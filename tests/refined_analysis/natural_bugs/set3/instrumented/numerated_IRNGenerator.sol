1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IRNGenerator {
5     function getRandomNumber(uint _potId, uint256 userProvidedSeed) external returns(bytes32 requestId);
6 }