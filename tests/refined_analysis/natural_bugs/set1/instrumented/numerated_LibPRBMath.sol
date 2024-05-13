1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 
7 /**
8  * @title LibPRBMath contains functionality to compute powers of 60.18 unsigned floating point to uint256
9  * Solution taken from https://github.com/paulrberg/prb-math/blob/main/contracts/PRBMathUD60x18.sol
10  * and adapted to Solidity 0.7.6
11 **/
12 library LibPRBMath {
13 
14     enum Rounding {
15         Down, // Toward negative infinity
16         Up, // Toward infinity
17         Zero // Toward zero
18     }
19 
20     // /// @dev How many trailing decimals can be represented.
21     //uint256 internal constant SCALE = 1e18;
22 
23     // /// @dev Largest power of two divisor of SCALE.
24     // uint256 internal constant SCALE_LPOTD = 262144;
25 
26     // /// @dev SCALE inverted mod 2^256.
27     // uint256 internal constant SCALE_INVERSE =
28     //     78156646155174841979727994598816262306175212592076161876661_508869554232690281;
29 
30 
31     /// @dev How many trailing decimals can be represented.
32     uint256 internal constant SCALE = 1e18;
33 
34      /// @dev Half the SCALE number.
35     uint256 internal constant HALF_SCALE = 5e17;
36 
37     /// @dev Largest power of two divisor of SCALE.
38     uint256 internal constant SCALE_LPOTD = 68719476736;
39 
40     /// @dev SCALE inverted mod 2^256.
41     uint256 internal constant SCALE_INVERSE =
42         24147664466589061293728112707504694672000531928996266765558539143717230155537;
43 
44     function powu(uint256 x, uint256 y) internal pure returns (uint256 result) {
45         // Calculate the first iteration of the loop in advance.
46         result = y & 1 > 0 ? x : SCALE;
47 
48         // Equivalent to "for(y /= 2; y > 0; y /= 2)" but faster.
49         for (y >>= 1; y > 0; y >>= 1) {
50             x = mulDivFixedPoint(x, x);
51 
52             // Equivalent to "y % 2 == 1" but faster.
53             if (y & 1 > 0) {
54                 result = mulDivFixedPoint(result, x);
55             }
56         }
57     }
58 
59     function mulDivFixedPoint(uint256 x, uint256 y) internal pure returns (uint256 result) {
60         uint256 prod0;
61         uint256 prod1;
62         assembly {
63             let mm := mulmod(x, y, not(0))
64             prod0 := mul(x, y)
65             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
66         }
67 
68         if (prod1 >= SCALE) {
69             revert("fixed point overflow");
70         }
71 
72         uint256 remainder;
73         uint256 roundUpUnit;
74         assembly {
75             remainder := mulmod(x, y, SCALE)
76             roundUpUnit := gt(remainder, 499999999999999999)
77         }
78 
79         if (prod1 == 0) {
80             result = (prod0 / SCALE) + roundUpUnit;
81             return result;
82         }
83 
84         assembly {
85             result := add(
86                 mul(
87                     or(
88                         div(sub(prod0, remainder), SCALE_LPOTD),
89                         mul(sub(prod1, gt(remainder, prod0)), add(div(sub(0, SCALE_LPOTD), SCALE_LPOTD), 1))
90                     ),
91                     SCALE_INVERSE
92                 ),
93                 roundUpUnit
94             )
95         }
96     }
97 
98     function mostSignificantBit(uint256 x) internal pure returns (uint256 msb) {
99         if (x >= 2**128) {
100             x >>= 128;
101             msb += 128;
102         }
103         if (x >= 2**64) {
104             x >>= 64;
105             msb += 64;
106         }
107         if (x >= 2**32) {
108             x >>= 32;
109             msb += 32;
110         }
111         if (x >= 2**16) {
112             x >>= 16;
113             msb += 16;
114         }
115         if (x >= 2**8) {
116             x >>= 8;
117             msb += 8;
118         }
119         if (x >= 2**4) {
120             x >>= 4;
121             msb += 4;
122         }
123         if (x >= 2**2) {
124             x >>= 2;
125             msb += 2;
126         }
127         if (x >= 2**1) {
128             // No need to shift x any more.
129             msb += 1;
130         }
131     }
132 
133     function logBase2(uint256 x) internal pure returns (uint256 result) {
134         if (x < SCALE) {
135             revert("Log Input Too Small");
136         }
137         // Calculate the integer part of the logarithm and add it to the result and finally calculate y = x * 2^(-n).
138         uint256 n = mostSignificantBit(x / SCALE);
139 
140         // The integer part of the logarithm as an unsigned 60.18-decimal fixed-point number. The operation can't overflow
141         // because n is maximum 255 and SCALE is 1e18.
142         result = n * SCALE;
143 
144         // This is y = x * 2^(-n).
145         uint256 y = x >> n;
146 
147         // If y = 1, the fractional part is zero.
148         if (y == SCALE) {
149             return result;
150         }
151 
152         // Calculate the fractional part via the iterative approximation.
153         // The "delta >>= 1" part is equivalent to "delta /= 2", but shifting bits is faster.
154         for (uint256 delta = HALF_SCALE; delta > 0; delta >>= 1) {
155             y = (y * y) / SCALE;
156 
157             // Is y^2 > 2 and so in the range [2,4)?
158             if (y >= 2 * SCALE) {
159                 // Add the 2^(-m) factor to the logarithm.
160                 result += delta;
161 
162                 // Corresponds to z/2 on Wikipedia.
163                 y >>= 1;
164             }
165         }
166     }
167 
168     function max(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a >= b ? a : b;
170     }
171 
172     function min(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a <= b ? a : b;
174     }
175 
176     function min(uint128 a, uint128 b) internal pure returns (uint256) {
177         return a <= b ? a : b;
178     }
179 
180     /**
181      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
182      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
183      * with further edits by Uniswap Labs also under MIT license.
184      */
185     function mulDiv(
186         uint256 x,
187         uint256 y,
188         uint256 denominator
189     ) internal pure returns (uint256 result) {
190             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
191             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
192             // variables such that product = prod1 * 2^256 + prod0.
193             uint256 prod0; // Least significant 256 bits of the product
194             uint256 prod1; // Most significant 256 bits of the product
195             assembly {
196                 let mm := mulmod(x, y, not(0))
197                 prod0 := mul(x, y)
198                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
199             }
200 
201             // Handle non-overflow cases, 256 by 256 division.
202             if (prod1 == 0) {
203                 return prod0 / denominator;
204             }
205 
206             // Make sure the result is less than 2^256. Also prevents denominator == 0.
207             require(denominator > prod1);
208 
209             ///////////////////////////////////////////////
210             // 512 by 256 division.
211             ///////////////////////////////////////////////
212 
213             // Make division exact by subtracting the remainder from [prod1 prod0].
214             uint256 remainder;
215             assembly {
216                 // Compute remainder using mulmod.
217                 remainder := mulmod(x, y, denominator)
218 
219                 // Subtract 256 bit number from 512 bit number.
220                 prod1 := sub(prod1, gt(remainder, prod0))
221                 prod0 := sub(prod0, remainder)
222             }
223 
224             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
225             // See https://cs.stackexchange.com/q/138556/92363.
226 
227             // Does not overflow because the denominator cannot be zero at this stage in the function.
228             uint256 twos = denominator & (~denominator + 1);
229             assembly {
230                 // Divide denominator by twos.
231                 denominator := div(denominator, twos)
232 
233                 // Divide [prod1 prod0] by twos.
234                 prod0 := div(prod0, twos)
235 
236                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
237                 twos := add(div(sub(0, twos), twos), 1)
238             }
239 
240             // Shift in bits from prod1 into prod0.
241             prod0 |= prod1 * twos;
242 
243             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
244             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
245             // four bits. That is, denominator * inv = 1 mod 2^4.
246             uint256 inverse = (3 * denominator) ^ 2;
247 
248             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
249             // in modular arithmetic, doubling the correct bits in each step.
250             inverse *= 2 - denominator * inverse; // inverse mod 2^8
251             inverse *= 2 - denominator * inverse; // inverse mod 2^16
252             inverse *= 2 - denominator * inverse; // inverse mod 2^32
253             inverse *= 2 - denominator * inverse; // inverse mod 2^64
254             inverse *= 2 - denominator * inverse; // inverse mod 2^128
255             inverse *= 2 - denominator * inverse; // inverse mod 2^256
256 
257             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
258             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
259             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
260             // is no longer required.
261             result = prod0 * inverse;
262             return result;
263     }
264 
265     /**
266      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
267      */
268     function mulDiv(
269         uint256 x,
270         uint256 y,
271         uint256 denominator,
272         Rounding rounding
273     ) internal pure returns (uint256) {
274         uint256 result = mulDiv(x, y, denominator);
275         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
276             result += 1;
277         }
278         return result;
279     }
280 }