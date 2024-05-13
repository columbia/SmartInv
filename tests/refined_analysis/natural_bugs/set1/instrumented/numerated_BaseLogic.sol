1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./BaseModule.sol";
6 import "./BaseIRM.sol";
7 import "./Interfaces.sol";
8 import "./Utils.sol";
9 import "./vendor/RPow.sol";
10 import "./IRiskManager.sol";
11 
12 
13 abstract contract BaseLogic is BaseModule {
14     constructor(uint moduleId_, bytes32 moduleGitCommit_) BaseModule(moduleId_, moduleGitCommit_) {}
15 
16 
17     // Account auth
18 
19     function getSubAccount(address primary, uint subAccountId) internal pure returns (address) {
20         require(subAccountId < 256, "e/sub-account-id-too-big");
21         return address(uint160(primary) ^ uint160(subAccountId));
22     }
23 
24     function isSubAccountOf(address primary, address subAccount) internal pure returns (bool) {
25         return (uint160(primary) | 0xFF) == (uint160(subAccount) | 0xFF);
26     }
27 
28 
29 
30     // Entered markets array
31 
32     function getEnteredMarketsArray(address account) internal view returns (address[] memory) {
33         uint32 numMarketsEntered = accountLookup[account].numMarketsEntered;
34         address firstMarketEntered = accountLookup[account].firstMarketEntered;
35 
36         address[] memory output = new address[](numMarketsEntered);
37         if (numMarketsEntered == 0) return output;
38 
39         address[MAX_POSSIBLE_ENTERED_MARKETS] storage markets = marketsEntered[account];
40 
41         output[0] = firstMarketEntered;
42 
43         for (uint i = 1; i < numMarketsEntered; ++i) {
44             output[i] = markets[i];
45         }
46 
47         return output;
48     }
49 
50     function isEnteredInMarket(address account, address underlying) internal view returns (bool) {
51         uint32 numMarketsEntered = accountLookup[account].numMarketsEntered;
52         address firstMarketEntered = accountLookup[account].firstMarketEntered;
53 
54         if (numMarketsEntered == 0) return false;
55         if (firstMarketEntered == underlying) return true;
56 
57         address[MAX_POSSIBLE_ENTERED_MARKETS] storage markets = marketsEntered[account];
58 
59         for (uint i = 1; i < numMarketsEntered; ++i) {
60             if (markets[i] == underlying) return true;
61         }
62 
63         return false;
64     }
65 
66     function doEnterMarket(address account, address underlying) internal {
67         AccountStorage storage accountStorage = accountLookup[account];
68 
69         uint32 numMarketsEntered = accountStorage.numMarketsEntered;
70         address[MAX_POSSIBLE_ENTERED_MARKETS] storage markets = marketsEntered[account];
71 
72         if (numMarketsEntered != 0) {
73             if (accountStorage.firstMarketEntered == underlying) return; // already entered
74             for (uint i = 1; i < numMarketsEntered; i++) {
75                 if (markets[i] == underlying) return; // already entered
76             }
77         }
78 
79         require(numMarketsEntered < MAX_ENTERED_MARKETS, "e/too-many-entered-markets");
80 
81         if (numMarketsEntered == 0) accountStorage.firstMarketEntered = underlying;
82         else markets[numMarketsEntered] = underlying;
83 
84         accountStorage.numMarketsEntered = numMarketsEntered + 1;
85 
86         emit EnterMarket(underlying, account);
87     }
88 
89     // Liquidity check must be done by caller after calling this
90 
91     function doExitMarket(address account, address underlying) internal {
92         AccountStorage storage accountStorage = accountLookup[account];
93 
94         uint32 numMarketsEntered = accountStorage.numMarketsEntered;
95         address[MAX_POSSIBLE_ENTERED_MARKETS] storage markets = marketsEntered[account];
96         uint searchIndex = type(uint).max;
97 
98         if (numMarketsEntered == 0) return; // already exited
99 
100         if (accountStorage.firstMarketEntered == underlying) {
101             searchIndex = 0;
102         } else {
103             for (uint i = 1; i < numMarketsEntered; i++) {
104                 if (markets[i] == underlying) {
105                     searchIndex = i;
106                     break;
107                 }
108             }
109 
110             if (searchIndex == type(uint).max) return; // already exited
111         }
112 
113         uint lastMarketIndex = numMarketsEntered - 1;
114 
115         if (searchIndex != lastMarketIndex) {
116             if (searchIndex == 0) accountStorage.firstMarketEntered = markets[lastMarketIndex];
117             else markets[searchIndex] = markets[lastMarketIndex];
118         }
119 
120         accountStorage.numMarketsEntered = uint32(lastMarketIndex);
121 
122         if (lastMarketIndex != 0) markets[lastMarketIndex] = address(0); // zero out for storage refund
123 
124         emit ExitMarket(underlying, account);
125     }
126 
127 
128 
129     // AssetConfig
130 
131     function resolveAssetConfig(address underlying) internal view returns (AssetConfig memory) {
132         AssetConfig memory config = underlyingLookup[underlying];
133         require(config.eTokenAddress != address(0), "e/market-not-activated");
134 
135         if (config.borrowFactor == type(uint32).max) config.borrowFactor = DEFAULT_BORROW_FACTOR;
136         if (config.twapWindow == type(uint24).max) config.twapWindow = DEFAULT_TWAP_WINDOW_SECONDS;
137 
138         return config;
139     }
140 
141 
142     // AssetCache
143 
144     struct AssetCache {
145         address underlying;
146 
147         uint112 totalBalances;
148         uint144 totalBorrows;
149 
150         uint96 reserveBalance;
151 
152         uint interestAccumulator;
153 
154         uint40 lastInterestAccumulatorUpdate;
155         uint8 underlyingDecimals;
156         uint32 interestRateModel;
157         int96 interestRate;
158         uint32 reserveFee;
159         uint16 pricingType;
160         uint32 pricingParameters;
161 
162         uint poolSize; // result of calling balanceOf on underlying (in external units)
163 
164         uint underlyingDecimalsScaler;
165         uint maxExternalAmount;
166     }
167 
168     function initAssetCache(address underlying, AssetStorage storage assetStorage, AssetCache memory assetCache) internal view returns (bool dirty) {
169         dirty = false;
170 
171         assetCache.underlying = underlying;
172 
173         // Storage loads
174 
175         assetCache.lastInterestAccumulatorUpdate = assetStorage.lastInterestAccumulatorUpdate;
176         uint8 underlyingDecimals = assetCache.underlyingDecimals = assetStorage.underlyingDecimals;
177         assetCache.interestRateModel = assetStorage.interestRateModel;
178         assetCache.interestRate = assetStorage.interestRate;
179         assetCache.reserveFee = assetStorage.reserveFee;
180         assetCache.pricingType = assetStorage.pricingType;
181         assetCache.pricingParameters = assetStorage.pricingParameters;
182 
183         assetCache.reserveBalance = assetStorage.reserveBalance;
184 
185         assetCache.totalBalances = assetStorage.totalBalances;
186         assetCache.totalBorrows = assetStorage.totalBorrows;
187 
188         assetCache.interestAccumulator = assetStorage.interestAccumulator;
189 
190         // Derived state
191 
192         unchecked {
193             assetCache.underlyingDecimalsScaler = 10**(18 - underlyingDecimals);
194             assetCache.maxExternalAmount = MAX_SANE_AMOUNT / assetCache.underlyingDecimalsScaler;
195         }
196 
197         uint poolSize = callBalanceOf(assetCache, address(this));
198         if (poolSize <= assetCache.maxExternalAmount) {
199             unchecked { assetCache.poolSize = poolSize * assetCache.underlyingDecimalsScaler; }
200         } else {
201             assetCache.poolSize = 0;
202         }
203 
204         // Update interest accumulator and reserves
205 
206         if (block.timestamp != assetCache.lastInterestAccumulatorUpdate) {
207             dirty = true;
208 
209             uint deltaT = block.timestamp - assetCache.lastInterestAccumulatorUpdate;
210 
211             // Compute new values
212 
213             uint newInterestAccumulator = (RPow.rpow(uint(int(assetCache.interestRate) + 1e27), deltaT, 1e27) * assetCache.interestAccumulator) / 1e27;
214 
215             uint newTotalBorrows = assetCache.totalBorrows * newInterestAccumulator / assetCache.interestAccumulator;
216 
217             uint newReserveBalance = assetCache.reserveBalance;
218             uint newTotalBalances = assetCache.totalBalances;
219 
220             uint feeAmount = (newTotalBorrows - assetCache.totalBorrows)
221                                * (assetCache.reserveFee == type(uint32).max ? DEFAULT_RESERVE_FEE : assetCache.reserveFee)
222                                / (RESERVE_FEE_SCALE * INTERNAL_DEBT_PRECISION);
223 
224             if (feeAmount != 0) {
225                 uint poolAssets = assetCache.poolSize + (newTotalBorrows / INTERNAL_DEBT_PRECISION);
226                 newTotalBalances = poolAssets * newTotalBalances / (poolAssets - feeAmount);
227                 newReserveBalance += newTotalBalances - assetCache.totalBalances;
228             }
229 
230             // Store new values in assetCache, only if no overflows will occur
231 
232             if (newTotalBalances <= MAX_SANE_AMOUNT && newTotalBorrows <= MAX_SANE_DEBT_AMOUNT && newReserveBalance <= MAX_SANE_SMALL_AMOUNT) {
233                 assetCache.totalBorrows = encodeDebtAmount(newTotalBorrows);
234                 assetCache.interestAccumulator = newInterestAccumulator;
235                 assetCache.lastInterestAccumulatorUpdate = uint40(block.timestamp);
236 
237                 if (newTotalBalances != assetCache.totalBalances) {
238                     assetCache.reserveBalance = encodeSmallAmount(newReserveBalance);
239                     assetCache.totalBalances = encodeAmount(newTotalBalances);
240                 }
241             }
242         }
243     }
244 
245     function loadAssetCache(address underlying, AssetStorage storage assetStorage) internal returns (AssetCache memory assetCache) {
246         if (initAssetCache(underlying, assetStorage, assetCache)) {
247             assetStorage.lastInterestAccumulatorUpdate = assetCache.lastInterestAccumulatorUpdate;
248 
249             assetStorage.underlying = assetCache.underlying; // avoid an SLOAD of this slot
250             assetStorage.reserveBalance = assetCache.reserveBalance;
251 
252             assetStorage.totalBalances = assetCache.totalBalances;
253             assetStorage.totalBorrows = assetCache.totalBorrows;
254 
255             assetStorage.interestAccumulator = assetCache.interestAccumulator;
256         }
257     }
258 
259     function loadAssetCacheRO(address underlying, AssetStorage storage assetStorage) internal view returns (AssetCache memory assetCache) {
260         require(reentrancyLock == REENTRANCYLOCK__UNLOCKED, "e/ro-reentrancy");
261         initAssetCache(underlying, assetStorage, assetCache);
262     }
263 
264     function internalLoadAssetCacheRO(address underlying, AssetStorage storage assetStorage) internal view returns (AssetCache memory assetCache) {
265         initAssetCache(underlying, assetStorage, assetCache);
266     }
267 
268 
269 
270     // Utils
271 
272     function decodeExternalAmount(AssetCache memory assetCache, uint externalAmount) internal pure returns (uint scaledAmount) {
273         require(externalAmount <= assetCache.maxExternalAmount, "e/amount-too-large");
274         unchecked { scaledAmount = externalAmount * assetCache.underlyingDecimalsScaler; }
275     }
276 
277     function encodeAmount(uint amount) internal pure returns (uint112) {
278         require(amount <= MAX_SANE_AMOUNT, "e/amount-too-large-to-encode");
279         return uint112(amount);
280     }
281 
282     function encodeSmallAmount(uint amount) internal pure returns (uint96) {
283         require(amount <= MAX_SANE_SMALL_AMOUNT, "e/small-amount-too-large-to-encode");
284         return uint96(amount);
285     }
286 
287     function encodeDebtAmount(uint amount) internal pure returns (uint144) {
288         require(amount <= MAX_SANE_DEBT_AMOUNT, "e/debt-amount-too-large-to-encode");
289         return uint144(amount);
290     }
291 
292     function computeExchangeRate(AssetCache memory assetCache) private pure returns (uint) {
293         uint totalAssets = assetCache.poolSize + (assetCache.totalBorrows / INTERNAL_DEBT_PRECISION);
294         if (totalAssets == 0 || assetCache.totalBalances == 0) return 1e18;
295         return totalAssets * 1e18 / assetCache.totalBalances;
296     }
297 
298     function underlyingAmountToBalance(AssetCache memory assetCache, uint amount) internal pure returns (uint) {
299         uint exchangeRate = computeExchangeRate(assetCache);
300         return amount * 1e18 / exchangeRate;
301     }
302 
303     function underlyingAmountToBalanceRoundUp(AssetCache memory assetCache, uint amount) internal pure returns (uint) {
304         uint exchangeRate = computeExchangeRate(assetCache);
305         return (amount * 1e18 + (exchangeRate - 1)) / exchangeRate;
306     }
307 
308     function balanceToUnderlyingAmount(AssetCache memory assetCache, uint amount) internal pure returns (uint) {
309         uint exchangeRate = computeExchangeRate(assetCache);
310         return amount * exchangeRate / 1e18;
311     }
312 
313     function callBalanceOf(AssetCache memory assetCache, address account) internal view FREEMEM returns (uint) {
314         // We set a gas limit so that a malicious token can't eat up all gas and cause a liquidity check to fail.
315 
316         (bool success, bytes memory data) = assetCache.underlying.staticcall{gas: 200000}(abi.encodeWithSelector(IERC20.balanceOf.selector, account));
317 
318         // If token's balanceOf() call fails for any reason, return 0. This prevents malicious tokens from causing liquidity checks to fail.
319         // If the contract doesn't exist (maybe because selfdestructed), then data.length will be 0 and we will return 0.
320         // Data length > 32 is allowed because some legitimate tokens append extra data that can be safely ignored.
321 
322         if (!success || data.length < 32) return 0;
323 
324         return abi.decode(data, (uint256));
325     }
326 
327     function updateInterestRate(AssetStorage storage assetStorage, AssetCache memory assetCache) internal {
328         uint32 utilisation;
329 
330         {
331             uint totalBorrows = assetCache.totalBorrows / INTERNAL_DEBT_PRECISION;
332             uint poolAssets = assetCache.poolSize + totalBorrows;
333             if (poolAssets == 0) utilisation = 0; // empty pool arbitrarily given utilisation of 0
334             else utilisation = uint32(totalBorrows * (uint(type(uint32).max) * 1e18) / poolAssets / 1e18);
335         }
336 
337         bytes memory result = callInternalModule(assetCache.interestRateModel,
338                                                  abi.encodeWithSelector(BaseIRM.computeInterestRate.selector, assetCache.underlying, utilisation));
339 
340         (int96 newInterestRate) = abi.decode(result, (int96));
341 
342         assetStorage.interestRate = assetCache.interestRate = newInterestRate;
343     }
344 
345     function logAssetStatus(AssetCache memory a) internal {
346         emit AssetStatus(a.underlying, a.totalBalances, a.totalBorrows / INTERNAL_DEBT_PRECISION, a.reserveBalance, a.poolSize, a.interestAccumulator, a.interestRate, block.timestamp);
347     }
348 
349 
350 
351     // Balances
352 
353     function increaseBalance(AssetStorage storage assetStorage, AssetCache memory assetCache, address eTokenAddress, address account, uint amount) internal {
354         assetStorage.users[account].balance = encodeAmount(assetStorage.users[account].balance + amount);
355 
356         assetStorage.totalBalances = assetCache.totalBalances = encodeAmount(uint(assetCache.totalBalances) + amount);
357 
358         updateInterestRate(assetStorage, assetCache);
359 
360         emit Deposit(assetCache.underlying, account, amount);
361         emitViaProxy_Transfer(eTokenAddress, address(0), account, amount);
362     }
363 
364     function decreaseBalance(AssetStorage storage assetStorage, AssetCache memory assetCache, address eTokenAddress, address account, uint amount) internal {
365         uint origBalance = assetStorage.users[account].balance;
366         require(origBalance >= amount, "e/insufficient-balance");
367         assetStorage.users[account].balance = encodeAmount(origBalance - amount);
368 
369         assetStorage.totalBalances = assetCache.totalBalances = encodeAmount(assetCache.totalBalances - amount);
370 
371         updateInterestRate(assetStorage, assetCache);
372 
373         emit Withdraw(assetCache.underlying, account, amount);
374         emitViaProxy_Transfer(eTokenAddress, account, address(0), amount);
375     }
376 
377     function transferBalance(AssetStorage storage assetStorage, AssetCache memory assetCache, address eTokenAddress, address from, address to, uint amount) internal {
378         uint origFromBalance = assetStorage.users[from].balance;
379         require(origFromBalance >= amount, "e/insufficient-balance");
380         uint newFromBalance;
381         unchecked { newFromBalance = origFromBalance - amount; }
382 
383         assetStorage.users[from].balance = encodeAmount(newFromBalance);
384         assetStorage.users[to].balance = encodeAmount(assetStorage.users[to].balance + amount);
385 
386         emit Withdraw(assetCache.underlying, from, amount);
387         emit Deposit(assetCache.underlying, to, amount);
388         emitViaProxy_Transfer(eTokenAddress, from, to, amount);
389     }
390 
391     function withdrawAmounts(AssetStorage storage assetStorage, AssetCache memory assetCache, address account, uint amount) internal view returns (uint, uint) {
392         uint amountInternal;
393         if (amount == type(uint).max) {
394             amountInternal = assetStorage.users[account].balance;
395             amount = balanceToUnderlyingAmount(assetCache, amountInternal);
396         } else {
397             amount = decodeExternalAmount(assetCache, amount);
398             amountInternal = underlyingAmountToBalanceRoundUp(assetCache, amount);
399         }
400 
401         return (amount, amountInternal);
402     }
403 
404     // Borrows
405 
406     // Returns internal precision
407 
408     function getCurrentOwedExact(AssetStorage storage assetStorage, AssetCache memory assetCache, address account, uint owed) internal view returns (uint) {
409         // Don't bother loading the user's accumulator
410         if (owed == 0) return 0;
411 
412         // Can't divide by 0 here: If owed is non-zero, we must've initialised the user's interestAccumulator
413         return owed * assetCache.interestAccumulator / assetStorage.users[account].interestAccumulator;
414     }
415 
416     // When non-zero, we round *up* to the smallest external unit so that outstanding dust in a loan can be repaid.
417     // unchecked is OK here since owed is always loaded from storage, so we know it fits into a uint144 (pre-interest accural)
418     // Takes and returns 27 decimals precision.
419 
420     function roundUpOwed(AssetCache memory assetCache, uint owed) private pure returns (uint) {
421         if (owed == 0) return 0;
422 
423         unchecked {
424             uint scale = INTERNAL_DEBT_PRECISION * assetCache.underlyingDecimalsScaler;
425             return (owed + scale - 1) / scale * scale;
426         }
427     }
428 
429     // Returns 18-decimals precision (debt amount is rounded up)
430 
431     function getCurrentOwed(AssetStorage storage assetStorage, AssetCache memory assetCache, address account) internal view returns (uint) {
432         return roundUpOwed(assetCache, getCurrentOwedExact(assetStorage, assetCache, account, assetStorage.users[account].owed)) / INTERNAL_DEBT_PRECISION;
433     }
434 
435     function updateUserBorrow(AssetStorage storage assetStorage, AssetCache memory assetCache, address account) private returns (uint newOwedExact, uint prevOwedExact) {
436         prevOwedExact = assetStorage.users[account].owed;
437 
438         newOwedExact = getCurrentOwedExact(assetStorage, assetCache, account, prevOwedExact);
439 
440         assetStorage.users[account].owed = encodeDebtAmount(newOwedExact);
441         assetStorage.users[account].interestAccumulator = assetCache.interestAccumulator;
442     }
443 
444     function logBorrowChange(AssetCache memory assetCache, address dTokenAddress, address account, uint prevOwed, uint owed) private {
445         prevOwed = roundUpOwed(assetCache, prevOwed) / INTERNAL_DEBT_PRECISION;
446         owed = roundUpOwed(assetCache, owed) / INTERNAL_DEBT_PRECISION;
447 
448         if (owed > prevOwed) {
449             uint change = owed - prevOwed;
450             emit Borrow(assetCache.underlying, account, change);
451             emitViaProxy_Transfer(dTokenAddress, address(0), account, change / assetCache.underlyingDecimalsScaler);
452         } else if (prevOwed > owed) {
453             uint change = prevOwed - owed;
454             emit Repay(assetCache.underlying, account, change);
455             emitViaProxy_Transfer(dTokenAddress, account, address(0), change / assetCache.underlyingDecimalsScaler);
456         }
457     }
458 
459     function increaseBorrow(AssetStorage storage assetStorage, AssetCache memory assetCache, address dTokenAddress, address account, uint amount) internal {
460         amount *= INTERNAL_DEBT_PRECISION;
461 
462         require(assetCache.pricingType != PRICINGTYPE__FORWARDED || pTokenLookup[assetCache.underlying] == address(0), "e/borrow-not-supported");
463 
464         (uint owed, uint prevOwed) = updateUserBorrow(assetStorage, assetCache, account);
465 
466         if (owed == 0) doEnterMarket(account, assetCache.underlying);
467 
468         owed += amount;
469 
470         assetStorage.users[account].owed = encodeDebtAmount(owed);
471         assetStorage.totalBorrows = assetCache.totalBorrows = encodeDebtAmount(assetCache.totalBorrows + amount);
472 
473         updateInterestRate(assetStorage, assetCache);
474 
475         logBorrowChange(assetCache, dTokenAddress, account, prevOwed, owed);
476     }
477 
478     function decreaseBorrow(AssetStorage storage assetStorage, AssetCache memory assetCache, address dTokenAddress, address account, uint origAmount) internal {
479         uint amount = origAmount * INTERNAL_DEBT_PRECISION;
480 
481         (uint owed, uint prevOwed) = updateUserBorrow(assetStorage, assetCache, account);
482         uint owedRoundedUp = roundUpOwed(assetCache, owed);
483 
484         require(amount <= owedRoundedUp, "e/repay-too-much");
485         uint owedRemaining;
486         unchecked { owedRemaining = owedRoundedUp - amount; }
487 
488         if (owed > assetCache.totalBorrows) owed = assetCache.totalBorrows;
489 
490         assetStorage.users[account].owed = encodeDebtAmount(owedRemaining);
491         assetStorage.totalBorrows = assetCache.totalBorrows = encodeDebtAmount(assetCache.totalBorrows - owed + owedRemaining);
492 
493         updateInterestRate(assetStorage, assetCache);
494 
495         logBorrowChange(assetCache, dTokenAddress, account, prevOwed, owedRemaining);
496     }
497 
498     function transferBorrow(AssetStorage storage assetStorage, AssetCache memory assetCache, address dTokenAddress, address from, address to, uint origAmount) internal {
499         uint amount = origAmount * INTERNAL_DEBT_PRECISION;
500 
501         (uint fromOwed, uint fromOwedPrev) = updateUserBorrow(assetStorage, assetCache, from);
502         (uint toOwed, uint toOwedPrev) = updateUserBorrow(assetStorage, assetCache, to);
503 
504         if (toOwed == 0) doEnterMarket(to, assetCache.underlying);
505 
506         // If amount was rounded up, transfer exact amount owed
507         if (amount > fromOwed && amount - fromOwed < INTERNAL_DEBT_PRECISION * assetCache.underlyingDecimalsScaler) amount = fromOwed;
508 
509         require(fromOwed >= amount, "e/insufficient-balance");
510         unchecked { fromOwed -= amount; }
511 
512         // Transfer any residual dust
513         if (fromOwed < INTERNAL_DEBT_PRECISION) {
514             amount += fromOwed;
515             fromOwed = 0;
516         }
517 
518         toOwed += amount;
519 
520         assetStorage.users[from].owed = encodeDebtAmount(fromOwed);
521         assetStorage.users[to].owed = encodeDebtAmount(toOwed);
522 
523         logBorrowChange(assetCache, dTokenAddress, from, fromOwedPrev, fromOwed);
524         logBorrowChange(assetCache, dTokenAddress, to, toOwedPrev, toOwed);
525     }
526 
527 
528 
529     // Reserves
530 
531     function increaseReserves(AssetStorage storage assetStorage, AssetCache memory assetCache, uint amount) internal {
532         uint newReserveBalance = assetCache.reserveBalance + amount;
533         uint newTotalBalances = assetCache.totalBalances + amount;
534 
535         if (newReserveBalance <= MAX_SANE_SMALL_AMOUNT && newTotalBalances <= MAX_SANE_AMOUNT) {
536             assetStorage.reserveBalance = assetCache.reserveBalance = encodeSmallAmount(newReserveBalance);
537             assetStorage.totalBalances = assetCache.totalBalances = encodeAmount(newTotalBalances);
538         }
539     }
540 
541 
542 
543     // Token asset transfers
544 
545     // amounts are in underlying units
546 
547     function pullTokens(AssetCache memory assetCache, address from, uint amount) internal returns (uint amountTransferred) {
548         uint poolSizeBefore = assetCache.poolSize;
549 
550         Utils.safeTransferFrom(assetCache.underlying, from, address(this), amount / assetCache.underlyingDecimalsScaler);
551         uint poolSizeAfter = assetCache.poolSize = decodeExternalAmount(assetCache, callBalanceOf(assetCache, address(this)));
552 
553         require(poolSizeAfter >= poolSizeBefore, "e/negative-transfer-amount");
554         unchecked { amountTransferred = poolSizeAfter - poolSizeBefore; }
555     }
556 
557     function pushTokens(AssetCache memory assetCache, address to, uint amount) internal returns (uint amountTransferred) {
558         uint poolSizeBefore = assetCache.poolSize;
559 
560         Utils.safeTransfer(assetCache.underlying, to, amount / assetCache.underlyingDecimalsScaler);
561         uint poolSizeAfter = assetCache.poolSize = decodeExternalAmount(assetCache, callBalanceOf(assetCache, address(this)));
562 
563         require(poolSizeBefore >= poolSizeAfter, "e/negative-transfer-amount");
564         unchecked { amountTransferred = poolSizeBefore - poolSizeAfter; }
565     }
566 
567 
568 
569 
570     // Liquidity
571 
572     function getAssetPrice(address asset) internal returns (uint) {
573         bytes memory result = callInternalModule(MODULEID__RISK_MANAGER, abi.encodeWithSelector(IRiskManager.getPrice.selector, asset));
574         return abi.decode(result, (uint));
575     }
576 
577     function getAccountLiquidity(address account) internal returns (uint collateralValue, uint liabilityValue) {
578         bytes memory result = callInternalModule(MODULEID__RISK_MANAGER, abi.encodeWithSelector(IRiskManager.computeLiquidity.selector, account));
579         (IRiskManager.LiquidityStatus memory status) = abi.decode(result, (IRiskManager.LiquidityStatus));
580 
581         collateralValue = status.collateralValue;
582         liabilityValue = status.liabilityValue;
583     }
584 
585     function checkLiquidity(address account) internal {
586         uint8 status = accountLookup[account].deferLiquidityStatus;
587 
588         if (status == DEFERLIQUIDITY__NONE) {
589             callInternalModule(MODULEID__RISK_MANAGER, abi.encodeWithSelector(IRiskManager.requireLiquidity.selector, account));
590         } else if (status == DEFERLIQUIDITY__CLEAN) {
591             accountLookup[account].deferLiquidityStatus = DEFERLIQUIDITY__DIRTY;
592         }
593     }
594 
595 
596 
597     // Optional average liquidity tracking
598 
599     function computeNewAverageLiquidity(address account, uint deltaT) private returns (uint) {
600         uint currDuration = deltaT >= AVERAGE_LIQUIDITY_PERIOD ? AVERAGE_LIQUIDITY_PERIOD : deltaT;
601         uint prevDuration = AVERAGE_LIQUIDITY_PERIOD - currDuration;
602 
603         uint currAverageLiquidity;
604 
605         {
606             (uint collateralValue, uint liabilityValue) = getAccountLiquidity(account);
607             currAverageLiquidity = collateralValue > liabilityValue ? collateralValue - liabilityValue : 0;
608         }
609 
610         return (accountLookup[account].averageLiquidity * prevDuration / AVERAGE_LIQUIDITY_PERIOD) +
611                (currAverageLiquidity * currDuration / AVERAGE_LIQUIDITY_PERIOD);
612     }
613 
614     function getUpdatedAverageLiquidity(address account) internal returns (uint) {
615         uint lastAverageLiquidityUpdate = accountLookup[account].lastAverageLiquidityUpdate;
616         if (lastAverageLiquidityUpdate == 0) return 0;
617 
618         uint deltaT = block.timestamp - lastAverageLiquidityUpdate;
619         if (deltaT == 0) return accountLookup[account].averageLiquidity;
620 
621         return computeNewAverageLiquidity(account, deltaT);
622     }
623 
624     function getUpdatedAverageLiquidityWithDelegate(address account) internal returns (uint) {
625         address delegate = accountLookup[account].averageLiquidityDelegate;
626 
627         return delegate != address(0) && accountLookup[delegate].averageLiquidityDelegate == account
628             ? getUpdatedAverageLiquidity(delegate)
629             : getUpdatedAverageLiquidity(account);
630     }
631 
632     function updateAverageLiquidity(address account) internal {
633         uint lastAverageLiquidityUpdate = accountLookup[account].lastAverageLiquidityUpdate;
634         if (lastAverageLiquidityUpdate == 0) return;
635 
636         uint deltaT = block.timestamp - lastAverageLiquidityUpdate;
637         if (deltaT == 0) return;
638 
639         accountLookup[account].lastAverageLiquidityUpdate = uint40(block.timestamp);
640         accountLookup[account].averageLiquidity = computeNewAverageLiquidity(account, deltaT);
641     }
642 }
