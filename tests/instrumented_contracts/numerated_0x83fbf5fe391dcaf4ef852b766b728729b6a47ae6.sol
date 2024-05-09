1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @title ERC721 token receiver interface
79  * @dev Interface for any contract that wants to support safeTransfers
80  * from ERC721 asset contracts.
81  */
82 interface IERC721Receiver {
83     /**
84      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
85      * by `operator` from `from`, this function is called.
86      *
87      * It must return its Solidity selector to confirm the token transfer.
88      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
89      *
90      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
91      */
92     function onERC721Received(
93         address operator,
94         address from,
95         uint256 tokenId,
96         bytes calldata data
97     ) external returns (bytes4);
98 }
99 
100 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 
136 /**
137  * @dev Implementation of the {IERC165} interface.
138  *
139  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
140  * for the additional interface id that will be supported. For example:
141  *
142  * ```solidity
143  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
144  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
145  * }
146  * ```
147  *
148  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
149  */
150 abstract contract ERC165 is IERC165 {
151     /**
152      * @dev See {IERC165-supportsInterface}.
153      */
154     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
155         return interfaceId == type(IERC165).interfaceId;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 
167 /**
168  * @dev Required interface of an ERC721 compliant contract.
169  */
170 interface IERC721 is IERC165 {
171     /**
172      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
173      */
174     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
175 
176     /**
177      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
178      */
179     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
180 
181     /**
182      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
183      */
184     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
185 
186     /**
187      * @dev Returns the number of tokens in ``owner``'s account.
188      */
189     function balanceOf(address owner) external view returns (uint256 balance);
190 
191     /**
192      * @dev Returns the owner of the `tokenId` token.
193      *
194      * Requirements:
195      *
196      * - `tokenId` must exist.
197      */
198     function ownerOf(uint256 tokenId) external view returns (address owner);
199 
200     /**
201      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
202      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must exist and be owned by `from`.
209      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211      *
212      * Emits a {Transfer} event.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Transfers `tokenId` token from `from` to `to`.
222      *
223      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
224      *
225      * Requirements:
226      *
227      * - `from` cannot be the zero address.
228      * - `to` cannot be the zero address.
229      * - `tokenId` token must be owned by `from`.
230      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transferFrom(
235         address from,
236         address to,
237         uint256 tokenId
238     ) external;
239 
240     /**
241      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
242      * The approval is cleared when the token is transferred.
243      *
244      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
245      *
246      * Requirements:
247      *
248      * - The caller must own the token or be an approved operator.
249      * - `tokenId` must exist.
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address to, uint256 tokenId) external;
254 
255     /**
256      * @dev Returns the account approved for `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function getApproved(uint256 tokenId) external view returns (address operator);
263 
264     /**
265      * @dev Approve or remove `operator` as an operator for the caller.
266      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
267      *
268      * Requirements:
269      *
270      * - The `operator` cannot be the caller.
271      *
272      * Emits an {ApprovalForAll} event.
273      */
274     function setApprovalForAll(address operator, bool _approved) external;
275 
276     /**
277      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
278      *
279      * See {setApprovalForAll}
280      */
281     function isApprovedForAll(address owner, address operator) external view returns (bool);
282 
283     /**
284      * @dev Safely transfers `tokenId` token from `from` to `to`.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must exist and be owned by `from`.
291      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
293      *
294      * Emits a {Transfer} event.
295      */
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId,
300         bytes calldata data
301     ) external;
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 
312 /**
313  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
314  * @dev See https://eips.ethereum.org/EIPS/eip-721
315  */
316 interface IERC721Enumerable is IERC721 {
317     /**
318      * @dev Returns the total amount of tokens stored by the contract.
319      */
320     function totalSupply() external view returns (uint256);
321 
322     /**
323      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
324      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
325      */
326     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
327 
328     /**
329      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
330      * Use along with {totalSupply} to enumerate all tokens.
331      */
332     function tokenByIndex(uint256 index) external view returns (uint256);
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 
343 /**
344  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
345  * @dev See https://eips.ethereum.org/EIPS/eip-721
346  */
347 interface IERC721Metadata is IERC721 {
348     /**
349      * @dev Returns the token collection name.
350      */
351     function name() external view returns (string memory);
352 
353     /**
354      * @dev Returns the token collection symbol.
355      */
356     function symbol() external view returns (string memory);
357 
358     /**
359      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
360      */
361     function tokenURI(uint256 tokenId) external view returns (string memory);
362 }
363 
364 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Contract module that helps prevent reentrant calls to a function.
373  *
374  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
375  * available, which can be applied to functions to make sure there are no nested
376  * (reentrant) calls to them.
377  *
378  * Note that because there is a single `nonReentrant` guard, functions marked as
379  * `nonReentrant` may not call one another. This can be worked around by making
380  * those functions `private`, and then adding `external` `nonReentrant` entry
381  * points to them.
382  *
383  * TIP: If you would like to learn more about reentrancy and alternative ways
384  * to protect against it, check out our blog post
385  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
386  */
387 abstract contract ReentrancyGuard {
388     // Booleans are more expensive than uint256 or any type that takes up a full
389     // word because each write operation emits an extra SLOAD to first read the
390     // slot's contents, replace the bits taken up by the boolean, and then write
391     // back. This is the compiler's defense against contract upgrades and
392     // pointer aliasing, and it cannot be disabled.
393 
394     // The values being non-zero value makes deployment a bit more expensive,
395     // but in exchange the refund on every call to nonReentrant will be lower in
396     // amount. Since refunds are capped to a percentage of the total
397     // transaction's gas, it is best to keep them low in cases like this one, to
398     // increase the likelihood of the full refund coming into effect.
399     uint256 private constant _NOT_ENTERED = 1;
400     uint256 private constant _ENTERED = 2;
401 
402     uint256 private _status;
403 
404     constructor() {
405         _status = _NOT_ENTERED;
406     }
407 
408     /**
409      * @dev Prevents a contract from calling itself, directly or indirectly.
410      * Calling a `nonReentrant` function from another `nonReentrant`
411      * function is not supported. It is possible to prevent this from happening
412      * by making the `nonReentrant` function external, and making it call a
413      * `private` function that does the actual work.
414      */
415     modifier nonReentrant() {
416         // On the first call to nonReentrant, _notEntered will be true
417         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
418 
419         // Any calls to nonReentrant after this point will fail
420         _status = _ENTERED;
421 
422         _;
423 
424         // By storing the original value once again, a refund is triggered (see
425         // https://eips.ethereum.org/EIPS/eip-2200)
426         _status = _NOT_ENTERED;
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Context.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 abstract contract Context {
448     function _msgSender() internal view virtual returns (address) {
449         return msg.sender;
450     }
451 
452     function _msgData() internal view virtual returns (bytes calldata) {
453         return msg.data;
454     }
455 }
456 
457 // File: @openzeppelin/contracts/access/Ownable.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 abstract contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor() {
486         _transferOwnership(_msgSender());
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view virtual returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(owner() == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         _transferOwnership(address(0));
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         _transferOwnership(newOwner);
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Internal function without access restriction.
527      */
528     function _transferOwnership(address newOwner) internal virtual {
529         address oldOwner = _owner;
530         _owner = newOwner;
531         emit OwnershipTransferred(oldOwner, newOwner);
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Address.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
539 
540 pragma solidity ^0.8.1;
541 
542 /**
543  * @dev Collection of functions related to the address type
544  */
545 library Address {
546     /**
547      * @dev Returns true if `account` is a contract.
548      *
549      * [IMPORTANT]
550      * ====
551      * It is unsafe to assume that an address for which this function returns
552      * false is an externally-owned account (EOA) and not a contract.
553      *
554      * Among others, `isContract` will return false for the following
555      * types of addresses:
556      *
557      *  - an externally-owned account
558      *  - a contract in construction
559      *  - an address where a contract will be created
560      *  - an address where a contract lived, but was destroyed
561      * ====
562      *
563      * [IMPORTANT]
564      * ====
565      * You shouldn't rely on `isContract` to protect against flash loan attacks!
566      *
567      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
568      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
569      * constructor.
570      * ====
571      */
572     function isContract(address account) internal view returns (bool) {
573         // This method relies on extcodesize/address.code.length, which returns 0
574         // for contracts in construction, since the code is only stored at the end
575         // of the constructor execution.
576 
577         return account.code.length > 0;
578     }
579 
580     /**
581      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
582      * `recipient`, forwarding all available gas and reverting on errors.
583      *
584      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
585      * of certain opcodes, possibly making contracts go over the 2300 gas limit
586      * imposed by `transfer`, making them unable to receive funds via
587      * `transfer`. {sendValue} removes this limitation.
588      *
589      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
590      *
591      * IMPORTANT: because control is transferred to `recipient`, care must be
592      * taken to not create reentrancy vulnerabilities. Consider using
593      * {ReentrancyGuard} or the
594      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
595      */
596     function sendValue(address payable recipient, uint256 amount) internal {
597         require(address(this).balance >= amount, "Address: insufficient balance");
598 
599         (bool success, ) = recipient.call{value: amount}("");
600         require(success, "Address: unable to send value, recipient may have reverted");
601     }
602 
603     /**
604      * @dev Performs a Solidity function call using a low level `call`. A
605      * plain `call` is an unsafe replacement for a function call: use this
606      * function instead.
607      *
608      * If `target` reverts with a revert reason, it is bubbled up by this
609      * function (like regular Solidity function calls).
610      *
611      * Returns the raw returned data. To convert to the expected return value,
612      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
613      *
614      * Requirements:
615      *
616      * - `target` must be a contract.
617      * - calling `target` with `data` must not revert.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionCall(target, data, "Address: low-level call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
627      * `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         return functionCallWithValue(target, data, 0, errorMessage);
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
641      * but also transferring `value` wei to `target`.
642      *
643      * Requirements:
644      *
645      * - the calling contract must have an ETH balance of at least `value`.
646      * - the called Solidity function must be `payable`.
647      *
648      * _Available since v3.1._
649      */
650     function functionCallWithValue(
651         address target,
652         bytes memory data,
653         uint256 value
654     ) internal returns (bytes memory) {
655         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
660      * with `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCallWithValue(
665         address target,
666         bytes memory data,
667         uint256 value,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         require(address(this).balance >= value, "Address: insufficient balance for call");
671         require(isContract(target), "Address: call to non-contract");
672 
673         (bool success, bytes memory returndata) = target.call{value: value}(data);
674         return verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
679      * but performing a static call.
680      *
681      * _Available since v3.3._
682      */
683     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
684         return functionStaticCall(target, data, "Address: low-level static call failed");
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
689      * but performing a static call.
690      *
691      * _Available since v3.3._
692      */
693     function functionStaticCall(
694         address target,
695         bytes memory data,
696         string memory errorMessage
697     ) internal view returns (bytes memory) {
698         require(isContract(target), "Address: static call to non-contract");
699 
700         (bool success, bytes memory returndata) = target.staticcall(data);
701         return verifyCallResult(success, returndata, errorMessage);
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
706      * but performing a delegate call.
707      *
708      * _Available since v3.4._
709      */
710     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
711         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
716      * but performing a delegate call.
717      *
718      * _Available since v3.4._
719      */
720     function functionDelegateCall(
721         address target,
722         bytes memory data,
723         string memory errorMessage
724     ) internal returns (bytes memory) {
725         require(isContract(target), "Address: delegate call to non-contract");
726 
727         (bool success, bytes memory returndata) = target.delegatecall(data);
728         return verifyCallResult(success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
733      * revert reason using the provided one.
734      *
735      * _Available since v4.3._
736      */
737     function verifyCallResult(
738         bool success,
739         bytes memory returndata,
740         string memory errorMessage
741     ) internal pure returns (bytes memory) {
742         if (success) {
743             return returndata;
744         } else {
745             // Look for revert reason and bubble it up if present
746             if (returndata.length > 0) {
747                 // The easiest way to bubble the revert reason is using memory via assembly
748 
749                 assembly {
750                     let returndata_size := mload(returndata)
751                     revert(add(32, returndata), returndata_size)
752                 }
753             } else {
754                 revert(errorMessage);
755             }
756         }
757     }
758 }
759 
760 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
761 
762 
763 // Creator: Chiru Labs
764 
765 pragma solidity ^0.8.4;
766 
767 
768 
769 
770 
771 
772 
773 
774 
775 error ApprovalCallerNotOwnerNorApproved();
776 error ApprovalQueryForNonexistentToken();
777 error ApproveToCaller();
778 error ApprovalToCurrentOwner();
779 error BalanceQueryForZeroAddress();
780 error MintedQueryForZeroAddress();
781 error BurnedQueryForZeroAddress();
782 error AuxQueryForZeroAddress();
783 error MintToZeroAddress();
784 error MintZeroQuantity();
785 error OwnerIndexOutOfBounds();
786 error OwnerQueryForNonexistentToken();
787 error TokenIndexOutOfBounds();
788 error TransferCallerNotOwnerNorApproved();
789 error TransferFromIncorrectOwner();
790 error TransferToNonERC721ReceiverImplementer();
791 error TransferToZeroAddress();
792 error URIQueryForNonexistentToken();
793 
794 /**
795  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
796  * the Metadata extension. Built to optimize for lower gas during batch mints.
797  *
798  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
799  *
800  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
801  *
802  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
803  */
804 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
805     using Address for address;
806     using Strings for uint256;
807 
808     // Compiler will pack this into a single 256bit word.
809     struct TokenOwnership {
810         // The address of the owner.
811         address addr;
812         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
813         uint64 startTimestamp;
814         // Whether the token has been burned.
815         bool burned;
816     }
817 
818     // Compiler will pack this into a single 256bit word.
819     struct AddressData {
820         // Realistically, 2**64-1 is more than enough.
821         uint64 balance;
822         // Keeps track of mint count with minimal overhead for tokenomics.
823         uint64 numberMinted;
824         // Keeps track of burn count with minimal overhead for tokenomics.
825         uint64 numberBurned;
826         // For miscellaneous variable(s) pertaining to the address
827         // (e.g. number of whitelist mint slots used).
828         // If there are multiple variables, please pack them into a uint64.
829         uint64 aux;
830     }
831 
832     // The tokenId of the next token to be minted.
833     uint256 internal _currentIndex;
834 
835     // The number of tokens burned.
836     uint256 internal _burnCounter;
837 
838     // Token name
839     string private _name;
840 
841     // Token symbol
842     string private _symbol;
843 
844     // Mapping from token ID to ownership details
845     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
846     mapping(uint256 => TokenOwnership) internal _ownerships;
847 
848     // Mapping owner address to address data
849     mapping(address => AddressData) private _addressData;
850 
851     // Mapping from token ID to approved address
852     mapping(uint256 => address) private _tokenApprovals;
853 
854     // Mapping from owner to operator approvals
855     mapping(address => mapping(address => bool)) private _operatorApprovals;
856 
857     constructor(string memory name_, string memory symbol_) {
858         _name = name_;
859         _symbol = symbol_;
860         _currentIndex = _startTokenId();
861     }
862 
863     /**
864      * To change the starting tokenId, please override this function.
865      */
866     function _startTokenId() internal view virtual returns (uint256) {
867         return 0;
868     }
869 
870     /**
871      * @dev See {IERC721Enumerable-totalSupply}.
872      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
873      */
874     function totalSupply() public view returns (uint256) {
875         // Counter underflow is impossible as _burnCounter cannot be incremented
876         // more than _currentIndex - _startTokenId() times
877         unchecked {
878             return _currentIndex - _burnCounter - _startTokenId();
879         }
880     }
881 
882     /**
883      * Returns the total amount of tokens minted in the contract.
884      */
885     function _totalMinted() internal view returns (uint256) {
886         // Counter underflow is impossible as _currentIndex does not decrement,
887         // and it is initialized to _startTokenId()
888         unchecked {
889             return _currentIndex - _startTokenId();
890         }
891     }
892 
893     /**
894      * @dev See {IERC165-supportsInterface}.
895      */
896     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
897         return
898             interfaceId == type(IERC721).interfaceId ||
899             interfaceId == type(IERC721Metadata).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         if (owner == address(0)) revert BalanceQueryForZeroAddress();
908         return uint256(_addressData[owner].balance);
909     }
910 
911     /**
912      * Returns the number of tokens minted by `owner`.
913      */
914     function _numberMinted(address owner) internal view returns (uint256) {
915         if (owner == address(0)) revert MintedQueryForZeroAddress();
916         return uint256(_addressData[owner].numberMinted);
917     }
918 
919     /**
920      * Returns the number of tokens burned by or on behalf of `owner`.
921      */
922     function _numberBurned(address owner) internal view returns (uint256) {
923         if (owner == address(0)) revert BurnedQueryForZeroAddress();
924         return uint256(_addressData[owner].numberBurned);
925     }
926 
927     /**
928      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
929      */
930     function _getAux(address owner) internal view returns (uint64) {
931         if (owner == address(0)) revert AuxQueryForZeroAddress();
932         return _addressData[owner].aux;
933     }
934 
935     /**
936      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
937      * If there are multiple variables, please pack them into a uint64.
938      */
939     function _setAux(address owner, uint64 aux) internal {
940         if (owner == address(0)) revert AuxQueryForZeroAddress();
941         _addressData[owner].aux = aux;
942     }
943 
944     /**
945      * Gas spent here starts off proportional to the maximum mint batch size.
946      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
947      */
948     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
949         uint256 curr = tokenId;
950 
951         unchecked {
952             if (_startTokenId() <= curr && curr < _currentIndex) {
953                 TokenOwnership memory ownership = _ownerships[curr];
954                 if (!ownership.burned) {
955                     if (ownership.addr != address(0)) {
956                         return ownership;
957                     }
958                     // Invariant:
959                     // There will always be an ownership that has an address and is not burned
960                     // before an ownership that does not have an address and is not burned.
961                     // Hence, curr will not underflow.
962                     while (true) {
963                         curr--;
964                         ownership = _ownerships[curr];
965                         if (ownership.addr != address(0)) {
966                             return ownership;
967                         }
968                     }
969                 }
970             }
971         }
972         revert OwnerQueryForNonexistentToken();
973     }
974 
975     /**
976      * @dev See {IERC721-ownerOf}.
977      */
978     function ownerOf(uint256 tokenId) public view override returns (address) {
979         return ownershipOf(tokenId).addr;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-name}.
984      */
985     function name() public view virtual override returns (string memory) {
986         return _name;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-symbol}.
991      */
992     function symbol() public view virtual override returns (string memory) {
993         return _symbol;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-tokenURI}.
998      */
999     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1000         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1001 
1002         string memory baseURI = _baseURI();
1003         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1004     }
1005 
1006     /**
1007      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1008      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1009      * by default, can be overriden in child contracts.
1010      */
1011     function _baseURI() internal view virtual returns (string memory) {
1012         return '';
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-approve}.
1017      */
1018     function approve(address to, uint256 tokenId) public override {
1019         address owner = ERC721A.ownerOf(tokenId);
1020         if (to == owner) revert ApprovalToCurrentOwner();
1021 
1022         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1023             revert ApprovalCallerNotOwnerNorApproved();
1024         }
1025 
1026         _approve(to, tokenId, owner);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-getApproved}.
1031      */
1032     function getApproved(uint256 tokenId) public view override returns (address) {
1033         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1034 
1035         return _tokenApprovals[tokenId];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-setApprovalForAll}.
1040      */
1041     function setApprovalForAll(address operator, bool approved) public override {
1042         if (operator == _msgSender()) revert ApproveToCaller();
1043 
1044         _operatorApprovals[_msgSender()][operator] = approved;
1045         emit ApprovalForAll(_msgSender(), operator, approved);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-isApprovedForAll}.
1050      */
1051     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1052         return _operatorApprovals[owner][operator];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-transferFrom}.
1057      */
1058     function transferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) public virtual override {
1063         _transfer(from, to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-safeTransferFrom}.
1068      */
1069     function safeTransferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) public virtual override {
1074         safeTransferFrom(from, to, tokenId, '');
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-safeTransferFrom}.
1079      */
1080     function safeTransferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) public virtual override {
1086         _transfer(from, to, tokenId);
1087         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1088             revert TransferToNonERC721ReceiverImplementer();
1089         }
1090     }
1091 
1092     /**
1093      * @dev Returns whether `tokenId` exists.
1094      *
1095      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1096      *
1097      * Tokens start existing when they are minted (`_mint`),
1098      */
1099     function _exists(uint256 tokenId) internal view returns (bool) {
1100         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1101             !_ownerships[tokenId].burned;
1102     }
1103 
1104     function _safeMint(address to, uint256 quantity) internal {
1105         _safeMint(to, quantity, '');
1106     }
1107 
1108     /**
1109      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _safeMint(
1119         address to,
1120         uint256 quantity,
1121         bytes memory _data
1122     ) internal {
1123         _mint(to, quantity, _data, true);
1124     }
1125 
1126     /**
1127      * @dev Mints `quantity` tokens and transfers them to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `quantity` must be greater than 0.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _mint(
1137         address to,
1138         uint256 quantity,
1139         bytes memory _data,
1140         bool safe
1141     ) internal {
1142         uint256 startTokenId = _currentIndex;
1143         if (to == address(0)) revert MintToZeroAddress();
1144         if (quantity == 0) revert MintZeroQuantity();
1145 
1146         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1147 
1148         // Overflows are incredibly unrealistic.
1149         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1150         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1151         unchecked {
1152             _addressData[to].balance += uint64(quantity);
1153             _addressData[to].numberMinted += uint64(quantity);
1154 
1155             _ownerships[startTokenId].addr = to;
1156             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1157 
1158             uint256 updatedIndex = startTokenId;
1159             uint256 end = updatedIndex + quantity;
1160 
1161             if (safe && to.isContract()) {
1162                 do {
1163                     emit Transfer(address(0), to, updatedIndex);
1164                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1165                         revert TransferToNonERC721ReceiverImplementer();
1166                     }
1167                 } while (updatedIndex != end);
1168                 // Reentrancy protection
1169                 if (_currentIndex != startTokenId) revert();
1170             } else {
1171                 do {
1172                     emit Transfer(address(0), to, updatedIndex++);
1173                 } while (updatedIndex != end);
1174             }
1175             _currentIndex = updatedIndex;
1176         }
1177         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) private {
1195         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1196 
1197         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1198             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1199             getApproved(tokenId) == _msgSender());
1200 
1201         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1202         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1203         if (to == address(0)) revert TransferToZeroAddress();
1204 
1205         _beforeTokenTransfers(from, to, tokenId, 1);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId, prevOwnership.addr);
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1213         unchecked {
1214             _addressData[from].balance -= 1;
1215             _addressData[to].balance += 1;
1216 
1217             _ownerships[tokenId].addr = to;
1218             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             if (_ownerships[nextTokenId].addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId < _currentIndex) {
1227                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1228                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1249 
1250         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, prevOwnership.addr);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             _addressData[prevOwnership.addr].balance -= 1;
1260             _addressData[prevOwnership.addr].numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             _ownerships[tokenId].addr = prevOwnership.addr;
1264             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1265             _ownerships[tokenId].burned = true;
1266 
1267             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1268             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1269             uint256 nextTokenId = tokenId + 1;
1270             if (_ownerships[nextTokenId].addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId < _currentIndex) {
1274                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1275                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(prevOwnership.addr, address(0), tokenId);
1281         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1282 
1283         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1284         unchecked {
1285             _burnCounter++;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(
1295         address to,
1296         uint256 tokenId,
1297         address owner
1298     ) private {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(owner, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1305      *
1306      * @param from address representing the previous owner of the given token ID
1307      * @param to target address that will receive the tokens
1308      * @param tokenId uint256 ID of the token to be transferred
1309      * @param _data bytes optional data to send along with the call
1310      * @return bool whether the call correctly returned the expected magic value
1311      */
1312     function _checkContractOnERC721Received(
1313         address from,
1314         address to,
1315         uint256 tokenId,
1316         bytes memory _data
1317     ) private returns (bool) {
1318         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1319             return retval == IERC721Receiver(to).onERC721Received.selector;
1320         } catch (bytes memory reason) {
1321             if (reason.length == 0) {
1322                 revert TransferToNonERC721ReceiverImplementer();
1323             } else {
1324                 assembly {
1325                     revert(add(32, reason), mload(reason))
1326                 }
1327             }
1328         }
1329     }
1330 
1331     /**
1332      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1333      * And also called before burning one token.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, `tokenId` will be burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _beforeTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1355      * minting.
1356      * And also called after one token has been burned.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` has been minted for `to`.
1366      * - When `to` is zero, `tokenId` has been burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _afterTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 }
1376 
1377 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1378 
1379 
1380 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 /**
1385  * @dev Interface of the ERC20 standard as defined in the EIP.
1386  */
1387 interface IERC20 {
1388     /**
1389      * @dev Returns the amount of tokens in existence.
1390      */
1391     function totalSupply() external view returns (uint256);
1392 
1393     /**
1394      * @dev Returns the amount of tokens owned by `account`.
1395      */
1396     function balanceOf(address account) external view returns (uint256);
1397 
1398     /**
1399      * @dev Moves `amount` tokens from the caller's account to `to`.
1400      *
1401      * Returns a boolean value indicating whether the operation succeeded.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function transfer(address to, uint256 amount) external returns (bool);
1406 
1407     /**
1408      * @dev Returns the remaining number of tokens that `spender` will be
1409      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1410      * zero by default.
1411      *
1412      * This value changes when {approve} or {transferFrom} are called.
1413      */
1414     function allowance(address owner, address spender) external view returns (uint256);
1415 
1416     /**
1417      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1418      *
1419      * Returns a boolean value indicating whether the operation succeeded.
1420      *
1421      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1422      * that someone may use both the old and the new allowance by unfortunate
1423      * transaction ordering. One possible solution to mitigate this race
1424      * condition is to first reduce the spender's allowance to 0 and set the
1425      * desired value afterwards:
1426      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1427      *
1428      * Emits an {Approval} event.
1429      */
1430     function approve(address spender, uint256 amount) external returns (bool);
1431 
1432     /**
1433      * @dev Moves `amount` tokens from `from` to `to` using the
1434      * allowance mechanism. `amount` is then deducted from the caller's
1435      * allowance.
1436      *
1437      * Returns a boolean value indicating whether the operation succeeded.
1438      *
1439      * Emits a {Transfer} event.
1440      */
1441     function transferFrom(
1442         address from,
1443         address to,
1444         uint256 amount
1445     ) external returns (bool);
1446 
1447     /**
1448      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1449      * another (`to`).
1450      *
1451      * Note that `value` may be zero.
1452      */
1453     event Transfer(address indexed from, address indexed to, uint256 value);
1454 
1455     /**
1456      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1457      * a call to {approve}. `value` is the new allowance.
1458      */
1459     event Approval(address indexed owner, address indexed spender, uint256 value);
1460 }
1461 
1462 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1463 
1464 
1465 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1466 
1467 pragma solidity ^0.8.0;
1468 
1469 
1470 
1471 /**
1472  * @title SafeERC20
1473  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1474  * contract returns false). Tokens that return no value (and instead revert or
1475  * throw on failure) are also supported, non-reverting calls are assumed to be
1476  * successful.
1477  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1478  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1479  */
1480 library SafeERC20 {
1481     using Address for address;
1482 
1483     function safeTransfer(
1484         IERC20 token,
1485         address to,
1486         uint256 value
1487     ) internal {
1488         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1489     }
1490 
1491     function safeTransferFrom(
1492         IERC20 token,
1493         address from,
1494         address to,
1495         uint256 value
1496     ) internal {
1497         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1498     }
1499 
1500     /**
1501      * @dev Deprecated. This function has issues similar to the ones found in
1502      * {IERC20-approve}, and its usage is discouraged.
1503      *
1504      * Whenever possible, use {safeIncreaseAllowance} and
1505      * {safeDecreaseAllowance} instead.
1506      */
1507     function safeApprove(
1508         IERC20 token,
1509         address spender,
1510         uint256 value
1511     ) internal {
1512         // safeApprove should only be called when setting an initial allowance,
1513         // or when resetting it to zero. To increase and decrease it, use
1514         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1515         require(
1516             (value == 0) || (token.allowance(address(this), spender) == 0),
1517             "SafeERC20: approve from non-zero to non-zero allowance"
1518         );
1519         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1520     }
1521 
1522     function safeIncreaseAllowance(
1523         IERC20 token,
1524         address spender,
1525         uint256 value
1526     ) internal {
1527         uint256 newAllowance = token.allowance(address(this), spender) + value;
1528         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1529     }
1530 
1531     function safeDecreaseAllowance(
1532         IERC20 token,
1533         address spender,
1534         uint256 value
1535     ) internal {
1536         unchecked {
1537             uint256 oldAllowance = token.allowance(address(this), spender);
1538             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1539             uint256 newAllowance = oldAllowance - value;
1540             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1541         }
1542     }
1543 
1544     /**
1545      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1546      * on the return value: the return value is optional (but if data is returned, it must not be false).
1547      * @param token The token targeted by the call.
1548      * @param data The call data (encoded using abi.encode or one of its variants).
1549      */
1550     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1551         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1552         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1553         // the target address contains contract code and also asserts for success in the low-level call.
1554 
1555         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1556         if (returndata.length > 0) {
1557             // Return data is optional
1558             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1559         }
1560     }
1561 }
1562 
1563 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1564 
1565 
1566 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 
1571 
1572 
1573 /**
1574  * @title PaymentSplitter
1575  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1576  * that the Ether will be split in this way, since it is handled transparently by the contract.
1577  *
1578  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1579  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1580  * an amount proportional to the percentage of total shares they were assigned.
1581  *
1582  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1583  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1584  * function.
1585  *
1586  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1587  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1588  * to run tests before sending real value to this contract.
1589  */
1590 contract PaymentSplitter is Context {
1591     event PayeeAdded(address account, uint256 shares);
1592     event PaymentReleased(address to, uint256 amount);
1593     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1594     event PaymentReceived(address from, uint256 amount);
1595 
1596     uint256 private _totalShares;
1597     uint256 private _totalReleased;
1598 
1599     mapping(address => uint256) private _shares;
1600     mapping(address => uint256) private _released;
1601     address[] private _payees;
1602 
1603     mapping(IERC20 => uint256) private _erc20TotalReleased;
1604     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1605 
1606     /**
1607      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1608      * the matching position in the `shares` array.
1609      *
1610      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1611      * duplicates in `payees`.
1612      */
1613     constructor(address[] memory payees, uint256[] memory shares_) payable {
1614         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1615         require(payees.length > 0, "PaymentSplitter: no payees");
1616 
1617         for (uint256 i = 0; i < payees.length; i++) {
1618             _addPayee(payees[i], shares_[i]);
1619         }
1620     }
1621 
1622     /**
1623      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1624      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1625      * reliability of the events, and not the actual splitting of Ether.
1626      *
1627      * To learn more about this see the Solidity documentation for
1628      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1629      * functions].
1630      */
1631     receive() external payable virtual {
1632         emit PaymentReceived(_msgSender(), msg.value);
1633     }
1634 
1635     /**
1636      * @dev Getter for the total shares held by payees.
1637      */
1638     function totalShares() public view returns (uint256) {
1639         return _totalShares;
1640     }
1641 
1642     /**
1643      * @dev Getter for the total amount of Ether already released.
1644      */
1645     function totalReleased() public view returns (uint256) {
1646         return _totalReleased;
1647     }
1648 
1649     /**
1650      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1651      * contract.
1652      */
1653     function totalReleased(IERC20 token) public view returns (uint256) {
1654         return _erc20TotalReleased[token];
1655     }
1656 
1657     /**
1658      * @dev Getter for the amount of shares held by an account.
1659      */
1660     function shares(address account) public view returns (uint256) {
1661         return _shares[account];
1662     }
1663 
1664     /**
1665      * @dev Getter for the amount of Ether already released to a payee.
1666      */
1667     function released(address account) public view returns (uint256) {
1668         return _released[account];
1669     }
1670 
1671     /**
1672      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1673      * IERC20 contract.
1674      */
1675     function released(IERC20 token, address account) public view returns (uint256) {
1676         return _erc20Released[token][account];
1677     }
1678 
1679     /**
1680      * @dev Getter for the address of the payee number `index`.
1681      */
1682     function payee(uint256 index) public view returns (address) {
1683         return _payees[index];
1684     }
1685 
1686     /**
1687      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1688      * total shares and their previous withdrawals.
1689      */
1690     function release(address payable account) public virtual {
1691         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1692 
1693         uint256 totalReceived = address(this).balance + totalReleased();
1694         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1695 
1696         require(payment != 0, "PaymentSplitter: account is not due payment");
1697 
1698         _released[account] += payment;
1699         _totalReleased += payment;
1700 
1701         Address.sendValue(account, payment);
1702         emit PaymentReleased(account, payment);
1703     }
1704 
1705     /**
1706      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1707      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1708      * contract.
1709      */
1710     function release(IERC20 token, address account) public virtual {
1711         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1712 
1713         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1714         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1715 
1716         require(payment != 0, "PaymentSplitter: account is not due payment");
1717 
1718         _erc20Released[token][account] += payment;
1719         _erc20TotalReleased[token] += payment;
1720 
1721         SafeERC20.safeTransfer(token, account, payment);
1722         emit ERC20PaymentReleased(token, account, payment);
1723     }
1724 
1725     /**
1726      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1727      * already released amounts.
1728      */
1729     function _pendingPayment(
1730         address account,
1731         uint256 totalReceived,
1732         uint256 alreadyReleased
1733     ) private view returns (uint256) {
1734         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1735     }
1736 
1737     /**
1738      * @dev Add a new payee to the contract.
1739      * @param account The address of the payee to add.
1740      * @param shares_ The number of shares owned by the payee.
1741      */
1742     function _addPayee(address account, uint256 shares_) private {
1743         require(account != address(0), "PaymentSplitter: account is the zero address");
1744         require(shares_ > 0, "PaymentSplitter: shares are 0");
1745         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1746 
1747         _payees.push(account);
1748         _shares[account] = shares_;
1749         _totalShares = _totalShares + shares_;
1750         emit PayeeAdded(account, shares_);
1751     }
1752 }
1753 
1754 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1755 
1756 
1757 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1758 
1759 pragma solidity ^0.8.0;
1760 
1761 /**
1762  * @dev These functions deal with verification of Merkle Trees proofs.
1763  *
1764  * The proofs can be generated using the JavaScript library
1765  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1766  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1767  *
1768  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1769  */
1770 library MerkleProof {
1771     /**
1772      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1773      * defined by `root`. For this, a `proof` must be provided, containing
1774      * sibling hashes on the branch from the leaf to the root of the tree. Each
1775      * pair of leaves and each pair of pre-images are assumed to be sorted.
1776      */
1777     function verify(
1778         bytes32[] memory proof,
1779         bytes32 root,
1780         bytes32 leaf
1781     ) internal pure returns (bool) {
1782         return processProof(proof, leaf) == root;
1783     }
1784 
1785     /**
1786      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1787      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1788      * hash matches the root of the tree. When processing the proof, the pairs
1789      * of leafs & pre-images are assumed to be sorted.
1790      *
1791      * _Available since v4.4._
1792      */
1793     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1794         bytes32 computedHash = leaf;
1795         for (uint256 i = 0; i < proof.length; i++) {
1796             bytes32 proofElement = proof[i];
1797             if (computedHash <= proofElement) {
1798                 // Hash(current computed hash + current element of the proof)
1799                 computedHash = _efficientHash(computedHash, proofElement);
1800             } else {
1801                 // Hash(current element of the proof + current computed hash)
1802                 computedHash = _efficientHash(proofElement, computedHash);
1803             }
1804         }
1805         return computedHash;
1806     }
1807 
1808     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1809         assembly {
1810             mstore(0x00, a)
1811             mstore(0x20, b)
1812             value := keccak256(0x00, 0x40)
1813         }
1814     }
1815 }
1816 
1817 // File: contracts/EnumerableERC721A.sol
1818 
1819 
1820 pragma solidity ^0.8.7;
1821 
1822 /// @title KPK Project
1823 
1824 contract KOPOKOMafia is ERC721A, PaymentSplitter, Ownable, ReentrancyGuard {
1825 
1826 
1827     //To concatenate the URL of an NFT
1828     using Strings for uint256;
1829 
1830     //To check the addresses in the whitelist
1831     bytes32 private mR;
1832     //Number of NFTs in the collection
1833     uint public constant MAX_SUPPLY = 1000;
1834     //Maximum number of NFTs an address can mint
1835     uint public max_mint_allowed = 2;
1836     //Maximum number of NFTs an address can mint
1837     uint public max_mint_allowed_presale = 2;
1838     //Price of one NFT in presale
1839     uint public pricePresale = 0.08 ether;
1840     //Price of one NFT in sale
1841     uint public priceSale = 0.08 ether;
1842 
1843     //URI of the NFTs when revealed
1844     string private baseURI;
1845     //URI of the NFTs when not revealed
1846     string private notRevealedURI;
1847     //The extension of the file containing the Metadatas of the NFTs
1848     string public baseExtension = ".json";
1849 
1850     //Are the NFTs revealed yet ?
1851     bool public revealed = false;
1852 
1853     //Is the contract paused ?
1854     bool public paused = false;
1855 
1856 
1857     //The different stages of selling the collection
1858     enum Steps {
1859         Before,
1860         Presale,
1861         Sale,
1862         SoldOut,
1863         Reveal
1864     }
1865 
1866     Steps public sellingStep;
1867     
1868     //Owner of the smart contract
1869     address private _owner;
1870 
1871     //Keep a track of the number of tokens per address
1872     mapping(address => uint) nftsPerWallet;
1873 
1874     //Keep a track of the number of tokens per address
1875     mapping(address => uint) nftsPerWalletSale;
1876 
1877     //Addresses of all the members of the team
1878     address[] private _team = [
1879         0x5B1a4ebd28b597fe47494A0a5766b2Eb6e6B3fcC
1880     ];
1881 
1882     //Shares of all the members of the team
1883     uint[] private _teamShares = [
1884         100
1885     ];
1886     
1887     //Constructor of the collection
1888     constructor() ERC721A("KPK Project", "KPK") PaymentSplitter(_team, _teamShares) {
1889        
1890         transferOwnership(msg.sender);
1891         sellingStep = Steps.Before;
1892   
1893     }
1894 
1895     /**
1896      * To change the starting tokenId, please override this function.
1897      */
1898     function _startTokenId() internal view virtual override returns (uint256) {
1899         return 1;
1900     }
1901 
1902     /**
1903     * @notice Edit the Merkle Root 
1904     *
1905     * @param _newMerkleRoot The new Merkle Root
1906     **/
1907     function changeMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1908         mR = _newMerkleRoot;
1909     }
1910     /**
1911     * @notice Initialise Merkle Root
1912     *
1913     * @param _theBaseURI Base URI
1914     * @param _notRevealedURI Hide base URI
1915     * @param _merkleRoot The new Merkle Root
1916     **/
1917     function init(string memory _theBaseURI, string memory _notRevealedURI, bytes32 _merkleRoot) external onlyOwner {
1918         mR = _merkleRoot;
1919         baseURI = _theBaseURI;
1920         notRevealedURI = _notRevealedURI;
1921     }
1922 
1923     /** 
1924     * @notice Set pause to true or false
1925     *
1926     * @param _paused True or false if you want the contract to be paused or not
1927     **/
1928     function setPaused(bool _paused) external onlyOwner {
1929         paused = _paused;
1930     }
1931 
1932     /** 
1933     * @notice Change the number of NFTs that an address can mint
1934     *
1935     * @param _maxMintAllowed The number of NFTs that an address can mint
1936     **/
1937     function changeMaxMintAllowed(uint _maxMintAllowed) external onlyOwner {
1938         max_mint_allowed = _maxMintAllowed;
1939     }
1940 
1941     /** 
1942     * @notice Change the number of NFTs that an address can mint
1943     *
1944     * @param _maxMintAllowedPreSale The number of NFTs that an address can mint
1945     **/
1946     function changeMaxMintAllowedPreSale(uint _maxMintAllowedPreSale) external onlyOwner {
1947         max_mint_allowed_presale = _maxMintAllowedPreSale;
1948     }
1949 
1950     /**
1951     * @notice Change the price of one NFT for the presale
1952     *
1953     * @param _pricePresale The new price of one NFT for the presale
1954     **/
1955     function changePricePresale(uint _pricePresale) external onlyOwner {
1956         pricePresale = _pricePresale;
1957     }
1958 
1959     /**
1960     * @notice Change the price of one NFT for the sale
1961     *
1962     * @param _priceSale The new price of one NFT for the sale
1963     **/
1964     function changePriceSale(uint _priceSale) external onlyOwner {
1965         priceSale = _priceSale;
1966     }
1967 
1968     /**
1969     * @notice Allows to set the revealed variable to true
1970     **/
1971     function reveal() external onlyOwner{
1972         revealed = true;
1973     }
1974     /**
1975     * @notice Change the base URI
1976     *
1977     * @param _newBaseURI The new base URI
1978     **/
1979     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1980         baseURI = _newBaseURI;
1981     }
1982 
1983     /**
1984     * @notice Change the not revealed URI
1985     *
1986     * @param _notRevealedURI The new not revealed URI
1987     **/
1988     function setNotRevealURI(string memory _notRevealedURI) external onlyOwner {
1989         notRevealedURI = _notRevealedURI;
1990     }
1991     /**
1992     * @notice Return URI of the NFTs when revealed
1993     *
1994     * @return The URI of the NFTs when revealed
1995     **/
1996     function _baseURI() internal view virtual override returns (string memory) {
1997         return baseURI;
1998     }
1999 
2000     /**
2001     * @notice Allows to change the base extension of the metadatas files
2002     *
2003     * @param _baseExtension the new extension of the metadatas files
2004     **/
2005     function setBaseExtension(string memory _baseExtension) external onlyOwner {
2006         baseExtension = _baseExtension;
2007     }
2008 
2009     /** 
2010     * @notice Allows to change the sellinStep to Presale
2011     **/
2012     function setUpPresale() external onlyOwner {
2013         sellingStep = Steps.Presale;
2014     }
2015 
2016     /** 
2017     * @notice Allows to change the sellinStep to Sale
2018     **/
2019     function setUpSale() external onlyOwner {
2020         require(sellingStep == Steps.Presale, "First the presale, then the sale.");
2021         sellingStep = Steps.Sale;
2022     }
2023 
2024     /**
2025     * @notice Allows to mint one NFT if whitelisted
2026     *
2027     * 
2028     * @param _proof The Merkle Proof
2029     * @param _ammount The ammount of NFTs the user wants to mint
2030     **/
2031     function presaleMint(bytes32[] calldata _proof,uint256 _ammount) external payable nonReentrant {
2032         
2033         //Are we in Presale ?
2034         require(sellingStep == Steps.Presale, "Presale has not started yet.");
2035         
2036         //Did this account already mint an NFT ?
2037         require(nftsPerWallet[msg.sender] < max_mint_allowed_presale, string(abi.encodePacked("You can only get ",
2038         Strings.toString(max_mint_allowed_presale)," NFT on the Presale")));
2039 
2040         require(_ammount <= max_mint_allowed_presale, string(abi.encodePacked("You can't mint more than ",
2041         Strings.toString(max_mint_allowed_presale)," tokens")));
2042 
2043         //Is this user on the whitelist ?
2044         require(isWhiteListed(msg.sender, _proof), "You are not on the whitelist");
2045          //Get the price of one NFT during the Presale
2046         uint price = pricePresale;
2047         //Did the user send enought Ethers ?
2048         require(msg.value >= price * _ammount, "Not enought funds.");
2049         //Increment the number of NFTs this user minted
2050         nftsPerWallet[msg.sender] += _ammount;
2051         //Mint the user NFT
2052         _safeMint(msg.sender, _ammount);
2053     }
2054 
2055     /**
2056     * @notice Allows to mint NFTs
2057     *
2058     * @param _ammount The ammount of NFTs the user wants to mint
2059     **/
2060     function saleMint(uint256 _ammount) external payable nonReentrant {
2061         //Get the number of NFT sold
2062         uint numberNftSold = totalSupply();
2063         //Get the price of one NFT in Sale
2064         uint price = priceSale;
2065         //If everything has been bought
2066         require(sellingStep != Steps.SoldOut, "Sorry, no NFTs left.");
2067         //If Sale didn't start yet
2068         require(sellingStep == Steps.Sale, "Sorry, sale has not started yet.");
2069         //Did the user then enought Ethers to buy ammount NFTs ?
2070         require(msg.value >= price * _ammount, "Not enought funds.");
2071        
2072         //The user can only mint max X NFTs
2073         require(nftsPerWalletSale[msg.sender] < max_mint_allowed, string(abi.encodePacked("You can only get ",
2074         Strings.toString(max_mint_allowed)," NFT on the Sale")));
2075 
2076          require(_ammount <= max_mint_allowed, string(abi.encodePacked("You can't mint more than ",
2077         Strings.toString(max_mint_allowed)," tokens")));
2078 
2079         //If the user try to mint any non-existent token
2080         require(numberNftSold + _ammount <= MAX_SUPPLY, "Sale is almost done and we don't have enought NFTs left.");
2081         //Add the ammount of NFTs minted by the user to the total he minted
2082         nftsPerWalletSale[msg.sender] += _ammount;
2083         //Minting all the account NFTs
2084         
2085         _safeMint(msg.sender, _ammount);
2086         
2087         //If this account minted the last NFTs available
2088         if(numberNftSold + _ammount == MAX_SUPPLY) {
2089             sellingStep = Steps.SoldOut;   
2090         }
2091     }
2092 
2093     /**
2094     * @notice Allows to gift one NFT to an address
2095     *
2096     * @param _account The account of the happy new owner of one NFT
2097     **/
2098     function gift(address _account) external onlyOwner {
2099         uint supply = totalSupply();
2100         require(supply + 1 <= MAX_SUPPLY, "Sold out");
2101         _safeMint(_account, 1);
2102     }
2103 
2104     /**
2105     * @notice Return true or false if the account is whitelisted or not
2106     *
2107     * @param account The account of the user
2108     * @param proof The Merkle Proof
2109     *
2110     * @return true or false if the account is whitelisted or not
2111     **/
2112     function isWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
2113            
2114         return _verify(_leaf(account),proof);
2115     }
2116 
2117     /**
2118     * @notice Return the account hashed
2119     *
2120     * @param account The account to hash
2121     *
2122     * @return The account hashed
2123     **/
2124     function _leaf(address account) internal pure returns(bytes32) {
2125         return keccak256(abi.encodePacked(account));
2126     }
2127 
2128     /** 
2129     * @notice Returns true if a leaf can be proved to be a part of a Merkle tree defined by root
2130     *
2131     * @param leaf The leaf
2132     * @param proof The Merkle Proof
2133     *
2134     * @return True if a leaf can be provded to be a part of a Merkle tree defined by root
2135     **/
2136     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
2137         return MerkleProof.verify(proof, mR, leaf);
2138     }
2139 
2140     /**
2141     * @notice Allows to get the complete URI of a specific NFT by his ID
2142     *
2143     * @param _nftId The id of the NFT
2144     *
2145     * @return The token URI of the NFT which has _nftId Id
2146     **/
2147     function tokenURI(uint _nftId) public view override(ERC721A) returns (string memory) {
2148         require(_exists(_nftId), "This NFT doesn't exist.");
2149         if(revealed == false) {
2150             return notRevealedURI;
2151         }
2152         
2153         string memory currentBaseURI = _baseURI();
2154         return 
2155             bytes(currentBaseURI).length > 0 
2156             ? string(abi.encodePacked(currentBaseURI, _nftId.toString(), baseExtension))
2157             : "";
2158     }   
2159 
2160 }