1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-28
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which allows children to implement an emergency stop
34  * mechanism that can be triggered by an authorized account.
35  *
36  * This module is used through inheritance. It will make available the
37  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
38  * the functions of your contract. Note that they will not be pausable by
39  * simply including this module, only once the modifiers are put in place.
40  */
41 abstract contract Pausable is Context {
42     /**
43      * @dev Emitted when the pause is triggered by `account`.
44      */
45     event Paused(address account);
46 
47     /**
48      * @dev Emitted when the pause is lifted by `account`.
49      */
50     event Unpaused(address account);
51 
52     bool private _paused;
53 
54     /**
55      * @dev Initializes the contract in unpaused state.
56      */
57     constructor() {
58         _paused = false;
59     }
60 
61     /**
62      * @dev Returns true if the contract is paused, and false otherwise.
63      */
64     function paused() public view virtual returns (bool) {
65         return _paused;
66     }
67 
68     /**
69      * @dev Modifier to make a function callable only when the contract is not paused.
70      *
71      * Requirements:
72      *
73      * - The contract must not be paused.
74      */
75     modifier whenNotPaused() {
76         require(!paused(), "Pausable: paused");
77         _;
78     }
79 
80     /**
81      * @dev Modifier to make a function callable only when the contract is paused.
82      *
83      * Requirements:
84      *
85      * - The contract must be paused.
86      */
87     modifier whenPaused() {
88         require(paused(), "Pausable: not paused");
89         _;
90     }
91 
92     /**
93      * @dev Triggers stopped state.
94      *
95      * Requirements:
96      *
97      * - The contract must not be paused.
98      */
99     function _pause() internal virtual whenNotPaused {
100         _paused = true;
101         emit Paused(_msgSender());
102     }
103 
104     /**
105      * @dev Returns to normal state.
106      *
107      * Requirements:
108      *
109      * - The contract must be paused.
110      */
111     function _unpause() internal virtual whenPaused {
112         _paused = false;
113         emit Unpaused(_msgSender());
114     }
115 }
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 }
183 
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Interface of the ERC165 standard, as defined in the
191  * https://eips.ethereum.org/EIPS/eip-165[EIP].
192  *
193  * Implementers can declare support of contract interfaces, which can then be
194  * queried by others ({ERC165Checker}).
195  *
196  * For an implementation, see {ERC165}.
197  */
198 interface IERC165 {
199     /**
200      * @dev Returns true if this contract implements the interface defined by
201      * `interfaceId`. See the corresponding
202      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
203      * to learn more about how these ids are created.
204      *
205      * This function call must use less than 30 000 gas.
206      */
207     function supportsInterface(bytes4 interfaceId) external view returns (bool);
208 }
209 
210 
211 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.3
212 
213 // SPDX-License-Identifier: MIT
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Required interface of an ERC721 compliant contract.
219  */
220 interface IERC721 is IERC165 {
221     /**
222      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
225 
226     /**
227      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
228      */
229     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
230 
231     /**
232      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
233      */
234     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
235 
236     /**
237      * @dev Returns the number of tokens in ``owner``'s account.
238      */
239     function balanceOf(address owner) external view returns (uint256 balance);
240 
241     /**
242      * @dev Returns the owner of the `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function ownerOf(uint256 tokenId) external view returns (address owner);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
252      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
253      *
254      * Requirements:
255      *
256      * - `from` cannot be the zero address.
257      * - `to` cannot be the zero address.
258      * - `tokenId` token must exist and be owned by `from`.
259      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
260      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
261      *
262      * Emits a {Transfer} event.
263      */
264     function safeTransferFrom(
265         address from,
266         address to,
267         uint256 tokenId
268     ) external;
269 
270     /**
271      * @dev Transfers `tokenId` token from `from` to `to`.
272      *
273      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must be owned by `from`.
280      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(
285         address from,
286         address to,
287         uint256 tokenId
288     ) external;
289 
290     /**
291      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
292      * The approval is cleared when the token is transferred.
293      *
294      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
295      *
296      * Requirements:
297      *
298      * - The caller must own the token or be an approved operator.
299      * - `tokenId` must exist.
300      *
301      * Emits an {Approval} event.
302      */
303     function approve(address to, uint256 tokenId) external;
304 
305     /**
306      * @dev Returns the account approved for `tokenId` token.
307      *
308      * Requirements:
309      *
310      * - `tokenId` must exist.
311      */
312     function getApproved(uint256 tokenId) external view returns (address operator);
313 
314     /**
315      * @dev Approve or remove `operator` as an operator for the caller.
316      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
317      *
318      * Requirements:
319      *
320      * - The `operator` cannot be the caller.
321      *
322      * Emits an {ApprovalForAll} event.
323      */
324     function setApprovalForAll(address operator, bool _approved) external;
325 
326     /**
327      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
328      *
329      * See {setApprovalForAll}
330      */
331     function isApprovedForAll(address owner, address operator) external view returns (bool);
332 
333     /**
334      * @dev Safely transfers `tokenId` token from `from` to `to`.
335      *
336      * Requirements:
337      *
338      * - `from` cannot be the zero address.
339      * - `to` cannot be the zero address.
340      * - `tokenId` token must exist and be owned by `from`.
341      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
342      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
343      *
344      * Emits a {Transfer} event.
345      */
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId,
350         bytes calldata data
351     ) external;
352 }
353 
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
361  * @dev See https://eips.ethereum.org/EIPS/eip-721
362  */
363 interface IERC721Enumerable is IERC721 {
364     /**
365      * @dev Returns the total amount of tokens stored by the contract.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
371      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
372      */
373     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
374 
375     /**
376      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
377      * Use along with {totalSupply} to enumerate all tokens.
378      */
379     function tokenByIndex(uint256 index) external view returns (uint256);
380 }
381 
382 
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @title ERC721 token receiver interface
388  * @dev Interface for any contract that wants to support safeTransfers
389  * from ERC721 asset contracts.
390  */
391 interface IERC721Receiver {
392     /**
393      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
394      * by `operator` from `from`, this function is called.
395      *
396      * It must return its Solidity selector to confirm the token transfer.
397      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
398      *
399      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
400      */
401     function onERC721Received(
402         address operator,
403         address from,
404         uint256 tokenId,
405         bytes calldata data
406     ) external returns (bytes4);
407 }
408 
409 
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
415  * @dev See https://eips.ethereum.org/EIPS/eip-721
416  */
417 interface IERC721Metadata is IERC721 {
418     /**
419      * @dev Returns the token collection name.
420      */
421     function name() external view returns (string memory);
422 
423     /**
424      * @dev Returns the token collection symbol.
425      */
426     function symbol() external view returns (string memory);
427 
428     /**
429      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
430      */
431     function tokenURI(uint256 tokenId) external view returns (string memory);
432 }
433 
434 
435 
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      */
460     function isContract(address account) internal view returns (bool) {
461         // This method relies on extcodesize, which returns 0 for contracts in
462         // construction, since the code is only stored at the end of the
463         // constructor execution.
464 
465         uint256 size;
466         assembly {
467             size := extcodesize(account)
468         }
469         return size > 0;
470     }
471 
472     /**
473      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
474      * `recipient`, forwarding all available gas and reverting on errors.
475      *
476      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
477      * of certain opcodes, possibly making contracts go over the 2300 gas limit
478      * imposed by `transfer`, making them unable to receive funds via
479      * `transfer`. {sendValue} removes this limitation.
480      *
481      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
482      *
483      * IMPORTANT: because control is transferred to `recipient`, care must be
484      * taken to not create reentrancy vulnerabilities. Consider using
485      * {ReentrancyGuard} or the
486      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
487      */
488     function sendValue(address payable recipient, uint256 amount) internal {
489         require(address(this).balance >= amount, "Address: insufficient balance");
490 
491         (bool success, ) = recipient.call{value: amount}("");
492         require(success, "Address: unable to send value, recipient may have reverted");
493     }
494 
495     /**
496      * @dev Performs a Solidity function call using a low level `call`. A
497      * plain `call` is an unsafe replacement for a function call: use this
498      * function instead.
499      *
500      * If `target` reverts with a revert reason, it is bubbled up by this
501      * function (like regular Solidity function calls).
502      *
503      * Returns the raw returned data. To convert to the expected return value,
504      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
505      *
506      * Requirements:
507      *
508      * - `target` must be a contract.
509      * - calling `target` with `data` must not revert.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
514         return functionCall(target, data, "Address: low-level call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
519      * `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, 0, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but also transferring `value` wei to `target`.
534      *
535      * Requirements:
536      *
537      * - the calling contract must have an ETH balance of at least `value`.
538      * - the called Solidity function must be `payable`.
539      *
540      * _Available since v3.1._
541      */
542     function functionCallWithValue(
543         address target,
544         bytes memory data,
545         uint256 value
546     ) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
552      * with `errorMessage` as a fallback revert reason when `target` reverts.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(
557         address target,
558         bytes memory data,
559         uint256 value,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         require(address(this).balance >= value, "Address: insufficient balance for call");
563         require(isContract(target), "Address: call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.call{value: value}(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but performing a static call.
572      *
573      * _Available since v3.3._
574      */
575     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
576         return functionStaticCall(target, data, "Address: low-level static call failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(
586         address target,
587         bytes memory data,
588         string memory errorMessage
589     ) internal view returns (bytes memory) {
590         require(isContract(target), "Address: static call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.staticcall(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a delegate call.
599      *
600      * _Available since v3.4._
601      */
602     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
603         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a delegate call.
609      *
610      * _Available since v3.4._
611      */
612     function functionDelegateCall(
613         address target,
614         bytes memory data,
615         string memory errorMessage
616     ) internal returns (bytes memory) {
617         require(isContract(target), "Address: delegate call to non-contract");
618 
619         (bool success, bytes memory returndata) = target.delegatecall(data);
620         return verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
625      * revert reason using the provided one.
626      *
627      * _Available since v4.3._
628      */
629     function verifyCallResult(
630         bool success,
631         bytes memory returndata,
632         string memory errorMessage
633     ) internal pure returns (bytes memory) {
634         if (success) {
635             return returndata;
636         } else {
637             // Look for revert reason and bubble it up if present
638             if (returndata.length > 0) {
639                 // The easiest way to bubble the revert reason is using memory via assembly
640 
641                 assembly {
642                     let returndata_size := mload(returndata)
643                     revert(add(32, returndata), returndata_size)
644                 }
645             } else {
646                 revert(errorMessage);
647             }
648         }
649     }
650 }
651 
652 
653 
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Implementation of the {IERC165} interface.
659  *
660  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
661  * for the additional interface id that will be supported. For example:
662  *
663  * ```solidity
664  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
665  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
666  * }
667  * ```
668  *
669  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
670  */
671 abstract contract ERC165 is IERC165 {
672     /**
673      * @dev See {IERC165-supportsInterface}.
674      */
675     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676         return interfaceId == type(IERC165).interfaceId;
677     }
678 }
679 
680 
681 // File contracts/ERC721.sol
682 
683 pragma solidity ^0.8.4;
684 
685 
686 
687 
688 
689 
690 
691 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
692 
693     event OwnershipTransferred(address indexed previousAdmin, address indexed newAdmin);
694 
695     using Address for address;
696     using Strings for uint256;
697 
698     // Token name
699     string private _name;
700 
701     // Token symbol
702     string private _symbol;
703 
704     address private _admin;
705 
706     // Mapping from token ID to owner address
707     mapping (uint256 => address) private _owners;
708 
709     // Mapping owner address to token count
710     mapping (address => uint256) private _balances;
711 
712     // Mapping from token ID to approved address
713     mapping (uint256 => address) private _tokenApprovals;
714 
715     // Mapping from owner to operator approvals
716     mapping (address => mapping (address => bool)) private _operatorApprovals;
717 
718     /**
719      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
720      */
721     constructor (address admin_, string memory name_, string memory symbol_) {
722         _admin = admin_;
723         _name = name_;
724         _symbol = symbol_;
725     }
726 
727     modifier onlyAdmin() {
728         require(msg.sender == _admin, "Restricted to admin");
729         _;
730     }
731 
732     function transferOwnership(address newAdmin) external onlyAdmin {
733         require(newAdmin != address(0), "ERC721: new admin is the zero address");
734         require(newAdmin != _admin, "ERC721: same admin");
735         _setAdmin(newAdmin);
736     }
737 
738     function _setAdmin(address newAdmin) private {
739         address oldAdmin = _admin;
740         _admin = newAdmin;
741         emit OwnershipTransferred(oldAdmin, newAdmin);
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
748         return interfaceId == type(IERC721).interfaceId
749         || interfaceId == type(IERC721Metadata).interfaceId
750         || super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      * return magic balance value if is admin user
756      */
757     function balanceOf(address owner) public view virtual override returns (uint256) {
758         require(owner != address(0), "ERC721: balance query for the zero address");
759         return _balances[owner];
760     }
761 
762     /**
763      * @dev See {IERC721-ownerOf}.
764      * return admin user address is not mint yet.
765      */
766     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
767         address owner = _owners[tokenId];
768         if (owner == address(0)) {
769             return _admin;
770         }
771         return owner;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-name}.
776      */
777     function name() public view virtual override returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-symbol}.
783      */
784     function symbol() public view virtual override returns (string memory) {
785         return _symbol;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-tokenURI}.
790      */
791     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
792         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
793 
794         string memory baseURI = _baseURI();
795         return bytes(baseURI).length > 0
796         ? string(abi.encodePacked(baseURI, tokenId.toString()))
797         : '';
798     }
799 
800     /**
801      * return admin user;
802      */
803     function admin() public view virtual returns (address) {
804         return _admin;
805     }
806 
807     /**
808      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
809      * in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return "";
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public virtual override {
819         require(_exists(tokenId), "ERC721: approve for nonexistent token");
820         address owner = ERC721.ownerOf(tokenId);
821         require(to != owner, "ERC721: approval to current owner");
822 
823         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             "ERC721: approve caller is not owner or approved for all"
825         );
826 
827         _approve(to, tokenId);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view virtual override returns (address) {
834         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public virtual override {
843         require(operator != _msgSender(), "ERC721: approve to caller");
844 
845         _operatorApprovals[_msgSender()][operator] = approved;
846         emit ApprovalForAll(_msgSender(), operator, approved);
847     }
848 
849     /**
850      * @dev See {IERC721-isApprovedForAll}.
851      */
852     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
853         return _operatorApprovals[owner][operator];
854     }
855 
856     /**
857      * @dev See {IERC721-transferFrom}.
858      * if msg.sender is admin, mint before transfer
859      */
860     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
861         _mintIfNotExist(tokenId);
862         //solhint-disable-next-line max-line-length
863         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
864 
865         _transfer(from, to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
872         safeTransferFrom(from, to, tokenId, "");
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      * if msg.sender is admin, mint before transfer
878      */
879     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
880         _mintIfNotExist(tokenId);
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
882         _safeTransfer(from, to, tokenId, _data);
883     }
884 
885     /**
886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
888      *
889      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
890      *
891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
892      * implement alternative mechanisms to perform token transfer, such as signature-based.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
904         _transfer(from, to, tokenId);
905         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
906     }
907 
908     /**
909      * @dev Returns whether `tokenId` exists.
910      *
911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
912      *
913      * Tokens start existing when they are minted (`_mint`),
914      * and stop existing when they are burned (`_burn`).
915      */
916     function _exists(uint256 tokenId) internal view virtual returns (bool) {
917         return _owners[tokenId] != address(0);
918     }
919 
920     /**
921      * @dev Returns whether `spender` is allowed to manage `tokenId`.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      */
927     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
928         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
929         address owner = ERC721.ownerOf(tokenId);
930         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
931     }
932 
933     /**
934      * @dev Safely mints `tokenId` and transfers it to `to`.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(address to, uint256 tokenId) internal virtual {
944         _safeMint(to, tokenId, "");
945     }
946 
947     /**
948      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
949      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
950      */
951     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
952         _mint(to, tokenId);
953         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978     }
979 
980     function _mintForAdmin(address to, uint256 tokenId) private {
981 
982         _beforeTokenTransfer(address(0), to, tokenId);
983 
984         _balances[to] += 1;
985         _owners[tokenId] = to;
986 
987         emit Transfer(address(0), to, tokenId);
988     }
989 
990     /**
991      * @dev Destroys `tokenId`.
992      * The approval is cleared when the token is burned.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _burn(uint256 tokenId) internal virtual {
1001         require(_exists(tokenId), "ERC721: burn nonexistent token");
1002         address owner = ERC721.ownerOf(tokenId);
1003 
1004         _beforeTokenTransfer(owner, address(0), tokenId);
1005 
1006         // Clear approvals
1007         _approve(address(0), tokenId);
1008 
1009         _balances[owner] -= 1;
1010         delete _owners[tokenId];
1011 
1012         emit Transfer(owner, address(0), tokenId);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1027         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1028         require(to != address(0), "ERC721: transfer to the zero address");
1029 
1030         _beforeTokenTransfer(from, to, tokenId);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId);
1034 
1035         _balances[from] -= 1;
1036         _balances[to] += 1;
1037         _owners[tokenId] = to;
1038 
1039         emit Transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Approve `to` to operate on `tokenId`
1044      *
1045      * Emits a {Approval} event.
1046      */
1047     function _approve(address to, uint256 tokenId) internal virtual {
1048         _tokenApprovals[tokenId] = to;
1049         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1054      * The call is not executed if the target address is not a contract.
1055      *
1056      * @param from address representing the previous owner of the given token ID
1057      * @param to target address that will receive the tokens
1058      * @param tokenId uint256 ID of the token to be transferred
1059      * @param _data bytes optional data to send along with the call
1060      * @return bool whether the call correctly returned the expected magic value
1061      */
1062     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1063     private returns (bool)
1064     {
1065         if (to.isContract()) {
1066             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1067                 return retval == IERC721Receiver(to).onERC721Received.selector;
1068             } catch (bytes memory reason) {
1069                 if (reason.length == 0) {
1070                     revert("ERC721: transfer to non ERC721Receiver implementer");
1071                 } else {
1072                     // solhint-disable-next-line no-inline-assembly
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /*
1084     * mint if msg.sender is admin && tokenId not mint.
1085     */
1086     function _mintIfNotExist(uint256 tokenId) private {
1087         if (msg.sender == _admin) {
1088             if (!_exists(tokenId)) {
1089             _mintForAdmin(_admin, tokenId);
1090             }
1091         }
1092     }
1093 
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1110 }
1111 
1112 
1113 // File contracts/ERC721Enumerable.sol
1114 
1115 pragma solidity ^0.8.4;
1116 
1117 
1118 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1119     // Mapping from owner to list of owned token IDs
1120     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1121 
1122     // Mapping from token ID to index of the owner tokens list
1123     mapping(uint256 => uint256) private _ownedTokensIndex;
1124 
1125     // Array with all token ids, used for enumeration
1126     uint256[] private _allTokens;
1127 
1128     // Mapping from token id to position in the allTokens array
1129     mapping(uint256 => uint256) private _allTokensIndex;
1130 
1131     /**
1132      * @dev See {IERC165-supportsInterface}.
1133      */
1134     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1135         return interfaceId == type(IERC721Enumerable).interfaceId
1136         || super.supportsInterface(interfaceId);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1141      */
1142     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1143         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1144         return _ownedTokens[owner][index];
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Enumerable-totalSupply}.
1149      */
1150     function totalSupply() public view virtual override returns (uint256) {
1151         return _allTokens.length;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Enumerable-tokenByIndex}.
1156      */
1157     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1158         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1159         return _allTokens[index];
1160     }
1161 
1162     /**
1163      * @dev Hook that is called before any token transfer. This includes minting
1164      * and burning.
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1172      * - `from` cannot be the zero address.
1173      * - `to` cannot be the zero address.
1174      *
1175      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1176      */
1177     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1178         super._beforeTokenTransfer(from, to, tokenId);
1179 
1180         if (from == address(0)) {
1181             _addTokenToAllTokensEnumeration(tokenId);
1182         } else if (from != to) {
1183             _removeTokenFromOwnerEnumeration(from, tokenId);
1184         }
1185         if (to == address(0)) {
1186             _removeTokenFromAllTokensEnumeration(tokenId);
1187         } else if (to != from) {
1188             _addTokenToOwnerEnumeration(to, tokenId);
1189         }
1190     }
1191 
1192     /**
1193      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1194      * @param to address representing the new owner of the given token ID
1195      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1196      */
1197     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1198         uint256 length = ERC721.balanceOf(to);
1199         _ownedTokens[to][length] = tokenId;
1200         _ownedTokensIndex[tokenId] = length;
1201     }
1202 
1203     /**
1204      * @dev Private function to add a token to this extension's token tracking data structures.
1205      * @param tokenId uint256 ID of the token to be added to the tokens list
1206      */
1207     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1208         _allTokensIndex[tokenId] = _allTokens.length;
1209         _allTokens.push(tokenId);
1210     }
1211 
1212     /**
1213      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1214      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1215      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1216      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1217      * @param from address representing the previous owner of the given token ID
1218      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1219      */
1220     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1221         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1222         // then delete the last slot (swap and pop).
1223 
1224         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1225         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1226 
1227         // When the token to delete is the last token, the swap operation is unnecessary
1228         if (tokenIndex != lastTokenIndex) {
1229             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1230 
1231             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1232             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1233         }
1234 
1235         // This also deletes the contents at the last position of the array
1236         delete _ownedTokensIndex[tokenId];
1237         delete _ownedTokens[from][lastTokenIndex];
1238     }
1239 
1240     /**
1241      * @dev Private function to remove a token from this extension's token tracking data structures.
1242      * This has O(1) time complexity, but alters the order of the _allTokens array.
1243      * @param tokenId uint256 ID of the token to be removed from the tokens list
1244      */
1245     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1246         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1247         // then delete the last slot (swap and pop).
1248 
1249         uint256 lastTokenIndex = _allTokens.length - 1;
1250         uint256 tokenIndex = _allTokensIndex[tokenId];
1251 
1252         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1253         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1254         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1255         uint256 lastTokenId = _allTokens[lastTokenIndex];
1256 
1257         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1258         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1259 
1260         // This also deletes the contents at the last position of the array
1261         delete _allTokensIndex[tokenId];
1262         _allTokens.pop();
1263     }
1264 }
1265 
1266 
1267 // File contracts/NFT.sol
1268 
1269 pragma solidity ^0.8.4;
1270 
1271 
1272 
1273 contract NFT is ERC721Enumerable, Pausable {
1274     using Strings for uint256;
1275 
1276     string private baseURI;
1277 
1278     constructor(
1279         address admin_,
1280         string memory baseURI_,
1281         string memory name_,
1282         string memory symbol_
1283     ) ERC721(admin_, name_, symbol_) {
1284         baseURI = string(abi.encodePacked(baseURI_, symbol_, "/"));
1285     }
1286 
1287     function _baseURI() internal view override returns (string memory) {
1288         return baseURI;
1289     }
1290 
1291 
1292     /**
1293      * override tokenURI(uint256), remove restrict for tokenId exist.
1294      */
1295     function tokenURI(uint256 tokenId)
1296     public
1297     view
1298     override
1299     returns (string memory)
1300     {
1301         return string(abi.encodePacked(baseURI, tokenId.toString()));
1302     }
1303 
1304     function setPause() external onlyAdmin {
1305         _pause();
1306     }
1307 
1308     function unsetPause() external onlyAdmin {
1309         _unpause();
1310     }
1311 
1312     function changeBaseURI(string memory newBaseURI) external onlyAdmin {
1313         string memory symbol_ = symbol();
1314         baseURI = string(abi.encodePacked(newBaseURI, symbol_, "/"));
1315     }
1316 
1317     /**
1318      * @dev See {ERC721-_beforeTokenTransfer}.
1319      *
1320      * Requirements:
1321      *
1322      * - the contract must not be paused.
1323      */
1324     function _beforeTokenTransfer(
1325         address from,
1326         address to,
1327         uint256 tokenId
1328     ) internal virtual override {
1329         require(!paused(), "ERC721Pausable: token transfer while paused");
1330         super._beforeTokenTransfer(from, to, tokenId);
1331     }
1332 
1333 }
1334 
1335 
1336 
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 /**
1341  * @dev Contract module which provides a basic access control mechanism, where
1342  * there is an account (an owner) that can be granted exclusive access to
1343  * specific functions.
1344  *
1345  * By default, the owner account will be the one that deploys the contract. This
1346  * can later be changed with {transferOwnership}.
1347  *
1348  * This module is used through inheritance. It will make available the modifier
1349  * `onlyOwner`, which can be applied to your functions to restrict their use to
1350  * the owner.
1351  */
1352 abstract contract Ownable is Context {
1353     address private _owner;
1354 
1355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1356 
1357     /**
1358      * @dev Initializes the contract setting the deployer as the initial owner.
1359      */
1360     constructor() {
1361         _setOwner(_msgSender());
1362     }
1363 
1364     /**
1365      * @dev Returns the address of the current owner.
1366      */
1367     function owner() public view virtual returns (address) {
1368         return _owner;
1369     }
1370 
1371     /**
1372      * @dev Throws if called by any account other than the owner.
1373      */
1374     modifier onlyOwner() {
1375         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1376         _;
1377     }
1378 
1379     /**
1380      * @dev Leaves the contract without owner. It will not be possible to call
1381      * `onlyOwner` functions anymore. Can only be called by the current owner.
1382      *
1383      * NOTE: Renouncing ownership will leave the contract without an owner,
1384      * thereby removing any functionality that is only available to the owner.
1385      */
1386     function renounceOwnership() public virtual onlyOwner {
1387         _setOwner(address(0));
1388     }
1389 
1390     /**
1391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1392      * Can only be called by the current owner.
1393      */
1394     function transferOwnership(address newOwner) public virtual onlyOwner {
1395         require(newOwner != address(0), "Ownable: new owner is the zero address");
1396         _setOwner(newOwner);
1397     }
1398 
1399     function _setOwner(address newOwner) private {
1400         address oldOwner = _owner;
1401         _owner = newOwner;
1402         emit OwnershipTransferred(oldOwner, newOwner);
1403     }
1404 }
1405 
1406 
1407 // File contracts/NFTFactory.sol
1408 
1409 pragma solidity ^0.8.4;
1410 
1411 
1412 contract NFTFactory {
1413     event NFTCreated(address indexed nftAddress, string name, string symbol);
1414     event OwnershipTransferred(address indexed previousAdmin, address indexed newAdmin);
1415 
1416     address public admin;
1417 
1418     constructor(address admin_) {
1419         admin = admin_;
1420     }
1421 
1422     modifier onlyAdmin() {
1423         require(msg.sender == admin, "Restricted to admin.");
1424         _;
1425     }
1426 
1427     function createNewNFT(
1428         address owner,
1429         string memory baseURI,
1430         string memory name,
1431         string memory symbol
1432     ) external onlyAdmin returns (address) {
1433         NFT nft = new NFT(owner, baseURI, name, symbol);
1434         emit NFTCreated(address(nft), name, symbol);
1435         return address(nft);
1436     }
1437 
1438     function transferOwnership(address newAdmin) external onlyAdmin {
1439         require(newAdmin != address(0), "Factory: new admin is the zero address");
1440         require(newAdmin != admin, "NFTFactory: same admin");
1441         _setAdmin(newAdmin);
1442     }
1443 
1444     function _setAdmin(address newAdmin) private {
1445         address oldAdmin = admin;
1446         admin = newAdmin;
1447         emit OwnershipTransferred(oldAdmin, newAdmin);
1448     }
1449 
1450 
1451 }