// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ZapIn, ZapOut } from "../../structs/ZapStructs.sol";

interface IZapLib {
    function zapIn(
        ZapIn memory zap
    ) external payable;

    function zapOut(
        ZapOut memory zap
    ) external;
}
