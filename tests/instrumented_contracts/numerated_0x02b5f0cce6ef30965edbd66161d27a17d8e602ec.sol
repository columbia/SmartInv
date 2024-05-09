1 pragma solidity ^0.8.7;
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 interface IERC721Receiver {
171     /**
172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
173      * by `operator` from `from`, this function is called.
174      *
175      * It must return its Solidity selector to confirm the token transfer.
176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
177      *
178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
179      */
180     function onERC721Received(
181         address operator,
182         address from,
183         uint256 tokenId,
184         bytes calldata data
185     ) external returns (bytes4);
186 }
187 
188 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194     /**
195      * @dev Returns the token collection name.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the token collection symbol.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
206      */
207     function tokenURI(uint256 tokenId) external view returns (string memory);
208 }
209 
210 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
211 /**
212  * @dev Collection of functions related to the address type
213  */
214 library Address {
215     /**
216      * @dev Returns true if `account` is a contract.
217      *
218      * [IMPORTANT]
219      * ====
220      * It is unsafe to assume that an address for which this function returns
221      * false is an externally-owned account (EOA) and not a contract.
222      *
223      * Among others, `isContract` will return false for the following
224      * types of addresses:
225      *
226      *  - an externally-owned account
227      *  - a contract in construction
228      *  - an address where a contract will be created
229      *  - an address where a contract lived, but was destroyed
230      * ====
231      *
232      * [IMPORTANT]
233      * ====
234      * You shouldn't rely on `isContract` to protect against flash loan attacks!
235      *
236      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
237      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
238      * constructor.
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize/address.code.length, which returns 0
243         // for contracts in construction, since the code is only stored at the end
244         // of the constructor execution.
245 
246         return account.code.length > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         (bool success, ) = recipient.call{value: amount}("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain `call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionCall(target, data, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, 0, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but also transferring `value` wei to `target`.
311      *
312      * Requirements:
313      *
314      * - the calling contract must have an ETH balance of at least `value`.
315      * - the called Solidity function must be `payable`.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
329      * with `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(address(this).balance >= value, "Address: insufficient balance for call");
340         require(isContract(target), "Address: call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.call{value: value}(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
353         return functionStaticCall(target, data, "Address: low-level static call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a static call.
359      *
360      * _Available since v3.3._
361      */
362     function functionStaticCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal view returns (bytes memory) {
367         require(isContract(target), "Address: static call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.staticcall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a delegate call.
386      *
387      * _Available since v3.4._
388      */
389     function functionDelegateCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(isContract(target), "Address: delegate call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.delegatecall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
402      * revert reason using the provided one.
403      *
404      * _Available since v4.3._
405      */
406     function verifyCallResult(
407         bool success,
408         bytes memory returndata,
409         string memory errorMessage
410     ) internal pure returns (bytes memory) {
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 assembly {
419                     let returndata_size := mload(returndata)
420                     revert(add(32, returndata), returndata_size)
421                 }
422             } else {
423                 revert(errorMessage);
424             }
425         }
426     }
427 }
428 
429 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
430 /**
431  * @dev Provides information about the current execution context, including the
432  * sender of the transaction and its data. While these are generally available
433  * via msg.sender and msg.data, they should not be accessed in such a direct
434  * manner, since when dealing with meta-transactions the account sending and
435  * paying for execution may not be the actual sender (as far as an application
436  * is concerned).
437  *
438  * This contract is only required for intermediate, library-like contracts.
439  */
440 abstract contract Context {
441     function _msgSender() internal view virtual returns (address) {
442         return msg.sender;
443     }
444 
445     function _msgData() internal view virtual returns (bytes calldata) {
446         return msg.data;
447     }
448 }
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
451 /**
452  * @dev String operations.
453  */
454 library Strings {
455     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
459      */
460     function toString(uint256 value) internal pure returns (string memory) {
461         // Inspired by OraclizeAPI's implementation - MIT licence
462         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
463 
464         if (value == 0) {
465             return "0";
466         }
467         uint256 temp = value;
468         uint256 digits;
469         while (temp != 0) {
470             digits++;
471             temp /= 10;
472         }
473         bytes memory buffer = new bytes(digits);
474         while (value != 0) {
475             digits -= 1;
476             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
477             value /= 10;
478         }
479         return string(buffer);
480     }
481 
482     /**
483      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
484      */
485     function toHexString(uint256 value) internal pure returns (string memory) {
486         if (value == 0) {
487             return "0x00";
488         }
489         uint256 temp = value;
490         uint256 length = 0;
491         while (temp != 0) {
492             length++;
493             temp >>= 8;
494         }
495         return toHexString(value, length);
496     }
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
500      */
501     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
502         bytes memory buffer = new bytes(2 * length + 2);
503         buffer[0] = "0";
504         buffer[1] = "x";
505         for (uint256 i = 2 * length + 1; i > 1; --i) {
506             buffer[i] = _HEX_SYMBOLS[value & 0xf];
507             value >>= 4;
508         }
509         require(value == 0, "Strings: hex length insufficient");
510         return string(buffer);
511     }
512 }
513 
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
515 /**
516  * @dev Implementation of the {IERC165} interface.
517  *
518  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
519  * for the additional interface id that will be supported. For example:
520  *
521  * ```solidity
522  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
523  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
524  * }
525  * ```
526  *
527  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
528  */
529 abstract contract ERC165 is IERC165 {
530     /**
531      * @dev See {IERC165-supportsInterface}.
532      */
533     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534         return interfaceId == type(IERC165).interfaceId;
535     }
536 }
537 
538 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
539 /**
540  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
541  * the Metadata extension, but not including the Enumerable extension, which is available separately as
542  * {ERC721Enumerable}.
543  */
544 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
545     using Address for address;
546     using Strings for uint256;
547 
548     // Token name
549     string private _name;
550 
551     // Token symbol
552     string private _symbol;
553 
554     // Mapping from token ID to owner address
555     mapping(uint256 => address) private _owners;
556 
557     // Mapping owner address to token count
558     mapping(address => uint256) private _balances;
559 
560     // Mapping from token ID to approved address
561     mapping(uint256 => address) private _tokenApprovals;
562 
563     // Mapping from owner to operator approvals
564     mapping(address => mapping(address => bool)) private _operatorApprovals;
565 
566     /**
567      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
568      */
569     constructor(string memory name_, string memory symbol_) {
570         _name = name_;
571         _symbol = symbol_;
572     }
573 
574     /**
575      * @dev See {IERC165-supportsInterface}.
576      */
577     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
578         return
579             interfaceId == type(IERC721).interfaceId ||
580             interfaceId == type(IERC721Metadata).interfaceId ||
581             super.supportsInterface(interfaceId);
582     }
583 
584     /**
585      * @dev See {IERC721-balanceOf}.
586      */
587     function balanceOf(address owner) public view virtual override returns (uint256) {
588         require(owner != address(0), "ERC721: balance query for the zero address");
589         return _balances[owner];
590     }
591 
592     /**
593      * @dev See {IERC721-ownerOf}.
594      */
595     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
596         address owner = _owners[tokenId];
597         require(owner != address(0), "ERC721: owner query for nonexistent token");
598         return owner;
599     }
600 
601     /**
602      * @dev See {IERC721Metadata-name}.
603      */
604     function name() public view virtual override returns (string memory) {
605         return _name;
606     }
607 
608     /**
609      * @dev See {IERC721Metadata-symbol}.
610      */
611     function symbol() public view virtual override returns (string memory) {
612         return _symbol;
613     }
614 
615     /**
616      * @dev See {IERC721Metadata-tokenURI}.
617      */
618     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
619         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
620 
621         string memory baseURI = _baseURI();
622         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
623     }
624 
625     /**
626      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
627      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
628      * by default, can be overriden in child contracts.
629      */
630     function _baseURI() internal view virtual returns (string memory) {
631         return "";
632     }
633 
634     /**
635      * @dev See {IERC721-approve}.
636      */
637     function approve(address to, uint256 tokenId) public virtual override {
638         address owner = ERC721.ownerOf(tokenId);
639         require(to != owner, "ERC721: approval to current owner");
640 
641         require(
642             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
643             "ERC721: approve caller is not owner nor approved for all"
644         );
645 
646         _approve(to, tokenId);
647     }
648 
649     /**
650      * @dev See {IERC721-getApproved}.
651      */
652     function getApproved(uint256 tokenId) public view virtual override returns (address) {
653         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
654 
655         return _tokenApprovals[tokenId];
656     }
657 
658     /**
659      * @dev See {IERC721-setApprovalForAll}.
660      */
661     function setApprovalForAll(address operator, bool approved) public virtual override {
662         _setApprovalForAll(_msgSender(), operator, approved);
663     }
664 
665     /**
666      * @dev See {IERC721-isApprovedForAll}.
667      */
668     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
669         return _operatorApprovals[owner][operator];
670     }
671 
672     /**
673      * @dev See {IERC721-transferFrom}.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         //solhint-disable-next-line max-line-length
681         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
682 
683         _transfer(from, to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) public virtual override {
694         safeTransferFrom(from, to, tokenId, "");
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes memory _data
705     ) public virtual override {
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707         _safeTransfer(from, to, tokenId, _data);
708     }
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
712      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
713      *
714      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
715      *
716      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
717      * implement alternative mechanisms to perform token transfer, such as signature-based.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must exist and be owned by `from`.
724      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _safeTransfer(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) internal virtual {
734         _transfer(from, to, tokenId);
735         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
736     }
737 
738     /**
739      * @dev Returns whether `tokenId` exists.
740      *
741      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
742      *
743      * Tokens start existing when they are minted (`_mint`),
744      * and stop existing when they are burned (`_burn`).
745      */
746     function _exists(uint256 tokenId) internal view virtual returns (bool) {
747         return _owners[tokenId] != address(0);
748     }
749 
750     /**
751      * @dev Returns whether `spender` is allowed to manage `tokenId`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      */
757     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
758         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
759         address owner = ERC721.ownerOf(tokenId);
760         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
761     }
762 
763     /**
764      * @dev Safely mints `tokenId` and transfers it to `to`.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must not exist.
769      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _safeMint(address to, uint256 tokenId) internal virtual {
774         _safeMint(to, tokenId, "");
775     }
776 
777     /**
778      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
779      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
780      */
781     function _safeMint(
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _mint(to, tokenId);
787         require(
788             _checkOnERC721Received(address(0), to, tokenId, _data),
789             "ERC721: transfer to non ERC721Receiver implementer"
790         );
791     }
792 
793     /**
794      * @dev Mints `tokenId` and transfers it to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
797      *
798      * Requirements:
799      *
800      * - `tokenId` must not exist.
801      * - `to` cannot be the zero address.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _mint(address to, uint256 tokenId) internal virtual {
806         require(to != address(0), "ERC721: mint to the zero address");
807         require(!_exists(tokenId), "ERC721: token already minted");
808 
809         _beforeTokenTransfer(address(0), to, tokenId);
810 
811         _balances[to] += 1;
812         _owners[tokenId] = to;
813 
814         emit Transfer(address(0), to, tokenId);
815 
816         _afterTokenTransfer(address(0), to, tokenId);
817     }
818 
819     /**
820      * @dev Destroys `tokenId`.
821      * The approval is cleared when the token is burned.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must exist.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _burn(uint256 tokenId) internal virtual {
830         address owner = ERC721.ownerOf(tokenId);
831 
832         _beforeTokenTransfer(owner, address(0), tokenId);
833 
834         // Clear approvals
835         _approve(address(0), tokenId);
836 
837         _balances[owner] -= 1;
838         delete _owners[tokenId];
839 
840         emit Transfer(owner, address(0), tokenId);
841 
842         _afterTokenTransfer(owner, address(0), tokenId);
843     }
844 
845     /**
846      * @dev Transfers `tokenId` from `from` to `to`.
847      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
848      *
849      * Requirements:
850      *
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must be owned by `from`.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _transfer(
857         address from,
858         address to,
859         uint256 tokenId
860     ) internal virtual {
861         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
862         require(to != address(0), "ERC721: transfer to the zero address");
863 
864         _beforeTokenTransfer(from, to, tokenId);
865 
866         // Clear approvals from the previous owner
867         _approve(address(0), tokenId);
868 
869         _balances[from] -= 1;
870         _balances[to] += 1;
871         _owners[tokenId] = to;
872 
873         emit Transfer(from, to, tokenId);
874 
875         _afterTokenTransfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev Approve `to` to operate on `tokenId`
880      *
881      * Emits a {Approval} event.
882      */
883     function _approve(address to, uint256 tokenId) internal virtual {
884         _tokenApprovals[tokenId] = to;
885         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
886     }
887 
888     /**
889      * @dev Approve `operator` to operate on all of `owner` tokens
890      *
891      * Emits a {ApprovalForAll} event.
892      */
893     function _setApprovalForAll(
894         address owner,
895         address operator,
896         bool approved
897     ) internal virtual {
898         require(owner != operator, "ERC721: approve to caller");
899         _operatorApprovals[owner][operator] = approved;
900         emit ApprovalForAll(owner, operator, approved);
901     }
902 
903     /**
904      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
905      * The call is not executed if the target address is not a contract.
906      *
907      * @param from address representing the previous owner of the given token ID
908      * @param to target address that will receive the tokens
909      * @param tokenId uint256 ID of the token to be transferred
910      * @param _data bytes optional data to send along with the call
911      * @return bool whether the call correctly returned the expected magic value
912      */
913     function _checkOnERC721Received(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) private returns (bool) {
919         if (to.isContract()) {
920             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
921                 return retval == IERC721Receiver.onERC721Received.selector;
922             } catch (bytes memory reason) {
923                 if (reason.length == 0) {
924                     revert("ERC721: transfer to non ERC721Receiver implementer");
925                 } else {
926                     assembly {
927                         revert(add(32, reason), mload(reason))
928                     }
929                 }
930             }
931         } else {
932             return true;
933         }
934     }
935 
936     /**
937      * @dev Hook that is called before any token transfer. This includes minting
938      * and burning.
939      *
940      * Calling conditions:
941      *
942      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
943      * transferred to `to`.
944      * - When `from` is zero, `tokenId` will be minted for `to`.
945      * - When `to` is zero, ``from``'s `tokenId` will be burned.
946      * - `from` and `to` are never both zero.
947      *
948      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
949      */
950     function _beforeTokenTransfer(
951         address from,
952         address to,
953         uint256 tokenId
954     ) internal virtual {}
955 
956     /**
957      * @dev Hook that is called after any transfer of tokens. This includes
958      * minting and burning.
959      *
960      * Calling conditions:
961      *
962      * - when `from` and `to` are both non-zero.
963      * - `from` and `to` are never both zero.
964      *
965      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
966      */
967     function _afterTokenTransfer(
968         address from,
969         address to,
970         uint256 tokenId
971     ) internal virtual {}
972 }
973 
974 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
975 /**
976  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
977  * @dev See https://eips.ethereum.org/EIPS/eip-721
978  */
979 interface IERC721Enumerable is IERC721 {
980     /**
981      * @dev Returns the total amount of tokens stored by the contract.
982      */
983     function totalSupply() external view returns (uint256);
984 
985     /**
986      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
987      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
988      */
989     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
990 
991     /**
992      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
993      * Use along with {totalSupply} to enumerate all tokens.
994      */
995     function tokenByIndex(uint256 index) external view returns (uint256);
996 }
997 
998 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
999 /**
1000  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1001  * enumerability of all the token ids in the contract as well as all token ids owned by each
1002  * account.
1003  */
1004 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1005     // Mapping from owner to list of owned token IDs
1006     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1007 
1008     // Mapping from token ID to index of the owner tokens list
1009     mapping(uint256 => uint256) private _ownedTokensIndex;
1010 
1011     // Array with all token ids, used for enumeration
1012     uint256[] private _allTokens;
1013 
1014     // Mapping from token id to position in the allTokens array
1015     mapping(uint256 => uint256) private _allTokensIndex;
1016 
1017     /**
1018      * @dev See {IERC165-supportsInterface}.
1019      */
1020     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1021         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1026      */
1027     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1028         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1029         return _ownedTokens[owner][index];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-totalSupply}.
1034      */
1035     function totalSupply() public view virtual override returns (uint256) {
1036         return _allTokens.length;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-tokenByIndex}.
1041      */
1042     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1043         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1044         return _allTokens[index];
1045     }
1046 
1047     /**
1048      * @dev Hook that is called before any token transfer. This includes minting
1049      * and burning.
1050      *
1051      * Calling conditions:
1052      *
1053      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1054      * transferred to `to`.
1055      * - When `from` is zero, `tokenId` will be minted for `to`.
1056      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1057      * - `from` cannot be the zero address.
1058      * - `to` cannot be the zero address.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _beforeTokenTransfer(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) internal virtual override {
1067         super._beforeTokenTransfer(from, to, tokenId);
1068 
1069         if (from == address(0)) {
1070             _addTokenToAllTokensEnumeration(tokenId);
1071         } else if (from != to) {
1072             _removeTokenFromOwnerEnumeration(from, tokenId);
1073         }
1074         if (to == address(0)) {
1075             _removeTokenFromAllTokensEnumeration(tokenId);
1076         } else if (to != from) {
1077             _addTokenToOwnerEnumeration(to, tokenId);
1078         }
1079     }
1080 
1081     /**
1082      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1083      * @param to address representing the new owner of the given token ID
1084      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1085      */
1086     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1087         uint256 length = ERC721.balanceOf(to);
1088         _ownedTokens[to][length] = tokenId;
1089         _ownedTokensIndex[tokenId] = length;
1090     }
1091 
1092     /**
1093      * @dev Private function to add a token to this extension's token tracking data structures.
1094      * @param tokenId uint256 ID of the token to be added to the tokens list
1095      */
1096     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1097         _allTokensIndex[tokenId] = _allTokens.length;
1098         _allTokens.push(tokenId);
1099     }
1100 
1101     /**
1102      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1103      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1104      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1105      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1106      * @param from address representing the previous owner of the given token ID
1107      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1108      */
1109     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1110         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1111         // then delete the last slot (swap and pop).
1112 
1113         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1114         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1115 
1116         // When the token to delete is the last token, the swap operation is unnecessary
1117         if (tokenIndex != lastTokenIndex) {
1118             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1119 
1120             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1121             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1122         }
1123 
1124         // This also deletes the contents at the last position of the array
1125         delete _ownedTokensIndex[tokenId];
1126         delete _ownedTokens[from][lastTokenIndex];
1127     }
1128 
1129     /**
1130      * @dev Private function to remove a token from this extension's token tracking data structures.
1131      * This has O(1) time complexity, but alters the order of the _allTokens array.
1132      * @param tokenId uint256 ID of the token to be removed from the tokens list
1133      */
1134     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1135         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1136         // then delete the last slot (swap and pop).
1137 
1138         uint256 lastTokenIndex = _allTokens.length - 1;
1139         uint256 tokenIndex = _allTokensIndex[tokenId];
1140 
1141         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1142         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1143         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1144         uint256 lastTokenId = _allTokens[lastTokenIndex];
1145 
1146         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1147         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1148 
1149         // This also deletes the contents at the last position of the array
1150         delete _allTokensIndex[tokenId];
1151         _allTokens.pop();
1152     }
1153 }
1154 
1155 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1156 /**
1157  * @dev Contract module which provides a basic access control mechanism, where
1158  * there is an account (an owner) that can be granted exclusive access to
1159  * specific functions.
1160  *
1161  * By default, the owner account will be the one that deploys the contract. This
1162  * can later be changed with {transferOwnership}.
1163  *
1164  * This module is used through inheritance. It will make available the modifier
1165  * `onlyOwner`, which can be applied to your functions to restrict their use to
1166  * the owner.
1167  */
1168 abstract contract Ownable is Context {
1169     address private _owner;
1170 
1171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1172 
1173     /**
1174      * @dev Initializes the contract setting the deployer as the initial owner.
1175      */
1176     constructor() {
1177         _transferOwnership(_msgSender());
1178     }
1179 
1180     /**
1181      * @dev Returns the address of the current owner.
1182      */
1183     function owner() public view virtual returns (address) {
1184         return _owner;
1185     }
1186 
1187     /**
1188      * @dev Throws if called by any account other than the owner.
1189      */
1190     modifier onlyOwner() {
1191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1192         _;
1193     }
1194 
1195     /**
1196      * @dev Leaves the contract without owner. It will not be possible to call
1197      * `onlyOwner` functions anymore. Can only be called by the current owner.
1198      *
1199      * NOTE: Renouncing ownership will leave the contract without an owner,
1200      * thereby removing any functionality that is only available to the owner.
1201      */
1202     function renounceOwnership() public virtual onlyOwner {
1203         _transferOwnership(address(0));
1204     }
1205 
1206     /**
1207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1208      * Can only be called by the current owner.
1209      */
1210     function transferOwnership(address newOwner) public virtual onlyOwner {
1211         require(newOwner != address(0), "Ownable: new owner is the zero address");
1212         _transferOwnership(newOwner);
1213     }
1214 
1215     /**
1216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1217      * Internal function without access restriction.
1218      */
1219     function _transferOwnership(address newOwner) internal virtual {
1220         address oldOwner = _owner;
1221         _owner = newOwner;
1222         emit OwnershipTransferred(oldOwner, newOwner);
1223     }
1224 }
1225 
1226 library Base64 {
1227     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1228     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
1229                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
1230                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
1231                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
1232 
1233     function encode(bytes memory data) internal pure returns (string memory) {
1234         if (data.length == 0) return '';
1235 
1236         // load the table into memory
1237         string memory table = TABLE_ENCODE;
1238 
1239         // multiply by 4/3 rounded up
1240         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1241 
1242         // add some extra buffer at the end required for the writing
1243         string memory result = new string(encodedLen + 32);
1244 
1245         assembly {
1246             // set the actual output length
1247             mstore(result, encodedLen)
1248 
1249             // prepare the lookup table
1250             let tablePtr := add(table, 1)
1251 
1252             // input ptr
1253             let dataPtr := data
1254             let endPtr := add(dataPtr, mload(data))
1255 
1256             // result ptr, jump over length
1257             let resultPtr := add(result, 32)
1258 
1259             // run over the input, 3 bytes at a time
1260             for {} lt(dataPtr, endPtr) {}
1261             {
1262                 // read 3 bytes
1263                 dataPtr := add(dataPtr, 3)
1264                 let input := mload(dataPtr)
1265 
1266                 // write 4 characters
1267                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1268                 resultPtr := add(resultPtr, 1)
1269                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1270                 resultPtr := add(resultPtr, 1)
1271                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
1272                 resultPtr := add(resultPtr, 1)
1273                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
1274                 resultPtr := add(resultPtr, 1)
1275             }
1276 
1277             // padding with '='
1278             switch mod(mload(data), 3)
1279             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
1280             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
1281         }
1282 
1283         return result;
1284     }
1285 
1286     function decode(string memory _data) internal pure returns (bytes memory) {
1287         bytes memory data = bytes(_data);
1288 
1289         if (data.length == 0) return new bytes(0);
1290         require(data.length % 4 == 0, "invalid base64 decoder input");
1291 
1292         // load the table into memory
1293         bytes memory table = TABLE_DECODE;
1294 
1295         // every 4 characters represent 3 bytes
1296         uint256 decodedLen = (data.length / 4) * 3;
1297 
1298         // add some extra buffer at the end required for the writing
1299         bytes memory result = new bytes(decodedLen + 32);
1300 
1301         assembly {
1302             // padding with '='
1303             let lastBytes := mload(add(data, mload(data)))
1304             if eq(and(lastBytes, 0xFF), 0x3d) {
1305                 decodedLen := sub(decodedLen, 1)
1306                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
1307                     decodedLen := sub(decodedLen, 1)
1308                 }
1309             }
1310 
1311             // set the actual output length
1312             mstore(result, decodedLen)
1313 
1314             // prepare the lookup table
1315             let tablePtr := add(table, 1)
1316 
1317             // input ptr
1318             let dataPtr := data
1319             let endPtr := add(dataPtr, mload(data))
1320 
1321             // result ptr, jump over length
1322             let resultPtr := add(result, 32)
1323 
1324             // run over the input, 4 characters at a time
1325             for {} lt(dataPtr, endPtr) {}
1326             {
1327                // read 4 characters
1328                dataPtr := add(dataPtr, 4)
1329                let input := mload(dataPtr)
1330 
1331                // write 3 bytes
1332                let output := add(
1333                    add(
1334                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
1335                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
1336                    add(
1337                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
1338                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
1339                     )
1340                 )
1341                 mstore(resultPtr, shl(232, output))
1342                 resultPtr := add(resultPtr, 3)
1343             }
1344         }
1345 
1346         return result;
1347     }
1348 }
1349 
1350 contract Catch22 is ERC721, ERC721Enumerable, Ownable {
1351     uint256 public constant maxSupply = 222;
1352 
1353     constructor() ERC721("Catch-22", "C22") {}
1354 
1355     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1356         if (_i == 0) {
1357             return "0";
1358         }
1359         uint j = _i;
1360         uint len;
1361         while (j != 0) {
1362             len++;
1363             j /= 10;
1364         }
1365         bytes memory bstr = new bytes(len);
1366         uint k = len;
1367         while (_i != 0) {
1368             k = k-1;
1369             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1370             bytes1 b1 = bytes1(temp);
1371             bstr[k] = b1;
1372             _i /= 10;
1373         }
1374         return string(bstr);
1375     }
1376 
1377     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1378         internal
1379         override(ERC721, ERC721Enumerable)
1380     {
1381         super._beforeTokenTransfer(from, to, tokenId);
1382     }
1383 
1384     function _burn(uint256 tokenId) internal override(ERC721) {
1385         super._burn(tokenId);
1386     }
1387 
1388     function supportsInterface(bytes4 interfaceId)
1389         public
1390         view
1391         override(ERC721, ERC721Enumerable)
1392         returns (bool)
1393     {
1394         return super.supportsInterface(interfaceId);
1395     }
1396 
1397     function mint() public {
1398         uint256 supply = totalSupply();
1399         require(supply < maxSupply, "SOLD OUT!");
1400         _safeMint(msg.sender, supply + 1);
1401     }
1402 
1403     function random(uint number, uint seed) public view returns(uint){
1404         return uint(keccak256(abi.encodePacked(seed))) % (number + 1);
1405     }
1406 
1407     function getSvg(uint tokenId) private view returns (string memory) {
1408         string memory svg;
1409         svg = string(abi.encodePacked(
1410             "<svg width='350px' height='350px' viewBox='0 0 350 350' fill='none' xmlns='http://www.w3.org/2000/svg'>",
1411             "<rect width='100%' height='100%' fill='rgb(",
1412             uint2str(random(222, tokenId + 7) + 10),
1413             ",",
1414             uint2str(random(222, tokenId + 3) + 10),
1415             ",",
1416             uint2str(random(222, tokenId + 1) + 10),
1417             ")'/>",
1418             "<text x='50%' y='50%' fill='black' font-family='fantasy' font-size='220px' dominant-baseline='middle' text-anchor='middle'>22</text>",
1419             "<text x='", uint2str(random(70, tokenId + 1) + 15), "%' y='", uint2str(random(75, tokenId + 2) + 15), "%' fill='white' font-family='fantasy' font-size='100px' dominant-baseline='middle' text-anchor='middle'>2</text>",
1420             "<text x='", uint2str(random(70, tokenId + 3) + 15), "%' y='", uint2str(random(75, tokenId + 5) + 15), "%' fill='white' font-family='fantasy' font-size='100px' dominant-baseline='middle' text-anchor='middle'>22</text> </svg>"
1421         ));
1422         return svg;
1423     }
1424 
1425     function tokenURI(uint256 tokenId) override(ERC721) public view returns (string memory) {
1426         string memory json = Base64.encode(
1427             bytes(string(
1428                 abi.encodePacked(
1429                     '{"name": "#',
1430                         uint2str(tokenId),
1431                     '",',
1432                     '"image_data": "',
1433                         getSvg(tokenId),
1434                     '",',
1435                     '"attributes": [',
1436                         '{"trait_type": "Year", "value": "22" },',
1437                         '{"trait_type": "Month", "value": "2" },',
1438                         '{"trait_type": "Day", "value": "22" }',
1439                     ']}'
1440                 )
1441             ))
1442         );
1443         return string(abi.encodePacked('data:application/json;base64,', json));
1444     }    
1445 }