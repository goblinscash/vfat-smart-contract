// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {NftSettingsRegistry} from "../src/NftSettingsRegistry.sol";
import {SickleFactory} from "../src/SickleFactory.sol";

contract NftSettingsRegistryScript is Script {
    SickleFactory public sickleFactory;
    NftSettingsRegistry public nftSettingsRegistry;

    address public sickleFactoryAddress = 0x52FFaccCBC6B6854Dd639D31b524CFe7485C8e67; 

    function run() public {
        vm.startBroadcast();
        sickleFactory = SickleFactory(sickleFactoryAddress);
        nftSettingsRegistry = new NftSettingsRegistry(sickleFactory);

        vm.stopBroadcast();
    }
}
