// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {NftSettingsRegistry} from "../src/NftSettingsRegistry.sol";
import {SickleFactory} from "../src/SickleFactory.sol";

contract NftSettingsRegistryScript is Script {
    SickleFactory public sickleFactory;
    NftSettingsRegistry public nftSettingsRegistry;

    address public sickleFactoryAddress = 0x62fB598f4a7379Ca36c2d031443F6c97B8F60C3f; 

    function run() public {
        vm.startBroadcast();
        sickleFactory = SickleFactory(sickleFactoryAddress);
        nftSettingsRegistry = new NftSettingsRegistry(sickleFactory);

        vm.stopBroadcast();
    }
}
