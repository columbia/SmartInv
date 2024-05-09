1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-27
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-06-23
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 // File 1: Address.sol
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
18 
19 pragma solidity ^0.8.1;
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      *
42      * [IMPORTANT]
43      * ====
44      * You shouldn't rely on `isContract` to protect against flash loan attacks!
45      *
46      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
47      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
48      * constructor.
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies on extcodesize/address.code.length, which returns 0
53         // for contracts in construction, since the code is only stored at the end
54         // of the constructor execution.
55 
56         return account.code.length > 0;
57     }
58 
59     /**
60      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
61      * `recipient`, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by `transfer`, making them unable to receive funds via
66      * `transfer`. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to `recipient`, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         (bool success, ) = recipient.call{value: amount}("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level `call`. A
84      * plain `call` is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If `target` reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
92      *
93      * Requirements:
94      *
95      * - `target` must be a contract.
96      * - calling `target` with `data` must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         (bool success, bytes memory returndata) = target.call{value: value}(data);
153         return verifyCallResult(success, returndata, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         require(isContract(target), "Address: static call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(isContract(target), "Address: delegate call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Contract module that helps prevent reentrant calls to a function.
248  *
249  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
250  * available, which can be applied to functions to make sure there are no nested
251  * (reentrant) calls to them.
252  *
253  * Note that because there is a single `nonReentrant` guard, functions marked as
254  * `nonReentrant` may not call one another. This can be worked around by making
255  * those functions `private`, and then adding `external` `nonReentrant` entry
256  * points to them.
257  *
258  * TIP: If you would like to learn more about reentrancy and alternative ways
259  * to protect against it, check out our blog post
260  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
261  */
262 abstract contract ReentrancyGuard {
263     // Booleans are more expensive than uint256 or any type that takes up a full
264     // word because each write operation emits an extra SLOAD to first read the
265     // slot's contents, replace the bits taken up by the boolean, and then write
266     // back. This is the compiler's defense against contract upgrades and
267     // pointer aliasing, and it cannot be disabled.
268 
269     // The values being non-zero value makes deployment a bit more expensive,
270     // but in exchange the refund on every call to nonReentrant will be lower in
271     // amount. Since refunds are capped to a percentage of the total
272     // transaction's gas, it is best to keep them low in cases like this one, to
273     // increase the likelihood of the full refund coming into effect.
274     uint256 private constant _NOT_ENTERED = 1;
275     uint256 private constant _ENTERED = 2;
276 
277     uint256 private _status;
278 
279     constructor() {
280         _status = _NOT_ENTERED;
281     }
282 
283     /**
284      * @dev Prevents a contract from calling itself, directly or indirectly.
285      * Calling a `nonReentrant` function from another `nonReentrant`
286      * function is not supported. It is possible to prevent this from happening
287      * by making the `nonReentrant` function external, and making it call a
288      * `private` function that does the actual work.
289      */
290     modifier nonReentrant() {
291         // On the first call to nonReentrant, _notEntered will be true
292         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
293 
294         // Any calls to nonReentrant after this point will fail
295         _status = _ENTERED;
296 
297         _;
298 
299         // By storing the original value once again, a refund is triggered (see
300         // https://eips.ethereum.org/EIPS/eip-2200)
301         _status = _NOT_ENTERED;
302     }
303 }
304 
305 // FILE 2: Context.sol
306 pragma solidity ^0.8.0;
307 
308 /*
309  * @dev Provides information about the current execution context, including the
310  * sender of the transaction and its data. While these are generally available
311  * via msg.sender and msg.data, they should not be accessed in such a direct
312  * manner, since when dealing with meta-transactions the account sending and
313  * paying for execution may not be the actual sender (as far as an application
314  * is concerned).
315  *
316  * This contract is only required for intermediate, library-like contracts.
317  */
318 abstract contract Context {
319     function _msgSender() internal view virtual returns (address) {
320         return msg.sender;
321     }
322 
323     function _msgData() internal view virtual returns (bytes calldata) {
324         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
325         return msg.data;
326     }
327 }
328 
329 // File 3: Strings.sol
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev String operations.
337  */
338 library Strings {
339     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
343      */
344     function toString(uint256 value) internal pure returns (string memory) {
345         // Inspired by OraclizeAPI's implementation - MIT licence
346         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
347 
348         if (value == 0) {
349             return "0";
350         }
351         uint256 temp = value;
352         uint256 digits;
353         while (temp != 0) {
354             digits++;
355             temp /= 10;
356         }
357         bytes memory buffer = new bytes(digits);
358         while (value != 0) {
359             digits -= 1;
360             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
361             value /= 10;
362         }
363         return string(buffer);
364     }
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
368      */
369     function toHexString(uint256 value) internal pure returns (string memory) {
370         if (value == 0) {
371             return "0x00";
372         }
373         uint256 temp = value;
374         uint256 length = 0;
375         while (temp != 0) {
376             length++;
377             temp >>= 8;
378         }
379         return toHexString(value, length);
380     }
381 
382     /**
383      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
384      */
385     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
386         bytes memory buffer = new bytes(2 * length + 2);
387         buffer[0] = "0";
388         buffer[1] = "x";
389         for (uint256 i = 2 * length + 1; i > 1; --i) {
390             buffer[i] = _HEX_SYMBOLS[value & 0xf];
391             value >>= 4;
392         }
393         require(value == 0, "Strings: hex length insufficient");
394         return string(buffer);
395     }
396 }
397 
398 
399 // File: @openzeppelin/contracts/utils/Counters.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @title Counters
408  * @author Matt Condon (@shrugs)
409  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
410  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
411  *
412  * Include with `using Counters for Counters.Counter;`
413  */
414 library Counters {
415     struct Counter {
416         // This variable should never be directly accessed by users of the library: interactions must be restricted to
417         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
418         // this feature: see https://github.com/ethereum/solidity/issues/4637
419         uint256 _value; // default: 0
420     }
421 
422     function current(Counter storage counter) internal view returns (uint256) {
423         return counter._value;
424     }
425 
426     function increment(Counter storage counter) internal {
427         unchecked {
428             counter._value += 1;
429         }
430     }
431 
432     function decrement(Counter storage counter) internal {
433         uint256 value = counter._value;
434         require(value > 0, "Counter: decrement overflow");
435         unchecked {
436             counter._value = value - 1;
437         }
438     }
439 
440     function reset(Counter storage counter) internal {
441         counter._value = 0;
442     }
443 }
444 
445 // File 4: Ownable.sol
446 
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Contract module which provides a basic access control mechanism, where
453  * there is an account (an owner) that can be granted exclusive access to
454  * specific functions.
455  *
456  * By default, the owner account will be the one that deploys the contract. This
457  * can later be changed with {transferOwnership}.
458  *
459  * This module is used through inheritance. It will make available the modifier
460  * `onlyOwner`, which can be applied to your functions to restrict their use to
461  * the owner.
462  */
463 abstract contract Ownable is Context {
464     address private _owner;
465 
466     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
467 
468     /**
469      * @dev Initializes the contract setting the deployer as the initial owner.
470      */
471     constructor () {
472         address msgSender = _msgSender();
473         _owner = msgSender;
474         emit OwnershipTransferred(address(0), msgSender);
475     }
476 
477     /**
478      * @dev Returns the address of the current owner.
479      */
480     function owner() public view virtual returns (address) {
481         return _owner;
482     }
483 
484     /**
485      * @dev Throws if called by any account other than the owner.
486      */
487     modifier onlyOwner() {
488         require(owner() == _msgSender(), "Ownable: caller is not the owner");
489         _;
490     }
491 
492     /**
493      * @dev Leaves the contract without owner. It will not be possible to call
494      * `onlyOwner` functions anymore. Can only be called by the current owner.
495      *
496      * NOTE: Renouncing ownership will leave the contract without an owner,
497      * thereby removing any functionality that is only available to the owner.
498      */
499     function renounceOwnership() public virtual onlyOwner {
500         emit OwnershipTransferred(_owner, address(0));
501         _owner = address(0);
502     }
503 
504     /**
505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
506      * Can only be called by the current owner.
507      */
508     function transferOwnership(address newOwner) public virtual onlyOwner {
509         require(newOwner != address(0), "Ownable: new owner is the zero address");
510         emit OwnershipTransferred(_owner, newOwner);
511         _owner = newOwner;
512     }
513 }
514 
515 
516 
517 
518 
519 // File 5: IERC165.sol
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Interface of the ERC165 standard, as defined in the
525  * https://eips.ethereum.org/EIPS/eip-165[EIP].
526  *
527  * Implementers can declare support of contract interfaces, which can then be
528  * queried by others ({ERC165Checker}).
529  *
530  * For an implementation, see {ERC165}.
531  */
532 interface IERC165 {
533     /**
534      * @dev Returns true if this contract implements the interface defined by
535      * `interfaceId`. See the corresponding
536      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
537      * to learn more about how these ids are created.
538      *
539      * This function call must use less than 30 000 gas.
540      */
541     function supportsInterface(bytes4 interfaceId) external view returns (bool);
542 }
543 
544 
545 // File 6: IERC721.sol
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Required interface of an ERC721 compliant contract.
552  */
553 interface IERC721 is IERC165 {
554     /**
555      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
561      */
562     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
566      */
567     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
568 
569     /**
570      * @dev Returns the number of tokens in ``owner``'s account.
571      */
572     function balanceOf(address owner) external view returns (uint256 balance);
573 
574     /**
575      * @dev Returns the owner of the `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function ownerOf(uint256 tokenId) external view returns (address owner);
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(address from, address to, uint256 tokenId) external;
598 
599     /**
600      * @dev Transfers `tokenId` token from `from` to `to`.
601      *
602      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      *
611      * Emits a {Transfer} event.
612      */
613     function transferFrom(address from, address to, uint256 tokenId) external;
614 
615     /**
616      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
617      * The approval is cleared when the token is transferred.
618      *
619      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
620      *
621      * Requirements:
622      *
623      * - The caller must own the token or be an approved operator.
624      * - `tokenId` must exist.
625      *
626      * Emits an {Approval} event.
627      */
628     function approve(address to, uint256 tokenId) external;
629 
630     /**
631      * @dev Returns the account approved for `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function getApproved(uint256 tokenId) external view returns (address operator);
638 
639     /**
640      * @dev Approve or remove `operator` as an operator for the caller.
641      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
642      *
643      * Requirements:
644      *
645      * - The `operator` cannot be the caller.
646      *
647      * Emits an {ApprovalForAll} event.
648      */
649     function setApprovalForAll(address operator, bool _approved) external;
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 
658     /**
659       * @dev Safely transfers `tokenId` token from `from` to `to`.
660       *
661       * Requirements:
662       *
663       * - `from` cannot be the zero address.
664       * - `to` cannot be the zero address.
665       * - `tokenId` token must exist and be owned by `from`.
666       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
667       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
668       *
669       * Emits a {Transfer} event.
670       */
671     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
672 }
673 
674 
675 
676 // File 7: IERC721Metadata.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Metadata is IERC721 {
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
701      */
702     function tokenURI(uint256 tokenId) external returns (string memory);
703 }
704 
705 
706 
707 
708 // File 8: ERC165.sol
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @dev Implementation of the {IERC165} interface.
717  *
718  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
719  * for the additional interface id that will be supported. For example:
720  *
721  * ```solidity
722  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
723  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
724  * }
725  * ```
726  *
727  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
728  */
729 abstract contract ERC165 is IERC165 {
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
734         return interfaceId == type(IERC165).interfaceId;
735     }
736 }
737 
738 
739 // File 9: ERC721.sol
740 
741 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
748  * the Metadata extension, but not including the Enumerable extension, which is available separately as
749  * {ERC721Enumerable}.
750  */
751 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
752     using Address for address;
753     using Strings for uint256;
754 
755     // Token name
756     string private _name;
757 
758     // Token symbol
759     string private _symbol;
760 
761     // Mapping from token ID to owner address
762     mapping(uint256 => address) private _owners;
763 
764     // Mapping owner address to token count
765     mapping(address => uint256) private _balances;
766 
767     // Mapping from token ID to approved address
768     mapping(uint256 => address) private _tokenApprovals;
769 
770     // Mapping from owner to operator approvals
771     mapping(address => mapping(address => bool)) private _operatorApprovals;
772 
773     /**
774      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
775      */
776     constructor(string memory name_, string memory symbol_) {
777         _name = name_;
778         _symbol = symbol_;
779     }
780 
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
785         return
786             interfaceId == type(IERC721).interfaceId ||
787             interfaceId == type(IERC721Metadata).interfaceId ||
788             super.supportsInterface(interfaceId);
789     }
790 
791     /**
792      * @dev See {IERC721-balanceOf}.
793      */
794     function balanceOf(address owner) public view virtual override returns (uint256) {
795         require(owner != address(0), "ERC721: balance query for the zero address");
796         return _balances[owner];
797     }
798 
799     /**
800      * @dev See {IERC721-ownerOf}.
801      */
802     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
803         address owner = _owners[tokenId];
804         require(owner != address(0), "ERC721: owner query for nonexistent token");
805         return owner;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
826         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
827 
828         string memory baseURI = _baseURI();
829         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
830     }
831 
832     /**
833      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
834      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
835      * by default, can be overridden in child contracts.
836      */
837     function _baseURI() internal view virtual returns (string memory) {
838         return "";
839     }
840 
841     /**
842      * @dev See {IERC721-approve}.
843      */
844     function approve(address to, uint256 tokenId) public virtual override {
845         address owner = ERC721.ownerOf(tokenId);
846         require(to != owner, "ERC721: approval to current owner");
847 
848         require(
849             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
850             "ERC721: approve caller is not owner nor approved for all"
851         );
852         if (to.isContract()) {
853             revert ("Token transfer to contract address is not allowed.");
854         } else {
855             _approve(to, tokenId);
856         }
857         // _approve(to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-getApproved}.
862      */
863     function getApproved(uint256 tokenId) public view virtual override returns (address) {
864         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
865 
866         return _tokenApprovals[tokenId];
867     }
868 
869     /**
870      * @dev See {IERC721-setApprovalForAll}.
871      */
872     function setApprovalForAll(address operator, bool approved) public virtual override {
873         _setApprovalForAll(_msgSender(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-transferFrom}.
885      */
886     function transferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         //solhint-disable-next-line max-line-length
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
893 
894         _transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, "");
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) public virtual override {
917         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
918         _safeTransfer(from, to, tokenId, _data);
919     }
920 
921     /**
922      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
923      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
924      *
925      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
926      *
927      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
928      * implement alternative mechanisms to perform token transfer, such as signature-based.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must exist and be owned by `from`.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeTransfer(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) internal virtual {
945         _transfer(from, to, tokenId);
946         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      * and stop existing when they are burned (`_burn`).
956      */
957     function _exists(uint256 tokenId) internal view virtual returns (bool) {
958         return _owners[tokenId] != address(0);
959     }
960 
961     /**
962      * @dev Returns whether `spender` is allowed to manage `tokenId`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
969         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
970         address owner = ERC721.ownerOf(tokenId);
971         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
972     }
973 
974     /**
975      * @dev Safely mints `tokenId` and transfers it to `to`.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _safeMint(address to, uint256 tokenId) internal virtual {
985         _safeMint(to, tokenId, "");
986     }
987 
988     /**
989      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
990      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
991      */
992     function _safeMint(
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _mint(to, tokenId);
998         require(
999             _checkOnERC721Received(address(0), to, tokenId, _data),
1000             "ERC721: transfer to non ERC721Receiver implementer"
1001         );
1002     }
1003 
1004     /**
1005      * @dev Mints `tokenId` and transfers it to `to`.
1006      *
1007      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must not exist.
1012      * - `to` cannot be the zero address.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(address to, uint256 tokenId) internal virtual {
1017         require(to != address(0), "ERC721: mint to the zero address");
1018         require(!_exists(tokenId), "ERC721: token already minted");
1019 
1020         _beforeTokenTransfer(address(0), to, tokenId);
1021 
1022         _balances[to] += 1;
1023         _owners[tokenId] = to;
1024 
1025         emit Transfer(address(0), to, tokenId);
1026 
1027         _afterTokenTransfer(address(0), to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev Destroys `tokenId`.
1032      * The approval is cleared when the token is burned.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must exist.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _burn(uint256 tokenId) internal virtual {
1041         address owner = ERC721.ownerOf(tokenId);
1042 
1043         _beforeTokenTransfer(owner, address(0), tokenId);
1044 
1045         // Clear approvals
1046         _approve(address(0), tokenId);
1047 
1048         _balances[owner] -= 1;
1049         delete _owners[tokenId];
1050 
1051         emit Transfer(owner, address(0), tokenId);
1052 
1053         _afterTokenTransfer(owner, address(0), tokenId);
1054     }
1055 
1056     /**
1057      * @dev Transfers `tokenId` from `from` to `to`.
1058      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
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
1071     ) internal virtual {
1072         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1073         require(to != address(0), "ERC721: transfer to the zero address");
1074 
1075         _beforeTokenTransfer(from, to, tokenId);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId);
1079 
1080         _balances[from] -= 1;
1081         _balances[to] += 1;
1082         _owners[tokenId] = to;
1083 
1084         emit Transfer(from, to, tokenId);
1085 
1086         _afterTokenTransfer(from, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Approve `to` to operate on `tokenId`
1091      *
1092      * Emits a {Approval} event.
1093      */
1094     function _approve(address to, uint256 tokenId) internal virtual {
1095         _tokenApprovals[tokenId] = to;
1096         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Approve `operator` to operate on all of `owner` tokens
1101      *
1102      * Emits a {ApprovalForAll} event.
1103      */
1104     function _setApprovalForAll(
1105         address owner,
1106         address operator,
1107         bool approved
1108     ) internal virtual {
1109         require(owner != operator, "ERC721: approve to caller");
1110         _operatorApprovals[owner][operator] = approved;
1111         emit ApprovalForAll(owner, operator, approved);
1112     }
1113 
1114     /**
1115      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1116      * The call is not executed if the target address is not a contract.
1117      *
1118      * @param from address representing the previous owner of the given token ID
1119      * @param to target address that will receive the tokens
1120      * @param tokenId uint256 ID of the token to be transferred
1121      * @param _data bytes optional data to send along with the call
1122      * @return bool whether the call correctly returned the expected magic value
1123      */
1124     function _checkOnERC721Received(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) private returns (bool) {
1130         if (to.isContract()) {
1131             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1132                 return retval == IERC721Receiver.onERC721Received.selector;
1133             } catch (bytes memory reason) {
1134                 if (reason.length == 0) {
1135                     revert("ERC721: transfer to non ERC721Receiver implementer");
1136                 } else {
1137                     assembly {
1138                         revert(add(32, reason), mload(reason))
1139                     }
1140                 }
1141             }
1142         } else {
1143             return true;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any token transfer. This includes minting
1149      * and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 
1167     /**
1168      * @dev Hook that is called after any transfer of tokens. This includes
1169      * minting and burning.
1170      *
1171      * Calling conditions:
1172      *
1173      * - when `from` and `to` are both non-zero.
1174      * - `from` and `to` are never both zero.
1175      *
1176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1177      */
1178     function _afterTokenTransfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) internal virtual {}
1183 }
1184 
1185 
1186 
1187 
1188 
1189 // File 10: IERC721Enumerable.sol
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 
1194 /**
1195  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1196  * @dev See https://eips.ethereum.org/EIPS/eip-721
1197  */
1198 interface IERC721Enumerable is IERC721 {
1199 
1200     /**
1201      * @dev Returns the total amount of tokens stored by the contract.
1202      */
1203     function totalSupply() external view returns (uint256);
1204 
1205     /**
1206      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1207      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1208      */
1209     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1210 
1211     /**
1212      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1213      * Use along with {totalSupply} to enumerate all tokens.
1214      */
1215     function tokenByIndex(uint256 index) external view returns (uint256);
1216 }
1217 
1218 
1219 
1220 
1221 
1222 
1223 // File 11: ERC721Enumerable.sol
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 
1228 /**
1229  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1230  * enumerability of all the token ids in the contract as well as all token ids owned by each
1231  * account.
1232  */
1233 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1234     // Mapping from owner to list of owned token IDs
1235     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1236 
1237     // Mapping from token ID to index of the owner tokens list
1238     mapping(uint256 => uint256) private _ownedTokensIndex;
1239 
1240     // Array with all token ids, used for enumeration
1241     uint256[] private _allTokens;
1242 
1243     // Mapping from token id to position in the allTokens array
1244     mapping(uint256 => uint256) private _allTokensIndex;
1245 
1246     /**
1247      * @dev See {IERC165-supportsInterface}.
1248      */
1249     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1250         return interfaceId == type(IERC721Enumerable).interfaceId
1251             || super.supportsInterface(interfaceId);
1252     }
1253 
1254     /**
1255      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1256      */
1257     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1258         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1259         return _ownedTokens[owner][index];
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Enumerable-totalSupply}.
1264      */
1265     function totalSupply() public view virtual override returns (uint256) {
1266         return _allTokens.length;
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Enumerable-tokenByIndex}.
1271      */
1272     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1273         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1274         return _allTokens[index];
1275     }
1276 
1277     /**
1278      * @dev Hook that is called before any token transfer. This includes minting
1279      * and burning.
1280      *
1281      * Calling conditions:
1282      *
1283      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1284      * transferred to `to`.
1285      * - When `from` is zero, `tokenId` will be minted for `to`.
1286      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1287      * - `from` cannot be the zero address.
1288      * - `to` cannot be the zero address.
1289      *
1290      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1291      */
1292     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1293         super._beforeTokenTransfer(from, to, tokenId);
1294 
1295         if (from == address(0)) {
1296             _addTokenToAllTokensEnumeration(tokenId);
1297         } else if (from != to) {
1298             _removeTokenFromOwnerEnumeration(from, tokenId);
1299         }
1300         if (to == address(0)) {
1301             _removeTokenFromAllTokensEnumeration(tokenId);
1302         } else if (to != from) {
1303             _addTokenToOwnerEnumeration(to, tokenId);
1304         }
1305     }
1306 
1307     /**
1308      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1309      * @param to address representing the new owner of the given token ID
1310      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1311      */
1312     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1313         uint256 length = ERC721.balanceOf(to);
1314         _ownedTokens[to][length] = tokenId;
1315         _ownedTokensIndex[tokenId] = length;
1316     }
1317 
1318     /**
1319      * @dev Private function to add a token to this extension's token tracking data structures.
1320      * @param tokenId uint256 ID of the token to be added to the tokens list
1321      */
1322     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1323         _allTokensIndex[tokenId] = _allTokens.length;
1324         _allTokens.push(tokenId);
1325     }
1326 
1327     /**
1328      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1329      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1330      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1331      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1332      * @param from address representing the previous owner of the given token ID
1333      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1334      */
1335     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1336         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1337         // then delete the last slot (swap and pop).
1338 
1339         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1340         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1341 
1342         // When the token to delete is the last token, the swap operation is unnecessary
1343         if (tokenIndex != lastTokenIndex) {
1344             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1345 
1346             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1347             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1348         }
1349 
1350         // This also deletes the contents at the last position of the array
1351         delete _ownedTokensIndex[tokenId];
1352         delete _ownedTokens[from][lastTokenIndex];
1353     }
1354 
1355     /**
1356      * @dev Private function to remove a token from this extension's token tracking data structures.
1357      * This has O(1) time complexity, but alters the order of the _allTokens array.
1358      * @param tokenId uint256 ID of the token to be removed from the tokens list
1359      */
1360     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1361         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1362         // then delete the last slot (swap and pop).
1363 
1364         uint256 lastTokenIndex = _allTokens.length - 1;
1365         uint256 tokenIndex = _allTokensIndex[tokenId];
1366 
1367         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1368         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1369         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1370         uint256 lastTokenId = _allTokens[lastTokenIndex];
1371 
1372         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374 
1375         // This also deletes the contents at the last position of the array
1376         delete _allTokensIndex[tokenId];
1377         _allTokens.pop();
1378     }
1379 }
1380 
1381 
1382 
1383 // File 12: IERC721Receiver.sol
1384 
1385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 /**
1390  * @title ERC721 token receiver interface
1391  * @dev Interface for any contract that wants to support safeTransfers
1392  * from ERC721 asset contracts.
1393  */
1394 interface IERC721Receiver {
1395     /**
1396      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1397      * by `operator` from `from`, this function is called.
1398      *
1399      * It must return its Solidity selector to confirm the token transfer.
1400      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1401      *
1402      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1403      */
1404     function onERC721Received(
1405         address operator,
1406         address from,
1407         uint256 tokenId,
1408         bytes calldata data
1409     ) external returns (bytes4);
1410 }
1411 
1412 
1413 
1414 // File 13: ERC721A.sol
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 
1419 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1420     using Address for address;
1421     using Strings for uint256;
1422 
1423     struct TokenOwnership {
1424         address addr;
1425         uint64 startTimestamp;
1426     }
1427 
1428     struct AddressData {
1429         uint128 balance;
1430         uint128 numberMinted;
1431     }
1432 
1433     uint256 internal currentIndex;
1434 
1435     // Token name
1436     string private _name;
1437 
1438     // Token symbol
1439     string private _symbol;
1440 
1441     // Mapping from token ID to ownership details
1442     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1443     mapping(uint256 => TokenOwnership) internal _ownerships;
1444 
1445     // Mapping owner address to address data
1446     mapping(address => AddressData) private _addressData;
1447 
1448     // Mapping from token ID to approved address
1449     mapping(uint256 => address) private _tokenApprovals;
1450 
1451     // Mapping from owner to operator approvals
1452     mapping(address => mapping(address => bool)) private _operatorApprovals;
1453 
1454     constructor(string memory name_, string memory symbol_) {
1455         _name = name_;
1456         _symbol = symbol_;
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Enumerable-totalSupply}.
1461      */
1462     function totalSupply() public view override virtual returns (uint256) {
1463         return currentIndex;
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Enumerable-tokenByIndex}.
1468      */
1469     function tokenByIndex(uint256 index) public view override returns (uint256) {
1470         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1471         return index;
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1476      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1477      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1478      */
1479     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1480         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1481         uint256 numMintedSoFar = totalSupply();
1482         uint256 tokenIdsIdx;
1483         address currOwnershipAddr;
1484 
1485         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1486         unchecked {
1487             for (uint256 i; i < numMintedSoFar; i++) {
1488                 TokenOwnership memory ownership = _ownerships[i];
1489                 if (ownership.addr != address(0)) {
1490                     currOwnershipAddr = ownership.addr;
1491                 }
1492                 if (currOwnershipAddr == owner) {
1493                     if (tokenIdsIdx == index) {
1494                         return i;
1495                     }
1496                     tokenIdsIdx++;
1497                 }
1498             }
1499         }
1500 
1501         revert('ERC721A: unable to get token of owner by index');
1502     }
1503 
1504     /**
1505      * @dev See {IERC165-supportsInterface}.
1506      */
1507     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1508         return
1509             interfaceId == type(IERC721).interfaceId ||
1510             interfaceId == type(IERC721Metadata).interfaceId ||
1511             interfaceId == type(IERC721Enumerable).interfaceId ||
1512             super.supportsInterface(interfaceId);
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-balanceOf}.
1517      */
1518     function balanceOf(address owner) public view override returns (uint256) {
1519         require(owner != address(0), 'ERC721A: balance query for the zero address');
1520         return uint256(_addressData[owner].balance);
1521     }
1522 
1523     function _numberMinted(address owner) internal view returns (uint256) {
1524         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1525         return uint256(_addressData[owner].numberMinted);
1526     }
1527 
1528     /**
1529      * Gas spent here starts off proportional to the maximum mint batch size.
1530      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1531      */
1532     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1533         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1534 
1535         unchecked {
1536             for (uint256 curr = tokenId; curr >= 0; curr--) {
1537                 TokenOwnership memory ownership = _ownerships[curr];
1538                 if (ownership.addr != address(0)) {
1539                     return ownership;
1540                 }
1541             }
1542         }
1543 
1544         revert('ERC721A: unable to determine the owner of token');
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-ownerOf}.
1549      */
1550     function ownerOf(uint256 tokenId) public view override returns (address) {
1551         return ownershipOf(tokenId).addr;
1552     }
1553 
1554     /**
1555      * @dev See {IERC721Metadata-name}.
1556      */
1557     function name() public view virtual override returns (string memory) {
1558         return _name;
1559     }
1560 
1561     /**
1562      * @dev See {IERC721Metadata-symbol}.
1563      */
1564     function symbol() public view virtual override returns (string memory) {
1565         return _symbol;
1566     }
1567 
1568     /**
1569      * @dev See {IERC721Metadata-tokenURI}.
1570      */
1571     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1572         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1573 
1574         string memory baseURI = _baseURI();
1575         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1576     }
1577 
1578     /**
1579      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1580      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1581      * by default, can be overriden in child contracts.
1582      */
1583     function _baseURI() internal view virtual returns (string memory) {
1584         return '';
1585     }
1586 
1587     /**
1588      * @dev See {IERC721-approve}.
1589      */
1590     function approve(address to, uint256 tokenId) public override {
1591         address owner = ERC721A.ownerOf(tokenId);
1592         require(to != owner, 'ERC721A: approval to current owner');
1593 
1594         require(
1595             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1596             'ERC721A: approve caller is not owner nor approved for all'
1597         );
1598 
1599         _approve(to, tokenId, owner);
1600     }
1601 
1602     /**
1603      * @dev See {IERC721-getApproved}.
1604      */
1605     function getApproved(uint256 tokenId) public view override returns (address) {
1606         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1607 
1608         return _tokenApprovals[tokenId];
1609     }
1610 
1611     /**
1612      * @dev See {IERC721-setApprovalForAll}.
1613      */
1614     function setApprovalForAll(address operator, bool approved) public override {
1615         require(operator != _msgSender(), 'ERC721A: approve to caller');
1616 
1617         _operatorApprovals[_msgSender()][operator] = approved;
1618         emit ApprovalForAll(_msgSender(), operator, approved);
1619     }
1620 
1621     /**
1622      * @dev See {IERC721-isApprovedForAll}.
1623      */
1624     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1625         return _operatorApprovals[owner][operator];
1626     }
1627 
1628     /**
1629      * @dev See {IERC721-transferFrom}.
1630      */
1631     function transferFrom(
1632         address from,
1633         address to,
1634         uint256 tokenId
1635     ) public override {
1636         _transfer(from, to, tokenId);
1637     }
1638 
1639     /**
1640      * @dev See {IERC721-safeTransferFrom}.
1641      */
1642     function safeTransferFrom(
1643         address from,
1644         address to,
1645         uint256 tokenId
1646     ) public override {
1647         safeTransferFrom(from, to, tokenId, '');
1648     }
1649 
1650     /**
1651      * @dev See {IERC721-safeTransferFrom}.
1652      */
1653     function safeTransferFrom(
1654         address from,
1655         address to,
1656         uint256 tokenId,
1657         bytes memory _data
1658     ) public override {
1659         _transfer(from, to, tokenId);
1660         require(
1661             _checkOnERC721Received(from, to, tokenId, _data),
1662             'ERC721A: transfer to non ERC721Receiver implementer'
1663         );
1664     }
1665 
1666     /**
1667      * @dev Returns whether `tokenId` exists.
1668      *
1669      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1670      *
1671      * Tokens start existing when they are minted (`_mint`),
1672      */
1673     function _exists(uint256 tokenId) internal view returns (bool) {
1674         return tokenId < currentIndex;
1675     }
1676 
1677     function _safeMint(address to, uint256 quantity) internal {
1678         _safeMint(to, quantity, '');
1679     }
1680 
1681     /**
1682      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1683      *
1684      * Requirements:
1685      *
1686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1687      * - `quantity` must be greater than 0.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _safeMint(
1692         address to,
1693         uint256 quantity,
1694         bytes memory _data
1695     ) internal {
1696         _mint(to, quantity, _data, true);
1697     }
1698 
1699     /**
1700      * @dev Mints `quantity` tokens and transfers them to `to`.
1701      *
1702      * Requirements:
1703      *
1704      * - `to` cannot be the zero address.
1705      * - `quantity` must be greater than 0.
1706      *
1707      * Emits a {Transfer} event.
1708      */
1709     function _mint(
1710         address to,
1711         uint256 quantity,
1712         bytes memory _data,
1713         bool safe
1714     ) internal {
1715         uint256 startTokenId = currentIndex;
1716         require(to != address(0), 'ERC721A: mint to the zero address');
1717         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1718 
1719         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1720 
1721         // Overflows are incredibly unrealistic.
1722         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1723         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1724         unchecked {
1725             _addressData[to].balance += uint128(quantity);
1726             _addressData[to].numberMinted += uint128(quantity);
1727 
1728             _ownerships[startTokenId].addr = to;
1729             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1730 
1731             uint256 updatedIndex = startTokenId;
1732 
1733             for (uint256 i; i < quantity; i++) {
1734                 emit Transfer(address(0), to, updatedIndex);
1735                 if (safe) {
1736                     require(
1737                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1738                         'ERC721A: transfer to non ERC721Receiver implementer'
1739                     );
1740                 }
1741 
1742                 updatedIndex++;
1743             }
1744 
1745             currentIndex = updatedIndex;
1746         }
1747 
1748         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1749     }
1750 
1751     /**
1752      * @dev Transfers `tokenId` from `from` to `to`.
1753      *
1754      * Requirements:
1755      *
1756      * - `to` cannot be the zero address.
1757      * - `tokenId` token must be owned by `from`.
1758      *
1759      * Emits a {Transfer} event.
1760      */
1761     function _transfer(
1762         address from,
1763         address to,
1764         uint256 tokenId
1765     ) private {
1766         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1767 
1768         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1769             getApproved(tokenId) == _msgSender() ||
1770             isApprovedForAll(prevOwnership.addr, _msgSender()));
1771 
1772         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1773 
1774         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1775         require(to != address(0), 'ERC721A: transfer to the zero address');
1776 
1777         _beforeTokenTransfers(from, to, tokenId, 1);
1778 
1779         // Clear approvals from the previous owner
1780         _approve(address(0), tokenId, prevOwnership.addr);
1781 
1782         // Underflow of the sender's balance is impossible because we check for
1783         // ownership above and the recipient's balance can't realistically overflow.
1784         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1785         unchecked {
1786             _addressData[from].balance -= 1;
1787             _addressData[to].balance += 1;
1788 
1789             _ownerships[tokenId].addr = to;
1790             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1791 
1792             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1793             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1794             uint256 nextTokenId = tokenId + 1;
1795             if (_ownerships[nextTokenId].addr == address(0)) {
1796                 if (_exists(nextTokenId)) {
1797                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1798                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1799                 }
1800             }
1801         }
1802 
1803         emit Transfer(from, to, tokenId);
1804         _afterTokenTransfers(from, to, tokenId, 1);
1805     }
1806 
1807     /**
1808      * @dev Approve `to` to operate on `tokenId`
1809      *
1810      * Emits a {Approval} event.
1811      */
1812     function _approve(
1813         address to,
1814         uint256 tokenId,
1815         address owner
1816     ) private {
1817         _tokenApprovals[tokenId] = to;
1818         emit Approval(owner, to, tokenId);
1819     }
1820 
1821     /**
1822      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1823      * The call is not executed if the target address is not a contract.
1824      *
1825      * @param from address representing the previous owner of the given token ID
1826      * @param to target address that will receive the tokens
1827      * @param tokenId uint256 ID of the token to be transferred
1828      * @param _data bytes optional data to send along with the call
1829      * @return bool whether the call correctly returned the expected magic value
1830      */
1831     function _checkOnERC721Received(
1832         address from,
1833         address to,
1834         uint256 tokenId,
1835         bytes memory _data
1836     ) private returns (bool) {
1837         if (to.isContract()) {
1838             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1839                 return retval == IERC721Receiver(to).onERC721Received.selector;
1840             } catch (bytes memory reason) {
1841                 if (reason.length == 0) {
1842                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1843                 } else {
1844                     assembly {
1845                         revert(add(32, reason), mload(reason))
1846                     }
1847                 }
1848             }
1849         } else {
1850             return true;
1851         }
1852     }
1853 
1854     /**
1855      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1856      *
1857      * startTokenId - the first token id to be transferred
1858      * quantity - the amount to be transferred
1859      *
1860      * Calling conditions:
1861      *
1862      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1863      * transferred to `to`.
1864      * - When `from` is zero, `tokenId` will be minted for `to`.
1865      */
1866     function _beforeTokenTransfers(
1867         address from,
1868         address to,
1869         uint256 startTokenId,
1870         uint256 quantity
1871     ) internal virtual {}
1872 
1873     /**
1874      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1875      * minting.
1876      *
1877      * startTokenId - the first token id to be transferred
1878      * quantity - the amount to be transferred
1879      *
1880      * Calling conditions:
1881      *
1882      * - when `from` and `to` are both non-zero.
1883      * - `from` and `to` are never both zero.
1884      */
1885     function _afterTokenTransfers(
1886         address from,
1887         address to,
1888         uint256 startTokenId,
1889         uint256 quantity
1890     ) internal virtual {}
1891 }
1892 
1893 // FILE 14: apes.sol
1894 
1895 pragma solidity ^0.8.0;
1896 
1897 contract apes8 is ERC721A, Ownable, ReentrancyGuard {
1898   using Strings for uint256;
1899   using Counters for Counters.Counter;
1900 
1901   string private uriPrefix = "";
1902   string public uriSuffix = ".json";
1903   string private hiddenMetadataUri;
1904 
1905     constructor() ERC721A("apes8", "ape8") {
1906         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1907     }
1908 
1909     uint256 public price = 0.002 ether;
1910     uint256 public maxPerTx = 20;
1911     uint256 public maxPerFree = 2;    
1912     uint256 public maxFreeSupply = 1111;
1913     uint256 public max_Supply = 5555;
1914      
1915   bool public paused = true;
1916   bool public revealed = true;
1917 
1918     mapping(address => uint256) private _mintedFreeAmount;
1919 
1920     function changePrice(uint256 _newPrice) external onlyOwner {
1921         price = _newPrice;
1922     }
1923 
1924     function withdraw() external onlyOwner {
1925         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1926         require(success, "Transfer failed.");
1927     }
1928 
1929     //mint
1930     function mint(uint256 count) external payable {
1931         uint256 cost = price;
1932         require(!paused, "The contract is paused!");
1933         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1934         if (msg.sender != owner()) {
1935             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1936                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1937 
1938             if (isFree) {
1939                 cost = 0;
1940                 _mintedFreeAmount[msg.sender] += count;
1941             }
1942 
1943             require(msg.value >= count * cost, "Please send the exact amount.");
1944             require(count <= maxPerTx, "Max per TX reached.");
1945         }
1946 
1947         require(totalSupply() + count <= max_Supply, "No more");
1948 
1949         _safeMint(msg.sender, count);
1950     }
1951 
1952     function walletOfOwner(address _owner)
1953         public
1954         view
1955         returns (uint256[] memory)
1956     {
1957         uint256 ownerTokenCount = balanceOf(_owner);
1958         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1959         uint256 currentTokenId = 1;
1960         uint256 ownedTokenIndex = 0;
1961 
1962         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= max_Supply) {
1963         address currentTokenOwner = ownerOf(currentTokenId);
1964             if (currentTokenOwner == _owner) {
1965                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1966                 ownedTokenIndex++;
1967             }
1968         currentTokenId++;
1969         }
1970         return ownedTokenIds;
1971     }
1972   
1973   function tokenURI(uint256 _tokenId)
1974     public
1975     view
1976     virtual
1977     override
1978     returns (string memory)
1979   {
1980     require(
1981       _exists(_tokenId),
1982       "ERC721Metadata: URI query for nonexistent token"
1983     );
1984     if (revealed == false) {
1985       return hiddenMetadataUri;
1986     }
1987     string memory currentBaseURI = _baseURI();
1988     return bytes(currentBaseURI).length > 0
1989         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1990         : "";
1991   }
1992 
1993   function setPaused(bool _state) public onlyOwner {
1994     paused = _state;
1995   }
1996 
1997   function setRevealed(bool _state) public onlyOwner {
1998     revealed = _state;
1999   }  
2000 
2001   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
2002     maxPerTx = _maxPerTx;
2003   }
2004 
2005   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
2006     maxPerFree = _maxPerFree;
2007   }  
2008 
2009   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2010     maxFreeSupply = _maxFreeSupply;
2011   }
2012 
2013   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2014     max_Supply = _maxSupply;
2015   }
2016 
2017   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2018     hiddenMetadataUri = _hiddenMetadataUri;
2019   }  
2020 
2021   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2022     uriPrefix = _uriPrefix;
2023   }  
2024 
2025   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2026     uriSuffix = _uriSuffix;
2027   }
2028 
2029   function _baseURI() internal view virtual override returns (string memory) {
2030     return uriPrefix;
2031   }
2032 }