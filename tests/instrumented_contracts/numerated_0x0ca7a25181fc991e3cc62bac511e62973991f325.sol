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
501 /**
502  * @dev Interface of the ERC20 standard as defined in the EIP.
503  */
504 
505 /**
506  * @dev Collection of functions related to the address type
507  */
508 library Address {
509     /**
510      * @dev Returns true if `account` is a contract.
511      *
512      * [IMPORTANT]
513      * ====
514      * It is unsafe to assume that an address for which this function returns
515      * false is an externally-owned account (EOA) and not a contract.
516      *
517      * Among others, `isContract` will return false for the following
518      * types of addresses:
519      *
520      *  - an externally-owned account
521      *  - a contract in construction
522      *  - an address where a contract will be created
523      *  - an address where a contract lived, but was destroyed
524      * ====
525      */
526     function isContract(address account) internal view returns (bool) {
527         // This method relies on extcodesize, which returns 0 for contracts in
528         // construction, since the code is only stored at the end of the
529         // constructor execution.
530 
531         uint256 size;
532         // solhint-disable-next-line no-inline-assembly
533         assembly { size := extcodesize(account) }
534         return size > 0;
535     }
536 
537     /**
538      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
539      * `recipient`, forwarding all available gas and reverting on errors.
540      *
541      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
542      * of certain opcodes, possibly making contracts go over the 2300 gas limit
543      * imposed by `transfer`, making them unable to receive funds via
544      * `transfer`. {sendValue} removes this limitation.
545      *
546      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
547      *
548      * IMPORTANT: because control is transferred to `recipient`, care must be
549      * taken to not create reentrancy vulnerabilities. Consider using
550      * {ReentrancyGuard} or the
551      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
552      */
553     function sendValue(address payable recipient, uint256 amount) internal {
554         require(address(this).balance >= amount, "Address: insufficient balance");
555 
556         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
557         (bool success, ) = recipient.call{ value: amount }("");
558         require(success, "Address: unable to send value, recipient may have reverted");
559     }
560 
561     /**
562      * @dev Performs a Solidity function call using a low level `call`. A
563      * plain`call` is an unsafe replacement for a function call: use this
564      * function instead.
565      *
566      * If `target` reverts with a revert reason, it is bubbled up by this
567      * function (like regular Solidity function calls).
568      *
569      * Returns the raw returned data. To convert to the expected return value,
570      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
571      *
572      * Requirements:
573      *
574      * - `target` must be a contract.
575      * - calling `target` with `data` must not revert.
576      *
577      * _Available since v3.1._
578      */
579     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
580       return functionCall(target, data, "Address: low-level call failed");
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
585      * `errorMessage` as a fallback revert reason when `target` reverts.
586      *
587      * _Available since v3.1._
588      */
589     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
590         return functionCallWithValue(target, data, 0, errorMessage);
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
595      * but also transferring `value` wei to `target`.
596      *
597      * Requirements:
598      *
599      * - the calling contract must have an ETH balance of at least `value`.
600      * - the called Solidity function must be `payable`.
601      *
602      * _Available since v3.1._
603      */
604     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
605         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
610      * with `errorMessage` as a fallback revert reason when `target` reverts.
611      *
612      * _Available since v3.1._
613      */
614     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
615         require(address(this).balance >= value, "Address: insufficient balance for call");
616         require(isContract(target), "Address: call to non-contract");
617 
618         // solhint-disable-next-line avoid-low-level-calls
619         (bool success, bytes memory returndata) = target.call{ value: value }(data);
620         return _verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but performing a static call.
626      *
627      * _Available since v3.3._
628      */
629     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
630         return functionStaticCall(target, data, "Address: low-level static call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a static call.
636      *
637      * _Available since v3.3._
638      */
639     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
640         require(isContract(target), "Address: static call to non-contract");
641 
642         // solhint-disable-next-line avoid-low-level-calls
643         (bool success, bytes memory returndata) = target.staticcall(data);
644         return _verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
649      * but performing a delegate call.
650      *
651      * _Available since v3.4._
652      */
653     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
654         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
659      * but performing a delegate call.
660      *
661      * _Available since v3.4._
662      */
663     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         // solhint-disable-next-line avoid-low-level-calls
667         (bool success, bytes memory returndata) = target.delegatecall(data);
668         return _verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
672         if (success) {
673             return returndata;
674         } else {
675             // Look for revert reason and bubble it up if present
676             if (returndata.length > 0) {
677                 // The easiest way to bubble the revert reason is using memory via assembly
678 
679                 // solhint-disable-next-line no-inline-assembly
680                 assembly {
681                     let returndata_size := mload(returndata)
682                     revert(add(32, returndata), returndata_size)
683                 }
684             } else {
685                 revert(errorMessage);
686             }
687         }
688     }
689 }
690 
691 library SafeERC20 {
692     using Address for address;
693 
694     function safeTransfer(IERC20 token, address to, uint256 value) internal {
695         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
696     }
697 
698     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
699         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
700     }
701 
702     /**
703      * @dev Deprecated. This function has issues similar to the ones found in
704      * {IERC20-approve}, and its usage is discouraged.
705      *
706      * Whenever possible, use {safeIncreaseAllowance} and
707      * {safeDecreaseAllowance} instead.
708      */
709     function safeApprove(IERC20 token, address spender, uint256 value) internal {
710         // safeApprove should only be called when setting an initial allowance,
711         // or when resetting it to zero. To increase and decrease it, use
712         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
713         // solhint-disable-next-line max-line-length
714         require((value == 0) || (token.allowance(address(this), spender) == 0),
715             "SafeERC20: approve from non-zero to non-zero allowance"
716         );
717         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
718     }
719 
720     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
721         uint256 newAllowance = token.allowance(address(this), spender) + value;
722         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
723     }
724 
725     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
726         unchecked {
727             uint256 oldAllowance = token.allowance(address(this), spender);
728             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
729             uint256 newAllowance = oldAllowance - value;
730             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
731         }
732     }
733 
734     /**
735      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
736      * on the return value: the return value is optional (but if data is returned, it must not be false).
737      * @param token The token targeted by the call.
738      * @param data The call data (encoded using abi.encode or one of its variants).
739      */
740     function _callOptionalReturn(IERC20 token, bytes memory data) private {
741         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
742         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
743         // the target address contains contract code and also asserts for success in the low-level call.
744 
745         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
746         if (returndata.length > 0) { // Return data is optional
747             // solhint-disable-next-line max-line-length
748             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
749         }
750     }
751 }
752 
753 /*
754  * @dev Provides information about the current execution context, including the
755  * sender of the transaction and its data. While these are generally available
756  * via msg.sender and msg.data, they should not be accessed in such a direct
757  * manner, since when dealing with meta-transactions the account sending and
758  * paying for execution may not be the actual sender (as far as an application
759  * is concerned).
760  *
761  * This contract is only required for intermediate, library-like contracts.
762  */
763 abstract contract Context {
764     function _msgSender() internal view virtual returns (address) {
765         return msg.sender;
766     }
767 
768     function _msgData() internal view virtual returns (bytes calldata) {
769         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
770         return msg.data;
771     }
772 }
773 
774 abstract contract Ownable is Context {
775     address private _owner;
776 
777     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
778 
779     /**
780      * @dev Initializes the contract setting the deployer as the initial owner.
781      */
782     constructor () {
783         address msgSender = _msgSender();
784         _owner = msgSender;
785         emit OwnershipTransferred(address(0), msgSender);
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view virtual returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
800         _;
801     }
802 
803     /**
804      * @dev Leaves the contract without owner. It will not be possible to call
805      * `onlyOwner` functions anymore. Can only be called by the current owner.
806      *
807      * NOTE: Renouncing ownership will leave the contract without an owner,
808      * thereby removing any functionality that is only available to the owner.
809      */
810     function renounceOwnership() public virtual onlyOwner {
811         emit OwnershipTransferred(_owner, address(0));
812         _owner = address(0);
813     }
814 
815     /**
816      * @dev Transfers ownership of the contract to a new account (`newOwner`).
817      * Can only be called by the current owner.
818      */
819     function transferOwnership(address newOwner) public virtual onlyOwner {
820         require(newOwner != address(0), "Ownable: new owner is the zero address");
821         emit OwnershipTransferred(_owner, newOwner);
822         _owner = newOwner;
823     }
824 }
825 
826 interface IUniswapV2Router02 {
827     function swapExactTokensForTokens(
828         uint256 amountIn,
829         uint256 amountOutMin, // calculated off chain
830         address[] calldata path, // also worked out off chain
831         address to,
832         uint256 deadline
833     ) external returns (uint256[] memory amounts);
834 
835     function swapExactETHForTokens(
836         uint256 amountOutMin,
837         address[] calldata path,
838         address to,
839         uint256 deadline
840     ) external payable returns (uint256[] memory amounts);
841 
842     function getAmountsIn(uint256 amountOut, address[] calldata path)
843         external
844         view
845         returns (uint256[] memory amounts);
846 
847     function getAmountsOut(uint256 amountIn, address[] calldata path)
848         external
849         view
850         returns (uint256[] memory amounts);
851 }
852 
853 interface IBasicToken {
854     function decimals() external view returns (uint8);
855 }
856 
857 // FLOWS
858 // 0 - mAsset -> Savings Vault
859 // 1 - bAsset -> Save/Savings Vault via Mint
860 // 2 - fAsset -> Save/Savings Vault via Feeder Pool
861 // 3 - ETH    -> Save/Savings Vault via Uniswap
862 contract SaveWrapper is Ownable {
863     using SafeERC20 for IERC20;
864 
865     /**
866      * @dev 0. Simply saves an mAsset and then into the vault
867      * @param _mAsset   mAsset address
868      * @param _save     Save address
869      * @param _vault    Boosted Savings Vault address
870      * @param _amount   Units of mAsset to deposit to savings
871      */
872     function saveAndStake(
873         address _mAsset,
874         address _save,
875         address _vault,
876         uint256 _amount
877     ) external {
878         require(_mAsset != address(0), "Invalid mAsset");
879         require(_save != address(0), "Invalid save");
880         require(_vault != address(0), "Invalid vault");
881 
882         // 1. Get the input mAsset
883         IERC20(_mAsset).safeTransferFrom(msg.sender, address(this), _amount);
884 
885         // 2. Mint imAsset and stake in vault
886         _saveAndStake(_save, _vault, _amount, true);
887     }
888 
889     /**
890      * @dev 1. Mints an mAsset and then deposits to Save/Savings Vault
891      * @param _mAsset       mAsset address
892      * @param _bAsset       bAsset address
893      * @param _save         Save address
894      * @param _vault        Boosted Savings Vault address
895      * @param _amount       Amount of bAsset to mint with
896      * @param _minOut       Min amount of mAsset to get back
897      * @param _stake        Add the imAsset to the Boosted Savings Vault?
898      */
899     function saveViaMint(
900         address _mAsset,
901         address _save,
902         address _vault,
903         address _bAsset,
904         uint256 _amount,
905         uint256 _minOut,
906         bool _stake
907     ) external {
908         require(_mAsset != address(0), "Invalid mAsset");
909         require(_save != address(0), "Invalid save");
910         require(_vault != address(0), "Invalid vault");
911         require(_bAsset != address(0), "Invalid bAsset");
912 
913         // 1. Get the input bAsset
914         IERC20(_bAsset).safeTransferFrom(msg.sender, address(this), _amount);
915 
916         // 2. Mint
917         uint256 massetsMinted = IMasset(_mAsset).mint(_bAsset, _amount, _minOut, address(this));
918 
919         // 3. Mint imAsset and optionally stake in vault
920         _saveAndStake(_save, _vault, massetsMinted, _stake);
921     }
922 
923     /**
924      * @dev 2. Swaps fAsset for mAsset and then deposits to Save/Savings Vault
925      * @param _mAsset             mAsset address
926      * @param _save               Save address
927      * @param _vault              Boosted Savings Vault address
928      * @param _feeder             Feeder Pool address
929      * @param _fAsset             fAsset address
930      * @param _fAssetQuantity     Quantity of fAsset sent
931      * @param _minOutputQuantity  Min amount of mAsset to be swapped and deposited
932      * @param _stake              Deposit the imAsset in the Savings Vault?
933      */
934     function saveViaSwap(
935         address _mAsset,
936         address _save,
937         address _vault,
938         address _feeder,
939         address _fAsset,
940         uint256 _fAssetQuantity,
941         uint256 _minOutputQuantity,
942         bool _stake
943     ) external {
944         require(_feeder != address(0), "Invalid feeder");
945         require(_mAsset != address(0), "Invalid mAsset");
946         require(_save != address(0), "Invalid save");
947         require(_vault != address(0), "Invalid vault");
948         require(_fAsset != address(0), "Invalid input");
949 
950         // 0. Transfer the fAsset here
951         IERC20(_fAsset).safeTransferFrom(msg.sender, address(this), _fAssetQuantity);
952 
953         // 1. Swap the fAsset for mAsset with the feeder pool
954         uint256 mAssetQuantity =
955             IFeederPool(_feeder).swap(
956                 _fAsset,
957                 _mAsset,
958                 _fAssetQuantity,
959                 _minOutputQuantity,
960                 address(this)
961             );
962 
963         // 2. Deposit the mAsset into Save and optionally stake in the vault
964         _saveAndStake(_save, _vault, mAssetQuantity, _stake);
965     }
966 
967     /**
968      * @dev 3. Buys a bAsset on Uniswap with ETH, then mints imAsset via mAsset,
969      *         optionally staking in the Boosted Savings Vault
970      * @param _mAsset         mAsset address
971      * @param _save           Save address
972      * @param _vault          Boosted vault address
973      * @param _uniswap        Uniswap router address
974      * @param _amountOutMin   Min uniswap output in bAsset units
975      * @param _path           Sell path on Uniswap (e.g. [WETH, DAI])
976      * @param _minOutMStable  Min amount of mAsset to receive
977      * @param _stake          Add the imAsset to the Savings Vault?
978      */
979     function saveViaUniswapETH(
980         address _mAsset,
981         address _save,
982         address _vault,
983         address _uniswap,
984         uint256 _amountOutMin,
985         address[] calldata _path,
986         uint256 _minOutMStable,
987         bool _stake
988     ) external payable {
989         require(_mAsset != address(0), "Invalid mAsset");
990         require(_save != address(0), "Invalid save");
991         require(_vault != address(0), "Invalid vault");
992         require(_uniswap != address(0), "Invalid uniswap");
993 
994         // 1. Get the bAsset
995         uint256[] memory amounts =
996             IUniswapV2Router02(_uniswap).swapExactETHForTokens{ value: msg.value }(
997                 _amountOutMin,
998                 _path,
999                 address(this),
1000                 block.timestamp + 1000
1001             );
1002 
1003         // 2. Purchase mAsset
1004         uint256 massetsMinted =
1005             IMasset(_mAsset).mint(
1006                 _path[_path.length - 1],
1007                 amounts[amounts.length - 1],
1008                 _minOutMStable,
1009                 address(this)
1010             );
1011 
1012         // 3. Mint imAsset and optionally stake in vault
1013         _saveAndStake(_save, _vault, massetsMinted, _stake);
1014     }
1015 
1016     /**
1017      * @dev Gets estimated mAsset output from a WETH > bAsset > mAsset trade
1018      * @param _mAsset       mAsset address
1019      * @param _uniswap      Uniswap router address
1020      * @param _ethAmount    ETH amount to sell
1021      * @param _path         Sell path on Uniswap (e.g. [WETH, DAI])
1022      */
1023     function estimate_saveViaUniswapETH(
1024         address _mAsset,
1025         address _uniswap,
1026         uint256 _ethAmount,
1027         address[] calldata _path
1028     ) external view returns (uint256 out) {
1029         require(_mAsset != address(0), "Invalid mAsset");
1030         require(_uniswap != address(0), "Invalid uniswap");
1031 
1032         uint256 estimatedBasset = _getAmountOut(_uniswap, _ethAmount, _path);
1033         return IMasset(_mAsset).getMintOutput(_path[_path.length - 1], estimatedBasset);
1034     }
1035 
1036     /** @dev Internal func to deposit into Save and optionally stake in the vault
1037      * @param _save       Save address
1038      * @param _vault      Boosted vault address
1039      * @param _amount     Amount of mAsset to deposit
1040      * @param _stake          Add the imAsset to the Savings Vault?
1041      */
1042     function _saveAndStake(
1043         address _save,
1044         address _vault,
1045         uint256 _amount,
1046         bool _stake
1047     ) internal {
1048         if (_stake) {
1049             uint256 credits = ISavingsContractV2(_save).depositSavings(_amount, address(this));
1050             IBoostedVaultWithLockup(_vault).stake(msg.sender, credits);
1051         } else {
1052             ISavingsContractV2(_save).depositSavings(_amount, msg.sender);
1053         }
1054     }
1055 
1056     /** @dev Internal func to get estimated Uniswap output from WETH to token trade */
1057     function _getAmountOut(
1058         address _uniswap,
1059         uint256 _amountIn,
1060         address[] memory _path
1061     ) internal view returns (uint256) {
1062         uint256[] memory amountsOut = IUniswapV2Router02(_uniswap).getAmountsOut(_amountIn, _path);
1063         return amountsOut[amountsOut.length - 1];
1064     }
1065 
1066     /**
1067      * @dev Approve mAsset and bAssets, Feeder Pools and fAssets, and Save/vault
1068      */
1069     function approve(
1070         address _mAsset,
1071         address[] calldata _bAssets,
1072         address[] calldata _fPools,
1073         address[] calldata _fAssets,
1074         address _save,
1075         address _vault
1076     ) external onlyOwner {
1077         _approve(_mAsset, _save);
1078         _approve(_save, _vault);
1079         _approve(_bAssets, _mAsset);
1080 
1081         require(_fPools.length == _fAssets.length, "Mismatching fPools/fAssets");
1082         for (uint256 i = 0; i < _fPools.length; i++) {
1083             _approve(_fAssets[i], _fPools[i]);
1084         }
1085     }
1086 
1087     /**
1088      * @dev Approve one token/spender
1089      */
1090     function approve(address _token, address _spender) external onlyOwner {
1091         _approve(_token, _spender);
1092     }
1093 
1094     /**
1095      * @dev Approve multiple tokens/one spender
1096      */
1097     function approve(address[] calldata _tokens, address _spender) external onlyOwner {
1098         _approve(_tokens, _spender);
1099     }
1100 
1101     function _approve(address _token, address _spender) internal {
1102         require(_spender != address(0), "Invalid spender");
1103         require(_token != address(0), "Invalid token");
1104         IERC20(_token).safeApprove(_spender, 2**256 - 1);
1105     }
1106 
1107     function _approve(address[] calldata _tokens, address _spender) internal {
1108         require(_spender != address(0), "Invalid spender");
1109         for (uint256 i = 0; i < _tokens.length; i++) {
1110             require(_tokens[i] != address(0), "Invalid token");
1111             IERC20(_tokens[i]).safeApprove(_spender, 2**256 - 1);
1112         }
1113     }
1114 }