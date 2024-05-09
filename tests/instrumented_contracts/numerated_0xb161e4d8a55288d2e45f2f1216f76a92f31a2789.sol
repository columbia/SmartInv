1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6 *                                                           .....#*.#.#,*
7 *                                                     ,*#.....................#..
8 *                                                 .%...............................#.
9 *                                              .#.....................................*.
10 *                                            *...........................................&(
11 *                                         (%...............................................#(
12 *                                        #...................................................*
13 *                                      .%..............................................#%####./.
14 *                                      ........................................,,####.&.####...,.
15 *                                   .(,..........................,#*##............######,###.....#
16 *                                  .#.....................#####.#######&.............######,......#%
17 *                                *#.........................######.###...................#..........,
18 *                                ,,............................######...............................#
19 *                               /#....*............................#...........&../*................/
20 *                             .#.....##........................................&##.(...............#(
21 *                           .*......% #...........................................................#(
22 *                        //..........#............................................................
23 *                       #...........#.*.##....................................................%.
24 *                    . ...........  .........#.............................................#,
25 *                 .,............... ......&&.# &.......................................&.
26 *                ..............#. ............. ,.,............................,#*./
27 *               ...............   ............       ..%#(.......&###....#
28 *               ............**    ./.........
29 *               .*........,,       .%....,..
30 *                 .#. &.              %.
31 *                                                        created by CryptoNooniz
32 *
33 *                                            @title Crypto Nooniz ERC-721 Smart Contract
34 */
35 
36 
37 abstract contract ReentrancyGuard {
38     // Booleans are more expensive than uint256 or any type that takes up a full
39     // word because each write operation emits an extra SLOAD to first read the
40     // slot's contents, replace the bits taken up by the boolean, and then write
41     // back. This is the compiler's defense against contract upgrades and
42     // pointer aliasing, and it cannot be disabled.
43 
44     // The values being non-zero value makes deployment a bit more expensive,
45     // but in exchange the refund on every call to nonReentrant will be lower in
46     // amount. Since refunds are capped to a percentage of the total
47     // transaction's gas, it is best to keep them low in cases like this one, to
48     // increase the likelihood of the full refund coming into effect.
49     uint256 private constant _NOT_ENTERED = 1;
50     uint256 private constant _ENTERED = 2;
51 
52     uint256 private _status;
53 
54     constructor() {
55         _status = _NOT_ENTERED;
56     }
57 
58     /**
59      * @dev Prevents a contract from calling itself, directly or indirectly.
60      * Calling a `nonReentrant` function from another `nonReentrant`
61      * function is not supported. It is possible to prevent this from happening
62      * by making the `nonReentrant` function external, and make it call a
63      * `private` function that does the actual work.
64      */
65     modifier nonReentrant() {
66         // On the first call to nonReentrant, _notEntered will be true
67         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
68 
69         // Any calls to nonReentrant after this point will fail
70         _status = _ENTERED;
71 
72         _;
73 
74         // By storing the original value once again, a refund is triggered (see
75         // https://eips.ethereum.org/EIPS/eip-2200)
76         _status = _NOT_ENTERED;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
81 pragma solidity ^0.8.0;
82 /**
83  * @dev Interface of the ERC165 standard, as defined in the
84  * https://eips.ethereum.org/EIPS/eip-165[EIP].
85  *
86  * Implementers can declare support of contract interfaces, which can then be
87  * queried by others ({ERC165Checker}).
88  *
89  * For an implementation, see {ERC165}.
90  */
91 interface IERC165 {
92     /**
93      * @dev Returns true if this contract implements the interface defined by
94      * `interfaceId`. See the corresponding
95      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
96      * to learn more about how these ids are created.
97      *
98      * This function call must use less than 30 000 gas.
99      */
100     function supportsInterface(bytes4 interfaceId) external view returns (bool);
101 }
102 
103 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
104 pragma solidity ^0.8.0;
105 /**
106  * @dev Required interface of an ERC721 compliant contract.
107  */
108 interface IERC721 is IERC165 {
109     /**
110      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
113 
114     /**
115      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
116      */
117     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
118 
119     /**
120      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
121      */
122     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
123 
124     /**
125      * @dev Returns the number of tokens in ``owner``'s account.
126      */
127     function balanceOf(address owner) external view returns (uint256 balance);
128 
129     /**
130      * @dev Returns the owner of the `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function ownerOf(uint256 tokenId) external view returns (address owner);
137 
138     /**
139      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
140      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
141      *
142      * Requirements:
143      *
144      * - `from` cannot be the zero address.
145      * - `to` cannot be the zero address.
146      * - `tokenId` token must exist and be owned by `from`.
147      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
149      *
150      * Emits a {Transfer} event.
151      */
152     function safeTransferFrom(
153         address from,
154         address to,
155         uint256 tokenId
156     ) external;
157 
158     /**
159      * @dev Transfers `tokenId` token from `from` to `to`.
160      *
161      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must be owned by `from`.
168      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address from,
174         address to,
175         uint256 tokenId
176     ) external;
177 
178     /**
179      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
180      * The approval is cleared when the token is transferred.
181      *
182      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
183      *
184      * Requirements:
185      *
186      * - The caller must own the token or be an approved operator.
187      * - `tokenId` must exist.
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Returns the account approved for `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function getApproved(uint256 tokenId) external view returns (address operator);
201 
202     /**
203      * @dev Approve or remove `operator` as an operator for the caller.
204      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
205      *
206      * Requirements:
207      *
208      * - The `operator` cannot be the caller.
209      *
210      * Emits an {ApprovalForAll} event.
211      */
212     function setApprovalForAll(address operator, bool _approved) external;
213 
214     /**
215      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
216      *
217      * See {setApprovalForAll}
218      */
219     function isApprovedForAll(address owner, address operator) external view returns (bool);
220 
221     /**
222      * @dev Safely transfers `tokenId` token from `from` to `to`.
223      *
224      * Requirements:
225      *
226      * - `from` cannot be the zero address.
227      * - `to` cannot be the zero address.
228      * - `tokenId` token must exist and be owned by `from`.
229      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
230      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
231      *
232      * Emits a {Transfer} event.
233      */
234     function safeTransferFrom(
235         address from,
236         address to,
237         uint256 tokenId,
238         bytes calldata data
239     ) external;
240 }
241 
242 
243 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
244 pragma solidity ^0.8.0;
245 /**
246  * @dev Implementation of the {IERC165} interface.
247  *
248  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
249  * for the additional interface id that will be supported. For example:
250  *
251  * ```solidity
252  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
253  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
254  * }
255  * ```
256  *
257  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
258  */
259 abstract contract ERC165 is IERC165 {
260     /**
261      * @dev See {IERC165-supportsInterface}.
262      */
263     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
264         return interfaceId == type(IERC165).interfaceId;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Strings.sol
269 
270 
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev String operations.
276  */
277 library Strings {
278     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
282      */
283     function toString(uint256 value) internal pure returns (string memory) {
284         // Inspired by OraclizeAPI's implementation - MIT licence
285         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
286 
287         if (value == 0) {
288             return "0";
289         }
290         uint256 temp = value;
291         uint256 digits;
292         while (temp != 0) {
293             digits++;
294             temp /= 10;
295         }
296         bytes memory buffer = new bytes(digits);
297         while (value != 0) {
298             digits -= 1;
299             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
300             value /= 10;
301         }
302         return string(buffer);
303     }
304 
305     /**
306      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
307      */
308     function toHexString(uint256 value) internal pure returns (string memory) {
309         if (value == 0) {
310             return "0x00";
311         }
312         uint256 temp = value;
313         uint256 length = 0;
314         while (temp != 0) {
315             length++;
316             temp >>= 8;
317         }
318         return toHexString(value, length);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
323      */
324     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
325         bytes memory buffer = new bytes(2 * length + 2);
326         buffer[0] = "0";
327         buffer[1] = "x";
328         for (uint256 i = 2 * length + 1; i > 1; --i) {
329             buffer[i] = _HEX_SYMBOLS[value & 0xf];
330             value >>= 4;
331         }
332         require(value == 0, "Strings: hex length insufficient");
333         return string(buffer);
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Address.sol
338 
339 
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Collection of functions related to the address type
345  */
346 library Address {
347     /**
348      * @dev Returns true if `account` is a contract.
349      *
350      * [IMPORTANT]
351      * ====
352      * It is unsafe to assume that an address for which this function returns
353      * false is an externally-owned account (EOA) and not a contract.
354      *
355      * Among others, `isContract` will return false for the following
356      * types of addresses:
357      *
358      *  - an externally-owned account
359      *  - a contract in construction
360      *  - an address where a contract will be created
361      *  - an address where a contract lived, but was destroyed
362      * ====
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies on extcodesize, which returns 0 for contracts in
366         // construction, since the code is only stored at the end of the
367         // constructor execution.
368 
369         uint256 size;
370         assembly {
371             size := extcodesize(account)
372         }
373         return size > 0;
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(address(this).balance >= amount, "Address: insufficient balance");
394 
395         (bool success, ) = recipient.call{value: amount}("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 
399     /**
400      * @dev Performs a Solidity function call using a low level `call`. A
401      * plain `call` is an unsafe replacement for a function call: use this
402      * function instead.
403      *
404      * If `target` reverts with a revert reason, it is bubbled up by this
405      * function (like regular Solidity function calls).
406      *
407      * Returns the raw returned data. To convert to the expected return value,
408      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
409      *
410      * Requirements:
411      *
412      * - `target` must be a contract.
413      * - calling `target` with `data` must not revert.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         return functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(
447         address target,
448         bytes memory data,
449         uint256 value
450     ) internal returns (bytes memory) {
451         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
456      * with `errorMessage` as a fallback revert reason when `target` reverts.
457      *
458      * _Available since v3.1._
459      */
460     function functionCallWithValue(
461         address target,
462         bytes memory data,
463         uint256 value,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(address(this).balance >= value, "Address: insufficient balance for call");
467         require(isContract(target), "Address: call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.call{value: value}(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
480         return functionStaticCall(target, data, "Address: low-level static call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal view returns (bytes memory) {
494         require(isContract(target), "Address: static call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.staticcall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
507         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(
517         address target,
518         bytes memory data,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(isContract(target), "Address: delegate call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.delegatecall(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
529      * revert reason using the provided one.
530      *
531      * _Available since v4.3._
532      */
533     function verifyCallResult(
534         bool success,
535         bytes memory returndata,
536         string memory errorMessage
537     ) internal pure returns (bytes memory) {
538         if (success) {
539             return returndata;
540         } else {
541             // Look for revert reason and bubble it up if present
542             if (returndata.length > 0) {
543                 // The easiest way to bubble the revert reason is using memory via assembly
544 
545                 assembly {
546                     let returndata_size := mload(returndata)
547                     revert(add(32, returndata), returndata_size)
548                 }
549             } else {
550                 revert(errorMessage);
551             }
552         }
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
557 
558 
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
565  * @dev See https://eips.ethereum.org/EIPS/eip-721
566  */
567 interface IERC721Metadata is IERC721 {
568     /**
569      * @dev Returns the token collection name.
570      */
571     function name() external view returns (string memory);
572 
573     /**
574      * @dev Returns the token collection symbol.
575      */
576     function symbol() external view returns (string memory);
577 
578     /**
579      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
580      */
581     function tokenURI(uint256 tokenId) external view returns (string memory);
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
585 
586 
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @title ERC721 token receiver interface
592  * @dev Interface for any contract that wants to support safeTransfers
593  * from ERC721 asset contracts.
594  */
595 interface IERC721Receiver {
596     /**
597      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
598      * by `operator` from `from`, this function is called.
599      *
600      * It must return its Solidity selector to confirm the token transfer.
601      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
602      *
603      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
604      */
605     function onERC721Received(
606         address operator,
607         address from,
608         uint256 tokenId,
609         bytes calldata data
610     ) external returns (bytes4);
611 }
612 
613 // File: @openzeppelin/contracts/utils/Context.sol
614 pragma solidity ^0.8.0;
615 /**
616  * @dev Provides information about the current execution context, including the
617  * sender of the transaction and its data. While these are generally available
618  * via msg.sender and msg.data, they should not be accessed in such a direct
619  * manner, since when dealing with meta-transactions the account sending and
620  * paying for execution may not be the actual sender (as far as an application
621  * is concerned).
622  *
623  * This contract is only required for intermediate, library-like contracts.
624  */
625 abstract contract Context {
626     function _msgSender() internal view virtual returns (address) {
627         return msg.sender;
628     }
629 
630     function _msgData() internal view virtual returns (bytes calldata) {
631         return msg.data;
632     }
633 }
634 
635 
636 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
637 pragma solidity ^0.8.0;
638 /**
639  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
640  * the Metadata extension, but not including the Enumerable extension, which is available separately as
641  * {ERC721Enumerable}.
642  */
643 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
644     using Address for address;
645     using Strings for uint256;
646 
647     // Token name
648     string private _name;
649 
650     // Token symbol
651     string private _symbol;
652 
653     // Mapping from token ID to owner address
654     mapping(uint256 => address) private _owners;
655 
656     // Mapping owner address to token count
657     mapping(address => uint256) private _balances;
658 
659     // Mapping from token ID to approved address
660     mapping(uint256 => address) private _tokenApprovals;
661 
662     // Mapping from owner to operator approvals
663     mapping(address => mapping(address => bool)) private _operatorApprovals;
664 
665     /**
666      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
667      */
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671     }
672 
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
677         return
678         interfaceId == type(IERC721).interfaceId ||
679         interfaceId == type(IERC721Metadata).interfaceId ||
680         super.supportsInterface(interfaceId);
681     }
682 
683     /**
684      * @dev See {IERC721-balanceOf}.
685      */
686     function balanceOf(address owner) public view virtual override returns (uint256) {
687         require(owner != address(0), "ERC721: balance query for the zero address");
688         return _balances[owner];
689     }
690 
691     /**
692      * @dev See {IERC721-ownerOf}.
693      */
694     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
695         address owner = _owners[tokenId];
696         require(owner != address(0), "ERC721: owner query for nonexistent token");
697         return owner;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-name}.
702      */
703     function name() public view virtual override returns (string memory) {
704         return _name;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-symbol}.
709      */
710     function symbol() public view virtual override returns (string memory) {
711         return _symbol;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-tokenURI}.
716      */
717     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
718         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
719 
720         string memory baseURI = _baseURI();
721         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
722     }
723 
724     /**
725      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
726      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
727      * by default, can be overriden in child contracts.
728      */
729     function _baseURI() internal view virtual returns (string memory) {
730         return "";
731     }
732 
733     /**
734      * @dev See {IERC721-approve}.
735      */
736     function approve(address to, uint256 tokenId) public virtual override {
737         address owner = ERC721.ownerOf(tokenId);
738         require(to != owner, "ERC721: approval to current owner");
739 
740         require(
741             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
742             "ERC721: approve caller is not owner nor approved for all"
743         );
744 
745         _approve(to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-getApproved}.
750      */
751     function getApproved(uint256 tokenId) public view virtual override returns (address) {
752         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
753 
754         return _tokenApprovals[tokenId];
755     }
756 
757     /**
758      * @dev See {IERC721-setApprovalForAll}.
759      */
760     function setApprovalForAll(address operator, bool approved) public virtual override {
761         require(operator != _msgSender(), "ERC721: approve to caller");
762 
763         _operatorApprovals[_msgSender()][operator] = approved;
764         emit ApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     /**
768      * @dev See {IERC721-isApprovedForAll}.
769      */
770     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
771         return _operatorApprovals[owner][operator];
772     }
773 
774     /**
775      * @dev See {IERC721-transferFrom}.
776      */
777     function transferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) public virtual override {
782         //solhint-disable-next-line max-line-length
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784 
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public virtual override {
796         safeTransferFrom(from, to, tokenId, "");
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public virtual override {
808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
809         _safeTransfer(from, to, tokenId, _data);
810     }
811 
812     /**
813      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
814      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
815      *
816      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
817      *
818      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
819      * implement alternative mechanisms to perform token transfer, such as signature-based.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must exist and be owned by `from`.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeTransfer(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _transfer(from, to, tokenId);
837         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted (`_mint`),
846      * and stop existing when they are burned (`_burn`).
847      */
848     function _exists(uint256 tokenId) internal view virtual returns (bool) {
849         return _owners[tokenId] != address(0);
850     }
851 
852     /**
853      * @dev Returns whether `spender` is allowed to manage `tokenId`.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
860         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
861         address owner = ERC721.ownerOf(tokenId);
862         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
863     }
864 
865     /**
866      * @dev Safely mints `tokenId` and transfers it to `to`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must not exist.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeMint(address to, uint256 tokenId) internal virtual {
876         _safeMint(to, tokenId, "");
877     }
878 
879     /**
880      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
881      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
882      */
883     function _safeMint(
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _mint(to, tokenId);
889         require(
890             _checkOnERC721Received(address(0), to, tokenId, _data),
891             "ERC721: transfer to non ERC721Receiver implementer"
892         );
893     }
894 
895     /**
896      * @dev Mints `tokenId` and transfers it to `to`.
897      *
898      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - `to` cannot be the zero address.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _mint(address to, uint256 tokenId) internal virtual {
908         require(to != address(0), "ERC721: mint to the zero address");
909         require(!_exists(tokenId), "ERC721: token already minted");
910 
911         _beforeTokenTransfer(address(0), to, tokenId);
912 
913         _balances[to] += 1;
914         _owners[tokenId] = to;
915 
916         emit Transfer(address(0), to, tokenId);
917     }
918 
919     /**
920      * @dev Destroys `tokenId`.
921      * The approval is cleared when the token is burned.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _burn(uint256 tokenId) internal virtual {
930         address owner = ERC721.ownerOf(tokenId);
931 
932         _beforeTokenTransfer(owner, address(0), tokenId);
933 
934         // Clear approvals
935         _approve(address(0), tokenId);
936 
937         _balances[owner] -= 1;
938         delete _owners[tokenId];
939 
940         emit Transfer(owner, address(0), tokenId);
941     }
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must be owned by `from`.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _transfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {
959         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _beforeTokenTransfer(from, to, tokenId);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId);
966 
967         _balances[from] -= 1;
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(from, to, tokenId);
972     }
973 
974     /**
975      * @dev Approve `to` to operate on `tokenId`
976      *
977      * Emits a {Approval} event.
978      */
979     function _approve(address to, uint256 tokenId) internal virtual {
980         _tokenApprovals[tokenId] = to;
981         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
1038 // File: contracts\lib\Counters.sol
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /**
1043  * @title Counters
1044  * @author Matt Condon (@shrugs)
1045  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1046  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1047  *
1048  * Include with `using Counters for Counters.Counter;`
1049  */
1050 library Counters {
1051     struct Counter {
1052         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1053         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1054         // this feature: see https://github.com/ethereum/solidity/issues/4637
1055         uint256 _value; // default: 0
1056     }
1057 
1058     function current(Counter storage counter) internal view returns (uint256) {
1059         return counter._value;
1060     }
1061 
1062     function increment(Counter storage counter) internal {
1063         {
1064             counter._value += 1;
1065         }
1066     }
1067 
1068     function decrement(Counter storage counter) internal {
1069         uint256 value = counter._value;
1070         require(value > 0, "Counter: decrement overflow");
1071         {
1072             counter._value = value - 1;
1073         }
1074     }
1075 }
1076 
1077 
1078 // File: @openzeppelin/contracts/access/Ownable.sol
1079 pragma solidity ^0.8.0;
1080 /**
1081  * @dev Contract module which provides a basic access control mechanism, where
1082  * there is an account (an owner) that can be granted exclusive access to
1083  * specific functions.
1084  *
1085  * By default, the owner account will be the one that deploys the contract. This
1086  * can later be changed with {transferOwnership}.
1087  *
1088  * This module is used through inheritance. It will make available the modifier
1089  * `onlyOwner`, which can be applied to your functions to restrict their use to
1090  * the owner.
1091  */
1092 abstract contract Ownable is Context {
1093     address private _owner;
1094 
1095     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1096 
1097     /**
1098      * @dev Initializes the contract setting the deployer as the initial owner.
1099      */
1100     constructor() {
1101         _setOwner(_msgSender());
1102     }
1103 
1104     /**
1105      * @dev Returns the address of the current owner.
1106      */
1107     function owner() public view virtual returns (address) {
1108         return _owner;
1109     }
1110 
1111     /**
1112      * @dev Throws if called by any account other than the owner.
1113      */
1114     modifier onlyOwner() {
1115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1116         _;
1117     }
1118 
1119     /**
1120      * @dev Leaves the contract without owner. It will not be possible to call
1121      * `onlyOwner` functions anymore. Can only be called by the current owner.
1122      *
1123      * NOTE: Renouncing ownership will leave the contract without an owner,
1124      * thereby removing any functionality that is only available to the owner.
1125      */
1126     function renounceOwnership() public virtual onlyOwner {
1127         _setOwner(address(0));
1128     }
1129 
1130     /**
1131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1132      * Can only be called by the current owner.
1133      */
1134     function transferOwnership(address newOwner) public virtual onlyOwner {
1135         require(newOwner != address(0), "Ownable: new owner is the zero address");
1136         _setOwner(newOwner);
1137     }
1138 
1139     function _setOwner(address newOwner) private {
1140         address oldOwner = _owner;
1141         _owner = newOwner;
1142         emit OwnershipTransferred(oldOwner, newOwner);
1143     }
1144 }
1145 
1146 
1147 
1148 pragma solidity >=0.7.0 <0.9.0;
1149 
1150 contract CryptoNooniz is ERC721, Ownable, ReentrancyGuard  {
1151     using Strings for uint256;
1152     using Counters for Counters.Counter;
1153 
1154     Counters.Counter private supply;
1155 
1156     string public baseURI;
1157     string public baseExtension = ".json";
1158     uint256 public cost = 0.03 ether;
1159     uint256 public constant NOONIZ_MAX_SUPPLY = 9997;
1160     uint256 public nftPerAddressLimit = 7;
1161 
1162     bool public isPaused = true;
1163     bool public isPresale = true;
1164     bool public presaleBenefits = true;
1165     mapping(address => uint8) public allowListMap;
1166 
1167     constructor() ERC721("CryptoNooniz", "NOONIZ") {
1168     }
1169 
1170     function totalSupply() public view returns (uint256) {
1171         return supply.current();
1172     }
1173 
1174     // public
1175     function mint(uint256 _mintAmount) public payable nonReentrant{
1176         require(!isPaused, "the contract is paused");
1177         require(_mintAmount > 0, "need to mint at least 1 NFT");
1178         uint256 tokensToMint = setDynamicMintAmount(_mintAmount);
1179         require(supply.current() + tokensToMint <= NOONIZ_MAX_SUPPLY, "max NFT limit exceeded");
1180         if (msg.sender != owner()) {
1181             if(isPresale == true) {
1182                 require(isInAllowList(msg.sender), "user is not in allow list");
1183             }
1184             uint256 ownerMintedCount = balanceOf(msg.sender);
1185             require(ownerMintedCount + tokensToMint <= nftPerAddressLimit, "max NFT per address exceeded");
1186 
1187             require(msg.value >= cost * _mintAmount, "insufficient funds");
1188         }
1189 
1190         for (uint256 i = 1; i <= tokensToMint; i++) {
1191             supply.increment();
1192             _safeMint(msg.sender, supply.current());
1193         }
1194     }
1195 
1196     function isInAllowList(address _user) public view returns (bool){
1197         uint256 _userRole = allowListMap[_user];
1198         if(_userRole == 1 || _userRole == 2){
1199             return true;
1200         }
1201         return false;
1202     }
1203 
1204     function getUserRole(address _user) public view returns (uint8){
1205         return allowListMap[_user];
1206     }
1207 
1208     function setDynamicMintAmount(uint256 _mintAmount) internal view returns(uint256){
1209         if(presaleBenefits == true){
1210             uint256 _userRole = allowListMap[msg.sender];
1211             if(_userRole == 1 && _mintAmount >= 5){
1212                 return _mintAmount + 2;
1213             } else if((_userRole == 1 || _userRole == 2) && _mintAmount >= 3 && balanceOf(msg.sender) < 4){
1214                 return _mintAmount + 1;
1215             }
1216         }
1217         return _mintAmount;
1218     }
1219 
1220     function walletOfOwner(address _owner)
1221     public
1222     view
1223     returns (uint256[] memory)
1224     {
1225         uint256 ownerTokenCount = balanceOf(_owner);
1226         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1227         uint256 currentTokenId = 1;
1228         uint256 ownedTokenIndex = 0;
1229 
1230         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= NOONIZ_MAX_SUPPLY) {
1231             address currentTokenOwner = ownerOf(currentTokenId);
1232 
1233             if (currentTokenOwner == _owner) {
1234                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1235 
1236                 ownedTokenIndex++;
1237             }
1238 
1239             currentTokenId++;
1240         }
1241 
1242         return ownedTokenIds;
1243     }
1244 
1245     function tokenURI(uint256 tokenId)
1246     public
1247     view
1248     virtual
1249     override
1250     returns (string memory)
1251     {
1252         require(
1253             _exists(tokenId),
1254             "ERC721Metadata: URI query for nonexistent token"
1255         );
1256 
1257         return string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension));
1258     }
1259 
1260     // BURN IT
1261     function burn(uint256 tokenId) external virtual {
1262         require(
1263             _isApprovedOrOwner(_msgSender(), tokenId),
1264             "ERC721Burnable: caller is not owner nor approved"
1265         );
1266         _burn(tokenId);
1267     }
1268 
1269     //only owner
1270     function ownerMint(address to, uint256 _mintAmount) public payable onlyOwner{
1271         require(supply.current() + _mintAmount <= NOONIZ_MAX_SUPPLY, "max NFT limit exceeded");
1272 
1273         for (uint256 i = 1; i <= _mintAmount; i++) {
1274             supply.increment();
1275             _safeMint(to, supply.current());
1276         }
1277     }
1278 
1279     function setPause(bool _state) public onlyOwner {
1280         isPaused = _state;
1281     }
1282 
1283     function setPresale(bool _state) public onlyOwner {
1284         isPresale = _state;
1285     }
1286 
1287     function setPresaleBenefits(bool _state) public onlyOwner {
1288         presaleBenefits = _state;
1289     }
1290 
1291     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1292         nftPerAddressLimit = _limit;
1293     }
1294 
1295     function setCost(uint256 _newCost) public onlyOwner {
1296         cost = _newCost;
1297     }
1298 
1299     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1300         baseURI = _newBaseURI;
1301     }
1302 
1303     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1304         baseExtension = _newBaseExtension;
1305     }
1306 
1307     function setAllowMap(address[] calldata _allowUsers, uint8 role) public onlyOwner {
1308         for (uint i = 0; i < _allowUsers.length; i++) {
1309             allowListMap[_allowUsers[i]] = role;
1310         }
1311     }
1312 
1313     function withdraw() public payable onlyOwner {
1314         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1315         require(os);
1316     }
1317 }