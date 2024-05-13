1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5       ___       ___       ___       ___       ___
6      /\  \     /\__\     /\  \     /\  \     /\  \
7     /::\  \   /:/ _/_   /::\  \   _\:\  \    \:\  \
8     \:\:\__\ /:/_/\__\ /::\:\__\ /\/::\__\   /::\__\
9      \::/  / \:\/:/  / \:\::/  / \::/\/__/  /:/\/__/
10      /:/  /   \::/  /   \::/  /   \:\__\    \/__/
11      \/__/     \/__/     \/__/     \/__/
12 
13 *
14 * MIT License
15 * ===========
16 *
17 * Copyright (c) 2021 QubitFinance
18 *
19 * Permission is hereby granted, free of charge, to any person obtaining a copy
20 * of this software and associated documentation files (the "Software"), to deal
21 * in the Software without restriction, including without limitation the rights
22 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
23 * copies of the Software, and to permit persons to whom the Software is
24 * furnished to do so, subject to the following conditions:
25 *
26 * The above copyright notice and this permission notice shall be included in all
27 * copies or substantial portions of the Software.
28 *
29 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
30 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
31 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
32 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
33 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
34 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
35 * SOFTWARE.
36 */
37 
38 library QConstant {
39     uint public constant CLOSE_FACTOR_MIN = 5e16;
40     uint public constant CLOSE_FACTOR_MAX = 9e17;
41     uint public constant COLLATERAL_FACTOR_MAX = 9e17;
42 
43     struct MarketInfo {
44         bool isListed;
45         uint borrowCap;
46         uint collateralFactor;
47     }
48 
49     struct BorrowInfo {
50         uint borrow;
51         uint interestIndex;
52     }
53 
54     struct AccountSnapshot {
55         uint qTokenBalance;
56         uint borrowBalance;
57         uint exchangeRate;
58     }
59 
60     struct AccrueSnapshot {
61         uint totalBorrow;
62         uint totalReserve;
63         uint accInterestIndex;
64     }
65 
66     struct DistributionInfo {
67         uint supplySpeed;
68         uint borrowSpeed;
69         uint totalBoostedSupply;
70         uint totalBoostedBorrow;
71         uint accPerShareSupply;
72         uint accPerShareBorrow;
73         uint accruedAt;
74     }
75 
76     struct DistributionAccountInfo {
77         uint accruedQubit;
78         uint boostedSupply; // effective(boosted) supply balance of user  (since last_action)
79         uint boostedBorrow; // effective(boosted) borrow balance of user  (since last_action)
80         uint accPerShareSupply; // Last integral value of Qubit rewards per share. ∫(qubitRate(t) / totalShare(t) dt) from 0 till (last_action)
81         uint accPerShareBorrow; // Last integral value of Qubit rewards per share. ∫(qubitRate(t) / totalShare(t) dt) from 0 till (last_action)
82     }
83 
84     struct DistributionAPY {
85         uint apySupplyQBT;
86         uint apyBorrowQBT;
87         uint apyAccountSupplyQBT;
88         uint apyAccountBorrowQBT;
89     }
90 }
