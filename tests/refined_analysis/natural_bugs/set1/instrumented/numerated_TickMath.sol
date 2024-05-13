1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 // From Uniswap3 Core
4 
5 // Updated to Solidity 0.8 by Euler:
6 //   * Cast MAX_TICK to int256 before casting to uint
7 //   * Wrapped function bodies with "unchecked {}" so as to not add any extra gas costs
8 
9 pragma solidity ^0.8.0;
10 
11 /// @title Math library for computing sqrt prices from ticks and vice versa
12 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
13 /// prices between 2**-128 and 2**128
14 library TickMath {
15     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
16     int24 internal constant MIN_TICK = -887272;
17     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
18     int24 internal constant MAX_TICK = -MIN_TICK;
19 
20     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
21     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
22     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
23     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
24 
25     /// @notice Calculates sqrt(1.0001^tick) * 2^96
26     /// @dev Throws if |tick| > max tick
27     /// @param tick The input tick for the above formula
28     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
29     /// at the given tick
30     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
31       unchecked {
32         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
33         require(absTick <= uint256(int(MAX_TICK)), 'T');
34 
35         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
36         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
37         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
38         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
39         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
40         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
41         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
42         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
43         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
44         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
45         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
46         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
47         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
48         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
49         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
50         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
51         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
52         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
53         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
54         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
55 
56         if (tick > 0) ratio = type(uint256).max / ratio;
57 
58         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
59         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
60         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
61         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
62       }
63     }
64 
65     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
66     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
67     /// ever return.
68     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
69     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
70     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
71       unchecked {
72         // second inequality must be < because the price can never reach the price at the max tick
73         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
74         uint256 ratio = uint256(sqrtPriceX96) << 32;
75 
76         uint256 r = ratio;
77         uint256 msb = 0;
78 
79         assembly {
80             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
81             msb := or(msb, f)
82             r := shr(f, r)
83         }
84         assembly {
85             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
86             msb := or(msb, f)
87             r := shr(f, r)
88         }
89         assembly {
90             let f := shl(5, gt(r, 0xFFFFFFFF))
91             msb := or(msb, f)
92             r := shr(f, r)
93         }
94         assembly {
95             let f := shl(4, gt(r, 0xFFFF))
96             msb := or(msb, f)
97             r := shr(f, r)
98         }
99         assembly {
100             let f := shl(3, gt(r, 0xFF))
101             msb := or(msb, f)
102             r := shr(f, r)
103         }
104         assembly {
105             let f := shl(2, gt(r, 0xF))
106             msb := or(msb, f)
107             r := shr(f, r)
108         }
109         assembly {
110             let f := shl(1, gt(r, 0x3))
111             msb := or(msb, f)
112             r := shr(f, r)
113         }
114         assembly {
115             let f := gt(r, 0x1)
116             msb := or(msb, f)
117         }
118 
119         if (msb >= 128) r = ratio >> (msb - 127);
120         else r = ratio << (127 - msb);
121 
122         int256 log_2 = (int256(msb) - 128) << 64;
123 
124         assembly {
125             r := shr(127, mul(r, r))
126             let f := shr(128, r)
127             log_2 := or(log_2, shl(63, f))
128             r := shr(f, r)
129         }
130         assembly {
131             r := shr(127, mul(r, r))
132             let f := shr(128, r)
133             log_2 := or(log_2, shl(62, f))
134             r := shr(f, r)
135         }
136         assembly {
137             r := shr(127, mul(r, r))
138             let f := shr(128, r)
139             log_2 := or(log_2, shl(61, f))
140             r := shr(f, r)
141         }
142         assembly {
143             r := shr(127, mul(r, r))
144             let f := shr(128, r)
145             log_2 := or(log_2, shl(60, f))
146             r := shr(f, r)
147         }
148         assembly {
149             r := shr(127, mul(r, r))
150             let f := shr(128, r)
151             log_2 := or(log_2, shl(59, f))
152             r := shr(f, r)
153         }
154         assembly {
155             r := shr(127, mul(r, r))
156             let f := shr(128, r)
157             log_2 := or(log_2, shl(58, f))
158             r := shr(f, r)
159         }
160         assembly {
161             r := shr(127, mul(r, r))
162             let f := shr(128, r)
163             log_2 := or(log_2, shl(57, f))
164             r := shr(f, r)
165         }
166         assembly {
167             r := shr(127, mul(r, r))
168             let f := shr(128, r)
169             log_2 := or(log_2, shl(56, f))
170             r := shr(f, r)
171         }
172         assembly {
173             r := shr(127, mul(r, r))
174             let f := shr(128, r)
175             log_2 := or(log_2, shl(55, f))
176             r := shr(f, r)
177         }
178         assembly {
179             r := shr(127, mul(r, r))
180             let f := shr(128, r)
181             log_2 := or(log_2, shl(54, f))
182             r := shr(f, r)
183         }
184         assembly {
185             r := shr(127, mul(r, r))
186             let f := shr(128, r)
187             log_2 := or(log_2, shl(53, f))
188             r := shr(f, r)
189         }
190         assembly {
191             r := shr(127, mul(r, r))
192             let f := shr(128, r)
193             log_2 := or(log_2, shl(52, f))
194             r := shr(f, r)
195         }
196         assembly {
197             r := shr(127, mul(r, r))
198             let f := shr(128, r)
199             log_2 := or(log_2, shl(51, f))
200             r := shr(f, r)
201         }
202         assembly {
203             r := shr(127, mul(r, r))
204             let f := shr(128, r)
205             log_2 := or(log_2, shl(50, f))
206         }
207 
208         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
209 
210         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
211         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
212 
213         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
214       }
215     }
216 }
