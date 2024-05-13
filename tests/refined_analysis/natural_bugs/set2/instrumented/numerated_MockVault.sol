1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "./MockWeightedPool.sol";
7 
8 contract MockVault {
9     using SafeERC20 for IERC20;
10 
11     MockWeightedPool public _pool;
12     IERC20[] public _tokens;
13     uint256[] public _balances;
14     uint256 public constant LIQUIDITY_AMOUNT = 1e18;
15     bool public mockDoTransfers = false;
16     bool public mockBalancesSet = false;
17 
18     constructor(IERC20[] memory tokens, address owner) {
19         _tokens = tokens;
20         _pool = new MockWeightedPool(MockVault(address(this)), owner);
21 
22         uint256[] memory weights = new uint256[](tokens.length);
23         uint256 weight = 1e18 / tokens.length;
24         for (uint256 i = 0; i < weights.length; i++) {
25             weights[i] = weight;
26         }
27         _pool.mockSetNormalizedWeights(weights);
28     }
29 
30     function setMockDoTransfers(bool flag) external {
31         mockDoTransfers = flag;
32     }
33 
34     enum PoolSpecialization {
35         GENERAL,
36         MINIMAL_SWAP_INFO,
37         TWO_TOKEN
38     }
39 
40     function getPool(
41         bytes32 /* poolId*/
42     ) external view returns (address poolAddress, PoolSpecialization poolSpec) {
43         poolAddress = address(_pool);
44         poolSpec = PoolSpecialization.TWO_TOKEN;
45     }
46 
47     function getPoolTokens(
48         bytes32 /* poolId*/
49     )
50         external
51         view
52         returns (
53             IERC20[] memory tokens,
54             uint256[] memory balances,
55             uint256 lastChangeBlock
56         )
57     {
58         if (mockBalancesSet) {
59             balances = _balances;
60         } else {
61             balances = new uint256[](_tokens.length);
62             for (uint256 i = 0; i < _tokens.length; i++) {
63                 balances[i] = _tokens[i].balanceOf(address(_pool));
64             }
65         }
66         return (_tokens, balances, lastChangeBlock);
67     }
68 
69     function setBalances(uint256[] memory balances) external {
70         _balances = balances;
71         mockBalancesSet = true;
72     }
73 
74     function joinPool(
75         bytes32, /* poolId*/
76         address, /* sender*/
77         address recipient,
78         JoinPoolRequest memory request
79     ) external payable {
80         if (mockDoTransfers) {
81             for (uint256 i = 0; i < _tokens.length; i++) {
82                 _tokens[i].safeTransferFrom(msg.sender, address(_pool), request.maxAmountsIn[i]);
83             }
84         }
85         _pool.mint(recipient, LIQUIDITY_AMOUNT);
86     }
87 
88     struct JoinPoolRequest {
89         IAsset[] assets;
90         uint256[] maxAmountsIn;
91         bytes userData;
92         bool fromInternalBalance;
93     }
94 
95     function exitPool(
96         bytes32, /* poolId*/
97         address sender,
98         address payable recipient,
99         ExitPoolRequest memory request
100     ) external {
101         _pool.mockBurn(sender, LIQUIDITY_AMOUNT);
102         if (mockDoTransfers) {
103             _pool.mockInitApprovals();
104             if (request.minAmountsOut[0] == 0 && request.minAmountsOut[1] == 0) {
105                 // transfer all
106                 for (uint256 i = 0; i < _tokens.length; i++) {
107                     _tokens[i].safeTransferFrom(address(_pool), recipient, _tokens[i].balanceOf(address(_pool)));
108                 }
109             } else {
110                 for (uint256 i = 0; i < _tokens.length; i++) {
111                     _tokens[i].safeTransferFrom(address(_pool), recipient, request.minAmountsOut[i]);
112                 }
113             }
114         }
115     }
116 
117     struct ExitPoolRequest {
118         IAsset[] assets;
119         uint256[] minAmountsOut;
120         bytes userData;
121         bool toInternalBalance;
122     }
123 }
