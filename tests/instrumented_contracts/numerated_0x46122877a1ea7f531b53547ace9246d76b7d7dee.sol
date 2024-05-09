1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
166 /**
167  * @title ERC721 token receiver interface
168  * @dev Interface for any contract that wants to support safeTransfers
169  * from ERC721 asset contracts.
170  */
171 interface IERC721Receiver {
172     /**
173      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
174      * by `operator` from `from`, this function is called.
175      *
176      * It must return its Solidity selector to confirm the token transfer.
177      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
178      *
179      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
180      */
181     function onERC721Received(
182         address operator,
183         address from,
184         uint256 tokenId,
185         bytes calldata data
186     ) external returns (bytes4);
187 }
188 
189 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
211 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
212 /**
213  * @dev Collection of functions related to the address type
214  */
215 library Address {
216     /**
217      * @dev Returns true if `account` is a contract.
218      *
219      * [IMPORTANT]
220      * ====
221      * It is unsafe to assume that an address for which this function returns
222      * false is an externally-owned account (EOA) and not a contract.
223      *
224      * Among others, `isContract` will return false for the following
225      * types of addresses:
226      *
227      *  - an externally-owned account
228      *  - a contract in construction
229      *  - an address where a contract will be created
230      *  - an address where a contract lived, but was destroyed
231      * ====
232      *
233      * [IMPORTANT]
234      * ====
235      * You shouldn't rely on `isContract` to protect against flash loan attacks!
236      *
237      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
238      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
239      * constructor.
240      * ====
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies on extcodesize/address.code.length, which returns 0
244         // for contracts in construction, since the code is only stored at the end
245         // of the constructor execution.
246 
247         return account.code.length > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         (bool success, ) = recipient.call{value: amount}("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain `call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330      * with `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         require(isContract(target), "Address: call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.call{value: value}(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
354         return functionStaticCall(target, data, "Address: low-level static call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal view returns (bytes memory) {
368         require(isContract(target), "Address: static call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.staticcall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(isContract(target), "Address: delegate call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
403      * revert reason using the provided one.
404      *
405      * _Available since v4.3._
406      */
407     function verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) internal pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
431 /**
432  * @dev Provides information about the current execution context, including the
433  * sender of the transaction and its data. While these are generally available
434  * via msg.sender and msg.data, they should not be accessed in such a direct
435  * manner, since when dealing with meta-transactions the account sending and
436  * paying for execution may not be the actual sender (as far as an application
437  * is concerned).
438  *
439  * This contract is only required for intermediate, library-like contracts.
440  */
441 abstract contract Context {
442     function _msgSender() internal view virtual returns (address) {
443         return msg.sender;
444     }
445 
446     function _msgData() internal view virtual returns (bytes calldata) {
447         return msg.data;
448     }
449 }
450 
451 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
452 /**
453  * @dev String operations.
454  */
455 library Strings {
456     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
460      */
461     function toString(uint256 value) internal pure returns (string memory) {
462         // Inspired by OraclizeAPI's implementation - MIT licence
463         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
464 
465         if (value == 0) {
466             return "0";
467         }
468         uint256 temp = value;
469         uint256 digits;
470         while (temp != 0) {
471             digits++;
472             temp /= 10;
473         }
474         bytes memory buffer = new bytes(digits);
475         while (value != 0) {
476             digits -= 1;
477             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
478             value /= 10;
479         }
480         return string(buffer);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
485      */
486     function toHexString(uint256 value) internal pure returns (string memory) {
487         if (value == 0) {
488             return "0x00";
489         }
490         uint256 temp = value;
491         uint256 length = 0;
492         while (temp != 0) {
493             length++;
494             temp >>= 8;
495         }
496         return toHexString(value, length);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
501      */
502     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
503         bytes memory buffer = new bytes(2 * length + 2);
504         buffer[0] = "0";
505         buffer[1] = "x";
506         for (uint256 i = 2 * length + 1; i > 1; --i) {
507             buffer[i] = _HEX_SYMBOLS[value & 0xf];
508             value >>= 4;
509         }
510         require(value == 0, "Strings: hex length insufficient");
511         return string(buffer);
512     }
513 }
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
540 /**
541  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
542  * the Metadata extension, but not including the Enumerable extension, which is available separately as
543  * {ERC721Enumerable}.
544  */
545 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
546     using Address for address;
547     using Strings for uint256;
548 
549     // Token name
550     string private _name;
551 
552     // Token symbol
553     string private _symbol;
554 
555     // Mapping from token ID to owner address
556     mapping(uint256 => address) private _owners;
557 
558     // Mapping owner address to token count
559     mapping(address => uint256) private _balances;
560 
561     // Mapping from token ID to approved address
562     mapping(uint256 => address) private _tokenApprovals;
563 
564     // Mapping from owner to operator approvals
565     mapping(address => mapping(address => bool)) private _operatorApprovals;
566 
567     /**
568      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
569      */
570     constructor(string memory name_, string memory symbol_) {
571         _name = name_;
572         _symbol = symbol_;
573     }
574 
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
579         return
580             interfaceId == type(IERC721).interfaceId ||
581             interfaceId == type(IERC721Metadata).interfaceId ||
582             super.supportsInterface(interfaceId);
583     }
584 
585     /**
586      * @dev See {IERC721-balanceOf}.
587      */
588     function balanceOf(address owner) public view virtual override returns (uint256) {
589         require(owner != address(0), "ERC721: balance query for the zero address");
590         return _balances[owner];
591     }
592 
593     /**
594      * @dev See {IERC721-ownerOf}.
595      */
596     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
597         address owner = _owners[tokenId];
598         require(owner != address(0), "ERC721: owner query for nonexistent token");
599         return owner;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-name}.
604      */
605     function name() public view virtual override returns (string memory) {
606         return _name;
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-symbol}.
611      */
612     function symbol() public view virtual override returns (string memory) {
613         return _symbol;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-tokenURI}.
618      */
619     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
620         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
621 
622         string memory baseURI = _baseURI();
623         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
624     }
625 
626     /**
627      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
628      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
629      * by default, can be overriden in child contracts.
630      */
631     function _baseURI() internal view virtual returns (string memory) {
632         return "";
633     }
634 
635     /**
636      * @dev See {IERC721-approve}.
637      */
638     function approve(address to, uint256 tokenId) public virtual override {
639         address owner = ERC721.ownerOf(tokenId);
640         require(to != owner, "ERC721: approval to current owner");
641 
642         require(
643             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
644             "ERC721: approve caller is not owner nor approved for all"
645         );
646 
647         _approve(to, tokenId);
648     }
649 
650     /**
651      * @dev See {IERC721-getApproved}.
652      */
653     function getApproved(uint256 tokenId) public view virtual override returns (address) {
654         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
655 
656         return _tokenApprovals[tokenId];
657     }
658 
659     /**
660      * @dev See {IERC721-setApprovalForAll}.
661      */
662     function setApprovalForAll(address operator, bool approved) public virtual override {
663         _setApprovalForAll(_msgSender(), operator, approved);
664     }
665 
666     /**
667      * @dev See {IERC721-isApprovedForAll}.
668      */
669     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
670         return _operatorApprovals[owner][operator];
671     }
672 
673     /**
674      * @dev See {IERC721-transferFrom}.
675      */
676     function transferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) public virtual override {
681         //solhint-disable-next-line max-line-length
682         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
683 
684         _transfer(from, to, tokenId);
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public virtual override {
695         safeTransferFrom(from, to, tokenId, "");
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes memory _data
706     ) public virtual override {
707         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
708         _safeTransfer(from, to, tokenId, _data);
709     }
710 
711     /**
712      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
713      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
714      *
715      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
716      *
717      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
718      * implement alternative mechanisms to perform token transfer, such as signature-based.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
726      *
727      * Emits a {Transfer} event.
728      */
729     function _safeTransfer(
730         address from,
731         address to,
732         uint256 tokenId,
733         bytes memory _data
734     ) internal virtual {
735         _transfer(from, to, tokenId);
736         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
737     }
738 
739     /**
740      * @dev Returns whether `tokenId` exists.
741      *
742      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
743      *
744      * Tokens start existing when they are minted (`_mint`),
745      * and stop existing when they are burned (`_burn`).
746      */
747     function _exists(uint256 tokenId) internal view virtual returns (bool) {
748         return _owners[tokenId] != address(0);
749     }
750 
751     /**
752      * @dev Returns whether `spender` is allowed to manage `tokenId`.
753      *
754      * Requirements:
755      *
756      * - `tokenId` must exist.
757      */
758     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
759         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
760         address owner = ERC721.ownerOf(tokenId);
761         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
762     }
763 
764     /**
765      * @dev Safely mints `tokenId` and transfers it to `to`.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must not exist.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeMint(address to, uint256 tokenId) internal virtual {
775         _safeMint(to, tokenId, "");
776     }
777 
778     /**
779      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
780      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
781      */
782     function _safeMint(
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) internal virtual {
787         _mint(to, tokenId);
788         require(
789             _checkOnERC721Received(address(0), to, tokenId, _data),
790             "ERC721: transfer to non ERC721Receiver implementer"
791         );
792     }
793 
794     /**
795      * @dev Mints `tokenId` and transfers it to `to`.
796      *
797      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
798      *
799      * Requirements:
800      *
801      * - `tokenId` must not exist.
802      * - `to` cannot be the zero address.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _mint(address to, uint256 tokenId) internal virtual {
807         require(to != address(0), "ERC721: mint to the zero address");
808         require(!_exists(tokenId), "ERC721: token already minted");
809 
810         _beforeTokenTransfer(address(0), to, tokenId);
811 
812         _balances[to] += 1;
813         _owners[tokenId] = to;
814 
815         emit Transfer(address(0), to, tokenId);
816 
817         _afterTokenTransfer(address(0), to, tokenId);
818     }
819 
820     /**
821      * @dev Destroys `tokenId`.
822      * The approval is cleared when the token is burned.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _burn(uint256 tokenId) internal virtual {
831         address owner = ERC721.ownerOf(tokenId);
832 
833         _beforeTokenTransfer(owner, address(0), tokenId);
834 
835         // Clear approvals
836         _approve(address(0), tokenId);
837 
838         _balances[owner] -= 1;
839         delete _owners[tokenId];
840 
841         emit Transfer(owner, address(0), tokenId);
842 
843         _afterTokenTransfer(owner, address(0), tokenId);
844     }
845 
846     /**
847      * @dev Transfers `tokenId` from `from` to `to`.
848      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must be owned by `from`.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _transfer(
858         address from,
859         address to,
860         uint256 tokenId
861     ) internal virtual {
862         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
863         require(to != address(0), "ERC721: transfer to the zero address");
864 
865         _beforeTokenTransfer(from, to, tokenId);
866 
867         // Clear approvals from the previous owner
868         _approve(address(0), tokenId);
869 
870         _balances[from] -= 1;
871         _balances[to] += 1;
872         _owners[tokenId] = to;
873 
874         emit Transfer(from, to, tokenId);
875 
876         _afterTokenTransfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev Approve `to` to operate on `tokenId`
881      *
882      * Emits a {Approval} event.
883      */
884     function _approve(address to, uint256 tokenId) internal virtual {
885         _tokenApprovals[tokenId] = to;
886         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
887     }
888 
889     /**
890      * @dev Approve `operator` to operate on all of `owner` tokens
891      *
892      * Emits a {ApprovalForAll} event.
893      */
894     function _setApprovalForAll(
895         address owner,
896         address operator,
897         bool approved
898     ) internal virtual {
899         require(owner != operator, "ERC721: approve to caller");
900         _operatorApprovals[owner][operator] = approved;
901         emit ApprovalForAll(owner, operator, approved);
902     }
903 
904     /**
905      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
906      * The call is not executed if the target address is not a contract.
907      *
908      * @param from address representing the previous owner of the given token ID
909      * @param to target address that will receive the tokens
910      * @param tokenId uint256 ID of the token to be transferred
911      * @param _data bytes optional data to send along with the call
912      * @return bool whether the call correctly returned the expected magic value
913      */
914     function _checkOnERC721Received(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) private returns (bool) {
920         if (to.isContract()) {
921             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
922                 return retval == IERC721Receiver.onERC721Received.selector;
923             } catch (bytes memory reason) {
924                 if (reason.length == 0) {
925                     revert("ERC721: transfer to non ERC721Receiver implementer");
926                 } else {
927                     assembly {
928                         revert(add(32, reason), mload(reason))
929                     }
930                 }
931             }
932         } else {
933             return true;
934         }
935     }
936 
937     /**
938      * @dev Hook that is called before any token transfer. This includes minting
939      * and burning.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, ``from``'s `tokenId` will be burned.
947      * - `from` and `to` are never both zero.
948      *
949      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
950      */
951     function _beforeTokenTransfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual {}
956 
957     /**
958      * @dev Hook that is called after any transfer of tokens. This includes
959      * minting and burning.
960      *
961      * Calling conditions:
962      *
963      * - when `from` and `to` are both non-zero.
964      * - `from` and `to` are never both zero.
965      *
966      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
967      */
968     function _afterTokenTransfer(
969         address from,
970         address to,
971         uint256 tokenId
972     ) internal virtual {}
973 }
974 
975 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
976 /**
977  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
978  * @dev See https://eips.ethereum.org/EIPS/eip-721
979  */
980 interface IERC721Enumerable is IERC721 {
981     /**
982      * @dev Returns the total amount of tokens stored by the contract.
983      */
984     function totalSupply() external view returns (uint256);
985 
986     /**
987      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
988      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
989      */
990     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
991 
992     /**
993      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
994      * Use along with {totalSupply} to enumerate all tokens.
995      */
996     function tokenByIndex(uint256 index) external view returns (uint256);
997 }
998 
999 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1000 /**
1001  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1002  * enumerability of all the token ids in the contract as well as all token ids owned by each
1003  * account.
1004  */
1005 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1006     // Mapping from owner to list of owned token IDs
1007     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1008 
1009     // Mapping from token ID to index of the owner tokens list
1010     mapping(uint256 => uint256) private _ownedTokensIndex;
1011 
1012     // Array with all token ids, used for enumeration
1013     uint256[] private _allTokens;
1014 
1015     // Mapping from token id to position in the allTokens array
1016     mapping(uint256 => uint256) private _allTokensIndex;
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1022         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1029         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1030         return _ownedTokens[owner][index];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-totalSupply}.
1035      */
1036     function totalSupply() public view virtual override returns (uint256) {
1037         return _allTokens.length;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenByIndex}.
1042      */
1043     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1045         return _allTokens[index];
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1058      * - `from` cannot be the zero address.
1059      * - `to` cannot be the zero address.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual override {
1068         super._beforeTokenTransfer(from, to, tokenId);
1069 
1070         if (from == address(0)) {
1071             _addTokenToAllTokensEnumeration(tokenId);
1072         } else if (from != to) {
1073             _removeTokenFromOwnerEnumeration(from, tokenId);
1074         }
1075         if (to == address(0)) {
1076             _removeTokenFromAllTokensEnumeration(tokenId);
1077         } else if (to != from) {
1078             _addTokenToOwnerEnumeration(to, tokenId);
1079         }
1080     }
1081 
1082     /**
1083      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1084      * @param to address representing the new owner of the given token ID
1085      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1086      */
1087     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1088         uint256 length = ERC721.balanceOf(to);
1089         _ownedTokens[to][length] = tokenId;
1090         _ownedTokensIndex[tokenId] = length;
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's token tracking data structures.
1095      * @param tokenId uint256 ID of the token to be added to the tokens list
1096      */
1097     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1098         _allTokensIndex[tokenId] = _allTokens.length;
1099         _allTokens.push(tokenId);
1100     }
1101 
1102     /**
1103      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1104      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1105      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1106      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1107      * @param from address representing the previous owner of the given token ID
1108      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1109      */
1110     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1111         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1112         // then delete the last slot (swap and pop).
1113 
1114         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1115         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1116 
1117         // When the token to delete is the last token, the swap operation is unnecessary
1118         if (tokenIndex != lastTokenIndex) {
1119             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1120 
1121             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123         }
1124 
1125         // This also deletes the contents at the last position of the array
1126         delete _ownedTokensIndex[tokenId];
1127         delete _ownedTokens[from][lastTokenIndex];
1128     }
1129 
1130     /**
1131      * @dev Private function to remove a token from this extension's token tracking data structures.
1132      * This has O(1) time complexity, but alters the order of the _allTokens array.
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list
1134      */
1135     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1136         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = _allTokens.length - 1;
1140         uint256 tokenIndex = _allTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1143         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1144         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1145         uint256 lastTokenId = _allTokens[lastTokenIndex];
1146 
1147         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _allTokensIndex[tokenId];
1152         _allTokens.pop();
1153     }
1154 }
1155 
1156 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1157 /**
1158  * @dev Contract module which provides a basic access control mechanism, where
1159  * there is an account (an owner) that can be granted exclusive access to
1160  * specific functions.
1161  *
1162  * By default, the owner account will be the one that deploys the contract. This
1163  * can later be changed with {transferOwnership}.
1164  *
1165  * This module is used through inheritance. It will make available the modifier
1166  * `onlyOwner`, which can be applied to your functions to restrict their use to
1167  * the owner.
1168  */
1169 abstract contract Ownable is Context {
1170     address private _owner;
1171 
1172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1173 
1174     /**
1175      * @dev Initializes the contract setting the deployer as the initial owner.
1176      */
1177     constructor() {
1178         _transferOwnership(_msgSender());
1179     }
1180 
1181     /**
1182      * @dev Returns the address of the current owner.
1183      */
1184     function owner() public view virtual returns (address) {
1185         return _owner;
1186     }
1187 
1188     /**
1189      * @dev Throws if called by any account other than the owner.
1190      */
1191     modifier onlyOwner() {
1192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1193         _;
1194     }
1195 
1196     /**
1197      * @dev Leaves the contract without owner. It will not be possible to call
1198      * `onlyOwner` functions anymore. Can only be called by the current owner.
1199      *
1200      * NOTE: Renouncing ownership will leave the contract without an owner,
1201      * thereby removing any functionality that is only available to the owner.
1202      */
1203     function renounceOwnership() public virtual onlyOwner {
1204         _transferOwnership(address(0));
1205     }
1206 
1207     /**
1208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1209      * Can only be called by the current owner.
1210      */
1211     function transferOwnership(address newOwner) public virtual onlyOwner {
1212         require(newOwner != address(0), "Ownable: new owner is the zero address");
1213         _transferOwnership(newOwner);
1214     }
1215 
1216     /**
1217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1218      * Internal function without access restriction.
1219      */
1220     function _transferOwnership(address newOwner) internal virtual {
1221         address oldOwner = _owner;
1222         _owner = newOwner;
1223         emit OwnershipTransferred(oldOwner, newOwner);
1224     }
1225 }
1226 
1227 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1228 // CAUTION
1229 // This version of SafeMath should only be used with Solidity 0.8 or later,
1230 // because it relies on the compiler's built in overflow checks.
1231 /**
1232  * @dev Wrappers over Solidity's arithmetic operations.
1233  *
1234  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1235  * now has built in overflow checking.
1236  */
1237 library SafeMath {
1238     /**
1239      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1240      *
1241      * _Available since v3.4._
1242      */
1243     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1244         unchecked {
1245             uint256 c = a + b;
1246             if (c < a) return (false, 0);
1247             return (true, c);
1248         }
1249     }
1250 
1251     /**
1252      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1253      *
1254      * _Available since v3.4._
1255      */
1256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1257         unchecked {
1258             if (b > a) return (false, 0);
1259             return (true, a - b);
1260         }
1261     }
1262 
1263     /**
1264      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1265      *
1266      * _Available since v3.4._
1267      */
1268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1269         unchecked {
1270             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1271             // benefit is lost if 'b' is also tested.
1272             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1273             if (a == 0) return (true, 0);
1274             uint256 c = a * b;
1275             if (c / a != b) return (false, 0);
1276             return (true, c);
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1286         unchecked {
1287             if (b == 0) return (false, 0);
1288             return (true, a / b);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1294      *
1295      * _Available since v3.4._
1296      */
1297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1298         unchecked {
1299             if (b == 0) return (false, 0);
1300             return (true, a % b);
1301         }
1302     }
1303 
1304     /**
1305      * @dev Returns the addition of two unsigned integers, reverting on
1306      * overflow.
1307      *
1308      * Counterpart to Solidity's `+` operator.
1309      *
1310      * Requirements:
1311      *
1312      * - Addition cannot overflow.
1313      */
1314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1315         return a + b;
1316     }
1317 
1318     /**
1319      * @dev Returns the subtraction of two unsigned integers, reverting on
1320      * overflow (when the result is negative).
1321      *
1322      * Counterpart to Solidity's `-` operator.
1323      *
1324      * Requirements:
1325      *
1326      * - Subtraction cannot overflow.
1327      */
1328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1329         return a - b;
1330     }
1331 
1332     /**
1333      * @dev Returns the multiplication of two unsigned integers, reverting on
1334      * overflow.
1335      *
1336      * Counterpart to Solidity's `*` operator.
1337      *
1338      * Requirements:
1339      *
1340      * - Multiplication cannot overflow.
1341      */
1342     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1343         return a * b;
1344     }
1345 
1346     /**
1347      * @dev Returns the integer division of two unsigned integers, reverting on
1348      * division by zero. The result is rounded towards zero.
1349      *
1350      * Counterpart to Solidity's `/` operator.
1351      *
1352      * Requirements:
1353      *
1354      * - The divisor cannot be zero.
1355      */
1356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1357         return a / b;
1358     }
1359 
1360     /**
1361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1362      * reverting when dividing by zero.
1363      *
1364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1365      * opcode (which leaves remaining gas untouched) while Solidity uses an
1366      * invalid opcode to revert (consuming all remaining gas).
1367      *
1368      * Requirements:
1369      *
1370      * - The divisor cannot be zero.
1371      */
1372     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1373         return a % b;
1374     }
1375 
1376     /**
1377      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1378      * overflow (when the result is negative).
1379      *
1380      * CAUTION: This function is deprecated because it requires allocating memory for the error
1381      * message unnecessarily. For custom revert reasons use {trySub}.
1382      *
1383      * Counterpart to Solidity's `-` operator.
1384      *
1385      * Requirements:
1386      *
1387      * - Subtraction cannot overflow.
1388      */
1389     function sub(
1390         uint256 a,
1391         uint256 b,
1392         string memory errorMessage
1393     ) internal pure returns (uint256) {
1394         unchecked {
1395             require(b <= a, errorMessage);
1396             return a - b;
1397         }
1398     }
1399 
1400     /**
1401      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1402      * division by zero. The result is rounded towards zero.
1403      *
1404      * Counterpart to Solidity's `/` operator. Note: this function uses a
1405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1406      * uses an invalid opcode to revert (consuming all remaining gas).
1407      *
1408      * Requirements:
1409      *
1410      * - The divisor cannot be zero.
1411      */
1412     function div(
1413         uint256 a,
1414         uint256 b,
1415         string memory errorMessage
1416     ) internal pure returns (uint256) {
1417         unchecked {
1418             require(b > 0, errorMessage);
1419             return a / b;
1420         }
1421     }
1422 
1423     /**
1424      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1425      * reverting with custom message when dividing by zero.
1426      *
1427      * CAUTION: This function is deprecated because it requires allocating memory for the error
1428      * message unnecessarily. For custom revert reasons use {tryMod}.
1429      *
1430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1431      * opcode (which leaves remaining gas untouched) while Solidity uses an
1432      * invalid opcode to revert (consuming all remaining gas).
1433      *
1434      * Requirements:
1435      *
1436      * - The divisor cannot be zero.
1437      */
1438     function mod(
1439         uint256 a,
1440         uint256 b,
1441         string memory errorMessage
1442     ) internal pure returns (uint256) {
1443         unchecked {
1444             require(b > 0, errorMessage);
1445             return a % b;
1446         }
1447     }
1448 }
1449 
1450 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1451 /**
1452  * @dev Contract module that helps prevent reentrant calls to a function.
1453  *
1454  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1455  * available, which can be applied to functions to make sure there are no nested
1456  * (reentrant) calls to them.
1457  *
1458  * Note that because there is a single `nonReentrant` guard, functions marked as
1459  * `nonReentrant` may not call one another. This can be worked around by making
1460  * those functions `private`, and then adding `external` `nonReentrant` entry
1461  * points to them.
1462  *
1463  * TIP: If you would like to learn more about reentrancy and alternative ways
1464  * to protect against it, check out our blog post
1465  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1466  */
1467 abstract contract ReentrancyGuard {
1468     // Booleans are more expensive than uint256 or any type that takes up a full
1469     // word because each write operation emits an extra SLOAD to first read the
1470     // slot's contents, replace the bits taken up by the boolean, and then write
1471     // back. This is the compiler's defense against contract upgrades and
1472     // pointer aliasing, and it cannot be disabled.
1473 
1474     // The values being non-zero value makes deployment a bit more expensive,
1475     // but in exchange the refund on every call to nonReentrant will be lower in
1476     // amount. Since refunds are capped to a percentage of the total
1477     // transaction's gas, it is best to keep them low in cases like this one, to
1478     // increase the likelihood of the full refund coming into effect.
1479     uint256 private constant _NOT_ENTERED = 1;
1480     uint256 private constant _ENTERED = 2;
1481 
1482     uint256 private _status;
1483 
1484     constructor() {
1485         _status = _NOT_ENTERED;
1486     }
1487 
1488     /**
1489      * @dev Prevents a contract from calling itself, directly or indirectly.
1490      * Calling a `nonReentrant` function from another `nonReentrant`
1491      * function is not supported. It is possible to prevent this from happening
1492      * by making the `nonReentrant` function external, and making it call a
1493      * `private` function that does the actual work.
1494      */
1495     modifier nonReentrant() {
1496         // On the first call to nonReentrant, _notEntered will be true
1497         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1498 
1499         // Any calls to nonReentrant after this point will fail
1500         _status = _ENTERED;
1501 
1502         _;
1503 
1504         // By storing the original value once again, a refund is triggered (see
1505         // https://eips.ethereum.org/EIPS/eip-2200)
1506         _status = _NOT_ENTERED;
1507     }
1508 }
1509 
1510 interface IMAL {
1511   function spendMAL(address user, uint256 amount) external;
1512 }
1513 
1514 interface ISTAKING {
1515     function balanceOf(address user) external view returns (uint256);
1516 }
1517 
1518 contract MoonLootBag is Context, ERC721Enumerable, Ownable, ReentrancyGuard {
1519     using SafeMath for uint256;
1520     using Strings for uint256;
1521 
1522     string private _lootBaseURI;
1523 
1524     uint256 public constant MAX_SUPPLY = 5000;
1525     uint256 public _basePriceAmount;
1526     uint256 public _basePrice;
1527     uint256 public _incrementPrice;
1528 
1529     bool public saleIsActive;
1530     bool public apeOwnershipRequired;
1531 
1532     mapping (address => bool) private _isAuthorised;
1533     address[] public authorisedLog;
1534 
1535     IMAL public MAL;
1536     ISTAKING public STAKING;
1537     IERC721 public APES;
1538 
1539     mapping(address => uint256) public _mintedByAddress;
1540 
1541     event LootsMinted(address indexed mintedBy, uint256 indexed tokensNumber);
1542 
1543     constructor(address _apes, address _staking, address _mal) ERC721("Moon Loot Bags", "MAL_LOOT"){
1544       MAL = IMAL(_mal);
1545       STAKING = ISTAKING(_staking);
1546       APES = IERC721(_apes);
1547       _isAuthorised[_staking] = true;
1548 
1549       _lootBaseURI = "ipfs://QmUbDeEV5ZdXqqzcMDAex4PfAVvKC4c5p6KdWrQr7oC5pP/";
1550       apeOwnershipRequired = true;
1551 
1552       _basePriceAmount = 3;
1553       _basePrice = 1000 ether;
1554       _incrementPrice = 1000 ether;
1555     }
1556 
1557     modifier onlyAuthorised {
1558       require(_isAuthorised[_msgSender()], "Not Authorised");
1559       _;
1560     }
1561 
1562     function authorise(address addressToAuth) public onlyOwner {
1563       _isAuthorised[addressToAuth] = true;
1564       authorisedLog.push(addressToAuth);
1565     }
1566 
1567     function unauthorise(address addressToUnAuth) public onlyOwner {
1568       _isAuthorised[addressToUnAuth] = false;
1569     }
1570 
1571     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
1572         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1573         address owner = ERC721.ownerOf(tokenId);
1574         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender) || _isAuthorised[spender]);
1575     }
1576 
1577     function reserveForGiveaways(uint256 lootsToMint) public onlyOwner{
1578       require(totalSupply().add(lootsToMint) <= MAX_SUPPLY, "Minting more tokens than allowed");
1579       for(uint256 i = 0; i < lootsToMint; i++) {
1580         _safeMint(_msgSender(), totalSupply() + 1);
1581       }
1582     }
1583 
1584     function giveaway(address[] memory receivers) public onlyOwner{
1585       require(totalSupply().add(receivers.length) <= MAX_SUPPLY, "Minting more tokens than allowed");
1586       for(uint256 i = 0; i < receivers.length; i++) {
1587         _safeMint(receivers[i], totalSupply() + 1);
1588       }
1589     }
1590 
1591     function purchaseLoot(uint256 lootsToMint) public nonReentrant {
1592       require(saleIsActive, "The mint has not started yet");
1593       require(_basePrice > 0, "The mint has not started yet");
1594       require(_incrementPrice > 0, "The mint has not started yet");
1595 
1596       require(_validateApeOwnership(_msgSender()), "You do not have any Moon Apes");
1597       require(lootsToMint > 0, "Min mint is 1 token");
1598       require(lootsToMint <= 50, "You can mint max 50 tokens per transaction");
1599       require(totalSupply().add(lootsToMint) <= MAX_SUPPLY, "Minting more tokens than allowed");
1600 
1601       uint256 totalPrice = getTokensPrice(_msgSender(), lootsToMint);
1602       MAL.spendMAL(_msgSender(), totalPrice);
1603       _mintedByAddress[_msgSender()] += lootsToMint;
1604 
1605       for(uint256 i = 0; i < lootsToMint; i++) {
1606         _safeMint(_msgSender(), totalSupply() + 1);
1607       }
1608 
1609       emit LootsMinted(_msgSender(), lootsToMint);
1610     }
1611 
1612     function getUserMintedAmount(address user) public view returns(uint256){
1613       return _mintedByAddress[user];
1614     }
1615 
1616     function getTokensPrice(address user, uint256 amount) public view returns (uint256) {
1617       uint256 minted = _mintedByAddress[user];
1618 
1619       if (minted.add(amount) <= _basePriceAmount) return amount.mul(_basePrice);
1620 
1621       uint256 totalPrice;
1622       for (uint256 i; i < amount; i++) {
1623         minted = minted.add(1);
1624         if (minted <= _basePriceAmount) {
1625           totalPrice = totalPrice.add(_basePrice);
1626           continue;
1627         }
1628         totalPrice += _basePrice.add((minted.sub(_basePriceAmount).mul(_incrementPrice)));
1629       }
1630       return totalPrice;
1631     }
1632 
1633     function _validateApeOwnership(address user) internal view returns (bool) {
1634       if (!apeOwnershipRequired) return true;
1635       if (STAKING.balanceOf(user) > 0) return true;
1636       return APES.balanceOf(user) > 0;
1637     }
1638 
1639     function updateApeOwnershipRequirement(bool _isOwnershipRequired) public onlyOwner {
1640       apeOwnershipRequired = _isOwnershipRequired;
1641     }
1642 
1643     function updateSaleStatus(bool status) public onlyOwner {
1644       saleIsActive = status;
1645     }
1646 
1647     function updateBasePrice(uint256 _newPrice) public onlyOwner {
1648       require(!saleIsActive, "Pause sale before price update");
1649       _basePrice = _newPrice;
1650     }
1651 
1652     function updateBasePriceAmount(uint256 _amount) public onlyOwner {
1653       _basePriceAmount = _amount;
1654     }
1655 
1656     function updateIncrementPrice(uint256 incrementPrice) public onlyOwner {
1657       require(!saleIsActive, "Pause sale before price update");
1658       _incrementPrice = incrementPrice;
1659     }
1660 
1661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1662       require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1663       return string(abi.encodePacked(string(abi.encodePacked(_lootBaseURI, tokenId.toString())), ".json"));
1664     }
1665 
1666     function withdraw() external onlyOwner {
1667       uint256 balance = address(this).balance;
1668       payable(owner()).transfer(balance);
1669     }
1670 }