1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from '../interfaces/IWETH.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {IWithdraw} from '../interfaces/IWithdraw.sol';
10 import {ETH} from './ETH.sol';
11 
12 library Withdraw {
13     function collect(
14         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
15         IFactory factory,
16         IWithdraw.Collect calldata params
17     ) external returns (IPair.Tokens memory tokensOut) {
18         tokensOut = _collect(
19             natives,
20             IWithdraw._Collect(
21                 factory,
22                 params.asset,
23                 params.collateral,
24                 params.maturity,
25                 params.assetTo,
26                 params.collateralTo,
27                 params.claimsIn
28             )
29         );
30     }
31 
32     function collectETHAsset(
33         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
34         IFactory factory,
35         IWETH weth,
36         IWithdraw.CollectETHAsset calldata params
37     ) external returns (IPair.Tokens memory tokensOut) {
38         tokensOut = _collect(
39             natives,
40             IWithdraw._Collect(
41                 factory,
42                 weth,
43                 params.collateral,
44                 params.maturity,
45                 address(this),
46                 params.collateralTo,
47                 params.claimsIn
48             )
49         );
50 
51         if (tokensOut.asset != 0) {
52             weth.withdraw(tokensOut.asset);
53             ETH.transfer(params.assetTo, tokensOut.asset);
54         }
55     }
56 
57     function collectETHCollateral(
58         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
59         IFactory factory,
60         IWETH weth,
61         IWithdraw.CollectETHCollateral calldata params
62     ) external returns (IPair.Tokens memory tokensOut) {
63         tokensOut = _collect(
64             natives,
65             IWithdraw._Collect(
66                 factory,
67                 params.asset,
68                 weth,
69                 params.maturity,
70                 params.assetTo,
71                 address(this),
72                 params.claimsIn
73             )
74         );
75 
76         if (tokensOut.collateral != 0) {
77             weth.withdraw(tokensOut.collateral);
78             ETH.transfer(params.collateralTo, tokensOut.collateral);
79         }
80     }
81 
82     function _collect(
83         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
84         IWithdraw._Collect memory params
85     ) private returns (IPair.Tokens memory tokensOut) {
86         IPair pair = params.factory.getPair(params.asset, params.collateral);
87         require(address(pair) != address(0), 'E501');
88 
89         IConvenience.Native memory native = natives[params.asset][params.collateral][params.maturity];
90         require(address(native.liquidity) != address(0), 'E502');
91 
92         tokensOut = pair.withdraw(
93             IPair.WithdrawParam(params.maturity, params.assetTo, params.collateralTo, params.claimsIn)
94         );
95 
96         if (params.claimsIn.bondInterest != 0) native.bondInterest.burn(msg.sender, params.claimsIn.bondInterest);
97         if (params.claimsIn.bondPrincipal != 0) native.bondPrincipal.burn(msg.sender, params.claimsIn.bondPrincipal);
98         if (params.claimsIn.insuranceInterest != 0)
99             native.insuranceInterest.burn(msg.sender, params.claimsIn.insuranceInterest);
100         if (params.claimsIn.insurancePrincipal != 0)
101             native.insurancePrincipal.burn(msg.sender, params.claimsIn.insurancePrincipal);
102     }
103 }
