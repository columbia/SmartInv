1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.0
33 
34 
35 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.0
178 
179 
180 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.0
209 
210 
211 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.4.0
238 
239 
240 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize, which returns 0 for contracts in
267         // construction, since the code is only stored at the end of the
268         // constructor execution.
269 
270         uint256 size;
271         assembly {
272             size := extcodesize(account)
273         }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 
458 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
459 
460 
461 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.0
487 
488 
489 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev String operations.
495  */
496 library Strings {
497     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
501      */
502     function toString(uint256 value) internal pure returns (string memory) {
503         // Inspired by OraclizeAPI's implementation - MIT licence
504         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
505 
506         if (value == 0) {
507             return "0";
508         }
509         uint256 temp = value;
510         uint256 digits;
511         while (temp != 0) {
512             digits++;
513             temp /= 10;
514         }
515         bytes memory buffer = new bytes(digits);
516         while (value != 0) {
517             digits -= 1;
518             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
519             value /= 10;
520         }
521         return string(buffer);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
526      */
527     function toHexString(uint256 value) internal pure returns (string memory) {
528         if (value == 0) {
529             return "0x00";
530         }
531         uint256 temp = value;
532         uint256 length = 0;
533         while (temp != 0) {
534             length++;
535             temp >>= 8;
536         }
537         return toHexString(value, length);
538     }
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
542      */
543     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
544         bytes memory buffer = new bytes(2 * length + 2);
545         buffer[0] = "0";
546         buffer[1] = "x";
547         for (uint256 i = 2 * length + 1; i > 1; --i) {
548             buffer[i] = _HEX_SYMBOLS[value & 0xf];
549             value >>= 4;
550         }
551         require(value == 0, "Strings: hex length insufficient");
552         return string(buffer);
553     }
554 }
555 
556 
557 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.0
558 
559 
560 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165).interfaceId;
584     }
585 }
586 
587 
588 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.0
589 
590 
591 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 
597 
598 
599 
600 
601 /**
602  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
603  * the Metadata extension, but not including the Enumerable extension, which is available separately as
604  * {ERC721Enumerable}.
605  */
606 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
607     using Address for address;
608     using Strings for uint256;
609 
610     // Token name
611     string private _name;
612 
613     // Token symbol
614     string private _symbol;
615 
616     // Mapping from token ID to owner address
617     mapping(uint256 => address) private _owners;
618 
619     // Mapping owner address to token count
620     mapping(address => uint256) private _balances;
621 
622     // Mapping from token ID to approved address
623     mapping(uint256 => address) private _tokenApprovals;
624 
625     // Mapping from owner to operator approvals
626     mapping(address => mapping(address => bool)) private _operatorApprovals;
627 
628     /**
629      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
630      */
631     constructor(string memory name_, string memory symbol_) {
632         _name = name_;
633         _symbol = symbol_;
634     }
635 
636     /**
637      * @dev See {IERC165-supportsInterface}.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
640         return
641             interfaceId == type(IERC721).interfaceId ||
642             interfaceId == type(IERC721Metadata).interfaceId ||
643             super.supportsInterface(interfaceId);
644     }
645 
646     /**
647      * @dev See {IERC721-balanceOf}.
648      */
649     function balanceOf(address owner) public view virtual override returns (uint256) {
650         require(owner != address(0), "ERC721: balance query for the zero address");
651         return _balances[owner];
652     }
653 
654     /**
655      * @dev See {IERC721-ownerOf}.
656      */
657     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
658         address owner = _owners[tokenId];
659         require(owner != address(0), "ERC721: owner query for nonexistent token");
660         return owner;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-name}.
665      */
666     function name() public view virtual override returns (string memory) {
667         return _name;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-symbol}.
672      */
673     function symbol() public view virtual override returns (string memory) {
674         return _symbol;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-tokenURI}.
679      */
680     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
681         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
682 
683         string memory baseURI = _baseURI();
684         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
685     }
686 
687     /**
688      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
689      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
690      * by default, can be overriden in child contracts.
691      */
692     function _baseURI() internal view virtual returns (string memory) {
693         return "";
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public virtual override {
700         address owner = ERC721.ownerOf(tokenId);
701         require(to != owner, "ERC721: approval to current owner");
702 
703         require(
704             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
705             "ERC721: approve caller is not owner nor approved for all"
706         );
707 
708         _approve(to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId) public view virtual override returns (address) {
715         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
716 
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         _setApprovalForAll(_msgSender(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC721-isApprovedForAll}.
729      */
730     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
731         return _operatorApprovals[owner][operator];
732     }
733 
734     /**
735      * @dev See {IERC721-transferFrom}.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         //solhint-disable-next-line max-line-length
743         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
744 
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, "");
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public virtual override {
768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
769         _safeTransfer(from, to, tokenId, _data);
770     }
771 
772     /**
773      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
774      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
775      *
776      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
777      *
778      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
779      * implement alternative mechanisms to perform token transfer, such as signature-based.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must exist and be owned by `from`.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _safeTransfer(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) internal virtual {
796         _transfer(from, to, tokenId);
797         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
798     }
799 
800     /**
801      * @dev Returns whether `tokenId` exists.
802      *
803      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
804      *
805      * Tokens start existing when they are minted (`_mint`),
806      * and stop existing when they are burned (`_burn`).
807      */
808     function _exists(uint256 tokenId) internal view virtual returns (bool) {
809         return _owners[tokenId] != address(0);
810     }
811 
812     /**
813      * @dev Returns whether `spender` is allowed to manage `tokenId`.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
820         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
821         address owner = ERC721.ownerOf(tokenId);
822         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
823     }
824 
825     /**
826      * @dev Safely mints `tokenId` and transfers it to `to`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeMint(address to, uint256 tokenId) internal virtual {
836         _safeMint(to, tokenId, "");
837     }
838 
839     /**
840      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
841      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
842      */
843     function _safeMint(
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) internal virtual {
848         _mint(to, tokenId);
849         require(
850             _checkOnERC721Received(address(0), to, tokenId, _data),
851             "ERC721: transfer to non ERC721Receiver implementer"
852         );
853     }
854 
855     /**
856      * @dev Mints `tokenId` and transfers it to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
859      *
860      * Requirements:
861      *
862      * - `tokenId` must not exist.
863      * - `to` cannot be the zero address.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _mint(address to, uint256 tokenId) internal virtual {
868         require(to != address(0), "ERC721: mint to the zero address");
869         require(!_exists(tokenId), "ERC721: token already minted");
870 
871         _beforeTokenTransfer(address(0), to, tokenId);
872 
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(address(0), to, tokenId);
877     }
878 
879     /**
880      * @dev Destroys `tokenId`.
881      * The approval is cleared when the token is burned.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _burn(uint256 tokenId) internal virtual {
890         address owner = ERC721.ownerOf(tokenId);
891 
892         _beforeTokenTransfer(owner, address(0), tokenId);
893 
894         // Clear approvals
895         _approve(address(0), tokenId);
896 
897         _balances[owner] -= 1;
898         delete _owners[tokenId];
899 
900         emit Transfer(owner, address(0), tokenId);
901     }
902 
903     /**
904      * @dev Transfers `tokenId` from `from` to `to`.
905      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
906      *
907      * Requirements:
908      *
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must be owned by `from`.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _transfer(
915         address from,
916         address to,
917         uint256 tokenId
918     ) internal virtual {
919         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
920         require(to != address(0), "ERC721: transfer to the zero address");
921 
922         _beforeTokenTransfer(from, to, tokenId);
923 
924         // Clear approvals from the previous owner
925         _approve(address(0), tokenId);
926 
927         _balances[from] -= 1;
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev Approve `to` to operate on `tokenId`
936      *
937      * Emits a {Approval} event.
938      */
939     function _approve(address to, uint256 tokenId) internal virtual {
940         _tokenApprovals[tokenId] = to;
941         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
942     }
943 
944     /**
945      * @dev Approve `operator` to operate on all of `owner` tokens
946      *
947      * Emits a {ApprovalForAll} event.
948      */
949     function _setApprovalForAll(
950         address owner,
951         address operator,
952         bool approved
953     ) internal virtual {
954         require(owner != operator, "ERC721: approve to caller");
955         _operatorApprovals[owner][operator] = approved;
956         emit ApprovalForAll(owner, operator, approved);
957     }
958 
959     /**
960      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
961      * The call is not executed if the target address is not a contract.
962      *
963      * @param from address representing the previous owner of the given token ID
964      * @param to target address that will receive the tokens
965      * @param tokenId uint256 ID of the token to be transferred
966      * @param _data bytes optional data to send along with the call
967      * @return bool whether the call correctly returned the expected magic value
968      */
969     function _checkOnERC721Received(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) private returns (bool) {
975         if (to.isContract()) {
976             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
977                 return retval == IERC721Receiver.onERC721Received.selector;
978             } catch (bytes memory reason) {
979                 if (reason.length == 0) {
980                     revert("ERC721: transfer to non ERC721Receiver implementer");
981                 } else {
982                     assembly {
983                         revert(add(32, reason), mload(reason))
984                     }
985                 }
986             }
987         } else {
988             return true;
989         }
990     }
991 
992     /**
993      * @dev Hook that is called before any token transfer. This includes minting
994      * and burning.
995      *
996      * Calling conditions:
997      *
998      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
999      * transferred to `to`.
1000      * - When `from` is zero, `tokenId` will be minted for `to`.
1001      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1002      * - `from` and `to` are never both zero.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {}
1011 }
1012 
1013 
1014 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.0
1015 
1016 
1017 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1023  * @dev See https://eips.ethereum.org/EIPS/eip-721
1024  */
1025 interface IERC721Enumerable is IERC721 {
1026     /**
1027      * @dev Returns the total amount of tokens stored by the contract.
1028      */
1029     function totalSupply() external view returns (uint256);
1030 
1031     /**
1032      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1033      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1034      */
1035     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1036 
1037     /**
1038      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1039      * Use along with {totalSupply} to enumerate all tokens.
1040      */
1041     function tokenByIndex(uint256 index) external view returns (uint256);
1042 }
1043 
1044 
1045 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.0
1046 
1047 
1048 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 
1053 /**
1054  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1055  * enumerability of all the token ids in the contract as well as all token ids owned by each
1056  * account.
1057  */
1058 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1059     // Mapping from owner to list of owned token IDs
1060     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1061 
1062     // Mapping from token ID to index of the owner tokens list
1063     mapping(uint256 => uint256) private _ownedTokensIndex;
1064 
1065     // Array with all token ids, used for enumeration
1066     uint256[] private _allTokens;
1067 
1068     // Mapping from token id to position in the allTokens array
1069     mapping(uint256 => uint256) private _allTokensIndex;
1070 
1071     /**
1072      * @dev See {IERC165-supportsInterface}.
1073      */
1074     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1075         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1080      */
1081     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1082         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1083         return _ownedTokens[owner][index];
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Enumerable-totalSupply}.
1088      */
1089     function totalSupply() public view virtual override returns (uint256) {
1090         return _allTokens.length;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Enumerable-tokenByIndex}.
1095      */
1096     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1097         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1098         return _allTokens[index];
1099     }
1100 
1101     /**
1102      * @dev Hook that is called before any token transfer. This includes minting
1103      * and burning.
1104      *
1105      * Calling conditions:
1106      *
1107      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1108      * transferred to `to`.
1109      * - When `from` is zero, `tokenId` will be minted for `to`.
1110      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      *
1114      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1115      */
1116     function _beforeTokenTransfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual override {
1121         super._beforeTokenTransfer(from, to, tokenId);
1122 
1123         if (from == address(0)) {
1124             _addTokenToAllTokensEnumeration(tokenId);
1125         } else if (from != to) {
1126             _removeTokenFromOwnerEnumeration(from, tokenId);
1127         }
1128         if (to == address(0)) {
1129             _removeTokenFromAllTokensEnumeration(tokenId);
1130         } else if (to != from) {
1131             _addTokenToOwnerEnumeration(to, tokenId);
1132         }
1133     }
1134 
1135     /**
1136      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1137      * @param to address representing the new owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1139      */
1140     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1141         uint256 length = ERC721.balanceOf(to);
1142         _ownedTokens[to][length] = tokenId;
1143         _ownedTokensIndex[tokenId] = length;
1144     }
1145 
1146     /**
1147      * @dev Private function to add a token to this extension's token tracking data structures.
1148      * @param tokenId uint256 ID of the token to be added to the tokens list
1149      */
1150     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1151         _allTokensIndex[tokenId] = _allTokens.length;
1152         _allTokens.push(tokenId);
1153     }
1154 
1155     /**
1156      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1157      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1158      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1159      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1160      * @param from address representing the previous owner of the given token ID
1161      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1162      */
1163     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1164         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1165         // then delete the last slot (swap and pop).
1166 
1167         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1168         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1169 
1170         // When the token to delete is the last token, the swap operation is unnecessary
1171         if (tokenIndex != lastTokenIndex) {
1172             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1173 
1174             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1175             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1176         }
1177 
1178         // This also deletes the contents at the last position of the array
1179         delete _ownedTokensIndex[tokenId];
1180         delete _ownedTokens[from][lastTokenIndex];
1181     }
1182 
1183     /**
1184      * @dev Private function to remove a token from this extension's token tracking data structures.
1185      * This has O(1) time complexity, but alters the order of the _allTokens array.
1186      * @param tokenId uint256 ID of the token to be removed from the tokens list
1187      */
1188     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1189         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1190         // then delete the last slot (swap and pop).
1191 
1192         uint256 lastTokenIndex = _allTokens.length - 1;
1193         uint256 tokenIndex = _allTokensIndex[tokenId];
1194 
1195         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1196         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1197         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1198         uint256 lastTokenId = _allTokens[lastTokenIndex];
1199 
1200         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1201         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1202 
1203         // This also deletes the contents at the last position of the array
1204         delete _allTokensIndex[tokenId];
1205         _allTokens.pop();
1206     }
1207 }
1208 
1209 
1210 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.0
1211 
1212 
1213 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 // CAUTION
1218 // This version of SafeMath should only be used with Solidity 0.8 or later,
1219 // because it relies on the compiler's built in overflow checks.
1220 
1221 /**
1222  * @dev Wrappers over Solidity's arithmetic operations.
1223  *
1224  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1225  * now has built in overflow checking.
1226  */
1227 library SafeMath {
1228     /**
1229      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1230      *
1231      * _Available since v3.4._
1232      */
1233     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1234         unchecked {
1235             uint256 c = a + b;
1236             if (c < a) return (false, 0);
1237             return (true, c);
1238         }
1239     }
1240 
1241     /**
1242      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1243      *
1244      * _Available since v3.4._
1245      */
1246     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1247         unchecked {
1248             if (b > a) return (false, 0);
1249             return (true, a - b);
1250         }
1251     }
1252 
1253     /**
1254      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1255      *
1256      * _Available since v3.4._
1257      */
1258     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1259         unchecked {
1260             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1261             // benefit is lost if 'b' is also tested.
1262             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1263             if (a == 0) return (true, 0);
1264             uint256 c = a * b;
1265             if (c / a != b) return (false, 0);
1266             return (true, c);
1267         }
1268     }
1269 
1270     /**
1271      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1272      *
1273      * _Available since v3.4._
1274      */
1275     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1276         unchecked {
1277             if (b == 0) return (false, 0);
1278             return (true, a / b);
1279         }
1280     }
1281 
1282     /**
1283      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1284      *
1285      * _Available since v3.4._
1286      */
1287     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1288         unchecked {
1289             if (b == 0) return (false, 0);
1290             return (true, a % b);
1291         }
1292     }
1293 
1294     /**
1295      * @dev Returns the addition of two unsigned integers, reverting on
1296      * overflow.
1297      *
1298      * Counterpart to Solidity's `+` operator.
1299      *
1300      * Requirements:
1301      *
1302      * - Addition cannot overflow.
1303      */
1304     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1305         return a + b;
1306     }
1307 
1308     /**
1309      * @dev Returns the subtraction of two unsigned integers, reverting on
1310      * overflow (when the result is negative).
1311      *
1312      * Counterpart to Solidity's `-` operator.
1313      *
1314      * Requirements:
1315      *
1316      * - Subtraction cannot overflow.
1317      */
1318     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1319         return a - b;
1320     }
1321 
1322     /**
1323      * @dev Returns the multiplication of two unsigned integers, reverting on
1324      * overflow.
1325      *
1326      * Counterpart to Solidity's `*` operator.
1327      *
1328      * Requirements:
1329      *
1330      * - Multiplication cannot overflow.
1331      */
1332     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1333         return a * b;
1334     }
1335 
1336     /**
1337      * @dev Returns the integer division of two unsigned integers, reverting on
1338      * division by zero. The result is rounded towards zero.
1339      *
1340      * Counterpart to Solidity's `/` operator.
1341      *
1342      * Requirements:
1343      *
1344      * - The divisor cannot be zero.
1345      */
1346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1347         return a / b;
1348     }
1349 
1350     /**
1351      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1352      * reverting when dividing by zero.
1353      *
1354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1355      * opcode (which leaves remaining gas untouched) while Solidity uses an
1356      * invalid opcode to revert (consuming all remaining gas).
1357      *
1358      * Requirements:
1359      *
1360      * - The divisor cannot be zero.
1361      */
1362     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1363         return a % b;
1364     }
1365 
1366     /**
1367      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1368      * overflow (when the result is negative).
1369      *
1370      * CAUTION: This function is deprecated because it requires allocating memory for the error
1371      * message unnecessarily. For custom revert reasons use {trySub}.
1372      *
1373      * Counterpart to Solidity's `-` operator.
1374      *
1375      * Requirements:
1376      *
1377      * - Subtraction cannot overflow.
1378      */
1379     function sub(
1380         uint256 a,
1381         uint256 b,
1382         string memory errorMessage
1383     ) internal pure returns (uint256) {
1384         unchecked {
1385             require(b <= a, errorMessage);
1386             return a - b;
1387         }
1388     }
1389 
1390     /**
1391      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1392      * division by zero. The result is rounded towards zero.
1393      *
1394      * Counterpart to Solidity's `/` operator. Note: this function uses a
1395      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1396      * uses an invalid opcode to revert (consuming all remaining gas).
1397      *
1398      * Requirements:
1399      *
1400      * - The divisor cannot be zero.
1401      */
1402     function div(
1403         uint256 a,
1404         uint256 b,
1405         string memory errorMessage
1406     ) internal pure returns (uint256) {
1407         unchecked {
1408             require(b > 0, errorMessage);
1409             return a / b;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1415      * reverting with custom message when dividing by zero.
1416      *
1417      * CAUTION: This function is deprecated because it requires allocating memory for the error
1418      * message unnecessarily. For custom revert reasons use {tryMod}.
1419      *
1420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1421      * opcode (which leaves remaining gas untouched) while Solidity uses an
1422      * invalid opcode to revert (consuming all remaining gas).
1423      *
1424      * Requirements:
1425      *
1426      * - The divisor cannot be zero.
1427      */
1428     function mod(
1429         uint256 a,
1430         uint256 b,
1431         string memory errorMessage
1432     ) internal pure returns (uint256) {
1433         unchecked {
1434             require(b > 0, errorMessage);
1435             return a % b;
1436         }
1437     }
1438 }
1439 
1440 
1441 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
1442 
1443 
1444 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1445 
1446 pragma solidity ^0.8.0;
1447 
1448 /**
1449  * @dev Contract module which provides a basic access control mechanism, where
1450  * there is an account (an owner) that can be granted exclusive access to
1451  * specific functions.
1452  *
1453  * By default, the owner account will be the one that deploys the contract. This
1454  * can later be changed with {transferOwnership}.
1455  *
1456  * This module is used through inheritance. It will make available the modifier
1457  * `onlyOwner`, which can be applied to your functions to restrict their use to
1458  * the owner.
1459  */
1460 abstract contract Ownable is Context {
1461     address private _owner;
1462 
1463     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1464 
1465     /**
1466      * @dev Initializes the contract setting the deployer as the initial owner.
1467      */
1468     constructor() {
1469         _transferOwnership(_msgSender());
1470     }
1471 
1472     /**
1473      * @dev Returns the address of the current owner.
1474      */
1475     function owner() public view virtual returns (address) {
1476         return _owner;
1477     }
1478 
1479     /**
1480      * @dev Throws if called by any account other than the owner.
1481      */
1482     modifier onlyOwner() {
1483         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1484         _;
1485     }
1486 
1487     /**
1488      * @dev Leaves the contract without owner. It will not be possible to call
1489      * `onlyOwner` functions anymore. Can only be called by the current owner.
1490      *
1491      * NOTE: Renouncing ownership will leave the contract without an owner,
1492      * thereby removing any functionality that is only available to the owner.
1493      */
1494     function renounceOwnership() public virtual onlyOwner {
1495         _transferOwnership(address(0));
1496     }
1497 
1498     /**
1499      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1500      * Can only be called by the current owner.
1501      */
1502     function transferOwnership(address newOwner) public virtual onlyOwner {
1503         require(newOwner != address(0), "Ownable: new owner is the zero address");
1504         _transferOwnership(newOwner);
1505     }
1506 
1507     /**
1508      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1509      * Internal function without access restriction.
1510      */
1511     function _transferOwnership(address newOwner) internal virtual {
1512         address oldOwner = _owner;
1513         _owner = newOwner;
1514         emit OwnershipTransferred(oldOwner, newOwner);
1515     }
1516 }
1517 
1518 
1519 // File @openzeppelin/contracts/security/Pausable.sol@v4.4.0
1520 
1521 
1522 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 /**
1527  * @dev Contract module which allows children to implement an emergency stop
1528  * mechanism that can be triggered by an authorized account.
1529  *
1530  * This module is used through inheritance. It will make available the
1531  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1532  * the functions of your contract. Note that they will not be pausable by
1533  * simply including this module, only once the modifiers are put in place.
1534  */
1535 abstract contract Pausable is Context {
1536     /**
1537      * @dev Emitted when the pause is triggered by `account`.
1538      */
1539     event Paused(address account);
1540 
1541     /**
1542      * @dev Emitted when the pause is lifted by `account`.
1543      */
1544     event Unpaused(address account);
1545 
1546     bool private _paused;
1547 
1548     /**
1549      * @dev Initializes the contract in unpaused state.
1550      */
1551     constructor() {
1552         _paused = false;
1553     }
1554 
1555     /**
1556      * @dev Returns true if the contract is paused, and false otherwise.
1557      */
1558     function paused() public view virtual returns (bool) {
1559         return _paused;
1560     }
1561 
1562     /**
1563      * @dev Modifier to make a function callable only when the contract is not paused.
1564      *
1565      * Requirements:
1566      *
1567      * - The contract must not be paused.
1568      */
1569     modifier whenNotPaused() {
1570         require(!paused(), "Pausable: paused");
1571         _;
1572     }
1573 
1574     /**
1575      * @dev Modifier to make a function callable only when the contract is paused.
1576      *
1577      * Requirements:
1578      *
1579      * - The contract must be paused.
1580      */
1581     modifier whenPaused() {
1582         require(paused(), "Pausable: not paused");
1583         _;
1584     }
1585 
1586     /**
1587      * @dev Triggers stopped state.
1588      *
1589      * Requirements:
1590      *
1591      * - The contract must not be paused.
1592      */
1593     function _pause() internal virtual whenNotPaused {
1594         _paused = true;
1595         emit Paused(_msgSender());
1596     }
1597 
1598     /**
1599      * @dev Returns to normal state.
1600      *
1601      * Requirements:
1602      *
1603      * - The contract must be paused.
1604      */
1605     function _unpause() internal virtual whenPaused {
1606         _paused = false;
1607         emit Unpaused(_msgSender());
1608     }
1609 }
1610 
1611 
1612 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.0
1613 
1614 
1615 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 /**
1620  * @dev Contract module that helps prevent reentrant calls to a function.
1621  *
1622  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1623  * available, which can be applied to functions to make sure there are no nested
1624  * (reentrant) calls to them.
1625  *
1626  * Note that because there is a single `nonReentrant` guard, functions marked as
1627  * `nonReentrant` may not call one another. This can be worked around by making
1628  * those functions `private`, and then adding `external` `nonReentrant` entry
1629  * points to them.
1630  *
1631  * TIP: If you would like to learn more about reentrancy and alternative ways
1632  * to protect against it, check out our blog post
1633  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1634  */
1635 abstract contract ReentrancyGuard {
1636     // Booleans are more expensive than uint256 or any type that takes up a full
1637     // word because each write operation emits an extra SLOAD to first read the
1638     // slot's contents, replace the bits taken up by the boolean, and then write
1639     // back. This is the compiler's defense against contract upgrades and
1640     // pointer aliasing, and it cannot be disabled.
1641 
1642     // The values being non-zero value makes deployment a bit more expensive,
1643     // but in exchange the refund on every call to nonReentrant will be lower in
1644     // amount. Since refunds are capped to a percentage of the total
1645     // transaction's gas, it is best to keep them low in cases like this one, to
1646     // increase the likelihood of the full refund coming into effect.
1647     uint256 private constant _NOT_ENTERED = 1;
1648     uint256 private constant _ENTERED = 2;
1649 
1650     uint256 private _status;
1651 
1652     constructor() {
1653         _status = _NOT_ENTERED;
1654     }
1655 
1656     /**
1657      * @dev Prevents a contract from calling itself, directly or indirectly.
1658      * Calling a `nonReentrant` function from another `nonReentrant`
1659      * function is not supported. It is possible to prevent this from happening
1660      * by making the `nonReentrant` function external, and making it call a
1661      * `private` function that does the actual work.
1662      */
1663     modifier nonReentrant() {
1664         // On the first call to nonReentrant, _notEntered will be true
1665         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1666 
1667         // Any calls to nonReentrant after this point will fail
1668         _status = _ENTERED;
1669 
1670         _;
1671 
1672         // By storing the original value once again, a refund is triggered (see
1673         // https://eips.ethereum.org/EIPS/eip-2200)
1674         _status = _NOT_ENTERED;
1675     }
1676 }
1677 
1678 
1679 // File contracts/NoBrainers.sol
1680 
1681 
1682 
1683 pragma solidity ^0.8.4;
1684 
1685 
1686 
1687 
1688 
1689 
1690 contract NoBrainers is ERC721Enumerable, ReentrancyGuard, Ownable, Pausable {
1691     using SafeMath for uint256;
1692     using Strings for uint256;
1693 
1694     uint256 public constant RESERVE_NFT = 200;
1695     uint256 public constant PUBLIC_NFT = 4900;
1696     uint256 public constant MAX_NFT = RESERVE_NFT + PUBLIC_NFT;
1697     uint256 public constant NFT_PRICE = 0.08 ether;
1698 
1699     uint256 public constant PRESALE_PURCHASE_LIMIT = 4;
1700     uint256 public constant MAINSALE_PURCHASE_LIMIT = 7;
1701 
1702     uint256 public publicTotalSupply;
1703 
1704     string public baseURI;
1705     string public blindURI;
1706     string public reserveURI;
1707 
1708     bool donate=true;
1709     bool checkWhitelist;
1710     bool public reveal;
1711     bool public isPreSaleActive;
1712     bool public isMainSaleActive;
1713 
1714     address public communityTreasury;
1715     address public charity;
1716 
1717     mapping(address => bool) presaleAccess;
1718 
1719     mapping(address => uint256) public presaleClaimed;
1720     mapping(address => uint256) public mainSaleClaimed;
1721     mapping(address => uint256[]) public giveaway;
1722 
1723     constructor(address _communityTreasury, address _charity) ERC721("No Brainers", "NBRN") {
1724         communityTreasury = _communityTreasury;
1725         charity = _charity;
1726     }
1727 
1728     // Function to start presale
1729     function changePreSaleStatus(bool _status) external onlyOwner {
1730         isPreSaleActive = _status;
1731     }
1732 
1733     // Function to start main sale
1734     function changeMainSaleStatus(bool _status) external onlyOwner {
1735         isMainSaleActive = _status;
1736     }
1737     
1738     // Function to reveal all NFTs
1739     function changeRevealStatus(bool _status) external onlyOwner {
1740         reveal = _status;
1741     }
1742 
1743     // Function to control whitelist flag
1744     function changeWhitelistFlag(bool _status) external onlyOwner {
1745         checkWhitelist = _status;
1746     }
1747 
1748     // Function to control donate flag
1749     function changeDonateFlag(bool _status) external onlyOwner {
1750         donate = _status;
1751     }
1752     
1753     // Function givePresaleAccess to give presale access to addresses
1754     function givePresaleAccess(address[] memory _addresses) external onlyOwner {
1755         for (uint256 i = 0; i < _addresses.length; i++) {
1756             presaleAccess[_addresses[i]] = true;
1757         }
1758     }
1759 
1760     // Function to set giveaway users (tokenIds should be below 200)
1761     function setGiveawayUsers(address[] memory _to, uint256[] memory _tokenIds) external onlyOwner {
1762         require(_to.length == _tokenIds.length, "array size mismatch");
1763         for(uint256 i = 0; i < _to.length; i++) {
1764             giveaway[_to[i]].push(_tokenIds[i]);
1765         }
1766     }
1767     
1768     // Function to set Base and Blind URI
1769     function setURIs(string memory _blindURI, string memory _URI, string memory _reserveURI) external onlyOwner {
1770         blindURI = _blindURI;
1771         baseURI = _URI;
1772         reserveURI = _reserveURI;
1773     }
1774 
1775     //Function to withdraw collected amount during minting by the owner
1776     function withdraw(address _to, uint256 _amount) external onlyOwner {
1777         uint256 balance = address(this).balance;
1778         require(balance >= _amount, "Balance should atleast equal to amount");
1779         payable(_to).transfer(_amount);
1780     }
1781 
1782     // Function to mint new NFTs during the presale
1783     function mintDuringPresale(uint256 _numOfTokens) public payable whenNotPaused nonReentrant {
1784         require(isPreSaleActive==true, "Presale Not Active");
1785         if(checkWhitelist==true) {
1786             require(presaleAccess[msg.sender] == true, "Presale Access Denied");
1787         }
1788         require(presaleClaimed[msg.sender].add(_numOfTokens) <= PRESALE_PURCHASE_LIMIT, 
1789             "Above Presale Purchase Limit");
1790         require(publicTotalSupply.add(_numOfTokens) <= PUBLIC_NFT, 'Purchase would exceed max NFTs');
1791         require(NFT_PRICE.mul(_numOfTokens) == msg.value, "Invalid Amount");
1792 
1793         if(donate==true) {
1794             checkDistribution(_numOfTokens);
1795         }
1796 
1797         for (uint256 i = 0; i < _numOfTokens; i++) {
1798             _safeMint(msg.sender, RESERVE_NFT.add(publicTotalSupply));
1799             publicTotalSupply = publicTotalSupply.add(1);
1800         }
1801         presaleClaimed[msg.sender] = presaleClaimed[msg.sender].add(_numOfTokens);
1802     }
1803 
1804     // Function to mint new NFTs during the public sale
1805     function mint(uint256 _numOfTokens) public payable whenNotPaused nonReentrant {
1806         require(isMainSaleActive==true, "Sale Not Active");
1807         require(mainSaleClaimed[msg.sender].add(_numOfTokens) <= MAINSALE_PURCHASE_LIMIT, 
1808             "Above Main Sale Purchase Limit");
1809         require(publicTotalSupply.add(_numOfTokens) <= PUBLIC_NFT, "Purchase would exceed max NFTs");
1810         require(NFT_PRICE.mul(_numOfTokens) == msg.value, "Invalid Amount");
1811         
1812         if(donate==true) {
1813             checkDistribution(_numOfTokens);
1814         }
1815 
1816         for(uint256 i = 0; i < _numOfTokens; i++) {
1817             _mint(msg.sender, RESERVE_NFT.add(publicTotalSupply));
1818             publicTotalSupply = publicTotalSupply.add(1);
1819         }
1820 
1821         mainSaleClaimed[msg.sender] = mainSaleClaimed[msg.sender].add(_numOfTokens);
1822     }
1823 
1824     // Function to claim giveaway
1825     function claimGiveaway() external whenNotPaused nonReentrant {
1826         for(uint256 i=0; i < giveaway[msg.sender].length; i++) {
1827             _safeMint(msg.sender, giveaway[msg.sender][i]);
1828         }
1829     }
1830 
1831     // Function to mint unclaimed
1832     function mintUnclaimed(address _to, uint256[] memory _tokenIds) external onlyOwner {
1833         for(uint256 i=0; i < _tokenIds.length; i++) {
1834             _safeMint(_to, _tokenIds[i]);
1835         }
1836     }
1837     
1838     // Function to get token URI of given token ID
1839     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1840         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1841         if (!reveal) {
1842             return string(abi.encodePacked(blindURI));
1843         } else {
1844             if (_tokenId < RESERVE_NFT) {
1845                 return string(abi.encodePacked(reserveURI, _tokenId.toString()));
1846             } else {
1847                 return string(abi.encodePacked(baseURI, _tokenId.toString()));
1848             }
1849         }
1850     }
1851 
1852     // Function to check charity and treasury distribution
1853     function checkDistribution(uint256 _numOfTokens) internal {
1854         if (publicTotalSupply < PUBLIC_NFT &&  publicTotalSupply.add(_numOfTokens) >= PUBLIC_NFT) {
1855             payable(communityTreasury).transfer(15 ether);
1856             payable(charity).transfer(12 ether);
1857         } else if (publicTotalSupply < 3675 && publicTotalSupply.add(_numOfTokens) >= 3675) {
1858             payable(communityTreasury).transfer(12 ether);
1859             payable(charity).transfer(8 ether);
1860         } else if (publicTotalSupply < 2450 &&  publicTotalSupply.add(_numOfTokens) >= 2450) {
1861             payable(communityTreasury).transfer(8 ether);
1862             payable(charity).transfer(6 ether);
1863         } else if (publicTotalSupply < 1225 && publicTotalSupply.add(_numOfTokens) >= 1225) {
1864             payable(communityTreasury).transfer(5 ether);
1865             payable(charity).transfer(4 ether);
1866         }
1867     }
1868 
1869     // Function to pause 
1870     function pause() external onlyOwner {
1871         _pause();
1872     }
1873 
1874     // Function to unpause 
1875     function unpause() external onlyOwner {
1876         _unpause();
1877     }
1878 }