1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity 0.8.17;
3 
4 /// @notice Arithmetic library with operations for fixed-point numbers.
5 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
6 /// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
7 library FixedPointMathLib {
8     /*//////////////////////////////////////////////////////////////
9                     SIMPLIFIED FIXED POINT OPERATIONS
10     //////////////////////////////////////////////////////////////*/
11 
12     uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.
13 
14     function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
15         return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
16     }
17 
18     function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
19         return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
20     }
21 
22     function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
23         return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
24     }
25 
26     function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
27         return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
28     }
29 
30     /*//////////////////////////////////////////////////////////////
31                     LOW LEVEL FIXED POINT OPERATIONS
32     //////////////////////////////////////////////////////////////*/
33 
34     function mulDivDown(
35         uint256 x,
36         uint256 y,
37         uint256 denominator
38     ) internal pure returns (uint256 z) {
39         assembly {
40             // Store x * y in z for now.
41             z := mul(x, y)
42 
43             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
44             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
45                 revert(0, 0)
46             }
47 
48             // Divide z by the denominator.
49             z := div(z, denominator)
50         }
51     }
52 
53     function mulDivUp(
54         uint256 x,
55         uint256 y,
56         uint256 denominator
57     ) internal pure returns (uint256 z) {
58         assembly {
59             // Store x * y in z for now.
60             z := mul(x, y)
61 
62             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
63             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
64                 revert(0, 0)
65             }
66 
67             // First, divide z - 1 by the denominator and add 1.
68             // We allow z - 1 to underflow if z is 0, because we multiply the
69             // end result by 0 if z is zero, ensuring we return 0 if z is zero.
70             z := mul(iszero(iszero(z)), add(div(sub(z, 1), denominator), 1))
71         }
72     }
73 
74     function rpow(
75         uint256 x,
76         uint256 n,
77         uint256 scalar
78     ) internal pure returns (uint256 z) {
79         assembly {
80             switch x
81             case 0 {
82                 switch n
83                 case 0 {
84                     // 0 ** 0 = 1
85                     z := scalar
86                 }
87                 default {
88                     // 0 ** n = 0
89                     z := 0
90                 }
91             }
92             default {
93                 switch mod(n, 2)
94                 case 0 {
95                     // If n is even, store scalar in z for now.
96                     z := scalar
97                 }
98                 default {
99                     // If n is odd, store x in z for now.
100                     z := x
101                 }
102 
103                 // Shifting right by 1 is like dividing by 2.
104                 let half := shr(1, scalar)
105 
106                 for {
107                     // Shift n right by 1 before looping to halve it.
108                     n := shr(1, n)
109                 } n {
110                     // Shift n right by 1 each iteration to halve it.
111                     n := shr(1, n)
112                 } {
113                     // Revert immediately if x ** 2 would overflow.
114                     // Equivalent to iszero(eq(div(xx, x), x)) here.
115                     if shr(128, x) {
116                         revert(0, 0)
117                     }
118 
119                     // Store x squared.
120                     let xx := mul(x, x)
121 
122                     // Round to the nearest number.
123                     let xxRound := add(xx, half)
124 
125                     // Revert if xx + half overflowed.
126                     if lt(xxRound, xx) {
127                         revert(0, 0)
128                     }
129 
130                     // Set x to scaled xxRound.
131                     // slither-disable-next-line divide-before-multiply
132                     x := div(xxRound, scalar)
133 
134                     // If n is even:
135                     if mod(n, 2) {
136                         // Compute z * x.
137                         let zx := mul(z, x)
138 
139                         // If z * x overflowed:
140                         if iszero(eq(div(zx, x), z)) {
141                             // Revert if x is non-zero.
142                             if iszero(iszero(x)) {
143                                 revert(0, 0)
144                             }
145                         }
146 
147                         // Round to the nearest number.
148                         let zxRound := add(zx, half)
149 
150                         // Revert if zx + half overflowed.
151                         if lt(zxRound, zx) {
152                             revert(0, 0)
153                         }
154 
155                         // Return properly scaled zxRound.
156                         z := div(zxRound, scalar)
157                     }
158                 }
159             }
160         }
161     }
162 
163     /*//////////////////////////////////////////////////////////////
164                         GENERAL NUMBER UTILITIES
165     //////////////////////////////////////////////////////////////*/
166 
167     function sqrt(uint256 x) internal pure returns (uint256 z) {
168         assembly {
169             let y := x // We start y at x, which will help us make our initial estimate.
170 
171             z := 181 // The "correct" value is 1, but this saves a multiplication later.
172 
173             // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
174             // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.
175 
176             // We check y >= 2^(k + 8) but shift right by k bits
177             // each branch to ensure that if x >= 256, then y >= 256.
178             if iszero(lt(y, 0x10000000000000000000000000000000000)) {
179                 y := shr(128, y)
180                 z := shl(64, z)
181             }
182             if iszero(lt(y, 0x1000000000000000000)) {
183                 y := shr(64, y)
184                 z := shl(32, z)
185             }
186             if iszero(lt(y, 0x10000000000)) {
187                 y := shr(32, y)
188                 z := shl(16, z)
189             }
190             if iszero(lt(y, 0x1000000)) {
191                 y := shr(16, y)
192                 z := shl(8, z)
193             }
194 
195             // Goal was to get z*z*y within a small factor of x. More iterations could
196             // get y in a tighter range. Currently, we will have y in [256, 256*2^16).
197             // We ensured y >= 256 so that the relative difference between y and y+1 is small.
198             // That's not possible if x < 256 but we can just verify those cases exhaustively.
199 
200             // Now, z*z*y <= x < z*z*(y+1), and y <= 2^(16+8), and either y >= 256, or x < 256.
201             // Correctness can be checked exhaustively for x < 256, so we assume y >= 256.
202             // Then z*sqrt(y) is within sqrt(257)/sqrt(256) of sqrt(x), or about 20bps.
203 
204             // For s in the range [1/256, 256], the estimate f(s) = (181/1024) * (s+1) is in the range
205             // (1/2.84 * sqrt(s), 2.84 * sqrt(s)), with largest error when s = 1 and when s = 256 or 1/256.
206 
207             // Since y is in [256, 256*2^16), let a = y/65536, so that a is in [1/256, 256). Then we can estimate
208             // sqrt(y) using sqrt(65536) * 181/1024 * (a + 1) = 181/4 * (y + 65536)/65536 = 181 * (y + 65536)/2^18.
209 
210             // There is no overflow risk here since y < 2^136 after the first branch above.
211             z := shr(18, mul(z, add(y, 65536))) // A mul() is saved from starting z at 181.
212 
213             // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
214             z := shr(1, add(z, div(x, z)))
215             z := shr(1, add(z, div(x, z)))
216             z := shr(1, add(z, div(x, z)))
217             z := shr(1, add(z, div(x, z)))
218             z := shr(1, add(z, div(x, z)))
219             z := shr(1, add(z, div(x, z)))
220             z := shr(1, add(z, div(x, z)))
221 
222             // If x+1 is a perfect square, the Babylonian method cycles between
223             // floor(sqrt(x)) and ceil(sqrt(x)). This statement ensures we return floor.
224             // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
225             // Since the ceil is rare, we save gas on the assignment and repeat division in the rare case.
226             // If you don't care whether the floor or ceil square root is returned, you can remove this statement.
227             z := sub(z, lt(div(x, z), z))
228         }
229     }
230 
231     function unsafeMod(uint256 x, uint256 y) internal pure returns (uint256 z) {
232         assembly {
233             // Mod x by y. Note this will return
234             // 0 instead of reverting if y is zero.
235             z := mod(x, y)
236         }
237     }
238 
239     function unsafeDiv(uint256 x, uint256 y) internal pure returns (uint256 r) {
240         assembly {
241             // Divide x by y. Note this will return
242             // 0 instead of reverting if y is zero.
243             r := div(x, y)
244         }
245     }
246 
247     function unsafeDivUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
248         assembly {
249             // Add 1 to x * y if x % y > 0. Note this will
250             // return 0 instead of reverting if y is zero.
251             z := add(gt(mod(x, y), 0), div(x, y))
252         }
253     }
254 }