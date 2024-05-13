1 // SPDX-License-Identifier: UNLICENSED
2 
3 // Cauldron
4 
5 //    (                (   (
6 //    )\      )    (   )\  )\ )  (
7 //  (((_)  ( /(   ))\ ((_)(()/(  )(    (    (
8 //  )\___  )(_)) /((_) _   ((_))(()\   )\   )\ )
9 // ((/ __|((_)_ (_))( | |  _| |  ((_) ((_) _(_/(
10 //  | (__ / _` || || || |/ _` | | '_|/ _ \| ' \))
11 //   \___|\__,_| \_,_||_|\__,_| |_|  \___/|_||_|
12 
13 // Copyright (c) 2021 BoringCrypto - All rights reserved
14 // Twitter: @Boring_Crypto
15 
16 // Special thanks to:
17 // @0xKeno - for all his invaluable contributions
18 // @burger_crypto - for the idea of trying to let the LPs benefit from liquidations
19 
20 pragma solidity 0.6.12;
21 pragma experimental ABIEncoderV2;
22 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
23 import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
24 import "@boringcrypto/boring-solidity/contracts/ERC20.sol";
25 import "@boringcrypto/boring-solidity/contracts/interfaces/IMasterContract.sol";
26 import "@boringcrypto/boring-solidity/contracts/libraries/BoringRebase.sol";
27 import "@boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol";
28 import "@sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol";
29 import "./NXUSD.sol";
30 import "./interfaces/IOracle.sol";
31 import "./interfaces/ISwapper.sol";
32 
33 // solhint-disable avoid-low-level-calls
34 // solhint-disable no-inline-assembly
35 
36 /// @title Cauldron
37 /// @dev This contract allows contract calls to any contract (except BentoBox)
38 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
39 contract Cauldron is BoringOwnable, IMasterContract {
40     using BoringMath for uint256;
41     using BoringMath128 for uint128;
42     using RebaseLibrary for Rebase;
43     using BoringERC20 for IERC20;
44 
45     event LogExchangeRate(uint256 rate);
46     event LogAccrue(uint128 accruedAmount);
47     event LogAddCollateral(address indexed from, address indexed to, uint256 share);
48     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share);
49     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 part);
50     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part);
51     event LogFeeTo(address indexed newFeeTo);
52     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
53 
54     // Immutables (for MasterContract and all clones)
55     IBentoBoxV1 public immutable bentoBox;
56     Cauldron public immutable masterContract;
57     IERC20 public immutable nxusd;
58 
59     // MasterContract variables
60     address public feeTo;
61 
62     // Per clone variables
63     // Clone init settings
64     IERC20 public collateral;
65     IOracle public oracle;
66     bytes public oracleData;
67 
68     // Total amounts
69     uint256 public totalCollateralShare; // Total collateral supplied
70     Rebase public totalBorrow; // elastic = Total token amount to be repayed by borrowers, base = Total parts of the debt held by borrowers
71 
72     // User balances
73     mapping(address => uint256) public userCollateralShare;
74     mapping(address => uint256) public userBorrowPart;
75 
76     /// @notice Exchange and interest rate tracking.
77     /// This is 'cached' here because calls to Oracles can be very expensive.
78     uint256 public exchangeRate;
79 
80     struct AccrueInfo {
81         uint64 lastAccrued;
82         uint128 feesEarned;
83     }
84 
85     AccrueInfo public accrueInfo;
86 
87     // Settings
88     uint256 private constant INTEREST_PER_SECOND = 317097920;
89 
90     uint256 private constant COLLATERIZATION_RATE = 75000; // 75%
91     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
92 
93     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
94 
95     uint256 private constant LIQUIDATION_MULTIPLIER = 112000; // add 12%
96     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
97 
98     uint256 private constant BORROW_OPENING_FEE = 50; // 0.05%
99     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
100 
101     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
102     constructor(IBentoBoxV1 bentoBox_, IERC20 nxusd_) public {
103         bentoBox = bentoBox_;
104         nxusd = nxusd_;
105         masterContract = this;
106     }
107 
108     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
109     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
110     function init(bytes calldata data) public payable override {
111         require(address(collateral) == address(0), "Cauldron: already initialized");
112         (collateral, oracle, oracleData) = abi.decode(data, (IERC20, IOracle, bytes));
113         require(address(collateral) != address(0), "Cauldron: bad pair");
114     }
115 
116     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
117     function accrue() public {
118         AccrueInfo memory _accrueInfo = accrueInfo;
119         // Number of seconds since accrue was called
120         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
121         if (elapsedTime == 0) {
122             return;
123         }
124         _accrueInfo.lastAccrued = uint64(block.timestamp);
125 
126         Rebase memory _totalBorrow = totalBorrow;
127         if (_totalBorrow.base == 0) {
128             accrueInfo = _accrueInfo;
129             return;
130         }
131 
132         // Accrue interest
133         uint128 extraAmount = (uint256(_totalBorrow.elastic).mul(INTEREST_PER_SECOND).mul(elapsedTime) / 1e18).to128();
134         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount);
135 
136         _accrueInfo.feesEarned = _accrueInfo.feesEarned.add(extraAmount);
137         totalBorrow = _totalBorrow;
138         accrueInfo = _accrueInfo;
139 
140         emit LogAccrue(extraAmount);
141     }
142 
143     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
144     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
145     function _isSolvent(address user, uint256 _exchangeRate) internal view returns (bool) {
146         // accrue must have already been called!
147         uint256 borrowPart = userBorrowPart[user];
148         if (borrowPart == 0) return true;
149         uint256 collateralShare = userCollateralShare[user];
150         if (collateralShare == 0) return false;
151 
152         Rebase memory _totalBorrow = totalBorrow;
153 
154         return
155             bentoBox.toAmount(
156                 collateral,
157                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(COLLATERIZATION_RATE),
158                 false
159             ) >=
160             // Moved exchangeRate here instead of dividing the other side to preserve more precision
161             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
162     }
163 
164     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
165     modifier solvent() {
166         _;
167         require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
168     }
169 
170     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
171     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
172     /// @return updated True if `exchangeRate` was updated.
173     /// @return rate The new exchange rate.
174     function updateExchangeRate() public returns (bool updated, uint256 rate) {
175         (updated, rate) = oracle.get(oracleData);
176 
177         if (updated) {
178             exchangeRate = rate;
179             emit LogExchangeRate(rate);
180         } else {
181             // Return the old rate if fetching wasn't successful
182             rate = exchangeRate;
183         }
184     }
185 
186     /// @dev Helper function to move tokens.
187     /// @param token The ERC-20 token.
188     /// @param share The amount in shares to add.
189     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
190     /// Only used for accounting checks.
191     /// @param skim If True, only does a balance check on this contract.
192     /// False if tokens from msg.sender in `bentoBox` should be transferred.
193     function _addTokens(
194         IERC20 token,
195         uint256 share,
196         uint256 total,
197         bool skim
198     ) internal {
199         if (skim) {
200             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "Cauldron: Skim too much");
201         } else {
202             bentoBox.transfer(token, msg.sender, address(this), share);
203         }
204     }
205 
206     /// @notice Adds `collateral` from msg.sender to the account `to`.
207     /// @param to The receiver of the tokens.
208     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.x
209     /// False if tokens from msg.sender in `bentoBox` should be transferred.
210     /// @param share The amount of shares to add for `to`.
211     function addCollateral(
212         address to,
213         bool skim,
214         uint256 share
215     ) public {
216         userCollateralShare[to] = userCollateralShare[to].add(share);
217         uint256 oldTotalCollateralShare = totalCollateralShare;
218         totalCollateralShare = oldTotalCollateralShare.add(share);
219         _addTokens(collateral, share, oldTotalCollateralShare, skim);
220         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share);
221     }
222 
223     /// @dev Concrete implementation of `removeCollateral`.
224     function _removeCollateral(address to, uint256 share) internal {
225         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
226         totalCollateralShare = totalCollateralShare.sub(share);
227         emit LogRemoveCollateral(msg.sender, to, share);
228         bentoBox.transfer(collateral, address(this), to, share);
229     }
230 
231     /// @notice Removes `share` amount of collateral and transfers it to `to`.
232     /// @param to The receiver of the shares.
233     /// @param share Amount of shares to remove.
234     function removeCollateral(address to, uint256 share) public solvent {
235         // accrue must be called because we check solvency
236         accrue();
237         _removeCollateral(to, share);
238     }
239 
240     /// @dev Concrete implementation of `borrow`.
241     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
242         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
243         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
244         accrueInfo.feesEarned = accrueInfo.feesEarned.add(uint128(feeAmount));
245         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
246 
247         // As long as there are tokens on this contract you can 'mint'... this enables limiting borrows
248         share = bentoBox.toShare(nxusd, amount, false);
249         bentoBox.transfer(nxusd, address(this), to, share);
250 
251         emit LogBorrow(msg.sender, to, amount.add(feeAmount), part);
252     }
253 
254     /// @notice Sender borrows `amount` and transfers it to `to`.
255     /// @return part Total part of the debt held by borrowers.
256     /// @return share Total amount in shares borrowed.
257     function borrow(address to, uint256 amount) public solvent returns (uint256 part, uint256 share) {
258         accrue();
259         (part, share) = _borrow(to, amount);
260     }
261 
262     /// @dev Concrete implementation of `repay`.
263     function _repay(
264         address to,
265         bool skim,
266         uint256 part
267     ) internal returns (uint256 amount) {
268         (totalBorrow, amount) = totalBorrow.sub(part, true);
269         userBorrowPart[to] = userBorrowPart[to].sub(part);
270 
271         uint256 share = bentoBox.toShare(nxusd, amount, true);
272         bentoBox.transfer(nxusd, skim ? address(bentoBox) : msg.sender, address(this), share);
273         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part);
274     }
275 
276     /// @notice Repays a loan.
277     /// @param to Address of the user this payment should go.
278     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
279     /// False if tokens from msg.sender in `bentoBox` should be transferred.
280     /// @param part The amount to repay. See `userBorrowPart`.
281     /// @return amount The total amount repayed.
282     function repay(
283         address to,
284         bool skim,
285         uint256 part
286     ) public returns (uint256 amount) {
287         accrue();
288         amount = _repay(to, skim, part);
289     }
290 
291     // Functions that need accrue to be called
292     uint8 internal constant ACTION_REPAY = 2;
293     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
294     uint8 internal constant ACTION_BORROW = 5;
295     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
296     uint8 internal constant ACTION_GET_REPAY_PART = 7;
297     uint8 internal constant ACTION_ACCRUE = 8;
298 
299     // Functions that don't need accrue to be called
300     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
301     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
302 
303     // Function on BentoBox
304     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
305     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
306     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
307     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
308     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
309 
310     // Any external call (except to BentoBox)
311     uint8 internal constant ACTION_CALL = 30;
312 
313     int256 internal constant USE_VALUE1 = -1;
314     int256 internal constant USE_VALUE2 = -2;
315 
316     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
317     function _num(
318         int256 inNum,
319         uint256 value1,
320         uint256 value2
321     ) internal pure returns (uint256 outNum) {
322         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
323     }
324 
325     /// @dev Helper function for depositing into `bentoBox`.
326     function _bentoDeposit(
327         bytes memory data,
328         uint256 value,
329         uint256 value1,
330         uint256 value2
331     ) internal returns (uint256, uint256) {
332         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
333         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
334         share = int256(_num(share, value1, value2));
335         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
336     }
337 
338     /// @dev Helper function to withdraw from the `bentoBox`.
339     function _bentoWithdraw(
340         bytes memory data,
341         uint256 value1,
342         uint256 value2
343     ) internal returns (uint256, uint256) {
344         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
345         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
346     }
347 
348     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
349     /// Calls to `bentoBox` are not allowed for obvious security reasons.
350     /// This also means that calls made from this contract shall *not* be trusted.
351     function _call(
352         uint256 value,
353         bytes memory data,
354         uint256 value1,
355         uint256 value2
356     ) internal returns (bytes memory, uint8) {
357         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
358             abi.decode(data, (address, bytes, bool, bool, uint8));
359 
360         if (useValue1 && !useValue2) {
361             callData = abi.encodePacked(callData, value1);
362         } else if (!useValue1 && useValue2) {
363             callData = abi.encodePacked(callData, value2);
364         } else if (useValue1 && useValue2) {
365             callData = abi.encodePacked(callData, value1, value2);
366         }
367 
368         require(callee != address(bentoBox) && callee != address(this), "Cauldron: can't call");
369 
370         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
371         require(success, "Cauldron: call failed");
372         return (returnData, returnValues);
373     }
374 
375     struct CookStatus {
376         bool needsSolvencyCheck;
377         bool hasAccrued;
378     }
379 
380     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
381     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
382     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
383     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
384     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
385     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
386     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
387     function cook(
388         uint8[] calldata actions,
389         uint256[] calldata values,
390         bytes[] calldata datas
391     ) external payable returns (uint256 value1, uint256 value2) {
392         CookStatus memory status;
393         for (uint256 i = 0; i < actions.length; i++) {
394             uint8 action = actions[i];
395             if (!status.hasAccrued && action < 10) {
396                 accrue();
397                 status.hasAccrued = true;
398             }
399             if (action == ACTION_ADD_COLLATERAL) {
400                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
401                 addCollateral(to, skim, _num(share, value1, value2));
402             } else if (action == ACTION_REPAY) {
403                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
404                 _repay(to, skim, _num(part, value1, value2));
405             } else if (action == ACTION_REMOVE_COLLATERAL) {
406                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
407                 _removeCollateral(to, _num(share, value1, value2));
408                 status.needsSolvencyCheck = true;
409             } else if (action == ACTION_BORROW) {
410                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
411                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
412                 status.needsSolvencyCheck = true;
413             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
414                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
415                 (bool updated, uint256 rate) = updateExchangeRate();
416                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "Cauldron: rate not ok");
417             } else if (action == ACTION_BENTO_SETAPPROVAL) {
418                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
419                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
420                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
421             } else if (action == ACTION_BENTO_DEPOSIT) {
422                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
423             } else if (action == ACTION_BENTO_WITHDRAW) {
424                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
425             } else if (action == ACTION_BENTO_TRANSFER) {
426                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
427                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
428             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
429                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
430                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
431             } else if (action == ACTION_CALL) {
432                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
433 
434                 if (returnValues == 1) {
435                     (value1) = abi.decode(returnData, (uint256));
436                 } else if (returnValues == 2) {
437                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
438                 }
439             } else if (action == ACTION_GET_REPAY_SHARE) {
440                 int256 part = abi.decode(datas[i], (int256));
441                 value1 = bentoBox.toShare(nxusd, totalBorrow.toElastic(_num(part, value1, value2), true), true);
442             } else if (action == ACTION_GET_REPAY_PART) {
443                 int256 amount = abi.decode(datas[i], (int256));
444                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
445             }
446         }
447 
448         if (status.needsSolvencyCheck) {
449             require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
450         }
451     }
452 
453     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
454     /// @param users An array of user addresses.
455     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
456     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
457     function liquidate(
458         address[] calldata users,
459         uint256[] calldata maxBorrowParts,
460         address to,
461         ISwapper swapper
462     ) public {
463         // Oracle can fail but we still need to allow liquidations
464         (, uint256 _exchangeRate) = updateExchangeRate();
465         accrue();
466 
467         uint256 allCollateralShare;
468         uint256 allBorrowAmount;
469         uint256 allBorrowPart;
470         Rebase memory _totalBorrow = totalBorrow;
471         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
472         for (uint256 i = 0; i < users.length; i++) {
473             address user = users[i];
474             if (!_isSolvent(user, _exchangeRate)) {
475                 uint256 borrowPart;
476                 {
477                     uint256 availableBorrowPart = userBorrowPart[user];
478                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
479                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
480                 }
481                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
482                 uint256 collateralShare =
483                     bentoBoxTotals.toBase(
484                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
485                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
486                         false
487                     );
488 
489                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
490                 emit LogRemoveCollateral(user, to, collateralShare);
491                 emit LogRepay(msg.sender, user, borrowAmount, borrowPart);
492 
493                 // Keep totals
494                 allCollateralShare = allCollateralShare.add(collateralShare);
495                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
496                 allBorrowPart = allBorrowPart.add(borrowPart);
497             }
498         }
499         require(allBorrowAmount != 0, "Cauldron: all are solvent");
500         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
501         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
502         totalBorrow = _totalBorrow;
503         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
504 
505         uint256 allBorrowShare = bentoBox.toShare(nxusd, allBorrowAmount, true);
506 
507         // Swap using a swapper freely chosen by the caller
508         // Open (flash) liquidation: get proceeds first and provide the borrow after
509         bentoBox.transfer(collateral, address(this), to, allCollateralShare);
510         if (swapper != ISwapper(0)) {
511             swapper.swap(collateral, nxusd, msg.sender, allBorrowShare, allCollateralShare);
512         }
513 
514         bentoBox.transfer(nxusd, msg.sender, address(this), allBorrowShare);
515     }
516 
517     /// @notice Withdraws the fees accumulated.
518     function withdrawFees() public {
519         accrue();
520         address _feeTo = masterContract.feeTo();
521         uint256 _feesEarned = accrueInfo.feesEarned;
522         uint256 share = bentoBox.toShare(nxusd, _feesEarned, false);
523         bentoBox.transfer(nxusd, address(this), _feeTo, share);
524         accrueInfo.feesEarned = 0;
525 
526         emit LogWithdrawFees(_feeTo, _feesEarned);
527     }
528 
529     /// @notice Sets the beneficiary of interest accrued.
530     /// MasterContract Only Admin function.
531     /// @param newFeeTo The address of the receiver.
532     function setFeeTo(address newFeeTo) public onlyOwner {
533         feeTo = newFeeTo;
534         emit LogFeeTo(newFeeTo);
535     }
536 
537     /// @notice reduces the supply of MIM
538     /// @param amount amount to reduce supply by
539     function reduceSupply(uint256 amount) public {
540         require(msg.sender == masterContract.owner(), "Caller is not the owner");
541         bentoBox.withdraw(nxusd, address(this), address(this), amount, 0);
542         NXUSD(address(nxusd)).burn(amount);
543     }
544 }
