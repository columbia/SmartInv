1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts-upgradeable-8/token/ERC20/IERC20Upgradeable.sol";
6 
7 enum ConvertKind {
8     BEANS_TO_CURVE_LP,
9     CURVE_LP_TO_BEANS,
10     UNRIPE_BEANS_TO_UNRIPE_LP,
11     UNRIPE_LP_TO_UNRIPE_BEANS,
12     LAMBDA_LAMBDA
13 }
14 
15 enum From {
16     EXTERNAL,
17     INTERNAL,
18     EXTERNAL_INTERNAL,
19     INTERNAL_TOLERANT
20 }
21 enum To {
22     EXTERNAL,
23     INTERNAL
24 }
25 
26 interface IBeanstalk {
27     function balanceOfSeeds(address account) external view returns (uint256);
28 
29     function balanceOfStalk(address account) external view returns (uint256);
30 
31     function transferDeposits(
32         address sender,
33         address recipient,
34         address token,
35         uint32[] calldata seasons,
36         uint256[] calldata amounts
37     ) external payable returns (uint256[] memory bdvs);
38 
39     function permitDeposit(
40         address owner,
41         address spender,
42         address token,
43         uint256 value,
44         uint256 deadline,
45         uint8 v,
46         bytes32 r,
47         bytes32 s
48     ) external payable;
49 
50     function permitDeposits(
51         address owner,
52         address spender,
53         address[] calldata tokens,
54         uint256[] calldata values,
55         uint256 deadline,
56         uint8 v,
57         bytes32 r,
58         bytes32 s
59     ) external payable;
60 
61     function plant() external payable returns (uint256);
62 
63     function update(address account) external payable;
64 
65     function transferInternalTokenFrom(
66         IERC20Upgradeable token,
67         address from,
68         address to,
69         uint256 amount,
70         To toMode
71     ) external payable;
72 
73     function transferToken(
74         IERC20Upgradeable token,
75         address recipient,
76         uint256 amount,
77         From fromMode,
78         To toMode
79     ) external payable;
80 
81     function permitToken(
82         address owner,
83         address spender,
84         address token,
85         uint256 value,
86         uint256 deadline,
87         uint8 v,
88         bytes32 r,
89         bytes32 s
90     ) external payable;
91 
92     function convert(
93         bytes calldata convertData,
94         uint32[] memory crates,
95         uint256[] memory amounts
96     ) external payable returns (uint32 toSeason, uint256 fromAmount, uint256 toAmount, uint256 fromBdv, uint256 toBdv);
97 
98     function getDeposit(
99         address account,
100         address token,
101         uint32 season
102     ) external view returns (uint256, uint256);
103 }
