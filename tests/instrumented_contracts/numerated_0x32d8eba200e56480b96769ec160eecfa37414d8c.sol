1 // File: contracts/Base64.sol
2 
3 // SPDX-License-Identifier: GPL-3.0
4 pragma solidity ^0.8.9;
5 
6 library Base64 {
7     bytes internal constant TABLE =
8         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
9 
10     /// @notice Encodes some bytes to the base64 representation
11     function encode(bytes memory data) internal pure returns (string memory) {
12         uint256 len = data.length;
13         if (len == 0) return "";
14 
15         // multiply by 4/3 rounded up
16         uint256 encodedLen = 4 * ((len + 2) / 3);
17 
18         // Add some extra buffer at the end
19         bytes memory result = new bytes(encodedLen + 32);
20         bytes memory table = TABLE;
21 
22         assembly {
23             let tablePtr := add(table, 1)
24             let resultPtr := add(result, 32)
25             for {
26                 let i := 0
27             } lt(i, len) {
28 
29             } {
30                 i := add(i, 3)
31                 let input := and(mload(add(data, i)), 0xffffff)
32                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
33                 out := shl(8, out)
34                 out := add(
35                     out,
36                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
37                 )
38                 out := shl(8, out)
39                 out := add(
40                     out,
41                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
42                 )
43                 out := shl(8, out)
44                 out := add(
45                     out,
46                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
47                 )
48                 out := shl(224, out)
49                 mstore(resultPtr, out)
50                 resultPtr := add(resultPtr, 4)
51             }
52             switch mod(len, 3)
53             case 1 {
54                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
55             }
56             case 2 {
57                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
58             }
59             mstore(result, encodedLen)
60         }
61         return string(result);
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Context.sol
66 
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev Provides information about the current execution context, including the
72  * sender of the transaction and its data. While these are generally available
73  * via msg.sender and msg.data, they should not be accessed in such a direct
74  * manner, since when dealing with meta-transactions the account sending and
75  * paying for execution may not be the actual sender (as far as an application
76  * is concerned).
77  *
78  * This contract is only required for intermediate, library-like contracts.
79  */
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         return msg.data;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/access/Ownable.sol
91 
92 
93 
94 pragma solidity ^0.8.0;
95 
96 
97 /**
98  * @dev Contract module which provides a basic access control mechanism, where
99  * there is an account (an owner) that can be granted exclusive access to
100  * specific functions.
101  *
102  * By default, the owner account will be the one that deploys the contract. This
103  * can later be changed with {transferOwnership}.
104  *
105  * This module is used through inheritance. It will make available the modifier
106  * `onlyOwner`, which can be applied to your functions to restrict their use to
107  * the owner.
108  */
109 abstract contract Ownable is Context {
110     address private _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115      * @dev Initializes the contract setting the deployer as the initial owner.
116      */
117     constructor() {
118         _setOwner(_msgSender());
119     }
120 
121     /**
122      * @dev Returns the address of the current owner.
123      */
124     function owner() public view virtual returns (address) {
125         return _owner;
126     }
127 
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         require(owner() == _msgSender(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     /**
137      * @dev Leaves the contract without owner. It will not be possible to call
138      * `onlyOwner` functions anymore. Can only be called by the current owner.
139      *
140      * NOTE: Renouncing ownership will leave the contract without an owner,
141      * thereby removing any functionality that is only available to the owner.
142      */
143     function renounceOwnership() public virtual onlyOwner {
144         _setOwner(address(0));
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      * Can only be called by the current owner.
150      */
151     function transferOwnership(address newOwner) public virtual onlyOwner {
152         require(newOwner != address(0), "Ownable: new owner is the zero address");
153         _setOwner(newOwner);
154     }
155 
156     function _setOwner(address newOwner) private {
157         address oldOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(oldOwner, newOwner);
160     }
161 }
162 
163 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
164 
165 
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Contract module that helps prevent reentrant calls to a function.
171  *
172  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
173  * available, which can be applied to functions to make sure there are no nested
174  * (reentrant) calls to them.
175  *
176  * Note that because there is a single `nonReentrant` guard, functions marked as
177  * `nonReentrant` may not call one another. This can be worked around by making
178  * those functions `private`, and then adding `external` `nonReentrant` entry
179  * points to them.
180  *
181  * TIP: If you would like to learn more about reentrancy and alternative ways
182  * to protect against it, check out our blog post
183  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
184  */
185 abstract contract ReentrancyGuard {
186     // Booleans are more expensive than uint256 or any type that takes up a full
187     // word because each write operation emits an extra SLOAD to first read the
188     // slot's contents, replace the bits taken up by the boolean, and then write
189     // back. This is the compiler's defense against contract upgrades and
190     // pointer aliasing, and it cannot be disabled.
191 
192     // The values being non-zero value makes deployment a bit more expensive,
193     // but in exchange the refund on every call to nonReentrant will be lower in
194     // amount. Since refunds are capped to a percentage of the total
195     // transaction's gas, it is best to keep them low in cases like this one, to
196     // increase the likelihood of the full refund coming into effect.
197     uint256 private constant _NOT_ENTERED = 1;
198     uint256 private constant _ENTERED = 2;
199 
200     uint256 private _status;
201 
202     constructor() {
203         _status = _NOT_ENTERED;
204     }
205 
206     /**
207      * @dev Prevents a contract from calling itself, directly or indirectly.
208      * Calling a `nonReentrant` function from another `nonReentrant`
209      * function is not supported. It is possible to prevent this from happening
210      * by making the `nonReentrant` function external, and make it call a
211      * `private` function that does the actual work.
212      */
213     modifier nonReentrant() {
214         // On the first call to nonReentrant, _notEntered will be true
215         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
216 
217         // Any calls to nonReentrant after this point will fail
218         _status = _ENTERED;
219 
220         _;
221 
222         // By storing the original value once again, a refund is triggered (see
223         // https://eips.ethereum.org/EIPS/eip-2200)
224         _status = _NOT_ENTERED;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
229 
230 
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Interface of the ERC165 standard, as defined in the
236  * https://eips.ethereum.org/EIPS/eip-165[EIP].
237  *
238  * Implementers can declare support of contract interfaces, which can then be
239  * queried by others ({ERC165Checker}).
240  *
241  * For an implementation, see {ERC165}.
242  */
243 interface IERC165 {
244     /**
245      * @dev Returns true if this contract implements the interface defined by
246      * `interfaceId`. See the corresponding
247      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
248      * to learn more about how these ids are created.
249      *
250      * This function call must use less than 30 000 gas.
251      */
252     function supportsInterface(bytes4 interfaceId) external view returns (bool);
253 }
254 
255 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
256 
257 
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Required interface of an ERC721 compliant contract.
264  */
265 interface IERC721 is IERC165 {
266     /**
267      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
268      */
269     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
270 
271     /**
272      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
273      */
274     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
275 
276     /**
277      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
278      */
279     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
280 
281     /**
282      * @dev Returns the number of tokens in ``owner``'s account.
283      */
284     function balanceOf(address owner) external view returns (uint256 balance);
285 
286     /**
287      * @dev Returns the owner of the `tokenId` token.
288      *
289      * Requirements:
290      *
291      * - `tokenId` must exist.
292      */
293     function ownerOf(uint256 tokenId) external view returns (address owner);
294 
295     /**
296      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
297      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must exist and be owned by `from`.
304      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
306      *
307      * Emits a {Transfer} event.
308      */
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 tokenId
313     ) external;
314 
315     /**
316      * @dev Transfers `tokenId` token from `from` to `to`.
317      *
318      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must be owned by `from`.
325      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
326      *
327      * Emits a {Transfer} event.
328      */
329     function transferFrom(
330         address from,
331         address to,
332         uint256 tokenId
333     ) external;
334 
335     /**
336      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
337      * The approval is cleared when the token is transferred.
338      *
339      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
340      *
341      * Requirements:
342      *
343      * - The caller must own the token or be an approved operator.
344      * - `tokenId` must exist.
345      *
346      * Emits an {Approval} event.
347      */
348     function approve(address to, uint256 tokenId) external;
349 
350     /**
351      * @dev Returns the account approved for `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function getApproved(uint256 tokenId) external view returns (address operator);
358 
359     /**
360      * @dev Approve or remove `operator` as an operator for the caller.
361      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
362      *
363      * Requirements:
364      *
365      * - The `operator` cannot be the caller.
366      *
367      * Emits an {ApprovalForAll} event.
368      */
369     function setApprovalForAll(address operator, bool _approved) external;
370 
371     /**
372      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
373      *
374      * See {setApprovalForAll}
375      */
376     function isApprovedForAll(address owner, address operator) external view returns (bool);
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must exist and be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
388      *
389      * Emits a {Transfer} event.
390      */
391     function safeTransferFrom(
392         address from,
393         address to,
394         uint256 tokenId,
395         bytes calldata data
396     ) external;
397 }
398 
399 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
400 
401 
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @title ERC721 token receiver interface
407  * @dev Interface for any contract that wants to support safeTransfers
408  * from ERC721 asset contracts.
409  */
410 interface IERC721Receiver {
411     /**
412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
413      * by `operator` from `from`, this function is called.
414      *
415      * It must return its Solidity selector to confirm the token transfer.
416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
417      *
418      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
419      */
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
429 
430 
431 
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
437  * @dev See https://eips.ethereum.org/EIPS/eip-721
438  */
439 interface IERC721Metadata is IERC721 {
440     /**
441      * @dev Returns the token collection name.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the token collection symbol.
447      */
448     function symbol() external view returns (string memory);
449 
450     /**
451      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
452      */
453     function tokenURI(uint256 tokenId) external view returns (string memory);
454 }
455 
456 // File: @openzeppelin/contracts/utils/Address.sol
457 
458 
459 
460 pragma solidity ^0.8.0;
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      */
483     function isContract(address account) internal view returns (bool) {
484         // This method relies on extcodesize, which returns 0 for contracts in
485         // construction, since the code is only stored at the end of the
486         // constructor execution.
487 
488         uint256 size;
489         assembly {
490             size := extcodesize(account)
491         }
492         return size > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         (bool success, ) = recipient.call{value: amount}("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.call{value: value}(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
599         return functionStaticCall(target, data, "Address: low-level static call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
626         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(isContract(target), "Address: delegate call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.delegatecall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
648      * revert reason using the provided one.
649      *
650      * _Available since v4.3._
651      */
652     function verifyCallResult(
653         bool success,
654         bytes memory returndata,
655         string memory errorMessage
656     ) internal pure returns (bytes memory) {
657         if (success) {
658             return returndata;
659         } else {
660             // Look for revert reason and bubble it up if present
661             if (returndata.length > 0) {
662                 // The easiest way to bubble the revert reason is using memory via assembly
663 
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 // File: @openzeppelin/contracts/utils/Strings.sol
676 
677 
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev String operations.
683  */
684 library Strings {
685     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
686 
687     /**
688      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
689      */
690     function toString(uint256 value) internal pure returns (string memory) {
691         // Inspired by OraclizeAPI's implementation - MIT licence
692         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
693 
694         if (value == 0) {
695             return "0";
696         }
697         uint256 temp = value;
698         uint256 digits;
699         while (temp != 0) {
700             digits++;
701             temp /= 10;
702         }
703         bytes memory buffer = new bytes(digits);
704         while (value != 0) {
705             digits -= 1;
706             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
707             value /= 10;
708         }
709         return string(buffer);
710     }
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
714      */
715     function toHexString(uint256 value) internal pure returns (string memory) {
716         if (value == 0) {
717             return "0x00";
718         }
719         uint256 temp = value;
720         uint256 length = 0;
721         while (temp != 0) {
722             length++;
723             temp >>= 8;
724         }
725         return toHexString(value, length);
726     }
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
730      */
731     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
732         bytes memory buffer = new bytes(2 * length + 2);
733         buffer[0] = "0";
734         buffer[1] = "x";
735         for (uint256 i = 2 * length + 1; i > 1; --i) {
736             buffer[i] = _HEX_SYMBOLS[value & 0xf];
737             value >>= 4;
738         }
739         require(value == 0, "Strings: hex length insufficient");
740         return string(buffer);
741     }
742 }
743 
744 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
745 
746 
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev Implementation of the {IERC165} interface.
753  *
754  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
755  * for the additional interface id that will be supported. For example:
756  *
757  * ```solidity
758  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
759  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
760  * }
761  * ```
762  *
763  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
764  */
765 abstract contract ERC165 is IERC165 {
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770         return interfaceId == type(IERC165).interfaceId;
771     }
772 }
773 
774 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
775 
776 
777 
778 pragma solidity ^0.8.0;
779 
780 
781 
782 
783 
784 
785 
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
789  * the Metadata extension, but not including the Enumerable extension, which is available separately as
790  * {ERC721Enumerable}.
791  */
792 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
793     using Address for address;
794     using Strings for uint256;
795 
796     // Token name
797     string private _name;
798 
799     // Token symbol
800     string private _symbol;
801 
802     // Mapping from token ID to owner address
803     mapping(uint256 => address) private _owners;
804 
805     // Mapping owner address to token count
806     mapping(address => uint256) private _balances;
807 
808     // Mapping from token ID to approved address
809     mapping(uint256 => address) private _tokenApprovals;
810 
811     // Mapping from owner to operator approvals
812     mapping(address => mapping(address => bool)) private _operatorApprovals;
813 
814     /**
815      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
816      */
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820     }
821 
822     /**
823      * @dev See {IERC165-supportsInterface}.
824      */
825     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
826         return
827             interfaceId == type(IERC721).interfaceId ||
828             interfaceId == type(IERC721Metadata).interfaceId ||
829             super.supportsInterface(interfaceId);
830     }
831 
832     /**
833      * @dev See {IERC721-balanceOf}.
834      */
835     function balanceOf(address owner) public view virtual override returns (uint256) {
836         require(owner != address(0), "ERC721: balance query for the zero address");
837         return _balances[owner];
838     }
839 
840     /**
841      * @dev See {IERC721-ownerOf}.
842      */
843     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
844         address owner = _owners[tokenId];
845         require(owner != address(0), "ERC721: owner query for nonexistent token");
846         return owner;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return "";
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public virtual override {
886         address owner = ERC721.ownerOf(tokenId);
887         require(to != owner, "ERC721: approval to current owner");
888 
889         require(
890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891             "ERC721: approve caller is not owner nor approved for all"
892         );
893 
894         _approve(to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view virtual override returns (address) {
901         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public virtual override {
910         require(operator != _msgSender(), "ERC721: approve to caller");
911 
912         _operatorApprovals[_msgSender()][operator] = approved;
913         emit ApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         //solhint-disable-next-line max-line-length
932         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
933 
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, "");
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public virtual override {
957         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
958         _safeTransfer(from, to, tokenId, _data);
959     }
960 
961     /**
962      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
963      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
964      *
965      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
966      *
967      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
968      * implement alternative mechanisms to perform token transfer, such as signature-based.
969      *
970      * Requirements:
971      *
972      * - `from` cannot be the zero address.
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must exist and be owned by `from`.
975      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeTransfer(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) internal virtual {
985         _transfer(from, to, tokenId);
986         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
987     }
988 
989     /**
990      * @dev Returns whether `tokenId` exists.
991      *
992      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
993      *
994      * Tokens start existing when they are minted (`_mint`),
995      * and stop existing when they are burned (`_burn`).
996      */
997     function _exists(uint256 tokenId) internal view virtual returns (bool) {
998         return _owners[tokenId] != address(0);
999     }
1000 
1001     /**
1002      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1009         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1010         address owner = ERC721.ownerOf(tokenId);
1011         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1012     }
1013 
1014     /**
1015      * @dev Safely mints `tokenId` and transfers it to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must not exist.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _safeMint(address to, uint256 tokenId) internal virtual {
1025         _safeMint(to, tokenId, "");
1026     }
1027 
1028     /**
1029      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1030      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1031      */
1032     function _safeMint(
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) internal virtual {
1037         _mint(to, tokenId);
1038         require(
1039             _checkOnERC721Received(address(0), to, tokenId, _data),
1040             "ERC721: transfer to non ERC721Receiver implementer"
1041         );
1042     }
1043 
1044     /**
1045      * @dev Mints `tokenId` and transfers it to `to`.
1046      *
1047      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must not exist.
1052      * - `to` cannot be the zero address.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _mint(address to, uint256 tokenId) internal virtual {
1057         require(to != address(0), "ERC721: mint to the zero address");
1058         require(!_exists(tokenId), "ERC721: token already minted");
1059 
1060         _beforeTokenTransfer(address(0), to, tokenId);
1061 
1062         _balances[to] += 1;
1063         _owners[tokenId] = to;
1064 
1065         emit Transfer(address(0), to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         address owner = ERC721.ownerOf(tokenId);
1080 
1081         _beforeTokenTransfer(owner, address(0), tokenId);
1082 
1083         // Clear approvals
1084         _approve(address(0), tokenId);
1085 
1086         _balances[owner] -= 1;
1087         delete _owners[tokenId];
1088 
1089         emit Transfer(owner, address(0), tokenId);
1090     }
1091 
1092     /**
1093      * @dev Transfers `tokenId` from `from` to `to`.
1094      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _transfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual {
1108         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1109         require(to != address(0), "ERC721: transfer to the zero address");
1110 
1111         _beforeTokenTransfer(from, to, tokenId);
1112 
1113         // Clear approvals from the previous owner
1114         _approve(address(0), tokenId);
1115 
1116         _balances[from] -= 1;
1117         _balances[to] += 1;
1118         _owners[tokenId] = to;
1119 
1120         emit Transfer(from, to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Approve `to` to operate on `tokenId`
1125      *
1126      * Emits a {Approval} event.
1127      */
1128     function _approve(address to, uint256 tokenId) internal virtual {
1129         _tokenApprovals[tokenId] = to;
1130         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1135      * The call is not executed if the target address is not a contract.
1136      *
1137      * @param from address representing the previous owner of the given token ID
1138      * @param to target address that will receive the tokens
1139      * @param tokenId uint256 ID of the token to be transferred
1140      * @param _data bytes optional data to send along with the call
1141      * @return bool whether the call correctly returned the expected magic value
1142      */
1143     function _checkOnERC721Received(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory _data
1148     ) private returns (bool) {
1149         if (to.isContract()) {
1150             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1151                 return retval == IERC721Receiver.onERC721Received.selector;
1152             } catch (bytes memory reason) {
1153                 if (reason.length == 0) {
1154                     revert("ERC721: transfer to non ERC721Receiver implementer");
1155                 } else {
1156                     assembly {
1157                         revert(add(32, reason), mload(reason))
1158                     }
1159                 }
1160             }
1161         } else {
1162             return true;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Hook that is called before any token transfer. This includes minting
1168      * and burning.
1169      *
1170      * Calling conditions:
1171      *
1172      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1173      * transferred to `to`.
1174      * - When `from` is zero, `tokenId` will be minted for `to`.
1175      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1176      * - `from` and `to` are never both zero.
1177      *
1178      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1179      */
1180     function _beforeTokenTransfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) internal virtual {}
1185 }
1186 
1187 // File: contracts/Kinochromes.sol
1188 
1189 
1190 pragma solidity ^0.8.9;
1191 
1192 
1193 
1194 
1195 
1196 //  _   ___                  _                                   
1197 // | | / (_)                | |                                  
1198 // | |/ / _ _ __   ___   ___| |__  _ __ ___  _ __ ___   ___  ___ 
1199 // |    \| | '_ \ / _ \ / __| '_ \| '__/ _ \| '_ ` _ \ / _ \/ __|
1200 // | |\  \ | | | | (_) | (__| | | | | | (_) | | | | | |  __/\__ \
1201 // \_| \_/_|_| |_|\___/ \___|_| |_|_|  \___/|_| |_| |_|\___||___/
1202 // by junkpunkie
1203 
1204 contract Kinochromes is ERC721, ReentrancyGuard, Ownable {
1205     mapping(bytes10 => bool) private hashToMinted;
1206     mapping(uint => bytes10) private sToDNA;
1207     mapping(uint => bytes10) private tokenIdToDNA;
1208     mapping (address => bool) private addressToWhitelist;
1209     mapping (address => bool) private whitelistAddrToMinted;
1210     bool private paused = true;
1211     bool private whitelistPaused = true;
1212     uint private randNonce = 0;
1213     uint private totalMinted = 0;
1214 
1215     constructor() ERC721("Kinochromes", "[k]") {
1216       bytes10 dnaOne = bytes10(abi.encodePacked(bytes1(0xFF),bytes1(0xFF),bytes1(0xFF),bytes1(0),bytes1(0),bytes1(0),bytes1(0),bytes1(0),bytes1(0),bytes1(0)));
1217       bytes10 dnaTwo = bytes10(abi.encodePacked(bytes1(0xFF),bytes1(0xFF),bytes1(0xFF),bytes1(0),bytes1(0),bytes1(0x09),bytes1(0),bytes1(0),bytes1(0),bytes1(0)));
1218       bytes5 dnaOneMinusColor = getDnaMinusColor(dnaOne);
1219       bytes5 dnaTwoMinusColor = getDnaMinusColor(dnaTwo);
1220 
1221       sToDNA[0x32] = dnaOne;
1222       tokenIdToDNA[0x32] = getDnaMinusColor(dnaOne);
1223       hashToMinted[dnaOneMinusColor] = true;
1224 
1225       sToDNA[0x1FF] = dnaTwo;
1226       tokenIdToDNA[0x1FF] = getDnaMinusColor(dnaTwo);
1227       hashToMinted[dnaTwoMinusColor] = true;
1228     }    
1229 
1230     // MINTING RELATED FUNCTIONS
1231 
1232     // Pause or unpause minting
1233     function setPaused(bool _paused) public nonReentrant onlyOwner {
1234       paused = _paused;
1235     }
1236 
1237     function addToWhitelist(address[] memory users) public onlyOwner nonReentrant {
1238         for (uint i = 0; i < users.length; i++) {
1239             addressToWhitelist[users[i]] = true;
1240             whitelistAddrToMinted[users[i]] = false;
1241         }      
1242     }
1243 
1244     // Whitelisted addresses can claim 1 until public minting opens
1245     function whitelistClaim() public nonReentrant {
1246         require (addressToWhitelist[msg.sender], "You are not on the whitelist");
1247         require (!whitelistAddrToMinted[msg.sender], "You have already claimed with this address");
1248         uint index = totalSupply();
1249         require(index >= 50 && index < 512, "All have been minted");
1250         _internalMint(index);
1251         whitelistAddrToMinted[msg.sender] = true;
1252     }
1253 
1254     // Owner keeps the first 50
1255     function ownerClaim() public nonReentrant onlyOwner {
1256         uint index = totalSupply();
1257         require(index >= 0 && index + 9 < 50, "Choose an unclaimed index between 0 and 51, inclusive");
1258         for (uint i = index; i < index + 10; i++) {
1259           _internalMint(i);
1260         }
1261     }
1262 
1263     // Claim for public mint
1264     function claim() public nonReentrant {
1265         require (!paused, "Minting is paused");
1266         uint index = totalSupply();
1267         require(index >= 50 && index < 512, "All have been minted");
1268         _internalMint(index);
1269     }
1270 
1271     function _internalMint(uint256 tokenId) private {
1272         tokenIdToDNA[tokenId] = generateHash(tokenId);
1273         _safeMint(_msgSender(), tokenId);
1274         totalMinted++;
1275     }
1276 
1277     function generateHash(uint256 tokenId) internal returns (bytes10) {
1278       // bytes10 scheme is r/g/b/background/filter/pattern/transform/shape/anim1/anim2
1279       // like this: 0xd0714c04020901020706
1280       // where d0 = red, 71 = green, 4c = blue, 04 = background, 02 = filter, etc
1281       bytes10 dna;
1282       if (tokenId == 0x32 || tokenId == 0x1FF) {
1283         return sToDNA[tokenId];
1284       } else {
1285           dna = bytes10(
1286             abi.encodePacked(
1287               genRandomNum(tokenId, 255), // red index 0
1288               genRandomNum(tokenId, 255), // green index 1
1289               genRandomNum(tokenId, 255), // blue index 2
1290               genRandomNum(tokenId, 4),   // background index 3
1291               genRandomNum(tokenId, 5),   // filter index 4
1292               genRandomNum(tokenId, 9),   // pattern index 5
1293               genRandomNum(tokenId, 5),   // transform index 6
1294               genRandomNum(tokenId, 2),   // shape index 7
1295               genRandomNum(tokenId, 8),   // anim1 duration index 8
1296               genRandomNum(tokenId, 8)    // anim2 duration index 9
1297             )
1298           );
1299         }
1300 
1301         // Colors don't matter to the uniqueness of each token, but the rest
1302         // of the attributes do matter.
1303         bytes5 dnaMinusColor = getDnaMinusColor(dna);
1304         // No dupes
1305         if (hashToMinted[dnaMinusColor]) {
1306           randNonce++;
1307           return generateHash(tokenId);
1308         }
1309         hashToMinted[dnaMinusColor] = true;
1310         return dna;      
1311     }
1312 
1313     function getDnaMinusColor(bytes10 dna) private pure returns (bytes5) {
1314       return bytes5(
1315           abi.encodePacked(
1316               dna[3], dna[4], dna[5], dna[6], dna[7], dna[8], dna[9]      
1317           )
1318       );
1319     }
1320 
1321     function totalSupply() public view returns (uint) {
1322       return totalMinted;
1323     }
1324 
1325     // ART FUNCTIONS
1326 
1327     // The main SVG generator function
1328     function generateSvg(uint256 tokenId) internal view returns (string memory) {
1329         return string(abi.encodePacked(
1330           '<svg width="256" height="256" version="1.1" xmlns="http://www.w3.org/2000/svg" class="s1" style="background:', buildBackground(tokenId), ';">',
1331           generateStyle(tokenId),
1332           '<defs>', buildShape(tokenId), '</defs>',
1333           '<g id="g" style="',tokenId % 3 == 0 ? 'transform:scale(0.7) rotate(45deg);transform-origin:50% 50%;' : '','">',
1334           makeArt(tokenId),
1335           '</g></svg>'
1336         ));
1337     }
1338 
1339     // Creates the <style> tag
1340     function generateStyle(uint256 tokenId) internal view returns (string memory) {
1341       string[2] memory bgColors = invertColors(tokenId);
1342       return string(abi.encodePacked(
1343         '<style>.s1{--a:rgb(', bgColors[0],
1344         ');--b:rgb(', bgColors[1], ');transition: all 1000ms ease;}.s1:hover {filter:',tokenId == 0x32 ? 'sepia(1)' : (tokenId == 0x1FF ? 'contrast(5)' : (tokenId % 2 == 0 ? 'invert(1)' : 'hue-rotate(-270deg)')),';}.u{animation:',toString(buildAnimationDuration(tokenId, 8)) ,'ms infinite alternate a,',toString(buildAnimationDuration(tokenId, 9)),'ms infinite alternate b;transform-origin:50% 50%;}',
1345         buildAnimation(tokenId),
1346         '@keyframes b{from{opacity: 1;}to {opacity: 0.5;}}',
1347         '</style>'
1348       ));
1349     }
1350 
1351     // This is the main shape and pattern plotting function
1352     function makeArt(uint256 tokenId) internal view returns (string memory) {
1353         string memory o;
1354         bytes10 DNA = tokenIdToDNA[tokenId];
1355         uint256 seed = getDNASeed(DNA, tokenId);
1356         uint256 v = 0;
1357         int a = 0;
1358         int b = 0;
1359         // The following loop and algorithm is taken and slightly tweaked from Autoglyphs, created by Matt Hall & John Watkinson of Larva Labs.
1360         // The credit for this project and for onchain generative art goes to them.
1361         // Read the Autoglyphs contract here: https://etherscan.io/address/0xd4e4078ca3495de5b1d4db434bebc5a986197782#code
1362         if (uint8(DNA[5]) > 7) {
1363           for (uint8 y = 0; y < 8; y++) {
1364               a = (2 * (int8(y) - 4) + 1);
1365               if (seed % 3 == 1) {
1366                 a = -a;
1367               } else if (seed % 3 == 2) {
1368                 a = abs(a);
1369               }
1370               a = a * int(seed);
1371               for (uint8 x = 0; x < 8; x++) {
1372                   b = (2 * (int8(x) - 4) + 1);
1373                   if (seed % 2 == 1) {
1374                     b = abs(b);
1375                   }
1376                   b = b * int(seed);
1377                   v = uint(a * b / int(0x100000000)) % ((seed % 25) + 5);
1378                   string memory dString = v > 12 ? string(abi.encodePacked('-', toString(v * 1000))) : toString(v * 1000);
1379                   
1380                   o = string(abi.encodePacked(
1381                       o,
1382                       createShape(DNA, x, y, dString)
1383                   ));
1384               }
1385           }
1386           // Custom Patterns
1387         } else {
1388           for (uint8 y = 0; y < 8; y++) {
1389             for (uint8 x = 0; x < 8; x++) {
1390               v = drawCustomPattern(DNA, x, y, v);
1391               o = string(abi.encodePacked(
1392                   o,
1393                   createShape(DNA, x, y, toString(v))
1394               ));
1395             }
1396           }
1397         }
1398         return o;
1399     }
1400 
1401     // This giant function contains the logic to apply animation delays
1402     // based on the given pattern for a tokenId
1403     function drawCustomPattern(bytes10 DNA, uint8 x, uint8 y, uint delay) pure internal returns (uint) {
1404       uint _delay = delay;
1405       if(DNA[5] == 0x00) {
1406         // simple
1407         _delay += 100;
1408       } else if (DNA[5] == 0x01) {
1409         // staircase
1410         _delay += 100;
1411         _delay = _delay > 800 ? 0 : _delay;
1412       } else if (DNA[5] == 0x02) {
1413         // runner
1414         if (_delay == 0) {
1415           _delay = 1000;
1416         }
1417         if (y % 2 == 0) {
1418           _delay = x % 2 == 0 ? _delay -= 1000 : _delay;
1419         } else {
1420           _delay = x % 2 == 0 ? _delay : _delay -= 1000;
1421         }
1422         _delay += 1000;
1423       } else if (DNA[5] == 0x03) {
1424         // cross + corners
1425         if ((x == 0 && y == 0) || (x == 0 && y == 7) || (x == 7 && y == 0) || (x == 7 && y == 7)) {
1426           _delay = 6500;
1427         } else if (x == 3 || x == 4 || y == 3 || y == 4) {
1428           _delay = 0;
1429         } else {
1430           _delay = 4000;
1431         }
1432       } else if (DNA[5] == 0x04) {
1433         // spiral
1434         if (x == 0) {
1435           _delay = 3500 + 500 * y;
1436         } else if (y == 0) {
1437           _delay = 3500 - 500 * x;
1438         } else if (y == 1) {
1439           if (x > 0 && x < 7) {
1440             _delay = 17000 - 500 * x;
1441           } else {
1442             _delay = 13500;
1443           }
1444         } else if (y == 2) {
1445           if (x == 1) {
1446             _delay = 17000;
1447           } else if (x == 7) {
1448             _delay = 13000;
1449           } else {
1450             _delay = 26000 - 500 * x;
1451           }
1452         } else if (y == 3) {
1453           if (x == 1) {
1454             _delay = 17500;
1455           } else if (x == 2) {
1456             _delay = 26000;
1457           } else if (x == 6) {
1458             _delay = 23000;
1459           } else if (x == 7) {
1460             _delay = 12500;
1461           } else {
1462             _delay = 32000 - 500 * x;
1463           }
1464         } else if (y == 4) {
1465           if (x == 1) {
1466             _delay = 18000;
1467           } else if (x == 2) {
1468             _delay = 26500;
1469           } else if (x == 5) {
1470             _delay = 29000;
1471           } else if (x == 6) {
1472             _delay = 22500;
1473           } else if (x == 7) {
1474             _delay = 12000;
1475           } else {
1476             _delay = 29500 + 500 * x;
1477           }
1478         } else if (y == 5) {
1479           if (x == 1) {
1480             _delay = 18500;
1481           } else if (x > 1 && x < 6) {
1482             _delay = 26000 + 500 * x;
1483           } else if (x == 6) {
1484             _delay = 22000;
1485           } else {
1486             _delay = 11500;
1487           }
1488         } else if (y == 6) {
1489           if (x != 7) {
1490             _delay = 18500 + 500 * x;
1491           } else {
1492             _delay = 11000;
1493           }
1494         } else if (y == 7) {
1495           _delay = 7000 + 500 * x;
1496         }
1497       } else if (DNA[5] == 0x05) {
1498         // X pattern
1499         if ((x == 0 && y == 0) || (x == 7 && y == 7) || (x == 0 && y == 7) || (x == 7 && y == 0)) {
1500           _delay = 1000;
1501         } else if ((x == 1 && y == 1) || (x == 6 && y == 6) || (x == 1 && y == 6) || (x == 6 && y == 1)) {
1502           _delay = 2000;
1503         } else if ((x == 2 && y == 2) || (x == 5 && y == 5) || (x == 2 && y == 5) || (x == 5 && y == 2)) {
1504           _delay = 3000;
1505         } else if ((x == 3 && y == 3) || (x == 4 && y == 4) || (x == 3 && y == 4) || (x == 4 && y == 3)) {
1506           _delay = 4000;
1507         } else {
1508           _delay = 0;
1509         }
1510       } else if (DNA[5] == 0x06) {
1511         // 10Print
1512         _delay = tenPrint(DNA, x, y);
1513       } else {
1514         // Squares in Squares
1515         if (
1516           (x == 0 && y == 0) || (x == 7 && y == 7) || (x == 0 && y == 7) || (x == 7 && y == 0)
1517           || (x == 2 && y == 2) || (x == 5 && y == 5) || (x == 2 && y == 5) || (x == 5 && y == 2)
1518           || ((y == 2 || y == 5) && (x > 2 && x < 6))
1519           || (y > 2 && y < 5) && (x == 2 || x == 5)) {
1520           _delay = 1000;
1521         } else if (y == 0 || y == 7 || x == 0 || x == 7) {
1522           _delay = 0;
1523         } else {
1524           _delay = 2000;
1525         }
1526       }
1527       return _delay;
1528     }
1529 
1530     // A custom pattern based on the 10Print algorithm.
1531     // See: https://10print.org/
1532     function tenPrint(bytes10 DNA, uint8 x, uint8 y) internal pure returns (uint) {
1533       uint rand = (uint(uint(uint8(DNA[x])) + uint(x) + uint(y)) % (uint(y) * 3 + 35)) % 3;
1534       if (rand == 0) {
1535         return 0;
1536       }
1537       if (rand == 1) {
1538         return 7000;
1539       }
1540       return 15000;
1541     }
1542 
1543     // Changes a given color by subtracting up to 98 from its RGB value, and shifts the RGB position
1544     // so as to create a nice gradient and to not clash with the background color
1545     function changeColor(bytes10 _rgb, uint position, uint8 x, uint8 y) internal pure returns (bytes1) {
1546         return subtractBitwise(getColor(_rgb, position > 1 ? 0 : position + 1), bytes1(uint8(x ** 2) + uint8(y ** 2)));
1547     }
1548 
1549     // Returns R, G, or B
1550     function getColor(bytes10 _rgb, uint position) internal pure returns (bytes1) {
1551         return _rgb[position];
1552     }    
1553 
1554     // Creates a shape based on the x and y coordinates, and the animation delay
1555     function createShape(bytes10 DNA, uint8 x, uint8 y, string memory delay) pure internal returns (string memory) {
1556         return string(
1557             abi.encodePacked(
1558               '<use class="u" href="#r" x="', toString(uint8(x) * 32),
1559               '" y="', toString(uint8(y) * 32), '" fill="rgb(',
1560               toString(uint8(changeColor(DNA, 0, x, y))), ',',
1561               toString(uint8(changeColor(DNA, 1, x, y))), ',',
1562               toString(uint8(changeColor(DNA, 2, x, y))),
1563               ')" style="animation-delay:', delay, 'ms;" />'
1564             )
1565         );
1566     }
1567 
1568     // Chooses either Square or Circle shape
1569     function buildShape(uint256 tokenId) internal view returns (string memory) {
1570       string[2] memory shapes = [
1571         '<rect id="r" height="32" width="32"></rect>',
1572         '<circle id="r" cx="16" cy="16" height="32" width="32" r="8"></circle>'
1573       ];
1574       return shapes[getAttributeAtPos(tokenId, 7)];
1575     }
1576 
1577     // TOKENURI AND ATTRIBUTE FUNCTIONS
1578 
1579     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1580         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1581         return string(abi.encodePacked(
1582           "data:application/json;base64,",
1583           Base64.encode(
1584             bytes(
1585               string(
1586                 abi.encodePacked(
1587                   '{"name": "', (tokenId == 0x1FF || tokenId == 0x32) ? 'Albinochrome #' : 'Kinochrome #',
1588                   toString(tokenId),
1589                   getAttributes(tokenId),
1590                   // These two traits are called outside of getAttributes because of Stack Too Deep errors
1591                   '"},{"trait_type": "Animation 1 Duration","value": "',
1592                   getAttributeTitleValues(tokenId, 8),
1593                   'ms"},{"trait_type": "Animation 2 Duration","value": "',
1594                   getAttributeTitleValues(tokenId, 9), 'ms"}]'
1595                   ',"image": "data:image/svg+xml;base64,',
1596                   Base64.encode(
1597                     bytes(generateSvg(tokenId))
1598                   ),
1599                   '"}'
1600                 )
1601               )
1602             )
1603           )
1604         ));
1605     }
1606 
1607     // Creates the "attributes" array for tokenURI
1608     function getAttributes(uint256 tokenId) view internal returns (string memory) {
1609       return string(
1610         abi.encodePacked(
1611           '", "attributes": [',(tokenId == 0x1FF || tokenId == 0x32) ? '{"trait_type": "Special","value": "Albino"},' : '',
1612           '{"trait_type": "Background","value": "',
1613           getAttributeTitleValues(tokenId, 3),
1614           '"},{"trait_type": "Filter","value": "',
1615           getAttributeTitleValues(tokenId, 4),
1616           '"},{"trait_type": "Pattern","value": "',
1617           getAttributeTitleValues(tokenId, 5),
1618           '"},{"trait_type": "Transform","value": "',
1619           getAttributeTitleValues(tokenId, 6),
1620           '"},{"trait_type": "Shape","value": "',
1621           getAttributeTitleValues(tokenId, 7)
1622         )
1623       );
1624     }
1625 
1626     // Returns the "value" for each trait_type
1627     function getAttributeTitleValues(uint256 tokenId, uint8 pos) view internal returns (string memory) {
1628       if (pos == 3) {
1629         return [
1630           'Solid',
1631           'Radial Gradient',
1632           'Linear Gradient',
1633           'Conic Gradient'
1634         ][getAttributeAtPos(tokenId, 3)];
1635       }
1636       if (pos == 4) {
1637         return [
1638           'Hue Rotate',
1639           'Reverse Hue Rotate',
1640           'Saturate/Invert',
1641           'Sepia',
1642           'Sepia/Invert'
1643         ][getAttributeAtPos(tokenId, 4)];
1644       }
1645       if (pos == 5) {
1646         uint8 index = getAttributeAtPos(tokenId, 5);
1647         return index > 7 ? 'Autoglyph' : [
1648           'Simple',
1649           'Staircase',
1650           'Runner',
1651           'Cross Corners',
1652           'Spiral',
1653           'X',
1654           '10 Print',
1655           'Squares in Squares'
1656         ][getAttributeAtPos(tokenId, 5)];
1657       }
1658       if (pos == 6) {
1659         return [
1660           'None',
1661           'Shrink',
1662           'Grow',
1663           'Rotate',
1664           'Slideways'
1665           // 'Slideways (Large)'
1666         ][getAttributeAtPos(tokenId, 6)];
1667       }
1668       if (pos == 7) {
1669         return [
1670           'Square',
1671           'Circle'
1672         ][getAttributeAtPos(tokenId, 7)];
1673       }
1674       return [
1675         '1500',
1676         '2700',
1677         '5100',
1678         '11000',
1679         '15500',
1680         '25000',
1681         '32000',
1682         '45000'
1683       ][getAttributeAtPos(tokenId, pos == 8 ? 8 : 9)];
1684     }
1685 
1686     // Returns animation duration in ms
1687     function buildAnimationDuration(uint256 tokenId, uint8 pos) internal view returns (uint16) {
1688       uint16[8] memory durs = [
1689         1500,
1690         2700,
1691         5100,
1692         11000,
1693         15500,
1694         25000,
1695         32000,
1696         45000
1697       ];
1698       return durs[getAttributeAtPos(tokenId, pos)];
1699     }
1700 
1701     // Returns background style for main <svg>
1702     function buildBackground(uint256 tokenId) internal view returns (string memory) {
1703       string[4] memory backgrounds = [
1704         'var(--a)',
1705         'radial-gradient(var(--a), var(--b))',
1706         'linear-gradient(var(--a), var(--b))',
1707         'conic-gradient(var(--a), var(--b))'
1708       ];
1709       return backgrounds[getAttributeAtPos(tokenId, 3)];
1710     }
1711 
1712     // Used for background only - inverts the RGB values to make a background color for the randomized palette
1713     function invertColors(uint256 tokenId) internal view returns (string[2] memory) {
1714       bytes1 red = bytes1(getAttributeAtPos(tokenId, 0));
1715       bytes1 green = bytes1(getAttributeAtPos(tokenId, 1));
1716       bytes1 blue = bytes1(getAttributeAtPos(tokenId, 2));
1717       return [
1718         string(abi.encodePacked(toString(uint8(~red)),',', toString(uint8(~green)),',', toString(uint8(~blue)))),
1719         string(abi.encodePacked(toString(uint8(~green)),',', toString(uint8(~blue)),',', toString(uint8(~red))))
1720       ];
1721     }
1722 
1723     // Returns CSS animations used for the animation pattern
1724     function buildAnimation(uint256 tokenId) internal view returns (string memory) {
1725       string[3][5] memory filters = [
1726         ['hue-rotate(0deg)', 'hue-rotate(180deg)', 'hue-rotate(-180deg)'],
1727         ['hue-rotate(0deg)', 'hue-rotate(-90deg)', 'hue-rotate(90deg)'],
1728         ['saturate(1) invert(0)', 'saturate(1.8) invert(1)', 'saturate(0.5) invert(0.2)'],
1729         ['sepia(0)', 'sepia(0.5)', 'sepia(0.8)'],
1730         ['sepia(0) invert(0)', 'sepia(0.5) invert(1)', 'sepia(0.8) invert(0.6)']
1731       ];
1732       string[3][5] memory transforms = [
1733         ['scale(1)', 'scale(1)', 'scale(1)'],
1734         ['scale(1)', 'scale(0.8)', 'scale(1.2)'],
1735         ['scale(1)', 'scale(1.6)', 'scale(1.2)'],
1736         ['rotate(0deg)', 'rotate(45deg)', 'rotate(-45deg)'],
1737         ['translate(0)', 'translate(16px)', 'translate(-16px)']
1738         // ['translate(0)', 'translate(-50%)']
1739       ];      
1740       string memory o = string(
1741         abi.encodePacked(
1742           '@keyframes a{25%{filter:',
1743           filters[getAttributeAtPos(tokenId, 4)][0],
1744           ';transform:',transforms[getAttributeAtPos(tokenId, 6)][0],
1745           ';}50%{filter:',
1746           filters[getAttributeAtPos(tokenId, 4)][1],
1747           ';transform:',transforms[getAttributeAtPos(tokenId, 6)][1],
1748           ';}75%{filter:',filters[getAttributeAtPos(tokenId, 4)][0],
1749           ';transform:',transforms[getAttributeAtPos(tokenId, 6)][0],
1750           ';}100%{filter:',filters[getAttributeAtPos(tokenId, 4)][2],
1751           ';transform:',transforms[getAttributeAtPos(tokenId, 6)][2],';}}'
1752         )
1753       );
1754 
1755       return o;
1756     }
1757 
1758     // Takes in a tokenId and a "max" number as the ceiling to randomly pull
1759     function genRandomNum(uint256 tokenId, uint8 max) internal returns (bytes1) {
1760       return bytes1(randMod(tokenId, max));
1761     }
1762 
1763     // Returns the value of each attribute at a specific position
1764     function getAttributeAtPos(uint256 tokenId, uint8 pos) internal view returns (uint8) {
1765       return uint8(tokenIdToDNA[tokenId][pos]);
1766     }    
1767 
1768     // Returns a seed; a uint of the DNA that's useful for performing math
1769     function getDNASeed(bytes10 DNA, uint256 tokenId) internal pure returns (uint64) {
1770         return uint64(uint256(keccak256(abi.encodePacked(
1771             DNA,
1772             tokenId
1773         ))));
1774     }    
1775 
1776     // UTIL FUNCTIONS
1777 
1778     function toString(uint256 value) internal pure returns (string memory) {
1779         // Inspired by OraclizeAPI's implementation - MIT licence
1780         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1781 
1782         if (value == 0) {
1783             return "0";
1784         }
1785         uint256 temp = value;
1786         uint256 digits;
1787         while (temp != 0) {
1788             digits++;
1789             temp /= 10;
1790         }
1791         bytes memory buffer = new bytes(digits);
1792         while (value != 0) {
1793             digits -= 1;
1794             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1795             value /= 10;
1796         }
1797         return string(buffer);
1798     }    
1799 
1800     function randMod(uint256 tokenId, uint8 _modulo) internal returns(uint8) {
1801         // increase nonce
1802         randNonce++; 
1803         return uint8(uint256(
1804           keccak256(
1805             abi.encodePacked(
1806               block.difficulty,
1807               block.timestamp,
1808               msg.sender,
1809               randNonce,
1810               tokenId)
1811             )
1812           )) % _modulo;
1813     }
1814 
1815     // Taken from Autoglyphs by Larva Labs
1816     function abs(int n) internal pure returns (int) {
1817         if (n >= 0) return n;
1818         return -n;
1819     }
1820 
1821     function subtractBitwise(bytes1 a, bytes1 b) internal pure returns (bytes1) {
1822       while (b != 0) {
1823         bytes1 borrow = (~a) & b;
1824         a = a ^ b;
1825         b = borrow << 1;
1826       }
1827       return a;
1828     }
1829 }