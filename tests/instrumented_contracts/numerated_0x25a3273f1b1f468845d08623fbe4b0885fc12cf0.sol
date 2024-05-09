1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
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
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
32 
33 
34 
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
176 
177 
178 
179 
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
204 
205 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
206 
207 
208 
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
232 
233 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
234 
235 
236 
237 
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 
453 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
454 
455 
456 
457 
458 
459 /**
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes calldata) {
475         return msg.data;
476     }
477 }
478 
479 
480 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
481 
482 
483 
484 
485 
486 /**
487  * @dev String operations.
488  */
489 library Strings {
490     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
494      */
495     function toString(uint256 value) internal pure returns (string memory) {
496         // Inspired by OraclizeAPI's implementation - MIT licence
497         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
498 
499         if (value == 0) {
500             return "0";
501         }
502         uint256 temp = value;
503         uint256 digits;
504         while (temp != 0) {
505             digits++;
506             temp /= 10;
507         }
508         bytes memory buffer = new bytes(digits);
509         while (value != 0) {
510             digits -= 1;
511             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
512             value /= 10;
513         }
514         return string(buffer);
515     }
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
519      */
520     function toHexString(uint256 value) internal pure returns (string memory) {
521         if (value == 0) {
522             return "0x00";
523         }
524         uint256 temp = value;
525         uint256 length = 0;
526         while (temp != 0) {
527             length++;
528             temp >>= 8;
529         }
530         return toHexString(value, length);
531     }
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
535      */
536     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
537         bytes memory buffer = new bytes(2 * length + 2);
538         buffer[0] = "0";
539         buffer[1] = "x";
540         for (uint256 i = 2 * length + 1; i > 1; --i) {
541             buffer[i] = _HEX_SYMBOLS[value & 0xf];
542             value >>= 4;
543         }
544         require(value == 0, "Strings: hex length insufficient");
545         return string(buffer);
546     }
547 }
548 
549 
550 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
551 
552 
553 
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 
580 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
581 
582 
583 
584 
585 
586 
587 
588 
589 
590 
591 
592 /**
593  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
594  * the Metadata extension, but not including the Enumerable extension, which is available separately as
595  * {ERC721Enumerable}.
596  */
597 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
598     using Address for address;
599     using Strings for uint256;
600 
601     // Token name
602     string private _name;
603 
604     // Token symbol
605     string private _symbol;
606 
607     // Mapping from token ID to owner address
608     mapping(uint256 => address) private _owners;
609 
610     // Mapping owner address to token count
611     mapping(address => uint256) private _balances;
612 
613     // Mapping from token ID to approved address
614     mapping(uint256 => address) private _tokenApprovals;
615 
616     // Mapping from owner to operator approvals
617     mapping(address => mapping(address => bool)) private _operatorApprovals;
618 
619     /**
620      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
621      */
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625     }
626 
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
631         return
632             interfaceId == type(IERC721).interfaceId ||
633             interfaceId == type(IERC721Metadata).interfaceId ||
634             super.supportsInterface(interfaceId);
635     }
636 
637     /**
638      * @dev See {IERC721-balanceOf}.
639      */
640     function balanceOf(address owner) public view virtual override returns (uint256) {
641         require(owner != address(0), "ERC721: balance query for the zero address");
642         return _balances[owner];
643     }
644 
645     /**
646      * @dev See {IERC721-ownerOf}.
647      */
648     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
649         address owner = _owners[tokenId];
650         require(owner != address(0), "ERC721: owner query for nonexistent token");
651         return owner;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-name}.
656      */
657     function name() public view virtual override returns (string memory) {
658         return _name;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-symbol}.
663      */
664     function symbol() public view virtual override returns (string memory) {
665         return _symbol;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-tokenURI}.
670      */
671     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
672         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
673 
674         string memory baseURI = _baseURI();
675         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
676     }
677 
678     /**
679      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
680      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
681      * by default, can be overriden in child contracts.
682      */
683     function _baseURI() internal view virtual returns (string memory) {
684         return "";
685     }
686 
687     /**
688      * @dev See {IERC721-approve}.
689      */
690     function approve(address to, uint256 tokenId) public virtual override {
691         address owner = ERC721.ownerOf(tokenId);
692         require(to != owner, "ERC721: approval to current owner");
693 
694         require(
695             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
696             "ERC721: approve caller is not owner nor approved for all"
697         );
698 
699         _approve(to, tokenId);
700     }
701 
702     /**
703      * @dev See {IERC721-getApproved}.
704      */
705     function getApproved(uint256 tokenId) public view virtual override returns (address) {
706         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
707 
708         return _tokenApprovals[tokenId];
709     }
710 
711     /**
712      * @dev See {IERC721-setApprovalForAll}.
713      */
714     function setApprovalForAll(address operator, bool approved) public virtual override {
715         require(operator != _msgSender(), "ERC721: approve to caller");
716 
717         _operatorApprovals[_msgSender()][operator] = approved;
718         emit ApprovalForAll(_msgSender(), operator, approved);
719     }
720 
721     /**
722      * @dev See {IERC721-isApprovedForAll}.
723      */
724     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
725         return _operatorApprovals[owner][operator];
726     }
727 
728     /**
729      * @dev See {IERC721-transferFrom}.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         //solhint-disable-next-line max-line-length
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738 
739         _transfer(from, to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, "");
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763         _safeTransfer(from, to, tokenId, _data);
764     }
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
771      *
772      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
773      * implement alternative mechanisms to perform token transfer, such as signature-based.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeTransfer(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes memory _data
789     ) internal virtual {
790         _transfer(from, to, tokenId);
791         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
792     }
793 
794     /**
795      * @dev Returns whether `tokenId` exists.
796      *
797      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
798      *
799      * Tokens start existing when they are minted (`_mint`),
800      * and stop existing when they are burned (`_burn`).
801      */
802     function _exists(uint256 tokenId) internal view virtual returns (bool) {
803         return _owners[tokenId] != address(0);
804     }
805 
806     /**
807      * @dev Returns whether `spender` is allowed to manage `tokenId`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
814         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
815         address owner = ERC721.ownerOf(tokenId);
816         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
817     }
818 
819     /**
820      * @dev Safely mints `tokenId` and transfers it to `to`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must not exist.
825      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeMint(address to, uint256 tokenId) internal virtual {
830         _safeMint(to, tokenId, "");
831     }
832 
833     /**
834      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
835      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
836      */
837     function _safeMint(
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) internal virtual {
842         _mint(to, tokenId);
843         require(
844             _checkOnERC721Received(address(0), to, tokenId, _data),
845             "ERC721: transfer to non ERC721Receiver implementer"
846         );
847     }
848 
849     /**
850      * @dev Mints `tokenId` and transfers it to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - `to` cannot be the zero address.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _mint(address to, uint256 tokenId) internal virtual {
862         require(to != address(0), "ERC721: mint to the zero address");
863         require(!_exists(tokenId), "ERC721: token already minted");
864 
865         _beforeTokenTransfer(address(0), to, tokenId);
866 
867         _balances[to] += 1;
868         _owners[tokenId] = to;
869 
870         emit Transfer(address(0), to, tokenId);
871     }
872 
873     /**
874      * @dev Destroys `tokenId`.
875      * The approval is cleared when the token is burned.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _burn(uint256 tokenId) internal virtual {
884         address owner = ERC721.ownerOf(tokenId);
885 
886         _beforeTokenTransfer(owner, address(0), tokenId);
887 
888         // Clear approvals
889         _approve(address(0), tokenId);
890 
891         _balances[owner] -= 1;
892         delete _owners[tokenId];
893 
894         emit Transfer(owner, address(0), tokenId);
895     }
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
900      *
901      * Requirements:
902      *
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _transfer(
909         address from,
910         address to,
911         uint256 tokenId
912     ) internal virtual {
913         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
914         require(to != address(0), "ERC721: transfer to the zero address");
915 
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `to` to operate on `tokenId`
930      *
931      * Emits a {Approval} event.
932      */
933     function _approve(address to, uint256 tokenId) internal virtual {
934         _tokenApprovals[tokenId] = to;
935         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
936     }
937 
938     /**
939      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
940      * The call is not executed if the target address is not a contract.
941      *
942      * @param from address representing the previous owner of the given token ID
943      * @param to target address that will receive the tokens
944      * @param tokenId uint256 ID of the token to be transferred
945      * @param _data bytes optional data to send along with the call
946      * @return bool whether the call correctly returned the expected magic value
947      */
948     function _checkOnERC721Received(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) private returns (bool) {
954         if (to.isContract()) {
955             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
956                 return retval == IERC721Receiver.onERC721Received.selector;
957             } catch (bytes memory reason) {
958                 if (reason.length == 0) {
959                     revert("ERC721: transfer to non ERC721Receiver implementer");
960                 } else {
961                     assembly {
962                         revert(add(32, reason), mload(reason))
963                     }
964                 }
965             }
966         } else {
967             return true;
968         }
969     }
970 
971     /**
972      * @dev Hook that is called before any token transfer. This includes minting
973      * and burning.
974      *
975      * Calling conditions:
976      *
977      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
978      * transferred to `to`.
979      * - When `from` is zero, `tokenId` will be minted for `to`.
980      * - When `to` is zero, ``from``'s `tokenId` will be burned.
981      * - `from` and `to` are never both zero.
982      *
983      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
984      */
985     function _beforeTokenTransfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) internal virtual {}
990 }
991 
992 
993 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
994 
995 
996 
997 
998 
999 /**
1000  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1001  * @dev See https://eips.ethereum.org/EIPS/eip-721
1002  */
1003 interface IERC721Enumerable is IERC721 {
1004     /**
1005      * @dev Returns the total amount of tokens stored by the contract.
1006      */
1007     function totalSupply() external view returns (uint256);
1008 
1009     /**
1010      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1011      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1012      */
1013     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1014 
1015     /**
1016      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1017      * Use along with {totalSupply} to enumerate all tokens.
1018      */
1019     function tokenByIndex(uint256 index) external view returns (uint256);
1020 }
1021 
1022 
1023 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1024 
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1032  * enumerability of all the token ids in the contract as well as all token ids owned by each
1033  * account.
1034  */
1035 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1036     // Mapping from owner to list of owned token IDs
1037     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1038 
1039     // Mapping from token ID to index of the owner tokens list
1040     mapping(uint256 => uint256) private _ownedTokensIndex;
1041 
1042     // Array with all token ids, used for enumeration
1043     uint256[] private _allTokens;
1044 
1045     // Mapping from token id to position in the allTokens array
1046     mapping(uint256 => uint256) private _allTokensIndex;
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1052         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1060         return _ownedTokens[owner][index];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-totalSupply}.
1065      */
1066     function totalSupply() public view virtual override returns (uint256) {
1067         return _allTokens.length;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-tokenByIndex}.
1072      */
1073     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1074         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1075         return _allTokens[index];
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual override {
1098         super._beforeTokenTransfer(from, to, tokenId);
1099 
1100         if (from == address(0)) {
1101             _addTokenToAllTokensEnumeration(tokenId);
1102         } else if (from != to) {
1103             _removeTokenFromOwnerEnumeration(from, tokenId);
1104         }
1105         if (to == address(0)) {
1106             _removeTokenFromAllTokensEnumeration(tokenId);
1107         } else if (to != from) {
1108             _addTokenToOwnerEnumeration(to, tokenId);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1114      * @param to address representing the new owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1116      */
1117     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1118         uint256 length = ERC721.balanceOf(to);
1119         _ownedTokens[to][length] = tokenId;
1120         _ownedTokensIndex[tokenId] = length;
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's token tracking data structures.
1125      * @param tokenId uint256 ID of the token to be added to the tokens list
1126      */
1127     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1128         _allTokensIndex[tokenId] = _allTokens.length;
1129         _allTokens.push(tokenId);
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1134      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1135      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1136      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1137      * @param from address representing the previous owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1139      */
1140     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1141         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1145         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary
1148         if (tokenIndex != lastTokenIndex) {
1149             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1150 
1151             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153         }
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _ownedTokensIndex[tokenId];
1157         delete _ownedTokens[from][lastTokenIndex];
1158     }
1159 
1160     /**
1161      * @dev Private function to remove a token from this extension's token tracking data structures.
1162      * This has O(1) time complexity, but alters the order of the _allTokens array.
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list
1164      */
1165     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1166         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = _allTokens.length - 1;
1170         uint256 tokenIndex = _allTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1173         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1174         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1175         uint256 lastTokenId = _allTokens[lastTokenIndex];
1176 
1177         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _allTokensIndex[tokenId];
1182         _allTokens.pop();
1183     }
1184 }
1185 
1186 
1187 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.2
1188 
1189 
1190 
1191 
1192 
1193 /**
1194  * @dev Contract module which allows children to implement an emergency stop
1195  * mechanism that can be triggered by an authorized account.
1196  *
1197  * This module is used through inheritance. It will make available the
1198  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1199  * the functions of your contract. Note that they will not be pausable by
1200  * simply including this module, only once the modifiers are put in place.
1201  */
1202 abstract contract Pausable is Context {
1203     /**
1204      * @dev Emitted when the pause is triggered by `account`.
1205      */
1206     event Paused(address account);
1207 
1208     /**
1209      * @dev Emitted when the pause is lifted by `account`.
1210      */
1211     event Unpaused(address account);
1212 
1213     bool private _paused;
1214 
1215     /**
1216      * @dev Initializes the contract in unpaused state.
1217      */
1218     constructor() {
1219         _paused = false;
1220     }
1221 
1222     /**
1223      * @dev Returns true if the contract is paused, and false otherwise.
1224      */
1225     function paused() public view virtual returns (bool) {
1226         return _paused;
1227     }
1228 
1229     /**
1230      * @dev Modifier to make a function callable only when the contract is not paused.
1231      *
1232      * Requirements:
1233      *
1234      * - The contract must not be paused.
1235      */
1236     modifier whenNotPaused() {
1237         require(!paused(), "Pausable: paused");
1238         _;
1239     }
1240 
1241     /**
1242      * @dev Modifier to make a function callable only when the contract is paused.
1243      *
1244      * Requirements:
1245      *
1246      * - The contract must be paused.
1247      */
1248     modifier whenPaused() {
1249         require(paused(), "Pausable: not paused");
1250         _;
1251     }
1252 
1253     /**
1254      * @dev Triggers stopped state.
1255      *
1256      * Requirements:
1257      *
1258      * - The contract must not be paused.
1259      */
1260     function _pause() internal virtual whenNotPaused {
1261         _paused = true;
1262         emit Paused(_msgSender());
1263     }
1264 
1265     /**
1266      * @dev Returns to normal state.
1267      *
1268      * Requirements:
1269      *
1270      * - The contract must be paused.
1271      */
1272     function _unpause() internal virtual whenPaused {
1273         _paused = false;
1274         emit Unpaused(_msgSender());
1275     }
1276 }
1277 
1278 
1279 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.2
1280 
1281 
1282 
1283 
1284 
1285 /**
1286  * @dev External interface of AccessControl declared to support ERC165 detection.
1287  */
1288 interface IAccessControl {
1289     /**
1290      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1291      *
1292      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1293      * {RoleAdminChanged} not being emitted signaling this.
1294      *
1295      * _Available since v3.1._
1296      */
1297     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1298 
1299     /**
1300      * @dev Emitted when `account` is granted `role`.
1301      *
1302      * `sender` is the account that originated the contract call, an admin role
1303      * bearer except when using {AccessControl-_setupRole}.
1304      */
1305     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1306 
1307     /**
1308      * @dev Emitted when `account` is revoked `role`.
1309      *
1310      * `sender` is the account that originated the contract call:
1311      *   - if using `revokeRole`, it is the admin role bearer
1312      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1313      */
1314     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1315 
1316     /**
1317      * @dev Returns `true` if `account` has been granted `role`.
1318      */
1319     function hasRole(bytes32 role, address account) external view returns (bool);
1320 
1321     /**
1322      * @dev Returns the admin role that controls `role`. See {grantRole} and
1323      * {revokeRole}.
1324      *
1325      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1326      */
1327     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1328 
1329     /**
1330      * @dev Grants `role` to `account`.
1331      *
1332      * If `account` had not been already granted `role`, emits a {RoleGranted}
1333      * event.
1334      *
1335      * Requirements:
1336      *
1337      * - the caller must have ``role``'s admin role.
1338      */
1339     function grantRole(bytes32 role, address account) external;
1340 
1341     /**
1342      * @dev Revokes `role` from `account`.
1343      *
1344      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1345      *
1346      * Requirements:
1347      *
1348      * - the caller must have ``role``'s admin role.
1349      */
1350     function revokeRole(bytes32 role, address account) external;
1351 
1352     /**
1353      * @dev Revokes `role` from the calling account.
1354      *
1355      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1356      * purpose is to provide a mechanism for accounts to lose their privileges
1357      * if they are compromised (such as when a trusted device is misplaced).
1358      *
1359      * If the calling account had been granted `role`, emits a {RoleRevoked}
1360      * event.
1361      *
1362      * Requirements:
1363      *
1364      * - the caller must be `account`.
1365      */
1366     function renounceRole(bytes32 role, address account) external;
1367 }
1368 
1369 
1370 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.2
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 
1379 /**
1380  * @dev Contract module that allows children to implement role-based access
1381  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1382  * members except through off-chain means by accessing the contract event logs. Some
1383  * applications may benefit from on-chain enumerability, for those cases see
1384  * {AccessControlEnumerable}.
1385  *
1386  * Roles are referred to by their `bytes32` identifier. These should be exposed
1387  * in the external API and be unique. The best way to achieve this is by
1388  * using `public constant` hash digests:
1389  *
1390  * ```
1391  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1392  * ```
1393  *
1394  * Roles can be used to represent a set of permissions. To restrict access to a
1395  * function call, use {hasRole}:
1396  *
1397  * ```
1398  * function foo() public {
1399  *     require(hasRole(MY_ROLE, msg.sender));
1400  *     ...
1401  * }
1402  * ```
1403  *
1404  * Roles can be granted and revoked dynamically via the {grantRole} and
1405  * {revokeRole} functions. Each role has an associated admin role, and only
1406  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1407  *
1408  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1409  * that only accounts with this role will be able to grant or revoke other
1410  * roles. More complex role relationships can be created by using
1411  * {_setRoleAdmin}.
1412  *
1413  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1414  * grant and revoke this role. Extra precautions should be taken to secure
1415  * accounts that have been granted it.
1416  */
1417 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1418     struct RoleData {
1419         mapping(address => bool) members;
1420         bytes32 adminRole;
1421     }
1422 
1423     mapping(bytes32 => RoleData) private _roles;
1424 
1425     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1426 
1427     /**
1428      * @dev Modifier that checks that an account has a specific role. Reverts
1429      * with a standardized message including the required role.
1430      *
1431      * The format of the revert reason is given by the following regular expression:
1432      *
1433      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1434      *
1435      * _Available since v4.1._
1436      */
1437     modifier onlyRole(bytes32 role) {
1438         _checkRole(role, _msgSender());
1439         _;
1440     }
1441 
1442     /**
1443      * @dev See {IERC165-supportsInterface}.
1444      */
1445     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1446         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1447     }
1448 
1449     /**
1450      * @dev Returns `true` if `account` has been granted `role`.
1451      */
1452     function hasRole(bytes32 role, address account) public view override returns (bool) {
1453         return _roles[role].members[account];
1454     }
1455 
1456     /**
1457      * @dev Revert with a standard message if `account` is missing `role`.
1458      *
1459      * The format of the revert reason is given by the following regular expression:
1460      *
1461      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1462      */
1463     function _checkRole(bytes32 role, address account) internal view {
1464         if (!hasRole(role, account)) {
1465             revert(
1466                 string(
1467                     abi.encodePacked(
1468                         "AccessControl: account ",
1469                         Strings.toHexString(uint160(account), 20),
1470                         " is missing role ",
1471                         Strings.toHexString(uint256(role), 32)
1472                     )
1473                 )
1474             );
1475         }
1476     }
1477 
1478     /**
1479      * @dev Returns the admin role that controls `role`. See {grantRole} and
1480      * {revokeRole}.
1481      *
1482      * To change a role's admin, use {_setRoleAdmin}.
1483      */
1484     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1485         return _roles[role].adminRole;
1486     }
1487 
1488     /**
1489      * @dev Grants `role` to `account`.
1490      *
1491      * If `account` had not been already granted `role`, emits a {RoleGranted}
1492      * event.
1493      *
1494      * Requirements:
1495      *
1496      * - the caller must have ``role``'s admin role.
1497      */
1498     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1499         _grantRole(role, account);
1500     }
1501 
1502     /**
1503      * @dev Revokes `role` from `account`.
1504      *
1505      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1506      *
1507      * Requirements:
1508      *
1509      * - the caller must have ``role``'s admin role.
1510      */
1511     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1512         _revokeRole(role, account);
1513     }
1514 
1515     /**
1516      * @dev Revokes `role` from the calling account.
1517      *
1518      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1519      * purpose is to provide a mechanism for accounts to lose their privileges
1520      * if they are compromised (such as when a trusted device is misplaced).
1521      *
1522      * If the calling account had been granted `role`, emits a {RoleRevoked}
1523      * event.
1524      *
1525      * Requirements:
1526      *
1527      * - the caller must be `account`.
1528      */
1529     function renounceRole(bytes32 role, address account) public virtual override {
1530         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1531 
1532         _revokeRole(role, account);
1533     }
1534 
1535     /**
1536      * @dev Grants `role` to `account`.
1537      *
1538      * If `account` had not been already granted `role`, emits a {RoleGranted}
1539      * event. Note that unlike {grantRole}, this function doesn't perform any
1540      * checks on the calling account.
1541      *
1542      * [WARNING]
1543      * ====
1544      * This function should only be called from the constructor when setting
1545      * up the initial roles for the system.
1546      *
1547      * Using this function in any other way is effectively circumventing the admin
1548      * system imposed by {AccessControl}.
1549      * ====
1550      */
1551     function _setupRole(bytes32 role, address account) internal virtual {
1552         _grantRole(role, account);
1553     }
1554 
1555     /**
1556      * @dev Sets `adminRole` as ``role``'s admin role.
1557      *
1558      * Emits a {RoleAdminChanged} event.
1559      */
1560     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1561         bytes32 previousAdminRole = getRoleAdmin(role);
1562         _roles[role].adminRole = adminRole;
1563         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1564     }
1565 
1566     function _grantRole(bytes32 role, address account) private {
1567         if (!hasRole(role, account)) {
1568             _roles[role].members[account] = true;
1569             emit RoleGranted(role, account, _msgSender());
1570         }
1571     }
1572 
1573     function _revokeRole(bytes32 role, address account) private {
1574         if (hasRole(role, account)) {
1575             _roles[role].members[account] = false;
1576             emit RoleRevoked(role, account, _msgSender());
1577         }
1578     }
1579 }
1580 
1581 
1582 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.3.2
1583 
1584 
1585 
1586 
1587 
1588 
1589 /**
1590  * @title ERC721 Burnable Token
1591  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1592  */
1593 abstract contract ERC721Burnable is Context, ERC721 {
1594     /**
1595      * @dev Burns `tokenId`. See {ERC721-_burn}.
1596      *
1597      * Requirements:
1598      *
1599      * - The caller must own `tokenId` or be an approved operator.
1600      */
1601     function burn(uint256 tokenId) public virtual {
1602         //solhint-disable-next-line max-line-length
1603         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1604         _burn(tokenId);
1605     }
1606 }
1607 
1608 
1609 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1610 
1611 
1612 
1613 
1614 
1615 /**
1616  * @title Counters
1617  * @author Matt Condon (@shrugs)
1618  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1619  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1620  *
1621  * Include with `using Counters for Counters.Counter;`
1622  */
1623 library Counters {
1624     struct Counter {
1625         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1626         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1627         // this feature: see https://github.com/ethereum/solidity/issues/4637
1628         uint256 _value; // default: 0
1629     }
1630 
1631     function current(Counter storage counter) internal view returns (uint256) {
1632         return counter._value;
1633     }
1634 
1635     function increment(Counter storage counter) internal {
1636         unchecked {
1637             counter._value += 1;
1638         }
1639     }
1640 
1641     function decrement(Counter storage counter) internal {
1642         uint256 value = counter._value;
1643         require(value > 0, "Counter: decrement overflow");
1644         unchecked {
1645             counter._value = value - 1;
1646         }
1647     }
1648 
1649     function reset(Counter storage counter) internal {
1650         counter._value = 0;
1651     }
1652 }
1653 
1654 
1655 // File contracts/CactusCrewCard.sol
1656 
1657 
1658 
1659 
1660 // Made with <3 by sqrt(-1)
1661 
1662 
1663 
1664 
1665 
1666 
1667 contract CactusCrewCard is ERC721, ERC721Enumerable, Pausable, AccessControl, ERC721Burnable {
1668     using Counters for Counters.Counter;
1669 
1670     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1671     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1672     Counters.Counter private _tokenIdCounter;
1673 
1674     string baseURI;
1675 
1676     constructor() ERC721("CactusCrewCard", "CACTUSCREWCARD") {
1677         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1678         _setupRole(PAUSER_ROLE, msg.sender);
1679         _setupRole(MINTER_ROLE, msg.sender);
1680     }
1681 
1682     function whitelist(address[] memory ads) public onlyRole(DEFAULT_ADMIN_ROLE) {
1683         for (uint256 i = 0; i < ads.length; i++) {
1684             grantRole(MINTER_ROLE, ads[i]);
1685         }
1686     }
1687 
1688     function setBaseURI(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
1689         baseURI = uri;
1690     }
1691 
1692     function _baseURI() internal view override returns (string memory) {
1693         return baseURI;
1694     }
1695 
1696     function pause() public onlyRole(PAUSER_ROLE) {
1697         _pause();
1698     }
1699 
1700     function unpause() public onlyRole(PAUSER_ROLE) {
1701         _unpause();
1702     }
1703 
1704     function safeMint(address to) public onlyRole(MINTER_ROLE) {
1705         _safeMint(to, _tokenIdCounter.current());
1706         _tokenIdCounter.increment();
1707         renounceRole(MINTER_ROLE, msg.sender);
1708     }
1709 
1710     function _beforeTokenTransfer(
1711         address from,
1712         address to,
1713         uint256 tokenId
1714     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1715         super._beforeTokenTransfer(from, to, tokenId);
1716     }
1717 
1718     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, AccessControl) returns (bool) {
1719         return super.supportsInterface(interfaceId);
1720     }
1721 }