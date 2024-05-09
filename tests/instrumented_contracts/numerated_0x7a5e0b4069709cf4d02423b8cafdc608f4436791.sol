1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
2 
3 // File contracts/solidity/interface/INFTXEligibility.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 interface INFTXEligibility {
10     // Read functions.
11     function name() external pure returns (string memory);
12     function finalized() external view returns (bool);
13     function targetAsset() external pure returns (address);
14     function checkAllEligible(uint256[] calldata tokenIds)
15         external
16         view
17         returns (bool);
18     function checkEligible(uint256[] calldata tokenIds)
19         external
20         view
21         returns (bool[] memory);
22     function checkAllIneligible(uint256[] calldata tokenIds)
23         external
24         view
25         returns (bool);
26     function checkIsEligible(uint256 tokenId) external view returns (bool);
27 
28     // Write functions.
29     function __NFTXEligibility_init_bytes(bytes calldata configData) external;
30     function beforeMintHook(uint256[] calldata tokenIds) external;
31     function afterMintHook(uint256[] calldata tokenIds) external;
32     function beforeRedeemHook(uint256[] calldata tokenIds) external;
33     function afterRedeemHook(uint256[] calldata tokenIds) external;
34 }
35 
36 
37 // File contracts/solidity/token/IERC20Upgradeable.sol
38 
39 
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20Upgradeable {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 // File contracts/solidity/proxy/IBeacon.sol
119 
120 
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev This is the interface that {BeaconProxy} expects of its beacon.
126  */
127 interface IBeacon {
128     /**
129      * @dev Must return an address that can be used as a delegate call target.
130      *
131      * {BeaconProxy} will check that this address is a contract.
132      */
133     function childImplementation() external view returns (address);
134     function upgradeChildTo(address newImplementation) external;
135 }
136 
137 
138 // File contracts/solidity/interface/INFTXVaultFactory.sol
139 
140 
141 
142 pragma solidity ^0.8.0;
143 
144 interface INFTXVaultFactory is IBeacon {
145   // Read functions.
146   function numVaults() external view returns (uint256);
147   function zapContract() external view returns (address);
148   function feeDistributor() external view returns (address);
149   function eligibilityManager() external view returns (address);
150   function vault(uint256 vaultId) external view returns (address);
151   function allVaults() external view returns (address[] memory);
152   function vaultsForAsset(address asset) external view returns (address[] memory);
153   function isLocked(uint256 id) external view returns (bool);
154   function excludedFromFees(address addr) external view returns (bool);
155   function factoryMintFee() external view returns (uint64);
156   function factoryRandomRedeemFee() external view returns (uint64);
157   function factoryTargetRedeemFee() external view returns (uint64);
158   function factoryRandomSwapFee() external view returns (uint64);
159   function factoryTargetSwapFee() external view returns (uint64);
160   function vaultFees(uint256 vaultId) external view returns (uint256, uint256, uint256, uint256, uint256);
161 
162   event NewFeeDistributor(address oldDistributor, address newDistributor);
163   event NewZapContract(address oldZap, address newZap);
164   event FeeExclusion(address feeExcluded, bool excluded);
165   event NewEligibilityManager(address oldEligManager, address newEligManager);
166   event NewVault(uint256 indexed vaultId, address vaultAddress, address assetAddress);
167   event UpdateVaultFees(uint256 vaultId, uint256 mintFee, uint256 randomRedeemFee, uint256 targetRedeemFee, uint256 randomSwapFee, uint256 targetSwapFee);
168   event DisableVaultFees(uint256 vaultId);
169   event UpdateFactoryFees(uint256 mintFee, uint256 randomRedeemFee, uint256 targetRedeemFee, uint256 randomSwapFee, uint256 targetSwapFee);
170 
171   // Write functions.
172   function __NFTXVaultFactory_init(address _vaultImpl, address _feeDistributor) external;
173   function createVault(
174       string calldata name,
175       string calldata symbol,
176       address _assetAddress,
177       bool is1155,
178       bool allowAllItems
179   ) external returns (uint256);
180   function setFeeDistributor(address _feeDistributor) external;
181   function setEligibilityManager(address _eligibilityManager) external;
182   function setZapContract(address _zapContract) external;
183   function setFeeExclusion(address _excludedAddr, bool excluded) external;
184 
185   function setFactoryFees(
186     uint256 mintFee, 
187     uint256 randomRedeemFee, 
188     uint256 targetRedeemFee,
189     uint256 randomSwapFee, 
190     uint256 targetSwapFee
191   ) external; 
192   function setVaultFees(
193       uint256 vaultId, 
194       uint256 mintFee, 
195       uint256 randomRedeemFee, 
196       uint256 targetRedeemFee,
197       uint256 randomSwapFee, 
198       uint256 targetSwapFee
199   ) external;
200   function disableVaultFees(uint256 vaultId) external;
201 }
202 
203 
204 // File contracts/solidity/interface/INFTXVault.sol
205 
206 
207 
208 pragma solidity ^0.8.0;
209 
210 
211 
212 interface INFTXVault is IERC20Upgradeable {
213     function manager() external view returns (address);
214     function assetAddress() external view returns (address);
215     function vaultFactory() external view returns (INFTXVaultFactory);
216     function eligibilityStorage() external view returns (INFTXEligibility);
217 
218     function is1155() external view returns (bool);
219     function allowAllItems() external view returns (bool);
220     function enableMint() external view returns (bool);
221     function enableRandomRedeem() external view returns (bool);
222     function enableTargetRedeem() external view returns (bool);
223     function enableRandomSwap() external view returns (bool);
224     function enableTargetSwap() external view returns (bool);
225 
226     function vaultId() external view returns (uint256);
227     function nftIdAt(uint256 holdingsIndex) external view returns (uint256);
228     function allHoldings() external view returns (uint256[] memory);
229     function totalHoldings() external view returns (uint256);
230     function mintFee() external view returns (uint256);
231     function randomRedeemFee() external view returns (uint256);
232     function targetRedeemFee() external view returns (uint256);
233     function randomSwapFee() external view returns (uint256);
234     function targetSwapFee() external view returns (uint256);
235     function vaultFees() external view returns (uint256, uint256, uint256, uint256, uint256);
236 
237     event VaultInit(
238         uint256 indexed vaultId,
239         address assetAddress,
240         bool is1155,
241         bool allowAllItems
242     );
243 
244     event ManagerSet(address manager);
245     event EligibilityDeployed(uint256 moduleIndex, address eligibilityAddr);
246     // event CustomEligibilityDeployed(address eligibilityAddr);
247 
248     event EnableMintUpdated(bool enabled);
249     event EnableRandomRedeemUpdated(bool enabled);
250     event EnableTargetRedeemUpdated(bool enabled);
251     event EnableRandomSwapUpdated(bool enabled);
252     event EnableTargetSwapUpdated(bool enabled);
253 
254     event Minted(uint256[] nftIds, uint256[] amounts, address to);
255     event Redeemed(uint256[] nftIds, uint256[] specificIds, address to);
256     event Swapped(
257         uint256[] nftIds,
258         uint256[] amounts,
259         uint256[] specificIds,
260         uint256[] redeemedIds,
261         address to
262     );
263 
264     function __NFTXVault_init(
265         string calldata _name,
266         string calldata _symbol,
267         address _assetAddress,
268         bool _is1155,
269         bool _allowAllItems
270     ) external;
271 
272     function finalizeVault() external;
273 
274     function setVaultMetadata(
275         string memory name_, 
276         string memory symbol_
277     ) external;
278 
279     function setVaultFeatures(
280         bool _enableMint,
281         bool _enableRandomRedeem,
282         bool _enableTargetRedeem,
283         bool _enableRandomSwap,
284         bool _enableTargetSwap
285     ) external;
286 
287     function setFees(
288         uint256 _mintFee,
289         uint256 _randomRedeemFee,
290         uint256 _targetRedeemFee,
291         uint256 _randomSwapFee,
292         uint256 _targetSwapFee
293     ) external;
294     function disableVaultFees() external;
295 
296     // This function allows for an easy setup of any eligibility module contract from the EligibilityManager.
297     // It takes in ABI encoded parameters for the desired module. This is to make sure they can all follow
298     // a similar interface.
299     function deployEligibilityStorage(
300         uint256 moduleIndex,
301         bytes calldata initData
302     ) external returns (address);
303 
304     // The manager has control over options like fees and features
305     function setManager(address _manager) external;
306 
307     function mint(
308         uint256[] calldata tokenIds,
309         uint256[] calldata amounts /* ignored for ERC721 vaults */
310     ) external returns (uint256);
311 
312     function mintTo(
313         uint256[] calldata tokenIds,
314         uint256[] calldata amounts, /* ignored for ERC721 vaults */
315         address to
316     ) external returns (uint256);
317 
318     function redeem(uint256 amount, uint256[] calldata specificIds)
319         external
320         returns (uint256[] calldata);
321 
322     function redeemTo(
323         uint256 amount,
324         uint256[] calldata specificIds,
325         address to
326     ) external returns (uint256[] calldata);
327 
328     function swap(
329         uint256[] calldata tokenIds,
330         uint256[] calldata amounts, /* ignored for ERC721 vaults */
331         uint256[] calldata specificIds
332     ) external returns (uint256[] calldata);
333 
334     function swapTo(
335         uint256[] calldata tokenIds,
336         uint256[] calldata amounts, /* ignored for ERC721 vaults */
337         uint256[] calldata specificIds,
338         address to
339     ) external returns (uint256[] calldata);
340 
341     function allValidNFTs(uint256[] calldata tokenIds)
342         external
343         view
344         returns (bool);
345 }
346 
347 
348 // File contracts/solidity/interface/INFTXSimpleFeeDistributor.sol
349 
350 
351 
352 pragma solidity ^0.8.0;
353 
354 interface INFTXSimpleFeeDistributor {
355   
356   struct FeeReceiver {
357     uint256 allocPoint;
358     address receiver;
359     bool isContract;
360   }
361 
362   function nftxVaultFactory() external view returns (address);
363   function lpStaking() external view returns (address);
364   function inventoryStaking() external view returns (address);
365   function treasury() external view returns (address);
366   function allocTotal() external view returns (uint256);
367 
368   // Write functions.
369   function __SimpleFeeDistributor__init__(address _lpStaking, address _treasury) external;
370   function rescueTokens(address token) external;
371   function distribute(uint256 vaultId) external;
372   function addReceiver(uint256 _allocPoint, address _receiver, bool _isContract) external;
373   function initializeVaultReceivers(uint256 _vaultId) external;
374 
375   function changeReceiverAlloc(uint256 _idx, uint256 _allocPoint) external;
376   function changeReceiverAddress(uint256 _idx, address _address, bool _isContract) external;
377   function removeReceiver(uint256 _receiverIdx) external;
378 
379   // Configuration functions.
380   function setTreasuryAddress(address _treasury) external;
381   function setLPStakingAddress(address _lpStaking) external;
382   function setInventoryStakingAddress(address _inventoryStaking) external;
383   function setNFTXVaultFactory(address _factory) external;
384 }
385 
386 
387 // File contracts/solidity/interface/INFTXLPStaking.sol
388 
389 
390 
391 pragma solidity ^0.8.0;
392 
393 interface INFTXLPStaking {
394     function nftxVaultFactory() external view returns (address);
395     function rewardDistTokenImpl() external view returns (address);
396     function stakingTokenProvider() external view returns (address);
397     function vaultToken(address _stakingToken) external view returns (address);
398     function stakingToken(address _vaultToken) external view returns (address);
399     function rewardDistributionToken(uint256 vaultId) external view returns (address);
400     function newRewardDistributionToken(uint256 vaultId) external view returns (address);
401     function oldRewardDistributionToken(uint256 vaultId) external view returns (address);
402     function unusedRewardDistributionToken(uint256 vaultId) external view returns (address);
403     function rewardDistributionTokenAddr(address stakedToken, address rewardToken) external view returns (address);
404     
405     // Write functions.
406     function __NFTXLPStaking__init(address _stakingTokenProvider) external;
407     function setNFTXVaultFactory(address newFactory) external;
408     function setStakingTokenProvider(address newProvider) external;
409     function addPoolForVault(uint256 vaultId) external;
410     function updatePoolForVault(uint256 vaultId) external;
411     function updatePoolForVaults(uint256[] calldata vaultId) external;
412     function receiveRewards(uint256 vaultId, uint256 amount) external returns (bool);
413     function deposit(uint256 vaultId, uint256 amount) external;
414     function timelockDepositFor(uint256 vaultId, address account, uint256 amount, uint256 timelockLength) external;
415     function exit(uint256 vaultId, uint256 amount) external;
416     function rescue(uint256 vaultId) external;
417     function withdraw(uint256 vaultId, uint256 amount) external;
418     function claimRewards(uint256 vaultId) external;
419 }
420 
421 
422 // File contracts/solidity/interface/INFTXInventoryStaking.sol
423 
424 
425 
426 pragma solidity ^0.8.0;
427 
428 interface INFTXInventoryStaking {
429     function nftxVaultFactory() external view returns (INFTXVaultFactory);
430     function vaultXToken(uint256 vaultId) external view returns (address);
431     function xTokenAddr(address baseToken) external view returns (address);
432     function xTokenShareValue(uint256 vaultId) external view returns (uint256);
433 
434     function __NFTXInventoryStaking_init(address nftxFactory) external;
435     
436     function deployXTokenForVault(uint256 vaultId) external;
437     function receiveRewards(uint256 vaultId, uint256 amount) external returns (bool);
438     function timelockMintFor(uint256 vaultId, uint256 amount, address to, uint256 timelockLength) external returns (uint256);
439     function deposit(uint256 vaultId, uint256 _amount) external;
440     function withdraw(uint256 vaultId, uint256 _share) external;
441 }
442 
443 
444 // File contracts/solidity/interface/IUniswapV2Router01.sol
445 
446 
447 
448 pragma solidity ^0.8.0;
449 
450 interface IUniswapV2Router01 {
451     function factory() external pure returns (address);
452     function WETH() external pure returns (address);
453 
454     function addLiquidity(
455         address tokenA,
456         address tokenB,
457         uint256 amountADesired,
458         uint256 amountBDesired,
459         uint256 amountAMin,
460         uint256 amountBMin,
461         address to,
462         uint256 deadline
463     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
464     function addLiquidityETH(
465         address token,
466         uint256 amountTokenDesired,
467         uint256 amountTokenMin,
468         uint256 amountETHMin,
469         address to,
470         uint256 deadline
471     )
472         external
473         payable
474         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
475     function removeLiquidity(
476         address tokenA,
477         address tokenB,
478         uint256 liquidity,
479         uint256 amountAMin,
480         uint256 amountBMin,
481         address to,
482         uint256 deadline
483     ) external returns (uint256 amountA, uint256 amountB);
484     function removeLiquidityETH(
485         address token,
486         uint256 liquidity,
487         uint256 amountTokenMin,
488         uint256 amountETHMin,
489         address to,
490         uint256 deadline
491     ) external returns (uint256 amountToken, uint256 amountETH);
492     function removeLiquidityWithPermit(
493         address tokenA,
494         address tokenB,
495         uint256 liquidity,
496         uint256 amountAMin,
497         uint256 amountBMin,
498         address to,
499         uint256 deadline,
500         bool approveMax,
501         uint8 v,
502         bytes32 r,
503         bytes32 s
504     ) external returns (uint256 amountA, uint256 amountB);
505     function removeLiquidityETHWithPermit(
506         address token,
507         uint256 liquidity,
508         uint256 amountTokenMin,
509         uint256 amountETHMin,
510         address to,
511         uint256 deadline,
512         bool approveMax,
513         uint8 v,
514         bytes32 r,
515         bytes32 s
516     ) external returns (uint256 amountToken, uint256 amountETH);
517     function swapExactTokensForTokens(
518         uint256 amountIn,
519         uint256 amountOutMin,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external returns (uint256[] memory amounts);
524     function swapTokensForExactTokens(
525         uint256 amountOut,
526         uint256 amountInMax,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external returns (uint256[] memory amounts);
531     function swapExactETHForTokens(
532         uint256 amountOutMin,
533         address[] calldata path,
534         address to,
535         uint256 deadline
536     ) external payable returns (uint256[] memory amounts);
537     function swapTokensForExactETH(
538         uint256 amountOut,
539         uint256 amountInMax,
540         address[] calldata path,
541         address to,
542         uint256 deadline
543     ) external returns (uint256[] memory amounts);
544     function swapExactTokensForETH(
545         uint256 amountIn,
546         uint256 amountOutMin,
547         address[] calldata path,
548         address to,
549         uint256 deadline
550     ) external returns (uint256[] memory amounts);
551     function swapETHForExactTokens(
552         uint256 amountOut,
553         address[] calldata path,
554         address to,
555         uint256 deadline
556     ) external payable returns (uint256[] memory amounts);
557 
558     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB)
559         external
560         pure
561         returns (uint256 amountB);
562     function getAmountOut(
563         uint256 amountIn,
564         uint256 reserveIn,
565         uint256 reserveOut
566     ) external pure returns (uint256 amountOut);
567     function getAmountIn(
568         uint256 amountOut,
569         uint256 reserveIn,
570         uint256 reserveOut
571     ) external pure returns (uint256 amountIn);
572     function getAmountsOut(uint256 amountIn, address[] calldata path)
573         external
574         view
575         returns (uint256[] memory amounts);
576     function getAmountsIn(uint256 amountOut, address[] calldata path)
577         external
578         view
579         returns (uint256[] memory amounts);
580 }
581 
582 
583 // File contracts/solidity/testing/IERC165.sol
584 
585 
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Interface of the ERC165 standard, as defined in the
591  * https://eips.ethereum.org/EIPS/eip-165[EIP].
592  *
593  * Implementers can declare support of contract interfaces, which can then be
594  * queried by others ({ERC165Checker}).
595  *
596  * For an implementation, see {ERC165}.
597  */
598 interface IERC165 {
599     /**
600      * @dev Returns true if this contract implements the interface defined by
601      * `interfaceId`. See the corresponding
602      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
603      * to learn more about how these ids are created.
604      *
605      * This function call must use less than 30 000 gas.
606      */
607     function supportsInterface(bytes4 interfaceId) external view returns (bool);
608 }
609 
610 
611 // File contracts/solidity/testing/IERC721.sol
612 
613 
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Required interface of an ERC721 compliant contract.
619  */
620 interface IERC721 is IERC165 {
621     /**
622      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
623      */
624     event Transfer(
625         address indexed from,
626         address indexed to,
627         uint256 indexed tokenId
628     );
629 
630     /**
631      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
632      */
633     event Approval(
634         address indexed owner,
635         address indexed approved,
636         uint256 indexed tokenId
637     );
638 
639     /**
640      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
641      */
642     event ApprovalForAll(
643         address indexed owner,
644         address indexed operator,
645         bool approved
646     );
647 
648     /**
649      * @dev Returns the number of tokens in ``owner``'s account.
650      */
651     function balanceOf(address owner) external view returns (uint256 balance);
652 
653     /**
654      * @dev Returns the owner of the `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function ownerOf(uint256 tokenId) external view returns (address owner);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
664      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Transfers `tokenId` token from `from` to `to`.
684      *
685      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      *
694      * Emits a {Transfer} event.
695      */
696     function transferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId)
725         external
726         view
727         returns (address operator);
728 
729     /**
730      * @dev Approve or remove `operator` as an operator for the caller.
731      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
732      *
733      * Requirements:
734      *
735      * - The `operator` cannot be the caller.
736      *
737      * Emits an {ApprovalForAll} event.
738      */
739     function setApprovalForAll(address operator, bool _approved) external;
740 
741     /**
742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
743      *
744      * See {setApprovalForAll}
745      */
746     function isApprovedForAll(address owner, address operator)
747         external
748         view
749         returns (bool);
750 
751     /**
752      * @dev Safely transfers `tokenId` token from `from` to `to`.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `tokenId` token must exist and be owned by `from`.
759      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes calldata data
769     ) external;
770 }
771 
772 
773 // File contracts/solidity/interface/IERC165Upgradeable.sol
774 
775 
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev Interface of the ERC165 standard, as defined in the
781  * https://eips.ethereum.org/EIPS/eip-165[EIP].
782  *
783  * Implementers can declare support of contract interfaces, which can then be
784  * queried by others ({ERC165Checker}).
785  *
786  * For an implementation, see {ERC165}.
787  */
788 interface IERC165Upgradeable {
789     /**
790      * @dev Returns true if this contract implements the interface defined by
791      * `interfaceId`. See the corresponding
792      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
793      * to learn more about how these ids are created.
794      *
795      * This function call must use less than 30 000 gas.
796      */
797     function supportsInterface(bytes4 interfaceId) external view returns (bool);
798 }
799 
800 
801 // File contracts/solidity/token/IERC1155Upgradeable.sol
802 
803 
804 
805 pragma solidity ^0.8.0;
806 
807 /**
808  * @dev Required interface of an ERC1155 compliant contract, as defined in the
809  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
810  *
811  * _Available since v3.1._
812  */
813 interface IERC1155Upgradeable is IERC165Upgradeable {
814     /**
815      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
816      */
817     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
818 
819     /**
820      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
821      * transfers.
822      */
823     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
824 
825     /**
826      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
827      * `approved`.
828      */
829     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
830 
831     /**
832      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
833      *
834      * If an {URI} event was emitted for `id`, the standard
835      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
836      * returned by {IERC1155MetadataURI-uri}.
837      */
838     event URI(string value, uint256 indexed id);
839 
840     /**
841      * @dev Returns the amount of tokens of token type `id` owned by `account`.
842      *
843      * Requirements:
844      *
845      * - `account` cannot be the zero address.
846      */
847     function balanceOf(address account, uint256 id) external view returns (uint256);
848 
849     /**
850      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
851      *
852      * Requirements:
853      *
854      * - `accounts` and `ids` must have the same length.
855      */
856     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
857 
858     /**
859      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
860      *
861      * Emits an {ApprovalForAll} event.
862      *
863      * Requirements:
864      *
865      * - `operator` cannot be the caller.
866      */
867     function setApprovalForAll(address operator, bool approved) external;
868 
869     /**
870      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
871      *
872      * See {setApprovalForAll}.
873      */
874     function isApprovedForAll(address account, address operator) external view returns (bool);
875 
876     /**
877      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
878      *
879      * Emits a {TransferSingle} event.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
885      * - `from` must have a balance of tokens of type `id` of at least `amount`.
886      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
887      * acceptance magic value.
888      */
889     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
890 
891     /**
892      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
893      *
894      * Emits a {TransferBatch} event.
895      *
896      * Requirements:
897      *
898      * - `ids` and `amounts` must have the same length.
899      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
900      * acceptance magic value.
901      */
902     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
903 }
904 
905 
906 // File contracts/solidity/token/IERC721ReceiverUpgradeable.sol
907 
908 
909 
910 pragma solidity ^0.8.0;
911 
912 /**
913  * @title ERC721 token receiver interface
914  * @dev Interface for any contract that wants to support safeTransfers
915  * from ERC721 asset contracts.
916  */
917 interface IERC721ReceiverUpgradeable {
918     /**
919      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
920      * by `operator` from `from`, this function is called.
921      *
922      * It must return its Solidity selector to confirm the token transfer.
923      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
924      *
925      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
926      */
927     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
928 }
929 
930 
931 // File contracts/solidity/token/ERC721HolderUpgradeable.sol
932 
933 
934 
935 pragma solidity ^0.8.0;
936 
937 /**
938  * @dev Implementation of the {IERC721Receiver} interface.
939  *
940  * Accepts all token transfers.
941  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
942  */
943 contract ERC721HolderUpgradeable is IERC721ReceiverUpgradeable {
944     /**
945      * @dev See {IERC721Receiver-onERC721Received}.
946      *
947      * Always returns `IERC721Receiver.onERC721Received.selector`.
948      */
949     function onERC721Received(
950         address,
951         address,
952         uint256,
953         bytes memory
954     ) public virtual override returns (bytes4) {
955         return this.onERC721Received.selector;
956     }
957 }
958 
959 
960 // File contracts/solidity/token/IERC1155ReceiverUpgradeable.sol
961 
962 
963 
964 pragma solidity ^0.8.0;
965 
966 /**
967  * @dev _Available since v3.1._
968  */
969 interface IERC1155ReceiverUpgradeable is IERC165Upgradeable {
970 
971     /**
972         @dev Handles the receipt of a single ERC1155 token type. This function is
973         called at the end of a `safeTransferFrom` after the balance has been updated.
974         To accept the transfer, this must return
975         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
976         (i.e. 0xf23a6e61, or its own function selector).
977         @param operator The address which initiated the transfer (i.e. msg.sender)
978         @param from The address which previously owned the token
979         @param id The ID of the token being transferred
980         @param value The amount of tokens being transferred
981         @param data Additional data with no specified format
982         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
983     */
984     function onERC1155Received(
985         address operator,
986         address from,
987         uint256 id,
988         uint256 value,
989         bytes calldata data
990     )
991         external
992         returns(bytes4);
993 
994     /**
995         @dev Handles the receipt of a multiple ERC1155 token types. This function
996         is called at the end of a `safeBatchTransferFrom` after the balances have
997         been updated. To accept the transfer(s), this must return
998         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
999         (i.e. 0xbc197c81, or its own function selector).
1000         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1001         @param from The address which previously owned the token
1002         @param ids An array containing ids of each token being transferred (order and length must match values array)
1003         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1004         @param data Additional data with no specified format
1005         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1006     */
1007     function onERC1155BatchReceived(
1008         address operator,
1009         address from,
1010         uint256[] calldata ids,
1011         uint256[] calldata values,
1012         bytes calldata data
1013     )
1014         external
1015         returns(bytes4);
1016 }
1017 
1018 
1019 // File contracts/solidity/util/ERC165Upgradeable.sol
1020 
1021 
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 /**
1026  * @dev Implementation of the {IERC165} interface.
1027  *
1028  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1029  * for the additional interface id that will be supported. For example:
1030  *
1031  * ```solidity
1032  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1033  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1034  * }
1035  * ```
1036  *
1037  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1038  */
1039 abstract contract ERC165Upgradeable is IERC165Upgradeable {
1040     /**
1041      * @dev See {IERC165-supportsInterface}.
1042      */
1043     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1044         return interfaceId == type(IERC165Upgradeable).interfaceId;
1045     }
1046 }
1047 
1048 
1049 // File contracts/solidity/token/ERC1155ReceiverUpgradeable.sol
1050 
1051 
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 
1056 /**
1057  * @dev _Available since v3.1._
1058  */
1059 abstract contract ERC1155ReceiverUpgradeable is ERC165Upgradeable, IERC1155ReceiverUpgradeable {
1060     /**
1061      * @dev See {IERC165-supportsInterface}.
1062      */
1063     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1064         return interfaceId == type(IERC1155ReceiverUpgradeable).interfaceId
1065             || super.supportsInterface(interfaceId);
1066     }
1067 }
1068 
1069 
1070 // File contracts/solidity/token/ERC1155HolderUpgradeable.sol
1071 
1072 
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 /**
1077  * @dev _Available since v3.1._
1078  */
1079 abstract contract ERC1155HolderUpgradeable is ERC1155ReceiverUpgradeable {
1080     function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
1081         return this.onERC1155Received.selector;
1082     }
1083 
1084     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
1085         return this.onERC1155BatchReceived.selector;
1086     }
1087 }
1088 
1089 
1090 // File contracts/solidity/proxy/Initializable.sol
1091 
1092 
1093 
1094 // solhint-disable-next-line compiler-version
1095 pragma solidity ^0.8.0;
1096 
1097 /**
1098  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1099  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1100  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1101  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1102  *
1103  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1104  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1105  *
1106  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1107  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1108  */
1109 abstract contract Initializable {
1110 
1111     /**
1112      * @dev Indicates that the contract has been initialized.
1113      */
1114     bool private _initialized;
1115 
1116     /**
1117      * @dev Indicates that the contract is in the process of being initialized.
1118      */
1119     bool private _initializing;
1120 
1121     /**
1122      * @dev Modifier to protect an initializer function from being invoked twice.
1123      */
1124     modifier initializer() {
1125         require(_initializing || !_initialized, "Initializable: contract is already initialized");
1126 
1127         bool isTopLevelCall = !_initializing;
1128         if (isTopLevelCall) {
1129             _initializing = true;
1130             _initialized = true;
1131         }
1132 
1133         _;
1134 
1135         if (isTopLevelCall) {
1136             _initializing = false;
1137         }
1138     }
1139 }
1140 
1141 
1142 // File contracts/solidity/util/ContextUpgradeable.sol
1143 
1144 
1145 
1146 pragma solidity ^0.8.0;
1147 
1148 /*
1149  * @dev Provides information about the current execution context, including the
1150  * sender of the transaction and its data. While these are generally available
1151  * via msg.sender and msg.data, they should not be accessed in such a direct
1152  * manner, since when dealing with meta-transactions the account sending and
1153  * paying for execution may not be the actual sender (as far as an application
1154  * is concerned).
1155  *
1156  * This contract is only required for intermediate, library-like contracts.
1157  */
1158 abstract contract ContextUpgradeable is Initializable {
1159     function __Context_init() internal initializer {
1160         __Context_init_unchained();
1161     }
1162 
1163     function __Context_init_unchained() internal initializer {
1164     }
1165     function _msgSender() internal view virtual returns (address) {
1166         return msg.sender;
1167     }
1168 
1169     function _msgData() internal view virtual returns (bytes calldata) {
1170         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1171         return msg.data;
1172     }
1173     uint256[50] private __gap;
1174 }
1175 
1176 
1177 // File contracts/solidity/util/OwnableUpgradeable.sol
1178 
1179 
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 
1184 /**
1185  * @dev Contract module which provides a basic access control mechanism, where
1186  * there is an account (an owner) that can be granted exclusive access to
1187  * specific functions.
1188  *
1189  * By default, the owner account will be the one that deploys the contract. This
1190  * can later be changed with {transferOwnership}.
1191  *
1192  * This module is used through inheritance. It will make available the modifier
1193  * `onlyOwner`, which can be applied to your functions to restrict their use to
1194  * the owner.
1195  */
1196 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1197     address private _owner;
1198 
1199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1200 
1201     /**
1202      * @dev Initializes the contract setting the deployer as the initial owner.
1203      */
1204     function __Ownable_init() internal initializer {
1205         __Context_init_unchained();
1206         __Ownable_init_unchained();
1207     }
1208 
1209     function __Ownable_init_unchained() internal initializer {
1210         address msgSender = _msgSender();
1211         _owner = msgSender;
1212         emit OwnershipTransferred(address(0), msgSender);
1213     }
1214 
1215     /**
1216      * @dev Returns the address of the current owner.
1217      */
1218     function owner() public view virtual returns (address) {
1219         return _owner;
1220     }
1221 
1222     /**
1223      * @dev Throws if called by any account other than the owner.
1224      */
1225     modifier onlyOwner() {
1226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1227         _;
1228     }
1229 
1230     /**
1231      * @dev Leaves the contract without owner. It will not be possible to call
1232      * `onlyOwner` functions anymore. Can only be called by the current owner.
1233      *
1234      * NOTE: Renouncing ownership will leave the contract without an owner,
1235      * thereby removing any functionality that is only available to the owner.
1236      */
1237     function renounceOwnership() public virtual onlyOwner {
1238         emit OwnershipTransferred(_owner, address(0));
1239         _owner = address(0);
1240     }
1241 
1242     /**
1243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1244      * Can only be called by the current owner.
1245      */
1246     function transferOwnership(address newOwner) public virtual onlyOwner {
1247         require(newOwner != address(0), "Ownable: new owner is the zero address");
1248         emit OwnershipTransferred(_owner, newOwner);
1249         _owner = newOwner;
1250     }
1251     uint256[49] private __gap;
1252 }
1253 
1254 
1255 // File contracts/solidity/util/Address.sol
1256 
1257 
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 /**
1262  * @dev Collection of functions related to the address type
1263  */
1264 library Address {
1265     /**
1266      * @dev Returns true if `account` is a contract.
1267      *
1268      * [IMPORTANT]
1269      * ====
1270      * It is unsafe to assume that an address for which this function returns
1271      * false is an externally-owned account (EOA) and not a contract.
1272      *
1273      * Among others, `isContract` will return false for the following
1274      * types of addresses:
1275      *
1276      *  - an externally-owned account
1277      *  - a contract in construction
1278      *  - an address where a contract will be created
1279      *  - an address where a contract lived, but was destroyed
1280      * ====
1281      */
1282     function isContract(address account) internal view returns (bool) {
1283         // This method relies on extcodesize, which returns 0 for contracts in
1284         // construction, since the code is only stored at the end of the
1285         // constructor execution.
1286 
1287         uint256 size;
1288         // solhint-disable-next-line no-inline-assembly
1289         assembly { size := extcodesize(account) }
1290         return size > 0;
1291     }
1292 
1293     /**
1294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1295      * `recipient`, forwarding all available gas and reverting on errors.
1296      *
1297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1299      * imposed by `transfer`, making them unable to receive funds via
1300      * `transfer`. {sendValue} removes this limitation.
1301      *
1302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1303      *
1304      * IMPORTANT: because control is transferred to `recipient`, care must be
1305      * taken to not create reentrancy vulnerabilities. Consider using
1306      * {ReentrancyGuard} or the
1307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1308      */
1309     function sendValue(address payable recipient, uint256 amount) internal {
1310         require(address(this).balance >= amount, "Address: insufficient balance");
1311 
1312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1313         (bool success, ) = recipient.call{ value: amount }("");
1314         require(success, "Address: unable to send value, recipient may have reverted");
1315     }
1316 
1317     /**
1318      * @dev Performs a Solidity function call using a low level `call`. A
1319      * plain`call` is an unsafe replacement for a function call: use this
1320      * function instead.
1321      *
1322      * If `target` reverts with a revert reason, it is bubbled up by this
1323      * function (like regular Solidity function calls).
1324      *
1325      * Returns the raw returned data. To convert to the expected return value,
1326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1327      *
1328      * Requirements:
1329      *
1330      * - `target` must be a contract.
1331      * - calling `target` with `data` must not revert.
1332      *
1333      * _Available since v3.1._
1334      */
1335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1336       return functionCall(target, data, "Address: low-level call failed");
1337     }
1338 
1339     /**
1340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1341      * `errorMessage` as a fallback revert reason when `target` reverts.
1342      *
1343      * _Available since v3.1._
1344      */
1345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1346         return functionCallWithValue(target, data, 0, errorMessage);
1347     }
1348 
1349     /**
1350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1351      * but also transferring `value` wei to `target`.
1352      *
1353      * Requirements:
1354      *
1355      * - the calling contract must have an ETH balance of at least `value`.
1356      * - the called Solidity function must be `payable`.
1357      *
1358      * _Available since v3.1._
1359      */
1360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1362     }
1363 
1364     /**
1365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1366      * with `errorMessage` as a fallback revert reason when `target` reverts.
1367      *
1368      * _Available since v3.1._
1369      */
1370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1371         require(address(this).balance >= value, "Address: insufficient balance for call");
1372         require(isContract(target), "Address: call to non-contract");
1373 
1374         // solhint-disable-next-line avoid-low-level-calls
1375         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1376         return _verifyCallResult(success, returndata, errorMessage);
1377     }
1378 
1379     /**
1380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1381      * but performing a static call.
1382      *
1383      * _Available since v3.3._
1384      */
1385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1386         return functionStaticCall(target, data, "Address: low-level static call failed");
1387     }
1388 
1389     /**
1390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1391      * but performing a static call.
1392      *
1393      * _Available since v3.3._
1394      */
1395     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1396         require(isContract(target), "Address: static call to non-contract");
1397 
1398         // solhint-disable-next-line avoid-low-level-calls
1399         (bool success, bytes memory returndata) = target.staticcall(data);
1400         return _verifyCallResult(success, returndata, errorMessage);
1401     }
1402 
1403     /**
1404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1405      * but performing a delegate call.
1406      *
1407      * _Available since v3.4._
1408      */
1409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1411     }
1412 
1413     /**
1414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1415      * but performing a delegate call.
1416      *
1417      * _Available since v3.4._
1418      */
1419     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1420         require(isContract(target), "Address: delegate call to non-contract");
1421 
1422         // solhint-disable-next-line avoid-low-level-calls
1423         (bool success, bytes memory returndata) = target.delegatecall(data);
1424         return _verifyCallResult(success, returndata, errorMessage);
1425     }
1426 
1427     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1428         if (success) {
1429             return returndata;
1430         } else {
1431             // Look for revert reason and bubble it up if present
1432             if (returndata.length > 0) {
1433                 // The easiest way to bubble the revert reason is using memory via assembly
1434 
1435                 // solhint-disable-next-line no-inline-assembly
1436                 assembly {
1437                     let returndata_size := mload(returndata)
1438                     revert(add(32, returndata), returndata_size)
1439                 }
1440             } else {
1441                 revert(errorMessage);
1442             }
1443         }
1444     }
1445 }
1446 
1447 
1448 // File contracts/solidity/util/SafeERC20Upgradeable.sol
1449 
1450 
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 
1455 /**
1456  * @title SafeERC20
1457  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1458  * contract returns false). Tokens that return no value (and instead revert or
1459  * throw on failure) are also supported, non-reverting calls are assumed to be
1460  * successful.
1461  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1462  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1463  */
1464 library SafeERC20Upgradeable {
1465     using Address for address;
1466 
1467     function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
1468         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1469     }
1470 
1471     function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
1472         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1473     }
1474 
1475     /**
1476      * @dev Deprecated. This function has issues similar to the ones found in
1477      * {IERC20-approve}, and its usage is discouraged.
1478      *
1479      * Whenever possible, use {safeIncreaseAllowance} and
1480      * {safeDecreaseAllowance} instead.
1481      */
1482     function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
1483         // safeApprove should only be called when setting an initial allowance,
1484         // or when resetting it to zero. To increase and decrease it, use
1485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1486         // solhint-disable-next-line max-line-length
1487         require((value == 0) || (token.allowance(address(this), spender) == 0),
1488             "SafeERC20: approve from non-zero to non-zero allowance"
1489         );
1490         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1491     }
1492 
1493     function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
1494         uint256 newAllowance = token.allowance(address(this), spender) + value;
1495         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1496     }
1497 
1498     function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
1499         unchecked {
1500             uint256 oldAllowance = token.allowance(address(this), spender);
1501             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1502             uint256 newAllowance = oldAllowance - value;
1503             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1504         }
1505     }
1506 
1507     /**
1508      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1509      * on the return value: the return value is optional (but if data is returned, it must not be false).
1510      * @param token The token targeted by the call.
1511      * @param data The call data (encoded using abi.encode or one of its variants).
1512      */
1513     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
1514         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1515         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1516         // the target address contains contract code and also asserts for success in the low-level call.
1517 
1518         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1519         if (returndata.length > 0) { // Return data is optional
1520             // solhint-disable-next-line max-line-length
1521             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1522         }
1523     }
1524 }
1525 
1526 
1527 // File contracts/solidity/NFTXStakingZap.sol
1528 
1529 
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 
1545 // Authors: @0xKiwi_.
1546 
1547 interface IWETH {
1548   function deposit() external payable;
1549   function transfer(address to, uint value) external returns (bool);
1550   function withdraw(uint) external;
1551 }
1552 
1553 /**
1554  * @dev Contract module that helps prevent reentrant calls to a function.
1555  *
1556  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1557  * available, which can be applied to functions to make sure there are no nested
1558  * (reentrant) calls to them.
1559  *
1560  * Note that because there is a single `nonReentrant` guard, functions marked as
1561  * `nonReentrant` may not call one another. This can be worked around by making
1562  * those functions `private`, and then adding `external` `nonReentrant` entry
1563  * points to them.
1564  *
1565  * TIP: If you would like to learn more about reentrancy and alternative ways
1566  * to protect against it, check out our blog post
1567  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1568  */
1569 abstract contract ReentrancyGuard {
1570     // Booleans are more expensive than uint256 or any type that takes up a full
1571     // word because each write operation emits an extra SLOAD to first read the
1572     // slot's contents, replace the bits taken up by the boolean, and then write
1573     // back. This is the compiler's defense against contract upgrades and
1574     // pointer aliasing, and it cannot be disabled.
1575 
1576     // The values being non-zero value makes deployment a bit more expensive,
1577     // but in exchange the refund on every call to nonReentrant will be lower in
1578     // amount. Since refunds are capped to a percentage of the total
1579     // transaction's gas, it is best to keep them low in cases like this one, to
1580     // increase the likelihood of the full refund coming into effect.
1581     uint256 private constant _NOT_ENTERED = 1;
1582     uint256 private constant _ENTERED = 2;
1583 
1584     uint256 private _status;
1585 
1586     constructor() {
1587         _status = _NOT_ENTERED;
1588     }
1589 
1590     /**
1591      * @dev Prevents a contract from calling itself, directly or indirectly.
1592      * Calling a `nonReentrant` function from another `nonReentrant`
1593      * function is not supported. It is possible to prevent this from happening
1594      * by making the `nonReentrant` function external, and make it call a
1595      * `private` function that does the actual work.
1596      */
1597     modifier nonReentrant() {
1598         // On the first call to nonReentrant, _notEntered will be true
1599         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1600 
1601         // Any calls to nonReentrant after this point will fail
1602         _status = _ENTERED;
1603 
1604         _;
1605 
1606         // By storing the original value once again, a refund is triggered (see
1607         // https://eips.ethereum.org/EIPS/eip-2200)
1608         _status = _NOT_ENTERED;
1609     }
1610 }
1611 
1612 /**
1613  * @dev Contract module which provides a basic access control mechanism, where
1614  * there is an account (an owner) that can be granted exclusive access to
1615  * specific functions.
1616  *
1617  * By default, the owner account will be the one that deploys the contract. This
1618  * can later be changed with {transferOwnership}.
1619  *
1620  * This module is used through inheritance. It will make available the modifier
1621  * `onlyOwner`, which can be applied to your functions to restrict their use to
1622  * the owner.
1623  */
1624 abstract contract Ownable {
1625     address private _owner;
1626 
1627     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1628 
1629     /**
1630      * @dev Initializes the contract setting the deployer as the initial owner.
1631      */
1632     constructor() {
1633         _setOwner(msg.sender);
1634     }
1635 
1636     /**
1637      * @dev Returns the address of the current owner.
1638      */
1639     function owner() public view virtual returns (address) {
1640         return _owner;
1641     }
1642 
1643     /**
1644      * @dev Throws if called by any account other than the owner.
1645      */
1646     modifier onlyOwner() {
1647         require(owner() == msg.sender, "Ownable: caller is not the owner");
1648         _;
1649     }
1650 
1651     /**
1652      * @dev Leaves the contract without owner. It will not be possible to call
1653      * `onlyOwner` functions anymore. Can only be called by the current owner.
1654      *
1655      * NOTE: Renouncing ownership will leave the contract without an owner,
1656      * thereby removing any functionality that is only available to the owner.
1657      */
1658     function renounceOwnership() public virtual onlyOwner {
1659         _setOwner(address(0));
1660     }
1661 
1662     /**
1663      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1664      * Can only be called by the current owner.
1665      */
1666     function transferOwnership(address newOwner) public virtual onlyOwner {
1667         require(newOwner != address(0), "Ownable: new owner is the zero address");
1668         _setOwner(newOwner);
1669     }
1670 
1671     function _setOwner(address newOwner) private {
1672         address oldOwner = _owner;
1673         _owner = newOwner;
1674         emit OwnershipTransferred(oldOwner, newOwner);
1675     }
1676 }
1677 
1678 contract NFTXStakingZap is Ownable, ReentrancyGuard, ERC721HolderUpgradeable, ERC1155HolderUpgradeable {
1679   using SafeERC20Upgradeable for IERC20Upgradeable;
1680 
1681   IWETH public immutable WETH; 
1682   INFTXLPStaking public lpStaking;
1683   INFTXInventoryStaking public inventoryStaking;
1684   INFTXVaultFactory public immutable nftxFactory;
1685   IUniswapV2Router01 public immutable sushiRouter;
1686 
1687   uint256 public lpLockTime = 48 hours; 
1688   uint256 public inventoryLockTime = 7 days; 
1689   uint256 constant BASE = 1e18;
1690 
1691   event UserStaked(uint256 vaultId, uint256 count, uint256 lpBalance, uint256 timelockUntil, address sender);
1692 
1693   constructor(address _nftxFactory, address _sushiRouter) Ownable() ReentrancyGuard() {
1694     nftxFactory = INFTXVaultFactory(_nftxFactory);
1695     sushiRouter = IUniswapV2Router01(_sushiRouter);
1696     WETH = IWETH(IUniswapV2Router01(_sushiRouter).WETH());
1697     IERC20Upgradeable(address(IUniswapV2Router01(_sushiRouter).WETH())).safeApprove(_sushiRouter, type(uint256).max);
1698   }
1699 
1700   function assignStakingContracts() public {
1701     require(address(lpStaking) == address(0) || address(inventoryStaking) == address(0), "not zero");
1702     lpStaking = INFTXLPStaking(INFTXSimpleFeeDistributor(INFTXVaultFactory(nftxFactory).feeDistributor()).lpStaking());
1703     inventoryStaking = INFTXInventoryStaking(INFTXSimpleFeeDistributor(INFTXVaultFactory(nftxFactory).feeDistributor()).inventoryStaking());
1704   }
1705 
1706   function setLPLockTime(uint256 newLPLockTime) external onlyOwner {
1707     require(newLPLockTime <= 7 days, "Lock too long");
1708     lpLockTime = newLPLockTime;
1709   } 
1710 
1711   function setInventoryLockTime(uint256 newInventoryLockTime) external onlyOwner {
1712     require(newInventoryLockTime <= 14 days, "Lock too long");
1713     inventoryLockTime = newInventoryLockTime;
1714   }
1715 
1716   function provideInventory721(uint256 vaultId, uint256[] calldata tokenIds) external {
1717     uint256 count = tokenIds.length;
1718     INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1719     inventoryStaking.timelockMintFor(vaultId, count*BASE, msg.sender, inventoryLockTime);
1720     address xToken = inventoryStaking.vaultXToken(vaultId);
1721     uint256 oldBal = IERC20Upgradeable(vault).balanceOf(xToken);
1722     uint256[] memory amounts = new uint256[](0);
1723     address assetAddress = vault.assetAddress();
1724     uint256 length = tokenIds.length;
1725     for (uint256 i; i < length; ++i) {
1726       transferFromERC721(assetAddress, tokenIds[i], address(vault));
1727       approveERC721(assetAddress, address(vault), tokenIds[i]);
1728     }
1729     vault.mintTo(tokenIds, amounts, address(xToken));
1730     uint256 newBal = IERC20Upgradeable(vault).balanceOf(xToken);
1731     require(newBal == oldBal + count*BASE, "Incorrect vtokens minted");
1732   }
1733 
1734   function provideInventory1155(uint256 vaultId, uint256[] calldata tokenIds, uint256[] calldata amounts) external {
1735     uint256 length = tokenIds.length;
1736     require(length == amounts.length, "Not equal length");
1737     uint256 count;
1738     for (uint256 i; i < length; ++i) {
1739       count += amounts[i];
1740     }
1741     INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1742     inventoryStaking.timelockMintFor(vaultId, count*BASE, msg.sender, inventoryLockTime);
1743     address xToken = inventoryStaking.vaultXToken(vaultId);
1744     uint256 oldBal = IERC20Upgradeable(vault).balanceOf(address(xToken));
1745     IERC1155Upgradeable nft = IERC1155Upgradeable(vault.assetAddress());
1746     nft.safeBatchTransferFrom(msg.sender, address(this), tokenIds, amounts, "");
1747     nft.setApprovalForAll(address(vault), true);
1748     vault.mintTo(tokenIds, amounts, address(xToken));
1749     uint256 newBal = IERC20Upgradeable(vault).balanceOf(address(xToken));
1750     require(newBal == oldBal + count*BASE, "Incorrect vtokens minted");
1751   }
1752 
1753   function addLiquidity721ETH(
1754     uint256 vaultId, 
1755     uint256[] calldata ids, 
1756     uint256 minWethIn
1757   ) external payable returns (uint256) {
1758     return addLiquidity721ETHTo(vaultId, ids, minWethIn, msg.sender);
1759   }
1760 
1761   function addLiquidity721ETHTo(
1762     uint256 vaultId, 
1763     uint256[] memory ids, 
1764     uint256 minWethIn,
1765     address to
1766   ) public payable nonReentrant returns (uint256) {
1767     require(to != address(0) && to != address(this));
1768     WETH.deposit{value: msg.value}();
1769     (, uint256 amountEth, uint256 liquidity) = _addLiquidity721WETH(vaultId, ids, minWethIn, msg.value, to);
1770 
1771     // Return extras.
1772     uint256 remaining = msg.value-amountEth;
1773     if (remaining != 0) {
1774       WETH.withdraw(remaining);
1775       (bool success, ) = payable(to).call{value: remaining}("");
1776       require(success, "Address: unable to send value, recipient may have reverted");
1777     }
1778 
1779     return liquidity;
1780   }
1781 
1782   function addLiquidity1155ETH(
1783     uint256 vaultId, 
1784     uint256[] calldata ids, 
1785     uint256[] calldata amounts,
1786     uint256 minEthIn
1787   ) external payable returns (uint256) {
1788     return addLiquidity1155ETHTo(vaultId, ids, amounts, minEthIn, msg.sender);
1789   }
1790 
1791   function addLiquidity1155ETHTo(
1792     uint256 vaultId, 
1793     uint256[] memory ids, 
1794     uint256[] memory amounts,
1795     uint256 minEthIn,
1796     address to
1797   ) public payable nonReentrant returns (uint256) {
1798     require(to != address(0) && to != address(this));
1799     WETH.deposit{value: msg.value}();
1800     // Finish this.
1801     (, uint256 amountEth, uint256 liquidity) = _addLiquidity1155WETH(vaultId, ids, amounts, minEthIn, msg.value, to);
1802 
1803     // Return extras.
1804     uint256 remaining = msg.value-amountEth;
1805     if (remaining != 0) {
1806       WETH.withdraw(remaining);
1807       (bool success, ) = payable(to).call{value: remaining}("");
1808       require(success, "Address: unable to send value, recipient may have reverted");
1809     }
1810 
1811     return liquidity;
1812   }
1813 
1814   function addLiquidity721(
1815     uint256 vaultId, 
1816     uint256[] calldata ids, 
1817     uint256 minWethIn,
1818     uint256 wethIn
1819   ) external returns (uint256) {
1820     return addLiquidity721To(vaultId, ids, minWethIn, wethIn, msg.sender);
1821   }
1822 
1823   function addLiquidity721To(
1824     uint256 vaultId, 
1825     uint256[] memory ids, 
1826     uint256 minWethIn,
1827     uint256 wethIn,
1828     address to
1829   ) public nonReentrant returns (uint256) {
1830     require(to != address(0) && to != address(this));
1831     IERC20Upgradeable(address(WETH)).safeTransferFrom(msg.sender, address(this), wethIn);
1832     (, uint256 amountEth, uint256 liquidity) = _addLiquidity721WETH(vaultId, ids, minWethIn, wethIn, to);
1833 
1834     // Return extras.
1835     uint256 remaining = wethIn-amountEth;
1836     if (remaining != 0) {
1837       WETH.transfer(to, remaining);
1838     }
1839 
1840     return liquidity;
1841   }
1842 
1843   function addLiquidity1155(
1844     uint256 vaultId, 
1845     uint256[] memory ids,
1846     uint256[] memory amounts,
1847     uint256 minWethIn,
1848     uint256 wethIn
1849   ) public returns (uint256) {
1850     return addLiquidity1155To(vaultId, ids, amounts, minWethIn, wethIn, msg.sender);
1851   }
1852 
1853   function addLiquidity1155To(
1854     uint256 vaultId, 
1855     uint256[] memory ids,
1856     uint256[] memory amounts,
1857     uint256 minWethIn,
1858     uint256 wethIn,
1859     address to
1860   ) public nonReentrant returns (uint256) {
1861     require(to != address(0) && to != address(this));
1862     IERC20Upgradeable(address(WETH)).safeTransferFrom(msg.sender, address(this), wethIn);
1863     (, uint256 amountEth, uint256 liquidity) = _addLiquidity1155WETH(vaultId, ids, amounts, minWethIn, wethIn, to);
1864 
1865     // Return extras.
1866     uint256 remaining = wethIn-amountEth; 
1867     if (remaining != 0) {
1868       WETH.transfer(to, remaining);
1869     }
1870 
1871     return liquidity;
1872   }
1873 
1874   function _addLiquidity721WETH(
1875     uint256 vaultId, 
1876     uint256[] memory ids, 
1877     uint256 minWethIn,
1878     uint256 wethIn,
1879     address to
1880   ) internal returns (uint256, uint256, uint256) {
1881     require(nftxFactory.excludedFromFees(address(this)));
1882     address vault = nftxFactory.vault(vaultId);
1883 
1884     // Transfer tokens to zap and mint to NFTX.
1885     address assetAddress = INFTXVault(vault).assetAddress();
1886     uint256 length = ids.length;
1887     for (uint256 i; i < length; i++) {
1888       transferFromERC721(assetAddress, ids[i], vault);
1889       approveERC721(assetAddress, vault, ids[i]);
1890     }
1891     uint256[] memory emptyIds;
1892     INFTXVault(vault).mint(ids, emptyIds);
1893     uint256 balance = length * BASE; // We should not be experiencing fees.
1894     
1895     return _addLiquidityAndLock(vaultId, vault, balance, minWethIn, wethIn, to);
1896   }
1897 
1898   function _addLiquidity1155WETH(
1899     uint256 vaultId, 
1900     uint256[] memory ids,
1901     uint256[] memory amounts,
1902     uint256 minWethIn,
1903     uint256 wethIn,
1904     address to
1905   ) internal returns (uint256, uint256, uint256) {
1906     require(nftxFactory.excludedFromFees(address(this)));
1907     address vault = nftxFactory.vault(vaultId);
1908 
1909     // Transfer tokens to zap and mint to NFTX.
1910     address assetAddress = INFTXVault(vault).assetAddress();
1911     IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), ids, amounts, "");
1912     IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
1913     
1914     uint256 count = INFTXVault(vault).mint(ids, amounts);
1915     uint256 balance = (count * BASE); // We should not be experiencing fees.
1916     
1917     return _addLiquidityAndLock(vaultId, vault, balance, minWethIn, wethIn, to);
1918   }
1919 
1920   function _addLiquidityAndLock(
1921     uint256 vaultId, 
1922     address vault, 
1923     uint256 minTokenIn, 
1924     uint256 minWethIn, 
1925     uint256 wethIn,
1926     address to
1927   ) internal returns (uint256, uint256, uint256) {
1928     // Provide liquidity.
1929     IERC20Upgradeable(vault).safeApprove(address(sushiRouter), minTokenIn);
1930     (uint256 amountToken, uint256 amountEth, uint256 liquidity) = sushiRouter.addLiquidity(
1931       address(vault),
1932       address(WETH),
1933       minTokenIn,
1934       wethIn,
1935       minTokenIn,
1936       minWethIn,
1937       address(this),
1938       block.timestamp
1939     );
1940 
1941     // Stake in LP rewards contract 
1942     address lpToken = pairFor(vault, address(WETH));
1943     IERC20Upgradeable(lpToken).safeApprove(address(lpStaking), liquidity);
1944     lpStaking.timelockDepositFor(vaultId, to, liquidity, lpLockTime);
1945     
1946     uint256 remaining = minTokenIn-amountToken;
1947     if (remaining != 0) {
1948       IERC20Upgradeable(vault).safeTransfer(to, remaining);
1949     }
1950 
1951     uint256 lockEndTime = block.timestamp + lpLockTime;
1952     emit UserStaked(vaultId, minTokenIn, liquidity, lockEndTime, to);
1953     return (amountToken, amountEth, liquidity);
1954   }
1955 
1956     // function removeLiquidity(
1957     //     address tokenA,
1958     //     address tokenB,
1959     //     uint256 liquidity,
1960     //     uint256 amountAMin,
1961     //     uint256 amountBMin,
1962     //     address to,
1963     //     uint256 deadline
1964     // ) external returns (uint256 amountA, uint256 amountB);
1965     // function removeLiquidityETH(
1966     //     address token,
1967     //     uint256 liquidity,
1968     //     uint256 amountTokenMin,
1969     //     uint256 amountETHMin,
1970     //     address to,
1971     //     uint256 deadline
1972     // ) external returns (uint256 amountToken, uint256 amountETH);
1973   function _removeLiquidityAndLock(
1974     uint256 vaultId, 
1975     address vault, 
1976     uint256 minTokenIn, 
1977     uint256 minWethIn, 
1978     uint256 wethIn,
1979     address to
1980   ) internal returns (uint256, uint256, uint256) {
1981     // Provide liquidity.
1982     IERC20Upgradeable(vault).safeApprove(address(sushiRouter), minTokenIn);
1983     (uint256 amountToken, uint256 amountEth, uint256 liquidity) = sushiRouter.addLiquidity(
1984       address(vault),
1985       address(WETH),
1986       minTokenIn,
1987       wethIn,
1988       minTokenIn,
1989       minWethIn,
1990       address(this),
1991       block.timestamp
1992     );
1993 
1994     // Stake in LP rewards contract 
1995     address lpToken = pairFor(vault, address(WETH));
1996     IERC20Upgradeable(lpToken).safeApprove(address(lpStaking), liquidity);
1997     lpStaking.timelockDepositFor(vaultId, to, liquidity, lpLockTime);
1998     
1999     uint256 remaining = minTokenIn-amountToken;
2000     if (remaining != 0) {
2001       IERC20Upgradeable(vault).safeTransfer(to, remaining);
2002     }
2003 
2004     uint256 lockEndTime = block.timestamp + lpLockTime;
2005     emit UserStaked(vaultId, minTokenIn, liquidity, lockEndTime, to);
2006     return (amountToken, amountEth, liquidity);
2007   }
2008 
2009   function transferFromERC721(address assetAddr, uint256 tokenId, address to) internal virtual {
2010     address kitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
2011     address punks = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
2012     bytes memory data;
2013     if (assetAddr == kitties) {
2014         // Cryptokitties.
2015         data = abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, to, tokenId);
2016     } else if (assetAddr == punks) {
2017         // CryptoPunks.
2018         // Fix here for frontrun attack. Added in v1.0.2.
2019         bytes memory punkIndexToAddress = abi.encodeWithSignature("punkIndexToAddress(uint256)", tokenId);
2020         (bool checkSuccess, bytes memory result) = address(assetAddr).staticcall(punkIndexToAddress);
2021         (address nftOwner) = abi.decode(result, (address));
2022         require(checkSuccess && nftOwner == msg.sender, "Not the NFT owner");
2023         data = abi.encodeWithSignature("buyPunk(uint256)", tokenId);
2024     } else {
2025         // Default.
2026         // We push to the vault to avoid an unneeded transfer.
2027         data = abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", msg.sender, to, tokenId);
2028     }
2029     (bool success, bytes memory resultData) = address(assetAddr).call(data);
2030     require(success, string(resultData));
2031   }
2032 
2033   function approveERC721(address assetAddr, address to, uint256 tokenId) internal virtual {
2034     address kitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
2035     address punks = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
2036     bytes memory data;
2037     if (assetAddr == kitties) {
2038         // Cryptokitties.
2039         // data = abi.encodeWithSignature("approve(address,uint256)", to, tokenId);
2040         // No longer needed to approve with pushing.
2041         return;
2042     } else if (assetAddr == punks) {
2043         // CryptoPunks.
2044         data = abi.encodeWithSignature("offerPunkForSaleToAddress(uint256,uint256,address)", tokenId, 0, to);
2045     } else {
2046       // No longer needed to approve with pushing.
2047       return;
2048     }
2049     (bool success, bytes memory resultData) = address(assetAddr).call(data);
2050     require(success, string(resultData));
2051   }
2052 
2053   // calculates the CREATE2 address for a pair without making any external calls
2054   function pairFor(address tokenA, address tokenB) internal view returns (address pair) {
2055     (address token0, address token1) = sortTokens(tokenA, tokenB);
2056     pair = address(uint160(uint256(keccak256(abi.encodePacked(
2057       hex'ff',
2058       sushiRouter.factory(),
2059       keccak256(abi.encodePacked(token0, token1)),
2060       hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
2061     )))));
2062   }
2063 
2064   // returns sorted token addresses, used to handle return values from pairs sorted in this order
2065   function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
2066       require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
2067       (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
2068       require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
2069   }
2070 
2071   receive() external payable {
2072     require(msg.sender == address(WETH), "Only WETH");
2073   }
2074 
2075   function rescue(address token) external onlyOwner {
2076     if (token == address(0)) {
2077       (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2078       require(success, "Address: unable to send value, recipient may have reverted");
2079     } else {
2080       IERC20Upgradeable(token).safeTransfer(msg.sender, IERC20Upgradeable(token).balanceOf(address(this)));
2081     }
2082   }
2083 }