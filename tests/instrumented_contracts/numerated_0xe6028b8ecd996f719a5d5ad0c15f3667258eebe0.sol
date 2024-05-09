1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-26
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
1225 contract Krisalis is ERC721Enumerable, Ownable {
1226   using Strings for uint256;
1227 
1228   string baseURI;
1229   string baseExtension = ".json";
1230   string notRevealedUri;
1231   uint256 public cost = 0.06 ether;
1232   uint256 public maxSupply = 8000;
1233   uint256 public maxMintAmount = 10;
1234   uint256 public nftPerAddressLimit = 10;
1235   bool public paused = false;
1236   bool public revealed = false;
1237   bool public onlyWhitelisted = true;
1238   address payable commissions = payable(0x4f43181A37A694308E6D55CB5E03fA8a12093814);
1239   address[] public whitelistedAddresses;
1240   mapping(address => uint256) public addressMintedBalance;
1241 
1242   constructor(
1243     string memory _name,
1244     string memory _symbol,
1245     string memory _initBaseURI,
1246     string memory _initNotRevealedUri
1247   ) ERC721(_name, _symbol) {
1248     setBaseURI(_initBaseURI);
1249     setNotRevealedURI(_initNotRevealedUri);
1250   }
1251 
1252   // internal
1253   function _baseURI() internal view virtual override returns (string memory) {
1254     return baseURI;
1255   }
1256 
1257   // public
1258   function mint(uint256 _mintAmount) public payable {
1259     require(!paused, "the contract is paused");
1260     uint256 supply = totalSupply();
1261     require(_mintAmount > 0, "need to mint at least 1 NFT");
1262     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1263     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1264 
1265     if (msg.sender != owner()) {
1266         if(onlyWhitelisted == true) {
1267             require(isWhitelisted(msg.sender), "user is not whitelisted");
1268             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1269             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1270         }
1271         require(msg.value >= cost * _mintAmount, "insufficient funds");
1272     }
1273 
1274     for (uint256 i = 1; i <= _mintAmount; i++) {
1275       addressMintedBalance[msg.sender]++;
1276       _safeMint(msg.sender, supply + i);
1277     }
1278    
1279     (bool success, ) = payable(commissions).call{value: msg.value * 5 / 100}("");
1280     require(success);
1281   }
1282  
1283   function isWhitelisted(address _user) public view returns (bool) {
1284     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1285       if (whitelistedAddresses[i] == _user) {
1286           return true;
1287       }
1288     }
1289     return false;
1290   }
1291 
1292   function walletOfOwner(address _owner)
1293     public
1294     view
1295     returns (uint256[] memory)
1296   {
1297     uint256 ownerTokenCount = balanceOf(_owner);
1298     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1299     for (uint256 i; i < ownerTokenCount; i++) {
1300       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1301     }
1302     return tokenIds;
1303   }
1304 
1305   function tokenURI(uint256 tokenId)
1306     public
1307     view
1308     virtual
1309     override
1310     returns (string memory)
1311   {
1312     require(
1313       _exists(tokenId),
1314       "ERC721Metadata: URI query for nonexistent token"
1315     );
1316    
1317     if(revealed == false) {
1318         return notRevealedUri;
1319     }
1320 
1321     string memory currentBaseURI = _baseURI();
1322     return bytes(currentBaseURI).length > 0
1323         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1324         : "";
1325   }
1326 
1327   //only owner
1328   function reveal() public onlyOwner() {
1329       revealed = true;
1330   }
1331  
1332   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1333     nftPerAddressLimit = _limit;
1334   }
1335  
1336   function setCost(uint256 _newCost) public onlyOwner() {
1337     cost = _newCost;
1338   }
1339 
1340   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1341     maxMintAmount = _newmaxMintAmount;
1342   }
1343 
1344   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1345     baseURI = _newBaseURI;
1346   }
1347 
1348   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1349     baseExtension = _newBaseExtension;
1350   }
1351  
1352   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1353     notRevealedUri = _notRevealedURI;
1354   }
1355 
1356   function pause(bool _state) public onlyOwner {
1357     paused = _state;
1358   }
1359  
1360   function setOnlyWhitelisted(bool _state) public onlyOwner {
1361     onlyWhitelisted = _state;
1362   }
1363  
1364   function whitelistUsers(address[] calldata _users) public onlyOwner {
1365     delete whitelistedAddresses;
1366     whitelistedAddresses = _users;
1367   }
1368  
1369   function withdraw() public payable onlyOwner {
1370     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1371     require(success);
1372   }
1373 }