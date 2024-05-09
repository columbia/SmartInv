1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
31 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
173 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
174 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
202 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
203 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
229 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
230 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
448 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
449 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
474 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
475 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
543 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
544 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
572 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.1
573 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
706         _setApprovalForAll(_msgSender(), operator, approved);
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
927      * @dev Approve `operator` to operate on all of `owner` tokens
928      *
929      * Emits a {ApprovalForAll} event.
930      */
931     function _setApprovalForAll(
932         address owner,
933         address operator,
934         bool approved
935     ) internal virtual {
936         require(owner != operator, "ERC721: approve to caller");
937         _operatorApprovals[owner][operator] = approved;
938         emit ApprovalForAll(owner, operator, approved);
939     }
940 
941     /**
942      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
943      * The call is not executed if the target address is not a contract.
944      *
945      * @param from address representing the previous owner of the given token ID
946      * @param to target address that will receive the tokens
947      * @param tokenId uint256 ID of the token to be transferred
948      * @param _data bytes optional data to send along with the call
949      * @return bool whether the call correctly returned the expected magic value
950      */
951     function _checkOnERC721Received(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) private returns (bool) {
957         if (to.isContract()) {
958             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
959                 return retval == IERC721Receiver.onERC721Received.selector;
960             } catch (bytes memory reason) {
961                 if (reason.length == 0) {
962                     revert("ERC721: transfer to non ERC721Receiver implementer");
963                 } else {
964                     assembly {
965                         revert(add(32, reason), mload(reason))
966                     }
967                 }
968             }
969         } else {
970             return true;
971         }
972     }
973 
974     /**
975      * @dev Hook that is called before any token transfer. This includes minting
976      * and burning.
977      *
978      * Calling conditions:
979      *
980      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
981      * transferred to `to`.
982      * - When `from` is zero, `tokenId` will be minted for `to`.
983      * - When `to` is zero, ``from``'s `tokenId` will be burned.
984      * - `from` and `to` are never both zero.
985      *
986      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
987      */
988     function _beforeTokenTransfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) internal virtual {}
993 }
994 
995 
996 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
997 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @dev Contract module which provides a basic access control mechanism, where
1003  * there is an account (an owner) that can be granted exclusive access to
1004  * specific functions.
1005  *
1006  * By default, the owner account will be the one that deploys the contract. This
1007  * can later be changed with {transferOwnership}.
1008  *
1009  * This module is used through inheritance. It will make available the modifier
1010  * `onlyOwner`, which can be applied to your functions to restrict their use to
1011  * the owner.
1012  */
1013 abstract contract Ownable is Context {
1014     address private _owner;
1015 
1016     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1017 
1018     /**
1019      * @dev Initializes the contract setting the deployer as the initial owner.
1020      */
1021     constructor() {
1022         _transferOwnership(_msgSender());
1023     }
1024 
1025     /**
1026      * @dev Returns the address of the current owner.
1027      */
1028     function owner() public view virtual returns (address) {
1029         return _owner;
1030     }
1031 
1032     /**
1033      * @dev Throws if called by any account other than the owner.
1034      */
1035     modifier onlyOwner() {
1036         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1037         _;
1038     }
1039 
1040     /**
1041      * @dev Leaves the contract without owner. It will not be possible to call
1042      * `onlyOwner` functions anymore. Can only be called by the current owner.
1043      *
1044      * NOTE: Renouncing ownership will leave the contract without an owner,
1045      * thereby removing any functionality that is only available to the owner.
1046      */
1047     function renounceOwnership() public virtual onlyOwner {
1048         _transferOwnership(address(0));
1049     }
1050 
1051     /**
1052      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1053      * Can only be called by the current owner.
1054      */
1055     function transferOwnership(address newOwner) public virtual onlyOwner {
1056         require(newOwner != address(0), "Ownable: new owner is the zero address");
1057         _transferOwnership(newOwner);
1058     }
1059 
1060     /**
1061      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1062      * Internal function without access restriction.
1063      */
1064     function _transferOwnership(address newOwner) internal virtual {
1065         address oldOwner = _owner;
1066         _owner = newOwner;
1067         emit OwnershipTransferred(oldOwner, newOwner);
1068     }
1069 }
1070 
1071 
1072 // File contracts/NFTArtGen.sol
1073 
1074 pragma solidity ^0.8.4;
1075 
1076 
1077 
1078 // 
1079 // Built by https://nft-generator.art
1080 // 
1081 contract NFTArtGen is ERC721, Ownable {
1082     string internal baseUri;
1083 
1084     uint256 public cost = 0.05 ether;
1085     uint32 public maxPerMint = 5;
1086     uint32 public maxPerWallet = 20;
1087     uint32 public supply = 0;
1088     uint32 public totalSupply = 0;
1089     bool public open = false;
1090     mapping(address => uint256) internal addressMintedMap;
1091 
1092     uint32 private commission = 49; // 4.9%
1093     address private author = 0x460Fd5059E7301680fA53E63bbBF7272E643e89C;
1094 
1095     constructor(
1096         string memory _uri,
1097         string memory _name,
1098         string memory _symbol,
1099         uint32 _totalSupply,
1100         uint256 _cost,
1101         bool _open
1102     ) ERC721(_name, _symbol) {
1103         baseUri = _uri;
1104         totalSupply = _totalSupply;
1105         cost = _cost;
1106         open = _open;
1107     }
1108 
1109     // ------ Author Only ------
1110 
1111     function setCommission(uint32 _commision) public {
1112         require(msg.sender == author, "Incorrect Address");
1113         commission = _commision;
1114     }
1115 
1116     // ------ Owner Only ------
1117 
1118     function setCost(uint256 _cost) public onlyOwner {
1119         cost = _cost;
1120     }
1121 
1122     function setOpen(bool _open) public onlyOwner {
1123         open = _open;
1124     }
1125 
1126     function setMaxPerWallet(uint32 _max) public onlyOwner {
1127         maxPerWallet = _max;
1128     }
1129 
1130     function setMaxPerMint(uint32 _max) public onlyOwner {
1131         maxPerMint = _max;
1132     }
1133 
1134     function airdrop(address[] calldata to) public onlyOwner {
1135         for (uint32 i = 0; i < to.length; i++) {
1136             require(1 + supply <= totalSupply, "Limit reached");
1137             _safeMint(to[i], ++supply, "");
1138         }
1139     }
1140 
1141     function withdraw() public payable onlyOwner {
1142         (bool success, ) = payable(msg.sender).call{
1143             value: address(this).balance
1144         }("");
1145         require(success);
1146     }
1147 
1148     // ------ Mint! ------
1149 
1150     function mint(uint32 count) external payable preMintChecks(count) {
1151         require(open == true, "Mint not open");
1152         performMint(count);
1153     }
1154 
1155     function performMint(uint32 count) internal {
1156         for (uint32 i = 0; i < count; i++) {
1157             _safeMint(msg.sender, ++supply, "");
1158         }
1159         
1160         addressMintedMap[msg.sender] += count;
1161 
1162         (bool success, ) = payable(author).call{
1163             value: (msg.value * commission) / 1000
1164         }("");
1165         require(success);
1166     }
1167 
1168     // ------ Read ------
1169 
1170     // ------ Modifiers ------
1171 
1172     modifier preMintChecks(uint32 count) {
1173         require(count > 0, "Mint at least one.");
1174         require(count < maxPerMint + 1, "Max mint reached.");
1175         require(msg.value >= cost * count, "Not enough fund.");
1176         require(supply + count < totalSupply + 1, "Mint sold out");
1177         require(
1178             addressMintedMap[msg.sender] + count <= maxPerWallet,
1179             "Max total mint reached"
1180         );
1181         _;
1182     }
1183 }
1184 
1185 
1186 // File contracts/extensions/Base.sol
1187 
1188 pragma solidity ^0.8.4;
1189 
1190 contract NFTArtGenBase is NFTArtGen {
1191     constructor(
1192         string memory _uri,
1193         string memory _name,
1194         string memory _symbol,
1195         uint32 _totalSupply,
1196         uint256 _cost,
1197         bool _open
1198     ) NFTArtGen(_uri, _name, _symbol, _totalSupply, _cost, _open) {}
1199 
1200     function tokenURI(uint256 _tokenId)
1201         public
1202         view
1203         virtual
1204         override
1205         returns (string memory)
1206     {
1207         require(_tokenId <= supply, "Not minted yet");
1208 
1209         return
1210             string(
1211                 abi.encodePacked(baseUri, Strings.toString(_tokenId), ".json")
1212             );
1213     }
1214 }