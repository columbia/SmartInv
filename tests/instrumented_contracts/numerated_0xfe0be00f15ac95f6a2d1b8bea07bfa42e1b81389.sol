1 // Sources flattened with hardhat v2.6.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.2;
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
1187 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1188 
1189 
1190 
1191 
1192 
1193 /**
1194  * @dev Contract module which provides a basic access control mechanism, where
1195  * there is an account (an owner) that can be granted exclusive access to
1196  * specific functions.
1197  *
1198  * By default, the owner account will be the one that deploys the contract. This
1199  * can later be changed with {transferOwnership}.
1200  *
1201  * This module is used through inheritance. It will make available the modifier
1202  * `onlyOwner`, which can be applied to your functions to restrict their use to
1203  * the owner.
1204  */
1205 abstract contract Ownable is Context {
1206     address private _owner;
1207 
1208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1209 
1210     /**
1211      * @dev Initializes the contract setting the deployer as the initial owner.
1212      */
1213     constructor() {
1214         _setOwner(_msgSender());
1215     }
1216 
1217     /**
1218      * @dev Returns the address of the current owner.
1219      */
1220     function owner() public view virtual returns (address) {
1221         return _owner;
1222     }
1223 
1224     /**
1225      * @dev Throws if called by any account other than the owner.
1226      */
1227     modifier onlyOwner() {
1228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1229         _;
1230     }
1231 
1232     /**
1233      * @dev Leaves the contract without owner. It will not be possible to call
1234      * `onlyOwner` functions anymore. Can only be called by the current owner.
1235      *
1236      * NOTE: Renouncing ownership will leave the contract without an owner,
1237      * thereby removing any functionality that is only available to the owner.
1238      */
1239     function renounceOwnership() public virtual onlyOwner {
1240         _setOwner(address(0));
1241     }
1242 
1243     /**
1244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1245      * Can only be called by the current owner.
1246      */
1247     function transferOwnership(address newOwner) public virtual onlyOwner {
1248         require(newOwner != address(0), "Ownable: new owner is the zero address");
1249         _setOwner(newOwner);
1250     }
1251 
1252     function _setOwner(address newOwner) private {
1253         address oldOwner = _owner;
1254         _owner = newOwner;
1255         emit OwnershipTransferred(oldOwner, newOwner);
1256     }
1257 }
1258 
1259 
1260 // File contracts/WastelandCactusCrew.sol
1261 
1262 
1263 abstract contract CrewCard {
1264   function ownerOf(uint256 tokenId) public virtual view returns (address);
1265 }
1266 
1267 contract WastelandCactusCrew is ERC721, ERC721Enumerable, Ownable {
1268 
1269     CrewCard private cc = CrewCard(0x25A3273f1b1F468845D08623FBe4b0885Fc12cf0);
1270     string public baseURL;
1271     string public provenance;
1272     bool public f1 = false;
1273     bool public f2 = false;
1274     bool public f3 = false;
1275     bool public f4 = false;
1276     uint public price = 60000000000000000; // 0.06 ETH 
1277     uint public maxSupply = 8500;
1278     uint public maxPerTransaction = 4;
1279     mapping(address => uint) m3;
1280     mapping(uint => uint) m4;
1281     mapping(address => uint) m1;
1282     mapping(address => uint) m2;
1283     uint public ltc = 0;
1284     uint public ef = 0;
1285     uint public totalCrewClaimed = 0;
1286     address private rl = 0x6e6093a650dcABc96eE4C40C02ba5788B1267160;
1287 
1288     constructor() ERC721("WastelandCactusCrew", "WLCC") {
1289     }
1290 
1291     function setltc(uint n) public onlyOwner {
1292         ltc = n;
1293     }
1294 
1295     function ff1() public onlyOwner {
1296         f1 = !f1;
1297     }
1298 
1299     function ff2() public onlyOwner {
1300         f2 = !f2;
1301     }
1302 
1303     function ff3() public onlyOwner {
1304         f3 = !f3;
1305     }
1306 
1307     function ff4() public onlyOwner {
1308         f4 = !f4;
1309     }
1310 
1311     function setbaseuri(string memory uri) public onlyOwner {
1312         baseURL = uri;
1313     }
1314 
1315     function _baseURI() internal view override returns (string memory) {
1316         return baseURL;
1317     }
1318 
1319     function setprovhash(string memory provenanceHash) public onlyOwner {
1320         provenance = provenanceHash;
1321     }
1322     
1323     function addsinglewhitelist(address[] memory addresses) public onlyOwner {
1324         for(uint i = 0; i < addresses.length; i++) {
1325             m3[addresses[i]] = 1;
1326         }
1327     }
1328 
1329     function adddoublewhitelist(address[] memory addresses) public onlyOwner {
1330         for(uint i = 0; i < addresses.length; i++) {
1331             m3[addresses[i]] = 2;
1332         }
1333     }
1334 
1335     function checkm1(address a) public view returns (uint) {
1336         return m1[a];
1337     }
1338 
1339     function checkm2(address a) public view returns (uint) {
1340         return m2[a];
1341     }
1342 
1343     function checkm3(address a) public view returns (uint) {
1344         return m3[a];
1345     }
1346 
1347     function checkm4(uint n) public view returns (uint) {
1348         return m4[n];
1349     }
1350     
1351     function airdrop(address to) public onlyOwner {
1352         _safeMint(to, totalSupply());
1353     }
1354 
1355     function devreserve(uint n) public onlyOwner {
1356         for(uint i = 0; i < n; i++) {
1357             _mint(msg.sender, totalSupply());
1358         }
1359     }
1360 
1361     function executef1b(uint n) public payable {
1362         require(f1);
1363         uint t = m3[msg.sender];
1364         require(t > 0 && n > 0 && n <= t);
1365         require(msg.value >= price * n);
1366 
1367         for(uint i = 0; i < n; i++) {
1368             _mint(msg.sender, totalSupply());
1369         }
1370 
1371         m3[msg.sender] = (t - n);
1372     }
1373 
1374     function executef1a(uint t, uint n) public payable {
1375         require(f1);
1376         require(cc.ownerOf(t) == msg.sender);
1377         uint b = m4[t];
1378         require(b > 0 && n > 0 && n <= b);
1379         require(msg.value >= price * n);
1380     
1381         for(uint i = 0; i < n; i++) {
1382             _mint(msg.sender, totalSupply());
1383         } 
1384         
1385         m4[t] = (b - n);
1386     }
1387 
1388     function executef2(uint n) public { // set ltc before f2
1389         require(f2 && n > 0 && n <= 4);
1390         if(ef >= ltc) {
1391             m2[msg.sender] = n;
1392         } else {
1393             m1[msg.sender] = n;
1394             ef = ef + n;
1395         }
1396     }
1397 
1398     function executef3() public payable {
1399         require(f3);
1400         uint b = m1[msg.sender];
1401         require(totalSupply() + b <= maxSupply);
1402         require(msg.value >= price * b);
1403 
1404         for(uint i = 0; i < b; i++) {
1405             _mint(msg.sender, totalSupply());
1406         }
1407     }
1408 
1409     function executef4(uint n) public payable {
1410         require(f4);
1411         require(n <= maxPerTransaction);
1412         require(totalSupply() + n <= maxSupply);
1413         require(msg.value >= price * n);
1414 
1415         for(uint i = 0; i < n; i++) {
1416             _mint(msg.sender, totalSupply());
1417         }
1418     }   
1419 
1420     function executef5() public payable {
1421         require(f3);
1422         uint b = m2[msg.sender];
1423         require(totalSupply() + b <= maxSupply);
1424         require(msg.value >= price * b);
1425 
1426         for(uint i = 0; i < b; i++) {
1427             _mint(msg.sender, totalSupply());
1428         }
1429     }
1430 
1431     function withdraw() public onlyOwner {
1432         uint b = address(this).balance;        
1433         payable(rl).transfer(b / 4);
1434         payable(msg.sender).transfer(b * 3 / 4);
1435     }
1436 
1437     // The following functions are overrides required by Solidity.
1438     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1439         internal
1440         override(ERC721, ERC721Enumerable)
1441     {
1442         super._beforeTokenTransfer(from, to, tokenId);
1443     }
1444 
1445     function supportsInterface(bytes4 interfaceId)
1446         public
1447         view
1448         override(ERC721, ERC721Enumerable)
1449         returns (bool)
1450     {
1451         return super.supportsInterface(interfaceId);
1452     }
1453 }