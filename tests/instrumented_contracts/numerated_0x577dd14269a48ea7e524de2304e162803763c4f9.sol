1 // File: contracts\CollectionProxy\IERC1538.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /// @title ERC1538 Transparent Contract Standard
6 /// @dev Required interface
7 ///  Note: the ERC-165 identifier for this interface is 0x61455567
8 interface IERC1538 {
9 
10     /// @dev This emits when one or a set of functions are updated in a transparent contract.
11     ///  The message string should give a short description of the change and why
12     ///  the change was made.
13     event CommitMessage(string message);
14 
15     /// @dev This emits for each function that is updated in a transparent contract.
16     ///  functionId is the bytes4 of the keccak256 of the function signature.
17     ///  oldDelegate is the delegate contract address of the old delegate contract if
18     ///  the function is being replaced or removed.
19     ///  oldDelegate is the zero value address(0) if a function is being added for the
20     ///  first time.
21     ///  newDelegate is the delegate contract address of the new delegate contract if
22     ///  the function is being added for the first time or if the function is being
23     ///  replaced.
24     ///  newDelegate is the zero value address(0) if the function is being removed.
25     event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
26 
27     /// @notice Updates functions in a transparent contract.
28     /// @dev If the value of _delegate is zero then the functions specified
29     ///  in _functionSignatures are removed.
30     ///  If the value of _delegate is a delegate contract address then the functions
31     ///  specified in _functionSignatures will be delegated to that address.
32     /// @param _delegate The address of a delegate contract to delegate to or zero
33     ///        to remove functions.
34     /// @param _functionSignatures A list of function signatures listed one after the other
35     /// @param _commitMessage A short description of the change and why it is made
36     ///        This message is passed to the CommitMessage event.
37     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) external;
38 }
39 
40 // File: contracts\CollectionProxy\ProxyBaseStorage.sol
41 
42 pragma solidity ^0.8.0;
43 
44 ///////////////////////////////////////////////////////////////////////////////////////////////////
45 /**
46  * @title ProxyBaseStorage
47  * @dev Defining base storage for the proxy contract.
48  */
49 ///////////////////////////////////////////////////////////////////////////////////////////////////
50 
51 contract ProxyBaseStorage {
52 
53     //////////////////////////////////////////// VARS /////////////////////////////////////////////
54 
55     // maps functions to the delegate contracts that execute the functions.
56     // funcId => delegate contract
57     mapping(bytes4 => address) public delegates;
58 
59     // array of function signatures supported by the contract.
60     bytes[] public funcSignatures;
61 
62     // maps each function signature to its position in the funcSignatures array.
63     // signature => index+1
64     mapping(bytes => uint256) internal funcSignatureToIndex;
65 
66     // proxy address of itself, can be used for cross-delegate calls but also safety checking.
67     address proxy;
68 
69     ///////////////////////////////////////////////////////////////////////////////////////////////
70 
71 }
72 
73 // File: @openzeppelin\contracts\utils\introspection\IERC165.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Interface of the ERC165 standard, as defined in the
82  * https://eips.ethereum.org/EIPS/eip-165[EIP].
83  *
84  * Implementers can declare support of contract interfaces, which can then be
85  * queried by others ({ERC165Checker}).
86  *
87  * For an implementation, see {ERC165}.
88  */
89 interface IERC165 {
90     /**
91      * @dev Returns true if this contract implements the interface defined by
92      * `interfaceId`. See the corresponding
93      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
94      * to learn more about how these ids are created.
95      *
96      * This function call must use less than 30 000 gas.
97      */
98     function supportsInterface(bytes4 interfaceId) external view returns (bool);
99 }
100 
101 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
102 
103 
104 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Required interface of an ERC721 compliant contract.
110  */
111 interface IERC721 is IERC165 {
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns the account approved for `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 }
244 
245 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
284  * @dev See https://eips.ethereum.org/EIPS/eip-721
285  */
286 interface IERC721Metadata is IERC721 {
287     /**
288      * @dev Returns the token collection name.
289      */
290     function name() external view returns (string memory);
291 
292     /**
293      * @dev Returns the token collection symbol.
294      */
295     function symbol() external view returns (string memory);
296 
297     /**
298      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
299      */
300     function tokenURI(uint256 tokenId) external view returns (string memory);
301 }
302 
303 // File: @openzeppelin\contracts\utils\Address.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
307 
308 pragma solidity ^0.8.1;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      *
331      * [IMPORTANT]
332      * ====
333      * You shouldn't rely on `isContract` to protect against flash loan attacks!
334      *
335      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
336      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
337      * constructor.
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize/address.code.length, which returns 0
342         // for contracts in construction, since the code is only stored at the end
343         // of the constructor execution.
344 
345         return account.code.length > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516                 /// @solidity memory-safe-assembly
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // File: @openzeppelin\contracts\utils\Context.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Provides information about the current execution context, including the
537  * sender of the transaction and its data. While these are generally available
538  * via msg.sender and msg.data, they should not be accessed in such a direct
539  * manner, since when dealing with meta-transactions the account sending and
540  * paying for execution may not be the actual sender (as far as an application
541  * is concerned).
542  *
543  * This contract is only required for intermediate, library-like contracts.
544  */
545 abstract contract Context {
546     function _msgSender() internal view virtual returns (address) {
547         return msg.sender;
548     }
549 
550     function _msgData() internal view virtual returns (bytes calldata) {
551         return msg.data;
552     }
553 }
554 
555 // File: @openzeppelin\contracts\utils\Strings.sol
556 
557 
558 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev String operations.
564  */
565 library Strings {
566     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
567     uint8 private constant _ADDRESS_LENGTH = 20;
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
571      */
572     function toString(uint256 value) internal pure returns (string memory) {
573         // Inspired by OraclizeAPI's implementation - MIT licence
574         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
575 
576         if (value == 0) {
577             return "0";
578         }
579         uint256 temp = value;
580         uint256 digits;
581         while (temp != 0) {
582             digits++;
583             temp /= 10;
584         }
585         bytes memory buffer = new bytes(digits);
586         while (value != 0) {
587             digits -= 1;
588             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
589             value /= 10;
590         }
591         return string(buffer);
592     }
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
596      */
597     function toHexString(uint256 value) internal pure returns (string memory) {
598         if (value == 0) {
599             return "0x00";
600         }
601         uint256 temp = value;
602         uint256 length = 0;
603         while (temp != 0) {
604             length++;
605             temp >>= 8;
606         }
607         return toHexString(value, length);
608     }
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
612      */
613     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
614         bytes memory buffer = new bytes(2 * length + 2);
615         buffer[0] = "0";
616         buffer[1] = "x";
617         for (uint256 i = 2 * length + 1; i > 1; --i) {
618             buffer[i] = _HEX_SYMBOLS[value & 0xf];
619             value >>= 4;
620         }
621         require(value == 0, "Strings: hex length insufficient");
622         return string(buffer);
623     }
624 
625     /**
626      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
627      */
628     function toHexString(address addr) internal pure returns (string memory) {
629         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
630     }
631 }
632 
633 // File: @openzeppelin\contracts\utils\introspection\ERC165.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev Implementation of the {IERC165} interface.
642  *
643  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
644  * for the additional interface id that will be supported. For example:
645  *
646  * ```solidity
647  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
648  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
649  * }
650  * ```
651  *
652  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
653  */
654 abstract contract ERC165 is IERC165 {
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659         return interfaceId == type(IERC165).interfaceId;
660     }
661 }
662 
663 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
664 
665 
666 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 
672 
673 
674 
675 
676 /**
677  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
678  * the Metadata extension, but not including the Enumerable extension, which is available separately as
679  * {ERC721Enumerable}.
680  */
681 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
682     using Address for address;
683     using Strings for uint256;
684 
685     // Token name
686     string private _name;
687 
688     // Token symbol
689     string private _symbol;
690 
691     // Mapping from token ID to owner address
692     mapping(uint256 => address) private _owners;
693 
694     // Mapping owner address to token count
695     mapping(address => uint256) private _balances;
696 
697     // Mapping from token ID to approved address
698     mapping(uint256 => address) private _tokenApprovals;
699 
700     // Mapping from owner to operator approvals
701     mapping(address => mapping(address => bool)) private _operatorApprovals;
702 
703     /**
704      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
705      */
706     constructor(string memory name_, string memory symbol_) {
707         _name = name_;
708         _symbol = symbol_;
709     }
710 
711     /**
712      * @dev See {IERC165-supportsInterface}.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
715         return
716             interfaceId == type(IERC721).interfaceId ||
717             interfaceId == type(IERC721Metadata).interfaceId ||
718             super.supportsInterface(interfaceId);
719     }
720 
721     /**
722      * @dev See {IERC721-balanceOf}.
723      */
724     function balanceOf(address owner) public view virtual override returns (uint256) {
725         require(owner != address(0), "ERC721: address zero is not a valid owner");
726         return _balances[owner];
727     }
728 
729     /**
730      * @dev See {IERC721-ownerOf}.
731      */
732     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
733         address owner = _owners[tokenId];
734         require(owner != address(0), "ERC721: invalid token ID");
735         return owner;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-name}.
740      */
741     function name() public view virtual override returns (string memory) {
742         return _name;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-symbol}.
747      */
748     function symbol() public view virtual override returns (string memory) {
749         return _symbol;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-tokenURI}.
754      */
755     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
756         _requireMinted(tokenId);
757 
758         string memory baseURI = _baseURI();
759         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
760     }
761 
762     /**
763      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
764      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
765      * by default, can be overridden in child contracts.
766      */
767     function _baseURI() internal view virtual returns (string memory) {
768         return "";
769     }
770 
771     /**
772      * @dev See {IERC721-approve}.
773      */
774     function approve(address to, uint256 tokenId) public virtual override {
775         address owner = ERC721.ownerOf(tokenId);
776         require(to != owner, "ERC721: approval to current owner");
777 
778         require(
779             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
780             "ERC721: approve caller is not token owner nor approved for all"
781         );
782 
783         _approve(to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-getApproved}.
788      */
789     function getApproved(uint256 tokenId) public view virtual override returns (address) {
790         _requireMinted(tokenId);
791 
792         return _tokenApprovals[tokenId];
793     }
794 
795     /**
796      * @dev See {IERC721-setApprovalForAll}.
797      */
798     function setApprovalForAll(address operator, bool approved) public virtual override {
799         _setApprovalForAll(_msgSender(), operator, approved);
800     }
801 
802     /**
803      * @dev See {IERC721-isApprovedForAll}.
804      */
805     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
806         return _operatorApprovals[owner][operator];
807     }
808 
809     /**
810      * @dev See {IERC721-transferFrom}.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) public virtual override {
817         //solhint-disable-next-line max-line-length
818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
819 
820         _transfer(from, to, tokenId);
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public virtual override {
831         safeTransferFrom(from, to, tokenId, "");
832     }
833 
834     /**
835      * @dev See {IERC721-safeTransferFrom}.
836      */
837     function safeTransferFrom(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes memory data
842     ) public virtual override {
843         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
844         _safeTransfer(from, to, tokenId, data);
845     }
846 
847     /**
848      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
849      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
850      *
851      * `data` is additional data, it has no specified format and it is sent in call to `to`.
852      *
853      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
854      * implement alternative mechanisms to perform token transfer, such as signature-based.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must exist and be owned by `from`.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _safeTransfer(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory data
870     ) internal virtual {
871         _transfer(from, to, tokenId);
872         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
873     }
874 
875     /**
876      * @dev Returns whether `tokenId` exists.
877      *
878      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
879      *
880      * Tokens start existing when they are minted (`_mint`),
881      * and stop existing when they are burned (`_burn`).
882      */
883     function _exists(uint256 tokenId) internal view virtual returns (bool) {
884         return _owners[tokenId] != address(0);
885     }
886 
887     /**
888      * @dev Returns whether `spender` is allowed to manage `tokenId`.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
895         address owner = ERC721.ownerOf(tokenId);
896         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
897     }
898 
899     /**
900      * @dev Safely mints `tokenId` and transfers it to `to`.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must not exist.
905      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _safeMint(address to, uint256 tokenId) internal virtual {
910         _safeMint(to, tokenId, "");
911     }
912 
913     /**
914      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
915      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
916      */
917     function _safeMint(
918         address to,
919         uint256 tokenId,
920         bytes memory data
921     ) internal virtual {
922         _mint(to, tokenId);
923         require(
924             _checkOnERC721Received(address(0), to, tokenId, data),
925             "ERC721: transfer to non ERC721Receiver implementer"
926         );
927     }
928 
929     /**
930      * @dev Mints `tokenId` and transfers it to `to`.
931      *
932      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
933      *
934      * Requirements:
935      *
936      * - `tokenId` must not exist.
937      * - `to` cannot be the zero address.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _mint(address to, uint256 tokenId) internal virtual {
942         require(to != address(0), "ERC721: mint to the zero address");
943         require(!_exists(tokenId), "ERC721: token already minted");
944 
945         _beforeTokenTransfer(address(0), to, tokenId);
946 
947         _balances[to] += 1;
948         _owners[tokenId] = to;
949 
950         emit Transfer(address(0), to, tokenId);
951 
952         _afterTokenTransfer(address(0), to, tokenId);
953     }
954 
955     /**
956      * @dev Destroys `tokenId`.
957      * The approval is cleared when the token is burned.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _burn(uint256 tokenId) internal virtual {
966         address owner = ERC721.ownerOf(tokenId);
967 
968         _beforeTokenTransfer(owner, address(0), tokenId);
969 
970         // Clear approvals
971         _approve(address(0), tokenId);
972 
973         _balances[owner] -= 1;
974         delete _owners[tokenId];
975 
976         emit Transfer(owner, address(0), tokenId);
977 
978         _afterTokenTransfer(owner, address(0), tokenId);
979     }
980 
981     /**
982      * @dev Transfers `tokenId` from `from` to `to`.
983      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must be owned by `from`.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _transfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) internal virtual {
997         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
998         require(to != address(0), "ERC721: transfer to the zero address");
999 
1000         _beforeTokenTransfer(from, to, tokenId);
1001 
1002         // Clear approvals from the previous owner
1003         _approve(address(0), tokenId);
1004 
1005         _balances[from] -= 1;
1006         _balances[to] += 1;
1007         _owners[tokenId] = to;
1008 
1009         emit Transfer(from, to, tokenId);
1010 
1011         _afterTokenTransfer(from, to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev Approve `to` to operate on `tokenId`
1016      *
1017      * Emits an {Approval} event.
1018      */
1019     function _approve(address to, uint256 tokenId) internal virtual {
1020         _tokenApprovals[tokenId] = to;
1021         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Approve `operator` to operate on all of `owner` tokens
1026      *
1027      * Emits an {ApprovalForAll} event.
1028      */
1029     function _setApprovalForAll(
1030         address owner,
1031         address operator,
1032         bool approved
1033     ) internal virtual {
1034         require(owner != operator, "ERC721: approve to caller");
1035         _operatorApprovals[owner][operator] = approved;
1036         emit ApprovalForAll(owner, operator, approved);
1037     }
1038 
1039     /**
1040      * @dev Reverts if the `tokenId` has not been minted yet.
1041      */
1042     function _requireMinted(uint256 tokenId) internal view virtual {
1043         require(_exists(tokenId), "ERC721: invalid token ID");
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1064                 return retval == IERC721Receiver.onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert("ERC721: transfer to non ERC721Receiver implementer");
1068                 } else {
1069                     /// @solidity memory-safe-assembly
1070                     assembly {
1071                         revert(add(32, reason), mload(reason))
1072                     }
1073                 }
1074             }
1075         } else {
1076             return true;
1077         }
1078     }
1079 
1080     /**
1081      * @dev Hook that is called before any token transfer. This includes minting
1082      * and burning.
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` will be minted for `to`.
1089      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1090      * - `from` and `to` are never both zero.
1091      *
1092      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1093      */
1094     function _beforeTokenTransfer(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) internal virtual {}
1099 
1100     /**
1101      * @dev Hook that is called after any transfer of tokens. This includes
1102      * minting and burning.
1103      *
1104      * Calling conditions:
1105      *
1106      * - when `from` and `to` are both non-zero.
1107      * - `from` and `to` are never both zero.
1108      *
1109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1110      */
1111     function _afterTokenTransfer(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) internal virtual {}
1116 }
1117 
1118 // File: contracts\OpenseaStandard\IOperatorFilterRegistry.sol
1119 
1120 
1121 pragma solidity ^0.8.13;
1122 
1123 interface IOperatorFilterRegistry {
1124     /**
1125      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1126      *         true if supplied registrant address is not registered.
1127      */
1128     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1129 
1130     /**
1131      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1132      */
1133     function register(address registrant) external;
1134 
1135     /**
1136      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1137      */
1138     function registerAndSubscribe(address registrant, address subscription) external;
1139 
1140     /**
1141      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1142      *         address without subscribing.
1143      */
1144     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1145 
1146     /**
1147      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1148      *         Note that this does not remove any filtered addresses or codeHashes.
1149      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1150      */
1151     function unregister(address addr) external;
1152 
1153     /**
1154      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1155      */
1156     function updateOperator(address registrant, address operator, bool filtered) external;
1157 
1158     /**
1159      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1160      */
1161     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1162 
1163     /**
1164      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1165      */
1166     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1167 
1168     /**
1169      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1170      */
1171     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1172 
1173     /**
1174      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1175      *         subscription if present.
1176      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1177      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1178      *         used.
1179      */
1180     function subscribe(address registrant, address registrantToSubscribe) external;
1181 
1182     /**
1183      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1184      */
1185     function unsubscribe(address registrant, bool copyExistingEntries) external;
1186 
1187     /**
1188      * @notice Get the subscription address of a given registrant, if any.
1189      */
1190     function subscriptionOf(address addr) external returns (address registrant);
1191 
1192     /**
1193      * @notice Get the set of addresses subscribed to a given registrant.
1194      *         Note that order is not guaranteed as updates are made.
1195      */
1196     function subscribers(address registrant) external returns (address[] memory);
1197 
1198     /**
1199      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1200      *         Note that order is not guaranteed as updates are made.
1201      */
1202     function subscriberAt(address registrant, uint256 index) external returns (address);
1203 
1204     /**
1205      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1206      */
1207     function copyEntriesOf(address registrant, address registrantToCopy) external;
1208 
1209     /**
1210      * @notice Returns true if operator is filtered by a given address or its subscription.
1211      */
1212     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1213 
1214     /**
1215      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1216      */
1217     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1218 
1219     /**
1220      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1221      */
1222     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1223 
1224     /**
1225      * @notice Returns a list of filtered operators for a given address or its subscription.
1226      */
1227     function filteredOperators(address addr) external returns (address[] memory);
1228 
1229     /**
1230      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1231      *         Note that order is not guaranteed as updates are made.
1232      */
1233     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1234 
1235     /**
1236      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1237      *         its subscription.
1238      *         Note that order is not guaranteed as updates are made.
1239      */
1240     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1241 
1242     /**
1243      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1244      *         its subscription.
1245      *         Note that order is not guaranteed as updates are made.
1246      */
1247     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1248 
1249     /**
1250      * @notice Returns true if an address has registered
1251      */
1252     function isRegistered(address addr) external returns (bool);
1253 
1254     /**
1255      * @dev Convenience method to compute the code hash of an arbitrary contract
1256      */
1257     function codeHashOf(address addr) external returns (bytes32);
1258 }
1259 
1260 // File: contracts\OpenseaStandard\lib\Constants.sol
1261 
1262 
1263 pragma solidity ^0.8.13;
1264 
1265 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1266 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1267 
1268 // File: contracts\OpenseaStandard\OperatorFilterer.sol
1269 
1270 
1271 pragma solidity ^0.8.13;
1272 /**
1273  * @title  OperatorFilterer
1274  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1275  *         registrant's entries in the OperatorFilterRegistry.
1276  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1277  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1278  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1279  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1280  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1281  *         will be locked to the options set during construction.
1282  */
1283 
1284 abstract contract OperatorFilterer {
1285     /// @dev Emitted when an operator is not allowed.
1286     error OperatorNotAllowed(address operator);
1287 
1288     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1289         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1290 
1291     /// @dev The constructor that is called when the contract is being deployed.
1292     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1293         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1294         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1295         // order for the modifier to filter addresses.
1296         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1297             if (subscribe) {
1298                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1299             } else {
1300                 if (subscriptionOrRegistrantToCopy != address(0)) {
1301                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1302                 } else {
1303                     OPERATOR_FILTER_REGISTRY.register(address(this));
1304                 }
1305             }
1306         }
1307     }
1308 
1309     /**
1310      * @dev A helper function to check if an operator is allowed.
1311      */
1312     modifier onlyAllowedOperator(address from) virtual {
1313         // Allow spending tokens from addresses with balance
1314         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1315         // from an EOA.
1316         if (from != msg.sender) {
1317             _checkFilterOperator(msg.sender);
1318         }
1319         _;
1320     }
1321 
1322     /**
1323      * @dev A helper function to check if an operator approval is allowed.
1324      */
1325     modifier onlyAllowedOperatorApproval(address operator) virtual {
1326         _checkFilterOperator(operator);
1327         _;
1328     }
1329 
1330     /**
1331      * @dev A helper function to check if an operator is allowed.
1332      */
1333     function _checkFilterOperator(address operator) internal view virtual {
1334         // Check registry code length to facilitate testing in environments without a deployed registry.
1335         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1336             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1337             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1338             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1339                 revert OperatorNotAllowed(operator);
1340             }
1341         }
1342     }
1343 }
1344 
1345 // File: contracts\OpenseaStandard\DefaultOperatorFilterer.sol
1346 
1347 
1348 pragma solidity ^0.8.13;
1349 /**
1350  * @title  DefaultOperatorFilterer
1351  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1352  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1353  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1354  *         will be locked to the options set during construction.
1355  */
1356 
1357 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1358     /// @dev The constructor that is called when the contract is being deployed.
1359     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1360 }
1361 
1362 // File: contracts\NFTLimit.sol
1363 
1364 pragma solidity ^0.8.13;
1365 abstract contract NFTLimit is ERC721, DefaultOperatorFilterer {
1366 
1367     mapping(address => bool) public isTransferAllowed;
1368     mapping(uint256 => bool) public nftLock;
1369 
1370      modifier  onlyTransferAllowed(address from) {
1371         require(isTransferAllowed[from],"ERC721: transfer not allowed");
1372         _;
1373     }
1374 
1375      modifier  isNFTLock(uint256 tokenId) {
1376         require(!nftLock[tokenId],"ERC721: NFT is locked");
1377         _;
1378     }
1379 
1380     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator)  {
1381         require(isTransferAllowed[operator],"ERC721: transfer not allowed");
1382         super.setApprovalForAll(operator, approved);
1383     }
1384 
1385     function approve(address operator, uint256 tokenId) public  override onlyAllowedOperatorApproval(operator)  {
1386         require(isTransferAllowed[operator],"ERC721: transfer not allowed");
1387         super.approve(operator, tokenId);
1388     }
1389 
1390     
1391 
1392 
1393      // OpenSea Enforcer functions
1394     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from)  {
1395         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
1396         require(!nftLock[tokenId],"ERC721: NFT is locked");
1397         super.transferFrom(from, to, tokenId);
1398     }
1399 
1400     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from)   {
1401         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
1402         require(!nftLock[tokenId],"ERC721: NFT is locked");
1403         super.safeTransferFrom(from, to, tokenId);
1404     }
1405 
1406     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from)  {
1407         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
1408         require(!nftLock[tokenId],"ERC721: NFT is locked");
1409         super.safeTransferFrom(from, to, tokenId, data);
1410     }
1411 
1412   
1413 }
1414 
1415 // File: contracts\CollectionProxy\CollectionStorage.sol
1416 
1417 pragma solidity ^0.8.13;
1418 
1419 contract CollectionStorage {
1420 
1421 uint256  tokenIds;
1422 uint256 burnCount;
1423 string public baseURI;
1424 mapping(address => bool) public _allowAddress;
1425 
1426 
1427  mapping(uint256 => bytes32) internal whiteListRoot;
1428 
1429  uint256 internal MaxSupply;
1430 
1431  uint256 public status;
1432 
1433  uint256 internal mainPrice;
1434 
1435  address internal seller;
1436 
1437  uint256 internal royalty;
1438 
1439 uint256 public bundleId;
1440  uint256 public perPurchaseNFTToMint;
1441 
1442  
1443 
1444  uint256[] rarity;
1445 
1446  struct SaleDetail {
1447     uint256 startTime;
1448     uint256 endTime;
1449     uint256 price;
1450  }
1451 
1452  mapping (uint256=>SaleDetail) internal _saleDetails;
1453  mapping(address => mapping(uint256 => uint256)) internal userBought;
1454  mapping(uint256 => bool) internal isReserveWhitelist;
1455  mapping(uint256 => uint256) public reservedNFT;
1456 
1457 }
1458 
1459 // File: contracts\CollectionProxy\Ownable.sol
1460 
1461 
1462 
1463 pragma solidity ^0.8.0;
1464 /**
1465  * @dev Contract module which provides a basic access control mechanism, where
1466  * there is an account (an owner) that can be granted exclusive access to
1467  * specific functions.
1468  *
1469  * By default, the owner account will be the one that deploys the contract. This
1470  * can later be changed with {transferOwnership}.
1471  *
1472  * This module is used through inheritance. It will make available the modifier
1473  * `onlyOwner`, which can be applied to your functions to restrict their use to
1474  * the owner.
1475  */
1476 abstract contract Ownable is Context {
1477     address private _owner;
1478 
1479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1480 
1481     /**
1482      * @dev Initializes the contract setting the deployer as the initial owner.
1483      */
1484     constructor() {
1485         _setOwner(_msgSender());
1486     }
1487 
1488     /**
1489      * @dev Returns the address of the current owner.
1490      */
1491     function owner() public view virtual returns (address) {
1492         return _owner;
1493     }
1494 
1495     /**
1496      * @dev Throws if called by any account other than the owner.
1497      */
1498     modifier onlyOwner() {
1499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1500         _;
1501     }
1502 
1503     /**
1504      * @dev Leaves the contract without owner. It will not be possible to call
1505      * `onlyOwner` functions anymore. Can only be called by the current owner.
1506      *
1507      * NOTE: Renouncing ownership will leave the contract without an owner,
1508      * thereby removing any functionality that is only available to the owner.
1509      */
1510     function renounceOwnership() public virtual onlyOwner {
1511         _setOwner(address(0));
1512     }
1513 
1514     /**
1515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1516      * Can only be called by the current owner.
1517      */
1518     function transferOwnership(address newOwner) public virtual onlyOwner {
1519         require(newOwner != address(0), "Ownable: new owner is the zero address");
1520         _setOwner(newOwner);
1521     }
1522 
1523     function _setOwner(address newOwner) internal {
1524         address oldOwner = _owner;
1525         _owner = newOwner;
1526         emit OwnershipTransferred(oldOwner, newOwner);
1527     }
1528 }
1529 
1530 // File: contracts\CollectionProxy\CollectionProxy.sol
1531 
1532 pragma solidity ^0.8.13;
1533 ///////////////////////////////////////////////////////////////////////////////////////////////////
1534 /**
1535  * @title ProxyReceiver Contract
1536  * @dev Handles forwarding calls to receiver delegates while offering transparency of updates.
1537  *      Follows ERC-1538 standard.
1538  *
1539  *    NOTE: Not recommended for direct use in a production contract, as no security control.
1540  *          Provided as simple example only.
1541  */
1542 ///////////////////////////////////////////////////////////////////////////////////////////////////
1543 
1544 contract CollectionProxy is ProxyBaseStorage, IERC1538, NFTLimit, Ownable, CollectionStorage {
1545 using Strings for uint256;
1546 
1547     constructor(address implementation)ERC721("XANA:PENPENZ x CryptoNinja", "PPZ") {
1548 
1549         proxy = address(this);
1550         _allowAddress[msg.sender] = true;
1551         baseURI = "https://testapi.xanalia.com/xanalia/get-nft-meta?tokenId=";
1552         MaxSupply = 10000;
1553     
1554         //Adding ERC1538 updateContract function
1555         bytes memory signature = "updateContract(address,string,string)";
1556          constructorRegisterFunction(signature, proxy);
1557          bytes memory setBaseURISig = "setBaseURI(string)";
1558          constructorRegisterFunction(setBaseURISig, implementation);
1559          setBaseURISig = "getUserBoughtCount(address,uint256)";
1560          constructorRegisterFunction(setBaseURISig, implementation);
1561          setBaseURISig = "isWhitelisted(address,bytes32[],uint256,uint256)";
1562          constructorRegisterFunction(setBaseURISig, implementation);
1563          setBaseURISig = "preMint(address,uint256)";
1564          constructorRegisterFunction(setBaseURISig, implementation);
1565          setBaseURISig = "setSeed(uint256)";
1566          constructorRegisterFunction(setBaseURISig, implementation);
1567          setBaseURISig = "claimCryptoNFT()";
1568          constructorRegisterFunction(setBaseURISig, implementation);
1569          setBaseURISig = "mint(bytes32[],uint256,uint256)";
1570          constructorRegisterFunction(setBaseURISig, implementation);
1571          setBaseURISig = "burnAdmin(uint256)";
1572          constructorRegisterFunction(setBaseURISig, implementation);
1573          setBaseURISig = "setWhitelistRoot(bytes32,uint256,bool)";
1574          constructorRegisterFunction(setBaseURISig, implementation);
1575          setBaseURISig = "setAuthor(address)";
1576          constructorRegisterFunction(setBaseURISig, implementation);
1577          setBaseURISig = "setMaxSupply(uint256)";
1578          constructorRegisterFunction(setBaseURISig, implementation);
1579          setBaseURISig = "setStatus(uint256)";
1580          constructorRegisterFunction(setBaseURISig, implementation);
1581          setBaseURISig = "setTransferAllowed(address,bool)";
1582          constructorRegisterFunction(setBaseURISig, implementation);
1583          setBaseURISig = "setSaleDetails(uint256,uint256,uint256)";
1584          constructorRegisterFunction(setBaseURISig, implementation);
1585          setBaseURISig = "setlockStatusNFT(uint256,bool)";
1586          constructorRegisterFunction(setBaseURISig, implementation);
1587          setBaseURISig = "setPerBundleNFTToMint(uint256)";
1588          constructorRegisterFunction(setBaseURISig, implementation);
1589          setBaseURISig = "tokenURI(uint256)";
1590          constructorRegisterFunction(setBaseURISig, implementation);
1591          setBaseURISig = "setPrice(uint256)";
1592          constructorRegisterFunction(setBaseURISig, implementation);
1593          setBaseURISig = "setRoyalty(uint256)";
1594          constructorRegisterFunction(setBaseURISig, implementation);
1595          setBaseURISig = "getPrice()";
1596          constructorRegisterFunction(setBaseURISig, implementation);
1597          setBaseURISig = "getMaxSupply()";
1598          constructorRegisterFunction(setBaseURISig, implementation);
1599          setBaseURISig = "getAuthor(uint256)";
1600          constructorRegisterFunction(setBaseURISig, implementation);
1601          setBaseURISig = "getRoyaltyFee(uint256)";
1602          constructorRegisterFunction(setBaseURISig, implementation);
1603          setBaseURISig = "getCreator(uint256)";
1604          constructorRegisterFunction(setBaseURISig, implementation);
1605          setBaseURISig = "lockNFTBulk(uint256[],bool)";
1606          constructorRegisterFunction(setBaseURISig, implementation);
1607          setBaseURISig = "unLockGas(uint256[])";
1608          constructorRegisterFunction(setBaseURISig, implementation);
1609     }
1610 
1611      function constructorRegisterFunction(bytes memory signature, address proxy) internal {
1612         bytes4 funcId = bytes4(keccak256(signature));
1613         delegates[funcId] = proxy;
1614         funcSignatures.push(signature);
1615         funcSignatureToIndex[signature] = funcSignatures.length;
1616        
1617         emit FunctionUpdate(funcId, address(0), proxy, string(signature));
1618         
1619         emit CommitMessage("Added ERC1538 updateContract function at contract creation");
1620     }
1621 
1622     ///////////////////////////////////////////////////////////////////////////////////////////////
1623 
1624     fallback() external payable {
1625         if (msg.sig == bytes4(0) && msg.value != uint(0)) { // skipping ethers/BNB received to delegate
1626             return;
1627         }
1628         address delegate = delegates[msg.sig];
1629         require(delegate != address(0), "Function does not exist.");
1630         assembly {
1631             let ptr := mload(0x40)
1632             calldatacopy(ptr, 0, calldatasize())
1633             let result := delegatecall(gas(), delegate, ptr, calldatasize(), 0, 0)
1634             let size := returndatasize()
1635             returndatacopy(ptr, 0, size)
1636             switch result
1637             case 0 {revert(ptr, size)}
1638             default {return (ptr, size)}
1639         }
1640     }
1641 
1642     ///////////////////////////////////////////////////////////////////////////////////////////////
1643 
1644     /// @notice Updates functions in a transparent contract.
1645     /// @dev If the value of _delegate is zero then the functions specified
1646     ///  in _functionSignatures are removed.
1647     ///  If the value of _delegate is a delegate contract address then the functions
1648     ///  specified in _functionSignatures will be delegated to that address.
1649     /// @param _delegate The address of a delegate contract to delegate to or zero
1650     /// @param _functionSignatures A list of function signatures listed one after the other
1651     /// @param _commitMessage A short description of the change and why it is made
1652     ///        This message is passed to the CommitMessage event.
1653     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) override onlyOwner external {
1654         // pos is first used to check the size of the delegate contract.
1655         // After that pos is the current memory location of _functionSignatures.
1656         // It is used to move through the characters of _functionSignatures
1657         uint256 pos;
1658         if(_delegate != address(0)) {
1659             assembly {
1660                 pos := extcodesize(_delegate)
1661             }
1662             require(pos > 0, "_delegate address is not a contract and is not address(0)");
1663         }
1664 
1665         // creates a bytes version of _functionSignatures
1666         bytes memory signatures = bytes(_functionSignatures);
1667         // stores the position in memory where _functionSignatures ends.
1668         uint256 signaturesEnd;
1669         // stores the starting position of a function signature in _functionSignatures
1670         uint256 start;
1671         assembly {
1672             pos := add(signatures,32)
1673             start := pos
1674             signaturesEnd := add(pos,mload(signatures))
1675         }
1676         // the function id of the current function signature
1677         bytes4 funcId;
1678         // the delegate address that is being replaced or address(0) if removing functions
1679         address oldDelegate;
1680         // the length of the current function signature in _functionSignatures
1681         uint256 num;
1682         // the current character in _functionSignatures
1683         uint256 char;
1684         // the position of the current function signature in the funcSignatures array
1685         uint256 index;
1686         // the last position in the funcSignatures array
1687         uint256 lastIndex;
1688         // parse the _functionSignatures string and handle each function
1689         for (; pos < signaturesEnd; pos++) {
1690             assembly {char := byte(0,mload(pos))}
1691             // 0x29 == )
1692             if (char == 0x29) {
1693                 pos++;
1694                 num = (pos - start);
1695                 start = pos;
1696                 assembly {
1697                     mstore(signatures,num)
1698                 }
1699                 funcId = bytes4(keccak256(signatures));
1700                 oldDelegate = delegates[funcId];
1701                 if(_delegate == address(0)) {
1702                     index = funcSignatureToIndex[signatures];
1703                     require(index != 0, "Function does not exist.");
1704                     index--;
1705                     lastIndex = funcSignatures.length - 1;
1706                     if (index != lastIndex) {
1707                         funcSignatures[index] = funcSignatures[lastIndex];
1708                         funcSignatureToIndex[funcSignatures[lastIndex]] = index + 1;
1709                     }
1710                     funcSignatures.pop();
1711                     delete funcSignatureToIndex[signatures];
1712                     delete delegates[funcId];
1713                     emit FunctionUpdate(funcId, oldDelegate, address(0), string(signatures));
1714                 }
1715                 else if (funcSignatureToIndex[signatures] == 0) {
1716                     require(oldDelegate == address(0), "FuncId clash.");
1717                     delegates[funcId] = _delegate;
1718                     funcSignatures.push(signatures);
1719                     funcSignatureToIndex[signatures] = funcSignatures.length;
1720                     emit FunctionUpdate(funcId, address(0), _delegate, string(signatures));
1721                 }
1722                 else if (delegates[funcId] != _delegate) {
1723                     delegates[funcId] = _delegate;
1724                     emit FunctionUpdate(funcId, oldDelegate, _delegate, string(signatures));
1725 
1726                 }
1727                 assembly {signatures := add(signatures,num)}
1728             }
1729         }
1730         emit CommitMessage(_commitMessage);
1731     }
1732 
1733     function _baseURI() internal view virtual override returns (string memory) {
1734       return baseURI;
1735     }
1736 
1737  /**
1738      * @dev See {IERC721Metadata-tokenURI}.
1739      */
1740     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1741         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1742 
1743         string memory baseURI = _baseURI();
1744         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1745     }
1746 
1747     ///////////////////////////////////////////////////////////////////////////////////////////////
1748 
1749 }
1750 
1751 ///////////////////////////////////////////////////////////////////////////////////////////////////