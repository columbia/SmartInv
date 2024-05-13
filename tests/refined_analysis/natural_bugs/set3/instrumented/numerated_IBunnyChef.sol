1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
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
36 interface IBunnyChef {
37 
38     struct UserInfo {
39         uint balance;
40         uint pending;
41         uint rewardPaid;
42     }
43 
44     struct VaultInfo {
45         address token;
46         uint allocPoint;       // How many allocation points assigned to this pool. BUNNYs to distribute per block.
47         uint lastRewardBlock;  // Last block number that BUNNYs distribution occurs.
48         uint accBunnyPerShare; // Accumulated BUNNYs per share, times 1e12. See below.
49     }
50 
51     function bunnyPerBlock() external view returns (uint);
52     function totalAllocPoint() external view returns (uint);
53 
54     function vaultInfoOf(address vault) external view returns (VaultInfo memory);
55     function vaultUserInfoOf(address vault, address user) external view returns (UserInfo memory);
56     function pendingBunny(address vault, address user) external view returns (uint);
57 
58     function notifyDeposited(address user, uint amount) external;
59     function notifyWithdrawn(address user, uint amount) external;
60     function safeBunnyTransfer(address user) external returns (uint);
61 
62     function updateRewardsOf(address vault) external;
63 }
