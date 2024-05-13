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
34 */
35 
36 interface IVaultCollateral {
37     function WITHDRAWAL_FEE_PERIOD() external view returns (uint);
38     function WITHDRAWAL_FEE_UNIT() external view returns (uint);
39     function WITHDRAWAL_FEE() external view returns (uint);
40 
41     function stakingToken() external view returns (address);
42     function collateralValueMin() external view returns (uint);
43 
44     function balance() external view returns (uint);
45     function availableOf(address account) external view returns (uint);
46     function collateralOf(address account) external view returns (uint);
47     function realizedInETH(address account) external view returns (uint);
48     function depositedAt(address account) external view returns (uint);
49 
50     function addCollateral(uint amount) external;
51     function addCollateralETH() external payable;
52     function removeCollateral() external;
53 
54     event CollateralAdded(address indexed user, uint amount);
55     event CollateralRemoved(address indexed user, uint amount, uint profitInETH);
56     event CollateralUnlocked(address indexed user, uint amount, uint profitInETH, uint lossInETH);
57     event Recovered(address token, uint amount);
58 }
