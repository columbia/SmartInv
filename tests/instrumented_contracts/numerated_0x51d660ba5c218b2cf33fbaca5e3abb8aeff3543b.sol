1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
2 
3 // File contracts/solidity/testing/Context.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File contracts/solidity/util/Ownable.sol
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 // File contracts/solidity/util/ReentrancyGuard.sol
105 
106 pragma solidity ^0.8.0;
107 
108 abstract contract ReentrancyGuard {
109     // Booleans are more expensive than uint256 or any type that takes up a full
110     // word because each write operation emits an extra SLOAD to first read the
111     // slot's contents, replace the bits taken up by the boolean, and then write
112     // back. This is the compiler's defense against contract upgrades and
113     // pointer aliasing, and it cannot be disabled.
114 
115     // The values being non-zero value makes deployment a bit more expensive,
116     // but in exchange the refund on every call to nonReentrant will be lower in
117     // amount. Since refunds are capped to a percentage of the total
118     // transaction's gas, it is best to keep them low in cases like this one, to
119     // increase the likelihood of the full refund coming into effect.
120     uint256 private constant _NOT_ENTERED = 1;
121     uint256 private constant _ENTERED = 2;
122 
123     uint256 private _status;
124 
125     constructor() {
126         _status = _NOT_ENTERED;
127     }
128 
129     /**
130      * @dev Prevents a contract from calling itself, directly or indirectly.
131      * Calling a `nonReentrant` function from another `nonReentrant`
132      * function is not supported. It is possible to prevent this from happening
133      * by making the `nonReentrant` function external, and make it call a
134      * `private` function that does the actual work.
135      */
136     modifier nonReentrant() {
137         // On the first call to nonReentrant, _notEntered will be true
138         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
139 
140         // Any calls to nonReentrant after this point will fail
141         _status = _ENTERED;
142 
143         _;
144 
145         // By storing the original value once again, a refund is triggered (see
146         // https://eips.ethereum.org/EIPS/eip-2200)
147         _status = _NOT_ENTERED;
148     }
149 }
150 
151 // File contracts/solidity/proxy/IBeacon.sol
152 
153 pragma solidity ^0.8.0;
154 
155 /**
156  * @dev This is the interface that {BeaconProxy} expects of its beacon.
157  */
158 interface IBeacon {
159     /**
160      * @dev Must return an address that can be used as a delegate call target.
161      *
162      * {BeaconProxy} will check that this address is a contract.
163      */
164     function childImplementation() external view returns (address);
165 
166     function upgradeChildTo(address newImplementation) external;
167 }
168 
169 // File contracts/solidity/interface/INFTXVaultFactory.sol
170 
171 pragma solidity ^0.8.0;
172 
173 interface INFTXVaultFactory is IBeacon {
174     // Read functions.
175     function numVaults() external view returns (uint256);
176 
177     function zapContract() external view returns (address);
178 
179     function feeDistributor() external view returns (address);
180 
181     function eligibilityManager() external view returns (address);
182 
183     function vault(uint256 vaultId) external view returns (address);
184 
185     function allVaults() external view returns (address[] memory);
186 
187     function vaultsForAsset(address asset)
188         external
189         view
190         returns (address[] memory);
191 
192     function isLocked(uint256 id) external view returns (bool);
193 
194     function excludedFromFees(address addr) external view returns (bool);
195 
196     function factoryMintFee() external view returns (uint64);
197 
198     function factoryRandomRedeemFee() external view returns (uint64);
199 
200     function factoryTargetRedeemFee() external view returns (uint64);
201 
202     function factoryRandomSwapFee() external view returns (uint64);
203 
204     function factoryTargetSwapFee() external view returns (uint64);
205 
206     function vaultFees(uint256 vaultId)
207         external
208         view
209         returns (
210             uint256,
211             uint256,
212             uint256,
213             uint256,
214             uint256
215         );
216 
217     event NewFeeDistributor(address oldDistributor, address newDistributor);
218     event NewZapContract(address oldZap, address newZap);
219     event FeeExclusion(address feeExcluded, bool excluded);
220     event NewEligibilityManager(address oldEligManager, address newEligManager);
221     event NewVault(
222         uint256 indexed vaultId,
223         address vaultAddress,
224         address assetAddress
225     );
226     event UpdateVaultFees(
227         uint256 vaultId,
228         uint256 mintFee,
229         uint256 randomRedeemFee,
230         uint256 targetRedeemFee,
231         uint256 randomSwapFee,
232         uint256 targetSwapFee
233     );
234     event DisableVaultFees(uint256 vaultId);
235     event UpdateFactoryFees(
236         uint256 mintFee,
237         uint256 randomRedeemFee,
238         uint256 targetRedeemFee,
239         uint256 randomSwapFee,
240         uint256 targetSwapFee
241     );
242 
243     // Write functions.
244     function __NFTXVaultFactory_init(
245         address _vaultImpl,
246         address _feeDistributor
247     ) external;
248 
249     function createVault(
250         string calldata name,
251         string calldata symbol,
252         address _assetAddress,
253         bool is1155,
254         bool allowAllItems
255     ) external returns (uint256);
256 
257     function setFeeDistributor(address _feeDistributor) external;
258 
259     function setEligibilityManager(address _eligibilityManager) external;
260 
261     function setZapContract(address _zapContract) external;
262 
263     function setFeeExclusion(address _excludedAddr, bool excluded) external;
264 
265     function setFactoryFees(
266         uint256 mintFee,
267         uint256 randomRedeemFee,
268         uint256 targetRedeemFee,
269         uint256 randomSwapFee,
270         uint256 targetSwapFee
271     ) external;
272 
273     function setVaultFees(
274         uint256 vaultId,
275         uint256 mintFee,
276         uint256 randomRedeemFee,
277         uint256 targetRedeemFee,
278         uint256 randomSwapFee,
279         uint256 targetSwapFee
280     ) external;
281 
282     function disableVaultFees(uint256 vaultId) external;
283 }
284 
285 // File contracts/solidity/interface/INFTXEligibility.sol
286 
287 pragma solidity ^0.8.0;
288 
289 interface INFTXEligibility {
290     // Read functions.
291     function name() external pure returns (string memory);
292 
293     function finalized() external view returns (bool);
294 
295     function targetAsset() external pure returns (address);
296 
297     function checkAllEligible(uint256[] calldata tokenIds)
298         external
299         view
300         returns (bool);
301 
302     function checkEligible(uint256[] calldata tokenIds)
303         external
304         view
305         returns (bool[] memory);
306 
307     function checkAllIneligible(uint256[] calldata tokenIds)
308         external
309         view
310         returns (bool);
311 
312     function checkIsEligible(uint256 tokenId) external view returns (bool);
313 
314     // Write functions.
315     function __NFTXEligibility_init_bytes(bytes calldata configData) external;
316 
317     function beforeMintHook(uint256[] calldata tokenIds) external;
318 
319     function afterMintHook(uint256[] calldata tokenIds) external;
320 
321     function beforeRedeemHook(uint256[] calldata tokenIds) external;
322 
323     function afterRedeemHook(uint256[] calldata tokenIds) external;
324 }
325 
326 // File contracts/solidity/token/IERC20Upgradeable.sol
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Interface of the ERC20 standard as defined in the EIP.
332  */
333 interface IERC20Upgradeable {
334     /**
335      * @dev Returns the amount of tokens in existence.
336      */
337     function totalSupply() external view returns (uint256);
338 
339     /**
340      * @dev Returns the amount of tokens owned by `account`.
341      */
342     function balanceOf(address account) external view returns (uint256);
343 
344     /**
345      * @dev Moves `amount` tokens from the caller's account to `recipient`.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * Emits a {Transfer} event.
350      */
351     function transfer(address recipient, uint256 amount)
352         external
353         returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender)
363         external
364         view
365         returns (uint256);
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * IMPORTANT: Beware that changing an allowance with this method brings the risk
373      * that someone may use both the old and the new allowance by unfortunate
374      * transaction ordering. One possible solution to mitigate this race
375      * condition is to first reduce the spender's allowance to 0 and set the
376      * desired value afterwards:
377      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address spender, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Moves `amount` tokens from `sender` to `recipient` using the
385      * allowance mechanism. `amount` is then deducted from the caller's
386      * allowance.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) external returns (bool);
397 
398     /**
399      * @dev Emitted when `value` tokens are moved from one account (`from`) to
400      * another (`to`).
401      *
402      * Note that `value` may be zero.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 value);
405 
406     /**
407      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
408      * a call to {approve}. `value` is the new allowance.
409      */
410     event Approval(
411         address indexed owner,
412         address indexed spender,
413         uint256 value
414     );
415 }
416 
417 // File contracts/solidity/interface/INFTXVault.sol
418 
419 pragma solidity ^0.8.0;
420 
421 interface INFTXVault is IERC20Upgradeable {
422     function manager() external view returns (address);
423 
424     function assetAddress() external view returns (address);
425 
426     function vaultFactory() external view returns (INFTXVaultFactory);
427 
428     function eligibilityStorage() external view returns (INFTXEligibility);
429 
430     function is1155() external view returns (bool);
431 
432     function allowAllItems() external view returns (bool);
433 
434     function enableMint() external view returns (bool);
435 
436     function enableRandomRedeem() external view returns (bool);
437 
438     function enableTargetRedeem() external view returns (bool);
439 
440     function enableRandomSwap() external view returns (bool);
441 
442     function enableTargetSwap() external view returns (bool);
443 
444     function vaultId() external view returns (uint256);
445 
446     function nftIdAt(uint256 holdingsIndex) external view returns (uint256);
447 
448     function allHoldings() external view returns (uint256[] memory);
449 
450     function totalHoldings() external view returns (uint256);
451 
452     function mintFee() external view returns (uint256);
453 
454     function randomRedeemFee() external view returns (uint256);
455 
456     function targetRedeemFee() external view returns (uint256);
457 
458     function randomSwapFee() external view returns (uint256);
459 
460     function targetSwapFee() external view returns (uint256);
461 
462     function vaultFees()
463         external
464         view
465         returns (
466             uint256,
467             uint256,
468             uint256,
469             uint256,
470             uint256
471         );
472 
473     event VaultInit(
474         uint256 indexed vaultId,
475         address assetAddress,
476         bool is1155,
477         bool allowAllItems
478     );
479 
480     event ManagerSet(address manager);
481     event EligibilityDeployed(uint256 moduleIndex, address eligibilityAddr);
482     // event CustomEligibilityDeployed(address eligibilityAddr);
483 
484     event EnableMintUpdated(bool enabled);
485     event EnableRandomRedeemUpdated(bool enabled);
486     event EnableTargetRedeemUpdated(bool enabled);
487     event EnableRandomSwapUpdated(bool enabled);
488     event EnableTargetSwapUpdated(bool enabled);
489 
490     event Minted(uint256[] nftIds, uint256[] amounts, address to);
491     event Redeemed(uint256[] nftIds, uint256[] specificIds, address to);
492     event Swapped(
493         uint256[] nftIds,
494         uint256[] amounts,
495         uint256[] specificIds,
496         uint256[] redeemedIds,
497         address to
498     );
499 
500     function __NFTXVault_init(
501         string calldata _name,
502         string calldata _symbol,
503         address _assetAddress,
504         bool _is1155,
505         bool _allowAllItems
506     ) external;
507 
508     function finalizeVault() external;
509 
510     function setVaultMetadata(string memory name_, string memory symbol_)
511         external;
512 
513     function setVaultFeatures(
514         bool _enableMint,
515         bool _enableRandomRedeem,
516         bool _enableTargetRedeem,
517         bool _enableRandomSwap,
518         bool _enableTargetSwap
519     ) external;
520 
521     function setFees(
522         uint256 _mintFee,
523         uint256 _randomRedeemFee,
524         uint256 _targetRedeemFee,
525         uint256 _randomSwapFee,
526         uint256 _targetSwapFee
527     ) external;
528 
529     function disableVaultFees() external;
530 
531     // This function allows for an easy setup of any eligibility module contract from the EligibilityManager.
532     // It takes in ABI encoded parameters for the desired module. This is to make sure they can all follow
533     // a similar interface.
534     function deployEligibilityStorage(
535         uint256 moduleIndex,
536         bytes calldata initData
537     ) external returns (address);
538 
539     // The manager has control over options like fees and features
540     function setManager(address _manager) external;
541 
542     function mint(
543         uint256[] calldata tokenIds,
544         uint256[] calldata amounts /* ignored for ERC721 vaults */
545     ) external returns (uint256);
546 
547     function mintTo(
548         uint256[] calldata tokenIds,
549         uint256[] calldata amounts, /* ignored for ERC721 vaults */
550         address to
551     ) external returns (uint256);
552 
553     function redeem(uint256 amount, uint256[] calldata specificIds)
554         external
555         returns (uint256[] calldata);
556 
557     function redeemTo(
558         uint256 amount,
559         uint256[] calldata specificIds,
560         address to
561     ) external returns (uint256[] calldata);
562 
563     function swap(
564         uint256[] calldata tokenIds,
565         uint256[] calldata amounts, /* ignored for ERC721 vaults */
566         uint256[] calldata specificIds
567     ) external returns (uint256[] calldata);
568 
569     function swapTo(
570         uint256[] calldata tokenIds,
571         uint256[] calldata amounts, /* ignored for ERC721 vaults */
572         uint256[] calldata specificIds,
573         address to
574     ) external returns (uint256[] calldata);
575 
576     function allValidNFTs(uint256[] calldata tokenIds)
577         external
578         view
579         returns (bool);
580 }
581 
582 // File contracts/solidity/interface/INFTXInventoryStaking.sol
583 
584 pragma solidity ^0.8.0;
585 
586 interface INFTXInventoryStaking {
587     function nftxVaultFactory() external view returns (INFTXVaultFactory);
588 
589     function vaultXToken(uint256 vaultId) external view returns (address);
590 
591     function xTokenAddr(address baseToken) external view returns (address);
592 
593     function xTokenShareValue(uint256 vaultId) external view returns (uint256);
594 
595     function __NFTXInventoryStaking_init(address nftxFactory) external;
596 
597     function deployXTokenForVault(uint256 vaultId) external;
598 
599     function receiveRewards(uint256 vaultId, uint256 amount)
600         external
601         returns (bool);
602 
603     function timelockMintFor(
604         uint256 vaultId,
605         uint256 amount,
606         address to,
607         uint256 timelockLength
608     ) external returns (uint256);
609 
610     function deposit(uint256 vaultId, uint256 _amount) external;
611 
612     function withdraw(uint256 vaultId, uint256 _share) external;
613 }
614 
615 // File contracts/solidity/token/IERC20Metadata.sol
616 
617 pragma solidity ^0.8.0;
618 
619 /**
620  * @dev Interface for the optional metadata functions from the ERC20 standard.
621  *
622  * _Available since v4.1._
623  */
624 interface IERC20Metadata is IERC20Upgradeable {
625     /**
626      * @dev Returns the name of the token.
627      */
628     function name() external view returns (string memory);
629 
630     /**
631      * @dev Returns the symbol of the token.
632      */
633     function symbol() external view returns (string memory);
634 
635     /**
636      * @dev Returns the decimals places of the token.
637      */
638     function decimals() external view returns (uint8);
639 }
640 
641 // File contracts/solidity/util/Address.sol
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Collection of functions related to the address type
647  */
648 library Address {
649     /**
650      * @dev Returns true if `account` is a contract.
651      *
652      * [IMPORTANT]
653      * ====
654      * It is unsafe to assume that an address for which this function returns
655      * false is an externally-owned account (EOA) and not a contract.
656      *
657      * Among others, `isContract` will return false for the following
658      * types of addresses:
659      *
660      *  - an externally-owned account
661      *  - a contract in construction
662      *  - an address where a contract will be created
663      *  - an address where a contract lived, but was destroyed
664      * ====
665      */
666     function isContract(address account) internal view returns (bool) {
667         // This method relies on extcodesize, which returns 0 for contracts in
668         // construction, since the code is only stored at the end of the
669         // constructor execution.
670 
671         uint256 size;
672         // solhint-disable-next-line no-inline-assembly
673         assembly {
674             size := extcodesize(account)
675         }
676         return size > 0;
677     }
678 
679     /**
680      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
681      * `recipient`, forwarding all available gas and reverting on errors.
682      *
683      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
684      * of certain opcodes, possibly making contracts go over the 2300 gas limit
685      * imposed by `transfer`, making them unable to receive funds via
686      * `transfer`. {sendValue} removes this limitation.
687      *
688      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
689      *
690      * IMPORTANT: because control is transferred to `recipient`, care must be
691      * taken to not create reentrancy vulnerabilities. Consider using
692      * {ReentrancyGuard} or the
693      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
694      */
695     function sendValue(address payable recipient, uint256 amount) internal {
696         require(
697             address(this).balance >= amount,
698             "Address: insufficient balance"
699         );
700 
701         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
702         (bool success, ) = recipient.call{value: amount}("");
703         require(
704             success,
705             "Address: unable to send value, recipient may have reverted"
706         );
707     }
708 
709     /**
710      * @dev Performs a Solidity function call using a low level `call`. A
711      * plain`call` is an unsafe replacement for a function call: use this
712      * function instead.
713      *
714      * If `target` reverts with a revert reason, it is bubbled up by this
715      * function (like regular Solidity function calls).
716      *
717      * Returns the raw returned data. To convert to the expected return value,
718      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
719      *
720      * Requirements:
721      *
722      * - `target` must be a contract.
723      * - calling `target` with `data` must not revert.
724      *
725      * _Available since v3.1._
726      */
727     function functionCall(address target, bytes memory data)
728         internal
729         returns (bytes memory)
730     {
731         return functionCall(target, data, "Address: low-level call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
736      * `errorMessage` as a fallback revert reason when `target` reverts.
737      *
738      * _Available since v3.1._
739      */
740     function functionCall(
741         address target,
742         bytes memory data,
743         string memory errorMessage
744     ) internal returns (bytes memory) {
745         return functionCallWithValue(target, data, 0, errorMessage);
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
750      * but also transferring `value` wei to `target`.
751      *
752      * Requirements:
753      *
754      * - the calling contract must have an ETH balance of at least `value`.
755      * - the called Solidity function must be `payable`.
756      *
757      * _Available since v3.1._
758      */
759     function functionCallWithValue(
760         address target,
761         bytes memory data,
762         uint256 value
763     ) internal returns (bytes memory) {
764         return
765             functionCallWithValue(
766                 target,
767                 data,
768                 value,
769                 "Address: low-level call with value failed"
770             );
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
775      * with `errorMessage` as a fallback revert reason when `target` reverts.
776      *
777      * _Available since v3.1._
778      */
779     function functionCallWithValue(
780         address target,
781         bytes memory data,
782         uint256 value,
783         string memory errorMessage
784     ) internal returns (bytes memory) {
785         require(
786             address(this).balance >= value,
787             "Address: insufficient balance for call"
788         );
789         require(isContract(target), "Address: call to non-contract");
790 
791         // solhint-disable-next-line avoid-low-level-calls
792         (bool success, bytes memory returndata) = target.call{value: value}(
793             data
794         );
795         return _verifyCallResult(success, returndata, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but performing a static call.
801      *
802      * _Available since v3.3._
803      */
804     function functionStaticCall(address target, bytes memory data)
805         internal
806         view
807         returns (bytes memory)
808     {
809         return
810             functionStaticCall(
811                 target,
812                 data,
813                 "Address: low-level static call failed"
814             );
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
819      * but performing a static call.
820      *
821      * _Available since v3.3._
822      */
823     function functionStaticCall(
824         address target,
825         bytes memory data,
826         string memory errorMessage
827     ) internal view returns (bytes memory) {
828         require(isContract(target), "Address: static call to non-contract");
829 
830         // solhint-disable-next-line avoid-low-level-calls
831         (bool success, bytes memory returndata) = target.staticcall(data);
832         return _verifyCallResult(success, returndata, errorMessage);
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
837      * but performing a delegate call.
838      *
839      * _Available since v3.4._
840      */
841     function functionDelegateCall(address target, bytes memory data)
842         internal
843         returns (bytes memory)
844     {
845         return
846             functionDelegateCall(
847                 target,
848                 data,
849                 "Address: low-level delegate call failed"
850             );
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
855      * but performing a delegate call.
856      *
857      * _Available since v3.4._
858      */
859     function functionDelegateCall(
860         address target,
861         bytes memory data,
862         string memory errorMessage
863     ) internal returns (bytes memory) {
864         require(isContract(target), "Address: delegate call to non-contract");
865 
866         // solhint-disable-next-line avoid-low-level-calls
867         (bool success, bytes memory returndata) = target.delegatecall(data);
868         return _verifyCallResult(success, returndata, errorMessage);
869     }
870 
871     function _verifyCallResult(
872         bool success,
873         bytes memory returndata,
874         string memory errorMessage
875     ) private pure returns (bytes memory) {
876         if (success) {
877             return returndata;
878         } else {
879             // Look for revert reason and bubble it up if present
880             if (returndata.length > 0) {
881                 // The easiest way to bubble the revert reason is using memory via assembly
882 
883                 // solhint-disable-next-line no-inline-assembly
884                 assembly {
885                     let returndata_size := mload(returndata)
886                     revert(add(32, returndata), returndata_size)
887                 }
888             } else {
889                 revert(errorMessage);
890             }
891         }
892     }
893 }
894 
895 // File contracts/solidity/util/SafeERC20Upgradeable.sol
896 
897 pragma solidity ^0.8.0;
898 
899 /**
900  * @title SafeERC20
901  * @dev Wrappers around ERC20 operations that throw on failure (when the token
902  * contract returns false). Tokens that return no value (and instead revert or
903  * throw on failure) are also supported, non-reverting calls are assumed to be
904  * successful.
905  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
906  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
907  */
908 library SafeERC20Upgradeable {
909     using Address for address;
910 
911     function safeTransfer(
912         IERC20Upgradeable token,
913         address to,
914         uint256 value
915     ) internal {
916         _callOptionalReturn(
917             token,
918             abi.encodeWithSelector(token.transfer.selector, to, value)
919         );
920     }
921 
922     function safeTransferFrom(
923         IERC20Upgradeable token,
924         address from,
925         address to,
926         uint256 value
927     ) internal {
928         _callOptionalReturn(
929             token,
930             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
931         );
932     }
933 
934     /**
935      * @dev Deprecated. This function has issues similar to the ones found in
936      * {IERC20-approve}, and its usage is discouraged.
937      *
938      * Whenever possible, use {safeIncreaseAllowance} and
939      * {safeDecreaseAllowance} instead.
940      */
941     function safeApprove(
942         IERC20Upgradeable token,
943         address spender,
944         uint256 value
945     ) internal {
946         // safeApprove should only be called when setting an initial allowance,
947         // or when resetting it to zero. To increase and decrease it, use
948         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
949         // solhint-disable-next-line max-line-length
950         require(
951             (value == 0) || (token.allowance(address(this), spender) == 0),
952             "SafeERC20: approve from non-zero to non-zero allowance"
953         );
954         _callOptionalReturn(
955             token,
956             abi.encodeWithSelector(token.approve.selector, spender, value)
957         );
958     }
959 
960     function safeIncreaseAllowance(
961         IERC20Upgradeable token,
962         address spender,
963         uint256 value
964     ) internal {
965         uint256 newAllowance = token.allowance(address(this), spender) + value;
966         _callOptionalReturn(
967             token,
968             abi.encodeWithSelector(
969                 token.approve.selector,
970                 spender,
971                 newAllowance
972             )
973         );
974     }
975 
976     function safeDecreaseAllowance(
977         IERC20Upgradeable token,
978         address spender,
979         uint256 value
980     ) internal {
981         unchecked {
982             uint256 oldAllowance = token.allowance(address(this), spender);
983             require(
984                 oldAllowance >= value,
985                 "SafeERC20: decreased allowance below zero"
986             );
987             uint256 newAllowance = oldAllowance - value;
988             _callOptionalReturn(
989                 token,
990                 abi.encodeWithSelector(
991                     token.approve.selector,
992                     spender,
993                     newAllowance
994                 )
995             );
996         }
997     }
998 
999     /**
1000      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1001      * on the return value: the return value is optional (but if data is returned, it must not be false).
1002      * @param token The token targeted by the call.
1003      * @param data The call data (encoded using abi.encode or one of its variants).
1004      */
1005     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data)
1006         private
1007     {
1008         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1009         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1010         // the target address contains contract code and also asserts for success in the low-level call.
1011 
1012         bytes memory returndata = address(token).functionCall(
1013             data,
1014             "SafeERC20: low-level call failed"
1015         );
1016         if (returndata.length > 0) {
1017             // Return data is optional
1018             // solhint-disable-next-line max-line-length
1019             require(
1020                 abi.decode(returndata, (bool)),
1021                 "SafeERC20: ERC20 operation did not succeed"
1022             );
1023         }
1024     }
1025 }
1026 
1027 // File contracts/solidity/proxy/Initializable.sol
1028 
1029 // solhint-disable-next-line compiler-version
1030 pragma solidity ^0.8.0;
1031 
1032 /**
1033  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1034  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1035  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1036  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1037  *
1038  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1039  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1040  *
1041  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1042  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1043  */
1044 abstract contract Initializable {
1045     /**
1046      * @dev Indicates that the contract has been initialized.
1047      */
1048     bool private _initialized;
1049 
1050     /**
1051      * @dev Indicates that the contract is in the process of being initialized.
1052      */
1053     bool private _initializing;
1054 
1055     /**
1056      * @dev Modifier to protect an initializer function from being invoked twice.
1057      */
1058     modifier initializer() {
1059         require(
1060             _initializing || !_initialized,
1061             "Initializable: contract is already initialized"
1062         );
1063 
1064         bool isTopLevelCall = !_initializing;
1065         if (isTopLevelCall) {
1066             _initializing = true;
1067             _initialized = true;
1068         }
1069 
1070         _;
1071 
1072         if (isTopLevelCall) {
1073             _initializing = false;
1074         }
1075     }
1076 }
1077 
1078 // File contracts/solidity/util/ContextUpgradeable.sol
1079 
1080 pragma solidity ^0.8.0;
1081 
1082 /*
1083  * @dev Provides information about the current execution context, including the
1084  * sender of the transaction and its data. While these are generally available
1085  * via msg.sender and msg.data, they should not be accessed in such a direct
1086  * manner, since when dealing with meta-transactions the account sending and
1087  * paying for execution may not be the actual sender (as far as an application
1088  * is concerned).
1089  *
1090  * This contract is only required for intermediate, library-like contracts.
1091  */
1092 abstract contract ContextUpgradeable is Initializable {
1093     function __Context_init() internal initializer {
1094         __Context_init_unchained();
1095     }
1096 
1097     function __Context_init_unchained() internal initializer {}
1098 
1099     function _msgSender() internal view virtual returns (address) {
1100         return msg.sender;
1101     }
1102 
1103     function _msgData() internal view virtual returns (bytes calldata) {
1104         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1105         return msg.data;
1106     }
1107 
1108     uint256[50] private __gap;
1109 }
1110 
1111 // File contracts/solidity/util/OwnableUpgradeable.sol
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 /**
1116  * @dev Contract module which provides a basic access control mechanism, where
1117  * there is an account (an owner) that can be granted exclusive access to
1118  * specific functions.
1119  *
1120  * By default, the owner account will be the one that deploys the contract. This
1121  * can later be changed with {transferOwnership}.
1122  *
1123  * This module is used through inheritance. It will make available the modifier
1124  * `onlyOwner`, which can be applied to your functions to restrict their use to
1125  * the owner.
1126  */
1127 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1128     address private _owner;
1129 
1130     event OwnershipTransferred(
1131         address indexed previousOwner,
1132         address indexed newOwner
1133     );
1134 
1135     /**
1136      * @dev Initializes the contract setting the deployer as the initial owner.
1137      */
1138     function __Ownable_init() internal initializer {
1139         __Context_init_unchained();
1140         __Ownable_init_unchained();
1141     }
1142 
1143     function __Ownable_init_unchained() internal initializer {
1144         address msgSender = _msgSender();
1145         _owner = msgSender;
1146         emit OwnershipTransferred(address(0), msgSender);
1147     }
1148 
1149     /**
1150      * @dev Returns the address of the current owner.
1151      */
1152     function owner() public view virtual returns (address) {
1153         return _owner;
1154     }
1155 
1156     /**
1157      * @dev Throws if called by any account other than the owner.
1158      */
1159     modifier onlyOwner() {
1160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1161         _;
1162     }
1163 
1164     /**
1165      * @dev Leaves the contract without owner. It will not be possible to call
1166      * `onlyOwner` functions anymore. Can only be called by the current owner.
1167      *
1168      * NOTE: Renouncing ownership will leave the contract without an owner,
1169      * thereby removing any functionality that is only available to the owner.
1170      */
1171     function renounceOwnership() public virtual onlyOwner {
1172         emit OwnershipTransferred(_owner, address(0));
1173         _owner = address(0);
1174     }
1175 
1176     /**
1177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1178      * Can only be called by the current owner.
1179      */
1180     function transferOwnership(address newOwner) public virtual onlyOwner {
1181         require(
1182             newOwner != address(0),
1183             "Ownable: new owner is the zero address"
1184         );
1185         emit OwnershipTransferred(_owner, newOwner);
1186         _owner = newOwner;
1187     }
1188 
1189     uint256[49] private __gap;
1190 }
1191 
1192 // File contracts/solidity/util/PausableUpgradeable.sol
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 contract PausableUpgradeable is OwnableUpgradeable {
1197     function __Pausable_init() internal initializer {
1198         __Ownable_init();
1199     }
1200 
1201     event SetPaused(uint256 lockId, bool paused);
1202     event SetIsGuardian(address addr, bool isGuardian);
1203 
1204     mapping(address => bool) public isGuardian;
1205     mapping(uint256 => bool) public isPaused;
1206 
1207     // 0 : createVault
1208     // 1 : mint
1209     // 2 : redeem
1210     // 3 : swap
1211     // 4 : flashloan
1212 
1213     function onlyOwnerIfPaused(uint256 lockId) public view virtual {
1214         require(!isPaused[lockId] || msg.sender == owner(), "Paused");
1215     }
1216 
1217     function unpause(uint256 lockId) public virtual onlyOwner {
1218         isPaused[lockId] = false;
1219         emit SetPaused(lockId, false);
1220     }
1221 
1222     function pause(uint256 lockId) public virtual {
1223         require(isGuardian[msg.sender], "Can't pause");
1224         isPaused[lockId] = true;
1225         emit SetPaused(lockId, true);
1226     }
1227 
1228     function setIsGuardian(address addr, bool _isGuardian)
1229         public
1230         virtual
1231         onlyOwner
1232     {
1233         isGuardian[addr] = _isGuardian;
1234         emit SetIsGuardian(addr, _isGuardian);
1235     }
1236 }
1237 
1238 // File contracts/solidity/util/Create2.sol
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 /**
1243  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
1244  * `CREATE2` can be used to compute in advance the address where a smart
1245  * contract will be deployed, which allows for interesting new mechanisms known
1246  * as 'counterfactual interactions'.
1247  *
1248  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
1249  * information.
1250  */
1251 library Create2 {
1252     /**
1253      * @dev Deploys a contract using `CREATE2`. The address where the contract
1254      * will be deployed can be known in advance via {computeAddress}.
1255      *
1256      * The bytecode for a contract can be obtained from Solidity with
1257      * `type(contractName).creationCode`.
1258      *
1259      * Requirements:
1260      *
1261      * - `bytecode` must not be empty.
1262      * - `salt` must have not been used for `bytecode` already.
1263      * - the factory must have a balance of at least `amount`.
1264      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
1265      */
1266     function deploy(
1267         uint256 amount,
1268         bytes32 salt,
1269         bytes memory bytecode
1270     ) internal returns (address) {
1271         address addr;
1272         require(
1273             address(this).balance >= amount,
1274             "Create2: insufficient balance"
1275         );
1276         require(bytecode.length != 0, "Create2: bytecode length is zero");
1277         // solhint-disable-next-line no-inline-assembly
1278         assembly {
1279             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
1280         }
1281         require(addr != address(0), "Create2: Failed on deploy");
1282         return addr;
1283     }
1284 
1285     /**
1286      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
1287      * `bytecodeHash` or `salt` will result in a new destination address.
1288      */
1289     function computeAddress(bytes32 salt, bytes32 bytecodeHash)
1290         internal
1291         view
1292         returns (address)
1293     {
1294         return computeAddress(salt, bytecodeHash, address(this));
1295     }
1296 
1297     /**
1298      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
1299      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
1300      */
1301     function computeAddress(
1302         bytes32 salt,
1303         bytes32 bytecodeHash,
1304         address deployer
1305     ) internal pure returns (address) {
1306         bytes32 _data = keccak256(
1307             abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)
1308         );
1309         return address(uint160(uint256(_data)));
1310     }
1311 }
1312 
1313 // File contracts/solidity/proxy/UpgradeableBeacon.sol
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 /**
1318  * @dev This contract is used in conjunction with one or more instances of {BeaconProxy} to determine their
1319  * implementation contract, which is where they will delegate all function calls.
1320  *
1321  * An owner is able to change the implementation the beacon points to, thus upgrading the proxies that use this beacon.
1322  */
1323 contract UpgradeableBeacon is IBeacon, OwnableUpgradeable {
1324     address private _childImplementation;
1325 
1326     /**
1327      * @dev Emitted when the child implementation returned by the beacon is changed.
1328      */
1329     event Upgraded(address indexed childImplementation);
1330 
1331     /**
1332      * @dev Sets the address of the initial implementation, and the deployer account as the owner who can upgrade the
1333      * beacon.
1334      */
1335     function __UpgradeableBeacon__init(address childImplementation_)
1336         public
1337         initializer
1338     {
1339         _setChildImplementation(childImplementation_);
1340     }
1341 
1342     /**
1343      * @dev Returns the current child implementation address.
1344      */
1345     function childImplementation()
1346         public
1347         view
1348         virtual
1349         override
1350         returns (address)
1351     {
1352         return _childImplementation;
1353     }
1354 
1355     /**
1356      * @dev Upgrades the beacon to a new implementation.
1357      *
1358      * Emits an {Upgraded} event.
1359      *
1360      * Requirements:
1361      *
1362      * - msg.sender must be the owner of the contract.
1363      * - `newChildImplementation` must be a contract.
1364      */
1365     function upgradeChildTo(address newChildImplementation)
1366         public
1367         virtual
1368         override
1369         onlyOwner
1370     {
1371         _setChildImplementation(newChildImplementation);
1372     }
1373 
1374     /**
1375      * @dev Sets the implementation contract address for this beacon
1376      *
1377      * Requirements:
1378      *
1379      * - `newChildImplementation` must be a contract.
1380      */
1381     function _setChildImplementation(address newChildImplementation) private {
1382         require(
1383             Address.isContract(newChildImplementation),
1384             "UpgradeableBeacon: child implementation is not a contract"
1385         );
1386         _childImplementation = newChildImplementation;
1387         emit Upgraded(newChildImplementation);
1388     }
1389 }
1390 
1391 // File contracts/solidity/proxy/Proxy.sol
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 /**
1396  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
1397  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
1398  * be specified by overriding the virtual {_implementation} function.
1399  *
1400  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
1401  * different contract through the {_delegate} function.
1402  *
1403  * The success and return data of the delegated call will be returned back to the caller of the proxy.
1404  */
1405 abstract contract Proxy {
1406     /**
1407      * @dev Delegates the current call to `implementation`.
1408      *
1409      * This function does not return to its internall call site, it will return directly to the external caller.
1410      */
1411     function _delegate(address implementation) internal virtual {
1412         // solhint-disable-next-line no-inline-assembly
1413         assembly {
1414             // Copy msg.data. We take full control of memory in this inline assembly
1415             // block because it will not return to Solidity code. We overwrite the
1416             // Solidity scratch pad at memory position 0.
1417             calldatacopy(0, 0, calldatasize())
1418 
1419             // Call the implementation.
1420             // out and outsize are 0 because we don't know the size yet.
1421             let result := delegatecall(
1422                 gas(),
1423                 implementation,
1424                 0,
1425                 calldatasize(),
1426                 0,
1427                 0
1428             )
1429 
1430             // Copy the returned data.
1431             returndatacopy(0, 0, returndatasize())
1432 
1433             switch result
1434             // delegatecall returns 0 on error.
1435             case 0 {
1436                 revert(0, returndatasize())
1437             }
1438             default {
1439                 return(0, returndatasize())
1440             }
1441         }
1442     }
1443 
1444     /**
1445      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
1446      * and {_fallback} should delegate.
1447      */
1448     function _implementation() internal view virtual returns (address);
1449 
1450     /**
1451      * @dev Delegates the current call to the address returned by `_implementation()`.
1452      *
1453      * This function does not return to its internall call site, it will return directly to the external caller.
1454      */
1455     function _fallback() internal virtual {
1456         _beforeFallback();
1457         _delegate(_implementation());
1458     }
1459 
1460     /**
1461      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
1462      * function in the contract matches the call data.
1463      */
1464     fallback() external payable virtual {
1465         _fallback();
1466     }
1467 
1468     /**
1469      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
1470      * is empty.
1471      */
1472     receive() external payable virtual {
1473         _fallback();
1474     }
1475 
1476     /**
1477      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
1478      * call, or as part of the Solidity `fallback` or `receive` functions.
1479      *
1480      * If overriden should call `super._beforeFallback()`.
1481      */
1482     function _beforeFallback() internal virtual {}
1483 }
1484 
1485 // File contracts/solidity/proxy/Create2BeaconProxy.sol
1486 
1487 pragma solidity ^0.8.0;
1488 
1489 /**
1490  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
1491  * Slightly modified to allow using beacon proxies with Create2.
1492  *
1493  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
1494  * conflict with the storage layout of the implementation behind the proxy.
1495  *
1496  * _Available since v3.4._
1497  */
1498 contract Create2BeaconProxy is Proxy {
1499     /**
1500      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
1501      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
1502      */
1503     bytes32 private constant _BEACON_SLOT =
1504         0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
1505 
1506     /**
1507      * @dev Initializes the proxy with `beacon`.
1508      *
1509      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
1510      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
1511      * constructor.
1512      *
1513      * Requirements:
1514      *
1515      * - `beacon` must be a contract with the interface {IBeacon}.
1516      */
1517     constructor() payable {
1518         assert(
1519             _BEACON_SLOT ==
1520                 bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1)
1521         );
1522         _setBeacon(msg.sender, "");
1523     }
1524 
1525     /**
1526      * @dev Returns the current beacon address.
1527      */
1528     function _beacon() internal view virtual returns (address beacon) {
1529         bytes32 slot = _BEACON_SLOT;
1530         // solhint-disable-next-line no-inline-assembly
1531         assembly {
1532             beacon := sload(slot)
1533         }
1534     }
1535 
1536     /**
1537      * @dev Returns the current implementation address of the associated beacon.
1538      */
1539     function _implementation()
1540         internal
1541         view
1542         virtual
1543         override
1544         returns (address)
1545     {
1546         return IBeacon(_beacon()).childImplementation();
1547     }
1548 
1549     /**
1550      * @dev Changes the proxy to use a new beacon.
1551      *
1552      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
1553      *
1554      * Requirements:
1555      *
1556      * - `beacon` must be a contract.
1557      * - The implementation returned by `beacon` must be a contract.
1558      */
1559     function _setBeacon(address beacon, bytes memory data) internal virtual {
1560         require(
1561             Address.isContract(beacon),
1562             "BeaconProxy: beacon is not a contract"
1563         );
1564         require(
1565             Address.isContract(IBeacon(beacon).childImplementation()),
1566             "BeaconProxy: beacon implementation is not a contract"
1567         );
1568         bytes32 slot = _BEACON_SLOT;
1569 
1570         // solhint-disable-next-line no-inline-assembly
1571         assembly {
1572             sstore(slot, beacon)
1573         }
1574 
1575         if (data.length > 0) {
1576             Address.functionDelegateCall(
1577                 _implementation(),
1578                 data,
1579                 "BeaconProxy: function call failed"
1580             );
1581         }
1582     }
1583 }
1584 
1585 // File contracts/solidity/token/ERC20Upgradeable.sol
1586 
1587 pragma solidity ^0.8.0;
1588 
1589 /**
1590  * @dev Implementation of the {IERC20} interface.
1591  *
1592  * This implementation is agnostic to the way tokens are created. This means
1593  * that a supply mechanism has to be added in a derived contract using {_mint}.
1594  * For a generic mechanism see {ERC20PresetMinterPauser}.
1595  *
1596  * TIP: For a detailed writeup see our guide
1597  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1598  * to implement supply mechanisms].
1599  *
1600  * We have followed general OpenZeppelin guidelines: functions revert instead
1601  * of returning `false` on failure. This behavior is nonetheless conventional
1602  * and does not conflict with the expectations of ERC20 applications.
1603  *
1604  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1605  * This allows applications to reconstruct the allowance for all accounts just
1606  * by listening to said events. Other implementations of the EIP may not emit
1607  * these events, as it isn't required by the specification.
1608  *
1609  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1610  * functions have been added to mitigate the well-known issues around setting
1611  * allowances. See {IERC20-approve}.
1612  */
1613 contract ERC20Upgradeable is
1614     Initializable,
1615     ContextUpgradeable,
1616     IERC20Upgradeable,
1617     IERC20Metadata
1618 {
1619     mapping(address => uint256) private _balances;
1620 
1621     mapping(address => mapping(address => uint256)) private _allowances;
1622 
1623     uint256 private _totalSupply;
1624 
1625     string private _name;
1626     string private _symbol;
1627 
1628     /**
1629      * @dev Sets the values for {name} and {symbol}.
1630      *
1631      * The default value of {decimals} is 18. To select a different value for
1632      * {decimals} you should overload it.
1633      *
1634      * All two of these values are immutable: they can only be set once during
1635      * construction.
1636      */
1637     function __ERC20_init(string memory name_, string memory symbol_)
1638         internal
1639         initializer
1640     {
1641         __Context_init_unchained();
1642         __ERC20_init_unchained(name_, symbol_);
1643     }
1644 
1645     function __ERC20_init_unchained(string memory name_, string memory symbol_)
1646         internal
1647         initializer
1648     {
1649         _name = name_;
1650         _symbol = symbol_;
1651     }
1652 
1653     function _setMetadata(string memory name_, string memory symbol_) internal {
1654         _name = name_;
1655         _symbol = symbol_;
1656     }
1657 
1658     /**
1659      * @dev Returns the name of the token.
1660      */
1661     function name() public view virtual override returns (string memory) {
1662         return _name;
1663     }
1664 
1665     /**
1666      * @dev Returns the symbol of the token, usually a shorter version of the
1667      * name.
1668      */
1669     function symbol() public view virtual override returns (string memory) {
1670         return _symbol;
1671     }
1672 
1673     /**
1674      * @dev Returns the number of decimals used to get its user representation.
1675      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1676      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1677      *
1678      * Tokens usually opt for a value of 18, imitating the relationship between
1679      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1680      * overridden;
1681      *
1682      * NOTE: This information is only used for _display_ purposes: it in
1683      * no way affects any of the arithmetic of the contract, including
1684      * {IERC20-balanceOf} and {IERC20-transfer}.
1685      */
1686     function decimals() public view virtual override returns (uint8) {
1687         return 18;
1688     }
1689 
1690     /**
1691      * @dev See {IERC20-totalSupply}.
1692      */
1693     function totalSupply() public view virtual override returns (uint256) {
1694         return _totalSupply;
1695     }
1696 
1697     /**
1698      * @dev See {IERC20-balanceOf}.
1699      */
1700     function balanceOf(address account)
1701         public
1702         view
1703         virtual
1704         override
1705         returns (uint256)
1706     {
1707         return _balances[account];
1708     }
1709 
1710     /**
1711      * @dev See {IERC20-transfer}.
1712      *
1713      * Requirements:
1714      *
1715      * - `recipient` cannot be the zero address.
1716      * - the caller must have a balance of at least `amount`.
1717      */
1718     function transfer(address recipient, uint256 amount)
1719         public
1720         virtual
1721         override
1722         returns (bool)
1723     {
1724         _transfer(_msgSender(), recipient, amount);
1725         return true;
1726     }
1727 
1728     /**
1729      * @dev See {IERC20-allowance}.
1730      */
1731     function allowance(address owner, address spender)
1732         public
1733         view
1734         virtual
1735         override
1736         returns (uint256)
1737     {
1738         return _allowances[owner][spender];
1739     }
1740 
1741     /**
1742      * @dev See {IERC20-approve}.
1743      *
1744      * Requirements:
1745      *
1746      * - `spender` cannot be the zero address.
1747      */
1748     function approve(address spender, uint256 amount)
1749         public
1750         virtual
1751         override
1752         returns (bool)
1753     {
1754         _approve(_msgSender(), spender, amount);
1755         return true;
1756     }
1757 
1758     /**
1759      * @dev See {IERC20-transferFrom}.
1760      *
1761      * Emits an {Approval} event indicating the updated allowance. This is not
1762      * required by the EIP. See the note at the beginning of {ERC20}.
1763      *
1764      * Requirements:
1765      *
1766      * - `sender` and `recipient` cannot be the zero address.
1767      * - `sender` must have a balance of at least `amount`.
1768      * - the caller must have allowance for ``sender``'s tokens of at least
1769      * `amount`.
1770      */
1771     function transferFrom(
1772         address sender,
1773         address recipient,
1774         uint256 amount
1775     ) public virtual override returns (bool) {
1776         _transfer(sender, recipient, amount);
1777 
1778         uint256 currentAllowance = _allowances[sender][_msgSender()];
1779         require(
1780             currentAllowance >= amount,
1781             "ERC20: transfer amount exceeds allowance"
1782         );
1783         _approve(sender, _msgSender(), currentAllowance - amount);
1784 
1785         return true;
1786     }
1787 
1788     /**
1789      * @dev Atomically increases the allowance granted to `spender` by the caller.
1790      *
1791      * This is an alternative to {approve} that can be used as a mitigation for
1792      * problems described in {IERC20-approve}.
1793      *
1794      * Emits an {Approval} event indicating the updated allowance.
1795      *
1796      * Requirements:
1797      *
1798      * - `spender` cannot be the zero address.
1799      */
1800     function increaseAllowance(address spender, uint256 addedValue)
1801         public
1802         virtual
1803         returns (bool)
1804     {
1805         _approve(
1806             _msgSender(),
1807             spender,
1808             _allowances[_msgSender()][spender] + addedValue
1809         );
1810         return true;
1811     }
1812 
1813     /**
1814      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1815      *
1816      * This is an alternative to {approve} that can be used as a mitigation for
1817      * problems described in {IERC20-approve}.
1818      *
1819      * Emits an {Approval} event indicating the updated allowance.
1820      *
1821      * Requirements:
1822      *
1823      * - `spender` cannot be the zero address.
1824      * - `spender` must have allowance for the caller of at least
1825      * `subtractedValue`.
1826      */
1827     function decreaseAllowance(address spender, uint256 subtractedValue)
1828         public
1829         virtual
1830         returns (bool)
1831     {
1832         uint256 currentAllowance = _allowances[_msgSender()][spender];
1833         require(
1834             currentAllowance >= subtractedValue,
1835             "ERC20: decreased allowance below zero"
1836         );
1837         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1838 
1839         return true;
1840     }
1841 
1842     /**
1843      * @dev Moves tokens `amount` from `sender` to `recipient`.
1844      *
1845      * This is internal function is equivalent to {transfer}, and can be used to
1846      * e.g. implement automatic token fees, slashing mechanisms, etc.
1847      *
1848      * Emits a {Transfer} event.
1849      *
1850      * Requirements:
1851      *
1852      * - `sender` cannot be the zero address.
1853      * - `recipient` cannot be the zero address.
1854      * - `sender` must have a balance of at least `amount`.
1855      */
1856     function _transfer(
1857         address sender,
1858         address recipient,
1859         uint256 amount
1860     ) internal virtual {
1861         require(sender != address(0), "ERC20: transfer from the zero address");
1862         require(recipient != address(0), "ERC20: transfer to the zero address");
1863 
1864         _beforeTokenTransfer(sender, recipient, amount);
1865 
1866         uint256 senderBalance = _balances[sender];
1867         require(
1868             senderBalance >= amount,
1869             "ERC20: transfer amount exceeds balance"
1870         );
1871         _balances[sender] = senderBalance - amount;
1872         _balances[recipient] += amount;
1873 
1874         emit Transfer(sender, recipient, amount);
1875     }
1876 
1877     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1878      * the total supply.
1879      *
1880      * Emits a {Transfer} event with `from` set to the zero address.
1881      *
1882      * Requirements:
1883      *
1884      * - `account` cannot be the zero address.
1885      */
1886     function _mint(address account, uint256 amount) internal virtual {
1887         require(account != address(0), "ERC20: mint to the zero address");
1888 
1889         _beforeTokenTransfer(address(0), account, amount);
1890 
1891         _totalSupply += amount;
1892         _balances[account] += amount;
1893         emit Transfer(address(0), account, amount);
1894     }
1895 
1896     /**
1897      * @dev Destroys `amount` tokens from `account`, reducing the
1898      * total supply.
1899      *
1900      * Emits a {Transfer} event with `to` set to the zero address.
1901      *
1902      * Requirements:
1903      *
1904      * - `account` cannot be the zero address.
1905      * - `account` must have at least `amount` tokens.
1906      */
1907     function _burn(address account, uint256 amount) internal virtual {
1908         require(account != address(0), "ERC20: burn from the zero address");
1909 
1910         _beforeTokenTransfer(account, address(0), amount);
1911 
1912         uint256 accountBalance = _balances[account];
1913         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1914         _balances[account] = accountBalance - amount;
1915         _totalSupply -= amount;
1916 
1917         emit Transfer(account, address(0), amount);
1918     }
1919 
1920     /**
1921      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1922      *
1923      * This internal function is equivalent to `approve`, and can be used to
1924      * e.g. set automatic allowances for certain subsystems, etc.
1925      *
1926      * Emits an {Approval} event.
1927      *
1928      * Requirements:
1929      *
1930      * - `owner` cannot be the zero address.
1931      * - `spender` cannot be the zero address.
1932      */
1933     function _approve(
1934         address owner,
1935         address spender,
1936         uint256 amount
1937     ) internal virtual {
1938         require(owner != address(0), "ERC20: approve from the zero address");
1939         require(spender != address(0), "ERC20: approve to the zero address");
1940 
1941         _allowances[owner][spender] = amount;
1942         emit Approval(owner, spender, amount);
1943     }
1944 
1945     /**
1946      * @dev Hook that is called before any transfer of tokens. This includes
1947      * minting and burning.
1948      *
1949      * Calling conditions:
1950      *
1951      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1952      * will be to transferred to `to`.
1953      * - when `from` is zero, `amount` tokens will be minted for `to`.
1954      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1955      * - `from` and `to` are never both zero.
1956      *
1957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1958      */
1959     function _beforeTokenTransfer(
1960         address from,
1961         address to,
1962         uint256 amount
1963     ) internal virtual {}
1964 
1965     uint256[45] private __gap;
1966 }
1967 
1968 // File contracts/solidity/token/XTokenUpgradeable.sol
1969 
1970 pragma solidity ^0.8.0;
1971 
1972 // XTokens let uou come in with some vault tokens, and leave with more! The longer you stay, the more vault tokens you get.
1973 //
1974 // This contract handles swapping to and from xSushi, SushiSwap's staking token.
1975 contract XTokenUpgradeable is OwnableUpgradeable, ERC20Upgradeable {
1976     using SafeERC20Upgradeable for IERC20Upgradeable;
1977 
1978     uint256 internal constant MAX_TIMELOCK = 2592000;
1979     IERC20Upgradeable public baseToken;
1980 
1981     mapping(address => uint256) internal timelock;
1982 
1983     event Timelocked(address user, uint256 until);
1984 
1985     function __XToken_init(
1986         address _baseToken,
1987         string memory name,
1988         string memory symbol
1989     ) public initializer {
1990         __Ownable_init();
1991         // string memory _name = INFTXInventoryStaking(msg.sender).nftxVaultFactory().vault();
1992         __ERC20_init(name, symbol);
1993         baseToken = IERC20Upgradeable(_baseToken);
1994     }
1995 
1996     // Needs to be called BEFORE new base tokens are deposited.
1997     function mintXTokens(
1998         address account,
1999         uint256 _amount,
2000         uint256 timelockLength
2001     ) external onlyOwner returns (uint256) {
2002         // Gets the amount of Base Token locked in the contract
2003         uint256 totalBaseToken = baseToken.balanceOf(address(this));
2004         // Gets the amount of xTokens in existence
2005         uint256 totalShares = totalSupply();
2006         // If no xTokens exist, mint it 1:1 to the amount put in
2007         if (totalShares == 0 || totalBaseToken == 0) {
2008             _timelockMint(account, _amount, timelockLength);
2009             return _amount;
2010         }
2011         // Calculate and mint the amount of xTokens the base tokens are worth. The ratio will change overtime, as xTokens are burned/minted and base tokens deposited + gained from fees / withdrawn.
2012         else {
2013             uint256 what = (_amount * totalShares) / totalBaseToken;
2014             _timelockMint(account, what, timelockLength);
2015             return what;
2016         }
2017     }
2018 
2019     function burnXTokens(address who, uint256 _share)
2020         external
2021         onlyOwner
2022         returns (uint256)
2023     {
2024         // Gets the amount of xToken in existence
2025         uint256 totalShares = totalSupply();
2026         // Calculates the amount of base tokens the xToken is worth
2027         uint256 what = (_share * baseToken.balanceOf(address(this))) /
2028             totalShares;
2029         _burn(who, _share);
2030         baseToken.safeTransfer(who, what);
2031         return what;
2032     }
2033 
2034     function timelockAccount(address account, uint256 timelockLength)
2035         public
2036         virtual
2037         onlyOwner
2038     {
2039         require(timelockLength < MAX_TIMELOCK, "Too long lock");
2040         uint256 timelockFinish = block.timestamp + timelockLength;
2041         if (timelockFinish > timelock[account]) {
2042             timelock[account] = timelockFinish;
2043             emit Timelocked(account, timelockFinish);
2044         }
2045     }
2046 
2047     function _burn(address who, uint256 amount) internal override {
2048         require(block.timestamp > timelock[who], "User locked");
2049         super._burn(who, amount);
2050     }
2051 
2052     function timelockUntil(address account) public view returns (uint256) {
2053         return timelock[account];
2054     }
2055 
2056     function _timelockMint(
2057         address account,
2058         uint256 amount,
2059         uint256 timelockLength
2060     ) internal virtual {
2061         timelockAccount(account, timelockLength);
2062         _mint(account, amount);
2063     }
2064 
2065     function _transfer(
2066         address from,
2067         address to,
2068         uint256 value
2069     ) internal override {
2070         require(block.timestamp > timelock[from], "User locked");
2071         super._transfer(from, to, value);
2072     }
2073 }
2074 
2075 // File contracts/solidity/NFTXInventoryStaking.sol
2076 
2077 pragma solidity ^0.8.0;
2078 
2079 // Author: 0xKiwi.
2080 
2081 // Pausing codes for inventory staking are:
2082 // 10: Deposit
2083 
2084 contract NFTXInventoryStaking is
2085     PausableUpgradeable,
2086     UpgradeableBeacon,
2087     INFTXInventoryStaking
2088 {
2089     using SafeERC20Upgradeable for IERC20Upgradeable;
2090 
2091     // Small locktime to prevent flash deposits.
2092     uint256 internal constant DEFAULT_LOCKTIME = 2;
2093     bytes internal constant beaconCode = type(Create2BeaconProxy).creationCode;
2094 
2095     INFTXVaultFactory public override nftxVaultFactory;
2096 
2097     event XTokenCreated(uint256 vaultId, address baseToken, address xToken);
2098     event Deposit(
2099         uint256 vaultId,
2100         uint256 baseTokenAmount,
2101         uint256 xTokenAmount,
2102         uint256 timelockUntil,
2103         address sender
2104     );
2105     event Withdraw(
2106         uint256 vaultId,
2107         uint256 baseTokenAmount,
2108         uint256 xTokenAmount,
2109         address sender
2110     );
2111     event FeesReceived(uint256 vaultId, uint256 amount);
2112 
2113     function __NFTXInventoryStaking_init(address _nftxVaultFactory)
2114         external
2115         virtual
2116         override
2117         initializer
2118     {
2119         __Ownable_init();
2120         nftxVaultFactory = INFTXVaultFactory(_nftxVaultFactory);
2121         address xTokenImpl = address(new XTokenUpgradeable());
2122         __UpgradeableBeacon__init(xTokenImpl);
2123     }
2124 
2125     modifier onlyAdmin() {
2126         require(
2127             msg.sender == owner() ||
2128                 msg.sender == nftxVaultFactory.feeDistributor(),
2129             "LPStaking: Not authorized"
2130         );
2131         _;
2132     }
2133 
2134     function deployXTokenForVault(uint256 vaultId) public virtual override {
2135         address baseToken = nftxVaultFactory.vault(vaultId);
2136         address deployedXToken = xTokenAddr(address(baseToken));
2137 
2138         if (isContract(deployedXToken)) {
2139             return;
2140         }
2141 
2142         address xToken = _deployXToken(baseToken);
2143         emit XTokenCreated(vaultId, baseToken, xToken);
2144     }
2145 
2146     function receiveRewards(uint256 vaultId, uint256 amount)
2147         external
2148         virtual
2149         override
2150         onlyAdmin
2151         returns (bool)
2152     {
2153         address baseToken = nftxVaultFactory.vault(vaultId);
2154         address deployedXToken = xTokenAddr(address(baseToken));
2155 
2156         // Don't distribute rewards unless there are people to distribute to.
2157         // Also added here if the distribution token is not deployed, just forfeit rewards for now.
2158         if (
2159             !isContract(deployedXToken) ||
2160             XTokenUpgradeable(deployedXToken).totalSupply() == 0
2161         ) {
2162             return false;
2163         }
2164         // We "pull" to the dividend tokens so the fee distributor only needs to approve this contract.
2165         IERC20Upgradeable(baseToken).safeTransferFrom(
2166             msg.sender,
2167             deployedXToken,
2168             amount
2169         );
2170         emit FeesReceived(vaultId, amount);
2171         return true;
2172     }
2173 
2174     // Enter staking. Staking, get minted shares and
2175     // locks base tokens and mints xTokens.
2176     function deposit(uint256 vaultId, uint256 _amount)
2177         external
2178         virtual
2179         override
2180     {
2181         onlyOwnerIfPaused(10);
2182 
2183         (
2184             IERC20Upgradeable baseToken,
2185             XTokenUpgradeable xToken,
2186             uint256 xTokensMinted
2187         ) = _timelockMintFor(vaultId, msg.sender, _amount, DEFAULT_LOCKTIME);
2188         // Lock the base token in the xtoken contract
2189         baseToken.safeTransferFrom(msg.sender, address(xToken), _amount);
2190         emit Deposit(
2191             vaultId,
2192             _amount,
2193             xTokensMinted,
2194             DEFAULT_LOCKTIME,
2195             msg.sender
2196         );
2197     }
2198 
2199     function timelockMintFor(
2200         uint256 vaultId,
2201         uint256 amount,
2202         address to,
2203         uint256 timelockLength
2204     ) external virtual override returns (uint256) {
2205         onlyOwnerIfPaused(10);
2206         require(msg.sender == nftxVaultFactory.zapContract(), "Not a zap");
2207         require(
2208             nftxVaultFactory.excludedFromFees(msg.sender),
2209             "Not fee excluded"
2210         );
2211 
2212         (, , uint256 xTokensMinted) = _timelockMintFor(
2213             vaultId,
2214             to,
2215             amount,
2216             timelockLength
2217         );
2218         emit Deposit(vaultId, amount, xTokensMinted, timelockLength, to);
2219         return xTokensMinted;
2220     }
2221 
2222     // Leave the bar. Claim back your tokens.
2223     // Unlocks the staked + gained tokens and burns xTokens.
2224     function withdraw(uint256 vaultId, uint256 _share)
2225         external
2226         virtual
2227         override
2228     {
2229         IERC20Upgradeable baseToken = IERC20Upgradeable(
2230             nftxVaultFactory.vault(vaultId)
2231         );
2232         XTokenUpgradeable xToken = XTokenUpgradeable(
2233             xTokenAddr(address(baseToken))
2234         );
2235 
2236         uint256 baseTokensRedeemed = xToken.burnXTokens(msg.sender, _share);
2237         emit Withdraw(vaultId, baseTokensRedeemed, _share, msg.sender);
2238     }
2239 
2240     function xTokenShareValue(uint256 vaultId)
2241         external
2242         view
2243         virtual
2244         override
2245         returns (uint256)
2246     {
2247         IERC20Upgradeable baseToken = IERC20Upgradeable(
2248             nftxVaultFactory.vault(vaultId)
2249         );
2250         XTokenUpgradeable xToken = XTokenUpgradeable(
2251             xTokenAddr(address(baseToken))
2252         );
2253         require(address(xToken) != address(0), "XToken not deployed");
2254 
2255         uint256 multiplier = 10**18;
2256         return
2257             xToken.totalSupply() > 0
2258                 ? (multiplier * baseToken.balanceOf(address(xToken))) /
2259                     xToken.totalSupply()
2260                 : multiplier;
2261     }
2262 
2263     function timelockUntil(uint256 vaultId, address who)
2264         external
2265         view
2266         returns (uint256)
2267     {
2268         XTokenUpgradeable xToken = XTokenUpgradeable(vaultXToken(vaultId));
2269         return xToken.timelockUntil(who);
2270     }
2271 
2272     function balanceOf(uint256 vaultId, address who)
2273         external
2274         view
2275         returns (uint256)
2276     {
2277         XTokenUpgradeable xToken = XTokenUpgradeable(vaultXToken(vaultId));
2278         return xToken.balanceOf(who);
2279     }
2280 
2281     // Note: this function does not guarantee the token is deployed, we leave that check to elsewhere to save gas.
2282     function xTokenAddr(address baseToken)
2283         public
2284         view
2285         virtual
2286         override
2287         returns (address)
2288     {
2289         bytes32 salt = keccak256(abi.encodePacked(baseToken));
2290         address tokenAddr = Create2.computeAddress(
2291             salt,
2292             keccak256(type(Create2BeaconProxy).creationCode)
2293         );
2294         return tokenAddr;
2295     }
2296 
2297     function vaultXToken(uint256 vaultId)
2298         public
2299         view
2300         virtual
2301         override
2302         returns (address)
2303     {
2304         address baseToken = nftxVaultFactory.vault(vaultId);
2305         address xToken = xTokenAddr(baseToken);
2306         require(isContract(xToken), "XToken not deployed");
2307         return xToken;
2308     }
2309 
2310     function _timelockMintFor(
2311         uint256 vaultId,
2312         address account,
2313         uint256 _amount,
2314         uint256 timelockLength
2315     )
2316         internal
2317         returns (
2318             IERC20Upgradeable,
2319             XTokenUpgradeable,
2320             uint256
2321         )
2322     {
2323         deployXTokenForVault(vaultId);
2324         IERC20Upgradeable baseToken = IERC20Upgradeable(
2325             nftxVaultFactory.vault(vaultId)
2326         );
2327         XTokenUpgradeable xToken = XTokenUpgradeable(
2328             (xTokenAddr(address(baseToken)))
2329         );
2330 
2331         uint256 xTokensMinted = xToken.mintXTokens(
2332             account,
2333             _amount,
2334             timelockLength
2335         );
2336         return (baseToken, xToken, xTokensMinted);
2337     }
2338 
2339     function _deployXToken(address baseToken) internal returns (address) {
2340         string memory symbol = IERC20Metadata(baseToken).symbol();
2341         symbol = string(abi.encodePacked("x", symbol));
2342         bytes32 salt = keccak256(abi.encodePacked(baseToken));
2343         address deployedXToken = Create2.deploy(0, salt, beaconCode);
2344         XTokenUpgradeable(deployedXToken).__XToken_init(
2345             baseToken,
2346             symbol,
2347             symbol
2348         );
2349         return deployedXToken;
2350     }
2351 
2352     function isContract(address account) internal view returns (bool) {
2353         // This method relies on extcodesize, which returns 0 for contracts in
2354         // construction, since the code is only stored at the end of the
2355         // constructor execution.
2356 
2357         uint256 size;
2358         // solhint-disable-next-line no-inline-assembly
2359         assembly {
2360             size := extcodesize(account)
2361         }
2362         return size != 0;
2363     }
2364 }
2365 
2366 // File contracts/solidity/interface/IUniswapV2Router01.sol
2367 
2368 pragma solidity ^0.8.0;
2369 
2370 interface IUniswapV2Router01 {
2371     function factory() external pure returns (address);
2372 
2373     function WETH() external pure returns (address);
2374 
2375     function addLiquidity(
2376         address tokenA,
2377         address tokenB,
2378         uint256 amountADesired,
2379         uint256 amountBDesired,
2380         uint256 amountAMin,
2381         uint256 amountBMin,
2382         address to,
2383         uint256 deadline
2384     )
2385         external
2386         returns (
2387             uint256 amountA,
2388             uint256 amountB,
2389             uint256 liquidity
2390         );
2391 
2392     function addLiquidityETH(
2393         address token,
2394         uint256 amountTokenDesired,
2395         uint256 amountTokenMin,
2396         uint256 amountETHMin,
2397         address to,
2398         uint256 deadline
2399     )
2400         external
2401         payable
2402         returns (
2403             uint256 amountToken,
2404             uint256 amountETH,
2405             uint256 liquidity
2406         );
2407 
2408     function removeLiquidity(
2409         address tokenA,
2410         address tokenB,
2411         uint256 liquidity,
2412         uint256 amountAMin,
2413         uint256 amountBMin,
2414         address to,
2415         uint256 deadline
2416     ) external returns (uint256 amountA, uint256 amountB);
2417 
2418     function removeLiquidityETH(
2419         address token,
2420         uint256 liquidity,
2421         uint256 amountTokenMin,
2422         uint256 amountETHMin,
2423         address to,
2424         uint256 deadline
2425     ) external returns (uint256 amountToken, uint256 amountETH);
2426 
2427     function removeLiquidityWithPermit(
2428         address tokenA,
2429         address tokenB,
2430         uint256 liquidity,
2431         uint256 amountAMin,
2432         uint256 amountBMin,
2433         address to,
2434         uint256 deadline,
2435         bool approveMax,
2436         uint8 v,
2437         bytes32 r,
2438         bytes32 s
2439     ) external returns (uint256 amountA, uint256 amountB);
2440 
2441     function removeLiquidityETHWithPermit(
2442         address token,
2443         uint256 liquidity,
2444         uint256 amountTokenMin,
2445         uint256 amountETHMin,
2446         address to,
2447         uint256 deadline,
2448         bool approveMax,
2449         uint8 v,
2450         bytes32 r,
2451         bytes32 s
2452     ) external returns (uint256 amountToken, uint256 amountETH);
2453 
2454     function swapExactTokensForTokens(
2455         uint256 amountIn,
2456         uint256 amountOutMin,
2457         address[] calldata path,
2458         address to,
2459         uint256 deadline
2460     ) external returns (uint256[] memory amounts);
2461 
2462     function swapTokensForExactTokens(
2463         uint256 amountOut,
2464         uint256 amountInMax,
2465         address[] calldata path,
2466         address to,
2467         uint256 deadline
2468     ) external returns (uint256[] memory amounts);
2469 
2470     function swapExactETHForTokens(
2471         uint256 amountOutMin,
2472         address[] calldata path,
2473         address to,
2474         uint256 deadline
2475     ) external payable returns (uint256[] memory amounts);
2476 
2477     function swapTokensForExactETH(
2478         uint256 amountOut,
2479         uint256 amountInMax,
2480         address[] calldata path,
2481         address to,
2482         uint256 deadline
2483     ) external returns (uint256[] memory amounts);
2484 
2485     function swapExactTokensForETH(
2486         uint256 amountIn,
2487         uint256 amountOutMin,
2488         address[] calldata path,
2489         address to,
2490         uint256 deadline
2491     ) external returns (uint256[] memory amounts);
2492 
2493     function swapETHForExactTokens(
2494         uint256 amountOut,
2495         address[] calldata path,
2496         address to,
2497         uint256 deadline
2498     ) external payable returns (uint256[] memory amounts);
2499 
2500     function quote(
2501         uint256 amountA,
2502         uint256 reserveA,
2503         uint256 reserveB
2504     ) external pure returns (uint256 amountB);
2505 
2506     function getAmountOut(
2507         uint256 amountIn,
2508         uint256 reserveIn,
2509         uint256 reserveOut
2510     ) external pure returns (uint256 amountOut);
2511 
2512     function getAmountIn(
2513         uint256 amountOut,
2514         uint256 reserveIn,
2515         uint256 reserveOut
2516     ) external pure returns (uint256 amountIn);
2517 
2518     function getAmountsOut(uint256 amountIn, address[] calldata path)
2519         external
2520         view
2521         returns (uint256[] memory amounts);
2522 
2523     function getAmountsIn(uint256 amountOut, address[] calldata path)
2524         external
2525         view
2526         returns (uint256[] memory amounts);
2527 }
2528 
2529 // File contracts/solidity/token/IWETH.sol
2530 
2531 pragma solidity ^0.8.0;
2532 
2533 interface IWETH {
2534     function balanceOf(address account) external view returns (uint256);
2535 
2536     function deposit() external payable;
2537 
2538     function transfer(address to, uint256 value) external returns (bool);
2539 
2540     function withdraw(uint256) external;
2541 }
2542 
2543 // File contracts/solidity/interface/IUniswapV2Pair.sol
2544 
2545 pragma solidity ^0.8.0;
2546 
2547 interface IUniswapV2Pair {
2548     event Approval(
2549         address indexed owner,
2550         address indexed spender,
2551         uint256 value
2552     );
2553     event Transfer(address indexed from, address indexed to, uint256 value);
2554 
2555     function name() external pure returns (string memory);
2556 
2557     function symbol() external pure returns (string memory);
2558 
2559     function decimals() external pure returns (uint8);
2560 
2561     function totalSupply() external view returns (uint256);
2562 
2563     function balanceOf(address owner) external view returns (uint256);
2564 
2565     function allowance(address owner, address spender)
2566         external
2567         view
2568         returns (uint256);
2569 
2570     function approve(address spender, uint256 value) external returns (bool);
2571 
2572     function transfer(address to, uint256 value) external returns (bool);
2573 
2574     function transferFrom(
2575         address from,
2576         address to,
2577         uint256 value
2578     ) external returns (bool);
2579 
2580     function DOMAIN_SEPARATOR() external view returns (bytes32);
2581 
2582     function PERMIT_TYPEHASH() external pure returns (bytes32);
2583 
2584     function nonces(address owner) external view returns (uint256);
2585 
2586     function permit(
2587         address owner,
2588         address spender,
2589         uint256 value,
2590         uint256 deadline,
2591         uint8 v,
2592         bytes32 r,
2593         bytes32 s
2594     ) external;
2595 
2596     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
2597     event Burn(
2598         address indexed sender,
2599         uint256 amount0,
2600         uint256 amount1,
2601         address indexed to
2602     );
2603     event Swap(
2604         address indexed sender,
2605         uint256 amount0In,
2606         uint256 amount1In,
2607         uint256 amount0Out,
2608         uint256 amount1Out,
2609         address indexed to
2610     );
2611     event Sync(uint112 reserve0, uint112 reserve1);
2612 
2613     function MINIMUM_LIQUIDITY() external pure returns (uint256);
2614 
2615     function factory() external view returns (address);
2616 
2617     function token0() external view returns (address);
2618 
2619     function token1() external view returns (address);
2620 
2621     function getReserves()
2622         external
2623         view
2624         returns (
2625             uint112 reserve0,
2626             uint112 reserve1,
2627             uint32 blockTimestampLast
2628         );
2629 
2630     function price0CumulativeLast() external view returns (uint256);
2631 
2632     function price1CumulativeLast() external view returns (uint256);
2633 
2634     function kLast() external view returns (uint256);
2635 
2636     function mint(address to) external returns (uint256 liquidity);
2637 
2638     function burn(address to)
2639         external
2640         returns (uint256 amount0, uint256 amount1);
2641 
2642     function swap(
2643         uint256 amount0Out,
2644         uint256 amount1Out,
2645         address to,
2646         bytes calldata data
2647     ) external;
2648 
2649     function skim(address to) external;
2650 
2651     function sync() external;
2652 
2653     function initialize(address, address) external;
2654 }
2655 
2656 // File contracts/solidity/NFTXUnstakingInventoryZap.sol
2657 
2658 pragma solidity ^0.8.0;
2659 
2660 contract NFTXUnstakingInventoryZap is Ownable, ReentrancyGuard {
2661     using SafeERC20Upgradeable for IERC20Upgradeable;
2662 
2663     INFTXVaultFactory public vaultFactory;
2664     NFTXInventoryStaking public inventoryStaking;
2665     IUniswapV2Router01 public sushiRouter;
2666     IWETH public weth;
2667 
2668     event InventoryUnstaked(
2669         uint256 vaultId,
2670         uint256 xTokensUnstaked,
2671         uint256 numNftsRedeemed,
2672         address unstaker
2673     );
2674 
2675     function setVaultFactory(address addr) public onlyOwner {
2676         vaultFactory = INFTXVaultFactory(addr);
2677     }
2678 
2679     function setInventoryStaking(address addr) public onlyOwner {
2680         inventoryStaking = NFTXInventoryStaking(addr);
2681     }
2682 
2683     function setSushiRouterAndWeth(address sushiRouterAddr) public onlyOwner {
2684         sushiRouter = IUniswapV2Router01(sushiRouterAddr);
2685         weth = IWETH(sushiRouter.WETH());
2686     }
2687 
2688     function unstakeInventory(
2689         uint256 vaultId,
2690         uint256 numNfts,
2691         uint256 remainingPortionToUnstake
2692     ) public payable {
2693         require(remainingPortionToUnstake <= 10e17);
2694         address vTokenAddr = vaultFactory.vault(vaultId);
2695         address xTokenAddr = inventoryStaking.xTokenAddr(vTokenAddr);
2696         IERC20Upgradeable vToken = IERC20Upgradeable(vTokenAddr);
2697         IERC20Upgradeable xToken = IERC20Upgradeable(xTokenAddr);
2698 
2699         // calculate xTokensToPull to pull
2700         uint256 xTokensToPull;
2701         if (remainingPortionToUnstake == 10e17) {
2702             xTokensToPull = xToken.balanceOf(msg.sender);
2703         } else {
2704             uint256 shareValue = inventoryStaking.xTokenShareValue(vaultId);
2705             uint256 reqXTokens = ((numNfts * 10e17) * 10e17) / shareValue;
2706             // check for rounding error
2707             if ((reqXTokens * shareValue) / 10e17 < numNfts * 10e17) {
2708                 reqXTokens += 1;
2709             }
2710 
2711             if (xToken.balanceOf(msg.sender) < reqXTokens) {
2712                 xTokensToPull = xToken.balanceOf(msg.sender);
2713             } else if (remainingPortionToUnstake == 0) {
2714                 xTokensToPull = reqXTokens;
2715             } else {
2716                 uint256 remainingXTokens = xToken.balanceOf(msg.sender) -
2717                     reqXTokens;
2718                 xTokensToPull =
2719                     reqXTokens +
2720                     ((remainingXTokens * remainingPortionToUnstake) / 10e17);
2721             }
2722         }
2723 
2724         // pull xTokens then unstake for vTokens
2725         xToken.safeTransferFrom(msg.sender, address(this), xTokensToPull);
2726         if (
2727             xToken.allowance(address(this), address(inventoryStaking)) <
2728             xTokensToPull
2729         ) {
2730             xToken.approve(address(inventoryStaking), type(uint256).max);
2731         }
2732 
2733         uint256 initialVTokenBal = vToken.balanceOf(address(this));
2734 
2735         inventoryStaking.withdraw(vaultId, xTokensToPull);
2736 
2737         uint256 missingVToken;
2738         if (
2739             vToken.balanceOf(address(this)) - initialVTokenBal < numNfts * 10e17
2740         ) {
2741             missingVToken =
2742                 (numNfts * 10e17) -
2743                 (vToken.balanceOf(address(this)) - initialVTokenBal);
2744         }
2745         require(missingVToken < 100, "not enough vTokens");
2746 
2747         if (missingVToken > initialVTokenBal) {
2748             if (
2749                 vToken.balanceOf(msg.sender) >= missingVToken &&
2750                 vToken.allowance(address(this), vTokenAddr) >= missingVToken
2751             ) {
2752                 vToken.safeTransferFrom(
2753                     msg.sender,
2754                     address(this),
2755                     missingVToken
2756                 );
2757             } else {
2758                 address[] memory path = new address[](2);
2759                 path[0] = address(weth);
2760                 path[1] = vTokenAddr;
2761                 sushiRouter.swapETHForExactTokens{value: 1000000000}(
2762                     missingVToken,
2763                     path,
2764                     address(this),
2765                     block.timestamp + 10000
2766                 );
2767             }
2768         }
2769 
2770         // reedem NFTs with vTokens, if requested
2771         if (numNfts > 0) {
2772             if (vToken.allowance(address(this), vTokenAddr) < numNfts * 10e17) {
2773                 vToken.approve(vTokenAddr, type(uint256).max);
2774             }
2775             INFTXVault(vTokenAddr).redeemTo(
2776                 numNfts,
2777                 new uint256[](0),
2778                 msg.sender
2779             );
2780         }
2781 
2782         uint256 vTokenRemainder = vToken.balanceOf(address(this)) -
2783             initialVTokenBal;
2784 
2785         // if vToken remainder more than dust then return to sender
2786         if (vTokenRemainder > 100) {
2787             vToken.safeTransfer(msg.sender, vTokenRemainder);
2788         }
2789 
2790         emit InventoryUnstaked(vaultId, xTokensToPull, numNfts, msg.sender);
2791     }
2792 
2793     function maxNftsUsingXToken(
2794         uint256 vaultId,
2795         address staker,
2796         address slpToken
2797     ) public view returns (uint256 numNfts, bool shortByTinyAmount) {
2798         if (inventoryStaking.timelockUntil(vaultId, staker) > block.timestamp) {
2799             return (0, false);
2800         }
2801         address vTokenAddr = vaultFactory.vault(vaultId);
2802         address xTokenAddr = inventoryStaking.xTokenAddr(vTokenAddr);
2803         IERC20Upgradeable vToken = IERC20Upgradeable(vTokenAddr);
2804         IERC20Upgradeable xToken = IERC20Upgradeable(xTokenAddr);
2805         IERC20Upgradeable lpPair = IERC20Upgradeable(slpToken);
2806 
2807         uint256 xTokenBal = xToken.balanceOf(staker);
2808         uint256 shareValue = inventoryStaking.xTokenShareValue(vaultId);
2809         uint256 vTokensA = (xTokenBal * shareValue) / 10e17;
2810         uint256 vTokensB = ((xTokenBal * shareValue) / 10e17) + 99;
2811 
2812         uint256 vTokensIntA = vTokensA / 10e17;
2813         uint256 vTokensIntB = vTokensB / 10e17;
2814 
2815         if (vTokensIntB > vTokensIntA) {
2816             if (
2817                 vToken.balanceOf(msg.sender) >= 99 &&
2818                 vToken.allowance(address(this), vTokenAddr) >= 99
2819             ) {
2820                 return (vTokensIntB, true);
2821             } else if (lpPair.totalSupply() >= 10000) {
2822                 return (vTokensIntB, true);
2823             } else if (vToken.balanceOf(address(this)) >= 99) {
2824                 return (vTokensIntB, true);
2825             } else {
2826                 return (vTokensIntA, false);
2827             }
2828         } else {
2829             return (vTokensIntA, false);
2830         }
2831     }
2832 
2833     receive() external payable {}
2834 
2835     function rescue(address token) external onlyOwner {
2836         if (token == address(0)) {
2837             (bool success, ) = payable(msg.sender).call{
2838                 value: address(this).balance
2839             }("");
2840             require(
2841                 success,
2842                 "Address: unable to send value, recipient may have reverted"
2843             );
2844         } else {
2845             IERC20Upgradeable(token).safeTransfer(
2846                 msg.sender,
2847                 IERC20Upgradeable(token).balanceOf(address(this))
2848             );
2849         }
2850     }
2851 }