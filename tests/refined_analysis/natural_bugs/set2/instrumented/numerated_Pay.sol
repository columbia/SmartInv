1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from '../interfaces/IWETH.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {IPay} from '../interfaces/IPay.sol';
10 import {IDue} from '../interfaces/IDue.sol';
11 import {PayMath} from './PayMath.sol';
12 import {MsgValue} from './MsgValue.sol';
13 import {ETH} from './ETH.sol';
14 
15 library Pay {
16     using PayMath for IPair;
17 
18     function pay(
19         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
20         IFactory factory,
21         IPay.Repay memory params
22     ) external returns (uint128 assetIn, uint128 collateralOut) {
23         (assetIn, collateralOut) = _pay(
24             natives,
25             IPay._Repay(
26                 factory,
27                 params.asset,
28                 params.collateral,
29                 params.maturity,
30                 msg.sender,
31                 params.collateralTo,
32                 params.ids,
33                 params.maxAssetsIn,
34                 params.deadline
35             )
36         );
37     }
38 
39     function payETHAsset(
40         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
41         IFactory factory,
42         IWETH weth,
43         IPay.RepayETHAsset memory params
44     ) external returns (uint128 assetIn, uint128 collateralOut) {
45         uint128 maxAssetIn = MsgValue.getUint112();
46 
47         (assetIn, collateralOut) = _pay(
48             natives,
49             IPay._Repay(
50                 factory,
51                 weth,
52                 params.collateral,
53                 params.maturity,
54                 address(this),
55                 params.collateralTo,
56                 params.ids,
57                 params.maxAssetsIn,
58                 params.deadline
59             )
60         );
61 
62         if (maxAssetIn > assetIn) {
63             uint256 excess = maxAssetIn;
64             unchecked {
65                 excess -= assetIn;
66             }
67             ETH.transfer(payable(msg.sender), excess);
68         }
69     }
70 
71     function payETHCollateral(
72         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
73         IFactory factory,
74         IWETH weth,
75         IPay.RepayETHCollateral memory params
76     ) external returns (uint128 assetIn, uint128 collateralOut) {
77         (assetIn, collateralOut) = _pay(
78             natives,
79             IPay._Repay(
80                 factory,
81                 params.asset,
82                 weth,
83                 params.maturity,
84                 msg.sender,
85                 address(this),
86                 params.ids,
87                 params.maxAssetsIn,
88                 params.deadline
89             )
90         );
91 
92         if (collateralOut != 0) {
93             weth.withdraw(collateralOut);
94             ETH.transfer(params.collateralTo, collateralOut);
95         }
96     }
97 
98     function _pay(
99         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
100         IPay._Repay memory params
101     ) private returns (uint128 assetIn, uint128 collateralOut) {
102         require(params.deadline >= block.timestamp, 'E504');
103         require(params.maturity > block.timestamp, 'E508');
104         require(params.ids.length == params.maxAssetsIn.length, '520');
105 
106         IPair pair = params.factory.getPair(params.asset, params.collateral);
107         require(address(pair) != address(0), 'E501');
108 
109         IDue collateralizedDebt = natives[params.asset][params.collateral][params.maturity].collateralizedDebt;
110         require(address(collateralizedDebt) != address(0), 'E502');
111 
112         (uint112[] memory assetsIn, uint112[] memory collateralsOut) = pair.givenMaxAssetsIn(
113             params.maturity,
114             collateralizedDebt,
115             params.ids,
116             params.maxAssetsIn
117         );
118 
119         (assetIn, collateralOut) = pair.pay(
120             IPair.PayParam(
121                 params.maturity,
122                 params.collateralTo,
123                 address(this),
124                 params.ids,
125                 assetsIn,
126                 collateralsOut,
127                 bytes(abi.encode(params.asset, params.collateral, params.from, params.maturity))
128             )
129         );
130     }
131 }
