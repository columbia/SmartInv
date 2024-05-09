1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @title ERC721 token receiver interface
176  * @dev Interface for any contract that wants to support safeTransfers
177  * from ERC721 asset contracts.
178  */
179 interface IERC721Receiver {
180     /**
181      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
182      * by `operator` from `from`, this function is called.
183      *
184      * It must return its Solidity selector to confirm the token transfer.
185      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
186      *
187      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
188      */
189     function onERC721Received(
190         address operator,
191         address from,
192         uint256 tokenId,
193         bytes calldata data
194     ) external returns (bytes4);
195 }
196 
197 
198 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
205  * @dev See https://eips.ethereum.org/EIPS/eip-721
206  */
207 interface IERC721Metadata is IERC721 {
208     /**
209      * @dev Returns the token collection name.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the token collection symbol.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
220      */
221     function tokenURI(uint256 tokenId) external view returns (string memory);
222 }
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 
230 /**
231  * @dev Implementation of the {IERC165} interface.
232  *
233  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
234  * for the additional interface id that will be supported. For example:
235  *
236  * ```solidity
237  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
238  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
239  * }
240  * ```
241  *
242  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
243  */
244 abstract contract ERC165 is IERC165 {
245     /**
246      * @dev See {IERC165-supportsInterface}.
247      */
248     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
249         return interfaceId == type(IERC165).interfaceId;
250     }
251 }
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies on extcodesize, which returns 0 for contracts in
281         // construction, since the code is only stored at the end of the
282         // constructor execution.
283 
284         uint256 size;
285         assembly {
286             size := extcodesize(account)
287         }
288         return size > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         (bool success, ) = recipient.call{value: amount}("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain `call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         require(isContract(target), "Address: call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.call{value: value}(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(isContract(target), "Address: delegate call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.delegatecall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             // Look for revert reason and bubble it up if present
457             if (returndata.length > 0) {
458                 // The easiest way to bubble the revert reason is using memory via assembly
459 
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @dev Provides information about the current execution context, including the
478  * sender of the transaction and its data. While these are generally available
479  * via msg.sender and msg.data, they should not be accessed in such a direct
480  * manner, since when dealing with meta-transactions the account sending and
481  * paying for execution may not be the actual sender (as far as an application
482  * is concerned).
483  *
484  * This contract is only required for intermediate, library-like contracts.
485  */
486 abstract contract Context {
487     function _msgSender() internal view virtual returns (address) {
488         return msg.sender;
489     }
490 
491     function _msgData() internal view virtual returns (bytes calldata) {
492         return msg.data;
493     }
494 }
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev String operations.
503  */
504 library Strings {
505     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
509      */
510     function toString(uint256 value) internal pure returns (string memory) {
511         // Inspired by OraclizeAPI's implementation - MIT licence
512         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
513 
514         if (value == 0) {
515             return "0";
516         }
517         uint256 temp = value;
518         uint256 digits;
519         while (temp != 0) {
520             digits++;
521             temp /= 10;
522         }
523         bytes memory buffer = new bytes(digits);
524         while (value != 0) {
525             digits -= 1;
526             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
527             value /= 10;
528         }
529         return string(buffer);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
534      */
535     function toHexString(uint256 value) internal pure returns (string memory) {
536         if (value == 0) {
537             return "0x00";
538         }
539         uint256 temp = value;
540         uint256 length = 0;
541         while (temp != 0) {
542             length++;
543             temp >>= 8;
544         }
545         return toHexString(value, length);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
552         bytes memory buffer = new bytes(2 * length + 2);
553         buffer[0] = "0";
554         buffer[1] = "x";
555         for (uint256 i = 2 * length + 1; i > 1; --i) {
556             buffer[i] = _HEX_SYMBOLS[value & 0xf];
557             value >>= 4;
558         }
559         require(value == 0, "Strings: hex length insufficient");
560         return string(buffer);
561     }
562 }
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
572  * the Metadata extension, but not including the Enumerable extension, which is available separately as
573  * {ERC721Enumerable}.
574  */
575 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
576     using Address for address;
577     using Strings for uint256;
578 
579     // Token name
580     string private _name;
581 
582     // Token symbol
583     string private _symbol;
584 
585     // Mapping from token ID to owner address
586     mapping(uint256 => address) private _owners;
587 
588     // Mapping owner address to token count
589     mapping(address => uint256) private _balances;
590 
591     // Mapping from token ID to approved address
592     mapping(uint256 => address) private _tokenApprovals;
593 
594     // Mapping from owner to operator approvals
595     mapping(address => mapping(address => bool)) private _operatorApprovals;
596 
597     /**
598      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
599      */
600     constructor(string memory name_, string memory symbol_) {
601         _name = name_;
602         _symbol = symbol_;
603     }
604 
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
609         return
610             interfaceId == type(IERC721).interfaceId ||
611             interfaceId == type(IERC721Metadata).interfaceId ||
612             super.supportsInterface(interfaceId);
613     }
614 
615     /**
616      * @dev See {IERC721-balanceOf}.
617      */
618     function balanceOf(address owner) public view virtual override returns (uint256) {
619         require(owner != address(0), "ERC721: balance query for the zero address");
620         return _balances[owner];
621     }
622 
623     /**
624      * @dev See {IERC721-ownerOf}.
625      */
626     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
627         address owner = _owners[tokenId];
628         require(owner != address(0), "ERC721: owner query for nonexistent token");
629         return owner;
630     }
631 
632     /**
633      * @dev See {IERC721Metadata-name}.
634      */
635     function name() public view virtual override returns (string memory) {
636         return _name;
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-symbol}.
641      */
642     function symbol() public view virtual override returns (string memory) {
643         return _symbol;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-tokenURI}.
648      */
649     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
650         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
651 
652         string memory baseURI = _baseURI();
653         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
654     }
655 
656     /**
657      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
658      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
659      * by default, can be overriden in child contracts.
660      */
661     function _baseURI() internal view virtual returns (string memory) {
662         return "";
663     }
664 
665     /**
666      * @dev See {IERC721-approve}.
667      */
668     function approve(address to, uint256 tokenId) public virtual override {
669         address owner = ERC721.ownerOf(tokenId);
670         require(to != owner, "ERC721: approval to current owner");
671 
672         require(
673             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
674             "ERC721: approve caller is not owner nor approved for all"
675         );
676 
677         _approve(to, tokenId);
678     }
679 
680     /**
681      * @dev See {IERC721-getApproved}.
682      */
683     function getApproved(uint256 tokenId) public view virtual override returns (address) {
684         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
685 
686         return _tokenApprovals[tokenId];
687     }
688 
689     /**
690      * @dev See {IERC721-setApprovalForAll}.
691      */
692     function setApprovalForAll(address operator, bool approved) public virtual override {
693         _setApprovalForAll(_msgSender(), operator, approved);
694     }
695 
696     /**
697      * @dev See {IERC721-isApprovedForAll}.
698      */
699     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
700         return _operatorApprovals[owner][operator];
701     }
702 
703     /**
704      * @dev See {IERC721-transferFrom}.
705      */
706     function transferFrom(
707         address from,
708         address to,
709         uint256 tokenId
710     ) public virtual override {
711         //solhint-disable-next-line max-line-length
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
713 
714         _transfer(from, to, tokenId);
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         safeTransferFrom(from, to, tokenId, "");
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) public virtual override {
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738         _safeTransfer(from, to, tokenId, _data);
739     }
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
743      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
744      *
745      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
746      *
747      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
748      * implement alternative mechanisms to perform token transfer, such as signature-based.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must exist and be owned by `from`.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _safeTransfer(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) internal virtual {
765         _transfer(from, to, tokenId);
766         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      * and stop existing when they are burned (`_burn`).
776      */
777     function _exists(uint256 tokenId) internal view virtual returns (bool) {
778         return _owners[tokenId] != address(0);
779     }
780 
781     /**
782      * @dev Returns whether `spender` is allowed to manage `tokenId`.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must exist.
787      */
788     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
789         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
790         address owner = ERC721.ownerOf(tokenId);
791         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
792     }
793 
794     /**
795      * @dev Safely mints `tokenId` and transfers it to `to`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must not exist.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _safeMint(address to, uint256 tokenId) internal virtual {
805         _safeMint(to, tokenId, "");
806     }
807 
808     /**
809      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
810      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
811      */
812     function _safeMint(
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) internal virtual {
817         _mint(to, tokenId);
818         require(
819             _checkOnERC721Received(address(0), to, tokenId, _data),
820             "ERC721: transfer to non ERC721Receiver implementer"
821         );
822     }
823 
824     /**
825      * @dev Mints `tokenId` and transfers it to `to`.
826      *
827      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
828      *
829      * Requirements:
830      *
831      * - `tokenId` must not exist.
832      * - `to` cannot be the zero address.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _mint(address to, uint256 tokenId) internal virtual {
837         require(to != address(0), "ERC721: mint to the zero address");
838         require(!_exists(tokenId), "ERC721: token already minted");
839 
840         _beforeTokenTransfer(address(0), to, tokenId);
841 
842         _balances[to] += 1;
843         _owners[tokenId] = to;
844 
845         emit Transfer(address(0), to, tokenId);
846     }
847 
848     /**
849      * @dev Destroys `tokenId`.
850      * The approval is cleared when the token is burned.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _burn(uint256 tokenId) internal virtual {
859         address owner = ERC721.ownerOf(tokenId);
860 
861         _beforeTokenTransfer(owner, address(0), tokenId);
862 
863         // Clear approvals
864         _approve(address(0), tokenId);
865 
866         _balances[owner] -= 1;
867         delete _owners[tokenId];
868 
869         emit Transfer(owner, address(0), tokenId);
870     }
871 
872     /**
873      * @dev Transfers `tokenId` from `from` to `to`.
874      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must be owned by `from`.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _transfer(
884         address from,
885         address to,
886         uint256 tokenId
887     ) internal virtual {
888         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
889         require(to != address(0), "ERC721: transfer to the zero address");
890 
891         _beforeTokenTransfer(from, to, tokenId);
892 
893         // Clear approvals from the previous owner
894         _approve(address(0), tokenId);
895 
896         _balances[from] -= 1;
897         _balances[to] += 1;
898         _owners[tokenId] = to;
899 
900         emit Transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev Approve `to` to operate on `tokenId`
905      *
906      * Emits a {Approval} event.
907      */
908     function _approve(address to, uint256 tokenId) internal virtual {
909         _tokenApprovals[tokenId] = to;
910         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
911     }
912 
913     /**
914      * @dev Approve `operator` to operate on all of `owner` tokens
915      *
916      * Emits a {ApprovalForAll} event.
917      */
918     function _setApprovalForAll(
919         address owner,
920         address operator,
921         bool approved
922     ) internal virtual {
923         require(owner != operator, "ERC721: approve to caller");
924         _operatorApprovals[owner][operator] = approved;
925         emit ApprovalForAll(owner, operator, approved);
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
983 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
984 
985 pragma solidity ^0.8.0;
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
1010 
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1017  * enumerability of all the token ids in the contract as well as all token ids owned by each
1018  * account.
1019  */
1020 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1021     // Mapping from owner to list of owned token IDs
1022     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1023 
1024     // Mapping from token ID to index of the owner tokens list
1025     mapping(uint256 => uint256) private _ownedTokensIndex;
1026 
1027     // Array with all token ids, used for enumeration
1028     uint256[] private _allTokens;
1029 
1030     // Mapping from token id to position in the allTokens array
1031     mapping(uint256 => uint256) private _allTokensIndex;
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1037         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1045         return _ownedTokens[owner][index];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-totalSupply}.
1050      */
1051     function totalSupply() public view virtual override returns (uint256) {
1052         return _allTokens.length;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenByIndex}.
1057      */
1058     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1060         return _allTokens[index];
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual override {
1083         super._beforeTokenTransfer(from, to, tokenId);
1084 
1085         if (from == address(0)) {
1086             _addTokenToAllTokensEnumeration(tokenId);
1087         } else if (from != to) {
1088             _removeTokenFromOwnerEnumeration(from, tokenId);
1089         }
1090         if (to == address(0)) {
1091             _removeTokenFromAllTokensEnumeration(tokenId);
1092         } else if (to != from) {
1093             _addTokenToOwnerEnumeration(to, tokenId);
1094         }
1095     }
1096 
1097     /**
1098      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1099      * @param to address representing the new owner of the given token ID
1100      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1101      */
1102     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1103         uint256 length = ERC721.balanceOf(to);
1104         _ownedTokens[to][length] = tokenId;
1105         _ownedTokensIndex[tokenId] = length;
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's token tracking data structures.
1110      * @param tokenId uint256 ID of the token to be added to the tokens list
1111      */
1112     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1113         _allTokensIndex[tokenId] = _allTokens.length;
1114         _allTokens.push(tokenId);
1115     }
1116 
1117     /**
1118      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1119      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1120      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1121      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1122      * @param from address representing the previous owner of the given token ID
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1124      */
1125     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1126         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1130         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary
1133         if (tokenIndex != lastTokenIndex) {
1134             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1135 
1136             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1137             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1138         }
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _ownedTokensIndex[tokenId];
1142         delete _ownedTokens[from][lastTokenIndex];
1143     }
1144 
1145     /**
1146      * @dev Private function to remove a token from this extension's token tracking data structures.
1147      * This has O(1) time complexity, but alters the order of the _allTokens array.
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list
1149      */
1150     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1151         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = _allTokens.length - 1;
1155         uint256 tokenIndex = _allTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1158         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1159         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1160         uint256 lastTokenId = _allTokens[lastTokenIndex];
1161 
1162         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1163         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _allTokensIndex[tokenId];
1167         _allTokens.pop();
1168     }
1169 }
1170 
1171 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 
1176 /**
1177  * @dev Contract module which provides a basic access control mechanism, where
1178  * there is an account (an owner) that can be granted exclusive access to
1179  * specific functions.
1180  *
1181  * By default, the owner account will be the one that deploys the contract. This
1182  * can later be changed with {transferOwnership}.
1183  *
1184  * This module is used through inheritance. It will make available the modifier
1185  * `onlyOwner`, which can be applied to your functions to restrict their use to
1186  * the owner.
1187  */
1188 abstract contract Ownable is Context {
1189     address private _owner;
1190 
1191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1192 
1193     /**
1194      * @dev Initializes the contract setting the deployer as the initial owner.
1195      */
1196     constructor() {
1197         _transferOwnership(_msgSender());
1198     }
1199 
1200     /**
1201      * @dev Returns the address of the current owner.
1202      */
1203     function owner() public view virtual returns (address) {
1204         return _owner;
1205     }
1206 
1207     /**
1208      * @dev Throws if called by any account other than the owner.
1209      */
1210     modifier onlyOwner() {
1211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1212         _;
1213     }
1214 
1215     /**
1216      * @dev Leaves the contract without owner. It will not be possible to call
1217      * `onlyOwner` functions anymore. Can only be called by the current owner.
1218      *
1219      * NOTE: Renouncing ownership will leave the contract without an owner,
1220      * thereby removing any functionality that is only available to the owner.
1221      */
1222     function renounceOwnership() public virtual onlyOwner {
1223         _transferOwnership(address(0));
1224     }
1225 
1226     /**
1227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1228      * Can only be called by the current owner.
1229      */
1230     function transferOwnership(address newOwner) public virtual onlyOwner {
1231         require(newOwner != address(0), "Ownable: new owner is the zero address");
1232         _transferOwnership(newOwner);
1233     }
1234 
1235     /**
1236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1237      * Internal function without access restriction.
1238      */
1239     function _transferOwnership(address newOwner) internal virtual {
1240         address oldOwner = _owner;
1241         _owner = newOwner;
1242         emit OwnershipTransferred(oldOwner, newOwner);
1243     }
1244 }
1245 
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 
1250 contract MutantApeWives is ERC721Enumerable, Ownable {
1251 
1252     uint256 public apePrice = 40000000000000000;
1253     uint public constant maxApePurchase = 10;
1254     uint public ApeSup = 10000;
1255     bool public drop_is_active = false;
1256     bool public presale_is_active = false;
1257     string public baseURI = "";
1258     uint256 public tokensMinted = 0;
1259 
1260     struct Whitelistaddr {
1261         uint256 presalemints;
1262         bool exists;
1263     }
1264     mapping(address => Whitelistaddr) private whitelist;
1265 
1266     constructor() ERC721("MutantApeWives", "MAW"){
1267     whitelist[0x1Fa0c42a65B51ABdd384C1bba97992CA478DF4e7].exists = true;
1268     whitelist[0x03EED5383cd57b8155De4A67fEdB906dC3C9eB6D].exists = true;
1269     whitelist[0x4d9f62922A828939eF6CE5E50FaF4A7B5360b943].exists = true;
1270     whitelist[0x1CccFDBaD92675f7212cb264e4FdCbd8699a81dE].exists = true;
1271     whitelist[0xA01C0735C7cA5f8efc1e63efa5F2D1C4fc1a4714].exists = true;
1272     whitelist[0x5ed39Ed5C210bdB9e67385478323E6113C33b1F0].exists = true;
1273     whitelist[0xA4Adc8AbE09cf3c06f353576c2E9886eef815ebE].exists = true;
1274     whitelist[0x921D53Af7CC5aE8fc65B6CB390762F9Abc82b8EA].exists = true;
1275     whitelist[0xaD31dFbF78BdC8E90c7DeF2a97ECbE917C53E7e3].exists = true;
1276     whitelist[0x8d256C3dEEDCF219764425Daf6c1e47244c6839b].exists = true;
1277     whitelist[0x98c68168474c7EfE22828EaB331Ce98655a8ecc9].exists = true;
1278     whitelist[0x64B1dF8EbeA8a1039217B9A7fAAed386d856e7c2].exists = true;
1279     whitelist[0x511DbcBa0c78cb4E35f1Fc2b14b1FCdDf133c2dd].exists = true;
1280     whitelist[0x036863A5A05c5A7EbD2553824Cb040aAa2a6D687].exists = true;
1281     whitelist[0x2fa03dcc825f2a09705904bc8f6E51662e9c9448].exists = true;
1282     whitelist[0xca4BF72AE1b9C050729931e715Bd6653df951848].exists = true;
1283     whitelist[0x9f8c7c5BaC70342B572Af5B395553eFd978C4425].exists = true;
1284     whitelist[0x90a4D5aD231E9250F53D0b2a0029556798eCcaeD].exists = true;
1285     whitelist[0xc5F62Ed23fb755D2B89c2372bF21eE711E4DB3B4].exists = true;
1286     whitelist[0xd34a6B9Fca0867988CDC602D60724F822F96ffFD].exists = true;
1287     whitelist[0x5fE8a15dbE1863B37F7e15B1B180af7627548738].exists = true;
1288     whitelist[0x21bd72a7e219B836680201c25B61a4AA407F7bfD].exists = true;
1289     whitelist[0x9AE6d4859109c83fab823Ea4dFd42843568D1084].exists = true;
1290     whitelist[0x2014ca876094Bf98F53226C9CD4E811862d07504].exists = true;
1291     whitelist[0xB1059da8327718704086e372320185B970b3FAFD].exists = true;
1292     whitelist[0x5C3086CdEC08849CdC592Eb88F9b8d2F72E3e42f].exists = true;
1293     whitelist[0xe701A35273c57791009a5d0B2de9B9b8c1fCeAEA].exists = true;
1294     whitelist[0x9e14b5E72b6F94b839C148C3A60F78c999DfE9db].exists = true;
1295     whitelist[0xf7A926e197e2A07213B320ad4651C8DF5Bdc6B1a].exists = true;
1296     whitelist[0x115D55FE3f068e05f57D247389c5B93534D685CA].exists = true;
1297     whitelist[0xBF2C089F3e9d23aa7D124c4B4E8371A54300fD5e].exists = true;
1298     whitelist[0x32752703548FbAf0113d4C20ddF08B66Eef1D31A].exists = true;
1299     whitelist[0xc34E1e7ae15410B37Db674955335E8Fd722cb3e6].exists = true;
1300     whitelist[0x428e209dA85f879168fd8e91e6eBFdb809c7EA46].exists = true;
1301     whitelist[0xa47467EfD942daCBf3b0D1d656bC512847e7f4e0].exists = true;
1302     whitelist[0x7B02Cf72c598F569237336F30c283668E8199dd9].exists = true;
1303     whitelist[0x86cb4684b24ff467Df46EF5804B24515E6AdB9C9].exists = true;
1304     whitelist[0x7254bb676d9cB54281028c4083455e85e2904C1b].exists = true;
1305     whitelist[0xED3ea09408bc99B8617Af13CfA2A86Ae4b247c2E].exists = true;
1306     whitelist[0x39794c3171d4D82eB9C6FBb764749Eb7ED92881d].exists = true;
1307     whitelist[0x37002077CacCA7534D89118836662779233e62B1].exists = true;
1308     whitelist[0x033d1a2357307Ae3f8a2D7aC15931f555d37D41d].exists = true;
1309     whitelist[0x483199Cc3318414B2b7Af323Cb981840ae8AB4F9].exists = true;
1310     whitelist[0xeacF6c83C26508F55AD6Bd49746E65C39645223E].exists = true;
1311     whitelist[0x602B93A6ab102907a40cDE6B786cD07B4279E796].exists = true;
1312     whitelist[0x87C9e727aD6DD925A1De7CD949349a855bEbD836].exists = true;
1313     whitelist[0xD57E60947C5AEfB0D80edca6b0B0Bfd31A50b739].exists = true;
1314     whitelist[0x8B0C2928e935b1D2Ac9D5a149829f7103c60b94f].exists = true;
1315     whitelist[0x06C4106E578110ED05c943d97A9a3e561b598DB0].exists = true;
1316     whitelist[0x746b024b8b93D0d447c61B955f8452afdB7682c4].exists = true;
1317     whitelist[0x713b8C9f2713a07a43EDA78B454BEaB9D9E96015].exists = true;
1318     whitelist[0xf543428D35aB7F3a86a7F4F448ec2B32eb0d8b32].exists = true;
1319     whitelist[0x642b286935113276d363dF4Cfd202079233f25d1].exists = true;
1320     whitelist[0xd7B83C30609db3f1F4ad68d9c046703a7d06D722].exists = true;
1321     whitelist[0x6f15Aa54a9370fB5A64291499B77650d5f3882FC].exists = true;
1322     whitelist[0x7443E57a7d4df44FE6819dd76474BA9C3BE3c81D].exists = true;
1323     whitelist[0x03f4Cb9e297ea659F30E09341eE7155a7d136398].exists = true;
1324     whitelist[0x6A61925DcdF27d8b28C11Ec76228b4195A978069].exists = true;
1325     whitelist[0x5078328036E21C42426D9514378d782e489c9844].exists = true;
1326     whitelist[0x2AF37023A1bEf8164781f1B941E8B7d9D2764766].exists = true;
1327     whitelist[0x4DA33Cf3100E5DA72285F1Cc282cf056ce0ADD51].exists = true;
1328     whitelist[0x2a32093A20D9E1D3f0620FbA008c9b2107Aa0D39].exists = true;
1329     whitelist[0x0C289Ec5d7FAC13EcBa85A404f144dfE461F6757].exists = true;
1330     whitelist[0xb5c1bbd13f127Bd1807d6434bB016ec93e6CB107].exists = true;
1331     whitelist[0x9B53f9f5e94fE905a25eB5E14EFa03a86AEf2f08].exists = true;
1332     whitelist[0x42cBD461BADfa828D64bB2684F49289a62248D4a].exists = true;
1333     whitelist[0xb53467e86A7AC44ED8623f01A3772F573d2A1f1d].exists = true;
1334     whitelist[0x7Eca7b2A0b7170DE1Fe3DC8ABb3007d60BE382Fc].exists = true;
1335     whitelist[0xB13a509B8E3Dd88f4a5239c1cC4a749111CCa5a7].exists = true;
1336     whitelist[0xc68810cD92dAC5186d035cC65C388060C1f85373].exists = true;
1337     whitelist[0xf7f058Cd6D8BC862BE2193AE60f9Fe3387fdFa3A].exists = true;
1338     whitelist[0xe2320De5d2ddA68A9479E4271b704284679E49eb].exists = true;
1339     whitelist[0x4a3172c5879ab244d53ed2eEf38dDc1bD8ACaCcb].exists = true;
1340     whitelist[0x35851bBBDF431c2AcF773f0e3FFeaa7279Dc60d7].exists = true;
1341     whitelist[0x2cDAAF054a63C2eaeA23A7A071E39bE872f2f808].exists = true;
1342     whitelist[0xA9DCc7771b949d9917AC2Db34471325D901303cD].exists = true;
1343     whitelist[0x358f0632548968776247C6154c06023a10A9Aa10].exists = true;
1344     whitelist[0x62Ac503e46fCc13317580b8B177f28f2F5270f17].exists = true;
1345     whitelist[0x07cd24C35403E88B647778ccA17B91D2ee02aFF3].exists = true;
1346     whitelist[0x2b762480E5BdF49eBa0e2126bd96685c70112355].exists = true;
1347     whitelist[0xABC2A9349d41ffBe8AFdB7886D70773991ACD833].exists = true;
1348     whitelist[0xb0f380d49a59F929c5481992892F899d390a6110].exists = true;
1349     whitelist[0x40119fD73a4c3c6cAf9DD5B0078f6c13E1133c61].exists = true;
1350     whitelist[0x6F2752bCF04aD3Bd569F8523C146701088dB8b2A].exists = true;
1351     whitelist[0x64aBB85Cc94dE5e0B56B2a1139B7DA70A7cd3b01].exists = true;
1352     whitelist[0xc27BA52C493e291FA50a8e537142dF2140520F0b].exists = true;
1353     whitelist[0x27F4f00A36FAa31A60A60cb56B25F99f9C683e9A].exists = true;
1354     whitelist[0xd6F1c330BF5379f8dC1C3db7f5daA8FB59581E30].exists = true;
1355     whitelist[0xCBcA70E92C68F08350deBB50a85bae486a709cBe].exists = true;
1356     whitelist[0x59Dcd59551848dda2448c71485E6E25238252682].exists = true;
1357     whitelist[0x1F057a18a0F3a0061d8170c303019CfA1D4E70C1].exists = true;
1358     whitelist[0xE289512D2322Ce7Bd468C2d9E1FEe03d0fBC4D43].exists = true;
1359     whitelist[0xf71Fc2ecf07364F3992beaf93168e8D911ac4336].exists = true;
1360     whitelist[0x1a47Ef7e41E3ac6e7f9612F697E69F8D0D9F0249].exists = true;
1361     whitelist[0x870B4947A30939C4D9338fc07C1370CE678C4a65].exists = true;
1362     whitelist[0x28c1Ed3cA6289F8E0C6B68508c1B7Fc00372001E].exists = true;
1363     whitelist[0xB6cd1D08bE8BaB1E702d6528702310239dc9E7D4].exists = true;
1364     whitelist[0x2B6E6bcB6d1a0544ec09A5209Db4f6023F6EbDF5].exists = true;
1365     whitelist[0xaa1edc3769f31Fe780e3Ee6d6C8ec534BA9A7725].exists = true;
1366     whitelist[0x06020f527C640692542D542A4d25Fc104E8F46a5].exists = true;
1367     whitelist[0x120C0daC8A4423a495AF6AB1aD64bc26b2C73986].exists = true;
1368     whitelist[0xAa5Ea948fCBd10132B2659Cd2181AA06a000c74F].exists = true;
1369     whitelist[0xFfE4261a55f4d5AE916D1130Ce4D9132f9Adb262].exists = true;
1370     whitelist[0x6CFbA31B89974acD050d5cAf48Ae92A12Ed160B9].exists = true;
1371     whitelist[0x35ddcaa76104D8009502fFFcfd00fe54210676F6].exists = true;
1372     whitelist[0xaFB2BdeCafeC778923cC9058c9642565B2999A29].exists = true;
1373     whitelist[0x665D43b4b3167D292Fd8D2712Bb7576e9eE31334].exists = true;
1374     whitelist[0xaB3418068Cdcf0cB116E408948c4aA1344519C3a].exists = true;
1375     whitelist[0x14D05798E8FB39Ea2604243fb6C4393DD7f36E14].exists = true;
1376     whitelist[0x4C97361f6D41f1E27daF636114F0Abaa61459167].exists = true;
1377     whitelist[0x259c9B7a6D6bA8CA30B849719a7Ee4CE843E4DDE].exists = true;
1378     whitelist[0x4bc91Bd7126B68CBD18F367E59754b878b72B848].exists = true;
1379     whitelist[0x2DD534dd4949ccDbB301D29b15d8B86111eE4aE1].exists = true;
1380     whitelist[0x8C87b46DC45076F3Cd457790100485Fd94fb4157].exists = true;
1381     whitelist[0x1228a857FD7Ee845f4999f33540F6b9D0988e80d].exists = true;
1382     whitelist[0xe522BfAbDba3E40dFf4187f5219a4E9f267cf504].exists = true;
1383     whitelist[0x49565Ba1f295dD7cfaD35C198f04153B9a0FB6d7].exists = true;
1384     whitelist[0x5444C883AA97d419AC20DCDbD7767F632b1A7669].exists = true;
1385     whitelist[0x7dD580A38454b97022B59EA1747e0Ffe279C508d].exists = true;
1386     whitelist[0x2B1632e4EF7cde52531E84998Df74773cA5216b7].exists = true;
1387     whitelist[0x65e46516353dB530f431Ee0535047c00e7e07E5F].exists = true;
1388     whitelist[0x8D24bCfEFbC93568872490C7A5f49E67819e8242].exists = true;
1389     whitelist[0x492191D35Ee2040E7733e7D18E405314a31abA85].exists = true;
1390     whitelist[0x66883274f20a617E781c3f869c48eD93a041F178].exists = true;
1391     whitelist[0x358Ffb79c76b45A3B9B13EE24Eb05Db85AdB1bB8].exists = true;
1392     whitelist[0xf0323b7dA670B039289A222189AC61389462Cb5A].exists = true;
1393     whitelist[0x162195Ea6e3d170939891Dd3A68a9CA32EcC1ca7].exists = true;
1394     whitelist[0xF328e13C8aB3cA38845724104aCC074Ff4121D74].exists = true;
1395     whitelist[0xbc3C52ECa94Fc1F412443a3d706CF19Fc80FfcB3].exists = true;
1396     whitelist[0x58f3e78f49296D5aD1C7798057A2e34949E95d55].exists = true;
1397     whitelist[0x74205C844f0a6c8510a03e68008B3e5be2d642e4].exists = true;
1398     whitelist[0x579cD9D50cda026B06891D5D482ce1f00D754022].exists = true;
1399     whitelist[0xc785EB6CF887b9d1DC971FcC9A81BF3fE030fD61].exists = true;
1400     whitelist[0xD42a0b819F6171A697501693D234bcE421FEAFEE].exists = true;
1401     whitelist[0x307C13D2820F35802307e943F59d65741256326F].exists = true;
1402     whitelist[0x04f5465dE5E6cE83bFc5a41E3b6450B7A52a361a].exists = true;
1403     whitelist[0xa04aC0F08D81bbfE8a5AFd8368Fa2E8d184fA9b5].exists = true;
1404     whitelist[0x9321D8d72f8BeBCf3D48725643564Eaf75a7a9ef].exists = true;
1405     whitelist[0xdEbD23D4f7706D873Ff766ed025C5854A732A463].exists = true;
1406     whitelist[0xe7c1DB78d86A6Ab2295a2B911559fd754710B64e].exists = true;
1407     whitelist[0x20f76AE93b4217D325b09bA5B99D4062BC6f1090].exists = true;
1408     whitelist[0x9C74F1a06CEa6587029029f3dE875D08757B9960].exists = true;
1409     whitelist[0xA8a437E16Ab784D72362F9ebFdC025f200BE28bF].exists = true;
1410     whitelist[0x69b02E16F3818D6211071E08E19f42944B90D1E7].exists = true;
1411     whitelist[0xDB2e9Af0Ec4Dc504b9409ec78b0FC4D9B30281Fc].exists = true;
1412     whitelist[0x686CB9D88719E85aCA606797743A6cc0F7343d31].exists = true;
1413     whitelist[0x0b6f3D59d4268679c6eba04eaCFAA4Ab4C9352D9].exists = true;
1414     whitelist[0x69F50475f695760C85bb28D7d6ecb9baD4Dd911d].exists = true;
1415     whitelist[0x7B3ea3001cbfB19fe7142757811056680C062114].exists = true;
1416     whitelist[0x5fD21B488987365b2C79aD42e5Ac6c15A1EA9cF0].exists = true;
1417     whitelist[0x196bF546a4944C31856009a87347C735e5d42A9D].exists = true;
1418     whitelist[0x4e1686BEdCF7B4f21B40a032cf6E7aFBbFaD947B].exists = true;
1419     whitelist[0x89f2C064a1e1ee5e37DF0698Fc95F43DAAA2a43A].exists = true;
1420     whitelist[0x84A2345A7fE0aBb8e6726051bf5bEb4A3E47A3Ee].exists = true;
1421     whitelist[0x88d19e08Cd43bba5761c10c588b2A3D85C75041f].exists = true;
1422     whitelist[0x9d4B7D78C81cDB2FB08bb24B3FA3E65f1ac444cA].exists = true;
1423     whitelist[0xaE149e2a083d94B9833102cF4fd6BEFF5409Fb20].exists = true;
1424     whitelist[0x612952a8D811B3Cd5626eBc748d5eB835Fcf724B].exists = true;
1425     whitelist[0x31B19F9183094fB6B87B8F26988865026c6AcF17].exists = true;
1426     whitelist[0x0b4955C7B65c9fdAeCB2e12717092936316f52F3].exists = true;
1427     whitelist[0x6507Db73D6AdE38af8467eB5aB445f224CeDAF38].exists = true;
1428     whitelist[0xB9c2cB57Dfe51F8A2Fb588f333bDC89D8d90ca9B].exists = true;
1429     whitelist[0x8F66c0c359B4546512BC8dca379B89Ac93008d97].exists = true;
1430     whitelist[0xc955Ce75796eF64eB1F09e9eff4481c8968C9346].exists = true;
1431     whitelist[0xA3274031a981003f136b731DF2B78CEE0ceCb160].exists = true;
1432     whitelist[0x466AbBfb9AAb4C6dF6d3Cc03D6C63C43C5162048].exists = true;
1433     whitelist[0x80EF7fB78F7e65928Ba2e60B7a5A9501Cbdcb612].exists = true;
1434     whitelist[0x58269C4fc0ACb2fB612638e75ED0e7113612F20f].exists = true;
1435     whitelist[0x7448E0C5f8e6cB5920bc197B0503e6B1c8cC495f].exists = true;
1436     whitelist[0x409239E29Dc9595D8DE2f8D4B916e2d076C82A73].exists = true;
1437     whitelist[0x82CAb764Df6a044029e34Ce281dF520c7DbeCed6].exists = true;
1438     whitelist[0x3fE167eD835fB3B28a555a5470b355202d27F436].exists = true;
1439     whitelist[0x35471F2cFab7B75e88D0eBfd5528586F55900C4E].exists = true;
1440     whitelist[0xd17579Ecff58C528C4Aa64Db58e8A829B1c111Cd].exists = true;
1441     whitelist[0xA94e497c4d7d59f572e8E27D53916f23635d6acd].exists = true;
1442     whitelist[0x07fC676A307F41dfa7e53b285cF87305B9ab940A].exists = true;
1443     whitelist[0xd8226Dd110c7bA2bcD7A680d9EA5206BaC40F201].exists = true;
1444     whitelist[0xE56B07262a1F52755B63bf32697511F84d46E780].exists = true;
1445     whitelist[0xE5Dd1908626392F5F4160C4d06729F733B1cfA3D].exists = true;
1446     whitelist[0x7f2FD2EAAF73CE2b4897566acA233244a4524BFB].exists = true;
1447     whitelist[0xDc92f758986cc62A1085319D2038445f3FeEF74b].exists = true;
1448     whitelist[0xDdE58fb699EB6f309b5759c9fC7c3aec43EbebE7].exists = true;
1449     whitelist[0xCe239202371B5215aA9155c6600c4D3506bD816A].exists = true;
1450     whitelist[0x1bd06653d474eF3d30E2057242a07A5E976Fb91f].exists = true;
1451     whitelist[0xaDD089EAD1d42bF90181D1c064931c3829438074].exists = true;
1452     whitelist[0xDfE59d4F638E24D413f0Be75417cCeD8Fae5FECb].exists = true;
1453     whitelist[0x0D5a507E4883b1F8a15103C842aA63D9e0F1D108].exists = true;
1454     whitelist[0x5CDB7Ff563c26beA21502d1e28f6566BFdA4a498].exists = true;
1455     whitelist[0xF85f584D4078E16673D3326a92C836E8350c7508].exists = true;
1456     whitelist[0x50c6320567cC830535f026193b57C370A65bDa80].exists = true;
1457     whitelist[0x563b3d92A0eE49C281ee50324bCd659B2bDBA414].exists = true;
1458     whitelist[0xdfDd269285cfc31A47ea35Df69E149e49cFca436].exists = true;
1459     whitelist[0xe03f7703ED4Af3a43Ac3608b46728884f0897f33].exists = true;
1460     whitelist[0x3eC4483CDB2bCcC637EF2C94e8F6EEEB8247823b].exists = true;
1461     whitelist[0xB04791252721BcB1c9B0Af567C985EF72C03b12D].exists = true;
1462     whitelist[0x7296077C84DD5249B2e3ae7fC3d49C86abc38C03].exists = true;
1463     whitelist[0x9cb01386968136745654650a9C806C211Fd61998].exists = true;
1464     whitelist[0x99549Be88376CE2edCBF513964c32243c2Daf3de].exists = true;
1465     whitelist[0x2C14d26e34cED6BA51e9a6c0c496b1aA42BAD131].exists = true;
1466     whitelist[0x8053843d83282e91f9DAaecfb66fE7C440545Ef8].exists = true;
1467     whitelist[0x8889D47281AEF794e39f50e679242bc9AC32cfeE].exists = true;
1468     whitelist[0xE8BEb17839F5f7fDD8324e3de41eaB74c03A280A].exists = true;
1469     whitelist[0x2146b3AE649d2829ec3234d2D4f5c9f34965E3Fe].exists = true;
1470     whitelist[0xDbf7E19a4FbCA4a2cD8820ca8A860C41fEadda90].exists = true;
1471     whitelist[0xBf7c5F30057288FC2D7D406B6F6c57E1D3235A27].exists = true;
1472     whitelist[0x0F87cD8301a0B74CCa321Be2b3e92fF859dd59Cb].exists = true;
1473     whitelist[0x1F3A0dd591B51Ae6a67415E147c7a25437B54501].exists = true;
1474     whitelist[0xA3c731882BBb5C2f19abcbbab06c22F20745Ef2b].exists = true;
1475     whitelist[0x00085AA596DA26FF95A0aa5772988E100bf52730].exists = true;
1476     whitelist[0xA7Fc9f19d9C5F8c39E69c1674C4c14fdd8f0dc2c].exists = true;
1477     whitelist[0xaB58f3dE07Fb3455D218438A99d69B3f06F23C49].exists = true;
1478     whitelist[0x67Bb605e68389C39e1b71990c54E985BeFFa0bd6].exists = true;
1479     whitelist[0x0A9acCc02Bf746D44E8E5f00056E24583AFDe0E4].exists = true;
1480     whitelist[0x3aE68dCe9c856413D5Fc72225e3b60E4EB8984Fc].exists = true;
1481     whitelist[0x50517761D2be85075Df41b92E2a581B59a0DB549].exists = true;
1482     whitelist[0x22eEF23D58355f08034551f66c194c2752D494C6].exists = true;
1483     whitelist[0xA0BDF16f3C91633838ad715a4bC7e8B406093340].exists = true;
1484     whitelist[0xD7e5EcE88400B813Ca8BE363583ACB3342939b24].exists = true;
1485     whitelist[0xeA5876991ca48E366f46b5BdE5E6aDCfFA2000bc].exists = true;
1486     whitelist[0x095fd83d8909B3f9daB3ab36B24a28d5b57a5E48].exists = true;
1487     whitelist[0xbAaBA861464F25f52c2eE10CC3AC024F4f77812a].exists = true;
1488     whitelist[0x09AF59067B159A023E41DF8721ce4ad71cd70a99].exists = true;
1489     whitelist[0x56F4507C6Fdb017CDE092C37D3cf9893322245EB].exists = true;
1490     whitelist[0x6245f1c86AF1D0F87e5830b400033b1369d41c34].exists = true;
1491     whitelist[0x709Ab301978E2Cc74D35D15C7C33107a37047BFa].exists = true;
1492     whitelist[0x6139A7487D122934982A9a0f6eb81D64F25A8176].exists = true;
1493     whitelist[0xbdE1668dC41e0edDb253c03faF965ADc72BFd027].exists = true;
1494     whitelist[0x70070d4Ff9487755709e8ddC895820B456AF9d9A].exists = true;
1495     whitelist[0xA5a88A21896f963F59f2c3E0Ee2247565dd9F257].exists = true;
1496     whitelist[0xa26bdB6b0183F142355D82BA51540D28ABeD75fF].exists = true;
1497     whitelist[0xC31cB85aFa668fa7BFDF1Ad189b16F5249FA4c8E].exists = true;
1498     whitelist[0xDF0f45c028946D7c410e06f18547EA5eD4B98B63].exists = true;
1499     whitelist[0x943ead70dce4DF339227f4c7480f80A584f3d884].exists = true;
1500     whitelist[0xD9E77B9dc0095F45273A49442FDC49513F2E062d].exists = true;
1501     whitelist[0x0763cB7FC792A0AD0EE5593be50f82e2Da7aeb09].exists = true;
1502     whitelist[0x445934820d319b9F26cD7E7675c3184C0E2013FD].exists = true;
1503     whitelist[0x4f0c752fdbEA79558DdA8273750562eed4a518e2].exists = true;
1504     whitelist[0x9a290AF64601F34debadc26526a1A52F7a554E1b].exists = true;
1505     whitelist[0x8A3FfA2F2F2249da2B475EB15a223C3b9F735Fe8].exists = true;
1506     whitelist[0x08A5ae15FAE7A78517438A7e44f3DefE588dEf6f].exists = true;
1507     whitelist[0x8118123F6747f6f079492b8789256f2CEe932B64].exists = true;
1508     whitelist[0x327Af9D0EC5851102D53326d1dD89ea0F43eC85c].exists = true;
1509     whitelist[0xcCC34C28A0b3762DaE74EECa2a631661DaF3DAf5].exists = true;
1510     whitelist[0xe0d4938f6325F0f4f944a581fc5bb68Faa07f47a].exists = true;
1511     whitelist[0xaEFC4c562002de306714a40Cc0A31b86f7E79077].exists = true;
1512     whitelist[0xd4Af804b5fc981c889E7b7c3af0E8D8aC2e2630D].exists = true;
1513     whitelist[0xB5BEebBFB568be3d5d7AFc7C35CAC5bC517a1fA4].exists = true;
1514     whitelist[0x9Fd9eC2A8BD80EE3105E979DB5f052B92A2F3FF1].exists = true;
1515     whitelist[0x2401379C8f2f131089db4a13454920F64bfBE622].exists = true;
1516     whitelist[0xDADa6af9D17B79d2a6e916c415178c3Fc252bD9A].exists = true;
1517     whitelist[0x72df07D6cB06d55B4e38f0b3761e0406E3FB38F6].exists = true;
1518     whitelist[0xB89f17Dd3772EFa4cf32785c3ad8c73a38A82409].exists = true;
1519     whitelist[0x65ADb749acE94D10535e0996C4223c3DcB4E6c84].exists = true;
1520     whitelist[0x7A7f4487642CB6Ba2D09A7f6902EB2feFA2ED5a4].exists = true;
1521     whitelist[0xaEaf879E6b2BECb46e173dC96888276800C74119].exists = true;
1522     whitelist[0xb490dde9273C5042B1c4E18aA1d551853b4862D0].exists = true;
1523     whitelist[0x367fc750E257656A6B4d497a0d9Ea74FE5C320eB].exists = true;
1524     whitelist[0xAD0bc71Da62040A4204bbbB0D83c4F4DCE5c8B03].exists = true;
1525     whitelist[0xBC50EB3b6C11F05a20353c1098B49Cd137788D40].exists = true;
1526     whitelist[0xa32886a9abB05D69ee88A55d98418539FE2B6339].exists = true;
1527     whitelist[0x3E18B56E65ccb82Ac6E81a0c18071D1dd644B65B].exists = true;
1528     whitelist[0x048B1cCecf3635f0506909e5BCF61Fac69b9236d].exists = true;
1529     whitelist[0x9Ca2F06c148b6ee694892B8A455400F75c2807A2].exists = true;
1530     whitelist[0xf147510B4755159608C4395C121fD64FeEA37747].exists = true;
1531     whitelist[0x3f015b37cd324D3cbaaA075A75f8F0a9AfeB04e1].exists = true;
1532     whitelist[0xE8fa3E7281C9fDE4F9c590DCEF0c797FDbd8E71f].exists = true;
1533     whitelist[0x3580aB76A179aF05E94FcB16f84C9C253d4d0aB1].exists = true;
1534     whitelist[0xe63fA6524Fa2d252cC3B46fDb4839900BfBFBB49].exists = true;
1535     whitelist[0xb518a513fE076345B13911617976E27b262d5033].exists = true;
1536     whitelist[0xdb2Ceb603DdF833A8D68698078F46efaA9C165E1].exists = true;
1537     whitelist[0x3Dce69B6e183ceb6B39fA7DF2BC190185D8eDf75].exists = true;
1538     whitelist[0xf43967FCA936a195981ebEECEC035daa59Fab443].exists = true;
1539     whitelist[0x43123084c1B589447a02e351688765ef57dc9B85].exists = true;
1540     whitelist[0xe072BE2b42857dbeeE17a30fA53752BF438058b7].exists = true;
1541     whitelist[0x15e8CcBD3CE150B382aB8bb8B1E874fC81d14EdD].exists = true;
1542     whitelist[0x11C61bcD43d61b62719c7971b227fBb8Cf6F3B71].exists = true;
1543     whitelist[0x68EFfCbfA1Fb3b5A18FEbC8aC4d22B5999B93E7f].exists = true;
1544     whitelist[0x3E59eA5c21ebb11765f182D7Cf901a8615c7cCDA].exists = true;
1545     whitelist[0x38E3f0Ca14525d869Fa7fE19303a9b711DD375c9].exists = true;
1546     whitelist[0x020F441f825767542a8853e08F7fd086a26981C2].exists = true;
1547     whitelist[0xE498Aa2326F80c7299E22d16376D4113cb519733].exists = true;
1548     whitelist[0x99F1396495cCeaFfE82C9e22b8A6ceB9c6b9336d].exists = true;
1549     whitelist[0xF9a99B48Ca723176B5Cc10d6EB0bA7d0e0529a3E].exists = true;
1550     whitelist[0xA17138c0675173B8Ea506Fb1b96FA754BC316cc2].exists = true;
1551     whitelist[0x9c4f52cf0f6537031d64B0C8BA7ea1729f0d1087].exists = true;
1552     whitelist[0x98BE88Fe1305e65EBd2AfaEf493A36200740e212].exists = true;
1553     whitelist[0xf777a4BA5021F3aB5Fe1F623d4051e556A246F72].exists = true;
1554     whitelist[0x0C9642Dc22C957612fD1c297EBB9fB91d9d12990].exists = true;
1555     whitelist[0x402a0Af9f46690c1f5d78e4d4990fb00a91C4114].exists = true;
1556     whitelist[0xF4a52a3B2715dd0bb046a212dE51dB38eb1329D3].exists = true;
1557     whitelist[0x4bB7Eceeb36395Deb86A42be19fC1440A23B5eA0].exists = true;
1558     whitelist[0xE5eF9FF63C464Cf421Aa95F06Ce15D707662D5f2].exists = true;
1559     whitelist[0x5233f73d362BC62Ccc500036027A100194506eC9].exists = true;
1560     whitelist[0x9EB335400b6AB26481002a25171b0E0b50A33fd8].exists = true;
1561     whitelist[0xf92f571Fd4ed497f672D4F37F46ee02eb13b63C8].exists = true;
1562     whitelist[0xcce848d0E705c72ce054c5D4918d32Ecf44c5905].exists = true;
1563     whitelist[0x40B4911489A87858F7e6765FDD32DFdD9D449aC6].exists = true;
1564     whitelist[0x406E4e822E0706Acf2c958d00ff82452020c556B].exists = true;
1565     whitelist[0x6b88C64796192728eEe4Ee19db1AE43FC4C80A23].exists = true;
1566     whitelist[0x8f94bE578e4A5435244b2E272D2b649D58242b23].exists = true;
1567     whitelist[0x2b08B2c356C2c9C4Cc8F2993673F44106165b20b].exists = true;
1568     whitelist[0x40b6B169FC9aAa1380375EBcC4BE40D19F37e1Ff].exists = true;
1569     }
1570 
1571     function OnWhiteList(address walletaddr)
1572     public
1573     view
1574     returns (bool)
1575     {
1576         if (whitelist[walletaddr].exists){
1577             return true;
1578         }
1579         else{
1580             return false;
1581         }
1582     }
1583 
1584     function addToWhiteList (address[] memory newWalletaddr) public onlyOwner{
1585         for (uint256 i = 0; i<newWalletaddr.length;i++){
1586             whitelist[newWalletaddr[i]].exists = true;
1587         }        
1588     }
1589 
1590     function withdraw() public onlyOwner {
1591     require(payable(msg.sender).send(address(this).balance));
1592     }
1593 
1594     function flipDropState() public onlyOwner {
1595         drop_is_active = !drop_is_active;
1596     }
1597 
1598     function flipPresaleSate() public onlyOwner {
1599         presale_is_active = !presale_is_active;
1600     }
1601 
1602     function PresaleMint(uint256 numberOfTokens) public payable{
1603         require(presale_is_active, "Please wait until the PreMint has begun!");
1604         require(whitelist[msg.sender].exists == true, "This Wallet is not able mint for presale");
1605         require(numberOfTokens > 0 && tokensMinted + numberOfTokens <= ApeSup, "Purchase would exceed max supply of MAW's");
1606         require(whitelist[msg.sender].presalemints + numberOfTokens <= 2,"This Wallet has already minted its 2 reserved MAW's");
1607         require(msg.value >= apePrice * numberOfTokens, "ETH value sent is too little for this many MAW's");
1608 
1609         for(uint i=0;i<numberOfTokens;i++){
1610             if (tokensMinted < ApeSup){
1611                 whitelist[msg.sender].presalemints++;
1612                 tokensMinted++;
1613                 _safeMint(msg.sender, tokensMinted);
1614             }
1615         }
1616 
1617     }
1618 
1619     function mintMAW(uint numberOfTokens) public payable {
1620         require(drop_is_active, "Please wait until the Public sale is active to mint");
1621         require(numberOfTokens > 0 && numberOfTokens <= maxApePurchase);
1622         require(tokensMinted + numberOfTokens <= ApeSup, "Purchase would exceed max supply of MAW's");
1623         require(msg.value >= apePrice * numberOfTokens, "ETH value sent is too little for this many MAW's");
1624 
1625         for (uint i=0;i<numberOfTokens;i++){
1626             if (tokensMinted < ApeSup){
1627                 tokensMinted++;
1628                 _safeMint(msg.sender, tokensMinted);
1629             }
1630         }
1631     }
1632 
1633     function _baseURI() internal view virtual override returns (string memory) {
1634         return baseURI;
1635     }
1636 
1637     function setBaseURI(string memory newBaseURI)public onlyOwner{
1638         baseURI = newBaseURI;
1639     }
1640     function lowerMintPrice(uint256 newPrice) public onlyOwner {
1641         require(newPrice < apePrice);
1642         apePrice = newPrice;
1643     }
1644 
1645     function lowerMintSupply(uint256 newSupply) public onlyOwner {
1646         require(newSupply < ApeSup);
1647         require(newSupply > totalSupply());
1648         ApeSup = newSupply;
1649     }
1650 }