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
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
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
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-tokenByIndex}.
1039      */
1040     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1041         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1042         return _allTokens[index];
1043     }
1044 
1045     /**
1046      * @dev Hook that is called before any token transfer. This includes minting
1047      * and burning.
1048      *
1049      * Calling conditions:
1050      *
1051      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1052      * transferred to `to`.
1053      * - When `from` is zero, `tokenId` will be minted for `to`.
1054      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1055      * - `from` cannot be the zero address.
1056      * - `to` cannot be the zero address.
1057      *
1058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1059      */
1060     function _beforeTokenTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) internal virtual override {
1065         super._beforeTokenTransfer(from, to, tokenId);
1066 
1067         if (from == address(0)) {
1068             _addTokenToAllTokensEnumeration(tokenId);
1069         } else if (from != to) {
1070             _removeTokenFromOwnerEnumeration(from, tokenId);
1071         }
1072         if (to == address(0)) {
1073             _removeTokenFromAllTokensEnumeration(tokenId);
1074         } else if (to != from) {
1075             _addTokenToOwnerEnumeration(to, tokenId);
1076         }
1077     }
1078 
1079     /**
1080      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1081      * @param to address representing the new owner of the given token ID
1082      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1083      */
1084     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1085         uint256 length = ERC721.balanceOf(to);
1086         _ownedTokens[to][length] = tokenId;
1087         _ownedTokensIndex[tokenId] = length;
1088     }
1089 
1090     /**
1091      * @dev Private function to add a token to this extension's token tracking data structures.
1092      * @param tokenId uint256 ID of the token to be added to the tokens list
1093      */
1094     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1095         _allTokensIndex[tokenId] = _allTokens.length;
1096         _allTokens.push(tokenId);
1097     }
1098 
1099     /**
1100      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1101      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1102      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1103      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1104      * @param from address representing the previous owner of the given token ID
1105      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1106      */
1107     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1108         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1109         // then delete the last slot (swap and pop).
1110 
1111         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1112         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1113 
1114         // When the token to delete is the last token, the swap operation is unnecessary
1115         if (tokenIndex != lastTokenIndex) {
1116             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1117 
1118             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1119             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1120         }
1121 
1122         // This also deletes the contents at the last position of the array
1123         delete _ownedTokensIndex[tokenId];
1124         delete _ownedTokens[from][lastTokenIndex];
1125     }
1126 
1127     /**
1128      * @dev Private function to remove a token from this extension's token tracking data structures.
1129      * This has O(1) time complexity, but alters the order of the _allTokens array.
1130      * @param tokenId uint256 ID of the token to be removed from the tokens list
1131      */
1132     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1133         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1134         // then delete the last slot (swap and pop).
1135 
1136         uint256 lastTokenIndex = _allTokens.length - 1;
1137         uint256 tokenIndex = _allTokensIndex[tokenId];
1138 
1139         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1140         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1141         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1142         uint256 lastTokenId = _allTokens[lastTokenIndex];
1143 
1144         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1145         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1146 
1147         // This also deletes the contents at the last position of the array
1148         delete _allTokensIndex[tokenId];
1149         _allTokens.pop();
1150     }
1151 }
1152 
1153 
1154 // File: @openzeppelin/contracts/access/Ownable.sol
1155 pragma solidity ^0.8.0;
1156 /**
1157  * @dev Contract module which provides a basic access control mechanism, where
1158  * there is an account (an owner) that can be granted exclusive access to
1159  * specific functions.
1160  *
1161  * By default, the owner account will be the one that deploys the contract. This
1162  * can later be changed with {transferOwnership}.
1163  *
1164  * This module is used through inheritance. It will make available the modifier
1165  * `onlyOwner`, which can be applied to your functions to restrict their use to
1166  * the owner.
1167  */
1168 abstract contract Ownable is Context {
1169     address private _owner;
1170 
1171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1172 
1173     /**
1174      * @dev Initializes the contract setting the deployer as the initial owner.
1175      */
1176     constructor() {
1177         _setOwner(_msgSender());
1178     }
1179 
1180     /**
1181      * @dev Returns the address of the current owner.
1182      */
1183     function owner() public view virtual returns (address) {
1184         return _owner;
1185     }
1186 
1187     /**
1188      * @dev Throws if called by any account other than the owner.
1189      */
1190     modifier onlyOwner() {
1191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1192         _;
1193     }
1194 
1195     /**
1196      * @dev Leaves the contract without owner. It will not be possible to call
1197      * `onlyOwner` functions anymore. Can only be called by the current owner.
1198      *
1199      * NOTE: Renouncing ownership will leave the contract without an owner,
1200      * thereby removing any functionality that is only available to the owner.
1201      */
1202     function renounceOwnership() public virtual onlyOwner {
1203         _setOwner(address(0));
1204     }
1205 
1206     /**
1207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1208      * Can only be called by the current owner.
1209      */
1210     function transferOwnership(address newOwner) public virtual onlyOwner {
1211         require(newOwner != address(0), "Ownable: new owner is the zero address");
1212         _setOwner(newOwner);
1213     }
1214 
1215     function _setOwner(address newOwner) private {
1216         address oldOwner = _owner;
1217         _owner = newOwner;
1218         emit OwnershipTransferred(oldOwner, newOwner);
1219     }
1220 }
1221 
1222 pragma solidity >=0.7.0 <0.9.0;
1223 
1224 //**********************************************************
1225 //**********************************************************
1226 //**********************************************************
1227 //***************&G5Y5G&************************************
1228 //**************B?!~~~!JG***********************************
1229 //*************B7!^::^!!?5**********************************
1230 //************#?!~::::~!J?B*********************************
1231 //************P7!^^~~~!75JJ*********************************
1232 //***********&Y77!77777JPY!#**********************&#BBB#&***
1233 //***********BJ777?JJ?J5PJ75*******************#GY?7!~~!J#**
1234 //**********BY????5PP5PPY77J&&&**************BYJ7!!~^::^!P**
1235 //*********BJ????YPP55YJ7777777?JYPB&*****&GJ?5J!!~::^:^!G**
1236 //*********PYJJJYP5J??7777?7777777!77J5G&P?7JPY777!~::^~J&**
1237 //*********G5GPGPY77???JYJ777777???77777777?5PJ??77!:^~?B***
1238 //**********BPBP?JYYYYYYJ?7!7!!!!!77?777777YPP5P5?77!!JB****
1239 //***********&5?P5Y5~!G55??7?JJ?7!!!777?J?7?YPPP5??77Y#*****
1240 //***********P7P5?YB##&&5?JJJYYJJ?7777?JJJ?77YP5J????G******
1241 //**********&?75GGJPGB##57?YYY5YY?7?JY5YYYJ?7YP5JJ??JB******
1242 //*********&?77~JBBGGGP5Y5555YJJ?7JP#&G!^YG?7JBP5YY5G&******
1243 //*********B7??77J5GGGGGB&&BGGBP??P#&&#BPJYP7?BBGGG#********
1244 //*********&JYPGGGGGGPPPP#&&&&##G5GGPPPYJYP5!5###&**********
1245 //**********B5BGGGGGPPPPGB##GPPGGGGGGBBGG5577#**************
1246 //***********#BBBBBBBBGPPPGBBGP5PGGP5J??777Y#***************
1247 //**********#YJ55PGBGBJ7??J5BBBBPGGGGY!!77J&****************
1248 //*********#7777??J55PP5JY5GB#B#BGGGGY??J5#*****************
1249 //*********YY?77777J5Y?JJGPY5PGGBBGP555G#*******************
1250 //********&Y777!??77JY~^^!!^?YJJJYYYYYJY********************
1251 //********GJ?!!JJ?777~:::^^^^7?77777??Y?B*******************
1252 //*******B7JJ7?77J?7^.       .~?7777!!JJ5*******************
1253 //******&Y?YJ?77PJ77?7.     .~7?YJ77!7?YJ*******************
1254 //*****#BYJ?77!5P?7?!:        ~7JP777!?YY*******************
1255 //****P?5??777!GPY?^          ^JYP?7?7775*******************
1256 //*****B5????7!B#5~^:::.....:^YY5B?7777?P*******************
1257 //****#5J??JJ?7#*&B5J7!~~^~~~?GB&*J7?JJYJY#*****************
1258 //****BYJJ?7??J&******&#BBB#&****#?777?7??Y&****************
1259 //******&#####&*******************#G55PPG##*****************
1260 //**********************************************************
1261 //**********************************************************
1262 //**********************************************************
1263 
1264 contract SparklesDogs is ERC721Enumerable, Ownable {
1265   using Strings for uint256;
1266 
1267   uint256 public cost = 0.02 ether;
1268   uint256 public maxSupply = 1000;
1269   uint256 public maxMintAmount = 5;
1270   uint256 public tokenAddress;
1271 
1272   bool public paused;
1273 
1274   using Strings for uint256;
1275         
1276 // Optional mapping for token URIs
1277     mapping (uint256 => string) private _tokenURIs;
1278 
1279   constructor(
1280     string memory _name,
1281     string memory _symbol,
1282     uint256 _tokenAddress
1283 
1284   ) 
1285   ERC721(_name, _symbol) {
1286     setTokenAddress(_tokenAddress);
1287     }
1288 
1289  
1290   
1291    function mintOneGift(address to, uint256 tokenId,  string memory _nftUri  ) public onlyOwner {
1292 
1293     require (tokenId > 881);
1294     require (tokenId < 1000);
1295       
1296     _safeMint(to, tokenId );
1297     _setTokenURI(tokenId,  _nftUri);
1298    }
1299   
1300   
1301   function mintFive(uint256 _mintAmount1, uint256 _mintAmount2, uint256 _mintAmount3, uint256 _mintAmount4, uint256 _mintAmount5
1302   , string[] memory _nftUri ) public payable {
1303     
1304     require(!paused);
1305     uint256 mintAmount1 = (_mintAmount1 - tokenAddress) / 1000000;
1306     uint256 _breeds1 = (_mintAmount1 - tokenAddress) % 1000;
1307     require (_breeds1 + mintAmount1 <= 882); 
1308 
1309     if(_breeds1 % 21 != 0)
1310     {
1311         require(_exists(_breeds1 - 1), "ERC721Metadata: URI set of nonexistent token");
1312     }
1313     require((mintAmount1 + _breeds1 <= (((_mintAmount1 - tokenAddress) % 100000) / 1000*21)));
1314 
1315     uint256 mintAmount2 = _mintAmount2 / 1000000;
1316     uint256 _breeds2 = _mintAmount2 % 1000;
1317     require (_breeds2 + mintAmount2 <= 882);
1318 
1319     if(_breeds2 % 21 != 0)
1320     {
1321         require(_exists(_breeds2 - 1), "ERC721Metadata: URI set of nonexistent token");
1322     }
1323     require((mintAmount2 + _breeds2 <= ((_mintAmount2 % 100000) / 1000*21)));
1324 
1325     uint256 mintAmount3 = _mintAmount3 / 1000000;
1326     uint256 _breeds3 = _mintAmount3 % 1000;
1327     require (_breeds3 + mintAmount3 <= 882);
1328 
1329     if(_breeds3 % 21 != 0)
1330     {
1331         require(_exists(_breeds3 - 1), "ERC721Metadata: URI set of nonexistent token");
1332     }
1333     require((mintAmount3 + _breeds3 <= ((_mintAmount3 % 100000) / 1000*21)));
1334 
1335     uint256 mintAmount4 = _mintAmount4 / 1000000;
1336     uint256 _breeds4 = _mintAmount4 % 1000;
1337     require (_breeds4 + mintAmount4 <= 882);
1338 
1339     if(_breeds4 % 21 != 0)
1340     {
1341         require(_exists(_breeds4 - 1), "ERC721Metadata: URI set of nonexistent token");
1342     }
1343     require((mintAmount4 + _breeds4 <= ((_mintAmount4 % 100000) / 1000*21)));
1344 
1345     uint256 mintAmount5 = _mintAmount5 / 1000000;
1346     uint256 _breeds5 = _mintAmount5 % 1000;
1347     require (_breeds5  + mintAmount5 <= 882);
1348 
1349     if(_breeds5 % 21 != 0)
1350     {
1351         require(_exists(_breeds5 - 1), "ERC721Metadata: URI set of nonexistent token");
1352     }
1353     require((mintAmount5 + _breeds5 <= ((_mintAmount5 % 100000) / 1000*21)));
1354  
1355     require(mintAmount1 == 1);    
1356     require(mintAmount2 == 1);
1357     require(mintAmount3 == 1);
1358     require(mintAmount4 == 1);
1359     require(mintAmount5 == 1);
1360    
1361     if (msg.sender != owner()) {
1362       require(msg.value >= cost * mintAmount1*5 );
1363     }
1364 
1365     for (uint256 i = _breeds1; i < mintAmount1 + _breeds1; i++) {
1366         _safeMint(msg.sender,i);
1367         _setTokenURI(i,  _nftUri[0]);
1368         
1369     }
1370 
1371     for (uint256 i = _breeds2; i < mintAmount2 + _breeds2; i++) {
1372         _safeMint(msg.sender,i);
1373         _setTokenURI(i,  _nftUri[1]);
1374         
1375     }
1376 
1377     for (uint256 i = _breeds3; i < mintAmount3 + _breeds3; i++) {
1378         _safeMint(msg.sender,i);
1379         _setTokenURI(i,  _nftUri[2]);
1380         
1381     }
1382 
1383     for (uint256 i = _breeds4; i < mintAmount4 + _breeds4; i++) {
1384         _safeMint(msg.sender,i);
1385         _setTokenURI(i,  _nftUri[3]);
1386         
1387     }
1388 
1389     for (uint256 i = _breeds5; i < mintAmount5 + _breeds5; i++) {
1390         _safeMint(msg.sender,i);
1391         _setTokenURI(i,  _nftUri[4]);
1392     }
1393     
1394   }
1395 
1396   function mintFour(uint256 _mintAmount1, uint256 _mintAmount2, uint256 _mintAmount3, uint256 _mintAmount4
1397   , string[] memory _nftUri ) public payable {
1398 
1399     require(!paused);
1400     uint8 j = 0;
1401     uint256 mintAmount1 = (_mintAmount1 - tokenAddress) / 1000000;
1402     uint256 _breeds1 = (_mintAmount1 - tokenAddress) % 1000;
1403     require (_breeds1 + mintAmount1 <= 882); 
1404 
1405     if(_breeds1 % 21 != 0)
1406     {
1407         require(_exists(_breeds1 - 1), "ERC721Metadata: URI set of nonexistent token");
1408     }
1409     require((mintAmount1 + _breeds1 <= (((_mintAmount1 - tokenAddress) % 100000) / 1000*21)));
1410 
1411     uint256 mintAmount2 = _mintAmount2 / 1000000;
1412     uint256 _breeds2 = _mintAmount2 % 1000;
1413     require (_breeds2 + mintAmount2 <= 882);
1414 
1415     if(_breeds2 % 21 != 0)
1416     {
1417         require(_exists(_breeds2 - 1), "ERC721Metadata: URI set of nonexistent token");
1418     }
1419     require((mintAmount2 + _breeds2 <= ((_mintAmount2 % 100000) / 1000*21)));
1420 
1421     uint256 mintAmount3 = _mintAmount3 / 1000000;
1422     uint256 _breeds3 = _mintAmount3 % 1000;
1423     require (_breeds3 + mintAmount3 <= 882);
1424 
1425     if(_breeds3 % 21 != 0)
1426     {
1427         require(_exists(_breeds3 - 1), "ERC721Metadata: URI set of nonexistent token");
1428     }
1429     require((mintAmount3 + _breeds3 <= ((_mintAmount3 % 100000) / 1000*21)));
1430 
1431     uint256 mintAmount4 = _mintAmount4 / 1000000;
1432     uint256 _breeds4 = _mintAmount4 % 1000;
1433     require (_breeds4 + mintAmount4 <= 882);
1434 
1435     if(_breeds4 % 21 != 0)
1436     {
1437         require(_exists(_breeds4 - 1), "ERC721Metadata: URI set of nonexistent token");
1438     }
1439     require((mintAmount4 + _breeds4 <= ((_mintAmount4 % 100000) / 1000*21)));
1440 
1441     require(mintAmount1 > 0); 
1442     require(mintAmount2 > 0); 
1443     require(mintAmount3 > 0); 
1444     require(mintAmount4 > 0);    
1445       
1446     require(mintAmount1+mintAmount2+mintAmount3+mintAmount4  <= maxMintAmount);
1447 
1448     if (msg.sender != owner()) {
1449       require(msg.value >= cost * (mintAmount1+mintAmount2+mintAmount3+mintAmount4 ));
1450     }
1451        
1452     for (uint256 i = _breeds1; i < mintAmount1 + _breeds1; i++) {
1453         _safeMint(msg.sender,i);
1454         _setTokenURI(i,  _nftUri[j]);
1455         j++;
1456     }
1457 
1458     for (uint256 i = _breeds2; i < mintAmount2 + _breeds2; i++) {
1459         _safeMint(msg.sender,i);
1460         _setTokenURI(i,  _nftUri[j]);
1461         j++;
1462     }
1463 
1464     for (uint256 i = _breeds3; i < mintAmount3 + _breeds3; i++) {
1465         _safeMint(msg.sender,i);
1466         _setTokenURI(i,  _nftUri[j]);
1467         j++;
1468     }
1469     for (uint256 i = _breeds4; i < mintAmount4 + _breeds4; i++) {
1470         _safeMint(msg.sender,i);
1471         _setTokenURI(i,  _nftUri[j]);
1472         j++;
1473     }
1474 
1475   }
1476 
1477    function mintThree(uint256 _mintAmount1, uint256 _mintAmount2, uint256 _mintAmount3,  string[] memory _nftUri) public payable {
1478     
1479     require(!paused);
1480     uint8 j = 0;
1481     uint256 mintAmount1 = (_mintAmount1 - tokenAddress) / 1000000;
1482     uint256 _breeds1 = (_mintAmount1 - tokenAddress) % 1000;
1483     require (_breeds1 + mintAmount1 <= 882); 
1484 
1485         if(_breeds1 % 21 != 0)
1486     {
1487         require(_exists(_breeds1 - 1), "ERC721Metadata: URI set of nonexistent token");
1488     }
1489     require((mintAmount1 + _breeds1 <= (((_mintAmount1 - tokenAddress) % 100000) / 1000*21)));
1490 
1491     uint256 mintAmount2 = _mintAmount2 / 1000000;
1492     uint256 _breeds2 = _mintAmount2 % 1000;
1493     require (_breeds2 + mintAmount2 <= 882);
1494 
1495         if(_breeds2 % 21 != 0)
1496     {
1497         require(_exists(_breeds2 - 1), "ERC721Metadata: URI set of nonexistent token");
1498     }
1499     require((mintAmount2 + _breeds2 <= ((_mintAmount2 % 100000) / 1000*21)));
1500 
1501     uint256 mintAmount3 = _mintAmount3 / 1000000;
1502     uint256 _breeds3 = _mintAmount3 % 1000;
1503     require (_breeds3 + mintAmount3 <= 882);
1504 
1505         if(_breeds3 % 21 != 0)
1506     {
1507         require(_exists(_breeds3 - 1), "ERC721Metadata: URI set of nonexistent token");
1508     }
1509     require((mintAmount3 + _breeds3 <= ((_mintAmount3 % 100000) / 1000*21)));
1510 
1511     require(mintAmount1 > 0); 
1512     require(mintAmount2 > 0); 
1513     require(mintAmount3 > 0); 
1514        
1515     require(mintAmount1+mintAmount2+mintAmount3  <= maxMintAmount);
1516 
1517     if (msg.sender != owner()) {
1518       require(msg.value >= cost * (mintAmount1+mintAmount2+mintAmount3 ));
1519     }
1520        
1521     for (uint256 i = _breeds1; i < mintAmount1 + _breeds1; i++) {
1522         _safeMint(msg.sender,i);
1523         _setTokenURI(i,  _nftUri[j]);
1524         j++;
1525     }
1526 
1527     for (uint256 i = _breeds2; i < mintAmount2 + _breeds2; i++) {
1528         _safeMint(msg.sender,i);
1529         _setTokenURI(i,  _nftUri[j]);
1530         j++;
1531     }
1532 
1533     for (uint256 i = _breeds3; i < mintAmount3 + _breeds3; i++) {
1534         _safeMint(msg.sender,i);
1535         _setTokenURI(i,  _nftUri[j]);
1536         j++;
1537     }
1538      
1539   }
1540 
1541   function mintTwo(uint256 _mintAmount1, uint256 _mintAmount2, string[] memory _nftUri) public payable {
1542     
1543     require(!paused);
1544     uint8 j = 0;
1545     uint256 mintAmount1 = (_mintAmount1 - tokenAddress) / 1000000;
1546     uint256 _breeds1 = (_mintAmount1 - tokenAddress) % 1000;
1547     require (_breeds1 + mintAmount1 <= 882);
1548 
1549     if(_breeds1 % 21 != 0)
1550     {
1551         require(_exists(_breeds1 - 1), "ERC721Metadata: URI set of nonexistent token");
1552     }
1553     require((mintAmount1 + _breeds1 <= (((_mintAmount1 - tokenAddress) % 100000) / 1000*21)));
1554 
1555     uint256 mintAmount2 = _mintAmount2 / 1000000;
1556     uint256 _breeds2 = _mintAmount2 % 1000;
1557     require (_breeds2 + mintAmount2 <= 882);
1558 
1559     if(_breeds2 % 21 != 0)
1560     {
1561         require(_exists(_breeds2 - 1), "ERC721Metadata: URI set of nonexistent token");
1562     }
1563     require((mintAmount2 + _breeds2 <= ((_mintAmount2 % 100000) / 1000*21)));
1564     
1565     require(mintAmount1 > 0); 
1566     require(mintAmount2 > 0); 
1567     
1568     require(mintAmount1 + mintAmount2  <= maxMintAmount);
1569 
1570     if (msg.sender != owner()) {
1571        require(msg.value >= cost * (mintAmount1 + mintAmount2 ));
1572     }
1573              
1574     for (uint256 i = _breeds1; i < mintAmount1 + _breeds1; i++) {
1575         _safeMint(msg.sender,i);
1576         _setTokenURI(i,  _nftUri[j]);
1577         j++;
1578     }
1579 
1580     for (uint256 i = _breeds2; i < mintAmount2 + _breeds2; i++) {
1581         _safeMint(msg.sender,i);
1582         _setTokenURI(i,  _nftUri[j]);
1583         j++;
1584     }
1585   }
1586 
1587    function mintOne(uint256 _mintAmount1,string[] memory _nftUri) public payable {
1588     
1589     require(!paused);
1590     uint8 j = 0;
1591     uint256 mintAmount1 = (_mintAmount1 - tokenAddress) / 1000000 ;
1592     uint256 _breeds1 = (_mintAmount1 - tokenAddress) % 1000;
1593     require (_breeds1 + mintAmount1 <= 882); 
1594 
1595     if(_breeds1 % 21 != 0)
1596     {
1597         require(_exists(_breeds1 - 1), "ERC721Metadata: URI set of nonexistent token");
1598     }
1599     require((mintAmount1 + _breeds1 <= (((_mintAmount1 - tokenAddress) % 100000) / 1000*21)));
1600 
1601     require(mintAmount1 > 0);    
1602     require(mintAmount1  <= maxMintAmount);
1603 
1604 
1605     if (msg.sender != owner()) {
1606        require(msg.value >= cost * (mintAmount1 ));
1607     }
1608     for (uint256 i = _breeds1; i < mintAmount1 + _breeds1; i++) {
1609         _safeMint(msg.sender,i);
1610         _setTokenURI(i,  _nftUri[j]);
1611         j++;
1612     }
1613    }
1614 
1615   function walletOfOwner(address _owner)
1616     public
1617     view
1618     returns (uint256[] memory)
1619   {
1620     uint256 ownerTokenCount = balanceOf(_owner);
1621     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1622     for (uint256 i; i < ownerTokenCount; i++) {
1623       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1624     }
1625     return tokenIds;
1626   }
1627       
1628     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1629         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1630         _tokenURIs[tokenId] = _tokenURI;
1631     }
1632         
1633 
1634     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1635         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1636 
1637         string memory _tokenURI = _tokenURIs[tokenId];
1638         return _tokenURI;
1639            
1640     }
1641 
1642 
1643   function setTokenURI(          
1644             uint256 _tokenId,
1645             string memory tokenURI_
1646         ) external onlyOwner() {
1647            
1648             _setTokenURI(_tokenId, tokenURI_);
1649         }     
1650 
1651 
1652   function setCost(uint256 _newCost) public onlyOwner() {
1653     cost = _newCost;
1654   }
1655 
1656    function setTokenAddress(uint256 _newAddress) public onlyOwner() {
1657     tokenAddress = _newAddress;
1658   }
1659 
1660   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1661     maxMintAmount = _newmaxMintAmount;
1662   }
1663 
1664   function pause(bool _state) public onlyOwner {
1665     paused = _state;
1666   }
1667   
1668   function withdraw() public payable onlyOwner {
1669     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1670     require(success);
1671   }
1672 
1673     
1674   function tokenByIndexBreed(uint256 _startID)  public
1675     view
1676     returns (uint256)
1677   {
1678     uint256 j;
1679     uint256 totalSup = totalSupply();
1680     for (uint256 i = 0; i < totalSup; i++) {
1681         uint256 tokenbyind = tokenByIndex(i);
1682         if(  tokenbyind >= _startID && tokenbyind < (_startID + 21)    ){
1683         j++;  
1684       }         
1685   }
1686     return j;   
1687   }
1688 
1689    function allTokens()  public
1690     view
1691     returns (uint256[] memory)
1692   {
1693     uint256 j;
1694     uint256[] memory tokenIds = new uint256[](totalSupply());
1695 
1696     for (uint256 i = 0; i < totalSupply(); i++) {
1697      
1698       if(tokenByIndex(i) >= 0 && tokenByIndex(i) < maxSupply ){
1699         j++;  
1700          tokenIds[i] = tokenByIndex(i);
1701       }         
1702   }
1703     return tokenIds;   
1704   }
1705 
1706      function allTokensInt(uint256 _start, uint256 _end)  public
1707     view
1708     returns (uint256[] memory)
1709   {
1710     uint256 j;
1711     uint256 end;
1712     if(_end >= totalSupply()) {end = totalSupply() - 1;}
1713     else {end = _end;}
1714     
1715     uint256[] memory tokenIds = new uint256[](end - _start + 1);
1716 
1717     for (uint256 i = 0; i <= end - _start ; i++) {
1718      
1719       if(tokenByIndex(_start + i) >= 0 && tokenByIndex(_start + i) < maxSupply ){
1720         j++;  
1721         tokenIds[i] = tokenByIndex(_start + i);
1722       }         
1723   }
1724     return tokenIds;   
1725   }
1726    
1727 }