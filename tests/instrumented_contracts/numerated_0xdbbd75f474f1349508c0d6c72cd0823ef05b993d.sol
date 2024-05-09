1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292                 /// @solidity memory-safe-assembly
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
539 
540 
541 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Enumerable is IERC721 {
551     /**
552      * @dev Returns the total amount of tokens stored by the contract.
553      */
554     function totalSupply() external view returns (uint256);
555 
556     /**
557      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
558      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
559      */
560     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
561 
562     /**
563      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
564      * Use along with {totalSupply} to enumerate all tokens.
565      */
566     function tokenByIndex(uint256 index) external view returns (uint256);
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Metadata is IERC721 {
582     /**
583      * @dev Returns the token collection name.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594      */
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 // File: @openzeppelin/contracts/utils/Context.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Provides information about the current execution context, including the
607  * sender of the transaction and its data. While these are generally available
608  * via msg.sender and msg.data, they should not be accessed in such a direct
609  * manner, since when dealing with meta-transactions the account sending and
610  * paying for execution may not be the actual sender (as far as an application
611  * is concerned).
612  *
613  * This contract is only required for intermediate, library-like contracts.
614  */
615 abstract contract Context {
616     function _msgSender() internal view virtual returns (address) {
617         return msg.sender;
618     }
619 
620     function _msgData() internal view virtual returns (bytes calldata) {
621         return msg.data;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
626 
627 
628 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 
633 
634 
635 
636 
637 
638 
639 /**
640  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
641  * the Metadata extension, but not including the Enumerable extension, which is available separately as
642  * {ERC721Enumerable}.
643  */
644 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
645     using Address for address;
646     using Strings for uint256;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     // Mapping from token ID to owner address
655     mapping(uint256 => address) private _owners;
656 
657     // Mapping owner address to token count
658     mapping(address => uint256) private _balances;
659 
660     // Mapping from token ID to approved address
661     mapping(uint256 => address) private _tokenApprovals;
662 
663     // Mapping from owner to operator approvals
664     mapping(address => mapping(address => bool)) private _operatorApprovals;
665 
666     /**
667      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
668      */
669     constructor(string memory name_, string memory symbol_) {
670         _name = name_;
671         _symbol = symbol_;
672     }
673 
674     /**
675      * @dev See {IERC165-supportsInterface}.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
678         return
679             interfaceId == type(IERC721).interfaceId ||
680             interfaceId == type(IERC721Metadata).interfaceId ||
681             super.supportsInterface(interfaceId);
682     }
683 
684     /**
685      * @dev See {IERC721-balanceOf}.
686      */
687     function balanceOf(address owner) public view virtual override returns (uint256) {
688         require(owner != address(0), "ERC721: address zero is not a valid owner");
689         return _balances[owner];
690     }
691 
692     /**
693      * @dev See {IERC721-ownerOf}.
694      */
695     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
696         address owner = _owners[tokenId];
697         require(owner != address(0), "ERC721: invalid token ID");
698         return owner;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-name}.
703      */
704     function name() public view virtual override returns (string memory) {
705         return _name;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-symbol}.
710      */
711     function symbol() public view virtual override returns (string memory) {
712         return _symbol;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-tokenURI}.
717      */
718     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
719         _requireMinted(tokenId);
720 
721         string memory baseURI = _baseURI();
722         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
723     }
724 
725     /**
726      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
727      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
728      * by default, can be overridden in child contracts.
729      */
730     function _baseURI() internal view virtual returns (string memory) {
731         return "";
732     }
733 
734     /**
735      * @dev See {IERC721-approve}.
736      */
737     function approve(address to, uint256 tokenId) public virtual override {
738         address owner = ERC721.ownerOf(tokenId);
739         require(to != owner, "ERC721: approval to current owner");
740 
741         require(
742             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
743             "ERC721: approve caller is not token owner nor approved for all"
744         );
745 
746         _approve(to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-getApproved}.
751      */
752     function getApproved(uint256 tokenId) public view virtual override returns (address) {
753         _requireMinted(tokenId);
754 
755         return _tokenApprovals[tokenId];
756     }
757 
758     /**
759      * @dev See {IERC721-setApprovalForAll}.
760      */
761     function setApprovalForAll(address operator, bool approved) public virtual override {
762         _setApprovalForAll(_msgSender(), operator, approved);
763     }
764 
765     /**
766      * @dev See {IERC721-isApprovedForAll}.
767      */
768     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
769         return _operatorApprovals[owner][operator];
770     }
771 
772     /**
773      * @dev See {IERC721-transferFrom}.
774      */
775     function transferFrom(
776         address from,
777         address to,
778         uint256 tokenId
779     ) public virtual override {
780         //solhint-disable-next-line max-line-length
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
782 
783         _transfer(from, to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-safeTransferFrom}.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) public virtual override {
794         safeTransferFrom(from, to, tokenId, "");
795     }
796 
797     /**
798      * @dev See {IERC721-safeTransferFrom}.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory data
805     ) public virtual override {
806         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
807         _safeTransfer(from, to, tokenId, data);
808     }
809 
810     /**
811      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
812      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
813      *
814      * `data` is additional data, it has no specified format and it is sent in call to `to`.
815      *
816      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
817      * implement alternative mechanisms to perform token transfer, such as signature-based.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must exist and be owned by `from`.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeTransfer(
829         address from,
830         address to,
831         uint256 tokenId,
832         bytes memory data
833     ) internal virtual {
834         _transfer(from, to, tokenId);
835         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
836     }
837 
838     /**
839      * @dev Returns whether `tokenId` exists.
840      *
841      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
842      *
843      * Tokens start existing when they are minted (`_mint`),
844      * and stop existing when they are burned (`_burn`).
845      */
846     function _exists(uint256 tokenId) internal view virtual returns (bool) {
847         return _owners[tokenId] != address(0);
848     }
849 
850     /**
851      * @dev Returns whether `spender` is allowed to manage `tokenId`.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
858         address owner = ERC721.ownerOf(tokenId);
859         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
860     }
861 
862     /**
863      * @dev Safely mints `tokenId` and transfers it to `to`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _safeMint(address to, uint256 tokenId) internal virtual {
873         _safeMint(to, tokenId, "");
874     }
875 
876     /**
877      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
878      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
879      */
880     function _safeMint(
881         address to,
882         uint256 tokenId,
883         bytes memory data
884     ) internal virtual {
885         _mint(to, tokenId);
886         require(
887             _checkOnERC721Received(address(0), to, tokenId, data),
888             "ERC721: transfer to non ERC721Receiver implementer"
889         );
890     }
891 
892     /**
893      * @dev Mints `tokenId` and transfers it to `to`.
894      *
895      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - `to` cannot be the zero address.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _mint(address to, uint256 tokenId) internal virtual {
905         require(to != address(0), "ERC721: mint to the zero address");
906         require(!_exists(tokenId), "ERC721: token already minted");
907 
908         _beforeTokenTransfer(address(0), to, tokenId);
909 
910         _balances[to] += 1;
911         _owners[tokenId] = to;
912 
913         emit Transfer(address(0), to, tokenId);
914 
915         _afterTokenTransfer(address(0), to, tokenId);
916     }
917 
918     /**
919      * @dev Destroys `tokenId`.
920      * The approval is cleared when the token is burned.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _burn(uint256 tokenId) internal virtual {
929         address owner = ERC721.ownerOf(tokenId);
930 
931         _beforeTokenTransfer(owner, address(0), tokenId);
932 
933         // Clear approvals
934         _approve(address(0), tokenId);
935 
936         _balances[owner] -= 1;
937         delete _owners[tokenId];
938 
939         emit Transfer(owner, address(0), tokenId);
940 
941         _afterTokenTransfer(owner, address(0), tokenId);
942     }
943 
944     /**
945      * @dev Transfers `tokenId` from `from` to `to`.
946      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
947      *
948      * Requirements:
949      *
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must be owned by `from`.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _transfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual {
960         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
961         require(to != address(0), "ERC721: transfer to the zero address");
962 
963         _beforeTokenTransfer(from, to, tokenId);
964 
965         // Clear approvals from the previous owner
966         _approve(address(0), tokenId);
967 
968         _balances[from] -= 1;
969         _balances[to] += 1;
970         _owners[tokenId] = to;
971 
972         emit Transfer(from, to, tokenId);
973 
974         _afterTokenTransfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev Approve `to` to operate on `tokenId`
979      *
980      * Emits an {Approval} event.
981      */
982     function _approve(address to, uint256 tokenId) internal virtual {
983         _tokenApprovals[tokenId] = to;
984         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
985     }
986 
987     /**
988      * @dev Approve `operator` to operate on all of `owner` tokens
989      *
990      * Emits an {ApprovalForAll} event.
991      */
992     function _setApprovalForAll(
993         address owner,
994         address operator,
995         bool approved
996     ) internal virtual {
997         require(owner != operator, "ERC721: approve to caller");
998         _operatorApprovals[owner][operator] = approved;
999         emit ApprovalForAll(owner, operator, approved);
1000     }
1001 
1002     /**
1003      * @dev Reverts if the `tokenId` has not been minted yet.
1004      */
1005     function _requireMinted(uint256 tokenId) internal view virtual {
1006         require(_exists(tokenId), "ERC721: invalid token ID");
1007     }
1008 
1009     /**
1010      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1011      * The call is not executed if the target address is not a contract.
1012      *
1013      * @param from address representing the previous owner of the given token ID
1014      * @param to target address that will receive the tokens
1015      * @param tokenId uint256 ID of the token to be transferred
1016      * @param data bytes optional data to send along with the call
1017      * @return bool whether the call correctly returned the expected magic value
1018      */
1019     function _checkOnERC721Received(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory data
1024     ) private returns (bool) {
1025         if (to.isContract()) {
1026             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1027                 return retval == IERC721Receiver.onERC721Received.selector;
1028             } catch (bytes memory reason) {
1029                 if (reason.length == 0) {
1030                     revert("ERC721: transfer to non ERC721Receiver implementer");
1031                 } else {
1032                     /// @solidity memory-safe-assembly
1033                     assembly {
1034                         revert(add(32, reason), mload(reason))
1035                     }
1036                 }
1037             }
1038         } else {
1039             return true;
1040         }
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before any token transfer. This includes minting
1045      * and burning.
1046      *
1047      * Calling conditions:
1048      *
1049      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1050      * transferred to `to`.
1051      * - When `from` is zero, `tokenId` will be minted for `to`.
1052      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1053      * - `from` and `to` are never both zero.
1054      *
1055      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1056      */
1057     function _beforeTokenTransfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual {}
1062 
1063     /**
1064      * @dev Hook that is called after any transfer of tokens. This includes
1065      * minting and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - when `from` and `to` are both non-zero.
1070      * - `from` and `to` are never both zero.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _afterTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual {}
1079 }
1080 
1081 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1082 
1083 
1084 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 
1089 
1090 /**
1091  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1092  * enumerability of all the token ids in the contract as well as all token ids owned by each
1093  * account.
1094  */
1095 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1096     // Mapping from owner to list of owned token IDs
1097     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1098 
1099     // Mapping from token ID to index of the owner tokens list
1100     mapping(uint256 => uint256) private _ownedTokensIndex;
1101 
1102     // Array with all token ids, used for enumeration
1103     uint256[] private _allTokens;
1104 
1105     // Mapping from token id to position in the allTokens array
1106     mapping(uint256 => uint256) private _allTokensIndex;
1107 
1108     /**
1109      * @dev See {IERC165-supportsInterface}.
1110      */
1111     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1112         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1119         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1120         return _ownedTokens[owner][index];
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-totalSupply}.
1125      */
1126     function totalSupply() public view virtual override returns (uint256) {
1127         return _allTokens.length;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Enumerable-tokenByIndex}.
1132      */
1133     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1134         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1135         return _allTokens[index];
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before any token transfer. This includes minting
1140      * and burning.
1141      *
1142      * Calling conditions:
1143      *
1144      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1145      * transferred to `to`.
1146      * - When `from` is zero, `tokenId` will be minted for `to`.
1147      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual override {
1158         super._beforeTokenTransfer(from, to, tokenId);
1159 
1160         if (from == address(0)) {
1161             _addTokenToAllTokensEnumeration(tokenId);
1162         } else if (from != to) {
1163             _removeTokenFromOwnerEnumeration(from, tokenId);
1164         }
1165         if (to == address(0)) {
1166             _removeTokenFromAllTokensEnumeration(tokenId);
1167         } else if (to != from) {
1168             _addTokenToOwnerEnumeration(to, tokenId);
1169         }
1170     }
1171 
1172     /**
1173      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1174      * @param to address representing the new owner of the given token ID
1175      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1176      */
1177     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1178         uint256 length = ERC721.balanceOf(to);
1179         _ownedTokens[to][length] = tokenId;
1180         _ownedTokensIndex[tokenId] = length;
1181     }
1182 
1183     /**
1184      * @dev Private function to add a token to this extension's token tracking data structures.
1185      * @param tokenId uint256 ID of the token to be added to the tokens list
1186      */
1187     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1188         _allTokensIndex[tokenId] = _allTokens.length;
1189         _allTokens.push(tokenId);
1190     }
1191 
1192     /**
1193      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1194      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1195      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1196      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1197      * @param from address representing the previous owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1199      */
1200     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1201         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1202         // then delete the last slot (swap and pop).
1203 
1204         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1205         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1206 
1207         // When the token to delete is the last token, the swap operation is unnecessary
1208         if (tokenIndex != lastTokenIndex) {
1209             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1210 
1211             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213         }
1214 
1215         // This also deletes the contents at the last position of the array
1216         delete _ownedTokensIndex[tokenId];
1217         delete _ownedTokens[from][lastTokenIndex];
1218     }
1219 
1220     /**
1221      * @dev Private function to remove a token from this extension's token tracking data structures.
1222      * This has O(1) time complexity, but alters the order of the _allTokens array.
1223      * @param tokenId uint256 ID of the token to be removed from the tokens list
1224      */
1225     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1226         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1227         // then delete the last slot (swap and pop).
1228 
1229         uint256 lastTokenIndex = _allTokens.length - 1;
1230         uint256 tokenIndex = _allTokensIndex[tokenId];
1231 
1232         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1233         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1234         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1235         uint256 lastTokenId = _allTokens[lastTokenIndex];
1236 
1237         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1238         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1239 
1240         // This also deletes the contents at the last position of the array
1241         delete _allTokensIndex[tokenId];
1242         _allTokens.pop();
1243     }
1244 }
1245 
1246 // File: @openzeppelin/contracts/access/Ownable.sol
1247 
1248 
1249 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 
1254 /**
1255  * @dev Contract module which provides a basic access control mechanism, where
1256  * there is an account (an owner) that can be granted exclusive access to
1257  * specific functions.
1258  *
1259  * By default, the owner account will be the one that deploys the contract. This
1260  * can later be changed with {transferOwnership}.
1261  *
1262  * This module is used through inheritance. It will make available the modifier
1263  * `onlyOwner`, which can be applied to your functions to restrict their use to
1264  * the owner.
1265  */
1266 abstract contract Ownable is Context {
1267     address private _owner;
1268 
1269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1270 
1271     /**
1272      * @dev Initializes the contract setting the deployer as the initial owner.
1273      */
1274     constructor() {
1275         _transferOwnership(_msgSender());
1276     }
1277 
1278     /**
1279      * @dev Throws if called by any account other than the owner.
1280      */
1281     modifier onlyOwner() {
1282         _checkOwner();
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Returns the address of the current owner.
1288      */
1289     function owner() public view virtual returns (address) {
1290         return _owner;
1291     }
1292 
1293     /**
1294      * @dev Throws if the sender is not the owner.
1295      */
1296     function _checkOwner() internal view virtual {
1297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1298     }
1299 
1300     /**
1301      * @dev Leaves the contract without owner. It will not be possible to call
1302      * `onlyOwner` functions anymore. Can only be called by the current owner.
1303      *
1304      * NOTE: Renouncing ownership will leave the contract without an owner,
1305      * thereby removing any functionality that is only available to the owner.
1306      */
1307     function renounceOwnership() public virtual onlyOwner {
1308         _transferOwnership(address(0));
1309     }
1310 
1311     /**
1312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1313      * Can only be called by the current owner.
1314      */
1315     function transferOwnership(address newOwner) public virtual onlyOwner {
1316         require(newOwner != address(0), "Ownable: new owner is the zero address");
1317         _transferOwnership(newOwner);
1318     }
1319 
1320     /**
1321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1322      * Internal function without access restriction.
1323      */
1324     function _transferOwnership(address newOwner) internal virtual {
1325         address oldOwner = _owner;
1326         _owner = newOwner;
1327         emit OwnershipTransferred(oldOwner, newOwner);
1328     }
1329 }
1330 
1331 // File: contracts/Def3cts.sol
1332 
1333 
1334 
1335 pragma solidity >=0.7.0 <0.9.0;
1336 
1337 
1338 
1339 contract Def3cts is ERC721Enumerable, Ownable {
1340   using Strings for uint256;
1341 
1342   // baseURI is the root URI of the metadata files
1343   string baseURI;
1344 
1345   // List of addresses that have been whitelisted and the amount
1346   mapping(address => uint256) private whitelistedAddresses;
1347 
1348   // List of addresses that have minted the (almost) free nft
1349   mapping(address => uint256) private almostFreeAddresses;
1350 
1351   // Usual NFT mint contract variables
1352   string public baseExtension = ".json";
1353   uint256 public normalCost = 0.02 ether;
1354   uint256 public almostFreeCost = 0.008 ether;
1355   uint256 public maxSupply = 8888;
1356   uint256 public maxMintAmount = 20;
1357   bool public mintPaused = true;
1358   bool public whitelistOnly = true;
1359   bool public revealed = false;
1360   string public notRevealedUri;
1361 
1362   constructor(
1363     string memory _name,
1364     string memory _symbol,
1365     string memory _initBaseURI,
1366     string memory _initNotRevealedUri
1367   ) ERC721(_name, _symbol) {
1368     // Sets our initial base URI.
1369     setBaseURI(_initBaseURI);
1370 
1371     // Sets our initial unrevealed URI
1372     setNotRevealedURI(_initNotRevealedUri);
1373   }
1374 
1375   // Internal method used to retrieve the baseURI based on the evolution of the token
1376   function _baseURI() internal view virtual override returns (string memory) {
1377     return baseURI;
1378   }
1379 
1380   // Main mint method that will be called to create the tokens
1381   function mint(uint256 _mintAmount) public payable {
1382     uint256 supply = totalSupply();
1383     require(!mintPaused, "Mint is paused");
1384     require(_mintAmount > 0, "Mint amount must be positive");
1385     require(_mintAmount <= maxMintAmount, "Mint amount must be less than max mint amount");
1386     require(supply + _mintAmount <= maxSupply, "Supply + mint amount must be less than max supply");
1387 
1388     // If the whitelist is enabled, only allow the whitelisted user to mint
1389     if (whitelistOnly) {
1390       require(whitelistedAddresses[msg.sender] >= _mintAmount, "Not whitelisted or not enough tokens allowed");
1391     }
1392 
1393     // Determine the amount of whitelist that can be minted
1394     uint256 whitelistAmount = whitelistedAddresses[msg.sender];
1395 
1396     // Determine the amount of almost free that can be minted
1397     uint256 almostFreeAmount = 1 - almostFreeAddresses[msg.sender];
1398 
1399     // We determine the normal amount, cannot be below 0
1400     uint256 normalAmount = 0;
1401 
1402     // We only want to mint the almostFree if needed
1403     if (_mintAmount <= whitelistAmount) {
1404       almostFreeAmount = 0;
1405     }
1406     
1407     // We determine the normal amount if needed
1408     if (_mintAmount > whitelistAmount + almostFreeAmount) {
1409       normalAmount = _mintAmount - (whitelistAmount + almostFreeAmount);
1410     }
1411 
1412     // We find out the price needed to mint the _mintAmount
1413     uint256 price = (normalCost * normalAmount) + (almostFreeCost * almostFreeAmount);
1414 
1415     // We must remove the whitelisted amount
1416     uint256 whitelistToRemove = _mintAmount > whitelistAmount ? whitelistAmount : _mintAmount;
1417     whitelistedAddresses[msg.sender] -= whitelistToRemove;
1418 
1419     // We must remove the almostFree amount
1420     uint256 almostFreeToRemove = almostFreeAmount == 1 ? 1 : 0;
1421     almostFreeAddresses[msg.sender] = almostFreeToRemove;
1422 
1423     // Owners don't have to pay for the tokens
1424     if (msg.sender != owner()) {
1425       require(msg.value >= price, "Not enough ether to mint");
1426     }
1427 
1428     // Loop through the requested amount to mint and mint the tokens
1429     for (uint256 i = 1; i <= _mintAmount; i++) {
1430       uint256 newItemId = supply + i;
1431       _safeMint(msg.sender, newItemId);
1432     }
1433   }
1434 
1435   // Tells us the price for an address and an amount of tokens
1436   function calculatePrice(address _user, uint256 _mintAmount) public view returns (uint256) {
1437     // Determine the amount of whitelist that can be minted
1438     uint256 whitelistAmount = whitelistedAddresses[_user];
1439 
1440     // Determine the amount of almost free that can be minted
1441     uint256 almostFreeAmount = 1 - almostFreeAddresses[_user];
1442 
1443     // We determine the normal amount, cannot be below 0
1444     uint256 normalAmount = 0;
1445 
1446     // We only want to mint the almostFree if needed
1447     if (_mintAmount <= whitelistAmount) {
1448       almostFreeAmount = 0;
1449     }
1450 
1451     // We determine the normal amount if needed
1452     if (_mintAmount > whitelistAmount + almostFreeAmount) {
1453       normalAmount = _mintAmount - (whitelistAmount + almostFreeAmount);
1454     }
1455 
1456     // We find out the price needed to mint the _mintAmount
1457     uint256 price = (normalCost * normalAmount) + (almostFreeCost * almostFreeAmount);
1458 
1459     return price;
1460   }
1461 
1462   // Tells us the amount of tokens the address can mint
1463   function getWhitelistAmount(address _user) public view returns (uint256) {
1464     return whitelistedAddresses[_user];
1465   }
1466 
1467   // Tells us if an address has mint there (almost) free nft
1468   function getAlmostFreeAmount(address _user) public view returns (uint256) {
1469     return almostFreeAddresses[_user];
1470   }
1471 
1472   // Adds users to the whitelist for a specific amount of tokens
1473   function setWhitelist(address[] calldata addresses, uint256 numAllowedToMint) external onlyOwner {
1474     for (uint256 i = 0; i < addresses.length; i++) {
1475       whitelistedAddresses[addresses[i]] = numAllowedToMint;
1476     }
1477   }
1478 
1479   // Retrieved all the tokens IDs for an Ethereum address
1480   function walletOfOwner(address _owner)
1481     public
1482     view
1483     returns (uint256[] memory)
1484   {
1485     uint256 ownerTokenCount = balanceOf(_owner);
1486     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1487     for (uint256 i; i < ownerTokenCount; i++) {
1488       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1489     }
1490     return tokenIds;
1491   }
1492 
1493   // Retrieve the tokenURI for a specific token ID
1494   function tokenURI(uint256 tokenId)
1495     public
1496     view
1497     virtual
1498     override
1499     returns (string memory)
1500   {
1501     require(
1502       _exists(tokenId),
1503       "ERC721Metadata: URI query for nonexistent token"
1504     );
1505     
1506     // If the collection is still unrevealed, return generic metadata
1507     if (revealed == false) {
1508         return notRevealedUri;
1509     }
1510 
1511     // Retrieve the baseURI of the token
1512     string memory currentBaseURI = _baseURI();
1513 
1514     return bytes(currentBaseURI).length > 0
1515         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1516         : "";
1517   }
1518 
1519   // Reveals the collection and makes metadata accessible
1520   function reveal() public onlyOwner() {
1521     revealed = true;
1522   }
1523 
1524   // Unreveal the collection and makes metadata hidden
1525   function unreveal() public onlyOwner() {
1526     revealed = false;
1527   }
1528 
1529   // Sets the normal costs of the minting
1530   function setNormalCost(uint256 _newCost) public onlyOwner() {
1531     normalCost = _newCost;
1532   }
1533 
1534   // Sets the free costs of the minting
1535   function setAlmostFreeCost(uint256 _newCost) public onlyOwner() {
1536     almostFreeCost = _newCost;
1537   }
1538 
1539   // Sets the maximum amount of tokens that can be minted in one transaction
1540   function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner() {
1541     maxMintAmount = _newMaxMintAmount;
1542   }
1543 
1544   // Sets the unrevealed URI for the collection
1545   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1546     notRevealedUri = _notRevealedURI;
1547   }
1548 
1549   // Sets the baseURI
1550   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1551     baseURI = _newBaseURI;
1552   }
1553 
1554   // Sets the base extension of the collection
1555   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1556     baseExtension = _newBaseExtension;
1557   }
1558 
1559   // Sets the paused state for the mint of the collection
1560   function mintPause(bool _state) public onlyOwner {
1561     mintPaused = _state;
1562   }
1563 
1564   // Sets the paused state for the whitelist
1565   function setWhitelistOnly(bool _state) public onlyOwner {
1566     whitelistOnly = _state;
1567   }
1568 
1569   // Withdraws the funds from the contract
1570   function withdraw() public payable onlyOwner {
1571     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1572     require(success);
1573   }
1574 }