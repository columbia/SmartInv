1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // This method relies on extcodesize, which returns 0 for contracts in
274         // construction, since the code is only stored at the end of the
275         // constructor execution.
276 
277         uint256 size;
278         assembly {
279             size := extcodesize(account)
280         }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         (bool success, ) = recipient.call{value: amount}("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain `call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         require(isContract(target), "Address: static call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.delegatecall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
437      * revert reason using the provided one.
438      *
439      * _Available since v4.3._
440      */
441     function verifyCallResult(
442         bool success,
443         bytes memory returndata,
444         string memory errorMessage
445     ) internal pure returns (bytes memory) {
446         if (success) {
447             return returndata;
448         } else {
449             // Look for revert reason and bubble it up if present
450             if (returndata.length > 0) {
451                 // The easiest way to bubble the revert reason is using memory via assembly
452 
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @title ERC721 token receiver interface
473  * @dev Interface for any contract that wants to support safeTransfers
474  * from ERC721 asset contracts.
475  */
476 interface IERC721Receiver {
477     /**
478      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
479      * by `operator` from `from`, this function is called.
480      *
481      * It must return its Solidity selector to confirm the token transfer.
482      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
483      *
484      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
485      */
486     function onERC721Received(
487         address operator,
488         address from,
489         uint256 tokenId,
490         bytes calldata data
491     ) external returns (bytes4);
492 }
493 
494 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Interface of the ERC165 standard, as defined in the
503  * https://eips.ethereum.org/EIPS/eip-165[EIP].
504  *
505  * Implementers can declare support of contract interfaces, which can then be
506  * queried by others ({ERC165Checker}).
507  *
508  * For an implementation, see {ERC165}.
509  */
510 interface IERC165 {
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 }
521 
522 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Required interface of an ERC721 compliant contract.
563  */
564 interface IERC721 is IERC165 {
565     /**
566      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
567      */
568     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
572      */
573     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
577      */
578     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
579 
580     /**
581      * @dev Returns the number of tokens in ``owner``'s account.
582      */
583     function balanceOf(address owner) external view returns (uint256 balance);
584 
585     /**
586      * @dev Returns the owner of the `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function ownerOf(uint256 tokenId) external view returns (address owner);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
596      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must exist and be owned by `from`.
603      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
605      *
606      * Emits a {Transfer} event.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Transfers `tokenId` token from `from` to `to`.
616      *
617      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
636      * The approval is cleared when the token is transferred.
637      *
638      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
639      *
640      * Requirements:
641      *
642      * - The caller must own the token or be an approved operator.
643      * - `tokenId` must exist.
644      *
645      * Emits an {Approval} event.
646      */
647     function approve(address to, uint256 tokenId) external;
648 
649     /**
650      * @dev Returns the account approved for `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function getApproved(uint256 tokenId) external view returns (address operator);
657 
658     /**
659      * @dev Approve or remove `operator` as an operator for the caller.
660      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
661      *
662      * Requirements:
663      *
664      * - The `operator` cannot be the caller.
665      *
666      * Emits an {ApprovalForAll} event.
667      */
668     function setApprovalForAll(address operator, bool _approved) external;
669 
670     /**
671      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
672      *
673      * See {setApprovalForAll}
674      */
675     function isApprovedForAll(address owner, address operator) external view returns (bool);
676 
677     /**
678      * @dev Safely transfers `tokenId` token from `from` to `to`.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes calldata data
695     ) external;
696 }
697 
698 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Enumerable is IERC721 {
711     /**
712      * @dev Returns the total amount of tokens stored by the contract.
713      */
714     function totalSupply() external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
718      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
719      */
720     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
721 
722     /**
723      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
724      * Use along with {totalSupply} to enumerate all tokens.
725      */
726     function tokenByIndex(uint256 index) external view returns (uint256);
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Metadata is IERC721 {
742     /**
743      * @dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 
767 
768 
769 
770 
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata extension, but not including the Enumerable extension, which is available separately as
775  * {ERC721Enumerable}.
776  */
777 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
778     using Address for address;
779     using Strings for uint256;
780 
781     // Token name
782     string private _name;
783 
784     // Token symbol
785     string private _symbol;
786 
787     // Mapping from token ID to owner address
788     mapping(uint256 => address) private _owners;
789 
790     // Mapping owner address to token count
791     mapping(address => uint256) private _balances;
792 
793     // Mapping from token ID to approved address
794     mapping(uint256 => address) private _tokenApprovals;
795 
796     // Mapping from owner to operator approvals
797     mapping(address => mapping(address => bool)) private _operatorApprovals;
798 
799     /**
800      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
801      */
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805     }
806 
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
811         return
812             interfaceId == type(IERC721).interfaceId ||
813             interfaceId == type(IERC721Metadata).interfaceId ||
814             super.supportsInterface(interfaceId);
815     }
816 
817     /**
818      * @dev See {IERC721-balanceOf}.
819      */
820     function balanceOf(address owner) public view virtual override returns (uint256) {
821         require(owner != address(0), "ERC721: balance query for the zero address");
822         return _balances[owner];
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
829         address owner = _owners[tokenId];
830         require(owner != address(0), "ERC721: owner query for nonexistent token");
831         return owner;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-name}.
836      */
837     function name() public view virtual override returns (string memory) {
838         return _name;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-symbol}.
843      */
844     function symbol() public view virtual override returns (string memory) {
845         return _symbol;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-tokenURI}.
850      */
851     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
852         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
853 
854         string memory baseURI = _baseURI();
855         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overriden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return "";
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public virtual override {
871         address owner = ERC721.ownerOf(tokenId);
872         require(to != owner, "ERC721: approval to current owner");
873 
874         require(
875             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
876             "ERC721: approve caller is not owner nor approved for all"
877         );
878 
879         _approve(to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-getApproved}.
884      */
885     function getApproved(uint256 tokenId) public view virtual override returns (address) {
886         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
887 
888         return _tokenApprovals[tokenId];
889     }
890 
891     /**
892      * @dev See {IERC721-setApprovalForAll}.
893      */
894     function setApprovalForAll(address operator, bool approved) public virtual override {
895         _setApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
902         return _operatorApprovals[owner][operator];
903     }
904 
905     /**
906      * @dev See {IERC721-transferFrom}.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         //solhint-disable-next-line max-line-length
914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
915 
916         _transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public virtual override {
927         safeTransferFrom(from, to, tokenId, "");
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940         _safeTransfer(from, to, tokenId, _data);
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
945      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
946      *
947      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
948      *
949      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
950      * implement alternative mechanisms to perform token transfer, such as signature-based.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeTransfer(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) internal virtual {
967         _transfer(from, to, tokenId);
968         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      * and stop existing when they are burned (`_burn`).
978      */
979     function _exists(uint256 tokenId) internal view virtual returns (bool) {
980         return _owners[tokenId] != address(0);
981     }
982 
983     /**
984      * @dev Returns whether `spender` is allowed to manage `tokenId`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
991         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
992         address owner = ERC721.ownerOf(tokenId);
993         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Destroys `tokenId`.
1052      * The approval is cleared when the token is burned.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _burn(uint256 tokenId) internal virtual {
1061         address owner = ERC721.ownerOf(tokenId);
1062 
1063         _beforeTokenTransfer(owner, address(0), tokenId);
1064 
1065         // Clear approvals
1066         _approve(address(0), tokenId);
1067 
1068         _balances[owner] -= 1;
1069         delete _owners[tokenId];
1070 
1071         emit Transfer(owner, address(0), tokenId);
1072     }
1073 
1074     /**
1075      * @dev Transfers `tokenId` from `from` to `to`.
1076      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must be owned by `from`.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual {
1090         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1091         require(to != address(0), "ERC721: transfer to the zero address");
1092 
1093         _beforeTokenTransfer(from, to, tokenId);
1094 
1095         // Clear approvals from the previous owner
1096         _approve(address(0), tokenId);
1097 
1098         _balances[from] -= 1;
1099         _balances[to] += 1;
1100         _owners[tokenId] = to;
1101 
1102         emit Transfer(from, to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Approve `to` to operate on `tokenId`
1107      *
1108      * Emits a {Approval} event.
1109      */
1110     function _approve(address to, uint256 tokenId) internal virtual {
1111         _tokenApprovals[tokenId] = to;
1112         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev Approve `operator` to operate on all of `owner` tokens
1117      *
1118      * Emits a {ApprovalForAll} event.
1119      */
1120     function _setApprovalForAll(
1121         address owner,
1122         address operator,
1123         bool approved
1124     ) internal virtual {
1125         require(owner != operator, "ERC721: approve to caller");
1126         _operatorApprovals[owner][operator] = approved;
1127         emit ApprovalForAll(owner, operator, approved);
1128     }
1129 
1130     /**
1131      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1132      * The call is not executed if the target address is not a contract.
1133      *
1134      * @param from address representing the previous owner of the given token ID
1135      * @param to target address that will receive the tokens
1136      * @param tokenId uint256 ID of the token to be transferred
1137      * @param _data bytes optional data to send along with the call
1138      * @return bool whether the call correctly returned the expected magic value
1139      */
1140     function _checkOnERC721Received(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes memory _data
1145     ) private returns (bool) {
1146         if (to.isContract()) {
1147             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1148                 return retval == IERC721Receiver.onERC721Received.selector;
1149             } catch (bytes memory reason) {
1150                 if (reason.length == 0) {
1151                     revert("ERC721: transfer to non ERC721Receiver implementer");
1152                 } else {
1153                     assembly {
1154                         revert(add(32, reason), mload(reason))
1155                     }
1156                 }
1157             }
1158         } else {
1159             return true;
1160         }
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
1173      * - `from` and `to` are never both zero.
1174      *
1175      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1176      */
1177     function _beforeTokenTransfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) internal virtual {}
1182 }
1183 
1184 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1185 
1186 
1187 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 
1192 
1193 /**
1194  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1195  * enumerability of all the token ids in the contract as well as all token ids owned by each
1196  * account.
1197  */
1198 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1199     // Mapping from owner to list of owned token IDs
1200     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1201 
1202     // Mapping from token ID to index of the owner tokens list
1203     mapping(uint256 => uint256) private _ownedTokensIndex;
1204 
1205     // Array with all token ids, used for enumeration
1206     uint256[] private _allTokens;
1207 
1208     // Mapping from token id to position in the allTokens array
1209     mapping(uint256 => uint256) private _allTokensIndex;
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1215         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1220      */
1221     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1222         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1223         return _ownedTokens[owner][index];
1224     }
1225 
1226     /**
1227      * @dev See {IERC721Enumerable-totalSupply}.
1228      */
1229     function totalSupply() public view virtual override returns (uint256) {
1230         return _allTokens.length;
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Enumerable-tokenByIndex}.
1235      */
1236     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1237         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1238         return _allTokens[index];
1239     }
1240 
1241     /**
1242      * @dev Hook that is called before any token transfer. This includes minting
1243      * and burning.
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1251      * - `from` cannot be the zero address.
1252      * - `to` cannot be the zero address.
1253      *
1254      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1255      */
1256     function _beforeTokenTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual override {
1261         super._beforeTokenTransfer(from, to, tokenId);
1262 
1263         if (from == address(0)) {
1264             _addTokenToAllTokensEnumeration(tokenId);
1265         } else if (from != to) {
1266             _removeTokenFromOwnerEnumeration(from, tokenId);
1267         }
1268         if (to == address(0)) {
1269             _removeTokenFromAllTokensEnumeration(tokenId);
1270         } else if (to != from) {
1271             _addTokenToOwnerEnumeration(to, tokenId);
1272         }
1273     }
1274 
1275     /**
1276      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1277      * @param to address representing the new owner of the given token ID
1278      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1279      */
1280     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1281         uint256 length = ERC721.balanceOf(to);
1282         _ownedTokens[to][length] = tokenId;
1283         _ownedTokensIndex[tokenId] = length;
1284     }
1285 
1286     /**
1287      * @dev Private function to add a token to this extension's token tracking data structures.
1288      * @param tokenId uint256 ID of the token to be added to the tokens list
1289      */
1290     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1291         _allTokensIndex[tokenId] = _allTokens.length;
1292         _allTokens.push(tokenId);
1293     }
1294 
1295     /**
1296      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1297      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1298      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1299      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1300      * @param from address representing the previous owner of the given token ID
1301      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1302      */
1303     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1304         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1305         // then delete the last slot (swap and pop).
1306 
1307         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1308         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1309 
1310         // When the token to delete is the last token, the swap operation is unnecessary
1311         if (tokenIndex != lastTokenIndex) {
1312             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1313 
1314             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1315             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1316         }
1317 
1318         // This also deletes the contents at the last position of the array
1319         delete _ownedTokensIndex[tokenId];
1320         delete _ownedTokens[from][lastTokenIndex];
1321     }
1322 
1323     /**
1324      * @dev Private function to remove a token from this extension's token tracking data structures.
1325      * This has O(1) time complexity, but alters the order of the _allTokens array.
1326      * @param tokenId uint256 ID of the token to be removed from the tokens list
1327      */
1328     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1329         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1330         // then delete the last slot (swap and pop).
1331 
1332         uint256 lastTokenIndex = _allTokens.length - 1;
1333         uint256 tokenIndex = _allTokensIndex[tokenId];
1334 
1335         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1336         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1337         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1338         uint256 lastTokenId = _allTokens[lastTokenIndex];
1339 
1340         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1341         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1342 
1343         // This also deletes the contents at the last position of the array
1344         delete _allTokensIndex[tokenId];
1345         _allTokens.pop();
1346     }
1347 }
1348 
1349 // File: contracts/GuardianKongz.sol
1350 
1351 
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 
1356 
1357 
1358 /*                                                                                                       
1359   $$$$$$\                                      $$\ $$\                     
1360  $$  __$$\                                     $$ |\__|                    
1361  $$ /  \__|$$\   $$\  $$$$$$\   $$$$$$\   $$$$$$$ |$$\  $$$$$$\  $$$$$$$\  
1362  $$ |$$$$\ $$ |  $$ | \____$$\ $$  __$$\ $$  __$$ |$$ | \____$$\ $$  __$$\ 
1363  $$ |\_$$ |$$ |  $$ | $$$$$$$ |$$ |  \__|$$ /  $$ |$$ | $$$$$$$ |$$ |  $$ |
1364  $$ |  $$ |$$ |  $$ |$$  __$$ |$$ |      $$ |  $$ |$$ |$$  __$$ |$$ |  $$ |
1365  \$$$$$$  |\$$$$$$  |\$$$$$$$ |$$ |      \$$$$$$$ |$$ |\$$$$$$$ |$$ |  $$ |
1366  \______/  \______/  \_______|\__|       \_______|\__| \_______|\__|  \__|
1367                                                                           
1368            $$\   $$\                                        
1369            $$ | $$  |                                       
1370            $$ |$$  / $$$$$$\  $$$$$$$\   $$$$$$\  $$$$$$$$\ 
1371             $$$$$  / $$  __$$\ $$  __$$\ $$  __$$\ \____$$  |
1372            $$  $$<  $$ /  $$ |$$ |  $$ |$$ /  $$ |  $$$$ _/ 
1373            $$ |\$$\ $$ |  $$ |$$ |  $$ |$$ |  $$ | $$  _/   
1374            $$ | \$$\\$$$$$$  |$$ |  $$ |\$$$$$$$ |$$$$$$$$\ 
1375            \__|  \__|\______/ \__|  \__| \____$$ |\________|
1376                                            $$\   $$ |          
1377                                            \$$$$$$  |          
1378                                             \______/                                                                     
1379 */                                                                                                                                                                                                                   
1380 
1381 contract GuardianKongz is ERC721Enumerable, ReentrancyGuard, Ownable {
1382     using Strings for uint256;
1383     
1384     string public baseURI;
1385     string public baseExtension = ".json";
1386 
1387     bool public presaleMintIsActive = false;
1388     bool public mintIsActive = false;
1389 
1390     uint256 public maxSupply = 5000;
1391     uint256 public maxMintAmount = 2;
1392     uint256 public mintPrice = 80000000000000000; // 0.08 ETH
1393     uint256 public presaleMintPrice = 60000000000000000; // 0.06 ETH
1394 
1395     address public signatureAddress;
1396 
1397     // constructor
1398     constructor(
1399     string memory _name,
1400     string memory _symbol,
1401     string memory _initBaseURI
1402     ) ERC721(_name, _symbol) {
1403         setBaseURI(_initBaseURI);
1404     }
1405 
1406     // internal
1407     function _baseURI() internal view virtual override returns (string memory) {
1408         return baseURI;
1409     }
1410 
1411     // public
1412     function walletOfOwner(address _owner)
1413         public
1414         view
1415         returns (uint256[] memory)
1416     {
1417         uint256 ownerTokenCount = balanceOf(_owner);
1418         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1419         for (uint256 i; i < ownerTokenCount; i++) {
1420         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1421         }
1422         return tokenIds;
1423     }
1424 
1425     function tokenURI(uint256 tokenId)
1426         public
1427         view
1428         virtual
1429         override
1430         returns (string memory)
1431     {
1432         require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1433         string memory currentBaseURI = _baseURI();
1434         return bytes(currentBaseURI).length > 0
1435             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1436             : "";
1437     }
1438 
1439     function setMintCost(uint256 _newPrice) public onlyOwner() {
1440         mintPrice = _newPrice;
1441     }
1442 
1443      function setPresaleMintCost(uint256 _newPrice) public onlyOwner() {
1444         presaleMintPrice = _newPrice;
1445     }
1446 
1447     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1448         maxMintAmount = _newmaxMintAmount;
1449     }
1450 
1451     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1452         baseURI = _newBaseURI;
1453     }
1454 
1455     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1456         baseExtension = _newBaseExtension;
1457     }
1458 
1459     function setSignatureAddress(address _importantAddress) public onlyOwner {
1460         signatureAddress = _importantAddress;
1461     }
1462 
1463     function flipMintState() public onlyOwner {
1464         mintIsActive = !mintIsActive;
1465     }
1466 
1467     function flipPresaleMintState() public onlyOwner {
1468         presaleMintIsActive = !presaleMintIsActive;
1469     }
1470 
1471     function withdraw() public onlyOwner {
1472         uint balance = address(this).balance;
1473         payable(_msgSender()).transfer(balance);
1474     }
1475 
1476     // mint
1477     function devMint(uint256 numberOfTokens) public onlyOwner {
1478         require(totalSupply() + numberOfTokens <= maxSupply, "Purchase would exceed max supply.");
1479         
1480         for (uint i = 0; i < numberOfTokens; i++) {
1481             _safeMint(_msgSender(), totalSupply() + 1);
1482         }
1483     }
1484 
1485     function mint(uint256 numberOfTokens) public payable nonReentrant  {
1486         require(mintIsActive, "Public mint is not active at the moment. Be patient.");
1487         require(numberOfTokens > 0, "Number of tokens can not be less than or equal to 0.");
1488         require(totalSupply() + numberOfTokens <= maxSupply, "Purchase would exceed max supply.");
1489         require(numberOfTokens <= 10, "Can only mint up to 10 per transaction.");
1490         require(mintPrice * numberOfTokens == msg.value, "Sent ETH value is incorrect.");
1491 
1492         for (uint i = 0; i < numberOfTokens; i++) {
1493             _safeMint(_msgSender(), totalSupply() + 1);
1494         }
1495     }
1496 
1497     function presaleMint(bytes memory sig, uint256 numberOfTokens) public payable nonReentrant  {
1498         require(presaleMintIsActive, "Presale mint is not active at the moment. Be patient.");
1499         require(numberOfTokens > 0, "Number of tokens can not be less than or equal to 0.");
1500         require(totalSupply() + numberOfTokens <= maxSupply, "Purchase would exceed max supply.");
1501         require(numberOfTokens <= maxMintAmount, "Can only mint up to 2 per transaction.");
1502         require(presaleMintPrice * numberOfTokens == msg.value, "Sent ETH value is incorrect.");
1503         require(balanceOf(msg.sender) + numberOfTokens <= maxMintAmount, "Can only mint up to 2 per wallet.");
1504         require(isValidData(msg.sender, sig), "You are not whitelisted");
1505 
1506         for (uint i = 0; i < numberOfTokens; i++) {
1507             _safeMint(_msgSender(), totalSupply() + 1);
1508         }
1509     }
1510 
1511     //verify signature
1512     function isValidData(address _walletAddress, bytes memory sig) public view returns(bool){
1513         bytes32 message = keccak256(abi.encodePacked(_walletAddress));
1514         return (recoverSigner(message, sig) == signatureAddress);
1515     }
1516 
1517     function recoverSigner(bytes32 message, bytes memory sig)
1518        public
1519        pure
1520        returns (address)
1521     {
1522        uint8 v;
1523        bytes32 r;
1524        bytes32 s;
1525        (v, r, s) = splitSignature(sig);
1526        return ecrecover(message, v, r, s);
1527    }
1528 
1529     function splitSignature(bytes memory sig)
1530        public
1531        pure
1532        returns (uint8, bytes32, bytes32)
1533     {
1534        require(sig.length == 65);
1535        bytes32 r;
1536        bytes32 s;
1537        uint8 v;
1538        assembly {
1539            // first 32 bytes, after the length prefix
1540            r := mload(add(sig, 32))
1541            // second 32 bytes
1542            s := mload(add(sig, 64))
1543            // final byte (first byte of the next 32 bytes)
1544            v := byte(0, mload(add(sig, 96)))
1545        }
1546        return (v, r, s);
1547    }
1548 }