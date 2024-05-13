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
37 library PoolConstant {
38 
39     enum PoolTypes {
40         BunnyStake_deprecated, // no perf fee
41         BunnyFlip_deprecated, // deprecated
42         CakeStake, FlipToFlip, FlipToCake,
43         Bunny, // no perf fee
44         BunnyBNB,
45         Venus,
46         Collateral,
47         BunnyToBunny,
48         FlipToReward,
49         BunnyV2,
50         Qubit,
51         bQBT, flipToQBT,
52         Multiplexer
53     }
54 
55     struct PoolInfo {
56         address pool;
57         uint balance;
58         uint principal;
59         uint available;
60         uint tvl;
61         uint utilized;
62         uint liquidity;
63         uint pBASE;
64         uint pBUNNY;
65         uint depositedAt;
66         uint feeDuration;
67         uint feePercentage;
68         uint portfolio;
69     }
70 
71     struct RelayInfo {
72         address pool;
73         uint balanceInUSD;
74         uint debtInUSD;
75         uint earnedInUSD;
76     }
77 
78     struct RelayWithdrawn {
79         address pool;
80         address account;
81         uint profitInETH;
82         uint lossInETH;
83     }
84 }
