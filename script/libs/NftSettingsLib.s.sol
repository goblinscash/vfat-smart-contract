// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NftSettingsLib} from "../../src/libraries/NftSettingsLib.sol";

contract NftSettingsLibScript is Script {
    NftSettingsLib public _nftSettingsLib;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        _nftSettingsLib = new NftSettingsLib();

        vm.stopBroadcast();
    }
}
