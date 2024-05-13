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
32 import "./interfaces/ICheckpointToken.sol";
33 
34 // solhint-disable avoid-low-level-calls
35 // solhint-disable no-inline-assembly
36 
37 /// @title Cauldron
38 /// @dev This contract allows contract calls to any contract (except BentoBox)
39 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
40 contract CauldronV2Checkpoint is BoringOwnable, IMasterContract {
41     using BoringMath for uint256;
42     using BoringMath128 for uint128;
43     using RebaseLibrary for Rebase;
44     using BoringERC20 for IERC20;
45 
46     event LogExchangeRate(uint256 rate);
47     event LogAccrue(uint128 accruedAmount);
48     event LogAddCollateral(address indexed from, address indexed to, uint256 share);
49     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share);
50     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 part);
51     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part);
52     event LogFeeTo(address indexed newFeeTo);
53     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
54 
55     // Immutables (for MasterContract and all clones)
56     IBentoBoxV1 public immutable bentoBox;
57     CauldronV2Checkpoint public immutable masterContract;
58     IERC20 public immutable nxusd;
59 
60     // MasterContract variables
61     address public feeTo;
62 
63     // Per clone variables
64     // Clone init settings
65     IERC20 public collateral;
66     IOracle public oracle;
67     bytes public oracleData;
68 
69     // Total amounts
70     uint256 public totalCollateralShare; // Total collateral supplied
71     Rebase public totalBorrow; // elastic = Total token amount to be repayed by borrowers, base = Total parts of the debt held by borrowers
72 
73     // User balances
74     mapping(address => uint256) public userCollateralShare;
75     mapping(address => uint256) public userBorrowPart;
76 
77     /// @notice Exchange and interest rate tracking.
78     /// This is 'cached' here because calls to Oracles can be very expensive.
79     uint256 public exchangeRate;
80 
81     struct AccrueInfo {
82         uint64 lastAccrued;
83         uint128 feesEarned;
84         uint64 INTEREST_PER_SECOND;
85     }
86 
87     AccrueInfo public accrueInfo;
88 
89     // Settings
90     uint256 public COLLATERIZATION_RATE;
91     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
92 
93     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
94 
95     uint256 public LIQUIDATION_MULTIPLIER; 
96     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
97 
98     uint256 public BORROW_OPENING_FEE;
99     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
100 
101     uint256 private constant DISTRIBUTION_PART = 10;
102     uint256 private constant DISTRIBUTION_PRECISION = 100;
103 
104     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
105     constructor(IBentoBoxV1 bentoBox_, IERC20 nxusd_) public {
106         bentoBox = bentoBox_;
107         nxusd = nxusd_;
108         masterContract = this;
109     }
110 
111     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
112     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
113     function init(bytes calldata data) public payable override {
114         require(address(collateral) == address(0), "Cauldron: already initialized");
115         (collateral, oracle, oracleData, accrueInfo.INTEREST_PER_SECOND, LIQUIDATION_MULTIPLIER, COLLATERIZATION_RATE, BORROW_OPENING_FEE) = abi.decode(data, (IERC20, IOracle, bytes, uint64, uint256, uint256, uint256));
116         require(address(collateral) != address(0), "Cauldron: bad pair");
117     }
118 
119     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
120     function accrue() public {
121         AccrueInfo memory _accrueInfo = accrueInfo;
122         // Number of seconds since accrue was called
123         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
124         if (elapsedTime == 0) {
125             return;
126         }
127         _accrueInfo.lastAccrued = uint64(block.timestamp);
128 
129         Rebase memory _totalBorrow = totalBorrow;
130         if (_totalBorrow.base == 0) {
131             accrueInfo = _accrueInfo;
132             return;
133         }
134 
135         // Accrue interest
136         uint128 extraAmount = (uint256(_totalBorrow.elastic).mul(_accrueInfo.INTEREST_PER_SECOND).mul(elapsedTime) / 1e18).to128();
137         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount);
138 
139         _accrueInfo.feesEarned = _accrueInfo.feesEarned.add(extraAmount);
140         totalBorrow = _totalBorrow;
141         accrueInfo = _accrueInfo;
142 
143         emit LogAccrue(extraAmount);
144     }
145 
146     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
147     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
148     function _isSolvent(address user, uint256 _exchangeRate) internal view returns (bool) {
149         // accrue must have already been called!
150         uint256 borrowPart = userBorrowPart[user];
151         if (borrowPart == 0) return true;
152         uint256 collateralShare = userCollateralShare[user];
153         if (collateralShare == 0) return false;
154 
155         Rebase memory _totalBorrow = totalBorrow;
156 
157         return
158             bentoBox.toAmount(
159                 collateral,
160                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(COLLATERIZATION_RATE),
161                 false
162             ) >=
163             // Moved exchangeRate here instead of dividing the other side to preserve more precision
164             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
165     }
166 
167     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
168     modifier solvent() {
169         _;
170         require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
171     }
172 
173     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
174     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
175     /// @return updated True if `exchangeRate` was updated.
176     /// @return rate The new exchange rate.
177     function updateExchangeRate() public returns (bool updated, uint256 rate) {
178         (updated, rate) = oracle.get(oracleData);
179 
180         if (updated) {
181             exchangeRate = rate;
182             emit LogExchangeRate(rate);
183         } else {
184             // Return the old rate if fetching wasn't successful
185             rate = exchangeRate;
186         }
187     }
188 
189     /// @dev Helper function to move tokens.
190     /// @param token The ERC-20 token.
191     /// @param share The amount in shares to add.
192     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
193     /// Only used for accounting checks.
194     /// @param skim If True, only does a balance check on this contract.
195     /// False if tokens from msg.sender in `bentoBox` should be transferred.
196     function _addTokens(
197         IERC20 token,
198         uint256 share,
199         uint256 total,
200         bool skim
201     ) internal {
202         if (skim) {
203             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "Cauldron: Skim too much");
204         } else {
205             bentoBox.transfer(token, msg.sender, address(this), share);
206         }
207     }
208 
209     /// @notice Adds `collateral` from msg.sender to the account `to`.
210     /// @param to The receiver of the tokens.
211     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.x
212     /// False if tokens from msg.sender in `bentoBox` should be transferred.
213     /// @param share The amount of shares to add for `to`.
214     function addCollateral(
215         address to,
216         bool skim,
217         uint256 share
218     ) public {
219         //checkpoint before userCollateralShare is changed
220         ICheckpointToken(address(collateral)).user_checkpoint([to,address(0)]);
221 
222         userCollateralShare[to] = userCollateralShare[to].add(share);
223         uint256 oldTotalCollateralShare = totalCollateralShare;
224         totalCollateralShare = oldTotalCollateralShare.add(share);
225         _addTokens(collateral, share, oldTotalCollateralShare, skim);
226         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share);
227     }
228 
229     /// @dev Concrete implementation of `removeCollateral`.
230     function _removeCollateral(address to, uint256 share) internal {
231         //checkpoint before userCollateralShare is changed
232         ICheckpointToken(address(collateral)).user_checkpoint([address(msg.sender),address(0)]);
233 
234         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
235         totalCollateralShare = totalCollateralShare.sub(share);
236         emit LogRemoveCollateral(msg.sender, to, share);
237         bentoBox.transfer(collateral, address(this), to, share);
238     }
239 
240     /// @notice Removes `share` amount of collateral and transfers it to `to`.
241     /// @param to The receiver of the shares.
242     /// @param share Amount of shares to remove.
243     function removeCollateral(address to, uint256 share) public solvent {
244         // accrue must be called because we check solvency
245         accrue();
246         _removeCollateral(to, share);
247     }
248 
249     /// @dev Concrete implementation of `borrow`.
250     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
251         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
252         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
253         accrueInfo.feesEarned = accrueInfo.feesEarned.add(uint128(feeAmount));
254         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
255 
256         // As long as there are tokens on this contract you can 'mint'... this enables limiting borrows
257         share = bentoBox.toShare(nxusd, amount, false);
258         bentoBox.transfer(nxusd, address(this), to, share);
259 
260         emit LogBorrow(msg.sender, to, amount.add(feeAmount), part);
261     }
262 
263     /// @notice Sender borrows `amount` and transfers it to `to`.
264     /// @return part Total part of the debt held by borrowers.
265     /// @return share Total amount in shares borrowed.
266     function borrow(address to, uint256 amount) public solvent returns (uint256 part, uint256 share) {
267         accrue();
268         (part, share) = _borrow(to, amount);
269     }
270 
271     /// @dev Concrete implementation of `repay`.
272     function _repay(
273         address to,
274         bool skim,
275         uint256 part
276     ) internal returns (uint256 amount) {
277         (totalBorrow, amount) = totalBorrow.sub(part, true);
278         userBorrowPart[to] = userBorrowPart[to].sub(part);
279 
280         uint256 share = bentoBox.toShare(nxusd, amount, true);
281         bentoBox.transfer(nxusd, skim ? address(bentoBox) : msg.sender, address(this), share);
282         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part);
283     }
284 
285     /// @notice Repays a loan.
286     /// @param to Address of the user this payment should go.
287     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
288     /// False if tokens from msg.sender in `bentoBox` should be transferred.
289     /// @param part The amount to repay. See `userBorrowPart`.
290     /// @return amount The total amount repayed.
291     function repay(
292         address to,
293         bool skim,
294         uint256 part
295     ) public returns (uint256 amount) {
296         accrue();
297         amount = _repay(to, skim, part);
298     }
299 
300     // Functions that need accrue to be called
301     uint8 internal constant ACTION_REPAY = 2;
302     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
303     uint8 internal constant ACTION_BORROW = 5;
304     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
305     uint8 internal constant ACTION_GET_REPAY_PART = 7;
306     uint8 internal constant ACTION_ACCRUE = 8;
307 
308     // Functions that don't need accrue to be called
309     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
310     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
311 
312     // Function on BentoBox
313     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
314     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
315     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
316     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
317     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
318 
319     // Any external call (except to BentoBox)
320     uint8 internal constant ACTION_CALL = 30;
321 
322     int256 internal constant USE_VALUE1 = -1;
323     int256 internal constant USE_VALUE2 = -2;
324 
325     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
326     function _num(
327         int256 inNum,
328         uint256 value1,
329         uint256 value2
330     ) internal pure returns (uint256 outNum) {
331         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
332     }
333 
334     /// @dev Helper function for depositing into `bentoBox`.
335     function _bentoDeposit(
336         bytes memory data,
337         uint256 value,
338         uint256 value1,
339         uint256 value2
340     ) internal returns (uint256, uint256) {
341         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
342         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
343         share = int256(_num(share, value1, value2));
344         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
345     }
346 
347     /// @dev Helper function to withdraw from the `bentoBox`.
348     function _bentoWithdraw(
349         bytes memory data,
350         uint256 value1,
351         uint256 value2
352     ) internal returns (uint256, uint256) {
353         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
354         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
355     }
356 
357     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
358     /// Calls to `bentoBox` are not allowed for obvious security reasons.
359     /// This also means that calls made from this contract shall *not* be trusted.
360     function _call(
361         uint256 value,
362         bytes memory data,
363         uint256 value1,
364         uint256 value2
365     ) internal returns (bytes memory, uint8) {
366         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
367             abi.decode(data, (address, bytes, bool, bool, uint8));
368 
369         if (useValue1 && !useValue2) {
370             callData = abi.encodePacked(callData, value1);
371         } else if (!useValue1 && useValue2) {
372             callData = abi.encodePacked(callData, value2);
373         } else if (useValue1 && useValue2) {
374             callData = abi.encodePacked(callData, value1, value2);
375         }
376 
377         require(callee != address(bentoBox) && callee != address(this), "Cauldron: can't call");
378 
379         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
380         require(success, "Cauldron: call failed");
381         return (returnData, returnValues);
382     }
383 
384     struct CookStatus {
385         bool needsSolvencyCheck;
386         bool hasAccrued;
387     }
388 
389     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
390     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
391     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
392     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
393     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
394     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
395     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
396     function cook(
397         uint8[] calldata actions,
398         uint256[] calldata values,
399         bytes[] calldata datas
400     ) external payable returns (uint256 value1, uint256 value2) {
401         CookStatus memory status;
402         for (uint256 i = 0; i < actions.length; i++) {
403             uint8 action = actions[i];
404             if (!status.hasAccrued && action < 10) {
405                 accrue();
406                 status.hasAccrued = true;
407             }
408             if (action == ACTION_ADD_COLLATERAL) {
409                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
410                 addCollateral(to, skim, _num(share, value1, value2));
411             } else if (action == ACTION_REPAY) {
412                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
413                 _repay(to, skim, _num(part, value1, value2));
414             } else if (action == ACTION_REMOVE_COLLATERAL) {
415                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
416                 _removeCollateral(to, _num(share, value1, value2));
417                 status.needsSolvencyCheck = true;
418             } else if (action == ACTION_BORROW) {
419                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
420                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
421                 status.needsSolvencyCheck = true;
422             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
423                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
424                 (bool updated, uint256 rate) = updateExchangeRate();
425                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "Cauldron: rate not ok");
426             } else if (action == ACTION_BENTO_SETAPPROVAL) {
427                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
428                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
429                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
430             } else if (action == ACTION_BENTO_DEPOSIT) {
431                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
432             } else if (action == ACTION_BENTO_WITHDRAW) {
433                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
434             } else if (action == ACTION_BENTO_TRANSFER) {
435                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
436                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
437             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
438                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
439                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
440             } else if (action == ACTION_CALL) {
441                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
442 
443                 if (returnValues == 1) {
444                     (value1) = abi.decode(returnData, (uint256));
445                 } else if (returnValues == 2) {
446                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
447                 }
448             } else if (action == ACTION_GET_REPAY_SHARE) {
449                 int256 part = abi.decode(datas[i], (int256));
450                 value1 = bentoBox.toShare(nxusd, totalBorrow.toElastic(_num(part, value1, value2), true), true);
451             } else if (action == ACTION_GET_REPAY_PART) {
452                 int256 amount = abi.decode(datas[i], (int256));
453                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
454             }
455         }
456 
457         if (status.needsSolvencyCheck) {
458             require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
459         }
460     }
461 
462     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
463     /// @param users An array of user addresses.
464     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
465     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
466     function liquidate(
467         address[] calldata users,
468         uint256[] calldata maxBorrowParts,
469         address to,
470         ISwapper swapper
471     ) public {
472         // Oracle can fail but we still need to allow liquidations
473         (, uint256 _exchangeRate) = updateExchangeRate();
474         accrue();
475 
476         uint256 allCollateralShare;
477         uint256 allBorrowAmount;
478         uint256 allBorrowPart;
479         Rebase memory _totalBorrow = totalBorrow;
480         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
481         for (uint256 i = 0; i < users.length; i++) {
482             address user = users[i];
483             if (!_isSolvent(user, _exchangeRate)) {
484                 uint256 borrowPart;
485                 {
486                     uint256 availableBorrowPart = userBorrowPart[user];
487                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
488                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
489                 }
490                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
491                 uint256 collateralShare =
492                     bentoBoxTotals.toBase(
493                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
494                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
495                         false
496                     );
497 
498                 //checkpoint before userCollateralShare is changed
499                 ICheckpointToken(address(collateral)).user_checkpoint([user,address(0)]);
500                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
501                 emit LogRemoveCollateral(user, to, collateralShare);
502                 emit LogRepay(msg.sender, user, borrowAmount, borrowPart);
503 
504                 // Keep totals
505                 allCollateralShare = allCollateralShare.add(collateralShare);
506                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
507                 allBorrowPart = allBorrowPart.add(borrowPart);
508             }
509         }
510         require(allBorrowAmount != 0, "Cauldron: all are solvent");
511         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
512         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
513         totalBorrow = _totalBorrow;
514         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
515 
516         // Apply a percentual fee share to sSpell holders
517         
518         {
519             uint256 distributionAmount = (allBorrowAmount.mul(LIQUIDATION_MULTIPLIER) / LIQUIDATION_MULTIPLIER_PRECISION).sub(allBorrowAmount).mul(DISTRIBUTION_PART) / DISTRIBUTION_PRECISION; // Distribution Amount
520             allBorrowAmount = allBorrowAmount.add(distributionAmount);
521             accrueInfo.feesEarned = accrueInfo.feesEarned.add(distributionAmount.to128());
522         }
523 
524         uint256 allBorrowShare = bentoBox.toShare(nxusd, allBorrowAmount, true);
525 
526         // Swap using a swapper freely chosen by the caller
527         // Open (flash) liquidation: get proceeds first and provide the borrow after
528         bentoBox.transfer(collateral, address(this), to, allCollateralShare);
529         if (swapper != ISwapper(0)) {
530             swapper.swap(collateral, nxusd, msg.sender, allBorrowShare, allCollateralShare);
531         }
532 
533         bentoBox.transfer(nxusd, msg.sender, address(this), allBorrowShare);
534     }
535 
536     /// @notice Withdraws the fees accumulated.
537     function withdrawFees() public {
538         accrue();
539         address _feeTo = masterContract.feeTo();
540         uint256 _feesEarned = accrueInfo.feesEarned;
541         uint256 share = bentoBox.toShare(nxusd, _feesEarned, false);
542         bentoBox.transfer(nxusd, address(this), _feeTo, share);
543         accrueInfo.feesEarned = 0;
544 
545         emit LogWithdrawFees(_feeTo, _feesEarned);
546     }
547 
548     /// @notice Sets the beneficiary of interest accrued.
549     /// MasterContract Only Admin function.
550     /// @param newFeeTo The address of the receiver.
551     function setFeeTo(address newFeeTo) public onlyOwner {
552         feeTo = newFeeTo;
553         emit LogFeeTo(newFeeTo);
554     }
555 
556     /// @notice reduces the supply of MIM
557     /// @param amount amount to reduce supply by
558     function reduceSupply(uint256 amount) public {
559         require(msg.sender == masterContract.owner(), "Caller is not the owner");
560         bentoBox.withdraw(nxusd, address(this), address(this), amount, 0);
561         NXUSD(address(nxusd)).burn(amount);
562     }
563 }
