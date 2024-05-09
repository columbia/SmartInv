1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /// [MIT License]
6 /// @title Base64
7 /// @notice Provides a function for encoding some bytes in base64
8 /// @author Brecht Devos <brecht@loopring.org>
9 library Base64 {
10     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
11 
12     /// @notice Encodes some bytes to the base64 representation
13     function encode(bytes memory data) internal pure returns (string memory) {
14         uint256 len = data.length;
15         if (len == 0) return "";
16 
17         // multiply by 4/3 rounded up
18         uint256 encodedLen = 4 * ((len + 2) / 3);
19 
20         // Add some extra buffer at the end
21         bytes memory result = new bytes(encodedLen + 32);
22 
23         bytes memory table = TABLE;
24 
25         assembly {
26             let tablePtr := add(table, 1)
27             let resultPtr := add(result, 32)
28 
29             for {
30                 let i := 0
31             } lt(i, len) {
32 
33             } {
34                 i := add(i, 3)
35                 let input := and(mload(add(data, i)), 0xffffff)
36 
37                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
38                 out := shl(8, out)
39                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
40                 out := shl(8, out)
41                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
42                 out := shl(8, out)
43                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
44                 out := shl(224, out)
45 
46                 mstore(resultPtr, out)
47 
48                 resultPtr := add(resultPtr, 4)
49             }
50 
51             switch mod(len, 3)
52             case 1 {
53                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
54             }
55             case 2 {
56                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
57             }
58 
59             mstore(result, encodedLen)
60         }
61 
62         return string(result);
63     }
64 }
65 
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79     uint8 private constant _ADDRESS_LENGTH = 20;
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
139      */
140     function toHexString(address addr) internal pure returns (string memory) {
141         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         _checkOwner();
209         _;
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if the sender is not the owner.
221      */
222     function _checkOwner() internal view virtual {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 
258 /**
259  * @dev Contract module that helps prevent reentrant calls to a function.
260  *
261  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
262  * available, which can be applied to functions to make sure there are no nested
263  * (reentrant) calls to them.
264  *
265  * Note that because there is a single `nonReentrant` guard, functions marked as
266  * `nonReentrant` may not call one another. This can be worked around by making
267  * those functions `private`, and then adding `external` `nonReentrant` entry
268  * points to them.
269  *
270  * TIP: If you would like to learn more about reentrancy and alternative ways
271  * to protect against it, check out our blog post
272  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
273  */
274 abstract contract ReentrancyGuard {
275     // Booleans are more expensive than uint256 or any type that takes up a full
276     // word because each write operation emits an extra SLOAD to first read the
277     // slot's contents, replace the bits taken up by the boolean, and then write
278     // back. This is the compiler's defense against contract upgrades and
279     // pointer aliasing, and it cannot be disabled.
280 
281     // The values being non-zero value makes deployment a bit more expensive,
282     // but in exchange the refund on every call to nonReentrant will be lower in
283     // amount. Since refunds are capped to a percentage of the total
284     // transaction's gas, it is best to keep them low in cases like this one, to
285     // increase the likelihood of the full refund coming into effect.
286     uint256 private constant _NOT_ENTERED = 1;
287     uint256 private constant _ENTERED = 2;
288 
289     uint256 private _status;
290 
291     constructor() {
292         _status = _NOT_ENTERED;
293     }
294 
295     /**
296      * @dev Prevents a contract from calling itself, directly or indirectly.
297      * Calling a `nonReentrant` function from another `nonReentrant`
298      * function is not supported. It is possible to prevent this from happening
299      * by making the `nonReentrant` function external, and make it call a
300      * `private` function that does the actual work.
301      */
302     modifier nonReentrant() {
303         // On the first call to nonReentrant, _notEntered will be true
304         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
305 
306         // Any calls to nonReentrant after this point will fail
307         _status = _ENTERED;
308 
309         _;
310 
311         // By storing the original value once again, a refund is triggered (see
312         // https://eips.ethereum.org/EIPS/eip-2200)
313         _status = _NOT_ENTERED;
314     }
315 }
316 
317 
318 
319 // File: @openzeppelin/contracts/utils/Address.sol
320 
321 
322 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
323 
324 pragma solidity ^0.8.1;
325 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      *
347      * [IMPORTANT]
348      * ====
349      * You shouldn't rely on `isContract` to protect against flash loan attacks!
350      *
351      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
352      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
353      * constructor.
354      * ====
355      */
356     function isContract(address account) internal view returns (bool) {
357         // This method relies on extcodesize/address.code.length, which returns 0
358         // for contracts in construction, since the code is only stored at the end
359         // of the constructor execution.
360 
361         return account.code.length > 0;
362     }
363 
364     /**
365      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
366      * `recipient`, forwarding all available gas and reverting on errors.
367      *
368      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
369      * of certain opcodes, possibly making contracts go over the 2300 gas limit
370      * imposed by `transfer`, making them unable to receive funds via
371      * `transfer`. {sendValue} removes this limitation.
372      *
373      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
374      *
375      * IMPORTANT: because control is transferred to `recipient`, care must be
376      * taken to not create reentrancy vulnerabilities. Consider using
377      * {ReentrancyGuard} or the
378      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
379      */
380     function sendValue(address payable recipient, uint256 amount) internal {
381         require(address(this).balance >= amount, "Address: insufficient balance");
382 
383         (bool success, ) = recipient.call{value: amount}("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388      * @dev Performs a Solidity function call using a low level `call`. A
389      * plain `call` is an unsafe replacement for a function call: use this
390      * function instead.
391      *
392      * If `target` reverts with a revert reason, it is bubbled up by this
393      * function (like regular Solidity function calls).
394      *
395      * Returns the raw returned data. To convert to the expected return value,
396      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397      *
398      * Requirements:
399      *
400      * - `target` must be a contract.
401      * - calling `target` with `data` must not revert.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411      * `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, 0, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but also transferring `value` wei to `target`.
426      *
427      * Requirements:
428      *
429      * - the calling contract must have an ETH balance of at least `value`.
430      * - the called Solidity function must be `payable`.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(address(this).balance >= value, "Address: insufficient balance for call");
455         require(isContract(target), "Address: call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.call{value: value}(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
468         return functionStaticCall(target, data, "Address: low-level static call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal view returns (bytes memory) {
482         require(isContract(target), "Address: static call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.staticcall(data);
485         return verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(isContract(target), "Address: delegate call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.delegatecall(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
517      * revert reason using the provided one.
518      *
519      * _Available since v4.3._
520      */
521     function verifyCallResult(
522         bool success,
523         bytes memory returndata,
524         string memory errorMessage
525     ) internal pure returns (bytes memory) {
526         if (success) {
527             return returndata;
528         } else {
529             // Look for revert reason and bubble it up if present
530             if (returndata.length > 0) {
531                 // The easiest way to bubble the revert reason is using memory via assembly
532                 /// @solidity memory-safe-assembly
533                 assembly {
534                     let returndata_size := mload(returndata)
535                     revert(add(32, returndata), returndata_size)
536                 }
537             } else {
538                 revert(errorMessage);
539             }
540         }
541     }
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
545 
546 
547 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @title ERC721 token receiver interface
553  * @dev Interface for any contract that wants to support safeTransfers
554  * from ERC721 asset contracts.
555  */
556 interface IERC721Receiver {
557     /**
558      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
559      * by `operator` from `from`, this function is called.
560      *
561      * It must return its Solidity selector to confirm the token transfer.
562      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
563      *
564      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
565      */
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Interface of the ERC165 standard, as defined in the
583  * https://eips.ethereum.org/EIPS/eip-165[EIP].
584  *
585  * Implementers can declare support of contract interfaces, which can then be
586  * queried by others ({ERC165Checker}).
587  *
588  * For an implementation, see {ERC165}.
589  */
590 interface IERC165 {
591     /**
592      * @dev Returns true if this contract implements the interface defined by
593      * `interfaceId`. See the corresponding
594      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
595      * to learn more about how these ids are created.
596      *
597      * This function call must use less than 30 000 gas.
598      */
599     function supportsInterface(bytes4 interfaceId) external view returns (bool);
600 }
601 
602 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @dev Implementation of the {IERC165} interface.
612  *
613  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
614  * for the additional interface id that will be supported. For example:
615  *
616  * ```solidity
617  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
619  * }
620  * ```
621  *
622  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
623  */
624 abstract contract ERC165 is IERC165 {
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
634 
635 
636 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Required interface of an ERC721 compliant contract.
643  */
644 interface IERC721 is IERC165 {
645     /**
646      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
647      */
648     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
649 
650     /**
651      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
652      */
653     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
654 
655     /**
656      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
657      */
658     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
659 
660     /**
661      * @dev Returns the number of tokens in ``owner``'s account.
662      */
663     function balanceOf(address owner) external view returns (uint256 balance);
664 
665     /**
666      * @dev Returns the owner of the `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function ownerOf(uint256 tokenId) external view returns (address owner);
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes calldata data
692     ) external;
693 
694     /**
695      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
696      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must exist and be owned by `from`.
703      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
704      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
705      *
706      * Emits a {Transfer} event.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) external;
713 
714     /**
715      * @dev Transfers `tokenId` token from `from` to `to`.
716      *
717      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must be owned by `from`.
724      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
725      *
726      * Emits a {Transfer} event.
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) external;
733 
734     /**
735      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
736      * The approval is cleared when the token is transferred.
737      *
738      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
739      *
740      * Requirements:
741      *
742      * - The caller must own the token or be an approved operator.
743      * - `tokenId` must exist.
744      *
745      * Emits an {Approval} event.
746      */
747     function approve(address to, uint256 tokenId) external;
748 
749     /**
750      * @dev Approve or remove `operator` as an operator for the caller.
751      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
752      *
753      * Requirements:
754      *
755      * - The `operator` cannot be the caller.
756      *
757      * Emits an {ApprovalForAll} event.
758      */
759     function setApprovalForAll(address operator, bool _approved) external;
760 
761     /**
762      * @dev Returns the account approved for `tokenId` token.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function getApproved(uint256 tokenId) external view returns (address operator);
769 
770     /**
771      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
772      *
773      * See {setApprovalForAll}
774      */
775     function isApprovedForAll(address owner, address operator) external view returns (bool);
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
779 
780 
781 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
788  * @dev See https://eips.ethereum.org/EIPS/eip-721
789  */
790 interface IERC721Metadata is IERC721 {
791     /**
792      * @dev Returns the token collection name.
793      */
794     function name() external view returns (string memory);
795 
796     /**
797      * @dev Returns the token collection symbol.
798      */
799     function symbol() external view returns (string memory);
800 
801     /**
802      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
803      */
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 }
806 
807 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
808 
809 
810 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
816  * the Metadata extension, but not including the Enumerable extension, which is available separately as
817  * {ERC721Enumerable}.
818  */
819 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
820     using Address for address;
821     using Strings for uint256;
822 
823     // Token name
824     string private _name;
825 
826     // Token symbol
827     string private _symbol;
828 
829     // Mapping from token ID to owner address
830     mapping(uint256 => address) private _owners;
831 
832     // Mapping owner address to token count
833     mapping(address => uint256) private _balances;
834 
835     // Mapping from token ID to approved address
836     mapping(uint256 => address) private _tokenApprovals;
837 
838     // Mapping from owner to operator approvals
839     mapping(address => mapping(address => bool)) private _operatorApprovals;
840 
841     /**
842      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
843      */
844     constructor(string memory name_, string memory symbol_) {
845         _name = name_;
846         _symbol = symbol_;
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
853         return
854             interfaceId == type(IERC721).interfaceId ||
855             interfaceId == type(IERC721Metadata).interfaceId ||
856             super.supportsInterface(interfaceId);
857     }
858 
859     /**
860      * @dev See {IERC721-balanceOf}.
861      */
862     function balanceOf(address owner) public view virtual override returns (uint256) {
863         require(owner != address(0), "ERC721: address zero is not a valid owner");
864         return _balances[owner];
865     }
866 
867     /**
868      * @dev See {IERC721-ownerOf}.
869      */
870     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
871         address owner = _owners[tokenId];
872         require(owner != address(0), "ERC721: invalid token ID");
873         return owner;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-name}.
878      */
879     function name() public view virtual override returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-symbol}.
885      */
886     function symbol() public view virtual override returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         _requireMinted(tokenId);
895 
896         string memory baseURI = _baseURI();
897         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, can be overridden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return "";
907     }
908 
909     /**
910      * @dev See {IERC721-approve}.
911      */
912     function approve(address to, uint256 tokenId) public virtual override {
913         address owner = ERC721.ownerOf(tokenId);
914         require(to != owner, "ERC721: approval to current owner");
915 
916         require(
917             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
918             "ERC721: approve caller is not token owner nor approved for all"
919         );
920 
921         _approve(to, tokenId);
922     }
923 
924     /**
925      * @dev See {IERC721-getApproved}.
926      */
927     function getApproved(uint256 tokenId) public view virtual override returns (address) {
928         _requireMinted(tokenId);
929 
930         return _tokenApprovals[tokenId];
931     }
932 
933     /**
934      * @dev See {IERC721-setApprovalForAll}.
935      */
936     function setApprovalForAll(address operator, bool approved) public virtual override {
937         _setApprovalForAll(_msgSender(), operator, approved);
938     }
939 
940     /**
941      * @dev See {IERC721-isApprovedForAll}.
942      */
943     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
944         return _operatorApprovals[owner][operator];
945     }
946 
947     /**
948      * @dev See {IERC721-transferFrom}.
949      */
950     function transferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         //solhint-disable-next-line max-line-length
956         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
957 
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         safeTransferFrom(from, to, tokenId, "");
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory data
980     ) public virtual override {
981         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
982         _safeTransfer(from, to, tokenId, data);
983     }
984 
985     /**
986      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
987      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
988      *
989      * `data` is additional data, it has no specified format and it is sent in call to `to`.
990      *
991      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
992      * implement alternative mechanisms to perform token transfer, such as signature-based.
993      *
994      * Requirements:
995      *
996      * - `from` cannot be the zero address.
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must exist and be owned by `from`.
999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _safeTransfer(
1004         address from,
1005         address to,
1006         uint256 tokenId,
1007         bytes memory data
1008     ) internal virtual {
1009         _transfer(from, to, tokenId);
1010         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1011     }
1012 
1013     /**
1014      * @dev Returns whether `tokenId` exists.
1015      *
1016      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1017      *
1018      * Tokens start existing when they are minted (`_mint`),
1019      * and stop existing when they are burned (`_burn`).
1020      */
1021     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1022         return _owners[tokenId] != address(0);
1023     }
1024 
1025     /**
1026      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      */
1032     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1033         address owner = ERC721.ownerOf(tokenId);
1034         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1035     }
1036 
1037     /**
1038      * @dev Safely mints `tokenId` and transfers it to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must not exist.
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _safeMint(address to, uint256 tokenId) internal virtual {
1048         _safeMint(to, tokenId, "");
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1053      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1054      */
1055     function _safeMint(
1056         address to,
1057         uint256 tokenId,
1058         bytes memory data
1059     ) internal virtual {
1060         _mint(to, tokenId);
1061         require(
1062             _checkOnERC721Received(address(0), to, tokenId, data),
1063             "ERC721: transfer to non ERC721Receiver implementer"
1064         );
1065     }
1066 
1067     /**
1068      * @dev Mints `tokenId` and transfers it to `to`.
1069      *
1070      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must not exist.
1075      * - `to` cannot be the zero address.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _mint(address to, uint256 tokenId) internal virtual {
1080         require(to != address(0), "ERC721: mint to the zero address");
1081         require(!_exists(tokenId), "ERC721: token already minted");
1082 
1083         _beforeTokenTransfer(address(0), to, tokenId);
1084 
1085         _balances[to] += 1;
1086         _owners[tokenId] = to;
1087 
1088         emit Transfer(address(0), to, tokenId);
1089 
1090         _afterTokenTransfer(address(0), to, tokenId);
1091     }
1092 
1093    
1094     /**
1095      * @dev Transfers `tokenId` from `from` to `to`.
1096      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _transfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) internal virtual {
1110         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1111         require(to != address(0), "ERC721: transfer to the zero address");
1112 
1113         _beforeTokenTransfer(from, to, tokenId);
1114 
1115         // Clear approvals from the previous owner
1116         _approve(address(0), tokenId);
1117 
1118         _balances[from] -= 1;
1119         _balances[to] += 1;
1120         _owners[tokenId] = to;
1121 
1122         emit Transfer(from, to, tokenId);
1123 
1124         _afterTokenTransfer(from, to, tokenId);
1125     }
1126 
1127     /**
1128      * @dev Approve `to` to operate on `tokenId`
1129      *
1130      * Emits an {Approval} event.
1131      */
1132     function _approve(address to, uint256 tokenId) internal virtual {
1133         _tokenApprovals[tokenId] = to;
1134         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev Approve `operator` to operate on all of `owner` tokens
1139      *
1140      * Emits an {ApprovalForAll} event.
1141      */
1142     function _setApprovalForAll(
1143         address owner,
1144         address operator,
1145         bool approved
1146     ) internal virtual {
1147         require(owner != operator, "ERC721: approve to caller");
1148         _operatorApprovals[owner][operator] = approved;
1149         emit ApprovalForAll(owner, operator, approved);
1150     }
1151 
1152     /**
1153      * @dev Reverts if the `tokenId` has not been minted yet.
1154      */
1155     function _requireMinted(uint256 tokenId) internal view virtual {
1156         require(_exists(tokenId), "ERC721: invalid token ID");
1157     }
1158 
1159     /**
1160      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1161      * The call is not executed if the target address is not a contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory data
1174     ) private returns (bool) {
1175         if (to.isContract()) {
1176             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1177                 return retval == IERC721Receiver.onERC721Received.selector;
1178             } catch (bytes memory reason) {
1179                 if (reason.length == 0) {
1180                     revert("ERC721: transfer to non ERC721Receiver implementer");
1181                 } else {
1182                     /// @solidity memory-safe-assembly
1183                     assembly {
1184                         revert(add(32, reason), mload(reason))
1185                     }
1186                 }
1187             }
1188         } else {
1189             return true;
1190         }
1191     }
1192 
1193     /**
1194      * @dev Hook that is called before any token transfer. This includes minting
1195      * and burning.
1196      *
1197      * Calling conditions:
1198      *
1199      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1200      * transferred to `to`.
1201      * - When `from` is zero, `tokenId` will be minted for `to`.
1202      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1203      * - `from` and `to` are never both zero.
1204      *
1205      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1206      */
1207     function _beforeTokenTransfer(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) internal virtual {}
1212 
1213     /**
1214      * @dev Hook that is called after any transfer of tokens. This includes
1215      * minting and burning.
1216      *
1217      * Calling conditions:
1218      *
1219      * - when `from` and `to` are both non-zero.
1220      * - `from` and `to` are never both zero.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _afterTokenTransfer(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) internal virtual {}
1229 }
1230 
1231 interface IERC721Enumerable is IERC721 {
1232     /**
1233      * @dev Returns the total amount of tokens stored by the contract.
1234      */
1235     function totalSupply() external view returns (uint256);
1236 
1237     /**
1238      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1239      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1240      */
1241     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1242 
1243     /**
1244      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1245      * Use along with {totalSupply} to enumerate all tokens.
1246      */
1247     function tokenByIndex(uint256 index) external view returns (uint256);
1248 }
1249 
1250 
1251 /**
1252  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1253  * enumerability of all the token ids in the contract as well as all token ids owned by each
1254  * account.
1255  */
1256 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1257     // Mapping from owner to list of owned token IDs
1258     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1259 
1260     // Mapping from token ID to index of the owner tokens list
1261     mapping(uint256 => uint256) private _ownedTokensIndex;
1262 
1263     // Array with all token ids, used for enumeration
1264     uint256[] private _allTokens;
1265 
1266     // Mapping from token id to position in the allTokens array
1267     mapping(uint256 => uint256) private _allTokensIndex;
1268 
1269     /**
1270      * @dev See {IERC165-supportsInterface}.
1271      */
1272     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1273         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1278      */
1279     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1280         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1281         return _ownedTokens[owner][index];
1282     }
1283 
1284     /**
1285      * @dev See {IERC721Enumerable-totalSupply}.
1286      */
1287     function totalSupply() public view virtual override returns (uint256) {
1288         return _allTokens.length;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenByIndex}.
1293      */
1294     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1295         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1296         return _allTokens[index];
1297     }
1298 
1299     /**
1300      * @dev Hook that is called before any token transfer. This includes minting
1301      * and burning.
1302      *
1303      * Calling conditions:
1304      *
1305      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1306      * transferred to `to`.
1307      * - When `from` is zero, `tokenId` will be minted for `to`.
1308      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1309      * - `from` cannot be the zero address.
1310      * - `to` cannot be the zero address.
1311      *
1312      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1313      */
1314     function _beforeTokenTransfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) internal virtual override {
1319         super._beforeTokenTransfer(from, to, tokenId);
1320 
1321         if (from == address(0)) {
1322             _addTokenToAllTokensEnumeration(tokenId);
1323         } else if (from != to) {
1324             _removeTokenFromOwnerEnumeration(from, tokenId);
1325         }
1326         if (to == address(0)) {
1327             _removeTokenFromAllTokensEnumeration(tokenId);
1328         } else if (to != from) {
1329             _addTokenToOwnerEnumeration(to, tokenId);
1330         }
1331     }
1332 
1333     /**
1334      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1335      * @param to address representing the new owner of the given token ID
1336      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1337      */
1338     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1339         uint256 length = ERC721.balanceOf(to);
1340         _ownedTokens[to][length] = tokenId;
1341         _ownedTokensIndex[tokenId] = length;
1342     }
1343 
1344     /**
1345      * @dev Private function to add a token to this extension's token tracking data structures.
1346      * @param tokenId uint256 ID of the token to be added to the tokens list
1347      */
1348     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1349         _allTokensIndex[tokenId] = _allTokens.length;
1350         _allTokens.push(tokenId);
1351     }
1352 
1353     /**
1354      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1355      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1356      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1357      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1358      * @param from address representing the previous owner of the given token ID
1359      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1360      */
1361     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1362         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1363         // then delete the last slot (swap and pop).
1364 
1365         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1366         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1367 
1368         // When the token to delete is the last token, the swap operation is unnecessary
1369         if (tokenIndex != lastTokenIndex) {
1370             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1371 
1372             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374         }
1375 
1376         // This also deletes the contents at the last position of the array
1377         delete _ownedTokensIndex[tokenId];
1378         delete _ownedTokens[from][lastTokenIndex];
1379     }
1380 
1381     /**
1382      * @dev Private function to remove a token from this extension's token tracking data structures.
1383      * This has O(1) time complexity, but alters the order of the _allTokens array.
1384      * @param tokenId uint256 ID of the token to be removed from the tokens list
1385      */
1386     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1387         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1388         // then delete the last slot (swap and pop).
1389 
1390         uint256 lastTokenIndex = _allTokens.length - 1;
1391         uint256 tokenIndex = _allTokensIndex[tokenId];
1392 
1393         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1394         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1395         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1396         uint256 lastTokenId = _allTokens[lastTokenIndex];
1397 
1398         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1399         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1400 
1401         // This also deletes the contents at the last position of the array
1402         delete _allTokensIndex[tokenId];
1403         _allTokens.pop();
1404     }
1405 }
1406 
1407 
1408 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
1409 
1410 pragma solidity ^0.8.13;
1411 
1412 interface IOperatorFilterRegistry {
1413     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1414     function register(address registrant) external;
1415     function registerAndSubscribe(address registrant, address subscription) external;
1416     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1417     function unregister(address addr) external;
1418     function updateOperator(address registrant, address operator, bool filtered) external;
1419     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1420     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1421     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1422     function subscribe(address registrant, address registrantToSubscribe) external;
1423     function unsubscribe(address registrant, bool copyExistingEntries) external;
1424     function subscriptionOf(address addr) external returns (address registrant);
1425     function subscribers(address registrant) external returns (address[] memory);
1426     function subscriberAt(address registrant, uint256 index) external returns (address);
1427     function copyEntriesOf(address registrant, address registrantToCopy) external;
1428     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1429     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1430     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1431     function filteredOperators(address addr) external returns (address[] memory);
1432     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1433     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1434     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1435     function isRegistered(address addr) external returns (bool);
1436     function codeHashOf(address addr) external returns (bytes32);
1437 }
1438 
1439 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
1440 pragma solidity ^0.8.13;
1441 
1442 /**
1443  * @title  OperatorFilterer
1444  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1445  *         registrant's entries in the OperatorFilterRegistry.
1446  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1447  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1448  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1449  */
1450 abstract contract OperatorFilterer {
1451     error OperatorNotAllowed(address operator);
1452 
1453     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1454         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1455 
1456     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1457         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1458         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1459         // order for the modifier to filter addresses.
1460         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1461             if (subscribe) {
1462                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1463             } else {
1464                 if (subscriptionOrRegistrantToCopy != address(0)) {
1465                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1466                 } else {
1467                     OPERATOR_FILTER_REGISTRY.register(address(this));
1468                 }
1469             }
1470         }
1471     }
1472 
1473     modifier onlyAllowedOperator(address from) virtual {
1474         // Check registry code length to facilitate testing in environments without a deployed registry.
1475         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1476             // Allow spending tokens from addresses with balance
1477             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1478             // from an EOA.
1479             if (from == msg.sender) {
1480                 _;
1481                 return;
1482             }
1483             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1484                 revert OperatorNotAllowed(msg.sender);
1485             }
1486         }
1487         _;
1488     }
1489 
1490     modifier onlyAllowedOperatorApproval(address operator) virtual {
1491         // Check registry code length to facilitate testing in environments without a deployed registry.
1492         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1493             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1494                 revert OperatorNotAllowed(operator);
1495             }
1496         }
1497         _;
1498     }
1499 }
1500 
1501 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
1502 pragma solidity ^0.8.13;
1503 
1504 /**
1505  * @title  DefaultOperatorFilterer
1506  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1507  */
1508 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1509     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1510 
1511     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1512 }
1513 
1514 pragma solidity ^0.8.0;
1515 
1516 /**
1517  * @dev Contract module which allows children to implement an emergency stop
1518  * mechanism that can be triggered by an authorized account.
1519  *
1520  * This module is used through inheritance. It will make available the
1521  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1522  * the functions of your contract. Note that they will not be pausable by
1523  * simply including this module, only once the modifiers are put in place.
1524  */
1525 abstract contract Pausable is Context {
1526     /**
1527      * @dev Emitted when the pause is triggered by `account`.
1528      */
1529     event Paused(address account);
1530 
1531     /**
1532      * @dev Emitted when the pause is lifted by `account`.
1533      */
1534     event Unpaused(address account);
1535 
1536     bool private _paused;
1537 
1538     /**
1539      * @dev Initializes the contract in unpaused state.
1540      */
1541     constructor() {
1542         _paused = false;
1543     }
1544 
1545     /**
1546      * @dev Returns true if the contract is paused, and false otherwise.
1547      */
1548     function paused() public view virtual returns (bool) {
1549         return _paused;
1550     }
1551 
1552     /**
1553      * @dev Modifier to make a function callable only when the contract is not paused.
1554      *
1555      * Requirements:
1556      *
1557      * - The contract must not be paused.
1558      */
1559     modifier whenNotPaused() {
1560         require(!paused(), "Pausable: paused");
1561         _;
1562     }
1563 
1564     /**
1565      * @dev Modifier to make a function callable only when the contract is paused.
1566      *
1567      * Requirements:
1568      *
1569      * - The contract must be paused.
1570      */
1571     modifier whenPaused() {
1572         require(paused(), "Pausable: not paused");
1573         _;
1574     }
1575 
1576     /**
1577      * @dev Triggers stopped state.
1578      *
1579      * Requirements:
1580      *
1581      * - The contract must not be paused.
1582      */
1583     function _pause() internal virtual whenNotPaused {
1584         _paused = true;
1585         emit Paused(_msgSender());
1586     }
1587 
1588     /**
1589      * @dev Returns to normal state.
1590      *
1591      * Requirements:
1592      *
1593      * - The contract must be paused.
1594      */
1595     function _unpause() internal virtual whenPaused {
1596         _paused = false;
1597         emit Unpaused(_msgSender());
1598     }
1599 }
1600 
1601 pragma solidity ^0.8.0;
1602 
1603 /**
1604  * @dev ERC721 token with pausable token transfers, minting and burning.
1605  *
1606  * Useful for scenarios such as preventing trades until the end of an evaluation
1607  * period, or having an emergency switch for freezing all token transfers in the
1608  * event of a large bug.
1609  */
1610     abstract contract ERC721Pausable is ERC721, Ownable, Pausable {
1611     /**
1612      * @dev See {ERC721-_beforeTokenTransfer}.
1613      *
1614      * Requirements:
1615      *
1616      * - the contract must not be paused.
1617      */
1618     function _beforeTokenTransfer(
1619         address from,
1620         address to,
1621         uint256 tokenId
1622     ) internal virtual override {
1623         super._beforeTokenTransfer(from, to, tokenId);
1624         if (_msgSender() != owner()) {
1625             require(!paused(), "ERC721Pausable: token transfer while paused");
1626         }
1627     }
1628 }
1629 
1630 contract AT is ERC721Enumerable, ReentrancyGuard, DefaultOperatorFilterer, Pausable, Ownable {
1631     
1632     uint256 public price = 60000000000000000; //0.06 ETH
1633     uint256 public constant supplyCap = 1000;
1634 
1635     constructor() ERC721("Adneo Token", "AT") {}
1636 
1637     function tokenURI(uint256 tokenId) public pure override returns (string memory) {
1638         string[4] memory parts;
1639         parts[
1640             0
1641         ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 290 500"><g><rect width="100%" height="100%" fill="#000" border-radius="25px" rx="25" ry="25" /><g shape-rendering="geometricPrecision" transform="translate(1.000000,385.000000) scale(0.005500,-0.005500)" fill="#fff" stroke="none"><path shape-rendering="geometricPrecision" d="M8463 65783 c-4 -10 -352 -997 -774 -2193 l-767 -2175 -1361 -3 c-749 -1 -1361 -5 -1361 -10 0 -4 304 -869 676 -1922 372 -1053 676 -1924 676 -1935 0 -11 -304 -882 -676 -1935 -372 -1053 -676 -1918 -676 -1922 0 -5 612 -9 1361 -10 l1361 -3 772 -2190 772 -2190 1359 0 1359 0 772 2190 772 2190 1361 3 c749 1 1361 5 1361 10 0 4 -304 869 -676 1922 -372 1053 -676 1924 -676 1935 0 11 304 882 676 1935 372 1053 676 1918 676 1922 0 5 -612 9 -1361 10 l-1361 3 -772 2190 -772 2190 -1358 3 c-1285 2 -1357 1 -1363 -15z m2192 -4796 l781 -2322 -802 -3 c-441 -1 -1166 -1 -1611 0 l-809 3 781 2322 780 2323 50 0 50 0 780 -2323z m666 -4904 c-65 -192 -417 -1238 -782 -2325 l-664 -1978 -50 0 -50 0 -664 1978 c-365 1087 -717 2133 -782 2325 l-118 347 1614 0 1614 0 -118 -347z" /></g></g>';
1642 
1643         parts[1] = '<text transform="translate(23.000000,474.000000)" fill="#fff" font-family="sans-serif" font-size="10px" font-weight="bold">';
1644 
1645         parts[2] = string(abi.encodePacked('#', toString(tokenId)));
1646 
1647         parts[3] = '</text></svg>';
1648 
1649         
1650         string memory output = string(
1651             abi.encodePacked(parts[0], parts[1], parts[2], parts[3])
1652         );
1653 
1654         string memory json = Base64.encode(
1655             bytes(
1656                 string(
1657                     abi.encodePacked(
1658                         '{"name": "Adneo Token #',
1659                         toString(tokenId),
1660                         '", "description": "", "image": "data:image/svg+xml;base64,',
1661                         Base64.encode(bytes(output)),
1662                         '"}'
1663                     )
1664                 )
1665             )
1666         );
1667         output = string(abi.encodePacked("data:application/json;base64,", json));
1668 
1669             return output;
1670 
1671     }
1672 
1673     // =============================================================================
1674     
1675     function mint(uint256 tokenId) public payable nonReentrant {
1676         require(tokenId > 0 && tokenId <= 1000, "Token ID invalid");
1677         require(price <= msg.value, "Ether value sent is not correct");
1678         require(!paused(), "Pausable: paused");
1679         _safeMint(_msgSender(), tokenId);
1680     }
1681   
1682     // =============================================================================
1683 
1684     function withdraw() public onlyOwner {
1685         payable(msg.sender).transfer(address(this).balance);
1686           
1687     }    
1688     
1689     // =============================================================================
1690     
1691     function pause(bool val) public onlyOwner {
1692         if (val == true) {
1693             _pause();
1694             return;
1695         }
1696         _unpause();
1697     }
1698 
1699     // =============================================================================
1700   
1701     // Operator Filter Registry https://github.com/ProjectOpenSea/operator-filter-registry
1702     function setApprovalForAll(address operator, bool approved) public override (ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
1703         super.setApprovalForAll(operator, approved);
1704     }
1705 
1706     function approve(address operator, uint256 tokenId) public override (ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
1707         super.approve(operator, tokenId);
1708     }
1709 
1710     function transferFrom(address from, address to, uint256 tokenId) public override (ERC721, IERC721) onlyAllowedOperator(from) {
1711         super.transferFrom(from, to, tokenId);
1712     }
1713 
1714     function safeTransferFrom(address from, address to, uint256 tokenId) public override (ERC721, IERC721) onlyAllowedOperator(from) {
1715         super.safeTransferFrom(from, to, tokenId);
1716     }
1717 
1718     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1719         public
1720         override (ERC721, IERC721) 
1721         onlyAllowedOperator(from)
1722     {
1723         super.safeTransferFrom(from, to, tokenId, data);
1724     }
1725 
1726     
1727     function toString(uint256 value) internal pure returns (string memory) {
1728     // Inspired by OraclizeAPI's implementation - MIT license
1729     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1730 
1731         if (value == 0) {
1732             return "0";
1733         }
1734         uint256 temp = value;
1735         uint256 digits;
1736         while (temp != 0) {
1737             digits++;
1738             temp /= 10;
1739         }
1740         bytes memory buffer = new bytes(digits);
1741         while (value != 0) {
1742             digits -= 1;
1743             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1744             value /= 10;
1745         }
1746         return string(buffer);
1747     }
1748     
1749 }