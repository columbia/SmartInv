1 // SPDX-License-Identifier: MIT
2 
3 
4 /***
5  *                                                                      
6  *                                                                      
7  *        .         .-.        .  .       .            .     ,   .  .-. 
8  *        |        :   :       |  |       |          .'|    /  .'| (   )
9  *     .-.|--. .--.|   |.--.--.'--|-.--.  |.-. .  .    |   /-.   |  >-< 
10  *    (   |  | |   :   ;|  |  |   | `--.  |   )|  |    |  (   )  | (   )
11  *     `-''  `-'    `-' '  '  `-  ' `--'  '`-' `--|  '---'o`-' '---'`-' 
12  *                                                ;                     
13  *                                             `-'                      
14  */
15 
16  
17 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Contract module that helps prevent reentrant calls to a function.
26  *
27  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
28  * available, which can be applied to functions to make sure there are no nested
29  * (reentrant) calls to them.
30  *
31  * Note that because there is a single `nonReentrant` guard, functions marked as
32  * `nonReentrant` may not call one another. This can be worked around by making
33  * those functions `private`, and then adding `external` `nonReentrant` entry
34  * points to them.
35  *
36  * TIP: If you would like to learn more about reentrancy and alternative ways
37  * to protect against it, check out our blog post
38  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
39  */
40 abstract contract ReentrancyGuard {
41     // Booleans are more expensive than uint256 or any type that takes up a full
42     // word because each write operation emits an extra SLOAD to first read the
43     // slot's contents, replace the bits taken up by the boolean, and then write
44     // back. This is the compiler's defense against contract upgrades and
45     // pointer aliasing, and it cannot be disabled.
46 
47     // The values being non-zero value makes deployment a bit more expensive,
48     // but in exchange the refund on every call to nonReentrant will be lower in
49     // amount. Since refunds are capped to a percentage of the total
50     // transaction's gas, it is best to keep them low in cases like this one, to
51     // increase the likelihood of the full refund coming into effect.
52     uint256 private constant _NOT_ENTERED = 1;
53     uint256 private constant _ENTERED = 2;
54 
55     uint256 private _status;
56 
57     constructor() {
58         _status = _NOT_ENTERED;
59     }
60 
61     /**
62      * @dev Prevents a contract from calling itself, directly or indirectly.
63      * Calling a `nonReentrant` function from another `nonReentrant`
64      * function is not supported. It is possible to prevent this from happening
65      * by making the `nonReentrant` function external, and making it call a
66      * `private` function that does the actual work.
67      */
68     modifier nonReentrant() {
69         // On the first call to nonReentrant, _notEntered will be true
70         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
71 
72         // Any calls to nonReentrant after this point will fail
73         _status = _ENTERED;
74 
75         _;
76 
77         // By storing the original value once again, a refund is triggered (see
78         // https://eips.ethereum.org/EIPS/eip-2200)
79         _status = _NOT_ENTERED;
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Strings.sol
84 
85 
86 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev String operations.
92  */
93 library Strings {
94     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
95     uint8 private constant _ADDRESS_LENGTH = 20;
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
155      */
156     function toHexString(address addr) internal pure returns (string memory) {
157         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Context.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Provides information about the current execution context, including the
170  * sender of the transaction and its data. While these are generally available
171  * via msg.sender and msg.data, they should not be accessed in such a direct
172  * manner, since when dealing with meta-transactions the account sending and
173  * paying for execution may not be the actual sender (as far as an application
174  * is concerned).
175  *
176  * This contract is only required for intermediate, library-like contracts.
177  */
178 abstract contract Context {
179     function _msgSender() internal view virtual returns (address) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view virtual returns (bytes calldata) {
184         return msg.data;
185     }
186 }
187 
188 // File: @openzeppelin/contracts/access/Ownable.sol
189 
190 
191 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * By default, the owner account will be the one that deploys the contract. This
202  * can later be changed with {transferOwnership}.
203  *
204  * This module is used through inheritance. It will make available the modifier
205  * `onlyOwner`, which can be applied to your functions to restrict their use to
206  * the owner.
207  */
208 abstract contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev Initializes the contract setting the deployer as the initial owner.
215      */
216     constructor() {
217         _transferOwnership(_msgSender());
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         _checkOwner();
225         _;
226     }
227 
228     /**
229      * @dev Returns the address of the current owner.
230      */
231     function owner() public view virtual returns (address) {
232         return _owner;
233     }
234 
235     /**
236      * @dev Throws if the sender is not the owner.
237      */
238     function _checkOwner() internal view virtual {
239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
240     }
241 
242     /**
243      * @dev Leaves the contract without owner. It will not be possible to call
244      * `onlyOwner` functions anymore. Can only be called by the current owner.
245      *
246      * NOTE: Renouncing ownership will leave the contract without an owner,
247      * thereby removing any functionality that is only available to the owner.
248      */
249     function renounceOwnership() public virtual onlyOwner {
250         _transferOwnership(address(0));
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         _transferOwnership(newOwner);
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Internal function without access restriction.
265      */
266     function _transferOwnership(address newOwner) internal virtual {
267         address oldOwner = _owner;
268         _owner = newOwner;
269         emit OwnershipTransferred(oldOwner, newOwner);
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/Address.sol
274 
275 
276 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
277 
278 pragma solidity ^0.8.1;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      *
301      * [IMPORTANT]
302      * ====
303      * You shouldn't rely on `isContract` to protect against flash loan attacks!
304      *
305      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
306      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
307      * constructor.
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // This method relies on extcodesize/address.code.length, which returns 0
312         // for contracts in construction, since the code is only stored at the end
313         // of the constructor execution.
314 
315         return account.code.length > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.call{value: value}(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.delegatecall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
471      * revert reason using the provided one.
472      *
473      * _Available since v4.3._
474      */
475     function verifyCallResult(
476         bool success,
477         bytes memory returndata,
478         string memory errorMessage
479     ) internal pure returns (bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486                 /// @solidity memory-safe-assembly
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
499 
500 
501 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @title ERC721 token receiver interface
507  * @dev Interface for any contract that wants to support safeTransfers
508  * from ERC721 asset contracts.
509  */
510 interface IERC721Receiver {
511     /**
512      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
513      * by `operator` from `from`, this function is called.
514      *
515      * It must return its Solidity selector to confirm the token transfer.
516      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
517      *
518      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
519      */
520     function onERC721Received(
521         address operator,
522         address from,
523         uint256 tokenId,
524         bytes calldata data
525     ) external returns (bytes4);
526 }
527 
528 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Interface of the ERC165 standard, as defined in the
537  * https://eips.ethereum.org/EIPS/eip-165[EIP].
538  *
539  * Implementers can declare support of contract interfaces, which can then be
540  * queried by others ({ERC165Checker}).
541  *
542  * For an implementation, see {ERC165}.
543  */
544 interface IERC165 {
545     /**
546      * @dev Returns true if this contract implements the interface defined by
547      * `interfaceId`. See the corresponding
548      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
549      * to learn more about how these ids are created.
550      *
551      * This function call must use less than 30 000 gas.
552      */
553     function supportsInterface(bytes4 interfaceId) external view returns (bool);
554 }
555 
556 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165).interfaceId;
584     }
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
588 
589 
590 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Required interface of an ERC721 compliant contract.
597  */
598 interface IERC721 is IERC165 {
599     /**
600      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
601      */
602     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
606      */
607     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
608 
609     /**
610      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
611      */
612     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
613 
614     /**
615      * @dev Returns the number of tokens in ``owner``'s account.
616      */
617     function balanceOf(address owner) external view returns (uint256 balance);
618 
619     /**
620      * @dev Returns the owner of the `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function ownerOf(uint256 tokenId) external view returns (address owner);
627 
628     /**
629      * @dev Safely transfers `tokenId` token from `from` to `to`.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must exist and be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId,
645         bytes calldata data
646     ) external;
647 
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
650      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must exist and be owned by `from`.
657      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) external;
667 
668     /**
669      * @dev Transfers `tokenId` token from `from` to `to`.
670      *
671      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      *
680      * Emits a {Transfer} event.
681      */
682     function transferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
690      * The approval is cleared when the token is transferred.
691      *
692      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
693      *
694      * Requirements:
695      *
696      * - The caller must own the token or be an approved operator.
697      * - `tokenId` must exist.
698      *
699      * Emits an {Approval} event.
700      */
701     function approve(address to, uint256 tokenId) external;
702 
703     /**
704      * @dev Approve or remove `operator` as an operator for the caller.
705      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
706      *
707      * Requirements:
708      *
709      * - The `operator` cannot be the caller.
710      *
711      * Emits an {ApprovalForAll} event.
712      */
713     function setApprovalForAll(address operator, bool _approved) external;
714 
715     /**
716      * @dev Returns the account approved for `tokenId` token.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must exist.
721      */
722     function getApproved(uint256 tokenId) external view returns (address operator);
723 
724     /**
725      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
726      *
727      * See {setApprovalForAll}
728      */
729     function isApprovedForAll(address owner, address operator) external view returns (bool);
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
742  * @dev See https://eips.ethereum.org/EIPS/eip-721
743  */
744 interface IERC721Metadata is IERC721 {
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 }
760 
761 // File: erc721a/contracts/IERC721A.sol
762 
763 
764 // ERC721A Contracts v4.2.3
765 // Creator: Chiru Labs
766 
767 pragma solidity ^0.8.4;
768 
769 /**
770  * @dev Interface of ERC721A.
771  */
772 interface IERC721A {
773     /**
774      * The caller must own the token or be an approved operator.
775      */
776     error ApprovalCallerNotOwnerNorApproved();
777 
778     /**
779      * The token does not exist.
780      */
781     error ApprovalQueryForNonexistentToken();
782 
783     /**
784      * Cannot query the balance for the zero address.
785      */
786     error BalanceQueryForZeroAddress();
787 
788     /**
789      * Cannot mint to the zero address.
790      */
791     error MintToZeroAddress();
792 
793     /**
794      * The quantity of tokens minted must be more than zero.
795      */
796     error MintZeroQuantity();
797 
798     /**
799      * The token does not exist.
800      */
801     error OwnerQueryForNonexistentToken();
802 
803     /**
804      * The caller must own the token or be an approved operator.
805      */
806     error TransferCallerNotOwnerNorApproved();
807 
808     /**
809      * The token must be owned by `from`.
810      */
811     error TransferFromIncorrectOwner();
812 
813     /**
814      * Cannot safely transfer to a contract that does not implement the
815      * ERC721Receiver interface.
816      */
817     error TransferToNonERC721ReceiverImplementer();
818 
819     /**
820      * Cannot transfer to the zero address.
821      */
822     error TransferToZeroAddress();
823 
824     /**
825      * The token does not exist.
826      */
827     error URIQueryForNonexistentToken();
828 
829     /**
830      * The `quantity` minted with ERC2309 exceeds the safety limit.
831      */
832     error MintERC2309QuantityExceedsLimit();
833 
834     /**
835      * The `extraData` cannot be set on an unintialized ownership slot.
836      */
837     error OwnershipNotInitializedForExtraData();
838 
839     // =============================================================
840     //                            STRUCTS
841     // =============================================================
842 
843     struct TokenOwnership {
844         // The address of the owner.
845         address addr;
846         // Stores the start time of ownership with minimal overhead for tokenomics.
847         uint64 startTimestamp;
848         // Whether the token has been burned.
849         bool burned;
850         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
851         uint24 extraData;
852     }
853 
854     // =============================================================
855     //                         TOKEN COUNTERS
856     // =============================================================
857 
858     /**
859      * @dev Returns the total number of tokens in existence.
860      * Burned tokens will reduce the count.
861      * To get the total number of tokens minted, please see {_totalMinted}.
862      */
863     function totalSupply() external view returns (uint256);
864 
865     // =============================================================
866     //                            IERC165
867     // =============================================================
868 
869     /**
870      * @dev Returns true if this contract implements the interface defined by
871      * `interfaceId`. See the corresponding
872      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
873      * to learn more about how these ids are created.
874      *
875      * This function call must use less than 30000 gas.
876      */
877     function supportsInterface(bytes4 interfaceId) external view returns (bool);
878 
879     // =============================================================
880     //                            IERC721
881     // =============================================================
882 
883     /**
884      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
885      */
886     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
887 
888     /**
889      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
890      */
891     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
892 
893     /**
894      * @dev Emitted when `owner` enables or disables
895      * (`approved`) `operator` to manage all of its assets.
896      */
897     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
898 
899     /**
900      * @dev Returns the number of tokens in `owner`'s account.
901      */
902     function balanceOf(address owner) external view returns (uint256 balance);
903 
904     /**
905      * @dev Returns the owner of the `tokenId` token.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function ownerOf(uint256 tokenId) external view returns (address owner);
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`,
915      * checking first that contract recipients are aware of the ERC721 protocol
916      * to prevent tokens from being forever locked.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If the caller is not `from`, it must be have been allowed to move
924      * this token by either {approve} or {setApprovalForAll}.
925      * - If `to` refers to a smart contract, it must implement
926      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927      *
928      * Emits a {Transfer} event.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes calldata data
935     ) external payable;
936 
937     /**
938      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) external payable;
945 
946     /**
947      * @dev Transfers `tokenId` from `from` to `to`.
948      *
949      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
950      * whenever possible.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must be owned by `from`.
957      * - If the caller is not `from`, it must be approved to move this token
958      * by either {approve} or {setApprovalForAll}.
959      *
960      * Emits a {Transfer} event.
961      */
962     function transferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) external payable;
967 
968     /**
969      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
970      * The approval is cleared when the token is transferred.
971      *
972      * Only a single account can be approved at a time, so approving the
973      * zero address clears previous approvals.
974      *
975      * Requirements:
976      *
977      * - The caller must own the token or be an approved operator.
978      * - `tokenId` must exist.
979      *
980      * Emits an {Approval} event.
981      */
982     function approve(address to, uint256 tokenId) external payable;
983 
984     /**
985      * @dev Approve or remove `operator` as an operator for the caller.
986      * Operators can call {transferFrom} or {safeTransferFrom}
987      * for any token owned by the caller.
988      *
989      * Requirements:
990      *
991      * - The `operator` cannot be the caller.
992      *
993      * Emits an {ApprovalForAll} event.
994      */
995     function setApprovalForAll(address operator, bool _approved) external;
996 
997     /**
998      * @dev Returns the account approved for `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function getApproved(uint256 tokenId) external view returns (address operator);
1005 
1006     /**
1007      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1008      *
1009      * See {setApprovalForAll}.
1010      */
1011     function isApprovedForAll(address owner, address operator) external view returns (bool);
1012 
1013     // =============================================================
1014     //                        IERC721Metadata
1015     // =============================================================
1016 
1017     /**
1018      * @dev Returns the token collection name.
1019      */
1020     function name() external view returns (string memory);
1021 
1022     /**
1023      * @dev Returns the token collection symbol.
1024      */
1025     function symbol() external view returns (string memory);
1026 
1027     /**
1028      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1029      */
1030     function tokenURI(uint256 tokenId) external view returns (string memory);
1031 
1032     // =============================================================
1033     //                           IERC2309
1034     // =============================================================
1035 
1036     /**
1037      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1038      * (inclusive) is transferred from `from` to `to`, as defined in the
1039      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1040      *
1041      * See {_mintERC2309} for more details.
1042      */
1043     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1044 }
1045 
1046 // File: erc721a/contracts/ERC721A.sol
1047 
1048 
1049 // ERC721A Contracts v4.2.3
1050 // Creator: Chiru Labs
1051 
1052 pragma solidity ^0.8.4;
1053 
1054 
1055 /**
1056  * @dev Interface of ERC721 token receiver.
1057  */
1058 interface ERC721A__IERC721Receiver {
1059     function onERC721Received(
1060         address operator,
1061         address from,
1062         uint256 tokenId,
1063         bytes calldata data
1064     ) external returns (bytes4);
1065 }
1066 
1067 /**
1068  * @title ERC721A
1069  *
1070  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1071  * Non-Fungible Token Standard, including the Metadata extension.
1072  * Optimized for lower gas during batch mints.
1073  *
1074  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1075  * starting from `_startTokenId()`.
1076  *
1077  * Assumptions:
1078  *
1079  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1080  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1081  */
1082 contract ERC721A is IERC721A {
1083     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1084     struct TokenApprovalRef {
1085         address value;
1086     }
1087 
1088     // =============================================================
1089     //                           CONSTANTS
1090     // =============================================================
1091 
1092     // Mask of an entry in packed address data.
1093     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1094 
1095     // The bit position of `numberMinted` in packed address data.
1096     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1097 
1098     // The bit position of `numberBurned` in packed address data.
1099     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1100 
1101     // The bit position of `aux` in packed address data.
1102     uint256 private constant _BITPOS_AUX = 192;
1103 
1104     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1105     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1106 
1107     // The bit position of `startTimestamp` in packed ownership.
1108     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1109 
1110     // The bit mask of the `burned` bit in packed ownership.
1111     uint256 private constant _BITMASK_BURNED = 1 << 224;
1112 
1113     // The bit position of the `nextInitialized` bit in packed ownership.
1114     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1115 
1116     // The bit mask of the `nextInitialized` bit in packed ownership.
1117     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1118 
1119     // The bit position of `extraData` in packed ownership.
1120     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1121 
1122     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1123     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1124 
1125     // The mask of the lower 160 bits for addresses.
1126     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1127 
1128     // The maximum `quantity` that can be minted with {_mintERC2309}.
1129     // This limit is to prevent overflows on the address data entries.
1130     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1131     // is required to cause an overflow, which is unrealistic.
1132     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1133 
1134     // The `Transfer` event signature is given by:
1135     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1136     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1137         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1138 
1139     // =============================================================
1140     //                            STORAGE
1141     // =============================================================
1142 
1143     // The next token ID to be minted.
1144     uint256 private _currentIndex;
1145 
1146     // The number of tokens burned.
1147     uint256 private _burnCounter;
1148 
1149     // Token name
1150     string private _name;
1151 
1152     // Token symbol
1153     string private _symbol;
1154 
1155     // Mapping from token ID to ownership details
1156     // An empty struct value does not necessarily mean the token is unowned.
1157     // See {_packedOwnershipOf} implementation for details.
1158     //
1159     // Bits Layout:
1160     // - [0..159]   `addr`
1161     // - [160..223] `startTimestamp`
1162     // - [224]      `burned`
1163     // - [225]      `nextInitialized`
1164     // - [232..255] `extraData`
1165     mapping(uint256 => uint256) private _packedOwnerships;
1166 
1167     // Mapping owner address to address data.
1168     //
1169     // Bits Layout:
1170     // - [0..63]    `balance`
1171     // - [64..127]  `numberMinted`
1172     // - [128..191] `numberBurned`
1173     // - [192..255] `aux`
1174     mapping(address => uint256) private _packedAddressData;
1175 
1176     // Mapping from token ID to approved address.
1177     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1178 
1179     // Mapping from owner to operator approvals
1180     mapping(address => mapping(address => bool)) private _operatorApprovals;
1181 
1182     // =============================================================
1183     //                          CONSTRUCTOR
1184     // =============================================================
1185 
1186     constructor(string memory name_, string memory symbol_) {
1187         _name = name_;
1188         _symbol = symbol_;
1189         _currentIndex = _startTokenId();
1190     }
1191 
1192     // =============================================================
1193     //                   TOKEN COUNTING OPERATIONS
1194     // =============================================================
1195 
1196     /**
1197      * @dev Returns the starting token ID.
1198      * To change the starting token ID, please override this function.
1199      */
1200     function _startTokenId() internal view virtual returns (uint256) {
1201         return 0;
1202     }
1203 
1204     /**
1205      * @dev Returns the next token ID to be minted.
1206      */
1207     function _nextTokenId() internal view virtual returns (uint256) {
1208         return _currentIndex;
1209     }
1210 
1211     /**
1212      * @dev Returns the total number of tokens in existence.
1213      * Burned tokens will reduce the count.
1214      * To get the total number of tokens minted, please see {_totalMinted}.
1215      */
1216     function totalSupply() public view virtual override returns (uint256) {
1217         // Counter underflow is impossible as _burnCounter cannot be incremented
1218         // more than `_currentIndex - _startTokenId()` times.
1219         unchecked {
1220             return _currentIndex - _burnCounter - _startTokenId();
1221         }
1222     }
1223 
1224     /**
1225      * @dev Returns the total amount of tokens minted in the contract.
1226      */
1227     function _totalMinted() internal view virtual returns (uint256) {
1228         // Counter underflow is impossible as `_currentIndex` does not decrement,
1229         // and it is initialized to `_startTokenId()`.
1230         unchecked {
1231             return _currentIndex - _startTokenId();
1232         }
1233     }
1234 
1235     /**
1236      * @dev Returns the total number of tokens burned.
1237      */
1238     function _totalBurned() internal view virtual returns (uint256) {
1239         return _burnCounter;
1240     }
1241 
1242     // =============================================================
1243     //                    ADDRESS DATA OPERATIONS
1244     // =============================================================
1245 
1246     /**
1247      * @dev Returns the number of tokens in `owner`'s account.
1248      */
1249     function balanceOf(address owner) public view virtual override returns (uint256) {
1250         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1251         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1252     }
1253 
1254     /**
1255      * Returns the number of tokens minted by `owner`.
1256      */
1257     function _numberMinted(address owner) internal view returns (uint256) {
1258         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1259     }
1260 
1261     /**
1262      * Returns the number of tokens burned by or on behalf of `owner`.
1263      */
1264     function _numberBurned(address owner) internal view returns (uint256) {
1265         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1266     }
1267 
1268     /**
1269      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1270      */
1271     function _getAux(address owner) internal view returns (uint64) {
1272         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1273     }
1274 
1275     /**
1276      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1277      * If there are multiple variables, please pack them into a uint64.
1278      */
1279     function _setAux(address owner, uint64 aux) internal virtual {
1280         uint256 packed = _packedAddressData[owner];
1281         uint256 auxCasted;
1282         // Cast `aux` with assembly to avoid redundant masking.
1283         assembly {
1284             auxCasted := aux
1285         }
1286         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1287         _packedAddressData[owner] = packed;
1288     }
1289 
1290     // =============================================================
1291     //                            IERC165
1292     // =============================================================
1293 
1294     /**
1295      * @dev Returns true if this contract implements the interface defined by
1296      * `interfaceId`. See the corresponding
1297      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1298      * to learn more about how these ids are created.
1299      *
1300      * This function call must use less than 30000 gas.
1301      */
1302     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1303         // The interface IDs are constants representing the first 4 bytes
1304         // of the XOR of all function selectors in the interface.
1305         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1306         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1307         return
1308             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1309             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1310             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1311     }
1312 
1313     // =============================================================
1314     //                        IERC721Metadata
1315     // =============================================================
1316 
1317     /**
1318      * @dev Returns the token collection name.
1319      */
1320     function name() public view virtual override returns (string memory) {
1321         return _name;
1322     }
1323 
1324     /**
1325      * @dev Returns the token collection symbol.
1326      */
1327     function symbol() public view virtual override returns (string memory) {
1328         return _symbol;
1329     }
1330 
1331     /**
1332      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1333      */
1334     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1335         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1336 
1337         string memory baseURI = _baseURI();
1338         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1339     }
1340 
1341     /**
1342      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1343      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1344      * by default, it can be overridden in child contracts.
1345      */
1346     function _baseURI() internal view virtual returns (string memory) {
1347         return '';
1348     }
1349 
1350     // =============================================================
1351     //                     OWNERSHIPS OPERATIONS
1352     // =============================================================
1353 
1354     /**
1355      * @dev Returns the owner of the `tokenId` token.
1356      *
1357      * Requirements:
1358      *
1359      * - `tokenId` must exist.
1360      */
1361     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1362         return address(uint160(_packedOwnershipOf(tokenId)));
1363     }
1364 
1365     /**
1366      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1367      * It gradually moves to O(1) as tokens get transferred around over time.
1368      */
1369     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1370         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1371     }
1372 
1373     /**
1374      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1375      */
1376     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1377         return _unpackedOwnership(_packedOwnerships[index]);
1378     }
1379 
1380     /**
1381      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1382      */
1383     function _initializeOwnershipAt(uint256 index) internal virtual {
1384         if (_packedOwnerships[index] == 0) {
1385             _packedOwnerships[index] = _packedOwnershipOf(index);
1386         }
1387     }
1388 
1389     /**
1390      * Returns the packed ownership data of `tokenId`.
1391      */
1392     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1393         uint256 curr = tokenId;
1394 
1395         unchecked {
1396             if (_startTokenId() <= curr)
1397                 if (curr < _currentIndex) {
1398                     uint256 packed = _packedOwnerships[curr];
1399                     // If not burned.
1400                     if (packed & _BITMASK_BURNED == 0) {
1401                         // Invariant:
1402                         // There will always be an initialized ownership slot
1403                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1404                         // before an unintialized ownership slot
1405                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1406                         // Hence, `curr` will not underflow.
1407                         //
1408                         // We can directly compare the packed value.
1409                         // If the address is zero, packed will be zero.
1410                         while (packed == 0) {
1411                             packed = _packedOwnerships[--curr];
1412                         }
1413                         return packed;
1414                     }
1415                 }
1416         }
1417         revert OwnerQueryForNonexistentToken();
1418     }
1419 
1420     /**
1421      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1422      */
1423     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1424         ownership.addr = address(uint160(packed));
1425         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1426         ownership.burned = packed & _BITMASK_BURNED != 0;
1427         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1428     }
1429 
1430     /**
1431      * @dev Packs ownership data into a single uint256.
1432      */
1433     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1434         assembly {
1435             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1436             owner := and(owner, _BITMASK_ADDRESS)
1437             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1438             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1439         }
1440     }
1441 
1442     /**
1443      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1444      */
1445     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1446         // For branchless setting of the `nextInitialized` flag.
1447         assembly {
1448             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1449             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1450         }
1451     }
1452 
1453     // =============================================================
1454     //                      APPROVAL OPERATIONS
1455     // =============================================================
1456 
1457     /**
1458      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1459      * The approval is cleared when the token is transferred.
1460      *
1461      * Only a single account can be approved at a time, so approving the
1462      * zero address clears previous approvals.
1463      *
1464      * Requirements:
1465      *
1466      * - The caller must own the token or be an approved operator.
1467      * - `tokenId` must exist.
1468      *
1469      * Emits an {Approval} event.
1470      */
1471     function approve(address to, uint256 tokenId) public payable virtual override {
1472         address owner = ownerOf(tokenId);
1473 
1474         if (_msgSenderERC721A() != owner)
1475             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1476                 revert ApprovalCallerNotOwnerNorApproved();
1477             }
1478 
1479         _tokenApprovals[tokenId].value = to;
1480         emit Approval(owner, to, tokenId);
1481     }
1482 
1483     /**
1484      * @dev Returns the account approved for `tokenId` token.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      */
1490     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1491         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1492 
1493         return _tokenApprovals[tokenId].value;
1494     }
1495 
1496     /**
1497      * @dev Approve or remove `operator` as an operator for the caller.
1498      * Operators can call {transferFrom} or {safeTransferFrom}
1499      * for any token owned by the caller.
1500      *
1501      * Requirements:
1502      *
1503      * - The `operator` cannot be the caller.
1504      *
1505      * Emits an {ApprovalForAll} event.
1506      */
1507     function setApprovalForAll(address operator, bool approved) public virtual override {
1508         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1509         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1510     }
1511 
1512     /**
1513      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1514      *
1515      * See {setApprovalForAll}.
1516      */
1517     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1518         return _operatorApprovals[owner][operator];
1519     }
1520 
1521     /**
1522      * @dev Returns whether `tokenId` exists.
1523      *
1524      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1525      *
1526      * Tokens start existing when they are minted. See {_mint}.
1527      */
1528     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1529         return
1530             _startTokenId() <= tokenId &&
1531             tokenId < _currentIndex && // If within bounds,
1532             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1533     }
1534 
1535     /**
1536      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1537      */
1538     function _isSenderApprovedOrOwner(
1539         address approvedAddress,
1540         address owner,
1541         address msgSender
1542     ) private pure returns (bool result) {
1543         assembly {
1544             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1545             owner := and(owner, _BITMASK_ADDRESS)
1546             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1547             msgSender := and(msgSender, _BITMASK_ADDRESS)
1548             // `msgSender == owner || msgSender == approvedAddress`.
1549             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1550         }
1551     }
1552 
1553     /**
1554      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1555      */
1556     function _getApprovedSlotAndAddress(uint256 tokenId)
1557         private
1558         view
1559         returns (uint256 approvedAddressSlot, address approvedAddress)
1560     {
1561         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1562         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1563         assembly {
1564             approvedAddressSlot := tokenApproval.slot
1565             approvedAddress := sload(approvedAddressSlot)
1566         }
1567     }
1568 
1569     // =============================================================
1570     //                      TRANSFER OPERATIONS
1571     // =============================================================
1572 
1573     /**
1574      * @dev Transfers `tokenId` from `from` to `to`.
1575      *
1576      * Requirements:
1577      *
1578      * - `from` cannot be the zero address.
1579      * - `to` cannot be the zero address.
1580      * - `tokenId` token must be owned by `from`.
1581      * - If the caller is not `from`, it must be approved to move this token
1582      * by either {approve} or {setApprovalForAll}.
1583      *
1584      * Emits a {Transfer} event.
1585      */
1586     function transferFrom(
1587         address from,
1588         address to,
1589         uint256 tokenId
1590     ) public payable virtual override {
1591         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1592 
1593         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1594 
1595         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1596 
1597         // The nested ifs save around 20+ gas over a compound boolean condition.
1598         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1599             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1600 
1601         if (to == address(0)) revert TransferToZeroAddress();
1602 
1603         _beforeTokenTransfers(from, to, tokenId, 1);
1604 
1605         // Clear approvals from the previous owner.
1606         assembly {
1607             if approvedAddress {
1608                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1609                 sstore(approvedAddressSlot, 0)
1610             }
1611         }
1612 
1613         // Underflow of the sender's balance is impossible because we check for
1614         // ownership above and the recipient's balance can't realistically overflow.
1615         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1616         unchecked {
1617             // We can directly increment and decrement the balances.
1618             --_packedAddressData[from]; // Updates: `balance -= 1`.
1619             ++_packedAddressData[to]; // Updates: `balance += 1`.
1620 
1621             // Updates:
1622             // - `address` to the next owner.
1623             // - `startTimestamp` to the timestamp of transfering.
1624             // - `burned` to `false`.
1625             // - `nextInitialized` to `true`.
1626             _packedOwnerships[tokenId] = _packOwnershipData(
1627                 to,
1628                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1629             );
1630 
1631             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1632             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1633                 uint256 nextTokenId = tokenId + 1;
1634                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1635                 if (_packedOwnerships[nextTokenId] == 0) {
1636                     // If the next slot is within bounds.
1637                     if (nextTokenId != _currentIndex) {
1638                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1639                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1640                     }
1641                 }
1642             }
1643         }
1644 
1645         emit Transfer(from, to, tokenId);
1646         _afterTokenTransfers(from, to, tokenId, 1);
1647     }
1648 
1649     /**
1650      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1651      */
1652     function safeTransferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId
1656     ) public payable virtual override {
1657         safeTransferFrom(from, to, tokenId, '');
1658     }
1659 
1660     /**
1661      * @dev Safely transfers `tokenId` token from `from` to `to`.
1662      *
1663      * Requirements:
1664      *
1665      * - `from` cannot be the zero address.
1666      * - `to` cannot be the zero address.
1667      * - `tokenId` token must exist and be owned by `from`.
1668      * - If the caller is not `from`, it must be approved to move this token
1669      * by either {approve} or {setApprovalForAll}.
1670      * - If `to` refers to a smart contract, it must implement
1671      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function safeTransferFrom(
1676         address from,
1677         address to,
1678         uint256 tokenId,
1679         bytes memory _data
1680     ) public payable virtual override {
1681         transferFrom(from, to, tokenId);
1682         if (to.code.length != 0)
1683             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1684                 revert TransferToNonERC721ReceiverImplementer();
1685             }
1686     }
1687 
1688     /**
1689      * @dev Hook that is called before a set of serially-ordered token IDs
1690      * are about to be transferred. This includes minting.
1691      * And also called before burning one token.
1692      *
1693      * `startTokenId` - the first token ID to be transferred.
1694      * `quantity` - the amount to be transferred.
1695      *
1696      * Calling conditions:
1697      *
1698      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1699      * transferred to `to`.
1700      * - When `from` is zero, `tokenId` will be minted for `to`.
1701      * - When `to` is zero, `tokenId` will be burned by `from`.
1702      * - `from` and `to` are never both zero.
1703      */
1704     function _beforeTokenTransfers(
1705         address from,
1706         address to,
1707         uint256 startTokenId,
1708         uint256 quantity
1709     ) internal virtual {}
1710 
1711     /**
1712      * @dev Hook that is called after a set of serially-ordered token IDs
1713      * have been transferred. This includes minting.
1714      * And also called after one token has been burned.
1715      *
1716      * `startTokenId` - the first token ID to be transferred.
1717      * `quantity` - the amount to be transferred.
1718      *
1719      * Calling conditions:
1720      *
1721      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1722      * transferred to `to`.
1723      * - When `from` is zero, `tokenId` has been minted for `to`.
1724      * - When `to` is zero, `tokenId` has been burned by `from`.
1725      * - `from` and `to` are never both zero.
1726      */
1727     function _afterTokenTransfers(
1728         address from,
1729         address to,
1730         uint256 startTokenId,
1731         uint256 quantity
1732     ) internal virtual {}
1733 
1734     /**
1735      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1736      *
1737      * `from` - Previous owner of the given token ID.
1738      * `to` - Target address that will receive the token.
1739      * `tokenId` - Token ID to be transferred.
1740      * `_data` - Optional data to send along with the call.
1741      *
1742      * Returns whether the call correctly returned the expected magic value.
1743      */
1744     function _checkContractOnERC721Received(
1745         address from,
1746         address to,
1747         uint256 tokenId,
1748         bytes memory _data
1749     ) private returns (bool) {
1750         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1751             bytes4 retval
1752         ) {
1753             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1754         } catch (bytes memory reason) {
1755             if (reason.length == 0) {
1756                 revert TransferToNonERC721ReceiverImplementer();
1757             } else {
1758                 assembly {
1759                     revert(add(32, reason), mload(reason))
1760                 }
1761             }
1762         }
1763     }
1764 
1765     // =============================================================
1766     //                        MINT OPERATIONS
1767     // =============================================================
1768 
1769     /**
1770      * @dev Mints `quantity` tokens and transfers them to `to`.
1771      *
1772      * Requirements:
1773      *
1774      * - `to` cannot be the zero address.
1775      * - `quantity` must be greater than 0.
1776      *
1777      * Emits a {Transfer} event for each mint.
1778      */
1779     function _mint(address to, uint256 quantity) internal virtual {
1780         uint256 startTokenId = _currentIndex;
1781         if (quantity == 0) revert MintZeroQuantity();
1782 
1783         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1784 
1785         // Overflows are incredibly unrealistic.
1786         // `balance` and `numberMinted` have a maximum limit of 2**64.
1787         // `tokenId` has a maximum limit of 2**256.
1788         unchecked {
1789             // Updates:
1790             // - `balance += quantity`.
1791             // - `numberMinted += quantity`.
1792             //
1793             // We can directly add to the `balance` and `numberMinted`.
1794             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1795 
1796             // Updates:
1797             // - `address` to the owner.
1798             // - `startTimestamp` to the timestamp of minting.
1799             // - `burned` to `false`.
1800             // - `nextInitialized` to `quantity == 1`.
1801             _packedOwnerships[startTokenId] = _packOwnershipData(
1802                 to,
1803                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1804             );
1805 
1806             uint256 toMasked;
1807             uint256 end = startTokenId + quantity;
1808 
1809             // Use assembly to loop and emit the `Transfer` event for gas savings.
1810             // The duplicated `log4` removes an extra check and reduces stack juggling.
1811             // The assembly, together with the surrounding Solidity code, have been
1812             // delicately arranged to nudge the compiler into producing optimized opcodes.
1813             assembly {
1814                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1815                 toMasked := and(to, _BITMASK_ADDRESS)
1816                 // Emit the `Transfer` event.
1817                 log4(
1818                     0, // Start of data (0, since no data).
1819                     0, // End of data (0, since no data).
1820                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1821                     0, // `address(0)`.
1822                     toMasked, // `to`.
1823                     startTokenId // `tokenId`.
1824                 )
1825 
1826                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1827                 // that overflows uint256 will make the loop run out of gas.
1828                 // The compiler will optimize the `iszero` away for performance.
1829                 for {
1830                     let tokenId := add(startTokenId, 1)
1831                 } iszero(eq(tokenId, end)) {
1832                     tokenId := add(tokenId, 1)
1833                 } {
1834                     // Emit the `Transfer` event. Similar to above.
1835                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1836                 }
1837             }
1838             if (toMasked == 0) revert MintToZeroAddress();
1839 
1840             _currentIndex = end;
1841         }
1842         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1843     }
1844 
1845     /**
1846      * @dev Mints `quantity` tokens and transfers them to `to`.
1847      *
1848      * This function is intended for efficient minting only during contract creation.
1849      *
1850      * It emits only one {ConsecutiveTransfer} as defined in
1851      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1852      * instead of a sequence of {Transfer} event(s).
1853      *
1854      * Calling this function outside of contract creation WILL make your contract
1855      * non-compliant with the ERC721 standard.
1856      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1857      * {ConsecutiveTransfer} event is only permissible during contract creation.
1858      *
1859      * Requirements:
1860      *
1861      * - `to` cannot be the zero address.
1862      * - `quantity` must be greater than 0.
1863      *
1864      * Emits a {ConsecutiveTransfer} event.
1865      */
1866     function _mintERC2309(address to, uint256 quantity) internal virtual {
1867         uint256 startTokenId = _currentIndex;
1868         if (to == address(0)) revert MintToZeroAddress();
1869         if (quantity == 0) revert MintZeroQuantity();
1870         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1871 
1872         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1873 
1874         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1875         unchecked {
1876             // Updates:
1877             // - `balance += quantity`.
1878             // - `numberMinted += quantity`.
1879             //
1880             // We can directly add to the `balance` and `numberMinted`.
1881             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1882 
1883             // Updates:
1884             // - `address` to the owner.
1885             // - `startTimestamp` to the timestamp of minting.
1886             // - `burned` to `false`.
1887             // - `nextInitialized` to `quantity == 1`.
1888             _packedOwnerships[startTokenId] = _packOwnershipData(
1889                 to,
1890                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1891             );
1892 
1893             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1894 
1895             _currentIndex = startTokenId + quantity;
1896         }
1897         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1898     }
1899 
1900     /**
1901      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1902      *
1903      * Requirements:
1904      *
1905      * - If `to` refers to a smart contract, it must implement
1906      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1907      * - `quantity` must be greater than 0.
1908      *
1909      * See {_mint}.
1910      *
1911      * Emits a {Transfer} event for each mint.
1912      */
1913     function _safeMint(
1914         address to,
1915         uint256 quantity,
1916         bytes memory _data
1917     ) internal virtual {
1918         _mint(to, quantity);
1919 
1920         unchecked {
1921             if (to.code.length != 0) {
1922                 uint256 end = _currentIndex;
1923                 uint256 index = end - quantity;
1924                 do {
1925                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1926                         revert TransferToNonERC721ReceiverImplementer();
1927                     }
1928                 } while (index < end);
1929                 // Reentrancy protection.
1930                 if (_currentIndex != end) revert();
1931             }
1932         }
1933     }
1934 
1935     /**
1936      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1937      */
1938     function _safeMint(address to, uint256 quantity) internal virtual {
1939         _safeMint(to, quantity, '');
1940     }
1941 
1942     // =============================================================
1943     //                        BURN OPERATIONS
1944     // =============================================================
1945 
1946     /**
1947      * @dev Equivalent to `_burn(tokenId, false)`.
1948      */
1949     function _burn(uint256 tokenId) internal virtual {
1950         _burn(tokenId, false);
1951     }
1952 
1953     /**
1954      * @dev Destroys `tokenId`.
1955      * The approval is cleared when the token is burned.
1956      *
1957      * Requirements:
1958      *
1959      * - `tokenId` must exist.
1960      *
1961      * Emits a {Transfer} event.
1962      */
1963     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1964         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1965 
1966         address from = address(uint160(prevOwnershipPacked));
1967 
1968         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1969 
1970         if (approvalCheck) {
1971             // The nested ifs save around 20+ gas over a compound boolean condition.
1972             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1973                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1974         }
1975 
1976         _beforeTokenTransfers(from, address(0), tokenId, 1);
1977 
1978         // Clear approvals from the previous owner.
1979         assembly {
1980             if approvedAddress {
1981                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1982                 sstore(approvedAddressSlot, 0)
1983             }
1984         }
1985 
1986         // Underflow of the sender's balance is impossible because we check for
1987         // ownership above and the recipient's balance can't realistically overflow.
1988         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1989         unchecked {
1990             // Updates:
1991             // - `balance -= 1`.
1992             // - `numberBurned += 1`.
1993             //
1994             // We can directly decrement the balance, and increment the number burned.
1995             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1996             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1997 
1998             // Updates:
1999             // - `address` to the last owner.
2000             // - `startTimestamp` to the timestamp of burning.
2001             // - `burned` to `true`.
2002             // - `nextInitialized` to `true`.
2003             _packedOwnerships[tokenId] = _packOwnershipData(
2004                 from,
2005                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2006             );
2007 
2008             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2009             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2010                 uint256 nextTokenId = tokenId + 1;
2011                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2012                 if (_packedOwnerships[nextTokenId] == 0) {
2013                     // If the next slot is within bounds.
2014                     if (nextTokenId != _currentIndex) {
2015                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2016                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2017                     }
2018                 }
2019             }
2020         }
2021 
2022         emit Transfer(from, address(0), tokenId);
2023         _afterTokenTransfers(from, address(0), tokenId, 1);
2024 
2025         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2026         unchecked {
2027             _burnCounter++;
2028         }
2029     }
2030 
2031     // =============================================================
2032     //                     EXTRA DATA OPERATIONS
2033     // =============================================================
2034 
2035     /**
2036      * @dev Directly sets the extra data for the ownership data `index`.
2037      */
2038     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2039         uint256 packed = _packedOwnerships[index];
2040         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2041         uint256 extraDataCasted;
2042         // Cast `extraData` with assembly to avoid redundant masking.
2043         assembly {
2044             extraDataCasted := extraData
2045         }
2046         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2047         _packedOwnerships[index] = packed;
2048     }
2049 
2050     /**
2051      * @dev Called during each token transfer to set the 24bit `extraData` field.
2052      * Intended to be overridden by the cosumer contract.
2053      *
2054      * `previousExtraData` - the value of `extraData` before transfer.
2055      *
2056      * Calling conditions:
2057      *
2058      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2059      * transferred to `to`.
2060      * - When `from` is zero, `tokenId` will be minted for `to`.
2061      * - When `to` is zero, `tokenId` will be burned by `from`.
2062      * - `from` and `to` are never both zero.
2063      */
2064     function _extraData(
2065         address from,
2066         address to,
2067         uint24 previousExtraData
2068     ) internal view virtual returns (uint24) {}
2069 
2070     /**
2071      * @dev Returns the next extra data for the packed ownership data.
2072      * The returned result is shifted into position.
2073      */
2074     function _nextExtraData(
2075         address from,
2076         address to,
2077         uint256 prevOwnershipPacked
2078     ) private view returns (uint256) {
2079         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2080         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2081     }
2082 
2083     // =============================================================
2084     //                       OTHER OPERATIONS
2085     // =============================================================
2086 
2087     /**
2088      * @dev Returns the message sender (defaults to `msg.sender`).
2089      *
2090      * If you are writing GSN compatible contracts, you need to override this function.
2091      */
2092     function _msgSenderERC721A() internal view virtual returns (address) {
2093         return msg.sender;
2094     }
2095 
2096     /**
2097      * @dev Converts a uint256 to its ASCII string decimal representation.
2098      */
2099     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2100         assembly {
2101             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2102             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2103             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2104             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2105             let m := add(mload(0x40), 0xa0)
2106             // Update the free memory pointer to allocate.
2107             mstore(0x40, m)
2108             // Assign the `str` to the end.
2109             str := sub(m, 0x20)
2110             // Zeroize the slot after the string.
2111             mstore(str, 0)
2112 
2113             // Cache the end of the memory to calculate the length later.
2114             let end := str
2115 
2116             // We write the string from rightmost digit to leftmost digit.
2117             // The following is essentially a do-while loop that also handles the zero case.
2118             // prettier-ignore
2119             for { let temp := value } 1 {} {
2120                 str := sub(str, 1)
2121                 // Write the character to the pointer.
2122                 // The ASCII index of the '0' character is 48.
2123                 mstore8(str, add(48, mod(temp, 10)))
2124                 // Keep dividing `temp` until zero.
2125                 temp := div(temp, 10)
2126                 // prettier-ignore
2127                 if iszero(temp) { break }
2128             }
2129 
2130             let length := sub(end, str)
2131             // Move the pointer 32 bytes leftwards to make room for the length.
2132             str := sub(str, 0x20)
2133             // Store the length.
2134             mstore(str, length)
2135         }
2136     }
2137 }
2138 
2139 // File: contracts/blockchainrocks.sol
2140 
2141 
2142 
2143 pragma solidity ^0.8.0;
2144 
2145 
2146 
2147 
2148 
2149 
2150 
2151 
2152 
2153 
2154 
2155 
2156 /***
2157  *                                                                      
2158  *                                                                      
2159  *        .         .-.        .  .       .            .     ,   .  .-. 
2160  *        |        :   :       |  |       |          .'|    /  .'| (   )
2161  *     .-.|--. .--.|   |.--.--.'--|-.--.  |.-. .  .    |   /-.   |  >-< 
2162  *    (   |  | |   :   ;|  |  |   | `--.  |   )|  |    |  (   )  | (   )
2163  *     `-''  `-'    `-' '  '  `-  ' `--'  '`-' `--|  '---'o`-' '---'`-' 
2164  *                                                ;                     
2165  *                                             `-'                      
2166  */
2167 
2168 
2169 contract chr0m4s is ERC721A, Ownable, ReentrancyGuard {
2170   using Address for address;
2171   using Strings for uint;
2172 
2173 
2174   string  public  baseTokenURI = "ipfs://bafybeiheyqdbjmhjp5lqh7s7sx7bsezbqqxfmyvlbtw333cvfamogeqrn4/";
2175   uint256 public  maxSupply = 1618;
2176   uint256 public  MAX_MINTS_PER_TX = 4;
2177   uint256 public  PUBLIC_SALE_PRICE = 0.0025 ether;
2178   uint256 public  NUM_FREE_MINTS = 500;
2179   uint256 public  MAX_FREE_PER_WALLET = 1;
2180   uint256 public freeAlreadyMinted = 0;
2181   bool public isPublicSaleActive = false;
2182   constructor() ERC721A("chr0m4s by 1.618", "chr0m4") {
2183       
2184   }
2185 
2186 
2187   function mint(uint256 numberOfTokens)
2188       external
2189       payable
2190   {
2191     require(isPublicSaleActive, "1.618");
2192     require(totalSupply() + numberOfTokens < maxSupply + 1, "1.618");
2193 
2194     if(freeAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2195         require(
2196             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2197             "1.618"
2198         );
2199     } else {
2200         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2201         require(
2202             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2203             "1.618"
2204         );
2205         require(
2206             numberOfTokens <= MAX_MINTS_PER_TX,
2207             "1.618"
2208         );
2209         } else {
2210             require(
2211                 numberOfTokens <= MAX_FREE_PER_WALLET,
2212                 "1.618"
2213             );
2214             freeAlreadyMinted += numberOfTokens;
2215         }
2216     }
2217     _safeMint(msg.sender, numberOfTokens);
2218   }
2219 
2220   function setBaseURI(string memory baseURI)
2221     public
2222     onlyOwner
2223   {
2224     baseTokenURI = baseURI;
2225   }
2226 
2227   function treasuryMint(uint quantity)
2228     public
2229     onlyOwner
2230   {
2231     require(
2232       quantity > 0,
2233       "1.618"
2234     );
2235     require(
2236       totalSupply() + quantity <= maxSupply,
2237       "1.618"
2238     );
2239     _safeMint(msg.sender, quantity);
2240   }
2241 
2242   function withdraw()
2243     public
2244     onlyOwner
2245     nonReentrant
2246   {
2247     Address.sendValue(payable(msg.sender), address(this).balance);
2248   }
2249 
2250   function _baseURI()
2251     internal
2252     view
2253     virtual
2254     override
2255     returns (string memory)
2256   {
2257     return baseTokenURI;
2258   }
2259 
2260   function setIsPublicSaleActive(bool _isPublicSaleActive)
2261       external
2262       onlyOwner
2263   {
2264       isPublicSaleActive = _isPublicSaleActive;
2265   }
2266 
2267   function setNumFreeMints(uint256 _numfreemints)
2268       external
2269       onlyOwner
2270   {
2271       NUM_FREE_MINTS = _numfreemints;
2272   }
2273 
2274   function setSalePrice(uint256 _price)
2275       external
2276       onlyOwner
2277   {
2278       PUBLIC_SALE_PRICE = _price;
2279   }
2280 
2281   function setMaxLimitPerTransaction(uint256 _limit)
2282       external
2283       onlyOwner
2284   {
2285       MAX_MINTS_PER_TX = _limit;
2286   }
2287 
2288   function setFreeLimitPerWallet(uint256 _limit)
2289       external
2290       onlyOwner
2291   {
2292       MAX_FREE_PER_WALLET = _limit;
2293   }
2294 }