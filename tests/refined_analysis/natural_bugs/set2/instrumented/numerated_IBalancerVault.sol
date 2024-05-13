1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 pragma abicoder v2;
4 
5 import "src/mainnet/interfaces/IAsset.sol";
6 
7 interface IBalancerVault {
8     
9     enum JoinKind {
10         INIT,
11         EXACT_TOKENS_IN_FOR_BPT_OUT,
12         TOKEN_IN_FOR_EXACT_BPT_OUT,
13         ALL_TOKENS_IN_FOR_EXACT_BPT_OUT
14     }
15 
16     enum ExitKind {
17         EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
18         EXACT_BPT_IN_FOR_TOKENS_OUT,
19         BPT_IN_FOR_EXACT_TOKENS_OUT,
20         MANAGEMENT_FEE_TOKENS_OUT
21     }
22 
23     enum SwapKind {
24         GIVEN_IN,
25         GIVEN_OUT
26     }
27 
28     struct SingleSwap {
29         bytes32 poolId;
30         SwapKind kind;
31         address assetIn;
32         address assetOut;
33         uint256 amount;
34         bytes userData;
35     }
36 
37     struct BatchSwapStep {
38         bytes32 poolId;
39         uint256 assetInIndex;
40         uint256 assetOutIndex;
41         uint256 amount;
42         bytes userData;
43     }
44 
45     struct FundManagement {
46         address sender;
47         bool fromInternalBalance;
48         address payable recipient;
49         bool toInternalBalance;
50     }
51 
52     struct JoinPoolRequest {
53         address[] assets;
54         uint256[] maxAmountsIn;
55         bytes userData;
56         bool fromInternalBalance;
57     }
58 
59     struct ExitPoolRequest{
60         address[] assets;
61         uint256[] minAmountsOut;
62         bytes userData;
63         bool toInternalBalance; 
64     }
65 
66     function getPoolTokens(bytes32 poolId) external view returns (address[] memory tokens, uint256[] memory balances, uint256 lastChangeBlock);
67 
68     function swap(SingleSwap memory singleSwap, FundManagement memory funds, uint256 limit, uint256 deadline) external payable returns (uint256 amountCalculated);
69 
70     function batchSwap(SwapKind kind, BatchSwapStep[] memory swaps, IAsset[] memory assets, FundManagement memory funds, int256[] memory limits, uint256 deadline) external payable returns (int256[] memory);
71 
72     function joinPool(bytes32 poolId, address sender, address recipient, JoinPoolRequest memory request) external payable;
73 
74     function exitPool(bytes32 poolId, address sender, address payable recipient, ExitPoolRequest memory request) external;
75 
76 }