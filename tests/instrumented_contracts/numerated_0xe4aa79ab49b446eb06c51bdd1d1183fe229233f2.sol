1 // SPDX-License-Identifier: MIT
2 
3 // ███╗░░░███╗███████╗████████╗░█████╗░███████╗██╗░██████╗░██╗░░░██╗██████╗░███████╗
4 // ████╗░████║██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║██╔════╝░██║░░░██║██╔══██╗██╔════╝
5 // ██╔████╔██║█████╗░░░░░██║░░░███████║█████╗░░██║██║░░██╗░██║░░░██║██████╔╝█████╗░░
6 // ██║╚██╔╝██║██╔══╝░░░░░██║░░░██╔══██║██╔══╝░░██║██║░░╚██╗██║░░░██║██╔══██╗██╔══╝░░
7 // ██║░╚═╝░██║███████╗░░░██║░░░██║░░██║██║░░░░░██║╚██████╔╝╚██████╔╝██║░░██║███████╗
8 // ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝░╚═════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝
9 
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Counters.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @title Counters
85  * @author Matt Condon (@shrugs)
86  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
87  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
88  *
89  * Include with `using Counters for Counters.Counter;`
90  */
91 library Counters {
92     struct Counter {
93         // This variable should never be directly accessed by users of the library: interactions must be restricted to
94         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
95         // this feature: see https://github.com/ethereum/solidity/issues/4637
96         uint256 _value; // default: 0
97     }
98 
99     function current(Counter storage counter) internal view returns (uint256) {
100         return counter._value;
101     }
102 
103     function increment(Counter storage counter) internal {
104         unchecked {
105             counter._value += 1;
106         }
107     }
108 
109     function decrement(Counter storage counter) internal {
110         uint256 value = counter._value;
111         require(value > 0, "Counter: decrement overflow");
112         unchecked {
113             counter._value = value - 1;
114         }
115     }
116 
117     function reset(Counter storage counter) internal {
118         counter._value = 0;
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Strings.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
137      */
138     function toString(uint256 value) internal pure returns (string memory) {
139         // Inspired by OraclizeAPI's implementation - MIT licence
140         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
141 
142         if (value == 0) {
143             return "0";
144         }
145         uint256 temp = value;
146         uint256 digits;
147         while (temp != 0) {
148             digits++;
149             temp /= 10;
150         }
151         bytes memory buffer = new bytes(digits);
152         while (value != 0) {
153             digits -= 1;
154             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
155             value /= 10;
156         }
157         return string(buffer);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
162      */
163     function toHexString(uint256 value) internal pure returns (string memory) {
164         if (value == 0) {
165             return "0x00";
166         }
167         uint256 temp = value;
168         uint256 length = 0;
169         while (temp != 0) {
170             length++;
171             temp >>= 8;
172         }
173         return toHexString(value, length);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
178      */
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Context.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/access/Ownable.sol
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor() {
248         _transferOwnership(_msgSender());
249     }
250 
251     /**
252      * @dev Returns the address of the current owner.
253      */
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257 
258     /**
259      * @dev Throws if called by any account other than the owner.
260      */
261     modifier onlyOwner() {
262         require(owner() == _msgSender(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     /**
267      * @dev Leaves the contract without owner. It will not be possible to call
268      * `onlyOwner` functions anymore. Can only be called by the current owner.
269      *
270      * NOTE: Renouncing ownership will leave the contract without an owner,
271      * thereby removing any functionality that is only available to the owner.
272      */
273     function renounceOwnership() public virtual onlyOwner {
274         _transferOwnership(address(0));
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Can only be called by the current owner.
280      */
281     function transferOwnership(address newOwner) public virtual onlyOwner {
282         require(newOwner != address(0), "Ownable: new owner is the zero address");
283         _transferOwnership(newOwner);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Internal function without access restriction.
289      */
290     function _transferOwnership(address newOwner) internal virtual {
291         address oldOwner = _owner;
292         _owner = newOwner;
293         emit OwnershipTransferred(oldOwner, newOwner);
294     }
295 }
296 
297 // File: @openzeppelin/contracts/security/Pausable.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Contract module which allows children to implement an emergency stop
307  * mechanism that can be triggered by an authorized account.
308  *
309  * This module is used through inheritance. It will make available the
310  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
311  * the functions of your contract. Note that they will not be pausable by
312  * simply including this module, only once the modifiers are put in place.
313  */
314 abstract contract Pausable is Context {
315     /**
316      * @dev Emitted when the pause is triggered by `account`.
317      */
318     event Paused(address account);
319 
320     /**
321      * @dev Emitted when the pause is lifted by `account`.
322      */
323     event Unpaused(address account);
324 
325     bool private _paused;
326 
327     /**
328      * @dev Initializes the contract in unpaused state.
329      */
330     constructor() {
331         _paused = false;
332     }
333 
334     /**
335      * @dev Returns true if the contract is paused, and false otherwise.
336      */
337     function paused() public view virtual returns (bool) {
338         return _paused;
339     }
340 
341     /**
342      * @dev Modifier to make a function callable only when the contract is not paused.
343      *
344      * Requirements:
345      *
346      * - The contract must not be paused.
347      */
348     modifier whenNotPaused() {
349         require(!paused(), "Pausable: paused");
350         _;
351     }
352 
353     /**
354      * @dev Modifier to make a function callable only when the contract is paused.
355      *
356      * Requirements:
357      *
358      * - The contract must be paused.
359      */
360     modifier whenPaused() {
361         require(paused(), "Pausable: not paused");
362         _;
363     }
364 
365     /**
366      * @dev Triggers stopped state.
367      *
368      * Requirements:
369      *
370      * - The contract must not be paused.
371      */
372     function _pause() internal virtual whenNotPaused {
373         _paused = true;
374         emit Paused(_msgSender());
375     }
376 
377     /**
378      * @dev Returns to normal state.
379      *
380      * Requirements:
381      *
382      * - The contract must be paused.
383      */
384     function _unpause() internal virtual whenPaused {
385         _paused = false;
386         emit Unpaused(_msgSender());
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Address.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
394 
395 pragma solidity ^0.8.1;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      *
418      * [IMPORTANT]
419      * ====
420      * You shouldn't rely on `isContract` to protect against flash loan attacks!
421      *
422      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
423      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
424      * constructor.
425      * ====
426      */
427     function isContract(address account) internal view returns (bool) {
428         // This method relies on extcodesize/address.code.length, which returns 0
429         // for contracts in construction, since the code is only stored at the end
430         // of the constructor execution.
431 
432         return account.code.length > 0;
433     }
434 
435     /**
436      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
437      * `recipient`, forwarding all available gas and reverting on errors.
438      *
439      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
440      * of certain opcodes, possibly making contracts go over the 2300 gas limit
441      * imposed by `transfer`, making them unable to receive funds via
442      * `transfer`. {sendValue} removes this limitation.
443      *
444      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
445      *
446      * IMPORTANT: because control is transferred to `recipient`, care must be
447      * taken to not create reentrancy vulnerabilities. Consider using
448      * {ReentrancyGuard} or the
449      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
450      */
451     function sendValue(address payable recipient, uint256 amount) internal {
452         require(address(this).balance >= amount, "Address: insufficient balance");
453 
454         (bool success, ) = recipient.call{value: amount}("");
455         require(success, "Address: unable to send value, recipient may have reverted");
456     }
457 
458     /**
459      * @dev Performs a Solidity function call using a low level `call`. A
460      * plain `call` is an unsafe replacement for a function call: use this
461      * function instead.
462      *
463      * If `target` reverts with a revert reason, it is bubbled up by this
464      * function (like regular Solidity function calls).
465      *
466      * Returns the raw returned data. To convert to the expected return value,
467      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
468      *
469      * Requirements:
470      *
471      * - `target` must be a contract.
472      * - calling `target` with `data` must not revert.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionCall(target, data, "Address: low-level call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
482      * `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, 0, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but also transferring `value` wei to `target`.
497      *
498      * Requirements:
499      *
500      * - the calling contract must have an ETH balance of at least `value`.
501      * - the called Solidity function must be `payable`.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
515      * with `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCallWithValue(
520         address target,
521         bytes memory data,
522         uint256 value,
523         string memory errorMessage
524     ) internal returns (bytes memory) {
525         require(address(this).balance >= value, "Address: insufficient balance for call");
526         require(isContract(target), "Address: call to non-contract");
527 
528         (bool success, bytes memory returndata) = target.call{value: value}(data);
529         return verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a static call.
535      *
536      * _Available since v3.3._
537      */
538     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
539         return functionStaticCall(target, data, "Address: low-level static call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal view returns (bytes memory) {
553         require(isContract(target), "Address: static call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.staticcall(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a delegate call.
572      *
573      * _Available since v3.4._
574      */
575     function functionDelegateCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(isContract(target), "Address: delegate call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.delegatecall(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
588      * revert reason using the provided one.
589      *
590      * _Available since v4.3._
591      */
592     function verifyCallResult(
593         bool success,
594         bytes memory returndata,
595         string memory errorMessage
596     ) internal pure returns (bytes memory) {
597         if (success) {
598             return returndata;
599         } else {
600             // Look for revert reason and bubble it up if present
601             if (returndata.length > 0) {
602                 // The easiest way to bubble the revert reason is using memory via assembly
603 
604                 assembly {
605                     let returndata_size := mload(returndata)
606                     revert(add(32, returndata), returndata_size)
607                 }
608             } else {
609                 revert(errorMessage);
610             }
611         }
612     }
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
616 
617 
618 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @title ERC721 token receiver interface
624  * @dev Interface for any contract that wants to support safeTransfers
625  * from ERC721 asset contracts.
626  */
627 interface IERC721Receiver {
628     /**
629      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
630      * by `operator` from `from`, this function is called.
631      *
632      * It must return its Solidity selector to confirm the token transfer.
633      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
634      *
635      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
636      */
637     function onERC721Received(
638         address operator,
639         address from,
640         uint256 tokenId,
641         bytes calldata data
642     ) external returns (bytes4);
643 }
644 
645 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Interface of the ERC165 standard, as defined in the
654  * https://eips.ethereum.org/EIPS/eip-165[EIP].
655  *
656  * Implementers can declare support of contract interfaces, which can then be
657  * queried by others ({ERC165Checker}).
658  *
659  * For an implementation, see {ERC165}.
660  */
661 interface IERC165 {
662     /**
663      * @dev Returns true if this contract implements the interface defined by
664      * `interfaceId`. See the corresponding
665      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
666      * to learn more about how these ids are created.
667      *
668      * This function call must use less than 30 000 gas.
669      */
670     function supportsInterface(bytes4 interfaceId) external view returns (bool);
671 }
672 
673 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 
681 /**
682  * @dev Implementation of the {IERC165} interface.
683  *
684  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
685  * for the additional interface id that will be supported. For example:
686  *
687  * ```solidity
688  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
689  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
690  * }
691  * ```
692  *
693  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
694  */
695 abstract contract ERC165 is IERC165 {
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
700         return interfaceId == type(IERC165).interfaceId;
701     }
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 /**
713  * @dev Required interface of an ERC721 compliant contract.
714  */
715 interface IERC721 is IERC165 {
716     /**
717      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
718      */
719     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
720 
721     /**
722      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
723      */
724     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
725 
726     /**
727      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
728      */
729     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
730 
731     /**
732      * @dev Returns the number of tokens in ``owner``'s account.
733      */
734     function balanceOf(address owner) external view returns (uint256 balance);
735 
736     /**
737      * @dev Returns the owner of the `tokenId` token.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must exist.
742      */
743     function ownerOf(uint256 tokenId) external view returns (address owner);
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must exist and be owned by `from`.
753      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes calldata data
763     ) external;
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
767      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) external;
784 
785     /**
786      * @dev Transfers `tokenId` token from `from` to `to`.
787      *
788      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
796      *
797      * Emits a {Transfer} event.
798      */
799     function transferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
807      * The approval is cleared when the token is transferred.
808      *
809      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
810      *
811      * Requirements:
812      *
813      * - The caller must own the token or be an approved operator.
814      * - `tokenId` must exist.
815      *
816      * Emits an {Approval} event.
817      */
818     function approve(address to, uint256 tokenId) external;
819 
820     /**
821      * @dev Approve or remove `operator` as an operator for the caller.
822      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
823      *
824      * Requirements:
825      *
826      * - The `operator` cannot be the caller.
827      *
828      * Emits an {ApprovalForAll} event.
829      */
830     function setApprovalForAll(address operator, bool _approved) external;
831 
832     /**
833      * @dev Returns the account approved for `tokenId` token.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function getApproved(uint256 tokenId) external view returns (address operator);
840 
841     /**
842      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
843      *
844      * See {setApprovalForAll}
845      */
846     function isApprovedForAll(address owner, address operator) external view returns (bool);
847 }
848 
849 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
850 
851 
852 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 
857 /**
858  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
859  * @dev See https://eips.ethereum.org/EIPS/eip-721
860  */
861 interface IERC721Enumerable is IERC721 {
862     /**
863      * @dev Returns the total amount of tokens stored by the contract.
864      */
865     function totalSupply() external view returns (uint256);
866 
867     /**
868      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
869      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
870      */
871     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
872 
873     /**
874      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
875      * Use along with {totalSupply} to enumerate all tokens.
876      */
877     function tokenByIndex(uint256 index) external view returns (uint256);
878 }
879 
880 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
881 
882 
883 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 
888 /**
889  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
890  * @dev See https://eips.ethereum.org/EIPS/eip-721
891  */
892 interface IERC721Metadata is IERC721 {
893     /**
894      * @dev Returns the token collection name.
895      */
896     function name() external view returns (string memory);
897 
898     /**
899      * @dev Returns the token collection symbol.
900      */
901     function symbol() external view returns (string memory);
902 
903     /**
904      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
905      */
906     function tokenURI(uint256 tokenId) external view returns (string memory);
907 }
908 
909 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
910 
911 
912 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 
917 
918 
919 
920 
921 
922 
923 /**
924  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
925  * the Metadata extension, but not including the Enumerable extension, which is available separately as
926  * {ERC721Enumerable}.
927  */
928 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
929     using Address for address;
930     using Strings for uint256;
931 
932     // Token name
933     string private _name;
934 
935     // Token symbol
936     string private _symbol;
937 
938     // Mapping from token ID to owner address
939     mapping(uint256 => address) private _owners;
940 
941     // Mapping owner address to token count
942     mapping(address => uint256) private _balances;
943 
944     // Mapping from token ID to approved address
945     mapping(uint256 => address) private _tokenApprovals;
946 
947     // Mapping from owner to operator approvals
948     mapping(address => mapping(address => bool)) private _operatorApprovals;
949 
950     /**
951      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
952      */
953     constructor(string memory name_, string memory symbol_) {
954         _name = name_;
955         _symbol = symbol_;
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
962         return
963             interfaceId == type(IERC721).interfaceId ||
964             interfaceId == type(IERC721Metadata).interfaceId ||
965             super.supportsInterface(interfaceId);
966     }
967 
968     /**
969      * @dev See {IERC721-balanceOf}.
970      */
971     function balanceOf(address owner) public view virtual override returns (uint256) {
972         require(owner != address(0), "ERC721: balance query for the zero address");
973         return _balances[owner];
974     }
975 
976     /**
977      * @dev See {IERC721-ownerOf}.
978      */
979     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
980         address owner = _owners[tokenId];
981         require(owner != address(0), "ERC721: owner query for nonexistent token");
982         return owner;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-name}.
987      */
988     function name() public view virtual override returns (string memory) {
989         return _name;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-symbol}.
994      */
995     function symbol() public view virtual override returns (string memory) {
996         return _symbol;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-tokenURI}.
1001      */
1002     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1003         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1004 
1005         string memory baseURI = _baseURI();
1006         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1007     }
1008 
1009     /**
1010      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1011      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1012      * by default, can be overridden in child contracts.
1013      */
1014     function _baseURI() internal view virtual returns (string memory) {
1015         return "";
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-approve}.
1020      */
1021     function approve(address to, uint256 tokenId) public virtual override {
1022         address owner = ERC721.ownerOf(tokenId);
1023         require(to != owner, "ERC721: approval to current owner");
1024 
1025         require(
1026             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1027             "ERC721: approve caller is not owner nor approved for all"
1028         );
1029 
1030         _approve(to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-getApproved}.
1035      */
1036     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1037         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1038 
1039         return _tokenApprovals[tokenId];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-setApprovalForAll}.
1044      */
1045     function setApprovalForAll(address operator, bool approved) public virtual override {
1046         _setApprovalForAll(_msgSender(), operator, approved);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-isApprovedForAll}.
1051      */
1052     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1053         return _operatorApprovals[owner][operator];
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-transferFrom}.
1058      */
1059     function transferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) public virtual override {
1064         //solhint-disable-next-line max-line-length
1065         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1066 
1067         _transfer(from, to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) public virtual override {
1078         safeTransferFrom(from, to, tokenId, "");
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-safeTransferFrom}.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) public virtual override {
1090         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1091         _safeTransfer(from, to, tokenId, _data);
1092     }
1093 
1094     /**
1095      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1096      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1097      *
1098      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1099      *
1100      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1101      * implement alternative mechanisms to perform token transfer, such as signature-based.
1102      *
1103      * Requirements:
1104      *
1105      * - `from` cannot be the zero address.
1106      * - `to` cannot be the zero address.
1107      * - `tokenId` token must exist and be owned by `from`.
1108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _safeTransfer(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) internal virtual {
1118         _transfer(from, to, tokenId);
1119         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1120     }
1121 
1122     /**
1123      * @dev Returns whether `tokenId` exists.
1124      *
1125      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1126      *
1127      * Tokens start existing when they are minted (`_mint`),
1128      * and stop existing when they are burned (`_burn`).
1129      */
1130     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1131         return _owners[tokenId] != address(0);
1132     }
1133 
1134     /**
1135      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1136      *
1137      * Requirements:
1138      *
1139      * - `tokenId` must exist.
1140      */
1141     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1142         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1143         address owner = ERC721.ownerOf(tokenId);
1144         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1145     }
1146 
1147     /**
1148      * @dev Safely mints `tokenId` and transfers it to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `tokenId` must not exist.
1153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _safeMint(address to, uint256 tokenId) internal virtual {
1158         _safeMint(to, tokenId, "");
1159     }
1160 
1161     /**
1162      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1163      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1164      */
1165     function _safeMint(
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) internal virtual {
1170         _mint(to, tokenId);
1171         require(
1172             _checkOnERC721Received(address(0), to, tokenId, _data),
1173             "ERC721: transfer to non ERC721Receiver implementer"
1174         );
1175     }
1176 
1177     /**
1178      * @dev Mints `tokenId` and transfers it to `to`.
1179      *
1180      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must not exist.
1185      * - `to` cannot be the zero address.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _mint(address to, uint256 tokenId) internal virtual {
1190         require(to != address(0), "ERC721: mint to the zero address");
1191         require(!_exists(tokenId), "ERC721: token already minted");
1192 
1193         _beforeTokenTransfer(address(0), to, tokenId);
1194 
1195         _balances[to] += 1;
1196         _owners[tokenId] = to;
1197 
1198         emit Transfer(address(0), to, tokenId);
1199 
1200         _afterTokenTransfer(address(0), to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId) internal virtual {
1214         address owner = ERC721.ownerOf(tokenId);
1215 
1216         _beforeTokenTransfer(owner, address(0), tokenId);
1217 
1218         // Clear approvals
1219         _approve(address(0), tokenId);
1220 
1221         _balances[owner] -= 1;
1222         delete _owners[tokenId];
1223 
1224         emit Transfer(owner, address(0), tokenId);
1225 
1226         _afterTokenTransfer(owner, address(0), tokenId);
1227     }
1228 
1229     /**
1230      * @dev Transfers `tokenId` from `from` to `to`.
1231      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `tokenId` token must be owned by `from`.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _transfer(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) internal virtual {
1245         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1246         require(to != address(0), "ERC721: transfer to the zero address");
1247 
1248         _beforeTokenTransfer(from, to, tokenId);
1249 
1250         // Clear approvals from the previous owner
1251         _approve(address(0), tokenId);
1252 
1253         _balances[from] -= 1;
1254         _balances[to] += 1;
1255         _owners[tokenId] = to;
1256 
1257         emit Transfer(from, to, tokenId);
1258 
1259         _afterTokenTransfer(from, to, tokenId);
1260     }
1261 
1262     /**
1263      * @dev Approve `to` to operate on `tokenId`
1264      *
1265      * Emits a {Approval} event.
1266      */
1267     function _approve(address to, uint256 tokenId) internal virtual {
1268         _tokenApprovals[tokenId] = to;
1269         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1270     }
1271 
1272     /**
1273      * @dev Approve `operator` to operate on all of `owner` tokens
1274      *
1275      * Emits a {ApprovalForAll} event.
1276      */
1277     function _setApprovalForAll(
1278         address owner,
1279         address operator,
1280         bool approved
1281     ) internal virtual {
1282         require(owner != operator, "ERC721: approve to caller");
1283         _operatorApprovals[owner][operator] = approved;
1284         emit ApprovalForAll(owner, operator, approved);
1285     }
1286 
1287     /**
1288      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1289      * The call is not executed if the target address is not a contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) private returns (bool) {
1303         if (to.isContract()) {
1304             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1305                 return retval == IERC721Receiver.onERC721Received.selector;
1306             } catch (bytes memory reason) {
1307                 if (reason.length == 0) {
1308                     revert("ERC721: transfer to non ERC721Receiver implementer");
1309                 } else {
1310                     assembly {
1311                         revert(add(32, reason), mload(reason))
1312                     }
1313                 }
1314             }
1315         } else {
1316             return true;
1317         }
1318     }
1319 
1320     /**
1321      * @dev Hook that is called before any token transfer. This includes minting
1322      * and burning.
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` will be minted for `to`.
1329      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1330      * - `from` and `to` are never both zero.
1331      *
1332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1333      */
1334     function _beforeTokenTransfer(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) internal virtual {}
1339 
1340     /**
1341      * @dev Hook that is called after any transfer of tokens. This includes
1342      * minting and burning.
1343      *
1344      * Calling conditions:
1345      *
1346      * - when `from` and `to` are both non-zero.
1347      * - `from` and `to` are never both zero.
1348      *
1349      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1350      */
1351     function _afterTokenTransfer(
1352         address from,
1353         address to,
1354         uint256 tokenId
1355     ) internal virtual {}
1356 }
1357 
1358 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1359 
1360 
1361 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1362 
1363 pragma solidity ^0.8.0;
1364 
1365 
1366 
1367 /**
1368  * @title ERC721 Burnable Token
1369  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1370  */
1371 abstract contract ERC721Burnable is Context, ERC721 {
1372     /**
1373      * @dev Burns `tokenId`. See {ERC721-_burn}.
1374      *
1375      * Requirements:
1376      *
1377      * - The caller must own `tokenId` or be an approved operator.
1378      */
1379     function burn(uint256 tokenId) public virtual {
1380         //solhint-disable-next-line max-line-length
1381         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1382         _burn(tokenId);
1383     }
1384 }
1385 
1386 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1387 
1388 
1389 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1390 
1391 pragma solidity ^0.8.0;
1392 
1393 
1394 
1395 /**
1396  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1397  * enumerability of all the token ids in the contract as well as all token ids owned by each
1398  * account.
1399  */
1400 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1401     // Mapping from owner to list of owned token IDs
1402     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1403 
1404     // Mapping from token ID to index of the owner tokens list
1405     mapping(uint256 => uint256) private _ownedTokensIndex;
1406 
1407     // Array with all token ids, used for enumeration
1408     uint256[] private _allTokens;
1409 
1410     // Mapping from token id to position in the allTokens array
1411     mapping(uint256 => uint256) private _allTokensIndex;
1412 
1413     /**
1414      * @dev See {IERC165-supportsInterface}.
1415      */
1416     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1417         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1418     }
1419 
1420     /**
1421      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1422      */
1423     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1424         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1425         return _ownedTokens[owner][index];
1426     }
1427 
1428     /**
1429      * @dev See {IERC721Enumerable-totalSupply}.
1430      */
1431     function totalSupply() public view virtual override returns (uint256) {
1432         return _allTokens.length;
1433     }
1434 
1435     /**
1436      * @dev See {IERC721Enumerable-tokenByIndex}.
1437      */
1438     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1439         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1440         return _allTokens[index];
1441     }
1442 
1443     /**
1444      * @dev Hook that is called before any token transfer. This includes minting
1445      * and burning.
1446      *
1447      * Calling conditions:
1448      *
1449      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1450      * transferred to `to`.
1451      * - When `from` is zero, `tokenId` will be minted for `to`.
1452      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1453      * - `from` cannot be the zero address.
1454      * - `to` cannot be the zero address.
1455      *
1456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1457      */
1458     function _beforeTokenTransfer(
1459         address from,
1460         address to,
1461         uint256 tokenId
1462     ) internal virtual override {
1463         super._beforeTokenTransfer(from, to, tokenId);
1464 
1465         if (from == address(0)) {
1466             _addTokenToAllTokensEnumeration(tokenId);
1467         } else if (from != to) {
1468             _removeTokenFromOwnerEnumeration(from, tokenId);
1469         }
1470         if (to == address(0)) {
1471             _removeTokenFromAllTokensEnumeration(tokenId);
1472         } else if (to != from) {
1473             _addTokenToOwnerEnumeration(to, tokenId);
1474         }
1475     }
1476 
1477     /**
1478      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1479      * @param to address representing the new owner of the given token ID
1480      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1481      */
1482     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1483         uint256 length = ERC721.balanceOf(to);
1484         _ownedTokens[to][length] = tokenId;
1485         _ownedTokensIndex[tokenId] = length;
1486     }
1487 
1488     /**
1489      * @dev Private function to add a token to this extension's token tracking data structures.
1490      * @param tokenId uint256 ID of the token to be added to the tokens list
1491      */
1492     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1493         _allTokensIndex[tokenId] = _allTokens.length;
1494         _allTokens.push(tokenId);
1495     }
1496 
1497     /**
1498      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1499      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1500      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1501      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1502      * @param from address representing the previous owner of the given token ID
1503      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1504      */
1505     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1506         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1507         // then delete the last slot (swap and pop).
1508 
1509         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1510         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1511 
1512         // When the token to delete is the last token, the swap operation is unnecessary
1513         if (tokenIndex != lastTokenIndex) {
1514             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1515 
1516             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1517             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1518         }
1519 
1520         // This also deletes the contents at the last position of the array
1521         delete _ownedTokensIndex[tokenId];
1522         delete _ownedTokens[from][lastTokenIndex];
1523     }
1524 
1525     /**
1526      * @dev Private function to remove a token from this extension's token tracking data structures.
1527      * This has O(1) time complexity, but alters the order of the _allTokens array.
1528      * @param tokenId uint256 ID of the token to be removed from the tokens list
1529      */
1530     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1531         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1532         // then delete the last slot (swap and pop).
1533 
1534         uint256 lastTokenIndex = _allTokens.length - 1;
1535         uint256 tokenIndex = _allTokensIndex[tokenId];
1536 
1537         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1538         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1539         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1540         uint256 lastTokenId = _allTokens[lastTokenIndex];
1541 
1542         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1543         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1544 
1545         // This also deletes the contents at the last position of the array
1546         delete _allTokensIndex[tokenId];
1547         _allTokens.pop();
1548     }
1549 }
1550 
1551 // File: contracts/MetaFigure.sol
1552 
1553 
1554 
1555 pragma solidity ^0.8.4;
1556 
1557 
1558 
1559 
1560 
1561 
1562 
1563 
1564 interface InterfaceMetaFigure {
1565     function getOwnerOf(uint256 tokenId) external view returns (address owner);
1566 	function getTokenIds(address _owner) external view returns (uint[] memory);
1567 }
1568 
1569 contract MetaFigure is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable, ReentrancyGuard {
1570     using Counters for Counters.Counter;
1571 
1572     Counters.Counter private _tokenIdCounter;
1573     string baseURI;
1574     uint256 maxSupply = 9600;
1575     uint256 maxMint = 1;
1576     uint256 mintCost = 0 ether;
1577 
1578     constructor(
1579         string memory _name,
1580         string memory _symbol,
1581         string memory _initBaseURI,
1582 		uint256 _initMint
1583 	) ERC721(_name,_symbol) {
1584         _setBaseURI(_initBaseURI);
1585 		safeMint(_initMint);
1586 	}
1587 
1588     function _baseURI() internal view override returns (string memory) {
1589         return baseURI;
1590     }
1591 	
1592     function _setBaseURI(string memory _newBaseURI) public onlyOwner {
1593         baseURI = _newBaseURI;
1594     }
1595 
1596     function pause() public onlyOwner {
1597         _pause();
1598     }
1599 
1600     function unpause() public onlyOwner {
1601         _unpause();
1602     }
1603 
1604     function safeMint(uint256 amount) public payable nonReentrant whenNotPaused {
1605         uint256 supply = totalSupply();
1606         uint256 senderBalance = ERC721.balanceOf(msg.sender);
1607         require(amount > 0,"You have to mint at least 1.");
1608         require(supply + amount <= maxSupply,"Mint would exceed max supply.");
1609         if(msg.sender != owner())
1610         {
1611             require(amount <= maxMint,"Mint would exceed max mint allowance.");
1612             require(maxMint >= senderBalance + amount,"Mint would exceed max mint allowance.");
1613         }
1614         if(mintCost > 0 && msg.sender != owner())
1615         {
1616             require(msg.value >= mintCost * amount,"You did not send enough ether to mint.");
1617         }
1618         for (uint256 i = 1; i <= amount; i++) {
1619             _tokenIdCounter.increment();
1620             _safeMint(msg.sender, _tokenIdCounter.current());
1621         }
1622     }
1623 
1624     function changeMaxSupply(uint256 _maxSupply) public onlyOwner {
1625         maxSupply = _maxSupply;
1626     }
1627     
1628     function tokenURI(uint256 tokenId) public view override returns (string memory) 
1629     {
1630         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1631 
1632 		string memory _tokenId = Strings.toString(tokenId);
1633         string memory currentBaseURI = _baseURI();
1634 
1635         if (bytes(currentBaseURI).length == 0) {
1636             return _tokenId;
1637         }
1638 		
1639         if (bytes(_tokenId).length > 0) {
1640             return string(abi.encodePacked(currentBaseURI, _tokenId, ".json"));
1641         }
1642 
1643         return super.tokenURI(tokenId);
1644     }
1645 	
1646 	function getOwnerOf(uint256 tokenId) external view returns (address owner) {
1647         return (ownerOf(tokenId));
1648     }
1649 	
1650 	function getTokenIds(address _owner) external view returns (uint[] memory) {
1651         uint[] memory _tokensOfOwner = new uint[](ERC721.balanceOf(_owner));
1652         uint i;
1653 
1654         for (i=0;i<ERC721.balanceOf(_owner);i++){
1655             _tokensOfOwner[i] = ERC721Enumerable.tokenOfOwnerByIndex(_owner, i);
1656         }
1657         return (_tokensOfOwner);
1658     }    
1659 
1660     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1661         internal
1662         whenNotPaused
1663         override(ERC721, ERC721Enumerable)
1664     {
1665         super._beforeTokenTransfer(from, to, tokenId);
1666     }
1667 
1668     function supportsInterface(bytes4 interfaceId)
1669         public
1670         view
1671         override(ERC721, ERC721Enumerable)
1672         returns (bool)
1673     {
1674         return super.supportsInterface(interfaceId);
1675     }
1676 }