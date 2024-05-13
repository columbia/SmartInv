1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IPotController {
5     function numbersDrawn(uint potId, bytes32 requestId, uint256 randomness) external;
6 }
