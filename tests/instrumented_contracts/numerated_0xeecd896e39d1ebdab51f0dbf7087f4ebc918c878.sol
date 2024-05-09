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
571 // File: @openzeppelin/contracts/interfaces/IERC165.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev Interface for the NFT Royalty Standard.
589  *
590  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
591  * support for royalty payments across all NFT marketplaces and ecosystem participants.
592  *
593  * _Available since v4.5._
594  */
595 interface IERC2981 is IERC165 {
596     /**
597      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
598      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
599      */
600     function royaltyInfo(uint256 tokenId, uint256 salePrice)
601         external
602         view
603         returns (address receiver, uint256 royaltyAmount);
604 }
605 
606 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633         return interfaceId == type(IERC165).interfaceId;
634     }
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @dev Required interface of an ERC721 compliant contract.
647  */
648 interface IERC721 is IERC165 {
649     /**
650      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
651      */
652     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
653 
654     /**
655      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
656      */
657     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
658 
659     /**
660      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
661      */
662     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
663 
664     /**
665      * @dev Returns the number of tokens in ``owner``'s account.
666      */
667     function balanceOf(address owner) external view returns (uint256 balance);
668 
669     /**
670      * @dev Returns the owner of the `tokenId` token.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function ownerOf(uint256 tokenId) external view returns (address owner);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
680      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must exist and be owned by `from`.
687      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId
696     ) external;
697 
698     /**
699      * @dev Transfers `tokenId` token from `from` to `to`.
700      *
701      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
702      *
703      * Requirements:
704      *
705      * - `from` cannot be the zero address.
706      * - `to` cannot be the zero address.
707      * - `tokenId` token must be owned by `from`.
708      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
709      *
710      * Emits a {Transfer} event.
711      */
712     function transferFrom(
713         address from,
714         address to,
715         uint256 tokenId
716     ) external;
717 
718     /**
719      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
720      * The approval is cleared when the token is transferred.
721      *
722      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
723      *
724      * Requirements:
725      *
726      * - The caller must own the token or be an approved operator.
727      * - `tokenId` must exist.
728      *
729      * Emits an {Approval} event.
730      */
731     function approve(address to, uint256 tokenId) external;
732 
733     /**
734      * @dev Returns the account approved for `tokenId` token.
735      *
736      * Requirements:
737      *
738      * - `tokenId` must exist.
739      */
740     function getApproved(uint256 tokenId) external view returns (address operator);
741 
742     /**
743      * @dev Approve or remove `operator` as an operator for the caller.
744      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool _approved) external;
753 
754     /**
755      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
756      *
757      * See {setApprovalForAll}
758      */
759     function isApprovedForAll(address owner, address operator) external view returns (bool);
760 
761     /**
762      * @dev Safely transfers `tokenId` token from `from` to `to`.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must exist and be owned by `from`.
769      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes calldata data
779     ) external;
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
783 
784 
785 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
792  * @dev See https://eips.ethereum.org/EIPS/eip-721
793  */
794 interface IERC721Metadata is IERC721 {
795     /**
796      * @dev Returns the token collection name.
797      */
798     function name() external view returns (string memory);
799 
800     /**
801      * @dev Returns the token collection symbol.
802      */
803     function symbol() external view returns (string memory);
804 
805     /**
806      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
807      */
808     function tokenURI(uint256 tokenId) external view returns (string memory);
809 }
810 
811 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
812 
813 
814 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
815 
816 pragma solidity ^0.8.0;
817 
818 
819 
820 
821 
822 
823 
824 
825 /**
826  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
827  * the Metadata extension, but not including the Enumerable extension, which is available separately as
828  * {ERC721Enumerable}.
829  */
830 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
831     using Address for address;
832     using Strings for uint256;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to owner address
841     mapping(uint256 => address) private _owners;
842 
843     // Mapping owner address to token count
844     mapping(address => uint256) private _balances;
845 
846     // Mapping from token ID to approved address
847     mapping(uint256 => address) private _tokenApprovals;
848 
849     // Mapping from owner to operator approvals
850     mapping(address => mapping(address => bool)) private _operatorApprovals;
851 
852     /**
853      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
854      */
855     constructor(string memory name_, string memory symbol_) {
856         _name = name_;
857         _symbol = symbol_;
858     }
859 
860     /**
861      * @dev See {IERC165-supportsInterface}.
862      */
863     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
864         return
865             interfaceId == type(IERC721).interfaceId ||
866             interfaceId == type(IERC721Metadata).interfaceId ||
867             super.supportsInterface(interfaceId);
868     }
869 
870     /**
871      * @dev See {IERC721-balanceOf}.
872      */
873     function balanceOf(address owner) public view virtual override returns (uint256) {
874         require(owner != address(0), "ERC721: balance query for the zero address");
875         return _balances[owner];
876     }
877 
878     /**
879      * @dev See {IERC721-ownerOf}.
880      */
881     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
882         address owner = _owners[tokenId];
883         require(owner != address(0), "ERC721: owner query for nonexistent token");
884         return owner;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-name}.
889      */
890     function name() public view virtual override returns (string memory) {
891         return _name;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-symbol}.
896      */
897     function symbol() public view virtual override returns (string memory) {
898         return _symbol;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-tokenURI}.
903      */
904     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
905         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
906 
907         string memory baseURI = _baseURI();
908         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
909     }
910 
911     /**
912      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
913      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
914      * by default, can be overriden in child contracts.
915      */
916     function _baseURI() internal view virtual returns (string memory) {
917         return "";
918     }
919 
920     /**
921      * @dev See {IERC721-approve}.
922      */
923     function approve(address to, uint256 tokenId) public virtual override {
924         address owner = ERC721.ownerOf(tokenId);
925         require(to != owner, "ERC721: approval to current owner");
926 
927         require(
928             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
929             "ERC721: approve caller is not owner nor approved for all"
930         );
931 
932         _approve(to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-getApproved}.
937      */
938     function getApproved(uint256 tokenId) public view virtual override returns (address) {
939         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
940 
941         return _tokenApprovals[tokenId];
942     }
943 
944     /**
945      * @dev See {IERC721-setApprovalForAll}.
946      */
947     function setApprovalForAll(address operator, bool approved) public virtual override {
948         _setApprovalForAll(_msgSender(), operator, approved);
949     }
950 
951     /**
952      * @dev See {IERC721-isApprovedForAll}.
953      */
954     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
955         return _operatorApprovals[owner][operator];
956     }
957 
958     /**
959      * @dev See {IERC721-transferFrom}.
960      */
961     function transferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) public virtual override {
966         //solhint-disable-next-line max-line-length
967         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
968 
969         _transfer(from, to, tokenId);
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId
979     ) public virtual override {
980         safeTransferFrom(from, to, tokenId, "");
981     }
982 
983     /**
984      * @dev See {IERC721-safeTransferFrom}.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) public virtual override {
992         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
993         _safeTransfer(from, to, tokenId, _data);
994     }
995 
996     /**
997      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
998      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
999      *
1000      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1001      *
1002      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1003      * implement alternative mechanisms to perform token transfer, such as signature-based.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must exist and be owned by `from`.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _safeTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) internal virtual {
1020         _transfer(from, to, tokenId);
1021         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1022     }
1023 
1024     /**
1025      * @dev Returns whether `tokenId` exists.
1026      *
1027      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1028      *
1029      * Tokens start existing when they are minted (`_mint`),
1030      * and stop existing when they are burned (`_burn`).
1031      */
1032     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1033         return _owners[tokenId] != address(0);
1034     }
1035 
1036     /**
1037      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must exist.
1042      */
1043     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1044         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1045         address owner = ERC721.ownerOf(tokenId);
1046         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1047     }
1048 
1049     /**
1050      * @dev Safely mints `tokenId` and transfers it to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must not exist.
1055      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _safeMint(address to, uint256 tokenId) internal virtual {
1060         _safeMint(to, tokenId, "");
1061     }
1062 
1063     /**
1064      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1065      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) internal virtual {
1072         _mint(to, tokenId);
1073         require(
1074             _checkOnERC721Received(address(0), to, tokenId, _data),
1075             "ERC721: transfer to non ERC721Receiver implementer"
1076         );
1077     }
1078 
1079     /**
1080      * @dev Mints `tokenId` and transfers it to `to`.
1081      *
1082      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1083      *
1084      * Requirements:
1085      *
1086      * - `tokenId` must not exist.
1087      * - `to` cannot be the zero address.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _mint(address to, uint256 tokenId) internal virtual {
1092         require(to != address(0), "ERC721: mint to the zero address");
1093         require(!_exists(tokenId), "ERC721: token already minted");
1094 
1095         _beforeTokenTransfer(address(0), to, tokenId);
1096 
1097         _balances[to] += 1;
1098         _owners[tokenId] = to;
1099 
1100         emit Transfer(address(0), to, tokenId);
1101 
1102         _afterTokenTransfer(address(0), to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Destroys `tokenId`.
1107      * The approval is cleared when the token is burned.
1108      *
1109      * Requirements:
1110      *
1111      * - `tokenId` must exist.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _burn(uint256 tokenId) internal virtual {
1116         address owner = ERC721.ownerOf(tokenId);
1117 
1118         _beforeTokenTransfer(owner, address(0), tokenId);
1119 
1120         // Clear approvals
1121         _approve(address(0), tokenId);
1122 
1123         _balances[owner] -= 1;
1124         delete _owners[tokenId];
1125 
1126         emit Transfer(owner, address(0), tokenId);
1127 
1128         _afterTokenTransfer(owner, address(0), tokenId);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must be owned by `from`.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _transfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual {
1147         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1148         require(to != address(0), "ERC721: transfer to the zero address");
1149 
1150         _beforeTokenTransfer(from, to, tokenId);
1151 
1152         // Clear approvals from the previous owner
1153         _approve(address(0), tokenId);
1154 
1155         _balances[from] -= 1;
1156         _balances[to] += 1;
1157         _owners[tokenId] = to;
1158 
1159         emit Transfer(from, to, tokenId);
1160 
1161         _afterTokenTransfer(from, to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Approve `to` to operate on `tokenId`
1166      *
1167      * Emits a {Approval} event.
1168      */
1169     function _approve(address to, uint256 tokenId) internal virtual {
1170         _tokenApprovals[tokenId] = to;
1171         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1172     }
1173 
1174     /**
1175      * @dev Approve `operator` to operate on all of `owner` tokens
1176      *
1177      * Emits a {ApprovalForAll} event.
1178      */
1179     function _setApprovalForAll(
1180         address owner,
1181         address operator,
1182         bool approved
1183     ) internal virtual {
1184         require(owner != operator, "ERC721: approve to caller");
1185         _operatorApprovals[owner][operator] = approved;
1186         emit ApprovalForAll(owner, operator, approved);
1187     }
1188 
1189     /**
1190      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1191      * The call is not executed if the target address is not a contract.
1192      *
1193      * @param from address representing the previous owner of the given token ID
1194      * @param to target address that will receive the tokens
1195      * @param tokenId uint256 ID of the token to be transferred
1196      * @param _data bytes optional data to send along with the call
1197      * @return bool whether the call correctly returned the expected magic value
1198      */
1199     function _checkOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         if (to.isContract()) {
1206             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1207                 return retval == IERC721Receiver.onERC721Received.selector;
1208             } catch (bytes memory reason) {
1209                 if (reason.length == 0) {
1210                     revert("ERC721: transfer to non ERC721Receiver implementer");
1211                 } else {
1212                     assembly {
1213                         revert(add(32, reason), mload(reason))
1214                     }
1215                 }
1216             }
1217         } else {
1218             return true;
1219         }
1220     }
1221 
1222     /**
1223      * @dev Hook that is called before any token transfer. This includes minting
1224      * and burning.
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1232      * - `from` and `to` are never both zero.
1233      *
1234      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1235      */
1236     function _beforeTokenTransfer(
1237         address from,
1238         address to,
1239         uint256 tokenId
1240     ) internal virtual {}
1241 
1242     /**
1243      * @dev Hook that is called after any transfer of tokens. This includes
1244      * minting and burning.
1245      *
1246      * Calling conditions:
1247      *
1248      * - when `from` and `to` are both non-zero.
1249      * - `from` and `to` are never both zero.
1250      *
1251      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1252      */
1253     function _afterTokenTransfer(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) internal virtual {}
1258 }
1259 
1260 // File: contracts/CopeBeanz.sol
1261 
1262 // SPDX-License-Identifier: MIT
1263 // Creator: Gigachad
1264 pragma solidity ^0.8.9;
1265 /**
1266  .d8888b.                                   888888b.                                       
1267 d88P  Y88b                                  888  "88b                                      
1268 888    888                                  888  .88P                                      
1269 888         .d88b.  88888b.   .d88b.        8888888K.   .d88b.   8888b.  88888b.  88888888 
1270 888        d88""88b 888 "88b d8P  Y8b       888  "Y88b d8P  Y8b     "88b 888 "88b    d88P  
1271 888    888 888  888 888  888 88888888       888    888 88888888 .d888888 888  888   d88P   
1272 Y88b  d88P Y88..88P 888 d88P Y8b.           888   d88P Y8b.     888  888 888  888  d88P    
1273  "Y8888P"   "Y88P"  88888P"   "Y8888        8888888P"   "Y8888  "Y888888 888  888 88888888 
1274                     888                                                                    
1275                     888                                                                    
1276                     888                                                                    **/
1277 contract CopeBeanz is ERC721, IERC2981, ReentrancyGuard, Ownable {
1278   using Counters for Counters.Counter;
1279 
1280   constructor(string memory customBaseURI_) ERC721("CopeBeanz", "cbnz") {
1281     customBaseURI = customBaseURI_;
1282   }
1283 
1284 
1285   mapping(address => uint256) private mintCountMap;
1286 
1287   mapping(address => uint256) private allowedMintCountMap;
1288 
1289   uint256 public constant MINT_LIMIT_PER_WALLET = 5;
1290 
1291   function allowedMintCount(address minter) public view returns (uint256) {
1292     return MINT_LIMIT_PER_WALLET - mintCountMap[minter];
1293   }
1294 
1295   function updateMintCount(address minter, uint256 count) private {
1296     mintCountMap[minter] += count;
1297   }
1298 
1299 
1300   uint256 public constant MAX_SUPPLY = 1500;
1301 
1302   uint256 public constant MAX_MULTIMINT = 5;
1303 
1304   uint256 public constant PRICE = 20000000000000000;  //same as 0.02
1305 
1306   Counters.Counter private supplyCounter;
1307 
1308   function mint(uint256 count) public payable nonReentrant {
1309     require(saleIsActive, "Sale not active");
1310 
1311     if (allowedMintCount(msg.sender) >= count) {
1312       updateMintCount(msg.sender, count);
1313     } else {
1314       revert("Minting limit exceeded");
1315     }
1316 
1317     require(totalSupply() + count - 1 < MAX_SUPPLY, "Max Supply Reached");
1318 
1319     require(count <= MAX_MULTIMINT, "Mint most 5 at a time");
1320 
1321     require(
1322       msg.value >= PRICE * count, "Too little eth, 0.02 ETH per item"
1323     );
1324 
1325     for (uint256 i = 0; i < count; i++) {
1326       _mint(msg.sender, totalSupply());
1327 
1328       supplyCounter.increment();
1329     }
1330   }
1331 
1332       /**
1333      * @dev See {IERC721Metadata-tokenURI}.
1334      */
1335     function tokenURI(uint256 tokenId)
1336         public
1337         view
1338         virtual
1339         override
1340         returns (string memory)
1341     {
1342         require(
1343             _exists(tokenId),
1344             "ERC721Metadata: URI query for nonexistent token"
1345         );
1346         
1347             return
1348                 string(
1349                     abi.encodePacked(
1350                         customBaseURI,
1351                         "/",
1352                         Strings.toString(tokenId+1),
1353                         ".json"
1354                     )
1355                 );
1356     }
1357 
1358   function totalSupply() public view returns (uint256) {
1359     return supplyCounter.current();
1360   }
1361 
1362   bool public saleIsActive = true;
1363 
1364   function setSaleIsActive(bool saleIsActive_) external onlyOwner {
1365     saleIsActive = saleIsActive_;
1366   }
1367 
1368 
1369   string private customBaseURI;
1370 
1371   function setBaseURI(string memory customBaseURI_) external onlyOwner {
1372     customBaseURI = customBaseURI_;
1373   }
1374 
1375   function _baseURI() internal view virtual override returns (string memory) {
1376     return customBaseURI;
1377   }
1378 
1379 
1380   function withdraw() public nonReentrant {
1381     uint256 balance = address(this).balance;
1382 
1383     Address.sendValue(payable(owner()), balance);
1384   }
1385 
1386 
1387   function royaltyInfo(uint256, uint256 salePrice) external view override
1388     returns (address receiver, uint256 royaltyAmount)
1389   {
1390     return (address(this), (salePrice * 690) / 10000);
1391   }
1392 
1393   function supportsInterface(bytes4 interfaceId)
1394     public
1395     view
1396     virtual
1397     override(ERC721, IERC165)
1398     returns (bool)
1399   {
1400     return (
1401       interfaceId == type(IERC2981).interfaceId ||
1402       super.supportsInterface(interfaceId)
1403     );
1404   }
1405 }