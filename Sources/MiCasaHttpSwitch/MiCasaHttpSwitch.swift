/*
 Copyright 2020 MiCasa Development Team

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import MiCasaPlugin
import HAP
import Swifter

struct SwitchStatus: Codable {
    var id: String
    var powerState: Bool
}

public class MiCasaHttpSwitch: MiCasaPlugin {

    // MARK: - Private Properties

    private let serialNumber = "fff4a4ae-8500-4548-b3a9-8fe5b105349c"
    private var config: HttpSwitchConfiguration!
    private var switches: [String:Accessory] = [:]
    private let server = HttpServer()
    //private let router = server.routes

    // MARK: - Initialize

    public override init(apiGateway gateway: ApiGateway, configuration: Data) {
        super.init(apiGateway: gateway, configuration: configuration)

        do {
            let decoder = JSONDecoder()

            decoder.keyDecodingStrategy = .convertFromSnakeCase
            config = try decoder.decode(HttpSwitchConfiguration.self, from: configuration)

            server.POST["/switches/:id/on"] = self.turnSwitchOn(request:)
            server.POST["/switches/:id/off"] = self.turnSwitchOff(request:)
            server.GET["/switches/:id/status"] = self.switchStatus(request:)
            server.POST["/switches/on"] = self.turnSwitchesOn(request:)
            server.POST["/switches/off"] = self.turnSwitchesOff(request:)
            server.GET["/switches/status"] = self.switchesStatus(request:)
        } catch {
            print(error)
        }
    }

    // MARK: - Hashable

    public static func == (lhs: MiCasaHttpSwitch, rhs: MiCasaHttpSwitch) -> Bool {
        return lhs.serialNumber == rhs.serialNumber
    }

    public override var hashValue: Int {
        return serialNumber.hashValue
    }

    public override func hash(into hasher: inout Hasher) {
        hasher.combine(serialNumber)
    }


    // MARK: - Plugin API

    public override func accessories() -> [Accessory] {
        if switches.count == 0 {
            config
                .switches
                .forEach { sw in
                    switches[sw.id] =
                        Accessory
                            .Switch(
                                info:
                                    .init(
                                        name: sw.name,
                                        serialNumber: sw.serialNumber,
                                        manufacturer: "MiCasa Development Team",
                                        model: "MiCasa HTTP Switch",
                                        firmwareRevision: "0.0.1"))
                }
        }

        return Array(switches.values)
    }

    public override func identify(accessory: Accessory) {
        super.identify(accessory: accessory)
    }

    public override func characteristic<T>(
        _ characteristic: GenericCharacteristic<T>,
        ofService service: Service,
        ofAccessory accessory: Accessory,
        didChangeValue newValue: T?) {

        super
            .characteristic(
                characteristic,
                ofService: service,
                ofAccessory: accessory,
                didChangeValue: newValue)
    }


    // MARK: - API

    /// This method starts the plugin.
    public override func start() {
        try? server.start(in_port_t(config.port))
    }

    /// This method stops the plugin.
    ///
    /// The method is called before the bridge stops or is about to restart.
    public override func stop() {
        server.stop()
    }


    // MARK: - HTTP Handlers

    private func turnSwitchOn(request: HttpRequest) -> HttpResponse {
        guard let id = request.params[":id"] else {
            return HttpResponse.badRequest(.text("Switch ID must be given"))
        }

        if let sw = switches[id] as? Accessory.Switch {
            sw.switch.powerState.value = true

            /*sw.characteristic(
                sw.switch.powerState,
                ofService: sw.switch,
                didChangeValue: true)*/

            return HttpResponse.accepted
        }

        return HttpResponse.notFound
    }

    private func turnSwitchOff(request: HttpRequest) -> HttpResponse {
        guard let id = request.params[":id"] else {
            return HttpResponse.badRequest(.text("Switch ID must be given"))
        }

        if let sw = switches[id] as? Accessory.Switch {
            sw.switch.powerState.value = false
            /*sw.characteristic(
                sw.switch.powerState,
                ofService: sw.switch,
                didChangeValue: false)*/

            return HttpResponse.accepted
        }

        return HttpResponse.notFound
    }

    private func switchStatus(request: HttpRequest) -> HttpResponse {
        guard let id = request.params[":id"] else {
            return HttpResponse.badRequest(.text("Switch ID must be given"))
        }

        if let sw = switches[id] as? Accessory.Switch {
            guard let response =
                try? JSONEncoder()
                    .encode(
                        SwitchStatus(id: id, powerState: sw.switch.powerState.value!)) else {

                return HttpResponse.internalServerError
            }

            return HttpResponse.ok(.data(response, contentType: "application/json"))
        }

        return HttpResponse.notFound
    }

    private func turnSwitchesOn(request: HttpRequest) -> HttpResponse {
        Array(switches.values)
            .forEach { sw in
                let `switch` = sw as! Accessory.Switch

                `switch`.switch.powerState.value = true
                /*`switch`.characteristic(
                    `switch`.switch.powerState,
                    ofService: `switch`.switch,
                    didChangeValue: true)*/
            }

        return HttpResponse.accepted
    }

    private func turnSwitchesOff(request: HttpRequest) -> HttpResponse {
        Array(switches.values)
            .forEach { sw in
                let `switch` = sw as! Accessory.Switch

                `switch`.switch.powerState.value = false
                /*`switch`.characteristic(
                    `switch`.switch.powerState,
                    ofService: `switch`.switch,
                    didChangeValue: false)*/
            }

        return HttpResponse.accepted
    }

    private func switchesStatus(request: HttpRequest) -> HttpResponse {
        guard let response =
                try? JSONEncoder()
                .encode(
                    Array(switches.keys)
                        .map { id -> SwitchStatus in
                            let sw = switches[id] as! Accessory.Switch

                            return SwitchStatus(id: id, powerState: sw.switch.powerState.value!)
                        }) else {

            return HttpResponse.internalServerError
        }

        return HttpResponse.ok(.data(response, contentType: "application/json"))
    }
}
