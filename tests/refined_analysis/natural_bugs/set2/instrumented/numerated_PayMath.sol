1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
5 import {IDue} from '../interfaces/IDue.sol';
6 import {SafeCast} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/SafeCast.sol';
7 
8 library PayMath {
9     using SafeCast for uint256;
10 
11     function givenMaxAssetsIn(
12         IPair pair,
13         uint256 maturity,
14         IDue collateralizedDebt,
15         uint256[] memory ids,
16         uint112[] memory maxAssetsIn
17     ) internal view returns (uint112[] memory assetsIn, uint112[] memory collateralsOut) {
18         uint256 length = ids.length;
19 
20         assetsIn = maxAssetsIn;
21         collateralsOut = new uint112[](length);
22 
23         for (uint256 i; i < length; ) {
24             IPair.Due memory due = pair.dueOf(maturity, address(this), ids[i]);
25 
26             if (assetsIn[i] > due.debt) assetsIn[i] = due.debt;
27             if (msg.sender == collateralizedDebt.ownerOf(ids[i])) {
28                 uint256 _collateralOut = due.collateral;
29                 if (due.debt != 0) {
30                     _collateralOut *= assetsIn[i];
31                     _collateralOut /= due.debt;
32                 }
33                 collateralsOut[i] = _collateralOut.toUint112();
34             }
35 
36             unchecked {
37                 ++i;
38             }
39         }
40     }
41 }
