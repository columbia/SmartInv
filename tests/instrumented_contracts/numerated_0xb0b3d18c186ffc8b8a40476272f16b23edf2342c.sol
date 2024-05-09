1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 pragma solidity ^0.8.0;
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
165 
166 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
167 pragma solidity ^0.8.0;
168 /**
169  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
170  * @dev See https://eips.ethereum.org/EIPS/eip-721
171  */
172 interface IERC721Enumerable is IERC721 {
173     /**
174      * @dev Returns the total amount of tokens stored by the contract.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
180      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
181      */
182     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
183 
184     /**
185      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
186      * Use along with {totalSupply} to enumerate all tokens.
187      */
188     function tokenByIndex(uint256 index) external view returns (uint256);
189 }
190 
191 
192 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
193 pragma solidity ^0.8.0;
194 /**
195  * @dev Implementation of the {IERC165} interface.
196  *
197  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
198  * for the additional interface id that will be supported. For example:
199  *
200  * ```solidity
201  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
202  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
203  * }
204  * ```
205  *
206  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
207  */
208 abstract contract ERC165 is IERC165 {
209     /**
210      * @dev See {IERC165-supportsInterface}.
211      */
212     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
213         return interfaceId == type(IERC165).interfaceId;
214     }
215 }
216 
217 // File: @openzeppelin/contracts/utils/Strings.sol
218 
219 
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return "0";
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return "0x00";
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = "0";
276         buffer[1] = "x";
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = _HEX_SYMBOLS[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, "Strings: hex length insufficient");
282         return string(buffer);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Address.sol
287 
288 
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      */
313     function isContract(address account) internal view returns (bool) {
314         // This method relies on extcodesize, which returns 0 for contracts in
315         // construction, since the code is only stored at the end of the
316         // constructor execution.
317 
318         uint256 size;
319         assembly {
320             size := extcodesize(account)
321         }
322         return size > 0;
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         (bool success, ) = recipient.call{value: amount}("");
345         require(success, "Address: unable to send value, recipient may have reverted");
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain `call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionCall(target, data, "Address: low-level call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
372      * `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(address(this).balance >= value, "Address: insufficient balance for call");
416         require(isContract(target), "Address: call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.call{value: value}(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
429         return functionStaticCall(target, data, "Address: low-level static call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal view returns (bytes memory) {
443         require(isContract(target), "Address: static call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.staticcall(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
456         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a delegate call.
462      *
463      * _Available since v3.4._
464      */
465     function functionDelegateCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         require(isContract(target), "Address: delegate call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.delegatecall(data);
473         return verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
478      * revert reason using the provided one.
479      *
480      * _Available since v4.3._
481      */
482     function verifyCallResult(
483         bool success,
484         bytes memory returndata,
485         string memory errorMessage
486     ) internal pure returns (bytes memory) {
487         if (success) {
488             return returndata;
489         } else {
490             // Look for revert reason and bubble it up if present
491             if (returndata.length > 0) {
492                 // The easiest way to bubble the revert reason is using memory via assembly
493 
494                 assembly {
495                     let returndata_size := mload(returndata)
496                     revert(add(32, returndata), returndata_size)
497                 }
498             } else {
499                 revert(errorMessage);
500             }
501         }
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
506 
507 
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
514  * @dev See https://eips.ethereum.org/EIPS/eip-721
515  */
516 interface IERC721Metadata is IERC721 {
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
534 
535 
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @title ERC721 token receiver interface
541  * @dev Interface for any contract that wants to support safeTransfers
542  * from ERC721 asset contracts.
543  */
544 interface IERC721Receiver {
545     /**
546      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
547      * by `operator` from `from`, this function is called.
548      *
549      * It must return its Solidity selector to confirm the token transfer.
550      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
551      *
552      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
553      */
554     function onERC721Received(
555         address operator,
556         address from,
557         uint256 tokenId,
558         bytes calldata data
559     ) external returns (bytes4);
560 }
561 
562 // File: @openzeppelin/contracts/utils/Context.sol
563 pragma solidity ^0.8.0;
564 /**
565  * @dev Provides information about the current execution context, including the
566  * sender of the transaction and its data. While these are generally available
567  * via msg.sender and msg.data, they should not be accessed in such a direct
568  * manner, since when dealing with meta-transactions the account sending and
569  * paying for execution may not be the actual sender (as far as an application
570  * is concerned).
571  *
572  * This contract is only required for intermediate, library-like contracts.
573  */
574 abstract contract Context {
575     function _msgSender() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _msgData() internal view virtual returns (bytes calldata) {
580         return msg.data;
581     }
582 }
583 
584 
585 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
586 pragma solidity ^0.8.0;
587 /**
588  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
589  * the Metadata extension, but not including the Enumerable extension, which is available separately as
590  * {ERC721Enumerable}.
591  */
592 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
593     using Address for address;
594     using Strings for uint256;
595 
596     // Token name
597     string private _name;
598 
599     // Token symbol
600     string private _symbol;
601 
602     // Mapping from token ID to owner address
603     mapping(uint256 => address) private _owners;
604 
605     // Mapping owner address to token count
606     mapping(address => uint256) private _balances;
607 
608     // Mapping from token ID to approved address
609     mapping(uint256 => address) private _tokenApprovals;
610 
611     // Mapping from owner to operator approvals
612     mapping(address => mapping(address => bool)) private _operatorApprovals;
613 
614     /**
615      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
616      */
617     constructor(string memory name_, string memory symbol_) {
618         _name = name_;
619         _symbol = symbol_;
620     }
621 
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
626         return
627             interfaceId == type(IERC721).interfaceId ||
628             interfaceId == type(IERC721Metadata).interfaceId ||
629             interfaceId == type(IERC2981).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         require(operator != _msgSender(), "ERC721: approve to caller");
712 
713         _operatorApprovals[_msgSender()][operator] = approved;
714         emit ApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
936      * The call is not executed if the target address is not a contract.
937      *
938      * @param from address representing the previous owner of the given token ID
939      * @param to target address that will receive the tokens
940      * @param tokenId uint256 ID of the token to be transferred
941      * @param _data bytes optional data to send along with the call
942      * @return bool whether the call correctly returned the expected magic value
943      */
944     function _checkOnERC721Received(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) private returns (bool) {
950         if (to.isContract()) {
951             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
952                 return retval == IERC721Receiver.onERC721Received.selector;
953             } catch (bytes memory reason) {
954                 if (reason.length == 0) {
955                     revert("ERC721: transfer to non ERC721Receiver implementer");
956                 } else {
957                     assembly {
958                         revert(add(32, reason), mload(reason))
959                     }
960                 }
961             }
962         } else {
963             return true;
964         }
965     }
966 
967     /**
968      * @dev Hook that is called before any token transfer. This includes minting
969      * and burning.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, ``from``'s `tokenId` will be burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _beforeTokenTransfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {}
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 
996 /**
997  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
998  * enumerability of all the token ids in the contract as well as all token ids owned by each
999  * account.
1000  */
1001 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1002     // Mapping from owner to list of owned token IDs
1003     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1004 
1005     // Mapping from token ID to index of the owner tokens list
1006     mapping(uint256 => uint256) private _ownedTokensIndex;
1007 
1008     // Array with all token ids, used for enumeration
1009     uint256[] private _allTokens;
1010 
1011     // Mapping from token id to position in the allTokens array
1012     mapping(uint256 => uint256) private _allTokensIndex;
1013 
1014     /**
1015      * @dev See {IERC165-supportsInterface}.
1016      */
1017     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1018         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1023      */
1024     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1026         return _ownedTokens[owner][index];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-totalSupply}.
1031      */
1032     function totalSupply() public view virtual override returns (uint256) {
1033         return _allTokens.length;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenByIndex}.
1038      */
1039     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1041         return _allTokens[index];
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before any token transfer. This includes minting
1046      * and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1051      * transferred to `to`.
1052      * - When `from` is zero, `tokenId` will be minted for `to`.
1053      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1054      * - `from` cannot be the zero address.
1055      * - `to` cannot be the zero address.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _beforeTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual override {
1064         super._beforeTokenTransfer(from, to, tokenId);
1065 
1066         if (from == address(0)) {
1067             _addTokenToAllTokensEnumeration(tokenId);
1068         } else if (from != to) {
1069             _removeTokenFromOwnerEnumeration(from, tokenId);
1070         }
1071         if (to == address(0)) {
1072             _removeTokenFromAllTokensEnumeration(tokenId);
1073         } else if (to != from) {
1074             _addTokenToOwnerEnumeration(to, tokenId);
1075         }
1076     }
1077 
1078     /**
1079      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1080      * @param to address representing the new owner of the given token ID
1081      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1082      */
1083     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1084         uint256 length = ERC721.balanceOf(to);
1085         _ownedTokens[to][length] = tokenId;
1086         _ownedTokensIndex[tokenId] = length;
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's token tracking data structures.
1091      * @param tokenId uint256 ID of the token to be added to the tokens list
1092      */
1093     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1094         _allTokensIndex[tokenId] = _allTokens.length;
1095         _allTokens.push(tokenId);
1096     }
1097 
1098     /**
1099      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1100      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1101      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1102      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1103      * @param from address representing the previous owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1105      */
1106     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1107         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1108         // then delete the last slot (swap and pop).
1109 
1110         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1111         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1112 
1113         // When the token to delete is the last token, the swap operation is unnecessary
1114         if (tokenIndex != lastTokenIndex) {
1115             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1116 
1117             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1118             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1119         }
1120 
1121         // This also deletes the contents at the last position of the array
1122         delete _ownedTokensIndex[tokenId];
1123         delete _ownedTokens[from][lastTokenIndex];
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's token tracking data structures.
1128      * This has O(1) time complexity, but alters the order of the _allTokens array.
1129      * @param tokenId uint256 ID of the token to be removed from the tokens list
1130      */
1131     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1132         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1133         // then delete the last slot (swap and pop).
1134 
1135         uint256 lastTokenIndex = _allTokens.length - 1;
1136         uint256 tokenIndex = _allTokensIndex[tokenId];
1137 
1138         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1139         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1140         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1141         uint256 lastTokenId = _allTokens[lastTokenIndex];
1142 
1143         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1144         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1145 
1146         // This also deletes the contents at the last position of the array
1147         delete _allTokensIndex[tokenId];
1148         _allTokens.pop();
1149     }
1150 }
1151 
1152 
1153 // File: @openzeppelin/contracts/access/Ownable.sol
1154 pragma solidity ^0.8.0;
1155 /**
1156  * @dev Contract module which provides a basic access control mechanism, where
1157  * there is an account (an owner) that can be granted exclusive access to
1158  * specific functions.
1159  *
1160  * By default, the owner account will be the one that deploys the contract. This
1161  * can later be changed with {transferOwnership}.
1162  *
1163  * This module is used through inheritance. It will make available the modifier
1164  * `onlyOwner`, which can be applied to your functions to restrict their use to
1165  * the owner.
1166  */
1167 abstract contract Ownable is Context {
1168     address private _owner;
1169 
1170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1171 
1172     /**
1173      * @dev Initializes the contract setting the deployer as the initial owner.
1174      */
1175     constructor() {
1176         _setOwner(_msgSender());
1177     }
1178 
1179     /**
1180      * @dev Returns the address of the current owner.
1181      */
1182     function owner() public view virtual returns (address) {
1183         return _owner;
1184     }
1185 
1186     /**
1187      * @dev Throws if called by any account other than the owner.
1188      */
1189     modifier onlyOwner() {
1190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1191         _;
1192     }
1193 
1194     /**
1195      * @dev Leaves the contract without owner. It will not be possible to call
1196      * `onlyOwner` functions anymore. Can only be called by the current owner.
1197      *
1198      * NOTE: Renouncing ownership will leave the contract without an owner,
1199      * thereby removing any functionality that is only available to the owner.
1200      */
1201     function renounceOwnership() public virtual onlyOwner {
1202         _setOwner(address(0));
1203     }
1204 
1205     /**
1206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1207      * Can only be called by the current owner.
1208      */
1209     function transferOwnership(address newOwner) public virtual onlyOwner {
1210         require(newOwner != address(0), "Ownable: new owner is the zero address");
1211         _setOwner(newOwner);
1212     }
1213 
1214     function _setOwner(address newOwner) private {
1215         address oldOwner = _owner;
1216         _owner = newOwner;
1217         emit OwnershipTransferred(oldOwner, newOwner);
1218     }
1219 }
1220 
1221 interface IERC2981 is IERC165 {
1222     /// ERC165 bytes to add to interface array - set in parent contract
1223     /// implementing this standard
1224     ///
1225     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1226     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1227     /// _registerInterface(_INTERFACE_ID_ERC2981);
1228 
1229     /// @notice Called with the sale price to determine how much royalty
1230     //          is owed and to whom.
1231     /// @param _tokenId - the NFT asset queried for royalty information
1232     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
1233     /// @return receiver - address of who should be sent the royalty payment
1234     /// @return royaltyAmount - the royalty payment amount for _salePrice
1235     function royaltyInfo(
1236         uint256 _tokenId,
1237         uint256 _salePrice
1238     ) external view returns (
1239         address receiver,
1240         uint256 royaltyAmount
1241     );
1242 }
1243 
1244 interface IOperatorFilterRegistry {
1245     /**
1246      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1247      *         true if supplied registrant address is not registered.
1248      */
1249     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1250 
1251     /**
1252      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1253      */
1254     function register(address registrant) external;
1255 
1256     /**
1257      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1258      */
1259     function registerAndSubscribe(address registrant, address subscription) external;
1260 
1261     /**
1262      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1263      *         address without subscribing.
1264      */
1265     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1266 
1267     /**
1268      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1269      *         Note that this does not remove any filtered addresses or codeHashes.
1270      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1271      */
1272     function unregister(address addr) external;
1273 
1274     /**
1275      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1276      */
1277     function updateOperator(address registrant, address operator, bool filtered) external;
1278 
1279     /**
1280      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1281      */
1282     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1283 
1284     /**
1285      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1286      */
1287     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1288 
1289     /**
1290      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1291      */
1292     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1293 
1294     /**
1295      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1296      *         subscription if present.
1297      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1298      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1299      *         used.
1300      */
1301     function subscribe(address registrant, address registrantToSubscribe) external;
1302 
1303     /**
1304      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1305      */
1306     function unsubscribe(address registrant, bool copyExistingEntries) external;
1307 
1308     /**
1309      * @notice Get the subscription address of a given registrant, if any.
1310      */
1311     function subscriptionOf(address addr) external returns (address registrant);
1312 
1313     /**
1314      * @notice Get the set of addresses subscribed to a given registrant.
1315      *         Note that order is not guaranteed as updates are made.
1316      */
1317     function subscribers(address registrant) external returns (address[] memory);
1318 
1319     /**
1320      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1321      *         Note that order is not guaranteed as updates are made.
1322      */
1323     function subscriberAt(address registrant, uint256 index) external returns (address);
1324 
1325     /**
1326      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1327      */
1328     function copyEntriesOf(address registrant, address registrantToCopy) external;
1329 
1330     /**
1331      * @notice Returns true if operator is filtered by a given address or its subscription.
1332      */
1333     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1334 
1335     /**
1336      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1337      */
1338     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1339 
1340     /**
1341      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1342      */
1343     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1344 
1345     /**
1346      * @notice Returns a list of filtered operators for a given address or its subscription.
1347      */
1348     function filteredOperators(address addr) external returns (address[] memory);
1349 
1350     /**
1351      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1352      *         Note that order is not guaranteed as updates are made.
1353      */
1354     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1355 
1356     /**
1357      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1358      *         its subscription.
1359      *         Note that order is not guaranteed as updates are made.
1360      */
1361     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1362 
1363     /**
1364      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1365      *         its subscription.
1366      *         Note that order is not guaranteed as updates are made.
1367      */
1368     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1369 
1370     /**
1371      * @notice Returns true if an address has registered
1372      */
1373     function isRegistered(address addr) external returns (bool);
1374 
1375     /**
1376      * @dev Convenience method to compute the code hash of an arbitrary contract
1377      */
1378     function codeHashOf(address addr) external returns (bytes32);
1379 }
1380 
1381 abstract contract OperatorFilterer {
1382     /// @dev Emitted when an operator is not allowed.
1383     error OperatorNotAllowed(address operator);
1384 
1385     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1386         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1387 
1388     /// @dev The constructor that is called when the contract is being deployed.
1389     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1390         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1391         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1392         // order for the modifier to filter addresses.
1393         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1394             if (subscribe) {
1395                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1396             } else {
1397                 if (subscriptionOrRegistrantToCopy != address(0)) {
1398                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1399                 } else {
1400                     OPERATOR_FILTER_REGISTRY.register(address(this));
1401                 }
1402             }
1403         }
1404     }
1405 
1406     /**
1407      * @dev A helper function to check if an operator is allowed.
1408      */
1409     modifier onlyAllowedOperator(address from) virtual {
1410         // Allow spending tokens from addresses with balance
1411         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1412         // from an EOA.
1413         if (from != msg.sender) {
1414             _checkFilterOperator(msg.sender);
1415         }
1416         _;
1417     }
1418 
1419     /**
1420      * @dev A helper function to check if an operator approval is allowed.
1421      */
1422     modifier onlyAllowedOperatorApproval(address operator) virtual {
1423         _checkFilterOperator(operator);
1424         _;
1425     }
1426 
1427     /**
1428      * @dev A helper function to check if an operator is allowed.
1429      */
1430     function _checkFilterOperator(address operator) internal view virtual {
1431         // Check registry code length to facilitate testing in environments without a deployed registry.
1432         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1433             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1434             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1435             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1436                 revert OperatorNotAllowed(operator);
1437             }
1438         }
1439     }
1440 }
1441 
1442 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1443     /// @dev The constructor that is called when the contract is being deployed.
1444     constructor() OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {}
1445 }
1446 
1447 pragma solidity >=0.7.0 <0.9.0;
1448 
1449 contract deployedContract {
1450     function ownerOf(uint256) public returns (address) {}
1451 }
1452 
1453 contract AngryRidersSociety is DefaultOperatorFilterer, ERC721Enumerable, IERC2981, Ownable {
1454   using Strings for uint256;
1455   string public baseURI = "baseUrl";
1456   string public notRevealedUri = "notrevealedUrl.json";
1457   uint256 public maxSupply = 4250;
1458   bool public paused = true;
1459   bool public revealed = false;
1460   constructor(
1461     string memory _name,
1462     string memory _symbol
1463   ) ERC721(_name, _symbol) {
1464   }
1465   function _baseURI() internal view virtual override returns (string memory) {
1466     return baseURI;
1467   }
1468   function mint(uint256 ppID) public {
1469     require(!paused, "the contract is paused");
1470     if (_exists(ppID)) { revert(); }
1471     if (deployedContract(0x50ca8e24D80946B9ccF4A15279DfF9eafde7e240).ownerOf(ppID) != msg.sender) {
1472       revert();
1473     }
1474     _safeMint(msg.sender, ppID);
1475   }
1476   function mintMultiple(uint256[] calldata ppID, uint amount) public {
1477       if (amount > 50) { revert(); }
1478       for (uint i; i < amount; i++) {
1479           mint(ppID[i]);
1480       }
1481   }
1482   function walletOfOwner(address _owner)
1483     public
1484     view
1485     returns (uint256[] memory)
1486   {
1487     uint256 ownerTokenCount = balanceOf(_owner);
1488     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1489     for (uint256 i; i < ownerTokenCount; i++) {
1490       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1491     }
1492     return tokenIds;
1493   }
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
1505     if(revealed == false) {
1506         return notRevealedUri;
1507     }
1508     string memory currentBaseURI = _baseURI();
1509     return bytes(currentBaseURI).length > 0
1510         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1511         : "";
1512   }
1513   function reveal() public onlyOwner {
1514       revealed = true;
1515   }
1516   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1517     baseURI = _newBaseURI;
1518   }
1519   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1520     notRevealedUri = _notRevealedURI;
1521   }
1522   function pause(bool _state) public onlyOwner {
1523     paused = _state;
1524   }
1525   function withdraw() public payable onlyOwner {
1526     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1527     require(os);
1528   }
1529 
1530 function mintOwner(uint256 amount) public onlyOwner {
1531     require(amount > 0, "Amount must be greater than 0");
1532     require(totalSupply() + amount <= maxSupply, "Minting exceeds the max supply");
1533 
1534     for (uint256 i = 0; i < amount; i++) {
1535         uint256 tokenId = totalSupply() + 1;
1536         _safeMint(msg.sender, tokenId);
1537     }
1538 }
1539 
1540 
1541   function royaltyInfo(uint256 tokenId, uint256 salePrice)
1542     public
1543     pure
1544     override
1545     returns (address receiver, uint256 royaltyAmount)
1546   {
1547     return (0x6E17dBaF9B8753380f2d3E703Cf7e822d0D4e254,(10 * salePrice)/100);
1548   }
1549   function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
1550     super.setApprovalForAll(operator, approved);
1551   }
1552   function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
1553     super.approve(operator, tokenId);
1554   }
1555   function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
1556     super.transferFrom(from, to, tokenId);
1557   }
1558   function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
1559     super.safeTransferFrom(from, to, tokenId);
1560   }
1561   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1562     public
1563     override(ERC721, IERC721)
1564     onlyAllowedOperator(from)
1565   {
1566     super.safeTransferFrom(from, to, tokenId, data);
1567   }
1568 }