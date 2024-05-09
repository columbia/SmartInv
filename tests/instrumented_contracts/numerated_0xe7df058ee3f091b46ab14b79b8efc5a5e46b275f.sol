1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
4 
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
29 
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
31 
32 
33 pragma solidity ^0.8.0;
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
172 
173 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
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
201 
202 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
203 
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Metadata is IERC721 {
212     /**
213      * @dev Returns the token collection name.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the token collection symbol.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
224      */
225     function tokenURI(uint256 tokenId) external view returns (string memory);
226 }
227 
228 
229 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
230 
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 
448 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
449 
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
474 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
475 
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev String operations.
481  */
482 library Strings {
483     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
487      */
488     function toString(uint256 value) internal pure returns (string memory) {
489         // Inspired by OraclizeAPI's implementation - MIT licence
490         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
491 
492         if (value == 0) {
493             return "0";
494         }
495         uint256 temp = value;
496         uint256 digits;
497         while (temp != 0) {
498             digits++;
499             temp /= 10;
500         }
501         bytes memory buffer = new bytes(digits);
502         while (value != 0) {
503             digits -= 1;
504             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
505             value /= 10;
506         }
507         return string(buffer);
508     }
509 
510     /**
511      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
512      */
513     function toHexString(uint256 value) internal pure returns (string memory) {
514         if (value == 0) {
515             return "0x00";
516         }
517         uint256 temp = value;
518         uint256 length = 0;
519         while (temp != 0) {
520             length++;
521             temp >>= 8;
522         }
523         return toHexString(value, length);
524     }
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
528      */
529     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
530         bytes memory buffer = new bytes(2 * length + 2);
531         buffer[0] = "0";
532         buffer[1] = "x";
533         for (uint256 i = 2 * length + 1; i > 1; --i) {
534             buffer[i] = _HEX_SYMBOLS[value & 0xf];
535             value >>= 4;
536         }
537         require(value == 0, "Strings: hex length insufficient");
538         return string(buffer);
539     }
540 }
541 
542 
543 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
544 
545 
546 pragma solidity ^0.8.0;
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
571 
572 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
573 
574 
575 pragma solidity ^0.8.0;
576 
577 
578 
579 
580 
581 
582 
583 /**
584  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
585  * the Metadata extension, but not including the Enumerable extension, which is available separately as
586  * {ERC721Enumerable}.
587  */
588 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
589     using Address for address;
590     using Strings for uint256;
591 
592     // Token name
593     string private _name;
594 
595     // Token symbol
596     string private _symbol;
597 
598     // Mapping from token ID to owner address
599     mapping(uint256 => address) private _owners;
600 
601     // Mapping owner address to token count
602     mapping(address => uint256) private _balances;
603 
604     // Mapping from token ID to approved address
605     mapping(uint256 => address) private _tokenApprovals;
606 
607     // Mapping from owner to operator approvals
608     mapping(address => mapping(address => bool)) private _operatorApprovals;
609 
610     /**
611      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
612      */
613     constructor(string memory name_, string memory symbol_) {
614         _name = name_;
615         _symbol = symbol_;
616     }
617 
618     /**
619      * @dev See {IERC165-supportsInterface}.
620      */
621     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
622         return
623             interfaceId == type(IERC721).interfaceId ||
624             interfaceId == type(IERC721Metadata).interfaceId ||
625             super.supportsInterface(interfaceId);
626     }
627 
628     /**
629      * @dev See {IERC721-balanceOf}.
630      */
631     function balanceOf(address owner) public view virtual override returns (uint256) {
632         require(owner != address(0), "ERC721: balance query for the zero address");
633         return _balances[owner];
634     }
635 
636     /**
637      * @dev See {IERC721-ownerOf}.
638      */
639     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
640         address owner = _owners[tokenId];
641         require(owner != address(0), "ERC721: owner query for nonexistent token");
642         return owner;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-name}.
647      */
648     function name() public view virtual override returns (string memory) {
649         return _name;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-symbol}.
654      */
655     function symbol() public view virtual override returns (string memory) {
656         return _symbol;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-tokenURI}.
661      */
662     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
663         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
664 
665         string memory baseURI = _baseURI();
666         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
667     }
668 
669     /**
670      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
671      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
672      * by default, can be overriden in child contracts.
673      */
674     function _baseURI() internal view virtual returns (string memory) {
675         return "";
676     }
677 
678     /**
679      * @dev See {IERC721-approve}.
680      */
681     function approve(address to, uint256 tokenId) public virtual override {
682         address owner = ERC721.ownerOf(tokenId);
683         require(to != owner, "ERC721: approval to current owner");
684 
685         require(
686             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
687             "ERC721: approve caller is not owner nor approved for all"
688         );
689 
690         _approve(to, tokenId);
691     }
692 
693     /**
694      * @dev See {IERC721-getApproved}.
695      */
696     function getApproved(uint256 tokenId) public view virtual override returns (address) {
697         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
698 
699         return _tokenApprovals[tokenId];
700     }
701 
702     /**
703      * @dev See {IERC721-setApprovalForAll}.
704      */
705     function setApprovalForAll(address operator, bool approved) public virtual override {
706         require(operator != _msgSender(), "ERC721: approve to caller");
707 
708         _operatorApprovals[_msgSender()][operator] = approved;
709         emit ApprovalForAll(_msgSender(), operator, approved);
710     }
711 
712     /**
713      * @dev See {IERC721-isApprovedForAll}.
714      */
715     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
716         return _operatorApprovals[owner][operator];
717     }
718 
719     /**
720      * @dev See {IERC721-transferFrom}.
721      */
722     function transferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) public virtual override {
727         //solhint-disable-next-line max-line-length
728         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
729 
730         _transfer(from, to, tokenId);
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         safeTransferFrom(from, to, tokenId, "");
742     }
743 
744     /**
745      * @dev See {IERC721-safeTransferFrom}.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) public virtual override {
753         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
754         _safeTransfer(from, to, tokenId, _data);
755     }
756 
757     /**
758      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
759      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
760      *
761      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
762      *
763      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
764      * implement alternative mechanisms to perform token transfer, such as signature-based.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
772      *
773      * Emits a {Transfer} event.
774      */
775     function _safeTransfer(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes memory _data
780     ) internal virtual {
781         _transfer(from, to, tokenId);
782         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
783     }
784 
785     /**
786      * @dev Returns whether `tokenId` exists.
787      *
788      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
789      *
790      * Tokens start existing when they are minted (`_mint`),
791      * and stop existing when they are burned (`_burn`).
792      */
793     function _exists(uint256 tokenId) internal view virtual returns (bool) {
794         return _owners[tokenId] != address(0);
795     }
796 
797     /**
798      * @dev Returns whether `spender` is allowed to manage `tokenId`.
799      *
800      * Requirements:
801      *
802      * - `tokenId` must exist.
803      */
804     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
805         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
806         address owner = ERC721.ownerOf(tokenId);
807         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
808     }
809 
810     /**
811      * @dev Safely mints `tokenId` and transfers it to `to`.
812      *
813      * Requirements:
814      *
815      * - `tokenId` must not exist.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _safeMint(address to, uint256 tokenId) internal virtual {
821         _safeMint(to, tokenId, "");
822     }
823 
824     /**
825      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
826      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
827      */
828     function _safeMint(
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) internal virtual {
833         _mint(to, tokenId);
834         require(
835             _checkOnERC721Received(address(0), to, tokenId, _data),
836             "ERC721: transfer to non ERC721Receiver implementer"
837         );
838     }
839 
840     /**
841      * @dev Mints `tokenId` and transfers it to `to`.
842      *
843      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
844      *
845      * Requirements:
846      *
847      * - `tokenId` must not exist.
848      * - `to` cannot be the zero address.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _mint(address to, uint256 tokenId) internal virtual {
853         require(to != address(0), "ERC721: mint to the zero address");
854         require(!_exists(tokenId), "ERC721: token already minted");
855 
856         _beforeTokenTransfer(address(0), to, tokenId);
857 
858         _balances[to] += 1;
859         _owners[tokenId] = to;
860 
861         emit Transfer(address(0), to, tokenId);
862     }
863 
864     /**
865      * @dev Destroys `tokenId`.
866      * The approval is cleared when the token is burned.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _burn(uint256 tokenId) internal virtual {
875         address owner = ERC721.ownerOf(tokenId);
876 
877         _beforeTokenTransfer(owner, address(0), tokenId);
878 
879         // Clear approvals
880         _approve(address(0), tokenId);
881 
882         _balances[owner] -= 1;
883         delete _owners[tokenId];
884 
885         emit Transfer(owner, address(0), tokenId);
886     }
887 
888     /**
889      * @dev Transfers `tokenId` from `from` to `to`.
890      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
891      *
892      * Requirements:
893      *
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must be owned by `from`.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _transfer(
900         address from,
901         address to,
902         uint256 tokenId
903     ) internal virtual {
904         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
905         require(to != address(0), "ERC721: transfer to the zero address");
906 
907         _beforeTokenTransfer(from, to, tokenId);
908 
909         // Clear approvals from the previous owner
910         _approve(address(0), tokenId);
911 
912         _balances[from] -= 1;
913         _balances[to] += 1;
914         _owners[tokenId] = to;
915 
916         emit Transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev Approve `to` to operate on `tokenId`
921      *
922      * Emits a {Approval} event.
923      */
924     function _approve(address to, uint256 tokenId) internal virtual {
925         _tokenApprovals[tokenId] = to;
926         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
927     }
928 
929     /**
930      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
931      * The call is not executed if the target address is not a contract.
932      *
933      * @param from address representing the previous owner of the given token ID
934      * @param to target address that will receive the tokens
935      * @param tokenId uint256 ID of the token to be transferred
936      * @param _data bytes optional data to send along with the call
937      * @return bool whether the call correctly returned the expected magic value
938      */
939     function _checkOnERC721Received(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) private returns (bool) {
945         if (to.isContract()) {
946             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
947                 return retval == IERC721Receiver.onERC721Received.selector;
948             } catch (bytes memory reason) {
949                 if (reason.length == 0) {
950                     revert("ERC721: transfer to non ERC721Receiver implementer");
951                 } else {
952                     assembly {
953                         revert(add(32, reason), mload(reason))
954                     }
955                 }
956             }
957         } else {
958             return true;
959         }
960     }
961 
962     /**
963      * @dev Hook that is called before any token transfer. This includes minting
964      * and burning.
965      *
966      * Calling conditions:
967      *
968      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
969      * transferred to `to`.
970      * - When `from` is zero, `tokenId` will be minted for `to`.
971      * - When `to` is zero, ``from``'s `tokenId` will be burned.
972      * - `from` and `to` are never both zero.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _beforeTokenTransfer(
977         address from,
978         address to,
979         uint256 tokenId
980     ) internal virtual {}
981 }
982 
983 
984 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
985 
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
991  * @dev See https://eips.ethereum.org/EIPS/eip-721
992  */
993 interface IERC721Enumerable is IERC721 {
994     /**
995      * @dev Returns the total amount of tokens stored by the contract.
996      */
997     function totalSupply() external view returns (uint256);
998 
999     /**
1000      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1001      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1002      */
1003     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1004 
1005     /**
1006      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1007      * Use along with {totalSupply} to enumerate all tokens.
1008      */
1009     function tokenByIndex(uint256 index) external view returns (uint256);
1010 }
1011 
1012 
1013 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1014 
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 
1019 /**
1020  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1021  * enumerability of all the token ids in the contract as well as all token ids owned by each
1022  * account.
1023  */
1024 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1025     // Mapping from owner to list of owned token IDs
1026     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1027 
1028     // Mapping from token ID to index of the owner tokens list
1029     mapping(uint256 => uint256) private _ownedTokensIndex;
1030 
1031     // Array with all token ids, used for enumeration
1032     uint256[] private _allTokens;
1033 
1034     // Mapping from token id to position in the allTokens array
1035     mapping(uint256 => uint256) private _allTokensIndex;
1036 
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1041         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1046      */
1047     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1048         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1049         return _ownedTokens[owner][index];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-totalSupply}.
1054      */
1055     function totalSupply() public view virtual override returns (uint256) {
1056         return _allTokens.length;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-tokenByIndex}.
1061      */
1062     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1063         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1064         return _allTokens[index];
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` will be minted for `to`.
1076      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      *
1080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1081      */
1082     function _beforeTokenTransfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual override {
1087         super._beforeTokenTransfer(from, to, tokenId);
1088 
1089         if (from == address(0)) {
1090             _addTokenToAllTokensEnumeration(tokenId);
1091         } else if (from != to) {
1092             _removeTokenFromOwnerEnumeration(from, tokenId);
1093         }
1094         if (to == address(0)) {
1095             _removeTokenFromAllTokensEnumeration(tokenId);
1096         } else if (to != from) {
1097             _addTokenToOwnerEnumeration(to, tokenId);
1098         }
1099     }
1100 
1101     /**
1102      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1103      * @param to address representing the new owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1105      */
1106     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1107         uint256 length = ERC721.balanceOf(to);
1108         _ownedTokens[to][length] = tokenId;
1109         _ownedTokensIndex[tokenId] = length;
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's token tracking data structures.
1114      * @param tokenId uint256 ID of the token to be added to the tokens list
1115      */
1116     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1117         _allTokensIndex[tokenId] = _allTokens.length;
1118         _allTokens.push(tokenId);
1119     }
1120 
1121     /**
1122      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1123      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1124      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1125      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1126      * @param from address representing the previous owner of the given token ID
1127      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1128      */
1129     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1130         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1131         // then delete the last slot (swap and pop).
1132 
1133         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1134         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1135 
1136         // When the token to delete is the last token, the swap operation is unnecessary
1137         if (tokenIndex != lastTokenIndex) {
1138             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1139 
1140             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1141             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1142         }
1143 
1144         // This also deletes the contents at the last position of the array
1145         delete _ownedTokensIndex[tokenId];
1146         delete _ownedTokens[from][lastTokenIndex];
1147     }
1148 
1149     /**
1150      * @dev Private function to remove a token from this extension's token tracking data structures.
1151      * This has O(1) time complexity, but alters the order of the _allTokens array.
1152      * @param tokenId uint256 ID of the token to be removed from the tokens list
1153      */
1154     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1155         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1156         // then delete the last slot (swap and pop).
1157 
1158         uint256 lastTokenIndex = _allTokens.length - 1;
1159         uint256 tokenIndex = _allTokensIndex[tokenId];
1160 
1161         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1162         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1163         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1164         uint256 lastTokenId = _allTokens[lastTokenIndex];
1165 
1166         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1167         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1168 
1169         // This also deletes the contents at the last position of the array
1170         delete _allTokensIndex[tokenId];
1171         _allTokens.pop();
1172     }
1173 }
1174 
1175 
1176 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
1177 
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 /**
1182  * @dev Interface of the ERC20 standard as defined in the EIP.
1183  */
1184 interface IERC20 {
1185     /**
1186      * @dev Returns the amount of tokens in existence.
1187      */
1188     function totalSupply() external view returns (uint256);
1189 
1190     /**
1191      * @dev Returns the amount of tokens owned by `account`.
1192      */
1193     function balanceOf(address account) external view returns (uint256);
1194 
1195     /**
1196      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1197      *
1198      * Returns a boolean value indicating whether the operation succeeded.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function transfer(address recipient, uint256 amount) external returns (bool);
1203 
1204     /**
1205      * @dev Returns the remaining number of tokens that `spender` will be
1206      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1207      * zero by default.
1208      *
1209      * This value changes when {approve} or {transferFrom} are called.
1210      */
1211     function allowance(address owner, address spender) external view returns (uint256);
1212 
1213     /**
1214      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1215      *
1216      * Returns a boolean value indicating whether the operation succeeded.
1217      *
1218      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1219      * that someone may use both the old and the new allowance by unfortunate
1220      * transaction ordering. One possible solution to mitigate this race
1221      * condition is to first reduce the spender's allowance to 0 and set the
1222      * desired value afterwards:
1223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1224      *
1225      * Emits an {Approval} event.
1226      */
1227     function approve(address spender, uint256 amount) external returns (bool);
1228 
1229     /**
1230      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1231      * allowance mechanism. `amount` is then deducted from the caller's
1232      * allowance.
1233      *
1234      * Returns a boolean value indicating whether the operation succeeded.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function transferFrom(
1239         address sender,
1240         address recipient,
1241         uint256 amount
1242     ) external returns (bool);
1243 
1244     /**
1245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1246      * another (`to`).
1247      *
1248      * Note that `value` may be zero.
1249      */
1250     event Transfer(address indexed from, address indexed to, uint256 value);
1251 
1252     /**
1253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1254      * a call to {approve}. `value` is the new allowance.
1255      */
1256     event Approval(address indexed owner, address indexed spender, uint256 value);
1257 }
1258 
1259 
1260 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 /**
1266  * @dev Contract module which provides a basic access control mechanism, where
1267  * there is an account (an owner) that can be granted exclusive access to
1268  * specific functions.
1269  *
1270  * By default, the owner account will be the one that deploys the contract. This
1271  * can later be changed with {transferOwnership}.
1272  *
1273  * This module is used through inheritance. It will make available the modifier
1274  * `onlyOwner`, which can be applied to your functions to restrict their use to
1275  * the owner.
1276  */
1277 abstract contract Ownable is Context {
1278     address private _owner;
1279 
1280     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1281 
1282     /**
1283      * @dev Initializes the contract setting the deployer as the initial owner.
1284      */
1285     constructor() {
1286         _setOwner(_msgSender());
1287     }
1288 
1289     /**
1290      * @dev Returns the address of the current owner.
1291      */
1292     function owner() public view virtual returns (address) {
1293         return _owner;
1294     }
1295 
1296     /**
1297      * @dev Throws if called by any account other than the owner.
1298      */
1299     modifier onlyOwner() {
1300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1301         _;
1302     }
1303 
1304     /**
1305      * @dev Leaves the contract without owner. It will not be possible to call
1306      * `onlyOwner` functions anymore. Can only be called by the current owner.
1307      *
1308      * NOTE: Renouncing ownership will leave the contract without an owner,
1309      * thereby removing any functionality that is only available to the owner.
1310      */
1311     function renounceOwnership() public virtual onlyOwner {
1312         _setOwner(address(0));
1313     }
1314 
1315     /**
1316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1317      * Can only be called by the current owner.
1318      */
1319     function transferOwnership(address newOwner) public virtual onlyOwner {
1320         require(newOwner != address(0), "Ownable: new owner is the zero address");
1321         _setOwner(newOwner);
1322     }
1323 
1324     function _setOwner(address newOwner) private {
1325         address oldOwner = _owner;
1326         _owner = newOwner;
1327         emit OwnershipTransferred(oldOwner, newOwner);
1328     }
1329 }
1330 
1331 
1332 // File contracts/Jims.sol
1333 
1334 pragma solidity ^0.8.0;
1335 
1336 
1337 
1338 
1339 // SPDX-License-Identifier: MIT
1340 contract Jims is ERC721Enumerable, Ownable {
1341   address[] public _whitelistedERC20s;
1342   address[] public _whitelistedERC721s;
1343   mapping (address => uint256) public _erc20MinBals;
1344   mapping (address => uint256) public _erc721MinBals;
1345 
1346   uint256 public constant priceToMint = 0.069 ether;
1347   address public immutable _feeWallet;
1348   uint256 public immutable maxSupply;
1349   uint256 public immutable preMintSupply;
1350   uint256 public immutable maxMintPerTransaction;
1351   uint256 private immutable _obfuscationOffset;
1352 
1353   uint256 public preMintStartTime;
1354   mapping (address => bool) public _whitelistedAddresses;
1355   mapping (address => bool) public _preMintedAddresses;
1356   mapping (uint256 => bool) public _preMintedTokenIds;
1357 
1358   uint256 public totalPreMinted = 0;
1359   bool public mintAllowed = false;
1360   bool public devMintLocked = false;
1361   bool public baseURILocked = false;
1362   string public baseURI = "ipfs://Qmf3yLqLE2DwpvN4MmPyy7bkCGXZFzf8EJPRoYiebJN96X/";
1363 
1364 
1365   constructor(address feeWallet, uint256 preMintSupply_, uint256 maxSupply_, uint256 maxMintPerTransaction_, uint256 obfuscationOffset) ERC721("The Jims", "JIM") {
1366     require(preMintSupply_ <= maxSupply_, "preMintSupply must <= maxSupply");
1367     _feeWallet = feeWallet;
1368     maxSupply = maxSupply_;
1369     preMintSupply = preMintSupply_;
1370     maxMintPerTransaction = maxMintPerTransaction_;
1371     _obfuscationOffset = obfuscationOffset;
1372     _whitelistToadzBuilders();
1373   }
1374 
1375   function allowMinting() public onlyOwner {
1376     mintAllowed = true;
1377     preMintStartTime = block.timestamp;
1378   }
1379 
1380   function whitelistERC721(address erc721, uint256 minBalance) public onlyOwner {
1381     require(minBalance > 0, "minBalance must be > 0");
1382     _whitelistedERC721s.push(erc721);
1383     _erc721MinBals[erc721] = minBalance;
1384   }
1385 
1386   function whitelistERC20(address erc20, uint256 minBalance) public onlyOwner {
1387     require(minBalance > 0, "minBalance must be > 0");
1388     _whitelistedERC20s.push(erc20);
1389     _erc20MinBals[erc20] = minBalance;
1390   }
1391 
1392   function whitelistAddress(address wallet) public onlyOwner {
1393     require(_whitelistedAddresses[wallet] == false, "Address already whitelisted");
1394     _whitelistedAddresses[wallet] = true;
1395   }
1396 
1397   function wasPreMinted(uint256 tokenId) public view returns (bool) {
1398     return _preMintedTokenIds[tokenId];
1399   }
1400 
1401   function publicSaleStarted() public view returns (bool) {
1402     return mintAllowed && preMintStartTime > 0 &&
1403       (totalPreMinted >= preMintSupply || block.timestamp - 30 minutes > preMintStartTime);
1404   }
1405 
1406   function timeToPublicSale() public view returns (int256) {
1407     if (preMintStartTime == 0) {
1408       return -1;
1409     }
1410     if (block.timestamp >= preMintStartTime + 30 minutes) {
1411       return 0;
1412     }
1413     return int256(preMintStartTime + 30 minutes - block.timestamp);
1414   }
1415 
1416   function mint(uint256 n) payable public {
1417     uint256 mintedSoFar = totalSupply();
1418     require(mintAllowed, "Mint is not allowed yet");
1419     require(n <= maxMintPerTransaction, "There is a limit on minting too many at a time!");
1420     require(mintedSoFar + n <= maxSupply, "Not enough Jims left to mint");
1421     require(msg.value >= n * priceToMint, "Not enough ether sent");
1422 
1423     if (canPreMint(msg.sender) && n == 1) {
1424       totalPreMinted += 1;
1425       _preMintedAddresses[msg.sender] = true;
1426       _preMintedTokenIds[_bijectTokenId(mintedSoFar + 1)] = true;
1427     } else {
1428       require(publicSaleStarted(), "You are not eligible to pre-mint");
1429     }
1430 
1431     (bool feeSent, ) = _feeWallet.call{value: msg.value}("");
1432     require(feeSent, "Transfer to fee wallet failed");
1433 
1434     for (uint256 i = 0; i < n; i++) {
1435       _safeMint(msg.sender, mintedSoFar + 1 + i);
1436     }
1437   }
1438 
1439 
1440   function allOwned(address wallet) public view returns (uint256[] memory) {
1441     uint256[] memory ret = new uint256[](balanceOf(wallet));
1442     for (uint256 i = 0; i < balanceOf(wallet); i++) {
1443       ret[i] = tokenOfOwnerByIndex(wallet, i);
1444     }
1445     return ret;
1446   }
1447 
1448   function canPreMint(address wallet) public view returns (bool) {
1449     return isPreMinter(wallet) && _preMintedAddresses[wallet] == false && totalPreMinted < preMintSupply;
1450   }
1451 
1452   function isPreMinter(address wallet) public view returns (bool) {
1453     for (uint256 i = 0; i < _whitelistedERC20s.length; i++) {
1454       address erc20 = _whitelistedERC20s[i];
1455       uint256 minBal = _erc20MinBals[erc20];
1456       if (IERC20(erc20).balanceOf(wallet) >= minBal) {
1457         return true;
1458       }
1459     }
1460 
1461     for (uint256 i = 0; i < _whitelistedERC721s.length; i++) {
1462       address erc721  = _whitelistedERC721s[i];
1463       uint256 minBal = _erc721MinBals[erc721];
1464       if (IERC721(erc721).balanceOf(wallet) >= minBal) {
1465         return true;
1466       }
1467     }
1468 
1469     return _whitelistedAddresses[wallet];
1470   }
1471 
1472   function _safeMint(address recipient, uint256 tokenId) internal override {
1473     super._safeMint(recipient, _bijectTokenId(tokenId));
1474   }
1475 
1476   function _bijectTokenId(uint256 tokenId) internal view returns (uint256) {
1477     return (tokenId + _obfuscationOffset) % maxSupply;
1478   }
1479 
1480   function mintSpecial(address recipient) external onlyOwner {
1481     require(!devMintLocked, "Dev Mint Permanently Locked");
1482     for (uint256 i = 0; i < 10; i++) {
1483         _safeMint(recipient, totalSupply() + 1);
1484     }
1485     devMintLocked = true;
1486   }
1487 
1488   function _whitelistToadzBuilders() private {
1489     _whitelistedAddresses[0x38cb169b538a9Ad32a8B146D534b8087A7fa9033] = true;
1490     _whitelistedAddresses[0xe151dF2b98F9CE246C1De62f10F08c75991F6f6d] = true;
1491     _whitelistedAddresses[0x0deE629A5961F0493A54283B88Fc0Da49558E27c] = true;
1492     _whitelistedAddresses[0x515278483D7888B877F605984bF7fF0f489D6b88] = true;
1493     _whitelistedAddresses[0x7651f150fDF8E9C6293FaF3DBFE469296397f216] = true;
1494     _whitelistedAddresses[0x829B325036EE8F6B6ec80311d2699505505696eF] = true;
1495     _whitelistedAddresses[0x31C1b03EC94EC958DD6E53351f1760f8FF72946B] = true;
1496     _whitelistedAddresses[0x5ba89cAd1B7925083FdC91F8aFc5dff954df803F] = true;
1497     _whitelistedAddresses[0xDE8f5F0b94134d50ad7f85EF02b9771203F939E5] = true;
1498     _whitelistedAddresses[0x27E46E5C28d29Cae26fC0a92ACfCb3C9718D8Ee0] = true;
1499     _whitelistedAddresses[0x51e13ff041D86dcc4B8126eD58050b7C2BA2c5B0] = true;
1500     _whitelistedAddresses[0xb4005DB54aDecf669BaBC3efb19B9B7E3978ebc2] = true;
1501     _whitelistedAddresses[0xce4122fEC66C21b0114a8Ef6dA8BCC44C396Cb66] = true;
1502     _whitelistedAddresses[0x1E4aB43d5D283cb3bf809a46C4eed47C7283e6EC] = true;
1503     _whitelistedAddresses[0xAd1B4d6d80Aea57c966D9751A5Fe2c60a0469F60] = true;
1504     _whitelistedAddresses[0xDe05523952B159f1E07f61E744a5e451776B2890] = true;
1505     _whitelistedAddresses[0x9C3b82bf3464e3Eb594d7F172800066C0394D996] = true;
1506     _whitelistedAddresses[0xCF4e26a7e7eAe4b3840dd31C527096e1265AB990] = true;
1507     _whitelistedAddresses[0xe1385eA3cD4AEB508b2B8094F822960D0C968505] = true;
1508     _whitelistedAddresses[0xcB06bEDe7cB0a4b333581B6BdcD05f7cc737b9cC] = true;
1509     _whitelistedAddresses[0x04fe82a2a3284F629Bb501e78e6DDf38702d129c] = true;
1510     _whitelistedAddresses[0xe0110C6EE2138Ecf9962a6f9f6Ad329cDFE1FA17] = true;
1511     _whitelistedAddresses[0x3993996B09949BBA655d98C02c87EA6ABf553630] = true;
1512     _whitelistedAddresses[0xD19BF5F0B785c6f1F6228C72A8A31C9f383a49c4] = true;
1513     _whitelistedAddresses[0x53aD02394eB71543D4deB7c034893A12e15fF4e0] = true;
1514     _whitelistedAddresses[0xF3A45Ee798fc560CE080d143D12312185f84aa72] = true;
1515     _whitelistedAddresses[0x5b8589befa1bAeaB1f10FF0933DC93c54F906A53] = true;
1516     _whitelistedAddresses[0x062062Ed41002Ed2Bff56df561496cbE7FB374ae] = true;
1517     _whitelistedAddresses[0xbC9C6379C7C5b87f32cB707711FbEbB2511f0BA1] = true;
1518     _whitelistedAddresses[0xb75F87261a1FAC3a86f8A48d55597A622BA3CC48] = true;
1519     _whitelistedAddresses[0x6b2AF62E0Bb72761241F35d6796b64B98Fe1Bd1C] = true;
1520     _whitelistedAddresses[0x9A15235379CF1111EA102850d442b743BF586FC5] = true;
1521     _whitelistedAddresses[0x52A7991d52d8e68de46DFe3CD7d4f48edDa7aE77] = true;
1522     _whitelistedAddresses[0x3b359252E4A9B352a127aDdbcc2547460AA4e51c] = true;
1523     _whitelistedAddresses[0xedcB20e324E75553C9C7E7578eFAe48AaB4702FF] = true;
1524     _whitelistedAddresses[0x7132C9f36abE62EAb74CdfDd08C154c9AE45691B] = true;
1525     _whitelistedAddresses[0x51200AA490F8DF9EBdC9671cF8C8F8A12c089fDa] = true;
1526     _whitelistedAddresses[0xCEB6798d609F86E156F36735EB39108aF6d9a8cB] = true;
1527     _whitelistedAddresses[0xe360776eDA4764CDEe0b7613857f286b861aB4D4] = true;
1528     _whitelistedAddresses[0x484eC62385e780f2460fEaC34864A77bA5A18134] = true;
1529     _whitelistedAddresses[0x202e1B414D601395c30A6F70EFfA082f36Ea8f79] = true;
1530     _whitelistedAddresses[0xf8c75C5E9ec6875c57C0Dbc30b59934B37908c4e] = true;
1531     _whitelistedAddresses[0x3491A2C7Aa4D12D67A5ab628185CE07821B9C553] = true;
1532     _whitelistedAddresses[0xa596370bC21DeE36872B98009dfbbF465DBFefA3] = true;
1533     _whitelistedAddresses[0xdFba1C121d57d317467dCf6eba3df7b32C5C736f] = true;
1534     _whitelistedAddresses[0x389D3C071687A92F060995327Acb015e936A27CE] = true;
1535     _whitelistedAddresses[0x04D42dEd30A02986Dd5E17d39dd34fBA381FcC4E] = true;
1536     _whitelistedAddresses[0xcD494a22fCF4888976c145F9e389869C4ec313aA] = true;
1537     _whitelistedAddresses[0xff91128081043dcEB6C0bD3f752Fa447fbaA9335] = true;
1538     _whitelistedAddresses[0x06151656d748990d77e20a2d47C4F9369AA74645] = true;
1539     _whitelistedAddresses[0x6A9B9563F32Bc418f35067CE47554C894799515b] = true;
1540     _whitelistedAddresses[0x9C906F90137C764035d180D3983F15E7C2cb8BbE] = true;
1541     _whitelistedAddresses[0x8Bd8795CbeED15F8D5074f493C53b39C11Ed37B2] = true;
1542     _whitelistedAddresses[0x93e9594A8f2b5671aeE54b86283FA5A7261F93d7] = true;
1543     _whitelistedAddresses[0xc6B89634f0afb34b59c05A0B7cD132141778aDDd] = true;
1544     _whitelistedAddresses[0x51661d54E0b6653446c602fd4d973D5205F22Dc3] = true;
1545   }
1546 
1547   function _baseURI() internal view virtual override returns (string memory) {
1548       return baseURI;
1549   }
1550 
1551   function _setBaseURI(string memory baseURI_) external onlyOwner {
1552     require(baseURILocked == false, "Can only set Base URI once");
1553     baseURI = baseURI_;
1554     baseURILocked = true;
1555   }
1556 
1557 }