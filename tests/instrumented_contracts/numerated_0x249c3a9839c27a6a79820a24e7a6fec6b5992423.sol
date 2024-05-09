1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @title ERC721 token receiver interface
22  * @dev Interface for any contract that wants to support safeTransfers
23  * from ERC721 asset contracts.
24  */
25 interface IERC721Receiver {
26     /**
27      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
28      * by `operator` from `from`, this function is called.
29      *
30      * It must return its Solidity selector to confirm the token transfer.
31      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
32      *
33      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
34      */
35     function onERC721Received(
36         address operator,
37         address from,
38         uint256 tokenId,
39         bytes calldata data
40     ) external returns (bytes4);
41 }
42 
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
66      */
67     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId,
105         bytes calldata data
106     ) external;
107 
108     /**
109      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
110      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must exist and be owned by `from`.
117      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
119      *
120      * Emits a {Transfer} event.
121      */
122     function safeTransferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Transfers `tokenId` token from `from` to `to`.
130      *
131      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must be owned by `from`.
138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address from,
144         address to,
145         uint256 tokenId
146     ) external;
147 
148     /**
149      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
150      * The approval is cleared when the token is transferred.
151      *
152      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
153      *
154      * Requirements:
155      *
156      * - The caller must own the token or be an approved operator.
157      * - `tokenId` must exist.
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address to, uint256 tokenId) external;
162 
163     /**
164      * @dev Approve or remove `operator` as an operator for the caller.
165      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
166      *
167      * Requirements:
168      *
169      * - The `operator` cannot be the caller.
170      *
171      * Emits an {ApprovalForAll} event.
172      */
173     function setApprovalForAll(address operator, bool _approved) external;
174 
175     /**
176      * @dev Returns the account approved for `tokenId` token.
177      *
178      * Requirements:
179      *
180      * - `tokenId` must exist.
181      */
182     function getApproved(uint256 tokenId) external view returns (address operator);
183 
184     /**
185      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
186      *
187      * See {setApprovalForAll}
188      */
189     function isApprovedForAll(address owner, address operator) external view returns (bool);
190 }
191 
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Metadata is IERC721 {
197     /**
198      * @dev Returns the token collection name.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the token collection symbol.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
209      */
210     function tokenURI(uint256 tokenId) external view returns (string memory);
211 }
212 
213 pragma solidity ^0.8.1;
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      *
236      * [IMPORTANT]
237      * ====
238      * You shouldn't rely on `isContract` to protect against flash loan attacks!
239      *
240      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
241      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
242      * constructor.
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // This method relies on extcodesize/address.code.length, which returns 0
247         // for contracts in construction, since the code is only stored at the end
248         // of the constructor execution.
249 
250         return account.code.length > 0;
251     }
252 
253     /**
254      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
255      * `recipient`, forwarding all available gas and reverting on errors.
256      *
257      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
258      * of certain opcodes, possibly making contracts go over the 2300 gas limit
259      * imposed by `transfer`, making them unable to receive funds via
260      * `transfer`. {sendValue} removes this limitation.
261      *
262      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
263      *
264      * IMPORTANT: because control is transferred to `recipient`, care must be
265      * taken to not create reentrancy vulnerabilities. Consider using
266      * {ReentrancyGuard} or the
267      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
268      */
269     function sendValue(address payable recipient, uint256 amount) internal {
270         require(address(this).balance >= amount, "Address: insufficient balance");
271 
272         (bool success, ) = recipient.call{value: amount}("");
273         require(success, "Address: unable to send value, recipient may have reverted");
274     }
275 
276     /**
277      * @dev Performs a Solidity function call using a low level `call`. A
278      * plain `call` is an unsafe replacement for a function call: use this
279      * function instead.
280      *
281      * If `target` reverts with a revert reason, it is bubbled up by this
282      * function (like regular Solidity function calls).
283      *
284      * Returns the raw returned data. To convert to the expected return value,
285      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
286      *
287      * Requirements:
288      *
289      * - `target` must be a contract.
290      * - calling `target` with `data` must not revert.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
300      * `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         (bool success, bytes memory returndata) = target.call{value: value}(data);
345         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         (bool success, bytes memory returndata) = target.staticcall(data);
370         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a delegate call.
386      *
387      * _Available since v3.4._
388      */
389     function functionDelegateCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         (bool success, bytes memory returndata) = target.delegatecall(data);
395         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
400      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
401      *
402      * _Available since v4.8._
403      */
404     function verifyCallResultFromTarget(
405         address target,
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) internal view returns (bytes memory) {
410         if (success) {
411             if (returndata.length == 0) {
412                 // only check isContract if the call was successful and the return data is empty
413                 // otherwise we already know that it was a contract
414                 require(isContract(target), "Address: call to non-contract");
415             }
416             return returndata;
417         } else {
418             _revert(returndata, errorMessage);
419         }
420     }
421 
422     /**
423      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason or using the provided one.
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
436             _revert(returndata, errorMessage);
437         }
438     }
439 
440     function _revert(bytes memory returndata, string memory errorMessage) private pure {
441         // Look for revert reason and bubble it up if present
442         if (returndata.length > 0) {
443             // The easiest way to bubble the revert reason is using memory via assembly
444             /// @solidity memory-safe-assembly
445             assembly {
446                 let returndata_size := mload(returndata)
447                 revert(add(32, returndata), returndata_size)
448             }
449         } else {
450             revert(errorMessage);
451         }
452     }
453 }
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev String operations.
482  */
483 library Strings {
484     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
485     uint8 private constant _ADDRESS_LENGTH = 20;
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
489      */
490     function toString(uint256 value) internal pure returns (string memory) {
491         // Inspired by OraclizeAPI's implementation - MIT licence
492         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
493 
494         if (value == 0) {
495             return "0";
496         }
497         uint256 temp = value;
498         uint256 digits;
499         while (temp != 0) {
500             digits++;
501             temp /= 10;
502         }
503         bytes memory buffer = new bytes(digits);
504         while (value != 0) {
505             digits -= 1;
506             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
507             value /= 10;
508         }
509         return string(buffer);
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
514      */
515     function toHexString(uint256 value) internal pure returns (string memory) {
516         if (value == 0) {
517             return "0x00";
518         }
519         uint256 temp = value;
520         uint256 length = 0;
521         while (temp != 0) {
522             length++;
523             temp >>= 8;
524         }
525         return toHexString(value, length);
526     }
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
530      */
531     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
532         bytes memory buffer = new bytes(2 * length + 2);
533         buffer[0] = "0";
534         buffer[1] = "x";
535         for (uint256 i = 2 * length + 1; i > 1; --i) {
536             buffer[i] = _HEX_SYMBOLS[value & 0xf];
537             value >>= 4;
538         }
539         require(value == 0, "Strings: hex length insufficient");
540         return string(buffer);
541     }
542 
543     /**
544      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
545      */
546     function toHexString(address addr) internal pure returns (string memory) {
547         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
548     }
549 }
550 
551 
552 /**
553  * @dev Implementation of the {IERC165} interface.
554  *
555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
556  * for the additional interface id that will be supported. For example:
557  *
558  * ```solidity
559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
561  * }
562  * ```
563  *
564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
565  */
566 abstract contract ERC165 is IERC165 {
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571         return interfaceId == type(IERC165).interfaceId;
572     }
573 }
574 
575 /**
576  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
577  * the Metadata extension, but not including the Enumerable extension, which is available separately as
578  * {ERC721Enumerable}.
579  */
580 
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
592 
593 
594 
595 
596 
597 
598 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
599     using Address for address;
600     using Strings for uint256;
601 
602     // Token name
603     string private _name;
604 
605     // Token symbol
606     string private _symbol;
607 
608     // Mapping from token ID to owner address
609     mapping(uint256 => address) private _owners;
610 
611     // Mapping owner address to token count
612     mapping(address => uint256) private _balances;
613 
614     // Mapping from token ID to approved address
615     mapping(uint256 => address) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     
621     address public _owner;
622     uint256 public totalSupply;
623     uint256 public _price;
624     string public _baseURI;
625     /**
626      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
627      */
628     constructor(string memory name_, string memory symbol_, string memory baseURI_) {
629         _name = name_;
630         _symbol = symbol_;
631         _owner = msg.sender;
632         _baseURI = baseURI_;
633     }
634 
635     modifier onlyOwner() {
636         require(msg.sender == _owner, "not owner");
637         _;
638     }
639 
640     function setPrice(uint256 amount) public onlyOwner {
641         _price = amount;
642     }
643 
644     function withdraw(address to, uint256 amount) public onlyOwner {
645         payable(to).transfer(amount);
646     }
647 
648     function mint() payable public {
649         require(msg.value >= _price, "insufficient value");
650         totalSupply = totalSupply + 1;
651         _mint(msg.sender, totalSupply);
652     }
653 
654     /**
655      * @dev See {IERC165-supportsInterface}.
656      */
657     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
658         return
659             interfaceId == type(IERC721).interfaceId ||
660             interfaceId == type(IERC721Metadata).interfaceId ||
661             super.supportsInterface(interfaceId);
662     }
663 
664     /**
665      * @dev See {IERC721-balanceOf}.
666      */
667     function balanceOf(address owner) public view virtual override returns (uint256) {
668         require(owner != address(0), "ERC721: address zero is not a valid owner");
669         return _balances[owner];
670     }
671 
672     /**
673      * @dev See {IERC721-ownerOf}.
674      */
675     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
676         address owner = _owners[tokenId];
677         require(owner != address(0), "ERC721: invalid token ID");
678         return owner;
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-name}.
683      */
684     function name() public view virtual override returns (string memory) {
685         return _name;
686     }
687 
688     /**
689      * @dev See {IERC721Metadata-symbol}.
690      */
691     function symbol() public view virtual override returns (string memory) {
692         return _symbol;
693     }
694 
695     /**
696      * @dev See {IERC721Metadata-tokenURI}.
697      */
698     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
699         _requireMinted(tokenId);
700 
701         string memory baseURI = _baseURI;
702         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
703     }
704 
705 
706     /**
707      * @dev See {IERC721-approve}.
708      */
709     function approve(address to, uint256 tokenId) public virtual override {
710         address owner = ERC721.ownerOf(tokenId);
711         require(to != owner, "ERC721: approval to current owner");
712 
713         require(
714             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
715             "ERC721: approve caller is not token owner or approved for all"
716         );
717 
718         _approve(to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-getApproved}.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         _requireMinted(tokenId);
726 
727         return _tokenApprovals[tokenId];
728     }
729 
730     /**
731      * @dev See {IERC721-setApprovalForAll}.
732      */
733     function setApprovalForAll(address operator, bool approved) public virtual override {
734         _setApprovalForAll(_msgSender(), operator, approved);
735     }
736 
737     /**
738      * @dev See {IERC721-isApprovedForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[owner][operator];
742     }
743 
744     /**
745      * @dev See {IERC721-transferFrom}.
746      */
747     function transferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         //solhint-disable-next-line max-line-length
753         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
754 
755         _transfer(from, to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId
765     ) public virtual override {
766         safeTransferFrom(from, to, tokenId, "");
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory data
777     ) public virtual override {
778         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
779         _safeTransfer(from, to, tokenId, data);
780     }
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
784      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
785      *
786      * `data` is additional data, it has no specified format and it is sent in call to `to`.
787      *
788      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
789      * implement alternative mechanisms to perform token transfer, such as signature-based.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _safeTransfer(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory data
805     ) internal virtual {
806         _transfer(from, to, tokenId);
807         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
808     }
809 
810     /**
811      * @dev Returns whether `tokenId` exists.
812      *
813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
814      *
815      * Tokens start existing when they are minted (`_mint`),
816      * and stop existing when they are burned (`_burn`).
817      */
818     function _exists(uint256 tokenId) internal view virtual returns (bool) {
819         return _owners[tokenId] != address(0);
820     }
821 
822     /**
823      * @dev Returns whether `spender` is allowed to manage `tokenId`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
830         address owner = ERC721.ownerOf(tokenId);
831         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
832     }
833 
834     /**
835      * @dev Safely mints `tokenId` and transfers it to `to`.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must not exist.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _safeMint(address to, uint256 tokenId) internal virtual {
845         _safeMint(to, tokenId, "");
846     }
847 
848     /**
849      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
850      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
851      */
852     function _safeMint(
853         address to,
854         uint256 tokenId,
855         bytes memory data
856     ) internal virtual {
857         _mint(to, tokenId);
858         require(
859             _checkOnERC721Received(address(0), to, tokenId, data),
860             "ERC721: transfer to non ERC721Receiver implementer"
861         );
862     }
863 
864     /**
865      * @dev Mints `tokenId` and transfers it to `to`.
866      *
867      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
868      *
869      * Requirements:
870      *
871      * - `tokenId` must not exist.
872      * - `to` cannot be the zero address.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _mint(address to, uint256 tokenId) internal virtual {
877         require(to != address(0), "ERC721: mint to the zero address");
878         require(!_exists(tokenId), "ERC721: token already minted");
879 
880         _beforeTokenTransfer(address(0), to, tokenId);
881 
882         _balances[to] += 1;
883         _owners[tokenId] = to;
884 
885         emit Transfer(address(0), to, tokenId);
886 
887         _afterTokenTransfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      * This is an internal function that does not check if the sender is authorized to operate on the token.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _burn(uint256 tokenId) internal virtual {
902         address owner = ERC721.ownerOf(tokenId);
903 
904         _beforeTokenTransfer(owner, address(0), tokenId);
905 
906         // Clear approvals
907         delete _tokenApprovals[tokenId];
908 
909         _balances[owner] -= 1;
910         delete _owners[tokenId];
911 
912         emit Transfer(owner, address(0), tokenId);
913 
914         _afterTokenTransfer(owner, address(0), tokenId);
915     }
916 
917     /**
918      * @dev Transfers `tokenId` from `from` to `to`.
919      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
920      *
921      * Requirements:
922      *
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must be owned by `from`.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _transfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) internal virtual {
933         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
934         require(to != address(0), "ERC721: transfer to the zero address");
935 
936         _beforeTokenTransfer(from, to, tokenId);
937 
938         // Clear approvals from the previous owner
939         delete _tokenApprovals[tokenId];
940 
941         _balances[from] -= 1;
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(from, to, tokenId);
946 
947         _afterTokenTransfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev Approve `to` to operate on `tokenId`
952      *
953      * Emits an {Approval} event.
954      */
955     function _approve(address to, uint256 tokenId) internal virtual {
956         _tokenApprovals[tokenId] = to;
957         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
958     }
959 
960     /**
961      * @dev Approve `operator` to operate on all of `owner` tokens
962      *
963      * Emits an {ApprovalForAll} event.
964      */
965     function _setApprovalForAll(
966         address owner,
967         address operator,
968         bool approved
969     ) internal virtual {
970         require(owner != operator, "ERC721: approve to caller");
971         _operatorApprovals[owner][operator] = approved;
972         emit ApprovalForAll(owner, operator, approved);
973     }
974 
975     /**
976      * @dev Reverts if the `tokenId` has not been minted yet.
977      */
978     function _requireMinted(uint256 tokenId) internal view virtual {
979         require(_exists(tokenId), "ERC721: invalid token ID");
980     }
981 
982     /**
983      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
984      * The call is not executed if the target address is not a contract.
985      *
986      * @param from address representing the previous owner of the given token ID
987      * @param to target address that will receive the tokens
988      * @param tokenId uint256 ID of the token to be transferred
989      * @param data bytes optional data to send along with the call
990      * @return bool whether the call correctly returned the expected magic value
991      */
992     function _checkOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory data
997     ) private returns (bool) {
998         if (to.isContract()) {
999             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1000                 return retval == IERC721Receiver.onERC721Received.selector;
1001             } catch (bytes memory reason) {
1002                 if (reason.length == 0) {
1003                     revert("ERC721: transfer to non ERC721Receiver implementer");
1004                 } else {
1005                     /// @solidity memory-safe-assembly
1006                     assembly {
1007                         revert(add(32, reason), mload(reason))
1008                     }
1009                 }
1010             }
1011         } else {
1012             return true;
1013         }
1014     }
1015 
1016     /**
1017      * @dev Hook that is called before any token transfer. This includes minting
1018      * and burning.
1019      *
1020      * Calling conditions:
1021      *
1022      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1023      * transferred to `to`.
1024      * - When `from` is zero, `tokenId` will be minted for `to`.
1025      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1026      * - `from` and `to` are never both zero.
1027      *
1028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1029      */
1030     function _beforeTokenTransfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual {}
1035 
1036     /**
1037      * @dev Hook that is called after any transfer of tokens. This includes
1038      * minting and burning.
1039      *
1040      * Calling conditions:
1041      *
1042      * - when `from` and `to` are both non-zero.
1043      * - `from` and `to` are never both zero.
1044      *
1045      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1046      */
1047     function _afterTokenTransfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) internal virtual {}
1052 }