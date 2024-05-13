1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 * SOFTWARE.
35 */
36 
37 import "./IStrategyCompact.sol";
38 
39 interface IStrategy is IStrategyCompact {
40 
41     // rewardsToken
42     function sharesOf(address account) external view returns (uint);
43     function deposit(uint _amount) external;
44     function withdraw(uint _amount) external;
45 
46     /* ========== Interface ========== */
47 
48     function depositAll() external;
49     function withdrawAll() external;
50     function getReward() external;
51     function harvest() external;
52     function pid() external view returns (uint);
53     function totalSupply() external view returns (uint);
54     function poolType() external view returns (PoolConstant.PoolTypes);
55 
56     event Deposited(address indexed user, uint amount);
57     event Withdrawn(address indexed user, uint amount, uint withdrawalFee);
58     event ProfitPaid(address indexed user, uint profit, uint performanceFee);
59     event BunnyPaid(address indexed user, uint profit, uint performanceFee);
60     event Harvested(uint profit);
61 }
