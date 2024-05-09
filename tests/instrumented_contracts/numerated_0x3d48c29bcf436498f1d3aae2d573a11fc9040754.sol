1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 pragma solidity ^0.8.0;
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 pragma solidity ^0.8.0;
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 
167 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
168 pragma solidity ^0.8.0;
169 /**
170  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
171  * @dev See https://eips.ethereum.org/EIPS/eip-721
172  */
173 interface IERC721Enumerable is IERC721 {
174     /**
175      * @dev Returns the total amount of tokens stored by the contract.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
181      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
182      */
183     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
184 
185     /**
186      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
187      * Use along with {totalSupply} to enumerate all tokens.
188      */
189     function tokenByIndex(uint256 index) external view returns (uint256);
190 }
191 
192 
193 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
194 pragma solidity ^0.8.0;
195 /**
196  * @dev Implementation of the {IERC165} interface.
197  *
198  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
199  * for the additional interface id that will be supported. For example:
200  *
201  * ```solidity
202  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
203  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
204  * }
205  * ```
206  *
207  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
208  */
209 abstract contract ERC165 is IERC165 {
210     /**
211      * @dev See {IERC165-supportsInterface}.
212      */
213     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
214         return interfaceId == type(IERC165).interfaceId;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Strings.sol
219 
220 
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev String operations.
226  */
227 library Strings {
228     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 }
286 
287 // File: @openzeppelin/contracts/utils/Address.sol
288 
289 
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize, which returns 0 for contracts in
316         // construction, since the code is only stored at the end of the
317         // constructor execution.
318 
319         uint256 size;
320         assembly {
321             size := extcodesize(account)
322         }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{value: amount}("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.call{value: value}(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(isContract(target), "Address: delegate call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
479      * revert reason using the provided one.
480      *
481      * _Available since v4.3._
482      */
483     function verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) internal pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494 
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
515  * @dev See https://eips.ethereum.org/EIPS/eip-721
516  */
517 interface IERC721Metadata is IERC721 {
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
535 
536 
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @title ERC721 token receiver interface
542  * @dev Interface for any contract that wants to support safeTransfers
543  * from ERC721 asset contracts.
544  */
545 interface IERC721Receiver {
546     /**
547      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
548      * by `operator` from `from`, this function is called.
549      *
550      * It must return its Solidity selector to confirm the token transfer.
551      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
552      *
553      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
554      */
555     function onERC721Received(
556         address operator,
557         address from,
558         uint256 tokenId,
559         bytes calldata data
560     ) external returns (bytes4);
561 }
562 
563 // File: @openzeppelin/contracts/utils/Context.sol
564 pragma solidity ^0.8.0;
565 /**
566  * @dev Provides information about the current execution context, including the
567  * sender of the transaction and its data. While these are generally available
568  * via msg.sender and msg.data, they should not be accessed in such a direct
569  * manner, since when dealing with meta-transactions the account sending and
570  * paying for execution may not be the actual sender (as far as an application
571  * is concerned).
572  *
573  * This contract is only required for intermediate, library-like contracts.
574  */
575 abstract contract Context {
576     function _msgSender() internal view virtual returns (address) {
577         return msg.sender;
578     }
579 
580     function _msgData() internal view virtual returns (bytes calldata) {
581         return msg.data;
582     }
583 }
584 
585 
586 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
587 pragma solidity ^0.8.0;
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension, but not including the Enumerable extension, which is available separately as
591  * {ERC721Enumerable}.
592  */
593 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
594     using Address for address;
595     using Strings for uint256;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to owner address
604     mapping(uint256 => address) private _owners;
605 
606     // Mapping owner address to token count
607     mapping(address => uint256) private _balances;
608 
609     // Mapping from token ID to approved address
610     mapping(uint256 => address) private _tokenApprovals;
611 
612     // Mapping from owner to operator approvals
613     mapping(address => mapping(address => bool)) private _operatorApprovals;
614 
615     /**
616      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
617      */
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621     }
622 
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
627         return
628             interfaceId == type(IERC721).interfaceId ||
629             interfaceId == type(IERC721Metadata).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         require(operator != _msgSender(), "ERC721: approve to caller");
712 
713         _operatorApprovals[_msgSender()][operator] = approved;
714         emit ApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
936      * The call is not executed if the target address is not a contract.
937      *
938      * @param from address representing the previous owner of the given token ID
939      * @param to target address that will receive the tokens
940      * @param tokenId uint256 ID of the token to be transferred
941      * @param _data bytes optional data to send along with the call
942      * @return bool whether the call correctly returned the expected magic value
943      */
944     function _checkOnERC721Received(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) private returns (bool) {
950         if (to.isContract()) {
951             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
952                 return retval == IERC721Receiver.onERC721Received.selector;
953             } catch (bytes memory reason) {
954                 if (reason.length == 0) {
955                     revert("ERC721: transfer to non ERC721Receiver implementer");
956                 } else {
957                     assembly {
958                         revert(add(32, reason), mload(reason))
959                     }
960                 }
961             }
962         } else {
963             return true;
964         }
965     }
966 
967     /**
968      * @dev Hook that is called before any token transfer. This includes minting
969      * and burning.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, ``from``'s `tokenId` will be burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _beforeTokenTransfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {}
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 
996 /**
997  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
998  * enumerability of all the token ids in the contract as well as all token ids owned by each
999  * account.
1000  */
1001 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1002     // Mapping from owner to list of owned token IDs
1003     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1004 
1005     // Mapping from token ID to index of the owner tokens list
1006     mapping(uint256 => uint256) private _ownedTokensIndex;
1007 
1008     // Array with all token ids, used for enumeration
1009     uint256[] private _allTokens;
1010 
1011     // Mapping from token id to position in the allTokens array
1012     mapping(uint256 => uint256) private _allTokensIndex;
1013 
1014     /**
1015      * @dev See {IERC165-supportsInterface}.
1016      */
1017     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1018         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1023      */
1024     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1026         return _ownedTokens[owner][index];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-totalSupply}.
1031      */
1032     function totalSupply() public view virtual override returns (uint256) {
1033         return _allTokens.length;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenByIndex}.
1038      */
1039     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1041         return _allTokens[index];
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before any token transfer. This includes minting
1046      * and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1051      * transferred to `to`.
1052      * - When `from` is zero, `tokenId` will be minted for `to`.
1053      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1054      * - `from` cannot be the zero address.
1055      * - `to` cannot be the zero address.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _beforeTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual override {
1064         super._beforeTokenTransfer(from, to, tokenId);
1065 
1066         if (from == address(0)) {
1067             _addTokenToAllTokensEnumeration(tokenId);
1068         } else if (from != to) {
1069             _removeTokenFromOwnerEnumeration(from, tokenId);
1070         }
1071         if (to == address(0)) {
1072             _removeTokenFromAllTokensEnumeration(tokenId);
1073         } else if (to != from) {
1074             _addTokenToOwnerEnumeration(to, tokenId);
1075         }
1076     }
1077 
1078     /**
1079      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1080      * @param to address representing the new owner of the given token ID
1081      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1082      */
1083     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1084         uint256 length = ERC721.balanceOf(to);
1085         _ownedTokens[to][length] = tokenId;
1086         _ownedTokensIndex[tokenId] = length;
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's token tracking data structures.
1091      * @param tokenId uint256 ID of the token to be added to the tokens list
1092      */
1093     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1094         _allTokensIndex[tokenId] = _allTokens.length;
1095         _allTokens.push(tokenId);
1096     }
1097 
1098     /**
1099      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1100      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1101      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1102      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1103      * @param from address representing the previous owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1105      */
1106     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1107         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1108         // then delete the last slot (swap and pop).
1109 
1110         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1111         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1112 
1113         // When the token to delete is the last token, the swap operation is unnecessary
1114         if (tokenIndex != lastTokenIndex) {
1115             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1116 
1117             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1118             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1119         }
1120 
1121         // This also deletes the contents at the last position of the array
1122         delete _ownedTokensIndex[tokenId];
1123         delete _ownedTokens[from][lastTokenIndex];
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's token tracking data structures.
1128      * This has O(1) time complexity, but alters the order of the _allTokens array.
1129      * @param tokenId uint256 ID of the token to be removed from the tokens list
1130      */
1131     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1132         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1133         // then delete the last slot (swap and pop).
1134 
1135         uint256 lastTokenIndex = _allTokens.length - 1;
1136         uint256 tokenIndex = _allTokensIndex[tokenId];
1137 
1138         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1139         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1140         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1141         uint256 lastTokenId = _allTokens[lastTokenIndex];
1142 
1143         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1144         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1145 
1146         // This also deletes the contents at the last position of the array
1147         delete _allTokensIndex[tokenId];
1148         _allTokens.pop();
1149     }
1150 }
1151 
1152 
1153 // File: @openzeppelin/contracts/access/Ownable.sol
1154 pragma solidity ^0.8.0;
1155 /**
1156  * @dev Contract module which provides a basic access control mechanism, where
1157  * there is an account (an owner) that can be granted exclusive access to
1158  * specific functions.
1159  *
1160  * By default, the owner account will be the one that deploys the contract. This
1161  * can later be changed with {transferOwnership}.
1162  *
1163  * This module is used through inheritance. It will make available the modifier
1164  * `onlyOwner`, which can be applied to your functions to restrict their use to
1165  * the owner.
1166  */
1167 abstract contract Ownable is Context {
1168     address private _owner;
1169 
1170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1171 
1172     /**
1173      * @dev Initializes the contract setting the deployer as the initial owner.
1174      */
1175     constructor() {
1176         _setOwner(_msgSender());
1177     }
1178 
1179     /**
1180      * @dev Returns the address of the current owner.
1181      */
1182     function owner() public view virtual returns (address) {
1183         return _owner;
1184     }
1185 
1186     /**
1187      * @dev Throws if called by any account other than the owner.
1188      */
1189     modifier onlyOwner() {
1190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1191         _;
1192     }
1193 
1194     /**
1195      * @dev Leaves the contract without owner. It will not be possible to call
1196      * `onlyOwner` functions anymore. Can only be called by the current owner.
1197      *
1198      * NOTE: Renouncing ownership will leave the contract without an owner,
1199      * thereby removing any functionality that is only available to the owner.
1200      */
1201     function renounceOwnership() public virtual onlyOwner {
1202         _setOwner(address(0));
1203     }
1204 
1205     /**
1206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1207      * Can only be called by the current owner.
1208      */
1209     function transferOwnership(address newOwner) public virtual onlyOwner {
1210         require(newOwner != address(0), "Ownable: new owner is the zero address");
1211         _setOwner(newOwner);
1212     }
1213 
1214     function _setOwner(address newOwner) private {
1215         address oldOwner = _owner;
1216         _owner = newOwner;
1217         emit OwnershipTransferred(oldOwner, newOwner);
1218     }
1219 }
1220 pragma solidity >=0.7.0 <0.9.0;
1221 
1222 
1223 contract MindFulls is ERC721Enumerable, Ownable {
1224   using Strings for uint256;
1225 
1226   string public baseURI;
1227   string public baseExtension = ".json";
1228   string public notRevealedUri;
1229   uint256 public cost = 0.04 ether;
1230   uint256 public maxSupply = 1111;
1231   uint256 public maxMintAmount = 20;
1232   uint256 public nftPerAddressLimit = 5;
1233   bool public paused = false;
1234   bool public revealed = false;
1235   bool public onlyWhitelisted = true;
1236   address[] public whitelistedAddresses;
1237   mapping(address => uint256) public addressMintedBalance;
1238 
1239 
1240   constructor(
1241     string memory _name,
1242     string memory _symbol,
1243     string memory _initBaseURI,
1244     string memory _initNotRevealedUri
1245   ) ERC721(_name, _symbol) {
1246     setBaseURI(_initBaseURI);
1247     setNotRevealedURI(_initNotRevealedUri);
1248   }
1249 
1250   // internal
1251   function _baseURI() internal view virtual override returns (string memory) {
1252     return baseURI;
1253   }
1254 
1255   // public
1256   function mint(uint256 _mintAmount) public payable {
1257     require(!paused, "the contract is paused");
1258     uint256 supply = totalSupply();
1259     require(_mintAmount > 0, "need to mint at least 1 NFT");
1260     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1261     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1262 
1263     if (msg.sender != owner()) {
1264         if(onlyWhitelisted == true) {
1265             require(isWhitelisted(msg.sender), "user is not whitelisted");
1266             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1267             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1268         }
1269         require(msg.value >= cost * _mintAmount, "insufficient funds");
1270     }
1271     
1272     for (uint256 i = 1; i <= _mintAmount; i++) {
1273         addressMintedBalance[msg.sender]++;
1274       _safeMint(msg.sender, supply + i);
1275     }
1276   }
1277   
1278   function isWhitelisted(address _user) public view returns (bool) {
1279     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1280       if (whitelistedAddresses[i] == _user) {
1281           return true;
1282       }
1283     }
1284     return false;
1285   }
1286 
1287   function walletOfOwner(address _owner)
1288     public
1289     view
1290     returns (uint256[] memory)
1291   {
1292     uint256 ownerTokenCount = balanceOf(_owner);
1293     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1294     for (uint256 i; i < ownerTokenCount; i++) {
1295       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1296     }
1297     return tokenIds;
1298   }
1299 
1300   function tokenURI(uint256 tokenId)
1301     public
1302     view
1303     virtual
1304     override
1305     returns (string memory)
1306   {
1307     require(
1308       _exists(tokenId),
1309       "ERC721Metadata: URI query for nonexistent token"
1310     );
1311     
1312     if(revealed == false) {
1313         return notRevealedUri;
1314     }
1315 
1316     string memory currentBaseURI = _baseURI();
1317     return bytes(currentBaseURI).length > 0
1318         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1319         : "";
1320   }
1321 
1322   //only owner
1323   function reveal() public onlyOwner {
1324       revealed = true;
1325   }
1326   
1327   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1328     nftPerAddressLimit = _limit;
1329   }
1330   
1331   function setCost(uint256 _newCost) public onlyOwner {
1332     cost = _newCost;
1333   }
1334 
1335   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1336     maxMintAmount = _newmaxMintAmount;
1337   }
1338 
1339   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1340     baseURI = _newBaseURI;
1341   }
1342 
1343   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1344     baseExtension = _newBaseExtension;
1345   }
1346   
1347   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1348     notRevealedUri = _notRevealedURI;
1349   }
1350 
1351   function pause(bool _state) public onlyOwner {
1352     paused = _state;
1353   }
1354   
1355   function setOnlyWhitelisted(bool _state) public onlyOwner {
1356     onlyWhitelisted = _state;
1357   }
1358   
1359   function whitelistUsers(address[] calldata _users) public onlyOwner {
1360     delete whitelistedAddresses;
1361     whitelistedAddresses = _users;
1362   }
1363  
1364   function withdraw() public payable onlyOwner {
1365     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1366     require(os);
1367   }
1368 }