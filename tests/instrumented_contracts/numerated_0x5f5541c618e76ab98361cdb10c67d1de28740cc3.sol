1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 
71 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 
96 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      */
121     function isContract(address account) internal view returns (bool) {
122         // This method relies on extcodesize, which returns 0 for contracts in
123         // construction, since the code is only stored at the end of the
124         // constructor execution.
125 
126         uint256 size;
127         assembly {
128             size := extcodesize(account)
129         }
130         return size > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{value: amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     /**
157      * @dev Performs a Solidity function call using a low level `call`. A
158      * plain `call` is an unsafe replacement for a function call: use this
159      * function instead.
160      *
161      * If `target` reverts with a revert reason, it is bubbled up by this
162      * function (like regular Solidity function calls).
163      *
164      * Returns the raw returned data. To convert to the expected return value,
165      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
166      *
167      * Requirements:
168      *
169      * - `target` must be a contract.
170      * - calling `target` with `data` must not revert.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionCall(target, data, "Address: low-level call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
180      * `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(address(this).balance >= value, "Address: insufficient balance for call");
224         require(isContract(target), "Address: call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.call{value: value}(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
237         return functionStaticCall(target, data, "Address: low-level static call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal view returns (bytes memory) {
251         require(isContract(target), "Address: static call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.staticcall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(isContract(target), "Address: delegate call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.delegatecall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
286      * revert reason using the provided one.
287      *
288      * _Available since v4.3._
289      */
290     function verifyCallResult(
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal pure returns (bytes memory) {
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301 
302                 assembly {
303                     let returndata_size := mload(returndata)
304                     revert(add(32, returndata), returndata_size)
305                 }
306             } else {
307                 revert(errorMessage);
308             }
309         }
310     }
311 }
312 
313 
314 
315 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Interface of the ERC165 standard, as defined in the
321  * https://eips.ethereum.org/EIPS/eip-165[EIP].
322  *
323  * Implementers can declare support of contract interfaces, which can then be
324  * queried by others ({ERC165Checker}).
325  *
326  * For an implementation, see {ERC165}.
327  */
328 interface IERC165 {
329     /**
330      * @dev Returns true if this contract implements the interface defined by
331      * `interfaceId`. See the corresponding
332      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
333      * to learn more about how these ids are created.
334      *
335      * This function call must use less than 30 000 gas.
336      */
337     function supportsInterface(bytes4 interfaceId) external view returns (bool);
338 }
339 
340 
341 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Required interface of an ERC721 compliant contract.
347  */
348 interface IERC721 is IERC165 {
349     /**
350      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
351      */
352     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
353 
354     /**
355      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
356      */
357     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
358 
359     /**
360      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
361      */
362     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
363 
364     /**
365      * @dev Returns the number of tokens in ``owner``'s account.
366      */
367     function balanceOf(address owner) external view returns (uint256 balance);
368 
369     /**
370      * @dev Returns the owner of the `tokenId` token.
371      *
372      * Requirements:
373      *
374      * - `tokenId` must exist.
375      */
376     function ownerOf(uint256 tokenId) external view returns (address owner);
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Transfers `tokenId` token from `from` to `to`.
400      *
401      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
420      * The approval is cleared when the token is transferred.
421      *
422      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Returns the account approved for `tokenId` token.
435      *
436      * Requirements:
437      *
438      * - `tokenId` must exist.
439      */
440     function getApproved(uint256 tokenId) external view returns (address operator);
441 
442     /**
443      * @dev Approve or remove `operator` as an operator for the caller.
444      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
445      *
446      * Requirements:
447      *
448      * - The `operator` cannot be the caller.
449      *
450      * Emits an {ApprovalForAll} event.
451      */
452     function setApprovalForAll(address operator, bool _approved) external;
453 
454     /**
455      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
456      *
457      * See {setApprovalForAll}
458      */
459     function isApprovedForAll(address owner, address operator) external view returns (bool);
460 
461     /**
462      * @dev Safely transfers `tokenId` token from `from` to `to`.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must exist and be owned by `from`.
469      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
470      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
471      *
472      * Emits a {Transfer} event.
473      */
474     function safeTransferFrom(
475         address from,
476         address to,
477         uint256 tokenId,
478         bytes calldata data
479     ) external;
480 }
481 
482 
483 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
489  * @dev See https://eips.ethereum.org/EIPS/eip-721
490  */
491 interface IERC721Metadata is IERC721 {
492     /**
493      * @dev Returns the token collection name.
494      */
495     function name() external view returns (string memory);
496 
497     /**
498      * @dev Returns the token collection symbol.
499      */
500     function symbol() external view returns (string memory);
501 
502     /**
503      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
504      */
505     function tokenURI(uint256 tokenId) external view returns (string memory);
506 }
507 
508 
509 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @title ERC721 token receiver interface
515  * @dev Interface for any contract that wants to support safeTransfers
516  * from ERC721 asset contracts.
517  */
518 interface IERC721Receiver {
519     /**
520      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
521      * by `operator` from `from`, this function is called.
522      *
523      * It must return its Solidity selector to confirm the token transfer.
524      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
525      *
526      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
527      */
528     function onERC721Received(
529         address operator,
530         address from,
531         uint256 tokenId,
532         bytes calldata data
533     ) external returns (bytes4);
534 }
535 
536 
537 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
565 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
571  * the Metadata extension, but not including the Enumerable extension, which is available separately as
572  * {ERC721Enumerable}.
573  */
574 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
575     using Address for address;
576     using Strings for uint256;
577 
578     // Token name
579     string private _name;
580 
581     // Token symbol
582     string private _symbol;
583 
584     // Mapping from token ID to owner address
585     mapping(uint256 => address) private _owners;
586 
587     // Mapping owner address to token count
588     mapping(address => uint256) private _balances;
589 
590     // Mapping from token ID to approved address
591     mapping(uint256 => address) private _tokenApprovals;
592 
593     // Mapping from owner to operator approvals
594     mapping(address => mapping(address => bool)) private _operatorApprovals;
595 
596     /**
597      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
598      */
599     constructor(string memory name_, string memory symbol_) {
600         _name = name_;
601         _symbol = symbol_;
602     }
603 
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
608         return
609             interfaceId == type(IERC721).interfaceId ||
610             interfaceId == type(IERC721Metadata).interfaceId ||
611             super.supportsInterface(interfaceId);
612     }
613 
614     /**
615      * @dev See {IERC721-balanceOf}.
616      */
617     function balanceOf(address owner) public view virtual override returns (uint256) {
618         require(owner != address(0), "ERC721: balance query for the zero address");
619         return _balances[owner];
620     }
621 
622     /**
623      * @dev See {IERC721-ownerOf}.
624      */
625     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
626         address owner = _owners[tokenId];
627         require(owner != address(0), "ERC721: owner query for nonexistent token");
628         return owner;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-name}.
633      */
634     function name() public view virtual override returns (string memory) {
635         return _name;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-symbol}.
640      */
641     function symbol() public view virtual override returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-tokenURI}.
647      */
648     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
649         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
650 
651         string memory baseURI = _baseURI();
652         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
653     }
654 
655     /**
656      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
657      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
658      * by default, can be overriden in child contracts.
659      */
660     function _baseURI() internal view virtual returns (string memory) {
661         return "";
662     }
663 
664     /**
665      * @dev See {IERC721-approve}.
666      */
667     function approve(address to, uint256 tokenId) public virtual override {
668         address owner = ERC721.ownerOf(tokenId);
669         require(to != owner, "ERC721: approval to current owner");
670 
671         require(
672             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
673             "ERC721: approve caller is not owner nor approved for all"
674         );
675 
676         _approve(to, tokenId);
677     }
678 
679     /**
680      * @dev See {IERC721-getApproved}.
681      */
682     function getApproved(uint256 tokenId) public view virtual override returns (address) {
683         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
684 
685         return _tokenApprovals[tokenId];
686     }
687 
688     /**
689      * @dev See {IERC721-setApprovalForAll}.
690      */
691     function setApprovalForAll(address operator, bool approved) public virtual override {
692         _setApprovalForAll(_msgSender(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC721-isApprovedForAll}.
697      */
698     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[owner][operator];
700     }
701 
702     /**
703      * @dev See {IERC721-transferFrom}.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         //solhint-disable-next-line max-line-length
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
712 
713         _transfer(from, to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         safeTransferFrom(from, to, tokenId, "");
725     }
726 
727     /**
728      * @dev See {IERC721-safeTransferFrom}.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes memory _data
735     ) public virtual override {
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737         _safeTransfer(from, to, tokenId, _data);
738     }
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
742      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
743      *
744      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
745      *
746      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
747      * implement alternative mechanisms to perform token transfer, such as signature-based.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _safeTransfer(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) internal virtual {
764         _transfer(from, to, tokenId);
765         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
766     }
767 
768     /**
769      * @dev Returns whether `tokenId` exists.
770      *
771      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
772      *
773      * Tokens start existing when they are minted (`_mint`),
774      * and stop existing when they are burned (`_burn`).
775      */
776     function _exists(uint256 tokenId) internal view virtual returns (bool) {
777         return _owners[tokenId] != address(0);
778     }
779 
780     /**
781      * @dev Returns whether `spender` is allowed to manage `tokenId`.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
788         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
789         address owner = ERC721.ownerOf(tokenId);
790         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
791     }
792 
793     /**
794      * @dev Safely mints `tokenId` and transfers it to `to`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must not exist.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _safeMint(address to, uint256 tokenId) internal virtual {
804         _safeMint(to, tokenId, "");
805     }
806 
807     /**
808      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
809      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
810      */
811     function _safeMint(
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) internal virtual {
816         _mint(to, tokenId);
817         require(
818             _checkOnERC721Received(address(0), to, tokenId, _data),
819             "ERC721: transfer to non ERC721Receiver implementer"
820         );
821     }
822 
823     /**
824      * @dev Mints `tokenId` and transfers it to `to`.
825      *
826      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - `to` cannot be the zero address.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _mint(address to, uint256 tokenId) internal virtual {
836         require(to != address(0), "ERC721: mint to the zero address");
837         require(!_exists(tokenId), "ERC721: token already minted");
838 
839         _beforeTokenTransfer(address(0), to, tokenId);
840 
841         _balances[to] += 1;
842         _owners[tokenId] = to;
843 
844         emit Transfer(address(0), to, tokenId);
845     }
846 
847     /**
848      * @dev Destroys `tokenId`.
849      * The approval is cleared when the token is burned.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _burn(uint256 tokenId) internal virtual {
858         address owner = ERC721.ownerOf(tokenId);
859 
860         _beforeTokenTransfer(owner, address(0), tokenId);
861 
862         // Clear approvals
863         _approve(address(0), tokenId);
864 
865         _balances[owner] -= 1;
866         delete _owners[tokenId];
867 
868         emit Transfer(owner, address(0), tokenId);
869     }
870 
871     /**
872      * @dev Transfers `tokenId` from `from` to `to`.
873      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must be owned by `from`.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _transfer(
883         address from,
884         address to,
885         uint256 tokenId
886     ) internal virtual {
887         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
888         require(to != address(0), "ERC721: transfer to the zero address");
889 
890         _beforeTokenTransfer(from, to, tokenId);
891 
892         // Clear approvals from the previous owner
893         _approve(address(0), tokenId);
894 
895         _balances[from] -= 1;
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev Approve `to` to operate on `tokenId`
904      *
905      * Emits a {Approval} event.
906      */
907     function _approve(address to, uint256 tokenId) internal virtual {
908         _tokenApprovals[tokenId] = to;
909         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
910     }
911 
912     /**
913      * @dev Approve `operator` to operate on all of `owner` tokens
914      *
915      * Emits a {ApprovalForAll} event.
916      */
917     function _setApprovalForAll(
918         address owner,
919         address operator,
920         bool approved
921     ) internal virtual {
922         require(owner != operator, "ERC721: approve to caller");
923         _operatorApprovals[owner][operator] = approved;
924         emit ApprovalForAll(owner, operator, approved);
925     }
926 
927     /**
928      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
929      * The call is not executed if the target address is not a contract.
930      *
931      * @param from address representing the previous owner of the given token ID
932      * @param to target address that will receive the tokens
933      * @param tokenId uint256 ID of the token to be transferred
934      * @param _data bytes optional data to send along with the call
935      * @return bool whether the call correctly returned the expected magic value
936      */
937     function _checkOnERC721Received(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) private returns (bool) {
943         if (to.isContract()) {
944             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
945                 return retval == IERC721Receiver.onERC721Received.selector;
946             } catch (bytes memory reason) {
947                 if (reason.length == 0) {
948                     revert("ERC721: transfer to non ERC721Receiver implementer");
949                 } else {
950                     assembly {
951                         revert(add(32, reason), mload(reason))
952                     }
953                 }
954             }
955         } else {
956             return true;
957         }
958     }
959 
960     /**
961      * @dev Hook that is called before any token transfer. This includes minting
962      * and burning.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` will be minted for `to`.
969      * - When `to` is zero, ``from``'s `tokenId` will be burned.
970      * - `from` and `to` are never both zero.
971      *
972      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
973      */
974     function _beforeTokenTransfer(
975         address from,
976         address to,
977         uint256 tokenId
978     ) internal virtual {}
979 }
980 
981 
982 /**
983 *   @title Survive All Apocalypses (AKA Don't Die Book)
984 *   @author Transient Labs
985 *   @notice ERC721 smart contract with access control and optimized for airdrop
986 *   Copyright (C) 2021 Transient Labs
987 */
988 
989 pragma solidity ^0.8.0;
990 
991 contract TheDegenaissance is ERC721 {
992     string public baseURI;
993     uint256 public _totalSupply;
994     address public owner;
995 
996     /**
997     *   @notice constructor for this contract
998     *   @dev name and symbol are hardcoded in from the start
999     */
1000     constructor() ERC721("The Degenaissance", "DEGEN") {
1001         baseURI = string("ipfs://QmdPQRVCDvDjapV6SNGMxNbp31NeNwneM54Y861MGjTYMR/");
1002         owner = address(0x9Ad21C497837165344e1fA54fe894174b19c51e0);
1003         _totalSupply = 2553;
1004     }
1005 
1006     /**
1007     *   @notice function to view total supply
1008     *   @return uint256 with supply
1009     */
1010     function totalSupply() public view returns(uint256) {
1011         return _totalSupply;
1012     }
1013 
1014     /**
1015     *   @notice override supportsInterface function since both ERC721 and AccessControl utilize it
1016     *   @dev see {IERC165-supportsInterface}
1017     */
1018     function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1019         return
1020             interfaceId == type(IERC721).interfaceId ||
1021             interfaceId == type(IERC721Metadata).interfaceId ||
1022             super.supportsInterface(interfaceId);       
1023     }
1024 
1025     /**
1026     *   @notice sets the baseURI for the ERC721 tokens
1027     *   @dev requires ADMIN role
1028     *   @param uri is the base URI set for each token
1029     */
1030     function setBaseURI(string memory uri) external {
1031         require(msg.sender == owner, "setBaseUri unauthorized");
1032         baseURI = uri;
1033     }
1034 
1035     /**
1036     *   @notice override standard ERC721 base URI
1037     *   @dev doesn't require access control since it's internal
1038     *   @return string representing base URI
1039     */
1040     function _baseURI() internal view override returns (string memory) {
1041         return baseURI;
1042     }
1043 
1044     /**
1045     *   @notice mint function in batches
1046     *   @dev requires ADMIN access
1047     *   @dev converts token id to the appropriate tokenURI string
1048     *   @param addresses is an array of addresses to mint to
1049     *   @param start is the tokenId to start iteration with
1050     */
1051     function batchMint(address[] memory addresses, uint256 start) external {
1052         require(msg.sender == owner, "batchMint unauthorized");
1053         for (uint256 i = 0; i < addresses.length; i++) {
1054             _mint(addresses[i], start+i);
1055         }
1056     }
1057     
1058     /**
1059      * @dev See {IERC721Metadata-tokenURI}.
1060      */
1061     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1062         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1063 
1064         return string(abi.encodePacked(_baseURI()));
1065     }
1066 
1067 }