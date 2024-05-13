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
39 contract CauldronV2MultiChain is BoringOwnable, IMasterContract {
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
56     CauldronV2MultiChain public immutable masterContract;
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
83         uint64 INTEREST_PER_SECOND;
84     }
85 
86     AccrueInfo public accrueInfo;
87 
88     // Settings
89     uint256 public COLLATERIZATION_RATE;
90     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
91 
92     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
93 
94     uint256 public LIQUIDATION_MULTIPLIER; 
95     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
96 
97     uint256 public BORROW_OPENING_FEE;
98     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
99 
100     uint256 private constant DISTRIBUTION_PART = 10;
101     uint256 private constant DISTRIBUTION_PRECISION = 100;
102 
103     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
104     constructor(IBentoBoxV1 bentoBox_, IERC20 nxusd_) public {
105         bentoBox = bentoBox_;
106         nxusd = nxusd_;
107         masterContract = this;
108     }
109 
110     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
111     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
112     function init(bytes calldata data) public payable override {
113         require(address(collateral) == address(0), "Cauldron: already initialized");
114         (collateral, oracle, oracleData, accrueInfo.INTEREST_PER_SECOND, LIQUIDATION_MULTIPLIER, COLLATERIZATION_RATE, BORROW_OPENING_FEE) = abi.decode(data, (IERC20, IOracle, bytes, uint64, uint256, uint256, uint256));
115         require(address(collateral) != address(0), "Cauldron: bad pair");
116     }
117 
118     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
119     function accrue() public {
120         AccrueInfo memory _accrueInfo = accrueInfo;
121         // Number of seconds since accrue was called
122         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
123         if (elapsedTime == 0) {
124             return;
125         }
126         _accrueInfo.lastAccrued = uint64(block.timestamp);
127 
128         Rebase memory _totalBorrow = totalBorrow;
129         if (_totalBorrow.base == 0) {
130             accrueInfo = _accrueInfo;
131             return;
132         }
133 
134         // Accrue interest
135         uint128 extraAmount = (uint256(_totalBorrow.elastic).mul(_accrueInfo.INTEREST_PER_SECOND).mul(elapsedTime) / 1e18).to128();
136         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount);
137 
138         _accrueInfo.feesEarned = _accrueInfo.feesEarned.add(extraAmount);
139         totalBorrow = _totalBorrow;
140         accrueInfo = _accrueInfo;
141 
142         emit LogAccrue(extraAmount);
143     }
144 
145     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
146     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
147     function _isSolvent(address user, uint256 _exchangeRate) internal view returns (bool) {
148         // accrue must have already been called!
149         uint256 borrowPart = userBorrowPart[user];
150         if (borrowPart == 0) return true;
151         uint256 collateralShare = userCollateralShare[user];
152         if (collateralShare == 0) return false;
153 
154         Rebase memory _totalBorrow = totalBorrow;
155 
156         return
157             bentoBox.toAmount(
158                 collateral,
159                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(COLLATERIZATION_RATE),
160                 false
161             ) >=
162             // Moved exchangeRate here instead of dividing the other side to preserve more precision
163             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
164     }
165 
166     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
167     modifier solvent() {
168         _;
169         require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
170     }
171 
172     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
173     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
174     /// @return updated True if `exchangeRate` was updated.
175     /// @return rate The new exchange rate.
176     function updateExchangeRate() public returns (bool updated, uint256 rate) {
177         (updated, rate) = oracle.get(oracleData);
178 
179         if (updated) {
180             exchangeRate = rate;
181             emit LogExchangeRate(rate);
182         } else {
183             // Return the old rate if fetching wasn't successful
184             rate = exchangeRate;
185         }
186     }
187 
188     /// @dev Helper function to move tokens.
189     /// @param token The ERC-20 token.
190     /// @param share The amount in shares to add.
191     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
192     /// Only used for accounting checks.
193     /// @param skim If True, only does a balance check on this contract.
194     /// False if tokens from msg.sender in `bentoBox` should be transferred.
195     function _addTokens(
196         IERC20 token,
197         uint256 share,
198         uint256 total,
199         bool skim
200     ) internal {
201         if (skim) {
202             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "Cauldron: Skim too much");
203         } else {
204             bentoBox.transfer(token, msg.sender, address(this), share);
205         }
206     }
207 
208     /// @notice Adds `collateral` from msg.sender to the account `to`.
209     /// @param to The receiver of the tokens.
210     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.x
211     /// False if tokens from msg.sender in `bentoBox` should be transferred.
212     /// @param share The amount of shares to add for `to`.
213     function addCollateral(
214         address to,
215         bool skim,
216         uint256 share
217     ) public {
218         userCollateralShare[to] = userCollateralShare[to].add(share);
219         uint256 oldTotalCollateralShare = totalCollateralShare;
220         totalCollateralShare = oldTotalCollateralShare.add(share);
221         _addTokens(collateral, share, oldTotalCollateralShare, skim);
222         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share);
223     }
224 
225     /// @dev Concrete implementation of `removeCollateral`.
226     function _removeCollateral(address to, uint256 share) internal {
227         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
228         totalCollateralShare = totalCollateralShare.sub(share);
229         emit LogRemoveCollateral(msg.sender, to, share);
230         bentoBox.transfer(collateral, address(this), to, share);
231     }
232 
233     /// @notice Removes `share` amount of collateral and transfers it to `to`.
234     /// @param to The receiver of the shares.
235     /// @param share Amount of shares to remove.
236     function removeCollateral(address to, uint256 share) public solvent {
237         // accrue must be called because we check solvency
238         accrue();
239         _removeCollateral(to, share);
240     }
241 
242     /// @dev Concrete implementation of `borrow`.
243     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
244         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
245         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
246         accrueInfo.feesEarned = accrueInfo.feesEarned.add(uint128(feeAmount));
247         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
248 
249         // As long as there are tokens on this contract you can 'mint'... this enables limiting borrows
250         share = bentoBox.toShare(nxusd, amount, false);
251         bentoBox.transfer(nxusd, address(this), to, share);
252 
253         emit LogBorrow(msg.sender, to, amount.add(feeAmount), part);
254     }
255 
256     /// @notice Sender borrows `amount` and transfers it to `to`.
257     /// @return part Total part of the debt held by borrowers.
258     /// @return share Total amount in shares borrowed.
259     function borrow(address to, uint256 amount) public solvent returns (uint256 part, uint256 share) {
260         accrue();
261         (part, share) = _borrow(to, amount);
262     }
263 
264     /// @dev Concrete implementation of `repay`.
265     function _repay(
266         address to,
267         bool skim,
268         uint256 part
269     ) internal returns (uint256 amount) {
270         (totalBorrow, amount) = totalBorrow.sub(part, true);
271         userBorrowPart[to] = userBorrowPart[to].sub(part);
272 
273         uint256 share = bentoBox.toShare(nxusd, amount, true);
274         bentoBox.transfer(nxusd, skim ? address(bentoBox) : msg.sender, address(this), share);
275         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part);
276     }
277 
278     /// @notice Repays a loan.
279     /// @param to Address of the user this payment should go.
280     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
281     /// False if tokens from msg.sender in `bentoBox` should be transferred.
282     /// @param part The amount to repay. See `userBorrowPart`.
283     /// @return amount The total amount repayed.
284     function repay(
285         address to,
286         bool skim,
287         uint256 part
288     ) public returns (uint256 amount) {
289         accrue();
290         amount = _repay(to, skim, part);
291     }
292 
293     // Functions that need accrue to be called
294     uint8 internal constant ACTION_REPAY = 2;
295     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
296     uint8 internal constant ACTION_BORROW = 5;
297     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
298     uint8 internal constant ACTION_GET_REPAY_PART = 7;
299     uint8 internal constant ACTION_ACCRUE = 8;
300 
301     // Functions that don't need accrue to be called
302     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
303     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
304 
305     // Function on BentoBox
306     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
307     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
308     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
309     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
310     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
311 
312     // Any external call (except to BentoBox)
313     uint8 internal constant ACTION_CALL = 30;
314 
315     int256 internal constant USE_VALUE1 = -1;
316     int256 internal constant USE_VALUE2 = -2;
317 
318     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
319     function _num(
320         int256 inNum,
321         uint256 value1,
322         uint256 value2
323     ) internal pure returns (uint256 outNum) {
324         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
325     }
326 
327     /// @dev Helper function for depositing into `bentoBox`.
328     function _bentoDeposit(
329         bytes memory data,
330         uint256 value,
331         uint256 value1,
332         uint256 value2
333     ) internal returns (uint256, uint256) {
334         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
335         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
336         share = int256(_num(share, value1, value2));
337         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
338     }
339 
340     /// @dev Helper function to withdraw from the `bentoBox`.
341     function _bentoWithdraw(
342         bytes memory data,
343         uint256 value1,
344         uint256 value2
345     ) internal returns (uint256, uint256) {
346         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
347         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
348     }
349 
350     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
351     /// Calls to `bentoBox` are not allowed for obvious security reasons.
352     /// This also means that calls made from this contract shall *not* be trusted.
353     function _call(
354         uint256 value,
355         bytes memory data,
356         uint256 value1,
357         uint256 value2
358     ) internal returns (bytes memory, uint8) {
359         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
360             abi.decode(data, (address, bytes, bool, bool, uint8));
361 
362         if (useValue1 && !useValue2) {
363             callData = abi.encodePacked(callData, value1);
364         } else if (!useValue1 && useValue2) {
365             callData = abi.encodePacked(callData, value2);
366         } else if (useValue1 && useValue2) {
367             callData = abi.encodePacked(callData, value1, value2);
368         }
369 
370         require(callee != address(bentoBox) && callee != address(this), "Cauldron: can't call");
371 
372         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
373         require(success, "Cauldron: call failed");
374         return (returnData, returnValues);
375     }
376 
377     struct CookStatus {
378         bool needsSolvencyCheck;
379         bool hasAccrued;
380     }
381 
382     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
383     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
384     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
385     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
386     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
387     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
388     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
389     function cook(
390         uint8[] calldata actions,
391         uint256[] calldata values,
392         bytes[] calldata datas
393     ) external payable returns (uint256 value1, uint256 value2) {
394         CookStatus memory status;
395         for (uint256 i = 0; i < actions.length; i++) {
396             uint8 action = actions[i];
397             if (!status.hasAccrued && action < 10) {
398                 accrue();
399                 status.hasAccrued = true;
400             }
401             if (action == ACTION_ADD_COLLATERAL) {
402                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
403                 addCollateral(to, skim, _num(share, value1, value2));
404             } else if (action == ACTION_REPAY) {
405                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
406                 _repay(to, skim, _num(part, value1, value2));
407             } else if (action == ACTION_REMOVE_COLLATERAL) {
408                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
409                 _removeCollateral(to, _num(share, value1, value2));
410                 status.needsSolvencyCheck = true;
411             } else if (action == ACTION_BORROW) {
412                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
413                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
414                 status.needsSolvencyCheck = true;
415             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
416                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
417                 (bool updated, uint256 rate) = updateExchangeRate();
418                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "Cauldron: rate not ok");
419             } else if (action == ACTION_BENTO_SETAPPROVAL) {
420                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
421                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
422                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
423             } else if (action == ACTION_BENTO_DEPOSIT) {
424                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
425             } else if (action == ACTION_BENTO_WITHDRAW) {
426                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
427             } else if (action == ACTION_BENTO_TRANSFER) {
428                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
429                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
430             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
431                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
432                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
433             } else if (action == ACTION_CALL) {
434                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
435 
436                 if (returnValues == 1) {
437                     (value1) = abi.decode(returnData, (uint256));
438                 } else if (returnValues == 2) {
439                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
440                 }
441             } else if (action == ACTION_GET_REPAY_SHARE) {
442                 int256 part = abi.decode(datas[i], (int256));
443                 value1 = bentoBox.toShare(nxusd, totalBorrow.toElastic(_num(part, value1, value2), true), true);
444             } else if (action == ACTION_GET_REPAY_PART) {
445                 int256 amount = abi.decode(datas[i], (int256));
446                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
447             }
448         }
449 
450         if (status.needsSolvencyCheck) {
451             require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
452         }
453     }
454 
455     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
456     /// @param users An array of user addresses.
457     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
458     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
459     function liquidate(
460         address[] calldata users,
461         uint256[] calldata maxBorrowParts,
462         address to,
463         ISwapper swapper
464     ) public {
465         // Oracle can fail but we still need to allow liquidations
466         (, uint256 _exchangeRate) = updateExchangeRate();
467         accrue();
468 
469         uint256 allCollateralShare;
470         uint256 allBorrowAmount;
471         uint256 allBorrowPart;
472         Rebase memory _totalBorrow = totalBorrow;
473         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
474         for (uint256 i = 0; i < users.length; i++) {
475             address user = users[i];
476             if (!_isSolvent(user, _exchangeRate)) {
477                 uint256 borrowPart;
478                 {
479                     uint256 availableBorrowPart = userBorrowPart[user];
480                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
481                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
482                 }
483                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
484                 uint256 collateralShare =
485                     bentoBoxTotals.toBase(
486                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
487                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
488                         false
489                     );
490 
491                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
492                 emit LogRemoveCollateral(user, to, collateralShare);
493                 emit LogRepay(msg.sender, user, borrowAmount, borrowPart);
494 
495                 // Keep totals
496                 allCollateralShare = allCollateralShare.add(collateralShare);
497                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
498                 allBorrowPart = allBorrowPart.add(borrowPart);
499             }
500         }
501         require(allBorrowAmount != 0, "Cauldron: all are solvent");
502         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
503         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
504         totalBorrow = _totalBorrow;
505         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
506 
507         // Apply a percentual fee share to sSpell holders
508         
509         {
510             uint256 distributionAmount = (allBorrowAmount.mul(LIQUIDATION_MULTIPLIER) / LIQUIDATION_MULTIPLIER_PRECISION).sub(allBorrowAmount).mul(DISTRIBUTION_PART) / DISTRIBUTION_PRECISION; // Distribution Amount
511             allBorrowAmount = allBorrowAmount.add(distributionAmount);
512             accrueInfo.feesEarned = accrueInfo.feesEarned.add(distributionAmount.to128());
513         }
514 
515         uint256 allBorrowShare = bentoBox.toShare(nxusd, allBorrowAmount, true);
516 
517         // Swap using a swapper freely chosen by the caller
518         // Open (flash) liquidation: get proceeds first and provide the borrow after
519         bentoBox.transfer(collateral, address(this), to, allCollateralShare);
520         if (swapper != ISwapper(0)) {
521             swapper.swap(collateral, nxusd, msg.sender, allBorrowShare, allCollateralShare);
522         }
523 
524         bentoBox.transfer(nxusd, msg.sender, address(this), allBorrowShare);
525     }
526 
527     /// @notice Withdraws the fees accumulated.
528     function withdrawFees() public {
529         accrue();
530         address _feeTo = masterContract.feeTo();
531         uint256 _feesEarned = accrueInfo.feesEarned;
532         uint256 share = bentoBox.toShare(nxusd, _feesEarned, false);
533         bentoBox.transfer(nxusd, address(this), _feeTo, share);
534         accrueInfo.feesEarned = 0;
535 
536         emit LogWithdrawFees(_feeTo, _feesEarned);
537     }
538 
539     /// @notice Sets the beneficiary of interest accrued.
540     /// MasterContract Only Admin function.
541     /// @param newFeeTo The address of the receiver.
542     function setFeeTo(address newFeeTo) public onlyOwner {
543         feeTo = newFeeTo;
544         emit LogFeeTo(newFeeTo);
545     }
546 
547     /// @notice reduces the supply of MIM
548     /// @param amount amount to reduce supply by
549     function reduceSupply(uint256 amount) public {
550         require(msg.sender == masterContract.owner(), "Caller is not the owner");
551         bentoBox.withdraw(nxusd, address(this), masterContract.owner(), amount, 0);
552     }
553 }
