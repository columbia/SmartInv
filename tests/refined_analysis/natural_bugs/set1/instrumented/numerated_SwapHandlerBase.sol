1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./ISwapHandler.sol";
6 import "../Interfaces.sol";
7 import "../Utils.sol";
8 
9 /// @notice Base contract for swap handlers
10 abstract contract SwapHandlerBase is ISwapHandler {
11     function trySafeApprove(address token, address to, uint value) internal returns (bool, bytes memory) {
12         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, value));
13         return (success && (data.length == 0 || abi.decode(data, (bool))), data);
14     }
15 
16     function safeApproveWithRetry(address token, address to, uint value) internal {
17         (bool success, bytes memory data) = trySafeApprove(token, to, value);
18 
19         // some tokens, like USDT, require the allowance to be set to 0 first
20         if (!success) {
21             (success,) = trySafeApprove(token, to, 0);
22             if (success) {
23                 (success,) = trySafeApprove(token, to, value);
24             }
25         }
26 
27         if (!success) revertBytes(data);
28     }
29 
30     function transferBack(address token) internal {
31         uint balance = IERC20(token).balanceOf(address(this));
32         if (balance > 0) Utils.safeTransfer(token, msg.sender, balance);
33     }
34 
35     function setMaxAllowance(address token, uint minAllowance, address spender) internal {
36         uint allowance = IERC20(token).allowance(address(this), spender);
37         if (allowance < minAllowance) safeApproveWithRetry(token, spender, type(uint).max);
38     }
39 
40     function revertBytes(bytes memory errMsg) internal pure {
41         if (errMsg.length > 0) {
42             assembly {
43                 revert(add(32, errMsg), mload(errMsg))
44             }
45         }
46 
47         revert("SwapHandlerBase: empty error");
48     }
49 }
