1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
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
37 // File contracts/solidity/proxy/IBeacon.sol
38 
39 
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev This is the interface that {BeaconProxy} expects of its beacon.
45  */
46 interface IBeacon {
47     /**
48      * @dev Must return an address that can be used as a delegate call target.
49      *
50      * {BeaconProxy} will check that this address is a contract.
51      */
52     function childImplementation() external view returns (address);
53     function upgradeChildTo(address newImplementation) external;
54 }
55 
56 
57 // File contracts/solidity/interface/INFTXVaultFactory.sol
58 
59 
60 
61 pragma solidity ^0.8.0;
62 
63 interface INFTXVaultFactory is IBeacon {
64   // Read functions.
65   function numVaults() external view returns (uint256);
66   function zapContract() external view returns (address);
67   function feeDistributor() external view returns (address);
68   function eligibilityManager() external view returns (address);
69   function vault(uint256 vaultId) external view returns (address);
70   function vaultsForAsset(address asset) external view returns (address[] memory);
71   function isLocked(uint256 id) external view returns (bool);
72   function excludedFromFees(address addr) external view returns (bool);
73 
74   event NewFeeDistributor(address oldDistributor, address newDistributor);
75   event NewZapContract(address oldZap, address newZap);
76   event FeeExclusion(address feeExcluded, bool excluded);
77   event NewEligibilityManager(address oldEligManager, address newEligManager);
78   event NewVault(uint256 indexed vaultId, address vaultAddress, address assetAddress);
79 
80   // Write functions.
81   function __NFTXVaultFactory_init(address _vaultImpl, address _feeDistributor) external;
82   function createVault(
83       string calldata name,
84       string calldata symbol,
85       address _assetAddress,
86       bool is1155,
87       bool allowAllItems
88   ) external returns (uint256);
89   function setFeeDistributor(address _feeDistributor) external;
90   function setEligibilityManager(address _eligibilityManager) external;
91   function setZapContract(address _zapContract) external;
92   function setFeeExclusion(address _excludedAddr, bool excluded) external;
93 }
94 
95 
96 // File contracts/solidity/interface/INFTXVault.sol
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 
103 interface INFTXVault {
104     function manager() external returns (address);
105     function assetAddress() external returns (address);
106     function vaultFactory() external returns (INFTXVaultFactory);
107     function eligibilityStorage() external returns (INFTXEligibility);
108 
109     function is1155() external returns (bool);
110     function allowAllItems() external returns (bool);
111     function enableMint() external returns (bool);
112     function enableRandomRedeem() external returns (bool);
113     function enableTargetRedeem() external returns (bool);
114 
115     function vaultId() external returns (uint256);
116     function nftIdAt(uint256 holdingsIndex) external view returns (uint256);
117     function allHoldings() external view returns (uint256[] memory);
118     function totalHoldings() external view returns (uint256);
119     function mintFee() external returns (uint256);
120     function randomRedeemFee() external returns (uint256);
121     function targetRedeemFee() external returns (uint256);
122 
123     event VaultInit(
124         uint256 indexed vaultId,
125         address assetAddress,
126         bool is1155,
127         bool allowAllItems
128     );
129 
130     event ManagerSet(address manager);
131     event EligibilityDeployed(uint256 moduleIndex, address eligibilityAddr);
132     // event CustomEligibilityDeployed(address eligibilityAddr);
133 
134     event EnableMintUpdated(bool enabled);
135     event EnableRandomRedeemUpdated(bool enabled);
136     event EnableTargetRedeemUpdated(bool enabled);
137 
138     event MintFeeUpdated(uint256 mintFee);
139     event RandomRedeemFeeUpdated(uint256 randomRedeemFee);
140     event TargetRedeemFeeUpdated(uint256 targetRedeemFee);
141 
142     event Minted(uint256[] nftIds, uint256[] amounts, address to);
143     event Redeemed(uint256[] nftIds, uint256[] specificIds, address to);
144     event Swapped(
145         uint256[] nftIds,
146         uint256[] amounts,
147         uint256[] specificIds,
148         uint256[] redeemedIds,
149         address to
150     );
151 
152     function __NFTXVault_init(
153         string calldata _name,
154         string calldata _symbol,
155         address _assetAddress,
156         bool _is1155,
157         bool _allowAllItems
158     ) external;
159 
160     function finalizeVault() external;
161 
162     function setVaultMetadata(
163         string memory name_, 
164         string memory symbol_
165     ) external;
166 
167     function setVaultFeatures(
168         bool _enableMint,
169         bool _enableRandomRedeem,
170         bool _enableTargetRedeem
171     ) external;
172 
173     function setFees(
174         uint256 _mintFee,
175         uint256 _randomRedeemFee,
176         uint256 _targetRedeemFee
177     ) external;
178 
179     // This function allows for an easy setup of any eligibility module contract from the EligibilityManager.
180     // It takes in ABI encoded parameters for the desired module. This is to make sure they can all follow
181     // a similar interface.
182     function deployEligibilityStorage(
183         uint256 moduleIndex,
184         bytes calldata initData
185     ) external returns (address);
186 
187     // The manager has control over options like fees and features
188     function setManager(address _manager) external;
189 
190     function mint(
191         uint256[] calldata tokenIds,
192         uint256[] calldata amounts /* ignored for ERC721 vaults */
193     ) external returns (uint256);
194 
195     function mintTo(
196         uint256[] calldata tokenIds,
197         uint256[] calldata amounts, /* ignored for ERC721 vaults */
198         address to
199     ) external returns (uint256);
200 
201     function redeem(uint256 amount, uint256[] calldata specificIds)
202         external
203         returns (uint256[] calldata);
204 
205     function redeemTo(
206         uint256 amount,
207         uint256[] calldata specificIds,
208         address to
209     ) external returns (uint256[] calldata);
210 
211     function swap(
212         uint256[] calldata tokenIds,
213         uint256[] calldata amounts, /* ignored for ERC721 vaults */
214         uint256[] calldata specificIds
215     ) external returns (uint256[] calldata);
216 
217     function swapTo(
218         uint256[] calldata tokenIds,
219         uint256[] calldata amounts, /* ignored for ERC721 vaults */
220         uint256[] calldata specificIds,
221         address to
222     ) external returns (uint256[] calldata);
223 
224     function allValidNFTs(uint256[] calldata tokenIds)
225         external
226         view
227         returns (bool);
228 }
229 
230 
231 // File contracts/solidity/interface/INFTXFeeDistributor.sol
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 interface INFTXFeeDistributor {
238   
239   struct FeeReceiver {
240     uint256 allocPoint;
241     address receiver;
242     bool isContract;
243   }
244 
245   function nftxVaultFactory() external returns (address);
246   function lpStaking() external returns (address);
247   function treasury() external returns (address);
248   function defaultTreasuryAlloc() external returns (uint256);
249   function defaultLPAlloc() external returns (uint256);
250   function allocTotal(uint256 vaultId) external returns (uint256);
251   function specificTreasuryAlloc(uint256 vaultId) external returns (uint256);
252 
253   // Write functions.
254   function __FeeDistributor__init__(address _lpStaking, address _treasury) external;
255   function rescueTokens(address token) external;
256   function distribute(uint256 vaultId) external;
257   function addReceiver(uint256 _vaultId, uint256 _allocPoint, address _receiver, bool _isContract) external;
258   function initializeVaultReceivers(uint256 _vaultId) external;
259   function changeMultipleReceiverAlloc(
260     uint256[] memory _vaultIds, 
261     uint256[] memory _receiverIdxs, 
262     uint256[] memory allocPoints
263   ) external;
264 
265   function changeMultipleReceiverAddress(
266     uint256[] memory _vaultIds, 
267     uint256[] memory _receiverIdxs, 
268     address[] memory addresses, 
269     bool[] memory isContracts
270   ) external;
271   function changeReceiverAlloc(uint256 _vaultId, uint256 _idx, uint256 _allocPoint) external;
272   function changeReceiverAddress(uint256 _vaultId, uint256 _idx, address _address, bool _isContract) external;
273   function removeReceiver(uint256 _vaultId, uint256 _receiverIdx) external;
274 
275   // Configuration functions.
276   function setTreasuryAddress(address _treasury) external;
277   function setDefaultTreasuryAlloc(uint256 _allocPoint) external;
278   function setSpecificTreasuryAlloc(uint256 _vaultId, uint256 _allocPoint) external;
279   function setLPStakingAddress(address _lpStaking) external;
280   function setNFTXVaultFactory(address _factory) external;
281   function setDefaultLPAlloc(uint256 _allocPoint) external;
282 }
283 
284 
285 // File contracts/solidity/interface/INFTXLPStaking.sol
286 
287 
288 
289 pragma solidity ^0.8.0;
290 
291 interface INFTXLPStaking {
292     function nftxVaultFactory() external view returns (address);
293     function rewardDistTokenImpl() external view returns (address);
294     function stakingTokenProvider() external view returns (address);
295     function vaultToken(address _stakingToken) external view returns (address);
296     function stakingToken(address _vaultToken) external view returns (address);
297     function rewardDistributionToken(uint256 vaultId) external view returns (address);
298     function newRewardDistributionToken(uint256 vaultId) external view returns (address);
299     function oldRewardDistributionToken(uint256 vaultId) external view returns (address);
300     function unusedRewardDistributionToken(uint256 vaultId) external view returns (address);
301     function rewardDistributionTokenAddr(address stakingToken, address rewardToken) external view returns (address);
302     
303     // Write functions.
304     function __NFTXLPStaking__init(address _stakingTokenProvider) external;
305     function setNFTXVaultFactory(address newFactory) external;
306     function setStakingTokenProvider(address newProvider) external;
307     function addPoolForVault(uint256 vaultId) external;
308     function updatePoolForVault(uint256 vaultId) external;
309     function updatePoolForVaults(uint256[] calldata vaultId) external;
310     function receiveRewards(uint256 vaultId, uint256 amount) external returns (bool);
311     function deposit(uint256 vaultId, uint256 amount) external;
312     function timelockDepositFor(uint256 vaultId, address account, uint256 amount, uint256 timelockLength) external;
313     function exit(uint256 vaultId, uint256 amount) external;
314     function rescue(uint256 vaultId) external;
315     function withdraw(uint256 vaultId, uint256 amount) external;
316     function claimRewards(uint256 vaultId) external;
317 }
318 
319 
320 // File contracts/solidity/token/IERC20Upgradeable.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev Interface of the ERC20 standard as defined in the EIP.
328  */
329 interface IERC20Upgradeable {
330     /**
331      * @dev Returns the amount of tokens in existence.
332      */
333     function totalSupply() external view returns (uint256);
334 
335     /**
336      * @dev Returns the amount of tokens owned by `account`.
337      */
338     function balanceOf(address account) external view returns (uint256);
339 
340     /**
341      * @dev Moves `amount` tokens from the caller's account to `recipient`.
342      *
343      * Returns a boolean value indicating whether the operation succeeded.
344      *
345      * Emits a {Transfer} event.
346      */
347     function transfer(address recipient, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Returns the remaining number of tokens that `spender` will be
351      * allowed to spend on behalf of `owner` through {transferFrom}. This is
352      * zero by default.
353      *
354      * This value changes when {approve} or {transferFrom} are called.
355      */
356     function allowance(address owner, address spender) external view returns (uint256);
357 
358     /**
359      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * IMPORTANT: Beware that changing an allowance with this method brings the risk
364      * that someone may use both the old and the new allowance by unfortunate
365      * transaction ordering. One possible solution to mitigate this race
366      * condition is to first reduce the spender's allowance to 0 and set the
367      * desired value afterwards:
368      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369      *
370      * Emits an {Approval} event.
371      */
372     function approve(address spender, uint256 amount) external returns (bool);
373 
374     /**
375      * @dev Moves `amount` tokens from `sender` to `recipient` using the
376      * allowance mechanism. `amount` is then deducted from the caller's
377      * allowance.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * Emits a {Transfer} event.
382      */
383     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
384 
385     /**
386      * @dev Emitted when `value` tokens are moved from one account (`from`) to
387      * another (`to`).
388      *
389      * Note that `value` may be zero.
390      */
391     event Transfer(address indexed from, address indexed to, uint256 value);
392 
393     /**
394      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
395      * a call to {approve}. `value` is the new allowance.
396      */
397     event Approval(address indexed owner, address indexed spender, uint256 value);
398 }
399 
400 
401 // File contracts/solidity/interface/ITimelockRewardDistributionToken.sol
402 
403 
404 
405 pragma solidity ^0.8.0;
406 
407 interface ITimelockRewardDistributionToken is IERC20Upgradeable {
408   function distributeRewards(uint amount) external;
409   function __TimelockRewardDistributionToken_init(IERC20Upgradeable _target, string memory _name, string memory _symbol) external;
410   function mint(address account, address to, uint256 amount) external;
411   function timelockMint(address account, uint256 amount, uint256 timelockLength) external;
412   function burnFrom(address account, uint256 amount) external;
413   function withdrawReward(address user) external;
414   function dividendOf(address _owner) external view returns(uint256);
415   function withdrawnRewardOf(address _owner) external view returns(uint256);
416   function accumulativeRewardOf(address _owner) external view returns(uint256);
417   function timelockUntil(address account) external view returns (uint256);
418 }
419 
420 
421 // File contracts/solidity/interface/IUniswapV2Router01.sol
422 
423 
424 
425 pragma solidity ^0.8.0;
426 
427 interface IUniswapV2Router01 {
428     function factory() external pure returns (address);
429     function WETH() external pure returns (address);
430 
431     function addLiquidity(
432         address tokenA,
433         address tokenB,
434         uint256 amountADesired,
435         uint256 amountBDesired,
436         uint256 amountAMin,
437         uint256 amountBMin,
438         address to,
439         uint256 deadline
440     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
441     function addLiquidityETH(
442         address token,
443         uint256 amountTokenDesired,
444         uint256 amountTokenMin,
445         uint256 amountETHMin,
446         address to,
447         uint256 deadline
448     )
449         external
450         payable
451         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
452     function removeLiquidity(
453         address tokenA,
454         address tokenB,
455         uint256 liquidity,
456         uint256 amountAMin,
457         uint256 amountBMin,
458         address to,
459         uint256 deadline
460     ) external returns (uint256 amountA, uint256 amountB);
461     function removeLiquidityETH(
462         address token,
463         uint256 liquidity,
464         uint256 amountTokenMin,
465         uint256 amountETHMin,
466         address to,
467         uint256 deadline
468     ) external returns (uint256 amountToken, uint256 amountETH);
469     function removeLiquidityWithPermit(
470         address tokenA,
471         address tokenB,
472         uint256 liquidity,
473         uint256 amountAMin,
474         uint256 amountBMin,
475         address to,
476         uint256 deadline,
477         bool approveMax,
478         uint8 v,
479         bytes32 r,
480         bytes32 s
481     ) external returns (uint256 amountA, uint256 amountB);
482     function removeLiquidityETHWithPermit(
483         address token,
484         uint256 liquidity,
485         uint256 amountTokenMin,
486         uint256 amountETHMin,
487         address to,
488         uint256 deadline,
489         bool approveMax,
490         uint8 v,
491         bytes32 r,
492         bytes32 s
493     ) external returns (uint256 amountToken, uint256 amountETH);
494     function swapExactTokensForTokens(
495         uint256 amountIn,
496         uint256 amountOutMin,
497         address[] calldata path,
498         address to,
499         uint256 deadline
500     ) external returns (uint256[] memory amounts);
501     function swapTokensForExactTokens(
502         uint256 amountOut,
503         uint256 amountInMax,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external returns (uint256[] memory amounts);
508     function swapExactETHForTokens(
509         uint256 amountOutMin,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external payable returns (uint256[] memory amounts);
514     function swapTokensForExactETH(
515         uint256 amountOut,
516         uint256 amountInMax,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external returns (uint256[] memory amounts);
521     function swapExactTokensForETH(
522         uint256 amountIn,
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external returns (uint256[] memory amounts);
528     function swapETHForExactTokens(
529         uint256 amountOut,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external payable returns (uint256[] memory amounts);
534 
535     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB)
536         external
537         pure
538         returns (uint256 amountB);
539     function getAmountOut(
540         uint256 amountIn,
541         uint256 reserveIn,
542         uint256 reserveOut
543     ) external pure returns (uint256 amountOut);
544     function getAmountIn(
545         uint256 amountOut,
546         uint256 reserveIn,
547         uint256 reserveOut
548     ) external pure returns (uint256 amountIn);
549     function getAmountsOut(uint256 amountIn, address[] calldata path)
550         external
551         view
552         returns (uint256[] memory amounts);
553     function getAmountsIn(uint256 amountOut, address[] calldata path)
554         external
555         view
556         returns (uint256[] memory amounts);
557 }
558 
559 
560 // File contracts/solidity/testing/IERC165.sol
561 
562 
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Interface of the ERC165 standard, as defined in the
568  * https://eips.ethereum.org/EIPS/eip-165[EIP].
569  *
570  * Implementers can declare support of contract interfaces, which can then be
571  * queried by others ({ERC165Checker}).
572  *
573  * For an implementation, see {ERC165}.
574  */
575 interface IERC165 {
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30 000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) external view returns (bool);
585 }
586 
587 
588 // File contracts/solidity/testing/IERC721.sol
589 
590 
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Required interface of an ERC721 compliant contract.
596  */
597 interface IERC721 is IERC165 {
598     /**
599      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
600      */
601     event Transfer(
602         address indexed from,
603         address indexed to,
604         uint256 indexed tokenId
605     );
606 
607     /**
608      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
609      */
610     event Approval(
611         address indexed owner,
612         address indexed approved,
613         uint256 indexed tokenId
614     );
615 
616     /**
617      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
618      */
619     event ApprovalForAll(
620         address indexed owner,
621         address indexed operator,
622         bool approved
623     );
624 
625     /**
626      * @dev Returns the number of tokens in ``owner``'s account.
627      */
628     function balanceOf(address owner) external view returns (uint256 balance);
629 
630     /**
631      * @dev Returns the owner of the `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function ownerOf(uint256 tokenId) external view returns (address owner);
638 
639     /**
640      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
641      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must exist and be owned by `from`.
648      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Transfers `tokenId` token from `from` to `to`.
661      *
662      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
670      *
671      * Emits a {Transfer} event.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
681      * The approval is cleared when the token is transferred.
682      *
683      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
684      *
685      * Requirements:
686      *
687      * - The caller must own the token or be an approved operator.
688      * - `tokenId` must exist.
689      *
690      * Emits an {Approval} event.
691      */
692     function approve(address to, uint256 tokenId) external;
693 
694     /**
695      * @dev Returns the account approved for `tokenId` token.
696      *
697      * Requirements:
698      *
699      * - `tokenId` must exist.
700      */
701     function getApproved(uint256 tokenId)
702         external
703         view
704         returns (address operator);
705 
706     /**
707      * @dev Approve or remove `operator` as an operator for the caller.
708      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
709      *
710      * Requirements:
711      *
712      * - The `operator` cannot be the caller.
713      *
714      * Emits an {ApprovalForAll} event.
715      */
716     function setApprovalForAll(address operator, bool _approved) external;
717 
718     /**
719      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
720      *
721      * See {setApprovalForAll}
722      */
723     function isApprovedForAll(address owner, address operator)
724         external
725         view
726         returns (bool);
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`.
730      *
731      * Requirements:
732      *
733      * - `from` cannot be the zero address.
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must exist and be owned by `from`.
736      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
738      *
739      * Emits a {Transfer} event.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes calldata data
746     ) external;
747 }
748 
749 
750 // File contracts/solidity/interface/IERC165Upgradeable.sol
751 
752 
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Interface of the ERC165 standard, as defined in the
758  * https://eips.ethereum.org/EIPS/eip-165[EIP].
759  *
760  * Implementers can declare support of contract interfaces, which can then be
761  * queried by others ({ERC165Checker}).
762  *
763  * For an implementation, see {ERC165}.
764  */
765 interface IERC165Upgradeable {
766     /**
767      * @dev Returns true if this contract implements the interface defined by
768      * `interfaceId`. See the corresponding
769      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
770      * to learn more about how these ids are created.
771      *
772      * This function call must use less than 30 000 gas.
773      */
774     function supportsInterface(bytes4 interfaceId) external view returns (bool);
775 }
776 
777 
778 // File contracts/solidity/token/IERC1155Upgradeable.sol
779 
780 
781 
782 pragma solidity ^0.8.0;
783 
784 /**
785  * @dev Required interface of an ERC1155 compliant contract, as defined in the
786  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
787  *
788  * _Available since v3.1._
789  */
790 interface IERC1155Upgradeable is IERC165Upgradeable {
791     /**
792      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
793      */
794     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
795 
796     /**
797      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
798      * transfers.
799      */
800     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
801 
802     /**
803      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
804      * `approved`.
805      */
806     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
807 
808     /**
809      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
810      *
811      * If an {URI} event was emitted for `id`, the standard
812      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
813      * returned by {IERC1155MetadataURI-uri}.
814      */
815     event URI(string value, uint256 indexed id);
816 
817     /**
818      * @dev Returns the amount of tokens of token type `id` owned by `account`.
819      *
820      * Requirements:
821      *
822      * - `account` cannot be the zero address.
823      */
824     function balanceOf(address account, uint256 id) external view returns (uint256);
825 
826     /**
827      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
828      *
829      * Requirements:
830      *
831      * - `accounts` and `ids` must have the same length.
832      */
833     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
834 
835     /**
836      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
837      *
838      * Emits an {ApprovalForAll} event.
839      *
840      * Requirements:
841      *
842      * - `operator` cannot be the caller.
843      */
844     function setApprovalForAll(address operator, bool approved) external;
845 
846     /**
847      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
848      *
849      * See {setApprovalForAll}.
850      */
851     function isApprovedForAll(address account, address operator) external view returns (bool);
852 
853     /**
854      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
855      *
856      * Emits a {TransferSingle} event.
857      *
858      * Requirements:
859      *
860      * - `to` cannot be the zero address.
861      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
862      * - `from` must have a balance of tokens of type `id` of at least `amount`.
863      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
864      * acceptance magic value.
865      */
866     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
867 
868     /**
869      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
870      *
871      * Emits a {TransferBatch} event.
872      *
873      * Requirements:
874      *
875      * - `ids` and `amounts` must have the same length.
876      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
877      * acceptance magic value.
878      */
879     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
880 }
881 
882 
883 // File contracts/solidity/token/IERC721ReceiverUpgradeable.sol
884 
885 
886 
887 pragma solidity ^0.8.0;
888 
889 /**
890  * @title ERC721 token receiver interface
891  * @dev Interface for any contract that wants to support safeTransfers
892  * from ERC721 asset contracts.
893  */
894 interface IERC721ReceiverUpgradeable {
895     /**
896      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
897      * by `operator` from `from`, this function is called.
898      *
899      * It must return its Solidity selector to confirm the token transfer.
900      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
901      *
902      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
903      */
904     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
905 }
906 
907 
908 // File contracts/solidity/token/ERC721HolderUpgradeable.sol
909 
910 
911 
912 pragma solidity ^0.8.0;
913 
914 /**
915  * @dev Implementation of the {IERC721Receiver} interface.
916  *
917  * Accepts all token transfers.
918  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
919  */
920 contract ERC721HolderUpgradeable is IERC721ReceiverUpgradeable {
921     /**
922      * @dev See {IERC721Receiver-onERC721Received}.
923      *
924      * Always returns `IERC721Receiver.onERC721Received.selector`.
925      */
926     function onERC721Received(
927         address,
928         address,
929         uint256,
930         bytes memory
931     ) public virtual override returns (bytes4) {
932         return this.onERC721Received.selector;
933     }
934 }
935 
936 
937 // File contracts/solidity/token/IERC1155ReceiverUpgradeable.sol
938 
939 
940 
941 pragma solidity ^0.8.0;
942 
943 /**
944  * @dev _Available since v3.1._
945  */
946 interface IERC1155ReceiverUpgradeable is IERC165Upgradeable {
947 
948     /**
949         @dev Handles the receipt of a single ERC1155 token type. This function is
950         called at the end of a `safeTransferFrom` after the balance has been updated.
951         To accept the transfer, this must return
952         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
953         (i.e. 0xf23a6e61, or its own function selector).
954         @param operator The address which initiated the transfer (i.e. msg.sender)
955         @param from The address which previously owned the token
956         @param id The ID of the token being transferred
957         @param value The amount of tokens being transferred
958         @param data Additional data with no specified format
959         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
960     */
961     function onERC1155Received(
962         address operator,
963         address from,
964         uint256 id,
965         uint256 value,
966         bytes calldata data
967     )
968         external
969         returns(bytes4);
970 
971     /**
972         @dev Handles the receipt of a multiple ERC1155 token types. This function
973         is called at the end of a `safeBatchTransferFrom` after the balances have
974         been updated. To accept the transfer(s), this must return
975         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
976         (i.e. 0xbc197c81, or its own function selector).
977         @param operator The address which initiated the batch transfer (i.e. msg.sender)
978         @param from The address which previously owned the token
979         @param ids An array containing ids of each token being transferred (order and length must match values array)
980         @param values An array containing amounts of each token being transferred (order and length must match ids array)
981         @param data Additional data with no specified format
982         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
983     */
984     function onERC1155BatchReceived(
985         address operator,
986         address from,
987         uint256[] calldata ids,
988         uint256[] calldata values,
989         bytes calldata data
990     )
991         external
992         returns(bytes4);
993 }
994 
995 
996 // File contracts/solidity/util/ERC165Upgradeable.sol
997 
998 
999 
1000 pragma solidity ^0.8.0;
1001 
1002 /**
1003  * @dev Implementation of the {IERC165} interface.
1004  *
1005  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1006  * for the additional interface id that will be supported. For example:
1007  *
1008  * ```solidity
1009  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1010  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1011  * }
1012  * ```
1013  *
1014  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1015  */
1016 abstract contract ERC165Upgradeable is IERC165Upgradeable {
1017     /**
1018      * @dev See {IERC165-supportsInterface}.
1019      */
1020     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1021         return interfaceId == type(IERC165Upgradeable).interfaceId;
1022     }
1023 }
1024 
1025 
1026 // File contracts/solidity/token/ERC1155ReceiverUpgradeable.sol
1027 
1028 
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 
1033 /**
1034  * @dev _Available since v3.1._
1035  */
1036 abstract contract ERC1155ReceiverUpgradeable is ERC165Upgradeable, IERC1155ReceiverUpgradeable {
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1041         return interfaceId == type(IERC1155ReceiverUpgradeable).interfaceId
1042             || super.supportsInterface(interfaceId);
1043     }
1044 }
1045 
1046 
1047 // File contracts/solidity/token/ERC1155HolderUpgradeable.sol
1048 
1049 
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 /**
1054  * @dev _Available since v3.1._
1055  */
1056 abstract contract ERC1155HolderUpgradeable is ERC1155ReceiverUpgradeable {
1057     function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
1058         return this.onERC1155Received.selector;
1059     }
1060 
1061     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
1062         return this.onERC1155BatchReceived.selector;
1063     }
1064 }
1065 
1066 
1067 // File contracts/solidity/proxy/Initializable.sol
1068 
1069 
1070 
1071 // solhint-disable-next-line compiler-version
1072 pragma solidity ^0.8.0;
1073 
1074 /**
1075  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1076  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1077  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1078  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1079  *
1080  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1081  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1082  *
1083  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1084  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1085  */
1086 abstract contract Initializable {
1087 
1088     /**
1089      * @dev Indicates that the contract has been initialized.
1090      */
1091     bool private _initialized;
1092 
1093     /**
1094      * @dev Indicates that the contract is in the process of being initialized.
1095      */
1096     bool private _initializing;
1097 
1098     /**
1099      * @dev Modifier to protect an initializer function from being invoked twice.
1100      */
1101     modifier initializer() {
1102         require(_initializing || !_initialized, "Initializable: contract is already initialized");
1103 
1104         bool isTopLevelCall = !_initializing;
1105         if (isTopLevelCall) {
1106             _initializing = true;
1107             _initialized = true;
1108         }
1109 
1110         _;
1111 
1112         if (isTopLevelCall) {
1113             _initializing = false;
1114         }
1115     }
1116 }
1117 
1118 
1119 // File contracts/solidity/util/ContextUpgradeable.sol
1120 
1121 
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 /*
1126  * @dev Provides information about the current execution context, including the
1127  * sender of the transaction and its data. While these are generally available
1128  * via msg.sender and msg.data, they should not be accessed in such a direct
1129  * manner, since when dealing with meta-transactions the account sending and
1130  * paying for execution may not be the actual sender (as far as an application
1131  * is concerned).
1132  *
1133  * This contract is only required for intermediate, library-like contracts.
1134  */
1135 abstract contract ContextUpgradeable is Initializable {
1136     function __Context_init() internal initializer {
1137         __Context_init_unchained();
1138     }
1139 
1140     function __Context_init_unchained() internal initializer {
1141     }
1142     function _msgSender() internal view virtual returns (address) {
1143         return msg.sender;
1144     }
1145 
1146     function _msgData() internal view virtual returns (bytes calldata) {
1147         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1148         return msg.data;
1149     }
1150     uint256[50] private __gap;
1151 }
1152 
1153 
1154 // File contracts/solidity/util/OwnableUpgradeable.sol
1155 
1156 
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @dev Contract module which provides a basic access control mechanism, where
1163  * there is an account (an owner) that can be granted exclusive access to
1164  * specific functions.
1165  *
1166  * By default, the owner account will be the one that deploys the contract. This
1167  * can later be changed with {transferOwnership}.
1168  *
1169  * This module is used through inheritance. It will make available the modifier
1170  * `onlyOwner`, which can be applied to your functions to restrict their use to
1171  * the owner.
1172  */
1173 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1174     address private _owner;
1175 
1176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1177 
1178     /**
1179      * @dev Initializes the contract setting the deployer as the initial owner.
1180      */
1181     function __Ownable_init() internal initializer {
1182         __Context_init_unchained();
1183         __Ownable_init_unchained();
1184     }
1185 
1186     function __Ownable_init_unchained() internal initializer {
1187         address msgSender = _msgSender();
1188         _owner = msgSender;
1189         emit OwnershipTransferred(address(0), msgSender);
1190     }
1191 
1192     /**
1193      * @dev Returns the address of the current owner.
1194      */
1195     function owner() public view virtual returns (address) {
1196         return _owner;
1197     }
1198 
1199     /**
1200      * @dev Throws if called by any account other than the owner.
1201      */
1202     modifier onlyOwner() {
1203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1204         _;
1205     }
1206 
1207     /**
1208      * @dev Leaves the contract without owner. It will not be possible to call
1209      * `onlyOwner` functions anymore. Can only be called by the current owner.
1210      *
1211      * NOTE: Renouncing ownership will leave the contract without an owner,
1212      * thereby removing any functionality that is only available to the owner.
1213      */
1214     function renounceOwnership() public virtual onlyOwner {
1215         emit OwnershipTransferred(_owner, address(0));
1216         _owner = address(0);
1217     }
1218 
1219     /**
1220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1221      * Can only be called by the current owner.
1222      */
1223     function transferOwnership(address newOwner) public virtual onlyOwner {
1224         require(newOwner != address(0), "Ownable: new owner is the zero address");
1225         emit OwnershipTransferred(_owner, newOwner);
1226         _owner = newOwner;
1227     }
1228     uint256[49] private __gap;
1229 }
1230 
1231 
1232 // File contracts/solidity/NFTXStakingZap.sol
1233 
1234 
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 // Authors: @0xKiwi_.
1250 
1251 interface IWETH {
1252   function deposit() external payable;
1253   function transfer(address to, uint value) external returns (bool);
1254   function withdraw(uint) external;
1255 }
1256 
1257 /**
1258  * @dev Contract module that helps prevent reentrant calls to a function.
1259  *
1260  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1261  * available, which can be applied to functions to make sure there are no nested
1262  * (reentrant) calls to them.
1263  *
1264  * Note that because there is a single `nonReentrant` guard, functions marked as
1265  * `nonReentrant` may not call one another. This can be worked around by making
1266  * those functions `private`, and then adding `external` `nonReentrant` entry
1267  * points to them.
1268  *
1269  * TIP: If you would like to learn more about reentrancy and alternative ways
1270  * to protect against it, check out our blog post
1271  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1272  */
1273 abstract contract ReentrancyGuard {
1274     // Booleans are more expensive than uint256 or any type that takes up a full
1275     // word because each write operation emits an extra SLOAD to first read the
1276     // slot's contents, replace the bits taken up by the boolean, and then write
1277     // back. This is the compiler's defense against contract upgrades and
1278     // pointer aliasing, and it cannot be disabled.
1279 
1280     // The values being non-zero value makes deployment a bit more expensive,
1281     // but in exchange the refund on every call to nonReentrant will be lower in
1282     // amount. Since refunds are capped to a percentage of the total
1283     // transaction's gas, it is best to keep them low in cases like this one, to
1284     // increase the likelihood of the full refund coming into effect.
1285     uint256 private constant _NOT_ENTERED = 1;
1286     uint256 private constant _ENTERED = 2;
1287 
1288     uint256 private _status;
1289 
1290     constructor() {
1291         _status = _NOT_ENTERED;
1292     }
1293 
1294     /**
1295      * @dev Prevents a contract from calling itself, directly or indirectly.
1296      * Calling a `nonReentrant` function from another `nonReentrant`
1297      * function is not supported. It is possible to prevent this from happening
1298      * by making the `nonReentrant` function external, and make it call a
1299      * `private` function that does the actual work.
1300      */
1301     modifier nonReentrant() {
1302         // On the first call to nonReentrant, _notEntered will be true
1303         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1304 
1305         // Any calls to nonReentrant after this point will fail
1306         _status = _ENTERED;
1307 
1308         _;
1309 
1310         // By storing the original value once again, a refund is triggered (see
1311         // https://eips.ethereum.org/EIPS/eip-2200)
1312         _status = _NOT_ENTERED;
1313     }
1314 }
1315 
1316 /**
1317  * @dev Contract module which provides a basic access control mechanism, where
1318  * there is an account (an owner) that can be granted exclusive access to
1319  * specific functions.
1320  *
1321  * By default, the owner account will be the one that deploys the contract. This
1322  * can later be changed with {transferOwnership}.
1323  *
1324  * This module is used through inheritance. It will make available the modifier
1325  * `onlyOwner`, which can be applied to your functions to restrict their use to
1326  * the owner.
1327  */
1328 abstract contract Ownable {
1329     address private _owner;
1330 
1331     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1332 
1333     /**
1334      * @dev Initializes the contract setting the deployer as the initial owner.
1335      */
1336     constructor() {
1337         _setOwner(msg.sender);
1338     }
1339 
1340     /**
1341      * @dev Returns the address of the current owner.
1342      */
1343     function owner() public view virtual returns (address) {
1344         return _owner;
1345     }
1346 
1347     /**
1348      * @dev Throws if called by any account other than the owner.
1349      */
1350     modifier onlyOwner() {
1351         require(owner() == msg.sender, "Ownable: caller is not the owner");
1352         _;
1353     }
1354 
1355     /**
1356      * @dev Leaves the contract without owner. It will not be possible to call
1357      * `onlyOwner` functions anymore. Can only be called by the current owner.
1358      *
1359      * NOTE: Renouncing ownership will leave the contract without an owner,
1360      * thereby removing any functionality that is only available to the owner.
1361      */
1362     function renounceOwnership() public virtual onlyOwner {
1363         _setOwner(address(0));
1364     }
1365 
1366     /**
1367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1368      * Can only be called by the current owner.
1369      */
1370     function transferOwnership(address newOwner) public virtual onlyOwner {
1371         require(newOwner != address(0), "Ownable: new owner is the zero address");
1372         _setOwner(newOwner);
1373     }
1374 
1375     function _setOwner(address newOwner) private {
1376         address oldOwner = _owner;
1377         _owner = newOwner;
1378         emit OwnershipTransferred(oldOwner, newOwner);
1379     }
1380 }
1381 
1382 contract NFTXStakingZap is Ownable, ReentrancyGuard, ERC721HolderUpgradeable, ERC1155HolderUpgradeable {
1383   IWETH public immutable WETH; 
1384   INFTXLPStaking public immutable lpStaking;
1385   INFTXVaultFactory public immutable nftxFactory;
1386   IUniswapV2Router01 public immutable sushiRouter;
1387 
1388   uint256 public lockTime = 48 hours; 
1389   uint256 constant BASE = 10**18;
1390 
1391   event UserStaked(uint256 vaultId, uint256 count, uint256 lpBalance, uint256 timelockUntil, address sender);
1392 
1393   constructor(address _nftxFactory, address _sushiRouter) Ownable() ReentrancyGuard() {
1394     nftxFactory = INFTXVaultFactory(_nftxFactory);
1395     lpStaking = INFTXLPStaking(INFTXFeeDistributor(INFTXVaultFactory(_nftxFactory).feeDistributor()).lpStaking());
1396     sushiRouter = IUniswapV2Router01(_sushiRouter);
1397     WETH = IWETH(IUniswapV2Router01(_sushiRouter).WETH());
1398     IERC20Upgradeable(address(IUniswapV2Router01(_sushiRouter).WETH())).approve(_sushiRouter, type(uint256).max);
1399   }
1400 
1401   function setLockTime(uint256 newLockTime) external onlyOwner {
1402     require(newLockTime <= 7 days, "Lock too long");
1403     lockTime = newLockTime;
1404   } 
1405 
1406   function addLiquidity721ETH(
1407     uint256 vaultId, 
1408     uint256[] memory ids, 
1409     uint256 minWethIn
1410   ) public payable returns (uint256) {
1411     return addLiquidity721ETHTo(vaultId, ids, minWethIn, msg.sender);
1412   }
1413 
1414   function addLiquidity721ETHTo(
1415     uint256 vaultId, 
1416     uint256[] memory ids, 
1417     uint256 minWethIn,
1418     address to
1419   ) public payable nonReentrant returns (uint256) {
1420     WETH.deposit{value: msg.value}();
1421     (, uint256 amountEth, uint256 liquidity) = _addLiquidity721WETH(vaultId, ids, minWethIn, msg.value, to);
1422 
1423     // Return extras.
1424     if (amountEth < msg.value) {
1425       WETH.withdraw(msg.value-amountEth);
1426       payable(to).call{value: msg.value-amountEth};
1427     }
1428 
1429     return liquidity;
1430   }
1431 
1432   function addLiquidity1155ETH(
1433     uint256 vaultId, 
1434     uint256[] memory ids, 
1435     uint256[] memory amounts,
1436     uint256 minEthIn
1437   ) public payable returns (uint256) {
1438     return addLiquidity1155ETHTo(vaultId, ids, amounts, minEthIn, msg.sender);
1439   }
1440 
1441   function addLiquidity1155ETHTo(
1442     uint256 vaultId, 
1443     uint256[] memory ids, 
1444     uint256[] memory amounts,
1445     uint256 minEthIn,
1446     address to
1447   ) public payable nonReentrant returns (uint256) {
1448     WETH.deposit{value: msg.value}();
1449     // Finish this.
1450     (, uint256 amountEth, uint256 liquidity) = _addLiquidity1155WETH(vaultId, ids, amounts, minEthIn, msg.value, to);
1451 
1452     // Return extras.
1453     if (amountEth < msg.value) {
1454       WETH.withdraw(msg.value-amountEth);
1455       payable(to).call{value: msg.value-amountEth};
1456     }
1457 
1458     return liquidity;
1459   }
1460 
1461   function addLiquidity721(
1462     uint256 vaultId, 
1463     uint256[] memory ids, 
1464     uint256 minWethIn,
1465     uint256 wethIn
1466   ) public returns (uint256) {
1467     return addLiquidity721To(vaultId, ids, minWethIn, wethIn, msg.sender);
1468   }
1469 
1470   function addLiquidity721To(
1471     uint256 vaultId, 
1472     uint256[] memory ids, 
1473     uint256 minWethIn,
1474     uint256 wethIn,
1475     address to
1476   ) public nonReentrant returns (uint256) {
1477     IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), wethIn);
1478     (, uint256 amountEth, uint256 liquidity) = _addLiquidity721WETH(vaultId, ids, minWethIn, wethIn, to);
1479 
1480     // Return extras.
1481     if (amountEth < wethIn) {
1482       WETH.transfer(to, wethIn-amountEth);
1483     }
1484 
1485     return liquidity;
1486   }
1487 
1488   function addLiquidity1155(
1489     uint256 vaultId, 
1490     uint256[] memory ids,
1491     uint256[] memory amounts,
1492     uint256 minWethIn,
1493     uint256 wethIn
1494   ) public returns (uint256) {
1495     return addLiquidity1155To(vaultId, ids, amounts, minWethIn, wethIn, msg.sender);
1496   }
1497 
1498   function addLiquidity1155To(
1499     uint256 vaultId, 
1500     uint256[] memory ids,
1501     uint256[] memory amounts,
1502     uint256 minWethIn,
1503     uint256 wethIn,
1504     address to
1505   ) public nonReentrant returns (uint256) {
1506     IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), wethIn);
1507     (, uint256 amountEth, uint256 liquidity) = _addLiquidity1155WETH(vaultId, ids, amounts, minWethIn, wethIn, to);
1508 
1509     // Return extras.
1510     if (amountEth < wethIn) {
1511       WETH.transfer(to, wethIn-amountEth);
1512     }
1513 
1514     return liquidity;
1515   }
1516 
1517   function lockedUntil(uint256 vaultId, address who) external view returns (uint256) {
1518     address xLPToken = lpStaking.newRewardDistributionToken(vaultId);
1519     return ITimelockRewardDistributionToken(xLPToken).timelockUntil(who);
1520   }
1521 
1522   function lockedLPBalance(uint256 vaultId, address who) external view returns (uint256) {
1523     ITimelockRewardDistributionToken xLPToken = ITimelockRewardDistributionToken(lpStaking.newRewardDistributionToken(vaultId));
1524     if(block.timestamp > xLPToken.timelockUntil(who)) {
1525       return 0;
1526     }
1527     return xLPToken.balanceOf(who);
1528   }
1529 
1530   function _addLiquidity721WETH(
1531     uint256 vaultId, 
1532     uint256[] memory ids, 
1533     uint256 minWethIn,
1534     uint256 wethIn,
1535     address to
1536   ) internal returns (uint256, uint256, uint256) {
1537     address vault = nftxFactory.vault(vaultId);
1538     require(vault != address(0), "NFTXZap: Vault does not exist");
1539 
1540     // Transfer tokens to zap and mint to NFTX.
1541     address assetAddress = INFTXVault(vault).assetAddress();
1542     for (uint256 i = 0; i < ids.length; i++) {
1543       transferFromERC721(assetAddress, ids[i]);
1544       approveERC721(assetAddress, vault, ids[i]);
1545     }
1546     uint256[] memory emptyIds;
1547     uint256 count = INFTXVault(vault).mint(ids, emptyIds);
1548     uint256 balance = (count * BASE); // We should not be experiencing fees.
1549     require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");
1550     
1551     return _addLiquidityAndLock(vaultId, vault, balance, minWethIn, wethIn, to);
1552   }
1553 
1554   function _addLiquidity1155WETH(
1555     uint256 vaultId, 
1556     uint256[] memory ids,
1557     uint256[] memory amounts,
1558     uint256 minWethIn,
1559     uint256 wethIn,
1560     address to
1561   ) internal returns (uint256, uint256, uint256) {
1562     address vault = nftxFactory.vault(vaultId);
1563     require(vault != address(0), "NFTXZap: Vault does not exist");
1564 
1565     // Transfer tokens to zap and mint to NFTX.
1566     address assetAddress = INFTXVault(vault).assetAddress();
1567     IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), ids, amounts, "");
1568     IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
1569     uint256 count = INFTXVault(vault).mint(ids, amounts);
1570     uint256 balance = (count * BASE); // We should not be experiencing fees.
1571     require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");
1572     
1573     return _addLiquidityAndLock(vaultId, vault, balance, minWethIn, wethIn, to);
1574   }
1575 
1576   function _addLiquidityAndLock(
1577     uint256 vaultId, 
1578     address vault, 
1579     uint256 minTokenIn, 
1580     uint256 minWethIn, 
1581     uint256 wethIn,
1582     address to
1583   ) internal returns (uint256, uint256, uint256) {
1584     // Provide liquidity.
1585     IERC20Upgradeable(vault).approve(address(sushiRouter), minTokenIn);
1586     (uint256 amountToken, uint256 amountEth, uint256 liquidity) = sushiRouter.addLiquidity(
1587       address(vault), 
1588       sushiRouter.WETH(),
1589       minTokenIn, 
1590       wethIn, 
1591       minTokenIn,
1592       minWethIn,
1593       address(this), 
1594       block.timestamp
1595     );
1596 
1597     // Stake in LP rewards contract 
1598     address lpToken = pairFor(vault, address(WETH));
1599     IERC20Upgradeable(lpToken).approve(address(lpStaking), liquidity);
1600     lpStaking.timelockDepositFor(vaultId, to, liquidity, lockTime);
1601     
1602     if (amountToken < minTokenIn) {
1603       IERC20Upgradeable(vault).transfer(to, minTokenIn-amountToken);
1604     }
1605 
1606     uint256 lockEndTime = block.timestamp + lockTime;
1607     emit UserStaked(vaultId, minTokenIn, liquidity, lockEndTime, to);
1608     return (amountToken, amountEth, liquidity);
1609   }
1610 
1611   function transferFromERC721(address assetAddr, uint256 tokenId) internal virtual {
1612     address kitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
1613     address punks = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
1614     bytes memory data;
1615     if (assetAddr == kitties) {
1616         // Cryptokitties.
1617         data = abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), tokenId);
1618     } else if (assetAddr == punks) {
1619         // CryptoPunks.
1620         // Fix here for frontrun attack. Added in v1.0.2.
1621         bytes memory punkIndexToAddress = abi.encodeWithSignature("punkIndexToAddress(uint256)", tokenId);
1622         (bool checkSuccess, bytes memory result) = address(assetAddr).staticcall(punkIndexToAddress);
1623         (address owner) = abi.decode(result, (address));
1624         require(checkSuccess && owner == msg.sender, "Not the owner");
1625         data = abi.encodeWithSignature("buyPunk(uint256)", tokenId);
1626     } else {
1627         // Default.
1628         data = abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", msg.sender, address(this), tokenId);
1629     }
1630     (bool success, bytes memory resultData) = address(assetAddr).call(data);
1631     require(success, string(resultData));
1632   }
1633 
1634   function approveERC721(address assetAddr, address to, uint256 tokenId) internal virtual {
1635     address kitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
1636     address punks = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
1637     bytes memory data;
1638     if (assetAddr == kitties) {
1639         // Cryptokitties.
1640         data = abi.encodeWithSignature("approve(address,uint256)", to, tokenId);
1641     } else if (assetAddr == punks) {
1642         // CryptoPunks.
1643         data = abi.encodeWithSignature("offerPunkForSaleToAddress(uint256,uint256,address)", tokenId, 0, to);
1644     } else {
1645         if (IERC721(assetAddr).isApprovedForAll(address(this), to)) {
1646           return;
1647         }
1648         // Default.
1649         data = abi.encodeWithSignature("setApprovalForAll(address,bool)", to, true);
1650     }
1651     (bool success, bytes memory resultData) = address(assetAddr).call(data);
1652     require(success, string(resultData));
1653   }
1654 
1655   // calculates the CREATE2 address for a pair without making any external calls
1656   function pairFor(address tokenA, address tokenB) internal view returns (address pair) {
1657     (address token0, address token1) = sortTokens(tokenA, tokenB);
1658     pair = address(uint160(uint256(keccak256(abi.encodePacked(
1659       hex'ff',
1660       sushiRouter.factory(),
1661       keccak256(abi.encodePacked(token0, token1)),
1662       hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
1663     )))));
1664   }
1665 
1666   // returns sorted token addresses, used to handle return values from pairs sorted in this order
1667   function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1668       require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1669       (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1670       require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1671   }
1672 
1673   receive() external payable {
1674 
1675   }
1676 }