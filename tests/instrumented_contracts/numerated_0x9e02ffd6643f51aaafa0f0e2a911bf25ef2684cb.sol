1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
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
57         _setOwner(_msgSender());
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
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Contract module that helps prevent reentrant calls to a function.
110  *
111  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
112  * available, which can be applied to functions to make sure there are no nested
113  * (reentrant) calls to them.
114  *
115  * Note that because there is a single `nonReentrant` guard, functions marked as
116  * `nonReentrant` may not call one another. This can be worked around by making
117  * those functions `private`, and then adding `external` `nonReentrant` entry
118  * points to them.
119  *
120  * TIP: If you would like to learn more about reentrancy and alternative ways
121  * to protect against it, check out our blog post
122  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
123  */
124 abstract contract ReentrancyGuard {
125     // Booleans are more expensive than uint256 or any type that takes up a full
126     // word because each write operation emits an extra SLOAD to first read the
127     // slot's contents, replace the bits taken up by the boolean, and then write
128     // back. This is the compiler's defense against contract upgrades and
129     // pointer aliasing, and it cannot be disabled.
130 
131     // The values being non-zero value makes deployment a bit more expensive,
132     // but in exchange the refund on every call to nonReentrant will be lower in
133     // amount. Since refunds are capped to a percentage of the total
134     // transaction's gas, it is best to keep them low in cases like this one, to
135     // increase the likelihood of the full refund coming into effect.
136     uint256 private constant _NOT_ENTERED = 1;
137     uint256 private constant _ENTERED = 2;
138 
139     uint256 private _status;
140 
141     constructor() {
142         _status = _NOT_ENTERED;
143     }
144 
145     /**
146      * @dev Prevents a contract from calling itself, directly or indirectly.
147      * Calling a `nonReentrant` function from another `nonReentrant`
148      * function is not supported. It is possible to prevent this from happening
149      * by making the `nonReentrant` function external, and make it call a
150      * `private` function that does the actual work.
151      */
152     modifier nonReentrant() {
153         // On the first call to nonReentrant, _notEntered will be true
154         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
155 
156         // Any calls to nonReentrant after this point will fail
157         _status = _ENTERED;
158 
159         _;
160 
161         // By storing the original value once again, a refund is triggered (see
162         // https://eips.ethereum.org/EIPS/eip-2200)
163         _status = _NOT_ENTERED;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
168 
169 
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @dev Interface of the ERC165 standard, as defined in the
175  * https://eips.ethereum.org/EIPS/eip-165[EIP].
176  *
177  * Implementers can declare support of contract interfaces, which can then be
178  * queried by others ({ERC165Checker}).
179  *
180  * For an implementation, see {ERC165}.
181  */
182 interface IERC165 {
183     /**
184      * @dev Returns true if this contract implements the interface defined by
185      * `interfaceId`. See the corresponding
186      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
187      * to learn more about how these ids are created.
188      *
189      * This function call must use less than 30 000 gas.
190      */
191     function supportsInterface(bytes4 interfaceId) external view returns (bool);
192 }
193 
194 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
195 
196 
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Required interface of an ERC721 compliant contract.
203  */
204 interface IERC721 is IERC165 {
205     /**
206      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
207      */
208     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
209 
210     /**
211      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
212      */
213     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
214 
215     /**
216      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
217      */
218     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
219 
220     /**
221      * @dev Returns the number of tokens in ``owner``'s account.
222      */
223     function balanceOf(address owner) external view returns (uint256 balance);
224 
225     /**
226      * @dev Returns the owner of the `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function ownerOf(uint256 tokenId) external view returns (address owner);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
236      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId
252     ) external;
253 
254     /**
255      * @dev Transfers `tokenId` token from `from` to `to`.
256      *
257      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must be owned by `from`.
264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transferFrom(
269         address from,
270         address to,
271         uint256 tokenId
272     ) external;
273 
274     /**
275      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
276      * The approval is cleared when the token is transferred.
277      *
278      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
279      *
280      * Requirements:
281      *
282      * - The caller must own the token or be an approved operator.
283      * - `tokenId` must exist.
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address to, uint256 tokenId) external;
288 
289     /**
290      * @dev Returns the account approved for `tokenId` token.
291      *
292      * Requirements:
293      *
294      * - `tokenId` must exist.
295      */
296     function getApproved(uint256 tokenId) external view returns (address operator);
297 
298     /**
299      * @dev Approve or remove `operator` as an operator for the caller.
300      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
301      *
302      * Requirements:
303      *
304      * - The `operator` cannot be the caller.
305      *
306      * Emits an {ApprovalForAll} event.
307      */
308     function setApprovalForAll(address operator, bool _approved) external;
309 
310     /**
311      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
312      *
313      * See {setApprovalForAll}
314      */
315     function isApprovedForAll(address owner, address operator) external view returns (bool);
316 
317     /**
318      * @dev Safely transfers `tokenId` token from `from` to `to`.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must exist and be owned by `from`.
325      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
327      *
328      * Emits a {Transfer} event.
329      */
330     function safeTransferFrom(
331         address from,
332         address to,
333         uint256 tokenId,
334         bytes calldata data
335     ) external;
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
339 
340 
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @title ERC721 token receiver interface
346  * @dev Interface for any contract that wants to support safeTransfers
347  * from ERC721 asset contracts.
348  */
349 interface IERC721Receiver {
350     /**
351      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
352      * by `operator` from `from`, this function is called.
353      *
354      * It must return its Solidity selector to confirm the token transfer.
355      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
356      *
357      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
358      */
359     function onERC721Received(
360         address operator,
361         address from,
362         uint256 tokenId,
363         bytes calldata data
364     ) external returns (bytes4);
365 }
366 
367 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
368 
369 
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
376  * @dev See https://eips.ethereum.org/EIPS/eip-721
377  */
378 interface IERC721Metadata is IERC721 {
379     /**
380      * @dev Returns the token collection name.
381      */
382     function name() external view returns (string memory);
383 
384     /**
385      * @dev Returns the token collection symbol.
386      */
387     function symbol() external view returns (string memory);
388 
389     /**
390      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
391      */
392     function tokenURI(uint256 tokenId) external view returns (string memory);
393 }
394 
395 // File: @openzeppelin/contracts/utils/Address.sol
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
614 // File: @openzeppelin/contracts/utils/Strings.sol
615 
616 
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev String operations.
622  */
623 library Strings {
624     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
628      */
629     function toString(uint256 value) internal pure returns (string memory) {
630         // Inspired by OraclizeAPI's implementation - MIT licence
631         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
632 
633         if (value == 0) {
634             return "0";
635         }
636         uint256 temp = value;
637         uint256 digits;
638         while (temp != 0) {
639             digits++;
640             temp /= 10;
641         }
642         bytes memory buffer = new bytes(digits);
643         while (value != 0) {
644             digits -= 1;
645             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
646             value /= 10;
647         }
648         return string(buffer);
649     }
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
653      */
654     function toHexString(uint256 value) internal pure returns (string memory) {
655         if (value == 0) {
656             return "0x00";
657         }
658         uint256 temp = value;
659         uint256 length = 0;
660         while (temp != 0) {
661             length++;
662             temp >>= 8;
663         }
664         return toHexString(value, length);
665     }
666 
667     /**
668      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
669      */
670     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
671         bytes memory buffer = new bytes(2 * length + 2);
672         buffer[0] = "0";
673         buffer[1] = "x";
674         for (uint256 i = 2 * length + 1; i > 1; --i) {
675             buffer[i] = _HEX_SYMBOLS[value & 0xf];
676             value >>= 4;
677         }
678         require(value == 0, "Strings: hex length insufficient");
679         return string(buffer);
680     }
681 }
682 
683 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         return interfaceId == type(IERC165).interfaceId;
710     }
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
714 
715 
716 
717 pragma solidity ^0.8.0;
718 
719 
720 
721 
722 
723 
724 
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension, but not including the Enumerable extension, which is available separately as
729  * {ERC721Enumerable}.
730  */
731 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
732     using Address for address;
733     using Strings for uint256;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to owner address
742     mapping(uint256 => address) private _owners;
743 
744     // Mapping owner address to token count
745     mapping(address => uint256) private _balances;
746 
747     // Mapping from token ID to approved address
748     mapping(uint256 => address) private _tokenApprovals;
749 
750     // Mapping from owner to operator approvals
751     mapping(address => mapping(address => bool)) private _operatorApprovals;
752 
753     /**
754      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
755      */
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759     }
760 
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner) public view virtual override returns (uint256) {
775         require(owner != address(0), "ERC721: balance query for the zero address");
776         return _balances[owner];
777     }
778 
779     /**
780      * @dev See {IERC721-ownerOf}.
781      */
782     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
783         address owner = _owners[tokenId];
784         require(owner != address(0), "ERC721: owner query for nonexistent token");
785         return owner;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overriden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return "";
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public virtual override {
825         address owner = ERC721.ownerOf(tokenId);
826         require(to != owner, "ERC721: approval to current owner");
827 
828         require(
829             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
830             "ERC721: approve caller is not owner nor approved for all"
831         );
832 
833         _approve(to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-getApproved}.
838      */
839     function getApproved(uint256 tokenId) public view virtual override returns (address) {
840         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
841 
842         return _tokenApprovals[tokenId];
843     }
844 
845     /**
846      * @dev See {IERC721-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         require(operator != _msgSender(), "ERC721: approve to caller");
850 
851         _operatorApprovals[_msgSender()][operator] = approved;
852         emit ApprovalForAll(_msgSender(), operator, approved);
853     }
854 
855     /**
856      * @dev See {IERC721-isApprovedForAll}.
857      */
858     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
859         return _operatorApprovals[owner][operator];
860     }
861 
862     /**
863      * @dev See {IERC721-transferFrom}.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         //solhint-disable-next-line max-line-length
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
872 
873         _transfer(from, to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         safeTransferFrom(from, to, tokenId, "");
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) public virtual override {
896         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
897         _safeTransfer(from, to, tokenId, _data);
898     }
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
902      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
903      *
904      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
905      *
906      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
907      * implement alternative mechanisms to perform token transfer, such as signature-based.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _safeTransfer(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) internal virtual {
924         _transfer(from, to, tokenId);
925         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      * and stop existing when they are burned (`_burn`).
935      */
936     function _exists(uint256 tokenId) internal view virtual returns (bool) {
937         return _owners[tokenId] != address(0);
938     }
939 
940     /**
941      * @dev Returns whether `spender` is allowed to manage `tokenId`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      */
947     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
948         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
951     }
952 
953     /**
954      * @dev Safely mints `tokenId` and transfers it to `to`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeMint(address to, uint256 tokenId) internal virtual {
964         _safeMint(to, tokenId, "");
965     }
966 
967     /**
968      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
969      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
970      */
971     function _safeMint(
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) internal virtual {
976         _mint(to, tokenId);
977         require(
978             _checkOnERC721Received(address(0), to, tokenId, _data),
979             "ERC721: transfer to non ERC721Receiver implementer"
980         );
981     }
982 
983     /**
984      * @dev Mints `tokenId` and transfers it to `to`.
985      *
986      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
987      *
988      * Requirements:
989      *
990      * - `tokenId` must not exist.
991      * - `to` cannot be the zero address.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _mint(address to, uint256 tokenId) internal virtual {
996         require(to != address(0), "ERC721: mint to the zero address");
997         require(!_exists(tokenId), "ERC721: token already minted");
998 
999         _beforeTokenTransfer(address(0), to, tokenId);
1000 
1001         _balances[to] += 1;
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(address(0), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Destroys `tokenId`.
1009      * The approval is cleared when the token is burned.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _burn(uint256 tokenId) internal virtual {
1018         address owner = ERC721.ownerOf(tokenId);
1019 
1020         _beforeTokenTransfer(owner, address(0), tokenId);
1021 
1022         // Clear approvals
1023         _approve(address(0), tokenId);
1024 
1025         _balances[owner] -= 1;
1026         delete _owners[tokenId];
1027 
1028         emit Transfer(owner, address(0), tokenId);
1029     }
1030 
1031     /**
1032      * @dev Transfers `tokenId` from `from` to `to`.
1033      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {
1047         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Approve `to` to operate on `tokenId`
1064      *
1065      * Emits a {Approval} event.
1066      */
1067     function _approve(address to, uint256 tokenId) internal virtual {
1068         _tokenApprovals[tokenId] = to;
1069         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1074      * The call is not executed if the target address is not a contract.
1075      *
1076      * @param from address representing the previous owner of the given token ID
1077      * @param to target address that will receive the tokens
1078      * @param tokenId uint256 ID of the token to be transferred
1079      * @param _data bytes optional data to send along with the call
1080      * @return bool whether the call correctly returned the expected magic value
1081      */
1082     function _checkOnERC721Received(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) private returns (bool) {
1088         if (to.isContract()) {
1089             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1090                 return retval == IERC721Receiver.onERC721Received.selector;
1091             } catch (bytes memory reason) {
1092                 if (reason.length == 0) {
1093                     revert("ERC721: transfer to non ERC721Receiver implementer");
1094                 } else {
1095                     assembly {
1096                         revert(add(32, reason), mload(reason))
1097                     }
1098                 }
1099             }
1100         } else {
1101             return true;
1102         }
1103     }
1104 
1105     /**
1106      * @dev Hook that is called before any token transfer. This includes minting
1107      * and burning.
1108      *
1109      * Calling conditions:
1110      *
1111      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1112      * transferred to `to`.
1113      * - When `from` is zero, `tokenId` will be minted for `to`.
1114      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1115      * - `from` and `to` are never both zero.
1116      *
1117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1118      */
1119     function _beforeTokenTransfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {}
1124 }
1125 
1126 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1127 
1128 
1129 
1130 pragma solidity ^0.8.0;
1131 
1132 
1133 /**
1134  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1135  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1136  *
1137  * _Available since v3.1._
1138  */
1139 interface IERC1155 is IERC165 {
1140     /**
1141      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1142      */
1143     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1144 
1145     /**
1146      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1147      * transfers.
1148      */
1149     event TransferBatch(
1150         address indexed operator,
1151         address indexed from,
1152         address indexed to,
1153         uint256[] ids,
1154         uint256[] values
1155     );
1156 
1157     /**
1158      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1159      * `approved`.
1160      */
1161     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1162 
1163     /**
1164      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1165      *
1166      * If an {URI} event was emitted for `id`, the standard
1167      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1168      * returned by {IERC1155MetadataURI-uri}.
1169      */
1170     event URI(string value, uint256 indexed id);
1171 
1172     /**
1173      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1174      *
1175      * Requirements:
1176      *
1177      * - `account` cannot be the zero address.
1178      */
1179     function balanceOf(address account, uint256 id) external view returns (uint256);
1180 
1181     /**
1182      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1183      *
1184      * Requirements:
1185      *
1186      * - `accounts` and `ids` must have the same length.
1187      */
1188     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1189         external
1190         view
1191         returns (uint256[] memory);
1192 
1193     /**
1194      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1195      *
1196      * Emits an {ApprovalForAll} event.
1197      *
1198      * Requirements:
1199      *
1200      * - `operator` cannot be the caller.
1201      */
1202     function setApprovalForAll(address operator, bool approved) external;
1203 
1204     /**
1205      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1206      *
1207      * See {setApprovalForAll}.
1208      */
1209     function isApprovedForAll(address account, address operator) external view returns (bool);
1210 
1211     /**
1212      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1213      *
1214      * Emits a {TransferSingle} event.
1215      *
1216      * Requirements:
1217      *
1218      * - `to` cannot be the zero address.
1219      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1220      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1221      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1222      * acceptance magic value.
1223      */
1224     function safeTransferFrom(
1225         address from,
1226         address to,
1227         uint256 id,
1228         uint256 amount,
1229         bytes calldata data
1230     ) external;
1231 
1232     /**
1233      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1234      *
1235      * Emits a {TransferBatch} event.
1236      *
1237      * Requirements:
1238      *
1239      * - `ids` and `amounts` must have the same length.
1240      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1241      * acceptance magic value.
1242      */
1243     function safeBatchTransferFrom(
1244         address from,
1245         address to,
1246         uint256[] calldata ids,
1247         uint256[] calldata amounts,
1248         bytes calldata data
1249     ) external;
1250 }
1251 
1252 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1253 
1254 
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 /**
1260  * @dev _Available since v3.1._
1261  */
1262 interface IERC1155Receiver is IERC165 {
1263     /**
1264         @dev Handles the receipt of a single ERC1155 token type. This function is
1265         called at the end of a `safeTransferFrom` after the balance has been updated.
1266         To accept the transfer, this must return
1267         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1268         (i.e. 0xf23a6e61, or its own function selector).
1269         @param operator The address which initiated the transfer (i.e. msg.sender)
1270         @param from The address which previously owned the token
1271         @param id The ID of the token being transferred
1272         @param value The amount of tokens being transferred
1273         @param data Additional data with no specified format
1274         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1275     */
1276     function onERC1155Received(
1277         address operator,
1278         address from,
1279         uint256 id,
1280         uint256 value,
1281         bytes calldata data
1282     ) external returns (bytes4);
1283 
1284     /**
1285         @dev Handles the receipt of a multiple ERC1155 token types. This function
1286         is called at the end of a `safeBatchTransferFrom` after the balances have
1287         been updated. To accept the transfer(s), this must return
1288         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1289         (i.e. 0xbc197c81, or its own function selector).
1290         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1291         @param from The address which previously owned the token
1292         @param ids An array containing ids of each token being transferred (order and length must match values array)
1293         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1294         @param data Additional data with no specified format
1295         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1296     */
1297     function onERC1155BatchReceived(
1298         address operator,
1299         address from,
1300         uint256[] calldata ids,
1301         uint256[] calldata values,
1302         bytes calldata data
1303     ) external returns (bytes4);
1304 }
1305 
1306 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1307 
1308 
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 
1313 /**
1314  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1315  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1316  *
1317  * _Available since v3.1._
1318  */
1319 interface IERC1155MetadataURI is IERC1155 {
1320     /**
1321      * @dev Returns the URI for token type `id`.
1322      *
1323      * If the `\{id\}` substring is present in the URI, it must be replaced by
1324      * clients with the actual token type ID.
1325      */
1326     function uri(uint256 id) external view returns (string memory);
1327 }
1328 
1329 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1330 
1331 
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 
1336 
1337 
1338 
1339 
1340 
1341 /**
1342  * @dev Implementation of the basic standard multi-token.
1343  * See https://eips.ethereum.org/EIPS/eip-1155
1344  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1345  *
1346  * _Available since v3.1._
1347  */
1348 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1349     using Address for address;
1350 
1351     // Mapping from token ID to account balances
1352     mapping(uint256 => mapping(address => uint256)) private _balances;
1353 
1354     // Mapping from account to operator approvals
1355     mapping(address => mapping(address => bool)) private _operatorApprovals;
1356 
1357     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1358     string private _uri;
1359 
1360     /**
1361      * @dev See {_setURI}.
1362      */
1363     constructor(string memory uri_) {
1364         _setURI(uri_);
1365     }
1366 
1367     /**
1368      * @dev See {IERC165-supportsInterface}.
1369      */
1370     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1371         return
1372             interfaceId == type(IERC1155).interfaceId ||
1373             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1374             super.supportsInterface(interfaceId);
1375     }
1376 
1377     /**
1378      * @dev See {IERC1155MetadataURI-uri}.
1379      *
1380      * This implementation returns the same URI for *all* token types. It relies
1381      * on the token type ID substitution mechanism
1382      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1383      *
1384      * Clients calling this function must replace the `\{id\}` substring with the
1385      * actual token type ID.
1386      */
1387     function uri(uint256) public view virtual override returns (string memory) {
1388         return _uri;
1389     }
1390 
1391     /**
1392      * @dev See {IERC1155-balanceOf}.
1393      *
1394      * Requirements:
1395      *
1396      * - `account` cannot be the zero address.
1397      */
1398     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1399         require(account != address(0), "ERC1155: balance query for the zero address");
1400         return _balances[id][account];
1401     }
1402 
1403     /**
1404      * @dev See {IERC1155-balanceOfBatch}.
1405      *
1406      * Requirements:
1407      *
1408      * - `accounts` and `ids` must have the same length.
1409      */
1410     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1411         public
1412         view
1413         virtual
1414         override
1415         returns (uint256[] memory)
1416     {
1417         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1418 
1419         uint256[] memory batchBalances = new uint256[](accounts.length);
1420 
1421         for (uint256 i = 0; i < accounts.length; ++i) {
1422             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1423         }
1424 
1425         return batchBalances;
1426     }
1427 
1428     /**
1429      * @dev See {IERC1155-setApprovalForAll}.
1430      */
1431     function setApprovalForAll(address operator, bool approved) public virtual override {
1432         require(_msgSender() != operator, "ERC1155: setting approval status for self");
1433 
1434         _operatorApprovals[_msgSender()][operator] = approved;
1435         emit ApprovalForAll(_msgSender(), operator, approved);
1436     }
1437 
1438     /**
1439      * @dev See {IERC1155-isApprovedForAll}.
1440      */
1441     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1442         return _operatorApprovals[account][operator];
1443     }
1444 
1445     /**
1446      * @dev See {IERC1155-safeTransferFrom}.
1447      */
1448     function safeTransferFrom(
1449         address from,
1450         address to,
1451         uint256 id,
1452         uint256 amount,
1453         bytes memory data
1454     ) public virtual override {
1455         require(
1456             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1457             "ERC1155: caller is not owner nor approved"
1458         );
1459         _safeTransferFrom(from, to, id, amount, data);
1460     }
1461 
1462     /**
1463      * @dev See {IERC1155-safeBatchTransferFrom}.
1464      */
1465     function safeBatchTransferFrom(
1466         address from,
1467         address to,
1468         uint256[] memory ids,
1469         uint256[] memory amounts,
1470         bytes memory data
1471     ) public virtual override {
1472         require(
1473             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1474             "ERC1155: transfer caller is not owner nor approved"
1475         );
1476         _safeBatchTransferFrom(from, to, ids, amounts, data);
1477     }
1478 
1479     /**
1480      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1481      *
1482      * Emits a {TransferSingle} event.
1483      *
1484      * Requirements:
1485      *
1486      * - `to` cannot be the zero address.
1487      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1488      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1489      * acceptance magic value.
1490      */
1491     function _safeTransferFrom(
1492         address from,
1493         address to,
1494         uint256 id,
1495         uint256 amount,
1496         bytes memory data
1497     ) internal virtual {
1498         require(to != address(0), "ERC1155: transfer to the zero address");
1499 
1500         address operator = _msgSender();
1501 
1502         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1503 
1504         uint256 fromBalance = _balances[id][from];
1505         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1506         unchecked {
1507             _balances[id][from] = fromBalance - amount;
1508         }
1509         _balances[id][to] += amount;
1510 
1511         emit TransferSingle(operator, from, to, id, amount);
1512 
1513         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1514     }
1515 
1516     /**
1517      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1518      *
1519      * Emits a {TransferBatch} event.
1520      *
1521      * Requirements:
1522      *
1523      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1524      * acceptance magic value.
1525      */
1526     function _safeBatchTransferFrom(
1527         address from,
1528         address to,
1529         uint256[] memory ids,
1530         uint256[] memory amounts,
1531         bytes memory data
1532     ) internal virtual {
1533         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1534         require(to != address(0), "ERC1155: transfer to the zero address");
1535 
1536         address operator = _msgSender();
1537 
1538         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1539 
1540         for (uint256 i = 0; i < ids.length; ++i) {
1541             uint256 id = ids[i];
1542             uint256 amount = amounts[i];
1543 
1544             uint256 fromBalance = _balances[id][from];
1545             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1546             unchecked {
1547                 _balances[id][from] = fromBalance - amount;
1548             }
1549             _balances[id][to] += amount;
1550         }
1551 
1552         emit TransferBatch(operator, from, to, ids, amounts);
1553 
1554         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1555     }
1556 
1557     /**
1558      * @dev Sets a new URI for all token types, by relying on the token type ID
1559      * substitution mechanism
1560      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1561      *
1562      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1563      * URI or any of the amounts in the JSON file at said URI will be replaced by
1564      * clients with the token type ID.
1565      *
1566      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1567      * interpreted by clients as
1568      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1569      * for token type ID 0x4cce0.
1570      *
1571      * See {uri}.
1572      *
1573      * Because these URIs cannot be meaningfully represented by the {URI} event,
1574      * this function emits no events.
1575      */
1576     function _setURI(string memory newuri) internal virtual {
1577         _uri = newuri;
1578     }
1579 
1580     /**
1581      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1582      *
1583      * Emits a {TransferSingle} event.
1584      *
1585      * Requirements:
1586      *
1587      * - `account` cannot be the zero address.
1588      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1589      * acceptance magic value.
1590      */
1591     function _mint(
1592         address account,
1593         uint256 id,
1594         uint256 amount,
1595         bytes memory data
1596     ) internal virtual {
1597         require(account != address(0), "ERC1155: mint to the zero address");
1598 
1599         address operator = _msgSender();
1600 
1601         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1602 
1603         _balances[id][account] += amount;
1604         emit TransferSingle(operator, address(0), account, id, amount);
1605 
1606         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1607     }
1608 
1609     /**
1610      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1611      *
1612      * Requirements:
1613      *
1614      * - `ids` and `amounts` must have the same length.
1615      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1616      * acceptance magic value.
1617      */
1618     function _mintBatch(
1619         address to,
1620         uint256[] memory ids,
1621         uint256[] memory amounts,
1622         bytes memory data
1623     ) internal virtual {
1624         require(to != address(0), "ERC1155: mint to the zero address");
1625         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1626 
1627         address operator = _msgSender();
1628 
1629         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1630 
1631         for (uint256 i = 0; i < ids.length; i++) {
1632             _balances[ids[i]][to] += amounts[i];
1633         }
1634 
1635         emit TransferBatch(operator, address(0), to, ids, amounts);
1636 
1637         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1638     }
1639 
1640     /**
1641      * @dev Destroys `amount` tokens of token type `id` from `account`
1642      *
1643      * Requirements:
1644      *
1645      * - `account` cannot be the zero address.
1646      * - `account` must have at least `amount` tokens of token type `id`.
1647      */
1648     function _burn(
1649         address account,
1650         uint256 id,
1651         uint256 amount
1652     ) internal virtual {
1653         require(account != address(0), "ERC1155: burn from the zero address");
1654 
1655         address operator = _msgSender();
1656 
1657         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1658 
1659         uint256 accountBalance = _balances[id][account];
1660         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1661         unchecked {
1662             _balances[id][account] = accountBalance - amount;
1663         }
1664 
1665         emit TransferSingle(operator, account, address(0), id, amount);
1666     }
1667 
1668     /**
1669      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1670      *
1671      * Requirements:
1672      *
1673      * - `ids` and `amounts` must have the same length.
1674      */
1675     function _burnBatch(
1676         address account,
1677         uint256[] memory ids,
1678         uint256[] memory amounts
1679     ) internal virtual {
1680         require(account != address(0), "ERC1155: burn from the zero address");
1681         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1682 
1683         address operator = _msgSender();
1684 
1685         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1686 
1687         for (uint256 i = 0; i < ids.length; i++) {
1688             uint256 id = ids[i];
1689             uint256 amount = amounts[i];
1690 
1691             uint256 accountBalance = _balances[id][account];
1692             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1693             unchecked {
1694                 _balances[id][account] = accountBalance - amount;
1695             }
1696         }
1697 
1698         emit TransferBatch(operator, account, address(0), ids, amounts);
1699     }
1700 
1701     /**
1702      * @dev Hook that is called before any token transfer. This includes minting
1703      * and burning, as well as batched variants.
1704      *
1705      * The same hook is called on both single and batched variants. For single
1706      * transfers, the length of the `id` and `amount` arrays will be 1.
1707      *
1708      * Calling conditions (for each `id` and `amount` pair):
1709      *
1710      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1711      * of token type `id` will be  transferred to `to`.
1712      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1713      * for `to`.
1714      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1715      * will be burned.
1716      * - `from` and `to` are never both zero.
1717      * - `ids` and `amounts` have the same, non-zero length.
1718      *
1719      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1720      */
1721     function _beforeTokenTransfer(
1722         address operator,
1723         address from,
1724         address to,
1725         uint256[] memory ids,
1726         uint256[] memory amounts,
1727         bytes memory data
1728     ) internal virtual {}
1729 
1730     function _doSafeTransferAcceptanceCheck(
1731         address operator,
1732         address from,
1733         address to,
1734         uint256 id,
1735         uint256 amount,
1736         bytes memory data
1737     ) private {
1738         if (to.isContract()) {
1739             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1740                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1741                     revert("ERC1155: ERC1155Receiver rejected tokens");
1742                 }
1743             } catch Error(string memory reason) {
1744                 revert(reason);
1745             } catch {
1746                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1747             }
1748         }
1749     }
1750 
1751     function _doSafeBatchTransferAcceptanceCheck(
1752         address operator,
1753         address from,
1754         address to,
1755         uint256[] memory ids,
1756         uint256[] memory amounts,
1757         bytes memory data
1758     ) private {
1759         if (to.isContract()) {
1760             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1761                 bytes4 response
1762             ) {
1763                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1764                     revert("ERC1155: ERC1155Receiver rejected tokens");
1765                 }
1766             } catch Error(string memory reason) {
1767                 revert(reason);
1768             } catch {
1769                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1770             }
1771         }
1772     }
1773 
1774     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1775         uint256[] memory array = new uint256[](1);
1776         array[0] = element;
1777 
1778         return array;
1779     }
1780 }
1781 
1782 // File: contracts/ERC1155Tradeable.sol
1783 
1784 pragma solidity >=0.8;
1785 
1786 
1787 
1788 contract OwnableDelegateProxy {}
1789 
1790 contract ProxyRegistry {
1791     mapping(address => OwnableDelegateProxy) public proxies;
1792 }
1793 
1794 abstract contract ContextMixin {
1795     function msgSender() internal view returns (address payable sender) {
1796         if (msg.sender == address(this)) {
1797             bytes memory array = msg.data;
1798             uint256 index = msg.data.length;
1799             assembly {
1800                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1801                 sender := and(
1802                     mload(add(array, index)),
1803                     0xffffffffffffffffffffffffffffffffffffffff
1804                 )
1805             }
1806         } else {
1807             sender = payable(msg.sender);
1808         }
1809         return sender;
1810     }
1811 }
1812 
1813 contract Initializable {
1814     bool inited = false;
1815 
1816     modifier initializer() {
1817         require(!inited, "already inited");
1818         _;
1819         inited = true;
1820     }
1821 }
1822 
1823 contract EIP712Base is Initializable {
1824     struct EIP712Domain {
1825         string name;
1826         string version;
1827         address verifyingContract;
1828         bytes32 salt;
1829     }
1830 
1831     string public constant ERC712_VERSION = "1";
1832 
1833     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
1834         keccak256(
1835             bytes(
1836                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1837             )
1838         );
1839     bytes32 internal domainSeperator;
1840 
1841     // supposed to be called once while initializing.
1842     // one of the contracts that inherits this contract follows proxy pattern
1843     // so it is not possible to do this in a constructor
1844     function _initializeEIP712(string memory name) internal initializer {
1845         _setDomainSeperator(name);
1846     }
1847 
1848     function _setDomainSeperator(string memory name) internal {
1849         domainSeperator = keccak256(
1850             abi.encode(
1851                 EIP712_DOMAIN_TYPEHASH,
1852                 keccak256(bytes(name)),
1853                 keccak256(bytes(ERC712_VERSION)),
1854                 address(this),
1855                 bytes32(getChainId())
1856             )
1857         );
1858     }
1859 
1860     function getDomainSeperator() public view returns (bytes32) {
1861         return domainSeperator;
1862     }
1863 
1864     function getChainId() public view returns (uint256) {
1865         uint256 id;
1866         assembly {
1867             id := chainid()
1868         }
1869         return id;
1870     }
1871 
1872     /**
1873      * Accept message hash and returns hash message in EIP712 compatible form
1874      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1875      * https://eips.ethereum.org/EIPS/eip-712
1876      * "\\x19" makes the encoding deterministic
1877      * "\\x01" is the version byte to make it compatible to EIP-191
1878      */
1879     function toTypedMessageHash(bytes32 messageHash)
1880         internal
1881         view
1882         returns (bytes32)
1883     {
1884         return
1885             keccak256(
1886                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1887             );
1888     }
1889 }
1890 
1891 contract NativeMetaTransaction is EIP712Base {
1892     bytes32 private constant META_TRANSACTION_TYPEHASH =
1893         keccak256(
1894             bytes(
1895                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1896             )
1897         );
1898     event MetaTransactionExecuted(
1899         address userAddress,
1900         address payable relayerAddress,
1901         bytes functionSignature
1902     );
1903     mapping(address => uint256) nonces;
1904 
1905     /*
1906      * Meta transaction structure.
1907      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1908      * He should call the desired function directly in that case.
1909      */
1910     struct MetaTransaction {
1911         uint256 nonce;
1912         address from;
1913         bytes functionSignature;
1914     }
1915 
1916     function executeMetaTransaction(
1917         address userAddress,
1918         bytes memory functionSignature,
1919         bytes32 sigR,
1920         bytes32 sigS,
1921         uint8 sigV
1922     ) external payable returns (bytes memory) {
1923         MetaTransaction memory metaTx =
1924             MetaTransaction({
1925                 nonce: nonces[userAddress],
1926                 from: userAddress,
1927                 functionSignature: functionSignature
1928             });
1929 
1930         require(
1931             verify(userAddress, metaTx, sigR, sigS, sigV),
1932             "Signer and signature do not match"
1933         );
1934 
1935         // increase nonce for user (to avoid re-use)
1936         nonces[userAddress] += 1;
1937 
1938         emit MetaTransactionExecuted(
1939             userAddress,
1940             payable(msg.sender),
1941             functionSignature
1942         );
1943 
1944         // Append userAddress and relayer address at the end to extract it from calling context
1945         (bool success, bytes memory returnData) =
1946             address(this).call(
1947                 abi.encodePacked(functionSignature, userAddress)
1948             );
1949         require(success, "Function call not successful");
1950 
1951         return returnData;
1952     }
1953 
1954     function hashMetaTransaction(MetaTransaction memory metaTx)
1955         internal
1956         pure
1957         returns (bytes32)
1958     {
1959         return
1960             keccak256(
1961                 abi.encode(
1962                     META_TRANSACTION_TYPEHASH,
1963                     metaTx.nonce,
1964                     metaTx.from,
1965                     keccak256(metaTx.functionSignature)
1966                 )
1967             );
1968     }
1969 
1970     function getNonce(address user) public view returns (uint256 nonce) {
1971         nonce = nonces[user];
1972     }
1973 
1974     function verify(
1975         address signer,
1976         MetaTransaction memory metaTx,
1977         bytes32 sigR,
1978         bytes32 sigS,
1979         uint8 sigV
1980     ) internal view returns (bool) {
1981         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1982         return
1983             signer ==
1984             ecrecover(
1985                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1986                 sigV,
1987                 sigR,
1988                 sigS
1989             );
1990     }
1991 }
1992 
1993 abstract contract Pausable is Context {
1994     /**
1995      * @dev Emitted when the pause is triggered by `account`.
1996      */
1997     event Paused(address account);
1998 
1999     /**
2000      * @dev Emitted when the pause is lifted by `account`.
2001      */
2002     event Unpaused(address account);
2003 
2004     bool private _paused;
2005 
2006     /**
2007      * @dev Initializes the contract in unpaused state.
2008      */
2009     constructor() {
2010         _paused = false;
2011     }
2012 
2013     /**
2014      * @dev Returns true if the contract is paused, and false otherwise.
2015      */
2016     function paused() public view virtual returns (bool) {
2017         return _paused;
2018     }
2019 
2020     /**
2021      * @dev Modifier to make a function callable only when the contract is not paused.
2022      *
2023      * Requirements:
2024      *
2025      * - The contract must not be paused.
2026      */
2027     modifier whenNotPaused() {
2028         require(!paused(), "Pausable: paused");
2029         _;
2030     }
2031 
2032     /**
2033      * @dev Modifier to make a function callable only when the contract is paused.
2034      *
2035      * Requirements:
2036      *
2037      * - The contract must be paused.
2038      */
2039     modifier whenPaused() {
2040         require(paused(), "Pausable: not paused");
2041         _;
2042     }
2043 
2044     /**
2045      * @dev Triggers stopped state.
2046      *
2047      * Requirements:
2048      *
2049      * - The contract must not be paused.
2050      */
2051     function _pause() internal virtual whenNotPaused {
2052         _paused = true;
2053         emit Paused(_msgSender());
2054     }
2055 
2056     /**
2057      * @dev Returns to normal state.
2058      *
2059      * Requirements:
2060      *
2061      * - The contract must be paused.
2062      */
2063     function _unpause() internal virtual whenPaused {
2064         _paused = false;
2065         emit Unpaused(_msgSender());
2066     }
2067 }
2068 
2069 
2070 contract ERC1155Tradable is
2071     ContextMixin,
2072     ERC1155,
2073     NativeMetaTransaction,
2074     Ownable,
2075     Pausable
2076 {
2077     using Address for address;
2078 
2079     // Proxy registry address
2080     address public proxyRegistryAddress;
2081     // Contract name
2082     string public name;
2083     // Contract symbol
2084     string public symbol;
2085 
2086     // Mapping from token ID to account balances
2087     mapping(uint256 => mapping(address => uint256)) private balances;
2088 
2089     mapping(uint256 => uint256) private _supply;
2090 
2091     constructor(
2092         string memory _name,
2093         string memory _symbol,
2094         address _proxyRegistryAddress
2095     ) ERC1155("") {
2096         name = _name;
2097         symbol = _symbol;
2098         proxyRegistryAddress = _proxyRegistryAddress;
2099         _initializeEIP712(name);
2100     }
2101 
2102     /**
2103      * @dev Throws if called by any account other than the owner or their proxy
2104      */
2105     modifier onlyOwnerOrProxy() {
2106         require(
2107             _isOwnerOrProxy(_msgSender()),
2108             "ERC1155Tradable#onlyOwner: CALLER_IS_NOT_OWNER"
2109         );
2110         _;
2111     }
2112 
2113     /**
2114      * @dev Throws if called by any account other than _from or their proxy
2115      */
2116     modifier onlyApproved(address _from) {
2117         require(
2118             _from == _msgSender() || isApprovedForAll(_from, _msgSender()),
2119             "ERC1155Tradable#onlyApproved: CALLER_NOT_ALLOWED"
2120         );
2121         _;
2122     }
2123 
2124     function _isOwnerOrProxy(address _address) internal view returns (bool) {
2125         return owner() == _address || _isProxyForUser(owner(), _address);
2126     }
2127 
2128     function pause() external onlyOwnerOrProxy {
2129         _pause();
2130     }
2131 
2132     function unpause() external onlyOwnerOrProxy {
2133         _unpause();
2134     }
2135 
2136     /**
2137      * @dev See {IERC1155-balanceOf}.
2138      *
2139      * Requirements:
2140      *
2141      * - `account` cannot be the zero address.
2142      */
2143     function balanceOf(address account, uint256 id)
2144         public
2145         view
2146         virtual
2147         override
2148         returns (uint256)
2149     {
2150         require(
2151             account != address(0),
2152             "ERC1155: balance query for the zero address"
2153         );
2154         return balances[id][account];
2155     }
2156 
2157     /**
2158      * @dev See {IERC1155-balanceOfBatch}.
2159      *
2160      * Requirements:
2161      *
2162      * - `accounts` and `ids` must have the same length.
2163      */
2164     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
2165         public
2166         view
2167         virtual
2168         override
2169         returns (uint256[] memory)
2170     {
2171         require(
2172             accounts.length == ids.length,
2173             "ERC1155: accounts and ids length mismatch"
2174         );
2175 
2176         uint256[] memory batchBalances = new uint256[](accounts.length);
2177 
2178         for (uint256 i = 0; i < accounts.length; ++i) {
2179             batchBalances[i] = balanceOf(accounts[i], ids[i]);
2180         }
2181 
2182         return batchBalances;
2183     }
2184 
2185     /**
2186      * @dev Returns the total quantity for a token ID
2187      * @param _id uint256 ID of the token to query
2188      * @return amount of token in existence
2189      */
2190     function totalSupply(uint256 _id) public view returns (uint256) {
2191         return _supply[_id];
2192     }
2193 
2194     /**
2195      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
2196      */
2197     function isApprovedForAll(address _owner, address _operator)
2198         public
2199         view
2200         override
2201         returns (bool isOperator)
2202     {
2203         // Whitelist OpenSea proxy contracts for easy trading.
2204         if (_isProxyForUser(_owner, _operator)) {
2205             return true;
2206         }
2207 
2208         return super.isApprovedForAll(_owner, _operator);
2209     }
2210 
2211     /**
2212      * @dev See {IERC1155-safeTransferFrom}.
2213      */
2214     function safeTransferFrom(
2215         address from,
2216         address to,
2217         uint256 id,
2218         uint256 amount,
2219         bytes memory data
2220     ) public virtual override whenNotPaused onlyApproved(from) {
2221         require(to != address(0), "ERC1155: transfer to the zero address");
2222 
2223         address operator = _msgSender();
2224 
2225         _beforeTokenTransfer(
2226             operator,
2227             from,
2228             to,
2229             asSingletonArray(id),
2230             asSingletonArray(amount),
2231             data
2232         );
2233 
2234         uint256 fromBalance = balances[id][from];
2235         require(
2236             fromBalance >= amount,
2237             "ERC1155: insufficient balance for transfer"
2238         );
2239         balances[id][from] = fromBalance - amount;
2240         balances[id][to] += amount;
2241 
2242         emit TransferSingle(operator, from, to, id, amount);
2243 
2244         doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
2245     }
2246 
2247     /**
2248      * @dev See {IERC1155-safeBatchTransferFrom}.
2249      */
2250     function safeBatchTransferFrom(
2251         address from,
2252         address to,
2253         uint256[] memory ids,
2254         uint256[] memory amounts,
2255         bytes memory data
2256     ) public virtual override whenNotPaused onlyApproved(from) {
2257         require(
2258             ids.length == amounts.length,
2259             "ERC1155: IDS_AMOUNTS_LENGTH_MISMATCH"
2260         );
2261         require(to != address(0), "ERC1155: transfer to the zero address");
2262 
2263         address operator = _msgSender();
2264 
2265         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2266 
2267         for (uint256 i = 0; i < ids.length; ++i) {
2268             uint256 id = ids[i];
2269             uint256 amount = amounts[i];
2270 
2271             uint256 fromBalance = balances[id][from];
2272             require(
2273                 fromBalance >= amount,
2274                 "ERC1155: insufficient balance for transfer"
2275             );
2276             balances[id][from] = fromBalance - amount;
2277             balances[id][to] += amount;
2278         }
2279 
2280         emit TransferBatch(operator, from, to, ids, amounts);
2281 
2282         doSafeBatchTransferAcceptanceCheck(
2283             operator,
2284             from,
2285             to,
2286             ids,
2287             amounts,
2288             data
2289         );
2290     }
2291 
2292     /**
2293      * @dev Hook to be called right before minting
2294      * @param _id          Token ID to mint
2295      * @param _quantity    Amount of tokens to mint
2296      */
2297     function _beforeMint(uint256 _id, uint256 _quantity) internal virtual {}
2298 
2299     /**
2300      * @dev Mints some amount of tokens to an address
2301      * @param _to          Address of the future owner of the token
2302      * @param _id          Token ID to mint
2303      * @param _quantity    Amount of tokens to mint
2304      * @param _data        Data to pass if receiver is contract
2305      */
2306     function mint(
2307         address _to,
2308         uint256 _id,
2309         uint256 _quantity,
2310         bytes memory _data
2311     ) public virtual onlyOwnerOrProxy {
2312         _mint(_to, _id, _quantity, _data);
2313     }
2314 
2315     /**
2316      * @dev Mint tokens for each id in _ids
2317      * @param _to          The address to mint tokens to
2318      * @param _ids         Array of ids to mint
2319      * @param _quantities  Array of amounts of tokens to mint per id
2320      * @param _data        Data to pass if receiver is contract
2321      */
2322     function batchMint(
2323         address _to,
2324         uint256[] memory _ids,
2325         uint256[] memory _quantities,
2326         bytes memory _data
2327     ) public virtual onlyOwnerOrProxy {
2328         _batchMint(_to, _ids, _quantities, _data);
2329     }
2330 
2331     /**
2332      * @dev Burns amount of a given token id
2333      * @param _from          The address to burn tokens from
2334      * @param _id          Token ID to burn
2335      * @param _quantity    Amount to burn
2336      */
2337     function burn(
2338         address _from,
2339         uint256 _id,
2340         uint256 _quantity
2341     ) public virtual onlyApproved(_from) {
2342         _burn(_from, _id, _quantity);
2343     }
2344 
2345     /**
2346      * @dev Burns tokens for each id in _ids
2347      * @param _from          The address to burn tokens from
2348      * @param _ids         Array of token ids to burn
2349      * @param _quantities  Array of the amount to be burned
2350      */
2351     function batchBurn(
2352         address _from,
2353         uint256[] memory _ids,
2354         uint256[] memory _quantities
2355     ) public virtual onlyApproved(_from) {
2356         _burnBatch(_from, _ids, _quantities);
2357     }
2358 
2359     /**
2360      * @dev Returns whether the specified token is minted
2361      * @param _id uint256 ID of the token to query the existence of
2362      * @return bool whether the token exists
2363      */
2364     function exists(uint256 _id) public view returns (bool) {
2365         return _supply[_id] > 0;
2366     }
2367 
2368     // Overrides ERC1155 _mint to allow changing birth events to creator transfers,
2369     // and to set _supply
2370     function _mint(
2371         address _to,
2372         uint256 _id,
2373         uint256 _amount,
2374         bytes memory _data
2375     ) internal virtual override whenNotPaused {
2376         address operator = _msgSender();
2377 
2378         _beforeTokenTransfer(
2379             operator,
2380             address(0),
2381             _to,
2382             asSingletonArray(_id),
2383             asSingletonArray(_amount),
2384             _data
2385         );
2386 
2387         _beforeMint(_id, _amount);
2388 
2389         // Add _amount
2390         balances[_id][_to] += _amount;
2391         _supply[_id] += _amount;
2392 
2393         // Origin of token will be the _from parameter
2394         address origin = _origin(_id);
2395 
2396         // Emit event
2397         emit TransferSingle(operator, origin, _to, _id, _amount);
2398 
2399         // Calling onReceive method if recipient is contract
2400         doSafeTransferAcceptanceCheck(
2401             operator,
2402             origin,
2403             _to,
2404             _id,
2405             _amount,
2406             _data
2407         );
2408     }
2409 
2410     // Overrides ERC1155MintBurn to change the batch birth events to creator transfers, and to set _supply
2411     function _batchMint(
2412         address _to,
2413         uint256[] memory _ids,
2414         uint256[] memory _amounts,
2415         bytes memory _data
2416     ) internal virtual whenNotPaused {
2417         require(
2418             _ids.length == _amounts.length,
2419             "ERC1155Tradable#batchMint: INVALID_ARRAYS_LENGTH"
2420         );
2421 
2422         // Number of mints to execute
2423         uint256 nMint = _ids.length;
2424 
2425         // Origin of tokens will be the _from parameter
2426         address origin = _origin(_ids[0]);
2427 
2428         address operator = _msgSender();
2429 
2430         _beforeTokenTransfer(operator, address(0), _to, _ids, _amounts, _data);
2431 
2432         // Executing all minting
2433         for (uint256 i = 0; i < nMint; i++) {
2434             // Update storage balance
2435             uint256 id = _ids[i];
2436             uint256 amount = _amounts[i];
2437             _beforeMint(id, amount);
2438             require(
2439                 _origin(id) == origin,
2440                 "ERC1155Tradable#batchMint: MULTIPLE_ORIGINS_NOT_ALLOWED"
2441             );
2442             balances[id][_to] += amount;
2443             _supply[id] += amount;
2444         }
2445 
2446         // Emit batch mint event
2447         emit TransferBatch(operator, origin, _to, _ids, _amounts);
2448 
2449         // Calling onReceive method if recipient is contract
2450         doSafeBatchTransferAcceptanceCheck(
2451             operator,
2452             origin,
2453             _to,
2454             _ids,
2455             _amounts,
2456             _data
2457         );
2458     }
2459 
2460     /**
2461      * @dev Destroys `amount` tokens of token type `id` from `account`
2462      *
2463      * Requirements:
2464      *
2465      * - `account` cannot be the zero address.
2466      * - `account` must have at least `amount` tokens of token type `id`.
2467      */
2468     function _burn(
2469         address account,
2470         uint256 id,
2471         uint256 amount
2472     ) internal override whenNotPaused {
2473         require(account != address(0), "ERC1155#_burn: BURN_FROM_ZERO_ADDRESS");
2474         require(amount > 0, "ERC1155#_burn: AMOUNT_LESS_THAN_ONE");
2475 
2476         address operator = _msgSender();
2477 
2478         _beforeTokenTransfer(
2479             operator,
2480             account,
2481             address(0),
2482             asSingletonArray(id),
2483             asSingletonArray(amount),
2484             ""
2485         );
2486 
2487         uint256 accountBalance = balances[id][account];
2488         require(
2489             accountBalance >= amount,
2490             "ERC1155#_burn: AMOUNT_EXCEEDS_BALANCE"
2491         );
2492         balances[id][account] = accountBalance - amount;
2493         _supply[id] -= amount;
2494 
2495         emit TransferSingle(operator, account, address(0), id, amount);
2496     }
2497 
2498     /**
2499      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
2500      *
2501      * Requirements:
2502      *
2503      * - `ids` and `amounts` must have the same length.
2504      */
2505     function _burnBatch(
2506         address account,
2507         uint256[] memory ids,
2508         uint256[] memory amounts
2509     ) internal override whenNotPaused {
2510         require(account != address(0), "ERC1155: BURN_FROM_ZERO_ADDRESS");
2511         require(
2512             ids.length == amounts.length,
2513             "ERC1155: IDS_AMOUNTS_LENGTH_MISMATCH"
2514         );
2515 
2516         address operator = _msgSender();
2517 
2518         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
2519 
2520         for (uint256 i = 0; i < ids.length; i++) {
2521             uint256 id = ids[i];
2522             uint256 amount = amounts[i];
2523 
2524             uint256 accountBalance = balances[id][account];
2525             require(
2526                 accountBalance >= amount,
2527                 "ERC1155#_burnBatch: AMOUNT_EXCEEDS_BALANCE"
2528             );
2529             balances[id][account] = accountBalance - amount;
2530             _supply[id] -= amount;
2531         }
2532 
2533         emit TransferBatch(operator, account, address(0), ids, amounts);
2534     }
2535 
2536     // Override this to change birth events' _from address
2537     function _origin(
2538         uint256 /* _id */
2539     ) internal view virtual returns (address) {
2540         return address(0);
2541     }
2542 
2543     // PROXY HELPER METHODS
2544 
2545     function _isProxyForUser(address _user, address _address)
2546         internal
2547         view
2548         virtual
2549         returns (bool)
2550     {
2551         if (!proxyRegistryAddress.isContract()) {
2552             return false;
2553         }
2554         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
2555         return address(proxyRegistry.proxies(_user)) == _address;
2556     }
2557 
2558     // Copied from OpenZeppelin
2559     // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/c3ae4790c71b7f53cc8fff743536dcb7031fed74/contracts/token/ERC1155/ERC1155.sol#L394
2560     function doSafeTransferAcceptanceCheck(
2561         address operator,
2562         address from,
2563         address to,
2564         uint256 id,
2565         uint256 amount,
2566         bytes memory data
2567     ) private {
2568         if (to.isContract()) {
2569             try
2570                 IERC1155Receiver(to).onERC1155Received(
2571                     operator,
2572                     from,
2573                     id,
2574                     amount,
2575                     data
2576                 )
2577             returns (bytes4 response) {
2578                 if (
2579                     response != IERC1155Receiver(to).onERC1155Received.selector
2580                 ) {
2581                     revert("ERC1155: ERC1155Receiver rejected tokens");
2582                 }
2583             } catch Error(string memory reason) {
2584                 revert(reason);
2585             } catch {
2586                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2587             }
2588         }
2589     }
2590 
2591     // Copied from OpenZeppelin
2592     // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/c3ae4790c71b7f53cc8fff743536dcb7031fed74/contracts/token/ERC1155/ERC1155.sol#L417
2593     function doSafeBatchTransferAcceptanceCheck(
2594         address operator,
2595         address from,
2596         address to,
2597         uint256[] memory ids,
2598         uint256[] memory amounts,
2599         bytes memory data
2600     ) internal {
2601         if (to.isContract()) {
2602             try
2603                 IERC1155Receiver(to).onERC1155BatchReceived(
2604                     operator,
2605                     from,
2606                     ids,
2607                     amounts,
2608                     data
2609                 )
2610             returns (bytes4 response) {
2611                 if (
2612                     response !=
2613                     IERC1155Receiver(to).onERC1155BatchReceived.selector
2614                 ) {
2615                     revert("ERC1155: ERC1155Receiver rejected tokens");
2616                 }
2617             } catch Error(string memory reason) {
2618                 revert(reason);
2619             } catch {
2620                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2621             }
2622         }
2623     }
2624 
2625     // Copied from OpenZeppelin
2626     // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/c3ae4790c71b7f53cc8fff743536dcb7031fed74/contracts/token/ERC1155/ERC1155.sol#L440
2627     function asSingletonArray(uint256 element)
2628         private
2629         pure
2630         returns (uint256[] memory)
2631     {
2632         uint256[] memory array = new uint256[](1);
2633         array[0] = element;
2634 
2635         return array;
2636     }
2637 
2638     /**
2639      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
2640      */
2641     function _msgSender() internal view override returns (address sender) {
2642         return ContextMixin.msgSender();
2643     }
2644 }
2645 
2646 // File: contracts/NFTheo.sol
2647 
2648   
2649 
2650 pragma solidity >= 0.8.0;
2651 
2652 
2653 
2654 
2655 
2656 
2657 contract NFTheo is
2658     Ownable, 
2659     ReentrancyGuard, 
2660     ERC721
2661 {
2662     using Address for address payable;
2663 
2664     bool public locked = true;
2665     bool public early = true;
2666 
2667     mapping(address => bool) private earlyMinted;
2668     
2669     // maximum number of tokens to exist
2670     uint256 constant MAX_MINTABLE_TOKENS = 2600;
2671     // current number of tokens in existence
2672     uint256 public minted = 0;
2673     // used to track which IDs have been used
2674     uint256[MAX_MINTABLE_TOKENS] public indices;
2675     
2676     // number of legacy tokens
2677     uint256 constant private LEGACY_TOKENS = 400;
2678     // current number of tokens mapped
2679     uint256 private mapped;
2680     // used to map legacy NFTheos to new ones
2681     mapping(uint256 => uint256) public legacyMapping;
2682     
2683 
2684     // address to withdraw funds
2685     address payable public teamAddress;
2686     // instance of legacy contract
2687     ERC1155Tradable legacyContract;
2688     // URI of metadata
2689     string baseURI;
2690     
2691     event TeamAddressChanged(
2692         address teamAddress
2693     );
2694     
2695     constructor(
2696         address _legacyContract,
2697         string memory _uri
2698     ) ERC721("NFTheo", "NFTheo") {
2699         legacyContract = ERC1155Tradable(_legacyContract);
2700         baseURI = _uri;
2701         teamAddress = payable(_msgSender());
2702     }
2703     
2704     /*************/
2705     /* MODIFIERS */
2706     /*************/
2707     
2708 
2709     modifier onlyUnlocked() {
2710         require(!locked, "Contract is locked");
2711         _;
2712     }
2713 
2714     modifier limitEarly(uint256 quantity) {
2715         if (early) {
2716             require(balanceOf(_msgSender()) > 0, "Only migrated legacy owners can currently mint");
2717             require(earlyMinted[_msgSender()] == false, "Can only mint once early");
2718             require(quantity <= 2, "Can only mint two early");
2719             earlyMinted[_msgSender()] = true;
2720         }
2721         _;
2722     }
2723 
2724     /***********************/
2725     /* USER INTERACTIONS   */
2726     /***********************/
2727 
2728 
2729     /**
2730      * @notice mints NFTs with random IDs
2731      * @param quantity the number of NFTs to create
2732      */
2733     function mint(uint256 quantity) external payable nonReentrant onlyUnlocked limitEarly(quantity) {
2734         require(minted + quantity <= MAX_MINTABLE_TOKENS, "Exceeds max NFT supply");
2735         require(quantity > 0, "Cannot mint 0 NFTs");
2736         require(quantity <= 5, "Cannot mint more than 5 NFTs at once");
2737         require(msg.value == nftCost() * quantity, "Incorrect payment amount");
2738 
2739         uint256 id;
2740         for (uint i = 0; i < quantity; i++) {
2741             id = randomID();
2742             _safeMint(_msgSender(), id);
2743             minted = minted + 1;
2744         }
2745     }
2746     
2747     /**
2748      * @notice burns a legacy NFT in return for a current NFT
2749      * @param tokenId ID of token to swap
2750      */
2751     function redeem(uint256 tokenId) external nonReentrant onlyUnlocked { 
2752         require(legacyContract.balanceOf(_msgSender(), tokenId) > 0, "Must own token to redeem");
2753         require(legacyMapping[tokenId] != 0, "Invalid legacy ID");
2754         _safeMint(_msgSender(), legacyMapping[tokenId]);
2755         legacyContract.safeTransferFrom(_msgSender(), address(0xdead), tokenId, 1, "");
2756     }
2757 
2758     /***********/
2759     /* GETTERS */
2760     /***********/
2761 
2762     /**
2763      * @notice current cost to create a single avatar
2764      * @return cost to create
2765      */
2766     function nftCost() public pure returns (uint256) {
2767         return 0.08 ether;
2768     }
2769 
2770     /***********/
2771     /* PRIVATE */
2772     /***********/
2773     
2774     /**
2775      * @notice generates random IDs without collisions
2776      * @return random ID
2777      */
2778     function randomID() internal returns (uint) {
2779         uint remaining = MAX_MINTABLE_TOKENS - minted;
2780         uint random = uint(keccak256(abi.encodePacked(minted, msg.sender, block.difficulty, block.timestamp))) % remaining;
2781         uint value = indices[random] == 0 ? random : indices[random];
2782 
2783         indices[random] = indices[remaining - 1] == 0 ? remaining - 1 : indices[remaining - 1];
2784 
2785         return value + LEGACY_TOKENS + 1;
2786     }
2787 
2788     function _baseURI() internal view override returns (string memory) {
2789         return baseURI;
2790     }
2791     
2792     /*********/
2793     /* OWNER */
2794     /*********/
2795 
2796     /**
2797      * @notice withdraws funds that are owed to the project (contract balance - total held in reserve)
2798      */
2799     function withdraw() external onlyOwner {
2800         payable(teamAddress).transfer(
2801             address(this).balance
2802         );
2803     }
2804     
2805     /**
2806      * @notice adds tokenIds to legacyMapping
2807      * @param newIds tokenIds, in order, of the new tokens
2808      * @param oldIds tokenIds, in order, referencing the same index new token
2809      */
2810     function addLegacyMappings(uint256[] calldata newIds, uint256[] calldata oldIds) external onlyOwner {
2811         for (uint i = 0; i < oldIds.length; i++) {
2812             require(newIds[i] <= LEGACY_TOKENS, "Invalid new ID");
2813             legacyMapping[oldIds[i]] = newIds[i];
2814         }
2815     }
2816 
2817     /**
2818      * @notice owner mint of tokens from legacy set in case of issues migrating
2819      * @param tokenIds to mint
2820      */
2821     function rescue(uint256[] calldata tokenIds) external onlyOwner {
2822         for (uint i = 0; i < tokenIds.length; i++) {
2823             require(tokenIds[i] <= LEGACY_TOKENS, "Must be legacy token");
2824             _safeMint(_msgSender(), tokenIds[i]);
2825         }
2826     }
2827     
2828     /**
2829      * @notice owner mint of tokens before public mint is available
2830      * @param tokenIds to mint 
2831      */
2832     function ownerMint(uint256[] calldata tokenIds) external onlyOwner {
2833         uint remaining = MAX_MINTABLE_TOKENS - minted;
2834         require(tokenIds.length <= remaining, "Exceeds number of available tokens");
2835         for (uint i = 0; i < tokenIds.length; i++) {
2836             require(tokenIds[i] <= LEGACY_TOKENS + MAX_MINTABLE_TOKENS, "Cannot mint token out of range");
2837             require(indices[tokenIds[i] - LEGACY_TOKENS - 1] == 0, "Cannot mint already claimed token");
2838             indices[tokenIds[i] - LEGACY_TOKENS - 1] = remaining - i - 1;
2839             _safeMint(_msgSender(), tokenIds[i]);
2840             minted = minted + 1;
2841         }
2842     }
2843     
2844     /**
2845      * @notice sets the address to send withdrawable funds to
2846      * @param _teamAddress the new destination address
2847      */
2848     function setTeamAddress(address payable _teamAddress) public onlyOwner {
2849         teamAddress = _teamAddress;
2850         emit TeamAddressChanged(teamAddress);
2851     }
2852 
2853     function setLocked(bool _locked) external onlyOwner {
2854         locked = _locked;
2855     }
2856 
2857     function setEarly(bool _early) external onlyOwner {
2858         early = _early;
2859     }
2860 
2861     function setBaseURI(string calldata _uri) external onlyOwner {
2862         baseURI = _uri;
2863     }
2864 }