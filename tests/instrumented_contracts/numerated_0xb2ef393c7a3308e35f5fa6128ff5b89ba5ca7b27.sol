1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Address.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
78 
79 pragma solidity ^0.8.1;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      *
102      * [IMPORTANT]
103      * ====
104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
105      *
106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
108      * constructor.
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize/address.code.length, which returns 0
113         // for contracts in construction, since the code is only stored at the end
114         // of the constructor execution.
115 
116         return account.code.length > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         require(isContract(target), "Address: call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.call{value: value}(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
223         return functionStaticCall(target, data, "Address: low-level static call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal view returns (bytes memory) {
237         require(isContract(target), "Address: static call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(isContract(target), "Address: delegate call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.delegatecall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
272      * revert reason using the provided one.
273      *
274      * _Available since v4.3._
275      */
276     function verifyCallResult(
277         bool success,
278         bytes memory returndata,
279         string memory errorMessage
280     ) internal pure returns (bytes memory) {
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
300 
301 
302 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @title ERC721 token receiver interface
308  * @dev Interface for any contract that wants to support safeTransfers
309  * from ERC721 asset contracts.
310  */
311 interface IERC721Receiver {
312     /**
313      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
314      * by `operator` from `from`, this function is called.
315      *
316      * It must return its Solidity selector to confirm the token transfer.
317      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
318      *
319      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
320      */
321     function onERC721Received(
322         address operator,
323         address from,
324         uint256 tokenId,
325         bytes calldata data
326     ) external returns (bytes4);
327 }
328 
329 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Interface of the ERC165 standard, as defined in the
338  * https://eips.ethereum.org/EIPS/eip-165[EIP].
339  *
340  * Implementers can declare support of contract interfaces, which can then be
341  * queried by others ({ERC165Checker}).
342  *
343  * For an implementation, see {ERC165}.
344  */
345 interface IERC165 {
346     /**
347      * @dev Returns true if this contract implements the interface defined by
348      * `interfaceId`. See the corresponding
349      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
350      * to learn more about how these ids are created.
351      *
352      * This function call must use less than 30 000 gas.
353      */
354     function supportsInterface(bytes4 interfaceId) external view returns (bool);
355 }
356 
357 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 
365 /**
366  * @dev Implementation of the {IERC165} interface.
367  *
368  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
369  * for the additional interface id that will be supported. For example:
370  *
371  * ```solidity
372  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
373  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
374  * }
375  * ```
376  *
377  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
378  */
379 abstract contract ERC165 is IERC165 {
380     /**
381      * @dev See {IERC165-supportsInterface}.
382      */
383     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
384         return interfaceId == type(IERC165).interfaceId;
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
389 
390 
391 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Required interface of an ERC721 compliant contract.
398  */
399 interface IERC721 is IERC165 {
400     /**
401      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
407      */
408     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
412      */
413     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
414 
415     /**
416      * @dev Returns the number of tokens in ``owner``'s account.
417      */
418     function balanceOf(address owner) external view returns (uint256 balance);
419 
420     /**
421      * @dev Returns the owner of the `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function ownerOf(uint256 tokenId) external view returns (address owner);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
439      *
440      * Emits a {Transfer} event.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId,
446         bytes calldata data
447     ) external;
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
451      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Transfers `tokenId` token from `from` to `to`.
471      *
472      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must be owned by `from`.
479      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
491      * The approval is cleared when the token is transferred.
492      *
493      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
494      *
495      * Requirements:
496      *
497      * - The caller must own the token or be an approved operator.
498      * - `tokenId` must exist.
499      *
500      * Emits an {Approval} event.
501      */
502     function approve(address to, uint256 tokenId) external;
503 
504     /**
505      * @dev Approve or remove `operator` as an operator for the caller.
506      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
507      *
508      * Requirements:
509      *
510      * - The `operator` cannot be the caller.
511      *
512      * Emits an {ApprovalForAll} event.
513      */
514     function setApprovalForAll(address operator, bool _approved) external;
515 
516     /**
517      * @dev Returns the account approved for `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function getApproved(uint256 tokenId) external view returns (address operator);
524 
525     /**
526      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
527      *
528      * See {setApprovalForAll}
529      */
530     function isApprovedForAll(address owner, address operator) external view returns (bool);
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
543  * @dev See https://eips.ethereum.org/EIPS/eip-721
544  */
545 interface IERC721Metadata is IERC721 {
546     /**
547      * @dev Returns the token collection name.
548      */
549     function name() external view returns (string memory);
550 
551     /**
552      * @dev Returns the token collection symbol.
553      */
554     function symbol() external view returns (string memory);
555 
556     /**
557      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
558      */
559     function tokenURI(uint256 tokenId) external view returns (string memory);
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Enumerable is IERC721 {
575     /**
576      * @dev Returns the total amount of tokens stored by the contract.
577      */
578     function totalSupply() external view returns (uint256);
579 
580     /**
581      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
582      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
583      */
584     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
585 
586     /**
587      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
588      * Use along with {totalSupply} to enumerate all tokens.
589      */
590     function tokenByIndex(uint256 index) external view returns (uint256);
591 }
592 
593 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @dev Contract module that helps prevent reentrant calls to a function.
602  *
603  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
604  * available, which can be applied to functions to make sure there are no nested
605  * (reentrant) calls to them.
606  *
607  * Note that because there is a single `nonReentrant` guard, functions marked as
608  * `nonReentrant` may not call one another. This can be worked around by making
609  * those functions `private`, and then adding `external` `nonReentrant` entry
610  * points to them.
611  *
612  * TIP: If you would like to learn more about reentrancy and alternative ways
613  * to protect against it, check out our blog post
614  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
615  */
616 abstract contract ReentrancyGuard {
617     // Booleans are more expensive than uint256 or any type that takes up a full
618     // word because each write operation emits an extra SLOAD to first read the
619     // slot's contents, replace the bits taken up by the boolean, and then write
620     // back. This is the compiler's defense against contract upgrades and
621     // pointer aliasing, and it cannot be disabled.
622 
623     // The values being non-zero value makes deployment a bit more expensive,
624     // but in exchange the refund on every call to nonReentrant will be lower in
625     // amount. Since refunds are capped to a percentage of the total
626     // transaction's gas, it is best to keep them low in cases like this one, to
627     // increase the likelihood of the full refund coming into effect.
628     uint256 private constant _NOT_ENTERED = 1;
629     uint256 private constant _ENTERED = 2;
630 
631     uint256 private _status;
632 
633     constructor() {
634         _status = _NOT_ENTERED;
635     }
636 
637     /**
638      * @dev Prevents a contract from calling itself, directly or indirectly.
639      * Calling a `nonReentrant` function from another `nonReentrant`
640      * function is not supported. It is possible to prevent this from happening
641      * by making the `nonReentrant` function external, and making it call a
642      * `private` function that does the actual work.
643      */
644     modifier nonReentrant() {
645         // On the first call to nonReentrant, _notEntered will be true
646         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
647 
648         // Any calls to nonReentrant after this point will fail
649         _status = _ENTERED;
650 
651         _;
652 
653         // By storing the original value once again, a refund is triggered (see
654         // https://eips.ethereum.org/EIPS/eip-2200)
655         _status = _NOT_ENTERED;
656     }
657 }
658 
659 // File: @openzeppelin/contracts/utils/Context.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev Provides information about the current execution context, including the
668  * sender of the transaction and its data. While these are generally available
669  * via msg.sender and msg.data, they should not be accessed in such a direct
670  * manner, since when dealing with meta-transactions the account sending and
671  * paying for execution may not be the actual sender (as far as an application
672  * is concerned).
673  *
674  * This contract is only required for intermediate, library-like contracts.
675  */
676 abstract contract Context {
677     function _msgSender() internal view virtual returns (address) {
678         return msg.sender;
679     }
680 
681     function _msgData() internal view virtual returns (bytes calldata) {
682         return msg.data;
683     }
684 }
685 
686 // File: @openzeppelin/contracts/access/Ownable.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @dev Contract module which provides a basic access control mechanism, where
696  * there is an account (an owner) that can be granted exclusive access to
697  * specific functions.
698  *
699  * By default, the owner account will be the one that deploys the contract. This
700  * can later be changed with {transferOwnership}.
701  *
702  * This module is used through inheritance. It will make available the modifier
703  * `onlyOwner`, which can be applied to your functions to restrict their use to
704  * the owner.
705  */
706 abstract contract Ownable is Context {
707     address private _owner;
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
729         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
764 // File:
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
1262 contract DontMintThisShit  is ERC721A, Ownable, ReentrancyGuard {
1263     string public baseURI           = "ipfs://QmeG99tQpUxrHTHtdq3XJgAuszQdWfcvy7gFgdcKVzbjyA/";
1264     uint   public price             = 0.0069 ether;
1265     uint   public maxPerTx          = 10;
1266     uint   public maxPerFree        = 1;
1267     uint   public totalFree         = 6969;
1268     uint   public maxSupply         = 6969;
1269     bool   public mintEnabled       = false;
1270 
1271     mapping(address => uint256) private _mintedFreeAmount;
1272 
1273     constructor() ERC721A("DontMintThisShit", "DMTS"){}
1274 
1275 
1276     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1277         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1278         string memory currentBaseURI = _baseURI();
1279         return bytes(currentBaseURI).length > 0
1280             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1281             : "";
1282     }
1283 
1284     function mint(uint256 count) external payable {
1285         uint256 cost = price;
1286         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1287             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1288 
1289         if (isFree) {
1290             cost = 0;
1291             _mintedFreeAmount[msg.sender] += count;
1292         }
1293 
1294         require(msg.value >= count * cost, "Please send the exact amount.");
1295         require(totalSupply() + count <= maxSupply, "No more");
1296         require(mintEnabled, "Minting is not live yet..");
1297         require(count <= maxPerTx, "Max per TX reached.");
1298 
1299         _safeMint(msg.sender, count);
1300     }
1301 
1302     function toggleMinting() external onlyOwner {
1303       mintEnabled = !mintEnabled;
1304     }
1305 
1306     function _baseURI() internal view virtual override returns (string memory) {
1307         return baseURI;
1308     }
1309 
1310     function setBaseUri(string memory baseuri_) public onlyOwner {
1311         baseURI = baseuri_;
1312     }
1313 
1314     function setPrice(uint256 price_) external onlyOwner {
1315         price = price_;
1316     }
1317 
1318     function withdraw() external onlyOwner nonReentrant {
1319         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1320         require(success, "Transfer failed.");
1321     }
1322 
1323 
1324 }