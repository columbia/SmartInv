1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 interface IVisorService {
5     /* 
6      * @dev Whenever an {IERC777} token is transferred to a subscriber vault via {IERC20-safeTransferFrom}
7      * by `operator` from `from`, this function is called.
8      *
9      * It must return its Solidity selector to confirm the token transfer.
10      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
11      *
12      * The selector can be obtained in Solidity with `IERC777.tokensReceived.selector`.
13      */
14 
15   function subscriberTokensReceived(
16         address token,
17         address operator,
18         address from,
19         address to,
20         uint256 amount,
21         bytes calldata userData,
22         bytes calldata operatorData
23     ) external; 
24 
25 
26 }
