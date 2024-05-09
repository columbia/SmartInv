1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-30
3 */
4 
5 // Baby Battle Bots Gen One
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Implementation of the {IERC165} interface.
40  *
41  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
42  * for the additional interface id that will be supported. For example:
43  *
44  * ```solidity
45  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
46  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
47  * }
48  * ```
49  *
50  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
51  */
52 abstract contract ERC165 is IERC165 {
53     /**
54      * @dev See {IERC165-supportsInterface}.
55      */
56     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
57         return interfaceId == type(IERC165).interfaceId;
58     }
59 }
60 
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev String operations.
66  */
67 library Strings {
68     bytes16 private constant alphabet = "0123456789abcdef";
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
72      */
73     function toString(uint256 value) internal pure returns (string memory) {
74         // Inspired by OraclizeAPI's implementation - MIT licence
75         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
76 
77         if (value == 0) {
78             return "0";
79         }
80         uint256 temp = value;
81         uint256 digits;
82         while (temp != 0) {
83             digits++;
84             temp /= 10;
85         }
86         bytes memory buffer = new bytes(digits);
87         while (value != 0) {
88             digits -= 1;
89             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
90             value /= 10;
91         }
92         return string(buffer);
93     }
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
97      */
98     function toHexString(uint256 value) internal pure returns (string memory) {
99         if (value == 0) {
100             return "0x00";
101         }
102         uint256 temp = value;
103         uint256 length = 0;
104         while (temp != 0) {
105             length++;
106             temp >>= 8;
107         }
108         return toHexString(value, length);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
113      */
114     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
115         bytes memory buffer = new bytes(2 * length + 2);
116         buffer[0] = "0";
117         buffer[1] = "x";
118         for (uint256 i = 2 * length + 1; i > 1; --i) {
119             buffer[i] = alphabet[value & 0xf];
120             value >>= 4;
121         }
122         require(value == 0, "Strings: hex length insufficient");
123         return string(buffer);
124     }
125 
126 }
127 
128 
129 
130 pragma solidity ^0.8.0;
131 
132 /*
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
149         return msg.data;
150     }
151 }
152 
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Collection of functions related to the address type
158  */
159 library Address {
160     /**
161      * @dev Returns true if `account` is a contract.
162      *
163      * [IMPORTANT]
164      * ====
165      * It is unsafe to assume that an address for which this function returns
166      * false is an externally-owned account (EOA) and not a contract.
167      *
168      * Among others, `isContract` will return false for the following
169      * types of addresses:
170      *
171      *  - an externally-owned account
172      *  - a contract in construction
173      *  - an address where a contract will be created
174      *  - an address where a contract lived, but was destroyed
175      * ====
176      */
177     function isContract(address account) internal view returns (bool) {
178         // This method relies on extcodesize, which returns 0 for contracts in
179         // construction, since the code is only stored at the end of the
180         // constructor execution.
181 
182         uint256 size;
183         // solhint-disable-next-line no-inline-assembly
184         assembly { size := extcodesize(account) }
185         return size > 0;
186     }
187 
188     /**
189      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
190      * `recipient`, forwarding all available gas and reverting on errors.
191      *
192      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
193      * of certain opcodes, possibly making contracts go over the 2300 gas limit
194      * imposed by `transfer`, making them unable to receive funds via
195      * `transfer`. {sendValue} removes this limitation.
196      *
197      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
198      *
199      * IMPORTANT: because control is transferred to `recipient`, care must be
200      * taken to not create reentrancy vulnerabilities. Consider using
201      * {ReentrancyGuard} or the
202      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
203      */
204     function sendValue(address payable recipient, uint256 amount) internal {
205         require(address(this).balance >= amount, "Address: insufficient balance");
206 
207         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
208         (bool success, ) = recipient.call{ value: amount }("");
209         require(success, "Address: unable to send value, recipient may have reverted");
210     }
211 
212     /**
213      * @dev Performs a Solidity function call using a low level `call`. A
214      * plain`call` is an unsafe replacement for a function call: use this
215      * function instead.
216      *
217      * If `target` reverts with a revert reason, it is bubbled up by this
218      * function (like regular Solidity function calls).
219      *
220      * Returns the raw returned data. To convert to the expected return value,
221      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
222      *
223      * Requirements:
224      *
225      * - `target` must be a contract.
226      * - calling `target` with `data` must not revert.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
231       return functionCall(target, data, "Address: low-level call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
236      * `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, 0, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but also transferring `value` wei to `target`.
247      *
248      * Requirements:
249      *
250      * - the calling contract must have an ETH balance of at least `value`.
251      * - the called Solidity function must be `payable`.
252      *
253      * _Available since v3.1._
254      */
255     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
261      * with `errorMessage` as a fallback revert reason when `target` reverts.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
266         require(address(this).balance >= value, "Address: insufficient balance for call");
267         require(isContract(target), "Address: call to non-contract");
268 
269         // solhint-disable-next-line avoid-low-level-calls
270         (bool success, bytes memory returndata) = target.call{ value: value }(data);
271         return _verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Address: low-level static call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
291         require(isContract(target), "Address: static call to non-contract");
292 
293         // solhint-disable-next-line avoid-low-level-calls
294         (bool success, bytes memory returndata) = target.staticcall(data);
295         return _verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a delegate call.
301      *
302      * _Available since v3.4._
303      */
304     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
315         require(isContract(target), "Address: delegate call to non-contract");
316 
317         // solhint-disable-next-line avoid-low-level-calls
318         (bool success, bytes memory returndata) = target.delegatecall(data);
319         return _verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
323         if (success) {
324             return returndata;
325         } else {
326             // Look for revert reason and bubble it up if present
327             if (returndata.length > 0) {
328                 // The easiest way to bubble the revert reason is using memory via assembly
329 
330                 // solhint-disable-next-line no-inline-assembly
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 
343 
344 
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @title ERC721 token receiver interface
350  * @dev Interface for any contract that wants to support safeTransfers
351  * from ERC721 asset contracts.
352  */
353 interface IERC721Receiver {
354     /**
355      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
356      * by `operator` from `from`, this function is called.
357      *
358      * It must return its Solidity selector to confirm the token transfer.
359      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
360      *
361      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
362      */
363     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
364 }
365 
366 
367 
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Required interface of an ERC721 compliant contract.
374  */
375 interface IERC721 is IERC165 {
376     /**
377      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
383      */
384     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
388      */
389     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
390 
391     /**
392      * @dev Returns the number of tokens in ``owner``'s account.
393      */
394     function balanceOf(address owner) external view returns (uint256 balance);
395 
396     /**
397      * @dev Returns the owner of the `tokenId` token.
398      *
399      * Requirements:
400      *
401      * - `tokenId` must exist.
402      */
403     function ownerOf(uint256 tokenId) external view returns (address owner);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(address from, address to, uint256 tokenId) external;
420 
421     /**
422      * @dev Transfers `tokenId` token from `from` to `to`.
423      *
424      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(address from, address to, uint256 tokenId) external;
436 
437     /**
438      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
439      * The approval is cleared when the token is transferred.
440      *
441      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
442      *
443      * Requirements:
444      *
445      * - The caller must own the token or be an approved operator.
446      * - `tokenId` must exist.
447      *
448      * Emits an {Approval} event.
449      */
450     function approve(address to, uint256 tokenId) external;
451 
452     /**
453      * @dev Returns the account approved for `tokenId` token.
454      *
455      * Requirements:
456      *
457      * - `tokenId` must exist.
458      */
459     function getApproved(uint256 tokenId) external view returns (address operator);
460 
461     /**
462      * @dev Approve or remove `operator` as an operator for the caller.
463      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
464      *
465      * Requirements:
466      *
467      * - The `operator` cannot be the caller.
468      *
469      * Emits an {ApprovalForAll} event.
470      */
471     function setApprovalForAll(address operator, bool _approved) external;
472 
473     /**
474      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
475      *
476      * See {setApprovalForAll}
477      */
478     function isApprovedForAll(address owner, address operator) external view returns (bool);
479 
480     /**
481       * @dev Safely transfers `tokenId` token from `from` to `to`.
482       *
483       * Requirements:
484       *
485       * - `from` cannot be the zero address.
486       * - `to` cannot be the zero address.
487       * - `tokenId` token must exist and be owned by `from`.
488       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
489       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
490       *
491       * Emits a {Transfer} event.
492       */
493     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
494 }
495 
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
502  * @dev See https://eips.ethereum.org/EIPS/eip-721
503  */
504 interface IERC721Enumerable is IERC721 {
505 
506     /**
507      * @dev Returns the total amount of tokens stored by the contract.
508      */
509     function totalSupply() external view returns (uint256);
510 
511     /**
512      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
513      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
514      */
515     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
516 
517     /**
518      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
519      * Use along with {totalSupply} to enumerate all tokens.
520      */
521     function tokenByIndex(uint256 index) external view returns (uint256);
522 }
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
530  * @dev See https://eips.ethereum.org/EIPS/eip-721
531  */
532 interface IERC721Metadata is IERC721 {
533 
534     /**
535      * @dev Returns the token collection name.
536      */
537     function name() external view returns (string memory);
538 
539     /**
540      * @dev Returns the token collection symbol.
541      */
542     function symbol() external view returns (string memory);
543 
544     /**
545      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
546      */
547     function tokenURI(uint256 tokenId) external view returns (string memory);
548 }
549 
550 
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
557  * the Metadata extension, but not including the Enumerable extension, which is available separately as
558  * {ERC721Enumerable}.
559  */
560 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
561     using Address for address;
562     using Strings for uint256;
563 
564     // Token name
565     string private _name;
566 
567     // Token symbol
568     string private _symbol;
569 
570     // Mapping from token ID to owner address
571     mapping (uint256 => address) private _owners;
572 
573     // Mapping owner address to token count
574     mapping (address => uint256) private _balances;
575 
576     // Mapping from token ID to approved address
577     mapping (uint256 => address) private _tokenApprovals;
578 
579     // Mapping from owner to operator approvals
580     mapping (address => mapping (address => bool)) private _operatorApprovals;
581 
582     /**
583      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
584      */
585     constructor (string memory name_, string memory symbol_) {
586         _name = name_;
587         _symbol = symbol_;
588     }
589 
590     /**
591      * @dev See {IERC165-supportsInterface}.
592      */
593     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
594         return interfaceId == type(IERC721).interfaceId
595             || interfaceId == type(IERC721Metadata).interfaceId
596             || super.supportsInterface(interfaceId);
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view virtual override returns (uint256) {
603         require(owner != address(0), "ERC721: balance query for the zero address");
604         return _balances[owner];
605     }
606 
607     /**
608      * @dev See {IERC721-ownerOf}.
609      */
610     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
611         address owner = _owners[tokenId];
612         require(owner != address(0), "ERC721: owner query for nonexistent token");
613         return owner;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-name}.
618      */
619     function name() public view virtual override returns (string memory) {
620         return _name;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-symbol}.
625      */
626     function symbol() public view virtual override returns (string memory) {
627         return _symbol;
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-tokenURI}.
632      */
633     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
634         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
635 
636         string memory baseURI = _baseURI();
637         return bytes(baseURI).length > 0
638             ? string(abi.encodePacked(baseURI, tokenId.toString()))
639             : '';
640     }
641 
642     /**
643      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
644      * in child contracts.
645      */
646     function _baseURI() internal view virtual returns (string memory) {
647         return "";
648     }
649 
650     /**
651      * @dev See {IERC721-approve}.
652      */
653     function approve(address to, uint256 tokenId) public virtual override {
654         address owner = ERC721.ownerOf(tokenId);
655         require(to != owner, "ERC721: approval to current owner");
656 
657         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
658             "ERC721: approve caller is not owner nor approved for all"
659         );
660 
661         _approve(to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-getApproved}.
666      */
667     function getApproved(uint256 tokenId) public view virtual override returns (address) {
668         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
669 
670         return _tokenApprovals[tokenId];
671     }
672 
673     /**
674      * @dev See {IERC721-setApprovalForAll}.
675      */
676     function setApprovalForAll(address operator, bool approved) public virtual override {
677         require(operator != _msgSender(), "ERC721: approve to caller");
678 
679         _operatorApprovals[_msgSender()][operator] = approved;
680         emit ApprovalForAll(_msgSender(), operator, approved);
681     }
682 
683     /**
684      * @dev See {IERC721-isApprovedForAll}.
685      */
686     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
687         return _operatorApprovals[owner][operator];
688     }
689 
690     /**
691      * @dev See {IERC721-transferFrom}.
692      */
693     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
694         //solhint-disable-next-line max-line-length
695         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
696 
697         _transfer(from, to, tokenId);
698     }
699 
700     /**
701      * @dev See {IERC721-safeTransferFrom}.
702      */
703     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
704         safeTransferFrom(from, to, tokenId, "");
705     }
706 
707     /**
708      * @dev See {IERC721-safeTransferFrom}.
709      */
710     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
712         _safeTransfer(from, to, tokenId, _data);
713     }
714 
715     /**
716      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
717      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
718      *
719      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
720      *
721      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
722      * implement alternative mechanisms to perform token transfer, such as signature-based.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
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
781     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
782         _mint(to, tokenId);
783         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
784     }
785 
786     /**
787      * @dev Mints `tokenId` and transfers it to `to`.
788      *
789      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
790      *
791      * Requirements:
792      *
793      * - `tokenId` must not exist.
794      * - `to` cannot be the zero address.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _mint(address to, uint256 tokenId) internal virtual {
799         require(to != address(0), "ERC721: mint to the zero address");
800         require(!_exists(tokenId), "ERC721: token already minted");
801 
802         _beforeTokenTransfer(address(0), to, tokenId);
803 
804         _balances[to] += 1;
805         _owners[tokenId] = to;
806 
807         emit Transfer(address(0), to, tokenId);
808     }
809     
810 
811     /**
812      * @dev Destroys `tokenId`.
813      * The approval is cleared when the token is burned.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _burn(uint256 tokenId) internal virtual {
822         address owner = ERC721.ownerOf(tokenId);
823 
824         _beforeTokenTransfer(owner, address(0), tokenId);
825 
826         // Clear approvals
827         _approve(address(0), tokenId);
828 
829         _balances[owner] -= 1;
830         delete _owners[tokenId];
831 
832         emit Transfer(owner, address(0), tokenId);
833     }
834 
835     /**
836      * @dev Transfers `tokenId` from `from` to `to`.
837      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
838      *
839      * Requirements:
840      *
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must be owned by `from`.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _transfer(address from, address to, uint256 tokenId) internal virtual {
847         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
848         require(to != address(0), "ERC721: transfer to the zero address");
849 
850         _beforeTokenTransfer(from, to, tokenId);
851 
852         // Clear approvals from the previous owner
853         _approve(address(0), tokenId);
854 
855         _balances[from] -= 1;
856         _balances[to] += 1;
857         _owners[tokenId] = to;
858 
859         emit Transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev Approve `to` to operate on `tokenId`
864      *
865      * Emits a {Approval} event.
866      */
867     function _approve(address to, uint256 tokenId) internal virtual {
868         _tokenApprovals[tokenId] = to;
869         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
870     }
871 
872     /**
873      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
874      * The call is not executed if the target address is not a contract.
875      *
876      * @param from address representing the previous owner of the given token ID
877      * @param to target address that will receive the tokens
878      * @param tokenId uint256 ID of the token to be transferred
879      * @param _data bytes optional data to send along with the call
880      * @return bool whether the call correctly returned the expected magic value
881      */
882     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
883         private returns (bool)
884     {
885         if (to.isContract()) {
886             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
887                 return retval == IERC721Receiver(to).onERC721Received.selector;
888             } catch (bytes memory reason) {
889                 if (reason.length == 0) {
890                     revert("ERC721: transfer to non ERC721Receiver implementer");
891                 } else {
892                     // solhint-disable-next-line no-inline-assembly
893                     assembly {
894                         revert(add(32, reason), mload(reason))
895                     }
896                 }
897             }
898         } else {
899             return true;
900         }
901     }
902 
903     /**
904      * @dev Hook that is called before any token transfer. This includes minting
905      * and burning.
906      *
907      * Calling conditions:
908      *
909      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
910      * transferred to `to`.
911      * - When `from` is zero, `tokenId` will be minted for `to`.
912      * - When `to` is zero, ``from``'s `tokenId` will be burned.
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
919 }
920 
921 
922 pragma solidity ^0.8.0;
923 
924 /**
925  * @dev Contract module which provides a basic access control mechanism, where
926  * there is an account (an owner) that can be granted exclusive access to
927  * specific functions.
928  *
929  * By default, the owner account will be the one that deploys the contract. This
930  * can later be changed with {transferOwnership}.
931  *
932  * This module is used through inheritance. It will make available the modifier
933  * `onlyOwner`, which can be applied to your functions to restrict their use to
934  * the owner.
935  */
936 abstract contract Ownable is Context {
937     address private _owner;
938 
939     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
940 
941     /**
942      * @dev Initializes the contract setting the deployer as the initial owner.
943      */
944     constructor () {
945         address msgSender = _msgSender();
946         _owner = msgSender;
947         emit OwnershipTransferred(address(0), msgSender);
948     }
949 
950     /**
951      * @dev Returns the address of the current owner.
952      */
953     function owner() public view virtual returns (address) {
954         return _owner;
955     }
956 
957     /**
958      * @dev Throws if called by any account other than the owner.
959      */
960     modifier onlyOwner() {
961         require(owner() == _msgSender(), "Ownable: caller is not the owner");
962         _;
963     }
964 
965     /**
966      * @dev Leaves the contract without owner. It will not be possible to call
967      * `onlyOwner` functions anymore. Can only be called by the current owner.
968      *
969      * NOTE: Renouncing ownership will leave the contract without an owner,
970      * thereby removing any functionality that is only available to the owner.
971      */
972     function renounceOwnership() public virtual onlyOwner {
973         emit OwnershipTransferred(_owner, address(0));
974         _owner = address(0);
975     }
976 
977     /**
978      * @dev Transfers ownership of the contract to a new account (`newOwner`).
979      * Can only be called by the current owner.
980      */
981     function transferOwnership(address newOwner) public virtual onlyOwner {
982         require(newOwner != address(0), "Ownable: new owner is the zero address");
983         emit OwnershipTransferred(_owner, newOwner);
984         _owner = newOwner;
985     }
986 }
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
993  * enumerability of all the token ids in the contract as well as all token ids owned by each
994  * account.
995  */
996 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
997     // Mapping from owner to list of owned token IDs
998     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
999 
1000     // Mapping from token ID to index of the owner tokens list
1001     mapping(uint256 => uint256) private _ownedTokensIndex;
1002 
1003     // Array with all token ids, used for enumeration
1004     uint256[] private _allTokens;
1005 
1006     // Mapping from token id to position in the allTokens array
1007     mapping(uint256 => uint256) private _allTokensIndex;
1008 
1009     /**
1010      * @dev See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1013         return interfaceId == type(IERC721Enumerable).interfaceId
1014             || super.supportsInterface(interfaceId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1019      */
1020     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1021         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1022         return _ownedTokens[owner][index];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-totalSupply}.
1027      */
1028     function totalSupply() public view virtual override returns (uint256) {
1029         return _allTokens.length;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-tokenByIndex}.
1034      */
1035     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1036         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1037         return _allTokens[index];
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before any token transfer. This includes minting
1042      * and burning.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1056         super._beforeTokenTransfer(from, to, tokenId);
1057 
1058         if (from == address(0)) {
1059             _addTokenToAllTokensEnumeration(tokenId);
1060         } else if (from != to) {
1061             _removeTokenFromOwnerEnumeration(from, tokenId);
1062         }
1063         if (to == address(0)) {
1064             _removeTokenFromAllTokensEnumeration(tokenId);
1065         } else if (to != from) {
1066             _addTokenToOwnerEnumeration(to, tokenId);
1067         }
1068     }
1069 
1070     /**
1071      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1072      * @param to address representing the new owner of the given token ID
1073      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1074      */
1075     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1076         uint256 length = ERC721.balanceOf(to);
1077         _ownedTokens[to][length] = tokenId;
1078         _ownedTokensIndex[tokenId] = length;
1079     }
1080 
1081     /**
1082      * @dev Private function to add a token to this extension's token tracking data structures.
1083      * @param tokenId uint256 ID of the token to be added to the tokens list
1084      */
1085     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1086         _allTokensIndex[tokenId] = _allTokens.length;
1087         _allTokens.push(tokenId);
1088     }
1089 
1090     /**
1091      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1092      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1093      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1094      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1095      * @param from address representing the previous owner of the given token ID
1096      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1097      */
1098     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1099         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1100         // then delete the last slot (swap and pop).
1101 
1102         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1103         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1104 
1105         // When the token to delete is the last token, the swap operation is unnecessary
1106         if (tokenIndex != lastTokenIndex) {
1107             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1108 
1109             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1110             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1111         }
1112 
1113         // This also deletes the contents at the last position of the array
1114         delete _ownedTokensIndex[tokenId];
1115         delete _ownedTokens[from][lastTokenIndex];
1116     }
1117 
1118     /**
1119      * @dev Private function to remove a token from this extension's token tracking data structures.
1120      * This has O(1) time complexity, but alters the order of the _allTokens array.
1121      * @param tokenId uint256 ID of the token to be removed from the tokens list
1122      */
1123     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1124         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1125         // then delete the last slot (swap and pop).
1126 
1127         uint256 lastTokenIndex = _allTokens.length - 1;
1128         uint256 tokenIndex = _allTokensIndex[tokenId];
1129 
1130         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1131         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1132         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1133         uint256 lastTokenId = _allTokens[lastTokenIndex];
1134 
1135         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1136         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1137 
1138         // This also deletes the contents at the last position of the array
1139         delete _allTokensIndex[tokenId];
1140         _allTokens.pop();
1141     }
1142 }
1143 
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 
1148 contract BabyBattleBotsGenOne is ERC721Enumerable, Ownable {
1149 
1150     using Strings for uint256;
1151 
1152     string _baseTokenURI;
1153     uint256 private _esReserved = 300;
1154     uint256 private _giftReserved = 100;
1155     uint256 private _price = 0.035 ether;
1156     uint256 private MAX_SUPPLY = 3500;
1157     uint256 private maxPerTx = 10;
1158     bool public _paused = true;
1159     bool public _ESpaused = false;
1160 
1161     mapping(address => bool) public _earlySupporters;
1162 
1163     address t1 = 0xDC3Ae92E82b5182e469A659786Fe038206858a8C;
1164     address t2 = 0xF129f79c05F6EA516d01176A3983475100CA64C4;
1165     address t3 = 0xf5CA775911EA3F3Fe75d8Ec3756a08AfFbf4dEB6;
1166     address t4 = 0x67D1D8c8c440f47F00b3CBf14dEbbF9CBEd00eeF;
1167 
1168     constructor() ERC721("Baby Battle Bots Gen One", "BBBONE") {
1169         _safeMint(t2, 0);
1170         _safeMint(t3, 1);
1171         _safeMint(t4, 2);
1172     }
1173 
1174     function mintBot(uint256 num) public payable {
1175         uint256 supply = totalSupply();
1176         require( !_paused,                              "Sale paused" );
1177         require( num <= maxPerTx,                              "Exceeds maximum amount of Bots per tx" );
1178         require( supply + num <= MAX_SUPPLY - _giftReserved - _esReserved,      "Exceeds maximum Bots supply" );
1179         require( msg.value >= _price * num,             "Ether sent is not correct" );
1180 
1181         for(uint256 i; i < num; i++){
1182             _safeMint( msg.sender, supply + i );
1183         }
1184     }
1185 
1186     function mintESBot() public payable {
1187         uint256 supply = totalSupply();
1188         uint256 balance = balanceOf(msg.sender);
1189 
1190         require( !_ESpaused,                              "Early Supporters sale paused" );
1191         require( supply + 1 <= _esReserved,      "Exceeds maximum Bots early mint reserved supply" );
1192         require( balance == 0,      "You already have some Bots" );
1193         require( _earlySupporters[msg.sender],      "Sorry you are not on the Early Supporters list" );
1194         require( msg.value >= _price,             "Ether sent is not correct" );
1195 
1196         _safeMint( msg.sender, supply);
1197     }
1198 
1199     function addES(address _es) public onlyOwner() {
1200         _earlySupporters[_es] = true;
1201     }
1202 
1203     function removeES(address _es) public onlyOwner() {
1204         _earlySupporters[_es] = false;
1205     }
1206 
1207     function addESMany(address[] memory _ess) public onlyOwner() {
1208         require(totalSupply() + _ess.length <= _esReserved, 'Would exceed ES reserved supply');
1209 
1210         for(uint256 i = 0; i < _ess.length; i++) {
1211             addES(_ess[i]);
1212         }
1213     }
1214 
1215     function removeESMany(address[] memory _ess) public onlyOwner() {
1216         for(uint256 i = 0; i < _ess.length; i++) {
1217             removeES(_ess[i]);
1218         }
1219     }
1220 
1221     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1222         uint256 tokenCount = balanceOf(_owner);
1223 
1224         uint256[] memory tokensId = new uint256[](tokenCount);
1225         for(uint256 i; i < tokenCount; i++){
1226             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1227         }
1228         return tokensId;
1229     }
1230 
1231     function setPrice(uint256 _newPrice) public onlyOwner() {
1232         _price = _newPrice;
1233     }
1234 
1235     function setMaxPerTx(uint256 _newMaxPerTx) public onlyOwner() {
1236         maxPerTx = _newMaxPerTx;
1237     }
1238 
1239     function setESReserved(uint256 _newReserved) public onlyOwner() {
1240         _esReserved = _newReserved;
1241     }
1242 
1243     function setGiftReserved(uint256 _newReserved) public onlyOwner() {
1244         _giftReserved = _newReserved;
1245     }
1246 
1247     function setMaxSupply(uint256 _newMax) public onlyOwner() {
1248         MAX_SUPPLY = _newMax;
1249     }
1250 
1251     function _baseURI() internal view virtual override returns (string memory) {
1252         return _baseTokenURI;
1253     }
1254 
1255     function setBaseURI(string memory baseURI) public onlyOwner {
1256         _baseTokenURI = baseURI;
1257     }
1258 
1259     function getPrice() public view returns (uint256){
1260         return _price;
1261     }
1262 
1263     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1264         require( _amount <= _giftReserved, "Exceeds reserved gift Bots supply" );
1265 
1266         uint256 supply = totalSupply();
1267         for(uint256 i; i < _amount; i++){
1268             _safeMint( _to, supply + i );
1269         }
1270 
1271         _giftReserved -= _amount;
1272     }
1273 
1274     function giveAwayMany(address[] memory addresses) external onlyOwner() {
1275         require( addresses.length <= _giftReserved, "Exceeds reserved gift Bots supply" );
1276 
1277         for (uint i = 0; i < addresses.length; i++) {
1278             _safeMint(addresses[i], totalSupply() + 1);
1279         }
1280 
1281         _giftReserved -= addresses.length;
1282     }
1283 
1284     function pause(bool val) public onlyOwner {
1285         _paused = val;
1286     }
1287 
1288     function ESpause(bool val) public onlyOwner {
1289         _ESpaused = val;
1290     }
1291 
1292     function withdrawAll() public payable onlyOwner {
1293         uint256 _balance = address(this).balance;
1294         uint256 w1 = _balance * 37 / 1000;
1295         uint256 w2 = _balance - w1;
1296 
1297         require(payable(t1).send(w1));
1298         require(payable(t2).send(w2));
1299     }
1300 }