1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-13
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-07-25
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-06-27
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-06-23
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 // File 1: Address.sol
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
26 
27 pragma solidity ^0.8.1;
28 
29 /**
30  * @dev Collection of functions related to the address type
31  */
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      *
50      * [IMPORTANT]
51      * ====
52      * You shouldn't rely on `isContract` to protect against flash loan attacks!
53      *
54      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
55      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
56      * constructor.
57      * ====
58      */
59     function isContract(address account) internal view returns (bool) {
60         // This method relies on extcodesize/address.code.length, which returns 0
61         // for contracts in construction, since the code is only stored at the end
62         // of the constructor execution.
63 
64         return account.code.length > 0;
65     }
66 
67     /**
68      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
69      * `recipient`, forwarding all available gas and reverting on errors.
70      *
71      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
72      * of certain opcodes, possibly making contracts go over the 2300 gas limit
73      * imposed by `transfer`, making them unable to receive funds via
74      * `transfer`. {sendValue} removes this limitation.
75      *
76      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
77      *
78      * IMPORTANT: because control is transferred to `recipient`, care must be
79      * taken to not create reentrancy vulnerabilities. Consider using
80      * {ReentrancyGuard} or the
81      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
82      */
83     function sendValue(address payable recipient, uint256 amount) internal {
84         require(address(this).balance >= amount, "Address: insufficient balance");
85 
86         (bool success, ) = recipient.call{value: amount}("");
87         require(success, "Address: unable to send value, recipient may have reverted");
88     }
89 
90     /**
91      * @dev Performs a Solidity function call using a low level `call`. A
92      * plain `call` is an unsafe replacement for a function call: use this
93      * function instead.
94      *
95      * If `target` reverts with a revert reason, it is bubbled up by this
96      * function (like regular Solidity function calls).
97      *
98      * Returns the raw returned data. To convert to the expected return value,
99      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
100      *
101      * Requirements:
102      *
103      * - `target` must be a contract.
104      * - calling `target` with `data` must not revert.
105      *
106      * _Available since v3.1._
107      */
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109         return functionCall(target, data, "Address: low-level call failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
114      * `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(
119         address target,
120         bytes memory data,
121         string memory errorMessage
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, 0, errorMessage);
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
128      * but also transferring `value` wei to `target`.
129      *
130      * Requirements:
131      *
132      * - the calling contract must have an ETH balance of at least `value`.
133      * - the called Solidity function must be `payable`.
134      *
135      * _Available since v3.1._
136      */
137     function functionCallWithValue(
138         address target,
139         bytes memory data,
140         uint256 value
141     ) internal returns (bytes memory) {
142         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
147      * with `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCallWithValue(
152         address target,
153         bytes memory data,
154         uint256 value,
155         string memory errorMessage
156     ) internal returns (bytes memory) {
157         require(address(this).balance >= value, "Address: insufficient balance for call");
158         require(isContract(target), "Address: call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.call{value: value}(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
171         return functionStaticCall(target, data, "Address: low-level static call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         require(isContract(target), "Address: static call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.staticcall(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but performing a delegate call.
194      *
195      * _Available since v3.4._
196      */
197     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(isContract(target), "Address: delegate call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.delegatecall(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
220      * revert reason using the provided one.
221      *
222      * _Available since v4.3._
223      */
224     function verifyCallResult(
225         bool success,
226         bytes memory returndata,
227         string memory errorMessage
228     ) internal pure returns (bytes memory) {
229         if (success) {
230             return returndata;
231         } else {
232             // Look for revert reason and bubble it up if present
233             if (returndata.length > 0) {
234                 // The easiest way to bubble the revert reason is using memory via assembly
235 
236                 assembly {
237                     let returndata_size := mload(returndata)
238                     revert(add(32, returndata), returndata_size)
239                 }
240             } else {
241                 revert(errorMessage);
242             }
243         }
244     }
245 }
246 
247 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Contract module that helps prevent reentrant calls to a function.
256  *
257  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
258  * available, which can be applied to functions to make sure there are no nested
259  * (reentrant) calls to them.
260  *
261  * Note that because there is a single `nonReentrant` guard, functions marked as
262  * `nonReentrant` may not call one another. This can be worked around by making
263  * those functions `private`, and then adding `external` `nonReentrant` entry
264  * points to them.
265  *
266  * TIP: If you would like to learn more about reentrancy and alternative ways
267  * to protect against it, check out our blog post
268  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
269  */
270 abstract contract ReentrancyGuard {
271     // Booleans are more expensive than uint256 or any type that takes up a full
272     // word because each write operation emits an extra SLOAD to first read the
273     // slot's contents, replace the bits taken up by the boolean, and then write
274     // back. This is the compiler's defense against contract upgrades and
275     // pointer aliasing, and it cannot be disabled.
276 
277     // The values being non-zero value makes deployment a bit more expensive,
278     // but in exchange the refund on every call to nonReentrant will be lower in
279     // amount. Since refunds are capped to a percentage of the total
280     // transaction's gas, it is best to keep them low in cases like this one, to
281     // increase the likelihood of the full refund coming into effect.
282     uint256 private constant _NOT_ENTERED = 1;
283     uint256 private constant _ENTERED = 2;
284 
285     uint256 private _status;
286 
287     constructor() {
288         _status = _NOT_ENTERED;
289     }
290 
291     /**
292      * @dev Prevents a contract from calling itself, directly or indirectly.
293      * Calling a `nonReentrant` function from another `nonReentrant`
294      * function is not supported. It is possible to prevent this from happening
295      * by making the `nonReentrant` function external, and making it call a
296      * `private` function that does the actual work.
297      */
298     modifier nonReentrant() {
299         // On the first call to nonReentrant, _notEntered will be true
300         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
301 
302         // Any calls to nonReentrant after this point will fail
303         _status = _ENTERED;
304 
305         _;
306 
307         // By storing the original value once again, a refund is triggered (see
308         // https://eips.ethereum.org/EIPS/eip-2200)
309         _status = _NOT_ENTERED;
310     }
311 }
312 
313 // FILE 2: Context.sol
314 pragma solidity ^0.8.0;
315 
316 /*
317  * @dev Provides information about the current execution context, including the
318  * sender of the transaction and its data. While these are generally available
319  * via msg.sender and msg.data, they should not be accessed in such a direct
320  * manner, since when dealing with meta-transactions the account sending and
321  * paying for execution may not be the actual sender (as far as an application
322  * is concerned).
323  *
324  * This contract is only required for intermediate, library-like contracts.
325  */
326 abstract contract Context {
327     function _msgSender() internal view virtual returns (address) {
328         return msg.sender;
329     }
330 
331     function _msgData() internal view virtual returns (bytes calldata) {
332         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
333         return msg.data;
334     }
335 }
336 
337 // File 3: Strings.sol
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev String operations.
345  */
346 library Strings {
347     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
348 
349     /**
350      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
351      */
352     function toString(uint256 value) internal pure returns (string memory) {
353         // Inspired by OraclizeAPI's implementation - MIT licence
354         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
355 
356         if (value == 0) {
357             return "0";
358         }
359         uint256 temp = value;
360         uint256 digits;
361         while (temp != 0) {
362             digits++;
363             temp /= 10;
364         }
365         bytes memory buffer = new bytes(digits);
366         while (value != 0) {
367             digits -= 1;
368             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
369             value /= 10;
370         }
371         return string(buffer);
372     }
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
376      */
377     function toHexString(uint256 value) internal pure returns (string memory) {
378         if (value == 0) {
379             return "0x00";
380         }
381         uint256 temp = value;
382         uint256 length = 0;
383         while (temp != 0) {
384             length++;
385             temp >>= 8;
386         }
387         return toHexString(value, length);
388     }
389 
390     /**
391      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
392      */
393     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
394         bytes memory buffer = new bytes(2 * length + 2);
395         buffer[0] = "0";
396         buffer[1] = "x";
397         for (uint256 i = 2 * length + 1; i > 1; --i) {
398             buffer[i] = _HEX_SYMBOLS[value & 0xf];
399             value >>= 4;
400         }
401         require(value == 0, "Strings: hex length insufficient");
402         return string(buffer);
403     }
404 }
405 
406 
407 // File: @openzeppelin/contracts/utils/Counters.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @title Counters
416  * @author Matt Condon (@shrugs)
417  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
418  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
419  *
420  * Include with `using Counters for Counters.Counter;`
421  */
422 library Counters {
423     struct Counter {
424         // This variable should never be directly accessed by users of the library: interactions must be restricted to
425         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
426         // this feature: see https://github.com/ethereum/solidity/issues/4637
427         uint256 _value; // default: 0
428     }
429 
430     function current(Counter storage counter) internal view returns (uint256) {
431         return counter._value;
432     }
433 
434     function increment(Counter storage counter) internal {
435         unchecked {
436             counter._value += 1;
437         }
438     }
439 
440     function decrement(Counter storage counter) internal {
441         uint256 value = counter._value;
442         require(value > 0, "Counter: decrement overflow");
443         unchecked {
444             counter._value = value - 1;
445         }
446     }
447 
448     function reset(Counter storage counter) internal {
449         counter._value = 0;
450     }
451 }
452 
453 // File 4: Ownable.sol
454 
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Contract module which provides a basic access control mechanism, where
461  * there is an account (an owner) that can be granted exclusive access to
462  * specific functions.
463  *
464  * By default, the owner account will be the one that deploys the contract. This
465  * can later be changed with {transferOwnership}.
466  *
467  * This module is used through inheritance. It will make available the modifier
468  * `onlyOwner`, which can be applied to your functions to restrict their use to
469  * the owner.
470  */
471 abstract contract Ownable is Context {
472     address private _owner;
473 
474     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
475 
476     /**
477      * @dev Initializes the contract setting the deployer as the initial owner.
478      */
479     constructor () {
480         address msgSender = _msgSender();
481         _owner = msgSender;
482         emit OwnershipTransferred(address(0), msgSender);
483     }
484 
485     /**
486      * @dev Returns the address of the current owner.
487      */
488     function owner() public view virtual returns (address) {
489         return _owner;
490     }
491 
492     /**
493      * @dev Throws if called by any account other than the owner.
494      */
495     modifier onlyOwner() {
496         require(owner() == _msgSender(), "Ownable: caller is not the owner");
497         _;
498     }
499 
500     /**
501      * @dev Leaves the contract without owner. It will not be possible to call
502      * `onlyOwner` functions anymore. Can only be called by the current owner.
503      *
504      * NOTE: Renouncing ownership will leave the contract without an owner,
505      * thereby removing any functionality that is only available to the owner.
506      */
507     function renounceOwnership() public virtual onlyOwner {
508         emit OwnershipTransferred(_owner, address(0));
509         _owner = address(0);
510     }
511 
512     /**
513      * @dev Transfers ownership of the contract to a new account (`newOwner`).
514      * Can only be called by the current owner.
515      */
516     function transferOwnership(address newOwner) public virtual onlyOwner {
517         require(newOwner != address(0), "Ownable: new owner is the zero address");
518         emit OwnershipTransferred(_owner, newOwner);
519         _owner = newOwner;
520     }
521 }
522 
523 
524 
525 
526 
527 // File 5: IERC165.sol
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Interface of the ERC165 standard, as defined in the
533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
534  *
535  * Implementers can declare support of contract interfaces, which can then be
536  * queried by others ({ERC165Checker}).
537  *
538  * For an implementation, see {ERC165}.
539  */
540 interface IERC165 {
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * `interfaceId`. See the corresponding
544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30 000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 }
551 
552 
553 // File 6: IERC721.sol
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Required interface of an ERC721 compliant contract.
560  */
561 interface IERC721 is IERC165 {
562     /**
563      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
564      */
565     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
569      */
570     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
574      */
575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
576 
577     /**
578      * @dev Returns the number of tokens in ``owner``'s account.
579      */
580     function balanceOf(address owner) external view returns (uint256 balance);
581 
582     /**
583      * @dev Returns the owner of the `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function ownerOf(uint256 tokenId) external view returns (address owner);
590 
591     /**
592      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
593      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must exist and be owned by `from`.
600      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function safeTransferFrom(address from, address to, uint256 tokenId) external;
606 
607     /**
608      * @dev Transfers `tokenId` token from `from` to `to`.
609      *
610      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      *
619      * Emits a {Transfer} event.
620      */
621     function transferFrom(address from, address to, uint256 tokenId) external;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
628      *
629      * Requirements:
630      *
631      * - The caller must own the token or be an approved operator.
632      * - `tokenId` must exist.
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address to, uint256 tokenId) external;
637 
638     /**
639      * @dev Returns the account approved for `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function getApproved(uint256 tokenId) external view returns (address operator);
646 
647     /**
648      * @dev Approve or remove `operator` as an operator for the caller.
649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
661      *
662      * See {setApprovalForAll}
663      */
664     function isApprovedForAll(address owner, address operator) external view returns (bool);
665 
666     /**
667       * @dev Safely transfers `tokenId` token from `from` to `to`.
668       *
669       * Requirements:
670       *
671       * - `from` cannot be the zero address.
672       * - `to` cannot be the zero address.
673       * - `tokenId` token must exist and be owned by `from`.
674       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676       *
677       * Emits a {Transfer} event.
678       */
679     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
680 }
681 
682 
683 
684 // File 7: IERC721Metadata.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Metadata is IERC721 {
697     /**
698      * @dev Returns the token collection name.
699      */
700     function name() external view returns (string memory);
701 
702     /**
703      * @dev Returns the token collection symbol.
704      */
705     function symbol() external view returns (string memory);
706 
707     /**
708      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
709      */
710     function tokenURI(uint256 tokenId) external returns (string memory);
711 }
712 
713 
714 
715 
716 // File 8: ERC165.sol
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Implementation of the {IERC165} interface.
725  *
726  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
727  * for the additional interface id that will be supported. For example:
728  *
729  * ```solidity
730  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
732  * }
733  * ```
734  *
735  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
736  */
737 abstract contract ERC165 is IERC165 {
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742         return interfaceId == type(IERC165).interfaceId;
743     }
744 }
745 
746 
747 // File 9: ERC721.sol
748 
749 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata extension, but not including the Enumerable extension, which is available separately as
757  * {ERC721Enumerable}.
758  */
759 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
760     using Address for address;
761     using Strings for uint256;
762 
763     // Token name
764     string private _name;
765 
766     // Token symbol
767     string private _symbol;
768 
769     // Mapping from token ID to owner address
770     mapping(uint256 => address) private _owners;
771 
772     // Mapping owner address to token count
773     mapping(address => uint256) private _balances;
774 
775     // Mapping from token ID to approved address
776     mapping(uint256 => address) private _tokenApprovals;
777 
778     // Mapping from owner to operator approvals
779     mapping(address => mapping(address => bool)) private _operatorApprovals;
780 
781     /**
782      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
783      */
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787     }
788 
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
793         return
794             interfaceId == type(IERC721).interfaceId ||
795             interfaceId == type(IERC721Metadata).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view virtual override returns (uint256) {
803         require(owner != address(0), "ERC721: balance query for the zero address");
804         return _balances[owner];
805     }
806 
807     /**
808      * @dev See {IERC721-ownerOf}.
809      */
810     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
811         address owner = _owners[tokenId];
812         require(owner != address(0), "ERC721: owner query for nonexistent token");
813         return owner;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-name}.
818      */
819     function name() public view virtual override returns (string memory) {
820         return _name;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-symbol}.
825      */
826     function symbol() public view virtual override returns (string memory) {
827         return _symbol;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-tokenURI}.
832      */
833     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
834         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
835 
836         string memory baseURI = _baseURI();
837         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
838     }
839 
840     /**
841      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
842      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
843      * by default, can be overridden in child contracts.
844      */
845     function _baseURI() internal view virtual returns (string memory) {
846         return "";
847     }
848 
849     /**
850      * @dev See {IERC721-approve}.
851      */
852     function approve(address to, uint256 tokenId) public virtual override {
853         address owner = ERC721.ownerOf(tokenId);
854         require(to != owner, "ERC721: approval to current owner");
855 
856         require(
857             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
858             "ERC721: approve caller is not owner nor approved for all"
859         );
860         if (to.isContract()) {
861             revert ("Token transfer to contract address is not allowed.");
862         } else {
863             _approve(to, tokenId);
864         }
865         // _approve(to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-getApproved}.
870      */
871     function getApproved(uint256 tokenId) public view virtual override returns (address) {
872         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
873 
874         return _tokenApprovals[tokenId];
875     }
876 
877     /**
878      * @dev See {IERC721-setApprovalForAll}.
879      */
880     function setApprovalForAll(address operator, bool approved) public virtual override {
881         _setApprovalForAll(_msgSender(), operator, approved);
882     }
883 
884     /**
885      * @dev See {IERC721-isApprovedForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         //solhint-disable-next-line max-line-length
900         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
901 
902         _transfer(from, to, tokenId);
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         safeTransferFrom(from, to, tokenId, "");
914     }
915 
916     /**
917      * @dev See {IERC721-safeTransferFrom}.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) public virtual override {
925         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
926         _safeTransfer(from, to, tokenId, _data);
927     }
928 
929     /**
930      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
931      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
932      *
933      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
934      *
935      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
936      * implement alternative mechanisms to perform token transfer, such as signature-based.
937      *
938      * Requirements:
939      *
940      * - `from` cannot be the zero address.
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must exist and be owned by `from`.
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _safeTransfer(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) internal virtual {
953         _transfer(from, to, tokenId);
954         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
955     }
956 
957     /**
958      * @dev Returns whether `tokenId` exists.
959      *
960      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
961      *
962      * Tokens start existing when they are minted (`_mint`),
963      * and stop existing when they are burned (`_burn`).
964      */
965     function _exists(uint256 tokenId) internal view virtual returns (bool) {
966         return _owners[tokenId] != address(0);
967     }
968 
969     /**
970      * @dev Returns whether `spender` is allowed to manage `tokenId`.
971      *
972      * Requirements:
973      *
974      * - `tokenId` must exist.
975      */
976     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
977         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
978         address owner = ERC721.ownerOf(tokenId);
979         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
980     }
981 
982     /**
983      * @dev Safely mints `tokenId` and transfers it to `to`.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must not exist.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _safeMint(address to, uint256 tokenId) internal virtual {
993         _safeMint(to, tokenId, "");
994     }
995 
996     /**
997      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
998      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
999      */
1000     function _safeMint(
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) internal virtual {
1005         _mint(to, tokenId);
1006         require(
1007             _checkOnERC721Received(address(0), to, tokenId, _data),
1008             "ERC721: transfer to non ERC721Receiver implementer"
1009         );
1010     }
1011 
1012     /**
1013      * @dev Mints `tokenId` and transfers it to `to`.
1014      *
1015      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must not exist.
1020      * - `to` cannot be the zero address.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _mint(address to, uint256 tokenId) internal virtual {
1025         require(to != address(0), "ERC721: mint to the zero address");
1026         require(!_exists(tokenId), "ERC721: token already minted");
1027 
1028         _beforeTokenTransfer(address(0), to, tokenId);
1029 
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(address(0), to, tokenId);
1034 
1035         _afterTokenTransfer(address(0), to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Destroys `tokenId`.
1040      * The approval is cleared when the token is burned.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _burn(uint256 tokenId) internal virtual {
1049         address owner = ERC721.ownerOf(tokenId);
1050 
1051         _beforeTokenTransfer(owner, address(0), tokenId);
1052 
1053         // Clear approvals
1054         _approve(address(0), tokenId);
1055 
1056         _balances[owner] -= 1;
1057         delete _owners[tokenId];
1058 
1059         emit Transfer(owner, address(0), tokenId);
1060 
1061         _afterTokenTransfer(owner, address(0), tokenId);
1062     }
1063 
1064     /**
1065      * @dev Transfers `tokenId` from `from` to `to`.
1066      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must be owned by `from`.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _transfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) internal virtual {
1080         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1081         require(to != address(0), "ERC721: transfer to the zero address");
1082 
1083         _beforeTokenTransfer(from, to, tokenId);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId);
1087 
1088         _balances[from] -= 1;
1089         _balances[to] += 1;
1090         _owners[tokenId] = to;
1091 
1092         emit Transfer(from, to, tokenId);
1093 
1094         _afterTokenTransfer(from, to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Approve `to` to operate on `tokenId`
1099      *
1100      * Emits a {Approval} event.
1101      */
1102     function _approve(address to, uint256 tokenId) internal virtual {
1103         _tokenApprovals[tokenId] = to;
1104         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Approve `operator` to operate on all of `owner` tokens
1109      *
1110      * Emits a {ApprovalForAll} event.
1111      */
1112     function _setApprovalForAll(
1113         address owner,
1114         address operator,
1115         bool approved
1116     ) internal virtual {
1117         require(owner != operator, "ERC721: approve to caller");
1118         _operatorApprovals[owner][operator] = approved;
1119         emit ApprovalForAll(owner, operator, approved);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver.onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert("ERC721: transfer to non ERC721Receiver implementer");
1144                 } else {
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any token transfer. This includes minting
1157      * and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1162      * transferred to `to`.
1163      * - When `from` is zero, `tokenId` will be minted for `to`.
1164      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1165      * - `from` and `to` are never both zero.
1166      *
1167      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1168      */
1169     function _beforeTokenTransfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) internal virtual {}
1174 
1175     /**
1176      * @dev Hook that is called after any transfer of tokens. This includes
1177      * minting and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - when `from` and `to` are both non-zero.
1182      * - `from` and `to` are never both zero.
1183      *
1184      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1185      */
1186     function _afterTokenTransfer(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) internal virtual {}
1191 }
1192 
1193 
1194 
1195 
1196 
1197 // File 10: IERC721Enumerable.sol
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 
1202 /**
1203  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1204  * @dev See https://eips.ethereum.org/EIPS/eip-721
1205  */
1206 interface IERC721Enumerable is IERC721 {
1207 
1208     /**
1209      * @dev Returns the total amount of tokens stored by the contract.
1210      */
1211     function totalSupply() external view returns (uint256);
1212 
1213     /**
1214      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1215      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1216      */
1217     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1218 
1219     /**
1220      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1221      * Use along with {totalSupply} to enumerate all tokens.
1222      */
1223     function tokenByIndex(uint256 index) external view returns (uint256);
1224 }
1225 
1226 
1227 
1228 
1229 
1230 
1231 // File 11: ERC721Enumerable.sol
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 
1236 /**
1237  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1238  * enumerability of all the token ids in the contract as well as all token ids owned by each
1239  * account.
1240  */
1241 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1242     // Mapping from owner to list of owned token IDs
1243     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1244 
1245     // Mapping from token ID to index of the owner tokens list
1246     mapping(uint256 => uint256) private _ownedTokensIndex;
1247 
1248     // Array with all token ids, used for enumeration
1249     uint256[] private _allTokens;
1250 
1251     // Mapping from token id to position in the allTokens array
1252     mapping(uint256 => uint256) private _allTokensIndex;
1253 
1254     /**
1255      * @dev See {IERC165-supportsInterface}.
1256      */
1257     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1258         return interfaceId == type(IERC721Enumerable).interfaceId
1259             || super.supportsInterface(interfaceId);
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1264      */
1265     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1266         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1267         return _ownedTokens[owner][index];
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Enumerable-totalSupply}.
1272      */
1273     function totalSupply() public view virtual override returns (uint256) {
1274         return _allTokens.length;
1275     }
1276 
1277     /**
1278      * @dev See {IERC721Enumerable-tokenByIndex}.
1279      */
1280     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1281         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1282         return _allTokens[index];
1283     }
1284 
1285     /**
1286      * @dev Hook that is called before any token transfer. This includes minting
1287      * and burning.
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1295      * - `from` cannot be the zero address.
1296      * - `to` cannot be the zero address.
1297      *
1298      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1299      */
1300     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1301         super._beforeTokenTransfer(from, to, tokenId);
1302 
1303         if (from == address(0)) {
1304             _addTokenToAllTokensEnumeration(tokenId);
1305         } else if (from != to) {
1306             _removeTokenFromOwnerEnumeration(from, tokenId);
1307         }
1308         if (to == address(0)) {
1309             _removeTokenFromAllTokensEnumeration(tokenId);
1310         } else if (to != from) {
1311             _addTokenToOwnerEnumeration(to, tokenId);
1312         }
1313     }
1314 
1315     /**
1316      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1317      * @param to address representing the new owner of the given token ID
1318      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1319      */
1320     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1321         uint256 length = ERC721.balanceOf(to);
1322         _ownedTokens[to][length] = tokenId;
1323         _ownedTokensIndex[tokenId] = length;
1324     }
1325 
1326     /**
1327      * @dev Private function to add a token to this extension's token tracking data structures.
1328      * @param tokenId uint256 ID of the token to be added to the tokens list
1329      */
1330     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1331         _allTokensIndex[tokenId] = _allTokens.length;
1332         _allTokens.push(tokenId);
1333     }
1334 
1335     /**
1336      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1337      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1338      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1339      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1340      * @param from address representing the previous owner of the given token ID
1341      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1342      */
1343     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1344         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1345         // then delete the last slot (swap and pop).
1346 
1347         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1348         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1349 
1350         // When the token to delete is the last token, the swap operation is unnecessary
1351         if (tokenIndex != lastTokenIndex) {
1352             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1353 
1354             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1355             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1356         }
1357 
1358         // This also deletes the contents at the last position of the array
1359         delete _ownedTokensIndex[tokenId];
1360         delete _ownedTokens[from][lastTokenIndex];
1361     }
1362 
1363     /**
1364      * @dev Private function to remove a token from this extension's token tracking data structures.
1365      * This has O(1) time complexity, but alters the order of the _allTokens array.
1366      * @param tokenId uint256 ID of the token to be removed from the tokens list
1367      */
1368     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1369         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1370         // then delete the last slot (swap and pop).
1371 
1372         uint256 lastTokenIndex = _allTokens.length - 1;
1373         uint256 tokenIndex = _allTokensIndex[tokenId];
1374 
1375         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1376         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1377         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1378         uint256 lastTokenId = _allTokens[lastTokenIndex];
1379 
1380         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1381         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1382 
1383         // This also deletes the contents at the last position of the array
1384         delete _allTokensIndex[tokenId];
1385         _allTokens.pop();
1386     }
1387 }
1388 
1389 
1390 
1391 // File 12: IERC721Receiver.sol
1392 
1393 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1394 
1395 pragma solidity ^0.8.0;
1396 
1397 /**
1398  * @title ERC721 token receiver interface
1399  * @dev Interface for any contract that wants to support safeTransfers
1400  * from ERC721 asset contracts.
1401  */
1402 interface IERC721Receiver {
1403     /**
1404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1405      * by `operator` from `from`, this function is called.
1406      *
1407      * It must return its Solidity selector to confirm the token transfer.
1408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1409      *
1410      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1411      */
1412     function onERC721Received(
1413         address operator,
1414         address from,
1415         uint256 tokenId,
1416         bytes calldata data
1417     ) external returns (bytes4);
1418 }
1419 
1420 
1421 
1422 // File 13: ERC721A.sol
1423 
1424 pragma solidity ^0.8.0;
1425 
1426 
1427 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1428     using Address for address;
1429     using Strings for uint256;
1430 
1431     struct TokenOwnership {
1432         address addr;
1433         uint64 startTimestamp;
1434     }
1435 
1436     struct AddressData {
1437         uint128 balance;
1438         uint128 numberMinted;
1439     }
1440 
1441     uint256 internal currentIndex;
1442 
1443     // Token name
1444     string private _name;
1445 
1446     // Token symbol
1447     string private _symbol;
1448 
1449     // Mapping from token ID to ownership details
1450     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1451     mapping(uint256 => TokenOwnership) internal _ownerships;
1452 
1453     // Mapping owner address to address data
1454     mapping(address => AddressData) private _addressData;
1455 
1456     // Mapping from token ID to approved address
1457     mapping(uint256 => address) private _tokenApprovals;
1458 
1459     // Mapping from owner to operator approvals
1460     mapping(address => mapping(address => bool)) private _operatorApprovals;
1461 
1462     constructor(string memory name_, string memory symbol_) {
1463         _name = name_;
1464         _symbol = symbol_;
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Enumerable-totalSupply}.
1469      */
1470     function totalSupply() public view override virtual returns (uint256) {
1471         return currentIndex;
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Enumerable-tokenByIndex}.
1476      */
1477     function tokenByIndex(uint256 index) public view override returns (uint256) {
1478         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1479         return index;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1484      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1485      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1486      */
1487     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1488         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1489         uint256 numMintedSoFar = totalSupply();
1490         uint256 tokenIdsIdx;
1491         address currOwnershipAddr;
1492 
1493         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1494         unchecked {
1495             for (uint256 i; i < numMintedSoFar; i++) {
1496                 TokenOwnership memory ownership = _ownerships[i];
1497                 if (ownership.addr != address(0)) {
1498                     currOwnershipAddr = ownership.addr;
1499                 }
1500                 if (currOwnershipAddr == owner) {
1501                     if (tokenIdsIdx == index) {
1502                         return i;
1503                     }
1504                     tokenIdsIdx++;
1505                 }
1506             }
1507         }
1508 
1509         revert('ERC721A: unable to get token of owner by index');
1510     }
1511 
1512     /**
1513      * @dev See {IERC165-supportsInterface}.
1514      */
1515     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1516         return
1517             interfaceId == type(IERC721).interfaceId ||
1518             interfaceId == type(IERC721Metadata).interfaceId ||
1519             interfaceId == type(IERC721Enumerable).interfaceId ||
1520             super.supportsInterface(interfaceId);
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-balanceOf}.
1525      */
1526     function balanceOf(address owner) public view override returns (uint256) {
1527         require(owner != address(0), 'ERC721A: balance query for the zero address');
1528         return uint256(_addressData[owner].balance);
1529     }
1530 
1531     function _numberMinted(address owner) internal view returns (uint256) {
1532         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1533         return uint256(_addressData[owner].numberMinted);
1534     }
1535 
1536     /**
1537      * Gas spent here starts off proportional to the maximum mint batch size.
1538      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1539      */
1540     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1541         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1542 
1543         unchecked {
1544             for (uint256 curr = tokenId; curr >= 0; curr--) {
1545                 TokenOwnership memory ownership = _ownerships[curr];
1546                 if (ownership.addr != address(0)) {
1547                     return ownership;
1548                 }
1549             }
1550         }
1551 
1552         revert('ERC721A: unable to determine the owner of token');
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-ownerOf}.
1557      */
1558     function ownerOf(uint256 tokenId) public view override returns (address) {
1559         return ownershipOf(tokenId).addr;
1560     }
1561 
1562     /**
1563      * @dev See {IERC721Metadata-name}.
1564      */
1565     function name() public view virtual override returns (string memory) {
1566         return _name;
1567     }
1568 
1569     /**
1570      * @dev See {IERC721Metadata-symbol}.
1571      */
1572     function symbol() public view virtual override returns (string memory) {
1573         return _symbol;
1574     }
1575 
1576     /**
1577      * @dev See {IERC721Metadata-tokenURI}.
1578      */
1579     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1580         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1581 
1582         string memory baseURI = _baseURI();
1583         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1584     }
1585 
1586     /**
1587      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1588      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1589      * by default, can be overriden in child contracts.
1590      */
1591     function _baseURI() internal view virtual returns (string memory) {
1592         return '';
1593     }
1594 
1595     /**
1596      * @dev See {IERC721-approve}.
1597      */
1598     function approve(address to, uint256 tokenId) public override {
1599         address owner = ERC721A.ownerOf(tokenId);
1600         require(to != owner, 'ERC721A: approval to current owner');
1601 
1602         require(
1603             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1604             'ERC721A: approve caller is not owner nor approved for all'
1605         );
1606 
1607         _approve(to, tokenId, owner);
1608     }
1609 
1610     /**
1611      * @dev See {IERC721-getApproved}.
1612      */
1613     function getApproved(uint256 tokenId) public view override returns (address) {
1614         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1615 
1616         return _tokenApprovals[tokenId];
1617     }
1618 
1619     /**
1620      * @dev See {IERC721-setApprovalForAll}.
1621      */
1622     function setApprovalForAll(address operator, bool approved) public override {
1623         require(operator != _msgSender(), 'ERC721A: approve to caller');
1624 
1625         _operatorApprovals[_msgSender()][operator] = approved;
1626         emit ApprovalForAll(_msgSender(), operator, approved);
1627     }
1628 
1629     /**
1630      * @dev See {IERC721-isApprovedForAll}.
1631      */
1632     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1633         return _operatorApprovals[owner][operator];
1634     }
1635 
1636     /**
1637      * @dev See {IERC721-transferFrom}.
1638      */
1639     function transferFrom(
1640         address from,
1641         address to,
1642         uint256 tokenId
1643     ) public override {
1644         _transfer(from, to, tokenId);
1645     }
1646 
1647     /**
1648      * @dev See {IERC721-safeTransferFrom}.
1649      */
1650     function safeTransferFrom(
1651         address from,
1652         address to,
1653         uint256 tokenId
1654     ) public override {
1655         safeTransferFrom(from, to, tokenId, '');
1656     }
1657 
1658     /**
1659      * @dev See {IERC721-safeTransferFrom}.
1660      */
1661     function safeTransferFrom(
1662         address from,
1663         address to,
1664         uint256 tokenId,
1665         bytes memory _data
1666     ) public override {
1667         _transfer(from, to, tokenId);
1668         require(
1669             _checkOnERC721Received(from, to, tokenId, _data),
1670             'ERC721A: transfer to non ERC721Receiver implementer'
1671         );
1672     }
1673 
1674     /**
1675      * @dev Returns whether `tokenId` exists.
1676      *
1677      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1678      *
1679      * Tokens start existing when they are minted (`_mint`),
1680      */
1681     function _exists(uint256 tokenId) internal view returns (bool) {
1682         return tokenId < currentIndex;
1683     }
1684 
1685     function _safeMint(address to, uint256 quantity) internal {
1686         _safeMint(to, quantity, '');
1687     }
1688 
1689     /**
1690      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1691      *
1692      * Requirements:
1693      *
1694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1695      * - `quantity` must be greater than 0.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _safeMint(
1700         address to,
1701         uint256 quantity,
1702         bytes memory _data
1703     ) internal {
1704         _mint(to, quantity, _data, true);
1705     }
1706 
1707     /**
1708      * @dev Mints `quantity` tokens and transfers them to `to`.
1709      *
1710      * Requirements:
1711      *
1712      * - `to` cannot be the zero address.
1713      * - `quantity` must be greater than 0.
1714      *
1715      * Emits a {Transfer} event.
1716      */
1717     function _mint(
1718         address to,
1719         uint256 quantity,
1720         bytes memory _data,
1721         bool safe
1722     ) internal {
1723         uint256 startTokenId = currentIndex;
1724         require(to != address(0), 'ERC721A: mint to the zero address');
1725         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1726 
1727         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1728 
1729         // Overflows are incredibly unrealistic.
1730         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1731         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1732         unchecked {
1733             _addressData[to].balance += uint128(quantity);
1734             _addressData[to].numberMinted += uint128(quantity);
1735 
1736             _ownerships[startTokenId].addr = to;
1737             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1738 
1739             uint256 updatedIndex = startTokenId;
1740 
1741             for (uint256 i; i < quantity; i++) {
1742                 emit Transfer(address(0), to, updatedIndex);
1743                 if (safe) {
1744                     require(
1745                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1746                         'ERC721A: transfer to non ERC721Receiver implementer'
1747                     );
1748                 }
1749 
1750                 updatedIndex++;
1751             }
1752 
1753             currentIndex = updatedIndex;
1754         }
1755 
1756         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1757     }
1758 
1759     /**
1760      * @dev Transfers `tokenId` from `from` to `to`.
1761      *
1762      * Requirements:
1763      *
1764      * - `to` cannot be the zero address.
1765      * - `tokenId` token must be owned by `from`.
1766      *
1767      * Emits a {Transfer} event.
1768      */
1769     function _transfer(
1770         address from,
1771         address to,
1772         uint256 tokenId
1773     ) private {
1774         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1775 
1776         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1777             getApproved(tokenId) == _msgSender() ||
1778             isApprovedForAll(prevOwnership.addr, _msgSender()));
1779 
1780         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1781 
1782         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1783         require(to != address(0), 'ERC721A: transfer to the zero address');
1784 
1785         _beforeTokenTransfers(from, to, tokenId, 1);
1786 
1787         // Clear approvals from the previous owner
1788         _approve(address(0), tokenId, prevOwnership.addr);
1789 
1790         // Underflow of the sender's balance is impossible because we check for
1791         // ownership above and the recipient's balance can't realistically overflow.
1792         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1793         unchecked {
1794             _addressData[from].balance -= 1;
1795             _addressData[to].balance += 1;
1796 
1797             _ownerships[tokenId].addr = to;
1798             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1799 
1800             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1801             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1802             uint256 nextTokenId = tokenId + 1;
1803             if (_ownerships[nextTokenId].addr == address(0)) {
1804                 if (_exists(nextTokenId)) {
1805                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1806                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1807                 }
1808             }
1809         }
1810 
1811         emit Transfer(from, to, tokenId);
1812         _afterTokenTransfers(from, to, tokenId, 1);
1813     }
1814 
1815     /**
1816      * @dev Approve `to` to operate on `tokenId`
1817      *
1818      * Emits a {Approval} event.
1819      */
1820     function _approve(
1821         address to,
1822         uint256 tokenId,
1823         address owner
1824     ) private {
1825         _tokenApprovals[tokenId] = to;
1826         emit Approval(owner, to, tokenId);
1827     }
1828 
1829     /**
1830      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1831      * The call is not executed if the target address is not a contract.
1832      *
1833      * @param from address representing the previous owner of the given token ID
1834      * @param to target address that will receive the tokens
1835      * @param tokenId uint256 ID of the token to be transferred
1836      * @param _data bytes optional data to send along with the call
1837      * @return bool whether the call correctly returned the expected magic value
1838      */
1839     function _checkOnERC721Received(
1840         address from,
1841         address to,
1842         uint256 tokenId,
1843         bytes memory _data
1844     ) private returns (bool) {
1845         if (to.isContract()) {
1846             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1847                 return retval == IERC721Receiver(to).onERC721Received.selector;
1848             } catch (bytes memory reason) {
1849                 if (reason.length == 0) {
1850                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1851                 } else {
1852                     assembly {
1853                         revert(add(32, reason), mload(reason))
1854                     }
1855                 }
1856             }
1857         } else {
1858             return true;
1859         }
1860     }
1861 
1862     /**
1863      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1864      *
1865      * startTokenId - the first token id to be transferred
1866      * quantity - the amount to be transferred
1867      *
1868      * Calling conditions:
1869      *
1870      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1871      * transferred to `to`.
1872      * - When `from` is zero, `tokenId` will be minted for `to`.
1873      */
1874     function _beforeTokenTransfers(
1875         address from,
1876         address to,
1877         uint256 startTokenId,
1878         uint256 quantity
1879     ) internal virtual {}
1880 
1881     /**
1882      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1883      * minting.
1884      *
1885      * startTokenId - the first token id to be transferred
1886      * quantity - the amount to be transferred
1887      *
1888      * Calling conditions:
1889      *
1890      * - when `from` and `to` are both non-zero.
1891      * - `from` and `to` are never both zero.
1892      */
1893     function _afterTokenTransfers(
1894         address from,
1895         address to,
1896         uint256 startTokenId,
1897         uint256 quantity
1898     ) internal virtual {}
1899 }
1900 
1901 // FILE 14: GABC.sol
1902 
1903 pragma solidity ^0.8.0;
1904 
1905 contract GangApeBlingClub is ERC721A, Ownable, ReentrancyGuard {
1906   using Strings for uint256;
1907   using Counters for Counters.Counter;
1908 
1909   string private uriPrefix = "";
1910   string public uriSuffix = ".json";
1911   string private hiddenMetadataUri;
1912 
1913     constructor() ERC721A("GangApeBlingClub", "GABC") {
1914         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1915     }
1916 
1917     uint256 public price = 0.0035 ether;
1918     uint256 public maxPerTx = 20;
1919     uint256 public maxPerFree = 2;    
1920     uint256 public maxFreeSupply = 1500;
1921     uint256 public max_Supply = 5555;
1922      
1923   bool public paused = true;
1924   bool public revealed = true;
1925 
1926     mapping(address => uint256) private _mintedFreeAmount;
1927 
1928     function changePrice(uint256 _newPrice) external onlyOwner {
1929         price = _newPrice;
1930     }
1931 
1932     function withdraw() external onlyOwner {
1933         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1934         require(success, "Transfer failed.");
1935     }
1936 
1937     //mint
1938     function mint(uint256 count) external payable {
1939         uint256 cost = price;
1940         require(!paused, "The contract is paused!");
1941         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1942         if (msg.sender != owner()) {
1943             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1944                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1945 
1946             if (isFree) {
1947                 cost = 0;
1948                 _mintedFreeAmount[msg.sender] += count;
1949             }
1950 
1951             require(msg.value >= count * cost, "Please send the exact amount.");
1952             require(count <= maxPerTx, "Max per TX reached.");
1953         }
1954 
1955         require(totalSupply() + count <= max_Supply, "No more");
1956 
1957         _safeMint(msg.sender, count);
1958     }
1959 
1960     function walletOfOwner(address _owner)
1961         public
1962         view
1963         returns (uint256[] memory)
1964     {
1965         uint256 ownerTokenCount = balanceOf(_owner);
1966         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1967         uint256 currentTokenId = 1;
1968         uint256 ownedTokenIndex = 0;
1969 
1970         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= max_Supply) {
1971         address currentTokenOwner = ownerOf(currentTokenId);
1972             if (currentTokenOwner == _owner) {
1973                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1974                 ownedTokenIndex++;
1975             }
1976         currentTokenId++;
1977         }
1978         return ownedTokenIds;
1979     }
1980   
1981   function tokenURI(uint256 _tokenId)
1982     public
1983     view
1984     virtual
1985     override
1986     returns (string memory)
1987   {
1988     require(
1989       _exists(_tokenId),
1990       "ERC721Metadata: URI query for nonexistent token"
1991     );
1992     if (revealed == false) {
1993       return hiddenMetadataUri;
1994     }
1995     string memory currentBaseURI = _baseURI();
1996     return bytes(currentBaseURI).length > 0
1997         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1998         : "";
1999   }
2000 
2001   function setPaused(bool _state) public onlyOwner {
2002     paused = _state;
2003   }
2004 
2005   function setRevealed(bool _state) public onlyOwner {
2006     revealed = _state;
2007   }  
2008 
2009   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
2010     maxPerTx = _maxPerTx;
2011   }
2012 
2013   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
2014     maxPerFree = _maxPerFree;
2015   }  
2016 
2017   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2018     maxFreeSupply = _maxFreeSupply;
2019   }
2020 
2021   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2022     max_Supply = _maxSupply;
2023   }
2024 
2025   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2026     hiddenMetadataUri = _hiddenMetadataUri;
2027   }  
2028 
2029   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2030     uriPrefix = _uriPrefix;
2031   }  
2032 
2033   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2034     uriSuffix = _uriSuffix;
2035   }
2036 
2037   function _baseURI() internal view virtual override returns (string memory) {
2038     return uriPrefix;
2039   }
2040 }