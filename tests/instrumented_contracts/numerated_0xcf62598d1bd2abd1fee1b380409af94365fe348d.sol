1 // SPDX-License-Identifier: UNLICENSED
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Contract module that helps prevent reentrant calls to a function.
57  *
58  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
59  * available, which can be applied to functions to make sure there are no nested
60  * (reentrant) calls to them.
61  *
62  * Note that because there is a single `nonReentrant` guard, functions marked as
63  * `nonReentrant` may not call one another. This can be worked around by making
64  * those functions `private`, and then adding `external` `nonReentrant` entry
65  * points to them.
66  *
67  * TIP: If you would like to learn more about reentrancy and alternative ways
68  * to protect against it, check out our blog post
69  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
70  */
71 abstract contract ReentrancyGuard {
72     // Booleans are more expensive than uint256 or any type that takes up a full
73     // word because each write operation emits an extra SLOAD to first read the
74     // slot's contents, replace the bits taken up by the boolean, and then write
75     // back. This is the compiler's defense against contract upgrades and
76     // pointer aliasing, and it cannot be disabled.
77 
78     // The values being non-zero value makes deployment a bit more expensive,
79     // but in exchange the refund on every call to nonReentrant will be lower in
80     // amount. Since refunds are capped to a percentage of the total
81     // transaction's gas, it is best to keep them low in cases like this one, to
82     // increase the likelihood of the full refund coming into effect.
83     uint256 private constant _NOT_ENTERED = 1;
84     uint256 private constant _ENTERED = 2;
85 
86     uint256 private _status;
87 
88     constructor() {
89         _status = _NOT_ENTERED;
90     }
91 
92     /**
93      * @dev Prevents a contract from calling itself, directly or indirectly.
94      * Calling a `nonReentrant` function from another `nonReentrant`
95      * function is not supported. It is possible to prevent this from happening
96      * by making the `nonReentrant` function external, and making it call a
97      * `private` function that does the actual work.
98      */
99     modifier nonReentrant() {
100         // On the first call to nonReentrant, _notEntered will be true
101         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
102 
103         // Any calls to nonReentrant after this point will fail
104         _status = _ENTERED;
105 
106         _;
107 
108         // By storing the original value once again, a refund is triggered (see
109         // https://eips.ethereum.org/EIPS/eip-2200)
110         _status = _NOT_ENTERED;
111     }
112 }
113 
114 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
182 }
183 
184 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @dev Contract module which provides a basic access control mechanism, where
221  * there is an account (an owner) that can be granted exclusive access to
222  * specific functions.
223  *
224  * By default, the owner account will be the one that deploys the contract. This
225  * can later be changed with {transferOwnership}.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 abstract contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor() {
240         _transferOwnership(_msgSender());
241     }
242 
243     /**
244      * @dev Returns the address of the current owner.
245      */
246     function owner() public view virtual returns (address) {
247         return _owner;
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         require(owner() == _msgSender(), "Ownable: caller is not the owner");
255         _;
256     }
257 
258     /**
259      * @dev Leaves the contract without owner. It will not be possible to call
260      * `onlyOwner` functions anymore. Can only be called by the current owner.
261      *
262      * NOTE: Renouncing ownership will leave the contract without an owner,
263      * thereby removing any functionality that is only available to the owner.
264      */
265     function renounceOwnership() public virtual onlyOwner {
266         _transferOwnership(address(0));
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Can only be called by the current owner.
272      */
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         _transferOwnership(newOwner);
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Internal function without access restriction.
281      */
282     function _transferOwnership(address newOwner) internal virtual {
283         address oldOwner = _owner;
284         _owner = newOwner;
285         emit OwnershipTransferred(oldOwner, newOwner);
286     }
287 }
288 
289 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
290 
291 
292 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
293 
294 pragma solidity ^0.8.1;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      *
317      * [IMPORTANT]
318      * ====
319      * You shouldn't rely on `isContract` to protect against flash loan attacks!
320      *
321      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
322      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
323      * constructor.
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize/address.code.length, which returns 0
328         // for contracts in construction, since the code is only stored at the end
329         // of the constructor execution.
330 
331         return account.code.length > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         (bool success, ) = recipient.call{value: amount}("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain `call` is an unsafe replacement for a function call: use this
360      * function instead.
361      *
362      * If `target` reverts with a revert reason, it is bubbled up by this
363      * function (like regular Solidity function calls).
364      *
365      * Returns the raw returned data. To convert to the expected return value,
366      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
367      *
368      * Requirements:
369      *
370      * - `target` must be a contract.
371      * - calling `target` with `data` must not revert.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(address(this).balance >= value, "Address: insufficient balance for call");
425         require(isContract(target), "Address: call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.call{value: value}(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
438         return functionStaticCall(target, data, "Address: low-level static call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.staticcall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
487      * revert reason using the provided one.
488      *
489      * _Available since v4.3._
490      */
491     function verifyCallResult(
492         bool success,
493         bytes memory returndata,
494         string memory errorMessage
495     ) internal pure returns (bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 assembly {
504                     let returndata_size := mload(returndata)
505                     revert(add(32, returndata), returndata_size)
506                 }
507             } else {
508                 revert(errorMessage);
509             }
510         }
511     }
512 }
513 
514 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @title ERC721 token receiver interface
523  * @dev Interface for any contract that wants to support safeTransfers
524  * from ERC721 asset contracts.
525  */
526 interface IERC721Receiver {
527     /**
528      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
529      * by `operator` from `from`, this function is called.
530      *
531      * It must return its Solidity selector to confirm the token transfer.
532      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
533      *
534      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
535      */
536     function onERC721Received(
537         address operator,
538         address from,
539         uint256 tokenId,
540         bytes calldata data
541     ) external returns (bytes4);
542 }
543 
544 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Interface of the ERC165 standard, as defined in the
553  * https://eips.ethereum.org/EIPS/eip-165[EIP].
554  *
555  * Implementers can declare support of contract interfaces, which can then be
556  * queried by others ({ERC165Checker}).
557  *
558  * For an implementation, see {ERC165}.
559  */
560 interface IERC165 {
561     /**
562      * @dev Returns true if this contract implements the interface defined by
563      * `interfaceId`. See the corresponding
564      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
565      * to learn more about how these ids are created.
566      *
567      * This function call must use less than 30 000 gas.
568      */
569     function supportsInterface(bytes4 interfaceId) external view returns (bool);
570 }
571 
572 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Implementation of the {IERC165} interface.
582  *
583  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
584  * for the additional interface id that will be supported. For example:
585  *
586  * ```solidity
587  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
589  * }
590  * ```
591  *
592  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
593  */
594 abstract contract ERC165 is IERC165 {
595     /**
596      * @dev See {IERC165-supportsInterface}.
597      */
598     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599         return interfaceId == type(IERC165).interfaceId;
600     }
601 }
602 
603 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @dev Required interface of an ERC721 compliant contract.
613  */
614 interface IERC721 is IERC165 {
615     /**
616      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
622      */
623     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
627      */
628     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
629 
630     /**
631      * @dev Returns the number of tokens in ``owner``'s account.
632      */
633     function balanceOf(address owner) external view returns (uint256 balance);
634 
635     /**
636      * @dev Returns the owner of the `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function ownerOf(uint256 tokenId) external view returns (address owner);
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Returns the account approved for `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function getApproved(uint256 tokenId) external view returns (address operator);
707 
708     /**
709      * @dev Approve or remove `operator` as an operator for the caller.
710      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
711      *
712      * Requirements:
713      *
714      * - The `operator` cannot be the caller.
715      *
716      * Emits an {ApprovalForAll} event.
717      */
718     function setApprovalForAll(address operator, bool _approved) external;
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 
727     /**
728      * @dev Safely transfers `tokenId` token from `from` to `to`.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must exist and be owned by `from`.
735      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes calldata data
745     ) external;
746 }
747 
748 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
749 
750 
751 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
758  * @dev See https://eips.ethereum.org/EIPS/eip-721
759  */
760 interface IERC721Metadata is IERC721 {
761     /**
762      * @dev Returns the token collection name.
763      */
764     function name() external view returns (string memory);
765 
766     /**
767      * @dev Returns the token collection symbol.
768      */
769     function symbol() external view returns (string memory);
770 
771     /**
772      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
773      */
774     function tokenURI(uint256 tokenId) external view returns (string memory);
775 }
776 
777 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
778 
779 
780 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 
785 
786 
787 
788 
789 
790 
791 /**
792  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
793  * the Metadata extension, but not including the Enumerable extension, which is available separately as
794  * {ERC721Enumerable}.
795  */
796 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
797     using Address for address;
798     using Strings for uint256;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to owner address
807     mapping(uint256 => address) private _owners;
808 
809     // Mapping owner address to token count
810     mapping(address => uint256) private _balances;
811 
812     // Mapping from token ID to approved address
813     mapping(uint256 => address) private _tokenApprovals;
814 
815     // Mapping from owner to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     /**
819      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
820      */
821     constructor(string memory name_, string memory symbol_) {
822         _name = name_;
823         _symbol = symbol_;
824     }
825 
826     /**
827      * @dev See {IERC165-supportsInterface}.
828      */
829     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
830         return
831             interfaceId == type(IERC721).interfaceId ||
832             interfaceId == type(IERC721Metadata).interfaceId ||
833             super.supportsInterface(interfaceId);
834     }
835 
836     /**
837      * @dev See {IERC721-balanceOf}.
838      */
839     function balanceOf(address owner) public view virtual override returns (uint256) {
840         require(owner != address(0), "ERC721: balance query for the zero address");
841         return _balances[owner];
842     }
843 
844     /**
845      * @dev See {IERC721-ownerOf}.
846      */
847     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
848         address owner = _owners[tokenId];
849         require(owner != address(0), "ERC721: owner query for nonexistent token");
850         return owner;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-name}.
855      */
856     function name() public view virtual override returns (string memory) {
857         return _name;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-symbol}.
862      */
863     function symbol() public view virtual override returns (string memory) {
864         return _symbol;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-tokenURI}.
869      */
870     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
871         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
872 
873         string memory baseURI = _baseURI();
874         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
875     }
876 
877     /**
878      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
879      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
880      * by default, can be overridden in child contracts.
881      */
882     function _baseURI() internal view virtual returns (string memory) {
883         return "";
884     }
885 
886     /**
887      * @dev See {IERC721-approve}.
888      */
889     function approve(address to, uint256 tokenId) public virtual override {
890         address owner = ERC721.ownerOf(tokenId);
891         require(to != owner, "ERC721: approval to current owner");
892 
893         require(
894             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
895             "ERC721: approve caller is not owner nor approved for all"
896         );
897 
898         _approve(to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-getApproved}.
903      */
904     function getApproved(uint256 tokenId) public view virtual override returns (address) {
905         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
906 
907         return _tokenApprovals[tokenId];
908     }
909 
910     /**
911      * @dev See {IERC721-setApprovalForAll}.
912      */
913     function setApprovalForAll(address operator, bool approved) public virtual override {
914         _setApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         //solhint-disable-next-line max-line-length
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
934 
935         _transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, "");
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
959         _safeTransfer(from, to, tokenId, _data);
960     }
961 
962     /**
963      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
964      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
965      *
966      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
967      *
968      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
969      * implement alternative mechanisms to perform token transfer, such as signature-based.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must exist and be owned by `from`.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeTransfer(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) internal virtual {
986         _transfer(from, to, tokenId);
987         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted (`_mint`),
996      * and stop existing when they are burned (`_burn`).
997      */
998     function _exists(uint256 tokenId) internal view virtual returns (bool) {
999         return _owners[tokenId] != address(0);
1000     }
1001 
1002     /**
1003      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1010         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1011         address owner = ERC721.ownerOf(tokenId);
1012         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1013     }
1014 
1015     /**
1016      * @dev Safely mints `tokenId` and transfers it to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must not exist.
1021      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeMint(address to, uint256 tokenId) internal virtual {
1026         _safeMint(to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1031      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1032      */
1033     function _safeMint(
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) internal virtual {
1038         _mint(to, tokenId);
1039         require(
1040             _checkOnERC721Received(address(0), to, tokenId, _data),
1041             "ERC721: transfer to non ERC721Receiver implementer"
1042         );
1043     }
1044 
1045     /**
1046      * @dev Mints `tokenId` and transfers it to `to`.
1047      *
1048      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must not exist.
1053      * - `to` cannot be the zero address.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 tokenId) internal virtual {
1058         require(to != address(0), "ERC721: mint to the zero address");
1059         require(!_exists(tokenId), "ERC721: token already minted");
1060 
1061         _beforeTokenTransfer(address(0), to, tokenId);
1062 
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(address(0), to, tokenId);
1067 
1068         _afterTokenTransfer(address(0), to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Destroys `tokenId`.
1073      * The approval is cleared when the token is burned.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _burn(uint256 tokenId) internal virtual {
1082         address owner = ERC721.ownerOf(tokenId);
1083 
1084         _beforeTokenTransfer(owner, address(0), tokenId);
1085 
1086         // Clear approvals
1087         _approve(address(0), tokenId);
1088 
1089         _balances[owner] -= 1;
1090         delete _owners[tokenId];
1091 
1092         emit Transfer(owner, address(0), tokenId);
1093 
1094         _afterTokenTransfer(owner, address(0), tokenId);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must be owned by `from`.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _transfer(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) internal virtual {
1113         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1114         require(to != address(0), "ERC721: transfer to the zero address");
1115 
1116         _beforeTokenTransfer(from, to, tokenId);
1117 
1118         // Clear approvals from the previous owner
1119         _approve(address(0), tokenId);
1120 
1121         _balances[from] -= 1;
1122         _balances[to] += 1;
1123         _owners[tokenId] = to;
1124 
1125         emit Transfer(from, to, tokenId);
1126 
1127         _afterTokenTransfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(address to, uint256 tokenId) internal virtual {
1136         _tokenApprovals[tokenId] = to;
1137         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Approve `operator` to operate on all of `owner` tokens
1142      *
1143      * Emits a {ApprovalForAll} event.
1144      */
1145     function _setApprovalForAll(
1146         address owner,
1147         address operator,
1148         bool approved
1149     ) internal virtual {
1150         require(owner != operator, "ERC721: approve to caller");
1151         _operatorApprovals[owner][operator] = approved;
1152         emit ApprovalForAll(owner, operator, approved);
1153     }
1154 
1155     /**
1156      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1157      * The call is not executed if the target address is not a contract.
1158      *
1159      * @param from address representing the previous owner of the given token ID
1160      * @param to target address that will receive the tokens
1161      * @param tokenId uint256 ID of the token to be transferred
1162      * @param _data bytes optional data to send along with the call
1163      * @return bool whether the call correctly returned the expected magic value
1164      */
1165     function _checkOnERC721Received(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) private returns (bool) {
1171         if (to.isContract()) {
1172             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1173                 return retval == IERC721Receiver.onERC721Received.selector;
1174             } catch (bytes memory reason) {
1175                 if (reason.length == 0) {
1176                     revert("ERC721: transfer to non ERC721Receiver implementer");
1177                 } else {
1178                     assembly {
1179                         revert(add(32, reason), mload(reason))
1180                     }
1181                 }
1182             }
1183         } else {
1184             return true;
1185         }
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before any token transfer. This includes minting
1190      * and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1195      * transferred to `to`.
1196      * - When `from` is zero, `tokenId` will be minted for `to`.
1197      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1198      * - `from` and `to` are never both zero.
1199      *
1200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1201      */
1202     function _beforeTokenTransfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Hook that is called after any transfer of tokens. This includes
1210      * minting and burning.
1211      *
1212      * Calling conditions:
1213      *
1214      * - when `from` and `to` are both non-zero.
1215      * - `from` and `to` are never both zero.
1216      *
1217      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1218      */
1219     function _afterTokenTransfer(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) internal virtual {}
1224 }
1225 
1226 // File: capeverse.sol
1227 
1228 
1229 pragma solidity 0.8.7;
1230 
1231 
1232 
1233 
1234 
1235 contract Capeverse is ERC721, Ownable, ReentrancyGuard {
1236 
1237     using Address for address;
1238     using Strings for uint256;
1239     using Counters for Counters.Counter;
1240 
1241     Counters.Counter private _tokenIdTracker;
1242 
1243     string public baseURI;
1244     string public baseExtension = ".json";
1245 
1246     uint256 public presaleMintPrice = 0.01 ether;
1247     uint256 public mintPrice = 0.029 ether;
1248     uint256 public maxSupply = 5551;
1249 
1250     uint256 internal constant icyHills = 793;
1251     uint256 public totalMintedIcy = 0;
1252 
1253     uint256 internal constant bananaParadise = 1586;
1254     uint256 public totalMintedBanana = 793;
1255 
1256     uint256 internal constant mysteriousMeadows = 2379;
1257     uint256 public totalMintedMeadows = 1586;
1258 
1259     uint256 internal constant sandyLanding = 3172;
1260     uint256 public totalMintedSandy = 2379;
1261 
1262     uint256 internal constant strangeTown = 3965;
1263     uint256 public totalMintedStrange = 3172;
1264 
1265     uint256 internal constant hellishHollows = 4758;
1266     uint256 public totalMintedHollows = 3965;
1267     
1268     uint256 internal constant theWasteLand = 5551;
1269     uint256 public totalMintedWaste = 4758;
1270 
1271     mapping(uint256 => bool) public coolApeMinted;
1272     IERC721 public coolApeClub = IERC721(0x01A6FA5769b13302E82F1385e18BAEf7e913d0a7);
1273 
1274     bool public whitelistOpen = true;
1275 
1276     constructor(string memory _initBaseURI) ERC721("Capeverse", "Capeverse")
1277     {
1278         setBaseURI(_initBaseURI);
1279     }
1280 
1281     // ===== Modifier =====
1282     function _onlySender() private view {
1283         require(msg.sender == tx.origin);
1284     }
1285 
1286     modifier onlySender {
1287         _onlySender();
1288         _;
1289     }
1290 
1291     modifier whitelistIsOpen {
1292         require(whitelistOpen == true);
1293         _;
1294     }
1295 
1296     modifier whitelistIsClosed {
1297         require(whitelistOpen == false);
1298         _;
1299     }
1300 
1301     function flipSale() public onlyOwner
1302     {
1303         whitelistOpen = !whitelistOpen;
1304     }
1305 
1306     function changePresalePrice(uint256 newPrice) public onlyOwner
1307     {
1308         presaleMintPrice = (newPrice * 10 ** 18);
1309     }
1310 
1311     function changeMainsalePrice(uint256 newPrice) public onlyOwner
1312     {
1313         mintPrice = (newPrice * 10 ** 18);
1314     }
1315 
1316     function coolApeMint(uint256 islandNumber, uint256[] memory tokenIds, uint256 amountToMint) public payable nonReentrant onlySender whitelistIsOpen
1317     {      
1318         require(msg.value >= (presaleMintPrice * amountToMint), "Minting a NFT Costs 0.01 Ether Each!");
1319         require(tokenIds.length == amountToMint);
1320 
1321         for(uint256 i=0;i<tokenIds.length; i++)
1322         {
1323             require(coolApeClub.ownerOf(tokenIds[i]) == msg.sender);
1324             require(coolApeMinted[tokenIds[i]] == false);
1325         }
1326 
1327         if(islandNumber == 1)
1328         {
1329             require((totalMintedIcy + amountToMint) <= icyHills);
1330             for(uint256 i=0;i<amountToMint;i++)
1331             {
1332                 _tokenIdTracker.increment();
1333                 totalMintedIcy++;
1334                 _safeMint(msg.sender, totalMintedIcy);
1335             }
1336         }
1337         else if(islandNumber == 2)
1338         {
1339             require((totalMintedBanana + amountToMint) <= bananaParadise);
1340             for(uint256 i=0;i<amountToMint;i++)
1341             {
1342                 _tokenIdTracker.increment();
1343                 totalMintedBanana++;
1344                 _safeMint(msg.sender, totalMintedBanana);
1345             }
1346         }
1347         else if(islandNumber == 3)
1348         {
1349             require((totalMintedMeadows + amountToMint) <= mysteriousMeadows);
1350             for(uint256 i=0;i<amountToMint;i++)
1351             {
1352                 _tokenIdTracker.increment();
1353                 totalMintedMeadows++;
1354                 _safeMint(msg.sender, totalMintedMeadows);
1355             }
1356         }
1357         else if(islandNumber == 4)
1358         {
1359             require((totalMintedSandy + amountToMint) <= sandyLanding);
1360             for(uint256 i=0;i<amountToMint;i++)
1361             {
1362                 _tokenIdTracker.increment();
1363                 totalMintedSandy++;
1364                 _safeMint(msg.sender, totalMintedSandy);
1365             }
1366         }
1367         else if(islandNumber == 5)
1368         {
1369             require((totalMintedStrange + amountToMint) <= strangeTown);
1370             for(uint256 i=0;i<amountToMint;i++)
1371             {
1372                 _tokenIdTracker.increment();
1373                 totalMintedStrange++;
1374                 _safeMint(msg.sender, totalMintedStrange);
1375             }
1376         }
1377         else if(islandNumber == 6)
1378         {
1379             require((totalMintedHollows + amountToMint) <= hellishHollows);
1380             for(uint256 i=0;i<amountToMint;i++)
1381             {
1382                 _tokenIdTracker.increment();
1383                 totalMintedHollows++;
1384                 _safeMint(msg.sender, totalMintedHollows);
1385             }
1386         }
1387         else if(islandNumber == 7)
1388         {
1389             require((totalMintedWaste + amountToMint) <= theWasteLand);
1390             for(uint256 i=0;i<amountToMint;i++)
1391             {
1392                 _tokenIdTracker.increment();
1393                 totalMintedWaste++;
1394                 _safeMint(msg.sender, totalMintedWaste);
1395             }
1396         }
1397 
1398         for(uint256 i=0;i<tokenIds.length; i++)
1399         {
1400             coolApeMinted[tokenIds[i]] = true;
1401         }
1402 
1403     }
1404 
1405     function publicMint(uint256 islandNumber, uint256 amountToMint) public payable nonReentrant onlySender whitelistIsClosed
1406     {      
1407         require(msg.value >= (mintPrice * amountToMint), "Minting a NFT Costs 0.029 Ether Each!");
1408 
1409         if(islandNumber == 1)
1410         {
1411             require((totalMintedIcy + amountToMint) <= icyHills);
1412             for(uint256 i=0;i<amountToMint;i++)
1413             {
1414                 
1415                 _tokenIdTracker.increment();
1416                 totalMintedIcy++;
1417                 _safeMint(msg.sender, totalMintedIcy);
1418             }
1419         }
1420         else if(islandNumber == 2)
1421         {
1422             require((totalMintedBanana + amountToMint) <= bananaParadise);
1423             for(uint256 i=0;i<amountToMint;i++)
1424             {
1425                 
1426                 _tokenIdTracker.increment();
1427                 totalMintedBanana++;
1428                 _safeMint(msg.sender, totalMintedBanana);
1429             }
1430         }
1431         else if(islandNumber == 3)
1432         {
1433             require((totalMintedMeadows + amountToMint) <= mysteriousMeadows);
1434             for(uint256 i=0;i<amountToMint;i++)
1435             {
1436                 
1437                 _tokenIdTracker.increment();
1438                 totalMintedMeadows++;
1439                 _safeMint(msg.sender, totalMintedMeadows);
1440             }
1441         }
1442         else if(islandNumber == 4)
1443         {
1444             require((totalMintedSandy + amountToMint) <= sandyLanding);
1445             for(uint256 i=0;i<amountToMint;i++)
1446             {
1447                 
1448                 _tokenIdTracker.increment();
1449                 totalMintedSandy++;
1450                 _safeMint(msg.sender, totalMintedSandy);
1451             }
1452         }
1453         else if(islandNumber == 5)
1454         {
1455             require((totalMintedStrange + amountToMint) <= strangeTown);
1456             for(uint256 i=0;i<amountToMint;i++)
1457             {
1458                 
1459                 _tokenIdTracker.increment();
1460                 totalMintedStrange++;
1461                 _safeMint(msg.sender, totalMintedStrange);
1462             }
1463         }
1464         else if(islandNumber == 6)
1465         {
1466             require((totalMintedHollows + amountToMint) <= hellishHollows);
1467             for(uint256 i=0;i<amountToMint;i++)
1468             {
1469                 
1470                 _tokenIdTracker.increment();
1471                 totalMintedHollows++;
1472                 _safeMint(msg.sender, totalMintedHollows);
1473             }
1474         }
1475         else if(islandNumber == 7)
1476         {
1477             require((totalMintedWaste + amountToMint) <= theWasteLand);
1478             for(uint256 i=0;i<amountToMint;i++)
1479             {
1480                 
1481                 _tokenIdTracker.increment();
1482                 totalMintedWaste++;
1483                 _safeMint(msg.sender, totalMintedWaste);
1484             }
1485         }
1486 
1487 
1488     }
1489 
1490     function _withdraw(address payable address_, uint256 amount_) internal {
1491         (bool success, ) = payable(address_).call{value: amount_}("");
1492         require(success, "Transfer failed");
1493     }
1494 
1495     function withdrawEther() external onlyOwner {
1496         _withdraw(payable(msg.sender), address(this).balance);
1497     }
1498 
1499     function withdrawEtherTo(address payable to_) external onlyOwner {
1500         _withdraw(to_, address(this).balance);
1501     }
1502     
1503     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1504         baseURI = _newBaseURI;
1505     }
1506     function _baseURI() internal view virtual override returns (string memory) {
1507         return baseURI;
1508     }   
1509     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1510     {
1511         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1512 
1513         string memory currentBaseURI = _baseURI();
1514         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1515     }
1516     function totalSupply() public view returns (uint256) {
1517             return _tokenIdTracker.current();
1518     }
1519 
1520 
1521     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
1522         uint256 _balance = balanceOf(address_);
1523         uint256[] memory _tokens = new uint256[] (_balance);
1524         uint256 _index;
1525         uint256 _loopThrough = totalSupply();
1526         for (uint256 i = 0; i < _loopThrough; i++) {
1527             bool _exists = _exists(i);
1528             if (_exists) {
1529                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
1530             }
1531             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
1532         }
1533         return _tokens;
1534     }
1535 
1536     function walletOfOwnerApes(address address_) public view returns (uint256[] memory) {
1537         uint256 _balance = coolApeClub.balanceOf(address_);
1538         if (_balance == 0) return new uint256[](0);
1539 
1540         uint256[] memory _tokens = new uint256[] (_balance);
1541         uint256 _index;
1542 
1543         for (uint256 i = 0; i < 5555; i++) {
1544             if (coolApeClub.ownerOf(i) == address_) {
1545                 _tokens[_index] = i; _index++;
1546             }
1547         }
1548         return _tokens;
1549     }
1550 }