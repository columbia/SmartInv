1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-08
3  */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-27
7  */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
11 
12 pragma solidity ^0.8.13;
13 
14 interface IOperatorFilterRegistry {
15     function isOperatorAllowed(
16         address registrant,
17         address operator
18     ) external view returns (bool);
19 
20     function register(address registrant) external;
21 
22     function registerAndSubscribe(
23         address registrant,
24         address subscription
25     ) external;
26 
27     function registerAndCopyEntries(
28         address registrant,
29         address registrantToCopy
30     ) external;
31 
32     function unregister(address addr) external;
33 
34     function updateOperator(
35         address registrant,
36         address operator,
37         bool filtered
38     ) external;
39 
40     function updateOperators(
41         address registrant,
42         address[] calldata operators,
43         bool filtered
44     ) external;
45 
46     function updateCodeHash(
47         address registrant,
48         bytes32 codehash,
49         bool filtered
50     ) external;
51 
52     function updateCodeHashes(
53         address registrant,
54         bytes32[] calldata codeHashes,
55         bool filtered
56     ) external;
57 
58     function subscribe(
59         address registrant,
60         address registrantToSubscribe
61     ) external;
62 
63     function unsubscribe(address registrant, bool copyExistingEntries) external;
64 
65     function subscriptionOf(address addr) external returns (address registrant);
66 
67     function subscribers(
68         address registrant
69     ) external returns (address[] memory);
70 
71     function subscriberAt(
72         address registrant,
73         uint256 index
74     ) external returns (address);
75 
76     function copyEntriesOf(
77         address registrant,
78         address registrantToCopy
79     ) external;
80 
81     function isOperatorFiltered(
82         address registrant,
83         address operator
84     ) external returns (bool);
85 
86     function isCodeHashOfFiltered(
87         address registrant,
88         address operatorWithCode
89     ) external returns (bool);
90 
91     function isCodeHashFiltered(
92         address registrant,
93         bytes32 codeHash
94     ) external returns (bool);
95 
96     function filteredOperators(
97         address addr
98     ) external returns (address[] memory);
99 
100     function filteredCodeHashes(
101         address addr
102     ) external returns (bytes32[] memory);
103 
104     function filteredOperatorAt(
105         address registrant,
106         uint256 index
107     ) external returns (address);
108 
109     function filteredCodeHashAt(
110         address registrant,
111         uint256 index
112     ) external returns (bytes32);
113 
114     function isRegistered(address addr) external returns (bool);
115 
116     function codeHashOf(address addr) external returns (bytes32);
117 }
118 
119 abstract contract OperatorFilterer {
120     error OperatorNotAllowed(address operator);
121 
122     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
123         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
124 
125     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
126         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
127         // will not revert, but the contract will need to be registered with the registry once it is deployed in
128         // order for the modifier to filter addresses.
129         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
130             if (subscribe) {
131                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
132                     address(this),
133                     subscriptionOrRegistrantToCopy
134                 );
135             } else {
136                 if (subscriptionOrRegistrantToCopy != address(0)) {
137                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
138                         address(this),
139                         subscriptionOrRegistrantToCopy
140                     );
141                 } else {
142                     OPERATOR_FILTER_REGISTRY.register(address(this));
143                 }
144             }
145         }
146     }
147 
148     modifier onlyAllowedOperator(address from) virtual {
149         // Allow spending tokens from addresses with balance
150         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
151         // from an EOA.
152         if (from != msg.sender) {
153             _checkFilterOperator(msg.sender);
154         }
155         _;
156     }
157 
158     modifier onlyAllowedOperatorApproval(address operator) virtual {
159         _checkFilterOperator(operator);
160         _;
161     }
162 
163     function _checkFilterOperator(address operator) internal view virtual {
164         // Check registry code length to facilitate testing in environments without a deployed registry.
165         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
166             if (
167                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
168                     address(this),
169                     operator
170                 )
171             ) {
172                 revert OperatorNotAllowed(operator);
173             }
174         }
175     }
176 }
177 
178 /**
179  * @title  DefaultOperatorFilterer
180  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
181  */
182 abstract contract DefaultOperatorFilterer is OperatorFilterer {
183     address constant DEFAULT_SUBSCRIPTION =
184         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
185 
186     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
187 }
188 
189 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
190 
191 /**
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 /**
212  * @dev Interface of the ERC165 standard, as defined in the
213  * https://eips.ethereum.org/EIPS/eip-165[EIP].
214  *
215  * Implementers can declare support of contract interfaces, which can then be
216  * queried by others ({ERC165Checker}).
217  *
218  * For an implementation, see {ERC165}.
219  */
220 interface IERC165 {
221     /**
222      * @dev Returns true if this contract implements the interface defined by
223      * `interfaceId`. See the corresponding
224      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
225      * to learn more about how these ids are created.
226      *
227      * This function call must use less than 30 000 gas.
228      */
229     function supportsInterface(bytes4 interfaceId) external view returns (bool);
230 }
231 
232 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
233 
234 /**
235  * @dev Required interface of an ERC721 compliant contract.
236  */
237 interface IERC721 is IERC165 {
238     /**
239      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
240      */
241     event Transfer(
242         address indexed from,
243         address indexed to,
244         uint256 indexed tokenId
245     );
246 
247     /**
248      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
249      */
250     event Approval(
251         address indexed owner,
252         address indexed approved,
253         uint256 indexed tokenId
254     );
255 
256     /**
257      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
258      */
259     event ApprovalForAll(
260         address indexed owner,
261         address indexed operator,
262         bool approved
263     );
264 
265     /**
266      * @dev Returns the number of tokens in ``owner``'s account.
267      */
268     function balanceOf(address owner) external view returns (uint256 balance);
269 
270     /**
271      * @dev Returns the owner of the `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function ownerOf(uint256 tokenId) external view returns (address owner);
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`.
281      *
282      * Requirements:
283      *
284      * - `from` cannot be the zero address.
285      * - `to` cannot be the zero address.
286      * - `tokenId` token must exist and be owned by `from`.
287      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
289      *
290      * Emits a {Transfer} event.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId,
296         bytes calldata data
297     ) external;
298 
299     /**
300      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
301      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must exist and be owned by `from`.
308      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
309      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
310      *
311      * Emits a {Transfer} event.
312      */
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external;
318 
319     /**
320      * @dev Transfers `tokenId` token from `from` to `to`.
321      *
322      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
323      *
324      * Requirements:
325      *
326      * - `from` cannot be the zero address.
327      * - `to` cannot be the zero address.
328      * - `tokenId` token must be owned by `from`.
329      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(address from, address to, uint256 tokenId) external;
334 
335     /**
336      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
337      * The approval is cleared when the token is transferred.
338      *
339      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
340      *
341      * Requirements:
342      *
343      * - The caller must own the token or be an approved operator.
344      * - `tokenId` must exist.
345      *
346      * Emits an {Approval} event.
347      */
348     function approve(address to, uint256 tokenId) external;
349 
350     /**
351      * @dev Approve or remove `operator` as an operator for the caller.
352      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
353      *
354      * Requirements:
355      *
356      * - The `operator` cannot be the caller.
357      *
358      * Emits an {ApprovalForAll} event.
359      */
360     function setApprovalForAll(address operator, bool _approved) external;
361 
362     /**
363      * @dev Returns the account approved for `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function getApproved(
370         uint256 tokenId
371     ) external view returns (address operator);
372 
373     /**
374      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
375      *
376      * See {setApprovalForAll}
377      */
378     function isApprovedForAll(
379         address owner,
380         address operator
381     ) external view returns (bool);
382 }
383 
384 /**
385  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
386  * @dev See https://eips.ethereum.org/EIPS/eip-721
387  */
388 interface IERC721Metadata is IERC721 {
389     /**
390      * @dev Returns the token collection name.
391      */
392     function name() external view returns (string memory);
393 
394     /**
395      * @dev Returns the token collection symbol.
396      */
397     function symbol() external view returns (string memory);
398 
399     /**
400      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
401      */
402     function tokenURI(uint256 tokenId) external view returns (string memory);
403 }
404 
405 // ERC721A Contracts v3.3.0
406 // Creator: Chiru Labs
407 
408 /**
409  * @dev Interface of an ERC721A compliant contract.
410  */
411 interface IERC721A is IERC721, IERC721Metadata {
412     /**
413      * The caller must own the token or be an approved operator.
414      */
415     error ApprovalCallerNotOwnerNorApproved();
416 
417     /**
418      * The token does not exist.
419      */
420     error ApprovalQueryForNonexistentToken();
421 
422     /**
423      * The caller cannot approve to their own address.
424      */
425     error ApproveToCaller();
426 
427     /**
428      * The caller cannot approve to the current owner.
429      */
430     error ApprovalToCurrentOwner();
431 
432     /**
433      * Cannot query the balance for the zero address.
434      */
435     error BalanceQueryForZeroAddress();
436 
437     /**
438      * Cannot mint to the zero address.
439      */
440     error MintToZeroAddress();
441 
442     /**
443      * The quantity of tokens minted must be more than zero.
444      */
445     error MintZeroQuantity();
446 
447     /**
448      * The token does not exist.
449      */
450     error OwnerQueryForNonexistentToken();
451 
452     /**
453      * The caller must own the token or be an approved operator.
454      */
455     error TransferCallerNotOwnerNorApproved();
456 
457     /**
458      * The token must be owned by `from`.
459      */
460     error TransferFromIncorrectOwner();
461 
462     /**
463      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
464      */
465     error TransferToNonERC721ReceiverImplementer();
466 
467     /**
468      * Cannot transfer to the zero address.
469      */
470     error TransferToZeroAddress();
471 
472     /**
473      * The token does not exist.
474      */
475     error URIQueryForNonexistentToken();
476 
477     // Compiler will pack this into a single 256bit word.
478     struct TokenOwnership {
479         // The address of the owner.
480         address addr;
481         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
482         uint64 startTimestamp;
483         // Whether the token has been burned.
484         bool burned;
485     }
486 
487     // Compiler will pack this into a single 256bit word.
488     struct AddressData {
489         // Realistically, 2**64-1 is more than enough.
490         uint64 balance;
491         // Keeps track of mint count with minimal overhead for tokenomics.
492         uint64 numberMinted;
493         // Keeps track of burn count with minimal overhead for tokenomics.
494         uint64 numberBurned;
495         // For miscellaneous variable(s) pertaining to the address
496         // (e.g. number of whitelist mint slots used).
497         // If there are multiple variables, please pack them into a uint64.
498         uint64 aux;
499     }
500 
501     /**
502      * @dev Returns the total amount of tokens stored by the contract.
503      *
504      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
505      */
506     function totalSupply() external view returns (uint256);
507 }
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
510 
511 /**
512  * @dev Implementation of the {IERC165} interface.
513  *
514  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
515  * for the additional interface id that will be supported. For example:
516  *
517  * ```solidity
518  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
520  * }
521  * ```
522  *
523  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
524  */
525 abstract contract ERC165 is IERC165 {
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(
530         bytes4 interfaceId
531     ) public view virtual override returns (bool) {
532         return interfaceId == type(IERC165).interfaceId;
533     }
534 }
535 
536 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
537 
538 /**
539  * @dev Contract module which provides a basic access control mechanism, where
540  * there is an account (an owner) that can be granted exclusive access to
541  * specific functions.
542  *
543  * By default, the owner account will be the one that deploys the contract. This
544  * can later be changed with {transferOwnership}.
545  *
546  * This module is used through inheritance. It will make available the modifier
547  * `onlyOwner`, which can be applied to your functions to restrict their use to
548  * the owner.
549  */
550 abstract contract Ownable is Context {
551     address private _owner;
552 
553     event OwnershipTransferred(
554         address indexed previousOwner,
555         address indexed newOwner
556     );
557 
558     /**
559      * @dev Initializes the contract setting the deployer as the initial owner.
560      */
561     constructor() {
562         _transferOwnership(_msgSender());
563     }
564 
565     /**
566      * @dev Returns the address of the current owner.
567      */
568     function owner() public view virtual returns (address) {
569         return _owner;
570     }
571 
572     /**
573      * @dev Throws if called by any account other than the owner.
574      */
575     modifier onlyOwner() {
576         require(owner() == _msgSender(), "Ownable: caller is not the owner");
577         _;
578     }
579 
580     /**
581      * @dev Leaves the contract without owner. It will not be possible to call
582      * `onlyOwner` functions anymore. Can only be called by the current owner.
583      *
584      * NOTE: Renouncing ownership will leave the contract without an owner,
585      * thereby removing any functionality that is only available to the owner.
586      */
587     function renounceOwnership() public virtual onlyOwner {
588         _transferOwnership(address(0));
589     }
590 
591     /**
592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
593      * Can only be called by the current owner.
594      */
595     function transferOwnership(address newOwner) public virtual onlyOwner {
596         require(
597             newOwner != address(0),
598             "Ownable: new owner is the zero address"
599         );
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      * Internal function without access restriction.
606      */
607     function _transferOwnership(address newOwner) internal virtual {
608         address oldOwner = _owner;
609         _owner = newOwner;
610         emit OwnershipTransferred(oldOwner, newOwner);
611     }
612 }
613 
614 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
615 
616 /**
617  * @dev Collection of functions related to the address type
618  */
619 library Address {
620     /**
621      * @dev Returns true if `account` is a contract.
622      *
623      * [IMPORTANT]
624      * ====
625      * It is unsafe to assume that an address for which this function returns
626      * false is an externally-owned account (EOA) and not a contract.
627      *
628      * Among others, `isContract` will return false for the following
629      * types of addresses:
630      *
631      *  - an externally-owned account
632      *  - a contract in construction
633      *  - an address where a contract will be created
634      *  - an address where a contract lived, but was destroyed
635      * ====
636      *
637      * [IMPORTANT]
638      * ====
639      * You shouldn't rely on `isContract` to protect against flash loan attacks!
640      *
641      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
642      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
643      * constructor.
644      * ====
645      */
646     function isContract(address account) internal view returns (bool) {
647         // This method relies on extcodesize/address.code.length, which returns 0
648         // for contracts in construction, since the code is only stored at the end
649         // of the constructor execution.
650 
651         return account.code.length > 0;
652     }
653 
654     /**
655      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
656      * `recipient`, forwarding all available gas and reverting on errors.
657      *
658      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
659      * of certain opcodes, possibly making contracts go over the 2300 gas limit
660      * imposed by `transfer`, making them unable to receive funds via
661      * `transfer`. {sendValue} removes this limitation.
662      *
663      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
664      *
665      * IMPORTANT: because control is transferred to `recipient`, care must be
666      * taken to not create reentrancy vulnerabilities. Consider using
667      * {ReentrancyGuard} or the
668      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
669      */
670     function sendValue(address payable recipient, uint256 amount) internal {
671         require(
672             address(this).balance >= amount,
673             "Address: insufficient balance"
674         );
675 
676         (bool success, ) = recipient.call{value: amount}("");
677         require(
678             success,
679             "Address: unable to send value, recipient may have reverted"
680         );
681     }
682 
683     /**
684      * @dev Performs a Solidity function call using a low level `call`. A
685      * plain `call` is an unsafe replacement for a function call: use this
686      * function instead.
687      *
688      * If `target` reverts with a revert reason, it is bubbled up by this
689      * function (like regular Solidity function calls).
690      *
691      * Returns the raw returned data. To convert to the expected return value,
692      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
693      *
694      * Requirements:
695      *
696      * - `target` must be a contract.
697      * - calling `target` with `data` must not revert.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(
702         address target,
703         bytes memory data
704     ) internal returns (bytes memory) {
705         return functionCall(target, data, "Address: low-level call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
710      * `errorMessage` as a fallback revert reason when `target` reverts.
711      *
712      * _Available since v3.1._
713      */
714     function functionCall(
715         address target,
716         bytes memory data,
717         string memory errorMessage
718     ) internal returns (bytes memory) {
719         return functionCallWithValue(target, data, 0, errorMessage);
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
724      * but also transferring `value` wei to `target`.
725      *
726      * Requirements:
727      *
728      * - the calling contract must have an ETH balance of at least `value`.
729      * - the called Solidity function must be `payable`.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(
734         address target,
735         bytes memory data,
736         uint256 value
737     ) internal returns (bytes memory) {
738         return
739             functionCallWithValue(
740                 target,
741                 data,
742                 value,
743                 "Address: low-level call with value failed"
744             );
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
749      * with `errorMessage` as a fallback revert reason when `target` reverts.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(
754         address target,
755         bytes memory data,
756         uint256 value,
757         string memory errorMessage
758     ) internal returns (bytes memory) {
759         require(
760             address(this).balance >= value,
761             "Address: insufficient balance for call"
762         );
763         require(isContract(target), "Address: call to non-contract");
764 
765         (bool success, bytes memory returndata) = target.call{value: value}(
766             data
767         );
768         return verifyCallResult(success, returndata, errorMessage);
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
773      * but performing a static call.
774      *
775      * _Available since v3.3._
776      */
777     function functionStaticCall(
778         address target,
779         bytes memory data
780     ) internal view returns (bytes memory) {
781         return
782             functionStaticCall(
783                 target,
784                 data,
785                 "Address: low-level static call failed"
786             );
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a static call.
792      *
793      * _Available since v3.3._
794      */
795     function functionStaticCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal view returns (bytes memory) {
800         require(isContract(target), "Address: static call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.staticcall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(
813         address target,
814         bytes memory data
815     ) internal returns (bytes memory) {
816         return
817             functionDelegateCall(
818                 target,
819                 data,
820                 "Address: low-level delegate call failed"
821             );
822     }
823 
824     /**
825      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
826      * but performing a delegate call.
827      *
828      * _Available since v3.4._
829      */
830     function functionDelegateCall(
831         address target,
832         bytes memory data,
833         string memory errorMessage
834     ) internal returns (bytes memory) {
835         require(isContract(target), "Address: delegate call to non-contract");
836 
837         (bool success, bytes memory returndata) = target.delegatecall(data);
838         return verifyCallResult(success, returndata, errorMessage);
839     }
840 
841     /**
842      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
843      * revert reason using the provided one.
844      *
845      * _Available since v4.3._
846      */
847     function verifyCallResult(
848         bool success,
849         bytes memory returndata,
850         string memory errorMessage
851     ) internal pure returns (bytes memory) {
852         if (success) {
853             return returndata;
854         } else {
855             // Look for revert reason and bubble it up if present
856             if (returndata.length > 0) {
857                 // The easiest way to bubble the revert reason is using memory via assembly
858 
859                 assembly {
860                     let returndata_size := mload(returndata)
861                     revert(add(32, returndata), returndata_size)
862                 }
863             } else {
864                 revert(errorMessage);
865             }
866         }
867     }
868 }
869 
870 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
871 
872 /**
873  * @dev String operations.
874  */
875 library Strings {
876     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
877 
878     /**
879      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
880      */
881     function toString(uint256 value) internal pure returns (string memory) {
882         // Inspired by OraclizeAPI's implementation - MIT licence
883         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
884 
885         if (value == 0) {
886             return "0";
887         }
888         uint256 temp = value;
889         uint256 digits;
890         while (temp != 0) {
891             digits++;
892             temp /= 10;
893         }
894         bytes memory buffer = new bytes(digits);
895         while (value != 0) {
896             digits -= 1;
897             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
898             value /= 10;
899         }
900         return string(buffer);
901     }
902 
903     /**
904      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
905      */
906     function toHexString(uint256 value) internal pure returns (string memory) {
907         if (value == 0) {
908             return "0x00";
909         }
910         uint256 temp = value;
911         uint256 length = 0;
912         while (temp != 0) {
913             length++;
914             temp >>= 8;
915         }
916         return toHexString(value, length);
917     }
918 
919     /**
920      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
921      */
922     function toHexString(
923         uint256 value,
924         uint256 length
925     ) internal pure returns (string memory) {
926         bytes memory buffer = new bytes(2 * length + 2);
927         buffer[0] = "0";
928         buffer[1] = "x";
929         for (uint256 i = 2 * length + 1; i > 1; --i) {
930             buffer[i] = _HEX_SYMBOLS[value & 0xf];
931             value >>= 4;
932         }
933         require(value == 0, "Strings: hex length insufficient");
934         return string(buffer);
935     }
936 }
937 
938 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
939 
940 /**
941  * @title ERC721 token receiver interface
942  * @dev Interface for any contract that wants to support safeTransfers
943  * from ERC721 asset contracts.
944  */
945 interface IERC721Receiver {
946     /**
947      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
948      * by `operator` from `from`, this function is called.
949      *
950      * It must return its Solidity selector to confirm the token transfer.
951      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
952      *
953      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
954      */
955     function onERC721Received(
956         address operator,
957         address from,
958         uint256 tokenId,
959         bytes calldata data
960     ) external returns (bytes4);
961 }
962 
963 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
964 
965 /**
966  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
967  * the Metadata extension, but not including the Enumerable extension, which is available separately as
968  * {ERC721Enumerable}.
969  */
970 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
971     using Address for address;
972     using Strings for uint256;
973 
974     // Token name
975     string private _name;
976 
977     // Token symbol
978     string private _symbol;
979 
980     // Mapping from token ID to owner address
981     mapping(uint256 => address) private _owners;
982 
983     // Mapping owner address to token count
984     mapping(address => uint256) private _balances;
985 
986     // Mapping from token ID to approved address
987     mapping(uint256 => address) private _tokenApprovals;
988 
989     // Mapping from owner to operator approvals
990     mapping(address => mapping(address => bool)) private _operatorApprovals;
991 
992     /**
993      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
994      */
995     constructor(string memory name_, string memory symbol_) {
996         _name = name_;
997         _symbol = symbol_;
998     }
999 
1000     /**
1001      * @dev See {IERC165-supportsInterface}.
1002      */
1003     function supportsInterface(
1004         bytes4 interfaceId
1005     ) public view virtual override(ERC165, IERC165) returns (bool) {
1006         return
1007             interfaceId == type(IERC721).interfaceId ||
1008             interfaceId == type(IERC721Metadata).interfaceId ||
1009             super.supportsInterface(interfaceId);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-balanceOf}.
1014      */
1015     function balanceOf(
1016         address owner
1017     ) public view virtual override returns (uint256) {
1018         require(
1019             owner != address(0),
1020             "ERC721: balance query for the zero address"
1021         );
1022         return _balances[owner];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-ownerOf}.
1027      */
1028     function ownerOf(
1029         uint256 tokenId
1030     ) public view virtual override returns (address) {
1031         address owner = _owners[tokenId];
1032         require(
1033             owner != address(0),
1034             "ERC721: owner query for nonexistent token"
1035         );
1036         return owner;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Metadata-name}.
1041      */
1042     function name() public view virtual override returns (string memory) {
1043         return _name;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Metadata-symbol}.
1048      */
1049     function symbol() public view virtual override returns (string memory) {
1050         return _symbol;
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Metadata-tokenURI}.
1055      */
1056     function tokenURI(
1057         uint256 tokenId
1058     ) public view virtual override returns (string memory) {
1059         require(
1060             _exists(tokenId),
1061             "ERC721Metadata: URI query for nonexistent token"
1062         );
1063 
1064         string memory baseURI = _baseURI();
1065         return
1066             bytes(baseURI).length > 0
1067                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1068                 : "";
1069     }
1070 
1071     /**
1072      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1073      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1074      * by default, can be overridden in child contracts.
1075      */
1076     function _baseURI() internal view virtual returns (string memory) {
1077         return "";
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-approve}.
1082      */
1083     function approve(address to, uint256 tokenId) public virtual override {
1084         address owner = ERC721.ownerOf(tokenId);
1085         require(to != owner, "ERC721: approval to current owner");
1086 
1087         require(
1088             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1089             "ERC721: approve caller is not owner nor approved for all"
1090         );
1091 
1092         _approve(to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-getApproved}.
1097      */
1098     function getApproved(
1099         uint256 tokenId
1100     ) public view virtual override returns (address) {
1101         require(
1102             _exists(tokenId),
1103             "ERC721: approved query for nonexistent token"
1104         );
1105 
1106         return _tokenApprovals[tokenId];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-setApprovalForAll}.
1111      */
1112     function setApprovalForAll(
1113         address operator,
1114         bool approved
1115     ) public virtual override {
1116         _setApprovalForAll(_msgSender(), operator, approved);
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-isApprovedForAll}.
1121      */
1122     function isApprovedForAll(
1123         address owner,
1124         address operator
1125     ) public view virtual override returns (bool) {
1126         return _operatorApprovals[owner][operator];
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-transferFrom}.
1131      */
1132     function transferFrom(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) public virtual override {
1137         //solhint-disable-next-line max-line-length
1138         require(
1139             _isApprovedOrOwner(_msgSender(), tokenId),
1140             "ERC721: transfer caller is not owner nor approved"
1141         );
1142 
1143         _transfer(from, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-safeTransferFrom}.
1148      */
1149     function safeTransferFrom(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) public virtual override {
1154         safeTransferFrom(from, to, tokenId, "");
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-safeTransferFrom}.
1159      */
1160     function safeTransferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) public virtual override {
1166         require(
1167             _isApprovedOrOwner(_msgSender(), tokenId),
1168             "ERC721: transfer caller is not owner nor approved"
1169         );
1170         _safeTransfer(from, to, tokenId, _data);
1171     }
1172 
1173     /**
1174      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1175      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1176      *
1177      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1178      *
1179      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1180      * implement alternative mechanisms to perform token transfer, such as signature-based.
1181      *
1182      * Requirements:
1183      *
1184      * - `from` cannot be the zero address.
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must exist and be owned by `from`.
1187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _safeTransfer(
1192         address from,
1193         address to,
1194         uint256 tokenId,
1195         bytes memory _data
1196     ) internal virtual {
1197         _transfer(from, to, tokenId);
1198         require(
1199             _checkOnERC721Received(from, to, tokenId, _data),
1200             "ERC721: transfer to non ERC721Receiver implementer"
1201         );
1202     }
1203 
1204     /**
1205      * @dev Returns whether `tokenId` exists.
1206      *
1207      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1208      *
1209      * Tokens start existing when they are minted (`_mint`),
1210      * and stop existing when they are burned (`_burn`).
1211      */
1212     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1213         return _owners[tokenId] != address(0);
1214     }
1215 
1216     /**
1217      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      */
1223     function _isApprovedOrOwner(
1224         address spender,
1225         uint256 tokenId
1226     ) internal view virtual returns (bool) {
1227         require(
1228             _exists(tokenId),
1229             "ERC721: operator query for nonexistent token"
1230         );
1231         address owner = ERC721.ownerOf(tokenId);
1232         return (spender == owner ||
1233             isApprovedForAll(owner, spender) ||
1234             getApproved(tokenId) == spender);
1235     }
1236 
1237     /**
1238      * @dev Safely mints `tokenId` and transfers it to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must not exist.
1243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _safeMint(address to, uint256 tokenId) internal virtual {
1248         _safeMint(to, tokenId, "");
1249     }
1250 
1251     /**
1252      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1253      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1254      */
1255     function _safeMint(
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) internal virtual {
1260         _mint(to, tokenId);
1261         require(
1262             _checkOnERC721Received(address(0), to, tokenId, _data),
1263             "ERC721: transfer to non ERC721Receiver implementer"
1264         );
1265     }
1266 
1267     /**
1268      * @dev Mints `tokenId` and transfers it to `to`.
1269      *
1270      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must not exist.
1275      * - `to` cannot be the zero address.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _mint(address to, uint256 tokenId) internal virtual {
1280         require(to != address(0), "ERC721: mint to the zero address");
1281         require(!_exists(tokenId), "ERC721: token already minted");
1282 
1283         _beforeTokenTransfer(address(0), to, tokenId);
1284 
1285         _balances[to] += 1;
1286         _owners[tokenId] = to;
1287 
1288         emit Transfer(address(0), to, tokenId);
1289 
1290         _afterTokenTransfer(address(0), to, tokenId);
1291     }
1292 
1293     /**
1294      * @dev Destroys `tokenId`.
1295      * The approval is cleared when the token is burned.
1296      *
1297      * Requirements:
1298      *
1299      * - `tokenId` must exist.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _burn(uint256 tokenId) internal virtual {
1304         address owner = ERC721.ownerOf(tokenId);
1305 
1306         _beforeTokenTransfer(owner, address(0), tokenId);
1307 
1308         // Clear approvals
1309         _approve(address(0), tokenId);
1310 
1311         _balances[owner] -= 1;
1312         delete _owners[tokenId];
1313 
1314         emit Transfer(owner, address(0), tokenId);
1315 
1316         _afterTokenTransfer(owner, address(0), tokenId);
1317     }
1318 
1319     /**
1320      * @dev Transfers `tokenId` from `from` to `to`.
1321      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - `tokenId` token must be owned by `from`.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _transfer(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) internal virtual {
1335         require(
1336             ERC721.ownerOf(tokenId) == from,
1337             "ERC721: transfer from incorrect owner"
1338         );
1339         require(to != address(0), "ERC721: transfer to the zero address");
1340 
1341         _beforeTokenTransfer(from, to, tokenId);
1342 
1343         // Clear approvals from the previous owner
1344         _approve(address(0), tokenId);
1345 
1346         _balances[from] -= 1;
1347         _balances[to] += 1;
1348         _owners[tokenId] = to;
1349 
1350         emit Transfer(from, to, tokenId);
1351 
1352         _afterTokenTransfer(from, to, tokenId);
1353     }
1354 
1355     /**
1356      * @dev Approve `to` to operate on `tokenId`
1357      *
1358      * Emits a {Approval} event.
1359      */
1360     function _approve(address to, uint256 tokenId) internal virtual {
1361         _tokenApprovals[tokenId] = to;
1362         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev Approve `operator` to operate on all of `owner` tokens
1367      *
1368      * Emits a {ApprovalForAll} event.
1369      */
1370     function _setApprovalForAll(
1371         address owner,
1372         address operator,
1373         bool approved
1374     ) internal virtual {
1375         require(owner != operator, "ERC721: approve to caller");
1376         _operatorApprovals[owner][operator] = approved;
1377         emit ApprovalForAll(owner, operator, approved);
1378     }
1379 
1380     /**
1381      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1382      * The call is not executed if the target address is not a contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param _data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) private returns (bool) {
1396         if (to.isContract()) {
1397             try
1398                 IERC721Receiver(to).onERC721Received(
1399                     _msgSender(),
1400                     from,
1401                     tokenId,
1402                     _data
1403                 )
1404             returns (bytes4 retval) {
1405                 return retval == IERC721Receiver.onERC721Received.selector;
1406             } catch (bytes memory reason) {
1407                 if (reason.length == 0) {
1408                     revert(
1409                         "ERC721: transfer to non ERC721Receiver implementer"
1410                     );
1411                 } else {
1412                     assembly {
1413                         revert(add(32, reason), mload(reason))
1414                     }
1415                 }
1416             }
1417         } else {
1418             return true;
1419         }
1420     }
1421 
1422     /**
1423      * @dev Hook that is called before any token transfer. This includes minting
1424      * and burning.
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` will be minted for `to`.
1431      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1432      * - `from` and `to` are never both zero.
1433      *
1434      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1435      */
1436     function _beforeTokenTransfer(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) internal virtual {}
1441 
1442     /**
1443      * @dev Hook that is called after any transfer of tokens. This includes
1444      * minting and burning.
1445      *
1446      * Calling conditions:
1447      *
1448      * - when `from` and `to` are both non-zero.
1449      * - `from` and `to` are never both zero.
1450      *
1451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1452      */
1453     function _afterTokenTransfer(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) internal virtual {}
1458 }
1459 
1460 // ERC721A Contracts v3.3.0
1461 // Creator: Chiru Labs
1462 
1463 /**
1464  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1465  * the Metadata extension. Built to optimize for lower gas during batch mints.
1466  *
1467  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1468  *
1469  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1470  *
1471  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1472  */
1473 contract ERC721A is Context, ERC165, IERC721A {
1474     using Address for address;
1475     using Strings for uint256;
1476 
1477     // The tokenId of the next token to be minted.
1478     uint256 internal _currentIndex;
1479 
1480     // The number of tokens burned.
1481     uint256 internal _burnCounter;
1482 
1483     // Token name
1484     string private _name;
1485 
1486     // Token symbol
1487     string private _symbol;
1488 
1489     // Mapping from token ID to ownership details
1490     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1491     mapping(uint256 => TokenOwnership) internal _ownerships;
1492 
1493     // Mapping owner address to address data
1494     mapping(address => AddressData) private _addressData;
1495 
1496     // Mapping from token ID to approved address
1497     mapping(uint256 => address) private _tokenApprovals;
1498 
1499     // Mapping from owner to operator approvals
1500     mapping(address => mapping(address => bool)) private _operatorApprovals;
1501 
1502     constructor(string memory name_, string memory symbol_) {
1503         _name = name_;
1504         _symbol = symbol_;
1505         _currentIndex = _startTokenId();
1506     }
1507 
1508     /**
1509      * To change the starting tokenId, please override this function.
1510      */
1511     function _startTokenId() internal view virtual returns (uint256) {
1512         return 0;
1513     }
1514 
1515     /**
1516      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1517      */
1518     function totalSupply() public view override returns (uint256) {
1519         // Counter underflow is impossible as _burnCounter cannot be incremented
1520         // more than _currentIndex - _startTokenId() times
1521         unchecked {
1522             return _currentIndex - _burnCounter - _startTokenId();
1523         }
1524     }
1525 
1526     /**
1527      * Returns the total amount of tokens minted in the contract.
1528      */
1529     function _totalMinted() internal view returns (uint256) {
1530         // Counter underflow is impossible as _currentIndex does not decrement,
1531         // and it is initialized to _startTokenId()
1532         unchecked {
1533             return _currentIndex - _startTokenId();
1534         }
1535     }
1536 
1537     /**
1538      * @dev See {IERC165-supportsInterface}.
1539      */
1540     function supportsInterface(
1541         bytes4 interfaceId
1542     ) public view virtual override(ERC165, IERC165) returns (bool) {
1543         return
1544             interfaceId == type(IERC721).interfaceId ||
1545             interfaceId == type(IERC721Metadata).interfaceId ||
1546             super.supportsInterface(interfaceId);
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-balanceOf}.
1551      */
1552     function balanceOf(address owner) public view override returns (uint256) {
1553         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1554         return uint256(_addressData[owner].balance);
1555     }
1556 
1557     /**
1558      * Returns the number of tokens minted by `owner`.
1559      */
1560     function _numberMinted(address owner) internal view returns (uint256) {
1561         return uint256(_addressData[owner].numberMinted);
1562     }
1563 
1564     /**
1565      * Returns the number of tokens burned by or on behalf of `owner`.
1566      */
1567     function _numberBurned(address owner) internal view returns (uint256) {
1568         return uint256(_addressData[owner].numberBurned);
1569     }
1570 
1571     /**
1572      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1573      */
1574     function _getAux(address owner) internal view returns (uint64) {
1575         return _addressData[owner].aux;
1576     }
1577 
1578     /**
1579      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1580      * If there are multiple variables, please pack them into a uint64.
1581      */
1582     function _setAux(address owner, uint64 aux) internal {
1583         _addressData[owner].aux = aux;
1584     }
1585 
1586     /**
1587      * Gas spent here starts off proportional to the maximum mint batch size.
1588      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1589      */
1590     function _ownershipOf(
1591         uint256 tokenId
1592     ) internal view returns (TokenOwnership memory) {
1593         uint256 curr = tokenId;
1594 
1595         unchecked {
1596             if (_startTokenId() <= curr)
1597                 if (curr < _currentIndex) {
1598                     TokenOwnership memory ownership = _ownerships[curr];
1599                     if (!ownership.burned) {
1600                         if (ownership.addr != address(0)) {
1601                             return ownership;
1602                         }
1603                         // Invariant:
1604                         // There will always be an ownership that has an address and is not burned
1605                         // before an ownership that does not have an address and is not burned.
1606                         // Hence, curr will not underflow.
1607                         while (true) {
1608                             curr--;
1609                             ownership = _ownerships[curr];
1610                             if (ownership.addr != address(0)) {
1611                                 return ownership;
1612                             }
1613                         }
1614                     }
1615                 }
1616         }
1617         revert OwnerQueryForNonexistentToken();
1618     }
1619 
1620     /**
1621      * @dev See {IERC721-ownerOf}.
1622      */
1623     function ownerOf(uint256 tokenId) public view override returns (address) {
1624         return _ownershipOf(tokenId).addr;
1625     }
1626 
1627     /**
1628      * @dev See {IERC721Metadata-name}.
1629      */
1630     function name() public view virtual override returns (string memory) {
1631         return _name;
1632     }
1633 
1634     /**
1635      * @dev See {IERC721Metadata-symbol}.
1636      */
1637     function symbol() public view virtual override returns (string memory) {
1638         return _symbol;
1639     }
1640 
1641     /**
1642      * @dev See {IERC721Metadata-tokenURI}.
1643      */
1644     function tokenURI(
1645         uint256 tokenId
1646     ) public view virtual override returns (string memory) {
1647         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1648 
1649         string memory baseURI = _baseURI();
1650         return
1651             bytes(baseURI).length != 0
1652                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1653                 : "";
1654     }
1655 
1656     /**
1657      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1658      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1659      * by default, can be overriden in child contracts.
1660      */
1661     function _baseURI() internal view virtual returns (string memory) {
1662         return "";
1663     }
1664 
1665     /**
1666      * @dev See {IERC721-approve}.
1667      */
1668     function approve(address to, uint256 tokenId) public virtual override {
1669         address owner = ERC721A.ownerOf(tokenId);
1670         if (to == owner) revert ApprovalToCurrentOwner();
1671 
1672         if (_msgSender() != owner)
1673             if (!isApprovedForAll(owner, _msgSender())) {
1674                 revert ApprovalCallerNotOwnerNorApproved();
1675             }
1676 
1677         _approve(to, tokenId, owner);
1678     }
1679 
1680     /**
1681      * @dev See {IERC721-getApproved}.
1682      */
1683     function getApproved(
1684         uint256 tokenId
1685     ) public view override returns (address) {
1686         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1687 
1688         return _tokenApprovals[tokenId];
1689     }
1690 
1691     /**
1692      * @dev See {IERC721-setApprovalForAll}.
1693      */
1694     function setApprovalForAll(
1695         address operator,
1696         bool approved
1697     ) public virtual override {
1698         if (operator == _msgSender()) revert ApproveToCaller();
1699 
1700         _operatorApprovals[_msgSender()][operator] = approved;
1701         emit ApprovalForAll(_msgSender(), operator, approved);
1702     }
1703 
1704     /**
1705      * @dev See {IERC721-isApprovedForAll}.
1706      */
1707     function isApprovedForAll(
1708         address owner,
1709         address operator
1710     ) public view virtual override returns (bool) {
1711         return _operatorApprovals[owner][operator];
1712     }
1713 
1714     /**
1715      * @dev See {IERC721-transferFrom}.
1716      */
1717     function transferFrom(
1718         address from,
1719         address to,
1720         uint256 tokenId
1721     ) public virtual override {
1722         _transfer(from, to, tokenId);
1723     }
1724 
1725     /**
1726      * @dev See {IERC721-safeTransferFrom}.
1727      */
1728     function safeTransferFrom(
1729         address from,
1730         address to,
1731         uint256 tokenId
1732     ) public virtual override {
1733         safeTransferFrom(from, to, tokenId, "");
1734     }
1735 
1736     /**
1737      * @dev See {IERC721-safeTransferFrom}.
1738      */
1739     function safeTransferFrom(
1740         address from,
1741         address to,
1742         uint256 tokenId,
1743         bytes memory _data
1744     ) public virtual override {
1745         _transfer(from, to, tokenId);
1746         if (to.isContract())
1747             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1748                 revert TransferToNonERC721ReceiverImplementer();
1749             }
1750     }
1751 
1752     /**
1753      * @dev Returns whether `tokenId` exists.
1754      *
1755      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1756      *
1757      * Tokens start existing when they are minted (`_mint`),
1758      */
1759     function _exists(uint256 tokenId) internal view returns (bool) {
1760         return
1761             _startTokenId() <= tokenId &&
1762             tokenId < _currentIndex &&
1763             !_ownerships[tokenId].burned;
1764     }
1765 
1766     /**
1767      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1768      */
1769     function _safeMint(address to, uint256 quantity) internal {
1770         _safeMint(to, quantity, "");
1771     }
1772 
1773     /**
1774      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1775      *
1776      * Requirements:
1777      *
1778      * - If `to` refers to a smart contract, it must implement
1779      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1780      * - `quantity` must be greater than 0.
1781      *
1782      * Emits a {Transfer} event.
1783      */
1784     function _safeMint(
1785         address to,
1786         uint256 quantity,
1787         bytes memory _data
1788     ) internal {
1789         uint256 startTokenId = _currentIndex;
1790         if (to == address(0)) revert MintToZeroAddress();
1791         if (quantity == 0) revert MintZeroQuantity();
1792 
1793         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1794 
1795         // Overflows are incredibly unrealistic.
1796         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1797         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1798         unchecked {
1799             _addressData[to].balance += uint64(quantity);
1800             _addressData[to].numberMinted += uint64(quantity);
1801 
1802             _ownerships[startTokenId].addr = to;
1803             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1804 
1805             uint256 updatedIndex = startTokenId;
1806             uint256 end = updatedIndex + quantity;
1807 
1808             if (to.isContract()) {
1809                 do {
1810                     emit Transfer(address(0), to, updatedIndex);
1811                     if (
1812                         !_checkContractOnERC721Received(
1813                             address(0),
1814                             to,
1815                             updatedIndex++,
1816                             _data
1817                         )
1818                     ) {
1819                         revert TransferToNonERC721ReceiverImplementer();
1820                     }
1821                 } while (updatedIndex < end);
1822                 // Reentrancy protection
1823                 if (_currentIndex != startTokenId) revert();
1824             } else {
1825                 do {
1826                     emit Transfer(address(0), to, updatedIndex++);
1827                 } while (updatedIndex < end);
1828             }
1829             _currentIndex = updatedIndex;
1830         }
1831         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1832     }
1833 
1834     /**
1835      * @dev Mints `quantity` tokens and transfers them to `to`.
1836      *
1837      * Requirements:
1838      *
1839      * - `to` cannot be the zero address.
1840      * - `quantity` must be greater than 0.
1841      *
1842      * Emits a {Transfer} event.
1843      */
1844     function _mint(address to, uint256 quantity) internal {
1845         uint256 startTokenId = _currentIndex;
1846         if (to == address(0)) revert MintToZeroAddress();
1847         if (quantity == 0) revert MintZeroQuantity();
1848 
1849         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1850 
1851         // Overflows are incredibly unrealistic.
1852         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1853         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1854         unchecked {
1855             _addressData[to].balance += uint64(quantity);
1856             _addressData[to].numberMinted += uint64(quantity);
1857 
1858             _ownerships[startTokenId].addr = to;
1859             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1860 
1861             uint256 updatedIndex = startTokenId;
1862             uint256 end = updatedIndex + quantity;
1863 
1864             do {
1865                 emit Transfer(address(0), to, updatedIndex++);
1866             } while (updatedIndex < end);
1867 
1868             _currentIndex = updatedIndex;
1869         }
1870         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1871     }
1872 
1873     /**
1874      * @dev Transfers `tokenId` from `from` to `to`.
1875      *
1876      * Requirements:
1877      *
1878      * - `to` cannot be the zero address.
1879      * - `tokenId` token must be owned by `from`.
1880      *
1881      * Emits a {Transfer} event.
1882      */
1883     function _transfer(address from, address to, uint256 tokenId) private {
1884         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1885 
1886         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1887 
1888         bool isApprovedOrOwner = (_msgSender() == from ||
1889             isApprovedForAll(from, _msgSender()) ||
1890             getApproved(tokenId) == _msgSender());
1891 
1892         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1893         if (to == address(0)) revert TransferToZeroAddress();
1894 
1895         _beforeTokenTransfers(from, to, tokenId, 1);
1896 
1897         // Clear approvals from the previous owner
1898         _approve(address(0), tokenId, from);
1899 
1900         // Underflow of the sender's balance is impossible because we check for
1901         // ownership above and the recipient's balance can't realistically overflow.
1902         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1903         unchecked {
1904             _addressData[from].balance -= 1;
1905             _addressData[to].balance += 1;
1906 
1907             TokenOwnership storage currSlot = _ownerships[tokenId];
1908             currSlot.addr = to;
1909             currSlot.startTimestamp = uint64(block.timestamp);
1910 
1911             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1912             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1913             uint256 nextTokenId = tokenId + 1;
1914             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1915             if (nextSlot.addr == address(0)) {
1916                 // This will suffice for checking _exists(nextTokenId),
1917                 // as a burned slot cannot contain the zero address.
1918                 if (nextTokenId != _currentIndex) {
1919                     nextSlot.addr = from;
1920                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1921                 }
1922             }
1923         }
1924 
1925         emit Transfer(from, to, tokenId);
1926         _afterTokenTransfers(from, to, tokenId, 1);
1927     }
1928 
1929     /**
1930      * @dev Equivalent to `_burn(tokenId, false)`.
1931      */
1932     function _burn(uint256 tokenId) internal virtual {
1933         _burn(tokenId, false);
1934     }
1935 
1936     /**
1937      * @dev Destroys `tokenId`.
1938      * The approval is cleared when the token is burned.
1939      *
1940      * Requirements:
1941      *
1942      * - `tokenId` must exist.
1943      *
1944      * Emits a {Transfer} event.
1945      */
1946     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1947         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1948 
1949         address from = prevOwnership.addr;
1950 
1951         if (approvalCheck) {
1952             bool isApprovedOrOwner = (_msgSender() == from ||
1953                 isApprovedForAll(from, _msgSender()) ||
1954                 getApproved(tokenId) == _msgSender());
1955 
1956             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1957         }
1958 
1959         _beforeTokenTransfers(from, address(0), tokenId, 1);
1960 
1961         // Clear approvals from the previous owner
1962         _approve(address(0), tokenId, from);
1963 
1964         // Underflow of the sender's balance is impossible because we check for
1965         // ownership above and the recipient's balance can't realistically overflow.
1966         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1967         unchecked {
1968             AddressData storage addressData = _addressData[from];
1969             addressData.balance -= 1;
1970             addressData.numberBurned += 1;
1971 
1972             // Keep track of who burned the token, and the timestamp of burning.
1973             TokenOwnership storage currSlot = _ownerships[tokenId];
1974             currSlot.addr = from;
1975             currSlot.startTimestamp = uint64(block.timestamp);
1976             currSlot.burned = true;
1977 
1978             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1979             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1980             uint256 nextTokenId = tokenId + 1;
1981             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1982             if (nextSlot.addr == address(0)) {
1983                 // This will suffice for checking _exists(nextTokenId),
1984                 // as a burned slot cannot contain the zero address.
1985                 if (nextTokenId != _currentIndex) {
1986                     nextSlot.addr = from;
1987                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1988                 }
1989             }
1990         }
1991 
1992         emit Transfer(from, address(0), tokenId);
1993         _afterTokenTransfers(from, address(0), tokenId, 1);
1994 
1995         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1996         unchecked {
1997             _burnCounter++;
1998         }
1999     }
2000 
2001     /**
2002      * @dev Approve `to` to operate on `tokenId`
2003      *
2004      * Emits a {Approval} event.
2005      */
2006     function _approve(address to, uint256 tokenId, address owner) private {
2007         _tokenApprovals[tokenId] = to;
2008         emit Approval(owner, to, tokenId);
2009     }
2010 
2011     /**
2012      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2013      *
2014      * @param from address representing the previous owner of the given token ID
2015      * @param to target address that will receive the tokens
2016      * @param tokenId uint256 ID of the token to be transferred
2017      * @param _data bytes optional data to send along with the call
2018      * @return bool whether the call correctly returned the expected magic value
2019      */
2020     function _checkContractOnERC721Received(
2021         address from,
2022         address to,
2023         uint256 tokenId,
2024         bytes memory _data
2025     ) private returns (bool) {
2026         try
2027             IERC721Receiver(to).onERC721Received(
2028                 _msgSender(),
2029                 from,
2030                 tokenId,
2031                 _data
2032             )
2033         returns (bytes4 retval) {
2034             return retval == IERC721Receiver(to).onERC721Received.selector;
2035         } catch (bytes memory reason) {
2036             if (reason.length == 0) {
2037                 revert TransferToNonERC721ReceiverImplementer();
2038             } else {
2039                 assembly {
2040                     revert(add(32, reason), mload(reason))
2041                 }
2042             }
2043         }
2044     }
2045 
2046     /**
2047      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2048      * And also called before burning one token.
2049      *
2050      * startTokenId - the first token id to be transferred
2051      * quantity - the amount to be transferred
2052      *
2053      * Calling conditions:
2054      *
2055      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2056      * transferred to `to`.
2057      * - When `from` is zero, `tokenId` will be minted for `to`.
2058      * - When `to` is zero, `tokenId` will be burned by `from`.
2059      * - `from` and `to` are never both zero.
2060      */
2061     function _beforeTokenTransfers(
2062         address from,
2063         address to,
2064         uint256 startTokenId,
2065         uint256 quantity
2066     ) internal virtual {}
2067 
2068     /**
2069      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2070      * minting.
2071      * And also called after one token has been burned.
2072      *
2073      * startTokenId - the first token id to be transferred
2074      * quantity - the amount to be transferred
2075      *
2076      * Calling conditions:
2077      *
2078      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2079      * transferred to `to`.
2080      * - When `from` is zero, `tokenId` has been minted for `to`.
2081      * - When `to` is zero, `tokenId` has been burned by `from`.
2082      * - `from` and `to` are never both zero.
2083      */
2084     function _afterTokenTransfers(
2085         address from,
2086         address to,
2087         uint256 startTokenId,
2088         uint256 quantity
2089     ) internal virtual {}
2090 }
2091 
2092 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
2093 
2094 /**
2095  * @dev Interface for the NFT Royalty Standard.
2096  *
2097  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2098  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2099  *
2100  * _Available since v4.5._
2101  */
2102 interface IERC2981 is IERC165 {
2103     /**
2104      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2105      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
2106      */
2107     function royaltyInfo(
2108         uint256 tokenId,
2109         uint256 salePrice
2110     ) external view returns (address receiver, uint256 royaltyAmount);
2111 }
2112 
2113 abstract contract ERC2981 is IERC2981, ERC165 {
2114     struct RoyaltyInfo {
2115         address receiver;
2116         uint96 royaltyFraction;
2117     }
2118 
2119     RoyaltyInfo private _defaultRoyaltyInfo;
2120     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2121 
2122     /**
2123      * @dev See {IERC165-supportsInterface}.
2124      */
2125     function supportsInterface(
2126         bytes4 interfaceId
2127     ) public view virtual override(IERC165, ERC165) returns (bool) {
2128         return
2129             interfaceId == type(IERC2981).interfaceId ||
2130             super.supportsInterface(interfaceId);
2131     }
2132 
2133     /**
2134      * @inheritdoc IERC2981
2135      */
2136     function royaltyInfo(
2137         uint256 _tokenId,
2138         uint256 _salePrice
2139     ) public view virtual override returns (address, uint256) {
2140         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2141 
2142         if (royalty.receiver == address(0)) {
2143             royalty = _defaultRoyaltyInfo;
2144         }
2145 
2146         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
2147             _feeDenominator();
2148 
2149         return (royalty.receiver, royaltyAmount);
2150     }
2151 
2152     /**
2153      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2154      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2155      * override.
2156      */
2157     function _feeDenominator() internal pure virtual returns (uint96) {
2158         return 10000;
2159     }
2160 
2161     /**
2162      * @dev Sets the royalty information that all ids in this contract will default to.
2163      *
2164      * Requirements:
2165      *
2166      * - `receiver` cannot be the zero address.
2167      * - `feeNumerator` cannot be greater than the fee denominator.
2168      */
2169     function _setDefaultRoyalty(
2170         address receiver,
2171         uint96 feeNumerator
2172     ) internal virtual {
2173         require(
2174             feeNumerator <= _feeDenominator(),
2175             "ERC2981: royalty fee will exceed salePrice"
2176         );
2177         require(receiver != address(0), "ERC2981: invalid receiver");
2178 
2179         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2180     }
2181 
2182     /**
2183      * @dev Removes default royalty information.
2184      */
2185     function _deleteDefaultRoyalty() internal virtual {
2186         delete _defaultRoyaltyInfo;
2187     }
2188 
2189     /**
2190      * @dev Sets the royalty information for a specific token id, overriding the global default.
2191      *
2192      * Requirements:
2193      *
2194      * - `receiver` cannot be the zero address.
2195      * - `feeNumerator` cannot be greater than the fee denominator.
2196      */
2197     function _setTokenRoyalty(
2198         uint256 tokenId,
2199         address receiver,
2200         uint96 feeNumerator
2201     ) internal virtual {
2202         require(
2203             feeNumerator <= _feeDenominator(),
2204             "ERC2981: royalty fee will exceed salePrice"
2205         );
2206         require(receiver != address(0), "ERC2981: Invalid parameters");
2207 
2208         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2209     }
2210 
2211     /**
2212      * @dev Resets royalty information for the token id back to the global default.
2213      */
2214     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2215         delete _tokenRoyaltyInfo[tokenId];
2216     }
2217 }
2218 
2219 contract Sachiko is ERC721A, ERC2981, Ownable, DefaultOperatorFilterer {
2220     string public baseURI = "https://art.getrik.com/c3291783/sachiko/";
2221 
2222     uint256 public tokenPrice = 2000000000000000; //0.005 ETH
2223 
2224     uint256 public maxTokensPerTx = 20;
2225 
2226     uint256 public defaultTokensPerTx = 2;
2227 
2228     uint256 public MAX_TOKENS = 5000;
2229 
2230     // bool public saleIsActive = true;
2231 
2232     uint256 public whitelistMintRemains = 1000;
2233 
2234     // = 0 if there are no free tokens
2235     // = maxTokensPerTx if free all
2236     uint256 public maxTokensFreePerTx = 2;
2237 
2238     enum TokenURIMode {
2239         MODE_ONE,
2240         MODE_TWO
2241     }
2242 
2243     TokenURIMode private tokenUriMode = TokenURIMode.MODE_ONE;
2244 
2245     constructor() ERC721A("Sachiko", "SC") {
2246         // 500 = RoyaltyFee
2247         _setDefaultRoyalty(msg.sender, 500);
2248     }
2249 
2250     struct HelperState {
2251         uint256 tokenPrice;
2252         uint256 maxTokensPerTx;
2253         uint256 MAX_TOKENS;
2254         bool saleIsActive;
2255         uint256 totalSupply;
2256         uint256 maxTokensFreePerTx;
2257         uint256 userMinted;
2258         uint256 defaultTokensPerTx;
2259     }
2260 
2261     function _state(address minter) external view returns (HelperState memory) {
2262         return
2263             HelperState({
2264                 tokenPrice: tokenPrice,
2265                 maxTokensPerTx: maxTokensPerTx,
2266                 MAX_TOKENS: MAX_TOKENS,
2267                 saleIsActive: true, //saleIsActive,
2268                 totalSupply: uint256(totalSupply()),
2269                 maxTokensFreePerTx: maxTokensFreePerTx,
2270                 userMinted: uint256(_numberMinted(minter)),
2271                 defaultTokensPerTx: defaultTokensPerTx
2272             });
2273     }
2274 
2275     function withdraw() public onlyOwner {
2276         uint256 balance = address(this).balance;
2277         payable(msg.sender).transfer(balance);
2278     }
2279 
2280     // function withdrawTo(address to, uint256 amount) public onlyOwner {
2281     //     require(
2282     //         amount <= address(this).balance,
2283     //         "Exceed balance of this contract"
2284     //     );
2285     //     payable(to).transfer(amount);
2286     // }
2287 
2288     function reserveTokens(
2289         address to,
2290         uint256 numberOfTokens
2291     ) public onlyOwner {
2292         require(
2293             totalSupply() + numberOfTokens <= MAX_TOKENS,
2294             "Exceed max supply of tokens"
2295         );
2296         _safeMint(to, numberOfTokens);
2297     }
2298 
2299     function setBaseURI(string memory newURI) public onlyOwner {
2300         baseURI = newURI;
2301     }
2302 
2303     // function flipSaleState() public onlyOwner {
2304     //     saleIsActive = !saleIsActive;
2305     // }
2306 
2307     function openWhitelistMint(uint256 _whitelistMintRemains) public onlyOwner {
2308         whitelistMintRemains = _whitelistMintRemains;
2309         // saleIsActive = true;
2310     }
2311 
2312     function closeWhitelistMint() public onlyOwner {
2313         whitelistMintRemains = 0;
2314     }
2315 
2316     function getPrice(
2317         uint256 numberOfTokens,
2318         address minter
2319     ) public view returns (uint256) {
2320         if (numberMinted(minter) > 0) {
2321             return numberOfTokens * tokenPrice;
2322         } else if (numberOfTokens > maxTokensFreePerTx) {
2323             return (numberOfTokens - maxTokensFreePerTx) * tokenPrice;
2324         }
2325         return 0;
2326     }
2327 
2328     // if numberMinted(msg.sender) > 0 -> no whitelist, no free.
2329     function mintToken(uint256 numberOfTokens) public payable {
2330         // require(saleIsActive, "Sale must be active");
2331         require(numberOfTokens <= maxTokensPerTx, "Exceed max tokens per tx");
2332         require(numberOfTokens > 0, "Must mint at least one");
2333         require(
2334             totalSupply() + numberOfTokens <= MAX_TOKENS,
2335             "Exceed max supply"
2336         );
2337 
2338         if (whitelistMintRemains > 0 && numberMinted(msg.sender) <= 0) {
2339             if (numberOfTokens >= whitelistMintRemains) {
2340                 numberOfTokens = whitelistMintRemains;
2341             }
2342             _safeMint(msg.sender, numberOfTokens);
2343             whitelistMintRemains = whitelistMintRemains - numberOfTokens;
2344         } else {
2345             if (_numberMinted(msg.sender) > 0) {
2346                 require(
2347                     msg.value >= numberOfTokens * tokenPrice,
2348                     "Not enough ether"
2349                 );
2350             } else if (numberOfTokens > maxTokensFreePerTx) {
2351                 require(
2352                     msg.value >=
2353                         (numberOfTokens - maxTokensFreePerTx) * tokenPrice,
2354                     "Not enough ether"
2355                 );
2356             }
2357             _safeMint(msg.sender, numberOfTokens);
2358         }
2359     }
2360 
2361     function setTokenPrice(uint256 newTokenPrice) public onlyOwner {
2362         tokenPrice = newTokenPrice;
2363     }
2364 
2365     function tokenURI(
2366         uint256 _tokenId
2367     ) public view override returns (string memory) {
2368         require(_exists(_tokenId), "Token does not exist.");
2369         if (tokenUriMode == TokenURIMode.MODE_TWO) {
2370             return
2371                 bytes(baseURI).length > 0
2372                     ? string(
2373                         abi.encodePacked(baseURI, Strings.toString(_tokenId))
2374                     )
2375                     : "";
2376         } else {
2377             return
2378                 bytes(baseURI).length > 0
2379                     ? string(
2380                         abi.encodePacked(
2381                             baseURI,
2382                             Strings.toString(_tokenId),
2383                             ".json"
2384                         )
2385                     )
2386                     : "";
2387         }
2388     }
2389 
2390     function setTokenURIMode(uint256 mode) external onlyOwner {
2391         if (mode == 2) {
2392             tokenUriMode = TokenURIMode.MODE_TWO;
2393         } else {
2394             tokenUriMode = TokenURIMode.MODE_ONE;
2395         }
2396     }
2397 
2398     function _baseURI() internal view virtual override returns (string memory) {
2399         return baseURI;
2400     }
2401 
2402     function numberMinted(address owner) public view returns (uint256) {
2403         return _numberMinted(owner);
2404     }
2405 
2406     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2407         MAX_TOKENS = _maxSupply;
2408     }
2409 
2410     function setMaxTokensPerTx(uint256 _maxTokensPerTx) public onlyOwner {
2411         maxTokensPerTx = _maxTokensPerTx;
2412     }
2413 
2414     function setMaxTokensFreePerTx(
2415         uint256 _maxTokensFreePerTx
2416     ) public onlyOwner {
2417         maxTokensFreePerTx = _maxTokensFreePerTx;
2418     }
2419 
2420     function setDefaultTokensPerTx(
2421         uint256 _defaultTokensPerTx
2422     ) public onlyOwner {
2423         defaultTokensPerTx = _defaultTokensPerTx;
2424     }
2425 
2426     function supportsInterface(
2427         bytes4 interfaceId
2428     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
2429         return super.supportsInterface(interfaceId);
2430     }
2431 
2432     function setRoyaltyInfo(
2433         address receiver,
2434         uint96 feeBasisPoints
2435     ) external onlyOwner {
2436         _setDefaultRoyalty(receiver, feeBasisPoints);
2437     }
2438 
2439     function setApprovalForAll(
2440         address operator,
2441         bool approved
2442     ) public override onlyAllowedOperatorApproval(operator) {
2443         super.setApprovalForAll(operator, approved);
2444     }
2445 
2446     function approve(
2447         address operator,
2448         uint256 tokenId
2449     ) public override onlyAllowedOperatorApproval(operator) {
2450         super.approve(operator, tokenId);
2451     }
2452 
2453     function transferFrom(
2454         address from,
2455         address to,
2456         uint256 tokenId
2457     ) public override onlyAllowedOperator(from) {
2458         super.transferFrom(from, to, tokenId);
2459     }
2460 
2461     function safeTransferFrom(
2462         address from,
2463         address to,
2464         uint256 tokenId
2465     ) public override onlyAllowedOperator(from) {
2466         super.safeTransferFrom(from, to, tokenId);
2467     }
2468 
2469     function safeTransferFrom(
2470         address from,
2471         address to,
2472         uint256 tokenId,
2473         bytes memory data
2474     ) public override onlyAllowedOperator(from) {
2475         super.safeTransferFrom(from, to, tokenId, data);
2476     }
2477 }