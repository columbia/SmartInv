1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
30 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
174 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
203 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
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
231 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
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
448 // File: @openzeppelin/contracts/utils/Context.sol
449 
450 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464 abstract contract Context {
465     function _msgSender() internal view virtual returns (address) {
466         return msg.sender;
467     }
468 
469     function _msgData() internal view virtual returns (bytes calldata) {
470         return msg.data;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/Strings.sol
475 
476 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
545 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Implementation of the {IERC165} interface.
552  *
553  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
554  * for the additional interface id that will be supported. For example:
555  *
556  * ```solidity
557  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
559  * }
560  * ```
561  *
562  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
563  */
564 abstract contract ERC165 is IERC165 {
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
574 
575 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 
582 
583 
584 
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         _setApprovalForAll(_msgSender(), operator, approved);
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
930      * @dev Approve `operator` to operate on all of `owner` tokens
931      *
932      * Emits a {ApprovalForAll} event.
933      */
934     function _setApprovalForAll(
935         address owner,
936         address operator,
937         bool approved
938     ) internal virtual {
939         require(owner != operator, "ERC721: approve to caller");
940         _operatorApprovals[owner][operator] = approved;
941         emit ApprovalForAll(owner, operator, approved);
942     }
943 
944     /**
945      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
946      * The call is not executed if the target address is not a contract.
947      *
948      * @param from address representing the previous owner of the given token ID
949      * @param to target address that will receive the tokens
950      * @param tokenId uint256 ID of the token to be transferred
951      * @param _data bytes optional data to send along with the call
952      * @return bool whether the call correctly returned the expected magic value
953      */
954     function _checkOnERC721Received(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) private returns (bool) {
960         if (to.isContract()) {
961             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
962                 return retval == IERC721Receiver.onERC721Received.selector;
963             } catch (bytes memory reason) {
964                 if (reason.length == 0) {
965                     revert("ERC721: transfer to non ERC721Receiver implementer");
966                 } else {
967                     assembly {
968                         revert(add(32, reason), mload(reason))
969                     }
970                 }
971             }
972         } else {
973             return true;
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before any token transfer. This includes minting
979      * and burning.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` will be minted for `to`.
986      * - When `to` is zero, ``from``'s `tokenId` will be burned.
987      * - `from` and `to` are never both zero.
988      *
989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
990      */
991     function _beforeTokenTransfer(
992         address from,
993         address to,
994         uint256 tokenId
995     ) internal virtual {}
996 }
997 
998 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
999 
1000 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721URIStorage.sol)
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 /**
1006  * @dev ERC721 token with storage based token URI management.
1007  */
1008 abstract contract ERC721URIStorage is ERC721 {
1009     using Strings for uint256;
1010 
1011     // Optional mapping for token URIs
1012     mapping(uint256 => string) private _tokenURIs;
1013 
1014     /**
1015      * @dev See {IERC721Metadata-tokenURI}.
1016      */
1017     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1018         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1019 
1020         string memory _tokenURI = _tokenURIs[tokenId];
1021         string memory base = _baseURI();
1022 
1023         // If there is no base URI, return the token URI.
1024         if (bytes(base).length == 0) {
1025             return _tokenURI;
1026         }
1027         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1028         if (bytes(_tokenURI).length > 0) {
1029             return string(abi.encodePacked(base, _tokenURI));
1030         }
1031 
1032         return super.tokenURI(tokenId);
1033     }
1034 
1035     /**
1036      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      */
1042     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1043         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1044         _tokenURIs[tokenId] = _tokenURI;
1045     }
1046 
1047     /**
1048      * @dev Destroys `tokenId`.
1049      * The approval is cleared when the token is burned.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _burn(uint256 tokenId) internal virtual override {
1058         super._burn(tokenId);
1059 
1060         if (bytes(_tokenURIs[tokenId]).length != 0) {
1061             delete _tokenURIs[tokenId];
1062         }
1063     }
1064 }
1065 
1066 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1067 
1068 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1075  * @dev See https://eips.ethereum.org/EIPS/eip-721
1076  */
1077 interface IERC721Enumerable is IERC721 {
1078     /**
1079      * @dev Returns the total amount of tokens stored by the contract.
1080      */
1081     function totalSupply() external view returns (uint256);
1082 
1083     /**
1084      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1085      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1088 
1089     /**
1090      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1091      * Use along with {totalSupply} to enumerate all tokens.
1092      */
1093     function tokenByIndex(uint256 index) external view returns (uint256);
1094 }
1095 
1096 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1097 
1098 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 
1103 
1104 /**
1105  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1106  * enumerability of all the token ids in the contract as well as all token ids owned by each
1107  * account.
1108  */
1109 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1110     // Mapping from owner to list of owned token IDs
1111     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1112 
1113     // Mapping from token ID to index of the owner tokens list
1114     mapping(uint256 => uint256) private _ownedTokensIndex;
1115 
1116     // Array with all token ids, used for enumeration
1117     uint256[] private _allTokens;
1118 
1119     // Mapping from token id to position in the allTokens array
1120     mapping(uint256 => uint256) private _allTokensIndex;
1121 
1122     /**
1123      * @dev See {IERC165-supportsInterface}.
1124      */
1125     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1126         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1131      */
1132     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1133         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1134         return _ownedTokens[owner][index];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Enumerable-totalSupply}.
1139      */
1140     function totalSupply() public view virtual override returns (uint256) {
1141         return _allTokens.length;
1142     }
1143 
1144     /**
1145      * @dev See {IERC721Enumerable-tokenByIndex}.
1146      */
1147     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1148         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1149         return _allTokens[index];
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` cannot be the zero address.
1163      * - `to` cannot be the zero address.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _beforeTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual override {
1172         super._beforeTokenTransfer(from, to, tokenId);
1173 
1174         if (from == address(0)) {
1175             _addTokenToAllTokensEnumeration(tokenId);
1176         } else if (from != to) {
1177             _removeTokenFromOwnerEnumeration(from, tokenId);
1178         }
1179         if (to == address(0)) {
1180             _removeTokenFromAllTokensEnumeration(tokenId);
1181         } else if (to != from) {
1182             _addTokenToOwnerEnumeration(to, tokenId);
1183         }
1184     }
1185 
1186     /**
1187      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1188      * @param to address representing the new owner of the given token ID
1189      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1190      */
1191     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1192         uint256 length = ERC721.balanceOf(to);
1193         _ownedTokens[to][length] = tokenId;
1194         _ownedTokensIndex[tokenId] = length;
1195     }
1196 
1197     /**
1198      * @dev Private function to add a token to this extension's token tracking data structures.
1199      * @param tokenId uint256 ID of the token to be added to the tokens list
1200      */
1201     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1202         _allTokensIndex[tokenId] = _allTokens.length;
1203         _allTokens.push(tokenId);
1204     }
1205 
1206     /**
1207      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1208      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1209      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1210      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1211      * @param from address representing the previous owner of the given token ID
1212      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1213      */
1214     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1215         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1216         // then delete the last slot (swap and pop).
1217 
1218         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1219         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1220 
1221         // When the token to delete is the last token, the swap operation is unnecessary
1222         if (tokenIndex != lastTokenIndex) {
1223             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1224 
1225             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1226             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1227         }
1228 
1229         // This also deletes the contents at the last position of the array
1230         delete _ownedTokensIndex[tokenId];
1231         delete _ownedTokens[from][lastTokenIndex];
1232     }
1233 
1234     /**
1235      * @dev Private function to remove a token from this extension's token tracking data structures.
1236      * This has O(1) time complexity, but alters the order of the _allTokens array.
1237      * @param tokenId uint256 ID of the token to be removed from the tokens list
1238      */
1239     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1240         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1241         // then delete the last slot (swap and pop).
1242 
1243         uint256 lastTokenIndex = _allTokens.length - 1;
1244         uint256 tokenIndex = _allTokensIndex[tokenId];
1245 
1246         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1247         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1248         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1249         uint256 lastTokenId = _allTokens[lastTokenIndex];
1250 
1251         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1252         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1253 
1254         // This also deletes the contents at the last position of the array
1255         delete _allTokensIndex[tokenId];
1256         _allTokens.pop();
1257     }
1258 }
1259 
1260 // File: @openzeppelin/contracts/access/Ownable.sol
1261 
1262 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 
1267 /**
1268  * @dev Contract module which provides a basic access control mechanism, where
1269  * there is an account (an owner) that can be granted exclusive access to
1270  * specific functions.
1271  *
1272  * By default, the owner account will be the one that deploys the contract. This
1273  * can later be changed with {transferOwnership}.
1274  *
1275  * This module is used through inheritance. It will make available the modifier
1276  * `onlyOwner`, which can be applied to your functions to restrict their use to
1277  * the owner.
1278  */
1279 abstract contract Ownable is Context {
1280     address private _owner;
1281 
1282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1283 
1284     /**
1285      * @dev Initializes the contract setting the deployer as the initial owner.
1286      */
1287     constructor() {
1288         _transferOwnership(_msgSender());
1289     }
1290 
1291     /**
1292      * @dev Returns the address of the current owner.
1293      */
1294     function owner() public view virtual returns (address) {
1295         return _owner;
1296     }
1297 
1298     /**
1299      * @dev Throws if called by any account other than the owner.
1300      */
1301     modifier onlyOwner() {
1302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1303         _;
1304     }
1305 
1306     /**
1307      * @dev Leaves the contract without owner. It will not be possible to call
1308      * `onlyOwner` functions anymore. Can only be called by the current owner.
1309      *
1310      * NOTE: Renouncing ownership will leave the contract without an owner,
1311      * thereby removing any functionality that is only available to the owner.
1312      */
1313     function renounceOwnership() public virtual onlyOwner {
1314         _transferOwnership(address(0));
1315     }
1316 
1317     /**
1318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1319      * Can only be called by the current owner.
1320      */
1321     function transferOwnership(address newOwner) public virtual onlyOwner {
1322         require(newOwner != address(0), "Ownable: new owner is the zero address");
1323         _transferOwnership(newOwner);
1324     }
1325 
1326     /**
1327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1328      * Internal function without access restriction.
1329      */
1330     function _transferOwnership(address newOwner) internal virtual {
1331         address oldOwner = _owner;
1332         _owner = newOwner;
1333         emit OwnershipTransferred(oldOwner, newOwner);
1334     }
1335 }
1336 
1337 // File: contracts/BabyDeluxe.sol
1338 
1339 pragma solidity ^0.8.10;
1340 
1341 
1342 
1343 
1344 
1345 
1346 
1347 contract BabyDeluxe is ERC721Enumerable, Ownable {
1348   using Strings for uint256;
1349   using Address for address;
1350 
1351   struct Conf {
1352         uint16 supply;
1353         uint16 _reserved;
1354         uint16 maxBabies;
1355         uint64 price;
1356     }
1357    
1358     address private controller;
1359     address public fundsWallet;
1360     bool public mintEnabled = false;
1361     bool public whitelistMintEnabled = false;
1362     uint8 public perMint = 10;
1363     uint16 public perWhitelistAccount = 5;
1364     uint16 public perAccount = 300;
1365     uint256 public imagesHash;
1366     string private defaultURI;
1367     string private baseURI;
1368     string private metaURI;
1369     mapping (address => bool) public whitelist;
1370 
1371     
1372 
1373     mapping(uint256 => uint256) private metaHashes;
1374 
1375     Conf private conf;
1376 
1377     event updateMetaHash(address, uint256, uint256);
1378 
1379     modifier isController(address sender) {
1380         require(
1381             sender != address(0) && (sender == owner() || sender == controller)
1382         );
1383         _;
1384     }
1385 
1386     /**
1387      * @notice Setup ERC721 and initial config
1388      */
1389     constructor(
1390         string memory name,
1391         string memory symbol,
1392         string memory _defaultURI,
1393         address _fundsWallet
1394     ) ERC721(name, symbol) {
1395         require(_fundsWallet != address(0), "Zero address error");
1396         fundsWallet = _fundsWallet;
1397         conf = Conf(0, 100, 3500, 50000000000000000);
1398         defaultURI = _defaultURI;
1399     }
1400 
1401     /**
1402      * @notice Send ETH to owners wallet 
1403      */
1404     function ownerWithdraw() public onlyOwner {
1405         uint256 balance = address(this).balance;
1406         payable(msg.sender).transfer(balance);
1407     }
1408 
1409     /**
1410      * @notice send contract eth to fundswallet 
1411      */
1412     function fundsWithdraw() public onlyOwner {
1413         uint256 balance = address(this).balance;
1414         payable(fundsWallet).transfer(balance);
1415     }
1416 
1417     /**
1418      * @notice Send reserved babies 
1419      * @param _to address to send reserved nfts to.
1420      * @param _amount number of nfts to send 
1421      */
1422     function fetchTeamReserved(address _to, uint16 _amount)
1423         public
1424         onlyOwner
1425     {
1426         require( _to !=  address(0), "Zero address error");
1427         require( _amount <= conf._reserved, "Exceeds reserved babies supply");
1428         uint16 supply = conf.supply;
1429         unchecked {
1430           for (uint8 i = 0; i < _amount; i++) {
1431               _safeMint(_to, supply++);
1432           }
1433         }
1434         conf.supply = supply;
1435         conf._reserved -= _amount;
1436     }
1437 
1438     /**
1439      * @notice Bring new Babies into the world.
1440      * @param amount Number of Babies to mint.
1441      * @dev Utilize unchecked {} and calldata for gas savings.
1442      */
1443     function mint(uint256 amount) public payable {
1444         require(mintEnabled, "Minting is disabled.");
1445         require(
1446             conf.supply + amount <= conf.maxBabies - conf._reserved,
1447             "Amount exceeds maximum supply of Babies."
1448         );
1449         require(
1450             balanceOf(msg.sender) + amount <= perAccount,
1451             "Amount exceeds current maximum mints per account."
1452         );
1453         require(
1454             amount <= perMint,
1455             "Amount exceeds current maximum Babies per mint."
1456         );
1457         require(
1458             conf.price * amount <= msg.value,
1459             "Ether value sent is not correct."
1460         );
1461 
1462         uint16 supply = conf.supply;
1463         unchecked {
1464             for (uint16 i = 0; i < amount; i++) {
1465                 _safeMint(msg.sender, supply++);
1466             }
1467         }
1468         conf.supply = supply;
1469     }
1470 
1471     // Whitelist functions
1472 
1473     /**
1474      * @notice add addresses to whitelist in bulk.
1475      * @param addresses Arrary of whitelisted addresses
1476      * @dev Only authorized accounts.
1477      */
1478     function bulkWhitelist(address[] memory addresses) public onlyOwner {
1479         for(uint i=0; i < addresses.length; i++){
1480             address addr = addresses[i];
1481             if(whitelist[addr] != true && addr != address(0)){
1482                 whitelist[addr] = true;
1483             }
1484         }
1485     }
1486 
1487     /**
1488      * @notice Whitelist Bring new Babies into the world.
1489      * @param amount Number of Babies to mint.
1490      * @dev Utilize unchecked {} and calldata for gas savings.
1491      */
1492     function whitelistMint(uint256 amount) public payable {
1493         require(whitelistMintEnabled, "Whitelist Minting is disabled.");
1494         require( whitelist[msg.sender] == true, "Only whitelist can mint" );
1495         require(
1496             conf.supply + amount <= conf.maxBabies - conf._reserved,
1497             "Amount exceeds maximum supply of Babies."
1498         );
1499         require(
1500             balanceOf(msg.sender) + amount <= perWhitelistAccount,
1501             "Amount exceeds current maximum mints per account."
1502         );
1503         require(
1504             amount <= perMint,
1505             "Amount exceeds current maximum Babies per mint."
1506         );
1507         require(
1508             conf.price * amount <= msg.value,
1509             "Ether value sent is not correct."
1510         );
1511 
1512         uint16 supply = conf.supply;
1513         unchecked {
1514             for (uint16 i = 0; i < amount; i++) {
1515                 _safeMint(msg.sender, supply++);
1516             }
1517         }
1518         conf.supply = supply;
1519     }
1520 
1521     /**
1522      * @notice Toggle white list mint status.
1523      * @dev Only authorized accounts.
1524      */
1525     function toggleWhitelistMintEnabled() public onlyOwner {
1526         whitelistMintEnabled = !whitelistMintEnabled;
1527     }
1528 
1529     /**
1530      * @notice Set price.
1531      * @param newPrice new minting price
1532      * @dev Only authorized accounts.
1533      */
1534     function setPrice(uint64 newPrice) public onlyOwner {
1535         conf.price = newPrice;
1536     }
1537 
1538     /**
1539      * @notice Set funds wallet.
1540      * @param _fundsWallet new funds wallet address 
1541      * @dev Only authorized accounts.
1542      */
1543     function setFundsWallet(address _fundsWallet) public onlyOwner {
1544         require(_fundsWallet != address(0), "Zero address error");
1545         fundsWallet = _fundsWallet;
1546     }
1547 
1548     /**
1549      * @notice Set meta hash for token.
1550      * @param id Token id.
1551      * @param _hash Hash value.
1552      * @dev Only authorized accounts.
1553      */
1554     function setMetaHash(uint256 id, uint256 _hash)
1555         public
1556         isController(msg.sender)
1557     {
1558         require(_exists(id), "Token does not exist.");
1559         metaHashes[id] = _hash;
1560         emit updateMetaHash(msg.sender, id, _hash);
1561     }
1562 
1563     /**
1564      * @notice Return mint price.
1565      */
1566     function getMintPrice() public view returns (uint64) {
1567         return conf.price;
1568     }
1569 
1570     /**
1571      * @notice Return meta hash for token.
1572      */
1573     function getMetaHash(uint256 id) public view returns (uint256) {
1574         return metaHashes[id];
1575     }
1576 
1577     /**
1578      * @notice Sets URI for image hashes.
1579      */
1580     function setImagesHash(uint256 _imagesHash) public onlyOwner {
1581         imagesHash = _imagesHash;
1582     }
1583 
1584     /**
1585      * @notice Toggles minting state.
1586      */
1587     function toggleMintEnabled() public onlyOwner {
1588         mintEnabled = !mintEnabled;
1589     }
1590 
1591     /**
1592      * @notice Sets max Babies per mint.
1593      */
1594     function setPerMint(uint8 _perMint) public onlyOwner {
1595         perMint = _perMint;
1596     }
1597 
1598     /**
1599      * @notice Sets max mints per account.
1600      */
1601     function setPerAccount(uint16 _perAccount) public onlyOwner {
1602         perAccount = _perAccount;
1603     }
1604     
1605     /**
1606      * @notice Sets max mints per whitelist account.
1607      */
1608     function setPerWhitelistAccount(uint16 _perAccount) public onlyOwner {
1609         perWhitelistAccount = _perAccount;
1610     }
1611 
1612     /**
1613      * @notice Set base URI.
1614      */
1615     function setBaseURI(string memory _baseURI) public onlyOwner {
1616         baseURI = _baseURI;
1617     }
1618 
1619     /**
1620      * @notice Set default URI.
1621      */
1622     function setDefaultURI(string memory _defaultURI) public onlyOwner {
1623         defaultURI = _defaultURI;
1624     }
1625 
1626     function tokenURI(uint256 tokenId)
1627         public
1628         view
1629         override
1630         returns (string memory)
1631     {
1632         require(_exists(tokenId), "Token does not exist.");
1633 
1634         if (bytes(baseURI).length == 0) {
1635             return defaultURI;
1636         } else {
1637             return string(abi.encodePacked(baseURI, (tokenId).toString()));
1638         }
1639     }
1640 
1641 }