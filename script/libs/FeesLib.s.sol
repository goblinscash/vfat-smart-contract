// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FeesLib} from "../../src/libraries/FeesLib.sol";
import {SickleRegistry} from "../../src/SickleRegistry.sol";
import {WETH} from "solmate/tokens/WETH.sol";

contract FeesLibScript is Script {
    FeesLib public _feesLib;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address sickleRegistry = 0x2c2fC8A1CDa7d853a214e294ea40De03d9fC1d2D; 
        address payable weth = payable(0x4200000000000000000000000000000000000006);

        _feesLib = new FeesLib(SickleRegistry(sickleRegistry), WETH(weth));

        vm.stopBroadcast();
    }
}
