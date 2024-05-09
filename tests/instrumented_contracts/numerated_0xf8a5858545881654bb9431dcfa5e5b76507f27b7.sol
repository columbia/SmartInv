1 //pxMAYCpastel - A community driven project.  First 1,000 free. - pxConcord
2 
3 // SPDX-License-Identifier: MIT
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 //
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Address.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      */
102     function isContract(address account) internal view returns (bool) {
103         // This method relies on extcodesize, which returns 0 for contracts in
104         // construction, since the code is only stored at the end of the
105         // constructor execution.
106 
107         uint256 size;
108         assembly {
109             size := extcodesize(account)
110         }
111         return size > 0;
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         (bool success, ) = recipient.call{value: amount}("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     /**
138      * @dev Performs a Solidity function call using a low level `call`. A
139      * plain `call` is an unsafe replacement for a function call: use this
140      * function instead.
141      *
142      * If `target` reverts with a revert reason, it is bubbled up by this
143      * function (like regular Solidity function calls).
144      *
145      * Returns the raw returned data. To convert to the expected return value,
146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
147      *
148      * Requirements:
149      *
150      * - `target` must be a contract.
151      * - calling `target` with `data` must not revert.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
161      * `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but also transferring `value` wei to `target`.
176      *
177      * Requirements:
178      *
179      * - the calling contract must have an ETH balance of at least `value`.
180      * - the called Solidity function must be `payable`.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(address(this).balance >= value, "Address: insufficient balance for call");
205         require(isContract(target), "Address: call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.call{value: value}(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
218         return functionStaticCall(target, data, "Address: low-level static call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal view returns (bytes memory) {
232         require(isContract(target), "Address: static call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.staticcall(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(isContract(target), "Address: delegate call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.delegatecall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
267      * revert reason using the provided one.
268      *
269      * _Available since v4.3._
270      */
271     function verifyCallResult(
272         bool success,
273         bytes memory returndata,
274         string memory errorMessage
275     ) internal pure returns (bytes memory) {
276         if (success) {
277             return returndata;
278         } else {
279             // Look for revert reason and bubble it up if present
280             if (returndata.length > 0) {
281                 // The easiest way to bubble the revert reason is using memory via assembly
282 
283                 assembly {
284                     let returndata_size := mload(returndata)
285                     revert(add(32, returndata), returndata_size)
286                 }
287             } else {
288                 revert(errorMessage);
289             }
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @title ERC721 token receiver interface
303  * @dev Interface for any contract that wants to support safeTransfers
304  * from ERC721 asset contracts.
305  */
306 interface IERC721Receiver {
307     /**
308      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
309      * by `operator` from `from`, this function is called.
310      *
311      * It must return its Solidity selector to confirm the token transfer.
312      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
313      *
314      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
315      */
316     function onERC721Received(
317         address operator,
318         address from,
319         uint256 tokenId,
320         bytes calldata data
321     ) external returns (bytes4);
322 }
323 
324 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Interface of the ERC165 standard, as defined in the
333  * https://eips.ethereum.org/EIPS/eip-165[EIP].
334  *
335  * Implementers can declare support of contract interfaces, which can then be
336  * queried by others ({ERC165Checker}).
337  *
338  * For an implementation, see {ERC165}.
339  */
340 interface IERC165 {
341     /**
342      * @dev Returns true if this contract implements the interface defined by
343      * `interfaceId`. See the corresponding
344      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
345      * to learn more about how these ids are created.
346      *
347      * This function call must use less than 30 000 gas.
348      */
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 }
351 
352 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
364  * for the additional interface id that will be supported. For example:
365  *
366  * ```solidity
367  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
369  * }
370  * ```
371  *
372  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
373  */
374 abstract contract ERC165 is IERC165 {
375     /**
376      * @dev See {IERC165-supportsInterface}.
377      */
378     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379         return interfaceId == type(IERC165).interfaceId;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 
391 /**
392  * @dev Required interface of an ERC721 compliant contract.
393  */
394 interface IERC721 is IERC165 {
395     /**
396      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
397      */
398     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
399 
400     /**
401      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
402      */
403     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
407      */
408     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
409 
410     /**
411      * @dev Returns the number of tokens in ``owner``'s account.
412      */
413     function balanceOf(address owner) external view returns (uint256 balance);
414 
415     /**
416      * @dev Returns the owner of the `tokenId` token.
417      *
418      * Requirements:
419      *
420      * - `tokenId` must exist.
421      */
422     function ownerOf(uint256 tokenId) external view returns (address owner);
423 
424     /**
425      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
426      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Transfers `tokenId` token from `from` to `to`.
446      *
447      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must be owned by `from`.
454      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
455      *
456      * Emits a {Transfer} event.
457      */
458     function transferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) external;
463 
464     /**
465      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
466      * The approval is cleared when the token is transferred.
467      *
468      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
469      *
470      * Requirements:
471      *
472      * - The caller must own the token or be an approved operator.
473      * - `tokenId` must exist.
474      *
475      * Emits an {Approval} event.
476      */
477     function approve(address to, uint256 tokenId) external;
478 
479     /**
480      * @dev Returns the account approved for `tokenId` token.
481      *
482      * Requirements:
483      *
484      * - `tokenId` must exist.
485      */
486     function getApproved(uint256 tokenId) external view returns (address operator);
487 
488     /**
489      * @dev Approve or remove `operator` as an operator for the caller.
490      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
491      *
492      * Requirements:
493      *
494      * - The `operator` cannot be the caller.
495      *
496      * Emits an {ApprovalForAll} event.
497      */
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500     /**
501      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
502      *
503      * See {setApprovalForAll}
504      */
505     function isApprovedForAll(address owner, address operator) external view returns (bool);
506 
507     /**
508      * @dev Safely transfers `tokenId` token from `from` to `to`.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must exist and be owned by `from`.
515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
517      *
518      * Emits a {Transfer} event.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId,
524         bytes calldata data
525     ) external;
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
538  * @dev See https://eips.ethereum.org/EIPS/eip-721
539  */
540 interface IERC721Metadata is IERC721 {
541     /**
542      * @dev Returns the token collection name.
543      */
544     function name() external view returns (string memory);
545 
546     /**
547      * @dev Returns the token collection symbol.
548      */
549     function symbol() external view returns (string memory);
550 
551     /**
552      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
553      */
554     function tokenURI(uint256 tokenId) external view returns (string memory);
555 }
556 
557 // File: @openzeppelin/contracts/utils/Context.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Provides information about the current execution context, including the
566  * sender of the transaction and its data. While these are generally available
567  * via msg.sender and msg.data, they should not be accessed in such a direct
568  * manner, since when dealing with meta-transactions the account sending and
569  * paying for execution may not be the actual sender (as far as an application
570  * is concerned).
571  *
572  * This contract is only required for intermediate, library-like contracts.
573  */
574 abstract contract Context {
575     function _msgSender() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _msgData() internal view virtual returns (bytes calldata) {
580         return msg.data;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 
593 
594 
595 
596 
597 
598 /**
599  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
600  * the Metadata extension, but not including the Enumerable extension, which is available separately as
601  * {ERC721Enumerable}.
602  */
603 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
604     using Address for address;
605     using Strings for uint256;
606 
607     // Token name
608     string private _name;
609 
610     // Token symbol
611     string private _symbol;
612 
613     // Mapping from token ID to owner address
614     mapping(uint256 => address) private _owners;
615 
616     // Mapping owner address to token count
617     mapping(address => uint256) private _balances;
618 
619     // Mapping from token ID to approved address
620     mapping(uint256 => address) private _tokenApprovals;
621 
622     // Mapping from owner to operator approvals
623     mapping(address => mapping(address => bool)) private _operatorApprovals;
624 
625     /**
626      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
627      */
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631     }
632 
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
637         return
638             interfaceId == type(IERC721).interfaceId ||
639             interfaceId == type(IERC721Metadata).interfaceId ||
640             super.supportsInterface(interfaceId);
641     }
642 
643     /**
644      * @dev See {IERC721-balanceOf}.
645      */
646     function balanceOf(address owner) public view virtual override returns (uint256) {
647         require(owner != address(0), "ERC721: balance query for the zero address");
648         return _balances[owner];
649     }
650 
651     /**
652      * @dev See {IERC721-ownerOf}.
653      */
654     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
655         address owner = _owners[tokenId];
656         require(owner != address(0), "ERC721: owner query for nonexistent token");
657         return owner;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-name}.
662      */
663     function name() public view virtual override returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-symbol}.
669      */
670     function symbol() public view virtual override returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-tokenURI}.
676      */
677     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
678         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
679 
680         string memory baseURI = _baseURI();
681         
682         //return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
683           return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return "";
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(
703             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
704             "ERC721: approve caller is not owner nor approved for all"
705         );
706 
707         _approve(to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         _setApprovalForAll(_msgSender(), operator, approved);
724     }
725 
726     /**
727      * @dev See {IERC721-isApprovedForAll}.
728      */
729     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
730         return _operatorApprovals[owner][operator];
731     }
732 
733     /**
734      * @dev See {IERC721-transferFrom}.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         //solhint-disable-next-line max-line-length
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743 
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         safeTransferFrom(from, to, tokenId, "");
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) public virtual override {
767         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
768         _safeTransfer(from, to, tokenId, _data);
769     }
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
776      *
777      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
778      * implement alternative mechanisms to perform token transfer, such as signature-based.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must exist and be owned by `from`.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeTransfer(
790         address from,
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _transfer(from, to, tokenId);
796         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
797     }
798 
799     /**
800      * @dev Returns whether `tokenId` exists.
801      *
802      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
803      *
804      * Tokens start existing when they are minted (`_mint`),
805      * and stop existing when they are burned (`_burn`).
806      */
807     function _exists(uint256 tokenId) internal view virtual returns (bool) {
808         return _owners[tokenId] != address(0);
809     }
810 
811     /**
812      * @dev Returns whether `spender` is allowed to manage `tokenId`.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
819         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
820         address owner = ERC721.ownerOf(tokenId);
821         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
822     }
823 
824     /**
825      * @dev Safely mints `tokenId` and transfers it to `to`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _safeMint(address to, uint256 tokenId) internal virtual {
835         _safeMint(to, tokenId, "");
836     }
837 
838     /**
839      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
840      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
841      */
842     function _safeMint(
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _mint(to, tokenId);
848         require(
849             _checkOnERC721Received(address(0), to, tokenId, _data),
850             "ERC721: transfer to non ERC721Receiver implementer"
851         );
852     }
853 
854     /**
855      * @dev Mints `tokenId` and transfers it to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
858      *
859      * Requirements:
860      *
861      * - `tokenId` must not exist.
862      * - `to` cannot be the zero address.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 tokenId) internal virtual {
867         require(to != address(0), "ERC721: mint to the zero address");
868         require(!_exists(tokenId), "ERC721: token already minted");
869 
870         _beforeTokenTransfer(address(0), to, tokenId);
871 
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(address(0), to, tokenId);
876     }
877 
878     /**
879      * @dev Destroys `tokenId`.
880      * The approval is cleared when the token is burned.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _burn(uint256 tokenId) internal virtual {
889         address owner = ERC721.ownerOf(tokenId);
890 
891         _beforeTokenTransfer(owner, address(0), tokenId);
892 
893         // Clear approvals
894         _approve(address(0), tokenId);
895 
896         _balances[owner] -= 1;
897         delete _owners[tokenId];
898 
899         emit Transfer(owner, address(0), tokenId);
900     }
901 
902     /**
903      * @dev Transfers `tokenId` from `from` to `to`.
904      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
905      *
906      * Requirements:
907      *
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must be owned by `from`.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _transfer(
914         address from,
915         address to,
916         uint256 tokenId
917     ) internal virtual {
918         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
919         require(to != address(0), "ERC721: transfer to the zero address");
920 
921         _beforeTokenTransfer(from, to, tokenId);
922 
923         // Clear approvals from the previous owner
924         _approve(address(0), tokenId);
925 
926         _balances[from] -= 1;
927         _balances[to] += 1;
928         _owners[tokenId] = to;
929 
930         emit Transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev Approve `to` to operate on `tokenId`
935      *
936      * Emits a {Approval} event.
937      */
938     function _approve(address to, uint256 tokenId) internal virtual {
939         _tokenApprovals[tokenId] = to;
940         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
941     }
942 
943     /**
944      * @dev Approve `operator` to operate on all of `owner` tokens
945      *
946      * Emits a {ApprovalForAll} event.
947      */
948     function _setApprovalForAll(
949         address owner,
950         address operator,
951         bool approved
952     ) internal virtual {
953         require(owner != operator, "ERC721: approve to caller");
954         _operatorApprovals[owner][operator] = approved;
955         emit ApprovalForAll(owner, operator, approved);
956     }
957 
958     /**
959      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
960      * The call is not executed if the target address is not a contract.
961      *
962      * @param from address representing the previous owner of the given token ID
963      * @param to target address that will receive the tokens
964      * @param tokenId uint256 ID of the token to be transferred
965      * @param _data bytes optional data to send along with the call
966      * @return bool whether the call correctly returned the expected magic value
967      */
968     function _checkOnERC721Received(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) private returns (bool) {
974         if (to.isContract()) {
975             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
976                 return retval == IERC721Receiver.onERC721Received.selector;
977             } catch (bytes memory reason) {
978                 if (reason.length == 0) {
979                     revert("ERC721: transfer to non ERC721Receiver implementer");
980                 } else {
981                     assembly {
982                         revert(add(32, reason), mload(reason))
983                     }
984                 }
985             }
986         } else {
987             return true;
988         }
989     }
990 
991     /**
992      * @dev Hook that is called before any token transfer. This includes minting
993      * and burning.
994      *
995      * Calling conditions:
996      *
997      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
998      * transferred to `to`.
999      * - When `from` is zero, `tokenId` will be minted for `to`.
1000      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1001      * - `from` and `to` are never both zero.
1002      *
1003      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1004      */
1005     function _beforeTokenTransfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) internal virtual {}
1010 }
1011 
1012 // File: @openzeppelin/contracts/access/Ownable.sol
1013 
1014 
1015 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 
1020 /**
1021  * @dev Contract module which provides a basic access control mechanism, where
1022  * there is an account (an owner) that can be granted exclusive access to
1023  * specific functions.
1024  *
1025  * By default, the owner account will be the one that deploys the contract. This
1026  * can later be changed with {transferOwnership}.
1027  *
1028  * This module is used through inheritance. It will make available the modifier
1029  * `onlyOwner`, which can be applied to your functions to restrict their use to
1030  * the owner.
1031  */
1032 abstract contract Ownable is Context {
1033     address private _owner;
1034 
1035     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1036 
1037     /**
1038      * @dev Initializes the contract setting the deployer as the initial owner.
1039      */
1040     constructor() {
1041         _transferOwnership(_msgSender());
1042     }
1043 
1044     /**
1045      * @dev Returns the address of the current owner.
1046      */
1047     function owner() public view virtual returns (address) {
1048         return _owner;
1049     }
1050 
1051     /**
1052      * @dev Throws if called by any account other than the owner.
1053      */
1054     modifier onlyOwner() {
1055         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1056         _;
1057     }
1058 
1059     /**
1060      * @dev Leaves the contract without owner. It will not be possible to call
1061      * `onlyOwner` functions anymore. Can only be called by the current owner.
1062      *
1063      * NOTE: Renouncing ownership will leave the contract without an owner,
1064      * thereby removing any functionality that is only available to the owner.
1065      */
1066     function renounceOwnership() public virtual onlyOwner {
1067         _transferOwnership(address(0));
1068     }
1069 
1070     /**
1071      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1072      * Can only be called by the current owner.
1073      */
1074     function transferOwnership(address newOwner) public virtual onlyOwner {
1075         require(newOwner != address(0), "Ownable: new owner is the zero address");
1076         _transferOwnership(newOwner);
1077     }
1078 
1079     /**
1080      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1081      * Internal function without access restriction.
1082      */
1083     function _transferOwnership(address newOwner) internal virtual {
1084         address oldOwner = _owner;
1085         _owner = newOwner;
1086         emit OwnershipTransferred(oldOwner, newOwner);
1087     }
1088 }
1089 
1090 // File: contracts/main.sol
1091 
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 
1096 
1097 contract pxMAYCpastel is ERC721, Ownable {
1098   bool public paused = true;
1099   bool public isFlipState = true;
1100   string private _baseTokenURI;
1101   uint256 public totalSupply = 0;
1102   uint256 public price = 0.01 ether;
1103   uint256 public maxSupply = 6666;
1104   uint256 public maxFreeMints = 1000;
1105   mapping(address => uint256) private freeWallets;
1106 
1107   constructor(string memory baseURI)
1108     ERC721("pxMAYCpastel", "pxMAYCpastel")
1109   {
1110     setBaseURI(baseURI);
1111   }
1112 
1113   function Mint(uint256 num) public payable {
1114     uint256 supply = totalSupply;
1115 
1116     require(!paused, "MINTING PAUSED");
1117     require(totalSupply + num <= maxSupply, "EXCEEDS MAX SUPPLY");
1118 
1119     if (totalSupply + num > maxFreeMints && isFlipState) {
1120       require(num < 31, "MAX PER TRANSACTION IS 30");
1121       require(msg.value >= price * num, "NOT ENOUGH ETH");
1122     } else {
1123       require(
1124         freeWallets[msg.sender] + num < 11,
1125         "MAX FREE MINTS PER WALLET IS 10"
1126       );
1127 
1128       freeWallets[msg.sender] += num;
1129     }
1130 
1131     totalSupply += num;
1132 
1133     for (uint256 i; i < num; i++) {
1134       _mint(msg.sender, supply + i);
1135     }
1136   }
1137 
1138   function _baseURI() internal view virtual override returns (string memory) {
1139     return _baseTokenURI;
1140   }
1141 
1142   function setBaseURI(string memory baseUri) public onlyOwner {
1143     _baseTokenURI = baseUri;
1144   }
1145 //price should be set ie 10000000000000000
1146   function setPrice(uint256 newPrice) public onlyOwner {
1147     price = newPrice;
1148   }
1149 
1150   function setMaxSupply(uint256 newMaxSupply) public onlyOwner {
1151     maxSupply = newMaxSupply;
1152   }
1153 
1154   function setMaxFreeMints(uint256 newMaxFreeMints) public onlyOwner {
1155     maxFreeMints = newMaxFreeMints;
1156   }
1157 
1158   function pause(bool state) public onlyOwner {
1159     paused = state;
1160   }
1161 
1162   function FlipState(bool state) public onlyOwner {
1163     isFlipState = state;
1164   }
1165 
1166   function withdrawAll() public onlyOwner {
1167     require(
1168       payable(owner()).send(address(this).balance),
1169       "WITHDRAW UNSUCCESSFUL"
1170     );
1171   }
1172 }