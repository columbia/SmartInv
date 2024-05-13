1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ISquidMulticall } from "./ISquidMulticall.sol";
5 
6 interface ISquidRouter {
7     function bridgeCall(
8         string calldata bridgedTokenSymbol,
9         uint256 amount,
10         string calldata destinationChain,
11         string calldata destinationAddress,
12         bytes calldata payload,
13         address gasRefundRecipient,
14         bool enableExpress
15     ) external payable;
16 
17     function callBridge(
18         address token,
19         uint256 amount,
20         ISquidMulticall.Call[] calldata calls,
21         string calldata bridgedTokenSymbol,
22         string calldata destinationChain,
23         string calldata destinationAddress
24     ) external payable;
25 
26     function callBridgeCall(
27         address token,
28         uint256 amount,
29         ISquidMulticall.Call[] calldata calls,
30         string calldata bridgedTokenSymbol,
31         string calldata destinationChain,
32         string calldata destinationAddress,
33         bytes calldata payload,
34         address gasRefundRecipient,
35         bool enableExpress
36     ) external payable;
37 }
