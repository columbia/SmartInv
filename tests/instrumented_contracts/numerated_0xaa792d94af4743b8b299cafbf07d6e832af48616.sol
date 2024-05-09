1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-19
3 */
4 
5 // File from: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.7;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File from: @openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 
35 pragma solidity ^0.8.7;
36 
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 // File from: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
176 
177 
178 
179 pragma solidity ^0.8.7;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 // File from: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
205 
206 
207 
208 pragma solidity ^0.8.7;
209 
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 // File from: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 
236 pragma solidity ^0.8.7;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 // File from: @openzeppelin/contracts/utils/Context.sol
452 
453 
454 
455 pragma solidity ^0.8.7;
456 
457 /*
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467 abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view virtual returns (bytes calldata) {
473         return msg.data;
474     }
475 }
476 
477 // File from: @openzeppelin/contracts/utils/Strings.sol
478 
479 
480 
481 pragma solidity ^0.8.7;
482 
483 /**
484  * @dev String operations.
485  */
486 library Strings {
487     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
491      */
492     function toString(uint256 value) internal pure returns (string memory) {
493         // Inspired by OraclizeAPI's implementation - MIT licence
494         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
495 
496         if (value == 0) {
497             return "0";
498         }
499         uint256 temp = value;
500         uint256 digits;
501         while (temp != 0) {
502             digits++;
503             temp /= 10;
504         }
505         bytes memory buffer = new bytes(digits);
506         while (value != 0) {
507             digits -= 1;
508             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
509             value /= 10;
510         }
511         return string(buffer);
512     }
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
516      */
517     function toHexString(uint256 value) internal pure returns (string memory) {
518         if (value == 0) {
519             return "0x00";
520         }
521         uint256 temp = value;
522         uint256 length = 0;
523         while (temp != 0) {
524             length++;
525             temp >>= 8;
526         }
527         return toHexString(value, length);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
532      */
533     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
534         bytes memory buffer = new bytes(2 * length + 2);
535         buffer[0] = "0";
536         buffer[1] = "x";
537         for (uint256 i = 2 * length + 1; i > 1; --i) {
538             buffer[i] = _HEX_SYMBOLS[value & 0xf];
539             value >>= 4;
540         }
541         require(value == 0, "Strings: hex length insufficient");
542         return string(buffer);
543     }
544 }
545 
546 // File from: @openzeppelin/contracts/utils/introspection/ERC165.sol
547 
548 pragma solidity ^0.8.7;
549 
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 // File from: @openzeppelin/contracts/token/ERC721/ERC721.sol
575 
576 pragma solidity ^0.8.7;
577 
578 /**
579  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
580  * the Metadata extension, but not including the Enumerable extension, which is available separately as
581  * {ERC721Enumerable}.
582  */
583 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
584     using Address for address;
585     using Strings for uint256;
586 
587     // Token name
588     string private _name;
589 
590     // Token symbol
591     string private _symbol;
592 
593     // Mapping from token ID to owner address
594     mapping(uint256 => address) private _owners;
595 
596     // Mapping owner address to token count
597     mapping(address => uint256) private _balances;
598 
599     // Mapping from token ID to approved address
600     mapping(uint256 => address) private _tokenApprovals;
601 
602     // Mapping from owner to operator approvals
603     mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605     /**
606      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
607      */
608     constructor(string memory name_, string memory symbol_) {
609         _name = name_;
610         _symbol = symbol_;
611     }
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
617         return
618         interfaceId == type(IERC721).interfaceId ||
619         interfaceId == type(IERC721Metadata).interfaceId ||
620         super.supportsInterface(interfaceId);
621     }
622 
623     /**
624      * @dev See {IERC721-balanceOf}.
625      */
626     function balanceOf(address owner) public view virtual override returns (uint256) {
627         require(owner != address(0), "ERC721: balance query for the zero address");
628         return _balances[owner];
629     }
630 
631     /**
632      * @dev See {IERC721-ownerOf}.
633      */
634     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
635         address owner = _owners[tokenId];
636         require(owner != address(0), "ERC721: owner query for nonexistent token");
637         return owner;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-name}.
642      */
643     function name() public view virtual override returns (string memory) {
644         return _name;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-symbol}.
649      */
650     function symbol() public view virtual override returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-tokenURI}.
656      */
657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
658         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
659 
660         string memory baseURI = _baseURI();
661         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
662     }
663 
664     /**
665      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
666      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
667      * by default, can be overriden in child contracts.
668      */
669     function _baseURI() internal view virtual returns (string memory) {
670         return "";
671     }
672 
673     /**
674      * @dev See {IERC721-approve}.
675      */
676     function approve(address to, uint256 tokenId) public virtual override {
677         address owner = ERC721.ownerOf(tokenId);
678         require(to != owner, "ERC721: approval to current owner");
679 
680         require(
681             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
682             "ERC721: approve caller is not owner nor approved for all"
683         );
684 
685         _approve(to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-getApproved}.
690      */
691     function getApproved(uint256 tokenId) public view virtual override returns (address) {
692         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
693 
694         return _tokenApprovals[tokenId];
695     }
696 
697     /**
698      * @dev See {IERC721-setApprovalForAll}.
699      */
700     function setApprovalForAll(address operator, bool approved) public virtual override {
701         require(operator != _msgSender(), "ERC721: approve to caller");
702 
703         _operatorApprovals[_msgSender()][operator] = approved;
704         emit ApprovalForAll(_msgSender(), operator, approved);
705     }
706 
707     /**
708      * @dev See {IERC721-isApprovedForAll}.
709      */
710     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
711         return _operatorApprovals[owner][operator];
712     }
713 
714     /**
715      * @dev See {IERC721-transferFrom}.
716      */
717     function transferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         //solhint-disable-next-line max-line-length
723         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
724 
725         _transfer(from, to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         safeTransferFrom(from, to, tokenId, "");
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId,
746         bytes memory _data
747     ) public virtual override {
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749         _safeTransfer(from, to, tokenId, _data);
750     }
751 
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
754      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
755      *
756      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
757      *
758      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
759      * implement alternative mechanisms to perform token transfer, such as signature-based.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeTransfer(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes memory _data
775     ) internal virtual {
776         _transfer(from, to, tokenId);
777         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
778     }
779 
780     /**
781      * @dev Returns whether `tokenId` exists.
782      *
783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
784      *
785      * Tokens start existing when they are minted (`_mint`),
786      * and stop existing when they are burned (`_burn`).
787      */
788     function _exists(uint256 tokenId) internal view virtual returns (bool) {
789         return _owners[tokenId] != address(0);
790     }
791 
792     /**
793      * @dev Returns whether `spender` is allowed to manage `tokenId`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
800         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
801         address owner = ERC721.ownerOf(tokenId);
802         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
803     }
804 
805     /**
806      * @dev Safely mints `tokenId` and transfers it to `to`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeMint(address to, uint256 tokenId) internal virtual {
816         _safeMint(to, tokenId, "");
817     }
818 
819     /**
820      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
821      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
822      */
823     function _safeMint(
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) internal virtual {
828         _mint(to, tokenId);
829         require(
830             _checkOnERC721Received(address(0), to, tokenId, _data),
831             "ERC721: transfer to non ERC721Receiver implementer"
832         );
833     }
834 
835     /**
836      * @dev Mints `tokenId` and transfers it to `to`.
837      *
838      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - `to` cannot be the zero address.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _mint(address to, uint256 tokenId) internal virtual {
848         require(to != address(0), "ERC721: mint to the zero address");
849         require(!_exists(tokenId), "ERC721: token already minted");
850 
851         _beforeTokenTransfer(address(0), to, tokenId);
852 
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(address(0), to, tokenId);
857     }
858 
859     /**
860      * @dev Destroys `tokenId`.
861      * The approval is cleared when the token is burned.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _burn(uint256 tokenId) internal virtual {
870         address owner = ERC721.ownerOf(tokenId);
871 
872         _beforeTokenTransfer(owner, address(0), tokenId);
873 
874         // Clear approvals
875         _approve(address(0), tokenId);
876 
877         _balances[owner] -= 1;
878         delete _owners[tokenId];
879 
880         emit Transfer(owner, address(0), tokenId);
881     }
882 
883     /**
884      * @dev Transfers `tokenId` from `from` to `to`.
885      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
886      *
887      * Requirements:
888      *
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must be owned by `from`.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _transfer(
895         address from,
896         address to,
897         uint256 tokenId
898     ) internal virtual {
899         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
900         require(to != address(0), "ERC721: transfer to the zero address");
901 
902         _beforeTokenTransfer(from, to, tokenId);
903 
904         // Clear approvals from the previous owner
905         _approve(address(0), tokenId);
906 
907         _balances[from] -= 1;
908         _balances[to] += 1;
909         _owners[tokenId] = to;
910 
911         emit Transfer(from, to, tokenId);
912     }
913 
914     /**
915      * @dev Approve `to` to operate on `tokenId`
916      *
917      * Emits a {Approval} event.
918      */
919     function _approve(address to, uint256 tokenId) internal virtual {
920         _tokenApprovals[tokenId] = to;
921         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
922     }
923 
924     /**
925      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
926      * The call is not executed if the target address is not a contract.
927      *
928      * @param from address representing the previous owner of the given token ID
929      * @param to target address that will receive the tokens
930      * @param tokenId uint256 ID of the token to be transferred
931      * @param _data bytes optional data to send along with the call
932      * @return bool whether the call correctly returned the expected magic value
933      */
934     function _checkOnERC721Received(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) private returns (bool) {
940         if (to.isContract()) {
941             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
942                 return retval == IERC721Receiver.onERC721Received.selector;
943             } catch (bytes memory reason) {
944                 if (reason.length == 0) {
945                     revert("ERC721: transfer to non ERC721Receiver implementer");
946                 } else {
947                     assembly {
948                         revert(add(32, reason), mload(reason))
949                     }
950                 }
951             }
952         } else {
953             return true;
954         }
955     }
956 
957     /**
958      * @dev Hook that is called before any token transfer. This includes minting
959      * and burning.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` will be minted for `to`.
966      * - When `to` is zero, ``from``'s `tokenId` will be burned.
967      * - `from` and `to` are never both zero.
968      *
969      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
970      */
971     function _beforeTokenTransfer(
972         address from,
973         address to,
974         uint256 tokenId
975     ) internal virtual {}
976 }
977 
978 // File from: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
979 
980 
981 
982 pragma solidity ^0.8.7;
983 
984 
985 /**
986  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
987  * @dev See https://eips.ethereum.org/EIPS/eip-721
988  */
989 interface IERC721Enumerable is IERC721 {
990     /**
991      * @dev Returns the total amount of tokens stored by the contract.
992      */
993     function totalSupply() external view returns (uint256);
994 
995     /**
996      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
997      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
998      */
999     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1000 
1001     /**
1002      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1003      * Use along with {totalSupply} to enumerate all tokens.
1004      */
1005     function tokenByIndex(uint256 index) external view returns (uint256);
1006 }
1007 
1008 // File from: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1009 
1010 
1011 
1012 pragma solidity ^0.8.7;
1013 
1014 
1015 
1016 /**
1017  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1018  * enumerability of all the token ids in the contract as well as all token ids owned by each
1019  * account.
1020  */
1021 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1022     // Mapping from owner to list of owned token IDs
1023     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1024 
1025     // Mapping from token ID to index of the owner tokens list
1026     mapping(uint256 => uint256) private _ownedTokensIndex;
1027 
1028     // Array with all token ids, used for enumeration
1029     uint256[] private _allTokens;
1030 
1031     // Mapping from token id to position in the allTokens array
1032     mapping(uint256 => uint256) private _allTokensIndex;
1033 
1034     /**
1035      * @dev See {IERC165-supportsInterface}.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1038         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1043      */
1044     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1045         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1046         return _ownedTokens[owner][index];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-totalSupply}.
1051      */
1052     function totalSupply() public view virtual override returns (uint256) {
1053         return _allTokens.length;
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenByIndex}.
1058      */
1059     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1060         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1061         return _allTokens[index];
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual override {
1084         super._beforeTokenTransfer(from, to, tokenId);
1085 
1086         if (from == address(0)) {
1087             _addTokenToAllTokensEnumeration(tokenId);
1088         } else if (from != to) {
1089             _removeTokenFromOwnerEnumeration(from, tokenId);
1090         }
1091         if (to == address(0)) {
1092             _removeTokenFromAllTokensEnumeration(tokenId);
1093         } else if (to != from) {
1094             _addTokenToOwnerEnumeration(to, tokenId);
1095         }
1096     }
1097 
1098     /**
1099      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1100      * @param to address representing the new owner of the given token ID
1101      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1102      */
1103     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1104         uint256 length = ERC721.balanceOf(to);
1105         _ownedTokens[to][length] = tokenId;
1106         _ownedTokensIndex[tokenId] = length;
1107     }
1108 
1109     /**
1110      * @dev Private function to add a token to this extension's token tracking data structures.
1111      * @param tokenId uint256 ID of the token to be added to the tokens list
1112      */
1113     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1114         _allTokensIndex[tokenId] = _allTokens.length;
1115         _allTokens.push(tokenId);
1116     }
1117 
1118     /**
1119      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1120      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1121      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1122      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1123      * @param from address representing the previous owner of the given token ID
1124      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1125      */
1126     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1127         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1128         // then delete the last slot (swap and pop).
1129 
1130         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1131         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1132 
1133         // When the token to delete is the last token, the swap operation is unnecessary
1134         if (tokenIndex != lastTokenIndex) {
1135             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1136 
1137             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139         }
1140 
1141         // This also deletes the contents at the last position of the array
1142         delete _ownedTokensIndex[tokenId];
1143         delete _ownedTokens[from][lastTokenIndex];
1144     }
1145 
1146     /**
1147      * @dev Private function to remove a token from this extension's token tracking data structures.
1148      * This has O(1) time complexity, but alters the order of the _allTokens array.
1149      * @param tokenId uint256 ID of the token to be removed from the tokens list
1150      */
1151     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1152         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1153         // then delete the last slot (swap and pop).
1154 
1155         uint256 lastTokenIndex = _allTokens.length - 1;
1156         uint256 tokenIndex = _allTokensIndex[tokenId];
1157 
1158         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1159         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1160         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1161         uint256 lastTokenId = _allTokens[lastTokenIndex];
1162 
1163         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1164         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1165 
1166         // This also deletes the contents at the last position of the array
1167         delete _allTokensIndex[tokenId];
1168         _allTokens.pop();
1169     }
1170 }
1171 
1172 // File from: @openzeppelin/contracts/access/Ownable.sol
1173 
1174 
1175 pragma solidity ^0.8.7;
1176 
1177 /**
1178  * @dev Contract module which provides a basic access control mechanism, where
1179  * there is an account (an owner) that can be granted exclusive access to
1180  * specific functions.
1181  *
1182  * By default, the owner account will be the one that deploys the contract. This
1183  * can later be changed with {transferOwnership}.
1184  *
1185  * This module is used through inheritance. It will make available the modifier
1186  * `onlyOwner`, which can be applied to your functions to restrict their use to
1187  * the owner.
1188  */
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _transferOwnership(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _transferOwnership(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _transferOwnership(newOwner);
1234     }
1235 
1236     /**
1237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1238      * Internal function without access restriction.
1239      */
1240     function _transferOwnership(address newOwner) internal virtual {
1241         address oldOwner = _owner;
1242         _owner = newOwner;
1243         emit OwnershipTransferred(oldOwner, newOwner);
1244     }
1245 }
1246 
1247 // File from: contracts/Companion.sol
1248 
1249 
1250 pragma solidity ^0.8.7;
1251 
1252 abstract contract SUYT {
1253     function balanceOf(address owner) external virtual view returns (uint256 balance);
1254     function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1255     function ownerOf(uint256 tokenId) public virtual view returns (address);
1256 }
1257 
1258 contract Companion is ERC721Enumerable, Ownable {
1259     SUYT private suyt;
1260     bool public _is_sale_active = false;
1261     string private baseURI;
1262     string public _provenance = "";
1263     uint public _max_mint;
1264     uint256 public _saleStarttime;
1265     uint256 public _saleEndtime;
1266 
1267     constructor(
1268         string memory name,
1269         string memory symbol,
1270         uint maxMint,
1271         uint256 saleStartTime,
1272         address dependentContractAddress
1273     ) ERC721(name, symbol) {
1274         _max_mint = maxMint;
1275         _saleStarttime = saleStartTime;
1276         _saleEndtime = saleStartTime + (86400 * 15);
1277         suyt = SUYT(dependentContractAddress);
1278     }
1279     // change max mint if necessary
1280     function setMaxMint(uint maxMint) public onlyOwner {
1281         _max_mint = maxMint;
1282     }
1283     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1284         _provenance = provenanceHash;
1285     }
1286     function isMinted(uint256 tokenId) external view returns (bool) {
1287         return _exists(tokenId);
1288     }
1289     function _baseURI() internal view override returns (string memory) {
1290         return baseURI;
1291     }
1292     function setBaseURI(string memory uri) public onlyOwner {
1293         baseURI = uri;
1294     }
1295     function mintCompanion(uint256 suytTokenId) public {
1296         require(block.timestamp > _saleStarttime, "Sale must start!");
1297         require(block.timestamp < _saleEndtime, "Sale has ended!");
1298         require(suyt.ownerOf(suytTokenId) == msg.sender, "Superyeti and Sno Demon ID doesn't match");
1299         _safeMint(msg.sender, suytTokenId);
1300     }
1301 
1302     function mintCompanions(uint[] memory tokenIDs) public {
1303         require(block.timestamp > _saleStarttime, "Sale must start!");
1304         require(block.timestamp < _saleEndtime, "Sale has Ended!");
1305         require(tokenIDs.length <= _max_mint, "Max Mint Exceeded");
1306         for (uint i=0; i < tokenIDs.length; i++) {
1307             require(suyt.ownerOf(tokenIDs[i]) == msg.sender, "Superyeti and Sno Demon ID doesn't match");
1308             _safeMint(msg.sender, tokenIDs[i]);
1309         }
1310     }
1311 }