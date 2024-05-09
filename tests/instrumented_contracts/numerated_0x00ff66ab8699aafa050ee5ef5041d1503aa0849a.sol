1 /*
2 B.PROTOCOL TERMS OF USE
3 =======================
4 
5 THE TERMS OF USE CONTAINED HEREIN (THESE “TERMS”) GOVERN YOUR USE OF B.PROTOCOL, WHICH IS A DECENTRALIZED PROTOCOL ON THE ETHEREUM BLOCKCHAIN (the “PROTOCOL”) THAT enables a backstop liquidity mechanism FOR DECENTRALIZED LENDING PLATFORMS (“DLPs”).  
6 PLEASE READ THESE TERMS CAREFULLY AT https://github.com/backstop-protocol/Terms-and-Conditions, INCLUDING ALL DISCLAIMERS AND RISK FACTORS, BEFORE USING THE PROTOCOL. BY USING THE PROTOCOL, YOU ARE IRREVOCABLY CONSENTING TO BE BOUND BY THESE TERMS. 
7 IF YOU DO NOT AGREE TO ALL OF THESE TERMS, DO NOT USE THE PROTOCOL. YOUR RIGHT TO USE THE PROTOCOL IS SUBJECT AND DEPENDENT BY YOUR AGREEMENT TO ALL TERMS AND CONDITIONS SET FORTH HEREIN, WHICH AGREEMENT SHALL BE EVIDENCED BY YOUR USE OF THE PROTOCOL.
8 Minors Prohibited: The Protocol is not directed to individuals under the age of eighteen (18) or the age of majority in your jurisdiction if the age of majority is greater. If you are under the age of eighteen or the age of majority (if greater), you are not authorized to access or use the Protocol. By using the Protocol, you represent and warrant that you are above such age.
9 
10 License; No Warranties; Limitation of Liability;
11 (a) The software underlying the Protocol is licensed for use in accordance with the 3-clause BSD License, which can be accessed here: https://opensource.org/licenses/BSD-3-Clause.
12 (b) THE PROTOCOL IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS", “WITH ALL FAULTS” and “AS AVAILABLE” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
13 (c) IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
14 */
15 
16 // Sources flattened with hardhat v2.8.3 https://hardhat.org
17 
18 // File contracts/Interfaces/IBorrowerOperations.sol
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity 0.6.11;
23 
24 // Common interface for the Trove Manager.
25 interface IBorrowerOperations {
26 
27     // --- Events ---
28 
29     event TroveManagerAddressChanged(address _newTroveManagerAddress);
30     event ActivePoolAddressChanged(address _activePoolAddress);
31     event DefaultPoolAddressChanged(address _defaultPoolAddress);
32     event StabilityPoolAddressChanged(address _stabilityPoolAddress);
33     event GasPoolAddressChanged(address _gasPoolAddress);
34     event CollSurplusPoolAddressChanged(address _collSurplusPoolAddress);
35     event PriceFeedAddressChanged(address  _newPriceFeedAddress);
36     event SortedTrovesAddressChanged(address _sortedTrovesAddress);
37     event LUSDTokenAddressChanged(address _lusdTokenAddress);
38     event LQTYStakingAddressChanged(address _lqtyStakingAddress);
39 
40     event TroveCreated(address indexed _borrower, uint arrayIndex);
41     event TroveUpdated(address indexed _borrower, uint _debt, uint _coll, uint stake, uint8 operation);
42     event LUSDBorrowingFeePaid(address indexed _borrower, uint _LUSDFee);
43 
44     // --- Functions ---
45 
46     function setAddresses(
47         address _troveManagerAddress,
48         address _activePoolAddress,
49         address _defaultPoolAddress,
50         address _stabilityPoolAddress,
51         address _gasPoolAddress,
52         address _collSurplusPoolAddress,
53         address _priceFeedAddress,
54         address _sortedTrovesAddress,
55         address _lusdTokenAddress,
56         address _lqtyStakingAddress
57     ) external;
58 
59     function openTrove(uint _maxFee, uint _LUSDAmount, address _upperHint, address _lowerHint) external payable;
60 
61     function addColl(address _upperHint, address _lowerHint) external payable;
62 
63     function moveETHGainToTrove(address _user, address _upperHint, address _lowerHint) external payable;
64 
65     function withdrawColl(uint _amount, address _upperHint, address _lowerHint) external;
66 
67     function withdrawLUSD(uint _maxFee, uint _amount, address _upperHint, address _lowerHint) external;
68 
69     function repayLUSD(uint _amount, address _upperHint, address _lowerHint) external;
70 
71     function closeTrove() external;
72 
73     function adjustTrove(uint _maxFee, uint _collWithdrawal, uint _debtChange, bool isDebtIncrease, address _upperHint, address _lowerHint) external payable;
74 
75     function claimCollateral() external;
76 
77     function getCompositeDebt(uint _debt) external pure returns (uint);
78 }
79 
80 
81 // File contracts/Interfaces/IStabilityPool.sol
82 
83 
84 
85 pragma solidity 0.6.11;
86 
87 /*
88  * The Stability Pool holds LUSD tokens deposited by Stability Pool depositors.
89  *
90  * When a trove is liquidated, then depending on system conditions, some of its LUSD debt gets offset with
91  * LUSD in the Stability Pool:  that is, the offset debt evaporates, and an equal amount of LUSD tokens in the Stability Pool is burned.
92  *
93  * Thus, a liquidation causes each depositor to receive a LUSD loss, in proportion to their deposit as a share of total deposits.
94  * They also receive an ETH gain, as the ETH collateral of the liquidated trove is distributed among Stability depositors,
95  * in the same proportion.
96  *
97  * When a liquidation occurs, it depletes every deposit by the same fraction: for example, a liquidation that depletes 40%
98  * of the total LUSD in the Stability Pool, depletes 40% of each deposit.
99  *
100  * A deposit that has experienced a series of liquidations is termed a "compounded deposit": each liquidation depletes the deposit,
101  * multiplying it by some factor in range ]0,1[
102  *
103  * Please see the implementation spec in the proof document, which closely follows on from the compounded deposit / ETH gain derivations:
104  * https://github.com/liquity/liquity/blob/master/papers/Scalable_Reward_Distribution_with_Compounding_Stakes.pdf
105  *
106  * --- LQTY ISSUANCE TO STABILITY POOL DEPOSITORS ---
107  *
108  * An LQTY issuance event occurs at every deposit operation, and every liquidation.
109  *
110  * Each deposit is tagged with the address of the front end through which it was made.
111  *
112  * All deposits earn a share of the issued LQTY in proportion to the deposit as a share of total deposits. The LQTY earned
113  * by a given deposit, is split between the depositor and the front end through which the deposit was made, based on the front end's kickbackRate.
114  *
115  * Please see the system Readme for an overview:
116  * https://github.com/liquity/dev/blob/main/README.md#lqty-issuance-to-stability-providers
117  */
118 interface IStabilityPool {
119 
120     // --- Events ---
121     
122     event StabilityPoolETHBalanceUpdated(uint _newBalance);
123     event StabilityPoolLUSDBalanceUpdated(uint _newBalance);
124 
125     event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
126     event TroveManagerAddressChanged(address _newTroveManagerAddress);
127     event ActivePoolAddressChanged(address _newActivePoolAddress);
128     event DefaultPoolAddressChanged(address _newDefaultPoolAddress);
129     event LUSDTokenAddressChanged(address _newLUSDTokenAddress);
130     event SortedTrovesAddressChanged(address _newSortedTrovesAddress);
131     event PriceFeedAddressChanged(address _newPriceFeedAddress);
132     event CommunityIssuanceAddressChanged(address _newCommunityIssuanceAddress);
133 
134     event P_Updated(uint _P);
135     event S_Updated(uint _S, uint128 _epoch, uint128 _scale);
136     event G_Updated(uint _G, uint128 _epoch, uint128 _scale);
137     event EpochUpdated(uint128 _currentEpoch);
138     event ScaleUpdated(uint128 _currentScale);
139 
140     event FrontEndRegistered(address indexed _frontEnd, uint _kickbackRate);
141     event FrontEndTagSet(address indexed _depositor, address indexed _frontEnd);
142 
143     event DepositSnapshotUpdated(address indexed _depositor, uint _P, uint _S, uint _G);
144     event FrontEndSnapshotUpdated(address indexed _frontEnd, uint _P, uint _G);
145     event UserDepositChanged(address indexed _depositor, uint _newDeposit);
146     event FrontEndStakeChanged(address indexed _frontEnd, uint _newFrontEndStake, address _depositor);
147 
148     event ETHGainWithdrawn(address indexed _depositor, uint _ETH, uint _LUSDLoss);
149     event LQTYPaidToDepositor(address indexed _depositor, uint _LQTY);
150     event LQTYPaidToFrontEnd(address indexed _frontEnd, uint _LQTY);
151     event EtherSent(address _to, uint _amount);
152 
153     // --- Functions ---
154 
155     /*
156      * Called only once on init, to set addresses of other Liquity contracts
157      * Callable only by owner, renounces ownership at the end
158      */
159     function setAddresses(
160         address _borrowerOperationsAddress,
161         address _troveManagerAddress,
162         address _activePoolAddress,
163         address _lusdTokenAddress,
164         address _sortedTrovesAddress,
165         address _priceFeedAddress,
166         address _communityIssuanceAddress
167     ) external;
168 
169     /*
170      * Initial checks:
171      * - Frontend is registered or zero address
172      * - Sender is not a registered frontend
173      * - _amount is not zero
174      * ---
175      * - Triggers a LQTY issuance, based on time passed since the last issuance. The LQTY issuance is shared between *all* depositors and front ends
176      * - Tags the deposit with the provided front end tag param, if it's a new deposit
177      * - Sends depositor's accumulated gains (LQTY, ETH) to depositor
178      * - Sends the tagged front end's accumulated LQTY gains to the tagged front end
179      * - Increases deposit and tagged front end's stake, and takes new snapshots for each.
180      */
181     function provideToSP(uint _amount, address _frontEndTag) external;
182 
183     /*
184      * Initial checks:
185      * - _amount is zero or there are no under collateralized troves left in the system
186      * - User has a non zero deposit
187      * ---
188      * - Triggers a LQTY issuance, based on time passed since the last issuance. The LQTY issuance is shared between *all* depositors and front ends
189      * - Removes the deposit's front end tag if it is a full withdrawal
190      * - Sends all depositor's accumulated gains (LQTY, ETH) to depositor
191      * - Sends the tagged front end's accumulated LQTY gains to the tagged front end
192      * - Decreases deposit and tagged front end's stake, and takes new snapshots for each.
193      *
194      * If _amount > userDeposit, the user withdraws all of their compounded deposit.
195      */
196     function withdrawFromSP(uint _amount) external;
197 
198     /*
199      * Initial checks:
200      * - User has a non zero deposit
201      * - User has an open trove
202      * - User has some ETH gain
203      * ---
204      * - Triggers a LQTY issuance, based on time passed since the last issuance. The LQTY issuance is shared between *all* depositors and front ends
205      * - Sends all depositor's LQTY gain to  depositor
206      * - Sends all tagged front end's LQTY gain to the tagged front end
207      * - Transfers the depositor's entire ETH gain from the Stability Pool to the caller's trove
208      * - Leaves their compounded deposit in the Stability Pool
209      * - Updates snapshots for deposit and tagged front end stake
210      */
211     function withdrawETHGainToTrove(address _upperHint, address _lowerHint) external;
212 
213     /*
214      * Initial checks:
215      * - Frontend (sender) not already registered
216      * - User (sender) has no deposit
217      * - _kickbackRate is in the range [0, 100%]
218      * ---
219      * Front end makes a one-time selection of kickback rate upon registering
220      */
221     function registerFrontEnd(uint _kickbackRate) external;
222 
223     /*
224      * Initial checks:
225      * - Caller is TroveManager
226      * ---
227      * Cancels out the specified debt against the LUSD contained in the Stability Pool (as far as possible)
228      * and transfers the Trove's ETH collateral from ActivePool to StabilityPool.
229      * Only called by liquidation functions in the TroveManager.
230      */
231     function offset(uint _debt, uint _coll) external;
232 
233     /*
234      * Returns the total amount of ETH held by the pool, accounted in an internal variable instead of `balance`,
235      * to exclude edge cases like ETH received from a self-destruct.
236      */
237     function getETH() external view returns (uint);
238 
239     /*
240      * Returns LUSD held in the pool. Changes when users deposit/withdraw, and when Trove debt is offset.
241      */
242     function getTotalLUSDDeposits() external view returns (uint);
243 
244     /*
245      * Calculates the ETH gain earned by the deposit since its last snapshots were taken.
246      */
247     function getDepositorETHGain(address _depositor) external view returns (uint);
248 
249     /*
250      * Calculate the LQTY gain earned by a deposit since its last snapshots were taken.
251      * If not tagged with a front end, the depositor gets a 100% cut of what their deposit earned.
252      * Otherwise, their cut of the deposit's earnings is equal to the kickbackRate, set by the front end through
253      * which they made their deposit.
254      */
255     function getDepositorLQTYGain(address _depositor) external view returns (uint);
256 
257     /*
258      * Return the LQTY gain earned by the front end.
259      */
260     function getFrontEndLQTYGain(address _frontEnd) external view returns (uint);
261 
262     /*
263      * Return the user's compounded deposit.
264      */
265     function getCompoundedLUSDDeposit(address _depositor) external view returns (uint);
266 
267     /*
268      * Return the front end's compounded stake.
269      *
270      * The front end's compounded stake is equal to the sum of its depositors' compounded deposits.
271      */
272     function getCompoundedFrontEndStake(address _frontEnd) external view returns (uint);
273 
274     /*
275      * Fallback function
276      * Only callable by Active Pool, it just accounts for ETH received
277      * receive() external payable;
278      */
279 }
280 
281 
282 // File contracts/Interfaces/IPriceFeed.sol
283 
284 
285 
286 pragma solidity 0.6.11;
287 
288 interface IPriceFeed {
289 
290     // --- Events ---
291     event LastGoodPriceUpdated(uint _lastGoodPrice);
292    
293     // --- Function ---
294     function fetchPrice() external returns (uint);
295 }
296 
297 
298 // File contracts/Interfaces/ILiquityBase.sol
299 
300 
301 
302 pragma solidity 0.6.11;
303 
304 interface ILiquityBase {
305     function priceFeed() external view returns (IPriceFeed);
306 }
307 
308 
309 // File contracts/Dependencies/IERC20.sol
310 
311 
312 
313 pragma solidity 0.6.11;
314 
315 /**
316  * Based on the OpenZeppelin IER20 interface:
317  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
318  *
319  * @dev Interface of the ERC20 standard as defined in the EIP.
320  */
321 interface IERC20 {
322     /**
323      * @dev Returns the amount of tokens in existence.
324      */
325     function totalSupply() external view returns (uint256);
326 
327     /**
328      * @dev Returns the amount of tokens owned by `account`.
329      */
330     function balanceOf(address account) external view returns (uint256);
331 
332     /**
333      * @dev Moves `amount` tokens from the caller's account to `recipient`.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * Emits a {Transfer} event.
338      */
339     function transfer(address recipient, uint256 amount) external returns (bool);
340 
341     /**
342      * @dev Returns the remaining number of tokens that `spender` will be
343      * allowed to spend on behalf of `owner` through {transferFrom}. This is
344      * zero by default.
345      *
346      * This value changes when {approve} or {transferFrom} are called.
347      */
348     function allowance(address owner, address spender) external view returns (uint256);
349     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
350     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
351 
352     /**
353      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * IMPORTANT: Beware that changing an allowance with this method brings the risk
358      * that someone may use both the old and the new allowance by unfortunate
359      * transaction ordering. One possible solution to mitigate this race
360      * condition is to first reduce the spender's allowance to 0 and set the
361      * desired value afterwards:
362      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363      *
364      * Emits an {Approval} event.
365      */
366     function approve(address spender, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Moves `amount` tokens from `sender` to `recipient` using the
370      * allowance mechanism. `amount` is then deducted from the caller's
371      * allowance.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
378 
379     function name() external view returns (string memory);
380     function symbol() external view returns (string memory);
381     function decimals() external view returns (uint8);
382     
383     /**
384      * @dev Emitted when `value` tokens are moved from one account (`from`) to
385      * another (`to`).
386      *
387      * Note that `value` may be zero.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 value);
390 
391     /**
392      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
393      * a call to {approve}. `value` is the new allowance.
394      */
395     event Approval(address indexed owner, address indexed spender, uint256 value);
396 }
397 
398 
399 // File contracts/Dependencies/IERC2612.sol
400 
401 
402 
403 pragma solidity 0.6.11;
404 
405 /**
406  * @dev Interface of the ERC2612 standard as defined in the EIP.
407  *
408  * Adds the {permit} method, which can be used to change one's
409  * {IERC20-allowance} without having to send a transaction, by signing a
410  * message. This allows users to spend tokens without having to hold Ether.
411  *
412  * See https://eips.ethereum.org/EIPS/eip-2612.
413  * 
414  * Code adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/
415  */
416 interface IERC2612 {
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
419      * given `owner`'s signed approval.
420      *
421      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
422      * ordering also apply here.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      * - `deadline` must be a timestamp in the future.
431      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
432      * over the EIP712-formatted function arguments.
433      * - the signature must use ``owner``'s current nonce (see {nonces}).
434      *
435      * For more information on the signature format, see the
436      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
437      * section].
438      */
439     function permit(address owner, address spender, uint256 amount, 
440                     uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
441     
442     /**
443      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
444      * included whenever a signature is generated for {permit}.
445      *
446      * Every successful call to {permit} increases `owner`'s nonce by one. This
447      * prevents a signature from being used multiple times.
448      *
449      * `owner` can limit the time a Permit is valid for by setting `deadline` to 
450      * a value in the near future. The deadline argument can be set to uint(-1) to 
451      * create Permits that effectively never expire.
452      */
453     function nonces(address owner) external view returns (uint256);
454     
455     function version() external view returns (string memory);
456     function permitTypeHash() external view returns (bytes32);
457     function domainSeparator() external view returns (bytes32);
458 }
459 
460 
461 // File contracts/Interfaces/ILUSDToken.sol
462 
463 
464 
465 pragma solidity 0.6.11;
466 
467 
468 interface ILUSDToken is IERC20, IERC2612 { 
469     
470     // --- Events ---
471 
472     event TroveManagerAddressChanged(address _troveManagerAddress);
473     event StabilityPoolAddressChanged(address _newStabilityPoolAddress);
474     event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
475 
476     event LUSDTokenBalanceUpdated(address _user, uint _amount);
477 
478     // --- Functions ---
479 
480     function mint(address _account, uint256 _amount) external;
481 
482     function burn(address _account, uint256 _amount) external;
483 
484     function sendToPool(address _sender,  address poolAddress, uint256 _amount) external;
485 
486     function returnFromPool(address poolAddress, address user, uint256 _amount ) external;
487 }
488 
489 
490 // File contracts/Interfaces/ILQTYToken.sol
491 
492 
493 
494 pragma solidity 0.6.11;
495 
496 
497 interface ILQTYToken is IERC20, IERC2612 { 
498    
499     // --- Events ---
500     
501     event CommunityIssuanceAddressSet(address _communityIssuanceAddress);
502     event LQTYStakingAddressSet(address _lqtyStakingAddress);
503     event LockupContractFactoryAddressSet(address _lockupContractFactoryAddress);
504 
505     // --- Functions ---
506     
507     function sendToLQTYStaking(address _sender, uint256 _amount) external;
508 
509     function getDeploymentStartTime() external view returns (uint256);
510 
511     function getLpRewardsEntitlement() external view returns (uint256);
512 }
513 
514 
515 // File contracts/Interfaces/ILQTYStaking.sol
516 
517 
518 
519 pragma solidity 0.6.11;
520 
521 interface ILQTYStaking {
522 
523     // --- Events --
524     
525     event LQTYTokenAddressSet(address _lqtyTokenAddress);
526     event LUSDTokenAddressSet(address _lusdTokenAddress);
527     event TroveManagerAddressSet(address _troveManager);
528     event BorrowerOperationsAddressSet(address _borrowerOperationsAddress);
529     event ActivePoolAddressSet(address _activePoolAddress);
530 
531     event StakeChanged(address indexed staker, uint newStake);
532     event StakingGainsWithdrawn(address indexed staker, uint LUSDGain, uint ETHGain);
533     event F_ETHUpdated(uint _F_ETH);
534     event F_LUSDUpdated(uint _F_LUSD);
535     event TotalLQTYStakedUpdated(uint _totalLQTYStaked);
536     event EtherSent(address _account, uint _amount);
537     event StakerSnapshotsUpdated(address _staker, uint _F_ETH, uint _F_LUSD);
538 
539     // --- Functions ---
540 
541     function setAddresses
542     (
543         address _lqtyTokenAddress,
544         address _lusdTokenAddress,
545         address _troveManagerAddress, 
546         address _borrowerOperationsAddress,
547         address _activePoolAddress
548     )  external;
549 
550     function stake(uint _LQTYamount) external;
551 
552     function unstake(uint _LQTYamount) external;
553 
554     function increaseF_ETH(uint _ETHFee) external; 
555 
556     function increaseF_LUSD(uint _LQTYFee) external;  
557 
558     function getPendingETHGain(address _user) external view returns (uint);
559 
560     function getPendingLUSDGain(address _user) external view returns (uint);
561 }
562 
563 
564 // File contracts/Interfaces/ITroveManager.sol
565 
566 
567 
568 pragma solidity 0.6.11;
569 
570 
571 
572 
573 
574 // Common interface for the Trove Manager.
575 interface ITroveManager is ILiquityBase {
576     
577     // --- Events ---
578 
579     event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
580     event PriceFeedAddressChanged(address _newPriceFeedAddress);
581     event LUSDTokenAddressChanged(address _newLUSDTokenAddress);
582     event ActivePoolAddressChanged(address _activePoolAddress);
583     event DefaultPoolAddressChanged(address _defaultPoolAddress);
584     event StabilityPoolAddressChanged(address _stabilityPoolAddress);
585     event GasPoolAddressChanged(address _gasPoolAddress);
586     event CollSurplusPoolAddressChanged(address _collSurplusPoolAddress);
587     event SortedTrovesAddressChanged(address _sortedTrovesAddress);
588     event LQTYTokenAddressChanged(address _lqtyTokenAddress);
589     event LQTYStakingAddressChanged(address _lqtyStakingAddress);
590 
591     event Liquidation(uint _liquidatedDebt, uint _liquidatedColl, uint _collGasCompensation, uint _LUSDGasCompensation);
592     event Redemption(uint _attemptedLUSDAmount, uint _actualLUSDAmount, uint _ETHSent, uint _ETHFee);
593     event TroveUpdated(address indexed _borrower, uint _debt, uint _coll, uint stake, uint8 operation);
594     event TroveLiquidated(address indexed _borrower, uint _debt, uint _coll, uint8 operation);
595     event BaseRateUpdated(uint _baseRate);
596     event LastFeeOpTimeUpdated(uint _lastFeeOpTime);
597     event TotalStakesUpdated(uint _newTotalStakes);
598     event SystemSnapshotsUpdated(uint _totalStakesSnapshot, uint _totalCollateralSnapshot);
599     event LTermsUpdated(uint _L_ETH, uint _L_LUSDDebt);
600     event TroveSnapshotsUpdated(uint _L_ETH, uint _L_LUSDDebt);
601     event TroveIndexUpdated(address _borrower, uint _newIndex);
602 
603     // --- Functions ---
604 
605     function setAddresses(
606         address _borrowerOperationsAddress,
607         address _activePoolAddress,
608         address _defaultPoolAddress,
609         address _stabilityPoolAddress,
610         address _gasPoolAddress,
611         address _collSurplusPoolAddress,
612         address _priceFeedAddress,
613         address _lusdTokenAddress,
614         address _sortedTrovesAddress,
615         address _lqtyTokenAddress,
616         address _lqtyStakingAddress
617     ) external;
618 
619     function stabilityPool() external view returns (IStabilityPool);
620     function lusdToken() external view returns (ILUSDToken);
621     function lqtyToken() external view returns (ILQTYToken);
622     function lqtyStaking() external view returns (ILQTYStaking);
623 
624     function getTroveOwnersCount() external view returns (uint);
625 
626     function getTroveFromTroveOwnersArray(uint _index) external view returns (address);
627 
628     function getNominalICR(address _borrower) external view returns (uint);
629     function getCurrentICR(address _borrower, uint _price) external view returns (uint);
630 
631     function liquidate(address _borrower) external;
632 
633     function liquidateTroves(uint _n) external;
634 
635     function batchLiquidateTroves(address[] calldata _troveArray) external;
636 
637     function redeemCollateral(
638         uint _LUSDAmount,
639         address _firstRedemptionHint,
640         address _upperPartialRedemptionHint,
641         address _lowerPartialRedemptionHint,
642         uint _partialRedemptionHintNICR,
643         uint _maxIterations,
644         uint _maxFee
645     ) external; 
646 
647     function updateStakeAndTotalStakes(address _borrower) external returns (uint);
648 
649     function updateTroveRewardSnapshots(address _borrower) external;
650 
651     function addTroveOwnerToArray(address _borrower) external returns (uint index);
652 
653     function applyPendingRewards(address _borrower) external;
654 
655     function getPendingETHReward(address _borrower) external view returns (uint);
656 
657     function getPendingLUSDDebtReward(address _borrower) external view returns (uint);
658 
659      function hasPendingRewards(address _borrower) external view returns (bool);
660 
661     function getEntireDebtAndColl(address _borrower) external view returns (
662         uint debt, 
663         uint coll, 
664         uint pendingLUSDDebtReward, 
665         uint pendingETHReward
666     );
667 
668     function closeTrove(address _borrower) external;
669 
670     function removeStake(address _borrower) external;
671 
672     function getRedemptionRate() external view returns (uint);
673     function getRedemptionRateWithDecay() external view returns (uint);
674 
675     function getRedemptionFeeWithDecay(uint _ETHDrawn) external view returns (uint);
676 
677     function getBorrowingRate() external view returns (uint);
678     function getBorrowingRateWithDecay() external view returns (uint);
679 
680     function getBorrowingFee(uint LUSDDebt) external view returns (uint);
681     function getBorrowingFeeWithDecay(uint _LUSDDebt) external view returns (uint);
682 
683     function decayBaseRateFromBorrowing() external;
684 
685     function getTroveStatus(address _borrower) external view returns (uint);
686     
687     function getTroveStake(address _borrower) external view returns (uint);
688 
689     function getTroveDebt(address _borrower) external view returns (uint);
690 
691     function getTroveColl(address _borrower) external view returns (uint);
692 
693     function setTroveStatus(address _borrower, uint num) external;
694 
695     function increaseTroveColl(address _borrower, uint _collIncrease) external returns (uint);
696 
697     function decreaseTroveColl(address _borrower, uint _collDecrease) external returns (uint); 
698 
699     function increaseTroveDebt(address _borrower, uint _debtIncrease) external returns (uint); 
700 
701     function decreaseTroveDebt(address _borrower, uint _collDecrease) external returns (uint); 
702 
703     function getTCR(uint _price) external view returns (uint);
704 
705     function checkRecoveryMode(uint _price) external view returns (bool);
706 }
707 
708 
709 // File contracts/Interfaces/ISortedTroves.sol
710 
711 
712 
713 pragma solidity 0.6.11;
714 
715 // Common interface for the SortedTroves Doubly Linked List.
716 interface ISortedTroves {
717 
718     // --- Events ---
719     
720     event SortedTrovesAddressChanged(address _sortedDoublyLLAddress);
721     event BorrowerOperationsAddressChanged(address _borrowerOperationsAddress);
722     event NodeAdded(address _id, uint _NICR);
723     event NodeRemoved(address _id);
724 
725     // --- Functions ---
726     
727     function setParams(uint256 _size, address _TroveManagerAddress, address _borrowerOperationsAddress) external;
728 
729     function insert(address _id, uint256 _ICR, address _prevId, address _nextId) external;
730 
731     function remove(address _id) external;
732 
733     function reInsert(address _id, uint256 _newICR, address _prevId, address _nextId) external;
734 
735     function contains(address _id) external view returns (bool);
736 
737     function isFull() external view returns (bool);
738 
739     function isEmpty() external view returns (bool);
740 
741     function getSize() external view returns (uint256);
742 
743     function getMaxSize() external view returns (uint256);
744 
745     function getFirst() external view returns (address);
746 
747     function getLast() external view returns (address);
748 
749     function getNext(address _id) external view returns (address);
750 
751     function getPrev(address _id) external view returns (address);
752 
753     function validInsertPosition(uint256 _ICR, address _prevId, address _nextId) external view returns (bool);
754 
755     function findInsertPosition(uint256 _ICR, address _prevId, address _nextId) external view returns (address, address);
756 }
757 
758 
759 // File contracts/Interfaces/ICommunityIssuance.sol
760 
761 
762 
763 pragma solidity 0.6.11;
764 
765 interface ICommunityIssuance { 
766     
767     // --- Events ---
768     
769     event LQTYTokenAddressSet(address _lqtyTokenAddress);
770     event StabilityPoolAddressSet(address _stabilityPoolAddress);
771     event TotalLQTYIssuedUpdated(uint _totalLQTYIssued);
772 
773     // --- Functions ---
774 
775     function setAddresses(address _lqtyTokenAddress, address _stabilityPoolAddress) external;
776 
777     function issueLQTY() external returns (uint);
778 
779     function sendLQTY(address _account, uint _LQTYamount) external;
780 }
781 
782 
783 // File contracts/Dependencies/BaseMath.sol
784 
785 
786 pragma solidity 0.6.11;
787 
788 
789 contract BaseMath {
790     uint constant public DECIMAL_PRECISION = 1e18;
791 }
792 
793 
794 // File contracts/Dependencies/SafeMath.sol
795 
796 
797 
798 pragma solidity 0.6.11;
799 
800 /**
801  * Based on OpenZeppelin's SafeMath:
802  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
803  *
804  * @dev Wrappers over Solidity's arithmetic operations with added overflow
805  * checks.
806  *
807  * Arithmetic operations in Solidity wrap on overflow. This can easily result
808  * in bugs, because programmers usually assume that an overflow raises an
809  * error, which is the standard behavior in high level programming languages.
810  * `SafeMath` restores this intuition by reverting the transaction when an
811  * operation overflows.
812  *
813  * Using this library instead of the unchecked operations eliminates an entire
814  * class of bugs, so it's recommended to use it always.
815  */
816 library SafeMath {
817     /**
818      * @dev Returns the addition of two unsigned integers, reverting on
819      * overflow.
820      *
821      * Counterpart to Solidity's `+` operator.
822      *
823      * Requirements:
824      * - Addition cannot overflow.
825      */
826     function add(uint256 a, uint256 b) internal pure returns (uint256) {
827         uint256 c = a + b;
828         require(c >= a, "SafeMath: addition overflow");
829 
830         return c;
831     }
832 
833     /**
834      * @dev Returns the subtraction of two unsigned integers, reverting on
835      * overflow (when the result is negative).
836      *
837      * Counterpart to Solidity's `-` operator.
838      *
839      * Requirements:
840      * - Subtraction cannot overflow.
841      */
842     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
843         return sub(a, b, "SafeMath: subtraction overflow");
844     }
845 
846     /**
847      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
848      * overflow (when the result is negative).
849      *
850      * Counterpart to Solidity's `-` operator.
851      *
852      * Requirements:
853      * - Subtraction cannot overflow.
854      *
855      * _Available since v2.4.0._
856      */
857     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
858         require(b <= a, errorMessage);
859         uint256 c = a - b;
860 
861         return c;
862     }
863 
864     /**
865      * @dev Returns the multiplication of two unsigned integers, reverting on
866      * overflow.
867      *
868      * Counterpart to Solidity's `*` operator.
869      *
870      * Requirements:
871      * - Multiplication cannot overflow.
872      */
873     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
874         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
875         // benefit is lost if 'b' is also tested.
876         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
877         if (a == 0) {
878             return 0;
879         }
880 
881         uint256 c = a * b;
882         require(c / a == b, "SafeMath: multiplication overflow");
883 
884         return c;
885     }
886 
887     /**
888      * @dev Returns the integer division of two unsigned integers. Reverts on
889      * division by zero. The result is rounded towards zero.
890      *
891      * Counterpart to Solidity's `/` operator. Note: this function uses a
892      * `revert` opcode (which leaves remaining gas untouched) while Solidity
893      * uses an invalid opcode to revert (consuming all remaining gas).
894      *
895      * Requirements:
896      * - The divisor cannot be zero.
897      */
898     function div(uint256 a, uint256 b) internal pure returns (uint256) {
899         return div(a, b, "SafeMath: division by zero");
900     }
901 
902     /**
903      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
904      * division by zero. The result is rounded towards zero.
905      *
906      * Counterpart to Solidity's `/` operator. Note: this function uses a
907      * `revert` opcode (which leaves remaining gas untouched) while Solidity
908      * uses an invalid opcode to revert (consuming all remaining gas).
909      *
910      * Requirements:
911      * - The divisor cannot be zero.
912      *
913      * _Available since v2.4.0._
914      */
915     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
916         // Solidity only automatically asserts when dividing by 0
917         require(b > 0, errorMessage);
918         uint256 c = a / b;
919         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
920 
921         return c;
922     }
923 
924     /**
925      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
926      * Reverts when dividing by zero.
927      *
928      * Counterpart to Solidity's `%` operator. This function uses a `revert`
929      * opcode (which leaves remaining gas untouched) while Solidity uses an
930      * invalid opcode to revert (consuming all remaining gas).
931      *
932      * Requirements:
933      * - The divisor cannot be zero.
934      */
935     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
936         return mod(a, b, "SafeMath: modulo by zero");
937     }
938 
939     /**
940      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
941      * Reverts with custom message when dividing by zero.
942      *
943      * Counterpart to Solidity's `%` operator. This function uses a `revert`
944      * opcode (which leaves remaining gas untouched) while Solidity uses an
945      * invalid opcode to revert (consuming all remaining gas).
946      *
947      * Requirements:
948      * - The divisor cannot be zero.
949      *
950      * _Available since v2.4.0._
951      */
952     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
953         require(b != 0, errorMessage);
954         return a % b;
955     }
956 }
957 
958 
959 // File contracts/Dependencies/console.sol
960 
961 
962 
963 pragma solidity 0.6.11;
964 
965 // Buidler's helper contract for console logging
966 library console {
967 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
968 
969 	function log() internal view {
970 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log()"));
971 		ignored;
972 	}	function logInt(int p0) internal view {
973 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(int)", p0));
974 		ignored;
975 	}
976 
977 	function logUint(uint p0) internal view {
978 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint)", p0));
979 		ignored;
980 	}
981 
982 	function logString(string memory p0) internal view {
983 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string)", p0));
984 		ignored;
985 	}
986 
987 	function logBool(bool p0) internal view {
988 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool)", p0));
989 		ignored;
990 	}
991 
992 	function logAddress(address p0) internal view {
993 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address)", p0));
994 		ignored;
995 	}
996 
997 	function logBytes(bytes memory p0) internal view {
998 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes)", p0));
999 		ignored;
1000 	}
1001 
1002 	function logByte(byte p0) internal view {
1003 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(byte)", p0));
1004 		ignored;
1005 	}
1006 
1007 	function logBytes1(bytes1 p0) internal view {
1008 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes1)", p0));
1009 		ignored;
1010 	}
1011 
1012 	function logBytes2(bytes2 p0) internal view {
1013 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes2)", p0));
1014 		ignored;
1015 	}
1016 
1017 	function logBytes3(bytes3 p0) internal view {
1018 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes3)", p0));
1019 		ignored;
1020 	}
1021 
1022 	function logBytes4(bytes4 p0) internal view {
1023 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes4)", p0));
1024 		ignored;
1025 	}
1026 
1027 	function logBytes5(bytes5 p0) internal view {
1028 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes5)", p0));
1029 		ignored;
1030 	}
1031 
1032 	function logBytes6(bytes6 p0) internal view {
1033 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes6)", p0));
1034 		ignored;
1035 	}
1036 
1037 	function logBytes7(bytes7 p0) internal view {
1038 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes7)", p0));
1039 		ignored;
1040 	}
1041 
1042 	function logBytes8(bytes8 p0) internal view {
1043 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes8)", p0));
1044 		ignored;
1045 	}
1046 
1047 	function logBytes9(bytes9 p0) internal view {
1048 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes9)", p0));
1049 		ignored;
1050 	}
1051 
1052 	function logBytes10(bytes10 p0) internal view {
1053 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes10)", p0));
1054 		ignored;
1055 	}
1056 
1057 	function logBytes11(bytes11 p0) internal view {
1058 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes11)", p0));
1059 		ignored;
1060 	}
1061 
1062 	function logBytes12(bytes12 p0) internal view {
1063 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes12)", p0));
1064 		ignored;
1065 	}
1066 
1067 	function logBytes13(bytes13 p0) internal view {
1068 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes13)", p0));
1069 		ignored;
1070 	}
1071 
1072 	function logBytes14(bytes14 p0) internal view {
1073 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes14)", p0));
1074 		ignored;
1075 	}
1076 
1077 	function logBytes15(bytes15 p0) internal view {
1078 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes15)", p0));
1079 		ignored;
1080 	}
1081 
1082 	function logBytes16(bytes16 p0) internal view {
1083 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes16)", p0));
1084 		ignored;
1085 	}
1086 
1087 	function logBytes17(bytes17 p0) internal view {
1088 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes17)", p0));
1089 		ignored;
1090 	}
1091 
1092 	function logBytes18(bytes18 p0) internal view {
1093 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes18)", p0));
1094 		ignored;
1095 	}
1096 
1097 	function logBytes19(bytes19 p0) internal view {
1098 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes19)", p0));
1099 		ignored;
1100 	}
1101 
1102 	function logBytes20(bytes20 p0) internal view {
1103 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes20)", p0));
1104 		ignored;
1105 	}
1106 
1107 	function logBytes21(bytes21 p0) internal view {
1108 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes21)", p0));
1109 		ignored;
1110 	}
1111 
1112 	function logBytes22(bytes22 p0) internal view {
1113 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes22)", p0));
1114 		ignored;
1115 	}
1116 
1117 	function logBytes23(bytes23 p0) internal view {
1118 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes23)", p0));
1119 		ignored;
1120 	}
1121 
1122 	function logBytes24(bytes24 p0) internal view {
1123 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes24)", p0));
1124 		ignored;
1125 	}
1126 
1127 	function logBytes25(bytes25 p0) internal view {
1128 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes25)", p0));
1129 		ignored;
1130 	}
1131 
1132 	function logBytes26(bytes26 p0) internal view {
1133 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes26)", p0));
1134 		ignored;
1135 	}
1136 
1137 	function logBytes27(bytes27 p0) internal view {
1138 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes27)", p0));
1139 		ignored;
1140 	}
1141 
1142 	function logBytes28(bytes28 p0) internal view {
1143 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes28)", p0));
1144 		ignored;
1145 	}
1146 
1147 	function logBytes29(bytes29 p0) internal view {
1148 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes29)", p0));
1149 		ignored;
1150 	}
1151 
1152 	function logBytes30(bytes30 p0) internal view {
1153 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes30)", p0));
1154 		ignored;
1155 	}
1156 
1157 	function logBytes31(bytes31 p0) internal view {
1158 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes31)", p0));
1159 		ignored;
1160 	}
1161 
1162 	function logBytes32(bytes32 p0) internal view {
1163 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bytes32)", p0));
1164 		ignored;
1165 	}
1166 
1167 	function log(uint p0) internal view {
1168 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint)", p0));
1169 		ignored;
1170 	}
1171 
1172 	function log(string memory p0) internal view {
1173 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string)", p0));
1174 		ignored;
1175 	}
1176 
1177 	function log(bool p0) internal view {
1178 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool)", p0));
1179 		ignored;
1180 	}
1181 
1182 	function log(address p0) internal view {
1183 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address)", p0));
1184 		ignored;
1185 	}
1186 
1187 	function log(uint p0, uint p1) internal view {
1188 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1189 		ignored;
1190 	}
1191 
1192 	function log(uint p0, string memory p1) internal view {
1193 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string)", p0, p1));
1194 		ignored;
1195 	}
1196 
1197 	function log(uint p0, bool p1) internal view {
1198 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1199 		ignored;
1200 	}
1201 
1202 	function log(uint p0, address p1) internal view {
1203 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address)", p0, p1));
1204 		ignored;
1205 	}
1206 
1207 	function log(string memory p0, uint p1) internal view {
1208 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint)", p0, p1));
1209 		ignored;
1210 	}
1211 
1212 	function log(string memory p0, string memory p1) internal view {
1213 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string)", p0, p1));
1214 		ignored;
1215 	}
1216 
1217 	function log(string memory p0, bool p1) internal view {
1218 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool)", p0, p1));
1219 		ignored;
1220 	}
1221 
1222 	function log(string memory p0, address p1) internal view {
1223 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address)", p0, p1));
1224 		ignored;
1225 	}
1226 
1227 	function log(bool p0, uint p1) internal view {
1228 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1229 		ignored;
1230 	}
1231 
1232 	function log(bool p0, string memory p1) internal view {
1233 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string)", p0, p1));
1234 		ignored;
1235 	}
1236 
1237 	function log(bool p0, bool p1) internal view {
1238 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1239 		ignored;
1240 	}
1241 
1242 	function log(bool p0, address p1) internal view {
1243 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address)", p0, p1));
1244 		ignored;
1245 	}
1246 
1247 	function log(address p0, uint p1) internal view {
1248 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint)", p0, p1));
1249 		ignored;
1250 	}
1251 
1252 	function log(address p0, string memory p1) internal view {
1253 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string)", p0, p1));
1254 		ignored;
1255 	}
1256 
1257 	function log(address p0, bool p1) internal view {
1258 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool)", p0, p1));
1259 		ignored;
1260 	}
1261 
1262 	function log(address p0, address p1) internal view {
1263 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address)", p0, p1));
1264 		ignored;
1265 	}
1266 
1267 	function log(uint p0, uint p1, uint p2) internal view {
1268 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1269 		ignored;
1270 	}
1271 
1272 	function log(uint p0, uint p1, string memory p2) internal view {
1273 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1274 		ignored;
1275 	}
1276 
1277 	function log(uint p0, uint p1, bool p2) internal view {
1278 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1279 		ignored;
1280 	}
1281 
1282 	function log(uint p0, uint p1, address p2) internal view {
1283 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1284 		ignored;
1285 	}
1286 
1287 	function log(uint p0, string memory p1, uint p2) internal view {
1288 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1289 		ignored;
1290 	}
1291 
1292 	function log(uint p0, string memory p1, string memory p2) internal view {
1293 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1294 		ignored;
1295 	}
1296 
1297 	function log(uint p0, string memory p1, bool p2) internal view {
1298 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1299 		ignored;
1300 	}
1301 
1302 	function log(uint p0, string memory p1, address p2) internal view {
1303 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1304 		ignored;
1305 	}
1306 
1307 	function log(uint p0, bool p1, uint p2) internal view {
1308 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1309 		ignored;
1310 	}
1311 
1312 	function log(uint p0, bool p1, string memory p2) internal view {
1313 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1314 		ignored;
1315 	}
1316 
1317 	function log(uint p0, bool p1, bool p2) internal view {
1318 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1319 		ignored;
1320 	}
1321 
1322 	function log(uint p0, bool p1, address p2) internal view {
1323 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1324 		ignored;
1325 	}
1326 
1327 	function log(uint p0, address p1, uint p2) internal view {
1328 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1329 		ignored;
1330 	}
1331 
1332 	function log(uint p0, address p1, string memory p2) internal view {
1333 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1334 		ignored;
1335 	}
1336 
1337 	function log(uint p0, address p1, bool p2) internal view {
1338 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1339 		ignored;
1340 	}
1341 
1342 	function log(uint p0, address p1, address p2) internal view {
1343 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1344 		ignored;
1345 	}
1346 
1347 	function log(string memory p0, uint p1, uint p2) internal view {
1348 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1349 		ignored;
1350 	}
1351 
1352 	function log(string memory p0, uint p1, string memory p2) internal view {
1353 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1354 		ignored;
1355 	}
1356 
1357 	function log(string memory p0, uint p1, bool p2) internal view {
1358 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1359 		ignored;
1360 	}
1361 
1362 	function log(string memory p0, uint p1, address p2) internal view {
1363 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1364 		ignored;
1365 	}
1366 
1367 	function log(string memory p0, string memory p1, uint p2) internal view {
1368 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1369 		ignored;
1370 	}
1371 
1372 	function log(string memory p0, string memory p1, string memory p2) internal view {
1373 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1374 		ignored;
1375 	}
1376 
1377 	function log(string memory p0, string memory p1, bool p2) internal view {
1378 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1379 		ignored;
1380 	}
1381 
1382 	function log(string memory p0, string memory p1, address p2) internal view {
1383 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1384 		ignored;
1385 	}
1386 
1387 	function log(string memory p0, bool p1, uint p2) internal view {
1388 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1389 		ignored;
1390 	}
1391 
1392 	function log(string memory p0, bool p1, string memory p2) internal view {
1393 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1394 		ignored;
1395 	}
1396 
1397 	function log(string memory p0, bool p1, bool p2) internal view {
1398 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1399 		ignored;
1400 	}
1401 
1402 	function log(string memory p0, bool p1, address p2) internal view {
1403 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1404 		ignored;
1405 	}
1406 
1407 	function log(string memory p0, address p1, uint p2) internal view {
1408 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1409 		ignored;
1410 	}
1411 
1412 	function log(string memory p0, address p1, string memory p2) internal view {
1413 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1414 		ignored;
1415 	}
1416 
1417 	function log(string memory p0, address p1, bool p2) internal view {
1418 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1419 		ignored;
1420 	}
1421 
1422 	function log(string memory p0, address p1, address p2) internal view {
1423 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1424 		ignored;
1425 	}
1426 
1427 	function log(bool p0, uint p1, uint p2) internal view {
1428 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1429 		ignored;
1430 	}
1431 
1432 	function log(bool p0, uint p1, string memory p2) internal view {
1433 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1434 		ignored;
1435 	}
1436 
1437 	function log(bool p0, uint p1, bool p2) internal view {
1438 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1439 		ignored;
1440 	}
1441 
1442 	function log(bool p0, uint p1, address p2) internal view {
1443 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1444 		ignored;
1445 	}
1446 
1447 	function log(bool p0, string memory p1, uint p2) internal view {
1448 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1449 		ignored;
1450 	}
1451 
1452 	function log(bool p0, string memory p1, string memory p2) internal view {
1453 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1454 		ignored;
1455 	}
1456 
1457 	function log(bool p0, string memory p1, bool p2) internal view {
1458 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1459 		ignored;
1460 	}
1461 
1462 	function log(bool p0, string memory p1, address p2) internal view {
1463 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1464 		ignored;
1465 	}
1466 
1467 	function log(bool p0, bool p1, uint p2) internal view {
1468 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1469 		ignored;
1470 	}
1471 
1472 	function log(bool p0, bool p1, string memory p2) internal view {
1473 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1474 		ignored;
1475 	}
1476 
1477 	function log(bool p0, bool p1, bool p2) internal view {
1478 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1479 		ignored;
1480 	}
1481 
1482 	function log(bool p0, bool p1, address p2) internal view {
1483 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1484 		ignored;
1485 	}
1486 
1487 	function log(bool p0, address p1, uint p2) internal view {
1488 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1489 		ignored;
1490 	}
1491 
1492 	function log(bool p0, address p1, string memory p2) internal view {
1493 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1494 		ignored;
1495 	}
1496 
1497 	function log(bool p0, address p1, bool p2) internal view {
1498 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1499 		ignored;
1500 	}
1501 
1502 	function log(bool p0, address p1, address p2) internal view {
1503 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1504 		ignored;
1505 	}
1506 
1507 	function log(address p0, uint p1, uint p2) internal view {
1508 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1509 		ignored;
1510 	}
1511 
1512 	function log(address p0, uint p1, string memory p2) internal view {
1513 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1514 		ignored;
1515 	}
1516 
1517 	function log(address p0, uint p1, bool p2) internal view {
1518 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1519 		ignored;
1520 	}
1521 
1522 	function log(address p0, uint p1, address p2) internal view {
1523 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1524 		ignored;
1525 	}
1526 
1527 	function log(address p0, string memory p1, uint p2) internal view {
1528 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1529 		ignored;
1530 	}
1531 
1532 	function log(address p0, string memory p1, string memory p2) internal view {
1533 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1534 		ignored;
1535 	}
1536 
1537 	function log(address p0, string memory p1, bool p2) internal view {
1538 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1539 		ignored;
1540 	}
1541 
1542 	function log(address p0, string memory p1, address p2) internal view {
1543 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1544 		ignored;
1545 	}
1546 
1547 	function log(address p0, bool p1, uint p2) internal view {
1548 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1549 		ignored;
1550 	}
1551 
1552 	function log(address p0, bool p1, string memory p2) internal view {
1553 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1554 		ignored;
1555 	}
1556 
1557 	function log(address p0, bool p1, bool p2) internal view {
1558 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1559 		ignored;
1560 	}
1561 
1562 	function log(address p0, bool p1, address p2) internal view {
1563 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1564 		ignored;
1565 	}
1566 
1567 	function log(address p0, address p1, uint p2) internal view {
1568 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1569 		ignored;
1570 	}
1571 
1572 	function log(address p0, address p1, string memory p2) internal view {
1573 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1574 		ignored;
1575 	}
1576 
1577 	function log(address p0, address p1, bool p2) internal view {
1578 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1579 		ignored;
1580 	}
1581 
1582 	function log(address p0, address p1, address p2) internal view {
1583 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1584 		ignored;
1585 	}
1586 
1587 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1588 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1589 		ignored;
1590 	}
1591 
1592 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1593 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1594 		ignored;
1595 	}
1596 
1597 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1598 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1599 		ignored;
1600 	}
1601 
1602 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1603 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1604 		ignored;
1605 	}
1606 
1607 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1608 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1609 		ignored;
1610 	}
1611 
1612 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1613 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1614 		ignored;
1615 	}
1616 
1617 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1618 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1619 		ignored;
1620 	}
1621 
1622 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1623 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1624 		ignored;
1625 	}
1626 
1627 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1628 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1629 		ignored;
1630 	}
1631 
1632 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1633 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1634 		ignored;
1635 	}
1636 
1637 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1638 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1639 		ignored;
1640 	}
1641 
1642 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1643 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1644 		ignored;
1645 	}
1646 
1647 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1648 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1649 		ignored;
1650 	}
1651 
1652 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1653 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1654 		ignored;
1655 	}
1656 
1657 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1658 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1659 		ignored;
1660 	}
1661 
1662 	function log(uint p0, uint p1, address p2, address p3) internal view {
1663 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1664 		ignored;
1665 	}
1666 
1667 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1668 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1669 		ignored;
1670 	}
1671 
1672 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1673 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1674 		ignored;
1675 	}
1676 
1677 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1678 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1679 		ignored;
1680 	}
1681 
1682 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1683 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1684 		ignored;
1685 	}
1686 
1687 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1688 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1689 		ignored;
1690 	}
1691 
1692 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1693 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1694 		ignored;
1695 	}
1696 
1697 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1698 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1699 		ignored;
1700 	}
1701 
1702 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1703 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1704 		ignored;
1705 	}
1706 
1707 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1708 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1709 		ignored;
1710 	}
1711 
1712 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1713 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1714 		ignored;
1715 	}
1716 
1717 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1718 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1719 		ignored;
1720 	}
1721 
1722 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1723 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1724 		ignored;
1725 	}
1726 
1727 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1728 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1729 		ignored;
1730 	}
1731 
1732 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1733 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1734 		ignored;
1735 	}
1736 
1737 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1738 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1739 		ignored;
1740 	}
1741 
1742 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1743 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1744 		ignored;
1745 	}
1746 
1747 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1748 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1749 		ignored;
1750 	}
1751 
1752 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1753 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1754 		ignored;
1755 	}
1756 
1757 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1758 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1759 		ignored;
1760 	}
1761 
1762 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1763 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1764 		ignored;
1765 	}
1766 
1767 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1768 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1769 		ignored;
1770 	}
1771 
1772 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1773 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1774 		ignored;
1775 	}
1776 
1777 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1778 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1779 		ignored;
1780 	}
1781 
1782 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1783 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1784 		ignored;
1785 	}
1786 
1787 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1788 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1789 		ignored;
1790 	}
1791 
1792 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1793 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1794 		ignored;
1795 	}
1796 
1797 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1798 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1799 		ignored;
1800 	}
1801 
1802 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1803 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1804 		ignored;
1805 	}
1806 
1807 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1808 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1809 		ignored;
1810 	}
1811 
1812 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1813 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1814 		ignored;
1815 	}
1816 
1817 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1818 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1819 		ignored;
1820 	}
1821 
1822 	function log(uint p0, bool p1, address p2, address p3) internal view {
1823 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1824 		ignored;
1825 	}
1826 
1827 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1828 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1829 		ignored;
1830 	}
1831 
1832 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1833 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1834 		ignored;
1835 	}
1836 
1837 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1838 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1839 		ignored;
1840 	}
1841 
1842 	function log(uint p0, address p1, uint p2, address p3) internal view {
1843 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1844 		ignored;
1845 	}
1846 
1847 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1848 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1849 		ignored;
1850 	}
1851 
1852 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1853 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1854 		ignored;
1855 	}
1856 
1857 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1858 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1859 		ignored;
1860 	}
1861 
1862 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1863 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1864 		ignored;
1865 	}
1866 
1867 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1868 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1869 		ignored;
1870 	}
1871 
1872 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1873 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1874 		ignored;
1875 	}
1876 
1877 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1878 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1879 		ignored;
1880 	}
1881 
1882 	function log(uint p0, address p1, bool p2, address p3) internal view {
1883 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1884 		ignored;
1885 	}
1886 
1887 	function log(uint p0, address p1, address p2, uint p3) internal view {
1888 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1889 		ignored;
1890 	}
1891 
1892 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1893 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1894 		ignored;
1895 	}
1896 
1897 	function log(uint p0, address p1, address p2, bool p3) internal view {
1898 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1899 		ignored;
1900 	}
1901 
1902 	function log(uint p0, address p1, address p2, address p3) internal view {
1903 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1904 		ignored;
1905 	}
1906 
1907 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1908 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1909 		ignored;
1910 	}
1911 
1912 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1913 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1914 		ignored;
1915 	}
1916 
1917 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1918 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1919 		ignored;
1920 	}
1921 
1922 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1923 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1924 		ignored;
1925 	}
1926 
1927 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1928 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1929 		ignored;
1930 	}
1931 
1932 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1933 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1934 		ignored;
1935 	}
1936 
1937 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1938 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1939 		ignored;
1940 	}
1941 
1942 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1943 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1944 		ignored;
1945 	}
1946 
1947 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1948 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1949 		ignored;
1950 	}
1951 
1952 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1953 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1954 		ignored;
1955 	}
1956 
1957 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1958 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1959 		ignored;
1960 	}
1961 
1962 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1963 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1964 		ignored;
1965 	}
1966 
1967 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1968 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1969 		ignored;
1970 	}
1971 
1972 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1973 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1974 		ignored;
1975 	}
1976 
1977 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1978 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1979 		ignored;
1980 	}
1981 
1982 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1983 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1984 		ignored;
1985 	}
1986 
1987 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1988 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1989 		ignored;
1990 	}
1991 
1992 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1993 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1994 		ignored;
1995 	}
1996 
1997 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1998 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1999 		ignored;
2000 	}
2001 
2002 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2003 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2004 		ignored;
2005 	}
2006 
2007 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2008 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2009 		ignored;
2010 	}
2011 
2012 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2013 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2014 		ignored;
2015 	}
2016 
2017 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2018 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2019 		ignored;
2020 	}
2021 
2022 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2023 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2024 		ignored;
2025 	}
2026 
2027 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2028 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2029 		ignored;
2030 	}
2031 
2032 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2033 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2034 		ignored;
2035 	}
2036 
2037 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2038 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2039 		ignored;
2040 	}
2041 
2042 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2043 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2044 		ignored;
2045 	}
2046 
2047 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2048 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2049 		ignored;
2050 	}
2051 
2052 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2053 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2054 		ignored;
2055 	}
2056 
2057 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2058 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2059 		ignored;
2060 	}
2061 
2062 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2063 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2064 		ignored;
2065 	}
2066 
2067 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2068 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2069 		ignored;
2070 	}
2071 
2072 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2073 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2074 		ignored;
2075 	}
2076 
2077 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2078 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2079 		ignored;
2080 	}
2081 
2082 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2083 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2084 		ignored;
2085 	}
2086 
2087 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2088 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2089 		ignored;
2090 	}
2091 
2092 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2093 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2094 		ignored;
2095 	}
2096 
2097 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2098 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2099 		ignored;
2100 	}
2101 
2102 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2103 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2104 		ignored;
2105 	}
2106 
2107 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2108 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2109 		ignored;
2110 	}
2111 
2112 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2113 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2114 		ignored;
2115 	}
2116 
2117 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2118 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2119 		ignored;
2120 	}
2121 
2122 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2123 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2124 		ignored;
2125 	}
2126 
2127 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2128 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2129 		ignored;
2130 	}
2131 
2132 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2133 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2134 		ignored;
2135 	}
2136 
2137 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2138 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2139 		ignored;
2140 	}
2141 
2142 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2143 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2144 		ignored;
2145 	}
2146 
2147 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2148 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2149 		ignored;
2150 	}
2151 
2152 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2153 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2154 		ignored;
2155 	}
2156 
2157 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2158 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2159 		ignored;
2160 	}
2161 
2162 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2163 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2164 		ignored;
2165 	}
2166 
2167 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2168 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2169 		ignored;
2170 	}
2171 
2172 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2173 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2174 		ignored;
2175 	}
2176 
2177 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2178 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2179 		ignored;
2180 	}
2181 
2182 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2183 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2184 		ignored;
2185 	}
2186 
2187 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2188 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2189 		ignored;
2190 	}
2191 
2192 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2193 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2194 		ignored;
2195 	}
2196 
2197 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2198 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2199 		ignored;
2200 	}
2201 
2202 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2203 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2204 		ignored;
2205 	}
2206 
2207 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2208 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2209 		ignored;
2210 	}
2211 
2212 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2213 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2214 		ignored;
2215 	}
2216 
2217 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2218 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2219 		ignored;
2220 	}
2221 
2222 	function log(string memory p0, address p1, address p2, address p3) internal view {
2223 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2224 		ignored;
2225 	}
2226 
2227 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2228 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2229 		ignored;
2230 	}
2231 
2232 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2233 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2234 		ignored;
2235 	}
2236 
2237 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2238 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2239 		ignored;
2240 	}
2241 
2242 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2243 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2244 		ignored;
2245 	}
2246 
2247 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2248 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2249 		ignored;
2250 	}
2251 
2252 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2253 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2254 		ignored;
2255 	}
2256 
2257 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2258 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2259 		ignored;
2260 	}
2261 
2262 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2263 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2264 		ignored;
2265 	}
2266 
2267 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2268 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2269 		ignored;
2270 	}
2271 
2272 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2273 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2274 		ignored;
2275 	}
2276 
2277 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2278 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2279 		ignored;
2280 	}
2281 
2282 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2283 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2284 		ignored;
2285 	}
2286 
2287 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2288 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2289 		ignored;
2290 	}
2291 
2292 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2293 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2294 		ignored;
2295 	}
2296 
2297 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2298 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2299 		ignored;
2300 	}
2301 
2302 	function log(bool p0, uint p1, address p2, address p3) internal view {
2303 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2304 		ignored;
2305 	}
2306 
2307 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2308 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2309 		ignored;
2310 	}
2311 
2312 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2313 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2314 		ignored;
2315 	}
2316 
2317 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2318 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2319 		ignored;
2320 	}
2321 
2322 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2323 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2324 		ignored;
2325 	}
2326 
2327 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2328 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2329 		ignored;
2330 	}
2331 
2332 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2333 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2334 		ignored;
2335 	}
2336 
2337 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2338 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2339 		ignored;
2340 	}
2341 
2342 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2343 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2344 		ignored;
2345 	}
2346 
2347 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2348 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2349 		ignored;
2350 	}
2351 
2352 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2353 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2354 		ignored;
2355 	}
2356 
2357 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2358 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2359 		ignored;
2360 	}
2361 
2362 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2363 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2364 		ignored;
2365 	}
2366 
2367 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2368 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2369 		ignored;
2370 	}
2371 
2372 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2373 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2374 		ignored;
2375 	}
2376 
2377 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2378 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2379 		ignored;
2380 	}
2381 
2382 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2383 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2384 		ignored;
2385 	}
2386 
2387 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2388 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2389 		ignored;
2390 	}
2391 
2392 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2393 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2394 		ignored;
2395 	}
2396 
2397 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2398 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2399 		ignored;
2400 	}
2401 
2402 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2403 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2404 		ignored;
2405 	}
2406 
2407 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2408 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2409 		ignored;
2410 	}
2411 
2412 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2413 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2414 		ignored;
2415 	}
2416 
2417 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2418 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2419 		ignored;
2420 	}
2421 
2422 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2423 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2424 		ignored;
2425 	}
2426 
2427 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2428 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2429 		ignored;
2430 	}
2431 
2432 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2433 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2434 		ignored;
2435 	}
2436 
2437 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2438 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2439 		ignored;
2440 	}
2441 
2442 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2443 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2444 		ignored;
2445 	}
2446 
2447 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2448 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2449 		ignored;
2450 	}
2451 
2452 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2453 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2454 		ignored;
2455 	}
2456 
2457 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2458 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2459 		ignored;
2460 	}
2461 
2462 	function log(bool p0, bool p1, address p2, address p3) internal view {
2463 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2464 		ignored;
2465 	}
2466 
2467 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2468 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2469 		ignored;
2470 	}
2471 
2472 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2473 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2474 		ignored;
2475 	}
2476 
2477 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2478 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2479 		ignored;
2480 	}
2481 
2482 	function log(bool p0, address p1, uint p2, address p3) internal view {
2483 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2484 		ignored;
2485 	}
2486 
2487 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2488 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2489 		ignored;
2490 	}
2491 
2492 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2493 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2494 		ignored;
2495 	}
2496 
2497 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2498 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2499 		ignored;
2500 	}
2501 
2502 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2503 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2504 		ignored;
2505 	}
2506 
2507 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2508 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2509 		ignored;
2510 	}
2511 
2512 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2513 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2514 		ignored;
2515 	}
2516 
2517 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2518 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2519 		ignored;
2520 	}
2521 
2522 	function log(bool p0, address p1, bool p2, address p3) internal view {
2523 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2524 		ignored;
2525 	}
2526 
2527 	function log(bool p0, address p1, address p2, uint p3) internal view {
2528 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2529 		ignored;
2530 	}
2531 
2532 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2533 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2534 		ignored;
2535 	}
2536 
2537 	function log(bool p0, address p1, address p2, bool p3) internal view {
2538 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2539 		ignored;
2540 	}
2541 
2542 	function log(bool p0, address p1, address p2, address p3) internal view {
2543 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2544 		ignored;
2545 	}
2546 
2547 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2548 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2549 		ignored;
2550 	}
2551 
2552 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2553 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2554 		ignored;
2555 	}
2556 
2557 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2558 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2559 		ignored;
2560 	}
2561 
2562 	function log(address p0, uint p1, uint p2, address p3) internal view {
2563 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2564 		ignored;
2565 	}
2566 
2567 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2568 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2569 		ignored;
2570 	}
2571 
2572 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2573 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2574 		ignored;
2575 	}
2576 
2577 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2578 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2579 		ignored;
2580 	}
2581 
2582 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2583 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2584 		ignored;
2585 	}
2586 
2587 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2588 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2589 		ignored;
2590 	}
2591 
2592 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2593 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2594 		ignored;
2595 	}
2596 
2597 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2598 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2599 		ignored;
2600 	}
2601 
2602 	function log(address p0, uint p1, bool p2, address p3) internal view {
2603 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2604 		ignored;
2605 	}
2606 
2607 	function log(address p0, uint p1, address p2, uint p3) internal view {
2608 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2609 		ignored;
2610 	}
2611 
2612 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2613 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2614 		ignored;
2615 	}
2616 
2617 	function log(address p0, uint p1, address p2, bool p3) internal view {
2618 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2619 		ignored;
2620 	}
2621 
2622 	function log(address p0, uint p1, address p2, address p3) internal view {
2623 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2624 		ignored;
2625 	}
2626 
2627 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2628 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2629 		ignored;
2630 	}
2631 
2632 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2633 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2634 		ignored;
2635 	}
2636 
2637 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2638 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2639 		ignored;
2640 	}
2641 
2642 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2643 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2644 		ignored;
2645 	}
2646 
2647 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2648 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2649 		ignored;
2650 	}
2651 
2652 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2653 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2654 		ignored;
2655 	}
2656 
2657 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2658 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2659 		ignored;
2660 	}
2661 
2662 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2663 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2664 		ignored;
2665 	}
2666 
2667 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2668 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2669 		ignored;
2670 	}
2671 
2672 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2673 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2674 		ignored;
2675 	}
2676 
2677 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2678 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2679 		ignored;
2680 	}
2681 
2682 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2683 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2684 		ignored;
2685 	}
2686 
2687 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2688 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2689 		ignored;
2690 	}
2691 
2692 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2693 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2694 		ignored;
2695 	}
2696 
2697 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2698 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2699 		ignored;
2700 	}
2701 
2702 	function log(address p0, string memory p1, address p2, address p3) internal view {
2703 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2704 		ignored;
2705 	}
2706 
2707 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2708 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2709 		ignored;
2710 	}
2711 
2712 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2713 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2714 		ignored;
2715 	}
2716 
2717 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2718 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2719 		ignored;
2720 	}
2721 
2722 	function log(address p0, bool p1, uint p2, address p3) internal view {
2723 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2724 		ignored;
2725 	}
2726 
2727 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2728 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2729 		ignored;
2730 	}
2731 
2732 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2733 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2734 		ignored;
2735 	}
2736 
2737 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2738 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2739 		ignored;
2740 	}
2741 
2742 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2743 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2744 		ignored;
2745 	}
2746 
2747 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2748 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2749 		ignored;
2750 	}
2751 
2752 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2753 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2754 		ignored;
2755 	}
2756 
2757 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2758 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2759 		ignored;
2760 	}
2761 
2762 	function log(address p0, bool p1, bool p2, address p3) internal view {
2763 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2764 		ignored;
2765 	}
2766 
2767 	function log(address p0, bool p1, address p2, uint p3) internal view {
2768 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2769 		ignored;
2770 	}
2771 
2772 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2773 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2774 		ignored;
2775 	}
2776 
2777 	function log(address p0, bool p1, address p2, bool p3) internal view {
2778 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2779 		ignored;
2780 	}
2781 
2782 	function log(address p0, bool p1, address p2, address p3) internal view {
2783 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2784 		ignored;
2785 	}
2786 
2787 	function log(address p0, address p1, uint p2, uint p3) internal view {
2788 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2789 		ignored;
2790 	}
2791 
2792 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2793 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2794 		ignored;
2795 	}
2796 
2797 	function log(address p0, address p1, uint p2, bool p3) internal view {
2798 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2799 		ignored;
2800 	}
2801 
2802 	function log(address p0, address p1, uint p2, address p3) internal view {
2803 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2804 		ignored;
2805 	}
2806 
2807 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2808 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2809 		ignored;
2810 	}
2811 
2812 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2813 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2814 		ignored;
2815 	}
2816 
2817 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2818 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2819 		ignored;
2820 	}
2821 
2822 	function log(address p0, address p1, string memory p2, address p3) internal view {
2823 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2824 		ignored;
2825 	}
2826 
2827 	function log(address p0, address p1, bool p2, uint p3) internal view {
2828 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2829 		ignored;
2830 	}
2831 
2832 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2833 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2834 		ignored;
2835 	}
2836 
2837 	function log(address p0, address p1, bool p2, bool p3) internal view {
2838 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2839 		ignored;
2840 	}
2841 
2842 	function log(address p0, address p1, bool p2, address p3) internal view {
2843 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2844 		ignored;
2845 	}
2846 
2847 	function log(address p0, address p1, address p2, uint p3) internal view {
2848 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2849 		ignored;
2850 	}
2851 
2852 	function log(address p0, address p1, address p2, string memory p3) internal view {
2853 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2854 		ignored;
2855 	}
2856 
2857 	function log(address p0, address p1, address p2, bool p3) internal view {
2858 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2859 		ignored;
2860 	}
2861 
2862 	function log(address p0, address p1, address p2, address p3) internal view {
2863 		(bool ignored, ) = CONSOLE_ADDRESS.staticcall(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2864 		ignored;
2865 	}
2866 
2867 }
2868 
2869 
2870 // File contracts/Dependencies/LiquityMath.sol
2871 
2872 
2873 
2874 pragma solidity 0.6.11;
2875 
2876 
2877 library LiquityMath {
2878     using SafeMath for uint;
2879 
2880     uint internal constant DECIMAL_PRECISION = 1e18;
2881 
2882     /* Precision for Nominal ICR (independent of price). Rationale for the value:
2883      *
2884      * - Making it “too high” could lead to overflows.
2885      * - Making it “too low” could lead to an ICR equal to zero, due to truncation from Solidity floor division. 
2886      *
2887      * This value of 1e20 is chosen for safety: the NICR will only overflow for numerator > ~1e39 ETH,
2888      * and will only truncate to 0 if the denominator is at least 1e20 times greater than the numerator.
2889      *
2890      */
2891     uint internal constant NICR_PRECISION = 1e20;
2892 
2893     function _min(uint _a, uint _b) internal pure returns (uint) {
2894         return (_a < _b) ? _a : _b;
2895     }
2896 
2897     function _max(uint _a, uint _b) internal pure returns (uint) {
2898         return (_a >= _b) ? _a : _b;
2899     }
2900 
2901     /* 
2902     * Multiply two decimal numbers and use normal rounding rules:
2903     * -round product up if 19'th mantissa digit >= 5
2904     * -round product down if 19'th mantissa digit < 5
2905     *
2906     * Used only inside the exponentiation, _decPow().
2907     */
2908     function decMul(uint x, uint y) internal pure returns (uint decProd) {
2909         uint prod_xy = x.mul(y);
2910 
2911         decProd = prod_xy.add(DECIMAL_PRECISION / 2).div(DECIMAL_PRECISION);
2912     }
2913 
2914     /* 
2915     * _decPow: Exponentiation function for 18-digit decimal base, and integer exponent n.
2916     * 
2917     * Uses the efficient "exponentiation by squaring" algorithm. O(log(n)) complexity. 
2918     * 
2919     * Called by two functions that represent time in units of minutes:
2920     * 1) TroveManager._calcDecayedBaseRate
2921     * 2) CommunityIssuance._getCumulativeIssuanceFraction 
2922     * 
2923     * The exponent is capped to avoid reverting due to overflow. The cap 525600000 equals
2924     * "minutes in 1000 years": 60 * 24 * 365 * 1000
2925     * 
2926     * If a period of > 1000 years is ever used as an exponent in either of the above functions, the result will be
2927     * negligibly different from just passing the cap, since: 
2928     *
2929     * In function 1), the decayed base rate will be 0 for 1000 years or > 1000 years
2930     * In function 2), the difference in tokens issued at 1000 years and any time > 1000 years, will be negligible
2931     */
2932     function _decPow(uint _base, uint _minutes) internal pure returns (uint) {
2933        
2934         if (_minutes > 525600000) {_minutes = 525600000;}  // cap to avoid overflow
2935     
2936         if (_minutes == 0) {return DECIMAL_PRECISION;}
2937 
2938         uint y = DECIMAL_PRECISION;
2939         uint x = _base;
2940         uint n = _minutes;
2941 
2942         // Exponentiation-by-squaring
2943         while (n > 1) {
2944             if (n % 2 == 0) {
2945                 x = decMul(x, x);
2946                 n = n.div(2);
2947             } else { // if (n % 2 != 0)
2948                 y = decMul(x, y);
2949                 x = decMul(x, x);
2950                 n = (n.sub(1)).div(2);
2951             }
2952         }
2953 
2954         return decMul(x, y);
2955   }
2956 
2957     function _getAbsoluteDifference(uint _a, uint _b) internal pure returns (uint) {
2958         return (_a >= _b) ? _a.sub(_b) : _b.sub(_a);
2959     }
2960 
2961     function _computeNominalCR(uint _coll, uint _debt) internal pure returns (uint) {
2962         if (_debt > 0) {
2963             return _coll.mul(NICR_PRECISION).div(_debt);
2964         }
2965         // Return the maximal value for uint256 if the Trove has a debt of 0. Represents "infinite" CR.
2966         else { // if (_debt == 0)
2967             return 2**256 - 1;
2968         }
2969     }
2970 
2971     function _computeCR(uint _coll, uint _debt, uint _price) internal pure returns (uint) {
2972         if (_debt > 0) {
2973             uint newCollRatio = _coll.mul(_price).div(_debt);
2974 
2975             return newCollRatio;
2976         }
2977         // Return the maximal value for uint256 if the Trove has a debt of 0. Represents "infinite" CR.
2978         else { // if (_debt == 0)
2979             return 2**256 - 1; 
2980         }
2981     }
2982 }
2983 
2984 
2985 // File contracts/Interfaces/IPool.sol
2986 
2987 
2988 
2989 pragma solidity 0.6.11;
2990 
2991 // Common interface for the Pools.
2992 interface IPool {
2993     
2994     // --- Events ---
2995     
2996     event ETHBalanceUpdated(uint _newBalance);
2997     event LUSDBalanceUpdated(uint _newBalance);
2998     event ActivePoolAddressChanged(address _newActivePoolAddress);
2999     event DefaultPoolAddressChanged(address _newDefaultPoolAddress);
3000     event StabilityPoolAddressChanged(address _newStabilityPoolAddress);
3001     event EtherSent(address _to, uint _amount);
3002 
3003     // --- Functions ---
3004     
3005     function getETH() external view returns (uint);
3006 
3007     function getLUSDDebt() external view returns (uint);
3008 
3009     function increaseLUSDDebt(uint _amount) external;
3010 
3011     function decreaseLUSDDebt(uint _amount) external;
3012 }
3013 
3014 
3015 // File contracts/Interfaces/IActivePool.sol
3016 
3017 
3018 
3019 pragma solidity 0.6.11;
3020 
3021 interface IActivePool is IPool {
3022     // --- Events ---
3023     event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
3024     event TroveManagerAddressChanged(address _newTroveManagerAddress);
3025     event ActivePoolLUSDDebtUpdated(uint _LUSDDebt);
3026     event ActivePoolETHBalanceUpdated(uint _ETH);
3027 
3028     // --- Functions ---
3029     function sendETH(address _account, uint _amount) external;
3030 }
3031 
3032 
3033 // File contracts/Interfaces/IDefaultPool.sol
3034 
3035 
3036 
3037 pragma solidity 0.6.11;
3038 
3039 interface IDefaultPool is IPool {
3040     // --- Events ---
3041     event TroveManagerAddressChanged(address _newTroveManagerAddress);
3042     event DefaultPoolLUSDDebtUpdated(uint _LUSDDebt);
3043     event DefaultPoolETHBalanceUpdated(uint _ETH);
3044 
3045     // --- Functions ---
3046     function sendETHToActivePool(uint _amount) external;
3047 }
3048 
3049 
3050 // File contracts/Dependencies/LiquityBase.sol
3051 
3052 
3053 
3054 pragma solidity 0.6.11;
3055 
3056 
3057 
3058 
3059 
3060 
3061 /* 
3062 * Base contract for TroveManager, BorrowerOperations and StabilityPool. Contains global system constants and
3063 * common functions. 
3064 */
3065 contract LiquityBase is BaseMath, ILiquityBase {
3066     using SafeMath for uint;
3067 
3068     uint constant public _100pct = 1000000000000000000; // 1e18 == 100%
3069 
3070     // Minimum collateral ratio for individual troves
3071     uint constant public MCR = 1100000000000000000; // 110%
3072 
3073     // Critical system collateral ratio. If the system's total collateral ratio (TCR) falls below the CCR, Recovery Mode is triggered.
3074     uint constant public CCR = 1500000000000000000; // 150%
3075 
3076     // Amount of LUSD to be locked in gas pool on opening troves
3077     uint constant public LUSD_GAS_COMPENSATION = 200e18;
3078 
3079     // Minimum amount of net LUSD debt a trove must have
3080     uint constant public MIN_NET_DEBT = 1800e18;
3081     // uint constant public MIN_NET_DEBT = 0; 
3082 
3083     uint constant public PERCENT_DIVISOR = 200; // dividing by 200 yields 0.5%
3084 
3085     uint constant public BORROWING_FEE_FLOOR = DECIMAL_PRECISION / 1000 * 5; // 0.5%
3086 
3087     IActivePool public activePool;
3088 
3089     IDefaultPool public defaultPool;
3090 
3091     IPriceFeed public override priceFeed;
3092 
3093     // --- Gas compensation functions ---
3094 
3095     // Returns the composite debt (drawn debt + gas compensation) of a trove, for the purpose of ICR calculation
3096     function _getCompositeDebt(uint _debt) internal pure returns (uint) {
3097         return _debt.add(LUSD_GAS_COMPENSATION);
3098     }
3099 
3100     function _getNetDebt(uint _debt) internal pure returns (uint) {
3101         return _debt.sub(LUSD_GAS_COMPENSATION);
3102     }
3103 
3104     // Return the amount of ETH to be drawn from a trove's collateral and sent as gas compensation.
3105     function _getCollGasCompensation(uint _entireColl) internal pure returns (uint) {
3106         return _entireColl / PERCENT_DIVISOR;
3107     }
3108 
3109     function getEntireSystemColl() public view returns (uint entireSystemColl) {
3110         uint activeColl = activePool.getETH();
3111         uint liquidatedColl = defaultPool.getETH();
3112 
3113         return activeColl.add(liquidatedColl);
3114     }
3115 
3116     function getEntireSystemDebt() public view returns (uint entireSystemDebt) {
3117         uint activeDebt = activePool.getLUSDDebt();
3118         uint closedDebt = defaultPool.getLUSDDebt();
3119 
3120         return activeDebt.add(closedDebt);
3121     }
3122 
3123     function _getTCR(uint _price) internal view returns (uint TCR) {
3124         uint entireSystemColl = getEntireSystemColl();
3125         uint entireSystemDebt = getEntireSystemDebt();
3126 
3127         TCR = LiquityMath._computeCR(entireSystemColl, entireSystemDebt, _price);
3128 
3129         return TCR;
3130     }
3131 
3132     function _checkRecoveryMode(uint _price) internal view returns (bool) {
3133         uint TCR = _getTCR(_price);
3134 
3135         return TCR < CCR;
3136     }
3137 
3138     function _requireUserAcceptsFee(uint _fee, uint _amount, uint _maxFeePercentage) internal pure {
3139         uint feePercentage = _fee.mul(DECIMAL_PRECISION).div(_amount);
3140         require(feePercentage <= _maxFeePercentage, "Fee exceeded provided maximum");
3141     }
3142 }
3143 
3144 
3145 // File contracts/Dependencies/LiquitySafeMath128.sol
3146 
3147 
3148 
3149 pragma solidity 0.6.11;
3150 
3151 // uint128 addition and subtraction, with overflow protection.
3152 
3153 library LiquitySafeMath128 {
3154     function add(uint128 a, uint128 b) internal pure returns (uint128) {
3155         uint128 c = a + b;
3156         require(c >= a, "LiquitySafeMath128: addition overflow");
3157 
3158         return c;
3159     }
3160    
3161     function sub(uint128 a, uint128 b) internal pure returns (uint128) {
3162         require(b <= a, "LiquitySafeMath128: subtraction overflow");
3163         uint128 c = a - b;
3164 
3165         return c;
3166     }
3167 }
3168 
3169 
3170 // File contracts/Dependencies/Ownable.sol
3171 
3172 
3173 
3174 pragma solidity 0.6.11;
3175 
3176 /**
3177  * Based on OpenZeppelin's Ownable contract:
3178  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
3179  *
3180  * @dev Contract module which provides a basic access control mechanism, where
3181  * there is an account (an owner) that can be granted exclusive access to
3182  * specific functions.
3183  *
3184  * This module is used through inheritance. It will make available the modifier
3185  * `onlyOwner`, which can be applied to your functions to restrict their use to
3186  * the owner.
3187  */
3188 contract Ownable {
3189     address private _owner;
3190 
3191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3192 
3193     /**
3194      * @dev Initializes the contract setting the deployer as the initial owner.
3195      */
3196     constructor () internal {
3197         _owner = msg.sender;
3198         emit OwnershipTransferred(address(0), msg.sender);
3199     }
3200 
3201     /**
3202      * @dev Returns the address of the current owner.
3203      */
3204     function owner() public view returns (address) {
3205         return _owner;
3206     }
3207 
3208     /**
3209      * @dev Throws if called by any account other than the owner.
3210      */
3211     modifier onlyOwner() {
3212         require(isOwner(), "Ownable: caller is not the owner");
3213         _;
3214     }
3215 
3216     /**
3217      * @dev Returns true if the caller is the current owner.
3218      */
3219     function isOwner() public view returns (bool) {
3220         return msg.sender == _owner;
3221     }
3222 
3223     function transferOwnership(address newOwner) public virtual onlyOwner {
3224         require(newOwner != address(0), "Ownable: new owner is the zero address");
3225         _setOwner(newOwner);
3226     }
3227 
3228     function _setOwner(address newOwner) private {
3229         address oldOwner = _owner;
3230         _owner = newOwner;
3231         emit OwnershipTransferred(oldOwner, newOwner);
3232     }
3233         
3234     /**
3235      * @dev Leaves the contract without owner. It will not be possible to call
3236      * `onlyOwner` functions anymore.
3237      *
3238      * NOTE: Renouncing ownership will leave the contract without an owner,
3239      * thereby removing any functionality that is only available to the owner.
3240      *
3241      * NOTE: This function is not safe, as it doesn’t check owner is calling it.
3242      * Make sure you check it before calling it.
3243      */
3244     function _renounceOwnership() internal {
3245         emit OwnershipTransferred(_owner, address(0));
3246         _owner = address(0);
3247     }
3248 }
3249 
3250 
3251 // File contracts/Dependencies/CheckContract.sol
3252 
3253 
3254 
3255 pragma solidity 0.6.11;
3256 
3257 
3258 contract CheckContract {
3259     /**
3260      * Check that the account is an already deployed non-destroyed contract.
3261      * See: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L12
3262      */
3263     function checkContract(address _account) internal view {
3264         require(_account != address(0), "Account cannot be zero address");
3265 
3266         uint256 size;
3267         // solhint-disable-next-line no-inline-assembly
3268         assembly { size := extcodesize(_account) }
3269         require(size > 0, "Account code size cannot be zero");
3270     }
3271 }
3272 
3273 
3274 // File contracts/StabilityPool.sol
3275 
3276 
3277 
3278 pragma solidity 0.6.11;
3279 
3280 
3281 
3282 
3283 
3284 
3285 
3286 
3287 
3288 
3289 
3290 
3291 
3292 /*
3293  * The Stability Pool holds LUSD tokens deposited by Stability Pool depositors.
3294  *
3295  * When a trove is liquidated, then depending on system conditions, some of its LUSD debt gets offset with
3296  * LUSD in the Stability Pool:  that is, the offset debt evaporates, and an equal amount of LUSD tokens in the Stability Pool is burned.
3297  *
3298  * Thus, a liquidation causes each depositor to receive a LUSD loss, in proportion to their deposit as a share of total deposits.
3299  * They also receive an ETH gain, as the ETH collateral of the liquidated trove is distributed among Stability depositors,
3300  * in the same proportion.
3301  *
3302  * When a liquidation occurs, it depletes every deposit by the same fraction: for example, a liquidation that depletes 40%
3303  * of the total LUSD in the Stability Pool, depletes 40% of each deposit.
3304  *
3305  * A deposit that has experienced a series of liquidations is termed a "compounded deposit": each liquidation depletes the deposit,
3306  * multiplying it by some factor in range ]0,1[
3307  *
3308  *
3309  * --- IMPLEMENTATION ---
3310  *
3311  * We use a highly scalable method of tracking deposits and ETH gains that has O(1) complexity.
3312  *
3313  * When a liquidation occurs, rather than updating each depositor's deposit and ETH gain, we simply update two state variables:
3314  * a product P, and a sum S.
3315  *
3316  * A mathematical manipulation allows us to factor out the initial deposit, and accurately track all depositors' compounded deposits
3317  * and accumulated ETH gains over time, as liquidations occur, using just these two variables P and S. When depositors join the
3318  * Stability Pool, they get a snapshot of the latest P and S: P_t and S_t, respectively.
3319  *
3320  * The formula for a depositor's accumulated ETH gain is derived here:
3321  * https://github.com/liquity/dev/blob/main/packages/contracts/mathProofs/Scalable%20Compounding%20Stability%20Pool%20Deposits.pdf
3322  *
3323  * For a given deposit d_t, the ratio P/P_t tells us the factor by which a deposit has decreased since it joined the Stability Pool,
3324  * and the term d_t * (S - S_t)/P_t gives us the deposit's total accumulated ETH gain.
3325  *
3326  * Each liquidation updates the product P and sum S. After a series of liquidations, a compounded deposit and corresponding ETH gain
3327  * can be calculated using the initial deposit, the depositor’s snapshots of P and S, and the latest values of P and S.
3328  *
3329  * Any time a depositor updates their deposit (withdrawal, top-up) their accumulated ETH gain is paid out, their new deposit is recorded
3330  * (based on their latest compounded deposit and modified by the withdrawal/top-up), and they receive new snapshots of the latest P and S.
3331  * Essentially, they make a fresh deposit that overwrites the old one.
3332  *
3333  *
3334  * --- SCALE FACTOR ---
3335  *
3336  * Since P is a running product in range ]0,1] that is always-decreasing, it should never reach 0 when multiplied by a number in range ]0,1[.
3337  * Unfortunately, Solidity floor division always reaches 0, sooner or later.
3338  *
3339  * A series of liquidations that nearly empty the Pool (and thus each multiply P by a very small number in range ]0,1[ ) may push P
3340  * to its 18 digit decimal limit, and round it to 0, when in fact the Pool hasn't been emptied: this would break deposit tracking.
3341  *
3342  * So, to track P accurately, we use a scale factor: if a liquidation would cause P to decrease to <1e-9 (and be rounded to 0 by Solidity),
3343  * we first multiply P by 1e9, and increment a currentScale factor by 1.
3344  *
3345  * The added benefit of using 1e9 for the scale factor (rather than 1e18) is that it ensures negligible precision loss close to the 
3346  * scale boundary: when P is at its minimum value of 1e9, the relative precision loss in P due to floor division is only on the 
3347  * order of 1e-9. 
3348  *
3349  * --- EPOCHS ---
3350  *
3351  * Whenever a liquidation fully empties the Stability Pool, all deposits should become 0. However, setting P to 0 would make P be 0
3352  * forever, and break all future reward calculations.
3353  *
3354  * So, every time the Stability Pool is emptied by a liquidation, we reset P = 1 and currentScale = 0, and increment the currentEpoch by 1.
3355  *
3356  * --- TRACKING DEPOSIT OVER SCALE CHANGES AND EPOCHS ---
3357  *
3358  * When a deposit is made, it gets snapshots of the currentEpoch and the currentScale.
3359  *
3360  * When calculating a compounded deposit, we compare the current epoch to the deposit's epoch snapshot. If the current epoch is newer,
3361  * then the deposit was present during a pool-emptying liquidation, and necessarily has been depleted to 0.
3362  *
3363  * Otherwise, we then compare the current scale to the deposit's scale snapshot. If they're equal, the compounded deposit is given by d_t * P/P_t.
3364  * If it spans one scale change, it is given by d_t * P/(P_t * 1e9). If it spans more than one scale change, we define the compounded deposit
3365  * as 0, since it is now less than 1e-9'th of its initial value (e.g. a deposit of 1 billion LUSD has depleted to < 1 LUSD).
3366  *
3367  *
3368  *  --- TRACKING DEPOSITOR'S ETH GAIN OVER SCALE CHANGES AND EPOCHS ---
3369  *
3370  * In the current epoch, the latest value of S is stored upon each scale change, and the mapping (scale -> S) is stored for each epoch.
3371  *
3372  * This allows us to calculate a deposit's accumulated ETH gain, during the epoch in which the deposit was non-zero and earned ETH.
3373  *
3374  * We calculate the depositor's accumulated ETH gain for the scale at which they made the deposit, using the ETH gain formula:
3375  * e_1 = d_t * (S - S_t) / P_t
3376  *
3377  * and also for scale after, taking care to divide the latter by a factor of 1e9:
3378  * e_2 = d_t * S / (P_t * 1e9)
3379  *
3380  * The gain in the second scale will be full, as the starting point was in the previous scale, thus no need to subtract anything.
3381  * The deposit therefore was present for reward events from the beginning of that second scale.
3382  *
3383  *        S_i-S_t + S_{i+1}
3384  *      .<--------.------------>
3385  *      .         .
3386  *      . S_i     .   S_{i+1}
3387  *   <--.-------->.<----------->
3388  *   S_t.         .
3389  *   <->.         .
3390  *      t         .
3391  *  |---+---------|-------------|-----...
3392  *         i            i+1
3393  *
3394  * The sum of (e_1 + e_2) captures the depositor's total accumulated ETH gain, handling the case where their
3395  * deposit spanned one scale change. We only care about gains across one scale change, since the compounded
3396  * deposit is defined as being 0 once it has spanned more than one scale change.
3397  *
3398  *
3399  * --- UPDATING P WHEN A LIQUIDATION OCCURS ---
3400  *
3401  * Please see the implementation spec in the proof document, which closely follows on from the compounded deposit / ETH gain derivations:
3402  * https://github.com/liquity/liquity/blob/master/papers/Scalable_Reward_Distribution_with_Compounding_Stakes.pdf
3403  *
3404  *
3405  * --- LQTY ISSUANCE TO STABILITY POOL DEPOSITORS ---
3406  *
3407  * An LQTY issuance event occurs at every deposit operation, and every liquidation.
3408  *
3409  * Each deposit is tagged with the address of the front end through which it was made.
3410  *
3411  * All deposits earn a share of the issued LQTY in proportion to the deposit as a share of total deposits. The LQTY earned
3412  * by a given deposit, is split between the depositor and the front end through which the deposit was made, based on the front end's kickbackRate.
3413  *
3414  * Please see the system Readme for an overview:
3415  * https://github.com/liquity/dev/blob/main/README.md#lqty-issuance-to-stability-providers
3416  *
3417  * We use the same mathematical product-sum approach to track LQTY gains for depositors, where 'G' is the sum corresponding to LQTY gains.
3418  * The product P (and snapshot P_t) is re-used, as the ratio P/P_t tracks a deposit's depletion due to liquidations.
3419  *
3420  */
3421 contract StabilityPool is LiquityBase, Ownable, CheckContract, IStabilityPool {
3422     using LiquitySafeMath128 for uint128;
3423 
3424     string constant public NAME = "StabilityPool";
3425 
3426     IBorrowerOperations public borrowerOperations;
3427 
3428     ITroveManager public troveManager;
3429 
3430     ILUSDToken public lusdToken;
3431 
3432     // Needed to check if there are pending liquidations
3433     ISortedTroves public sortedTroves;
3434 
3435     ICommunityIssuance public communityIssuance;
3436 
3437     uint256 internal ETH;  // deposited ether tracker
3438 
3439     // Tracker for LUSD held in the pool. Changes when users deposit/withdraw, and when Trove debt is offset.
3440     uint256 internal totalLUSDDeposits;
3441 
3442    // --- Data structures ---
3443 
3444     struct FrontEnd {
3445         uint kickbackRate;
3446         bool registered;
3447     }
3448 
3449     struct Deposit {
3450         uint initialValue;
3451         address frontEndTag;
3452     }
3453 
3454     struct Snapshots {
3455         uint S;
3456         uint P;
3457         uint G;
3458         uint128 scale;
3459         uint128 epoch;
3460     }
3461 
3462     mapping (address => Deposit) public deposits;  // depositor address -> Deposit struct
3463     mapping (address => Snapshots) public depositSnapshots;  // depositor address -> snapshots struct
3464 
3465     mapping (address => FrontEnd) public frontEnds;  // front end address -> FrontEnd struct
3466     mapping (address => uint) public frontEndStakes; // front end address -> last recorded total deposits, tagged with that front end
3467     mapping (address => Snapshots) public frontEndSnapshots; // front end address -> snapshots struct
3468 
3469     /*  Product 'P': Running product by which to multiply an initial deposit, in order to find the current compounded deposit,
3470     * after a series of liquidations have occurred, each of which cancel some LUSD debt with the deposit.
3471     *
3472     * During its lifetime, a deposit's value evolves from d_t to d_t * P / P_t , where P_t
3473     * is the snapshot of P taken at the instant the deposit was made. 18-digit decimal.
3474     */
3475     uint public P = DECIMAL_PRECISION;
3476 
3477     uint public constant SCALE_FACTOR = 1e9;
3478 
3479     // Each time the scale of P shifts by SCALE_FACTOR, the scale is incremented by 1
3480     uint128 public currentScale;
3481 
3482     // With each offset that fully empties the Pool, the epoch is incremented by 1
3483     uint128 public currentEpoch;
3484 
3485     /* ETH Gain sum 'S': During its lifetime, each deposit d_t earns an ETH gain of ( d_t * [S - S_t] )/P_t, where S_t
3486     * is the depositor's snapshot of S taken at the time t when the deposit was made.
3487     *
3488     * The 'S' sums are stored in a nested mapping (epoch => scale => sum):
3489     *
3490     * - The inner mapping records the sum S at different scales
3491     * - The outer mapping records the (scale => sum) mappings, for different epochs.
3492     */
3493     mapping (uint128 => mapping(uint128 => uint)) public epochToScaleToSum;
3494 
3495     /*
3496     * Similarly, the sum 'G' is used to calculate LQTY gains. During it's lifetime, each deposit d_t earns a LQTY gain of
3497     *  ( d_t * [G - G_t] )/P_t, where G_t is the depositor's snapshot of G taken at time t when  the deposit was made.
3498     *
3499     *  LQTY reward events occur are triggered by depositor operations (new deposit, topup, withdrawal), and liquidations.
3500     *  In each case, the LQTY reward is issued (i.e. G is updated), before other state changes are made.
3501     */
3502     mapping (uint128 => mapping(uint128 => uint)) public epochToScaleToG;
3503 
3504     // Error tracker for the error correction in the LQTY issuance calculation
3505     uint public lastLQTYError;
3506     // Error trackers for the error correction in the offset calculation
3507     uint public lastETHError_Offset;
3508     uint public lastLUSDLossError_Offset;
3509 
3510     // --- Events ---
3511 
3512     event StabilityPoolETHBalanceUpdated(uint _newBalance);
3513     event StabilityPoolLUSDBalanceUpdated(uint _newBalance);
3514 
3515     event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
3516     event TroveManagerAddressChanged(address _newTroveManagerAddress);
3517     event ActivePoolAddressChanged(address _newActivePoolAddress);
3518     event DefaultPoolAddressChanged(address _newDefaultPoolAddress);
3519     event LUSDTokenAddressChanged(address _newLUSDTokenAddress);
3520     event SortedTrovesAddressChanged(address _newSortedTrovesAddress);
3521     event PriceFeedAddressChanged(address _newPriceFeedAddress);
3522     event CommunityIssuanceAddressChanged(address _newCommunityIssuanceAddress);
3523 
3524     event P_Updated(uint _P);
3525     event S_Updated(uint _S, uint128 _epoch, uint128 _scale);
3526     event G_Updated(uint _G, uint128 _epoch, uint128 _scale);
3527     event EpochUpdated(uint128 _currentEpoch);
3528     event ScaleUpdated(uint128 _currentScale);
3529 
3530     event FrontEndRegistered(address indexed _frontEnd, uint _kickbackRate);
3531     event FrontEndTagSet(address indexed _depositor, address indexed _frontEnd);
3532 
3533     event DepositSnapshotUpdated(address indexed _depositor, uint _P, uint _S, uint _G);
3534     event FrontEndSnapshotUpdated(address indexed _frontEnd, uint _P, uint _G);
3535     event UserDepositChanged(address indexed _depositor, uint _newDeposit);
3536     event FrontEndStakeChanged(address indexed _frontEnd, uint _newFrontEndStake, address _depositor);
3537 
3538     event ETHGainWithdrawn(address indexed _depositor, uint _ETH, uint _LUSDLoss);
3539     event LQTYPaidToDepositor(address indexed _depositor, uint _LQTY);
3540     event LQTYPaidToFrontEnd(address indexed _frontEnd, uint _LQTY);
3541     event EtherSent(address _to, uint _amount);
3542 
3543     // --- Contract setters ---
3544 
3545     function setAddresses(
3546         address _borrowerOperationsAddress,
3547         address _troveManagerAddress,
3548         address _activePoolAddress,
3549         address _lusdTokenAddress,
3550         address _sortedTrovesAddress,
3551         address _priceFeedAddress,
3552         address _communityIssuanceAddress
3553     )
3554         external
3555         override
3556         onlyOwner
3557     {
3558         checkContract(_borrowerOperationsAddress);
3559         checkContract(_troveManagerAddress);
3560         checkContract(_activePoolAddress);
3561         checkContract(_lusdTokenAddress);
3562         checkContract(_sortedTrovesAddress);
3563         checkContract(_priceFeedAddress);
3564         checkContract(_communityIssuanceAddress);
3565 
3566         borrowerOperations = IBorrowerOperations(_borrowerOperationsAddress);
3567         troveManager = ITroveManager(_troveManagerAddress);
3568         activePool = IActivePool(_activePoolAddress);
3569         lusdToken = ILUSDToken(_lusdTokenAddress);
3570         sortedTroves = ISortedTroves(_sortedTrovesAddress);
3571         priceFeed = IPriceFeed(_priceFeedAddress);
3572         communityIssuance = ICommunityIssuance(_communityIssuanceAddress);
3573 
3574         emit BorrowerOperationsAddressChanged(_borrowerOperationsAddress);
3575         emit TroveManagerAddressChanged(_troveManagerAddress);
3576         emit ActivePoolAddressChanged(_activePoolAddress);
3577         emit LUSDTokenAddressChanged(_lusdTokenAddress);
3578         emit SortedTrovesAddressChanged(_sortedTrovesAddress);
3579         emit PriceFeedAddressChanged(_priceFeedAddress);
3580         emit CommunityIssuanceAddressChanged(_communityIssuanceAddress);
3581 
3582         _renounceOwnership();
3583     }
3584 
3585     // --- Getters for public variables. Required by IPool interface ---
3586 
3587     function getETH() external view override returns (uint) {
3588         return ETH;
3589     }
3590 
3591     function getTotalLUSDDeposits() external view override returns (uint) {
3592         return totalLUSDDeposits;
3593     }
3594 
3595     // --- External Depositor Functions ---
3596 
3597     /*  provideToSP():
3598     *
3599     * - Triggers a LQTY issuance, based on time passed since the last issuance. The LQTY issuance is shared between *all* depositors and front ends
3600     * - Tags the deposit with the provided front end tag param, if it's a new deposit
3601     * - Sends depositor's accumulated gains (LQTY, ETH) to depositor
3602     * - Sends the tagged front end's accumulated LQTY gains to the tagged front end
3603     * - Increases deposit and tagged front end's stake, and takes new snapshots for each.
3604     */
3605     function provideToSP(uint _amount, address _frontEndTag) external override {
3606         _requireFrontEndIsRegisteredOrZero(_frontEndTag);
3607         _requireFrontEndNotRegistered(msg.sender);
3608         _requireNonZeroAmount(_amount);
3609 
3610         uint initialDeposit = deposits[msg.sender].initialValue;
3611 
3612         ICommunityIssuance communityIssuanceCached = communityIssuance;
3613 
3614         _triggerLQTYIssuance(communityIssuanceCached);
3615 
3616         if (initialDeposit == 0) {_setFrontEndTag(msg.sender, _frontEndTag);}
3617         uint depositorETHGain = getDepositorETHGain(msg.sender);
3618         uint compoundedLUSDDeposit = getCompoundedLUSDDeposit(msg.sender);
3619         uint LUSDLoss = initialDeposit.sub(compoundedLUSDDeposit); // Needed only for event log
3620 
3621         // First pay out any LQTY gains
3622         address frontEnd = deposits[msg.sender].frontEndTag;
3623         _payOutLQTYGains(communityIssuanceCached, msg.sender, frontEnd);
3624 
3625         // Update front end stake
3626         uint compoundedFrontEndStake = getCompoundedFrontEndStake(frontEnd);
3627         uint newFrontEndStake = compoundedFrontEndStake.add(_amount);
3628         _updateFrontEndStakeAndSnapshots(frontEnd, newFrontEndStake);
3629         emit FrontEndStakeChanged(frontEnd, newFrontEndStake, msg.sender);
3630 
3631         _sendLUSDtoStabilityPool(msg.sender, _amount);
3632 
3633         uint newDeposit = compoundedLUSDDeposit.add(_amount);
3634         _updateDepositAndSnapshots(msg.sender, newDeposit);
3635         emit UserDepositChanged(msg.sender, newDeposit);
3636 
3637         emit ETHGainWithdrawn(msg.sender, depositorETHGain, LUSDLoss); // LUSD Loss required for event log
3638 
3639         _sendETHGainToDepositor(depositorETHGain);
3640      }
3641 
3642     /*  withdrawFromSP():
3643     *
3644     * - Triggers a LQTY issuance, based on time passed since the last issuance. The LQTY issuance is shared between *all* depositors and front ends
3645     * - Removes the deposit's front end tag if it is a full withdrawal
3646     * - Sends all depositor's accumulated gains (LQTY, ETH) to depositor
3647     * - Sends the tagged front end's accumulated LQTY gains to the tagged front end
3648     * - Decreases deposit and tagged front end's stake, and takes new snapshots for each.
3649     *
3650     * If _amount > userDeposit, the user withdraws all of their compounded deposit.
3651     */
3652     function withdrawFromSP(uint _amount) external override {
3653         if (_amount !=0) {_requireNoUnderCollateralizedTroves();}
3654         uint initialDeposit = deposits[msg.sender].initialValue;
3655         _requireUserHasDeposit(initialDeposit);
3656 
3657         ICommunityIssuance communityIssuanceCached = communityIssuance;
3658 
3659         _triggerLQTYIssuance(communityIssuanceCached);
3660 
3661         uint depositorETHGain = getDepositorETHGain(msg.sender);
3662 
3663         uint compoundedLUSDDeposit = getCompoundedLUSDDeposit(msg.sender);
3664         uint LUSDtoWithdraw = LiquityMath._min(_amount, compoundedLUSDDeposit);
3665         uint LUSDLoss = initialDeposit.sub(compoundedLUSDDeposit); // Needed only for event log
3666 
3667         // First pay out any LQTY gains
3668         address frontEnd = deposits[msg.sender].frontEndTag;
3669         _payOutLQTYGains(communityIssuanceCached, msg.sender, frontEnd);
3670         
3671         // Update front end stake
3672         uint compoundedFrontEndStake = getCompoundedFrontEndStake(frontEnd);
3673         uint newFrontEndStake = compoundedFrontEndStake.sub(LUSDtoWithdraw);
3674         _updateFrontEndStakeAndSnapshots(frontEnd, newFrontEndStake);
3675         emit FrontEndStakeChanged(frontEnd, newFrontEndStake, msg.sender);
3676 
3677         _sendLUSDToDepositor(msg.sender, LUSDtoWithdraw);
3678 
3679         // Update deposit
3680         uint newDeposit = compoundedLUSDDeposit.sub(LUSDtoWithdraw);
3681         _updateDepositAndSnapshots(msg.sender, newDeposit);
3682         emit UserDepositChanged(msg.sender, newDeposit);
3683 
3684         emit ETHGainWithdrawn(msg.sender, depositorETHGain, LUSDLoss);  // LUSD Loss required for event log
3685 
3686         _sendETHGainToDepositor(depositorETHGain);
3687     }
3688 
3689     /* withdrawETHGainToTrove:
3690     * - Triggers a LQTY issuance, based on time passed since the last issuance. The LQTY issuance is shared between *all* depositors and front ends
3691     * - Sends all depositor's LQTY gain to  depositor
3692     * - Sends all tagged front end's LQTY gain to the tagged front end
3693     * - Transfers the depositor's entire ETH gain from the Stability Pool to the caller's trove
3694     * - Leaves their compounded deposit in the Stability Pool
3695     * - Updates snapshots for deposit and tagged front end stake */
3696     function withdrawETHGainToTrove(address _upperHint, address _lowerHint) external override {
3697         uint initialDeposit = deposits[msg.sender].initialValue;
3698         _requireUserHasDeposit(initialDeposit);
3699         _requireUserHasTrove(msg.sender);
3700         _requireUserHasETHGain(msg.sender);
3701 
3702         ICommunityIssuance communityIssuanceCached = communityIssuance;
3703 
3704         _triggerLQTYIssuance(communityIssuanceCached);
3705 
3706         uint depositorETHGain = getDepositorETHGain(msg.sender);
3707 
3708         uint compoundedLUSDDeposit = getCompoundedLUSDDeposit(msg.sender);
3709         uint LUSDLoss = initialDeposit.sub(compoundedLUSDDeposit); // Needed only for event log
3710 
3711         // First pay out any LQTY gains
3712         address frontEnd = deposits[msg.sender].frontEndTag;
3713         _payOutLQTYGains(communityIssuanceCached, msg.sender, frontEnd);
3714 
3715         // Update front end stake
3716         uint compoundedFrontEndStake = getCompoundedFrontEndStake(frontEnd);
3717         uint newFrontEndStake = compoundedFrontEndStake;
3718         _updateFrontEndStakeAndSnapshots(frontEnd, newFrontEndStake);
3719         emit FrontEndStakeChanged(frontEnd, newFrontEndStake, msg.sender);
3720 
3721         _updateDepositAndSnapshots(msg.sender, compoundedLUSDDeposit);
3722 
3723         /* Emit events before transferring ETH gain to Trove.
3724          This lets the event log make more sense (i.e. so it appears that first the ETH gain is withdrawn
3725         and then it is deposited into the Trove, not the other way around). */
3726         emit ETHGainWithdrawn(msg.sender, depositorETHGain, LUSDLoss);
3727         emit UserDepositChanged(msg.sender, compoundedLUSDDeposit);
3728 
3729         ETH = ETH.sub(depositorETHGain);
3730         emit StabilityPoolETHBalanceUpdated(ETH);
3731         emit EtherSent(msg.sender, depositorETHGain);
3732 
3733         borrowerOperations.moveETHGainToTrove{ value: depositorETHGain }(msg.sender, _upperHint, _lowerHint);
3734     }
3735 
3736     // --- LQTY issuance functions ---
3737 
3738     function _triggerLQTYIssuance(ICommunityIssuance _communityIssuance) internal {
3739         uint LQTYIssuance = _communityIssuance.issueLQTY();
3740        _updateG(LQTYIssuance);
3741     }
3742 
3743     function _updateG(uint _LQTYIssuance) internal {
3744         uint totalLUSD = totalLUSDDeposits; // cached to save an SLOAD
3745         /*
3746         * When total deposits is 0, G is not updated. In this case, the LQTY issued can not be obtained by later
3747         * depositors - it is missed out on, and remains in the balanceof the CommunityIssuance contract.
3748         *
3749         */
3750         if (totalLUSD == 0 || _LQTYIssuance == 0) {return;}
3751 
3752         uint LQTYPerUnitStaked;
3753         LQTYPerUnitStaked =_computeLQTYPerUnitStaked(_LQTYIssuance, totalLUSD);
3754 
3755         uint marginalLQTYGain = LQTYPerUnitStaked.mul(P);
3756         epochToScaleToG[currentEpoch][currentScale] = epochToScaleToG[currentEpoch][currentScale].add(marginalLQTYGain);
3757 
3758         emit G_Updated(epochToScaleToG[currentEpoch][currentScale], currentEpoch, currentScale);
3759     }
3760 
3761     function _computeLQTYPerUnitStaked(uint _LQTYIssuance, uint _totalLUSDDeposits) internal returns (uint) {
3762         /*  
3763         * Calculate the LQTY-per-unit staked.  Division uses a "feedback" error correction, to keep the 
3764         * cumulative error low in the running total G:
3765         *
3766         * 1) Form a numerator which compensates for the floor division error that occurred the last time this 
3767         * function was called.  
3768         * 2) Calculate "per-unit-staked" ratio.
3769         * 3) Multiply the ratio back by its denominator, to reveal the current floor division error.
3770         * 4) Store this error for use in the next correction when this function is called.
3771         * 5) Note: static analysis tools complain about this "division before multiplication", however, it is intended.
3772         */
3773         uint LQTYNumerator = _LQTYIssuance.mul(DECIMAL_PRECISION).add(lastLQTYError);
3774 
3775         uint LQTYPerUnitStaked = LQTYNumerator.div(_totalLUSDDeposits);
3776         lastLQTYError = LQTYNumerator.sub(LQTYPerUnitStaked.mul(_totalLUSDDeposits));
3777 
3778         return LQTYPerUnitStaked;
3779     }
3780 
3781     // --- Liquidation functions ---
3782 
3783     /*
3784     * Cancels out the specified debt against the LUSD contained in the Stability Pool (as far as possible)
3785     * and transfers the Trove's ETH collateral from ActivePool to StabilityPool.
3786     * Only called by liquidation functions in the TroveManager.
3787     */
3788     function offset(uint _debtToOffset, uint _collToAdd) external override {
3789         _requireCallerIsTroveManager();
3790         uint totalLUSD = totalLUSDDeposits; // cached to save an SLOAD
3791         if (totalLUSD == 0 || _debtToOffset == 0) { return; }
3792 
3793         _triggerLQTYIssuance(communityIssuance);
3794 
3795         (uint ETHGainPerUnitStaked,
3796             uint LUSDLossPerUnitStaked) = _computeRewardsPerUnitStaked(_collToAdd, _debtToOffset, totalLUSD);
3797 
3798         _updateRewardSumAndProduct(ETHGainPerUnitStaked, LUSDLossPerUnitStaked);  // updates S and P
3799 
3800         _moveOffsetCollAndDebt(_collToAdd, _debtToOffset);
3801     }
3802 
3803     // --- Offset helper functions ---
3804 
3805     function _computeRewardsPerUnitStaked(
3806         uint _collToAdd,
3807         uint _debtToOffset,
3808         uint _totalLUSDDeposits
3809     )
3810         internal
3811         returns (uint ETHGainPerUnitStaked, uint LUSDLossPerUnitStaked)
3812     {
3813         /*
3814         * Compute the LUSD and ETH rewards. Uses a "feedback" error correction, to keep
3815         * the cumulative error in the P and S state variables low:
3816         *
3817         * 1) Form numerators which compensate for the floor division errors that occurred the last time this 
3818         * function was called.  
3819         * 2) Calculate "per-unit-staked" ratios.
3820         * 3) Multiply each ratio back by its denominator, to reveal the current floor division error.
3821         * 4) Store these errors for use in the next correction when this function is called.
3822         * 5) Note: static analysis tools complain about this "division before multiplication", however, it is intended.
3823         */
3824         uint ETHNumerator = _collToAdd.mul(DECIMAL_PRECISION).add(lastETHError_Offset);
3825 
3826         assert(_debtToOffset <= _totalLUSDDeposits);
3827         if (_debtToOffset == _totalLUSDDeposits) {
3828             LUSDLossPerUnitStaked = DECIMAL_PRECISION;  // When the Pool depletes to 0, so does each deposit 
3829             lastLUSDLossError_Offset = 0;
3830         } else {
3831             uint LUSDLossNumerator = _debtToOffset.mul(DECIMAL_PRECISION).sub(lastLUSDLossError_Offset);
3832             /*
3833             * Add 1 to make error in quotient positive. We want "slightly too much" LUSD loss,
3834             * which ensures the error in any given compoundedLUSDDeposit favors the Stability Pool.
3835             */
3836             LUSDLossPerUnitStaked = (LUSDLossNumerator.div(_totalLUSDDeposits)).add(1);
3837             lastLUSDLossError_Offset = (LUSDLossPerUnitStaked.mul(_totalLUSDDeposits)).sub(LUSDLossNumerator);
3838         }
3839 
3840         ETHGainPerUnitStaked = ETHNumerator.div(_totalLUSDDeposits);
3841         lastETHError_Offset = ETHNumerator.sub(ETHGainPerUnitStaked.mul(_totalLUSDDeposits));
3842 
3843         return (ETHGainPerUnitStaked, LUSDLossPerUnitStaked);
3844     }
3845 
3846     // Update the Stability Pool reward sum S and product P
3847     function _updateRewardSumAndProduct(uint _ETHGainPerUnitStaked, uint _LUSDLossPerUnitStaked) internal {
3848         uint currentP = P;
3849         uint newP;
3850 
3851         assert(_LUSDLossPerUnitStaked <= DECIMAL_PRECISION);
3852         /*
3853         * The newProductFactor is the factor by which to change all deposits, due to the depletion of Stability Pool LUSD in the liquidation.
3854         * We make the product factor 0 if there was a pool-emptying. Otherwise, it is (1 - LUSDLossPerUnitStaked)
3855         */
3856         uint newProductFactor = uint(DECIMAL_PRECISION).sub(_LUSDLossPerUnitStaked);
3857 
3858         uint128 currentScaleCached = currentScale;
3859         uint128 currentEpochCached = currentEpoch;
3860         uint currentS = epochToScaleToSum[currentEpochCached][currentScaleCached];
3861 
3862         /*
3863         * Calculate the new S first, before we update P.
3864         * The ETH gain for any given depositor from a liquidation depends on the value of their deposit
3865         * (and the value of totalDeposits) prior to the Stability being depleted by the debt in the liquidation.
3866         *
3867         * Since S corresponds to ETH gain, and P to deposit loss, we update S first.
3868         */
3869         uint marginalETHGain = _ETHGainPerUnitStaked.mul(currentP);
3870         uint newS = currentS.add(marginalETHGain);
3871         epochToScaleToSum[currentEpochCached][currentScaleCached] = newS;
3872         emit S_Updated(newS, currentEpochCached, currentScaleCached);
3873 
3874         // If the Stability Pool was emptied, increment the epoch, and reset the scale and product P
3875         if (newProductFactor == 0) {
3876             currentEpoch = currentEpochCached.add(1);
3877             emit EpochUpdated(currentEpoch);
3878             currentScale = 0;
3879             emit ScaleUpdated(currentScale);
3880             newP = DECIMAL_PRECISION;
3881 
3882         // If multiplying P by a non-zero product factor would reduce P below the scale boundary, increment the scale
3883         } else if (currentP.mul(newProductFactor).div(DECIMAL_PRECISION) < SCALE_FACTOR) {
3884             newP = currentP.mul(newProductFactor).mul(SCALE_FACTOR).div(DECIMAL_PRECISION); 
3885             currentScale = currentScaleCached.add(1);
3886             emit ScaleUpdated(currentScale);
3887         } else {
3888             newP = currentP.mul(newProductFactor).div(DECIMAL_PRECISION);
3889         }
3890 
3891         assert(newP > 0);
3892         P = newP;
3893 
3894         emit P_Updated(newP);
3895     }
3896 
3897     function _moveOffsetCollAndDebt(uint _collToAdd, uint _debtToOffset) internal {
3898         IActivePool activePoolCached = activePool;
3899 
3900         // Cancel the liquidated LUSD debt with the LUSD in the stability pool
3901         activePoolCached.decreaseLUSDDebt(_debtToOffset);
3902         _decreaseLUSD(_debtToOffset);
3903 
3904         // Burn the debt that was successfully offset
3905         lusdToken.burn(address(this), _debtToOffset);
3906 
3907         activePoolCached.sendETH(address(this), _collToAdd);
3908     }
3909 
3910     function _decreaseLUSD(uint _amount) internal {
3911         uint newTotalLUSDDeposits = totalLUSDDeposits.sub(_amount);
3912         totalLUSDDeposits = newTotalLUSDDeposits;
3913         emit StabilityPoolLUSDBalanceUpdated(newTotalLUSDDeposits);
3914     }
3915 
3916     // --- Reward calculator functions for depositor and front end ---
3917 
3918     /* Calculates the ETH gain earned by the deposit since its last snapshots were taken.
3919     * Given by the formula:  E = d0 * (S - S(0))/P(0)
3920     * where S(0) and P(0) are the depositor's snapshots of the sum S and product P, respectively.
3921     * d0 is the last recorded deposit value.
3922     */
3923     function getDepositorETHGain(address _depositor) public view override returns (uint) {
3924         uint initialDeposit = deposits[_depositor].initialValue;
3925 
3926         if (initialDeposit == 0) { return 0; }
3927 
3928         Snapshots memory snapshots = depositSnapshots[_depositor];
3929 
3930         uint ETHGain = _getETHGainFromSnapshots(initialDeposit, snapshots);
3931         return ETHGain;
3932     }
3933 
3934     function _getETHGainFromSnapshots(uint initialDeposit, Snapshots memory snapshots) internal view returns (uint) {
3935         /*
3936         * Grab the sum 'S' from the epoch at which the stake was made. The ETH gain may span up to one scale change.
3937         * If it does, the second portion of the ETH gain is scaled by 1e9.
3938         * If the gain spans no scale change, the second portion will be 0.
3939         */
3940         uint128 epochSnapshot = snapshots.epoch;
3941         uint128 scaleSnapshot = snapshots.scale;
3942         uint S_Snapshot = snapshots.S;
3943         uint P_Snapshot = snapshots.P;
3944 
3945         uint firstPortion = epochToScaleToSum[epochSnapshot][scaleSnapshot].sub(S_Snapshot);
3946         uint secondPortion = epochToScaleToSum[epochSnapshot][scaleSnapshot.add(1)].div(SCALE_FACTOR);
3947 
3948         uint ETHGain = initialDeposit.mul(firstPortion.add(secondPortion)).div(P_Snapshot).div(DECIMAL_PRECISION);
3949 
3950         return ETHGain;
3951     }
3952 
3953     /*
3954     * Calculate the LQTY gain earned by a deposit since its last snapshots were taken.
3955     * Given by the formula:  LQTY = d0 * (G - G(0))/P(0)
3956     * where G(0) and P(0) are the depositor's snapshots of the sum G and product P, respectively.
3957     * d0 is the last recorded deposit value.
3958     */
3959     function getDepositorLQTYGain(address _depositor) public view override returns (uint) {
3960         uint initialDeposit = deposits[_depositor].initialValue;
3961         if (initialDeposit == 0) {return 0;}
3962 
3963         address frontEndTag = deposits[_depositor].frontEndTag;
3964 
3965         /*
3966         * If not tagged with a front end, the depositor gets a 100% cut of what their deposit earned.
3967         * Otherwise, their cut of the deposit's earnings is equal to the kickbackRate, set by the front end through
3968         * which they made their deposit.
3969         */
3970         uint kickbackRate = frontEndTag == address(0) ? DECIMAL_PRECISION : frontEnds[frontEndTag].kickbackRate;
3971 
3972         Snapshots memory snapshots = depositSnapshots[_depositor];
3973 
3974         uint LQTYGain = kickbackRate.mul(_getLQTYGainFromSnapshots(initialDeposit, snapshots)).div(DECIMAL_PRECISION);
3975 
3976         return LQTYGain;
3977     }
3978 
3979     /*
3980     * Return the LQTY gain earned by the front end. Given by the formula:  E = D0 * (G - G(0))/P(0)
3981     * where G(0) and P(0) are the depositor's snapshots of the sum G and product P, respectively.
3982     *
3983     * D0 is the last recorded value of the front end's total tagged deposits.
3984     */
3985     function getFrontEndLQTYGain(address _frontEnd) public view override returns (uint) {
3986         uint frontEndStake = frontEndStakes[_frontEnd];
3987         if (frontEndStake == 0) { return 0; }
3988 
3989         uint kickbackRate = frontEnds[_frontEnd].kickbackRate;
3990         uint frontEndShare = uint(DECIMAL_PRECISION).sub(kickbackRate);
3991 
3992         Snapshots memory snapshots = frontEndSnapshots[_frontEnd];
3993 
3994         uint LQTYGain = frontEndShare.mul(_getLQTYGainFromSnapshots(frontEndStake, snapshots)).div(DECIMAL_PRECISION);
3995         return LQTYGain;
3996     }
3997 
3998     function _getLQTYGainFromSnapshots(uint initialStake, Snapshots memory snapshots) internal view returns (uint) {
3999        /*
4000         * Grab the sum 'G' from the epoch at which the stake was made. The LQTY gain may span up to one scale change.
4001         * If it does, the second portion of the LQTY gain is scaled by 1e9.
4002         * If the gain spans no scale change, the second portion will be 0.
4003         */
4004         uint128 epochSnapshot = snapshots.epoch;
4005         uint128 scaleSnapshot = snapshots.scale;
4006         uint G_Snapshot = snapshots.G;
4007         uint P_Snapshot = snapshots.P;
4008 
4009         uint firstPortion = epochToScaleToG[epochSnapshot][scaleSnapshot].sub(G_Snapshot);
4010         uint secondPortion = epochToScaleToG[epochSnapshot][scaleSnapshot.add(1)].div(SCALE_FACTOR);
4011 
4012         uint LQTYGain = initialStake.mul(firstPortion.add(secondPortion)).div(P_Snapshot).div(DECIMAL_PRECISION);
4013 
4014         return LQTYGain;
4015     }
4016 
4017     // --- Compounded deposit and compounded front end stake ---
4018 
4019     /*
4020     * Return the user's compounded deposit. Given by the formula:  d = d0 * P/P(0)
4021     * where P(0) is the depositor's snapshot of the product P, taken when they last updated their deposit.
4022     */
4023     function getCompoundedLUSDDeposit(address _depositor) public view override returns (uint) {
4024         uint initialDeposit = deposits[_depositor].initialValue;
4025         if (initialDeposit == 0) { return 0; }
4026 
4027         Snapshots memory snapshots = depositSnapshots[_depositor];
4028 
4029         uint compoundedDeposit = _getCompoundedStakeFromSnapshots(initialDeposit, snapshots);
4030         return compoundedDeposit;
4031     }
4032 
4033     /*
4034     * Return the front end's compounded stake. Given by the formula:  D = D0 * P/P(0)
4035     * where P(0) is the depositor's snapshot of the product P, taken at the last time
4036     * when one of the front end's tagged deposits updated their deposit.
4037     *
4038     * The front end's compounded stake is equal to the sum of its depositors' compounded deposits.
4039     */
4040     function getCompoundedFrontEndStake(address _frontEnd) public view override returns (uint) {
4041         uint frontEndStake = frontEndStakes[_frontEnd];
4042         if (frontEndStake == 0) { return 0; }
4043 
4044         Snapshots memory snapshots = frontEndSnapshots[_frontEnd];
4045 
4046         uint compoundedFrontEndStake = _getCompoundedStakeFromSnapshots(frontEndStake, snapshots);
4047         return compoundedFrontEndStake;
4048     }
4049 
4050     // Internal function, used to calculcate compounded deposits and compounded front end stakes.
4051     function _getCompoundedStakeFromSnapshots(
4052         uint initialStake,
4053         Snapshots memory snapshots
4054     )
4055         internal
4056         view
4057         returns (uint)
4058     {
4059         uint snapshot_P = snapshots.P;
4060         uint128 scaleSnapshot = snapshots.scale;
4061         uint128 epochSnapshot = snapshots.epoch;
4062 
4063         // If stake was made before a pool-emptying event, then it has been fully cancelled with debt -- so, return 0
4064         if (epochSnapshot < currentEpoch) { return 0; }
4065 
4066         uint compoundedStake;
4067         uint128 scaleDiff = currentScale.sub(scaleSnapshot);
4068 
4069         /* Compute the compounded stake. If a scale change in P was made during the stake's lifetime,
4070         * account for it. If more than one scale change was made, then the stake has decreased by a factor of
4071         * at least 1e-9 -- so return 0.
4072         */
4073         if (scaleDiff == 0) {
4074             compoundedStake = initialStake.mul(P).div(snapshot_P);
4075         } else if (scaleDiff == 1) {
4076             compoundedStake = initialStake.mul(P).div(snapshot_P).div(SCALE_FACTOR);
4077         } else { // if scaleDiff >= 2
4078             compoundedStake = 0;
4079         }
4080 
4081         /*
4082         * If compounded deposit is less than a billionth of the initial deposit, return 0.
4083         *
4084         * NOTE: originally, this line was in place to stop rounding errors making the deposit too large. However, the error
4085         * corrections should ensure the error in P "favors the Pool", i.e. any given compounded deposit should slightly less
4086         * than it's theoretical value.
4087         *
4088         * Thus it's unclear whether this line is still really needed.
4089         */
4090         if (compoundedStake < initialStake.div(1e9)) {return 0;}
4091 
4092         return compoundedStake;
4093     }
4094 
4095     // --- Sender functions for LUSD deposit, ETH gains and LQTY gains ---
4096 
4097     // Transfer the LUSD tokens from the user to the Stability Pool's address, and update its recorded LUSD
4098     function _sendLUSDtoStabilityPool(address _address, uint _amount) internal {
4099         lusdToken.sendToPool(_address, address(this), _amount);
4100         uint newTotalLUSDDeposits = totalLUSDDeposits.add(_amount);
4101         totalLUSDDeposits = newTotalLUSDDeposits;
4102         emit StabilityPoolLUSDBalanceUpdated(newTotalLUSDDeposits);
4103     }
4104 
4105     function _sendETHGainToDepositor(uint _amount) internal {
4106         if (_amount == 0) {return;}
4107         uint newETH = ETH.sub(_amount);
4108         ETH = newETH;
4109         emit StabilityPoolETHBalanceUpdated(newETH);
4110         emit EtherSent(msg.sender, _amount);
4111 
4112         (bool success, ) = msg.sender.call{ value: _amount }("");
4113         require(success, "StabilityPool: sending ETH failed");
4114     }
4115 
4116     // Send LUSD to user and decrease LUSD in Pool
4117     function _sendLUSDToDepositor(address _depositor, uint LUSDWithdrawal) internal {
4118         if (LUSDWithdrawal == 0) {return;}
4119 
4120         lusdToken.returnFromPool(address(this), _depositor, LUSDWithdrawal);
4121         _decreaseLUSD(LUSDWithdrawal);
4122     }
4123 
4124     // --- External Front End functions ---
4125 
4126     // Front end makes a one-time selection of kickback rate upon registering
4127     function registerFrontEnd(uint _kickbackRate) external override {
4128         _requireFrontEndNotRegistered(msg.sender);
4129         _requireUserHasNoDeposit(msg.sender);
4130         _requireValidKickbackRate(_kickbackRate);
4131 
4132         frontEnds[msg.sender].kickbackRate = _kickbackRate;
4133         frontEnds[msg.sender].registered = true;
4134 
4135         emit FrontEndRegistered(msg.sender, _kickbackRate);
4136     }
4137 
4138     // --- Stability Pool Deposit Functionality ---
4139 
4140     function _setFrontEndTag(address _depositor, address _frontEndTag) internal {
4141         deposits[_depositor].frontEndTag = _frontEndTag;
4142         emit FrontEndTagSet(_depositor, _frontEndTag);
4143     }
4144 
4145 
4146     function _updateDepositAndSnapshots(address _depositor, uint _newValue) internal {
4147         deposits[_depositor].initialValue = _newValue;
4148 
4149         if (_newValue == 0) {
4150             delete deposits[_depositor].frontEndTag;
4151             delete depositSnapshots[_depositor];
4152             emit DepositSnapshotUpdated(_depositor, 0, 0, 0);
4153             return;
4154         }
4155         uint128 currentScaleCached = currentScale;
4156         uint128 currentEpochCached = currentEpoch;
4157         uint currentP = P;
4158 
4159         // Get S and G for the current epoch and current scale
4160         uint currentS = epochToScaleToSum[currentEpochCached][currentScaleCached];
4161         uint currentG = epochToScaleToG[currentEpochCached][currentScaleCached];
4162 
4163         // Record new snapshots of the latest running product P, sum S, and sum G, for the depositor
4164         depositSnapshots[_depositor].P = currentP;
4165         depositSnapshots[_depositor].S = currentS;
4166         depositSnapshots[_depositor].G = currentG;
4167         depositSnapshots[_depositor].scale = currentScaleCached;
4168         depositSnapshots[_depositor].epoch = currentEpochCached;
4169 
4170         emit DepositSnapshotUpdated(_depositor, currentP, currentS, currentG);
4171     }
4172 
4173     function _updateFrontEndStakeAndSnapshots(address _frontEnd, uint _newValue) internal {
4174         frontEndStakes[_frontEnd] = _newValue;
4175 
4176         if (_newValue == 0) {
4177             delete frontEndSnapshots[_frontEnd];
4178             emit FrontEndSnapshotUpdated(_frontEnd, 0, 0);
4179             return;
4180         }
4181 
4182         uint128 currentScaleCached = currentScale;
4183         uint128 currentEpochCached = currentEpoch;
4184         uint currentP = P;
4185 
4186         // Get G for the current epoch and current scale
4187         uint currentG = epochToScaleToG[currentEpochCached][currentScaleCached];
4188 
4189         // Record new snapshots of the latest running product P and sum G for the front end
4190         frontEndSnapshots[_frontEnd].P = currentP;
4191         frontEndSnapshots[_frontEnd].G = currentG;
4192         frontEndSnapshots[_frontEnd].scale = currentScaleCached;
4193         frontEndSnapshots[_frontEnd].epoch = currentEpochCached;
4194 
4195         emit FrontEndSnapshotUpdated(_frontEnd, currentP, currentG);
4196     }
4197 
4198     function _payOutLQTYGains(ICommunityIssuance _communityIssuance, address _depositor, address _frontEnd) internal {
4199         // Pay out front end's LQTY gain
4200         if (_frontEnd != address(0)) {
4201             uint frontEndLQTYGain = getFrontEndLQTYGain(_frontEnd);
4202             _communityIssuance.sendLQTY(_frontEnd, frontEndLQTYGain);
4203             emit LQTYPaidToFrontEnd(_frontEnd, frontEndLQTYGain);
4204         }
4205 
4206         // Pay out depositor's LQTY gain
4207         uint depositorLQTYGain = getDepositorLQTYGain(_depositor);
4208         _communityIssuance.sendLQTY(_depositor, depositorLQTYGain);
4209         emit LQTYPaidToDepositor(_depositor, depositorLQTYGain);
4210     }
4211 
4212     // --- 'require' functions ---
4213 
4214     function _requireCallerIsActivePool() internal view {
4215         require( msg.sender == address(activePool), "StabilityPool: Caller is not ActivePool");
4216     }
4217 
4218     function _requireCallerIsTroveManager() internal view {
4219         require(msg.sender == address(troveManager), "StabilityPool: Caller is not TroveManager");
4220     }
4221 
4222     function _requireNoUnderCollateralizedTroves() internal {
4223         uint price = priceFeed.fetchPrice();
4224         address lowestTrove = sortedTroves.getLast();
4225         uint ICR = troveManager.getCurrentICR(lowestTrove, price);
4226         require(ICR >= MCR, "StabilityPool: Cannot withdraw while there are troves with ICR < MCR");
4227     }
4228 
4229     function _requireUserHasDeposit(uint _initialDeposit) internal pure {
4230         require(_initialDeposit > 0, 'StabilityPool: User must have a non-zero deposit');
4231     }
4232 
4233      function _requireUserHasNoDeposit(address _address) internal view {
4234         uint initialDeposit = deposits[_address].initialValue;
4235         require(initialDeposit == 0, 'StabilityPool: User must have no deposit');
4236     }
4237 
4238     function _requireNonZeroAmount(uint _amount) internal pure {
4239         require(_amount > 0, 'StabilityPool: Amount must be non-zero');
4240     }
4241 
4242     function _requireUserHasTrove(address _depositor) internal view {
4243         require(troveManager.getTroveStatus(_depositor) == 1, "StabilityPool: caller must have an active trove to withdraw ETHGain to");
4244     }
4245 
4246     function _requireUserHasETHGain(address _depositor) internal view {
4247         uint ETHGain = getDepositorETHGain(_depositor);
4248         require(ETHGain > 0, "StabilityPool: caller must have non-zero ETH Gain");
4249     }
4250 
4251     function _requireFrontEndNotRegistered(address _address) internal view {
4252         require(!frontEnds[_address].registered, "StabilityPool: must not already be a registered front end");
4253     }
4254 
4255      function _requireFrontEndIsRegisteredOrZero(address _address) internal view {
4256         require(frontEnds[_address].registered || _address == address(0),
4257             "StabilityPool: Tag must be a registered front end, or the zero address");
4258     }
4259 
4260     function  _requireValidKickbackRate(uint _kickbackRate) internal pure {
4261         require (_kickbackRate <= DECIMAL_PRECISION, "StabilityPool: Kickback rate must be in range [0,1]");
4262     }
4263 
4264     // --- Fallback function ---
4265 
4266     receive() external payable {
4267         _requireCallerIsActivePool();
4268         ETH = ETH.add(msg.value);
4269         StabilityPoolETHBalanceUpdated(ETH);
4270     }
4271 }
4272 
4273 
4274 // File contracts/B.Protocol/crop.sol
4275 
4276 
4277 // Copyright (C) 2021 Dai Foundation
4278 //
4279 // This program is free software: you can redistribute it and/or modify
4280 // it under the terms of the GNU Affero General Public License as published by
4281 // the Free Software Foundation, either version 3 of the License, or
4282 // (at your option) any later version.
4283 //
4284 // This program is distributed in the hope that it will be useful,
4285 // but WITHOUT ANY WARRANTY; without even the implied warranty of
4286 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4287 // GNU Affero General Public License for more details.
4288 //
4289 // You should have received a copy of the GNU Affero General Public License
4290 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
4291 
4292 pragma solidity 0.6.11;
4293 
4294 interface VatLike {
4295     function urns(bytes32, address) external view returns (uint256, uint256);
4296     function gem(bytes32, address) external view returns (uint256);
4297     function slip(bytes32, address, int256) external;
4298 }
4299 
4300 interface ERC20 {
4301     function balanceOf(address owner) external view returns (uint256);
4302     function transfer(address dst, uint256 amount) external returns (bool);
4303     function transferFrom(address src, address dst, uint256 amount) external returns (bool);
4304     function approve(address spender, uint256 amount) external returns (bool);
4305     function allowance(address owner, address spender) external view returns (uint256);
4306     function decimals() external returns (uint8);
4307 }
4308 
4309 // receives tokens and shares them among holders
4310 contract CropJoin {
4311 
4312     VatLike     public immutable vat;    // cdp engine
4313     bytes32     public immutable ilk;    // collateral type
4314     ERC20       public immutable gem;    // collateral token
4315     uint256     public immutable dec;    // gem decimals
4316     ERC20       public immutable bonus;  // rewards token
4317 
4318     uint256     public share;  // crops per gem    [ray]
4319     uint256     public total;  // total gems       [wad]
4320     uint256     public stock;  // crop balance     [wad]
4321 
4322     mapping (address => uint256) public crops; // crops per user  [wad]
4323     mapping (address => uint256) public stake; // gems per user   [wad]
4324 
4325     uint256 immutable internal to18ConversionFactor;
4326     uint256 immutable internal toGemConversionFactor;
4327 
4328     // --- Events ---
4329     event Join(uint256 val);
4330     event Exit(uint256 val);
4331     event Flee();
4332     event Tack(address indexed src, address indexed dst, uint256 wad);
4333 
4334     constructor(address vat_, bytes32 ilk_, address gem_, address bonus_) public {
4335         vat = VatLike(vat_);
4336         ilk = ilk_;
4337         gem = ERC20(gem_);
4338         uint256 dec_ = ERC20(gem_).decimals();
4339         require(dec_ <= 18);
4340         dec = dec_;
4341         to18ConversionFactor = 10 ** (18 - dec_);
4342         toGemConversionFactor = 10 ** dec_;
4343 
4344         bonus = ERC20(bonus_);
4345     }
4346 
4347     function add(uint256 x, uint256 y) public pure returns (uint256 z) {
4348         require((z = x + y) >= x, "ds-math-add-overflow");
4349     }
4350     function sub(uint256 x, uint256 y) public pure returns (uint256 z) {
4351         require((z = x - y) <= x, "ds-math-sub-underflow");
4352     }
4353     function mul(uint256 x, uint256 y) public pure returns (uint256 z) {
4354         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
4355     }
4356     function divup(uint256 x, uint256 y) internal pure returns (uint256 z) {
4357         z = add(x, sub(y, 1)) / y;
4358     }
4359     uint256 constant WAD  = 10 ** 18;
4360     function wmul(uint256 x, uint256 y) public pure returns (uint256 z) {
4361         z = mul(x, y) / WAD;
4362     }
4363     function wdiv(uint256 x, uint256 y) public pure returns (uint256 z) {
4364         z = mul(x, WAD) / y;
4365     }
4366     function wdivup(uint256 x, uint256 y) public pure returns (uint256 z) {
4367         z = divup(mul(x, WAD), y);
4368     }
4369     uint256 constant RAY  = 10 ** 27;
4370     function rmul(uint256 x, uint256 y) public pure returns (uint256 z) {
4371         z = mul(x, y) / RAY;
4372     }
4373     function rmulup(uint256 x, uint256 y) public pure returns (uint256 z) {
4374         z = divup(mul(x, y), RAY);
4375     }
4376     function rdiv(uint256 x, uint256 y) public pure returns (uint256 z) {
4377         z = mul(x, RAY) / y;
4378     }
4379 
4380     // Net Asset Valuation [wad]
4381     function nav() public virtual returns (uint256) {
4382         uint256 _nav = gem.balanceOf(address(this));
4383         return mul(_nav, to18ConversionFactor);
4384     }
4385 
4386     // Net Assets per Share [wad]
4387     function nps() public returns (uint256) {
4388         if (total == 0) return WAD;
4389         else return wdiv(nav(), total);
4390     }
4391 
4392     function crop() internal virtual returns (uint256) {
4393         return sub(bonus.balanceOf(address(this)), stock);
4394     }
4395 
4396     function harvest(address from, address to) internal {
4397         if (total > 0) share = add(share, rdiv(crop(), total));
4398 
4399         uint256 last = crops[from];
4400         uint256 curr = rmul(stake[from], share);
4401         if (curr > last) require(bonus.transfer(to, curr - last));
4402         stock = bonus.balanceOf(address(this));
4403     }
4404 
4405     function join(address urn, uint256 val) internal virtual {
4406         harvest(urn, urn);
4407         if (val > 0) {
4408             uint256 wad = wdiv(mul(val, to18ConversionFactor), nps());
4409 
4410             // Overflow check for int256(wad) cast below
4411             // Also enforces a non-zero wad
4412             require(int256(wad) > 0);
4413 
4414             require(gem.transferFrom(msg.sender, address(this), val));
4415             vat.slip(ilk, urn, int256(wad));
4416 
4417             total = add(total, wad);
4418             stake[urn] = add(stake[urn], wad);
4419         }
4420         crops[urn] = rmulup(stake[urn], share);
4421         emit Join(val);
4422     }
4423 
4424     function exit(address guy, uint256 val) internal virtual {
4425         harvest(msg.sender, guy);
4426         if (val > 0) {
4427             uint256 wad = wdivup(mul(val, to18ConversionFactor), nps());
4428 
4429             // Overflow check for int256(wad) cast below
4430             // Also enforces a non-zero wad
4431             require(int256(wad) > 0);
4432 
4433             require(gem.transfer(guy, val));
4434             vat.slip(ilk, msg.sender, -int256(wad));
4435 
4436             total = sub(total, wad);
4437             stake[msg.sender] = sub(stake[msg.sender], wad);
4438         }
4439         crops[msg.sender] = rmulup(stake[msg.sender], share);
4440         emit Exit(val);
4441     }
4442 }
4443 
4444 
4445 // File contracts/B.Protocol/CropJoinAdapter.sol
4446 
4447 
4448 
4449 pragma solidity 0.6.11;
4450 
4451 
4452 // NOTE! - this is not an ERC20 token. transfer is not supported.
4453 contract CropJoinAdapter is CropJoin {
4454     string constant public name = "B.AMM LUSD-ETH";
4455     string constant public symbol = "LUSDETH";
4456     uint constant public decimals = 18;
4457 
4458     event Transfer(address indexed _from, address indexed _to, uint256 _value);
4459 
4460     constructor(address _lqty) public 
4461         CropJoin(address(new Dummy()), "B.AMM", address(new DummyGem()), _lqty)
4462     {
4463     }
4464 
4465     // adapter to cropjoin
4466     function nav() public override returns (uint256) {
4467         return total;
4468     }
4469     
4470     function totalSupply() public view returns (uint256) {
4471         return total;
4472     }
4473 
4474     function balanceOf(address owner) public view returns (uint256 balance) {
4475         balance = stake[owner];
4476     }
4477 
4478     function mint(address to, uint value) virtual internal {
4479         join(to, value);
4480         emit Transfer(address(0), to, value);
4481     }
4482 
4483     function burn(address owner, uint value) virtual internal {
4484         exit(owner, value);
4485         emit Transfer(owner, address(0), value);        
4486     }
4487 }
4488 
4489 contract Dummy {
4490     fallback() external {}
4491 }
4492 
4493 contract DummyGem is Dummy {
4494     function transfer(address, uint) external pure returns(bool) {
4495         return true;
4496     }
4497 
4498     function transferFrom(address, address, uint) external pure returns(bool) {
4499         return true;
4500     }
4501 
4502     function decimals() external pure returns(uint) {
4503         return 18;
4504     } 
4505 }
4506 
4507 
4508 // File contracts/B.Protocol/PriceFormula.sol
4509 
4510 
4511 
4512 pragma solidity 0.6.11;
4513 
4514 contract PriceFormula {
4515     using SafeMath for uint256;
4516 
4517     function getSumFixedPoint(uint x, uint y, uint A) public pure returns(uint) {
4518         if(x == 0 && y == 0) return 0;
4519 
4520         uint sum = x.add(y);
4521 
4522         for(uint i = 0 ; i < 255 ; i++) {
4523             uint dP = sum;
4524             dP = dP.mul(sum) / (x.mul(2)).add(1);
4525             dP = dP.mul(sum) / (y.mul(2)).add(1);
4526 
4527             uint prevSum = sum;
4528 
4529             uint n = (A.mul(2).mul(x.add(y)).add(dP.mul(2))).mul(sum);
4530             uint d = (A.mul(2).sub(1).mul(sum));
4531             sum = n / d.add(dP.mul(3));
4532 
4533             if(sum <= prevSum.add(1) && prevSum <= sum.add(1)) break;
4534         }
4535 
4536         return sum;
4537     }
4538 
4539     function getReturn(uint xQty, uint xBalance, uint yBalance, uint A) public pure returns(uint) {
4540         uint sum = getSumFixedPoint(xBalance, yBalance, A);
4541 
4542         uint c = sum.mul(sum) / (xQty.add(xBalance)).mul(2);
4543         c = c.mul(sum) / A.mul(4);
4544         uint b = (xQty.add(xBalance)).add(sum / A.mul(2));
4545         uint yPrev = 0;
4546         uint y = sum;
4547 
4548         for(uint i = 0 ; i < 255 ; i++) {
4549             yPrev = y;
4550             uint n = (y.mul(y)).add(c);
4551             uint d = y.mul(2).add(b).sub(sum); 
4552             y = n / d;
4553 
4554             if(y <= yPrev.add(1) && yPrev <= y.add(1)) break;
4555         }
4556 
4557         return yBalance.sub(y).sub(1);
4558     }
4559 }
4560 
4561 
4562 // File contracts/Dependencies/AggregatorV3Interface.sol
4563 
4564 
4565 // Code from https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
4566 
4567 pragma solidity 0.6.11;
4568 
4569 interface AggregatorV3Interface {
4570 
4571   function decimals() external view returns (uint8);
4572   function description() external view returns (string memory);
4573   function version() external view returns (uint256);
4574 
4575   // getRoundData and latestRoundData should both raise "No data present"
4576   // if they do not have data to report, instead of returning unset values
4577   // which could be misinterpreted as actual reported values.
4578   function getRoundData(uint80 _roundId)
4579     external
4580     view
4581     returns (
4582       uint80 roundId,
4583       int256 answer,
4584       uint256 startedAt,
4585       uint256 updatedAt,
4586       uint80 answeredInRound
4587     );
4588 
4589   function latestRoundData()
4590     external
4591     view
4592     returns (
4593       uint80 roundId,
4594       int256 answer,
4595       uint256 startedAt,
4596       uint256 updatedAt,
4597       uint80 answeredInRound
4598     );
4599 }
4600 
4601 
4602 // File contracts/B.Protocol/BAMM.sol
4603 
4604 
4605 
4606 pragma solidity 0.6.11;
4607 
4608 
4609 
4610 
4611 
4612 
4613 
4614 
4615 contract BAMM is CropJoinAdapter, PriceFormula, Ownable {
4616     using SafeMath for uint256;
4617 
4618     AggregatorV3Interface public immutable priceAggregator;
4619     AggregatorV3Interface public immutable lusd2UsdPriceAggregator;    
4620     IERC20 public immutable LUSD;
4621     StabilityPool immutable public SP;
4622 
4623     address payable public immutable feePool;
4624     uint public constant MAX_FEE = 100; // 1%
4625     uint public fee = 0; // fee in bps
4626     uint public A = 20;
4627     uint public constant MIN_A = 20;
4628     uint public constant MAX_A = 200;    
4629 
4630     uint public immutable maxDiscount; // max discount in bips
4631 
4632     address public immutable frontEndTag;
4633 
4634     uint constant public PRECISION = 1e18;
4635 
4636     event ParamsSet(uint A, uint fee);
4637     event UserDeposit(address indexed user, uint lusdAmount, uint numShares);
4638     event UserWithdraw(address indexed user, uint lusdAmount, uint ethAmount, uint numShares);
4639     event RebalanceSwap(address indexed user, uint lusdAmount, uint ethAmount, uint timestamp);
4640 
4641     constructor(
4642         address _priceAggregator,
4643         address _lusd2UsdPriceAggregator,
4644         address payable _SP,
4645         address _LUSD,
4646         address _LQTY,
4647         uint _maxDiscount,
4648         address payable _feePool,
4649         address _fronEndTag)
4650         public
4651         CropJoinAdapter(_LQTY)
4652     {
4653         priceAggregator = AggregatorV3Interface(_priceAggregator);
4654         lusd2UsdPriceAggregator = AggregatorV3Interface(_lusd2UsdPriceAggregator);
4655         LUSD = IERC20(_LUSD);
4656         SP = StabilityPool(_SP);
4657 
4658         feePool = _feePool;
4659         maxDiscount = _maxDiscount;
4660         frontEndTag = _fronEndTag;
4661     }
4662 
4663     function setParams(uint _A, uint _fee) external onlyOwner {
4664         require(_fee <= MAX_FEE, "setParams: fee is too big");
4665         require(_A >= MIN_A, "setParams: A too small");
4666         require(_A <= MAX_A, "setParams: A too big");
4667 
4668         fee = _fee;
4669         A = _A;
4670 
4671         emit ParamsSet(_A, _fee);
4672     }
4673 
4674     function fetchPrice() public view returns(uint) {
4675         uint chainlinkDecimals;
4676         uint chainlinkLatestAnswer;
4677         uint chainlinkTimestamp;
4678 
4679         // First, try to get current decimal precision:
4680         try priceAggregator.decimals() returns (uint8 decimals) {
4681             // If call to Chainlink succeeds, record the current decimal precision
4682             chainlinkDecimals = decimals;
4683         } catch {
4684             // If call to Chainlink aggregator reverts, return a zero response with success = false
4685             return 0;
4686         }
4687 
4688         // Secondly, try to get latest price data:
4689         try priceAggregator.latestRoundData() returns
4690         (
4691             uint80 /* roundId */,
4692             int256 answer,
4693             uint256 /* startedAt */,
4694             uint256 timestamp,
4695             uint80 /* answeredInRound */
4696         )
4697         {
4698             // If call to Chainlink succeeds, return the response and success = true
4699             chainlinkLatestAnswer = uint(answer);
4700             chainlinkTimestamp = timestamp;
4701         } catch {
4702             // If call to Chainlink aggregator reverts, return a zero response with success = false
4703             return 0;
4704         }
4705 
4706         if(chainlinkTimestamp + 1 hours < now) return 0; // price is down
4707 
4708         uint chainlinkFactor = 10 ** chainlinkDecimals;
4709         return chainlinkLatestAnswer.mul(PRECISION) / chainlinkFactor;
4710     }
4711 
4712     function deposit(uint lusdAmount) external {        
4713         // update share
4714         uint lusdValue = SP.getCompoundedLUSDDeposit(address(this));
4715         uint ethValue = SP.getDepositorETHGain(address(this)).add(address(this).balance);
4716 
4717         uint price = fetchPrice();
4718         require(ethValue == 0 || price > 0, "deposit: chainlink is down");
4719 
4720         uint totalValue = lusdValue.add(ethValue.mul(price) / PRECISION);
4721 
4722         // this is in theory not reachable. if it is, better halt deposits
4723         // the condition is equivalent to: (totalValue = 0) ==> (total = 0)
4724         require(totalValue > 0 || total == 0, "deposit: system is rekt");
4725 
4726         uint newShare = PRECISION;
4727         if(total > 0) newShare = total.mul(lusdAmount) / totalValue;
4728 
4729         // deposit
4730         require(LUSD.transferFrom(msg.sender, address(this), lusdAmount), "deposit: transferFrom failed");
4731         SP.provideToSP(lusdAmount, frontEndTag);
4732 
4733         // update LP token
4734         mint(msg.sender, newShare);
4735 
4736         emit UserDeposit(msg.sender, lusdAmount, newShare);        
4737     }
4738 
4739     function withdraw(uint numShares) external {
4740         uint lusdValue = SP.getCompoundedLUSDDeposit(address(this));
4741         uint ethValue = SP.getDepositorETHGain(address(this)).add(address(this).balance);
4742 
4743         uint lusdAmount = lusdValue.mul(numShares).div(total);
4744         uint ethAmount = ethValue.mul(numShares).div(total);
4745 
4746         // this withdraws lusd, lqty, and eth
4747         SP.withdrawFromSP(lusdAmount);
4748 
4749         // update LP token
4750         burn(msg.sender, numShares);
4751 
4752         // send lusd and eth
4753         if(lusdAmount > 0) LUSD.transfer(msg.sender, lusdAmount);
4754         if(ethAmount > 0) {
4755             (bool success, ) = msg.sender.call{ value: ethAmount }(""); // re-entry is fine here
4756             require(success, "withdraw: sending ETH failed");
4757         }
4758 
4759         emit UserWithdraw(msg.sender, lusdAmount, ethAmount, numShares);            
4760     }
4761 
4762     function addBps(uint n, int bps) internal pure returns(uint) {
4763         require(bps <= 10000, "reduceBps: bps exceeds max");
4764         require(bps >= -10000, "reduceBps: bps exceeds min");
4765 
4766         return n.mul(uint(10000 + bps)) / 10000;
4767     }
4768 
4769     function compensateForLusdDeviation(uint ethAmount) public view returns(uint newEthAmount) {
4770         uint chainlinkDecimals;
4771         uint chainlinkLatestAnswer;
4772 
4773         // get current decimal precision:
4774         chainlinkDecimals = lusd2UsdPriceAggregator.decimals();
4775 
4776         // Secondly, try to get latest price data:
4777         (,int256 answer,,,) = lusd2UsdPriceAggregator.latestRoundData();
4778         chainlinkLatestAnswer = uint(answer);
4779 
4780         // adjust only if 1 LUSD > 1 USDC. If LUSD < USD, then we give a discount, and rebalance will happen anw
4781         if(chainlinkLatestAnswer > 10 ** chainlinkDecimals ) {
4782             newEthAmount = ethAmount.mul(chainlinkLatestAnswer) / (10 ** chainlinkDecimals);
4783         }
4784         else newEthAmount = ethAmount;
4785     }
4786 
4787     function getSwapEthAmount(uint lusdQty) public view returns(uint ethAmount, uint feeLusdAmount) {
4788         uint lusdBalance = SP.getCompoundedLUSDDeposit(address(this));
4789         uint ethBalance  = SP.getDepositorETHGain(address(this)).add(address(this).balance);
4790 
4791         uint eth2usdPrice = fetchPrice();
4792         if(eth2usdPrice == 0) return (0, 0); // chainlink is down
4793 
4794         uint ethUsdValue = ethBalance.mul(eth2usdPrice) / PRECISION;
4795         uint maxReturn = addBps(lusdQty.mul(PRECISION) / eth2usdPrice, int(maxDiscount));
4796 
4797         uint xQty = lusdQty;
4798         uint xBalance = lusdBalance;
4799         uint yBalance = lusdBalance.add(ethUsdValue.mul(2));
4800         
4801         uint usdReturn = getReturn(xQty, xBalance, yBalance, A);
4802         uint basicEthReturn = usdReturn.mul(PRECISION) / eth2usdPrice;
4803 
4804         basicEthReturn = compensateForLusdDeviation(basicEthReturn);
4805 
4806         if(ethBalance < basicEthReturn) basicEthReturn = ethBalance; // cannot give more than balance 
4807         if(maxReturn < basicEthReturn) basicEthReturn = maxReturn;
4808 
4809         ethAmount = basicEthReturn;
4810         feeLusdAmount = addBps(lusdQty, int(fee)).sub(lusdQty);
4811     }
4812 
4813     // get ETH in return to LUSD
4814     function swap(uint lusdAmount, uint minEthReturn, address payable dest) public returns(uint) {
4815         (uint ethAmount, uint feeAmount) = getSwapEthAmount(lusdAmount);
4816 
4817         require(ethAmount >= minEthReturn, "swap: low return");
4818 
4819         LUSD.transferFrom(msg.sender, address(this), lusdAmount);
4820         SP.provideToSP(lusdAmount.sub(feeAmount), frontEndTag);
4821 
4822         if(feeAmount > 0) LUSD.transfer(feePool, feeAmount);
4823         (bool success, ) = dest.call{ value: ethAmount }(""); // re-entry is fine here
4824         require(success, "swap: sending ETH failed");
4825 
4826         emit RebalanceSwap(msg.sender, lusdAmount, ethAmount, now);
4827 
4828         return ethAmount;
4829     }
4830 
4831     // kyber network reserve compatible function
4832     function trade(
4833         IERC20 /* srcToken */,
4834         uint256 srcAmount,
4835         IERC20 /* destToken */,
4836         address payable destAddress,
4837         uint256 /* conversionRate */,
4838         bool /* validate */
4839     ) external payable returns (bool) {
4840         return swap(srcAmount, 0, destAddress) > 0;
4841     }
4842 
4843     function getConversionRate(
4844         IERC20 /* src */,
4845         IERC20 /* dest */,
4846         uint256 srcQty,
4847         uint256 /* blockNumber */
4848     ) external view returns (uint256) {
4849         (uint ethQty, ) = getSwapEthAmount(srcQty);
4850         return ethQty.mul(PRECISION) / srcQty;
4851     }
4852 
4853     receive() external payable {}
4854 }