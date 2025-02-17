// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Sickle} from "../src/Sickle.sol";
import {SickleRegistry} from "../src/SickleRegistry.sol";

contract SickleScript is Script {
    Sickle public _sickle;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address sickleRegistryAddr = 0xF1Cf2598d89215d15578813aBc04698BB55b8E3F;

        SickleRegistry sickleRegistry = SickleRegistry(sickleRegistryAddr);
        
        _sickle = new Sickle(sickleRegistry);

        vm.stopBroadcast();
    }
}
