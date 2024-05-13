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
33 */
34 
35 
36 interface IBank {
37     function pendingDebtOf(address pool, address account) external view returns (uint);
38     function pendingDebtOfBridge() external view returns (uint);
39     function sharesOf(address pool, address account) external view returns (uint);
40     function debtToProviders() external view returns (uint);
41     function getUtilizationInfo() external view returns (uint liquidity, uint utilized);
42 
43     function shareToAmount(uint share) external view returns (uint);
44     function amountToShare(uint share) external view returns (uint);
45 
46     function accruedDebtOf(address pool, address account) external returns (uint debt);
47     function accruedDebtOfBridge() external returns (uint debt);
48     function executeAccrue() external;
49 
50     function borrow(address pool, address account, uint amount) external returns (uint debtInBNB);
51 //    function repayPartial(address pool, address account) external payable;
52     function repayAll(address pool, address account) external payable returns (uint profitInETH, uint lossInETH);
53     function repayBridge() external payable;
54 
55     function bridgeETH(address to, uint amount) external;
56 }
57 
58 interface IBankBridge {
59     function realizeProfit() external payable returns (uint profitInETH);
60     function realizeLoss(uint debt) external returns (uint lossInETH);
61 }
62 
63 interface IBankConfig {
64     /// @dev Return the interest rate per second, using 1e18 as denom.
65     function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);
66 
67     /// @dev Return the bps rate for reserve pool.
68     function getReservePoolBps() external view returns (uint256);
69 }
70 
71 interface InterestModel {
72     /// @dev Return the interest rate per second, using 1e18 as denom.
73     function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);
74 }
