1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 interface ERC20Interface {
6     function balanceOf(address user) external view returns (uint256);
7 }
8 
9 library SafeToken {
10     function myBalance(address token) internal view returns (uint256) {
11         return ERC20Interface(token).balanceOf(address(this));
12     }
13 
14     function balanceOf(address token, address user) internal view returns (uint256) {
15         return ERC20Interface(token).balanceOf(user);
16     }
17 
18     function safeApprove(address token, address to, uint256 value) internal {
19         // bytes4(keccak256(bytes('approve(address,uint256)')));
20         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
21         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
22     }
23 
24     function safeTransfer(address token, address to, uint256 value) internal {
25         // bytes4(keccak256(bytes('transfer(address,uint256)')));
26         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
27         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
28     }
29 
30     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
31         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
32         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
33         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
34     }
35 
36     function safeTransferETH(address to, uint256 value) internal {
37         (bool success, ) = to.call{ value: value }(new bytes(0));
38         require(success, "!safeTransferETH");
39     }
40 }
