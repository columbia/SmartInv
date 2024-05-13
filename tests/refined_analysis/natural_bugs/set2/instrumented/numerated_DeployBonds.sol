1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
6 import {BondInterest} from '../BondInterest.sol';
7 import {BondPrincipal} from '../BondPrincipal.sol';
8 
9 library DeployBonds {
10     function deployBonds(
11         IConvenience.Native storage native,
12         bytes32 salt,
13         IConvenience convenience,
14         IPair pair,
15         uint256 maturity
16     ) external {
17         native.bondInterest = new BondInterest{salt: salt}(convenience, pair, maturity);
18         native.bondPrincipal = new BondPrincipal{salt: salt}(convenience, pair, maturity);
19     }
20 }
