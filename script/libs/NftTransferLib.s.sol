// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NftTransferLib} from "../../src/libraries/NftTransferLib.sol";

contract NftTransferLibScript is Script {
    NftTransferLib public _nftTransfer;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        _nftTransfer = new NftTransferLib();

        vm.stopBroadcast();
    }
}
