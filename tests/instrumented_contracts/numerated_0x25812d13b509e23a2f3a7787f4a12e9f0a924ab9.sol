1 // SPDX-License-Identifier: MIT
2 
3 // Contract by S_V.
4 //
5 //
6 // 
7 // ***not iconic***
8 // Counterculture art project of 1974 artwork 1/1, created from analog frames and modified with computer graphics.
9 // 1974 NFT
10 // Free mint
11 // max 2 for tx 
12 //
13 //
14 //
15 /**
16     !Disclaimer!
17     These contracts have been used to create tutorials,
18     and was created for the purpose to teach people
19     how to create smart contracts on the blockchain.
20     please review this code on your own before using any of
21     the following code for production.
22     HashLips will not be liable in any way if for the use 
23     of the code. That being said, the code has been tested 
24     to the best of the developers' knowledge to work as intended.
25 */
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 pragma solidity ^0.8.0;
29 /**
30  * @dev Interface of the ERC165 standard, as defined in the
31  * https://eips.ethereum.org/EIPS/eip-165[EIP].
32  *
33  * Implementers can declare support of contract interfaces, which can then be
34  * queried by others ({ERC165Checker}).
35  *
36  * For an implementation, see {ERC165}.
37  */
38 interface IERC165 {
39     /**
40      * @dev Returns true if this contract implements the interface defined by
41      * `interfaceId`. See the corresponding
42      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
43      * to learn more about how these ids are created.
44      *
45      * This function call must use less than 30 000 gas.
46      */
47     function supportsInterface(bytes4 interfaceId) external view returns (bool);
48 }
49 
50 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
51 pragma solidity ^0.8.0;
52 /**
53  * @dev Required interface of an ERC721 compliant contract.
54  */
55 interface IERC721 is IERC165 {
56     /**
57      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
58      */
59     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
63      */
64     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
68      */
69     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
70 
71     /**
72      * @dev Returns the number of tokens in ``owner``'s account.
73      */
74     function balanceOf(address owner) external view returns (uint256 balance);
75 
76     /**
77      * @dev Returns the owner of the `tokenId` token.
78      *
79      * Requirements:
80      *
81      * - `tokenId` must exist.
82      */
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 }
188 
189 
190 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
191 pragma solidity ^0.8.0;
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Enumerable is IERC721 {
197     /**
198      * @dev Returns the total amount of tokens stored by the contract.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
204      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
205      */
206     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
207 
208     /**
209      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
210      * Use along with {totalSupply} to enumerate all tokens.
211      */
212     function tokenByIndex(uint256 index) external view returns (uint256);
213 }
214 
215 
216 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
217 pragma solidity ^0.8.0;
218 /**
219  * @dev Implementation of the {IERC165} interface.
220  *
221  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
222  * for the additional interface id that will be supported. For example:
223  *
224  * ```solidity
225  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
226  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
227  * }
228  * ```
229  *
230  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
231  */
232 abstract contract ERC165 is IERC165 {
233     /**
234      * @dev See {IERC165-supportsInterface}.
235      */
236     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
237         return interfaceId == type(IERC165).interfaceId;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Strings.sol
242 
243 
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev String operations.
249  */
250 library Strings {
251     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
255      */
256     function toString(uint256 value) internal pure returns (string memory) {
257         // Inspired by OraclizeAPI's implementation - MIT licence
258         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
259 
260         if (value == 0) {
261             return "0";
262         }
263         uint256 temp = value;
264         uint256 digits;
265         while (temp != 0) {
266             digits++;
267             temp /= 10;
268         }
269         bytes memory buffer = new bytes(digits);
270         while (value != 0) {
271             digits -= 1;
272             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
273             value /= 10;
274         }
275         return string(buffer);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
280      */
281     function toHexString(uint256 value) internal pure returns (string memory) {
282         if (value == 0) {
283             return "0x00";
284         }
285         uint256 temp = value;
286         uint256 length = 0;
287         while (temp != 0) {
288             length++;
289             temp >>= 8;
290         }
291         return toHexString(value, length);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
296      */
297     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
298         bytes memory buffer = new bytes(2 * length + 2);
299         buffer[0] = "0";
300         buffer[1] = "x";
301         for (uint256 i = 2 * length + 1; i > 1; --i) {
302             buffer[i] = _HEX_SYMBOLS[value & 0xf];
303             value >>= 4;
304         }
305         require(value == 0, "Strings: hex length insufficient");
306         return string(buffer);
307     }
308 }
309 
310 // File: @openzeppelin/contracts/utils/Address.sol
311 
312 
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320     /**
321      * @dev Returns true if `account` is a contract.
322      *
323      * [IMPORTANT]
324      * ====
325      * It is unsafe to assume that an address for which this function returns
326      * false is an externally-owned account (EOA) and not a contract.
327      *
328      * Among others, `isContract` will return false for the following
329      * types of addresses:
330      *
331      *  - an externally-owned account
332      *  - a contract in construction
333      *  - an address where a contract will be created
334      *  - an address where a contract lived, but was destroyed
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         assembly {
344             size := extcodesize(account)
345         }
346         return size > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
530 
531 
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
557 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
558 
559 
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @title ERC721 token receiver interface
565  * @dev Interface for any contract that wants to support safeTransfers
566  * from ERC721 asset contracts.
567  */
568 interface IERC721Receiver {
569     /**
570      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
571      * by `operator` from `from`, this function is called.
572      *
573      * It must return its Solidity selector to confirm the token transfer.
574      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
575      *
576      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
577      */
578     function onERC721Received(
579         address operator,
580         address from,
581         uint256 tokenId,
582         bytes calldata data
583     ) external returns (bytes4);
584 }
585 
586 // File: @openzeppelin/contracts/utils/Context.sol
587 pragma solidity ^0.8.0;
588 /**
589  * @dev Provides information about the current execution context, including the
590  * sender of the transaction and its data. While these are generally available
591  * via msg.sender and msg.data, they should not be accessed in such a direct
592  * manner, since when dealing with meta-transactions the account sending and
593  * paying for execution may not be the actual sender (as far as an application
594  * is concerned).
595  *
596  * This contract is only required for intermediate, library-like contracts.
597  */
598 abstract contract Context {
599     function _msgSender() internal view virtual returns (address) {
600         return msg.sender;
601     }
602 
603     function _msgData() internal view virtual returns (bytes calldata) {
604         return msg.data;
605     }
606 }
607 
608 
609 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
610 pragma solidity ^0.8.0;
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
613  * the Metadata extension, but not including the Enumerable extension, which is available separately as
614  * {ERC721Enumerable}.
615  */
616 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
617     using Address for address;
618     using Strings for uint256;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     // Mapping from token ID to owner address
627     mapping(uint256 => address) private _owners;
628 
629     // Mapping owner address to token count
630     mapping(address => uint256) private _balances;
631 
632     // Mapping from token ID to approved address
633     mapping(uint256 => address) private _tokenApprovals;
634 
635     // Mapping from owner to operator approvals
636     mapping(address => mapping(address => bool)) private _operatorApprovals;
637 
638     /**
639      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
640      */
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644     }
645 
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
650         return
651             interfaceId == type(IERC721).interfaceId ||
652             interfaceId == type(IERC721Metadata).interfaceId ||
653             super.supportsInterface(interfaceId);
654     }
655 
656     /**
657      * @dev See {IERC721-balanceOf}.
658      */
659     function balanceOf(address owner) public view virtual override returns (uint256) {
660         require(owner != address(0), "ERC721: balance query for the zero address");
661         return _balances[owner];
662     }
663 
664     /**
665      * @dev See {IERC721-ownerOf}.
666      */
667     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
668         address owner = _owners[tokenId];
669         require(owner != address(0), "ERC721: owner query for nonexistent token");
670         return owner;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-name}.
675      */
676     function name() public view virtual override returns (string memory) {
677         return _name;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-symbol}.
682      */
683     function symbol() public view virtual override returns (string memory) {
684         return _symbol;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-tokenURI}.
689      */
690     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
691         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
692 
693         string memory baseURI = _baseURI();
694         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
695     }
696 
697     /**
698      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
699      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
700      * by default, can be overriden in child contracts.
701      */
702     function _baseURI() internal view virtual returns (string memory) {
703         return "";
704     }
705 
706     /**
707      * @dev See {IERC721-approve}.
708      */
709     function approve(address to, uint256 tokenId) public virtual override {
710         address owner = ERC721.ownerOf(tokenId);
711         require(to != owner, "ERC721: approval to current owner");
712 
713         require(
714             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
715             "ERC721: approve caller is not owner nor approved for all"
716         );
717 
718         _approve(to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-getApproved}.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
726 
727         return _tokenApprovals[tokenId];
728     }
729 
730     /**
731      * @dev See {IERC721-setApprovalForAll}.
732      */
733     function setApprovalForAll(address operator, bool approved) public virtual override {
734         require(operator != _msgSender(), "ERC721: approve to caller");
735 
736         _operatorApprovals[_msgSender()][operator] = approved;
737         emit ApprovalForAll(_msgSender(), operator, approved);
738     }
739 
740     /**
741      * @dev See {IERC721-isApprovedForAll}.
742      */
743     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
744         return _operatorApprovals[owner][operator];
745     }
746 
747     /**
748      * @dev See {IERC721-transferFrom}.
749      */
750     function transferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         //solhint-disable-next-line max-line-length
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757 
758         _transfer(from, to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId
768     ) public virtual override {
769         safeTransferFrom(from, to, tokenId, "");
770     }
771 
772     /**
773      * @dev See {IERC721-safeTransferFrom}.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes memory _data
780     ) public virtual override {
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
782         _safeTransfer(from, to, tokenId, _data);
783     }
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
790      *
791      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
792      * implement alternative mechanisms to perform token transfer, such as signature-based.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _safeTransfer(
804         address from,
805         address to,
806         uint256 tokenId,
807         bytes memory _data
808     ) internal virtual {
809         _transfer(from, to, tokenId);
810         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
811     }
812 
813     /**
814      * @dev Returns whether `tokenId` exists.
815      *
816      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
817      *
818      * Tokens start existing when they are minted (`_mint`),
819      * and stop existing when they are burned (`_burn`).
820      */
821     function _exists(uint256 tokenId) internal view virtual returns (bool) {
822         return _owners[tokenId] != address(0);
823     }
824 
825     /**
826      * @dev Returns whether `spender` is allowed to manage `tokenId`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
833         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
834         address owner = ERC721.ownerOf(tokenId);
835         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
836     }
837 
838     /**
839      * @dev Safely mints `tokenId` and transfers it to `to`.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _safeMint(address to, uint256 tokenId) internal virtual {
849         _safeMint(to, tokenId, "");
850     }
851 
852     /**
853      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
854      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
855      */
856     function _safeMint(
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) internal virtual {
861         _mint(to, tokenId);
862         require(
863             _checkOnERC721Received(address(0), to, tokenId, _data),
864             "ERC721: transfer to non ERC721Receiver implementer"
865         );
866     }
867 
868     /**
869      * @dev Mints `tokenId` and transfers it to `to`.
870      *
871      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
872      *
873      * Requirements:
874      *
875      * - `tokenId` must not exist.
876      * - `to` cannot be the zero address.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _mint(address to, uint256 tokenId) internal virtual {
881         require(to != address(0), "ERC721: mint to the zero address");
882         require(!_exists(tokenId), "ERC721: token already minted");
883 
884         _beforeTokenTransfer(address(0), to, tokenId);
885 
886         _balances[to] += 1;
887         _owners[tokenId] = to;
888 
889         emit Transfer(address(0), to, tokenId);
890     }
891 
892     /**
893      * @dev Destroys `tokenId`.
894      * The approval is cleared when the token is burned.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _burn(uint256 tokenId) internal virtual {
903         address owner = ERC721.ownerOf(tokenId);
904 
905         _beforeTokenTransfer(owner, address(0), tokenId);
906 
907         // Clear approvals
908         _approve(address(0), tokenId);
909 
910         _balances[owner] -= 1;
911         delete _owners[tokenId];
912 
913         emit Transfer(owner, address(0), tokenId);
914     }
915 
916     /**
917      * @dev Transfers `tokenId` from `from` to `to`.
918      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
919      *
920      * Requirements:
921      *
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must be owned by `from`.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _transfer(
928         address from,
929         address to,
930         uint256 tokenId
931     ) internal virtual {
932         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
933         require(to != address(0), "ERC721: transfer to the zero address");
934 
935         _beforeTokenTransfer(from, to, tokenId);
936 
937         // Clear approvals from the previous owner
938         _approve(address(0), tokenId);
939 
940         _balances[from] -= 1;
941         _balances[to] += 1;
942         _owners[tokenId] = to;
943 
944         emit Transfer(from, to, tokenId);
945     }
946 
947     /**
948      * @dev Approve `to` to operate on `tokenId`
949      *
950      * Emits a {Approval} event.
951      */
952     function _approve(address to, uint256 tokenId) internal virtual {
953         _tokenApprovals[tokenId] = to;
954         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
955     }
956 
957     /**
958      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
959      * The call is not executed if the target address is not a contract.
960      *
961      * @param from address representing the previous owner of the given token ID
962      * @param to target address that will receive the tokens
963      * @param tokenId uint256 ID of the token to be transferred
964      * @param _data bytes optional data to send along with the call
965      * @return bool whether the call correctly returned the expected magic value
966      */
967     function _checkOnERC721Received(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) private returns (bool) {
973         if (to.isContract()) {
974             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
975                 return retval == IERC721Receiver.onERC721Received.selector;
976             } catch (bytes memory reason) {
977                 if (reason.length == 0) {
978                     revert("ERC721: transfer to non ERC721Receiver implementer");
979                 } else {
980                     assembly {
981                         revert(add(32, reason), mload(reason))
982                     }
983                 }
984             }
985         } else {
986             return true;
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before any token transfer. This includes minting
992      * and burning.
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` will be minted for `to`.
999      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1000      * - `from` and `to` are never both zero.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {}
1009 }
1010 
1011 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1012 
1013 
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 
1018 
1019 /**
1020  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1021  * enumerability of all the token ids in the contract as well as all token ids owned by each
1022  * account.
1023  */
1024 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1025     // Mapping from owner to list of owned token IDs
1026     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1027 
1028     // Mapping from token ID to index of the owner tokens list
1029     mapping(uint256 => uint256) private _ownedTokensIndex;
1030 
1031     // Array with all token ids, used for enumeration
1032     uint256[] private _allTokens;
1033 
1034     // Mapping from token id to position in the allTokens array
1035     mapping(uint256 => uint256) private _allTokensIndex;
1036 
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1041         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1046      */
1047     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1048         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1049         return _ownedTokens[owner][index];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-totalSupply}.
1054      */
1055     function totalSupply() public view virtual override returns (uint256) {
1056         return _allTokens.length;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-tokenByIndex}.
1061      */
1062     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1063         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1064         return _allTokens[index];
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` will be minted for `to`.
1076      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      *
1080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1081      */
1082     function _beforeTokenTransfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual override {
1087         super._beforeTokenTransfer(from, to, tokenId);
1088 
1089         if (from == address(0)) {
1090             _addTokenToAllTokensEnumeration(tokenId);
1091         } else if (from != to) {
1092             _removeTokenFromOwnerEnumeration(from, tokenId);
1093         }
1094         if (to == address(0)) {
1095             _removeTokenFromAllTokensEnumeration(tokenId);
1096         } else if (to != from) {
1097             _addTokenToOwnerEnumeration(to, tokenId);
1098         }
1099     }
1100 
1101     /**
1102      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1103      * @param to address representing the new owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1105      */
1106     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1107         uint256 length = ERC721.balanceOf(to);
1108         _ownedTokens[to][length] = tokenId;
1109         _ownedTokensIndex[tokenId] = length;
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's token tracking data structures.
1114      * @param tokenId uint256 ID of the token to be added to the tokens list
1115      */
1116     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1117         _allTokensIndex[tokenId] = _allTokens.length;
1118         _allTokens.push(tokenId);
1119     }
1120 
1121     /**
1122      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1123      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1124      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1125      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1126      * @param from address representing the previous owner of the given token ID
1127      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1128      */
1129     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1130         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1131         // then delete the last slot (swap and pop).
1132 
1133         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1134         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1135 
1136         // When the token to delete is the last token, the swap operation is unnecessary
1137         if (tokenIndex != lastTokenIndex) {
1138             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1139 
1140             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1141             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1142         }
1143 
1144         // This also deletes the contents at the last position of the array
1145         delete _ownedTokensIndex[tokenId];
1146         delete _ownedTokens[from][lastTokenIndex];
1147     }
1148 
1149     /**
1150      * @dev Private function to remove a token from this extension's token tracking data structures.
1151      * This has O(1) time complexity, but alters the order of the _allTokens array.
1152      * @param tokenId uint256 ID of the token to be removed from the tokens list
1153      */
1154     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1155         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1156         // then delete the last slot (swap and pop).
1157 
1158         uint256 lastTokenIndex = _allTokens.length - 1;
1159         uint256 tokenIndex = _allTokensIndex[tokenId];
1160 
1161         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1162         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1163         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1164         uint256 lastTokenId = _allTokens[lastTokenIndex];
1165 
1166         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1167         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1168 
1169         // This also deletes the contents at the last position of the array
1170         delete _allTokensIndex[tokenId];
1171         _allTokens.pop();
1172     }
1173 }
1174 
1175 
1176 // File: @openzeppelin/contracts/access/Ownable.sol
1177 pragma solidity ^0.8.0;
1178 /**
1179  * @dev Contract module which provides a basic access control mechanism, where
1180  * there is an account (an owner) that can be granted exclusive access to
1181  * specific functions.
1182  *
1183  * By default, the owner account will be the one that deploys the contract. This
1184  * can later be changed with {transferOwnership}.
1185  *
1186  * This module is used through inheritance. It will make available the modifier
1187  * `onlyOwner`, which can be applied to your functions to restrict their use to
1188  * the owner.
1189  */
1190 abstract contract Ownable is Context {
1191     address private _owner;
1192 
1193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1194 
1195     /**
1196      * @dev Initializes the contract setting the deployer as the initial owner.
1197      */
1198     constructor() {
1199         _setOwner(_msgSender());
1200     }
1201 
1202     /**
1203      * @dev Returns the address of the current owner.
1204      */
1205     function owner() public view virtual returns (address) {
1206         return _owner;
1207     }
1208 
1209     /**
1210      * @dev Throws if called by any account other than the owner.
1211      */
1212     modifier onlyOwner() {
1213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1214         _;
1215     }
1216 
1217     /**
1218      * @dev Leaves the contract without owner. It will not be possible to call
1219      * `onlyOwner` functions anymore. Can only be called by the current owner.
1220      *
1221      * NOTE: Renouncing ownership will leave the contract without an owner,
1222      * thereby removing any functionality that is only available to the owner.
1223      */
1224     function renounceOwnership() public virtual onlyOwner {
1225         _setOwner(address(0));
1226     }
1227 
1228     /**
1229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1230      * Can only be called by the current owner.
1231      */
1232     function transferOwnership(address newOwner) public virtual onlyOwner {
1233         require(newOwner != address(0), "Ownable: new owner is the zero address");
1234         _setOwner(newOwner);
1235     }
1236 
1237     function _setOwner(address newOwner) private {
1238         address oldOwner = _owner;
1239         _owner = newOwner;
1240         emit OwnershipTransferred(oldOwner, newOwner);
1241     }
1242 }
1243 
1244 pragma solidity >=0.7.0 <0.9.0;
1245 
1246 contract noticonic is ERC721Enumerable, Ownable {
1247   using Strings for uint256;
1248 
1249   string baseURI;
1250   string public baseExtension = ".json";
1251   uint256 public cost = 0 ether;
1252   uint256 public maxSupply = 1974;
1253   uint256 public maxMintAmount = 2;
1254   bool public paused = false;
1255   bool public revealed = false;
1256   string public notRevealedUri;
1257 
1258   constructor(
1259     string memory _name,
1260     string memory _symbol,
1261     string memory _initBaseURI,
1262     string memory _initNotRevealedUri
1263   ) ERC721(_name, _symbol) {
1264     setBaseURI(_initBaseURI);
1265     setNotRevealedURI(_initNotRevealedUri);
1266   }
1267 
1268   // internal
1269   function _baseURI() internal view virtual override returns (string memory) {
1270     return baseURI;
1271   }
1272 
1273   // public
1274   function mint(uint256 _mintAmount) public payable {
1275     uint256 supply = totalSupply();
1276     require(!paused);
1277     require(_mintAmount > 0);
1278     require(_mintAmount <= maxMintAmount);
1279     require(supply + _mintAmount <= maxSupply);
1280 
1281     if (msg.sender != owner()) {
1282       require(msg.value >= cost * _mintAmount);
1283     }
1284 
1285     for (uint256 i = 1; i <= _mintAmount; i++) {
1286       _safeMint(msg.sender, supply + i);
1287     }
1288   }
1289 
1290   function walletOfOwner(address _owner)
1291     public
1292     view
1293     returns (uint256[] memory)
1294   {
1295     uint256 ownerTokenCount = balanceOf(_owner);
1296     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1297     for (uint256 i; i < ownerTokenCount; i++) {
1298       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1299     }
1300     return tokenIds;
1301   }
1302 
1303   function tokenURI(uint256 tokenId)
1304     public
1305     view
1306     virtual
1307     override
1308     returns (string memory)
1309   {
1310     require(
1311       _exists(tokenId),
1312       "ERC721Metadata: URI query for nonexistent token"
1313     );
1314     
1315     if(revealed == false) {
1316         return notRevealedUri;
1317     }
1318 
1319     string memory currentBaseURI = _baseURI();
1320     return bytes(currentBaseURI).length > 0
1321         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1322         : "";
1323   }
1324 
1325   //only owner
1326   function reveal() public onlyOwner {
1327       revealed = true;
1328   }
1329   
1330   function setCost(uint256 _newCost) public onlyOwner {
1331     cost = _newCost;
1332   }
1333 
1334   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1335     maxMintAmount = _newmaxMintAmount;
1336   }
1337   
1338   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1339     notRevealedUri = _notRevealedURI;
1340   }
1341 
1342   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1343     baseURI = _newBaseURI;
1344   }
1345 
1346   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1347     baseExtension = _newBaseExtension;
1348   }
1349 
1350   function pause(bool _state) public onlyOwner {
1351     paused = _state;
1352   }
1353  
1354   function withdraw() public payable onlyOwner {
1355     // This will pay S_V 5% of the initial sale.
1356     // You can remove this if you want, or keep it in to support Clayco and his channel.
1357     // =============================================================================
1358     (bool hs, ) = payable(0x878975Cf4a97774af6875B3B37b0920b83121F35).call{value: address(this).balance * 5 / 100}("");
1359     require(hs);
1360     // =============================================================================
1361     
1362     // This will payout the owner 95% of the contract balance.
1363     // Do not remove this otherwise you will not be able to withdraw the funds.
1364     // =============================================================================
1365     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1366     require(os);
1367     // =============================================================================
1368   }
1369 }