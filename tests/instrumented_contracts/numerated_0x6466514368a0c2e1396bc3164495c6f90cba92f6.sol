1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
72 
73 
74 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Enumerable is IERC721 {
538     /**
539      * @dev Returns the total amount of tokens stored by the contract.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
545      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
546      */
547     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
548 
549     /**
550      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
551      * Use along with {totalSupply} to enumerate all tokens.
552      */
553     function tokenByIndex(uint256 index) external view returns (uint256);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Metadata is IERC721 {
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 // File: @openzeppelin/contracts/utils/Context.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Provides information about the current execution context, including the
594  * sender of the transaction and its data. While these are generally available
595  * via msg.sender and msg.data, they should not be accessed in such a direct
596  * manner, since when dealing with meta-transactions the account sending and
597  * paying for execution may not be the actual sender (as far as an application
598  * is concerned).
599  *
600  * This contract is only required for intermediate, library-like contracts.
601  */
602 abstract contract Context {
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 
622 
623 
624 
625 
626 /**
627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
628  * the Metadata extension, but not including the Enumerable extension, which is available separately as
629  * {ERC721Enumerable}.
630  */
631 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
632     using Address for address;
633     using Strings for uint256;
634 
635     // Token name
636     string private _name;
637 
638     // Token symbol
639     string private _symbol;
640 
641     // Mapping from token ID to owner address
642     mapping(uint256 => address) private _owners;
643 
644     // Mapping owner address to token count
645     mapping(address => uint256) private _balances;
646 
647     // Mapping from token ID to approved address
648     mapping(uint256 => address) private _tokenApprovals;
649 
650     // Mapping from owner to operator approvals
651     mapping(address => mapping(address => bool)) private _operatorApprovals;
652 
653     /**
654      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
655      */
656     constructor(string memory name_, string memory symbol_) {
657         _name = name_;
658         _symbol = symbol_;
659     }
660 
661     /**
662      * @dev See {IERC165-supportsInterface}.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
665         return
666             interfaceId == type(IERC721).interfaceId ||
667             interfaceId == type(IERC721Metadata).interfaceId ||
668             super.supportsInterface(interfaceId);
669     }
670 
671     /**
672      * @dev See {IERC721-balanceOf}.
673      */
674     function balanceOf(address owner) public view virtual override returns (uint256) {
675         require(owner != address(0), "ERC721: balance query for the zero address");
676         return _balances[owner];
677     }
678 
679     /**
680      * @dev See {IERC721-ownerOf}.
681      */
682     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
683         address owner = _owners[tokenId];
684         require(owner != address(0), "ERC721: owner query for nonexistent token");
685         return owner;
686     }
687 
688     /**
689      * @dev See {IERC721Metadata-name}.
690      */
691     function name() public view virtual override returns (string memory) {
692         return _name;
693     }
694 
695     /**
696      * @dev See {IERC721Metadata-symbol}.
697      */
698     function symbol() public view virtual override returns (string memory) {
699         return _symbol;
700     }
701 
702     /**
703      * @dev See {IERC721Metadata-tokenURI}.
704      */
705     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
706         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
707 
708         string memory baseURI = _baseURI();
709         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
710     }
711 
712     /**
713      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
714      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
715      * by default, can be overriden in child contracts.
716      */
717     function _baseURI() internal view virtual returns (string memory) {
718         return "";
719     }
720 
721     /**
722      * @dev See {IERC721-approve}.
723      */
724     function approve(address to, uint256 tokenId) public virtual override {
725         address owner = ERC721.ownerOf(tokenId);
726         require(to != owner, "ERC721: approval to current owner");
727 
728         require(
729             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
730             "ERC721: approve caller is not owner nor approved for all"
731         );
732 
733         _approve(to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-getApproved}.
738      */
739     function getApproved(uint256 tokenId) public view virtual override returns (address) {
740         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
741 
742         return _tokenApprovals[tokenId];
743     }
744 
745     /**
746      * @dev See {IERC721-setApprovalForAll}.
747      */
748     function setApprovalForAll(address operator, bool approved) public virtual override {
749         _setApprovalForAll(_msgSender(), operator, approved);
750     }
751 
752     /**
753      * @dev See {IERC721-isApprovedForAll}.
754      */
755     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
756         return _operatorApprovals[owner][operator];
757     }
758 
759     /**
760      * @dev See {IERC721-transferFrom}.
761      */
762     function transferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         //solhint-disable-next-line max-line-length
768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
769 
770         _transfer(from, to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) public virtual override {
781         safeTransferFrom(from, to, tokenId, "");
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) public virtual override {
793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
794         _safeTransfer(from, to, tokenId, _data);
795     }
796 
797     /**
798      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
799      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
800      *
801      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
802      *
803      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
804      * implement alternative mechanisms to perform token transfer, such as signature-based.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must exist and be owned by `from`.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeTransfer(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) internal virtual {
821         _transfer(from, to, tokenId);
822         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
823     }
824 
825     /**
826      * @dev Returns whether `tokenId` exists.
827      *
828      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
829      *
830      * Tokens start existing when they are minted (`_mint`),
831      * and stop existing when they are burned (`_burn`).
832      */
833     function _exists(uint256 tokenId) internal view virtual returns (bool) {
834         return _owners[tokenId] != address(0);
835     }
836 
837     /**
838      * @dev Returns whether `spender` is allowed to manage `tokenId`.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      */
844     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
845         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
846         address owner = ERC721.ownerOf(tokenId);
847         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
848     }
849 
850     /**
851      * @dev Safely mints `tokenId` and transfers it to `to`.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _safeMint(address to, uint256 tokenId) internal virtual {
861         _safeMint(to, tokenId, "");
862     }
863 
864     /**
865      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
866      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
867      */
868     function _safeMint(
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) internal virtual {
873         _mint(to, tokenId);
874         require(
875             _checkOnERC721Received(address(0), to, tokenId, _data),
876             "ERC721: transfer to non ERC721Receiver implementer"
877         );
878     }
879 
880     /**
881      * @dev Mints `tokenId` and transfers it to `to`.
882      *
883      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
884      *
885      * Requirements:
886      *
887      * - `tokenId` must not exist.
888      * - `to` cannot be the zero address.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _mint(address to, uint256 tokenId) internal virtual {
893         require(to != address(0), "ERC721: mint to the zero address");
894         require(!_exists(tokenId), "ERC721: token already minted");
895 
896         _beforeTokenTransfer(address(0), to, tokenId);
897 
898         _balances[to] += 1;
899         _owners[tokenId] = to;
900 
901         emit Transfer(address(0), to, tokenId);
902     }
903 
904     /**
905      * @dev Destroys `tokenId`.
906      * The approval is cleared when the token is burned.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _burn(uint256 tokenId) internal virtual {
915         address owner = ERC721.ownerOf(tokenId);
916 
917         _beforeTokenTransfer(owner, address(0), tokenId);
918 
919         // Clear approvals
920         _approve(address(0), tokenId);
921 
922         _balances[owner] -= 1;
923         delete _owners[tokenId];
924 
925         emit Transfer(owner, address(0), tokenId);
926     }
927 
928     /**
929      * @dev Transfers `tokenId` from `from` to `to`.
930      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
931      *
932      * Requirements:
933      *
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must be owned by `from`.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _transfer(
940         address from,
941         address to,
942         uint256 tokenId
943     ) internal virtual {
944         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
945         require(to != address(0), "ERC721: transfer to the zero address");
946 
947         _beforeTokenTransfer(from, to, tokenId);
948 
949         // Clear approvals from the previous owner
950         _approve(address(0), tokenId);
951 
952         _balances[from] -= 1;
953         _balances[to] += 1;
954         _owners[tokenId] = to;
955 
956         emit Transfer(from, to, tokenId);
957     }
958 
959     /**
960      * @dev Approve `to` to operate on `tokenId`
961      *
962      * Emits a {Approval} event.
963      */
964     function _approve(address to, uint256 tokenId) internal virtual {
965         _tokenApprovals[tokenId] = to;
966         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
967     }
968 
969     /**
970      * @dev Approve `operator` to operate on all of `owner` tokens
971      *
972      * Emits a {ApprovalForAll} event.
973      */
974     function _setApprovalForAll(
975         address owner,
976         address operator,
977         bool approved
978     ) internal virtual {
979         require(owner != operator, "ERC721: approve to caller");
980         _operatorApprovals[owner][operator] = approved;
981         emit ApprovalForAll(owner, operator, approved);
982     }
983 
984     /**
985      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
986      * The call is not executed if the target address is not a contract.
987      *
988      * @param from address representing the previous owner of the given token ID
989      * @param to target address that will receive the tokens
990      * @param tokenId uint256 ID of the token to be transferred
991      * @param _data bytes optional data to send along with the call
992      * @return bool whether the call correctly returned the expected magic value
993      */
994     function _checkOnERC721Received(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) private returns (bool) {
1000         if (to.isContract()) {
1001             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1002                 return retval == IERC721Receiver.onERC721Received.selector;
1003             } catch (bytes memory reason) {
1004                 if (reason.length == 0) {
1005                     revert("ERC721: transfer to non ERC721Receiver implementer");
1006                 } else {
1007                     assembly {
1008                         revert(add(32, reason), mload(reason))
1009                     }
1010                 }
1011             }
1012         } else {
1013             return true;
1014         }
1015     }
1016 
1017     /**
1018      * @dev Hook that is called before any token transfer. This includes minting
1019      * and burning.
1020      *
1021      * Calling conditions:
1022      *
1023      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1024      * transferred to `to`.
1025      * - When `from` is zero, `tokenId` will be minted for `to`.
1026      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1027      * - `from` and `to` are never both zero.
1028      *
1029      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1030      */
1031     function _beforeTokenTransfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {}
1036 }
1037 
1038 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 
1046 
1047 /**
1048  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1049  * enumerability of all the token ids in the contract as well as all token ids owned by each
1050  * account.
1051  */
1052 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1053     // Mapping from owner to list of owned token IDs
1054     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1055 
1056     // Mapping from token ID to index of the owner tokens list
1057     mapping(uint256 => uint256) private _ownedTokensIndex;
1058 
1059     // Array with all token ids, used for enumeration
1060     uint256[] private _allTokens;
1061 
1062     // Mapping from token id to position in the allTokens array
1063     mapping(uint256 => uint256) private _allTokensIndex;
1064 
1065     /**
1066      * @dev See {IERC165-supportsInterface}.
1067      */
1068     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1069         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1074      */
1075     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1076         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1077         return _ownedTokens[owner][index];
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-totalSupply}.
1082      */
1083     function totalSupply() public view virtual override returns (uint256) {
1084         return _allTokens.length;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Enumerable-tokenByIndex}.
1089      */
1090     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1091         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1092         return _allTokens[index];
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` cannot be the zero address.
1106      * - `to` cannot be the zero address.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _beforeTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual override {
1115         super._beforeTokenTransfer(from, to, tokenId);
1116 
1117         if (from == address(0)) {
1118             _addTokenToAllTokensEnumeration(tokenId);
1119         } else if (from != to) {
1120             _removeTokenFromOwnerEnumeration(from, tokenId);
1121         }
1122         if (to == address(0)) {
1123             _removeTokenFromAllTokensEnumeration(tokenId);
1124         } else if (to != from) {
1125             _addTokenToOwnerEnumeration(to, tokenId);
1126         }
1127     }
1128 
1129     /**
1130      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1131      * @param to address representing the new owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1133      */
1134     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1135         uint256 length = ERC721.balanceOf(to);
1136         _ownedTokens[to][length] = tokenId;
1137         _ownedTokensIndex[tokenId] = length;
1138     }
1139 
1140     /**
1141      * @dev Private function to add a token to this extension's token tracking data structures.
1142      * @param tokenId uint256 ID of the token to be added to the tokens list
1143      */
1144     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1145         _allTokensIndex[tokenId] = _allTokens.length;
1146         _allTokens.push(tokenId);
1147     }
1148 
1149     /**
1150      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1151      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1152      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1153      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1154      * @param from address representing the previous owner of the given token ID
1155      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1156      */
1157     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1158         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1159         // then delete the last slot (swap and pop).
1160 
1161         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1162         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1163 
1164         // When the token to delete is the last token, the swap operation is unnecessary
1165         if (tokenIndex != lastTokenIndex) {
1166             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1167 
1168             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1169             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1170         }
1171 
1172         // This also deletes the contents at the last position of the array
1173         delete _ownedTokensIndex[tokenId];
1174         delete _ownedTokens[from][lastTokenIndex];
1175     }
1176 
1177     /**
1178      * @dev Private function to remove a token from this extension's token tracking data structures.
1179      * This has O(1) time complexity, but alters the order of the _allTokens array.
1180      * @param tokenId uint256 ID of the token to be removed from the tokens list
1181      */
1182     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1183         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1184         // then delete the last slot (swap and pop).
1185 
1186         uint256 lastTokenIndex = _allTokens.length - 1;
1187         uint256 tokenIndex = _allTokensIndex[tokenId];
1188 
1189         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1190         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1191         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1192         uint256 lastTokenId = _allTokens[lastTokenIndex];
1193 
1194         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1195         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1196 
1197         // This also deletes the contents at the last position of the array
1198         delete _allTokensIndex[tokenId];
1199         _allTokens.pop();
1200     }
1201 }
1202 
1203 // File: @openzeppelin/contracts/access/Ownable.sol
1204 
1205 
1206 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 
1211 /**
1212  * @dev Contract module which provides a basic access control mechanism, where
1213  * there is an account (an owner) that can be granted exclusive access to
1214  * specific functions.
1215  *
1216  * By default, the owner account will be the one that deploys the contract. This
1217  * can later be changed with {transferOwnership}.
1218  *
1219  * This module is used through inheritance. It will make available the modifier
1220  * `onlyOwner`, which can be applied to your functions to restrict their use to
1221  * the owner.
1222  */
1223 abstract contract Ownable is Context {
1224     address private _owner;
1225 
1226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1227 
1228     /**
1229      * @dev Initializes the contract setting the deployer as the initial owner.
1230      */
1231     constructor() {
1232         _transferOwnership(_msgSender());
1233     }
1234 
1235     /**
1236      * @dev Returns the address of the current owner.
1237      */
1238     function owner() public view virtual returns (address) {
1239         return _owner;
1240     }
1241 
1242     /**
1243      * @dev Throws if called by any account other than the owner.
1244      */
1245     modifier onlyOwner() {
1246         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1247         _;
1248     }
1249 
1250     /**
1251      * @dev Leaves the contract without owner. It will not be possible to call
1252      * `onlyOwner` functions anymore. Can only be called by the current owner.
1253      *
1254      * NOTE: Renouncing ownership will leave the contract without an owner,
1255      * thereby removing any functionality that is only available to the owner.
1256      */
1257     function renounceOwnership() public virtual onlyOwner {
1258         _transferOwnership(address(0));
1259     }
1260 
1261     /**
1262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1263      * Can only be called by the current owner.
1264      */
1265     function transferOwnership(address newOwner) public virtual onlyOwner {
1266         require(newOwner != address(0), "Ownable: new owner is the zero address");
1267         _transferOwnership(newOwner);
1268     }
1269 
1270     /**
1271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1272      * Internal function without access restriction.
1273      */
1274     function _transferOwnership(address newOwner) internal virtual {
1275         address oldOwner = _owner;
1276         _owner = newOwner;
1277         emit OwnershipTransferred(oldOwner, newOwner);
1278     }
1279 }
1280 
1281 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1282 
1283 
1284 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 /**
1289  * @dev Contract module that helps prevent reentrant calls to a function.
1290  *
1291  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1292  * available, which can be applied to functions to make sure there are no nested
1293  * (reentrant) calls to them.
1294  *
1295  * Note that because there is a single `nonReentrant` guard, functions marked as
1296  * `nonReentrant` may not call one another. This can be worked around by making
1297  * those functions `private`, and then adding `external` `nonReentrant` entry
1298  * points to them.
1299  *
1300  * TIP: If you would like to learn more about reentrancy and alternative ways
1301  * to protect against it, check out our blog post
1302  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1303  */
1304 abstract contract ReentrancyGuard {
1305     // Booleans are more expensive than uint256 or any type that takes up a full
1306     // word because each write operation emits an extra SLOAD to first read the
1307     // slot's contents, replace the bits taken up by the boolean, and then write
1308     // back. This is the compiler's defense against contract upgrades and
1309     // pointer aliasing, and it cannot be disabled.
1310 
1311     // The values being non-zero value makes deployment a bit more expensive,
1312     // but in exchange the refund on every call to nonReentrant will be lower in
1313     // amount. Since refunds are capped to a percentage of the total
1314     // transaction's gas, it is best to keep them low in cases like this one, to
1315     // increase the likelihood of the full refund coming into effect.
1316     uint256 private constant _NOT_ENTERED = 1;
1317     uint256 private constant _ENTERED = 2;
1318 
1319     uint256 private _status;
1320 
1321     constructor() {
1322         _status = _NOT_ENTERED;
1323     }
1324 
1325     /**
1326      * @dev Prevents a contract from calling itself, directly or indirectly.
1327      * Calling a `nonReentrant` function from another `nonReentrant`
1328      * function is not supported. It is possible to prevent this from happening
1329      * by making the `nonReentrant` function external, and making it call a
1330      * `private` function that does the actual work.
1331      */
1332     modifier nonReentrant() {
1333         // On the first call to nonReentrant, _notEntered will be true
1334         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1335 
1336         // Any calls to nonReentrant after this point will fail
1337         _status = _ENTERED;
1338 
1339         _;
1340 
1341         // By storing the original value once again, a refund is triggered (see
1342         // https://eips.ethereum.org/EIPS/eip-2200)
1343         _status = _NOT_ENTERED;
1344     }
1345 }
1346 
1347 // File: contracts/Tank.sol
1348 
1349 
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 
1355 
1356 /// [MIT License]
1357 /// @title Base64
1358 /// @notice Provides a function for encoding some bytes in base64
1359 /// @author Brecht Devos <brecht@loopring.org>
1360 library Base64 {
1361     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1362 
1363     /// @notice Encodes some bytes to the base64 representation
1364     function encode(bytes memory data) internal pure returns (string memory) {
1365         uint256 len = data.length;
1366         if (len == 0) return "";
1367 
1368         // multiply by 4/3 rounded up
1369         uint256 encodedLen = 4 * ((len + 2) / 3);
1370 
1371         // Add some extra buffer at the end
1372         bytes memory result = new bytes(encodedLen + 32);
1373 
1374         bytes memory table = TABLE;
1375 
1376         assembly {
1377             let tablePtr := add(table, 1)
1378             let resultPtr := add(result, 32)
1379 
1380             for {
1381                 let i := 0
1382             } lt(i, len) {
1383 
1384             } {
1385                 i := add(i, 3)
1386                 let input := and(mload(add(data, i)), 0xffffff)
1387 
1388                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1389                 out := shl(8, out)
1390                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1391                 out := shl(8, out)
1392                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1393                 out := shl(8, out)
1394                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1395                 out := shl(224, out)
1396 
1397                 mstore(resultPtr, out)
1398 
1399                 resultPtr := add(resultPtr, 4)
1400             }
1401 
1402             switch mod(len, 3)
1403             case 1 {
1404                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1405             }
1406             case 2 {
1407                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1408             }
1409 
1410             mstore(result, encodedLen)
1411         }
1412 
1413         return string(result);
1414     }
1415 }
1416 
1417 /**
1418  * @title Fortress Arena Tank NFT contract
1419  * @author Atomrigs Lab 
1420  */
1421 
1422 interface ITankGene {
1423     function getSeed(uint _tokenId) external view returns (uint);
1424     function getBaseGenes(uint _tokenId) external view returns (uint[] memory);
1425     function getBaseGeneNames(uint _tokenId) external view returns (string[] memory);
1426     function getImgIdx(uint _tokenId) external view returns (string memory);
1427 }
1428 
1429 contract TankNFT is ERC721Enumerable, ReentrancyGuard, Ownable {
1430 
1431     enum State {
1432         Setup,
1433         PreMint,
1434         PublicMint,
1435         Finished
1436     }
1437 
1438     State public state;
1439     address private _tankGene;
1440     address private _signer;
1441     address private _receiver;
1442 
1443     bool public isPermanent;
1444     uint8 public constant FOUNDER_TANKS_COUNT = 120;
1445     uint8 public MAX_PRE_MULTI = 2; //4 for presale round2
1446     uint8 public constant MAX_PUBLIC_MULTI = 20;
1447     uint16 public MAX_PRE_ID = FOUNDER_TANKS_COUNT + 3200; 
1448     uint16 public MAX_PUBLIC_ID = FOUNDER_TANKS_COUNT + 3600; 
1449     uint16 public constant MAX_COUNT = 5000;
1450     uint16 private _publicTokenId = FOUNDER_TANKS_COUNT; 
1451     uint public MINTING_FEE = 0.1 * 10**18; //in wei
1452     string private _baseImgUrl = "";
1453 
1454     mapping (address => uint8) public freeClaims; //address => count
1455     mapping (address => uint8) public preMints; //address => count
1456 
1457     event Received(address caller, uint amount, string message);
1458     event BalanceWithdraw(address recipient, uint amount);
1459     event StateChanged(State _state);
1460     event SignerChanged(address signer);    
1461 
1462     constructor(address signer_, address receiver_, string memory baseImgUrl_) ERC721("Fortress-Arena NFT", "FortressTank") Ownable() {
1463         _signer = signer_;
1464         _receiver = receiver_;
1465         _baseImgUrl = baseImgUrl_;
1466         state = State.Setup;
1467     }
1468 
1469     fallback() external payable {
1470         emit Received(_msgSender(), msg.value, "Fallback was called");
1471     }
1472 
1473     receive() external payable {
1474         emit Received(_msgSender(), msg.value, "Fallback was called");
1475     }    
1476 
1477     function updateMaxPreMulti(uint8 _newMax) external onlyOwner { //in wei unit
1478         MAX_PRE_MULTI = _newMax;
1479     }
1480 
1481     function updateMintingFee(uint _feeAmount) external onlyOwner { //in wei unit
1482         MINTING_FEE = _feeAmount;
1483     }    
1484 
1485     function updateSigner(address signer_) external onlyOwner {
1486         require(!isPermanent, "TankNFT: contract is fixed");        
1487         _signer = signer_;
1488     }
1489 
1490     function getSigner() external view returns (address){
1491         return _signer;
1492     }
1493 
1494     function updateGene(address tankGene_) external onlyOwner {
1495         require(!isPermanent, "TankNFT: Gene contract is fixed");
1496         _tankGene = tankGene_;
1497     }
1498 
1499     function updateBaseImgUrl(string memory _url) external onlyOwner {
1500         require(!isPermanent, "TankNFT: All images are on ipfs");
1501         _baseImgUrl = _url;
1502     }
1503 
1504     function updateMaxPublicId(uint16 _newMax) external onlyOwner {
1505         require(_newMax >= _publicTokenId, "TankNFT: Can not set MAX_PUBLIC_ID lower than the current id");
1506         require(_newMax <= MAX_COUNT, "TankNFT: Can not set more than MAX_COUNT");
1507         MAX_PUBLIC_ID = _newMax;
1508     }
1509 
1510     function changeToPermanent() external onlyOwner {
1511         isPermanent = true;
1512     }
1513 
1514     function setStateToSetup() public onlyOwner {
1515         state = State.Setup;
1516     }
1517     
1518     function setStateToPreMint() public onlyOwner {
1519         state = State.PreMint;
1520     }
1521 
1522     function setStateToPublicMint() public onlyOwner {
1523         state = State.PublicMint;
1524     }
1525     
1526     function setStateToFinished() public onlyOwner {
1527         state = State.Finished;
1528     }
1529 
1530     function getCurrentPublicId() public view returns (uint16) {
1531         return _publicTokenId;
1532     }
1533 
1534     function getNextPublicId() private returns (uint16) {
1535         uint16 newTokenId = _publicTokenId + 1;
1536         if (_exists(newTokenId)) {
1537             while (newTokenId <= MAX_PUBLIC_ID) {
1538                 newTokenId += 1;
1539                 if (!_exists(newTokenId)) {
1540                     break;
1541                 }
1542             }
1543         }
1544         _publicTokenId = newTokenId;
1545         return newTokenId;
1546     }
1547 
1548     function safeMint(address _to, uint _tokenId) private returns (bool) {
1549         _safeMint(_to, _tokenId);
1550         return true;
1551     }
1552 
1553     function getBalance() public view returns (uint) {
1554         return address(this).balance;
1555     } 
1556 
1557     function withdraw() external onlyOwner { 
1558         uint amount = address(this).balance;
1559         (bool success, ) = _receiver.call{value: amount}("");
1560         require(success, "Failed to send Ether");
1561         emit BalanceWithdraw(_receiver, amount);
1562     }    
1563 
1564     function getHash(address this_, address sender_, string memory msg_) 
1565         public pure 
1566         returns (bytes32) {
1567         return keccak256(abi.encodePacked(this_, sender_, msg_));
1568     }
1569 
1570     function verifySig(bytes32 hash, uint8 v, bytes32 r, bytes32 s) 
1571         public view 
1572         returns (bool) {
1573         return ecrecover(hash, v, r, s) == _signer;
1574     }
1575 
1576     function freeClaim(uint8 v, bytes32 r, bytes32 s) external nonReentrant {
1577         require(state == State.PreMint || state == State.PublicMint, "TankNFT: State is not in PreMint or PublicMint");                
1578         require(_publicTokenId + 1 <= MAX_PUBLIC_ID, "TankNFT: Can not mint more than MAX_PUBLIC_ID");
1579         require(freeClaims[_msgSender()] == 0, "TankNFT: Already claimed");
1580 
1581         bytes32 hash = getHash(address(this), _msgSender(), "freeClaim");
1582         require(verifySig(hash, v, r, s), "TankNFT: Signer's sig does not match ");
1583 
1584         freeClaims[_msgSender()] = 1;
1585         require(safeMint(_msgSender(), getNextPublicId()), "TankNFT: minting failed");
1586     }
1587 
1588     function preMint(uint8 v, bytes32 r, bytes32 s, uint8 _count) external payable nonReentrant {
1589         require(state == State.PreMint, "TankNFT: State is not in PreMint");                
1590         require(_publicTokenId + _count <= MAX_PRE_ID, "TankNFT: Can not mint more than MAX_PRE_ID");        
1591         require(preMints[_msgSender()] + _count <=  MAX_PRE_MULTI, "TankNFT: Minting count exceeds more than allowed");
1592         require(MINTING_FEE * _count == msg.value, "TankNFT: Minting fee amounts does not match."); 
1593 
1594         bytes32 hash = getHash(address(this), _msgSender(), "preMint");
1595         require(verifySig(hash, v, r, s), "Signer's sig does not match ");
1596         for (uint i; i < _count; i++) {
1597             preMints[_msgSender()] += 1;
1598             require(safeMint(_msgSender(), getNextPublicId()), "TankNFT: minting failed");
1599         }
1600     }
1601 
1602     function publicMint(uint _count) external payable nonReentrant {
1603         require(state == State.PublicMint, "TankNFT: State is not in PublicMint");
1604         require(_count <= MAX_PUBLIC_MULTI, "TankNFT: Minting count exceeds more than allowed");
1605         require(_publicTokenId + _count <= MAX_PUBLIC_ID, "TankNFT: Can not mint more than MAX_PUBLIC_ID");
1606         require(MINTING_FEE * _count == msg.value, "TankNFT: Minting fee amounts does not match."); 
1607 
1608         for(uint i=0; i<_count; i++) {
1609             require(safeMint(_msgSender(), getNextPublicId()), "TankNFT: minting failed");
1610         }
1611     }
1612 
1613     function adminMint(uint[] calldata _tokenIds) external onlyOwner nonReentrant{
1614         for(uint i=0; i<_tokenIds.length; i++) {
1615             uint tokenId = _tokenIds[i];
1616             if (!_exists(tokenId)) {
1617                 require(tokenId > 0);
1618                 require(tokenId <= FOUNDER_TANKS_COUNT || tokenId > MAX_PUBLIC_ID, "TankNFT: id is out of range");
1619                 require(tokenId <= MAX_COUNT);
1620                 require(safeMint(_msgSender(), tokenId), "TankNFT: minting failed");
1621             }
1622         }
1623     }
1624 
1625     function adminMintTo(uint[] calldata _tokenIds, address[] calldata _tos) external onlyOwner nonReentrant {
1626         require(_tokenIds.length == _tos.length, "TankNFT: token count does not match recipient count");
1627         for(uint i=0; i<_tokenIds.length; i++) {
1628             uint tokenId = _tokenIds[i];
1629             if (!_exists(tokenId)) {
1630                 require(tokenId > 0);
1631                 require(tokenId <= FOUNDER_TANKS_COUNT || tokenId > MAX_PUBLIC_ID, "TankNFT: id is out of range");
1632                 require(tokenId <= MAX_COUNT);
1633                 require(safeMint(_tos[i], tokenId), "TankNFT: minting failed");
1634             }
1635         }
1636     }
1637 
1638     function transferBatch(uint[] calldata _tokenIds, address _to) external nonReentrant {
1639         for(uint i=0; i<_tokenIds.length; i++) {
1640             safeTransferFrom(_msgSender(), _to, _tokenIds[i]);
1641         }
1642     }
1643 
1644     function getSeed(uint _tokenId) public view onlyOwner returns (uint) {
1645         require(_exists(_tokenId), "TankNFT: TokenId not minted yet");
1646         ITankGene gene = ITankGene(_tankGene);
1647         return gene.getSeed(_tokenId);
1648     }
1649 
1650     function getBaseGenes(uint _tokenId) public view returns (uint[] memory) {
1651         require(_exists(_tokenId), "TankNFT: TokenId not minted yet");
1652         ITankGene gene = ITankGene(_tankGene);
1653         return gene.getBaseGenes(_tokenId);        
1654     }
1655 
1656     function getBaseGeneNames(uint _tokenId) public view returns (string[] memory) {
1657         require(_exists(_tokenId), "TankNFT: TokenId not minted yet");
1658         ITankGene gene = ITankGene(_tankGene);
1659         return gene.getBaseGeneNames(_tokenId);        
1660     }
1661 
1662     function getImgUrl(uint _tokenId) public view returns (string memory) {
1663         require(_exists(_tokenId), "TankNFT: TokenId not minted yet");
1664 
1665         return string(abi.encodePacked(_baseImgUrl, toString(_tokenId), '.gif'));
1666     }
1667 
1668     function getImgIdx(uint _tokenId) public view returns (string memory) {
1669         require(_exists(_tokenId), "TankNFT: TokenId not minted yet");
1670         ITankGene gene = ITankGene(_tankGene);
1671         return gene.getImgIdx(_tokenId);
1672     }
1673 
1674     function tokensOf(address _account) public view returns (uint[] memory) {
1675         uint[] memory tokenIds = new uint[] (balanceOf(_account));
1676         for (uint i; i<balanceOf(_account); i++) {
1677             tokenIds[i] = tokenOfOwnerByIndex(_account, i);
1678         }
1679         return tokenIds;
1680     }
1681    
1682     function tokenURI(uint _tokenId) override public view returns (string memory) {
1683         require(_exists(_tokenId), "TankNFT: TokenId not minted yet");
1684         string[] memory genes = getBaseGeneNames(_tokenId);
1685         string[15] memory parts;
1686 
1687         parts[0] = '[{"trait_type": "Race", "value": "';
1688         parts[1] = genes[0];
1689         parts[2] = '"}, {"trait_type": "Color", "value": "';
1690         parts[3] = genes[1];
1691         parts[4] = '"}, {"trait_type": "Material", "value": "';        
1692         parts[5] = genes[2];
1693         parts[6] = '"}, {"trait_type": "Class", "value": "';
1694         parts[7] = genes[3];
1695         parts[8] = '"}, {"trait_type": "Element", "value": "';
1696         parts[9] = genes[4];
1697         parts[10] = '"}, {"trait_type": "Generation", "value": "';
1698         parts[11] = genes[5];
1699         parts[12] = '"}, {"trait_type": "FounderTank", "value": "';
1700         parts[13] = genes[6];
1701         parts[14] = '"}]';
1702         
1703         string memory attrs = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
1704         attrs = string(abi.encodePacked(attrs, parts[7], parts[8], parts[9], parts[10]));
1705                 attrs = string(abi.encodePacked(attrs, parts[11], parts[12], parts[13], parts[14]));
1706         string memory description = "Fortress Arana Tank NFT(ERC721) is a necessity for playing Fortress-Arena. Users can not only get TANK Tokens(ERC20) by winning with their respective Tank-NFTs, but also create new tanks through combination. It is a great opportunity to increase your own asset while enjoying the newly reborn Fortress game with the blockchain.";
1707         string memory imgUrl = getImgUrl(_tokenId);
1708         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Fortress-Arena NFT #', toString(_tokenId), '", "attributes": ', attrs,', "description": "', description, '", "image": "', imgUrl, '"}'))));
1709         return string(abi.encodePacked('data:application/json;base64,', json));
1710     }
1711 
1712     function getMintingState() external view returns (uint8) {
1713         if (state == State.Setup) {
1714             return 0;
1715         } else if (state == State.PreMint && _publicTokenId < MAX_PUBLIC_ID ) {
1716             return 1;
1717         } else if (state == State.PublicMint && _publicTokenId < MAX_PUBLIC_ID ) {
1718             return 2;
1719         } else {
1720             return 3;
1721         }
1722     }
1723 
1724     function toString(uint256 value) internal pure returns (string memory) {
1725     // Inspired by OraclizeAPI's implementation - MIT license
1726     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1727 
1728         if (value == 0) {
1729             return "0";
1730         }
1731         uint256 temp = value;
1732         uint256 digits;
1733         while (temp != 0) {
1734             digits++;
1735             temp /= 10;
1736         }
1737         bytes memory buffer = new bytes(digits);
1738         while (value != 0) {
1739             digits -= 1;
1740             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1741             value /= 10;
1742         }
1743         return string(buffer);
1744     }    
1745 }