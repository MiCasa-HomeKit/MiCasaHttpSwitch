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

public class MiCasaHttpSwitchBuilder: MiCasaPluginBuilder<MiCasaHttpSwitch> {

    // MARK: - Initialization

    public override init() {
        super.init()
    }


    // MARK: - Plugin Properties

    /// The plugin id. The id must be unique and constant; it mustn't change.
    public override var pluginId: String {
        return "2fab528d-b609-4244-a6cf-59be2ff87295"
    }

    /// The plugin name. The plugin name must be unique and is a technical name.
    public override var pluginName: String {
        return "micasa-http-switch";
    }

    /// The plugin version.
    public override var pluginVersion: String {
        return "0.0.1"
    }


    // MARK: - Initialization

    /**
     This method must return an instance of the plugin.

     - Parameter apiGateway: The API that can be used by the plugin.

     - Returns: An instance of the plugin
     */
    public override func build(apiGateway: ApiGateway, configuration: [String:Any]) -> MiCasaHttpSwitch {
        return MiCasaHttpSwitch(apiGateway: apiGateway, configuration: configuration)
    }
}
