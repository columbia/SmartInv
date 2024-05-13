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
35 */
36 
37 interface IPresaleLocker {
38     function setPresale(address _presaleContract) external;
39 
40     function setPresaleEndTime(uint endTime) external;
41 
42     function balanceOf(address account) external view returns (uint);
43 
44     function withdrawableBalanceOf(address account) external view returns (uint);
45 
46     function depositBehalf(address account, uint balance) external;
47 
48     function withdraw(uint amount) external;
49 
50     function withdrawAll() external;
51 
52     function recoverToken(address tokenAddress, uint tokenAmount) external;
53 }
