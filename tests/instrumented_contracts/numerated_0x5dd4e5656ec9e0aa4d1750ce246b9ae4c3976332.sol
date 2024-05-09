1 // SPDX-License-Identifier: MIT
2 // Blockchain Ballers NFT - Official Contract 
3 // https://twitter.com/BBallersNFT
4 
5 
6 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
7 pragma solidity ^0.8.0;
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 pragma solidity ^0.8.0;
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
169 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
170 pragma solidity ^0.8.0;
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Enumerable is IERC721 {
176     /**
177      * @dev Returns the total amount of tokens stored by the contract.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
183      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
184      */
185     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
186 
187     /**
188      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
189      * Use along with {totalSupply} to enumerate all tokens.
190      */
191     function tokenByIndex(uint256 index) external view returns (uint256);
192 }
193 
194 
195 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
196 pragma solidity ^0.8.0;
197 /**
198  * @dev Implementation of the {IERC165} interface.
199  *
200  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
201  * for the additional interface id that will be supported. For example:
202  *
203  * ```solidity
204  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
205  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
206  * }
207  * ```
208  *
209  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
210  */
211 abstract contract ERC165 is IERC165 {
212     /**
213      * @dev See {IERC165-supportsInterface}.
214      */
215     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
216         return interfaceId == type(IERC165).interfaceId;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Strings.sol
221 
222 
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev String operations.
228  */
229 library Strings {
230     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
234      */
235     function toString(uint256 value) internal pure returns (string memory) {
236         // Inspired by OraclizeAPI's implementation - MIT licence
237         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
238 
239         if (value == 0) {
240             return "0";
241         }
242         uint256 temp = value;
243         uint256 digits;
244         while (temp != 0) {
245             digits++;
246             temp /= 10;
247         }
248         bytes memory buffer = new bytes(digits);
249         while (value != 0) {
250             digits -= 1;
251             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
252             value /= 10;
253         }
254         return string(buffer);
255     }
256 
257     /**
258      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
259      */
260     function toHexString(uint256 value) internal pure returns (string memory) {
261         if (value == 0) {
262             return "0x00";
263         }
264         uint256 temp = value;
265         uint256 length = 0;
266         while (temp != 0) {
267             length++;
268             temp >>= 8;
269         }
270         return toHexString(value, length);
271     }
272 
273     /**
274      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
275      */
276     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
277         bytes memory buffer = new bytes(2 * length + 2);
278         buffer[0] = "0";
279         buffer[1] = "x";
280         for (uint256 i = 2 * length + 1; i > 1; --i) {
281             buffer[i] = _HEX_SYMBOLS[value & 0xf];
282             value >>= 4;
283         }
284         require(value == 0, "Strings: hex length insufficient");
285         return string(buffer);
286     }
287 }
288 
289 // File: @openzeppelin/contracts/utils/Address.sol
290 
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize, which returns 0 for contracts in
318         // construction, since the code is only stored at the end of the
319         // constructor execution.
320 
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         (bool success, ) = recipient.call{value: amount}("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain `call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
408      * with `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.call{value: value}(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.staticcall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
481      * revert reason using the provided one.
482      *
483      * _Available since v4.3._
484      */
485     function verifyCallResult(
486         bool success,
487         bytes memory returndata,
488         string memory errorMessage
489     ) internal pure returns (bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 assembly {
498                     let returndata_size := mload(returndata)
499                     revert(add(32, returndata), returndata_size)
500                 }
501             } else {
502                 revert(errorMessage);
503             }
504         }
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
517  * @dev See https://eips.ethereum.org/EIPS/eip-721
518  */
519 interface IERC721Metadata is IERC721 {
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
537 
538 
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @title ERC721 token receiver interface
544  * @dev Interface for any contract that wants to support safeTransfers
545  * from ERC721 asset contracts.
546  */
547 interface IERC721Receiver {
548     /**
549      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
550      * by `operator` from `from`, this function is called.
551      *
552      * It must return its Solidity selector to confirm the token transfer.
553      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
554      *
555      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
556      */
557     function onERC721Received(
558         address operator,
559         address from,
560         uint256 tokenId,
561         bytes calldata data
562     ) external returns (bytes4);
563 }
564 
565 // File: @openzeppelin/contracts/utils/Context.sol
566 pragma solidity ^0.8.0;
567 /**
568  * @dev Provides information about the current execution context, including the
569  * sender of the transaction and its data. While these are generally available
570  * via msg.sender and msg.data, they should not be accessed in such a direct
571  * manner, since when dealing with meta-transactions the account sending and
572  * paying for execution may not be the actual sender (as far as an application
573  * is concerned).
574  *
575  * This contract is only required for intermediate, library-like contracts.
576  */
577 abstract contract Context {
578     function _msgSender() internal view virtual returns (address) {
579         return msg.sender;
580     }
581 
582     function _msgData() internal view virtual returns (bytes calldata) {
583         return msg.data;
584     }
585 }
586 
587 
588 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
589 pragma solidity ^0.8.0;
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata extension, but not including the Enumerable extension, which is available separately as
593  * {ERC721Enumerable}.
594  */
595 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
596     using Address for address;
597     using Strings for uint256;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to owner address
606     mapping(uint256 => address) private _owners;
607 
608     // Mapping owner address to token count
609     mapping(address => uint256) private _balances;
610 
611     // Mapping from token ID to approved address
612     mapping(uint256 => address) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     /**
618      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
619      */
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623     }
624 
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
629         return
630             interfaceId == type(IERC721).interfaceId ||
631             interfaceId == type(IERC721Metadata).interfaceId ||
632             super.supportsInterface(interfaceId);
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner) public view virtual override returns (uint256) {
639         require(owner != address(0), "ERC721: balance query for the zero address");
640         return _balances[owner];
641     }
642 
643     /**
644      * @dev See {IERC721-ownerOf}.
645      */
646     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
647         address owner = _owners[tokenId];
648         require(owner != address(0), "ERC721: owner query for nonexistent token");
649         return owner;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-name}.
654      */
655     function name() public view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-symbol}.
661      */
662     function symbol() public view virtual override returns (string memory) {
663         return _symbol;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-tokenURI}.
668      */
669     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
670         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
671 
672         string memory baseURI = _baseURI();
673         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
674     }
675 
676     /**
677      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
678      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
679      * by default, can be overriden in child contracts.
680      */
681     function _baseURI() internal view virtual returns (string memory) {
682         return "";
683     }
684 
685     /**
686      * @dev See {IERC721-approve}.
687      */
688     function approve(address to, uint256 tokenId) public virtual override {
689         address owner = ERC721.ownerOf(tokenId);
690         require(to != owner, "ERC721: approval to current owner");
691 
692         require(
693             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
694             "ERC721: approve caller is not owner nor approved for all"
695         );
696 
697         _approve(to, tokenId);
698     }
699 
700     /**
701      * @dev See {IERC721-getApproved}.
702      */
703     function getApproved(uint256 tokenId) public view virtual override returns (address) {
704         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
705 
706         return _tokenApprovals[tokenId];
707     }
708 
709     /**
710      * @dev See {IERC721-setApprovalForAll}.
711      */
712     function setApprovalForAll(address operator, bool approved) public virtual override {
713         require(operator != _msgSender(), "ERC721: approve to caller");
714 
715         _operatorApprovals[_msgSender()][operator] = approved;
716         emit ApprovalForAll(_msgSender(), operator, approved);
717     }
718 
719     /**
720      * @dev See {IERC721-isApprovedForAll}.
721      */
722     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
723         return _operatorApprovals[owner][operator];
724     }
725 
726     /**
727      * @dev See {IERC721-transferFrom}.
728      */
729     function transferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         //solhint-disable-next-line max-line-length
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736 
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, "");
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761         _safeTransfer(from, to, tokenId, _data);
762     }
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
769      *
770      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
771      * implement alternative mechanisms to perform token transfer, such as signature-based.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeTransfer(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) internal virtual {
788         _transfer(from, to, tokenId);
789         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted (`_mint`),
798      * and stop existing when they are burned (`_burn`).
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return _owners[tokenId] != address(0);
802     }
803 
804     /**
805      * @dev Returns whether `spender` is allowed to manage `tokenId`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
812         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
813         address owner = ERC721.ownerOf(tokenId);
814         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
815     }
816 
817     /**
818      * @dev Safely mints `tokenId` and transfers it to `to`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _safeMint(address to, uint256 tokenId) internal virtual {
828         _safeMint(to, tokenId, "");
829     }
830 
831     /**
832      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
833      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
834      */
835     function _safeMint(
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) internal virtual {
840         _mint(to, tokenId);
841         require(
842             _checkOnERC721Received(address(0), to, tokenId, _data),
843             "ERC721: transfer to non ERC721Receiver implementer"
844         );
845     }
846 
847     /**
848      * @dev Mints `tokenId` and transfers it to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
851      *
852      * Requirements:
853      *
854      * - `tokenId` must not exist.
855      * - `to` cannot be the zero address.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _mint(address to, uint256 tokenId) internal virtual {
860         require(to != address(0), "ERC721: mint to the zero address");
861         require(!_exists(tokenId), "ERC721: token already minted");
862 
863         _beforeTokenTransfer(address(0), to, tokenId);
864 
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(address(0), to, tokenId);
869     }
870 
871     /**
872      * @dev Destroys `tokenId`.
873      * The approval is cleared when the token is burned.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _burn(uint256 tokenId) internal virtual {
882         address owner = ERC721.ownerOf(tokenId);
883 
884         _beforeTokenTransfer(owner, address(0), tokenId);
885 
886         // Clear approvals
887         _approve(address(0), tokenId);
888 
889         _balances[owner] -= 1;
890         delete _owners[tokenId];
891 
892         emit Transfer(owner, address(0), tokenId);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _transfer(
907         address from,
908         address to,
909         uint256 tokenId
910     ) internal virtual {
911         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
912         require(to != address(0), "ERC721: transfer to the zero address");
913 
914         _beforeTokenTransfer(from, to, tokenId);
915 
916         // Clear approvals from the previous owner
917         _approve(address(0), tokenId);
918 
919         _balances[from] -= 1;
920         _balances[to] += 1;
921         _owners[tokenId] = to;
922 
923         emit Transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev Approve `to` to operate on `tokenId`
928      *
929      * Emits a {Approval} event.
930      */
931     function _approve(address to, uint256 tokenId) internal virtual {
932         _tokenApprovals[tokenId] = to;
933         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
934     }
935 
936     /**
937      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
938      * The call is not executed if the target address is not a contract.
939      *
940      * @param from address representing the previous owner of the given token ID
941      * @param to target address that will receive the tokens
942      * @param tokenId uint256 ID of the token to be transferred
943      * @param _data bytes optional data to send along with the call
944      * @return bool whether the call correctly returned the expected magic value
945      */
946     function _checkOnERC721Received(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) private returns (bool) {
952         if (to.isContract()) {
953             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
954                 return retval == IERC721Receiver.onERC721Received.selector;
955             } catch (bytes memory reason) {
956                 if (reason.length == 0) {
957                     revert("ERC721: transfer to non ERC721Receiver implementer");
958                 } else {
959                     assembly {
960                         revert(add(32, reason), mload(reason))
961                     }
962                 }
963             }
964         } else {
965             return true;
966         }
967     }
968 
969     /**
970      * @dev Hook that is called before any token transfer. This includes minting
971      * and burning.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` will be minted for `to`.
978      * - When `to` is zero, ``from``'s `tokenId` will be burned.
979      * - `from` and `to` are never both zero.
980      *
981      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
982      */
983     function _beforeTokenTransfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {}
988 }
989 
990 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
991 
992 
993 
994 pragma solidity ^0.8.0;
995 
996 
997 
998 /**
999  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1000  * enumerability of all the token ids in the contract as well as all token ids owned by each
1001  * account.
1002  */
1003 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1004     // Mapping from owner to list of owned token IDs
1005     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1006 
1007     // Mapping from token ID to index of the owner tokens list
1008     mapping(uint256 => uint256) private _ownedTokensIndex;
1009 
1010     // Array with all token ids, used for enumeration
1011     uint256[] private _allTokens;
1012 
1013     // Mapping from token id to position in the allTokens array
1014     mapping(uint256 => uint256) private _allTokensIndex;
1015 
1016     /**
1017      * @dev See {IERC165-supportsInterface}.
1018      */
1019     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1020         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1025      */
1026     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1027         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1028         return _ownedTokens[owner][index];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-totalSupply}.
1033      */
1034     function totalSupply() public view virtual override returns (uint256) {
1035         return _allTokens.length;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Enumerable-tokenByIndex}.
1040      */
1041     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1042         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1043         return _allTokens[index];
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before any token transfer. This includes minting
1048      * and burning.
1049      *
1050      * Calling conditions:
1051      *
1052      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1053      * transferred to `to`.
1054      * - When `from` is zero, `tokenId` will be minted for `to`.
1055      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      *
1059      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1060      */
1061     function _beforeTokenTransfer(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) internal virtual override {
1066         super._beforeTokenTransfer(from, to, tokenId);
1067 
1068         if (from == address(0)) {
1069             _addTokenToAllTokensEnumeration(tokenId);
1070         } else if (from != to) {
1071             _removeTokenFromOwnerEnumeration(from, tokenId);
1072         }
1073         if (to == address(0)) {
1074             _removeTokenFromAllTokensEnumeration(tokenId);
1075         } else if (to != from) {
1076             _addTokenToOwnerEnumeration(to, tokenId);
1077         }
1078     }
1079 
1080     /**
1081      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1082      * @param to address representing the new owner of the given token ID
1083      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1084      */
1085     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1086         uint256 length = ERC721.balanceOf(to);
1087         _ownedTokens[to][length] = tokenId;
1088         _ownedTokensIndex[tokenId] = length;
1089     }
1090 
1091     /**
1092      * @dev Private function to add a token to this extension's token tracking data structures.
1093      * @param tokenId uint256 ID of the token to be added to the tokens list
1094      */
1095     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1096         _allTokensIndex[tokenId] = _allTokens.length;
1097         _allTokens.push(tokenId);
1098     }
1099 
1100     /**
1101      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1102      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1103      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1104      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1105      * @param from address representing the previous owner of the given token ID
1106      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1107      */
1108     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1109         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1110         // then delete the last slot (swap and pop).
1111 
1112         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1113         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1114 
1115         // When the token to delete is the last token, the swap operation is unnecessary
1116         if (tokenIndex != lastTokenIndex) {
1117             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1118 
1119             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1120             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1121         }
1122 
1123         // This also deletes the contents at the last position of the array
1124         delete _ownedTokensIndex[tokenId];
1125         delete _ownedTokens[from][lastTokenIndex];
1126     }
1127 
1128     /**
1129      * @dev Private function to remove a token from this extension's token tracking data structures.
1130      * This has O(1) time complexity, but alters the order of the _allTokens array.
1131      * @param tokenId uint256 ID of the token to be removed from the tokens list
1132      */
1133     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1134         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1135         // then delete the last slot (swap and pop).
1136 
1137         uint256 lastTokenIndex = _allTokens.length - 1;
1138         uint256 tokenIndex = _allTokensIndex[tokenId];
1139 
1140         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1141         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1142         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1143         uint256 lastTokenId = _allTokens[lastTokenIndex];
1144 
1145         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1146         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1147 
1148         // This also deletes the contents at the last position of the array
1149         delete _allTokensIndex[tokenId];
1150         _allTokens.pop();
1151     }
1152 }
1153 
1154 
1155 // File: @openzeppelin/contracts/access/Ownable.sol
1156 pragma solidity ^0.8.0;
1157 /**
1158  * @dev Contract module which provides a basic access control mechanism, where
1159  * there is an account (an owner) that can be granted exclusive access to
1160  * specific functions.
1161  *
1162  * By default, the owner account will be the one that deploys the contract. This
1163  * can later be changed with {transferOwnership}.
1164  *
1165  * This module is used through inheritance. It will make available the modifier
1166  * `onlyOwner`, which can be applied to your functions to restrict their use to
1167  * the owner.
1168  */
1169 abstract contract Ownable is Context {
1170     address private _owner;
1171 
1172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1173 
1174     /**
1175      * @dev Initializes the contract setting the deployer as the initial owner.
1176      */
1177     constructor() {
1178         _setOwner(_msgSender());
1179     }
1180 
1181     /**
1182      * @dev Returns the address of the current owner.
1183      */
1184     function owner() public view virtual returns (address) {
1185         return _owner;
1186     }
1187 
1188     /**
1189      * @dev Throws if called by any account other than the owner.
1190      */
1191     modifier onlyOwner() {
1192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1193         _;
1194     }
1195 
1196     /**
1197      * @dev Leaves the contract without owner. It will not be possible to call
1198      * `onlyOwner` functions anymore. Can only be called by the current owner.
1199      *
1200      * NOTE: Renouncing ownership will leave the contract without an owner,
1201      * thereby removing any functionality that is only available to the owner.
1202      */
1203     function renounceOwnership() public virtual onlyOwner {
1204         _setOwner(address(0));
1205     }
1206 
1207     /**
1208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1209      * Can only be called by the current owner.
1210      */
1211     function transferOwnership(address newOwner) public virtual onlyOwner {
1212         require(newOwner != address(0), "Ownable: new owner is the zero address");
1213         _setOwner(newOwner);
1214     }
1215 
1216     function _setOwner(address newOwner) private {
1217         address oldOwner = _owner;
1218         _owner = newOwner;
1219         emit OwnershipTransferred(oldOwner, newOwner);
1220     }
1221 }
1222 
1223 pragma solidity >=0.7.0 <0.9.0;
1224 
1225 contract BlockchainBallers is ERC721Enumerable, Ownable {
1226   using Strings for uint256;
1227 
1228   string baseURI;
1229   string public baseExtension = ".json";
1230   uint256 public cost = 0.03 ether;
1231   uint256 public maxSupply = 3000;
1232   uint256 public maxMintAmount = 10;
1233 
1234   uint256 public maxFreeMintAmount = 3;
1235   uint256 public maxFreeMint = 1000;
1236 
1237   bool public paused = true;
1238   bool public revealed = false;
1239   string public notRevealedUri;
1240 
1241   constructor(
1242     string memory _name,
1243     string memory _symbol,
1244     string memory _initBaseURI,
1245     string memory _initNotRevealedUri
1246   ) ERC721(_name, _symbol) {
1247     setBaseURI(_initBaseURI);
1248     setNotRevealedURI(_initNotRevealedUri);
1249   }
1250 
1251   function _baseURI() internal view virtual override returns (string memory) {
1252     return baseURI;
1253   }
1254 
1255   function mint(uint256 _mintAmount) public payable {
1256     uint256 supply = totalSupply();
1257     require(!paused);
1258     require(_mintAmount > 0);
1259     require(_mintAmount <= maxMintAmount);
1260     require(supply + _mintAmount <= maxSupply);
1261 
1262     if (msg.sender != owner()) {
1263       require(msg.value >= cost * _mintAmount);
1264     }
1265 
1266     for (uint256 i = 1; i <= _mintAmount; i++) {
1267       _safeMint(msg.sender, supply + i);
1268     }
1269   }
1270 
1271   function freeMint(uint256 _mintAmount) public {
1272       uint256 supply = totalSupply();
1273       require(!paused, "Sale has paused");
1274       require(_mintAmount <= maxFreeMintAmount);
1275       require(supply + _mintAmount <= maxFreeMint, "No more BALLS left");
1276 
1277       for (uint256 i = 1; i <= _mintAmount; i++) {
1278        _safeMint(msg.sender, supply + i);
1279     }
1280   }
1281 
1282 
1283   function walletOfOwner(address _owner)
1284     public
1285     view
1286     returns (uint256[] memory)
1287   {
1288     uint256 ownerTokenCount = balanceOf(_owner);
1289     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1290     for (uint256 i; i < ownerTokenCount; i++) {
1291       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1292     }
1293     return tokenIds;
1294   }
1295 
1296   function tokenURI(uint256 tokenId)
1297     public
1298     view
1299     virtual
1300     override
1301     returns (string memory)
1302   {
1303     require(
1304       _exists(tokenId),
1305       "ERC721Metadata: URI query for nonexistent token"
1306     );
1307     
1308     if(revealed == false) {
1309         return notRevealedUri;
1310     }
1311 
1312     string memory currentBaseURI = _baseURI();
1313     return bytes(currentBaseURI).length > 0
1314         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1315         : "";
1316   }
1317 
1318   function reveal() public onlyOwner {
1319       revealed = true;
1320   }
1321   
1322   function setCost(uint256 _newCost) public onlyOwner {
1323     cost = _newCost;
1324   }
1325 
1326   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1327     maxMintAmount = _newmaxMintAmount;
1328   }
1329   
1330   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1331     notRevealedUri = _notRevealedURI;
1332   }
1333 
1334   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1335     baseURI = _newBaseURI;
1336   }
1337 
1338   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1339     baseExtension = _newBaseExtension;
1340   }
1341 
1342   function pause(bool _state) public onlyOwner {
1343     paused = _state;
1344   }
1345  
1346   function withdraw() public payable onlyOwner {
1347     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1348     require(os);
1349   }
1350 }