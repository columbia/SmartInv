1 /**
2  *Submitted for verification at BscScan.com on 2022-04-09
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 
7 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
8 pragma solidity ^0.8.0;
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 pragma solidity ^0.8.0;
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
171 pragma solidity ^0.8.0;
172 /**
173  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
174  * @dev See https://eips.ethereum.org/EIPS/eip-721
175  */
176 interface IERC721Enumerable is IERC721 {
177     /**
178      * @dev Returns the total amount of tokens stored by the contract.
179      */
180     function totalSupply() external view returns (uint256);
181 
182     /**
183      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
184      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
185      */
186     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
187 
188     /**
189      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
190      * Use along with {totalSupply} to enumerate all tokens.
191      */
192     function tokenByIndex(uint256 index) external view returns (uint256);
193 }
194 
195 
196 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
197 pragma solidity ^0.8.0;
198 /**
199  * @dev Implementation of the {IERC165} interface.
200  *
201  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
202  * for the additional interface id that will be supported. For example:
203  *
204  * ```solidity
205  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
206  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
207  * }
208  * ```
209  *
210  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
211  */
212 abstract contract ERC165 is IERC165 {
213     /**
214      * @dev See {IERC165-supportsInterface}.
215      */
216     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217         return interfaceId == type(IERC165).interfaceId;
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Strings.sol
222 
223 
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
235      */
236     function toString(uint256 value) internal pure returns (string memory) {
237         // Inspired by OraclizeAPI's implementation - MIT licence
238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
239 
240         if (value == 0) {
241             return "0";
242         }
243         uint256 temp = value;
244         uint256 digits;
245         while (temp != 0) {
246             digits++;
247             temp /= 10;
248         }
249         bytes memory buffer = new bytes(digits);
250         while (value != 0) {
251             digits -= 1;
252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
253             value /= 10;
254         }
255         return string(buffer);
256     }
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
260      */
261     function toHexString(uint256 value) internal pure returns (string memory) {
262         if (value == 0) {
263             return "0x00";
264         }
265         uint256 temp = value;
266         uint256 length = 0;
267         while (temp != 0) {
268             length++;
269             temp >>= 8;
270         }
271         return toHexString(value, length);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
276      */
277     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
278         bytes memory buffer = new bytes(2 * length + 2);
279         buffer[0] = "0";
280         buffer[1] = "x";
281         for (uint256 i = 2 * length + 1; i > 1; --i) {
282             buffer[i] = _HEX_SYMBOLS[value & 0xf];
283             value >>= 4;
284         }
285         require(value == 0, "Strings: hex length insufficient");
286         return string(buffer);
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Address.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         assembly {
324             size := extcodesize(account)
325         }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{value: amount}("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain `call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.call{value: value}(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
518  * @dev See https://eips.ethereum.org/EIPS/eip-721
519  */
520 interface IERC721Metadata is IERC721 {
521     /**
522      * @dev Returns the token collection name.
523      */
524     function name() external view returns (string memory);
525 
526     /**
527      * @dev Returns the token collection symbol.
528      */
529     function symbol() external view returns (string memory);
530 
531     /**
532      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
533      */
534     function tokenURI(uint256 tokenId) external view returns (string memory);
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
538 
539 
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @title ERC721 token receiver interface
545  * @dev Interface for any contract that wants to support safeTransfers
546  * from ERC721 asset contracts.
547  */
548 interface IERC721Receiver {
549     /**
550      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
551      * by `operator` from `from`, this function is called.
552      *
553      * It must return its Solidity selector to confirm the token transfer.
554      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
555      *
556      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
557      */
558     function onERC721Received(
559         address operator,
560         address from,
561         uint256 tokenId,
562         bytes calldata data
563     ) external returns (bytes4);
564 }
565 
566 // File: @openzeppelin/contracts/utils/Context.sol
567 pragma solidity ^0.8.0;
568 /**
569  * @dev Provides information about the current execution context, including the
570  * sender of the transaction and its data. While these are generally available
571  * via msg.sender and msg.data, they should not be accessed in such a direct
572  * manner, since when dealing with meta-transactions the account sending and
573  * paying for execution may not be the actual sender (as far as an application
574  * is concerned).
575  *
576  * This contract is only required for intermediate, library-like contracts.
577  */
578 abstract contract Context {
579     function _msgSender() internal view virtual returns (address) {
580         return msg.sender;
581     }
582 
583     function _msgData() internal view virtual returns (bytes calldata) {
584         return msg.data;
585     }
586 }
587 
588 
589 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
590 pragma solidity ^0.8.0;
591 /**
592  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
593  * the Metadata extension, but not including the Enumerable extension, which is available separately as
594  * {ERC721Enumerable}.
595  */
596 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
597     using Address for address;
598     using Strings for uint256;
599 
600     // Token name
601     string private _name;
602 
603     // Token symbol
604     string private _symbol;
605 
606     // Mapping from token ID to owner address
607     mapping(uint256 => address) private _owners;
608 
609     // Mapping owner address to token count
610     mapping(address => uint256) private _balances;
611 
612     // Mapping from token ID to approved address
613     mapping(uint256 => address) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     /**
619      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
620      */
621     constructor(string memory name_, string memory symbol_) {
622         _name = name_;
623         _symbol = symbol_;
624     }
625 
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
630         return
631             interfaceId == type(IERC721).interfaceId ||
632             interfaceId == type(IERC721Metadata).interfaceId ||
633             super.supportsInterface(interfaceId);
634     }
635 
636     /**
637      * @dev See {IERC721-balanceOf}.
638      */
639     function balanceOf(address owner) public view virtual override returns (uint256) {
640         require(owner != address(0), "ERC721: balance query for the zero address");
641         return _balances[owner];
642     }
643 
644     /**
645      * @dev See {IERC721-ownerOf}.
646      */
647     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
648         address owner = _owners[tokenId];
649         require(owner != address(0), "ERC721: owner query for nonexistent token");
650         return owner;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-name}.
655      */
656     function name() public view virtual override returns (string memory) {
657         return _name;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-symbol}.
662      */
663     function symbol() public view virtual override returns (string memory) {
664         return _symbol;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-tokenURI}.
669      */
670     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
671         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
672 
673         string memory baseURI = _baseURI();
674         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
675     }
676 
677     /**
678      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
679      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
680      * by default, can be overriden in child contracts.
681      */
682     function _baseURI() internal view virtual returns (string memory) {
683         return "";
684     }
685 
686     /**
687      * @dev See {IERC721-approve}.
688      */
689     function approve(address to, uint256 tokenId) public virtual override {
690         address owner = ERC721.ownerOf(tokenId);
691         require(to != owner, "ERC721: approval to current owner");
692 
693         require(
694             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
695             "ERC721: approve caller is not owner nor approved for all"
696         );
697 
698         _approve(to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-getApproved}.
703      */
704     function getApproved(uint256 tokenId) public view virtual override returns (address) {
705         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
706 
707         return _tokenApprovals[tokenId];
708     }
709 
710     /**
711      * @dev See {IERC721-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved) public virtual override {
714         require(operator != _msgSender(), "ERC721: approve to caller");
715 
716         _operatorApprovals[_msgSender()][operator] = approved;
717         emit ApprovalForAll(_msgSender(), operator, approved);
718     }
719 
720     /**
721      * @dev See {IERC721-isApprovedForAll}.
722      */
723     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
724         return _operatorApprovals[owner][operator];
725     }
726 
727     /**
728      * @dev See {IERC721-transferFrom}.
729      */
730     function transferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         //solhint-disable-next-line max-line-length
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737 
738         _transfer(from, to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) public virtual override {
749         safeTransferFrom(from, to, tokenId, "");
750     }
751 
752     /**
753      * @dev See {IERC721-safeTransferFrom}.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) public virtual override {
761         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
762         _safeTransfer(from, to, tokenId, _data);
763     }
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
767      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
768      *
769      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
770      *
771      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
772      * implement alternative mechanisms to perform token transfer, such as signature-based.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must exist and be owned by `from`.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _safeTransfer(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) internal virtual {
789         _transfer(from, to, tokenId);
790         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted (`_mint`),
799      * and stop existing when they are burned (`_burn`).
800      */
801     function _exists(uint256 tokenId) internal view virtual returns (bool) {
802         return _owners[tokenId] != address(0);
803     }
804 
805     /**
806      * @dev Returns whether `spender` is allowed to manage `tokenId`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      */
812     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
813         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
814         address owner = ERC721.ownerOf(tokenId);
815         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
816     }
817 
818     /**
819      * @dev Safely mints `tokenId` and transfers it to `to`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must not exist.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeMint(address to, uint256 tokenId) internal virtual {
829         _safeMint(to, tokenId, "");
830     }
831 
832     /**
833      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
834      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
835      */
836     function _safeMint(
837         address to,
838         uint256 tokenId,
839         bytes memory _data
840     ) internal virtual {
841         _mint(to, tokenId);
842         require(
843             _checkOnERC721Received(address(0), to, tokenId, _data),
844             "ERC721: transfer to non ERC721Receiver implementer"
845         );
846     }
847 
848     /**
849      * @dev Mints `tokenId` and transfers it to `to`.
850      *
851      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - `to` cannot be the zero address.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _mint(address to, uint256 tokenId) internal virtual {
861         require(to != address(0), "ERC721: mint to the zero address");
862         require(!_exists(tokenId), "ERC721: token already minted");
863 
864         _beforeTokenTransfer(address(0), to, tokenId);
865 
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(address(0), to, tokenId);
870     }
871 
872     /**
873      * @dev Destroys `tokenId`.
874      * The approval is cleared when the token is burned.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _burn(uint256 tokenId) internal virtual {
883         address owner = ERC721.ownerOf(tokenId);
884 
885         _beforeTokenTransfer(owner, address(0), tokenId);
886 
887         // Clear approvals
888         _approve(address(0), tokenId);
889 
890         _balances[owner] -= 1;
891         delete _owners[tokenId];
892 
893         emit Transfer(owner, address(0), tokenId);
894     }
895 
896     /**
897      * @dev Transfers `tokenId` from `from` to `to`.
898      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _transfer(
908         address from,
909         address to,
910         uint256 tokenId
911     ) internal virtual {
912         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
913         require(to != address(0), "ERC721: transfer to the zero address");
914 
915         _beforeTokenTransfer(from, to, tokenId);
916 
917         // Clear approvals from the previous owner
918         _approve(address(0), tokenId);
919 
920         _balances[from] -= 1;
921         _balances[to] += 1;
922         _owners[tokenId] = to;
923 
924         emit Transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev Approve `to` to operate on `tokenId`
929      *
930      * Emits a {Approval} event.
931      */
932     function _approve(address to, uint256 tokenId) internal virtual {
933         _tokenApprovals[tokenId] = to;
934         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
935     }
936 
937     /**
938      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
939      * The call is not executed if the target address is not a contract.
940      *
941      * @param from address representing the previous owner of the given token ID
942      * @param to target address that will receive the tokens
943      * @param tokenId uint256 ID of the token to be transferred
944      * @param _data bytes optional data to send along with the call
945      * @return bool whether the call correctly returned the expected magic value
946      */
947     function _checkOnERC721Received(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) private returns (bool) {
953         if (to.isContract()) {
954             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
955                 return retval == IERC721Receiver.onERC721Received.selector;
956             } catch (bytes memory reason) {
957                 if (reason.length == 0) {
958                     revert("ERC721: transfer to non ERC721Receiver implementer");
959                 } else {
960                     assembly {
961                         revert(add(32, reason), mload(reason))
962                     }
963                 }
964             }
965         } else {
966             return true;
967         }
968     }
969 
970     /**
971      * @dev Hook that is called before any token transfer. This includes minting
972      * and burning.
973      *
974      * Calling conditions:
975      *
976      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
977      * transferred to `to`.
978      * - When `from` is zero, `tokenId` will be minted for `to`.
979      * - When `to` is zero, ``from``'s `tokenId` will be burned.
980      * - `from` and `to` are never both zero.
981      *
982      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
983      */
984     function _beforeTokenTransfer(
985         address from,
986         address to,
987         uint256 tokenId
988     ) internal virtual {}
989 }
990 
991 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
992 
993 
994 
995 pragma solidity ^0.8.0;
996 
997 
998 
999 /**
1000  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1001  * enumerability of all the token ids in the contract as well as all token ids owned by each
1002  * account.
1003  */
1004 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1005     // Mapping from owner to list of owned token IDs
1006     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1007 
1008     // Mapping from token ID to index of the owner tokens list
1009     mapping(uint256 => uint256) private _ownedTokensIndex;
1010 
1011     // Array with all token ids, used for enumeration
1012     uint256[] private _allTokens;
1013 
1014     // Mapping from token id to position in the allTokens array
1015     mapping(uint256 => uint256) private _allTokensIndex;
1016 
1017     /**
1018      * @dev See {IERC165-supportsInterface}.
1019      */
1020     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1021         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1026      */
1027     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1028         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1029         return _ownedTokens[owner][index];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-totalSupply}.
1034      */
1035     function totalSupply() public view virtual override returns (uint256) {
1036         return _allTokens.length;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-tokenByIndex}.
1041      */
1042     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1043         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1044         return _allTokens[index];
1045     }
1046 
1047     /**
1048      * @dev Hook that is called before any token transfer. This includes minting
1049      * and burning.
1050      *
1051      * Calling conditions:
1052      *
1053      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1054      * transferred to `to`.
1055      * - When `from` is zero, `tokenId` will be minted for `to`.
1056      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1057      * - `from` cannot be the zero address.
1058      * - `to` cannot be the zero address.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _beforeTokenTransfer(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) internal virtual override {
1067         super._beforeTokenTransfer(from, to, tokenId);
1068 
1069         if (from == address(0)) {
1070             _addTokenToAllTokensEnumeration(tokenId);
1071         } else if (from != to) {
1072             _removeTokenFromOwnerEnumeration(from, tokenId);
1073         }
1074         if (to == address(0)) {
1075             _removeTokenFromAllTokensEnumeration(tokenId);
1076         } else if (to != from) {
1077             _addTokenToOwnerEnumeration(to, tokenId);
1078         }
1079     }
1080 
1081     /**
1082      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1083      * @param to address representing the new owner of the given token ID
1084      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1085      */
1086     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1087         uint256 length = ERC721.balanceOf(to);
1088         _ownedTokens[to][length] = tokenId;
1089         _ownedTokensIndex[tokenId] = length;
1090     }
1091 
1092     /**
1093      * @dev Private function to add a token to this extension's token tracking data structures.
1094      * @param tokenId uint256 ID of the token to be added to the tokens list
1095      */
1096     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1097         _allTokensIndex[tokenId] = _allTokens.length;
1098         _allTokens.push(tokenId);
1099     }
1100 
1101     /**
1102      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1103      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1104      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1105      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1106      * @param from address representing the previous owner of the given token ID
1107      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1108      */
1109     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1110         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1111         // then delete the last slot (swap and pop).
1112 
1113         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1114         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1115 
1116         // When the token to delete is the last token, the swap operation is unnecessary
1117         if (tokenIndex != lastTokenIndex) {
1118             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1119 
1120             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1121             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1122         }
1123 
1124         // This also deletes the contents at the last position of the array
1125         delete _ownedTokensIndex[tokenId];
1126         delete _ownedTokens[from][lastTokenIndex];
1127     }
1128 
1129     /**
1130      * @dev Private function to remove a token from this extension's token tracking data structures.
1131      * This has O(1) time complexity, but alters the order of the _allTokens array.
1132      * @param tokenId uint256 ID of the token to be removed from the tokens list
1133      */
1134     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1135         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1136         // then delete the last slot (swap and pop).
1137 
1138         uint256 lastTokenIndex = _allTokens.length - 1;
1139         uint256 tokenIndex = _allTokensIndex[tokenId];
1140 
1141         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1142         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1143         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1144         uint256 lastTokenId = _allTokens[lastTokenIndex];
1145 
1146         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1147         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1148 
1149         // This also deletes the contents at the last position of the array
1150         delete _allTokensIndex[tokenId];
1151         _allTokens.pop();
1152     }
1153 }
1154 
1155 
1156 // File: @openzeppelin/contracts/access/Ownable.sol
1157 pragma solidity ^0.8.0;
1158 /**
1159  * @dev Contract module which provides a basic access control mechanism, where
1160  * there is an account (an owner) that can be granted exclusive access to
1161  * specific functions.
1162  *
1163  * By default, the owner account will be the one that deploys the contract. This
1164  * can later be changed with {transferOwnership}.
1165  *
1166  * This module is used through inheritance. It will make available the modifier
1167  * `onlyOwner`, which can be applied to your functions to restrict their use to
1168  * the owner.
1169  */
1170 abstract contract Ownable is Context {
1171     address private _owner;
1172 
1173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1174 
1175     /**
1176      * @dev Initializes the contract setting the deployer as the initial owner.
1177      */
1178     constructor() {
1179         _setOwner(_msgSender());
1180     }
1181 
1182     /**
1183      * @dev Returns the address of the current owner.
1184      */
1185     function owner() public view virtual returns (address) {
1186         return _owner;
1187     }
1188 
1189     /**
1190      * @dev Throws if called by any account other than the owner.
1191      */
1192     modifier onlyOwner() {
1193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1194         _;
1195     }
1196 
1197     /**
1198      * @dev Leaves the contract without owner. It will not be possible to call
1199      * `onlyOwner` functions anymore. Can only be called by the current owner.
1200      *
1201      * NOTE: Renouncing ownership will leave the contract without an owner,
1202      * thereby removing any functionality that is only available to the owner.
1203      */
1204     function renounceOwnership() public virtual onlyOwner {
1205         _setOwner(address(0));
1206     }
1207 
1208     /**
1209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1210      * Can only be called by the current owner.
1211      */
1212     function transferOwnership(address newOwner) public virtual onlyOwner {
1213         require(newOwner != address(0), "Ownable: new owner is the zero address");
1214         _setOwner(newOwner);
1215     }
1216 
1217     function _setOwner(address newOwner) private {
1218         address oldOwner = _owner;
1219         _owner = newOwner;
1220         emit OwnershipTransferred(oldOwner, newOwner);
1221     }
1222 }
1223 
1224 
1225 
1226 pragma solidity >=0.7.0 <0.9.0;
1227 
1228 contract Ogrez is ERC721Enumerable, Ownable {
1229   using Strings for uint256;
1230 
1231   string public baseURI;
1232   string public baseExtension = ".json";
1233   string public notRevealedUri;
1234   uint256 public cost = 0 ether;
1235   uint256 public maxSupply = 10000;
1236   uint256 public maxMintAmount = 25;
1237   uint256 public nftPerAddressLimit = 100;
1238   bool public paused = false;
1239   bool public revealed = false;
1240   bool public onlyWhitelisted = false;
1241   address[] public whitelistedAddresses;
1242   mapping(address => uint256) public addressMintedBalance;
1243 
1244   constructor(
1245     string memory _name,
1246     string memory _symbol,
1247     string memory _initBaseURI,
1248     string memory _initNotRevealedUri
1249   ) ERC721(_name, _symbol) {
1250     setBaseURI(_initBaseURI);
1251     setNotRevealedURI(_initNotRevealedUri);
1252   }
1253 
1254   // internal
1255   function _baseURI() internal view virtual override returns (string memory) {
1256     return baseURI;
1257   }
1258 
1259   // public
1260   function mint(uint256 _mintAmount) public payable {
1261     require(!paused, "the contract is paused");
1262     uint256 supply = totalSupply();
1263     require(_mintAmount > 0, "need to mint at least 1 NFT");
1264     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1265     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1266 
1267     if (msg.sender != owner()) {
1268         if(onlyWhitelisted == true) {
1269             require(isWhitelisted(msg.sender), "user is not whitelisted");
1270             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1271             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1272         }
1273         require(msg.value >= cost * _mintAmount, "insufficient funds");
1274     }
1275 
1276     for (uint256 i = 1; i <= _mintAmount; i++) {
1277       addressMintedBalance[msg.sender]++;
1278       _safeMint(msg.sender, supply + i);
1279     }
1280   }
1281   
1282   function isWhitelisted(address _user) public view returns (bool) {
1283     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1284       if (whitelistedAddresses[i] == _user) {
1285           return true;
1286       }
1287     }
1288     return false;
1289   }
1290 
1291   function walletOfOwner(address _owner)
1292     public
1293     view
1294     returns (uint256[] memory)
1295   {
1296     uint256 ownerTokenCount = balanceOf(_owner);
1297     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1298     for (uint256 i; i < ownerTokenCount; i++) {
1299       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1300     }
1301     return tokenIds;
1302   }
1303 
1304   function tokenURI(uint256 tokenId)
1305     public
1306     view
1307     virtual
1308     override
1309     returns (string memory)
1310   {
1311     require(
1312       _exists(tokenId),
1313       "ERC721Metadata: URI query for nonexistent token"
1314     );
1315     
1316     if(revealed == false) {
1317         return notRevealedUri;
1318     }
1319 
1320     string memory currentBaseURI = _baseURI();
1321     return bytes(currentBaseURI).length > 0
1322         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1323         : "";
1324   }
1325 
1326   //only owner
1327   function reveal() public onlyOwner {
1328       revealed = true;
1329   }
1330   
1331   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1332     nftPerAddressLimit = _limit;
1333   }
1334   
1335   function setCost(uint256 _newCost) public onlyOwner {
1336     cost = _newCost;
1337   }
1338 
1339   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1340     maxMintAmount = _newmaxMintAmount;
1341   }
1342 
1343   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1344     baseURI = _newBaseURI;
1345   }
1346 
1347   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1348     baseExtension = _newBaseExtension;
1349   }
1350   
1351   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1352     notRevealedUri = _notRevealedURI;
1353   }
1354 
1355   function pause(bool _state) public onlyOwner {
1356     paused = _state;
1357   }
1358   
1359   function setOnlyWhitelisted(bool _state) public onlyOwner {
1360     onlyWhitelisted = _state;
1361   }
1362   
1363   function whitelistUsers(address[] calldata _users) public onlyOwner {
1364     delete whitelistedAddresses;
1365     whitelistedAddresses = _users;
1366   }
1367  
1368   function withdraw() public payable onlyOwner {
1369     
1370        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1371     require(os);
1372    
1373   }
1374 }