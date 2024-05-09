1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
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
27 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId,
81         bytes calldata data
82     ) external;
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns the account approved for `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function getApproved(uint256 tokenId) external view returns (address operator);
159 
160     /**
161      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162      *
163      * See {setApprovalForAll}
164      */
165     function isApprovedForAll(address owner, address operator) external view returns (bool);
166 }
167 
168 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  * from ERC721 asset contracts.
176  */
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
186      */
187     function onERC721Received(
188         address operator,
189         address from,
190         uint256 tokenId,
191         bytes calldata data
192     ) external returns (bytes4);
193 }
194 
195 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
201  * @dev See https://eips.ethereum.org/EIPS/eip-721
202  */
203 interface IERC721Metadata is IERC721 {
204     /**
205      * @dev Returns the token collection name.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the token collection symbol.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
216      */
217     function tokenURI(uint256 tokenId) external view returns (string memory);
218 }
219 
220 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
221 
222 pragma solidity ^0.8.1;
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      *
245      * [IMPORTANT]
246      * ====
247      * You shouldn't rely on `isContract` to protect against flash loan attacks!
248      *
249      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
250      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
251      * constructor.
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize/address.code.length, which returns 0
256         // for contracts in construction, since the code is only stored at the end
257         // of the constructor execution.
258 
259         return account.code.length > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430                 /// @solidity memory-safe-assembly
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Provides information about the current execution context, including the
448  * sender of the transaction and its data. While these are generally available
449  * via msg.sender and msg.data, they should not be accessed in such a direct
450  * manner, since when dealing with meta-transactions the account sending and
451  * paying for execution may not be the actual sender (as far as an application
452  * is concerned).
453  *
454  * This contract is only required for intermediate, library-like contracts.
455  */
456 abstract contract Context {
457     function _msgSender() internal view virtual returns (address) {
458         return msg.sender;
459     }
460 
461     function _msgData() internal view virtual returns (bytes calldata) {
462         return msg.data;
463     }
464 }
465 
466 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev String operations.
472  */
473 library Strings {
474     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
475     uint8 private constant _ADDRESS_LENGTH = 20;
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
479      */
480     function toString(uint256 value) internal pure returns (string memory) {
481         // Inspired by OraclizeAPI's implementation - MIT licence
482         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
483 
484         if (value == 0) {
485             return "0";
486         }
487         uint256 temp = value;
488         uint256 digits;
489         while (temp != 0) {
490             digits++;
491             temp /= 10;
492         }
493         bytes memory buffer = new bytes(digits);
494         while (value != 0) {
495             digits -= 1;
496             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
497             value /= 10;
498         }
499         return string(buffer);
500     }
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
504      */
505     function toHexString(uint256 value) internal pure returns (string memory) {
506         if (value == 0) {
507             return "0x00";
508         }
509         uint256 temp = value;
510         uint256 length = 0;
511         while (temp != 0) {
512             length++;
513             temp >>= 8;
514         }
515         return toHexString(value, length);
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
520      */
521     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
522         bytes memory buffer = new bytes(2 * length + 2);
523         buffer[0] = "0";
524         buffer[1] = "x";
525         for (uint256 i = 2 * length + 1; i > 1; --i) {
526             buffer[i] = _HEX_SYMBOLS[value & 0xf];
527             value >>= 4;
528         }
529         require(value == 0, "Strings: hex length insufficient");
530         return string(buffer);
531     }
532 
533     /**
534      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
535      */
536     function toHexString(address addr) internal pure returns (string memory) {
537         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
538     }
539 }
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 
569 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
575  * the Metadata extension, but not including the Enumerable extension, which is available separately as
576  * {ERC721Enumerable}.
577  */
578 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
579     using Address for address;
580     using Strings for uint256;
581 
582     // Token name
583     string private _name;
584 
585     // Token symbol
586     string private _symbol;
587 
588     // Mapping from token ID to owner address
589     mapping(uint256 => address) private _owners;
590 
591     // Mapping owner address to token count
592     mapping(address => uint256) private _balances;
593 
594     // Mapping from token ID to approved address
595     mapping(uint256 => address) private _tokenApprovals;
596 
597     // Mapping from owner to operator approvals
598     mapping(address => mapping(address => bool)) private _operatorApprovals;
599 
600     /**
601      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
602      */
603     constructor(string memory name_, string memory symbol_) {
604         _name = name_;
605         _symbol = symbol_;
606     }
607 
608     /**
609      * @dev See {IERC165-supportsInterface}.
610      */
611     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
612         return
613             interfaceId == type(IERC721).interfaceId ||
614             interfaceId == type(IERC721Metadata).interfaceId ||
615             super.supportsInterface(interfaceId);
616     }
617 
618     /**
619      * @dev See {IERC721-balanceOf}.
620      */
621     function balanceOf(address owner) public view virtual override returns (uint256) {
622         require(owner != address(0), "ERC721: address zero is not a valid owner");
623         return _balances[owner];
624     }
625 
626     /**
627      * @dev See {IERC721-ownerOf}.
628      */
629     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
630         address owner = _owners[tokenId];
631         require(owner != address(0), "ERC721: invalid token ID");
632         return owner;
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-name}.
637      */
638     function name() public view virtual override returns (string memory) {
639         return _name;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-symbol}.
644      */
645     function symbol() public view virtual override returns (string memory) {
646         return _symbol;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-tokenURI}.
651      */
652     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
653         _requireMinted(tokenId);
654 
655         string memory baseURI = _baseURI();
656         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
657     }
658 
659     /**
660      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
661      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
662      * by default, can be overridden in child contracts.
663      */
664     function _baseURI() internal view virtual returns (string memory) {
665         return "";
666     }
667 
668     /**
669      * @dev See {IERC721-approve}.
670      */
671     function approve(address to, uint256 tokenId) public virtual override {
672         address owner = ERC721.ownerOf(tokenId);
673         require(to != owner, "ERC721: approval to current owner");
674 
675         require(
676             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
677             "ERC721: approve caller is not token owner nor approved for all"
678         );
679 
680         _approve(to, tokenId);
681     }
682 
683     /**
684      * @dev See {IERC721-getApproved}.
685      */
686     function getApproved(uint256 tokenId) public view virtual override returns (address) {
687         _requireMinted(tokenId);
688 
689         return _tokenApprovals[tokenId];
690     }
691 
692     /**
693      * @dev See {IERC721-setApprovalForAll}.
694      */
695     function setApprovalForAll(address operator, bool approved) public virtual override {
696         _setApprovalForAll(_msgSender(), operator, approved);
697     }
698 
699     /**
700      * @dev See {IERC721-isApprovedForAll}.
701      */
702     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
703         return _operatorApprovals[owner][operator];
704     }
705 
706     /**
707      * @dev See {IERC721-transferFrom}.
708      */
709     function transferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) public virtual override {
714         //solhint-disable-next-line max-line-length
715         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
716 
717         _transfer(from, to, tokenId);
718     }
719 
720     /**
721      * @dev See {IERC721-safeTransferFrom}.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) public virtual override {
728         safeTransferFrom(from, to, tokenId, "");
729     }
730 
731     /**
732      * @dev See {IERC721-safeTransferFrom}.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes memory data
739     ) public virtual override {
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
741         _safeTransfer(from, to, tokenId, data);
742     }
743 
744     /**
745      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
746      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
747      *
748      * `data` is additional data, it has no specified format and it is sent in call to `to`.
749      *
750      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
751      * implement alternative mechanisms to perform token transfer, such as signature-based.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must exist and be owned by `from`.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _safeTransfer(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory data
767     ) internal virtual {
768         _transfer(from, to, tokenId);
769         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
770     }
771 
772     /**
773      * @dev Returns whether `tokenId` exists.
774      *
775      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
776      *
777      * Tokens start existing when they are minted (`_mint`),
778      * and stop existing when they are burned (`_burn`).
779      */
780     function _exists(uint256 tokenId) internal view virtual returns (bool) {
781         return _owners[tokenId] != address(0);
782     }
783 
784     /**
785      * @dev Returns whether `spender` is allowed to manage `tokenId`.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      */
791     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
792         address owner = ERC721.ownerOf(tokenId);
793         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
794     }
795 
796     /**
797      * @dev Safely mints `tokenId` and transfers it to `to`.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must not exist.
802      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _safeMint(address to, uint256 tokenId) internal virtual {
807         _safeMint(to, tokenId, "");
808     }
809 
810     /**
811      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
812      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
813      */
814     function _safeMint(
815         address to,
816         uint256 tokenId,
817         bytes memory data
818     ) internal virtual {
819         _mint(to, tokenId);
820         require(
821             _checkOnERC721Received(address(0), to, tokenId, data),
822             "ERC721: transfer to non ERC721Receiver implementer"
823         );
824     }
825 
826     /**
827      * @dev Mints `tokenId` and transfers it to `to`.
828      *
829      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
830      *
831      * Requirements:
832      *
833      * - `tokenId` must not exist.
834      * - `to` cannot be the zero address.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _mint(address to, uint256 tokenId) internal virtual {
839         require(to != address(0), "ERC721: mint to the zero address");
840         require(!_exists(tokenId), "ERC721: token already minted");
841 
842         _beforeTokenTransfer(address(0), to, tokenId);
843 
844         _balances[to] += 1;
845         _owners[tokenId] = to;
846 
847         emit Transfer(address(0), to, tokenId);
848 
849         _afterTokenTransfer(address(0), to, tokenId);
850     }
851 
852     /**
853      * @dev Destroys `tokenId`.
854      * The approval is cleared when the token is burned.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _burn(uint256 tokenId) internal virtual {
863         address owner = ERC721.ownerOf(tokenId);
864 
865         _beforeTokenTransfer(owner, address(0), tokenId);
866 
867         // Clear approvals
868         _approve(address(0), tokenId);
869 
870         _balances[owner] -= 1;
871         delete _owners[tokenId];
872 
873         emit Transfer(owner, address(0), tokenId);
874 
875         _afterTokenTransfer(owner, address(0), tokenId);
876     }
877 
878     /**
879      * @dev Transfers `tokenId` from `from` to `to`.
880      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
881      *
882      * Requirements:
883      *
884      * - `to` cannot be the zero address.
885      * - `tokenId` token must be owned by `from`.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _transfer(
890         address from,
891         address to,
892         uint256 tokenId
893     ) internal virtual {
894         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
895         require(to != address(0), "ERC721: transfer to the zero address");
896 
897         _beforeTokenTransfer(from, to, tokenId);
898 
899         // Clear approvals from the previous owner
900         _approve(address(0), tokenId);
901 
902         _balances[from] -= 1;
903         _balances[to] += 1;
904         _owners[tokenId] = to;
905 
906         emit Transfer(from, to, tokenId);
907 
908         _afterTokenTransfer(from, to, tokenId);
909     }
910 
911     /**
912      * @dev Approve `to` to operate on `tokenId`
913      *
914      * Emits an {Approval} event.
915      */
916     function _approve(address to, uint256 tokenId) internal virtual {
917         _tokenApprovals[tokenId] = to;
918         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
919     }
920 
921     /**
922      * @dev Approve `operator` to operate on all of `owner` tokens
923      *
924      * Emits an {ApprovalForAll} event.
925      */
926     function _setApprovalForAll(
927         address owner,
928         address operator,
929         bool approved
930     ) internal virtual {
931         require(owner != operator, "ERC721: approve to caller");
932         _operatorApprovals[owner][operator] = approved;
933         emit ApprovalForAll(owner, operator, approved);
934     }
935 
936     /**
937      * @dev Reverts if the `tokenId` has not been minted yet.
938      */
939     function _requireMinted(uint256 tokenId) internal view virtual {
940         require(_exists(tokenId), "ERC721: invalid token ID");
941     }
942 
943     /**
944      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
945      * The call is not executed if the target address is not a contract.
946      *
947      * @param from address representing the previous owner of the given token ID
948      * @param to target address that will receive the tokens
949      * @param tokenId uint256 ID of the token to be transferred
950      * @param data bytes optional data to send along with the call
951      * @return bool whether the call correctly returned the expected magic value
952      */
953     function _checkOnERC721Received(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory data
958     ) private returns (bool) {
959         if (to.isContract()) {
960             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
961                 return retval == IERC721Receiver.onERC721Received.selector;
962             } catch (bytes memory reason) {
963                 if (reason.length == 0) {
964                     revert("ERC721: transfer to non ERC721Receiver implementer");
965                 } else {
966                     /// @solidity memory-safe-assembly
967                     assembly {
968                         revert(add(32, reason), mload(reason))
969                     }
970                 }
971             }
972         } else {
973             return true;
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before any token transfer. This includes minting
979      * and burning.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` will be minted for `to`.
986      * - When `to` is zero, ``from``'s `tokenId` will be burned.
987      * - `from` and `to` are never both zero.
988      *
989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
990      */
991     function _beforeTokenTransfer(
992         address from,
993         address to,
994         uint256 tokenId
995     ) internal virtual {}
996 
997     /**
998      * @dev Hook that is called after any transfer of tokens. This includes
999      * minting and burning.
1000      *
1001      * Calling conditions:
1002      *
1003      * - when `from` and `to` are both non-zero.
1004      * - `from` and `to` are never both zero.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _afterTokenTransfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) internal virtual {}
1013 }
1014 
1015 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 /**
1020  * @title Counters
1021  * @author Matt Condon (@shrugs)
1022  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1023  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1024  *
1025  * Include with `using Counters for Counters.Counter;`
1026  */
1027 library Counters {
1028     struct Counter {
1029         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1030         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1031         // this feature: see https://github.com/ethereum/solidity/issues/4637
1032         uint256 _value; // default: 0
1033     }
1034 
1035     function current(Counter storage counter) internal view returns (uint256) {
1036         return counter._value;
1037     }
1038 
1039     function increment(Counter storage counter) internal {
1040         unchecked {
1041             counter._value += 1;
1042         }
1043     }
1044 
1045     function decrement(Counter storage counter) internal {
1046         uint256 value = counter._value;
1047         require(value > 0, "Counter: decrement overflow");
1048         unchecked {
1049             counter._value = value - 1;
1050         }
1051     }
1052 
1053     function reset(Counter storage counter) internal {
1054         counter._value = 0;
1055     }
1056 }
1057 
1058 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 /**
1063  * @dev Contract module which provides a basic access control mechanism, where
1064  * there is an account (an owner) that can be granted exclusive access to
1065  * specific functions.
1066  *
1067  * By default, the owner account will be the one that deploys the contract. This
1068  * can later be changed with {transferOwnership}.
1069  *
1070  * This module is used through inheritance. It will make available the modifier
1071  * `onlyOwner`, which can be applied to your functions to restrict their use to
1072  * the owner.
1073  */
1074 abstract contract Ownable is Context {
1075     address private _owner;
1076 
1077     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1078 
1079     /**
1080      * @dev Initializes the contract setting the deployer as the initial owner.
1081      */
1082     constructor() {
1083         _transferOwnership(_msgSender());
1084     }
1085 
1086     /**
1087      * @dev Throws if called by any account other than the owner.
1088      */
1089     modifier onlyOwner() {
1090         _checkOwner();
1091         _;
1092     }
1093 
1094     /**
1095      * @dev Returns the address of the current owner.
1096      */
1097     function owner() public view virtual returns (address) {
1098         return _owner;
1099     }
1100 
1101     /**
1102      * @dev Throws if the sender is not the owner.
1103      */
1104     function _checkOwner() internal view virtual {
1105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1106     }
1107 
1108     /**
1109      * @dev Leaves the contract without owner. It will not be possible to call
1110      * `onlyOwner` functions anymore. Can only be called by the current owner.
1111      *
1112      * NOTE: Renouncing ownership will leave the contract without an owner,
1113      * thereby removing any functionality that is only available to the owner.
1114      */
1115     function renounceOwnership() public virtual onlyOwner {
1116         _transferOwnership(address(0));
1117     }
1118 
1119     /**
1120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1121      * Can only be called by the current owner.
1122      */
1123     function transferOwnership(address newOwner) public virtual onlyOwner {
1124         require(newOwner != address(0), "Ownable: new owner is the zero address");
1125         _transferOwnership(newOwner);
1126     }
1127 
1128     /**
1129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1130      * Internal function without access restriction.
1131      */
1132     function _transferOwnership(address newOwner) internal virtual {
1133         address oldOwner = _owner;
1134         _owner = newOwner;
1135         emit OwnershipTransferred(oldOwner, newOwner);
1136     }
1137 }
1138 
1139 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 /**
1144  * @dev ERC721 token with storage based token URI management.
1145  */
1146 abstract contract ERC721URIStorage is ERC721 {
1147     using Strings for uint256;
1148 
1149     // Optional mapping for token URIs
1150     mapping(uint256 => string) private _tokenURIs;
1151 
1152     /**
1153      * @dev See {IERC721Metadata-tokenURI}.
1154      */
1155     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1156         _requireMinted(tokenId);
1157 
1158         string memory _tokenURI = _tokenURIs[tokenId];
1159         string memory base = _baseURI();
1160 
1161         // If there is no base URI, return the token URI.
1162         if (bytes(base).length == 0) {
1163             return _tokenURI;
1164         }
1165         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1166         if (bytes(_tokenURI).length > 0) {
1167             return string(abi.encodePacked(base, _tokenURI));
1168         }
1169 
1170         return super.tokenURI(tokenId);
1171     }
1172 
1173     /**
1174      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      */
1180     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1181         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1182         _tokenURIs[tokenId] = _tokenURI;
1183     }
1184 
1185     /**
1186      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1187      * token-specific URI was set for the token, and if so, it deletes the token URI from
1188      * the storage mapping.
1189      */
1190     function _burn(uint256 tokenId) internal virtual override {
1191         super._burn(tokenId);
1192 
1193         if (bytes(_tokenURIs[tokenId]).length != 0) {
1194             delete _tokenURIs[tokenId];
1195         }
1196     }
1197 }
1198 
1199 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1200 pragma solidity >=0.6.0 <0.9.0;
1201 contract SimpleGuys is ERC721URIStorage, Ownable {
1202     using Counters for Counters.Counter;
1203     Counters.Counter private _tokenIds;
1204 
1205     uint256 public totalSupply;
1206     uint256 public collectionSize;
1207     uint256 public maxPerWallet;
1208     uint256 public simpleListCost;
1209     uint256 public devMints;
1210 
1211     string public baseURI;
1212     string public notRevealedURI;
1213 
1214     bool public simpleListMintEnabled = false;
1215     bool public revealed = false;
1216 
1217     mapping(address => uint256) public walletMints;
1218 
1219     constructor(
1220         uint256 maxPerWallet_,
1221         uint256 simpleListCost_,
1222         uint256 devMints_,
1223         string memory baseURI_,
1224         string memory notRevealedURI_
1225     ) ERC721("SimpleGuys", "SIMPLE") {
1226         totalSupply = 0;
1227         collectionSize = 4444;
1228         maxPerWallet = maxPerWallet_;
1229         simpleListCost = simpleListCost_;
1230         devMints = devMints_;
1231         baseURI = baseURI_;
1232         notRevealedURI = notRevealedURI_;
1233     }
1234 
1235     //Only Owner
1236     function reveal(bool reveal_) external onlyOwner {
1237         revealed = reveal_;
1238     }
1239 
1240     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1241         baseURI = _newBaseURI;
1242     }
1243 
1244     function setNotRevealedBaseURI(string memory _newBaseURI)
1245         external
1246         onlyOwner
1247     {
1248         notRevealedURI = _newBaseURI;
1249     }
1250 
1251     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1252         maxPerWallet = maxPerWallet_;
1253     }
1254 
1255     function setSimpleListCost(uint256 simpleListCost_) external onlyOwner {
1256         simpleListCost = simpleListCost_;
1257     }
1258 
1259     function setDevMints(uint256 devMints_) external onlyOwner {
1260         devMints = devMints_;
1261     }
1262 
1263     function setSimpleListMintEnabled(bool simpleListMintEnabled_)
1264         external
1265         onlyOwner
1266     {
1267         simpleListMintEnabled = simpleListMintEnabled_;
1268     }
1269 
1270     function withdraw(address to_) external onlyOwner {
1271         payable(to_).transfer(address(this).balance);
1272     }
1273 
1274     function devMint() external onlyOwner {
1275         require(walletMints[msg.sender] <= devMints, "Exceed dev mint");
1276         mint(devMints);
1277     }
1278 
1279     function getWalletMints() external view returns (uint256) {
1280         return walletMints[msg.sender];
1281     }
1282 
1283     function getTotalSupply() external view returns (uint256) {
1284         return totalSupply;
1285     }
1286 
1287     function getCollectionSize() external view returns (uint256) {
1288         return collectionSize;
1289     }
1290 
1291     function getWhitelistStatus() external view returns (bool) {
1292         return simpleListMintEnabled;
1293     }
1294 
1295     //Public
1296 
1297     function tokenURI(uint256 tokenId)
1298         public
1299         view
1300         virtual
1301         override
1302         returns (string memory)
1303     {
1304         require(
1305             _exists(tokenId),
1306             "ERC721Metadata: URI query for nonexistent token"
1307         );
1308 
1309         if (revealed == false) {
1310             return notRevealedURI;
1311         }
1312 
1313         string memory currentBaseURI = baseURI;
1314         return
1315             bytes(currentBaseURI).length > 0
1316                 ? string(abi.encodePacked(currentBaseURI, tokenId, ".json"))
1317                 : "";
1318     }
1319 
1320     function mint(uint256 quantity_) internal {
1321         require(quantity_ <= 3, "Too many mints");
1322         for (uint256 i = 0; i < quantity_; i++) {
1323             _tokenIds.increment();
1324             uint256 newItemId = _tokenIds.current();
1325             _safeMint(msg.sender, newItemId);
1326             totalSupply++;
1327         }
1328 
1329         walletMints[msg.sender] += quantity_;
1330     }
1331 
1332     function mintSimpleList(uint256 quantity_) external payable {
1333         require(simpleListMintEnabled, "Simple list minting is not enabled");
1334         require(
1335             totalSupply + quantity_ <= collectionSize,
1336             "All SimpleGuys have been minted"
1337         );
1338         require(
1339             walletMints[msg.sender] + quantity_ <= maxPerWallet,
1340             "Exceed max mint"
1341         );
1342 
1343         if (quantity_ == 1) {
1344             if (walletMints[msg.sender] == 0) {
1345                 mint(quantity_);
1346             } else {
1347                 require(
1348                     msg.value * quantity_ >= simpleListCost * quantity_,
1349                     "Not enough ether for mint"
1350                 );
1351                 mint(quantity_);
1352             }
1353         } else {
1354             if (walletMints[msg.sender] == 0) {
1355                 require(
1356                     msg.value * (quantity_ - 1) >= simpleListCost * (quantity_ - 1),
1357                     "Not enough ether for mint"
1358                 );
1359                 mint(quantity_);
1360             } else {
1361                 require(
1362                     msg.value * (quantity_) >= simpleListCost * (quantity_),
1363                     "Not enough ether for mint"
1364                 );
1365                 mint(quantity_);
1366             }
1367         }
1368     }
1369 }