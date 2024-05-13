1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import {PotConstant} from "../library/PotConstant.sol";
6 
7 interface IBunnyPot {
8 
9     function potInfoOf(address _account) external view returns (PotConstant.PotInfo memory, PotConstant.PotInfoMe memory);
10 
11     function deposit(uint amount) external;
12     function withdrawAll(uint amount) external;
13 }