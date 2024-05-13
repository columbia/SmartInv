1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from '../interfaces/IWETH.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {IBurn} from '../interfaces/IBurn.sol';
10 import {ETH} from './ETH.sol';
11 
12 library Burn {
13     function removeLiquidity(
14         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
15         IFactory factory,
16         IBurn.RemoveLiquidity calldata params
17     ) external returns (uint256 assetOut, uint128 collateralOut) {
18         (assetOut, collateralOut) = _removeLiquidity(
19             natives,
20             IBurn._RemoveLiquidity(
21                 factory,
22                 params.asset,
23                 params.collateral,
24                 params.maturity,
25                 params.assetTo,
26                 params.collateralTo,
27                 params.liquidityIn
28             )
29         );
30     }
31 
32     function removeLiquidityETHAsset(
33         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
34         IFactory factory,
35         IWETH weth,
36         IBurn.RemoveLiquidityETHAsset calldata params
37     ) external returns (uint256 assetOut, uint128 collateralOut) {
38         (assetOut, collateralOut) = _removeLiquidity(
39             natives,
40             IBurn._RemoveLiquidity(
41                 factory,
42                 weth,
43                 params.collateral,
44                 params.maturity,
45                 address(this),
46                 params.collateralTo,
47                 params.liquidityIn
48             )
49         );
50 
51         if (assetOut != 0) {
52             weth.withdraw(assetOut);
53             ETH.transfer(params.assetTo, assetOut);
54         }
55     }
56 
57     function removeLiquidityETHCollateral(
58         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
59         IFactory factory,
60         IWETH weth,
61         IBurn.RemoveLiquidityETHCollateral calldata params
62     ) external returns (uint256 assetOut, uint128 collateralOut) {
63         (assetOut, collateralOut) = _removeLiquidity(
64             natives,
65             IBurn._RemoveLiquidity(
66                 factory,
67                 params.asset,
68                 weth,
69                 params.maturity,
70                 params.assetTo,
71                 address(this),
72                 params.liquidityIn
73             )
74         );
75 
76         if (collateralOut != 0) {
77             weth.withdraw(collateralOut);
78             ETH.transfer(params.collateralTo, collateralOut);
79         }
80     }
81 
82     function _removeLiquidity(
83         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
84         IBurn._RemoveLiquidity memory params
85     ) private returns (uint256 assetOut, uint128 collateralOut) {
86         IPair pair = params.factory.getPair(params.asset, params.collateral);
87         require(address(pair) != address(0), 'E501');
88 
89         IConvenience.Native memory native = natives[params.asset][params.collateral][params.maturity];
90         require(address(native.liquidity) != address(0), 'E502');
91 
92         (assetOut, collateralOut) = pair.burn(
93             IPair.BurnParam(params.maturity, params.assetTo, params.collateralTo, params.liquidityIn)
94         );
95 
96         native.liquidity.burn(msg.sender, params.liquidityIn);
97     }
98 }
