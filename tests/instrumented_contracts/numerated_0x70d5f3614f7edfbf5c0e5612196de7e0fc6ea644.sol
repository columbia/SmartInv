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
543 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Implementation of the {IERC721Receiver} interface.
553  *
554  * Accepts all token transfers.
555  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
556  */
557 contract ERC721Holder is IERC721Receiver {
558     /**
559      * @dev See {IERC721Receiver-onERC721Received}.
560      *
561      * Always returns `IERC721Receiver.onERC721Received.selector`.
562      */
563     function onERC721Received(
564         address,
565         address,
566         uint256,
567         bytes memory
568     ) public virtual override returns (bytes4) {
569         return this.onERC721Received.selector;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Interface of the ERC165 standard, as defined in the
582  * https://eips.ethereum.org/EIPS/eip-165[EIP].
583  *
584  * Implementers can declare support of contract interfaces, which can then be
585  * queried by others ({ERC165Checker}).
586  *
587  * For an implementation, see {ERC165}.
588  */
589 interface IERC165 {
590     /**
591      * @dev Returns true if this contract implements the interface defined by
592      * `interfaceId`. See the corresponding
593      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
594      * to learn more about how these ids are created.
595      *
596      * This function call must use less than 30 000 gas.
597      */
598     function supportsInterface(bytes4 interfaceId) external view returns (bool);
599 }
600 
601 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @dev Implementation of the {IERC165} interface.
611  *
612  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
613  * for the additional interface id that will be supported. For example:
614  *
615  * ```solidity
616  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
618  * }
619  * ```
620  *
621  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
622  */
623 abstract contract ERC165 is IERC165 {
624     /**
625      * @dev See {IERC165-supportsInterface}.
626      */
627     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
628         return interfaceId == type(IERC165).interfaceId;
629     }
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @dev Required interface of an ERC721 compliant contract.
642  */
643 interface IERC721 is IERC165 {
644     /**
645      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
646      */
647     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
648 
649     /**
650      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
651      */
652     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
653 
654     /**
655      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
656      */
657     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
658 
659     /**
660      * @dev Returns the number of tokens in ``owner``'s account.
661      */
662     function balanceOf(address owner) external view returns (uint256 balance);
663 
664     /**
665      * @dev Returns the owner of the `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function ownerOf(uint256 tokenId) external view returns (address owner);
672 
673     /**
674      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
675      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) external;
692 
693     /**
694      * @dev Transfers `tokenId` token from `from` to `to`.
695      *
696      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must be owned by `from`.
703      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
704      *
705      * Emits a {Transfer} event.
706      */
707     function transferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) external;
712 
713     /**
714      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
715      * The approval is cleared when the token is transferred.
716      *
717      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
718      *
719      * Requirements:
720      *
721      * - The caller must own the token or be an approved operator.
722      * - `tokenId` must exist.
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address to, uint256 tokenId) external;
727 
728     /**
729      * @dev Returns the account approved for `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function getApproved(uint256 tokenId) external view returns (address operator);
736 
737     /**
738      * @dev Approve or remove `operator` as an operator for the caller.
739      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
740      *
741      * Requirements:
742      *
743      * - The `operator` cannot be the caller.
744      *
745      * Emits an {ApprovalForAll} event.
746      */
747     function setApprovalForAll(address operator, bool _approved) external;
748 
749     /**
750      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
751      *
752      * See {setApprovalForAll}
753      */
754     function isApprovedForAll(address owner, address operator) external view returns (bool);
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`.
758      *
759      * Requirements:
760      *
761      * - `from` cannot be the zero address.
762      * - `to` cannot be the zero address.
763      * - `tokenId` token must exist and be owned by `from`.
764      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
765      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
766      *
767      * Emits a {Transfer} event.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId,
773         bytes calldata data
774     ) external;
775 }
776 
777 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
778 
779 
780 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 
785 /**
786  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
787  * @dev See https://eips.ethereum.org/EIPS/eip-721
788  */
789 interface IERC721Metadata is IERC721 {
790     /**
791      * @dev Returns the token collection name.
792      */
793     function name() external view returns (string memory);
794 
795     /**
796      * @dev Returns the token collection symbol.
797      */
798     function symbol() external view returns (string memory);
799 
800     /**
801      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
802      */
803     function tokenURI(uint256 tokenId) external view returns (string memory);
804 }
805 
806 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
807 
808 
809 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
810 
811 pragma solidity ^0.8.0;
812 
813 
814 
815 
816 
817 
818 
819 
820 /**
821  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
822  * the Metadata extension, but not including the Enumerable extension, which is available separately as
823  * {ERC721Enumerable}.
824  */
825 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
826     using Address for address;
827     using Strings for uint256;
828 
829     // Token name
830     string private _name;
831 
832     // Token symbol
833     string private _symbol;
834 
835     // Mapping from token ID to owner address
836     mapping(uint256 => address) private _owners;
837 
838     // Mapping owner address to token count
839     mapping(address => uint256) private _balances;
840 
841     // Mapping from token ID to approved address
842     mapping(uint256 => address) private _tokenApprovals;
843 
844     // Mapping from owner to operator approvals
845     mapping(address => mapping(address => bool)) private _operatorApprovals;
846 
847     /**
848      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
849      */
850     constructor(string memory name_, string memory symbol_) {
851         _name = name_;
852         _symbol = symbol_;
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
859         return
860             interfaceId == type(IERC721).interfaceId ||
861             interfaceId == type(IERC721Metadata).interfaceId ||
862             super.supportsInterface(interfaceId);
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868     function balanceOf(address owner) public view virtual override returns (uint256) {
869         require(owner != address(0), "ERC721: balance query for the zero address");
870         return _balances[owner];
871     }
872 
873     /**
874      * @dev See {IERC721-ownerOf}.
875      */
876     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
877         address owner = _owners[tokenId];
878         require(owner != address(0), "ERC721: owner query for nonexistent token");
879         return owner;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-name}.
884      */
885     function name() public view virtual override returns (string memory) {
886         return _name;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-symbol}.
891      */
892     function symbol() public view virtual override returns (string memory) {
893         return _symbol;
894     }
895 
896     /**
897      * @dev See {IERC721Metadata-tokenURI}.
898      */
899     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
900         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
901 
902         string memory baseURI = _baseURI();
903         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
904     }
905 
906     /**
907      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
908      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
909      * by default, can be overridden in child contracts.
910      */
911     function _baseURI() internal view virtual returns (string memory) {
912         return "";
913     }
914 
915     /**
916      * @dev See {IERC721-approve}.
917      */
918     function approve(address to, uint256 tokenId) public virtual override {
919         address owner = ERC721.ownerOf(tokenId);
920         require(to != owner, "ERC721: approval to current owner");
921 
922         require(
923             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
924             "ERC721: approve caller is not owner nor approved for all"
925         );
926 
927         _approve(to, tokenId);
928     }
929 
930     /**
931      * @dev See {IERC721-getApproved}.
932      */
933     function getApproved(uint256 tokenId) public view virtual override returns (address) {
934         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
935 
936         return _tokenApprovals[tokenId];
937     }
938 
939     /**
940      * @dev See {IERC721-setApprovalForAll}.
941      */
942     function setApprovalForAll(address operator, bool approved) public virtual override {
943         _setApprovalForAll(_msgSender(), operator, approved);
944     }
945 
946     /**
947      * @dev See {IERC721-isApprovedForAll}.
948      */
949     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
950         return _operatorApprovals[owner][operator];
951     }
952 
953     /**
954      * @dev See {IERC721-transferFrom}.
955      */
956     function transferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         //solhint-disable-next-line max-line-length
962         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
963 
964         _transfer(from, to, tokenId);
965     }
966 
967     /**
968      * @dev See {IERC721-safeTransferFrom}.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId
974     ) public virtual override {
975         safeTransferFrom(from, to, tokenId, "");
976     }
977 
978     /**
979      * @dev See {IERC721-safeTransferFrom}.
980      */
981     function safeTransferFrom(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) public virtual override {
987         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
988         _safeTransfer(from, to, tokenId, _data);
989     }
990 
991     /**
992      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
993      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
994      *
995      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
996      *
997      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
998      * implement alternative mechanisms to perform token transfer, such as signature-based.
999      *
1000      * Requirements:
1001      *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must exist and be owned by `from`.
1005      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) internal virtual {
1015         _transfer(from, to, tokenId);
1016         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1017     }
1018 
1019     /**
1020      * @dev Returns whether `tokenId` exists.
1021      *
1022      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1023      *
1024      * Tokens start existing when they are minted (`_mint`),
1025      * and stop existing when they are burned (`_burn`).
1026      */
1027     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1028         return _owners[tokenId] != address(0);
1029     }
1030 
1031     /**
1032      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must exist.
1037      */
1038     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1039         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1040         address owner = ERC721.ownerOf(tokenId);
1041         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1042     }
1043 
1044     /**
1045      * @dev Safely mints `tokenId` and transfers it to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must not exist.
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeMint(address to, uint256 tokenId) internal virtual {
1055         _safeMint(to, tokenId, "");
1056     }
1057 
1058     /**
1059      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1060      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) internal virtual {
1067         _mint(to, tokenId);
1068         require(
1069             _checkOnERC721Received(address(0), to, tokenId, _data),
1070             "ERC721: transfer to non ERC721Receiver implementer"
1071         );
1072     }
1073 
1074     /**
1075      * @dev Mints `tokenId` and transfers it to `to`.
1076      *
1077      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must not exist.
1082      * - `to` cannot be the zero address.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _mint(address to, uint256 tokenId) internal virtual {
1087         require(to != address(0), "ERC721: mint to the zero address");
1088         require(!_exists(tokenId), "ERC721: token already minted");
1089 
1090         _beforeTokenTransfer(address(0), to, tokenId);
1091 
1092         _balances[to] += 1;
1093         _owners[tokenId] = to;
1094 
1095         emit Transfer(address(0), to, tokenId);
1096 
1097         _afterTokenTransfer(address(0), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Destroys `tokenId`.
1102      * The approval is cleared when the token is burned.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must exist.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _burn(uint256 tokenId) internal virtual {
1111         address owner = ERC721.ownerOf(tokenId);
1112 
1113         _beforeTokenTransfer(owner, address(0), tokenId);
1114 
1115         // Clear approvals
1116         _approve(address(0), tokenId);
1117 
1118         _balances[owner] -= 1;
1119         delete _owners[tokenId];
1120 
1121         emit Transfer(owner, address(0), tokenId);
1122 
1123         _afterTokenTransfer(owner, address(0), tokenId);
1124     }
1125 
1126     /**
1127      * @dev Transfers `tokenId` from `from` to `to`.
1128      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must be owned by `from`.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _transfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {
1142         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1143         require(to != address(0), "ERC721: transfer to the zero address");
1144 
1145         _beforeTokenTransfer(from, to, tokenId);
1146 
1147         // Clear approvals from the previous owner
1148         _approve(address(0), tokenId);
1149 
1150         _balances[from] -= 1;
1151         _balances[to] += 1;
1152         _owners[tokenId] = to;
1153 
1154         emit Transfer(from, to, tokenId);
1155 
1156         _afterTokenTransfer(from, to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev Approve `to` to operate on `tokenId`
1161      *
1162      * Emits a {Approval} event.
1163      */
1164     function _approve(address to, uint256 tokenId) internal virtual {
1165         _tokenApprovals[tokenId] = to;
1166         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1167     }
1168 
1169     /**
1170      * @dev Approve `operator` to operate on all of `owner` tokens
1171      *
1172      * Emits a {ApprovalForAll} event.
1173      */
1174     function _setApprovalForAll(
1175         address owner,
1176         address operator,
1177         bool approved
1178     ) internal virtual {
1179         require(owner != operator, "ERC721: approve to caller");
1180         _operatorApprovals[owner][operator] = approved;
1181         emit ApprovalForAll(owner, operator, approved);
1182     }
1183 
1184     /**
1185      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1186      * The call is not executed if the target address is not a contract.
1187      *
1188      * @param from address representing the previous owner of the given token ID
1189      * @param to target address that will receive the tokens
1190      * @param tokenId uint256 ID of the token to be transferred
1191      * @param _data bytes optional data to send along with the call
1192      * @return bool whether the call correctly returned the expected magic value
1193      */
1194     function _checkOnERC721Received(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) private returns (bool) {
1200         if (to.isContract()) {
1201             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1202                 return retval == IERC721Receiver.onERC721Received.selector;
1203             } catch (bytes memory reason) {
1204                 if (reason.length == 0) {
1205                     revert("ERC721: transfer to non ERC721Receiver implementer");
1206                 } else {
1207                     assembly {
1208                         revert(add(32, reason), mload(reason))
1209                     }
1210                 }
1211             }
1212         } else {
1213             return true;
1214         }
1215     }
1216 
1217     /**
1218      * @dev Hook that is called before any token transfer. This includes minting
1219      * and burning.
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` will be minted for `to`.
1226      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1227      * - `from` and `to` are never both zero.
1228      *
1229      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1230      */
1231     function _beforeTokenTransfer(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) internal virtual {}
1236 
1237     /**
1238      * @dev Hook that is called after any transfer of tokens. This includes
1239      * minting and burning.
1240      *
1241      * Calling conditions:
1242      *
1243      * - when `from` and `to` are both non-zero.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _afterTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 // File: slapeold.sol
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 
1260 
1261 
1262 /// SPDX-License-Identifier: UNLICENSED
1263 
1264 
1265 /*
1266   ______                                 __          _    _                       _                             
1267 .' ____ \                               [  |        / |_ (_)                     / \                            
1268 | (___ \_|__   _  _ .--.   .---.  _ .--. | |  ,--. `| |-'__  _   __  .---.      / _ \    _ .--.   .---.  .--.   
1269  _.____`.[  | | |[ '/'`\ \/ /__\\[ `/'`\]| | `'_\ : | | [  |[ \ [  ]/ /__\\    / ___ \  [ '/'`\ \/ /__\\( (`\]  
1270 | \____) || \_/ |,| \__/ || \__., | |    | | // | |,| |, | | \ \/ / | \__.,  _/ /   \ \_ | \__/ || \__., `'.'.  
1271  \______.''.__.'_/| ;.__/  '.__.'[___]  [___]\'-;__/\__/[___] \__/   '.__.' |____| |____|| ;.__/  '.__.'[\__) ) 
1272                  [__|                                                                   [__|                        
1273 */
1274 
1275 
1276 contract SUPERLATIVEAPES is ERC721, Ownable {
1277    
1278     using Strings for uint256;
1279     using Counters for Counters.Counter;
1280 
1281     string public baseURI;
1282     string public baseExtension = ".json";
1283 
1284 
1285     uint256 public maxTx = 5;
1286     uint256 public maxPreTx = 2;
1287     uint256 public maxSupply = 4444;
1288     uint256 public presaleSupply = 2400;
1289     uint256 public price = 0.069 ether;
1290    
1291    
1292     //December 16th 3AM GMT
1293     uint256 public presaleTime = 1639623600;
1294     //December 16th 11PM GMT 
1295     uint256 public presaleClose = 1639695600;
1296 
1297     //December 17th 3AM GMT
1298     uint256 public mainsaleTime = 1639710000;
1299    
1300     Counters.Counter private _tokenIdTracker;
1301 
1302     mapping (address => bool) public presaleWallets;
1303     mapping (address => uint256) public presaleWalletLimits;
1304     mapping (address => uint256) public mainsaleWalletLimits;
1305 
1306 
1307     modifier isMainsaleOpen
1308     {
1309          require(block.timestamp >= mainsaleTime);
1310          _;
1311     }
1312     modifier isPresaleOpen
1313     {
1314          require(block.timestamp >= presaleTime && block.timestamp <= presaleClose, "Presale closed!");
1315          _;
1316     }
1317    
1318     constructor(string memory _initBaseURI) ERC721("Superlative Apes", "SLAPE")
1319     {
1320         setBaseURI(_initBaseURI);
1321         for(uint256 i=0; i<100; i++)
1322         {
1323             _tokenIdTracker.increment();
1324             _safeMint(msg.sender, totalToken());
1325         }
1326         for(uint256 i=0; i<100; i++)
1327         {
1328             _tokenIdTracker.increment();
1329             _safeMint(0xE5dF6d3Ca3CE03015a6AB93CD6d98D5b4fdb9c11, totalToken());
1330         }
1331         for(uint256 i=0; i<100; i++)
1332         {
1333             _tokenIdTracker.increment();
1334             _safeMint(0x3047866171b5E450449f9B1B492D2670aA08A746, totalToken());
1335         }
1336         
1337     }
1338    
1339     function setPrice(uint256 newPrice) external onlyOwner  {
1340         price = newPrice;
1341     }
1342    
1343     function setMaxTx(uint newMax) external onlyOwner {
1344         maxTx = newMax;
1345     }
1346 
1347     function totalToken() public view returns (uint256) {
1348             return _tokenIdTracker.current();
1349     }
1350 
1351     function mainSale(uint8 mintTotal) public payable isMainsaleOpen
1352     {
1353         uint256 totalMinted = mintTotal + mainsaleWalletLimits[msg.sender];
1354         
1355         require(mintTotal >= 1 && mintTotal <= maxTx, "Mint Amount Incorrect");
1356         require(msg.value >= price * mintTotal, "Minting a SLAPE APE Costs 0.069 Ether Each!");
1357         require(totalToken() <= maxSupply, "SOLD OUT!");
1358         require(totalMinted <= maxTx, "You'll pass mint limit!");
1359        
1360         for(uint i=0;i<mintTotal;i++)
1361         {
1362             mainsaleWalletLimits[msg.sender]++;
1363             _tokenIdTracker.increment();
1364             require(totalToken() <= maxSupply, "SOLD OUT!");
1365             _safeMint(msg.sender, totalToken());
1366         }
1367     }
1368    
1369     function preSale(uint8 mintTotal) public payable isPresaleOpen
1370     {
1371         uint256 totalMinted = mintTotal + presaleWalletLimits[msg.sender];
1372 
1373         require(presaleWallets[msg.sender] == true, "You aren't whitelisted!");
1374         require(mintTotal >= 1 && mintTotal <= maxTx, "Mint Amount Incorrect");
1375         require(msg.value >= price * mintTotal, "Minting a SLAPE APE Costs 0.069 Ether Each!");
1376         require(totalToken() <= presaleSupply, "SOLD OUT!");
1377         require(totalMinted <= maxPreTx, "You'll pass mint limit!");
1378        
1379         for(uint i=0; i<mintTotal; i++)
1380         {
1381             presaleWalletLimits[msg.sender]++;
1382             _tokenIdTracker.increment();
1383             require(totalToken() <= presaleSupply, "SOLD OUT!");
1384             _safeMint(msg.sender, totalToken());
1385         }
1386        
1387     }
1388    
1389     function airdrop(address airdropPatricipent, uint8 tokenID) public payable onlyOwner
1390     {
1391         _transfer(address(this), airdropPatricipent, tokenID);
1392     }
1393    
1394     function addWhiteList(address[] memory whiteListedAddresses) public onlyOwner
1395     {
1396         for(uint256 i=0; i<whiteListedAddresses.length;i++)
1397         {
1398             presaleWallets[whiteListedAddresses[i]] = true;
1399         }
1400     }
1401     function isAddressWhitelisted(address whitelist) public view returns(bool)
1402     {
1403         return presaleWallets[whitelist];
1404     }
1405        
1406     function withdrawContractEther(address payable recipient) external onlyOwner
1407     {
1408         recipient.transfer(getBalance());
1409     }
1410    
1411     function _baseURI() internal view virtual override returns (string memory) {
1412         return baseURI;
1413     }
1414    
1415     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1416         baseURI = _newBaseURI;
1417     }
1418    
1419     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1420     {
1421         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1422 
1423         string memory currentBaseURI = _baseURI();
1424         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1425     }
1426     function getBalance() public view returns(uint)
1427     {
1428         return address(this).balance;
1429     }
1430    
1431 
1432 }
1433 // File: slapeFix.sol
1434 
1435 
1436 pragma solidity 0.8.7;
1437 
1438 
1439 
1440 
1441 
1442 
1443 contract SLAPES is ERC721, Ownable, ReentrancyGuard, ERC721Holder {
1444 
1445     using Address for address;
1446     using Strings for uint256;
1447 
1448     string public baseURI;
1449     string public baseExtension = ".json";
1450 
1451     uint256 public totalMinted;
1452 
1453     SUPERLATIVEAPES slapes = SUPERLATIVEAPES(0x1e87eE9249Cc647Af9EDEecB73D6b76AF14d8C27);
1454     mapping (uint256 => bool) public slapeIdMinted;
1455 
1456     constructor(string memory _initBaseURI) ERC721("Superlative Apes", "SLAPE") {
1457         setBaseURI(_initBaseURI);
1458     }
1459 
1460     modifier onlySender {
1461         require(msg.sender == tx.origin);
1462         _;
1463     }
1464     function slapeAuto() public payable nonReentrant onlySender
1465     {      
1466         uint256[] memory slapeIDS = walletOfSlapeOwner(msg.sender);
1467 
1468         for(uint256 i=0; i<slapeIDS.length; i++)
1469         {
1470             require(slapeIdMinted[slapeIDS[i]] == false);
1471 
1472             totalMinted +=1;
1473             slapeIdMinted[slapeIDS[i]] = true;
1474             _mint(msg.sender, slapeIDS[i]);
1475         }
1476     }
1477 
1478     function slapeMint(uint256[] memory slapeIDS) public payable nonReentrant onlySender
1479     {      
1480         for(uint256 i=0; i<slapeIDS.length; i++)
1481         {
1482             require(msg.sender == slapes.ownerOf(slapeIDS[i]));
1483             require(slapeIdMinted[slapeIDS[i]] == false);
1484 
1485             totalMinted +=1;
1486             slapeIdMinted[slapeIDS[i]] = true;
1487             _mint(msg.sender, slapeIDS[i]);
1488         }
1489     }
1490 
1491     function totalSupply() public view returns (uint256)
1492     {
1493         return totalMinted;
1494     }
1495 
1496     function devMint(uint256[] memory slapeIDS) public onlyOwner
1497     {
1498         for(uint256 i=0; i<slapeIDS.length; i++)
1499         {
1500             totalMinted +=1;
1501             slapeIdMinted[slapeIDS[i]] = true;
1502             _mint(msg.sender, slapeIDS[i]);
1503         }
1504     }
1505 
1506     function _baseURI() internal view virtual override returns (string memory) {
1507         return baseURI;
1508     }
1509    
1510     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1511         baseURI = _newBaseURI;
1512     }
1513    
1514     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1515     {
1516         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1517 
1518         string memory currentBaseURI = _baseURI();
1519         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1520     }
1521 
1522     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
1523         uint256 _balance = balanceOf(address_);
1524         uint256[] memory _tokens = new uint256[] (_balance);
1525         uint256 _index;
1526         uint256 _loopThrough = totalSupply();
1527         for (uint256 i = 0; i < _loopThrough; i++) {
1528             bool _exists = _exists(i);
1529             if (_exists) {
1530                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
1531             }
1532             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
1533         }
1534         return _tokens;
1535     }
1536 
1537     function walletOfSlapeOwner(address address_) public virtual view returns (uint256[] memory) {
1538         uint256 _balance = slapes.balanceOf(address_);
1539         uint256[] memory _tokens = new uint256[] (_balance);
1540         uint256 _index;
1541         uint256 _loopThrough = slapes.totalToken();
1542         for (uint256 i = 1; i <= _loopThrough; i++) {
1543 
1544             if(slapes.ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
1545 
1546         }
1547         return _tokens;
1548     }
1549 }