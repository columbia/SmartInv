1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IHopBridge {
5     function sendToL2(
6         uint256 chainId,
7         address recipient,
8         uint256 amount,
9         uint256 amountOutMin,
10         uint256 deadline,
11         address relayer,
12         uint256 relayerFee
13     ) external payable;
14 
15     function swapAndSend(
16         uint256 chainId,
17         address recipient,
18         uint256 amount,
19         uint256 bonderFee,
20         uint256 amountOutMin,
21         uint256 deadline,
22         uint256 destinationAmountOutMin,
23         uint256 destinationDeadline
24     ) external payable;
25 
26     function send(
27         uint256 chainId,
28         address recipient,
29         uint256 amount,
30         uint256 bonderFee,
31         uint256 amountOutMin,
32         uint256 deadline
33     ) external;
34 }
35 
36 interface IL2AmmWrapper {
37     function bridge() external view returns (address);
38 
39     function l2CanonicalToken() external view returns (address);
40 
41     function hToken() external view returns (address);
42 
43     function exchangeAddress() external view returns (address);
44 }
45 
46 interface ISwap {
47     function swap(
48         uint8 tokenIndexFrom,
49         uint8 tokenIndexTo,
50         uint256 dx,
51         uint256 minDy,
52         uint256 deadline
53     ) external returns (uint256);
54 }
