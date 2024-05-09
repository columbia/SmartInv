1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module that helps prevent reentrant calls to a function.
107  *
108  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
109  * available, which can be applied to functions to make sure there are no nested
110  * (reentrant) calls to them.
111  *
112  * Note that because there is a single `nonReentrant` guard, functions marked as
113  * `nonReentrant` may not call one another. This can be worked around by making
114  * those functions `private`, and then adding `external` `nonReentrant` entry
115  * points to them.
116  *
117  * TIP: If you would like to learn more about reentrancy and alternative ways
118  * to protect against it, check out our blog post
119  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
120  */
121 abstract contract ReentrancyGuard {
122     // Booleans are more expensive than uint256 or any type that takes up a full
123     // word because each write operation emits an extra SLOAD to first read the
124     // slot's contents, replace the bits taken up by the boolean, and then write
125     // back. This is the compiler's defense against contract upgrades and
126     // pointer aliasing, and it cannot be disabled.
127 
128     // The values being non-zero value makes deployment a bit more expensive,
129     // but in exchange the refund on every call to nonReentrant will be lower in
130     // amount. Since refunds are capped to a percentage of the total
131     // transaction's gas, it is best to keep them low in cases like this one, to
132     // increase the likelihood of the full refund coming into effect.
133     uint256 private constant _NOT_ENTERED = 1;
134     uint256 private constant _ENTERED = 2;
135 
136     uint256 private _status;
137 
138     constructor() {
139         _status = _NOT_ENTERED;
140     }
141 
142     /**
143      * @dev Prevents a contract from calling itself, directly or indirectly.
144      * Calling a `nonReentrant` function from another `nonReentrant`
145      * function is not supported. It is possible to prevent this from happening
146      * by making the `nonReentrant` function external, and make it call a
147      * `private` function that does the actual work.
148      */
149     modifier nonReentrant() {
150         // On the first call to nonReentrant, _notEntered will be true
151         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
152 
153         // Any calls to nonReentrant after this point will fail
154         _status = _ENTERED;
155 
156         _;
157 
158         // By storing the original value once again, a refund is triggered (see
159         // https://eips.ethereum.org/EIPS/eip-2200)
160         _status = _NOT_ENTERED;
161     }
162 }
163 
164 
165 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
166 
167 
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Interface of the ERC165 standard, as defined in the
173  * https://eips.ethereum.org/EIPS/eip-165[EIP].
174  *
175  * Implementers can declare support of contract interfaces, which can then be
176  * queried by others ({ERC165Checker}).
177  *
178  * For an implementation, see {ERC165}.
179  */
180 interface IERC165 {
181     /**
182      * @dev Returns true if this contract implements the interface defined by
183      * `interfaceId`. See the corresponding
184      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
185      * to learn more about how these ids are created.
186      *
187      * This function call must use less than 30 000 gas.
188      */
189     function supportsInterface(bytes4 interfaceId) external view returns (bool);
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
194 
195 
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Required interface of an ERC721 compliant contract.
201  */
202 interface IERC721 is IERC165 {
203     /**
204      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
205      */
206     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
207 
208     /**
209      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
210      */
211     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
212 
213     /**
214      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
215      */
216     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
217 
218     /**
219      * @dev Returns the number of tokens in ``owner``'s account.
220      */
221     function balanceOf(address owner) external view returns (uint256 balance);
222 
223     /**
224      * @dev Returns the owner of the `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function ownerOf(uint256 tokenId) external view returns (address owner);
231 
232     /**
233      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
234      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must exist and be owned by `from`.
241      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
243      *
244      * Emits a {Transfer} event.
245      */
246     function safeTransferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external;
251 
252     /**
253      * @dev Transfers `tokenId` token from `from` to `to`.
254      *
255      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(
267         address from,
268         address to,
269         uint256 tokenId
270     ) external;
271 
272     /**
273      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
274      * The approval is cleared when the token is transferred.
275      *
276      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
277      *
278      * Requirements:
279      *
280      * - The caller must own the token or be an approved operator.
281      * - `tokenId` must exist.
282      *
283      * Emits an {Approval} event.
284      */
285     function approve(address to, uint256 tokenId) external;
286 
287     /**
288      * @dev Returns the account approved for `tokenId` token.
289      *
290      * Requirements:
291      *
292      * - `tokenId` must exist.
293      */
294     function getApproved(uint256 tokenId) external view returns (address operator);
295 
296     /**
297      * @dev Approve or remove `operator` as an operator for the caller.
298      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
299      *
300      * Requirements:
301      *
302      * - The `operator` cannot be the caller.
303      *
304      * Emits an {ApprovalForAll} event.
305      */
306     function setApprovalForAll(address operator, bool _approved) external;
307 
308     /**
309      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
310      *
311      * See {setApprovalForAll}
312      */
313     function isApprovedForAll(address owner, address operator) external view returns (bool);
314 
315     /**
316      * @dev Safely transfers `tokenId` token from `from` to `to`.
317      *
318      * Requirements:
319      *
320      * - `from` cannot be the zero address.
321      * - `to` cannot be the zero address.
322      * - `tokenId` token must exist and be owned by `from`.
323      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
324      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
325      *
326      * Emits a {Transfer} event.
327      */
328     function safeTransferFrom(
329         address from,
330         address to,
331         uint256 tokenId,
332         bytes calldata data
333     ) external;
334 }
335 
336 
337 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
338 
339 
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @title ERC721 token receiver interface
345  * @dev Interface for any contract that wants to support safeTransfers
346  * from ERC721 asset contracts.
347  */
348 interface IERC721Receiver {
349     /**
350      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
351      * by `operator` from `from`, this function is called.
352      *
353      * It must return its Solidity selector to confirm the token transfer.
354      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
355      *
356      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
357      */
358     function onERC721Received(
359         address operator,
360         address from,
361         uint256 tokenId,
362         bytes calldata data
363     ) external returns (bytes4);
364 }
365 
366 
367 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
368 
369 
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
375  * @dev See https://eips.ethereum.org/EIPS/eip-721
376  */
377 interface IERC721Metadata is IERC721 {
378     /**
379      * @dev Returns the token collection name.
380      */
381     function name() external view returns (string memory);
382 
383     /**
384      * @dev Returns the token collection symbol.
385      */
386     function symbol() external view returns (string memory);
387 
388     /**
389      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
390      */
391     function tokenURI(uint256 tokenId) external view returns (string memory);
392 }
393 
394 
395 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize, which returns 0 for contracts in
424         // construction, since the code is only stored at the end of the
425         // constructor execution.
426 
427         uint256 size;
428         assembly {
429             size := extcodesize(account)
430         }
431         return size > 0;
432     }
433 
434     /**
435      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
436      * `recipient`, forwarding all available gas and reverting on errors.
437      *
438      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
439      * of certain opcodes, possibly making contracts go over the 2300 gas limit
440      * imposed by `transfer`, making them unable to receive funds via
441      * `transfer`. {sendValue} removes this limitation.
442      *
443      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
444      *
445      * IMPORTANT: because control is transferred to `recipient`, care must be
446      * taken to not create reentrancy vulnerabilities. Consider using
447      * {ReentrancyGuard} or the
448      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
449      */
450     function sendValue(address payable recipient, uint256 amount) internal {
451         require(address(this).balance >= amount, "Address: insufficient balance");
452 
453         (bool success, ) = recipient.call{value: amount}("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain `call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionCall(target, data, "Address: low-level call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
481      * `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
514      * with `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         require(isContract(target), "Address: call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.call{value: value}(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
538         return functionStaticCall(target, data, "Address: low-level static call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal view returns (bytes memory) {
552         require(isContract(target), "Address: static call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.staticcall(data);
555         return verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
565         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(isContract(target), "Address: delegate call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.delegatecall(data);
582         return verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     /**
586      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
587      * revert reason using the provided one.
588      *
589      * _Available since v4.3._
590      */
591     function verifyCallResult(
592         bool success,
593         bytes memory returndata,
594         string memory errorMessage
595     ) internal pure returns (bytes memory) {
596         if (success) {
597             return returndata;
598         } else {
599             // Look for revert reason and bubble it up if present
600             if (returndata.length > 0) {
601                 // The easiest way to bubble the revert reason is using memory via assembly
602 
603                 assembly {
604                     let returndata_size := mload(returndata)
605                     revert(add(32, returndata), returndata_size)
606                 }
607             } else {
608                 revert(errorMessage);
609             }
610         }
611     }
612 }
613 
614 
615 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
616 
617 
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @dev String operations.
623  */
624 library Strings {
625     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
626 
627     /**
628      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
629      */
630     function toString(uint256 value) internal pure returns (string memory) {
631         // Inspired by OraclizeAPI's implementation - MIT licence
632         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
633 
634         if (value == 0) {
635             return "0";
636         }
637         uint256 temp = value;
638         uint256 digits;
639         while (temp != 0) {
640             digits++;
641             temp /= 10;
642         }
643         bytes memory buffer = new bytes(digits);
644         while (value != 0) {
645             digits -= 1;
646             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
647             value /= 10;
648         }
649         return string(buffer);
650     }
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
654      */
655     function toHexString(uint256 value) internal pure returns (string memory) {
656         if (value == 0) {
657             return "0x00";
658         }
659         uint256 temp = value;
660         uint256 length = 0;
661         while (temp != 0) {
662             length++;
663             temp >>= 8;
664         }
665         return toHexString(value, length);
666     }
667 
668     /**
669      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
670      */
671     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
672         bytes memory buffer = new bytes(2 * length + 2);
673         buffer[0] = "0";
674         buffer[1] = "x";
675         for (uint256 i = 2 * length + 1; i > 1; --i) {
676             buffer[i] = _HEX_SYMBOLS[value & 0xf];
677             value >>= 4;
678         }
679         require(value == 0, "Strings: hex length insufficient");
680         return string(buffer);
681     }
682 }
683 
684 
685 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
686 
687 
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @dev Implementation of the {IERC165} interface.
693  *
694  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
695  * for the additional interface id that will be supported. For example:
696  *
697  * ```solidity
698  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
700  * }
701  * ```
702  *
703  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
704  */
705 abstract contract ERC165 is IERC165 {
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
710         return interfaceId == type(IERC165).interfaceId;
711     }
712 }
713 
714 
715 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
716 
717 
718 
719 pragma solidity ^0.8.0;
720 
721 
722 
723 
724 
725 
726 
727 /**
728  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
729  * the Metadata extension, but not including the Enumerable extension, which is available separately as
730  * {ERC721Enumerable}.
731  */
732 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
733     using Address for address;
734     using Strings for uint256;
735 
736     // Token name
737     string private _name;
738 
739     // Token symbol
740     string private _symbol;
741 
742     // Mapping from token ID to owner address
743     mapping(uint256 => address) private _owners;
744 
745     // Mapping owner address to token count
746     mapping(address => uint256) private _balances;
747 
748     // Mapping from token ID to approved address
749     mapping(uint256 => address) private _tokenApprovals;
750 
751     // Mapping from owner to operator approvals
752     mapping(address => mapping(address => bool)) private _operatorApprovals;
753 
754     /**
755      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
756      */
757     constructor(string memory name_, string memory symbol_) {
758         _name = name_;
759         _symbol = symbol_;
760     }
761 
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      */
765     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
766         return
767             interfaceId == type(IERC721).interfaceId ||
768             interfaceId == type(IERC721Metadata).interfaceId ||
769             super.supportsInterface(interfaceId);
770     }
771 
772     /**
773      * @dev See {IERC721-balanceOf}.
774      */
775     function balanceOf(address owner) public view virtual override returns (uint256) {
776         require(owner != address(0), "ERC721: balance query for the zero address");
777         return _balances[owner];
778     }
779 
780     /**
781      * @dev See {IERC721-ownerOf}.
782      */
783     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
784         address owner = _owners[tokenId];
785         require(owner != address(0), "ERC721: owner query for nonexistent token");
786         return owner;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-name}.
791      */
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-symbol}.
798      */
799     function symbol() public view virtual override returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-tokenURI}.
805      */
806     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
807         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
808 
809         string memory baseURI = _baseURI();
810         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
811     }
812 
813     /**
814      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
815      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
816      * by default, can be overriden in child contracts.
817      */
818     function _baseURI() internal view virtual returns (string memory) {
819         return "";
820     }
821 
822     /**
823      * @dev See {IERC721-approve}.
824      */
825     function approve(address to, uint256 tokenId) public virtual override {
826         address owner = ERC721.ownerOf(tokenId);
827         require(to != owner, "ERC721: approval to current owner");
828 
829         require(
830             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
831             "ERC721: approve caller is not owner nor approved for all"
832         );
833 
834         _approve(to, tokenId);
835     }
836 
837     /**
838      * @dev See {IERC721-getApproved}.
839      */
840     function getApproved(uint256 tokenId) public view virtual override returns (address) {
841         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
842 
843         return _tokenApprovals[tokenId];
844     }
845 
846     /**
847      * @dev See {IERC721-setApprovalForAll}.
848      */
849     function setApprovalForAll(address operator, bool approved) public virtual override {
850         require(operator != _msgSender(), "ERC721: approve to caller");
851 
852         _operatorApprovals[_msgSender()][operator] = approved;
853         emit ApprovalForAll(_msgSender(), operator, approved);
854     }
855 
856     /**
857      * @dev See {IERC721-isApprovedForAll}.
858      */
859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
860         return _operatorApprovals[owner][operator];
861     }
862 
863     /**
864      * @dev See {IERC721-transferFrom}.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         //solhint-disable-next-line max-line-length
872         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
873 
874         _transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         safeTransferFrom(from, to, tokenId, "");
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) public virtual override {
897         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
898         _safeTransfer(from, to, tokenId, _data);
899     }
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
903      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
904      *
905      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
906      *
907      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
908      * implement alternative mechanisms to perform token transfer, such as signature-based.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeTransfer(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) internal virtual {
925         _transfer(from, to, tokenId);
926         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are minted (`_mint`),
935      * and stop existing when they are burned (`_burn`).
936      */
937     function _exists(uint256 tokenId) internal view virtual returns (bool) {
938         return _owners[tokenId] != address(0);
939     }
940 
941     /**
942      * @dev Returns whether `spender` is allowed to manage `tokenId`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
949         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
950         address owner = ERC721.ownerOf(tokenId);
951         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
952     }
953 
954     /**
955      * @dev Safely mints `tokenId` and transfers it to `to`.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must not exist.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeMint(address to, uint256 tokenId) internal virtual {
965         _safeMint(to, tokenId, "");
966     }
967 
968     /**
969      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
970      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
971      */
972     function _safeMint(
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) internal virtual {
977         _mint(to, tokenId);
978         require(
979             _checkOnERC721Received(address(0), to, tokenId, _data),
980             "ERC721: transfer to non ERC721Receiver implementer"
981         );
982     }
983 
984     /**
985      * @dev Mints `tokenId` and transfers it to `to`.
986      *
987      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
988      *
989      * Requirements:
990      *
991      * - `tokenId` must not exist.
992      * - `to` cannot be the zero address.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _mint(address to, uint256 tokenId) internal virtual {
997         require(to != address(0), "ERC721: mint to the zero address");
998         require(!_exists(tokenId), "ERC721: token already minted");
999 
1000         _beforeTokenTransfer(address(0), to, tokenId);
1001 
1002         _balances[to] += 1;
1003         _owners[tokenId] = to;
1004 
1005         emit Transfer(address(0), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Destroys `tokenId`.
1010      * The approval is cleared when the token is burned.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _burn(uint256 tokenId) internal virtual {
1019         address owner = ERC721.ownerOf(tokenId);
1020 
1021         _beforeTokenTransfer(owner, address(0), tokenId);
1022 
1023         // Clear approvals
1024         _approve(address(0), tokenId);
1025 
1026         _balances[owner] -= 1;
1027         delete _owners[tokenId];
1028 
1029         emit Transfer(owner, address(0), tokenId);
1030     }
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must be owned by `from`.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _transfer(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) internal virtual {
1048         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1049         require(to != address(0), "ERC721: transfer to the zero address");
1050 
1051         _beforeTokenTransfer(from, to, tokenId);
1052 
1053         // Clear approvals from the previous owner
1054         _approve(address(0), tokenId);
1055 
1056         _balances[from] -= 1;
1057         _balances[to] += 1;
1058         _owners[tokenId] = to;
1059 
1060         emit Transfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Approve `to` to operate on `tokenId`
1065      *
1066      * Emits a {Approval} event.
1067      */
1068     function _approve(address to, uint256 tokenId) internal virtual {
1069         _tokenApprovals[tokenId] = to;
1070         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1075      * The call is not executed if the target address is not a contract.
1076      *
1077      * @param from address representing the previous owner of the given token ID
1078      * @param to target address that will receive the tokens
1079      * @param tokenId uint256 ID of the token to be transferred
1080      * @param _data bytes optional data to send along with the call
1081      * @return bool whether the call correctly returned the expected magic value
1082      */
1083     function _checkOnERC721Received(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) private returns (bool) {
1089         if (to.isContract()) {
1090             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1091                 return retval == IERC721Receiver.onERC721Received.selector;
1092             } catch (bytes memory reason) {
1093                 if (reason.length == 0) {
1094                     revert("ERC721: transfer to non ERC721Receiver implementer");
1095                 } else {
1096                     assembly {
1097                         revert(add(32, reason), mload(reason))
1098                     }
1099                 }
1100             }
1101         } else {
1102             return true;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Hook that is called before any token transfer. This includes minting
1108      * and burning.
1109      *
1110      * Calling conditions:
1111      *
1112      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1113      * transferred to `to`.
1114      * - When `from` is zero, `tokenId` will be minted for `to`.
1115      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1116      * - `from` and `to` are never both zero.
1117      *
1118      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1119      */
1120     function _beforeTokenTransfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {}
1125 }
1126 
1127 
1128 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1129 
1130 
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 /**
1135  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1136  * @dev See https://eips.ethereum.org/EIPS/eip-721
1137  */
1138 interface IERC721Enumerable is IERC721 {
1139     /**
1140      * @dev Returns the total amount of tokens stored by the contract.
1141      */
1142     function totalSupply() external view returns (uint256);
1143 
1144     /**
1145      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1146      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1147      */
1148     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1149 
1150     /**
1151      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1152      * Use along with {totalSupply} to enumerate all tokens.
1153      */
1154     function tokenByIndex(uint256 index) external view returns (uint256);
1155 }
1156 
1157 
1158 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1159 
1160 
1161 
1162 pragma solidity ^0.8.0;
1163 
1164 
1165 /**
1166  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1167  * enumerability of all the token ids in the contract as well as all token ids owned by each
1168  * account.
1169  */
1170 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1171     // Mapping from owner to list of owned token IDs
1172     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1173 
1174     // Mapping from token ID to index of the owner tokens list
1175     mapping(uint256 => uint256) private _ownedTokensIndex;
1176 
1177     // Array with all token ids, used for enumeration
1178     uint256[] private _allTokens;
1179 
1180     // Mapping from token id to position in the allTokens array
1181     mapping(uint256 => uint256) private _allTokensIndex;
1182 
1183     /**
1184      * @dev See {IERC165-supportsInterface}.
1185      */
1186     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1187         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1192      */
1193     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1194         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1195         return _ownedTokens[owner][index];
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Enumerable-totalSupply}.
1200      */
1201     function totalSupply() public view virtual override returns (uint256) {
1202         return _allTokens.length;
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-tokenByIndex}.
1207      */
1208     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1209         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1210         return _allTokens[index];
1211     }
1212 
1213     /**
1214      * @dev Hook that is called before any token transfer. This includes minting
1215      * and burning.
1216      *
1217      * Calling conditions:
1218      *
1219      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1220      * transferred to `to`.
1221      * - When `from` is zero, `tokenId` will be minted for `to`.
1222      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1223      * - `from` cannot be the zero address.
1224      * - `to` cannot be the zero address.
1225      *
1226      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1227      */
1228     function _beforeTokenTransfer(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) internal virtual override {
1233         super._beforeTokenTransfer(from, to, tokenId);
1234 
1235         if (from == address(0)) {
1236             _addTokenToAllTokensEnumeration(tokenId);
1237         } else if (from != to) {
1238             _removeTokenFromOwnerEnumeration(from, tokenId);
1239         }
1240         if (to == address(0)) {
1241             _removeTokenFromAllTokensEnumeration(tokenId);
1242         } else if (to != from) {
1243             _addTokenToOwnerEnumeration(to, tokenId);
1244         }
1245     }
1246 
1247     /**
1248      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1249      * @param to address representing the new owner of the given token ID
1250      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1251      */
1252     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1253         uint256 length = ERC721.balanceOf(to);
1254         _ownedTokens[to][length] = tokenId;
1255         _ownedTokensIndex[tokenId] = length;
1256     }
1257 
1258     /**
1259      * @dev Private function to add a token to this extension's token tracking data structures.
1260      * @param tokenId uint256 ID of the token to be added to the tokens list
1261      */
1262     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1263         _allTokensIndex[tokenId] = _allTokens.length;
1264         _allTokens.push(tokenId);
1265     }
1266 
1267     /**
1268      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1269      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1270      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1271      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1272      * @param from address representing the previous owner of the given token ID
1273      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1274      */
1275     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1276         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1277         // then delete the last slot (swap and pop).
1278 
1279         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1280         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1281 
1282         // When the token to delete is the last token, the swap operation is unnecessary
1283         if (tokenIndex != lastTokenIndex) {
1284             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1285 
1286             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1287             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1288         }
1289 
1290         // This also deletes the contents at the last position of the array
1291         delete _ownedTokensIndex[tokenId];
1292         delete _ownedTokens[from][lastTokenIndex];
1293     }
1294 
1295     /**
1296      * @dev Private function to remove a token from this extension's token tracking data structures.
1297      * This has O(1) time complexity, but alters the order of the _allTokens array.
1298      * @param tokenId uint256 ID of the token to be removed from the tokens list
1299      */
1300     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1301         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1302         // then delete the last slot (swap and pop).
1303 
1304         uint256 lastTokenIndex = _allTokens.length - 1;
1305         uint256 tokenIndex = _allTokensIndex[tokenId];
1306 
1307         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1308         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1309         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1310         uint256 lastTokenId = _allTokens[lastTokenIndex];
1311 
1312         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1313         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1314 
1315         // This also deletes the contents at the last position of the array
1316         delete _allTokensIndex[tokenId];
1317         _allTokens.pop();
1318     }
1319 }
1320 
1321 
1322 // File contracts/ApesPunk.sol
1323 
1324 
1325 pragma solidity ^0.8.0;
1326 contract ApesPunk is Ownable, ERC721Enumerable, ReentrancyGuard {
1327     using Strings for uint256;
1328 
1329     // variables for mint
1330     bool public isMintOn = false;
1331 
1332     bool public saleHasBeenStarted = false;
1333 
1334     uint256 public constant MAX_MINTABLE_AT_ONCE = 50;
1335 
1336     uint256[10000] private _availableTokens;
1337     uint256 private _numAvailableTokens = 10000;
1338     
1339     uint256 private _lastTokenIdMintedInInitialSet = 10000;
1340 
1341     // variables for market
1342     struct Offer {
1343         bool isForSale;
1344         uint tokenId;
1345         address seller;
1346         uint minValue;          // in ether
1347         address onlySellTo;     // specify to sell only to a specific person
1348     }
1349 
1350     struct Bid {
1351         bool hasBid;
1352         uint tokenId;
1353         address bidder;
1354         uint value;
1355     }
1356 
1357     // A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
1358     mapping (uint => Offer) public punksOfferedForSale;
1359 
1360     // A record of the highest punk bid
1361     mapping (uint => Bid) public punkBids;
1362 
1363     mapping (address => uint) public pendingWithdrawals;
1364 
1365     event PunkOffered(uint indexed tokenId, uint minValue, address indexed toAddress);
1366     event PunkBidEntered(uint indexed tokenId, uint value, address indexed fromAddress);
1367     event PunkBidWithdrawn(uint indexed tokenId, uint value, address indexed fromAddress);
1368     event PunkBought(uint indexed tokenId, uint value, address indexed fromAddress, address indexed toAddress);
1369     event PunkNoLongerForSale(uint indexed tokenId);
1370 
1371 
1372     constructor() ERC721("0xApes", "0xApe") {}
1373     
1374     function numTotalPhunks() public view virtual returns (uint256) {
1375         return 10000;
1376     }
1377 
1378     function mint(uint256 _numToMint) public payable nonReentrant() {
1379         require(isMintOn, "Sale hasn't started.");
1380         uint256 totalSupply = totalSupply();
1381         require(
1382             totalSupply + _numToMint <= numTotalPhunks(),
1383             "There aren't this many phunks left."
1384         );
1385         uint256 costForMintingPhunks = getCostForMintingPhunks(_numToMint);
1386         require(
1387             msg.value >= costForMintingPhunks,
1388             "Too little sent, please send more eth."
1389         );
1390         if (msg.value > costForMintingPhunks) {
1391             require(_safeTransferETH(msg.sender, msg.value - costForMintingPhunks));
1392         }
1393 
1394         // transfer cost for mint to owner address
1395         require(_safeTransferETH(owner(), costForMintingPhunks), "failed to transfer minting cost");
1396 
1397         _mint(_numToMint);
1398     }
1399 
1400     // internal minting function
1401     function _mint(uint256 _numToMint) internal {
1402         require(_numToMint <= MAX_MINTABLE_AT_ONCE, "Minting too many at once.");
1403 
1404         uint256 updatedNumAvailableTokens = _numAvailableTokens;
1405         for (uint256 i = 0; i < _numToMint; i++) {
1406             uint256 newTokenId = useRandomAvailableToken(_numToMint, i);
1407             _safeMint(msg.sender, newTokenId + 10000);
1408             updatedNumAvailableTokens--;
1409         }
1410         _numAvailableTokens = updatedNumAvailableTokens;
1411     }
1412 
1413     function useRandomAvailableToken(uint256 _numToFetch, uint256 _i)
1414         internal
1415         returns (uint256)
1416     {
1417         uint256 randomNum =
1418         uint256(
1419             keccak256(
1420             abi.encode(
1421                 msg.sender,
1422                 tx.gasprice,
1423                 block.number,
1424                 block.timestamp,
1425                 blockhash(block.number - 1),
1426                 _numToFetch,
1427                 _i
1428             )
1429             )
1430         );
1431         uint256 randomIndex = randomNum % _numAvailableTokens;
1432         return useAvailableTokenAtIndex(randomIndex);
1433     }
1434 
1435     function useAvailableTokenAtIndex(uint256 indexToUse)
1436         internal
1437         returns (uint256)
1438     {
1439         uint256 valAtIndex = _availableTokens[indexToUse];
1440         uint256 result;
1441         if (valAtIndex == 0) {
1442             // This means the index itself is still an available token
1443             result = indexToUse;
1444         } else {
1445             // This means the index itself is not an available token, but the val at that index is.
1446             result = valAtIndex;
1447         }
1448 
1449         uint256 lastIndex = _numAvailableTokens - 1;
1450         if (indexToUse != lastIndex) {
1451             // Replace the value at indexToUse, now that it's been used.
1452             // Replace it with the data from the last index in the array, since we are going to decrease the array size afterwards.
1453             uint256 lastValInArray = _availableTokens[lastIndex];
1454             if (lastValInArray == 0) {
1455                 // This means the index itself is still an available token
1456                 _availableTokens[indexToUse] = lastIndex;
1457             } else {
1458                 // This means the index itself is not an available token, but the val at that index is.
1459                 _availableTokens[indexToUse] = lastValInArray;
1460             }
1461         }
1462 
1463         _numAvailableTokens--;
1464         return result;
1465     }
1466 
1467     function getCostForMintingPhunks(uint256 _numToMint)
1468         public
1469         view
1470         returns (uint256)
1471     {
1472         require(
1473             totalSupply() + _numToMint <= numTotalPhunks(),
1474             "There aren't this many phunks left."
1475         );
1476         return 0.05 ether * _numToMint;
1477     }
1478 
1479     function getPhunksBelongingToOwner(address _owner)
1480         external
1481         view
1482         returns (uint256[] memory)
1483     {
1484         uint256 numPhunks = balanceOf(_owner);
1485         if (numPhunks == 0) {
1486             return new uint256[](0);
1487         } else {
1488             uint256[] memory result = new uint256[](numPhunks);
1489             for (uint256 i = 0; i < numPhunks; i++) {
1490                 result[i] = tokenOfOwnerByIndex(_owner, i);
1491             }
1492             return result;
1493         }
1494     }
1495 
1496     /*
1497     * Dev stuff.
1498     */
1499 
1500     // metadata URI
1501     string private _baseTokenURI;
1502 
1503     function _baseURI() internal view virtual override returns (string memory) {
1504         return _baseTokenURI;
1505     }
1506 
1507     function tokenURI(uint256 _tokenId)
1508         public
1509         view
1510         override
1511         returns (string memory)
1512     {
1513         string memory base = _baseURI();
1514         string memory _tokenURI = Strings.toString(_tokenId);
1515 
1516         // If there is no base URI, return the token URI.
1517         if (bytes(base).length == 0) {
1518             return _tokenURI;
1519         }
1520 
1521         return string(abi.encodePacked(base, _tokenURI));
1522     }
1523 
1524     // contract metadata URI for opensea
1525     string public contractURI;
1526 
1527     /*
1528     * Owner stuff
1529     */
1530 
1531     function startMinting() public onlyOwner {
1532         isMintOn = true;
1533         saleHasBeenStarted = true;
1534     }
1535 
1536     function endMinting() public onlyOwner {
1537         isMintOn = false;
1538     }
1539 
1540     // for seeding the v2 contract with v1 state
1541     // details on seeding info here: https://gist.github.com/cryptophunks/7f542feaee510e12464da3bb2a922713
1542     function seedInitialContractState(
1543         address[] memory tokenOwners,
1544         uint256[] memory tokens
1545     ) public onlyOwner {
1546         require(
1547             !saleHasBeenStarted,
1548             "cannot initial phunk mint if sale has started"
1549         );
1550         require(
1551             tokenOwners.length == tokens.length,
1552             "tokenOwners does not match tokens length"
1553         );
1554 
1555         uint256 lastTokenIdMintedInInitialSetCopy = _lastTokenIdMintedInInitialSet;
1556         for (uint256 i = 0; i < tokenOwners.length; i++) {
1557             uint256 token = tokens[i];
1558             require(
1559                 lastTokenIdMintedInInitialSetCopy > token,
1560                 "initial phunk mints must be in decreasing order for our availableToken index to work"
1561             );
1562             lastTokenIdMintedInInitialSetCopy = token;
1563 
1564             useAvailableTokenAtIndex(token);
1565             _safeMint(tokenOwners[i], token + 10000);
1566         }
1567         _lastTokenIdMintedInInitialSet = lastTokenIdMintedInInitialSetCopy;
1568     }
1569 
1570     // URIs
1571     function setBaseURI(string memory baseURI) external onlyOwner {
1572         _baseTokenURI = baseURI;
1573     }
1574 
1575     function setContractURI(string memory _contractURI) external onlyOwner {
1576         contractURI = _contractURI;
1577     }
1578 
1579     /***********************************************************************************************************************
1580      *   Punk Market
1581      * 
1582     ***********************************************************************************************************************/
1583 
1584     function punkNoLongerForSale(uint tokenId) public onlyPunkOwner(tokenId) {
1585         punksOfferedForSale[tokenId] = Offer(false, tokenId, msg.sender, 0, address(0x0));
1586         emit PunkNoLongerForSale(tokenId);
1587     }
1588 
1589     function offerPunkForSale(uint tokenId, uint minSalePriceInWei) public onlyPunkOwner(tokenId) {
1590         punksOfferedForSale[tokenId] = Offer(true, tokenId, msg.sender, minSalePriceInWei, address(0x0));
1591         emit PunkOffered(tokenId, minSalePriceInWei, address(0x0));
1592     }
1593 
1594     function offerPunkForSaleToAddress(uint tokenId, uint minSalePriceInWei, address toAddress) public onlyPunkOwner(tokenId) {
1595         punksOfferedForSale[tokenId] = Offer(true, tokenId, msg.sender, minSalePriceInWei, toAddress);
1596         emit PunkOffered(tokenId, minSalePriceInWei, toAddress);
1597     }
1598 
1599     function buyPunk(uint tokenId) public payable nonReentrant() {
1600         Offer memory offer = punksOfferedForSale[tokenId];
1601         require (offer.isForSale, "this token is not for sale");                // punk not actually for sale
1602         require (offer.onlySellTo == address(0x0) || offer.onlySellTo == msg.sender, "not available for you");  // punk not supposed to be sold to this user
1603         require (msg.value >= offer.minValue, "invalid eth value");      // Didn't send enough ETH
1604         require (offer.seller == ownerOf(tokenId), "seller is not owner"); // Seller no longer owner of punk
1605 
1606         address seller = offer.seller;
1607 
1608         _safeTransfer(seller, msg.sender, tokenId, "buying punk");
1609 
1610         punkNoLongerForSale(tokenId);
1611         pendingWithdrawals[seller] += msg.value;
1612         emit PunkBought(tokenId, msg.value, seller, msg.sender);
1613 
1614         // Check for the case where there is a bid from the new owner and refund it.
1615         // Any other bid can stay in place.
1616         Bid memory bid = punkBids[tokenId];
1617         if (bid.bidder == msg.sender) {
1618             // Kill bid and refund value
1619             pendingWithdrawals[msg.sender] += bid.value;
1620             punkBids[tokenId] = Bid(false, tokenId, address(0x0), 0);
1621         }
1622     }
1623 
1624     function withdraw() public nonReentrant() {
1625         uint amount = pendingWithdrawals[msg.sender];
1626         // Remember to zero the pending refund before
1627         // sending to prevent re-entrancy attacks
1628         pendingWithdrawals[msg.sender] = 0;
1629         _safeTransferETH(msg.sender, amount);
1630     }
1631 
1632     function enterBidForPunk(uint tokenId) public payable {
1633         require(ownerOf(tokenId) != address(0x0), "not minted token");
1634         require(ownerOf(tokenId) != address(msg.sender), "impossible for owned token");
1635         require (msg.value > 0, "not enough eth");
1636         
1637         Bid memory existing = punkBids[tokenId];
1638         require(msg.value > existing.value, "low than previous");
1639     
1640         if (existing.value > 0) {
1641             // Refund the failing bid
1642             pendingWithdrawals[existing.bidder] += existing.value;
1643         }
1644         punkBids[tokenId] = Bid(true, tokenId, msg.sender, msg.value);
1645         emit PunkBidEntered(tokenId, msg.value, msg.sender);
1646     }
1647 
1648     function acceptBidForPunk(uint tokenId, uint minPrice) public onlyPunkOwner(tokenId) {
1649         address seller = msg.sender;
1650         Bid memory bid = punkBids[tokenId];
1651         require(bid.value > 0 && bid.value > minPrice, "invalid bid price");
1652         
1653         _safeTransfer(seller, bid.bidder, tokenId, "win");
1654         
1655         punksOfferedForSale[tokenId] = Offer(false, tokenId, bid.bidder, 0, address(0x0));
1656         uint amount = bid.value;
1657         punkBids[tokenId] = Bid(false, tokenId, address(0x0), 0);
1658         pendingWithdrawals[seller] += amount;
1659         emit PunkBought(tokenId, bid.value, seller, bid.bidder);
1660     }
1661 
1662     function withdrawBidForPunk(uint tokenId) public nonReentrant() {
1663         require(ownerOf(tokenId) != address(0x0), "not minted token");
1664         require(ownerOf(tokenId) != address(msg.sender), "impossible for owned token");
1665 
1666         Bid memory bid = punkBids[tokenId];
1667         require (bid.bidder == msg.sender, "not bidder");
1668 
1669         emit PunkBidWithdrawn(tokenId, bid.value, msg.sender);
1670         uint amount = bid.value;
1671         punkBids[tokenId] = Bid(false, tokenId, address(0x0), 0);
1672         // Refund the bid money
1673         require(_safeTransferETH(msg.sender, amount), "failed to refund");
1674     }
1675 
1676     function _beforeTokenTransfer(
1677         address from,
1678         address to,
1679         uint256 tokenId
1680     ) internal virtual override(ERC721Enumerable) {
1681         super._beforeTokenTransfer(from, to, tokenId);
1682 
1683         if (punksOfferedForSale[tokenId].isForSale) {
1684             punkNoLongerForSale(tokenId);
1685         }
1686         
1687         // Check for the case where there is a bid from the new owner and refund it.
1688         // Any other bid can stay in place.
1689         Bid memory bid = punkBids[tokenId];
1690         if (bid.bidder == to) {
1691             // Kill bid and refund value
1692             pendingWithdrawals[to] += bid.value;
1693             punkBids[tokenId] = Bid(false, tokenId, address(0x0), 0);
1694         }
1695     }
1696 
1697     function supportsInterface(bytes4 interfaceId)
1698         public
1699         view
1700         virtual
1701         override(ERC721Enumerable)
1702         returns (bool)
1703     {
1704         return super.supportsInterface(interfaceId);
1705     }
1706 
1707     receive() external payable {}
1708 
1709     function _safeTransferETH(address to, uint256 value) internal returns(bool) {
1710 		(bool success, ) = to.call{value: value}(new bytes(0));
1711 		return success;
1712     }
1713 
1714     modifier onlyPunkOwner(uint256 tokenId) {
1715         require(ownerOf(tokenId) == msg.sender, "only for punk owner");
1716         _;
1717     }
1718 }