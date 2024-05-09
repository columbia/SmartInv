1 // SPDX-License-Identifier: MIT
2 
3 // Scroll down to the bottom to find the contract of interest. 
4 
5 // File: @openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File: @openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol
33 
34 
35 pragma solidity ^0.8.0;
36 
37 // import "@openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol";
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File: @openzeppelin/contracts@4.3.2/token/ERC721/IERC721Receiver.sol
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 
206 // File: @openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Metadata.sol
207 
208 
209 pragma solidity ^0.8.0;
210 
211 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol";
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Metadata is IERC721 {
218     /**
219      * @dev Returns the token collection name.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the token collection symbol.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
230      */
231     function tokenURI(uint256 tokenId) external view returns (string memory);
232 }
233 
234 
235 // File: @openzeppelin/contracts@4.3.2/utils/Address.sol
236 
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 
454 // File: @openzeppelin/contracts@4.3.2/utils/Context.sol
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes calldata) {
475         return msg.data;
476     }
477 }
478 
479 
480 // File: @openzeppelin/contracts@4.3.2/utils/Strings.sol
481 
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497 
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 }
547 
548 
549 // File: @openzeppelin/contracts@4.3.2/utils/introspection/ERC165.sol
550 
551 
552 pragma solidity ^0.8.0;
553 
554 // import "@openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol";
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 
580 // File: @openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Enumerable.sol
581 
582 
583 pragma solidity ^0.8.0;
584 
585 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol";
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Enumerable is IERC721 {
592     /**
593      * @dev Returns the total amount of tokens stored by the contract.
594      */
595     function totalSupply() external view returns (uint256);
596 
597     /**
598      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
599      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
600      */
601     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
602 
603     /**
604      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
605      * Use along with {totalSupply} to enumerate all tokens.
606      */
607     function tokenByIndex(uint256 index) external view returns (uint256);
608 }
609 
610 
611 // File: @openzeppelin/contracts@4.3.2/access/Ownable.sol
612 
613 
614 pragma solidity ^0.8.0;
615 
616 // import "@openzeppelin/contracts@4.3.2/utils/Context.sol";
617 
618 /**
619  * @dev Contract module which provides a basic access control mechanism, where
620  * there is an account (an owner) that can be granted exclusive access to
621  * specific functions.
622  *
623  * By default, the owner account will be the one that deploys the contract. This
624  * can later be changed with {transferOwnership}.
625  *
626  * This module is used through inheritance. It will make available the modifier
627  * `onlyOwner`, which can be applied to your functions to restrict their use to
628  * the owner.
629  */
630 abstract contract Ownable is Context {
631     address private _owner;
632 
633     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
634 
635     /**
636      * @dev Initializes the contract setting the deployer as the initial owner.
637      */
638     constructor() {
639         _setOwner(_msgSender());
640     }
641 
642     /**
643      * @dev Returns the address of the current owner.
644      */
645     function owner() public view virtual returns (address) {
646         return _owner;
647     }
648 
649     /**
650      * @dev Throws if called by any account other than the owner.
651      */
652     modifier onlyOwner() {
653         require(owner() == _msgSender(), "Ownable: caller is not the owner");
654         _;
655     }
656 
657     /**
658      * @dev Leaves the contract without owner. It will not be possible to call
659      * `onlyOwner` functions anymore. Can only be called by the current owner.
660      *
661      * NOTE: Renouncing ownership will leave the contract without an owner,
662      * thereby removing any functionality that is only available to the owner.
663      */
664     function renounceOwnership() public virtual onlyOwner {
665         _setOwner(address(0));
666     }
667 
668     /**
669      * @dev Transfers ownership of the contract to a new account (`newOwner`).
670      * Can only be called by the current owner.
671      */
672     function transferOwnership(address newOwner) public virtual onlyOwner {
673         require(newOwner != address(0), "Ownable: new owner is the zero address");
674         _setOwner(newOwner);
675     }
676 
677     function _setOwner(address newOwner) private {
678         address oldOwner = _owner;
679         _owner = newOwner;
680         emit OwnershipTransferred(oldOwner, newOwner);
681     }
682 }
683 
684 
685 // File: @openzeppelin/contracts@4.3.2/security/ReentrancyGuard.sol
686 
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Contract module that helps prevent reentrant calls to a function.
692  *
693  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
694  * available, which can be applied to functions to make sure there are no nested
695  * (reentrant) calls to them.
696  *
697  * Note that because there is a single `nonReentrant` guard, functions marked as
698  * `nonReentrant` may not call one another. This can be worked around by making
699  * those functions `private`, and then adding `external` `nonReentrant` entry
700  * points to them.
701  *
702  * TIP: If you would like to learn more about reentrancy and alternative ways
703  * to protect against it, check out our blog post
704  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
705  */
706 abstract contract ReentrancyGuard {
707     // Booleans are more expensive than uint256 or any type that takes up a full
708     // word because each write operation emits an extra SLOAD to first read the
709     // slot's contents, replace the bits taken up by the boolean, and then write
710     // back. This is the compiler's defense against contract upgrades and
711     // pointer aliasing, and it cannot be disabled.
712 
713     // The values being non-zero value makes deployment a bit more expensive,
714     // but in exchange the refund on every call to nonReentrant will be lower in
715     // amount. Since refunds are capped to a percentage of the total
716     // transaction's gas, it is best to keep them low in cases like this one, to
717     // increase the likelihood of the full refund coming into effect.
718     uint256 private constant _NOT_ENTERED = 1;
719     uint256 private constant _ENTERED = 2;
720 
721     uint256 private _status;
722 
723     constructor() {
724         _status = _NOT_ENTERED;
725     }
726 
727     /**
728      * @dev Prevents a contract from calling itself, directly or indirectly.
729      * Calling a `nonReentrant` function from another `nonReentrant`
730      * function is not supported. It is possible to prevent this from happening
731      * by making the `nonReentrant` function external, and make it call a
732      * `private` function that does the actual work.
733      */
734     modifier nonReentrant() {
735         // On the first call to nonReentrant, _notEntered will be true
736         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
737 
738         // Any calls to nonReentrant after this point will fail
739         _status = _ENTERED;
740 
741         _;
742 
743         // By storing the original value once again, a refund is triggered (see
744         // https://eips.ethereum.org/EIPS/eip-2200)
745         _status = _NOT_ENTERED;
746     }
747 }
748 
749 // File: bd/contracts/SDA.optimized.sol
750 
751 pragma solidity ^0.8.0;
752 
753 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol";
754 // import "@openzeppelin/contracts@4.3.2/token/ERC721/IERC721Receiver.sol";
755 // import "@openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Metadata.sol";
756 // import "@openzeppelin/contracts@4.3.2/utils/Address.sol";
757 // import "@openzeppelin/contracts@4.3.2/utils/Context.sol";
758 // import "@openzeppelin/contracts@4.3.2/utils/Strings.sol";
759 // import "@openzeppelin/contracts@4.3.2/utils/introspection/ERC165.sol";
760 
761 /**
762  * This is a modified version of the ERC721 class, where we only store
763  * the address of the minter into an _owners array upon minting.
764  * 
765  * While this saves on minting gas costs, it means that the the balanceOf
766  * function needs to do a bruteforce search through all the tokens.
767  *
768  * For small amounts of tokens (e.g. 8888), RPC services like Infura
769  * can still query the function. 
770  *
771  * It also means any future contracts that reads the balanceOf function 
772  * in a non-view function will incur a gigantic gas fee. 
773  */
774 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
775     
776     using Address for address;
777     
778     string private _name;
779     
780     string private _symbol;
781     
782     address[] internal _owners;
783     
784     mapping(uint256 => address) private _tokenApprovals;
785     
786     mapping(address => mapping(address => bool)) private _operatorApprovals;     
787     
788     constructor(string memory name_, string memory symbol_) {
789         _name = name_;
790         _symbol = symbol_;
791     }     
792     
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799     
800     function balanceOf(address owner) public view virtual override returns (uint256) {
801         require(owner != address(0), "ERC721: balance query for the zero address");
802         uint count = 0;
803         uint n = _owners.length;
804         for (uint i = 0; i < n; ++i) {
805             if (owner == _owners[i]) {
806                 ++count;
807             }
808         }
809         return count;
810     }
811     
812     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
813         address owner = _owners[tokenId];
814         require(owner != address(0), "ERC721: owner query for nonexistent token");
815         return owner;
816     }
817     
818     function name() public view virtual override returns (string memory) {
819         return _name;
820     }
821     
822     function symbol() public view virtual override returns (string memory) {
823         return _symbol;
824     }
825     
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             "ERC721: approve caller is not owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837     
838     function getApproved(uint256 tokenId) public view virtual override returns (address) {
839         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
840 
841         return _tokenApprovals[tokenId];
842     }
843     
844     function setApprovalForAll(address operator, bool approved) public virtual override {
845         require(operator != _msgSender(), "ERC721: approve to caller");
846 
847         _operatorApprovals[_msgSender()][operator] = approved;
848         emit ApprovalForAll(_msgSender(), operator, approved);
849     }
850     
851     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
852         return _operatorApprovals[owner][operator];
853     }
854     
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         //solhint-disable-next-line max-line-length
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
862 
863         _transfer(from, to, tokenId);
864     }
865     
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         safeTransferFrom(from, to, tokenId, "");
872     }
873     
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) public virtual override {
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881         _safeTransfer(from, to, tokenId, _data);
882     }     
883     
884     function _safeTransfer(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) internal virtual {
890         _transfer(from, to, tokenId);
891         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
892     }
893   
894     function _exists(uint256 tokenId) internal view virtual returns (bool) {
895         return tokenId < _owners.length && _owners[tokenId] != address(0);
896     }
897   
898     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
899         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
900         address owner = ERC721.ownerOf(tokenId);
901         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
902     }
903   
904     function _safeMint(address to, uint256 tokenId) internal virtual {
905         _safeMint(to, tokenId, "");
906     }
907   
908     function _safeMint(
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _mint(to, tokenId);
914         require(
915             _checkOnERC721Received(address(0), to, tokenId, _data),
916             "ERC721: transfer to non ERC721Receiver implementer"
917         );
918     }
919   
920     function _mint(address to, uint256 tokenId) internal virtual {
921         require(to != address(0), "ERC721: mint to the zero address");
922         require(!_exists(tokenId), "ERC721: token already minted");
923 
924         _beforeTokenTransfer(address(0), to, tokenId);
925         _owners.push(to);
926 
927         emit Transfer(address(0), to, tokenId);
928     }
929   
930     function _burn(uint256 tokenId) internal virtual {
931         address owner = ERC721.ownerOf(tokenId);
932 
933         _beforeTokenTransfer(owner, address(0), tokenId);
934 
935         // Clear approvals
936         _approve(address(0), tokenId);
937         _owners[tokenId] = address(0);
938 
939         emit Transfer(owner, address(0), tokenId);
940     }
941   
942     function _transfer(
943         address from,
944         address to,
945         uint256 tokenId
946     ) internal virtual {
947         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
948         require(to != address(0), "ERC721: transfer to the zero address");
949 
950         _beforeTokenTransfer(from, to, tokenId);
951 
952         // Clear approvals from the previous owner
953         _approve(address(0), tokenId);
954         _owners[tokenId] = to;
955 
956         emit Transfer(from, to, tokenId);
957     }
958   
959     function _approve(address to, uint256 tokenId) internal virtual {
960         _tokenApprovals[tokenId] = to;
961         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
962     }
963   
964     function _checkOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) private returns (bool) {
970         if (to.isContract()) {
971             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
972                 return retval == IERC721Receiver.onERC721Received.selector;
973             } catch (bytes memory reason) {
974                 if (reason.length == 0) {
975                     revert("ERC721: transfer to non ERC721Receiver implementer");
976                 } else {
977                     assembly {
978                         revert(add(32, reason), mload(reason))
979                     }
980                 }
981             }
982         } else {
983             return true;
984         }
985     }
986   
987     function _beforeTokenTransfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {}
992 }
993 
994 pragma solidity ^0.8.0;
995 
996 // import "@openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Enumerable.sol";
997 
998 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
999     
1000     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1001         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1002     }
1003     
1004     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1005         uint256 count = 0;
1006         uint256 n = _owners.length;
1007         for (uint256 i = 0; i < n; ++i) {
1008             if (owner == _owners[i]) {
1009                 if (count == index) {
1010                     return i;
1011                 } else {
1012                     ++count;
1013                 }
1014             }
1015         }
1016         require(false, "Token not found.");
1017     }
1018     
1019     function totalSupply() public view virtual override returns (uint256) {
1020         return _owners.length;
1021     }
1022     
1023     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1024         require(index < ERC721Enumerable.totalSupply(), "Token not found.");
1025         return index;
1026     }
1027 }
1028 
1029 pragma solidity ^0.8.0;
1030 pragma abicoder v2;
1031 
1032 // import "@openzeppelin/contracts@4.3.2/access/Ownable.sol";
1033 // import "@openzeppelin/contracts@4.3.2/security/ReentrancyGuard.sol";
1034 
1035 contract SorasDreamworldLucidDreaming is ERC721Enumerable, Ownable, ReentrancyGuard {
1036 
1037     using Strings for uint;
1038     
1039     uint public constant TOKEN_PRICE = 80000000000000000; // 0.08 ETH
1040 
1041     uint public constant PRE_SALE_TOKEN_PRICE = 50000000000000000; // 0.05 ETH
1042 
1043     uint public constant MAX_TOKENS_PER_PUBLIC_MINT = 10; // Only applies during public sale.
1044 
1045     uint public constant MAX_TOKENS = 8888;
1046 
1047     address public constant GENESIS_BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
1048 
1049     /// @dev 1: presale, 2: public sale, 3: genesis claim, 4: genesis burn, 255: closed.
1050     uint public saleState; 
1051 
1052     /// @dev A mapping of the token names.
1053     mapping(uint => string) public tokenNames;
1054 
1055     // @dev Whether the presale slot has been used. One slot per address.
1056     mapping(address => bool) public presaleUsed;
1057 
1058     /// @dev 256-bit words, each representing 256 booleans.
1059     mapping(uint => uint) internal genesisClaimedMap;
1060 
1061     /// @dev The license text/url for every token.
1062     string public LICENSE = "https://www.nftlicense.org"; 
1063 
1064     /// @dev Link to a Chainrand NFT.
1065     ///      This contains all the information needed to reproduce
1066     ///      the traits with a locked Chainlink VRF result.
1067     string public PROVENANCE; 
1068 
1069     /// @dev The base URI
1070     string public baseURI;
1071 
1072     event TokenNameChanged(address _by, uint _tokenId, string _name);
1073 
1074     event LicenseSet(string _license);
1075 
1076     event ProvenanceSet(string _provenance);
1077 
1078     event SaleClosed();
1079 
1080     event PreSaleOpened();
1081 
1082     event PublicSaleOpened();
1083 
1084     event GenesisClaimOpened();
1085 
1086     event GenesisBurnOpened();
1087 
1088     // IMPORTANT: Make sure to change this to the correct address before publishing!
1089     // Gen 0 mainnet address: 0x4e2781e3aD94b2DfcF34c51De0D8e9358c69F296
1090     IERC721 internal genesisContract = IERC721(0x4e2781e3aD94b2DfcF34c51De0D8e9358c69F296);
1091 
1092     constructor() 
1093     ERC721("Sora's Dreamworld: LUCID DREAMING", "SDLD") { 
1094         saleState = 255;
1095         baseURI = "https://sorasdreamworld.io/tokens/dark/";
1096     }
1097     
1098     /// @dev Withdraws Ether for the owner.    
1099     function withdraw() public onlyOwner {
1100         uint256 amount = address(this).balance;
1101         payable(msg.sender).transfer(amount);
1102     }
1103 
1104     /// @dev Sets the provenance.
1105     function setProvenance(string memory _provenance) public onlyOwner {
1106         PROVENANCE = _provenance;
1107         emit ProvenanceSet(_provenance);
1108     }
1109 
1110     /// @dev Sets base URI for all token IDs. 
1111     ///      e.g. https://sorasdreamworld.io/tokens/dark/
1112     function setBaseURI(string memory _baseURI) public onlyOwner {
1113         baseURI = _baseURI;
1114     }
1115 
1116     /// @dev Open the pre-sale. 
1117     function openPreSale() public onlyOwner {
1118         saleState = 1;
1119         emit PreSaleOpened();
1120     }
1121 
1122     /// @dev Open the public sale. 
1123     function openPublicSale() public onlyOwner {
1124         saleState = 2;
1125         emit PublicSaleOpened();
1126     }
1127 
1128     /// @dev Open the claim phase. 
1129     function openGenesisClaim() public onlyOwner {
1130         saleState = 3;
1131         emit GenesisClaimOpened();
1132     }
1133 
1134     /// @dev Open the burn phase. 
1135     function openGenesisBurn() public onlyOwner {
1136         saleState = 4;
1137         emit GenesisBurnOpened();
1138     }
1139 
1140     /// @dev Close the sale.
1141     function closeSale() public onlyOwner {
1142         saleState = 255;
1143         emit SaleClosed();
1144     }
1145 
1146     /// @dev Mint just one NFT.
1147     function mintOne(address _toAddress) internal {
1148         uint mintIndex = totalSupply();
1149         require(mintIndex < MAX_TOKENS, "Sold out.");
1150         _safeMint(_toAddress, mintIndex);
1151     }
1152 
1153     /// @dev Force mint for the addresses. 
1154     //       Can be called anytime.
1155     //       If called right after the creation of the contract, the tokens 
1156     //       are assigned sequentially starting from id 0. 
1157     function forceMint(address[] memory _addresses) public onlyOwner { 
1158         for (uint i = 0; i < _addresses.length; ++i) {
1159             mintOne(_addresses[i]);
1160         }
1161     }
1162     
1163     /// @dev Self mint for the owner. 
1164     ///      Can be called anytime.
1165     ///      This does not require the sale to be open.
1166     function selfMint(uint _numTokens) public onlyOwner { 
1167         for (uint i = 0; i < _numTokens; ++i) {
1168             mintOne(msg.sender);
1169         }
1170     }
1171     
1172     /// @dev Sets the license text.
1173     function setLicense(string memory _license) public onlyOwner {
1174         LICENSE = _license;
1175         emit LicenseSet(_license);
1176     }
1177 
1178     /// @dev Returns the license for tokens.
1179     function tokenLicense(uint _id) public view returns(string memory) {
1180         require(_id < totalSupply(), "Token not found.");
1181         return LICENSE;
1182     }
1183     
1184     /// @dev Mints tokens.
1185     function mint(uint _numTokens) public payable nonReentrant {
1186         // saleState == 1 || saleState == 2. Zero is not used.
1187         require(saleState < 3, "Not open."); 
1188         require(_numTokens > 0, "Minimum number to mint is 1.");
1189         
1190         address sender = msg.sender;
1191 
1192         uint effectiveTokenPrice;
1193         if (saleState == 1) {
1194             effectiveTokenPrice = PRE_SALE_TOKEN_PRICE; 
1195             require(_numTokens <= 1, "Number per mint exceeded.");
1196             require(genesisContract.balanceOf(sender) > 0, "You don't have a Dream Machine.");
1197             require(!presaleUsed[sender], "Presale slot already used.");
1198             presaleUsed[sender] = true;
1199         } else { // 2
1200             effectiveTokenPrice = TOKEN_PRICE;
1201             require(_numTokens <= MAX_TOKENS_PER_PUBLIC_MINT, "Number per mint exceeded.");
1202         }
1203 
1204         require(msg.value >= effectiveTokenPrice * _numTokens, "Wrong Ether value.");
1205 
1206         for (uint i = 0; i < _numTokens; ++i) {
1207             mintOne(sender);
1208         }
1209     }
1210 
1211     /// @dev Returns whether the genesis token has been claimed.
1212     function checkGenesisClaimed(uint _genesisId) public view returns(bool) {
1213         uint t = _genesisId;
1214         uint q = t >> 8;
1215         uint r = t & 255;
1216         uint m = genesisClaimedMap[q];
1217         return m & (1 << r) != 0;
1218     }
1219 
1220     /// @dev Returns an array of uints representing whether the token has been claimed.
1221     function genesisClaimed(uint[] memory _genesisIds) public view returns(bool[] memory) {
1222         uint n = _genesisIds.length;
1223         bool[] memory a = new bool[](n);
1224         for (uint i = 0; i < n; ++i) {
1225             a[i] = checkGenesisClaimed(_genesisIds[i]);
1226         }
1227         return a;
1228     }
1229 
1230     /// @dev Use the genesis tokens to claim free mints.
1231     function genesisClaim(uint[] memory _genesisIds) public nonReentrant {
1232         require(saleState == 3, "Not open.");
1233         uint n = _genesisIds.length;
1234         require(n > 0 && n % 3 == 0, "Please submit a positive multiple of 3.");
1235         address sender = msg.sender;
1236         uint qPrevInitial = 1 << 255;
1237         uint qPrev = qPrevInitial;
1238         uint m;
1239         for (uint i = 0; i < n; i += 3) {
1240             for (uint j = 0; j < 3; ++j) {
1241                 uint t = _genesisIds[i + j];
1242                 uint q = t >> 8;
1243                 uint r = t & 255;
1244                 if (q != qPrev) {
1245                     if (qPrev != qPrevInitial) {
1246                         genesisClaimedMap[qPrev] = m;
1247                     } 
1248                     m = genesisClaimedMap[q];
1249                 } 
1250                 qPrev = q;
1251                 uint b = 1 << r;
1252                 // Token must be unused and owned.
1253                 require(m & b == 0 && genesisContract.ownerOf(t) == sender, "Invalid submission.");
1254                 // Modifying the map and checking will ensure that there 
1255                 // are no duplicates in _genesisIds.
1256                 m = m | b;
1257             }
1258             mintOne(sender);
1259         }
1260         genesisClaimedMap[qPrev] = m;    
1261     }
1262 
1263     /// @dev Burns the genesis tokens for free mints.
1264     function genesisBurn(uint[] memory _genesisIds) public nonReentrant {
1265         require(saleState == 4, "Not open.");
1266         uint n = _genesisIds.length;
1267         require(n > 0 && n & 1 == 0, "Please submit a positive multiple of 2.");
1268         address sender = msg.sender;
1269         for (uint i = 0; i < n; i += 2) {
1270             // Transfer from requires that the token must be owned.
1271             // Calling it in sequence will ensure that no are no 
1272             // duplicates in _genesisIds.
1273             genesisContract.transferFrom(sender, GENESIS_BURN_ADDRESS, _genesisIds[i]);
1274             genesisContract.transferFrom(sender, GENESIS_BURN_ADDRESS, _genesisIds[i + 1]);
1275             mintOne(sender);
1276         }   
1277     }
1278 
1279     /// @dev Returns an array of the token ids under the owner.
1280     function tokensOfOwner(address _owner) external view returns (uint[] memory) {
1281         uint[] memory a = new uint[](balanceOf(_owner));
1282         uint j = 0;
1283         uint n = _owners.length;
1284         for (uint i; i < n; ++i) {
1285             if (_owner == _owners[i]) {
1286                 a[j++] = i;
1287             }
1288         }
1289         return a;
1290     }
1291     
1292     /// @dev Change the token name.
1293     function changeTokenName(uint _id, string memory _name) public {
1294         require(ownerOf(_id) == msg.sender, "You do not own this token.");
1295         require(sha256(bytes(_name)) != sha256(bytes(tokenNames[_id])), "Name unchanged.");
1296         tokenNames[_id] = _name;
1297         emit TokenNameChanged(msg.sender, _id, _name);
1298     }
1299 
1300     /// @dev Returns the token's URI for the metadata.
1301     function tokenURI(uint256 _id) public view virtual override returns (string memory) {
1302         require(_id < totalSupply(), "Token not found.");
1303         return string(abi.encodePacked(baseURI, _id.toString()));
1304     }
1305 
1306     /// @dev Returns the most relevant stats in a single go to reduce RPC calls.
1307     function stats() external view returns (uint[] memory) {
1308         uint[] memory a = new uint[](4);
1309         a[0] = saleState; 
1310         a[1] = totalSupply(); 
1311         a[2] = genesisContract.balanceOf(GENESIS_BURN_ADDRESS);
1312         a[3] = saleState == 1 ? PRE_SALE_TOKEN_PRICE : TOKEN_PRICE;
1313         return a;
1314     }
1315 }