1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC165 standard, as defined in the
115  * https://eips.ethereum.org/EIPS/eip-165[EIP].
116  *
117  * Implementers can declare support of contract interfaces, which can then be
118  * queried by others ({ERC165Checker}).
119  *
120  * For an implementation, see {ERC165}.
121  */
122 interface IERC165 {
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30 000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Required interface of an ERC721 compliant contract.
144  */
145 interface IERC721 is IERC165 {
146     /**
147      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
153      */
154     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
155 
156     /**
157      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
158      */
159     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
160 
161     /**
162      * @dev Returns the number of tokens in ``owner``'s account.
163      */
164     function balanceOf(address owner) external view returns (uint256 balance);
165 
166     /**
167      * @dev Returns the owner of the `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function ownerOf(uint256 tokenId) external view returns (address owner);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external;
229 
230     /**
231      * @dev Returns the account approved for `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function getApproved(uint256 tokenId) external view returns (address operator);
238 
239     /**
240      * @dev Approve or remove `operator` as an operator for the caller.
241      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
242      *
243      * Requirements:
244      *
245      * - The `operator` cannot be the caller.
246      *
247      * Emits an {ApprovalForAll} event.
248      */
249     function setApprovalForAll(address operator, bool _approved) external;
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     /**
259      * @dev Safely transfers `tokenId` token from `from` to `to`.
260      *
261      * Requirements:
262      *
263      * - `from` cannot be the zero address.
264      * - `to` cannot be the zero address.
265      * - `tokenId` token must exist and be owned by `from`.
266      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
267      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
268      *
269      * Emits a {Transfer} event.
270      */
271     function safeTransferFrom(
272         address from,
273         address to,
274         uint256 tokenId,
275         bytes calldata data
276     ) external;
277 }
278 
279 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 /**
287  * @title ERC721 token receiver interface
288  * @dev Interface for any contract that wants to support safeTransfers
289  * from ERC721 asset contracts.
290  */
291 interface IERC721Receiver {
292     /**
293      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
294      * by `operator` from `from`, this function is called.
295      *
296      * It must return its Solidity selector to confirm the token transfer.
297      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
298      *
299      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
300      */
301     function onERC721Received(
302         address operator,
303         address from,
304         uint256 tokenId,
305         bytes calldata data
306     ) external returns (bytes4);
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
310 
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
319  * @dev See https://eips.ethereum.org/EIPS/eip-721
320  */
321 interface IERC721Metadata is IERC721 {
322     /**
323      * @dev Returns the token collection name.
324      */
325     function name() external view returns (string memory);
326 
327     /**
328      * @dev Returns the token collection symbol.
329      */
330     function symbol() external view returns (string memory);
331 
332     /**
333      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
334      */
335     function tokenURI(uint256 tokenId) external view returns (string memory);
336 }
337 
338 // File: @openzeppelin/contracts/utils/Address.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         assembly {
373             size := extcodesize(account)
374         }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
531      * revert reason using the provided one.
532      *
533      * _Available since v4.3._
534      */
535     function verifyCallResult(
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal pure returns (bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 // File: @openzeppelin/contracts/utils/Strings.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev String operations.
567  */
568 library Strings {
569     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
573      */
574     function toString(uint256 value) internal pure returns (string memory) {
575         // Inspired by OraclizeAPI's implementation - MIT licence
576         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
577 
578         if (value == 0) {
579             return "0";
580         }
581         uint256 temp = value;
582         uint256 digits;
583         while (temp != 0) {
584             digits++;
585             temp /= 10;
586         }
587         bytes memory buffer = new bytes(digits);
588         while (value != 0) {
589             digits -= 1;
590             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
591             value /= 10;
592         }
593         return string(buffer);
594     }
595 
596     /**
597      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
598      */
599     function toHexString(uint256 value) internal pure returns (string memory) {
600         if (value == 0) {
601             return "0x00";
602         }
603         uint256 temp = value;
604         uint256 length = 0;
605         while (temp != 0) {
606             length++;
607             temp >>= 8;
608         }
609         return toHexString(value, length);
610     }
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
614      */
615     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
616         bytes memory buffer = new bytes(2 * length + 2);
617         buffer[0] = "0";
618         buffer[1] = "x";
619         for (uint256 i = 2 * length + 1; i > 1; --i) {
620             buffer[i] = _HEX_SYMBOLS[value & 0xf];
621             value >>= 4;
622         }
623         require(value == 0, "Strings: hex length insufficient");
624         return string(buffer);
625     }
626 }
627 
628 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
629 
630 
631 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 /**
637  * @dev Implementation of the {IERC165} interface.
638  *
639  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
640  * for the additional interface id that will be supported. For example:
641  *
642  * ```solidity
643  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
644  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
645  * }
646  * ```
647  *
648  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
649  */
650 abstract contract ERC165 is IERC165 {
651     /**
652      * @dev See {IERC165-supportsInterface}.
653      */
654     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
655         return interfaceId == type(IERC165).interfaceId;
656     }
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 
667 
668 
669 
670 
671 
672 
673 /**
674  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
675  * the Metadata extension, but not including the Enumerable extension, which is available separately as
676  * {ERC721Enumerable}.
677  */
678 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
679     using Address for address;
680     using Strings for uint256;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to owner address
689     mapping(uint256 => address) private _owners;
690 
691     // Mapping owner address to token count
692     mapping(address => uint256) private _balances;
693 
694     // Mapping from token ID to approved address
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     /**
701      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
702      */
703     constructor(string memory name_, string memory symbol_) {
704         _name = name_;
705         _symbol = symbol_;
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713             interfaceId == type(IERC721).interfaceId ||
714             interfaceId == type(IERC721Metadata).interfaceId ||
715             super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view virtual override returns (uint256) {
722         require(owner != address(0), "ERC721: balance query for the zero address");
723         return _balances[owner];
724     }
725 
726     /**
727      * @dev See {IERC721-ownerOf}.
728      */
729     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
730         address owner = _owners[tokenId];
731         require(owner != address(0), "ERC721: owner query for nonexistent token");
732         return owner;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-name}.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-symbol}.
744      */
745     function symbol() public view virtual override returns (string memory) {
746         return _symbol;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-tokenURI}.
751      */
752     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
753         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
754 
755         string memory baseURI = _baseURI();
756         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
757     }
758 
759     /**
760      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
761      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
762      * by default, can be overriden in child contracts.
763      */
764     function _baseURI() internal view virtual returns (string memory) {
765         return "";
766     }
767 
768     /**
769      * @dev See {IERC721-approve}.
770      */
771     function approve(address to, uint256 tokenId) public virtual override {
772         address owner = ERC721.ownerOf(tokenId);
773         require(to != owner, "ERC721: approval to current owner");
774 
775         require(
776             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
777             "ERC721: approve caller is not owner nor approved for all"
778         );
779 
780         _approve(to, tokenId);
781     }
782 
783     /**
784      * @dev See {IERC721-getApproved}.
785      */
786     function getApproved(uint256 tokenId) public view virtual override returns (address) {
787         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev See {IERC721-setApprovalForAll}.
794      */
795     function setApprovalForAll(address operator, bool approved) public virtual override {
796         _setApprovalForAll(_msgSender(), operator, approved);
797     }
798 
799     /**
800      * @dev See {IERC721-isApprovedForAll}.
801      */
802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
803         return _operatorApprovals[owner][operator];
804     }
805 
806     /**
807      * @dev See {IERC721-transferFrom}.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         //solhint-disable-next-line max-line-length
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
816 
817         _transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         safeTransferFrom(from, to, tokenId, "");
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) public virtual override {
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841         _safeTransfer(from, to, tokenId, _data);
842     }
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
847      *
848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
849      *
850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
851      * implement alternative mechanisms to perform token transfer, such as signature-based.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeTransfer(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _transfer(from, to, tokenId);
869         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted (`_mint`),
878      * and stop existing when they are burned (`_burn`).
879      */
880     function _exists(uint256 tokenId) internal view virtual returns (bool) {
881         return _owners[tokenId] != address(0);
882     }
883 
884     /**
885      * @dev Returns whether `spender` is allowed to manage `tokenId`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
892         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
893         address owner = ERC721.ownerOf(tokenId);
894         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
895     }
896 
897     /**
898      * @dev Safely mints `tokenId` and transfers it to `to`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeMint(address to, uint256 tokenId) internal virtual {
908         _safeMint(to, tokenId, "");
909     }
910 
911     /**
912      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
913      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
914      */
915     function _safeMint(
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _mint(to, tokenId);
921         require(
922             _checkOnERC721Received(address(0), to, tokenId, _data),
923             "ERC721: transfer to non ERC721Receiver implementer"
924         );
925     }
926 
927     /**
928      * @dev Mints `tokenId` and transfers it to `to`.
929      *
930      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - `to` cannot be the zero address.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944 
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(address(0), to, tokenId);
949     }
950 
951     /**
952      * @dev Destroys `tokenId`.
953      * The approval is cleared when the token is burned.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _burn(uint256 tokenId) internal virtual {
962         address owner = ERC721.ownerOf(tokenId);
963 
964         _beforeTokenTransfer(owner, address(0), tokenId);
965 
966         // Clear approvals
967         _approve(address(0), tokenId);
968 
969         _balances[owner] -= 1;
970         delete _owners[tokenId];
971 
972         emit Transfer(owner, address(0), tokenId);
973     }
974 
975     /**
976      * @dev Transfers `tokenId` from `from` to `to`.
977      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _transfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {
991         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
992         require(to != address(0), "ERC721: transfer to the zero address");
993 
994         _beforeTokenTransfer(from, to, tokenId);
995 
996         // Clear approvals from the previous owner
997         _approve(address(0), tokenId);
998 
999         _balances[from] -= 1;
1000         _balances[to] += 1;
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Approve `to` to operate on `tokenId`
1008      *
1009      * Emits a {Approval} event.
1010      */
1011     function _approve(address to, uint256 tokenId) internal virtual {
1012         _tokenApprovals[tokenId] = to;
1013         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Approve `operator` to operate on all of `owner` tokens
1018      *
1019      * Emits a {ApprovalForAll} event.
1020      */
1021     function _setApprovalForAll(
1022         address owner,
1023         address operator,
1024         bool approved
1025     ) internal virtual {
1026         require(owner != operator, "ERC721: approve to caller");
1027         _operatorApprovals[owner][operator] = approved;
1028         emit ApprovalForAll(owner, operator, approved);
1029     }
1030 
1031     /**
1032      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1033      * The call is not executed if the target address is not a contract.
1034      *
1035      * @param from address representing the previous owner of the given token ID
1036      * @param to target address that will receive the tokens
1037      * @param tokenId uint256 ID of the token to be transferred
1038      * @param _data bytes optional data to send along with the call
1039      * @return bool whether the call correctly returned the expected magic value
1040      */
1041     function _checkOnERC721Received(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) private returns (bool) {
1047         if (to.isContract()) {
1048             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1049                 return retval == IERC721Receiver.onERC721Received.selector;
1050             } catch (bytes memory reason) {
1051                 if (reason.length == 0) {
1052                     revert("ERC721: transfer to non ERC721Receiver implementer");
1053                 } else {
1054                     assembly {
1055                         revert(add(32, reason), mload(reason))
1056                     }
1057                 }
1058             }
1059         } else {
1060             return true;
1061         }
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
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual {}
1083 }
1084 
1085 // File: contracts/ShittyFuckingToken.sol
1086 
1087 
1088 pragma solidity 0.8.0;
1089 
1090 
1091 
1092 contract ShittyFuckingToken is ERC721, Ownable {
1093 
1094     uint256 public tokenCounter = 0;
1095     uint256 public currentSftCount = 200;
1096     bool public saleIsActive = false;
1097 
1098     // Base URI
1099     string private baseURI;
1100 
1101     //Minting Price of SFT
1102     uint256 public sftPrice = 10000000000000000; // 0.01 ETH
1103     
1104     constructor () ERC721 ("Shitty Fucking Tokens", "SFT"){}
1105 
1106     // Withdraw
1107     function withdraw() public onlyOwner {
1108         uint balance = address(this).balance;
1109         payable(msg.sender).transfer(balance);
1110     }
1111 
1112     // Enable/Disable the ability to mint
1113     function flipSaleState() public onlyOwner {
1114         saleIsActive = !saleIsActive;
1115     }
1116 
1117     function setBaseURI(string memory uriString) public onlyOwner {
1118         baseURI = uriString;
1119     }
1120 
1121     function _baseURI() internal view override returns(string memory){
1122         return baseURI;
1123     }
1124 
1125     // Enable/Disable the ability to mint
1126     function setSftCount(uint256 count) public onlyOwner {
1127         currentSftCount = count;
1128     }
1129 
1130     // Enable/Disable the ability to mint
1131     function setSftPrice(uint256 price) public onlyOwner {
1132         sftPrice = price;
1133     }
1134 
1135 
1136 
1137     //Public Mint Shitty Fucking Token
1138     function mintShittyFuckingToken(uint sftTokenId) public payable {
1139         require(saleIsActive, "Sale must be active to mint SFT");
1140         require(sftTokenId > 0 && sftTokenId <=currentSftCount, "Must Pick an sft within valid range");
1141         require(msg.value >= sftPrice, "Ether value sent is not correct");
1142         require(!_exists(sftTokenId), "This SFT was already minted");
1143         
1144         _safeMint(msg.sender, sftTokenId);
1145         tokenCounter = tokenCounter + 1;
1146     }
1147 
1148 
1149     // Special Mint 
1150     function specialMint(uint sftTokenId) public onlyOwner {
1151         require(sftTokenId > 0 && sftTokenId <=currentSftCount, "Must Pick an sft within valid range");
1152         require(!_exists(sftTokenId), "This SFT was already minted");
1153         
1154         _safeMint(msg.sender, sftTokenId);
1155         tokenCounter = tokenCounter + 1;
1156     }
1157 
1158 
1159 
1160 
1161 }