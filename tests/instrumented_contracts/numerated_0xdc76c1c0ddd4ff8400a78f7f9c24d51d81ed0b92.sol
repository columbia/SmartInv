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
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59     uint8 private constant _ADDRESS_LENGTH = 20;
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
119      */
120     function toHexString(address addr) internal pure returns (string memory) {
121         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Context.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         return msg.data;
149     }
150 }
151 
152 // File: @openzeppelin/contracts/security/Pausable.sol
153 
154 
155 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 /**
161  * @dev Contract module which allows children to implement an emergency stop
162  * mechanism that can be triggered by an authorized account.
163  *
164  * This module is used through inheritance. It will make available the
165  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
166  * the functions of your contract. Note that they will not be pausable by
167  * simply including this module, only once the modifiers are put in place.
168  */
169 abstract contract Pausable is Context {
170     /**
171      * @dev Emitted when the pause is triggered by `account`.
172      */
173     event Paused(address account);
174 
175     /**
176      * @dev Emitted when the pause is lifted by `account`.
177      */
178     event Unpaused(address account);
179 
180     bool private _paused;
181 
182     /**
183      * @dev Initializes the contract in unpaused state.
184      */
185     constructor() {
186         _paused = false;
187     }
188 
189     /**
190      * @dev Modifier to make a function callable only when the contract is not paused.
191      *
192      * Requirements:
193      *
194      * - The contract must not be paused.
195      */
196     modifier whenNotPaused() {
197         _requireNotPaused();
198         _;
199     }
200 
201     /**
202      * @dev Modifier to make a function callable only when the contract is paused.
203      *
204      * Requirements:
205      *
206      * - The contract must be paused.
207      */
208     modifier whenPaused() {
209         _requirePaused();
210         _;
211     }
212 
213     /**
214      * @dev Returns true if the contract is paused, and false otherwise.
215      */
216     function paused() public view virtual returns (bool) {
217         return _paused;
218     }
219 
220     /**
221      * @dev Throws if the contract is paused.
222      */
223     function _requireNotPaused() internal view virtual {
224         require(!paused(), "Pausable: paused");
225     }
226 
227     /**
228      * @dev Throws if the contract is not paused.
229      */
230     function _requirePaused() internal view virtual {
231         require(paused(), "Pausable: not paused");
232     }
233 
234     /**
235      * @dev Triggers stopped state.
236      *
237      * Requirements:
238      *
239      * - The contract must not be paused.
240      */
241     function _pause() internal virtual whenNotPaused {
242         _paused = true;
243         emit Paused(_msgSender());
244     }
245 
246     /**
247      * @dev Returns to normal state.
248      *
249      * Requirements:
250      *
251      * - The contract must be paused.
252      */
253     function _unpause() internal virtual whenPaused {
254         _paused = false;
255         emit Unpaused(_msgSender());
256     }
257 }
258 
259 // File: @openzeppelin/contracts/access/Ownable.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @dev Contract module which provides a basic access control mechanism, where
269  * there is an account (an owner) that can be granted exclusive access to
270  * specific functions.
271  *
272  * By default, the owner account will be the one that deploys the contract. This
273  * can later be changed with {transferOwnership}.
274  *
275  * This module is used through inheritance. It will make available the modifier
276  * `onlyOwner`, which can be applied to your functions to restrict their use to
277  * the owner.
278  */
279 abstract contract Ownable is Context {
280     address private _owner;
281 
282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284     /**
285      * @dev Initializes the contract setting the deployer as the initial owner.
286      */
287     constructor() {
288         _transferOwnership(_msgSender());
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         _checkOwner();
296         _;
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view virtual returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if the sender is not the owner.
308      */
309     function _checkOwner() internal view virtual {
310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
311     }
312 
313     /**
314      * @dev Leaves the contract without owner. It will not be possible to call
315      * `onlyOwner` functions anymore. Can only be called by the current owner.
316      *
317      * NOTE: Renouncing ownership will leave the contract without an owner,
318      * thereby removing any functionality that is only available to the owner.
319      */
320     function renounceOwnership() public virtual onlyOwner {
321         _transferOwnership(address(0));
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Can only be called by the current owner.
327      */
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         _transferOwnership(newOwner);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Internal function without access restriction.
336      */
337     function _transferOwnership(address newOwner) internal virtual {
338         address oldOwner = _owner;
339         _owner = newOwner;
340         emit OwnershipTransferred(oldOwner, newOwner);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Address.sol
345 
346 
347 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
348 
349 pragma solidity ^0.8.1;
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * [IMPORTANT]
359      * ====
360      * It is unsafe to assume that an address for which this function returns
361      * false is an externally-owned account (EOA) and not a contract.
362      *
363      * Among others, `isContract` will return false for the following
364      * types of addresses:
365      *
366      *  - an externally-owned account
367      *  - a contract in construction
368      *  - an address where a contract will be created
369      *  - an address where a contract lived, but was destroyed
370      * ====
371      *
372      * [IMPORTANT]
373      * ====
374      * You shouldn't rely on `isContract` to protect against flash loan attacks!
375      *
376      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
377      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
378      * constructor.
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // This method relies on extcodesize/address.code.length, which returns 0
383         // for contracts in construction, since the code is only stored at the end
384         // of the constructor execution.
385 
386         return account.code.length > 0;
387     }
388 
389     /**
390      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
391      * `recipient`, forwarding all available gas and reverting on errors.
392      *
393      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
394      * of certain opcodes, possibly making contracts go over the 2300 gas limit
395      * imposed by `transfer`, making them unable to receive funds via
396      * `transfer`. {sendValue} removes this limitation.
397      *
398      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
399      *
400      * IMPORTANT: because control is transferred to `recipient`, care must be
401      * taken to not create reentrancy vulnerabilities. Consider using
402      * {ReentrancyGuard} or the
403      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
404      */
405     function sendValue(address payable recipient, uint256 amount) internal {
406         require(address(this).balance >= amount, "Address: insufficient balance");
407 
408         (bool success, ) = recipient.call{value: amount}("");
409         require(success, "Address: unable to send value, recipient may have reverted");
410     }
411 
412     /**
413      * @dev Performs a Solidity function call using a low level `call`. A
414      * plain `call` is an unsafe replacement for a function call: use this
415      * function instead.
416      *
417      * If `target` reverts with a revert reason, it is bubbled up by this
418      * function (like regular Solidity function calls).
419      *
420      * Returns the raw returned data. To convert to the expected return value,
421      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
422      *
423      * Requirements:
424      *
425      * - `target` must be a contract.
426      * - calling `target` with `data` must not revert.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionCall(target, data, "Address: low-level call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
436      * `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, 0, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but also transferring `value` wei to `target`.
451      *
452      * Requirements:
453      *
454      * - the calling contract must have an ETH balance of at least `value`.
455      * - the called Solidity function must be `payable`.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
469      * with `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCallWithValue(
474         address target,
475         bytes memory data,
476         uint256 value,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(address(this).balance >= value, "Address: insufficient balance for call");
480         require(isContract(target), "Address: call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.call{value: value}(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
493         return functionStaticCall(target, data, "Address: low-level static call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal view returns (bytes memory) {
507         require(isContract(target), "Address: static call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.staticcall(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a delegate call.
516      *
517      * _Available since v3.4._
518      */
519     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
520         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a delegate call.
526      *
527      * _Available since v3.4._
528      */
529     function functionDelegateCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(isContract(target), "Address: delegate call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.delegatecall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
542      * revert reason using the provided one.
543      *
544      * _Available since v4.3._
545      */
546     function verifyCallResult(
547         bool success,
548         bytes memory returndata,
549         string memory errorMessage
550     ) internal pure returns (bytes memory) {
551         if (success) {
552             return returndata;
553         } else {
554             // Look for revert reason and bubble it up if present
555             if (returndata.length > 0) {
556                 // The easiest way to bubble the revert reason is using memory via assembly
557                 /// @solidity memory-safe-assembly
558                 assembly {
559                     let returndata_size := mload(returndata)
560                     revert(add(32, returndata), returndata_size)
561                 }
562             } else {
563                 revert(errorMessage);
564             }
565         }
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
570 
571 
572 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @title ERC721 token receiver interface
578  * @dev Interface for any contract that wants to support safeTransfers
579  * from ERC721 asset contracts.
580  */
581 interface IERC721Receiver {
582     /**
583      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
584      * by `operator` from `from`, this function is called.
585      *
586      * It must return its Solidity selector to confirm the token transfer.
587      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
588      *
589      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
590      */
591     function onERC721Received(
592         address operator,
593         address from,
594         uint256 tokenId,
595         bytes calldata data
596     ) external returns (bytes4);
597 }
598 
599 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 /**
607  * @dev Interface of the ERC165 standard, as defined in the
608  * https://eips.ethereum.org/EIPS/eip-165[EIP].
609  *
610  * Implementers can declare support of contract interfaces, which can then be
611  * queried by others ({ERC165Checker}).
612  *
613  * For an implementation, see {ERC165}.
614  */
615 interface IERC165 {
616     /**
617      * @dev Returns true if this contract implements the interface defined by
618      * `interfaceId`. See the corresponding
619      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
620      * to learn more about how these ids are created.
621      *
622      * This function call must use less than 30 000 gas.
623      */
624     function supportsInterface(bytes4 interfaceId) external view returns (bool);
625 }
626 
627 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 /**
636  * @dev Implementation of the {IERC165} interface.
637  *
638  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
639  * for the additional interface id that will be supported. For example:
640  *
641  * ```solidity
642  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
643  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
644  * }
645  * ```
646  *
647  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
648  */
649 abstract contract ERC165 is IERC165 {
650     /**
651      * @dev See {IERC165-supportsInterface}.
652      */
653     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654         return interfaceId == type(IERC165).interfaceId;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
659 
660 
661 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Required interface of an ERC721 compliant contract.
668  */
669 interface IERC721 is IERC165 {
670     /**
671      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
672      */
673     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
674 
675     /**
676      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
677      */
678     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
679 
680     /**
681      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
682      */
683     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
684 
685     /**
686      * @dev Returns the number of tokens in ``owner``'s account.
687      */
688     function balanceOf(address owner) external view returns (uint256 balance);
689 
690     /**
691      * @dev Returns the owner of the `tokenId` token.
692      *
693      * Requirements:
694      *
695      * - `tokenId` must exist.
696      */
697     function ownerOf(uint256 tokenId) external view returns (address owner);
698 
699     /**
700      * @dev Safely transfers `tokenId` token from `from` to `to`.
701      *
702      * Requirements:
703      *
704      * - `from` cannot be the zero address.
705      * - `to` cannot be the zero address.
706      * - `tokenId` token must exist and be owned by `from`.
707      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
708      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
709      *
710      * Emits a {Transfer} event.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId,
716         bytes calldata data
717     ) external;
718 
719     /**
720      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
721      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must exist and be owned by `from`.
728      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) external;
738 
739     /**
740      * @dev Transfers `tokenId` token from `from` to `to`.
741      *
742      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      *
751      * Emits a {Transfer} event.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) external;
758 
759     /**
760      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
761      * The approval is cleared when the token is transferred.
762      *
763      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
764      *
765      * Requirements:
766      *
767      * - The caller must own the token or be an approved operator.
768      * - `tokenId` must exist.
769      *
770      * Emits an {Approval} event.
771      */
772     function approve(address to, uint256 tokenId) external;
773 
774     /**
775      * @dev Approve or remove `operator` as an operator for the caller.
776      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
777      *
778      * Requirements:
779      *
780      * - The `operator` cannot be the caller.
781      *
782      * Emits an {ApprovalForAll} event.
783      */
784     function setApprovalForAll(address operator, bool _approved) external;
785 
786     /**
787      * @dev Returns the account approved for `tokenId` token.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function getApproved(uint256 tokenId) external view returns (address operator);
794 
795     /**
796      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
797      *
798      * See {setApprovalForAll}
799      */
800     function isApprovedForAll(address owner, address operator) external view returns (bool);
801 }
802 
803 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
804 
805 
806 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 
811 /**
812  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
813  * @dev See https://eips.ethereum.org/EIPS/eip-721
814  */
815 interface IERC721Metadata is IERC721 {
816     /**
817      * @dev Returns the token collection name.
818      */
819     function name() external view returns (string memory);
820 
821     /**
822      * @dev Returns the token collection symbol.
823      */
824     function symbol() external view returns (string memory);
825 
826     /**
827      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
828      */
829     function tokenURI(uint256 tokenId) external view returns (string memory);
830 }
831 
832 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
833 
834 
835 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 
840 
841 
842 
843 
844 
845 
846 /**
847  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
848  * the Metadata extension, but not including the Enumerable extension, which is available separately as
849  * {ERC721Enumerable}.
850  */
851 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
852     using Address for address;
853     using Strings for uint256;
854 
855     // Token name
856     string private _name;
857 
858     // Token symbol
859     string private _symbol;
860 
861     // Mapping from token ID to owner address
862     mapping(uint256 => address) private _owners;
863 
864     // Mapping owner address to token count
865     mapping(address => uint256) private _balances;
866 
867     // Mapping from token ID to approved address
868     mapping(uint256 => address) private _tokenApprovals;
869 
870     // Mapping from owner to operator approvals
871     mapping(address => mapping(address => bool)) private _operatorApprovals;
872 
873     /**
874      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
875      */
876     constructor(string memory name_, string memory symbol_) {
877         _name = name_;
878         _symbol = symbol_;
879     }
880 
881     /**
882      * @dev See {IERC165-supportsInterface}.
883      */
884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
885         return
886             interfaceId == type(IERC721).interfaceId ||
887             interfaceId == type(IERC721Metadata).interfaceId ||
888             super.supportsInterface(interfaceId);
889     }
890 
891     /**
892      * @dev See {IERC721-balanceOf}.
893      */
894     function balanceOf(address owner) public view virtual override returns (uint256) {
895         require(owner != address(0), "ERC721: address zero is not a valid owner");
896         return _balances[owner];
897     }
898 
899     /**
900      * @dev See {IERC721-ownerOf}.
901      */
902     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
903         address owner = _owners[tokenId];
904         require(owner != address(0), "ERC721: invalid token ID");
905         return owner;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-name}.
910      */
911     function name() public view virtual override returns (string memory) {
912         return _name;
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-symbol}.
917      */
918     function symbol() public view virtual override returns (string memory) {
919         return _symbol;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-tokenURI}.
924      */
925     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
926         _requireMinted(tokenId);
927 
928         string memory baseURI = _baseURI();
929         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
930     }
931 
932     /**
933      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
934      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
935      * by default, can be overridden in child contracts.
936      */
937     function _baseURI() internal view virtual returns (string memory) {
938         return "";
939     }
940 
941     /**
942      * @dev See {IERC721-approve}.
943      */
944     function approve(address to, uint256 tokenId) public virtual override {
945         address owner = ERC721.ownerOf(tokenId);
946         require(to != owner, "ERC721: approval to current owner");
947 
948         require(
949             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
950             "ERC721: approve caller is not token owner nor approved for all"
951         );
952 
953         _approve(to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-getApproved}.
958      */
959     function getApproved(uint256 tokenId) public view virtual override returns (address) {
960         _requireMinted(tokenId);
961 
962         return _tokenApprovals[tokenId];
963     }
964 
965     /**
966      * @dev See {IERC721-setApprovalForAll}.
967      */
968     function setApprovalForAll(address operator, bool approved) public virtual override {
969         _setApprovalForAll(_msgSender(), operator, approved);
970     }
971 
972     /**
973      * @dev See {IERC721-isApprovedForAll}.
974      */
975     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
976         return _operatorApprovals[owner][operator];
977     }
978 
979     /**
980      * @dev See {IERC721-transferFrom}.
981      */
982     function transferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) public virtual override {
987         //solhint-disable-next-line max-line-length
988         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
989 
990         _transfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         safeTransferFrom(from, to, tokenId, "");
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory data
1012     ) public virtual override {
1013         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1014         _safeTransfer(from, to, tokenId, data);
1015     }
1016 
1017     /**
1018      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1019      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1020      *
1021      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1022      *
1023      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1024      * implement alternative mechanisms to perform token transfer, such as signature-based.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must exist and be owned by `from`.
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _safeTransfer(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory data
1040     ) internal virtual {
1041         _transfer(from, to, tokenId);
1042         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1043     }
1044 
1045     /**
1046      * @dev Returns whether `tokenId` exists.
1047      *
1048      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1049      *
1050      * Tokens start existing when they are minted (`_mint`),
1051      * and stop existing when they are burned (`_burn`).
1052      */
1053     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1054         return _owners[tokenId] != address(0);
1055     }
1056 
1057     /**
1058      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      */
1064     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1065         address owner = ERC721.ownerOf(tokenId);
1066         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1067     }
1068 
1069     /**
1070      * @dev Safely mints `tokenId` and transfers it to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must not exist.
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(address to, uint256 tokenId) internal virtual {
1080         _safeMint(to, tokenId, "");
1081     }
1082 
1083     /**
1084      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1085      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 tokenId,
1090         bytes memory data
1091     ) internal virtual {
1092         _mint(to, tokenId);
1093         require(
1094             _checkOnERC721Received(address(0), to, tokenId, data),
1095             "ERC721: transfer to non ERC721Receiver implementer"
1096         );
1097     }
1098 
1099     /**
1100      * @dev Mints `tokenId` and transfers it to `to`.
1101      *
1102      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must not exist.
1107      * - `to` cannot be the zero address.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _mint(address to, uint256 tokenId) internal virtual {
1112         require(to != address(0), "ERC721: mint to the zero address");
1113         require(!_exists(tokenId), "ERC721: token already minted");
1114 
1115         _beforeTokenTransfer(address(0), to, tokenId);
1116 
1117         _balances[to] += 1;
1118         _owners[tokenId] = to;
1119 
1120         emit Transfer(address(0), to, tokenId);
1121 
1122         _afterTokenTransfer(address(0), to, tokenId);
1123     }
1124 
1125     /**
1126      * @dev Destroys `tokenId`.
1127      * The approval is cleared when the token is burned.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _burn(uint256 tokenId) internal virtual {
1136         address owner = ERC721.ownerOf(tokenId);
1137 
1138         _beforeTokenTransfer(owner, address(0), tokenId);
1139 
1140         // Clear approvals
1141         _approve(address(0), tokenId);
1142 
1143         _balances[owner] -= 1;
1144         delete _owners[tokenId];
1145 
1146         emit Transfer(owner, address(0), tokenId);
1147 
1148         _afterTokenTransfer(owner, address(0), tokenId);
1149     }
1150 
1151     /**
1152      * @dev Transfers `tokenId` from `from` to `to`.
1153      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _transfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {
1167         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1168         require(to != address(0), "ERC721: transfer to the zero address");
1169 
1170         _beforeTokenTransfer(from, to, tokenId);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId);
1174 
1175         _balances[from] -= 1;
1176         _balances[to] += 1;
1177         _owners[tokenId] = to;
1178 
1179         emit Transfer(from, to, tokenId);
1180 
1181         _afterTokenTransfer(from, to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev Approve `to` to operate on `tokenId`
1186      *
1187      * Emits an {Approval} event.
1188      */
1189     function _approve(address to, uint256 tokenId) internal virtual {
1190         _tokenApprovals[tokenId] = to;
1191         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev Approve `operator` to operate on all of `owner` tokens
1196      *
1197      * Emits an {ApprovalForAll} event.
1198      */
1199     function _setApprovalForAll(
1200         address owner,
1201         address operator,
1202         bool approved
1203     ) internal virtual {
1204         require(owner != operator, "ERC721: approve to caller");
1205         _operatorApprovals[owner][operator] = approved;
1206         emit ApprovalForAll(owner, operator, approved);
1207     }
1208 
1209     /**
1210      * @dev Reverts if the `tokenId` has not been minted yet.
1211      */
1212     function _requireMinted(uint256 tokenId) internal view virtual {
1213         require(_exists(tokenId), "ERC721: invalid token ID");
1214     }
1215 
1216     /**
1217      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1218      * The call is not executed if the target address is not a contract.
1219      *
1220      * @param from address representing the previous owner of the given token ID
1221      * @param to target address that will receive the tokens
1222      * @param tokenId uint256 ID of the token to be transferred
1223      * @param data bytes optional data to send along with the call
1224      * @return bool whether the call correctly returned the expected magic value
1225      */
1226     function _checkOnERC721Received(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory data
1231     ) private returns (bool) {
1232         if (to.isContract()) {
1233             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1234                 return retval == IERC721Receiver.onERC721Received.selector;
1235             } catch (bytes memory reason) {
1236                 if (reason.length == 0) {
1237                     revert("ERC721: transfer to non ERC721Receiver implementer");
1238                 } else {
1239                     /// @solidity memory-safe-assembly
1240                     assembly {
1241                         revert(add(32, reason), mload(reason))
1242                     }
1243                 }
1244             }
1245         } else {
1246             return true;
1247         }
1248     }
1249 
1250     /**
1251      * @dev Hook that is called before any token transfer. This includes minting
1252      * and burning.
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1260      * - `from` and `to` are never both zero.
1261      *
1262      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1263      */
1264     function _beforeTokenTransfer(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) internal virtual {}
1269 
1270     /**
1271      * @dev Hook that is called after any transfer of tokens. This includes
1272      * minting and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - when `from` and `to` are both non-zero.
1277      * - `from` and `to` are never both zero.
1278      *
1279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1280      */
1281     function _afterTokenTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) internal virtual {}
1286 }
1287 
1288 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1289 
1290 
1291 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 
1296 
1297 /**
1298  * @title ERC721 Burnable Token
1299  * @dev ERC721 Token that can be burned (destroyed).
1300  */
1301 abstract contract ERC721Burnable is Context, ERC721 {
1302     /**
1303      * @dev Burns `tokenId`. See {ERC721-_burn}.
1304      *
1305      * Requirements:
1306      *
1307      * - The caller must own `tokenId` or be an approved operator.
1308      */
1309     function burn(uint256 tokenId) public virtual {
1310         //solhint-disable-next-line max-line-length
1311         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1312         _burn(tokenId);
1313     }
1314 }
1315 
1316 // File: airdroppass.sol
1317 
1318 
1319 pragma solidity ^0.8.4;
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 contract ARABPUNKS is ERC721, Ownable, ERC721Burnable, Pausable  {
1330     
1331     using Counters for Counters.Counter;
1332 
1333     bool public contractStatus = true;
1334     string _baseTokenURI;
1335 
1336 
1337     Counters.Counter private _tokenIdCounter;
1338 
1339     modifier iswhiteListedUser() {
1340         require(whiteList[msg.sender], "Not a White listed User");
1341         _;
1342     }
1343 
1344     constructor(string memory baseURI) ERC721("ARABPUNKS", "ABP") {
1345          _baseTokenURI = baseURI;
1346     }
1347 
1348 
1349     mapping(address => bool) public whiteList;
1350     mapping(uint => string) _tokenURIs;
1351     mapping(address => bool) public addressMintedStatus;
1352 
1353 
1354 
1355     function _baseURI() internal view virtual override returns (string memory) {
1356             return _baseTokenURI;
1357         }
1358 
1359     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1360             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1361             string memory baseURI = _baseURI();
1362             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI,"/AlphaPass.json")) : "";
1363         }
1364 
1365     
1366     function setcontractStatus(bool _status) external onlyOwner {
1367         contractStatus = _status;
1368     }
1369 
1370     function safeMint(uint _tokenId) public iswhiteListedUser {
1371         require(contractStatus, "Currently contract is not active");
1372         require(addressMintedStatus[msg.sender] == false,"You have already minted");
1373         _mint(msg.sender, _tokenId);
1374         tokenURI(_tokenId);
1375         addressMintedStatus[msg.sender] = true;
1376      }
1377         
1378     function airdropMint(address[] memory _addresses, uint[] memory _tokenIds) external onlyOwner {
1379         require(contractStatus, "Currently contract is not active");
1380         require(_addresses.length == _tokenIds.length);
1381         uint arrayLength = _addresses.length;
1382         for(uint i = 0; i < arrayLength; ++i){
1383             _mint(_addresses[i], _tokenIds[i]);
1384             tokenURI(_tokenIds[i]);            
1385         }
1386     }
1387     
1388     function addWhilteListUser (address[] memory _whiteListUser) public onlyOwner {
1389        for ( uint i=0; i < _whiteListUser.length; ++i){
1390         whiteList[_whiteListUser[i]] = true;
1391         } 
1392     }
1393 
1394     function pause() public onlyOwner {
1395         _pause();
1396     }
1397 
1398     function unpause() public onlyOwner {
1399         _unpause();
1400     }
1401 }