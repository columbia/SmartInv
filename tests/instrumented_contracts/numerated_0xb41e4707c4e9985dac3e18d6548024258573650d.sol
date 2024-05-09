1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity 0.8.10;
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Interface of the ERC165 standard, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-165[EIP].
31  *
32  * Implementers can declare support of contract interfaces, which can then be
33  * queried by others ({ERC165Checker}).
34  *
35  * For an implementation, see {ERC165}.
36  */
37 interface IERC165 {
38     /**
39      * @dev Returns true if this contract implements the interface defined by
40      * `interfaceId`. See the corresponding
41      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
42      * to learn more about how these ids are created.
43      *
44      * This function call must use less than 30 000 gas.
45      */
46     function supportsInterface(bytes4 interfaceId) external view returns (bool);
47 }
48 
49 
50 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
51 
52 /**
53  * @dev Required interface of an ERC721 compliant contract.
54  */
55 interface IERC721 is IERC165 {
56     /**
57      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
58      */
59     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
63      */
64     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
68      */
69     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
70 
71     /**
72      * @dev Returns the number of tokens in ``owner``'s account.
73      */
74     function balanceOf(address owner) external view returns (uint256 balance);
75 
76     /**
77      * @dev Returns the owner of the `tokenId` token.
78      *
79      * Requirements:
80      *
81      * - `tokenId` must exist.
82      */
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 tokenId,
102         bytes calldata data
103     ) external;
104 
105     /**
106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must exist and be owned by `from`.
114      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
116      *
117      * Emits a {Transfer} event.
118      */
119     function safeTransferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Transfers `tokenId` token from `from` to `to`.
127      *
128      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must be owned by `from`.
135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) external;
144 
145     /**
146      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
147      * The approval is cleared when the token is transferred.
148      *
149      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
150      *
151      * Requirements:
152      *
153      * - The caller must own the token or be an approved operator.
154      * - `tokenId` must exist.
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address to, uint256 tokenId) external;
159 
160     /**
161      * @dev Approve or remove `operator` as an operator for the caller.
162      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
163      *
164      * Requirements:
165      *
166      * - The `operator` cannot be the caller.
167      *
168      * Emits an {ApprovalForAll} event.
169      */
170     function setApprovalForAll(address operator, bool _approved) external;
171 
172     /**
173      * @dev Returns the account approved for `tokenId` token.
174      *
175      * Requirements:
176      *
177      * - `tokenId` must exist.
178      */
179     function getApproved(uint256 tokenId) external view returns (address operator);
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator) external view returns (bool);
187 }
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 
212 // ERC721A Contracts v3.3.0
213 // Creator: Chiru Labs
214 
215 /**
216  * @dev Interface of an ERC721A compliant contract.
217  */
218 interface IERC721A is IERC721, IERC721Metadata {
219     /**
220      * The caller must own the token or be an approved operator.
221      */
222     error ApprovalCallerNotOwnerNorApproved();
223 
224     /**
225      * The token does not exist.
226      */
227     error ApprovalQueryForNonexistentToken();
228 
229     /**
230      * The caller cannot approve to their own address.
231      */
232     error ApproveToCaller();
233 
234     /**
235      * The caller cannot approve to the current owner.
236      */
237     error ApprovalToCurrentOwner();
238 
239     /**
240      * Cannot query the balance for the zero address.
241      */
242     error BalanceQueryForZeroAddress();
243 
244     /**
245      * Cannot mint to the zero address.
246      */
247     error MintToZeroAddress();
248 
249     /**
250      * The quantity of tokens minted must be more than zero.
251      */
252     error MintZeroQuantity();
253 
254     /**
255      * The token does not exist.
256      */
257     error OwnerQueryForNonexistentToken();
258 
259     /**
260      * The caller must own the token or be an approved operator.
261      */
262     error TransferCallerNotOwnerNorApproved();
263 
264     /**
265      * The token must be owned by `from`.
266      */
267     error TransferFromIncorrectOwner();
268 
269     /**
270      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
271      */
272     error TransferToNonERC721ReceiverImplementer();
273 
274     /**
275      * Cannot transfer to the zero address.
276      */
277     error TransferToZeroAddress();
278 
279     /**
280      * The token does not exist.
281      */
282     error URIQueryForNonexistentToken();
283 
284     // Compiler will pack this into a single 256bit word.
285     struct TokenOwnership {
286         // The address of the owner.
287         address addr;
288         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
289         uint64 startTimestamp;
290         // Whether the token has been burned.
291         bool burned;
292     }
293 
294     // Compiler will pack this into a single 256bit word.
295     struct AddressData {
296         // Realistically, 2**64-1 is more than enough.
297         uint64 balance;
298         // Keeps track of mint count with minimal overhead for tokenomics.
299         uint64 numberMinted;
300         // Keeps track of burn count with minimal overhead for tokenomics.
301         uint64 numberBurned;
302         // For miscellaneous variable(s) pertaining to the address
303         // (e.g. number of whitelist mint slots used).
304         // If there are multiple variables, please pack them into a uint64.
305         uint64 aux;
306     }
307 
308     /**
309      * @dev Returns the total amount of tokens stored by the contract.
310      * 
311      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
312      */
313     function totalSupply() external view returns (uint256);
314 }
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
318 
319 /**
320  * @dev Implementation of the {IERC165} interface.
321  *
322  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
323  * for the additional interface id that will be supported. For example:
324  *
325  * ```solidity
326  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
328  * }
329  * ```
330  *
331  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
332  */
333 abstract contract ERC165 is IERC165 {
334     /**
335      * @dev See {IERC165-supportsInterface}.
336      */
337     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
338         return interfaceId == type(IERC165).interfaceId;
339     }
340 }
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
344 
345 /**
346  * @dev Contract module which provides a basic access control mechanism, where
347  * there is an account (an owner) that can be granted exclusive access to
348  * specific functions.
349  *
350  * By default, the owner account will be the one that deploys the contract. This
351  * can later be changed with {transferOwnership}.
352  *
353  * This module is used through inheritance. It will make available the modifier
354  * `onlyOwner`, which can be applied to your functions to restrict their use to
355  * the owner.
356  */
357 abstract contract Ownable is Context {
358     address private _owner;
359 
360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
361 
362     /**
363      * @dev Initializes the contract setting the deployer as the initial owner.
364      */
365     constructor() {
366         _transferOwnership(_msgSender());
367     }
368 
369     /**
370      * @dev Returns the address of the current owner.
371      */
372     function owner() public view virtual returns (address) {
373         return _owner;
374     }
375 
376     /**
377      * @dev Throws if called by any account other than the owner.
378      */
379     modifier onlyOwner() {
380         require(owner() == _msgSender(), "Ownable: caller is not the owner");
381         _;
382     }
383 
384     /**
385      * @dev Leaves the contract without owner. It will not be possible to call
386      * `onlyOwner` functions anymore. Can only be called by the current owner.
387      *
388      * NOTE: Renouncing ownership will leave the contract without an owner,
389      * thereby removing any functionality that is only available to the owner.
390      */
391     function renounceOwnership() public virtual onlyOwner {
392         _transferOwnership(address(0));
393     }
394 
395     /**
396      * @dev Transfers ownership of the contract to a new account (`newOwner`).
397      * Can only be called by the current owner.
398      */
399     function transferOwnership(address newOwner) public virtual onlyOwner {
400         require(newOwner != address(0), "Ownable: new owner is the zero address");
401         _transferOwnership(newOwner);
402     }
403 
404     /**
405      * @dev Transfers ownership of the contract to a new account (`newOwner`).
406      * Internal function without access restriction.
407      */
408     function _transferOwnership(address newOwner) internal virtual {
409         address oldOwner = _owner;
410         _owner = newOwner;
411         emit OwnershipTransferred(oldOwner, newOwner);
412     }
413 }
414 
415 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      *
438      * [IMPORTANT]
439      * ====
440      * You shouldn't rely on `isContract` to protect against flash loan attacks!
441      *
442      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
443      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
444      * constructor.
445      * ====
446      */
447     function isContract(address account) internal view returns (bool) {
448         // This method relies on extcodesize/address.code.length, which returns 0
449         // for contracts in construction, since the code is only stored at the end
450         // of the constructor execution.
451 
452         return account.code.length > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
608      * revert reason using the provided one.
609      *
610      * _Available since v4.3._
611      */
612     function verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) internal pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
637 
638 /**
639  * @dev String operations.
640  */
641 library Strings {
642     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
646      */
647     function toString(uint256 value) internal pure returns (string memory) {
648         // Inspired by OraclizeAPI's implementation - MIT licence
649         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
650 
651         if (value == 0) {
652             return "0";
653         }
654         uint256 temp = value;
655         uint256 digits;
656         while (temp != 0) {
657             digits++;
658             temp /= 10;
659         }
660         bytes memory buffer = new bytes(digits);
661         while (value != 0) {
662             digits -= 1;
663             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
664             value /= 10;
665         }
666         return string(buffer);
667     }
668 
669     /**
670      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
671      */
672     function toHexString(uint256 value) internal pure returns (string memory) {
673         if (value == 0) {
674             return "0x00";
675         }
676         uint256 temp = value;
677         uint256 length = 0;
678         while (temp != 0) {
679             length++;
680             temp >>= 8;
681         }
682         return toHexString(value, length);
683     }
684 
685     /**
686      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
687      */
688     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
689         bytes memory buffer = new bytes(2 * length + 2);
690         buffer[0] = "0";
691         buffer[1] = "x";
692         for (uint256 i = 2 * length + 1; i > 1; --i) {
693             buffer[i] = _HEX_SYMBOLS[value & 0xf];
694             value >>= 4;
695         }
696         require(value == 0, "Strings: hex length insufficient");
697         return string(buffer);
698     }
699 }
700 
701 
702 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
703 
704 /**
705  * @title ERC721 token receiver interface
706  * @dev Interface for any contract that wants to support safeTransfers
707  * from ERC721 asset contracts.
708  */
709 interface IERC721Receiver {
710     /**
711      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
712      * by `operator` from `from`, this function is called.
713      *
714      * It must return its Solidity selector to confirm the token transfer.
715      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
716      *
717      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
718      */
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 
728 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension, but not including the Enumerable extension, which is available separately as
733  * {ERC721Enumerable}.
734  */
735 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to owner address
746     mapping(uint256 => address) private _owners;
747 
748     // Mapping owner address to token count
749     mapping(address => uint256) private _balances;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     /**
758      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
759      */
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
769         return
770             interfaceId == type(IERC721).interfaceId ||
771             interfaceId == type(IERC721Metadata).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view virtual override returns (uint256) {
779         require(owner != address(0), "ERC721: balance query for the zero address");
780         return _balances[owner];
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
787         address owner = _owners[tokenId];
788         require(owner != address(0), "ERC721: owner query for nonexistent token");
789         return owner;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-name}.
794      */
795     function name() public view virtual override returns (string memory) {
796         return _name;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-symbol}.
801      */
802     function symbol() public view virtual override returns (string memory) {
803         return _symbol;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-tokenURI}.
808      */
809     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
810         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
811 
812         string memory baseURI = _baseURI();
813         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overridden in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return "";
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721: approve caller is not owner nor approved for all"
835         );
836 
837         _approve(to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-getApproved}.
842      */
843     function getApproved(uint256 tokenId) public view virtual override returns (address) {
844         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
845 
846         return _tokenApprovals[tokenId];
847     }
848 
849     /**
850      * @dev See {IERC721-setApprovalForAll}.
851      */
852     function setApprovalForAll(address operator, bool approved) public virtual override {
853         _setApprovalForAll(_msgSender(), operator, approved);
854     }
855 
856     /**
857      * @dev See {IERC721-isApprovedForAll}.
858      */
859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
860         return _operatorApprovals[owner][operator];
861     }
862 
863     /**
864      * @dev See {IERC721-transferFrom}.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         //solhint-disable-next-line max-line-length
872         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
873 
874         _transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         safeTransferFrom(from, to, tokenId, "");
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) public virtual override {
897         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
898         _safeTransfer(from, to, tokenId, _data);
899     }
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
903      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
904      *
905      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
906      *
907      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
908      * implement alternative mechanisms to perform token transfer, such as signature-based.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeTransfer(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) internal virtual {
925         _transfer(from, to, tokenId);
926         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are minted (`_mint`),
935      * and stop existing when they are burned (`_burn`).
936      */
937     function _exists(uint256 tokenId) internal view virtual returns (bool) {
938         return _owners[tokenId] != address(0);
939     }
940 
941     /**
942      * @dev Returns whether `spender` is allowed to manage `tokenId`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
949         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
950         address owner = ERC721.ownerOf(tokenId);
951         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
952     }
953 
954     /**
955      * @dev Safely mints `tokenId` and transfers it to `to`.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must not exist.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeMint(address to, uint256 tokenId) internal virtual {
965         _safeMint(to, tokenId, "");
966     }
967 
968     /**
969      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
970      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
971      */
972     function _safeMint(
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) internal virtual {
977         _mint(to, tokenId);
978         require(
979             _checkOnERC721Received(address(0), to, tokenId, _data),
980             "ERC721: transfer to non ERC721Receiver implementer"
981         );
982     }
983 
984     /**
985      * @dev Mints `tokenId` and transfers it to `to`.
986      *
987      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
988      *
989      * Requirements:
990      *
991      * - `tokenId` must not exist.
992      * - `to` cannot be the zero address.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _mint(address to, uint256 tokenId) internal virtual {
997         require(to != address(0), "ERC721: mint to the zero address");
998         require(!_exists(tokenId), "ERC721: token already minted");
999 
1000         _beforeTokenTransfer(address(0), to, tokenId);
1001 
1002         _balances[to] += 1;
1003         _owners[tokenId] = to;
1004 
1005         emit Transfer(address(0), to, tokenId);
1006 
1007         _afterTokenTransfer(address(0), to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev Destroys `tokenId`.
1012      * The approval is cleared when the token is burned.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _burn(uint256 tokenId) internal virtual {
1021         address owner = ERC721.ownerOf(tokenId);
1022 
1023         _beforeTokenTransfer(owner, address(0), tokenId);
1024 
1025         // Clear approvals
1026         _approve(address(0), tokenId);
1027 
1028         _balances[owner] -= 1;
1029         delete _owners[tokenId];
1030 
1031         emit Transfer(owner, address(0), tokenId);
1032 
1033         _afterTokenTransfer(owner, address(0), tokenId);
1034     }
1035 
1036     /**
1037      * @dev Transfers `tokenId` from `from` to `to`.
1038      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) internal virtual {
1052         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1053         require(to != address(0), "ERC721: transfer to the zero address");
1054 
1055         _beforeTokenTransfer(from, to, tokenId);
1056 
1057         // Clear approvals from the previous owner
1058         _approve(address(0), tokenId);
1059 
1060         _balances[from] -= 1;
1061         _balances[to] += 1;
1062         _owners[tokenId] = to;
1063 
1064         emit Transfer(from, to, tokenId);
1065 
1066         _afterTokenTransfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Approve `to` to operate on `tokenId`
1071      *
1072      * Emits a {Approval} event.
1073      */
1074     function _approve(address to, uint256 tokenId) internal virtual {
1075         _tokenApprovals[tokenId] = to;
1076         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `operator` to operate on all of `owner` tokens
1081      *
1082      * Emits a {ApprovalForAll} event.
1083      */
1084     function _setApprovalForAll(
1085         address owner,
1086         address operator,
1087         bool approved
1088     ) internal virtual {
1089         require(owner != operator, "ERC721: approve to caller");
1090         _operatorApprovals[owner][operator] = approved;
1091         emit ApprovalForAll(owner, operator, approved);
1092     }
1093 
1094     /**
1095      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1096      * The call is not executed if the target address is not a contract.
1097      *
1098      * @param from address representing the previous owner of the given token ID
1099      * @param to target address that will receive the tokens
1100      * @param tokenId uint256 ID of the token to be transferred
1101      * @param _data bytes optional data to send along with the call
1102      * @return bool whether the call correctly returned the expected magic value
1103      */
1104     function _checkOnERC721Received(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) private returns (bool) {
1110         if (to.isContract()) {
1111             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1112                 return retval == IERC721Receiver.onERC721Received.selector;
1113             } catch (bytes memory reason) {
1114                 if (reason.length == 0) {
1115                     revert("ERC721: transfer to non ERC721Receiver implementer");
1116                 } else {
1117                     assembly {
1118                         revert(add(32, reason), mload(reason))
1119                     }
1120                 }
1121             }
1122         } else {
1123             return true;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any token transfer. This includes minting
1129      * and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1134      * transferred to `to`.
1135      * - When `from` is zero, `tokenId` will be minted for `to`.
1136      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1137      * - `from` and `to` are never both zero.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after any transfer of tokens. This includes
1149      * minting and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - when `from` and `to` are both non-zero.
1154      * - `from` and `to` are never both zero.
1155      *
1156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1157      */
1158     function _afterTokenTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) internal virtual {}
1163 }
1164 
1165 
1166 // ERC721A Contracts v3.3.0
1167 // Creator: Chiru Labs
1168 
1169 /**
1170  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1171  * the Metadata extension. Built to optimize for lower gas during batch mints.
1172  *
1173  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1174  *
1175  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1176  *
1177  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1178  */
1179 contract ERC721A is Context, ERC165, IERC721A {
1180     using Address for address;
1181     using Strings for uint256;
1182 
1183     // The tokenId of the next token to be minted.
1184     uint256 internal _currentIndex;
1185 
1186     // The number of tokens burned.
1187     uint256 internal _burnCounter;
1188 
1189     // Token name
1190     string private _name;
1191 
1192     // Token symbol
1193     string private _symbol;
1194 
1195     // Mapping from token ID to ownership details
1196     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1197     mapping(uint256 => TokenOwnership) internal _ownerships;
1198 
1199     // Mapping owner address to address data
1200     mapping(address => AddressData) private _addressData;
1201 
1202     // Mapping from token ID to approved address
1203     mapping(uint256 => address) private _tokenApprovals;
1204 
1205     // Mapping from owner to operator approvals
1206     mapping(address => mapping(address => bool)) private _operatorApprovals;
1207 
1208     constructor(string memory name_, string memory symbol_) {
1209         _name = name_;
1210         _symbol = symbol_;
1211         _currentIndex = _startTokenId();
1212     }
1213 
1214     /**
1215      * To change the starting tokenId, please override this function.
1216      */
1217     function _startTokenId() internal view virtual returns (uint256) {
1218         return 0;
1219     }
1220 
1221     /**
1222      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1223      */
1224     function totalSupply() public view override returns (uint256) {
1225         // Counter underflow is impossible as _burnCounter cannot be incremented
1226         // more than _currentIndex - _startTokenId() times
1227         unchecked {
1228             return _currentIndex - _burnCounter - _startTokenId();
1229         }
1230     }
1231 
1232     /**
1233      * Returns the total amount of tokens minted in the contract.
1234      */
1235     function _totalMinted() internal view returns (uint256) {
1236         // Counter underflow is impossible as _currentIndex does not decrement,
1237         // and it is initialized to _startTokenId()
1238         unchecked {
1239             return _currentIndex - _startTokenId();
1240         }
1241     }
1242 
1243     /**
1244      * @dev See {IERC165-supportsInterface}.
1245      */
1246     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1247         return
1248             interfaceId == type(IERC721).interfaceId ||
1249             interfaceId == type(IERC721Metadata).interfaceId ||
1250             super.supportsInterface(interfaceId);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-balanceOf}.
1255      */
1256     function balanceOf(address owner) public view override returns (uint256) {
1257         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1258         return uint256(_addressData[owner].balance);
1259     }
1260 
1261     /**
1262      * Returns the number of tokens minted by `owner`.
1263      */
1264     function _numberMinted(address owner) internal view returns (uint256) {
1265         return uint256(_addressData[owner].numberMinted);
1266     }
1267 
1268     /**
1269      * Returns the number of tokens burned by or on behalf of `owner`.
1270      */
1271     function _numberBurned(address owner) internal view returns (uint256) {
1272         return uint256(_addressData[owner].numberBurned);
1273     }
1274 
1275     /**
1276      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1277      */
1278     function _getAux(address owner) internal view returns (uint64) {
1279         return _addressData[owner].aux;
1280     }
1281 
1282     /**
1283      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1284      * If there are multiple variables, please pack them into a uint64.
1285      */
1286     function _setAux(address owner, uint64 aux) internal {
1287         _addressData[owner].aux = aux;
1288     }
1289 
1290     /**
1291      * Gas spent here starts off proportional to the maximum mint batch size.
1292      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1293      */
1294     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1295         uint256 curr = tokenId;
1296 
1297         unchecked {
1298             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1299                 TokenOwnership memory ownership = _ownerships[curr];
1300                 if (!ownership.burned) {
1301                     if (ownership.addr != address(0)) {
1302                         return ownership;
1303                     }
1304                     // Invariant:
1305                     // There will always be an ownership that has an address and is not burned
1306                     // before an ownership that does not have an address and is not burned.
1307                     // Hence, curr will not underflow.
1308                     while (true) {
1309                         curr--;
1310                         ownership = _ownerships[curr];
1311                         if (ownership.addr != address(0)) {
1312                             return ownership;
1313                         }
1314                     }
1315                 }
1316             }
1317         }
1318         revert OwnerQueryForNonexistentToken();
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-ownerOf}.
1323      */
1324     function ownerOf(uint256 tokenId) public view override returns (address) {
1325         return _ownershipOf(tokenId).addr;
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Metadata-name}.
1330      */
1331     function name() public view virtual override returns (string memory) {
1332         return _name;
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Metadata-symbol}.
1337      */
1338     function symbol() public view virtual override returns (string memory) {
1339         return _symbol;
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Metadata-tokenURI}.
1344      */
1345     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1346         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1347 
1348         string memory baseURI = _baseURI();
1349         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1350     }
1351 
1352     /**
1353      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1354      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1355      * by default, can be overriden in child contracts.
1356      */
1357     function _baseURI() internal view virtual returns (string memory) {
1358         return '';
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-approve}.
1363      */
1364     function approve(address to, uint256 tokenId) public override {
1365         address owner = ERC721A.ownerOf(tokenId);
1366         if (to == owner) revert ApprovalToCurrentOwner();
1367 
1368         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1369             revert ApprovalCallerNotOwnerNorApproved();
1370         }
1371 
1372         _approve(to, tokenId, owner);
1373     }
1374 
1375     /**
1376      * @dev See {IERC721-getApproved}.
1377      */
1378     function getApproved(uint256 tokenId) public view override returns (address) {
1379         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1380 
1381         return _tokenApprovals[tokenId];
1382     }
1383 
1384     /**
1385      * @dev See {IERC721-setApprovalForAll}.
1386      */
1387     function setApprovalForAll(address operator, bool approved) public virtual override {
1388         if (operator == _msgSender()) revert ApproveToCaller();
1389 
1390         _operatorApprovals[_msgSender()][operator] = approved;
1391         emit ApprovalForAll(_msgSender(), operator, approved);
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-isApprovedForAll}.
1396      */
1397     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1398         return _operatorApprovals[owner][operator];
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-transferFrom}.
1403      */
1404     function transferFrom(
1405         address from,
1406         address to,
1407         uint256 tokenId
1408     ) public virtual override {
1409         _transfer(from, to, tokenId);
1410     }
1411 
1412     /**
1413      * @dev See {IERC721-safeTransferFrom}.
1414      */
1415     function safeTransferFrom(
1416         address from,
1417         address to,
1418         uint256 tokenId
1419     ) public virtual override {
1420         safeTransferFrom(from, to, tokenId, '');
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-safeTransferFrom}.
1425      */
1426     function safeTransferFrom(
1427         address from,
1428         address to,
1429         uint256 tokenId,
1430         bytes memory _data
1431     ) public virtual override {
1432         _transfer(from, to, tokenId);
1433         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1434             revert TransferToNonERC721ReceiverImplementer();
1435         }
1436     }
1437 
1438     /**
1439      * @dev Returns whether `tokenId` exists.
1440      *
1441      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1442      *
1443      * Tokens start existing when they are minted (`_mint`),
1444      */
1445     function _exists(uint256 tokenId) internal view returns (bool) {
1446         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1447     }
1448 
1449     /**
1450      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1451      */
1452     function _safeMint(address to, uint256 quantity) internal {
1453         _safeMint(to, quantity, '');
1454     }
1455 
1456     /**
1457      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1458      *
1459      * Requirements:
1460      *
1461      * - If `to` refers to a smart contract, it must implement
1462      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1463      * - `quantity` must be greater than 0.
1464      *
1465      * Emits a {Transfer} event.
1466      */
1467     function _safeMint(
1468         address to,
1469         uint256 quantity,
1470         bytes memory _data
1471     ) internal {
1472         uint256 startTokenId = _currentIndex;
1473         if (to == address(0)) revert MintToZeroAddress();
1474         if (quantity == 0) revert MintZeroQuantity();
1475 
1476         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1477 
1478         // Overflows are incredibly unrealistic.
1479         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1480         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1481         unchecked {
1482             _addressData[to].balance += uint64(quantity);
1483             _addressData[to].numberMinted += uint64(quantity);
1484 
1485             _ownerships[startTokenId].addr = to;
1486             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1487 
1488             uint256 updatedIndex = startTokenId;
1489             uint256 end = updatedIndex + quantity;
1490 
1491             if (to.isContract()) {
1492                 do {
1493                     emit Transfer(address(0), to, updatedIndex);
1494                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1495                         revert TransferToNonERC721ReceiverImplementer();
1496                     }
1497                 } while (updatedIndex < end);
1498                 // Reentrancy protection
1499                 if (_currentIndex != startTokenId) revert();
1500             } else {
1501                 do {
1502                     emit Transfer(address(0), to, updatedIndex++);
1503                 } while (updatedIndex < end);
1504             }
1505             _currentIndex = updatedIndex;
1506         }
1507         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1508     }
1509 
1510     /**
1511      * @dev Mints `quantity` tokens and transfers them to `to`.
1512      *
1513      * Requirements:
1514      *
1515      * - `to` cannot be the zero address.
1516      * - `quantity` must be greater than 0.
1517      *
1518      * Emits a {Transfer} event.
1519      */
1520     function _mint(address to, uint256 quantity) internal {
1521         uint256 startTokenId = _currentIndex;
1522         if (to == address(0)) revert MintToZeroAddress();
1523         if (quantity == 0) revert MintZeroQuantity();
1524 
1525         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1526 
1527         // Overflows are incredibly unrealistic.
1528         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1529         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1530         unchecked {
1531             _addressData[to].balance += uint64(quantity);
1532             _addressData[to].numberMinted += uint64(quantity);
1533 
1534             _ownerships[startTokenId].addr = to;
1535             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1536 
1537             uint256 updatedIndex = startTokenId;
1538             uint256 end = updatedIndex + quantity;
1539 
1540             do {
1541                 emit Transfer(address(0), to, updatedIndex++);
1542             } while (updatedIndex < end);
1543 
1544             _currentIndex = updatedIndex;
1545         }
1546         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1547     }
1548 
1549     /**
1550      * @dev Transfers `tokenId` from `from` to `to`.
1551      *
1552      * Requirements:
1553      *
1554      * - `to` cannot be the zero address.
1555      * - `tokenId` token must be owned by `from`.
1556      *
1557      * Emits a {Transfer} event.
1558      */
1559     function _transfer(
1560         address from,
1561         address to,
1562         uint256 tokenId
1563     ) private {
1564         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1565 
1566         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1567 
1568         bool isApprovedOrOwner = (_msgSender() == from ||
1569             isApprovedForAll(from, _msgSender()) ||
1570             getApproved(tokenId) == _msgSender());
1571 
1572         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1573         if (to == address(0)) revert TransferToZeroAddress();
1574 
1575         _beforeTokenTransfers(from, to, tokenId, 1);
1576 
1577         // Clear approvals from the previous owner
1578         _approve(address(0), tokenId, from);
1579 
1580         // Underflow of the sender's balance is impossible because we check for
1581         // ownership above and the recipient's balance can't realistically overflow.
1582         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1583         unchecked {
1584             _addressData[from].balance -= 1;
1585             _addressData[to].balance += 1;
1586 
1587             TokenOwnership storage currSlot = _ownerships[tokenId];
1588             currSlot.addr = to;
1589             currSlot.startTimestamp = uint64(block.timestamp);
1590 
1591             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1592             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1593             uint256 nextTokenId = tokenId + 1;
1594             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1595             if (nextSlot.addr == address(0)) {
1596                 // This will suffice for checking _exists(nextTokenId),
1597                 // as a burned slot cannot contain the zero address.
1598                 if (nextTokenId != _currentIndex) {
1599                     nextSlot.addr = from;
1600                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1601                 }
1602             }
1603         }
1604 
1605         emit Transfer(from, to, tokenId);
1606         _afterTokenTransfers(from, to, tokenId, 1);
1607     }
1608 
1609     /**
1610      * @dev Equivalent to `_burn(tokenId, false)`.
1611      */
1612     function _burn(uint256 tokenId) internal virtual {
1613         _burn(tokenId, false);
1614     }
1615 
1616     /**
1617      * @dev Destroys `tokenId`.
1618      * The approval is cleared when the token is burned.
1619      *
1620      * Requirements:
1621      *
1622      * - `tokenId` must exist.
1623      *
1624      * Emits a {Transfer} event.
1625      */
1626     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1627         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1628 
1629         address from = prevOwnership.addr;
1630 
1631         if (approvalCheck) {
1632             bool isApprovedOrOwner = (_msgSender() == from ||
1633                 isApprovedForAll(from, _msgSender()) ||
1634                 getApproved(tokenId) == _msgSender());
1635 
1636             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1637         }
1638 
1639         _beforeTokenTransfers(from, address(0), tokenId, 1);
1640 
1641         // Clear approvals from the previous owner
1642         _approve(address(0), tokenId, from);
1643 
1644         // Underflow of the sender's balance is impossible because we check for
1645         // ownership above and the recipient's balance can't realistically overflow.
1646         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1647         unchecked {
1648             AddressData storage addressData = _addressData[from];
1649             addressData.balance -= 1;
1650             addressData.numberBurned += 1;
1651 
1652             // Keep track of who burned the token, and the timestamp of burning.
1653             TokenOwnership storage currSlot = _ownerships[tokenId];
1654             currSlot.addr = from;
1655             currSlot.startTimestamp = uint64(block.timestamp);
1656             currSlot.burned = true;
1657 
1658             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1659             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1660             uint256 nextTokenId = tokenId + 1;
1661             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1662             if (nextSlot.addr == address(0)) {
1663                 // This will suffice for checking _exists(nextTokenId),
1664                 // as a burned slot cannot contain the zero address.
1665                 if (nextTokenId != _currentIndex) {
1666                     nextSlot.addr = from;
1667                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1668                 }
1669             }
1670         }
1671 
1672         emit Transfer(from, address(0), tokenId);
1673         _afterTokenTransfers(from, address(0), tokenId, 1);
1674 
1675         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1676         unchecked {
1677             _burnCounter++;
1678         }
1679     }
1680 
1681     /**
1682      * @dev Approve `to` to operate on `tokenId`
1683      *
1684      * Emits a {Approval} event.
1685      */
1686     function _approve(
1687         address to,
1688         uint256 tokenId,
1689         address owner
1690     ) private {
1691         _tokenApprovals[tokenId] = to;
1692         emit Approval(owner, to, tokenId);
1693     }
1694 
1695     /**
1696      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1697      *
1698      * @param from address representing the previous owner of the given token ID
1699      * @param to target address that will receive the tokens
1700      * @param tokenId uint256 ID of the token to be transferred
1701      * @param _data bytes optional data to send along with the call
1702      * @return bool whether the call correctly returned the expected magic value
1703      */
1704     function _checkContractOnERC721Received(
1705         address from,
1706         address to,
1707         uint256 tokenId,
1708         bytes memory _data
1709     ) private returns (bool) {
1710         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1711             return retval == IERC721Receiver(to).onERC721Received.selector;
1712         } catch (bytes memory reason) {
1713             if (reason.length == 0) {
1714                 revert TransferToNonERC721ReceiverImplementer();
1715             } else {
1716                 assembly {
1717                     revert(add(32, reason), mload(reason))
1718                 }
1719             }
1720         }
1721     }
1722 
1723     /**
1724      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1725      * And also called before burning one token.
1726      *
1727      * startTokenId - the first token id to be transferred
1728      * quantity - the amount to be transferred
1729      *
1730      * Calling conditions:
1731      *
1732      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1733      * transferred to `to`.
1734      * - When `from` is zero, `tokenId` will be minted for `to`.
1735      * - When `to` is zero, `tokenId` will be burned by `from`.
1736      * - `from` and `to` are never both zero.
1737      */
1738     function _beforeTokenTransfers(
1739         address from,
1740         address to,
1741         uint256 startTokenId,
1742         uint256 quantity
1743     ) internal virtual {}
1744 
1745     /**
1746      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1747      * minting.
1748      * And also called after one token has been burned.
1749      *
1750      * startTokenId - the first token id to be transferred
1751      * quantity - the amount to be transferred
1752      *
1753      * Calling conditions:
1754      *
1755      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1756      * transferred to `to`.
1757      * - When `from` is zero, `tokenId` has been minted for `to`.
1758      * - When `to` is zero, `tokenId` has been burned by `from`.
1759      * - `from` and `to` are never both zero.
1760      */
1761     function _afterTokenTransfers(
1762         address from,
1763         address to,
1764         uint256 startTokenId,
1765         uint256 quantity
1766     ) internal virtual {}
1767 }
1768 
1769 /**
1770  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1771  * checks.
1772  *
1773  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1774  * in bugs, because programmers usually assume that an overflow raises an
1775  * error, which is the standard behavior in high level programming languages.
1776  * `SafeMath` restores this intuition by reverting the transaction when an
1777  * operation overflows.
1778  *
1779  * Using this library instead of the unchecked operations eliminates an entire
1780  * class of bugs, so it's recommended to use it always.
1781  */
1782 library SafeMath {
1783     /**
1784      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1785      *
1786      * _Available since v3.4._
1787      */
1788     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1789         uint256 c = a + b;
1790         if (c < a) return (false, 0);
1791         return (true, c);
1792     }
1793 
1794     /**
1795      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1796      *
1797      * _Available since v3.4._
1798      */
1799     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1800         if (b > a) return (false, 0);
1801         return (true, a - b);
1802     }
1803 
1804     /**
1805      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1806      *
1807      * _Available since v3.4._
1808      */
1809     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1810         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1811         // benefit is lost if 'b' is also tested.
1812         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1813         if (a == 0) return (true, 0);
1814         uint256 c = a * b;
1815         if (c / a != b) return (false, 0);
1816         return (true, c);
1817     }
1818 
1819     /**
1820      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1821      *
1822      * _Available since v3.4._
1823      */
1824     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1825         if (b == 0) return (false, 0);
1826         return (true, a / b);
1827     }
1828 
1829     /**
1830      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1831      *
1832      * _Available since v3.4._
1833      */
1834     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1835         if (b == 0) return (false, 0);
1836         return (true, a % b);
1837     }
1838 
1839     /**
1840      * @dev Returns the addition of two unsigned integers, reverting on
1841      * overflow.
1842      *
1843      * Counterpart to Solidity's `+` operator.
1844      *
1845      * Requirements:
1846      *
1847      * - Addition cannot overflow.
1848      */
1849     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1850         uint256 c = a + b;
1851         require(c >= a, "SafeMath: addition overflow");
1852         return c;
1853     }
1854 
1855     /**
1856      * @dev Returns the subtraction of two unsigned integers, reverting on
1857      * overflow (when the result is negative).
1858      *
1859      * Counterpart to Solidity's `-` operator.
1860      *
1861      * Requirements:
1862      *
1863      * - Subtraction cannot overflow.
1864      */
1865     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1866         require(b <= a, "SafeMath: subtraction overflow");
1867         return a - b;
1868     }
1869 
1870     /**
1871      * @dev Returns the multiplication of two unsigned integers, reverting on
1872      * overflow.
1873      *
1874      * Counterpart to Solidity's `*` operator.
1875      *
1876      * Requirements:
1877      *
1878      * - Multiplication cannot overflow.
1879      */
1880     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1881         if (a == 0) return 0;
1882         uint256 c = a * b;
1883         require(c / a == b, "SafeMath: multiplication overflow");
1884         return c;
1885     }
1886 
1887     /**
1888      * @dev Returns the integer division of two unsigned integers, reverting on
1889      * division by zero. The result is rounded towards zero.
1890      *
1891      * Counterpart to Solidity's `/` operator. Note: this function uses a
1892      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1893      * uses an invalid opcode to revert (consuming all remaining gas).
1894      *
1895      * Requirements:
1896      *
1897      * - The divisor cannot be zero.
1898      */
1899     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1900         require(b > 0, "SafeMath: division by zero");
1901         return a / b;
1902     }
1903 
1904     /**
1905      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1906      * reverting when dividing by zero.
1907      *
1908      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1909      * opcode (which leaves remaining gas untouched) while Solidity uses an
1910      * invalid opcode to revert (consuming all remaining gas).
1911      *
1912      * Requirements:
1913      *
1914      * - The divisor cannot be zero.
1915      */
1916     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1917         require(b > 0, "SafeMath: modulo by zero");
1918         return a % b;
1919     }
1920 
1921     /**
1922      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1923      * overflow (when the result is negative).
1924      *
1925      * CAUTION: This function is deprecated because it requires allocating memory for the error
1926      * message unnecessarily. For custom revert reasons use {trySub}.
1927      *
1928      * Counterpart to Solidity's `-` operator.
1929      *
1930      * Requirements:
1931      *
1932      * - Subtraction cannot overflow.
1933      */
1934     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1935         require(b <= a, errorMessage);
1936         return a - b;
1937     }
1938 
1939     /**
1940      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1941      * division by zero. The result is rounded towards zero.
1942      *
1943      * CAUTION: This function is deprecated because it requires allocating memory for the error
1944      * message unnecessarily. For custom revert reasons use {tryDiv}.
1945      *
1946      * Counterpart to Solidity's `/` operator. Note: this function uses a
1947      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1948      * uses an invalid opcode to revert (consuming all remaining gas).
1949      *
1950      * Requirements:
1951      *
1952      * - The divisor cannot be zero.
1953      */
1954     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1955         require(b > 0, errorMessage);
1956         return a / b;
1957     }
1958 
1959     /**
1960      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1961      * reverting with custom message when dividing by zero.
1962      *
1963      * CAUTION: This function is deprecated because it requires allocating memory for the error
1964      * message unnecessarily. For custom revert reasons use {tryMod}.
1965      *
1966      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1967      * opcode (which leaves remaining gas untouched) while Solidity uses an
1968      * invalid opcode to revert (consuming all remaining gas).
1969      *
1970      * Requirements:
1971      *
1972      * - The divisor cannot be zero.
1973      */
1974     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1975         require(b > 0, errorMessage);
1976         return a % b;
1977     }
1978 }
1979 
1980 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1981 
1982 /**
1983  * @dev Interface for the NFT Royalty Standard.
1984  *
1985  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1986  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1987  *
1988  * _Available since v4.5._
1989  */
1990 interface IERC2981 is IERC165 {
1991     /**
1992      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1993      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1994      */
1995     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1996         external
1997         view
1998         returns (address receiver, uint256 royaltyAmount);
1999 }
2000 
2001 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
2002 
2003 /**
2004  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2005  *
2006  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2007  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2008  *
2009  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2010  * fee is specified in basis points by default.
2011  *
2012  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2013  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2014  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2015  *
2016  * _Available since v4.5._
2017  */
2018 abstract contract ERC2981 is IERC2981, ERC165 {
2019     struct RoyaltyInfo {
2020         address receiver;
2021         uint96 royaltyFraction;
2022     }
2023 
2024     RoyaltyInfo private _defaultRoyaltyInfo;
2025     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2026 
2027     /**
2028      * @dev See {IERC165-supportsInterface}.
2029      */
2030     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2031         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2032     }
2033 
2034     /**
2035      * @inheritdoc IERC2981
2036      */
2037     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
2038         external
2039         view
2040         virtual
2041         override
2042         returns (address, uint256)
2043     {
2044         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2045 
2046         if (royalty.receiver == address(0)) {
2047             royalty = _defaultRoyaltyInfo;
2048         }
2049 
2050         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2051 
2052         return (royalty.receiver, royaltyAmount);
2053     }
2054 
2055     /**
2056      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2057      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2058      * override.
2059      */
2060     function _feeDenominator() internal pure virtual returns (uint96) {
2061         return 10000;
2062     }
2063 
2064     /**
2065      * @dev Sets the royalty information that all ids in this contract will default to.
2066      *
2067      * Requirements:
2068      *
2069      * - `receiver` cannot be the zero address.
2070      * - `feeNumerator` cannot be greater than the fee denominator.
2071      */
2072     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2073         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2074         require(receiver != address(0), "ERC2981: invalid receiver");
2075 
2076         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2077     }
2078 
2079     /**
2080      * @dev Removes default royalty information.
2081      */
2082     function _deleteDefaultRoyalty() internal virtual {
2083         delete _defaultRoyaltyInfo;
2084     }
2085 
2086     /**
2087      * @dev Sets the royalty information for a specific token id, overriding the global default.
2088      *
2089      * Requirements:
2090      *
2091      * - `tokenId` must be already minted.
2092      * - `receiver` cannot be the zero address.
2093      * - `feeNumerator` cannot be greater than the fee denominator.
2094      */
2095     function _setTokenRoyalty(
2096         uint256 tokenId,
2097         address receiver,
2098         uint96 feeNumerator
2099     ) internal virtual {
2100         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2101         require(receiver != address(0), "ERC2981: Invalid parameters");
2102 
2103         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2104     }
2105 
2106     /**
2107      * @dev Resets royalty information for the token id back to the global default.
2108      */
2109     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2110         delete _tokenRoyaltyInfo[tokenId];
2111     }
2112 }
2113 
2114 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2115 
2116 /**
2117  * @dev Contract module that helps prevent reentrant calls to a function.
2118  *
2119  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2120  * available, which can be applied to functions to make sure there are no nested
2121  * (reentrant) calls to them.
2122  *
2123  * Note that because there is a single `nonReentrant` guard, functions marked as
2124  * `nonReentrant` may not call one another. This can be worked around by making
2125  * those functions `private`, and then adding `external` `nonReentrant` entry
2126  * points to them.
2127  *
2128  * TIP: If you would like to learn more about reentrancy and alternative ways
2129  * to protect against it, check out our blog post
2130  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2131  */
2132 abstract contract ReentrancyGuard {
2133     // Booleans are more expensive than uint256 or any type that takes up a full
2134     // word because each write operation emits an extra SLOAD to first read the
2135     // slot's contents, replace the bits taken up by the boolean, and then write
2136     // back. This is the compiler's defense against contract upgrades and
2137     // pointer aliasing, and it cannot be disabled.
2138 
2139     // The values being non-zero value makes deployment a bit more expensive,
2140     // but in exchange the refund on every call to nonReentrant will be lower in
2141     // amount. Since refunds are capped to a percentage of the total
2142     // transaction's gas, it is best to keep them low in cases like this one, to
2143     // increase the likelihood of the full refund coming into effect.
2144     uint256 private constant _NOT_ENTERED = 1;
2145     uint256 private constant _ENTERED = 2;
2146 
2147     uint256 private _status;
2148 
2149     constructor() {
2150         _status = _NOT_ENTERED;
2151     }
2152 
2153     /**
2154      * @dev Prevents a contract from calling itself, directly or indirectly.
2155      * Calling a `nonReentrant` function from another `nonReentrant`
2156      * function is not supported. It is possible to prevent this from happening
2157      * by making the `nonReentrant` function external, and making it call a
2158      * `private` function that does the actual work.
2159      */
2160     modifier nonReentrant() {
2161         // On the first call to nonReentrant, _notEntered will be true
2162         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2163 
2164         // Any calls to nonReentrant after this point will fail
2165         _status = _ENTERED;
2166 
2167         _;
2168 
2169         // By storing the original value once again, a refund is triggered (see
2170         // https://eips.ethereum.org/EIPS/eip-2200)
2171         _status = _NOT_ENTERED;
2172     }
2173 }
2174 
2175 
2176 contract OkeyPandas is ERC721A, ERC2981, Ownable, ReentrancyGuard {
2177     using SafeMath for uint256;
2178 
2179     string public baseURI = "ipfs://bafybeicibbgtjhx6l52psow6qrbxtj3iwe24bfqq4nobqik5cmwonrmfy4/";
2180 
2181     uint256 public tokenPrice = 10000000000000000; //0.01 ETH
2182 
2183     uint public constant maxTokensPurchase = 20;
2184 
2185     uint public maxFreeTokensPerAddress = 5;
2186 
2187     uint256 public maxFreeTokens = 2222;
2188     
2189     uint256 public numberOfFreeTokensMinted = 0;
2190 
2191     uint256 public MAX_TOKENS = 3333;
2192 
2193     bool public saleIsActive = false;
2194 
2195     bool public freeMintIsActive = false;
2196 
2197     uint public percentRequiredAdditionalFee = 10;
2198     
2199     mapping (address => uint256) addressToNumberOfFreeTokensMinted;
2200 
2201     enum TokenURIMode {
2202         MODE_ONE,
2203         MODE_TWO
2204     }
2205 
2206     TokenURIMode private tokenUriMode = TokenURIMode.MODE_TWO;
2207 
2208     constructor(        
2209         string memory name,
2210         string memory symbol,
2211         address payable royaltyReceiver
2212     ) ERC721A(name, symbol) {
2213         _setDefaultRoyalty(royaltyReceiver, 250);
2214         _safeMint(msg.sender, 100);
2215     }
2216 
2217     function withdraw() public onlyOwner {
2218         uint balance = address(this).balance;
2219         payable(msg.sender).transfer(balance);
2220     } 
2221 
2222     function withdrawTo(address to, uint256 amount) public onlyOwner {
2223         require(amount <= address(this).balance, "Request would exceed balance of this contract");
2224         payable(to).transfer(amount);
2225     } 
2226 
2227     function reserveTokens(address to, uint numberOfTokens) public onlyOwner {        
2228         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Request would exceed max supply of tokens");
2229         _safeMint(to, numberOfTokens);
2230     }         
2231     
2232     function setBaseURI(string memory newURI) public onlyOwner {
2233         baseURI = newURI;
2234     }    
2235 
2236     function flipSaleState() public onlyOwner {
2237         saleIsActive = !saleIsActive;
2238     }
2239 
2240     function flipFreeMintState() public onlyOwner {
2241         freeMintIsActive = !freeMintIsActive;
2242     }
2243 
2244     function openFreeMint(uint256 _maxFreeTokensPerAddress, uint256 _maxFreeTokens) public onlyOwner{
2245         saleIsActive = true;
2246         freeMintIsActive = true;
2247         maxFreeTokensPerAddress = _maxFreeTokensPerAddress;
2248         maxFreeTokens = _maxFreeTokens;
2249         numberOfFreeTokensMinted = 0;
2250     }
2251     
2252     function mintFreeToken(uint numberOfTokens) public payable nonReentrant {
2253         require(saleIsActive, "Sale must be active to mint token");
2254         require(freeMintIsActive, "Free mint must be active to mint token");
2255         require(numberOfTokens <= maxFreeTokensPerAddress, "Exceed max allow to free tokens per wallet");
2256         require(numberOfFreeTokensMinted.add(1) <= maxFreeTokens, "No free mints left");
2257         require(addressToNumberOfFreeTokensMinted[msg.sender].add(1) <= maxFreeTokensPerAddress, "No free mints left for this wallet");
2258 
2259         if(numberOfFreeTokensMinted.add(numberOfTokens) > maxFreeTokens){
2260             numberOfTokens = maxFreeTokens.sub( numberOfFreeTokensMinted );
2261         }
2262         if(addressToNumberOfFreeTokensMinted[msg.sender].add(numberOfTokens) > maxFreeTokensPerAddress){
2263             numberOfTokens = 1;
2264         }
2265 
2266         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Exceed max supply of tokens");
2267         require(numberOfTokens > 0, "You must mint at least one token");
2268         
2269         if(percentRequiredAdditionalFee > 0 ){
2270             uint lottery = randomLottery(msg.sender);
2271             if(lottery <= percentRequiredAdditionalFee){
2272                 require(msg.value >= tokenPrice, "You must pay an additional fee to complete this transaction.");
2273             }
2274         }
2275 
2276         _safeMint(msg.sender, numberOfTokens);
2277 
2278         addressToNumberOfFreeTokensMinted[msg.sender] = addressToNumberOfFreeTokensMinted[msg.sender].add( numberOfTokens );
2279         numberOfFreeTokensMinted = numberOfFreeTokensMinted.add(numberOfTokens);
2280         if(numberOfFreeTokensMinted >= maxFreeTokens){
2281             freeMintIsActive = false;
2282         }
2283     }
2284 
2285     function mintToken(uint numberOfTokens) public payable nonReentrant {
2286         require(saleIsActive, "Sale must be active to mint token");
2287         require(numberOfTokens <= maxTokensPurchase, "The number of tokens per request exceeds the allowed number");
2288         require(numberOfTokens > 0, "You must mint at least one token");
2289         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Purchase would exceed max supply of tokens");
2290         require(tokenPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2291         
2292         _safeMint(msg.sender, numberOfTokens);
2293     }
2294 
2295     function setTokenPrice(uint256 newTokenPrice) public onlyOwner{
2296         tokenPrice = newTokenPrice;
2297     }
2298 
2299     function getTotalFreeMinted(address adr) public view returns(uint256) {
2300         return addressToNumberOfFreeTokensMinted[adr];
2301     }   
2302 
2303     function setMaxTokenFreePerAddress(uint256 _maxFreeTokensPerAddress) public onlyOwner{
2304         maxFreeTokensPerAddress = _maxFreeTokensPerAddress;
2305     }
2306 
2307     function tokenURI(uint256 _tokenId) public view override returns (string memory) 
2308     {
2309         require(_exists(_tokenId), "Token does not exist.");
2310         if (tokenUriMode == TokenURIMode.MODE_TWO) {
2311           return bytes(baseURI).length > 0 ? string(
2312             abi.encodePacked(
2313               baseURI,
2314               Strings.toString(_tokenId)
2315             )
2316           ) : "";
2317         } else {
2318           return bytes(baseURI).length > 0 ? string(
2319             abi.encodePacked(
2320               baseURI,
2321               Strings.toString(_tokenId),
2322               ".json"
2323             )
2324           ) : "";
2325         }
2326     }
2327 
2328     function setTokenURIMode(uint256 mode) external onlyOwner {
2329         if (mode == 2) {
2330             tokenUriMode = TokenURIMode.MODE_TWO;
2331         } else {
2332             tokenUriMode = TokenURIMode.MODE_ONE;
2333         }
2334     }
2335 
2336     function _baseURI() internal view virtual override returns (string memory) {
2337         return baseURI;
2338     }   
2339 
2340     function numberMinted(address owner) public view returns (uint256) {
2341         return _numberMinted(owner);
2342     } 
2343 
2344     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
2345       MAX_TOKENS = _maxSupply;
2346     }
2347 
2348     /**
2349     @notice Sets the contract-wide royalty info.
2350      */
2351     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
2352         external
2353         onlyOwner
2354     {
2355         _setDefaultRoyalty(receiver, feeBasisPoints);
2356     }
2357 
2358     function supportsInterface(bytes4 interfaceId)
2359         public
2360         view
2361         override(ERC721A, ERC2981)
2362         returns (bool)
2363     {
2364         return super.supportsInterface(interfaceId);
2365     }
2366 
2367     function setPercentRequiredAdditionalFee(uint _percentRequiredAdditionalFee) public onlyOwner{
2368         percentRequiredAdditionalFee = _percentRequiredAdditionalFee;
2369     }
2370 
2371     function randomLottery(address adr) public pure returns (uint){
2372         return uint( keccak256(abi.encodePacked(adr, "2")) ) % 100;
2373     }
2374 }