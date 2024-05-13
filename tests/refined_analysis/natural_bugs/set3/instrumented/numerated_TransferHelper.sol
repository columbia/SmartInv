1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0;
4 
5 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
6 library TransferHelper {
7     function safeApprove(address token, address to, uint value) internal {
8         // bytes4(keccak256(bytes('approve(address,uint256)')));
9         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
10         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
11     }
12 
13     function safeTransfer(address token, address to, uint value) internal {
14         // bytes4(keccak256(bytes('transfer(address,uint256)')));
15         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
16         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
17     }
18 
19     function safeTransferFrom(address token, address from, address to, uint value) internal {
20         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
21         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
22         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
23     }
24 
25     function safeTransferETH(address to, uint value) internal {
26         (bool success,) = to.call{value:value}(new bytes(0));
27         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
28     }
29 }
