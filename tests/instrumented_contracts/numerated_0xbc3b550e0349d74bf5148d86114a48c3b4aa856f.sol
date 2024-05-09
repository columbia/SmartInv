1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.8.6;
3 
4 
5 struct BassetPersonal {
6     // Address of the bAsset
7     address addr;
8     // Address of the bAsset
9     address integrator;
10     // An ERC20 can charge transfer fee, for example USDT, DGX tokens.
11     bool hasTxFee; // takes a byte in storage
12     // Status of the bAsset
13     BassetStatus status;
14 }
15 
16 struct BassetData {
17     // 1 Basset * ratio / ratioScale == x Masset (relative value)
18     // If ratio == 10e8 then 1 bAsset = 10 mAssets
19     // A ratio is divised as 10^(18-tokenDecimals) * measurementMultiple(relative value of 1 base unit)
20     uint128 ratio;
21     // Amount of the Basset that is held in Collateral
22     uint128 vaultBalance;
23 }
24 
25 // Status of the Basset - has it broken its peg?
26 enum BassetStatus {
27     Default,
28     Normal,
29     BrokenBelowPeg,
30     BrokenAbovePeg,
31     Blacklisted,
32     Liquidating,
33     Liquidated,
34     Fail
35 }
36 
37 abstract contract IMasset {
38     // Mint
39     function mint(
40         address _input,
41         uint256 _inputQuantity,
42         uint256 _minOutputQuantity,
43         address _recipient
44     ) external virtual returns (uint256 mintOutput);
45 
46     function mintMulti(
47         address[] calldata _inputs,
48         uint256[] calldata _inputQuantities,
49         uint256 _minOutputQuantity,
50         address _recipient
51     ) external virtual returns (uint256 mintOutput);
52 
53     function getMintOutput(address _input, uint256 _inputQuantity)
54         external
55         view
56         virtual
57         returns (uint256 mintOutput);
58 
59     function getMintMultiOutput(address[] calldata _inputs, uint256[] calldata _inputQuantities)
60         external
61         view
62         virtual
63         returns (uint256 mintOutput);
64 
65     // Swaps
66     function swap(
67         address _input,
68         address _output,
69         uint256 _inputQuantity,
70         uint256 _minOutputQuantity,
71         address _recipient
72     ) external virtual returns (uint256 swapOutput);
73 
74     function getSwapOutput(
75         address _input,
76         address _output,
77         uint256 _inputQuantity
78     ) external view virtual returns (uint256 swapOutput);
79 
80     // Redemption
81     function redeem(
82         address _output,
83         uint256 _mAssetQuantity,
84         uint256 _minOutputQuantity,
85         address _recipient
86     ) external virtual returns (uint256 outputQuantity);
87 
88     function redeemMasset(
89         uint256 _mAssetQuantity,
90         uint256[] calldata _minOutputQuantities,
91         address _recipient
92     ) external virtual returns (uint256[] memory outputQuantities);
93 
94     function redeemExactBassets(
95         address[] calldata _outputs,
96         uint256[] calldata _outputQuantities,
97         uint256 _maxMassetQuantity,
98         address _recipient
99     ) external virtual returns (uint256 mAssetRedeemed);
100 
101     function getRedeemOutput(address _output, uint256 _mAssetQuantity)
102         external
103         view
104         virtual
105         returns (uint256 bAssetOutput);
106 
107     function getRedeemExactBassetsOutput(
108         address[] calldata _outputs,
109         uint256[] calldata _outputQuantities
110     ) external view virtual returns (uint256 mAssetAmount);
111 
112     // Views
113     function getBasket() external view virtual returns (bool, bool);
114 
115     function getBasset(address _token)
116         external
117         view
118         virtual
119         returns (BassetPersonal memory personal, BassetData memory data);
120 
121     function getBassets()
122         external
123         view
124         virtual
125         returns (BassetPersonal[] memory personal, BassetData[] memory data);
126 
127     function bAssetIndexes(address) external view virtual returns (uint8);
128 
129     function getPrice() external view virtual returns (uint256 price, uint256 k);
130 
131     // SavingsManager
132     function collectInterest() external virtual returns (uint256 swapFeesGained, uint256 newSupply);
133 
134     function collectPlatformInterest()
135         external
136         virtual
137         returns (uint256 mintAmount, uint256 newSupply);
138 
139     // Admin
140     function setCacheSize(uint256 _cacheSize) external virtual;
141 
142     function setFees(uint256 _swapFee, uint256 _redemptionFee) external virtual;
143 
144     function setTransferFeesFlag(address _bAsset, bool _flag) external virtual;
145 
146     function migrateBassets(address[] calldata _bAssets, address _newIntegration) external virtual;
147 }
148 
149 interface IERC20 {
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * zero by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address sender,
205         address recipient,
206         uint256 amount
207     ) external returns (bool);
208 
209     /**
210      * @dev Emitted when `value` tokens are moved from one account (`from`) to
211      * another (`to`).
212      *
213      * Note that `value` may be zero.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 value);
216 
217     /**
218      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
219      * a call to {approve}. `value` is the new allowance.
220      */
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222 }
223 
224 interface ISavingsContractV2 {
225     // DEPRECATED but still backwards compatible
226     function redeem(uint256 _amount) external returns (uint256 massetReturned);
227 
228     function creditBalances(address) external view returns (uint256); // V1 & V2 (use balanceOf)
229 
230     // --------------------------------------------
231 
232     function depositInterest(uint256 _amount) external; // V1 & V2
233 
234     function depositSavings(uint256 _amount) external returns (uint256 creditsIssued); // V1 & V2
235 
236     function depositSavings(uint256 _amount, address _beneficiary)
237         external
238         returns (uint256 creditsIssued); // V2
239 
240     function redeemCredits(uint256 _amount) external returns (uint256 underlyingReturned); // V2
241 
242     function redeemUnderlying(uint256 _amount) external returns (uint256 creditsBurned); // V2
243 
244     function exchangeRate() external view returns (uint256); // V1 & V2
245 
246     function balanceOfUnderlying(address _user) external view returns (uint256 underlying); // V2
247 
248     function underlyingToCredits(uint256 _underlying) external view returns (uint256 credits); // V2
249 
250     function creditsToUnderlying(uint256 _credits) external view returns (uint256 underlying); // V2
251 
252     function underlying() external view returns (IERC20 underlyingMasset); // V2
253 }
254 
255 interface IRevenueRecipient {
256     /** @dev Recipient */
257     function notifyRedistributionAmount(address _mAsset, uint256 _amount) external;
258 
259     function depositToPool(address[] calldata _mAssets, uint256[] calldata _percentages) external;
260 }
261 
262 interface ISavingsManager {
263     /** @dev Admin privs */
264     function distributeUnallocatedInterest(address _mAsset) external;
265 
266     /** @dev Liquidator */
267     function depositLiquidation(address _mAsset, uint256 _liquidation) external;
268 
269     /** @dev Liquidator */
270     function collectAndStreamInterest(address _mAsset) external;
271 
272     /** @dev Public privs */
273     function collectAndDistributeInterest(address _mAsset) external;
274 
275     /** @dev getter for public lastBatchCollected mapping */
276     function lastBatchCollected(address _mAsset) external view returns (uint256);
277 }
278 
279 contract ModuleKeys {
280     // Governance
281     // ===========
282     // keccak256("Governance");
283     bytes32 internal constant KEY_GOVERNANCE =
284         0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
285     //keccak256("Staking");
286     bytes32 internal constant KEY_STAKING =
287         0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
288     //keccak256("ProxyAdmin");
289     bytes32 internal constant KEY_PROXY_ADMIN =
290         0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;
291 
292     // mStable
293     // =======
294     // keccak256("OracleHub");
295     bytes32 internal constant KEY_ORACLE_HUB =
296         0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
297     // keccak256("Manager");
298     bytes32 internal constant KEY_MANAGER =
299         0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
300     //keccak256("Recollateraliser");
301     bytes32 internal constant KEY_RECOLLATERALISER =
302         0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
303     //keccak256("MetaToken");
304     bytes32 internal constant KEY_META_TOKEN =
305         0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
306     // keccak256("SavingsManager");
307     bytes32 internal constant KEY_SAVINGS_MANAGER =
308         0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
309     // keccak256("Liquidator");
310     bytes32 internal constant KEY_LIQUIDATOR =
311         0x1e9cb14d7560734a61fa5ff9273953e971ff3cd9283c03d8346e3264617933d4;
312     // keccak256("InterestValidator");
313     bytes32 internal constant KEY_INTEREST_VALIDATOR =
314         0xc10a28f028c7f7282a03c90608e38a4a646e136e614e4b07d119280c5f7f839f;
315 }
316 
317 interface INexus {
318     function governor() external view returns (address);
319 
320     function getModule(bytes32 key) external view returns (address);
321 
322     function proposeModule(bytes32 _key, address _addr) external;
323 
324     function cancelProposedModule(bytes32 _key) external;
325 
326     function acceptProposedModule(bytes32 _key) external;
327 
328     function acceptProposedModules(bytes32[] calldata _keys) external;
329 
330     function requestLockModule(bytes32 _key) external;
331 
332     function cancelLockModule(bytes32 _key) external;
333 
334     function lockModule(bytes32 _key) external;
335 }
336 
337 abstract contract ImmutableModule is ModuleKeys {
338     INexus public immutable nexus;
339 
340     /**
341      * @dev Initialization function for upgradable proxy contracts
342      * @param _nexus Nexus contract address
343      */
344     constructor(address _nexus) {
345         require(_nexus != address(0), "Nexus address is zero");
346         nexus = INexus(_nexus);
347     }
348 
349     /**
350      * @dev Modifier to allow function calls only from the Governor.
351      */
352     modifier onlyGovernor() {
353         _onlyGovernor();
354         _;
355     }
356 
357     function _onlyGovernor() internal view {
358         require(msg.sender == _governor(), "Only governor can execute");
359     }
360 
361     /**
362      * @dev Modifier to allow function calls only from the Governance.
363      *      Governance is either Governor address or Governance address.
364      */
365     modifier onlyGovernance() {
366         require(
367             msg.sender == _governor() || msg.sender == _governance(),
368             "Only governance can execute"
369         );
370         _;
371     }
372 
373     /**
374      * @dev Returns Governor address from the Nexus
375      * @return Address of Governor Contract
376      */
377     function _governor() internal view returns (address) {
378         return nexus.governor();
379     }
380 
381     /**
382      * @dev Returns Governance Module address from the Nexus
383      * @return Address of the Governance (Phase 2)
384      */
385     function _governance() internal view returns (address) {
386         return nexus.getModule(KEY_GOVERNANCE);
387     }
388 
389     /**
390      * @dev Return SavingsManager Module address from the Nexus
391      * @return Address of the SavingsManager Module contract
392      */
393     function _savingsManager() internal view returns (address) {
394         return nexus.getModule(KEY_SAVINGS_MANAGER);
395     }
396 
397     /**
398      * @dev Return Recollateraliser Module address from the Nexus
399      * @return  Address of the Recollateraliser Module contract (Phase 2)
400      */
401     function _recollateraliser() internal view returns (address) {
402         return nexus.getModule(KEY_RECOLLATERALISER);
403     }
404 
405     /**
406      * @dev Return Liquidator Module address from the Nexus
407      * @return  Address of the Liquidator Module contract
408      */
409     function _liquidator() internal view returns (address) {
410         return nexus.getModule(KEY_LIQUIDATOR);
411     }
412 
413     /**
414      * @dev Return ProxyAdmin Module address from the Nexus
415      * @return Address of the ProxyAdmin Module contract
416      */
417     function _proxyAdmin() internal view returns (address) {
418         return nexus.getModule(KEY_PROXY_ADMIN);
419     }
420 }
421 
422 abstract contract PausableModule is ImmutableModule {
423     /**
424      * @dev Emitted when the pause is triggered by Governor
425      */
426     event Paused(address account);
427 
428     /**
429      * @dev Emitted when the pause is lifted by Governor
430      */
431     event Unpaused(address account);
432 
433     bool internal _paused = false;
434 
435     /**
436      * @dev Modifier to make a function callable only when the contract is not paused.
437      */
438     modifier whenNotPaused() {
439         require(!_paused, "Pausable: paused");
440         _;
441     }
442 
443     /**
444      * @dev Modifier to make a function callable only when the contract is paused.
445      */
446     modifier whenPaused() {
447         require(_paused, "Pausable: not paused");
448         _;
449     }
450 
451     /**
452      * @dev Initializes the contract in unpaused state.
453      * Hooks into the Module to give the Governor ability to pause
454      * @param _nexus Nexus contract address
455      */
456     constructor(address _nexus) ImmutableModule(_nexus) {
457         _paused = false;
458     }
459 
460     /**
461      * @dev Returns true if the contract is paused, and false otherwise.
462      * @return Returns `true` when paused, otherwise `false`
463      */
464     function paused() external view returns (bool) {
465         return _paused;
466     }
467 
468     /**
469      * @dev Called by the Governor to pause, triggers stopped state.
470      */
471     function pause() external onlyGovernor whenNotPaused {
472         _paused = true;
473         emit Paused(msg.sender);
474     }
475 
476     /**
477      * @dev Called by Governor to unpause, returns to normal state.
478      */
479     function unpause() external onlyGovernor whenPaused {
480         _paused = false;
481         emit Unpaused(msg.sender);
482     }
483 }
484 
485 /**
486  * @dev Collection of functions related to the address type
487  */
488 library Address {
489     /**
490      * @dev Returns true if `account` is a contract.
491      *
492      * [IMPORTANT]
493      * ====
494      * It is unsafe to assume that an address for which this function returns
495      * false is an externally-owned account (EOA) and not a contract.
496      *
497      * Among others, `isContract` will return false for the following
498      * types of addresses:
499      *
500      *  - an externally-owned account
501      *  - a contract in construction
502      *  - an address where a contract will be created
503      *  - an address where a contract lived, but was destroyed
504      * ====
505      */
506     function isContract(address account) internal view returns (bool) {
507         // This method relies on extcodesize, which returns 0 for contracts in
508         // construction, since the code is only stored at the end of the
509         // constructor execution.
510 
511         uint256 size;
512         assembly {
513             size := extcodesize(account)
514         }
515         return size > 0;
516     }
517 
518     /**
519      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
520      * `recipient`, forwarding all available gas and reverting on errors.
521      *
522      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
523      * of certain opcodes, possibly making contracts go over the 2300 gas limit
524      * imposed by `transfer`, making them unable to receive funds via
525      * `transfer`. {sendValue} removes this limitation.
526      *
527      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
528      *
529      * IMPORTANT: because control is transferred to `recipient`, care must be
530      * taken to not create reentrancy vulnerabilities. Consider using
531      * {ReentrancyGuard} or the
532      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
533      */
534     function sendValue(address payable recipient, uint256 amount) internal {
535         require(address(this).balance >= amount, "Address: insufficient balance");
536 
537         (bool success, ) = recipient.call{value: amount}("");
538         require(success, "Address: unable to send value, recipient may have reverted");
539     }
540 
541     /**
542      * @dev Performs a Solidity function call using a low level `call`. A
543      * plain `call` is an unsafe replacement for a function call: use this
544      * function instead.
545      *
546      * If `target` reverts with a revert reason, it is bubbled up by this
547      * function (like regular Solidity function calls).
548      *
549      * Returns the raw returned data. To convert to the expected return value,
550      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
551      *
552      * Requirements:
553      *
554      * - `target` must be a contract.
555      * - calling `target` with `data` must not revert.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionCall(target, data, "Address: low-level call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
565      * `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, 0, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but also transferring `value` wei to `target`.
580      *
581      * Requirements:
582      *
583      * - the calling contract must have an ETH balance of at least `value`.
584      * - the called Solidity function must be `payable`.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(
589         address target,
590         bytes memory data,
591         uint256 value
592     ) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(
603         address target,
604         bytes memory data,
605         uint256 value,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(address(this).balance >= value, "Address: insufficient balance for call");
609         require(isContract(target), "Address: call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.call{value: value}(data);
612         return _verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
622         return functionStaticCall(target, data, "Address: low-level static call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a static call.
628      *
629      * _Available since v3.3._
630      */
631     function functionStaticCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal view returns (bytes memory) {
636         require(isContract(target), "Address: static call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.staticcall(data);
639         return _verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
649         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
654      * but performing a delegate call.
655      *
656      * _Available since v3.4._
657      */
658     function functionDelegateCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         require(isContract(target), "Address: delegate call to non-contract");
664 
665         (bool success, bytes memory returndata) = target.delegatecall(data);
666         return _verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     function _verifyCallResult(
670         bool success,
671         bytes memory returndata,
672         string memory errorMessage
673     ) private pure returns (bytes memory) {
674         if (success) {
675             return returndata;
676         } else {
677             // Look for revert reason and bubble it up if present
678             if (returndata.length > 0) {
679                 // The easiest way to bubble the revert reason is using memory via assembly
680 
681                 assembly {
682                     let returndata_size := mload(returndata)
683                     revert(add(32, returndata), returndata_size)
684                 }
685             } else {
686                 revert(errorMessage);
687             }
688         }
689     }
690 }
691 
692 library SafeERC20 {
693     using Address for address;
694 
695     function safeTransfer(
696         IERC20 token,
697         address to,
698         uint256 value
699     ) internal {
700         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
701     }
702 
703     function safeTransferFrom(
704         IERC20 token,
705         address from,
706         address to,
707         uint256 value
708     ) internal {
709         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
710     }
711 
712     /**
713      * @dev Deprecated. This function has issues similar to the ones found in
714      * {IERC20-approve}, and its usage is discouraged.
715      *
716      * Whenever possible, use {safeIncreaseAllowance} and
717      * {safeDecreaseAllowance} instead.
718      */
719     function safeApprove(
720         IERC20 token,
721         address spender,
722         uint256 value
723     ) internal {
724         // safeApprove should only be called when setting an initial allowance,
725         // or when resetting it to zero. To increase and decrease it, use
726         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
727         require(
728             (value == 0) || (token.allowance(address(this), spender) == 0),
729             "SafeERC20: approve from non-zero to non-zero allowance"
730         );
731         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
732     }
733 
734     function safeIncreaseAllowance(
735         IERC20 token,
736         address spender,
737         uint256 value
738     ) internal {
739         uint256 newAllowance = token.allowance(address(this), spender) + value;
740         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
741     }
742 
743     function safeDecreaseAllowance(
744         IERC20 token,
745         address spender,
746         uint256 value
747     ) internal {
748         unchecked {
749             uint256 oldAllowance = token.allowance(address(this), spender);
750             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
751             uint256 newAllowance = oldAllowance - value;
752             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
753         }
754     }
755 
756     /**
757      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
758      * on the return value: the return value is optional (but if data is returned, it must not be false).
759      * @param token The token targeted by the call.
760      * @param data The call data (encoded using abi.encode or one of its variants).
761      */
762     function _callOptionalReturn(IERC20 token, bytes memory data) private {
763         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
764         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
765         // the target address contains contract code and also asserts for success in the low-level call.
766 
767         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
768         if (returndata.length > 0) {
769             // Return data is optional
770             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
771         }
772     }
773 }
774 
775 library StableMath {
776     /**
777      * @dev Scaling unit for use in specific calculations,
778      * where 1 * 10**18, or 1e18 represents a unit '1'
779      */
780     uint256 private constant FULL_SCALE = 1e18;
781 
782     /**
783      * @dev Token Ratios are used when converting between units of bAsset, mAsset and MTA
784      * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
785      * bAsset ratio unit for use in exact calculations,
786      * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
787      */
788     uint256 private constant RATIO_SCALE = 1e8;
789 
790     /**
791      * @dev Provides an interface to the scaling unit
792      * @return Scaling unit (1e18 or 1 * 10**18)
793      */
794     function getFullScale() internal pure returns (uint256) {
795         return FULL_SCALE;
796     }
797 
798     /**
799      * @dev Provides an interface to the ratio unit
800      * @return Ratio scale unit (1e8 or 1 * 10**8)
801      */
802     function getRatioScale() internal pure returns (uint256) {
803         return RATIO_SCALE;
804     }
805 
806     /**
807      * @dev Scales a given integer to the power of the full scale.
808      * @param x   Simple uint256 to scale
809      * @return    Scaled value a to an exact number
810      */
811     function scaleInteger(uint256 x) internal pure returns (uint256) {
812         return x * FULL_SCALE;
813     }
814 
815     /***************************************
816               PRECISE ARITHMETIC
817     ****************************************/
818 
819     /**
820      * @dev Multiplies two precise units, and then truncates by the full scale
821      * @param x     Left hand input to multiplication
822      * @param y     Right hand input to multiplication
823      * @return      Result after multiplying the two inputs and then dividing by the shared
824      *              scale unit
825      */
826     function mulTruncate(uint256 x, uint256 y) internal pure returns (uint256) {
827         return mulTruncateScale(x, y, FULL_SCALE);
828     }
829 
830     /**
831      * @dev Multiplies two precise units, and then truncates by the given scale. For example,
832      * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
833      * @param x     Left hand input to multiplication
834      * @param y     Right hand input to multiplication
835      * @param scale Scale unit
836      * @return      Result after multiplying the two inputs and then dividing by the shared
837      *              scale unit
838      */
839     function mulTruncateScale(
840         uint256 x,
841         uint256 y,
842         uint256 scale
843     ) internal pure returns (uint256) {
844         // e.g. assume scale = fullScale
845         // z = 10e18 * 9e17 = 9e36
846         // return 9e36 / 1e18 = 9e18
847         return (x * y) / scale;
848     }
849 
850     /**
851      * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
852      * @param x     Left hand input to multiplication
853      * @param y     Right hand input to multiplication
854      * @return      Result after multiplying the two inputs and then dividing by the shared
855      *              scale unit, rounded up to the closest base unit.
856      */
857     function mulTruncateCeil(uint256 x, uint256 y) internal pure returns (uint256) {
858         // e.g. 8e17 * 17268172638 = 138145381104e17
859         uint256 scaled = x * y;
860         // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
861         uint256 ceil = scaled + FULL_SCALE - 1;
862         // e.g. 13814538111.399...e18 / 1e18 = 13814538111
863         return ceil / FULL_SCALE;
864     }
865 
866     /**
867      * @dev Precisely divides two units, by first scaling the left hand operand. Useful
868      *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
869      * @param x     Left hand input to division
870      * @param y     Right hand input to division
871      * @return      Result after multiplying the left operand by the scale, and
872      *              executing the division on the right hand input.
873      */
874     function divPrecisely(uint256 x, uint256 y) internal pure returns (uint256) {
875         // e.g. 8e18 * 1e18 = 8e36
876         // e.g. 8e36 / 10e18 = 8e17
877         return (x * FULL_SCALE) / y;
878     }
879 
880     /***************************************
881                   RATIO FUNCS
882     ****************************************/
883 
884     /**
885      * @dev Multiplies and truncates a token ratio, essentially flooring the result
886      *      i.e. How much mAsset is this bAsset worth?
887      * @param x     Left hand operand to multiplication (i.e Exact quantity)
888      * @param ratio bAsset ratio
889      * @return c    Result after multiplying the two inputs and then dividing by the ratio scale
890      */
891     function mulRatioTruncate(uint256 x, uint256 ratio) internal pure returns (uint256 c) {
892         return mulTruncateScale(x, ratio, RATIO_SCALE);
893     }
894 
895     /**
896      * @dev Multiplies and truncates a token ratio, rounding up the result
897      *      i.e. How much mAsset is this bAsset worth?
898      * @param x     Left hand input to multiplication (i.e Exact quantity)
899      * @param ratio bAsset ratio
900      * @return      Result after multiplying the two inputs and then dividing by the shared
901      *              ratio scale, rounded up to the closest base unit.
902      */
903     function mulRatioTruncateCeil(uint256 x, uint256 ratio) internal pure returns (uint256) {
904         // e.g. How much mAsset should I burn for this bAsset (x)?
905         // 1e18 * 1e8 = 1e26
906         uint256 scaled = x * ratio;
907         // 1e26 + 9.99e7 = 100..00.999e8
908         uint256 ceil = scaled + RATIO_SCALE - 1;
909         // return 100..00.999e8 / 1e8 = 1e18
910         return ceil / RATIO_SCALE;
911     }
912 
913     /**
914      * @dev Precisely divides two ratioed units, by first scaling the left hand operand
915      *      i.e. How much bAsset is this mAsset worth?
916      * @param x     Left hand operand in division
917      * @param ratio bAsset ratio
918      * @return c    Result after multiplying the left operand by the scale, and
919      *              executing the division on the right hand input.
920      */
921     function divRatioPrecisely(uint256 x, uint256 ratio) internal pure returns (uint256 c) {
922         // e.g. 1e14 * 1e8 = 1e22
923         // return 1e22 / 1e12 = 1e10
924         return (x * RATIO_SCALE) / ratio;
925     }
926 
927     /***************************************
928                     HELPERS
929     ****************************************/
930 
931     /**
932      * @dev Calculates minimum of two numbers
933      * @param x     Left hand input
934      * @param y     Right hand input
935      * @return      Minimum of the two inputs
936      */
937     function min(uint256 x, uint256 y) internal pure returns (uint256) {
938         return x > y ? y : x;
939     }
940 
941     /**
942      * @dev Calculated maximum of two numbers
943      * @param x     Left hand input
944      * @param y     Right hand input
945      * @return      Maximum of the two inputs
946      */
947     function max(uint256 x, uint256 y) internal pure returns (uint256) {
948         return x > y ? x : y;
949     }
950 
951     /**
952      * @dev Clamps a value to an upper bound
953      * @param x           Left hand input
954      * @param upperBound  Maximum possible value to return
955      * @return            Input x clamped to a maximum value, upperBound
956      */
957     function clamp(uint256 x, uint256 upperBound) internal pure returns (uint256) {
958         return x > upperBound ? upperBound : x;
959     }
960 }
961 
962 library YieldValidator {
963     uint256 private constant SECONDS_IN_YEAR = 365 days;
964     uint256 private constant THIRTY_MINUTES = 30 minutes;
965 
966     uint256 private constant MAX_APY = 15e18;
967     uint256 private constant TEN_BPS = 1e15;
968 
969     /**
970      * @dev Validates that an interest collection does not exceed a maximum APY. If last collection
971      * was under 30 mins ago, simply check it does not exceed 10bps
972      * @param _newSupply               New total supply of the mAsset
973      * @param _interest                Increase in total supply since last collection
974      * @param _timeSinceLastCollection Seconds since last collection
975      */
976     function validateCollection(
977         uint256 _newSupply,
978         uint256 _interest,
979         uint256 _timeSinceLastCollection
980     ) internal pure returns (uint256 extrapolatedAPY) {
981         return
982             validateCollection(_newSupply, _interest, _timeSinceLastCollection, MAX_APY, TEN_BPS);
983     }
984 
985     /**
986      * @dev Validates that an interest collection does not exceed a maximum APY. If last collection
987      * was under 30 mins ago, simply check it does not exceed 10bps
988      * @param _newSupply               New total supply of the mAsset
989      * @param _interest                Increase in total supply since last collection
990      * @param _timeSinceLastCollection Seconds since last collection
991      * @param _maxApy                  Max APY where 100% == 1e18
992      * @param _baseApy                 If less than 30 mins, do not exceed this % increase
993      */
994     function validateCollection(
995         uint256 _newSupply,
996         uint256 _interest,
997         uint256 _timeSinceLastCollection,
998         uint256 _maxApy,
999         uint256 _baseApy
1000     ) internal pure returns (uint256 extrapolatedAPY) {
1001         uint256 protectedTime = _timeSinceLastCollection == 0 ? 1 : _timeSinceLastCollection;
1002 
1003         // Percentage increase in total supply
1004         // e.g. (1e20 * 1e18) / 1e24 = 1e14 (or a 0.01% increase)
1005         // e.g. (5e18 * 1e18) / 1.2e24 = 4.1667e12
1006         // e.g. (1e19 * 1e18) / 1e21 = 1e16
1007         uint256 oldSupply = _newSupply - _interest;
1008         uint256 percentageIncrease = (_interest * 1e18) / oldSupply;
1009 
1010         //      If over 30 mins, extrapolate APY
1011         // e.g. day: (86400 * 1e18) / 3.154e7 = 2.74..e15
1012         // e.g. 30 mins: (1800 * 1e18) / 3.154e7 = 5.7..e13
1013         // e.g. epoch: (1593596907 * 1e18) / 3.154e7 = 50.4..e18
1014         uint256 yearsSinceLastCollection = (protectedTime * 1e18) / SECONDS_IN_YEAR;
1015 
1016         // e.g. 0.01% (1e14 * 1e18) / 2.74..e15 = 3.65e16 or 3.65% apr
1017         // e.g. (4.1667e12 * 1e18) / 5.7..e13 = 7.1e16 or 7.1% apr
1018         // e.g. (1e16 * 1e18) / 50e18 = 2e14
1019         extrapolatedAPY = (percentageIncrease * 1e18) / yearsSinceLastCollection;
1020 
1021         if (protectedTime > THIRTY_MINUTES) {
1022             require(extrapolatedAPY < _maxApy, "Interest protected from inflating past maxAPY");
1023         } else {
1024             require(percentageIncrease < _baseApy, "Interest protected from inflating past 10 Bps");
1025         }
1026     }
1027 }
1028 
1029 /**
1030  * @title   SavingsManager
1031  * @author  mStable
1032  * @notice  Savings Manager collects interest from mAssets and sends them to the
1033  *          corresponding Savings Contract, performing some validation in the process.
1034  * @dev     VERSION: 1.4
1035  *          DATE:    2021-10-15
1036  */
1037 contract SavingsManager is ISavingsManager, PausableModule {
1038     using StableMath for uint256;
1039     using SafeERC20 for IERC20;
1040 
1041     // Core admin events
1042     event RevenueRecipientSet(address indexed mAsset, address recipient);
1043     event SavingsContractAdded(address indexed mAsset, address savingsContract);
1044     event SavingsContractUpdated(address indexed mAsset, address savingsContract);
1045     event SavingsRateChanged(uint256 newSavingsRate);
1046     event StreamsFrozen();
1047     // Interest collection
1048     event LiquidatorDeposited(address indexed mAsset, uint256 amount);
1049     event InterestCollected(
1050         address indexed mAsset,
1051         uint256 interest,
1052         uint256 newTotalSupply,
1053         uint256 apy
1054     );
1055     event InterestDistributed(address indexed mAsset, uint256 amountSent);
1056     event RevenueRedistributed(address indexed mAsset, address recipient, uint256 amount);
1057 
1058     // Locations of each mAsset savings contract
1059     mapping(address => ISavingsContractV2) public savingsContracts;
1060     mapping(address => IRevenueRecipient) public revenueRecipients;
1061     // Time at which last collection was made
1062     mapping(address => uint256) public lastPeriodStart;
1063     mapping(address => uint256) public lastCollection;
1064     mapping(address => uint256) public periodYield;
1065 
1066     // Amount of collected interest that will be sent to Savings Contract (1e18 = 100%)
1067     uint256 private savingsRate;
1068     // Streaming liquidated tokens
1069     uint256 private immutable DURATION; // measure in days. eg 1 days or 7 days
1070     uint256 private constant ONE_DAY = 1 days;
1071     uint256 private constant THIRTY_MINUTES = 30 minutes;
1072     // Streams
1073     bool private streamsFrozen = false;
1074     // Liquidator
1075     mapping(address => Stream) public liqStream;
1076     // Platform
1077     mapping(address => Stream) public yieldStream;
1078     // Batches are for the platformInterest collection
1079     mapping(address => uint256) public override lastBatchCollected;
1080 
1081     enum StreamType {
1082         liquidator,
1083         yield
1084     }
1085 
1086     struct Stream {
1087         uint256 end;
1088         uint256 rate;
1089     }
1090 
1091     constructor(
1092         address _nexus,
1093         address[] memory _mAssets,
1094         address[] memory _savingsContracts,
1095         address[] memory _revenueRecipients,
1096         uint256 _savingsRate,
1097         uint256 _duration
1098     ) PausableModule(_nexus) {
1099         uint256 len = _mAssets.length;
1100         require(
1101             _savingsContracts.length == len && _revenueRecipients.length == len,
1102             "Invalid inputs"
1103         );
1104         for (uint256 i = 0; i < len; i++) {
1105             _updateSavingsContract(_mAssets[i], _savingsContracts[i]);
1106             emit SavingsContractAdded(_mAssets[i], _savingsContracts[i]);
1107 
1108             revenueRecipients[_mAssets[i]] = IRevenueRecipient(_revenueRecipients[i]);
1109             emit RevenueRecipientSet(_mAssets[i], _revenueRecipients[i]);
1110         }
1111         savingsRate = _savingsRate;
1112         DURATION = _duration;
1113     }
1114 
1115     modifier onlyLiquidator() {
1116         require(msg.sender == _liquidator(), "Only liquidator can execute");
1117         _;
1118     }
1119 
1120     modifier whenStreamsNotFrozen() {
1121         require(!streamsFrozen, "Streaming is currently frozen");
1122         _;
1123     }
1124 
1125     /***************************************
1126                     STATE
1127     ****************************************/
1128 
1129     /**
1130      * @dev Adds a new savings contract
1131      * @param _mAsset           Address of underlying mAsset
1132      * @param _savingsContract  Address of the savings contract
1133      */
1134     function addSavingsContract(address _mAsset, address _savingsContract) external onlyGovernor {
1135         require(
1136             address(savingsContracts[_mAsset]) == address(0),
1137             "Savings contract already exists"
1138         );
1139         _updateSavingsContract(_mAsset, _savingsContract);
1140         emit SavingsContractAdded(_mAsset, _savingsContract);
1141     }
1142 
1143     /**
1144      * @dev Updates an existing savings contract
1145      * @param _mAsset           Address of underlying mAsset
1146      * @param _savingsContract  Address of the savings contract
1147      */
1148     function updateSavingsContract(address _mAsset, address _savingsContract)
1149         external
1150         onlyGovernor
1151     {
1152         require(
1153             address(savingsContracts[_mAsset]) != address(0),
1154             "Savings contract does not exist"
1155         );
1156         _updateSavingsContract(_mAsset, _savingsContract);
1157         emit SavingsContractUpdated(_mAsset, _savingsContract);
1158     }
1159 
1160     function _updateSavingsContract(address _mAsset, address _savingsContract) internal {
1161         require(_mAsset != address(0) && _savingsContract != address(0), "Must be valid address");
1162         savingsContracts[_mAsset] = ISavingsContractV2(_savingsContract);
1163 
1164         IERC20(_mAsset).safeApprove(address(_savingsContract), 0);
1165         IERC20(_mAsset).safeApprove(address(_savingsContract), type(uint256).max);
1166     }
1167 
1168     /**
1169      * @dev Freezes streaming of mAssets
1170      */
1171     function freezeStreams() external onlyGovernor whenStreamsNotFrozen {
1172         streamsFrozen = true;
1173 
1174         emit StreamsFrozen();
1175     }
1176 
1177     /**
1178      * @dev Sets the revenue recipient address
1179      * @param _mAsset           Address of underlying mAsset
1180      * @param _recipient        Address of the recipient
1181      */
1182     function setRevenueRecipient(address _mAsset, address _recipient) external onlyGovernor {
1183         revenueRecipients[_mAsset] = IRevenueRecipient(_recipient);
1184 
1185         emit RevenueRecipientSet(_mAsset, _recipient);
1186     }
1187 
1188     /**
1189      * @dev Sets a new savings rate for interest distribution
1190      * @param _savingsRate   Rate of savings sent to SavingsContract (100% = 1e18)
1191      */
1192     function setSavingsRate(uint256 _savingsRate) external onlyGovernor {
1193         // Greater than 25% up to 100%
1194         require(_savingsRate >= 25e16 && _savingsRate <= 1e18, "Must be a valid rate");
1195         savingsRate = _savingsRate;
1196         emit SavingsRateChanged(_savingsRate);
1197     }
1198 
1199     /**
1200      * @dev Allows the liquidator to deposit proceeds from liquidated gov tokens.
1201      * Transfers proceeds on a second by second basis to the Savings Contract over 1 week.
1202      * @param _mAsset The mAsset to transfer and distribute
1203      * @param _liquidated Units of mAsset to distribute
1204      */
1205     function depositLiquidation(address _mAsset, uint256 _liquidated)
1206         external
1207         override
1208         whenNotPaused
1209         onlyLiquidator
1210         whenStreamsNotFrozen
1211     {
1212         // Collect existing interest to ensure everything is up to date
1213         _collectAndDistributeInterest(_mAsset);
1214 
1215         // transfer liquidated mUSD to here
1216         IERC20(_mAsset).safeTransferFrom(_liquidator(), address(this), _liquidated);
1217 
1218         uint256 leftover = _unstreamedRewards(_mAsset, StreamType.liquidator);
1219         _initialiseStream(_mAsset, StreamType.liquidator, _liquidated + leftover, DURATION);
1220 
1221         emit LiquidatorDeposited(_mAsset, _liquidated);
1222     }
1223 
1224     /**
1225      * @dev Collects the platform interest from a given mAsset and then adds capital to the
1226      * stream. If there is > 24h left in current stream, just top it up, otherwise reset.
1227      * @param _mAsset The mAsset to fetch interest
1228      */
1229     function collectAndStreamInterest(address _mAsset)
1230         external
1231         override
1232         whenNotPaused
1233         whenStreamsNotFrozen
1234     {
1235         // Collect existing interest to ensure everything is up to date
1236         _collectAndDistributeInterest(_mAsset);
1237 
1238         uint256 currentTime = block.timestamp;
1239         uint256 previousBatch = lastBatchCollected[_mAsset];
1240         uint256 timeSincePreviousBatch = currentTime - previousBatch;
1241         require(timeSincePreviousBatch > 6 hours, "Cannot deposit twice in 6 hours");
1242         lastBatchCollected[_mAsset] = currentTime;
1243 
1244         // Batch collect
1245         (uint256 interestCollected, uint256 totalSupply) = IMasset(_mAsset)
1246         .collectPlatformInterest();
1247 
1248         if (interestCollected > 0) {
1249             // Validate APY
1250             uint256 apy = YieldValidator.validateCollection(
1251                 totalSupply,
1252                 interestCollected,
1253                 timeSincePreviousBatch
1254             );
1255 
1256             // Get remaining rewards
1257             uint256 leftover = _unstreamedRewards(_mAsset, StreamType.yield);
1258             _initialiseStream(_mAsset, StreamType.yield, interestCollected + leftover, ONE_DAY);
1259 
1260             emit InterestCollected(_mAsset, interestCollected, totalSupply, apy);
1261         } else {
1262             emit InterestCollected(_mAsset, interestCollected, totalSupply, 0);
1263         }
1264     }
1265 
1266     /**
1267      * @dev Calculates how many rewards from the stream are still to be distributed, from the
1268      * last collection time to the end of the stream.
1269      * @param _mAsset The mAsset in question
1270      * @return leftover The total amount of mAsset that is yet to be collected from a stream
1271      */
1272     function _unstreamedRewards(address _mAsset, StreamType _stream)
1273         internal
1274         view
1275         returns (uint256 leftover)
1276     {
1277         uint256 lastUpdate = lastCollection[_mAsset];
1278 
1279         Stream memory stream = _stream == StreamType.liquidator
1280             ? liqStream[_mAsset]
1281             : yieldStream[_mAsset];
1282         uint256 unclaimedSeconds = 0;
1283         if (lastUpdate < stream.end) {
1284             unclaimedSeconds = stream.end - lastUpdate;
1285         }
1286         return unclaimedSeconds * stream.rate;
1287     }
1288 
1289     /**
1290      * @dev Simply sets up the stream
1291      * @param _mAsset The mAsset in question
1292      * @param _amount Amount of units to stream
1293      * @param _duration Duration of the stream, from now
1294      */
1295     function _initialiseStream(
1296         address _mAsset,
1297         StreamType _stream,
1298         uint256 _amount,
1299         uint256 _duration
1300     ) internal {
1301         uint256 currentTime = block.timestamp;
1302         // Distribute reward per second over X seconds
1303         uint256 rate = _amount / _duration;
1304         uint256 end = currentTime + _duration;
1305         if (_stream == StreamType.liquidator) {
1306             liqStream[_mAsset] = Stream(end, rate);
1307         } else {
1308             yieldStream[_mAsset] = Stream(end, rate);
1309         }
1310 
1311         // Reset pool data to enable lastCollection usage twice
1312         require(lastCollection[_mAsset] == currentTime, "Stream data must be up to date");
1313     }
1314 
1315     /***************************************
1316                 COLLECTION
1317     ****************************************/
1318 
1319     /**
1320      * @dev Collects interest from a target mAsset and distributes to the SavingsContract.
1321      *      Applies constraints such that the max APY since the last fee collection cannot
1322      *      exceed the "MAX_APY" variable.
1323      * @param _mAsset       mAsset for which the interest should be collected
1324      */
1325     function collectAndDistributeInterest(address _mAsset) external override whenNotPaused {
1326         _collectAndDistributeInterest(_mAsset);
1327     }
1328 
1329     function _collectAndDistributeInterest(address _mAsset) internal {
1330         ISavingsContractV2 savingsContract = savingsContracts[_mAsset];
1331         require(address(savingsContract) != address(0), "Must have a valid savings contract");
1332 
1333         // Get collection details
1334         uint256 recentPeriodStart = lastPeriodStart[_mAsset];
1335         uint256 previousCollection = lastCollection[_mAsset];
1336         lastCollection[_mAsset] = block.timestamp;
1337 
1338         // 1. Collect the new interest from the mAsset
1339         IMasset mAsset = IMasset(_mAsset);
1340         (uint256 interestCollected, uint256 totalSupply) = mAsset.collectInterest();
1341 
1342         // 2. Update all the time stamps
1343         //    Avoid division by 0 by adding a minimum elapsed time of 1 second
1344         uint256 timeSincePeriodStart = StableMath.max(1, block.timestamp - recentPeriodStart);
1345         uint256 timeSinceLastCollection = StableMath.max(1, block.timestamp - previousCollection);
1346 
1347         uint256 inflationOperand = interestCollected;
1348         //    If it has been 30 mins since last collection, reset period data
1349         if (timeSinceLastCollection > THIRTY_MINUTES) {
1350             lastPeriodStart[_mAsset] = block.timestamp;
1351             periodYield[_mAsset] = 0;
1352         }
1353         //    Else if period has elapsed, start a new period from the lastCollection time
1354         else if (timeSincePeriodStart > THIRTY_MINUTES) {
1355             lastPeriodStart[_mAsset] = previousCollection;
1356             periodYield[_mAsset] = interestCollected;
1357         }
1358         //    Else add yield to period yield
1359         else {
1360             inflationOperand = periodYield[_mAsset] + interestCollected;
1361             periodYield[_mAsset] = inflationOperand;
1362         }
1363 
1364         //    Add on liquidated
1365         uint256 newReward = _unclaimedRewards(_mAsset, previousCollection);
1366         // 3. Validate that interest is collected correctly and does not exceed max APY
1367         if (interestCollected > 0 || newReward > 0) {
1368             require(
1369                 IERC20(_mAsset).balanceOf(address(this)) >= interestCollected + newReward,
1370                 "Must receive mUSD"
1371             );
1372 
1373             uint256 extrapolatedAPY = YieldValidator.validateCollection(
1374                 totalSupply,
1375                 inflationOperand,
1376                 timeSinceLastCollection
1377             );
1378 
1379             emit InterestCollected(_mAsset, interestCollected, totalSupply, extrapolatedAPY);
1380 
1381             // 4. Distribute the interest
1382             //    Calculate the share for savers (95e16 or 95%)
1383             uint256 saversShare = (interestCollected + newReward).mulTruncate(savingsRate);
1384 
1385             //    Call depositInterest on contract
1386             savingsContract.depositInterest(saversShare);
1387 
1388             emit InterestDistributed(_mAsset, saversShare);
1389         } else {
1390             emit InterestCollected(_mAsset, 0, totalSupply, 0);
1391         }
1392     }
1393 
1394     /**
1395      * @dev Calculates unclaimed rewards from the liquidation stream
1396      * @param _mAsset mAsset key
1397      * @param _previousCollection Time of previous collection
1398      * @return Units of mAsset that have been unlocked for distribution
1399      */
1400     function _unclaimedRewards(address _mAsset, uint256 _previousCollection)
1401         internal
1402         view
1403         returns (uint256)
1404     {
1405         Stream memory liq = liqStream[_mAsset];
1406         uint256 unclaimedSeconds_liq = _unclaimedSeconds(_previousCollection, liq.end);
1407         uint256 subtotal_liq = unclaimedSeconds_liq * liq.rate;
1408 
1409         Stream memory yield = yieldStream[_mAsset];
1410         uint256 unclaimedSeconds_yield = _unclaimedSeconds(_previousCollection, yield.end);
1411         uint256 subtotal_yield = unclaimedSeconds_yield * yield.rate;
1412 
1413         return subtotal_liq + subtotal_yield;
1414     }
1415 
1416     /**
1417      * @dev Calculates the seconds of unclaimed rewards, based on period length
1418      * @param _lastUpdate Time of last update
1419      * @param _end End time of period
1420      * @return Seconds of stream that should be compensated
1421      */
1422     function _unclaimedSeconds(uint256 _lastUpdate, uint256 _end) internal view returns (uint256) {
1423         uint256 currentTime = block.timestamp;
1424         uint256 unclaimedSeconds = 0;
1425 
1426         if (currentTime <= _end) {
1427             unclaimedSeconds = currentTime - _lastUpdate;
1428         } else if (_lastUpdate < _end) {
1429             unclaimedSeconds = _end - _lastUpdate;
1430         }
1431         return unclaimedSeconds;
1432     }
1433 
1434     /***************************************
1435             Revenue Redistribution
1436     ****************************************/
1437 
1438     /**
1439      * @dev Redistributes the unallocated interest to the saved recipient, allowing
1440      * the siphoned assets to be used elsewhere in the system
1441      * @param _mAsset  mAsset to collect
1442      */
1443     function distributeUnallocatedInterest(address _mAsset) external override {
1444         IRevenueRecipient recipient = revenueRecipients[_mAsset];
1445         require(address(recipient) != address(0), "Must have valid recipient");
1446 
1447         IERC20 mAsset = IERC20(_mAsset);
1448         uint256 balance = mAsset.balanceOf(address(this));
1449         uint256 leftover_liq = _unstreamedRewards(_mAsset, StreamType.liquidator);
1450         uint256 leftover_yield = _unstreamedRewards(_mAsset, StreamType.yield);
1451 
1452         uint256 unallocated = balance - leftover_liq - leftover_yield;
1453 
1454         mAsset.approve(address(recipient), unallocated);
1455         recipient.notifyRedistributionAmount(_mAsset, unallocated);
1456 
1457         emit RevenueRedistributed(_mAsset, address(recipient), unallocated);
1458     }
1459 }