1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
30 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
171 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
200 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
227 // File: @openzeppelin/contracts/utils/Address.sol
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
360         return verifyCallResult(success, returndata, errorMessage);
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
387         return verifyCallResult(success, returndata, errorMessage);
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
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
419      * revert reason using the provided one.
420      *
421      * _Available since v4.3._
422      */
423     function verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) internal pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/utils/Context.sol
447 
448 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Provides information about the current execution context, including the
454  * sender of the transaction and its data. While these are generally available
455  * via msg.sender and msg.data, they should not be accessed in such a direct
456  * manner, since when dealing with meta-transactions the account sending and
457  * paying for execution may not be the actual sender (as far as an application
458  * is concerned).
459  *
460  * This contract is only required for intermediate, library-like contracts.
461  */
462 abstract contract Context {
463     function _msgSender() internal view virtual returns (address) {
464         return msg.sender;
465     }
466 
467     function _msgData() internal view virtual returns (bytes calldata) {
468         return msg.data;
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/Strings.sol
473 
474 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev String operations.
480  */
481 library Strings {
482     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
486      */
487     function toString(uint256 value) internal pure returns (string memory) {
488         // Inspired by OraclizeAPI's implementation - MIT licence
489         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
490 
491         if (value == 0) {
492             return "0";
493         }
494         uint256 temp = value;
495         uint256 digits;
496         while (temp != 0) {
497             digits++;
498             temp /= 10;
499         }
500         bytes memory buffer = new bytes(digits);
501         while (value != 0) {
502             digits -= 1;
503             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
504             value /= 10;
505         }
506         return string(buffer);
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
511      */
512     function toHexString(uint256 value) internal pure returns (string memory) {
513         if (value == 0) {
514             return "0x00";
515         }
516         uint256 temp = value;
517         uint256 length = 0;
518         while (temp != 0) {
519             length++;
520             temp >>= 8;
521         }
522         return toHexString(value, length);
523     }
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
527      */
528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
529         bytes memory buffer = new bytes(2 * length + 2);
530         buffer[0] = "0";
531         buffer[1] = "x";
532         for (uint256 i = 2 * length + 1; i > 1; --i) {
533             buffer[i] = _HEX_SYMBOLS[value & 0xf];
534             value >>= 4;
535         }
536         require(value == 0, "Strings: hex length insufficient");
537         return string(buffer);
538     }
539 }
540 
541 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
542 
543 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Implementation of the {IERC165} interface.
549  *
550  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
551  * for the additional interface id that will be supported. For example:
552  *
553  * ```solidity
554  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
556  * }
557  * ```
558  *
559  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
560  */
561 abstract contract ERC165 is IERC165 {
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         return interfaceId == type(IERC165).interfaceId;
567     }
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
573 
574 pragma solidity ^0.8.0;
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
705         _setApprovalForAll(_msgSender(), operator, approved);
706     }
707 
708     /**
709      * @dev See {IERC721-isApprovedForAll}.
710      */
711     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[owner][operator];
713     }
714 
715     /**
716      * @dev See {IERC721-transferFrom}.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) public virtual override {
723         //solhint-disable-next-line max-line-length
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725 
726         _transfer(from, to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-safeTransferFrom}.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         safeTransferFrom(from, to, tokenId, "");
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) public virtual override {
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750         _safeTransfer(from, to, tokenId, _data);
751     }
752 
753     /**
754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756      *
757      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
758      *
759      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
760      * implement alternative mechanisms to perform token transfer, such as signature-based.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _safeTransfer(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) internal virtual {
777         _transfer(from, to, tokenId);
778         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
779     }
780 
781     /**
782      * @dev Returns whether `tokenId` exists.
783      *
784      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
785      *
786      * Tokens start existing when they are minted (`_mint`),
787      * and stop existing when they are burned (`_burn`).
788      */
789     function _exists(uint256 tokenId) internal view virtual returns (bool) {
790         return _owners[tokenId] != address(0);
791     }
792 
793     /**
794      * @dev Returns whether `spender` is allowed to manage `tokenId`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must exist.
799      */
800     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
801         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
802         address owner = ERC721.ownerOf(tokenId);
803         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
804     }
805 
806     /**
807      * @dev Safely mints `tokenId` and transfers it to `to`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must not exist.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _safeMint(address to, uint256 tokenId) internal virtual {
817         _safeMint(to, tokenId, "");
818     }
819 
820     /**
821      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
822      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
823      */
824     function _safeMint(
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) internal virtual {
829         _mint(to, tokenId);
830         require(
831             _checkOnERC721Received(address(0), to, tokenId, _data),
832             "ERC721: transfer to non ERC721Receiver implementer"
833         );
834     }
835 
836     /**
837      * @dev Mints `tokenId` and transfers it to `to`.
838      *
839      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - `to` cannot be the zero address.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _mint(address to, uint256 tokenId) internal virtual {
849         require(to != address(0), "ERC721: mint to the zero address");
850         require(!_exists(tokenId), "ERC721: token already minted");
851 
852         _beforeTokenTransfer(address(0), to, tokenId);
853 
854         _balances[to] += 1;
855         _owners[tokenId] = to;
856 
857         emit Transfer(address(0), to, tokenId);
858     }
859 
860     /**
861      * @dev Destroys `tokenId`.
862      * The approval is cleared when the token is burned.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _burn(uint256 tokenId) internal virtual {
871         address owner = ERC721.ownerOf(tokenId);
872 
873         _beforeTokenTransfer(owner, address(0), tokenId);
874 
875         // Clear approvals
876         _approve(address(0), tokenId);
877 
878         _balances[owner] -= 1;
879         delete _owners[tokenId];
880 
881         emit Transfer(owner, address(0), tokenId);
882     }
883 
884     /**
885      * @dev Transfers `tokenId` from `from` to `to`.
886      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
887      *
888      * Requirements:
889      *
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must be owned by `from`.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _transfer(
896         address from,
897         address to,
898         uint256 tokenId
899     ) internal virtual {
900         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
901         require(to != address(0), "ERC721: transfer to the zero address");
902 
903         _beforeTokenTransfer(from, to, tokenId);
904 
905         // Clear approvals from the previous owner
906         _approve(address(0), tokenId);
907 
908         _balances[from] -= 1;
909         _balances[to] += 1;
910         _owners[tokenId] = to;
911 
912         emit Transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev Approve `to` to operate on `tokenId`
917      *
918      * Emits a {Approval} event.
919      */
920     function _approve(address to, uint256 tokenId) internal virtual {
921         _tokenApprovals[tokenId] = to;
922         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
923     }
924 
925     /**
926      * @dev Approve `operator` to operate on all of `owner` tokens
927      *
928      * Emits a {ApprovalForAll} event.
929      */
930     function _setApprovalForAll(
931         address owner,
932         address operator,
933         bool approved
934     ) internal virtual {
935         require(owner != operator, "ERC721: approve to caller");
936         _operatorApprovals[owner][operator] = approved;
937         emit ApprovalForAll(owner, operator, approved);
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942      * The call is not executed if the target address is not a contract.
943      *
944      * @param from address representing the previous owner of the given token ID
945      * @param to target address that will receive the tokens
946      * @param tokenId uint256 ID of the token to be transferred
947      * @param _data bytes optional data to send along with the call
948      * @return bool whether the call correctly returned the expected magic value
949      */
950     function _checkOnERC721Received(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) private returns (bool) {
956         if (to.isContract()) {
957             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
958                 return retval == IERC721Receiver.onERC721Received.selector;
959             } catch (bytes memory reason) {
960                 if (reason.length == 0) {
961                     revert("ERC721: transfer to non ERC721Receiver implementer");
962                 } else {
963                     assembly {
964                         revert(add(32, reason), mload(reason))
965                     }
966                 }
967             }
968         } else {
969             return true;
970         }
971     }
972 
973     /**
974      * @dev Hook that is called before any token transfer. This includes minting
975      * and burning.
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` will be minted for `to`.
982      * - When `to` is zero, ``from``'s `tokenId` will be burned.
983      * - `from` and `to` are never both zero.
984      *
985      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
986      */
987     function _beforeTokenTransfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {}
992 }
993 
994 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
995 
996 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Enumerable is IERC721 {
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1015 
1016     /**
1017      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1018      * Use along with {totalSupply} to enumerate all tokens.
1019      */
1020     function tokenByIndex(uint256 index) external view returns (uint256);
1021 }
1022 
1023 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1024 
1025 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1026 
1027 pragma solidity ^0.8.0;
1028 
1029 
1030 /**
1031  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1032  * enumerability of all the token ids in the contract as well as all token ids owned by each
1033  * account.
1034  */
1035 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1036     // Mapping from owner to list of owned token IDs
1037     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1038 
1039     // Mapping from token ID to index of the owner tokens list
1040     mapping(uint256 => uint256) private _ownedTokensIndex;
1041 
1042     // Array with all token ids, used for enumeration
1043     uint256[] private _allTokens;
1044 
1045     // Mapping from token id to position in the allTokens array
1046     mapping(uint256 => uint256) private _allTokensIndex;
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1052         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1060         return _ownedTokens[owner][index];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-totalSupply}.
1065      */
1066     function totalSupply() public view virtual override returns (uint256) {
1067         return _allTokens.length;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-tokenByIndex}.
1072      */
1073     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1074         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1075         return _allTokens[index];
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual override {
1098         super._beforeTokenTransfer(from, to, tokenId);
1099 
1100         if (from == address(0)) {
1101             _addTokenToAllTokensEnumeration(tokenId);
1102         } else if (from != to) {
1103             _removeTokenFromOwnerEnumeration(from, tokenId);
1104         }
1105         if (to == address(0)) {
1106             _removeTokenFromAllTokensEnumeration(tokenId);
1107         } else if (to != from) {
1108             _addTokenToOwnerEnumeration(to, tokenId);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1114      * @param to address representing the new owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1116      */
1117     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1118         uint256 length = ERC721.balanceOf(to);
1119         _ownedTokens[to][length] = tokenId;
1120         _ownedTokensIndex[tokenId] = length;
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's token tracking data structures.
1125      * @param tokenId uint256 ID of the token to be added to the tokens list
1126      */
1127     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1128         _allTokensIndex[tokenId] = _allTokens.length;
1129         _allTokens.push(tokenId);
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1134      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1135      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1136      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1137      * @param from address representing the previous owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1139      */
1140     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1141         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1145         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary
1148         if (tokenIndex != lastTokenIndex) {
1149             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1150 
1151             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153         }
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _ownedTokensIndex[tokenId];
1157         delete _ownedTokens[from][lastTokenIndex];
1158     }
1159 
1160     /**
1161      * @dev Private function to remove a token from this extension's token tracking data structures.
1162      * This has O(1) time complexity, but alters the order of the _allTokens array.
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list
1164      */
1165     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1166         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = _allTokens.length - 1;
1170         uint256 tokenIndex = _allTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1173         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1174         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1175         uint256 lastTokenId = _allTokens[lastTokenIndex];
1176 
1177         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _allTokensIndex[tokenId];
1182         _allTokens.pop();
1183     }
1184 }
1185 
1186 // File: @openzeppelin/contracts/utils/Counters.sol
1187 
1188 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 /**
1193  * @title Counters
1194  * @author Matt Condon (@shrugs)
1195  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1196  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1197  *
1198  * Include with `using Counters for Counters.Counter;`
1199  */
1200 library Counters {
1201     struct Counter {
1202         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1203         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1204         // this feature: see https://github.com/ethereum/solidity/issues/4637
1205         uint256 _value; // default: 0
1206     }
1207 
1208     function current(Counter storage counter) internal view returns (uint256) {
1209         return counter._value;
1210     }
1211 
1212     function increment(Counter storage counter) internal {
1213         unchecked {
1214             counter._value += 1;
1215         }
1216     }
1217 
1218     function decrement(Counter storage counter) internal {
1219         uint256 value = counter._value;
1220         require(value > 0, "Counter: decrement overflow");
1221         unchecked {
1222             counter._value = value - 1;
1223         }
1224     }
1225 
1226     function reset(Counter storage counter) internal {
1227         counter._value = 0;
1228     }
1229 }
1230 
1231 // File: @openzeppelin/contracts/access/Ownable.sol
1232 
1233 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 /**
1238  * @dev Contract module which provides a basic access control mechanism, where
1239  * there is an account (an owner) that can be granted exclusive access to
1240  * specific functions.
1241  *
1242  * By default, the owner account will be the one that deploys the contract. This
1243  * can later be changed with {transferOwnership}.
1244  *
1245  * This module is used through inheritance. It will make available the modifier
1246  * `onlyOwner`, which can be applied to your functions to restrict their use to
1247  * the owner.
1248  */
1249 abstract contract Ownable is Context {
1250     address private _owner;
1251 
1252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1253 
1254     /**
1255      * @dev Initializes the contract setting the deployer as the initial owner.
1256      */
1257     constructor() {
1258         _transferOwnership(_msgSender());
1259     }
1260 
1261     /**
1262      * @dev Returns the address of the current owner.
1263      */
1264     function owner() public view virtual returns (address) {
1265         return _owner;
1266     }
1267 
1268     /**
1269      * @dev Throws if called by any account other than the owner.
1270      */
1271     modifier onlyOwner() {
1272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1273         _;
1274     }
1275 
1276     /**
1277      * @dev Leaves the contract without owner. It will not be possible to call
1278      * `onlyOwner` functions anymore. Can only be called by the current owner.
1279      *
1280      * NOTE: Renouncing ownership will leave the contract without an owner,
1281      * thereby removing any functionality that is only available to the owner.
1282      */
1283     function renounceOwnership() public virtual onlyOwner {
1284         _transferOwnership(address(0));
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Can only be called by the current owner.
1290      */
1291     function transferOwnership(address newOwner) public virtual onlyOwner {
1292         require(newOwner != address(0), "Ownable: new owner is the zero address");
1293         _transferOwnership(newOwner);
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Internal function without access restriction.
1299      */
1300     function _transferOwnership(address newOwner) internal virtual {
1301         address oldOwner = _owner;
1302         _owner = newOwner;
1303         emit OwnershipTransferred(oldOwner, newOwner);
1304     }
1305 }
1306 
1307 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1308 
1309 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1310 
1311 pragma solidity ^0.8.0;
1312 
1313 // CAUTION
1314 // This version of SafeMath should only be used with Solidity 0.8 or later,
1315 // because it relies on the compiler's built in overflow checks.
1316 
1317 /**
1318  * @dev Wrappers over Solidity's arithmetic operations.
1319  *
1320  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1321  * now has built in overflow checking.
1322  */
1323 library SafeMath {
1324     /**
1325      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1326      *
1327      * _Available since v3.4._
1328      */
1329     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1330         unchecked {
1331             uint256 c = a + b;
1332             if (c < a) return (false, 0);
1333             return (true, c);
1334         }
1335     }
1336 
1337     /**
1338      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1339      *
1340      * _Available since v3.4._
1341      */
1342     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1343         unchecked {
1344             if (b > a) return (false, 0);
1345             return (true, a - b);
1346         }
1347     }
1348 
1349     /**
1350      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1351      *
1352      * _Available since v3.4._
1353      */
1354     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1355         unchecked {
1356             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1357             // benefit is lost if 'b' is also tested.
1358             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1359             if (a == 0) return (true, 0);
1360             uint256 c = a * b;
1361             if (c / a != b) return (false, 0);
1362             return (true, c);
1363         }
1364     }
1365 
1366     /**
1367      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1368      *
1369      * _Available since v3.4._
1370      */
1371     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1372         unchecked {
1373             if (b == 0) return (false, 0);
1374             return (true, a / b);
1375         }
1376     }
1377 
1378     /**
1379      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1380      *
1381      * _Available since v3.4._
1382      */
1383     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1384         unchecked {
1385             if (b == 0) return (false, 0);
1386             return (true, a % b);
1387         }
1388     }
1389 
1390     /**
1391      * @dev Returns the addition of two unsigned integers, reverting on
1392      * overflow.
1393      *
1394      * Counterpart to Solidity's `+` operator.
1395      *
1396      * Requirements:
1397      *
1398      * - Addition cannot overflow.
1399      */
1400     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1401         return a + b;
1402     }
1403 
1404     /**
1405      * @dev Returns the subtraction of two unsigned integers, reverting on
1406      * overflow (when the result is negative).
1407      *
1408      * Counterpart to Solidity's `-` operator.
1409      *
1410      * Requirements:
1411      *
1412      * - Subtraction cannot overflow.
1413      */
1414     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1415         return a - b;
1416     }
1417 
1418     /**
1419      * @dev Returns the multiplication of two unsigned integers, reverting on
1420      * overflow.
1421      *
1422      * Counterpart to Solidity's `*` operator.
1423      *
1424      * Requirements:
1425      *
1426      * - Multiplication cannot overflow.
1427      */
1428     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1429         return a * b;
1430     }
1431 
1432     /**
1433      * @dev Returns the integer division of two unsigned integers, reverting on
1434      * division by zero. The result is rounded towards zero.
1435      *
1436      * Counterpart to Solidity's `/` operator.
1437      *
1438      * Requirements:
1439      *
1440      * - The divisor cannot be zero.
1441      */
1442     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1443         return a / b;
1444     }
1445 
1446     /**
1447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1448      * reverting when dividing by zero.
1449      *
1450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1451      * opcode (which leaves remaining gas untouched) while Solidity uses an
1452      * invalid opcode to revert (consuming all remaining gas).
1453      *
1454      * Requirements:
1455      *
1456      * - The divisor cannot be zero.
1457      */
1458     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1459         return a % b;
1460     }
1461 
1462     /**
1463      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1464      * overflow (when the result is negative).
1465      *
1466      * CAUTION: This function is deprecated because it requires allocating memory for the error
1467      * message unnecessarily. For custom revert reasons use {trySub}.
1468      *
1469      * Counterpart to Solidity's `-` operator.
1470      *
1471      * Requirements:
1472      *
1473      * - Subtraction cannot overflow.
1474      */
1475     function sub(
1476         uint256 a,
1477         uint256 b,
1478         string memory errorMessage
1479     ) internal pure returns (uint256) {
1480         unchecked {
1481             require(b <= a, errorMessage);
1482             return a - b;
1483         }
1484     }
1485 
1486     /**
1487      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1488      * division by zero. The result is rounded towards zero.
1489      *
1490      * Counterpart to Solidity's `/` operator. Note: this function uses a
1491      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1492      * uses an invalid opcode to revert (consuming all remaining gas).
1493      *
1494      * Requirements:
1495      *
1496      * - The divisor cannot be zero.
1497      */
1498     function div(
1499         uint256 a,
1500         uint256 b,
1501         string memory errorMessage
1502     ) internal pure returns (uint256) {
1503         unchecked {
1504             require(b > 0, errorMessage);
1505             return a / b;
1506         }
1507     }
1508 
1509     /**
1510      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1511      * reverting with custom message when dividing by zero.
1512      *
1513      * CAUTION: This function is deprecated because it requires allocating memory for the error
1514      * message unnecessarily. For custom revert reasons use {tryMod}.
1515      *
1516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1517      * opcode (which leaves remaining gas untouched) while Solidity uses an
1518      * invalid opcode to revert (consuming all remaining gas).
1519      *
1520      * Requirements:
1521      *
1522      * - The divisor cannot be zero.
1523      */
1524     function mod(
1525         uint256 a,
1526         uint256 b,
1527         string memory errorMessage
1528     ) internal pure returns (uint256) {
1529         unchecked {
1530             require(b > 0, errorMessage);
1531             return a % b;
1532         }
1533     }
1534 }
1535 
1536 // File: contracts/KryptoPetNFT.sol
1537 
1538 //SPDX-License-Identifier: MIT
1539 pragma solidity ^0.8.10;
1540 
1541 
1542 interface IERC20 {
1543 
1544 
1545     /**
1546     * @dev Returns the decimals.
1547     */
1548     function decimals() external view returns (uint256);
1549 
1550     /**
1551     * @dev Returns the totalSupply
1552     */
1553     function totalSupply() external view returns (uint256);
1554 
1555     /**
1556     * @dev Returns the amount of tokens owned by `account`.
1557     */
1558     function balanceOf(address account) external view returns (uint256);
1559 
1560     /**
1561         * @dev Moves `amount` tokens from the caller's account to `recipient`.
1562         *
1563         * Returns a boolean value indicating whether the operation succeeded.
1564         *
1565         * Emits a {Transfer} event.
1566         */
1567     function transfer(address recipient, uint256 amount) external returns (bool);
1568 
1569     /**
1570         * @dev Returns the remaining number of tokens that `spender` will be
1571         * allowed to spend on behalf of `owner` through {transferFrom}. This is
1572         * zero by default.
1573         *
1574         * This value changes when {approve} or {transferFrom} are called.
1575         */
1576     function allowance(address owner, address spender) external view returns (uint256);
1577 
1578     /**
1579         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1580         *
1581         * Returns a boolean value indicating whether the operation succeeded.
1582         *
1583         * IMPORTANT: Beware that changing an allowance with this method brings the risk
1584         * that someone may use both the old and the new allowance by unfortunate
1585         * transaction ordering. One possible solution to mitigate this race
1586         * condition is to first reduce the spender's allowance to 0 and set the
1587         * desired value afterwards:
1588         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1589         *
1590         * Emits an {Approval} event.
1591         */
1592     function approve(address spender, uint256 amount) external returns (bool);
1593 
1594     /**
1595         * @dev Moves `amount` tokens from `sender` to `recipient` using the
1596         * allowance mechanism. `amount` is then deducted from the caller's
1597         * allowance.
1598         *
1599         * Returns a boolean value indicating whether the operation succeeded.
1600         *
1601         * Emits a {Transfer} event.
1602         */
1603     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1604 
1605     /**
1606         * @dev Emitted when `value` tokens are moved from one account (`from`) to
1607         * another (`to`).
1608         *
1609         * Note that `value` may be zero.
1610         */
1611     event Transfer(address indexed from, address indexed to, uint256 value);
1612 
1613     /**
1614         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1615         * a call to {approve}. `value` is the new allowance.
1616         */
1617     event Approval(address indexed owner, address indexed spender, uint256 value);
1618 }
1619 
1620 /**
1621  * @title SafeERC20
1622  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1623  * contract returns false). Tokens that return no value (and instead revert or
1624  * throw on failure) are also supported, non-reverting calls are assumed to be
1625  * successful.
1626  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1627  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1628  */
1629 library SafeERC20 {
1630     using SafeMath for uint256;
1631     using Address for address;
1632 
1633     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1634         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1635     }
1636 
1637     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1638         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1639     }
1640 
1641     /**
1642      * @dev Deprecated. This function has issues similar to the ones found in
1643      * {IERC20-approve}, and its usage is discouraged.
1644      *
1645      * Whenever possible, use {safeIncreaseAllowance} and
1646      * {safeDecreaseAllowance} instead.
1647      */
1648     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1649         // safeApprove should only be called when setting an initial allowance,
1650         // or when resetting it to zero. To increase and decrease it, use
1651         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1652         // solhint-disable-next-line max-line-length
1653         require((value == 0) || (token.allowance(address(this), spender) == 0),
1654             "SafeERC20: approve from non-zero to non-zero allowance"
1655         );
1656         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1657     }
1658 
1659     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1660         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1661         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1662     }
1663 
1664 /*
1665     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1666         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1667         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1668     }*/
1669 
1670     /**
1671      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1672      * on the return value: the return value is optional (but if data is returned, it must not be false).
1673      * @param token The token targeted by the call.
1674      * @param data The call data (encoded using abi.encode or one of its variants).
1675      */
1676     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1677         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1678         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1679         // the target address contains contract code and also asserts for success in the low-level call.
1680 
1681         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1682         if (returndata.length > 0) { // Return data is optional
1683             // solhint-disable-next-line max-line-length
1684             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1685         }
1686     }
1687 }
1688 
1689 interface IUniswapV2Pair {
1690     function factory() external view returns (address);
1691     function token0() external view returns (address);
1692     function token1() external view returns (address);
1693     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1694 }
1695 
1696 contract KryptoPetNFT is ERC721Enumerable, Ownable{
1697     using SafeMath for uint256;
1698     using Counters for Counters.Counter;
1699     using SafeERC20 for IERC20;
1700 
1701     modifier onlyClevel() {
1702         require(msg.sender == walletA || msg.sender == owner());
1703     _;
1704     }
1705 
1706     Counters.Counter private _tokenIds;
1707 
1708     address walletA;
1709 
1710     uint256 public phaseEndsAt = 10000;
1711 
1712     uint256 public mintPriceEth = 0.015 ether;
1713     uint256 public updatePriceEth = 0.005 ether;
1714 
1715     uint256 public hatchPriceEth = 0.020 ether;
1716     uint256 public trainPriceEth = 0.010 ether;
1717     uint256 public revivePriceEth = 0.030 ether;
1718     uint256 public feedPriceEth = 0.005 ether;
1719 
1720     IERC20 public kryptoPetTokenContract;
1721 
1722     string private _baseTokenURI;
1723 
1724     event minting(uint256 id, address indexed customer);
1725 
1726     constructor(address _walletA, address _kryptoPetTokenContract) ERC721("KryptoPetNFT", "KryptoPetNFT") {
1727         _baseTokenURI = "http://157.245.247.146/pets/";
1728         walletA = _walletA;
1729         kryptoPetTokenContract = IERC20(_kryptoPetTokenContract);
1730     }
1731 
1732     function _baseURI() internal view virtual override returns (string memory) {
1733         return _baseTokenURI;
1734     }
1735 
1736     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1737         uint256 tokenCount = balanceOf(_owner);
1738         if (tokenCount == 0) {
1739             // Return an empty array
1740             return new uint256[](0);
1741         } else {
1742             uint256[] memory result = new uint256[](tokenCount);
1743             uint256 index;
1744             for (index = 0; index < tokenCount; index++) {
1745                 result[index] = tokenOfOwnerByIndex(_owner, index);
1746             }
1747             return result;
1748         }
1749     }
1750 
1751     function airdrop_nft(uint256 _amount, address _destination) public payable returns (uint256[] memory minted)  {
1752         require(_tokenIds.current() < phaseEndsAt, "Minting Phase Ended");
1753         require(_amount>0, "NFT: Invalid amount to mint.");
1754         require(msg.sender == owner(), "Who are you?");
1755         // require(msg.value==_amount*mintPriceEth , "NFT: Invalid value.");
1756 
1757         uint256[] memory tokensMinted;
1758         for (uint256 i = 0; i < _amount; i++) {
1759             _tokenIds.increment();
1760             uint256 newPack = _tokenIds.current();
1761             _mint(_destination, newPack);
1762 
1763             emit minting(newPack, _destination);
1764         }
1765         return tokensMinted;
1766     }
1767 
1768 
1769     function mint_nft_for_eth(uint256 _amount) public payable returns (uint256[] memory minted)  {
1770         require(_tokenIds.current() < phaseEndsAt, "Minting Phase Ended");
1771         require(_amount>0, "NFT: Invalid amount to mint.");
1772         require(msg.value==_amount*mintPriceEth , "NFT: Invalid value.");
1773 
1774         uint256[] memory tokensMinted;
1775         for (uint256 i = 0; i < _amount; i++) {
1776             _tokenIds.increment();
1777             uint256 newPack = _tokenIds.current();
1778             _mint(msg.sender, newPack);
1779 
1780             emit minting(newPack, msg.sender);
1781         }
1782         return tokensMinted;
1783     }
1784 
1785     function getTokensForEth(uint _amountETH) public view returns(uint256){
1786 
1787         IUniswapV2Pair pair = IUniswapV2Pair(0xC525C83168EF7B9D75dAa09581da5A8848Bc3a15);
1788         IERC20 token0 = IERC20(pair.token0());
1789         (uint Res0, uint Res1,) = pair.getReserves();
1790 
1791         // decimals
1792         uint res1 = Res1*(10**token0.decimals());
1793         uint ethPrice = ((10e18*res1)/Res0); // return amount of ETH needed to buy KPET
1794         uint amountTokens = (_amountETH*10e18)/ethPrice;
1795         return amountTokens;
1796     }
1797 
1798 
1799     function mint_nft_for_kpet(uint256 _amount) public payable returns (uint256[] memory minted)  {
1800         require(_tokenIds.current() < phaseEndsAt, "Minting Phase Ended");
1801         require(_amount>0, "NFT: Invalid amount to mint.");
1802 
1803         uint256 numTokensNeeded= getTokensForEth(_amount*mintPriceEth);
1804         // uint256 numTokensNeeded= 10;
1805         require(kryptoPetTokenContract.balanceOf(msg.sender)>=numTokensNeeded, "Insufficient token balance.");
1806         kryptoPetTokenContract.transferFrom(msg.sender, address(this) , numTokensNeeded);
1807 
1808         uint256[] memory tokensMinted;
1809         for (uint256 i = 0; i < _amount; i++) {
1810             _tokenIds.increment();
1811             uint256 newPack = _tokenIds.current();
1812             _mint(msg.sender, newPack);
1813 
1814             emit minting(newPack, msg.sender);
1815         }
1816         return tokensMinted;
1817     }
1818 
1819 
1820     function update_nft_for_eth(uint256 _nftId) public payable returns(uint256){
1821 
1822         uint256 tokenCount = balanceOf(msg.sender);
1823         require(tokenCount > 0, "No NFT for this address");
1824         require(ownerOf(_nftId) == msg.sender, "Not the owner of this NFT");
1825 
1826         return _nftId;
1827 
1828     }
1829 
1830     function update_nft_for_kpet(uint256 _nftId, uint256 _amount) public payable returns(uint256){
1831 
1832         uint256 tokenCount = balanceOf(msg.sender);
1833         // require(msg.value== _amount , "NFT: Invalid value.");
1834         require(tokenCount > 0, "No NFT for this address");
1835         require(ownerOf(_nftId) == msg.sender, "Not the owner of this NFT");
1836 
1837         uint256 numTokensNeeded= getTokensForEth(_amount);
1838         require(kryptoPetTokenContract.balanceOf(msg.sender)>=numTokensNeeded, "Insufficient token balance.");
1839         kryptoPetTokenContract.transferFrom(msg.sender, address(this) , numTokensNeeded);
1840 
1841         return _nftId;
1842 
1843     }
1844 
1845     function revive_nft_for_eth(uint256 _nftId) public payable returns(uint256){
1846        require(msg.value== revivePriceEth , "NFT: Invalid value.");
1847         return update_nft_for_eth(_nftId);
1848     }
1849 
1850     function revive_nft_for_kpet(uint256 _nftId) public payable returns(uint256){
1851         return update_nft_for_kpet(_nftId, revivePriceEth);
1852     }
1853 
1854     function feed_nft_for_eth(uint256 _nftId) public payable returns(uint256){
1855         require(msg.value== feedPriceEth , "NFT: Invalid value.");
1856         return update_nft_for_eth(_nftId);
1857     }
1858 
1859     function feed_nft_for_kpet(uint256 _nftId) public payable returns(uint256){
1860         return update_nft_for_kpet(_nftId, feedPriceEth);
1861     }
1862 
1863     function train_nft_for_eth(uint256 _nftId) public payable returns(uint256){
1864         require(msg.value== trainPriceEth , "NFT: Invalid value.");
1865         return update_nft_for_eth(_nftId);
1866     }
1867 
1868     function train_nft_for_kpet(uint256 _nftId) public payable returns(uint256){
1869         return update_nft_for_kpet(_nftId, trainPriceEth);
1870     }
1871 
1872     function hatch_nft_for_eth(uint256 _nftId) public payable returns(uint256){
1873         require(msg.value== hatchPriceEth , "NFT: Invalid value.");
1874         return update_nft_for_eth(_nftId);
1875     }
1876 
1877     function hatch_nft_for_kpet(uint256 _nftId) public payable returns(uint256){
1878         return update_nft_for_kpet(_nftId, hatchPriceEth);
1879     }
1880 
1881     function setEthMintPrice(uint256 _priceEth) public onlyOwner {
1882          mintPriceEth =_priceEth;
1883     }
1884 
1885     function setEthUpdatePrice(uint256 _priceEth) public onlyOwner {
1886          updatePriceEth =_priceEth;
1887     }
1888 
1889     function setEthHatchPrice(uint256 _priceEth) public onlyOwner {
1890          hatchPriceEth =_priceEth;
1891     }
1892 
1893     function setEthFeedPrice(uint256 _priceEth) public onlyOwner {
1894          feedPriceEth =_priceEth;
1895     }
1896 
1897     function setEthRevivePrice(uint256 _priceEth) public onlyOwner {
1898          revivePriceEth =_priceEth;
1899     }
1900 
1901     function setEthTrainPrice(uint256 _priceEth) public onlyOwner {
1902          trainPriceEth =_priceEth;
1903     }
1904 
1905     function withdraw_all() public onlyClevel {
1906 
1907         if(address(this).balance>0){
1908             uint256 amountEthA = address(this).balance;
1909             payable(walletA).transfer(amountEthA);
1910         }
1911 
1912         uint256 tokenBalance = kryptoPetTokenContract.balanceOf(address(this));
1913         if (tokenBalance>0){
1914             kryptoPetTokenContract.safeTransfer(walletA, tokenBalance);
1915         }
1916 
1917     }
1918 
1919     function setKryptoPetContractAddress(address _kryptoPetTokenContract) public onlyOwner {
1920         kryptoPetTokenContract = IERC20(_kryptoPetTokenContract);
1921     }
1922 
1923     function setWalletA(address _walletA) public {
1924         require (msg.sender == walletA, "Who are you?");
1925         require (_walletA != address(0x0), "Invalid wallet");
1926         walletA = _walletA;
1927     }
1928 
1929     function setPhaseEndsAt(uint256 _phaseEnds) public onlyOwner{
1930         phaseEndsAt = _phaseEnds;
1931     }
1932 
1933 }