1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ISynapseRouter {
5     /// @notice Struct representing a request for SynapseRouter.
6     /// @dev tokenIn is supplied separately.
7     /// @param swapAdapter Adapter address that will perform the swap.
8     ///                    Address(0) specifies a "no swap" query.
9     /// @param tokenOut Token address to swap to.
10     /// @param minAmountOut Minimum amount of tokens to receive after the swap,
11     ///                     or tx will be reverted.
12     /// @param deadline Latest timestamp for when the transaction needs to be executed,
13     ///                 or tx will be reverted.
14     /// @param rawParams ABI-encoded params for the swap that will be passed to `swapAdapter`.
15     ///                  Should be SynapseParams for swaps via SynapseAdapter.
16     struct SwapQuery {
17         address swapAdapter;
18         address tokenOut;
19         uint256 minAmountOut;
20         uint256 deadline;
21         bytes rawParams;
22     }
23 
24     /// @notice Struct representing a request for a swap quote from a bridge token.
25     /// @dev tokenOut is passed externally.
26     /// @param symbol Bridge token symbol: unique token ID consistent among all chains.
27     /// @param amountIn Amount of bridge token to start with, before the bridge fee is applied.
28     struct DestRequest {
29         string symbol;
30         uint256 amountIn;
31     }
32 
33     /// @notice Struct representing a bridge token.
34     ///         Used as the return value in view functions.
35     /// @param symbol Bridge token symbol: unique token ID consistent among all chains.
36     /// @param token Bridge token address.
37     struct BridgeToken {
38         string symbol;
39         address token;
40     }
41 
42     /// @notice Initiate a bridge transaction with an optional swap on both origin
43     ///         and destination chains.
44     /// @dev Note This method is payable.
45     ///      If token is ETH_ADDRESS, this method should be invoked with `msg.value = amountIn`.
46     ///      If token is ERC20, the tokens will be pulled from msg.sender (use `msg.value = 0`).
47     ///      Make sure to approve this contract for spending `token` beforehand.
48     ///      originQuery.tokenOut should never be ETH_ADDRESS, bridge only works with ERC20 tokens.
49     ///
50     ///      `token` is always a token user is sending.
51     ///      In case token requires a wrapper token to be bridge,
52     ///      use underlying address for `token` instead of the wrapper one.
53     ///
54     ///      `originQuery` contains instructions for the swap on origin chain.
55     ///      As above, originQuery.tokenOut should always use the underlying address.
56     ///      In other words, the concept of wrapper token is fully abstracted away from the end user.
57     ///
58     ///      `originQuery` is supposed to be fetched using SynapseRouter.getOriginAmountOut().
59     ///      Alternatively one could use an external adapter for more complex swaps on the origin chain.
60     ///
61     ///      `destQuery` is supposed to be fetched using SynapseRouter.getDestinationAmountOut().
62     ///      Complex swaps on destination chain are not supported for the time being.
63     ///      Check contract description above for more details.
64     /// @param to Address to receive tokens on destination chain.
65     /// @param chainId Destination chain id.
66     /// @param token Initial token for the bridge transaction to be pulled from the user.
67     /// @param amount Amount of the initial tokens for the bridge transaction.
68     /// @param originQuery Origin swap query. Empty struct indicates no swap is required.
69     /// @param destQuery Destination swap query. Empty struct indicates no swap is required.
70     function bridge(
71         address to,
72         uint256 chainId,
73         address token,
74         uint256 amount,
75         SwapQuery memory originQuery,
76         SwapQuery memory destQuery
77     ) external payable;
78 
79     /// @notice Finds the best path between `tokenIn` and every supported bridge token
80     ///         from the given list, treating the swap as "origin swap",
81     ///         without putting any restrictions on the swap.
82     /// @dev Will NOT revert if any of the tokens are not supported,
83     ///      instead will return an empty query for that symbol.
84     ///      Check (query.minAmountOut != 0): this is true only if the swap is possible
85     ///      and bridge token is supported.
86     ///      The returned queries with minAmountOut != 0 could be used as `originQuery`
87     ///      with SynapseRouter.
88     /// Note: It is possible to form a SwapQuery off-chain using alternative SwapAdapter
89     ///       for the origin swap.
90     /// @param tokenIn Initial token that user wants to bridge/swap.
91     /// @param tokenSymbols List of symbols representing bridge tokens.
92     /// @param amountIn Amount of tokens user wants to bridge/swap.
93     /// @return originQueries List of structs that could be used as `originQuery` in SynapseRouter.
94     ///                       minAmountOut and deadline fields will need to be adjusted
95     ///                       based on the user settings.
96     function getOriginAmountOut(
97         address tokenIn,
98         string[] memory tokenSymbols,
99         uint256 amountIn
100     ) external view returns (SwapQuery[] memory originQueries);
101 
102     /// @notice Finds the best path between every supported bridge token from
103     ///         the given list and `tokenOut`, treating the swap as "destination swap",
104     ///         limiting possible actions to those available for every bridge token.
105     /// @dev Will NOT revert if any of the tokens are not supported,
106     ///      instead will return an empty query for that symbol.
107     /// Note: It is NOT possible to form a SwapQuery off-chain using alternative SwapAdapter
108     ///       for the destination swap.
109     ///       For the time being, only swaps through the Synapse-supported pools
110     ///       are available on destination chain.
111     /// @param requests List of structs with following information:
112     ///                 - symbol: unique token ID consistent among all chains.
113     ///                 - amountIn: amount of bridge token to start with,
114     ///                              before the bridge fee is applied.
115     /// @param tokenOut Token user wants to receive on destination chain.
116     /// @return destQueries List of structs that could be used as `destQuery` in SynapseRouter.
117     ///                     minAmountOut and deadline fields will need to be adjusted based
118     ///                     on the user settings.
119     function getDestinationAmountOut(
120         DestRequest[] memory requests,
121         address tokenOut
122     ) external view returns (SwapQuery[] memory destQueries);
123 
124     /// @notice Gets the list of all bridge tokens (and their symbols),
125     ///         such that destination swap from a bridge token to `tokenOut` is possible.
126     /// @param tokenOut Token address to swap to on destination chain
127     /// @return tokens List of structs with following information:
128     ///                - symbol: unique token ID consistent among all chains
129     ///                - token: bridge token address
130     function getConnectedBridgeTokens(
131         address tokenOut
132     ) external view returns (BridgeToken[] memory tokens);
133 }
