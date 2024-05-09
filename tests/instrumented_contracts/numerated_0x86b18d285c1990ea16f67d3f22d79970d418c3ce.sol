1 // SPDX-License-Identifier: BSD-3-Clause
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         assembly {
104             size := extcodesize(account)
105         }
106         return size > 0;
107     }
108 
109     /**
110      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
111      * `recipient`, forwarding all available gas and reverting on errors.
112      *
113      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
114      * of certain opcodes, possibly making contracts go over the 2300 gas limit
115      * imposed by `transfer`, making them unable to receive funds via
116      * `transfer`. {sendValue} removes this limitation.
117      *
118      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
119      *
120      * IMPORTANT: because control is transferred to `recipient`, care must be
121      * taken to not create reentrancy vulnerabilities. Consider using
122      * {ReentrancyGuard} or the
123      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
124      */
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain `call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: value}(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal view returns (bytes memory) {
227         require(isContract(target), "Address: static call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.staticcall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(isContract(target), "Address: delegate call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.delegatecall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
262      * revert reason using the provided one.
263      *
264      * _Available since v4.3._
265      */
266     function verifyCallResult(
267         bool success,
268         bytes memory returndata,
269         string memory errorMessage
270     ) internal pure returns (bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 assembly {
279                     let returndata_size := mload(returndata)
280                     revert(add(32, returndata), returndata_size)
281                 }
282             } else {
283                 revert(errorMessage);
284             }
285         }
286     }
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
290 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @title ERC721 token receiver interface
296  * @dev Interface for any contract that wants to support safeTransfers
297  * from ERC721 asset contracts.
298  */
299 interface IERC721Receiver {
300     /**
301      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
302      * by `operator` from `from`, this function is called.
303      *
304      * It must return its Solidity selector to confirm the token transfer.
305      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
306      *
307      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
308      */
309     function onERC721Received(
310         address operator,
311         address from,
312         uint256 tokenId,
313         bytes calldata data
314     ) external returns (bytes4);
315 }
316 
317 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
318 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Interface of the ERC165 standard, as defined in the
324  * https://eips.ethereum.org/EIPS/eip-165[EIP].
325  *
326  * Implementers can declare support of contract interfaces, which can then be
327  * queried by others ({ERC165Checker}).
328  *
329  * For an implementation, see {ERC165}.
330  */
331 interface IERC165 {
332     /**
333      * @dev Returns true if this contract implements the interface defined by
334      * `interfaceId`. See the corresponding
335      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
336      * to learn more about how these ids are created.
337      *
338      * This function call must use less than 30 000 gas.
339      */
340     function supportsInterface(bytes4 interfaceId) external view returns (bool);
341 }
342 
343 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
344 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 
349 /**
350  * @dev Implementation of the {IERC165} interface.
351  *
352  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
353  * for the additional interface id that will be supported. For example:
354  *
355  * ```solidity
356  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
358  * }
359  * ```
360  *
361  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
362  */
363 abstract contract ERC165 is IERC165 {
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
373 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Required interface of an ERC721 compliant contract.
379  */
380 interface IERC721 is IERC165 {
381     /**
382      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
388      */
389     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
393      */
394     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
395 
396     /**
397      * @dev Returns the number of tokens in ``owner``'s account.
398      */
399     function balanceOf(address owner) external view returns (uint256 balance);
400 
401     /**
402      * @dev Returns the owner of the `tokenId` token.
403      *
404      * Requirements:
405      *
406      * - `tokenId` must exist.
407      */
408     function ownerOf(uint256 tokenId) external view returns (address owner);
409 
410     /**
411      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
412      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external;
429 
430     /**
431      * @dev Transfers `tokenId` token from `from` to `to`.
432      *
433      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must be owned by `from`.
440      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
441      *
442      * Emits a {Transfer} event.
443      */
444     function transferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
452      * The approval is cleared when the token is transferred.
453      *
454      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
455      *
456      * Requirements:
457      *
458      * - The caller must own the token or be an approved operator.
459      * - `tokenId` must exist.
460      *
461      * Emits an {Approval} event.
462      */
463     function approve(address to, uint256 tokenId) external;
464 
465     /**
466      * @dev Returns the account approved for `tokenId` token.
467      *
468      * Requirements:
469      *
470      * - `tokenId` must exist.
471      */
472     function getApproved(uint256 tokenId) external view returns (address operator);
473 
474     /**
475      * @dev Approve or remove `operator` as an operator for the caller.
476      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
477      *
478      * Requirements:
479      *
480      * - The `operator` cannot be the caller.
481      *
482      * Emits an {ApprovalForAll} event.
483      */
484     function setApprovalForAll(address operator, bool _approved) external;
485 
486     /**
487      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
488      *
489      * See {setApprovalForAll}
490      */
491     function isApprovedForAll(address owner, address operator) external view returns (bool);
492 
493     /**
494      * @dev Safely transfers `tokenId` token from `from` to `to`.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes calldata data
511     ) external;
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
515 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
522  * @dev See https://eips.ethereum.org/EIPS/eip-721
523  */
524 interface IERC721Metadata is IERC721 {
525     /**
526      * @dev Returns the token collection name.
527      */
528     function name() external view returns (string memory);
529 
530     /**
531      * @dev Returns the token collection symbol.
532      */
533     function symbol() external view returns (string memory);
534 
535     /**
536      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
537      */
538     function tokenURI(uint256 tokenId) external view returns (string memory);
539 }
540 
541 // File: @openzeppelin/contracts/utils/Context.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Provides information about the current execution context, including the
550  * sender of the transaction and its data. While these are generally available
551  * via msg.sender and msg.data, they should not be accessed in such a direct
552  * manner, since when dealing with meta-transactions the account sending and
553  * paying for execution may not be the actual sender (as far as an application
554  * is concerned).
555  *
556  * This contract is only required for intermediate, library-like contracts.
557  */
558 abstract contract Context {
559     function _msgSender() internal view virtual returns (address) {
560         return msg.sender;
561     }
562 
563     function _msgData() internal view virtual returns (bytes calldata) {
564         return msg.data;
565     }
566 }
567 
568 // File: contracts/ERC721B.sol
569 
570 pragma solidity ^0.8.0;
571 
572 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
573     using Address for address;
574 
575     // Token name
576     string private _name;
577 
578     // Token symbol
579     string private _symbol;
580 
581     // Mapping from token ID to owner address
582     address[] internal _owners;
583 
584     // Mapping from token ID to approved address
585     mapping(uint256 => address) private _tokenApprovals;
586 
587     // Mapping from owner to operator approvals
588     mapping(address => mapping(address => bool)) private _operatorApprovals;
589 
590     /**
591      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
592      */
593     constructor(string memory name_, string memory symbol_) {
594         _name = name_;
595         _symbol = symbol_;
596     }
597 
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      */
601     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
602         return
603             interfaceId == type(IERC721).interfaceId ||
604             interfaceId == type(IERC721Metadata).interfaceId ||
605             super.supportsInterface(interfaceId);
606     }
607 
608     /**
609      * @dev See {IERC721-balanceOf}.
610      */
611     function balanceOf(address owner) public view virtual override returns (uint256) {
612         require(owner != address(0), "ERC721: balance query for the zero address");
613 
614         uint count = 0;
615         uint length = _owners.length;
616         for( uint i = 0; i < length; ++i ){
617           if( owner == _owners[i] ){
618             ++count;
619           }
620         }
621 
622         delete length;
623         return count;
624     }
625 
626     /**
627      * @dev See {IERC721-ownerOf}.
628      */
629     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
630         address owner = _owners[tokenId];
631         require(owner != address(0), "ERC721: owner query for nonexistent token");
632         return owner;
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-name}.
637      */
638     function name() public view virtual override returns (string memory) {
639         return _name;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-symbol}.
644      */
645     function symbol() public view virtual override returns (string memory) {
646         return _symbol;
647     }
648 
649     /**
650      * @dev See {IERC721-approve}.
651      */
652     function approve(address to, uint256 tokenId) public virtual override {
653         address owner = ERC721B.ownerOf(tokenId);
654         require(to != owner, "ERC721: approval to current owner");
655 
656         require(
657             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
658             "ERC721: approve caller is not owner nor approved for all"
659         );
660 
661         _approve(to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-getApproved}.
666      */
667     function getApproved(uint256 tokenId) public view virtual override returns (address) {
668         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
669 
670         return _tokenApprovals[tokenId];
671     }
672 
673     /**
674      * @dev See {IERC721-setApprovalForAll}.
675      */
676     function setApprovalForAll(address operator, bool approved) public virtual override {
677         require(operator != _msgSender(), "ERC721: approve to caller");
678 
679         _operatorApprovals[_msgSender()][operator] = approved;
680         emit ApprovalForAll(_msgSender(), operator, approved);
681     }
682 
683     /**
684      * @dev See {IERC721-isApprovedForAll}.
685      */
686     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
687         return _operatorApprovals[owner][operator];
688     }
689 
690 
691     /**
692      * @dev See {IERC721-transferFrom}.
693      */
694     function transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) public virtual override {
699         //solhint-disable-next-line max-line-length
700         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
701 
702         _transfer(from, to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-safeTransferFrom}.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) public virtual override {
713         safeTransferFrom(from, to, tokenId, "");
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId,
723         bytes memory _data
724     ) public virtual override {
725         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
726         _safeTransfer(from, to, tokenId, _data);
727     }
728 
729     /**
730      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
731      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
732      *
733      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
734      *
735      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
736      * implement alternative mechanisms to perform token transfer, such as signature-based.
737      *
738      * Requirements:
739      *
740      * - `from` cannot be the zero address.
741      * - `to` cannot be the zero address.
742      * - `tokenId` token must exist and be owned by `from`.
743      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
744      *
745      * Emits a {Transfer} event.
746      */
747     function _safeTransfer(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) internal virtual {
753         _transfer(from, to, tokenId);
754         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
755     }
756 
757     /**
758      * @dev Returns whether `tokenId` exists.
759      *
760      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
761      *
762      * Tokens start existing when they are minted (`_mint`),
763      * and stop existing when they are burned (`_burn`).
764      */
765     function _exists(uint256 tokenId) internal view virtual returns (bool) {
766         return tokenId < _owners.length && _owners[tokenId] != address(0);
767     }
768 
769     /**
770      * @dev Returns whether `spender` is allowed to manage `tokenId`.
771      *
772      * Requirements:
773      *
774      * - `tokenId` must exist.
775      */
776     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
777         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
778         address owner = ERC721B.ownerOf(tokenId);
779         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
780     }
781 
782     /**
783      * @dev Safely mints `tokenId` and transfers it to `to`.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must not exist.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeMint(address to, uint256 tokenId) internal virtual {
793         _safeMint(to, tokenId, "");
794     }
795 
796 
797     /**
798      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
799      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
800      */
801     function _safeMint(
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) internal virtual {
806         _mint(to, tokenId);
807         require(
808             _checkOnERC721Received(address(0), to, tokenId, _data),
809             "ERC721: transfer to non ERC721Receiver implementer"
810         );
811     }
812 
813     /**
814      * @dev Mints `tokenId` and transfers it to `to`.
815      *
816      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - `to` cannot be the zero address.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _mint(address to, uint256 tokenId) internal virtual {
826         require(to != address(0), "ERC721: mint to the zero address");
827         require(!_exists(tokenId), "ERC721: token already minted");
828 
829         _beforeTokenTransfer(address(0), to, tokenId);
830         _owners.push(to);
831 
832         emit Transfer(address(0), to, tokenId);
833     }
834 
835     /**
836      * @dev Destroys `tokenId`.
837      * The approval is cleared when the token is burned.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _burn(uint256 tokenId) internal virtual {
846         address owner = ERC721B.ownerOf(tokenId);
847 
848         _beforeTokenTransfer(owner, address(0), tokenId);
849 
850         // Clear approvals
851         _approve(address(0), tokenId);
852         _owners[tokenId] = address(0);
853 
854         emit Transfer(owner, address(0), tokenId);
855     }
856 
857     /**
858      * @dev Transfers `tokenId` from `from` to `to`.
859      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _transfer(
869         address from,
870         address to,
871         uint256 tokenId
872     ) internal virtual {
873         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
874         require(to != address(0), "ERC721: transfer to the zero address");
875 
876         _beforeTokenTransfer(from, to, tokenId);
877 
878         // Clear approvals from the previous owner
879         _approve(address(0), tokenId);
880         _owners[tokenId] = to;
881 
882         emit Transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev Approve `to` to operate on `tokenId`
887      *
888      * Emits a {Approval} event.
889      */
890     function _approve(address to, uint256 tokenId) internal virtual {
891         _tokenApprovals[tokenId] = to;
892         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
893     }
894 
895     /**
896      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
897      * The call is not executed if the target address is not a contract.
898      *
899      * @param from address representing the previous owner of the given token ID
900      * @param to target address that will receive the tokens
901      * @param tokenId uint256 ID of the token to be transferred
902      * @param _data bytes optional data to send along with the call
903      * @return bool whether the call correctly returned the expected magic value
904      */
905     function _checkOnERC721Received(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) private returns (bool) {
911         if (to.isContract()) {
912             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
913                 return retval == IERC721Receiver.onERC721Received.selector;
914             } catch (bytes memory reason) {
915                 if (reason.length == 0) {
916                     revert("ERC721: transfer to non ERC721Receiver implementer");
917                 } else {
918                     assembly {
919                         revert(add(32, reason), mload(reason))
920                     }
921                 }
922             }
923         } else {
924             return true;
925         }
926     }
927 
928     /**
929      * @dev Hook that is called before any token transfer. This includes minting
930      * and burning.
931      *
932      * Calling conditions:
933      *
934      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
935      * transferred to `to`.
936      * - When `from` is zero, `tokenId` will be minted for `to`.
937      * - When `to` is zero, ``from``'s `tokenId` will be burned.
938      * - `from` and `to` are never both zero.
939      *
940      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
941      */
942     function _beforeTokenTransfer(
943         address from,
944         address to,
945         uint256 tokenId
946     ) internal virtual {}
947 }
948 
949 // File: @openzeppelin/contracts/access/Ownable.sol
950 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 /**
955  * @dev Contract module which provides a basic access control mechanism, where
956  * there is an account (an owner) that can be granted exclusive access to
957  * specific functions.
958  *
959  * By default, the owner account will be the one that deploys the contract. This
960  * can later be changed with {transferOwnership}.
961  *
962  * This module is used through inheritance. It will make available the modifier
963  * `onlyOwner`, which can be applied to your functions to restrict their use to
964  * the owner.
965  */
966 abstract contract Ownable is Context {
967     address private _owner;
968 
969     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
970 
971     /**
972      * @dev Initializes the contract setting the deployer as the initial owner.
973      */
974     constructor() {
975         _transferOwnership(_msgSender());
976     }
977 
978     /**
979      * @dev Returns the address of the current owner.
980      */
981     function owner() public view virtual returns (address) {
982         return _owner;
983     }
984 
985     /**
986      * @dev Throws if called by any account other than the owner.
987      */
988     modifier onlyOwner() {
989         require(owner() == _msgSender(), "Ownable: caller is not the owner");
990         _;
991     }
992 
993     /**
994      * @dev Leaves the contract without owner. It will not be possible to call
995      * `onlyOwner` functions anymore. Can only be called by the current owner.
996      *
997      * NOTE: Renouncing ownership will leave the contract without an owner,
998      * thereby removing any functionality that is only available to the owner.
999      */
1000     function renounceOwnership() public virtual onlyOwner {
1001         _transferOwnership(address(0));
1002     }
1003 
1004     /**
1005      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1006      * Can only be called by the current owner.
1007      */
1008     function transferOwnership(address newOwner) public virtual onlyOwner {
1009         require(newOwner != address(0), "Ownable: new owner is the zero address");
1010         _transferOwnership(newOwner);
1011     }
1012 
1013     /**
1014      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1015      * Internal function without access restriction.
1016      */
1017     function _transferOwnership(address newOwner) internal virtual {
1018         address oldOwner = _owner;
1019         _owner = newOwner;
1020         emit OwnershipTransferred(oldOwner, newOwner);
1021     }
1022 }
1023 
1024 /*@@((#@&#((((((((/(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#############%%%%%%%%%%%%&&%%%%%%%%%%%%%%%##(((((%
1025 %%(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#(((((((((((((((((/(((((((((((((((((((((((((((((((((((((@
1026 %%#((((((((((((((((((((((((((((((((((((((((((((((((((((( ((((((((((((((((.((((((((((((((((((((((((((((((((((((((((((((((((((((((((
1027 %#(((((((((((((((((((((((((((((((((((((((((((((((((((((# ((((((((((((((((,*((/((((((((((((((((((((((((((((((((((((((((((((((((((((
1028 %((((((((((((((((((((((((((((((((((((((((((((((((((((((. (((((((((((((/(/. (((((((((((((((((((((((((((((((((((((((((((((((((((((((
1029 &(((((((((((((((((((((((((((((((((((((((((((((((((((((#  #(((((//((((((((. /((((((((((((((((((((((((((((((((((((((((((((((((((((((
1030 &(((((((((((((((((((((((((((((((((((((((((((((((((((((*  /.,***@@@&&(/##&, .((((((((((((((((((((((((((((((((((((((((((((((((((((((
1031 &((((((((((((((((((((((((((((((((((((((((((((((((////(, .%@@@@#@@@@@@@@@&, .#(((((((((((((((((((((((((((((((((((((((((((((((((((((
1032 &((((((((((((((((((((((((((((((((((((((((((//////((((&,  *@@@@@@@@@@@@@@%. .%&((((((((((((((((((((((((((((((((((((((((((((((/(((/(
1033 &(((((((((((((((((((((((((((((((((((///////(((((((((#/.  *&(#%&#%&&&#((%(. .%%%(((((((((((((((((((((((((((((((((((((((((((((((((/(
1034 &(((((((((((((((((((((((((((((///////(((((((((((((((%,,  .(&&@&@&@@&@&%&*...%&&(((((((((((((((((((((((((((((((((/(((((((((((((((((
1035 &((((((((((((((((((((((//////////(((((((((((((((((((&%*. .&@@&#@&&@@&@@@*  ,&&@(((((((((((((((((((((((((((((((((((((((((((((((////
1036 &((((((((((((((((//////////(((((((((((((((((((((((#&&&/,,&&&%/*&&&&@&&&&&&*,@@&&((((((((((((((((/(((((((/(((((((/((((/////((((((((
1037 &((((((((((//////////(((((((((((((((((((((((((((((@@@&%&&&&#/&&&&&&&&&&&&&&@&@%(((((((((((((((/(((((((((((//////((((((((((((((((
1038 &((((///////////(((((((((((((((((((((((((((((((((#@@&&#///,,,^/#%%(#(////(/(/&@@@(((((((((((((((/(((///////(((((((((((((((((((((((
1039 &////////((((((((((((((((((((((((((((((((((((((((#@@&&&&&*(^/^/&#%%%%&%&&%&&&&&@@/((((((((((////////((((((((((((((((((((((((//////
1040 &///((((((((((((((((((((((((((((((((((((((((((((((@&&&&&&/(***(&&&&&&&&@&&&&&&&@%(///////////(/(((((((((((((((((((((//////////////
1041 &(((((((((((((((((((((((((((((((((((((((((((((*(. #@@@&&&/////%&&&&&&&&/&&&&&&&%.,*(.#///((((((((((((((((((((/////////////////////
1042 ##((((((((((((((((((((((((((((((((((((((((((((#.**(@&@...*@@@/.(%&&&&@@@&,.,&@@&**..((((((((((((((((((////(((#(///////////////////
1043 #((((((((((((((((((((((((((((((((((((((((((((((/*.,@&&/*,....*,/...^/*....,/&&@(..//(((((((((((//////////((%%%(%&/////////////////
1044 &(((((((((((((((((((((((((((((((((((((((((((((((#,.@%/..^^/*,.,.......,//*..*%@/.#/((((/////////////(((###%%%%%#%%%%//////////////
1045 &(((((((((((((((((((((((((((((((((((((((((((//////(@#/.    ............     .(&&(*//////////////////%#(#%%%&##&%#/////////////////
1046 /*((((((((((((((((((((((((((((((((((((////////(///(#&%(..........*./..........%&&#//////////////////#(#//%(((%(.#%%%&//////////////
1047 &(((((((((((((((((((((((((((((/////((((((//////////(&%(,.........,/(,......%/%&&///////////////////(##%%#(##%&#/#/////////////////
1048 &(((((((((((((((((((((((///(/(((((((////////////////@%((#%...%%%#(###.../@@@/#%@///////////////////%%(*(#%*,%(%#(/////////////((((
1049 &((((((((((((((((/(((((((((((((////////////////((///&%/((#@@@...,*,,.(@@@@@@(/%&///////////////////&(#%%(%(##(#/////////(((((((///
1050 &(((((((((((((((((((((((((//////////////////////////(&///#@@@@(*(/(*(@@@@@@&#/%#////////////////////#%&%(%.(#/(////(((((//////////
1051 &(((((((((((((((((((((///////////////////////////////&(/((@@@%&*****,&#%@@@%&/#(/////////////////////((##/*#%%(((/////////////////
1052 &(((((((/(((((((/////////////////////////////////////#(/#/%&&&,/&%.&%#(%@@@&@(((&&&&&(/////////(((////(%###%*#////////////////////
1053 &((((((((((((/////////////////////////////////////////(/#(%@,....,(,..,/(##&&&#&&&&&#&&((((((/////////(###%/%/////////////////////
1054 %(((((((///////////////////////////////////////%&&&&&&&&&&&#  ..,(,^/..,&&&&&&&&&&&&&&&&(//////////////#(#%%//////////////////////
1055 /*(((///////////////////////////////////////(&&((&&&&&&&%#(/#&&&&(%&%*&&&&&&&&&&&&&&&&&&&&/////////////(,##%(//////////////////////
1056 %///////////////////////////////////////(&&&&&&&&&&&&&&&&&&&&&&(%&&&&%(&&&&//&&&&%&&&&&&&#////////////&%#%&///////////////////////
1057 %/////////////(///////////////////////&&&&&&&&&&&&&&&&&&&&&&&&(%&&&&&&&&&%&&&&&&@@&&&&&%%&(//////////#%&#%#///////////////////////
1058 %(////////((///////////////////////(&//#&&&&&&&&&&&(&&&&&&&&&/&&&&&&&&&&&&%//%&&&@&&&&&&/(&/////////(&&&###///////////////////////
1059 %(///((((////////////////////////&&/%&&&&&&&&&&&@@&@&&&&&&&#&&&&&&&&&&&&&&&&&%#&&&@&&&&&&/(&///////(&&&&##%///////////////////////
1060 %((((/////////////////////////(&&(&&&&&&&&&&&@(////&&&&&&&(%&&&&&&&&&&&(/&&&&&/%#&&&@&&&&&%(&//////&(&&&(#%///////////////////////
1061 %#//////((//////////////////&&&&&&&&&&&&&&&(//////%&&&&&(&&&&&&&&&&&&&&&&&&&&&////##&&&&&&&%%&////(%%&&&&#%///////////////////////
1062 %#/(((///////////////////#&&%&&&&&&&&&&%////////((&&&/%%/&&&&&&&&&&&&&&&&&&&&&&&&&&&&%&#&&&&%&&///&/&&&&&&%///////////////////////
1063 %#////////////////////(&&%%&&&&&&&&&%///////(((((&#%&&%((&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/(&&&&&&&&#(//////////////////////
1064 #%//////////////////&&&&&&&&#&&&&(//////(((//////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&%&#&&&&&&&#(//////////////////////
1065 #%///////////////(&&&&&&&&&&&&(/////(((//////////#&&&&&&&&&&&%///(.......(*^/(#&&&&&&&&&&&&&&&&&@&&%&&&&&&##//////////////////////
1066 #%///////////////(&&&&&%#&&(/////((////////////////&&#**,,****^//..........,*(##(#%////(@&&&&&%&&&&%&&&&&%&#//////////////////////
1067 #%////////////////&&&&&//&%//((///////////////////////%(///((**...................#//////%&&&&&&%%&&&&&&&%&(//////////////////////
1068 #%////////////////(&&&&&#/&%///////////////////////////(*((/***...................(////////&&&&&%#&&&&&%#&&///////////////////////
1069 #&/////////////////%&&&&&%#&(/////////////////////////////^/.*.***..............*%///////////%&&&#&&&&&%&%////////////////////////
1070 #&//////////////////%&&&&&%&&///////////////////////////#,&/.*,...**...........(%//////////////#((#&&&&%//////////////////////////
1071 (&///////////////////%&&&&&&&&////////////////////////////.,,.............*(./,(%////////////////%%###////////////////////////////
1072 (%////////////////////(&&&&&&&#//////////////////////////% ............*,.(..**(#/////////////////#%//////////////////////////////
1073 (%//////////////////////%&&&&&&////////////////////////#*. ...........(*..//././#/////////////////(///////////////////////////////
1074 (%///////////////////////(&&&&&&////////////////////(/.   .....................*%/////////////////(///////////////////////////////
1075 (%/////////////////////////%&&&&&/////////////////#.@&........................,*(/////////////////#///////////////////////////////
1076 (%//////////////////////////(&&&&&////(%/..,(,.#.   .&%...............*.......,**(////////////////////////////////////////////////
1077 (%////////////////////////////@&@//(...*#(#&&@%.*  ...#&............ *,.......,*.&////////////////////////////////////////////////
1078 (%//////////////////////////////*... .,,... .*&@&%,....#@.....................*.@%*///////////////////////////////////////////////
1079 /*//////////////////////////////^**....,,***.,,&&&&&&,..&@%..................,%%....#////////////////////////////////////////////(
1080 /#///////////////////////////////#%#/**,,#&@#&/&&&,.&&&&%@@@&...............&&.... ..%(//////////////////////////////////////////(
1081 /(//////////////////////////////&@&&&%%@%.@&&%,&%&&&&&&&&*&&&@@&,.......*&@@,.../&&&&&&&&////////////////////////////////////////(
1082 /(////////////////////////////(%&&&&///#@*%&&&&*&@@@@@&%&&&&&&###&&&&&&(#%&&#&&&&&(.&&&##(,./////////////////////////////////////(
1083 /////////////////////////////(&%&&#///%&&&&&&&&&&&&&&&&@@@@@@@##&(#&%%&##&&&&##&&&&&&(&@@%////////////////////////////////////////
1084 /////////////////////////////&&#&(///&&&&&&&&&&&&&&&&&&&&&&&&&&&&%&&@#@@&@@@@@@@&@@&@&&&&&#///////////////////////////////////////
1085 ////////////////////////////%&@&(//#&&&&&&&&&&&&%&&&&&&&&&&&&&&%/%&&&/&&&&&&&@&&&&&&&&&&&&&%//////////////////////////////////////
1086 ////////////////////////////&&&&(#/&&&&&&&&&&&&&&&&&&&&&&&&&*#&&%&&&@@%#&%&&&&&&&&&&&&&&&&&&%////////////////////////////////////(
1087 ///////////////////////////%&&&//%@%#&&&&&&&&&&&&&&&&&&&(&&@@&&%&&&&&&@&%#&&&&&&&&&&&&&(/&&&&#///////////////////////////////////(
1088 ///////////////////////////@&&(//&&&&&&&(*@&&&&&&&,%&#&&@@@&&&&&&&&@&&&&@&%/&&&&&&&&&&&///&&&&///////////////////////////////////(
1089 //////////////////////////(&&&//%&&&&&&&&&&&&@@@@@@@@@&&&@//(%&%&&&&&&&&&&@@&%&&&&&&&&#////&&&&//////////////////////////////////#
1090 //////////////////////////#&&&//&&&&&&&&&&&&&&&&&&&&&&&&&&//////&&&&&&&&&&&&&@&#*&&&&&&/////&&&%/////////////////////////////////#
1091 (/////////////////////////%&&&//&&&&&&&&&&&&&&&&&&&&&&&&&&///////&&&&&&&&&&&&&&&@&%&&&&&////&&&&/////////////////////////////////#
1092 #/////////////////////////&&&&/#&&&&&&&&&&&&&&&&&&&&&&&&&(///////%&&&&&&&&&&&&&&&&&@&%%#*///(&&&&////////////////////////////////%
1093 /*/////////////////////////&&&&(%&&&&&&&&&&&&&&&&&&&&&&&&&/////////&&&&&&&&&&&&&&&&&&&&&&&%(##&@@&@@@@@@&&&&&&&%#///////////////#&%*/
1094 
1095 // ******** DEVIL CHICKS *********
1096 
1097 pragma solidity ^0.8.10;
1098 
1099 contract DevilChicks is Ownable, ERC721B {
1100     using Strings for uint256;
1101 
1102     uint256 private constant MAX_MINT = 2666;
1103     uint256 private constant MINT_PRICE = 0.02 ether;
1104     uint256 private constant T_MINT = 10;
1105     uint256 private _available;
1106     
1107     string private _contractURI;
1108     string private _baseURI;
1109     string private _notRevealedURI = "ipfs://QmUvCeboAPHDj5magQddFj9Z5mKb4yEzwBb8Q5qpkX84jj";
1110     string private _baseExtension = ".json";
1111     
1112     address private _vaultAddress = 0x94FAeC8839C37dA88b495243b85A75d06bdD6dab;
1113 
1114     bool private saleActive;
1115     bool private revealed;
1116    
1117     constructor() ERC721B("Devil Chicks", "DVLCKS") {
1118         _owners.push(address(0));
1119     }
1120     
1121     function mint(uint256 _amount) external payable {
1122         require(saleActive, "SALE_CLOSED");
1123         require(_amount * MINT_PRICE <= msg.value, "INSUFFICIENT_ETH");
1124         require(_amount <= T_MINT, "MAX_AMOUNT_PER_MINT");
1125         require(_amount <= _available, "MAX_SALE_SUPPLY");
1126 
1127         for(uint256 i = 0; i < _amount; i++) {
1128             _safeMint(msg.sender, _owners.length);
1129         }
1130 
1131         _available -= _amount;
1132     } 
1133 
1134     function setVaultAddress(address addr) external onlyOwner {
1135         _vaultAddress = addr;
1136     }
1137 
1138     function setBaseURI(string memory URI) external onlyOwner {
1139         _baseURI = URI;
1140     }
1141 
1142     function setNotRevealURI(string memory URI) external onlyOwner {
1143         _notRevealedURI = URI;
1144     }
1145 
1146     function setBaseExtension(string memory extension) external onlyOwner { 
1147         _baseExtension = extension;
1148     }
1149 
1150     function setReserve(uint256 reserve) external onlyOwner {
1151         _available = MAX_MINT - reserve - _owners.length + 1;
1152     }
1153     
1154     function setContractURI(string calldata URI) external onlyOwner {
1155         _contractURI = URI;
1156     }
1157     
1158     function totalSupply() external view returns (uint256) {
1159         return _owners.length - 1;
1160     }
1161 
1162     function contractURI() external view returns (string memory) {
1163         return _contractURI;
1164     } 
1165 
1166     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1167         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1168 
1169         if (!revealed) {
1170             return _notRevealedURI;
1171         }
1172         
1173         return string(abi.encodePacked(_baseURI, tokenId.toString(), _baseExtension));    
1174     }
1175 
1176 // admin commands
1177     function gift(address[] calldata receivers) external onlyOwner {
1178         require(receivers.length + _owners.length - 1 <= MAX_MINT, "MAX_MINT");
1179         
1180         for (uint256 i = 0; i < receivers.length; i++) {
1181             _safeMint(receivers[i], _owners.length);
1182         }
1183 
1184         _available = _available < receivers.length ? 0 : _available - receivers.length;
1185     }
1186 
1187     function switchSale() external onlyOwner {
1188         saleActive = !saleActive;
1189     }
1190 
1191     function reveal() external onlyOwner {
1192         revealed = !revealed;
1193     }
1194 
1195     function withdraw() external onlyOwner {
1196         (bool success, ) = payable(_vaultAddress).call{value: address(this).balance}("");
1197         require(success);
1198     }
1199 }