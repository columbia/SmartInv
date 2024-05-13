1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
6 import {Liquidity} from '../Liquidity.sol';
7 
8 library DeployLiquidity {
9     function deployLiquidity(
10         IConvenience.Native storage native,
11         bytes32 salt,
12         IConvenience convenience,
13         IPair pair,
14         uint256 maturity
15     ) external {
16         native.liquidity = new Liquidity{salt: salt}(convenience, pair, maturity);
17     }
18 }
