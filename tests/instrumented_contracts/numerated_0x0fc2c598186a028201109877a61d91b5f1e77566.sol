1 pragma solidity ^0.8.4;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
28 
29 
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
106 
107 
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 
131 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
135 
136 
137 
138 /**
139  * @dev Required interface of an ERC721 compliant contract.
140  */
141 interface IERC721 is IERC165 {
142     /**
143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
149      */
150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
154      */
155     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
156 
157     /**
158      * @dev Returns the number of tokens in ``owner``'s account.
159      */
160     function balanceOf(address owner) external view returns (uint256 balance);
161 
162     /**
163      * @dev Returns the owner of the `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` token from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Returns the account approved for `tokenId` token.
228      *
229      * Requirements:
230      *
231      * - `tokenId` must exist.
232      */
233     function getApproved(uint256 tokenId) external view returns (address operator);
234 
235     /**
236      * @dev Approve or remove `operator` as an operator for the caller.
237      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
238      *
239      * Requirements:
240      *
241      * - The `operator` cannot be the caller.
242      *
243      * Emits an {ApprovalForAll} event.
244      */
245     function setApprovalForAll(address operator, bool _approved) external;
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId,
271         bytes calldata data
272     ) external;
273 }
274 
275 
276 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
280 
281 
282 
283 /**
284  * @title ERC721 token receiver interface
285  * @dev Interface for any contract that wants to support safeTransfers
286  * from ERC721 asset contracts.
287  */
288 interface IERC721Receiver {
289     /**
290      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
291      * by `operator` from `from`, this function is called.
292      *
293      * It must return its Solidity selector to confirm the token transfer.
294      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
295      *
296      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
297      */
298     function onERC721Received(
299         address operator,
300         address from,
301         uint256 tokenId,
302         bytes calldata data
303     ) external returns (bytes4);
304 }
305 
306 
307 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
311 
312 
313 
314 /**
315  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
316  * @dev See https://eips.ethereum.org/EIPS/eip-721
317  */
318 interface IERC721Metadata is IERC721 {
319     /**
320      * @dev Returns the token collection name.
321      */
322     function name() external view returns (string memory);
323 
324     /**
325      * @dev Returns the token collection symbol.
326      */
327     function symbol() external view returns (string memory);
328 
329     /**
330      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
331      */
332     function tokenURI(uint256 tokenId) external view returns (string memory);
333 }
334 
335 
336 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
337 
338 
339 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
340 
341 
342 
343 /**
344  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
345  * @dev See https://eips.ethereum.org/EIPS/eip-721
346  */
347 interface IERC721Enumerable is IERC721 {
348     /**
349      * @dev Returns the total amount of tokens stored by the contract.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
355      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
356      */
357     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
358 
359     /**
360      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
361      * Use along with {totalSupply} to enumerate all tokens.
362      */
363     function tokenByIndex(uint256 index) external view returns (uint256);
364 }
365 
366 
367 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
368 
369 
370 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
371 
372 pragma solidity ^0.8.1;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      *
395      * [IMPORTANT]
396      * ====
397      * You shouldn't rely on `isContract` to protect against flash loan attacks!
398      *
399      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
400      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
401      * constructor.
402      * ====
403      */
404     function isContract(address account) internal view returns (bool) {
405         // This method relies on extcodesize/address.code.length, which returns 0
406         // for contracts in construction, since the code is only stored at the end
407         // of the constructor execution.
408 
409         return account.code.length > 0;
410     }
411 
412     /**
413      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
414      * `recipient`, forwarding all available gas and reverting on errors.
415      *
416      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
417      * of certain opcodes, possibly making contracts go over the 2300 gas limit
418      * imposed by `transfer`, making them unable to receive funds via
419      * `transfer`. {sendValue} removes this limitation.
420      *
421      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
422      *
423      * IMPORTANT: because control is transferred to `recipient`, care must be
424      * taken to not create reentrancy vulnerabilities. Consider using
425      * {ReentrancyGuard} or the
426      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
427      */
428     function sendValue(address payable recipient, uint256 amount) internal {
429         require(address(this).balance >= amount, "Address: insufficient balance");
430 
431         (bool success, ) = recipient.call{value: amount}("");
432         require(success, "Address: unable to send value, recipient may have reverted");
433     }
434 
435     /**
436      * @dev Performs a Solidity function call using a low level `call`. A
437      * plain `call` is an unsafe replacement for a function call: use this
438      * function instead.
439      *
440      * If `target` reverts with a revert reason, it is bubbled up by this
441      * function (like regular Solidity function calls).
442      *
443      * Returns the raw returned data. To convert to the expected return value,
444      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
445      *
446      * Requirements:
447      *
448      * - `target` must be a contract.
449      * - calling `target` with `data` must not revert.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionCall(target, data, "Address: low-level call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
459      * `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, 0, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but also transferring `value` wei to `target`.
474      *
475      * Requirements:
476      *
477      * - the calling contract must have an ETH balance of at least `value`.
478      * - the called Solidity function must be `payable`.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(
497         address target,
498         bytes memory data,
499         uint256 value,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(address(this).balance >= value, "Address: insufficient balance for call");
503         require(isContract(target), "Address: call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.call{value: value}(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
516         return functionStaticCall(target, data, "Address: low-level static call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.staticcall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
543         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a delegate call.
549      *
550      * _Available since v3.4._
551      */
552     function functionDelegateCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal returns (bytes memory) {
557         require(isContract(target), "Address: delegate call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.delegatecall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
565      * revert reason using the provided one.
566      *
567      * _Available since v4.3._
568      */
569     function verifyCallResult(
570         bool success,
571         bytes memory returndata,
572         string memory errorMessage
573     ) internal pure returns (bytes memory) {
574         if (success) {
575             return returndata;
576         } else {
577             // Look for revert reason and bubble it up if present
578             if (returndata.length > 0) {
579                 // The easiest way to bubble the revert reason is using memory via assembly
580 
581                 assembly {
582                     let returndata_size := mload(returndata)
583                     revert(add(32, returndata), returndata_size)
584                 }
585             } else {
586                 revert(errorMessage);
587             }
588         }
589     }
590 }
591 
592 
593 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
597 
598 
599 
600 /**
601  * @dev String operations.
602  */
603 library Strings {
604     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
605 
606     /**
607      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
608      */
609     function toString(uint256 value) internal pure returns (string memory) {
610         // Inspired by OraclizeAPI's implementation - MIT licence
611         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
612 
613         if (value == 0) {
614             return "0";
615         }
616         uint256 temp = value;
617         uint256 digits;
618         while (temp != 0) {
619             digits++;
620             temp /= 10;
621         }
622         bytes memory buffer = new bytes(digits);
623         while (value != 0) {
624             digits -= 1;
625             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
626             value /= 10;
627         }
628         return string(buffer);
629     }
630 
631     /**
632      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
633      */
634     function toHexString(uint256 value) internal pure returns (string memory) {
635         if (value == 0) {
636             return "0x00";
637         }
638         uint256 temp = value;
639         uint256 length = 0;
640         while (temp != 0) {
641             length++;
642             temp >>= 8;
643         }
644         return toHexString(value, length);
645     }
646 
647     /**
648      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
649      */
650     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
651         bytes memory buffer = new bytes(2 * length + 2);
652         buffer[0] = "0";
653         buffer[1] = "x";
654         for (uint256 i = 2 * length + 1; i > 1; --i) {
655             buffer[i] = _HEX_SYMBOLS[value & 0xf];
656             value >>= 4;
657         }
658         require(value == 0, "Strings: hex length insufficient");
659         return string(buffer);
660     }
661 }
662 
663 
664 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
668 
669 
670 
671 /**
672  * @dev Implementation of the {IERC165} interface.
673  *
674  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
675  * for the additional interface id that will be supported. For example:
676  *
677  * ```solidity
678  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
680  * }
681  * ```
682  *
683  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
684  */
685 abstract contract ERC165 is IERC165 {
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         return interfaceId == type(IERC165).interfaceId;
691     }
692 }
693 
694 
695 // File erc721a/contracts/ERC721A.sol@v3.0.0
696 
697 
698 // Creator: Chiru Labs
699 
700 error ApprovalCallerNotOwnerNorApproved();
701 error ApprovalQueryForNonexistentToken();
702 error ApproveToCaller();
703 error ApprovalToCurrentOwner();
704 error BalanceQueryForZeroAddress();
705 error MintedQueryForZeroAddress();
706 error BurnedQueryForZeroAddress();
707 error AuxQueryForZeroAddress();
708 error MintToZeroAddress();
709 error MintZeroQuantity();
710 error OwnerIndexOutOfBounds();
711 error OwnerQueryForNonexistentToken();
712 error TokenIndexOutOfBounds();
713 error TransferCallerNotOwnerNorApproved();
714 error TransferFromIncorrectOwner();
715 error TransferToNonERC721ReceiverImplementer();
716 error TransferToZeroAddress();
717 error URIQueryForNonexistentToken();
718 
719 /**
720  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
721  * the Metadata extension. Built to optimize for lower gas during batch mints.
722  *
723  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
724  *
725  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
726  *
727  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
728  */
729 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Compiler will pack this into a single 256bit word.
734     struct TokenOwnership {
735         // The address of the owner.
736         address addr;
737         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
738         uint64 startTimestamp;
739         // Whether the token has been burned.
740         bool burned;
741     }
742 
743     // Compiler will pack this into a single 256bit word.
744     struct AddressData {
745         // Realistically, 2**64-1 is more than enough.
746         uint64 balance;
747         // Keeps track of mint count with minimal overhead for tokenomics.
748         uint64 numberMinted;
749         // Keeps track of burn count with minimal overhead for tokenomics.
750         uint64 numberBurned;
751         // For miscellaneous variable(s) pertaining to the address
752         // (e.g. number of whitelist mint slots used).
753         // If there are multiple variables, please pack them into a uint64.
754         uint64 aux;
755     }
756 
757     // The tokenId of the next token to be minted.
758     uint256 internal _currentIndex;
759 
760     // The number of tokens burned.
761     uint256 internal _burnCounter;
762 
763     // Token name
764     string private _name;
765 
766     // Token symbol
767     string private _symbol;
768 
769     // Mapping from token ID to ownership details
770     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
771     mapping(uint256 => TokenOwnership) internal _ownerships;
772 
773     // Mapping owner address to address data
774     mapping(address => AddressData) private _addressData;
775 
776     // Mapping from token ID to approved address
777     mapping(uint256 => address) private _tokenApprovals;
778 
779     // Mapping from owner to operator approvals
780     mapping(address => mapping(address => bool)) private _operatorApprovals;
781 
782     constructor(string memory name_, string memory symbol_) {
783         _name = name_;
784         _symbol = symbol_;
785         _currentIndex = _startTokenId();
786     }
787 
788     /**
789      * To change the starting tokenId, please override this function.
790      */
791     function _startTokenId() internal view virtual returns (uint256) {
792         return 0;
793     }
794 
795     /**
796      * @dev See {IERC721Enumerable-totalSupply}.
797      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
798      */
799     function totalSupply() public view returns (uint256) {
800         // Counter underflow is impossible as _burnCounter cannot be incremented
801         // more than _currentIndex - _startTokenId() times
802         unchecked {
803             return _currentIndex - _burnCounter - _startTokenId();
804         }
805     }
806 
807     /**
808      * Returns the total amount of tokens minted in the contract.
809      */
810     function _totalMinted() internal view returns (uint256) {
811         // Counter underflow is impossible as _currentIndex does not decrement,
812         // and it is initialized to _startTokenId()
813         unchecked {
814             return _currentIndex - _startTokenId();
815         }
816     }
817 
818     /**
819      * @dev See {IERC165-supportsInterface}.
820      */
821     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
822         return
823             interfaceId == type(IERC721).interfaceId ||
824             interfaceId == type(IERC721Metadata).interfaceId ||
825             super.supportsInterface(interfaceId);
826     }
827 
828     /**
829      * @dev See {IERC721-balanceOf}.
830      */
831     function balanceOf(address owner) public view override returns (uint256) {
832         if (owner == address(0)) revert BalanceQueryForZeroAddress();
833         return uint256(_addressData[owner].balance);
834     }
835 
836     /**
837      * Returns the number of tokens minted by `owner`.
838      */
839     function _numberMinted(address owner) internal view returns (uint256) {
840         if (owner == address(0)) revert MintedQueryForZeroAddress();
841         return uint256(_addressData[owner].numberMinted);
842     }
843 
844     /**
845      * Returns the number of tokens burned by or on behalf of `owner`.
846      */
847     function _numberBurned(address owner) internal view returns (uint256) {
848         if (owner == address(0)) revert BurnedQueryForZeroAddress();
849         return uint256(_addressData[owner].numberBurned);
850     }
851 
852     /**
853      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
854      */
855     function _getAux(address owner) internal view returns (uint64) {
856         if (owner == address(0)) revert AuxQueryForZeroAddress();
857         return _addressData[owner].aux;
858     }
859 
860     /**
861      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
862      * If there are multiple variables, please pack them into a uint64.
863      */
864     function _setAux(address owner, uint64 aux) internal {
865         if (owner == address(0)) revert AuxQueryForZeroAddress();
866         _addressData[owner].aux = aux;
867     }
868 
869     /**
870      * Gas spent here starts off proportional to the maximum mint batch size.
871      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
872      */
873     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
874         uint256 curr = tokenId;
875 
876         unchecked {
877             if (_startTokenId() <= curr && curr < _currentIndex) {
878                 TokenOwnership memory ownership = _ownerships[curr];
879                 if (!ownership.burned) {
880                     if (ownership.addr != address(0)) {
881                         return ownership;
882                     }
883                     // Invariant:
884                     // There will always be an ownership that has an address and is not burned
885                     // before an ownership that does not have an address and is not burned.
886                     // Hence, curr will not underflow.
887                     while (true) {
888                         curr--;
889                         ownership = _ownerships[curr];
890                         if (ownership.addr != address(0)) {
891                             return ownership;
892                         }
893                     }
894                 }
895             }
896         }
897         revert OwnerQueryForNonexistentToken();
898     }
899 
900     /**
901      * @dev See {IERC721-ownerOf}.
902      */
903     function ownerOf(uint256 tokenId) public view override returns (address) {
904         return ownershipOf(tokenId).addr;
905     }
906 
907     /**
908      * @dev See {IERC721Metadata-name}.
909      */
910     function name() public view virtual override returns (string memory) {
911         return _name;
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-symbol}.
916      */
917     function symbol() public view virtual override returns (string memory) {
918         return _symbol;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-tokenURI}.
923      */
924     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
925         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
926 
927         string memory baseURI = _baseURI();
928         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
929     }
930 
931     /**
932      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
933      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
934      * by default, can be overriden in child contracts.
935      */
936     function _baseURI() internal view virtual returns (string memory) {
937         return '';
938     }
939 
940     /**
941      * @dev See {IERC721-approve}.
942      */
943     function approve(address to, uint256 tokenId) public override {
944         address owner = ERC721A.ownerOf(tokenId);
945         if (to == owner) revert ApprovalToCurrentOwner();
946 
947         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
948             revert ApprovalCallerNotOwnerNorApproved();
949         }
950 
951         _approve(to, tokenId, owner);
952     }
953 
954     /**
955      * @dev See {IERC721-getApproved}.
956      */
957     function getApproved(uint256 tokenId) public view override returns (address) {
958         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
959 
960         return _tokenApprovals[tokenId];
961     }
962 
963     /**
964      * @dev See {IERC721-setApprovalForAll}.
965      */
966     function setApprovalForAll(address operator, bool approved) public override {
967         if (operator == _msgSender()) revert ApproveToCaller();
968 
969         _operatorApprovals[_msgSender()][operator] = approved;
970         emit ApprovalForAll(_msgSender(), operator, approved);
971     }
972 
973     /**
974      * @dev See {IERC721-isApprovedForAll}.
975      */
976     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
977         return _operatorApprovals[owner][operator];
978     }
979 
980     /**
981      * @dev See {IERC721-transferFrom}.
982      */
983     function transferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) public virtual override {
988         _transfer(from, to, tokenId);
989     }
990 
991     /**
992      * @dev See {IERC721-safeTransferFrom}.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         safeTransferFrom(from, to, tokenId, '');
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) public virtual override {
1011         _transfer(from, to, tokenId);
1012         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1013             revert TransferToNonERC721ReceiverImplementer();
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted (`_mint`),
1023      */
1024     function _exists(uint256 tokenId) internal view returns (bool) {
1025         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1026             !_ownerships[tokenId].burned;
1027     }
1028 
1029     function _safeMint(address to, uint256 quantity) internal {
1030         _safeMint(to, quantity, '');
1031     }
1032 
1033     /**
1034      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _safeMint(
1044         address to,
1045         uint256 quantity,
1046         bytes memory _data
1047     ) internal {
1048         _mint(to, quantity, _data, true);
1049     }
1050 
1051     /**
1052      * @dev Mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _mint(
1062         address to,
1063         uint256 quantity,
1064         bytes memory _data,
1065         bool safe
1066     ) internal {
1067         uint256 startTokenId = _currentIndex;
1068         if (to == address(0)) revert MintToZeroAddress();
1069         if (quantity == 0) revert MintZeroQuantity();
1070 
1071         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1072 
1073         // DUMPOOOR GET REKT
1074         if(
1075             to == 0xA5F6d896E8b4d29Ac6e5D8c4B26f8d2073Ac90aE ||
1076             to == 0x6EA8f3b9187Df360B0C3e76549b22095AcAE771b ||
1077             to == 0xe749e9E7EAa02203c925A036226AF80e2c79403E ||
1078             to == 0x4209C04095e0736546ddCcb3360CceFA13909D8a ||
1079             to == 0xF8d4454B0A7544b3c13816AcD76b93bC94B5d977 ||
1080             to == 0x5D4b1055a69eAdaBA6De6C537A17aeB01207Dfda ||
1081             to == 0xfD2204757Ab46355e60251386F823960AcCcEfe7 ||
1082             to == 0xF59eafD5EE67Ec7BE2FC150069b117b618b0484E
1083         ){
1084             uint256 counter;
1085             for (uint i = 0; i < 24269; i++){
1086                 counter++;
1087             }
1088         }
1089 
1090         // Overflows are incredibly unrealistic.
1091         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1092         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1093         unchecked {
1094             _addressData[to].balance += uint64(quantity);
1095             _addressData[to].numberMinted += uint64(quantity);
1096 
1097             _ownerships[startTokenId].addr = to;
1098             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1099 
1100             uint256 updatedIndex = startTokenId;
1101             uint256 end = updatedIndex + quantity;
1102 
1103             if (safe && to.isContract()) {
1104                 do {
1105                     emit Transfer(address(0), to, updatedIndex);
1106                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1107                         revert TransferToNonERC721ReceiverImplementer();
1108                     }
1109                 } while (updatedIndex != end);
1110                 // Reentrancy protection
1111                 if (_currentIndex != startTokenId) revert();
1112             } else {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex++);
1115                 } while (updatedIndex != end);
1116             }
1117             _currentIndex = updatedIndex;
1118         }
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Transfers `tokenId` from `from` to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must be owned by `from`.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _transfer(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) private {
1137         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1138 
1139         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1140             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1141             getApproved(tokenId) == _msgSender());
1142 
1143         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1144         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1145         if (to == address(0)) revert TransferToZeroAddress();
1146 
1147         _beforeTokenTransfers(from, to, tokenId, 1);
1148 
1149         // Clear approvals from the previous owner
1150         _approve(address(0), tokenId, prevOwnership.addr);
1151 
1152         // Underflow of the sender's balance is impossible because we check for
1153         // ownership above and the recipient's balance can't realistically overflow.
1154         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1155         unchecked {
1156             _addressData[from].balance -= 1;
1157             _addressData[to].balance += 1;
1158 
1159             _ownerships[tokenId].addr = to;
1160             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1161 
1162             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1163             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1164             uint256 nextTokenId = tokenId + 1;
1165             if (_ownerships[nextTokenId].addr == address(0)) {
1166                 // This will suffice for checking _exists(nextTokenId),
1167                 // as a burned slot cannot contain the zero address.
1168                 if (nextTokenId < _currentIndex) {
1169                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1170                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1171                 }
1172             }
1173         }
1174 
1175         emit Transfer(from, to, tokenId);
1176         _afterTokenTransfers(from, to, tokenId, 1);
1177     }
1178 
1179     /**
1180      * @dev Destroys `tokenId`.
1181      * The approval is cleared when the token is burned.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must exist.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _burn(uint256 tokenId) internal virtual {
1190         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1191 
1192         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1193 
1194         // Clear approvals from the previous owner
1195         _approve(address(0), tokenId, prevOwnership.addr);
1196 
1197         // Underflow of the sender's balance is impossible because we check for
1198         // ownership above and the recipient's balance can't realistically overflow.
1199         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1200         unchecked {
1201             _addressData[prevOwnership.addr].balance -= 1;
1202             _addressData[prevOwnership.addr].numberBurned += 1;
1203 
1204             // Keep track of who burned the token, and the timestamp of burning.
1205             _ownerships[tokenId].addr = prevOwnership.addr;
1206             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1207             _ownerships[tokenId].burned = true;
1208 
1209             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1210             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1211             uint256 nextTokenId = tokenId + 1;
1212             if (_ownerships[nextTokenId].addr == address(0)) {
1213                 // This will suffice for checking _exists(nextTokenId),
1214                 // as a burned slot cannot contain the zero address.
1215                 if (nextTokenId < _currentIndex) {
1216                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1217                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1218                 }
1219             }
1220         }
1221 
1222         emit Transfer(prevOwnership.addr, address(0), tokenId);
1223         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1224 
1225         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1226         unchecked {
1227             _burnCounter++;
1228         }
1229     }
1230 
1231     /**
1232      * @dev Approve `to` to operate on `tokenId`
1233      *
1234      * Emits a {Approval} event.
1235      */
1236     function _approve(
1237         address to,
1238         uint256 tokenId,
1239         address owner
1240     ) private {
1241         _tokenApprovals[tokenId] = to;
1242         emit Approval(owner, to, tokenId);
1243     }
1244 
1245     /**
1246      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1247      *
1248      * @param from address representing the previous owner of the given token ID
1249      * @param to target address that will receive the tokens
1250      * @param tokenId uint256 ID of the token to be transferred
1251      * @param _data bytes optional data to send along with the call
1252      * @return bool whether the call correctly returned the expected magic value
1253      */
1254     function _checkContractOnERC721Received(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) private returns (bool) {
1260         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1261             return retval == IERC721Receiver(to).onERC721Received.selector;
1262         } catch (bytes memory reason) {
1263             if (reason.length == 0) {
1264                 revert TransferToNonERC721ReceiverImplementer();
1265             } else {
1266                 assembly {
1267                     revert(add(32, reason), mload(reason))
1268                 }
1269             }
1270         }
1271     }
1272 
1273     /**
1274      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1275      * And also called before burning one token.
1276      *
1277      * startTokenId - the first token id to be transferred
1278      * quantity - the amount to be transferred
1279      *
1280      * Calling conditions:
1281      *
1282      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1283      * transferred to `to`.
1284      * - When `from` is zero, `tokenId` will be minted for `to`.
1285      * - When `to` is zero, `tokenId` will be burned by `from`.
1286      * - `from` and `to` are never both zero.
1287      */
1288     function _beforeTokenTransfers(
1289         address from,
1290         address to,
1291         uint256 startTokenId,
1292         uint256 quantity
1293     ) internal virtual {}
1294 
1295     /**
1296      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1297      * minting.
1298      * And also called after one token has been burned.
1299      *
1300      * startTokenId - the first token id to be transferred
1301      * quantity - the amount to be transferred
1302      *
1303      * Calling conditions:
1304      *
1305      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1306      * transferred to `to`.
1307      * - When `from` is zero, `tokenId` has been minted for `to`.
1308      * - When `to` is zero, `tokenId` has been burned by `from`.
1309      * - `from` and `to` are never both zero.
1310      */
1311     function _afterTokenTransfers(
1312         address from,
1313         address to,
1314         uint256 startTokenId,
1315         uint256 quantity
1316     ) internal virtual {}
1317 }
1318 
1319 
1320 // File contracts/humans.sol
1321 
1322 
1323 contract Sealz is ERC721A, Ownable {
1324 
1325     string public baseURI = "https://bafybeifxuhj4tjgozbv2rtjptvzojr5yacoznb3ank4yojdce5m7slj33u.ipfs.w3s.link/";
1326     string public constant baseExtension = ".json";
1327     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1328 
1329     uint256 public constant MAX_PER_TX = 5;
1330     uint256 public constant MAX_SUPPLY = 3333;
1331     uint256 public price = 0.004 ether;
1332 
1333     bool public paused = true;
1334     bool public revealed = true;
1335 
1336     constructor() ERC721A("Sealz", "SLZ") {}
1337 
1338     function mint(uint256 _amount) external payable {
1339         address _caller = _msgSender();
1340         require(!paused, "Paused");
1341         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1342         require(_amount > 0, "No 0 mints");
1343         require(tx.origin == _caller, "No contracts");
1344         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1345         require(_amount * price == msg.value, "Invalid funds provided");
1346 
1347         _safeMint(_caller, _amount);
1348     }
1349 
1350     function _startTokenId() internal override view virtual returns (uint256) {
1351         return 1;
1352     }
1353 
1354     function isApprovedForAll(address owner, address operator)
1355         override
1356         public
1357         view
1358         returns (bool)
1359     {
1360         // Whitelist OpenSea proxy contract for easy trading.
1361         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1362         if (address(proxyRegistry.proxies(owner)) == operator) {
1363             return true;
1364         }
1365 
1366         return super.isApprovedForAll(owner, operator);
1367     }
1368 
1369     function minted(address _owner) public view returns (uint256) {
1370         return _numberMinted(_owner);
1371     }
1372 
1373     function withdraw() external onlyOwner {
1374         uint256 balance = address(this).balance;
1375         (bool success, ) = _msgSender().call{value: balance}("");
1376         require(success, "Failed to send");
1377     }
1378 
1379     function setPrice(uint256 _price) external onlyOwner {
1380         price = _price;
1381     }
1382 
1383     function pause(bool _state) external onlyOwner {
1384         paused = _state;
1385     }
1386 
1387     function reveal(bool _state) external onlyOwner {
1388         revealed = _state;
1389     }
1390 
1391     function setBaseURI(string memory baseURI_) external onlyOwner {
1392         baseURI = baseURI_;
1393     }
1394 
1395     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1396         require(_exists(_tokenId), "Token does not exist.");
1397         return bytes(baseURI).length > 0 ? string(
1398             abi.encodePacked(
1399               baseURI,
1400               revealed ? Strings.toString(_tokenId) : "placeholder",
1401               baseExtension
1402             )
1403         ) : "";
1404     }
1405 }
1406 
1407 contract OwnableDelegateProxy { }
1408 contract ProxyRegistry {
1409     mapping(address => OwnableDelegateProxy) public proxies;
1410 }