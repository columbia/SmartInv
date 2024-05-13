1 // SPDX-License-Identifier: MIT
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.7.3;
17 pragma experimental ABIEncoderV2;
18 
19 import "@openzeppelin/contracts/math/SafeMath.sol";
20 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
21 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
22 
23 import "./Curve.sol";
24 
25 contract Zap {
26     using SafeMath for uint256;
27     using SafeERC20 for IERC20;
28 
29     IERC20 private constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
30 
31     struct ZapData {
32         address curve;
33         address base;
34         uint256 zapAmount;
35         uint256 curveBaseBal;
36         uint8 curveBaseDecimals;
37         uint256 curveQuoteBal;
38     }
39 
40     struct DepositData {
41         uint256 curBaseAmount;
42         uint256 curQuoteAmount;
43         uint256 maxBaseAmount;
44         uint256 maxQuoteAmount;
45     }
46 
47     /// @notice Zaps from a quote token (non-USDC) into the LP pool
48     /// @param _curve The address of the curve
49     /// @param _zapAmount The amount to zap, denominated in the ERC20's decimal placing
50     /// @param _deadline Deadline for this zap to be completed by
51     /// @param _minLPAmount Min LP amount to get
52     /// @return uint256 - The amount of LP tokens received
53     function zapFromBase(
54         address _curve,
55         uint256 _zapAmount,
56         uint256 _deadline,
57         uint256 _minLPAmount
58     ) public returns (uint256) {
59         return zap(_curve, _zapAmount, _deadline, _minLPAmount, true);
60     }
61 
62     /// @notice Zaps from a quote token (USDC) into the LP pool
63     /// @param _curve The address of the curve
64     /// @param _zapAmount The amount to zap, denominated in the ERC20's decimal placing
65     /// @param _deadline Deadline for this zap to be completed by
66     /// @param _minLPAmount Min LP amount to get
67     /// @return uint256 - The amount of LP tokens received
68     function zapFromQuote(
69         address _curve,
70         uint256 _zapAmount,
71         uint256 _deadline,
72         uint256 _minLPAmount
73     ) public returns (uint256) {
74         return zap(_curve, _zapAmount, _deadline, _minLPAmount, false);
75     }
76 
77     /// @notice Zaps from a single token into the LP pool
78     /// @param _curve The address of the curve
79     /// @param _zapAmount The amount to zap, denominated in the ERC20's decimal placing
80     /// @param _deadline Deadline for this zap to be completed by
81     /// @param _minLPAmount Min LP amount to get
82     /// @param isFromBase Is the zap originating from the base? (if base, then not USDC)
83     /// @return uint256 - The amount of LP tokens received
84     function zap(
85         address _curve,
86         uint256 _zapAmount,
87         uint256 _deadline,
88         uint256 _minLPAmount,
89         bool isFromBase
90     ) public returns (uint256) {
91         (address base, uint256 swapAmount) = calcSwapAmountForZap(_curve, _zapAmount, isFromBase);
92 
93         // Swap on curve
94         if (isFromBase) {
95             IERC20(base).safeTransferFrom(msg.sender, address(this), _zapAmount);
96             IERC20(base).safeApprove(_curve, 0);
97             IERC20(base).safeApprove(_curve, swapAmount);
98 
99             Curve(_curve).originSwap(base, address(USDC), swapAmount, 0, _deadline);
100         } else {
101             USDC.safeTransferFrom(msg.sender, address(this), _zapAmount);
102             USDC.safeApprove(_curve, 0);
103             USDC.safeApprove(_curve, swapAmount);
104 
105             Curve(_curve).originSwap(address(USDC), base, swapAmount, 0, _deadline);
106         }
107 
108         // Calculate deposit amount
109         uint256 baseAmount = IERC20(base).balanceOf(address(this));
110         uint256 quoteAmount = USDC.balanceOf(address(this));
111         (uint256 depositAmount, , ) =
112             _calcDepositAmount(
113                 _curve,
114                 base,
115                 DepositData({
116                     curBaseAmount: baseAmount,
117                     curQuoteAmount: quoteAmount,
118                     maxBaseAmount: baseAmount,
119                     maxQuoteAmount: quoteAmount
120                 })
121             );
122 
123         // Can only deposit the smaller amount as we won't have enough of the
124         // token to deposit
125         IERC20(base).safeApprove(_curve, 0);
126         IERC20(base).safeApprove(_curve, baseAmount);
127 
128         USDC.safeApprove(_curve, 0);
129         USDC.safeApprove(_curve, quoteAmount);
130 
131         (uint256 lpAmount, ) = Curve(_curve).deposit(depositAmount, _deadline);
132         require(lpAmount >= _minLPAmount, "!Zap/not-enough-lp-amount");
133 
134         // Transfer all remaining balances back to user
135         IERC20(_curve).transfer(msg.sender, IERC20(_curve).balanceOf(address(this)));
136         IERC20(base).transfer(msg.sender, IERC20(base).balanceOf(address(this)));
137         USDC.transfer(msg.sender, USDC.balanceOf(address(this)));
138 
139         return lpAmount;
140     }
141 
142     // **** View only functions **** //
143 
144     /// @notice Iteratively calculates how much base to swap
145     /// @param _curve The address of the curve
146     /// @param _zapAmount The amount to zap, denominated in the ERC20's decimal placing
147     /// @return uint256 - The amount to swap
148     function calcSwapAmountForZapFromBase(address _curve, uint256 _zapAmount) public view returns (uint256) {
149         (, uint256 ret) = calcSwapAmountForZap(_curve, _zapAmount, true);
150         return ret;
151     }
152 
153     /// @notice Iteratively calculates how much quote to swap
154     /// @param _curve The address of the curve
155     /// @param _zapAmount The amount to zap, denominated in the ERC20's decimal placing
156     /// @return uint256 - The amount to swap
157     function calcSwapAmountForZapFromQuote(address _curve, uint256 _zapAmount) public view returns (uint256) {
158         (, uint256 ret) = calcSwapAmountForZap(_curve, _zapAmount, false);
159         return ret;
160     }
161 
162     /// @notice Iteratively calculates how much to swap
163     /// @param _curve The address of the curve
164     /// @param _zapAmount The amount to zap, denominated in the ERC20's decimal placing
165     /// @param isFromBase Is the swap originating from the base?
166     /// @return address - The address of the base
167     /// @return uint256 - The amount to swap
168     function calcSwapAmountForZap(
169         address _curve,
170         uint256 _zapAmount,
171         bool isFromBase
172     ) public view returns (address, uint256) {
173         // Base will always be index 0
174         address base = Curve(_curve).reserves(0);
175 
176         // Ratio of base quote in 18 decimals
177         uint256 curveBaseBal = IERC20(base).balanceOf(_curve);
178         uint8 curveBaseDecimals = ERC20(base).decimals();
179         uint256 curveQuoteBal = USDC.balanceOf(_curve);
180 
181         // How much user wants to swap
182         uint256 initialSwapAmount = _zapAmount.div(2);
183 
184         // Calc Base Swap Amount
185         if (isFromBase) {
186             return (
187                 base,
188                 _calcBaseSwapAmount(
189                     initialSwapAmount,
190                     ZapData({
191                         curve: _curve,
192                         base: base,
193                         zapAmount: _zapAmount,
194                         curveBaseBal: curveBaseBal,
195                         curveBaseDecimals: curveBaseDecimals,
196                         curveQuoteBal: curveQuoteBal
197                     })
198                 )
199             );
200         }
201 
202         // Calc quote swap amount
203         return (
204             base,
205             _calcQuoteSwapAmount(
206                 initialSwapAmount,
207                 ZapData({
208                     curve: _curve,
209                     base: base,
210                     zapAmount: _zapAmount,
211                     curveBaseBal: curveBaseBal,
212                     curveBaseDecimals: curveBaseDecimals,
213                     curveQuoteBal: curveQuoteBal
214                 })
215             )
216         );
217     }
218 
219     // **** Helper functions ****
220 
221     /// @notice Given a quote amount, calculate the maximum deposit amount, along with the
222     ///         the number of LP tokens that will be generated, along with the maximized
223     ///         base/quote amounts
224     /// @param _curve The address of the curve
225     /// @param _quoteAmount The amount of quote tokens
226     /// @return uint256 - The deposit amount
227     /// @return uint256 - The LPTs received
228     /// @return uint256[] memory - The baseAmount and quoteAmount
229     function calcMaxDepositAmountGivenQuote(address _curve, uint256 _quoteAmount)
230         public
231         view
232         returns (
233             uint256,
234             uint256,
235             uint256[] memory
236         )
237     {
238         uint256 maxBaseAmount = calcMaxBaseForDeposit(_curve, _quoteAmount);
239         address base = Curve(_curve).reserves(0);
240 
241         return
242             _calcDepositAmount(
243                 _curve,
244                 base,
245                 DepositData({
246                     curBaseAmount: maxBaseAmount,
247                     curQuoteAmount: _quoteAmount,
248                     maxBaseAmount: maxBaseAmount,
249                     maxQuoteAmount: _quoteAmount
250                 })
251             );
252     }
253 
254     /// @notice Given a base amount, calculate the maximum deposit amount, along with the
255     ///         the number of LP tokens that will be generated, along with the maximized
256     ///         base/quote amounts
257     /// @param _curve The address of the curve
258     /// @param _baseAmount The amount of base tokens
259     /// @return uint256 - The deposit amount
260     /// @return uint256 - The LPTs received
261     /// @return uint256[] memory - The baseAmount and quoteAmount
262     function calcMaxDepositAmountGivenBase(address _curve, uint256 _baseAmount)
263         public
264         view
265         returns (
266             uint256,
267             uint256,
268             uint256[] memory
269         )
270     {
271         uint256 maxQuoteAmount = calcMaxQuoteForDeposit(_curve, _baseAmount);
272         address base = Curve(_curve).reserves(0);
273 
274         return
275             _calcDepositAmount(
276                 _curve,
277                 base,
278                 DepositData({
279                     curBaseAmount: _baseAmount,
280                     curQuoteAmount: maxQuoteAmount,
281                     maxBaseAmount: _baseAmount,
282                     maxQuoteAmount: maxQuoteAmount
283                 })
284             );
285     }
286 
287     /// @notice Given a base amount, calculate the max base amount to be deposited
288     /// @param _curve The address of the curve
289     /// @param _quoteAmount The amount of base tokens
290     /// @return uint256 - The max quote amount
291     function calcMaxBaseForDeposit(address _curve, uint256 _quoteAmount) public view returns (uint256) {
292         (, uint256[] memory outs) = Curve(_curve).viewDeposit(2e18);
293         uint256 baseAmount = outs[0].mul(_quoteAmount).div(1e6);
294 
295         return baseAmount;
296     }
297 
298     /// @notice Given a base amount, calculate the max quote amount to be deposited
299     /// @param _curve The address of the curve
300     /// @param _baseAmount The amount of quote tokens
301     /// @return uint256 - The max quote amount
302     function calcMaxQuoteForDeposit(address _curve, uint256 _baseAmount) public view returns (uint256) {
303         uint8 curveBaseDecimals = ERC20(Curve(_curve).reserves(0)).decimals();
304         (, uint256[] memory outs) = Curve(_curve).viewDeposit(2e18);
305         uint256 ratio = outs[0].mul(10**(36 - curveBaseDecimals)).div(outs[1].mul(1e12));
306         uint256 quoteAmount = _baseAmount.mul(10**(36 - curveBaseDecimals)).div(ratio).div(1e12);
307 
308         return quoteAmount;
309     }
310 
311     // **** Internal function ****
312 
313     // Stack too deep
314     function _roundDown(uint256 a) internal pure returns (uint256) {
315         return a.mul(99999999).div(100000000);
316     }
317 
318     /// @notice Calculate how many quote tokens needs to be swapped into base tokens to
319     ///         respect the pool's ratio
320     /// @param initialSwapAmount The initial amount to swap
321     /// @param zapData           Zap data encoded
322     /// @return uint256 - The amount of quote tokens to be swapped into base tokens
323     function _calcQuoteSwapAmount(uint256 initialSwapAmount, ZapData memory zapData) internal view returns (uint256) {
324         uint256 swapAmount = initialSwapAmount;
325         uint256 delta = initialSwapAmount.div(2);
326         uint256 recvAmount;
327         uint256 curveRatio;
328         uint256 userRatio;
329 
330         // Computer bring me magic number
331         for (uint256 i = 0; i < 32; i++) {
332             // How much will we receive in return
333             recvAmount = Curve(zapData.curve).viewOriginSwap(address(USDC), zapData.base, swapAmount);
334 
335             // Update user's ratio
336             userRatio = recvAmount.mul(10**(36 - uint256(zapData.curveBaseDecimals))).div(
337                 zapData.zapAmount.sub(swapAmount).mul(1e12)
338             );
339             curveRatio = zapData.curveBaseBal.sub(recvAmount).mul(10**(36 - uint256(zapData.curveBaseDecimals))).div(
340                 zapData.curveQuoteBal.add(swapAmount).mul(1e12)
341             );
342 
343             // If user's ratio is approx curve ratio, then just swap
344             // I.e. ratio converges
345             if (userRatio.div(1e16) == curveRatio.div(1e16)) {
346                 return swapAmount;
347             }
348             // Otherwise, we keep iterating
349             else if (userRatio > curveRatio) {
350                 // We swapping too much
351                 swapAmount = swapAmount.sub(delta);
352             } else if (userRatio < curveRatio) {
353                 // We swapping too little
354                 swapAmount = swapAmount.add(delta);
355             }
356 
357             // Cannot swap more than zapAmount
358             if (swapAmount > zapData.zapAmount) {
359                 swapAmount = zapData.zapAmount - 1;
360             }
361 
362             // Keep halving
363             delta = delta.div(2);
364         }
365 
366         revert("Zap/not-converging");
367     }
368 
369     /// @notice Calculate how many base tokens needs to be swapped into quote tokens to
370     ///         respect the pool's ratio
371     /// @param initialSwapAmount The initial amount to swap
372     /// @param zapData           Zap data encoded
373     /// @return uint256 - The amount of base tokens to be swapped into quote tokens
374     function _calcBaseSwapAmount(uint256 initialSwapAmount, ZapData memory zapData) internal view returns (uint256) {
375         uint256 swapAmount = initialSwapAmount;
376         uint256 delta = initialSwapAmount.div(2);
377         uint256 recvAmount;
378         uint256 curveRatio;
379         uint256 userRatio;
380 
381         // Computer bring me magic number
382         for (uint256 i = 0; i < 32; i++) {
383             // How much will we receive in return
384             recvAmount = Curve(zapData.curve).viewOriginSwap(zapData.base, address(USDC), swapAmount);
385 
386             // Update user's ratio
387             userRatio = zapData.zapAmount.sub(swapAmount).mul(10**(36 - uint256(zapData.curveBaseDecimals))).div(
388                 recvAmount.mul(1e12)
389             );
390             curveRatio = zapData.curveBaseBal.add(swapAmount).mul(10**(36 - uint256(zapData.curveBaseDecimals))).div(
391                 zapData.curveQuoteBal.sub(recvAmount).mul(1e12)
392             );
393 
394             // If user's ratio is approx curve ratio, then just swap
395             // I.e. ratio converges
396             if (userRatio.div(1e16) == curveRatio.div(1e16)) {
397                 return swapAmount;
398             }
399             // Otherwise, we keep iterating
400             else if (userRatio > curveRatio) {
401                 // We swapping too little
402                 swapAmount = swapAmount.add(delta);
403             } else if (userRatio < curveRatio) {
404                 // We swapping too much
405                 swapAmount = swapAmount.sub(delta);
406             }
407 
408             // Cannot swap more than zap
409             if (swapAmount > zapData.zapAmount) {
410                 swapAmount = zapData.zapAmount - 1;
411             }
412 
413             // Keep halving
414             delta = delta.div(2);
415         }
416 
417         revert("Zap/not-converging");
418     }
419 
420     /// @notice Given a DepositData structure, calculate the max depositAmount, the max
421     ///          LP tokens received, and the required amounts
422     /// @param _curve The address of the curve
423     /// @param _base  The base address in the curve
424     /// @param dd     Deposit data
425 
426     /// @return uint256 - The deposit amount
427     /// @return uint256 - The LPTs received
428     /// @return uint256[] memory - The baseAmount and quoteAmount
429     function _calcDepositAmount(
430         address _curve,
431         address _base,
432         DepositData memory dd
433     )
434         internal
435         view
436         returns (
437             uint256,
438             uint256,
439             uint256[] memory
440         )
441     {
442         // Calculate _depositAmount
443         uint8 curveBaseDecimals = ERC20(_base).decimals();
444         uint256 curveRatio =
445             IERC20(_base).balanceOf(_curve).mul(10**(36 - uint256(curveBaseDecimals))).div(
446                 USDC.balanceOf(_curve).mul(1e12)
447             );
448 
449         // Deposit amount is denomiated in USD value (based on pool LP ratio)
450         // Things are 1:1 on USDC side on deposit
451         uint256 usdcDepositAmount = dd.curQuoteAmount.mul(1e12);
452 
453         // Things will be based on ratio on deposit
454         uint256 baseDepositAmount = dd.curBaseAmount.mul(10**(18 - uint256(curveBaseDecimals)));
455 
456         // Trim out decimal values
457         uint256 depositAmount = usdcDepositAmount.add(baseDepositAmount.mul(1e18).div(curveRatio));
458         depositAmount = _roundDown(depositAmount);
459 
460         // // Make sure we have enough of our inputs
461         (uint256 lps, uint256[] memory outs) = Curve(_curve).viewDeposit(depositAmount);
462 
463         uint256 baseDelta = outs[0] > dd.maxBaseAmount ? outs[0].sub(dd.curBaseAmount) : 0;
464         uint256 usdcDelta = outs[1] > dd.maxQuoteAmount ? outs[1].sub(dd.curQuoteAmount) : 0;
465 
466         // Make sure we can deposit
467         if (baseDelta > 0 || usdcDelta > 0) {
468             dd.curBaseAmount = _roundDown(dd.curBaseAmount.sub(baseDelta));
469             dd.curQuoteAmount = _roundDown(dd.curQuoteAmount.sub(usdcDelta));
470 
471             return _calcDepositAmount(_curve, _base, dd);
472         }
473 
474         return (depositAmount, lps, outs);
475     }
476 }
