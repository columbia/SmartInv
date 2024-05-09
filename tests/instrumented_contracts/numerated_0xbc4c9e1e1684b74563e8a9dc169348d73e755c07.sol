1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Counters.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @title Counters
76  * @author Matt Condon (@shrugs)
77  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
78  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
79  *
80  * Include with `using Counters for Counters.Counter;`
81  */
82 library Counters {
83     struct Counter {
84         // This variable should never be directly accessed by users of the library: interactions must be restricted to
85         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
86         // this feature: see https://github.com/ethereum/solidity/issues/4637
87         uint256 _value; // default: 0
88     }
89 
90     function current(Counter storage counter) internal view returns (uint256) {
91         return counter._value;
92     }
93 
94     function increment(Counter storage counter) internal {
95         unchecked {
96             counter._value += 1;
97         }
98     }
99 
100     function decrement(Counter storage counter) internal {
101         uint256 value = counter._value;
102         require(value > 0, "Counter: decrement overflow");
103         unchecked {
104             counter._value = value - 1;
105         }
106     }
107 
108     function reset(Counter storage counter) internal {
109         counter._value = 0;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Strings.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
128      */
129     function toString(uint256 value) internal pure returns (string memory) {
130         // Inspired by OraclizeAPI's implementation - MIT licence
131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
132 
133         if (value == 0) {
134             return "0";
135         }
136         uint256 temp = value;
137         uint256 digits;
138         while (temp != 0) {
139             digits++;
140             temp /= 10;
141         }
142         bytes memory buffer = new bytes(digits);
143         while (value != 0) {
144             digits -= 1;
145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
146             value /= 10;
147         }
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
153      */
154     function toHexString(uint256 value) internal pure returns (string memory) {
155         if (value == 0) {
156             return "0x00";
157         }
158         uint256 temp = value;
159         uint256 length = 0;
160         while (temp != 0) {
161             length++;
162             temp >>= 8;
163         }
164         return toHexString(value, length);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
169      */
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 // File: @openzeppelin/contracts/utils/Context.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Provides information about the current execution context, including the
192  * sender of the transaction and its data. While these are generally available
193  * via msg.sender and msg.data, they should not be accessed in such a direct
194  * manner, since when dealing with meta-transactions the account sending and
195  * paying for execution may not be the actual sender (as far as an application
196  * is concerned).
197  *
198  * This contract is only required for intermediate, library-like contracts.
199  */
200 abstract contract Context {
201     function _msgSender() internal view virtual returns (address) {
202         return msg.sender;
203     }
204 
205     function _msgData() internal view virtual returns (bytes calldata) {
206         return msg.data;
207     }
208 }
209 
210 // File: @openzeppelin/contracts/access/Ownable.sol
211 
212 
213 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 
218 /**
219  * @dev Contract module which provides a basic access control mechanism, where
220  * there is an account (an owner) that can be granted exclusive access to
221  * specific functions.
222  *
223  * By default, the owner account will be the one that deploys the contract. This
224  * can later be changed with {transferOwnership}.
225  *
226  * This module is used through inheritance. It will make available the modifier
227  * `onlyOwner`, which can be applied to your functions to restrict their use to
228  * the owner.
229  */
230 abstract contract Ownable is Context {
231     address private _owner;
232 
233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235     /**
236      * @dev Initializes the contract setting the deployer as the initial owner.
237      */
238     constructor() {
239         _transferOwnership(_msgSender());
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view virtual returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public virtual onlyOwner {
265         _transferOwnership(address(0));
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public virtual onlyOwner {
273         require(newOwner != address(0), "Ownable: new owner is the zero address");
274         _transferOwnership(newOwner);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Internal function without access restriction.
280      */
281     function _transferOwnership(address newOwner) internal virtual {
282         address oldOwner = _owner;
283         _owner = newOwner;
284         emit OwnershipTransferred(oldOwner, newOwner);
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Address.sol
289 
290 
291 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
292 
293 pragma solidity ^0.8.1;
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      *
316      * [IMPORTANT]
317      * ====
318      * You shouldn't rely on `isContract` to protect against flash loan attacks!
319      *
320      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
321      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
322      * constructor.
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize/address.code.length, which returns 0
327         // for contracts in construction, since the code is only stored at the end
328         // of the constructor execution.
329 
330         return account.code.length > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain `call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(address(this).balance >= value, "Address: insufficient balance for call");
424         require(isContract(target), "Address: call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.call{value: value}(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
437         return functionStaticCall(target, data, "Address: low-level static call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal view returns (bytes memory) {
451         require(isContract(target), "Address: static call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.staticcall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
464         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.delegatecall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
486      * revert reason using the provided one.
487      *
488      * _Available since v4.3._
489      */
490     function verifyCallResult(
491         bool success,
492         bytes memory returndata,
493         string memory errorMessage
494     ) internal pure returns (bytes memory) {
495         if (success) {
496             return returndata;
497         } else {
498             // Look for revert reason and bubble it up if present
499             if (returndata.length > 0) {
500                 // The easiest way to bubble the revert reason is using memory via assembly
501 
502                 assembly {
503                     let returndata_size := mload(returndata)
504                     revert(add(32, returndata), returndata_size)
505                 }
506             } else {
507                 revert(errorMessage);
508             }
509         }
510     }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
514 
515 
516 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @title ERC721 token receiver interface
522  * @dev Interface for any contract that wants to support safeTransfers
523  * from ERC721 asset contracts.
524  */
525 interface IERC721Receiver {
526     /**
527      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
528      * by `operator` from `from`, this function is called.
529      *
530      * It must return its Solidity selector to confirm the token transfer.
531      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
532      *
533      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
534      */
535     function onERC721Received(
536         address operator,
537         address from,
538         uint256 tokenId,
539         bytes calldata data
540     ) external returns (bytes4);
541 }
542 
543 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev Interface of the ERC165 standard, as defined in the
552  * https://eips.ethereum.org/EIPS/eip-165[EIP].
553  *
554  * Implementers can declare support of contract interfaces, which can then be
555  * queried by others ({ERC165Checker}).
556  *
557  * For an implementation, see {ERC165}.
558  */
559 interface IERC165 {
560     /**
561      * @dev Returns true if this contract implements the interface defined by
562      * `interfaceId`. See the corresponding
563      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
564      * to learn more about how these ids are created.
565      *
566      * This function call must use less than 30 000 gas.
567      */
568     function supportsInterface(bytes4 interfaceId) external view returns (bool);
569 }
570 
571 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @dev Implementation of the {IERC165} interface.
581  *
582  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
583  * for the additional interface id that will be supported. For example:
584  *
585  * ```solidity
586  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
588  * }
589  * ```
590  *
591  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
592  */
593 abstract contract ERC165 is IERC165 {
594     /**
595      * @dev See {IERC165-supportsInterface}.
596      */
597     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598         return interfaceId == type(IERC165).interfaceId;
599     }
600 }
601 
602 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
603 
604 
605 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @dev Required interface of an ERC721 compliant contract.
612  */
613 interface IERC721 is IERC165 {
614     /**
615      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
616      */
617     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
618 
619     /**
620      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
621      */
622     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
623 
624     /**
625      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
626      */
627     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
628 
629     /**
630      * @dev Returns the number of tokens in ``owner``'s account.
631      */
632     function balanceOf(address owner) external view returns (uint256 balance);
633 
634     /**
635      * @dev Returns the owner of the `tokenId` token.
636      *
637      * Requirements:
638      *
639      * - `tokenId` must exist.
640      */
641     function ownerOf(uint256 tokenId) external view returns (address owner);
642 
643     /**
644      * @dev Safely transfers `tokenId` token from `from` to `to`.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
653      *
654      * Emits a {Transfer} event.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId,
660         bytes calldata data
661     ) external;
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
665      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
674      *
675      * Emits a {Transfer} event.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) external;
682 
683     /**
684      * @dev Transfers `tokenId` token from `from` to `to`.
685      *
686      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must be owned by `from`.
693      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
694      *
695      * Emits a {Transfer} event.
696      */
697     function transferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) external;
702 
703     /**
704      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
705      * The approval is cleared when the token is transferred.
706      *
707      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) external;
717 
718     /**
719      * @dev Approve or remove `operator` as an operator for the caller.
720      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
721      *
722      * Requirements:
723      *
724      * - The `operator` cannot be the caller.
725      *
726      * Emits an {ApprovalForAll} event.
727      */
728     function setApprovalForAll(address operator, bool _approved) external;
729 
730     /**
731      * @dev Returns the account approved for `tokenId` token.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must exist.
736      */
737     function getApproved(uint256 tokenId) external view returns (address operator);
738 
739     /**
740      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
741      *
742      * See {setApprovalForAll}
743      */
744     function isApprovedForAll(address owner, address operator) external view returns (bool);
745 }
746 
747 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
757  * @dev See https://eips.ethereum.org/EIPS/eip-721
758  */
759 interface IERC721Metadata is IERC721 {
760     /**
761      * @dev Returns the token collection name.
762      */
763     function name() external view returns (string memory);
764 
765     /**
766      * @dev Returns the token collection symbol.
767      */
768     function symbol() external view returns (string memory);
769 
770     /**
771      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
772      */
773     function tokenURI(uint256 tokenId) external view returns (string memory);
774 }
775 
776 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
777 
778 
779 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 
785 
786 
787 
788 
789 
790 /**
791  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
792  * the Metadata extension, but not including the Enumerable extension, which is available separately as
793  * {ERC721Enumerable}.
794  */
795 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
796     using Address for address;
797     using Strings for uint256;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to owner address
806     mapping(uint256 => address) private _owners;
807 
808     // Mapping owner address to token count
809     mapping(address => uint256) private _balances;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     /**
818      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
819      */
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823     }
824 
825     /**
826      * @dev See {IERC165-supportsInterface}.
827      */
828     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
829         return
830             interfaceId == type(IERC721).interfaceId ||
831             interfaceId == type(IERC721Metadata).interfaceId ||
832             super.supportsInterface(interfaceId);
833     }
834 
835     /**
836      * @dev See {IERC721-balanceOf}.
837      */
838     function balanceOf(address owner) public view virtual override returns (uint256) {
839         require(owner != address(0), "ERC721: balance query for the zero address");
840         return _balances[owner];
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
847         address owner = _owners[tokenId];
848         require(owner != address(0), "ERC721: owner query for nonexistent token");
849         return owner;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-name}.
854      */
855     function name() public view virtual override returns (string memory) {
856         return _name;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-symbol}.
861      */
862     function symbol() public view virtual override returns (string memory) {
863         return _symbol;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-tokenURI}.
868      */
869     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
870         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
871 
872         string memory baseURI = _baseURI();
873         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
879      * by default, can be overridden in child contracts.
880      */
881     function _baseURI() internal view virtual returns (string memory) {
882         return "";
883     }
884 
885     /**
886      * @dev See {IERC721-approve}.
887      */
888     function approve(address to, uint256 tokenId) public virtual override {
889         address owner = ERC721.ownerOf(tokenId);
890         require(to != owner, "ERC721: approval to current owner");
891 
892         require(
893             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
894             "ERC721: approve caller is not owner nor approved for all"
895         );
896 
897         _approve(to, tokenId);
898     }
899 
900     /**
901      * @dev See {IERC721-getApproved}.
902      */
903     function getApproved(uint256 tokenId) public view virtual override returns (address) {
904         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
905 
906         return _tokenApprovals[tokenId];
907     }
908 
909     /**
910      * @dev See {IERC721-setApprovalForAll}.
911      */
912     function setApprovalForAll(address operator, bool approved) public virtual override {
913         _setApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         //solhint-disable-next-line max-line-length
932         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
933 
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, "");
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public virtual override {
957         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
958         _safeTransfer(from, to, tokenId, _data);
959     }
960 
961     /**
962      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
963      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
964      *
965      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
966      *
967      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
968      * implement alternative mechanisms to perform token transfer, such as signature-based.
969      *
970      * Requirements:
971      *
972      * - `from` cannot be the zero address.
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must exist and be owned by `from`.
975      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeTransfer(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) internal virtual {
985         _transfer(from, to, tokenId);
986         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
987     }
988 
989     /**
990      * @dev Returns whether `tokenId` exists.
991      *
992      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
993      *
994      * Tokens start existing when they are minted (`_mint`),
995      * and stop existing when they are burned (`_burn`).
996      */
997     function _exists(uint256 tokenId) internal view virtual returns (bool) {
998         return _owners[tokenId] != address(0);
999     }
1000 
1001     /**
1002      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1009         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1010         address owner = ERC721.ownerOf(tokenId);
1011         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1012     }
1013 
1014     /**
1015      * @dev Safely mints `tokenId` and transfers it to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must not exist.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _safeMint(address to, uint256 tokenId) internal virtual {
1025         _safeMint(to, tokenId, "");
1026     }
1027 
1028     /**
1029      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1030      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1031      */
1032     function _safeMint(
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) internal virtual {
1037         _mint(to, tokenId);
1038         require(
1039             _checkOnERC721Received(address(0), to, tokenId, _data),
1040             "ERC721: transfer to non ERC721Receiver implementer"
1041         );
1042     }
1043 
1044     /**
1045      * @dev Mints `tokenId` and transfers it to `to`.
1046      *
1047      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must not exist.
1052      * - `to` cannot be the zero address.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _mint(address to, uint256 tokenId) internal virtual {
1057         require(to != address(0), "ERC721: mint to the zero address");
1058         require(!_exists(tokenId), "ERC721: token already minted");
1059 
1060         _beforeTokenTransfer(address(0), to, tokenId);
1061 
1062         _balances[to] += 1;
1063         _owners[tokenId] = to;
1064 
1065         emit Transfer(address(0), to, tokenId);
1066 
1067         _afterTokenTransfer(address(0), to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev Destroys `tokenId`.
1072      * The approval is cleared when the token is burned.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _burn(uint256 tokenId) internal virtual {
1081         address owner = ERC721.ownerOf(tokenId);
1082 
1083         _beforeTokenTransfer(owner, address(0), tokenId);
1084 
1085         // Clear approvals
1086         _approve(address(0), tokenId);
1087 
1088         _balances[owner] -= 1;
1089         delete _owners[tokenId];
1090 
1091         emit Transfer(owner, address(0), tokenId);
1092 
1093         _afterTokenTransfer(owner, address(0), tokenId);
1094     }
1095 
1096     /**
1097      * @dev Transfers `tokenId` from `from` to `to`.
1098      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual {
1112         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1113         require(to != address(0), "ERC721: transfer to the zero address");
1114 
1115         _beforeTokenTransfer(from, to, tokenId);
1116 
1117         // Clear approvals from the previous owner
1118         _approve(address(0), tokenId);
1119 
1120         _balances[from] -= 1;
1121         _balances[to] += 1;
1122         _owners[tokenId] = to;
1123 
1124         emit Transfer(from, to, tokenId);
1125 
1126         _afterTokenTransfer(from, to, tokenId);
1127     }
1128 
1129     /**
1130      * @dev Approve `to` to operate on `tokenId`
1131      *
1132      * Emits a {Approval} event.
1133      */
1134     function _approve(address to, uint256 tokenId) internal virtual {
1135         _tokenApprovals[tokenId] = to;
1136         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev Approve `operator` to operate on all of `owner` tokens
1141      *
1142      * Emits a {ApprovalForAll} event.
1143      */
1144     function _setApprovalForAll(
1145         address owner,
1146         address operator,
1147         bool approved
1148     ) internal virtual {
1149         require(owner != operator, "ERC721: approve to caller");
1150         _operatorApprovals[owner][operator] = approved;
1151         emit ApprovalForAll(owner, operator, approved);
1152     }
1153 
1154     /**
1155      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1156      * The call is not executed if the target address is not a contract.
1157      *
1158      * @param from address representing the previous owner of the given token ID
1159      * @param to target address that will receive the tokens
1160      * @param tokenId uint256 ID of the token to be transferred
1161      * @param _data bytes optional data to send along with the call
1162      * @return bool whether the call correctly returned the expected magic value
1163      */
1164     function _checkOnERC721Received(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) private returns (bool) {
1170         if (to.isContract()) {
1171             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1172                 return retval == IERC721Receiver.onERC721Received.selector;
1173             } catch (bytes memory reason) {
1174                 if (reason.length == 0) {
1175                     revert("ERC721: transfer to non ERC721Receiver implementer");
1176                 } else {
1177                     assembly {
1178                         revert(add(32, reason), mload(reason))
1179                     }
1180                 }
1181             }
1182         } else {
1183             return true;
1184         }
1185     }
1186 
1187     /**
1188      * @dev Hook that is called before any token transfer. This includes minting
1189      * and burning.
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` will be minted for `to`.
1196      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1197      * - `from` and `to` are never both zero.
1198      *
1199      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1200      */
1201     function _beforeTokenTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) internal virtual {}
1206 
1207     /**
1208      * @dev Hook that is called after any transfer of tokens. This includes
1209      * minting and burning.
1210      *
1211      * Calling conditions:
1212      *
1213      * - when `from` and `to` are both non-zero.
1214      * - `from` and `to` are never both zero.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _afterTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual {}
1223 }
1224 
1225 // File: chibizuki.sol
1226 
1227 
1228 pragma solidity >=0.7.0 <0.9.0;
1229 
1230 
1231 
1232 
1233 contract chibizuki is ERC721, Ownable, ReentrancyGuard {
1234   using Strings for uint256;
1235   using Counters for Counters.Counter;
1236   Counters.Counter private supply;
1237   string public baseURI = "ipfs://QmUDL5QVHXxGnMVaZLg3qvYBZjapLsARP5xqJfvryjdZNN/";
1238   string public baseExtension = ".json";
1239     
1240   uint256 public cost = 0.00 ether;
1241   uint256 public maxSupply = 5555;
1242   uint256 public maxMintAmountPerTx = 10;
1243   bool public paused = true;
1244   
1245   constructor() ERC721("chibizuki", "") { }
1246   function totalSupply() public view returns (uint256) { 
1247     return supply.current();
1248   }
1249   function mint(uint256 _mintAmount) public payable nonReentrant {
1250     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1251     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1252     require(!paused || msg.sender == owner(), "The contract is paused!");
1253     require(msg.value >= cost * _mintAmount || msg.sender == owner(), "Insufficient funds!");
1254     _mintLoop(msg.sender, _mintAmount);
1255   }
1256   
1257   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1258   {
1259     uint256 ownerTokenCount = balanceOf(_owner);
1260     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1261     uint256 currentTokenId = 1;
1262     uint256 ownedTokenIndex = 0;
1263     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1264       address currentTokenOwner = ownerOf(currentTokenId);
1265       if (currentTokenOwner == _owner) {
1266         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1267         ownedTokenIndex++;
1268       }
1269       currentTokenId++;
1270     }
1271     return ownedTokenIds;
1272   }
1273   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory)
1274   {
1275     require(
1276       _exists(_tokenId),
1277       "ERC721Metadata: URI query for nonexistent token"
1278     );
1279     string memory currentBaseURI = _baseURI();
1280     return bytes(currentBaseURI).length > 0
1281         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension))
1282         : "";
1283   }
1284  
1285   function setCost(uint256 _cost) public onlyOwner {
1286     cost = _cost;
1287   }
1288   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1289     maxMintAmountPerTx = _maxMintAmountPerTx;
1290   }
1291   function setBaseURI(string memory baseURI_in) public onlyOwner {
1292     baseURI = baseURI_in;
1293   }
1294   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1295     baseExtension = _newBaseExtension;
1296   }
1297   function setPaused(bool _state) public onlyOwner {
1298     paused = _state;
1299   }
1300   function withdraw() public onlyOwner {
1301     uint256 balance = address(this).balance;
1302     Address.sendValue(payable(owner()), balance);
1303   }
1304   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1305     for (uint256 i = 0; i < _mintAmount; i++) {
1306       supply.increment();
1307       _safeMint(_receiver, supply.current());
1308     }
1309   }
1310   function _baseURI() internal view virtual override returns (string memory) {
1311     return baseURI;
1312   }
1313 }