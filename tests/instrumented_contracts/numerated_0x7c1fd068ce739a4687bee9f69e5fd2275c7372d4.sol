1 pragma solidity 0.8.2;
2 
3 
4 interface ISavingsContractV2 {
5     // DEPRECATED but still backwards compatible
6     function redeem(uint256 _amount) external returns (uint256 massetReturned);
7 
8     function creditBalances(address) external view returns (uint256); // V1 & V2 (use balanceOf)
9 
10     // --------------------------------------------
11 
12     function depositInterest(uint256 _amount) external; // V1 & V2
13 
14     function depositSavings(uint256 _amount) external returns (uint256 creditsIssued); // V1 & V2
15 
16     function depositSavings(uint256 _amount, address _beneficiary)
17         external
18         returns (uint256 creditsIssued); // V2
19 
20     function redeemCredits(uint256 _amount) external returns (uint256 underlyingReturned); // V2
21 
22     function redeemUnderlying(uint256 _amount) external returns (uint256 creditsBurned); // V2
23 
24     function exchangeRate() external view returns (uint256); // V1 & V2
25 
26     function balanceOfUnderlying(address _user) external view returns (uint256 balance); // V2
27 
28     function underlyingToCredits(uint256 _credits) external view returns (uint256 underlying); // V2
29 
30     function creditsToUnderlying(uint256 _underlying) external view returns (uint256 credits); // V2
31 }
32 
33 struct BassetPersonal {
34     // Address of the bAsset
35     address addr;
36     // Address of the bAsset
37     address integrator;
38     // An ERC20 can charge transfer fee, for example USDT, DGX tokens.
39     bool hasTxFee; // takes a byte in storage
40     // Status of the bAsset
41     BassetStatus status;
42 }
43 
44 struct BassetData {
45     // 1 Basset * ratio / ratioScale == x Masset (relative value)
46     // If ratio == 10e8 then 1 bAsset = 10 mAssets
47     // A ratio is divised as 10^(18-tokenDecimals) * measurementMultiple(relative value of 1 base unit)
48     uint128 ratio;
49     // Amount of the Basset that is held in Collateral
50     uint128 vaultBalance;
51 }
52 
53 abstract contract IMasset {
54     // Mint
55     function mint(
56         address _input,
57         uint256 _inputQuantity,
58         uint256 _minOutputQuantity,
59         address _recipient
60     ) external virtual returns (uint256 mintOutput);
61 
62     function mintMulti(
63         address[] calldata _inputs,
64         uint256[] calldata _inputQuantities,
65         uint256 _minOutputQuantity,
66         address _recipient
67     ) external virtual returns (uint256 mintOutput);
68 
69     function getMintOutput(address _input, uint256 _inputQuantity)
70         external
71         view
72         virtual
73         returns (uint256 mintOutput);
74 
75     function getMintMultiOutput(address[] calldata _inputs, uint256[] calldata _inputQuantities)
76         external
77         view
78         virtual
79         returns (uint256 mintOutput);
80 
81     // Swaps
82     function swap(
83         address _input,
84         address _output,
85         uint256 _inputQuantity,
86         uint256 _minOutputQuantity,
87         address _recipient
88     ) external virtual returns (uint256 swapOutput);
89 
90     function getSwapOutput(
91         address _input,
92         address _output,
93         uint256 _inputQuantity
94     ) external view virtual returns (uint256 swapOutput);
95 
96     // Redemption
97     function redeem(
98         address _output,
99         uint256 _mAssetQuantity,
100         uint256 _minOutputQuantity,
101         address _recipient
102     ) external virtual returns (uint256 outputQuantity);
103 
104     function redeemMasset(
105         uint256 _mAssetQuantity,
106         uint256[] calldata _minOutputQuantities,
107         address _recipient
108     ) external virtual returns (uint256[] memory outputQuantities);
109 
110     function redeemExactBassets(
111         address[] calldata _outputs,
112         uint256[] calldata _outputQuantities,
113         uint256 _maxMassetQuantity,
114         address _recipient
115     ) external virtual returns (uint256 mAssetRedeemed);
116 
117     function getRedeemOutput(address _output, uint256 _mAssetQuantity)
118         external
119         view
120         virtual
121         returns (uint256 bAssetOutput);
122 
123     function getRedeemExactBassetsOutput(
124         address[] calldata _outputs,
125         uint256[] calldata _outputQuantities
126     ) external view virtual returns (uint256 mAssetAmount);
127 
128     // Views
129     function getBasket() external view virtual returns (bool, bool);
130 
131     function getBasset(address _token)
132         external
133         view
134         virtual
135         returns (BassetPersonal memory personal, BassetData memory data);
136 
137     function getBassets()
138         external
139         view
140         virtual
141         returns (BassetPersonal[] memory personal, BassetData[] memory data);
142 
143     function bAssetIndexes(address) external view virtual returns (uint8);
144 
145     // SavingsManager
146     function collectInterest() external virtual returns (uint256 swapFeesGained, uint256 newSupply);
147 
148     function collectPlatformInterest()
149         external
150         virtual
151         returns (uint256 mintAmount, uint256 newSupply);
152 
153     // Admin
154     function setCacheSize(uint256 _cacheSize) external virtual;
155 
156     function upgradeForgeValidator(address _newForgeValidator) external virtual;
157 
158     function setFees(uint256 _swapFee, uint256 _redemptionFee) external virtual;
159 
160     function setTransferFeesFlag(address _bAsset, bool _flag) external virtual;
161 
162     function migrateBassets(address[] calldata _bAssets, address _newIntegration) external virtual;
163 }
164 
165 // Status of the Basset - has it broken its peg?
166 enum BassetStatus {
167     Default,
168     Normal,
169     BrokenBelowPeg,
170     BrokenAbovePeg,
171     Blacklisted,
172     Liquidating,
173     Liquidated,
174     Failed
175 }
176 
177 struct BasketState {
178     bool undergoingRecol;
179     bool failed;
180 }
181 
182 struct InvariantConfig {
183     uint256 a;
184     WeightLimits limits;
185 }
186 
187 struct WeightLimits {
188     uint128 min;
189     uint128 max;
190 }
191 
192 struct FeederConfig {
193     uint256 supply;
194     uint256 a;
195     WeightLimits limits;
196 }
197 
198 struct AmpData {
199     uint64 initialA;
200     uint64 targetA;
201     uint64 rampStartTime;
202     uint64 rampEndTime;
203 }
204 
205 struct FeederData {
206     uint256 swapFee;
207     uint256 redemptionFee;
208     uint256 govFee;
209     uint256 pendingFees;
210     uint256 cacheSize;
211     BassetPersonal[] bAssetPersonal;
212     BassetData[] bAssetData;
213     AmpData ampData;
214     WeightLimits weightLimits;
215 }
216 
217 struct AssetData {
218     uint8 idx;
219     uint256 amt;
220     BassetPersonal personal;
221 }
222 
223 struct Asset {
224     uint8 idx;
225     address addr;
226     bool exists;
227 }
228 
229 abstract contract IFeederPool {
230     // Mint
231     function mint(
232         address _input,
233         uint256 _inputQuantity,
234         uint256 _minOutputQuantity,
235         address _recipient
236     ) external virtual returns (uint256 mintOutput);
237 
238     function mintMulti(
239         address[] calldata _inputs,
240         uint256[] calldata _inputQuantities,
241         uint256 _minOutputQuantity,
242         address _recipient
243     ) external virtual returns (uint256 mintOutput);
244 
245     function getMintOutput(address _input, uint256 _inputQuantity)
246         external
247         view
248         virtual
249         returns (uint256 mintOutput);
250 
251     function getMintMultiOutput(address[] calldata _inputs, uint256[] calldata _inputQuantities)
252         external
253         view
254         virtual
255         returns (uint256 mintOutput);
256 
257     // Swaps
258     function swap(
259         address _input,
260         address _output,
261         uint256 _inputQuantity,
262         uint256 _minOutputQuantity,
263         address _recipient
264     ) external virtual returns (uint256 swapOutput);
265 
266     function getSwapOutput(
267         address _input,
268         address _output,
269         uint256 _inputQuantity
270     ) external view virtual returns (uint256 swapOutput);
271 
272     // Redemption
273     function redeem(
274         address _output,
275         uint256 _fpTokenQuantity,
276         uint256 _minOutputQuantity,
277         address _recipient
278     ) external virtual returns (uint256 outputQuantity);
279 
280     function redeemProportionately(
281         uint256 _fpTokenQuantity,
282         uint256[] calldata _minOutputQuantities,
283         address _recipient
284     ) external virtual returns (uint256[] memory outputQuantities);
285 
286     function redeemExactBassets(
287         address[] calldata _outputs,
288         uint256[] calldata _outputQuantities,
289         uint256 _maxMassetQuantity,
290         address _recipient
291     ) external virtual returns (uint256 mAssetRedeemed);
292 
293     function getRedeemOutput(address _output, uint256 _fpTokenQuantity)
294         external
295         view
296         virtual
297         returns (uint256 bAssetOutput);
298 
299     function getRedeemExactBassetsOutput(
300         address[] calldata _outputs,
301         uint256[] calldata _outputQuantities
302     ) external view virtual returns (uint256 mAssetAmount);
303 
304     // Views
305     function mAsset() external view virtual returns (address);
306 
307     function getPrice() public view virtual returns (uint256 price, uint256 k);
308 
309     function getConfig() external view virtual returns (FeederConfig memory config);
310 
311     function getBasset(address _token)
312         external
313         view
314         virtual
315         returns (BassetPersonal memory personal, BassetData memory data);
316 
317     function getBassets()
318         external
319         view
320         virtual
321         returns (BassetPersonal[] memory personal, BassetData[] memory data);
322 
323     // SavingsManager
324     function collectPlatformInterest()
325         external
326         virtual
327         returns (uint256 mintAmount, uint256 newSupply);
328 
329     function collectPendingFees() external virtual;
330 }
331 
332 interface IERC20 {
333     /**
334      * @dev Returns the amount of tokens in existence.
335      */
336     function totalSupply() external view returns (uint256);
337 
338     /**
339      * @dev Returns the amount of tokens owned by `account`.
340      */
341     function balanceOf(address account) external view returns (uint256);
342 
343     /**
344      * @dev Moves `amount` tokens from the caller's account to `recipient`.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * Emits a {Transfer} event.
349      */
350     function transfer(address recipient, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Returns the remaining number of tokens that `spender` will be
354      * allowed to spend on behalf of `owner` through {transferFrom}. This is
355      * zero by default.
356      *
357      * This value changes when {approve} or {transferFrom} are called.
358      */
359     function allowance(address owner, address spender) external view returns (uint256);
360 
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * IMPORTANT: Beware that changing an allowance with this method brings the risk
367      * that someone may use both the old and the new allowance by unfortunate
368      * transaction ordering. One possible solution to mitigate this race
369      * condition is to first reduce the spender's allowance to 0 and set the
370      * desired value afterwards:
371      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
372      *
373      * Emits an {Approval} event.
374      */
375     function approve(address spender, uint256 amount) external returns (bool);
376 
377     /**
378      * @dev Moves `amount` tokens from `sender` to `recipient` using the
379      * allowance mechanism. `amount` is then deducted from the caller's
380      * allowance.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Emitted when `value` tokens are moved from one account (`from`) to
390      * another (`to`).
391      *
392      * Note that `value` may be zero.
393      */
394     event Transfer(address indexed from, address indexed to, uint256 value);
395 
396     /**
397      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
398      * a call to {approve}. `value` is the new allowance.
399      */
400     event Approval(address indexed owner, address indexed spender, uint256 value);
401 }
402 
403 interface IBoostedVaultWithLockup {
404     /**
405      * @dev Stakes a given amount of the StakingToken for the sender
406      * @param _amount Units of StakingToken
407      */
408     function stake(uint256 _amount) external;
409 
410     /**
411      * @dev Stakes a given amount of the StakingToken for a given beneficiary
412      * @param _beneficiary Staked tokens are credited to this address
413      * @param _amount      Units of StakingToken
414      */
415     function stake(address _beneficiary, uint256 _amount) external;
416 
417     /**
418      * @dev Withdraws stake from pool and claims any unlocked rewards.
419      * Note, this function is costly - the args for _claimRewards
420      * should be determined off chain and then passed to other fn
421      */
422     function exit() external;
423 
424     /**
425      * @dev Withdraws stake from pool and claims any unlocked rewards.
426      * @param _first    Index of the first array element to claim
427      * @param _last     Index of the last array element to claim
428      */
429     function exit(uint256 _first, uint256 _last) external;
430 
431     /**
432      * @dev Withdraws given stake amount from the pool
433      * @param _amount Units of the staked token to withdraw
434      */
435     function withdraw(uint256 _amount) external;
436 
437     /**
438      * @dev Claims only the tokens that have been immediately unlocked, not including
439      * those that are in the lockers.
440      */
441     function claimReward() external;
442 
443     /**
444      * @dev Claims all unlocked rewards for sender.
445      * Note, this function is costly - the args for _claimRewards
446      * should be determined off chain and then passed to other fn
447      */
448     function claimRewards() external;
449 
450     /**
451      * @dev Claims all unlocked rewards for sender. Both immediately unlocked
452      * rewards and also locked rewards past their time lock.
453      * @param _first    Index of the first array element to claim
454      * @param _last     Index of the last array element to claim
455      */
456     function claimRewards(uint256 _first, uint256 _last) external;
457 
458     /**
459      * @dev Pokes a given account to reset the boost
460      */
461     function pokeBoost(address _account) external;
462 
463     /**
464      * @dev Gets the last applicable timestamp for this reward period
465      */
466     function lastTimeRewardApplicable() external view returns (uint256);
467 
468     /**
469      * @dev Calculates the amount of unclaimed rewards per token since last update,
470      * and sums with stored to give the new cumulative reward per token
471      * @return 'Reward' per staked token
472      */
473     function rewardPerToken() external view returns (uint256);
474 
475     /**
476      * @dev Returned the units of IMMEDIATELY claimable rewards a user has to receive. Note - this
477      * does NOT include the majority of rewards which will be locked up.
478      * @param _account User address
479      * @return Total reward amount earned
480      */
481     function earned(address _account) external view returns (uint256);
482 
483     /**
484      * @dev Calculates all unclaimed reward data, finding both immediately unlocked rewards
485      * and those that have passed their time lock.
486      * @param _account User address
487      * @return amount Total units of unclaimed rewards
488      * @return first Index of the first userReward that has unlocked
489      * @return last Index of the last userReward that has unlocked
490      */
491     function unclaimedRewards(address _account)
492         external
493         view
494         returns (
495             uint256 amount,
496             uint256 first,
497             uint256 last
498         );
499 }
500 
501 
502 /*
503  * @dev Provides information about the current execution context, including the
504  * sender of the transaction and its data. While these are generally available
505  * via msg.sender and msg.data, they should not be accessed in such a direct
506  * manner, since when dealing with meta-transactions the account sending and
507  * paying for execution may not be the actual sender (as far as an application
508  * is concerned).
509  *
510  * This contract is only required for intermediate, library-like contracts.
511  */
512 abstract contract Context {
513     function _msgSender() internal view virtual returns (address) {
514         return msg.sender;
515     }
516 
517     function _msgData() internal view virtual returns (bytes calldata) {
518         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
519         return msg.data;
520     }
521 }
522 
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor () {
532         address msgSender = _msgSender();
533         _owner = msgSender;
534         emit OwnershipTransferred(address(0), msgSender);
535     }
536 
537     /**
538      * @dev Returns the address of the current owner.
539      */
540     function owner() public view virtual returns (address) {
541         return _owner;
542     }
543 
544     /**
545      * @dev Throws if called by any account other than the owner.
546      */
547     modifier onlyOwner() {
548         require(owner() == _msgSender(), "Ownable: caller is not the owner");
549         _;
550     }
551 
552     /**
553      * @dev Leaves the contract without owner. It will not be possible to call
554      * `onlyOwner` functions anymore. Can only be called by the current owner.
555      *
556      * NOTE: Renouncing ownership will leave the contract without an owner,
557      * thereby removing any functionality that is only available to the owner.
558      */
559     function renounceOwnership() public virtual onlyOwner {
560         emit OwnershipTransferred(_owner, address(0));
561         _owner = address(0);
562     }
563 
564     /**
565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
566      * Can only be called by the current owner.
567      */
568     function transferOwnership(address newOwner) public virtual onlyOwner {
569         require(newOwner != address(0), "Ownable: new owner is the zero address");
570         emit OwnershipTransferred(_owner, newOwner);
571         _owner = newOwner;
572     }
573 }
574 
575 /**
576  * @dev Interface of the ERC20 standard as defined in the EIP.
577  */
578 
579 /**
580  * @dev Collection of functions related to the address type
581  */
582 library Address {
583     /**
584      * @dev Returns true if `account` is a contract.
585      *
586      * [IMPORTANT]
587      * ====
588      * It is unsafe to assume that an address for which this function returns
589      * false is an externally-owned account (EOA) and not a contract.
590      *
591      * Among others, `isContract` will return false for the following
592      * types of addresses:
593      *
594      *  - an externally-owned account
595      *  - a contract in construction
596      *  - an address where a contract will be created
597      *  - an address where a contract lived, but was destroyed
598      * ====
599      */
600     function isContract(address account) internal view returns (bool) {
601         // This method relies on extcodesize, which returns 0 for contracts in
602         // construction, since the code is only stored at the end of the
603         // constructor execution.
604 
605         uint256 size;
606         // solhint-disable-next-line no-inline-assembly
607         assembly { size := extcodesize(account) }
608         return size > 0;
609     }
610 
611     /**
612      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
613      * `recipient`, forwarding all available gas and reverting on errors.
614      *
615      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
616      * of certain opcodes, possibly making contracts go over the 2300 gas limit
617      * imposed by `transfer`, making them unable to receive funds via
618      * `transfer`. {sendValue} removes this limitation.
619      *
620      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
621      *
622      * IMPORTANT: because control is transferred to `recipient`, care must be
623      * taken to not create reentrancy vulnerabilities. Consider using
624      * {ReentrancyGuard} or the
625      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
626      */
627     function sendValue(address payable recipient, uint256 amount) internal {
628         require(address(this).balance >= amount, "Address: insufficient balance");
629 
630         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
631         (bool success, ) = recipient.call{ value: amount }("");
632         require(success, "Address: unable to send value, recipient may have reverted");
633     }
634 
635     /**
636      * @dev Performs a Solidity function call using a low level `call`. A
637      * plain`call` is an unsafe replacement for a function call: use this
638      * function instead.
639      *
640      * If `target` reverts with a revert reason, it is bubbled up by this
641      * function (like regular Solidity function calls).
642      *
643      * Returns the raw returned data. To convert to the expected return value,
644      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
645      *
646      * Requirements:
647      *
648      * - `target` must be a contract.
649      * - calling `target` with `data` must not revert.
650      *
651      * _Available since v3.1._
652      */
653     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
654       return functionCall(target, data, "Address: low-level call failed");
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
659      * `errorMessage` as a fallback revert reason when `target` reverts.
660      *
661      * _Available since v3.1._
662      */
663     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
664         return functionCallWithValue(target, data, 0, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but also transferring `value` wei to `target`.
670      *
671      * Requirements:
672      *
673      * - the calling contract must have an ETH balance of at least `value`.
674      * - the called Solidity function must be `payable`.
675      *
676      * _Available since v3.1._
677      */
678     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
679         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
684      * with `errorMessage` as a fallback revert reason when `target` reverts.
685      *
686      * _Available since v3.1._
687      */
688     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
689         require(address(this).balance >= value, "Address: insufficient balance for call");
690         require(isContract(target), "Address: call to non-contract");
691 
692         // solhint-disable-next-line avoid-low-level-calls
693         (bool success, bytes memory returndata) = target.call{ value: value }(data);
694         return _verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but performing a static call.
700      *
701      * _Available since v3.3._
702      */
703     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
704         return functionStaticCall(target, data, "Address: low-level static call failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
709      * but performing a static call.
710      *
711      * _Available since v3.3._
712      */
713     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
714         require(isContract(target), "Address: static call to non-contract");
715 
716         // solhint-disable-next-line avoid-low-level-calls
717         (bool success, bytes memory returndata) = target.staticcall(data);
718         return _verifyCallResult(success, returndata, errorMessage);
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
723      * but performing a delegate call.
724      *
725      * _Available since v3.4._
726      */
727     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
728         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
733      * but performing a delegate call.
734      *
735      * _Available since v3.4._
736      */
737     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
738         require(isContract(target), "Address: delegate call to non-contract");
739 
740         // solhint-disable-next-line avoid-low-level-calls
741         (bool success, bytes memory returndata) = target.delegatecall(data);
742         return _verifyCallResult(success, returndata, errorMessage);
743     }
744 
745     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
746         if (success) {
747             return returndata;
748         } else {
749             // Look for revert reason and bubble it up if present
750             if (returndata.length > 0) {
751                 // The easiest way to bubble the revert reason is using memory via assembly
752 
753                 // solhint-disable-next-line no-inline-assembly
754                 assembly {
755                     let returndata_size := mload(returndata)
756                     revert(add(32, returndata), returndata_size)
757                 }
758             } else {
759                 revert(errorMessage);
760             }
761         }
762     }
763 }
764 
765 library SafeERC20 {
766     using Address for address;
767 
768     function safeTransfer(IERC20 token, address to, uint256 value) internal {
769         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
770     }
771 
772     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
773         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
774     }
775 
776     /**
777      * @dev Deprecated. This function has issues similar to the ones found in
778      * {IERC20-approve}, and its usage is discouraged.
779      *
780      * Whenever possible, use {safeIncreaseAllowance} and
781      * {safeDecreaseAllowance} instead.
782      */
783     function safeApprove(IERC20 token, address spender, uint256 value) internal {
784         // safeApprove should only be called when setting an initial allowance,
785         // or when resetting it to zero. To increase and decrease it, use
786         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
787         // solhint-disable-next-line max-line-length
788         require((value == 0) || (token.allowance(address(this), spender) == 0),
789             "SafeERC20: approve from non-zero to non-zero allowance"
790         );
791         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
792     }
793 
794     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
795         uint256 newAllowance = token.allowance(address(this), spender) + value;
796         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
797     }
798 
799     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
800         unchecked {
801             uint256 oldAllowance = token.allowance(address(this), spender);
802             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
803             uint256 newAllowance = oldAllowance - value;
804             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
805         }
806     }
807 
808     /**
809      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
810      * on the return value: the return value is optional (but if data is returned, it must not be false).
811      * @param token The token targeted by the call.
812      * @param data The call data (encoded using abi.encode or one of its variants).
813      */
814     function _callOptionalReturn(IERC20 token, bytes memory data) private {
815         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
816         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
817         // the target address contains contract code and also asserts for success in the low-level call.
818 
819         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
820         if (returndata.length > 0) { // Return data is optional
821             // solhint-disable-next-line max-line-length
822             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
823         }
824     }
825 }
826 
827 // FLOWS
828 // 0 - fAsset/mAsset/mpAsset    -> FeederPool BoostedVault
829 // 1 - fAssets/mAssets/mpAssets -> FeederPool BoostedVault
830 contract FeederWrapper is Ownable {
831     using SafeERC20 for IERC20;
832 
833     /**
834      * @dev 0. fAsset/mAsset/mpAsset -> FeederPool BoostedVault
835      * @param  _feeder             FeederPool address
836      * @param  _vault              BoostedVault address (with stakingToken of `_feeder`)
837      * @param  _input              Input address; fAsset, mAsset or mpAsset
838      * @param  _inputQuantity      Quantity of input sent
839      * @param  _minOutputQuantity  Min amount of fpToken to be minted and staked
840      */
841     function mintAndStake(
842         address _feeder,
843         address _vault,
844         address _input,
845         uint256 _inputQuantity,
846         uint256 _minOutputQuantity
847     ) external {
848         // 0. Transfer the asset here
849         IERC20(_input).safeTransferFrom(msg.sender, address(this), _inputQuantity);
850 
851         // 1. Mint the fpToken and transfer here
852         uint256 fpTokenAmt =
853             IFeederPool(_feeder).mint(_input, _inputQuantity, _minOutputQuantity, address(this));
854 
855         // 2. Stake the fpToken in the BoostedVault on behalf of sender
856         IBoostedVaultWithLockup(_vault).stake(msg.sender, fpTokenAmt);
857     }
858 
859     /**
860      * @dev 1. fAssets/mAssets/mpAssets -> FeederPool BoostedVault
861      * @param _feeder             FeederPool address
862      * @param _vault              BoostedVault address (with stakingToken of `_feeder`)
863      * @param _inputs             Input addresses; fAsset, mAsset or mpAsset
864      * @param _inputQuantities    Quantity of input sent
865      * @param _minOutputQuantity  Min amount of fpToken to be minted and staked
866      */
867     function mintMultiAndStake(
868         address _feeder,
869         address _vault,
870         address[] calldata _inputs,
871         uint256[] calldata _inputQuantities,
872         uint256 _minOutputQuantity
873     ) external {
874         require(_inputs.length == _inputQuantities.length, "Mismatching inputs");
875 
876         // 0. Transfer the assets here
877         for (uint256 i = 0; i < _inputs.length; i++) {
878             IERC20(_inputs[i]).safeTransferFrom(msg.sender, address(this), _inputQuantities[i]);
879         }
880 
881         // 1. Mint the fpToken and transfer here
882         uint256 fpTokenAmt =
883             IFeederPool(_feeder).mintMulti(
884                 _inputs,
885                 _inputQuantities,
886                 _minOutputQuantity,
887                 address(this)
888             );
889 
890         // 2. Stake the fpToken in the BoostedVault on behalf of sender
891         IBoostedVaultWithLockup(_vault).stake(msg.sender, fpTokenAmt);
892     }
893 
894     /**
895      * @dev Approve vault and multiple assets
896      */
897     function approve(
898         address _feeder,
899         address _vault,
900         address[] calldata _assets
901     ) external onlyOwner {
902         _approve(_feeder, _vault);
903         _approve(_assets, _feeder);
904     }
905 
906     /**
907      * @dev Approve one token/spender
908      */
909     function approve(address _token, address _spender) external onlyOwner {
910         _approve(_token, _spender);
911     }
912 
913     /**
914      * @dev Approve multiple tokens/one spender
915      */
916     function approve(address[] calldata _tokens, address _spender) external onlyOwner {
917         _approve(_tokens, _spender);
918     }
919 
920     function _approve(address _token, address _spender) internal {
921         require(_spender != address(0), "Invalid spender");
922         require(_token != address(0), "Invalid token");
923         IERC20(_token).safeApprove(_spender, 2**256 - 1);
924     }
925 
926     function _approve(address[] calldata _tokens, address _spender) internal {
927         require(_spender != address(0), "Invalid spender");
928         for (uint256 i = 0; i < _tokens.length; i++) {
929             require(_tokens[i] != address(0), "Invalid token");
930             IERC20(_tokens[i]).safeApprove(_spender, 2**256 - 1);
931         }
932     }
933 }