1 /*
2 
3   Copyright 2018 HydroProtocol.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 contract ERC20 {
22     function transfer(address to, uint tokens) public returns (bool success);
23     function approve(address spender, uint tokens) public returns (bool success);
24     function transferFrom(address from, address to, uint tokens) public returns (bool success);
25 }
26 
27 contract Exchange {
28     function fillOrder(address[5], uint[6], uint, bool, uint8, bytes32, bytes32) public returns (uint);
29 }
30 
31 contract WETH {
32     function deposit() public payable;
33     function withdraw(uint) public;
34 }
35 
36 contract HydroSwap {
37     address exchangeAddress;
38     address tokenProxyAddress;
39     address wethAddress;
40 
41     uint256 constant MAX_UINT = 2 ** 256 - 1;
42 
43     event LogSwapSuccess(bytes32 indexed id);
44 
45     constructor(address _exchangeAddress, address _tokenProxyAddress, address _wethAddress) public {
46         exchangeAddress = _exchangeAddress;
47         tokenProxyAddress = _tokenProxyAddress;
48         wethAddress = _wethAddress;
49     }
50 
51     function swap(
52         bytes32 id,
53         address[5] orderAddresses,
54         uint[6] orderValues,
55         uint8 v,
56         bytes32 r,
57         bytes32 s)
58         external
59         payable
60         returns (uint256 takerTokenFilledAmount)
61     {
62         address makerTokenAddress = orderAddresses[2];
63         address takerTokenAddress = orderAddresses[3];
64         uint makerTokenAmount = orderValues[0];
65         uint takerTokenAmount = orderValues[1];
66 
67         if (takerTokenAddress == wethAddress) {
68             require(takerTokenAmount == msg.value, "WRONG_ETH_AMOUNT");
69             WETH(wethAddress).deposit.value(takerTokenAmount)();
70         } else {
71             require(ERC20(takerTokenAddress).transferFrom(msg.sender, this, takerTokenAmount), "TOKEN_TRANSFER_FROM_ERROR");
72         }
73 
74         require(ERC20(takerTokenAddress).approve(tokenProxyAddress, takerTokenAmount), "TOKEN_APPROVE_ERROR");
75 
76         require(
77             Exchange(exchangeAddress).fillOrder(orderAddresses, orderValues, takerTokenAmount, true, v, r, s) == takerTokenAmount,
78             "FILL_ORDER_ERROR"
79         );
80 
81         if (makerTokenAddress == wethAddress) {
82             WETH(wethAddress).withdraw(makerTokenAmount);
83             msg.sender.transfer(makerTokenAmount);
84         } else {
85             require(ERC20(makerTokenAddress).transfer(msg.sender, makerTokenAmount), "TOKEN_TRANSFER_ERROR");
86         }
87 
88         emit LogSwapSuccess(id);
89 
90         return takerTokenAmount;
91     }
92 
93     // Need payable fallback function to accept the WETH withdraw funds.
94     function() public payable {} 
95 }