1 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
172 
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
200 
201 pragma solidity ^0.8.0;
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 // File: node_modules\@openzeppelin\contracts\utils\Address.
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
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
442 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
443 
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Provides information about the current execution context, including the
449  * sender of the transaction and its data. While these are generally available
450  * via msg.sender and msg.data, they should not be accessed in such a direct
451  * manner, since when dealing with meta-transactions the account sending and
452  * paying for execution may not be the actual sender (as far as an application
453  * is concerned).
454  *
455  * This contract is only required for intermediate, library-like contracts.
456  */
457 abstract contract Context {
458     function _msgSender() internal view virtual returns (address) {
459         return msg.sender;
460     }
461 
462     function _msgData() internal view virtual returns (bytes calldata) {
463         return msg.data;
464     }
465 }
466 
467 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
468 
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev String operations.
474  */
475 library Strings {
476     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
480      */
481     function toString(uint256 value) internal pure returns (string memory) {
482         // Inspired by OraclizeAPI's implementation - MIT licence
483         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
484 
485         if (value == 0) {
486             return "0";
487         }
488         uint256 temp = value;
489         uint256 digits;
490         while (temp != 0) {
491             digits++;
492             temp /= 10;
493         }
494         bytes memory buffer = new bytes(digits);
495         while (value != 0) {
496             digits -= 1;
497             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
498             value /= 10;
499         }
500         return string(buffer);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
505      */
506     function toHexString(uint256 value) internal pure returns (string memory) {
507         if (value == 0) {
508             return "0x00";
509         }
510         uint256 temp = value;
511         uint256 length = 0;
512         while (temp != 0) {
513             length++;
514             temp >>= 8;
515         }
516         return toHexString(value, length);
517     }
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
521      */
522     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
523         bytes memory buffer = new bytes(2 * length + 2);
524         buffer[0] = "0";
525         buffer[1] = "x";
526         for (uint256 i = 2 * length + 1; i > 1; --i) {
527             buffer[i] = _HEX_SYMBOLS[value & 0xf];
528             value >>= 4;
529         }
530         require(value == 0, "Strings: hex length insufficient");
531         return string(buffer);
532     }
533 }
534 
535 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
536 
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Implementation of the {IERC165} interface.
543  *
544  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
545  * for the additional interface id that will be supported. For example:
546  *
547  * ```solidity
548  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
550  * }
551  * ```
552  *
553  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
554  */
555 abstract contract ERC165 is IERC165 {
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol
565 
566 
567 pragma solidity ^0.8.0;
568 
569 
570 
571 
572 
573 
574 
575 
576 /**
577  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
578  * the Metadata extension, but not including the Enumerable extension, which is available separately as
579  * {ERC721Enumerable}.
580  */
581 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
582     using Address for address;
583     using Strings for uint256;
584 
585     // Token name
586     string private _name;
587 
588     // Token symbol
589     string private _symbol;
590 
591     // Mapping from token ID to owner address
592     mapping(uint256 => address) private _owners;
593 
594     // Mapping owner address to token count
595     mapping(address => uint256) private _balances;
596 
597     // Mapping from token ID to approved address
598     mapping(uint256 => address) private _tokenApprovals;
599 
600     // Mapping from owner to operator approvals
601     mapping(address => mapping(address => bool)) private _operatorApprovals;
602 
603     /**
604      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
605      */
606     constructor(string memory name_, string memory symbol_) {
607         _name = name_;
608         _symbol = symbol_;
609     }
610 
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
615         return
616             interfaceId == type(IERC721).interfaceId ||
617             interfaceId == type(IERC721Metadata).interfaceId ||
618             super.supportsInterface(interfaceId);
619     }
620 
621     /**
622      * @dev See {IERC721-balanceOf}.
623      */
624     function balanceOf(address owner) public view virtual override returns (uint256) {
625         require(owner != address(0), "ERC721: balance query for the zero address");
626         return _balances[owner];
627     }
628 
629     /**
630      * @dev See {IERC721-ownerOf}.
631      */
632     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
633         address owner = _owners[tokenId];
634         require(owner != address(0), "ERC721: owner query for nonexistent token");
635         return owner;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-name}.
640      */
641     function name() public view virtual override returns (string memory) {
642         return _name;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-symbol}.
647      */
648     function symbol() public view virtual override returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-tokenURI}.
654      */
655     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
656         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
657 
658         string memory baseURI = _baseURI();
659         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
660     }
661 
662     /**
663      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
664      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
665      * by default, can be overriden in child contracts.
666      */
667     function _baseURI() internal view virtual returns (string memory) {
668         return "";
669     }
670 
671     /**
672      * @dev See {IERC721-approve}.
673      */
674     function approve(address to, uint256 tokenId) public virtual override {
675         address owner = ERC721.ownerOf(tokenId);
676         require(to != owner, "ERC721: approval to current owner");
677 
678         require(
679             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
680             "ERC721: approve caller is not owner nor approved for all"
681         );
682 
683         _approve(to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-getApproved}.
688      */
689     function getApproved(uint256 tokenId) public view virtual override returns (address) {
690         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
691 
692         return _tokenApprovals[tokenId];
693     }
694 
695     /**
696      * @dev See {IERC721-setApprovalForAll}.
697      */
698     function setApprovalForAll(address operator, bool approved) public virtual override {
699         _setApprovalForAll(_msgSender(), operator, approved);
700     }
701 
702     /**
703      * @dev See {IERC721-isApprovedForAll}.
704      */
705     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
706         return _operatorApprovals[owner][operator];
707     }
708 
709     /**
710      * @dev See {IERC721-transferFrom}.
711      */
712     function transferFrom(
713         address from,
714         address to,
715         uint256 tokenId
716     ) public virtual override {
717         //solhint-disable-next-line max-line-length
718         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
719 
720         _transfer(from, to, tokenId);
721     }
722 
723     /**
724      * @dev See {IERC721-safeTransferFrom}.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId
730     ) public virtual override {
731         safeTransferFrom(from, to, tokenId, "");
732     }
733 
734     /**
735      * @dev See {IERC721-safeTransferFrom}.
736      */
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId,
741         bytes memory _data
742     ) public virtual override {
743         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
744         _safeTransfer(from, to, tokenId, _data);
745     }
746 
747     /**
748      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
749      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
750      *
751      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
752      *
753      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
754      * implement alternative mechanisms to perform token transfer, such as signature-based.
755      *
756      * Requirements:
757      *
758      * - `from` cannot be the zero address.
759      * - `to` cannot be the zero address.
760      * - `tokenId` token must exist and be owned by `from`.
761      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _safeTransfer(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) internal virtual {
771         _transfer(from, to, tokenId);
772         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
773     }
774 
775     /**
776      * @dev Returns whether `tokenId` exists.
777      *
778      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
779      *
780      * Tokens start existing when they are minted (`_mint`),
781      * and stop existing when they are burned (`_burn`).
782      */
783     function _exists(uint256 tokenId) internal view virtual returns (bool) {
784         return _owners[tokenId] != address(0);
785     }
786 
787     /**
788      * @dev Returns whether `spender` is allowed to manage `tokenId`.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      */
794     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
795         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
796         address owner = ERC721.ownerOf(tokenId);
797         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
798     }
799 
800     /**
801      * @dev Safely mints `tokenId` and transfers it to `to`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must not exist.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _safeMint(address to, uint256 tokenId) internal virtual {
811         _safeMint(to, tokenId, "");
812     }
813 
814     /**
815      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
816      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
817      */
818     function _safeMint(
819         address to,
820         uint256 tokenId,
821         bytes memory _data
822     ) internal virtual {
823         _mint(to, tokenId);
824         require(
825             _checkOnERC721Received(address(0), to, tokenId, _data),
826             "ERC721: transfer to non ERC721Receiver implementer"
827         );
828     }
829 
830     /**
831      * @dev Mints `tokenId` and transfers it to `to`.
832      *
833      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
834      *
835      * Requirements:
836      *
837      * - `tokenId` must not exist.
838      * - `to` cannot be the zero address.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _mint(address to, uint256 tokenId) internal virtual {
843         require(to != address(0), "ERC721: mint to the zero address");
844         require(!_exists(tokenId), "ERC721: token already minted");
845 
846         _beforeTokenTransfer(address(0), to, tokenId);
847 
848         _balances[to] += 1;
849         _owners[tokenId] = to;
850 
851         emit Transfer(address(0), to, tokenId);
852     }
853 
854     /**
855      * @dev Destroys `tokenId`.
856      * The approval is cleared when the token is burned.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must exist.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _burn(uint256 tokenId) internal virtual {
865         address owner = ERC721.ownerOf(tokenId);
866 
867         _beforeTokenTransfer(owner, address(0), tokenId);
868 
869         // Clear approvals
870         _approve(address(0), tokenId);
871 
872         _balances[owner] -= 1;
873         delete _owners[tokenId];
874 
875         emit Transfer(owner, address(0), tokenId);
876     }
877 
878     /**
879      * @dev Transfers `tokenId` from `from` to `to`.
880      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
881      *
882      * Requirements:
883      *
884      * - `to` cannot be the zero address.
885      * - `tokenId` token must be owned by `from`.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _transfer(
890         address from,
891         address to,
892         uint256 tokenId
893     ) internal virtual {
894         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
895         require(to != address(0), "ERC721: transfer to the zero address");
896 
897         _beforeTokenTransfer(from, to, tokenId);
898 
899         // Clear approvals from the previous owner
900         _approve(address(0), tokenId);
901 
902         _balances[from] -= 1;
903         _balances[to] += 1;
904         _owners[tokenId] = to;
905 
906         emit Transfer(from, to, tokenId);
907     }
908 
909     /**
910      * @dev Approve `to` to operate on `tokenId`
911      *
912      * Emits a {Approval} event.
913      */
914     function _approve(address to, uint256 tokenId) internal virtual {
915         _tokenApprovals[tokenId] = to;
916         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
917     }
918 
919     /**
920      * @dev Approve `operator` to operate on all of `owner` tokens
921      *
922      * Emits a {ApprovalForAll} event.
923      */
924     function _setApprovalForAll(
925         address owner,
926         address operator,
927         bool approved
928     ) internal virtual {
929         require(owner != operator, "ERC721: approve to caller");
930         _operatorApprovals[owner][operator] = approved;
931         emit ApprovalForAll(owner, operator, approved);
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
988 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
989 
990 
991 pragma solidity ^0.8.0;
992 
993 
994 /**
995  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
996  * @dev See https://eips.ethereum.org/EIPS/eip-721
997  */
998 interface IERC721Enumerable is IERC721 {
999     /**
1000      * @dev Returns the total amount of tokens stored by the contract.
1001      */
1002     function totalSupply() external view returns (uint256);
1003 
1004     /**
1005      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1006      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1007      */
1008     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1009 
1010     /**
1011      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1012      * Use along with {totalSupply} to enumerate all tokens.
1013      */
1014     function tokenByIndex(uint256 index) external view returns (uint256);
1015 }
1016 
1017 // File: @openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1018 
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 
1024 /**
1025  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1026  * enumerability of all the token ids in the contract as well as all token ids owned by each
1027  * account.
1028  */
1029 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1030     // Mapping from owner to list of owned token IDs
1031     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1032 
1033     // Mapping from token ID to index of the owner tokens list
1034     mapping(uint256 => uint256) private _ownedTokensIndex;
1035 
1036     // Array with all token ids, used for enumeration
1037     uint256[] private _allTokens;
1038 
1039     // Mapping from token id to position in the allTokens array
1040     mapping(uint256 => uint256) private _allTokensIndex;
1041 
1042     /**
1043      * @dev See {IERC165-supportsInterface}.
1044      */
1045     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1046         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1051      */
1052     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1053         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1054         return _ownedTokens[owner][index];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-totalSupply}.
1059      */
1060     function totalSupply() public view virtual override returns (uint256) {
1061         return _allTokens.length;
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-tokenByIndex}.
1066      */
1067     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1068         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1069         return _allTokens[index];
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any token transfer. This includes minting
1074      * and burning.
1075      *
1076      * Calling conditions:
1077      *
1078      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1079      * transferred to `to`.
1080      * - When `from` is zero, `tokenId` will be minted for `to`.
1081      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual override {
1092         super._beforeTokenTransfer(from, to, tokenId);
1093 
1094         if (from == address(0)) {
1095             _addTokenToAllTokensEnumeration(tokenId);
1096         } else if (from != to) {
1097             _removeTokenFromOwnerEnumeration(from, tokenId);
1098         }
1099         if (to == address(0)) {
1100             _removeTokenFromAllTokensEnumeration(tokenId);
1101         } else if (to != from) {
1102             _addTokenToOwnerEnumeration(to, tokenId);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1108      * @param to address representing the new owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1110      */
1111     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1112         uint256 length = ERC721.balanceOf(to);
1113         _ownedTokens[to][length] = tokenId;
1114         _ownedTokensIndex[tokenId] = length;
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's token tracking data structures.
1119      * @param tokenId uint256 ID of the token to be added to the tokens list
1120      */
1121     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1122         _allTokensIndex[tokenId] = _allTokens.length;
1123         _allTokens.push(tokenId);
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1128      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1129      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1130      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1131      * @param from address representing the previous owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1133      */
1134     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1135         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1136         // then delete the last slot (swap and pop).
1137 
1138         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1139         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1140 
1141         // When the token to delete is the last token, the swap operation is unnecessary
1142         if (tokenIndex != lastTokenIndex) {
1143             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1144 
1145             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1146             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1147         }
1148 
1149         // This also deletes the contents at the last position of the array
1150         delete _ownedTokensIndex[tokenId];
1151         delete _ownedTokens[from][lastTokenIndex];
1152     }
1153 
1154     /**
1155      * @dev Private function to remove a token from this extension's token tracking data structures.
1156      * This has O(1) time complexity, but alters the order of the _allTokens array.
1157      * @param tokenId uint256 ID of the token to be removed from the tokens list
1158      */
1159     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1160         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1161         // then delete the last slot (swap and pop).
1162 
1163         uint256 lastTokenIndex = _allTokens.length - 1;
1164         uint256 tokenIndex = _allTokensIndex[tokenId];
1165 
1166         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1167         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1168         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1169         uint256 lastTokenId = _allTokens[lastTokenIndex];
1170 
1171         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173 
1174         // This also deletes the contents at the last position of the array
1175         delete _allTokensIndex[tokenId];
1176         _allTokens.pop();
1177     }
1178 }
1179 
1180 // File: @openzeppelin\contracts\access\Ownable.sol
1181 
1182 pragma solidity ^0.8.0;
1183 
1184 
1185 /**
1186  * @dev Contract module which provides a basic access control mechanism, where
1187  * there is an account (an owner) that can be granted exclusive access to
1188  * specific functions.
1189  *
1190  * By default, the owner account will be the one that deploys the contract. This
1191  * can later be changed with {transferOwnership}.
1192  *
1193  * This module is used through inheritance. It will make available the modifier
1194  * `onlyOwner`, which can be applied to your functions to restrict their use to
1195  * the owner.
1196  */
1197 abstract contract Ownable is Context {
1198     address private _owner;
1199 
1200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1201 
1202     /**
1203      * @dev Initializes the contract setting the deployer as the initial owner.
1204      */
1205     constructor() {
1206         _transferOwnership(_msgSender());
1207     }
1208 
1209     /**
1210      * @dev Returns the address of the current owner.
1211      */
1212     function owner() public view virtual returns (address) {
1213         return _owner;
1214     }
1215 
1216     /**
1217      * @dev Throws if called by any account other than the owner.
1218      */
1219     modifier onlyOwner() {
1220         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1221         _;
1222     }
1223 
1224     /**
1225      * @dev Leaves the contract without owner. It will not be possible to call
1226      * `onlyOwner` functions anymore. Can only be called by the current owner.
1227      *
1228      * NOTE: Renouncing ownership will leave the contract without an owner,
1229      * thereby removing any functionality that is only available to the owner.
1230      */
1231     function renounceOwnership() public virtual onlyOwner {
1232         _transferOwnership(address(0));
1233     }
1234 
1235     /**
1236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1237      * Can only be called by the current owner.
1238      */
1239     function transferOwnership(address newOwner) public virtual onlyOwner {
1240         require(newOwner != address(0), "Ownable: new owner is the zero address");
1241         _transferOwnership(newOwner);
1242     }
1243 
1244     /**
1245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1246      * Internal function without access restriction.
1247      */
1248     function _transferOwnership(address newOwner) internal virtual {
1249         address oldOwner = _owner;
1250         _owner = newOwner;
1251         emit OwnershipTransferred(oldOwner, newOwner);
1252     }
1253 }
1254 
1255 // File: contracts\SmartContract.sol
1256 
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 
1262 contract Drifters is ERC721Enumerable, Ownable {
1263   using Strings for uint256;
1264 
1265   string public baseURI;
1266   string public baseExtension = ".json";
1267   uint256 public cost = .05 * 10 ** 18;
1268   uint256 public maxSupply = 3000;
1269   uint256 public maxMintAmount = 3;
1270 
1271   bool public revealed = false;
1272   string public hiddenBaseUri = "ipfs://QmdXauRVaGbFHmTeZhVnfXA4uAfH7NUTctnDYjsAHCdeyC/hidden.json";
1273 
1274   // Private Sale
1275   bool public isPrivateSaleActive;
1276   mapping(address => uint256) public whitelisted;
1277   mapping(address => uint256) public privateSaleTracker;
1278 
1279 
1280   bool public isPublicSaleActive;
1281 
1282   constructor(
1283     string memory _name,
1284     string memory _symbol,
1285     string memory _initBaseURI
1286   ) ERC721(_name, _symbol) {
1287     isPrivateSaleActive = true;
1288     isPublicSaleActive = false;
1289     setBaseURI(_initBaseURI);
1290     legendaryPlaceholder(10);
1291   }
1292 
1293   function _baseURI() internal view virtual override returns (string memory) {
1294     return baseURI;
1295   }
1296 
1297 
1298   function legendaryPlaceholder(uint256 _mintAmount) public payable onlyOwner {
1299     uint256 supply = totalSupply();
1300 
1301     _safeMint(msg.sender, 0);    
1302     for (uint256 i = 1; i <= _mintAmount; i++) {
1303       _safeMint(msg.sender, supply + i);
1304     }
1305   }
1306   
1307   function publicMint(uint256 _mintAmount) public payable {
1308     uint256 supply = totalSupply();
1309     require(isPublicSaleActive);
1310     require(_mintAmount > 0);
1311     require(_mintAmount <= maxMintAmount);
1312     require(supply + _mintAmount <= maxSupply);
1313     require(msg.value >= cost * _mintAmount);
1314 
1315     for (uint256 i = 1; i <= _mintAmount; i++) {
1316       _safeMint(msg.sender, supply + i);
1317     }
1318   }
1319 
1320   function togglePrivateSaleState() public onlyOwner{
1321     isPrivateSaleActive = !isPrivateSaleActive;
1322   }
1323 
1324   function privateMint(uint256 _mintAmount) public payable {
1325     uint256 supply = totalSupply();
1326     uint maxPrivateMintAmount = whitelisted[msg.sender];
1327     require(isPrivateSaleActive);
1328     require(_mintAmount > 0);
1329     require(_mintAmount <= maxPrivateMintAmount);
1330     require(privateSaleTracker[msg.sender] < maxPrivateMintAmount);
1331     require(whitelisted[msg.sender] > 0);
1332     require(privateSaleTracker[msg.sender] + _mintAmount <= maxPrivateMintAmount);
1333 
1334     
1335     for (uint256 i = 1; i <= _mintAmount; i++) {
1336       _safeMint(msg.sender, supply + i);
1337       privateSaleTracker[msg.sender] = privateSaleTracker[msg.sender] + 1;
1338     }
1339     
1340   }
1341 
1342   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1343   {
1344     uint256 ownerTokenCount = balanceOf(_owner);
1345     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1346     for (uint256 i; i < ownerTokenCount; i++) {
1347       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1348     }
1349     return tokenIds;
1350   }
1351 
1352   function tokenURI(uint256 tokenId)
1353     public
1354     view
1355     virtual
1356     override
1357     returns (string memory)
1358   {
1359     require(
1360       _exists(tokenId),
1361       "ERC721Metadata: URI query for nonexistent token"
1362     );
1363     if(!revealed){
1364         return string(abi.encodePacked(hiddenBaseUri));
1365     }
1366     string memory currentBaseURI = _baseURI();
1367     return bytes(currentBaseURI).length > 0
1368         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1369         : "";
1370   }
1371 
1372   //only owner
1373   function setCost(uint256 _newCost) public onlyOwner() {
1374     cost = _newCost;
1375   }
1376 
1377   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1378     maxMintAmount = _newmaxMintAmount;
1379   }
1380 
1381   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1382     baseURI = _newBaseURI;
1383   }
1384 
1385   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1386     baseExtension = _newBaseExtension;
1387   }
1388 
1389   function togglePublicSaleState() public onlyOwner {
1390     isPublicSaleActive = !isPublicSaleActive;
1391   }
1392  
1393  function whitelistUsers(address[] memory _addresses, uint256[] memory _limit) public onlyOwner {
1394     for (uint256 i = 0; i < _addresses.length; i++) {
1395         whitelisted[_addresses[i]] = _limit[i];
1396     }
1397   }
1398 
1399   function removeWhitelistUsers(address[] memory _addresses) public onlyOwner {
1400     for (uint256 i = 0; i < _addresses.length; i++) {
1401         whitelisted[_addresses[i]] = 0;
1402     }
1403   }
1404   
1405   function mintsLeft(address _address) public view returns (uint256){
1406       return whitelisted[_address] - privateSaleTracker[_address];
1407   }
1408 
1409   function withdraw() public payable onlyOwner {
1410     require(payable(msg.sender).send(address(this).balance));
1411   }
1412 
1413   function toggleReaveal() public onlyOwner {
1414     revealed = !revealed;
1415   }
1416 
1417   function setHiddenUri(string memory newHiddenBaseUri) public onlyOwner {
1418       hiddenBaseUri = newHiddenBaseUri;
1419   }
1420 }