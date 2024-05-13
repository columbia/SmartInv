1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "contracts/tokens/Fertilizer/Fertilizer.sol";
9 
10 /**
11  * @author Publius
12  * @title MockFertilizer is a Mock version of Fertilizer
13 **/
14 contract MockFertilizer is Fertilizer  {
15 
16     function initialize() public initializer {
17         __Internallize_init("");
18     }
19 
20 }
