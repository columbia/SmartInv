1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./SwapHandlerBase.sol";
6 import "../vendor/ISwapRouterV3.sol";
7 import "../vendor/ISwapRouterV2.sol";
8 
9 /// @notice Base contract for swap handlers which execute a secondary swap on Uniswap V2 or V3 for exact output
10 abstract contract SwapHandlerCombinedBase is SwapHandlerBase {
11     address immutable public uniSwapRouterV2;
12     address immutable public uniSwapRouterV3;
13 
14     constructor(address uniSwapRouterV2_, address uniSwapRouterV3_) {
15         uniSwapRouterV2 = uniSwapRouterV2_;
16         uniSwapRouterV3 = uniSwapRouterV3_;
17     }
18 
19     function executeSwap(SwapParams memory params) external override {
20         require(params.mode <= 1, "SwapHandlerCombinedBase: invalid mode");
21 
22         if (params.mode == 0) {
23             swapPrimary(params);
24         } else {
25             // For exact output expect a payload for the primary swap provider and a path to swap the remainder on Uni2 or Uni3
26             bytes memory path;
27             (params.payload, path) = abi.decode(params.payload, (bytes, bytes));
28 
29             uint primaryAmountOut = swapPrimary(params);
30 
31             if (primaryAmountOut < params.amountOut) {
32                 // The path param is reused for UniV2 and UniV3 swaps. The protocol to use is determined by the path length.
33                 // The length of valid UniV2 paths is given as n * 20, for n > 1, and the shortes path is 40 bytes.
34                 // The length of valid UniV3 paths is given as 20 + n * 23 for n > 0, because of an additional 3 bytes for the pool fee.
35                 // The max path length must be lower than the first path length which is valid for both protocols (and is therefore ambiguous)
36                 // This value is at 20 UniV3 hops, which corresponds to 24 UniV2 hops.
37                 require(path.length >= 40 && path.length < 20 + (20 * 23), "SwapHandlerPayloadBase: secondary path format");
38 
39                 uint remainder;
40                 unchecked { remainder = params.amountOut - primaryAmountOut; }
41 
42                 swapExactOutDirect(params, remainder, path);
43             }
44         }
45 
46         transferBack(params.underlyingIn);
47     }
48 
49     function swapPrimary(SwapParams memory params) internal virtual returns (uint amountOut);
50 
51     function swapExactOutDirect(SwapParams memory params, uint amountOut, bytes memory path) private {
52         (bool isUniV2, address[] memory uniV2Path) = detectAndDecodeUniV2Path(path);
53 
54         if (isUniV2) {
55             setMaxAllowance(params.underlyingIn, params.amountIn, uniSwapRouterV2);
56 
57             ISwapRouterV2(uniSwapRouterV2).swapTokensForExactTokens(amountOut, type(uint).max, uniV2Path, msg.sender, block.timestamp);
58         } else {
59             setMaxAllowance(params.underlyingIn, params.amountIn, uniSwapRouterV3);
60 
61             ISwapRouterV3(uniSwapRouterV3).exactOutput(
62                 ISwapRouterV3.ExactOutputParams({
63                     path: path,
64                     recipient: msg.sender,
65                     amountOut: amountOut,
66                     amountInMaximum: type(uint).max,
67                     deadline: block.timestamp
68                 })
69             );
70         }
71     }
72 
73     function detectAndDecodeUniV2Path(bytes memory path) private pure returns (bool, address[] memory) {
74         bool isUniV2 = path.length % 20 == 0;
75         address[] memory addressPath;
76 
77         if (isUniV2) {
78             uint addressPathSize = path.length / 20;
79             addressPath = new address[](addressPathSize);
80 
81             unchecked {
82                 for(uint i = 0; i < addressPathSize; ++i) {
83                     addressPath[i] = toAddress(path, i * 20);
84                 }
85             }
86         }
87 
88         return (isUniV2, addressPath);
89     }
90 
91     function toAddress(bytes memory data, uint start) private pure returns (address result) {
92         // assuming data length is already validated
93         assembly {
94             // borrowed from BytesLib https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
95             result := div(mload(add(add(data, 0x20), start)), 0x1000000000000000000000000)
96         }
97     }
98 }
