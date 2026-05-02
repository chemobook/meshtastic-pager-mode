#include "StatusLEDModule.h"
#include "MeshService.h"
#include "configuration.h"
#include "graphics/draw/MessageRenderer.h"
#include <Arduino.h>

/*
StatusLEDModule manages the device's status LEDs, updating their states based on power and Bluetooth status.
It reflects charging, charged, discharging, and Bluetooth connection states using the appropriate LEDs.
*/
StatusLEDModule *statusLEDModule;

StatusLEDModule::StatusLEDModule() : concurrency::OSThread("StatusLEDModule")
{
    bluetoothStatusObserver.observe(&bluetoothStatus->onNewStatus);
    powerStatusObserver.observe(&powerStatus->onNewStatus);
#if !MESHTASTIC_EXCLUDE_INPUTBROKER
    if (inputBroker)
        inputObserver.observe(inputBroker);
#endif
}

int StatusLEDModule::handleStatusUpdate(const meshtastic::Status *arg)
{
    switch (arg->getStatusType()) {
    case STATUS_TYPE_POWER: {
        if (powerStatus->getHasUSB() || powerStatus->getIsCharging()) {
            power_state = charging;
            if (powerStatus->getBatteryChargePercent() >= 100) {
                power_state = charged;
            }
        } else {
            if (powerStatus->getBatteryChargePercent() > 5) {
                power_state = discharging;
            } else {
                power_state = critical;
            }
        }
        break;
    }
    case STATUS_TYPE_BLUETOOTH: {
        switch (bluetoothStatus->getConnectionState()) {
        case meshtastic::BluetoothStatus::ConnectionState::DISCONNECTED: {
            ble_state = unpaired;
            PAIRING_LED_starttime = millis();
            break;
        }
        case meshtastic::BluetoothStatus::ConnectionState::PAIRING: {
            ble_state = pairing;
            PAIRING_LED_starttime = millis();
            break;
        }
        case meshtastic::BluetoothStatus::ConnectionState::CONNECTED: {
            if (ble_state != connected) {
                ble_state = connected;
                PAIRING_LED_starttime = millis();
            }
        }
        }

        break;
    }
    }
    return 0;
};
#if !MESHTASTIC_EXCLUDE_INPUTBROKER
int StatusLEDModule::handleInputEvent(const InputEvent *event)
{
    lastUserbuttonTime = millis();
    return 0;
}
#endif

int32_t StatusLEDModule::runOnce()
{
#ifdef MESHTASTIC_PAGER_OS
    /*
     * Pager OS: never fall through to the stock charge/BLE heartbeat — on USB power that path
     * forces CHARGE_LED ON (charging/charged) so the lamp looks stuck. Only pulse unread on GPIO
     * LED_POWER (e.g. Heltec V4 OLED white LED on pin 35). Do NOT drive the PMU charging LED or
     * RGB strands from this path — that is a separate hardware indicator the user reserved.
     */
    static bool unreadPulseOn = false;
    constexpr uint32_t unreadPulseWidthMs = 60;
    my_interval = 1000;
    PAIRING_LED_state = LED_STATE_OFF;
    CHARGE_LED_state = LED_STATE_OFF;

    if (graphics::MessageRenderer::hasUnreadMessages() && power_state == discharging) {
        const uint32_t cycleMs = graphics::MessageRenderer::unreadLedIntervalMs();
        if (!unreadPulseOn) {
            CHARGE_LED_state = LED_STATE_ON;
            unreadPulseOn = true;
            my_interval = unreadPulseWidthMs;
        } else {
            CHARGE_LED_state = LED_STATE_OFF;
            unreadPulseOn = false;
            my_interval = (cycleMs > unreadPulseWidthMs) ? (cycleMs - unreadPulseWidthMs) : cycleMs;
            if (my_interval == 0)
                my_interval = 250;
        }
    } else {
        unreadPulseOn = false;
    }

    if (config.device.led_heartbeat_disabled) {
        CHARGE_LED_state = LED_STATE_OFF;
    }
#ifdef PCA_LED_POWER
    io.digitalWrite(PCA_LED_POWER, CHARGE_LED_state);
#endif
#ifdef PCA_LED_ENABLE
    io.digitalWrite(PCA_LED_ENABLE, CHARGE_LED_state);
#endif
#ifdef LED_POWER
    digitalWrite(LED_POWER, CHARGE_LED_state);
#endif
#ifdef LED_PAIRING
    digitalWrite(LED_PAIRING, PAIRING_LED_state);
#endif

#ifdef RGB_LED_POWER
    ambientLightingThread->setLighting(0, 0, 0, 0); // pager: unread uses LED_POWER only
#endif

    return (my_interval);
#else // !MESHTASTIC_PAGER_OS
    my_interval = 1000;

    if (power_state == charging) {
#ifndef POWER_LED_HARDWARE_BLINKS_WHILE_CHARGING
        CHARGE_LED_state = !CHARGE_LED_state;
#endif
    } else if (power_state == charged) {
        CHARGE_LED_state = LED_STATE_ON;
    } else if (power_state == critical) {
        if (POWER_LED_starttime + 30000 < millis() && !doing_fast_blink) {
            doing_fast_blink = true;
            POWER_LED_starttime = millis();
        }
        if (doing_fast_blink) {
            PAIRING_LED_state = LED_STATE_OFF;
            CHARGE_LED_state = !CHARGE_LED_state;
            my_interval = 250;
            if (POWER_LED_starttime + 2000 < millis()) {
                doing_fast_blink = false;
                CHARGE_LED_state = LED_STATE_OFF;
            }
        }
    }

    if (power_state != charging && power_state != charged && !doing_fast_blink) {
        if (CHARGE_LED_state == LED_STATE_ON) {
            CHARGE_LED_state = LED_STATE_OFF;
            my_interval = 999;
        } else {
            CHARGE_LED_state = LED_STATE_ON;
            my_interval = 1;
        }
    }

    if (!config.bluetooth.enabled || PAIRING_LED_starttime + 30 * 1000 < millis() || doing_fast_blink) {
        PAIRING_LED_state = LED_STATE_OFF;
    } else if (ble_state == unpaired) {
        if (slowTrack) {
            PAIRING_LED_state = !PAIRING_LED_state;
            slowTrack = false;
        } else {
            slowTrack = true;
        }
    } else if (ble_state == pairing) {
        PAIRING_LED_state = !PAIRING_LED_state;
    } else {
        PAIRING_LED_state = LED_STATE_ON;
    }

    // Override if disabled in config
    if (config.device.led_heartbeat_disabled) {
        CHARGE_LED_state = LED_STATE_OFF;
    }
#ifdef Battery_LED_1
    bool chargeIndicatorLED1 = LED_STATE_OFF;
    bool chargeIndicatorLED2 = LED_STATE_OFF;
    bool chargeIndicatorLED3 = LED_STATE_OFF;
    bool chargeIndicatorLED4 = LED_STATE_OFF;
    if (lastUserbuttonTime + 10 * 1000 > millis() || CHARGE_LED_state == LED_STATE_ON) {
        // should this be off at very low percentages?
        chargeIndicatorLED1 = LED_STATE_ON;
        if (powerStatus && powerStatus->getBatteryChargePercent() >= 25)
            chargeIndicatorLED2 = LED_STATE_ON;
        if (powerStatus && powerStatus->getBatteryChargePercent() >= 50)
            chargeIndicatorLED3 = LED_STATE_ON;
        if (powerStatus && powerStatus->getBatteryChargePercent() >= 75)
            chargeIndicatorLED4 = LED_STATE_ON;
    }
#endif

#if defined(HAS_PMU)
    if (pmu_found && PMU) {
        // blink the axp led
        PMU->setChargingLedMode(CHARGE_LED_state ? XPOWERS_CHG_LED_ON : XPOWERS_CHG_LED_OFF);
    }
#endif

#ifdef PCA_LED_POWER
    io.digitalWrite(PCA_LED_POWER, CHARGE_LED_state);
#endif
#ifdef PCA_LED_ENABLE
    io.digitalWrite(PCA_LED_ENABLE, CHARGE_LED_state);
#endif
#ifdef LED_POWER
    digitalWrite(LED_POWER, CHARGE_LED_state);
#endif
#ifdef LED_PAIRING
    digitalWrite(LED_PAIRING, PAIRING_LED_state);
#endif

#ifdef RGB_LED_POWER
    if (!config.device.led_heartbeat_disabled) {
        if (CHARGE_LED_state == LED_STATE_ON) {
            ambientLightingThread->setLighting(10, 255, 0, 0);
        } else {
            ambientLightingThread->setLighting(0, 0, 0, 0);
        }
    }
#endif

#ifdef Battery_LED_1
    digitalWrite(Battery_LED_1, chargeIndicatorLED1);
#endif
#ifdef Battery_LED_2
    digitalWrite(Battery_LED_2, chargeIndicatorLED2);
#endif
#ifdef Battery_LED_3
    digitalWrite(Battery_LED_3, chargeIndicatorLED3);
#endif
#ifdef Battery_LED_4
    digitalWrite(Battery_LED_4, chargeIndicatorLED4);
#endif

    return (my_interval);
#endif // MESHTASTIC_PAGER_OS
}

void StatusLEDModule::setPowerLED(bool LEDon)
{
#ifdef MESHTASTIC_PAGER_OS
    /*
     * Pager / Heltec OLED: firmware only touches the notification LED on LED_POWER (e.g. GPIO 35).
     * Charging / status red on the PMU is left to hardware, like stock Meshtastic never repurposed it in UX.
     */
    const uint8_t ledState = LEDon ? LED_STATE_ON : LED_STATE_OFF;
#ifdef LED_POWER
    digitalWrite(LED_POWER, ledState);
#endif
#else
#if defined(HAS_PMU)
    if (pmu_found && PMU) {
        // blink the axp led
        PMU->setChargingLedMode(LEDon ? XPOWERS_CHG_LED_ON : XPOWERS_CHG_LED_OFF);
    }
#endif
    uint8_t ledState = LEDon ? LED_STATE_ON : LED_STATE_OFF;
#ifdef PCA_LED_POWER
    io.digitalWrite(PCA_LED_POWER, ledState);
#endif
#ifdef PCA_LED_ENABLE
    io.digitalWrite(PCA_LED_ENABLE, ledState);
#endif
#ifdef LED_POWER
    digitalWrite(LED_POWER, ledState);
#endif
#ifdef LED_PAIRING
    digitalWrite(LED_PAIRING, ledState);
#endif

#ifdef Battery_LED_1
    digitalWrite(Battery_LED_1, ledState);
#endif
#ifdef Battery_LED_2
    digitalWrite(Battery_LED_2, ledState);
#endif
#ifdef Battery_LED_3
    digitalWrite(Battery_LED_3, ledState);
#endif
#ifdef Battery_LED_4
    digitalWrite(Battery_LED_4, ledState);
#endif
#endif // MESHTASTIC_PAGER_OS
}
