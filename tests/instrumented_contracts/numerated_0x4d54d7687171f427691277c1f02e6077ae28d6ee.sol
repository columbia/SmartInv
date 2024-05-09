1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Address.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      */
96     function isContract(address account) internal view returns (bool) {
97         // This method relies on extcodesize, which returns 0 for contracts in
98         // construction, since the code is only stored at the end of the
99         // constructor execution.
100 
101         uint256 size;
102         assembly {
103             size := extcodesize(account)
104         }
105         return size > 0;
106     }
107 
108     /**
109      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
110      * `recipient`, forwarding all available gas and reverting on errors.
111      *
112      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
113      * of certain opcodes, possibly making contracts go over the 2300 gas limit
114      * imposed by `transfer`, making them unable to receive funds via
115      * `transfer`. {sendValue} removes this limitation.
116      *
117      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
118      *
119      * IMPORTANT: because control is transferred to `recipient`, care must be
120      * taken to not create reentrancy vulnerabilities. Consider using
121      * {ReentrancyGuard} or the
122      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
123      */
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126 
127         (bool success, ) = recipient.call{value: amount}("");
128         require(success, "Address: unable to send value, recipient may have reverted");
129     }
130 
131     /**
132      * @dev Performs a Solidity function call using a low level `call`. A
133      * plain `call` is an unsafe replacement for a function call: use this
134      * function instead.
135      *
136      * If `target` reverts with a revert reason, it is bubbled up by this
137      * function (like regular Solidity function calls).
138      *
139      * Returns the raw returned data. To convert to the expected return value,
140      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
141      *
142      * Requirements:
143      *
144      * - `target` must be a contract.
145      * - calling `target` with `data` must not revert.
146      *
147      * _Available since v3.1._
148      */
149     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
150         return functionCall(target, data, "Address: low-level call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
155      * `errorMessage` as a fallback revert reason when `target` reverts.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, 0, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but also transferring `value` wei to `target`.
170      *
171      * Requirements:
172      *
173      * - the calling contract must have an ETH balance of at least `value`.
174      * - the called Solidity function must be `payable`.
175      *
176      * _Available since v3.1._
177      */
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
188      * with `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.call{value: value}(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a static call.
208      *
209      * _Available since v3.3._
210      */
211     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
212         return functionStaticCall(target, data, "Address: low-level static call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal view returns (bytes memory) {
226         require(isContract(target), "Address: static call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a delegate call.
235      *
236      * _Available since v3.4._
237      */
238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(isContract(target), "Address: delegate call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.delegatecall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
261      * revert reason using the provided one.
262      *
263      * _Available since v4.3._
264      */
265     function verifyCallResult(
266         bool success,
267         bytes memory returndata,
268         string memory errorMessage
269     ) internal pure returns (bytes memory) {
270         if (success) {
271             return returndata;
272         } else {
273             // Look for revert reason and bubble it up if present
274             if (returndata.length > 0) {
275                 // The easiest way to bubble the revert reason is using memory via assembly
276 
277                 assembly {
278                     let returndata_size := mload(returndata)
279                     revert(add(32, returndata), returndata_size)
280                 }
281             } else {
282                 revert(errorMessage);
283             }
284         }
285     }
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
289 
290 
291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Interface of the ERC165 standard, as defined in the
327  * https://eips.ethereum.org/EIPS/eip-165[EIP].
328  *
329  * Implementers can declare support of contract interfaces, which can then be
330  * queried by others ({ERC165Checker}).
331  *
332  * For an implementation, see {ERC165}.
333  */
334 interface IERC165 {
335     /**
336      * @dev Returns true if this contract implements the interface defined by
337      * `interfaceId`. See the corresponding
338      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
339      * to learn more about how these ids are created.
340      *
341      * This function call must use less than 30 000 gas.
342      */
343     function supportsInterface(bytes4 interfaceId) external view returns (bool);
344 }
345 
346 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Implementation of the {IERC165} interface.
356  *
357  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
358  * for the additional interface id that will be supported. For example:
359  *
360  * ```solidity
361  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
362  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
363  * }
364  * ```
365  *
366  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
367  */
368 abstract contract ERC165 is IERC165 {
369     /**
370      * @dev See {IERC165-supportsInterface}.
371      */
372     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
373         return interfaceId == type(IERC165).interfaceId;
374     }
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @dev Required interface of an ERC721 compliant contract.
387  */
388 interface IERC721 is IERC165 {
389     /**
390      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
391      */
392     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
396      */
397     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
401      */
402     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
403 
404     /**
405      * @dev Returns the number of tokens in ``owner``'s account.
406      */
407     function balanceOf(address owner) external view returns (uint256 balance);
408 
409     /**
410      * @dev Returns the owner of the `tokenId` token.
411      *
412      * Requirements:
413      *
414      * - `tokenId` must exist.
415      */
416     function ownerOf(uint256 tokenId) external view returns (address owner);
417 
418     /**
419      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
420      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `tokenId` token must exist and be owned by `from`.
427      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
429      *
430      * Emits a {Transfer} event.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId
436     ) external;
437 
438     /**
439      * @dev Transfers `tokenId` token from `from` to `to`.
440      *
441      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must be owned by `from`.
448      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
449      *
450      * Emits a {Transfer} event.
451      */
452     function transferFrom(
453         address from,
454         address to,
455         uint256 tokenId
456     ) external;
457 
458     /**
459      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
460      * The approval is cleared when the token is transferred.
461      *
462      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
463      *
464      * Requirements:
465      *
466      * - The caller must own the token or be an approved operator.
467      * - `tokenId` must exist.
468      *
469      * Emits an {Approval} event.
470      */
471     function approve(address to, uint256 tokenId) external;
472 
473     /**
474      * @dev Returns the account approved for `tokenId` token.
475      *
476      * Requirements:
477      *
478      * - `tokenId` must exist.
479      */
480     function getApproved(uint256 tokenId) external view returns (address operator);
481 
482     /**
483      * @dev Approve or remove `operator` as an operator for the caller.
484      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
485      *
486      * Requirements:
487      *
488      * - The `operator` cannot be the caller.
489      *
490      * Emits an {ApprovalForAll} event.
491      */
492     function setApprovalForAll(address operator, bool _approved) external;
493 
494     /**
495      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
496      *
497      * See {setApprovalForAll}
498      */
499     function isApprovedForAll(address owner, address operator) external view returns (bool);
500 
501     /**
502      * @dev Safely transfers `tokenId` token from `from` to `to`.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must exist and be owned by `from`.
509      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
510      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId,
518         bytes calldata data
519     ) external;
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
532  * @dev See https://eips.ethereum.org/EIPS/eip-721
533  */
534 interface IERC721Metadata is IERC721 {
535     /**
536      * @dev Returns the token collection name.
537      */
538     function name() external view returns (string memory);
539 
540     /**
541      * @dev Returns the token collection symbol.
542      */
543     function symbol() external view returns (string memory);
544 
545     /**
546      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
547      */
548     function tokenURI(uint256 tokenId) external view returns (string memory);
549 }
550 
551 // File: @openzeppelin/contracts/utils/Context.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Provides information about the current execution context, including the
560  * sender of the transaction and its data. While these are generally available
561  * via msg.sender and msg.data, they should not be accessed in such a direct
562  * manner, since when dealing with meta-transactions the account sending and
563  * paying for execution may not be the actual sender (as far as an application
564  * is concerned).
565  *
566  * This contract is only required for intermediate, library-like contracts.
567  */
568 abstract contract Context {
569     function _msgSender() internal view virtual returns (address) {
570         return msg.sender;
571     }
572 
573     function _msgData() internal view virtual returns (bytes calldata) {
574         return msg.data;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
582 
583 pragma solidity ^0.8.0;
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
715         _setApprovalForAll(_msgSender(), operator, approved);
716     }
717 
718     /**
719      * @dev See {IERC721-isApprovedForAll}.
720      */
721     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
722         return _operatorApprovals[owner][operator];
723     }
724 
725     /**
726      * @dev See {IERC721-transferFrom}.
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public virtual override {
733         //solhint-disable-next-line max-line-length
734         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
735 
736         _transfer(from, to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         safeTransferFrom(from, to, tokenId, "");
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes memory _data
758     ) public virtual override {
759         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
760         _safeTransfer(from, to, tokenId, _data);
761     }
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
765      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
766      *
767      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
768      *
769      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
770      * implement alternative mechanisms to perform token transfer, such as signature-based.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must exist and be owned by `from`.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _safeTransfer(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) internal virtual {
787         _transfer(from, to, tokenId);
788         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
789     }
790 
791     /**
792      * @dev Returns whether `tokenId` exists.
793      *
794      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
795      *
796      * Tokens start existing when they are minted (`_mint`),
797      * and stop existing when they are burned (`_burn`).
798      */
799     function _exists(uint256 tokenId) internal view virtual returns (bool) {
800         return _owners[tokenId] != address(0);
801     }
802 
803     /**
804      * @dev Returns whether `spender` is allowed to manage `tokenId`.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
811         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
812         address owner = ERC721.ownerOf(tokenId);
813         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
814     }
815 
816     /**
817      * @dev Safely mints `tokenId` and transfers it to `to`.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must not exist.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _safeMint(address to, uint256 tokenId) internal virtual {
827         _safeMint(to, tokenId, "");
828     }
829 
830     /**
831      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
832      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
833      */
834     function _safeMint(
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) internal virtual {
839         _mint(to, tokenId);
840         require(
841             _checkOnERC721Received(address(0), to, tokenId, _data),
842             "ERC721: transfer to non ERC721Receiver implementer"
843         );
844     }
845 
846     /**
847      * @dev Mints `tokenId` and transfers it to `to`.
848      *
849      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
850      *
851      * Requirements:
852      *
853      * - `tokenId` must not exist.
854      * - `to` cannot be the zero address.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _mint(address to, uint256 tokenId) internal virtual {
859         require(to != address(0), "ERC721: mint to the zero address");
860         require(!_exists(tokenId), "ERC721: token already minted");
861 
862         _beforeTokenTransfer(address(0), to, tokenId);
863 
864         _balances[to] += 1;
865         _owners[tokenId] = to;
866 
867         emit Transfer(address(0), to, tokenId);
868     }
869 
870     /**
871      * @dev Destroys `tokenId`.
872      * The approval is cleared when the token is burned.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _burn(uint256 tokenId) internal virtual {
881         address owner = ERC721.ownerOf(tokenId);
882 
883         _beforeTokenTransfer(owner, address(0), tokenId);
884 
885         // Clear approvals
886         _approve(address(0), tokenId);
887 
888         _balances[owner] -= 1;
889         delete _owners[tokenId];
890 
891         emit Transfer(owner, address(0), tokenId);
892     }
893 
894     /**
895      * @dev Transfers `tokenId` from `from` to `to`.
896      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _transfer(
906         address from,
907         address to,
908         uint256 tokenId
909     ) internal virtual {
910         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
911         require(to != address(0), "ERC721: transfer to the zero address");
912 
913         _beforeTokenTransfer(from, to, tokenId);
914 
915         // Clear approvals from the previous owner
916         _approve(address(0), tokenId);
917 
918         _balances[from] -= 1;
919         _balances[to] += 1;
920         _owners[tokenId] = to;
921 
922         emit Transfer(from, to, tokenId);
923     }
924 
925     /**
926      * @dev Approve `to` to operate on `tokenId`
927      *
928      * Emits a {Approval} event.
929      */
930     function _approve(address to, uint256 tokenId) internal virtual {
931         _tokenApprovals[tokenId] = to;
932         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
933     }
934 
935     /**
936      * @dev Approve `operator` to operate on all of `owner` tokens
937      *
938      * Emits a {ApprovalForAll} event.
939      */
940     function _setApprovalForAll(
941         address owner,
942         address operator,
943         bool approved
944     ) internal virtual {
945         require(owner != operator, "ERC721: approve to caller");
946         _operatorApprovals[owner][operator] = approved;
947         emit ApprovalForAll(owner, operator, approved);
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
952      * The call is not executed if the target address is not a contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         if (to.isContract()) {
967             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
968                 return retval == IERC721Receiver.onERC721Received.selector;
969             } catch (bytes memory reason) {
970                 if (reason.length == 0) {
971                     revert("ERC721: transfer to non ERC721Receiver implementer");
972                 } else {
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {}
1002 }
1003 
1004 // File: @openzeppelin/contracts/access/Ownable.sol
1005 
1006 
1007 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 
1012 /**
1013  * @dev Contract module which provides a basic access control mechanism, where
1014  * there is an account (an owner) that can be granted exclusive access to
1015  * specific functions.
1016  *
1017  * By default, the owner account will be the one that deploys the contract. This
1018  * can later be changed with {transferOwnership}.
1019  *
1020  * This module is used through inheritance. It will make available the modifier
1021  * `onlyOwner`, which can be applied to your functions to restrict their use to
1022  * the owner.
1023  */
1024 abstract contract Ownable is Context {
1025     address private _owner;
1026 
1027     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1028 
1029     /**
1030      * @dev Initializes the contract setting the deployer as the initial owner.
1031      */
1032     constructor() {
1033         _transferOwnership(_msgSender());
1034     }
1035 
1036     /**
1037      * @dev Returns the address of the current owner.
1038      */
1039     function owner() public view virtual returns (address) {
1040         return _owner;
1041     }
1042 
1043     /**
1044      * @dev Throws if called by any account other than the owner.
1045      */
1046     modifier onlyOwner() {
1047         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1048         _;
1049     }
1050 
1051     /**
1052      * @dev Leaves the contract without owner. It will not be possible to call
1053      * `onlyOwner` functions anymore. Can only be called by the current owner.
1054      *
1055      * NOTE: Renouncing ownership will leave the contract without an owner,
1056      * thereby removing any functionality that is only available to the owner.
1057      */
1058     function renounceOwnership() public virtual onlyOwner {
1059         _transferOwnership(address(0));
1060     }
1061 
1062     /**
1063      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1064      * Can only be called by the current owner.
1065      */
1066     function transferOwnership(address newOwner) public virtual onlyOwner {
1067         require(newOwner != address(0), "Ownable: new owner is the zero address");
1068         _transferOwnership(newOwner);
1069     }
1070 
1071     /**
1072      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1073      * Internal function without access restriction.
1074      */
1075     function _transferOwnership(address newOwner) internal virtual {
1076         address oldOwner = _owner;
1077         _owner = newOwner;
1078         emit OwnershipTransferred(oldOwner, newOwner);
1079     }
1080 }
1081 
1082 // File: contracts/GirlVibes.sol
1083 
1084 
1085 pragma solidity >=0.8.0;
1086 
1087 
1088 
1089 contract OwnableDelegateProxy {}
1090 
1091 contract ProxyRegistry {
1092     mapping(address => OwnableDelegateProxy) public proxies;
1093 }
1094 
1095 contract GirlVibes is ERC721, Ownable
1096 {
1097     /** Let use use sath math functions on uint256 */
1098     using Strings for uint256;
1099 
1100     uint256 public price = 0.05 ether;  // Base price for each mint.
1101     uint256 public totalSupply = 0;
1102     uint256 public maxSupply = 10000;  // Maximum that can be minted
1103     uint256 public maxMintAmount = 10;  // How many can be minted in a single transaction.
1104     uint256 public giftSupply = 200;  // Rservered for give aways / team
1105     uint256 public giftTotal = 0;  // Track how many have been gifted already.
1106 
1107     // Metadata
1108     string public baseExtension = ".json";
1109     string public notRevealedURI;  // Path to hidden teaser metadata.
1110     string private baseURI;  // Private because it's a secret until revealed.
1111 
1112     // Allow List
1113     bool public allowListOnly = true; // Whether only allow list addresses can mint or not.
1114     bool public mintingActive = true;  // If minting is active.
1115     bool public revealed = false;  // Have we revealed the real metadata yet.
1116 
1117     mapping(address => bool) private allowList;  // Mapping of all allow list addressed true = On allow list.
1118     address proxyRegistryAddress;
1119 
1120     // Events
1121     event Minted(address sender, uint256 count);
1122 
1123 
1124     constructor(address _proxyRegistryAddress) 
1125         ERC721("#GirlVibes - Beach", "GVB")
1126     {
1127         proxyRegistryAddress = _proxyRegistryAddress;
1128         // Set the allow list 
1129         // Mint at least one for ourselves so it shows up on OpenSea
1130         teamMint(1);
1131     }
1132 
1133     /** Override isApprovedForAll to user's OpenSea proxy accounts to enable gas-less listing. */
1134     function isApprovedForAll(address owner, address operator) override public view returns (bool)
1135     {
1136         // OpenSea proxy contract for easy trading.
1137         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1138         if (address(proxyRegistry.proxies(owner)) == operator) {
1139             return true;
1140         }
1141 
1142         return super.isApprovedForAll(owner, operator);
1143     }
1144 
1145     /** Returns the URI metadata for this token ID. */
1146     function tokenURI(uint256 tokenId)
1147 		public
1148 		view
1149 		virtual
1150 		override
1151 		returns (string memory)
1152 	{
1153 		require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1154 		
1155         // If not revealed yet just return the not revealed URI
1156         if (revealed == false) 
1157         {
1158             return notRevealedURI;
1159         }
1160 		
1161         string memory currentBaseURI = _baseURI();
1162         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1163 	}
1164 
1165     function _baseURI() internal view virtual override returns (string memory)
1166     {
1167         return baseURI;
1168     }
1169 
1170     /** Check if the address is on the allow */
1171     function isAllowListed(address _addr) public view returns (bool)
1172     {
1173         return allowList[_addr];
1174     }
1175 
1176     /** Add / Remove addresses to the allow */
1177     function setAllowList(address[] memory _addressList, bool _onAllowList) public onlyOwner {
1178         for (uint256 i = 0; i < _addressList.length; i++) {
1179             require(_addressList[i] != address(0), 'Not allowed to add null address');
1180             // Set the address in the allow list
1181             allowList[_addressList[i]] = _onAllowList;
1182         }
1183     }
1184 
1185     // We can do this on the client save some gas on deploy.
1186     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1187         uint256 ownerCount = balanceOf(_owner);
1188         uint256[] memory tokenIds = new uint256[](ownerCount);
1189         uint256 current = 1;
1190         uint256 ownedIndex = 0;
1191 
1192         while (ownedIndex < ownerCount && current <= maxSupply) {
1193             address ownerAt = ownerOf(current);
1194             if (ownerAt == _owner) {
1195                 // This is ours
1196                 tokenIds[ownedIndex] = current;
1197                 ownedIndex++;
1198             }
1199             current++;
1200         }
1201 
1202        return tokenIds;
1203     }
1204 
1205     modifier canMint(uint256 _amount) {
1206         require(_amount > 0, 'Must mint at least one.');
1207         require(totalSupply + giftSupply + _amount <= maxSupply, 'Purchase would exceed available supply.');
1208         _;
1209     }
1210 
1211     /** Mints and transfers the number of NFT's to the sender. */
1212     function mint(uint256 _amount) public payable canMint(_amount) {
1213         require(mintingActive, 'Minting is not currently active');
1214 
1215         if (!allowListOnly) {
1216             require(_amount <= maxMintAmount, 'Cannot go over the purchase limit.');
1217         }
1218         require(price * _amount <= msg.value, 'Insufficient ETH for quantity');
1219 
1220         address sender = _msgSender();
1221 
1222         // Check if allow list only.
1223         if (allowListOnly == true) {
1224             require(isAllowListed(sender), 'You are not on the allow list');
1225         }
1226 
1227         // Finally mint to the sender.
1228         _mintTo(sender, _amount);
1229 
1230         emit Minted(sender, _amount);
1231     }
1232 
1233     /** Gift NFT supply to addresses. */
1234     function gift(address[] calldata _to) external onlyOwner
1235     {
1236         require(totalSupply + _to.length < maxSupply, 'Not enough left to gift');
1237         require(giftTotal + _to.length <= giftSupply, 'Reached max gifting allowance.');
1238 
1239         for (uint256 i = 0; i < _to.length; i++) {
1240             giftTotal += 1;
1241             // Give 1 to the address.
1242             _mintTo(_to[i], 1);
1243         }
1244     }
1245 
1246     /** Gift NFT supply to team. */
1247    function teamMint(uint256 _amount) public canMint(_amount) onlyOwner
1248     {
1249         // Mint for the team.
1250         _mintTo(owner(), _amount);
1251     }
1252 
1253     function _mintTo(address _to, uint256 _mintAmount) internal {
1254         for (uint256 i = 0; i < _mintAmount; i++) {
1255             // Increase supply by 1
1256             totalSupply += 1;
1257             // Mint to the address.
1258             _safeMint(_to, totalSupply);
1259         }
1260     }
1261 
1262     /** Update the price of the NFT as a failsafe. */
1263     function setPrice(uint256 _price) external onlyOwner
1264     {
1265         price = _price;
1266     }
1267 
1268     /** Update the base URI only if we have to */
1269     function setBaseURI(string memory _baseUri) external onlyOwner
1270     {
1271         baseURI = _baseUri;
1272     }
1273 
1274     /** Get the current base URI */
1275     function getBaseURI() external view onlyOwner returns (string memory)
1276     {
1277         return baseURI;
1278     }
1279 
1280     /** Update the not revealed URI only if we have to */
1281     function setNotRevealedURI(string memory _notRevealedUri) external onlyOwner
1282     {
1283         notRevealedURI = _notRevealedUri;
1284     }
1285 
1286     function setBaseURIExtension(string memory _ext) external onlyOwner
1287     {
1288         baseExtension = _ext;
1289     }
1290 
1291     /** 
1292     Reveal the NFT's this will make the real metadata URI active and people will
1293     see what they got. 
1294     */
1295     function reveal() external onlyOwner
1296     {
1297         revealed = true;
1298     }
1299 
1300     /** Toggle if minting is on or off. */
1301     function toggleMinting() external onlyOwner
1302     {
1303         mintingActive = !mintingActive;
1304     }
1305 
1306     /** Toggle if allow list only or not */
1307     function toggleAllowList() external onlyOwner
1308     {
1309         allowListOnly = !allowListOnly;
1310     }
1311 
1312     /** Withdraw the eth stored in the contract. */
1313     function withdraw() external onlyOwner
1314     {
1315         uint256 balance = address(this).balance;
1316         payable(msg.sender).transfer(balance);
1317     }
1318 
1319     /** Sets the maximum amount of NFTs that can be minted in a single transation */
1320     function setMaxMintAmount(uint256 _amount) external onlyOwner
1321     {
1322         maxMintAmount = _amount;
1323     }
1324 
1325     /** Sets the max supply this should only be used in emergency */
1326     function setMaxSupply(uint256 _amount) external onlyOwner
1327     {
1328         maxSupply = _amount;
1329     }
1330 
1331     /** Sets the max gift supply emergency */
1332     function setMaxGiftSupply(uint256 _amount) external onlyOwner
1333     {
1334         giftSupply = _amount;
1335     }
1336 }