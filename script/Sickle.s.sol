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

        address sickleRegistryAddr = 0xFd8E0705EdCc01A142ed0a8e76F036e38B72Bcc3;

        SickleRegistry sickleRegistry = SickleRegistry(sickleRegistryAddr);
        
        _sickle = new Sickle(sickleRegistry);

        vm.stopBroadcast();
    }
}
