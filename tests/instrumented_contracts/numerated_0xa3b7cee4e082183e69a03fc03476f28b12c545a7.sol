1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.https://bafybeihtl7sst4jza7r3myipylg5z5ywktt2zritdqnvxbqrvaw5qpvkmu.ipfs.infura-ipfs.io/0.png
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
168 
169 /**
170  * @title ERC721 token receiver interface
171  * @dev Interface for any contract that wants to support safeTransfers
172  * from ERC721 asset contracts.
173  */
174 interface IERC721Receiver {
175     /**
176      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
177      * by `operator` from `from`, this function is called.
178      *
179      * It must return its Solidity selector to confirm the token transfer.
180      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
181      *
182      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
183      */
184     function onERC721Received(
185         address operator,
186         address from,
187         uint256 tokenId,
188         bytes calldata data
189     ) external returns (bytes4);
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Metadata is IERC721 {
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 // File: @openzeppelin/contracts/utils/Address.sol
216 
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         assembly {
245             size := extcodesize(account)
246         }
247         return size > 0;
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
430 // File: @openzeppelin/contracts/utils/Context.sol
431 
432 /**
433  * @dev Provides information about the current execution context, including the
434  * sender of the transaction and its data. While these are generally available
435  * via msg.sender and msg.data, they should not be accessed in such a direct
436  * manner, since when dealing with meta-transactions the account sending and
437  * paying for execution may not be the actual sender (as far as an application
438  * is concerned).
439  *
440  * This contract is only required for intermediate, library-like contracts.
441  */
442 abstract contract Context {
443     function _msgSender() internal view virtual returns (address) {
444         return msg.sender;
445     }
446 
447     function _msgData() internal view virtual returns (bytes calldata) {
448         return msg.data;
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Strings.sol
453 
454 /**
455  * @dev String operations.
456  */
457 library Strings {
458     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
462      */
463     function toString(uint256 value) internal pure returns (string memory) {
464         // Inspired by OraclizeAPI's implementation - MIT licence
465         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
466 
467         if (value == 0) {
468             return "0";
469         }
470         uint256 temp = value;
471         uint256 digits;
472         while (temp != 0) {
473             digits++;
474             temp /= 10;
475         }
476         bytes memory buffer = new bytes(digits);
477         while (value != 0) {
478             digits -= 1;
479             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
480             value /= 10;
481         }
482         return string(buffer);
483     }
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
487      */
488     function toHexString(uint256 value) internal pure returns (string memory) {
489         if (value == 0) {
490             return "0x00";
491         }
492         uint256 temp = value;
493         uint256 length = 0;
494         while (temp != 0) {
495             length++;
496             temp >>= 8;
497         }
498         return toHexString(value, length);
499     }
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
503      */
504     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
505         bytes memory buffer = new bytes(2 * length + 2);
506         buffer[0] = "0";
507         buffer[1] = "x";
508         for (uint256 i = 2 * length + 1; i > 1; --i) {
509             buffer[i] = _HEX_SYMBOLS[value & 0xf];
510             value >>= 4;
511         }
512         require(value == 0, "Strings: hex length insufficient");
513         return string(buffer);
514     }
515 }
516 
517 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
518 
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
543 
544 /**
545  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
546  * the Metadata extension, but not including the Enumerable extension, which is available separately as
547  * {ERC721Enumerable}.
548  */
549 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
550     using Address for address;
551     using Strings for uint256;
552 
553     // Token name
554     string private _name;
555 
556     // Token symbol
557     string private _symbol;
558 
559     // Mapping from token ID to owner address
560     mapping(uint256 => address) private _owners;
561 
562     // Mapping owner address to token count
563     mapping(address => uint256) private _balances;
564 
565     // Mapping from token ID to approved address
566     mapping(uint256 => address) private _tokenApprovals;
567 
568     // Mapping from owner to operator approvals
569     mapping(address => mapping(address => bool)) private _operatorApprovals;
570 
571     /**
572      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
573      */
574     constructor(string memory name_, string memory symbol_) {
575         _name = name_;
576         _symbol = symbol_;
577     }
578 
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
583         return
584             interfaceId == type(IERC721).interfaceId ||
585             interfaceId == type(IERC721Metadata).interfaceId ||
586             super.supportsInterface(interfaceId);
587     }
588 
589     /**
590      * @dev See {IERC721-balanceOf}.
591      */
592     function balanceOf(address owner) public view virtual override returns (uint256) {
593         require(owner != address(0), "ERC721: balance query for the zero address");
594         return _balances[owner];
595     }
596 
597     /**
598      * @dev See {IERC721-ownerOf}.
599      */
600     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
601         address owner = _owners[tokenId];
602         require(owner != address(0), "ERC721: owner query for nonexistent token");
603         return owner;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-name}.
608      */
609     function name() public view virtual override returns (string memory) {
610         return _name;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-symbol}.
615      */
616     function symbol() public view virtual override returns (string memory) {
617         return _symbol;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-tokenURI}.
622      */
623     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
624         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
625 
626         string memory baseURI = _baseURI();
627         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
628     }
629 
630     /**
631      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
632      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
633      * by default, can be overriden in child contracts.
634      */
635     function _baseURI() internal view virtual returns (string memory) {
636         return "";
637     }
638 
639     /**
640      * @dev See {IERC721-approve}.
641      */
642     function approve(address to, uint256 tokenId) public virtual override {
643         address owner = ERC721.ownerOf(tokenId);
644         require(to != owner, "ERC721: approval to current owner");
645 
646         require(
647             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
648             "ERC721: approve caller is not owner nor approved for all"
649         );
650 
651         _approve(to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-getApproved}.
656      */
657     function getApproved(uint256 tokenId) public view virtual override returns (address) {
658         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
659 
660         return _tokenApprovals[tokenId];
661     }
662 
663     /**
664      * @dev See {IERC721-setApprovalForAll}.
665      */
666     function setApprovalForAll(address operator, bool approved) public virtual override {
667         require(operator != _msgSender(), "ERC721: approve to caller");
668 
669         _operatorApprovals[_msgSender()][operator] = approved;
670         emit ApprovalForAll(_msgSender(), operator, approved);
671     }
672 
673     /**
674      * @dev See {IERC721-isApprovedForAll}.
675      */
676     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
677         return _operatorApprovals[owner][operator];
678     }
679 
680     /**
681      * @dev See {IERC721-transferFrom}.
682      */
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) public virtual override {
688         //solhint-disable-next-line max-line-length
689         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
690 
691         _transfer(from, to, tokenId);
692     }
693 
694     /**
695      * @dev See {IERC721-safeTransferFrom}.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) public virtual override {
702         safeTransferFrom(from, to, tokenId, "");
703     }
704 
705     /**
706      * @dev See {IERC721-safeTransferFrom}.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId,
712         bytes memory _data
713     ) public virtual override {
714         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
715         _safeTransfer(from, to, tokenId, _data);
716     }
717 
718     /**
719      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
720      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
721      *
722      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
723      *
724      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
725      * implement alternative mechanisms to perform token transfer, such as signature-based.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _safeTransfer(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) internal virtual {
742         _transfer(from, to, tokenId);
743         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
744     }
745 
746     /**
747      * @dev Returns whether `tokenId` exists.
748      *
749      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
750      *
751      * Tokens start existing when they are minted (`_mint`),
752      * and stop existing when they are burned (`_burn`).
753      */
754     function _exists(uint256 tokenId) internal view virtual returns (bool) {
755         return _owners[tokenId] != address(0);
756     }
757 
758     /**
759      * @dev Returns whether `spender` is allowed to manage `tokenId`.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
766         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
767         address owner = ERC721.ownerOf(tokenId);
768         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
769     }
770 
771     /**
772      * @dev Safely mints `tokenId` and transfers it to `to`.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must not exist.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _safeMint(address to, uint256 tokenId) internal virtual {
782         _safeMint(to, tokenId, "");
783     }
784 
785     /**
786      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
787      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
788      */
789     function _safeMint(
790         address to,
791         uint256 tokenId,
792         bytes memory _data
793     ) internal virtual {
794         _mint(to, tokenId);
795         require(
796             _checkOnERC721Received(address(0), to, tokenId, _data),
797             "ERC721: transfer to non ERC721Receiver implementer"
798         );
799     }
800 
801     /**
802      * @dev Mints `tokenId` and transfers it to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
805      *
806      * Requirements:
807      *
808      * - `tokenId` must not exist.
809      * - `to` cannot be the zero address.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _mint(address to, uint256 tokenId) internal virtual {
814         require(to != address(0), "ERC721: mint to the zero address");
815         require(!_exists(tokenId), "ERC721: token already minted");
816 
817         _beforeTokenTransfer(address(0), to, tokenId);
818 
819         _balances[to] += 1;
820         _owners[tokenId] = to;
821 
822         emit Transfer(address(0), to, tokenId);
823     }
824 
825     /**
826      * @dev Destroys `tokenId`.
827      * The approval is cleared when the token is burned.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _burn(uint256 tokenId) internal virtual {
836         address owner = ERC721.ownerOf(tokenId);
837 
838         _beforeTokenTransfer(owner, address(0), tokenId);
839 
840         // Clear approvals
841         _approve(address(0), tokenId);
842 
843         _balances[owner] -= 1;
844         delete _owners[tokenId];
845 
846         emit Transfer(owner, address(0), tokenId);
847     }
848 
849     /**
850      * @dev Transfers `tokenId` from `from` to `to`.
851      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
852      *
853      * Requirements:
854      *
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must be owned by `from`.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _transfer(
861         address from,
862         address to,
863         uint256 tokenId
864     ) internal virtual {
865         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
866         require(to != address(0), "ERC721: transfer to the zero address");
867 
868         _beforeTokenTransfer(from, to, tokenId);
869 
870         // Clear approvals from the previous owner
871         _approve(address(0), tokenId);
872 
873         _balances[from] -= 1;
874         _balances[to] += 1;
875         _owners[tokenId] = to;
876 
877         emit Transfer(from, to, tokenId);
878     }
879 
880     /**
881      * @dev Approve `to` to operate on `tokenId`
882      *
883      * Emits a {Approval} event.
884      */
885     function _approve(address to, uint256 tokenId) internal virtual {
886         _tokenApprovals[tokenId] = to;
887         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
888     }
889 
890     /**
891      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
892      * The call is not executed if the target address is not a contract.
893      *
894      * @param from address representing the previous owner of the given token ID
895      * @param to target address that will receive the tokens
896      * @param tokenId uint256 ID of the token to be transferred
897      * @param _data bytes optional data to send along with the call
898      * @return bool whether the call correctly returned the expected magic value
899      */
900     function _checkOnERC721Received(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) private returns (bool) {
906         if (to.isContract()) {
907             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
908                 return retval == IERC721Receiver.onERC721Received.selector;
909             } catch (bytes memory reason) {
910                 if (reason.length == 0) {
911                     revert("ERC721: transfer to non ERC721Receiver implementer");
912                 } else {
913                     assembly {
914                         revert(add(32, reason), mload(reason))
915                     }
916                 }
917             }
918         } else {
919             return true;
920         }
921     }
922 
923     /**
924      * @dev Hook that is called before any token transfer. This includes minting
925      * and burning.
926      *
927      * Calling conditions:
928      *
929      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
930      * transferred to `to`.
931      * - When `from` is zero, `tokenId` will be minted for `to`.
932      * - When `to` is zero, ``from``'s `tokenId` will be burned.
933      * - `from` and `to` are never both zero.
934      *
935      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
936      */
937     function _beforeTokenTransfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {}
942 }
943 
944 // File: @openzeppelin/contracts/access/Ownable.sol
945 
946 /**
947  * @dev Contract module which provides a basic access control mechanism, where
948  * there is an account (an owner) that can be granted exclusive access to
949  * specific functions.
950  *
951  * By default, the owner account will be the one that deploys the contract. This
952  * can later be changed with {transferOwnership}.
953  *
954  * This module is used through inheritance. It will make available the modifier
955  * `onlyOwner`, which can be applied to your functions to restrict their use to
956  * the owner.
957  */
958 abstract contract Ownable is Context {
959     address private _owner;
960 
961     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
962 
963     /**
964      * @dev Initializes the contract setting the deployer as the initial owner.
965      */
966     constructor() {
967         _setOwner(_msgSender());
968     }
969 
970     /**
971      * @dev Returns the address of the current owner.
972      */
973     function owner() public view virtual returns (address) {
974         return _owner;
975     }
976 
977     /**
978      * @dev Throws if called by any account other than the owner.
979      */
980     modifier onlyOwner() {
981         require(owner() == _msgSender(), "Ownable: caller is not the owner");
982         _;
983     }
984 
985     /**
986      * @dev Leaves the contract without owner. It will not be possible to call
987      * `onlyOwner` functions anymore. Can only be called by the current owner.
988      *
989      * NOTE: Renouncing ownership will leave the contract without an owner,
990      * thereby removing any functionality that is only available to the owner.
991      */
992     function renounceOwnership() public virtual onlyOwner {
993         _setOwner(address(0));
994     }
995 
996     /**
997      * @dev Transfers ownership of the contract to a new account (`newOwner`).
998      * Can only be called by the current owner.
999      */
1000     function transferOwnership(address newOwner) public virtual onlyOwner {
1001         require(newOwner != address(0), "Ownable: new owner is the zero address");
1002         _setOwner(newOwner);
1003     }
1004 
1005     function _setOwner(address newOwner) private {
1006         address oldOwner = _owner;
1007         _owner = newOwner;
1008         emit OwnershipTransferred(oldOwner, newOwner);
1009     }
1010 }
1011 
1012 // File: @openzeppelin/contracts/security/Pausable.sol
1013 
1014 /**
1015  * @dev Contract module which allows children to implement an emergency stop
1016  * mechanism that can be triggered by an authorized account.
1017  *
1018  * This module is used through inheritance. It will make available the
1019  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1020  * the functions of your contract. Note that they will not be pausable by
1021  * simply including this module, only once the modifiers are put in place.
1022  */
1023 abstract contract Pausable is Context {
1024     /**
1025      * @dev Emitted when the pause is triggered by `account`.
1026      */
1027     event Paused(address account);
1028 
1029     /**
1030      * @dev Emitted when the pause is lifted by `account`.
1031      */
1032     event Unpaused(address account);
1033 
1034     bool private _paused;
1035 
1036     /**
1037      * @dev Initializes the contract in unpaused state.
1038      */
1039     constructor() {
1040         _paused = false;
1041     }
1042 
1043     /**
1044      * @dev Returns true if the contract is paused, and false otherwise.
1045      */
1046     function paused() public view virtual returns (bool) {
1047         return _paused;
1048     }
1049 
1050     /**
1051      * @dev Modifier to make a function callable only when the contract is not paused.
1052      *
1053      * Requirements:
1054      *
1055      * - The contract must not be paused.
1056      */
1057     modifier whenNotPaused() {
1058         require(!paused(), "Pausable: paused");
1059         _;
1060     }
1061 
1062     /**
1063      * @dev Modifier to make a function callable only when the contract is paused.
1064      *
1065      * Requirements:
1066      *
1067      * - The contract must be paused.
1068      */
1069     modifier whenPaused() {
1070         require(paused(), "Pausable: not paused");
1071         _;
1072     }
1073 
1074     /**
1075      * @dev Triggers stopped state.
1076      *
1077      * Requirements:
1078      *
1079      * - The contract must not be paused.
1080      */
1081     function _pause() internal virtual whenNotPaused {
1082         _paused = true;
1083         emit Paused(_msgSender());
1084     }
1085 
1086     /**
1087      * @dev Returns to normal state.
1088      *
1089      * Requirements:
1090      *
1091      * - The contract must be paused.
1092      */
1093     function _unpause() internal virtual whenPaused {
1094         _paused = false;
1095         emit Unpaused(_msgSender());
1096     }
1097 }
1098 
1099 // File: contracts/ChillFrogs.sol
1100 
1101 contract ChillFrogs is ERC721, Ownable, Pausable {
1102 
1103     uint256 public constant MAX_PER_CALL = 20;
1104     uint256 public constant MAX_PER_CALL_PRESALE = 4;
1105     uint256 public constant MAX_SUPPLY = 6000;
1106     uint256 public constant NFT_PRICE = 0.045e18;
1107 
1108     string internal baseURI;
1109     bool public presaleOngoing;
1110 
1111     uint256 public totalSupply;
1112 
1113     mapping(address => bool) public presaleWhitelist;
1114     mapping(address => uint256) public presaleMintedAmounts;
1115 
1116     constructor() ERC721("Chill Frogs", "FROGS") {
1117         _pause();
1118     }
1119 
1120     function mint(uint256 amount) external payable whenNotPaused {
1121         require(amount <= MAX_PER_CALL, "Amount exceeds max per tx");
1122 
1123         uint256 newSupply = totalSupply + amount;
1124 
1125         require(newSupply <= MAX_SUPPLY, "Amount exceeds max supply");
1126         require(msg.value == NFT_PRICE * amount, "Wrong eth amount");
1127 
1128         for (uint256 i = 0; i < amount; i++) {
1129             _mint(msg.sender, totalSupply + i);
1130         }
1131 
1132         totalSupply = newSupply;
1133     }
1134 
1135     function mintOwner(uint256 amount) external onlyOwner {
1136         uint256 newSupply = totalSupply + amount;
1137         require(newSupply <= MAX_SUPPLY, "Amount exceeds max supply");
1138 
1139         for (uint256 i = 0; i < amount; i++) {
1140             _mint(msg.sender, totalSupply + i);
1141         }
1142 
1143         totalSupply = newSupply;
1144     }
1145 
1146     function mintPresale(uint256 amount) external payable whenPaused {
1147         require(presaleOngoing, "Presale hasn't started yet");
1148         require(presaleWhitelist[msg.sender], "Address isn't whitelisted");
1149         require(presaleMintedAmounts[msg.sender] + amount <= MAX_PER_CALL_PRESALE, "Amount exceeds presale max");
1150         require(msg.value == NFT_PRICE * amount, "Wrong eth amount");
1151 
1152         for (uint256 i = 0; i < amount; i++) {
1153             _mint(msg.sender, totalSupply + i);
1154         }
1155 
1156         totalSupply = totalSupply + amount;
1157         
1158         presaleMintedAmounts[msg.sender] = presaleMintedAmounts[msg.sender] + amount;
1159     }
1160 
1161     function addAddressesToWhitelist(address[] memory whitelisted) external onlyOwner {
1162         for (uint256 i = 0; i < whitelisted.length; i++) {
1163             presaleWhitelist[whitelisted[i]] = true;
1164         }
1165     }
1166 
1167     function startPresale() external onlyOwner {
1168         presaleOngoing = true;
1169     }
1170 
1171     function setBaseURI(string memory uri) external onlyOwner {
1172         baseURI = uri;
1173     }
1174 
1175     function unpause() external onlyOwner {
1176         _unpause();
1177     }
1178 
1179     function withdraw() external onlyOwner {
1180         payable(msg.sender).transfer(address(this).balance);
1181     }
1182 
1183     function _baseURI() internal override view returns(string memory) {
1184         return baseURI;
1185     }
1186 }