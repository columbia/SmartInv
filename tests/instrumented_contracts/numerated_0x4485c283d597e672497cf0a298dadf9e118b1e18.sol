1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-20
3 */
4 
5 //      OOOOOOOOO     RRRRRRRRRRRRRRRRR   IIIIIIIIII      GGGGGGGGGGGGG     OOOOOOOOO     
6 //    OO:::::::::OO   R::::::::::::::::R  I::::::::I   GGG::::::::::::G   OO:::::::::OO   
7 //  OO:::::::::::::OO R::::::RRRRRR:::::R I::::::::I GG:::::::::::::::G OO:::::::::::::OO 
8 // O:::::::OOO:::::::ORR:::::R     R:::::RII::::::IIG:::::GGGGGGGG::::GO:::::::OOO:::::::O
9 // O::::::O   O::::::O  R::::R     R:::::R  I::::I G:::::G       GGGGGGO::::::O   O::::::O
10 // O:::::O     O:::::O  R::::R     R:::::R  I::::IG:::::G              O:::::O     O:::::O
11 // O:::::O     O:::::O  R::::RRRRRR:::::R   I::::IG:::::G              O:::::O     O:::::O
12 // O:::::O     O:::::O  R:::::::::::::RR    I::::IG:::::G    GGGGGGGGGGO:::::O     O:::::O
13 // O:::::O     O:::::O  R::::RRRRRR:::::R   I::::IG:::::G    G::::::::GO:::::O     O:::::O
14 // O:::::O     O:::::O  R::::R     R:::::R  I::::IG:::::G    GGGGG::::GO:::::O     O:::::O
15 // O:::::O     O:::::O  R::::R     R:::::R  I::::IG:::::G        G::::GO:::::O     O:::::O
16 // O::::::O   O::::::O  R::::R     R:::::R  I::::I G:::::G       G::::GO::::::O   O::::::O
17 // O:::::::OOO:::::::ORR:::::R     R:::::RII::::::IIG:::::GGGGGGGG::::GO:::::::OOO:::::::O
18 //  OO:::::::::::::OO R::::::R     R:::::RI::::::::I GG:::::::::::::::G OO:::::::::::::OO 
19 //    OO:::::::::OO   R::::::R     R:::::RI::::::::I   GGG::::::GGG:::G   OO:::::::::OO   
20 //      OOOOOOOOO     RRRRRRRR     RRRRRRRIIIIIIIIII      GGGGGG   GGGG     OOOOOOOOO  
21 
22 
23 // SPDX-License-Identifier: MIT
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 
91 // File: Context.sol
92 
93 
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 
118 // File: Ownable.sol
119 
120 
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _setOwner(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _setOwner(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _setOwner(newOwner);
182     }
183 
184     function _setOwner(address newOwner) private {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 
192 // File: Address.sol
193 
194 
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize, which returns 0 for contracts in
221         // construction, since the code is only stored at the end of the
222         // constructor execution.
223 
224         uint256 size;
225         assembly {
226             size := extcodesize(account)
227         }
228         return size > 0;
229     }
230 
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     /**
255      * @dev Performs a Solidity function call using a low level `call`. A
256      * plain `call` is an unsafe replacement for a function call: use this
257      * function instead.
258      *
259      * If `target` reverts with a revert reason, it is bubbled up by this
260      * function (like regular Solidity function calls).
261      *
262      * Returns the raw returned data. To convert to the expected return value,
263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
264      *
265      * Requirements:
266      *
267      * - `target` must be a contract.
268      * - calling `target` with `data` must not revert.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
311      * with `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(address(this).balance >= value, "Address: insufficient balance for call");
322         require(isContract(target), "Address: call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.call{value: value}(data);
325         return _verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return _verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return _verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     function _verifyCallResult(
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) private pure returns (bytes memory) {
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Contract module that helps prevent reentrant calls to a function.
411  *
412  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
413  * available, which can be applied to functions to make sure there are no nested
414  * (reentrant) calls to them.
415  *
416  * Note that because there is a single `nonReentrant` guard, functions marked as
417  * `nonReentrant` may not call one another. This can be worked around by making
418  * those functions `private`, and then adding `external` `nonReentrant` entry
419  * points to them.
420  *
421  * TIP: If you would like to learn more about reentrancy and alternative ways
422  * to protect against it, check out our blog post
423  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
424  */
425 abstract contract ReentrancyGuard {
426     // Booleans are more expensive than uint256 or any type that takes up a full
427     // word because each write operation emits an extra SLOAD to first read the
428     // slot's contents, replace the bits taken up by the boolean, and then write
429     // back. This is the compiler's defense against contract upgrades and
430     // pointer aliasing, and it cannot be disabled.
431 
432     // The values being non-zero value makes deployment a bit more expensive,
433     // but in exchange the refund on every call to nonReentrant will be lower in
434     // amount. Since refunds are capped to a percentage of the total
435     // transaction's gas, it is best to keep them low in cases like this one, to
436     // increase the likelihood of the full refund coming into effect.
437     uint256 private constant _NOT_ENTERED = 1;
438     uint256 private constant _ENTERED = 2;
439 
440     uint256 private _status;
441 
442     constructor() {
443         _status = _NOT_ENTERED;
444     }
445 
446     /**
447      * @dev Prevents a contract from calling itself, directly or indirectly.
448      * Calling a `nonReentrant` function from another `nonReentrant`
449      * function is not supported. It is possible to prevent this from happening
450      * by making the `nonReentrant` function external, and making it call a
451      * `private` function that does the actual work.
452      */
453     modifier nonReentrant() {
454         // On the first call to nonReentrant, _notEntered will be true
455         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
456 
457         // Any calls to nonReentrant after this point will fail
458         _status = _ENTERED;
459 
460         _;
461 
462         // By storing the original value once again, a refund is triggered (see
463         // https://eips.ethereum.org/EIPS/eip-2200)
464         _status = _NOT_ENTERED;
465     }
466 }
467 
468 
469 // File: IERC721Receiver.sol
470 
471 
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @title ERC721 token receiver interface
477  * @dev Interface for any contract that wants to support safeTransfers
478  * from ERC721 asset contracts.
479  */
480 interface IERC721Receiver {
481     /**
482      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
483      * by `operator` from `from`, this function is called.
484      *
485      * It must return its Solidity selector to confirm the token transfer.
486      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
487      *
488      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
489      */
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 
499 // File: IERC165.sol
500 
501 
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Interface of the ERC165 standard, as defined in the
507  * https://eips.ethereum.org/EIPS/eip-165[EIP].
508  *
509  * Implementers can declare support of contract interfaces, which can then be
510  * queried by others ({ERC165Checker}).
511  *
512  * For an implementation, see {ERC165}.
513  */
514 interface IERC165 {
515     /**
516      * @dev Returns true if this contract implements the interface defined by
517      * `interfaceId`. See the corresponding
518      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
519      * to learn more about how these ids are created.
520      *
521      * This function call must use less than 30 000 gas.
522      */
523     function supportsInterface(bytes4 interfaceId) external view returns (bool);
524 }
525 
526 
527 // File: ERC165.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 
558 // File: IERC721.sol
559 
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Required interface of an ERC721 compliant contract.
567  */
568 interface IERC721 is IERC165 {
569     /**
570      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
571      */
572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
576      */
577     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
581      */
582     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
583 
584     /**
585      * @dev Returns the number of tokens in ``owner``'s account.
586      */
587     function balanceOf(address owner) external view returns (uint256 balance);
588 
589     /**
590      * @dev Returns the owner of the `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function ownerOf(uint256 tokenId) external view returns (address owner);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
600      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Transfers `tokenId` token from `from` to `to`.
620      *
621      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must be owned by `from`.
628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
640      * The approval is cleared when the token is transferred.
641      *
642      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
643      *
644      * Requirements:
645      *
646      * - The caller must own the token or be an approved operator.
647      * - `tokenId` must exist.
648      *
649      * Emits an {Approval} event.
650      */
651     function approve(address to, uint256 tokenId) external;
652 
653     /**
654      * @dev Returns the account approved for `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function getApproved(uint256 tokenId) external view returns (address operator);
661 
662     /**
663      * @dev Approve or remove `operator` as an operator for the caller.
664      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
665      *
666      * Requirements:
667      *
668      * - The `operator` cannot be the caller.
669      *
670      * Emits an {ApprovalForAll} event.
671      */
672     function setApprovalForAll(address operator, bool _approved) external;
673 
674     /**
675      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
676      *
677      * See {setApprovalForAll}
678      */
679     function isApprovedForAll(address owner, address operator) external view returns (bool);
680 
681     /**
682      * @dev Safely transfers `tokenId` token from `from` to `to`.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must exist and be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes calldata data
699     ) external;
700 }
701 
702 
703 
704 // File: IERC721Metadata.sol
705 
706 
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Metadata is IERC721 {
716     /**
717      * @dev Returns the token collection name.
718      */
719     function name() external view returns (string memory);
720 
721     /**
722      * @dev Returns the token collection symbol.
723      */
724     function symbol() external view returns (string memory);
725 
726     /**
727      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
728      */
729     function tokenURI(uint256 tokenId) external view returns (string memory);
730 }
731 
732 
733 // ERC721A Contracts v3.3.0
734 // Creator: Chiru Labs
735 
736 pragma solidity ^0.8.4;
737 
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
744  *
745  * Assumes that an owner cannot have more than 2**128 - 1 (max value of uint128) of supply.
746  *
747  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
748  */
749 
750 error ApprovalCallerNotOwnerNorApproved();
751 error ApprovalQueryForNonexistentToken();
752 error ApproveToCaller();
753 error ApprovalToCurrentOwner();
754 error BalanceQueryForZeroAddress();
755 error MintedQueryForZeroAddress();
756 error MintToZeroAddress();
757 error MintZeroQuantity();
758 error OwnerQueryForNonexistentToken();
759 error TransferCallerNotOwnerNorApproved();
760 error TransferFromIncorrectOwner();
761 error TransferToNonERC721ReceiverImplementer();
762 error TransferToNonERC721ReceiverImplementerFunction();
763 error MintToNonERC721ReceiverImplementer();
764 error TransferToZeroAddress();
765 error URIQueryForNonexistentToken();
766 
767 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, ReentrancyGuard {
768     using Address for address;
769     using Strings for uint256;
770 
771     struct TokenOwnership {
772         address addr;
773         uint64 startTimestamp;
774     }
775 
776     // Compiler will pack this into a single 256bit word.
777     struct AddressData {
778         // Realistically, 2**64-1 is more than enough.
779         uint128 balance;
780         // Keeps track of mint count with minimal overhead for tokenomics.
781         uint128 numberMinted;
782     }
783 
784     // The tokenId of the next token to be minted.
785     uint256 internal _currentIndex = 0;
786 
787     // address to tribulate to
788     address public tribulationWallet;
789 
790     // Token name
791     string private _name;
792 
793     // Token symbol
794     string private _symbol;
795 
796     // Mapping from token ID to ownership details
797     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
798     mapping(uint256 => TokenOwnership) internal _ownerships;
799 
800     // Mapping owner address to address data
801     mapping(address => AddressData) private _addressData;
802 
803     // Mapping from token ID to approved address
804     mapping(uint256 => address) private _tokenApprovals;
805 
806     // Mapping from owner to operator approvals
807     mapping(address => mapping(address => bool)) private _operatorApprovals;
808 
809     constructor(string memory name_, string memory symbol_) {
810         _name = name_;
811         _symbol = symbol_;
812     }
813 
814     /**
815      * @dev Returns _currentIndex.
816      */
817     function totalSupply() public view returns (uint256) {
818         return _currentIndex;
819     }
820 
821     /**
822      * @dev See {IERC165-supportsInterface}.
823      */
824     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
825         return
826             interfaceId == type(IERC721).interfaceId ||
827             interfaceId == type(IERC721Metadata).interfaceId ||
828             super.supportsInterface(interfaceId);
829     }
830 
831     /**
832      * @dev See {IERC721-balanceOf}.
833      */
834     function balanceOf(address owner) public view override returns (uint256) {
835         if (owner == address(0)) revert BalanceQueryForZeroAddress();
836         return uint256(_addressData[owner].balance);
837     }
838 
839     /**
840      * Returns the number of tokens minted by `owner`.
841      */
842     function _numberMinted(address owner) internal view returns (uint256) {
843         if (owner == address(0)) revert MintedQueryForZeroAddress();
844         return uint256(_addressData[owner].numberMinted);
845     }
846 
847     /**
848      * Gas spent here starts off proportional to the maximum mint batch size.
849      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
850      */
851     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
852         uint256 curr = tokenId;
853 
854         unchecked {
855             if (0 <= curr && curr < _currentIndex) {
856                 TokenOwnership memory ownership = _ownerships[curr];
857                 if (ownership.addr != address(0)) {
858                     return ownership;
859                 }
860                 // Invariant:
861                 // There will always be an ownership that has an address and is not burned
862                 // before an ownership that does not have an address and is not burned.
863                 // Hence, curr will not underflow.
864                 while (true) {
865                     curr--;
866                     ownership = _ownerships[curr];
867                     if (ownership.addr != address(0)) {
868                         return ownership;
869                     }
870                 }
871             }
872         }
873         revert OwnerQueryForNonexistentToken();
874     }
875 
876     /**
877      * @dev See {IERC721-ownerOf}.
878      */
879     function ownerOf(uint256 tokenId) public view override returns (address) {
880         return _ownershipOf(tokenId).addr;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-name}.
885      */
886     function name() public view virtual override returns (string memory) {
887         return _name;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-symbol}.
892      */
893     function symbol() public view virtual override returns (string memory) {
894         return _symbol;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-tokenURI}.
899      */
900     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
901         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
902 
903         string memory baseURI = _baseURI();
904         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
905     }
906 
907     /**
908      * @dev Base URI for {tokenURI}. Empty
909      * by default, can be overriden in child contracts.
910      */
911     function _baseURI() internal view virtual returns (string memory) {
912         return '';
913     }
914 
915     /**
916      * @dev See {IERC721-approve}.
917      */
918     function approve(address to, uint256 tokenId) public override {
919         address owner = ERC721A.ownerOf(tokenId);
920         if (to == owner) revert ApprovalToCurrentOwner();
921 
922         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
923             revert ApprovalCallerNotOwnerNorApproved();
924         }
925 
926         _approve(to, tokenId, owner);
927     }
928 
929     /**
930      * @dev See {IERC721-getApproved}.
931      */
932     function getApproved(uint256 tokenId) public view override returns (address) {
933         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
934 
935         return _tokenApprovals[tokenId];
936     }
937 
938     /**
939      * @dev See {IERC721-setApprovalForAll}.
940      */
941     function setApprovalForAll(address operator, bool approved) public override {
942         if (operator == _msgSender()) revert ApproveToCaller();
943 
944         _operatorApprovals[_msgSender()][operator] = approved;
945         emit ApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public override {
963         _transfer(from, to, tokenId);
964     }
965 
966     /**
967      * @dev See {IERC721-safeTransferFrom}.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public override {
974         safeTransferFrom(from, to, tokenId, '');
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) public override {
986         _transfer(from, to, tokenId);
987         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
988             revert TransferToNonERC721ReceiverImplementer();
989         }
990     }
991 
992     /**
993      * @dev Returns whether `tokenId` exists.
994      *
995      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
996      *
997      * Tokens start existing when they are minted (`_mint`),
998      */
999     function _exists(uint256 tokenId) internal view returns (bool) {
1000         return tokenId < _currentIndex;
1001     }
1002 
1003     /**
1004      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1005      */
1006     function _safeMint(address to, uint256 quantity) internal {
1007         _safeMint(to, quantity, '');
1008     }
1009 
1010     /**
1011      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - If `to` refers to a smart contract, it must implement
1016      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _safeMint(
1022         address to,
1023         uint256 quantity,
1024         bytes memory _data
1025     ) internal {
1026         if (to == address(0)) revert MintToZeroAddress();
1027         if (quantity == 0) revert MintZeroQuantity();
1028         uint256 startTokenId = _currentIndex;
1029 
1030         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1031 
1032         // Overflows are incredibly unrealistic
1033         // balance or numberMinted overflow if current value of either + quantity > (2**128) - 1
1034         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1035         unchecked {
1036             _addressData[to].balance += uint128(quantity);
1037             _addressData[to].numberMinted += uint128(quantity);
1038 
1039             _ownerships[startTokenId].addr = to;
1040             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1041 
1042             uint256 updatedIndex = startTokenId;
1043 
1044             for (uint256 i = 0; i < quantity; i++) {
1045                 emit Transfer(address(0), to, updatedIndex);
1046                 if (!_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1047                     revert MintToNonERC721ReceiverImplementer();
1048                 }
1049                 updatedIndex++;
1050             }
1051             
1052             _currentIndex = updatedIndex;
1053         } // unchecked
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Transfers `tokenId` from `from` to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _transfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) private nonReentrant {
1072         if (to == address(0)) revert TransferToZeroAddress();
1073 
1074         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1075         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1076 
1077         bool isApprovedOrOwner = (_msgSender() == from ||
1078             isApprovedForAll(from, _msgSender()) ||
1079             getApproved(tokenId) == _msgSender());
1080 
1081         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1082 
1083         _beforeTokenTransfers(from, to, tokenId, 1);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId, from);
1087 
1088         // Underflow of the sender's balance is impossible because we check for
1089         // ownership above and the recipient's balance can't realistically overflow.
1090         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1091         //      Me: meh, I'm not convinced the underflow is safe from re-entrancy attacks 
1092         // (comes down to a race condition); to still save gas I modified this 
1093         // to be nonReentrant to be safe
1094         unchecked {
1095             _addressData[from].balance -= 1;
1096             _addressData[to].balance += 1;
1097 
1098             _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1099 
1100             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1101             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1102             uint256 nextTokenId = tokenId + 1;
1103             if (_ownerships[nextTokenId].addr == address(0)) {
1104                 if (_exists(nextTokenId)) {
1105                     _ownerships[nextTokenId] = TokenOwnership(
1106                         prevOwnership.addr,
1107                         prevOwnership.startTimestamp
1108                     );
1109                 }
1110             }
1111         } // unchecked
1112 
1113         emit Transfer(from, to, tokenId);
1114         _afterTokenTransfers(from, to, tokenId, 1);
1115     }
1116 
1117     function setTribulationWallet(address _tribulationWallet) public virtual {
1118         tribulationWallet = _tribulationWallet;
1119     }
1120 
1121     /**
1122      * @dev Approve `to` to operate on `tokenId`
1123      *
1124      * Emits a {Approval} event.
1125      */
1126     function _approve(
1127         address to,
1128         uint256 tokenId,
1129         address owner
1130     ) private {
1131         _tokenApprovals[tokenId] = to;
1132         emit Approval(owner, to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1137      *
1138      * @param from address representing the previous owner of the given token ID
1139      * @param to target address that will receive the tokens
1140      * @param tokenId uint256 ID of the token to be transferred
1141      * @param _data bytes optional data to send along with the call
1142      * @return bool whether the call correctly returned the expected magic value
1143      */
1144     function _checkOnERC721Received(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) private returns (bool) {
1150         if (to.isContract()) {
1151             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1152                 return retval == IERC721Receiver(to).onERC721Received.selector;
1153             } catch (bytes memory reason) {
1154                 if (reason.length == 0) {
1155                     revert TransferToNonERC721ReceiverImplementerFunction();
1156                 } else {
1157                     assembly {
1158                         revert(add(32, reason), mload(reason))
1159                     }
1160                 }
1161             }
1162         } else {
1163             return true;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1169      * And also called before burning one token.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, `tokenId` will be burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _beforeTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1191      * minting.
1192      * And also called after one token has been burned.
1193      *
1194      * startTokenId - the first token id to be transferred
1195      * quantity - the amount to be transferred
1196      *
1197      * Calling conditions:
1198      *
1199      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1200      * transferred to `to`.
1201      * - When `from` is zero, `tokenId` has been minted for `to`.
1202      * - When `to` is zero, `tokenId` has been burned by `from`.
1203      * - `from` and `to` are never both zero.
1204      */
1205     function _afterTokenTransfers(
1206         address from,
1207         address to,
1208         uint256 startTokenId,
1209         uint256 quantity
1210     ) internal virtual {}
1211 }
1212 
1213 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 /**
1218  * @dev These functions deal with verification of Merkle Tree proofs.
1219  *
1220  * The proofs can be generated using the JavaScript library
1221  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1222  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1223  *
1224  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1225  *
1226  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1227  * hashing, or use a hash function other than keccak256 for hashing leaves.
1228  * This is because the concatenation of a sorted pair of internal nodes in
1229  * the merkle tree could be reinterpreted as a leaf value.
1230  */
1231 library MerkleProof {
1232     /**
1233      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1234      * defined by `root`. For this, a `proof` must be provided, containing
1235      * sibling hashes on the branch from the leaf to the root of the tree. Each
1236      * pair of leaves and each pair of pre-images are assumed to be sorted.
1237      */
1238     function verify(
1239         bytes32[] memory proof,
1240         bytes32 root,
1241         bytes32 leaf
1242     ) internal pure returns (bool) {
1243         return processProof(proof, leaf) == root;
1244     }
1245 
1246     /**
1247      * @dev Calldata version of {verify}
1248      *
1249      * _Available since v4.7._
1250      */
1251     function verifyCalldata(
1252         bytes32[] calldata proof,
1253         bytes32 root,
1254         bytes32 leaf
1255     ) internal pure returns (bool) {
1256         return processProofCalldata(proof, leaf) == root;
1257     }
1258 
1259     /**
1260      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1261      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1262      * hash matches the root of the tree. When processing the proof, the pairs
1263      * of leafs & pre-images are assumed to be sorted.
1264      *
1265      * _Available since v4.4._
1266      */
1267     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1268         bytes32 computedHash = leaf;
1269         for (uint256 i = 0; i < proof.length; i++) {
1270             computedHash = _hashPair(computedHash, proof[i]);
1271         }
1272         return computedHash;
1273     }
1274 
1275     /**
1276      * @dev Calldata version of {processProof}
1277      *
1278      * _Available since v4.7._
1279      */
1280     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1281         bytes32 computedHash = leaf;
1282         for (uint256 i = 0; i < proof.length; i++) {
1283             computedHash = _hashPair(computedHash, proof[i]);
1284         }
1285         return computedHash;
1286     }
1287 
1288     /**
1289      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1290      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1291      *
1292      * _Available since v4.7._
1293      */
1294     function multiProofVerify(
1295         bytes32[] memory proof,
1296         bool[] memory proofFlags,
1297         bytes32 root,
1298         bytes32[] memory leaves
1299     ) internal pure returns (bool) {
1300         return processMultiProof(proof, proofFlags, leaves) == root;
1301     }
1302 
1303     /**
1304      * @dev Calldata version of {multiProofVerify}
1305      *
1306      * _Available since v4.7._
1307      */
1308     function multiProofVerifyCalldata(
1309         bytes32[] calldata proof,
1310         bool[] calldata proofFlags,
1311         bytes32 root,
1312         bytes32[] memory leaves
1313     ) internal pure returns (bool) {
1314         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1315     }
1316 
1317     /**
1318      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1319      * consuming from one or the other at each step according to the instructions given by
1320      * `proofFlags`.
1321      *
1322      * _Available since v4.7._
1323      */
1324     function processMultiProof(
1325         bytes32[] memory proof,
1326         bool[] memory proofFlags,
1327         bytes32[] memory leaves
1328     ) internal pure returns (bytes32 merkleRoot) {
1329         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1330         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1331         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1332         // the merkle tree.
1333         uint256 leavesLen = leaves.length;
1334         uint256 totalHashes = proofFlags.length;
1335 
1336         // Check proof validity.
1337         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1338 
1339         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1340         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1341         bytes32[] memory hashes = new bytes32[](totalHashes);
1342         uint256 leafPos = 0;
1343         uint256 hashPos = 0;
1344         uint256 proofPos = 0;
1345         // At each step, we compute the next hash using two values:
1346         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1347         //   get the next hash.
1348         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1349         //   `proof` array.
1350         for (uint256 i = 0; i < totalHashes; i++) {
1351             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1352             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1353             hashes[i] = _hashPair(a, b);
1354         }
1355 
1356         if (totalHashes > 0) {
1357             return hashes[totalHashes - 1];
1358         } else if (leavesLen > 0) {
1359             return leaves[0];
1360         } else {
1361             return proof[0];
1362         }
1363     }
1364 
1365     /**
1366      * @dev Calldata version of {processMultiProof}
1367      *
1368      * _Available since v4.7._
1369      */
1370     function processMultiProofCalldata(
1371         bytes32[] calldata proof,
1372         bool[] calldata proofFlags,
1373         bytes32[] memory leaves
1374     ) internal pure returns (bytes32 merkleRoot) {
1375         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1376         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1377         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1378         // the merkle tree.
1379         uint256 leavesLen = leaves.length;
1380         uint256 totalHashes = proofFlags.length;
1381 
1382         // Check proof validity.
1383         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1384 
1385         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1386         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1387         bytes32[] memory hashes = new bytes32[](totalHashes);
1388         uint256 leafPos = 0;
1389         uint256 hashPos = 0;
1390         uint256 proofPos = 0;
1391         // At each step, we compute the next hash using two values:
1392         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1393         //   get the next hash.
1394         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1395         //   `proof` array.
1396         for (uint256 i = 0; i < totalHashes; i++) {
1397             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1398             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1399             hashes[i] = _hashPair(a, b);
1400         }
1401 
1402         if (totalHashes > 0) {
1403             return hashes[totalHashes - 1];
1404         } else if (leavesLen > 0) {
1405             return leaves[0];
1406         } else {
1407             return proof[0];
1408         }
1409     }
1410 
1411     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1412         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1413     }
1414 
1415     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1416         /// @solidity memory-safe-assembly
1417         assembly {
1418             mstore(0x00, a)
1419             mstore(0x20, b)
1420             value := keccak256(0x00, 0x40)
1421         }
1422     }
1423 }
1424 
1425 pragma solidity >=0.8.4 <0.9.0;
1426 
1427 error NotATribulator();
1428 error TokenForTribNonexistent();
1429 error MintFromContract();
1430 error MintNonpositive();
1431 error MintMoreThanMaxSupply();
1432 error MintValueInsufficientPublic();
1433 error MintWalletLimitExceededPublic();
1434 error MintValueInsufficientPre();
1435 error MintWalletLimitExceededPre();
1436 error MerkleProofInvalid();
1437 error SaleNotActive();
1438 error WithdrawAFailed();
1439 error WithdrawBFailed();
1440 error WithdrawDFailed();
1441 error WithdrawOFailed();
1442 
1443 contract OrigoGenesis is ERC721A, Ownable {  
1444     using Strings for uint256;
1445 
1446     uint256 public max_supply = 3000;
1447     mapping(address => uint256) public num_minted; // allows limit per wallet but multiple txs
1448     mapping(address => uint256) public tribulator; // in case they want to add mods etc as tribulators
1449 
1450     uint256 public sale_state = 0;
1451 
1452     uint256 public pre_sale_cost = 0.089 ether;
1453     uint256 public public_sale_cost = 0.099 ether;
1454 
1455     uint256 public pre_sale_mint_limit = 2;
1456     uint256 public public_sale_mint_limit = 3;
1457 
1458     bytes32 public merkle_root;
1459 
1460     string private _myBaseURI;
1461    
1462 	constructor() ERC721A("Origo Genesis", "ORIGO") {}
1463 
1464     function setMyBaseURI(string memory _myNewBaseURI) external onlyOwner {
1465         _myBaseURI = _myNewBaseURI;
1466     }
1467     function _baseURI() internal view virtual override(ERC721A) returns (string memory) {
1468         return _myBaseURI;
1469     }
1470 
1471     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1472         merkle_root = _merkleRoot;
1473     }
1474 
1475  	function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1476          max_supply = _maxSupply;
1477     }
1478     function setSaleState(uint256 _saleState) external onlyOwner {
1479         sale_state = _saleState;
1480     }
1481     function setPreSaleCost(uint256 _preSaleCost) external onlyOwner {
1482         pre_sale_cost = _preSaleCost;
1483     }
1484     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1485         public_sale_cost = _publicSaleCost;
1486     }
1487     function setPreSaleMintLimit(uint256 _preSaleMintLimit) external onlyOwner {
1488         pre_sale_mint_limit = _preSaleMintLimit;
1489     }
1490     function setPublicSaleMintLimit(uint256 _publicSaleMintLimit) external onlyOwner {
1491         public_sale_mint_limit = _publicSaleMintLimit;
1492     }
1493 
1494     function isApprovedForAll(address owner, address operator) public override view returns (bool) {
1495         if (tribulator[operator] == 1) {
1496             return true;
1497         }
1498 
1499         return super.isApprovedForAll(owner, operator);
1500     }
1501 
1502     function tribulation(uint256[] calldata tokenIds) external {
1503         if (tribulator[_msgSender()] != 1) revert NotATribulator();
1504         for (uint256 ii = 0; ii < tokenIds.length; ii++) {
1505             if (!_exists(tokenIds[ii])) revert TokenForTribNonexistent();
1506             safeTransferFrom(ownerOf(tokenIds[ii]), tribulationWallet, tokenIds[ii]);
1507         }
1508     }
1509     function addTribulator(address trib) external onlyOwner {
1510         tribulator[trib] = 1;
1511     }
1512     function subTribulator(address trib) external onlyOwner {
1513         tribulator[trib] = 0;
1514     }
1515     function setTribulationWallet(address _tribulationWallet) public override onlyOwner {
1516         tribulationWallet = _tribulationWallet;
1517     }
1518 
1519     // note v0.8.0 checks safe math by default :)
1520     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) payable external nonReentrant {
1521         if (tx.origin != msg.sender) revert MintFromContract();
1522         if (!(_mintAmount > 0)) revert MintNonpositive();
1523         if (_mintAmount + totalSupply() > max_supply) revert MintMoreThanMaxSupply();
1524 
1525         // team mint
1526         if (_msgSender() == owner()) {
1527             _safeMint(_msgSender(), _mintAmount);
1528         }
1529         else if (sale_state == 2) { // public sale
1530             if (msg.value < public_sale_cost * _mintAmount) revert MintValueInsufficientPublic();
1531             if (_mintAmount + num_minted[_msgSender()] > public_sale_mint_limit) revert MintWalletLimitExceededPublic();
1532 
1533             num_minted[_msgSender()] += _mintAmount;
1534             _safeMint(_msgSender(), _mintAmount);
1535         }
1536         else if (sale_state == 1) { // pre sale
1537             if (msg.value < pre_sale_cost * _mintAmount) revert MintValueInsufficientPre();
1538             if (_mintAmount + num_minted[_msgSender()] > pre_sale_mint_limit) revert MintWalletLimitExceededPre();
1539 
1540             if (!MerkleProof.verify(_merkleProof, merkle_root, keccak256(abi.encodePacked(_msgSender())))) revert MerkleProofInvalid();
1541             num_minted[_msgSender()] += _mintAmount;
1542             _safeMint(_msgSender(), _mintAmount);
1543         }
1544         else {
1545             revert SaleNotActive();
1546         }
1547     }
1548 
1549     event DonationReceived(address sender, uint256 amount);
1550     receive() external payable {
1551         emit DonationReceived(msg.sender, msg.value);
1552     }
1553 
1554     function withdraw() external payable nonReentrant {
1555         uint256 balance0 = address(this).balance;
1556         (bool Os, ) = payable(0x01656D41e041b50fc7c1eb270f7d891021937436).call{value: balance0 * 5 / 100}("");
1557         if (!Os) revert WithdrawOFailed();
1558 
1559         (bool As, ) = payable(0x0bD059100255Ba73ca80F8EB8772AB00A2bc1236).call{value: balance0 * 25 / 100}("");
1560         if (!As) revert WithdrawAFailed();
1561 
1562         (bool Bs, ) = payable(0x5582291cACb396cdB02b0bAD08343e78fA1f2Aa4).call{value: balance0 * 25 / 100}("");
1563         if (!Bs) revert WithdrawBFailed();
1564 
1565         (bool Ds, ) = payable(0xe0f94C24E9a69B686EA97E07F4112e48634167Bb).call{value: balance0 * 45 / 100}("");
1566         if (!Ds) revert WithdrawDFailed();
1567     }
1568 }