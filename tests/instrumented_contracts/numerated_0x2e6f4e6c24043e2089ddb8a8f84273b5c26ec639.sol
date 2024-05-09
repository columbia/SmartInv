1 /**
2  *Submitted for verification at BscScan.com on 2022-05-09
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2022-04-02
7 */
8 
9 /**
10  *Submitted for verification at BscScan.com on 2022-04-01
11 */
12 
13 /**
14  *Submitted for verification at BscScan.com on 2022-03-19
15 */
16 
17 // File: contracts/InfiniteHeroesNFTContract.sol
18 
19 
20 // SPDX-License-Identifier: GPL-3.0
21 /*
22     Testing NFT
23 */
24 
25 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
26 pragma solidity ^0.8.0;
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
49 pragma solidity ^0.8.0;
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
188 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
189 pragma solidity ^0.8.0;
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Enumerable is IERC721 {
195     /**
196      * @dev Returns the total amount of tokens stored by the contract.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
202      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
203      */
204     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
205 
206     /**
207      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
208      * Use along with {totalSupply} to enumerate all tokens.
209      */
210     function tokenByIndex(uint256 index) external view returns (uint256);
211 }
212 
213 
214 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
215 pragma solidity ^0.8.0;
216 /**
217  * @dev Implementation of the {IERC165} interface.
218  *
219  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
220  * for the additional interface id that will be supported. For example:
221  *
222  * ```solidity
223  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
224  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
225  * }
226  * ```
227  *
228  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
229  */
230 abstract contract ERC165 is IERC165 {
231     /**
232      * @dev See {IERC165-supportsInterface}.
233      */
234     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
235         return interfaceId == type(IERC165).interfaceId;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Strings.sol
240 
241 
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev String operations.
247  */
248 library Strings {
249     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
253      */
254     function toString(uint256 value) internal pure returns (string memory) {
255         // Inspired by OraclizeAPI's implementation - MIT licence
256         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
257 
258         if (value == 0) {
259             return "0";
260         }
261         uint256 temp = value;
262         uint256 digits;
263         while (temp != 0) {
264             digits++;
265             temp /= 10;
266         }
267         bytes memory buffer = new bytes(digits);
268         while (value != 0) {
269             digits -= 1;
270             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
271             value /= 10;
272         }
273         return string(buffer);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
278      */
279     function toHexString(uint256 value) internal pure returns (string memory) {
280         if (value == 0) {
281             return "0x00";
282         }
283         uint256 temp = value;
284         uint256 length = 0;
285         while (temp != 0) {
286             length++;
287             temp >>= 8;
288         }
289         return toHexString(value, length);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
294      */
295     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
296         bytes memory buffer = new bytes(2 * length + 2);
297         buffer[0] = "0";
298         buffer[1] = "x";
299         for (uint256 i = 2 * length + 1; i > 1; --i) {
300             buffer[i] = _HEX_SYMBOLS[value & 0xf];
301             value >>= 4;
302         }
303         require(value == 0, "Strings: hex length insufficient");
304         return string(buffer);
305     }
306 }
307 
308 // File: @openzeppelin/contracts/utils/Address.sol
309 
310 
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize, which returns 0 for contracts in
337         // construction, since the code is only stored at the end of the
338         // constructor execution.
339 
340         uint256 size;
341         assembly {
342             size := extcodesize(account)
343         }
344         return size > 0;
345     }
346 
347     /**
348      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
349      * `recipient`, forwarding all available gas and reverting on errors.
350      *
351      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
352      * of certain opcodes, possibly making contracts go over the 2300 gas limit
353      * imposed by `transfer`, making them unable to receive funds via
354      * `transfer`. {sendValue} removes this limitation.
355      *
356      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
357      *
358      * IMPORTANT: because control is transferred to `recipient`, care must be
359      * taken to not create reentrancy vulnerabilities. Consider using
360      * {ReentrancyGuard} or the
361      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
362      */
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         (bool success, ) = recipient.call{value: amount}("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 
370     /**
371      * @dev Performs a Solidity function call using a low level `call`. A
372      * plain `call` is an unsafe replacement for a function call: use this
373      * function instead.
374      *
375      * If `target` reverts with a revert reason, it is bubbled up by this
376      * function (like regular Solidity function calls).
377      *
378      * Returns the raw returned data. To convert to the expected return value,
379      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
380      *
381      * Requirements:
382      *
383      * - `target` must be a contract.
384      * - calling `target` with `data` must not revert.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.call{value: value}(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
451         return functionStaticCall(target, data, "Address: low-level static call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal view returns (bytes memory) {
465         require(isContract(target), "Address: static call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.delegatecall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
500      * revert reason using the provided one.
501      *
502      * _Available since v4.3._
503      */
504     function verifyCallResult(
505         bool success,
506         bytes memory returndata,
507         string memory errorMessage
508     ) internal pure returns (bytes memory) {
509         if (success) {
510             return returndata;
511         } else {
512             // Look for revert reason and bubble it up if present
513             if (returndata.length > 0) {
514                 // The easiest way to bubble the revert reason is using memory via assembly
515 
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Metadata is IERC721 {
539     /**
540      * @dev Returns the token collection name.
541      */
542     function name() external view returns (string memory);
543 
544     /**
545      * @dev Returns the token collection symbol.
546      */
547     function symbol() external view returns (string memory);
548 
549     /**
550      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
551      */
552     function tokenURI(uint256 tokenId) external view returns (string memory);
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
556 
557 
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @title ERC721 token receiver interface
563  * @dev Interface for any contract that wants to support safeTransfers
564  * from ERC721 asset contracts.
565  */
566 interface IERC721Receiver {
567     /**
568      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
569      * by `operator` from `from`, this function is called.
570      *
571      * It must return its Solidity selector to confirm the token transfer.
572      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
573      *
574      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
575      */
576     function onERC721Received(
577         address operator,
578         address from,
579         uint256 tokenId,
580         bytes calldata data
581     ) external returns (bytes4);
582 }
583 
584 // File: @openzeppelin/contracts/utils/Context.sol
585 pragma solidity ^0.8.0;
586 /**
587  * @dev Provides information about the current execution context, including the
588  * sender of the transaction and its data. While these are generally available
589  * via msg.sender and msg.data, they should not be accessed in such a direct
590  * manner, since when dealing with meta-transactions the account sending and
591  * paying for execution may not be the actual sender (as far as an application
592  * is concerned).
593  *
594  * This contract is only required for intermediate, library-like contracts.
595  */
596 abstract contract Context {
597     function _msgSender() internal view virtual returns (address) {
598         return msg.sender;
599     }
600 
601     function _msgData() internal view virtual returns (bytes calldata) {
602         return msg.data;
603     }
604 }
605 
606 
607 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
608 pragma solidity ^0.8.0;
609 /**
610  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
611  * the Metadata extension, but not including the Enumerable extension, which is available separately as
612  * {ERC721Enumerable}.
613  */
614 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
615     using Address for address;
616     using Strings for uint256;
617 
618     uint256 public maxSupply = 6654;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     string public baseExtension = ".json";
627 
628     // Mapping from token ID to owner address
629     mapping(uint256 => address) private _owners;
630 
631     // Mapping owner address to token count
632     mapping(address => uint256) private _balances;
633 
634     // Mapping from token ID to approved address
635     mapping(uint256 => address) private _tokenApprovals;
636 
637     // Mapping from owner to operator approvals
638     mapping(address => mapping(address => bool)) private _operatorApprovals;
639 
640 
641     /**
642      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
643      */
644     constructor(string memory name_, string memory symbol_) {
645         _name = name_;
646         _symbol = symbol_;
647     }
648 
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
653         return
654             interfaceId == type(IERC721).interfaceId ||
655             interfaceId == type(IERC721Metadata).interfaceId ||
656             super.supportsInterface(interfaceId);
657     }
658 
659     function tokenURI(uint256 tokenId)
660     public
661     view
662     virtual
663     override
664     returns (string memory)
665   {
666     require(_exists(tokenId) || tokenId <= maxSupply || maxSupply == 0, "ERC721Metadata: URI query for nonexistent token");
667 
668     string memory currentBaseURI = _baseURI();
669     return bytes(currentBaseURI).length > 0
670         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
671         : "";
672   }
673 
674     /**
675      * @dev See {IERC721-balanceOf}.
676      */
677     function balanceOf(address owner) public view virtual override returns (uint256) {
678         require(owner != address(0), "ERC721: balance query for the zero address");
679         return _balances[owner];
680     }
681 
682     /**
683      * @dev See {IERC721-ownerOf}.
684      */
685     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
686         address owner = _owners[tokenId];
687         require(owner != address(0), "ERC721: owner query for nonexistent token");
688         return owner;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-name}.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-symbol}.
700      */
701     function symbol() public view virtual override returns (string memory) {
702         return _symbol;
703     }
704 
705     /**
706      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
707      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
708      * by default, can be overriden in child contracts.
709      */
710     function _baseURI() internal view virtual returns (string memory) {
711         return "";
712     }
713 
714     /**
715      * @dev See {IERC721-approve}.
716      */
717     function approve(address to, uint256 tokenId) public virtual override {
718         address owner = ERC721.ownerOf(tokenId);
719         require(to != owner, "ERC721: approval to current owner");
720 
721         require(
722             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
723             "ERC721: approve caller is not owner nor approved for all"
724         );
725 
726         _approve(to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-getApproved}.
731      */
732     function getApproved(uint256 tokenId) public view virtual override returns (address) {
733         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
734 
735         return _tokenApprovals[tokenId];
736     }
737 
738     /**
739      * @dev See {IERC721-setApprovalForAll}.
740      */
741     function setApprovalForAll(address operator, bool approved) public virtual override {
742         require(operator != _msgSender(), "ERC721: approve to caller");
743 
744         _operatorApprovals[_msgSender()][operator] = approved;
745         emit ApprovalForAll(_msgSender(), operator, approved);
746     }
747 
748     /**
749      * @dev See {IERC721-isApprovedForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev See {IERC721-transferFrom}.
757      */
758     function transferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         //solhint-disable-next-line max-line-length
764         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
765 
766         _transfer(from, to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) public virtual override {
777         safeTransferFrom(from, to, tokenId, "");
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) public virtual override {
789         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
790         _safeTransfer(from, to, tokenId, _data);
791     }
792 
793     /**
794      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
795      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
796      *
797      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
798      *
799      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
800      * implement alternative mechanisms to perform token transfer, such as signature-based.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must exist and be owned by `from`.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _safeTransfer(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) internal virtual {
817         _transfer(from, to, tokenId);
818         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
819     }
820 
821     /**
822      * @dev Returns whether `tokenId` exists.
823      *
824      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
825      *
826      * Tokens start existing when they are minted (`_mint`),
827      * and stop existing when they are burned (`_burn`).
828      */
829     function _exists(uint256 tokenId) internal view virtual returns (bool) {
830         return _owners[tokenId] != address(0);
831     }
832 
833     /**
834      * @dev Returns whether `spender` is allowed to manage `tokenId`.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
841         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
842         address owner = ERC721.ownerOf(tokenId);
843         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
844     }
845 
846     /**
847      * @dev Safely mints `tokenId` and transfers it to `to`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must not exist.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _safeMint(address to, uint256 tokenId) internal virtual {
857         _safeMint(to, tokenId, "");
858     }
859 
860     /**
861      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
862      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
863      */
864     function _safeMint(
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) internal virtual {
869         _mint(to, tokenId);
870         require(
871             _checkOnERC721Received(address(0), to, tokenId, _data),
872             "ERC721: transfer to non ERC721Receiver implementer"
873         );
874     }
875 
876     /**
877      * @dev Mints `tokenId` and transfers it to `to`.
878      *
879      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
880      *
881      * Requirements:
882      *
883      * - `tokenId` must not exist.
884      * - `to` cannot be the zero address.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _mint(address to, uint256 tokenId) internal virtual {
889         require(to != address(0), "ERC721: mint to the zero address");
890         require(!_exists(tokenId), "ERC721: token already minted");
891 
892         _beforeTokenTransfer(address(0), to, tokenId);
893 
894         _balances[to] += 1;
895         _owners[tokenId] = to;
896 
897         emit Transfer(address(0), to, tokenId);
898     }
899 
900     /**
901      * @dev Destroys `tokenId`.
902      * The approval is cleared when the token is burned.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _burn(uint256 tokenId) internal virtual {
911         address owner = ERC721.ownerOf(tokenId);
912 
913         _beforeTokenTransfer(owner, address(0), tokenId);
914 
915         // Clear approvals
916         _approve(address(0), tokenId);
917 
918         _balances[owner] -= 1;
919         delete _owners[tokenId];
920 
921         emit Transfer(owner, address(0), tokenId);
922     }
923 
924     /**
925      * @dev Transfers `tokenId` from `from` to `to`.
926      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _transfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {
940         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
941         require(to != address(0), "ERC721: transfer to the zero address");
942 
943         _beforeTokenTransfer(from, to, tokenId);
944 
945         // Clear approvals from the previous owner
946         _approve(address(0), tokenId);
947 
948         _balances[from] -= 1;
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(from, to, tokenId);
953     }
954 
955     /**
956      * @dev Approve `to` to operate on `tokenId`
957      *
958      * Emits a {Approval} event.
959      */
960     function _approve(address to, uint256 tokenId) internal virtual {
961         _tokenApprovals[tokenId] = to;
962         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
963     }
964 
965     /**
966      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
967      * The call is not executed if the target address is not a contract.
968      *
969      * @param from address representing the previous owner of the given token ID
970      * @param to target address that will receive the tokens
971      * @param tokenId uint256 ID of the token to be transferred
972      * @param _data bytes optional data to send along with the call
973      * @return bool whether the call correctly returned the expected magic value
974      */
975     function _checkOnERC721Received(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) private returns (bool) {
981         if (to.isContract()) {
982             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
983                 return retval == IERC721Receiver.onERC721Received.selector;
984             } catch (bytes memory reason) {
985                 if (reason.length == 0) {
986                     revert("ERC721: transfer to non ERC721Receiver implementer");
987                 } else {
988                     assembly {
989                         revert(add(32, reason), mload(reason))
990                     }
991                 }
992             }
993         } else {
994             return true;
995         }
996     }
997 
998     /**
999      * @dev Hook that is called before any token transfer. This includes minting
1000      * and burning.
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` will be minted for `to`.
1007      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1008      * - `from` and `to` are never both zero.
1009      *
1010      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1011      */
1012     function _beforeTokenTransfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) internal virtual {}
1017 }
1018 
1019 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1020 
1021 
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 
1026 
1027 /**
1028  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1029  * enumerability of all the token ids in the contract as well as all token ids owned by each
1030  * account.
1031  */
1032 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1033     // Mapping from owner to list of owned token IDs
1034     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1035 
1036     // Mapping from token ID to index of the owner tokens list
1037     mapping(uint256 => uint256) private _ownedTokensIndex;
1038 
1039     // Array with all token ids, used for enumeration
1040     uint256[] private _allTokens;
1041 
1042     // Mapping from token id to position in the allTokens array
1043     mapping(uint256 => uint256) private _allTokensIndex;
1044 
1045     /**
1046      * @dev See {IERC165-supportsInterface}.
1047      */
1048     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1049         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1054      */
1055     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1056         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1057         return _ownedTokens[owner][index];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-totalSupply}.
1062      */
1063     function totalSupply() public view virtual override returns (uint256) {
1064         return _allTokens.length;
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Enumerable-tokenByIndex}.
1069      */
1070     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1071         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1072         return _allTokens[index];
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` cannot be the zero address.
1086      * - `to` cannot be the zero address.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) internal virtual override {
1095         super._beforeTokenTransfer(from, to, tokenId);
1096 
1097         if (from == address(0)) {
1098             _addTokenToAllTokensEnumeration(tokenId);
1099         } else if (from != to) {
1100             _removeTokenFromOwnerEnumeration(from, tokenId);
1101         }
1102         if (to == address(0)) {
1103             _removeTokenFromAllTokensEnumeration(tokenId);
1104         } else if (to != from) {
1105             _addTokenToOwnerEnumeration(to, tokenId);
1106         }
1107     }
1108 
1109     /**
1110      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1111      * @param to address representing the new owner of the given token ID
1112      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1113      */
1114     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1115         uint256 length = ERC721.balanceOf(to);
1116         _ownedTokens[to][length] = tokenId;
1117         _ownedTokensIndex[tokenId] = length;
1118     }
1119 
1120     /**
1121      * @dev Private function to add a token to this extension's token tracking data structures.
1122      * @param tokenId uint256 ID of the token to be added to the tokens list
1123      */
1124     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1125         _allTokensIndex[tokenId] = _allTokens.length;
1126         _allTokens.push(tokenId);
1127     }
1128 
1129     /**
1130      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1131      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1132      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1133      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1134      * @param from address representing the previous owner of the given token ID
1135      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1136      */
1137     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1138         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1139         // then delete the last slot (swap and pop).
1140 
1141         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1142         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1143 
1144         // When the token to delete is the last token, the swap operation is unnecessary
1145         if (tokenIndex != lastTokenIndex) {
1146             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1147 
1148             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1149             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1150         }
1151 
1152         // This also deletes the contents at the last position of the array
1153         delete _ownedTokensIndex[tokenId];
1154         delete _ownedTokens[from][lastTokenIndex];
1155     }
1156 
1157     /**
1158      * @dev Private function to remove a token from this extension's token tracking data structures.
1159      * This has O(1) time complexity, but alters the order of the _allTokens array.
1160      * @param tokenId uint256 ID of the token to be removed from the tokens list
1161      */
1162     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1163         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1164         // then delete the last slot (swap and pop).
1165 
1166         uint256 lastTokenIndex = _allTokens.length - 1;
1167         uint256 tokenIndex = _allTokensIndex[tokenId];
1168 
1169         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1170         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1171         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1172         uint256 lastTokenId = _allTokens[lastTokenIndex];
1173 
1174         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1175         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1176 
1177         // This also deletes the contents at the last position of the array
1178         delete _allTokensIndex[tokenId];
1179         _allTokens.pop();
1180     }
1181 }
1182 
1183 
1184 // File: @openzeppelin/contracts/access/Ownable.sol
1185 pragma solidity ^0.8.0;
1186 /**
1187  * @dev Contract module which provides a basic access control mechanism, where
1188  * there is an account (an owner) that can be granted exclusive access to
1189  * specific functions.
1190  *
1191  * By default, the owner account will be the one that deploys the contract. This
1192  * can later be changed with {transferOwnership}.
1193  *
1194  * This module is used through inheritance. It will make available the modifier
1195  * `onlyOwner`, which can be applied to your functions to restrict their use to
1196  * the owner.
1197  */
1198 abstract contract Ownable is Context {
1199     address private _owner;
1200 
1201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1202 
1203     /**
1204      * @dev Initializes the contract setting the deployer as the initial owner.
1205      */
1206     constructor() {
1207         _setOwner(_msgSender());
1208     }
1209 
1210     /**
1211      * @dev Returns the address of the current owner.
1212      */
1213     function owner() public view virtual returns (address) {
1214         return _owner;
1215     }
1216 
1217     /**
1218      * @dev Throws if called by any account other than the owner.
1219      */
1220     modifier onlyOwner() {
1221         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1222         _;
1223     }
1224 
1225     /**
1226      * @dev Leaves the contract without owner. It will not be possible to call
1227      * `onlyOwner` functions anymore. Can only be called by the current owner.
1228      *
1229      * NOTE: Renouncing ownership will leave the contract without an owner,
1230      * thereby removing any functionality that is only available to the owner.
1231      */
1232     function renounceOwnership() public virtual onlyOwner {
1233         _setOwner(address(0));
1234     }
1235 
1236     /**
1237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1238      * Can only be called by the current owner.
1239      */
1240     function transferOwnership(address newOwner) public virtual onlyOwner {
1241         require(newOwner != address(0), "Ownable: new owner is the zero address");
1242         _setOwner(newOwner);
1243     }
1244 
1245     function _setOwner(address newOwner) private {
1246         address oldOwner = _owner;
1247         _owner = newOwner;
1248         emit OwnershipTransferred(oldOwner, newOwner);
1249     }
1250 }
1251 
1252 
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 interface IBEP20 {
1257     /**
1258      * @dev Returns the amount of tokens in existence.
1259      */
1260     function totalSupply() external view returns (uint256);
1261 
1262     /**
1263      * @dev Returns the token decimals.
1264      */
1265     function decimals() external view returns (uint8);
1266 
1267     /**
1268      * @dev Returns the token symbol.
1269      */
1270     function symbol() external view returns (string memory);
1271 
1272     /**
1273      * @dev Returns the token name.
1274      */
1275     function name() external view returns (string memory);
1276 
1277     /**
1278      * @dev Returns the bep token owner.
1279      */
1280     function getOwner() external view returns (address);
1281 
1282     /**
1283      * @dev Returns the amount of tokens owned by `account`.
1284      */
1285     function balanceOf(address account) external view returns (uint256);
1286 
1287     /**
1288      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1289      *
1290      * Returns a boolean value indicating whether the operation succeeded.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function transfer(address recipient, uint256 amount) external returns (bool);
1295 
1296     /**
1297      * @dev Returns the remaining number of tokens that `spender` will be
1298      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1299      * zero by default.
1300      *
1301      * This value changes when {approve} or {transferFrom} are called.
1302      */
1303     function allowance(address _owner, address spender) external view returns (uint256);
1304 
1305     /**
1306      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1307      *
1308      * Returns a boolean value indicating whether the operation succeeded.
1309      *
1310      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1311      * that someone may use both the old and the new allowance by unfortunate
1312      * transaction ordering. One possible solution to mitigate this race
1313      * condition is to first reduce the spender's allowance to 0 and set the
1314      * desired value afterwards:
1315      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1316      *
1317      * Emits an {Approval} event.
1318      */
1319     function approve(address spender, uint256 amount) external returns (bool);
1320 
1321     /**
1322      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1323      * allowance mechanism. `amount` is then deducted from the caller's
1324      * allowance.
1325      *
1326      * Returns a boolean value indicating whether the operation succeeded.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function transferFrom(
1331         address sender,
1332         address recipient,
1333         uint256 amount
1334     ) external returns (bool);
1335 
1336     /**
1337      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1338      * another (`to`).
1339      *
1340      * Note that `value` may be zero.
1341      */
1342     event Transfer(address indexed from, address indexed to, uint256 value);
1343 
1344     /**
1345      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1346      * a call to {approve}. `value` is the new allowance.
1347      */
1348     event Approval(address indexed owner, address indexed spender, uint256 value);
1349 }
1350 
1351 
1352 
1353 
1354 pragma solidity ^0.8.0;
1355 
1356 
1357 
1358 contract Mojis is ERC721Enumerable, Ownable {
1359   using Strings for uint256;
1360 
1361   string public baseURI;
1362   uint256 public cost = 15 * 1e16;
1363   uint256 public maxMintAmount = 10;
1364   bool public paused = false;
1365   mapping(address => bool) public whitelisted;
1366      
1367   constructor(
1368     string memory _name,
1369     string memory _symbol,
1370     string memory _initBaseURI
1371   ) ERC721(_name, _symbol) {
1372     setBaseURI(_initBaseURI);
1373   }
1374 
1375   // internal
1376   function _baseURI() internal view virtual override returns (string memory) {
1377     return baseURI;
1378   }
1379 
1380   function mint(address _to) public returns (uint256) {
1381     require(!paused);
1382     require(totalSupply() < maxSupply);
1383     require(whitelisted[msg.sender]);
1384     uint256 tokenId = totalSupply() + 1;
1385     _safeMint(_to, tokenId);
1386     return tokenId;
1387   }
1388 
1389   // public
1390   function mint(address _to, uint256 _mintAmount) public payable {
1391     uint256 supply = totalSupply();
1392     require(!paused);
1393     require(_mintAmount > 0);
1394     require(_mintAmount <= maxMintAmount);
1395     require(supply + _mintAmount <= maxSupply);
1396 
1397     if (msg.sender != owner()) {
1398         if(whitelisted[msg.sender] != true) {
1399           require(msg.value >= cost * _mintAmount);
1400         }
1401     }
1402 
1403     for (uint256 i = 1; i <= _mintAmount; i++) {
1404       _safeMint(_to, supply + i);
1405     }
1406   }
1407 
1408   
1409 
1410   function OwnerPreMint(uint256 _mintAmount) external onlyOwner {
1411     uint256 supply = totalSupply();
1412     require(paused);
1413     require(_mintAmount > 0);
1414     require(supply + _mintAmount <= maxSupply);
1415    
1416     
1417     for (uint256 i = 1; i <= _mintAmount; i++) {
1418         _safeMint(msg.sender, supply + i);
1419     }
1420       
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
1436   //only owner
1437   function setCost(uint256 _newCost) public onlyOwner() {
1438     cost = _newCost;
1439   }
1440 
1441   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1442     maxMintAmount = _newmaxMintAmount;
1443   }
1444 
1445   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1446     baseURI = _newBaseURI;
1447   }
1448 
1449   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1450     baseExtension = _newBaseExtension;
1451   }
1452 
1453   function pause(bool _state) public onlyOwner {
1454     paused = _state;
1455   }
1456  
1457  function whitelistUser(address _user) public onlyOwner {
1458     whitelisted[_user] = true;
1459   }
1460  
1461   function removeWhitelistUser(address _user) public onlyOwner {
1462     whitelisted[_user] = false;
1463   }
1464 
1465   function withdraw() public payable onlyOwner {
1466 
1467 (bool hs, ) = payable(0x33cEE6b4967F5447AD7083B57FEeF4aB7D0f0CC6).call{value: address(this).balance * 25 / 100}("");
1468     require(hs);
1469 
1470     (bool fs, ) = payable(0xCA5E85906422f5959ED7aFFAfed667d600Cdb5a1).call{value: address(this).balance * 40 / 100}("");
1471     require(fs);
1472 
1473 (bool ds, ) = payable(0x8374196c929726fd24820C30D2Fe8994af72DCd2).call{value: address(this).balance * 67 / 100}("");
1474     require(ds);
1475 
1476      (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1477     require(os);
1478 
1479 
1480   
1481   }
1482   
1483    
1484 }