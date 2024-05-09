1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-23
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File 1: Address.sol
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
10 
11 pragma solidity ^0.8.1;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      *
34      * [IMPORTANT]
35      * ====
36      * You shouldn't rely on `isContract` to protect against flash loan attacks!
37      *
38      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
39      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
40      * constructor.
41      * ====
42      */
43     function isContract(address account) internal view returns (bool) {
44         // This method relies on extcodesize/address.code.length, which returns 0
45         // for contracts in construction, since the code is only stored at the end
46         // of the constructor execution.
47 
48         return account.code.length > 0;
49     }
50 
51     /**
52      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
53      * `recipient`, forwarding all available gas and reverting on errors.
54      *
55      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
56      * of certain opcodes, possibly making contracts go over the 2300 gas limit
57      * imposed by `transfer`, making them unable to receive funds via
58      * `transfer`. {sendValue} removes this limitation.
59      *
60      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
61      *
62      * IMPORTANT: because control is transferred to `recipient`, care must be
63      * taken to not create reentrancy vulnerabilities. Consider using
64      * {ReentrancyGuard} or the
65      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         (bool success, ) = recipient.call{value: amount}("");
71         require(success, "Address: unable to send value, recipient may have reverted");
72     }
73 
74     /**
75      * @dev Performs a Solidity function call using a low level `call`. A
76      * plain `call` is an unsafe replacement for a function call: use this
77      * function instead.
78      *
79      * If `target` reverts with a revert reason, it is bubbled up by this
80      * function (like regular Solidity function calls).
81      *
82      * Returns the raw returned data. To convert to the expected return value,
83      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
84      *
85      * Requirements:
86      *
87      * - `target` must be a contract.
88      * - calling `target` with `data` must not revert.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
98      * `errorMessage` as a fallback revert reason when `target` reverts.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
112      * but also transferring `value` wei to `target`.
113      *
114      * Requirements:
115      *
116      * - the calling contract must have an ETH balance of at least `value`.
117      * - the called Solidity function must be `payable`.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value
125     ) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
131      * with `errorMessage` as a fallback revert reason when `target` reverts.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value,
139         string memory errorMessage
140     ) internal returns (bytes memory) {
141         require(address(this).balance >= value, "Address: insufficient balance for call");
142         require(isContract(target), "Address: call to non-contract");
143 
144         (bool success, bytes memory returndata) = target.call{value: value}(data);
145         return verifyCallResult(success, returndata, errorMessage);
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155         return functionStaticCall(target, data, "Address: low-level static call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal view returns (bytes memory) {
169         require(isContract(target), "Address: static call to non-contract");
170 
171         (bool success, bytes memory returndata) = target.staticcall(data);
172         return verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         require(isContract(target), "Address: delegate call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.delegatecall(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     /**
203      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
204      * revert reason using the provided one.
205      *
206      * _Available since v4.3._
207      */
208     function verifyCallResult(
209         bool success,
210         bytes memory returndata,
211         string memory errorMessage
212     ) internal pure returns (bytes memory) {
213         if (success) {
214             return returndata;
215         } else {
216             // Look for revert reason and bubble it up if present
217             if (returndata.length > 0) {
218                 // The easiest way to bubble the revert reason is using memory via assembly
219 
220                 assembly {
221                     let returndata_size := mload(returndata)
222                     revert(add(32, returndata), returndata_size)
223                 }
224             } else {
225                 revert(errorMessage);
226             }
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Contract module that helps prevent reentrant calls to a function.
240  *
241  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
242  * available, which can be applied to functions to make sure there are no nested
243  * (reentrant) calls to them.
244  *
245  * Note that because there is a single `nonReentrant` guard, functions marked as
246  * `nonReentrant` may not call one another. This can be worked around by making
247  * those functions `private`, and then adding `external` `nonReentrant` entry
248  * points to them.
249  *
250  * TIP: If you would like to learn more about reentrancy and alternative ways
251  * to protect against it, check out our blog post
252  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
253  */
254 abstract contract ReentrancyGuard {
255     // Booleans are more expensive than uint256 or any type that takes up a full
256     // word because each write operation emits an extra SLOAD to first read the
257     // slot's contents, replace the bits taken up by the boolean, and then write
258     // back. This is the compiler's defense against contract upgrades and
259     // pointer aliasing, and it cannot be disabled.
260 
261     // The values being non-zero value makes deployment a bit more expensive,
262     // but in exchange the refund on every call to nonReentrant will be lower in
263     // amount. Since refunds are capped to a percentage of the total
264     // transaction's gas, it is best to keep them low in cases like this one, to
265     // increase the likelihood of the full refund coming into effect.
266     uint256 private constant _NOT_ENTERED = 1;
267     uint256 private constant _ENTERED = 2;
268 
269     uint256 private _status;
270 
271     constructor() {
272         _status = _NOT_ENTERED;
273     }
274 
275     /**
276      * @dev Prevents a contract from calling itself, directly or indirectly.
277      * Calling a `nonReentrant` function from another `nonReentrant`
278      * function is not supported. It is possible to prevent this from happening
279      * by making the `nonReentrant` function external, and making it call a
280      * `private` function that does the actual work.
281      */
282     modifier nonReentrant() {
283         // On the first call to nonReentrant, _notEntered will be true
284         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
285 
286         // Any calls to nonReentrant after this point will fail
287         _status = _ENTERED;
288 
289         _;
290 
291         // By storing the original value once again, a refund is triggered (see
292         // https://eips.ethereum.org/EIPS/eip-2200)
293         _status = _NOT_ENTERED;
294     }
295 }
296 
297 // FILE 2: Context.sol
298 pragma solidity ^0.8.0;
299 
300 /*
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes calldata) {
316         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
317         return msg.data;
318     }
319 }
320 
321 // File 3: Strings.sol
322 
323 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev String operations.
329  */
330 library Strings {
331     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
332 
333     /**
334      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
335      */
336     function toString(uint256 value) internal pure returns (string memory) {
337         // Inspired by OraclizeAPI's implementation - MIT licence
338         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
339 
340         if (value == 0) {
341             return "0";
342         }
343         uint256 temp = value;
344         uint256 digits;
345         while (temp != 0) {
346             digits++;
347             temp /= 10;
348         }
349         bytes memory buffer = new bytes(digits);
350         while (value != 0) {
351             digits -= 1;
352             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
353             value /= 10;
354         }
355         return string(buffer);
356     }
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
360      */
361     function toHexString(uint256 value) internal pure returns (string memory) {
362         if (value == 0) {
363             return "0x00";
364         }
365         uint256 temp = value;
366         uint256 length = 0;
367         while (temp != 0) {
368             length++;
369             temp >>= 8;
370         }
371         return toHexString(value, length);
372     }
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
376      */
377     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
378         bytes memory buffer = new bytes(2 * length + 2);
379         buffer[0] = "0";
380         buffer[1] = "x";
381         for (uint256 i = 2 * length + 1; i > 1; --i) {
382             buffer[i] = _HEX_SYMBOLS[value & 0xf];
383             value >>= 4;
384         }
385         require(value == 0, "Strings: hex length insufficient");
386         return string(buffer);
387     }
388 }
389 
390 
391 // File: @openzeppelin/contracts/utils/Counters.sol
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @title Counters
400  * @author Matt Condon (@shrugs)
401  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
402  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
403  *
404  * Include with `using Counters for Counters.Counter;`
405  */
406 library Counters {
407     struct Counter {
408         // This variable should never be directly accessed by users of the library: interactions must be restricted to
409         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
410         // this feature: see https://github.com/ethereum/solidity/issues/4637
411         uint256 _value; // default: 0
412     }
413 
414     function current(Counter storage counter) internal view returns (uint256) {
415         return counter._value;
416     }
417 
418     function increment(Counter storage counter) internal {
419         unchecked {
420             counter._value += 1;
421         }
422     }
423 
424     function decrement(Counter storage counter) internal {
425         uint256 value = counter._value;
426         require(value > 0, "Counter: decrement overflow");
427         unchecked {
428             counter._value = value - 1;
429         }
430     }
431 
432     function reset(Counter storage counter) internal {
433         counter._value = 0;
434     }
435 }
436 
437 // File 4: Ownable.sol
438 
439 
440 pragma solidity ^0.8.0;
441 
442 
443 /**
444  * @dev Contract module which provides a basic access control mechanism, where
445  * there is an account (an owner) that can be granted exclusive access to
446  * specific functions.
447  *
448  * By default, the owner account will be the one that deploys the contract. This
449  * can later be changed with {transferOwnership}.
450  *
451  * This module is used through inheritance. It will make available the modifier
452  * `onlyOwner`, which can be applied to your functions to restrict their use to
453  * the owner.
454  */
455 abstract contract Ownable is Context {
456     address private _owner;
457 
458     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
459 
460     /**
461      * @dev Initializes the contract setting the deployer as the initial owner.
462      */
463     constructor () {
464         address msgSender = _msgSender();
465         _owner = msgSender;
466         emit OwnershipTransferred(address(0), msgSender);
467     }
468 
469     /**
470      * @dev Returns the address of the current owner.
471      */
472     function owner() public view virtual returns (address) {
473         return _owner;
474     }
475 
476     /**
477      * @dev Throws if called by any account other than the owner.
478      */
479     modifier onlyOwner() {
480         require(owner() == _msgSender(), "Ownable: caller is not the owner");
481         _;
482     }
483 
484     /**
485      * @dev Leaves the contract without owner. It will not be possible to call
486      * `onlyOwner` functions anymore. Can only be called by the current owner.
487      *
488      * NOTE: Renouncing ownership will leave the contract without an owner,
489      * thereby removing any functionality that is only available to the owner.
490      */
491     function renounceOwnership() public virtual onlyOwner {
492         emit OwnershipTransferred(_owner, address(0));
493         _owner = address(0);
494     }
495 
496     /**
497      * @dev Transfers ownership of the contract to a new account (`newOwner`).
498      * Can only be called by the current owner.
499      */
500     function transferOwnership(address newOwner) public virtual onlyOwner {
501         require(newOwner != address(0), "Ownable: new owner is the zero address");
502         emit OwnershipTransferred(_owner, newOwner);
503         _owner = newOwner;
504     }
505 }
506 
507 
508 
509 
510 
511 // File 5: IERC165.sol
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Interface of the ERC165 standard, as defined in the
517  * https://eips.ethereum.org/EIPS/eip-165[EIP].
518  *
519  * Implementers can declare support of contract interfaces, which can then be
520  * queried by others ({ERC165Checker}).
521  *
522  * For an implementation, see {ERC165}.
523  */
524 interface IERC165 {
525     /**
526      * @dev Returns true if this contract implements the interface defined by
527      * `interfaceId`. See the corresponding
528      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
529      * to learn more about how these ids are created.
530      *
531      * This function call must use less than 30 000 gas.
532      */
533     function supportsInterface(bytes4 interfaceId) external view returns (bool);
534 }
535 
536 
537 // File 6: IERC721.sol
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Required interface of an ERC721 compliant contract.
544  */
545 interface IERC721 is IERC165 {
546     /**
547      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
548      */
549     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
553      */
554     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
558      */
559     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
560 
561     /**
562      * @dev Returns the number of tokens in ``owner``'s account.
563      */
564     function balanceOf(address owner) external view returns (uint256 balance);
565 
566     /**
567      * @dev Returns the owner of the `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function ownerOf(uint256 tokenId) external view returns (address owner);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
577      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(address from, address to, uint256 tokenId) external;
590 
591     /**
592      * @dev Transfers `tokenId` token from `from` to `to`.
593      *
594      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must be owned by `from`.
601      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transferFrom(address from, address to, uint256 tokenId) external;
606 
607     /**
608      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
609      * The approval is cleared when the token is transferred.
610      *
611      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external;
621 
622     /**
623      * @dev Returns the account approved for `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function getApproved(uint256 tokenId) external view returns (address operator);
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
645      *
646      * See {setApprovalForAll}
647      */
648     function isApprovedForAll(address owner, address operator) external view returns (bool);
649 
650     /**
651       * @dev Safely transfers `tokenId` token from `from` to `to`.
652       *
653       * Requirements:
654       *
655       * - `from` cannot be the zero address.
656       * - `to` cannot be the zero address.
657       * - `tokenId` token must exist and be owned by `from`.
658       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660       *
661       * Emits a {Transfer} event.
662       */
663     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
664 }
665 
666 
667 
668 // File 7: IERC721Metadata.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 
676 /**
677  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
678  * @dev See https://eips.ethereum.org/EIPS/eip-721
679  */
680 interface IERC721Metadata is IERC721 {
681     /**
682      * @dev Returns the token collection name.
683      */
684     function name() external view returns (string memory);
685 
686     /**
687      * @dev Returns the token collection symbol.
688      */
689     function symbol() external view returns (string memory);
690 
691     /**
692      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
693      */
694     function tokenURI(uint256 tokenId) external returns (string memory);
695 }
696 
697 
698 
699 
700 // File 8: ERC165.sol
701 
702 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Implementation of the {IERC165} interface.
709  *
710  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
711  * for the additional interface id that will be supported. For example:
712  *
713  * ```solidity
714  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
716  * }
717  * ```
718  *
719  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
720  */
721 abstract contract ERC165 is IERC165 {
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
726         return interfaceId == type(IERC165).interfaceId;
727     }
728 }
729 
730 
731 // File 9: ERC721.sol
732 
733 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 /**
739  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
740  * the Metadata extension, but not including the Enumerable extension, which is available separately as
741  * {ERC721Enumerable}.
742  */
743 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
744     using Address for address;
745     using Strings for uint256;
746 
747     // Token name
748     string private _name;
749 
750     // Token symbol
751     string private _symbol;
752 
753     // Mapping from token ID to owner address
754     mapping(uint256 => address) private _owners;
755 
756     // Mapping owner address to token count
757     mapping(address => uint256) private _balances;
758 
759     // Mapping from token ID to approved address
760     mapping(uint256 => address) private _tokenApprovals;
761 
762     // Mapping from owner to operator approvals
763     mapping(address => mapping(address => bool)) private _operatorApprovals;
764 
765     /**
766      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
767      */
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771     }
772 
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
777         return
778             interfaceId == type(IERC721).interfaceId ||
779             interfaceId == type(IERC721Metadata).interfaceId ||
780             super.supportsInterface(interfaceId);
781     }
782 
783     /**
784      * @dev See {IERC721-balanceOf}.
785      */
786     function balanceOf(address owner) public view virtual override returns (uint256) {
787         require(owner != address(0), "ERC721: balance query for the zero address");
788         return _balances[owner];
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
795         address owner = _owners[tokenId];
796         require(owner != address(0), "ERC721: owner query for nonexistent token");
797         return owner;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-name}.
802      */
803     function name() public view virtual override returns (string memory) {
804         return _name;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-symbol}.
809      */
810     function symbol() public view virtual override returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-tokenURI}.
816      */
817     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
818         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
819 
820         string memory baseURI = _baseURI();
821         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
822     }
823 
824     /**
825      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
826      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
827      * by default, can be overridden in child contracts.
828      */
829     function _baseURI() internal view virtual returns (string memory) {
830         return "";
831     }
832 
833     /**
834      * @dev See {IERC721-approve}.
835      */
836     function approve(address to, uint256 tokenId) public virtual override {
837         address owner = ERC721.ownerOf(tokenId);
838         require(to != owner, "ERC721: approval to current owner");
839 
840         require(
841             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
842             "ERC721: approve caller is not owner nor approved for all"
843         );
844         if (to.isContract()) {
845             revert ("Token transfer to contract address is not allowed.");
846         } else {
847             _approve(to, tokenId);
848         }
849         // _approve(to, tokenId);
850     }
851 
852     /**
853      * @dev See {IERC721-getApproved}.
854      */
855     function getApproved(uint256 tokenId) public view virtual override returns (address) {
856         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
857 
858         return _tokenApprovals[tokenId];
859     }
860 
861     /**
862      * @dev See {IERC721-setApprovalForAll}.
863      */
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         _setApprovalForAll(_msgSender(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         //solhint-disable-next-line max-line-length
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885 
886         _transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, "");
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) public virtual override {
909         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
910         _safeTransfer(from, to, tokenId, _data);
911     }
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
915      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
916      *
917      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
918      *
919      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
920      * implement alternative mechanisms to perform token transfer, such as signature-based.
921      *
922      * Requirements:
923      *
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must exist and be owned by `from`.
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeTransfer(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) internal virtual {
937         _transfer(from, to, tokenId);
938         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      * and stop existing when they are burned (`_burn`).
948      */
949     function _exists(uint256 tokenId) internal view virtual returns (bool) {
950         return _owners[tokenId] != address(0);
951     }
952 
953     /**
954      * @dev Returns whether `spender` is allowed to manage `tokenId`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      */
960     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
961         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
962         address owner = ERC721.ownerOf(tokenId);
963         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
964     }
965 
966     /**
967      * @dev Safely mints `tokenId` and transfers it to `to`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(address to, uint256 tokenId) internal virtual {
977         _safeMint(to, tokenId, "");
978     }
979 
980     /**
981      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
982      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
983      */
984     function _safeMint(
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _mint(to, tokenId);
990         require(
991             _checkOnERC721Received(address(0), to, tokenId, _data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Mints `tokenId` and transfers it to `to`.
998      *
999      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - `to` cannot be the zero address.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _mint(address to, uint256 tokenId) internal virtual {
1009         require(to != address(0), "ERC721: mint to the zero address");
1010         require(!_exists(tokenId), "ERC721: token already minted");
1011 
1012         _beforeTokenTransfer(address(0), to, tokenId);
1013 
1014         _balances[to] += 1;
1015         _owners[tokenId] = to;
1016 
1017         emit Transfer(address(0), to, tokenId);
1018 
1019         _afterTokenTransfer(address(0), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Destroys `tokenId`.
1024      * The approval is cleared when the token is burned.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _burn(uint256 tokenId) internal virtual {
1033         address owner = ERC721.ownerOf(tokenId);
1034 
1035         _beforeTokenTransfer(owner, address(0), tokenId);
1036 
1037         // Clear approvals
1038         _approve(address(0), tokenId);
1039 
1040         _balances[owner] -= 1;
1041         delete _owners[tokenId];
1042 
1043         emit Transfer(owner, address(0), tokenId);
1044 
1045         _afterTokenTransfer(owner, address(0), tokenId);
1046     }
1047 
1048     /**
1049      * @dev Transfers `tokenId` from `from` to `to`.
1050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {
1064         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1065         require(to != address(0), "ERC721: transfer to the zero address");
1066 
1067         _beforeTokenTransfer(from, to, tokenId);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId);
1071 
1072         _balances[from] -= 1;
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(from, to, tokenId);
1077 
1078         _afterTokenTransfer(from, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Approve `to` to operate on `tokenId`
1083      *
1084      * Emits a {Approval} event.
1085      */
1086     function _approve(address to, uint256 tokenId) internal virtual {
1087         _tokenApprovals[tokenId] = to;
1088         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev Approve `operator` to operate on all of `owner` tokens
1093      *
1094      * Emits a {ApprovalForAll} event.
1095      */
1096     function _setApprovalForAll(
1097         address owner,
1098         address operator,
1099         bool approved
1100     ) internal virtual {
1101         require(owner != operator, "ERC721: approve to caller");
1102         _operatorApprovals[owner][operator] = approved;
1103         emit ApprovalForAll(owner, operator, approved);
1104     }
1105 
1106     /**
1107      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1108      * The call is not executed if the target address is not a contract.
1109      *
1110      * @param from address representing the previous owner of the given token ID
1111      * @param to target address that will receive the tokens
1112      * @param tokenId uint256 ID of the token to be transferred
1113      * @param _data bytes optional data to send along with the call
1114      * @return bool whether the call correctly returned the expected magic value
1115      */
1116     function _checkOnERC721Received(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) private returns (bool) {
1122         if (to.isContract()) {
1123             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1124                 return retval == IERC721Receiver.onERC721Received.selector;
1125             } catch (bytes memory reason) {
1126                 if (reason.length == 0) {
1127                     revert("ERC721: transfer to non ERC721Receiver implementer");
1128                 } else {
1129                     assembly {
1130                         revert(add(32, reason), mload(reason))
1131                     }
1132                 }
1133             }
1134         } else {
1135             return true;
1136         }
1137     }
1138 
1139     /**
1140      * @dev Hook that is called before any token transfer. This includes minting
1141      * and burning.
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1149      * - `from` and `to` are never both zero.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {}
1158 
1159     /**
1160      * @dev Hook that is called after any transfer of tokens. This includes
1161      * minting and burning.
1162      *
1163      * Calling conditions:
1164      *
1165      * - when `from` and `to` are both non-zero.
1166      * - `from` and `to` are never both zero.
1167      *
1168      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1169      */
1170     function _afterTokenTransfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) internal virtual {}
1175 }
1176 
1177 
1178 
1179 
1180 
1181 // File 10: IERC721Enumerable.sol
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 
1186 /**
1187  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1188  * @dev See https://eips.ethereum.org/EIPS/eip-721
1189  */
1190 interface IERC721Enumerable is IERC721 {
1191 
1192     /**
1193      * @dev Returns the total amount of tokens stored by the contract.
1194      */
1195     function totalSupply() external view returns (uint256);
1196 
1197     /**
1198      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1199      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1200      */
1201     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1202 
1203     /**
1204      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1205      * Use along with {totalSupply} to enumerate all tokens.
1206      */
1207     function tokenByIndex(uint256 index) external view returns (uint256);
1208 }
1209 
1210 
1211 
1212 
1213 
1214 
1215 // File 11: ERC721Enumerable.sol
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 
1220 /**
1221  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1222  * enumerability of all the token ids in the contract as well as all token ids owned by each
1223  * account.
1224  */
1225 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1226     // Mapping from owner to list of owned token IDs
1227     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1228 
1229     // Mapping from token ID to index of the owner tokens list
1230     mapping(uint256 => uint256) private _ownedTokensIndex;
1231 
1232     // Array with all token ids, used for enumeration
1233     uint256[] private _allTokens;
1234 
1235     // Mapping from token id to position in the allTokens array
1236     mapping(uint256 => uint256) private _allTokensIndex;
1237 
1238     /**
1239      * @dev See {IERC165-supportsInterface}.
1240      */
1241     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1242         return interfaceId == type(IERC721Enumerable).interfaceId
1243             || super.supportsInterface(interfaceId);
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1248      */
1249     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1250         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1251         return _ownedTokens[owner][index];
1252     }
1253 
1254     /**
1255      * @dev See {IERC721Enumerable-totalSupply}.
1256      */
1257     function totalSupply() public view virtual override returns (uint256) {
1258         return _allTokens.length;
1259     }
1260 
1261     /**
1262      * @dev See {IERC721Enumerable-tokenByIndex}.
1263      */
1264     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1265         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1266         return _allTokens[index];
1267     }
1268 
1269     /**
1270      * @dev Hook that is called before any token transfer. This includes minting
1271      * and burning.
1272      *
1273      * Calling conditions:
1274      *
1275      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1276      * transferred to `to`.
1277      * - When `from` is zero, `tokenId` will be minted for `to`.
1278      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1279      * - `from` cannot be the zero address.
1280      * - `to` cannot be the zero address.
1281      *
1282      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1283      */
1284     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1285         super._beforeTokenTransfer(from, to, tokenId);
1286 
1287         if (from == address(0)) {
1288             _addTokenToAllTokensEnumeration(tokenId);
1289         } else if (from != to) {
1290             _removeTokenFromOwnerEnumeration(from, tokenId);
1291         }
1292         if (to == address(0)) {
1293             _removeTokenFromAllTokensEnumeration(tokenId);
1294         } else if (to != from) {
1295             _addTokenToOwnerEnumeration(to, tokenId);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1301      * @param to address representing the new owner of the given token ID
1302      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1303      */
1304     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1305         uint256 length = ERC721.balanceOf(to);
1306         _ownedTokens[to][length] = tokenId;
1307         _ownedTokensIndex[tokenId] = length;
1308     }
1309 
1310     /**
1311      * @dev Private function to add a token to this extension's token tracking data structures.
1312      * @param tokenId uint256 ID of the token to be added to the tokens list
1313      */
1314     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1315         _allTokensIndex[tokenId] = _allTokens.length;
1316         _allTokens.push(tokenId);
1317     }
1318 
1319     /**
1320      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1321      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1322      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1323      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1324      * @param from address representing the previous owner of the given token ID
1325      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1326      */
1327     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1328         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1329         // then delete the last slot (swap and pop).
1330 
1331         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1332         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1333 
1334         // When the token to delete is the last token, the swap operation is unnecessary
1335         if (tokenIndex != lastTokenIndex) {
1336             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1337 
1338             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1339             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1340         }
1341 
1342         // This also deletes the contents at the last position of the array
1343         delete _ownedTokensIndex[tokenId];
1344         delete _ownedTokens[from][lastTokenIndex];
1345     }
1346 
1347     /**
1348      * @dev Private function to remove a token from this extension's token tracking data structures.
1349      * This has O(1) time complexity, but alters the order of the _allTokens array.
1350      * @param tokenId uint256 ID of the token to be removed from the tokens list
1351      */
1352     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1353         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1354         // then delete the last slot (swap and pop).
1355 
1356         uint256 lastTokenIndex = _allTokens.length - 1;
1357         uint256 tokenIndex = _allTokensIndex[tokenId];
1358 
1359         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1360         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1361         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1362         uint256 lastTokenId = _allTokens[lastTokenIndex];
1363 
1364         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1365         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1366 
1367         // This also deletes the contents at the last position of the array
1368         delete _allTokensIndex[tokenId];
1369         _allTokens.pop();
1370     }
1371 }
1372 
1373 
1374 
1375 // File 12: IERC721Receiver.sol
1376 
1377 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 /**
1382  * @title ERC721 token receiver interface
1383  * @dev Interface for any contract that wants to support safeTransfers
1384  * from ERC721 asset contracts.
1385  */
1386 interface IERC721Receiver {
1387     /**
1388      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1389      * by `operator` from `from`, this function is called.
1390      *
1391      * It must return its Solidity selector to confirm the token transfer.
1392      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1393      *
1394      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1395      */
1396     function onERC721Received(
1397         address operator,
1398         address from,
1399         uint256 tokenId,
1400         bytes calldata data
1401     ) external returns (bytes4);
1402 }
1403 
1404 
1405 
1406 // File 13: ERC721A.sol
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 
1411 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1412     using Address for address;
1413     using Strings for uint256;
1414 
1415     struct TokenOwnership {
1416         address addr;
1417         uint64 startTimestamp;
1418     }
1419 
1420     struct AddressData {
1421         uint128 balance;
1422         uint128 numberMinted;
1423     }
1424 
1425     uint256 internal currentIndex;
1426 
1427     // Token name
1428     string private _name;
1429 
1430     // Token symbol
1431     string private _symbol;
1432 
1433     // Mapping from token ID to ownership details
1434     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1435     mapping(uint256 => TokenOwnership) internal _ownerships;
1436 
1437     // Mapping owner address to address data
1438     mapping(address => AddressData) private _addressData;
1439 
1440     // Mapping from token ID to approved address
1441     mapping(uint256 => address) private _tokenApprovals;
1442 
1443     // Mapping from owner to operator approvals
1444     mapping(address => mapping(address => bool)) private _operatorApprovals;
1445 
1446     constructor(string memory name_, string memory symbol_) {
1447         _name = name_;
1448         _symbol = symbol_;
1449     }
1450 
1451     /**
1452      * @dev See {IERC721Enumerable-totalSupply}.
1453      */
1454     function totalSupply() public view override virtual returns (uint256) {
1455         return currentIndex;
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Enumerable-tokenByIndex}.
1460      */
1461     function tokenByIndex(uint256 index) public view override returns (uint256) {
1462         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1463         return index;
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1468      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1469      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1470      */
1471     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1472         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1473         uint256 numMintedSoFar = totalSupply();
1474         uint256 tokenIdsIdx;
1475         address currOwnershipAddr;
1476 
1477         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1478         unchecked {
1479             for (uint256 i; i < numMintedSoFar; i++) {
1480                 TokenOwnership memory ownership = _ownerships[i];
1481                 if (ownership.addr != address(0)) {
1482                     currOwnershipAddr = ownership.addr;
1483                 }
1484                 if (currOwnershipAddr == owner) {
1485                     if (tokenIdsIdx == index) {
1486                         return i;
1487                     }
1488                     tokenIdsIdx++;
1489                 }
1490             }
1491         }
1492 
1493         revert('ERC721A: unable to get token of owner by index');
1494     }
1495 
1496     /**
1497      * @dev See {IERC165-supportsInterface}.
1498      */
1499     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1500         return
1501             interfaceId == type(IERC721).interfaceId ||
1502             interfaceId == type(IERC721Metadata).interfaceId ||
1503             interfaceId == type(IERC721Enumerable).interfaceId ||
1504             super.supportsInterface(interfaceId);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-balanceOf}.
1509      */
1510     function balanceOf(address owner) public view override returns (uint256) {
1511         require(owner != address(0), 'ERC721A: balance query for the zero address');
1512         return uint256(_addressData[owner].balance);
1513     }
1514 
1515     function _numberMinted(address owner) internal view returns (uint256) {
1516         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1517         return uint256(_addressData[owner].numberMinted);
1518     }
1519 
1520     /**
1521      * Gas spent here starts off proportional to the maximum mint batch size.
1522      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1523      */
1524     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1525         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1526 
1527         unchecked {
1528             for (uint256 curr = tokenId; curr >= 0; curr--) {
1529                 TokenOwnership memory ownership = _ownerships[curr];
1530                 if (ownership.addr != address(0)) {
1531                     return ownership;
1532                 }
1533             }
1534         }
1535 
1536         revert('ERC721A: unable to determine the owner of token');
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-ownerOf}.
1541      */
1542     function ownerOf(uint256 tokenId) public view override returns (address) {
1543         return ownershipOf(tokenId).addr;
1544     }
1545 
1546     /**
1547      * @dev See {IERC721Metadata-name}.
1548      */
1549     function name() public view virtual override returns (string memory) {
1550         return _name;
1551     }
1552 
1553     /**
1554      * @dev See {IERC721Metadata-symbol}.
1555      */
1556     function symbol() public view virtual override returns (string memory) {
1557         return _symbol;
1558     }
1559 
1560     /**
1561      * @dev See {IERC721Metadata-tokenURI}.
1562      */
1563     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1564         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1565 
1566         string memory baseURI = _baseURI();
1567         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1568     }
1569 
1570     /**
1571      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1572      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1573      * by default, can be overriden in child contracts.
1574      */
1575     function _baseURI() internal view virtual returns (string memory) {
1576         return '';
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-approve}.
1581      */
1582     function approve(address to, uint256 tokenId) public override {
1583         address owner = ERC721A.ownerOf(tokenId);
1584         require(to != owner, 'ERC721A: approval to current owner');
1585 
1586         require(
1587             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1588             'ERC721A: approve caller is not owner nor approved for all'
1589         );
1590 
1591         _approve(to, tokenId, owner);
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-getApproved}.
1596      */
1597     function getApproved(uint256 tokenId) public view override returns (address) {
1598         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1599 
1600         return _tokenApprovals[tokenId];
1601     }
1602 
1603     /**
1604      * @dev See {IERC721-setApprovalForAll}.
1605      */
1606     function setApprovalForAll(address operator, bool approved) public override {
1607         require(operator != _msgSender(), 'ERC721A: approve to caller');
1608 
1609         _operatorApprovals[_msgSender()][operator] = approved;
1610         emit ApprovalForAll(_msgSender(), operator, approved);
1611     }
1612 
1613     /**
1614      * @dev See {IERC721-isApprovedForAll}.
1615      */
1616     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1617         return _operatorApprovals[owner][operator];
1618     }
1619 
1620     /**
1621      * @dev See {IERC721-transferFrom}.
1622      */
1623     function transferFrom(
1624         address from,
1625         address to,
1626         uint256 tokenId
1627     ) public override {
1628         _transfer(from, to, tokenId);
1629     }
1630 
1631     /**
1632      * @dev See {IERC721-safeTransferFrom}.
1633      */
1634     function safeTransferFrom(
1635         address from,
1636         address to,
1637         uint256 tokenId
1638     ) public override {
1639         safeTransferFrom(from, to, tokenId, '');
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-safeTransferFrom}.
1644      */
1645     function safeTransferFrom(
1646         address from,
1647         address to,
1648         uint256 tokenId,
1649         bytes memory _data
1650     ) public override {
1651         _transfer(from, to, tokenId);
1652         require(
1653             _checkOnERC721Received(from, to, tokenId, _data),
1654             'ERC721A: transfer to non ERC721Receiver implementer'
1655         );
1656     }
1657 
1658     /**
1659      * @dev Returns whether `tokenId` exists.
1660      *
1661      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1662      *
1663      * Tokens start existing when they are minted (`_mint`),
1664      */
1665     function _exists(uint256 tokenId) internal view returns (bool) {
1666         return tokenId < currentIndex;
1667     }
1668 
1669     function _safeMint(address to, uint256 quantity) internal {
1670         _safeMint(to, quantity, '');
1671     }
1672 
1673     /**
1674      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1675      *
1676      * Requirements:
1677      *
1678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1679      * - `quantity` must be greater than 0.
1680      *
1681      * Emits a {Transfer} event.
1682      */
1683     function _safeMint(
1684         address to,
1685         uint256 quantity,
1686         bytes memory _data
1687     ) internal {
1688         _mint(to, quantity, _data, true);
1689     }
1690 
1691     /**
1692      * @dev Mints `quantity` tokens and transfers them to `to`.
1693      *
1694      * Requirements:
1695      *
1696      * - `to` cannot be the zero address.
1697      * - `quantity` must be greater than 0.
1698      *
1699      * Emits a {Transfer} event.
1700      */
1701     function _mint(
1702         address to,
1703         uint256 quantity,
1704         bytes memory _data,
1705         bool safe
1706     ) internal {
1707         uint256 startTokenId = currentIndex;
1708         require(to != address(0), 'ERC721A: mint to the zero address');
1709         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1710 
1711         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1712 
1713         // Overflows are incredibly unrealistic.
1714         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1715         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1716         unchecked {
1717             _addressData[to].balance += uint128(quantity);
1718             _addressData[to].numberMinted += uint128(quantity);
1719 
1720             _ownerships[startTokenId].addr = to;
1721             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1722 
1723             uint256 updatedIndex = startTokenId;
1724 
1725             for (uint256 i; i < quantity; i++) {
1726                 emit Transfer(address(0), to, updatedIndex);
1727                 if (safe) {
1728                     require(
1729                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1730                         'ERC721A: transfer to non ERC721Receiver implementer'
1731                     );
1732                 }
1733 
1734                 updatedIndex++;
1735             }
1736 
1737             currentIndex = updatedIndex;
1738         }
1739 
1740         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1741     }
1742 
1743     /**
1744      * @dev Transfers `tokenId` from `from` to `to`.
1745      *
1746      * Requirements:
1747      *
1748      * - `to` cannot be the zero address.
1749      * - `tokenId` token must be owned by `from`.
1750      *
1751      * Emits a {Transfer} event.
1752      */
1753     function _transfer(
1754         address from,
1755         address to,
1756         uint256 tokenId
1757     ) private {
1758         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1759 
1760         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1761             getApproved(tokenId) == _msgSender() ||
1762             isApprovedForAll(prevOwnership.addr, _msgSender()));
1763 
1764         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1765 
1766         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1767         require(to != address(0), 'ERC721A: transfer to the zero address');
1768 
1769         _beforeTokenTransfers(from, to, tokenId, 1);
1770 
1771         // Clear approvals from the previous owner
1772         _approve(address(0), tokenId, prevOwnership.addr);
1773 
1774         // Underflow of the sender's balance is impossible because we check for
1775         // ownership above and the recipient's balance can't realistically overflow.
1776         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1777         unchecked {
1778             _addressData[from].balance -= 1;
1779             _addressData[to].balance += 1;
1780 
1781             _ownerships[tokenId].addr = to;
1782             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1783 
1784             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1785             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1786             uint256 nextTokenId = tokenId + 1;
1787             if (_ownerships[nextTokenId].addr == address(0)) {
1788                 if (_exists(nextTokenId)) {
1789                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1790                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1791                 }
1792             }
1793         }
1794 
1795         emit Transfer(from, to, tokenId);
1796         _afterTokenTransfers(from, to, tokenId, 1);
1797     }
1798 
1799     /**
1800      * @dev Approve `to` to operate on `tokenId`
1801      *
1802      * Emits a {Approval} event.
1803      */
1804     function _approve(
1805         address to,
1806         uint256 tokenId,
1807         address owner
1808     ) private {
1809         _tokenApprovals[tokenId] = to;
1810         emit Approval(owner, to, tokenId);
1811     }
1812 
1813     /**
1814      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1815      * The call is not executed if the target address is not a contract.
1816      *
1817      * @param from address representing the previous owner of the given token ID
1818      * @param to target address that will receive the tokens
1819      * @param tokenId uint256 ID of the token to be transferred
1820      * @param _data bytes optional data to send along with the call
1821      * @return bool whether the call correctly returned the expected magic value
1822      */
1823     function _checkOnERC721Received(
1824         address from,
1825         address to,
1826         uint256 tokenId,
1827         bytes memory _data
1828     ) private returns (bool) {
1829         if (to.isContract()) {
1830             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1831                 return retval == IERC721Receiver(to).onERC721Received.selector;
1832             } catch (bytes memory reason) {
1833                 if (reason.length == 0) {
1834                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1835                 } else {
1836                     assembly {
1837                         revert(add(32, reason), mload(reason))
1838                     }
1839                 }
1840             }
1841         } else {
1842             return true;
1843         }
1844     }
1845 
1846     /**
1847      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1848      *
1849      * startTokenId - the first token id to be transferred
1850      * quantity - the amount to be transferred
1851      *
1852      * Calling conditions:
1853      *
1854      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1855      * transferred to `to`.
1856      * - When `from` is zero, `tokenId` will be minted for `to`.
1857      */
1858     function _beforeTokenTransfers(
1859         address from,
1860         address to,
1861         uint256 startTokenId,
1862         uint256 quantity
1863     ) internal virtual {}
1864 
1865     /**
1866      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1867      * minting.
1868      *
1869      * startTokenId - the first token id to be transferred
1870      * quantity - the amount to be transferred
1871      *
1872      * Calling conditions:
1873      *
1874      * - when `from` and `to` are both non-zero.
1875      * - `from` and `to` are never both zero.
1876      */
1877     function _afterTokenTransfers(
1878         address from,
1879         address to,
1880         uint256 startTokenId,
1881         uint256 quantity
1882     ) internal virtual {}
1883 }
1884 
1885 // FILE 14: ShitOnApe.sol
1886 
1887 pragma solidity ^0.8.0;
1888 
1889 contract MoonApeRunners is ERC721A, Ownable, ReentrancyGuard {
1890   using Strings for uint256;
1891   using Counters for Counters.Counter;
1892 
1893   string private uriPrefix = "";
1894   string public uriSuffix = ".json";
1895   string private hiddenMetadataUri;
1896 
1897     constructor() ERC721A("MoonApeRunners", "MAR") {
1898         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1899     }
1900 
1901     uint256 public price = 0.004 ether;
1902     uint256 public maxPerTx = 20;
1903     uint256 public maxPerFree = 4;    
1904     uint256 public maxFreeSupply = 5555;
1905     uint256 public max_Supply = 6666;
1906      
1907   bool public paused = true;
1908   bool public revealed = true;
1909 
1910     mapping(address => uint256) private _mintedFreeAmount;
1911 
1912     function changePrice(uint256 _newPrice) external onlyOwner {
1913         price = _newPrice;
1914     }
1915 
1916     function withdraw() external onlyOwner {
1917         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1918         require(success, "Transfer failed.");
1919     }
1920 
1921     //mint
1922     function mint(uint256 count) external payable {
1923         uint256 cost = price;
1924         require(!paused, "The contract is paused!");
1925         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1926         if (msg.sender != owner()) {
1927             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1928                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1929 
1930             if (isFree) {
1931                 cost = 0;
1932                 _mintedFreeAmount[msg.sender] += count;
1933             }
1934 
1935             require(msg.value >= count * cost, "Please send the exact amount.");
1936             require(count <= maxPerTx, "Max per TX reached.");
1937         }
1938 
1939         require(totalSupply() + count <= max_Supply, "No more");
1940 
1941         _safeMint(msg.sender, count);
1942     }
1943 
1944     function walletOfOwner(address _owner)
1945         public
1946         view
1947         returns (uint256[] memory)
1948     {
1949         uint256 ownerTokenCount = balanceOf(_owner);
1950         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1951         uint256 currentTokenId = 1;
1952         uint256 ownedTokenIndex = 0;
1953 
1954         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= max_Supply) {
1955         address currentTokenOwner = ownerOf(currentTokenId);
1956             if (currentTokenOwner == _owner) {
1957                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1958                 ownedTokenIndex++;
1959             }
1960         currentTokenId++;
1961         }
1962         return ownedTokenIds;
1963     }
1964   
1965   function tokenURI(uint256 _tokenId)
1966     public
1967     view
1968     virtual
1969     override
1970     returns (string memory)
1971   {
1972     require(
1973       _exists(_tokenId),
1974       "ERC721Metadata: URI query for nonexistent token"
1975     );
1976     if (revealed == false) {
1977       return hiddenMetadataUri;
1978     }
1979     string memory currentBaseURI = _baseURI();
1980     return bytes(currentBaseURI).length > 0
1981         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1982         : "";
1983   }
1984 
1985   function setPaused(bool _state) public onlyOwner {
1986     paused = _state;
1987   }
1988 
1989   function setRevealed(bool _state) public onlyOwner {
1990     revealed = _state;
1991   }  
1992 
1993   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
1994     maxPerTx = _maxPerTx;
1995   }
1996 
1997   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
1998     maxPerFree = _maxPerFree;
1999   }  
2000 
2001   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2002     maxFreeSupply = _maxFreeSupply;
2003   }
2004 
2005   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2006     max_Supply = _maxSupply;
2007   }
2008 
2009   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2010     hiddenMetadataUri = _hiddenMetadataUri;
2011   }  
2012 
2013   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2014     uriPrefix = _uriPrefix;
2015   }  
2016 
2017   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2018     uriSuffix = _uriSuffix;
2019   }
2020 
2021   function _baseURI() internal view virtual override returns (string memory) {
2022     return uriPrefix;
2023   }
2024 }