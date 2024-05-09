1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 /**
5 
6 pragma solidity ^0.8.0;
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 pragma solidity ^0.8.0;
28 
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _setOwner(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         _setOwner(address(0));
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         _setOwner(newOwner);
87     }
88 
89     function _setOwner(address newOwner) private {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Contract module that helps prevent reentrant calls to a function.
101  *
102  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
103  * available, which can be applied to functions to make sure there are no nested
104  * (reentrant) calls to them.
105  *
106  * Note that because there is a single `nonReentrant` guard, functions marked as
107  * `nonReentrant` may not call one another. This can be worked around by making
108  * those functions `private`, and then adding `external` `nonReentrant` entry
109  * points to them.
110  *
111  * TIP: If you would like to learn more about reentrancy and alternative ways
112  * to protect against it, check out our blog post
113  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
114  */
115 abstract contract ReentrancyGuard {
116     // Booleans are more expensive than uint256 or any type that takes up a full
117     // word because each write operation emits an extra SLOAD to first read the
118     // slot's contents, replace the bits taken up by the boolean, and then write
119     // back. This is the compiler's defense against contract upgrades and
120     // pointer aliasing, and it cannot be disabled.
121 
122     // The values being non-zero value makes deployment a bit more expensive,
123     // but in exchange the refund on every call to nonReentrant will be lower in
124     // amount. Since refunds are capped to a percentage of the total
125     // transaction's gas, it is best to keep them low in cases like this one, to
126     // increase the likelihood of the full refund coming into effect.
127     uint256 private constant _NOT_ENTERED = 1;
128     uint256 private constant _ENTERED = 2;
129 
130     uint256 private _status;
131 
132     constructor() {
133         _status = _NOT_ENTERED;
134     }
135 
136     /**
137      * @dev Prevents a contract from calling itself, directly or indirectly.
138      * Calling a `nonReentrant` function from another `nonReentrant`
139      * function is not supported. It is possible to prevent this from happening
140      * by making the `nonReentrant` function external, and make it call a
141      * `private` function that does the actual work.
142      */
143     modifier nonReentrant() {
144         // On the first call to nonReentrant, _notEntered will be true
145         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
146 
147         // Any calls to nonReentrant after this point will fail
148         _status = _ENTERED;
149 
150         _;
151 
152         // By storing the original value once again, a refund is triggered (see
153         // https://eips.ethereum.org/EIPS/eip-2200)
154         _status = _NOT_ENTERED;
155     }
156 }
157 
158 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev Interface of the ERC165 standard, as defined in the
163  * https://eips.ethereum.org/EIPS/eip-165[EIP].
164  *
165  * Implementers can declare support of contract interfaces, which can then be
166  * queried by others ({ERC165Checker}).
167  *
168  * For an implementation, see {ERC165}.
169  */
170 interface IERC165 {
171     /**
172      * @dev Returns true if this contract implements the interface defined by
173      * `interfaceId`. See the corresponding
174      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
175      * to learn more about how these ids are created.
176      *
177      * This function call must use less than 30 000 gas.
178      */
179     function supportsInterface(bytes4 interfaceId) external view returns (bool);
180 }
181 
182 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @dev Required interface of an ERC721 compliant contract.
188  */
189 interface IERC721 is IERC165 {
190     /**
191      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
197      */
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
202      */
203     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
204 
205     /**
206      * @dev Returns the number of tokens in ``owner``'s account.
207      */
208     function balanceOf(address owner) external view returns (uint256 balance);
209 
210     /**
211      * @dev Returns the owner of the `tokenId` token.
212      *
213      * Requirements:
214      *
215      * - `tokenId` must exist.
216      */
217     function ownerOf(uint256 tokenId) external view returns (address owner);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
221      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
222      *
223      * Requirements:
224      *
225      * - `from` cannot be the zero address.
226      * - `to` cannot be the zero address.
227      * - `tokenId` token must exist and be owned by `from`.
228      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
230      *
231      * Emits a {Transfer} event.
232      */
233     function safeTransferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) external;
238 
239     /**
240      * @dev Transfers `tokenId` token from `from` to `to`.
241      *
242      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must be owned by `from`.
249      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(
254         address from,
255         address to,
256         uint256 tokenId
257     ) external;
258 
259     /**
260      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
261      * The approval is cleared when the token is transferred.
262      *
263      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
264      *
265      * Requirements:
266      *
267      * - The caller must own the token or be an approved operator.
268      * - `tokenId` must exist.
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address to, uint256 tokenId) external;
273 
274     /**
275      * @dev Returns the account approved for `tokenId` token.
276      *
277      * Requirements:
278      *
279      * - `tokenId` must exist.
280      */
281     function getApproved(uint256 tokenId) external view returns (address operator);
282 
283     /**
284      * @dev Approve or remove `operator` as an operator for the caller.
285      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
286      *
287      * Requirements:
288      *
289      * - The `operator` cannot be the caller.
290      *
291      * Emits an {ApprovalForAll} event.
292      */
293     function setApprovalForAll(address operator, bool _approved) external;
294 
295     /**
296      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
297      *
298      * See {setApprovalForAll}
299      */
300     function isApprovedForAll(address owner, address operator) external view returns (bool);
301 
302     /**
303      * @dev Safely transfers `tokenId` token from `from` to `to`.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must exist and be owned by `from`.
310      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
311      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
312      *
313      * Emits a {Transfer} event.
314      */
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId,
319         bytes calldata data
320     ) external;
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @title ERC721 token receiver interface
328  * @dev Interface for any contract that wants to support safeTransfers
329  * from ERC721 asset contracts.
330  */
331 interface IERC721Receiver {
332     /**
333      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
334      * by `operator` from `from`, this function is called.
335      *
336      * It must return its Solidity selector to confirm the token transfer.
337      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
338      *
339      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
340      */
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 
349 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
355  * @dev See https://eips.ethereum.org/EIPS/eip-721
356  */
357 interface IERC721Metadata is IERC721 {
358     /**
359      * @dev Returns the token collection name.
360      */
361     function name() external view returns (string memory);
362 
363     /**
364      * @dev Returns the token collection symbol.
365      */
366     function symbol() external view returns (string memory);
367 
368     /**
369      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
370      */
371     function tokenURI(uint256 tokenId) external view returns (string memory);
372 }
373 
374 // File: @openzeppelin/contracts/utils/Address.sol
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies on extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         uint256 size;
404         assembly {
405             size := extcodesize(account)
406         }
407         return size > 0;
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
427         require(address(this).balance >= amount, "Address: insufficient balance");
428 
429         (bool success, ) = recipient.call{value: amount}("");
430         require(success, "Address: unable to send value, recipient may have reverted");
431     }
432 
433     /**
434      * @dev Performs a Solidity function call using a low level `call`. A
435      * plain `call` is an unsafe replacement for a function call: use this
436      * function instead.
437      *
438      * If `target` reverts with a revert reason, it is bubbled up by this
439      * function (like regular Solidity function calls).
440      *
441      * Returns the raw returned data. To convert to the expected return value,
442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
443      *
444      * Requirements:
445      *
446      * - `target` must be a contract.
447      * - calling `target` with `data` must not revert.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
452         return functionCall(target, data, "Address: low-level call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
457      * `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         return functionCallWithValue(target, data, 0, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but also transferring `value` wei to `target`.
472      *
473      * Requirements:
474      *
475      * - the calling contract must have an ETH balance of at least `value`.
476      * - the called Solidity function must be `payable`.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value
484     ) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
490      * with `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(address(this).balance >= value, "Address: insufficient balance for call");
501         require(isContract(target), "Address: call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.call{value: value}(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a static call.
510      *
511      * _Available since v3.3._
512      */
513     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
514         return functionStaticCall(target, data, "Address: low-level static call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal view returns (bytes memory) {
528         require(isContract(target), "Address: static call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.staticcall(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a delegate call.
537      *
538      * _Available since v3.4._
539      */
540     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         require(isContract(target), "Address: delegate call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.delegatecall(data);
558         return verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
563      * revert reason using the provided one.
564      *
565      * _Available since v4.3._
566      */
567     function verifyCallResult(
568         bool success,
569         bytes memory returndata,
570         string memory errorMessage
571     ) internal pure returns (bytes memory) {
572         if (success) {
573             return returndata;
574         } else {
575             // Look for revert reason and bubble it up if present
576             if (returndata.length > 0) {
577                 // The easiest way to bubble the revert reason is using memory via assembly
578 
579                 assembly {
580                     let returndata_size := mload(returndata)
581                     revert(add(32, returndata), returndata_size)
582                 }
583             } else {
584                 revert(errorMessage);
585             }
586         }
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/Strings.sol
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
601      */
602     function toString(uint256 value) internal pure returns (string memory) {
603         // Inspired by OraclizeAPI's implementation - MIT licence
604         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
605 
606         if (value == 0) {
607             return "0";
608         }
609         uint256 temp = value;
610         uint256 digits;
611         while (temp != 0) {
612             digits++;
613             temp /= 10;
614         }
615         bytes memory buffer = new bytes(digits);
616         while (value != 0) {
617             digits -= 1;
618             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
619             value /= 10;
620         }
621         return string(buffer);
622     }
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
626      */
627     function toHexString(uint256 value) internal pure returns (string memory) {
628         if (value == 0) {
629             return "0x00";
630         }
631         uint256 temp = value;
632         uint256 length = 0;
633         while (temp != 0) {
634             length++;
635             temp >>= 8;
636         }
637         return toHexString(value, length);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
642      */
643     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
644         bytes memory buffer = new bytes(2 * length + 2);
645         buffer[0] = "0";
646         buffer[1] = "x";
647         for (uint256 i = 2 * length + 1; i > 1; --i) {
648             buffer[i] = _HEX_SYMBOLS[value & 0xf];
649             value >>= 4;
650         }
651         require(value == 0, "Strings: hex length insufficient");
652         return string(buffer);
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @dev Implementation of the {IERC165} interface.
662  *
663  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
664  * for the additional interface id that will be supported. For example:
665  *
666  * ```solidity
667  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
668  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
669  * }
670  * ```
671  *
672  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
673  */
674 abstract contract ERC165 is IERC165 {
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      */
678     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679         return interfaceId == type(IERC165).interfaceId;
680     }
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
688  * the Metadata extension, but not including the Enumerable extension, which is available separately as
689  * {ERC721Enumerable}.
690  */
691 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
692     using Address for address;
693     using Strings for uint256;
694 
695     // Token name
696     string private _name;
697 
698     // Token symbol
699     string private _symbol;
700 
701     // Mapping from token ID to owner address
702     mapping(uint256 => address) private _owners;
703 
704     // Mapping owner address to token count
705     mapping(address => uint256) private _balances;
706 
707     // Mapping from token ID to approved address
708     mapping(uint256 => address) private _tokenApprovals;
709 
710     // Mapping from owner to operator approvals
711     mapping(address => mapping(address => bool)) private _operatorApprovals;
712 
713     /**
714      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
715      */
716     constructor(string memory name_, string memory symbol_) {
717         _name = name_;
718         _symbol = symbol_;
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726             interfaceId == type(IERC721).interfaceId ||
727             interfaceId == type(IERC721Metadata).interfaceId ||
728             super.supportsInterface(interfaceId);
729     }
730 
731     /**
732      * @dev See {IERC721-balanceOf}.
733      */
734     function balanceOf(address owner) public view virtual override returns (uint256) {
735         require(owner != address(0), "ERC721: balance query for the zero address");
736         return _balances[owner];
737     }
738 
739     /**
740      * @dev See {IERC721-ownerOf}.
741      */
742     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
743         address owner = _owners[tokenId];
744         require(owner != address(0), "ERC721: owner query for nonexistent token");
745         return owner;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-name}.
750      */
751     function name() public view virtual override returns (string memory) {
752         return _name;
753     }
754 
755     /**
756      * @dev See {IERC721Metadata-symbol}.
757      */
758     function symbol() public view virtual override returns (string memory) {
759         return _symbol;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-tokenURI}.
764      */
765     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
766         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
767 
768         string memory baseURI = _baseURI();
769         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
770     }
771 
772     /**
773      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
774      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
775      * by default, can be overriden in child contracts.
776      */
777     function _baseURI() internal view virtual returns (string memory) {
778         return "";
779     }
780 
781     /**
782      * @dev See {IERC721-approve}.
783      */
784     function approve(address to, uint256 tokenId) public virtual override {
785         address owner = ERC721.ownerOf(tokenId);
786         require(to != owner, "ERC721: approval to current owner");
787 
788         require(
789             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
790             "ERC721: approve caller is not owner nor approved for all"
791         );
792 
793         _approve(to, tokenId);
794     }
795 
796     /**
797      * @dev See {IERC721-getApproved}.
798      */
799     function getApproved(uint256 tokenId) public view virtual override returns (address) {
800         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
801 
802         return _tokenApprovals[tokenId];
803     }
804 
805     /**
806      * @dev See {IERC721-setApprovalForAll}.
807      */
808     function setApprovalForAll(address operator, bool approved) public virtual override {
809         require(operator != _msgSender(), "ERC721: approve to caller");
810 
811         _operatorApprovals[_msgSender()][operator] = approved;
812         emit ApprovalForAll(_msgSender(), operator, approved);
813     }
814 
815     /**
816      * @dev See {IERC721-isApprovedForAll}.
817      */
818     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
819         return _operatorApprovals[owner][operator];
820     }
821 
822     /**
823      * @dev See {IERC721-transferFrom}.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public virtual override {
830         //solhint-disable-next-line max-line-length
831         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
832 
833         _transfer(from, to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         safeTransferFrom(from, to, tokenId, "");
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) public virtual override {
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857         _safeTransfer(from, to, tokenId, _data);
858     }
859 
860     /**
861      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
862      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
863      *
864      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
865      *
866      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
867      * implement alternative mechanisms to perform token transfer, such as signature-based.
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must exist and be owned by `from`.
874      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _safeTransfer(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) internal virtual {
884         _transfer(from, to, tokenId);
885         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
886     }
887 
888     /**
889      * @dev Returns whether `tokenId` exists.
890      *
891      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
892      *
893      * Tokens start existing when they are minted (`_mint`),
894      * and stop existing when they are burned (`_burn`).
895      */
896     function _exists(uint256 tokenId) internal view virtual returns (bool) {
897         return _owners[tokenId] != address(0);
898     }
899 
900     /**
901      * @dev Returns whether `spender` is allowed to manage `tokenId`.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      */
907     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
908         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
909         address owner = ERC721.ownerOf(tokenId);
910         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
911     }
912 
913     /**
914      * @dev Safely mints `tokenId` and transfers it to `to`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must not exist.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeMint(address to, uint256 tokenId) internal virtual {
924         _safeMint(to, tokenId, "");
925     }
926 
927     /**
928      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
929      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
930      */
931     function _safeMint(
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) internal virtual {
936         _mint(to, tokenId);
937         require(
938             _checkOnERC721Received(address(0), to, tokenId, _data),
939             "ERC721: transfer to non ERC721Receiver implementer"
940         );
941     }
942 
943     /**
944      * @dev Mints `tokenId` and transfers it to `to`.
945      *
946      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
947      *
948      * Requirements:
949      *
950      * - `tokenId` must not exist.
951      * - `to` cannot be the zero address.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _mint(address to, uint256 tokenId) internal virtual {
956         require(to != address(0), "ERC721: mint to the zero address");
957         require(!_exists(tokenId), "ERC721: token already minted");
958 
959         _beforeTokenTransfer(address(0), to, tokenId);
960 
961         _balances[to] += 1;
962         _owners[tokenId] = to;
963 
964         emit Transfer(address(0), to, tokenId);
965     }
966 
967     /**
968      * @dev Destroys `tokenId`.
969      * The approval is cleared when the token is burned.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must exist.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _burn(uint256 tokenId) internal virtual {
978         address owner = ERC721.ownerOf(tokenId);
979 
980         _beforeTokenTransfer(owner, address(0), tokenId);
981 
982         // Clear approvals
983         _approve(address(0), tokenId);
984 
985         _balances[owner] -= 1;
986         delete _owners[tokenId];
987 
988         emit Transfer(owner, address(0), tokenId);
989     }
990 
991     /**
992      * @dev Transfers `tokenId` from `from` to `to`.
993      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
994      *
995      * Requirements:
996      *
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must be owned by `from`.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _transfer(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) internal virtual {
1007         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1008         require(to != address(0), "ERC721: transfer to the zero address");
1009 
1010         _beforeTokenTransfer(from, to, tokenId);
1011 
1012         // Clear approvals from the previous owner
1013         _approve(address(0), tokenId);
1014 
1015         _balances[from] -= 1;
1016         _balances[to] += 1;
1017         _owners[tokenId] = to;
1018 
1019         emit Transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `to` to operate on `tokenId`
1024      *
1025      * Emits a {Approval} event.
1026      */
1027     function _approve(address to, uint256 tokenId) internal virtual {
1028         _tokenApprovals[tokenId] = to;
1029         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1034      * The call is not executed if the target address is not a contract.
1035      *
1036      * @param from address representing the previous owner of the given token ID
1037      * @param to target address that will receive the tokens
1038      * @param tokenId uint256 ID of the token to be transferred
1039      * @param _data bytes optional data to send along with the call
1040      * @return bool whether the call correctly returned the expected magic value
1041      */
1042     function _checkOnERC721Received(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) private returns (bool) {
1048         if (to.isContract()) {
1049             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1050                 return retval == IERC721Receiver.onERC721Received.selector;
1051             } catch (bytes memory reason) {
1052                 if (reason.length == 0) {
1053                     revert("ERC721: transfer to non ERC721Receiver implementer");
1054                 } else {
1055                     assembly {
1056                         revert(add(32, reason), mload(reason))
1057                     }
1058                 }
1059             }
1060         } else {
1061             return true;
1062         }
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before any token transfer. This includes minting
1067      * and burning.
1068      *
1069      * Calling conditions:
1070      *
1071      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1072      * transferred to `to`.
1073      * - When `from` is zero, `tokenId` will be minted for `to`.
1074      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1075      * - `from` and `to` are never both zero.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {}
1084 }
1085 
1086 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1087 pragma solidity ^0.8.0;
1088 
1089 /**
1090  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1091  * @dev See https://eips.ethereum.org/EIPS/eip-721
1092  */
1093 interface IERC721Enumerable is IERC721 {
1094     /**
1095      * @dev Returns the total amount of tokens stored by the contract.
1096      */
1097     function totalSupply() external view returns (uint256);
1098 
1099     /**
1100      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1101      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1102      */
1103     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1104 
1105     /**
1106      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1107      * Use along with {totalSupply} to enumerate all tokens.
1108      */
1109     function tokenByIndex(uint256 index) external view returns (uint256);
1110 }
1111 
1112 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1113 pragma solidity ^0.8.0;
1114 
1115 /**
1116  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1117  * enumerability of all the token ids in the contract as well as all token ids owned by each
1118  * account.
1119  */
1120 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1121     // Mapping from owner to list of owned token IDs
1122     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1123 
1124     // Mapping from token ID to index of the owner tokens list
1125     mapping(uint256 => uint256) private _ownedTokensIndex;
1126 
1127     // Array with all token ids, used for enumeration
1128     uint256[] private _allTokens;
1129 
1130     // Mapping from token id to position in the allTokens array
1131     mapping(uint256 => uint256) private _allTokensIndex;
1132 
1133     /**
1134      * @dev See {IERC165-supportsInterface}.
1135      */
1136     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1137         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1142      */
1143     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1144         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1145         return _ownedTokens[owner][index];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Enumerable-totalSupply}.
1150      */
1151     function totalSupply() public view virtual override returns (uint256) {
1152         return _allTokens.length;
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Enumerable-tokenByIndex}.
1157      */
1158     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1159         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1160         return _allTokens[index];
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before any token transfer. This includes minting
1165      * and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1170      * transferred to `to`.
1171      * - When `from` is zero, `tokenId` will be minted for `to`.
1172      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1173      * - `from` cannot be the zero address.
1174      * - `to` cannot be the zero address.
1175      *
1176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1177      */
1178     function _beforeTokenTransfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) internal virtual override {
1183         super._beforeTokenTransfer(from, to, tokenId);
1184 
1185         if (from == address(0)) {
1186             _addTokenToAllTokensEnumeration(tokenId);
1187         } else if (from != to) {
1188             _removeTokenFromOwnerEnumeration(from, tokenId);
1189         }
1190         if (to == address(0)) {
1191             _removeTokenFromAllTokensEnumeration(tokenId);
1192         } else if (to != from) {
1193             _addTokenToOwnerEnumeration(to, tokenId);
1194         }
1195     }
1196 
1197     /**
1198      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1199      * @param to address representing the new owner of the given token ID
1200      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1201      */
1202     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1203         uint256 length = ERC721.balanceOf(to);
1204         _ownedTokens[to][length] = tokenId;
1205         _ownedTokensIndex[tokenId] = length;
1206     }
1207 
1208     /**
1209      * @dev Private function to add a token to this extension's token tracking data structures.
1210      * @param tokenId uint256 ID of the token to be added to the tokens list
1211      */
1212     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1213         _allTokensIndex[tokenId] = _allTokens.length;
1214         _allTokens.push(tokenId);
1215     }
1216 
1217     /**
1218      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1219      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1220      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1221      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1222      * @param from address representing the previous owner of the given token ID
1223      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1224      */
1225     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1226         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1227         // then delete the last slot (swap and pop).
1228 
1229         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1230         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1231 
1232         // When the token to delete is the last token, the swap operation is unnecessary
1233         if (tokenIndex != lastTokenIndex) {
1234             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1235 
1236             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1237             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1238         }
1239 
1240         // This also deletes the contents at the last position of the array
1241         delete _ownedTokensIndex[tokenId];
1242         delete _ownedTokens[from][lastTokenIndex];
1243     }
1244 
1245     /**
1246      * @dev Private function to remove a token from this extension's token tracking data structures.
1247      * This has O(1) time complexity, but alters the order of the _allTokens array.
1248      * @param tokenId uint256 ID of the token to be removed from the tokens list
1249      */
1250     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1251         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1252         // then delete the last slot (swap and pop).
1253 
1254         uint256 lastTokenIndex = _allTokens.length - 1;
1255         uint256 tokenIndex = _allTokensIndex[tokenId];
1256 
1257         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1258         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1259         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1260         uint256 lastTokenId = _allTokens[lastTokenIndex];
1261 
1262         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1263         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1264 
1265         // This also deletes the contents at the last position of the array
1266         delete _allTokensIndex[tokenId];
1267         _allTokens.pop();
1268     }
1269 }
1270 
1271 
1272 contract notanaltcoin is ERC721, Ownable, ReentrancyGuard {
1273     uint256 private PRICE = 10000000000000000; // .01e
1274     uint256 private MAX_QUANTITY = 1000;
1275     uint256 private totalSupply = 0;
1276 
1277     constructor() ERC721("Not an Altcoin", "NOTANAL") {}
1278 
1279     function claim(uint256 num) public payable nonReentrant {
1280         require(
1281             num > 0 && num < 51,
1282             "Choose at least 1 and at most 50 to mint"
1283         );
1284         require(
1285             num + totalSupply < MAX_QUANTITY,
1286             "Enter a different quantity - there arent that many left to mint"
1287         );
1288         require(msg.value >= num * PRICE, "Price is .01 per mint");
1289         for (uint256 i = 0; i < num; i++) {
1290             _safeMint(_msgSender(), totalSupply);
1291             totalSupply++;
1292         }
1293     }    
1294 
1295     function withdraw() public payable nonReentrant onlyOwner {
1296         payable(msg.sender).transfer(address(this).balance);
1297     }    
1298 
1299 }