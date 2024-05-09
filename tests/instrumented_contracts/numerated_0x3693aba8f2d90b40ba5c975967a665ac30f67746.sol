1 // Sources flattened with hardhat v2.4.1 https://hardhat.org
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
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev This is the interface that {BeaconProxy} expects of its beacon.
43  */
44 interface IBeacon {
45     /**
46      * @dev Must return an address that can be used as a delegate call target.
47      *
48      * {BeaconProxy} will check that this address is a contract.
49      */
50     function childImplementation() external view returns (address);
51     function upgradeChildTo(address newImplementation) external;
52 }
53 
54 
55 // File contracts/solidity/interface/INFTXVaultFactory.sol
56 
57 pragma solidity ^0.8.0;
58 
59 interface INFTXVaultFactory is IBeacon {
60   // Read functions.
61   function numVaults() external view returns (uint256);
62   function zapContract() external view returns (address);
63   function feeDistributor() external view returns (address);
64   function eligibilityManager() external view returns (address);
65   function vault(uint256 vaultId) external view returns (address);
66   function vaultsForAsset(address asset) external view returns (address[] memory);
67   function isLocked(uint256 id) external view returns (bool);
68   function excludedFromFees(address addr) external view returns (bool);
69 
70   event NewFeeDistributor(address oldDistributor, address newDistributor);
71   event NewZapContract(address oldZap, address newZap);
72   event FeeExclusion(address feeExcluded, bool excluded);
73   event NewEligibilityManager(address oldEligManager, address newEligManager);
74   event NewVault(uint256 indexed vaultId, address vaultAddress, address assetAddress);
75 
76   // Write functions.
77   function __NFTXVaultFactory_init(address _vaultImpl, address _feeDistributor) external;
78   function createVault(
79       string calldata name,
80       string calldata symbol,
81       address _assetAddress,
82       bool is1155,
83       bool allowAllItems
84   ) external returns (uint256);
85   function setFeeDistributor(address _feeDistributor) external;
86   function setEligibilityManager(address _eligibilityManager) external;
87   function setZapContract(address _zapContract) external;
88   function setFeeExclusion(address _excludedAddr, bool excluded) external;
89 }
90 
91 
92 // File contracts/solidity/interface/INFTXVault.sol
93 
94 pragma solidity ^0.8.0;
95 
96 
97 interface INFTXVault {
98     function manager() external returns (address);
99     function assetAddress() external returns (address);
100     function vaultFactory() external returns (INFTXVaultFactory);
101     function eligibilityStorage() external returns (INFTXEligibility);
102 
103     function is1155() external returns (bool);
104     function allowAllItems() external returns (bool);
105     function enableMint() external returns (bool);
106     function enableRandomRedeem() external returns (bool);
107     function enableTargetRedeem() external returns (bool);
108 
109     function vaultId() external returns (uint256);
110     function nftIdAt(uint256 holdingsIndex) external view returns (uint256);
111     function allHoldings() external view returns (uint256[] memory);
112     function totalHoldings() external view returns (uint256);
113     function mintFee() external returns (uint256);
114     function randomRedeemFee() external returns (uint256);
115     function targetRedeemFee() external returns (uint256);
116 
117     event VaultInit(
118         uint256 indexed vaultId,
119         address assetAddress,
120         bool is1155,
121         bool allowAllItems
122     );
123 
124     event ManagerSet(address manager);
125     event EligibilityDeployed(uint256 moduleIndex, address eligibilityAddr);
126     // event CustomEligibilityDeployed(address eligibilityAddr);
127 
128     event EnableMintUpdated(bool enabled);
129     event EnableRandomRedeemUpdated(bool enabled);
130     event EnableTargetRedeemUpdated(bool enabled);
131 
132     event MintFeeUpdated(uint256 mintFee);
133     event RandomRedeemFeeUpdated(uint256 randomRedeemFee);
134     event TargetRedeemFeeUpdated(uint256 targetRedeemFee);
135 
136     event Minted(uint256[] nftIds, uint256[] amounts, address to);
137     event Redeemed(uint256[] nftIds, uint256[] specificIds, address to);
138     event Swapped(
139         uint256[] nftIds,
140         uint256[] amounts,
141         uint256[] specificIds,
142         uint256[] redeemedIds,
143         address to
144     );
145 
146     function __NFTXVault_init(
147         string calldata _name,
148         string calldata _symbol,
149         address _assetAddress,
150         bool _is1155,
151         bool _allowAllItems
152     ) external;
153 
154     function finalizeVault() external;
155 
156     function setVaultMetadata(
157         string memory name_, 
158         string memory symbol_
159     ) external;
160 
161     function setVaultFeatures(
162         bool _enableMint,
163         bool _enableRandomRedeem,
164         bool _enableTargetRedeem
165     ) external;
166 
167     function setFees(
168         uint256 _mintFee,
169         uint256 _randomRedeemFee,
170         uint256 _targetRedeemFee
171     ) external;
172 
173     // This function allows for an easy setup of any eligibility module contract from the EligibilityManager.
174     // It takes in ABI encoded parameters for the desired module. This is to make sure they can all follow
175     // a similar interface.
176     function deployEligibilityStorage(
177         uint256 moduleIndex,
178         bytes calldata initData
179     ) external returns (address);
180 
181     // The manager has control over options like fees and features
182     function setManager(address _manager) external;
183 
184     function mint(
185         uint256[] calldata tokenIds,
186         uint256[] calldata amounts /* ignored for ERC721 vaults */
187     ) external returns (uint256);
188 
189     function mintTo(
190         uint256[] calldata tokenIds,
191         uint256[] calldata amounts, /* ignored for ERC721 vaults */
192         address to
193     ) external returns (uint256);
194 
195     function redeem(uint256 amount, uint256[] calldata specificIds)
196         external
197         returns (uint256[] calldata);
198 
199     function redeemTo(
200         uint256 amount,
201         uint256[] calldata specificIds,
202         address to
203     ) external returns (uint256[] calldata);
204 
205     function swap(
206         uint256[] calldata tokenIds,
207         uint256[] calldata amounts, /* ignored for ERC721 vaults */
208         uint256[] calldata specificIds
209     ) external returns (uint256[] calldata);
210 
211     function swapTo(
212         uint256[] calldata tokenIds,
213         uint256[] calldata amounts, /* ignored for ERC721 vaults */
214         uint256[] calldata specificIds,
215         address to
216     ) external returns (uint256[] calldata);
217 
218     function allValidNFTs(uint256[] calldata tokenIds)
219         external
220         view
221         returns (bool);
222 }
223 
224 
225 // File contracts/solidity/interface/INFTXFeeDistributor.sol
226 
227 pragma solidity ^0.8.0;
228 
229 interface INFTXFeeDistributor {
230   
231   struct FeeReceiver {
232     uint256 allocPoint;
233     address receiver;
234     bool isContract;
235   }
236 
237   function nftxVaultFactory() external returns (address);
238   function lpStaking() external returns (address);
239   function treasury() external returns (address);
240   function defaultTreasuryAlloc() external returns (uint256);
241   function defaultLPAlloc() external returns (uint256);
242   function allocTotal(uint256 vaultId) external returns (uint256);
243   function specificTreasuryAlloc(uint256 vaultId) external returns (uint256);
244 
245   // Write functions.
246   function __FeeDistributor__init__(address _lpStaking, address _treasury) external;
247   function rescueTokens(address token) external;
248   function distribute(uint256 vaultId) external;
249   function addReceiver(uint256 _vaultId, uint256 _allocPoint, address _receiver, bool _isContract) external;
250   function initializeVaultReceivers(uint256 _vaultId) external;
251   function changeMultipleReceiverAlloc(
252     uint256[] memory _vaultIds, 
253     uint256[] memory _receiverIdxs, 
254     uint256[] memory allocPoints
255   ) external;
256 
257   function changeMultipleReceiverAddress(
258     uint256[] memory _vaultIds, 
259     uint256[] memory _receiverIdxs, 
260     address[] memory addresses, 
261     bool[] memory isContracts
262   ) external;
263   function changeReceiverAlloc(uint256 _vaultId, uint256 _idx, uint256 _allocPoint) external;
264   function changeReceiverAddress(uint256 _vaultId, uint256 _idx, address _address, bool _isContract) external;
265   function removeReceiver(uint256 _vaultId, uint256 _receiverIdx) external;
266 
267   // Configuration functions.
268   function setTreasuryAddress(address _treasury) external;
269   function setDefaultTreasuryAlloc(uint256 _allocPoint) external;
270   function setSpecificTreasuryAlloc(uint256 _vaultId, uint256 _allocPoint) external;
271   function setLPStakingAddress(address _lpStaking) external;
272   function setNFTXVaultFactory(address _factory) external;
273   function setDefaultLPAlloc(uint256 _allocPoint) external;
274 }
275 
276 
277 // File contracts/solidity/interface/INFTXLPStaking.sol
278 
279 pragma solidity ^0.8.0;
280 
281 interface INFTXLPStaking {
282     function nftxVaultFactory() external view returns (address);
283     function rewardDistTokenImpl() external view returns (address);
284     function stakingTokenProvider() external view returns (address);
285     function vaultToken(address _stakingToken) external view returns (address);
286     function stakingToken(address _vaultToken) external view returns (address);
287     function rewardDistributionToken(uint256 vaultId) external view returns (address);
288     function newRewardDistributionToken(uint256 vaultId) external view returns (address);
289     function oldRewardDistributionToken(uint256 vaultId) external view returns (address);
290     function unusedRewardDistributionToken(uint256 vaultId) external view returns (address);
291     function rewardDistributionTokenAddr(address stakingToken, address rewardToken) external view returns (address);
292     
293     // Write functions.
294     function __NFTXLPStaking__init(address _stakingTokenProvider) external;
295     function setNFTXVaultFactory(address newFactory) external;
296     function setStakingTokenProvider(address newProvider) external;
297     function addPoolForVault(uint256 vaultId) external;
298     function updatePoolForVault(uint256 vaultId) external;
299     function updatePoolForVaults(uint256[] calldata vaultId) external;
300     function receiveRewards(uint256 vaultId, uint256 amount) external returns (bool);
301     function deposit(uint256 vaultId, uint256 amount) external;
302     function timelockDepositFor(uint256 vaultId, address account, uint256 amount, uint256 timelockLength) external;
303     function exit(uint256 vaultId, uint256 amount) external;
304     function rescue(uint256 vaultId) external;
305     function withdraw(uint256 vaultId, uint256 amount) external;
306     function claimRewards(uint256 vaultId) external;
307 }
308 
309 
310 // File contracts/solidity/token/IERC20Upgradeable.sol
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Interface of the ERC20 standard as defined in the EIP.
316  */
317 interface IERC20Upgradeable {
318     /**
319      * @dev Returns the amount of tokens in existence.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns the amount of tokens owned by `account`.
325      */
326     function balanceOf(address account) external view returns (uint256);
327 
328     /**
329      * @dev Moves `amount` tokens from the caller's account to `recipient`.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transfer(address recipient, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Returns the remaining number of tokens that `spender` will be
339      * allowed to spend on behalf of `owner` through {transferFrom}. This is
340      * zero by default.
341      *
342      * This value changes when {approve} or {transferFrom} are called.
343      */
344     function allowance(address owner, address spender) external view returns (uint256);
345 
346     /**
347      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * IMPORTANT: Beware that changing an allowance with this method brings the risk
352      * that someone may use both the old and the new allowance by unfortunate
353      * transaction ordering. One possible solution to mitigate this race
354      * condition is to first reduce the spender's allowance to 0 and set the
355      * desired value afterwards:
356      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357      *
358      * Emits an {Approval} event.
359      */
360     function approve(address spender, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Moves `amount` tokens from `sender` to `recipient` using the
364      * allowance mechanism. `amount` is then deducted from the caller's
365      * allowance.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Emitted when `value` tokens are moved from one account (`from`) to
375      * another (`to`).
376      *
377      * Note that `value` may be zero.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 value);
380 
381     /**
382      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
383      * a call to {approve}. `value` is the new allowance.
384      */
385     event Approval(address indexed owner, address indexed spender, uint256 value);
386 }
387 
388 
389 // File contracts/solidity/interface/ITimelockRewardDistributionToken.sol
390 
391 pragma solidity ^0.8.0;
392 
393 interface ITimelockRewardDistributionToken is IERC20Upgradeable {
394   function distributeRewards(uint amount) external;
395   function __TimelockRewardDistributionToken_init(IERC20Upgradeable _target, string memory _name, string memory _symbol) external;
396   function mint(address account, address to, uint256 amount) external;
397   function timelockMint(address account, uint256 amount, uint256 timelockLength) external;
398   function burnFrom(address account, uint256 amount) external;
399   function withdrawReward(address user) external;
400   function dividendOf(address _owner) external view returns(uint256);
401   function withdrawnRewardOf(address _owner) external view returns(uint256);
402   function accumulativeRewardOf(address _owner) external view returns(uint256);
403   function timelockUntil(address account) external view returns (uint256);
404 }
405 
406 
407 // File contracts/solidity/interface/IUniswapV2Router01.sol
408 
409 pragma solidity ^0.8.0;
410 
411 interface IUniswapV2Router01 {
412     function factory() external pure returns (address);
413     function WETH() external pure returns (address);
414 
415     function addLiquidity(
416         address tokenA,
417         address tokenB,
418         uint256 amountADesired,
419         uint256 amountBDesired,
420         uint256 amountAMin,
421         uint256 amountBMin,
422         address to,
423         uint256 deadline
424     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
425     function addLiquidityETH(
426         address token,
427         uint256 amountTokenDesired,
428         uint256 amountTokenMin,
429         uint256 amountETHMin,
430         address to,
431         uint256 deadline
432     )
433         external
434         payable
435         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
436     function removeLiquidity(
437         address tokenA,
438         address tokenB,
439         uint256 liquidity,
440         uint256 amountAMin,
441         uint256 amountBMin,
442         address to,
443         uint256 deadline
444     ) external returns (uint256 amountA, uint256 amountB);
445     function removeLiquidityETH(
446         address token,
447         uint256 liquidity,
448         uint256 amountTokenMin,
449         uint256 amountETHMin,
450         address to,
451         uint256 deadline
452     ) external returns (uint256 amountToken, uint256 amountETH);
453     function removeLiquidityWithPermit(
454         address tokenA,
455         address tokenB,
456         uint256 liquidity,
457         uint256 amountAMin,
458         uint256 amountBMin,
459         address to,
460         uint256 deadline,
461         bool approveMax,
462         uint8 v,
463         bytes32 r,
464         bytes32 s
465     ) external returns (uint256 amountA, uint256 amountB);
466     function removeLiquidityETHWithPermit(
467         address token,
468         uint256 liquidity,
469         uint256 amountTokenMin,
470         uint256 amountETHMin,
471         address to,
472         uint256 deadline,
473         bool approveMax,
474         uint8 v,
475         bytes32 r,
476         bytes32 s
477     ) external returns (uint256 amountToken, uint256 amountETH);
478     function swapExactTokensForTokens(
479         uint256 amountIn,
480         uint256 amountOutMin,
481         address[] calldata path,
482         address to,
483         uint256 deadline
484     ) external returns (uint256[] memory amounts);
485     function swapTokensForExactTokens(
486         uint256 amountOut,
487         uint256 amountInMax,
488         address[] calldata path,
489         address to,
490         uint256 deadline
491     ) external returns (uint256[] memory amounts);
492     function swapExactETHForTokens(
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external payable returns (uint256[] memory amounts);
498     function swapTokensForExactETH(
499         uint256 amountOut,
500         uint256 amountInMax,
501         address[] calldata path,
502         address to,
503         uint256 deadline
504     ) external returns (uint256[] memory amounts);
505     function swapExactTokensForETH(
506         uint256 amountIn,
507         uint256 amountOutMin,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external returns (uint256[] memory amounts);
512     function swapETHForExactTokens(
513         uint256 amountOut,
514         address[] calldata path,
515         address to,
516         uint256 deadline
517     ) external payable returns (uint256[] memory amounts);
518 
519     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB)
520         external
521         pure
522         returns (uint256 amountB);
523     function getAmountOut(
524         uint256 amountIn,
525         uint256 reserveIn,
526         uint256 reserveOut
527     ) external pure returns (uint256 amountOut);
528     function getAmountIn(
529         uint256 amountOut,
530         uint256 reserveIn,
531         uint256 reserveOut
532     ) external pure returns (uint256 amountIn);
533     function getAmountsOut(uint256 amountIn, address[] calldata path)
534         external
535         view
536         returns (uint256[] memory amounts);
537     function getAmountsIn(uint256 amountOut, address[] calldata path)
538         external
539         view
540         returns (uint256[] memory amounts);
541 }
542 
543 
544 // File contracts/solidity/testing/IERC165.sol
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Interface of the ERC165 standard, as defined in the
550  * https://eips.ethereum.org/EIPS/eip-165[EIP].
551  *
552  * Implementers can declare support of contract interfaces, which can then be
553  * queried by others ({ERC165Checker}).
554  *
555  * For an implementation, see {ERC165}.
556  */
557 interface IERC165 {
558     /**
559      * @dev Returns true if this contract implements the interface defined by
560      * `interfaceId`. See the corresponding
561      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
562      * to learn more about how these ids are created.
563      *
564      * This function call must use less than 30 000 gas.
565      */
566     function supportsInterface(bytes4 interfaceId) external view returns (bool);
567 }
568 
569 
570 // File contracts/solidity/testing/IERC721.sol
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Required interface of an ERC721 compliant contract.
576  */
577 interface IERC721 is IERC165 {
578     /**
579      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
580      */
581     event Transfer(
582         address indexed from,
583         address indexed to,
584         uint256 indexed tokenId
585     );
586 
587     /**
588      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
589      */
590     event Approval(
591         address indexed owner,
592         address indexed approved,
593         uint256 indexed tokenId
594     );
595 
596     /**
597      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
598      */
599     event ApprovalForAll(
600         address indexed owner,
601         address indexed operator,
602         bool approved
603     );
604 
605     /**
606      * @dev Returns the number of tokens in ``owner``'s account.
607      */
608     function balanceOf(address owner) external view returns (uint256 balance);
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) external view returns (address owner);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Returns the account approved for `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function getApproved(uint256 tokenId)
682         external
683         view
684         returns (address operator);
685 
686     /**
687      * @dev Approve or remove `operator` as an operator for the caller.
688      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
689      *
690      * Requirements:
691      *
692      * - The `operator` cannot be the caller.
693      *
694      * Emits an {ApprovalForAll} event.
695      */
696     function setApprovalForAll(address operator, bool _approved) external;
697 
698     /**
699      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
700      *
701      * See {setApprovalForAll}
702      */
703     function isApprovedForAll(address owner, address operator)
704         external
705         view
706         returns (bool);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes calldata data
726     ) external;
727 }
728 
729 
730 // File contracts/solidity/interface/IERC165Upgradeable.sol
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Interface of the ERC165 standard, as defined in the
736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
737  *
738  * Implementers can declare support of contract interfaces, which can then be
739  * queried by others ({ERC165Checker}).
740  *
741  * For an implementation, see {ERC165}.
742  */
743 interface IERC165Upgradeable {
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30 000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 }
754 
755 
756 // File contracts/solidity/token/IERC1155Upgradeable.sol
757 
758 pragma solidity ^0.8.0;
759 
760 /**
761  * @dev Required interface of an ERC1155 compliant contract, as defined in the
762  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
763  *
764  * _Available since v3.1._
765  */
766 interface IERC1155Upgradeable is IERC165Upgradeable {
767     /**
768      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
769      */
770     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
771 
772     /**
773      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
774      * transfers.
775      */
776     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
777 
778     /**
779      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
780      * `approved`.
781      */
782     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
783 
784     /**
785      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
786      *
787      * If an {URI} event was emitted for `id`, the standard
788      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
789      * returned by {IERC1155MetadataURI-uri}.
790      */
791     event URI(string value, uint256 indexed id);
792 
793     /**
794      * @dev Returns the amount of tokens of token type `id` owned by `account`.
795      *
796      * Requirements:
797      *
798      * - `account` cannot be the zero address.
799      */
800     function balanceOf(address account, uint256 id) external view returns (uint256);
801 
802     /**
803      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
804      *
805      * Requirements:
806      *
807      * - `accounts` and `ids` must have the same length.
808      */
809     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
810 
811     /**
812      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
813      *
814      * Emits an {ApprovalForAll} event.
815      *
816      * Requirements:
817      *
818      * - `operator` cannot be the caller.
819      */
820     function setApprovalForAll(address operator, bool approved) external;
821 
822     /**
823      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
824      *
825      * See {setApprovalForAll}.
826      */
827     function isApprovedForAll(address account, address operator) external view returns (bool);
828 
829     /**
830      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
831      *
832      * Emits a {TransferSingle} event.
833      *
834      * Requirements:
835      *
836      * - `to` cannot be the zero address.
837      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
838      * - `from` must have a balance of tokens of type `id` of at least `amount`.
839      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
840      * acceptance magic value.
841      */
842     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
843 
844     /**
845      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
846      *
847      * Emits a {TransferBatch} event.
848      *
849      * Requirements:
850      *
851      * - `ids` and `amounts` must have the same length.
852      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
853      * acceptance magic value.
854      */
855     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
856 }
857 
858 
859 // File contracts/solidity/token/IERC721ReceiverUpgradeable.sol
860 
861 pragma solidity ^0.8.0;
862 
863 /**
864  * @title ERC721 token receiver interface
865  * @dev Interface for any contract that wants to support safeTransfers
866  * from ERC721 asset contracts.
867  */
868 interface IERC721ReceiverUpgradeable {
869     /**
870      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
871      * by `operator` from `from`, this function is called.
872      *
873      * It must return its Solidity selector to confirm the token transfer.
874      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
875      *
876      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
877      */
878     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
879 }
880 
881 
882 // File contracts/solidity/token/ERC721HolderUpgradeable.sol
883 
884 pragma solidity ^0.8.0;
885 
886 /**
887  * @dev Implementation of the {IERC721Receiver} interface.
888  *
889  * Accepts all token transfers.
890  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
891  */
892 contract ERC721HolderUpgradeable is IERC721ReceiverUpgradeable {
893     /**
894      * @dev See {IERC721Receiver-onERC721Received}.
895      *
896      * Always returns `IERC721Receiver.onERC721Received.selector`.
897      */
898     function onERC721Received(
899         address,
900         address,
901         uint256,
902         bytes memory
903     ) public virtual override returns (bytes4) {
904         return this.onERC721Received.selector;
905     }
906 }
907 
908 
909 // File contracts/solidity/token/IERC1155ReceiverUpgradeable.sol
910 
911 pragma solidity ^0.8.0;
912 
913 /**
914  * @dev _Available since v3.1._
915  */
916 interface IERC1155ReceiverUpgradeable is IERC165Upgradeable {
917 
918     /**
919         @dev Handles the receipt of a single ERC1155 token type. This function is
920         called at the end of a `safeTransferFrom` after the balance has been updated.
921         To accept the transfer, this must return
922         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
923         (i.e. 0xf23a6e61, or its own function selector).
924         @param operator The address which initiated the transfer (i.e. msg.sender)
925         @param from The address which previously owned the token
926         @param id The ID of the token being transferred
927         @param value The amount of tokens being transferred
928         @param data Additional data with no specified format
929         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
930     */
931     function onERC1155Received(
932         address operator,
933         address from,
934         uint256 id,
935         uint256 value,
936         bytes calldata data
937     )
938         external
939         returns(bytes4);
940 
941     /**
942         @dev Handles the receipt of a multiple ERC1155 token types. This function
943         is called at the end of a `safeBatchTransferFrom` after the balances have
944         been updated. To accept the transfer(s), this must return
945         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
946         (i.e. 0xbc197c81, or its own function selector).
947         @param operator The address which initiated the batch transfer (i.e. msg.sender)
948         @param from The address which previously owned the token
949         @param ids An array containing ids of each token being transferred (order and length must match values array)
950         @param values An array containing amounts of each token being transferred (order and length must match ids array)
951         @param data Additional data with no specified format
952         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
953     */
954     function onERC1155BatchReceived(
955         address operator,
956         address from,
957         uint256[] calldata ids,
958         uint256[] calldata values,
959         bytes calldata data
960     )
961         external
962         returns(bytes4);
963 }
964 
965 
966 // File contracts/solidity/util/ERC165Upgradeable.sol
967 
968 pragma solidity ^0.8.0;
969 
970 /**
971  * @dev Implementation of the {IERC165} interface.
972  *
973  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
974  * for the additional interface id that will be supported. For example:
975  *
976  * ```solidity
977  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
978  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
979  * }
980  * ```
981  *
982  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
983  */
984 abstract contract ERC165Upgradeable is IERC165Upgradeable {
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
989         return interfaceId == type(IERC165Upgradeable).interfaceId;
990     }
991 }
992 
993 
994 // File contracts/solidity/token/ERC1155ReceiverUpgradeable.sol
995 
996 pragma solidity ^0.8.0;
997 
998 
999 /**
1000  * @dev _Available since v3.1._
1001  */
1002 abstract contract ERC1155ReceiverUpgradeable is ERC165Upgradeable, IERC1155ReceiverUpgradeable {
1003     /**
1004      * @dev See {IERC165-supportsInterface}.
1005      */
1006     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1007         return interfaceId == type(IERC1155ReceiverUpgradeable).interfaceId
1008             || super.supportsInterface(interfaceId);
1009     }
1010 }
1011 
1012 
1013 // File contracts/solidity/token/ERC1155HolderUpgradeable.sol
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @dev _Available since v3.1._
1019  */
1020 abstract contract ERC1155HolderUpgradeable is ERC1155ReceiverUpgradeable {
1021     function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
1022         return this.onERC1155Received.selector;
1023     }
1024 
1025     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
1026         return this.onERC1155BatchReceived.selector;
1027     }
1028 }
1029 
1030 
1031 // File contracts/solidity/proxy/Initializable.sol
1032 
1033 // solhint-disable-next-line compiler-version
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1038  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1039  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1040  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1041  *
1042  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1043  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1044  *
1045  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1046  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1047  */
1048 abstract contract Initializable {
1049 
1050     /**
1051      * @dev Indicates that the contract has been initialized.
1052      */
1053     bool private _initialized;
1054 
1055     /**
1056      * @dev Indicates that the contract is in the process of being initialized.
1057      */
1058     bool private _initializing;
1059 
1060     /**
1061      * @dev Modifier to protect an initializer function from being invoked twice.
1062      */
1063     modifier initializer() {
1064         require(_initializing || !_initialized, "Initializable: contract is already initialized");
1065 
1066         bool isTopLevelCall = !_initializing;
1067         if (isTopLevelCall) {
1068             _initializing = true;
1069             _initialized = true;
1070         }
1071 
1072         _;
1073 
1074         if (isTopLevelCall) {
1075             _initializing = false;
1076         }
1077     }
1078 }
1079 
1080 
1081 // File contracts/solidity/util/ContextUpgradeable.sol
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 /*
1086  * @dev Provides information about the current execution context, including the
1087  * sender of the transaction and its data. While these are generally available
1088  * via msg.sender and msg.data, they should not be accessed in such a direct
1089  * manner, since when dealing with meta-transactions the account sending and
1090  * paying for execution may not be the actual sender (as far as an application
1091  * is concerned).
1092  *
1093  * This contract is only required for intermediate, library-like contracts.
1094  */
1095 abstract contract ContextUpgradeable is Initializable {
1096     function __Context_init() internal initializer {
1097         __Context_init_unchained();
1098     }
1099 
1100     function __Context_init_unchained() internal initializer {
1101     }
1102     function _msgSender() internal view virtual returns (address) {
1103         return msg.sender;
1104     }
1105 
1106     function _msgData() internal view virtual returns (bytes calldata) {
1107         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1108         return msg.data;
1109     }
1110     uint256[50] private __gap;
1111 }
1112 
1113 
1114 // File contracts/solidity/util/OwnableUpgradeable.sol
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 
1119 /**
1120  * @dev Contract module which provides a basic access control mechanism, where
1121  * there is an account (an owner) that can be granted exclusive access to
1122  * specific functions.
1123  *
1124  * By default, the owner account will be the one that deploys the contract. This
1125  * can later be changed with {transferOwnership}.
1126  *
1127  * This module is used through inheritance. It will make available the modifier
1128  * `onlyOwner`, which can be applied to your functions to restrict their use to
1129  * the owner.
1130  */
1131 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1132     address private _owner;
1133 
1134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1135 
1136     /**
1137      * @dev Initializes the contract setting the deployer as the initial owner.
1138      */
1139     function __Ownable_init() internal initializer {
1140         __Context_init_unchained();
1141         __Ownable_init_unchained();
1142     }
1143 
1144     function __Ownable_init_unchained() internal initializer {
1145         address msgSender = _msgSender();
1146         _owner = msgSender;
1147         emit OwnershipTransferred(address(0), msgSender);
1148     }
1149 
1150     /**
1151      * @dev Returns the address of the current owner.
1152      */
1153     function owner() public view virtual returns (address) {
1154         return _owner;
1155     }
1156 
1157     /**
1158      * @dev Throws if called by any account other than the owner.
1159      */
1160     modifier onlyOwner() {
1161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1162         _;
1163     }
1164 
1165     /**
1166      * @dev Leaves the contract without owner. It will not be possible to call
1167      * `onlyOwner` functions anymore. Can only be called by the current owner.
1168      *
1169      * NOTE: Renouncing ownership will leave the contract without an owner,
1170      * thereby removing any functionality that is only available to the owner.
1171      */
1172     function renounceOwnership() public virtual onlyOwner {
1173         emit OwnershipTransferred(_owner, address(0));
1174         _owner = address(0);
1175     }
1176 
1177     /**
1178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1179      * Can only be called by the current owner.
1180      */
1181     function transferOwnership(address newOwner) public virtual onlyOwner {
1182         require(newOwner != address(0), "Ownable: new owner is the zero address");
1183         emit OwnershipTransferred(_owner, newOwner);
1184         _owner = newOwner;
1185     }
1186     uint256[49] private __gap;
1187 }
1188 
1189 
1190 // File contracts/solidity/NFTXMarketplaceZap.sol
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 // Authors: @0xKiwi_.
1206 
1207 interface IWETH {
1208   function deposit() external payable;
1209   function transfer(address to, uint value) external returns (bool);
1210   function withdraw(uint) external;
1211   function balanceOf(address to) external view returns (uint256);
1212 }
1213 
1214 /**
1215  * @dev Contract module that helps prevent reentrant calls to a function.
1216  *
1217  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1218  * available, which can be applied to functions to make sure there are no nested
1219  * (reentrant) calls to them.
1220  *
1221  * Note that because there is a single `nonReentrant` guard, functions marked as
1222  * `nonReentrant` may not call one another. This can be worked around by making
1223  * those functions `private`, and then adding `external` `nonReentrant` entry
1224  * points to them.
1225  *
1226  * TIP: If you would like to learn more about reentrancy and alternative ways
1227  * to protect against it, check out our blog post
1228  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1229  */
1230 abstract contract ReentrancyGuard {
1231     // Booleans are more expensive than uint256 or any type that takes up a full
1232     // word because each write operation emits an extra SLOAD to first read the
1233     // slot's contents, replace the bits taken up by the boolean, and then write
1234     // back. This is the compiler's defense against contract upgrades and
1235     // pointer aliasing, and it cannot be disabled.
1236 
1237     // The values being non-zero value makes deployment a bit more expensive,
1238     // but in exchange the refund on every call to nonReentrant will be lower in
1239     // amount. Since refunds are capped to a percentage of the total
1240     // transaction's gas, it is best to keep them low in cases like this one, to
1241     // increase the likelihood of the full refund coming into effect.
1242     uint256 private constant _NOT_ENTERED = 1;
1243     uint256 private constant _ENTERED = 2;
1244 
1245     uint256 private _status;
1246 
1247     constructor() {
1248         _status = _NOT_ENTERED;
1249     }
1250 
1251     /**
1252      * @dev Prevents a contract from calling itself, directly or indirectly.
1253      * Calling a `nonReentrant` function from another `nonReentrant`
1254      * function is not supported. It is possible to prevent this from happening
1255      * by making the `nonReentrant` function external, and make it call a
1256      * `private` function that does the actual work.
1257      */
1258     modifier nonReentrant() {
1259         // On the first call to nonReentrant, _notEntered will be true
1260         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1261 
1262         // Any calls to nonReentrant after this point will fail
1263         _status = _ENTERED;
1264 
1265         _;
1266 
1267         // By storing the original value once again, a refund is triggered (see
1268         // https://eips.ethereum.org/EIPS/eip-2200)
1269         _status = _NOT_ENTERED;
1270     }
1271 }
1272 
1273 /**
1274  * @dev Contract module which provides a basic access control mechanism, where
1275  * there is an account (an owner) that can be granted exclusive access to
1276  * specific functions.
1277  *
1278  * By default, the owner account will be the one that deploys the contract. This
1279  * can later be changed with {transferOwnership}.
1280  *
1281  * This module is used through inheritance. It will make available the modifier
1282  * `onlyOwner`, which can be applied to your functions to restrict their use to
1283  * the owner.
1284  */
1285 abstract contract Ownable {
1286     address private _owner;
1287 
1288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1289 
1290     /**
1291      * @dev Initializes the contract setting the deployer as the initial owner.
1292      */
1293     constructor() {
1294         _setOwner(msg.sender);
1295     }
1296 
1297     /**
1298      * @dev Returns the address of the current owner.
1299      */
1300     function owner() public view virtual returns (address) {
1301         return _owner;
1302     }
1303 
1304     /**
1305      * @dev Throws if called by any account other than the owner.
1306      */
1307     modifier onlyOwner() {
1308         require(owner() == msg.sender, "Ownable: caller is not the owner");
1309         _;
1310     }
1311 
1312     /**
1313      * @dev Leaves the contract without owner. It will not be possible to call
1314      * `onlyOwner` functions anymore. Can only be called by the current owner.
1315      *
1316      * NOTE: Renouncing ownership will leave the contract without an owner,
1317      * thereby removing any functionality that is only available to the owner.
1318      */
1319     function renounceOwnership() public virtual onlyOwner {
1320         _setOwner(address(0));
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Can only be called by the current owner.
1326      */
1327     function transferOwnership(address newOwner) public virtual onlyOwner {
1328         require(newOwner != address(0), "Ownable: new owner is the zero address");
1329         _setOwner(newOwner);
1330     }
1331 
1332     function _setOwner(address newOwner) private {
1333         address oldOwner = _owner;
1334         _owner = newOwner;
1335         emit OwnershipTransferred(oldOwner, newOwner);
1336     }
1337 }
1338 
1339 contract NFTXMarketplaceZap is Ownable, ReentrancyGuard, ERC721HolderUpgradeable, ERC1155HolderUpgradeable {
1340   IWETH public immutable WETH; 
1341   INFTXLPStaking public immutable lpStaking;
1342   INFTXVaultFactory public immutable nftxFactory;
1343   IUniswapV2Router01 public immutable sushiRouter;
1344 
1345   uint256 constant BASE = 10**18;
1346 
1347   constructor(address _nftxFactory, address _sushiRouter) Ownable() ReentrancyGuard() {
1348     nftxFactory = INFTXVaultFactory(_nftxFactory);
1349     lpStaking = INFTXLPStaking(INFTXFeeDistributor(INFTXVaultFactory(_nftxFactory).feeDistributor()).lpStaking());
1350     sushiRouter = IUniswapV2Router01(_sushiRouter);
1351     WETH = IWETH(IUniswapV2Router01(_sushiRouter).WETH());
1352     IERC20Upgradeable(address(IUniswapV2Router01(_sushiRouter).WETH())).approve(_sushiRouter, type(uint256).max);
1353   }
1354 
1355   function mintAndSell721(
1356     uint256 vaultId, 
1357     uint256[] memory ids, 
1358     uint256 minWethOut, 
1359     address[] calldata path,
1360     address to
1361   ) public nonReentrant {
1362     require(to != address(0));
1363     require(ids.length != 0);
1364     (address vault, uint256 vaultBalance) = _mint721(vaultId, ids);
1365     uint256[] memory amounts = _sellVaultToken(vault, minWethOut, vaultBalance, path);
1366 
1367     // Return extras.
1368     uint256 remaining = WETH.balanceOf(address(this));
1369     WETH.withdraw(remaining);
1370     (bool success, ) = payable(to).call{value: remaining}("");
1371     require(success, "Address: unable to send value, recipient may have reverted");
1372   }
1373 
1374   function mintAndSell721WETH(
1375     uint256 vaultId, 
1376     uint256[] memory ids, 
1377     uint256 minWethOut, 
1378     address[] calldata path,
1379     address to
1380   ) public nonReentrant {
1381     require(to != address(0));
1382     require(ids.length != 0);
1383     (address vault, uint256 vaultBalance) = _mint721(vaultId, ids);
1384     uint256[] memory amounts = _sellVaultToken(vault, minWethOut, vaultBalance, path);
1385     uint256 remaining = WETH.balanceOf(address(this));
1386     WETH.transfer(to, remaining);
1387   }
1388 
1389   // function buyAndSwap721(
1390   //   uint256 vaultId, 
1391   //   uint256[] memory idsIn, 
1392   //   uint256[] memory specificIds, 
1393   //   address[] calldata path,
1394   //   address to
1395   // ) public payable nonReentrant {
1396   //   require(to != address(0));
1397   //   require(idsIn.length != 0);
1398   //   WETH.deposit{value: msg.value}();
1399   //   INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1400   //   uint256 mintFees = vault.mintFee() * idsIn.length;
1401   //   uint256 redeemFees = (vault.targetRedeemFee() * specificIds.length) + (
1402   //       vault.randomRedeemFee() * (idsIn.length - specificIds.length)
1403   //   );
1404   //   uint256[] memory amounts = _buyVaultToken(address(vault), mintFees + redeemFees, msg.value, path);
1405   //   _swap721(vaultId, idsIn, specificIds, to);
1406 
1407   //   // Return extras.
1408   //   uint256 remaining = WETH.balanceOf(address(this));
1409   //   WETH.withdraw(remaining);
1410   //   (bool success, ) = payable(to).call{value: remaining}("");
1411   //   require(success, "Address: unable to send value, recipient may have reverted");
1412   // }
1413 
1414   // function buyAndSwap721WETH(
1415   //   uint256 vaultId, 
1416   //   uint256[] memory idsIn, 
1417   //   uint256[] memory specificIds, 
1418   //   uint256 maxWethIn, 
1419   //   address[] calldata path,
1420   //   address to
1421   // ) public nonReentrant {
1422   //   require(to != address(0));
1423   //   require(idsIn.length != 0);
1424   //   IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), maxWethIn);
1425   //   INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1426   //   uint256 mintFees = vault.mintFee() * idsIn.length;
1427   //   uint256 redeemFees = (vault.targetRedeemFee() * specificIds.length) + (
1428   //       vault.randomRedeemFee() * (idsIn.length - specificIds.length)
1429   //   );
1430   //   uint256[] memory amounts = _buyVaultToken(address(vault), mintFees + redeemFees, maxWethIn, path);
1431   //   _swap721(vaultId, idsIn, specificIds, to);
1432 
1433   //   // Return extras.
1434   //   uint256 remaining = WETH.balanceOf(address(this));
1435   //   WETH.transfer(to, remaining);
1436   // }
1437 
1438   // function buyAndSwap1155(
1439   //   uint256 vaultId, 
1440   //   uint256[] memory idsIn, 
1441   //   uint256[] memory amounts, 
1442   //   uint256[] memory specificIds, 
1443   //   address[] calldata path,
1444   //   address to
1445   // ) public payable nonReentrant {
1446   //   require(to != address(0));
1447   //   require(idsIn.length != 0);
1448   //   WETH.deposit{value: msg.value}();
1449   //   uint256 count;
1450   //   for (uint256 i = 0; i < idsIn.length; i++) {
1451   //       uint256 amount = amounts[i];
1452   //       require(amount > 0, "Transferring < 1");
1453   //       count += amount;
1454   //   }
1455   //   INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1456   //   uint256 mintFees = vault.mintFee() * count;
1457   //   uint256 redeemFees = (vault.targetRedeemFee() * specificIds.length) + (
1458   //       vault.randomRedeemFee() * (count - specificIds.length)
1459   //   );
1460   //   uint256[] memory amounts = _buyVaultToken(address(vault), mintFees + redeemFees, msg.value, path);
1461   //   _swap1155(vaultId, idsIn, amounts, specificIds, to);
1462 
1463   //   // Return extras.
1464   //   uint256 remaining = WETH.balanceOf(address(this));
1465   //   WETH.withdraw(remaining);
1466   //   (bool success, ) = payable(to).call{value: remaining}("");
1467   //   require(success, "Address: unable to send value, recipient may have reverted");
1468   // }
1469 
1470   // function buyAndSwap1155WETH(
1471   //   uint256 vaultId, 
1472   //   uint256[] memory idsIn, 
1473   //   uint256[] memory amounts, 
1474   //   uint256[] memory specificIds, 
1475   //   uint256 maxWethIn, 
1476   //   address[] calldata path,
1477   //   address to
1478   // ) public payable nonReentrant {
1479   //   require(to != address(0));
1480   //   require(idsIn.length != 0);
1481   //   IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), maxWethIn);
1482   //   uint256 count;
1483   //   for (uint256 i = 0; i < idsIn.length; i++) {
1484   //       uint256 amount = amounts[i];
1485   //       require(amount > 0, "Transferring < 1");
1486   //       count += amount;
1487   //   }
1488   //   INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1489   //   uint256 mintFees = vault.mintFee() * count;
1490   //   uint256 redeemFees = (vault.targetRedeemFee() * specificIds.length) + (
1491   //       vault.randomRedeemFee() * (count - specificIds.length)
1492   //   );
1493   //   uint256[] memory amounts = _buyVaultToken(address(vault), mintFees + redeemFees, msg.value, path);
1494   //   _swap1155(vaultId, idsIn, amounts, specificIds, to);
1495 
1496   //   // Return extras.
1497   //   uint256 remaining = WETH.balanceOf(address(this));
1498   //   WETH.transfer(to, remaining);
1499   // }
1500 
1501   function buyAndRedeem(
1502     uint256 vaultId, 
1503     uint256 amount,
1504     uint256[] memory specificIds, 
1505     address[] calldata path,
1506     address to
1507   ) public payable nonReentrant {
1508     require(to != address(0));
1509     require(amount != 0);
1510     WETH.deposit{value: msg.value}();
1511     INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1512     uint256 totalFee = (vault.targetRedeemFee() * specificIds.length) + (
1513         vault.randomRedeemFee() * (amount - specificIds.length)
1514     );
1515     uint256[] memory amounts = _buyVaultToken(address(vault), (amount*BASE)+totalFee, msg.value, path);
1516     _redeem(vaultId, amount, specificIds, to);
1517 
1518     uint256 remaining = WETH.balanceOf(address(this));
1519     WETH.withdraw(remaining);
1520     (bool success, ) = payable(to).call{value: remaining}("");
1521     require(success, "Address: unable to send value, recipient may have reverted");
1522   }
1523 
1524   function buyAndRedeemWETH(
1525     uint256 vaultId, 
1526     uint256 amount,
1527     uint256[] memory specificIds, 
1528     uint256 maxWethIn, 
1529     address[] calldata path,
1530     address to
1531   ) public nonReentrant {
1532     require(to != address(0));
1533     require(amount != 0);
1534     IERC20Upgradeable(address(WETH)).transferFrom(msg.sender, address(this), maxWethIn);
1535     INFTXVault vault = INFTXVault(nftxFactory.vault(vaultId));
1536     uint256 totalFee = (vault.targetRedeemFee() * specificIds.length) + (
1537         vault.randomRedeemFee() * (amount - specificIds.length)
1538     );
1539     uint256[] memory amounts = _buyVaultToken(address(vault), (amount*BASE) + totalFee, maxWethIn, path);
1540     _redeem(vaultId, amount, specificIds, to);
1541 
1542     uint256 remaining = WETH.balanceOf(address(this));
1543     WETH.transfer(to, remaining);
1544   }
1545 
1546   function mintAndSell1155(
1547     uint256 vaultId, 
1548     uint256[] memory ids, 
1549     uint256[] memory amounts,
1550     uint256 minWethOut, 
1551     address[] calldata path,
1552     address to
1553   ) public nonReentrant {
1554     require(to != address(0));
1555     require(ids.length != 0);
1556     (address vault, uint256 vaultTokenBalance) = _mint1155(vaultId, ids, amounts);
1557     uint256[] memory amounts = _sellVaultToken(vault, minWethOut, vaultTokenBalance, path);
1558 
1559     // Return extras.
1560     uint256 remaining = WETH.balanceOf(address(this));
1561     WETH.withdraw(remaining);
1562     (bool success, ) = payable(to).call{value: remaining}("");
1563     require(success, "Address: unable to send value, recipient may have reverted");
1564   }
1565 
1566   function mintAndSell1155WETH(
1567     uint256 vaultId, 
1568     uint256[] memory ids, 
1569     uint256[] memory amounts,
1570     uint256 minWethOut, 
1571     address[] calldata path,
1572     address to
1573   ) public nonReentrant {
1574     require(to != address(0));
1575     require(ids.length != 0);
1576     (address vault, uint256 vaultTokenBalance) = _mint1155(vaultId, ids, amounts);
1577     uint256[] memory amounts = _sellVaultToken(vault, minWethOut, vaultTokenBalance, path);
1578     uint256 remaining = WETH.balanceOf(address(this));
1579     WETH.transfer(to, remaining);
1580   }
1581 
1582   function _mint721(
1583     uint256 vaultId, 
1584     uint256[] memory ids
1585   ) internal returns (address, uint256) {
1586     address vault = nftxFactory.vault(vaultId);
1587     require(vault != address(0), "NFTXZap: Vault does not exist");
1588 
1589     // Transfer tokens to zap and mint to NFTX.
1590     address assetAddress = INFTXVault(vault).assetAddress();
1591     for (uint256 i = 0; i < ids.length; i++) {
1592       transferFromERC721(assetAddress, ids[i]);
1593       approveERC721(assetAddress, vault, ids[i]);
1594     }
1595     uint256[] memory emptyIds;
1596     uint256 count = INFTXVault(vault).mint(ids, emptyIds);
1597     uint256 balance = (count * BASE) - (count * INFTXVault(vault).mintFee()); 
1598     require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");
1599     
1600     return (vault, balance);
1601   }
1602 
1603   function _swap721(
1604     uint256 vaultId, 
1605     uint256[] memory idsIn,
1606     uint256[] memory idsOut,
1607     address to
1608   ) internal returns (address) {
1609     address vault = nftxFactory.vault(vaultId);
1610     require(vault != address(0), "NFTXZap: Vault does not exist");
1611 
1612     // Transfer tokens to zap and mint to NFTX.
1613     address assetAddress = INFTXVault(vault).assetAddress();
1614     for (uint256 i = 0; i < idsIn.length; i++) {
1615       transferFromERC721(assetAddress, idsIn[i]);
1616       approveERC721(assetAddress, vault, idsIn[i]);
1617     }
1618     uint256[] memory emptyIds;
1619     INFTXVault(vault).swapTo(idsIn, emptyIds, idsOut, to);
1620     
1621     return (vault);
1622   }
1623 
1624   function _swap1155(
1625     uint256 vaultId, 
1626     uint256[] memory idsIn,
1627     uint256[] memory amounts,
1628     uint256[] memory idsOut,
1629     address to
1630   ) internal returns (address) {
1631     address vault = nftxFactory.vault(vaultId);
1632     require(vault != address(0), "NFTXZap: Vault does not exist");
1633 
1634     // Transfer tokens to zap and mint to NFTX.
1635     address assetAddress = INFTXVault(vault).assetAddress();
1636     IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), idsIn, amounts, "");
1637     IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
1638     INFTXVault(vault).swapTo(idsIn, amounts, idsOut, to);
1639     
1640     return (vault);
1641   }
1642 
1643   function _redeem(
1644     uint256 vaultId, 
1645     uint256 amount,
1646     uint256[] memory specificIds,
1647     address to
1648   ) internal {
1649     address vault = nftxFactory.vault(vaultId);
1650     require(vault != address(0), "NFTXZap: Vault does not exist");
1651     INFTXVault(vault).redeemTo(amount, specificIds, to);
1652   }
1653 
1654   function _mint1155(
1655     uint256 vaultId, 
1656     uint256[] memory ids,
1657     uint256[] memory amounts
1658   ) internal returns (address, uint256) {
1659     address vault = nftxFactory.vault(vaultId);
1660     require(vault != address(0), "NFTXZap: Vault does not exist");
1661 
1662     // Transfer tokens to zap and mint to NFTX.
1663     address assetAddress = INFTXVault(vault).assetAddress();
1664     IERC1155Upgradeable(assetAddress).safeBatchTransferFrom(msg.sender, address(this), ids, amounts, "");
1665     IERC1155Upgradeable(assetAddress).setApprovalForAll(vault, true);
1666     uint256 count = INFTXVault(vault).mint(ids, amounts);
1667     uint256 balance = (count * BASE) - INFTXVault(vault).mintFee()*count;
1668     require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");
1669     
1670     return (vault, balance);
1671   }
1672 
1673   function _buyVaultToken(
1674     address vault, 
1675     uint256 minTokenOut, 
1676     uint256 maxWethIn, 
1677     address[] calldata path
1678   ) internal returns (uint256[] memory) {
1679     uint256[] memory amounts = sushiRouter.swapTokensForExactTokens(
1680       minTokenOut,
1681       maxWethIn,
1682       path, 
1683       address(this),
1684       block.timestamp
1685     );
1686 
1687     return amounts;
1688   }
1689 
1690   function _sellVaultToken(
1691     address vault, 
1692     uint256 minWethOut, 
1693     uint256 maxTokenIn, 
1694     address[] calldata path
1695   ) internal returns (uint256[] memory) {
1696     IERC20Upgradeable(vault).approve(address(sushiRouter), maxTokenIn);
1697     uint256[] memory amounts = sushiRouter.swapExactTokensForTokens(
1698       maxTokenIn,
1699       minWethOut,
1700       path, 
1701       address(this),
1702       block.timestamp
1703     );
1704 
1705     return amounts;
1706   }
1707 
1708   function transferFromERC721(address assetAddr, uint256 tokenId) internal virtual {
1709     address kitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
1710     address punks = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
1711     bytes memory data;
1712     if (assetAddr == kitties) {
1713         // Cryptokitties.
1714         data = abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), tokenId);
1715     } else if (assetAddr == punks) {
1716         // CryptoPunks.
1717         // Fix here for frontrun attack. Added in v1.0.2.
1718         bytes memory punkIndexToAddress = abi.encodeWithSignature("punkIndexToAddress(uint256)", tokenId);
1719         (bool checkSuccess, bytes memory result) = address(assetAddr).staticcall(punkIndexToAddress);
1720         (address owner) = abi.decode(result, (address));
1721         require(checkSuccess && owner == msg.sender, "Not the owner");
1722         data = abi.encodeWithSignature("buyPunk(uint256)", tokenId);
1723     } else {
1724         // Default.
1725         data = abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", msg.sender, address(this), tokenId);
1726     }
1727     (bool success, bytes memory resultData) = address(assetAddr).call(data);
1728     require(success, string(resultData));
1729   }
1730 
1731   function approveERC721(address assetAddr, address to, uint256 tokenId) internal virtual {
1732     address kitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
1733     address punks = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
1734     bytes memory data;
1735     if (assetAddr == kitties) {
1736         // Cryptokitties.
1737         data = abi.encodeWithSignature("approve(address,uint256)", to, tokenId);
1738     } else if (assetAddr == punks) {
1739         // CryptoPunks.
1740         data = abi.encodeWithSignature("offerPunkForSaleToAddress(uint256,uint256,address)", tokenId, 0, to);
1741     } else {
1742         if (IERC721(assetAddr).isApprovedForAll(address(this), to)) {
1743           return;
1744         }
1745         // Default.
1746         data = abi.encodeWithSignature("setApprovalForAll(address,bool)", to, true);
1747     }
1748     (bool success, bytes memory resultData) = address(assetAddr).call(data);
1749     require(success, string(resultData));
1750   }
1751 
1752   // calculates the CREATE2 address for a pair without making any external calls
1753   function pairFor(address tokenA, address tokenB) internal view returns (address pair) {
1754     (address token0, address token1) = sortTokens(tokenA, tokenB);
1755     pair = address(uint160(uint256(keccak256(abi.encodePacked(
1756       hex'ff',
1757       sushiRouter.factory(),
1758       keccak256(abi.encodePacked(token0, token1)),
1759       hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
1760     )))));
1761   }
1762 
1763   // returns sorted token addresses, used to handle return values from pairs sorted in this order
1764   function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1765       require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1766       (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1767       require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1768   }
1769 
1770   receive() external payable {
1771 
1772   }
1773 }