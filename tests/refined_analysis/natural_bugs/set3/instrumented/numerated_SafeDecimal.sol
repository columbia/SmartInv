1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Docs: https://docs.synthetix.io/
9 *
10 *
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 Synthetix
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 
34 // SPDX-License-Identifier: MIT
35 pragma solidity ^0.6.2;
36 
37 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
38 
39 
40 library SafeDecimal {
41     using SafeMath for uint;
42 
43     uint8 public constant decimals = 18;
44     uint public constant UNIT = 10 ** uint(decimals);
45 
46     function unit() external pure returns (uint) {
47         return UNIT;
48     }
49 
50     function multiply(uint x, uint y) internal pure returns (uint) {
51         return x.mul(y).div(UNIT);
52     }
53 
54     // https://mpark.github.io/programming/2014/08/18/exponentiation-by-squaring/
55     function power(uint x, uint n) internal pure returns (uint) {
56         uint result = UNIT;
57         while (n > 0) {
58             if (n % 2 != 0) {
59                 result = multiply(result, x);
60             }
61             x = multiply(x, x);
62             n /= 2;
63         }
64         return result;
65     }
66 }
