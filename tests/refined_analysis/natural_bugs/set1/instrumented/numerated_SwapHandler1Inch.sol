1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./SwapHandlerCombinedBase.sol";
6 
7 /// @notice Swap handler executing trades on 1Inch
8 contract SwapHandler1Inch is SwapHandlerCombinedBase {
9     address immutable public oneInchAggregator;
10 
11     constructor(address oneInchAggregator_, address uniSwapRouterV2, address uniSwapRouterV3) SwapHandlerCombinedBase(uniSwapRouterV2, uniSwapRouterV3) {
12         oneInchAggregator = oneInchAggregator_;
13     }
14 
15     function swapPrimary(SwapParams memory params) override internal returns (uint amountOut) {
16         setMaxAllowance(params.underlyingIn, params.amountIn, oneInchAggregator);
17 
18         (bool success, bytes memory result) = oneInchAggregator.call(params.payload);
19         if (!success) revertBytes(result);
20 
21         // return amount out reported by 1Inch. It might not be exact for fee-on-transfer or rebasing tokens.
22         amountOut = abi.decode(result, (uint));
23     }
24 }
