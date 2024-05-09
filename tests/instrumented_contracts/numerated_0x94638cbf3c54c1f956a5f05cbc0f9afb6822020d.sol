1 /*
2 ................................................................................
3 ................................................................................
4 ................................................................................
5 ................................................................................
6 ................................................................................
7 ................................................................................
8 .....................................................@@@@@@.....................
9 ..................................................@##########@..................
10 ..................@@####@.......................@##############@................
11 ................@##########@...................######@@@@######@................
12 ................######%#####@..@@@#############@@@#&,,,,,@#####@................
13 ................@###@,,,,@@%  #######################@,,,@####@.................
14 ..................@###@@  ##############################@####@..................
15 ....................@  ############@@##@@#################@.....................
16 ...................@@(###@########@#///@#@#################@....................
17 ...................@#///@#@#######@#@@@@#@##################....................
18 ....................@@##@@#################################@....................
19 ....................@#@%%&&&&&&@,,,,,,,,@@#################@....................
20 ....................,,,,@&&&&@,,,,,,,,,,,,@###############@.....................
21 ...................@,,,,,,,,,,,,,,,,,,,,,,,%#############/......................
22 ....................@,,,,@,,,,@@,,,,,,,,,,@############@........................
23 .....................@,,,,,,,,,,,,,,,,,,,@###########@..........................
24 ......................@/,,,,,,,,,,,,,,,,@##########@............................
25 .........................@,,,,,,,,,,,,@##########@..............................
26 ............................@@(,,,,@@#########%*................................
27 ............................&(#%##########&,#&@.................................
28 ..........................@##@%&@######*(*#####@...............................
29 ........................@###@ #%@%@/.&*(/#@#######@.............................
30 .......................@ ,#@#######&((####@########@............................
31 ......................@#.##@##############@#########@...........................
32 */
33 
34 // SPDX-License-Identifier: MIT AND GPL-3.0
35 
36 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
37 
38 
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Interface of the ERC165 standard, as defined in the
44  * https://eips.ethereum.org/EIPS/eip-165[EIP].
45  *
46  * Implementers can declare support of contract interfaces, which can then be
47  * queried by others ({ERC165Checker}).
48  *
49  * For an implementation, see {ERC165}.
50  */
51 interface IERC165 {
52     /**
53      * @dev Returns true if this contract implements the interface defined by
54      * `interfaceId`. See the corresponding
55      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
56      * to learn more about how these ids are created.
57      *
58      * This function call must use less than 30 000 gas.
59      */
60     function supportsInterface(bytes4 interfaceId) external view returns (bool);
61 }
62 
63 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
64 
65 
66 
67 pragma solidity ^0.8.0;
68 
69 
70 /**
71  * @dev Required interface of an ERC721 compliant contract.
72  */
73 interface IERC721 is IERC165 {
74     /**
75      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
81      */
82     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
83 
84     /**
85      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
86      */
87     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
88 
89     /**
90      * @dev Returns the number of tokens in ``owner``'s account.
91      */
92     function balanceOf(address owner) external view returns (uint256 balance);
93 
94     /**
95      * @dev Returns the owner of the `tokenId` token.
96      *
97      * Requirements:
98      *
99      * - `tokenId` must exist.
100      */
101     function ownerOf(uint256 tokenId) external view returns (address owner);
102 
103     /**
104      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
105      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must exist and be owned by `from`.
112      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
114      *
115      * Emits a {Transfer} event.
116      */
117     function safeTransferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Transfers `tokenId` token from `from` to `to`.
125      *
126      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
127      *
128      * Requirements:
129      *
130      * - `from` cannot be the zero address.
131      * - `to` cannot be the zero address.
132      * - `tokenId` token must be owned by `from`.
133      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(
138         address from,
139         address to,
140         uint256 tokenId
141     ) external;
142 
143     /**
144      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
145      * The approval is cleared when the token is transferred.
146      *
147      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
148      *
149      * Requirements:
150      *
151      * - The caller must own the token or be an approved operator.
152      * - `tokenId` must exist.
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address to, uint256 tokenId) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Approve or remove `operator` as an operator for the caller.
169      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
170      *
171      * Requirements:
172      *
173      * - The `operator` cannot be the caller.
174      *
175      * Emits an {ApprovalForAll} event.
176      */
177     function setApprovalForAll(address operator, bool _approved) external;
178 
179     /**
180      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
181      *
182      * See {setApprovalForAll}
183      */
184     function isApprovedForAll(address owner, address operator) external view returns (bool);
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId,
203         bytes calldata data
204     ) external;
205 }
206 
207 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
208 
209 
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @title ERC721 token receiver interface
215  * @dev Interface for any contract that wants to support safeTransfers
216  * from ERC721 asset contracts.
217  */
218 interface IERC721Receiver {
219     /**
220      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
221      * by `operator` from `from`, this function is called.
222      *
223      * It must return its Solidity selector to confirm the token transfer.
224      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
225      *
226      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
227      */
228     function onERC721Received(
229         address operator,
230         address from,
231         uint256 tokenId,
232         bytes calldata data
233     ) external returns (bytes4);
234 }
235 
236 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
237 
238 
239 
240 pragma solidity ^0.8.0;
241 
242 
243 /**
244  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
245  * @dev See https://eips.ethereum.org/EIPS/eip-721
246  */
247 interface IERC721Metadata is IERC721 {
248     /**
249      * @dev Returns the token collection name.
250      */
251     function name() external view returns (string memory);
252 
253     /**
254      * @dev Returns the token collection symbol.
255      */
256     function symbol() external view returns (string memory);
257 
258     /**
259      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
260      */
261     function tokenURI(uint256 tokenId) external view returns (string memory);
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         assembly {
298             size := extcodesize(account)
299         }
300         return size > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         (bool success, ) = recipient.call{value: amount}("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain `call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.staticcall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
434         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(isContract(target), "Address: delegate call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.delegatecall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
456      * revert reason using the provided one.
457      *
458      * _Available since v4.3._
459      */
460     function verifyCallResult(
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) internal pure returns (bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/Context.sol
484 
485 
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Provides information about the current execution context, including the
491  * sender of the transaction and its data. While these are generally available
492  * via msg.sender and msg.data, they should not be accessed in such a direct
493  * manner, since when dealing with meta-transactions the account sending and
494  * paying for execution may not be the actual sender (as far as an application
495  * is concerned).
496  *
497  * This contract is only required for intermediate, library-like contracts.
498  */
499 abstract contract Context {
500     function _msgSender() internal view virtual returns (address) {
501         return msg.sender;
502     }
503 
504     function _msgData() internal view virtual returns (bytes calldata) {
505         return msg.data;
506     }
507 }
508 
509 // File: @openzeppelin/contracts/utils/Strings.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev String operations.
517  */
518 library Strings {
519     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
523      */
524     function toString(uint256 value) internal pure returns (string memory) {
525         // Inspired by OraclizeAPI's implementation - MIT licence
526         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
527 
528         if (value == 0) {
529             return "0";
530         }
531         uint256 temp = value;
532         uint256 digits;
533         while (temp != 0) {
534             digits++;
535             temp /= 10;
536         }
537         bytes memory buffer = new bytes(digits);
538         while (value != 0) {
539             digits -= 1;
540             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
541             value /= 10;
542         }
543         return string(buffer);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
548      */
549     function toHexString(uint256 value) internal pure returns (string memory) {
550         if (value == 0) {
551             return "0x00";
552         }
553         uint256 temp = value;
554         uint256 length = 0;
555         while (temp != 0) {
556             length++;
557             temp >>= 8;
558         }
559         return toHexString(value, length);
560     }
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
564      */
565     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
566         bytes memory buffer = new bytes(2 * length + 2);
567         buffer[0] = "0";
568         buffer[1] = "x";
569         for (uint256 i = 2 * length + 1; i > 1; --i) {
570             buffer[i] = _HEX_SYMBOLS[value & 0xf];
571             value >>= 4;
572         }
573         require(value == 0, "Strings: hex length insufficient");
574         return string(buffer);
575     }
576 }
577 
578 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
579 
580 
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev Implementation of the {IERC165} interface.
587  *
588  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
589  * for the additional interface id that will be supported. For example:
590  *
591  * ```solidity
592  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
594  * }
595  * ```
596  *
597  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
598  */
599 abstract contract ERC165 is IERC165 {
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604         return interfaceId == type(IERC165).interfaceId;
605     }
606 }
607 
608 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
609 
610 
611 
612 pragma solidity ^0.8.0;
613 
614 
615 
616 
617 
618 
619 
620 
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata extension, but not including the Enumerable extension, which is available separately as
624  * {ERC721Enumerable}.
625  */
626 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
627     using Address for address;
628     using Strings for uint256;
629 
630     // Token name
631     string private _name;
632 
633     // Token symbol
634     string private _symbol;
635 
636     // Mapping from token ID to owner address
637     mapping(uint256 => address) private _owners;
638 
639     // Mapping owner address to token count
640     mapping(address => uint256) private _balances;
641 
642     // Mapping from token ID to approved address
643     mapping(uint256 => address) private _tokenApprovals;
644 
645     // Mapping from owner to operator approvals
646     mapping(address => mapping(address => bool)) private _operatorApprovals;
647 
648     /**
649      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
650      */
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654     }
655 
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
660         return
661             interfaceId == type(IERC721).interfaceId ||
662             interfaceId == type(IERC721Metadata).interfaceId ||
663             super.supportsInterface(interfaceId);
664     }
665 
666     /**
667      * @dev See {IERC721-balanceOf}.
668      */
669     function balanceOf(address owner) public view virtual override returns (uint256) {
670         require(owner != address(0), "ERC721: balance query for the zero address");
671         return _balances[owner];
672     }
673 
674     /**
675      * @dev See {IERC721-ownerOf}.
676      */
677     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
678         address owner = _owners[tokenId];
679         require(owner != address(0), "ERC721: owner query for nonexistent token");
680         return owner;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-name}.
685      */
686     function name() public view virtual override returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-symbol}.
692      */
693     function symbol() public view virtual override returns (string memory) {
694         return _symbol;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-tokenURI}.
699      */
700     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
701         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
702 
703         string memory baseURI = _baseURI();
704         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
705     }
706 
707     /**
708      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
709      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
710      * by default, can be overriden in child contracts.
711      */
712     function _baseURI() internal view virtual returns (string memory) {
713         return "";
714     }
715 
716     /**
717      * @dev See {IERC721-approve}.
718      */
719     function approve(address to, uint256 tokenId) public virtual override {
720         address owner = ERC721.ownerOf(tokenId);
721         require(to != owner, "ERC721: approval to current owner");
722 
723         require(
724             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
725             "ERC721: approve caller is not owner nor approved for all"
726         );
727 
728         _approve(to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-getApproved}.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
736 
737         return _tokenApprovals[tokenId];
738     }
739 
740     /**
741      * @dev See {IERC721-setApprovalForAll}.
742      */
743     function setApprovalForAll(address operator, bool approved) public virtual override {
744         require(operator != _msgSender(), "ERC721: approve to caller");
745 
746         _operatorApprovals[_msgSender()][operator] = approved;
747         emit ApprovalForAll(_msgSender(), operator, approved);
748     }
749 
750     /**
751      * @dev See {IERC721-isApprovedForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
754         return _operatorApprovals[owner][operator];
755     }
756 
757     /**
758      * @dev See {IERC721-transferFrom}.
759      */
760     function transferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) public virtual override {
765         //solhint-disable-next-line max-line-length
766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
767 
768         _transfer(from, to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-safeTransferFrom}.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         safeTransferFrom(from, to, tokenId, "");
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) public virtual override {
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792         _safeTransfer(from, to, tokenId, _data);
793     }
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
800      *
801      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
802      * implement alternative mechanisms to perform token transfer, such as signature-based.
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must exist and be owned by `from`.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeTransfer(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) internal virtual {
819         _transfer(from, to, tokenId);
820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822 
823     /**
824      * @dev Returns whether `tokenId` exists.
825      *
826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
827      *
828      * Tokens start existing when they are minted (`_mint`),
829      * and stop existing when they are burned (`_burn`).
830      */
831     function _exists(uint256 tokenId) internal view virtual returns (bool) {
832         return _owners[tokenId] != address(0);
833     }
834 
835     /**
836      * @dev Returns whether `spender` is allowed to manage `tokenId`.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
843         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
844         address owner = ERC721.ownerOf(tokenId);
845         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
846     }
847 
848     /**
849      * @dev Safely mints `tokenId` and transfers it to `to`.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must not exist.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _safeMint(address to, uint256 tokenId) internal virtual {
859         _safeMint(to, tokenId, "");
860     }
861 
862     /**
863      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
864      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
865      */
866     function _safeMint(
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) internal virtual {
871         _mint(to, tokenId);
872         require(
873             _checkOnERC721Received(address(0), to, tokenId, _data),
874             "ERC721: transfer to non ERC721Receiver implementer"
875         );
876     }
877 
878     /**
879      * @dev Mints `tokenId` and transfers it to `to`.
880      *
881      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - `to` cannot be the zero address.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _mint(address to, uint256 tokenId) internal virtual {
891         require(to != address(0), "ERC721: mint to the zero address");
892         require(!_exists(tokenId), "ERC721: token already minted");
893 
894         _beforeTokenTransfer(address(0), to, tokenId);
895 
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(address(0), to, tokenId);
900     }
901 
902     /**
903      * @dev Destroys `tokenId`.
904      * The approval is cleared when the token is burned.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _burn(uint256 tokenId) internal virtual {
913         address owner = ERC721.ownerOf(tokenId);
914 
915         _beforeTokenTransfer(owner, address(0), tokenId);
916 
917         // Clear approvals
918         _approve(address(0), tokenId);
919 
920         _balances[owner] -= 1;
921         delete _owners[tokenId];
922 
923         emit Transfer(owner, address(0), tokenId);
924     }
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _transfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {
942         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
943         require(to != address(0), "ERC721: transfer to the zero address");
944 
945         _beforeTokenTransfer(from, to, tokenId);
946 
947         // Clear approvals from the previous owner
948         _approve(address(0), tokenId);
949 
950         _balances[from] -= 1;
951         _balances[to] += 1;
952         _owners[tokenId] = to;
953 
954         emit Transfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev Approve `to` to operate on `tokenId`
959      *
960      * Emits a {Approval} event.
961      */
962     function _approve(address to, uint256 tokenId) internal virtual {
963         _tokenApprovals[tokenId] = to;
964         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
965     }
966 
967     /**
968      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
969      * The call is not executed if the target address is not a contract.
970      *
971      * @param from address representing the previous owner of the given token ID
972      * @param to target address that will receive the tokens
973      * @param tokenId uint256 ID of the token to be transferred
974      * @param _data bytes optional data to send along with the call
975      * @return bool whether the call correctly returned the expected magic value
976      */
977     function _checkOnERC721Received(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) private returns (bool) {
983         if (to.isContract()) {
984             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
985                 return retval == IERC721Receiver.onERC721Received.selector;
986             } catch (bytes memory reason) {
987                 if (reason.length == 0) {
988                     revert("ERC721: transfer to non ERC721Receiver implementer");
989                 } else {
990                     assembly {
991                         revert(add(32, reason), mload(reason))
992                     }
993                 }
994             }
995         } else {
996             return true;
997         }
998     }
999 
1000     /**
1001      * @dev Hook that is called before any token transfer. This includes minting
1002      * and burning.
1003      *
1004      * Calling conditions:
1005      *
1006      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1007      * transferred to `to`.
1008      * - When `from` is zero, `tokenId` will be minted for `to`.
1009      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1010      * - `from` and `to` are never both zero.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _beforeTokenTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual {}
1019 }
1020 
1021 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1022 
1023 
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 /**
1029  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1030  * @dev See https://eips.ethereum.org/EIPS/eip-721
1031  */
1032 interface IERC721Enumerable is IERC721 {
1033     /**
1034      * @dev Returns the total amount of tokens stored by the contract.
1035      */
1036     function totalSupply() external view returns (uint256);
1037 
1038     /**
1039      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1040      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1041      */
1042     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1043 
1044     /**
1045      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1046      * Use along with {totalSupply} to enumerate all tokens.
1047      */
1048     function tokenByIndex(uint256 index) external view returns (uint256);
1049 }
1050 
1051 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1052 
1053 
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 
1058 
1059 /**
1060  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1061  * enumerability of all the token ids in the contract as well as all token ids owned by each
1062  * account.
1063  */
1064 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1065     // Mapping from owner to list of owned token IDs
1066     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1067 
1068     // Mapping from token ID to index of the owner tokens list
1069     mapping(uint256 => uint256) private _ownedTokensIndex;
1070 
1071     // Array with all token ids, used for enumeration
1072     uint256[] private _allTokens;
1073 
1074     // Mapping from token id to position in the allTokens array
1075     mapping(uint256 => uint256) private _allTokensIndex;
1076 
1077     /**
1078      * @dev See {IERC165-supportsInterface}.
1079      */
1080     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1081         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1088         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1089         return _ownedTokens[owner][index];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Enumerable-totalSupply}.
1094      */
1095     function totalSupply() public view virtual override returns (uint256) {
1096         return _allTokens.length;
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Enumerable-tokenByIndex}.
1101      */
1102     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1103         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1104         return _allTokens[index];
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual override {
1127         super._beforeTokenTransfer(from, to, tokenId);
1128 
1129         if (from == address(0)) {
1130             _addTokenToAllTokensEnumeration(tokenId);
1131         } else if (from != to) {
1132             _removeTokenFromOwnerEnumeration(from, tokenId);
1133         }
1134         if (to == address(0)) {
1135             _removeTokenFromAllTokensEnumeration(tokenId);
1136         } else if (to != from) {
1137             _addTokenToOwnerEnumeration(to, tokenId);
1138         }
1139     }
1140 
1141     /**
1142      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1143      * @param to address representing the new owner of the given token ID
1144      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1145      */
1146     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1147         uint256 length = ERC721.balanceOf(to);
1148         _ownedTokens[to][length] = tokenId;
1149         _ownedTokensIndex[tokenId] = length;
1150     }
1151 
1152     /**
1153      * @dev Private function to add a token to this extension's token tracking data structures.
1154      * @param tokenId uint256 ID of the token to be added to the tokens list
1155      */
1156     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1157         _allTokensIndex[tokenId] = _allTokens.length;
1158         _allTokens.push(tokenId);
1159     }
1160 
1161     /**
1162      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1163      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1164      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1165      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1166      * @param from address representing the previous owner of the given token ID
1167      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1168      */
1169     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1170         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1171         // then delete the last slot (swap and pop).
1172 
1173         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1174         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1175 
1176         // When the token to delete is the last token, the swap operation is unnecessary
1177         if (tokenIndex != lastTokenIndex) {
1178             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1179 
1180             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1181             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1182         }
1183 
1184         // This also deletes the contents at the last position of the array
1185         delete _ownedTokensIndex[tokenId];
1186         delete _ownedTokens[from][lastTokenIndex];
1187     }
1188 
1189     /**
1190      * @dev Private function to remove a token from this extension's token tracking data structures.
1191      * This has O(1) time complexity, but alters the order of the _allTokens array.
1192      * @param tokenId uint256 ID of the token to be removed from the tokens list
1193      */
1194     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1195         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1196         // then delete the last slot (swap and pop).
1197 
1198         uint256 lastTokenIndex = _allTokens.length - 1;
1199         uint256 tokenIndex = _allTokensIndex[tokenId];
1200 
1201         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1202         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1203         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1204         uint256 lastTokenId = _allTokens[lastTokenIndex];
1205 
1206         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1207         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1208 
1209         // This also deletes the contents at the last position of the array
1210         delete _allTokensIndex[tokenId];
1211         _allTokens.pop();
1212     }
1213 }
1214 
1215 // File: @openzeppelin/contracts/access/Ownable.sol
1216 
1217 
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 
1222 /**
1223  * @dev Contract module which provides a basic access control mechanism, where
1224  * there is an account (an owner) that can be granted exclusive access to
1225  * specific functions.
1226  *
1227  * By default, the owner account will be the one that deploys the contract. This
1228  * can later be changed with {transferOwnership}.
1229  *
1230  * This module is used through inheritance. It will make available the modifier
1231  * `onlyOwner`, which can be applied to your functions to restrict their use to
1232  * the owner.
1233  */
1234 abstract contract Ownable is Context {
1235     address private _owner;
1236 
1237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1238 
1239     /**
1240      * @dev Initializes the contract setting the deployer as the initial owner.
1241      */
1242     constructor() {
1243         _setOwner(_msgSender());
1244     }
1245 
1246     /**
1247      * @dev Returns the address of the current owner.
1248      */
1249     function owner() public view virtual returns (address) {
1250         return _owner;
1251     }
1252 
1253     /**
1254      * @dev Throws if called by any account other than the owner.
1255      */
1256     modifier onlyOwner() {
1257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1258         _;
1259     }
1260 
1261     /**
1262      * @dev Leaves the contract without owner. It will not be possible to call
1263      * `onlyOwner` functions anymore. Can only be called by the current owner.
1264      *
1265      * NOTE: Renouncing ownership will leave the contract without an owner,
1266      * thereby removing any functionality that is only available to the owner.
1267      */
1268     function renounceOwnership() public virtual onlyOwner {
1269         _setOwner(address(0));
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Can only be called by the current owner.
1275      */
1276     function transferOwnership(address newOwner) public virtual onlyOwner {
1277         require(newOwner != address(0), "Ownable: new owner is the zero address");
1278         _setOwner(newOwner);
1279     }
1280 
1281     function _setOwner(address newOwner) private {
1282         address oldOwner = _owner;
1283         _owner = newOwner;
1284         emit OwnershipTransferred(oldOwner, newOwner);
1285     }
1286 }
1287 
1288 // File: contracts/InBetweeners.sol
1289 
1290 pragma solidity >=0.7.0 <0.9.0;
1291 
1292 
1293 
1294 contract InBetweeners is ERC721Enumerable, Ownable {
1295   using Strings for uint256;
1296   string private baseURI;
1297   string public baseExtension = ".json";
1298   string public notRevealedUri;
1299   uint256 public preSaleCost = 0.27 ether;
1300   uint256 public cost = 0.27 ether;
1301   uint256 public maxSupply = 10777;
1302   uint256 public preSaleMaxSupply = 2300;
1303   uint256 public maxMintAmountPresale = 3;
1304   uint256 public maxMintAmount = 10;
1305   uint256 public nftPerAddressLimitPresale = 3;
1306   uint256 public nftPerAddressLimit = 10000;
1307   uint256 public preSaleDate = 1639589400; 
1308   uint256 public preSaleEndDate = 1639675800; 
1309   uint256 public publicSaleDate = 1639762200; 
1310   bool public paused = true;
1311   bool public revealed = false;
1312   mapping(address => bool) whitelistedAddresses;
1313   mapping(address => uint256) public addressMintedBalance;
1314 
1315   constructor(
1316     string memory _name,
1317     string memory _symbol,
1318     string memory _initNotRevealedUri
1319   ) ERC721(_name, _symbol) {
1320     setNotRevealedURI(_initNotRevealedUri);
1321   }
1322 
1323   //MODIFIERS
1324   modifier notPaused {
1325     require(!paused, "the contract is paused");
1326     _;
1327   }
1328 
1329   modifier saleStarted {
1330     require(block.timestamp >= preSaleDate, "Sale has not started yet");
1331     _;
1332   }
1333 
1334   modifier minimumMintAmount(uint256 _mintAmount) {
1335     require(_mintAmount > 0, "need to mint at least 1 NFT");
1336     _;
1337   }
1338 
1339   // INTERNAL
1340   function _baseURI() internal view virtual override returns (string memory) {
1341     return baseURI;
1342   }
1343 
1344   function presaleValidations(
1345     uint256 _ownerMintedCount,
1346     uint256 _mintAmount,
1347     uint256 _supply
1348   ) internal {
1349     uint256 actualCost;
1350     block.timestamp < preSaleEndDate
1351       ? actualCost = preSaleCost
1352       : actualCost = cost;
1353     require(isWhitelisted(msg.sender), "user is not whitelisted");
1354     require(
1355       _ownerMintedCount + _mintAmount <= nftPerAddressLimitPresale,
1356       "max NFT per address exceeded for presale"
1357     );
1358     require(msg.value >= actualCost * _mintAmount, "insufficient funds");
1359     require(
1360       _mintAmount <= maxMintAmountPresale,
1361       "max mint amount per transaction exceeded"
1362     );
1363     require(
1364       _supply + _mintAmount <= preSaleMaxSupply,
1365       "max NFT presale limit exceeded"
1366     );
1367   }
1368 
1369   function publicsaleValidations(uint256 _ownerMintedCount, uint256 _mintAmount)
1370     internal
1371   {
1372     require(
1373       _ownerMintedCount + _mintAmount <= nftPerAddressLimit,
1374       "max NFT per address exceeded"
1375     );
1376     require(msg.value >= cost * _mintAmount, "insufficient funds");
1377     require(
1378       _mintAmount <= maxMintAmount,
1379       "max mint amount per transaction exceeded"
1380     );
1381   }
1382 
1383   //MINT
1384   function mint(uint256 _mintAmount)
1385     public
1386     payable
1387     notPaused
1388     saleStarted
1389     minimumMintAmount(_mintAmount)
1390   {
1391     uint256 supply = totalSupply();
1392     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1393 
1394     //Do some validations depending on which step of the sale we are in
1395     block.timestamp < publicSaleDate
1396       ? presaleValidations(ownerMintedCount, _mintAmount, supply)
1397       : publicsaleValidations(ownerMintedCount, _mintAmount);
1398 
1399     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1400 
1401     for (uint256 i = 1; i <= _mintAmount; i++) {
1402       addressMintedBalance[msg.sender]++;
1403       _safeMint(msg.sender, supply + i);
1404     }
1405   }
1406 
1407   function gift(uint256 _mintAmount, address destination) public onlyOwner {
1408     require(_mintAmount > 0, "need to mint at least 1 NFT");
1409     uint256 supply = totalSupply();
1410     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1411 
1412     for (uint256 i = 1; i <= _mintAmount; i++) {
1413       addressMintedBalance[destination]++;
1414       _safeMint(destination, supply + i);
1415     }
1416   }
1417 
1418   //PUBLIC VIEWS
1419   function isWhitelisted(address _user) public view returns (bool) {
1420     return whitelistedAddresses[_user];
1421   }
1422 
1423   function walletOfOwner(address _owner)
1424     public
1425     view
1426     returns (uint256[] memory)
1427   {
1428     uint256 ownerTokenCount = balanceOf(_owner);
1429     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1430     for (uint256 i; i < ownerTokenCount; i++) {
1431       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1432     }
1433     return tokenIds;
1434   }
1435 
1436   function tokenURI(uint256 tokenId)
1437     public
1438     view
1439     virtual
1440     override
1441     returns (string memory)
1442   {
1443     require(
1444       _exists(tokenId),
1445       "ERC721Metadata: URI query for nonexistent token"
1446     );
1447 
1448     if (!revealed) {
1449       return notRevealedUri;
1450     } else {
1451       string memory currentBaseURI = _baseURI();
1452       return
1453         bytes(currentBaseURI).length > 0
1454           ? string(
1455             abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
1456           )
1457           : "";
1458     }
1459   }
1460 
1461   function getCurrentCost() public view returns (uint256) {
1462     if (block.timestamp < preSaleEndDate) {
1463       return preSaleCost;
1464     } else {
1465       return cost;
1466     }
1467   }
1468 
1469   //ONLY OWNER VIEWS
1470   function getBaseURI() public view onlyOwner returns (string memory) {
1471     return baseURI;
1472   }
1473 
1474   function getContractBalance() public view onlyOwner returns (uint256) {
1475     return address(this).balance;
1476   }
1477 
1478   //ONLY OWNER SETTERS
1479   function reveal() public onlyOwner {
1480     revealed = true;
1481   }
1482 
1483   function pause(bool _state) public onlyOwner {
1484     paused = _state;
1485   }
1486 
1487   function setNftPerAddressLimitPreSale(uint256 _limit) public onlyOwner {
1488     nftPerAddressLimitPresale = _limit;
1489   }
1490 
1491   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1492     nftPerAddressLimit = _limit;
1493   }
1494 
1495   function setPresaleCost(uint256 _newCost) public onlyOwner {
1496     preSaleCost = _newCost;
1497   }
1498 
1499   function setCost(uint256 _newCost) public onlyOwner {
1500     cost = _newCost;
1501   }
1502 
1503   function setmaxMintAmountPreSale(uint256 _newmaxMintAmount) public onlyOwner {
1504     maxMintAmountPresale = _newmaxMintAmount;
1505   }
1506 
1507   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1508     maxMintAmount = _newmaxMintAmount;
1509   }
1510 
1511   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1512     baseURI = _newBaseURI;
1513   }
1514 
1515   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1516     baseExtension = _newBaseExtension;
1517   }
1518 
1519   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1520     notRevealedUri = _notRevealedURI;
1521   }
1522 
1523   function setPresaleMaxSupply(uint256 _newPresaleMaxSupply) public onlyOwner {
1524     preSaleMaxSupply = _newPresaleMaxSupply;
1525   }
1526 
1527   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1528     maxSupply = _maxSupply;
1529   }
1530 
1531   function setPreSaleDate(uint256 _preSaleDate) public onlyOwner {
1532     preSaleDate = _preSaleDate;
1533   }
1534 
1535   function setPreSaleEndDate(uint256 _preSaleEndDate) public onlyOwner {
1536     preSaleEndDate = _preSaleEndDate;
1537   }
1538 
1539   function setPublicSaleDate(uint256 _publicSaleDate) public onlyOwner {
1540     publicSaleDate = _publicSaleDate;
1541   }
1542 
1543   function whitelistUsers(address[] memory addresses) public onlyOwner {
1544     for (uint256 i = 0; i < addresses.length; i++) {
1545       whitelistedAddresses[addresses[i]] = true;
1546     }
1547   }
1548 
1549   function withdraw() public payable onlyOwner {
1550     (bool success, ) = payable(msg.sender).call{ value: address(this).balance }(
1551       ""
1552     );
1553     require(success);
1554   }
1555 }