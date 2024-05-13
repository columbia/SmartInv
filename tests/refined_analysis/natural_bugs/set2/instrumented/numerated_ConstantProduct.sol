1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
5 
6 library ConstantProduct {
7     struct CP {
8         uint112 x;
9         uint112 y;
10         uint112 z;
11     }
12 
13     function get(IPair pair, uint256 maturity) internal view returns (CP memory cp) {
14         (uint112 x, uint112 y, uint112 z) = pair.constantProduct(maturity);
15         cp = CP(x, y, z);
16     }
17 }
