1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
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
28 
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
30 
31 
32 pragma solidity ^0.8.0;
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
171 
172 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
173 
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
191      */
192     function onERC721Received(
193         address operator,
194         address from,
195         uint256 tokenId,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199 
200 
201 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
202 
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
208  * @dev See https://eips.ethereum.org/EIPS/eip-721
209  */
210 interface IERC721Metadata is IERC721 {
211     /**
212      * @dev Returns the token collection name.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the token collection symbol.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
223      */
224     function tokenURI(uint256 tokenId) external view returns (string memory);
225 }
226 
227 
228 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
229 
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize, which returns 0 for contracts in
256         // construction, since the code is only stored at the end of the
257         // constructor execution.
258 
259         uint256 size;
260         assembly {
261             size := extcodesize(account)
262         }
263         return size > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain `call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return _verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return _verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.delegatecall(data);
414         return _verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     function _verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) private pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 
441 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
442 
443 
444 pragma solidity ^0.8.0;
445 
446 /*
447  * @dev Provides information about the current execution context, including the
448  * sender of the transaction and its data. While these are generally available
449  * via msg.sender and msg.data, they should not be accessed in such a direct
450  * manner, since when dealing with meta-transactions the account sending and
451  * paying for execution may not be the actual sender (as far as an application
452  * is concerned).
453  *
454  * This contract is only required for intermediate, library-like contracts.
455  */
456 abstract contract Context {
457     function _msgSender() internal view virtual returns (address) {
458         return msg.sender;
459     }
460 
461     function _msgData() internal view virtual returns (bytes calldata) {
462         return msg.data;
463     }
464 }
465 
466 
467 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
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
535 
536 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
537 
538 
539 pragma solidity ^0.8.0;
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
564 
565 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
566 
567 
568 pragma solidity ^0.8.0;
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
699         require(operator != _msgSender(), "ERC721: approve to caller");
700 
701         _operatorApprovals[_msgSender()][operator] = approved;
702         emit ApprovalForAll(_msgSender(), operator, approved);
703     }
704 
705     /**
706      * @dev See {IERC721-isApprovedForAll}.
707      */
708     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
709         return _operatorApprovals[owner][operator];
710     }
711 
712     /**
713      * @dev See {IERC721-transferFrom}.
714      */
715     function transferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) public virtual override {
720         //solhint-disable-next-line max-line-length
721         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
722 
723         _transfer(from, to, tokenId);
724     }
725 
726     /**
727      * @dev See {IERC721-safeTransferFrom}.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         safeTransferFrom(from, to, tokenId, "");
735     }
736 
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) public virtual override {
746         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
747         _safeTransfer(from, to, tokenId, _data);
748     }
749 
750     /**
751      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
752      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
753      *
754      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
755      *
756      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
757      * implement alternative mechanisms to perform token transfer, such as signature-based.
758      *
759      * Requirements:
760      *
761      * - `from` cannot be the zero address.
762      * - `to` cannot be the zero address.
763      * - `tokenId` token must exist and be owned by `from`.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _safeTransfer(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) internal virtual {
774         _transfer(from, to, tokenId);
775         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
776     }
777 
778     /**
779      * @dev Returns whether `tokenId` exists.
780      *
781      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782      *
783      * Tokens start existing when they are minted (`_mint`),
784      * and stop existing when they are burned (`_burn`).
785      */
786     function _exists(uint256 tokenId) internal view virtual returns (bool) {
787         return _owners[tokenId] != address(0);
788     }
789 
790     /**
791      * @dev Returns whether `spender` is allowed to manage `tokenId`.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
798         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
799         address owner = ERC721.ownerOf(tokenId);
800         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
801     }
802 
803     /**
804      * @dev Safely mints `tokenId` and transfers it to `to`.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must not exist.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeMint(address to, uint256 tokenId) internal virtual {
814         _safeMint(to, tokenId, "");
815     }
816 
817     /**
818      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
819      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
820      */
821     function _safeMint(
822         address to,
823         uint256 tokenId,
824         bytes memory _data
825     ) internal virtual {
826         _mint(to, tokenId);
827         require(
828             _checkOnERC721Received(address(0), to, tokenId, _data),
829             "ERC721: transfer to non ERC721Receiver implementer"
830         );
831     }
832 
833     /**
834      * @dev Mints `tokenId` and transfers it to `to`.
835      *
836      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
837      *
838      * Requirements:
839      *
840      * - `tokenId` must not exist.
841      * - `to` cannot be the zero address.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _mint(address to, uint256 tokenId) internal virtual {
846         require(to != address(0), "ERC721: mint to the zero address");
847         require(!_exists(tokenId), "ERC721: token already minted");
848 
849         _beforeTokenTransfer(address(0), to, tokenId);
850 
851         _balances[to] += 1;
852         _owners[tokenId] = to;
853 
854         emit Transfer(address(0), to, tokenId);
855     }
856 
857     /**
858      * @dev Destroys `tokenId`.
859      * The approval is cleared when the token is burned.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _burn(uint256 tokenId) internal virtual {
868         address owner = ERC721.ownerOf(tokenId);
869 
870         _beforeTokenTransfer(owner, address(0), tokenId);
871 
872         // Clear approvals
873         _approve(address(0), tokenId);
874 
875         _balances[owner] -= 1;
876         delete _owners[tokenId];
877 
878         emit Transfer(owner, address(0), tokenId);
879     }
880 
881     /**
882      * @dev Transfers `tokenId` from `from` to `to`.
883      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
884      *
885      * Requirements:
886      *
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must be owned by `from`.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _transfer(
893         address from,
894         address to,
895         uint256 tokenId
896     ) internal virtual {
897         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
898         require(to != address(0), "ERC721: transfer to the zero address");
899 
900         _beforeTokenTransfer(from, to, tokenId);
901 
902         // Clear approvals from the previous owner
903         _approve(address(0), tokenId);
904 
905         _balances[from] -= 1;
906         _balances[to] += 1;
907         _owners[tokenId] = to;
908 
909         emit Transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev Approve `to` to operate on `tokenId`
914      *
915      * Emits a {Approval} event.
916      */
917     function _approve(address to, uint256 tokenId) internal virtual {
918         _tokenApprovals[tokenId] = to;
919         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
920     }
921 
922     /**
923      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
924      * The call is not executed if the target address is not a contract.
925      *
926      * @param from address representing the previous owner of the given token ID
927      * @param to target address that will receive the tokens
928      * @param tokenId uint256 ID of the token to be transferred
929      * @param _data bytes optional data to send along with the call
930      * @return bool whether the call correctly returned the expected magic value
931      */
932     function _checkOnERC721Received(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) private returns (bool) {
938         if (to.isContract()) {
939             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
940                 return retval == IERC721Receiver(to).onERC721Received.selector;
941             } catch (bytes memory reason) {
942                 if (reason.length == 0) {
943                     revert("ERC721: transfer to non ERC721Receiver implementer");
944                 } else {
945                     assembly {
946                         revert(add(32, reason), mload(reason))
947                     }
948                 }
949             }
950         } else {
951             return true;
952         }
953     }
954 
955     /**
956      * @dev Hook that is called before any token transfer. This includes minting
957      * and burning.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, ``from``'s `tokenId` will be burned.
965      * - `from` and `to` are never both zero.
966      *
967      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
968      */
969     function _beforeTokenTransfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {}
974 }
975 
976 
977 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
978 
979 
980 pragma solidity ^0.8.0;
981 
982 /**
983  * @dev Contract module which provides a basic access control mechanism, where
984  * there is an account (an owner) that can be granted exclusive access to
985  * specific functions.
986  *
987  * By default, the owner account will be the one that deploys the contract. This
988  * can later be changed with {transferOwnership}.
989  *
990  * This module is used through inheritance. It will make available the modifier
991  * `onlyOwner`, which can be applied to your functions to restrict their use to
992  * the owner.
993  */
994 abstract contract Ownable is Context {
995     address private _owner;
996 
997     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
998 
999     /**
1000      * @dev Initializes the contract setting the deployer as the initial owner.
1001      */
1002     constructor() {
1003         _setOwner(_msgSender());
1004     }
1005 
1006     /**
1007      * @dev Returns the address of the current owner.
1008      */
1009     function owner() public view virtual returns (address) {
1010         return _owner;
1011     }
1012 
1013     /**
1014      * @dev Throws if called by any account other than the owner.
1015      */
1016     modifier onlyOwner() {
1017         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1018         _;
1019     }
1020 
1021     /**
1022      * @dev Leaves the contract without owner. It will not be possible to call
1023      * `onlyOwner` functions anymore. Can only be called by the current owner.
1024      *
1025      * NOTE: Renouncing ownership will leave the contract without an owner,
1026      * thereby removing any functionality that is only available to the owner.
1027      */
1028     function renounceOwnership() public virtual onlyOwner {
1029         _setOwner(address(0));
1030     }
1031 
1032     /**
1033      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1034      * Can only be called by the current owner.
1035      */
1036     function transferOwnership(address newOwner) public virtual onlyOwner {
1037         require(newOwner != address(0), "Ownable: new owner is the zero address");
1038         _setOwner(newOwner);
1039     }
1040 
1041     function _setOwner(address newOwner) private {
1042         address oldOwner = _owner;
1043         _owner = newOwner;
1044         emit OwnershipTransferred(oldOwner, newOwner);
1045     }
1046 }
1047 
1048 
1049 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1050 
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 /**
1055  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1056  * @dev See https://eips.ethereum.org/EIPS/eip-721
1057  */
1058 interface IERC721Enumerable is IERC721 {
1059     /**
1060      * @dev Returns the total amount of tokens stored by the contract.
1061      */
1062     function totalSupply() external view returns (uint256);
1063 
1064     /**
1065      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1066      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1069 
1070     /**
1071      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1072      * Use along with {totalSupply} to enumerate all tokens.
1073      */
1074     function tokenByIndex(uint256 index) external view returns (uint256);
1075 }
1076 
1077 
1078 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1079 
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 
1084 /**
1085  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1086  * enumerability of all the token ids in the contract as well as all token ids owned by each
1087  * account.
1088  */
1089 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1090     // Mapping from owner to list of owned token IDs
1091     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1092 
1093     // Mapping from token ID to index of the owner tokens list
1094     mapping(uint256 => uint256) private _ownedTokensIndex;
1095 
1096     // Array with all token ids, used for enumeration
1097     uint256[] private _allTokens;
1098 
1099     // Mapping from token id to position in the allTokens array
1100     mapping(uint256 => uint256) private _allTokensIndex;
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1106         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1111      */
1112     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1113         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1114         return _ownedTokens[owner][index];
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Enumerable-totalSupply}.
1119      */
1120     function totalSupply() public view virtual override returns (uint256) {
1121         return _allTokens.length;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Enumerable-tokenByIndex}.
1126      */
1127     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1128         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1129         return _allTokens[index];
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before any token transfer. This includes minting
1134      * and burning.
1135      *
1136      * Calling conditions:
1137      *
1138      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1139      * transferred to `to`.
1140      * - When `from` is zero, `tokenId` will be minted for `to`.
1141      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1142      * - `from` cannot be the zero address.
1143      * - `to` cannot be the zero address.
1144      *
1145      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1146      */
1147     function _beforeTokenTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual override {
1152         super._beforeTokenTransfer(from, to, tokenId);
1153 
1154         if (from == address(0)) {
1155             _addTokenToAllTokensEnumeration(tokenId);
1156         } else if (from != to) {
1157             _removeTokenFromOwnerEnumeration(from, tokenId);
1158         }
1159         if (to == address(0)) {
1160             _removeTokenFromAllTokensEnumeration(tokenId);
1161         } else if (to != from) {
1162             _addTokenToOwnerEnumeration(to, tokenId);
1163         }
1164     }
1165 
1166     /**
1167      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1168      * @param to address representing the new owner of the given token ID
1169      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1170      */
1171     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1172         uint256 length = ERC721.balanceOf(to);
1173         _ownedTokens[to][length] = tokenId;
1174         _ownedTokensIndex[tokenId] = length;
1175     }
1176 
1177     /**
1178      * @dev Private function to add a token to this extension's token tracking data structures.
1179      * @param tokenId uint256 ID of the token to be added to the tokens list
1180      */
1181     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1182         _allTokensIndex[tokenId] = _allTokens.length;
1183         _allTokens.push(tokenId);
1184     }
1185 
1186     /**
1187      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1188      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1189      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1190      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1191      * @param from address representing the previous owner of the given token ID
1192      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1193      */
1194     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1195         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1196         // then delete the last slot (swap and pop).
1197 
1198         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1199         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1200 
1201         // When the token to delete is the last token, the swap operation is unnecessary
1202         if (tokenIndex != lastTokenIndex) {
1203             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1204 
1205             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1206             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1207         }
1208 
1209         // This also deletes the contents at the last position of the array
1210         delete _ownedTokensIndex[tokenId];
1211         delete _ownedTokens[from][lastTokenIndex];
1212     }
1213 
1214     /**
1215      * @dev Private function to remove a token from this extension's token tracking data structures.
1216      * This has O(1) time complexity, but alters the order of the _allTokens array.
1217      * @param tokenId uint256 ID of the token to be removed from the tokens list
1218      */
1219     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1220         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1221         // then delete the last slot (swap and pop).
1222 
1223         uint256 lastTokenIndex = _allTokens.length - 1;
1224         uint256 tokenIndex = _allTokensIndex[tokenId];
1225 
1226         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1227         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1228         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1229         uint256 lastTokenId = _allTokens[lastTokenIndex];
1230 
1231         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1232         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1233 
1234         // This also deletes the contents at the last position of the array
1235         delete _allTokensIndex[tokenId];
1236         _allTokens.pop();
1237     }
1238 }
1239 
1240 
1241 // File contracts/Whales.sol
1242 
1243 
1244 /*
1245                                           «∩ⁿ─╖
1246                                        ⌐  ╦╠Σ▌╓┴                        .⌐─≈-,
1247                                 ≤╠╠╠╫╕╬╦╜              ┌"░░░░░░░░░░≈╖φ░╔╦╬░░Σ╜^
1248                                ¼,╠.:╬╬╦╖╔≡p               "╙φ░ ╠╩╚`  ░╩░╟╓╜
1249                                    Γ╠▀╬═┘`                         Θ Å░▄
1250                       ,,,,,        ┌#                             ]  ▌░░╕
1251              ,-─S╜" ,⌐"",`░░φ░░░░S>╫▐                             ╩  ░░░░¼
1252             ╙ⁿ═s, <░φ╬░░φù ░░░░░░░░╬╠░░"Zw,                    ,─╓φ░Å░░╩╧w¼
1253             ∩²≥┴╝δ»╬░╝░░╩░╓║╙░░░░░░Åφ▄φ░░╦≥░⌠░≥╖,          ,≈"╓φ░░░╬╬░░╕ {⌐\
1254             } ▐      ½,#░░░░░╦╚░░╬╜Σ░p╠░░╬╘░░░░╩  ^"¥7"""░"¬╖╠░░░#▒░░░╩ φ╩ ∩
1255               Γ      ╬░⌐"╢╙φ░░▒╬╓╓░░░░▄▄╬▄░╬░░Å░░░░╠░╦,φ╠░░░░░░-"╠░╩╩  ê░Γ╠
1256              ╘░,,   ╠╬     '░╗Σ╢░░░░░░▀╢▓▒▒╬╬░╦#####≥╨░░░╝╜╙` ,φ╬░░░. é░░╔⌐
1257               ▐░ `^Σ░▒╗,   ▐░░░░░ ▒░"╙Σ░╨▀╜╬░▓▓▓▓▓▓▀▀░»φ░N  ╔╬▒░░░"`,╬≥░░╢
1258                \  ╠░░░░░░╬#╩╣▄░Γ, ▐░,φ╬▄Å` ░ ```"╚░░░░,╓▄▄▄╬▀▀░╠╙░╔╬░░░ ½"
1259                 └ '░░░░░░╦╠ ╟▒M╗▄▄,▄▄▄╗#▒╬▒╠"╙╙╙╙╙╙╢▒▒▓▀▀░░░░░╠╦#░░░░╚,╩
1260                   ¼░░░░░░░⌂╦ ▀░░░╚╙░╚▓▒▀░░░½░░╠╜   ╘▀░░░╩╩╩,▄╣╬░░░░░╙╔╩
1261                     ╢^╙╨╠░░▄æ,Σ ",╓╥m╬░░░░░░░Θ░φ░φ▄ ╬╬░,▄#▒▀░░░░░≥░░#`
1262                       *╓,╙φ░░░░░#░░░░░░░#╬╠╩ ╠╩╚╠╟▓▄╣▒▓╬▓▀░░░░░╩░╓═^
1263                           `"╜╧Σ░░░Σ░░░░░░╬▓µ ─"░░░░░░░░░░╜░╬▄≈"
1264                                     `"╙╜╜╜╝╩ÅΣM≡,`╙╚░╙╙░╜|  ╙╙╙┴7≥╗
1265                                                    `"┴╙¬¬¬┴┴╙╙╙╙""
1266 */
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 
1272 contract Whales is ERC721, ERC721Enumerable, Ownable {
1273 
1274     string public PROVENANCE;
1275     uint256 public constant tokenPrice = 50000000000000000; // 0.05 ETH
1276     uint public constant maxTokenPurchase = 10;
1277     uint256 public MAX_TOKENS = 10000;
1278     bool public saleIsActive = false;
1279 
1280     string private _baseURIextended;
1281 
1282     constructor() ERC721("Secret Society of Whales", "SSOW") {
1283     }
1284 
1285     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1286         super._beforeTokenTransfer(from, to, tokenId);
1287     }
1288 
1289     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1290         return super.supportsInterface(interfaceId);
1291     }
1292 
1293     function setBaseURI(string memory baseURI_) external onlyOwner() {
1294         _baseURIextended = baseURI_;
1295     }
1296 
1297     function _baseURI() internal view virtual override returns (string memory) {
1298         return _baseURIextended;
1299     }
1300 
1301     function setProvenance(string memory provenance) public onlyOwner {
1302         PROVENANCE = provenance;
1303     }
1304 
1305     function reserveTokens() public onlyOwner {
1306         uint supply = totalSupply();
1307         require(supply < 200, "More than 200 tokens have already been reserved or minted.");
1308         uint i;
1309         for (i = 0; i < 100; i++) {
1310             _safeMint(msg.sender, supply + i);
1311         }
1312     }
1313 
1314     function flipSaleState() public onlyOwner {
1315         saleIsActive = !saleIsActive;
1316     }
1317 
1318     function mintToken(uint numberOfTokens) public payable {
1319         require(saleIsActive, "Sale must be active to mint Tokens");
1320         require(numberOfTokens <= maxTokenPurchase, "Exceeded max token purchase");
1321         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply of tokens");
1322         require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1323 
1324         for(uint i = 0; i < numberOfTokens; i++) {
1325             uint mintIndex = totalSupply();
1326             if (totalSupply() < MAX_TOKENS) {
1327                 _safeMint(msg.sender, mintIndex);
1328             }
1329         }
1330     }
1331 
1332     function withdraw() public onlyOwner {
1333         uint balance = address(this).balance;
1334         payable(msg.sender).transfer(balance);
1335     }
1336 
1337 }