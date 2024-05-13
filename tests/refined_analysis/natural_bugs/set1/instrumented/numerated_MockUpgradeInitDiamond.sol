1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 /**
9  * @author Publius
10  * @title Mock Upgrade Init Diamond
11 **/
12 contract MockUpgradeInitDiamond {
13     uint256 private _s;
14     function init() public {
15         _s = 1;
16     }
17 
18 }
