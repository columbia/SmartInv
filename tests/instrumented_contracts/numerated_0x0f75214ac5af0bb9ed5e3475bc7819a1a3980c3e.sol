1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
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
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
173 
174 
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @title ERC721 token receiver interface
180  * @dev Interface for any contract that wants to support safeTransfers
181  * from ERC721 asset contracts.
182  */
183 interface IERC721Receiver {
184     /**
185      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
186      * by `operator` from `from`, this function is called.
187      *
188      * It must return its Solidity selector to confirm the token transfer.
189      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
190      *
191      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
192      */
193     function onERC721Received(
194         address operator,
195         address from,
196         uint256 tokenId,
197         bytes calldata data
198     ) external returns (bytes4);
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
202 
203 
204 
205 pragma solidity ^0.8.0;
206 
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
229 // File: @openzeppelin/contracts/utils/Address.sol
230 
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
442 // File: @openzeppelin/contracts/utils/Context.sol
443 
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
468 // File: @openzeppelin/contracts/utils/Strings.sol
469 
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
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
568 
569 
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 
576 
577 
578 
579 
580 /**
581  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
582  * the Metadata extension, but not including the Enumerable extension, which is available separately as
583  * {ERC721Enumerable}.
584  */
585 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
586     using Address for address;
587     using Strings for uint256;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     // Mapping from token ID to owner address
596     mapping(uint256 => address) private _owners;
597 
598     // Mapping owner address to token count
599     mapping(address => uint256) private _balances;
600 
601     // Mapping from token ID to approved address
602     mapping(uint256 => address) private _tokenApprovals;
603 
604     // Mapping from owner to operator approvals
605     mapping(address => mapping(address => bool)) private _operatorApprovals;
606 
607     /**
608      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
609      */
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
619         return
620             interfaceId == type(IERC721).interfaceId ||
621             interfaceId == type(IERC721Metadata).interfaceId ||
622             super.supportsInterface(interfaceId);
623     }
624 
625     /**
626      * @dev See {IERC721-balanceOf}.
627      */
628     function balanceOf(address owner) public view virtual override returns (uint256) {
629         require(owner != address(0), "ERC721: balance query for the zero address");
630         return _balances[owner];
631     }
632 
633     /**
634      * @dev See {IERC721-ownerOf}.
635      */
636     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
637         address owner = _owners[tokenId];
638         require(owner != address(0), "ERC721: owner query for nonexistent token");
639         return owner;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-name}.
644      */
645     function name() public view virtual override returns (string memory) {
646         return _name;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-symbol}.
651      */
652     function symbol() public view virtual override returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-tokenURI}.
658      */
659     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
660         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
661 
662         string memory baseURI = _baseURI();
663         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
664     }
665 
666     /**
667      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
668      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
669      * by default, can be overriden in child contracts.
670      */
671     function _baseURI() internal view virtual returns (string memory) {
672         return "";
673     }
674 
675     /**
676      * @dev See {IERC721-approve}.
677      */
678     function approve(address to, uint256 tokenId) public virtual override {
679         address owner = ERC721.ownerOf(tokenId);
680         require(to != owner, "ERC721: approval to current owner");
681 
682         require(
683             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
684             "ERC721: approve caller is not owner nor approved for all"
685         );
686 
687         _approve(to, tokenId);
688     }
689 
690     /**
691      * @dev See {IERC721-getApproved}.
692      */
693     function getApproved(uint256 tokenId) public view virtual override returns (address) {
694         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
695 
696         return _tokenApprovals[tokenId];
697     }
698 
699     /**
700      * @dev See {IERC721-setApprovalForAll}.
701      */
702     function setApprovalForAll(address operator, bool approved) public virtual override {
703         require(operator != _msgSender(), "ERC721: approve to caller");
704 
705         _operatorApprovals[_msgSender()][operator] = approved;
706         emit ApprovalForAll(_msgSender(), operator, approved);
707     }
708 
709     /**
710      * @dev See {IERC721-isApprovedForAll}.
711      */
712     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
713         return _operatorApprovals[owner][operator];
714     }
715 
716     /**
717      * @dev See {IERC721-transferFrom}.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         //solhint-disable-next-line max-line-length
725         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
726 
727         _transfer(from, to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-safeTransferFrom}.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) public virtual override {
738         safeTransferFrom(from, to, tokenId, "");
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes memory _data
749     ) public virtual override {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         _safeTransfer(from, to, tokenId, _data);
752     }
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
759      *
760      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
761      * implement alternative mechanisms to perform token transfer, such as signature-based.
762      *
763      * Requirements:
764      *
765      * - `from` cannot be the zero address.
766      * - `to` cannot be the zero address.
767      * - `tokenId` token must exist and be owned by `from`.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeTransfer(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory _data
777     ) internal virtual {
778         _transfer(from, to, tokenId);
779         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
780     }
781 
782     /**
783      * @dev Returns whether `tokenId` exists.
784      *
785      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
786      *
787      * Tokens start existing when they are minted (`_mint`),
788      * and stop existing when they are burned (`_burn`).
789      */
790     function _exists(uint256 tokenId) internal view virtual returns (bool) {
791         return _owners[tokenId] != address(0);
792     }
793 
794     /**
795      * @dev Returns whether `spender` is allowed to manage `tokenId`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
802         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
803         address owner = ERC721.ownerOf(tokenId);
804         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
805     }
806 
807     /**
808      * @dev Safely mints `tokenId` and transfers it to `to`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must not exist.
813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _safeMint(address to, uint256 tokenId) internal virtual {
818         _safeMint(to, tokenId, "");
819     }
820 
821     /**
822      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
823      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
824      */
825     function _safeMint(
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) internal virtual {
830         _mint(to, tokenId);
831         require(
832             _checkOnERC721Received(address(0), to, tokenId, _data),
833             "ERC721: transfer to non ERC721Receiver implementer"
834         );
835     }
836 
837     /**
838      * @dev Mints `tokenId` and transfers it to `to`.
839      *
840      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
841      *
842      * Requirements:
843      *
844      * - `tokenId` must not exist.
845      * - `to` cannot be the zero address.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _mint(address to, uint256 tokenId) internal virtual {
850         require(to != address(0), "ERC721: mint to the zero address");
851         require(!_exists(tokenId), "ERC721: token already minted");
852 
853         _beforeTokenTransfer(address(0), to, tokenId);
854 
855         _balances[to] += 1;
856         _owners[tokenId] = to;
857 
858         emit Transfer(address(0), to, tokenId);
859     }
860 
861     /**
862      * @dev Destroys `tokenId`.
863      * The approval is cleared when the token is burned.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _burn(uint256 tokenId) internal virtual {
872         address owner = ERC721.ownerOf(tokenId);
873 
874         _beforeTokenTransfer(owner, address(0), tokenId);
875 
876         // Clear approvals
877         _approve(address(0), tokenId);
878 
879         _balances[owner] -= 1;
880         delete _owners[tokenId];
881 
882         emit Transfer(owner, address(0), tokenId);
883     }
884 
885     /**
886      * @dev Transfers `tokenId` from `from` to `to`.
887      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
888      *
889      * Requirements:
890      *
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must be owned by `from`.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _transfer(
897         address from,
898         address to,
899         uint256 tokenId
900     ) internal virtual {
901         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
902         require(to != address(0), "ERC721: transfer to the zero address");
903 
904         _beforeTokenTransfer(from, to, tokenId);
905 
906         // Clear approvals from the previous owner
907         _approve(address(0), tokenId);
908 
909         _balances[from] -= 1;
910         _balances[to] += 1;
911         _owners[tokenId] = to;
912 
913         emit Transfer(from, to, tokenId);
914     }
915 
916     /**
917      * @dev Approve `to` to operate on `tokenId`
918      *
919      * Emits a {Approval} event.
920      */
921     function _approve(address to, uint256 tokenId) internal virtual {
922         _tokenApprovals[tokenId] = to;
923         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
924     }
925 
926     /**
927      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
928      * The call is not executed if the target address is not a contract.
929      *
930      * @param from address representing the previous owner of the given token ID
931      * @param to target address that will receive the tokens
932      * @param tokenId uint256 ID of the token to be transferred
933      * @param _data bytes optional data to send along with the call
934      * @return bool whether the call correctly returned the expected magic value
935      */
936     function _checkOnERC721Received(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) private returns (bool) {
942         if (to.isContract()) {
943             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
944                 return retval == IERC721Receiver(to).onERC721Received.selector;
945             } catch (bytes memory reason) {
946                 if (reason.length == 0) {
947                     revert("ERC721: transfer to non ERC721Receiver implementer");
948                 } else {
949                     assembly {
950                         revert(add(32, reason), mload(reason))
951                     }
952                 }
953             }
954         } else {
955             return true;
956         }
957     }
958 
959     /**
960      * @dev Hook that is called before any token transfer. This includes minting
961      * and burning.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` will be minted for `to`.
968      * - When `to` is zero, ``from``'s `tokenId` will be burned.
969      * - `from` and `to` are never both zero.
970      *
971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
972      */
973     function _beforeTokenTransfer(
974         address from,
975         address to,
976         uint256 tokenId
977     ) internal virtual {}
978 }
979 
980 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
981 
982 
983 
984 pragma solidity ^0.8.0;
985 
986 
987 /**
988  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
989  * @dev See https://eips.ethereum.org/EIPS/eip-721
990  */
991 interface IERC721Enumerable is IERC721 {
992     /**
993      * @dev Returns the total amount of tokens stored by the contract.
994      */
995     function totalSupply() external view returns (uint256);
996 
997     /**
998      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
999      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1000      */
1001     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1002 
1003     /**
1004      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1005      * Use along with {totalSupply} to enumerate all tokens.
1006      */
1007     function tokenByIndex(uint256 index) external view returns (uint256);
1008 }
1009 
1010 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1011 
1012 
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 
1018 /**
1019  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1020  * enumerability of all the token ids in the contract as well as all token ids owned by each
1021  * account.
1022  */
1023 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1024     // Mapping from owner to list of owned token IDs
1025     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1026 
1027     // Mapping from token ID to index of the owner tokens list
1028     mapping(uint256 => uint256) private _ownedTokensIndex;
1029 
1030     // Array with all token ids, used for enumeration
1031     uint256[] private _allTokens;
1032 
1033     // Mapping from token id to position in the allTokens array
1034     mapping(uint256 => uint256) private _allTokensIndex;
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1040         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1048         return _ownedTokens[owner][index];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-totalSupply}.
1053      */
1054     function totalSupply() public view virtual override returns (uint256) {
1055         return _allTokens.length;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-tokenByIndex}.
1060      */
1061     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1062         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1063         return _allTokens[index];
1064     }
1065 
1066     /**
1067      * @dev Hook that is called before any token transfer. This includes minting
1068      * and burning.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual override {
1086         super._beforeTokenTransfer(from, to, tokenId);
1087 
1088         if (from == address(0)) {
1089             _addTokenToAllTokensEnumeration(tokenId);
1090         } else if (from != to) {
1091             _removeTokenFromOwnerEnumeration(from, tokenId);
1092         }
1093         if (to == address(0)) {
1094             _removeTokenFromAllTokensEnumeration(tokenId);
1095         } else if (to != from) {
1096             _addTokenToOwnerEnumeration(to, tokenId);
1097         }
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1102      * @param to address representing the new owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1104      */
1105     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1106         uint256 length = ERC721.balanceOf(to);
1107         _ownedTokens[to][length] = tokenId;
1108         _ownedTokensIndex[tokenId] = length;
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's token tracking data structures.
1113      * @param tokenId uint256 ID of the token to be added to the tokens list
1114      */
1115     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1116         _allTokensIndex[tokenId] = _allTokens.length;
1117         _allTokens.push(tokenId);
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1122      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1123      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1124      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1125      * @param from address representing the previous owner of the given token ID
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1127      */
1128     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1129         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1133         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary
1136         if (tokenIndex != lastTokenIndex) {
1137             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1138 
1139             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1140             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1141         }
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _ownedTokensIndex[tokenId];
1145         delete _ownedTokens[from][lastTokenIndex];
1146     }
1147 
1148     /**
1149      * @dev Private function to remove a token from this extension's token tracking data structures.
1150      * This has O(1) time complexity, but alters the order of the _allTokens array.
1151      * @param tokenId uint256 ID of the token to be removed from the tokens list
1152      */
1153     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1154         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1155         // then delete the last slot (swap and pop).
1156 
1157         uint256 lastTokenIndex = _allTokens.length - 1;
1158         uint256 tokenIndex = _allTokensIndex[tokenId];
1159 
1160         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1161         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1162         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1163         uint256 lastTokenId = _allTokens[lastTokenIndex];
1164 
1165         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1166         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1167 
1168         // This also deletes the contents at the last position of the array
1169         delete _allTokensIndex[tokenId];
1170         _allTokens.pop();
1171     }
1172 }
1173 
1174 // File: @openzeppelin/contracts/access/Ownable.sol
1175 
1176 
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 /**
1182  * @dev Contract module which provides a basic access control mechanism, where
1183  * there is an account (an owner) that can be granted exclusive access to
1184  * specific functions.
1185  *
1186  * By default, the owner account will be the one that deploys the contract. This
1187  * can later be changed with {transferOwnership}.
1188  *
1189  * This module is used through inheritance. It will make available the modifier
1190  * `onlyOwner`, which can be applied to your functions to restrict their use to
1191  * the owner.
1192  */
1193 abstract contract Ownable is Context {
1194     address private _owner;
1195 
1196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1197 
1198     /**
1199      * @dev Initializes the contract setting the deployer as the initial owner.
1200      */
1201     constructor() {
1202         _setOwner(_msgSender());
1203     }
1204 
1205     /**
1206      * @dev Returns the address of the current owner.
1207      */
1208     function owner() public view virtual returns (address) {
1209         return _owner;
1210     }
1211 
1212     /**
1213      * @dev Throws if called by any account other than the owner.
1214      */
1215     modifier onlyOwner() {
1216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1217         _;
1218     }
1219 
1220     /**
1221      * @dev Leaves the contract without owner. It will not be possible to call
1222      * `onlyOwner` functions anymore. Can only be called by the current owner.
1223      *
1224      * NOTE: Renouncing ownership will leave the contract without an owner,
1225      * thereby removing any functionality that is only available to the owner.
1226      */
1227     function renounceOwnership() public virtual onlyOwner {
1228         _setOwner(address(0));
1229     }
1230 
1231     /**
1232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1233      * Can only be called by the current owner.
1234      */
1235     function transferOwnership(address newOwner) public virtual onlyOwner {
1236         require(newOwner != address(0), "Ownable: new owner is the zero address");
1237         _setOwner(newOwner);
1238     }
1239 
1240     function _setOwner(address newOwner) private {
1241         address oldOwner = _owner;
1242         _owner = newOwner;
1243         emit OwnershipTransferred(oldOwner, newOwner);
1244     }
1245 }
1246 
1247 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1248 
1249 
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 /**
1254  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1255  *
1256  * These functions can be used to verify that a message was signed by the holder
1257  * of the private keys of a given address.
1258  */
1259 library ECDSA {
1260     /**
1261      * @dev Returns the address that signed a hashed message (`hash`) with
1262      * `signature`. This address can then be used for verification purposes.
1263      *
1264      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1265      * this function rejects them by requiring the `s` value to be in the lower
1266      * half order, and the `v` value to be either 27 or 28.
1267      *
1268      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1269      * verification to be secure: it is possible to craft signatures that
1270      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1271      * this is by receiving a hash of the original message (which may otherwise
1272      * be too long), and then calling {toEthSignedMessageHash} on it.
1273      *
1274      * Documentation for signature generation:
1275      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1276      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1277      */
1278     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1279         // Check the signature length
1280         // - case 65: r,s,v signature (standard)
1281         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1282         if (signature.length == 65) {
1283             bytes32 r;
1284             bytes32 s;
1285             uint8 v;
1286             // ecrecover takes the signature parameters, and the only way to get them
1287             // currently is to use assembly.
1288             assembly {
1289                 r := mload(add(signature, 0x20))
1290                 s := mload(add(signature, 0x40))
1291                 v := byte(0, mload(add(signature, 0x60)))
1292             }
1293             return recover(hash, v, r, s);
1294         } else if (signature.length == 64) {
1295             bytes32 r;
1296             bytes32 vs;
1297             // ecrecover takes the signature parameters, and the only way to get them
1298             // currently is to use assembly.
1299             assembly {
1300                 r := mload(add(signature, 0x20))
1301                 vs := mload(add(signature, 0x40))
1302             }
1303             return recover(hash, r, vs);
1304         } else {
1305             revert("ECDSA: invalid signature length");
1306         }
1307     }
1308 
1309     /**
1310      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
1311      *
1312      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1313      *
1314      * _Available since v4.2._
1315      */
1316     function recover(
1317         bytes32 hash,
1318         bytes32 r,
1319         bytes32 vs
1320     ) internal pure returns (address) {
1321         bytes32 s;
1322         uint8 v;
1323         assembly {
1324             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1325             v := add(shr(255, vs), 27)
1326         }
1327         return recover(hash, v, r, s);
1328     }
1329 
1330     /**
1331      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
1332      */
1333     function recover(
1334         bytes32 hash,
1335         uint8 v,
1336         bytes32 r,
1337         bytes32 s
1338     ) internal pure returns (address) {
1339         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1340         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1341         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1342         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1343         //
1344         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1345         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1346         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1347         // these malleable signatures as well.
1348         require(
1349             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
1350             "ECDSA: invalid signature 's' value"
1351         );
1352         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1353 
1354         // If the signature is valid (and not malleable), return the signer address
1355         address signer = ecrecover(hash, v, r, s);
1356         require(signer != address(0), "ECDSA: invalid signature");
1357 
1358         return signer;
1359     }
1360 
1361     /**
1362      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1363      * produces hash corresponding to the one signed with the
1364      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1365      * JSON-RPC method as part of EIP-191.
1366      *
1367      * See {recover}.
1368      */
1369     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1370         // 32 is the length in bytes of hash,
1371         // enforced by the type signature above
1372         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1373     }
1374 
1375     /**
1376      * @dev Returns an Ethereum Signed Typed Data, created from a
1377      * `domainSeparator` and a `structHash`. This produces hash corresponding
1378      * to the one signed with the
1379      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1380      * JSON-RPC method as part of EIP-712.
1381      *
1382      * See {recover}.
1383      */
1384     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1385         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1386     }
1387 }
1388 
1389 // File: contracts/ERC721Cells.sol
1390 
1391 
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 
1396 
1397 
1398 
1399 
1400 /**
1401  * @title ERC721Cells
1402  * ERC721Cells - ERC721 Contract of The Cells Zone
1403  */
1404 abstract contract ERC721Cells is ERC721Enumerable, Ownable {
1405     using ECDSA for bytes32;
1406 
1407     address signerAddress = 0x8E7c6DBdae809c79C9f8Aa0F9ACf05614b4EB548; // The Cells Zone Signer Address
1408     uint256 private _currentTokenId = 386;
1409     uint256 private _reservedTokenId = 0;
1410     uint256 private MAX_RESERVED_ID = 386;
1411     uint256 public mintedSupply = 0;
1412     bool public lockingEnabled = false;
1413     string public baseURI = "https://api.thecellszone.com/json/";
1414     
1415     // Optional mapping for token URIs
1416     mapping (uint256 => string) private _tokenURIs;
1417     mapping (uint256 => string) public tokenIdToCellCode;
1418     mapping (string => uint256) public cellCodeToTokenId;
1419     mapping (address => mapping(uint => bool)) private lockNonces;
1420 
1421     event CellAllocation(address indexed to, uint256 indexed fromTokenId, uint256 indexed toTokenId, uint256 data, bool isRandom);
1422     event LockedCell(uint indexed tokenId, address owner, string cellCode, string tokenURI);
1423     event PermanentURI(string _value, uint256 indexed _id);
1424 
1425     constructor(
1426         string memory _name,
1427         string memory _symbol
1428     ) ERC721(_name, _symbol) {
1429         
1430     }
1431 
1432     /**
1433      * @dev Mints a token to an address with a tokenURI.
1434      * @param _to address of the future owner of the token
1435      */
1436     function mintTo(address _to, uint256 _numItemsAllocated, bool isRandom, uint256 data) public virtual onlyOwner {
1437         uint256 newTokenId = _getNextTokenId();
1438         for (uint256 i = 0; i < _numItemsAllocated; i++) {
1439             _mint(_to, newTokenId + i);
1440         }
1441         _incrementTokenId(_numItemsAllocated);
1442         emit CellAllocation(_to, newTokenId, newTokenId + _numItemsAllocated - 1, data, isRandom);
1443     }
1444 
1445     function mintCell(address _to, uint256 _numItemsAllocated, bool isRandom, uint256 data) internal virtual {
1446         uint256 newTokenId = _getNextTokenId();
1447         for (uint256 i = 0; i < _numItemsAllocated; i++) {
1448             _mint(_to, newTokenId + i);
1449         }
1450         _incrementTokenId(_numItemsAllocated);
1451         _incrementMintedSupply(_numItemsAllocated);
1452         emit CellAllocation(_to, newTokenId, newTokenId + _numItemsAllocated - 1, data, isRandom);
1453     }    
1454 
1455     function reserveTo(address _to, uint256 _numItemsAllocated, bool isRandom, uint256 data) public virtual onlyOwner {
1456         uint256 newTokenId = _getNextReservedTokenId();
1457         uint256 newCount = newTokenId + _numItemsAllocated;
1458         require(newCount <= MAX_RESERVED_ID, "tokenId too high");
1459         for (uint256 i = 0; i < _numItemsAllocated; i++) {
1460             _mint(_to, newTokenId + i);
1461         }
1462         _incrementReservedTokenId(_numItemsAllocated);
1463         emit CellAllocation(_to, newTokenId, newTokenId + _numItemsAllocated - 1, data, isRandom);
1464     }
1465 
1466     /**
1467      * @dev calculates the next token ID based on value of _currentTokenId
1468      * @return uint256 for the next token ID
1469      */
1470     function _getNextTokenId() private view returns (uint256) {
1471         return _currentTokenId + 1;
1472     }
1473 
1474     function _getNextReservedTokenId() private view returns (uint256) {
1475         return _reservedTokenId + 1;
1476     }    
1477 
1478     function setSignerAddress(address _address) public virtual onlyOwner {
1479         signerAddress = _address;
1480     }
1481 
1482     function toggleLocking() public virtual onlyOwner {
1483         lockingEnabled = !lockingEnabled;
1484     }
1485 
1486     /**
1487      * @dev increments the value of _currentTokenId
1488      */
1489     function _incrementTokenId(uint256 num) private {
1490         _currentTokenId += num;
1491     }
1492 
1493     function _incrementReservedTokenId(uint256 num) private {
1494         _reservedTokenId += num;
1495     }
1496 
1497     function _incrementMintedSupply(uint256 num) private {
1498         mintedSupply += num;
1499     }
1500 
1501     function _baseURI() internal view virtual override returns (string memory) {
1502         return baseURI;
1503     }
1504 
1505     function setBaseURI(string memory newURI) public onlyOwner {
1506         baseURI = newURI;
1507     }    
1508 
1509     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1510         require(_exists(tokenId), "invalid token");
1511 
1512         string memory _tokenURI = _tokenURIs[tokenId];
1513         string memory base = _baseURI();
1514 
1515         // If exists, return ipfs URI
1516         if (bytes(_tokenURI).length > 0) {
1517             return string(abi.encodePacked('ipfs://', _tokenURI));
1518         }
1519         // If not, return Cells API URI
1520         return string(abi.encodePacked(base, Strings.toString(tokenId)));
1521     }
1522 
1523     /*
1524      * Lock Cell forever
1525      */ 
1526     function lockCell(
1527         bytes memory signature,
1528         uint256 tokenId, 
1529         uint256 nonce,
1530         string memory cellCode,
1531         string memory _tokenURI
1532     ) external {
1533         require(lockingEnabled, "locking disabled");
1534         require(ownerOf(tokenId) == msg.sender, "not your cell");
1535         require(bytes(_tokenURIs[tokenId]).length == 0 || !lockNonces[msg.sender][nonce], "already locked");
1536 
1537         bytes32 _hash = keccak256(abi.encode(msg.sender, tokenId, nonce, cellCode, _tokenURI));
1538         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
1539         address signer = messageHash.recover(signature);
1540         require(signer == signerAddress, "Signers don't match");
1541 
1542         lockNonces[msg.sender][nonce] = true;
1543         _setTokenURI(tokenId, _tokenURI);
1544         _setCellCode(tokenId, cellCode);
1545         
1546         emit LockedCell(tokenId, msg.sender, cellCode, _tokenURI);
1547         emit PermanentURI(_tokenURI, tokenId);
1548     }
1549 
1550     /**
1551      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1552      *
1553      * Requirements:
1554      *
1555      * - `tokenId` must exist.
1556      */
1557     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1558         require(_exists(tokenId), "invalid token");
1559         _tokenURIs[tokenId] = _tokenURI;
1560     }
1561 
1562     function _setCellCode(uint256 tokenId, string memory _cellCode) internal virtual {
1563         require(_exists(tokenId), "invalid token");
1564         require(cellCodeToTokenId[_cellCode] == 0, "already set");
1565         require(bytes(tokenIdToCellCode[tokenId]).length == 0, "already set");
1566         cellCodeToTokenId[_cellCode] = tokenId;
1567         tokenIdToCellCode[tokenId] = _cellCode;
1568     }
1569 
1570 }
1571 
1572 // File: contracts/Cells.sol
1573 
1574 
1575 
1576 pragma solidity ^0.8.0;
1577 
1578 
1579 /**
1580 ______________ ______________ _________ ___________.____    .____       _________ __________________    _______  ___________
1581 \__    ___/   |   \_   _____/ \_   ___ \\_   _____/|    |   |    |     /   _____/ \____    /\_____  \   \      \ \_   _____/
1582   |    | /    ~    \    __)_  /    \  \/ |    __)_ |    |   |    |     \_____  \    /     /  /   |   \  /   |   \ |    __)_ 
1583   |    | \    Y    /        \ \     \____|        \|    |___|    |___  /        \  /     /_ /    |    \/    |    \|        \
1584   |____|  \___|_  /_______  /  \______  /_______  /|_______ \_______ \/_______  / /_______ \\_______  /\____|__  /_______  /
1585                 \/        \/          \/        \/         \/       \/        \/          \/        \/         \/        \/
1586 
1587 **/
1588 interface IERC20 {
1589    function mint(address to, uint256 amount) external;
1590    function transfer(address recipient, uint256 amount) external returns (bool);
1591    function balanceOf(address account) external view returns (uint256);
1592 }
1593 
1594 /**
1595  * @title The Cells Zone
1596  * 
1597  */
1598 contract Cells is ERC721Cells {
1599     using ECDSA for bytes32;
1600 
1601     bool public directMint = false;
1602     bool public randomMint = true;
1603     bool public packMint = false;
1604     bool public signatureMint = true;
1605     bool public bonusCoins = true;
1606     uint256 public constant MAX_CELLS_PURCHASE = 25;
1607     uint256 public constant MAX_CELLS = 29886;
1608     uint256 public minMintable = 1;
1609     uint256 public maxMintable = 29000;
1610     uint256 public cellPrice = 0.025 ether;
1611     uint256 public bonusCoinsAmount = 200;
1612     IERC20 public celdaContract;
1613 
1614     mapping (uint256 => uint256) public packPrices;
1615     mapping (address => mapping(uint => bool)) private mintNonces;
1616 
1617     constructor(address _erc20Address)
1618         ERC721Cells("The Cells Zone", "CELLS") 
1619     {
1620         celdaContract = IERC20(_erc20Address);
1621         packPrices[0] = 0.02 ether;
1622         packPrices[1] = 0.015 ether;
1623         packPrices[2] = 0.01 ether;
1624     }
1625 
1626     function contractURI() public pure returns (string memory) {
1627         return "https://api.thecellszone.com/contract/";
1628     }
1629 
1630     function toggleDirectMint() public onlyOwner {
1631         directMint = !directMint;
1632     }    
1633 
1634     function toggleRandomMint() public onlyOwner {
1635         randomMint = !randomMint;
1636     }
1637 
1638     function togglePackMint() public onlyOwner {
1639         packMint = !packMint;
1640     }
1641 
1642     function toggleSignatureMint() public onlyOwner {
1643         signatureMint = !signatureMint;
1644     }
1645 
1646     function toggleBonusCoins() public onlyOwner {
1647         bonusCoins = !bonusCoins;
1648     }
1649 
1650     function setBonusCoinsAmount(uint amount) public onlyOwner {
1651         bonusCoinsAmount = amount;
1652     }    
1653 
1654     function setCellPrice(uint256 newPrice) public onlyOwner {
1655         cellPrice = newPrice;
1656     }
1657 
1658     function setPackPrice(uint packId, uint256 newPrice) public onlyOwner {
1659         packPrices[packId] = newPrice;
1660     }    
1661 
1662     function setMinMintable(uint quantity) public onlyOwner {
1663         minMintable = quantity;
1664     }    
1665 
1666     function setMaxMintable(uint quantity) public onlyOwner {
1667         maxMintable = quantity;
1668     }    
1669 
1670     function reserveCells(uint number, bool isRandom, uint256 data) public onlyOwner {
1671         reserveTo(msg.sender, number, isRandom, data);
1672     }
1673     
1674     /**
1675     * Mint Cells
1676     */
1677     function mintCells(uint amount) public payable {
1678         require(directMint, "Direct mint is not active");
1679         require(amount >= minMintable, "Quantity too low");        
1680         require(amount <= MAX_CELLS_PURCHASE || mintedSupply + amount <= maxMintable || totalSupply() + amount <= MAX_CELLS, "Quantity too high");
1681         require(cellPrice * amount <= msg.value, "Ether value sent is not correct");
1682         
1683         mintCell(msg.sender, amount, randomMint, 0);
1684         if (bonusCoins) {
1685             sendBonusCoins(msg.sender, amount);
1686         }
1687     }
1688 
1689     /**
1690     * Batch Mint Cells
1691     */
1692     function mintCellPack(uint amount) public payable {
1693         require(packMint, "Pack mint is not active");
1694         require(amount >= minMintable, "Quantity too low");        
1695         require(amount <= MAX_CELLS_PURCHASE || mintedSupply + amount <= maxMintable || totalSupply() + amount <= MAX_CELLS, "Quantity too high");
1696         require(getPackPrice(amount) * amount <= msg.value, "Ether value sent is not correct");
1697         
1698         mintCell(msg.sender, amount, randomMint, 0);
1699         if (bonusCoins) {
1700             sendBonusCoins(msg.sender, amount);
1701         }
1702     }
1703 
1704     /**
1705     * Authorized Mint
1706     */
1707     function verifyAndMint(bytes memory signature, uint amount, uint nonce, uint mintPrice, uint data) public payable {
1708         require(signatureMint, "Signature mint is not active");
1709         require(amount >= minMintable, "Quantity too low");        
1710         require(amount <= MAX_CELLS_PURCHASE || mintedSupply + amount <= maxMintable || totalSupply() + amount <= MAX_CELLS, "Quantity too high");
1711         require(!mintNonces[msg.sender][nonce], "Nonce already used");
1712 
1713         uint price;
1714         if (mintPrice == 1) {
1715             price = getPackPrice(amount);
1716         } else if (mintPrice == 2) {
1717             price = cellPrice;
1718         } else {
1719             price = mintPrice;
1720         }
1721         
1722         require(price * amount <= msg.value, "Ether value sent is not correct");
1723         
1724         bytes32 hash = keccak256(abi.encode(msg.sender, amount, nonce, mintPrice, data));
1725         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1726         address signer = messageHash.recover(signature);
1727         require(signer == signerAddress, "Signers don't match");
1728 
1729         mintNonces[msg.sender][nonce] = true;
1730         mintCell(msg.sender, amount, randomMint, data);
1731         if (bonusCoins) {
1732             sendBonusCoins(msg.sender, amount);
1733         }
1734     }
1735 
1736     function getPackPrice(uint256 _amount) internal view returns (uint256) {
1737         uint256 price;
1738         
1739         if (_amount < 3) {
1740             price = cellPrice;
1741         } else if (_amount < 10) {
1742             price = packPrices[0];
1743         } else if (_amount < 25) {
1744             price = packPrices[1];
1745         } else {
1746             price = packPrices[2];
1747         }
1748 
1749         return price;
1750     }
1751 
1752     function sendBonusCoins(address _to, uint256 _amount) internal {
1753         celdaContract.mint(_to, _amount * bonusCoinsAmount * 10**18);
1754     }
1755 
1756     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1757         uint256 tokenCount = balanceOf(_owner);
1758 
1759         uint256[] memory tokensId = new uint256[](tokenCount);
1760         for(uint256 i; i < tokenCount; i++){
1761             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1762         }
1763         return tokensId;
1764     }
1765 
1766     function withdraw() public onlyOwner {
1767         uint balance = address(this).balance;
1768         address payable sender = payable(msg.sender);
1769         sender.transfer(balance);
1770     }    
1771 
1772 	function reclaimToken(IERC20 token) public onlyOwner {
1773 		require(address(token) != address(0));
1774 		uint256 balance = token.balanceOf(address(this));
1775 		token.transfer(msg.sender, balance);
1776 	}
1777 }