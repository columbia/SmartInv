1 /**
2  * SPDX-License-Identifier: MIT
3  **/
4 
5 pragma solidity =0.7.6;
6  
7 import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
8 import "./LibBytes.sol";
9  
10 /* 
11 * @author: Malteasy
12 * @title: LibPolynomial
13 */
14 
15 library LibPolynomial { 
16 
17     using SafeMath for uint256;
18 
19     using LibBytes for bytes;
20 
21     /**
22     The polynomial's constant terms are split into: 1) constant * 10^exponent , 2) the exponent the constant is raised to in base 10 and, 3) the sign of the coefficients.
23     Example conversion to Piecewise: 
24 
25         Range(0, 1) -> Polynomial(0.25*x^3 + 25*x^2 + x + 1)
26         Range(1, 2) -> Polynomial(0.0125*x^3 + 50*x^2 + x - 2)
27         Range(2, Infinity) -> Polynomial(-1)
28         
29     Resulting Piecewise:
30 
31         breakpoints: [0, 1, 2]
32         significands: [1, 1, 25, 25, 2, 1, 50, 125, 1, 0, 0, 0]
33         (expanded) coefficient exponents: [0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 0]
34         (expanded) signs: [true, true, true, true, false, true, true, true, false, false, false, false]
35 
36     The resulting piecewise is then encoded into a single bytes array by concatenating as follows, where n is the number of polynomial pieces: 
37         [
38             n, (32 bytes)
39             breakpoints, (32n bytes)
40             significands, (128n bytes)
41             exponents, (4n bytes)
42             signs, (4n bytes)
43         ]
44         
45     */
46 
47     enum PriceType {
48         Fixed,
49         Dynamic
50     }
51 
52     uint256 constant MAX_DEGREE = 3;
53 
54     /**
55     * @notice Computes a cubic polynomial.
56     * @dev Polynomial is of the form a(x-k)^3 + b(x-k)^2 + c(x-k) + d where k is the start of the piecewise interval
57     * @param f The encoded piecewise polynomial
58     * @param pieceIndex Which piece of the polynomial to evaluate
59     * @param numPieces The number of pieces in the polynomial
60     * @param x The value to be evaluated at.
61     */
62     function evaluatePolynomial(
63         bytes calldata f,
64         uint256 pieceIndex,
65         uint256 numPieces,
66         uint256 x
67     ) internal pure returns (uint256) {
68         uint256 positiveSum;
69         uint256 negativeSum;
70 
71         uint256[4] memory significands = getSignificands(f, pieceIndex, numPieces);
72         uint8[4] memory exponents = getExponents(f, pieceIndex, numPieces);
73         bool[4] memory signs = getSigns(f, pieceIndex, numPieces);
74         
75         for(uint256 degree; degree <= MAX_DEGREE; ++degree) {
76             if(signs[degree]) {
77                 positiveSum = positiveSum.add(pow(x, degree).mul(significands[degree]).div(pow(10, exponents[degree])));
78             } else {
79                 negativeSum = negativeSum.add(pow(x, degree).mul(significands[degree]).div(pow(10, exponents[degree])));
80             }
81         }
82         return positiveSum.sub(negativeSum);
83     }
84 
85     function evaluatePolynomialPiecewise(
86         bytes calldata f,
87         uint256 x
88     ) internal pure returns (uint256 y) {
89         uint256 numPieces = getNumPieces(f);
90         uint256 pieceIndex = findPiecewiseIndex(f, x, numPieces);
91         y = evaluatePolynomial(f, pieceIndex, numPieces,
92             x.sub(getPiecewiseBreakpoint(f, pieceIndex), "Evaluation must be within piecewise bounds")
93         );
94     }
95 
96     /**
97     * @notice Computes the integral of a cubic polynomial 
98     * @dev Polynomial is of the form a(x-k)^3 + b(x-k)^2 + c(x-k) + d where k is the start of the piecewise interval
99     * @param f The encoded piecewise polynomial
100     * @param pieceIndex Which piece of the polynomial to evaluate
101     * @param numPieces The number of pieces in the polynomial
102     * @param start The lower bound of the integration. (can overflow past 10e13)
103     * @param end The upper bound of the integration. (can overflow past 10e13)
104     */
105     function evaluatePolynomialIntegration(
106         bytes calldata f,
107         uint256 pieceIndex,
108         uint256 numPieces,
109         uint256 start, //start of breakpoint is assumed to be subtracted
110         uint256 end //start of breakpoint is assumed to be subtracted
111     ) internal pure returns (uint256) {
112         uint256 positiveSum;
113         uint256 negativeSum;
114 
115         uint256[4] memory significands = getSignificands(f, pieceIndex, numPieces);
116         uint8[4] memory exponents = getExponents(f, pieceIndex, numPieces);
117         bool[4] memory signs = getSigns(f, pieceIndex, numPieces);
118         
119         for(uint256 degree; degree <= MAX_DEGREE; ++degree) {
120 
121             if(signs[degree]) {
122                 //uint256 max value is 1e77 and this has been tested to work to not overflow for values less than 1e14. 
123                 //Note: susceptible to overflows past 1e14
124                 positiveSum = positiveSum.add(pow(end, 1 + degree).mul(significands[degree]).div(pow(10, exponents[degree]).mul(1 + degree)));
125 
126                 positiveSum = positiveSum.sub(pow(start, 1 + degree).mul(significands[degree]).div(pow(10, exponents[degree]).mul(1 + degree)));
127             } else {
128                 negativeSum = negativeSum.add(pow(end, 1 + degree).mul(significands[degree]).div(pow(10, exponents[degree]).mul(1 + degree)));
129 
130                 negativeSum = negativeSum.sub(pow(start, 1 + degree).mul(significands[degree]).div(pow(10, exponents[degree]).mul(1 + degree)));
131             }
132         }
133 
134         return positiveSum.sub(negativeSum);
135     }
136 
137     function evaluatePolynomialIntegrationPiecewise(
138         bytes calldata f,
139         uint256 start, 
140         uint256 end
141     ) internal pure returns (uint256 integral) {
142         uint256 numPieces = getNumPieces(f);
143         uint256 currentPieceIndex = findPiecewiseIndex(f, start, numPieces);
144         uint256 currentPieceStart = getPiecewiseBreakpoint(f, currentPieceIndex);
145         uint256 nextPieceStart = getPiecewiseBreakpoint(f, currentPieceIndex + 1);
146         bool integrateToEnd;
147 
148         while (!integrateToEnd) {
149             if(end > nextPieceStart) {
150                 integrateToEnd = false;
151             } else {
152                 integrateToEnd = true;
153             }
154 
155             uint256 startIntegration = start.sub(currentPieceStart, "Evaluation must be within piecewise bounds.");
156             uint256 endIntegration = integrateToEnd ? end.sub(currentPieceStart) : nextPieceStart.sub(currentPieceStart);
157 
158             integral = integral.add(evaluatePolynomialIntegration(f, currentPieceIndex, numPieces, 
159                 startIntegration, 
160                 endIntegration
161             ));
162 
163             if(!integrateToEnd) {
164                 start = nextPieceStart;
165                 if(currentPieceIndex == (numPieces - 1)) {
166                     //reached end of piecewise
167                     integrateToEnd = true;
168                 } else {
169                     //continue to next piece
170                     currentPieceIndex++;
171                     currentPieceStart = getPiecewiseBreakpoint(f, currentPieceIndex);
172                     if(currentPieceIndex != (numPieces - 1)) nextPieceStart = getPiecewiseBreakpoint(f, currentPieceIndex + 1);
173                 }
174             }
175 
176         }
177     }
178     
179     /**
180     * @notice Searches for index of interval containing x
181     * @dev [inclusiveStart, exclusiveEnd)
182     * @param value The value to search for.
183     * @param high The highest index of the array to search. Could be retrieved from getNumPieces(arr) - 1.
184     */
185     function findPiecewiseIndex(bytes calldata f, uint256 value, uint256 high) internal pure returns (uint256) {
186         uint256 breakpointAtIndex = getPiecewiseBreakpoint(f, 0);
187         if(value < breakpointAtIndex) return 0;
188         
189         uint256 low = 0;
190         
191         while(low < high) {
192             if(breakpointAtIndex == value) return low;
193             else if(breakpointAtIndex > value) return low - 1;
194             else low++;
195             breakpointAtIndex = getPiecewiseBreakpoint(f, low);
196         }
197 
198         return low - 1;
199     }
200 
201     /**
202       Function calldata parsing.
203     */
204 
205     /**
206     * @notice Retrieves the length of pieces in a piecewise polynomial. 
207     * @dev Stored as the first 32 bytes of the piecewise function data.
208     * @param f The function data of the piecewise polynomial.
209     */
210     function getNumPieces(bytes calldata f) internal pure returns (uint256) {
211         return f.sliceToMemory(0, 32).toUint256(0);
212     }
213 
214     /**
215     * @notice Retrieves the breakpoint at the specified piecewise index.
216     * @dev Stored in function data after the first 32 bytes. Occupies 32n bytes, where n is the number of polynomial pieces.
217     * @param f The function data of the piecewise polynomial.
218     */
219     function getPiecewiseBreakpoint(bytes calldata f, uint256 pieceIndex) internal pure returns (uint256) {
220         return f.sliceToMemory((pieceIndex.mul(32)).add(32), 32).toUint256(0);
221     }
222 
223     /**
224     * @notice Retrieves the coefficient significands of a cubic polynomial at specified piecewise index. (significands / 10^exponent = coefficientValue)
225     * @dev Stored in function data after the first 32 + 32n bytes. Occupies 128n bytes, where n is the number of polynomial pieces.
226     * @param f The function data of the piecewise polynomial.
227     * @param pieceIndex The index of the piecewise polynomial to get signs for.
228     * @param numPieces The number of pieces in the piecewise polynomial.
229     */
230     function getSignificands(bytes calldata f, uint256 pieceIndex, uint256 numPieces) internal pure returns (uint256[4] memory significands) {
231         bytes memory significandSlice = f.sliceToMemory((pieceIndex.mul(128)).add(numPieces.mul(32)).add(32), 128);
232         significands[0] = significandSlice.toUint256(0);
233         significands[1] = significandSlice.toUint256(32);
234         significands[2] = significandSlice.toUint256(64);
235         significands[3] = significandSlice.toUint256(96);
236     }
237 
238     /**
239     * @notice Retrieves the exponents for the coefficients of a cubic polynomial at specified piecewise index. (significand / 10^exponent = coefficientValue)
240     * @dev Stored in function data after the first 32 + 32n + 128n bytes. Occupies 4n bytes, where n is the number of polynomial pieces.
241     * @param f The function data of the piecewise polynomial.
242     * @param pieceIndex The index of the piecewise polynomial to get signs for.
243     * @param numPieces The number of pieces in the piecewise polynomial.
244     */
245     function getExponents(bytes calldata f, uint256 pieceIndex, uint256 numPieces) internal pure returns(uint8[4] memory exponents) {
246         bytes memory exponentSlice = f.sliceToMemory((pieceIndex.mul(4)).add(numPieces.mul(160)).add(32), 4);
247         exponents[0] = exponentSlice.toUint8(0);
248         exponents[1] = exponentSlice.toUint8(1);
249         exponents[2] = exponentSlice.toUint8(2);
250         exponents[3] = exponentSlice.toUint8(3);
251     }
252 
253     /**
254     * @notice Retrieves the signs (bool values) for the coefficients of a cubic polynomial at specified piecewise index.
255     * @dev Stored in function data after the first 32 + 32n + 128n + 4n bytes. Occupies 4n bytes, where n is the number of polynomial pieces.
256     * @param f The function data of the piecewise polynomial.
257     * @param pieceIndex The index of the piecewise polynomial to get signs for.
258     * @param numPieces The number of pieces in the piecewise polynomial.
259     */
260     function getSigns(bytes calldata f, uint256 pieceIndex, uint256 numPieces) internal pure returns(bool[4] memory signs) {
261         bytes memory signSlice = f.sliceToMemory((pieceIndex.mul(4)).add(numPieces.mul(164)).add(32), 4);
262         signs[0] = signSlice.toUint8(0) == 1;
263         signs[1] = signSlice.toUint8(1) == 1;
264         signs[2] = signSlice.toUint8(2) == 1; 
265         signs[3] = signSlice.toUint8(3) == 1;
266     }
267 
268     /**
269     * @notice A safe way to take the power of a number.
270     */
271     function pow(uint256 base, uint256 exponent) internal pure returns (uint256) {
272         if(exponent == 0) 
273             return 1;
274             
275         else if(exponent == 1) 
276             return base; 
277 
278         else if(base == 0 && exponent != 0) 
279             return 0;
280 
281         else {
282             uint256 z = base;
283             for(uint256 i = 1; i < exponent; ++i) 
284                 z = z.mul(base);
285             return z;
286         }
287     }
288 }