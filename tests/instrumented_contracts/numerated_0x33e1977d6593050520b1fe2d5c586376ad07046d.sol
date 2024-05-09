1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-28
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-10-28
11 */
12 
13 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
14 
15 // SPDX-License-Identifier: MIT AND GPL-3.0
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Interface of the ERC165 standard, as defined in the
21  * https://eips.ethereum.org/EIPS/eip-165[EIP].
22  *
23  * Implementers can declare support of contract interfaces, which can then be
24  * queried by others ({ERC165Checker}).
25  *
26  * For an implementation, see {ERC165}.
27  */
28 interface IERC165 {
29     /**
30      * @dev Returns true if this contract implements the interface defined by
31      * `interfaceId`. See the corresponding
32      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
33      * to learn more about how these ids are created.
34      *
35      * This function call must use less than 30 000 gas.
36      */
37     function supportsInterface(bytes4 interfaceId) external view returns (bool);
38 }
39 
40 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
41 
42 pragma solidity ^0.8.0;
43 
44 
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @title ERC721 token receiver interface
188  * @dev Interface for any contract that wants to support safeTransfers
189  * from ERC721 asset contracts.
190  */
191 interface IERC721Receiver {
192     /**
193      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
194      * by `operator` from `from`, this function is called.
195      *
196      * It must return its Solidity selector to confirm the token transfer.
197      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
198      *
199      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
200      */
201     function onERC721Received(
202         address operator,
203         address from,
204         uint256 tokenId,
205         bytes calldata data
206     ) external returns (bytes4);
207 }
208 
209 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
210 
211 pragma solidity ^0.8.0;
212 
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Context.sol
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Provides information about the current execution context, including the
458  * sender of the transaction and its data. While these are generally available
459  * via msg.sender and msg.data, they should not be accessed in such a direct
460  * manner, since when dealing with meta-transactions the account sending and
461  * paying for execution may not be the actual sender (as far as an application
462  * is concerned).
463  *
464  * This contract is only required for intermediate, library-like contracts.
465  */
466 abstract contract Context {
467     function _msgSender() internal view virtual returns (address) {
468         return msg.sender;
469     }
470 
471     function _msgData() internal view virtual returns (bytes calldata) {
472         return msg.data;
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Strings.sol
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev String operations.
482  */
483 library Strings {
484     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
488      */
489     function toString(uint256 value) internal pure returns (string memory) {
490         // Inspired by OraclizeAPI's implementation - MIT licence
491         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
492 
493         if (value == 0) {
494             return "0";
495         }
496         uint256 temp = value;
497         uint256 digits;
498         while (temp != 0) {
499             digits++;
500             temp /= 10;
501         }
502         bytes memory buffer = new bytes(digits);
503         while (value != 0) {
504             digits -= 1;
505             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
506             value /= 10;
507         }
508         return string(buffer);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
513      */
514     function toHexString(uint256 value) internal pure returns (string memory) {
515         if (value == 0) {
516             return "0x00";
517         }
518         uint256 temp = value;
519         uint256 length = 0;
520         while (temp != 0) {
521             length++;
522             temp >>= 8;
523         }
524         return toHexString(value, length);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
529      */
530     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
531         bytes memory buffer = new bytes(2 * length + 2);
532         buffer[0] = "0";
533         buffer[1] = "x";
534         for (uint256 i = 2 * length + 1; i > 1; --i) {
535             buffer[i] = _HEX_SYMBOLS[value & 0xf];
536             value >>= 4;
537         }
538         require(value == 0, "Strings: hex length insufficient");
539         return string(buffer);
540     }
541 }
542 
543 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Implementation of the {IERC165} interface.
550  *
551  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
552  * for the additional interface id that will be supported. For example:
553  *
554  * ```solidity
555  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
557  * }
558  * ```
559  *
560  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
561  */
562 abstract contract ERC165 is IERC165 {
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567         return interfaceId == type(IERC165).interfaceId;
568     }
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
572 
573 pragma solidity ^0.8.0;
574 
575 
576 
577 
578 
579 
580 
581 
582 /**
583  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
584  * the Metadata extension, but not including the Enumerable extension, which is available separately as
585  * {ERC721Enumerable}.
586  */
587 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
588     using Address for address;
589     using Strings for uint256;
590 
591     // Token name
592     string private _name;
593 
594     // Token symbol
595     string private _symbol;
596 
597     // Mapping from token ID to owner address
598     mapping(uint256 => address) private _owners;
599 
600     // Mapping owner address to token count
601     mapping(address => uint256) private _balances;
602 
603     // Mapping from token ID to approved address
604     mapping(uint256 => address) private _tokenApprovals;
605 
606     // Mapping from owner to operator approvals
607     mapping(address => mapping(address => bool)) private _operatorApprovals;
608 
609     /**
610      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
611      */
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615     }
616 
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
621         return
622             interfaceId == type(IERC721).interfaceId ||
623             interfaceId == type(IERC721Metadata).interfaceId ||
624             super.supportsInterface(interfaceId);
625     }
626 
627     /**
628      * @dev See {IERC721-balanceOf}.
629      */
630     function balanceOf(address owner) public view virtual override returns (uint256) {
631         require(owner != address(0), "ERC721: balance query for the zero address");
632         return _balances[owner];
633     }
634 
635     /**
636      * @dev See {IERC721-ownerOf}.
637      */
638     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
639         address owner = _owners[tokenId];
640         require(owner != address(0), "ERC721: owner query for nonexistent token");
641         return owner;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-name}.
646      */
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-symbol}.
653      */
654     function symbol() public view virtual override returns (string memory) {
655         return _symbol;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-tokenURI}.
660      */
661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
662         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
663 
664         string memory baseURI = _baseURI();
665         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
666     }
667 
668     /**
669      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
670      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
671      * by default, can be overriden in child contracts.
672      */
673     function _baseURI() internal view virtual returns (string memory) {
674         return "";
675     }
676 
677     /**
678      * @dev See {IERC721-approve}.
679      */
680     function approve(address to, uint256 tokenId) public virtual override {
681         address owner = ERC721.ownerOf(tokenId);
682         require(to != owner, "ERC721: approval to current owner");
683 
684         require(
685             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
686             "ERC721: approve caller is not owner nor approved for all"
687         );
688 
689         _approve(to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-getApproved}.
694      */
695     function getApproved(uint256 tokenId) public view virtual override returns (address) {
696         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
697 
698         return _tokenApprovals[tokenId];
699     }
700 
701     /**
702      * @dev See {IERC721-setApprovalForAll}.
703      */
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         require(operator != _msgSender(), "ERC721: approve to caller");
706 
707         _operatorApprovals[_msgSender()][operator] = approved;
708         emit ApprovalForAll(_msgSender(), operator, approved);
709     }
710 
711     /**
712      * @dev See {IERC721-isApprovedForAll}.
713      */
714     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
715         return _operatorApprovals[owner][operator];
716     }
717 
718     /**
719      * @dev See {IERC721-transferFrom}.
720      */
721     function transferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) public virtual override {
726         //solhint-disable-next-line max-line-length
727         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
728 
729         _transfer(from, to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-safeTransferFrom}.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         safeTransferFrom(from, to, tokenId, "");
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) public virtual override {
752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
753         _safeTransfer(from, to, tokenId, _data);
754     }
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
761      *
762      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
763      * implement alternative mechanisms to perform token transfer, such as signature-based.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeTransfer(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) internal virtual {
780         _transfer(from, to, tokenId);
781         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
782     }
783 
784     /**
785      * @dev Returns whether `tokenId` exists.
786      *
787      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
788      *
789      * Tokens start existing when they are minted (`_mint`),
790      * and stop existing when they are burned (`_burn`).
791      */
792     function _exists(uint256 tokenId) internal view virtual returns (bool) {
793         return _owners[tokenId] != address(0);
794     }
795 
796     /**
797      * @dev Returns whether `spender` is allowed to manage `tokenId`.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
804         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
805         address owner = ERC721.ownerOf(tokenId);
806         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
807     }
808 
809     /**
810      * @dev Safely mints `tokenId` and transfers it to `to`.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must not exist.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeMint(address to, uint256 tokenId) internal virtual {
820         _safeMint(to, tokenId, "");
821     }
822 
823     /**
824      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
825      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
826      */
827     function _safeMint(
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) internal virtual {
832         _mint(to, tokenId);
833         require(
834             _checkOnERC721Received(address(0), to, tokenId, _data),
835             "ERC721: transfer to non ERC721Receiver implementer"
836         );
837     }
838 
839     /**
840      * @dev Mints `tokenId` and transfers it to `to`.
841      *
842      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
843      *
844      * Requirements:
845      *
846      * - `tokenId` must not exist.
847      * - `to` cannot be the zero address.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _mint(address to, uint256 tokenId) internal virtual {
852         require(to != address(0), "ERC721: mint to the zero address");
853         require(!_exists(tokenId), "ERC721: token already minted");
854 
855         _beforeTokenTransfer(address(0), to, tokenId);
856 
857         _balances[to] += 1;
858         _owners[tokenId] = to;
859 
860         emit Transfer(address(0), to, tokenId);
861     }
862 
863     /**
864      * @dev Destroys `tokenId`.
865      * The approval is cleared when the token is burned.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _burn(uint256 tokenId) internal virtual {
874         address owner = ERC721.ownerOf(tokenId);
875 
876         _beforeTokenTransfer(owner, address(0), tokenId);
877 
878         // Clear approvals
879         _approve(address(0), tokenId);
880 
881         _balances[owner] -= 1;
882         delete _owners[tokenId];
883 
884         emit Transfer(owner, address(0), tokenId);
885     }
886 
887     /**
888      * @dev Transfers `tokenId` from `from` to `to`.
889      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must be owned by `from`.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _transfer(
899         address from,
900         address to,
901         uint256 tokenId
902     ) internal virtual {
903         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
904         require(to != address(0), "ERC721: transfer to the zero address");
905 
906         _beforeTokenTransfer(from, to, tokenId);
907 
908         // Clear approvals from the previous owner
909         _approve(address(0), tokenId);
910 
911         _balances[from] -= 1;
912         _balances[to] += 1;
913         _owners[tokenId] = to;
914 
915         emit Transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev Approve `to` to operate on `tokenId`
920      *
921      * Emits a {Approval} event.
922      */
923     function _approve(address to, uint256 tokenId) internal virtual {
924         _tokenApprovals[tokenId] = to;
925         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
926     }
927 
928     /**
929      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
930      * The call is not executed if the target address is not a contract.
931      *
932      * @param from address representing the previous owner of the given token ID
933      * @param to target address that will receive the tokens
934      * @param tokenId uint256 ID of the token to be transferred
935      * @param _data bytes optional data to send along with the call
936      * @return bool whether the call correctly returned the expected magic value
937      */
938     function _checkOnERC721Received(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) private returns (bool) {
944         if (to.isContract()) {
945             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
946                 return retval == IERC721Receiver.onERC721Received.selector;
947             } catch (bytes memory reason) {
948                 if (reason.length == 0) {
949                     revert("ERC721: transfer to non ERC721Receiver implementer");
950                 } else {
951                     assembly {
952                         revert(add(32, reason), mload(reason))
953                     }
954                 }
955             }
956         } else {
957             return true;
958         }
959     }
960 
961     /**
962      * @dev Hook that is called before any token transfer. This includes minting
963      * and burning.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` will be minted for `to`.
970      * - When `to` is zero, ``from``'s `tokenId` will be burned.
971      * - `from` and `to` are never both zero.
972      *
973      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
974      */
975     function _beforeTokenTransfer(
976         address from,
977         address to,
978         uint256 tokenId
979     ) internal virtual {}
980 }
981 
982 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
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
1012 pragma solidity ^0.8.0;
1013 
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
1172 // File: @openzeppelin/contracts/access/Ownable.sol
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 /**
1178  * @dev Contract module which provides a basic access control mechanism, where
1179  * there is an account (an owner) that can be granted exclusive access to
1180  * specific functions.
1181  *
1182  * By default, the owner account will be the one that deploys the contract. This
1183  * can later be changed with {transferOwnership}.
1184  *
1185  * This module is used through inheritance. It will make available the modifier
1186  * `onlyOwner`, which can be applied to your functions to restrict their use to
1187  * the owner.
1188  */
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _setOwner(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _setOwner(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _setOwner(newOwner);
1234     }
1235 
1236     function _setOwner(address newOwner) private {
1237         address oldOwner = _owner;
1238         _owner = newOwner;
1239         emit OwnershipTransferred(oldOwner, newOwner);
1240     }
1241 }
1242 
1243 // File: BVGARDEN.sol
1244 
1245 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1246 // File: @openzeppelin/contracts/access/Ownable.sol
1247 
1248 pragma solidity >=0.8.0;
1249 
1250 
1251 contract BVGARDEN is ERC721Enumerable, Ownable { using Strings for uint256;
1252 string public baseURI;
1253 string public baseExtension = ".json";
1254 string public notRevealedUri;
1255 uint256 public cost = 0.05 ether;
1256 uint256 public whiteListCost = 0 ether;
1257 uint256 public maxSupply = 4444;
1258 uint256 public maxMintAmount = 9;
1259 uint256 public whitelistedPerAddressLimit = 1; 
1260 uint256 public nftPerAddressLimit = 44;
1261 bool public paused = false;
1262 bool public revealed = false;
1263 bool public onlyWhitelisted = true;
1264 address[] public whitelistedAddresses; mapping(address => uint256) public
1265 addressMintedBalance;
1266 constructor(
1267 string memory _name,
1268 string memory _symbol,
1269 string memory _initBaseURI,
1270 string memory _initNotRevealedUri
1271 ) ERC721(_name, _symbol) { setBaseURI(_initBaseURI); setNotRevealedURI(_initNotRevealedUri);
1272 
1273 }
1274     // internal
1275     function _baseURI() internal view virtual override returns (string memory) {
1276         return baseURI; 
1277     }
1278    
1279     // public
1280         function isWhitelisted(address _user) public view returns (bool) {
1281         for (uint i = 0; i < whitelistedAddresses.length; i++) { 
1282             if (whitelistedAddresses[i] == _user) {
1283                 return true; 
1284             }
1285         }
1286         return false; 
1287     }
1288     function mint(uint256 _mintAmount) public payable {
1289         require(!paused, "the contract is paused");
1290         uint256 supply = totalSupply();
1291         require(_mintAmount > 0, "Mint at least 1 Flower"); require(_mintAmount <= maxMintAmount, "Flower limit exceeded");
1292         require(supply + _mintAmount <= maxSupply, "All Flowers have been minted"); uint256 userMintedCount = addressMintedBalance[msg.sender]; require(userMintedCount + _mintAmount <= nftPerAddressLimit, "No more flowers for u :)");
1293 
1294         if (msg.sender != owner()) { 
1295             if(onlyWhitelisted == true) {
1296                 require(isWhitelisted(msg.sender), "You are not whitelisted, please wait for public minting");
1297             
1298             uint256 whitelistedMintedCount = addressMintedBalance[msg.sender];
1299             require(whitelistedMintedCount + _mintAmount <= whitelistedPerAddressLimit, "1 whitelisted Flower per address only");
1300             }
1301         
1302        if(onlyWhitelisted == true) {
1303         require(msg.value >= whiteListCost * _mintAmount, "insufficient funds"); 
1304         }
1305         
1306         if(onlyWhitelisted == false) {
1307         require (msg.value >= cost * _mintAmount, "insufficient funds"); 
1308         }
1309     }
1310 
1311     for (uint256 i = 1; i <= _mintAmount; i++) { addressMintedBalance[msg.sender]++;
1312     _safeMint(msg.sender, supply + i); }
1313     }
1314 
1315 
1316     function walletOfOwner(address _owner) 
1317     public
1318     view
1319     returns (uint256[] memory)
1320     {
1321     uint256 ownerTokenCount = balanceOf(_owner); 
1322     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1323     for (uint256 i; i < ownerTokenCount; i++) {
1324         tokenIds[i] = tokenOfOwnerByIndex(_owner, i); 
1325     }
1326     return tokenIds; 
1327     }
1328     
1329     function tokenURI(uint256 tokenId) 
1330     public
1331     view
1332     virtual
1333     override
1334     returns (string memory)
1335     { 
1336     require(
1337         _exists(tokenId),
1338         "ERC721Metadata: URI query for nonexistent token" );
1339         if(revealed == false) {
1340         return notRevealedUri; }
1341         string memory currentBaseURI = _baseURI(); return bytes(currentBaseURI).length > 0
1342             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1343             : ""; 
1344     }
1345 
1346     //only owner
1347     function reveal() public onlyOwner() {
1348         revealed = true; 
1349     }
1350 
1351     function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1352         nftPerAddressLimit = _limit; 
1353     }
1354     function setCost(uint256 _newCost) public onlyOwner(){
1355         cost = _newCost;
1356     }
1357     
1358     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1359         maxMintAmount = _newmaxMintAmount; 
1360     }
1361 
1362     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1363         baseURI = _newBaseURI; 
1364     }
1365 
1366     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1367     baseExtension = _newBaseExtension;
1368     }
1369 
1370     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1371     notRevealedUri = _notRevealedURI; 
1372     }
1373 
1374     function pause(bool _state) public onlyOwner {
1375         paused = _state; 
1376     }
1377 
1378     function setOnlyWhitelisted(bool _state) public onlyOwner {
1379     onlyWhitelisted = _state; 
1380     }
1381 
1382     function whitelistUsers(address[] calldata _users) public onlyOwner {
1383     delete whitelistedAddresses;
1384     whitelistedAddresses = _users; 
1385     }
1386     
1387     function withdraw() public payable onlyOwner { (bool success, ) = payable(msg.sender).call{value:
1388         address(this).balance}("");
1389         require(success); 
1390     }
1391 }