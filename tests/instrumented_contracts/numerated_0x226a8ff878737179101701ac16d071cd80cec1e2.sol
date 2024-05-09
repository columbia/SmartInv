1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /// @title Fouding Agents
5 /// @author André Costa @ Digits Brands
6 
7 
8 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Contract module that helps prevent reentrant calls to a function.
17  *
18  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
19  * available, which can be applied to functions to make sure there are no nested
20  * (reentrant) calls to them.
21  *
22  * Note that because there is a single `nonReentrant` guard, functions marked as
23  * `nonReentrant` may not call one another. This can be worked around by making
24  * those functions `private`, and then adding `external` `nonReentrant` entry
25  * points to them.
26  *
27  * TIP: If you would like to learn more about reentrancy and alternative ways
28  * to protect against it, check out our blog post
29  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
30  */
31 abstract contract ReentrancyGuard {
32     // Booleans are more expensive than uint256 or any type that takes up a full
33     // word because each write operation emits an extra SLOAD to first read the
34     // slot's contents, replace the bits taken up by the boolean, and then write
35     // back. This is the compiler's defense against contract upgrades and
36     // pointer aliasing, and it cannot be disabled.
37 
38     // The values being non-zero value makes deployment a bit more expensive,
39     // but in exchange the refund on every call to nonReentrant will be lower in
40     // amount. Since refunds are capped to a percentage of the total
41     // transaction's gas, it is best to keep them low in cases like this one, to
42     // increase the likelihood of the full refund coming into effect.
43     uint256 private constant _NOT_ENTERED = 1;
44     uint256 private constant _ENTERED = 2;
45 
46     uint256 private _status;
47 
48     constructor() {
49         _status = _NOT_ENTERED;
50     }
51 
52     /**
53      * @dev Prevents a contract from calling itself, directly or indirectly.
54      * Calling a `nonReentrant` function from another `nonReentrant`
55      * function is not supported. It is possible to prevent this from happening
56      * by making the `nonReentrant` function external, and making it call a
57      * `private` function that does the actual work.
58      */
59     modifier nonReentrant() {
60         // On the first call to nonReentrant, _notEntered will be true
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65 
66         _;
67 
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Address.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
183 
184 pragma solidity ^0.8.1;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      *
207      * [IMPORTANT]
208      * ====
209      * You shouldn't rely on `isContract` to protect against flash loan attacks!
210      *
211      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
212      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
213      * constructor.
214      * ====
215      */
216     function isContract(address account) internal view returns (bool) {
217         // This method relies on extcodesize/address.code.length, which returns 0
218         // for contracts in construction, since the code is only stored at the end
219         // of the constructor execution.
220 
221         return account.code.length > 0;
222     }
223 
224     /**
225      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
226      * `recipient`, forwarding all available gas and reverting on errors.
227      *
228      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
229      * of certain opcodes, possibly making contracts go over the 2300 gas limit
230      * imposed by `transfer`, making them unable to receive funds via
231      * `transfer`. {sendValue} removes this limitation.
232      *
233      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
234      *
235      * IMPORTANT: because control is transferred to `recipient`, care must be
236      * taken to not create reentrancy vulnerabilities. Consider using
237      * {ReentrancyGuard} or the
238      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
239      */
240     function sendValue(address payable recipient, uint256 amount) internal {
241         require(address(this).balance >= amount, "Address: insufficient balance");
242 
243         (bool success, ) = recipient.call{value: amount}("");
244         require(success, "Address: unable to send value, recipient may have reverted");
245     }
246 
247     /**
248      * @dev Performs a Solidity function call using a low level `call`. A
249      * plain `call` is an unsafe replacement for a function call: use this
250      * function instead.
251      *
252      * If `target` reverts with a revert reason, it is bubbled up by this
253      * function (like regular Solidity function calls).
254      *
255      * Returns the raw returned data. To convert to the expected return value,
256      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
257      *
258      * Requirements:
259      *
260      * - `target` must be a contract.
261      * - calling `target` with `data` must not revert.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionCall(target, data, "Address: low-level call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
271      * `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, 0, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but also transferring `value` wei to `target`.
286      *
287      * Requirements:
288      *
289      * - the calling contract must have an ETH balance of at least `value`.
290      * - the called Solidity function must be `payable`.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
304      * with `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         require(isContract(target), "Address: call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.call{value: value}(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         require(isContract(target), "Address: static call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.staticcall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(isContract(target), "Address: delegate call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.delegatecall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
377      * revert reason using the provided one.
378      *
379      * _Available since v4.3._
380      */
381     function verifyCallResult(
382         bool success,
383         bytes memory returndata,
384         string memory errorMessage
385     ) internal pure returns (bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @title ERC721 token receiver interface
413  * @dev Interface for any contract that wants to support safeTransfers
414  * from ERC721 asset contracts.
415  */
416 interface IERC721Receiver {
417     /**
418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
419      * by `operator` from `from`, this function is called.
420      *
421      * It must return its Solidity selector to confirm the token transfer.
422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
423      *
424      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
425      */
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * `interfaceId`. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505     /**
506      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
512      */
513     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in ``owner``'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Transfers `tokenId` token from `from` to `to`.
556      *
557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
579      *
580      * Requirements:
581      *
582      * - The caller must own the token or be an approved operator.
583      * - `tokenId` must exist.
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Approve or remove `operator` as an operator for the caller.
600      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
601      *
602      * Requirements:
603      *
604      * - The `operator` cannot be the caller.
605      *
606      * Emits an {ApprovalForAll} event.
607      */
608     function setApprovalForAll(address operator, bool _approved) external;
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId,
634         bytes calldata data
635     ) external;
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
648  * @dev See https://eips.ethereum.org/EIPS/eip-721
649  */
650 interface IERC721Metadata is IERC721 {
651     /**
652      * @dev Returns the token collection name.
653      */
654     function name() external view returns (string memory);
655 
656     /**
657      * @dev Returns the token collection symbol.
658      */
659     function symbol() external view returns (string memory);
660 
661     /**
662      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
663      */
664     function tokenURI(uint256 tokenId) external view returns (string memory);
665 }
666 
667 
668 /**
669  * @dev String operations.
670  */
671 library Strings {
672     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
673 
674     /**
675      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
676      */
677     function toString(uint256 value) internal pure returns (string memory) {
678         // Inspired by OraclizeAPI's implementation - MIT licence
679         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
680 
681         if (value == 0) {
682             return "0";
683         }
684         uint256 temp = value;
685         uint256 digits;
686         while (temp != 0) {
687             digits++;
688             temp /= 10;
689         }
690         bytes memory buffer = new bytes(digits);
691         while (value != 0) {
692             digits -= 1;
693             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
694             value /= 10;
695         }
696         return string(buffer);
697     }
698 
699     /**
700      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
701      */
702     function toHexString(uint256 value) internal pure returns (string memory) {
703         if (value == 0) {
704             return "0x00";
705         }
706         uint256 temp = value;
707         uint256 length = 0;
708         while (temp != 0) {
709             length++;
710             temp >>= 8;
711         }
712         return toHexString(value, length);
713     }
714 
715     /**
716      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
717      */
718     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
719         bytes memory buffer = new bytes(2 * length + 2);
720         buffer[0] = "0";
721         buffer[1] = "x";
722         for (uint256 i = 2 * length + 1; i > 1; --i) {
723             buffer[i] = _HEX_SYMBOLS[value & 0xf];
724             value >>= 4;
725         }
726         require(value == 0, "Strings: hex length insufficient");
727         return string(buffer);
728     }
729 }
730 
731 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
732 
733 /**
734  * @dev Interface of the ERC20 standard as defined in the EIP.
735  */
736 interface IERC20 {
737     /**
738      * @dev Returns the amount of tokens in existence.
739      */
740     function totalSupply() external view returns (uint256);
741 
742     /**
743      * @dev Returns the amount of tokens owned by `account`.
744      */
745     function balanceOf(address account) external view returns (uint256);
746 
747     /**
748      * @dev Moves `amount` tokens from the caller's account to `recipient`.
749      *
750      * Returns a boolean value indicating whether the operation succeeded.
751      *
752      * Emits a {Transfer} event.
753      */
754     function transfer(address recipient, uint256 amount) external returns (bool);
755 
756     /**
757      * @dev Returns the remaining number of tokens that `spender` will be
758      * allowed to spend on behalf of `owner` through {transferFrom}. This is
759      * zero by default.
760      *
761      * This value changes when {approve} or {transferFrom} are called.
762      */
763     function allowance(address owner, address spender) external view returns (uint256);
764 
765     /**
766      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
767      *
768      * Returns a boolean value indicating whether the operation succeeded.
769      *
770      * IMPORTANT: Beware that changing an allowance with this method brings the risk
771      * that someone may use both the old and the new allowance by unfortunate
772      * transaction ordering. One possible solution to mitigate this race
773      * condition is to first reduce the spender's allowance to 0 and set the
774      * desired value afterwards:
775      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
776      *
777      * Emits an {Approval} event.
778      */
779     function approve(address spender, uint256 amount) external returns (bool);
780 
781     /**
782      * @dev Moves `amount` tokens from `sender` to `recipient` using the
783      * allowance mechanism. `amount` is then deducted from the caller's
784      * allowance.
785      *
786      * Returns a boolean value indicating whether the operation succeeded.
787      *
788      * Emits a {Transfer} event.
789      */
790     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
791 
792     /**
793      * @dev Emitted when `value` tokens are moved from one account (`from`) to
794      * another (`to`).
795      *
796      * Note that `value` may be zero.
797      */
798     event Transfer(address indexed from, address indexed to, uint256 value);
799 
800     /**
801      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
802      * a call to {approve}. `value` is the new allowance.
803      */
804     event Approval(address indexed owner, address indexed spender, uint256 value);
805 }
806 
807 
808 interface IDigitsRedeemer {
809     /**
810      * @dev Returns if the `tokenId` has been staked and therefore blocking transfers.
811      */
812     function isStaked(uint tokenId) external view returns (bool);
813 }
814 
815 
816 error ApprovalCallerNotOwnerNorApproved();
817 error ApprovalQueryForNonexistentToken();
818 error ApproveToCaller();
819 error ApprovalToCurrentOwner();
820 error BalanceQueryForZeroAddress();
821 error MintToZeroAddress();
822 error MintZeroQuantity();
823 error OwnerQueryForNonexistentToken();
824 error TransferCallerNotOwnerNorApproved();
825 error TransferFromIncorrectOwner();
826 error TransferToNonERC721ReceiverImplementer();
827 error TransferToZeroAddress();
828 error URIQueryForNonexistentToken();
829 
830 pragma solidity ^0.8.9;
831 
832 /**
833  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
834  * @dev See https://eips.ethereum.org/EIPS/eip-721
835  */
836 interface IERC721Enumerable is IERC721 {
837     /**
838      * @dev Returns the total amount of tokens stored by the contract.
839      */
840     function totalSupply() external view returns (uint256);
841 
842     /**
843      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
844      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
845      */
846     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
847 
848     /**
849      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
850      * Use along with {totalSupply} to enumerate all tokens.
851      */
852     function tokenByIndex(uint256 index) external view returns (uint256);
853 }
854 
855 
856 // Creator: Chiru Labs
857 
858 pragma solidity ^0.8.9;
859 
860 /**
861  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
862  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
863  *
864  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
865  *
866  * Does not support burning tokens to address(0).
867  *
868  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
869  */
870 contract ERC721A is Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
871     using Address for address;
872     using Strings for uint256;
873 
874     struct TokenOwnership {
875         address addr;
876         uint64 startTimestamp;
877     }
878 
879     struct AddressData {
880         uint128 balance;
881         uint128 numberMinted;
882     }
883 
884     uint256 internal currentIndex;
885 
886     // Token name
887     string private _name;
888 
889     // Token symbol
890     string private _symbol;
891 
892     // Mapping from token ID to ownership details
893     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
894     mapping(uint256 => TokenOwnership) internal _ownerships;
895 
896     // Mapping owner address to address data
897     mapping(address => AddressData) private _addressData;
898 
899     // Mapping from token ID to approved address
900     mapping(uint256 => address) private _tokenApprovals;
901 
902     // Mapping from owner to operator approvals
903     mapping(address => mapping(address => bool)) private _operatorApprovals;
904 
905     //connects to the redeemer contract
906     IDigitsRedeemer public DigitsRedeemer;
907 
908     constructor(string memory name_, string memory symbol_) {
909         _name = name_;
910         _symbol = symbol_;
911     }
912 
913     /**
914         To set the address of the digits redeemer contract
915      */
916     function setDigitsRedeemer(address newRedeemer) public onlyOwner {
917         DigitsRedeemer = IDigitsRedeemer(newRedeemer);
918     }
919 
920     /**
921      * @dev See {IERC721Enumerable-totalSupply}.
922      */
923     function totalSupply() public view virtual override returns (uint256) {
924         return currentIndex;
925     }
926 
927     /**
928      * @dev See {IERC721Enumerable-tokenByIndex}.
929      */
930     function tokenByIndex(uint256 index) public view override returns (uint256) {
931         require(index < totalSupply(), 'ERC721A: global index out of bounds');
932         return index;
933     }
934 
935     /**
936      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
937      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
938      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
939      */
940     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
941         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
942         uint256 numMintedSoFar = totalSupply();
943         uint256 tokenIdsIdx;
944         address currOwnershipAddr;
945 
946         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
947         unchecked {
948             for (uint256 i; i < numMintedSoFar; i++) {
949                 TokenOwnership memory ownership = _ownerships[i];
950                 if (ownership.addr != address(0)) {
951                     currOwnershipAddr = ownership.addr;
952                 }
953                 if (currOwnershipAddr == owner) {
954                     if (tokenIdsIdx == index) {
955                         return i;
956                     }
957                     tokenIdsIdx++;
958                 }
959             }
960         }
961 
962         revert('ERC721A: unable to get token of owner by index');
963     }
964 
965     /**
966      * @dev See {IERC165-supportsInterface}.
967      */
968     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
969         return
970             interfaceId == type(IERC721).interfaceId ||
971             interfaceId == type(IERC721Metadata).interfaceId ||
972             interfaceId == type(IERC721Enumerable).interfaceId ||
973             super.supportsInterface(interfaceId);
974     }
975 
976     /**
977      * @dev See {IERC721-balanceOf}.
978      */
979     function balanceOf(address owner) public view override returns (uint256) {
980         require(owner != address(0), 'ERC721A: balance query for the zero address');
981         return uint256(_addressData[owner].balance);
982     }
983 
984     function _numberMinted(address owner) internal view returns (uint256) {
985         require(owner != address(0), 'ERC721A: number minted query for the zero address');
986         return uint256(_addressData[owner].numberMinted);
987     }
988 
989     /**
990      * Gas spent here starts off proportional to the maximum mint batch size.
991      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
992      */
993     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
994         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
995 
996         unchecked {
997             for (uint256 curr = tokenId; curr >= 0; curr--) {
998                 TokenOwnership memory ownership = _ownerships[curr];
999                 if (ownership.addr != address(0)) {
1000                     return ownership;
1001                 }
1002             }
1003         }
1004 
1005         revert('ERC721A: unable to determine the owner of token');
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-ownerOf}.
1010      */
1011     function ownerOf(uint256 tokenId) public view override returns (address) {
1012         return ownershipOf(tokenId).addr;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-name}.
1017      */
1018     function name() public view virtual override returns (string memory) {
1019         return _name;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-symbol}.
1024      */
1025     function symbol() public view virtual override returns (string memory) {
1026         return _symbol;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-tokenURI}.
1031      */
1032     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1033         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1034 
1035         string memory baseURI = _baseURI();
1036         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1037     }
1038 
1039     /**
1040      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1041      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1042      * by default, can be overriden in child contracts.
1043      */
1044     function _baseURI() internal view virtual returns (string memory) {
1045         return '';
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-approve}.
1050      */
1051     function approve(address to, uint256 tokenId) public override {
1052         address owner = ERC721A.ownerOf(tokenId);
1053         require(to != owner, 'ERC721A: approval to current owner');
1054 
1055         require(
1056             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1057             'ERC721A: approve caller is not owner nor approved for all'
1058         );
1059 
1060         _approve(to, tokenId, owner);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-getApproved}.
1065      */
1066     function getApproved(uint256 tokenId) public view override returns (address) {
1067         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved) public override {
1076         require(operator != _msgSender(), 'ERC721A: approve to caller');
1077 
1078         _operatorApprovals[_msgSender()][operator] = approved;
1079         emit ApprovalForAll(_msgSender(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1086         return _operatorApprovals[owner][operator];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-transferFrom}.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         _transfer(from, to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-safeTransferFrom}.
1102      */
1103     function safeTransferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) public virtual override {
1108         safeTransferFrom(from, to, tokenId, '');
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-safeTransferFrom}.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) public override {
1120         _transfer(from, to, tokenId);
1121         require(
1122             _checkOnERC721Received(from, to, tokenId, _data),
1123             'ERC721A: transfer to non ERC721Receiver implementer'
1124         );
1125     }
1126 
1127     /**
1128      * @dev Returns whether `tokenId` exists.
1129      *
1130      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1131      *
1132      * Tokens start existing when they are minted (`_mint`),
1133      */
1134     function _exists(uint256 tokenId) internal view returns (bool) {
1135         return tokenId < currentIndex;
1136     }
1137 
1138     function _safeMint(address to, uint256 quantity) internal {
1139         _safeMint(to, quantity, '');
1140     }
1141 
1142     /**
1143      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _safeMint(
1153         address to,
1154         uint256 quantity,
1155         bytes memory _data
1156     ) internal {
1157         _mint(to, quantity, _data, true);
1158     }
1159 
1160     /**
1161      * @dev Mints `quantity` tokens and transfers them to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - `to` cannot be the zero address.
1166      * - `quantity` must be greater than 0.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function _mint(
1171         address to,
1172         uint256 quantity,
1173         bytes memory _data,
1174         bool safe
1175     ) internal {
1176         uint256 startTokenId = currentIndex;
1177         require(to != address(0), 'ERC721A: mint to the zero address');
1178         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1179 
1180         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1181 
1182         // Overflows are incredibly unrealistic.
1183         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1184         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1185         unchecked {
1186             _addressData[to].balance += uint128(quantity);
1187             _addressData[to].numberMinted += uint128(quantity);
1188 
1189             _ownerships[startTokenId].addr = to;
1190             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1191 
1192             uint256 updatedIndex = startTokenId;
1193 
1194             for (uint256 i; i < quantity; i++) {
1195                 emit Transfer(address(0), to, updatedIndex);
1196                 if (safe) {
1197                     require(
1198                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1199                         'ERC721A: transfer to non ERC721Receiver implementer'
1200                     );
1201                 }
1202 
1203                 updatedIndex++;
1204             }
1205 
1206             currentIndex = updatedIndex;
1207         }
1208 
1209         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1210     }
1211 
1212     /**
1213      * @dev Transfers `tokenId` from `from` to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `to` cannot be the zero address.
1218      * - `tokenId` token must be owned by `from`.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _transfer(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) private {
1227         require(!DigitsRedeemer.isStaked(tokenId), "Token is Staked!");
1228         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1229 
1230         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1231             getApproved(tokenId) == _msgSender() ||
1232             isApprovedForAll(prevOwnership.addr, _msgSender()));
1233 
1234         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1235 
1236         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1237         require(to != address(0), 'ERC721A: transfer to the zero address');
1238 
1239         _beforeTokenTransfers(from, to, tokenId, 1);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId, prevOwnership.addr);
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             _addressData[from].balance -= 1;
1249             _addressData[to].balance += 1;
1250 
1251             _ownerships[tokenId].addr = to;
1252             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1253 
1254             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1255             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1256             uint256 nextTokenId = tokenId + 1;
1257             if (_ownerships[nextTokenId].addr == address(0)) {
1258                 if (_exists(nextTokenId)) {
1259                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1260                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, to, tokenId);
1266         _afterTokenTransfers(from, to, tokenId, 1);
1267     }
1268 
1269     /**
1270      * @dev Approve `to` to operate on `tokenId`
1271      *
1272      * Emits a {Approval} event.
1273      */
1274     function _approve(
1275         address to,
1276         uint256 tokenId,
1277         address owner
1278     ) private {
1279         _tokenApprovals[tokenId] = to;
1280         emit Approval(owner, to, tokenId);
1281     }
1282 
1283     /**
1284      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1285      * The call is not executed if the target address is not a contract.
1286      *
1287      * @param from address representing the previous owner of the given token ID
1288      * @param to target address that will receive the tokens
1289      * @param tokenId uint256 ID of the token to be transferred
1290      * @param _data bytes optional data to send along with the call
1291      * @return bool whether the call correctly returned the expected magic value
1292      */
1293     function _checkOnERC721Received(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes memory _data
1298     ) private returns (bool) {
1299         if (to.isContract()) {
1300             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1301                 return retval == IERC721Receiver(to).onERC721Received.selector;
1302             } catch (bytes memory reason) {
1303                 if (reason.length == 0) {
1304                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1305                 } else {
1306                     assembly {
1307                         revert(add(32, reason), mload(reason))
1308                     }
1309                 }
1310             }
1311         } else {
1312             return true;
1313         }
1314     }
1315 
1316     /**
1317      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1318      *
1319      * startTokenId - the first token id to be transferred
1320      * quantity - the amount to be transferred
1321      *
1322      * Calling conditions:
1323      *
1324      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1325      * transferred to `to`.
1326      * - When `from` is zero, `tokenId` will be minted for `to`.
1327      */
1328     function _beforeTokenTransfers(
1329         address from,
1330         address to,
1331         uint256 startTokenId,
1332         uint256 quantity
1333     ) internal virtual {}
1334 
1335     /**
1336      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1337      * minting.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - when `from` and `to` are both non-zero.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _afterTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 }
1354 
1355 contract FoundingAgents is ERC721A, ReentrancyGuard {
1356     using Strings for uint256;
1357 
1358     //NOTE Token values incremented for gas efficiency
1359     uint256 public maxSalePlusOne = 1000;
1360     uint256 public tokenPricePublic = 0.99 ether;
1361     uint256 public tokenPriceWhitelist = 0.69 ether;
1362 
1363     uint256 public tokenPricePublicBytes = 125000000000000000000;
1364     uint256 public tokenPriceWhitelistBytes = 100000000000000000000;
1365 
1366     IERC20 public BYTES;
1367 
1368     uint public publicMintAllowancePlusOne = 10;
1369     uint public whitelistMintAllowancePlusOne = 10;
1370     uint public presale1MintAllowancePlusOne = 3;
1371     uint public presale2MintAllowancePlusOne = 5;
1372 
1373     enum ContractState {
1374         OFF,
1375         PRESALE,
1376         PUBLIC
1377     }
1378     ContractState public contractState = ContractState.OFF;
1379 
1380     string public placeholderURI;
1381     string public baseURI;
1382 
1383     address public recipient;
1384 
1385     //sigmer address that we use to sign the mint transaction to make sure it is valid
1386     address private signer = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1387 
1388     constructor() ERC721A("Founding Agents", "FA") {
1389         placeholderURI = "ipfs://Qme7LaNmJ87JxV9QRwybRVx6tw4fK3SR5QRBLTjghuC9DN";
1390 
1391         BYTES = IERC20(0x7d647b1A0dcD5525e9C6B3D14BE58f27674f8c95);
1392     
1393     }
1394 
1395     //
1396     // Modifiers
1397     //
1398 
1399     /**
1400      * Do not allow calls from other contracts.
1401      */
1402     modifier noBots() {
1403         require(msg.sender == tx.origin, "No bots!");
1404         _;
1405     }
1406 
1407     /**
1408      * Ensure current state is correct for this method.
1409      */
1410     modifier isContractState(ContractState contractState_) {
1411         require(contractState == contractState_, "Invalid state");
1412         _;
1413     }
1414 
1415     /**
1416      * Ensure amount of tokens to mint is within the limit.
1417      */
1418     modifier withinMintLimit(uint256 quantity) {
1419         require((totalSupply() + quantity) < maxSalePlusOne, "Exceeds available tokens");
1420         _;
1421     }
1422 
1423     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s, uint sale) {
1424         require( isValidAccessMessage(msg.sender,_v,_r,_s, sale), 'Invalid Signature' );
1425         _;
1426     }
1427  
1428     /* 
1429     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1430     *      Assumes Geth signature prefix.
1431     * @param _add Address of agent with access
1432     * @param _v ECDSA signature parameter v.
1433     * @param _r ECDSA signature parameters r.
1434     * @param _s ECDSA signature parameters s.
1435     * @return Validity of access message for a given address.
1436     */
1437     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s, uint sale) view public returns (bool) {
1438         bytes32 hash = keccak256(abi.encodePacked(address(this), _add, sale));
1439         return signer == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1440     }
1441 
1442     //
1443     // Mint
1444     //
1445 
1446     /**
1447      * Public mint.
1448      * @param quantity Amount of tokens to mint.
1449      */
1450     function mintPublic(uint256 quantity, bool isBytes)
1451         external
1452         payable
1453         noBots
1454         isContractState(ContractState.PUBLIC)
1455         withinMintLimit(quantity)
1456     {
1457         require(_numberMinted(msg.sender) + quantity < publicMintAllowancePlusOne, "Maximum number of NFTs allowed to Mint reached!");
1458         if (isBytes) {
1459             BYTES.transferFrom(msg.sender, address(this), quantity * tokenPricePublicBytes);
1460         }
1461         else {
1462             require(msg.value >= tokenPricePublic * quantity, "Insufficient Funds!");
1463         }
1464         _safeMint(msg.sender, quantity);
1465     }
1466 
1467     /**
1468      * Mint tokens during the presale.
1469      * @notice This function is only available to those on the allowlist.
1470      * @param quantity The number of tokens to mint.
1471      * @param isBytes if the user is paying in bytes or eth
1472      */
1473     function mintWhitelist(uint256 quantity, bool isBytes, uint8 _v, bytes32 _r, bytes32 _s)
1474         external
1475         payable
1476         isContractState(ContractState.PRESALE)
1477         withinMintLimit(quantity)
1478         onlyValidAccess(_v,  _r, _s, 1)
1479     {
1480         require(_numberMinted(msg.sender) + quantity < whitelistMintAllowancePlusOne, "Maximum number of NFTs allowed to Mint reached!");
1481         if (isBytes) {
1482             BYTES.transferFrom(msg.sender, address(this), quantity * tokenPriceWhitelistBytes);
1483         }
1484         else {
1485             require(msg.value >= tokenPriceWhitelist * quantity, "Insufficient Funds!");
1486         }
1487         _safeMint(msg.sender, quantity);
1488     }
1489 
1490     /**
1491      * Mint tokens during the presale.
1492      * @notice This function is only available to those on the allowlist.
1493      * @param quantity The number of tokens to mint.
1494      */
1495     function mintPresale1(uint256 quantity, uint8 _v, bytes32 _r, bytes32 _s)
1496         external
1497         payable
1498         noBots
1499         isContractState(ContractState.PRESALE)
1500         withinMintLimit(quantity)
1501         onlyValidAccess(_v,  _r, _s, 2)
1502     {
1503         require(_numberMinted(msg.sender) + quantity < presale1MintAllowancePlusOne, "Maximum number of NFTs allowed to Mint reached!");
1504         _safeMint(msg.sender, quantity);
1505     }
1506 
1507     /**
1508      * Mint tokens during the presale.
1509      * @notice This function is only available to those on the allowlist.
1510      * @param quantity The number of tokens to mint.
1511      */
1512     function mintPresale2(uint256 quantity, uint8 _v, bytes32 _r, bytes32 _s)
1513         external
1514         payable
1515         noBots
1516         isContractState(ContractState.PRESALE)
1517         withinMintLimit(quantity)
1518         onlyValidAccess(_v,  _r, _s, 3)
1519     {
1520         require(_numberMinted(msg.sender) + quantity < presale2MintAllowancePlusOne, "Maximum number of NFTs allowed to Mint reached!");
1521         _safeMint(msg.sender, quantity);
1522     }
1523 
1524     /**
1525      * Team reserved mint.
1526      * @param to Address to mint to.
1527      * @param quantity Amount of tokens to mint.
1528      */
1529     function mintReserved(address to, uint256 quantity) external onlyOwner withinMintLimit(quantity) {
1530         _safeMint(to, quantity);
1531     }
1532 
1533     //
1534     // Admin
1535     //
1536 
1537     /**
1538      * Set contract state.
1539      * @param contractState_ The new state of the contract.
1540      */
1541     function setContractState(uint contractState_) external onlyOwner {
1542         require(contractState_ < 3, "Invalid Contract State!");
1543         if (contractState_ == 0) {
1544             contractState = ContractState.OFF;
1545         }
1546         else if (contractState_ == 1) {
1547             contractState = ContractState.PRESALE;
1548         }
1549         else {
1550             contractState = ContractState.PUBLIC;
1551         }
1552         
1553     }
1554 
1555     /**
1556      * Update maximum number of tokens for sale.
1557      * @param maxSale The maximum number of tokens available for sale.
1558      */
1559     function setMaxSale(uint256 maxSale) external onlyOwner {
1560         uint256 maxSalePlusOne_ = maxSale + 1;
1561         require(maxSalePlusOne_ < maxSalePlusOne, "Can only reduce supply");
1562         maxSalePlusOne = maxSalePlusOne_;
1563     }
1564 
1565     /**
1566      * Update the price for public sale
1567      * @param newPrice The updated price
1568      */
1569     function setTokenPricePublic(uint256 newPrice) external onlyOwner {
1570         tokenPricePublic = newPrice;
1571     }
1572 
1573     /**
1574      * Update the price for whitelist sale
1575      * @param newPrice The updated price
1576      */
1577     function setTokenPriceWhitelist(uint256 newPrice) external onlyOwner {
1578         tokenPriceWhitelist = newPrice;
1579     }
1580 
1581     /**
1582      * Update the price for public sale
1583      * @param newPrice The updated price
1584      */
1585     function setTokenPricePublicBytes(uint256 newPrice) external onlyOwner {
1586         tokenPricePublicBytes = newPrice;
1587     }
1588 
1589     /**
1590      * Update the price for whitelist sale
1591      * @param newPrice The updated price
1592      */
1593     function setTokenPriceWhitelistBytes(uint256 newPrice) external onlyOwner {
1594         tokenPriceWhitelistBytes = newPrice;
1595     }
1596 
1597     /**
1598      * Sets base URI.
1599      * @param baseURI_ The base URI
1600      */
1601     function setBaseURI(string memory baseURI_) external onlyOwner {
1602         baseURI = baseURI_;
1603     }
1604 
1605     /**
1606      * Sets placeholder URI.
1607      * @param placeholderURI_ The placeholder URI
1608      */
1609     function setPlaceholderURI(string memory placeholderURI_) external onlyOwner {
1610         placeholderURI = placeholderURI_;
1611     }
1612 
1613     /**
1614      * Update wallet that will recieve funds.
1615      * @param newRecipient The new address that will recieve funds
1616      */
1617     function setRecipient(address newRecipient) external onlyOwner {
1618         require(newRecipient != address(0), "Cannot be the 0 address!");
1619         recipient = newRecipient;
1620     }
1621 
1622     /**
1623      * Update bytes contract
1624      * @param newAddress The updated address
1625      */
1626     function setBytes(address newAddress) external onlyOwner {
1627         require(newAddress != address(0), "Cannot be the 0 address!");
1628         BYTES = IERC20(newAddress);
1629     }
1630 
1631 
1632     //retrieve all funds recieved from minting
1633     function withdraw() public onlyOwner {
1634         uint256 balance = accountBalance();
1635         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1636 
1637         _withdraw(payable(recipient), balance); 
1638     }
1639     
1640     //send the percentage of funds to a shareholder´s wallet
1641     function _withdraw(address payable account, uint256 amount) internal {
1642         (bool sent, ) = account.call{value: amount}("");
1643         require(sent, "Failed to send Ether");
1644     }
1645 
1646     //
1647     // Views
1648     //
1649 
1650     /**
1651      * The block.timestamp when this token was transferred to the current owner.
1652      * @param tokenId The token id to query
1653      */
1654     function ownedSince(uint256 tokenId) public view returns (uint256) {
1655         return _ownerships[tokenId].startTimestamp;
1656     }
1657 
1658     /**
1659      * @dev See {IERC721Metadata-tokenURI}.
1660      */
1661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1662         require(_exists(uint16(tokenId)), "URI query for nonexistent token");
1663 
1664         return
1665             bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : placeholderURI;
1666     }
1667 
1668     /**
1669      * Get the current amount of Eth stored
1670      */
1671     function accountBalance() public view returns(uint) {
1672         return address(this).balance;
1673     }
1674 
1675     /**
1676      * See how many mints an address has executed in one of the sales
1677      * @param minter the address of the person that
1678      */
1679     function getMintsPerAddress(address minter) public view returns(uint) {
1680         return _numberMinted(minter);
1681     }
1682 }