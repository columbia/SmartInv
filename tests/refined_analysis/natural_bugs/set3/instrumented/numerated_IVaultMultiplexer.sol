1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5   ___                      _   _
6  | _ )_  _ _ _  _ _ _  _  | | | |
7  | _ \ || | ' \| ' \ || | |_| |_|
8  |___/\_,_|_||_|_||_\_, | (_) (_)
9                     |__/
10 
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 BunnyFinance
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 * SOFTWARE.
34 */
35 
36 
37 interface IVaultMultiplexer {
38     struct PositionInfo {
39         address account;
40         uint depositedAt;
41     }
42 
43     struct UserInfo {
44         uint[] positionList;
45         mapping(address => uint) debtShare;
46     }
47 
48     struct PositionState {
49         address account;
50         bool liquidated;
51         uint balance;
52         uint principal;
53         uint earned;
54         uint debtRatio;
55         uint debtToken0;
56         uint debtToken1;
57         uint token0Value;
58         uint token1Value;
59         uint token0Refund;
60         uint token1Refund;
61         uint debtRatioLimit;
62         uint depositedAt;
63     }
64 
65     struct VaultState {
66         uint balance;
67         uint tvl;
68         uint debtRatioLimit;
69     }
70 
71     // view function
72     function token0() external view returns (address);
73     function token1() external view returns (address);
74     function getPositionOwner(uint id) external view  returns (address);
75 
76     // view function
77     function balance() external view returns(uint);
78     function balanceOf(uint id) external view returns(uint);
79     function principalOf(uint id) external view returns(uint);
80     function earned(uint id) external view returns(uint);
81     function debtValOfPosition(uint id) external view returns (uint[] memory);
82     function debtRatioOf(uint id) external view returns (uint);
83 
84     // events
85     event OpenPosition(address indexed account, uint indexed id);
86     event ClosePosition(address indexed account, uint indexed id);
87 
88     event Deposited(address indexed account, uint indexed id, uint token0Amount, uint token1Amount, uint lpAmount);
89     event Withdrawn(address indexed account, uint indexed id, uint amount, uint token0Amount, uint token1Amount);
90     event Borrow(address indexed account, uint indexed id, uint token0Borrow, uint token1Borrow);
91     event Repay(address indexed account, uint indexed id, uint token0Repay, uint token1Repay);
92 
93     event RewardAdded(address indexed token, uint reward);
94     event ClaimReward(address indexed account, uint indexed id, uint reward);
95 }