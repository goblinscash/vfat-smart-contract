// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Script, console } from "forge-std/Script.sol";
import { SickleFactory } from "../src/SickleFactory.sol";
import { SickleRegistry } from "../src/SickleRegistry.sol";
import { Sickle } from "../src/Sickle.sol";

contract SickleFactoryScript is Script {
    SickleFactory public _sickleFactory;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address sickleRegistryAddr = 0xF1Cf2598d89215d15578813aBc04698BB55b8E3F;
        
        address sickleImplementationAddr = 0x72a72C80fe211bEaBce5516974fffa2c9aECBb3D;

        address previousFactoryAddr = 0x0000000000000000000000000000000000000000;

        _sickleFactory = new SickleFactory(
            msg.sender,                   // Admin address (owner of the factory)
            sickleRegistryAddr,            
            sickleImplementationAddr,  
            previousFactoryAddr          // Previous SickleFactory address (or 0x0)
        );

        vm.stopBroadcast();
    }
}
