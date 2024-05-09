1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Contract module that helps prevent reentrant calls to a function.
56  *
57  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
58  * available, which can be applied to functions to make sure there are no nested
59  * (reentrant) calls to them.
60  *
61  * Note that because there is a single `nonReentrant` guard, functions marked as
62  * `nonReentrant` may not call one another. This can be worked around by making
63  * those functions `private`, and then adding `external` `nonReentrant` entry
64  * points to them.
65  *
66  * TIP: If you would like to learn more about reentrancy and alternative ways
67  * to protect against it, check out our blog post
68  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
69  */
70 abstract contract ReentrancyGuard {
71     // Booleans are more expensive than uint256 or any type that takes up a full
72     // word because each write operation emits an extra SLOAD to first read the
73     // slot's contents, replace the bits taken up by the boolean, and then write
74     // back. This is the compiler's defense against contract upgrades and
75     // pointer aliasing, and it cannot be disabled.
76 
77     // The values being non-zero value makes deployment a bit more expensive,
78     // but in exchange the refund on every call to nonReentrant will be lower in
79     // amount. Since refunds are capped to a percentage of the total
80     // transaction's gas, it is best to keep them low in cases like this one, to
81     // increase the likelihood of the full refund coming into effect.
82     uint256 private constant _NOT_ENTERED = 1;
83     uint256 private constant _ENTERED = 2;
84 
85     uint256 private _status;
86 
87     constructor() {
88         _status = _NOT_ENTERED;
89     }
90 
91     /**
92      * @dev Prevents a contract from calling itself, directly or indirectly.
93      * Calling a `nonReentrant` function from another `nonReentrant`
94      * function is not supported. It is possible to prevent this from happening
95      * by making the `nonReentrant` function external, and making it call a
96      * `private` function that does the actual work.
97      */
98     modifier nonReentrant() {
99         // On the first call to nonReentrant, _notEntered will be true
100         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
101 
102         // Any calls to nonReentrant after this point will fail
103         _status = _ENTERED;
104 
105         _;
106 
107         // By storing the original value once again, a refund is triggered (see
108         // https://eips.ethereum.org/EIPS/eip-2200)
109         _status = _NOT_ENTERED;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Strings.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125     uint8 private constant _ADDRESS_LENGTH = 20;
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 
183     /**
184      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
185      */
186     function toHexString(address addr) internal pure returns (string memory) {
187         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Context.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Provides information about the current execution context, including the
200  * sender of the transaction and its data. While these are generally available
201  * via msg.sender and msg.data, they should not be accessed in such a direct
202  * manner, since when dealing with meta-transactions the account sending and
203  * paying for execution may not be the actual sender (as far as an application
204  * is concerned).
205  *
206  * This contract is only required for intermediate, library-like contracts.
207  */
208 abstract contract Context {
209     function _msgSender() internal view virtual returns (address) {
210         return msg.sender;
211     }
212 
213     function _msgData() internal view virtual returns (bytes calldata) {
214         return msg.data;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/access/Ownable.sol
219 
220 
221 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * By default, the owner account will be the one that deploys the contract. This
232  * can later be changed with {transferOwnership}.
233  *
234  * This module is used through inheritance. It will make available the modifier
235  * `onlyOwner`, which can be applied to your functions to restrict their use to
236  * the owner.
237  */
238 abstract contract Ownable is Context {
239     address private _owner;
240 
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor() {
247         _transferOwnership(_msgSender());
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         _checkOwner();
255         _;
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view virtual returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if the sender is not the owner.
267      */
268     function _checkOwner() internal view virtual {
269         require(owner() == _msgSender(), "Ownable: caller is not the owner");
270     }
271 
272     /**
273      * @dev Leaves the contract without owner. It will not be possible to call
274      * `onlyOwner` functions anymore. Can only be called by the current owner.
275      *
276      * NOTE: Renouncing ownership will leave the contract without an owner,
277      * thereby removing any functionality that is only available to the owner.
278      */
279     function renounceOwnership() public virtual onlyOwner {
280         _transferOwnership(address(0));
281     }
282 
283     /**
284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
285      * Can only be called by the current owner.
286      */
287     function transferOwnership(address newOwner) public virtual onlyOwner {
288         require(newOwner != address(0), "Ownable: new owner is the zero address");
289         _transferOwnership(newOwner);
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Internal function without access restriction.
295      */
296     function _transferOwnership(address newOwner) internal virtual {
297         address oldOwner = _owner;
298         _owner = newOwner;
299         emit OwnershipTransferred(oldOwner, newOwner);
300     }
301 }
302 
303 // File: @openzeppelin/contracts/security/Pausable.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev Contract module which allows children to implement an emergency stop
313  * mechanism that can be triggered by an authorized account.
314  *
315  * This module is used through inheritance. It will make available the
316  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
317  * the functions of your contract. Note that they will not be pausable by
318  * simply including this module, only once the modifiers are put in place.
319  */
320 abstract contract Pausable is Context {
321     /**
322      * @dev Emitted when the pause is triggered by `account`.
323      */
324     event Paused(address account);
325 
326     /**
327      * @dev Emitted when the pause is lifted by `account`.
328      */
329     event Unpaused(address account);
330 
331     bool private _paused;
332 
333     /**
334      * @dev Initializes the contract in unpaused state.
335      */
336     constructor() {
337         _paused = false;
338     }
339 
340     /**
341      * @dev Modifier to make a function callable only when the contract is not paused.
342      *
343      * Requirements:
344      *
345      * - The contract must not be paused.
346      */
347     modifier whenNotPaused() {
348         _requireNotPaused();
349         _;
350     }
351 
352     /**
353      * @dev Modifier to make a function callable only when the contract is paused.
354      *
355      * Requirements:
356      *
357      * - The contract must be paused.
358      */
359     modifier whenPaused() {
360         _requirePaused();
361         _;
362     }
363 
364     /**
365      * @dev Returns true if the contract is paused, and false otherwise.
366      */
367     function paused() public view virtual returns (bool) {
368         return _paused;
369     }
370 
371     /**
372      * @dev Throws if the contract is paused.
373      */
374     function _requireNotPaused() internal view virtual {
375         require(!paused(), "Pausable: paused");
376     }
377 
378     /**
379      * @dev Throws if the contract is not paused.
380      */
381     function _requirePaused() internal view virtual {
382         require(paused(), "Pausable: not paused");
383     }
384 
385     /**
386      * @dev Triggers stopped state.
387      *
388      * Requirements:
389      *
390      * - The contract must not be paused.
391      */
392     function _pause() internal virtual whenNotPaused {
393         _paused = true;
394         emit Paused(_msgSender());
395     }
396 
397     /**
398      * @dev Returns to normal state.
399      *
400      * Requirements:
401      *
402      * - The contract must be paused.
403      */
404     function _unpause() internal virtual whenPaused {
405         _paused = false;
406         emit Unpaused(_msgSender());
407     }
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 
412 
413 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
414 
415 pragma solidity ^0.8.1;
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      *
438      * [IMPORTANT]
439      * ====
440      * You shouldn't rely on `isContract` to protect against flash loan attacks!
441      *
442      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
443      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
444      * constructor.
445      * ====
446      */
447     function isContract(address account) internal view returns (bool) {
448         // This method relies on extcodesize/address.code.length, which returns 0
449         // for contracts in construction, since the code is only stored at the end
450         // of the constructor execution.
451 
452         return account.code.length > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
608      * revert reason using the provided one.
609      *
610      * _Available since v4.3._
611      */
612     function verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) internal pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623                 /// @solidity memory-safe-assembly
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @title ERC721 token receiver interface
644  * @dev Interface for any contract that wants to support safeTransfers
645  * from ERC721 asset contracts.
646  */
647 interface IERC721Receiver {
648     /**
649      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
650      * by `operator` from `from`, this function is called.
651      *
652      * It must return its Solidity selector to confirm the token transfer.
653      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
654      *
655      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
656      */
657     function onERC721Received(
658         address operator,
659         address from,
660         uint256 tokenId,
661         bytes calldata data
662     ) external returns (bytes4);
663 }
664 
665 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev Interface of the ERC165 standard, as defined in the
674  * https://eips.ethereum.org/EIPS/eip-165[EIP].
675  *
676  * Implementers can declare support of contract interfaces, which can then be
677  * queried by others ({ERC165Checker}).
678  *
679  * For an implementation, see {ERC165}.
680  */
681 interface IERC165 {
682     /**
683      * @dev Returns true if this contract implements the interface defined by
684      * `interfaceId`. See the corresponding
685      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
686      * to learn more about how these ids are created.
687      *
688      * This function call must use less than 30 000 gas.
689      */
690     function supportsInterface(bytes4 interfaceId) external view returns (bool);
691 }
692 
693 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Implementation of the {IERC165} interface.
703  *
704  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
705  * for the additional interface id that will be supported. For example:
706  *
707  * ```solidity
708  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
710  * }
711  * ```
712  *
713  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
714  */
715 abstract contract ERC165 is IERC165 {
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         return interfaceId == type(IERC165).interfaceId;
721     }
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Required interface of an ERC721 compliant contract.
734  */
735 interface IERC721 is IERC165 {
736     /**
737      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
738      */
739     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
740 
741     /**
742      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
743      */
744     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
745 
746     /**
747      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
748      */
749     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
750 
751     /**
752      * @dev Returns the number of tokens in ``owner``'s account.
753      */
754     function balanceOf(address owner) external view returns (uint256 balance);
755 
756     /**
757      * @dev Returns the owner of the `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function ownerOf(uint256 tokenId) external view returns (address owner);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes calldata data
783     ) external;
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Transfers `tokenId` token from `from` to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
830      *
831      * Requirements:
832      *
833      * - The caller must own the token or be an approved operator.
834      * - `tokenId` must exist.
835      *
836      * Emits an {Approval} event.
837      */
838     function approve(address to, uint256 tokenId) external;
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
843      *
844      * Requirements:
845      *
846      * - The `operator` cannot be the caller.
847      *
848      * Emits an {ApprovalForAll} event.
849      */
850     function setApprovalForAll(address operator, bool _approved) external;
851 
852     /**
853      * @dev Returns the account approved for `tokenId` token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function getApproved(uint256 tokenId) external view returns (address operator);
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}
865      */
866     function isApprovedForAll(address owner, address operator) external view returns (bool);
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
870 
871 
872 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 interface IERC721Enumerable is IERC721 {
882     /**
883      * @dev Returns the total amount of tokens stored by the contract.
884      */
885     function totalSupply() external view returns (uint256);
886 
887     /**
888      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
889      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
890      */
891     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
892 
893     /**
894      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
895      * Use along with {totalSupply} to enumerate all tokens.
896      */
897     function tokenByIndex(uint256 index) external view returns (uint256);
898 }
899 
900 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
910  * @dev See https://eips.ethereum.org/EIPS/eip-721
911  */
912 interface IERC721Metadata is IERC721 {
913     /**
914      * @dev Returns the token collection name.
915      */
916     function name() external view returns (string memory);
917 
918     /**
919      * @dev Returns the token collection symbol.
920      */
921     function symbol() external view returns (string memory);
922 
923     /**
924      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
925      */
926     function tokenURI(uint256 tokenId) external view returns (string memory);
927 }
928 
929 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
930 
931 
932 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 
940 
941 
942 
943 /**
944  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
945  * the Metadata extension, but not including the Enumerable extension, which is available separately as
946  * {ERC721Enumerable}.
947  */
948 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
949     using Address for address;
950     using Strings for uint256;
951 
952     // Token name
953     string private _name;
954 
955     // Token symbol
956     string private _symbol;
957 
958     // Mapping from token ID to owner address
959     mapping(uint256 => address) private _owners;
960 
961     // Mapping owner address to token count
962     mapping(address => uint256) private _balances;
963 
964     // Mapping from token ID to approved address
965     mapping(uint256 => address) private _tokenApprovals;
966 
967     // Mapping from owner to operator approvals
968     mapping(address => mapping(address => bool)) private _operatorApprovals;
969 
970     /**
971      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
972      */
973     constructor(string memory name_, string memory symbol_) {
974         _name = name_;
975         _symbol = symbol_;
976     }
977 
978     /**
979      * @dev See {IERC165-supportsInterface}.
980      */
981     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
982         return
983             interfaceId == type(IERC721).interfaceId ||
984             interfaceId == type(IERC721Metadata).interfaceId ||
985             super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721-balanceOf}.
990      */
991     function balanceOf(address owner) public view virtual override returns (uint256) {
992         require(owner != address(0), "ERC721: address zero is not a valid owner");
993         return _balances[owner];
994     }
995 
996     /**
997      * @dev See {IERC721-ownerOf}.
998      */
999     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1000         address owner = _owners[tokenId];
1001         require(owner != address(0), "ERC721: invalid token ID");
1002         return owner;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-name}.
1007      */
1008     function name() public view virtual override returns (string memory) {
1009         return _name;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-symbol}.
1014      */
1015     function symbol() public view virtual override returns (string memory) {
1016         return _symbol;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-tokenURI}.
1021      */
1022     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1023         _requireMinted(tokenId);
1024 
1025         string memory baseURI = _baseURI();
1026         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1027     }
1028 
1029     /**
1030      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1032      * by default, can be overridden in child contracts.
1033      */
1034     function _baseURI() internal view virtual returns (string memory) {
1035         return "";
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-approve}.
1040      */
1041     function approve(address to, uint256 tokenId) public virtual override {
1042         address owner = ERC721.ownerOf(tokenId);
1043         require(to != owner, "ERC721: approval to current owner");
1044 
1045         require(
1046             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1047             "ERC721: approve caller is not token owner nor approved for all"
1048         );
1049 
1050         _approve(to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-getApproved}.
1055      */
1056     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1057         _requireMinted(tokenId);
1058 
1059         return _tokenApprovals[tokenId];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-setApprovalForAll}.
1064      */
1065     function setApprovalForAll(address operator, bool approved) public virtual override {
1066         _setApprovalForAll(_msgSender(), operator, approved);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-isApprovedForAll}.
1071      */
1072     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1073         return _operatorApprovals[owner][operator];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-transferFrom}.
1078      */
1079     function transferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) public virtual override {
1084         //solhint-disable-next-line max-line-length
1085         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1086 
1087         _transfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-safeTransferFrom}.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) public virtual override {
1098         safeTransferFrom(from, to, tokenId, "");
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory data
1109     ) public virtual override {
1110         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1111         _safeTransfer(from, to, tokenId, data);
1112     }
1113 
1114     /**
1115      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1116      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1117      *
1118      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1119      *
1120      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1121      * implement alternative mechanisms to perform token transfer, such as signature-based.
1122      *
1123      * Requirements:
1124      *
1125      * - `from` cannot be the zero address.
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must exist and be owned by `from`.
1128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeTransfer(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory data
1137     ) internal virtual {
1138         _transfer(from, to, tokenId);
1139         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1140     }
1141 
1142     /**
1143      * @dev Returns whether `tokenId` exists.
1144      *
1145      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1146      *
1147      * Tokens start existing when they are minted (`_mint`),
1148      * and stop existing when they are burned (`_burn`).
1149      */
1150     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1151         return _owners[tokenId] != address(0);
1152     }
1153 
1154     /**
1155      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      */
1161     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1162         address owner = ERC721.ownerOf(tokenId);
1163         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1164     }
1165 
1166     /**
1167      * @dev Safely mints `tokenId` and transfers it to `to`.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must not exist.
1172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function _safeMint(address to, uint256 tokenId) internal virtual {
1177         _safeMint(to, tokenId, "");
1178     }
1179 
1180     /**
1181      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1182      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1183      */
1184     function _safeMint(
1185         address to,
1186         uint256 tokenId,
1187         bytes memory data
1188     ) internal virtual {
1189         _mint(to, tokenId);
1190         require(
1191             _checkOnERC721Received(address(0), to, tokenId, data),
1192             "ERC721: transfer to non ERC721Receiver implementer"
1193         );
1194     }
1195 
1196     /**
1197      * @dev Mints `tokenId` and transfers it to `to`.
1198      *
1199      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must not exist.
1204      * - `to` cannot be the zero address.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _mint(address to, uint256 tokenId) internal virtual {
1209         require(to != address(0), "ERC721: mint to the zero address");
1210         require(!_exists(tokenId), "ERC721: token already minted");
1211 
1212         _beforeTokenTransfer(address(0), to, tokenId);
1213 
1214         _balances[to] += 1;
1215         _owners[tokenId] = to;
1216 
1217         emit Transfer(address(0), to, tokenId);
1218 
1219         _afterTokenTransfer(address(0), to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev Destroys `tokenId`.
1224      * The approval is cleared when the token is burned.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _burn(uint256 tokenId) internal virtual {
1233         address owner = ERC721.ownerOf(tokenId);
1234 
1235         _beforeTokenTransfer(owner, address(0), tokenId);
1236 
1237         // Clear approvals
1238         _approve(address(0), tokenId);
1239 
1240         _balances[owner] -= 1;
1241         delete _owners[tokenId];
1242 
1243         emit Transfer(owner, address(0), tokenId);
1244 
1245         _afterTokenTransfer(owner, address(0), tokenId);
1246     }
1247 
1248     /**
1249      * @dev Transfers `tokenId` from `from` to `to`.
1250      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must be owned by `from`.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _transfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) internal virtual {
1264         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1265         require(to != address(0), "ERC721: transfer to the zero address");
1266 
1267         _beforeTokenTransfer(from, to, tokenId);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId);
1271 
1272         _balances[from] -= 1;
1273         _balances[to] += 1;
1274         _owners[tokenId] = to;
1275 
1276         emit Transfer(from, to, tokenId);
1277 
1278         _afterTokenTransfer(from, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev Approve `to` to operate on `tokenId`
1283      *
1284      * Emits an {Approval} event.
1285      */
1286     function _approve(address to, uint256 tokenId) internal virtual {
1287         _tokenApprovals[tokenId] = to;
1288         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1289     }
1290 
1291     /**
1292      * @dev Approve `operator` to operate on all of `owner` tokens
1293      *
1294      * Emits an {ApprovalForAll} event.
1295      */
1296     function _setApprovalForAll(
1297         address owner,
1298         address operator,
1299         bool approved
1300     ) internal virtual {
1301         require(owner != operator, "ERC721: approve to caller");
1302         _operatorApprovals[owner][operator] = approved;
1303         emit ApprovalForAll(owner, operator, approved);
1304     }
1305 
1306     /**
1307      * @dev Reverts if the `tokenId` has not been minted yet.
1308      */
1309     function _requireMinted(uint256 tokenId) internal view virtual {
1310         require(_exists(tokenId), "ERC721: invalid token ID");
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1315      * The call is not executed if the target address is not a contract.
1316      *
1317      * @param from address representing the previous owner of the given token ID
1318      * @param to target address that will receive the tokens
1319      * @param tokenId uint256 ID of the token to be transferred
1320      * @param data bytes optional data to send along with the call
1321      * @return bool whether the call correctly returned the expected magic value
1322      */
1323     function _checkOnERC721Received(
1324         address from,
1325         address to,
1326         uint256 tokenId,
1327         bytes memory data
1328     ) private returns (bool) {
1329         if (to.isContract()) {
1330             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1331                 return retval == IERC721Receiver.onERC721Received.selector;
1332             } catch (bytes memory reason) {
1333                 if (reason.length == 0) {
1334                     revert("ERC721: transfer to non ERC721Receiver implementer");
1335                 } else {
1336                     /// @solidity memory-safe-assembly
1337                     assembly {
1338                         revert(add(32, reason), mload(reason))
1339                     }
1340                 }
1341             }
1342         } else {
1343             return true;
1344         }
1345     }
1346 
1347     /**
1348      * @dev Hook that is called before any token transfer. This includes minting
1349      * and burning.
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` will be minted for `to`.
1356      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1357      * - `from` and `to` are never both zero.
1358      *
1359      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1360      */
1361     function _beforeTokenTransfer(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Hook that is called after any transfer of tokens. This includes
1369      * minting and burning.
1370      *
1371      * Calling conditions:
1372      *
1373      * - when `from` and `to` are both non-zero.
1374      * - `from` and `to` are never both zero.
1375      *
1376      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1377      */
1378     function _afterTokenTransfer(
1379         address from,
1380         address to,
1381         uint256 tokenId
1382     ) internal virtual {}
1383 }
1384 
1385 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1386 
1387 
1388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1389 
1390 pragma solidity ^0.8.0;
1391 
1392 
1393 
1394 /**
1395  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1396  * enumerability of all the token ids in the contract as well as all token ids owned by each
1397  * account.
1398  */
1399 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1400     // Mapping from owner to list of owned token IDs
1401     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1402 
1403     // Mapping from token ID to index of the owner tokens list
1404     mapping(uint256 => uint256) private _ownedTokensIndex;
1405 
1406     // Array with all token ids, used for enumeration
1407     uint256[] private _allTokens;
1408 
1409     // Mapping from token id to position in the allTokens array
1410     mapping(uint256 => uint256) private _allTokensIndex;
1411 
1412     /**
1413      * @dev See {IERC165-supportsInterface}.
1414      */
1415     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1416         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1417     }
1418 
1419     /**
1420      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1421      */
1422     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1423         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1424         return _ownedTokens[owner][index];
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Enumerable-totalSupply}.
1429      */
1430     function totalSupply() public view virtual override returns (uint256) {
1431         return _allTokens.length;
1432     }
1433 
1434     /**
1435      * @dev See {IERC721Enumerable-tokenByIndex}.
1436      */
1437     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1438         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1439         return _allTokens[index];
1440     }
1441 
1442     /**
1443      * @dev Hook that is called before any token transfer. This includes minting
1444      * and burning.
1445      *
1446      * Calling conditions:
1447      *
1448      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1449      * transferred to `to`.
1450      * - When `from` is zero, `tokenId` will be minted for `to`.
1451      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1452      * - `from` cannot be the zero address.
1453      * - `to` cannot be the zero address.
1454      *
1455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1456      */
1457     function _beforeTokenTransfer(
1458         address from,
1459         address to,
1460         uint256 tokenId
1461     ) internal virtual override {
1462         super._beforeTokenTransfer(from, to, tokenId);
1463 
1464         if (from == address(0)) {
1465             _addTokenToAllTokensEnumeration(tokenId);
1466         } else if (from != to) {
1467             _removeTokenFromOwnerEnumeration(from, tokenId);
1468         }
1469         if (to == address(0)) {
1470             _removeTokenFromAllTokensEnumeration(tokenId);
1471         } else if (to != from) {
1472             _addTokenToOwnerEnumeration(to, tokenId);
1473         }
1474     }
1475 
1476     /**
1477      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1478      * @param to address representing the new owner of the given token ID
1479      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1480      */
1481     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1482         uint256 length = ERC721.balanceOf(to);
1483         _ownedTokens[to][length] = tokenId;
1484         _ownedTokensIndex[tokenId] = length;
1485     }
1486 
1487     /**
1488      * @dev Private function to add a token to this extension's token tracking data structures.
1489      * @param tokenId uint256 ID of the token to be added to the tokens list
1490      */
1491     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1492         _allTokensIndex[tokenId] = _allTokens.length;
1493         _allTokens.push(tokenId);
1494     }
1495 
1496     /**
1497      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1498      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1499      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1500      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1501      * @param from address representing the previous owner of the given token ID
1502      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1503      */
1504     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1505         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1506         // then delete the last slot (swap and pop).
1507 
1508         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1509         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1510 
1511         // When the token to delete is the last token, the swap operation is unnecessary
1512         if (tokenIndex != lastTokenIndex) {
1513             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1514 
1515             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1516             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1517         }
1518 
1519         // This also deletes the contents at the last position of the array
1520         delete _ownedTokensIndex[tokenId];
1521         delete _ownedTokens[from][lastTokenIndex];
1522     }
1523 
1524     /**
1525      * @dev Private function to remove a token from this extension's token tracking data structures.
1526      * This has O(1) time complexity, but alters the order of the _allTokens array.
1527      * @param tokenId uint256 ID of the token to be removed from the tokens list
1528      */
1529     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1530         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1531         // then delete the last slot (swap and pop).
1532 
1533         uint256 lastTokenIndex = _allTokens.length - 1;
1534         uint256 tokenIndex = _allTokensIndex[tokenId];
1535 
1536         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1537         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1538         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1539         uint256 lastTokenId = _allTokens[lastTokenIndex];
1540 
1541         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1542         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1543 
1544         // This also deletes the contents at the last position of the array
1545         delete _allTokensIndex[tokenId];
1546         _allTokens.pop();
1547     }
1548 }
1549 
1550 // File: MarsWawa.sol
1551 
1552 
1553 pragma solidity ^0.8.4;
1554 
1555 contract MarsWawa is ERC721, ERC721Enumerable, Pausable, Ownable, ReentrancyGuard {
1556 
1557   enum Stage {Pending, OGMint, WLMint, PublicSale, Publish}
1558 
1559   uint16 public constant MaxSupply = 3333;
1560   uint8 public constant MaxMint = 1;
1561   uint16 public constant ReserveCount = 200;
1562   uint16 public constant FreeMintCount = 1600;
1563   uint16 public constant Royalty = 750; 
1564   uint256 public constant PublicPrice = 0.00777 ether;
1565 
1566   uint256 public lastTime = 0; 
1567 
1568   using Counters for Counters.Counter;
1569   Counters.Counter private _tokenIdCounter;
1570 
1571   struct WLUser {
1572     uint8 count;
1573     bool isOG;
1574     bool isWL;
1575   }
1576 
1577   mapping (address => WLUser) private wlUsers;
1578 
1579   uint16 public ogCount = 0; 
1580   uint16 public wlCount = 0; 
1581   uint16 public freeCount = FreeMintCount; 
1582   uint16 public mintCount = MaxSupply - ReserveCount; 
1583 
1584   string private _uri;
1585   Stage private _stage = Stage.Pending;
1586 
1587   string private _contractURI = "ipfs://QmNkYsBzuSGtFdkUmwDimoqPd7UdfkmCHmzHyqvymz2EfH";
1588 
1589   constructor(string memory uri) ERC721("MarsWaWa", "MWW") {
1590     _uri = uri;
1591   }
1592 
1593   // region Stage
1594 
1595   modifier onlyStage(Stage stage_) {
1596     require(stage_ == _stage, "It's not right stage.");
1597     _;
1598   }
1599 
1600   function getStage() public view returns(Stage) {
1601     return _stage;
1602   }
1603 
1604   function setStage(Stage stage) public onlyOwner {
1605     lastTime = block.timestamp;
1606     _stage = stage;
1607   }
1608 
1609   // endregion
1610 
1611   // region URI
1612 
1613   function setURI(string memory baseURI_) public onlyOwner{
1614     _uri = baseURI_;
1615   }
1616 
1617   function _baseURI() override(ERC721) internal view returns (string memory){
1618     return _uri;
1619   }
1620 
1621   function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
1622     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1623     return super.tokenURI(_stage < Stage.Publish ? 0 : tokenId);
1624   }
1625 
1626   function _exists(uint256 tokenId) internal view virtual override(ERC721) returns (bool) {
1627     return tokenId == 0 ? true : super._exists(tokenId);
1628   }
1629 
1630   function setContractURI(string memory baseURI_) public onlyOwner{
1631     _contractURI = baseURI_;
1632   }
1633 
1634   function contractURI() public view returns (string memory) {
1635     return _contractURI;
1636   }
1637 
1638   // endregion
1639 
1640   // region Pause
1641 
1642   function setPause(bool value) public onlyOwner {
1643     value ? _pause() : _unpause();
1644   }
1645 
1646   // endregion
1647 
1648   // region Override
1649 
1650   function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1651   override (ERC721,ERC721Enumerable) internal whenNotPaused {
1652     return super._beforeTokenTransfer(from,to,tokenId);
1653   }
1654 
1655   function release() public onlyOwner {
1656     uint256 balance_ = address(this).balance;
1657     payable(address(owner())).transfer(balance_);
1658   }
1659 
1660   function supportsInterface(bytes4 interfaceId) public view
1661   override(ERC721 , ERC721Enumerable) returns(bool){
1662     return super.supportsInterface(interfaceId);
1663   }
1664 
1665   // endregion
1666 
1667   // region WhiteList
1668 
1669   function isOG(address sender) public view returns(bool){
1670     return wlUsers[sender].isOG;
1671   }
1672   function isWL(address sender) public view returns(bool){
1673     return wlUsers[sender].isWL;
1674   }
1675   function isWLMintEnable(address sender, uint8 num) public view returns(bool){
1676     return wlUsers[sender].count >= num;
1677   }
1678 
1679   function addOG(address[] calldata members) public onlyOwner {
1680     for (uint256 i = 0; i < members.length; i++)
1681       _addWL(members[i], true);
1682   }
1683   function addWL(address[] calldata members) public onlyOwner {
1684     for (uint256 i = 0; i < members.length; i++)
1685       _addWL(members[i], false);
1686   }
1687   function _addWL(address m, bool isOG_) private onlyOwner {
1688     if (isWL(m)) return;
1689     wlUsers[m] = WLUser(MaxMint, isOG_, true);
1690     if (isOG_) ogCount += wlUsers[m].count;
1691     wlCount += wlUsers[m].count;
1692   }
1693 
1694   function removeOG(address[] calldata members) public onlyOwner {
1695     for (uint256 i = 0; i < members.length; i++)
1696       _removeWL(members[i], true);
1697   }
1698   function removeWL(address[] calldata members) public onlyOwner {
1699     for (uint256 i = 0; i < members.length; i++)
1700       _removeWL(members[i], false);
1701   }
1702   function _removeWL(address m, bool isOG_) private onlyOwner {
1703     if (isOG_ ? !isOG(m) : (isOG(m) || !isWL(m))) return;
1704     if (isOG_) ogCount -= wlUsers[m].count;
1705     wlCount -= wlUsers[m].count;
1706     wlUsers[m] = WLUser(0, false, false);
1707   }
1708 
1709   // endregion
1710 
1711   // region Mint
1712 
1713   function ogMint(uint8 num) public onlyStage(Stage.OGMint) nonReentrant payable {
1714     _WLMint(num, true);
1715   }
1716   function wlMint(uint8 num) public onlyStage(Stage.WLMint) nonReentrant payable {
1717     _WLMint(num, false);
1718   }
1719   function _WLMint(uint8 num, bool isOG_) private {
1720     require(freeCount >= num, "Free mint is over!");
1721     require(isOG_ ? isOG(msg.sender) : isWL(msg.sender), "The address not in WL/OG");
1722     require(isWLMintEnable(msg.sender, num), "The address have minted");
1723 
1724     safeMint(msg.sender, num);
1725 
1726     wlUsers[msg.sender].count -= num;
1727     if (isOG_) ogCount -= num; wlCount -= num;
1728 
1729     freeCount -= num; mintCount -= num;
1730   }
1731 
1732   function mint(uint8 num) public onlyStage(Stage.PublicSale) nonReentrant payable {
1733     require(mintCount >= num, "All tokens have been minted!");
1734 
1735     uint balance = balanceOf(msg.sender);
1736     require(balance + num <= MaxMint, strConcat("The address have minted", Strings.toString(num)));
1737 
1738     uint totalPrice = num * PublicPrice;
1739     require(msg.value >= totalPrice, strConcat("Lack of ETH: ",
1740       strConcat(Strings.toString(msg.value), strConcat(" -> ", Strings.toString(totalPrice)))));
1741 
1742     safeMint(msg.sender, num);
1743     mintCount -= num;
1744   }
1745 
1746   function safeMint(address to, uint256 num) private {
1747     require(num > 0, "Can't mint zero NFT");
1748 
1749     for (uint256 i = 0; i < num; i++) {
1750       _tokenIdCounter.increment();
1751       uint256 current_ = _tokenIdCounter.current();
1752       require(current_ <= MaxSupply, "All NFTs have already been minted.");
1753       _safeMint(to, current_);
1754     }
1755   }
1756 
1757   function reserve(uint256 n) public onlyOwner {
1758     safeMint(msg.sender, n);
1759   }
1760 
1761   // endregion
1762 
1763   // region Utils
1764 
1765   function strConcat(string memory _a, string memory _b) public pure returns (string memory){
1766     bytes memory _ba = bytes(_a);
1767     bytes memory _bb = bytes(_b);
1768     string memory ret = new string(_ba.length + _bb.length);
1769     bytes memory bret = bytes(ret);
1770     uint k = 0;
1771     for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
1772     for (uint i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
1773     return string(ret);
1774   }
1775 
1776   // endregion
1777 
1778 }