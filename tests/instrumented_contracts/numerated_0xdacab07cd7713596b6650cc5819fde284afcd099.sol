1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
32 
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(
54         address indexed owner,
55         address indexed approved,
56         uint256 indexed tokenId
57     );
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(
63         address indexed owner,
64         address indexed operator,
65         bool approved
66     );
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Returns the account approved for `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function getApproved(uint256 tokenId)
145         external
146         view
147         returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator)
167         external
168         view
169         returns (bool);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 }
191 
192 // File contracts/interfaces/IMintClubIncinerator.sol
193 
194 pragma solidity ^0.8.0;
195 
196 interface IMintClubIncinerator {
197     function burnGoldTokens(address _tokenOwner, uint256 _qty) external;
198 
199     function burnBasicTokens(address _tokenOwner, uint256 _qty) external;
200 }
201 
202 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
229 
230 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * By default, the owner account will be the one that deploys the contract. This
240  * can later be changed with {transferOwnership}.
241  *
242  * This module is used through inheritance. It will make available the modifier
243  * `onlyOwner`, which can be applied to your functions to restrict their use to
244  * the owner.
245  */
246 abstract contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(
250         address indexed previousOwner,
251         address indexed newOwner
252     );
253 
254     /**
255      * @dev Initializes the contract setting the deployer as the initial owner.
256      */
257     constructor() {
258         _transferOwnership(_msgSender());
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         _transferOwnership(address(0));
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(
293             newOwner != address(0),
294             "Ownable: new owner is the zero address"
295         );
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @title ERC721 token receiver interface
318  * @dev Interface for any contract that wants to support safeTransfers
319  * from ERC721 asset contracts.
320  */
321 interface IERC721Receiver {
322     /**
323      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
324      * by `operator` from `from`, this function is called.
325      *
326      * It must return its Solidity selector to confirm the token transfer.
327      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
328      *
329      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
330      */
331     function onERC721Received(
332         address operator,
333         address from,
334         uint256 tokenId,
335         bytes calldata data
336     ) external returns (bytes4);
337 }
338 
339 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
340 
341 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
347  * @dev See https://eips.ethereum.org/EIPS/eip-721
348  */
349 interface IERC721Metadata is IERC721 {
350     /**
351      * @dev Returns the token collection name.
352      */
353     function name() external view returns (string memory);
354 
355     /**
356      * @dev Returns the token collection symbol.
357      */
358     function symbol() external view returns (string memory);
359 
360     /**
361      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
362      */
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
367 
368 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
369 
370 pragma solidity ^0.8.1;
371 
372 /**
373  * @dev Collection of functions related to the address type
374  */
375 library Address {
376     /**
377      * @dev Returns true if `account` is a contract.
378      *
379      * [IMPORTANT]
380      * ====
381      * It is unsafe to assume that an address for which this function returns
382      * false is an externally-owned account (EOA) and not a contract.
383      *
384      * Among others, `isContract` will return false for the following
385      * types of addresses:
386      *
387      *  - an externally-owned account
388      *  - a contract in construction
389      *  - an address where a contract will be created
390      *  - an address where a contract lived, but was destroyed
391      * ====
392      *
393      * [IMPORTANT]
394      * ====
395      * You shouldn't rely on `isContract` to protect against flash loan attacks!
396      *
397      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
398      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
399      * constructor.
400      * ====
401      */
402     function isContract(address account) internal view returns (bool) {
403         // This method relies on extcodesize/address.code.length, which returns 0
404         // for contracts in construction, since the code is only stored at the end
405         // of the constructor execution.
406 
407         return account.code.length > 0;
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      */
426     function sendValue(address payable recipient, uint256 amount) internal {
427         require(
428             address(this).balance >= amount,
429             "Address: insufficient balance"
430         );
431 
432         (bool success, ) = recipient.call{value: amount}("");
433         require(
434             success,
435             "Address: unable to send value, recipient may have reverted"
436         );
437     }
438 
439     /**
440      * @dev Performs a Solidity function call using a low level `call`. A
441      * plain `call` is an unsafe replacement for a function call: use this
442      * function instead.
443      *
444      * If `target` reverts with a revert reason, it is bubbled up by this
445      * function (like regular Solidity function calls).
446      *
447      * Returns the raw returned data. To convert to the expected return value,
448      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
449      *
450      * Requirements:
451      *
452      * - `target` must be a contract.
453      * - calling `target` with `data` must not revert.
454      *
455      * _Available since v3.1._
456      */
457     function functionCall(address target, bytes memory data)
458         internal
459         returns (bytes memory)
460     {
461         return functionCall(target, data, "Address: low-level call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
466      * `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, 0, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but also transferring `value` wei to `target`.
481      *
482      * Requirements:
483      *
484      * - the calling contract must have an ETH balance of at least `value`.
485      * - the called Solidity function must be `payable`.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(
490         address target,
491         bytes memory data,
492         uint256 value
493     ) internal returns (bytes memory) {
494         return
495             functionCallWithValue(
496                 target,
497                 data,
498                 value,
499                 "Address: low-level call with value failed"
500             );
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
505      * with `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value,
513         string memory errorMessage
514     ) internal returns (bytes memory) {
515         require(
516             address(this).balance >= value,
517             "Address: insufficient balance for call"
518         );
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(
522             data
523         );
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data)
534         internal
535         view
536         returns (bytes memory)
537     {
538         return
539             functionStaticCall(
540                 target,
541                 data,
542                 "Address: low-level static call failed"
543             );
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.staticcall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(address target, bytes memory data)
570         internal
571         returns (bytes memory)
572     {
573         return
574             functionDelegateCall(
575                 target,
576                 data,
577                 "Address: low-level delegate call failed"
578             );
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(isContract(target), "Address: delegate call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
600      * revert reason using the provided one.
601      *
602      * _Available since v4.3._
603      */
604     function verifyCallResult(
605         bool success,
606         bytes memory returndata,
607         string memory errorMessage
608     ) internal pure returns (bytes memory) {
609         if (success) {
610             return returndata;
611         } else {
612             // Look for revert reason and bubble it up if present
613             if (returndata.length > 0) {
614                 // The easiest way to bubble the revert reason is using memory via assembly
615 
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert(errorMessage);
622             }
623         }
624     }
625 }
626 
627 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev String operations.
635  */
636 library Strings {
637     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
638 
639     /**
640      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
641      */
642     function toString(uint256 value) internal pure returns (string memory) {
643         // Inspired by OraclizeAPI's implementation - MIT licence
644         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
645 
646         if (value == 0) {
647             return "0";
648         }
649         uint256 temp = value;
650         uint256 digits;
651         while (temp != 0) {
652             digits++;
653             temp /= 10;
654         }
655         bytes memory buffer = new bytes(digits);
656         while (value != 0) {
657             digits -= 1;
658             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
659             value /= 10;
660         }
661         return string(buffer);
662     }
663 
664     /**
665      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
666      */
667     function toHexString(uint256 value) internal pure returns (string memory) {
668         if (value == 0) {
669             return "0x00";
670         }
671         uint256 temp = value;
672         uint256 length = 0;
673         while (temp != 0) {
674             length++;
675             temp >>= 8;
676         }
677         return toHexString(value, length);
678     }
679 
680     /**
681      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
682      */
683     function toHexString(uint256 value, uint256 length)
684         internal
685         pure
686         returns (string memory)
687     {
688         bytes memory buffer = new bytes(2 * length + 2);
689         buffer[0] = "0";
690         buffer[1] = "x";
691         for (uint256 i = 2 * length + 1; i > 1; --i) {
692             buffer[i] = _HEX_SYMBOLS[value & 0xf];
693             value >>= 4;
694         }
695         require(value == 0, "Strings: hex length insufficient");
696         return string(buffer);
697     }
698 }
699 
700 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
701 
702 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @dev Implementation of the {IERC165} interface.
708  *
709  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
710  * for the additional interface id that will be supported. For example:
711  *
712  * ```solidity
713  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
714  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
715  * }
716  * ```
717  *
718  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
719  */
720 abstract contract ERC165 is IERC165 {
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId)
725         public
726         view
727         virtual
728         override
729         returns (bool)
730     {
731         return interfaceId == type(IERC165).interfaceId;
732     }
733 }
734 
735 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
736 
737 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
743  * the Metadata extension, but not including the Enumerable extension, which is available separately as
744  * {ERC721Enumerable}.
745  */
746 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
747     using Address for address;
748     using Strings for uint256;
749 
750     // Token name
751     string private _name;
752 
753     // Token symbol
754     string private _symbol;
755 
756     // Mapping from token ID to owner address
757     mapping(uint256 => address) private _owners;
758 
759     // Mapping owner address to token count
760     mapping(address => uint256) private _balances;
761 
762     // Mapping from token ID to approved address
763     mapping(uint256 => address) private _tokenApprovals;
764 
765     // Mapping from owner to operator approvals
766     mapping(address => mapping(address => bool)) private _operatorApprovals;
767 
768     /**
769      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
770      */
771     constructor(string memory name_, string memory symbol_) {
772         _name = name_;
773         _symbol = symbol_;
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId)
780         public
781         view
782         virtual
783         override(ERC165, IERC165)
784         returns (bool)
785     {
786         return
787             interfaceId == type(IERC721).interfaceId ||
788             interfaceId == type(IERC721Metadata).interfaceId ||
789             super.supportsInterface(interfaceId);
790     }
791 
792     /**
793      * @dev See {IERC721-balanceOf}.
794      */
795     function balanceOf(address owner)
796         public
797         view
798         virtual
799         override
800         returns (uint256)
801     {
802         require(
803             owner != address(0),
804             "ERC721: balance query for the zero address"
805         );
806         return _balances[owner];
807     }
808 
809     /**
810      * @dev See {IERC721-ownerOf}.
811      */
812     function ownerOf(uint256 tokenId)
813         public
814         view
815         virtual
816         override
817         returns (address)
818     {
819         address owner = _owners[tokenId];
820         require(
821             owner != address(0),
822             "ERC721: owner query for nonexistent token"
823         );
824         return owner;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-name}.
829      */
830     function name() public view virtual override returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-symbol}.
836      */
837     function symbol() public view virtual override returns (string memory) {
838         return _symbol;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-tokenURI}.
843      */
844     function tokenURI(uint256 tokenId)
845         public
846         view
847         virtual
848         override
849         returns (string memory)
850     {
851         require(
852             _exists(tokenId),
853             "ERC721Metadata: URI query for nonexistent token"
854         );
855 
856         string memory baseURI = _baseURI();
857         return
858             bytes(baseURI).length > 0
859                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
860                 : "";
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return "";
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public virtual override {
876         address owner = ERC721.ownerOf(tokenId);
877         require(to != owner, "ERC721: approval to current owner");
878 
879         require(
880             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
881             "ERC721: approve caller is not owner nor approved for all"
882         );
883 
884         _approve(to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-getApproved}.
889      */
890     function getApproved(uint256 tokenId)
891         public
892         view
893         virtual
894         override
895         returns (address)
896     {
897         require(
898             _exists(tokenId),
899             "ERC721: approved query for nonexistent token"
900         );
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved)
909         public
910         virtual
911         override
912     {
913         _setApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator)
920         public
921         view
922         virtual
923         override
924         returns (bool)
925     {
926         return _operatorApprovals[owner][operator];
927     }
928 
929     /**
930      * @dev See {IERC721-transferFrom}.
931      */
932     function transferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public virtual override {
937         //solhint-disable-next-line max-line-length
938         require(
939             _isApprovedOrOwner(_msgSender(), tokenId),
940             "ERC721: transfer caller is not owner nor approved"
941         );
942 
943         _transfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         safeTransferFrom(from, to, tokenId, "");
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) public virtual override {
966         require(
967             _isApprovedOrOwner(_msgSender(), tokenId),
968             "ERC721: transfer caller is not owner nor approved"
969         );
970         _safeTransfer(from, to, tokenId, _data);
971     }
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
975      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
976      *
977      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
978      *
979      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
980      * implement alternative mechanisms to perform token transfer, such as signature-based.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeTransfer(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _transfer(from, to, tokenId);
998         require(
999             _checkOnERC721Received(from, to, tokenId, _data),
1000             "ERC721: transfer to non ERC721Receiver implementer"
1001         );
1002     }
1003 
1004     /**
1005      * @dev Returns whether `tokenId` exists.
1006      *
1007      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1008      *
1009      * Tokens start existing when they are minted (`_mint`),
1010      * and stop existing when they are burned (`_burn`).
1011      */
1012     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1013         return _owners[tokenId] != address(0);
1014     }
1015 
1016     /**
1017      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function _isApprovedOrOwner(address spender, uint256 tokenId)
1024         internal
1025         view
1026         virtual
1027         returns (bool)
1028     {
1029         require(
1030             _exists(tokenId),
1031             "ERC721: operator query for nonexistent token"
1032         );
1033         address owner = ERC721.ownerOf(tokenId);
1034         return (spender == owner ||
1035             getApproved(tokenId) == spender ||
1036             isApprovedForAll(owner, spender));
1037     }
1038 
1039     /**
1040      * @dev Safely mints `tokenId` and transfers it to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must not exist.
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _safeMint(address to, uint256 tokenId) internal virtual {
1050         _safeMint(to, tokenId, "");
1051     }
1052 
1053     /**
1054      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1055      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1056      */
1057     function _safeMint(
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) internal virtual {
1062         _mint(to, tokenId);
1063         require(
1064             _checkOnERC721Received(address(0), to, tokenId, _data),
1065             "ERC721: transfer to non ERC721Receiver implementer"
1066         );
1067     }
1068 
1069     /**
1070      * @dev Mints `tokenId` and transfers it to `to`.
1071      *
1072      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must not exist.
1077      * - `to` cannot be the zero address.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _mint(address to, uint256 tokenId) internal virtual {
1082         require(to != address(0), "ERC721: mint to the zero address");
1083         require(!_exists(tokenId), "ERC721: token already minted");
1084 
1085         _beforeTokenTransfer(address(0), to, tokenId);
1086 
1087         _balances[to] += 1;
1088         _owners[tokenId] = to;
1089 
1090         emit Transfer(address(0), to, tokenId);
1091 
1092         _afterTokenTransfer(address(0), to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Destroys `tokenId`.
1097      * The approval is cleared when the token is burned.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _burn(uint256 tokenId) internal virtual {
1106         address owner = ERC721.ownerOf(tokenId);
1107 
1108         _beforeTokenTransfer(owner, address(0), tokenId);
1109 
1110         // Clear approvals
1111         _approve(address(0), tokenId);
1112 
1113         _balances[owner] -= 1;
1114         delete _owners[tokenId];
1115 
1116         emit Transfer(owner, address(0), tokenId);
1117 
1118         _afterTokenTransfer(owner, address(0), tokenId);
1119     }
1120 
1121     /**
1122      * @dev Transfers `tokenId` from `from` to `to`.
1123      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must be owned by `from`.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _transfer(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) internal virtual {
1137         require(
1138             ERC721.ownerOf(tokenId) == from,
1139             "ERC721: transfer from incorrect owner"
1140         );
1141         require(to != address(0), "ERC721: transfer to the zero address");
1142 
1143         _beforeTokenTransfer(from, to, tokenId);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId);
1147 
1148         _balances[from] -= 1;
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(from, to, tokenId);
1153 
1154         _afterTokenTransfer(from, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev Approve `to` to operate on `tokenId`
1159      *
1160      * Emits a {Approval} event.
1161      */
1162     function _approve(address to, uint256 tokenId) internal virtual {
1163         _tokenApprovals[tokenId] = to;
1164         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev Approve `operator` to operate on all of `owner` tokens
1169      *
1170      * Emits a {ApprovalForAll} event.
1171      */
1172     function _setApprovalForAll(
1173         address owner,
1174         address operator,
1175         bool approved
1176     ) internal virtual {
1177         require(owner != operator, "ERC721: approve to caller");
1178         _operatorApprovals[owner][operator] = approved;
1179         emit ApprovalForAll(owner, operator, approved);
1180     }
1181 
1182     /**
1183      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1184      * The call is not executed if the target address is not a contract.
1185      *
1186      * @param from address representing the previous owner of the given token ID
1187      * @param to target address that will receive the tokens
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @param _data bytes optional data to send along with the call
1190      * @return bool whether the call correctly returned the expected magic value
1191      */
1192     function _checkOnERC721Received(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) private returns (bool) {
1198         if (to.isContract()) {
1199             try
1200                 IERC721Receiver(to).onERC721Received(
1201                     _msgSender(),
1202                     from,
1203                     tokenId,
1204                     _data
1205                 )
1206             returns (bytes4 retval) {
1207                 return retval == IERC721Receiver.onERC721Received.selector;
1208             } catch (bytes memory reason) {
1209                 if (reason.length == 0) {
1210                     revert(
1211                         "ERC721: transfer to non ERC721Receiver implementer"
1212                     );
1213                 } else {
1214                     assembly {
1215                         revert(add(32, reason), mload(reason))
1216                     }
1217                 }
1218             }
1219         } else {
1220             return true;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before any token transfer. This includes minting
1226      * and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1234      * - `from` and `to` are never both zero.
1235      *
1236      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1237      */
1238     function _beforeTokenTransfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after any transfer of tokens. This includes
1246      * minting and burning.
1247      *
1248      * Calling conditions:
1249      *
1250      * - when `from` and `to` are both non-zero.
1251      * - `from` and `to` are never both zero.
1252      *
1253      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1254      */
1255     function _afterTokenTransfer(
1256         address from,
1257         address to,
1258         uint256 tokenId
1259     ) internal virtual {}
1260 }
1261 
1262 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1263 
1264 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 /**
1269  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1270  * @dev See https://eips.ethereum.org/EIPS/eip-721
1271  */
1272 interface IERC721Enumerable is IERC721 {
1273     /**
1274      * @dev Returns the total amount of tokens stored by the contract.
1275      */
1276     function totalSupply() external view returns (uint256);
1277 
1278     /**
1279      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1280      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1281      */
1282     function tokenOfOwnerByIndex(address owner, uint256 index)
1283         external
1284         view
1285         returns (uint256);
1286 
1287     /**
1288      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1289      * Use along with {totalSupply} to enumerate all tokens.
1290      */
1291     function tokenByIndex(uint256 index) external view returns (uint256);
1292 }
1293 
1294 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1295 
1296 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 /**
1301  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1302  * enumerability of all the token ids in the contract as well as all token ids owned by each
1303  * account.
1304  */
1305 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1306     // Mapping from owner to list of owned token IDs
1307     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1308 
1309     // Mapping from token ID to index of the owner tokens list
1310     mapping(uint256 => uint256) private _ownedTokensIndex;
1311 
1312     // Array with all token ids, used for enumeration
1313     uint256[] private _allTokens;
1314 
1315     // Mapping from token id to position in the allTokens array
1316     mapping(uint256 => uint256) private _allTokensIndex;
1317 
1318     /**
1319      * @dev See {IERC165-supportsInterface}.
1320      */
1321     function supportsInterface(bytes4 interfaceId)
1322         public
1323         view
1324         virtual
1325         override(IERC165, ERC721)
1326         returns (bool)
1327     {
1328         return
1329             interfaceId == type(IERC721Enumerable).interfaceId ||
1330             super.supportsInterface(interfaceId);
1331     }
1332 
1333     /**
1334      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1335      */
1336     function tokenOfOwnerByIndex(address owner, uint256 index)
1337         public
1338         view
1339         virtual
1340         override
1341         returns (uint256)
1342     {
1343         require(
1344             index < ERC721.balanceOf(owner),
1345             "ERC721Enumerable: owner index out of bounds"
1346         );
1347         return _ownedTokens[owner][index];
1348     }
1349 
1350     /**
1351      * @dev See {IERC721Enumerable-totalSupply}.
1352      */
1353     function totalSupply() public view virtual override returns (uint256) {
1354         return _allTokens.length;
1355     }
1356 
1357     /**
1358      * @dev See {IERC721Enumerable-tokenByIndex}.
1359      */
1360     function tokenByIndex(uint256 index)
1361         public
1362         view
1363         virtual
1364         override
1365         returns (uint256)
1366     {
1367         require(
1368             index < ERC721Enumerable.totalSupply(),
1369             "ERC721Enumerable: global index out of bounds"
1370         );
1371         return _allTokens[index];
1372     }
1373 
1374     /**
1375      * @dev Hook that is called before any token transfer. This includes minting
1376      * and burning.
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` will be minted for `to`.
1383      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1384      * - `from` cannot be the zero address.
1385      * - `to` cannot be the zero address.
1386      *
1387      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1388      */
1389     function _beforeTokenTransfer(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) internal virtual override {
1394         super._beforeTokenTransfer(from, to, tokenId);
1395 
1396         if (from == address(0)) {
1397             _addTokenToAllTokensEnumeration(tokenId);
1398         } else if (from != to) {
1399             _removeTokenFromOwnerEnumeration(from, tokenId);
1400         }
1401         if (to == address(0)) {
1402             _removeTokenFromAllTokensEnumeration(tokenId);
1403         } else if (to != from) {
1404             _addTokenToOwnerEnumeration(to, tokenId);
1405         }
1406     }
1407 
1408     /**
1409      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1410      * @param to address representing the new owner of the given token ID
1411      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1412      */
1413     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1414         uint256 length = ERC721.balanceOf(to);
1415         _ownedTokens[to][length] = tokenId;
1416         _ownedTokensIndex[tokenId] = length;
1417     }
1418 
1419     /**
1420      * @dev Private function to add a token to this extension's token tracking data structures.
1421      * @param tokenId uint256 ID of the token to be added to the tokens list
1422      */
1423     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1424         _allTokensIndex[tokenId] = _allTokens.length;
1425         _allTokens.push(tokenId);
1426     }
1427 
1428     /**
1429      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1430      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1431      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1432      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1433      * @param from address representing the previous owner of the given token ID
1434      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1435      */
1436     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1437         private
1438     {
1439         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1440         // then delete the last slot (swap and pop).
1441 
1442         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1443         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1444 
1445         // When the token to delete is the last token, the swap operation is unnecessary
1446         if (tokenIndex != lastTokenIndex) {
1447             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1448 
1449             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1450             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1451         }
1452 
1453         // This also deletes the contents at the last position of the array
1454         delete _ownedTokensIndex[tokenId];
1455         delete _ownedTokens[from][lastTokenIndex];
1456     }
1457 
1458     /**
1459      * @dev Private function to remove a token from this extension's token tracking data structures.
1460      * This has O(1) time complexity, but alters the order of the _allTokens array.
1461      * @param tokenId uint256 ID of the token to be removed from the tokens list
1462      */
1463     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1464         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1465         // then delete the last slot (swap and pop).
1466 
1467         uint256 lastTokenIndex = _allTokens.length - 1;
1468         uint256 tokenIndex = _allTokensIndex[tokenId];
1469 
1470         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1471         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1472         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1473         uint256 lastTokenId = _allTokens[lastTokenIndex];
1474 
1475         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1476         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1477 
1478         // This also deletes the contents at the last position of the array
1479         delete _allTokensIndex[tokenId];
1480         _allTokens.pop();
1481     }
1482 }
1483 
1484 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.5.0
1485 
1486 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 /**
1491  * @dev ERC721 token with storage based token URI management.
1492  */
1493 abstract contract ERC721URIStorage is ERC721 {
1494     using Strings for uint256;
1495 
1496     // Optional mapping for token URIs
1497     mapping(uint256 => string) private _tokenURIs;
1498 
1499     /**
1500      * @dev See {IERC721Metadata-tokenURI}.
1501      */
1502     function tokenURI(uint256 tokenId)
1503         public
1504         view
1505         virtual
1506         override
1507         returns (string memory)
1508     {
1509         require(
1510             _exists(tokenId),
1511             "ERC721URIStorage: URI query for nonexistent token"
1512         );
1513 
1514         string memory _tokenURI = _tokenURIs[tokenId];
1515         string memory base = _baseURI();
1516 
1517         // If there is no base URI, return the token URI.
1518         if (bytes(base).length == 0) {
1519             return _tokenURI;
1520         }
1521         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1522         if (bytes(_tokenURI).length > 0) {
1523             return string(abi.encodePacked(base, _tokenURI));
1524         }
1525 
1526         return super.tokenURI(tokenId);
1527     }
1528 
1529     /**
1530      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1531      *
1532      * Requirements:
1533      *
1534      * - `tokenId` must exist.
1535      */
1536     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1537         internal
1538         virtual
1539     {
1540         require(
1541             _exists(tokenId),
1542             "ERC721URIStorage: URI set of nonexistent token"
1543         );
1544         _tokenURIs[tokenId] = _tokenURI;
1545     }
1546 
1547     /**
1548      * @dev Destroys `tokenId`.
1549      * The approval is cleared when the token is burned.
1550      *
1551      * Requirements:
1552      *
1553      * - `tokenId` must exist.
1554      *
1555      * Emits a {Transfer} event.
1556      */
1557     function _burn(uint256 tokenId) internal virtual override {
1558         super._burn(tokenId);
1559 
1560         if (bytes(_tokenURIs[tokenId]).length != 0) {
1561             delete _tokenURIs[tokenId];
1562         }
1563     }
1564 }
1565 
1566 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
1567 
1568 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1569 
1570 pragma solidity ^0.8.0;
1571 
1572 /**
1573  * @title Counters
1574  * @author Matt Condon (@shrugs)
1575  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1576  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1577  *
1578  * Include with `using Counters for Counters.Counter;`
1579  */
1580 library Counters {
1581     struct Counter {
1582         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1583         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1584         // this feature: see https://github.com/ethereum/solidity/issues/4637
1585         uint256 _value; // default: 0
1586     }
1587 
1588     function current(Counter storage counter) internal view returns (uint256) {
1589         return counter._value;
1590     }
1591 
1592     function increment(Counter storage counter) internal {
1593         unchecked {
1594             counter._value += 1;
1595         }
1596     }
1597 
1598     function decrement(Counter storage counter) internal {
1599         uint256 value = counter._value;
1600         require(value > 0, "Counter: decrement overflow");
1601         unchecked {
1602             counter._value = value - 1;
1603         }
1604     }
1605 
1606     function reset(Counter storage counter) internal {
1607         counter._value = 0;
1608     }
1609 }
1610 
1611 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1612 
1613 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1614 
1615 pragma solidity ^0.8.0;
1616 
1617 /**
1618  * @dev These functions deal with verification of Merkle Trees proofs.
1619  *
1620  * The proofs can be generated using the JavaScript library
1621  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1622  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1623  *
1624  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1625  */
1626 library MerkleProof {
1627     /**
1628      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1629      * defined by `root`. For this, a `proof` must be provided, containing
1630      * sibling hashes on the branch from the leaf to the root of the tree. Each
1631      * pair of leaves and each pair of pre-images are assumed to be sorted.
1632      */
1633     function verify(
1634         bytes32[] memory proof,
1635         bytes32 root,
1636         bytes32 leaf
1637     ) internal pure returns (bool) {
1638         return processProof(proof, leaf) == root;
1639     }
1640 
1641     /**
1642      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1643      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1644      * hash matches the root of the tree. When processing the proof, the pairs
1645      * of leafs & pre-images are assumed to be sorted.
1646      *
1647      * _Available since v4.4._
1648      */
1649     function processProof(bytes32[] memory proof, bytes32 leaf)
1650         internal
1651         pure
1652         returns (bytes32)
1653     {
1654         bytes32 computedHash = leaf;
1655         for (uint256 i = 0; i < proof.length; i++) {
1656             bytes32 proofElement = proof[i];
1657             if (computedHash <= proofElement) {
1658                 // Hash(current computed hash + current element of the proof)
1659                 computedHash = _efficientHash(computedHash, proofElement);
1660             } else {
1661                 // Hash(current element of the proof + current computed hash)
1662                 computedHash = _efficientHash(proofElement, computedHash);
1663             }
1664         }
1665         return computedHash;
1666     }
1667 
1668     function _efficientHash(bytes32 a, bytes32 b)
1669         private
1670         pure
1671         returns (bytes32 value)
1672     {
1673         assembly {
1674             mstore(0x00, a)
1675             mstore(0x20, b)
1676             value := keccak256(0x00, 0x40)
1677         }
1678     }
1679 }
1680 
1681 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
1682 
1683 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1684 
1685 pragma solidity ^0.8.0;
1686 
1687 // CAUTION
1688 // This version of SafeMath should only be used with Solidity 0.8 or later,
1689 // because it relies on the compiler's built in overflow checks.
1690 
1691 /**
1692  * @dev Wrappers over Solidity's arithmetic operations.
1693  *
1694  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1695  * now has built in overflow checking.
1696  */
1697 library SafeMath {
1698     /**
1699      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1700      *
1701      * _Available since v3.4._
1702      */
1703     function tryAdd(uint256 a, uint256 b)
1704         internal
1705         pure
1706         returns (bool, uint256)
1707     {
1708         unchecked {
1709             uint256 c = a + b;
1710             if (c < a) return (false, 0);
1711             return (true, c);
1712         }
1713     }
1714 
1715     /**
1716      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1717      *
1718      * _Available since v3.4._
1719      */
1720     function trySub(uint256 a, uint256 b)
1721         internal
1722         pure
1723         returns (bool, uint256)
1724     {
1725         unchecked {
1726             if (b > a) return (false, 0);
1727             return (true, a - b);
1728         }
1729     }
1730 
1731     /**
1732      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1733      *
1734      * _Available since v3.4._
1735      */
1736     function tryMul(uint256 a, uint256 b)
1737         internal
1738         pure
1739         returns (bool, uint256)
1740     {
1741         unchecked {
1742             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1743             // benefit is lost if 'b' is also tested.
1744             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1745             if (a == 0) return (true, 0);
1746             uint256 c = a * b;
1747             if (c / a != b) return (false, 0);
1748             return (true, c);
1749         }
1750     }
1751 
1752     /**
1753      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1754      *
1755      * _Available since v3.4._
1756      */
1757     function tryDiv(uint256 a, uint256 b)
1758         internal
1759         pure
1760         returns (bool, uint256)
1761     {
1762         unchecked {
1763             if (b == 0) return (false, 0);
1764             return (true, a / b);
1765         }
1766     }
1767 
1768     /**
1769      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1770      *
1771      * _Available since v3.4._
1772      */
1773     function tryMod(uint256 a, uint256 b)
1774         internal
1775         pure
1776         returns (bool, uint256)
1777     {
1778         unchecked {
1779             if (b == 0) return (false, 0);
1780             return (true, a % b);
1781         }
1782     }
1783 
1784     /**
1785      * @dev Returns the addition of two unsigned integers, reverting on
1786      * overflow.
1787      *
1788      * Counterpart to Solidity's `+` operator.
1789      *
1790      * Requirements:
1791      *
1792      * - Addition cannot overflow.
1793      */
1794     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1795         return a + b;
1796     }
1797 
1798     /**
1799      * @dev Returns the subtraction of two unsigned integers, reverting on
1800      * overflow (when the result is negative).
1801      *
1802      * Counterpart to Solidity's `-` operator.
1803      *
1804      * Requirements:
1805      *
1806      * - Subtraction cannot overflow.
1807      */
1808     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1809         return a - b;
1810     }
1811 
1812     /**
1813      * @dev Returns the multiplication of two unsigned integers, reverting on
1814      * overflow.
1815      *
1816      * Counterpart to Solidity's `*` operator.
1817      *
1818      * Requirements:
1819      *
1820      * - Multiplication cannot overflow.
1821      */
1822     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1823         return a * b;
1824     }
1825 
1826     /**
1827      * @dev Returns the integer division of two unsigned integers, reverting on
1828      * division by zero. The result is rounded towards zero.
1829      *
1830      * Counterpart to Solidity's `/` operator.
1831      *
1832      * Requirements:
1833      *
1834      * - The divisor cannot be zero.
1835      */
1836     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1837         return a / b;
1838     }
1839 
1840     /**
1841      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1842      * reverting when dividing by zero.
1843      *
1844      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1845      * opcode (which leaves remaining gas untouched) while Solidity uses an
1846      * invalid opcode to revert (consuming all remaining gas).
1847      *
1848      * Requirements:
1849      *
1850      * - The divisor cannot be zero.
1851      */
1852     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1853         return a % b;
1854     }
1855 
1856     /**
1857      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1858      * overflow (when the result is negative).
1859      *
1860      * CAUTION: This function is deprecated because it requires allocating memory for the error
1861      * message unnecessarily. For custom revert reasons use {trySub}.
1862      *
1863      * Counterpart to Solidity's `-` operator.
1864      *
1865      * Requirements:
1866      *
1867      * - Subtraction cannot overflow.
1868      */
1869     function sub(
1870         uint256 a,
1871         uint256 b,
1872         string memory errorMessage
1873     ) internal pure returns (uint256) {
1874         unchecked {
1875             require(b <= a, errorMessage);
1876             return a - b;
1877         }
1878     }
1879 
1880     /**
1881      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1882      * division by zero. The result is rounded towards zero.
1883      *
1884      * Counterpart to Solidity's `/` operator. Note: this function uses a
1885      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1886      * uses an invalid opcode to revert (consuming all remaining gas).
1887      *
1888      * Requirements:
1889      *
1890      * - The divisor cannot be zero.
1891      */
1892     function div(
1893         uint256 a,
1894         uint256 b,
1895         string memory errorMessage
1896     ) internal pure returns (uint256) {
1897         unchecked {
1898             require(b > 0, errorMessage);
1899             return a / b;
1900         }
1901     }
1902 
1903     /**
1904      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1905      * reverting with custom message when dividing by zero.
1906      *
1907      * CAUTION: This function is deprecated because it requires allocating memory for the error
1908      * message unnecessarily. For custom revert reasons use {tryMod}.
1909      *
1910      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1911      * opcode (which leaves remaining gas untouched) while Solidity uses an
1912      * invalid opcode to revert (consuming all remaining gas).
1913      *
1914      * Requirements:
1915      *
1916      * - The divisor cannot be zero.
1917      */
1918     function mod(
1919         uint256 a,
1920         uint256 b,
1921         string memory errorMessage
1922     ) internal pure returns (uint256) {
1923         unchecked {
1924             require(b > 0, errorMessage);
1925             return a % b;
1926         }
1927     }
1928 }
1929 
1930 // File contracts/LurkDrop.sol
1931 
1932 pragma solidity ^0.8.0;
1933 
1934 contract LurkDrop is ERC721URIStorage, ERC721Enumerable, Ownable {
1935     using SafeMath for uint256;
1936     using Strings for uint256;
1937     using Counters for Counters.Counter;
1938 
1939     Counters.Counter private _tokenIds;
1940 
1941     string public baseExtension = ".json";
1942     string public baseURI = "";
1943 
1944     uint256 public MAX_TOKEN_SUPPLY = 5000;
1945     bool isSpawnPeriod = false;
1946 
1947     uint256 public currentMintStage = 0;
1948     uint256 public currentMintStageLimit = 0;
1949     uint256 public currentMintStageLimitPerWallet = 0;
1950     uint256 public currentMintStageRate = 0;
1951     bool public currrentStageIsPublic = false;
1952     bytes32 public currentMintStageMerkleRoot;
1953     uint256 public currentLimitPerWalletCounter = 0;
1954 
1955     uint256 public currentMintStageOpeningTime = 0;
1956     uint256 public currentMintStageClosingTime = 0;
1957 
1958     uint256 public currentSpawnPeriod = 0;
1959     uint256 public currentSpawnOpeningTime = 0;
1960     uint256 public currentSpawnClosingTime = 0;
1961     uint256 public currentSpawnRate = 0;
1962 
1963     uint256 private discountPerBasicTokenBurn = 2 * 10**16;
1964     uint256 private goldTokenCountForFreeMint = 2;
1965 
1966     mapping(uint256 => mapping(uint256 => bool)) public spawnClaimList;
1967     mapping(uint256 => mapping(uint256 => bool)) public recentlySpawnList;
1968     mapping(uint256 => mapping(address => uint256)) public walletMintCount;
1969 
1970     address public lurkAddress = 0x298e30553c179969C8F9eA80e5918E82EF8d1a38;
1971     address public remixAddress = 0xbda1E2757f9A8973926120F6977756B2468B79bb;
1972     address public devAddress = 0x2412C008ED3CAaBfBD2bF9Ee73D9fDB6F2180A21;
1973 
1974     address public INCINERATOR_CONTRACT_ADDRESS;
1975     uint256 private constant BATCH_LIMIT = 20;
1976 
1977     uint256 private mintLurkPct = 60;
1978     uint256 private mintRemixPct = 34;
1979     uint256 private mintDevPct = 6;
1980 
1981     uint256 private spawnLurkPct = 40;
1982     uint256 private spawnRemixPct = 54;
1983     uint256 private spawnDevPct = 6;
1984 
1985     event SetMintStage(
1986         uint256 indexed _stage,
1987         uint256 _stageLimit,
1988         uint256 _stageLimitPerWallet,
1989         uint256 _rate,
1990         uint256 _openingTime,
1991         uint256 _closingTIme
1992     );
1993 
1994     event SetSpawnPeriod(
1995         uint256 indexed _spawnPeriod,
1996         uint256 _openingTime,
1997         uint256 _closingTime,
1998         uint256 _spawnRate
1999     );
2000 
2001     event Claim(address indexed _recipient, uint256 _tokenId, uint256 _stage);
2002 
2003     event Spawn(address indexed _recipient, uint256 _spawner, uint256 _spawned);
2004 
2005     event SpawnGiveaway(address indexed _recipient, uint256 _spawned);
2006 
2007     event PaymentSplit(uint256 _lurk, uint256 _remix, uint256 _dev);
2008 
2009     constructor(address _incineratorAddress) ERC721("Lurk Drop", "LURK") {
2010         INCINERATOR_CONTRACT_ADDRESS = _incineratorAddress;
2011     }
2012 
2013     function tokenURI(uint256 _tokenId)
2014         public
2015         view
2016         override(ERC721, ERC721URIStorage)
2017         returns (string memory)
2018     {
2019         require(_tokenId > 0, "URI requested for invalid token");
2020         return
2021             bytes(baseURI).length > 0
2022                 ? string(
2023                     abi.encodePacked(
2024                         baseURI,
2025                         _tokenId.toString(),
2026                         baseExtension
2027                     )
2028                 )
2029                 : baseURI;
2030     }
2031 
2032     function setBaseURI(string memory _baseURI) public onlyOwner {
2033         baseURI = _baseURI;
2034     }
2035 
2036     function setBaseExtension(string memory _newBaseExtension)
2037         public
2038         onlyOwner
2039     {
2040         baseExtension = _newBaseExtension;
2041     }
2042 
2043     function setMintStage(
2044         uint256 _stage,
2045         uint256 _stageLimit,
2046         uint256 _stageLimitPerWallet,
2047         uint256 _rate,
2048         uint256 _openingTime,
2049         uint256 _closingTime,
2050         bytes32 _whitelistMerkleRoot,
2051         bool _isPublic,
2052         bool _resetClaimCounter
2053     ) public onlyOwner {
2054         require(_stage != currentMintStage, "LURK: Stage same as previous");
2055         require(_openingTime < _closingTime, "LURK: Invalid duration");
2056 
2057         currentMintStage = _stage;
2058         currentMintStageLimit = _stageLimit;
2059         currentMintStageLimitPerWallet = _stageLimitPerWallet;
2060         currentMintStageRate = _rate;
2061         currentMintStageMerkleRoot = _whitelistMerkleRoot;
2062 
2063         currentMintStageOpeningTime = _openingTime;
2064         currentMintStageClosingTime = _closingTime;
2065         currrentStageIsPublic = _isPublic;
2066 
2067         if (_resetClaimCounter) {
2068             currentLimitPerWalletCounter = currentLimitPerWalletCounter + 1;
2069         }
2070 
2071         emit SetMintStage(
2072             _stage,
2073             _stageLimit,
2074             _stageLimitPerWallet,
2075             _rate,
2076             _openingTime,
2077             _closingTime
2078         );
2079     }
2080 
2081     function setSpawnPeriod(
2082         uint256 _openingTime,
2083         uint256 _closingTime,
2084         uint256 _rate
2085     ) public onlyOwner {
2086         require(_openingTime < _closingTime, "LURK: Invalid duration");
2087 
2088         isSpawnPeriod = true;
2089 
2090         currentSpawnPeriod = currentSpawnPeriod + 1;
2091         currentSpawnOpeningTime = _openingTime;
2092         currentSpawnClosingTime = _closingTime;
2093         currentSpawnRate = _rate;
2094 
2095         emit SetSpawnPeriod(
2096             currentSpawnPeriod,
2097             _openingTime,
2098             _closingTime,
2099             _rate
2100         );
2101     }
2102 
2103     function isClaimOpen() public view returns (bool) {
2104         return
2105             block.timestamp >= currentMintStageOpeningTime &&
2106             block.timestamp <= currentMintStageClosingTime;
2107     }
2108 
2109     function isSpawnOpen() public view returns (bool) {
2110         return
2111             block.timestamp >= currentSpawnOpeningTime &&
2112             block.timestamp <= currentSpawnClosingTime;
2113     }
2114 
2115     function spawn(uint256[] calldata _ids) public payable {
2116         address sender = msg.sender;
2117         uint256 sentAmount = msg.value;
2118         uint256 requiredPayment = currentSpawnRate.mul(_ids.length);
2119 
2120         require(_ids.length <= BATCH_LIMIT, "LURK: Batch more than limit");
2121         require(isSpawnOpen(), "LURK: Spawn Not Open");
2122         require(
2123             sentAmount >= requiredPayment,
2124             "LURK: Payment amount not enough"
2125         );
2126 
2127         for (uint256 i = 0; i < _ids.length; i++) {
2128             address tokenOwner = ownerOf(_ids[i]);
2129 
2130             require(tokenOwner == sender, "LURK: Sender is not owner");
2131             require(
2132                 recentlySpawnList[currentSpawnPeriod][_ids[i]] == false,
2133                 "LURK: Has just been spawned"
2134             );
2135             require(
2136                 spawnClaimList[currentSpawnPeriod][_ids[i]] == false,
2137                 "LURK: Has already spawned"
2138             );
2139 
2140             uint256 spawnedTokenId = mint(sender);
2141 
2142             spawnClaimList[currentSpawnPeriod][_ids[i]] = true;
2143             recentlySpawnList[currentSpawnPeriod][spawnedTokenId] = true;
2144 
2145             emit Spawn(sender, _ids[i], spawnedTokenId);
2146         }
2147     }
2148 
2149     function claim(bytes32[] calldata _merkleProof, uint256 _mintAmount)
2150         public
2151         payable
2152     {
2153         uint256 requiredPayment = _mintAmount.mul(currentMintStageRate);
2154 
2155         _verifyClaim(_merkleProof, _mintAmount, requiredPayment);
2156         _claim(_mintAmount);
2157     }
2158 
2159     function _verifyClaim(
2160         bytes32[] calldata _merkleProof,
2161         uint256 _mintAmount,
2162         uint256 _requiredpayment
2163     ) private {
2164         address sender = msg.sender;
2165         uint256 sentAmount = msg.value;
2166         uint256 mintCount = walletMintCount[currentLimitPerWalletCounter][
2167             sender
2168         ];
2169 
2170         require(
2171             _mintAmount > 0 && _mintAmount <= BATCH_LIMIT,
2172             "LURK: Mint Amount invalid"
2173         );
2174         require(isSpawnPeriod == false, "LURK: Spawn Started");
2175         require(isClaimOpen(), "LURK: Claim Not Open");
2176 
2177         if (!currrentStageIsPublic) {
2178             require(
2179                 tokensMinted().add(_mintAmount) <= currentMintStageLimit,
2180                 "LURK: Reached Mint Stage Limit"
2181             );
2182             require(
2183                 currentMintStageLimitPerWallet == 0 ||
2184                     mintCount.add(_mintAmount) <=
2185                     currentMintStageLimitPerWallet,
2186                 "LURK: Reached Mint Wallet Limit"
2187             );
2188 
2189             bytes32 leaf = keccak256(abi.encodePacked(sender));
2190             require(
2191                 MerkleProof.verify(
2192                     _merkleProof,
2193                     currentMintStageMerkleRoot,
2194                     leaf
2195                 ),
2196                 "LURK: Not in whitelist"
2197             );
2198         }
2199 
2200         require(
2201             sentAmount >= _requiredpayment,
2202             "LURK: Payment amount not enough"
2203         );
2204     }
2205 
2206     function _claim(uint256 _mintAmount) private {
2207         address sender = msg.sender;
2208         uint256 mintCount = walletMintCount[currentLimitPerWalletCounter][
2209             sender
2210         ];
2211 
2212         for (uint256 i = 0; i < _mintAmount; i++) {
2213             uint256 tokenId = mint(sender);
2214             emit Claim(sender, tokenId, currentMintStage);
2215         }
2216 
2217         walletMintCount[currentLimitPerWalletCounter][sender] = mintCount.add(
2218             _mintAmount
2219         );
2220     }
2221 
2222     function claimWithBurn(
2223         bytes32[] calldata _merkleProof,
2224         uint256 _numGoldTokens,
2225         uint256 _numBasicTokens,
2226         uint256 _mintAmount
2227     ) public payable {
2228         uint256 tokensToMint;
2229         uint256 requiredPayment = 0;
2230 
2231         require(
2232             _numGoldTokens > 0 || _numBasicTokens > 0,
2233             "LURK: Tokens required to mint"
2234         );
2235 
2236         if (_numGoldTokens > 0) {
2237             require(
2238                 _numGoldTokens % 2 == 0,
2239                 "LURK: Gold must be multiple of 2"
2240             );
2241             tokensToMint = _numGoldTokens / 2;
2242         } else {
2243             require(_mintAmount > 0, "LURK: Mint Amount invalid");
2244             uint256 discountRate = _numBasicTokens.mul(
2245                 discountPerBasicTokenBurn
2246             );
2247             requiredPayment = _mintAmount.mul(currentMintStageRate);
2248             tokensToMint = _mintAmount;
2249 
2250             require(discountRate <= requiredPayment, "LURK: Discount invalid");
2251             requiredPayment = requiredPayment.sub(discountRate);
2252         }
2253 
2254         _verifyClaim(_merkleProof, tokensToMint, requiredPayment);
2255         _incinerateTokens(_numGoldTokens, _numBasicTokens);
2256         _claim(tokensToMint);
2257     }
2258 
2259     function _incinerateTokens(uint256 _numGoldTokens, uint256 _numBasicTokens)
2260         private
2261     {
2262         IMintClubIncinerator incineratorContract = IMintClubIncinerator(
2263             INCINERATOR_CONTRACT_ADDRESS
2264         );
2265 
2266         if (_numGoldTokens > 0) {
2267             incineratorContract.burnGoldTokens(msg.sender, _numGoldTokens);
2268         } else {
2269             incineratorContract.burnBasicTokens(msg.sender, _numBasicTokens);
2270         }
2271     }
2272 
2273     function splitPayment() public {
2274         uint256 contractBalance = address(this).balance;
2275 
2276         uint256 lurkPct = mintLurkPct;
2277         uint256 remixPct = mintRemixPct;
2278 
2279         if (isSpawnPeriod) {
2280             lurkPct = spawnLurkPct;
2281             remixPct = spawnRemixPct;
2282         }
2283 
2284         uint256 lurkSplit = contractBalance.mul(lurkPct).div(100);
2285         _sendSplit(lurkAddress, lurkSplit);
2286 
2287         uint256 remixSplit = contractBalance.mul(remixPct).div(100);
2288         _sendSplit(remixAddress, remixSplit);
2289 
2290         uint256 devSplit = address(this).balance;
2291         _sendSplit(devAddress, devSplit);
2292 
2293         emit PaymentSplit(lurkSplit, remixSplit, devSplit);
2294     }
2295 
2296     function _sendSplit(address _recipient, uint256 value) private {
2297         address payable recipient = payable(_recipient);
2298         Address.sendValue(recipient, value);
2299     }
2300 
2301     function mint(address recipient) private returns (uint256) {
2302         require(
2303             _tokenIds.current() < MAX_TOKEN_SUPPLY,
2304             "LURK: Max Supply reached"
2305         );
2306 
2307         _tokenIds.increment();
2308         uint256 newItemId = _tokenIds.current();
2309         _mint(recipient, newItemId);
2310         return newItemId;
2311     }
2312 
2313     function burn(uint256 tokenId) public {
2314         _burn(tokenId);
2315     }
2316 
2317     function batchAirdrop(address[] calldata _recipients, bool _isSpawnGiveaway)
2318         public
2319         onlyOwner
2320     {
2321         require(
2322             _recipients.length <= BATCH_LIMIT,
2323             "LURK: Batch more than limit"
2324         );
2325 
2326         if (_isSpawnGiveaway) {
2327             require(isSpawnPeriod == true, "LURK: Spawn Not Started");
2328         }
2329 
2330         for (uint256 i = 0; i < _recipients.length; i++) {
2331             uint256 tokenId = mint(_recipients[i]);
2332 
2333             if (_isSpawnGiveaway) {
2334                 spawnClaimList[currentSpawnPeriod][tokenId] = true;
2335                 recentlySpawnList[currentSpawnPeriod][tokenId] = true;
2336 
2337                 emit SpawnGiveaway(_recipients[i], tokenId);
2338             } else {
2339                 emit Claim(_recipients[i], tokenId, currentMintStage);
2340             }
2341         }
2342     }
2343 
2344     function tokensMinted() public view returns (uint256) {
2345         return _tokenIds.current();
2346     }
2347 
2348     function _beforeTokenTransfer(
2349         address from,
2350         address to,
2351         uint256 tokenId
2352     ) internal override(ERC721, ERC721Enumerable) {
2353         super._beforeTokenTransfer(from, to, tokenId);
2354     }
2355 
2356     function _burn(uint256 tokenId)
2357         internal
2358         override(ERC721, ERC721URIStorage)
2359     {
2360         super._burn(tokenId);
2361     }
2362 
2363     function supportsInterface(bytes4 interfaceId)
2364         public
2365         view
2366         override(ERC721, ERC721Enumerable)
2367         returns (bool)
2368     {
2369         return super.supportsInterface(interfaceId);
2370     }
2371 }