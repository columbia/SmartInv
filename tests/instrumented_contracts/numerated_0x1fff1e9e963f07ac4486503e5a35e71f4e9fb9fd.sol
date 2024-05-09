1 // SPDX-License-Identifier: MIT
2 
3 // MTI4
4 
5 
6 // File: @openzeppelin/contracts@4.3.1/utils/Strings.sol
7 
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts@4.3.1/utils/Address.sol
76 
77 
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      */
102     function isContract(address account) internal view returns (bool) {
103         // This method relies on extcodesize, which returns 0 for contracts in
104         // construction, since the code is only stored at the end of the
105         // constructor execution.
106 
107         uint256 size;
108         assembly {
109             size := extcodesize(account)
110         }
111         return size > 0;
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         (bool success, ) = recipient.call{value: amount}("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     /**
138      * @dev Performs a Solidity function call using a low level `call`. A
139      * plain `call` is an unsafe replacement for a function call: use this
140      * function instead.
141      *
142      * If `target` reverts with a revert reason, it is bubbled up by this
143      * function (like regular Solidity function calls).
144      *
145      * Returns the raw returned data. To convert to the expected return value,
146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
147      *
148      * Requirements:
149      *
150      * - `target` must be a contract.
151      * - calling `target` with `data` must not revert.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
161      * `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but also transferring `value` wei to `target`.
176      *
177      * Requirements:
178      *
179      * - the calling contract must have an ETH balance of at least `value`.
180      * - the called Solidity function must be `payable`.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(address(this).balance >= value, "Address: insufficient balance for call");
205         require(isContract(target), "Address: call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.call{value: value}(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
218         return functionStaticCall(target, data, "Address: low-level static call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal view returns (bytes memory) {
232         require(isContract(target), "Address: static call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.staticcall(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(isContract(target), "Address: delegate call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.delegatecall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
267      * revert reason using the provided one.
268      *
269      * _Available since v4.3._
270      */
271     function verifyCallResult(
272         bool success,
273         bytes memory returndata,
274         string memory errorMessage
275     ) internal pure returns (bytes memory) {
276         if (success) {
277             return returndata;
278         } else {
279             // Look for revert reason and bubble it up if present
280             if (returndata.length > 0) {
281                 // The easiest way to bubble the revert reason is using memory via assembly
282 
283                 assembly {
284                     let returndata_size := mload(returndata)
285                     revert(add(32, returndata), returndata_size)
286                 }
287             } else {
288                 revert(errorMessage);
289             }
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts@4.3.1/token/ERC721/IERC721Receiver.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 // File: @openzeppelin/contracts@4.3.1/utils/introspection/IERC165.sol
324 
325 
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Interface of the ERC165 standard, as defined in the
331  * https://eips.ethereum.org/EIPS/eip-165[EIP].
332  *
333  * Implementers can declare support of contract interfaces, which can then be
334  * queried by others ({ERC165Checker}).
335  *
336  * For an implementation, see {ERC165}.
337  */
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 // File: @openzeppelin/contracts@4.3.1/utils/introspection/ERC165.sol
351 
352 
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts@4.3.1/token/ERC721/IERC721.sol
381 
382 
383 
384 pragma solidity ^0.8.0;
385 
386 
387 /**
388  * @dev Required interface of an ERC721 compliant contract.
389  */
390 interface IERC721 is IERC165 {
391     /**
392      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
393      */
394     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
398      */
399     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
403      */
404     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
405 
406     /**
407      * @dev Returns the number of tokens in ``owner``'s account.
408      */
409     function balanceOf(address owner) external view returns (uint256 balance);
410 
411     /**
412      * @dev Returns the owner of the `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function ownerOf(uint256 tokenId) external view returns (address owner);
419 
420     /**
421      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
422      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must exist and be owned by `from`.
429      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
431      *
432      * Emits a {Transfer} event.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Transfers `tokenId` token from `from` to `to`.
442      *
443      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must be owned by `from`.
450      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transferFrom(
455         address from,
456         address to,
457         uint256 tokenId
458     ) external;
459 
460     /**
461      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
462      * The approval is cleared when the token is transferred.
463      *
464      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
465      *
466      * Requirements:
467      *
468      * - The caller must own the token or be an approved operator.
469      * - `tokenId` must exist.
470      *
471      * Emits an {Approval} event.
472      */
473     function approve(address to, uint256 tokenId) external;
474 
475     /**
476      * @dev Returns the account approved for `tokenId` token.
477      *
478      * Requirements:
479      *
480      * - `tokenId` must exist.
481      */
482     function getApproved(uint256 tokenId) external view returns (address operator);
483 
484     /**
485      * @dev Approve or remove `operator` as an operator for the caller.
486      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
487      *
488      * Requirements:
489      *
490      * - The `operator` cannot be the caller.
491      *
492      * Emits an {ApprovalForAll} event.
493      */
494     function setApprovalForAll(address operator, bool _approved) external;
495 
496     /**
497      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
498      *
499      * See {setApprovalForAll}
500      */
501     function isApprovedForAll(address owner, address operator) external view returns (bool);
502 
503     /**
504      * @dev Safely transfers `tokenId` token from `from` to `to`.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must exist and be owned by `from`.
511      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
513      *
514      * Emits a {Transfer} event.
515      */
516     function safeTransferFrom(
517         address from,
518         address to,
519         uint256 tokenId,
520         bytes calldata data
521     ) external;
522 }
523 
524 // File: @openzeppelin/contracts@4.3.1/token/ERC721/extensions/IERC721Enumerable.sol
525 
526 
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
533  * @dev See https://eips.ethereum.org/EIPS/eip-721
534  */
535 interface IERC721Enumerable is IERC721 {
536     /**
537      * @dev Returns the total amount of tokens stored by the contract.
538      */
539     function totalSupply() external view returns (uint256);
540 
541     /**
542      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
543      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
544      */
545     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
546 
547     /**
548      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
549      * Use along with {totalSupply} to enumerate all tokens.
550      */
551     function tokenByIndex(uint256 index) external view returns (uint256);
552 }
553 
554 // File: @openzeppelin/contracts@4.3.1/token/ERC721/extensions/IERC721Metadata.sol
555 
556 
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
563  * @dev See https://eips.ethereum.org/EIPS/eip-721
564  */
565 interface IERC721Metadata is IERC721 {
566     /**
567      * @dev Returns the token collection name.
568      */
569     function name() external view returns (string memory);
570 
571     /**
572      * @dev Returns the token collection symbol.
573      */
574     function symbol() external view returns (string memory);
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) external view returns (string memory);
580 }
581 
582 // File: @openzeppelin/contracts@4.3.1/utils/Context.sol
583 
584 
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Provides information about the current execution context, including the
590  * sender of the transaction and its data. While these are generally available
591  * via msg.sender and msg.data, they should not be accessed in such a direct
592  * manner, since when dealing with meta-transactions the account sending and
593  * paying for execution may not be the actual sender (as far as an application
594  * is concerned).
595  *
596  * This contract is only required for intermediate, library-like contracts.
597  */
598 abstract contract Context {
599     function _msgSender() internal view virtual returns (address) {
600         return msg.sender;
601     }
602 
603     function _msgData() internal view virtual returns (bytes calldata) {
604         return msg.data;
605     }
606 }
607 
608 // File: @openzeppelin/contracts@4.3.1/token/ERC721/ERC721.sol
609 
610 
611 
612 pragma solidity ^0.8.0;
613 
614 
615 
616 
617 
618 
619 
620 
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata extension, but not including the Enumerable extension, which is available separately as
624  * {ERC721Enumerable}.
625  */
626 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
627     using Address for address;
628     using Strings for uint256;
629 
630     // Token name
631     string private _name;
632 
633     // Token symbol
634     string private _symbol;
635 
636     // Mapping from token ID to owner address
637     mapping(uint256 => address) private _owners;
638 
639     // Mapping owner address to token count
640     mapping(address => uint256) private _balances;
641 
642     // Mapping from token ID to approved address
643     mapping(uint256 => address) private _tokenApprovals;
644 
645     // Mapping from owner to operator approvals
646     mapping(address => mapping(address => bool)) private _operatorApprovals;
647 
648     /**
649      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
650      */
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654     }
655 
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
660         return
661             interfaceId == type(IERC721).interfaceId ||
662             interfaceId == type(IERC721Metadata).interfaceId ||
663             super.supportsInterface(interfaceId);
664     }
665 
666     /**
667      * @dev See {IERC721-balanceOf}.
668      */
669     function balanceOf(address owner) public view virtual override returns (uint256) {
670         require(owner != address(0), "ERC721: balance query for the zero address");
671         return _balances[owner];
672     }
673 
674     /**
675      * @dev See {IERC721-ownerOf}.
676      */
677     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
678         address owner = _owners[tokenId];
679         require(owner != address(0), "ERC721: owner query for nonexistent token");
680         return owner;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-name}.
685      */
686     function name() public view virtual override returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-symbol}.
692      */
693     function symbol() public view virtual override returns (string memory) {
694         return _symbol;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-tokenURI}.
699      */
700     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
701         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
702 
703         string memory baseURI = _baseURI();
704         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
705     }
706 
707     /**
708      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
709      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
710      * by default, can be overriden in child contracts.
711      */
712     function _baseURI() internal view virtual returns (string memory) {
713         return "";
714     }
715 
716     /**
717      * @dev See {IERC721-approve}.
718      */
719     function approve(address to, uint256 tokenId) public virtual override {
720         address owner = ERC721.ownerOf(tokenId);
721         require(to != owner, "ERC721: approval to current owner");
722 
723         require(
724             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
725             "ERC721: approve caller is not owner nor approved for all"
726         );
727 
728         _approve(to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-getApproved}.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
736 
737         return _tokenApprovals[tokenId];
738     }
739 
740     /**
741      * @dev See {IERC721-setApprovalForAll}.
742      */
743     function setApprovalForAll(address operator, bool approved) public virtual override {
744         require(operator != _msgSender(), "ERC721: approve to caller");
745 
746         _operatorApprovals[_msgSender()][operator] = approved;
747         emit ApprovalForAll(_msgSender(), operator, approved);
748     }
749 
750     /**
751      * @dev See {IERC721-isApprovedForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
754         return _operatorApprovals[owner][operator];
755     }
756 
757     /**
758      * @dev See {IERC721-transferFrom}.
759      */
760     function transferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) public virtual override {
765         //solhint-disable-next-line max-line-length
766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
767 
768         _transfer(from, to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-safeTransferFrom}.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         safeTransferFrom(from, to, tokenId, "");
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) public virtual override {
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792         _safeTransfer(from, to, tokenId, _data);
793     }
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
800      *
801      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
802      * implement alternative mechanisms to perform token transfer, such as signature-based.
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must exist and be owned by `from`.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeTransfer(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) internal virtual {
819         _transfer(from, to, tokenId);
820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822 
823     /**
824      * @dev Returns whether `tokenId` exists.
825      *
826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
827      *
828      * Tokens start existing when they are minted (`_mint`),
829      * and stop existing when they are burned (`_burn`).
830      */
831     function _exists(uint256 tokenId) internal view virtual returns (bool) {
832         return _owners[tokenId] != address(0);
833     }
834 
835     /**
836      * @dev Returns whether `spender` is allowed to manage `tokenId`.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
843         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
844         address owner = ERC721.ownerOf(tokenId);
845         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
846     }
847 
848     /**
849      * @dev Safely mints `tokenId` and transfers it to `to`.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must not exist.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _safeMint(address to, uint256 tokenId) internal virtual {
859         _safeMint(to, tokenId, "");
860     }
861 
862     /**
863      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
864      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
865      */
866     function _safeMint(
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) internal virtual {
871         _mint(to, tokenId);
872         require(
873             _checkOnERC721Received(address(0), to, tokenId, _data),
874             "ERC721: transfer to non ERC721Receiver implementer"
875         );
876     }
877 
878     /**
879      * @dev Mints `tokenId` and transfers it to `to`.
880      *
881      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - `to` cannot be the zero address.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _mint(address to, uint256 tokenId) internal virtual {
891         require(to != address(0), "ERC721: mint to the zero address");
892         require(!_exists(tokenId), "ERC721: token already minted");
893 
894         _beforeTokenTransfer(address(0), to, tokenId);
895 
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(address(0), to, tokenId);
900     }
901 
902     /**
903      * @dev Destroys `tokenId`.
904      * The approval is cleared when the token is burned.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _burn(uint256 tokenId) internal virtual {
913         address owner = ERC721.ownerOf(tokenId);
914 
915         _beforeTokenTransfer(owner, address(0), tokenId);
916 
917         // Clear approvals
918         _approve(address(0), tokenId);
919 
920         _balances[owner] -= 1;
921         delete _owners[tokenId];
922 
923         emit Transfer(owner, address(0), tokenId);
924     }
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _transfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {
942         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
943         require(to != address(0), "ERC721: transfer to the zero address");
944 
945         _beforeTokenTransfer(from, to, tokenId);
946 
947         // Clear approvals from the previous owner
948         _approve(address(0), tokenId);
949 
950         _balances[from] -= 1;
951         _balances[to] += 1;
952         _owners[tokenId] = to;
953 
954         emit Transfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev Approve `to` to operate on `tokenId`
959      *
960      * Emits a {Approval} event.
961      */
962     function _approve(address to, uint256 tokenId) internal virtual {
963         _tokenApprovals[tokenId] = to;
964         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
965     }
966 
967     /**
968      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
969      * The call is not executed if the target address is not a contract.
970      *
971      * @param from address representing the previous owner of the given token ID
972      * @param to target address that will receive the tokens
973      * @param tokenId uint256 ID of the token to be transferred
974      * @param _data bytes optional data to send along with the call
975      * @return bool whether the call correctly returned the expected magic value
976      */
977     function _checkOnERC721Received(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) private returns (bool) {
983         if (to.isContract()) {
984             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
985                 return retval == IERC721Receiver.onERC721Received.selector;
986             } catch (bytes memory reason) {
987                 if (reason.length == 0) {
988                     revert("ERC721: transfer to non ERC721Receiver implementer");
989                 } else {
990                     assembly {
991                         revert(add(32, reason), mload(reason))
992                     }
993                 }
994             }
995         } else {
996             return true;
997         }
998     }
999 
1000     /**
1001      * @dev Hook that is called before any token transfer. This includes minting
1002      * and burning.
1003      *
1004      * Calling conditions:
1005      *
1006      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1007      * transferred to `to`.
1008      * - When `from` is zero, `tokenId` will be minted for `to`.
1009      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1010      * - `from` and `to` are never both zero.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _beforeTokenTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual {}
1019 }
1020 
1021 // File: @openzeppelin/contracts@4.3.1/token/ERC721/extensions/ERC721Enumerable.sol
1022 
1023 
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 
1029 /**
1030  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1031  * enumerability of all the token ids in the contract as well as all token ids owned by each
1032  * account.
1033  */
1034 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1035     // Mapping from owner to list of owned token IDs
1036     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1037 
1038     // Mapping from token ID to index of the owner tokens list
1039     mapping(uint256 => uint256) private _ownedTokensIndex;
1040 
1041     // Array with all token ids, used for enumeration
1042     uint256[] private _allTokens;
1043 
1044     // Mapping from token id to position in the allTokens array
1045     mapping(uint256 => uint256) private _allTokensIndex;
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1051         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1056      */
1057     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1058         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1059         return _ownedTokens[owner][index];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Enumerable-totalSupply}.
1064      */
1065     function totalSupply() public view virtual override returns (uint256) {
1066         return _allTokens.length;
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Enumerable-tokenByIndex}.
1071      */
1072     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1073         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1074         return _allTokens[index];
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before any token transfer. This includes minting
1079      * and burning.
1080      *
1081      * Calling conditions:
1082      *
1083      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1084      * transferred to `to`.
1085      * - When `from` is zero, `tokenId` will be minted for `to`.
1086      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual override {
1097         super._beforeTokenTransfer(from, to, tokenId);
1098 
1099         if (from == address(0)) {
1100             _addTokenToAllTokensEnumeration(tokenId);
1101         } else if (from != to) {
1102             _removeTokenFromOwnerEnumeration(from, tokenId);
1103         }
1104         if (to == address(0)) {
1105             _removeTokenFromAllTokensEnumeration(tokenId);
1106         } else if (to != from) {
1107             _addTokenToOwnerEnumeration(to, tokenId);
1108         }
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1113      * @param to address representing the new owner of the given token ID
1114      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1115      */
1116     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1117         uint256 length = ERC721.balanceOf(to);
1118         _ownedTokens[to][length] = tokenId;
1119         _ownedTokensIndex[tokenId] = length;
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's token tracking data structures.
1124      * @param tokenId uint256 ID of the token to be added to the tokens list
1125      */
1126     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1127         _allTokensIndex[tokenId] = _allTokens.length;
1128         _allTokens.push(tokenId);
1129     }
1130 
1131     /**
1132      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1133      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1134      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1135      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1136      * @param from address representing the previous owner of the given token ID
1137      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1138      */
1139     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1140         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1141         // then delete the last slot (swap and pop).
1142 
1143         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1144         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1145 
1146         // When the token to delete is the last token, the swap operation is unnecessary
1147         if (tokenIndex != lastTokenIndex) {
1148             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1149 
1150             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1151             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1152         }
1153 
1154         // This also deletes the contents at the last position of the array
1155         delete _ownedTokensIndex[tokenId];
1156         delete _ownedTokens[from][lastTokenIndex];
1157     }
1158 
1159     /**
1160      * @dev Private function to remove a token from this extension's token tracking data structures.
1161      * This has O(1) time complexity, but alters the order of the _allTokens array.
1162      * @param tokenId uint256 ID of the token to be removed from the tokens list
1163      */
1164     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1165         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1166         // then delete the last slot (swap and pop).
1167 
1168         uint256 lastTokenIndex = _allTokens.length - 1;
1169         uint256 tokenIndex = _allTokensIndex[tokenId];
1170 
1171         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1172         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1173         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1174         uint256 lastTokenId = _allTokens[lastTokenIndex];
1175 
1176         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1177         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1178 
1179         // This also deletes the contents at the last position of the array
1180         delete _allTokensIndex[tokenId];
1181         _allTokens.pop();
1182     }
1183 }
1184 
1185 // File: @openzeppelin/contracts@4.3.1/access/Ownable.sol
1186 
1187 
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 
1192 /**
1193  * @dev Contract module which provides a basic access control mechanism, where
1194  * there is an account (an owner) that can be granted exclusive access to
1195  * specific functions.
1196  *
1197  * By default, the owner account will be the one that deploys the contract. This
1198  * can later be changed with {transferOwnership}.
1199  *
1200  * This module is used through inheritance. It will make available the modifier
1201  * `onlyOwner`, which can be applied to your functions to restrict their use to
1202  * the owner.
1203  */
1204 abstract contract Ownable is Context {
1205     address private _owner;
1206 
1207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1208 
1209     /**
1210      * @dev Initializes the contract setting the deployer as the initial owner.
1211      */
1212     constructor() {
1213         _setOwner(_msgSender());
1214     }
1215 
1216     /**
1217      * @dev Returns the address of the current owner.
1218      */
1219     function owner() public view virtual returns (address) {
1220         return _owner;
1221     }
1222 
1223     /**
1224      * @dev Throws if called by any account other than the owner.
1225      */
1226     modifier onlyOwner() {
1227         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1228         _;
1229     }
1230 
1231     /**
1232      * @dev Leaves the contract without owner. It will not be possible to call
1233      * `onlyOwner` functions anymore. Can only be called by the current owner.
1234      *
1235      * NOTE: Renouncing ownership will leave the contract without an owner,
1236      * thereby removing any functionality that is only available to the owner.
1237      */
1238     function renounceOwnership() public virtual onlyOwner {
1239         _setOwner(address(0));
1240     }
1241 
1242     /**
1243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1244      * Can only be called by the current owner.
1245      */
1246     function transferOwnership(address newOwner) public virtual onlyOwner {
1247         require(newOwner != address(0), "Ownable: new owner is the zero address");
1248         _setOwner(newOwner);
1249     }
1250 
1251     function _setOwner(address newOwner) private {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 
1258 // File: etholvants.sol
1259 
1260 
1261 
1262 // MTI4
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 
1267 
1268 contract Etholvants is ERC721Enumerable, Ownable {
1269     uint256 public constant MAX_SUPPLY = 10000;
1270     uint256 public constant MINT_COST = 0.024 ether;
1271     uint256 public constant MAX_MINT_PER_TX = 14;
1272     uint256 public constant BASE_GROWTH_RATE = 2;
1273     uint256 public nextId = 0;
1274     uint256 public initMintCount = 0;
1275     uint256 public burnedWithCombine = 0;
1276     uint256 public totalStaked = 0;
1277     address public injectionContract = address(0);
1278     bool public injectionContractLocked = false;
1279     bool public mintPaused = false;
1280     string private _baseUriStr = "";
1281     mapping(uint256 => bytes32) public tokenToSeed;
1282     mapping(uint256 => uint256) private tokenToNumCells;
1283     mapping(uint256 => address) public tokenToStaker;
1284     mapping(uint256 => uint256) public tokenToStakeTime;
1285     mapping(address => uint256[]) public stakerToTokens;
1286     mapping(uint256 => uint256) public tokenToGrowthBoost;
1287 
1288     constructor() ERC721("Etholvants", "ETHOL") {}
1289 
1290     function _baseURI() internal view virtual override returns (string memory) {
1291         return _baseUriStr;
1292     }
1293 
1294     function setBaseURI(string memory baseUri) external onlyOwner {
1295         _baseUriStr = baseUri;
1296     }
1297 
1298     function togglePause() external onlyOwner {
1299         mintPaused = !mintPaused;
1300     }
1301 
1302     function setInjectionContract(address contractAddr) external onlyOwner {
1303         require(!injectionContractLocked, "Locked!");
1304         injectionContract = contractAddr;
1305     }
1306 
1307     function lockInjectionContract() external onlyOwner {
1308         injectionContractLocked = true;
1309     }
1310 
1311     function injectBooster(uint256 tokenId, uint256 boostAmount) external {
1312         require(msg.sender == injectionContract);
1313         tokenToGrowthBoost[tokenId] += boostAmount;
1314     }
1315 
1316     function getRealOwner(uint tokenId) public view returns (address) {
1317         if (tokenToStaker[tokenId] != address(0)) {
1318             return tokenToStaker[tokenId];
1319         }
1320         return ownerOf(tokenId);
1321     }
1322 
1323     function _sqrt(uint256 x) internal pure returns (uint256 y) {
1324         uint256 z = (x + 1) / 2;
1325         y = x;
1326         while (z < y) {
1327             y = z;
1328             z = (x / z + z) / 2;
1329         }
1330     }
1331 
1332     function onERC721Received(
1333         address operator,
1334         address from,
1335         uint256 tokenId,
1336         bytes calldata data
1337     ) external returns (bytes4) {
1338         return
1339             bytes4(
1340                 keccak256("onERC721Received(address,address,uint256,bytes)")
1341             );
1342     }
1343 
1344     function stake(uint256[] memory tokenIds) external {
1345         address staker = msg.sender;
1346         for (uint256 i = 0; i < tokenIds.length; i++) {
1347             require(ownerOf(tokenIds[i]) == staker, "permission denied");
1348         }
1349 
1350         for (uint256 i = 0; i < tokenIds.length; i++) {
1351             uint256 tokenId = tokenIds[i];
1352             tokenToStaker[tokenId] = staker;
1353             tokenToStakeTime[tokenId] = block.timestamp;
1354             stakerToTokens[staker].push(tokenId);
1355             safeTransferFrom(staker, address(this), tokenId);
1356             totalStaked += 1;
1357         }
1358     }
1359 
1360     function unstake(uint256[] memory tokenIds) external payable {
1361         require(msg.value == 0.01 ether, "unstaking fee is 0.01 ETH");
1362         address staker = msg.sender;
1363         for (uint256 i = 0; i < tokenIds.length; i++) {
1364             require(tokenToStaker[tokenIds[i]] == staker, "permission denied");
1365         }
1366 
1367         for (uint256 i = 0; i < tokenIds.length; i++) {
1368             uint256 tokenId = tokenIds[i];
1369             tokenToStaker[tokenId] = address(0);
1370             tokenToNumCells[tokenId] +=
1371                 ((block.timestamp - tokenToStakeTime[tokenId]) / 14400) *
1372                 (BASE_GROWTH_RATE + tokenToGrowthBoost[tokenId]);
1373             tokenToStakeTime[tokenId] = 0;
1374             _removeFromStakedList(staker, tokenId);
1375             _transfer(address(this), staker, tokenId);
1376             totalStaked -= 1;
1377         }
1378     }
1379 
1380     function _removeFromStakedList(address staker, uint256 tokenId) internal {
1381         for (uint256 i = 0; i < stakerToTokens[staker].length; i++) {
1382             if (stakerToTokens[staker][i] == tokenId) {
1383                 for (
1384                     uint256 j = i;
1385                     j < stakerToTokens[staker].length - 1;
1386                     j++
1387                 ) {
1388                     stakerToTokens[staker][j] = stakerToTokens[staker][j + 1];
1389                 }
1390                 stakerToTokens[staker].pop();
1391                 break;
1392             }
1393         }
1394     }
1395 
1396     function getStakedTokens(address staker)
1397         public
1398         view
1399         returns (uint256[] memory)
1400     {
1401         return stakerToTokens[staker];
1402     }
1403 
1404     function stakedTokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1405         require(index < stakerToTokens[owner].length, "index out of bounds");
1406         return stakerToTokens[owner][index];
1407     }
1408 
1409     function getTokensOfOwner(address owner) public view returns (uint[] memory) {
1410         uint size = balanceOf(owner);
1411         uint[] memory tokens = new uint[](size);
1412         for (uint i=0; i<size; i++) {
1413             tokens[i] = tokenOfOwnerByIndex(owner, i);
1414         }
1415         return tokens;
1416     }
1417 
1418     function combine(uint256[] memory tokenIds) external {
1419         require(tokenIds.length > 1, "you should provide more than 1 token");
1420         uint256 numCells = 0;
1421         uint maxGrowthBoost = 0;
1422         for (uint256 i = 0; i < tokenIds.length; i++) {
1423             require(ownerOf(tokenIds[i]) == msg.sender, "permission denied");
1424             numCells += tokenToNumCells[tokenIds[i]];
1425             _burn(tokenIds[i]);
1426             burnedWithCombine += 1;
1427             if (tokenToGrowthBoost[tokenIds[i]] > maxGrowthBoost) {
1428                 maxGrowthBoost = tokenToGrowthBoost[tokenIds[i]];
1429             }
1430         }
1431         bytes32 seed = keccak256(
1432             abi.encodePacked(tokenToSeed[tokenIds[0]], tokenToSeed[tokenIds[1]])
1433         );
1434         for (uint256 i = 2; i < tokenIds.length; i++) {
1435             seed = keccak256(abi.encodePacked(seed, tokenToSeed[tokenIds[i]]));
1436         }
1437         uint256 tokenId = nextId;
1438         tokenToNumCells[tokenId] = numCells;
1439         tokenToSeed[tokenId] = seed;
1440         tokenToGrowthBoost[tokenId] = maxGrowthBoost;
1441         _safeMint(msg.sender, tokenId);
1442         nextId += 1;
1443     }
1444 
1445     function withdraw() external onlyOwner {
1446         payable(owner()).transfer(address(this).balance);
1447     }
1448 
1449     function getNumCells(uint256 tokenId) public view returns (uint256) {
1450         uint256 numCells = tokenToNumCells[tokenId];
1451         if (tokenToStaker[tokenId] == address(0)) {
1452             return numCells;
1453         }
1454         return
1455             numCells +
1456             ((block.timestamp - tokenToStakeTime[tokenId]) / 14400) *
1457             (BASE_GROWTH_RATE + tokenToGrowthBoost[tokenId]);
1458     }
1459 
1460     // size = width = height
1461     function getSize(uint256 numCells) public pure returns (uint256) {
1462         uint256 size = (_sqrt((numCells / 7) * 10) / 2) * 2;
1463         if (size < 8) {
1464             size = 8;
1465         }
1466         return size;
1467     }
1468 
1469     function getTokenData(uint256 tokenId)
1470         public
1471         view
1472         returns (
1473             bytes32,
1474             uint256,
1475             uint256,
1476             uint256
1477         )
1478     {
1479         bytes32 seed = tokenToSeed[tokenId];
1480         uint256 numCells = getNumCells(tokenId);
1481         uint256 size = getSize(numCells);
1482         uint256 growthRate = BASE_GROWTH_RATE + tokenToGrowthBoost[tokenId];
1483         return (seed, numCells, size, growthRate);
1484     }
1485 
1486     function getStats() public view returns (uint256, uint256, uint256, uint256) {
1487         return (initMintCount, totalStaked, burnedWithCombine, totalSupply());
1488     }
1489 
1490     function mint(uint256 quantity) external payable {
1491         require(quantity <= MAX_MINT_PER_TX, "max mint per tx exceeded");
1492         require(!mintPaused, "minting paused");
1493         require(quantity > 0, "min mint per tx is 1");
1494         require(msg.value == quantity * MINT_COST, "incorrect ether value");
1495         require(initMintCount + quantity <= MAX_SUPPLY, "max supply exceeded");
1496         for (uint256 i = 0; i < quantity; i++) {
1497             uint256 tokenId = nextId + i;
1498             tokenToNumCells[tokenId] = 24;
1499             tokenToSeed[tokenId] = keccak256(
1500                 abi.encodePacked(
1501                     msg.sender,
1502                     tokenId,
1503                     block.difficulty,
1504                     block.timestamp
1505                 )
1506             );
1507             _safeMint(msg.sender, tokenId);
1508         }
1509         nextId += quantity;
1510         initMintCount += quantity;
1511     }
1512 
1513     function getCellPositionsCustom(
1514         bytes32 seed,
1515         uint256 numCells,
1516         uint256 width,
1517         uint256 height,
1518         uint256 cursor,
1519         uint256 limit
1520     ) public pure returns (uint256, uint256[] memory) {
1521         require(limit % 2 == 0, "limit should be an even number");
1522         uint256 index = cursor >> 128;
1523         uint256 lastPixel = cursor & ((1 << 128) - 1);
1524 
1525         if (index + limit > numCells) {
1526             limit = numCells - index;
1527         }
1528 
1529         uint256[] memory pixels = new uint256[](limit);
1530         uint256 x;
1531         uint256 y;
1532         uint256 i = index;
1533         if (index == 0) {
1534             x = width / 2;
1535             y = height / 2;
1536             pixels[0] = y * width + x;
1537             pixels[1] = y * width + width - 1 - x;
1538             i = 2;
1539         } else {
1540             y = lastPixel / width;
1541             x = lastPixel % width;
1542         }
1543         for (; i <= numCells; i += 2) {
1544             if (i == index + limit) {
1545                 break;
1546             }
1547             uint256 r;
1548             r = uint256(keccak256(abi.encodePacked(seed, i))) % 7;
1549             if (r >= 4) {
1550                 x = (x + 1) % width;
1551             } else if (r >= 1) {
1552                 x = x > 0 ? x - 1 : width - 1;
1553             }
1554             r = uint256(keccak256(abi.encodePacked(seed, i + 1))) % 7;
1555             if (r >= 4) {
1556                 y = (y + 1) % height;
1557             } else if (r >= 1) {
1558                 y = y > 0 ? y - 1 : height - 1;
1559             }
1560             pixels[i - index] = y * width + x;
1561             pixels[i + 1 - index] = y * width + width - 1 - x;
1562         }
1563         if (i == numCells) {
1564             cursor = 0;
1565         } else {
1566             cursor = (i << 128) | (y * width + x);
1567         }
1568         return (cursor, pixels);
1569     }
1570     
1571 
1572     /**
1573      * @dev (0, 0) is the top left corner.
1574      * X from left to right, Y from top to bottom.
1575      * Each element in the result list is (y * size + x)
1576      * width = height = size
1577      *
1578      * Result is paginated. cursor will be returend 0 at the end.
1579      */
1580     function getCellPositions(
1581         uint256 tokenId,
1582         uint256 cursor,
1583         uint256 limit
1584     ) public view returns (uint256, uint256[] memory) {
1585         bytes32 seed = tokenToSeed[tokenId];
1586         uint256 numCells = getNumCells(tokenId);
1587         uint256 size = getSize(numCells);
1588         return getCellPositionsCustom(seed, numCells, size, size, cursor, limit);
1589     }
1590 }