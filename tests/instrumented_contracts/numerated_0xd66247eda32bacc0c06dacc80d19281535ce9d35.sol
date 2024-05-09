1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
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
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
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
172 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
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
201 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
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
228 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
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
446 
447 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
448 
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
472 
473 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
474 
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
541 
542 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
543 
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
570 
571 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
572 
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
982 
983 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
984 
985 
986 pragma solidity ^0.8.0;
987 
988 /**
989  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
990  * @dev See https://eips.ethereum.org/EIPS/eip-721
991  */
992 interface IERC721Enumerable is IERC721 {
993     /**
994      * @dev Returns the total amount of tokens stored by the contract.
995      */
996     function totalSupply() external view returns (uint256);
997 
998     /**
999      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1000      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1001      */
1002     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1003 
1004     /**
1005      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1006      * Use along with {totalSupply} to enumerate all tokens.
1007      */
1008     function tokenByIndex(uint256 index) external view returns (uint256);
1009 }
1010 
1011 
1012 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1013 
1014 
1015 pragma solidity ^0.8.0;
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
1174 
1175 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.3.2
1176 
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 /**
1181  * @dev ERC721 token with storage based token URI management.
1182  */
1183 abstract contract ERC721URIStorage is ERC721 {
1184     using Strings for uint256;
1185 
1186     // Optional mapping for token URIs
1187     mapping(uint256 => string) private _tokenURIs;
1188 
1189     /**
1190      * @dev See {IERC721Metadata-tokenURI}.
1191      */
1192     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1193         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1194 
1195         string memory _tokenURI = _tokenURIs[tokenId];
1196         string memory base = _baseURI();
1197 
1198         // If there is no base URI, return the token URI.
1199         if (bytes(base).length == 0) {
1200             return _tokenURI;
1201         }
1202         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1203         if (bytes(_tokenURI).length > 0) {
1204             return string(abi.encodePacked(base, _tokenURI));
1205         }
1206 
1207         return super.tokenURI(tokenId);
1208     }
1209 
1210     /**
1211      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      */
1217     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1218         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1219         _tokenURIs[tokenId] = _tokenURI;
1220     }
1221 
1222     /**
1223      * @dev Destroys `tokenId`.
1224      * The approval is cleared when the token is burned.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _burn(uint256 tokenId) internal virtual override {
1233         super._burn(tokenId);
1234 
1235         if (bytes(_tokenURIs[tokenId]).length != 0) {
1236             delete _tokenURIs[tokenId];
1237         }
1238     }
1239 }
1240 
1241 
1242 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1243 
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 /**
1248  * @dev Contract module which provides a basic access control mechanism, where
1249  * there is an account (an owner) that can be granted exclusive access to
1250  * specific functions.
1251  *
1252  * By default, the owner account will be the one that deploys the contract. This
1253  * can later be changed with {transferOwnership}.
1254  *
1255  * This module is used through inheritance. It will make available the modifier
1256  * `onlyOwner`, which can be applied to your functions to restrict their use to
1257  * the owner.
1258  */
1259 abstract contract Ownable is Context {
1260     address private _owner;
1261 
1262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1263 
1264     /**
1265      * @dev Initializes the contract setting the deployer as the initial owner.
1266      */
1267     constructor() {
1268         _setOwner(_msgSender());
1269     }
1270 
1271     /**
1272      * @dev Returns the address of the current owner.
1273      */
1274     function owner() public view virtual returns (address) {
1275         return _owner;
1276     }
1277 
1278     /**
1279      * @dev Throws if called by any account other than the owner.
1280      */
1281     modifier onlyOwner() {
1282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Leaves the contract without owner. It will not be possible to call
1288      * `onlyOwner` functions anymore. Can only be called by the current owner.
1289      *
1290      * NOTE: Renouncing ownership will leave the contract without an owner,
1291      * thereby removing any functionality that is only available to the owner.
1292      */
1293     function renounceOwnership() public virtual onlyOwner {
1294         _setOwner(address(0));
1295     }
1296 
1297     /**
1298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1299      * Can only be called by the current owner.
1300      */
1301     function transferOwnership(address newOwner) public virtual onlyOwner {
1302         require(newOwner != address(0), "Ownable: new owner is the zero address");
1303         _setOwner(newOwner);
1304     }
1305 
1306     function _setOwner(address newOwner) private {
1307         address oldOwner = _owner;
1308         _owner = newOwner;
1309         emit OwnershipTransferred(oldOwner, newOwner);
1310     }
1311 }
1312 
1313 
1314 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1315 
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 /**
1320  * @title Counters
1321  * @author Matt Condon (@shrugs)
1322  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1323  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1324  *
1325  * Include with `using Counters for Counters.Counter;`
1326  */
1327 library Counters {
1328     struct Counter {
1329         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1330         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1331         // this feature: see https://github.com/ethereum/solidity/issues/4637
1332         uint256 _value; // default: 0
1333     }
1334 
1335     function current(Counter storage counter) internal view returns (uint256) {
1336         return counter._value;
1337     }
1338 
1339     function increment(Counter storage counter) internal {
1340         unchecked {
1341             counter._value += 1;
1342         }
1343     }
1344 
1345     function decrement(Counter storage counter) internal {
1346         uint256 value = counter._value;
1347         require(value > 0, "Counter: decrement overflow");
1348         unchecked {
1349             counter._value = value - 1;
1350         }
1351     }
1352 
1353     function reset(Counter storage counter) internal {
1354         counter._value = 0;
1355     }
1356 }
1357 
1358 
1359 // File contracts/ZombieFishMafia.sol
1360 
1361 ///////////////////////////////////////////////////////////////////////////////////////////
1362 //                                                                                        //
1363 //                                                                                        //
1364 //        ____                      __   _______      __       __  ___      _____         //
1365 //       / __ )____ _________  ____/ /  / ____(_)____/ /_     /  |/  /___ _/ __(_)___ _   //
1366 //      / __  / __ `/ ___/ _ \/ __  /  / /_  / / ___/ __ \   / /|_/ / __ `/ /_/ / __ `/   //
1367 //     / /_/ / /_/ (__  )  __/ /_/ /  / __/ / (__  ) / / /  / /  / / /_/ / __/ / /_/ /    //
1368 //    /_____/\__,_/____/\___/\__,_/  /_/   /_/____/_/ /_/  /_/  /_/\__,_/_/ /_/\__,_/     //
1369 //                                                                                        //
1370 //                                                                                        //
1371 //                             [ZOMBIE FISH MAFIA COLLECTION]                             //
1372 ////////////////////////////////////////////////////////////////////////////////////////////
1373 
1374 pragma solidity ^0.8.2;
1375 
1376 contract ZombieFishMafia is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
1377     using Counters for Counters.Counter;
1378 
1379     Counters.Counter private _tokenIdCounter;
1380 
1381     constructor() ERC721("Zombie Fish Mafia", "ZFM") {}
1382 
1383     function mintNFT(address recipient, string memory tokenURI)
1384         public onlyOwner
1385         returns (uint256)
1386     {
1387         _tokenIdCounter.increment();
1388 
1389         uint256 newItemId = _tokenIdCounter.current();
1390         _mint(recipient, newItemId);
1391         _setTokenURI(newItemId, tokenURI);
1392 
1393         return newItemId;
1394     }
1395     // The following functions are overrides required by Solidity.
1396 
1397     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1398         internal
1399         override(ERC721, ERC721Enumerable)
1400     {
1401         super._beforeTokenTransfer(from, to, tokenId);
1402     }
1403 
1404     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1405         super._burn(tokenId);
1406     }
1407 
1408     function tokenURI(uint256 tokenId)
1409         public
1410         view
1411         override(ERC721, ERC721URIStorage)
1412         returns (string memory)
1413     {
1414         return super.tokenURI(tokenId);
1415     }
1416 
1417     function supportsInterface(bytes4 interfaceId)
1418         public
1419         view
1420         override(ERC721, ERC721Enumerable)
1421         returns (bool)
1422     {
1423         return super.supportsInterface(interfaceId);
1424     }
1425 }