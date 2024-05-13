1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
6 import {CollateralizedDebt} from '../CollateralizedDebt.sol';
7 library DeployCollateralizedDebt {
8     function deployCollateralizedDebt(
9         IConvenience.Native storage native,
10         bytes32 salt,
11         IConvenience convenience,
12         IPair pair,
13         uint256 maturity
14     ) external {
15         native.collateralizedDebt = new CollateralizedDebt{salt: salt}(convenience, pair, maturity);
16     }
17 }
