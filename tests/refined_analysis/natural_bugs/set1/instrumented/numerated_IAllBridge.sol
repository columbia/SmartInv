1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /// @title AllBridge Interface
5 interface IAllBridge {
6     /// @dev AllBridge Messenger Protocol Enum
7     enum MessengerProtocol {
8         None,
9         Allbridge,
10         Wormhole,
11         LayerZero
12     }
13 
14     function pools(bytes32 addr) external returns (address);
15 
16     function swapAndBridge(
17         bytes32 token,
18         uint256 amount,
19         bytes32 recipient,
20         uint256 destinationChainId,
21         bytes32 receiveToken,
22         uint256 nonce,
23         MessengerProtocol messenger,
24         uint256 feeTokenAmount
25     ) external payable;
26 
27     function getTransactionCost(
28         uint256 chainId
29     ) external view returns (uint256);
30 
31     function getMessageCost(
32         uint256 chainId,
33         MessengerProtocol protocol
34     ) external view returns (uint256);
35 
36     function getBridgingCostInTokens(
37         uint256 destinationChainId,
38         MessengerProtocol messenger,
39         address tokenAddress
40     ) external view returns (uint256);
41 }
