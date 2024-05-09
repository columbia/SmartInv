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
516 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
533      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
605 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
644      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
645      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must exist and be owned by `from`.
652      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
653      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
654      *
655      * Emits a {Transfer} event.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external;
662 
663     /**
664      * @dev Transfers `tokenId` token from `from` to `to`.
665      *
666      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
674      *
675      * Emits a {Transfer} event.
676      */
677     function transferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) external;
682 
683     /**
684      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
685      * The approval is cleared when the token is transferred.
686      *
687      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
688      *
689      * Requirements:
690      *
691      * - The caller must own the token or be an approved operator.
692      * - `tokenId` must exist.
693      *
694      * Emits an {Approval} event.
695      */
696     function approve(address to, uint256 tokenId) external;
697 
698     /**
699      * @dev Returns the account approved for `tokenId` token.
700      *
701      * Requirements:
702      *
703      * - `tokenId` must exist.
704      */
705     function getApproved(uint256 tokenId) external view returns (address operator);
706 
707     /**
708      * @dev Approve or remove `operator` as an operator for the caller.
709      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
710      *
711      * Requirements:
712      *
713      * - The `operator` cannot be the caller.
714      *
715      * Emits an {ApprovalForAll} event.
716      */
717     function setApprovalForAll(address operator, bool _approved) external;
718 
719     /**
720      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
721      *
722      * See {setApprovalForAll}
723      */
724     function isApprovedForAll(address owner, address operator) external view returns (bool);
725 
726     /**
727      * @dev Safely transfers `tokenId` token from `from` to `to`.
728      *
729      * Requirements:
730      *
731      * - `from` cannot be the zero address.
732      * - `to` cannot be the zero address.
733      * - `tokenId` token must exist and be owned by `from`.
734      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId,
743         bytes calldata data
744     ) external;
745 }
746 
747 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
748 
749 
750 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
757  * @dev See https://eips.ethereum.org/EIPS/eip-721
758  */
759 interface IERC721Enumerable is IERC721 {
760     /**
761      * @dev Returns the total amount of tokens stored by the contract.
762      */
763     function totalSupply() external view returns (uint256);
764 
765     /**
766      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
767      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
768      */
769     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
770 
771     /**
772      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
773      * Use along with {totalSupply} to enumerate all tokens.
774      */
775     function tokenByIndex(uint256 index) external view returns (uint256);
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
779 
780 
781 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
788  * @dev See https://eips.ethereum.org/EIPS/eip-721
789  */
790 interface IERC721Metadata is IERC721 {
791     /**
792      * @dev Returns the token collection name.
793      */
794     function name() external view returns (string memory);
795 
796     /**
797      * @dev Returns the token collection symbol.
798      */
799     function symbol() external view returns (string memory);
800 
801     /**
802      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
803      */
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 }
806 
807 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
808 
809 
810 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
811 
812 pragma solidity ^0.8.0;
813 
814 
815 
816 
817 
818 
819 
820 
821 /**
822  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
823  * the Metadata extension, but not including the Enumerable extension, which is available separately as
824  * {ERC721Enumerable}.
825  */
826 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
827     using Address for address;
828     using Strings for uint256;
829 
830     // Token name
831     string private _name;
832 
833     // Token symbol
834     string private _symbol;
835 
836     // Mapping from token ID to owner address
837     mapping(uint256 => address) private _owners;
838 
839     // Mapping owner address to token count
840     mapping(address => uint256) private _balances;
841 
842     // Mapping from token ID to approved address
843     mapping(uint256 => address) private _tokenApprovals;
844 
845     // Mapping from owner to operator approvals
846     mapping(address => mapping(address => bool)) private _operatorApprovals;
847 
848     /**
849      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
850      */
851     constructor(string memory name_, string memory symbol_) {
852         _name = name_;
853         _symbol = symbol_;
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC721).interfaceId ||
862             interfaceId == type(IERC721Metadata).interfaceId ||
863             super.supportsInterface(interfaceId);
864     }
865 
866     /**
867      * @dev See {IERC721-balanceOf}.
868      */
869     function balanceOf(address owner) public view virtual override returns (uint256) {
870         require(owner != address(0), "ERC721: balance query for the zero address");
871         return _balances[owner];
872     }
873 
874     /**
875      * @dev See {IERC721-ownerOf}.
876      */
877     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
878         address owner = _owners[tokenId];
879         require(owner != address(0), "ERC721: owner query for nonexistent token");
880         return owner;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-name}.
885      */
886     function name() public view virtual override returns (string memory) {
887         return _name;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-symbol}.
892      */
893     function symbol() public view virtual override returns (string memory) {
894         return _symbol;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-tokenURI}.
899      */
900     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
901         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
902 
903         string memory baseURI = _baseURI();
904         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
905     }
906 
907     /**
908      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
909      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
910      * by default, can be overriden in child contracts.
911      */
912     function _baseURI() internal view virtual returns (string memory) {
913         return "";
914     }
915 
916     /**
917      * @dev See {IERC721-approve}.
918      */
919     function approve(address to, uint256 tokenId) public virtual override {
920         address owner = ERC721.ownerOf(tokenId);
921         require(to != owner, "ERC721: approval to current owner");
922 
923         require(
924             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
925             "ERC721: approve caller is not owner nor approved for all"
926         );
927 
928         _approve(to, tokenId);
929     }
930 
931     /**
932      * @dev See {IERC721-getApproved}.
933      */
934     function getApproved(uint256 tokenId) public view virtual override returns (address) {
935         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
936 
937         return _tokenApprovals[tokenId];
938     }
939 
940     /**
941      * @dev See {IERC721-setApprovalForAll}.
942      */
943     function setApprovalForAll(address operator, bool approved) public virtual override {
944         _setApprovalForAll(_msgSender(), operator, approved);
945     }
946 
947     /**
948      * @dev See {IERC721-isApprovedForAll}.
949      */
950     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
951         return _operatorApprovals[owner][operator];
952     }
953 
954     /**
955      * @dev See {IERC721-transferFrom}.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         //solhint-disable-next-line max-line-length
963         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
964 
965         _transfer(from, to, tokenId);
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         safeTransferFrom(from, to, tokenId, "");
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) public virtual override {
988         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
989         _safeTransfer(from, to, tokenId, _data);
990     }
991 
992     /**
993      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
994      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
995      *
996      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
997      *
998      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
999      * implement alternative mechanisms to perform token transfer, such as signature-based.
1000      *
1001      * Requirements:
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must exist and be owned by `from`.
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _safeTransfer(
1011         address from,
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) internal virtual {
1016         _transfer(from, to, tokenId);
1017         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1018     }
1019 
1020     /**
1021      * @dev Returns whether `tokenId` exists.
1022      *
1023      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1024      *
1025      * Tokens start existing when they are minted (`_mint`),
1026      * and stop existing when they are burned (`_burn`).
1027      */
1028     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1029         return _owners[tokenId] != address(0);
1030     }
1031 
1032     /**
1033      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      */
1039     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1040         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1041         address owner = ERC721.ownerOf(tokenId);
1042         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1043     }
1044 
1045     /**
1046      * @dev Safely mints `tokenId` and transfers it to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must not exist.
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(address to, uint256 tokenId) internal virtual {
1056         _safeMint(to, tokenId, "");
1057     }
1058 
1059     /**
1060      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1061      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1062      */
1063     function _safeMint(
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) internal virtual {
1068         _mint(to, tokenId);
1069         require(
1070             _checkOnERC721Received(address(0), to, tokenId, _data),
1071             "ERC721: transfer to non ERC721Receiver implementer"
1072         );
1073     }
1074 
1075     /**
1076      * @dev Mints `tokenId` and transfers it to `to`.
1077      *
1078      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must not exist.
1083      * - `to` cannot be the zero address.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(address to, uint256 tokenId) internal virtual {
1088         require(to != address(0), "ERC721: mint to the zero address");
1089         require(!_exists(tokenId), "ERC721: token already minted");
1090 
1091         _beforeTokenTransfer(address(0), to, tokenId);
1092 
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(address(0), to, tokenId);
1097 
1098         _afterTokenTransfer(address(0), to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Destroys `tokenId`.
1103      * The approval is cleared when the token is burned.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _burn(uint256 tokenId) internal virtual {
1112         address owner = ERC721.ownerOf(tokenId);
1113 
1114         _beforeTokenTransfer(owner, address(0), tokenId);
1115 
1116         // Clear approvals
1117         _approve(address(0), tokenId);
1118 
1119         _balances[owner] -= 1;
1120         delete _owners[tokenId];
1121 
1122         emit Transfer(owner, address(0), tokenId);
1123 
1124         _afterTokenTransfer(owner, address(0), tokenId);
1125     }
1126 
1127     /**
1128      * @dev Transfers `tokenId` from `from` to `to`.
1129      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `tokenId` token must be owned by `from`.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _transfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual {
1143         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1144         require(to != address(0), "ERC721: transfer to the zero address");
1145 
1146         _beforeTokenTransfer(from, to, tokenId);
1147 
1148         // Clear approvals from the previous owner
1149         _approve(address(0), tokenId);
1150 
1151         _balances[from] -= 1;
1152         _balances[to] += 1;
1153         _owners[tokenId] = to;
1154 
1155         emit Transfer(from, to, tokenId);
1156 
1157         _afterTokenTransfer(from, to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Approve `to` to operate on `tokenId`
1162      *
1163      * Emits a {Approval} event.
1164      */
1165     function _approve(address to, uint256 tokenId) internal virtual {
1166         _tokenApprovals[tokenId] = to;
1167         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev Approve `operator` to operate on all of `owner` tokens
1172      *
1173      * Emits a {ApprovalForAll} event.
1174      */
1175     function _setApprovalForAll(
1176         address owner,
1177         address operator,
1178         bool approved
1179     ) internal virtual {
1180         require(owner != operator, "ERC721: approve to caller");
1181         _operatorApprovals[owner][operator] = approved;
1182         emit ApprovalForAll(owner, operator, approved);
1183     }
1184 
1185     /**
1186      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1187      * The call is not executed if the target address is not a contract.
1188      *
1189      * @param from address representing the previous owner of the given token ID
1190      * @param to target address that will receive the tokens
1191      * @param tokenId uint256 ID of the token to be transferred
1192      * @param _data bytes optional data to send along with the call
1193      * @return bool whether the call correctly returned the expected magic value
1194      */
1195     function _checkOnERC721Received(
1196         address from,
1197         address to,
1198         uint256 tokenId,
1199         bytes memory _data
1200     ) private returns (bool) {
1201         if (to.isContract()) {
1202             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1203                 return retval == IERC721Receiver.onERC721Received.selector;
1204             } catch (bytes memory reason) {
1205                 if (reason.length == 0) {
1206                     revert("ERC721: transfer to non ERC721Receiver implementer");
1207                 } else {
1208                     assembly {
1209                         revert(add(32, reason), mload(reason))
1210                     }
1211                 }
1212             }
1213         } else {
1214             return true;
1215         }
1216     }
1217 
1218     /**
1219      * @dev Hook that is called before any token transfer. This includes minting
1220      * and burning.
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` will be minted for `to`.
1227      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1228      * - `from` and `to` are never both zero.
1229      *
1230      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1231      */
1232     function _beforeTokenTransfer(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) internal virtual {}
1237 
1238     /**
1239      * @dev Hook that is called after any transfer of tokens. This includes
1240      * minting and burning.
1241      *
1242      * Calling conditions:
1243      *
1244      * - when `from` and `to` are both non-zero.
1245      * - `from` and `to` are never both zero.
1246      *
1247      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1248      */
1249     function _afterTokenTransfer(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) internal virtual {}
1254 }
1255 
1256 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1257 
1258 
1259 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 
1265 /**
1266  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1267  * enumerability of all the token ids in the contract as well as all token ids owned by each
1268  * account.
1269  */
1270 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1271     // Mapping from owner to list of owned token IDs
1272     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1273 
1274     // Mapping from token ID to index of the owner tokens list
1275     mapping(uint256 => uint256) private _ownedTokensIndex;
1276 
1277     // Array with all token ids, used for enumeration
1278     uint256[] private _allTokens;
1279 
1280     // Mapping from token id to position in the allTokens array
1281     mapping(uint256 => uint256) private _allTokensIndex;
1282 
1283     /**
1284      * @dev See {IERC165-supportsInterface}.
1285      */
1286     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1287         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1292      */
1293     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1294         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1295         return _ownedTokens[owner][index];
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Enumerable-totalSupply}.
1300      */
1301     function totalSupply() public view virtual override returns (uint256) {
1302         return _allTokens.length;
1303     }
1304 
1305     /**
1306      * @dev See {IERC721Enumerable-tokenByIndex}.
1307      */
1308     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1309         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1310         return _allTokens[index];
1311     }
1312 
1313     /**
1314      * @dev Hook that is called before any token transfer. This includes minting
1315      * and burning.
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      *
1326      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1327      */
1328     function _beforeTokenTransfer(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) internal virtual override {
1333         super._beforeTokenTransfer(from, to, tokenId);
1334 
1335         if (from == address(0)) {
1336             _addTokenToAllTokensEnumeration(tokenId);
1337         } else if (from != to) {
1338             _removeTokenFromOwnerEnumeration(from, tokenId);
1339         }
1340         if (to == address(0)) {
1341             _removeTokenFromAllTokensEnumeration(tokenId);
1342         } else if (to != from) {
1343             _addTokenToOwnerEnumeration(to, tokenId);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1349      * @param to address representing the new owner of the given token ID
1350      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1351      */
1352     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1353         uint256 length = ERC721.balanceOf(to);
1354         _ownedTokens[to][length] = tokenId;
1355         _ownedTokensIndex[tokenId] = length;
1356     }
1357 
1358     /**
1359      * @dev Private function to add a token to this extension's token tracking data structures.
1360      * @param tokenId uint256 ID of the token to be added to the tokens list
1361      */
1362     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1363         _allTokensIndex[tokenId] = _allTokens.length;
1364         _allTokens.push(tokenId);
1365     }
1366 
1367     /**
1368      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1369      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1370      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1371      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1372      * @param from address representing the previous owner of the given token ID
1373      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1374      */
1375     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1376         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1377         // then delete the last slot (swap and pop).
1378 
1379         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1380         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1381 
1382         // When the token to delete is the last token, the swap operation is unnecessary
1383         if (tokenIndex != lastTokenIndex) {
1384             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1385 
1386             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1387             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1388         }
1389 
1390         // This also deletes the contents at the last position of the array
1391         delete _ownedTokensIndex[tokenId];
1392         delete _ownedTokens[from][lastTokenIndex];
1393     }
1394 
1395     /**
1396      * @dev Private function to remove a token from this extension's token tracking data structures.
1397      * This has O(1) time complexity, but alters the order of the _allTokens array.
1398      * @param tokenId uint256 ID of the token to be removed from the tokens list
1399      */
1400     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1401         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1402         // then delete the last slot (swap and pop).
1403 
1404         uint256 lastTokenIndex = _allTokens.length - 1;
1405         uint256 tokenIndex = _allTokensIndex[tokenId];
1406 
1407         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1408         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1409         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1410         uint256 lastTokenId = _allTokens[lastTokenIndex];
1411 
1412         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1413         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1414 
1415         // This also deletes the contents at the last position of the array
1416         delete _allTokensIndex[tokenId];
1417         _allTokens.pop();
1418     }
1419 }
1420 
1421 // File: contracts/METAHERMIA.sol
1422 
1423 
1424 
1425 pragma solidity ^0.8.7;
1426 
1427 
1428 
1429 /**
1430 
1431 ███╗░░░███╗███████╗████████╗░█████╗░██╗░░██╗███████╗██████╗░███╗░░░███╗██╗░█████╗░
1432 
1433 ████╗░████║██╔════╝╚══██╔══╝██╔══██╗██║░░██║██╔════╝██╔══██╗████╗░████║██║██╔══██╗
1434 
1435 ██╔████╔██║█████╗░░░░░██║░░░███████║███████║█████╗░░██████╔╝██╔████╔██║██║███████║
1436 
1437 ██║╚██╔╝██║██╔══╝░░░░░██║░░░██╔══██║██╔══██║██╔══╝░░██╔══██╗██║╚██╔╝██║██║██╔══██║
1438 
1439 ██║░╚═╝░██║███████╗░░░██║░░░██║░░██║██║░░██║███████╗██║░░██║██║░╚═╝░██║██║██║░░██║
1440 
1441 ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░╚═╝
1442 
1443 **/
1444 
1445 
1446 
1447 
1448 
1449 
1450 
1451 
1452 contract METAHERMIA is ERC721Enumerable, Ownable, ReentrancyGuard {
1453 
1454 
1455 
1456     //To increment the id of the NFTs
1457 
1458     using Counters for Counters.Counter;
1459 
1460     //To concatenate the URL of an NFT
1461 
1462     using Strings for uint256;
1463 
1464     //Id of the next NFT to mint
1465 
1466     Counters.Counter private _nftIdCounter;
1467 
1468     //Number of NFTs in the collection
1469 
1470     uint public constant MAX_SUPPLY = 7777;
1471 
1472     //Number of NFTs presale one
1473 
1474     uint public constant MAX_SUPPLY_PRESALEONE = 1000;
1475 
1476     //Number of NFTs presale two
1477 
1478     uint public constant MAX_SUPPLY_PRESALETWO = 4000;
1479 
1480     //Maximum number of NFTs an address can mint
1481 
1482     uint public max_mint_allowed = 100;
1483 
1484     //Price of one NFT in presale1
1485 
1486     uint public pricePresaleOne = 0.05 ether;
1487 
1488     //Price of one NFT in presale2
1489 
1490     uint public pricePresaleTwo = 0.1 ether;
1491 
1492     //Price of one NFT in sale
1493 
1494     uint public priceSale = 0.2 ether;
1495 
1496     uint256 public nftPerAddressLimit = 100;
1497 
1498     //Is the contract paused ?
1499 
1500     bool public paused = false;
1501 
1502     //whiteslited condition
1503 
1504     bool public onlyWhitelisted = true;
1505 
1506     //Whitelisted Addresses
1507 
1508     address[] public whitelistedAddresses;
1509 
1510     //Mapping Address Minted Balance
1511 
1512     mapping(address => uint256) public addressMintedBalance;
1513 
1514     //URI of the NFTs when revealed
1515 
1516     string public baseURI;
1517 
1518     //The extension of the file containing the Metadatas of the NFTs
1519 
1520     string public baseExtension = ".json";
1521 
1522 
1523 
1524 
1525 
1526 
1527 
1528     //The different stages of selling the collection
1529 
1530     enum Steps {
1531 
1532         Before,
1533 
1534         PresaleOne,
1535 
1536         PauseOne,
1537 
1538         PresaleTwo,
1539 
1540         PauseTwo,
1541 
1542         Sale,
1543 
1544         SoldOut
1545 
1546     }
1547 
1548 
1549 
1550     Steps public sellingStep;
1551 
1552     
1553 
1554     //Owner of the smart contract
1555 
1556     address private _owner;
1557 
1558 
1559 
1560 
1561 
1562     //Constructor of the collection
1563 
1564     constructor(string memory _theBaseURI) ERC721("METAHERMIA", "HERMIA") {
1565 
1566         _nftIdCounter.increment();
1567 
1568         transferOwnership(msg.sender);
1569 
1570         sellingStep = Steps.Before;
1571 
1572         baseURI = _theBaseURI;
1573 
1574     }
1575 
1576 
1577 
1578     /** 
1579 
1580     * @param _paused True or false if you want the contract to be paused or not
1581 
1582     **/
1583 
1584     function setPaused(bool _paused) external onlyOwner {
1585 
1586         paused = _paused;
1587 
1588     }
1589 
1590 
1591 
1592     /** 
1593 
1594     * @param _maxMintAllowed The number of NFTs that an address can mint
1595 
1596     **/
1597 
1598     function changeMaxMintAllowed(uint _maxMintAllowed) external onlyOwner {
1599 
1600         max_mint_allowed = _maxMintAllowed;
1601 
1602     }
1603 
1604 
1605 
1606     /** Change nftPerAddressLimit **/
1607 
1608     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1609 
1610     nftPerAddressLimit = _limit;
1611 
1612     }
1613 
1614 
1615 
1616     /** Change setOnlyWhitelisted state **/
1617 
1618     function setOnlyWhitelisted(bool _state) public onlyOwner {
1619 
1620     onlyWhitelisted = _state;
1621 
1622     }
1623 
1624   
1625 
1626     /** Change setOnlyWhitelisted state **/
1627 
1628     function whitelistUsers(address[] calldata _users) public onlyOwner {
1629 
1630     delete whitelistedAddresses;
1631 
1632     whitelistedAddresses = _users;
1633 
1634      }
1635 
1636 
1637 
1638 
1639 
1640     /**
1641 
1642     * @param _priceSale The new price of one NFT for the sale
1643 
1644     **/
1645 
1646     function changePriceSale(uint _priceSale) external onlyOwner {
1647 
1648         priceSale = _priceSale;
1649 
1650     }
1651 
1652 
1653 
1654     /**
1655 
1656     * @param _newBaseURI The new base URI
1657 
1658     **/
1659 
1660     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1661 
1662         baseURI = _newBaseURI;
1663 
1664     }
1665 
1666 
1667 
1668     /**
1669 
1670     * @return The URI of the NFTs
1671 
1672     **/
1673 
1674     function _baseURI() internal view virtual override returns (string memory) {
1675 
1676             return baseURI;
1677 
1678     }
1679 
1680 
1681 
1682     /**
1683 
1684     * @param _baseExtension the new extension of the metadatas files
1685 
1686     **/
1687 
1688     function setBaseExtension(string memory _baseExtension) external onlyOwner {
1689 
1690         baseExtension = _baseExtension;
1691 
1692     }
1693 
1694 
1695 
1696     /** 
1697 
1698     * @notice Allows to change the sellinStep to PresaleOne
1699 
1700     **/
1701 
1702     function setUpPresaleOne() external onlyOwner {
1703 
1704         sellingStep = Steps.PresaleOne;
1705 
1706     }
1707 
1708 
1709 
1710     /** 
1711 
1712     * @notice Allows to change the sellinStep to PauseOne
1713 
1714     **/
1715 
1716     function setUpPauseOne() external onlyOwner {
1717 
1718         sellingStep = Steps.PauseOne;
1719 
1720     }
1721 
1722 
1723 
1724     /** 
1725 
1726     * @notice Allows to change the sellinStep to PauseTwo
1727 
1728     **/
1729 
1730     function setUpPauseTwo() external onlyOwner {
1731 
1732         sellingStep = Steps.PauseTwo;
1733 
1734     }
1735 
1736 
1737 
1738     /** 
1739 
1740     * @notice Allows to change the sellinStep to PresaleTwo
1741 
1742     **/
1743 
1744     function setUpPresaleTwo() external onlyOwner {
1745 
1746         sellingStep = Steps.PresaleTwo;
1747 
1748     }
1749 
1750 
1751 
1752     /** 
1753 
1754     * @notice Allows to change the sellinStep to Sale
1755 
1756     **/
1757 
1758     function setUpSale() external onlyOwner {
1759 
1760         sellingStep = Steps.Sale;
1761 
1762     }
1763 
1764 
1765 
1766     /** 
1767 
1768     * @notice Allows to change the sellinStep to SodlOut
1769 
1770     **/
1771 
1772     function setUpSoldOut() external onlyOwner {
1773 
1774         sellingStep = Steps.SoldOut;
1775 
1776     }
1777 
1778 
1779 
1780     /**MINTING**/
1781 
1782     function mint(uint256 _mintAmount) external payable nonReentrant {
1783 
1784     require(!paused, "the contract is paused");
1785 
1786     uint256 supply = totalSupply();
1787 
1788     require(_mintAmount > 0, "need to mint at least 1 NFT");
1789 
1790     require(_mintAmount <= max_mint_allowed, "max mint amount per session exceeded");
1791 
1792     require(sellingStep != Steps.Before, "Presale 1 has not started yet.");
1793 
1794     require(sellingStep != Steps.PauseOne, "Sorry, Presale 1 SOLDOUT, please wait for Presale 2, FEB 18th.");
1795 
1796     require(sellingStep != Steps.PauseTwo, "Sorry, Presale 2 SOLDOUT, please wait for Public sale, FEB 21st.");
1797 
1798     require(sellingStep != Steps.SoldOut, "Sorry, MINTING SOLDOUT, please buy from the secondary market on OPENSEA.");  
1799 
1800     require(supply + _mintAmount <= MAX_SUPPLY, "Sorry, don't have enought NFTs left");     
1801 
1802     if(sellingStep == Steps.PresaleOne){
1803 
1804         uint256 price = pricePresaleOne;
1805 
1806         require(msg.value >= price * _mintAmount, "insufficient funds");
1807 
1808         if(onlyWhitelisted == true) {
1809 
1810             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1811 
1812             require(isWhitelisted(msg.sender), "You are not whitelisted");
1813 
1814             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "MAX NFT per address exceeded");
1815 
1816             require(supply + _mintAmount <= MAX_SUPPLY_PRESALEONE, "Presale 1 is almost done, and we don't have enought NFTs left.");
1817 
1818             if(supply + _mintAmount == MAX_SUPPLY_PRESALEONE) {
1819 
1820             sellingStep = Steps.PauseOne;   
1821 
1822                 }
1823 
1824             }
1825 
1826         }
1827 
1828     
1829 
1830     if(sellingStep == Steps.PresaleTwo){
1831 
1832         uint256 price = pricePresaleTwo;
1833 
1834         require(msg.value >= price * _mintAmount, "insufficient funds");
1835 
1836         if(onlyWhitelisted == true) {
1837 
1838             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1839 
1840             require(isWhitelisted(msg.sender), "You are not whitelisted");
1841 
1842             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "MAX NFT per address exceeded");
1843 
1844             require(supply + _mintAmount <= MAX_SUPPLY_PRESALETWO, "Presale 2 is almost done, and we don't have enought NFTs left.");
1845 
1846             if(supply + _mintAmount == MAX_SUPPLY_PRESALETWO) {
1847 
1848             sellingStep = Steps.PauseTwo;   
1849 
1850          }
1851 
1852         }
1853 
1854     }
1855 
1856 
1857 
1858     if(sellingStep == Steps.Sale){
1859 
1860         uint256 price = priceSale;
1861 
1862         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1863 
1864         require(msg.value >= price * _mintAmount, "insufficient funds");
1865 
1866         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "MAX NFT per address exceeded");
1867 
1868         require(supply + _mintAmount <= MAX_SUPPLY, "Sale is almost done, and we don't have enought NFTs left.");
1869 
1870         
1871 
1872         if(supply + _mintAmount == MAX_SUPPLY) {
1873 
1874             sellingStep = Steps.SoldOut;   
1875 
1876          }
1877 
1878     }
1879 
1880     
1881 
1882 
1883 
1884     for (uint256 i = 1; i <= _mintAmount; i++) {
1885 
1886         addressMintedBalance[msg.sender]++;
1887 
1888       _safeMint(msg.sender, supply + i);
1889 
1890     }
1891 
1892    }
1893 
1894   
1895 
1896   function isWhitelisted(address _user) public view returns (bool) {
1897 
1898     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1899 
1900       if (whitelistedAddresses[i] == _user) {
1901 
1902           return true;
1903 
1904       }
1905 
1906     }
1907 
1908     return false;
1909 
1910   }
1911 
1912 
1913 
1914 
1915 
1916     /**
1917 
1918     * @notice Allows to gift one NFT to an address
1919 
1920     *
1921 
1922     * @param _account The account of the happy new owner of one NFT
1923 
1924     **/
1925 
1926     function gift(address _account) external onlyOwner {
1927 
1928         uint supply = totalSupply();
1929 
1930         require(supply + 1 <= MAX_SUPPLY, "Sold out");
1931 
1932         _safeMint(_account, supply + 1);
1933 
1934     }
1935 
1936 
1937 
1938 
1939 
1940     /**
1941 
1942     * @return The token URI of the NFT which has _nftId Id
1943 
1944     **/
1945 
1946     function tokenURI(uint _nftId) public view override(ERC721) returns (string memory) {
1947 
1948         require(_exists(_nftId), "This NFT doesn't exist.");
1949 
1950         string memory currentBaseURI = _baseURI();
1951 
1952         return 
1953 
1954             bytes(currentBaseURI).length > 0 
1955 
1956             ? string(abi.encodePacked(currentBaseURI, _nftId.toString(), baseExtension))
1957 
1958             : "";
1959 
1960     }
1961 
1962     
1963 
1964     /**Withdraw function**/
1965 
1966     function withdraw() public payable onlyOwner {
1967 
1968     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1969 
1970     require(os);
1971 
1972   }
1973 
1974 
1975 
1976 }