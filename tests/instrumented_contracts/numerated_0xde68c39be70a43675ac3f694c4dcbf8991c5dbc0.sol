1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-27
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-23
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File 1: Address.sol
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
14 
15 pragma solidity ^0.8.1;
16 
17 /**
18  * @dev Collection of functions related to the address type
19  */
20 library Address {
21     /**
22      * @dev Returns true if `account` is a contract.
23      *
24      * [IMPORTANT]
25      * ====
26      * It is unsafe to assume that an address for which this function returns
27      * false is an externally-owned account (EOA) and not a contract.
28      *
29      * Among others, `isContract` will return false for the following
30      * types of addresses:
31      *
32      *  - an externally-owned account
33      *  - a contract in construction
34      *  - an address where a contract will be created
35      *  - an address where a contract lived, but was destroyed
36      * ====
37      *
38      * [IMPORTANT]
39      * ====
40      * You shouldn't rely on `isContract` to protect against flash loan attacks!
41      *
42      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
43      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
44      * constructor.
45      * ====
46      */
47     function isContract(address account) internal view returns (bool) {
48         // This method relies on extcodesize/address.code.length, which returns 0
49         // for contracts in construction, since the code is only stored at the end
50         // of the constructor execution.
51 
52         return account.code.length > 0;
53     }
54 
55     /**
56      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
57      * `recipient`, forwarding all available gas and reverting on errors.
58      *
59      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
60      * of certain opcodes, possibly making contracts go over the 2300 gas limit
61      * imposed by `transfer`, making them unable to receive funds via
62      * `transfer`. {sendValue} removes this limitation.
63      *
64      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
65      *
66      * IMPORTANT: because control is transferred to `recipient`, care must be
67      * taken to not create reentrancy vulnerabilities. Consider using
68      * {ReentrancyGuard} or the
69      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
70      */
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73 
74         (bool success, ) = recipient.call{value: amount}("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 
78     /**
79      * @dev Performs a Solidity function call using a low level `call`. A
80      * plain `call` is an unsafe replacement for a function call: use this
81      * function instead.
82      *
83      * If `target` reverts with a revert reason, it is bubbled up by this
84      * function (like regular Solidity function calls).
85      *
86      * Returns the raw returned data. To convert to the expected return value,
87      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
88      *
89      * Requirements:
90      *
91      * - `target` must be a contract.
92      * - calling `target` with `data` must not revert.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
97         return functionCall(target, data, "Address: low-level call failed");
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
102      * `errorMessage` as a fallback revert reason when `target` reverts.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(
107         address target,
108         bytes memory data,
109         string memory errorMessage
110     ) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
116      * but also transferring `value` wei to `target`.
117      *
118      * Requirements:
119      *
120      * - the calling contract must have an ETH balance of at least `value`.
121      * - the called Solidity function must be `payable`.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value
129     ) internal returns (bytes memory) {
130         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
135      * with `errorMessage` as a fallback revert reason when `target` reverts.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(
140         address target,
141         bytes memory data,
142         uint256 value,
143         string memory errorMessage
144     ) internal returns (bytes memory) {
145         require(address(this).balance >= value, "Address: insufficient balance for call");
146         require(isContract(target), "Address: call to non-contract");
147 
148         (bool success, bytes memory returndata) = target.call{value: value}(data);
149         return verifyCallResult(success, returndata, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal view returns (bytes memory) {
173         require(isContract(target), "Address: static call to non-contract");
174 
175         (bool success, bytes memory returndata) = target.staticcall(data);
176         return verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but performing a delegate call.
182      *
183      * _Available since v3.4._
184      */
185     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(isContract(target), "Address: delegate call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.delegatecall(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
208      * revert reason using the provided one.
209      *
210      * _Available since v4.3._
211      */
212     function verifyCallResult(
213         bool success,
214         bytes memory returndata,
215         string memory errorMessage
216     ) internal pure returns (bytes memory) {
217         if (success) {
218             return returndata;
219         } else {
220             // Look for revert reason and bubble it up if present
221             if (returndata.length > 0) {
222                 // The easiest way to bubble the revert reason is using memory via assembly
223 
224                 assembly {
225                     let returndata_size := mload(returndata)
226                     revert(add(32, returndata), returndata_size)
227                 }
228             } else {
229                 revert(errorMessage);
230             }
231         }
232     }
233 }
234 
235 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Contract module that helps prevent reentrant calls to a function.
244  *
245  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
246  * available, which can be applied to functions to make sure there are no nested
247  * (reentrant) calls to them.
248  *
249  * Note that because there is a single `nonReentrant` guard, functions marked as
250  * `nonReentrant` may not call one another. This can be worked around by making
251  * those functions `private`, and then adding `external` `nonReentrant` entry
252  * points to them.
253  *
254  * TIP: If you would like to learn more about reentrancy and alternative ways
255  * to protect against it, check out our blog post
256  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
257  */
258 abstract contract ReentrancyGuard {
259     // Booleans are more expensive than uint256 or any type that takes up a full
260     // word because each write operation emits an extra SLOAD to first read the
261     // slot's contents, replace the bits taken up by the boolean, and then write
262     // back. This is the compiler's defense against contract upgrades and
263     // pointer aliasing, and it cannot be disabled.
264 
265     // The values being non-zero value makes deployment a bit more expensive,
266     // but in exchange the refund on every call to nonReentrant will be lower in
267     // amount. Since refunds are capped to a percentage of the total
268     // transaction's gas, it is best to keep them low in cases like this one, to
269     // increase the likelihood of the full refund coming into effect.
270     uint256 private constant _NOT_ENTERED = 1;
271     uint256 private constant _ENTERED = 2;
272 
273     uint256 private _status;
274 
275     constructor() {
276         _status = _NOT_ENTERED;
277     }
278 
279     /**
280      * @dev Prevents a contract from calling itself, directly or indirectly.
281      * Calling a `nonReentrant` function from another `nonReentrant`
282      * function is not supported. It is possible to prevent this from happening
283      * by making the `nonReentrant` function external, and making it call a
284      * `private` function that does the actual work.
285      */
286     modifier nonReentrant() {
287         // On the first call to nonReentrant, _notEntered will be true
288         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
289 
290         // Any calls to nonReentrant after this point will fail
291         _status = _ENTERED;
292 
293         _;
294 
295         // By storing the original value once again, a refund is triggered (see
296         // https://eips.ethereum.org/EIPS/eip-2200)
297         _status = _NOT_ENTERED;
298     }
299 }
300 
301 // FILE 2: Context.sol
302 pragma solidity ^0.8.0;
303 
304 /*
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view virtual returns (bytes calldata) {
320         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
321         return msg.data;
322     }
323 }
324 
325 // File 3: Strings.sol
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev String operations.
333  */
334 library Strings {
335     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
336 
337     /**
338      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
339      */
340     function toString(uint256 value) internal pure returns (string memory) {
341         // Inspired by OraclizeAPI's implementation - MIT licence
342         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
343 
344         if (value == 0) {
345             return "0";
346         }
347         uint256 temp = value;
348         uint256 digits;
349         while (temp != 0) {
350             digits++;
351             temp /= 10;
352         }
353         bytes memory buffer = new bytes(digits);
354         while (value != 0) {
355             digits -= 1;
356             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
357             value /= 10;
358         }
359         return string(buffer);
360     }
361 
362     /**
363      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
364      */
365     function toHexString(uint256 value) internal pure returns (string memory) {
366         if (value == 0) {
367             return "0x00";
368         }
369         uint256 temp = value;
370         uint256 length = 0;
371         while (temp != 0) {
372             length++;
373             temp >>= 8;
374         }
375         return toHexString(value, length);
376     }
377 
378     /**
379      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
380      */
381     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
382         bytes memory buffer = new bytes(2 * length + 2);
383         buffer[0] = "0";
384         buffer[1] = "x";
385         for (uint256 i = 2 * length + 1; i > 1; --i) {
386             buffer[i] = _HEX_SYMBOLS[value & 0xf];
387             value >>= 4;
388         }
389         require(value == 0, "Strings: hex length insufficient");
390         return string(buffer);
391     }
392 }
393 
394 
395 // File: @openzeppelin/contracts/utils/Counters.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @title Counters
404  * @author Matt Condon (@shrugs)
405  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
406  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
407  *
408  * Include with `using Counters for Counters.Counter;`
409  */
410 library Counters {
411     struct Counter {
412         // This variable should never be directly accessed by users of the library: interactions must be restricted to
413         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
414         // this feature: see https://github.com/ethereum/solidity/issues/4637
415         uint256 _value; // default: 0
416     }
417 
418     function current(Counter storage counter) internal view returns (uint256) {
419         return counter._value;
420     }
421 
422     function increment(Counter storage counter) internal {
423         unchecked {
424             counter._value += 1;
425         }
426     }
427 
428     function decrement(Counter storage counter) internal {
429         uint256 value = counter._value;
430         require(value > 0, "Counter: decrement overflow");
431         unchecked {
432             counter._value = value - 1;
433         }
434     }
435 
436     function reset(Counter storage counter) internal {
437         counter._value = 0;
438     }
439 }
440 
441 // File 4: Ownable.sol
442 
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Contract module which provides a basic access control mechanism, where
449  * there is an account (an owner) that can be granted exclusive access to
450  * specific functions.
451  *
452  * By default, the owner account will be the one that deploys the contract. This
453  * can later be changed with {transferOwnership}.
454  *
455  * This module is used through inheritance. It will make available the modifier
456  * `onlyOwner`, which can be applied to your functions to restrict their use to
457  * the owner.
458  */
459 abstract contract Ownable is Context {
460     address private _owner;
461 
462     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
463 
464     /**
465      * @dev Initializes the contract setting the deployer as the initial owner.
466      */
467     constructor () {
468         address msgSender = _msgSender();
469         _owner = msgSender;
470         emit OwnershipTransferred(address(0), msgSender);
471     }
472 
473     /**
474      * @dev Returns the address of the current owner.
475      */
476     function owner() public view virtual returns (address) {
477         return _owner;
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         require(owner() == _msgSender(), "Ownable: caller is not the owner");
485         _;
486     }
487 
488     /**
489      * @dev Leaves the contract without owner. It will not be possible to call
490      * `onlyOwner` functions anymore. Can only be called by the current owner.
491      *
492      * NOTE: Renouncing ownership will leave the contract without an owner,
493      * thereby removing any functionality that is only available to the owner.
494      */
495     function renounceOwnership() public virtual onlyOwner {
496         emit OwnershipTransferred(_owner, address(0));
497         _owner = address(0);
498     }
499 
500     /**
501      * @dev Transfers ownership of the contract to a new account (`newOwner`).
502      * Can only be called by the current owner.
503      */
504     function transferOwnership(address newOwner) public virtual onlyOwner {
505         require(newOwner != address(0), "Ownable: new owner is the zero address");
506         emit OwnershipTransferred(_owner, newOwner);
507         _owner = newOwner;
508     }
509 }
510 
511 
512 
513 
514 
515 // File 5: IERC165.sol
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Interface of the ERC165 standard, as defined in the
521  * https://eips.ethereum.org/EIPS/eip-165[EIP].
522  *
523  * Implementers can declare support of contract interfaces, which can then be
524  * queried by others ({ERC165Checker}).
525  *
526  * For an implementation, see {ERC165}.
527  */
528 interface IERC165 {
529     /**
530      * @dev Returns true if this contract implements the interface defined by
531      * `interfaceId`. See the corresponding
532      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
533      * to learn more about how these ids are created.
534      *
535      * This function call must use less than 30 000 gas.
536      */
537     function supportsInterface(bytes4 interfaceId) external view returns (bool);
538 }
539 
540 
541 // File 6: IERC721.sol
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev Required interface of an ERC721 compliant contract.
548  */
549 interface IERC721 is IERC165 {
550     /**
551      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
552      */
553     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
557      */
558     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
562      */
563     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
564 
565     /**
566      * @dev Returns the number of tokens in ``owner``'s account.
567      */
568     function balanceOf(address owner) external view returns (uint256 balance);
569 
570     /**
571      * @dev Returns the owner of the `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function ownerOf(uint256 tokenId) external view returns (address owner);
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
581      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must exist and be owned by `from`.
588      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
589      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
590      *
591      * Emits a {Transfer} event.
592      */
593     function safeTransferFrom(address from, address to, uint256 tokenId) external;
594 
595     /**
596      * @dev Transfers `tokenId` token from `from` to `to`.
597      *
598      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transferFrom(address from, address to, uint256 tokenId) external;
610 
611     /**
612      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
613      * The approval is cleared when the token is transferred.
614      *
615      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
616      *
617      * Requirements:
618      *
619      * - The caller must own the token or be an approved operator.
620      * - `tokenId` must exist.
621      *
622      * Emits an {Approval} event.
623      */
624     function approve(address to, uint256 tokenId) external;
625 
626     /**
627      * @dev Returns the account approved for `tokenId` token.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function getApproved(uint256 tokenId) external view returns (address operator);
634 
635     /**
636      * @dev Approve or remove `operator` as an operator for the caller.
637      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
638      *
639      * Requirements:
640      *
641      * - The `operator` cannot be the caller.
642      *
643      * Emits an {ApprovalForAll} event.
644      */
645     function setApprovalForAll(address operator, bool _approved) external;
646 
647     /**
648      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
649      *
650      * See {setApprovalForAll}
651      */
652     function isApprovedForAll(address owner, address operator) external view returns (bool);
653 
654     /**
655       * @dev Safely transfers `tokenId` token from `from` to `to`.
656       *
657       * Requirements:
658       *
659       * - `from` cannot be the zero address.
660       * - `to` cannot be the zero address.
661       * - `tokenId` token must exist and be owned by `from`.
662       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
663       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
664       *
665       * Emits a {Transfer} event.
666       */
667     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
668 }
669 
670 
671 
672 // File 7: IERC721Metadata.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
682  * @dev See https://eips.ethereum.org/EIPS/eip-721
683  */
684 interface IERC721Metadata is IERC721 {
685     /**
686      * @dev Returns the token collection name.
687      */
688     function name() external view returns (string memory);
689 
690     /**
691      * @dev Returns the token collection symbol.
692      */
693     function symbol() external view returns (string memory);
694 
695     /**
696      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
697      */
698     function tokenURI(uint256 tokenId) external returns (string memory);
699 }
700 
701 
702 
703 
704 // File 8: ERC165.sol
705 
706 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @dev Implementation of the {IERC165} interface.
713  *
714  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
715  * for the additional interface id that will be supported. For example:
716  *
717  * ```solidity
718  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
720  * }
721  * ```
722  *
723  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
724  */
725 abstract contract ERC165 is IERC165 {
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730         return interfaceId == type(IERC165).interfaceId;
731     }
732 }
733 
734 
735 // File 9: ERC721.sol
736 
737 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 /**
743  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
744  * the Metadata extension, but not including the Enumerable extension, which is available separately as
745  * {ERC721Enumerable}.
746  */
747 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
748     using Address for address;
749     using Strings for uint256;
750 
751     // Token name
752     string private _name;
753 
754     // Token symbol
755     string private _symbol;
756 
757     // Mapping from token ID to owner address
758     mapping(uint256 => address) private _owners;
759 
760     // Mapping owner address to token count
761     mapping(address => uint256) private _balances;
762 
763     // Mapping from token ID to approved address
764     mapping(uint256 => address) private _tokenApprovals;
765 
766     // Mapping from owner to operator approvals
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     /**
770      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
771      */
772     constructor(string memory name_, string memory symbol_) {
773         _name = name_;
774         _symbol = symbol_;
775     }
776 
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
781         return
782             interfaceId == type(IERC721).interfaceId ||
783             interfaceId == type(IERC721Metadata).interfaceId ||
784             super.supportsInterface(interfaceId);
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view virtual override returns (uint256) {
791         require(owner != address(0), "ERC721: balance query for the zero address");
792         return _balances[owner];
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
799         address owner = _owners[tokenId];
800         require(owner != address(0), "ERC721: owner query for nonexistent token");
801         return owner;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
822         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overridden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return "";
835     }
836 
837     /**
838      * @dev See {IERC721-approve}.
839      */
840     function approve(address to, uint256 tokenId) public virtual override {
841         address owner = ERC721.ownerOf(tokenId);
842         require(to != owner, "ERC721: approval to current owner");
843 
844         require(
845             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
846             "ERC721: approve caller is not owner nor approved for all"
847         );
848         if (to.isContract()) {
849             revert ("Token transfer to contract address is not allowed.");
850         } else {
851             _approve(to, tokenId);
852         }
853         // _approve(to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view virtual override returns (address) {
860         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public virtual override {
869         _setApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         //solhint-disable-next-line max-line-length
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889 
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, "");
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914         _safeTransfer(from, to, tokenId, _data);
915     }
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
919      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
920      *
921      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
922      *
923      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
924      * implement alternative mechanisms to perform token transfer, such as signature-based.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeTransfer(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _transfer(from, to, tokenId);
942         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
943     }
944 
945     /**
946      * @dev Returns whether `tokenId` exists.
947      *
948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
949      *
950      * Tokens start existing when they are minted (`_mint`),
951      * and stop existing when they are burned (`_burn`).
952      */
953     function _exists(uint256 tokenId) internal view virtual returns (bool) {
954         return _owners[tokenId] != address(0);
955     }
956 
957     /**
958      * @dev Returns whether `spender` is allowed to manage `tokenId`.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      */
964     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
965         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
966         address owner = ERC721.ownerOf(tokenId);
967         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
968     }
969 
970     /**
971      * @dev Safely mints `tokenId` and transfers it to `to`.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(address to, uint256 tokenId) internal virtual {
981         _safeMint(to, tokenId, "");
982     }
983 
984     /**
985      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
986      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
987      */
988     function _safeMint(
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) internal virtual {
993         _mint(to, tokenId);
994         require(
995             _checkOnERC721Received(address(0), to, tokenId, _data),
996             "ERC721: transfer to non ERC721Receiver implementer"
997         );
998     }
999 
1000     /**
1001      * @dev Mints `tokenId` and transfers it to `to`.
1002      *
1003      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must not exist.
1008      * - `to` cannot be the zero address.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _mint(address to, uint256 tokenId) internal virtual {
1013         require(to != address(0), "ERC721: mint to the zero address");
1014         require(!_exists(tokenId), "ERC721: token already minted");
1015 
1016         _beforeTokenTransfer(address(0), to, tokenId);
1017 
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(address(0), to, tokenId);
1022 
1023         _afterTokenTransfer(address(0), to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Destroys `tokenId`.
1028      * The approval is cleared when the token is burned.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _burn(uint256 tokenId) internal virtual {
1037         address owner = ERC721.ownerOf(tokenId);
1038 
1039         _beforeTokenTransfer(owner, address(0), tokenId);
1040 
1041         // Clear approvals
1042         _approve(address(0), tokenId);
1043 
1044         _balances[owner] -= 1;
1045         delete _owners[tokenId];
1046 
1047         emit Transfer(owner, address(0), tokenId);
1048 
1049         _afterTokenTransfer(owner, address(0), tokenId);
1050     }
1051 
1052     /**
1053      * @dev Transfers `tokenId` from `from` to `to`.
1054      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must be owned by `from`.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual {
1068         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1069         require(to != address(0), "ERC721: transfer to the zero address");
1070 
1071         _beforeTokenTransfer(from, to, tokenId);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId);
1075 
1076         _balances[from] -= 1;
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(from, to, tokenId);
1081 
1082         _afterTokenTransfer(from, to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Approve `to` to operate on `tokenId`
1087      *
1088      * Emits a {Approval} event.
1089      */
1090     function _approve(address to, uint256 tokenId) internal virtual {
1091         _tokenApprovals[tokenId] = to;
1092         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Approve `operator` to operate on all of `owner` tokens
1097      *
1098      * Emits a {ApprovalForAll} event.
1099      */
1100     function _setApprovalForAll(
1101         address owner,
1102         address operator,
1103         bool approved
1104     ) internal virtual {
1105         require(owner != operator, "ERC721: approve to caller");
1106         _operatorApprovals[owner][operator] = approved;
1107         emit ApprovalForAll(owner, operator, approved);
1108     }
1109 
1110     /**
1111      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1112      * The call is not executed if the target address is not a contract.
1113      *
1114      * @param from address representing the previous owner of the given token ID
1115      * @param to target address that will receive the tokens
1116      * @param tokenId uint256 ID of the token to be transferred
1117      * @param _data bytes optional data to send along with the call
1118      * @return bool whether the call correctly returned the expected magic value
1119      */
1120     function _checkOnERC721Received(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) private returns (bool) {
1126         if (to.isContract()) {
1127             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1128                 return retval == IERC721Receiver.onERC721Received.selector;
1129             } catch (bytes memory reason) {
1130                 if (reason.length == 0) {
1131                     revert("ERC721: transfer to non ERC721Receiver implementer");
1132                 } else {
1133                     assembly {
1134                         revert(add(32, reason), mload(reason))
1135                     }
1136                 }
1137             }
1138         } else {
1139             return true;
1140         }
1141     }
1142 
1143     /**
1144      * @dev Hook that is called before any token transfer. This includes minting
1145      * and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` will be minted for `to`.
1152      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1153      * - `from` and `to` are never both zero.
1154      *
1155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1156      */
1157     function _beforeTokenTransfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Hook that is called after any transfer of tokens. This includes
1165      * minting and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - when `from` and `to` are both non-zero.
1170      * - `from` and `to` are never both zero.
1171      *
1172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1173      */
1174     function _afterTokenTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal virtual {}
1179 }
1180 
1181 
1182 
1183 
1184 
1185 // File 10: IERC721Enumerable.sol
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1192  * @dev See https://eips.ethereum.org/EIPS/eip-721
1193  */
1194 interface IERC721Enumerable is IERC721 {
1195 
1196     /**
1197      * @dev Returns the total amount of tokens stored by the contract.
1198      */
1199     function totalSupply() external view returns (uint256);
1200 
1201     /**
1202      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1203      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1204      */
1205     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1206 
1207     /**
1208      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1209      * Use along with {totalSupply} to enumerate all tokens.
1210      */
1211     function tokenByIndex(uint256 index) external view returns (uint256);
1212 }
1213 
1214 
1215 
1216 
1217 
1218 
1219 // File 11: ERC721Enumerable.sol
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 
1224 /**
1225  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1226  * enumerability of all the token ids in the contract as well as all token ids owned by each
1227  * account.
1228  */
1229 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1230     // Mapping from owner to list of owned token IDs
1231     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1232 
1233     // Mapping from token ID to index of the owner tokens list
1234     mapping(uint256 => uint256) private _ownedTokensIndex;
1235 
1236     // Array with all token ids, used for enumeration
1237     uint256[] private _allTokens;
1238 
1239     // Mapping from token id to position in the allTokens array
1240     mapping(uint256 => uint256) private _allTokensIndex;
1241 
1242     /**
1243      * @dev See {IERC165-supportsInterface}.
1244      */
1245     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1246         return interfaceId == type(IERC721Enumerable).interfaceId
1247             || super.supportsInterface(interfaceId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1252      */
1253     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1254         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1255         return _ownedTokens[owner][index];
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Enumerable-totalSupply}.
1260      */
1261     function totalSupply() public view virtual override returns (uint256) {
1262         return _allTokens.length;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Enumerable-tokenByIndex}.
1267      */
1268     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1269         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1270         return _allTokens[index];
1271     }
1272 
1273     /**
1274      * @dev Hook that is called before any token transfer. This includes minting
1275      * and burning.
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` will be minted for `to`.
1282      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1283      * - `from` cannot be the zero address.
1284      * - `to` cannot be the zero address.
1285      *
1286      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1287      */
1288     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1289         super._beforeTokenTransfer(from, to, tokenId);
1290 
1291         if (from == address(0)) {
1292             _addTokenToAllTokensEnumeration(tokenId);
1293         } else if (from != to) {
1294             _removeTokenFromOwnerEnumeration(from, tokenId);
1295         }
1296         if (to == address(0)) {
1297             _removeTokenFromAllTokensEnumeration(tokenId);
1298         } else if (to != from) {
1299             _addTokenToOwnerEnumeration(to, tokenId);
1300         }
1301     }
1302 
1303     /**
1304      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1305      * @param to address representing the new owner of the given token ID
1306      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1307      */
1308     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1309         uint256 length = ERC721.balanceOf(to);
1310         _ownedTokens[to][length] = tokenId;
1311         _ownedTokensIndex[tokenId] = length;
1312     }
1313 
1314     /**
1315      * @dev Private function to add a token to this extension's token tracking data structures.
1316      * @param tokenId uint256 ID of the token to be added to the tokens list
1317      */
1318     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1319         _allTokensIndex[tokenId] = _allTokens.length;
1320         _allTokens.push(tokenId);
1321     }
1322 
1323     /**
1324      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1325      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1326      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1327      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1328      * @param from address representing the previous owner of the given token ID
1329      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1330      */
1331     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1332         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1333         // then delete the last slot (swap and pop).
1334 
1335         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1336         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1337 
1338         // When the token to delete is the last token, the swap operation is unnecessary
1339         if (tokenIndex != lastTokenIndex) {
1340             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1341 
1342             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1343             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1344         }
1345 
1346         // This also deletes the contents at the last position of the array
1347         delete _ownedTokensIndex[tokenId];
1348         delete _ownedTokens[from][lastTokenIndex];
1349     }
1350 
1351     /**
1352      * @dev Private function to remove a token from this extension's token tracking data structures.
1353      * This has O(1) time complexity, but alters the order of the _allTokens array.
1354      * @param tokenId uint256 ID of the token to be removed from the tokens list
1355      */
1356     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1357         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1358         // then delete the last slot (swap and pop).
1359 
1360         uint256 lastTokenIndex = _allTokens.length - 1;
1361         uint256 tokenIndex = _allTokensIndex[tokenId];
1362 
1363         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1364         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1365         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1366         uint256 lastTokenId = _allTokens[lastTokenIndex];
1367 
1368         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1369         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1370 
1371         // This also deletes the contents at the last position of the array
1372         delete _allTokensIndex[tokenId];
1373         _allTokens.pop();
1374     }
1375 }
1376 
1377 
1378 
1379 // File 12: IERC721Receiver.sol
1380 
1381 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 /**
1386  * @title ERC721 token receiver interface
1387  * @dev Interface for any contract that wants to support safeTransfers
1388  * from ERC721 asset contracts.
1389  */
1390 interface IERC721Receiver {
1391     /**
1392      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1393      * by `operator` from `from`, this function is called.
1394      *
1395      * It must return its Solidity selector to confirm the token transfer.
1396      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1397      *
1398      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1399      */
1400     function onERC721Received(
1401         address operator,
1402         address from,
1403         uint256 tokenId,
1404         bytes calldata data
1405     ) external returns (bytes4);
1406 }
1407 
1408 
1409 
1410 // File 13: ERC721A.sol
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 
1415 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1416     using Address for address;
1417     using Strings for uint256;
1418 
1419     struct TokenOwnership {
1420         address addr;
1421         uint64 startTimestamp;
1422     }
1423 
1424     struct AddressData {
1425         uint128 balance;
1426         uint128 numberMinted;
1427     }
1428 
1429     uint256 internal currentIndex;
1430 
1431     // Token name
1432     string private _name;
1433 
1434     // Token symbol
1435     string private _symbol;
1436 
1437     // Mapping from token ID to ownership details
1438     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1439     mapping(uint256 => TokenOwnership) internal _ownerships;
1440 
1441     // Mapping owner address to address data
1442     mapping(address => AddressData) private _addressData;
1443 
1444     // Mapping from token ID to approved address
1445     mapping(uint256 => address) private _tokenApprovals;
1446 
1447     // Mapping from owner to operator approvals
1448     mapping(address => mapping(address => bool)) private _operatorApprovals;
1449 
1450     constructor(string memory name_, string memory symbol_) {
1451         _name = name_;
1452         _symbol = symbol_;
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Enumerable-totalSupply}.
1457      */
1458     function totalSupply() public view override virtual returns (uint256) {
1459         return currentIndex;
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Enumerable-tokenByIndex}.
1464      */
1465     function tokenByIndex(uint256 index) public view override returns (uint256) {
1466         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1467         return index;
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1472      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1473      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1474      */
1475     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1476         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1477         uint256 numMintedSoFar = totalSupply();
1478         uint256 tokenIdsIdx;
1479         address currOwnershipAddr;
1480 
1481         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1482         unchecked {
1483             for (uint256 i; i < numMintedSoFar; i++) {
1484                 TokenOwnership memory ownership = _ownerships[i];
1485                 if (ownership.addr != address(0)) {
1486                     currOwnershipAddr = ownership.addr;
1487                 }
1488                 if (currOwnershipAddr == owner) {
1489                     if (tokenIdsIdx == index) {
1490                         return i;
1491                     }
1492                     tokenIdsIdx++;
1493                 }
1494             }
1495         }
1496 
1497         revert('ERC721A: unable to get token of owner by index');
1498     }
1499 
1500     /**
1501      * @dev See {IERC165-supportsInterface}.
1502      */
1503     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1504         return
1505             interfaceId == type(IERC721).interfaceId ||
1506             interfaceId == type(IERC721Metadata).interfaceId ||
1507             interfaceId == type(IERC721Enumerable).interfaceId ||
1508             super.supportsInterface(interfaceId);
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-balanceOf}.
1513      */
1514     function balanceOf(address owner) public view override returns (uint256) {
1515         require(owner != address(0), 'ERC721A: balance query for the zero address');
1516         return uint256(_addressData[owner].balance);
1517     }
1518 
1519     function _numberMinted(address owner) internal view returns (uint256) {
1520         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1521         return uint256(_addressData[owner].numberMinted);
1522     }
1523 
1524     /**
1525      * Gas spent here starts off proportional to the maximum mint batch size.
1526      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1527      */
1528     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1529         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1530 
1531         unchecked {
1532             for (uint256 curr = tokenId; curr >= 0; curr--) {
1533                 TokenOwnership memory ownership = _ownerships[curr];
1534                 if (ownership.addr != address(0)) {
1535                     return ownership;
1536                 }
1537             }
1538         }
1539 
1540         revert('ERC721A: unable to determine the owner of token');
1541     }
1542 
1543     /**
1544      * @dev See {IERC721-ownerOf}.
1545      */
1546     function ownerOf(uint256 tokenId) public view override returns (address) {
1547         return ownershipOf(tokenId).addr;
1548     }
1549 
1550     /**
1551      * @dev See {IERC721Metadata-name}.
1552      */
1553     function name() public view virtual override returns (string memory) {
1554         return _name;
1555     }
1556 
1557     /**
1558      * @dev See {IERC721Metadata-symbol}.
1559      */
1560     function symbol() public view virtual override returns (string memory) {
1561         return _symbol;
1562     }
1563 
1564     /**
1565      * @dev See {IERC721Metadata-tokenURI}.
1566      */
1567     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1568         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1569 
1570         string memory baseURI = _baseURI();
1571         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1572     }
1573 
1574     /**
1575      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1576      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1577      * by default, can be overriden in child contracts.
1578      */
1579     function _baseURI() internal view virtual returns (string memory) {
1580         return '';
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-approve}.
1585      */
1586     function approve(address to, uint256 tokenId) public override {
1587         address owner = ERC721A.ownerOf(tokenId);
1588         require(to != owner, 'ERC721A: approval to current owner');
1589 
1590         require(
1591             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1592             'ERC721A: approve caller is not owner nor approved for all'
1593         );
1594 
1595         _approve(to, tokenId, owner);
1596     }
1597 
1598     /**
1599      * @dev See {IERC721-getApproved}.
1600      */
1601     function getApproved(uint256 tokenId) public view override returns (address) {
1602         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1603 
1604         return _tokenApprovals[tokenId];
1605     }
1606 
1607     /**
1608      * @dev See {IERC721-setApprovalForAll}.
1609      */
1610     function setApprovalForAll(address operator, bool approved) public override {
1611         require(operator != _msgSender(), 'ERC721A: approve to caller');
1612 
1613         _operatorApprovals[_msgSender()][operator] = approved;
1614         emit ApprovalForAll(_msgSender(), operator, approved);
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-isApprovedForAll}.
1619      */
1620     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1621         return _operatorApprovals[owner][operator];
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-transferFrom}.
1626      */
1627     function transferFrom(
1628         address from,
1629         address to,
1630         uint256 tokenId
1631     ) public override {
1632         _transfer(from, to, tokenId);
1633     }
1634 
1635     /**
1636      * @dev See {IERC721-safeTransferFrom}.
1637      */
1638     function safeTransferFrom(
1639         address from,
1640         address to,
1641         uint256 tokenId
1642     ) public override {
1643         safeTransferFrom(from, to, tokenId, '');
1644     }
1645 
1646     /**
1647      * @dev See {IERC721-safeTransferFrom}.
1648      */
1649     function safeTransferFrom(
1650         address from,
1651         address to,
1652         uint256 tokenId,
1653         bytes memory _data
1654     ) public override {
1655         _transfer(from, to, tokenId);
1656         require(
1657             _checkOnERC721Received(from, to, tokenId, _data),
1658             'ERC721A: transfer to non ERC721Receiver implementer'
1659         );
1660     }
1661 
1662     /**
1663      * @dev Returns whether `tokenId` exists.
1664      *
1665      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1666      *
1667      * Tokens start existing when they are minted (`_mint`),
1668      */
1669     function _exists(uint256 tokenId) internal view returns (bool) {
1670         return tokenId < currentIndex;
1671     }
1672 
1673     function _safeMint(address to, uint256 quantity) internal {
1674         _safeMint(to, quantity, '');
1675     }
1676 
1677     /**
1678      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1679      *
1680      * Requirements:
1681      *
1682      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1683      * - `quantity` must be greater than 0.
1684      *
1685      * Emits a {Transfer} event.
1686      */
1687     function _safeMint(
1688         address to,
1689         uint256 quantity,
1690         bytes memory _data
1691     ) internal {
1692         _mint(to, quantity, _data, true);
1693     }
1694 
1695     /**
1696      * @dev Mints `quantity` tokens and transfers them to `to`.
1697      *
1698      * Requirements:
1699      *
1700      * - `to` cannot be the zero address.
1701      * - `quantity` must be greater than 0.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function _mint(
1706         address to,
1707         uint256 quantity,
1708         bytes memory _data,
1709         bool safe
1710     ) internal {
1711         uint256 startTokenId = currentIndex;
1712         require(to != address(0), 'ERC721A: mint to the zero address');
1713         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1714 
1715         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1716 
1717         // Overflows are incredibly unrealistic.
1718         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1719         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1720         unchecked {
1721             _addressData[to].balance += uint128(quantity);
1722             _addressData[to].numberMinted += uint128(quantity);
1723 
1724             _ownerships[startTokenId].addr = to;
1725             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1726 
1727             uint256 updatedIndex = startTokenId;
1728 
1729             for (uint256 i; i < quantity; i++) {
1730                 emit Transfer(address(0), to, updatedIndex);
1731                 if (safe) {
1732                     require(
1733                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1734                         'ERC721A: transfer to non ERC721Receiver implementer'
1735                     );
1736                 }
1737 
1738                 updatedIndex++;
1739             }
1740 
1741             currentIndex = updatedIndex;
1742         }
1743 
1744         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1745     }
1746 
1747     /**
1748      * @dev Transfers `tokenId` from `from` to `to`.
1749      *
1750      * Requirements:
1751      *
1752      * - `to` cannot be the zero address.
1753      * - `tokenId` token must be owned by `from`.
1754      *
1755      * Emits a {Transfer} event.
1756      */
1757     function _transfer(
1758         address from,
1759         address to,
1760         uint256 tokenId
1761     ) private {
1762         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1763 
1764         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1765             getApproved(tokenId) == _msgSender() ||
1766             isApprovedForAll(prevOwnership.addr, _msgSender()));
1767 
1768         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1769 
1770         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1771         require(to != address(0), 'ERC721A: transfer to the zero address');
1772 
1773         _beforeTokenTransfers(from, to, tokenId, 1);
1774 
1775         // Clear approvals from the previous owner
1776         _approve(address(0), tokenId, prevOwnership.addr);
1777 
1778         // Underflow of the sender's balance is impossible because we check for
1779         // ownership above and the recipient's balance can't realistically overflow.
1780         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1781         unchecked {
1782             _addressData[from].balance -= 1;
1783             _addressData[to].balance += 1;
1784 
1785             _ownerships[tokenId].addr = to;
1786             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1787 
1788             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1789             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1790             uint256 nextTokenId = tokenId + 1;
1791             if (_ownerships[nextTokenId].addr == address(0)) {
1792                 if (_exists(nextTokenId)) {
1793                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1794                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1795                 }
1796             }
1797         }
1798 
1799         emit Transfer(from, to, tokenId);
1800         _afterTokenTransfers(from, to, tokenId, 1);
1801     }
1802 
1803     /**
1804      * @dev Approve `to` to operate on `tokenId`
1805      *
1806      * Emits a {Approval} event.
1807      */
1808     function _approve(
1809         address to,
1810         uint256 tokenId,
1811         address owner
1812     ) private {
1813         _tokenApprovals[tokenId] = to;
1814         emit Approval(owner, to, tokenId);
1815     }
1816 
1817     /**
1818      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1819      * The call is not executed if the target address is not a contract.
1820      *
1821      * @param from address representing the previous owner of the given token ID
1822      * @param to target address that will receive the tokens
1823      * @param tokenId uint256 ID of the token to be transferred
1824      * @param _data bytes optional data to send along with the call
1825      * @return bool whether the call correctly returned the expected magic value
1826      */
1827     function _checkOnERC721Received(
1828         address from,
1829         address to,
1830         uint256 tokenId,
1831         bytes memory _data
1832     ) private returns (bool) {
1833         if (to.isContract()) {
1834             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1835                 return retval == IERC721Receiver(to).onERC721Received.selector;
1836             } catch (bytes memory reason) {
1837                 if (reason.length == 0) {
1838                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1839                 } else {
1840                     assembly {
1841                         revert(add(32, reason), mload(reason))
1842                     }
1843                 }
1844             }
1845         } else {
1846             return true;
1847         }
1848     }
1849 
1850     /**
1851      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1852      *
1853      * startTokenId - the first token id to be transferred
1854      * quantity - the amount to be transferred
1855      *
1856      * Calling conditions:
1857      *
1858      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1859      * transferred to `to`.
1860      * - When `from` is zero, `tokenId` will be minted for `to`.
1861      */
1862     function _beforeTokenTransfers(
1863         address from,
1864         address to,
1865         uint256 startTokenId,
1866         uint256 quantity
1867     ) internal virtual {}
1868 
1869     /**
1870      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1871      * minting.
1872      *
1873      * startTokenId - the first token id to be transferred
1874      * quantity - the amount to be transferred
1875      *
1876      * Calling conditions:
1877      *
1878      * - when `from` and `to` are both non-zero.
1879      * - `from` and `to` are never both zero.
1880      */
1881     function _afterTokenTransfers(
1882         address from,
1883         address to,
1884         uint256 startTokenId,
1885         uint256 quantity
1886     ) internal virtual {}
1887 }
1888 
1889 // FILE 14: TOMATOZ.sol
1890 
1891 pragma solidity ^0.8.0;
1892 
1893 contract TOMATOZ is ERC721A, Ownable, ReentrancyGuard {
1894   using Strings for uint256;
1895   using Counters for Counters.Counter;
1896 
1897   string private uriPrefix = "";
1898   string public uriSuffix = ".json";
1899   string private hiddenMetadataUri;
1900 
1901     constructor() ERC721A("TOMATOZ", "TOTOZ") {
1902         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1903     }
1904 
1905     uint256 public price = 0.01 ether;
1906     uint256 public maxPerTx = 20;
1907     uint256 public maxPerFree = 2;    
1908     uint256 public maxFreeSupply = 3333;
1909     uint256 public max_Supply = 9999;
1910      
1911   bool public paused = true;
1912   bool public revealed = true;
1913 
1914     mapping(address => uint256) private _mintedFreeAmount;
1915 
1916     function changePrice(uint256 _newPrice) external onlyOwner {
1917         price = _newPrice;
1918     }
1919 
1920     function withdraw() external onlyOwner {
1921         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1922         require(success, "Transfer failed.");
1923     }
1924 
1925     //mint
1926     function mint(uint256 count) external payable {
1927         uint256 cost = price;
1928         require(!paused, "The contract is paused!");
1929         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1930         if (msg.sender != owner()) {
1931             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1932                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1933 
1934             if (isFree) {
1935                 cost = 0;
1936                 _mintedFreeAmount[msg.sender] += count;
1937             }
1938 
1939             require(msg.value >= count * cost, "Please send the exact amount.");
1940             require(count <= maxPerTx, "Max per TX reached.");
1941         }
1942 
1943         require(totalSupply() + count <= max_Supply, "No more");
1944 
1945         _safeMint(msg.sender, count);
1946     }
1947 
1948     function walletOfOwner(address _owner)
1949         public
1950         view
1951         returns (uint256[] memory)
1952     {
1953         uint256 ownerTokenCount = balanceOf(_owner);
1954         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1955         uint256 currentTokenId = 1;
1956         uint256 ownedTokenIndex = 0;
1957 
1958         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= max_Supply) {
1959         address currentTokenOwner = ownerOf(currentTokenId);
1960             if (currentTokenOwner == _owner) {
1961                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1962                 ownedTokenIndex++;
1963             }
1964         currentTokenId++;
1965         }
1966         return ownedTokenIds;
1967     }
1968   
1969   function tokenURI(uint256 _tokenId)
1970     public
1971     view
1972     virtual
1973     override
1974     returns (string memory)
1975   {
1976     require(
1977       _exists(_tokenId),
1978       "ERC721Metadata: URI query for nonexistent token"
1979     );
1980     if (revealed == false) {
1981       return hiddenMetadataUri;
1982     }
1983     string memory currentBaseURI = _baseURI();
1984     return bytes(currentBaseURI).length > 0
1985         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1986         : "";
1987   }
1988 
1989   function setPaused(bool _state) public onlyOwner {
1990     paused = _state;
1991   }
1992 
1993   function setRevealed(bool _state) public onlyOwner {
1994     revealed = _state;
1995   }  
1996 
1997   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
1998     maxPerTx = _maxPerTx;
1999   }
2000 
2001   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
2002     maxPerFree = _maxPerFree;
2003   }  
2004 
2005   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2006     maxFreeSupply = _maxFreeSupply;
2007   }
2008 
2009   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2010     max_Supply = _maxSupply;
2011   }
2012 
2013   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2014     hiddenMetadataUri = _hiddenMetadataUri;
2015   }  
2016 
2017   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2018     uriPrefix = _uriPrefix;
2019   }  
2020 
2021   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2022     uriSuffix = _uriSuffix;
2023   }
2024 
2025   function _baseURI() internal view virtual override returns (string memory) {
2026     return uriPrefix;
2027   }
2028 }