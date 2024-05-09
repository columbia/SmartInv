1 // File: contracts/Tabula_Rasa.sol
2 
3 
4 
5 // File 1: Address.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
8 
9 pragma solidity ^0.8.1;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on `isContract` to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217 
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Contract module that helps prevent reentrant calls to a function.
238  *
239  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
240  * available, which can be applied to functions to make sure there are no nested
241  * (reentrant) calls to them.
242  *
243  * Note that because there is a single `nonReentrant` guard, functions marked as
244  * `nonReentrant` may not call one another. This can be worked around by making
245  * those functions `private`, and then adding `external` `nonReentrant` entry
246  * points to them.
247  *
248  * TIP: If you would like to learn more about reentrancy and alternative ways
249  * to protect against it, check out our blog post
250  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
251  */
252 abstract contract ReentrancyGuard {
253     // Booleans are more expensive than uint256 or any type that takes up a full
254     // word because each write operation emits an extra SLOAD to first read the
255     // slot's contents, replace the bits taken up by the boolean, and then write
256     // back. This is the compiler's defense against contract upgrades and
257     // pointer aliasing, and it cannot be disabled.
258 
259     // The values being non-zero value makes deployment a bit more expensive,
260     // but in exchange the refund on every call to nonReentrant will be lower in
261     // amount. Since refunds are capped to a percentage of the total
262     // transaction's gas, it is best to keep them low in cases like this one, to
263     // increase the likelihood of the full refund coming into effect.
264     uint256 private constant _NOT_ENTERED = 1;
265     uint256 private constant _ENTERED = 2;
266 
267     uint256 private _status;
268 
269     constructor() {
270         _status = _NOT_ENTERED;
271     }
272 
273     /**
274      * @dev Prevents a contract from calling itself, directly or indirectly.
275      * Calling a `nonReentrant` function from another `nonReentrant`
276      * function is not supported. It is possible to prevent this from happening
277      * by making the `nonReentrant` function external, and making it call a
278      * `private` function that does the actual work.
279      */
280     modifier nonReentrant() {
281         // On the first call to nonReentrant, _notEntered will be true
282         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
283 
284         // Any calls to nonReentrant after this point will fail
285         _status = _ENTERED;
286 
287         _;
288 
289         // By storing the original value once again, a refund is triggered (see
290         // https://eips.ethereum.org/EIPS/eip-2200)
291         _status = _NOT_ENTERED;
292     }
293 }
294 
295 // FILE 2: Context.sol
296 pragma solidity ^0.8.0;
297 
298 /*
299  * @dev Provides information about the current execution context, including the
300  * sender of the transaction and its data. While these are generally available
301  * via msg.sender and msg.data, they should not be accessed in such a direct
302  * manner, since when dealing with meta-transactions the account sending and
303  * paying for execution may not be the actual sender (as far as an application
304  * is concerned).
305  *
306  * This contract is only required for intermediate, library-like contracts.
307  */
308 abstract contract Context {
309     function _msgSender() internal view virtual returns (address) {
310         return msg.sender;
311     }
312 
313     function _msgData() internal view virtual returns (bytes calldata) {
314         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
315         return msg.data;
316     }
317 }
318 
319 // File 3: Strings.sol
320 
321 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev String operations.
327  */
328 library Strings {
329     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
330 
331     /**
332      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
333      */
334     function toString(uint256 value) internal pure returns (string memory) {
335         // Inspired by OraclizeAPI's implementation - MIT licence
336         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
337 
338         if (value == 0) {
339             return "0";
340         }
341         uint256 temp = value;
342         uint256 digits;
343         while (temp != 0) {
344             digits++;
345             temp /= 10;
346         }
347         bytes memory buffer = new bytes(digits);
348         while (value != 0) {
349             digits -= 1;
350             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
351             value /= 10;
352         }
353         return string(buffer);
354     }
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
358      */
359     function toHexString(uint256 value) internal pure returns (string memory) {
360         if (value == 0) {
361             return "0x00";
362         }
363         uint256 temp = value;
364         uint256 length = 0;
365         while (temp != 0) {
366             length++;
367             temp >>= 8;
368         }
369         return toHexString(value, length);
370     }
371 
372     /**
373      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
374      */
375     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
376         bytes memory buffer = new bytes(2 * length + 2);
377         buffer[0] = "0";
378         buffer[1] = "x";
379         for (uint256 i = 2 * length + 1; i > 1; --i) {
380             buffer[i] = _HEX_SYMBOLS[value & 0xf];
381             value >>= 4;
382         }
383         require(value == 0, "Strings: hex length insufficient");
384         return string(buffer);
385     }
386 }
387 
388 
389 // File: @openzeppelin/contracts/utils/Counters.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @title Counters
398  * @author Matt Condon (@shrugs)
399  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
400  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
401  *
402  * Include with `using Counters for Counters.Counter;`
403  */
404 library Counters {
405     struct Counter {
406         // This variable should never be directly accessed by users of the library: interactions must be restricted to
407         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
408         // this feature: see https://github.com/ethereum/solidity/issues/4637
409         uint256 _value; // default: 0
410     }
411 
412     function current(Counter storage counter) internal view returns (uint256) {
413         return counter._value;
414     }
415 
416     function increment(Counter storage counter) internal {
417         unchecked {
418             counter._value += 1;
419         }
420     }
421 
422     function decrement(Counter storage counter) internal {
423         uint256 value = counter._value;
424         require(value > 0, "Counter: decrement overflow");
425         unchecked {
426             counter._value = value - 1;
427         }
428     }
429 
430     function reset(Counter storage counter) internal {
431         counter._value = 0;
432     }
433 }
434 
435 // File 4: Ownable.sol
436 
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @dev Contract module which provides a basic access control mechanism, where
443  * there is an account (an owner) that can be granted exclusive access to
444  * specific functions.
445  *
446  * By default, the owner account will be the one that deploys the contract. This
447  * can later be changed with {transferOwnership}.
448  *
449  * This module is used through inheritance. It will make available the modifier
450  * `onlyOwner`, which can be applied to your functions to restrict their use to
451  * the owner.
452  */
453 abstract contract Ownable is Context {
454     address private _owner;
455 
456     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
457 
458     /**
459      * @dev Initializes the contract setting the deployer as the initial owner.
460      */
461     constructor () {
462         address msgSender = _msgSender();
463         _owner = msgSender;
464         emit OwnershipTransferred(address(0), msgSender);
465     }
466 
467     /**
468      * @dev Returns the address of the current owner.
469      */
470     function owner() public view virtual returns (address) {
471         return _owner;
472     }
473 
474     /**
475      * @dev Throws if called by any account other than the owner.
476      */
477     modifier onlyOwner() {
478         require(owner() == _msgSender(), "Ownable: caller is not the owner");
479         _;
480     }
481 
482     /**
483      * @dev Leaves the contract without owner. It will not be possible to call
484      * `onlyOwner` functions anymore. Can only be called by the current owner.
485      *
486      * NOTE: Renouncing ownership will leave the contract without an owner,
487      * thereby removing any functionality that is only available to the owner.
488      */
489     function renounceOwnership() public virtual onlyOwner {
490         emit OwnershipTransferred(_owner, address(0));
491         _owner = address(0);
492     }
493 
494     /**
495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
496      * Can only be called by the current owner.
497      */
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(newOwner != address(0), "Ownable: new owner is the zero address");
500         emit OwnershipTransferred(_owner, newOwner);
501         _owner = newOwner;
502     }
503 }
504 
505 
506 
507 
508 
509 // File 5: IERC165.sol
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Interface of the ERC165 standard, as defined in the
515  * https://eips.ethereum.org/EIPS/eip-165[EIP].
516  *
517  * Implementers can declare support of contract interfaces, which can then be
518  * queried by others ({ERC165Checker}).
519  *
520  * For an implementation, see {ERC165}.
521  */
522 interface IERC165 {
523     /**
524      * @dev Returns true if this contract implements the interface defined by
525      * `interfaceId`. See the corresponding
526      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
527      * to learn more about how these ids are created.
528      *
529      * This function call must use less than 30 000 gas.
530      */
531     function supportsInterface(bytes4 interfaceId) external view returns (bool);
532 }
533 
534 
535 // File 6: IERC721.sol
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(address from, address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(address from, address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
607      * The approval is cleared when the token is transferred.
608      *
609      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
610      *
611      * Requirements:
612      *
613      * - The caller must own the token or be an approved operator.
614      * - `tokenId` must exist.
615      *
616      * Emits an {Approval} event.
617      */
618     function approve(address to, uint256 tokenId) external;
619 
620     /**
621      * @dev Returns the account approved for `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function getApproved(uint256 tokenId) external view returns (address operator);
628 
629     /**
630      * @dev Approve or remove `operator` as an operator for the caller.
631      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
632      *
633      * Requirements:
634      *
635      * - The `operator` cannot be the caller.
636      *
637      * Emits an {ApprovalForAll} event.
638      */
639     function setApprovalForAll(address operator, bool _approved) external;
640 
641     /**
642      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
643      *
644      * See {setApprovalForAll}
645      */
646     function isApprovedForAll(address owner, address operator) external view returns (bool);
647 
648     /**
649       * @dev Safely transfers `tokenId` token from `from` to `to`.
650       *
651       * Requirements:
652       *
653       * - `from` cannot be the zero address.
654       * - `to` cannot be the zero address.
655       * - `tokenId` token must exist and be owned by `from`.
656       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
657       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658       *
659       * Emits a {Transfer} event.
660       */
661     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
662 }
663 
664 
665 
666 // File 7: IERC721Metadata.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Metadata is IERC721 {
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external returns (string memory);
693 }
694 
695 
696 
697 
698 // File 8: ERC165.sol
699 
700 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Implementation of the {IERC165} interface.
707  *
708  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
709  * for the additional interface id that will be supported. For example:
710  *
711  * ```solidity
712  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
713  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
714  * }
715  * ```
716  *
717  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
718  */
719 abstract contract ERC165 is IERC165 {
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         return interfaceId == type(IERC165).interfaceId;
725     }
726 }
727 
728 
729 // File 9: ERC721.sol
730 
731 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
738  * the Metadata extension, but not including the Enumerable extension, which is available separately as
739  * {ERC721Enumerable}.
740  */
741 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
742     using Address for address;
743     using Strings for uint256;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Mapping from token ID to owner address
752     mapping(uint256 => address) private _owners;
753 
754     // Mapping owner address to token count
755     mapping(address => uint256) private _balances;
756 
757     // Mapping from token ID to approved address
758     mapping(uint256 => address) private _tokenApprovals;
759 
760     // Mapping from owner to operator approvals
761     mapping(address => mapping(address => bool)) private _operatorApprovals;
762 
763     /**
764      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
765      */
766     constructor(string memory name_, string memory symbol_) {
767         _name = name_;
768         _symbol = symbol_;
769     }
770 
771     /**
772      * @dev See {IERC165-supportsInterface}.
773      */
774     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
775         return
776             interfaceId == type(IERC721).interfaceId ||
777             interfaceId == type(IERC721Metadata).interfaceId ||
778             super.supportsInterface(interfaceId);
779     }
780 
781     /**
782      * @dev See {IERC721-balanceOf}.
783      */
784     function balanceOf(address owner) public view virtual override returns (uint256) {
785         require(owner != address(0), "ERC721: balance query for the zero address");
786         return _balances[owner];
787     }
788 
789     /**
790      * @dev See {IERC721-ownerOf}.
791      */
792     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
793         address owner = _owners[tokenId];
794         require(owner != address(0), "ERC721: owner query for nonexistent token");
795         return owner;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
816         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
817 
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overridden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return "";
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public virtual override {
835         address owner = ERC721.ownerOf(tokenId);
836         require(to != owner, "ERC721: approval to current owner");
837 
838         require(
839             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
840             "ERC721: approve caller is not owner nor approved for all"
841         );
842         if (to.isContract()) {
843             revert ("Token transfer to contract address is not allowed.");
844         } else {
845             _approve(to, tokenId);
846         }
847         // _approve(to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view virtual override returns (address) {
854         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         _setApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         //solhint-disable-next-line max-line-length
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883 
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, "");
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public virtual override {
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
908         _safeTransfer(from, to, tokenId, _data);
909     }
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
913      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
914      *
915      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
916      *
917      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
918      * implement alternative mechanisms to perform token transfer, such as signature-based.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _safeTransfer(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _transfer(from, to, tokenId);
936         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      * and stop existing when they are burned (`_burn`).
946      */
947     function _exists(uint256 tokenId) internal view virtual returns (bool) {
948         return _owners[tokenId] != address(0);
949     }
950 
951     /**
952      * @dev Returns whether `spender` is allowed to manage `tokenId`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
959         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
960         address owner = ERC721.ownerOf(tokenId);
961         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
962     }
963 
964     /**
965      * @dev Safely mints `tokenId` and transfers it to `to`.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _safeMint(address to, uint256 tokenId) internal virtual {
975         _safeMint(to, tokenId, "");
976     }
977 
978     /**
979      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
980      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
981      */
982     function _safeMint(
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) internal virtual {
987         _mint(to, tokenId);
988         require(
989             _checkOnERC721Received(address(0), to, tokenId, _data),
990             "ERC721: transfer to non ERC721Receiver implementer"
991         );
992     }
993 
994     /**
995      * @dev Mints `tokenId` and transfers it to `to`.
996      *
997      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - `to` cannot be the zero address.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(address to, uint256 tokenId) internal virtual {
1007         require(to != address(0), "ERC721: mint to the zero address");
1008         require(!_exists(tokenId), "ERC721: token already minted");
1009 
1010         _beforeTokenTransfer(address(0), to, tokenId);
1011 
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(address(0), to, tokenId);
1016 
1017         _afterTokenTransfer(address(0), to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Destroys `tokenId`.
1022      * The approval is cleared when the token is burned.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must exist.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _burn(uint256 tokenId) internal virtual {
1031         address owner = ERC721.ownerOf(tokenId);
1032 
1033         _beforeTokenTransfer(owner, address(0), tokenId);
1034 
1035         // Clear approvals
1036         _approve(address(0), tokenId);
1037 
1038         _balances[owner] -= 1;
1039         delete _owners[tokenId];
1040 
1041         emit Transfer(owner, address(0), tokenId);
1042 
1043         _afterTokenTransfer(owner, address(0), tokenId);
1044     }
1045 
1046     /**
1047      * @dev Transfers `tokenId` from `from` to `to`.
1048      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must be owned by `from`.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual {
1062         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1063         require(to != address(0), "ERC721: transfer to the zero address");
1064 
1065         _beforeTokenTransfer(from, to, tokenId);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId);
1069 
1070         _balances[from] -= 1;
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(from, to, tokenId);
1075 
1076         _afterTokenTransfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits a {Approval} event.
1083      */
1084     function _approve(address to, uint256 tokenId) internal virtual {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Approve `operator` to operate on all of `owner` tokens
1091      *
1092      * Emits a {ApprovalForAll} event.
1093      */
1094     function _setApprovalForAll(
1095         address owner,
1096         address operator,
1097         bool approved
1098     ) internal virtual {
1099         require(owner != operator, "ERC721: approve to caller");
1100         _operatorApprovals[owner][operator] = approved;
1101         emit ApprovalForAll(owner, operator, approved);
1102     }
1103 
1104     /**
1105      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1106      * The call is not executed if the target address is not a contract.
1107      *
1108      * @param from address representing the previous owner of the given token ID
1109      * @param to target address that will receive the tokens
1110      * @param tokenId uint256 ID of the token to be transferred
1111      * @param _data bytes optional data to send along with the call
1112      * @return bool whether the call correctly returned the expected magic value
1113      */
1114     function _checkOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         if (to.isContract()) {
1121             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1122                 return retval == IERC721Receiver.onERC721Received.selector;
1123             } catch (bytes memory reason) {
1124                 if (reason.length == 0) {
1125                     revert("ERC721: transfer to non ERC721Receiver implementer");
1126                 } else {
1127                     assembly {
1128                         revert(add(32, reason), mload(reason))
1129                     }
1130                 }
1131             }
1132         } else {
1133             return true;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Hook that is called before any token transfer. This includes minting
1139      * and burning.
1140      *
1141      * Calling conditions:
1142      *
1143      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1144      * transferred to `to`.
1145      * - When `from` is zero, `tokenId` will be minted for `to`.
1146      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1147      * - `from` and `to` are never both zero.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _beforeTokenTransfer(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) internal virtual {}
1156 
1157     /**
1158      * @dev Hook that is called after any transfer of tokens. This includes
1159      * minting and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - when `from` and `to` are both non-zero.
1164      * - `from` and `to` are never both zero.
1165      *
1166      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1167      */
1168     function _afterTokenTransfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) internal virtual {}
1173 }
1174 
1175 
1176 
1177 
1178 
1179 // File 10: IERC721Enumerable.sol
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 
1184 /**
1185  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1186  * @dev See https://eips.ethereum.org/EIPS/eip-721
1187  */
1188 interface IERC721Enumerable is IERC721 {
1189 
1190     /**
1191      * @dev Returns the total amount of tokens stored by the contract.
1192      */
1193     function totalSupply() external view returns (uint256);
1194 
1195     /**
1196      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1197      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1198      */
1199     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1200 
1201     /**
1202      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1203      * Use along with {totalSupply} to enumerate all tokens.
1204      */
1205     function tokenByIndex(uint256 index) external view returns (uint256);
1206 }
1207 
1208 
1209 
1210 
1211 
1212 
1213 // File 11: ERC721Enumerable.sol
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 
1218 /**
1219  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1220  * enumerability of all the token ids in the contract as well as all token ids owned by each
1221  * account.
1222  */
1223 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1224     // Mapping from owner to list of owned token IDs
1225     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1226 
1227     // Mapping from token ID to index of the owner tokens list
1228     mapping(uint256 => uint256) private _ownedTokensIndex;
1229 
1230     // Array with all token ids, used for enumeration
1231     uint256[] private _allTokens;
1232 
1233     // Mapping from token id to position in the allTokens array
1234     mapping(uint256 => uint256) private _allTokensIndex;
1235 
1236     /**
1237      * @dev See {IERC165-supportsInterface}.
1238      */
1239     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1240         return interfaceId == type(IERC721Enumerable).interfaceId
1241             || super.supportsInterface(interfaceId);
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1246      */
1247     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1248         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1249         return _ownedTokens[owner][index];
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Enumerable-totalSupply}.
1254      */
1255     function totalSupply() public view virtual override returns (uint256) {
1256         return _allTokens.length;
1257     }
1258 
1259     /**
1260      * @dev See {IERC721Enumerable-tokenByIndex}.
1261      */
1262     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1263         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1264         return _allTokens[index];
1265     }
1266 
1267     /**
1268      * @dev Hook that is called before any token transfer. This includes minting
1269      * and burning.
1270      *
1271      * Calling conditions:
1272      *
1273      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1274      * transferred to `to`.
1275      * - When `from` is zero, `tokenId` will be minted for `to`.
1276      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1277      * - `from` cannot be the zero address.
1278      * - `to` cannot be the zero address.
1279      *
1280      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1281      */
1282     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1283         super._beforeTokenTransfer(from, to, tokenId);
1284 
1285         if (from == address(0)) {
1286             _addTokenToAllTokensEnumeration(tokenId);
1287         } else if (from != to) {
1288             _removeTokenFromOwnerEnumeration(from, tokenId);
1289         }
1290         if (to == address(0)) {
1291             _removeTokenFromAllTokensEnumeration(tokenId);
1292         } else if (to != from) {
1293             _addTokenToOwnerEnumeration(to, tokenId);
1294         }
1295     }
1296 
1297     /**
1298      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1299      * @param to address representing the new owner of the given token ID
1300      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1301      */
1302     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1303         uint256 length = ERC721.balanceOf(to);
1304         _ownedTokens[to][length] = tokenId;
1305         _ownedTokensIndex[tokenId] = length;
1306     }
1307 
1308     /**
1309      * @dev Private function to add a token to this extension's token tracking data structures.
1310      * @param tokenId uint256 ID of the token to be added to the tokens list
1311      */
1312     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1313         _allTokensIndex[tokenId] = _allTokens.length;
1314         _allTokens.push(tokenId);
1315     }
1316 
1317     /**
1318      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1319      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1320      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1321      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1322      * @param from address representing the previous owner of the given token ID
1323      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1324      */
1325     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1326         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1327         // then delete the last slot (swap and pop).
1328 
1329         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1330         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1331 
1332         // When the token to delete is the last token, the swap operation is unnecessary
1333         if (tokenIndex != lastTokenIndex) {
1334             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1335 
1336             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1337             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1338         }
1339 
1340         // This also deletes the contents at the last position of the array
1341         delete _ownedTokensIndex[tokenId];
1342         delete _ownedTokens[from][lastTokenIndex];
1343     }
1344 
1345     /**
1346      * @dev Private function to remove a token from this extension's token tracking data structures.
1347      * This has O(1) time complexity, but alters the order of the _allTokens array.
1348      * @param tokenId uint256 ID of the token to be removed from the tokens list
1349      */
1350     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1351         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1352         // then delete the last slot (swap and pop).
1353 
1354         uint256 lastTokenIndex = _allTokens.length - 1;
1355         uint256 tokenIndex = _allTokensIndex[tokenId];
1356 
1357         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1358         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1359         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1360         uint256 lastTokenId = _allTokens[lastTokenIndex];
1361 
1362         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1363         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1364 
1365         // This also deletes the contents at the last position of the array
1366         delete _allTokensIndex[tokenId];
1367         _allTokens.pop();
1368     }
1369 }
1370 
1371 
1372 
1373 // File 12: IERC721Receiver.sol
1374 
1375 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 /**
1380  * @title ERC721 token receiver interface
1381  * @dev Interface for any contract that wants to support safeTransfers
1382  * from ERC721 asset contracts.
1383  */
1384 interface IERC721Receiver {
1385     /**
1386      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1387      * by `operator` from `from`, this function is called.
1388      *
1389      * It must return its Solidity selector to confirm the token transfer.
1390      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1391      *
1392      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1393      */
1394     function onERC721Received(
1395         address operator,
1396         address from,
1397         uint256 tokenId,
1398         bytes calldata data
1399     ) external returns (bytes4);
1400 }
1401 
1402 
1403 
1404 // File 13: ERC721A.sol
1405 
1406 pragma solidity ^0.8.0;
1407 
1408 
1409 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1410     using Address for address;
1411     using Strings for uint256;
1412 
1413     struct TokenOwnership {
1414         address addr;
1415         uint64 startTimestamp;
1416     }
1417 
1418     struct AddressData {
1419         uint128 balance;
1420         uint128 numberMinted;
1421     }
1422 
1423     uint256 internal currentIndex;
1424 
1425     // Token name
1426     string private _name;
1427 
1428     // Token symbol
1429     string private _symbol;
1430 
1431     // Mapping from token ID to ownership details
1432     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1433     mapping(uint256 => TokenOwnership) internal _ownerships;
1434 
1435     // Mapping owner address to address data
1436     mapping(address => AddressData) private _addressData;
1437 
1438     // Mapping from token ID to approved address
1439     mapping(uint256 => address) private _tokenApprovals;
1440 
1441     // Mapping from owner to operator approvals
1442     mapping(address => mapping(address => bool)) private _operatorApprovals;
1443 
1444     constructor(string memory name_, string memory symbol_) {
1445         _name = name_;
1446         _symbol = symbol_;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-totalSupply}.
1451      */
1452     function totalSupply() public view override virtual returns (uint256) {
1453         return currentIndex;
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Enumerable-tokenByIndex}.
1458      */
1459     function tokenByIndex(uint256 index) public view override returns (uint256) {
1460         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1461         return index;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1466      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1467      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1468      */
1469     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1470         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1471         uint256 numMintedSoFar = totalSupply();
1472         uint256 tokenIdsIdx;
1473         address currOwnershipAddr;
1474 
1475         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1476         unchecked {
1477             for (uint256 i; i < numMintedSoFar; i++) {
1478                 TokenOwnership memory ownership = _ownerships[i];
1479                 if (ownership.addr != address(0)) {
1480                     currOwnershipAddr = ownership.addr;
1481                 }
1482                 if (currOwnershipAddr == owner) {
1483                     if (tokenIdsIdx == index) {
1484                         return i;
1485                     }
1486                     tokenIdsIdx++;
1487                 }
1488             }
1489         }
1490 
1491         revert('ERC721A: unable to get token of owner by index');
1492     }
1493 
1494     /**
1495      * @dev See {IERC165-supportsInterface}.
1496      */
1497     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1498         return
1499             interfaceId == type(IERC721).interfaceId ||
1500             interfaceId == type(IERC721Metadata).interfaceId ||
1501             interfaceId == type(IERC721Enumerable).interfaceId ||
1502             super.supportsInterface(interfaceId);
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-balanceOf}.
1507      */
1508     function balanceOf(address owner) public view override returns (uint256) {
1509         require(owner != address(0), 'ERC721A: balance query for the zero address');
1510         return uint256(_addressData[owner].balance);
1511     }
1512 
1513     function _numberMinted(address owner) internal view returns (uint256) {
1514         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1515         return uint256(_addressData[owner].numberMinted);
1516     }
1517 
1518     /**
1519      * Gas spent here starts off proportional to the maximum mint batch size.
1520      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1521      */
1522     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1523         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1524 
1525         unchecked {
1526             for (uint256 curr = tokenId; curr >= 0; curr--) {
1527                 TokenOwnership memory ownership = _ownerships[curr];
1528                 if (ownership.addr != address(0)) {
1529                     return ownership;
1530                 }
1531             }
1532         }
1533 
1534         revert('ERC721A: unable to determine the owner of token');
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-ownerOf}.
1539      */
1540     function ownerOf(uint256 tokenId) public view override returns (address) {
1541         return ownershipOf(tokenId).addr;
1542     }
1543 
1544     /**
1545      * @dev See {IERC721Metadata-name}.
1546      */
1547     function name() public view virtual override returns (string memory) {
1548         return _name;
1549     }
1550 
1551     /**
1552      * @dev See {IERC721Metadata-symbol}.
1553      */
1554     function symbol() public view virtual override returns (string memory) {
1555         return _symbol;
1556     }
1557 
1558     /**
1559      * @dev See {IERC721Metadata-tokenURI}.
1560      */
1561     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1562         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1563 
1564         string memory baseURI = _baseURI();
1565         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1566     }
1567 
1568     /**
1569      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1570      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1571      * by default, can be overriden in child contracts.
1572      */
1573     function _baseURI() internal view virtual returns (string memory) {
1574         return '';
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-approve}.
1579      */
1580     function approve(address to, uint256 tokenId) public override {
1581         address owner = ERC721A.ownerOf(tokenId);
1582         require(to != owner, 'ERC721A: approval to current owner');
1583 
1584         require(
1585             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1586             'ERC721A: approve caller is not owner nor approved for all'
1587         );
1588 
1589         _approve(to, tokenId, owner);
1590     }
1591 
1592     /**
1593      * @dev See {IERC721-getApproved}.
1594      */
1595     function getApproved(uint256 tokenId) public view override returns (address) {
1596         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1597 
1598         return _tokenApprovals[tokenId];
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-setApprovalForAll}.
1603      */
1604     function setApprovalForAll(address operator, bool approved) public override {
1605         require(operator != _msgSender(), 'ERC721A: approve to caller');
1606 
1607         _operatorApprovals[_msgSender()][operator] = approved;
1608         emit ApprovalForAll(_msgSender(), operator, approved);
1609     }
1610 
1611     /**
1612      * @dev See {IERC721-isApprovedForAll}.
1613      */
1614     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1615         return _operatorApprovals[owner][operator];
1616     }
1617 
1618     /**
1619      * @dev See {IERC721-transferFrom}.
1620      */
1621     function transferFrom(
1622         address from,
1623         address to,
1624         uint256 tokenId
1625     ) public override {
1626         _transfer(from, to, tokenId);
1627     }
1628 
1629     /**
1630      * @dev See {IERC721-safeTransferFrom}.
1631      */
1632     function safeTransferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) public override {
1637         safeTransferFrom(from, to, tokenId, '');
1638     }
1639 
1640     /**
1641      * @dev See {IERC721-safeTransferFrom}.
1642      */
1643     function safeTransferFrom(
1644         address from,
1645         address to,
1646         uint256 tokenId,
1647         bytes memory _data
1648     ) public override {
1649         _transfer(from, to, tokenId);
1650         require(
1651             _checkOnERC721Received(from, to, tokenId, _data),
1652             'ERC721A: transfer to non ERC721Receiver implementer'
1653         );
1654     }
1655 
1656     /**
1657      * @dev Returns whether `tokenId` exists.
1658      *
1659      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1660      *
1661      * Tokens start existing when they are minted (`_mint`),
1662      */
1663     function _exists(uint256 tokenId) internal view returns (bool) {
1664         return tokenId < currentIndex;
1665     }
1666 
1667     function _safeMint(address to, uint256 quantity) internal {
1668         _safeMint(to, quantity, '');
1669     }
1670 
1671     /**
1672      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1673      *
1674      * Requirements:
1675      *
1676      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1677      * - `quantity` must be greater than 0.
1678      *
1679      * Emits a {Transfer} event.
1680      */
1681     function _safeMint(
1682         address to,
1683         uint256 quantity,
1684         bytes memory _data
1685     ) internal {
1686         _mint(to, quantity, _data, true);
1687     }
1688 
1689     /**
1690      * @dev Mints `quantity` tokens and transfers them to `to`.
1691      *
1692      * Requirements:
1693      *
1694      * - `to` cannot be the zero address.
1695      * - `quantity` must be greater than 0.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _mint(
1700         address to,
1701         uint256 quantity,
1702         bytes memory _data,
1703         bool safe
1704     ) internal {
1705         uint256 startTokenId = currentIndex;
1706         require(to != address(0), 'ERC721A: mint to the zero address');
1707         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1708 
1709         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1710 
1711         // Overflows are incredibly unrealistic.
1712         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1713         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1714         unchecked {
1715             _addressData[to].balance += uint128(quantity);
1716             _addressData[to].numberMinted += uint128(quantity);
1717 
1718             _ownerships[startTokenId].addr = to;
1719             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1720 
1721             uint256 updatedIndex = startTokenId;
1722 
1723             for (uint256 i; i < quantity; i++) {
1724                 emit Transfer(address(0), to, updatedIndex);
1725                 if (safe) {
1726                     require(
1727                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1728                         'ERC721A: transfer to non ERC721Receiver implementer'
1729                     );
1730                 }
1731 
1732                 updatedIndex++;
1733             }
1734 
1735             currentIndex = updatedIndex;
1736         }
1737 
1738         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1739     }
1740 
1741     /**
1742      * @dev Transfers `tokenId` from `from` to `to`.
1743      *
1744      * Requirements:
1745      *
1746      * - `to` cannot be the zero address.
1747      * - `tokenId` token must be owned by `from`.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function _transfer(
1752         address from,
1753         address to,
1754         uint256 tokenId
1755     ) private {
1756         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1757 
1758         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1759             getApproved(tokenId) == _msgSender() ||
1760             isApprovedForAll(prevOwnership.addr, _msgSender()));
1761 
1762         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1763 
1764         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1765         require(to != address(0), 'ERC721A: transfer to the zero address');
1766 
1767         _beforeTokenTransfers(from, to, tokenId, 1);
1768 
1769         // Clear approvals from the previous owner
1770         _approve(address(0), tokenId, prevOwnership.addr);
1771 
1772         // Underflow of the sender's balance is impossible because we check for
1773         // ownership above and the recipient's balance can't realistically overflow.
1774         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1775         unchecked {
1776             _addressData[from].balance -= 1;
1777             _addressData[to].balance += 1;
1778 
1779             _ownerships[tokenId].addr = to;
1780             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1781 
1782             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1783             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1784             uint256 nextTokenId = tokenId + 1;
1785             if (_ownerships[nextTokenId].addr == address(0)) {
1786                 if (_exists(nextTokenId)) {
1787                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1788                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1789                 }
1790             }
1791         }
1792 
1793         emit Transfer(from, to, tokenId);
1794         _afterTokenTransfers(from, to, tokenId, 1);
1795     }
1796 
1797     /**
1798      * @dev Approve `to` to operate on `tokenId`
1799      *
1800      * Emits a {Approval} event.
1801      */
1802     function _approve(
1803         address to,
1804         uint256 tokenId,
1805         address owner
1806     ) private {
1807         _tokenApprovals[tokenId] = to;
1808         emit Approval(owner, to, tokenId);
1809     }
1810 
1811     /**
1812      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1813      * The call is not executed if the target address is not a contract.
1814      *
1815      * @param from address representing the previous owner of the given token ID
1816      * @param to target address that will receive the tokens
1817      * @param tokenId uint256 ID of the token to be transferred
1818      * @param _data bytes optional data to send along with the call
1819      * @return bool whether the call correctly returned the expected magic value
1820      */
1821     function _checkOnERC721Received(
1822         address from,
1823         address to,
1824         uint256 tokenId,
1825         bytes memory _data
1826     ) private returns (bool) {
1827         if (to.isContract()) {
1828             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1829                 return retval == IERC721Receiver(to).onERC721Received.selector;
1830             } catch (bytes memory reason) {
1831                 if (reason.length == 0) {
1832                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1833                 } else {
1834                     assembly {
1835                         revert(add(32, reason), mload(reason))
1836                     }
1837                 }
1838             }
1839         } else {
1840             return true;
1841         }
1842     }
1843 
1844     /**
1845      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1846      *
1847      * startTokenId - the first token id to be transferred
1848      * quantity - the amount to be transferred
1849      *
1850      * Calling conditions:
1851      *
1852      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1853      * transferred to `to`.
1854      * - When `from` is zero, `tokenId` will be minted for `to`.
1855      */
1856     function _beforeTokenTransfers(
1857         address from,
1858         address to,
1859         uint256 startTokenId,
1860         uint256 quantity
1861     ) internal virtual {}
1862 
1863     /**
1864      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1865      * minting.
1866      *
1867      * startTokenId - the first token id to be transferred
1868      * quantity - the amount to be transferred
1869      *
1870      * Calling conditions:
1871      *
1872      * - when `from` and `to` are both non-zero.
1873      * - `from` and `to` are never both zero.
1874      */
1875     function _afterTokenTransfers(
1876         address from,
1877         address to,
1878         uint256 startTokenId,
1879         uint256 quantity
1880     ) internal virtual {}
1881 }
1882 
1883 // FILE 14: Tabula_Rasa.sol
1884 
1885 pragma solidity ^0.8.0;
1886 
1887 contract Tabula_Rasa is ERC721A, Ownable, ReentrancyGuard {
1888   using Strings for uint256;
1889   using Counters for Counters.Counter;
1890 
1891   string private uriPrefix = "";
1892   string public uriSuffix = ".json";
1893   string private hiddenMetadataUri;
1894 
1895     constructor() ERC721A("Tabula Rasa", "TR") {
1896         setHiddenMetadataUri("ipfs://QmRjsnojiYAKVGrrkueo5VSf7FbYKoEKHqWAAwwjkiyJPi/hidden.json");
1897     }
1898 
1899     uint256 public price = 0.004 ether;
1900     uint256 public maxPerTx = 3;
1901     uint256 public maxPerFree = 1;    
1902     uint256 public maxFreeSupply = 2222;
1903     uint256 public maxSupply = 4444;
1904      
1905   bool public paused = false;
1906   bool public revealed = false;
1907 
1908     mapping(address => uint256) private _mintedFreeAmount;
1909 
1910     function changePrice(uint256 _newPrice) external onlyOwner {
1911         price = _newPrice;
1912     }
1913 
1914     function withdraw() external onlyOwner {
1915         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1916         require(success, "Transfer failed.");
1917     }
1918 
1919     //mint
1920     function mint(uint256 count) external payable {
1921         uint256 cost = price;
1922         require(!paused, "The contract is paused!");
1923         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1924         if (msg.sender != owner()) {
1925             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1926                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1927 
1928             if (isFree) {
1929                 cost = 0;
1930                 _mintedFreeAmount[msg.sender] += count;
1931             }
1932 
1933             require(msg.value >= count * cost, "Please send the exact amount.");
1934             require(count <= maxPerTx, "Max per TX reached.");
1935         }
1936 
1937         require(totalSupply() + count <= maxSupply, "No more");
1938 
1939         _safeMint(msg.sender, count);
1940     }
1941 
1942 
1943     function walletOfOwner(address _owner)
1944         public
1945         view
1946         returns (uint256[] memory)
1947     {
1948         uint256 ownerTokenCount = balanceOf(_owner);
1949         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1950         uint256 currentTokenId = 1;
1951         uint256 ownedTokenIndex = 0;
1952 
1953         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1954         address currentTokenOwner = ownerOf(currentTokenId);
1955             if (currentTokenOwner == _owner) {
1956                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1957                 ownedTokenIndex++;
1958             }
1959         currentTokenId++;
1960         }
1961         return ownedTokenIds;
1962     }
1963   
1964   function tokenURI(uint256 _tokenId)
1965     public
1966     view
1967     virtual
1968     override
1969     returns (string memory)
1970   {
1971     require(
1972       _exists(_tokenId),
1973       "ERC721Metadata: URI query for nonexistent token"
1974     );
1975     if (revealed == false) {
1976       return hiddenMetadataUri;
1977     }
1978     string memory currentBaseURI = _baseURI();
1979     return bytes(currentBaseURI).length > 0
1980         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1981         : "";
1982   }
1983 
1984   function setPaused(bool _state) public onlyOwner {
1985     paused = _state;
1986   }
1987 
1988   function setRevealed(bool _state) public onlyOwner {
1989     revealed = _state;
1990   }  
1991 
1992   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
1993     maxPerTx = _maxPerTx;
1994   }
1995 
1996   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
1997     maxPerFree = _maxPerFree;
1998   }  
1999 
2000   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
2001     maxFreeSupply = _maxFreeSupply;
2002   }
2003 
2004   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2005     maxSupply = _maxSupply;
2006   }
2007 
2008   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2009     hiddenMetadataUri = _hiddenMetadataUri;
2010   }  
2011 
2012   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2013     uriPrefix = _uriPrefix;
2014   }  
2015 
2016   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2017     uriSuffix = _uriSuffix;
2018   }
2019 
2020   function _baseURI() internal view virtual override returns (string memory) {
2021     return uriPrefix;
2022   }
2023 }