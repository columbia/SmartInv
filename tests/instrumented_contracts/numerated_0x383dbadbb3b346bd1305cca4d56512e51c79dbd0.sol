1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-25
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-06-27
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-06-23
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 // File 1: Address.sol
20 
21 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
22 
23 pragma solidity ^0.8.1;
24 
25 /**
26  * @dev Collection of functions related to the address type
27  */
28 library Address {
29     /**
30      * @dev Returns true if `account` is a contract.
31      *
32      * [IMPORTANT]
33      * ====
34      * It is unsafe to assume that an address for which this function returns
35      * false is an externally-owned account (EOA) and not a contract.
36      *
37      * Among others, `isContract` will return false for the following
38      * types of addresses:
39      *
40      *  - an externally-owned account
41      *  - a contract in construction
42      *  - an address where a contract will be created
43      *  - an address where a contract lived, but was destroyed
44      * ====
45      *
46      * [IMPORTANT]
47      * ====
48      * You shouldn't rely on `isContract` to protect against flash loan attacks!
49      *
50      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
51      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
52      * constructor.
53      * ====
54      */
55     function isContract(address account) internal view returns (bool) {
56         // This method relies on extcodesize/address.code.length, which returns 0
57         // for contracts in construction, since the code is only stored at the end
58         // of the constructor execution.
59 
60         return account.code.length > 0;
61     }
62 
63     /**
64      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
65      * `recipient`, forwarding all available gas and reverting on errors.
66      *
67      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
68      * of certain opcodes, possibly making contracts go over the 2300 gas limit
69      * imposed by `transfer`, making them unable to receive funds via
70      * `transfer`. {sendValue} removes this limitation.
71      *
72      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
73      *
74      * IMPORTANT: because control is transferred to `recipient`, care must be
75      * taken to not create reentrancy vulnerabilities. Consider using
76      * {ReentrancyGuard} or the
77      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
78      */
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         (bool success, ) = recipient.call{value: amount}("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     /**
87      * @dev Performs a Solidity function call using a low level `call`. A
88      * plain `call` is an unsafe replacement for a function call: use this
89      * function instead.
90      *
91      * If `target` reverts with a revert reason, it is bubbled up by this
92      * function (like regular Solidity function calls).
93      *
94      * Returns the raw returned data. To convert to the expected return value,
95      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
96      *
97      * Requirements:
98      *
99      * - `target` must be a contract.
100      * - calling `target` with `data` must not revert.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
110      * `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(
115         address target,
116         bytes memory data,
117         string memory errorMessage
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but also transferring `value` wei to `target`.
125      *
126      * Requirements:
127      *
128      * - the calling contract must have an ETH balance of at least `value`.
129      * - the called Solidity function must be `payable`.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value
137     ) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
143      * with `errorMessage` as a fallback revert reason when `target` reverts.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value,
151         string memory errorMessage
152     ) internal returns (bytes memory) {
153         require(address(this).balance >= value, "Address: insufficient balance for call");
154         require(isContract(target), "Address: call to non-contract");
155 
156         (bool success, bytes memory returndata) = target.call{value: value}(data);
157         return verifyCallResult(success, returndata, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
162      * but performing a static call.
163      *
164      * _Available since v3.3._
165      */
166     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
167         return functionStaticCall(target, data, "Address: low-level static call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal view returns (bytes memory) {
181         require(isContract(target), "Address: static call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.staticcall(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but performing a delegate call.
190      *
191      * _Available since v3.4._
192      */
193     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(isContract(target), "Address: delegate call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
216      * revert reason using the provided one.
217      *
218      * _Available since v4.3._
219      */
220     function verifyCallResult(
221         bool success,
222         bytes memory returndata,
223         string memory errorMessage
224     ) internal pure returns (bytes memory) {
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231 
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Contract module that helps prevent reentrant calls to a function.
252  *
253  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
254  * available, which can be applied to functions to make sure there are no nested
255  * (reentrant) calls to them.
256  *
257  * Note that because there is a single `nonReentrant` guard, functions marked as
258  * `nonReentrant` may not call one another. This can be worked around by making
259  * those functions `private`, and then adding `external` `nonReentrant` entry
260  * points to them.
261  *
262  * TIP: If you would like to learn more about reentrancy and alternative ways
263  * to protect against it, check out our blog post
264  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
265  */
266 abstract contract ReentrancyGuard {
267     // Booleans are more expensive than uint256 or any type that takes up a full
268     // word because each write operation emits an extra SLOAD to first read the
269     // slot's contents, replace the bits taken up by the boolean, and then write
270     // back. This is the compiler's defense against contract upgrades and
271     // pointer aliasing, and it cannot be disabled.
272 
273     // The values being non-zero value makes deployment a bit more expensive,
274     // but in exchange the refund on every call to nonReentrant will be lower in
275     // amount. Since refunds are capped to a percentage of the total
276     // transaction's gas, it is best to keep them low in cases like this one, to
277     // increase the likelihood of the full refund coming into effect.
278     uint256 private constant _NOT_ENTERED = 1;
279     uint256 private constant _ENTERED = 2;
280 
281     uint256 private _status;
282 
283     constructor() {
284         _status = _NOT_ENTERED;
285     }
286 
287     /**
288      * @dev Prevents a contract from calling itself, directly or indirectly.
289      * Calling a `nonReentrant` function from another `nonReentrant`
290      * function is not supported. It is possible to prevent this from happening
291      * by making the `nonReentrant` function external, and making it call a
292      * `private` function that does the actual work.
293      */
294     modifier nonReentrant() {
295         // On the first call to nonReentrant, _notEntered will be true
296         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
297 
298         // Any calls to nonReentrant after this point will fail
299         _status = _ENTERED;
300 
301         _;
302 
303         // By storing the original value once again, a refund is triggered (see
304         // https://eips.ethereum.org/EIPS/eip-2200)
305         _status = _NOT_ENTERED;
306     }
307 }
308 
309 // FILE 2: Context.sol
310 pragma solidity ^0.8.0;
311 
312 /*
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
329         return msg.data;
330     }
331 }
332 
333 // File 3: Strings.sol
334 
335 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev String operations.
341  */
342 library Strings {
343     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
344 
345     /**
346      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
347      */
348     function toString(uint256 value) internal pure returns (string memory) {
349         // Inspired by OraclizeAPI's implementation - MIT licence
350         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
351 
352         if (value == 0) {
353             return "0";
354         }
355         uint256 temp = value;
356         uint256 digits;
357         while (temp != 0) {
358             digits++;
359             temp /= 10;
360         }
361         bytes memory buffer = new bytes(digits);
362         while (value != 0) {
363             digits -= 1;
364             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
365             value /= 10;
366         }
367         return string(buffer);
368     }
369 
370     /**
371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
372      */
373     function toHexString(uint256 value) internal pure returns (string memory) {
374         if (value == 0) {
375             return "0x00";
376         }
377         uint256 temp = value;
378         uint256 length = 0;
379         while (temp != 0) {
380             length++;
381             temp >>= 8;
382         }
383         return toHexString(value, length);
384     }
385 
386     /**
387      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
388      */
389     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
390         bytes memory buffer = new bytes(2 * length + 2);
391         buffer[0] = "0";
392         buffer[1] = "x";
393         for (uint256 i = 2 * length + 1; i > 1; --i) {
394             buffer[i] = _HEX_SYMBOLS[value & 0xf];
395             value >>= 4;
396         }
397         require(value == 0, "Strings: hex length insufficient");
398         return string(buffer);
399     }
400 }
401 
402 
403 // File: @openzeppelin/contracts/utils/Counters.sol
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @title Counters
412  * @author Matt Condon (@shrugs)
413  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
414  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
415  *
416  * Include with `using Counters for Counters.Counter;`
417  */
418 library Counters {
419     struct Counter {
420         // This variable should never be directly accessed by users of the library: interactions must be restricted to
421         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
422         // this feature: see https://github.com/ethereum/solidity/issues/4637
423         uint256 _value; // default: 0
424     }
425 
426     function current(Counter storage counter) internal view returns (uint256) {
427         return counter._value;
428     }
429 
430     function increment(Counter storage counter) internal {
431         unchecked {
432             counter._value += 1;
433         }
434     }
435 
436     function decrement(Counter storage counter) internal {
437         uint256 value = counter._value;
438         require(value > 0, "Counter: decrement overflow");
439         unchecked {
440             counter._value = value - 1;
441         }
442     }
443 
444     function reset(Counter storage counter) internal {
445         counter._value = 0;
446     }
447 }
448 
449 // File 4: Ownable.sol
450 
451 
452 pragma solidity ^0.8.0;
453 
454 
455 /**
456  * @dev Contract module which provides a basic access control mechanism, where
457  * there is an account (an owner) that can be granted exclusive access to
458  * specific functions.
459  *
460  * By default, the owner account will be the one that deploys the contract. This
461  * can later be changed with {transferOwnership}.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * `onlyOwner`, which can be applied to your functions to restrict their use to
465  * the owner.
466  */
467 abstract contract Ownable is Context {
468     address private _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor () {
476         address msgSender = _msgSender();
477         _owner = msgSender;
478         emit OwnershipTransferred(address(0), msgSender);
479     }
480 
481     /**
482      * @dev Returns the address of the current owner.
483      */
484     function owner() public view virtual returns (address) {
485         return _owner;
486     }
487 
488     /**
489      * @dev Throws if called by any account other than the owner.
490      */
491     modifier onlyOwner() {
492         require(owner() == _msgSender(), "Ownable: caller is not the owner");
493         _;
494     }
495 
496     /**
497      * @dev Leaves the contract without owner. It will not be possible to call
498      * `onlyOwner` functions anymore. Can only be called by the current owner.
499      *
500      * NOTE: Renouncing ownership will leave the contract without an owner,
501      * thereby removing any functionality that is only available to the owner.
502      */
503     function renounceOwnership() public virtual onlyOwner {
504         emit OwnershipTransferred(_owner, address(0));
505         _owner = address(0);
506     }
507 
508     /**
509      * @dev Transfers ownership of the contract to a new account (`newOwner`).
510      * Can only be called by the current owner.
511      */
512     function transferOwnership(address newOwner) public virtual onlyOwner {
513         require(newOwner != address(0), "Ownable: new owner is the zero address");
514         emit OwnershipTransferred(_owner, newOwner);
515         _owner = newOwner;
516     }
517 }
518 
519 
520 
521 
522 
523 // File 5: IERC165.sol
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Interface of the ERC165 standard, as defined in the
529  * https://eips.ethereum.org/EIPS/eip-165[EIP].
530  *
531  * Implementers can declare support of contract interfaces, which can then be
532  * queried by others ({ERC165Checker}).
533  *
534  * For an implementation, see {ERC165}.
535  */
536 interface IERC165 {
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30 000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) external view returns (bool);
546 }
547 
548 
549 // File 6: IERC721.sol
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Required interface of an ERC721 compliant contract.
556  */
557 interface IERC721 is IERC165 {
558     /**
559      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
560      */
561     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
565      */
566     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
567 
568     /**
569      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
570      */
571     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
572 
573     /**
574      * @dev Returns the number of tokens in ``owner``'s account.
575      */
576     function balanceOf(address owner) external view returns (uint256 balance);
577 
578     /**
579      * @dev Returns the owner of the `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function ownerOf(uint256 tokenId) external view returns (address owner);
586 
587     /**
588      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
589      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function safeTransferFrom(address from, address to, uint256 tokenId) external;
602 
603     /**
604      * @dev Transfers `tokenId` token from `from` to `to`.
605      *
606      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(address from, address to, uint256 tokenId) external;
618 
619     /**
620      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
621      * The approval is cleared when the token is transferred.
622      *
623      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
624      *
625      * Requirements:
626      *
627      * - The caller must own the token or be an approved operator.
628      * - `tokenId` must exist.
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address to, uint256 tokenId) external;
633 
634     /**
635      * @dev Returns the account approved for `tokenId` token.
636      *
637      * Requirements:
638      *
639      * - `tokenId` must exist.
640      */
641     function getApproved(uint256 tokenId) external view returns (address operator);
642 
643     /**
644      * @dev Approve or remove `operator` as an operator for the caller.
645      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
646      *
647      * Requirements:
648      *
649      * - The `operator` cannot be the caller.
650      *
651      * Emits an {ApprovalForAll} event.
652      */
653     function setApprovalForAll(address operator, bool _approved) external;
654 
655     /**
656      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
657      *
658      * See {setApprovalForAll}
659      */
660     function isApprovedForAll(address owner, address operator) external view returns (bool);
661 
662     /**
663       * @dev Safely transfers `tokenId` token from `from` to `to`.
664       *
665       * Requirements:
666       *
667       * - `from` cannot be the zero address.
668       * - `to` cannot be the zero address.
669       * - `tokenId` token must exist and be owned by `from`.
670       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672       *
673       * Emits a {Transfer} event.
674       */
675     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
676 }
677 
678 
679 
680 // File 7: IERC721Metadata.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
690  * @dev See https://eips.ethereum.org/EIPS/eip-721
691  */
692 interface IERC721Metadata is IERC721 {
693     /**
694      * @dev Returns the token collection name.
695      */
696     function name() external view returns (string memory);
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() external view returns (string memory);
702 
703     /**
704      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
705      */
706     function tokenURI(uint256 tokenId) external returns (string memory);
707 }
708 
709 
710 
711 
712 // File 8: ERC165.sol
713 
714 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Implementation of the {IERC165} interface.
721  *
722  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
723  * for the additional interface id that will be supported. For example:
724  *
725  * ```solidity
726  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
728  * }
729  * ```
730  *
731  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
732  */
733 abstract contract ERC165 is IERC165 {
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         return interfaceId == type(IERC165).interfaceId;
739     }
740 }
741 
742 
743 // File 9: ERC721.sol
744 
745 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
752  * the Metadata extension, but not including the Enumerable extension, which is available separately as
753  * {ERC721Enumerable}.
754  */
755 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
756     using Address for address;
757     using Strings for uint256;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Mapping from token ID to owner address
766     mapping(uint256 => address) private _owners;
767 
768     // Mapping owner address to token count
769     mapping(address => uint256) private _balances;
770 
771     // Mapping from token ID to approved address
772     mapping(uint256 => address) private _tokenApprovals;
773 
774     // Mapping from owner to operator approvals
775     mapping(address => mapping(address => bool)) private _operatorApprovals;
776 
777     /**
778      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
779      */
780     constructor(string memory name_, string memory symbol_) {
781         _name = name_;
782         _symbol = symbol_;
783     }
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
789         return
790             interfaceId == type(IERC721).interfaceId ||
791             interfaceId == type(IERC721Metadata).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721-balanceOf}.
797      */
798     function balanceOf(address owner) public view virtual override returns (uint256) {
799         require(owner != address(0), "ERC721: balance query for the zero address");
800         return _balances[owner];
801     }
802 
803     /**
804      * @dev See {IERC721-ownerOf}.
805      */
806     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
807         address owner = _owners[tokenId];
808         require(owner != address(0), "ERC721: owner query for nonexistent token");
809         return owner;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-name}.
814      */
815     function name() public view virtual override returns (string memory) {
816         return _name;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-symbol}.
821      */
822     function symbol() public view virtual override returns (string memory) {
823         return _symbol;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-tokenURI}.
828      */
829     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
830         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
831 
832         string memory baseURI = _baseURI();
833         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
834     }
835 
836     /**
837      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
838      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
839      * by default, can be overridden in child contracts.
840      */
841     function _baseURI() internal view virtual returns (string memory) {
842         return "";
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public virtual override {
849         address owner = ERC721.ownerOf(tokenId);
850         require(to != owner, "ERC721: approval to current owner");
851 
852         require(
853             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
854             "ERC721: approve caller is not owner nor approved for all"
855         );
856         if (to.isContract()) {
857             revert ("Token transfer to contract address is not allowed.");
858         } else {
859             _approve(to, tokenId);
860         }
861         // _approve(to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId) public view virtual override returns (address) {
868         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
869 
870         return _tokenApprovals[tokenId];
871     }
872 
873     /**
874      * @dev See {IERC721-setApprovalForAll}.
875      */
876     function setApprovalForAll(address operator, bool approved) public virtual override {
877         _setApprovalForAll(_msgSender(), operator, approved);
878     }
879 
880     /**
881      * @dev See {IERC721-isApprovedForAll}.
882      */
883     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
884         return _operatorApprovals[owner][operator];
885     }
886 
887     /**
888      * @dev See {IERC721-transferFrom}.
889      */
890     function transferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         //solhint-disable-next-line max-line-length
896         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
897 
898         _transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         safeTransferFrom(from, to, tokenId, "");
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public virtual override {
921         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
922         _safeTransfer(from, to, tokenId, _data);
923     }
924 
925     /**
926      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
927      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
928      *
929      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
930      *
931      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
932      * implement alternative mechanisms to perform token transfer, such as signature-based.
933      *
934      * Requirements:
935      *
936      * - `from` cannot be the zero address.
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must exist and be owned by `from`.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeTransfer(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _transfer(from, to, tokenId);
950         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
951     }
952 
953     /**
954      * @dev Returns whether `tokenId` exists.
955      *
956      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
957      *
958      * Tokens start existing when they are minted (`_mint`),
959      * and stop existing when they are burned (`_burn`).
960      */
961     function _exists(uint256 tokenId) internal view virtual returns (bool) {
962         return _owners[tokenId] != address(0);
963     }
964 
965     /**
966      * @dev Returns whether `spender` is allowed to manage `tokenId`.
967      *
968      * Requirements:
969      *
970      * - `tokenId` must exist.
971      */
972     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
973         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
974         address owner = ERC721.ownerOf(tokenId);
975         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
976     }
977 
978     /**
979      * @dev Safely mints `tokenId` and transfers it to `to`.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must not exist.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeMint(address to, uint256 tokenId) internal virtual {
989         _safeMint(to, tokenId, "");
990     }
991 
992     /**
993      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
994      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
995      */
996     function _safeMint(
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) internal virtual {
1001         _mint(to, tokenId);
1002         require(
1003             _checkOnERC721Received(address(0), to, tokenId, _data),
1004             "ERC721: transfer to non ERC721Receiver implementer"
1005         );
1006     }
1007 
1008     /**
1009      * @dev Mints `tokenId` and transfers it to `to`.
1010      *
1011      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must not exist.
1016      * - `to` cannot be the zero address.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _mint(address to, uint256 tokenId) internal virtual {
1021         require(to != address(0), "ERC721: mint to the zero address");
1022         require(!_exists(tokenId), "ERC721: token already minted");
1023 
1024         _beforeTokenTransfer(address(0), to, tokenId);
1025 
1026         _balances[to] += 1;
1027         _owners[tokenId] = to;
1028 
1029         emit Transfer(address(0), to, tokenId);
1030 
1031         _afterTokenTransfer(address(0), to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Destroys `tokenId`.
1036      * The approval is cleared when the token is burned.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _burn(uint256 tokenId) internal virtual {
1045         address owner = ERC721.ownerOf(tokenId);
1046 
1047         _beforeTokenTransfer(owner, address(0), tokenId);
1048 
1049         // Clear approvals
1050         _approve(address(0), tokenId);
1051 
1052         _balances[owner] -= 1;
1053         delete _owners[tokenId];
1054 
1055         emit Transfer(owner, address(0), tokenId);
1056 
1057         _afterTokenTransfer(owner, address(0), tokenId);
1058     }
1059 
1060     /**
1061      * @dev Transfers `tokenId` from `from` to `to`.
1062      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must be owned by `from`.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _transfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual {
1076         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1077         require(to != address(0), "ERC721: transfer to the zero address");
1078 
1079         _beforeTokenTransfer(from, to, tokenId);
1080 
1081         // Clear approvals from the previous owner
1082         _approve(address(0), tokenId);
1083 
1084         _balances[from] -= 1;
1085         _balances[to] += 1;
1086         _owners[tokenId] = to;
1087 
1088         emit Transfer(from, to, tokenId);
1089 
1090         _afterTokenTransfer(from, to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Approve `to` to operate on `tokenId`
1095      *
1096      * Emits a {Approval} event.
1097      */
1098     function _approve(address to, uint256 tokenId) internal virtual {
1099         _tokenApprovals[tokenId] = to;
1100         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev Approve `operator` to operate on all of `owner` tokens
1105      *
1106      * Emits a {ApprovalForAll} event.
1107      */
1108     function _setApprovalForAll(
1109         address owner,
1110         address operator,
1111         bool approved
1112     ) internal virtual {
1113         require(owner != operator, "ERC721: approve to caller");
1114         _operatorApprovals[owner][operator] = approved;
1115         emit ApprovalForAll(owner, operator, approved);
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param _data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1136                 return retval == IERC721Receiver.onERC721Received.selector;
1137             } catch (bytes memory reason) {
1138                 if (reason.length == 0) {
1139                     revert("ERC721: transfer to non ERC721Receiver implementer");
1140                 } else {
1141                     assembly {
1142                         revert(add(32, reason), mload(reason))
1143                     }
1144                 }
1145             }
1146         } else {
1147             return true;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Hook that is called before any token transfer. This includes minting
1153      * and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` will be minted for `to`.
1160      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1161      * - `from` and `to` are never both zero.
1162      *
1163      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1164      */
1165     function _beforeTokenTransfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {}
1170 
1171     /**
1172      * @dev Hook that is called after any transfer of tokens. This includes
1173      * minting and burning.
1174      *
1175      * Calling conditions:
1176      *
1177      * - when `from` and `to` are both non-zero.
1178      * - `from` and `to` are never both zero.
1179      *
1180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1181      */
1182     function _afterTokenTransfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) internal virtual {}
1187 }
1188 
1189 
1190 
1191 
1192 
1193 // File 10: IERC721Enumerable.sol
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 
1198 /**
1199  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1200  * @dev See https://eips.ethereum.org/EIPS/eip-721
1201  */
1202 interface IERC721Enumerable is IERC721 {
1203 
1204     /**
1205      * @dev Returns the total amount of tokens stored by the contract.
1206      */
1207     function totalSupply() external view returns (uint256);
1208 
1209     /**
1210      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1211      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1212      */
1213     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1214 
1215     /**
1216      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1217      * Use along with {totalSupply} to enumerate all tokens.
1218      */
1219     function tokenByIndex(uint256 index) external view returns (uint256);
1220 }
1221 
1222 
1223 
1224 
1225 
1226 
1227 // File 11: ERC721Enumerable.sol
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 
1232 /**
1233  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1234  * enumerability of all the token ids in the contract as well as all token ids owned by each
1235  * account.
1236  */
1237 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1238     // Mapping from owner to list of owned token IDs
1239     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1240 
1241     // Mapping from token ID to index of the owner tokens list
1242     mapping(uint256 => uint256) private _ownedTokensIndex;
1243 
1244     // Array with all token ids, used for enumeration
1245     uint256[] private _allTokens;
1246 
1247     // Mapping from token id to position in the allTokens array
1248     mapping(uint256 => uint256) private _allTokensIndex;
1249 
1250     /**
1251      * @dev See {IERC165-supportsInterface}.
1252      */
1253     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1254         return interfaceId == type(IERC721Enumerable).interfaceId
1255             || super.supportsInterface(interfaceId);
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1260      */
1261     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1262         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1263         return _ownedTokens[owner][index];
1264     }
1265 
1266     /**
1267      * @dev See {IERC721Enumerable-totalSupply}.
1268      */
1269     function totalSupply() public view virtual override returns (uint256) {
1270         return _allTokens.length;
1271     }
1272 
1273     /**
1274      * @dev See {IERC721Enumerable-tokenByIndex}.
1275      */
1276     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1277         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1278         return _allTokens[index];
1279     }
1280 
1281     /**
1282      * @dev Hook that is called before any token transfer. This includes minting
1283      * and burning.
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1291      * - `from` cannot be the zero address.
1292      * - `to` cannot be the zero address.
1293      *
1294      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1295      */
1296     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1297         super._beforeTokenTransfer(from, to, tokenId);
1298 
1299         if (from == address(0)) {
1300             _addTokenToAllTokensEnumeration(tokenId);
1301         } else if (from != to) {
1302             _removeTokenFromOwnerEnumeration(from, tokenId);
1303         }
1304         if (to == address(0)) {
1305             _removeTokenFromAllTokensEnumeration(tokenId);
1306         } else if (to != from) {
1307             _addTokenToOwnerEnumeration(to, tokenId);
1308         }
1309     }
1310 
1311     /**
1312      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1313      * @param to address representing the new owner of the given token ID
1314      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1315      */
1316     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1317         uint256 length = ERC721.balanceOf(to);
1318         _ownedTokens[to][length] = tokenId;
1319         _ownedTokensIndex[tokenId] = length;
1320     }
1321 
1322     /**
1323      * @dev Private function to add a token to this extension's token tracking data structures.
1324      * @param tokenId uint256 ID of the token to be added to the tokens list
1325      */
1326     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1327         _allTokensIndex[tokenId] = _allTokens.length;
1328         _allTokens.push(tokenId);
1329     }
1330 
1331     /**
1332      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1333      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1334      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1335      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1336      * @param from address representing the previous owner of the given token ID
1337      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1338      */
1339     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1340         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1341         // then delete the last slot (swap and pop).
1342 
1343         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1344         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1345 
1346         // When the token to delete is the last token, the swap operation is unnecessary
1347         if (tokenIndex != lastTokenIndex) {
1348             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1349 
1350             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1351             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1352         }
1353 
1354         // This also deletes the contents at the last position of the array
1355         delete _ownedTokensIndex[tokenId];
1356         delete _ownedTokens[from][lastTokenIndex];
1357     }
1358 
1359     /**
1360      * @dev Private function to remove a token from this extension's token tracking data structures.
1361      * This has O(1) time complexity, but alters the order of the _allTokens array.
1362      * @param tokenId uint256 ID of the token to be removed from the tokens list
1363      */
1364     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1365         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1366         // then delete the last slot (swap and pop).
1367 
1368         uint256 lastTokenIndex = _allTokens.length - 1;
1369         uint256 tokenIndex = _allTokensIndex[tokenId];
1370 
1371         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1372         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1373         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1374         uint256 lastTokenId = _allTokens[lastTokenIndex];
1375 
1376         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1377         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1378 
1379         // This also deletes the contents at the last position of the array
1380         delete _allTokensIndex[tokenId];
1381         _allTokens.pop();
1382     }
1383 }
1384 
1385 
1386 
1387 // File 12: IERC721Receiver.sol
1388 
1389 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1390 
1391 pragma solidity ^0.8.0;
1392 
1393 /**
1394  * @title ERC721 token receiver interface
1395  * @dev Interface for any contract that wants to support safeTransfers
1396  * from ERC721 asset contracts.
1397  */
1398 interface IERC721Receiver {
1399     /**
1400      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1401      * by `operator` from `from`, this function is called.
1402      *
1403      * It must return its Solidity selector to confirm the token transfer.
1404      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1405      *
1406      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1407      */
1408     function onERC721Received(
1409         address operator,
1410         address from,
1411         uint256 tokenId,
1412         bytes calldata data
1413     ) external returns (bytes4);
1414 }
1415 
1416 
1417 
1418 // File 13: ERC721A.sol
1419 
1420 pragma solidity ^0.8.0;
1421 
1422 
1423 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1424     using Address for address;
1425     using Strings for uint256;
1426 
1427     struct TokenOwnership {
1428         address addr;
1429         uint64 startTimestamp;
1430     }
1431 
1432     struct AddressData {
1433         uint128 balance;
1434         uint128 numberMinted;
1435     }
1436 
1437     uint256 internal currentIndex;
1438 
1439     // Token name
1440     string private _name;
1441 
1442     // Token symbol
1443     string private _symbol;
1444 
1445     // Mapping from token ID to ownership details
1446     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1447     mapping(uint256 => TokenOwnership) internal _ownerships;
1448 
1449     // Mapping owner address to address data
1450     mapping(address => AddressData) private _addressData;
1451 
1452     // Mapping from token ID to approved address
1453     mapping(uint256 => address) private _tokenApprovals;
1454 
1455     // Mapping from owner to operator approvals
1456     mapping(address => mapping(address => bool)) private _operatorApprovals;
1457 
1458     constructor(string memory name_, string memory symbol_) {
1459         _name = name_;
1460         _symbol = symbol_;
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Enumerable-totalSupply}.
1465      */
1466     function totalSupply() public view override virtual returns (uint256) {
1467         return currentIndex;
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Enumerable-tokenByIndex}.
1472      */
1473     function tokenByIndex(uint256 index) public view override returns (uint256) {
1474         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1475         return index;
1476     }
1477 
1478     /**
1479      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1480      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1481      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1482      */
1483     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1484         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1485         uint256 numMintedSoFar = totalSupply();
1486         uint256 tokenIdsIdx;
1487         address currOwnershipAddr;
1488 
1489         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1490         unchecked {
1491             for (uint256 i; i < numMintedSoFar; i++) {
1492                 TokenOwnership memory ownership = _ownerships[i];
1493                 if (ownership.addr != address(0)) {
1494                     currOwnershipAddr = ownership.addr;
1495                 }
1496                 if (currOwnershipAddr == owner) {
1497                     if (tokenIdsIdx == index) {
1498                         return i;
1499                     }
1500                     tokenIdsIdx++;
1501                 }
1502             }
1503         }
1504 
1505         revert('ERC721A: unable to get token of owner by index');
1506     }
1507 
1508     /**
1509      * @dev See {IERC165-supportsInterface}.
1510      */
1511     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1512         return
1513             interfaceId == type(IERC721).interfaceId ||
1514             interfaceId == type(IERC721Metadata).interfaceId ||
1515             interfaceId == type(IERC721Enumerable).interfaceId ||
1516             super.supportsInterface(interfaceId);
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-balanceOf}.
1521      */
1522     function balanceOf(address owner) public view override returns (uint256) {
1523         require(owner != address(0), 'ERC721A: balance query for the zero address');
1524         return uint256(_addressData[owner].balance);
1525     }
1526 
1527     function _numberMinted(address owner) internal view returns (uint256) {
1528         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1529         return uint256(_addressData[owner].numberMinted);
1530     }
1531 
1532     /**
1533      * Gas spent here starts off proportional to the maximum mint batch size.
1534      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1535      */
1536     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1537         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1538 
1539         unchecked {
1540             for (uint256 curr = tokenId; curr >= 0; curr--) {
1541                 TokenOwnership memory ownership = _ownerships[curr];
1542                 if (ownership.addr != address(0)) {
1543                     return ownership;
1544                 }
1545             }
1546         }
1547 
1548         revert('ERC721A: unable to determine the owner of token');
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-ownerOf}.
1553      */
1554     function ownerOf(uint256 tokenId) public view override returns (address) {
1555         return ownershipOf(tokenId).addr;
1556     }
1557 
1558     /**
1559      * @dev See {IERC721Metadata-name}.
1560      */
1561     function name() public view virtual override returns (string memory) {
1562         return _name;
1563     }
1564 
1565     /**
1566      * @dev See {IERC721Metadata-symbol}.
1567      */
1568     function symbol() public view virtual override returns (string memory) {
1569         return _symbol;
1570     }
1571 
1572     /**
1573      * @dev See {IERC721Metadata-tokenURI}.
1574      */
1575     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1576         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1577 
1578         string memory baseURI = _baseURI();
1579         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1580     }
1581 
1582     /**
1583      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1584      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1585      * by default, can be overriden in child contracts.
1586      */
1587     function _baseURI() internal view virtual returns (string memory) {
1588         return '';
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-approve}.
1593      */
1594     function approve(address to, uint256 tokenId) public override {
1595         address owner = ERC721A.ownerOf(tokenId);
1596         require(to != owner, 'ERC721A: approval to current owner');
1597 
1598         require(
1599             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1600             'ERC721A: approve caller is not owner nor approved for all'
1601         );
1602 
1603         _approve(to, tokenId, owner);
1604     }
1605 
1606     /**
1607      * @dev See {IERC721-getApproved}.
1608      */
1609     function getApproved(uint256 tokenId) public view override returns (address) {
1610         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1611 
1612         return _tokenApprovals[tokenId];
1613     }
1614 
1615     /**
1616      * @dev See {IERC721-setApprovalForAll}.
1617      */
1618     function setApprovalForAll(address operator, bool approved) public override {
1619         require(operator != _msgSender(), 'ERC721A: approve to caller');
1620 
1621         _operatorApprovals[_msgSender()][operator] = approved;
1622         emit ApprovalForAll(_msgSender(), operator, approved);
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-isApprovedForAll}.
1627      */
1628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1629         return _operatorApprovals[owner][operator];
1630     }
1631 
1632     /**
1633      * @dev See {IERC721-transferFrom}.
1634      */
1635     function transferFrom(
1636         address from,
1637         address to,
1638         uint256 tokenId
1639     ) public override {
1640         _transfer(from, to, tokenId);
1641     }
1642 
1643     /**
1644      * @dev See {IERC721-safeTransferFrom}.
1645      */
1646     function safeTransferFrom(
1647         address from,
1648         address to,
1649         uint256 tokenId
1650     ) public override {
1651         safeTransferFrom(from, to, tokenId, '');
1652     }
1653 
1654     /**
1655      * @dev See {IERC721-safeTransferFrom}.
1656      */
1657     function safeTransferFrom(
1658         address from,
1659         address to,
1660         uint256 tokenId,
1661         bytes memory _data
1662     ) public override {
1663         _transfer(from, to, tokenId);
1664         require(
1665             _checkOnERC721Received(from, to, tokenId, _data),
1666             'ERC721A: transfer to non ERC721Receiver implementer'
1667         );
1668     }
1669 
1670     /**
1671      * @dev Returns whether `tokenId` exists.
1672      *
1673      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1674      *
1675      * Tokens start existing when they are minted (`_mint`),
1676      */
1677     function _exists(uint256 tokenId) internal view returns (bool) {
1678         return tokenId < currentIndex;
1679     }
1680 
1681     function _safeMint(address to, uint256 quantity) internal {
1682         _safeMint(to, quantity, '');
1683     }
1684 
1685     /**
1686      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1687      *
1688      * Requirements:
1689      *
1690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1691      * - `quantity` must be greater than 0.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function _safeMint(
1696         address to,
1697         uint256 quantity,
1698         bytes memory _data
1699     ) internal {
1700         _mint(to, quantity, _data, true);
1701     }
1702 
1703     /**
1704      * @dev Mints `quantity` tokens and transfers them to `to`.
1705      *
1706      * Requirements:
1707      *
1708      * - `to` cannot be the zero address.
1709      * - `quantity` must be greater than 0.
1710      *
1711      * Emits a {Transfer} event.
1712      */
1713     function _mint(
1714         address to,
1715         uint256 quantity,
1716         bytes memory _data,
1717         bool safe
1718     ) internal {
1719         uint256 startTokenId = currentIndex;
1720         require(to != address(0), 'ERC721A: mint to the zero address');
1721         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1722 
1723         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1724 
1725         // Overflows are incredibly unrealistic.
1726         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1727         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1728         unchecked {
1729             _addressData[to].balance += uint128(quantity);
1730             _addressData[to].numberMinted += uint128(quantity);
1731 
1732             _ownerships[startTokenId].addr = to;
1733             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1734 
1735             uint256 updatedIndex = startTokenId;
1736 
1737             for (uint256 i; i < quantity; i++) {
1738                 emit Transfer(address(0), to, updatedIndex);
1739                 if (safe) {
1740                     require(
1741                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1742                         'ERC721A: transfer to non ERC721Receiver implementer'
1743                     );
1744                 }
1745 
1746                 updatedIndex++;
1747             }
1748 
1749             currentIndex = updatedIndex;
1750         }
1751 
1752         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1753     }
1754 
1755     /**
1756      * @dev Transfers `tokenId` from `from` to `to`.
1757      *
1758      * Requirements:
1759      *
1760      * - `to` cannot be the zero address.
1761      * - `tokenId` token must be owned by `from`.
1762      *
1763      * Emits a {Transfer} event.
1764      */
1765     function _transfer(
1766         address from,
1767         address to,
1768         uint256 tokenId
1769     ) private {
1770         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1771 
1772         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1773             getApproved(tokenId) == _msgSender() ||
1774             isApprovedForAll(prevOwnership.addr, _msgSender()));
1775 
1776         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1777 
1778         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1779         require(to != address(0), 'ERC721A: transfer to the zero address');
1780 
1781         _beforeTokenTransfers(from, to, tokenId, 1);
1782 
1783         // Clear approvals from the previous owner
1784         _approve(address(0), tokenId, prevOwnership.addr);
1785 
1786         // Underflow of the sender's balance is impossible because we check for
1787         // ownership above and the recipient's balance can't realistically overflow.
1788         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1789         unchecked {
1790             _addressData[from].balance -= 1;
1791             _addressData[to].balance += 1;
1792 
1793             _ownerships[tokenId].addr = to;
1794             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1795 
1796             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1797             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1798             uint256 nextTokenId = tokenId + 1;
1799             if (_ownerships[nextTokenId].addr == address(0)) {
1800                 if (_exists(nextTokenId)) {
1801                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1802                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1803                 }
1804             }
1805         }
1806 
1807         emit Transfer(from, to, tokenId);
1808         _afterTokenTransfers(from, to, tokenId, 1);
1809     }
1810 
1811     /**
1812      * @dev Approve `to` to operate on `tokenId`
1813      *
1814      * Emits a {Approval} event.
1815      */
1816     function _approve(
1817         address to,
1818         uint256 tokenId,
1819         address owner
1820     ) private {
1821         _tokenApprovals[tokenId] = to;
1822         emit Approval(owner, to, tokenId);
1823     }
1824 
1825     /**
1826      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1827      * The call is not executed if the target address is not a contract.
1828      *
1829      * @param from address representing the previous owner of the given token ID
1830      * @param to target address that will receive the tokens
1831      * @param tokenId uint256 ID of the token to be transferred
1832      * @param _data bytes optional data to send along with the call
1833      * @return bool whether the call correctly returned the expected magic value
1834      */
1835     function _checkOnERC721Received(
1836         address from,
1837         address to,
1838         uint256 tokenId,
1839         bytes memory _data
1840     ) private returns (bool) {
1841         if (to.isContract()) {
1842             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1843                 return retval == IERC721Receiver(to).onERC721Received.selector;
1844             } catch (bytes memory reason) {
1845                 if (reason.length == 0) {
1846                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1847                 } else {
1848                     assembly {
1849                         revert(add(32, reason), mload(reason))
1850                     }
1851                 }
1852             }
1853         } else {
1854             return true;
1855         }
1856     }
1857 
1858     /**
1859      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1860      *
1861      * startTokenId - the first token id to be transferred
1862      * quantity - the amount to be transferred
1863      *
1864      * Calling conditions:
1865      *
1866      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1867      * transferred to `to`.
1868      * - When `from` is zero, `tokenId` will be minted for `to`.
1869      */
1870     function _beforeTokenTransfers(
1871         address from,
1872         address to,
1873         uint256 startTokenId,
1874         uint256 quantity
1875     ) internal virtual {}
1876 
1877     /**
1878      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1879      * minting.
1880      *
1881      * startTokenId - the first token id to be transferred
1882      * quantity - the amount to be transferred
1883      *
1884      * Calling conditions:
1885      *
1886      * - when `from` and `to` are both non-zero.
1887      * - `from` and `to` are never both zero.
1888      */
1889     function _afterTokenTransfers(
1890         address from,
1891         address to,
1892         uint256 startTokenId,
1893         uint256 quantity
1894     ) internal virtual {}
1895 }
1896 
1897 // FILE 14: CDA.sol
1898 
1899 pragma solidity ^0.8.0;
1900 
1901 contract CryptoDickAss is ERC721A, Ownable, ReentrancyGuard {
1902   using Strings for uint256;
1903   using Counters for Counters.Counter;
1904 
1905   string private uriPrefix = "";
1906   string public uriSuffix = ".json";
1907   string private hiddenMetadataUri;
1908 
1909     constructor() ERC721A("CryptoDickAss", "CDA") {
1910         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1911     }
1912 
1913     uint256 public price = 0.001 ether;
1914     uint256 public maxPerTx = 20;
1915     uint256 public maxPerFree = 2;    
1916     uint256 public maxFreeSupply = 1200;
1917     uint256 public max_Supply = 4200;
1918      
1919   bool public paused = true;
1920   bool public revealed = true;
1921 
1922     mapping(address => uint256) private _mintedFreeAmount;
1923 
1924     function changePrice(uint256 _newPrice) external onlyOwner {
1925         price = _newPrice;
1926     }
1927 
1928     function withdraw() external onlyOwner {
1929         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1930         require(success, "Transfer failed.");
1931     }
1932 
1933     //mint
1934     function mint(uint256 count) external payable {
1935         uint256 cost = price;
1936         require(!paused, "The contract is paused!");
1937         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1938         if (msg.sender != owner()) {
1939             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1940                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1941 
1942             if (isFree) {
1943                 cost = 0;
1944                 _mintedFreeAmount[msg.sender] += count;
1945             }
1946 
1947             require(msg.value >= count * cost, "Please send the exact amount.");
1948             require(count <= maxPerTx, "Max per TX reached.");
1949         }
1950 
1951         require(totalSupply() + count <= max_Supply, "No more");
1952 
1953         _safeMint(msg.sender, count);
1954     }
1955 
1956     function walletOfOwner(address _owner)
1957         public
1958         view
1959         returns (uint256[] memory)
1960     {
1961         uint256 ownerTokenCount = balanceOf(_owner);
1962         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1963         uint256 currentTokenId = 1;
1964         uint256 ownedTokenIndex = 0;
1965 
1966         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= max_Supply) {
1967         address currentTokenOwner = ownerOf(currentTokenId);
1968             if (currentTokenOwner == _owner) {
1969                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1970                 ownedTokenIndex++;
1971             }
1972         currentTokenId++;
1973         }
1974         return ownedTokenIds;
1975     }
1976   
1977   function tokenURI(uint256 _tokenId)
1978     public
1979     view
1980     virtual
1981     override
1982     returns (string memory)
1983   {
1984     require(
1985       _exists(_tokenId),
1986       "ERC721Metadata: URI query for nonexistent token"
1987     );
1988     if (revealed == false) {
1989       return hiddenMetadataUri;
1990     }
1991     string memory currentBaseURI = _baseURI();
1992     return bytes(currentBaseURI).length > 0
1993         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1994         : "";
1995   }
1996 
1997   function setPaused(bool _state) public onlyOwner {
1998     paused = _state;
1999   }
2000 
2001   function setRevealed(bool _state) public onlyOwner {
2002     revealed = _state;
2003   }  
2004 
2005   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
2006     maxPerTx = _maxPerTx;
2007   }
2008 
2009   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
2010     maxPerFree = _maxPerFree;
2011   }  
2012 
2013   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2014     maxFreeSupply = _maxFreeSupply;
2015   }
2016 
2017   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2018     max_Supply = _maxSupply;
2019   }
2020 
2021   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2022     hiddenMetadataUri = _hiddenMetadataUri;
2023   }  
2024 
2025   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2026     uriPrefix = _uriPrefix;
2027   }  
2028 
2029   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2030     uriSuffix = _uriSuffix;
2031   }
2032 
2033   function _baseURI() internal view virtual override returns (string memory) {
2034     return uriPrefix;
2035   }
2036 }