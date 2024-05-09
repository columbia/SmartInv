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
653         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
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
1250 contract PhunkyMutantApeYachtClub is ERC721Enumerable, Ownable {
1251 
1252     uint256 public maycPrice = 20000000000000000;
1253     uint public constant maxMaycPurchase = 10;
1254     uint public maycSupply = 10000;
1255     bool public drop_is_active = false;
1256     string public baseURI = "";
1257     uint256 public tokensMinted = 0;
1258     uint256 public freeMints = 6000;
1259 
1260     mapping(address => uint) addressesThatMinted;
1261 
1262     constructor() ERC721("PhunkyMutantApeYachtClub", "PMAYC"){
1263     
1264     }
1265 
1266     function withdraw() public onlyOwner {
1267         require(payable(msg.sender).send(address(this).balance));
1268     }
1269 
1270     function flipDropState() public onlyOwner {
1271         drop_is_active = !drop_is_active;
1272     }
1273 
1274     function freeMintPMAYC(uint numberOfTokens) public {
1275         require(drop_is_active, "Please wait until the drop is active to mint");
1276         require(numberOfTokens > 0 && numberOfTokens <= maxMaycPurchase, "Mint count is too little or too high");
1277         require(tokensMinted + numberOfTokens <= freeMints, "Purchase will exceed max supply of free mints");
1278         require(addressesThatMinted[msg.sender] + numberOfTokens <= 10, "You have already minted 10!");
1279 
1280         uint256 tokenIndex = tokensMinted;
1281         tokensMinted += numberOfTokens;
1282         addressesThatMinted[msg.sender] += numberOfTokens;
1283 
1284         for (uint i = 0; i < numberOfTokens; i++){
1285             _safeMint(msg.sender, tokenIndex);
1286             tokenIndex++;
1287         }
1288     }
1289 
1290     function mintPMAYC(uint numberOfTokens) public payable {
1291         require(drop_is_active, "Please wait until the drop is active to mint");
1292         require(numberOfTokens > 0 && numberOfTokens <= maxMaycPurchase, "Mint count is too little or too high");
1293         require(tokensMinted + numberOfTokens <= maycSupply, "Purchase would exceed max supply of PMAYCs");
1294         require(msg.value >= maycPrice * numberOfTokens, "ETH value sent is too little for this many PMAYCs");
1295         require(addressesThatMinted[msg.sender] + numberOfTokens <= 10, "You have already minted 10!");
1296 
1297         uint256 tokenIndex = tokensMinted;
1298         tokensMinted += numberOfTokens;
1299         addressesThatMinted[msg.sender] += numberOfTokens;
1300 
1301         for (uint i = 0; i < numberOfTokens; i++){
1302             _safeMint(msg.sender, tokenIndex);
1303             tokenIndex++;
1304         }
1305     }
1306 
1307     function _baseURI() internal view virtual override returns (string memory) {
1308         return baseURI;
1309     }
1310 
1311     function setBaseURI(string memory newBaseURI)public onlyOwner{
1312         baseURI = newBaseURI;
1313     }
1314 
1315     function setSupply(uint256 newSupply)public onlyOwner{
1316         maycSupply = newSupply;
1317     }
1318 
1319 }