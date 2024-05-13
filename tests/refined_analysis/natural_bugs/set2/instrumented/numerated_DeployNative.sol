1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {Deploy} from './Deploy.sol';
9 import {IDeployNatives} from '../interfaces/IDeployNatives.sol';
10 
11 library DeployNative {
12     using Deploy for IConvenience.Native;
13 
14     function deploy(
15         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
16         IConvenience convenience,
17         IFactory factory,
18         IDeployNatives.DeployNatives memory params
19     ) internal {
20         require(params.deadline >= block.timestamp, 'E504');
21 
22         IPair pair = factory.getPair(params.asset, params.collateral);
23         require(address(pair) != address(0), 'E501');
24 
25         IConvenience.Native storage native = natives[params.asset][params.collateral][params.maturity];
26         require(address(native.liquidity) == address(0), 'E503');
27 
28         native.deploy(convenience, pair, params.asset, params.collateral, params.maturity);
29     }
30 }
