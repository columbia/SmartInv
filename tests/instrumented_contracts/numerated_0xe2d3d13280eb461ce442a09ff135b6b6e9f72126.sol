1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Collection of functions related to the address type
32  */
33 library Address {
34     /**
35      * @dev Returns true if `account` is a contract.
36      *
37      * [IMPORTANT]
38      * ====
39      * It is unsafe to assume that an address for which this function returns
40      * false is an externally-owned account (EOA) and not a contract.
41      *
42      * Among others, `isContract` will return false for the following
43      * types of addresses:
44      *
45      *  - an externally-owned account
46      *  - a contract in construction
47      *  - an address where a contract will be created
48      *  - an address where a contract lived, but was destroyed
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies on extcodesize, which returns 0 for contracts in
53         // construction, since the code is only stored at the end of the
54         // constructor execution.
55 
56         uint256 size;
57         assembly {
58             size := extcodesize(account)
59         }
60         return size > 0;
61     }
62 
63     /**
64      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
65      * `recipient`, forwarding all available gas and reverting on errors.
66      *
67      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
68      * of certain opcodes, possibly making contracts go over the 2300 gas limit
69      * imposed by `transfer`, making them unable to receive funds via
70      * `transfer`. {sendValue} removes this limitation.
71      *
72      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
73      *
74      * IMPORTANT: because control is transferred to `recipient`, care must be
75      * taken to not create reentrancy vulnerabilities. Consider using
76      * {ReentrancyGuard} or the
77      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
78      */
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         (bool success, ) = recipient.call{value: amount}("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     /**
87      * @dev Performs a Solidity function call using a low level `call`. A
88      * plain `call` is an unsafe replacement for a function call: use this
89      * function instead.
90      *
91      * If `target` reverts with a revert reason, it is bubbled up by this
92      * function (like regular Solidity function calls).
93      *
94      * Returns the raw returned data. To convert to the expected return value,
95      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
96      *
97      * Requirements:
98      *
99      * - `target` must be a contract.
100      * - calling `target` with `data` must not revert.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
110      * `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(
115         address target,
116         bytes memory data,
117         string memory errorMessage
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but also transferring `value` wei to `target`.
125      *
126      * Requirements:
127      *
128      * - the calling contract must have an ETH balance of at least `value`.
129      * - the called Solidity function must be `payable`.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value
137     ) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
143      * with `errorMessage` as a fallback revert reason when `target` reverts.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value,
151         string memory errorMessage
152     ) internal returns (bytes memory) {
153         require(address(this).balance >= value, "Address: insufficient balance for call");
154         require(isContract(target), "Address: call to non-contract");
155 
156         (bool success, bytes memory returndata) = target.call{value: value}(data);
157         return verifyCallResult(success, returndata, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
162      * but performing a static call.
163      *
164      * _Available since v3.3._
165      */
166     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
167         return functionStaticCall(target, data, "Address: low-level static call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal view returns (bytes memory) {
181         require(isContract(target), "Address: static call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.staticcall(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but performing a delegate call.
190      *
191      * _Available since v3.4._
192      */
193     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(isContract(target), "Address: delegate call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
216      * revert reason using the provided one.
217      *
218      * _Available since v4.3._
219      */
220     function verifyCallResult(
221         bool success,
222         bytes memory returndata,
223         string memory errorMessage
224     ) internal pure returns (bytes memory) {
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231 
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 /**
244  * @dev String operations.
245  */
246 library Strings {
247     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
248 
249     /**
250      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
251      */
252     function toString(uint256 value) internal pure returns (string memory) {
253         // Inspired by OraclizeAPI's implementation - MIT licence
254         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
255 
256         if (value == 0) {
257             return "0";
258         }
259         uint256 temp = value;
260         uint256 digits;
261         while (temp != 0) {
262             digits++;
263             temp /= 10;
264         }
265         bytes memory buffer = new bytes(digits);
266         while (value != 0) {
267             digits -= 1;
268             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
269             value /= 10;
270         }
271         return string(buffer);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
276      */
277     function toHexString(uint256 value) internal pure returns (string memory) {
278         if (value == 0) {
279             return "0x00";
280         }
281         uint256 temp = value;
282         uint256 length = 0;
283         while (temp != 0) {
284             length++;
285             temp >>= 8;
286         }
287         return toHexString(value, length);
288     }
289 
290     /**
291      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
292      */
293     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
294         bytes memory buffer = new bytes(2 * length + 2);
295         buffer[0] = "0";
296         buffer[1] = "x";
297         for (uint256 i = 2 * length + 1; i > 1; --i) {
298             buffer[i] = _HEX_SYMBOLS[value & 0xf];
299             value >>= 4;
300         }
301         require(value == 0, "Strings: hex length insufficient");
302         return string(buffer);
303     }
304 }
305 
306 /**
307  * @dev Interface of the ERC165 standard, as defined in the
308  * https://eips.ethereum.org/EIPS/eip-165[EIP].
309  *
310  * Implementers can declare support of contract interfaces, which can then be
311  * queried by others ({ERC165Checker}).
312  *
313  * For an implementation, see {ERC165}.
314  */
315 interface IERC165 {
316     /**
317      * @dev Returns true if this contract implements the interface defined by
318      * `interfaceId`. See the corresponding
319      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
320      * to learn more about how these ids are created.
321      *
322      * This function call must use less than 30 000 gas.
323      */
324     function supportsInterface(bytes4 interfaceId) external view returns (bool);
325 }
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
331  * for the additional interface id that will be supported. For example:
332  *
333  * ```solidity
334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
336  * }
337  * ```
338  *
339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
340  */
341 abstract contract ERC165 is IERC165 {
342     /**
343      * @dev See {IERC165-supportsInterface}.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 /**
351  * @dev Required interface of an ERC721 compliant contract.
352  */
353 interface IERC721 is IERC165 {
354     /**
355      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
358 
359     /**
360      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
361      */
362     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
363 
364     /**
365      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
366      */
367     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
368 
369     /**
370      * @dev Returns the number of tokens in ``owner``'s account.
371      */
372     function balanceOf(address owner) external view returns (uint256 balance);
373 
374     /**
375      * @dev Returns the owner of the `tokenId` token.
376      *
377      * Requirements:
378      *
379      * - `tokenId` must exist.
380      */
381     function ownerOf(uint256 tokenId) external view returns (address owner);
382 
383     /**
384      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
385      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
394      *
395      * Emits a {Transfer} event.
396      */
397     function safeTransferFrom(
398         address from,
399         address to,
400         uint256 tokenId
401     ) external;
402 
403     /**
404      * @dev Transfers `tokenId` token from `from` to `to`.
405      *
406      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external;
422 
423     /**
424      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
425      * The approval is cleared when the token is transferred.
426      *
427      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
428      *
429      * Requirements:
430      *
431      * - The caller must own the token or be an approved operator.
432      * - `tokenId` must exist.
433      *
434      * Emits an {Approval} event.
435      */
436     function approve(address to, uint256 tokenId) external;
437 
438     /**
439      * @dev Returns the account approved for `tokenId` token.
440      *
441      * Requirements:
442      *
443      * - `tokenId` must exist.
444      */
445     function getApproved(uint256 tokenId) external view returns (address operator);
446 
447     /**
448      * @dev Approve or remove `operator` as an operator for the caller.
449      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
450      *
451      * Requirements:
452      *
453      * - The `operator` cannot be the caller.
454      *
455      * Emits an {ApprovalForAll} event.
456      */
457     function setApprovalForAll(address operator, bool _approved) external;
458 
459     /**
460      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
461      *
462      * See {setApprovalForAll}
463      */
464     function isApprovedForAll(address owner, address operator) external view returns (bool);
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`.
468      *
469      * Requirements:
470      *
471      * - `from` cannot be the zero address.
472      * - `to` cannot be the zero address.
473      * - `tokenId` token must exist and be owned by `from`.
474      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
476      *
477      * Emits a {Transfer} event.
478      */
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 tokenId,
483         bytes calldata data
484     ) external;
485 }
486 
487 /**
488  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
489  * @dev See https://eips.ethereum.org/EIPS/eip-721
490  */
491 interface IERC721Metadata is IERC721 {
492     /**
493      * @dev Returns the token collection name.
494      */
495     function name() external view returns (string memory);
496 
497     /**
498      * @dev Returns the token collection symbol.
499      */
500     function symbol() external view returns (string memory);
501 
502     /**
503      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
504      */
505     function tokenURI(uint256 tokenId) external view returns (string memory);
506 }
507 
508 /**
509  * @title ERC721 token receiver interface
510  * @dev Interface for any contract that wants to support safeTransfers
511  * from ERC721 asset contracts.
512  */
513 interface IERC721Receiver {
514     /**
515      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
516      * by `operator` from `from`, this function is called.
517      *
518      * It must return its Solidity selector to confirm the token transfer.
519      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
520      *
521      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
522      */
523     function onERC721Received(
524         address operator,
525         address from,
526         uint256 tokenId,
527         bytes calldata data
528     ) external returns (bytes4);
529 }
530 
531 /**
532  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
533  * the Metadata extension, but not including the Enumerable extension, which is available separately as
534  * {ERC721Enumerable}.
535  */
536 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
537     using Address for address;
538     using Strings for uint256;
539 
540     // Token name
541     string private _name;
542 
543     // Token symbol
544     string private _symbol;
545 
546     // Mapping from token ID to owner address
547     mapping(uint256 => address) private _owners;
548 
549     // Mapping owner address to token count
550     mapping(address => uint256) private _balances;
551 
552     // Mapping from token ID to approved address
553     mapping(uint256 => address) private _tokenApprovals;
554 
555     // Mapping from owner to operator approvals
556     mapping(address => mapping(address => bool)) private _operatorApprovals;
557 
558     /**
559      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
560      */
561     constructor(string memory name_, string memory symbol_) {
562         _name = name_;
563         _symbol = symbol_;
564     }
565 
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
570         return
571             interfaceId == type(IERC721).interfaceId ||
572             interfaceId == type(IERC721Metadata).interfaceId ||
573             super.supportsInterface(interfaceId);
574     }
575 
576     /**
577      * @dev See {IERC721-balanceOf}.
578      */
579     function balanceOf(address owner) public view virtual override returns (uint256) {
580         require(owner != address(0), "ERC721: balance query for the zero address");
581         return _balances[owner];
582     }
583 
584     /**
585      * @dev See {IERC721-ownerOf}.
586      */
587     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
588         address owner = _owners[tokenId];
589         require(owner != address(0), "ERC721: owner query for nonexistent token");
590         return owner;
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-name}.
595      */
596     function name() public view virtual override returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-symbol}.
602      */
603     function symbol() public view virtual override returns (string memory) {
604         return _symbol;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-tokenURI}.
609      */
610     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
611         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
612 
613         string memory baseURI = _baseURI();
614         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
615     }
616 
617     /**
618      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
619      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
620      * by default, can be overriden in child contracts.
621      */
622     function _baseURI() public view virtual returns (string memory) {
623         return "";
624     }
625 
626     /**
627      * @dev See {IERC721-approve}.
628      */
629     function approve(address to, uint256 tokenId) public virtual override {
630         address owner = ERC721.ownerOf(tokenId);
631         require(to != owner, "ERC721: approval to current owner");
632 
633         require(
634             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
635             "ERC721: approve caller is not owner nor approved for all"
636         );
637 
638         _approve(to, tokenId);
639     }
640 
641     /**
642      * @dev See {IERC721-getApproved}.
643      */
644     function getApproved(uint256 tokenId) public view virtual override returns (address) {
645         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
646 
647         return _tokenApprovals[tokenId];
648     }
649 
650     /**
651      * @dev See {IERC721-setApprovalForAll}.
652      */
653     function setApprovalForAll(address operator, bool approved) public virtual override {
654         require(operator != _msgSender(), "ERC721: approve to caller");
655 
656         _operatorApprovals[_msgSender()][operator] = approved;
657         emit ApprovalForAll(_msgSender(), operator, approved);
658     }
659 
660     /**
661      * @dev See {IERC721-isApprovedForAll}.
662      */
663     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
664         return _operatorApprovals[owner][operator];
665     }
666 
667     /**
668      * @dev See {IERC721-transferFrom}.
669      */
670     function transferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) public virtual override {
675         //solhint-disable-next-line max-line-length
676         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
677 
678         _transfer(from, to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-safeTransferFrom}.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) public virtual override {
689         safeTransferFrom(from, to, tokenId, "");
690     }
691 
692     /**
693      * @dev See {IERC721-safeTransferFrom}.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId,
699         bytes memory _data
700     ) public virtual override {
701         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
702         _safeTransfer(from, to, tokenId, _data);
703     }
704 
705     /**
706      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
707      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
708      *
709      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
710      *
711      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
712      * implement alternative mechanisms to perform token transfer, such as signature-based.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must exist and be owned by `from`.
719      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
720      *
721      * Emits a {Transfer} event.
722      */
723     function _safeTransfer(
724         address from,
725         address to,
726         uint256 tokenId,
727         bytes memory _data
728     ) internal virtual {
729         _transfer(from, to, tokenId);
730         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
731     }
732 
733     /**
734      * @dev Returns whether `tokenId` exists.
735      *
736      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
737      *
738      * Tokens start existing when they are minted (`_mint`),
739      * and stop existing when they are burned (`_burn`).
740      */
741     function _exists(uint256 tokenId) internal view virtual returns (bool) {
742         return _owners[tokenId] != address(0);
743     }
744 
745     /**
746      * @dev Returns whether `spender` is allowed to manage `tokenId`.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must exist.
751      */
752     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
753         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
754         address owner = ERC721.ownerOf(tokenId);
755         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
756     }
757 
758     /**
759      * @dev Safely mints `tokenId` and transfers it to `to`.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must not exist.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _safeMint(address to, uint256 tokenId) internal virtual {
769         _safeMint(to, tokenId, "");
770     }
771 
772     /**
773      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
774      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
775      */
776     function _safeMint(
777         address to,
778         uint256 tokenId,
779         bytes memory _data
780     ) internal virtual {
781         _mint(to, tokenId);
782         require(
783             _checkOnERC721Received(address(0), to, tokenId, _data),
784             "ERC721: transfer to non ERC721Receiver implementer"
785         );
786     }
787 
788     /**
789      * @dev Mints `tokenId` and transfers it to `to`.
790      *
791      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
792      *
793      * Requirements:
794      *
795      * - `tokenId` must not exist.
796      * - `to` cannot be the zero address.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _mint(address to, uint256 tokenId) internal virtual {
801         require(to != address(0), "ERC721: mint to the zero address");
802         require(!_exists(tokenId), "ERC721: token already minted");
803 
804         _beforeTokenTransfer(address(0), to, tokenId);
805 
806         _balances[to] += 1;
807         _owners[tokenId] = to;
808 
809         emit Transfer(address(0), to, tokenId);
810     }
811 
812     /**
813      * @dev Destroys `tokenId`.
814      * The approval is cleared when the token is burned.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _burn(uint256 tokenId) internal virtual {
823         address owner = ERC721.ownerOf(tokenId);
824 
825         _beforeTokenTransfer(owner, address(0), tokenId);
826 
827         // Clear approvals
828         _approve(address(0), tokenId);
829 
830         _balances[owner] -= 1;
831         delete _owners[tokenId];
832 
833         emit Transfer(owner, address(0), tokenId);
834     }
835 
836     /**
837      * @dev Transfers `tokenId` from `from` to `to`.
838      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
839      *
840      * Requirements:
841      *
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must be owned by `from`.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _transfer(
848         address from,
849         address to,
850         uint256 tokenId
851     ) internal virtual {
852         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
853         require(to != address(0), "ERC721: transfer to the zero address");
854 
855         _beforeTokenTransfer(from, to, tokenId);
856 
857         // Clear approvals from the previous owner
858         _approve(address(0), tokenId);
859 
860         _balances[from] -= 1;
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(from, to, tokenId);
865     }
866 
867     /**
868      * @dev Approve `to` to operate on `tokenId`
869      *
870      * Emits a {Approval} event.
871      */
872     function _approve(address to, uint256 tokenId) internal virtual {
873         _tokenApprovals[tokenId] = to;
874         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
875     }
876 
877     /**
878      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
879      * The call is not executed if the target address is not a contract.
880      *
881      * @param from address representing the previous owner of the given token ID
882      * @param to target address that will receive the tokens
883      * @param tokenId uint256 ID of the token to be transferred
884      * @param _data bytes optional data to send along with the call
885      * @return bool whether the call correctly returned the expected magic value
886      */
887     function _checkOnERC721Received(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) private returns (bool) {
893         if (to.isContract()) {
894             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
895                 return retval == IERC721Receiver.onERC721Received.selector;
896             } catch (bytes memory reason) {
897                 if (reason.length == 0) {
898                     revert("ERC721: transfer to non ERC721Receiver implementer");
899                 } else {
900                     assembly {
901                         revert(add(32, reason), mload(reason))
902                     }
903                 }
904             }
905         } else {
906             return true;
907         }
908     }
909 
910     /**
911      * @dev Hook that is called before any token transfer. This includes minting
912      * and burning.
913      *
914      * Calling conditions:
915      *
916      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
917      * transferred to `to`.
918      * - When `from` is zero, `tokenId` will be minted for `to`.
919      * - When `to` is zero, ``from``'s `tokenId` will be burned.
920      * - `from` and `to` are never both zero.
921      *
922      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
923      */
924     function _beforeTokenTransfer(
925         address from,
926         address to,
927         uint256 tokenId
928     ) internal virtual {}
929 }
930 
931 /**
932  * @dev ERC721 token with storage based token URI management.
933  */
934 abstract contract ERC721URIStorage is ERC721 {
935     using Strings for uint256;
936 
937     // Optional mapping for token URIs
938     mapping(uint256 => string) private _tokenURIs;
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
944         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
945 
946         string memory _tokenURI = _tokenURIs[tokenId];
947         string memory base = _baseURI();
948 
949         // If there is no base URI, return the token URI.
950         if (bytes(base).length == 0) {
951             return _tokenURI;
952         }
953         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
954         if (bytes(_tokenURI).length > 0) {
955             return string(abi.encodePacked(base, _tokenURI));
956         }
957 
958         return super.tokenURI(tokenId);
959     }
960 
961     /**
962      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
969         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
970         _tokenURIs[tokenId] = _tokenURI;
971     }
972 
973     /**
974      * @dev Destroys `tokenId`.
975      * The approval is cleared when the token is burned.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must exist.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _burn(uint256 tokenId) internal virtual override {
984         super._burn(tokenId);
985 
986         if (bytes(_tokenURIs[tokenId]).length != 0) {
987             delete _tokenURIs[tokenId];
988         }
989     }
990 }
991 
992 /**
993  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
994  * @dev See https://eips.ethereum.org/EIPS/eip-721
995  */
996 interface IERC721Enumerable is IERC721 {
997     /**
998      * @dev Returns the total amount of tokens stored by the contract.
999      */
1000     function totalSupply() external view returns (uint256);
1001 
1002     /**
1003      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1004      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1005      */
1006     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1007 
1008     /**
1009      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1010      * Use along with {totalSupply} to enumerate all tokens.
1011      */
1012     function tokenByIndex(uint256 index) external view returns (uint256);
1013 }
1014 
1015 /**
1016  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1017  * enumerability of all the token ids in the contract as well as all token ids owned by each
1018  * account.
1019  */
1020 abstract contract ERC721Enumerable is ERC721URIStorage, IERC721Enumerable {
1021     // Mapping from owner to list of owned token IDs
1022     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1023 
1024     // Mapping from token ID to index of the owner tokens list
1025     mapping(uint256 => uint256) private _ownedTokensIndex;
1026 
1027     // Array with all token ids, used for enumeration
1028     uint256[] private _allTokens;
1029 
1030     // Mapping from token id to position in the allTokens array
1031     mapping(uint256 => uint256) private _allTokensIndex;
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1037         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1045         return _ownedTokens[owner][index];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-totalSupply}.
1050      */
1051     function totalSupply() public view virtual override returns (uint256) {
1052         return _allTokens.length;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenByIndex}.
1057      */
1058     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1060         return _allTokens[index];
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual override {
1083         super._beforeTokenTransfer(from, to, tokenId);
1084 
1085         if (from == address(0)) {
1086             _addTokenToAllTokensEnumeration(tokenId);
1087         } else if (from != to) {
1088             _removeTokenFromOwnerEnumeration(from, tokenId);
1089         }
1090         if (to == address(0)) {
1091             _removeTokenFromAllTokensEnumeration(tokenId);
1092         } else if (to != from) {
1093             _addTokenToOwnerEnumeration(to, tokenId);
1094         }
1095     }
1096 
1097     /**
1098      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1099      * @param to address representing the new owner of the given token ID
1100      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1101      */
1102     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1103         uint256 length = ERC721.balanceOf(to);
1104         _ownedTokens[to][length] = tokenId;
1105         _ownedTokensIndex[tokenId] = length;
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's token tracking data structures.
1110      * @param tokenId uint256 ID of the token to be added to the tokens list
1111      */
1112     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1113         _allTokensIndex[tokenId] = _allTokens.length;
1114         _allTokens.push(tokenId);
1115     }
1116 
1117     /**
1118      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1119      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1120      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1121      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1122      * @param from address representing the previous owner of the given token ID
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1124      */
1125     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1126         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1130         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary
1133         if (tokenIndex != lastTokenIndex) {
1134             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1135 
1136             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1137             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1138         }
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _ownedTokensIndex[tokenId];
1142         delete _ownedTokens[from][lastTokenIndex];
1143     }
1144 
1145     /**
1146      * @dev Private function to remove a token from this extension's token tracking data structures.
1147      * This has O(1) time complexity, but alters the order of the _allTokens array.
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list
1149      */
1150     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1151         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = _allTokens.length - 1;
1155         uint256 tokenIndex = _allTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1158         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1159         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1160         uint256 lastTokenId = _allTokens[lastTokenIndex];
1161 
1162         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1163         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _allTokensIndex[tokenId];
1167         _allTokens.pop();
1168     }
1169 }
1170 
1171 /**
1172  * @title Counters
1173  * @author Matt Condon (@shrugs)
1174  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1175  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1176  *
1177  * Include with `using Counters for Counters.Counter;`
1178  */
1179 library Counters {
1180     struct Counter {
1181         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1182         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1183         // this feature: see https://github.com/ethereum/solidity/issues/4637
1184         uint256 _value; // default: 0
1185     }
1186 
1187     function current(Counter storage counter) internal view returns (uint256) {
1188         return counter._value;
1189     }
1190 
1191     function increment(Counter storage counter) internal {
1192         unchecked {
1193             counter._value += 1;
1194         }
1195     }
1196 
1197     function decrement(Counter storage counter) internal {
1198         uint256 value = counter._value;
1199         require(value > 0, "Counter: decrement overflow");
1200         unchecked {
1201             counter._value = value - 1;
1202         }
1203     }
1204 
1205     function reset(Counter storage counter) internal {
1206         counter._value = 0;
1207     }
1208 }
1209 
1210 /**
1211  * @dev {ERC721} token, including:
1212  *
1213  *  - ability for holders to burn (destroy) their tokens
1214  *  - a minter role that allows for token minting (creation)
1215  *  - a pauser role that allows to stop all token transfers
1216  *  - token ID and URI autogeneration
1217  *
1218  * This contract uses {AccessControl} to lock permissioned functions using the
1219  * different roles - head to its documentation for details.
1220  *
1221  * The account that deploys the contract will be granted the minter and pauser
1222  * roles, as well as the default admin role, which will let it grant both minter
1223  * and pauser roles to other accounts.
1224  */
1225 contract MetaVisa is ERC721Enumerable {
1226     using Counters for Counters.Counter;
1227     
1228     Counters.Counter private _tokenIdTracker;
1229     
1230     event Mint(address indexed from, address indexed to, uint256 indexed tokenId);
1231     
1232     mapping(address => bool) public isBuy; 
1233 
1234     /**
1235      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1236      * account that deploys the contract.
1237      *
1238      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
1239      * See {ERC721-tokenURI}.
1240      */
1241     constructor(
1242         string memory name,
1243         string memory symbol
1244     ) ERC721(name, symbol) {
1245     }
1246 
1247     
1248     /**
1249      * @dev Creates a new token for `to`. Its token ID will be automatically
1250      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
1251      * URI autogenerated based on the base URI passed at construction.
1252      *
1253      * See {ERC721-_mint}.
1254      *
1255      * Requirements:
1256      *
1257      * - the caller must have the `MINTER_ROLE`.
1258      */
1259     function mint(string memory tokenURI) public virtual  {
1260         // We cannot just use balanceOf to create the new tokenId because tokens
1261         // can be burned (destroyed), so we need a separate counter.
1262         //getFeeAddress().transfer(msg.value);
1263         require(!isBuy[msg.sender], "mint:You can only buy it once ");
1264         uint256 tokenId = _tokenIdTracker.current();
1265         _mint(msg.sender, _tokenIdTracker.current());
1266         _setTokenURI(_tokenIdTracker.current(),tokenURI);
1267         _tokenIdTracker.increment();
1268         isBuy[msg.sender]=true;
1269         emit Mint(address(0), msg.sender, tokenId);
1270     }
1271 
1272     function _beforeTokenTransfer(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) internal virtual override( ERC721Enumerable) {
1277         super._beforeTokenTransfer(from, to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev See {IERC165-supportsInterface}.
1282      */
1283     function supportsInterface(bytes4 interfaceId)
1284         public
1285         view
1286         virtual
1287         override( ERC721Enumerable)
1288         returns (bool)
1289     {
1290         return super.supportsInterface(interfaceId);
1291     }
1292     
1293 }