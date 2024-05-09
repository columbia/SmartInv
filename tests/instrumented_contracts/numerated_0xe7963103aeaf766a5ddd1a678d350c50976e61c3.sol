1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-08
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-09-05
11 */
12 
13 
14 // SPDX-License-Identifier: MIT
15 
16 // File 1: Address.sol
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
19 
20 pragma solidity ^0.8.1;
21 
22 /**
23  * @dev Collection of functions related to the address type
24  */
25 library Address {
26     /**
27      * @dev Returns true if `account` is a contract.
28      *
29      * [IMPORTANT]
30      * ====
31      * It is unsafe to assume that an address for which this function returns
32      * false is an externally-owned account (EOA) and not a contract.
33      *
34      * Among others, `isContract` will return false for the following
35      * types of addresses:
36      *
37      *  - an externally-owned account
38      *  - a contract in construction
39      *  - an address where a contract will be created
40      *  - an address where a contract lived, but was destroyed
41      * ====
42      *
43      * [IMPORTANT]
44      * ====
45      * You shouldn't rely on `isContract` to protect against flash loan attacks!
46      *
47      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
48      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
49      * constructor.
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize/address.code.length, which returns 0
54         // for contracts in construction, since the code is only stored at the end
55         // of the constructor execution.
56 
57         return account.code.length > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
62      * `recipient`, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by `transfer`, making them unable to receive funds via
67      * `transfer`. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to `recipient`, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level `call`. A
85      * plain `call` is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If `target` reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
93      *
94      * Requirements:
95      *
96      * - `target` must be a contract.
97      * - calling `target` with `data` must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
107      * `errorMessage` as a fallback revert reason when `target` reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
121      * but also transferring `value` wei to `target`.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least `value`.
126      * - the called Solidity function must be `payable`.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Contract module that helps prevent reentrant calls to a function.
249  *
250  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
251  * available, which can be applied to functions to make sure there are no nested
252  * (reentrant) calls to them.
253  *
254  * Note that because there is a single `nonReentrant` guard, functions marked as
255  * `nonReentrant` may not call one another. This can be worked around by making
256  * those functions `private`, and then adding `external` `nonReentrant` entry
257  * points to them.
258  *
259  * TIP: If you would like to learn more about reentrancy and alternative ways
260  * to protect against it, check out our blog post
261  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
262  */
263 abstract contract ReentrancyGuard {
264     // Booleans are more expensive than uint256 or any type that takes up a full
265     // word because each write operation emits an extra SLOAD to first read the
266     // slot's contents, replace the bits taken up by the boolean, and then write
267     // back. This is the compiler's defense against contract upgrades and
268     // pointer aliasing, and it cannot be disabled.
269 
270     // The values being non-zero value makes deployment a bit more expensive,
271     // but in exchange the refund on every call to nonReentrant will be lower in
272     // amount. Since refunds are capped to a percentage of the total
273     // transaction's gas, it is best to keep them low in cases like this one, to
274     // increase the likelihood of the full refund coming into effect.
275     uint256 private constant _NOT_ENTERED = 1;
276     uint256 private constant _ENTERED = 2;
277 
278     uint256 private _status;
279 
280     constructor() {
281         _status = _NOT_ENTERED;
282     }
283 
284     /**
285      * @dev Prevents a contract from calling itself, directly or indirectly.
286      * Calling a `nonReentrant` function from another `nonReentrant`
287      * function is not supported. It is possible to prevent this from happening
288      * by making the `nonReentrant` function external, and making it call a
289      * `private` function that does the actual work.
290      */
291     modifier nonReentrant() {
292         // On the first call to nonReentrant, _notEntered will be true
293         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
294 
295         // Any calls to nonReentrant after this point will fail
296         _status = _ENTERED;
297 
298         _;
299 
300         // By storing the original value once again, a refund is triggered (see
301         // https://eips.ethereum.org/EIPS/eip-2200)
302         _status = _NOT_ENTERED;
303     }
304 }
305 
306 // FILE 2: Context.sol
307 pragma solidity ^0.8.0;
308 
309 /*
310  * @dev Provides information about the current execution context, including the
311  * sender of the transaction and its data. While these are generally available
312  * via msg.sender and msg.data, they should not be accessed in such a direct
313  * manner, since when dealing with meta-transactions the account sending and
314  * paying for execution may not be the actual sender (as far as an application
315  * is concerned).
316  *
317  * This contract is only required for intermediate, library-like contracts.
318  */
319 abstract contract Context {
320     function _msgSender() internal view virtual returns (address) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes calldata) {
325         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
326         return msg.data;
327     }
328 }
329 
330 // File 3: Strings.sol
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev String operations.
338  */
339 library Strings {
340     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
341 
342     /**
343      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
344      */
345     function toString(uint256 value) internal pure returns (string memory) {
346         // Inspired by OraclizeAPI's implementation - MIT licence
347         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
348 
349         if (value == 0) {
350             return "0";
351         }
352         uint256 temp = value;
353         uint256 digits;
354         while (temp != 0) {
355             digits++;
356             temp /= 10;
357         }
358         bytes memory buffer = new bytes(digits);
359         while (value != 0) {
360             digits -= 1;
361             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
362             value /= 10;
363         }
364         return string(buffer);
365     }
366 
367     /**
368      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
369      */
370     function toHexString(uint256 value) internal pure returns (string memory) {
371         if (value == 0) {
372             return "0x00";
373         }
374         uint256 temp = value;
375         uint256 length = 0;
376         while (temp != 0) {
377             length++;
378             temp >>= 8;
379         }
380         return toHexString(value, length);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
385      */
386     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
387         bytes memory buffer = new bytes(2 * length + 2);
388         buffer[0] = "0";
389         buffer[1] = "x";
390         for (uint256 i = 2 * length + 1; i > 1; --i) {
391             buffer[i] = _HEX_SYMBOLS[value & 0xf];
392             value >>= 4;
393         }
394         require(value == 0, "Strings: hex length insufficient");
395         return string(buffer);
396     }
397 }
398 
399 
400 // File: @openzeppelin/contracts/utils/Counters.sol
401 
402 
403 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @title Counters
409  * @author Matt Condon (@shrugs)
410  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
411  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
412  *
413  * Include with `using Counters for Counters.Counter;`
414  */
415 library Counters {
416     struct Counter {
417         // This variable should never be directly accessed by users of the library: interactions must be restricted to
418         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
419         // this feature: see https://github.com/ethereum/solidity/issues/4637
420         uint256 _value; // default: 0
421     }
422 
423     function current(Counter storage counter) internal view returns (uint256) {
424         return counter._value;
425     }
426 
427     function increment(Counter storage counter) internal {
428         unchecked {
429             counter._value += 1;
430         }
431     }
432 
433     function decrement(Counter storage counter) internal {
434         uint256 value = counter._value;
435         require(value > 0, "Counter: decrement overflow");
436         unchecked {
437             counter._value = value - 1;
438         }
439     }
440 
441     function reset(Counter storage counter) internal {
442         counter._value = 0;
443     }
444 }
445 
446 // File 4: Ownable.sol
447 
448 
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev Contract module which provides a basic access control mechanism, where
454  * there is an account (an owner) that can be granted exclusive access to
455  * specific functions.
456  *
457  * By default, the owner account will be the one that deploys the contract. This
458  * can later be changed with {transferOwnership}.
459  *
460  * This module is used through inheritance. It will make available the modifier
461  * `onlyOwner`, which can be applied to your functions to restrict their use to
462  * the owner.
463  */
464 abstract contract Ownable is Context {
465     address private _owner;
466 
467     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
468 
469     /**
470      * @dev Initializes the contract setting the deployer as the initial owner.
471      */
472     constructor () {
473         address msgSender = _msgSender();
474         _owner = msgSender;
475         emit OwnershipTransferred(address(0), msgSender);
476     }
477 
478     /**
479      * @dev Returns the address of the current owner.
480      */
481     function owner() public view virtual returns (address) {
482         return _owner;
483     }
484 
485     /**
486      * @dev Throws if called by any account other than the owner.
487      */
488     modifier onlyOwner() {
489         require(owner() == _msgSender(), "Ownable: caller is not the owner");
490         _;
491     }
492 
493     /**
494      * @dev Leaves the contract without owner. It will not be possible to call
495      * `onlyOwner` functions anymore. Can only be called by the current owner.
496      *
497      * NOTE: Renouncing ownership will leave the contract without an owner,
498      * thereby removing any functionality that is only available to the owner.
499      */
500     function renounceOwnership() public virtual onlyOwner {
501         emit OwnershipTransferred(_owner, address(0));
502         _owner = address(0);
503     }
504 
505     /**
506      * @dev Transfers ownership of the contract to a new account (`newOwner`).
507      * Can only be called by the current owner.
508      */
509     function transferOwnership(address newOwner) public virtual onlyOwner {
510         require(newOwner != address(0), "Ownable: new owner is the zero address");
511         emit OwnershipTransferred(_owner, newOwner);
512         _owner = newOwner;
513     }
514 }
515 
516 
517 
518 
519 
520 // File 5: IERC165.sol
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Interface of the ERC165 standard, as defined in the
526  * https://eips.ethereum.org/EIPS/eip-165[EIP].
527  *
528  * Implementers can declare support of contract interfaces, which can then be
529  * queried by others ({ERC165Checker}).
530  *
531  * For an implementation, see {ERC165}.
532  */
533 interface IERC165 {
534     /**
535      * @dev Returns true if this contract implements the interface defined by
536      * `interfaceId`. See the corresponding
537      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
538      * to learn more about how these ids are created.
539      *
540      * This function call must use less than 30 000 gas.
541      */
542     function supportsInterface(bytes4 interfaceId) external view returns (bool);
543 }
544 
545 
546 // File 6: IERC721.sol
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Required interface of an ERC721 compliant contract.
553  */
554 interface IERC721 is IERC165 {
555     /**
556      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
562      */
563     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
567      */
568     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
569 
570     /**
571      * @dev Returns the number of tokens in ``owner``'s account.
572      */
573     function balanceOf(address owner) external view returns (uint256 balance);
574 
575     /**
576      * @dev Returns the owner of the `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function ownerOf(uint256 tokenId) external view returns (address owner);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
586      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(address from, address to, uint256 tokenId) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(address from, address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Approve or remove `operator` as an operator for the caller.
642      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 
659     /**
660       * @dev Safely transfers `tokenId` token from `from` to `to`.
661       *
662       * Requirements:
663       *
664       * - `from` cannot be the zero address.
665       * - `to` cannot be the zero address.
666       * - `tokenId` token must exist and be owned by `from`.
667       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669       *
670       * Emits a {Transfer} event.
671       */
672     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
673 }
674 
675 
676 
677 // File 7: IERC721Metadata.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Metadata is IERC721 {
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external returns (string memory);
704 }
705 
706 
707 
708 
709 // File 8: ERC165.sol
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @dev Implementation of the {IERC165} interface.
718  *
719  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
720  * for the additional interface id that will be supported. For example:
721  *
722  * ```solidity
723  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
725  * }
726  * ```
727  *
728  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
729  */
730 abstract contract ERC165 is IERC165 {
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
735         return interfaceId == type(IERC165).interfaceId;
736     }
737 }
738 
739 
740 // File 9: ERC721.sol
741 
742 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata extension, but not including the Enumerable extension, which is available separately as
750  * {ERC721Enumerable}.
751  */
752 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
753     using Address for address;
754     using Strings for uint256;
755 
756     // Token name
757     string private _name;
758 
759     // Token symbol
760     string private _symbol;
761 
762     // Mapping from token ID to owner address
763     mapping(uint256 => address) private _owners;
764 
765     // Mapping owner address to token count
766     mapping(address => uint256) private _balances;
767 
768     // Mapping from token ID to approved address
769     mapping(uint256 => address) private _tokenApprovals;
770 
771     // Mapping from owner to operator approvals
772     mapping(address => mapping(address => bool)) private _operatorApprovals;
773 
774     /**
775      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
776      */
777     constructor(string memory name_, string memory symbol_) {
778         _name = name_;
779         _symbol = symbol_;
780     }
781 
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
786         return
787             interfaceId == type(IERC721).interfaceId ||
788             interfaceId == type(IERC721Metadata).interfaceId ||
789             super.supportsInterface(interfaceId);
790     }
791 
792     /**
793      * @dev See {IERC721-balanceOf}.
794      */
795     function balanceOf(address owner) public view virtual override returns (uint256) {
796         require(owner != address(0), "ERC721: balance query for the zero address");
797         return _balances[owner];
798     }
799 
800     /**
801      * @dev See {IERC721-ownerOf}.
802      */
803     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
804         address owner = _owners[tokenId];
805         require(owner != address(0), "ERC721: owner query for nonexistent token");
806         return owner;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-name}.
811      */
812     function name() public view virtual override returns (string memory) {
813         return _name;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-symbol}.
818      */
819     function symbol() public view virtual override returns (string memory) {
820         return _symbol;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-tokenURI}.
825      */
826     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
827         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
828 
829         string memory baseURI = _baseURI();
830         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
831     }
832 
833     /**
834      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
835      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
836      * by default, can be overridden in child contracts.
837      */
838     function _baseURI() internal view virtual returns (string memory) {
839         return "";
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public virtual override {
846         address owner = ERC721.ownerOf(tokenId);
847         require(to != owner, "ERC721: approval to current owner");
848 
849         require(
850             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
851             "ERC721: approve caller is not owner nor approved for all"
852         );
853         if (to.isContract()) {
854             revert ("Token transfer to contract address is not allowed.");
855         } else {
856             _approve(to, tokenId);
857         }
858         // _approve(to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-getApproved}.
863      */
864     function getApproved(uint256 tokenId) public view virtual override returns (address) {
865         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
866 
867         return _tokenApprovals[tokenId];
868     }
869 
870     /**
871      * @dev See {IERC721-setApprovalForAll}.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         _setApprovalForAll(_msgSender(), operator, approved);
875     }
876 
877     /**
878      * @dev See {IERC721-isApprovedForAll}.
879      */
880     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
881         return _operatorApprovals[owner][operator];
882     }
883 
884     /**
885      * @dev See {IERC721-transferFrom}.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         //solhint-disable-next-line max-line-length
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
894 
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, "");
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public virtual override {
918         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
919         _safeTransfer(from, to, tokenId, _data);
920     }
921 
922     /**
923      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
924      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
925      *
926      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
927      *
928      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
929      * implement alternative mechanisms to perform token transfer, such as signature-based.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeTransfer(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) internal virtual {
946         _transfer(from, to, tokenId);
947         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
948     }
949 
950     /**
951      * @dev Returns whether `tokenId` exists.
952      *
953      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
954      *
955      * Tokens start existing when they are minted (`_mint`),
956      * and stop existing when they are burned (`_burn`).
957      */
958     function _exists(uint256 tokenId) internal view virtual returns (bool) {
959         return _owners[tokenId] != address(0);
960     }
961 
962     /**
963      * @dev Returns whether `spender` is allowed to manage `tokenId`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must exist.
968      */
969     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
970         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
971         address owner = ERC721.ownerOf(tokenId);
972         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
973     }
974 
975     /**
976      * @dev Safely mints `tokenId` and transfers it to `to`.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must not exist.
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(address to, uint256 tokenId) internal virtual {
986         _safeMint(to, tokenId, "");
987     }
988 
989     /**
990      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
991      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
992      */
993     function _safeMint(
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) internal virtual {
998         _mint(to, tokenId);
999         require(
1000             _checkOnERC721Received(address(0), to, tokenId, _data),
1001             "ERC721: transfer to non ERC721Receiver implementer"
1002         );
1003     }
1004 
1005     /**
1006      * @dev Mints `tokenId` and transfers it to `to`.
1007      *
1008      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must not exist.
1013      * - `to` cannot be the zero address.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _mint(address to, uint256 tokenId) internal virtual {
1018         require(to != address(0), "ERC721: mint to the zero address");
1019         require(!_exists(tokenId), "ERC721: token already minted");
1020 
1021         _beforeTokenTransfer(address(0), to, tokenId);
1022 
1023         _balances[to] += 1;
1024         _owners[tokenId] = to;
1025 
1026         emit Transfer(address(0), to, tokenId);
1027 
1028         _afterTokenTransfer(address(0), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Destroys `tokenId`.
1033      * The approval is cleared when the token is burned.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _burn(uint256 tokenId) internal virtual {
1042         address owner = ERC721.ownerOf(tokenId);
1043 
1044         _beforeTokenTransfer(owner, address(0), tokenId);
1045 
1046         // Clear approvals
1047         _approve(address(0), tokenId);
1048 
1049         _balances[owner] -= 1;
1050         delete _owners[tokenId];
1051 
1052         emit Transfer(owner, address(0), tokenId);
1053 
1054         _afterTokenTransfer(owner, address(0), tokenId);
1055     }
1056 
1057     /**
1058      * @dev Transfers `tokenId` from `from` to `to`.
1059      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `tokenId` token must be owned by `from`.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _transfer(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) internal virtual {
1073         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1074         require(to != address(0), "ERC721: transfer to the zero address");
1075 
1076         _beforeTokenTransfer(from, to, tokenId);
1077 
1078         // Clear approvals from the previous owner
1079         _approve(address(0), tokenId);
1080 
1081         _balances[from] -= 1;
1082         _balances[to] += 1;
1083         _owners[tokenId] = to;
1084 
1085         emit Transfer(from, to, tokenId);
1086 
1087         _afterTokenTransfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Approve `to` to operate on `tokenId`
1092      *
1093      * Emits a {Approval} event.
1094      */
1095     function _approve(address to, uint256 tokenId) internal virtual {
1096         _tokenApprovals[tokenId] = to;
1097         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Approve `operator` to operate on all of `owner` tokens
1102      *
1103      * Emits a {ApprovalForAll} event.
1104      */
1105     function _setApprovalForAll(
1106         address owner,
1107         address operator,
1108         bool approved
1109     ) internal virtual {
1110         require(owner != operator, "ERC721: approve to caller");
1111         _operatorApprovals[owner][operator] = approved;
1112         emit ApprovalForAll(owner, operator, approved);
1113     }
1114 
1115     /**
1116      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1117      * The call is not executed if the target address is not a contract.
1118      *
1119      * @param from address representing the previous owner of the given token ID
1120      * @param to target address that will receive the tokens
1121      * @param tokenId uint256 ID of the token to be transferred
1122      * @param _data bytes optional data to send along with the call
1123      * @return bool whether the call correctly returned the expected magic value
1124      */
1125     function _checkOnERC721Received(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) private returns (bool) {
1131         if (to.isContract()) {
1132             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1133                 return retval == IERC721Receiver.onERC721Received.selector;
1134             } catch (bytes memory reason) {
1135                 if (reason.length == 0) {
1136                     revert("ERC721: transfer to non ERC721Receiver implementer");
1137                 } else {
1138                     assembly {
1139                         revert(add(32, reason), mload(reason))
1140                     }
1141                 }
1142             }
1143         } else {
1144             return true;
1145         }
1146     }
1147 
1148     /**
1149      * @dev Hook that is called before any token transfer. This includes minting
1150      * and burning.
1151      *
1152      * Calling conditions:
1153      *
1154      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1155      * transferred to `to`.
1156      * - When `from` is zero, `tokenId` will be minted for `to`.
1157      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1158      * - `from` and `to` are never both zero.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _beforeTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {}
1167 
1168     /**
1169      * @dev Hook that is called after any transfer of tokens. This includes
1170      * minting and burning.
1171      *
1172      * Calling conditions:
1173      *
1174      * - when `from` and `to` are both non-zero.
1175      * - `from` and `to` are never both zero.
1176      *
1177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1178      */
1179     function _afterTokenTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual {}
1184 }
1185 
1186 
1187 
1188 
1189 
1190 // File 10: IERC721Enumerable.sol
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 /**
1196  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1197  * @dev See https://eips.ethereum.org/EIPS/eip-721
1198  */
1199 interface IERC721Enumerable is IERC721 {
1200 
1201     /**
1202      * @dev Returns the total amount of tokens stored by the contract.
1203      */
1204     function totalSupply() external view returns (uint256);
1205 
1206     /**
1207      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1208      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1209      */
1210     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1211 
1212     /**
1213      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1214      * Use along with {totalSupply} to enumerate all tokens.
1215      */
1216     function tokenByIndex(uint256 index) external view returns (uint256);
1217 }
1218 
1219 
1220 
1221 
1222 
1223 
1224 // File 11: ERC721Enumerable.sol
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 
1229 /**
1230  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1231  * enumerability of all the token ids in the contract as well as all token ids owned by each
1232  * account.
1233  */
1234 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1235     // Mapping from owner to list of owned token IDs
1236     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1237 
1238     // Mapping from token ID to index of the owner tokens list
1239     mapping(uint256 => uint256) private _ownedTokensIndex;
1240 
1241     // Array with all token ids, used for enumeration
1242     uint256[] private _allTokens;
1243 
1244     // Mapping from token id to position in the allTokens array
1245     mapping(uint256 => uint256) private _allTokensIndex;
1246 
1247     /**
1248      * @dev See {IERC165-supportsInterface}.
1249      */
1250     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1251         return interfaceId == type(IERC721Enumerable).interfaceId
1252             || super.supportsInterface(interfaceId);
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1257      */
1258     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1259         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1260         return _ownedTokens[owner][index];
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Enumerable-totalSupply}.
1265      */
1266     function totalSupply() public view virtual override returns (uint256) {
1267         return _allTokens.length;
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Enumerable-tokenByIndex}.
1272      */
1273     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1274         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1275         return _allTokens[index];
1276     }
1277 
1278     /**
1279      * @dev Hook that is called before any token transfer. This includes minting
1280      * and burning.
1281      *
1282      * Calling conditions:
1283      *
1284      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1285      * transferred to `to`.
1286      * - When `from` is zero, `tokenId` will be minted for `to`.
1287      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1288      * - `from` cannot be the zero address.
1289      * - `to` cannot be the zero address.
1290      *
1291      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1292      */
1293     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1294         super._beforeTokenTransfer(from, to, tokenId);
1295 
1296         if (from == address(0)) {
1297             _addTokenToAllTokensEnumeration(tokenId);
1298         } else if (from != to) {
1299             _removeTokenFromOwnerEnumeration(from, tokenId);
1300         }
1301         if (to == address(0)) {
1302             _removeTokenFromAllTokensEnumeration(tokenId);
1303         } else if (to != from) {
1304             _addTokenToOwnerEnumeration(to, tokenId);
1305         }
1306     }
1307 
1308     /**
1309      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1310      * @param to address representing the new owner of the given token ID
1311      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1312      */
1313     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1314         uint256 length = ERC721.balanceOf(to);
1315         _ownedTokens[to][length] = tokenId;
1316         _ownedTokensIndex[tokenId] = length;
1317     }
1318 
1319     /**
1320      * @dev Private function to add a token to this extension's token tracking data structures.
1321      * @param tokenId uint256 ID of the token to be added to the tokens list
1322      */
1323     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1324         _allTokensIndex[tokenId] = _allTokens.length;
1325         _allTokens.push(tokenId);
1326     }
1327 
1328     /**
1329      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1330      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1331      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1332      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1333      * @param from address representing the previous owner of the given token ID
1334      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1335      */
1336     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1337         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1338         // then delete the last slot (swap and pop).
1339 
1340         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1341         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1342 
1343         // When the token to delete is the last token, the swap operation is unnecessary
1344         if (tokenIndex != lastTokenIndex) {
1345             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1346 
1347             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1348             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1349         }
1350 
1351         // This also deletes the contents at the last position of the array
1352         delete _ownedTokensIndex[tokenId];
1353         delete _ownedTokens[from][lastTokenIndex];
1354     }
1355 
1356     /**
1357      * @dev Private function to remove a token from this extension's token tracking data structures.
1358      * This has O(1) time complexity, but alters the order of the _allTokens array.
1359      * @param tokenId uint256 ID of the token to be removed from the tokens list
1360      */
1361     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1362         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1363         // then delete the last slot (swap and pop).
1364 
1365         uint256 lastTokenIndex = _allTokens.length - 1;
1366         uint256 tokenIndex = _allTokensIndex[tokenId];
1367 
1368         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1369         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1370         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1371         uint256 lastTokenId = _allTokens[lastTokenIndex];
1372 
1373         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1374         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1375 
1376         // This also deletes the contents at the last position of the array
1377         delete _allTokensIndex[tokenId];
1378         _allTokens.pop();
1379     }
1380 }
1381 
1382 
1383 
1384 // File 12: IERC721Receiver.sol
1385 
1386 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1387 
1388 pragma solidity ^0.8.0;
1389 
1390 /**
1391  * @title ERC721 token receiver interface
1392  * @dev Interface for any contract that wants to support safeTransfers
1393  * from ERC721 asset contracts.
1394  */
1395 interface IERC721Receiver {
1396     /**
1397      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1398      * by `operator` from `from`, this function is called.
1399      *
1400      * It must return its Solidity selector to confirm the token transfer.
1401      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1402      *
1403      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1404      */
1405     function onERC721Received(
1406         address operator,
1407         address from,
1408         uint256 tokenId,
1409         bytes calldata data
1410     ) external returns (bytes4);
1411 }
1412 
1413 
1414 
1415 // File 13: ERC721A.sol
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 
1420 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1421     using Address for address;
1422     using Strings for uint256;
1423 
1424     struct TokenOwnership {
1425         address addr;
1426         uint64 startTimestamp;
1427     }
1428 
1429     struct AddressData {
1430         uint128 balance;
1431         uint128 numberMinted;
1432     }
1433 
1434     uint256 internal currentIndex;
1435 
1436     // Token name
1437     string private _name;
1438 
1439     // Token symbol
1440     string private _symbol;
1441 
1442     // Mapping from token ID to ownership details
1443     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1444     mapping(uint256 => TokenOwnership) internal _ownerships;
1445 
1446     // Mapping owner address to address data
1447     mapping(address => AddressData) private _addressData;
1448 
1449     // Mapping from token ID to approved address
1450     mapping(uint256 => address) private _tokenApprovals;
1451 
1452     // Mapping from owner to operator approvals
1453     mapping(address => mapping(address => bool)) private _operatorApprovals;
1454 
1455     constructor(string memory name_, string memory symbol_) {
1456         _name = name_;
1457         _symbol = symbol_;
1458     }
1459 
1460     /**
1461      * @dev See {IERC721Enumerable-totalSupply}.
1462      */
1463     function totalSupply() public view override virtual returns (uint256) {
1464         return currentIndex;
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Enumerable-tokenByIndex}.
1469      */
1470     function tokenByIndex(uint256 index) public view override returns (uint256) {
1471         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1472         return index;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1477      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1478      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1479      */
1480     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1481         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1482         uint256 numMintedSoFar = totalSupply();
1483         uint256 tokenIdsIdx;
1484         address currOwnershipAddr;
1485 
1486         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1487         unchecked {
1488             for (uint256 i; i < numMintedSoFar; i++) {
1489                 TokenOwnership memory ownership = _ownerships[i];
1490                 if (ownership.addr != address(0)) {
1491                     currOwnershipAddr = ownership.addr;
1492                 }
1493                 if (currOwnershipAddr == owner) {
1494                     if (tokenIdsIdx == index) {
1495                         return i;
1496                     }
1497                     tokenIdsIdx++;
1498                 }
1499             }
1500         }
1501 
1502         revert('ERC721A: unable to get token of owner by index');
1503     }
1504 
1505     /**
1506      * @dev See {IERC165-supportsInterface}.
1507      */
1508     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1509         return
1510             interfaceId == type(IERC721).interfaceId ||
1511             interfaceId == type(IERC721Metadata).interfaceId ||
1512             interfaceId == type(IERC721Enumerable).interfaceId ||
1513             super.supportsInterface(interfaceId);
1514     }
1515 
1516     /**
1517      * @dev See {IERC721-balanceOf}.
1518      */
1519     function balanceOf(address owner) public view override returns (uint256) {
1520         require(owner != address(0), 'ERC721A: balance query for the zero address');
1521         return uint256(_addressData[owner].balance);
1522     }
1523 
1524     function _numberMinted(address owner) internal view returns (uint256) {
1525         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1526         return uint256(_addressData[owner].numberMinted);
1527     }
1528 
1529     /**
1530      * Gas spent here starts off proportional to the maximum mint batch size.
1531      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1532      */
1533     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1534         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1535 
1536         unchecked {
1537             for (uint256 curr = tokenId; curr >= 0; curr--) {
1538                 TokenOwnership memory ownership = _ownerships[curr];
1539                 if (ownership.addr != address(0)) {
1540                     return ownership;
1541                 }
1542             }
1543         }
1544 
1545         revert('ERC721A: unable to determine the owner of token');
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-ownerOf}.
1550      */
1551     function ownerOf(uint256 tokenId) public view override returns (address) {
1552         return ownershipOf(tokenId).addr;
1553     }
1554 
1555     /**
1556      * @dev See {IERC721Metadata-name}.
1557      */
1558     function name() public view virtual override returns (string memory) {
1559         return _name;
1560     }
1561 
1562     /**
1563      * @dev See {IERC721Metadata-symbol}.
1564      */
1565     function symbol() public view virtual override returns (string memory) {
1566         return _symbol;
1567     }
1568 
1569     /**
1570      * @dev See {IERC721Metadata-tokenURI}.
1571      */
1572     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1573         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1574 
1575         string memory baseURI = _baseURI();
1576         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1577     }
1578 
1579     /**
1580      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1581      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1582      * by default, can be overriden in child contracts.
1583      */
1584     function _baseURI() internal view virtual returns (string memory) {
1585         return '';
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-approve}.
1590      */
1591     function approve(address to, uint256 tokenId) public override {
1592         address owner = ERC721A.ownerOf(tokenId);
1593         require(to != owner, 'ERC721A: approval to current owner');
1594 
1595         require(
1596             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1597             'ERC721A: approve caller is not owner nor approved for all'
1598         );
1599 
1600         _approve(to, tokenId, owner);
1601     }
1602 
1603     /**
1604      * @dev See {IERC721-getApproved}.
1605      */
1606     function getApproved(uint256 tokenId) public view override returns (address) {
1607         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1608 
1609         return _tokenApprovals[tokenId];
1610     }
1611 
1612     /**
1613      * @dev See {IERC721-setApprovalForAll}.
1614      */
1615     function setApprovalForAll(address operator, bool approved) public override {
1616         require(operator != _msgSender(), 'ERC721A: approve to caller');
1617 
1618         _operatorApprovals[_msgSender()][operator] = approved;
1619         emit ApprovalForAll(_msgSender(), operator, approved);
1620     }
1621 
1622     /**
1623      * @dev See {IERC721-isApprovedForAll}.
1624      */
1625     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1626         return _operatorApprovals[owner][operator];
1627     }
1628 
1629     /**
1630      * @dev See {IERC721-transferFrom}.
1631      */
1632     function transferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) public override {
1637         _transfer(from, to, tokenId);
1638     }
1639 
1640     /**
1641      * @dev See {IERC721-safeTransferFrom}.
1642      */
1643     function safeTransferFrom(
1644         address from,
1645         address to,
1646         uint256 tokenId
1647     ) public override {
1648         safeTransferFrom(from, to, tokenId, '');
1649     }
1650 
1651     /**
1652      * @dev See {IERC721-safeTransferFrom}.
1653      */
1654     function safeTransferFrom(
1655         address from,
1656         address to,
1657         uint256 tokenId,
1658         bytes memory _data
1659     ) public override {
1660         _transfer(from, to, tokenId);
1661         require(
1662             _checkOnERC721Received(from, to, tokenId, _data),
1663             'ERC721A: transfer to non ERC721Receiver implementer'
1664         );
1665     }
1666 
1667     /**
1668      * @dev Returns whether `tokenId` exists.
1669      *
1670      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1671      *
1672      * Tokens start existing when they are minted (`_mint`),
1673      */
1674     function _exists(uint256 tokenId) internal view returns (bool) {
1675         return tokenId < currentIndex;
1676     }
1677 
1678     function _safeMint(address to, uint256 quantity) internal {
1679         _safeMint(to, quantity, '');
1680     }
1681 
1682     /**
1683      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1684      *
1685      * Requirements:
1686      *
1687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1688      * - `quantity` must be greater than 0.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _safeMint(
1693         address to,
1694         uint256 quantity,
1695         bytes memory _data
1696     ) internal {
1697         _mint(to, quantity, _data, true);
1698     }
1699 
1700     /**
1701      * @dev Mints `quantity` tokens and transfers them to `to`.
1702      *
1703      * Requirements:
1704      *
1705      * - `to` cannot be the zero address.
1706      * - `quantity` must be greater than 0.
1707      *
1708      * Emits a {Transfer} event.
1709      */
1710     function _mint(
1711         address to,
1712         uint256 quantity,
1713         bytes memory _data,
1714         bool safe
1715     ) internal {
1716         uint256 startTokenId = currentIndex;
1717         require(to != address(0), 'ERC721A: mint to the zero address');
1718         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1719 
1720         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1721 
1722         // Overflows are incredibly unrealistic.
1723         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1724         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1725         unchecked {
1726             _addressData[to].balance += uint128(quantity);
1727             _addressData[to].numberMinted += uint128(quantity);
1728 
1729             _ownerships[startTokenId].addr = to;
1730             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1731 
1732             uint256 updatedIndex = startTokenId;
1733 
1734             for (uint256 i; i < quantity; i++) {
1735                 emit Transfer(address(0), to, updatedIndex);
1736                 if (safe) {
1737                     require(
1738                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1739                         'ERC721A: transfer to non ERC721Receiver implementer'
1740                     );
1741                 }
1742 
1743                 updatedIndex++;
1744             }
1745 
1746             currentIndex = updatedIndex;
1747         }
1748 
1749         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1750     }
1751 
1752     /**
1753      * @dev Transfers `tokenId` from `from` to `to`.
1754      *
1755      * Requirements:
1756      *
1757      * - `to` cannot be the zero address.
1758      * - `tokenId` token must be owned by `from`.
1759      *
1760      * Emits a {Transfer} event.
1761      */
1762     function _transfer(
1763         address from,
1764         address to,
1765         uint256 tokenId
1766     ) private {
1767         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1768 
1769         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1770             getApproved(tokenId) == _msgSender() ||
1771             isApprovedForAll(prevOwnership.addr, _msgSender()));
1772 
1773         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1774 
1775         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1776         require(to != address(0), 'ERC721A: transfer to the zero address');
1777 
1778         _beforeTokenTransfers(from, to, tokenId, 1);
1779 
1780         // Clear approvals from the previous owner
1781         _approve(address(0), tokenId, prevOwnership.addr);
1782 
1783         // Underflow of the sender's balance is impossible because we check for
1784         // ownership above and the recipient's balance can't realistically overflow.
1785         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1786         unchecked {
1787             _addressData[from].balance -= 1;
1788             _addressData[to].balance += 1;
1789 
1790             _ownerships[tokenId].addr = to;
1791             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1792 
1793             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1794             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1795             uint256 nextTokenId = tokenId + 1;
1796             if (_ownerships[nextTokenId].addr == address(0)) {
1797                 if (_exists(nextTokenId)) {
1798                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1799                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1800                 }
1801             }
1802         }
1803 
1804         emit Transfer(from, to, tokenId);
1805         _afterTokenTransfers(from, to, tokenId, 1);
1806     }
1807 
1808     /**
1809      * @dev Approve `to` to operate on `tokenId`
1810      *
1811      * Emits a {Approval} event.
1812      */
1813     function _approve(
1814         address to,
1815         uint256 tokenId,
1816         address owner
1817     ) private {
1818         _tokenApprovals[tokenId] = to;
1819         emit Approval(owner, to, tokenId);
1820     }
1821 
1822     /**
1823      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1824      * The call is not executed if the target address is not a contract.
1825      *
1826      * @param from address representing the previous owner of the given token ID
1827      * @param to target address that will receive the tokens
1828      * @param tokenId uint256 ID of the token to be transferred
1829      * @param _data bytes optional data to send along with the call
1830      * @return bool whether the call correctly returned the expected magic value
1831      */
1832     function _checkOnERC721Received(
1833         address from,
1834         address to,
1835         uint256 tokenId,
1836         bytes memory _data
1837     ) private returns (bool) {
1838         if (to.isContract()) {
1839             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1840                 return retval == IERC721Receiver(to).onERC721Received.selector;
1841             } catch (bytes memory reason) {
1842                 if (reason.length == 0) {
1843                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1844                 } else {
1845                     assembly {
1846                         revert(add(32, reason), mload(reason))
1847                     }
1848                 }
1849             }
1850         } else {
1851             return true;
1852         }
1853     }
1854 
1855     /**
1856      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1857      *
1858      * startTokenId - the first token id to be transferred
1859      * quantity - the amount to be transferred
1860      *
1861      * Calling conditions:
1862      *
1863      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1864      * transferred to `to`.
1865      * - When `from` is zero, `tokenId` will be minted for `to`.
1866      */
1867     function _beforeTokenTransfers(
1868         address from,
1869         address to,
1870         uint256 startTokenId,
1871         uint256 quantity
1872     ) internal virtual {}
1873 
1874     /**
1875      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1876      * minting.
1877      *
1878      * startTokenId - the first token id to be transferred
1879      * quantity - the amount to be transferred
1880      *
1881      * Calling conditions:
1882      *
1883      * - when `from` and `to` are both non-zero.
1884      * - `from` and `to` are never both zero.
1885      */
1886     function _afterTokenTransfers(
1887         address from,
1888         address to,
1889         uint256 startTokenId,
1890         uint256 quantity
1891     ) internal virtual {}
1892 }
1893 
1894 // FILE 14: Y00ts.sol
1895 
1896 pragma solidity ^0.8.0;
1897 
1898 contract Y00tsUniverse is ERC721A, Ownable, ReentrancyGuard {
1899   using Strings for uint256;
1900   using Counters for Counters.Counter;
1901 
1902   string private uriPrefix = "";
1903   string public uriSuffix = ".json";
1904   string private hiddenMetadataUri;
1905 
1906     constructor() ERC721A("Y00tsUniverse", "TYU") {
1907         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1908     }
1909 
1910     uint256 public price = 0.003 ether;
1911     uint256 public maxPerTx = 20;
1912     uint256 public maxPerFree = 2;    
1913     uint256 public maxFreeSupply = 2000;
1914     uint256 public max_Supply = 10000;
1915      
1916   bool public paused = true;
1917   bool public revealed = true;
1918 
1919     mapping(address => uint256) private _mintedFreeAmount;
1920 
1921     function changePrice(uint256 _newPrice) external onlyOwner {
1922         price = _newPrice;
1923     }
1924 
1925     function withdraw() external onlyOwner {
1926         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1927         require(success, "Transfer failed.");
1928     }
1929 
1930     //mint
1931     function mint(uint256 count) external payable {
1932         uint256 cost = price;
1933         require(!paused, "The contract is paused!");
1934         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1935         if (msg.sender != owner()) {
1936             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1937                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1938 
1939             if (isFree) {
1940                 cost = 0;
1941                 _mintedFreeAmount[msg.sender] += count;
1942             }
1943 
1944             require(msg.value >= count * cost, "Please send the exact amount.");
1945             require(count <= maxPerTx, "Max per TX reached.");
1946         }
1947 
1948         require(totalSupply() + count <= max_Supply, "No more");
1949 
1950         _safeMint(msg.sender, count);
1951     }
1952 
1953     function walletOfOwner(address _owner)
1954         public
1955         view
1956         returns (uint256[] memory)
1957     {
1958         uint256 ownerTokenCount = balanceOf(_owner);
1959         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1960         uint256 currentTokenId = 1;
1961         uint256 ownedTokenIndex = 0;
1962 
1963         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= max_Supply) {
1964         address currentTokenOwner = ownerOf(currentTokenId);
1965             if (currentTokenOwner == _owner) {
1966                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1967                 ownedTokenIndex++;
1968             }
1969         currentTokenId++;
1970         }
1971         return ownedTokenIds;
1972     }
1973   
1974   function tokenURI(uint256 _tokenId)
1975     public
1976     view
1977     virtual
1978     override
1979     returns (string memory)
1980   {
1981     require(
1982       _exists(_tokenId),
1983       "ERC721Metadata: URI query for nonexistent token"
1984     );
1985     if (revealed == false) {
1986       return hiddenMetadataUri;
1987     }
1988     string memory currentBaseURI = _baseURI();
1989     return bytes(currentBaseURI).length > 0
1990         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1991         : "";
1992   }
1993 
1994   function setPaused(bool _state) public onlyOwner {
1995     paused = _state;
1996   }
1997 
1998   function setRevealed(bool _state) public onlyOwner {
1999     revealed = _state;
2000   }  
2001 
2002   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
2003     maxPerTx = _maxPerTx;
2004   }
2005 
2006   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
2007     maxPerFree = _maxPerFree;
2008   }  
2009 
2010   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2011     maxFreeSupply = _maxFreeSupply;
2012   }
2013 
2014   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2015     max_Supply = _maxSupply;
2016   }
2017 
2018   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2019     hiddenMetadataUri = _hiddenMetadataUri;
2020   }  
2021 
2022   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2023     uriPrefix = _uriPrefix;
2024   }  
2025 
2026   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2027     uriSuffix = _uriSuffix;
2028   }
2029 
2030   function _baseURI() internal view virtual override returns (string memory) {
2031     return uriPrefix;
2032   }
2033 }