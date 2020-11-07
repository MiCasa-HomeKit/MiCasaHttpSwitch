<p align="center">
  <img src="https://raw.githubusercontent.com/MiCasa-HomeKit/MiCasaAssets/main/micasa-header.png"/><br/>
  <a href="https://opensource.org/licenses/Apache-2.0" target="_new">
    <img src="https://img.shields.io/github/license/MiCasa-HomeKit/MiCasaHttpSwitch"/>
  </a>
  <a href="https://travis-ci.org/github/MiCasa-HomeKit/MiCasaHttpSwitch/branches" target="_new">
      <img src="https://travis-ci.org/MiCasa-HomeKit/MiCasaHttpSwitch.svg?branch=main"/>
  </a>
  <a href="https://github.com/MiCasa-HomeKit/MiCasaHttpSwitch/issues">
    <img src="https://img.shields.io/github/issues/MiCasa-HomeKit/MiCasaHttpSwitch"/>
  </a>
</p>

This MiCasa plugin provides a switch, that can be toggled via HTTP.

## Configuration
Tho configure the plugin, the following objkect has to be added to the `plugins` array:
```json
{
    "plugin": "micasa-http-switch",
    "configuration": {
        "port": 18080,
        "switches": [
            {
                "id": "terrarium-light",
                "name": "Terrarium: Light",
                "serialNumber": "29084d67-e5f3-4b10-9db5-5d698fc1fb3f"
            }
        ]                
    }
}
```

### Toplevel properties
| Property                              | Description                                                                     |
|---------------------------------------|---------------------------------------------------------------------------------|
| `plugin`                              | Plugin name; must be 'micasa-http-switch'.                                      |
| `configuration`                       | Plugin configuration.                                                           |
| `configuration.port`                  | Port on which the web server is listening.                                      |
| `configuration.switches`              | Array with the switch configurations. Any number of switches can be configured. |
| `configuration.switches.id`           | Technical ID of the switch; must be unique.                                     |
| `configuration.switches.name`         | Display name that is passed to HomeKit.                                         |
| `configuration.switches.serialNumber` | Serial number that is passed to HomeKit                                         |

### REST endpoints
| URI                   | Description                              |
|-----------------------|------------------------------------------|
| `/switches/off`       | Turn all switches off.                   |
| `/switches/on`        | Turn all switches on.                    |
| `/switches/status`    | Get the status of all switches.          |
| `/switches/:id/off`   | Turn the switch with `:id` off.          |
| `/switches/:id/on`    | Turn the switch with `:id` on.           |
| `/switches/:id/status`| Get the status of the switch with `:id`. |
