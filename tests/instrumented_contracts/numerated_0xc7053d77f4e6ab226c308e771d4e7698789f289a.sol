1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-25
3 */
4 
5 /*
6 .______   .______          ___       __  .__   __.    .______    __    __   _______   _______  ____    ____ 
7 |   _  \  |   _  \        /   \     |  | |  \ |  |    |   _  \  |  |  |  | |       \ |       \ \   \  /   / 
8 |  |_)  | |  |_)  |      /  ^  \    |  | |   \|  |    |  |_)  | |  |  |  | |  .--.  ||  .--.  | \   \/   /  
9 |   _  <  |      /      /  /_\  \   |  | |  . `  |    |   _  <  |  |  |  | |  |  |  ||  |  |  |  \_    _/   
10 |  |_)  | |  |\  \----./  _____  \  |  | |  |\   |    |  |_)  | |  `--'  | |  '--'  ||  '--'  |    |  |     
11 |______/  | _| `._____/__/     \__\ |__| |__| \__|    |______/   \______/  |_______/ |_______/     |__|     
12                                                                                                             
13 
14 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.0
15 
16 // SPDX-License-Identifier: MIT
17 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Interface of the ERC165 standard, as defined in the
23  * https://eips.ethereum.org/EIPS/eip-165[EIP].
24  *
25  * Implementers can declare support of contract interfaces, which can then be
26  * queried by others ({ERC165Checker}).
27  *
28  * For an implementation, see {ERC165}.
29  */
30 interface IERC165 {
31     /**
32      * @dev Returns true if this contract implements the interface defined by
33      * `interfaceId`. See the corresponding
34      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
35      * to learn more about how these ids are created.
36      *
37      * This function call must use less than 30 000 gas.
38      */
39     function supportsInterface(bytes4 interfaceId) external view returns (bool);
40 }
41 
42 
43 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.0
44 
45 
46 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54     /**
55      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56      */
57     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187 
188 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.0
189 
190 
191 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @title ERC721 token receiver interface
197  * @dev Interface for any contract that wants to support safeTransfers
198  * from ERC721 asset contracts.
199  */
200 interface IERC721Receiver {
201     /**
202      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
203      * by `operator` from `from`, this function is called.
204      *
205      * It must return its Solidity selector to confirm the token transfer.
206      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
207      *
208      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
209      */
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 tokenId,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217 
218 
219 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.0
220 
221 
222 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Metadata is IERC721 {
231     /**
232      * @dev Returns the token collection name.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the token collection symbol.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
243      */
244     function tokenURI(uint256 tokenId) external view returns (string memory);
245 }
246 
247 
248 // File @openzeppelin/contracts/utils/Address.sol@v4.4.0
249 
250 
251 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize, which returns 0 for contracts in
278         // construction, since the code is only stored at the end of the
279         // constructor execution.
280 
281         uint256 size;
282         assembly {
283             size := extcodesize(account)
284         }
285         return size > 0;
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         (bool success, ) = recipient.call{value: amount}("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain `call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         require(isContract(target), "Address: call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.call{value: value}(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
392         return functionStaticCall(target, data, "Address: low-level static call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal view returns (bytes memory) {
406         require(isContract(target), "Address: static call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.staticcall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(isContract(target), "Address: delegate call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
441      * revert reason using the provided one.
442      *
443      * _Available since v4.3._
444      */
445     function verifyCallResult(
446         bool success,
447         bytes memory returndata,
448         string memory errorMessage
449     ) internal pure returns (bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 
469 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
470 
471 
472 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
497 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.0
498 
499 
500 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev String operations.
506  */
507 library Strings {
508     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
509 
510     /**
511      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
512      */
513     function toString(uint256 value) internal pure returns (string memory) {
514         // Inspired by OraclizeAPI's implementation - MIT licence
515         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
516 
517         if (value == 0) {
518             return "0";
519         }
520         uint256 temp = value;
521         uint256 digits;
522         while (temp != 0) {
523             digits++;
524             temp /= 10;
525         }
526         bytes memory buffer = new bytes(digits);
527         while (value != 0) {
528             digits -= 1;
529             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
530             value /= 10;
531         }
532         return string(buffer);
533     }
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
537      */
538     function toHexString(uint256 value) internal pure returns (string memory) {
539         if (value == 0) {
540             return "0x00";
541         }
542         uint256 temp = value;
543         uint256 length = 0;
544         while (temp != 0) {
545             length++;
546             temp >>= 8;
547         }
548         return toHexString(value, length);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
553      */
554     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
555         bytes memory buffer = new bytes(2 * length + 2);
556         buffer[0] = "0";
557         buffer[1] = "x";
558         for (uint256 i = 2 * length + 1; i > 1; --i) {
559             buffer[i] = _HEX_SYMBOLS[value & 0xf];
560             value >>= 4;
561         }
562         require(value == 0, "Strings: hex length insufficient");
563         return string(buffer);
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.0
569 
570 
571 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Implementation of the {IERC165} interface.
577  *
578  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
579  * for the additional interface id that will be supported. For example:
580  *
581  * ```solidity
582  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
584  * }
585  * ```
586  *
587  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
588  */
589 abstract contract ERC165 is IERC165 {
590     /**
591      * @dev See {IERC165-supportsInterface}.
592      */
593     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594         return interfaceId == type(IERC165).interfaceId;
595     }
596 }
597 
598 
599 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.0
600 
601 
602 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 
608 
609 
610 
611 
612 /**
613  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
614  * the Metadata extension, but not including the Enumerable extension, which is available separately as
615  * {ERC721Enumerable}.
616  */
617 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
618     using Address for address;
619     using Strings for uint256;
620 
621     // Token name
622     string private _name;
623 
624     // Token symbol
625     string private _symbol;
626 
627     // Mapping from token ID to owner address
628     mapping(uint256 => address) private _owners;
629 
630     // Mapping owner address to token count
631     mapping(address => uint256) private _balances;
632 
633     // Mapping from token ID to approved address
634     mapping(uint256 => address) private _tokenApprovals;
635 
636     // Mapping from owner to operator approvals
637     mapping(address => mapping(address => bool)) private _operatorApprovals;
638 
639     /**
640      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
641      */
642     constructor(string memory name_, string memory symbol_) {
643         _name = name_;
644         _symbol = symbol_;
645     }
646 
647     /**
648      * @dev See {IERC165-supportsInterface}.
649      */
650     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
651         return
652             interfaceId == type(IERC721).interfaceId ||
653             interfaceId == type(IERC721Metadata).interfaceId ||
654             super.supportsInterface(interfaceId);
655     }
656 
657     /**
658      * @dev See {IERC721-balanceOf}.
659      */
660     function balanceOf(address owner) public view virtual override returns (uint256) {
661         require(owner != address(0), "ERC721: balance query for the zero address");
662         return _balances[owner];
663     }
664 
665     /**
666      * @dev See {IERC721-ownerOf}.
667      */
668     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
669         address owner = _owners[tokenId];
670         require(owner != address(0), "ERC721: owner query for nonexistent token");
671         return owner;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-name}.
676      */
677     function name() public view virtual override returns (string memory) {
678         return _name;
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-symbol}.
683      */
684     function symbol() public view virtual override returns (string memory) {
685         return _symbol;
686     }
687 
688     /**
689      * @dev See {IERC721Metadata-tokenURI}.
690      */
691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
692         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
693 
694         string memory baseURI = _baseURI();
695         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
696     }
697 
698     /**
699      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
700      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
701      * by default, can be overriden in child contracts.
702      */
703     function _baseURI() internal view virtual returns (string memory) {
704         return "";
705     }
706 
707     /**
708      * @dev See {IERC721-approve}.
709      */
710     function approve(address to, uint256 tokenId) public virtual override {
711         address owner = ERC721.ownerOf(tokenId);
712         require(to != owner, "ERC721: approval to current owner");
713 
714         require(
715             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
716             "ERC721: approve caller is not owner nor approved for all"
717         );
718 
719         _approve(to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-getApproved}.
724      */
725     function getApproved(uint256 tokenId) public view virtual override returns (address) {
726         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
727 
728         return _tokenApprovals[tokenId];
729     }
730 
731     /**
732      * @dev See {IERC721-setApprovalForAll}.
733      */
734     function setApprovalForAll(address operator, bool approved) public virtual override {
735         _setApprovalForAll(_msgSender(), operator, approved);
736     }
737 
738     /**
739      * @dev See {IERC721-isApprovedForAll}.
740      */
741     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
742         return _operatorApprovals[owner][operator];
743     }
744 
745     /**
746      * @dev See {IERC721-transferFrom}.
747      */
748     function transferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         //solhint-disable-next-line max-line-length
754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
755 
756         _transfer(from, to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         safeTransferFrom(from, to, tokenId, "");
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) public virtual override {
779         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
780         _safeTransfer(from, to, tokenId, _data);
781     }
782 
783     /**
784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
786      *
787      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
788      *
789      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
790      * implement alternative mechanisms to perform token transfer, such as signature-based.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _safeTransfer(
802         address from,
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) internal virtual {
807         _transfer(from, to, tokenId);
808         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
809     }
810 
811     /**
812      * @dev Returns whether `tokenId` exists.
813      *
814      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
815      *
816      * Tokens start existing when they are minted (`_mint`),
817      * and stop existing when they are burned (`_burn`).
818      */
819     function _exists(uint256 tokenId) internal view virtual returns (bool) {
820         return _owners[tokenId] != address(0);
821     }
822 
823     /**
824      * @dev Returns whether `spender` is allowed to manage `tokenId`.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
831         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
832         address owner = ERC721.ownerOf(tokenId);
833         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
834     }
835 
836     /**
837      * @dev Safely mints `tokenId` and transfers it to `to`.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must not exist.
842      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _safeMint(address to, uint256 tokenId) internal virtual {
847         _safeMint(to, tokenId, "");
848     }
849 
850     /**
851      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
852      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
853      */
854     function _safeMint(
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) internal virtual {
859         _mint(to, tokenId);
860         require(
861             _checkOnERC721Received(address(0), to, tokenId, _data),
862             "ERC721: transfer to non ERC721Receiver implementer"
863         );
864     }
865 
866     /**
867      * @dev Mints `tokenId` and transfers it to `to`.
868      *
869      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
870      *
871      * Requirements:
872      *
873      * - `tokenId` must not exist.
874      * - `to` cannot be the zero address.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _mint(address to, uint256 tokenId) internal virtual {
879         require(to != address(0), "ERC721: mint to the zero address");
880         require(!_exists(tokenId), "ERC721: token already minted");
881 
882         _beforeTokenTransfer(address(0), to, tokenId);
883 
884         _balances[to] += 1;
885         _owners[tokenId] = to;
886 
887         emit Transfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _burn(uint256 tokenId) internal virtual {
901         address owner = ERC721.ownerOf(tokenId);
902 
903         _beforeTokenTransfer(owner, address(0), tokenId);
904 
905         // Clear approvals
906         _approve(address(0), tokenId);
907 
908         _balances[owner] -= 1;
909         delete _owners[tokenId];
910 
911         emit Transfer(owner, address(0), tokenId);
912     }
913 
914     /**
915      * @dev Transfers `tokenId` from `from` to `to`.
916      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
917      *
918      * Requirements:
919      *
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must be owned by `from`.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _transfer(
926         address from,
927         address to,
928         uint256 tokenId
929     ) internal virtual {
930         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
931         require(to != address(0), "ERC721: transfer to the zero address");
932 
933         _beforeTokenTransfer(from, to, tokenId);
934 
935         // Clear approvals from the previous owner
936         _approve(address(0), tokenId);
937 
938         _balances[from] -= 1;
939         _balances[to] += 1;
940         _owners[tokenId] = to;
941 
942         emit Transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev Approve `to` to operate on `tokenId`
947      *
948      * Emits a {Approval} event.
949      */
950     function _approve(address to, uint256 tokenId) internal virtual {
951         _tokenApprovals[tokenId] = to;
952         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
953     }
954 
955     /**
956      * @dev Approve `operator` to operate on all of `owner` tokens
957      *
958      * Emits a {ApprovalForAll} event.
959      */
960     function _setApprovalForAll(
961         address owner,
962         address operator,
963         bool approved
964     ) internal virtual {
965         require(owner != operator, "ERC721: approve to caller");
966         _operatorApprovals[owner][operator] = approved;
967         emit ApprovalForAll(owner, operator, approved);
968     }
969 
970     /**
971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
972      * The call is not executed if the target address is not a contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
988                 return retval == IERC721Receiver.onERC721Received.selector;
989             } catch (bytes memory reason) {
990                 if (reason.length == 0) {
991                     revert("ERC721: transfer to non ERC721Receiver implementer");
992                 } else {
993                     assembly {
994                         revert(add(32, reason), mload(reason))
995                     }
996                 }
997             }
998         } else {
999             return true;
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any token transfer. This includes minting
1005      * and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1013      * - `from` and `to` are never both zero.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {}
1022 }
1023 
1024 
1025 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.0
1026 
1027 
1028 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 /**
1033  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1034  * @dev See https://eips.ethereum.org/EIPS/eip-721
1035  */
1036 interface IERC721Enumerable is IERC721 {
1037     /**
1038      * @dev Returns the total amount of tokens stored by the contract.
1039      */
1040     function totalSupply() external view returns (uint256);
1041 
1042     /**
1043      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1044      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1047 
1048     /**
1049      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1050      * Use along with {totalSupply} to enumerate all tokens.
1051      */
1052     function tokenByIndex(uint256 index) external view returns (uint256);
1053 }
1054 
1055 
1056 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.0
1057 
1058 
1059 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 
1064 /**
1065  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1066  * enumerability of all the token ids in the contract as well as all token ids owned by each
1067  * account.
1068  */
1069 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1070     // Mapping from owner to list of owned token IDs
1071     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1072 
1073     // Mapping from token ID to index of the owner tokens list
1074     mapping(uint256 => uint256) private _ownedTokensIndex;
1075 
1076     // Array with all token ids, used for enumeration
1077     uint256[] private _allTokens;
1078 
1079     // Mapping from token id to position in the allTokens array
1080     mapping(uint256 => uint256) private _allTokensIndex;
1081 
1082     /**
1083      * @dev See {IERC165-supportsInterface}.
1084      */
1085     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1086         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1091      */
1092     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1093         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1094         return _ownedTokens[owner][index];
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-totalSupply}.
1099      */
1100     function totalSupply() public view virtual override returns (uint256) {
1101         return _allTokens.length;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-tokenByIndex}.
1106      */
1107     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1108         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1109         return _allTokens[index];
1110     }
1111 
1112     /**
1113      * @dev Hook that is called before any token transfer. This includes minting
1114      * and burning.
1115      *
1116      * Calling conditions:
1117      *
1118      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1119      * transferred to `to`.
1120      * - When `from` is zero, `tokenId` will be minted for `to`.
1121      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) internal virtual override {
1132         super._beforeTokenTransfer(from, to, tokenId);
1133 
1134         if (from == address(0)) {
1135             _addTokenToAllTokensEnumeration(tokenId);
1136         } else if (from != to) {
1137             _removeTokenFromOwnerEnumeration(from, tokenId);
1138         }
1139         if (to == address(0)) {
1140             _removeTokenFromAllTokensEnumeration(tokenId);
1141         } else if (to != from) {
1142             _addTokenToOwnerEnumeration(to, tokenId);
1143         }
1144     }
1145 
1146     /**
1147      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1148      * @param to address representing the new owner of the given token ID
1149      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1150      */
1151     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1152         uint256 length = ERC721.balanceOf(to);
1153         _ownedTokens[to][length] = tokenId;
1154         _ownedTokensIndex[tokenId] = length;
1155     }
1156 
1157     /**
1158      * @dev Private function to add a token to this extension's token tracking data structures.
1159      * @param tokenId uint256 ID of the token to be added to the tokens list
1160      */
1161     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1162         _allTokensIndex[tokenId] = _allTokens.length;
1163         _allTokens.push(tokenId);
1164     }
1165 
1166     /**
1167      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1168      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1169      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1170      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1171      * @param from address representing the previous owner of the given token ID
1172      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1173      */
1174     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1175         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1176         // then delete the last slot (swap and pop).
1177 
1178         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1179         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1180 
1181         // When the token to delete is the last token, the swap operation is unnecessary
1182         if (tokenIndex != lastTokenIndex) {
1183             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1184 
1185             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1186             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1187         }
1188 
1189         // This also deletes the contents at the last position of the array
1190         delete _ownedTokensIndex[tokenId];
1191         delete _ownedTokens[from][lastTokenIndex];
1192     }
1193 
1194     /**
1195      * @dev Private function to remove a token from this extension's token tracking data structures.
1196      * This has O(1) time complexity, but alters the order of the _allTokens array.
1197      * @param tokenId uint256 ID of the token to be removed from the tokens list
1198      */
1199     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1200         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1201         // then delete the last slot (swap and pop).
1202 
1203         uint256 lastTokenIndex = _allTokens.length - 1;
1204         uint256 tokenIndex = _allTokensIndex[tokenId];
1205 
1206         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1207         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1208         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1209         uint256 lastTokenId = _allTokens[lastTokenIndex];
1210 
1211         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213 
1214         // This also deletes the contents at the last position of the array
1215         delete _allTokensIndex[tokenId];
1216         _allTokens.pop();
1217     }
1218 }
1219 
1220 
1221 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.0
1222 
1223 
1224 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 // CAUTION
1229 // This version of SafeMath should only be used with Solidity 0.8 or later,
1230 // because it relies on the compiler's built in overflow checks.
1231 
1232 /**
1233  * @dev Wrappers over Solidity's arithmetic operations.
1234  *
1235  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1236  * now has built in overflow checking.
1237  */
1238 library SafeMath {
1239     /**
1240      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1241      *
1242      * _Available since v3.4._
1243      */
1244     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1245         unchecked {
1246             uint256 c = a + b;
1247             if (c < a) return (false, 0);
1248             return (true, c);
1249         }
1250     }
1251 
1252     /**
1253      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1254      *
1255      * _Available since v3.4._
1256      */
1257     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1258         unchecked {
1259             if (b > a) return (false, 0);
1260             return (true, a - b);
1261         }
1262     }
1263 
1264     /**
1265      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1266      *
1267      * _Available since v3.4._
1268      */
1269     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1270         unchecked {
1271             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1272             // benefit is lost if 'b' is also tested.
1273             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1274             if (a == 0) return (true, 0);
1275             uint256 c = a * b;
1276             if (c / a != b) return (false, 0);
1277             return (true, c);
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1283      *
1284      * _Available since v3.4._
1285      */
1286     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1287         unchecked {
1288             if (b == 0) return (false, 0);
1289             return (true, a / b);
1290         }
1291     }
1292 
1293     /**
1294      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1295      *
1296      * _Available since v3.4._
1297      */
1298     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1299         unchecked {
1300             if (b == 0) return (false, 0);
1301             return (true, a % b);
1302         }
1303     }
1304 
1305     /**
1306      * @dev Returns the addition of two unsigned integers, reverting on
1307      * overflow.
1308      *
1309      * Counterpart to Solidity's `+` operator.
1310      *
1311      * Requirements:
1312      *
1313      * - Addition cannot overflow.
1314      */
1315     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1316         return a + b;
1317     }
1318 
1319     /**
1320      * @dev Returns the subtraction of two unsigned integers, reverting on
1321      * overflow (when the result is negative).
1322      *
1323      * Counterpart to Solidity's `-` operator.
1324      *
1325      * Requirements:
1326      *
1327      * - Subtraction cannot overflow.
1328      */
1329     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1330         return a - b;
1331     }
1332 
1333     /**
1334      * @dev Returns the multiplication of two unsigned integers, reverting on
1335      * overflow.
1336      *
1337      * Counterpart to Solidity's `*` operator.
1338      *
1339      * Requirements:
1340      *
1341      * - Multiplication cannot overflow.
1342      */
1343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1344         return a * b;
1345     }
1346 
1347     /**
1348      * @dev Returns the integer division of two unsigned integers, reverting on
1349      * division by zero. The result is rounded towards zero.
1350      *
1351      * Counterpart to Solidity's `/` operator.
1352      *
1353      * Requirements:
1354      *
1355      * - The divisor cannot be zero.
1356      */
1357     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1358         return a / b;
1359     }
1360 
1361     /**
1362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1363      * reverting when dividing by zero.
1364      *
1365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1366      * opcode (which leaves remaining gas untouched) while Solidity uses an
1367      * invalid opcode to revert (consuming all remaining gas).
1368      *
1369      * Requirements:
1370      *
1371      * - The divisor cannot be zero.
1372      */
1373     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1374         return a % b;
1375     }
1376 
1377     /**
1378      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1379      * overflow (when the result is negative).
1380      *
1381      * CAUTION: This function is deprecated because it requires allocating memory for the error
1382      * message unnecessarily. For custom revert reasons use {trySub}.
1383      *
1384      * Counterpart to Solidity's `-` operator.
1385      *
1386      * Requirements:
1387      *
1388      * - Subtraction cannot overflow.
1389      */
1390     function sub(
1391         uint256 a,
1392         uint256 b,
1393         string memory errorMessage
1394     ) internal pure returns (uint256) {
1395         unchecked {
1396             require(b <= a, errorMessage);
1397             return a - b;
1398         }
1399     }
1400 
1401     /**
1402      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1403      * division by zero. The result is rounded towards zero.
1404      *
1405      * Counterpart to Solidity's `/` operator. Note: this function uses a
1406      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1407      * uses an invalid opcode to revert (consuming all remaining gas).
1408      *
1409      * Requirements:
1410      *
1411      * - The divisor cannot be zero.
1412      */
1413     function div(
1414         uint256 a,
1415         uint256 b,
1416         string memory errorMessage
1417     ) internal pure returns (uint256) {
1418         unchecked {
1419             require(b > 0, errorMessage);
1420             return a / b;
1421         }
1422     }
1423 
1424     /**
1425      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1426      * reverting with custom message when dividing by zero.
1427      *
1428      * CAUTION: This function is deprecated because it requires allocating memory for the error
1429      * message unnecessarily. For custom revert reasons use {tryMod}.
1430      *
1431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1432      * opcode (which leaves remaining gas untouched) while Solidity uses an
1433      * invalid opcode to revert (consuming all remaining gas).
1434      *
1435      * Requirements:
1436      *
1437      * - The divisor cannot be zero.
1438      */
1439     function mod(
1440         uint256 a,
1441         uint256 b,
1442         string memory errorMessage
1443     ) internal pure returns (uint256) {
1444         unchecked {
1445             require(b > 0, errorMessage);
1446             return a % b;
1447         }
1448     }
1449 }
1450 
1451 
1452 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
1453 
1454 
1455 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1456 
1457 pragma solidity ^0.8.0;
1458 
1459 /**
1460  * @dev Contract module which provides a basic access control mechanism, where
1461  * there is an account (an owner) that can be granted exclusive access to
1462  * specific functions.
1463  *
1464  * By default, the owner account will be the one that deploys the contract. This
1465  * can later be changed with {transferOwnership}.
1466  *
1467  * This module is used through inheritance. It will make available the modifier
1468  * `onlyOwner`, which can be applied to your functions to restrict their use to
1469  * the owner.
1470  */
1471 abstract contract Ownable is Context {
1472     address private _owner;
1473 
1474     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1475 
1476     /**
1477      * @dev Initializes the contract setting the deployer as the initial owner.
1478      */
1479     constructor() {
1480         _transferOwnership(_msgSender());
1481     }
1482 
1483     /**
1484      * @dev Returns the address of the current owner.
1485      */
1486     function owner() public view virtual returns (address) {
1487         return _owner;
1488     }
1489 
1490     /**
1491      * @dev Throws if called by any account other than the owner.
1492      */
1493     modifier onlyOwner() {
1494         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1495         _;
1496     }
1497 
1498     /**
1499      * @dev Leaves the contract without owner. It will not be possible to call
1500      * `onlyOwner` functions anymore. Can only be called by the current owner.
1501      *
1502      * NOTE: Renouncing ownership will leave the contract without an owner,
1503      * thereby removing any functionality that is only available to the owner.
1504      */
1505     function renounceOwnership() public virtual onlyOwner {
1506         _transferOwnership(address(0));
1507     }
1508 
1509     /**
1510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1511      * Can only be called by the current owner.
1512      */
1513     function transferOwnership(address newOwner) public virtual onlyOwner {
1514         require(newOwner != address(0), "Ownable: new owner is the zero address");
1515         _transferOwnership(newOwner);
1516     }
1517 
1518     /**
1519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1520      * Internal function without access restriction.
1521      */
1522     function _transferOwnership(address newOwner) internal virtual {
1523         address oldOwner = _owner;
1524         _owner = newOwner;
1525         emit OwnershipTransferred(oldOwner, newOwner);
1526     }
1527 }
1528 
1529 
1530 // File @openzeppelin/contracts/security/Pausable.sol@v4.4.0
1531 
1532 
1533 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
1534 
1535 pragma solidity ^0.8.0;
1536 
1537 /**
1538  * @dev Contract module which allows children to implement an emergency stop
1539  * mechanism that can be triggered by an authorized account.
1540  *
1541  * This module is used through inheritance. It will make available the
1542  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1543  * the functions of your contract. Note that they will not be pausable by
1544  * simply including this module, only once the modifiers are put in place.
1545  */
1546 abstract contract Pausable is Context {
1547     /**
1548      * @dev Emitted when the pause is triggered by `account`.
1549      */
1550     event Paused(address account);
1551 
1552     /**
1553      * @dev Emitted when the pause is lifted by `account`.
1554      */
1555     event Unpaused(address account);
1556 
1557     bool private _paused;
1558 
1559     /**
1560      * @dev Initializes the contract in unpaused state.
1561      */
1562     constructor() {
1563         _paused = false;
1564     }
1565 
1566     /**
1567      * @dev Returns true if the contract is paused, and false otherwise.
1568      */
1569     function paused() public view virtual returns (bool) {
1570         return _paused;
1571     }
1572 
1573     /**
1574      * @dev Modifier to make a function callable only when the contract is not paused.
1575      *
1576      * Requirements:
1577      *
1578      * - The contract must not be paused.
1579      */
1580     modifier whenNotPaused() {
1581         require(!paused(), "Pausable: paused");
1582         _;
1583     }
1584 
1585     /**
1586      * @dev Modifier to make a function callable only when the contract is paused.
1587      *
1588      * Requirements:
1589      *
1590      * - The contract must be paused.
1591      */
1592     modifier whenPaused() {
1593         require(paused(), "Pausable: not paused");
1594         _;
1595     }
1596 
1597     /**
1598      * @dev Triggers stopped state.
1599      *
1600      * Requirements:
1601      *
1602      * - The contract must not be paused.
1603      */
1604     function _pause() internal virtual whenNotPaused {
1605         _paused = true;
1606         emit Paused(_msgSender());
1607     }
1608 
1609     /**
1610      * @dev Returns to normal state.
1611      *
1612      * Requirements:
1613      *
1614      * - The contract must be paused.
1615      */
1616     function _unpause() internal virtual whenPaused {
1617         _paused = false;
1618         emit Unpaused(_msgSender());
1619     }
1620 }
1621 
1622 
1623 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.0
1624 
1625 
1626 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1627 
1628 pragma solidity ^0.8.0;
1629 
1630 /**
1631  * @dev Contract module that helps prevent reentrant calls to a function.
1632  *
1633  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1634  * available, which can be applied to functions to make sure there are no nested
1635  * (reentrant) calls to them.
1636  *
1637  * Note that because there is a single `nonReentrant` guard, functions marked as
1638  * `nonReentrant` may not call one another. This can be worked around by making
1639  * those functions `private`, and then adding `external` `nonReentrant` entry
1640  * points to them.
1641  *
1642  * TIP: If you would like to learn more about reentrancy and alternative ways
1643  * to protect against it, check out our blog post
1644  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1645  */
1646 abstract contract ReentrancyGuard {
1647     // Booleans are more expensive than uint256 or any type that takes up a full
1648     // word because each write operation emits an extra SLOAD to first read the
1649     // slot's contents, replace the bits taken up by the boolean, and then write
1650     // back. This is the compiler's defense against contract upgrades and
1651     // pointer aliasing, and it cannot be disabled.
1652 
1653     // The values being non-zero value makes deployment a bit more expensive,
1654     // but in exchange the refund on every call to nonReentrant will be lower in
1655     // amount. Since refunds are capped to a percentage of the total
1656     // transaction's gas, it is best to keep them low in cases like this one, to
1657     // increase the likelihood of the full refund coming into effect.
1658     uint256 private constant _NOT_ENTERED = 1;
1659     uint256 private constant _ENTERED = 2;
1660 
1661     uint256 private _status;
1662 
1663     constructor() {
1664         _status = _NOT_ENTERED;
1665     }
1666 
1667     /**
1668      * @dev Prevents a contract from calling itself, directly or indirectly.
1669      * Calling a `nonReentrant` function from another `nonReentrant`
1670      * function is not supported. It is possible to prevent this from happening
1671      * by making the `nonReentrant` function external, and making it call a
1672      * `private` function that does the actual work.
1673      */
1674     modifier nonReentrant() {
1675         // On the first call to nonReentrant, _notEntered will be true
1676         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1677 
1678         // Any calls to nonReentrant after this point will fail
1679         _status = _ENTERED;
1680 
1681         _;
1682 
1683         // By storing the original value once again, a refund is triggered (see
1684         // https://eips.ethereum.org/EIPS/eip-2200)
1685         _status = _NOT_ENTERED;
1686     }
1687 }
1688 
1689 
1690 interface ILOBE {
1691     function burn(address from, uint256 amount) external;
1692     function mint(address to, uint256 amount) external;
1693 }
1694 
1695 interface IStakingToken {
1696     function update(address from, address to) external;
1697 }
1698 
1699 // File contracts/Brainbuddy.sol
1700 
1701 pragma solidity ^0.8.4;
1702 
1703 
1704 
1705 
1706 
1707 
1708 contract Brainbuddy is ERC721Enumerable, ReentrancyGuard, Ownable, Pausable {
1709     using SafeMath for uint256;
1710     using Strings for uint256;
1711 
1712     struct BrainBuddyInfo {
1713         string name;
1714         string description;
1715     }
1716 
1717     mapping(uint256 => BrainBuddyInfo) public buddyInfo;
1718 
1719     uint256 public RESERVE_NFT = 100;     // Expected to use last 100 tokenIDs.
1720     uint256 public LOBE_Mint_NFT = 2310;
1721     uint256 public ETH_Mint_NFT = 7590;
1722     uint256 public constant MAX_NFT = 10000;
1723 
1724     uint256 public LOBE_PRICE = 3000 ether;
1725     uint256 public ETH_PRICE = 0.02 ether;
1726     uint256 public VIP_ETH_PRICE = 0.01 ether;
1727     uint256 public UPDATE_NAME_PRICE = 2000 ether;
1728     uint256 public UPDATE_DESCRIPTION_PRICE = 2000 ether;
1729 
1730     uint256 public PURCHASE_LIMIT = 50;
1731 
1732     uint256 public totalLOBEMinted;
1733     uint256 public totalETHMinted;
1734     uint256 public totalReserveClaimed;
1735     uint256 public publicMintPosition;
1736 
1737     string public baseURI;
1738     string public blindURI;
1739 
1740     bool public isPublicSaleActive;
1741     bool public isReveal;
1742 
1743     ILOBE public LOBEContract;
1744     IStakingToken public stakingTokenContract;
1745 
1746     mapping(address => uint256) public publicSaleClaimed;
1747 
1748     mapping(address => uint256[]) public giveaway;
1749 
1750     mapping(address => bool) public isVIP;
1751 
1752     address public communityTreasuryWallet;
1753     address public LOBELiquidityWallet;
1754 
1755     event UpdateName(uint256 indexed tokenId, string name);
1756     event UpdateDescription(uint256 indexed tokenId, string description);
1757 
1758     constructor(address _community, address _liquidity, address _LOBE) ERC721("BrainBuddies", "BB") {
1759         communityTreasuryWallet = _community;
1760         LOBELiquidityWallet = _liquidity;
1761         LOBEContract = ILOBE(_LOBE);
1762     }    
1763 
1764     // Function to start main sale
1765     function changePublicSaleStatus(bool _status) external onlyOwner {
1766         isPublicSaleActive = _status;
1767     }    
1768 
1769     // Function to reveal all NFTs
1770     function changeRevealStatus(bool _status) external onlyOwner {
1771         isReveal = _status;
1772     }  
1773 
1774     // Function to change LOBE mint price
1775     function changeLOBEPrice(uint256 amount) external onlyOwner {
1776         LOBE_PRICE = amount;
1777     }   
1778 
1779     // Function to change ETH mint price
1780     function changeETHPrice(uint256 amount) external onlyOwner {
1781         ETH_PRICE = amount;
1782     }    
1783 
1784     // Function to change VIP ETH mint price
1785     function changeVIPETHPrice(uint256 amount) external onlyOwner {
1786         VIP_ETH_PRICE = amount;
1787     } 
1788 
1789     // Function to change UPDATE name and description price
1790     function changeUpdateNameAndDescriptionPrice(uint256 _name, uint256 _description) external onlyOwner {
1791         UPDATE_NAME_PRICE = _name;
1792         UPDATE_DESCRIPTION_PRICE = _description;
1793     } 
1794 
1795     // Function to change max mint per wallet
1796     function changePurchaseLimit(uint256 amount) external onlyOwner {
1797         PURCHASE_LIMIT = amount;
1798     }   
1799 
1800     // Function to change LOBE mint to giveway
1801     function changeLOBEToGiveway(uint256 amount) external onlyOwner {
1802         require(totalLOBEMinted.add(amount) <= LOBE_Mint_NFT, "Amount exceed available.");
1803         LOBE_Mint_NFT = LOBE_Mint_NFT.sub(amount);
1804         RESERVE_NFT = RESERVE_NFT.add(amount);
1805     } 
1806 
1807     // Function to change ETH mint to giveway
1808     function changeETHToGiveway(uint256 amount) external onlyOwner {
1809         require(totalETHMinted.add(amount) <= ETH_Mint_NFT, "Amount exceed available.");
1810         ETH_Mint_NFT = ETH_Mint_NFT.sub(amount);
1811         RESERVE_NFT = RESERVE_NFT.add(amount);
1812     } 
1813     
1814     // Function VIP access to to addresses
1815     function giveVIPAccess(address[] memory _addresses) external onlyOwner {
1816         for (uint256 i = 0; i < _addresses.length; i++) {
1817             isVIP[_addresses[i]] = true;
1818         }
1819     }
1820 
1821     // Function to set giveaway users
1822     function setGiveawayUsers(address[] memory _to, uint256[] memory _tokenIds) external onlyOwner {
1823         require(_to.length == _tokenIds.length, "array size mismatch");
1824         for(uint256 i = 0; i < _to.length; i++) {
1825             require(_tokenIds[i] >= MAX_NFT - RESERVE_NFT, "Giveaway tokenID must be set from Reserved IDs which are lastest");            
1826             giveaway[_to[i]].push(_tokenIds[i]);
1827         }
1828     }
1829 
1830     // Function to set $LOBE and future staking token address
1831     function setContractAddresses(address _lobe, address _stakingToken) external onlyOwner {
1832         LOBEContract = ILOBE(_lobe);
1833         stakingTokenContract = IStakingToken(_stakingToken);
1834     }
1835     
1836     // Function to set Base and Blind URI
1837     function setURIs(string memory _blindURI, string memory _URI) external onlyOwner {
1838         blindURI = _blindURI;
1839         baseURI = _URI;        
1840     }
1841 
1842     // Function to update name
1843     function updateName(uint256 tokenId, string calldata name) external  {
1844         require(ownerOf(tokenId) == msg.sender, "Caller must be token owner");
1845         require(address(LOBEContract) != address(0), "No token contract set");
1846 
1847         bytes memory n = bytes(name);
1848         require(n.length > 0 && n.length < 25, "Invalid name length");
1849         require(
1850         sha256(n) != sha256(bytes(buddyInfo[tokenId].name)),
1851         "New name is same as current name"
1852         );
1853 
1854         LOBEContract.burn(msg.sender, UPDATE_NAME_PRICE);
1855         LOBEContract.mint(LOBELiquidityWallet, UPDATE_NAME_PRICE.div(100).mul(30));
1856         buddyInfo[tokenId].name = name;
1857         emit UpdateName(tokenId, name);
1858     }
1859 
1860     // Function to update description
1861     function updateDescription(uint256 tokenId, string calldata description) external  {
1862         require(ownerOf(tokenId) == msg.sender, "Caller must be token owner");
1863         require(address(LOBEContract) != address(0), "No token contract set");
1864 
1865         bytes memory d = bytes(description);
1866         require(d.length > 0 && d.length < 280, "Invalid description length");
1867         require(
1868             sha256(bytes(d)) != sha256(bytes(buddyInfo[tokenId].description)),
1869             "New description is same as current description"
1870         );
1871 
1872         LOBEContract.burn(msg.sender, UPDATE_DESCRIPTION_PRICE);
1873         LOBEContract.mint(LOBELiquidityWallet, UPDATE_DESCRIPTION_PRICE.div(100).mul(30));
1874         buddyInfo[tokenId].description = description;
1875         emit UpdateDescription(tokenId, description);
1876     }
1877 
1878     //Function to withdraw collected amount during minting by the owner
1879     function withdraw(address _to, uint256 _amount) external onlyOwner {
1880         uint256 balance = address(this).balance;
1881         require(balance >= _amount, "Balance should atleast equal to amount");
1882         payable(_to).transfer(_amount);
1883     }    
1884 
1885     // Function to mint using LOBE
1886     function mintWithLOBE(uint256 _numOfTokens) public whenNotPaused nonReentrant {
1887         require(address(LOBEContract) != address(0), "No token contract set");
1888         require(isPublicSaleActive==true, "Sale Not Active");        
1889         require(totalLOBEMinted.add(_numOfTokens) <= LOBE_Mint_NFT, "Purchase would exceed max LOBE mint NFTs");
1890         LOBEContract.burn(msg.sender, _numOfTokens.mul(LOBE_PRICE));
1891         LOBEContract.mint(LOBELiquidityWallet, _numOfTokens.mul(LOBE_PRICE).div(100).mul(30));
1892         for(uint256 i = 0; i < _numOfTokens; i++) {
1893             _mint(msg.sender, publicMintPosition);
1894             publicMintPosition = publicMintPosition.add(1);
1895         }
1896         totalLOBEMinted = totalLOBEMinted.add(_numOfTokens);        
1897     }
1898 
1899     // Function to adjust public mint position
1900     function updatePublicMintPosition (uint256 pos) external onlyOwner {
1901         publicMintPosition = pos;
1902     }
1903 
1904     // Function to mint using ETH
1905     function mintWithETH(uint256 _numOfTokens) public payable whenNotPaused nonReentrant {
1906         require(isPublicSaleActive==true, "Sale Not Active");
1907         require(publicSaleClaimed[msg.sender].add(_numOfTokens) <= PURCHASE_LIMIT, 
1908             "Above Sale Purchase Limit");
1909         require(totalETHMinted.add(_numOfTokens) <= ETH_Mint_NFT, "Purchase would exceed max ETH mint NFTs");
1910         if (isVIP[msg.sender]){
1911             require(VIP_ETH_PRICE.mul(_numOfTokens) == msg.value, "Invalid Amount");
1912         } else {
1913             require(ETH_PRICE.mul(_numOfTokens) == msg.value, "Invalid Amount");
1914         }
1915         for(uint256 i = 0; i < _numOfTokens; i++) {
1916             _mint(msg.sender, publicMintPosition);
1917             publicMintPosition = publicMintPosition.add(1);
1918         }
1919         totalETHMinted = totalETHMinted.add(_numOfTokens);
1920         publicSaleClaimed[msg.sender] = publicSaleClaimed[msg.sender].add(_numOfTokens);
1921     }
1922 
1923     // Function to claim giveaway
1924     function claimGiveaway() external whenNotPaused nonReentrant {
1925         for(uint256 i=0; i < giveaway[msg.sender].length; i++) {            
1926             _safeMint(msg.sender, giveaway[msg.sender][i]);
1927             totalReserveClaimed = totalReserveClaimed.add(1);
1928         }
1929     }
1930 
1931     // Function to airdrop unclaimed
1932     function airdropNFT(address _to, uint256[] memory _tokenIds) external onlyOwner {
1933         for(uint256 i=0; i < _tokenIds.length; i++) {            
1934             require(_tokenIds[i] >= MAX_NFT - RESERVE_NFT, "Airdrop tokenID must be set from Reserved IDs which are lastest");
1935             _safeMint(_to, _tokenIds[i]);
1936             totalReserveClaimed = totalReserveClaimed.add(1);
1937         }
1938     }
1939 
1940     // Function to migrate from past contract
1941     function mirrorDropNFT(address[] memory _to, uint256[] memory _tokenIds) external onlyOwner {
1942         uint256 holderIndex = 0;
1943         for(uint256 i = 0; i < _tokenIds.length; i++) {      
1944             if (_tokenIds[i] == 11111111){
1945                 holderIndex ++;
1946             } else {                
1947                 _safeMint(_to[holderIndex], _tokenIds[i]);
1948             }            
1949         }
1950     }
1951     
1952     // Function to get token URI of given token ID
1953     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1954         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1955         if (!isReveal) {
1956             return string(abi.encodePacked(blindURI, _tokenId.toString()));
1957         } else {
1958             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1959         }
1960     }    
1961 
1962     // Function to list own NFTs 
1963     function listMyNFTs(address _owner) public view returns(uint256[] memory) {
1964         uint256 tokenCount = balanceOf(_owner);
1965 
1966         if (tokenCount == 0) {
1967             return new uint256[](0);
1968     	}
1969     	else {
1970     		uint256[] memory tokensId = new uint256[](tokenCount);
1971             for(uint256 i = 0; i < tokenCount; i++){
1972                 tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1973             }
1974             return tokensId;
1975     	}        
1976     }
1977 
1978     // Function to get ETH mint price
1979     function getETHmintPrice() public view returns(uint256) {
1980         return isVIP[msg.sender] ? VIP_ETH_PRICE : ETH_PRICE;
1981     }
1982 
1983     // Function to pause 
1984     function pause() external onlyOwner {
1985         _pause();
1986     }
1987 
1988     // Function to unpause 
1989     function unpause() external onlyOwner {
1990         _unpause();
1991     }
1992 
1993     function transferFrom(address from, address to, uint256 tokenId)
1994         public        
1995         override(ERC721)
1996         nonReentrant
1997     {
1998         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1999 
2000         if (address(stakingTokenContract) != address(0)) {
2001             stakingTokenContract.update(from, to);
2002         }
2003 
2004         ERC721.transferFrom(from, to, tokenId);
2005     }
2006 
2007     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2008         public
2009         override(ERC721)
2010         nonReentrant
2011     {
2012         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2013 
2014         if (address(stakingTokenContract) != address(0)) {
2015             stakingTokenContract.update(from, to);
2016         }
2017 
2018         ERC721.safeTransferFrom(from, to, tokenId, data);
2019     }
2020 }