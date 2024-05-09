1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
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
26 pragma solidity ^0.8.0;
27 
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(address from, address to, uint256 tokenId) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address from, address to, uint256 tokenId) external;
93 
94     /**
95      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
96      * The approval is cleared when the token is transferred.
97      *
98      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
99      *
100      * Requirements:
101      *
102      * - The caller must own the token or be an approved operator.
103      * - `tokenId` must exist.
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Returns the account approved for `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function getApproved(uint256 tokenId) external view returns (address operator);
117 
118     /**
119      * @dev Approve or remove `operator` as an operator for the caller.
120      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
121      *
122      * Requirements:
123      *
124      * - The `operator` cannot be the caller.
125      *
126      * Emits an {ApprovalForAll} event.
127      */
128     function setApprovalForAll(address operator, bool _approved) external;
129 
130     /**
131      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
132      *
133      * See {setApprovalForAll}
134      */
135     function isApprovedForAll(address owner, address operator) external view returns (bool);
136 
137     /**
138       * @dev Safely transfers `tokenId` token from `from` to `to`.
139       *
140       * Requirements:
141       *
142       * - `from` cannot be the zero address.
143       * - `to` cannot be the zero address.
144       * - `tokenId` token must exist and be owned by `from`.
145       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147       *
148       * Emits a {Transfer} event.
149       */
150     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
151 }
152 
153 pragma solidity ^0.8.0;
154 
155 /**
156  * @title ERC721 token receiver interface
157  * @dev Interface for any contract that wants to support safeTransfers
158  * from ERC721 asset contracts.
159  */
160 interface IERC721Receiver {
161     /**
162      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
163      * by `operator` from `from`, this function is called.
164      *
165      * It must return its Solidity selector to confirm the token transfer.
166      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
167      *
168      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
169      */
170     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
171 }
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
178  * @dev See https://eips.ethereum.org/EIPS/eip-721
179  */
180 interface IERC721Metadata is IERC721 {
181 
182     /**
183      * @dev Returns the token collection name.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the token collection symbol.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
194      */
195     function tokenURI(uint256 tokenId) external view returns (string memory);
196 }
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev Collection of functions related to the address type
202  */
203 library Address {
204     /**
205      * @dev Returns true if `account` is a contract.
206      *
207      * [IMPORTANT]
208      * ====
209      * It is unsafe to assume that an address for which this function returns
210      * false is an externally-owned account (EOA) and not a contract.
211      *
212      * Among others, `isContract` will return false for the following
213      * types of addresses:
214      *
215      *  - an externally-owned account
216      *  - a contract in construction
217      *  - an address where a contract will be created
218      *  - an address where a contract lived, but was destroyed
219      * ====
220      */
221     function isContract(address account) internal view returns (bool) {
222         // This method relies on extcodesize, which returns 0 for contracts in
223         // construction, since the code is only stored at the end of the
224         // constructor execution.
225 
226         uint256 size;
227         // solhint-disable-next-line no-inline-assembly
228         assembly { size := extcodesize(account) }
229         return size > 0;
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      */
248     function sendValue(address payable recipient, uint256 amount) internal {
249         require(address(this).balance >= amount, "Address: insufficient balance");
250 
251         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
252         (bool success, ) = recipient.call{ value: amount }("");
253         require(success, "Address: unable to send value, recipient may have reverted");
254     }
255 
256     /**
257      * @dev Performs a Solidity function call using a low level `call`. A
258      * plain`call` is an unsafe replacement for a function call: use this
259      * function instead.
260      *
261      * If `target` reverts with a revert reason, it is bubbled up by this
262      * function (like regular Solidity function calls).
263      *
264      * Returns the raw returned data. To convert to the expected return value,
265      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
266      *
267      * Requirements:
268      *
269      * - `target` must be a contract.
270      * - calling `target` with `data` must not revert.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
275       return functionCall(target, data, "Address: low-level call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
280      * `errorMessage` as a fallback revert reason when `target` reverts.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, 0, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but also transferring `value` wei to `target`.
291      *
292      * Requirements:
293      *
294      * - the calling contract must have an ETH balance of at least `value`.
295      * - the called Solidity function must be `payable`.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312 
313         // solhint-disable-next-line avoid-low-level-calls
314         (bool success, bytes memory returndata) = target.call{ value: value }(data);
315         return _verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         // solhint-disable-next-line avoid-low-level-calls
338         (bool success, bytes memory returndata) = target.staticcall(data);
339         return _verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
359         require(isContract(target), "Address: delegate call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.delegatecall(data);
363         return _verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 pragma solidity ^0.8.0;
387 
388 /*
389  * @dev Provides information about the current execution context, including the
390  * sender of the transaction and its data. While these are generally available
391  * via msg.sender and msg.data, they should not be accessed in such a direct
392  * manner, since when dealing with meta-transactions the account sending and
393  * paying for execution may not be the actual sender (as far as an application
394  * is concerned).
395  *
396  * This contract is only required for intermediate, library-like contracts.
397  */
398 abstract contract Context {
399     function _msgSender() internal view virtual returns (address) {
400         return msg.sender;
401     }
402 
403     function _msgData() internal view virtual returns (bytes calldata) {
404         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
405         return msg.data;
406     }
407 }
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev String operations.
413  */
414 library Strings {
415     bytes16 private constant alphabet = "0123456789abcdef";
416 
417     /**
418      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
419      */
420     function toString(uint256 value) internal pure returns (string memory) {
421         // Inspired by OraclizeAPI's implementation - MIT licence
422         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
423 
424         if (value == 0) {
425             return "0";
426         }
427         uint256 temp = value;
428         uint256 digits;
429         while (temp != 0) {
430             digits++;
431             temp /= 10;
432         }
433         bytes memory buffer = new bytes(digits);
434         while (value != 0) {
435             digits -= 1;
436             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
437             value /= 10;
438         }
439         return string(buffer);
440     }
441 
442     /**
443      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
444      */
445     function toHexString(uint256 value) internal pure returns (string memory) {
446         if (value == 0) {
447             return "0x00";
448         }
449         uint256 temp = value;
450         uint256 length = 0;
451         while (temp != 0) {
452             length++;
453             temp >>= 8;
454         }
455         return toHexString(value, length);
456     }
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
460      */
461     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
462         bytes memory buffer = new bytes(2 * length + 2);
463         buffer[0] = "0";
464         buffer[1] = "x";
465         for (uint256 i = 2 * length + 1; i > 1; --i) {
466             buffer[i] = alphabet[value & 0xf];
467             value >>= 4;
468         }
469         require(value == 0, "Strings: hex length insufficient");
470         return string(buffer);
471     }
472 
473 }
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
505  * the Metadata extension, but not including the Enumerable extension, which is available separately as
506  * {ERC721Enumerable}.
507  */
508 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
509     using Address for address;
510     using Strings for uint256;
511 
512     // Token name
513     string private _name;
514 
515     // Token symbol
516     string private _symbol;
517 
518     // Mapping from token ID to owner address
519     mapping (uint256 => address) private _owners;
520 
521     // Mapping owner address to token count
522     mapping (address => uint256) private _balances;
523 
524     // Mapping from token ID to approved address
525     mapping (uint256 => address) private _tokenApprovals;
526 
527     // Mapping from owner to operator approvals
528     mapping (address => mapping (address => bool)) private _operatorApprovals;
529 
530     /**
531      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
532      */
533     constructor (string memory name_, string memory symbol_) {
534         _name = name_;
535         _symbol = symbol_;
536     }
537 
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
542         return interfaceId == type(IERC721).interfaceId
543             || interfaceId == type(IERC721Metadata).interfaceId
544             || super.supportsInterface(interfaceId);
545     }
546 
547     /**
548      * @dev See {IERC721-balanceOf}.
549      */
550     function balanceOf(address owner) public view virtual override returns (uint256) {
551         require(owner != address(0), "ERC721: balance query for the zero address");
552         return _balances[owner];
553     }
554 
555     /**
556      * @dev See {IERC721-ownerOf}.
557      */
558     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
559         address owner = _owners[tokenId];
560         require(owner != address(0), "ERC721: owner query for nonexistent token");
561         return owner;
562     }
563 
564     /**
565      * @dev See {IERC721Metadata-name}.
566      */
567     function name() public view virtual override returns (string memory) {
568         return _name;
569     }
570 
571     /**
572      * @dev See {IERC721Metadata-symbol}.
573      */
574     function symbol() public view virtual override returns (string memory) {
575         return _symbol;
576     }
577 
578     /**
579      * @dev See {IERC721Metadata-tokenURI}.
580      */
581     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
582         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
583 
584         string memory baseURI = _baseURI();
585         return bytes(baseURI).length > 0
586             ? string(abi.encodePacked(baseURI, tokenId.toString()))
587             : '';
588     }
589 
590     /**
591      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
592      * in child contracts.
593      */
594     function _baseURI() internal view virtual returns (string memory) {
595         return "";
596     }
597 
598     /**
599      * @dev See {IERC721-approve}.
600      */
601     function approve(address to, uint256 tokenId) public virtual override {
602         address owner = ERC721.ownerOf(tokenId);
603         require(to != owner, "ERC721: approval to current owner");
604 
605         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
606             "ERC721: approve caller is not owner nor approved for all"
607         );
608 
609         _approve(to, tokenId);
610     }
611 
612     /**
613      * @dev See {IERC721-getApproved}.
614      */
615     function getApproved(uint256 tokenId) public view virtual override returns (address) {
616         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
617 
618         return _tokenApprovals[tokenId];
619     }
620 
621     /**
622      * @dev See {IERC721-setApprovalForAll}.
623      */
624     function setApprovalForAll(address operator, bool approved) public virtual override {
625         require(operator != _msgSender(), "ERC721: approve to caller");
626 
627         _operatorApprovals[_msgSender()][operator] = approved;
628         emit ApprovalForAll(_msgSender(), operator, approved);
629     }
630 
631     /**
632      * @dev See {IERC721-isApprovedForAll}.
633      */
634     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
635         return _operatorApprovals[owner][operator];
636     }
637 
638     /**
639      * @dev See {IERC721-transferFrom}.
640      */
641     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
642         //solhint-disable-next-line max-line-length
643         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
644 
645         _transfer(from, to, tokenId);
646     }
647 
648     /**
649      * @dev See {IERC721-safeTransferFrom}.
650      */
651     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
652         safeTransferFrom(from, to, tokenId, "");
653     }
654 
655     /**
656      * @dev See {IERC721-safeTransferFrom}.
657      */
658     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
659         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
660         _safeTransfer(from, to, tokenId, _data);
661     }
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
665      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
666      *
667      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
668      *
669      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
670      * implement alternative mechanisms to perform token transfer, such as signature-based.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must exist and be owned by `from`.
677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678      *
679      * Emits a {Transfer} event.
680      */
681     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
682         _transfer(from, to, tokenId);
683         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
684     }
685 
686     /**
687      * @dev Returns whether `tokenId` exists.
688      *
689      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
690      *
691      * Tokens start existing when they are minted (`_mint`),
692      * and stop existing when they are burned (`_burn`).
693      */
694     function _exists(uint256 tokenId) internal view virtual returns (bool) {
695         return _owners[tokenId] != address(0);
696     }
697 
698     /**
699      * @dev Returns whether `spender` is allowed to manage `tokenId`.
700      *
701      * Requirements:
702      *
703      * - `tokenId` must exist.
704      */
705     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
706         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
707         address owner = ERC721.ownerOf(tokenId);
708         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
709     }
710 
711     /**
712      * @dev Safely mints `tokenId` and transfers it to `to`.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must not exist.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _safeMint(address to, uint256 tokenId) internal virtual {
722         _safeMint(to, tokenId, "");
723     }
724 
725     /**
726      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
727      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
728      */
729     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
730         _mint(to, tokenId);
731         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
732     }
733 
734     /**
735      * @dev Mints `tokenId` and transfers it to `to`.
736      *
737      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
738      *
739      * Requirements:
740      *
741      * - `tokenId` must not exist.
742      * - `to` cannot be the zero address.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _mint(address to, uint256 tokenId) internal virtual {
747         require(to != address(0), "ERC721: mint to the zero address");
748         require(!_exists(tokenId), "ERC721: token already minted");
749 
750         _beforeTokenTransfer(address(0), to, tokenId);
751 
752         _balances[to] += 1;
753         _owners[tokenId] = to;
754 
755         emit Transfer(address(0), to, tokenId);
756     }
757 
758     /**
759      * @dev Destroys `tokenId`.
760      * The approval is cleared when the token is burned.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _burn(uint256 tokenId) internal virtual {
769         address owner = ERC721.ownerOf(tokenId);
770 
771         _beforeTokenTransfer(owner, address(0), tokenId);
772 
773         // Clear approvals
774         _approve(address(0), tokenId);
775 
776         _balances[owner] -= 1;
777         delete _owners[tokenId];
778 
779         emit Transfer(owner, address(0), tokenId);
780     }
781 
782     /**
783      * @dev Transfers `tokenId` from `from` to `to`.
784      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
785      *
786      * Requirements:
787      *
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must be owned by `from`.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _transfer(address from, address to, uint256 tokenId) internal virtual {
794         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
795         require(to != address(0), "ERC721: transfer to the zero address");
796 
797         _beforeTokenTransfer(from, to, tokenId);
798 
799         // Clear approvals from the previous owner
800         _approve(address(0), tokenId);
801 
802         _balances[from] -= 1;
803         _balances[to] += 1;
804         _owners[tokenId] = to;
805 
806         emit Transfer(from, to, tokenId);
807     }
808 
809     /**
810      * @dev Approve `to` to operate on `tokenId`
811      *
812      * Emits a {Approval} event.
813      */
814     function _approve(address to, uint256 tokenId) internal virtual {
815         _tokenApprovals[tokenId] = to;
816         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
817     }
818 
819     /**
820      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
821      * The call is not executed if the target address is not a contract.
822      *
823      * @param from address representing the previous owner of the given token ID
824      * @param to target address that will receive the tokens
825      * @param tokenId uint256 ID of the token to be transferred
826      * @param _data bytes optional data to send along with the call
827      * @return bool whether the call correctly returned the expected magic value
828      */
829     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
830         private returns (bool)
831     {
832         if (to.isContract()) {
833             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
834                 return retval == IERC721Receiver(to).onERC721Received.selector;
835             } catch (bytes memory reason) {
836                 if (reason.length == 0) {
837                     revert("ERC721: transfer to non ERC721Receiver implementer");
838                 } else {
839                     // solhint-disable-next-line no-inline-assembly
840                     assembly {
841                         revert(add(32, reason), mload(reason))
842                     }
843                 }
844             }
845         } else {
846             return true;
847         }
848     }
849 
850     /**
851      * @dev Hook that is called before any token transfer. This includes minting
852      * and burning.
853      *
854      * Calling conditions:
855      *
856      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
857      * transferred to `to`.
858      * - When `from` is zero, `tokenId` will be minted for `to`.
859      * - When `to` is zero, ``from``'s `tokenId` will be burned.
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      *
863      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
864      */
865     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
866 }
867 
868 pragma solidity ^0.8.0;
869 
870 /**
871  * @title Counters
872  * @author Matt Condon (@shrugs)
873  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
874  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
875  *
876  * Include with `using Counters for Counters.Counter;`
877  */
878 library Counters {
879     struct Counter {
880         // This variable should never be directly accessed by users of the library: interactions must be restricted to
881         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
882         // this feature: see https://github.com/ethereum/solidity/issues/4637
883         uint256 _value; // default: 0
884     }
885 
886     function current(Counter storage counter) internal view returns (uint256) {
887         return counter._value;
888     }
889 
890     function increment(Counter storage counter) internal {
891         unchecked {
892             counter._value += 1;
893         }
894     }
895 
896     function decrement(Counter storage counter) internal {
897         uint256 value = counter._value;
898         require(value > 0, "Counter: decrement overflow");
899         unchecked {
900             counter._value = value - 1;
901         }
902     }
903 }
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev Contract module which provides a basic access control mechanism, where
909  * there is an account (an owner) that can be granted exclusive access to
910  * specific functions.
911  *
912  * By default, the owner account will be the one that deploys the contract. This
913  * can later be changed with {transferOwnership}.
914  *
915  * This module is used through inheritance. It will make available the modifier
916  * `onlyOwner`, which can be applied to your functions to restrict their use to
917  * the owner.
918  */
919 abstract contract Ownable is Context {
920     address private _owner;
921 
922     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
923 
924     /**
925      * @dev Initializes the contract setting the deployer as the initial owner.
926      */
927     constructor () {
928         address msgSender = _msgSender();
929         _owner = msgSender;
930         emit OwnershipTransferred(address(0), msgSender);
931     }
932 
933     /**
934      * @dev Returns the address of the current owner.
935      */
936     function owner() public view virtual returns (address) {
937         return _owner;
938     }
939 
940     /**
941      * @dev Throws if called by any account other than the owner.
942      */
943     modifier onlyOwner() {
944         require(owner() == _msgSender(), "Ownable: caller is not the owner");
945         _;
946     }
947 
948     /**
949      * @dev Leaves the contract without owner. It will not be possible to call
950      * `onlyOwner` functions anymore. Can only be called by the current owner.
951      *
952      * NOTE: Renouncing ownership will leave the contract without an owner,
953      * thereby removing any functionality that is only available to the owner.
954      */
955     function renounceOwnership() public virtual onlyOwner {
956         emit OwnershipTransferred(_owner, address(0));
957         _owner = address(0);
958     }
959 
960     /**
961      * @dev Transfers ownership of the contract to a new account (`newOwner`).
962      * Can only be called by the current owner.
963      */
964     function transferOwnership(address newOwner) public virtual onlyOwner {
965         require(newOwner != address(0), "Ownable: new owner is the zero address");
966         emit OwnershipTransferred(_owner, newOwner);
967         _owner = newOwner;
968     }
969 }
970 
971 // File: contracts\ArteonGPU.sol
972 
973 pragma solidity ^0.8.0;
974 
975 contract ArteonGPU is ERC721, Ownable {
976   using Counters for Counters.Counter;
977   Counters.Counter private _tokenIds;
978 
979   string private _tokenURI;
980   uint256 private _cap;
981 
982   constructor() ERC721('Arteon Graphics Card: ARTX 1000', 'ARTX 1000') {
983     _tokenURI = 'https://nft.arteon.org/json/artx1000.json';
984     _cap = 400;
985   }
986 
987   function supplyCap() public view virtual returns (uint256) {
988     return _cap;
989   }
990 
991   function totalSupply() public view virtual returns (uint256) {
992     return _tokenIds.current();
993   }
994 
995   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
996     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
997     return _tokenURI;
998   }
999 
1000   function addCard(address to) public onlyOwner returns (uint256) {
1001     _tokenIds.increment();
1002 
1003     uint256 _tokenId = _tokenIds.current();
1004     require(_tokenId <= _cap, 'SUPPLY_CAP_EXCEEDED');
1005     _mint(to, _tokenId);
1006 
1007     return _tokenId;
1008   }
1009 }