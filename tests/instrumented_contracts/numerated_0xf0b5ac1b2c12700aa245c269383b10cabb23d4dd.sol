1 // Sources flattened with hardhat v2.7.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.0
4 
5 
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
1014 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
1015 
1016 
1017 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @dev Contract module which provides a basic access control mechanism, where
1023  * there is an account (an owner) that can be granted exclusive access to
1024  * specific functions.
1025  *
1026  * By default, the owner account will be the one that deploys the contract. This
1027  * can later be changed with {transferOwnership}.
1028  *
1029  * This module is used through inheritance. It will make available the modifier
1030  * `onlyOwner`, which can be applied to your functions to restrict their use to
1031  * the owner.
1032  */
1033 abstract contract Ownable is Context {
1034     address private _owner;
1035 
1036     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1037 
1038     /**
1039      * @dev Initializes the contract setting the deployer as the initial owner.
1040      */
1041     constructor() {
1042         _transferOwnership(_msgSender());
1043     }
1044 
1045     /**
1046      * @dev Returns the address of the current owner.
1047      */
1048     function owner() public view virtual returns (address) {
1049         return _owner;
1050     }
1051 
1052     /**
1053      * @dev Throws if called by any account other than the owner.
1054      */
1055     modifier onlyOwner() {
1056         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1057         _;
1058     }
1059 
1060     /**
1061      * @dev Leaves the contract without owner. It will not be possible to call
1062      * `onlyOwner` functions anymore. Can only be called by the current owner.
1063      *
1064      * NOTE: Renouncing ownership will leave the contract without an owner,
1065      * thereby removing any functionality that is only available to the owner.
1066      */
1067     function renounceOwnership() public virtual onlyOwner {
1068         _transferOwnership(address(0));
1069     }
1070 
1071     /**
1072      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1073      * Can only be called by the current owner.
1074      */
1075     function transferOwnership(address newOwner) public virtual onlyOwner {
1076         require(newOwner != address(0), "Ownable: new owner is the zero address");
1077         _transferOwnership(newOwner);
1078     }
1079 
1080     /**
1081      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1082      * Internal function without access restriction.
1083      */
1084     function _transferOwnership(address newOwner) internal virtual {
1085         address oldOwner = _owner;
1086         _owner = newOwner;
1087         emit OwnershipTransferred(oldOwner, newOwner);
1088     }
1089 }
1090 
1091 
1092 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.4.0
1093 
1094 
1095 // OpenZeppelin Contracts v4.4.0 (utils/structs/EnumerableSet.sol)
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 /**
1100  * @dev Library for managing
1101  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1102  * types.
1103  *
1104  * Sets have the following properties:
1105  *
1106  * - Elements are added, removed, and checked for existence in constant time
1107  * (O(1)).
1108  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1109  *
1110  * ```
1111  * contract Example {
1112  *     // Add the library methods
1113  *     using EnumerableSet for EnumerableSet.AddressSet;
1114  *
1115  *     // Declare a set state variable
1116  *     EnumerableSet.AddressSet private mySet;
1117  * }
1118  * ```
1119  *
1120  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1121  * and `uint256` (`UintSet`) are supported.
1122  */
1123 library EnumerableSet {
1124     // To implement this library for multiple types with as little code
1125     // repetition as possible, we write it in terms of a generic Set type with
1126     // bytes32 values.
1127     // The Set implementation uses private functions, and user-facing
1128     // implementations (such as AddressSet) are just wrappers around the
1129     // underlying Set.
1130     // This means that we can only create new EnumerableSets for types that fit
1131     // in bytes32.
1132 
1133     struct Set {
1134         // Storage of set values
1135         bytes32[] _values;
1136         // Position of the value in the `values` array, plus 1 because index 0
1137         // means a value is not in the set.
1138         mapping(bytes32 => uint256) _indexes;
1139     }
1140 
1141     /**
1142      * @dev Add a value to a set. O(1).
1143      *
1144      * Returns true if the value was added to the set, that is if it was not
1145      * already present.
1146      */
1147     function _add(Set storage set, bytes32 value) private returns (bool) {
1148         if (!_contains(set, value)) {
1149             set._values.push(value);
1150             // The value is stored at length-1, but we add 1 to all indexes
1151             // and use 0 as a sentinel value
1152             set._indexes[value] = set._values.length;
1153             return true;
1154         } else {
1155             return false;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Removes a value from a set. O(1).
1161      *
1162      * Returns true if the value was removed from the set, that is if it was
1163      * present.
1164      */
1165     function _remove(Set storage set, bytes32 value) private returns (bool) {
1166         // We read and store the value's index to prevent multiple reads from the same storage slot
1167         uint256 valueIndex = set._indexes[value];
1168 
1169         if (valueIndex != 0) {
1170             // Equivalent to contains(set, value)
1171             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1172             // the array, and then remove the last element (sometimes called as 'swap and pop').
1173             // This modifies the order of the array, as noted in {at}.
1174 
1175             uint256 toDeleteIndex = valueIndex - 1;
1176             uint256 lastIndex = set._values.length - 1;
1177 
1178             if (lastIndex != toDeleteIndex) {
1179                 bytes32 lastvalue = set._values[lastIndex];
1180 
1181                 // Move the last value to the index where the value to delete is
1182                 set._values[toDeleteIndex] = lastvalue;
1183                 // Update the index for the moved value
1184                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1185             }
1186 
1187             // Delete the slot where the moved value was stored
1188             set._values.pop();
1189 
1190             // Delete the index for the deleted slot
1191             delete set._indexes[value];
1192 
1193             return true;
1194         } else {
1195             return false;
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns true if the value is in the set. O(1).
1201      */
1202     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1203         return set._indexes[value] != 0;
1204     }
1205 
1206     /**
1207      * @dev Returns the number of values on the set. O(1).
1208      */
1209     function _length(Set storage set) private view returns (uint256) {
1210         return set._values.length;
1211     }
1212 
1213     /**
1214      * @dev Returns the value stored at position `index` in the set. O(1).
1215      *
1216      * Note that there are no guarantees on the ordering of values inside the
1217      * array, and it may change when more values are added or removed.
1218      *
1219      * Requirements:
1220      *
1221      * - `index` must be strictly less than {length}.
1222      */
1223     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1224         return set._values[index];
1225     }
1226 
1227     /**
1228      * @dev Return the entire set in an array
1229      *
1230      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1231      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1232      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1233      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1234      */
1235     function _values(Set storage set) private view returns (bytes32[] memory) {
1236         return set._values;
1237     }
1238 
1239     // Bytes32Set
1240 
1241     struct Bytes32Set {
1242         Set _inner;
1243     }
1244 
1245     /**
1246      * @dev Add a value to a set. O(1).
1247      *
1248      * Returns true if the value was added to the set, that is if it was not
1249      * already present.
1250      */
1251     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1252         return _add(set._inner, value);
1253     }
1254 
1255     /**
1256      * @dev Removes a value from a set. O(1).
1257      *
1258      * Returns true if the value was removed from the set, that is if it was
1259      * present.
1260      */
1261     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1262         return _remove(set._inner, value);
1263     }
1264 
1265     /**
1266      * @dev Returns true if the value is in the set. O(1).
1267      */
1268     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1269         return _contains(set._inner, value);
1270     }
1271 
1272     /**
1273      * @dev Returns the number of values in the set. O(1).
1274      */
1275     function length(Bytes32Set storage set) internal view returns (uint256) {
1276         return _length(set._inner);
1277     }
1278 
1279     /**
1280      * @dev Returns the value stored at position `index` in the set. O(1).
1281      *
1282      * Note that there are no guarantees on the ordering of values inside the
1283      * array, and it may change when more values are added or removed.
1284      *
1285      * Requirements:
1286      *
1287      * - `index` must be strictly less than {length}.
1288      */
1289     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1290         return _at(set._inner, index);
1291     }
1292 
1293     /**
1294      * @dev Return the entire set in an array
1295      *
1296      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1297      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1298      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1299      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1300      */
1301     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1302         return _values(set._inner);
1303     }
1304 
1305     // AddressSet
1306 
1307     struct AddressSet {
1308         Set _inner;
1309     }
1310 
1311     /**
1312      * @dev Add a value to a set. O(1).
1313      *
1314      * Returns true if the value was added to the set, that is if it was not
1315      * already present.
1316      */
1317     function add(AddressSet storage set, address value) internal returns (bool) {
1318         return _add(set._inner, bytes32(uint256(uint160(value))));
1319     }
1320 
1321     /**
1322      * @dev Removes a value from a set. O(1).
1323      *
1324      * Returns true if the value was removed from the set, that is if it was
1325      * present.
1326      */
1327     function remove(AddressSet storage set, address value) internal returns (bool) {
1328         return _remove(set._inner, bytes32(uint256(uint160(value))));
1329     }
1330 
1331     /**
1332      * @dev Returns true if the value is in the set. O(1).
1333      */
1334     function contains(AddressSet storage set, address value) internal view returns (bool) {
1335         return _contains(set._inner, bytes32(uint256(uint160(value))));
1336     }
1337 
1338     /**
1339      * @dev Returns the number of values in the set. O(1).
1340      */
1341     function length(AddressSet storage set) internal view returns (uint256) {
1342         return _length(set._inner);
1343     }
1344 
1345     /**
1346      * @dev Returns the value stored at position `index` in the set. O(1).
1347      *
1348      * Note that there are no guarantees on the ordering of values inside the
1349      * array, and it may change when more values are added or removed.
1350      *
1351      * Requirements:
1352      *
1353      * - `index` must be strictly less than {length}.
1354      */
1355     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1356         return address(uint160(uint256(_at(set._inner, index))));
1357     }
1358 
1359     /**
1360      * @dev Return the entire set in an array
1361      *
1362      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1363      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1364      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1365      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1366      */
1367     function values(AddressSet storage set) internal view returns (address[] memory) {
1368         bytes32[] memory store = _values(set._inner);
1369         address[] memory result;
1370 
1371         assembly {
1372             result := store
1373         }
1374 
1375         return result;
1376     }
1377 
1378     // UintSet
1379 
1380     struct UintSet {
1381         Set _inner;
1382     }
1383 
1384     /**
1385      * @dev Add a value to a set. O(1).
1386      *
1387      * Returns true if the value was added to the set, that is if it was not
1388      * already present.
1389      */
1390     function add(UintSet storage set, uint256 value) internal returns (bool) {
1391         return _add(set._inner, bytes32(value));
1392     }
1393 
1394     /**
1395      * @dev Removes a value from a set. O(1).
1396      *
1397      * Returns true if the value was removed from the set, that is if it was
1398      * present.
1399      */
1400     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1401         return _remove(set._inner, bytes32(value));
1402     }
1403 
1404     /**
1405      * @dev Returns true if the value is in the set. O(1).
1406      */
1407     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1408         return _contains(set._inner, bytes32(value));
1409     }
1410 
1411     /**
1412      * @dev Returns the number of values on the set. O(1).
1413      */
1414     function length(UintSet storage set) internal view returns (uint256) {
1415         return _length(set._inner);
1416     }
1417 
1418     /**
1419      * @dev Returns the value stored at position `index` in the set. O(1).
1420      *
1421      * Note that there are no guarantees on the ordering of values inside the
1422      * array, and it may change when more values are added or removed.
1423      *
1424      * Requirements:
1425      *
1426      * - `index` must be strictly less than {length}.
1427      */
1428     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1429         return uint256(_at(set._inner, index));
1430     }
1431 
1432     /**
1433      * @dev Return the entire set in an array
1434      *
1435      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1436      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1437      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1438      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1439      */
1440     function values(UintSet storage set) internal view returns (uint256[] memory) {
1441         bytes32[] memory store = _values(set._inner);
1442         uint256[] memory result;
1443 
1444         assembly {
1445             result := store
1446         }
1447 
1448         return result;
1449     }
1450 }
1451 
1452 
1453 // File contracts/DoodLadsNFT.sol
1454 
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 
1459 
1460 /**
1461     Dood Lads is a collection of 4,555 randomly generated NFTs on the Ethereum blockchain.
1462      A tribute project inspired by Larva Lads and Doodles.
1463     Join the Doodlelads and vibe with other Dood Lads!
1464     Spread our !vibe over the whole space!
1465     Make friends here! WGMI!
1466 **/
1467 contract DoodLadsNFT is ERC721, Ownable {
1468     /// @dev Library
1469     ////////////////////////////////////////////
1470     using EnumerableSet for EnumerableSet.UintSet;
1471 
1472     /// @dev Event
1473     event PurchaseEvent(address purchaseWallet, uint256 nftID, uint256 purchaseTimestamp);
1474     ////////////////////////////////////////////
1475 
1476     /// @dev All constant defination
1477     ////////////////////////////////////////////
1478     uint256 public constant TOTAL_SUPPLY = 3555;
1479 
1480     uint256 public constant PRICE = 0.0188 ether;
1481 
1482     uint256 public constant PRE_SAlE_AMOUNT = 1000;
1483 
1484     uint256 public constant PRE_SALE_PRICE = 0.0 ether;
1485 
1486     address public constant WITHDRAW_ADDRESS = 0x8c89031Ee2ED29b5d4dc1671078a122f3E000310;
1487 
1488     /// @dev public variable for business
1489     ////////////////////////////////////////////
1490 
1491     /// @dev how many NFTs have been sold
1492     uint256 private _totalSold;
1493 
1494     /// @dev notice upgrade token
1495     bool private IS_SELLING = true;
1496 
1497     mapping(address=>EnumerableSet.UintSet) private ownedNFTs;
1498 
1499     string private BASE_URI = "https://nft.doodladsnft.com/id/";
1500 
1501     /// functions
1502     ////////////////////////////////////////////////////////////////////////
1503 
1504     /// NFT Related
1505     ////////////////////////////////////////////////////////////////////////
1506     constructor() ERC721("DooDLads", "Lads") {}
1507 
1508     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1509         return string(abi.encodePacked(BASE_URI, Strings.toString(tokenId), ".json"));
1510     }
1511 
1512 
1513     /// @dev total sold
1514     /// @return total sold amount
1515     function totalSold() public view returns (uint256) {
1516         return _totalSold;
1517     }
1518 
1519     /// @dev check if we have storage for the purchase
1520     function isEnoughSupply(uint256 amount, bool needReportError) private view returns (bool) {
1521         uint256 solded = totalSold();
1522         uint256 afterPurchase = solded + amount;
1523         if (needReportError) {
1524             require(afterPurchase <= TOTAL_SUPPLY, "Max limit");
1525             return true;
1526         } else {
1527             if (afterPurchase <= TOTAL_SUPPLY) {
1528                 return true;
1529             } else {
1530                 return false;
1531             }
1532         }
1533     }
1534 
1535     function queryPurchaseLimit(address target) public view returns (uint256) {
1536         if (totalSold() >= PRE_SAlE_AMOUNT) {
1537             return 10;
1538         } else {
1539             return 5;
1540         }
1541     }
1542 
1543 
1544     function queryPurchaseTotalFee(uint256 amount) public view returns (uint256 totalFee) {
1545         // price validate
1546         if (totalSold() >= PRE_SAlE_AMOUNT) {
1547             // normal price
1548             totalFee = (PRICE * amount);
1549         } else {
1550             if (totalSold() + amount > PRE_SAlE_AMOUNT) {
1551                 totalFee = (PRE_SAlE_AMOUNT - totalSold()) * PRE_SALE_PRICE + (PRICE * (amount - (PRE_SAlE_AMOUNT - totalSold())));
1552             } else {
1553                 totalFee = (PRE_SALE_PRICE * amount);
1554             }
1555         }
1556     }
1557 
1558     function purchaseValidate(address purchaseUser, uint256 amount) private view {
1559         // basic validate
1560         require(IS_SELLING == true, "Not start selling yet(1)");
1561         require(amount >= 1, "at least purchase 1");
1562         require(amount <= 10, "at most purchase 10");
1563         isEnoughSupply(amount, true);
1564         // price validate
1565         if (totalSold() > PRE_SAlE_AMOUNT) {
1566             // normal price
1567             require(msg.value >= (PRICE * amount), "insufficient value");
1568         } else {
1569             
1570             if (totalSold() + amount > PRE_SAlE_AMOUNT) {
1571                 uint256 requireAmount = (PRE_SAlE_AMOUNT - totalSold()) * PRE_SALE_PRICE + (PRICE * (amount - (PRE_SAlE_AMOUNT - totalSold())));
1572                 require(msg.value >= requireAmount, "insufficient value");
1573             } else {
1574                 // preSales
1575                 // require(ownedNFTs[purchaseUser].length() + amount <= 3, "purchase over is limite");
1576                 require(amount <= 5, "at most purchase 5");
1577                 require(msg.value >= (PRE_SALE_PRICE * amount), "insufficient value");
1578             }
1579         }
1580     }
1581 
1582 
1583     /// @dev inner method to verify the owner of the token
1584     function isOwner(uint256 nftID, address owner) private view returns(bool isNFTOwner) {
1585         address tokenOwner = ownerOf(nftID);
1586         isNFTOwner = (tokenOwner == owner);
1587     }
1588 
1589 
1590     /// @dev mint function
1591     function mintToAddress(address purchaseUser, uint256 amount) private {
1592         EnumerableSet.UintSet storage nftSet = ownedNFTs[purchaseUser];
1593         uint256 currentTokenId = _totalSold;
1594         for(uint256 i=0; i<amount; i++){
1595             // do mint
1596             currentTokenId = currentTokenId + 1;
1597             _safeMint(purchaseUser, currentTokenId);
1598             nftSet.add(currentTokenId);
1599             emit PurchaseEvent(purchaseUser, currentTokenId, block.timestamp);
1600         }
1601         _totalSold = currentTokenId;
1602     }
1603 
1604 
1605     /// @dev show all purchased nfts by Arrays
1606     /// @return tokens nftID array
1607     function listMyNFT(address owner) external view returns (uint256[] memory tokens) {
1608         EnumerableSet.UintSet storage nftSets = ownedNFTs[owner];
1609         tokens = nftSets.values();
1610     }
1611 
1612 
1613     /// @dev user doing purchase
1614     /// @param amount how many
1615     function purchaseNFT(uint256 amount) external payable {
1616         address purchaseUser = msg.sender;
1617         purchaseValidate(purchaseUser, amount);
1618         mintToAddress(purchaseUser, amount);
1619     }
1620 
1621 
1622     function transferFrom(
1623         address from,
1624         address to,
1625         uint256 tokenId
1626     ) public override {
1627 
1628         ownedNFTs[from].remove(tokenId);
1629         super.transferFrom(from, to, tokenId);
1630         ownedNFTs[to].add(tokenId);
1631 
1632     }
1633 
1634     /// Admin Functions
1635     //////////////////////////////////////////////////////////////////////////////////////////
1636     //////////////////////////////////////////////////////////////////////////////////////////
1637     function batchMint(address wallet, uint amount) external onlyOwner {
1638         isEnoughSupply(amount, true);
1639         mintToAddress(wallet, amount);
1640     }
1641 
1642     function setSelling(bool isSelling) external onlyOwner {
1643         IS_SELLING = isSelling;
1644     }
1645 
1646     function withdrawETH() external {
1647         if (msg.sender == WITHDRAW_ADDRESS) {
1648             payable(msg.sender).transfer(address(this).balance);
1649         }
1650     }
1651 
1652 }