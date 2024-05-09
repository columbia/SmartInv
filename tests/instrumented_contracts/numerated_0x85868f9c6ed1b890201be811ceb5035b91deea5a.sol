1 // Sources flattened with hardhat v2.6.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
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
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
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
203 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
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
230 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
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
362         return verifyCallResult(success, returndata, errorMessage);
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
389         return verifyCallResult(success, returndata, errorMessage);
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
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 
449 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 
474 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev String operations.
479  */
480 library Strings {
481     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
485      */
486     function toString(uint256 value) internal pure returns (string memory) {
487         // Inspired by OraclizeAPI's implementation - MIT licence
488         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
489 
490         if (value == 0) {
491             return "0";
492         }
493         uint256 temp = value;
494         uint256 digits;
495         while (temp != 0) {
496             digits++;
497             temp /= 10;
498         }
499         bytes memory buffer = new bytes(digits);
500         while (value != 0) {
501             digits -= 1;
502             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
503             value /= 10;
504         }
505         return string(buffer);
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
510      */
511     function toHexString(uint256 value) internal pure returns (string memory) {
512         if (value == 0) {
513             return "0x00";
514         }
515         uint256 temp = value;
516         uint256 length = 0;
517         while (temp != 0) {
518             length++;
519             temp >>= 8;
520         }
521         return toHexString(value, length);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
526      */
527     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
528         bytes memory buffer = new bytes(2 * length + 2);
529         buffer[0] = "0";
530         buffer[1] = "x";
531         for (uint256 i = 2 * length + 1; i > 1; --i) {
532             buffer[i] = _HEX_SYMBOLS[value & 0xf];
533             value >>= 4;
534         }
535         require(value == 0, "Strings: hex length insufficient");
536         return string(buffer);
537     }
538 }
539 
540 
541 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 
569 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
570 
571 
572 pragma solidity ^0.8.0;
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
944                 return retval == IERC721Receiver.onERC721Received.selector;
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
980 
981 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
982 
983 
984 pragma solidity ^0.8.0;
985 
986 /**
987  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
988  * @dev See https://eips.ethereum.org/EIPS/eip-721
989  */
990 interface IERC721Enumerable is IERC721 {
991     /**
992      * @dev Returns the total amount of tokens stored by the contract.
993      */
994     function totalSupply() external view returns (uint256);
995 
996     /**
997      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
998      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
999      */
1000     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1001 
1002     /**
1003      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1004      * Use along with {totalSupply} to enumerate all tokens.
1005      */
1006     function tokenByIndex(uint256 index) external view returns (uint256);
1007 }
1008 
1009 
1010 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1011 
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 
1016 /**
1017  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1018  * enumerability of all the token ids in the contract as well as all token ids owned by each
1019  * account.
1020  */
1021 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1022     // Mapping from owner to list of owned token IDs
1023     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1024 
1025     // Mapping from token ID to index of the owner tokens list
1026     mapping(uint256 => uint256) private _ownedTokensIndex;
1027 
1028     // Array with all token ids, used for enumeration
1029     uint256[] private _allTokens;
1030 
1031     // Mapping from token id to position in the allTokens array
1032     mapping(uint256 => uint256) private _allTokensIndex;
1033 
1034     /**
1035      * @dev See {IERC165-supportsInterface}.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1038         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1043      */
1044     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1045         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1046         return _ownedTokens[owner][index];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-totalSupply}.
1051      */
1052     function totalSupply() public view virtual override returns (uint256) {
1053         return _allTokens.length;
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenByIndex}.
1058      */
1059     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1060         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1061         return _allTokens[index];
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual override {
1084         super._beforeTokenTransfer(from, to, tokenId);
1085 
1086         if (from == address(0)) {
1087             _addTokenToAllTokensEnumeration(tokenId);
1088         } else if (from != to) {
1089             _removeTokenFromOwnerEnumeration(from, tokenId);
1090         }
1091         if (to == address(0)) {
1092             _removeTokenFromAllTokensEnumeration(tokenId);
1093         } else if (to != from) {
1094             _addTokenToOwnerEnumeration(to, tokenId);
1095         }
1096     }
1097 
1098     /**
1099      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1100      * @param to address representing the new owner of the given token ID
1101      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1102      */
1103     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1104         uint256 length = ERC721.balanceOf(to);
1105         _ownedTokens[to][length] = tokenId;
1106         _ownedTokensIndex[tokenId] = length;
1107     }
1108 
1109     /**
1110      * @dev Private function to add a token to this extension's token tracking data structures.
1111      * @param tokenId uint256 ID of the token to be added to the tokens list
1112      */
1113     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1114         _allTokensIndex[tokenId] = _allTokens.length;
1115         _allTokens.push(tokenId);
1116     }
1117 
1118     /**
1119      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1120      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1121      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1122      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1123      * @param from address representing the previous owner of the given token ID
1124      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1125      */
1126     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1127         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1128         // then delete the last slot (swap and pop).
1129 
1130         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1131         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1132 
1133         // When the token to delete is the last token, the swap operation is unnecessary
1134         if (tokenIndex != lastTokenIndex) {
1135             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1136 
1137             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139         }
1140 
1141         // This also deletes the contents at the last position of the array
1142         delete _ownedTokensIndex[tokenId];
1143         delete _ownedTokens[from][lastTokenIndex];
1144     }
1145 
1146     /**
1147      * @dev Private function to remove a token from this extension's token tracking data structures.
1148      * This has O(1) time complexity, but alters the order of the _allTokens array.
1149      * @param tokenId uint256 ID of the token to be removed from the tokens list
1150      */
1151     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1152         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1153         // then delete the last slot (swap and pop).
1154 
1155         uint256 lastTokenIndex = _allTokens.length - 1;
1156         uint256 tokenIndex = _allTokensIndex[tokenId];
1157 
1158         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1159         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1160         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1161         uint256 lastTokenId = _allTokens[lastTokenIndex];
1162 
1163         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1164         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1165 
1166         // This also deletes the contents at the last position of the array
1167         delete _allTokensIndex[tokenId];
1168         _allTokens.pop();
1169     }
1170 }
1171 
1172 
1173 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1174 
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 /**
1179  * @dev Contract module which provides a basic access control mechanism, where
1180  * there is an account (an owner) that can be granted exclusive access to
1181  * specific functions.
1182  *
1183  * By default, the owner account will be the one that deploys the contract. This
1184  * can later be changed with {transferOwnership}.
1185  *
1186  * This module is used through inheritance. It will make available the modifier
1187  * `onlyOwner`, which can be applied to your functions to restrict their use to
1188  * the owner.
1189  */
1190 abstract contract Ownable is Context {
1191     address private _owner;
1192 
1193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1194 
1195     /**
1196      * @dev Initializes the contract setting the deployer as the initial owner.
1197      */
1198     constructor() {
1199         _setOwner(_msgSender());
1200     }
1201 
1202     /**
1203      * @dev Returns the address of the current owner.
1204      */
1205     function owner() public view virtual returns (address) {
1206         return _owner;
1207     }
1208 
1209     /**
1210      * @dev Throws if called by any account other than the owner.
1211      */
1212     modifier onlyOwner() {
1213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1214         _;
1215     }
1216 
1217     /**
1218      * @dev Leaves the contract without owner. It will not be possible to call
1219      * `onlyOwner` functions anymore. Can only be called by the current owner.
1220      *
1221      * NOTE: Renouncing ownership will leave the contract without an owner,
1222      * thereby removing any functionality that is only available to the owner.
1223      */
1224     function renounceOwnership() public virtual onlyOwner {
1225         _setOwner(address(0));
1226     }
1227 
1228     /**
1229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1230      * Can only be called by the current owner.
1231      */
1232     function transferOwnership(address newOwner) public virtual onlyOwner {
1233         require(newOwner != address(0), "Ownable: new owner is the zero address");
1234         _setOwner(newOwner);
1235     }
1236 
1237     function _setOwner(address newOwner) private {
1238         address oldOwner = _owner;
1239         _owner = newOwner;
1240         emit OwnershipTransferred(oldOwner, newOwner);
1241     }
1242 }
1243 
1244 
1245 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1246 
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 /**
1251  * @dev Contract module that helps prevent reentrant calls to a function.
1252  *
1253  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1254  * available, which can be applied to functions to make sure there are no nested
1255  * (reentrant) calls to them.
1256  *
1257  * Note that because there is a single `nonReentrant` guard, functions marked as
1258  * `nonReentrant` may not call one another. This can be worked around by making
1259  * those functions `private`, and then adding `external` `nonReentrant` entry
1260  * points to them.
1261  *
1262  * TIP: If you would like to learn more about reentrancy and alternative ways
1263  * to protect against it, check out our blog post
1264  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1265  */
1266 abstract contract ReentrancyGuard {
1267     // Booleans are more expensive than uint256 or any type that takes up a full
1268     // word because each write operation emits an extra SLOAD to first read the
1269     // slot's contents, replace the bits taken up by the boolean, and then write
1270     // back. This is the compiler's defense against contract upgrades and
1271     // pointer aliasing, and it cannot be disabled.
1272 
1273     // The values being non-zero value makes deployment a bit more expensive,
1274     // but in exchange the refund on every call to nonReentrant will be lower in
1275     // amount. Since refunds are capped to a percentage of the total
1276     // transaction's gas, it is best to keep them low in cases like this one, to
1277     // increase the likelihood of the full refund coming into effect.
1278     uint256 private constant _NOT_ENTERED = 1;
1279     uint256 private constant _ENTERED = 2;
1280 
1281     uint256 private _status;
1282 
1283     constructor() {
1284         _status = _NOT_ENTERED;
1285     }
1286 
1287     /**
1288      * @dev Prevents a contract from calling itself, directly or indirectly.
1289      * Calling a `nonReentrant` function from another `nonReentrant`
1290      * function is not supported. It is possible to prevent this from happening
1291      * by making the `nonReentrant` function external, and make it call a
1292      * `private` function that does the actual work.
1293      */
1294     modifier nonReentrant() {
1295         // On the first call to nonReentrant, _notEntered will be true
1296         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1297 
1298         // Any calls to nonReentrant after this point will fail
1299         _status = _ENTERED;
1300 
1301         _;
1302 
1303         // By storing the original value once again, a refund is triggered (see
1304         // https://eips.ethereum.org/EIPS/eip-2200)
1305         _status = _NOT_ENTERED;
1306     }
1307 }
1308 
1309 
1310 // File contracts/PaymentSplitter.sol
1311 
1312 //
1313 //ÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòùÔûæÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔÇâÔÇâÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔòù
1314 //ÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûêÔûêÔòöÔòØÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòÉÔòØÔÇâÔÇâÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòÉÔòØÔòÜÔòÉÔòÉÔûêÔûêÔòöÔòÉÔòÉÔòØ
1315 //ÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔòÉÔòØÔûæÔòÜÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔÇâÔÇâÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûæÔûæÔûæÔûæÔûêÔûêÔòæÔûæÔûæÔûæ
1316 //ÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòØÔûæÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔûêÔûêÔòùÔûæÔûæÔòÜÔòÉÔòÉÔòÉÔûêÔûêÔòùÔÇâÔÇâÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòØÔûæÔûæÔûæÔûæÔûæÔûêÔûêÔòæÔûæÔûæÔûæ
1317 //ÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔûæÔûæÔûæÔûæÔòÜÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔÇâÔÇâÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔûêÔûêÔòæÔûæÔûæÔûæ
1318 //ÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔûæÔûæÔûæÔûæÔûæÔûæÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòØÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔÇâÔÇâÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔòÜÔòÉÔòØÔûæÔûæÔûæ
1319 //
1320 pragma solidity ^0.8.0;
1321     /********************Begin of Payment Splitter *********************************/
1322     /**
1323      * @dev this section contains the methods used
1324      * to split payment between all collaborators of this project
1325      */
1326 contract PaymentSplitter is Ownable{
1327     event PayeeAdded(address account, uint256 shares);
1328     event PaymentReleased(address to, uint256 amount);
1329     event PaymentReceived(address from, uint256 amount);
1330 
1331     uint256 private _totalShares;
1332     uint256 private _totalReleased;
1333 
1334     mapping(address => uint256) private _shares;
1335     mapping(address => uint256) private _released;
1336     address[] private _payees;
1337     bool private initialized = false;
1338 
1339     /**
1340      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1341      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1342      * reliability of the events, and not the actual splitting of Ether.
1343      *
1344      * To learn more about this see the Solidity documentation for
1345      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1346      * functions].
1347      */
1348     receive() external payable virtual {
1349         emit PaymentReceived(msg.sender, msg.value);
1350     }
1351 
1352     /**
1353      * @dev Getter for the total shares held by payees.
1354      */
1355     function totalShares() public view returns (uint256) {
1356         return _totalShares;
1357     }
1358 
1359     /**
1360      * @dev Getter for the total amount of Ether already released.
1361      */
1362     function totalReleased() public view returns (uint256) {
1363         return _totalReleased;
1364     }
1365 
1366     /**
1367      * @dev Getter for the amount of shares held by an account.
1368      */
1369     function shares(address account) public view returns (uint256) {
1370         return _shares[account];
1371     }
1372 
1373     /**
1374      * @dev Getter for the amount of Ether already released to a payee.
1375      */
1376     function released(address account) public view returns (uint256) {
1377         return _released[account];
1378     }
1379 
1380     /**
1381      * @dev Getter for the address of the payee number `index`.
1382      */
1383     function payee(uint256 index) public view returns (address) {
1384         return _payees[index];
1385     }
1386 
1387     /**
1388      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1389      * total shares and their previous withdrawals.
1390      */
1391     function release(address payable account) public virtual {
1392         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1393         require(msg.sender == account,"Not authorized");
1394         uint256 totalReceived = address(this).balance + _totalReleased;
1395         uint256 payment = (totalReceived * _shares[account]) /
1396             _totalShares -
1397             _released[account];
1398 
1399         require(payment != 0, "Account is not due payment");
1400 
1401         _released[account] = _released[account] + payment;
1402         _totalReleased = _totalReleased + payment;
1403 
1404         Address.sendValue(account, payment);
1405         // payable(account).send(payment);
1406         emit PaymentReleased(account, payment);
1407     }
1408 
1409     /**
1410      * @dev Add a new payee to the contract.
1411      * @param account The address of the payee to add.
1412      * @param shares_ The number of shares owned by the payee.
1413      */
1414     function _addPayee(address account, uint256 shares_) internal {
1415         require(
1416             account != address(0),
1417             "Account is the zero address"
1418         );
1419         require(shares_ > 0, "PaymentSplitter: shares are 0");
1420         require(
1421             _shares[account] == 0,
1422             "Account already has shares"
1423         );
1424 
1425         _payees.push(account);
1426         _shares[account] = shares_;
1427         _totalShares = _totalShares + shares_;
1428         emit PayeeAdded(account, shares_);
1429     }
1430 
1431     /**
1432      * @dev Return all payees
1433      */
1434     function getPayees() public view returns (address[] memory) {
1435         return _payees;
1436     }
1437     
1438     /**
1439      * @dev Set up all holders shares
1440      * @param payees wallets of holders.
1441      * @param shares_ shares of each holder.
1442      */
1443     function initializePaymentSplitter(
1444         address[] memory payees,
1445         uint256[] memory shares_
1446     ) public onlyOwner {
1447         require(!initialized, "Payment Split Already Initialized!");
1448         require(
1449             payees.length == shares_.length,
1450             "Payees and shares length mismatch"
1451         );
1452         require(payees.length > 0, "PaymentSplitter: no payees");
1453 
1454         for (uint256 i = 0; i < payees.length; i++) {
1455             _addPayee(payees[i], shares_[i]);
1456         }
1457         initialized = true;
1458     }
1459 }
1460     /********************End of Payment Splitter *********************************/
1461 
1462 
1463 // File contracts/DinoPunks.sol
1464 
1465 //
1466 //ÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòùÔûæÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûæÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔÇâÔÇâÔûêÔûêÔûêÔòùÔûæÔûæÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔûêÔòù
1467 //ÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòöÔòÉÔòÉÔûêÔûêÔòùÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûêÔûêÔòöÔòØÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòÉÔòØÔÇâÔÇâÔûêÔûêÔûêÔûêÔòùÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòÉÔòØÔòÜÔòÉÔòÉÔûêÔûêÔòöÔòÉÔòÉÔòØ
1468 //ÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔòÉÔòØÔûæÔòÜÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔÇâÔÇâÔûêÔûêÔòöÔûêÔûêÔòùÔûêÔûêÔòæÔûêÔûêÔûêÔûêÔûêÔòùÔûæÔûæÔûæÔûæÔûæÔûêÔûêÔòæÔûæÔûæÔûæ
1469 //ÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòÉÔòØÔûæÔûêÔûêÔòæÔûæÔûæÔûæÔûêÔûêÔòæÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔûêÔûêÔòùÔûæÔûæÔòÜÔòÉÔòÉÔòÉÔûêÔûêÔòùÔÇâÔÇâÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔòæÔûêÔûêÔòöÔòÉÔòÉÔòØÔûæÔûæÔûæÔûæÔûæÔûêÔûêÔòæÔûæÔûæÔûæ
1470 //ÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔòÜÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔûæÔûæÔûæÔûæÔòÜÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔòùÔûêÔûêÔûêÔûêÔûêÔûêÔòöÔòØÔÇâÔÇâÔûêÔûêÔòæÔûæÔòÜÔûêÔûêÔûêÔòæÔûêÔûêÔòæÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔûêÔûêÔòæÔûæÔûæÔûæ
1471 //ÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔûæÔûæÔûæÔûæÔûæÔûæÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòØÔòÜÔòÉÔòÉÔòÉÔòÉÔòÉÔòØÔûæÔÇâÔÇâÔòÜÔòÉÔòØÔûæÔûæÔòÜÔòÉÔòÉÔòØÔòÜÔòÉÔòØÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔûæÔòÜÔòÉÔòØÔûæÔûæÔûæ
1472 //
1473 
1474 pragma solidity >=0.8.0;
1475 /**
1476  * @dev contract module which defines Dino Punks NFT Collection
1477  * and all the interactions it uses
1478  */
1479 contract DinoPunks is ERC721Enumerable, Ownable, PaymentSplitter, ReentrancyGuard {
1480     using Strings for uint256;
1481 
1482     //@dev Attributes for NFT configuration
1483     string internal baseURI; 
1484     uint256 public cost = 0.05 ether;
1485     uint256 public maxSupply = 8888;
1486     uint256 public maxMintAmount = 5;
1487     mapping(address => uint256) public whitelist;
1488     mapping(uint256 => string) private _tokenURIs;
1489     mapping(address => bool) presaleAddress;
1490     uint256[] mintedEditions;
1491     bool public presale;
1492     bool public paused = true;
1493     bool public revealed;
1494     // @dev inner attributes of the contract
1495     
1496     /**
1497      * @dev Create an instance of Dino Punks contract
1498      * @param _initBaseURI Base URI for NFT metadata.
1499      */
1500     constructor(
1501         string memory _initBaseURI
1502         // address[] memory _payees,
1503         // uint256[] memory _amount,
1504     ) ERC721("DinoPunks", "DinoPunks"){
1505         setBaseURI(_initBaseURI);
1506         // initializePaymentSplitter(_payees, _amount); 
1507     }
1508     
1509     /**
1510      * @dev get base URI for NFT metadata
1511      */
1512     function _baseURI() internal view virtual override returns (string memory) {
1513         return baseURI;
1514     }
1515     
1516     /**
1517      * @dev set new max supply for the smart contract
1518      * @param _newMaxSupply new max supply 
1519      */
1520     function setNewMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1521         maxSupply = _newMaxSupply;
1522     }
1523     
1524     /**
1525      * 
1526      * @dev Mint edition to a wallet
1527      * @param _to wallet receiving the edition(s).
1528      * @param _mintAmount number of editions to mint.
1529      */
1530     function mint(address _to, uint256 _mintAmount) public payable nonReentrant {
1531         require(paused == false,"Minting is paused");
1532         require(_mintAmount <= maxMintAmount, "Cannot exceed max mint amount");
1533         if(presale == true)
1534             require(presaleAddress[msg.sender] == true,"Address not whitelisted for pre-sale minting");
1535             
1536         uint256 supply = totalSupply();
1537         require(
1538             supply + _mintAmount <= maxSupply,
1539             "Not enough mintable editions !"
1540         );
1541 
1542         require(
1543             msg.value >= cost * _mintAmount,
1544             "Insufficient transaction amount."
1545         );
1546         
1547         for (uint256 i = 1; i <= _mintAmount; i++) {
1548             _safeMint(_to, supply + i);
1549         }
1550     }
1551 
1552     /**
1553      * @dev whitelistMint edition to a wallet
1554      * @param _to wallet receiving the edition(s).
1555      * @param _mintAmount number of editions to mint.
1556      */    
1557     function freeMint(address _to, uint256 _mintAmount) public nonReentrant{
1558         uint256 supply = totalSupply();
1559         require(
1560                 _mintAmount <= whitelist[msg.sender],
1561                 "Amount exceeds allowance"
1562             );
1563             
1564         require(
1565             supply + _mintAmount <= maxSupply,
1566             "Not enough mintable editions !"
1567         );
1568         
1569         whitelist[msg.sender] -= _mintAmount;
1570 		for (uint256 i = 1; i <= _mintAmount; i++) {
1571             _safeMint(_to, supply + i);
1572         }
1573     }
1574     
1575     /**
1576      * @dev get balance contained in the smart contract
1577      */
1578     function getBalance() public view onlyOwner returns (uint256) {
1579         return address(this).balance;
1580     }
1581 
1582     /**
1583      * @dev change cost of NFT
1584      * @param _newCost new cost of each edition
1585      */
1586     function setCost(uint256 _newCost) public onlyOwner {
1587         require(_newCost > 0, "New cost can not be 0");
1588         cost = _newCost;
1589     }
1590 
1591     /**
1592      * @dev restrict max mintable amount of edition at a time
1593      * @param _newmaxMintAmount new max mintable amount
1594      */
1595     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1596         require(_newmaxMintAmount > 0, "New mint amount cannot be 0");
1597         maxMintAmount = _newmaxMintAmount;
1598     }
1599 
1600     /**
1601      * @dev change metadata uri
1602      * @param _newBaseURI new URI for metadata
1603      */
1604     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1605         baseURI = _newBaseURI;
1606     }
1607 
1608     /**
1609      * @dev Disable minting process
1610      */
1611     function pause() public onlyOwner {
1612         paused = !paused;
1613     }
1614 
1615     /**
1616      * @dev Activate presaleAddress
1617      */
1618     function activatePresale() public onlyOwner {
1619         presale = !presale;
1620     } 
1621     
1622     /**
1623      * @dev Activate presaleAddress
1624      */
1625     function presaleMembers(address[] memory _presaleAddress) public onlyOwner {
1626         for(uint i = 0; i< _presaleAddress.length; i++)
1627             presaleAddress[_presaleAddress[i]] = true;
1628     } 
1629     
1630     /**
1631      * @dev Add user to white list
1632      * @param _user Users wallet to whitelist
1633      */
1634     function whitelistUserBatch(
1635         address[] memory _user,
1636         uint256[] memory _amount
1637     ) public onlyOwner {
1638         require(_user.length == _amount.length);
1639         for (uint256 i = 0; i < _user.length; i++)
1640             whitelist[_user[i]] = _amount[i];
1641     }
1642 
1643     /**
1644      * @dev Reveal metadata
1645      * @param _newURI new metadata URI
1646      */
1647     function reveal(string memory _newURI) public onlyOwner {
1648         setBaseURI(_newURI);
1649         revealed = true;
1650     }
1651     
1652     /**
1653      * @dev Get token URI
1654      * @param tokenId ID of the token to retrieve
1655      */
1656     function tokenURI(uint256 tokenId)
1657         public
1658         view
1659         virtual
1660         override
1661         returns (string memory)
1662         {
1663         require(
1664             _exists(tokenId),
1665             "URI query for nonexistent token"
1666         );
1667         
1668         if(revealed == false)
1669             return baseURI;
1670         else {
1671             if (bytes(_tokenURIs[tokenId]).length == 0) {
1672                 string memory currentBaseURI = _baseURI();
1673                 return
1674                     bytes(currentBaseURI).length > 0
1675                         ? string(
1676                             abi.encodePacked(
1677                                 currentBaseURI,
1678                                 tokenId.toString(),
1679                                 ".json"
1680                             )
1681                         )
1682                         : "";
1683             } else return _tokenURIs[tokenId];
1684         }
1685     }
1686     
1687     function burn(uint256[] memory _tokenIds) public onlyOwner {
1688         for( uint256 i = 0; i < _tokenIds.length; i++)
1689             _burn(_tokenIds[i]);
1690     }
1691 }