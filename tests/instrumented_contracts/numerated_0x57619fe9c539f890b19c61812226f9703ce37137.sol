1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.10;
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library Math {
10     /**
11      * @dev Returns the largest of two numbers.
12      */
13     function max(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a >= b ? a : b;
15     }
16 
17     /**
18      * @dev Returns the smallest of two numbers.
19      */
20     function min(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a < b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the average of two numbers. The result is rounded towards
26      * zero.
27      */
28     function average(uint256 a, uint256 b) internal pure returns (uint256) {
29         // (a + b) / 2 can overflow.
30         return (a & b) + (a ^ b) / 2;
31     }
32 
33     /**
34      * @dev Returns the ceiling of the division of two numbers.
35      *
36      * This differs from standard division with `/` in that it rounds up instead
37      * of rounding down.
38      */
39     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
40         // (a + b - 1) / b can overflow on addition, so we distribute.
41         return a / b + (a % b == 0 ? 0 : 1);
42     }
43 }
44 
45 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
46 
47 /**
48  * @dev Interface of the ERC20 standard as defined in the EIP.
49  */
50 interface IERC20 {
51     /**
52      * @dev Returns the amount of tokens in existence.
53      */
54     function totalSupply() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens owned by `account`.
58      */
59     function balanceOf(address account) external view returns (uint256);
60 
61     /**
62      * @dev Moves `amount` tokens from the caller's account to `to`.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transfer(address to, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Returns the remaining number of tokens that `spender` will be
72      * allowed to spend on behalf of `owner` through {transferFrom}. This is
73      * zero by default.
74      *
75      * This value changes when {approve} or {transferFrom} are called.
76      */
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     /**
80      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * IMPORTANT: Beware that changing an allowance with this method brings the risk
85      * that someone may use both the old and the new allowance by unfortunate
86      * transaction ordering. One possible solution to mitigate this race
87      * condition is to first reduce the spender's allowance to 0 and set the
88      * desired value afterwards:
89      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90      *
91      * Emits an {Approval} event.
92      */
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Moves `amount` tokens from `from` to `to` using the
97      * allowance mechanism. `amount` is then deducted from the caller's
98      * allowance.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 amount
108     ) external returns (bool);
109 
110     /**
111      * @dev Emitted when `value` tokens are moved from one account (`from`) to
112      * another (`to`).
113      *
114      * Note that `value` may be zero.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     /**
119      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
120      * a call to {approve}. `value` is the new allowance.
121      */
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 contract BaseMath {
126     uint constant public DECIMAL_PRECISION = 1e18;
127 }
128 
129 // taken from: https://github.com/liquity/dev/blob/8371355b2f11bee9fa599f9223f4c2f6f429351f/packages/contracts/contracts/Dependencies/LiquityMath.sol
130 contract ChickenMath is BaseMath {
131 
132     /*
133      * Multiply two decimal numbers and use normal rounding rules:
134      * -round product up if 19'th mantissa digit >= 5
135      * -round product down if 19'th mantissa digit < 5
136      *
137      * Used only inside the exponentiation, decPow().
138      */
139     function decMul(uint256 x, uint256 y) internal pure returns (uint256) {
140         return (x * y + DECIMAL_PRECISION / 2) / DECIMAL_PRECISION;
141     }
142 
143     /*
144      * decPow: Exponentiation function for 18-digit decimal base, and integer exponent n.
145      *
146      * Uses the efficient "exponentiation by squaring" algorithm. O(log(n)) complexity.
147      *
148      * Called by ChickenBondManager.calcRedemptionFeePercentage, that represents time in units of minutes:
149      *
150      * The exponent is capped to avoid reverting due to overflow. The cap 525600000 equals
151      * "minutes in 1000 years": 60 * 24 * 365 * 1000
152      *
153      * If a period of > 1000 years is ever used as an exponent in either of the above functions, the result will be
154      * negligibly different from just passing the cap, since:
155      * the decayed base rate will be 0 for 1000 years or > 1000 years
156      */
157     function decPow(uint256 _base, uint256 _exponent) internal pure returns (uint) {
158 
159         if (_exponent > 525600000) {_exponent = 525600000;}  // cap to avoid overflow
160 
161         if (_exponent == 0) {return DECIMAL_PRECISION;}
162 
163         uint256 y = DECIMAL_PRECISION;
164         uint256 x = _base;
165         uint256 n = _exponent;
166 
167         // Exponentiation-by-squaring
168         while (n > 1) {
169             if (n % 2 != 0) {
170                 y = decMul(x, y);
171             }
172             x = decMul(x, x);
173             n = n / 2;
174         }
175 
176         return decMul(x, y);
177     }
178 }
179 
180 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
181 
182 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
185 
186 /**
187  * @dev Interface of the ERC165 standard, as defined in the
188  * https://eips.ethereum.org/EIPS/eip-165[EIP].
189  *
190  * Implementers can declare support of contract interfaces, which can then be
191  * queried by others ({ERC165Checker}).
192  *
193  * For an implementation, see {ERC165}.
194  */
195 interface IERC165 {
196     /**
197      * @dev Returns true if this contract implements the interface defined by
198      * `interfaceId`. See the corresponding
199      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
200      * to learn more about how these ids are created.
201      *
202      * This function call must use less than 30 000 gas.
203      */
204     function supportsInterface(bytes4 interfaceId) external view returns (bool);
205 }
206 
207 /**
208  * @dev Required interface of an ERC721 compliant contract.
209  */
210 interface IERC721 is IERC165 {
211     /**
212      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
215 
216     /**
217      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
218      */
219     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
220 
221     /**
222      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
223      */
224     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
225 
226     /**
227      * @dev Returns the number of tokens in ``owner``'s account.
228      */
229     function balanceOf(address owner) external view returns (uint256 balance);
230 
231     /**
232      * @dev Returns the owner of the `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function ownerOf(uint256 tokenId) external view returns (address owner);
239 
240     /**
241      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
242      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must exist and be owned by `from`.
249      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
251      *
252      * Emits a {Transfer} event.
253      */
254     function safeTransferFrom(
255         address from,
256         address to,
257         uint256 tokenId
258     ) external;
259 
260     /**
261      * @dev Transfers `tokenId` token from `from` to `to`.
262      *
263      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must be owned by `from`.
270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external;
279 
280     /**
281      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
282      * The approval is cleared when the token is transferred.
283      *
284      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
285      *
286      * Requirements:
287      *
288      * - The caller must own the token or be an approved operator.
289      * - `tokenId` must exist.
290      *
291      * Emits an {Approval} event.
292      */
293     function approve(address to, uint256 tokenId) external;
294 
295     /**
296      * @dev Returns the account approved for `tokenId` token.
297      *
298      * Requirements:
299      *
300      * - `tokenId` must exist.
301      */
302     function getApproved(uint256 tokenId) external view returns (address operator);
303 
304     /**
305      * @dev Approve or remove `operator` as an operator for the caller.
306      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
307      *
308      * Requirements:
309      *
310      * - The `operator` cannot be the caller.
311      *
312      * Emits an {ApprovalForAll} event.
313      */
314     function setApprovalForAll(address operator, bool _approved) external;
315 
316     /**
317      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
318      *
319      * See {setApprovalForAll}
320      */
321     function isApprovedForAll(address owner, address operator) external view returns (bool);
322 
323     /**
324      * @dev Safely transfers `tokenId` token from `from` to `to`.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must exist and be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
333      *
334      * Emits a {Transfer} event.
335      */
336     function safeTransferFrom(
337         address from,
338         address to,
339         uint256 tokenId,
340         bytes calldata data
341     ) external;
342 }
343 
344 /**
345  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
346  * @dev See https://eips.ethereum.org/EIPS/eip-721
347  */
348 interface IERC721Enumerable is IERC721 {
349     /**
350      * @dev Returns the total amount of tokens stored by the contract.
351      */
352     function totalSupply() external view returns (uint256);
353 
354     /**
355      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
356      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
357      */
358     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
359 
360     /**
361      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
362      * Use along with {totalSupply} to enumerate all tokens.
363      */
364     function tokenByIndex(uint256 index) external view returns (uint256);
365 }
366 
367 interface ILUSDToken is IERC20 { 
368     
369     // --- Events ---
370 
371     event TroveManagerAddressChanged(address _troveManagerAddress);
372     event StabilityPoolAddressChanged(address _newStabilityPoolAddress);
373     event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
374     event LUSDTokenBalanceUpdated(address _user, uint _amount);
375 
376     // --- Functions ---
377 
378     function mint(address _account, uint256 _amount) external;
379 
380     function burn(address _account, uint256 _amount) external;
381 
382     function sendToPool(address _sender,  address poolAddress, uint256 _amount) external;
383 
384     function returnFromPool(address poolAddress, address user, uint256 _amount ) external;
385 
386     function permit(
387         address owner,
388         address spender,
389         uint256 value,
390         uint256 deadline,
391         uint8 v,
392         bytes32 r,
393         bytes32 s
394     ) external;
395 }
396 
397 interface IBLUSDToken is IERC20 {
398     function mint(address _to, uint256 _bLUSDAmount) external;
399 
400     function burn(address _from, uint256 _bLUSDAmount) external;
401 }
402 
403 interface ICurvePool is IERC20 { 
404     function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256 mint_amount);
405 
406     function remove_liquidity(uint256 burn_amount, uint256[2] memory _min_amounts) external;
407 
408     function remove_liquidity_one_coin(uint256 _burn_amount, int128 i, uint256 _min_received) external;
409 
410     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy, address _receiver) external returns (uint256);
411 
412     function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy, address _receiver) external returns (uint256);
413 
414     function calc_withdraw_one_coin(uint256 _burn_amount, int128 i) external view returns (uint256);
415 
416     function calc_token_amount(uint256[2] memory _amounts, bool _is_deposit) external view returns (uint256);
417 
418     function balances(uint256 arg0) external view returns (uint256);
419 
420     function token() external view returns (address);
421 
422     function totalSupply() external view returns (uint256);
423 
424     function get_dy(int128 i,int128 j, uint256 dx) external view returns (uint256);
425 
426     function get_dy_underlying(int128 i,int128 j, uint256 dx) external view returns (uint256);
427 
428     function get_virtual_price() external view returns (uint256);
429 
430     function fee() external view returns (uint256);
431 
432     function D() external returns (uint256);
433 
434     function future_A_gamma_time() external returns (uint256);
435 }
436 
437 interface IYearnVault is IERC20 { 
438     function deposit(uint256 _tokenAmount) external returns (uint256);
439 
440     function withdraw(uint256 _tokenAmount) external returns (uint256);
441 
442     function lastReport() external view returns (uint256);
443 
444     function totalDebt() external view returns (uint256);
445 
446     function calcTokenToYToken(uint256 _tokenAmount) external pure returns (uint256); 
447 
448     function token() external view returns (address);
449 
450     function availableDepositLimit() external view returns (uint256);
451 
452     function pricePerShare() external view returns (uint256);
453 
454     function name() external view returns (string memory);
455 
456     function setDepositLimit(uint256 limit) external;
457 
458     function withdrawalQueue(uint256) external returns (address);
459 }
460 
461 interface IBAMM {
462     function deposit(uint256 lusdAmount) external;
463 
464     function withdraw(uint256 lusdAmount, address to) external;
465 
466     function swap(uint lusdAmount, uint minEthReturn, address payable dest) external returns(uint);
467 
468     function getSwapEthAmount(uint lusdQty) external view returns(uint ethAmount, uint feeLusdAmount);
469 
470     function getLUSDValue() external view returns (uint256, uint256, uint256);
471 
472     function setChicken(address _chicken) external;
473 }
474 
475 interface IChickenBondManager {
476     // Valid values for `status` returned by `getBondData()`
477     enum BondStatus {
478         nonExistent,
479         active,
480         chickenedOut,
481         chickenedIn
482     }
483 
484     function lusdToken() external view returns (ILUSDToken);
485     function bLUSDToken() external view returns (IBLUSDToken);
486     function curvePool() external view returns (ICurvePool);
487     function bammSPVault() external view returns (IBAMM);
488     function yearnCurveVault() external view returns (IYearnVault);
489     // constants
490     function INDEX_OF_LUSD_TOKEN_IN_CURVE_POOL() external pure returns (int128);
491 
492     function createBond(uint256 _lusdAmount) external returns (uint256);
493     function createBondWithPermit(
494         address owner, 
495         uint256 amount, 
496         uint256 deadline, 
497         uint8 v, 
498         bytes32 r, 
499         bytes32 s
500     ) external  returns (uint256);
501     function chickenOut(uint256 _bondID, uint256 _minLUSD) external;
502     function chickenIn(uint256 _bondID) external;
503     function redeem(uint256 _bLUSDToRedeem, uint256 _minLUSDFromBAMMSPVault) external returns (uint256, uint256);
504 
505     // getters
506     function calcRedemptionFeePercentage(uint256 _fractionOfBLUSDToRedeem) external view returns (uint256);
507     function getBondData(uint256 _bondID) external view returns (uint256 lusdAmount, uint64 claimedBLUSD, uint64 startTime, uint64 endTime, uint8 status);
508     function getLUSDToAcquire(uint256 _bondID) external view returns (uint256);
509     function calcAccruedBLUSD(uint256 _bondID) external view returns (uint256);
510     function calcBondBLUSDCap(uint256 _bondID) external view returns (uint256);
511     function getLUSDInBAMMSPVault() external view returns (uint256);
512     function calcTotalYearnCurveVaultShareValue() external view returns (uint256);
513     function calcTotalLUSDValue() external view returns (uint256);
514     function getPendingLUSD() external view returns (uint256);
515     function getAcquiredLUSDInSP() external view returns (uint256);
516     function getAcquiredLUSDInCurve() external view returns (uint256);
517     function getTotalAcquiredLUSD() external view returns (uint256);
518     function getPermanentLUSD() external view returns (uint256);
519     function getOwnedLUSDInSP() external view returns (uint256);
520     function getOwnedLUSDInCurve() external view returns (uint256);
521     function calcSystemBackingRatio() external view returns (uint256);
522     function calcUpdatedAccrualParameter() external view returns (uint256);
523     function getBAMMLUSDDebt() external view returns (uint256);
524 }
525 
526 interface IBondNFT is IERC721Enumerable {
527     struct BondExtraData {
528         uint80 initialHalfDna;
529         uint80 finalHalfDna;
530         uint32 troveSize;         // Debt in LUSD
531         uint32 lqtyAmount;        // Holding LQTY, staking or deposited into Pickle
532         uint32 curveGaugeSlopes;  // For 3CRV and Frax pools combined
533     }
534 
535     function mint(address _bonder, uint256 _permanentSeed) external returns (uint256, uint80);
536     function setFinalExtraData(address _bonder, uint256 _tokenID, uint256 _permanentSeed) external returns (uint80);
537     function chickenBondManager() external view returns (IChickenBondManager);
538     function getBondAmount(uint256 _tokenID) external view returns (uint256 amount);
539     function getBondStartTime(uint256 _tokenID) external view returns (uint256 startTime);
540     function getBondEndTime(uint256 _tokenID) external view returns (uint256 endTime);
541     function getBondInitialHalfDna(uint256 _tokenID) external view returns (uint80 initialHalfDna);
542     function getBondInitialDna(uint256 _tokenID) external view returns (uint256 initialDna);
543     function getBondFinalHalfDna(uint256 _tokenID) external view returns (uint80 finalHalfDna);
544     function getBondFinalDna(uint256 _tokenID) external view returns (uint256 finalDna);
545     function getBondStatus(uint256 _tokenID) external view returns (uint8 status);
546     function getBondExtraData(uint256 _tokenID) external view returns (uint80 initialHalfDna, uint80 finalHalfDna, uint32 troveSize, uint32 lqtyAmount, uint32 curveGaugeSlopes);
547 }
548 
549 interface IYearnRegistry {
550     function latestVault(address _tokenAddress) external returns (address);
551 }
552 
553 interface ICurveLiquidityGaugeV5 is IERC20 {
554     // Public state getters
555 
556     function reward_data(address _reward_token) external returns (
557         address token,
558         address distributor,
559         uint256 period_finish,
560         uint256 rate,
561         uint256 last_update,
562         uint256 integral
563     );
564 
565     // User-facing functions
566 
567     function deposit(uint256 _value) external;
568     function deposit(uint256 _value, address _addr) external;
569     function deposit(uint256 _value, address _addr, bool _claim_rewards) external;
570 
571     function withdraw(uint256 _value) external;
572     function withdraw(uint256 _value, bool _claim_rewards) external;
573 
574     function claim_rewards() external;
575     function claim_rewards(address _addr) external;
576     function claim_rewards(address _addr, address _receiver) external;
577 
578     function user_checkpoint(address addr) external returns (bool);
579     function set_rewards_receiver(address _receiver) external;
580     function kick(address addr) external;
581 
582     // Admin functions
583 
584     function deposit_reward_token(address _reward_token, uint256 _amount) external;
585     function add_reward(address _reward_token, address _distributor) external;
586     function set_reward_distributor(address _reward_token, address _distributor) external;
587     function set_killed(bool _is_killed) external;
588 
589     // View methods
590 
591     function claimed_reward(address _addr, address _token) external view returns (uint256);
592     function claimable_reward(address _user, address _reward_token) external view returns (uint256);
593     function claimable_tokens(address addr) external view returns (uint256);
594 
595     function integrate_checkpoint() external view returns (uint256);
596     function future_epoch_time() external view returns (uint256);
597     function inflation_rate() external view returns (uint256);
598 
599     function version() external view returns (string memory);
600 }
601 
602 // import "forge-std/console.sol";
603 
604 contract ChickenBondManager is ChickenMath, IChickenBondManager {
605 
606     // ChickenBonds contracts and addresses
607     IBondNFT immutable public bondNFT;
608 
609     IBLUSDToken immutable public bLUSDToken;
610     ILUSDToken immutable public lusdToken;
611 
612     // External contracts and addresses
613     ICurvePool immutable public curvePool; // LUSD meta-pool (i.e. coin 0 is LUSD, coin 1 is LP token from a base pool)
614     ICurvePool immutable public curveBasePool; // base pool of curvePool
615     IBAMM immutable public bammSPVault; // B.Protocol Stability Pool vault
616     IYearnVault immutable public yearnCurveVault;
617     IYearnRegistry immutable public yearnRegistry;
618     ICurveLiquidityGaugeV5 immutable public curveLiquidityGauge;
619 
620     address immutable public yearnGovernanceAddress;
621 
622     uint256 immutable public CHICKEN_IN_AMM_FEE;
623 
624     uint256 private pendingLUSD;          // Total pending LUSD. It will always be in SP (B.Protocol)
625     uint256 private permanentLUSD;        // Total permanent LUSD
626     uint256 private bammLUSDDebt;         // Amount “owed” by B.Protocol to ChickenBonds, equals deposits - withdrawals + rewards
627     uint256 public yTokensHeldByCBM;      // Computed balance of Y-tokens of LUSD-3CRV vault owned by this contract
628                                           // (to prevent certain attacks where attacker increases the balance and thus the backing ratio)
629 
630     // --- Data structures ---
631 
632     struct ExternalAdresses {
633         address bondNFTAddress;
634         address lusdTokenAddress;
635         address curvePoolAddress;
636         address curveBasePoolAddress;
637         address bammSPVaultAddress;
638         address yearnCurveVaultAddress;
639         address yearnRegistryAddress;
640         address yearnGovernanceAddress;
641         address bLUSDTokenAddress;
642         address curveLiquidityGaugeAddress;
643     }
644 
645     struct Params {
646         uint256 targetAverageAgeSeconds;        // Average outstanding bond age above which the controller will adjust `accrualParameter` in order to speed up accrual
647         uint256 initialAccrualParameter;        // Initial value for `accrualParameter`
648         uint256 minimumAccrualParameter;        // Stop adjusting `accrualParameter` when this value is reached
649         uint256 accrualAdjustmentRate;          // `accrualParameter` is multiplied `1 - accrualAdjustmentRate` every time there's an adjustment
650         uint256 accrualAdjustmentPeriodSeconds; // The duration of an adjustment period in seconds
651         uint256 chickenInAMMFee;                // Fraction of bonded amount that is sent to Curve Liquidity Gauge to incentivize LUSD-bLUSD liquidity
652         uint256 curveDepositDydxThreshold;      // Threshold of SP => Curve shifting
653         uint256 curveWithdrawalDxdyThreshold;   // Threshold of Curve => SP shifting
654         uint256 bootstrapPeriodChickenIn;       // Min duration of first chicken-in
655         uint256 bootstrapPeriodRedeem;          // Redemption lock period after first chicken in
656         uint256 bootstrapPeriodShift;           // Period after launch during which shifter functions are disabled
657         uint256 shifterDelay;                   // Duration of shifter countdown
658         uint256 shifterWindow;                  // Interval in which shifting is possible after countdown finishes
659         uint256 minBLUSDSupply;                 // Minimum amount of bLUSD supply that must remain after a redemption
660         uint256 minBondAmount;                  // Minimum amount of LUSD that needs to be bonded
661         uint256 nftRandomnessDivisor;           // Divisor for permanent LUSD amount in NFT pseudo-randomness computation (see comment below)
662         uint256 redemptionFeeBeta;              // Parameter by which to divide the redeemed fraction, in order to calculate the new base rate from a redemption
663         uint256 redemptionFeeMinuteDecayFactor; // Factor by which redemption fee decays (exponentially) every minute
664     }
665 
666     struct BondData {
667         uint256 lusdAmount;
668         uint64 claimedBLUSD; // In BLUSD units without decimals
669         uint64 startTime;
670         uint64 endTime; // Timestamp of chicken in/out event
671         BondStatus status;
672     }
673 
674     uint256 public firstChickenInTime; // Timestamp of the first chicken in after bLUSD supply is zero
675     uint256 public totalWeightedStartTimes; // Sum of `lusdAmount * startTime` for all outstanding bonds (used to tell weighted average bond age)
676     uint256 public lastRedemptionTime; // The timestamp of the latest redemption
677     uint256 public baseRedemptionRate; // The latest base redemption rate
678     mapping (uint256 => BondData) private idToBondData;
679 
680     /* migration: flag which determines whether the system is in migration mode.
681 
682     When migration mode has been triggered:
683 
684     - No funds are held in the permanent bucket. Liquidity is either pending, or acquired
685     - Bond creation and public shifter functions are disabled
686     - Users with an existing bond may still chicken in or out
687     - Chicken-ins will no longer send the LUSD surplus to the permanent bucket. Instead, they refund the surplus to the bonder
688     - bLUSD holders may still redeem
689     - Redemption fees are zero
690     */
691     bool public migration;
692 
693     uint256 public countChickenIn;
694     uint256 public countChickenOut;
695 
696     // --- Constants ---
697 
698     uint256 constant MAX_UINT256 = type(uint256).max;
699     int128 public constant INDEX_OF_LUSD_TOKEN_IN_CURVE_POOL = 0;
700     int128 constant INDEX_OF_3CRV_TOKEN_IN_CURVE_POOL = 1;
701 
702     uint256 constant public SECONDS_IN_ONE_MINUTE = 60;
703 
704     uint256 public immutable BOOTSTRAP_PERIOD_CHICKEN_IN; // Min duration of first chicken-in
705     uint256 public immutable BOOTSTRAP_PERIOD_REDEEM;     // Redemption lock period after first chicken in
706     uint256 public immutable BOOTSTRAP_PERIOD_SHIFT;      // Period after launch during which shifter functions are disabled
707 
708     uint256 public immutable SHIFTER_DELAY;               // Duration of shifter countdown
709     uint256 public immutable SHIFTER_WINDOW;              // Interval in which shifting is possible after countdown finishes
710 
711     uint256 public immutable MIN_BLUSD_SUPPLY;            // Minimum amount of bLUSD supply that must remain after a redemption
712     uint256 public immutable MIN_BOND_AMOUNT;             // Minimum amount of LUSD that needs to be bonded
713     // This is the minimum amount the permanent bucket needs to be increased by an attacker (through previous chicken in or redemption fee),
714     // in order to manipulate the obtained NFT. If the attacker finds the desired outcome at attempt N,
715     // the permanent increase should be N * NFT_RANDOMNESS_DIVISOR.
716     // It also means that as long as Permanent doesn’t change in that order of magnitude, attacker can try to manipulate
717     // only changing the event date.
718     uint256 public immutable NFT_RANDOMNESS_DIVISOR;
719 
720     /*
721      * BETA: 18 digit decimal. Parameter by which to divide the redeemed fraction, in order to calc the new base rate from a redemption.
722      * Corresponds to (1 / ALPHA) in the Liquity white paper.
723      */
724     uint256 public immutable BETA;
725     uint256 public immutable MINUTE_DECAY_FACTOR;
726 
727     uint256 constant CURVE_FEE_DENOMINATOR = 1e10;
728 
729     // Thresholds of SP <=> Curve shifting
730     uint256 public immutable curveDepositLUSD3CRVExchangeRateThreshold;
731     uint256 public immutable curveWithdrawal3CRVLUSDExchangeRateThreshold;
732 
733     // Timestamp at which the last shifter countdown started
734     uint256 public lastShifterCountdownStartTime;
735 
736     // --- Accrual control variables ---
737 
738     // `block.timestamp` of the block in which this contract was deployed.
739     uint256 public immutable deploymentTimestamp;
740 
741     // Average outstanding bond age above which the controller will adjust `accrualParameter` in order to speed up accrual.
742     uint256 public immutable targetAverageAgeSeconds;
743 
744     // Stop adjusting `accrualParameter` when this value is reached.
745     uint256 public immutable minimumAccrualParameter;
746 
747     // Number between 0 and 1. `accrualParameter` is multiplied by this every time there's an adjustment.
748     uint256 public immutable accrualAdjustmentMultiplier;
749 
750     // The duration of an adjustment period in seconds. The controller performs at most one adjustment per every period.
751     uint256 public immutable accrualAdjustmentPeriodSeconds;
752 
753     // The number of seconds it takes to accrue 50% of the cap, represented as an 18 digit fixed-point number.
754     uint256 public accrualParameter;
755 
756     // Counts the number of adjustment periods since deployment.
757     // Updated by operations that change the average outstanding bond age (createBond, chickenIn, chickenOut).
758     // Used by `_calcUpdatedAccrualParameter` to tell whether it's time to perform adjustments, and if so, how many times
759     // (in case the time elapsed since the last adjustment is more than one adjustment period).
760     uint256 public accrualAdjustmentPeriodCount;
761 
762     // --- Events ---
763 
764     event BaseRedemptionRateUpdated(uint256 _baseRedemptionRate);
765     event LastRedemptionTimeUpdated(uint256 _lastRedemptionFeeOpTime);
766     event BondCreated(address indexed bonder, uint256 bondId, uint256 amount, uint80 bondInitialHalfDna);
767     event BondClaimed(
768         address indexed bonder,
769         uint256 bondId,
770         uint256 lusdAmount,
771         uint256 bLusdAmount,
772         uint256 lusdSurplus,
773         uint256 chickenInFeeAmount,
774         bool migration,
775         uint80 bondFinalHalfDna
776     );
777     event BondCancelled(address indexed bonder, uint256 bondId, uint256 principalLusdAmount, uint256 minLusdAmount, uint256 withdrawnLusdAmount, uint80 bondFinalHalfDna);
778     event BLUSDRedeemed(address indexed redeemer, uint256 bLusdAmount, uint256 minLusdAmount, uint256 lusdAmount, uint256 yTokens, uint256 redemptionFee);
779     event MigrationTriggered(uint256 previousPermanentLUSD);
780     event AccrualParameterUpdated(uint256 accrualParameter);
781 
782     // --- Constructor ---
783 
784     constructor
785     (
786         ExternalAdresses memory _externalContractAddresses, // to avoid stack too deep issues
787         Params memory _params
788     )
789     {
790         bondNFT = IBondNFT(_externalContractAddresses.bondNFTAddress);
791         lusdToken = ILUSDToken(_externalContractAddresses.lusdTokenAddress);
792         bLUSDToken = IBLUSDToken(_externalContractAddresses.bLUSDTokenAddress);
793         curvePool = ICurvePool(_externalContractAddresses.curvePoolAddress);
794         curveBasePool = ICurvePool(_externalContractAddresses.curveBasePoolAddress);
795         bammSPVault = IBAMM(_externalContractAddresses.bammSPVaultAddress);
796         yearnCurveVault = IYearnVault(_externalContractAddresses.yearnCurveVaultAddress);
797         yearnRegistry = IYearnRegistry(_externalContractAddresses.yearnRegistryAddress);
798         yearnGovernanceAddress = _externalContractAddresses.yearnGovernanceAddress;
799 
800         deploymentTimestamp = block.timestamp;
801         targetAverageAgeSeconds = _params.targetAverageAgeSeconds;
802         accrualParameter = _params.initialAccrualParameter;
803         minimumAccrualParameter = _params.minimumAccrualParameter;
804         require(minimumAccrualParameter > 0, "CBM: Min accrual parameter cannot be zero");
805         accrualAdjustmentMultiplier = 1e18 - _params.accrualAdjustmentRate;
806         accrualAdjustmentPeriodSeconds = _params.accrualAdjustmentPeriodSeconds;
807 
808         curveLiquidityGauge = ICurveLiquidityGaugeV5(_externalContractAddresses.curveLiquidityGaugeAddress);
809         CHICKEN_IN_AMM_FEE = _params.chickenInAMMFee;
810 
811         uint256 fee = curvePool.fee(); // This is practically immutable (can only be set once, in `initialize()`)
812 
813         // By exchange rate, we mean the rate at which Curve exchanges LUSD <=> $ value of 3CRV (at the virtual price),
814         // which is reduced by the fee.
815         // For convenience, we want to parameterize our thresholds in terms of the spot prices -dy/dx & -dx/dy,
816         // which are not exposed by Curve directly. Instead, we turn our thresholds into thresholds on the exchange rate
817         // by taking into account the fee.
818         curveDepositLUSD3CRVExchangeRateThreshold =
819             _params.curveDepositDydxThreshold * (CURVE_FEE_DENOMINATOR - fee) / CURVE_FEE_DENOMINATOR;
820         curveWithdrawal3CRVLUSDExchangeRateThreshold =
821             _params.curveWithdrawalDxdyThreshold * (CURVE_FEE_DENOMINATOR - fee) / CURVE_FEE_DENOMINATOR;
822 
823         BOOTSTRAP_PERIOD_CHICKEN_IN = _params.bootstrapPeriodChickenIn;
824         BOOTSTRAP_PERIOD_REDEEM = _params.bootstrapPeriodRedeem;
825         BOOTSTRAP_PERIOD_SHIFT = _params.bootstrapPeriodShift;
826         SHIFTER_DELAY = _params.shifterDelay;
827         SHIFTER_WINDOW = _params.shifterWindow;
828         MIN_BLUSD_SUPPLY = _params.minBLUSDSupply;
829         require(_params.minBondAmount > 0, "CBM: MIN BOND AMOUNT parameter cannot be zero"); // We can still use 1e-18
830         MIN_BOND_AMOUNT = _params.minBondAmount;
831         NFT_RANDOMNESS_DIVISOR = _params.nftRandomnessDivisor;
832         BETA = _params.redemptionFeeBeta;
833         MINUTE_DECAY_FACTOR = _params.redemptionFeeMinuteDecayFactor;
834 
835         // TODO: Decide between one-time infinite LUSD approval to Yearn and Curve (lower gas cost per user tx, less secure
836         // or limited approval at each bonder action (higher gas cost per user tx, more secure)
837         lusdToken.approve(address(bammSPVault), MAX_UINT256);
838         lusdToken.approve(address(curvePool), MAX_UINT256);
839         curvePool.approve(address(yearnCurveVault), MAX_UINT256);
840         lusdToken.approve(address(curveLiquidityGauge), MAX_UINT256);
841 
842         // Check that the system is hooked up to the correct latest Yearn vault
843         assert(address(yearnCurveVault) == yearnRegistry.latestVault(address(curvePool)));
844     }
845 
846     // --- User-facing functions ---
847 
848     function createBond(uint256 _lusdAmount) public returns (uint256) {
849         _requireMinBond(_lusdAmount);
850         _requireMigrationNotActive();
851 
852         _updateAccrualParameter();
853 
854         // Mint the bond NFT to the caller and get the bond ID
855         (uint256 bondID, uint80 initialHalfDna) = bondNFT.mint(msg.sender, permanentLUSD / NFT_RANDOMNESS_DIVISOR);
856 
857         //Record the user’s bond data: bond_amount and start_time
858         BondData memory bondData;
859         bondData.lusdAmount = _lusdAmount;
860         bondData.startTime = uint64(block.timestamp);
861         bondData.status = BondStatus.active;
862         idToBondData[bondID] = bondData;
863 
864         pendingLUSD += _lusdAmount;
865         totalWeightedStartTimes += _lusdAmount * block.timestamp;
866 
867         lusdToken.transferFrom(msg.sender, address(this), _lusdAmount);
868 
869         // Deposit the LUSD to the B.Protocol LUSD vault
870         _depositToBAMM(_lusdAmount);
871 
872         emit BondCreated(msg.sender, bondID, _lusdAmount, initialHalfDna);
873 
874         return bondID;
875     }
876 
877     function createBondWithPermit(
878         address owner, 
879         uint256 amount, 
880         uint256 deadline, 
881         uint8 v, 
882         bytes32 r, 
883         bytes32 s
884     ) external returns (uint256) {
885         // LCB-10: don't call permit if the user already has the required amount permitted
886         if (lusdToken.allowance(owner, address(this)) < amount) {
887             lusdToken.permit(owner, address(this), amount, deadline, v, r, s);
888         }
889         return createBond(amount);
890     }
891 
892     function chickenOut(uint256 _bondID, uint256 _minLUSD) external {
893         BondData memory bond = idToBondData[_bondID];
894 
895         _requireCallerOwnsBond(_bondID);
896         _requireActiveStatus(bond.status);
897 
898         _updateAccrualParameter();
899 
900         idToBondData[_bondID].status = BondStatus.chickenedOut;
901         idToBondData[_bondID].endTime = uint64(block.timestamp);
902         uint80 newDna = bondNFT.setFinalExtraData(msg.sender, _bondID, permanentLUSD / NFT_RANDOMNESS_DIVISOR);
903 
904         countChickenOut += 1;
905 
906         pendingLUSD -= bond.lusdAmount;
907         totalWeightedStartTimes -= bond.lusdAmount * bond.startTime;
908 
909         /* In practice, there could be edge cases where the pendingLUSD is not fully backed:
910         * - Heavy liquidations, and before yield has been converted
911         * - Heavy loss-making liquidations, i.e. at <100% CR
912         * - SP or B.Protocol vault hack that drains LUSD
913         *
914         * The user can decide how to handle chickenOuts if/when the recorded pendingLUSD is not fully backed by actual
915         * LUSD in B.Protocol / the SP, by adjusting _minLUSD */
916         uint256 lusdToWithdraw = _requireEnoughLUSDInBAMM(bond.lusdAmount, _minLUSD);
917 
918         // Withdraw from B.Protocol LUSD vault
919         _withdrawFromBAMM(lusdToWithdraw, msg.sender);
920 
921         emit BondCancelled(msg.sender, _bondID, bond.lusdAmount, _minLUSD, lusdToWithdraw, newDna);
922     }
923 
924     // transfer _lusdToTransfer to the LUSD/bLUSD AMM LP Rewards staking contract
925     function _transferToRewardsStakingContract(uint256 _lusdToTransfer) internal {
926         uint256 lusdBalanceBefore = lusdToken.balanceOf(address(this));
927         curveLiquidityGauge.deposit_reward_token(address(lusdToken), _lusdToTransfer);
928 
929         assert(lusdBalanceBefore - lusdToken.balanceOf(address(this)) == _lusdToTransfer);
930     }
931 
932     function _withdrawFromSPVaultAndTransferToRewardsStakingContract(uint256 _lusdAmount) internal {
933         // Pull the LUSD amount from B.Protocol LUSD vault
934         _withdrawFromBAMM(_lusdAmount, address(this));
935 
936         // Deposit in rewards contract
937         _transferToRewardsStakingContract(_lusdAmount);
938     }
939 
940     /* Divert acquired yield to LUSD/bLUSD AMM LP rewards staking contract
941      * It happens on the very first chicken in event of the system, or any time that redemptions deplete bLUSD total supply to zero
942      * Assumption: When there have been no chicken ins since the bLUSD supply was set to 0 (either due to system deployment, or full bLUSD redemption),
943      * all acquired LUSD must necessarily be pure yield.
944      */
945     function _firstChickenIn(uint256 _bondStartTime, uint256 _bammLUSDValue, uint256 _lusdInBAMMSPVault) internal returns (uint256) {
946         //assert(!migration); // we leave it as a comment so we can uncomment it for automated testing tools
947 
948         require(block.timestamp >= _bondStartTime + BOOTSTRAP_PERIOD_CHICKEN_IN, "CBM: First chicken in must wait until bootstrap period is over");
949         firstChickenInTime = block.timestamp;
950 
951         (
952             uint256 acquiredLUSDInSP,
953             /* uint256 acquiredLUSDInCurve */,
954             /* uint256 ownedLUSDInSP */,
955             /* uint256 ownedLUSDInCurve */,
956             /* uint256 permanentLUSDCached */
957         ) = _getLUSDSplit(_bammLUSDValue);
958 
959         // Make sure that LUSD available in B.Protocol is at least as much as acquired
960         // If first chicken in happens after an scenario of heavy liquidations and before ETH has been sold by B.Protocol
961         // so that there’s not enough LUSD available in B.Protocol to transfer all the acquired bucket to the staking contract,
962         // the system would start with a backing ratio greater than 1
963         require(_lusdInBAMMSPVault >= acquiredLUSDInSP, "CBM: Not enough LUSD available in B.Protocol");
964 
965         // From SP Vault
966         if (acquiredLUSDInSP > 0) {
967             _withdrawFromSPVaultAndTransferToRewardsStakingContract(acquiredLUSDInSP);
968         }
969 
970         return _lusdInBAMMSPVault - acquiredLUSDInSP;
971     }
972 
973     function chickenIn(uint256 _bondID) external {
974         BondData memory bond = idToBondData[_bondID];
975 
976         _requireCallerOwnsBond(_bondID);
977         _requireActiveStatus(bond.status);
978 
979         uint256 updatedAccrualParameter = _updateAccrualParameter();
980         (uint256 bammLUSDValue, uint256 lusdInBAMMSPVault) = _updateBAMMDebt();
981 
982         (uint256 chickenInFeeAmount, uint256 bondAmountMinusChickenInFee) = _getBondWithChickenInFeeApplied(bond.lusdAmount);
983 
984         /* Upon the first chicken-in after a) system deployment or b) redemption of the full bLUSD supply, divert
985         * any earned yield to the bLUSD-LUSD AMM for fairness.
986         *
987         * This is not done in migration mode since there is no need to send rewards to the staking contract.
988         */
989         if (bLUSDToken.totalSupply() == 0 && !migration) {
990             lusdInBAMMSPVault = _firstChickenIn(bond.startTime, bammLUSDValue, lusdInBAMMSPVault);
991         }
992 
993         // Get the LUSD amount to acquire from the bond in proportion to the system's current backing ratio, in order to maintain said ratio.
994         uint256 lusdToAcquire = _calcAccruedAmount(bond.startTime, bondAmountMinusChickenInFee, updatedAccrualParameter);
995         // Get backing ratio and accrued bLUSD
996         uint256 backingRatio = _calcSystemBackingRatioFromBAMMValue(bammLUSDValue);
997         uint256 accruedBLUSD = lusdToAcquire * 1e18 / backingRatio;
998 
999         idToBondData[_bondID].claimedBLUSD = uint64(Math.min(accruedBLUSD / 1e18, type(uint64).max)); // to units and uint64
1000         idToBondData[_bondID].status = BondStatus.chickenedIn;
1001         idToBondData[_bondID].endTime = uint64(block.timestamp);
1002         uint80 newDna = bondNFT.setFinalExtraData(msg.sender, _bondID, permanentLUSD / NFT_RANDOMNESS_DIVISOR);
1003 
1004         countChickenIn += 1;
1005 
1006         // Subtract the bonded amount from the total pending LUSD (and implicitly increase the total acquired LUSD)
1007         pendingLUSD -= bond.lusdAmount;
1008         totalWeightedStartTimes -= bond.lusdAmount * bond.startTime;
1009 
1010         // Get the remaining surplus from the LUSD amount to acquire from the bond
1011         uint256 lusdSurplus = bondAmountMinusChickenInFee - lusdToAcquire;
1012 
1013         // Handle the surplus LUSD from the chicken-in:
1014         if (!migration) { // In normal mode, add the surplus to the permanent bucket by increasing the permament tracker. This implicitly decreases the acquired LUSD.
1015             permanentLUSD += lusdSurplus;
1016         } else { // In migration mode, withdraw surplus from B.Protocol and refund to bonder
1017             // TODO: should we allow to pass in a minimum value here too?
1018             (,lusdInBAMMSPVault,) = bammSPVault.getLUSDValue();
1019             uint256 lusdToRefund = Math.min(lusdSurplus, lusdInBAMMSPVault);
1020             if (lusdToRefund > 0) { _withdrawFromBAMM(lusdToRefund, msg.sender); }
1021         }
1022 
1023         bLUSDToken.mint(msg.sender, accruedBLUSD);
1024 
1025         // Transfer the chicken in fee to the LUSD/bLUSD AMM LP Rewards staking contract during normal mode.
1026         if (!migration && lusdInBAMMSPVault >= chickenInFeeAmount) {
1027             _withdrawFromSPVaultAndTransferToRewardsStakingContract(chickenInFeeAmount);
1028         }
1029 
1030         emit BondClaimed(msg.sender, _bondID, bond.lusdAmount, accruedBLUSD, lusdSurplus, chickenInFeeAmount, migration, newDna);
1031     }
1032 
1033     function redeem(uint256 _bLUSDToRedeem, uint256 _minLUSDFromBAMMSPVault) external returns (uint256, uint256) {
1034         _requireNonZeroAmount(_bLUSDToRedeem);
1035         _requireRedemptionNotDepletingbLUSD(_bLUSDToRedeem);
1036 
1037         require(block.timestamp >= firstChickenInTime + BOOTSTRAP_PERIOD_REDEEM, "CBM: Redemption after first chicken in must wait until bootstrap period is over");
1038 
1039         (
1040             uint256 acquiredLUSDInSP,
1041             uint256 acquiredLUSDInCurve,
1042             /* uint256 ownedLUSDInSP */,
1043             uint256 ownedLUSDInCurve,
1044             uint256 permanentLUSDCached
1045         ) = _getLUSDSplitAfterUpdatingBAMMDebt();
1046 
1047         uint256 fractionOfBLUSDToRedeem = _bLUSDToRedeem * 1e18 / bLUSDToken.totalSupply();
1048         // Calculate redemption fee. No fee in migration mode.
1049         uint256 redemptionFeePercentage = migration ? 0 : _updateRedemptionFeePercentage(fractionOfBLUSDToRedeem);
1050         // Will collect redemption fees from both buckets (in LUSD).
1051         uint256 redemptionFeeLUSD;
1052 
1053         // TODO: Both _requireEnoughLUSDInBAMM and _updateBAMMDebt call B.Protocol getLUSDValue, so it may be optmized
1054         // Calculate the LUSD to withdraw from LUSD vault, withdraw and send to redeemer. Move the fee to the permanent bucket.
1055         uint256 lusdToWithdrawFromSP;
1056         { // Block scoping to avoid stack too deep issues
1057             uint256 acquiredLUSDInSPToRedeem = acquiredLUSDInSP * fractionOfBLUSDToRedeem / 1e18;
1058             uint256 acquiredLUSDInSPToWithdraw = acquiredLUSDInSPToRedeem * (1e18 - redemptionFeePercentage) / 1e18;
1059             redemptionFeeLUSD += acquiredLUSDInSPToRedeem - acquiredLUSDInSPToWithdraw;
1060             lusdToWithdrawFromSP = _requireEnoughLUSDInBAMM(acquiredLUSDInSPToWithdraw, _minLUSDFromBAMMSPVault);
1061             if (lusdToWithdrawFromSP > 0) { _withdrawFromBAMM(lusdToWithdrawFromSP, msg.sender); }
1062         }
1063 
1064         // Send yTokens to the redeemer according to the proportion of owned LUSD in Curve that's being redeemed
1065         uint256 yTokensFromCurveVault;
1066         if (ownedLUSDInCurve > 0) {
1067             uint256 acquiredLUSDInCurveToRedeem = acquiredLUSDInCurve * fractionOfBLUSDToRedeem / 1e18;
1068             uint256 lusdToWithdrawFromCurve = acquiredLUSDInCurveToRedeem * (1e18 - redemptionFeePercentage) / 1e18;
1069             redemptionFeeLUSD += acquiredLUSDInCurveToRedeem - lusdToWithdrawFromCurve;
1070             yTokensFromCurveVault = yTokensHeldByCBM * lusdToWithdrawFromCurve / ownedLUSDInCurve;
1071             if (yTokensFromCurveVault > 0) { _transferFromCurve(msg.sender, yTokensFromCurveVault); }
1072         }
1073 
1074         // Move the fee to permanent. This implicitly removes it from the acquired bucket
1075         permanentLUSD = permanentLUSDCached + redemptionFeeLUSD;
1076 
1077         _requireNonZeroAmount(lusdToWithdrawFromSP + yTokensFromCurveVault);
1078 
1079         // Burn the redeemed bLUSD
1080         bLUSDToken.burn(msg.sender, _bLUSDToRedeem);
1081 
1082         emit BLUSDRedeemed(msg.sender, _bLUSDToRedeem, _minLUSDFromBAMMSPVault, lusdToWithdrawFromSP, yTokensFromCurveVault, redemptionFeeLUSD);
1083 
1084         return (lusdToWithdrawFromSP, yTokensFromCurveVault);
1085     }
1086 
1087     function shiftLUSDFromSPToCurve(uint256 _maxLUSDToShift) external {
1088         _requireShiftBootstrapPeriodEnded();
1089         _requireMigrationNotActive();
1090         _requireNonZeroBLUSDSupply();
1091         _requireShiftWindowIsOpen();
1092 
1093         (uint256 bammLUSDValue, uint256 lusdInBAMMSPVault) = _updateBAMMDebt();
1094         uint256 lusdOwnedInBAMMSPVault = bammLUSDValue - pendingLUSD;
1095 
1096         uint256 totalLUSDInCurve = getTotalLUSDInCurve();
1097         // it can happen due to profits from shifts or rounding errors:
1098         _requirePermanentGreaterThanCurve(totalLUSDInCurve);
1099 
1100         // Make sure pending bucket is not moved to Curve, so it can be withdrawn on chicken out
1101         uint256 clampedLUSDToShift = Math.min(_maxLUSDToShift, lusdOwnedInBAMMSPVault);
1102 
1103         // Make sure there’s enough LUSD available in B.Protocol
1104         clampedLUSDToShift = Math.min(clampedLUSDToShift, lusdInBAMMSPVault);
1105 
1106         // Make sure we don’t make Curve bucket greater than Permanent one with the shift
1107         // subtraction is safe per _requirePermanentGreaterThanCurve above
1108         clampedLUSDToShift = Math.min(clampedLUSDToShift, permanentLUSD - totalLUSDInCurve);
1109 
1110         _requireNonZeroAmount(clampedLUSDToShift);
1111 
1112         // Get the 3CRV virtual price only once, and use it for both initial and final check.
1113         // Adding LUSD liquidity to the meta-pool does not change 3CRV virtual price.
1114         uint256 _3crvVirtualPrice = curveBasePool.get_virtual_price();
1115         uint256 initialExchangeRate = _getLUSD3CRVExchangeRate(_3crvVirtualPrice);
1116 
1117         require(
1118             initialExchangeRate > curveDepositLUSD3CRVExchangeRateThreshold,
1119             "CBM: LUSD:3CRV exchange rate must be over the deposit threshold before SP->Curve shift"
1120         );
1121 
1122         // Withdram LUSD from B.Protocol
1123         _withdrawFromBAMM(clampedLUSDToShift, address(this));
1124 
1125         // Deposit the received LUSD to Curve in return for LUSD3CRV-f tokens
1126         uint256 lusd3CRVBalanceBefore = curvePool.balanceOf(address(this));
1127         /* TODO: Determine if we should pass a minimum amount of LP tokens to receive here. Seems infeasible to determinine the mininum on-chain from
1128         * Curve spot price / quantities, which are manipulable. */
1129         curvePool.add_liquidity([clampedLUSDToShift, 0], 0);
1130         uint256 lusd3CRVBalanceDelta = curvePool.balanceOf(address(this)) - lusd3CRVBalanceBefore;
1131 
1132         // Deposit the received LUSD3CRV-f to Yearn Curve vault
1133         _depositToCurve(lusd3CRVBalanceDelta);
1134 
1135         // Do price check: ensure the SP->Curve shift has decreased the LUSD:3CRV exchange rate, but not into unprofitable territory
1136         uint256 finalExchangeRate = _getLUSD3CRVExchangeRate(_3crvVirtualPrice);
1137 
1138         require(
1139             finalExchangeRate < initialExchangeRate &&
1140             finalExchangeRate >= curveDepositLUSD3CRVExchangeRateThreshold,
1141             "CBM: SP->Curve shift must decrease LUSD:3CRV exchange rate to a value above the deposit threshold"
1142         );
1143     }
1144 
1145     function shiftLUSDFromCurveToSP(uint256 _maxLUSDToShift) external {
1146         _requireShiftBootstrapPeriodEnded();
1147         _requireMigrationNotActive();
1148         _requireNonZeroBLUSDSupply();
1149         _requireShiftWindowIsOpen();
1150 
1151         // We can’t shift more than what’s in Curve
1152         uint256 ownedLUSDInCurve = getTotalLUSDInCurve();
1153         uint256 clampedLUSDToShift = Math.min(_maxLUSDToShift, ownedLUSDInCurve);
1154         _requireNonZeroAmount(clampedLUSDToShift);
1155 
1156         // Get the 3CRV virtual price only once, and use it for both initial and final check.
1157         // Removing LUSD liquidity from the meta-pool does not change 3CRV virtual price.
1158         uint256 _3crvVirtualPrice = curveBasePool.get_virtual_price();
1159         uint256 initialExchangeRate = _get3CRVLUSDExchangeRate(_3crvVirtualPrice);
1160 
1161         // Here we're using the 3CRV:LUSD exchange rate (with 3CRV being valued at its virtual price),
1162         // which increases as LUSD price decreases, hence the direction of the inequality.
1163         require(
1164             initialExchangeRate > curveWithdrawal3CRVLUSDExchangeRateThreshold,
1165             "CBM: 3CRV:LUSD exchange rate must be above the withdrawal threshold before Curve->SP shift"
1166         );
1167 
1168         // Convert yTokens to LUSD3CRV-f
1169         uint256 lusd3CRVBalanceBefore = curvePool.balanceOf(address(this));
1170 
1171         // ownedLUSDInCurve > 0 implied by _requireNonZeroAmount(clampedLUSDToShift)
1172         uint256 yTokensToBurnFromCurveVault = yTokensHeldByCBM * clampedLUSDToShift / ownedLUSDInCurve;
1173         _withdrawFromCurve(yTokensToBurnFromCurveVault);
1174         uint256 lusd3CRVBalanceDelta = curvePool.balanceOf(address(this)) - lusd3CRVBalanceBefore;
1175 
1176         // Withdraw LUSD from Curve
1177         uint256 lusdBalanceBefore = lusdToken.balanceOf(address(this));
1178         /* TODO: Determine if we should pass a minimum amount of LUSD to receive here. Seems infeasible to determinine the mininum on-chain from
1179         * Curve spot price / quantities, which are manipulable. */
1180         curvePool.remove_liquidity_one_coin(lusd3CRVBalanceDelta, INDEX_OF_LUSD_TOKEN_IN_CURVE_POOL, 0);
1181         uint256 lusdBalanceDelta = lusdToken.balanceOf(address(this)) - lusdBalanceBefore;
1182 
1183         // Assertion should hold in principle. In practice, there is usually minor rounding error
1184         // assert(lusdBalanceDelta == _lusdToShift);
1185 
1186         // Deposit the received LUSD to B.Protocol LUSD vault
1187         _depositToBAMM(lusdBalanceDelta);
1188 
1189         // Ensure the Curve->SP shift has decreased the 3CRV:LUSD exchange rate, but not into unprofitable territory
1190         uint256 finalExchangeRate = _get3CRVLUSDExchangeRate(_3crvVirtualPrice);
1191 
1192         require(
1193             finalExchangeRate < initialExchangeRate &&
1194             finalExchangeRate >= curveWithdrawal3CRVLUSDExchangeRateThreshold,
1195             "CBM: Curve->SP shift must increase 3CRV:LUSD exchange rate to a value above the withdrawal threshold"
1196         );
1197     }
1198 
1199     // --- B.Protocol debt functions ---
1200 
1201     // If the actual balance of B.Protocol is higher than our internal accounting,
1202     // it means that B.Protocol has had gains (through sell of ETH or LQTY).
1203     // We account for those gains
1204     // If the balance was lower (which would mean losses), we expect them to be eventually recovered
1205     function _getInternalBAMMLUSDValue() internal view returns (uint256) {
1206         (, uint256 lusdInBAMMSPVault,) = bammSPVault.getLUSDValue();
1207 
1208         return Math.max(bammLUSDDebt, lusdInBAMMSPVault);
1209     }
1210 
1211     // TODO: Should we make this one publicly callable, so that external getters can be up to date (by previously calling this)?
1212     // Returns the value updated
1213     function _updateBAMMDebt() internal returns (uint256, uint256) {
1214         (, uint256 lusdInBAMMSPVault,) = bammSPVault.getLUSDValue();
1215         uint256 bammLUSDDebtCached = bammLUSDDebt;
1216 
1217         // If the actual balance of B.Protocol is higher than our internal accounting,
1218         // it means that B.Protocol has had gains (through sell of ETH or LQTY).
1219         // We account for those gains
1220         // If the balance was lower (which would mean losses), we expect them to be eventually recovered
1221         if (lusdInBAMMSPVault > bammLUSDDebtCached) {
1222             bammLUSDDebt = lusdInBAMMSPVault;
1223             return (lusdInBAMMSPVault, lusdInBAMMSPVault);
1224         }
1225 
1226         return (bammLUSDDebtCached, lusdInBAMMSPVault);
1227     }
1228 
1229     function _depositToBAMM(uint256 _lusdAmount) internal {
1230         bammSPVault.deposit(_lusdAmount);
1231         bammLUSDDebt += _lusdAmount;
1232     }
1233 
1234     function _withdrawFromBAMM(uint256 _lusdAmount, address _to) internal {
1235         bammSPVault.withdraw(_lusdAmount, _to);
1236         bammLUSDDebt -= _lusdAmount;
1237     }
1238 
1239     // @dev make sure this wrappers are always used instead of calling yearnCurveVault functions directyl,
1240     // otherwise the internal accounting would fail
1241     function _depositToCurve(uint256 _lusd3CRV) internal {
1242         uint256 yTokensBalanceBefore = yearnCurveVault.balanceOf(address(this));
1243         yearnCurveVault.deposit(_lusd3CRV);
1244         uint256 yTokensBalanceDelta = yearnCurveVault.balanceOf(address(this)) - yTokensBalanceBefore;
1245         yTokensHeldByCBM += yTokensBalanceDelta;
1246     }
1247 
1248     function _withdrawFromCurve(uint256 _yTokensToSwap) internal {
1249         yearnCurveVault.withdraw(_yTokensToSwap);
1250         yTokensHeldByCBM -= _yTokensToSwap;
1251     }
1252 
1253     function _transferFromCurve(address _to, uint256 _yTokensToTransfer) internal {
1254         yearnCurveVault.transfer(_to, _yTokensToTransfer);
1255         yTokensHeldByCBM -= _yTokensToTransfer;
1256     }
1257 
1258     // --- Migration functionality ---
1259 
1260     /* Migration function callable one-time and only by Yearn governance.
1261     * Moves all permanent LUSD in Curve to the Curve acquired bucket.
1262     */
1263     function activateMigration() external {
1264         _requireCallerIsYearnGovernance();
1265         _requireMigrationNotActive();
1266 
1267         migration = true;
1268 
1269         emit MigrationTriggered(permanentLUSD);
1270 
1271         // Zero the permament LUSD tracker. This implicitly makes all permament liquidity acquired (and redeemable)
1272         permanentLUSD = 0;
1273     }
1274 
1275     // --- Shifter countdown starter ---
1276 
1277     function startShifterCountdown() public {
1278         // First check that the previous delay and shifting window have passed
1279         require(block.timestamp >= lastShifterCountdownStartTime + SHIFTER_DELAY + SHIFTER_WINDOW, "CBM: Previous shift delay and window must have passed");
1280 
1281         // Begin the new countdown from now
1282         lastShifterCountdownStartTime = block.timestamp;
1283     }
1284 
1285     // --- Fee share ---
1286 
1287     function sendFeeShare(uint256 _lusdAmount) external {
1288         _requireCallerIsYearnGovernance();
1289         require(!migration, "CBM: Receive fee share only in normal mode");
1290 
1291         // Move LUSD from caller to CBM and deposit to B.Protocol LUSD Vault
1292         lusdToken.transferFrom(yearnGovernanceAddress, address(this), _lusdAmount);
1293         _depositToBAMM(_lusdAmount);
1294     }
1295 
1296     // --- Helper functions ---
1297 
1298     function _getLUSD3CRVExchangeRate(uint256 _3crvVirtualPrice) internal view returns (uint256) {
1299         // Get the amount of 3CRV that would be received by swapping 1 LUSD (after deduction of fees)
1300         // If p_{LUSD:3CRV} is the price of LUSD quoted in 3CRV, then this returns p_{LUSD:3CRV} * (1 - fee)
1301         // as long as the pool is large enough so that 1 LUSD doesn't introduce significant slippage.
1302         uint256 dy = curvePool.get_dy(INDEX_OF_LUSD_TOKEN_IN_CURVE_POOL, INDEX_OF_3CRV_TOKEN_IN_CURVE_POOL, 1e18);
1303 
1304         return dy * _3crvVirtualPrice / 1e18;
1305     }
1306 
1307     function _get3CRVLUSDExchangeRate(uint256 _3crvVirtualPrice) internal view returns (uint256) {
1308         // Get the amount of LUSD that would be received by swapping 1 3CRV (after deduction of fees)
1309         // If p_{3CRV:LUSD} is the price of 3CRV quoted in LUSD, then this returns p_{3CRV:LUSD} * (1 - fee)
1310         // as long as the pool is large enough so that 1 3CRV doesn't introduce significant slippage.
1311         uint256 dy = curvePool.get_dy(INDEX_OF_3CRV_TOKEN_IN_CURVE_POOL, INDEX_OF_LUSD_TOKEN_IN_CURVE_POOL, 1e18);
1312 
1313         return dy * 1e18 / _3crvVirtualPrice;
1314     }
1315 
1316     // Calc decayed redemption rate
1317     function calcRedemptionFeePercentage(uint256 _fractionOfBLUSDToRedeem) public view returns (uint256) {
1318         uint256 minutesPassed = _minutesPassedSinceLastRedemption();
1319         uint256 decayFactor = decPow(MINUTE_DECAY_FACTOR, minutesPassed);
1320 
1321         uint256 decayedBaseRedemptionRate = baseRedemptionRate * decayFactor / DECIMAL_PRECISION;
1322 
1323         // Increase redemption base rate with the new redeemed amount
1324         uint256 newBaseRedemptionRate = decayedBaseRedemptionRate + _fractionOfBLUSDToRedeem / BETA;
1325         newBaseRedemptionRate = Math.min(newBaseRedemptionRate, DECIMAL_PRECISION); // cap baseRate at a maximum of 100%
1326         //assert(newBaseRedemptionRate <= DECIMAL_PRECISION); // This is already enforced in the line above
1327 
1328         return newBaseRedemptionRate;
1329     }
1330 
1331     // Update the base redemption rate and the last redemption time (only if time passed >= decay interval. This prevents base rate griefing)
1332     function _updateRedemptionFeePercentage(uint256 _fractionOfBLUSDToRedeem) internal returns (uint256) {
1333         uint256 newBaseRedemptionRate = calcRedemptionFeePercentage(_fractionOfBLUSDToRedeem);
1334         baseRedemptionRate = newBaseRedemptionRate;
1335         emit BaseRedemptionRateUpdated(newBaseRedemptionRate);
1336 
1337         uint256 timePassed = block.timestamp - lastRedemptionTime;
1338 
1339         if (timePassed >= SECONDS_IN_ONE_MINUTE) {
1340             lastRedemptionTime = block.timestamp;
1341             emit LastRedemptionTimeUpdated(block.timestamp);
1342         }
1343 
1344         return newBaseRedemptionRate;
1345     }
1346 
1347     function _minutesPassedSinceLastRedemption() internal view returns (uint256) {
1348         return (block.timestamp - lastRedemptionTime) / SECONDS_IN_ONE_MINUTE;
1349     }
1350 
1351     function _getBondWithChickenInFeeApplied(uint256 _bondLUSDAmount) internal view returns (uint256, uint256) {
1352         // Apply zero fee in migration mode
1353         if (migration) {return (0, _bondLUSDAmount);}
1354 
1355         // Otherwise, apply the constant fee rate
1356         uint256 chickenInFeeAmount = _bondLUSDAmount * CHICKEN_IN_AMM_FEE / 1e18;
1357         uint256 bondAmountMinusChickenInFee = _bondLUSDAmount - chickenInFeeAmount;
1358 
1359         return (chickenInFeeAmount, bondAmountMinusChickenInFee);
1360     }
1361 
1362     function _getBondAmountMinusChickenInFee(uint256 _bondLUSDAmount) internal view returns (uint256) {
1363         (, uint256 bondAmountMinusChickenInFee) = _getBondWithChickenInFeeApplied(_bondLUSDAmount);
1364         return bondAmountMinusChickenInFee;
1365     }
1366 
1367     /* _calcAccruedAmount: internal getter for calculating accrued token amount for a given bond.
1368     *
1369     * This function is unit-agnostic. It can be used to calculate a bonder's accrrued bLUSD, or the LUSD that that the
1370     * CB system would acquire (i.e. receive to the acquired bucket) if the bond were Chickened In now.
1371     *
1372     * For the bonder, _capAmount is their bLUSD cap.
1373     * For the CB system, _capAmount is the LUSD bond amount (less the Chicken In fee).
1374     */
1375     function _calcAccruedAmount(uint256 _startTime, uint256 _capAmount, uint256 _accrualParameter) internal view returns (uint256) {
1376         // All bonds have a non-zero creation timestamp, so return accrued sLQTY 0 if the startTime is 0
1377         if (_startTime == 0) {return 0;}
1378 
1379         // Scale `bondDuration` up to an 18 digit fixed-point number.
1380         // This lets us add it to `accrualParameter`, which is also an 18-digit FP.
1381         uint256 bondDuration = 1e18 * (block.timestamp - _startTime);
1382 
1383         uint256 accruedAmount = _capAmount * bondDuration / (bondDuration + _accrualParameter);
1384         //assert(accruedAmount < _capAmount); // we leave it as a comment so we can uncomment it for automated testing tools
1385 
1386         return accruedAmount;
1387     }
1388 
1389     // Gauge the average (size-weighted) outstanding bond age and adjust accrual parameter if it's higher than our target.
1390     // If there's been more than one adjustment period since the last adjustment, perform multiple adjustments retroactively.
1391     function _calcUpdatedAccrualParameter(
1392         uint256 _storedAccrualParameter,
1393         uint256 _storedAccrualAdjustmentCount
1394     )
1395         internal
1396         view
1397         returns (
1398             uint256 updatedAccrualParameter,
1399             uint256 updatedAccrualAdjustmentPeriodCount
1400         )
1401     {
1402         updatedAccrualAdjustmentPeriodCount = (block.timestamp - deploymentTimestamp) / accrualAdjustmentPeriodSeconds;
1403 
1404         if (
1405             // There hasn't been enough time since the last update to warrant another update
1406             updatedAccrualAdjustmentPeriodCount == _storedAccrualAdjustmentCount ||
1407             // or `accrualParameter` is already bottomed-out
1408             _storedAccrualParameter == minimumAccrualParameter ||
1409             // or there are no outstanding bonds (avoid division by zero)
1410             pendingLUSD == 0
1411         ) {
1412             return (_storedAccrualParameter, updatedAccrualAdjustmentPeriodCount);
1413         }
1414 
1415         uint256 averageStartTime = totalWeightedStartTimes / pendingLUSD;
1416 
1417         // We want to calculate the period when the average age will have reached or exceeded the
1418         // target average age, to be used later in a check against the actual current period.
1419         //
1420         // At any given timestamp `t`, the average age can be calculated as:
1421         //   averageAge(t) = t - averageStartTime
1422         //
1423         // For any period `n`, the average age is evaluated at the following timestamp:
1424         //   tSample(n) = deploymentTimestamp + n * accrualAdjustmentPeriodSeconds
1425         //
1426         // Hence we're looking for the smallest integer `n` such that:
1427         //   averageAge(tSample(n)) >= targetAverageAgeSeconds
1428         //
1429         // If `n` is the smallest integer for which the above inequality stands, then:
1430         //   averageAge(tSample(n - 1)) < targetAverageAgeSeconds
1431         //
1432         // Combining the two inequalities:
1433         //   averageAge(tSample(n - 1)) < targetAverageAgeSeconds <= averageAge(tSample(n))
1434         //
1435         // Substituting and rearranging:
1436         //   1.    deploymentTimestamp + (n - 1) * accrualAdjustmentPeriodSeconds - averageStartTime
1437         //       < targetAverageAgeSeconds
1438         //      <= deploymentTimestamp + n * accrualAdjustmentPeriodSeconds - averageStartTime
1439         //
1440         //   2.    (n - 1) * accrualAdjustmentPeriodSeconds
1441         //       < averageStartTime + targetAverageAgeSeconds - deploymentTimestamp
1442         //      <= n * accrualAdjustmentPeriodSeconds
1443         //
1444         //   3. n - 1 < (averageStartTime + targetAverageAgeSeconds - deploymentTimestamp) / accrualAdjustmentPeriodSeconds <= n
1445         //
1446         // Using equivalence `n = ceil(x) <=> n - 1 < x <= n` we arrive at:
1447         //   n = ceil((averageStartTime + targetAverageAgeSeconds - deploymentTimestamp) / accrualAdjustmentPeriodSeconds)
1448         //
1449         // We can calculate `ceil(a / b)` using `Math.ceilDiv(a, b)`.
1450         uint256 adjustmentPeriodCountWhenTargetIsExceeded = Math.ceilDiv(
1451             averageStartTime + targetAverageAgeSeconds - deploymentTimestamp,
1452             accrualAdjustmentPeriodSeconds
1453         );
1454 
1455         if (updatedAccrualAdjustmentPeriodCount < adjustmentPeriodCountWhenTargetIsExceeded) {
1456             // No adjustment needed; target average age hasn't been exceeded yet
1457             return (_storedAccrualParameter, updatedAccrualAdjustmentPeriodCount);
1458         }
1459 
1460         uint256 numberOfAdjustments = updatedAccrualAdjustmentPeriodCount - Math.max(
1461             _storedAccrualAdjustmentCount,
1462             adjustmentPeriodCountWhenTargetIsExceeded - 1
1463         );
1464 
1465         updatedAccrualParameter = Math.max(
1466             _storedAccrualParameter * decPow(accrualAdjustmentMultiplier, numberOfAdjustments) / 1e18,
1467             minimumAccrualParameter
1468         );
1469     }
1470 
1471     function _updateAccrualParameter() internal returns (uint256) {
1472         uint256 storedAccrualParameter = accrualParameter;
1473         uint256 storedAccrualAdjustmentPeriodCount = accrualAdjustmentPeriodCount;
1474 
1475         (uint256 updatedAccrualParameter, uint256 updatedAccrualAdjustmentPeriodCount) =
1476             _calcUpdatedAccrualParameter(storedAccrualParameter, storedAccrualAdjustmentPeriodCount);
1477 
1478         if (updatedAccrualAdjustmentPeriodCount != storedAccrualAdjustmentPeriodCount) {
1479             accrualAdjustmentPeriodCount = updatedAccrualAdjustmentPeriodCount;
1480 
1481             if (updatedAccrualParameter != storedAccrualParameter) {
1482                 accrualParameter = updatedAccrualParameter;
1483                 emit AccrualParameterUpdated(updatedAccrualParameter);
1484             }
1485         }
1486 
1487         return updatedAccrualParameter;
1488     }
1489 
1490     // Internal getter for calculating the bond bLUSD cap based on bonded amount and backing ratio
1491     function _calcBondBLUSDCap(uint256 _bondedAmount, uint256 _backingRatio) internal pure returns (uint256) {
1492         // TODO: potentially refactor this -  i.e. have a (1 / backingRatio) function for more precision
1493         return _bondedAmount * 1e18 / _backingRatio;
1494     }
1495 
1496     // --- 'require' functions
1497 
1498     function _requireCallerOwnsBond(uint256 _bondID) internal view {
1499         require(msg.sender == bondNFT.ownerOf(_bondID), "CBM: Caller must own the bond");
1500     }
1501 
1502     function _requireActiveStatus(BondStatus status) internal pure {
1503         require(status == BondStatus.active, "CBM: Bond must be active");
1504     }
1505 
1506     function _requireNonZeroAmount(uint256 _amount) internal pure {
1507         require(_amount > 0, "CBM: Amount must be > 0");
1508     }
1509 
1510     function _requireNonZeroBLUSDSupply() internal view {
1511         require(bLUSDToken.totalSupply() > 0, "CBM: bLUSD Supply must be > 0 upon shifting");
1512     }
1513 
1514     function _requireMinBond(uint256 _lusdAmount) internal view {
1515         require(_lusdAmount >= MIN_BOND_AMOUNT, "CBM: Bond minimum amount not reached");
1516     }
1517 
1518     function _requireRedemptionNotDepletingbLUSD(uint256 _bLUSDToRedeem) internal view {
1519         if (!migration) {
1520             //require(_bLUSDToRedeem < bLUSDTotalSupply, "CBM: Cannot redeem total supply");
1521             require(_bLUSDToRedeem + MIN_BLUSD_SUPPLY <= bLUSDToken.totalSupply(), "CBM: Cannot redeem below min supply");
1522         }
1523     }
1524 
1525     function _requireMigrationNotActive() internal view {
1526         require(!migration, "CBM: Migration must be not be active");
1527     }
1528 
1529     function _requireCallerIsYearnGovernance() internal view {
1530         require(msg.sender == yearnGovernanceAddress, "CBM: Only Yearn Governance can call");
1531     }
1532 
1533     function _requireEnoughLUSDInBAMM(uint256 _requestedLUSD, uint256 _minLUSD) internal view returns (uint256) {
1534         require(_requestedLUSD >= _minLUSD, "CBM: Min value cannot be greater than nominal amount");
1535 
1536         (, uint256 lusdInBAMMSPVault,) = bammSPVault.getLUSDValue();
1537         require(lusdInBAMMSPVault >= _minLUSD, "CBM: Not enough LUSD available in B.Protocol");
1538 
1539         uint256 lusdToWithdraw = Math.min(_requestedLUSD, lusdInBAMMSPVault);
1540 
1541         return lusdToWithdraw;
1542     }
1543 
1544     function _requireShiftBootstrapPeriodEnded() internal view {
1545         require(block.timestamp - deploymentTimestamp >= BOOTSTRAP_PERIOD_SHIFT, "CBM: Shifter only callable after shift bootstrap period ends");
1546     }
1547 
1548     function _requireShiftWindowIsOpen() internal view {
1549         uint256 shiftWindowStartTime = lastShifterCountdownStartTime + SHIFTER_DELAY;
1550         uint256 shiftWindowFinishTime = shiftWindowStartTime + SHIFTER_WINDOW;
1551 
1552         require(block.timestamp >= shiftWindowStartTime && block.timestamp < shiftWindowFinishTime, "CBM: Shift only possible inside shifting window");
1553     }
1554 
1555     function _requirePermanentGreaterThanCurve(uint256 _totalLUSDInCurve) internal view {
1556         require(permanentLUSD >= _totalLUSDInCurve, "CBM: The amount in Curve cannot be greater than the Permanent bucket");
1557     }
1558 
1559     // --- Getter convenience functions ---
1560 
1561     // Bond getters
1562 
1563     function getBondData(uint256 _bondID)
1564         external
1565         view
1566         returns (
1567             uint256 lusdAmount,
1568             uint64 claimedBLUSD,
1569             uint64 startTime,
1570             uint64 endTime,
1571             uint8 status
1572         )
1573     {
1574         BondData memory bond = idToBondData[_bondID];
1575         return (bond.lusdAmount, bond.claimedBLUSD, bond.startTime, bond.endTime, uint8(bond.status));
1576     }
1577 
1578     function getLUSDToAcquire(uint256 _bondID) external view returns (uint256) {
1579         BondData memory bond = idToBondData[_bondID];
1580 
1581         (uint256 updatedAccrualParameter, ) = _calcUpdatedAccrualParameter(accrualParameter, accrualAdjustmentPeriodCount);
1582 
1583         return _calcAccruedAmount(bond.startTime, _getBondAmountMinusChickenInFee(bond.lusdAmount), updatedAccrualParameter);
1584     }
1585 
1586     function calcAccruedBLUSD(uint256 _bondID) external view returns (uint256) {
1587         BondData memory bond = idToBondData[_bondID];
1588 
1589         if (bond.status != BondStatus.active) {
1590             return 0;
1591         }
1592 
1593         uint256 bondBLUSDCap = _calcBondBLUSDCap(_getBondAmountMinusChickenInFee(bond.lusdAmount), calcSystemBackingRatio());
1594 
1595         (uint256 updatedAccrualParameter, ) = _calcUpdatedAccrualParameter(accrualParameter, accrualAdjustmentPeriodCount);
1596 
1597         return _calcAccruedAmount(bond.startTime, bondBLUSDCap, updatedAccrualParameter);
1598     }
1599 
1600     function calcBondBLUSDCap(uint256 _bondID) external view returns (uint256) {
1601         uint256 backingRatio = calcSystemBackingRatio();
1602 
1603         BondData memory bond = idToBondData[_bondID];
1604 
1605         return _calcBondBLUSDCap(_getBondAmountMinusChickenInFee(bond.lusdAmount), backingRatio);
1606     }
1607 
1608     function getLUSDInBAMMSPVault() external view returns (uint256) {
1609         (, uint256 lusdInBAMMSPVault,) = bammSPVault.getLUSDValue();
1610 
1611         return lusdInBAMMSPVault;
1612     }
1613 
1614     // Native vault token value getters
1615 
1616     // Calculates the LUSD3CRV value of LUSD Curve Vault yTokens held by the ChickenBondManager
1617     function calcTotalYearnCurveVaultShareValue() public view returns (uint256) {
1618         return yTokensHeldByCBM * yearnCurveVault.pricePerShare() / 1e18;
1619     }
1620 
1621     // Calculates the LUSD value of this contract, including B.Protocol LUSD Vault and Curve Vault
1622     function calcTotalLUSDValue() external view returns (uint256) {
1623         uint256 totalLUSDInCurve = getTotalLUSDInCurve();
1624         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1625 
1626         return bammLUSDValue + totalLUSDInCurve;
1627     }
1628 
1629     function getTotalLUSDInCurve() public view returns (uint256) {
1630         uint256 LUSD3CRVInCurve = calcTotalYearnCurveVaultShareValue();
1631         uint256 totalLUSDInCurve;
1632         if (LUSD3CRVInCurve > 0) {
1633             uint256 LUSD3CRVVirtualPrice = curvePool.get_virtual_price();
1634             totalLUSDInCurve = LUSD3CRVInCurve * LUSD3CRVVirtualPrice / 1e18;
1635         }
1636 
1637         return totalLUSDInCurve;
1638     }
1639 
1640     // Pending getter
1641 
1642     function getPendingLUSD() external view returns (uint256) {
1643         return pendingLUSD;
1644     }
1645 
1646     // Acquired getters
1647 
1648     function _getLUSDSplit(uint256 _bammLUSDValue)
1649         internal
1650         view
1651         returns (
1652             uint256 acquiredLUSDInSP,
1653             uint256 acquiredLUSDInCurve,
1654             uint256 ownedLUSDInSP,
1655             uint256 ownedLUSDInCurve,
1656             uint256 permanentLUSDCached
1657         )
1658     {
1659         // _bammLUSDValue is guaranteed to be at least pendingLUSD due to the way we track BAMM debt
1660         ownedLUSDInSP = _bammLUSDValue - pendingLUSD;
1661         ownedLUSDInCurve = getTotalLUSDInCurve(); // All LUSD in Curve is owned
1662         permanentLUSDCached = permanentLUSD;
1663 
1664         uint256 ownedLUSD = ownedLUSDInSP + ownedLUSDInCurve;
1665 
1666         if (ownedLUSD > permanentLUSDCached) {
1667             // ownedLUSD > 0 implied
1668             uint256 acquiredLUSD = ownedLUSD - permanentLUSDCached;
1669             acquiredLUSDInSP = acquiredLUSD * ownedLUSDInSP / ownedLUSD;
1670             acquiredLUSDInCurve = acquiredLUSD - acquiredLUSDInSP;
1671         }
1672     }
1673 
1674     // Helper to avoid stack too deep in redeem() (we save one local variable)
1675     function _getLUSDSplitAfterUpdatingBAMMDebt()
1676         internal
1677         returns (
1678             uint256 acquiredLUSDInSP,
1679             uint256 acquiredLUSDInCurve,
1680             uint256 ownedLUSDInSP,
1681             uint256 ownedLUSDInCurve,
1682             uint256 permanentLUSDCached
1683         )
1684     {
1685         (uint256 bammLUSDValue,) = _updateBAMMDebt();
1686         return _getLUSDSplit(bammLUSDValue);
1687     }
1688 
1689     function getTotalAcquiredLUSD() public view returns (uint256) {
1690         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1691         (uint256 acquiredLUSDInSP, uint256 acquiredLUSDInCurve,,,) = _getLUSDSplit(bammLUSDValue);
1692         return acquiredLUSDInSP + acquiredLUSDInCurve;
1693     }
1694 
1695     function getAcquiredLUSDInSP() external view returns (uint256) {
1696         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1697         (uint256 acquiredLUSDInSP,,,,) = _getLUSDSplit(bammLUSDValue);
1698         return acquiredLUSDInSP;
1699     }
1700 
1701     function getAcquiredLUSDInCurve() external view returns (uint256) {
1702         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1703         (, uint256 acquiredLUSDInCurve,,,) = _getLUSDSplit(bammLUSDValue);
1704         return acquiredLUSDInCurve;
1705     }
1706 
1707     // Permanent getter
1708 
1709     function getPermanentLUSD() external view returns (uint256) {
1710         return permanentLUSD;
1711     }
1712 
1713     // Owned getters
1714 
1715     function getOwnedLUSDInSP() external view returns (uint256) {
1716         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1717         (,, uint256 ownedLUSDInSP,,) = _getLUSDSplit(bammLUSDValue);
1718         return ownedLUSDInSP;
1719     }
1720 
1721     function getOwnedLUSDInCurve() external view returns (uint256) {
1722         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1723         (,,, uint256 ownedLUSDInCurve,) = _getLUSDSplit(bammLUSDValue);
1724         return ownedLUSDInCurve;
1725     }
1726 
1727     // Other getters
1728 
1729     function calcSystemBackingRatio() public view returns (uint256) {
1730         uint256 bammLUSDValue = _getInternalBAMMLUSDValue();
1731         return _calcSystemBackingRatioFromBAMMValue(bammLUSDValue);
1732     }
1733 
1734     function _calcSystemBackingRatioFromBAMMValue(uint256 _bammLUSDValue) public view returns (uint256) {
1735         uint256 totalBLUSDSupply = bLUSDToken.totalSupply();
1736         (uint256 acquiredLUSDInSP, uint256 acquiredLUSDInCurve,,,) = _getLUSDSplit(_bammLUSDValue);
1737 
1738         /* TODO: Determine how to define the backing ratio when there is 0 bLUSD and 0 totalAcquiredLUSD,
1739          * i.e. before the first chickenIn. For now, return a backing ratio of 1. Note: Both quantities would be 0
1740          * also when the bLUSD supply is fully redeemed.
1741          */
1742         //if (totalBLUSDSupply == 0  && totalAcquiredLUSD == 0) {return 1e18;}
1743         //if (totalBLUSDSupply == 0) {return MAX_UINT256;}
1744         if (totalBLUSDSupply == 0) {return 1e18;}
1745 
1746         return  (acquiredLUSDInSP + acquiredLUSDInCurve) * 1e18 / totalBLUSDSupply;
1747     }
1748 
1749     function calcUpdatedAccrualParameter() external view returns (uint256) {
1750         (uint256 updatedAccrualParameter, ) = _calcUpdatedAccrualParameter(accrualParameter, accrualAdjustmentPeriodCount);
1751         return updatedAccrualParameter;
1752     }
1753 
1754     function getBAMMLUSDDebt() external view returns (uint256) {
1755         return bammLUSDDebt;
1756     }
1757 
1758     function getTreasury()
1759         external
1760         view
1761         returns (
1762             // We don't normally use leading underscores for return values,
1763             // but we do so here in order to avoid shadowing state variables
1764             uint256 _pendingLUSD,
1765             uint256 _totalAcquiredLUSD,
1766             uint256 _permanentLUSD
1767         )
1768     {
1769         _pendingLUSD = pendingLUSD;
1770         _totalAcquiredLUSD = getTotalAcquiredLUSD();
1771         _permanentLUSD = permanentLUSD;
1772     }
1773 
1774     function getOpenBondCount() external view returns (uint256 openBondCount) {
1775         return bondNFT.totalSupply() - countChickenIn - countChickenOut;
1776     }
1777 }