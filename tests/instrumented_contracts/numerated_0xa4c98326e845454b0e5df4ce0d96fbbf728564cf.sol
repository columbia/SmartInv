1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Address.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
86 
87 pragma solidity ^0.8.1;
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      *
110      * [IMPORTANT]
111      * ====
112      * You shouldn't rely on `isContract` to protect against flash loan attacks!
113      *
114      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
115      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
116      * constructor.
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize/address.code.length, which returns 0
121         // for contracts in construction, since the code is only stored at the end
122         // of the constructor execution.
123 
124         return account.code.length > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295                 /// @solidity memory-safe-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
308 
309 
310 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @title ERC721 token receiver interface
316  * @dev Interface for any contract that wants to support safeTransfers
317  * from ERC721 asset contracts.
318  */
319 interface IERC721Receiver {
320     /**
321      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
322      * by `operator` from `from`, this function is called.
323      *
324      * It must return its Solidity selector to confirm the token transfer.
325      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
326      *
327      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
328      */
329     function onERC721Received(
330         address operator,
331         address from,
332         uint256 tokenId,
333         bytes calldata data
334     ) external returns (bytes4);
335 }
336 
337 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Interface of the ERC165 standard, as defined in the
346  * https://eips.ethereum.org/EIPS/eip-165[EIP].
347  *
348  * Implementers can declare support of contract interfaces, which can then be
349  * queried by others ({ERC165Checker}).
350  *
351  * For an implementation, see {ERC165}.
352  */
353 interface IERC165 {
354     /**
355      * @dev Returns true if this contract implements the interface defined by
356      * `interfaceId`. See the corresponding
357      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
358      * to learn more about how these ids are created.
359      *
360      * This function call must use less than 30 000 gas.
361      */
362     function supportsInterface(bytes4 interfaceId) external view returns (bool);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Implementation of the {IERC165} interface.
375  *
376  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
377  * for the additional interface id that will be supported. For example:
378  *
379  * ```solidity
380  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
382  * }
383  * ```
384  *
385  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
386  */
387 abstract contract ERC165 is IERC165 {
388     /**
389      * @dev See {IERC165-supportsInterface}.
390      */
391     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392         return interfaceId == type(IERC165).interfaceId;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
397 
398 
399 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Required interface of an ERC721 compliant contract.
406  */
407 interface IERC721 is IERC165 {
408     /**
409      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
415      */
416     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
420      */
421     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
422 
423     /**
424      * @dev Returns the number of tokens in ``owner``'s account.
425      */
426     function balanceOf(address owner) external view returns (uint256 balance);
427 
428     /**
429      * @dev Returns the owner of the `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function ownerOf(uint256 tokenId) external view returns (address owner);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes calldata data
455     ) external;
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Transfers `tokenId` token from `from` to `to`.
479      *
480      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must be owned by `from`.
487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
499      * The approval is cleared when the token is transferred.
500      *
501      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
502      *
503      * Requirements:
504      *
505      * - The caller must own the token or be an approved operator.
506      * - `tokenId` must exist.
507      *
508      * Emits an {Approval} event.
509      */
510     function approve(address to, uint256 tokenId) external;
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns the account approved for `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function getApproved(uint256 tokenId) external view returns (address operator);
532 
533     /**
534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
535      *
536      * See {setApprovalForAll}
537      */
538     function isApprovedForAll(address owner, address operator) external view returns (bool);
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
551  * @dev See https://eips.ethereum.org/EIPS/eip-721
552  */
553 interface IERC721Metadata is IERC721 {
554     /**
555      * @dev Returns the token collection name.
556      */
557     function name() external view returns (string memory);
558 
559     /**
560      * @dev Returns the token collection symbol.
561      */
562     function symbol() external view returns (string memory);
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view returns (string memory);
568 }
569 
570 // File: @openzeppelin/contracts/utils/Context.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Provides information about the current execution context, including the
579  * sender of the transaction and its data. While these are generally available
580  * via msg.sender and msg.data, they should not be accessed in such a direct
581  * manner, since when dealing with meta-transactions the account sending and
582  * paying for execution may not be the actual sender (as far as an application
583  * is concerned).
584  *
585  * This contract is only required for intermediate, library-like contracts.
586  */
587 abstract contract Context {
588     function _msgSender() internal view virtual returns (address) {
589         return msg.sender;
590     }
591 
592     function _msgData() internal view virtual returns (bytes calldata) {
593         return msg.data;
594     }
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
598 
599 
600 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 
606 
607 
608 
609 
610 
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
613  * the Metadata extension, but not including the Enumerable extension, which is available separately as
614  * {ERC721Enumerable}.
615  */
616 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
617     using Address for address;
618     using Strings for uint256;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     // Mapping from token ID to owner address
627     mapping(uint256 => address) private _owners;
628 
629     // Mapping owner address to token count
630     mapping(address => uint256) private _balances;
631 
632     // Mapping from token ID to approved address
633     mapping(uint256 => address) private _tokenApprovals;
634 
635     // Mapping from owner to operator approvals
636     mapping(address => mapping(address => bool)) private _operatorApprovals;
637 
638     /**
639      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
640      */
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644     }
645 
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
650         return
651             interfaceId == type(IERC721).interfaceId ||
652             interfaceId == type(IERC721Metadata).interfaceId ||
653             super.supportsInterface(interfaceId);
654     }
655 
656     /**
657      * @dev See {IERC721-balanceOf}.
658      */
659     function balanceOf(address owner) public view virtual override returns (uint256) {
660         require(owner != address(0), "ERC721: address zero is not a valid owner");
661         return _balances[owner];
662     }
663 
664     /**
665      * @dev See {IERC721-ownerOf}.
666      */
667     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
668         address owner = _owners[tokenId];
669         require(owner != address(0), "ERC721: invalid token ID");
670         return owner;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-name}.
675      */
676     function name() public view virtual override returns (string memory) {
677         return _name;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-symbol}.
682      */
683     function symbol() public view virtual override returns (string memory) {
684         return _symbol;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-tokenURI}.
689      */
690     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
691         _requireMinted(tokenId);
692 
693         string memory baseURI = _baseURI();
694         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
695     }
696 
697     /**
698      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
699      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
700      * by default, can be overridden in child contracts.
701      */
702     function _baseURI() internal view virtual returns (string memory) {
703         return "";
704     }
705 
706     /**
707      * @dev See {IERC721-approve}.
708      */
709     function approve(address to, uint256 tokenId) public virtual override {
710         address owner = ERC721.ownerOf(tokenId);
711         require(to != owner, "ERC721: approval to current owner");
712 
713         require(
714             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
715             "ERC721: approve caller is not token owner nor approved for all"
716         );
717 
718         _approve(to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-getApproved}.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         _requireMinted(tokenId);
726 
727         return _tokenApprovals[tokenId];
728     }
729 
730     /**
731      * @dev See {IERC721-setApprovalForAll}.
732      */
733     function setApprovalForAll(address operator, bool approved) public virtual override {
734         _setApprovalForAll(_msgSender(), operator, approved);
735     }
736 
737     /**
738      * @dev See {IERC721-isApprovedForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[owner][operator];
742     }
743 
744     /**
745      * @dev See {IERC721-transferFrom}.
746      */
747     function transferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         //solhint-disable-next-line max-line-length
753         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
754 
755         _transfer(from, to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId
765     ) public virtual override {
766         safeTransferFrom(from, to, tokenId, "");
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory data
777     ) public virtual override {
778         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
779         _safeTransfer(from, to, tokenId, data);
780     }
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
784      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
785      *
786      * `data` is additional data, it has no specified format and it is sent in call to `to`.
787      *
788      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
789      * implement alternative mechanisms to perform token transfer, such as signature-based.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _safeTransfer(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory data
805     ) internal virtual {
806         _transfer(from, to, tokenId);
807         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
808     }
809 
810     /**
811      * @dev Returns whether `tokenId` exists.
812      *
813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
814      *
815      * Tokens start existing when they are minted (`_mint`),
816      * and stop existing when they are burned (`_burn`).
817      */
818     function _exists(uint256 tokenId) internal view virtual returns (bool) {
819         return _owners[tokenId] != address(0);
820     }
821 
822     /**
823      * @dev Returns whether `spender` is allowed to manage `tokenId`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
830         address owner = ERC721.ownerOf(tokenId);
831         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
832     }
833 
834     /**
835      * @dev Safely mints `tokenId` and transfers it to `to`.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must not exist.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _safeMint(address to, uint256 tokenId) internal virtual {
845         _safeMint(to, tokenId, "");
846     }
847 
848     /**
849      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
850      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
851      */
852     function _safeMint(
853         address to,
854         uint256 tokenId,
855         bytes memory data
856     ) internal virtual {
857         _mint(to, tokenId);
858         require(
859             _checkOnERC721Received(address(0), to, tokenId, data),
860             "ERC721: transfer to non ERC721Receiver implementer"
861         );
862     }
863 
864     /**
865      * @dev Mints `tokenId` and transfers it to `to`.
866      *
867      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
868      *
869      * Requirements:
870      *
871      * - `tokenId` must not exist.
872      * - `to` cannot be the zero address.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _mint(address to, uint256 tokenId) internal virtual {
877         require(to != address(0), "ERC721: mint to the zero address");
878         require(!_exists(tokenId), "ERC721: token already minted");
879 
880         _beforeTokenTransfer(address(0), to, tokenId);
881 
882         _balances[to] += 1;
883         _owners[tokenId] = to;
884 
885         emit Transfer(address(0), to, tokenId);
886 
887         _afterTokenTransfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _burn(uint256 tokenId) internal virtual {
901         address owner = ERC721.ownerOf(tokenId);
902 
903         _beforeTokenTransfer(owner, address(0), tokenId);
904 
905         // Clear approvals
906         _approve(address(0), tokenId);
907 
908         _balances[owner] -= 1;
909         delete _owners[tokenId];
910 
911         emit Transfer(owner, address(0), tokenId);
912 
913         _afterTokenTransfer(owner, address(0), tokenId);
914     }
915 
916     /**
917      * @dev Transfers `tokenId` from `from` to `to`.
918      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
919      *
920      * Requirements:
921      *
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must be owned by `from`.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _transfer(
928         address from,
929         address to,
930         uint256 tokenId
931     ) internal virtual {
932         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
933         require(to != address(0), "ERC721: transfer to the zero address");
934 
935         _beforeTokenTransfer(from, to, tokenId);
936 
937         // Clear approvals from the previous owner
938         _approve(address(0), tokenId);
939 
940         _balances[from] -= 1;
941         _balances[to] += 1;
942         _owners[tokenId] = to;
943 
944         emit Transfer(from, to, tokenId);
945 
946         _afterTokenTransfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `to` to operate on `tokenId`
951      *
952      * Emits an {Approval} event.
953      */
954     function _approve(address to, uint256 tokenId) internal virtual {
955         _tokenApprovals[tokenId] = to;
956         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
957     }
958 
959     /**
960      * @dev Approve `operator` to operate on all of `owner` tokens
961      *
962      * Emits an {ApprovalForAll} event.
963      */
964     function _setApprovalForAll(
965         address owner,
966         address operator,
967         bool approved
968     ) internal virtual {
969         require(owner != operator, "ERC721: approve to caller");
970         _operatorApprovals[owner][operator] = approved;
971         emit ApprovalForAll(owner, operator, approved);
972     }
973 
974     /**
975      * @dev Reverts if the `tokenId` has not been minted yet.
976      */
977     function _requireMinted(uint256 tokenId) internal view virtual {
978         require(_exists(tokenId), "ERC721: invalid token ID");
979     }
980 
981     /**
982      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
983      * The call is not executed if the target address is not a contract.
984      *
985      * @param from address representing the previous owner of the given token ID
986      * @param to target address that will receive the tokens
987      * @param tokenId uint256 ID of the token to be transferred
988      * @param data bytes optional data to send along with the call
989      * @return bool whether the call correctly returned the expected magic value
990      */
991     function _checkOnERC721Received(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory data
996     ) private returns (bool) {
997         if (to.isContract()) {
998             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
999                 return retval == IERC721Receiver.onERC721Received.selector;
1000             } catch (bytes memory reason) {
1001                 if (reason.length == 0) {
1002                     revert("ERC721: transfer to non ERC721Receiver implementer");
1003                 } else {
1004                     /// @solidity memory-safe-assembly
1005                     assembly {
1006                         revert(add(32, reason), mload(reason))
1007                     }
1008                 }
1009             }
1010         } else {
1011             return true;
1012         }
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` and `to` are never both zero.
1026      *
1027      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1028      */
1029     function _beforeTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {}
1034 
1035     /**
1036      * @dev Hook that is called after any transfer of tokens. This includes
1037      * minting and burning.
1038      *
1039      * Calling conditions:
1040      *
1041      * - when `from` and `to` are both non-zero.
1042      * - `from` and `to` are never both zero.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _afterTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {}
1051 }
1052 
1053 // File: @openzeppelin/contracts/access/Ownable.sol
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 /**
1062  * @dev Contract module which provides a basic access control mechanism, where
1063  * there is an account (an owner) that can be granted exclusive access to
1064  * specific functions.
1065  *
1066  * By default, the owner account will be the one that deploys the contract. This
1067  * can later be changed with {transferOwnership}.
1068  *
1069  * This module is used through inheritance. It will make available the modifier
1070  * `onlyOwner`, which can be applied to your functions to restrict their use to
1071  * the owner.
1072  */
1073 abstract contract Ownable is Context {
1074     address private _owner;
1075 
1076     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1077 
1078     /**
1079      * @dev Initializes the contract setting the deployer as the initial owner.
1080      */
1081     constructor() {
1082         _transferOwnership(_msgSender());
1083     }
1084 
1085     /**
1086      * @dev Throws if called by any account other than the owner.
1087      */
1088     modifier onlyOwner() {
1089         _checkOwner();
1090         _;
1091     }
1092 
1093     /**
1094      * @dev Returns the address of the current owner.
1095      */
1096     function owner() public view virtual returns (address) {
1097         return _owner;
1098     }
1099 
1100     /**
1101      * @dev Throws if the sender is not the owner.
1102      */
1103     function _checkOwner() internal view virtual {
1104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1105     }
1106 
1107     /**
1108      * @dev Leaves the contract without owner. It will not be possible to call
1109      * `onlyOwner` functions anymore. Can only be called by the current owner.
1110      *
1111      * NOTE: Renouncing ownership will leave the contract without an owner,
1112      * thereby removing any functionality that is only available to the owner.
1113      */
1114     function renounceOwnership() public virtual onlyOwner {
1115         _transferOwnership(address(0));
1116     }
1117 
1118     /**
1119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1120      * Can only be called by the current owner.
1121      */
1122     function transferOwnership(address newOwner) public virtual onlyOwner {
1123         require(newOwner != address(0), "Ownable: new owner is the zero address");
1124         _transferOwnership(newOwner);
1125     }
1126 
1127     /**
1128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1129      * Internal function without access restriction.
1130      */
1131     function _transferOwnership(address newOwner) internal virtual {
1132         address oldOwner = _owner;
1133         _owner = newOwner;
1134         emit OwnershipTransferred(oldOwner, newOwner);
1135     }
1136 }
1137 
1138 // File: contracts/CyberPandaz.sol
1139 
1140 
1141 
1142 pragma solidity ^0.8.4;
1143 
1144 
1145 
1146 contract CyberPandazGenesis is ERC721, Ownable { 
1147 
1148     using Strings for uint256;
1149 
1150     uint256 public constant MAX_TOKENS = 2004;
1151     uint256 public constant TOKENS_RESERVED = 0;
1152     uint256 public price = 0;
1153     uint256 public constant MAX_MINT_PER_TX = 1;
1154 
1155     bool public isSaleActive;
1156     uint256 public totalSupply;
1157     mapping(address => uint256) private mintedPerWallet;
1158 
1159     string public baseUri;
1160     string public baseExtension = ".json";
1161 
1162     constructor() ERC721("CyberPandaz Genesis", "CPG") {
1163 
1164     baseUri = "ipfs://QmbVGUrB6J9aw5shBbtGGPnCEtWj9hK459b9k7h6kYfBoh/";
1165     for (uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
1166         _safeMint(msg.sender, i);
1167     }
1168     totalSupply = TOKENS_RESERVED;
1169 }
1170 
1171     function mint(uint256 _numTokens) external payable {
1172         require(isSaleActive, "The sale is paused.");
1173         require(_numTokens <= MAX_MINT_PER_TX, "You can only mint 1 per transaction.");
1174         require(mintedPerWallet[msg.sender] + _numTokens <= 2, "You can only mint 2 per wallet.");
1175         uint256 curTotalSupply = totalSupply;
1176         require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds 'MAX TOKENS'");
1177         require(_numTokens * price <= msg.value, "Insufficient funds. You need more ETH");
1178 
1179         for (uint256 i = 1; i <= _numTokens; ++i) {
1180             _safeMint(msg.sender, curTotalSupply  +i);  
1181         }
1182         mintedPerWallet[msg.sender] += _numTokens;
1183         totalSupply += _numTokens;
1184     }
1185 
1186     function flipSaleState() external onlyOwner {
1187         isSaleActive = !isSaleActive;
1188     }
1189 
1190     function setBaseURI(string memory _baseUri) external onlyOwner {
1191         baseUri = _baseUri;
1192     }
1193 
1194     function withdrawAll() external payable onlyOwner {
1195         uint256 balance = address(this).balance;
1196         uint256 balanceOne = balance * 50 / 100;
1197         uint256 balanceTwo = balance * 50 / 100;
1198         (bool transferOne, ) = payable(0x31d1e1ADB221c6B1b2a0A7753dfb96e934eBaCc0).call{value: balanceOne}("");
1199         (bool transferTwo, ) = payable(0x31d1e1ADB221c6B1b2a0A7753dfb96e934eBaCc0).call{value: balanceTwo}("");
1200         require(transferOne && transferTwo, "Transfer Failed.");
1201     }
1202 
1203     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1204         require(
1205             _exists(tokenId),
1206             "ERC721Metadata: URI query for no token"
1207         );
1208 
1209         string memory currentBaseURI = _baseURI();
1210         return bytes(currentBaseURI).length > 0
1211         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1212         : "";
1213 
1214     }
1215 
1216     function _baseURI() internal view virtual override returns (string memory) {
1217         return baseUri;
1218         
1219     }
1220 
1221 }