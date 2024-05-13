1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/math/SafeMath.sol";
7 import "../MathUtils.sol";
8 import "../interfaces/ISwap.sol";
9 import "../helper/BaseBoringBatchable.sol";
10 
11 interface IERC20Decimals {
12     function decimals() external returns (uint8);
13 }
14 
15 /**
16  * @title SwapCalculator
17  * @notice A contract to help calculate exact input and output amounts for a swap. Supports pools with ISwap interfaces.
18  * Additionally includes functions to calculate with arbitrary balances, A parameter, and swap fee.
19  */
20 contract SwapCalculator is BaseBoringBatchable {
21     using SafeMath for uint256;
22     using MathUtils for uint256;
23 
24     // Constant values
25     uint256 private constant BALANCE_PRECISION = 1e18;
26     uint256 private constant BALANCE_DECIMALS = 18;
27     uint256 private constant A_PRECISION = 100;
28     uint256 private constant MAX_LOOP_LIMIT = 256;
29     uint256 private constant MAX_TOKENS_LENGTH = 8;
30     uint256 private constant FEE_DENOMINATOR = 10**10;
31 
32     mapping(address => uint256[]) public storedDecimals;
33 
34     /**
35      * @notice Calculate the expected output amount for given pool, indexes, and input amount
36      * @param pool address of a pool contract that implements ISwap
37      * @param inputIndex index of the input token in the pool
38      * @param outputIndex index of the output token in the pool
39      * @param inputAmount amount of input token to swap
40      * @return outputAmount expected output amount
41      */
42     function calculateSwapOutput(
43         address pool,
44         uint256 inputIndex,
45         uint256 outputIndex,
46         uint256 inputAmount
47     ) external view returns (uint256 outputAmount) {
48         outputAmount = ISwap(pool).calculateSwap(
49             uint8(inputIndex),
50             uint8(outputIndex),
51             inputAmount
52         );
53     }
54 
55     /**
56      * @notice Calculate the expected input amount for given pool, indexes, and out amount
57      * @param pool address of a pool contract that implements ISwap
58      * @param inputIndex index of the input token in the pool
59      * @param outputIndex index of the output token in the pool
60      * @param outputAmount desired amount of output token to receive on swap
61      * @return inputAmount expected input amount
62      */
63     function calculateSwapInput(
64         address pool,
65         uint256 inputIndex,
66         uint256 outputIndex,
67         uint256 outputAmount
68     ) external view returns (uint256 inputAmount) {
69         uint256[] memory decimalsArr = storedDecimals[pool];
70         require(decimalsArr.length > 0, "Must call addPool() first");
71 
72         uint256[] memory balances = new uint256[](decimalsArr.length);
73         for (uint256 i = 0; i < decimalsArr.length; i++) {
74             uint256 multiplier = 10**BALANCE_DECIMALS.sub(decimalsArr[i]);
75             balances[i] = ISwap(pool).getTokenBalance(uint8(i)).mul(multiplier);
76         }
77         outputAmount = outputAmount.mul(
78             10**BALANCE_DECIMALS.sub(decimalsArr[outputIndex])
79         );
80 
81         (, , , , uint256 swapFee, , ) = ISwap(pool).swapStorage();
82 
83         inputAmount = calculateSwapInputCustom(
84             balances,
85             ISwap(pool).getAPrecise(),
86             swapFee,
87             inputIndex,
88             outputIndex,
89             outputAmount
90         ).div(10**BALANCE_DECIMALS.sub(decimalsArr[inputIndex]));
91     }
92 
93     /**
94      * @notice Calculates the relative price between two assets in a pool
95      * @param pool address of a pool contract that implements ISwap
96      * @param inputIndex index of the input token in the pool
97      * @param outputIndex index of the output token in the pool
98      * @return price relative price of output tokens per one input token
99      */
100     function relativePrice(
101         address pool,
102         uint256 inputIndex,
103         uint256 outputIndex
104     ) external view returns (uint256 price) {
105         uint256[] memory decimalsArr = storedDecimals[pool];
106         require(decimalsArr.length > 0, "Must call addPool() first");
107 
108         uint256[] memory balances = new uint256[](decimalsArr.length);
109         for (uint256 i = 0; i < decimalsArr.length; i++) {
110             uint256 multiplier = 10**BALANCE_DECIMALS.sub(decimalsArr[i]);
111             balances[i] = ISwap(pool).getTokenBalance(uint8(i)).mul(multiplier);
112         }
113 
114         price = relativePriceCustom(
115             balances,
116             ISwap(pool).getAPrecise(),
117             inputIndex,
118             outputIndex
119         );
120     }
121 
122     /**
123      * @notice Calculate the expected input amount for given balances, A, swap fee, indexes, and out amount
124      * @dev Uses 1e18 precision for balances, 1e2 for A, and 1e10 for swap fee
125      * @param balances array of balances
126      * @param a A parameter to be used in the calculation
127      * @param swapFee fee to be charged per swap
128      * @param inputIndex index of the input token in the pool
129      * @param outputIndex index of the output token in the pool
130      * @param inputAmount amount of input token to swap
131      * @return outputAmount expected output amount
132      */
133     function calculateSwapOutputCustom(
134         uint256[] memory balances,
135         uint256 a,
136         uint256 swapFee,
137         uint256 inputIndex,
138         uint256 outputIndex,
139         uint256 inputAmount
140     ) public pure returns (uint256 outputAmount) {
141         require(
142             inputIndex < balances.length && outputIndex < balances.length,
143             "Invalid token index"
144         );
145         // Calculate the swap
146         uint256 x = inputAmount.add(balances[inputIndex]);
147         uint256 y = getY(a, inputIndex, outputIndex, x, balances);
148         outputAmount = balances[outputIndex].sub(y).sub(1);
149 
150         // Simulate the swap fee
151         uint256 fee = outputAmount.mul(swapFee).div(FEE_DENOMINATOR);
152         outputAmount = outputAmount.sub(fee);
153     }
154 
155     /**
156      * @notice Calculate the expected input amount for given balances, A, swap fee, indexes, and out amount
157      * @dev Uses 1e18 precision for balances, 1e2 for A, and 1e10 for swap fee
158      * @param balances array of balances
159      * @param a A parameter to be used in the calculation
160      * @param swapFee fee to be charged per swap
161      * @param inputIndex index of the input token in the pool
162      * @param outputIndex index of the output token in the pool
163      * @param outputAmount desired amount of output token to receive on swap
164      * @return inputAmount expected input amount
165      */
166     function calculateSwapInputCustom(
167         uint256[] memory balances,
168         uint256 a,
169         uint256 swapFee,
170         uint256 inputIndex,
171         uint256 outputIndex,
172         uint256 outputAmount
173     ) public pure returns (uint256 inputAmount) {
174         require(
175             inputIndex < balances.length && outputIndex < balances.length,
176             "Invalid token index"
177         );
178 
179         // Simulate the swap fee
180         uint256 fee = outputAmount.mul(swapFee).div(
181             FEE_DENOMINATOR.sub(swapFee)
182         );
183         outputAmount = outputAmount.add(fee);
184 
185         // Calculate the swap
186         uint256 y = balances[outputIndex].sub(outputAmount);
187         uint256 x = getX(a, inputIndex, outputIndex, y, balances);
188         inputAmount = x.sub(balances[inputIndex]).add(1);
189     }
190 
191     /**
192      * @notice Calculate the relative price between two assets in given setup of balances and A
193      * @dev Uses 1e18 precision for balances, 1e2 for A
194      * @param balances array of balances
195      * @param a A parameter to be used in the calculation
196      * @param inputIndex index of the input token in the pool
197      * @param outputIndex index of the output token in the pool
198      * @return price relative price of output tokens per one input token
199      */
200     function relativePriceCustom(
201         uint256[] memory balances,
202         uint256 a,
203         uint256 inputIndex,
204         uint256 outputIndex
205     ) public pure returns (uint256 price) {
206         return
207             calculateSwapOutputCustom(
208                 balances,
209                 a,
210                 0,
211                 inputIndex,
212                 outputIndex,
213                 BALANCE_PRECISION
214             );
215     }
216 
217     /**
218      * @notice Add and registers a new pool. This function exist to cache decimal information.
219      * @param pool address of a pool contract that implements ISwap
220      */
221     function addPool(address pool) external payable {
222         uint256[] memory decimalsArr = new uint256[](MAX_TOKENS_LENGTH);
223 
224         for (uint256 i = 0; i < MAX_TOKENS_LENGTH; i++) {
225             try ISwap(pool).getToken(uint8(i)) returns (IERC20 token) {
226                 require(address(token) != address(0), "Token invalid");
227                 decimalsArr[i] = IERC20Decimals(address(token)).decimals();
228             } catch {
229                 assembly {
230                     mstore(decimalsArr, sub(mload(decimalsArr), sub(8, i)))
231                 }
232                 break;
233             }
234         }
235 
236         require(decimalsArr.length > 0, "Must call addPool() first");
237         storedDecimals[pool] = decimalsArr;
238     }
239 
240     /**
241      * @notice Get D, the StableSwap invariant, based on a set of balances and a particular A.
242      * @param xp a precision-adjusted set of pool balances. Array should be the same cardinality
243      * as the pool.
244      * @param a the amplification coefficient * n * (n - 1) in A_PRECISION.
245      * See the StableSwap paper for details
246      * @return the invariant, at the precision of the pool
247      */
248     function getD(uint256[] memory xp, uint256 a)
249         internal
250         pure
251         returns (uint256)
252     {
253         uint256 numTokens = xp.length;
254         uint256 s;
255         for (uint256 i = 0; i < numTokens; i++) {
256             s = s.add(xp[i]);
257         }
258         if (s == 0) {
259             return 0;
260         }
261 
262         uint256 prevD;
263         uint256 d = s;
264         uint256 nA = a.mul(numTokens);
265 
266         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
267             uint256 dP = d;
268             for (uint256 j = 0; j < numTokens; j++) {
269                 dP = dP.mul(d).div(xp[j].mul(numTokens));
270                 // If we were to protect the division loss we would have to keep the denominator separate
271                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
272                 // dP = dP * D * D * D * ... overflow!
273             }
274             prevD = d;
275             d = nA.mul(s).div(A_PRECISION).add(dP.mul(numTokens)).mul(d).div(
276                 nA.sub(A_PRECISION).mul(d).div(A_PRECISION).add(
277                     numTokens.add(1).mul(dP)
278                 )
279             );
280             if (d.within1(prevD)) {
281                 return d;
282             }
283         }
284 
285         // Convergence should occur in 4 loops or less. If this is reached, there may be something wrong
286         // with the pool. If this were to occur repeatedly, LPs should withdraw via `removeLiquidity()`
287         // function which does not rely on D.
288         revert("D does not converge");
289     }
290 
291     /**
292      * @notice Calculate the new balances of the tokens given the indexes of the token
293      * that is swapped from (FROM) and the token that is swapped to (TO).
294      * This function is used as a helper function to calculate how much TO token
295      * the user should receive on swap.
296      *
297      * @param preciseA precise form of amplification coefficient
298      * @param tokenIndexFrom index of FROM token
299      * @param tokenIndexTo index of TO token
300      * @param x the new total amount of FROM token
301      * @param xp balances of the tokens in the pool
302      * @return the amount of TO token that should remain in the pool
303      */
304     function getY(
305         uint256 preciseA,
306         uint256 tokenIndexFrom,
307         uint256 tokenIndexTo,
308         uint256 x,
309         uint256[] memory xp
310     ) internal pure returns (uint256) {
311         uint256 numTokens = xp.length;
312         require(
313             tokenIndexFrom != tokenIndexTo,
314             "Can't compare token to itself"
315         );
316         require(
317             tokenIndexFrom < numTokens && tokenIndexTo < numTokens,
318             "Tokens must be in pool"
319         );
320 
321         uint256 d = getD(xp, preciseA);
322         uint256 c = d;
323         uint256 s;
324         uint256 nA = numTokens.mul(preciseA);
325 
326         uint256 _x;
327         for (uint256 i = 0; i < numTokens; i++) {
328             if (i == tokenIndexFrom) {
329                 _x = x;
330             } else if (i != tokenIndexTo) {
331                 _x = xp[i];
332             } else {
333                 continue;
334             }
335             s = s.add(_x);
336             c = c.mul(d).div(_x.mul(numTokens));
337             // If we were to protect the division loss we would have to keep the denominator separate
338             // and divide at the end. However this leads to overflow with large numTokens or/and D.
339             // c = c * D * D * D * ... overflow!
340         }
341         c = c.mul(d).mul(A_PRECISION).div(nA.mul(numTokens));
342         uint256 b = s.add(d.mul(A_PRECISION).div(nA));
343         uint256 yPrev;
344         uint256 y = d;
345 
346         // iterative approximation
347         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
348             yPrev = y;
349             y = y.mul(y).add(c).div(y.mul(2).add(b).sub(d));
350             if (y.within1(yPrev)) {
351                 return y;
352             }
353         }
354         revert("Approximation did not converge");
355     }
356 
357     /**
358      * @notice Calculate the new balances of the tokens given the indexes of the token
359      * that is swapped from (FROM) and the token that is swapped to (TO).
360      * This function is used as a helper function to calculate how much FROM token
361      * the user will be required to transfer on swap.
362      *
363      * @param preciseA precise form of amplification coefficient
364      * @param tokenIndexFrom index of FROM token
365      * @param tokenIndexTo index of TO token
366      * @param y the new total amount of TO token
367      * @param xp balances of the tokens in the pool
368      * @return the amount of FROM token that will be required
369      */
370     function getX(
371         uint256 preciseA,
372         uint256 tokenIndexFrom,
373         uint256 tokenIndexTo,
374         uint256 y,
375         uint256[] memory xp
376     ) internal pure returns (uint256) {
377         return getY(preciseA, tokenIndexTo, tokenIndexFrom, y, xp);
378     }
379 }
