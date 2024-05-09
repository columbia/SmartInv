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
807 // File: ERC721A.sol
808 
809 
810 // Creators: locationtba.eth, 2pmflow.eth
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
821 
822 /**
823  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
824  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
825  *
826  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
827  *
828  * Does not support burning tokens to address(0).
829  */
830 contract ERC721A is
831   Context,
832   ERC165,
833   IERC721,
834   IERC721Metadata,
835   IERC721Enumerable
836 {
837   using Address for address;
838   using Strings for uint256;
839 
840   struct TokenOwnership {
841     address addr;
842     uint64 startTimestamp;
843   }
844 
845   struct AddressData {
846     uint128 balance;
847     uint128 numberMinted;
848   }
849 
850   uint256 private currentIndex;
851 
852   uint256 internal immutable maxBatchSize;
853 
854   // Token name
855   string private _name;
856 
857   // Token symbol
858   string private _symbol;
859 
860   // Mapping from token ID to ownership details
861   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
862   mapping(uint256 => TokenOwnership) private _ownerships;
863 
864   // Mapping owner address to address data
865   mapping(address => AddressData) private _addressData;
866 
867   // Mapping from token ID to approved address
868   mapping(uint256 => address) private _tokenApprovals;
869 
870   // Mapping from owner to operator approvals
871   mapping(address => mapping(address => bool)) private _operatorApprovals;
872 
873   /**
874    * @dev
875    * `maxBatchSize` refers to how much a minter can mint at a time.
876    */
877   constructor(
878     string memory name_,
879     string memory symbol_,
880     uint256 maxBatchSize_
881   ) {
882     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
883     _name = name_;
884     _symbol = symbol_;
885     maxBatchSize = maxBatchSize_;
886   }
887 
888   /**
889    * @dev See {IERC721Enumerable-totalSupply}.
890    */
891   function totalSupply() public view override returns (uint256) {
892     return currentIndex;
893   }
894 
895   /**
896    * @dev See {IERC721Enumerable-tokenByIndex}.
897    */
898   function tokenByIndex(uint256 index) public view override returns (uint256) {
899     require(index < totalSupply(), "ERC721A: global index out of bounds");
900     return index;
901   }
902 
903   /**
904    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
905    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
906    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
907    */
908   function tokenOfOwnerByIndex(address owner, uint256 index)
909     public
910     view
911     override
912     returns (uint256)
913   {
914     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
915     uint256 numMintedSoFar = totalSupply();
916     uint256 tokenIdsIdx = 0;
917     address currOwnershipAddr = address(0);
918     for (uint256 i = 0; i < numMintedSoFar; i++) {
919       TokenOwnership memory ownership = _ownerships[i];
920       if (ownership.addr != address(0)) {
921         currOwnershipAddr = ownership.addr;
922       }
923       if (currOwnershipAddr == owner) {
924         if (tokenIdsIdx == index) {
925           return i;
926         }
927         tokenIdsIdx++;
928       }
929     }
930     revert("ERC721A: unable to get token of owner by index");
931   }
932 
933   /**
934    * @dev See {IERC165-supportsInterface}.
935    */
936   function supportsInterface(bytes4 interfaceId)
937     public
938     view
939     virtual
940     override(ERC165, IERC165)
941     returns (bool)
942   {
943     return
944       interfaceId == type(IERC721).interfaceId ||
945       interfaceId == type(IERC721Metadata).interfaceId ||
946       interfaceId == type(IERC721Enumerable).interfaceId ||
947       super.supportsInterface(interfaceId);
948   }
949 
950   /**
951    * @dev See {IERC721-balanceOf}.
952    */
953   function balanceOf(address owner) public view override returns (uint256) {
954     require(owner != address(0), "ERC721A: balance query for the zero address");
955     return uint256(_addressData[owner].balance);
956   }
957 
958   function _numberMinted(address owner) internal view returns (uint256) {
959     require(
960       owner != address(0),
961       "ERC721A: number minted query for the zero address"
962     );
963     return uint256(_addressData[owner].numberMinted);
964   }
965 
966   function ownershipOf(uint256 tokenId)
967     internal
968     view
969     returns (TokenOwnership memory)
970   {
971     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
972 
973     uint256 lowestTokenToCheck;
974     if (tokenId >= maxBatchSize) {
975       lowestTokenToCheck = tokenId - maxBatchSize + 1;
976     }
977 
978     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
979       TokenOwnership memory ownership = _ownerships[curr];
980       if (ownership.addr != address(0)) {
981         return ownership;
982       }
983     }
984 
985     revert("ERC721A: unable to determine the owner of token");
986   }
987 
988   /**
989    * @dev See {IERC721-ownerOf}.
990    */
991   function ownerOf(uint256 tokenId) public view override returns (address) {
992     return ownershipOf(tokenId).addr;
993   }
994 
995   /**
996    * @dev See {IERC721Metadata-name}.
997    */
998   function name() public view virtual override returns (string memory) {
999     return _name;
1000   }
1001 
1002   /**
1003    * @dev See {IERC721Metadata-symbol}.
1004    */
1005   function symbol() public view virtual override returns (string memory) {
1006     return _symbol;
1007   }
1008 
1009   /**
1010    * @dev See {IERC721Metadata-tokenURI}.
1011    */
1012   function tokenURI(uint256 tokenId)
1013     public
1014     view
1015     virtual
1016     override
1017     returns (string memory)
1018   {
1019     require(
1020       _exists(tokenId),
1021       "ERC721Metadata: URI query for nonexistent token"
1022     );
1023 
1024     string memory baseURI = _baseURI();
1025     return
1026       bytes(baseURI).length > 0
1027         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1028         : "";
1029   }
1030 
1031   /**
1032    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1033    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1034    * by default, can be overriden in child contracts.
1035    */
1036   function _baseURI() internal view virtual returns (string memory) {
1037     return "";
1038   }
1039 
1040   /**
1041    * @dev See {IERC721-approve}.
1042    */
1043   function approve(address to, uint256 tokenId) public override {
1044     address owner = ERC721A.ownerOf(tokenId);
1045     require(to != owner, "ERC721A: approval to current owner");
1046 
1047     require(
1048       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1049       "ERC721A: approve caller is not owner nor approved for all"
1050     );
1051 
1052     _approve(to, tokenId, owner);
1053   }
1054 
1055   /**
1056    * @dev See {IERC721-getApproved}.
1057    */
1058   function getApproved(uint256 tokenId) public view override returns (address) {
1059     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1060 
1061     return _tokenApprovals[tokenId];
1062   }
1063 
1064   /**
1065    * @dev See {IERC721-setApprovalForAll}.
1066    */
1067   function setApprovalForAll(address operator, bool approved) public override {
1068     require(operator != _msgSender(), "ERC721A: approve to caller");
1069 
1070     _operatorApprovals[_msgSender()][operator] = approved;
1071     emit ApprovalForAll(_msgSender(), operator, approved);
1072   }
1073 
1074   /**
1075    * @dev See {IERC721-isApprovedForAll}.
1076    */
1077   function isApprovedForAll(address owner, address operator)
1078     public
1079     view
1080     virtual
1081     override
1082     returns (bool)
1083   {
1084     return _operatorApprovals[owner][operator];
1085   }
1086 
1087   /**
1088    * @dev See {IERC721-transferFrom}.
1089    */
1090   function transferFrom(
1091     address from,
1092     address to,
1093     uint256 tokenId
1094   ) public override {
1095     _transfer(from, to, tokenId);
1096   }
1097 
1098   /**
1099    * @dev See {IERC721-safeTransferFrom}.
1100    */
1101   function safeTransferFrom(
1102     address from,
1103     address to,
1104     uint256 tokenId
1105   ) public override {
1106     safeTransferFrom(from, to, tokenId, "");
1107   }
1108 
1109   /**
1110    * @dev See {IERC721-safeTransferFrom}.
1111    */
1112   function safeTransferFrom(
1113     address from,
1114     address to,
1115     uint256 tokenId,
1116     bytes memory _data
1117   ) public override {
1118     _transfer(from, to, tokenId);
1119     require(
1120       _checkOnERC721Received(from, to, tokenId, _data),
1121       "ERC721A: transfer to non ERC721Receiver implementer"
1122     );
1123   }
1124 
1125   /**
1126    * @dev Returns whether `tokenId` exists.
1127    *
1128    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1129    *
1130    * Tokens start existing when they are minted (`_mint`),
1131    */
1132   function _exists(uint256 tokenId) internal view returns (bool) {
1133     return tokenId < currentIndex;
1134   }
1135 
1136   function _safeMint(address to, uint256 quantity) internal {
1137     _safeMint(to, quantity, "");
1138   }
1139 
1140   /**
1141    * @dev Mints `quantity` tokens and transfers them to `to`.
1142    *
1143    * Requirements:
1144    *
1145    * - `to` cannot be the zero address.
1146    * - `quantity` cannot be larger than the max batch size.
1147    *
1148    * Emits a {Transfer} event.
1149    */
1150   function _safeMint(
1151     address to,
1152     uint256 quantity,
1153     bytes memory _data
1154   ) internal {
1155     uint256 startTokenId = currentIndex;
1156     require(to != address(0), "ERC721A: mint to the zero address");
1157     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1158     require(!_exists(startTokenId), "ERC721A: token already minted");
1159     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1160 
1161     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1162 
1163     AddressData memory addressData = _addressData[to];
1164     _addressData[to] = AddressData(
1165       addressData.balance + uint128(quantity),
1166       addressData.numberMinted + uint128(quantity)
1167     );
1168     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1169 
1170     uint256 updatedIndex = startTokenId;
1171 
1172     for (uint256 i = 0; i < quantity; i++) {
1173       emit Transfer(address(0), to, updatedIndex);
1174       require(
1175         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1176         "ERC721A: transfer to non ERC721Receiver implementer"
1177       );
1178       updatedIndex++;
1179     }
1180 
1181     currentIndex = updatedIndex;
1182     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1183   }
1184 
1185   /**
1186    * @dev Transfers `tokenId` from `from` to `to`.
1187    *
1188    * Requirements:
1189    *
1190    * - `to` cannot be the zero address.
1191    * - `tokenId` token must be owned by `from`.
1192    *
1193    * Emits a {Transfer} event.
1194    */
1195   function _transfer(
1196     address from,
1197     address to,
1198     uint256 tokenId
1199   ) private {
1200     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1201 
1202     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1203       getApproved(tokenId) == _msgSender() ||
1204       isApprovedForAll(prevOwnership.addr, _msgSender()));
1205 
1206     require(
1207       isApprovedOrOwner,
1208       "ERC721A: transfer caller is not owner nor approved"
1209     );
1210 
1211     require(
1212       prevOwnership.addr == from,
1213       "ERC721A: transfer from incorrect owner"
1214     );
1215     require(to != address(0), "ERC721A: transfer to the zero address");
1216 
1217     _beforeTokenTransfers(from, to, tokenId, 1);
1218 
1219     // Clear approvals from the previous owner
1220     _approve(address(0), tokenId, prevOwnership.addr);
1221 
1222     _addressData[from].balance -= 1;
1223     _addressData[to].balance += 1;
1224     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1225 
1226     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1227     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1228     uint256 nextTokenId = tokenId + 1;
1229     if (_ownerships[nextTokenId].addr == address(0)) {
1230       if (_exists(nextTokenId)) {
1231         _ownerships[nextTokenId] = TokenOwnership(
1232           prevOwnership.addr,
1233           prevOwnership.startTimestamp
1234         );
1235       }
1236     }
1237 
1238     emit Transfer(from, to, tokenId);
1239     _afterTokenTransfers(from, to, tokenId, 1);
1240   }
1241 
1242   /**
1243    * @dev Approve `to` to operate on `tokenId`
1244    *
1245    * Emits a {Approval} event.
1246    */
1247   function _approve(
1248     address to,
1249     uint256 tokenId,
1250     address owner
1251   ) private {
1252     _tokenApprovals[tokenId] = to;
1253     emit Approval(owner, to, tokenId);
1254   }
1255 
1256   uint256 public nextOwnerToExplicitlySet = 0;
1257 
1258   /**
1259    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1260    */
1261   function _setOwnersExplicit(uint256 quantity) internal {
1262     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1263     require(quantity > 0, "quantity must be nonzero");
1264     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1265     if (endIndex > currentIndex - 1) {
1266       endIndex = currentIndex - 1;
1267     }
1268     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1269     require(_exists(endIndex), "not enough minted yet for this cleanup");
1270     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1271       if (_ownerships[i].addr == address(0)) {
1272         TokenOwnership memory ownership = ownershipOf(i);
1273         _ownerships[i] = TokenOwnership(
1274           ownership.addr,
1275           ownership.startTimestamp
1276         );
1277       }
1278     }
1279     nextOwnerToExplicitlySet = endIndex + 1;
1280   }
1281 
1282   /**
1283    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1284    * The call is not executed if the target address is not a contract.
1285    *
1286    * @param from address representing the previous owner of the given token ID
1287    * @param to target address that will receive the tokens
1288    * @param tokenId uint256 ID of the token to be transferred
1289    * @param _data bytes optional data to send along with the call
1290    * @return bool whether the call correctly returned the expected magic value
1291    */
1292   function _checkOnERC721Received(
1293     address from,
1294     address to,
1295     uint256 tokenId,
1296     bytes memory _data
1297   ) private returns (bool) {
1298     if (to.isContract()) {
1299       try
1300         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1301       returns (bytes4 retval) {
1302         return retval == IERC721Receiver(to).onERC721Received.selector;
1303       } catch (bytes memory reason) {
1304         if (reason.length == 0) {
1305           revert("ERC721A: transfer to non ERC721Receiver implementer");
1306         } else {
1307           assembly {
1308             revert(add(32, reason), mload(reason))
1309           }
1310         }
1311       }
1312     } else {
1313       return true;
1314     }
1315   }
1316 
1317   /**
1318    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1319    *
1320    * startTokenId - the first token id to be transferred
1321    * quantity - the amount to be transferred
1322    *
1323    * Calling conditions:
1324    *
1325    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1326    * transferred to `to`.
1327    * - When `from` is zero, `tokenId` will be minted for `to`.
1328    */
1329   function _beforeTokenTransfers(
1330     address from,
1331     address to,
1332     uint256 startTokenId,
1333     uint256 quantity
1334   ) internal virtual {}
1335 
1336   /**
1337    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1338    * minting.
1339    *
1340    * startTokenId - the first token id to be transferred
1341    * quantity - the amount to be transferred
1342    *
1343    * Calling conditions:
1344    *
1345    * - when `from` and `to` are both non-zero.
1346    * - `from` and `to` are never both zero.
1347    */
1348   function _afterTokenTransfers(
1349     address from,
1350     address to,
1351     uint256 startTokenId,
1352     uint256 quantity
1353   ) internal virtual {}
1354 }
1355 
1356 // File: peasantville.sol
1357 
1358 pragma solidity 0.8.7;
1359 
1360 
1361 
1362 
1363 
1364 /// SPDX-License-Identifier: MIT
1365 
1366 contract PeasantVille is ERC721A, Ownable, ReentrancyGuard {
1367 
1368     using Address for address;
1369     using Strings for uint256;
1370 
1371     string public baseURI;
1372     string public baseExtension = ".json";
1373 
1374     uint256 public collectionSize = 5000;
1375     uint256 public maxPerWallet = 1;
1376     uint256 public pricePerMint = 0 ether;
1377     
1378     mapping (address => uint256) public maxMint;
1379 
1380     constructor() ERC721A("PeasantVille", "PeAsAnT", 1000) {
1381         
1382     }
1383 
1384     function NeWpEaSant(uint256 amount) public payable nonReentrant onlySender 
1385     {      
1386         require(maxMint[msg.sender] + amount <= maxPerWallet);
1387         require(msg.value >= pricePerMint * amount);
1388         require((totalSupply() + amount) <= collectionSize, "Sold out!");
1389 
1390         maxMint[msg.sender] += amount;
1391         _safeMint(msg.sender, amount);
1392     }
1393 
1394     function tEaMmInT(uint256 amount) public onlyOwner
1395     {
1396         require((totalSupply() + amount) <= collectionSize, "Sold out!");
1397         _safeMint(msg.sender, amount);
1398     }
1399 
1400     modifier onlySender {
1401         require(msg.sender == tx.origin);
1402         _;
1403     }
1404 
1405     function updateMintInfo(uint256 newSize, uint256 newMax, uint256 newPrice) public onlyOwner
1406     {
1407         collectionSize = newSize;
1408         maxPerWallet = newMax;
1409         pricePerMint = newPrice;
1410     }
1411 
1412     function _baseURI() internal view virtual override returns (string memory) {
1413         return baseURI;
1414     }
1415 
1416     function withdrawContractEther(address payable recipient) external onlyOwner
1417     {
1418         recipient.transfer(address(this).balance);
1419     }
1420    
1421     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1422         baseURI = _newBaseURI;
1423     }
1424    
1425     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1426     {
1427         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1428 
1429         string memory currentBaseURI = _baseURI();
1430         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1431     }
1432 
1433 }