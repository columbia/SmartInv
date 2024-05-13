1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {ERC20} from "solmate/tokens/ERC20.sol";
5 import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
6 import {Errors} from "./libraries/Errors.sol";
7 import {DataTypes} from "./libraries/DataTypes.sol";
8 import {IPirexFees} from "./interfaces/IPirexFees.sol";
9 import {PirexEthValidators} from "./PirexEthValidators.sol";
10 
11 /**
12  * @title  Main contract for handling interactions with pxETH
13  * @notice This contract manages various interactions with pxETH, such as deposits, redemptions, and fee adjustments.
14  * @dev    This contract inherits from PirexEthValidators and utilizes SafeTransferLib for ERC20 token transfers.
15  * @author redactedcartel.finance
16  */
17 contract PirexEth is PirexEthValidators {
18     /**
19      * @notice Smart contract uses the SafeTransferLib library for secure ERC20 token transfers.
20      * @dev    The SafeTransferLib library provides enhanced safety checks and error handling for ERC20 token transfers,
21      *         reducing the risk of common vulnerabilities such as reentrancy attacks. By using this library,
22      *         the smart contract ensures safer and more reliable interactions with ERC20 tokens.
23      */
24     using SafeTransferLib for ERC20;
25 
26     /**
27      * @notice Immutable reference to the Pirex fee repository and distribution contract.
28      * @dev    The `pirexFees` variable holds the address of the Pirex fee repository and distribution contract (IPirexFees).
29      *         This contract is responsible for managing and distributing fees collected within the Pirex ecosystem.
30      *         As an immutable variable, its value is set at deployment and cannot be changed thereafter.
31      */
32     IPirexFees public immutable pirexFees;
33 
34     /**
35      * @notice Mapping of maximum fees allowed for different operations in the contract.
36      * @dev    The `maxFees` mapping associates each fee type (Deposit, Redemption, InstantRedemption) with its corresponding maximum fee percentage.
37      *         For example, a value of 200000 represents a maximum fee of 20% (200000 / 1000000).
38      *         Developers can access and modify these maximum fees directly through this public mapping.
39      */
40     mapping(DataTypes.Fees => uint32) public maxFees;
41 
42     /**
43      * @notice Mapping of fees for different operations in the contract.
44      * @dev    The `fees` mapping associates each fee type (Deposit, Redemption, InstantRedemption) with its corresponding fee percentage.
45      *         For example, a value of 5000 represents a 0.5% fee (5000 / 1000000).
46      *         Developers can access and modify these fees directly through this public mapping.
47      */
48     mapping(DataTypes.Fees => uint32) public fees;
49 
50     /**
51      * @notice Current pause state of the contract.
52      * @dev    The `paused` state variable indicates whether certain functionalities of the contract are currently paused or active.
53      *         A value of 1 denotes a paused state, while 0 indicates the contract is not paused.
54      */
55     uint256 public paused;
56 
57     // Events
58     /**
59      * @notice Event emitted when ETH is deposited, minting pxETH, and optionally compounding into the vault.
60      * @dev    Use this event to log details about the deposit, including the caller's address, the receiver's address, whether compounding occurred, the deposited amount, received pxETH amount, and fee amount.
61      * @param  caller          address  indexed  Address of the entity initiating the deposit.
62      * @param  receiver        address  indexed  Address of the receiver of the minted pxETH or apxEth.
63      * @param  shouldCompound  bool     indexed  Boolean indicating whether compounding into the vault occurred.
64      * @param  deposited       uint256           Amount of ETH deposited.
65      * @param  receivedAmount  uint256           Amount of pxETH minted for the receiver.
66      * @param  feeAmount       uint256           Amount of pxETH distributed as fees.
67      */
68     event Deposit(
69         address indexed caller,
70         address indexed receiver,
71         bool indexed shouldCompound,
72         uint256 deposited,
73         uint256 receivedAmount,
74         uint256 feeAmount
75     );
76 
77     /**
78      * @notice Event emitted when a redemption is initiated by burning pxETH in return for upxETH.
79      * @dev    Use this event to log details about the redemption initiation, including the redeemed asset amount, post-fee amount, and the receiver's address.
80      * @param  assets         uint256           Amount of pxETH burnt for the redemption.
81      * @param  postFeeAmount  uint256           Amount of pxETH distributed to the receiver after deducting fees.
82      * @param  receiver       address  indexed  Address of the receiver of the upxETH.
83      */
84     event InitiateRedemption(
85         uint256 assets,
86         uint256 postFeeAmount,
87         address indexed receiver
88     );
89 
90     /**
91      * @notice Event emitted when ETH is redeemed using UpxETH.
92      * @dev    Use this event to log details about the redemption, including the tokenId, redeemed asset amount, and the receiver's address.
93      * @param  tokenId   uint256           Identifier for the redemption batch.
94      * @param  assets    uint256           Amount of ETH redeemed.
95      * @param  receiver  address  indexed  Address of the receiver of the redeemed ETH.
96      */
97     event RedeemWithUpxEth(
98         uint256 tokenId,
99         uint256 assets,
100         address indexed receiver
101     );
102 
103     /**
104      * @notice Event emitted when pxETH is redeemed for ETH with fees.
105      * @dev    Use this event to log details about pxETH redemption, including the redeemed asset amount, post-fee amount, and the receiver's address.
106      * @param  assets         uint256           Amount of pxETH redeemed.
107      * @param  postFeeAmount  uint256           Amount of ETH received by the receiver after deducting fees.
108      * @param  _receiver      address  indexed  Address of the receiver of the redeemed ETH.
109      */
110     event RedeemWithPxEth(
111         uint256 assets,
112         uint256 postFeeAmount,
113         address indexed _receiver
114     );
115 
116     /**
117      * @notice Event emitted when the fee amount for a specific fee type is set.
118      * @dev    Use this event to log changes in the fee amount for a particular fee type, including the fee type and the new fee amount.
119      * @param  f    DataTypes.Fees  indexed (Deposit, Redemption, InstantRedemption) for which the fee amount is being set.
120      * @param  fee  uint32                  New fee amount for the specified fee type.
121      */
122     event SetFee(DataTypes.Fees indexed f, uint32 fee);
123 
124     /**
125      * @notice Event emitted when the maximum fee for a specific fee type is set.
126      * @dev    Use this event to log changes in the maximum fee for a particular fee type, including the fee type and the new maximum fee.
127      * @param  f       DataTypes.Fees  indexed  Deposit, Redemption or InstantRedemption for which the maximum fee is being set.
128      * @param  maxFee  uint32                   New maximum fee amount for the specified fee type.
129      */
130     event SetMaxFee(DataTypes.Fees indexed f, uint32 maxFee);
131 
132     /**
133      * @notice Event emitted when the contract's pause state is toggled.
134      * @dev    Use this event to log changes in the contract's pause state, including the account triggering the change and the new state.
135      * @param  account  address  Address of the entity toggling the pause state.
136      * @param  state    uint256  New pause state: 1 for paused, 0 for not paused.
137      */
138     event SetPauseState(address account, uint256 state);
139 
140     /**
141      * @notice Event emitted when an emergency withdrawal occurs.
142      * @dev    Use this event to log details about emergency withdrawals, including the receiver's address, the token involved, and the withdrawn amount.
143      * @param  receiver address  indexed  Address of the receiver of the emergency withdrawal.
144      * @param  token    address  indexed  Address of the token involved in the emergency withdrawal.
145      * @param  amount   uint256           Amount withdrawn in the emergency withdrawal.
146      */
147     event EmergencyWithdrawal(
148         address indexed receiver,
149         address indexed token,
150         uint256 amount
151     );
152 
153     // Modifiers
154     /**
155      * @dev Use this modifier to check if the contract is not currently paused before allowing function execution.
156      */
157     modifier whenNotPaused() {
158         if (paused == _PAUSED) revert Errors.Paused();
159         _;
160     }
161 
162     /**
163      * @notice Contract constructor to initialize PirexEthValidator with necessary parameters and configurations.
164      * @dev    This constructor sets up the PirexEthValidator contract, configuring key parameters and initializing state variables.
165      * @param  _pxEth                      address  PxETH contract address
166      * @param  _admin                      address  Admin address
167      * @param  _beaconChainDepositContract address  The address of the beacon chain deposit contract
168      * @param  _upxEth                     address  UpxETH address
169      * @param  _depositSize                uint256  Amount of eth to stake
170      * @param  _preDepositAmount           uint256  Amount of ETH for pre-deposit
171      * @param  _pirexFees                  address  PirexFees contract address
172      * @param  _initialDelay               uint48   Delay required to schedule the acceptance
173      *                                              of an access control transfer started
174      */
175     constructor(
176         address _pxEth,
177         address _admin,
178         address _beaconChainDepositContract,
179         address _upxEth,
180         uint256 _depositSize,
181         uint256 _preDepositAmount,
182         address _pirexFees,
183         uint48 _initialDelay
184     )
185         PirexEthValidators(
186             _pxEth,
187             _admin,
188             _beaconChainDepositContract,
189             _upxEth,
190             _depositSize,
191             _preDepositAmount,
192             _initialDelay
193         )
194     {
195         if (_pirexFees == address(0)) revert Errors.ZeroAddress();
196 
197         pirexFees = IPirexFees(_pirexFees);
198         maxFees[DataTypes.Fees.Deposit] = 200_000;
199         maxFees[DataTypes.Fees.Redemption] = 200_000;
200         maxFees[DataTypes.Fees.InstantRedemption] = 200_000;
201         paused = _NOT_PAUSED;
202     }
203 
204     /*//////////////////////////////////////////////////////////////
205                             MUTATIVE FUNCTIONS
206     //////////////////////////////////////////////////////////////*/
207 
208     /**
209      * @notice Set fee
210      * @dev    This function allows an entity with the GOVERNANCE_ROLE to set the fee amount for a specific fee type.
211      * @param  f    DataTypes.Fees  Fee
212      * @param  fee  uint32          Fee amount
213      */
214     function setFee(
215         DataTypes.Fees f,
216         uint32 fee
217     ) external onlyRole(GOVERNANCE_ROLE) {
218         if (fee > maxFees[f]) revert Errors.InvalidFee();
219 
220         fees[f] = fee;
221 
222         emit SetFee(f, fee);
223     }
224 
225     /**
226      * @notice Set Max fee
227      * @dev    This function allows an entity with the GOVERNANCE_ROLE to set the maximum fee for a specific fee type.
228      * @param  f       DataTypes.Fees  Fee
229      * @param  maxFee  uint32          Max fee amount
230      */
231     function setMaxFee(
232         DataTypes.Fees f,
233         uint32 maxFee
234     ) external onlyRole(GOVERNANCE_ROLE) {
235         if (maxFee < fees[f] || maxFee > DENOMINATOR) revert Errors.InvalidMaxFee();
236 
237         maxFees[f] = maxFee;
238 
239         emit SetMaxFee(f, maxFee);
240     }
241 
242     /**
243      * @notice Toggle the contract's pause state
244      * @dev    This function allows an entity with the GOVERNANCE_ROLE to toggle the contract's pause state.
245      */
246     function togglePauseState() external onlyRole(GOVERNANCE_ROLE) {
247         paused = paused == _PAUSED ? _NOT_PAUSED : _PAUSED;
248 
249         emit SetPauseState(msg.sender, paused);
250     }
251 
252     /**
253      * @notice Emergency withdrawal for all ERC20 tokens (except pxETH) and ETH
254      * @dev    This function should only be called under major emergency
255      * @param  receiver address  Receiver address
256      * @param  token    address  Token address
257      * @param  amount   uint256  Token amount
258      */
259     function emergencyWithdraw(
260         address receiver,
261         address token,
262         uint256 amount
263     ) external onlyRole(GOVERNANCE_ROLE) onlyWhenDepositEtherPaused {
264         if (paused == _NOT_PAUSED) revert Errors.NotPaused();
265         if (receiver == address(0)) revert Errors.ZeroAddress();
266         if (amount == 0) revert Errors.ZeroAmount();
267         if (token == address(pxEth)) revert Errors.InvalidToken();
268 
269         if (token == address(0)) {
270             // Update pendingDeposit when affected by emergency withdrawal
271             uint256 remainingBalance = address(this).balance - amount;
272             if (pendingDeposit > remainingBalance) {
273                 pendingDeposit = remainingBalance;
274             }
275 
276             // Handle ETH withdrawal
277             (bool _success, ) = payable(receiver).call{value: amount}("");
278             assert(_success);
279         } else {
280             ERC20(token).safeTransfer(receiver, amount);
281         }
282 
283         emit EmergencyWithdrawal(receiver, token, amount);
284     }
285 
286     /**
287      * @notice Handle pxETH minting in return for ETH deposits
288      * @dev    This function handles the minting of pxETH in return for ETH deposits.
289      * @param  receiver        address  Receiver of the minted pxETH or apxEth
290      * @param  shouldCompound  bool     Whether to also compound into the vault
291      * @return postFeeAmount   uint256  pxETH minted for the receiver
292      * @return feeAmount       uint256  pxETH distributed as fees
293      */
294     function deposit(
295         address receiver,
296         bool shouldCompound
297     )
298         external
299         payable
300         whenNotPaused
301         nonReentrant
302         returns (uint256 postFeeAmount, uint256 feeAmount)
303     {
304         if (msg.value == 0) revert Errors.ZeroAmount();
305         if (receiver == address(0)) revert Errors.ZeroAddress();
306 
307         // Get the pxETH amounts for the receiver and the protocol (fees)
308         (postFeeAmount, feeAmount) = _computeAssetAmounts(
309             DataTypes.Fees.Deposit,
310             msg.value
311         );
312 
313         // Mint pxETH for the receiver (or this contract if compounding) excluding fees
314         _mintPxEth(shouldCompound ? address(this) : receiver, postFeeAmount);
315 
316         if (shouldCompound) {
317             // Deposit pxETH excluding fees into the autocompounding vault
318             // then mint shares (apxETH) for the user
319             autoPxEth.deposit(postFeeAmount, receiver);
320         }
321 
322         // Mint pxETH for fee distribution contract
323         if (feeAmount != 0) {
324             _mintPxEth(address(pirexFees), feeAmount);
325         }
326 
327         // Redirect the deposit to beacon chain deposit contract
328         _addPendingDeposit(msg.value);
329 
330         emit Deposit(
331             msg.sender,
332             receiver,
333             shouldCompound,
334             msg.value,
335             postFeeAmount,
336             feeAmount
337         );
338     }
339 
340     /**
341      * @notice Initiate redemption by burning pxETH in return for upxETH
342      * @dev    This function is used to initiate redemption by burning pxETH and receiving upxETH.
343      * @param  _assets                      uint256  If caller is AutoPxEth then apxETH; pxETH otherwise.
344      * @param  _receiver                    address  Receiver for upxETH.
345      * @param  _shouldTriggerValidatorExit  bool     Whether the initiation should trigger voluntary exit.
346      * @return postFeeAmount                uint256  pxETH burnt for the receiver.
347      * @return feeAmount                    uint256  pxETH distributed as fees.
348      */
349     function initiateRedemption(
350         uint256 _assets,
351         address _receiver,
352         bool _shouldTriggerValidatorExit
353     )
354         external
355         override
356         whenNotPaused
357         nonReentrant
358         returns (uint256 postFeeAmount, uint256 feeAmount)
359     {
360         if (_assets == 0) revert Errors.ZeroAmount();
361         if (_receiver == address(0)) revert Errors.ZeroAddress();
362 
363         uint256 _pxEthAmount;
364 
365         if (msg.sender == address(autoPxEth)) {
366             // The pxETH amount is calculated as per apxETH-ETH ratio during current block
367             _pxEthAmount = autoPxEth.redeem(
368                 _assets,
369                 address(this),
370                 address(this)
371             );
372         } else {
373             _pxEthAmount = _assets;
374         }
375 
376         // Get the pxETH amounts for the receiver and the protocol (fees)
377         (postFeeAmount, feeAmount) = _computeAssetAmounts(
378             DataTypes.Fees.Redemption,
379             _pxEthAmount
380         );
381 
382         uint256 _requiredValidators = (pendingWithdrawal + postFeeAmount) /
383             DEPOSIT_SIZE;
384 
385         if (_shouldTriggerValidatorExit && _requiredValidators == 0)
386             revert Errors.NoValidatorExit();
387 
388         if (_requiredValidators > getStakingValidatorCount())
389             revert Errors.NotEnoughValidators();
390 
391         emit InitiateRedemption(_pxEthAmount, postFeeAmount, _receiver);
392 
393         address _owner = msg.sender == address(autoPxEth)
394             ? address(this)
395             : msg.sender;
396 
397         _burnPxEth(_owner, postFeeAmount);
398 
399         if (feeAmount != 0) {
400             // Allow PirexFees to distribute fees directly from sender
401             pxEth.operatorApprove(_owner, address(pirexFees), feeAmount);
402 
403             // Distribute fees
404             pirexFees.distributeFees(_owner, address(pxEth), feeAmount);
405         }
406 
407         _initiateRedemption(
408             postFeeAmount,
409             _receiver,
410             _shouldTriggerValidatorExit
411         );
412     }
413 
414     /**
415      * @notice Bulk redeem back ETH using a set of upxEth identifiers
416      * @dev    This function allows the bulk redemption of ETH using upxEth tokens.
417      * @param  _tokenIds  uint256[]  Redeem batch identifiers
418      * @param  _amounts   uint256[]  Amounts of ETH to redeem for each identifier
419      * @param  _receiver  address    Address of the ETH receiver
420      */
421     function bulkRedeemWithUpxEth(
422         uint256[] calldata _tokenIds,
423         uint256[] calldata _amounts,
424         address _receiver
425     ) external whenNotPaused nonReentrant {
426         uint256 tLen = _tokenIds.length;
427         uint256 aLen = _amounts.length;
428 
429         if (tLen == 0) revert Errors.EmptyArray();
430         if (tLen != aLen) revert Errors.MismatchedArrayLengths();
431 
432         for (uint256 i; i < tLen; ++i) {
433             _redeemWithUpxEth(_tokenIds[i], _amounts[i], _receiver);
434         }
435     }
436 
437     /**
438      * @notice Redeem back ETH using a single upxEth identifier
439      * @dev    This function allows the redemption of ETH using upxEth tokens.
440      * @param  _tokenId  uint256  Redeem batch identifier
441      * @param  _assets   uint256  Amount of ETH to redeem
442      * @param  _receiver  address  Address of the ETH receiver
443      */
444     function redeemWithUpxEth(
445         uint256 _tokenId,
446         uint256 _assets,
447         address _receiver
448     ) external whenNotPaused nonReentrant {
449         _redeemWithUpxEth(_tokenId, _assets, _receiver);
450     }
451 
452     /**
453      * @notice Instant redeem back ETH using pxETH
454      * @dev    This function burns pxETH, calculates fees, and transfers ETH to the receiver.
455      * @param  _assets        uint256   Amount of pxETH to redeem.
456      * @param  _receiver      address   Address of the ETH receiver.
457      * @return postFeeAmount  uint256   Post-fee amount for the receiver.
458      * @return feeAmount      uinit256  Fee amount sent to the PirexFees.
459      */
460     function instantRedeemWithPxEth(
461         uint256 _assets,
462         address _receiver
463     )
464         external
465         whenNotPaused
466         nonReentrant
467         returns (uint256 postFeeAmount, uint256 feeAmount)
468     {
469         if (_assets == 0) revert Errors.ZeroAmount();
470         if (_receiver == address(0)) revert Errors.ZeroAddress();
471 
472         // Get the pxETH amounts for the receiver and the protocol (fees)
473         (postFeeAmount, feeAmount) = _computeAssetAmounts(
474             DataTypes.Fees.InstantRedemption,
475             _assets
476         );
477 
478         if (postFeeAmount > buffer) revert Errors.NotEnoughBuffer();
479 
480         if (feeAmount != 0) {
481             // Allow PirexFees to distribute fees directly from sender
482             pxEth.operatorApprove(msg.sender, address(pirexFees), feeAmount);
483 
484             // Distribute fees
485             pirexFees.distributeFees(msg.sender, address(pxEth), feeAmount);
486         }
487 
488         _burnPxEth(msg.sender, postFeeAmount);
489         buffer -= postFeeAmount;
490 
491         (bool _success, ) = payable(_receiver).call{value: postFeeAmount}("");
492         assert(_success);
493 
494         emit RedeemWithPxEth(_assets, postFeeAmount, _receiver);
495     }
496 
497     /*//////////////////////////////////////////////////////////////
498                         INTERNAL FUNCTIONS
499     //////////////////////////////////////////////////////////////*/
500 
501     /**
502      * @notice Redeem back ETH using upxEth
503      * @dev    This function allows the redemption of ETH using upxEth tokens.
504      * @param  _tokenId  uint256  Redeem batch identifier
505      * @param  _assets   uint256  Amount of ETH to redeem
506      * @param  _receiver  address  Address of the ETH receiver
507      */
508     function _redeemWithUpxEth(
509         uint256 _tokenId,
510         uint256 _assets,
511         address _receiver
512     ) internal {
513         if (_assets == 0) revert Errors.ZeroAmount();
514         if (_receiver == address(0)) revert Errors.ZeroAddress();
515 
516         DataTypes.ValidatorStatus _validatorStatus = status[
517             batchIdToValidator[_tokenId]
518         ];
519 
520         if (
521             _validatorStatus != DataTypes.ValidatorStatus.Dissolved &&
522             _validatorStatus != DataTypes.ValidatorStatus.Slashed
523         ) {
524             revert Errors.StatusNotDissolvedOrSlashed();
525         }
526 
527         if (outstandingRedemptions < _assets) revert Errors.NotEnoughETH();
528 
529         outstandingRedemptions -= _assets;
530         upxEth.burn(msg.sender, _tokenId, _assets);
531 
532         (bool _success, ) = payable(_receiver).call{value: _assets}("");
533         assert(_success);
534 
535         emit RedeemWithUpxEth(_tokenId, _assets, _receiver);
536     }
537 
538     /**
539      * @dev     This function calculates the post-fee asset amount and fee amount based on the specified fee type and total assets.
540      * @param   f              DataTypes.Fees  representing the fee type.
541      * @param   assets         uint256         Total ETH or pxETH asset amount.
542      * @return  postFeeAmount  uint256         Post-fee asset amount (for mint/burn/claim/etc.).
543      * @return  feeAmount      uint256         Fee amount.
544      */
545     function _computeAssetAmounts(
546         DataTypes.Fees f,
547         uint256 assets
548     ) internal view returns (uint256 postFeeAmount, uint256 feeAmount) {
549         feeAmount = (assets * fees[f]) / DENOMINATOR;
550         postFeeAmount = assets - feeAmount;
551     }
552 }
