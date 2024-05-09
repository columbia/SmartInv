1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
173 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/utils/Context.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 // File: @openzeppelin/contracts/utils/Strings.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497 
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
559  * for the additional interface id that will be supported. For example:
560  *
561  * ```solidity
562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
564  * }
565  * ```
566  *
567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
568  */
569 abstract contract ERC165 is IERC165 {
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         return interfaceId == type(IERC165).interfaceId;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 
587 
588 
589 
590 
591 /**
592  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
593  * the Metadata extension, but not including the Enumerable extension, which is available separately as
594  * {ERC721Enumerable}.
595  */
596 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
597     using Address for address;
598     using Strings for uint256;
599 
600     // Token name
601     string private _name;
602 
603     // Token symbol
604     string private _symbol;
605 
606     // Mapping from token ID to owner address
607     mapping(uint256 => address) private _owners;
608 
609     // Mapping owner address to token count
610     mapping(address => uint256) private _balances;
611 
612     // Mapping from token ID to approved address
613     mapping(uint256 => address) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     /**
619      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
620      */
621     constructor(string memory name_, string memory symbol_) {
622         _name = name_;
623         _symbol = symbol_;
624     }
625 
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
630         return
631             interfaceId == type(IERC721).interfaceId ||
632             interfaceId == type(IERC721Metadata).interfaceId ||
633             super.supportsInterface(interfaceId);
634     }
635 
636     /**
637      * @dev See {IERC721-balanceOf}.
638      */
639     function balanceOf(address owner) public view virtual override returns (uint256) {
640         require(owner != address(0), "ERC721: balance query for the zero address");
641         return _balances[owner];
642     }
643 
644     /**
645      * @dev See {IERC721-ownerOf}.
646      */
647     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
648         address owner = _owners[tokenId];
649         require(owner != address(0), "ERC721: owner query for nonexistent token");
650         return owner;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-name}.
655      */
656     function name() public view virtual override returns (string memory) {
657         return _name;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-symbol}.
662      */
663     function symbol() public view virtual override returns (string memory) {
664         return _symbol;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-tokenURI}.
669      */
670     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
671         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
672 
673         string memory baseURI = _baseURI();
674         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
675     }
676 
677     /**
678      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
679      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
680      * by default, can be overriden in child contracts.
681      */
682     function _baseURI() internal view virtual returns (string memory) {
683         return "";
684     }
685 
686     /**
687      * @dev See {IERC721-approve}.
688      */
689     function approve(address to, uint256 tokenId) public virtual override {
690         address owner = ERC721.ownerOf(tokenId);
691         require(to != owner, "ERC721: approval to current owner");
692 
693         require(
694             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
695             "ERC721: approve caller is not owner nor approved for all"
696         );
697 
698         _approve(to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-getApproved}.
703      */
704     function getApproved(uint256 tokenId) public view virtual override returns (address) {
705         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
706 
707         return _tokenApprovals[tokenId];
708     }
709 
710     /**
711      * @dev See {IERC721-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved) public virtual override {
714         _setApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Approve `operator` to operate on all of `owner` tokens
936      *
937      * Emits a {ApprovalForAll} event.
938      */
939     function _setApprovalForAll(
940         address owner,
941         address operator,
942         bool approved
943     ) internal virtual {
944         require(owner != operator, "ERC721: approve to caller");
945         _operatorApprovals[owner][operator] = approved;
946         emit ApprovalForAll(owner, operator, approved);
947     }
948 
949     /**
950      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
951      * The call is not executed if the target address is not a contract.
952      *
953      * @param from address representing the previous owner of the given token ID
954      * @param to target address that will receive the tokens
955      * @param tokenId uint256 ID of the token to be transferred
956      * @param _data bytes optional data to send along with the call
957      * @return bool whether the call correctly returned the expected magic value
958      */
959     function _checkOnERC721Received(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) private returns (bool) {
965         if (to.isContract()) {
966             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
967                 return retval == IERC721Receiver.onERC721Received.selector;
968             } catch (bytes memory reason) {
969                 if (reason.length == 0) {
970                     revert("ERC721: transfer to non ERC721Receiver implementer");
971                 } else {
972                     assembly {
973                         revert(add(32, reason), mload(reason))
974                     }
975                 }
976             }
977         } else {
978             return true;
979         }
980     }
981 
982     /**
983      * @dev Hook that is called before any token transfer. This includes minting
984      * and burning.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, ``from``'s `tokenId` will be burned.
992      * - `from` and `to` are never both zero.
993      *
994      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
995      */
996     function _beforeTokenTransfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) internal virtual {}
1001 }
1002 
1003 // File: @openzeppelin/contracts/access/Ownable.sol
1004 
1005 
1006 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 /**
1011  * @dev Contract module which provides a basic access control mechanism, where
1012  * there is an account (an owner) that can be granted exclusive access to
1013  * specific functions.
1014  *
1015  * By default, the owner account will be the one that deploys the contract. This
1016  * can later be changed with {transferOwnership}.
1017  *
1018  * This module is used through inheritance. It will make available the modifier
1019  * `onlyOwner`, which can be applied to your functions to restrict their use to
1020  * the owner.
1021  */
1022 abstract contract Ownable is Context {
1023     address private _owner;
1024 
1025     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1026 
1027     /**
1028      * @dev Initializes the contract setting the deployer as the initial owner.
1029      */
1030     constructor() {
1031         _transferOwnership(_msgSender());
1032     }
1033 
1034     /**
1035      * @dev Returns the address of the current owner.
1036      */
1037     function owner() public view virtual returns (address) {
1038         return _owner;
1039     }
1040 
1041     /**
1042      * @dev Throws if called by any account other than the owner.
1043      */
1044     modifier onlyOwner() {
1045         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1046         _;
1047     }
1048 
1049     /**
1050      * @dev Leaves the contract without owner. It will not be possible to call
1051      * `onlyOwner` functions anymore. Can only be called by the current owner.
1052      *
1053      * NOTE: Renouncing ownership will leave the contract without an owner,
1054      * thereby removing any functionality that is only available to the owner.
1055      */
1056     function renounceOwnership() public virtual onlyOwner {
1057         _transferOwnership(address(0));
1058     }
1059 
1060     /**
1061      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1062      * Can only be called by the current owner.
1063      */
1064     function transferOwnership(address newOwner) public virtual onlyOwner {
1065         require(newOwner != address(0), "Ownable: new owner is the zero address");
1066         _transferOwnership(newOwner);
1067     }
1068 
1069     /**
1070      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1071      * Internal function without access restriction.
1072      */
1073     function _transferOwnership(address newOwner) internal virtual {
1074         address oldOwner = _owner;
1075         _owner = newOwner;
1076         emit OwnershipTransferred(oldOwner, newOwner);
1077     }
1078 }
1079 
1080 // File: @openzeppelin/contracts/utils/Counters.sol
1081 
1082 
1083 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 /**
1088  * @title Counters
1089  * @author Matt Condon (@shrugs)
1090  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1091  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1092  *
1093  * Include with `using Counters for Counters.Counter;`
1094  */
1095 library Counters {
1096     struct Counter {
1097         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1098         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1099         // this feature: see https://github.com/ethereum/solidity/issues/4637
1100         uint256 _value; // default: 0
1101     }
1102 
1103     function current(Counter storage counter) internal view returns (uint256) {
1104         return counter._value;
1105     }
1106 
1107     function increment(Counter storage counter) internal {
1108         unchecked {
1109             counter._value += 1;
1110         }
1111     }
1112 
1113     function decrement(Counter storage counter) internal {
1114         uint256 value = counter._value;
1115         require(value > 0, "Counter: decrement overflow");
1116         unchecked {
1117             counter._value = value - 1;
1118         }
1119     }
1120 
1121     function reset(Counter storage counter) internal {
1122         counter._value = 0;
1123     }
1124 }
1125 
1126 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1127 
1128 
1129 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 // CAUTION
1134 // This version of SafeMath should only be used with Solidity 0.8 or later,
1135 // because it relies on the compiler's built in overflow checks.
1136 
1137 /**
1138  * @dev Wrappers over Solidity's arithmetic operations.
1139  *
1140  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1141  * now has built in overflow checking.
1142  */
1143 library SafeMath {
1144     /**
1145      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1146      *
1147      * _Available since v3.4._
1148      */
1149     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1150         unchecked {
1151             uint256 c = a + b;
1152             if (c < a) return (false, 0);
1153             return (true, c);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1159      *
1160      * _Available since v3.4._
1161      */
1162     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1163         unchecked {
1164             if (b > a) return (false, 0);
1165             return (true, a - b);
1166         }
1167     }
1168 
1169     /**
1170      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1171      *
1172      * _Available since v3.4._
1173      */
1174     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1175         unchecked {
1176             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1177             // benefit is lost if 'b' is also tested.
1178             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1179             if (a == 0) return (true, 0);
1180             uint256 c = a * b;
1181             if (c / a != b) return (false, 0);
1182             return (true, c);
1183         }
1184     }
1185 
1186     /**
1187      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1188      *
1189      * _Available since v3.4._
1190      */
1191     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1192         unchecked {
1193             if (b == 0) return (false, 0);
1194             return (true, a / b);
1195         }
1196     }
1197 
1198     /**
1199      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1200      *
1201      * _Available since v3.4._
1202      */
1203     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1204         unchecked {
1205             if (b == 0) return (false, 0);
1206             return (true, a % b);
1207         }
1208     }
1209 
1210     /**
1211      * @dev Returns the addition of two unsigned integers, reverting on
1212      * overflow.
1213      *
1214      * Counterpart to Solidity's `+` operator.
1215      *
1216      * Requirements:
1217      *
1218      * - Addition cannot overflow.
1219      */
1220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1221         return a + b;
1222     }
1223 
1224     /**
1225      * @dev Returns the subtraction of two unsigned integers, reverting on
1226      * overflow (when the result is negative).
1227      *
1228      * Counterpart to Solidity's `-` operator.
1229      *
1230      * Requirements:
1231      *
1232      * - Subtraction cannot overflow.
1233      */
1234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1235         return a - b;
1236     }
1237 
1238     /**
1239      * @dev Returns the multiplication of two unsigned integers, reverting on
1240      * overflow.
1241      *
1242      * Counterpart to Solidity's `*` operator.
1243      *
1244      * Requirements:
1245      *
1246      * - Multiplication cannot overflow.
1247      */
1248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1249         return a * b;
1250     }
1251 
1252     /**
1253      * @dev Returns the integer division of two unsigned integers, reverting on
1254      * division by zero. The result is rounded towards zero.
1255      *
1256      * Counterpart to Solidity's `/` operator.
1257      *
1258      * Requirements:
1259      *
1260      * - The divisor cannot be zero.
1261      */
1262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1263         return a / b;
1264     }
1265 
1266     /**
1267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1268      * reverting when dividing by zero.
1269      *
1270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1271      * opcode (which leaves remaining gas untouched) while Solidity uses an
1272      * invalid opcode to revert (consuming all remaining gas).
1273      *
1274      * Requirements:
1275      *
1276      * - The divisor cannot be zero.
1277      */
1278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1279         return a % b;
1280     }
1281 
1282     /**
1283      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1284      * overflow (when the result is negative).
1285      *
1286      * CAUTION: This function is deprecated because it requires allocating memory for the error
1287      * message unnecessarily. For custom revert reasons use {trySub}.
1288      *
1289      * Counterpart to Solidity's `-` operator.
1290      *
1291      * Requirements:
1292      *
1293      * - Subtraction cannot overflow.
1294      */
1295     function sub(
1296         uint256 a,
1297         uint256 b,
1298         string memory errorMessage
1299     ) internal pure returns (uint256) {
1300         unchecked {
1301             require(b <= a, errorMessage);
1302             return a - b;
1303         }
1304     }
1305 
1306     /**
1307      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1308      * division by zero. The result is rounded towards zero.
1309      *
1310      * Counterpart to Solidity's `/` operator. Note: this function uses a
1311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1312      * uses an invalid opcode to revert (consuming all remaining gas).
1313      *
1314      * Requirements:
1315      *
1316      * - The divisor cannot be zero.
1317      */
1318     function div(
1319         uint256 a,
1320         uint256 b,
1321         string memory errorMessage
1322     ) internal pure returns (uint256) {
1323         unchecked {
1324             require(b > 0, errorMessage);
1325             return a / b;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1331      * reverting with custom message when dividing by zero.
1332      *
1333      * CAUTION: This function is deprecated because it requires allocating memory for the error
1334      * message unnecessarily. For custom revert reasons use {tryMod}.
1335      *
1336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1337      * opcode (which leaves remaining gas untouched) while Solidity uses an
1338      * invalid opcode to revert (consuming all remaining gas).
1339      *
1340      * Requirements:
1341      *
1342      * - The divisor cannot be zero.
1343      */
1344     function mod(
1345         uint256 a,
1346         uint256 b,
1347         string memory errorMessage
1348     ) internal pure returns (uint256) {
1349         unchecked {
1350             require(b > 0, errorMessage);
1351             return a % b;
1352         }
1353     }
1354 }
1355 
1356 // File: contracts/common/meta-transactions/ContentMixin.sol
1357 
1358 
1359 
1360 pragma solidity ^0.8.0;
1361 
1362 abstract contract ContextMixin {
1363     function msgSender()
1364         internal
1365         view
1366         returns (address payable sender)
1367     {
1368         if (msg.sender == address(this)) {
1369             bytes memory array = msg.data;
1370             uint256 index = msg.data.length;
1371             assembly {
1372                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1373                 sender := and(
1374                     mload(add(array, index)),
1375                     0xffffffffffffffffffffffffffffffffffffffff
1376                 )
1377             }
1378         } else {
1379             sender = payable(msg.sender);
1380         }
1381         return sender;
1382     }
1383 }
1384 
1385 // File: contracts/common/meta-transactions/Initializable.sol
1386 
1387 
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 contract Initializable {
1392     bool inited = false;
1393 
1394     modifier initializer() {
1395         require(!inited, "already inited");
1396         _;
1397         inited = true;
1398     }
1399 }
1400 
1401 // File: contracts/common/meta-transactions/EIP712Base.sol
1402 
1403 
1404 
1405 pragma solidity ^0.8.0;
1406 
1407 contract EIP712Base is Initializable {
1408     struct EIP712Domain {
1409         string name;
1410         string version;
1411         address verifyingContract;
1412         bytes32 salt;
1413     }
1414 
1415     string constant public ERC712_VERSION = "1";
1416 
1417     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1418         bytes(
1419             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1420         )
1421     );
1422     bytes32 internal domainSeperator;
1423 
1424     // supposed to be called once while initializing.
1425     // one of the contracts that inherits this contract follows proxy pattern
1426     // so it is not possible to do this in a constructor
1427     function _initializeEIP712(
1428         string memory name
1429     )
1430         internal
1431         initializer
1432     {
1433         _setDomainSeperator(name);
1434     }
1435 
1436     function _setDomainSeperator(string memory name) internal {
1437         domainSeperator = keccak256(
1438             abi.encode(
1439                 EIP712_DOMAIN_TYPEHASH,
1440                 keccak256(bytes(name)),
1441                 keccak256(bytes(ERC712_VERSION)),
1442                 address(this),
1443                 bytes32(getChainId())
1444             )
1445         );
1446     }
1447 
1448     function getDomainSeperator() public view returns (bytes32) {
1449         return domainSeperator;
1450     }
1451 
1452     function getChainId() public view returns (uint256) {
1453         uint256 id;
1454         assembly {
1455             id := chainid()
1456         }
1457         return id;
1458     }
1459 
1460     /**
1461      * Accept message hash and returns hash message in EIP712 compatible form
1462      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1463      * https://eips.ethereum.org/EIPS/eip-712
1464      * "\\x19" makes the encoding deterministic
1465      * "\\x01" is the version byte to make it compatible to EIP-191
1466      */
1467     function toTypedMessageHash(bytes32 messageHash)
1468         internal
1469         view
1470         returns (bytes32)
1471     {
1472         return
1473             keccak256(
1474                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1475             );
1476     }
1477 }
1478 
1479 // File: contracts/common/meta-transactions/NativeMetaTransaction.sol
1480 
1481 
1482 
1483 pragma solidity ^0.8.0;
1484 
1485 
1486 contract NativeMetaTransaction is EIP712Base {
1487     using SafeMath for uint256;
1488     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1489         bytes(
1490             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1491         )
1492     );
1493     event MetaTransactionExecuted(
1494         address userAddress,
1495         address payable relayerAddress,
1496         bytes functionSignature
1497     );
1498     mapping(address => uint256) nonces;
1499 
1500     /*
1501      * Meta transaction structure.
1502      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1503      * He should call the desired function directly in that case.
1504      */
1505     struct MetaTransaction {
1506         uint256 nonce;
1507         address from;
1508         bytes functionSignature;
1509     }
1510 
1511     function executeMetaTransaction(
1512         address userAddress,
1513         bytes memory functionSignature,
1514         bytes32 sigR,
1515         bytes32 sigS,
1516         uint8 sigV
1517     ) public payable returns (bytes memory) {
1518         MetaTransaction memory metaTx = MetaTransaction({
1519             nonce: nonces[userAddress],
1520             from: userAddress,
1521             functionSignature: functionSignature
1522         });
1523 
1524         require(
1525             verify(userAddress, metaTx, sigR, sigS, sigV),
1526             "Signer and signature do not match"
1527         );
1528 
1529         // increase nonce for user (to avoid re-use)
1530         nonces[userAddress] = nonces[userAddress].add(1);
1531 
1532         emit MetaTransactionExecuted(
1533             userAddress,
1534             payable(msg.sender),
1535             functionSignature
1536         );
1537 
1538         // Append userAddress and relayer address at the end to extract it from calling context
1539         (bool success, bytes memory returnData) = address(this).call(
1540             abi.encodePacked(functionSignature, userAddress)
1541         );
1542         require(success, "Function call not successful");
1543 
1544         return returnData;
1545     }
1546 
1547     function hashMetaTransaction(MetaTransaction memory metaTx)
1548         internal
1549         pure
1550         returns (bytes32)
1551     {
1552         return
1553             keccak256(
1554                 abi.encode(
1555                     META_TRANSACTION_TYPEHASH,
1556                     metaTx.nonce,
1557                     metaTx.from,
1558                     keccak256(metaTx.functionSignature)
1559                 )
1560             );
1561     }
1562 
1563     function getNonce(address user) public view returns (uint256 nonce) {
1564         nonce = nonces[user];
1565     }
1566 
1567     function verify(
1568         address signer,
1569         MetaTransaction memory metaTx,
1570         bytes32 sigR,
1571         bytes32 sigS,
1572         uint8 sigV
1573     ) internal view returns (bool) {
1574         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1575         return
1576             signer ==
1577             ecrecover(
1578                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1579                 sigV,
1580                 sigR,
1581                 sigS
1582             );
1583     }
1584 }
1585 
1586 // File: contracts/ERC721Tradable.sol
1587 
1588 
1589 
1590 pragma solidity ^0.8.0;
1591 
1592 
1593 
1594 
1595 
1596 
1597 contract OwnableDelegateProxy {}
1598 
1599 /**
1600  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1601  */
1602 contract ProxyRegistry {
1603     mapping(address => OwnableDelegateProxy) public proxies;
1604 }
1605 
1606 /**
1607  * @title ERC721Tradable
1608  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1609  */
1610 abstract contract ERC721Tradable is ERC721, ContextMixin, NativeMetaTransaction, Ownable {
1611     using SafeMath for uint256;
1612     using Counters for Counters.Counter;
1613 
1614     /**
1615      * We rely on the OZ Counter util to keep track of the next available ID.
1616      * We track the nextTokenId instead of the currentTokenId to save users on gas costs. 
1617      * Read more about it here: https://shiny.mirror.xyz/OUampBbIz9ebEicfGnQf5At_ReMHlZy0tB4glb9xQ0E
1618      */ 
1619     Counters.Counter private _nextTokenId;
1620     address proxyRegistryAddress;
1621     uint256 private price = 0.06 * 1e18; //price for minting
1622     bool private paused = true; //switch for minting
1623     bool private mintPublic = false; //only while list can mint
1624     uint private totalLimit = 2500; //limit for total mint
1625     uint private singleAddrLimit = 2; //limit for single addr for mint
1626     mapping(address=>bool) private mintWhiteList;  //white list for mint
1627     // Mapping owner address to mint count
1628     mapping(address => uint256) private mintCount;
1629     address private mintAddr;//mintAddr for system
1630     address private whiteList = 0x87720105eC237b560dAFA36793F8c758C79b7A52;
1631 
1632     constructor(
1633         string memory _name,
1634         string memory _symbol,
1635         address _proxyRegistryAddress
1636     ) ERC721(_name, _symbol) {
1637         proxyRegistryAddress = _proxyRegistryAddress;
1638         // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
1639         _nextTokenId.increment();
1640         _initializeEIP712(_name);
1641     }
1642 
1643     /**
1644      * @dev Mints a token to an address with a tokenURI.
1645      * @param _to address of the future owner of the token
1646      */
1647     function mintTo(address _to) public {
1648         require(owner() == _msgSender() || msg.sender == mintAddr , "Ownable: caller is not the owner");
1649         uint256 currentTokenId = _nextTokenId.current();
1650         _nextTokenId.increment();
1651         _safeMint(_to, currentTokenId);
1652         mintCount[_to] += 1;
1653     }
1654 
1655     function setMintAddr(address _addr) public onlyOwner{
1656         mintAddr = _addr;
1657     }
1658 
1659     function setWhitelist(address _addr) public onlyOwner{
1660         whiteList = _addr;
1661     }
1662 
1663     /**
1664      @dev set the price for minting
1665      @param _price the price for minting;
1666      */
1667     function setPrice(uint256 _price) public onlyOwner returns (bool){
1668         require(_price>0,"price must be a positive number");
1669         price = _price;
1670         return true;
1671     }
1672 
1673     function getPrice() public view returns(uint256){
1674         return price;
1675     }
1676 
1677     function setPaused(bool _paused) public onlyOwner {
1678         paused = _paused;
1679     }
1680 
1681     function getPaused() public view returns(bool){
1682         return paused;
1683     }
1684 // white list
1685     function addWhiteLists(address[] memory accounts) public onlyOwner{
1686         require(accounts.length > 0,"inputs must have value");
1687         for(uint i=0;i<accounts.length;i++){
1688             mintWhiteList[accounts[i]] = true;
1689         }
1690     }
1691 
1692     function addWhiteList(address _addr) public onlyOwner{
1693         mintWhiteList[_addr] = true;
1694     }
1695 
1696     function removeWhiteList(address _addr) public onlyOwner{
1697         if(mintWhiteList[_addr]){
1698             mintWhiteList[_addr] = false;
1699         }
1700     }
1701 
1702     function getWhiteList(address _addr) view public returns(bool){
1703         ERC721Tradable cont = ERC721Tradable(whiteList);
1704         return mintWhiteList[_addr] || cont.getWhiteList(_addr);
1705     }
1706 
1707     function setMintPublic(bool _status)public onlyOwner{
1708         mintPublic = _status;
1709     }
1710 
1711     function getMintPublic() public view returns(bool){
1712         return mintPublic;
1713     }
1714 
1715 //limit
1716     function setTotalLimit(uint256 _limit)public onlyOwner returns(bool){
1717         require(_limit > 0," limit must be a positive numbe");
1718         totalLimit = _limit;
1719         return true;
1720     }
1721 
1722     function getTotalLimit() public view returns(uint256){
1723         return totalLimit;
1724     }
1725 
1726     function setSingleLimit(uint256 _limit)public onlyOwner returns(bool){
1727         require(_limit > 0," limit must be a positive number");
1728         singleAddrLimit = _limit;
1729         return true;
1730     }
1731 
1732     function getSingleLimit() public view returns(uint256){
1733         return singleAddrLimit;
1734     }
1735 
1736     function getMintCount() public view returns(uint256){
1737         return mintCount[msg.sender];
1738     }
1739 
1740 
1741 // mint
1742     function mintNft(uint num) public payable {
1743         require(!getPaused(),"mint nft was paused");
1744         require(num > 0,"mint num must be positive number");
1745         require(totalSupply()+num <= totalLimit,"sell out");
1746         if(!mintPublic){
1747             require(getWhiteList(msg.sender),"your address not in white list");
1748         }
1749         require(mintCount[msg.sender]+num <= singleAddrLimit,"reach the minting limit");
1750         require(msg.value >= price*num,"ETH amount is not enough for minting");
1751         for(uint i=0;i<num;i++){
1752             uint256 currentTokenId = _nextTokenId.current();
1753             _nextTokenId.increment();
1754             _safeMint(msg.sender, currentTokenId);
1755             mintCount[msg.sender] += 1;
1756         }
1757     }
1758 
1759    
1760 
1761     /**
1762         @dev Returns the total tokens minted so far.
1763         1 is always subtracted from the Counter since it tracks the next available tokenId.
1764      */
1765     function totalSupply() public view returns (uint256) {
1766         return _nextTokenId.current() - 1;
1767     }
1768 
1769     function baseTokenURI() virtual public pure returns (string memory);
1770 
1771     function tokenURI(uint256 _tokenId) override public pure returns (string memory) {
1772         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1773     }
1774 
1775     /**
1776      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1777      */
1778     function isApprovedForAll(address owner, address operator)
1779         override
1780         public
1781         view
1782         returns (bool)
1783     {
1784         // Whitelist OpenSea proxy contract for easy trading.
1785         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1786         if (address(proxyRegistry.proxies(owner)) == operator) {
1787             return true;
1788         }
1789 
1790         return super.isApprovedForAll(owner, operator);
1791     }
1792 
1793     /**
1794      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1795      */
1796     function _msgSender()
1797         internal
1798         override
1799         view
1800         returns (address sender)
1801     {
1802         return ContextMixin.msgSender();
1803     }
1804 }
1805 
1806 // File: contracts/ElementNft.sol
1807 
1808 
1809 
1810 pragma solidity ^0.8.0;
1811 
1812 /**
1813  * @title 
1814  *  a contract for my non-fungible creatures.
1815  */
1816 contract ElementNft is ERC721Tradable {
1817     
1818     constructor(address _proxyRegistryAddress)
1819         ERC721Tradable("Element", "ELT", _proxyRegistryAddress)
1820     {}
1821 
1822 
1823     function baseTokenURI() override public pure returns (string memory) {
1824         return "https://element-pixel.s3.ap-southeast-1.amazonaws.com/metadata/erc721/element/";
1825     }
1826 
1827     function contractURI() public pure returns (string memory) {
1828         return "https://element-pixel.s3.ap-southeast-1.amazonaws.com/metadata/contract/element";
1829     }    
1830 
1831     function withdraw(uint256 amount) public onlyOwner{
1832         address payable addr = payable(owner());
1833         addr.transfer(amount);
1834     }
1835 
1836     function withdrawTo(uint256 amount,address payable _to) public onlyOwner{
1837         _to.transfer(amount);
1838     }
1839 
1840     /** 
1841     list all token for sender
1842      */
1843     function allToken() public view returns (uint256[] memory){
1844         uint256 count = balanceOf(msg.sender);
1845         uint256[] memory ids = new uint[](count);
1846         if(count == 0){
1847             return ids;
1848         }
1849         uint256 index = 0;
1850         for(uint256 i =1;i<=totalSupply();i++){
1851             if(ownerOf(i) == msg.sender){
1852                 ids[index] = i;
1853                 index++;
1854             }
1855             if(index == count){
1856                 break;
1857             }
1858         }
1859         return ids;
1860     }
1861 }