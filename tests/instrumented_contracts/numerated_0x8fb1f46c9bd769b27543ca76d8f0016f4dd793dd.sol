1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Transfers `tokenId` token from `from` to `to`.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
491      *
492      * Requirements:
493      *
494      * - The caller must own the token or be an approved operator.
495      * - `tokenId` must exist.
496      *
497      * Emits an {Approval} event.
498      */
499     function approve(address to, uint256 tokenId) external;
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
524      *
525      * See {setApprovalForAll}
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Enumerable is IERC721 {
572     /**
573      * @dev Returns the total amount of tokens stored by the contract.
574      */
575     function totalSupply() external view returns (uint256);
576 
577     /**
578      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
579      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
580      */
581     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
582 
583     /**
584      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
585      * Use along with {totalSupply} to enumerate all tokens.
586      */
587     function tokenByIndex(uint256 index) external view returns (uint256);
588 }
589 
590 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Contract module that helps prevent reentrant calls to a function.
599  *
600  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
601  * available, which can be applied to functions to make sure there are no nested
602  * (reentrant) calls to them.
603  *
604  * Note that because there is a single `nonReentrant` guard, functions marked as
605  * `nonReentrant` may not call one another. This can be worked around by making
606  * those functions `private`, and then adding `external` `nonReentrant` entry
607  * points to them.
608  *
609  * TIP: If you would like to learn more about reentrancy and alternative ways
610  * to protect against it, check out our blog post
611  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
612  */
613 abstract contract ReentrancyGuard {
614     // Booleans are more expensive than uint256 or any type that takes up a full
615     // word because each write operation emits an extra SLOAD to first read the
616     // slot's contents, replace the bits taken up by the boolean, and then write
617     // back. This is the compiler's defense against contract upgrades and
618     // pointer aliasing, and it cannot be disabled.
619 
620     // The values being non-zero value makes deployment a bit more expensive,
621     // but in exchange the refund on every call to nonReentrant will be lower in
622     // amount. Since refunds are capped to a percentage of the total
623     // transaction's gas, it is best to keep them low in cases like this one, to
624     // increase the likelihood of the full refund coming into effect.
625     uint256 private constant _NOT_ENTERED = 1;
626     uint256 private constant _ENTERED = 2;
627 
628     uint256 private _status;
629 
630     constructor() {
631         _status = _NOT_ENTERED;
632     }
633 
634     /**
635      * @dev Prevents a contract from calling itself, directly or indirectly.
636      * Calling a `nonReentrant` function from another `nonReentrant`
637      * function is not supported. It is possible to prevent this from happening
638      * by making the `nonReentrant` function external, and making it call a
639      * `private` function that does the actual work.
640      */
641     modifier nonReentrant() {
642         // On the first call to nonReentrant, _notEntered will be true
643         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
644 
645         // Any calls to nonReentrant after this point will fail
646         _status = _ENTERED;
647 
648         _;
649 
650         // By storing the original value once again, a refund is triggered (see
651         // https://eips.ethereum.org/EIPS/eip-2200)
652         _status = _NOT_ENTERED;
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/Context.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Provides information about the current execution context, including the
665  * sender of the transaction and its data. While these are generally available
666  * via msg.sender and msg.data, they should not be accessed in such a direct
667  * manner, since when dealing with meta-transactions the account sending and
668  * paying for execution may not be the actual sender (as far as an application
669  * is concerned).
670  *
671  * This contract is only required for intermediate, library-like contracts.
672  */
673 abstract contract Context {
674     function _msgSender() internal view virtual returns (address) {
675         return msg.sender;
676     }
677 
678     function _msgData() internal view virtual returns (bytes calldata) {
679         return msg.data;
680     }
681 }
682 
683 // File: @openzeppelin/contracts/access/Ownable.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @dev Contract module which provides a basic access control mechanism, where
693  * there is an account (an owner) that can be granted exclusive access to
694  * specific functions.
695  *
696  * By default, the owner account will be the one that deploys the contract. This
697  * can later be changed with {transferOwnership}.
698  *
699  * This module is used through inheritance. It will make available the modifier
700  * `onlyOwner`, which can be applied to your functions to restrict their use to
701  * the owner.
702  */
703 abstract contract Ownable is Context {
704     address private _owner;
705 
706     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
707 
708     /**
709      * @dev Initializes the contract setting the deployer as the initial owner.
710      */
711     constructor() {
712         _transferOwnership(_msgSender());
713     }
714 
715     /**
716      * @dev Returns the address of the current owner.
717      */
718     function owner() public view virtual returns (address) {
719         return _owner;
720     }
721 
722     /**
723      * @dev Throws if called by any account other than the owner.
724      */
725     modifier onlyOwner() {
726         require(owner() == _msgSender(), "Ownable: caller is not the owner");
727         _;
728     }
729 
730     /**
731      * @dev Leaves the contract without owner. It will not be possible to call
732      * `onlyOwner` functions anymore. Can only be called by the current owner.
733      *
734      * NOTE: Renouncing ownership will leave the contract without an owner,
735      * thereby removing any functionality that is only available to the owner.
736      */
737     function renounceOwnership() public virtual onlyOwner {
738         _transferOwnership(address(0));
739     }
740 
741     /**
742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
743      * Can only be called by the current owner.
744      */
745     function transferOwnership(address newOwner) public virtual onlyOwner {
746         require(newOwner != address(0), "Ownable: new owner is the zero address");
747         _transferOwnership(newOwner);
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      * Internal function without access restriction.
753      */
754     function _transferOwnership(address newOwner) internal virtual {
755         address oldOwner = _owner;
756         _owner = newOwner;
757         emit OwnershipTransferred(oldOwner, newOwner);
758     }
759 }
760 
761 // File: CESHI1.sol
762 
763 
764 pragma solidity ^0.8.0;
765 
766 
767 
768 
769 
770 
771 
772 
773 
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
778  *
779  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
780  *
781  * Does not support burning tokens to address(0).
782  *
783  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
784  */
785 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
786     using Address for address;
787     using Strings for uint256;
788 
789     struct TokenOwnership {
790         address addr;
791         uint64 startTimestamp;
792     }
793 
794     struct AddressData {
795         uint128 balance;
796         uint128 numberMinted;
797     }
798 
799     uint256 internal currentIndex;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to ownership details
808     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
809     mapping(uint256 => TokenOwnership) internal _ownerships;
810 
811     // Mapping owner address to address data
812     mapping(address => AddressData) private _addressData;
813 
814     // Mapping from token ID to approved address
815     mapping(uint256 => address) private _tokenApprovals;
816 
817     // Mapping from owner to operator approvals
818     mapping(address => mapping(address => bool)) private _operatorApprovals;
819 
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823     }
824 
825     /**
826      * @dev See {IERC721Enumerable-totalSupply}.
827      */
828     function totalSupply() public view override returns (uint256) {
829         return currentIndex;
830     }
831 
832     /**
833      * @dev See {IERC721Enumerable-tokenByIndex}.
834      */
835     function tokenByIndex(uint256 index) public view override returns (uint256) {
836         require(index < totalSupply(), "ERC721A: global index out of bounds");
837         return index;
838     }
839 
840     /**
841      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
842      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
843      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
844      */
845     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
846         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
847         uint256 numMintedSoFar = totalSupply();
848         uint256 tokenIdsIdx;
849         address currOwnershipAddr;
850 
851         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
852         unchecked {
853             for (uint256 i; i < numMintedSoFar; i++) {
854                 TokenOwnership memory ownership = _ownerships[i];
855                 if (ownership.addr != address(0)) {
856                     currOwnershipAddr = ownership.addr;
857                 }
858                 if (currOwnershipAddr == owner) {
859                     if (tokenIdsIdx == index) {
860                         return i;
861                     }
862                     tokenIdsIdx++;
863                 }
864             }
865         }
866 
867         revert("ERC721A: unable to get token of owner by index");
868     }
869 
870     /**
871      * @dev See {IERC165-supportsInterface}.
872      */
873     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
874         return
875             interfaceId == type(IERC721).interfaceId ||
876             interfaceId == type(IERC721Metadata).interfaceId ||
877             interfaceId == type(IERC721Enumerable).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view override returns (uint256) {
885         require(owner != address(0), "ERC721A: balance query for the zero address");
886         return uint256(_addressData[owner].balance);
887     }
888 
889     function _numberMinted(address owner) internal view returns (uint256) {
890         require(owner != address(0), "ERC721A: number minted query for the zero address");
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Gas spent here starts off proportional to the maximum mint batch size.
896      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
897      */
898     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
899         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
900 
901         unchecked {
902             for (uint256 curr = tokenId; curr >= 0; curr--) {
903                 TokenOwnership memory ownership = _ownerships[curr];
904                 if (ownership.addr != address(0)) {
905                     return ownership;
906                 }
907             }
908         }
909 
910         revert("ERC721A: unable to determine the owner of token");
911     }
912 
913     /**
914      * @dev See {IERC721-ownerOf}.
915      */
916     function ownerOf(uint256 tokenId) public view override returns (address) {
917         return ownershipOf(tokenId).addr;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-name}.
922      */
923     function name() public view virtual override returns (string memory) {
924         return _name;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-symbol}.
929      */
930     function symbol() public view virtual override returns (string memory) {
931         return _symbol;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-tokenURI}.
936      */
937     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
938         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
939 
940         string memory baseURI = _baseURI();
941         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
942     }
943 
944     /**
945      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
946      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
947      * by default, can be overriden in child contracts.
948      */
949     function _baseURI() internal view virtual returns (string memory) {
950         return "";
951     }
952 
953     /**
954      * @dev See {IERC721-approve}.
955      */
956     function approve(address to, uint256 tokenId) public override {
957         address owner = ERC721A.ownerOf(tokenId);
958         require(to != owner, "ERC721A: approval to current owner");
959 
960         require(
961             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
962             "ERC721A: approve caller is not owner nor approved for all"
963         );
964 
965         _approve(to, tokenId, owner);
966     }
967 
968     /**
969      * @dev See {IERC721-getApproved}.
970      */
971     function getApproved(uint256 tokenId) public view override returns (address) {
972         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
973 
974         return _tokenApprovals[tokenId];
975     }
976 
977     /**
978      * @dev See {IERC721-setApprovalForAll}.
979      */
980     function setApprovalForAll(address operator, bool approved) public override {
981         require(operator != _msgSender(), "ERC721A: approve to caller");
982 
983         _operatorApprovals[_msgSender()][operator] = approved;
984         emit ApprovalForAll(_msgSender(), operator, approved);
985     }
986 
987     /**
988      * @dev See {IERC721-isApprovedForAll}.
989      */
990     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
991         return _operatorApprovals[owner][operator];
992     }
993 
994     /**
995      * @dev See {IERC721-transferFrom}.
996      */
997     function transferFrom(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public override {
1025         _transfer(from, to, tokenId);
1026         require(
1027             _checkOnERC721Received(from, to, tokenId, _data),
1028             "ERC721A: transfer to non ERC721Receiver implementer"
1029         );
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return tokenId < currentIndex;
1041     }
1042 
1043     function _safeMint(address to, uint256 quantity) internal {
1044         _safeMint(to, quantity, "");
1045     }
1046 
1047     /**
1048      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _safeMint(
1058         address to,
1059         uint256 quantity,
1060         bytes memory _data
1061     ) internal {
1062         _mint(to, quantity, _data, true);
1063     }
1064 
1065     /**
1066      * @dev Mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _mint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data,
1079         bool safe
1080     ) internal {
1081         uint256 startTokenId = currentIndex;
1082         require(to != address(0), "ERC721A: mint to the zero address");
1083         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1084 
1085         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1086 
1087         // Overflows are incredibly unrealistic.
1088         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1089         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1090         unchecked {
1091             _addressData[to].balance += uint128(quantity);
1092             _addressData[to].numberMinted += uint128(quantity);
1093 
1094             _ownerships[startTokenId].addr = to;
1095             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1096 
1097             uint256 updatedIndex = startTokenId;
1098 
1099             for (uint256 i; i < quantity; i++) {
1100                 emit Transfer(address(0), to, updatedIndex);
1101                 if (safe) {
1102                     require(
1103                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1104                         "ERC721A: transfer to non ERC721Receiver implementer"
1105                     );
1106                 }
1107 
1108                 updatedIndex++;
1109             }
1110 
1111             currentIndex = updatedIndex;
1112         }
1113 
1114         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1115     }
1116 
1117     /**
1118      * @dev Transfers `tokenId` from `from` to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must be owned by `from`.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _transfer(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) private {
1132         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1133 
1134         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1135             getApproved(tokenId) == _msgSender() ||
1136             isApprovedForAll(prevOwnership.addr, _msgSender()));
1137 
1138         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1139 
1140         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1141         require(to != address(0), "ERC721A: transfer to the zero address");
1142 
1143         _beforeTokenTransfers(from, to, tokenId, 1);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId, prevOwnership.addr);
1147 
1148         // Underflow of the sender's balance is impossible because we check for
1149         // ownership above and the recipient's balance can't realistically overflow.
1150         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1151         unchecked {
1152             _addressData[from].balance -= 1;
1153             _addressData[to].balance += 1;
1154 
1155             _ownerships[tokenId].addr = to;
1156             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1157 
1158             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1159             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1160             uint256 nextTokenId = tokenId + 1;
1161             if (_ownerships[nextTokenId].addr == address(0)) {
1162                 if (_exists(nextTokenId)) {
1163                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1164                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1165                 }
1166             }
1167         }
1168 
1169         emit Transfer(from, to, tokenId);
1170         _afterTokenTransfers(from, to, tokenId, 1);
1171     }
1172 
1173     /**
1174      * @dev Approve `to` to operate on `tokenId`
1175      *
1176      * Emits a {Approval} event.
1177      */
1178     function _approve(
1179         address to,
1180         uint256 tokenId,
1181         address owner
1182     ) private {
1183         _tokenApprovals[tokenId] = to;
1184         emit Approval(owner, to, tokenId);
1185     }
1186 
1187     /**
1188      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1189      * The call is not executed if the target address is not a contract.
1190      *
1191      * @param from address representing the previous owner of the given token ID
1192      * @param to target address that will receive the tokens
1193      * @param tokenId uint256 ID of the token to be transferred
1194      * @param _data bytes optional data to send along with the call
1195      * @return bool whether the call correctly returned the expected magic value
1196      */
1197     function _checkOnERC721Received(
1198         address from,
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) private returns (bool) {
1203         if (to.isContract()) {
1204             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1205                 return retval == IERC721Receiver(to).onERC721Received.selector;
1206             } catch (bytes memory reason) {
1207                 if (reason.length == 0) {
1208                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1209                 } else {
1210                     assembly {
1211                         revert(add(32, reason), mload(reason))
1212                     }
1213                 }
1214             }
1215         } else {
1216             return true;
1217         }
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1222      *
1223      * startTokenId - the first token id to be transferred
1224      * quantity - the amount to be transferred
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      */
1232     function _beforeTokenTransfers(
1233         address from,
1234         address to,
1235         uint256 startTokenId,
1236         uint256 quantity
1237     ) internal virtual {}
1238 
1239     /**
1240      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1241      * minting.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - when `from` and `to` are both non-zero.
1249      * - `from` and `to` are never both zero.
1250      */
1251     function _afterTokenTransfers(
1252         address from,
1253         address to,
1254         uint256 startTokenId,
1255         uint256 quantity
1256     ) internal virtual {}
1257 }
1258 
1259 contract GreatGoat is ERC721A, Ownable, ReentrancyGuard {
1260     string public baseURI = "ipfs://QmTyAvxLLjer8NZu6fKD71jU4wp5cVTERcfoTNueu98cnN/";
1261     uint   public price             = 0.004 ether;
1262     uint   public maxPerTx          = 10;
1263     uint   public maxPerFree        = 1;
1264     uint   public totalFree         = 4444;
1265     uint   public maxSupply         = 4444;
1266 
1267     mapping(address => uint256) private _mintedFreeAmount;
1268 
1269     constructor() ERC721A("Uncle Ghost", "UG"){}
1270 
1271     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1272         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1273         string memory currentBaseURI = _baseURI();
1274         return bytes(currentBaseURI).length > 0
1275             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1276             : "";
1277     }
1278 
1279     function mint(uint256 count) external payable {
1280         uint256 cost = price;
1281         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1282             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1283 
1284         if (isFree) {
1285             cost = 0;
1286             _mintedFreeAmount[msg.sender] += count;
1287         }
1288 
1289         require(msg.value >= count * cost, "Please send the exact amount.");
1290         require(totalSupply() + count <= maxSupply, "No more");
1291         require(count <= maxPerTx, "Max per TX reached.");
1292 
1293         _safeMint(msg.sender, count);
1294     }
1295 
1296     function _baseURI() internal view virtual override returns (string memory) {
1297         return baseURI;
1298     }
1299 
1300     function setBaseUri(string memory baseuri_) public onlyOwner {
1301         baseURI = baseuri_;
1302     }
1303 
1304     function setPrice(uint256 price_) external onlyOwner {
1305         price = price_;
1306     }
1307 
1308     function withdraw() external onlyOwner nonReentrant {
1309         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1310         require(success, "Transfer failed.");
1311     }
1312 }