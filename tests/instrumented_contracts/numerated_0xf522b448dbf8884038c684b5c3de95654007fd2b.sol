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
584 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
585 pragma solidity ^0.8.0;
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver.onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
987 
988 
989 
990 pragma solidity ^0.8.0;
991 
992 
993 
994 /**
995  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
996  * enumerability of all the token ids in the contract as well as all token ids owned by each
997  * account.
998  */
999 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1000     // Mapping from owner to list of owned token IDs
1001     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1002 
1003     // Mapping from token ID to index of the owner tokens list
1004     mapping(uint256 => uint256) private _ownedTokensIndex;
1005 
1006     // Array with all token ids, used for enumeration
1007     uint256[] private _allTokens;
1008 
1009     // Mapping from token id to position in the allTokens array
1010     mapping(uint256 => uint256) private _allTokensIndex;
1011 
1012     /**
1013      * @dev See {IERC165-supportsInterface}.
1014      */
1015     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1016         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1023         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1024         return _ownedTokens[owner][index];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-totalSupply}.
1029      */
1030     function totalSupply() public view virtual override returns (uint256) {
1031         return _allTokens.length;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-tokenByIndex}.
1036      */
1037     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1038         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1039         return _allTokens[index];
1040     }
1041 
1042     /**
1043      * @dev Hook that is called before any token transfer. This includes minting
1044      * and burning.
1045      *
1046      * Calling conditions:
1047      *
1048      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1049      * transferred to `to`.
1050      * - When `from` is zero, `tokenId` will be minted for `to`.
1051      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1052      * - `from` cannot be the zero address.
1053      * - `to` cannot be the zero address.
1054      *
1055      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1056      */
1057     function _beforeTokenTransfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual override {
1062         super._beforeTokenTransfer(from, to, tokenId);
1063 
1064         if (from == address(0)) {
1065             _addTokenToAllTokensEnumeration(tokenId);
1066         } else if (from != to) {
1067             _removeTokenFromOwnerEnumeration(from, tokenId);
1068         }
1069         if (to == address(0)) {
1070             _removeTokenFromAllTokensEnumeration(tokenId);
1071         } else if (to != from) {
1072             _addTokenToOwnerEnumeration(to, tokenId);
1073         }
1074     }
1075 
1076     /**
1077      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1078      * @param to address representing the new owner of the given token ID
1079      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1080      */
1081     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1082         uint256 length = ERC721.balanceOf(to);
1083         _ownedTokens[to][length] = tokenId;
1084         _ownedTokensIndex[tokenId] = length;
1085     }
1086 
1087     /**
1088      * @dev Private function to add a token to this extension's token tracking data structures.
1089      * @param tokenId uint256 ID of the token to be added to the tokens list
1090      */
1091     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1092         _allTokensIndex[tokenId] = _allTokens.length;
1093         _allTokens.push(tokenId);
1094     }
1095 
1096     /**
1097      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1098      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1099      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1100      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1101      * @param from address representing the previous owner of the given token ID
1102      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1103      */
1104     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1105         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1106         // then delete the last slot (swap and pop).
1107 
1108         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1109         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1110 
1111         // When the token to delete is the last token, the swap operation is unnecessary
1112         if (tokenIndex != lastTokenIndex) {
1113             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1114 
1115             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1116             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1117         }
1118 
1119         // This also deletes the contents at the last position of the array
1120         delete _ownedTokensIndex[tokenId];
1121         delete _ownedTokens[from][lastTokenIndex];
1122     }
1123 
1124     /**
1125      * @dev Private function to remove a token from this extension's token tracking data structures.
1126      * This has O(1) time complexity, but alters the order of the _allTokens array.
1127      * @param tokenId uint256 ID of the token to be removed from the tokens list
1128      */
1129     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1130         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1131         // then delete the last slot (swap and pop).
1132 
1133         uint256 lastTokenIndex = _allTokens.length - 1;
1134         uint256 tokenIndex = _allTokensIndex[tokenId];
1135 
1136         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1137         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1138         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1139         uint256 lastTokenId = _allTokens[lastTokenIndex];
1140 
1141         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1142         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1143 
1144         // This also deletes the contents at the last position of the array
1145         delete _allTokensIndex[tokenId];
1146         _allTokens.pop();
1147     }
1148 }
1149 
1150 
1151 // File: @openzeppelin/contracts/access/Ownable.sol
1152 pragma solidity ^0.8.0;
1153 /**
1154  * @dev Contract module which provides a basic access control mechanism, where
1155  * there is an account (an owner) that can be granted exclusive access to
1156  * specific functions.
1157  *
1158  * By default, the owner account will be the one that deploys the contract. This
1159  * can later be changed with {transferOwnership}.
1160  *
1161  * This module is used through inheritance. It will make available the modifier
1162  * `onlyOwner`, which can be applied to your functions to restrict their use to
1163  * the owner.
1164  */
1165 abstract contract Ownable is Context {
1166     address private _owner;
1167 
1168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1169 
1170     /**
1171      * @dev Initializes the contract setting the deployer as the initial owner.
1172      */
1173     constructor() {
1174         _setOwner(_msgSender());
1175     }
1176 
1177     /**
1178      * @dev Returns the address of the current owner.
1179      */
1180     function owner() public view virtual returns (address) {
1181         return _owner;
1182     }
1183 
1184     /**
1185      * @dev Throws if called by any account other than the owner.
1186      */
1187     modifier onlyOwner() {
1188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1189         _;
1190     }
1191 
1192     /**
1193      * @dev Leaves the contract without owner. It will not be possible to call
1194      * `onlyOwner` functions anymore. Can only be called by the current owner.
1195      *
1196      * NOTE: Renouncing ownership will leave the contract without an owner,
1197      * thereby removing any functionality that is only available to the owner.
1198      */
1199     function renounceOwnership() public virtual onlyOwner {
1200         _setOwner(address(0));
1201     }
1202 
1203     /**
1204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1205      * Can only be called by the current owner.
1206      */
1207     function transferOwnership(address newOwner) public virtual onlyOwner {
1208         require(newOwner != address(0), "Ownable: new owner is the zero address");
1209         _setOwner(newOwner);
1210     }
1211 
1212     function _setOwner(address newOwner) private {
1213         address oldOwner = _owner;
1214         _owner = newOwner;
1215         emit OwnershipTransferred(oldOwner, newOwner);
1216     }
1217 }
1218 
1219 pragma solidity >=0.7.0 <0.9.0;
1220 
1221 contract AmeegosNFT is ERC721Enumerable, Ownable {
1222   using Strings for uint256;
1223 
1224   string baseURI;
1225   string baseExtension = ".json";
1226   string notRevealedUri;
1227   uint256 public cost = 0.075 ether;
1228   uint256 public maxSupply = 7500;
1229   uint256 public maxMintAmount = 3;
1230   uint256 public nftPerAddressLimit = 3;
1231   bool public paused = false;
1232   bool public revealed = false;
1233   bool public onlyWhitelisted = true;
1234   address payable commissions = payable(0xde3B22caAaD25e65C839c2A3d852d665669EdD5c);
1235   address[] public whitelistedAddresses;
1236   mapping(address => uint256) public addressMintedBalance;
1237 
1238   constructor(
1239     string memory _name,
1240     string memory _symbol,
1241     string memory _initBaseURI,
1242     string memory _initNotRevealedUri
1243   ) ERC721(_name, _symbol) {
1244     setBaseURI(_initBaseURI);
1245     setNotRevealedURI(_initNotRevealedUri);
1246   }
1247 
1248   // internal
1249   function _baseURI() internal view virtual override returns (string memory) {
1250     return baseURI;
1251   }
1252 
1253   // public
1254   function mint(uint256 _mintAmount) public payable {
1255     require(!paused, "the contract is paused");
1256     uint256 supply = totalSupply();
1257     require(_mintAmount > 0, "need to mint at least 1 NFT");
1258     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1259     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1260 
1261     if (msg.sender != owner()) {
1262         if(onlyWhitelisted == true) {
1263             require(isWhitelisted(msg.sender), "user is not whitelisted");
1264             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1265             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1266         }
1267         require(msg.value >= cost * _mintAmount, "insufficient funds");
1268     }
1269 
1270     for (uint256 i = 1; i <= _mintAmount; i++) {
1271       addressMintedBalance[msg.sender]++;
1272       _safeMint(msg.sender, supply + i);
1273     }
1274    
1275     (bool success, ) = payable(commissions).call{value: msg.value * 7 / 100}("");
1276     require(success);
1277   }
1278  
1279   function isWhitelisted(address _user) public view returns (bool) {
1280     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1281       if (whitelistedAddresses[i] == _user) {
1282           return true;
1283       }
1284     }
1285     return false;
1286   }
1287 
1288   function walletOfOwner(address _owner)
1289     public
1290     view
1291     returns (uint256[] memory)
1292   {
1293     uint256 ownerTokenCount = balanceOf(_owner);
1294     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1295     for (uint256 i; i < ownerTokenCount; i++) {
1296       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1297     }
1298     return tokenIds;
1299   }
1300 
1301   function tokenURI(uint256 tokenId)
1302     public
1303     view
1304     virtual
1305     override
1306     returns (string memory)
1307   {
1308     require(
1309       _exists(tokenId),
1310       "ERC721Metadata: URI query for nonexistent token"
1311     );
1312    
1313     if(revealed == false) {
1314         return notRevealedUri;
1315     }
1316 
1317     string memory currentBaseURI = _baseURI();
1318     return bytes(currentBaseURI).length > 0
1319         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1320         : "";
1321   }
1322 
1323   //only owner
1324   function reveal() public onlyOwner() {
1325       revealed = true;
1326   }
1327  
1328   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1329     nftPerAddressLimit = _limit;
1330   }
1331  
1332   function setCost(uint256 _newCost) public onlyOwner() {
1333     cost = _newCost;
1334   }
1335 
1336   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1337     maxMintAmount = _newmaxMintAmount;
1338   }
1339 
1340   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1341     baseURI = _newBaseURI;
1342   }
1343 
1344   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1345     baseExtension = _newBaseExtension;
1346   }
1347  
1348   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1349     notRevealedUri = _notRevealedURI;
1350   }
1351 
1352   function pause(bool _state) public onlyOwner {
1353     paused = _state;
1354   }
1355  
1356   function setOnlyWhitelisted(bool _state) public onlyOwner {
1357     onlyWhitelisted = _state;
1358   }
1359  
1360   function whitelistUsers(address[] calldata _users) public onlyOwner {
1361     delete whitelistedAddresses;
1362     whitelistedAddresses = _users;
1363   }
1364  
1365   function withdraw() public payable onlyOwner {
1366     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1367     require(success);
1368   }
1369 }