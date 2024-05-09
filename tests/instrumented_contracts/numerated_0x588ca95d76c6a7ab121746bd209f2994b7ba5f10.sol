1 /*
2  * Crypto stamp 2 On-Chain Shop
3  * Ability to purchase pseudo-random digital-physical collectible postage stamps
4  * and to redeem Crypto stamp 2 pre-sale vouchers in a similar manner
5  *
6  * Developed by Capacity Blockchain Solutions GmbH <capacity.at>
7  * for Österreichische Post AG <post.at>
8  */
9 
10 
11 // File: @openzeppelin/contracts/math/SafeMath.sol
12 
13 pragma solidity ^0.6.0;
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations with added overflow
17  * checks.
18  *
19  * Arithmetic operations in Solidity wrap on overflow. This can easily result
20  * in bugs, because programmers usually assume that an overflow raises an
21  * error, which is the standard behavior in high level programming languages.
22  * `SafeMath` restores this intuition by reverting the transaction when an
23  * operation overflows.
24  *
25  * Using this library instead of the unchecked operations eliminates an entire
26  * class of bugs, so it's recommended to use it always.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, reverting on
31      * overflow.
32      *
33      * Counterpart to Solidity's `+` operator.
34      *
35      * Requirements:
36      * - Addition cannot overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, reverting on
47      * overflow (when the result is negative).
48      *
49      * Counterpart to Solidity's `-` operator.
50      *
51      * Requirements:
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         // Solidity only automatically asserts when dividing by 0
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/introspection/IERC165.sol
165 
166 pragma solidity ^0.6.0;
167 
168 /**
169  * @dev Interface of the ERC165 standard, as defined in the
170  * https://eips.ethereum.org/EIPS/eip-165[EIP].
171  *
172  * Implementers can declare support of contract interfaces, which can then be
173  * queried by others ({ERC165Checker}).
174  *
175  * For an implementation, see {ERC165}.
176  */
177 interface IERC165 {
178     /**
179      * @dev Returns true if this contract implements the interface defined by
180      * `interfaceId`. See the corresponding
181      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
182      * to learn more about how these ids are created.
183      *
184      * This function call must use less than 30 000 gas.
185      */
186     function supportsInterface(bytes4 interfaceId) external view returns (bool);
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
190 
191 pragma solidity ^0.6.2;
192 
193 
194 /**
195  * @dev Required interface of an ERC721 compliant contract.
196  */
197 interface IERC721 is IERC165 {
198     /**
199      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
202 
203     /**
204      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
205      */
206     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
207 
208     /**
209      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
210      */
211     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
212 
213     /**
214      * @dev Returns the number of tokens in ``owner``'s account.
215      */
216     function balanceOf(address owner) external view returns (uint256 balance);
217 
218     /**
219      * @dev Returns the owner of the `tokenId` token.
220      *
221      * Requirements:
222      *
223      * - `tokenId` must exist.
224      */
225     function ownerOf(uint256 tokenId) external view returns (address owner);
226 
227     /**
228      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
229      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
230      *
231      * Requirements:
232      *
233      * - `from`, `to` cannot be zero.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
236      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
237      *
238      * Emits a {Transfer} event.
239      */
240     function safeTransferFrom(address from, address to, uint256 tokenId) external;
241 
242     /**
243      * @dev Transfers `tokenId` token from `from` to `to`.
244      *
245      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
246      *
247      * Requirements:
248      *
249      * - `from`, `to` cannot be zero.
250      * - `tokenId` token must be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(address from, address to, uint256 tokenId) external;
256 
257     /**
258      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
259      * The approval is cleared when the token is transferred.
260      *
261      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
262      *
263      * Requirements:
264      *
265      * - The caller must own the token or be an approved operator.
266      * - `tokenId` must exist.
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address to, uint256 tokenId) external;
271 
272     /**
273      * @dev Returns the account approved for `tokenId` token.
274      *
275      * Requirements:
276      *
277      * - `tokenId` must exist.
278      */
279     function getApproved(uint256 tokenId) external view returns (address operator);
280 
281     /**
282      * @dev Approve or remove `operator` as an operator for the caller.
283      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
284      *
285      * Requirements:
286      *
287      * - The `operator` cannot be the caller.
288      *
289      * Emits an {ApprovalForAll} event.
290      */
291     function setApprovalForAll(address operator, bool _approved) external;
292 
293     /**
294      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
295      *
296      * See {setApprovalForAll}
297      */
298     function isApprovedForAll(address owner, address operator) external view returns (bool);
299 
300     /**
301       * @dev Safely transfers `tokenId` token from `from` to `to`.
302       *
303       * Requirements:
304       *
305       * - `from`, `to` cannot be zero.
306       * - `tokenId` token must exist and be owned by `from`.
307       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
308       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
309       *
310       * Emits a {Transfer} event.
311       */
312     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
316 
317 pragma solidity ^0.6.0;
318 
319 /**
320  * @dev Interface of the ERC20 standard as defined in the EIP.
321  */
322 interface IERC20 {
323     /**
324      * @dev Returns the amount of tokens in existence.
325      */
326     function totalSupply() external view returns (uint256);
327 
328     /**
329      * @dev Returns the amount of tokens owned by `account`.
330      */
331     function balanceOf(address account) external view returns (uint256);
332 
333     /**
334      * @dev Moves `amount` tokens from the caller's account to `recipient`.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a {Transfer} event.
339      */
340     function transfer(address recipient, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Returns the remaining number of tokens that `spender` will be
344      * allowed to spend on behalf of `owner` through {transferFrom}. This is
345      * zero by default.
346      *
347      * This value changes when {approve} or {transferFrom} are called.
348      */
349     function allowance(address owner, address spender) external view returns (uint256);
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * IMPORTANT: Beware that changing an allowance with this method brings the risk
357      * that someone may use both the old and the new allowance by unfortunate
358      * transaction ordering. One possible solution to mitigate this race
359      * condition is to first reduce the spender's allowance to 0 and set the
360      * desired value afterwards:
361      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362      *
363      * Emits an {Approval} event.
364      */
365     function approve(address spender, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Moves `amount` tokens from `sender` to `recipient` using the
369      * allowance mechanism. `amount` is then deducted from the caller's
370      * allowance.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Emitted when `value` tokens are moved from one account (`from`) to
380      * another (`to`).
381      *
382      * Note that `value` may be zero.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 value);
385 
386     /**
387      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
388      * a call to {approve}. `value` is the new allowance.
389      */
390     event Approval(address indexed owner, address indexed spender, uint256 value);
391 }
392 
393 // File: contracts/ENSReverseRegistrarI.sol
394 
395 /*
396  * Interfaces for ENS Reverse Registrar
397  * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl
398  * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol
399  *
400  * Use this as follows (registryAddress is the address of the ENS registry to use):
401  * -----
402  * // This hex value is caclulated by namehash('addr.reverse')
403  * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
404  * function registerReverseENS(address registryAddress, string memory calldata) external {
405  *     require(registryAddress != address(0), "need a valid registry");
406  *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)
407  *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
408  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
409  * }
410  * -----
411  * or
412  * -----
413  * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {
414  *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
415  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
416  * }
417  * -----
418  * ENS deployments can be found at https://docs.ens.domains/ens-deployments
419  * E.g. Etherscan can be used to look up that owner on those contracts.
420  * namehash.hash("addr.reverse") == "0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2"
421  * Ropsten: ens.owner(namehash.hash("addr.reverse")) == "0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c"
422  * Mainnet: ens.owner(namehash.hash("addr.reverse")) == "0x084b1c3C81545d370f3634392De611CaaBFf8148"
423  */
424 pragma solidity ^0.6.0;
425 
426 interface ENSRegistryOwnerI {
427     function owner(bytes32 node) external view returns (address);
428 }
429 
430 interface ENSReverseRegistrarI {
431     function setName(string calldata name) external returns (bytes32 node);
432 }
433 
434 // File: contracts/OracleRequest.sol
435 
436 /*
437 Interface for requests to the rate oracle (for EUR/ETH)
438 Copy this to projects that need to access the oracle.
439 See rate-oracle project for implementation.
440 */
441 pragma solidity ^0.6.0;
442 
443 
444 abstract contract OracleRequest {
445 
446     uint256 public EUR_WEI; //number of wei per EUR
447 
448     uint256 public lastUpdate; //timestamp of when the last update occurred
449 
450     function ETH_EUR() public view virtual returns (uint256); //number of EUR per ETH (rounded down!)
451 
452     function ETH_EURCENT() public view virtual returns (uint256); //number of EUR cent per ETH (rounded down!)
453 
454 }
455 
456 // File: contracts/CS2PropertiesI.sol
457 
458 /*
459 Interface for CS2 properties.
460 */
461 pragma solidity ^0.6.0;
462 
463 interface CS2PropertiesI {
464 
465     enum AssetType {
466         Honeybadger,
467         Llama,
468         Panda,
469         Doge
470     }
471 
472     enum Colors {
473         Black,
474         Green,
475         Blue,
476         Yellow,
477         Red
478     }
479 
480     function getType(uint256 tokenId) external view returns (AssetType);
481     function getColor(uint256 tokenId) external view returns (Colors);
482 
483 }
484 
485 // File: contracts/OZ_ERC1155/IERC1155.sol
486 
487 pragma solidity ^0.6.0;
488 
489 
490 /**
491     @title ERC-1155 Multi Token Standard basic interface
492     @dev See https://eips.ethereum.org/EIPS/eip-1155
493  */
494 abstract contract IERC1155 is IERC165 {
495     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
496 
497     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
498 
499     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
500 
501     event URI(string value, uint256 indexed id);
502 
503     function balanceOf(address account, uint256 id) public view virtual returns (uint256);
504 
505     function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view virtual returns (uint256[] memory);
506 
507     function setApprovalForAll(address operator, bool approved) external virtual;
508 
509     function isApprovedForAll(address account, address operator) external view virtual returns (bool);
510 
511     function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external virtual;
512 
513     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata values, bytes calldata data) external virtual;
514 }
515 
516 // File: contracts/CS2PresaleRedeemI.sol
517 
518 /*
519 Interface for CS2 on-chain presale for usage with redeemer (OCS) contract.
520 */
521 pragma solidity ^0.6.0;
522 
523 
524 abstract contract CS2PresaleRedeemI is IERC1155 {
525     enum AssetType {
526         Honeybadger,
527         Llama,
528         Panda,
529         Doge
530     }
531 
532     // Redeem assets of a multiple types/animals at once.
533     // This burns them in this contract, but should be called by a contract that assigns/creates the final assets in turn.
534     function redeemBatch(address owner, AssetType[] calldata _type, uint256[] calldata _count) external virtual;
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
538 
539 pragma solidity ^0.6.2;
540 
541 
542 /**
543  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
544  * @dev See https://eips.ethereum.org/EIPS/eip-721
545  */
546 interface IERC721Enumerable is IERC721 {
547 
548     /**
549      * @dev Returns the total amount of tokens stored by the contract.
550      */
551     function totalSupply() external view returns (uint256);
552 
553     /**
554      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
555      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
556      */
557     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
558 
559     /**
560      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
561      * Use along with {totalSupply} to enumerate all tokens.
562      */
563     function tokenByIndex(uint256 index) external view returns (uint256);
564 }
565 
566 // File: contracts/ERC721ExistsI.sol
567 
568 pragma solidity ^0.6.0;
569 
570 
571 /**
572  * @dev ERC721 compliant contract with an exists() function.
573  */
574 abstract contract ERC721ExistsI is IERC721 {
575 
576     // Returns whether the specified token exists
577     function exists(uint256 tokenId) public view virtual returns (bool);
578 
579 }
580 
581 // File: contracts/CS2OCSBaseI.sol
582 
583 pragma solidity ^0.6.0;
584 
585 
586 
587 /**
588  * @dev ERC721 compliant contract with an exists() function.
589  */
590 abstract contract CS2OCSBaseI is ERC721ExistsI, IERC721Enumerable {
591 
592     // Issue a crypto stamp with a merkle proof.
593     function createWithProof(bytes32 tokenData, bytes32[] memory merkleProof) public virtual returns (uint256);
594 
595 }
596 
597 // File: contracts/CS2OnChainShop.sol
598 
599 /*
600 Implements an on-chain shop for Crypto stamp Edition 2
601 */
602 pragma solidity ^0.6.0;
603 
604 
605 
606 
607 
608 
609 
610 
611 
612 contract CS2OnChainShop {
613     using SafeMath for uint256;
614 
615     CS2OCSBaseI internal CS2;
616     CS2PresaleRedeemI internal CS2Presale;
617     OracleRequest internal oracle;
618 
619     address payable public beneficiary;
620     address public shippingControl;
621     address public tokenAssignmentControl;
622 
623     uint256 public basePriceEurCent;
624     uint256 public priceTargetTimestamp;
625     uint256[4] public lastSaleTimestamp; // Every AssetType has their own sale/price tracking.
626     uint256[4] public lastSalePriceEurCent;
627     uint256[4] public lastSlotPriceEurCent;
628     uint256 public slotSeconds = 600;
629     uint256 public increaseFactorMicro; // 2500 for 0.25% (0.0025 * 1M)
630 
631     struct SoldInfo {
632         address recipient;
633         uint256 blocknumber;
634         uint256 tokenId;
635         bool presale;
636         CS2PropertiesI.AssetType aType;
637     }
638 
639     SoldInfo[] public soldSequence;
640     uint256 public lastAssignedSequence;
641     uint256 public lastRetrievedSequence;
642 
643     address[8] public tokenPools; // Pools for every AssetType as well as "normal" OCS and presale.
644     uint256[8] public startIds;
645     uint256[8] public tokenPoolSize;
646     uint256[8] public unassignedInPool;
647     uint256[2500][8] public tokenIdPools; // Max 2500 IDs per pool.
648 
649     bool internal _isOpen = true;
650 
651     enum ShippingStatus{
652         Initial,
653         Sold,
654         ShippingSubmitted,
655         ShippingConfirmed
656     }
657 
658     mapping(uint256 => ShippingStatus) public deliveryStatus;
659 
660     event BasePriceChanged(uint256 previousBasePriceEurCent, uint256 newBasePriceEurCent);
661     event PriceTargetTimeChanged(uint256 previousPriceTargetTimestamp, uint256 newPriceTargetTimestamp);
662     event IncreaseFactorChanged(uint256 previousIncreaseFactorMicro, uint256 newIncreaseFactorMicro);
663     event OracleChanged(address indexed previousOracle, address indexed newOracle);
664     event BeneficiaryTransferred(address indexed previousBeneficiary, address indexed newBeneficiary);
665     event TokenAssignmentControlTransferred(address indexed previousTokenAssignmentControl, address indexed newTokenAssignmentControl);
666     event ShippingControlTransferred(address indexed previousShippingControl, address indexed newShippingControl);
667     event ShopOpened();
668     event ShopClosed();
669     event AssetSold(address indexed buyer, address recipient, bool indexed presale, CS2PropertiesI.AssetType indexed aType, uint256 sequenceNumber, uint256 priceWei);
670     event AssetAssigned(address indexed recipient, uint256 indexed tokenId, uint256 sequenceNumber);
671     event AssignedAssetRetrieved(uint256 indexed tokenId, address indexed recipient);
672     event ShippingSubmitted(address indexed owner, uint256[] tokenIds, string deliveryInfo);
673     event ShippingFailed(address indexed owner, uint256 indexed tokenId, string reason);
674     event ShippingConfirmed(address indexed owner, uint256 indexed tokenId);
675     // ERC721 event - never emitted in this contract but helpful for running our tests.
676     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
677     // ERC1155 event - never emitted in this contract but helpful for running our tests.
678     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
679 
680     constructor(OracleRequest _oracle,
681         address _CS2Address,
682         address _CS2PresaleAddress,
683         uint256 _basePriceEurCent,
684         uint256 _priceTargetTimestamp,
685         uint256 _increaseFactorMicro,
686         address payable _beneficiary,
687         address _shippingControl,
688         address _tokenAssignmentControl,
689         uint256 _tokenPoolSize,
690         address[] memory _tokenPools,
691         uint256[] memory _startIds)
692     public
693     {
694         oracle = _oracle;
695         require(address(oracle) != address(0x0), "You need to provide an actual Oracle contract.");
696         CS2 = CS2OCSBaseI(_CS2Address);
697         require(address(CS2) != address(0x0), "You need to provide an actual Cryptostamp 2 contract.");
698         CS2Presale = CS2PresaleRedeemI(_CS2PresaleAddress);
699         require(address(CS2Presale) != address(0x0), "You need to provide an actual Cryptostamp 2 Presale contract.");
700         beneficiary = _beneficiary;
701         require(address(beneficiary) != address(0x0), "You need to provide an actual beneficiary address.");
702         shippingControl = _shippingControl;
703         require(address(shippingControl) != address(0x0), "You need to provide an actual shippingControl address.");
704         tokenAssignmentControl = _tokenAssignmentControl;
705         require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");
706         basePriceEurCent = _basePriceEurCent;
707         require(basePriceEurCent > 0, "You need to provide a non-zero base price.");
708         priceTargetTimestamp = _priceTargetTimestamp;
709         require(priceTargetTimestamp > now, "You need to provide a price target time in the future.");
710         increaseFactorMicro = _increaseFactorMicro;
711         uint256 poolnum = tokenPools.length;
712         require(_tokenPools.length == poolnum, "Need correct amount of token pool addresses.");
713         require(_startIds.length == poolnum, "Need correct amount of token pool start IDs.");
714         for (uint256 i = 0; i < poolnum; i++) {
715             tokenPools[i] = _tokenPools[i];
716             startIds[i] = _startIds[i];
717             tokenPoolSize[i] = _tokenPoolSize;
718         }
719     }
720 
721     modifier onlyBeneficiary() {
722         require(msg.sender == beneficiary, "Only the current benefinicary can call this function.");
723         _;
724     }
725 
726     modifier onlyShippingControl() {
727         require(msg.sender == shippingControl, "shippingControl key required for this function.");
728         _;
729     }
730 
731     modifier onlyTokenAssignmentControl() {
732         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
733         _;
734     }
735 
736     modifier requireOpen() {
737         require(isOpen() == true, "This call only works when the shop is open.");
738         _;
739     }
740 
741     /*** Enable adjusting variables after deployment ***/
742 
743     function setBasePrice(uint256 _newBasePriceEurCent)
744     public
745     onlyBeneficiary
746     {
747         require(_newBasePriceEurCent > 0, "You need to provide a non-zero price.");
748         emit BasePriceChanged(basePriceEurCent, _newBasePriceEurCent);
749         basePriceEurCent = _newBasePriceEurCent;
750     }
751 
752     function setPriceTargetTime(uint256 _newPriceTargetTimestamp)
753     public
754     onlyBeneficiary
755     {
756         require(_newPriceTargetTimestamp > now, "You need to provide a price target time in the future.");
757         emit PriceTargetTimeChanged(priceTargetTimestamp, _newPriceTargetTimestamp);
758         priceTargetTimestamp = _newPriceTargetTimestamp;
759     }
760 
761     function setIncreaseFactor(uint256 _newIncreaseFactorMicro)
762     public
763     onlyBeneficiary
764     {
765         emit IncreaseFactorChanged(increaseFactorMicro, _newIncreaseFactorMicro);
766         increaseFactorMicro = _newIncreaseFactorMicro;
767     }
768 
769     function setOracle(OracleRequest _newOracle)
770     public
771     onlyBeneficiary
772     {
773         require(address(_newOracle) != address(0x0), "You need to provide an actual Oracle contract.");
774         emit OracleChanged(address(oracle), address(_newOracle));
775         oracle = _newOracle;
776     }
777 
778     function transferBeneficiary(address payable _newBeneficiary)
779     public
780     onlyBeneficiary
781     {
782         require(_newBeneficiary != address(0), "beneficiary cannot be the zero address.");
783         emit BeneficiaryTransferred(beneficiary, _newBeneficiary);
784         beneficiary = _newBeneficiary;
785     }
786 
787     function transferTokenAssignmentControl(address _newTokenAssignmentControl)
788     public
789     onlyTokenAssignmentControl
790     {
791         require(_newTokenAssignmentControl != address(0), "tokenAssignmentControl cannot be the zero address.");
792         emit TokenAssignmentControlTransferred(tokenAssignmentControl, _newTokenAssignmentControl);
793         tokenAssignmentControl = _newTokenAssignmentControl;
794     }
795 
796     function transferShippingControl(address _newShippingControl)
797     public
798     onlyShippingControl
799     {
800         require(_newShippingControl != address(0), "shippingControl cannot be the zero address.");
801         emit ShippingControlTransferred(shippingControl, _newShippingControl);
802         shippingControl = _newShippingControl;
803     }
804 
805     function openShop()
806     public
807     onlyBeneficiary
808     {
809         _isOpen = true;
810         emit ShopOpened();
811     }
812 
813     function closeShop()
814     public
815     onlyBeneficiary
816     {
817         _isOpen = false;
818         emit ShopClosed();
819     }
820 
821     /*** Actual on-chain shop functionality ***/
822 
823     // Return true if OCS is currently open for purchases.
824     // This can have additional conditions to just the variable, e.g. actually having items to sell.
825     function isOpen()
826     public view
827     returns (bool)
828     {
829         return _isOpen;
830     }
831 
832     // Calculate dynamic asset price in EUR cent.
833     function priceEurCent(CS2PropertiesI.AssetType _type)
834     public view
835     returns (uint256)
836     {
837         return priceEurCentDynamic(true, _type);
838     }
839 
840     // Calculate fully dynamic asset price in EUR cent, without any capping for a time period.
841     // If freezeSaleSlot is true, the price from the last sale stays frozen during its slot.
842     // If that parameter if false, any sale will increase the price, even within the slot (used internally).
843     function priceEurCentDynamic(bool freezeSaleSlot, CS2PropertiesI.AssetType _type)
844     public view
845     returns (uint256)
846     {
847         uint256 nowSlot = getTimeSlot(now);
848         uint256 typeNum = uint256(_type);
849         if (lastSaleTimestamp[typeNum] == 0 || nowSlot == 0) {
850             // The first stamp as well as any after the target time are sold for the base price.
851             return basePriceEurCent;
852         }
853         uint256 lastSaleSlot = getTimeSlot(lastSaleTimestamp[typeNum]);
854         if (freezeSaleSlot) {
855             // Keep price static within a time slot of slotSeconds (default 10 minutes).
856             if (nowSlot == lastSaleSlot) {
857                 return lastSlotPriceEurCent[typeNum];
858             }
859         }
860         // The price is increased by a fixed percentage compared to the last sale,
861         // and decreased linearly towards the target timestamp and the base price.
862         // NOTE that due to the precision in EUR cent, we never end up with fractal EUR cent values.
863         uint256 priceIncrease = lastSalePriceEurCent[typeNum] * increaseFactorMicro / 1_000_000;
864         // Decrease: current overpricing multiplied by how much of the time between last sale and target has already passed.
865         // NOTE: *current* overpricing needs to take the increase into account first (otherwise it's overpricing of last sale)
866         // NOTE: getTimeSlot already reports the number of slots remaining to the target.
867         uint256 priceDecrease = (lastSalePriceEurCent[typeNum] + priceIncrease - basePriceEurCent) * (lastSaleSlot - nowSlot) / lastSaleSlot;
868         return lastSalePriceEurCent[typeNum] + priceIncrease - priceDecrease;
869     }
870 
871     // Get number of time slot. Slot numbers decrease towards the target timestamp, 0 is anything after that target.
872     function getTimeSlot(uint256 _timestamp)
873     public view
874     returns (uint256)
875     {
876         if (_timestamp >= priceTargetTimestamp) {
877             return 0;
878         }
879         return (priceTargetTimestamp - _timestamp) / slotSeconds + 1;
880     }
881 
882     // Calculate current asset price in wei.
883     // Note: Price in EUR cent is available from basePriceEurCent().
884     function priceWei(CS2PropertiesI.AssetType _type)
885     public view
886     returns (uint256)
887     {
888         return priceEurCent(_type).mul(oracle.EUR_WEI()).div(100);
889     }
890 
891     // Get the index of the pool for presale or normal OCS assets of the given type.
892     function getPoolIndex(bool _isPresale, CS2PropertiesI.AssetType _type)
893     public pure
894     returns (uint256)
895     {
896         return (_isPresale ? 4 : 0) + uint256(_type);
897     }
898 
899     // Returns the amount of assets of that type still available for sale.
900     function availableForSale(bool _presale, CS2PropertiesI.AssetType _type)
901     public view
902     returns (uint256)
903     {
904         uint256 poolIndex = getPoolIndex(_presale, _type);
905         return tokenPoolSize[poolIndex].sub(unassignedInPool[poolIndex]);
906     }
907 
908     // Returns true if the asset of the given type is sold out.
909     function isSoldOut(bool _presale, CS2PropertiesI.AssetType _type)
910     public view
911     returns (bool)
912     {
913         return availableForSale(_presale, _type) == 0;
914     }
915 
916     // Buy assets of a single type/animal.
917     // The number of assets as well as the recipient are explicitly given.
918     // This will fail when the full amount cannot be provided or the payment is too little for that amount.
919     // The recipient does not need to match the buyer, so the assets can be sent elsewhere (e.g. into a collection).
920     // tokenData and merkleProofs are are collection of mint proofs to optimistically try for retrieving assigned assets.
921     function buy(CS2PropertiesI.AssetType _type, uint256 _amount, address payable _recipient, bytes32[] memory tokenData, bytes32[] memory merkleProofsAggregated)
922     public payable
923     requireOpen
924     {
925         if (tokenData.length > 0) {
926             mintAssetsWithAggregatedProofs(tokenData, merkleProofsAggregated);
927         }
928         bool isPresale = false;
929         require(_amount <= availableForSale(isPresale, _type), "Not enough assets available to buy that amount.");
930         uint256 curPriceWei = priceWei(_type);
931         uint256 payAmount = _amount.mul(curPriceWei);
932         require(msg.value >= payAmount, "You need to send enough currency to buy the specified amount.");
933         uint256 typeNum = uint256(_type);
934         if (lastSaleTimestamp[typeNum] == 0 || getTimeSlot(now) != getTimeSlot(lastSaleTimestamp[typeNum])) {
935             // This is only called when priceEurCent() actually returns something different than the last slot price.
936             lastSlotPriceEurCent[typeNum] = priceEurCent(_type);
937         }
938         // Transfer the actual payment amount to the beneficiary.
939         // NOTE: We know this is no contract that causes re-entrancy as we own it.
940         (bool sendSuccess, /*bytes memory data*/) = beneficiary.call{value: payAmount}("");
941         if (!sendSuccess) { revert("Error in sending payment!"); }
942         for (uint256 i = 0; i < _amount; i++) {
943             // Assign a sequence number and store block and owner for it.
944             soldSequence.push(SoldInfo(_recipient, block.number, 0, isPresale, _type));
945             emit AssetSold(msg.sender, _recipient, isPresale, _type, soldSequence.length, curPriceWei);
946             // Adjust lastSale parameters for every sale so per-sale increase is calculated correctly.
947             lastSalePriceEurCent[typeNum] = priceEurCentDynamic(false, _type);
948             lastSaleTimestamp[typeNum] = now;
949         }
950         uint256 poolIndex = getPoolIndex(isPresale, _type);
951         unassignedInPool[poolIndex] = unassignedInPool[poolIndex].add(_amount);
952         // Assign a max of one asset/token more than we purchased.
953         assignPurchasedAssets(_amount + 1);
954         // Try retrieving a max of one asset/token more than we purchased.
955         retrieveAssignedAssets(_amount + 1);
956         // Send back change money. Do this last as msg.sender could cause re-entrancy.
957         if (msg.value > payAmount) {
958             (bool returnSuccess, /*bytes memory data*/) = msg.sender.call{value: msg.value.sub(payAmount)}("");
959             if (!returnSuccess) { revert("Error in returning change!"); }
960         }
961     }
962 
963     // Redeem presale vouchers for assets of a single type/animal.
964     // The number of assets as well as the recipient are explicitly given.
965     // This will fail when the full amount cannot be provided or the buyer has too few vouchers.
966     // The recipient does not need to match the buyer, so the assets can be sent elsewhere (e.g. into a collection).
967     // tokenData and merkleProofs are are collection of mint proofs to optimistically try for retrieving assigned assets.
968     function redeemVoucher(CS2PropertiesI.AssetType _type, uint256 _amount, address payable _recipient, bytes32[] memory tokenData, bytes32[] memory merkleProofsAggregated)
969     public
970     requireOpen
971     {
972         if (tokenData.length > 0) {
973             mintAssetsWithAggregatedProofs(tokenData, merkleProofsAggregated);
974         }
975         bool isPresale = true;
976         require(_amount <= availableForSale(isPresale, _type), "Not enough assets available to buy that amount.");
977         uint256 typeNum = uint256(_type);
978         require(CS2Presale.balanceOf(msg.sender, typeNum) >= _amount, "You need to own enough presale vouchers to redeem the specified amount.");
979         // Redeem the vouchers.
980         CS2PresaleRedeemI.AssetType[] memory redeemTypes = new CS2PresaleRedeemI.AssetType[](1);
981         uint256[] memory redeemAmounts = new uint256[](1);
982         redeemTypes[0] = CS2PresaleRedeemI.AssetType(typeNum);
983         redeemAmounts[0] = _amount;
984         CS2Presale.redeemBatch(msg.sender, redeemTypes, redeemAmounts);
985         //CS2Presale.redeemBatch(msg.sender, [_type], [_amount]);
986         for (uint256 i = 0; i < _amount; i++) {
987             // Assign a sequence number and store block and owner for it.
988             soldSequence.push(SoldInfo(_recipient, block.number, 0, isPresale, _type));
989             emit AssetSold(msg.sender, _recipient, isPresale, _type, soldSequence.length, 0);
990         }
991         uint256 poolIndex = getPoolIndex(isPresale, _type);
992         unassignedInPool[poolIndex] = unassignedInPool[poolIndex].add(_amount);
993         // Assign a max of one asset/token more than we purchased.
994         assignPurchasedAssets(_amount + 1);
995         // Try retrieving a max of one asset/token more than we purchased.
996         retrieveAssignedAssets(_amount + 1);
997     }
998 
999     // Get total amount of not-yet-assigned assets
1000     function getUnassignedAssetCount()
1001     public view
1002     returns (uint256)
1003     {
1004         return soldSequence.length - lastAssignedSequence;
1005     }
1006 
1007     // Get total amount of not-yet-retrieved assets
1008     function getUnretrievedAssetCount()
1009     public view
1010     returns (uint256)
1011     {
1012         return soldSequence.length - lastRetrievedSequence;
1013     }
1014 
1015     // Get total amount of sold assets
1016     function getSoldCount()
1017     public view
1018     returns (uint256)
1019     {
1020         return soldSequence.length;
1021     }
1022 
1023     // Get the token ID for any sold asset with the given sequence number.
1024     // As we do not know the block hash of the current block in Solidity, this can be given from the outside.
1025     // NOTE that when you hand in a wrong block hash, you will get wrong results!
1026     function getSoldTokenId(uint256 _sequenceNumber, bytes32 _currentBlockHash)
1027     public view
1028     returns (uint256)
1029     {
1030         if (_sequenceNumber <= lastAssignedSequence) {
1031             // We can return the ID directly from the soldSequence.
1032             uint256 seqIdx = _sequenceNumber.sub(1);
1033             return soldSequence[seqIdx].tokenId;
1034         }
1035         // For unassigned assets, get pool and slot and then a token ID from that.
1036         uint256 poolIndex;
1037         uint256 slotIndex;
1038         if (_sequenceNumber == lastAssignedSequence.add(1)) {
1039             (poolIndex, slotIndex) = _getNextUnassignedPoolSlot(_currentBlockHash);
1040         }
1041         else {
1042             (poolIndex, slotIndex) = _getUnassignedPoolSlotDeep(_sequenceNumber, _currentBlockHash);
1043         }
1044         return _getTokenIdForPoolSlot(poolIndex, slotIndex);
1045     }
1046 
1047     // Get the actual token ID for a pool slot, including the dance of resolving "0" IDs.
1048     function _getTokenIdForPoolSlot(uint256 _poolIndex, uint256 _slotIndex)
1049     internal view
1050     returns (uint256)
1051     {
1052         uint256 tokenId = tokenIdPools[_poolIndex][_slotIndex];
1053         if (tokenId == 0) {
1054             // We know we don't have token ID 0 in the pool, so we'll calculate the actual ID.
1055             tokenId = startIds[_poolIndex].add(_slotIndex);
1056         }
1057         return tokenId;
1058     }
1059 
1060     // Get a slot index for the given sequence index (not sequence number!) and pool size.
1061     function _getSemiRandomSlotIndex(uint256 seqIdx, uint256 poolSize, bytes32 _currentBlockHash)
1062     internal view
1063     returns (uint256)
1064     {
1065         // Get block hash. As this only works for the last 256 blocks, fall back to the empty keccak256 hash to keep getting stable results.
1066         bytes32 bhash;
1067         if (soldSequence[seqIdx].blocknumber == block.number) {
1068           require(_currentBlockHash != bytes32(""), "For assets sold in the current block, provide a valid block hash.");
1069           bhash = _currentBlockHash;
1070         }
1071         else if (block.number < 256 || soldSequence[seqIdx].blocknumber >= block.number.sub(256)) {
1072           bhash = blockhash(soldSequence[seqIdx].blocknumber);
1073         }
1074         else {
1075           bhash = keccak256("");
1076         }
1077         return uint256(keccak256(abi.encodePacked(seqIdx, bhash))) % poolSize;
1078     }
1079 
1080     // Get the pool and slot indexes for the next asset to assign, which is a pretty straight-forward case.
1081     function _getNextUnassignedPoolSlot(bytes32 _currentBlockHash)
1082     internal view
1083     returns (uint256, uint256)
1084     {
1085         uint256 seqIdx = lastAssignedSequence; // last + 1 is next seqNo, seqIdx is seqNo - 1
1086         uint256 poolIndex = getPoolIndex(soldSequence[seqIdx].presale, soldSequence[seqIdx].aType);
1087         uint256 slotIndex = _getSemiRandomSlotIndex(seqIdx, tokenPoolSize[poolIndex], _currentBlockHash);
1088         return (poolIndex, slotIndex);
1089     }
1090 
1091     // Get the pool and slot indexes for any asset that is still to be assigned.
1092     // This case is rather complicated as it needs to calculate which assets would be removed in sequence before this one.
1093     function _getUnassignedPoolSlotDeep(uint256 _sequenceNumber, bytes32 _currentBlockHash)
1094     internal view
1095     returns (uint256, uint256)
1096     {
1097         require(_sequenceNumber > lastAssignedSequence, "The asset was assigned already.");
1098         require(_sequenceNumber <= soldSequence.length, "Exceeds maximum sequence number.");
1099         uint256 depth = _sequenceNumber.sub(lastAssignedSequence);
1100         uint256[] memory poolIndex = new uint256[](depth);
1101         uint256[] memory slotIndex = new uint256[](depth);
1102         uint256[] memory slotRedirect = new uint256[](depth);
1103         uint256[] memory poolSizeReduction = new uint256[](tokenPoolSize.length);
1104         for (uint256 i = 0; i < depth; i++) {
1105             uint256 seqIdx = lastAssignedSequence.add(i); // last + 1 is next seqNo, seqIdx is seqNo - 1, then we add i
1106             poolIndex[i] = getPoolIndex(soldSequence[seqIdx].presale, soldSequence[seqIdx].aType);
1107             uint256 calcPoolSize = tokenPoolSize[poolIndex[i]].sub(poolSizeReduction[poolIndex[i]]);
1108             slotIndex[i] = _getSemiRandomSlotIndex(seqIdx, calcPoolSize, _currentBlockHash);
1109             // Resolve all fitting redirects - this is an O(2) loop!
1110             for (uint256 fitloop = 0; fitloop < i; fitloop++) {
1111                 for (uint256 j = 0; j < i; j++) {
1112                     if (poolIndex[i] == poolIndex[j] && slotIndex[i] == slotIndex[j]) {
1113                         slotIndex[i] = slotRedirect[j];
1114                     }
1115                 }
1116             }
1117             // Instead of actually shuffling the array, do a redirect dance.
1118             slotRedirect[i] = calcPoolSize.sub(1);
1119             poolSizeReduction[poolIndex[i]] = poolSizeReduction[poolIndex[i]].add(1);
1120         }
1121         return (poolIndex[depth.sub(1)], slotIndex[depth.sub(1)]);
1122     }
1123 
1124     // Assign _maxCount asset (or less if less are unassigned)
1125     function assignPurchasedAssets(uint256 _maxCount)
1126     public
1127     {
1128         for (uint256 i = 0; i < _maxCount; i++) {
1129             if (lastAssignedSequence < soldSequence.length) {
1130                 _assignNextPurchasedAsset(false);
1131             }
1132         }
1133     }
1134 
1135     function assignNextPurchasedAssset()
1136     public
1137     {
1138         _assignNextPurchasedAsset(true);
1139     }
1140 
1141     function _assignNextPurchasedAsset(bool revertForSameBlock)
1142     internal
1143     {
1144         uint256 nextSequenceNumber = lastAssignedSequence.add(1);
1145         // Find the stamp to assign and transfer it.
1146         uint256 seqIdx = nextSequenceNumber.sub(1);
1147         if (soldSequence[seqIdx].blocknumber < block.number) {
1148             // Get tokenId in two steps as we need the slot index later.
1149             (uint256 poolIndex, uint256 slotIndex) = _getNextUnassignedPoolSlot(bytes32(""));
1150             uint256 tokenId = _getTokenIdForPoolSlot(poolIndex, slotIndex);
1151             soldSequence[seqIdx].tokenId = tokenId;
1152             emit AssetAssigned(soldSequence[seqIdx].recipient, tokenId, nextSequenceNumber);
1153             if (lastRetrievedSequence == lastAssignedSequence && CS2.exists(tokenId)) {
1154                 // If the asset exists and retrieval is caught up, do retrieval right away.
1155                 _retrieveAssignedAsset(seqIdx);
1156             }
1157             // Adjust the pool for the transferred asset.
1158             uint256 lastSlotIndex = tokenPoolSize[poolIndex].sub(1);
1159             if (slotIndex != lastSlotIndex) {
1160                 // If the removed index is not the last, move the last one to the removed slot.
1161                 uint256 lastValue = tokenIdPools[poolIndex][lastSlotIndex];
1162                 if (lastValue == 0) {
1163                     // In case we still have a 0 here, set the correct tokenId instead.
1164                     lastValue = startIds[poolIndex] + lastSlotIndex;
1165                 }
1166                 tokenIdPools[poolIndex][slotIndex] = lastValue;
1167             }
1168             tokenPoolSize[poolIndex] = tokenPoolSize[poolIndex].sub(1);
1169             unassignedInPool[poolIndex] = unassignedInPool[poolIndex].sub(1);
1170             // Set delivery status for newly sold asset, and update lastAssigned.
1171             deliveryStatus[tokenId] = ShippingStatus.Sold;
1172             lastAssignedSequence = nextSequenceNumber;
1173         }
1174         else {
1175             if (revertForSameBlock) {
1176                 revert("Cannot assign assets in the same block.");
1177             }
1178         }
1179     }
1180 
1181     // Retrieve multiple assets with mint proofs, if they match the next ones to retrieve.
1182     function mintAssetsWithAggregatedProofs(bytes32[] memory tokenData, bytes32[] memory merkleProofsAggregated)
1183     public
1184     {
1185         uint256 count = tokenData.length;
1186         require(count > 0, "Need actual data and proofs");
1187         require(merkleProofsAggregated.length % count == 0, "Count of data and proofs need to match");
1188         uint256 singleProofLength = merkleProofsAggregated.length / count;
1189         // Try to mint all given proofs.
1190         for (uint256 i = 0; i < count; i++) {
1191             uint256 tokenId = uint256(tokenData[i] >> 168); // shift by 20 bytes for address and 1 byte for properties
1192             if (!CS2.exists(tokenId)) {
1193                 bytes32[] memory merkleProof = new bytes32[](singleProofLength);
1194                 for (uint256 j = 0; j < singleProofLength; j++) {
1195                     merkleProof[j] = merkleProofsAggregated[singleProofLength.mul(i).add(j)];
1196                 }
1197                 CS2.createWithProof(tokenData[i], merkleProof);
1198             }
1199         }
1200     }
1201 
1202     function retrieveAssignedAssets(uint256 _maxCount)
1203     public
1204     {
1205         for (uint256 i = 0; i < _maxCount; i++) {
1206             if (lastRetrievedSequence < lastAssignedSequence) {
1207                 uint256 seqIdx = lastRetrievedSequence; // last + 1 is next seqNo, seqIdx is seqNo - 1
1208                 // Only retrieve an asset if the token actually exists.
1209                 if (CS2.exists(soldSequence[seqIdx].tokenId)) {
1210                     _retrieveAssignedAsset(seqIdx);
1211                 }
1212             }
1213         }
1214     }
1215 
1216     function _retrieveAssignedAsset(uint256 seqIdx)
1217     internal
1218     {
1219         uint256 poolIndex = getPoolIndex(soldSequence[seqIdx].presale, soldSequence[seqIdx].aType);
1220         require(CS2.ownerOf(soldSequence[seqIdx].tokenId) == tokenPools[poolIndex], "Already transferred out of the pool");
1221         // NOTE: We know CS2 is no contract that causes re-entrancy as it's our code.
1222         CS2.safeTransferFrom(tokenPools[poolIndex], soldSequence[seqIdx].recipient, soldSequence[seqIdx].tokenId);
1223         emit AssignedAssetRetrieved(soldSequence[seqIdx].tokenId, soldSequence[seqIdx].recipient);
1224         lastRetrievedSequence = seqIdx.add(1); // current SeqNo is SeqIdx + 1
1225     }
1226 
1227     /*** Handle physical shipping ***/
1228 
1229     // For token owner (after successful purchase): Request shipping.
1230     // _deliveryInfo is a postal address encrypted with a public key on the client side.
1231     function shipToMe(string memory _deliveryInfo, uint256[] memory _tokenIds)
1232     public
1233     requireOpen
1234     {
1235         uint256 count = _tokenIds.length;
1236         for (uint256 i = 0; i < count; i++) {
1237             require(CS2.ownerOf(_tokenIds[i]) == msg.sender, "You can only request shipping for your own tokens.");
1238             require(deliveryStatus[_tokenIds[i]] == ShippingStatus.Sold, "Shipping was already requested for one of these tokens or it was not sold by this shop.");
1239             deliveryStatus[_tokenIds[i]] = ShippingStatus.ShippingSubmitted;
1240         }
1241         emit ShippingSubmitted(msg.sender, _tokenIds, _deliveryInfo);
1242     }
1243 
1244     // For shipping service: Mark shipping as completed/confirmed.
1245     function confirmShipping(uint256[] memory _tokenIds)
1246     public
1247     onlyShippingControl
1248     {
1249         uint256 count = _tokenIds.length;
1250         for (uint256 i = 0; i < count; i++) {
1251             deliveryStatus[_tokenIds[i]] = ShippingStatus.ShippingConfirmed;
1252             emit ShippingConfirmed(CS2.ownerOf(_tokenIds[i]), _tokenIds[i]);
1253         }
1254     }
1255 
1256     // For shipping service: Mark shipping as failed/rejected (due to invalid address).
1257     function rejectShipping(uint256[] memory _tokenIds, string memory _reason)
1258     public
1259     onlyShippingControl
1260     {
1261         uint256 count = _tokenIds.length;
1262         for (uint256 i = 0; i < count; i++) {
1263             deliveryStatus[_tokenIds[i]] = ShippingStatus.Sold;
1264             emit ShippingFailed(CS2.ownerOf(_tokenIds[i]), _tokenIds[i], _reason);
1265         }
1266     }
1267 
1268     /*** Enable reverse ENS registration ***/
1269 
1270     // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.
1271     // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
1272     // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069
1273     function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)
1274     external
1275     onlyTokenAssignmentControl
1276     {
1277         require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");
1278         ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);
1279     }
1280 
1281     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
1282 
1283     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
1284     function rescueToken(IERC20 _foreignToken, address _to)
1285     external
1286     onlyTokenAssignmentControl
1287     {
1288         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
1289     }
1290 
1291     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
1292     function approveNFTrescue(IERC721 _foreignNFT, address _to)
1293     external
1294     onlyTokenAssignmentControl
1295     {
1296         _foreignNFT.setApprovalForAll(_to, true);
1297     }
1298 
1299 }