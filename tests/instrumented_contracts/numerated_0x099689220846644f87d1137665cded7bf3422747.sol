1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 
203 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
204 
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 
230 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
231 
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies on extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return _verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     function _verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) private pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
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
442 
443 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
444 
445 
446 pragma solidity ^0.8.0;
447 
448 /*
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         return msg.data;
465     }
466 }
467 
468 
469 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
470 
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev String operations.
476  */
477 library Strings {
478     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
482      */
483     function toString(uint256 value) internal pure returns (string memory) {
484         // Inspired by OraclizeAPI's implementation - MIT licence
485         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
486 
487         if (value == 0) {
488             return "0";
489         }
490         uint256 temp = value;
491         uint256 digits;
492         while (temp != 0) {
493             digits++;
494             temp /= 10;
495         }
496         bytes memory buffer = new bytes(digits);
497         while (value != 0) {
498             digits -= 1;
499             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
500             value /= 10;
501         }
502         return string(buffer);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
507      */
508     function toHexString(uint256 value) internal pure returns (string memory) {
509         if (value == 0) {
510             return "0x00";
511         }
512         uint256 temp = value;
513         uint256 length = 0;
514         while (temp != 0) {
515             length++;
516             temp >>= 8;
517         }
518         return toHexString(value, length);
519     }
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
523      */
524     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
525         bytes memory buffer = new bytes(2 * length + 2);
526         buffer[0] = "0";
527         buffer[1] = "x";
528         for (uint256 i = 2 * length + 1; i > 1; --i) {
529             buffer[i] = _HEX_SYMBOLS[value & 0xf];
530             value >>= 4;
531         }
532         require(value == 0, "Strings: hex length insufficient");
533         return string(buffer);
534     }
535 }
536 
537 
538 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
539 
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
565 
566 
567 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
568 
569 
570 pragma solidity ^0.8.0;
571 
572 
573 
574 
575 
576 
577 
578 /**
579  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
580  * the Metadata extension, but not including the Enumerable extension, which is available separately as
581  * {ERC721Enumerable}.
582  */
583 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
584     using Address for address;
585     using Strings for uint256;
586 
587     // Token name
588     string private _name;
589 
590     // Token symbol
591     string private _symbol;
592 
593     // Mapping from token ID to owner address
594     mapping(uint256 => address) private _owners;
595 
596     // Mapping owner address to token count
597     mapping(address => uint256) private _balances;
598 
599     // Mapping from token ID to approved address
600     mapping(uint256 => address) private _tokenApprovals;
601 
602     // Mapping from owner to operator approvals
603     mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605     /**
606      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
607      */
608     constructor(string memory name_, string memory symbol_) {
609         _name = name_;
610         _symbol = symbol_;
611     }
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
617         return
618             interfaceId == type(IERC721).interfaceId ||
619             interfaceId == type(IERC721Metadata).interfaceId ||
620             super.supportsInterface(interfaceId);
621     }
622 
623     /**
624      * @dev See {IERC721-balanceOf}.
625      */
626     function balanceOf(address owner) public view virtual override returns (uint256) {
627         require(owner != address(0), "ERC721: balance query for the zero address");
628         return _balances[owner];
629     }
630 
631     /**
632      * @dev See {IERC721-ownerOf}.
633      */
634     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
635         address owner = _owners[tokenId];
636         require(owner != address(0), "ERC721: owner query for nonexistent token");
637         return owner;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-name}.
642      */
643     function name() public view virtual override returns (string memory) {
644         return _name;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-symbol}.
649      */
650     function symbol() public view virtual override returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-tokenURI}.
656      */
657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
658         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
659 
660         string memory baseURI = _baseURI();
661         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
662     }
663 
664     /**
665      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
666      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
667      * by default, can be overriden in child contracts.
668      */
669     function _baseURI() internal view virtual returns (string memory) {
670         return "";
671     }
672 
673     /**
674      * @dev See {IERC721-approve}.
675      */
676     function approve(address to, uint256 tokenId) public virtual override {
677         address owner = ERC721.ownerOf(tokenId);
678         require(to != owner, "ERC721: approval to current owner");
679 
680         require(
681             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
682             "ERC721: approve caller is not owner nor approved for all"
683         );
684 
685         _approve(to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-getApproved}.
690      */
691     function getApproved(uint256 tokenId) public view virtual override returns (address) {
692         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
693 
694         return _tokenApprovals[tokenId];
695     }
696 
697     /**
698      * @dev See {IERC721-setApprovalForAll}.
699      */
700     function setApprovalForAll(address operator, bool approved) public virtual override {
701         require(operator != _msgSender(), "ERC721: approve to caller");
702 
703         _operatorApprovals[_msgSender()][operator] = approved;
704         emit ApprovalForAll(_msgSender(), operator, approved);
705     }
706 
707     /**
708      * @dev See {IERC721-isApprovedForAll}.
709      */
710     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
711         return _operatorApprovals[owner][operator];
712     }
713 
714     /**
715      * @dev See {IERC721-transferFrom}.
716      */
717     function transferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         //solhint-disable-next-line max-line-length
723         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
724 
725         _transfer(from, to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         safeTransferFrom(from, to, tokenId, "");
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId,
746         bytes memory _data
747     ) public virtual override {
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749         _safeTransfer(from, to, tokenId, _data);
750     }
751 
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
754      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
755      *
756      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
757      *
758      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
759      * implement alternative mechanisms to perform token transfer, such as signature-based.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeTransfer(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes memory _data
775     ) internal virtual {
776         _transfer(from, to, tokenId);
777         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
778     }
779 
780     /**
781      * @dev Returns whether `tokenId` exists.
782      *
783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
784      *
785      * Tokens start existing when they are minted (`_mint`),
786      * and stop existing when they are burned (`_burn`).
787      */
788     function _exists(uint256 tokenId) internal view virtual returns (bool) {
789         return _owners[tokenId] != address(0);
790     }
791 
792     /**
793      * @dev Returns whether `spender` is allowed to manage `tokenId`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
800         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
801         address owner = ERC721.ownerOf(tokenId);
802         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
803     }
804 
805     /**
806      * @dev Safely mints `tokenId` and transfers it to `to`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeMint(address to, uint256 tokenId) internal virtual {
816         _safeMint(to, tokenId, "");
817     }
818 
819     /**
820      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
821      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
822      */
823     function _safeMint(
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) internal virtual {
828         _mint(to, tokenId);
829         require(
830             _checkOnERC721Received(address(0), to, tokenId, _data),
831             "ERC721: transfer to non ERC721Receiver implementer"
832         );
833     }
834 
835     /**
836      * @dev Mints `tokenId` and transfers it to `to`.
837      *
838      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - `to` cannot be the zero address.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _mint(address to, uint256 tokenId) internal virtual {
848         require(to != address(0), "ERC721: mint to the zero address");
849         require(!_exists(tokenId), "ERC721: token already minted");
850 
851         _beforeTokenTransfer(address(0), to, tokenId);
852 
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(address(0), to, tokenId);
857     }
858 
859     /**
860      * @dev Destroys `tokenId`.
861      * The approval is cleared when the token is burned.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _burn(uint256 tokenId) internal virtual {
870         address owner = ERC721.ownerOf(tokenId);
871 
872         _beforeTokenTransfer(owner, address(0), tokenId);
873 
874         // Clear approvals
875         _approve(address(0), tokenId);
876 
877         _balances[owner] -= 1;
878         delete _owners[tokenId];
879 
880         emit Transfer(owner, address(0), tokenId);
881     }
882 
883     /**
884      * @dev Transfers `tokenId` from `from` to `to`.
885      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
886      *
887      * Requirements:
888      *
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must be owned by `from`.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _transfer(
895         address from,
896         address to,
897         uint256 tokenId
898     ) internal virtual {
899         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
900         require(to != address(0), "ERC721: transfer to the zero address");
901 
902         _beforeTokenTransfer(from, to, tokenId);
903 
904         // Clear approvals from the previous owner
905         _approve(address(0), tokenId);
906 
907         _balances[from] -= 1;
908         _balances[to] += 1;
909         _owners[tokenId] = to;
910 
911         emit Transfer(from, to, tokenId);
912     }
913 
914     /**
915      * @dev Approve `to` to operate on `tokenId`
916      *
917      * Emits a {Approval} event.
918      */
919     function _approve(address to, uint256 tokenId) internal virtual {
920         _tokenApprovals[tokenId] = to;
921         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
922     }
923 
924     /**
925      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
926      * The call is not executed if the target address is not a contract.
927      *
928      * @param from address representing the previous owner of the given token ID
929      * @param to target address that will receive the tokens
930      * @param tokenId uint256 ID of the token to be transferred
931      * @param _data bytes optional data to send along with the call
932      * @return bool whether the call correctly returned the expected magic value
933      */
934     function _checkOnERC721Received(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) private returns (bool) {
940         if (to.isContract()) {
941             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
942                 return retval == IERC721Receiver(to).onERC721Received.selector;
943             } catch (bytes memory reason) {
944                 if (reason.length == 0) {
945                     revert("ERC721: transfer to non ERC721Receiver implementer");
946                 } else {
947                     assembly {
948                         revert(add(32, reason), mload(reason))
949                     }
950                 }
951             }
952         } else {
953             return true;
954         }
955     }
956 
957     /**
958      * @dev Hook that is called before any token transfer. This includes minting
959      * and burning.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` will be minted for `to`.
966      * - When `to` is zero, ``from``'s `tokenId` will be burned.
967      * - `from` and `to` are never both zero.
968      *
969      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
970      */
971     function _beforeTokenTransfer(
972         address from,
973         address to,
974         uint256 tokenId
975     ) internal virtual {}
976 }
977 
978 
979 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
980 
981 
982 pragma solidity ^0.8.0;
983 
984 /**
985  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
986  * @dev See https://eips.ethereum.org/EIPS/eip-721
987  */
988 interface IERC721Enumerable is IERC721 {
989     /**
990      * @dev Returns the total amount of tokens stored by the contract.
991      */
992     function totalSupply() external view returns (uint256);
993 
994     /**
995      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
996      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
997      */
998     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
999 
1000     /**
1001      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1002      * Use along with {totalSupply} to enumerate all tokens.
1003      */
1004     function tokenByIndex(uint256 index) external view returns (uint256);
1005 }
1006 
1007 
1008 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1009 
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1016  * enumerability of all the token ids in the contract as well as all token ids owned by each
1017  * account.
1018  */
1019 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1020     // Mapping from owner to list of owned token IDs
1021     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1022 
1023     // Mapping from token ID to index of the owner tokens list
1024     mapping(uint256 => uint256) private _ownedTokensIndex;
1025 
1026     // Array with all token ids, used for enumeration
1027     uint256[] private _allTokens;
1028 
1029     // Mapping from token id to position in the allTokens array
1030     mapping(uint256 => uint256) private _allTokensIndex;
1031 
1032     /**
1033      * @dev See {IERC165-supportsInterface}.
1034      */
1035     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1036         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1041      */
1042     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1043         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1044         return _ownedTokens[owner][index];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Enumerable-totalSupply}.
1049      */
1050     function totalSupply() public view virtual override returns (uint256) {
1051         return _allTokens.length;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-tokenByIndex}.
1056      */
1057     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1058         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1059         return _allTokens[index];
1060     }
1061 
1062     /**
1063      * @dev Hook that is called before any token transfer. This includes minting
1064      * and burning.
1065      *
1066      * Calling conditions:
1067      *
1068      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1069      * transferred to `to`.
1070      * - When `from` is zero, `tokenId` will be minted for `to`.
1071      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1072      * - `from` cannot be the zero address.
1073      * - `to` cannot be the zero address.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) internal virtual override {
1082         super._beforeTokenTransfer(from, to, tokenId);
1083 
1084         if (from == address(0)) {
1085             _addTokenToAllTokensEnumeration(tokenId);
1086         } else if (from != to) {
1087             _removeTokenFromOwnerEnumeration(from, tokenId);
1088         }
1089         if (to == address(0)) {
1090             _removeTokenFromAllTokensEnumeration(tokenId);
1091         } else if (to != from) {
1092             _addTokenToOwnerEnumeration(to, tokenId);
1093         }
1094     }
1095 
1096     /**
1097      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1098      * @param to address representing the new owner of the given token ID
1099      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1100      */
1101     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1102         uint256 length = ERC721.balanceOf(to);
1103         _ownedTokens[to][length] = tokenId;
1104         _ownedTokensIndex[tokenId] = length;
1105     }
1106 
1107     /**
1108      * @dev Private function to add a token to this extension's token tracking data structures.
1109      * @param tokenId uint256 ID of the token to be added to the tokens list
1110      */
1111     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1112         _allTokensIndex[tokenId] = _allTokens.length;
1113         _allTokens.push(tokenId);
1114     }
1115 
1116     /**
1117      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1118      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1119      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1120      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1121      * @param from address representing the previous owner of the given token ID
1122      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1123      */
1124     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1125         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1126         // then delete the last slot (swap and pop).
1127 
1128         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1129         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1130 
1131         // When the token to delete is the last token, the swap operation is unnecessary
1132         if (tokenIndex != lastTokenIndex) {
1133             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1134 
1135             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1136             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1137         }
1138 
1139         // This also deletes the contents at the last position of the array
1140         delete _ownedTokensIndex[tokenId];
1141         delete _ownedTokens[from][lastTokenIndex];
1142     }
1143 
1144     /**
1145      * @dev Private function to remove a token from this extension's token tracking data structures.
1146      * This has O(1) time complexity, but alters the order of the _allTokens array.
1147      * @param tokenId uint256 ID of the token to be removed from the tokens list
1148      */
1149     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1150         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1151         // then delete the last slot (swap and pop).
1152 
1153         uint256 lastTokenIndex = _allTokens.length - 1;
1154         uint256 tokenIndex = _allTokensIndex[tokenId];
1155 
1156         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1157         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1158         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1159         uint256 lastTokenId = _allTokens[lastTokenIndex];
1160 
1161         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163 
1164         // This also deletes the contents at the last position of the array
1165         delete _allTokensIndex[tokenId];
1166         _allTokens.pop();
1167     }
1168 }
1169 
1170 
1171 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1172 
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev Contract module which provides a basic access control mechanism, where
1178  * there is an account (an owner) that can be granted exclusive access to
1179  * specific functions.
1180  *
1181  * By default, the owner account will be the one that deploys the contract. This
1182  * can later be changed with {transferOwnership}.
1183  *
1184  * This module is used through inheritance. It will make available the modifier
1185  * `onlyOwner`, which can be applied to your functions to restrict their use to
1186  * the owner.
1187  */
1188 abstract contract Ownable is Context {
1189     address private _owner;
1190 
1191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1192 
1193     /**
1194      * @dev Initializes the contract setting the deployer as the initial owner.
1195      */
1196     constructor() {
1197         _setOwner(_msgSender());
1198     }
1199 
1200     /**
1201      * @dev Returns the address of the current owner.
1202      */
1203     function owner() public view virtual returns (address) {
1204         return _owner;
1205     }
1206 
1207     /**
1208      * @dev Throws if called by any account other than the owner.
1209      */
1210     modifier onlyOwner() {
1211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1212         _;
1213     }
1214 
1215     /**
1216      * @dev Leaves the contract without owner. It will not be possible to call
1217      * `onlyOwner` functions anymore. Can only be called by the current owner.
1218      *
1219      * NOTE: Renouncing ownership will leave the contract without an owner,
1220      * thereby removing any functionality that is only available to the owner.
1221      */
1222     function renounceOwnership() public virtual onlyOwner {
1223         _setOwner(address(0));
1224     }
1225 
1226     /**
1227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1228      * Can only be called by the current owner.
1229      */
1230     function transferOwnership(address newOwner) public virtual onlyOwner {
1231         require(newOwner != address(0), "Ownable: new owner is the zero address");
1232         _setOwner(newOwner);
1233     }
1234 
1235     function _setOwner(address newOwner) private {
1236         address oldOwner = _owner;
1237         _owner = newOwner;
1238         emit OwnershipTransferred(oldOwner, newOwner);
1239     }
1240 }
1241 
1242 
1243 // File contracts/Robotos.sol
1244 
1245 
1246 pragma solidity ^0.8.0;
1247 
1248 
1249 contract Robotos is ERC721Enumerable, Ownable {
1250 
1251     using Strings for uint256;
1252 
1253     string public _baseTokenURI;
1254     uint256 public _price = 0.05 ether;
1255     uint256 public _maxSupply = 9999;
1256     bool public _preSaleIsActive = false;
1257     bool public _saleIsActive = false;
1258 
1259     address a1 = 0x63989a803b61581683B54AB6188ffa0F4bAAdf28;
1260     address a2 = 0x273Dc0347CB3AbA026F8A4704B1E1a81a3647Cf3;
1261     address a3 = 0x81a76401a46FA740c911e374324E4046b84cFA33;
1262 
1263     constructor(string memory baseURI) ERC721("Robotos", "ROBO") {
1264         setBaseURI(baseURI);
1265 
1266         for (uint256 i = 0; i < 36; i++) {
1267             if (i < 16) {
1268                 _safeMint(a1, i);
1269             }
1270             else if (i < 26) {
1271                 _safeMint(a2, i);
1272             }
1273             else if (i < 36) {
1274                 _safeMint(a3, i);
1275             }
1276         }
1277     }
1278 
1279     function preSaleMint() public payable {
1280         uint256 supply = totalSupply();
1281 
1282         require(_preSaleIsActive,                   "presale_not_active");
1283         require(balanceOf(msg.sender) == 0,         "presale_wallet_limit_met");
1284         require(supply < 900,                       "max_token_supply_exceeded");
1285         require(msg.value >= _price,                "insufficient_payment_value");
1286 
1287         _safeMint(msg.sender, supply);
1288     }
1289 
1290     function mint(uint256 mintCount) public payable {
1291         uint256 supply = totalSupply();
1292 
1293         require(_saleIsActive,                      "sale_not_active");
1294         require(mintCount <= 18,                    "max_mint_count_exceeded");
1295         require(supply + mintCount <= _maxSupply,   "max_token_supply_exceeded");
1296         require(msg.value >= _price * mintCount,    "insufficient_payment_value");
1297 
1298         for (uint256 i = 0; i < mintCount; i++) {
1299             _safeMint(msg.sender, supply + i);
1300         }
1301         if (supply + mintCount == _maxSupply) {
1302             withdrawAll();
1303         }
1304     }
1305 
1306     function _baseURI() internal view virtual override returns (string memory) {
1307         return _baseTokenURI;
1308     }
1309 
1310     function setBaseURI(string memory baseURI) public onlyOwner {
1311         _baseTokenURI = baseURI;
1312     }
1313 
1314     function setPrice(uint256 price) public onlyOwner {
1315         _price = price;
1316     }
1317 
1318     function preSaleStart() public onlyOwner {
1319         _preSaleIsActive = true;
1320     }
1321 
1322     function preSaleStop() public onlyOwner {
1323         _preSaleIsActive = false;
1324     }
1325 
1326     function saleStart() public onlyOwner {
1327         _saleIsActive = true;
1328     }
1329 
1330     function saleStop() public onlyOwner {
1331         _saleIsActive = false;
1332     }
1333 
1334     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1335         uint256 tokenCount = balanceOf(owner);
1336         uint256[] memory tokenIds = new uint256[](tokenCount);
1337         for (uint256 i = 0; i < tokenCount; i++) {
1338             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1339         }
1340         return tokenIds;
1341     }
1342 
1343     function withdrawAll() public payable onlyOwner {
1344         uint256 _each = address(this).balance / 3;
1345         require(payable(a1).send(_each));
1346         require(payable(a2).send(_each));
1347         require(payable(a3).send(_each));
1348     }
1349 }