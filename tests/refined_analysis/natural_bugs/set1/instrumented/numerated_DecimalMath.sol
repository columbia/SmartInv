1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {SafeMath} from "./SafeMath.sol";
12 
13 
14 /**
15  * @title DecimalMath
16  * @author DODO Breeder
17  *
18  * @notice Functions for fixed point number with 18 decimals
19  */
20 library DecimalMath {
21     using SafeMath for uint256;
22 
23     uint256 constant ONE = 10**18;
24 
25     function mul(uint256 target, uint256 d) internal pure returns (uint256) {
26         return target.mul(d) / ONE;
27     }
28 
29     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
30         return target.mul(d).divCeil(ONE);
31     }
32 
33     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
34         return target.mul(ONE).div(d);
35     }
36 
37     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
38         return target.mul(ONE).divCeil(d);
39     }
40 }
