1 // File: metamishima/filter/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 // File: metamishima/filter/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.17;
36 
37 
38 /**
39  * @title  OperatorFilterer
40  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
41  *         registrant's entries in the OperatorFilterRegistry.
42  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
43  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
44  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
45  */
46 abstract contract OperatorFilterer {
47     error OperatorNotAllowed(address operator);
48 
49     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
50         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
51 
52     bool internal filterAllowed = true;
53     mapping(address => bool) internal internallyAllowed;
54 
55     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
56         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
57         // will not revert, but the contract will need to be registered with the registry once it is deployed in
58         // order for the modifier to filter addresses.
59         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
60             if (subscribe) {
61                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
62             } else {
63                 if (subscriptionOrRegistrantToCopy != address(0)) {
64                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
65                 } else {
66                     OPERATOR_FILTER_REGISTRY.register(address(this));
67                 }
68             }
69         }
70     }
71 
72     modifier onlyAllowedOperator(address from) virtual {
73         if(internallyAllowed[from]) {
74             _;
75             return;
76         } else
77         // Check registry code length to facilitate testing in environments without a deployed registry.
78         if (filterAllowed && address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
79             // Allow spending tokens from addresses with balance
80             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
81             // from an EOA.
82             if (from == msg.sender) {
83                 _;
84                 return;
85             }
86             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
87                 revert OperatorNotAllowed(msg.sender);
88             }
89         }
90         _;
91     }
92 
93     modifier onlyAllowedOperatorApproval(address operator) virtual {
94         if(internallyAllowed[operator]) {
95             _;
96             return;
97         } else
98         // Check registry code length to facilitate testing in environments without a deployed registry.
99         if (filterAllowed && address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
100             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
101                 revert OperatorNotAllowed(operator);
102             }
103         }
104         _;
105     }
106 }
107 // File: metamishima/filter/DefaultOperatorFilterer.sol
108 
109 
110 pragma solidity ^0.8.17;
111 
112 
113 /**
114  * @title  DefaultOperatorFilterer
115  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
116  */
117 abstract contract DefaultOperatorFilterer is OperatorFilterer {
118     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
119 
120     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
121 }
122 // File: metamishima/Meta Mishima.sol
123 
124 
125 
126 pragma solidity 0.8.17;
127 
128 
129 /// @title META MISHIMA by TAG COMICS
130 /// @author Andre Costa @ Terratecc
131 /// updated for royalty enforcement by https://rarity.garden
132 
133 /**
134  * @dev Contract module that helps prevent reentrant calls to a function.
135  *
136  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
137  * available, which can be applied to functions to make sure there are no nested
138  * (reentrant) calls to them.
139  *
140  * Note that because there is a single `nonReentrant` guard, functions marked as
141  * `nonReentrant` may not call one another. This can be worked around by making
142  * those functions `private`, and then adding `external` `nonReentrant` entry
143  * points to them.
144  *
145  * TIP: If you would like to learn more about reentrancy and alternative ways
146  * to protect against it, check out our blog post
147  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
148  */
149 abstract contract ReentrancyGuard {
150     // Booleans are more expensive than uint256 or any type that takes up a full
151     // word because each write operation emits an extra SLOAD to first read the
152     // slot's contents, replace the bits taken up by the boolean, and then write
153     // back. This is the compiler's defense against contract upgrades and
154     // pointer aliasing, and it cannot be disabled.
155 
156     // The values being non-zero value makes deployment a bit more expensive,
157     // but in exchange the refund on every call to nonReentrant will be lower in
158     // amount. Since refunds are capped to a percentage of the total
159     // transaction's gas, it is best to keep them low in cases like this one, to
160     // increase the likelihood of the full refund coming into effect.
161     uint256 private constant _NOT_ENTERED = 1;
162     uint256 private constant _ENTERED = 2;
163 
164     uint256 private _status;
165 
166     constructor() {
167         _status = _NOT_ENTERED;
168     }
169 
170     /**
171      * @dev Prevents a contract from calling itself, directly or indirectly.
172      * Calling a `nonReentrant` function from another `nonReentrant`
173      * function is not supported. It is possible to prevent this from happening
174      * by making the `nonReentrant` function external, and making it call a
175      * `private` function that does the actual work.
176      */
177     modifier nonReentrant() {
178         // On the first call to nonReentrant, _notEntered will be true
179         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
180 
181         // Any calls to nonReentrant after this point will fail
182         _status = _ENTERED;
183 
184         _;
185 
186         // By storing the original value once again, a refund is triggered (see
187         // https://eips.ethereum.org/EIPS/eip-2200)
188         _status = _NOT_ENTERED;
189     }
190 }
191 
192 /**
193  * @dev Provides information about the current execution context, including the
194  * sender of the transaction and its data. While these are generally available
195  * via msg.sender and msg.data, they should not be accessed in such a direct
196  * manner, since when dealing with meta-transactions the account sending and
197  * paying for execution may not be the actual sender (as far as an application
198  * is concerned).
199  *
200  * This contract is only required for intermediate, library-like contracts.
201  */
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 
212 /**
213  * @dev Contract module which provides a basic access control mechanism, where
214  * there is an account (an owner) that can be granted exclusive access to
215  * specific functions.
216  *
217  * By default, the owner account will be the one that deploys the contract. This
218  * can later be changed with {transferOwnership}.
219  *
220  * This module is used through inheritance. It will make available the modifier
221  * `onlyOwner`, which can be applied to your functions to restrict their use to
222  * the owner.
223  */
224 abstract contract Ownable is Context {
225     address private _owner;
226 
227     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229     /**
230      * @dev Initializes the contract setting the deployer as the initial owner.
231      */
232     constructor() {
233         _transferOwnership(_msgSender());
234     }
235 
236     /**
237      * @dev Returns the address of the current owner.
238      */
239     function owner() public view virtual returns (address) {
240         return _owner;
241     }
242 
243     /**
244      * @dev Throws if called by any account other than the owner.
245      */
246     modifier onlyOwner() {
247         require(owner() == _msgSender(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     /**
252      * @dev Leaves the contract without owner. It will not be possible to call
253      * `onlyOwner` functions anymore. Can only be called by the current owner.
254      *
255      * NOTE: Renouncing ownership will leave the contract without an owner,
256      * thereby removing any functionality that is only available to the owner.
257      */
258     function renounceOwnership() public virtual onlyOwner {
259         _transferOwnership(address(0));
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Can only be called by the current owner.
265      */
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         _transferOwnership(newOwner);
269     }
270 
271     /**
272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
273      * Internal function without access restriction.
274      */
275     function _transferOwnership(address newOwner) internal virtual {
276         address oldOwner = _owner;
277         _owner = newOwner;
278         emit OwnershipTransferred(oldOwner, newOwner);
279     }
280 }
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      *
303      * [IMPORTANT]
304      * ====
305      * You shouldn't rely on `isContract` to protect against flash loan attacks!
306      *
307      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
308      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
309      * constructor.
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // This method relies on extcodesize/address.code.length, which returns 0
314         // for contracts in construction, since the code is only stored at the end
315         // of the constructor execution.
316 
317         return account.code.length > 0;
318     }
319 
320     /**
321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322      * `recipient`, forwarding all available gas and reverting on errors.
323      *
324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
326      * imposed by `transfer`, making them unable to receive funds via
327      * `transfer`. {sendValue} removes this limitation.
328      *
329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330      *
331      * IMPORTANT: because control is transferred to `recipient`, care must be
332      * taken to not create reentrancy vulnerabilities. Consider using
333      * {ReentrancyGuard} or the
334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335      */
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(address(this).balance >= amount, "Address: insufficient balance");
338 
339         (bool success, ) = recipient.call{value: amount}("");
340         require(success, "Address: unable to send value, recipient may have reverted");
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain `call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionCall(target, data, "Address: low-level call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
367      * `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, 0, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but also transferring `value` wei to `target`.
382      *
383      * Requirements:
384      *
385      * - the calling contract must have an ETH balance of at least `value`.
386      * - the called Solidity function must be `payable`.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value
394     ) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(address(this).balance >= value, "Address: insufficient balance for call");
411         require(isContract(target), "Address: call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.call{value: value}(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
424         return functionStaticCall(target, data, "Address: low-level static call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal view returns (bytes memory) {
438         require(isContract(target), "Address: static call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(isContract(target), "Address: delegate call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
473      * revert reason using the provided one.
474      *
475      * _Available since v4.3._
476      */
477     function verifyCallResult(
478         bool success,
479         bytes memory returndata,
480         string memory errorMessage
481     ) internal pure returns (bytes memory) {
482         if (success) {
483             return returndata;
484         } else {
485             // Look for revert reason and bubble it up if present
486             if (returndata.length > 0) {
487                 // The easiest way to bubble the revert reason is using memory via assembly
488 
489                 assembly {
490                     let returndata_size := mload(returndata)
491                     revert(add(32, returndata), returndata_size)
492                 }
493             } else {
494                 revert(errorMessage);
495             }
496         }
497     }
498 }
499 
500 /**
501  * @title ERC721 token receiver interface
502  * @dev Interface for any contract that wants to support safeTransfers
503  * from ERC721 asset contracts.
504  */
505 interface IERC721Receiver {
506     /**
507      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
508      * by `operator` from `from`, this function is called.
509      *
510      * It must return its Solidity selector to confirm the token transfer.
511      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
512      *
513      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
514      */
515     function onERC721Received(
516         address operator,
517         address from,
518         uint256 tokenId,
519         bytes calldata data
520     ) external returns (bytes4);
521 }
522 
523 /**
524  * @dev Interface of the ERC165 standard, as defined in the
525  * https://eips.ethereum.org/EIPS/eip-165[EIP].
526  *
527  * Implementers can declare support of contract interfaces, which can then be
528  * queried by others ({ERC165Checker}).
529  *
530  * For an implementation, see {ERC165}.
531  */
532 interface IERC165 {
533     /**
534      * @dev Returns true if this contract implements the interface defined by
535      * `interfaceId`. See the corresponding
536      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
537      * to learn more about how these ids are created.
538      *
539      * This function call must use less than 30 000 gas.
540      */
541     function supportsInterface(bytes4 interfaceId) external view returns (bool);
542 }
543 
544 /**
545  * @dev Interface for the NFT Royalty Standard.
546  *
547  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
548  * support for royalty payments across all NFT marketplaces and ecosystem participants.
549  *
550  * _Available since v4.5._
551  */
552 interface IERC2981 is IERC165 {
553     /**
554      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
555      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
556      */
557     function royaltyInfo(uint256 tokenId, uint256 salePrice)
558         external
559         view
560         returns (address receiver, uint256 royaltyAmount);
561 }
562 
563 /**
564  * @dev Implementation of the {IERC165} interface.
565  *
566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
567  * for the additional interface id that will be supported. For example:
568  *
569  * ```solidity
570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
572  * }
573  * ```
574  *
575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
576  */
577 abstract contract ERC165 is IERC165 {
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582         return interfaceId == type(IERC165).interfaceId;
583     }
584 }
585 
586 /**
587  * @dev Required interface of an ERC721 compliant contract.
588  */
589 interface IERC721 is IERC165 {
590     /**
591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
592      */
593     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
597      */
598     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
602      */
603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
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
681     function getApproved(uint256 tokenId) external view returns (address operator);
682 
683     /**
684      * @dev Approve or remove `operator` as an operator for the caller.
685      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
686      *
687      * Requirements:
688      *
689      * - The `operator` cannot be the caller.
690      *
691      * Emits an {ApprovalForAll} event.
692      */
693     function setApprovalForAll(address operator, bool _approved) external;
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes calldata data
720     ) external;
721 }
722 
723 /**
724  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
725  * @dev See https://eips.ethereum.org/EIPS/eip-721
726  */
727 interface IERC721Metadata is IERC721 {
728     /**
729      * @dev Returns the token collection name.
730      */
731     function name() external view returns (string memory);
732 
733     /**
734      * @dev Returns the token collection symbol.
735      */
736     function symbol() external view returns (string memory);
737 
738     /**
739      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
740      */
741     function tokenURI(uint256 tokenId) external view returns (string memory);
742 }
743 
744 
745 /**
746  * @dev String operations.
747  */
748 library Strings {
749     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
750 
751     /**
752      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
753      */
754     function toString(uint256 value) internal pure returns (string memory) {
755         // Inspired by OraclizeAPI's implementation - MIT licence
756         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
757 
758         if (value == 0) {
759             return "0";
760         }
761         uint256 temp = value;
762         uint256 digits;
763         while (temp != 0) {
764             digits++;
765             temp /= 10;
766         }
767         bytes memory buffer = new bytes(digits);
768         while (value != 0) {
769             digits -= 1;
770             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
771             value /= 10;
772         }
773         return string(buffer);
774     }
775 
776     /**
777      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
778      */
779     function toHexString(uint256 value) internal pure returns (string memory) {
780         if (value == 0) {
781             return "0x00";
782         }
783         uint256 temp = value;
784         uint256 length = 0;
785         while (temp != 0) {
786             length++;
787             temp >>= 8;
788         }
789         return toHexString(value, length);
790     }
791 
792     /**
793      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
794      */
795     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
796         bytes memory buffer = new bytes(2 * length + 2);
797         buffer[0] = "0";
798         buffer[1] = "x";
799         for (uint256 i = 2 * length + 1; i > 1; --i) {
800             buffer[i] = _HEX_SYMBOLS[value & 0xf];
801             value >>= 4;
802         }
803         require(value == 0, "Strings: hex length insufficient");
804         return string(buffer);
805     }
806 }
807 
808 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
809 contract ERC2981 is IERC2981 {
810     struct RoyaltyInfo {
811         address recipient;
812         uint24 amount;
813     }
814 
815     RoyaltyInfo private _royalties;
816 
817     /// @dev Sets token royalties
818     /// @param recipient recipient of the royalties
819     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
820     function _setRoyalties(address recipient, uint256 value) internal {
821         require(value <= 10000, "ERC2981Royalties: Too high");
822         _royalties = RoyaltyInfo(recipient, uint24(value));
823     }
824 
825     /// @inheritdoc IERC2981
826     function royaltyInfo(uint256, uint256 value)
827         external
828         view
829         override
830         returns (address receiver, uint256 royaltyAmount)
831     {
832         RoyaltyInfo memory royalties = _royalties;
833         receiver = royalties.recipient;
834         royaltyAmount = (value * royalties.amount) / 10000;
835     }
836 
837     /// @inheritdoc IERC165
838     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
839         return interfaceId == type(IERC2981).interfaceId || interfaceId == type(IERC165).interfaceId;
840     }
841 }
842 
843 /**
844  * @dev These functions deal with verification of Merkle Trees proofs.
845  *
846  * The proofs can be generated using the JavaScript library
847  * https://github.com/miguelmota/merkletreejs[merkletreejs].
848  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
849  *
850  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
851  */
852 library MerkleProof {
853     /**
854      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
855      * defined by `root`. For this, a `proof` must be provided, containing
856      * sibling hashes on the branch from the leaf to the root of the tree. Each
857      * pair of leaves and each pair of pre-images are assumed to be sorted.
858      */
859     function verify(
860         bytes32[] memory proof,
861         bytes32 root,
862         bytes32 leaf
863     ) internal pure returns (bool) {
864         return processProof(proof, leaf) == root;
865     }
866 
867     /**
868      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
869      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
870      * hash matches the root of the tree. When processing the proof, the pairs
871      * of leafs & pre-images are assumed to be sorted.
872      *
873      * _Available since v4.4._
874      */
875     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
876         bytes32 computedHash = leaf;
877         for (uint256 i = 0; i < proof.length; i++) {
878             bytes32 proofElement = proof[i];
879             if (computedHash <= proofElement) {
880                 // Hash(current computed hash + current element of the proof)
881                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
882             } else {
883                 // Hash(current element of the proof + current computed hash)
884                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
885             }
886         }
887         return computedHash;
888     }
889 }
890 
891 /**
892  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
893  * @dev See https://eips.ethereum.org/EIPS/eip-721
894  */
895 interface IERC721Enumerable is IERC721 {
896     /**
897      * @dev Returns the total amount of tokens stored by the contract.
898      */
899     function totalSupply() external view returns (uint256);
900 
901     /**
902      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
903      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
904      */
905     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
906 
907     /**
908      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
909      * Use along with {totalSupply} to enumerate all tokens.
910      */
911     function tokenByIndex(uint256 index) external view returns (uint256);
912 }
913 
914 contract ERC721A is
915   Context,
916   ERC165,
917   IERC721,
918   IERC721Metadata,
919   IERC721Enumerable
920 {
921   using Address for address;
922   using Strings for uint256;
923 
924   struct TokenOwnership {
925     address addr;
926     uint64 startTimestamp;
927   }
928 
929   struct AddressData {
930     uint128 balance;
931     uint128 numberMinted;
932   }
933 
934   uint256 private currentIndex = 0;
935 
936   uint256 internal immutable collectionSize;
937   uint256 internal immutable maxBatchSize;
938 
939   // Token name
940   string private _name;
941 
942   // Token symbol
943   string private _symbol;
944 
945   // Mapping from token ID to ownership details
946   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
947   mapping(uint256 => TokenOwnership) private _ownerships;
948 
949   // Mapping owner address to address data
950   mapping(address => AddressData) private _addressData;
951 
952   // Mapping from token ID to approved address
953   mapping(uint256 => address) private _tokenApprovals;
954 
955   // Mapping from owner to operator approvals
956   mapping(address => mapping(address => bool)) private _operatorApprovals;
957 
958   /**
959    * @dev
960    * `maxBatchSize` refers to how much a minter can mint at a time.
961    * `collectionSize_` refers to how many tokens are in the collection.
962    */
963   constructor(
964     string memory name_,
965     string memory symbol_
966   ) {
967     _name = name_;
968     _symbol = symbol_;
969     maxBatchSize = 10;
970     collectionSize = 10000;
971   }
972 
973   /**
974    * @dev See {IERC721Enumerable-totalSupply}.
975    */
976   function totalSupply() public view override returns (uint256) {
977     return currentIndex;
978   }
979 
980   /**
981    * @dev See {IERC721Enumerable-tokenByIndex}.
982    */
983   function tokenByIndex(uint256 index) public view override returns (uint256) {
984     require(index < totalSupply(), "ERC721A: global index out of bounds");
985     return index;
986   }
987 
988   /**
989    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
990    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
991    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
992    */
993   function tokenOfOwnerByIndex(address owner, uint256 index)
994     public
995     view
996     override
997     returns (uint256)
998   {
999     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1000     uint256 numMintedSoFar = totalSupply();
1001     uint256 tokenIdsIdx = 0;
1002     address currOwnershipAddr = address(0);
1003     for (uint256 i = 0; i < numMintedSoFar; i++) {
1004       TokenOwnership memory ownership = _ownerships[i];
1005       if (ownership.addr != address(0)) {
1006         currOwnershipAddr = ownership.addr;
1007       }
1008       if (currOwnershipAddr == owner) {
1009         if (tokenIdsIdx == index) {
1010           return i;
1011         }
1012         tokenIdsIdx++;
1013       }
1014     }
1015     revert("ERC721A: unable to get token of owner by index");
1016   }
1017 
1018   /**
1019    * @dev See {IERC165-supportsInterface}.
1020    */
1021   function supportsInterface(bytes4 interfaceId)
1022     public
1023     view
1024     virtual
1025     override(ERC165, IERC165)
1026     returns (bool)
1027   {
1028     return
1029       interfaceId == type(IERC721).interfaceId ||
1030       interfaceId == type(IERC721Metadata).interfaceId ||
1031       interfaceId == type(IERC721Enumerable).interfaceId ||
1032       super.supportsInterface(interfaceId);
1033   }
1034 
1035   /**
1036    * @dev See {IERC721-balanceOf}.
1037    */
1038   function balanceOf(address owner) public view override returns (uint256) {
1039     require(owner != address(0), "ERC721A: balance query for the zero address");
1040     return uint256(_addressData[owner].balance);
1041   }
1042 
1043   function _numberMinted(address owner) internal view returns (uint256) {
1044     require(
1045       owner != address(0),
1046       "ERC721A: number minted query for the zero address"
1047     );
1048     return uint256(_addressData[owner].numberMinted);
1049   }
1050 
1051   function ownershipOf(uint256 tokenId)
1052     internal
1053     view
1054     returns (TokenOwnership memory)
1055   {
1056     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1057 
1058     uint256 lowestTokenToCheck;
1059     if (tokenId >= maxBatchSize) {
1060       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1061     }
1062 
1063     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1064       TokenOwnership memory ownership = _ownerships[curr];
1065       if (ownership.addr != address(0)) {
1066         return ownership;
1067       }
1068     }
1069 
1070     revert("ERC721A: unable to determine the owner of token");
1071   }
1072 
1073   /**
1074    * @dev See {IERC721-ownerOf}.
1075    */
1076   function ownerOf(uint256 tokenId) public view override returns (address) {
1077     return ownershipOf(tokenId).addr;
1078   }
1079 
1080   /**
1081    * @dev See {IERC721Metadata-name}.
1082    */
1083   function name() public view virtual override returns (string memory) {
1084     return _name;
1085   }
1086 
1087   /**
1088    * @dev See {IERC721Metadata-symbol}.
1089    */
1090   function symbol() public view virtual override returns (string memory) {
1091     return _symbol;
1092   }
1093 
1094   /**
1095    * @dev See {IERC721Metadata-tokenURI}.
1096    */
1097   function tokenURI(uint256 tokenId)
1098     public
1099     view
1100     virtual
1101     override
1102     returns (string memory)
1103   {
1104     require(
1105       _exists(tokenId),
1106       "ERC721Metadata: URI query for nonexistent token"
1107     );
1108 
1109     string memory baseURI = _baseURI();
1110     return
1111       bytes(baseURI).length > 0
1112         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1113         : "";
1114   }
1115 
1116   /**
1117    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1118    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1119    * by default, can be overriden in child contracts.
1120    */
1121   function _baseURI() internal view virtual returns (string memory) {
1122     return "";
1123   }
1124 
1125   /**
1126    * @dev See {IERC721-approve}.
1127    */
1128   function approve(address to, uint256 tokenId) public virtual override {
1129     address owner = ERC721A.ownerOf(tokenId);
1130     require(to != owner, "ERC721A: approval to current owner");
1131 
1132     require(
1133       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1134       "ERC721A: approve caller is not owner nor approved for all"
1135     );
1136 
1137     _approve(to, tokenId, owner);
1138   }
1139 
1140   /**
1141    * @dev See {IERC721-getApproved}.
1142    */
1143   function getApproved(uint256 tokenId) public view override returns (address) {
1144     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1145 
1146     return _tokenApprovals[tokenId];
1147   }
1148 
1149   /**
1150    * @dev See {IERC721-setApprovalForAll}.
1151    */
1152   function setApprovalForAll(address operator, bool approved) public virtual override {
1153     require(operator != _msgSender(), "ERC721A: approve to caller");
1154 
1155     _operatorApprovals[_msgSender()][operator] = approved;
1156     emit ApprovalForAll(_msgSender(), operator, approved);
1157   }
1158 
1159   /**
1160    * @dev See {IERC721-isApprovedForAll}.
1161    */
1162   function isApprovedForAll(address owner, address operator)
1163     public
1164     view
1165     virtual
1166     override
1167     returns (bool)
1168   {
1169     return _operatorApprovals[owner][operator];
1170   }
1171 
1172   /**
1173    * @dev See {IERC721-transferFrom}.
1174    */
1175   function transferFrom(
1176     address from,
1177     address to,
1178     uint256 tokenId
1179   ) public virtual override {
1180     _transfer(from, to, tokenId);
1181   }
1182 
1183   /**
1184    * @dev See {IERC721-safeTransferFrom}.
1185    */
1186   function safeTransferFrom(
1187     address from,
1188     address to,
1189     uint256 tokenId
1190   ) public virtual override {
1191     safeTransferFrom(from, to, tokenId, "");
1192   }
1193 
1194   /**
1195    * @dev See {IERC721-safeTransferFrom}.
1196    */
1197   function safeTransferFrom(
1198     address from,
1199     address to,
1200     uint256 tokenId,
1201     bytes memory _data
1202   ) public virtual override {
1203     _transfer(from, to, tokenId);
1204     require(
1205       _checkOnERC721Received(from, to, tokenId, _data),
1206       "ERC721A: transfer to non ERC721Receiver implementer"
1207     );
1208   }
1209 
1210   /**
1211    * @dev Returns whether `tokenId` exists.
1212    *
1213    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1214    *
1215    * Tokens start existing when they are minted (`_mint`),
1216    */
1217   function _exists(uint256 tokenId) internal view returns (bool) {
1218     return tokenId < currentIndex;
1219   }
1220 
1221   function _safeMint(address to, uint256 quantity) internal {
1222     _safeMint(to, quantity, "");
1223   }
1224 
1225   /**
1226    * @dev Mints `quantity` tokens and transfers them to `to`.
1227    *
1228    * Requirements:
1229    *
1230    * - there must be `quantity` tokens remaining unminted in the total collection.
1231    * - `to` cannot be the zero address.
1232    * - `quantity` cannot be larger than the max batch size.
1233    *
1234    * Emits a {Transfer} event.
1235    */
1236   function _safeMint(
1237     address to,
1238     uint256 quantity,
1239     bytes memory _data
1240   ) internal {
1241     uint256 startTokenId = currentIndex;
1242     require(to != address(0), "ERC721A: mint to the zero address");
1243     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1244     require(!_exists(startTokenId), "ERC721A: token already minted");
1245     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1246 
1247     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1248 
1249     AddressData memory addressData = _addressData[to];
1250     _addressData[to] = AddressData(
1251       addressData.balance + uint128(quantity),
1252       addressData.numberMinted + uint128(quantity)
1253     );
1254     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1255 
1256     uint256 updatedIndex = startTokenId;
1257 
1258     for (uint256 i = 0; i < quantity; i++) {
1259       emit Transfer(address(0), to, updatedIndex);
1260       require(
1261         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1262         "ERC721A: transfer to non ERC721Receiver implementer"
1263       );
1264       updatedIndex++;
1265     }
1266 
1267     currentIndex = updatedIndex;
1268     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1269   }
1270 
1271   /**
1272    * @dev Transfers `tokenId` from `from` to `to`.
1273    *
1274    * Requirements:
1275    *
1276    * - `to` cannot be the zero address.
1277    * - `tokenId` token must be owned by `from`.
1278    *
1279    * Emits a {Transfer} event.
1280    */
1281   function _transfer(
1282     address from,
1283     address to,
1284     uint256 tokenId
1285   ) private {
1286     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1287 
1288     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1289       getApproved(tokenId) == _msgSender() ||
1290       isApprovedForAll(prevOwnership.addr, _msgSender()));
1291 
1292     require(
1293       isApprovedOrOwner,
1294       "ERC721A: transfer caller is not owner nor approved"
1295     );
1296 
1297     require(
1298       prevOwnership.addr == from,
1299       "ERC721A: transfer from incorrect owner"
1300     );
1301     require(to != address(0), "ERC721A: transfer to the zero address");
1302 
1303     _beforeTokenTransfers(from, to, tokenId, 1);
1304 
1305     // Clear approvals from the previous owner
1306     _approve(address(0), tokenId, prevOwnership.addr);
1307 
1308     _addressData[from].balance -= 1;
1309     _addressData[to].balance += 1;
1310     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1311 
1312     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1313     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1314     uint256 nextTokenId = tokenId + 1;
1315     if (_ownerships[nextTokenId].addr == address(0)) {
1316       if (_exists(nextTokenId)) {
1317         _ownerships[nextTokenId] = TokenOwnership(
1318           prevOwnership.addr,
1319           prevOwnership.startTimestamp
1320         );
1321       }
1322     }
1323 
1324     emit Transfer(from, to, tokenId);
1325     _afterTokenTransfers(from, to, tokenId, 1);
1326   }
1327 
1328   /**
1329    * @dev Approve `to` to operate on `tokenId`
1330    *
1331    * Emits a {Approval} event.
1332    */
1333   function _approve(
1334     address to,
1335     uint256 tokenId,
1336     address owner
1337   ) private {
1338     _tokenApprovals[tokenId] = to;
1339     emit Approval(owner, to, tokenId);
1340   }
1341 
1342   uint256 public nextOwnerToExplicitlySet = 0;
1343 
1344   /**
1345    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1346    */
1347   function _setOwnersExplicit(uint256 quantity) internal {
1348     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1349     require(quantity > 0, "quantity must be nonzero");
1350     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1351     if (endIndex > collectionSize - 1) {
1352       endIndex = collectionSize - 1;
1353     }
1354     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1355     require(_exists(endIndex), "not enough minted yet for this cleanup");
1356     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1357       if (_ownerships[i].addr == address(0)) {
1358         TokenOwnership memory ownership = ownershipOf(i);
1359         _ownerships[i] = TokenOwnership(
1360           ownership.addr,
1361           ownership.startTimestamp
1362         );
1363       }
1364     }
1365     nextOwnerToExplicitlySet = endIndex + 1;
1366   }
1367 
1368   /**
1369    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1370    * The call is not executed if the target address is not a contract.
1371    *
1372    * @param from address representing the previous owner of the given token ID
1373    * @param to target address that will receive the tokens
1374    * @param tokenId uint256 ID of the token to be transferred
1375    * @param _data bytes optional data to send along with the call
1376    * @return bool whether the call correctly returned the expected magic value
1377    */
1378   function _checkOnERC721Received(
1379     address from,
1380     address to,
1381     uint256 tokenId,
1382     bytes memory _data
1383   ) private returns (bool) {
1384     if (to.isContract()) {
1385       try
1386         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1387       returns (bytes4 retval) {
1388         return retval == IERC721Receiver(to).onERC721Received.selector;
1389       } catch (bytes memory reason) {
1390         if (reason.length == 0) {
1391           revert("ERC721A: transfer to non ERC721Receiver implementer");
1392         } else {
1393           assembly {
1394             revert(add(32, reason), mload(reason))
1395           }
1396         }
1397       }
1398     } else {
1399       return true;
1400     }
1401   }
1402 
1403   /**
1404    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1405    *
1406    * startTokenId - the first token id to be transferred
1407    * quantity - the amount to be transferred
1408    *
1409    * Calling conditions:
1410    *
1411    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1412    * transferred to `to`.
1413    * - When `from` is zero, `tokenId` will be minted for `to`.
1414    */
1415   function _beforeTokenTransfers(
1416     address from,
1417     address to,
1418     uint256 startTokenId,
1419     uint256 quantity
1420   ) internal virtual {}
1421 
1422   /**
1423    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1424    * minting.
1425    *
1426    * startTokenId - the first token id to be transferred
1427    * quantity - the amount to be transferred
1428    *
1429    * Calling conditions:
1430    *
1431    * - when `from` and `to` are both non-zero.
1432    * - `from` and `to` are never both zero.
1433    */
1434   function _afterTokenTransfers(
1435     address from,
1436     address to,
1437     uint256 startTokenId,
1438     uint256 quantity
1439   ) internal virtual {}
1440 }
1441 
1442 
1443 
1444 contract MetaMishima is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer, ReentrancyGuard {
1445     using Strings for uint256;
1446 
1447     uint256 public maxSalePlusOne = 10001;
1448     uint256 public maxGoldListPlusOne = 201;
1449     uint256 public maxEarlyBirdPlusOne = 2501;
1450 
1451     uint256 public maxMintGoldList = 2;
1452     uint256 public maxMintEarlyBird = 5;
1453     uint256 public maxMintWhitelist = 2;
1454     uint256 public maxMintPublic = 2;
1455 
1456     uint256 public tokenPrice = 0.07 ether;
1457     uint256 public tokenPricePublic = 0.09 ether;
1458 
1459     mapping(address => uint) public mintsPerAddress;
1460 
1461     bytes32 public merkleRootGoldList;
1462     bytes32 public merkleRootEarlyBird;
1463     bytes32 public merkleRootWhitelist;
1464 
1465     enum ContractState {
1466         OFF,
1467         GOLDLIST,
1468         EARLYBIRD,
1469         WHITELIST,
1470         PUBLIC
1471     }
1472 
1473     ContractState public contractState = ContractState.OFF;
1474 
1475     string public placeholderURI;
1476     string public baseURI;
1477 
1478     address public recipient;
1479 
1480     constructor() ERC721A("META MISHIMA", "MM") {
1481 
1482         placeholderURI = "ipfs://QmUDoDyvq7pUq37Ch5W5DfASPqDpSvEeuWqS7dw7Uj6fc4/";
1483 
1484         merkleRootGoldList = 0x08ce80abf0f09dd4d52be336e652a1cc125dfbe2344dbd645e1f2ccfe68cb7f0;
1485         merkleRootEarlyBird = 0x50df34905004bf0a80a679297c4b6f3ff9edbe61e09d83746869abf097d30253;
1486         merkleRootWhitelist = 0x1d3b012114f833891d9c8b5afad43264538b4613634b296b9e0e102f3de8d1c2;
1487 
1488         // 5% royalties
1489         recipient = msg.sender;
1490         _setRoyalties(recipient, 500);
1491     }
1492 
1493     //
1494     // Modifiers
1495     //
1496 
1497     /**
1498      * Do not allow calls from other contracts.
1499      */
1500     modifier noBots() {
1501         require(msg.sender == tx.origin, "No bots!");
1502         _;
1503     }
1504 
1505     /**
1506      * Ensure current state is correct for this method.
1507      */
1508     modifier isContractState(ContractState contractState_) {
1509         require(contractState == contractState_, "Invalid state");
1510         _;
1511     }
1512 
1513     /**
1514      * Ensure amount of tokens to mint is within the limit.
1515      */
1516     modifier withinMintLimit(uint256 quantity, uint256 maxSale) {
1517         require((totalSupply() + quantity) < maxSale, "Exceeds available tokens");
1518         _;
1519     }
1520 
1521     /**
1522      * Ensure correct amount of Ether present in transaction.
1523      */
1524     modifier correctValue(uint256 expectedValue) {
1525         require(expectedValue == msg.value, "Ether value sent is not correct");
1526         _;
1527     }
1528 
1529     //
1530     // Mint
1531     //
1532 
1533     /**
1534      * Public mint.
1535      * @param quantity Amount of tokens to mint.
1536      */
1537     function mintPublic(uint256 quantity)
1538         external
1539         payable
1540         noBots
1541         isContractState(ContractState.PUBLIC)
1542         withinMintLimit(quantity, maxSalePlusOne)
1543         correctValue(tokenPricePublic * quantity)
1544     {
1545         require(mintsPerAddress[_msgSender()] + quantity <= maxMintPublic, "Exceeds Max Mint Amount!");
1546         mintsPerAddress[_msgSender()] += quantity;
1547         _safeMint(_msgSender(), quantity);
1548     }
1549 
1550     /**
1551      * Mint tokens during the presale.
1552      * @notice This function is only available to those on the allowlist.
1553      * @param quantity The number of tokens to mint.
1554      */
1555     function mintWhitelist(uint256 quantity, bytes32[] calldata proof)
1556         external
1557         payable
1558         noBots
1559         isContractState(ContractState.WHITELIST)
1560         withinMintLimit(quantity, maxSalePlusOne)
1561         correctValue(tokenPrice * quantity)
1562     {
1563         bytes32 _leaf = keccak256(abi.encodePacked(_msgSender()));
1564         require(verify(merkleRootWhitelist, _leaf, proof), "Not a valid proof!");
1565         require(mintsPerAddress[_msgSender()] + quantity <= maxMintWhitelist, "Exceeds Max Mint Amount!");
1566         mintsPerAddress[_msgSender()] += quantity;
1567         _safeMint(_msgSender(), quantity);
1568     }
1569 
1570     /**
1571      * Mint tokens during the presale.
1572      * @notice This function is only available to those on the allowlist.
1573      * @param quantity The number of tokens to mint.
1574      */
1575     function mintEarlyBird(uint256 quantity, bytes32[] calldata proof)
1576         external
1577         payable
1578         noBots
1579         isContractState(ContractState.EARLYBIRD)
1580         withinMintLimit(quantity, maxEarlyBirdPlusOne)
1581         correctValue(tokenPrice * quantity)
1582     {
1583         bytes32 _leaf = keccak256(abi.encodePacked(_msgSender()));
1584         require(verify(merkleRootEarlyBird, _leaf, proof), "Not a valid proof!");
1585         require(mintsPerAddress[_msgSender()] + quantity <= maxMintEarlyBird, "Exceeds Max Mint Amount!");
1586         mintsPerAddress[_msgSender()] += quantity;
1587         _safeMint(_msgSender(), quantity);
1588     }
1589 
1590     /**
1591      * Mint tokens during the presale.
1592      * @notice This function is only available to those on the allowlist.
1593      * @param quantity The number of tokens to mint.
1594      */
1595     function mintGoldList(uint256 quantity, bytes32[] calldata proof)
1596         external
1597         payable
1598         noBots
1599         isContractState(ContractState.GOLDLIST)
1600         withinMintLimit(quantity, maxGoldListPlusOne)
1601     {
1602         bytes32 _leaf = keccak256(abi.encodePacked(_msgSender()));
1603         require(verify(merkleRootGoldList, _leaf, proof), "Not a valid proof!");
1604         require(mintsPerAddress[_msgSender()] + quantity <= maxMintGoldList, "Exceeds Max Mint Amount!");
1605         mintsPerAddress[_msgSender()] += quantity;
1606         _safeMint(_msgSender(), quantity);
1607     }
1608 
1609     /**
1610      * Team reserved mint.
1611      * @param to Address to mint to.
1612      * @param quantity Amount of tokens to mint.
1613      */
1614     function mintReserved(address to, uint256 quantity) external onlyOwner withinMintLimit(quantity, maxSalePlusOne) {
1615         _safeMint(to, quantity);
1616     }
1617 
1618     //
1619     // Admin
1620     //
1621 
1622     /**
1623      * Set contract state.
1624      * @param contractState_ The new state of the contract.
1625      */
1626     function setContractState(uint contractState_) external onlyOwner {
1627         require(contractState_ < 5, "Invalid Contract State!");
1628 
1629         if (contractState_ == 0) {
1630             contractState = ContractState.OFF;
1631         }
1632         else if (contractState_ == 1) {
1633             contractState = ContractState.GOLDLIST;
1634         }
1635         else if (contractState_ == 2) {
1636             contractState = ContractState.EARLYBIRD;
1637         }
1638         else if (contractState_ == 3) {
1639             contractState = ContractState.WHITELIST;
1640         }
1641         else {
1642             contractState = ContractState.PUBLIC;
1643         }
1644     }
1645 
1646     /**
1647      * Set the goldlist Merkle root.
1648      * @dev The Merkle root is calculated from [address, allowance] pairs.
1649      * @param merkleRoot_ The new merkle roo
1650      */
1651     function setMerkleRootGoldList(bytes32 merkleRoot_) external onlyOwner {
1652         merkleRootGoldList = merkleRoot_;
1653     }
1654 
1655     /**
1656      * Set the EB Merkle root.
1657      * @dev The Merkle root is calculated from [address, allowance] pairs.
1658      * @param merkleRoot_ The new merkle roo
1659      */
1660     function setMerkleRootEB(bytes32 merkleRoot_) external onlyOwner {
1661         merkleRootEarlyBird = merkleRoot_;
1662     }
1663 
1664     /**
1665      * Set the whitelist Merkle root.
1666      * @dev The Merkle root is calculated from [address, allowance] pairs.
1667      * @param merkleRoot_ The new merkle roo
1668      */
1669     function setMerkleRootWhitelist(bytes32 merkleRoot_) external onlyOwner {
1670         merkleRootWhitelist = merkleRoot_;
1671     }
1672 
1673     /**
1674      * Update maximum number of tokens for sale.
1675      * @param maxSale The maximum number of tokens available for sale.
1676      */
1677     function setMaxSale(uint256 maxSale) external onlyOwner {
1678         uint256 maxSalePlusOne_ = maxSale + 1;
1679         maxSalePlusOne = maxSalePlusOne_;
1680     }
1681 
1682     /**
1683      * Update public sale price.
1684      * @param newPrice The new token price.
1685      */
1686     function setTokenPrice(uint256 newPrice, uint256 newPricePublic) external onlyOwner {
1687         tokenPrice = newPrice;
1688         tokenPricePublic = newPricePublic;
1689     }
1690 
1691 
1692     /**
1693      * Sets base URI.
1694      * @param baseURI_ The base URI
1695      */
1696     function setBaseURI(string memory baseURI_) external onlyOwner {
1697         baseURI = baseURI_;
1698     }
1699 
1700     /**
1701      * Sets placeholder URI.
1702      * @param placeholderURI_ The placeholder URI
1703      */
1704     function setPlaceholderURI(string memory placeholderURI_) external onlyOwner {
1705         placeholderURI = placeholderURI_;
1706     }
1707 
1708     /**
1709      * Update wallet that will recieve funds.
1710      * @param newRecipient The new address that will recieve funds
1711      */
1712     function setRecipient(address newRecipient) external onlyOwner {
1713         require(newRecipient != address(0), "Cannot be the 0 address!");
1714         recipient = newRecipient;
1715     }
1716 
1717 
1718     //retrieve all funds recieved from minting
1719     function withdraw() public onlyOwner {
1720         uint256 balance = accountBalance();
1721         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1722 
1723         _withdraw(payable(recipient), balance); 
1724     }
1725     
1726     //send the percentage of funds to a shareholder´s wallet
1727     function _withdraw(address payable account, uint256 amount) internal {
1728         (bool sent, ) = account.call{value: amount}("");
1729         require(sent, "Failed to send Ether");
1730     }
1731 
1732     //
1733     // Views
1734     //
1735 
1736     /**
1737      * @dev See {IERC721Metadata-tokenURI}.
1738      */
1739     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1740         require(_exists(uint16(tokenId)), "URI query for nonexistent token");
1741 
1742         return
1743             bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : placeholderURI;
1744     }
1745 
1746     /// @inheritdoc IERC165
1747     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1748         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
1749     }
1750 
1751     /**
1752      * Verify the Merkle proof is valid.
1753      * @param root The Merkle root. Use the value stored in the contract
1754      * @param leaf The leaf. A [address, availableAmt] pair
1755      * @param proof The Merkle proof used to validate the leaf is in the root
1756      */
1757     function verify(
1758         bytes32 root,
1759         bytes32 leaf,
1760         bytes32[] memory proof
1761     ) internal pure returns (bool) {
1762         return MerkleProof.verify(proof, root, leaf);
1763     }
1764 
1765     /**
1766      * Get the current amount of Eth stored
1767      */
1768     function accountBalance() public view returns(uint) {
1769         return address(this).balance;
1770     }
1771 
1772     /**
1773     * ERC2981 Royalties
1774     *
1775     **/
1776 
1777     function setDefaultRoyalty(address royaltyAddress, uint96 royaltyAmount) external onlyOwner {
1778 
1779         _setRoyalties(royaltyAddress, royaltyAmount);
1780     }
1781 
1782     /**
1783     * Royalty enforcing overrides for OpenSea in order to be eligiible for creator fees on their platform.
1784     *
1785     * Since the OperatorFilterer basically controls where NFTs are allowed to get transferred to and by whom they may be approved,
1786     * we added a switch in onlyAllowedOperatorApproval() and onlyAllowedOperator() to turn it off 
1787     * in case if it will be mis-used by marketplaces.
1788     *
1789     * In case we want to allow certain addresses that are banned but the marketplace is not really bad acting,
1790     * we reserve the right to do so by using an internal allow-list for transfers and approvals.
1791     **/
1792 
1793     function setInternallyAllowed(address requestor, bool allowed) external onlyOwner {
1794 
1795         internallyAllowed[requestor] = allowed;
1796     }
1797 
1798     function isInternallyAllowed(address requestor) view external returns(bool) {
1799 
1800         return internallyAllowed[requestor];
1801     }
1802 
1803     function setOperatorFiltererAllowed(bool allowed) external onlyOwner {
1804 
1805         filterAllowed = allowed;
1806     }
1807 
1808     function isOperatorFiltererAllowed() view external returns(bool) {
1809 
1810         return filterAllowed;
1811     }
1812 
1813     function setApprovalForAll(address operator, bool approved) public override(ERC721A) onlyAllowedOperatorApproval(operator) {
1814         
1815         super.setApprovalForAll(operator, approved);
1816     }
1817 
1818     function approve(address operator, uint256 tokenId) public override(ERC721A) onlyAllowedOperatorApproval(operator) {
1819 
1820         super.approve(operator, tokenId);
1821     }
1822 
1823     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A) onlyAllowedOperator(from) {
1824 
1825         super.transferFrom(from, to, tokenId);
1826     }
1827 
1828     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A) onlyAllowedOperator(from) {
1829 
1830         super.safeTransferFrom(from, to, tokenId);
1831     }
1832 
1833     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1834         public 
1835         override(ERC721A)
1836         onlyAllowedOperator(from)
1837     {
1838 
1839         super.safeTransferFrom(from, to, tokenId, data);
1840     }
1841 }