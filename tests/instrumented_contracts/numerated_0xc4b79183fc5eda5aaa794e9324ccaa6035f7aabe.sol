1 // SPDX-License-Identifier: MIT
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
629             super.supportsInterface(interfaceId);
630     }
631 
632     /**
633      * @dev See {IERC721-balanceOf}.
634      */
635     function balanceOf(address owner) public view virtual override returns (uint256) {
636         require(owner != address(0), "ERC721: balance query for the zero address");
637         return _balances[owner];
638     }
639 
640     /**
641      * @dev See {IERC721-ownerOf}.
642      */
643     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
644         address owner = _owners[tokenId];
645         require(owner != address(0), "ERC721: owner query for nonexistent token");
646         return owner;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-name}.
651      */
652     function name() public view virtual override returns (string memory) {
653         return _name;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-symbol}.
658      */
659     function symbol() public view virtual override returns (string memory) {
660         return _symbol;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-tokenURI}.
665      */
666     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
667         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
668 
669         string memory baseURI = _baseURI();
670         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
671     }
672 
673     /**
674      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
675      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
676      * by default, can be overriden in child contracts.
677      */
678     function _baseURI() internal view virtual returns (string memory) {
679         return "";
680     }
681 
682     /**
683      * @dev See {IERC721-approve}.
684      */
685     function approve(address to, uint256 tokenId) public virtual override {
686         address owner = ERC721.ownerOf(tokenId);
687         require(to != owner, "ERC721: approval to current owner");
688 
689         require(
690             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
691             "ERC721: approve caller is not owner nor approved for all"
692         );
693 
694         _approve(to, tokenId);
695     }
696 
697     /**
698      * @dev See {IERC721-getApproved}.
699      */
700     function getApproved(uint256 tokenId) public view virtual override returns (address) {
701         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
702 
703         return _tokenApprovals[tokenId];
704     }
705 
706     /**
707      * @dev See {IERC721-setApprovalForAll}.
708      */
709     function setApprovalForAll(address operator, bool approved) public virtual override {
710         require(operator != _msgSender(), "ERC721: approve to caller");
711 
712         _operatorApprovals[_msgSender()][operator] = approved;
713         emit ApprovalForAll(_msgSender(), operator, approved);
714     }
715 
716     /**
717      * @dev See {IERC721-isApprovedForAll}.
718      */
719     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
720         return _operatorApprovals[owner][operator];
721     }
722 
723     /**
724      * @dev See {IERC721-transferFrom}.
725      */
726     function transferFrom(
727         address from,
728         address to,
729         uint256 tokenId
730     ) public virtual override {
731         //solhint-disable-next-line max-line-length
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733 
734         _transfer(from, to, tokenId);
735     }
736 
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         safeTransferFrom(from, to, tokenId, "");
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes memory _data
756     ) public virtual override {
757         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
758         _safeTransfer(from, to, tokenId, _data);
759     }
760 
761     /**
762      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
763      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
764      *
765      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
766      *
767      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
768      * implement alternative mechanisms to perform token transfer, such as signature-based.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _safeTransfer(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) internal virtual {
785         _transfer(from, to, tokenId);
786         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
787     }
788 
789     /**
790      * @dev Returns whether `tokenId` exists.
791      *
792      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
793      *
794      * Tokens start existing when they are minted (`_mint`),
795      * and stop existing when they are burned (`_burn`).
796      */
797     function _exists(uint256 tokenId) internal view virtual returns (bool) {
798         return _owners[tokenId] != address(0);
799     }
800 
801     /**
802      * @dev Returns whether `spender` is allowed to manage `tokenId`.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
809         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
810         address owner = ERC721.ownerOf(tokenId);
811         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
812     }
813 
814     /**
815      * @dev Safely mints `tokenId` and transfers it to `to`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must not exist.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeMint(address to, uint256 tokenId) internal virtual {
825         _safeMint(to, tokenId, "");
826     }
827 
828     /**
829      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
830      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
831      */
832     function _safeMint(
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) internal virtual {
837         _mint(to, tokenId);
838         require(
839             _checkOnERC721Received(address(0), to, tokenId, _data),
840             "ERC721: transfer to non ERC721Receiver implementer"
841         );
842     }
843 
844     /**
845      * @dev Mints `tokenId` and transfers it to `to`.
846      *
847      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
848      *
849      * Requirements:
850      *
851      * - `tokenId` must not exist.
852      * - `to` cannot be the zero address.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _mint(address to, uint256 tokenId) internal virtual {
857         require(to != address(0), "ERC721: mint to the zero address");
858         require(!_exists(tokenId), "ERC721: token already minted");
859 
860         _beforeTokenTransfer(address(0), to, tokenId);
861 
862         _balances[to] += 1;
863         _owners[tokenId] = to;
864 
865         emit Transfer(address(0), to, tokenId);
866     }
867 
868     /**
869      * @dev Destroys `tokenId`.
870      * The approval is cleared when the token is burned.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _burn(uint256 tokenId) internal virtual {
879         address owner = ERC721.ownerOf(tokenId);
880 
881         _beforeTokenTransfer(owner, address(0), tokenId);
882 
883         // Clear approvals
884         _approve(address(0), tokenId);
885 
886         _balances[owner] -= 1;
887         delete _owners[tokenId];
888 
889         emit Transfer(owner, address(0), tokenId);
890     }
891 
892     /**
893      * @dev Transfers `tokenId` from `from` to `to`.
894      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
895      *
896      * Requirements:
897      *
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must be owned by `from`.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _transfer(
904         address from,
905         address to,
906         uint256 tokenId
907     ) internal virtual {
908         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
909         require(to != address(0), "ERC721: transfer to the zero address");
910 
911         _beforeTokenTransfer(from, to, tokenId);
912 
913         // Clear approvals from the previous owner
914         _approve(address(0), tokenId);
915 
916         _balances[from] -= 1;
917         _balances[to] += 1;
918         _owners[tokenId] = to;
919 
920         emit Transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev Approve `to` to operate on `tokenId`
925      *
926      * Emits a {Approval} event.
927      */
928     function _approve(address to, uint256 tokenId) internal virtual {
929         _tokenApprovals[tokenId] = to;
930         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
931     }
932 
933     /**
934      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
935      * The call is not executed if the target address is not a contract.
936      *
937      * @param from address representing the previous owner of the given token ID
938      * @param to target address that will receive the tokens
939      * @param tokenId uint256 ID of the token to be transferred
940      * @param _data bytes optional data to send along with the call
941      * @return bool whether the call correctly returned the expected magic value
942      */
943     function _checkOnERC721Received(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) private returns (bool) {
949         if (to.isContract()) {
950             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
951                 return retval == IERC721Receiver.onERC721Received.selector;
952             } catch (bytes memory reason) {
953                 if (reason.length == 0) {
954                     revert("ERC721: transfer to non ERC721Receiver implementer");
955                 } else {
956                     assembly {
957                         revert(add(32, reason), mload(reason))
958                     }
959                 }
960             }
961         } else {
962             return true;
963         }
964     }
965 
966     /**
967      * @dev Hook that is called before any token transfer. This includes minting
968      * and burning.
969      *
970      * Calling conditions:
971      *
972      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
973      * transferred to `to`.
974      * - When `from` is zero, `tokenId` will be minted for `to`.
975      * - When `to` is zero, ``from``'s `tokenId` will be burned.
976      * - `from` and `to` are never both zero.
977      *
978      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
979      */
980     function _beforeTokenTransfer(
981         address from,
982         address to,
983         uint256 tokenId
984     ) internal virtual {}
985 }
986 
987 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
988 
989 
990 
991 pragma solidity ^0.8.0;
992 
993 
994 
995 /**
996  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
997  * enumerability of all the token ids in the contract as well as all token ids owned by each
998  * account.
999  */
1000 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1001     // Mapping from owner to list of owned token IDs
1002     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1003 
1004     // Mapping from token ID to index of the owner tokens list
1005     mapping(uint256 => uint256) private _ownedTokensIndex;
1006 
1007     // Array with all token ids, used for enumeration
1008     uint256[] private _allTokens;
1009 
1010     // Mapping from token id to position in the allTokens array
1011     mapping(uint256 => uint256) private _allTokensIndex;
1012 
1013     /**
1014      * @dev See {IERC165-supportsInterface}.
1015      */
1016     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1017         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1022      */
1023     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1024         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1025         return _ownedTokens[owner][index];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-totalSupply}.
1030      */
1031     function totalSupply() public view virtual override returns (uint256) {
1032         return _allTokens.length;
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-tokenByIndex}.
1037      */
1038     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1039         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1040         return _allTokens[index];
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before any token transfer. This includes minting
1045      * and burning.
1046      *
1047      * Calling conditions:
1048      *
1049      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1050      * transferred to `to`.
1051      * - When `from` is zero, `tokenId` will be minted for `to`.
1052      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1053      * - `from` cannot be the zero address.
1054      * - `to` cannot be the zero address.
1055      *
1056      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1057      */
1058     function _beforeTokenTransfer(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) internal virtual override {
1063         super._beforeTokenTransfer(from, to, tokenId);
1064 
1065         if (from == address(0)) {
1066             _addTokenToAllTokensEnumeration(tokenId);
1067         } else if (from != to) {
1068             _removeTokenFromOwnerEnumeration(from, tokenId);
1069         }
1070         if (to == address(0)) {
1071             _removeTokenFromAllTokensEnumeration(tokenId);
1072         } else if (to != from) {
1073             _addTokenToOwnerEnumeration(to, tokenId);
1074         }
1075     }
1076 
1077     /**
1078      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1079      * @param to address representing the new owner of the given token ID
1080      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1081      */
1082     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1083         uint256 length = ERC721.balanceOf(to);
1084         _ownedTokens[to][length] = tokenId;
1085         _ownedTokensIndex[tokenId] = length;
1086     }
1087 
1088     /**
1089      * @dev Private function to add a token to this extension's token tracking data structures.
1090      * @param tokenId uint256 ID of the token to be added to the tokens list
1091      */
1092     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1093         _allTokensIndex[tokenId] = _allTokens.length;
1094         _allTokens.push(tokenId);
1095     }
1096 
1097     /**
1098      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1099      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1100      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1101      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1102      * @param from address representing the previous owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1104      */
1105     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1106         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1107         // then delete the last slot (swap and pop).
1108 
1109         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1110         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1111 
1112         // When the token to delete is the last token, the swap operation is unnecessary
1113         if (tokenIndex != lastTokenIndex) {
1114             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1115 
1116             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1117             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1118         }
1119 
1120         // This also deletes the contents at the last position of the array
1121         delete _ownedTokensIndex[tokenId];
1122         delete _ownedTokens[from][lastTokenIndex];
1123     }
1124 
1125     /**
1126      * @dev Private function to remove a token from this extension's token tracking data structures.
1127      * This has O(1) time complexity, but alters the order of the _allTokens array.
1128      * @param tokenId uint256 ID of the token to be removed from the tokens list
1129      */
1130     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1131         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1132         // then delete the last slot (swap and pop).
1133 
1134         uint256 lastTokenIndex = _allTokens.length - 1;
1135         uint256 tokenIndex = _allTokensIndex[tokenId];
1136 
1137         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1138         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1139         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1140         uint256 lastTokenId = _allTokens[lastTokenIndex];
1141 
1142         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1143         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1144 
1145         // This also deletes the contents at the last position of the array
1146         delete _allTokensIndex[tokenId];
1147         _allTokens.pop();
1148     }
1149 }
1150 
1151 
1152 // File: @openzeppelin/contracts/access/Ownable.sol
1153 pragma solidity ^0.8.0;
1154 /**
1155  * @dev Contract module which provides a basic access control mechanism, where
1156  * there is an account (an owner) that can be granted exclusive access to
1157  * specific functions.
1158  *
1159  * By default, the owner account will be the one that deploys the contract. This
1160  * can later be changed with {transferOwnership}.
1161  *
1162  * This module is used through inheritance. It will make available the modifier
1163  * `onlyOwner`, which can be applied to your functions to restrict their use to
1164  * the owner.
1165  */
1166 abstract contract Ownable is Context {
1167     address private _owner;
1168 
1169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1170 
1171     /**
1172      * @dev Initializes the contract setting the deployer as the initial owner.
1173      */
1174     constructor() {
1175         _setOwner(_msgSender());
1176     }
1177 
1178     /**
1179      * @dev Returns the address of the current owner.
1180      */
1181     function owner() public view virtual returns (address) {
1182         return _owner;
1183     }
1184 
1185     /**
1186      * @dev Throws if called by any account other than the owner.
1187      */
1188     modifier onlyOwner() {
1189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1190         _;
1191     }
1192 
1193     /**
1194      * @dev Leaves the contract without owner. It will not be possible to call
1195      * `onlyOwner` functions anymore. Can only be called by the current owner.
1196      *
1197      * NOTE: Renouncing ownership will leave the contract without an owner,
1198      * thereby removing any functionality that is only available to the owner.
1199      */
1200     function renounceOwnership() public virtual onlyOwner {
1201         _setOwner(address(0));
1202     }
1203 
1204     /**
1205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1206      * Can only be called by the current owner.
1207      */
1208     function transferOwnership(address newOwner) public virtual onlyOwner {
1209         require(newOwner != address(0), "Ownable: new owner is the zero address");
1210         _setOwner(newOwner);
1211     }
1212 
1213     function _setOwner(address newOwner) private {
1214         address oldOwner = _owner;
1215         _owner = newOwner;
1216         emit OwnershipTransferred(oldOwner, newOwner);
1217     }
1218 }
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 /**
1223  * @dev These functions deal with verification of Merkle Tree proofs.
1224  *
1225  * The proofs can be generated using the JavaScript library
1226  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1227  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1228  *
1229  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1230  *
1231  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1232  * hashing, or use a hash function other than keccak256 for hashing leaves.
1233  * This is because the concatenation of a sorted pair of internal nodes in
1234  * the merkle tree could be reinterpreted as a leaf value.
1235  */
1236 library MerkleProof {
1237     /**
1238      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1239      * defined by `root`. For this, a `proof` must be provided, containing
1240      * sibling hashes on the branch from the leaf to the root of the tree. Each
1241      * pair of leaves and each pair of pre-images are assumed to be sorted.
1242      */
1243     function verify(
1244         bytes32[] memory proof,
1245         bytes32 root,
1246         bytes32 leaf
1247     ) internal pure returns (bool) {
1248         return processProof(proof, leaf) == root;
1249     }
1250 
1251     /**
1252      * @dev Calldata version of {verify}
1253      *
1254      * _Available since v4.7._
1255      */
1256     function verifyCalldata(
1257         bytes32[] calldata proof,
1258         bytes32 root,
1259         bytes32 leaf
1260     ) internal pure returns (bool) {
1261         return processProofCalldata(proof, leaf) == root;
1262     }
1263 
1264     /**
1265      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1266      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1267      * hash matches the root of the tree. When processing the proof, the pairs
1268      * of leafs & pre-images are assumed to be sorted.
1269      *
1270      * _Available since v4.4._
1271      */
1272     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1273         bytes32 computedHash = leaf;
1274         for (uint256 i = 0; i < proof.length; i++) {
1275             computedHash = _hashPair(computedHash, proof[i]);
1276         }
1277         return computedHash;
1278     }
1279 
1280     /**
1281      * @dev Calldata version of {processProof}
1282      *
1283      * _Available since v4.7._
1284      */
1285     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1286         bytes32 computedHash = leaf;
1287         for (uint256 i = 0; i < proof.length; i++) {
1288             computedHash = _hashPair(computedHash, proof[i]);
1289         }
1290         return computedHash;
1291     }
1292 
1293     /**
1294      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1295      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1296      *
1297      * _Available since v4.7._
1298      */
1299     function multiProofVerify(
1300         bytes32[] memory proof,
1301         bool[] memory proofFlags,
1302         bytes32 root,
1303         bytes32[] memory leaves
1304     ) internal pure returns (bool) {
1305         return processMultiProof(proof, proofFlags, leaves) == root;
1306     }
1307 
1308     /**
1309      * @dev Calldata version of {multiProofVerify}
1310      *
1311      * _Available since v4.7._
1312      */
1313     function multiProofVerifyCalldata(
1314         bytes32[] calldata proof,
1315         bool[] calldata proofFlags,
1316         bytes32 root,
1317         bytes32[] memory leaves
1318     ) internal pure returns (bool) {
1319         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1320     }
1321 
1322     /**
1323      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1324      * consuming from one or the other at each step according to the instructions given by
1325      * `proofFlags`.
1326      *
1327      * _Available since v4.7._
1328      */
1329     function processMultiProof(
1330         bytes32[] memory proof,
1331         bool[] memory proofFlags,
1332         bytes32[] memory leaves
1333     ) internal pure returns (bytes32 merkleRoot) {
1334         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1335         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1336         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1337         // the merkle tree.
1338         uint256 leavesLen = leaves.length;
1339         uint256 totalHashes = proofFlags.length;
1340 
1341         // Check proof validity.
1342         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1343 
1344         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1345         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1346         bytes32[] memory hashes = new bytes32[](totalHashes);
1347         uint256 leafPos = 0;
1348         uint256 hashPos = 0;
1349         uint256 proofPos = 0;
1350         // At each step, we compute the next hash using two values:
1351         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1352         //   get the next hash.
1353         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1354         //   `proof` array.
1355         for (uint256 i = 0; i < totalHashes; i++) {
1356             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1357             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1358             hashes[i] = _hashPair(a, b);
1359         }
1360 
1361         if (totalHashes > 0) {
1362             return hashes[totalHashes - 1];
1363         } else if (leavesLen > 0) {
1364             return leaves[0];
1365         } else {
1366             return proof[0];
1367         }
1368     }
1369 
1370     /**
1371      * @dev Calldata version of {processMultiProof}
1372      *
1373      * _Available since v4.7._
1374      */
1375     function processMultiProofCalldata(
1376         bytes32[] calldata proof,
1377         bool[] calldata proofFlags,
1378         bytes32[] memory leaves
1379     ) internal pure returns (bytes32 merkleRoot) {
1380         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1381         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1382         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1383         // the merkle tree.
1384         uint256 leavesLen = leaves.length;
1385         uint256 totalHashes = proofFlags.length;
1386 
1387         // Check proof validity.
1388         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1389 
1390         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1391         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1392         bytes32[] memory hashes = new bytes32[](totalHashes);
1393         uint256 leafPos = 0;
1394         uint256 hashPos = 0;
1395         uint256 proofPos = 0;
1396         // At each step, we compute the next hash using two values:
1397         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1398         //   get the next hash.
1399         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1400         //   `proof` array.
1401         for (uint256 i = 0; i < totalHashes; i++) {
1402             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1403             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1404             hashes[i] = _hashPair(a, b);
1405         }
1406 
1407         if (totalHashes > 0) {
1408             return hashes[totalHashes - 1];
1409         } else if (leavesLen > 0) {
1410             return leaves[0];
1411         } else {
1412             return proof[0];
1413         }
1414     }
1415 
1416     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1417         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1418     }
1419 
1420     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1421         /// @solidity memory-safe-assembly
1422         assembly {
1423             mstore(0x00, a)
1424             mstore(0x20, b)
1425             value := keccak256(0x00, 0x40)
1426         }
1427     }
1428 }
1429 
1430 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1431 
1432 pragma solidity ^0.8.0;
1433 
1434 /**
1435  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1436  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1437  *
1438  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1439  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1440  * need to send a transaction, and thus is not required to hold Ether at all.
1441  */
1442 interface IERC20Permit {
1443     /**
1444      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1445      * given ``owner``'s signed approval.
1446      *
1447      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1448      * ordering also apply here.
1449      *
1450      * Emits an {Approval} event.
1451      *
1452      * Requirements:
1453      *
1454      * - `spender` cannot be the zero address.
1455      * - `deadline` must be a timestamp in the future.
1456      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1457      * over the EIP712-formatted function arguments.
1458      * - the signature must use ``owner``'s current nonce (see {nonces}).
1459      *
1460      * For more information on the signature format, see the
1461      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1462      * section].
1463      */
1464     function permit(
1465         address owner,
1466         address spender,
1467         uint256 value,
1468         uint256 deadline,
1469         uint8 v,
1470         bytes32 r,
1471         bytes32 s
1472     ) external;
1473 
1474     /**
1475      * @dev Returns the current nonce for `owner`. This value must be
1476      * included whenever a signature is generated for {permit}.
1477      *
1478      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1479      * prevents a signature from being used multiple times.
1480      */
1481     function nonces(address owner) external view returns (uint256);
1482 
1483     /**
1484      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1485      */
1486     // solhint-disable-next-line func-name-mixedcase
1487     function DOMAIN_SEPARATOR() external view returns (bytes32);
1488 }
1489 
1490 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 /**
1495  * @dev Interface of the ERC20 standard as defined in the EIP.
1496  */
1497 interface IERC20 {
1498     /**
1499      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1500      * another (`to`).
1501      *
1502      * Note that `value` may be zero.
1503      */
1504     event Transfer(address indexed from, address indexed to, uint256 value);
1505 
1506     /**
1507      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1508      * a call to {approve}. `value` is the new allowance.
1509      */
1510     event Approval(address indexed owner, address indexed spender, uint256 value);
1511 
1512     /**
1513      * @dev Returns the amount of tokens in existence.
1514      */
1515     function totalSupply() external view returns (uint256);
1516 
1517     /**
1518      * @dev Returns the amount of tokens owned by `account`.
1519      */
1520     function balanceOf(address account) external view returns (uint256);
1521 
1522     /**
1523      * @dev Moves `amount` tokens from the caller's account to `to`.
1524      *
1525      * Returns a boolean value indicating whether the operation succeeded.
1526      *
1527      * Emits a {Transfer} event.
1528      */
1529     function transfer(address to, uint256 amount) external returns (bool);
1530 
1531     /**
1532      * @dev Returns the remaining number of tokens that `spender` will be
1533      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1534      * zero by default.
1535      *
1536      * This value changes when {approve} or {transferFrom} are called.
1537      */
1538     function allowance(address owner, address spender) external view returns (uint256);
1539 
1540     /**
1541      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1542      *
1543      * Returns a boolean value indicating whether the operation succeeded.
1544      *
1545      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1546      * that someone may use both the old and the new allowance by unfortunate
1547      * transaction ordering. One possible solution to mitigate this race
1548      * condition is to first reduce the spender's allowance to 0 and set the
1549      * desired value afterwards:
1550      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1551      *
1552      * Emits an {Approval} event.
1553      */
1554     function approve(address spender, uint256 amount) external returns (bool);
1555 
1556     /**
1557      * @dev Moves `amount` tokens from `from` to `to` using the
1558      * allowance mechanism. `amount` is then deducted from the caller's
1559      * allowance.
1560      *
1561      * Returns a boolean value indicating whether the operation succeeded.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function transferFrom(
1566         address from,
1567         address to,
1568         uint256 amount
1569     ) external returns (bool);
1570 }
1571 
1572 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1573 pragma solidity ^0.8.0;
1574 /**
1575  * @title SafeERC20
1576  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1577  * contract returns false). Tokens that return no value (and instead revert or
1578  * throw on failure) are also supported, non-reverting calls are assumed to be
1579  * successful.
1580  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1581  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1582  */
1583 library SafeERC20 {
1584     using Address for address;
1585 
1586     function safeTransfer(
1587         IERC20 token,
1588         address to,
1589         uint256 value
1590     ) internal {
1591         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1592     }
1593 
1594     function safeTransferFrom(
1595         IERC20 token,
1596         address from,
1597         address to,
1598         uint256 value
1599     ) internal {
1600         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1601     }
1602 
1603     /**
1604      * @dev Deprecated. This function has issues similar to the ones found in
1605      * {IERC20-approve}, and its usage is discouraged.
1606      *
1607      * Whenever possible, use {safeIncreaseAllowance} and
1608      * {safeDecreaseAllowance} instead.
1609      */
1610     function safeApprove(
1611         IERC20 token,
1612         address spender,
1613         uint256 value
1614     ) internal {
1615         // safeApprove should only be called when setting an initial allowance,
1616         // or when resetting it to zero. To increase and decrease it, use
1617         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1618         require(
1619             (value == 0) || (token.allowance(address(this), spender) == 0),
1620             "SafeERC20: approve from non-zero to non-zero allowance"
1621         );
1622         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1623     }
1624 
1625     function safeIncreaseAllowance(
1626         IERC20 token,
1627         address spender,
1628         uint256 value
1629     ) internal {
1630         uint256 newAllowance = token.allowance(address(this), spender) + value;
1631         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1632     }
1633 
1634     function safeDecreaseAllowance(
1635         IERC20 token,
1636         address spender,
1637         uint256 value
1638     ) internal {
1639         unchecked {
1640             uint256 oldAllowance = token.allowance(address(this), spender);
1641             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1642             uint256 newAllowance = oldAllowance - value;
1643             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1644         }
1645     }
1646 
1647     function safePermit(
1648         IERC20Permit token,
1649         address owner,
1650         address spender,
1651         uint256 value,
1652         uint256 deadline,
1653         uint8 v,
1654         bytes32 r,
1655         bytes32 s
1656     ) internal {
1657         uint256 nonceBefore = token.nonces(owner);
1658         token.permit(owner, spender, value, deadline, v, r, s);
1659         uint256 nonceAfter = token.nonces(owner);
1660         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1661     }
1662 
1663     /**
1664      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1665      * on the return value: the return value is optional (but if data is returned, it must not be false).
1666      * @param token The token targeted by the call.
1667      * @param data The call data (encoded using abi.encode or one of its variants).
1668      */
1669     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1670         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1671         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1672         // the target address contains contract code and also asserts for success in the low-level call.
1673 
1674         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1675         if (returndata.length > 0) {
1676             // Return data is optional
1677             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1678         }
1679     }
1680 }
1681 
1682 pragma solidity ^0.8.0;
1683 /**
1684  * @title PaymentSplitter
1685  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1686  * that the Ether will be split in this way, since it is handled transparently by the contract.
1687  *
1688  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1689  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1690  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
1691  * time of contract deployment and can't be updated thereafter.
1692  *
1693  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1694  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1695  * function.
1696  *
1697  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1698  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1699  * to run tests before sending real value to this contract.
1700  */
1701 contract PaymentSplitter is Context {
1702     event PayeeAdded(address account, uint256 shares);
1703     event PaymentReleased(address to, uint256 amount);
1704     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1705     event PaymentReceived(address from, uint256 amount);
1706 
1707     uint256 private _totalShares;
1708     uint256 private _totalReleased;
1709 
1710     mapping(address => uint256) private _shares;
1711     mapping(address => uint256) private _released;
1712     address[] private _payees;
1713 
1714     mapping(IERC20 => uint256) private _erc20TotalReleased;
1715     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1716 
1717     /**
1718      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1719      * the matching position in the `shares` array.
1720      *
1721      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1722      * duplicates in `payees`.
1723      */
1724     constructor(address[] memory payees, uint256[] memory shares_) payable {
1725         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1726         require(payees.length > 0, "PaymentSplitter: no payees");
1727 
1728         for (uint256 i = 0; i < payees.length; i++) {
1729             _addPayee(payees[i], shares_[i]);
1730         }
1731     }
1732 
1733     /**
1734      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1735      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1736      * reliability of the events, and not the actual splitting of Ether.
1737      *
1738      * To learn more about this see the Solidity documentation for
1739      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1740      * functions].
1741      */
1742     receive() external payable virtual {
1743         emit PaymentReceived(_msgSender(), msg.value);
1744     }
1745 
1746     /**
1747      * @dev Getter for the total shares held by payees.
1748      */
1749     function totalShares() public view returns (uint256) {
1750         return _totalShares;
1751     }
1752 
1753     /**
1754      * @dev Getter for the total amount of Ether already released.
1755      */
1756     function totalReleased() public view returns (uint256) {
1757         return _totalReleased;
1758     }
1759 
1760     /**
1761      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1762      * contract.
1763      */
1764     function totalReleased(IERC20 token) public view returns (uint256) {
1765         return _erc20TotalReleased[token];
1766     }
1767 
1768     /**
1769      * @dev Getter for the amount of shares held by an account.
1770      */
1771     function shares(address account) public view returns (uint256) {
1772         return _shares[account];
1773     }
1774 
1775     /**
1776      * @dev Getter for the amount of Ether already released to a payee.
1777      */
1778     function released(address account) public view returns (uint256) {
1779         return _released[account];
1780     }
1781 
1782     /**
1783      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1784      * IERC20 contract.
1785      */
1786     function released(IERC20 token, address account) public view returns (uint256) {
1787         return _erc20Released[token][account];
1788     }
1789 
1790     /**
1791      * @dev Getter for the address of the payee number `index`.
1792      */
1793     function payee(uint256 index) public view returns (address) {
1794         return _payees[index];
1795     }
1796 
1797     /**
1798      * @dev Getter for the amount of payee's releasable Ether.
1799      */
1800     function releasable(address account) public view returns (uint256) {
1801         uint256 totalReceived = address(this).balance + totalReleased();
1802         return _pendingPayment(account, totalReceived, released(account));
1803     }
1804 
1805     /**
1806      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1807      * IERC20 contract.
1808      */
1809     function releasable(IERC20 token, address account) public view returns (uint256) {
1810         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1811         return _pendingPayment(account, totalReceived, released(token, account));
1812     }
1813 
1814     /**
1815      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1816      * total shares and their previous withdrawals.
1817      */
1818     function release(address payable account) public virtual {
1819         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1820 
1821         uint256 payment = releasable(account);
1822 
1823         require(payment != 0, "PaymentSplitter: account is not due payment");
1824 
1825         // _totalReleased is the sum of all values in _released.
1826         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
1827         _totalReleased += payment;
1828         unchecked {
1829             _released[account] += payment;
1830         }
1831 
1832         Address.sendValue(account, payment);
1833         emit PaymentReleased(account, payment);
1834     }
1835 
1836     /**
1837      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1838      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1839      * contract.
1840      */
1841     function release(IERC20 token, address account) public virtual {
1842         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1843 
1844         uint256 payment = releasable(token, account);
1845 
1846         require(payment != 0, "PaymentSplitter: account is not due payment");
1847 
1848         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
1849         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
1850         // cannot overflow.
1851         _erc20TotalReleased[token] += payment;
1852         unchecked {
1853             _erc20Released[token][account] += payment;
1854         }
1855 
1856         SafeERC20.safeTransfer(token, account, payment);
1857         emit ERC20PaymentReleased(token, account, payment);
1858     }
1859 
1860     /**
1861      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1862      * already released amounts.
1863      */
1864     function _pendingPayment(
1865         address account,
1866         uint256 totalReceived,
1867         uint256 alreadyReleased
1868     ) private view returns (uint256) {
1869         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1870     }
1871 
1872     /**
1873      * @dev Add a new payee to the contract.
1874      * @param account The address of the payee to add.
1875      * @param shares_ The number of shares owned by the payee.
1876      */
1877     function _addPayee(address account, uint256 shares_) private {
1878         require(account != address(0), "PaymentSplitter: account is the zero address");
1879         require(shares_ > 0, "PaymentSplitter: shares are 0");
1880         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1881 
1882         _payees.push(account);
1883         _shares[account] = shares_;
1884         _totalShares = _totalShares + shares_;
1885         emit PayeeAdded(account, shares_);
1886     }
1887 }
1888 
1889 pragma solidity >=0.7.0 <0.9.0;
1890 
1891 contract Azaza is ERC721Enumerable, Ownable, PaymentSplitter {
1892   using Strings for uint256;
1893 
1894   string baseURI;
1895   uint256 public cost = 0.05 ether;
1896   uint256 public maxSupply = 555;
1897   uint public maxFree = 0;
1898   uint public wlMaxPerTx = 1;
1899   uint public wlMaxPerWallet = 1;
1900   uint public publicMaxPerTx = 1;
1901   uint public publicMaxPerWallet = 1;
1902   uint public totalFree = 0;
1903   mapping (address => uint) internal wlMintWallet;
1904   mapping (address => uint) internal publicMintWallet;
1905   bool public paused;
1906   bytes32 public merkleRoot;
1907    mapping (address => bool) public claimedMint;
1908   enum Step {
1909     Before,
1910     WhitelistSale,
1911     PublicSale,
1912     SoldOut,
1913     Reveal
1914   }
1915 
1916     uint256 private _teamLength;
1917 
1918     address[] private _team = [
1919         0xe3E5608D7e4594313c71ef0D2BF0F8F500869f79
1920     ];
1921 
1922     uint256[] private _teamShares = [1000];
1923 
1924   Step public sellingStep;
1925   constructor(
1926     string memory _name,
1927     string memory _symbol,
1928     string memory _baseURI,
1929     bytes32 _merkleRoot
1930   ) ERC721(_name, _symbol) PaymentSplitter(_team, _teamShares) {
1931     baseURI = _baseURI;
1932     merkleRoot = _merkleRoot;
1933     _teamLength = _team.length;
1934   }
1935 
1936   // public
1937   function mint(uint256 _mintAmount) public payable {
1938     require(!paused, "Contract paused.");
1939     require(sellingStep == Step.PublicSale, "Public sale is not running");
1940     require(_mintAmount > 0, "You can't mint less than 1 NFT.");
1941     require(_mintAmount <= publicMaxPerTx, "You can't mint more than 5 NFT in one transaction.");
1942     uint supply = totalSupply();
1943     require(supply + _mintAmount <= maxSupply, "Max supply exceeded.");
1944 
1945     if (msg.sender != owner()) {
1946         require(msg.value >= cost * _mintAmount, "Sorry you did not send enough ether");
1947         if(publicMaxPerWallet != 0) {
1948             require(publicMintWallet[msg.sender] + _mintAmount <= publicMaxPerWallet, "Max per wallet exceeded");
1949             publicMintWallet[msg.sender] += _mintAmount;
1950         }
1951     }
1952 
1953     for (uint256 i = 1; i <= _mintAmount; i++) {
1954       _safeMint(msg.sender, supply + i);
1955     }
1956   }
1957 
1958   function whitelistMint(uint _mintAmount, bytes32[] calldata _proof) public payable {
1959     require(!paused, "Contract paused.");
1960     require(sellingStep == Step.WhitelistSale, "Whitelist sale is not running.");
1961     require(isWhitelisted(msg.sender, _proof), "You're not whitelisted.");
1962     require(_mintAmount > 0, "You can't mint less than 1 NFT.");
1963     require(_mintAmount <= wlMaxPerTx, "You can't mint more than limit in one transaction.");
1964     uint supply = totalSupply();
1965     require(supply + _mintAmount <= maxSupply, "Max supply exceeded.");
1966 
1967     if (msg.sender != owner()) {
1968         if(totalFree + 1 <= maxFree) {
1969             if (!claimedMint[msg.sender]) {
1970                 require(msg.value >= cost * _mintAmount - cost, "Sorry you did not send enough ether");
1971                 claimedMint[msg.sender] = true;
1972 		    totalFree += 1;
1973             } else {
1974                 require(msg.value >= cost * _mintAmount, "Sorry you did not send enough ether");
1975             }
1976         } else {
1977                 require(msg.value >= cost * _mintAmount, "Sorry you did not send enough ether");
1978         }
1979         if(wlMaxPerWallet != 0) {
1980             require(wlMintWallet[msg.sender] + _mintAmount <= wlMaxPerWallet, "Max per wallet exceeded");
1981             wlMintWallet[msg.sender] += _mintAmount;
1982         }
1983     }
1984 
1985     for (uint256 i = 1; i <= _mintAmount; i++) {
1986       _safeMint(msg.sender, supply + i);
1987     }
1988   }
1989 
1990   function walletOfOwner(address _owner)
1991     public
1992     view
1993     returns (uint256[] memory)
1994   {
1995     uint256 ownerTokenCount = balanceOf(_owner);
1996     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1997     for (uint256 i; i < ownerTokenCount; i++) {
1998       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1999     }
2000     return tokenIds;
2001   }
2002 
2003     /**
2004      * @notice Get the token URI of an NFT by his ID
2005      *
2006      * @param _tokenId The ID of the NFT you want to have the URI of the metadatas
2007      *
2008      * @return string Token URI of an NFT by his ID
2009      */
2010     function tokenURI(uint256 _tokenId)
2011         public
2012         view
2013         virtual
2014         override
2015         returns (string memory)
2016     {
2017         require(_exists(_tokenId), "URI query for nonexistent token");
2018 
2019         return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
2020     }
2021   
2022   function setCost(uint256 _newCost) public onlyOwner {
2023     cost = _newCost;
2024   }
2025 
2026   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2027     baseURI = _newBaseURI;
2028   }
2029   function pause(bool _state) public onlyOwner {
2030     paused = _state;
2031   }
2032 
2033       /**
2034      * @notice Change the step of the sale
2035      *
2036      * @param _step The new step of the sale
2037      */
2038     function setStep(uint256 _step) external onlyOwner {
2039         sellingStep = Step(_step);
2040     }
2041 
2042     function setMaxFree(uint256 _maxfree) public onlyOwner {
2043         maxFree = _maxfree;
2044     }
2045 
2046     function setWlMaxPerTx(uint _wlMaxPerTx) public onlyOwner {
2047         wlMaxPerTx = _wlMaxPerTx;
2048     }
2049 
2050     function setWlMaxPerWallet(uint _wlMaxPerWallet) public onlyOwner {
2051         wlMaxPerWallet = _wlMaxPerWallet;
2052     }
2053 
2054     function setPublicMaxPerTx(uint _publicMaxPerTx) public onlyOwner {
2055         publicMaxPerTx = _publicMaxPerTx;
2056     }
2057 
2058     function setPublicMaxPerWallet(uint _publicMaxPerWallet) public onlyOwner {
2059         wlMaxPerWallet = _publicMaxPerWallet;
2060     }
2061 
2062     function getMintInfos(address _account) external view returns(uint[11] memory) {
2063         uint[11] memory infos = [wlMaxPerTx, wlMaxPerWallet, wlMintWallet[_account], publicMaxPerTx, publicMaxPerWallet, publicMintWallet[_account], claimedMint[_account] ? 1 : 0, totalSupply(), maxFree, uint(sellingStep), totalFree];
2064         return infos;
2065     }
2066 
2067       /**
2068      * @notice Change the merkle root
2069      *
2070      * @param _merkleRoot The new merkle root
2071      */
2072     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2073         merkleRoot = _merkleRoot;
2074     }
2075 
2076     /**
2077      * @notice Hash an address
2078      *
2079      * @param _account The address to be hashed
2080      *
2081      * @return bytes32 The hashed address
2082      */
2083     function leaf(address _account) internal pure returns (bytes32) {
2084         return keccak256(abi.encodePacked(_account));
2085     }
2086 
2087     /**
2088      * @notice Returns true if a leaf can be proved to be a part of a merkle tree defined by root
2089      *
2090      * @param _leaf The leaf
2091      * @param _proof The Merkle Proof
2092      *
2093      * @return bool return true if a leaf can be proved to be a part of a merkle tree defined by root, false othewise
2094      */
2095     function _verify(bytes32 _leaf, bytes32[] memory _proof)
2096         internal
2097         view
2098         returns (bool)
2099     {
2100         return MerkleProof.verify(_proof, merkleRoot, _leaf);
2101     }
2102 
2103     /**
2104      * @notice Check if an address is whitelisted or not
2105      *
2106      * @param _account The account checked
2107      * @param _proof The Merkle Proof
2108      *
2109      * @return bool return true if an address is whitelisted, false otherwise
2110      */
2111     function isWhitelisted(address _account, bytes32[] calldata _proof)
2112         public
2113         view
2114         returns (bool)
2115     {
2116         return _verify(leaf(_account), _proof);
2117     }
2118 
2119         /**
2120      * @notice Release the gains on every accounts
2121      */
2122     function releaseAll() external {
2123         for (uint256 i = 0; i < _teamLength; i++) {
2124             release(payable(payee(i)));
2125         }
2126     }
2127 }