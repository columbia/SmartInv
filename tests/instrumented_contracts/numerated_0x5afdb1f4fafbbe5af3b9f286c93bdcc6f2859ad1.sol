1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/Strings.sol
50 
51 
52 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/access/Ownable.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 
154 /**
155  * @dev Contract module which provides a basic access control mechanism, where
156  * there is an account (an owner) that can be granted exclusive access to
157  * specific functions.
158  *
159  * By default, the owner account will be the one that deploys the contract. This
160  * can later be changed with {transferOwnership}.
161  *
162  * This module is used through inheritance. It will make available the modifier
163  * `onlyOwner`, which can be applied to your functions to restrict their use to
164  * the owner.
165  */
166 abstract contract Ownable is Context {
167     address private _owner;
168 
169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171     /**
172      * @dev Initializes the contract setting the deployer as the initial owner.
173      */
174     constructor() {
175         _transferOwnership(_msgSender());
176     }
177 
178     /**
179      * @dev Returns the address of the current owner.
180      */
181     function owner() public view virtual returns (address) {
182         return _owner;
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
190         _;
191     }
192 
193     /**
194      * @dev Leaves the contract without owner. It will not be possible to call
195      * `onlyOwner` functions anymore. Can only be called by the current owner.
196      *
197      * NOTE: Renouncing ownership will leave the contract without an owner,
198      * thereby removing any functionality that is only available to the owner.
199      */
200     function renounceOwnership() public virtual onlyOwner {
201         _transferOwnership(address(0));
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Can only be called by the current owner.
207      */
208     function transferOwnership(address newOwner) public virtual onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         _transferOwnership(newOwner);
211     }
212 
213     /**
214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
215      * Internal function without access restriction.
216      */
217     function _transferOwnership(address newOwner) internal virtual {
218         address oldOwner = _owner;
219         _owner = newOwner;
220         emit OwnershipTransferred(oldOwner, newOwner);
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Address.sol
225 
226 
227 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
228 
229 pragma solidity ^0.8.1;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      *
252      * [IMPORTANT]
253      * ====
254      * You shouldn't rely on `isContract` to protect against flash loan attacks!
255      *
256      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
257      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
258      * constructor.
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize/address.code.length, which returns 0
263         // for contracts in construction, since the code is only stored at the end
264         // of the constructor execution.
265 
266         return account.code.length > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.call{value: value}(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
422      * revert reason using the provided one.
423      *
424      * _Available since v4.3._
425      */
426     function verifyCallResult(
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal pure returns (bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @title ERC721 token receiver interface
458  * @dev Interface for any contract that wants to support safeTransfers
459  * from ERC721 asset contracts.
460  */
461 interface IERC721Receiver {
462     /**
463      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
464      * by `operator` from `from`, this function is called.
465      *
466      * It must return its Solidity selector to confirm the token transfer.
467      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
468      *
469      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
470      */
471     function onERC721Received(
472         address operator,
473         address from,
474         uint256 tokenId,
475         bytes calldata data
476     ) external returns (bytes4);
477 }
478 
479 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Interface of the ERC165 standard, as defined in the
488  * https://eips.ethereum.org/EIPS/eip-165[EIP].
489  *
490  * Implementers can declare support of contract interfaces, which can then be
491  * queried by others ({ERC165Checker}).
492  *
493  * For an implementation, see {ERC165}.
494  */
495 interface IERC165 {
496     /**
497      * @dev Returns true if this contract implements the interface defined by
498      * `interfaceId`. See the corresponding
499      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
500      * to learn more about how these ids are created.
501      *
502      * This function call must use less than 30 000 gas.
503      */
504     function supportsInterface(bytes4 interfaceId) external view returns (bool);
505 }
506 
507 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Implementation of the {IERC165} interface.
517  *
518  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
519  * for the additional interface id that will be supported. For example:
520  *
521  * ```solidity
522  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
523  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
524  * }
525  * ```
526  *
527  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
528  */
529 abstract contract ERC165 is IERC165 {
530     /**
531      * @dev See {IERC165-supportsInterface}.
532      */
533     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534         return interfaceId == type(IERC165).interfaceId;
535     }
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev Required interface of an ERC721 compliant contract.
548  */
549 interface IERC721 is IERC165 {
550     /**
551      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
552      */
553     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
557      */
558     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
562      */
563     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
564 
565     /**
566      * @dev Returns the number of tokens in ``owner``'s account.
567      */
568     function balanceOf(address owner) external view returns (uint256 balance);
569 
570     /**
571      * @dev Returns the owner of the `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function ownerOf(uint256 tokenId) external view returns (address owner);
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
581      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must exist and be owned by `from`.
588      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
589      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
590      *
591      * Emits a {Transfer} event.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 tokenId
597     ) external;
598 
599     /**
600      * @dev Transfers `tokenId` token from `from` to `to`.
601      *
602      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      *
611      * Emits a {Transfer} event.
612      */
613     function transferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
621      * The approval is cleared when the token is transferred.
622      *
623      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
624      *
625      * Requirements:
626      *
627      * - The caller must own the token or be an approved operator.
628      * - `tokenId` must exist.
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address to, uint256 tokenId) external;
633 
634     /**
635      * @dev Returns the account approved for `tokenId` token.
636      *
637      * Requirements:
638      *
639      * - `tokenId` must exist.
640      */
641     function getApproved(uint256 tokenId) external view returns (address operator);
642 
643     /**
644      * @dev Approve or remove `operator` as an operator for the caller.
645      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
646      *
647      * Requirements:
648      *
649      * - The `operator` cannot be the caller.
650      *
651      * Emits an {ApprovalForAll} event.
652      */
653     function setApprovalForAll(address operator, bool _approved) external;
654 
655     /**
656      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
657      *
658      * See {setApprovalForAll}
659      */
660     function isApprovedForAll(address owner, address operator) external view returns (bool);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must exist and be owned by `from`.
670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672      *
673      * Emits a {Transfer} event.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes calldata data
680     ) external;
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
684 
685 
686 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Enumerable is IERC721 {
696     /**
697      * @dev Returns the total amount of tokens stored by the contract.
698      */
699     function totalSupply() external view returns (uint256);
700 
701     /**
702      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
703      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
704      */
705     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
706 
707     /**
708      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
709      * Use along with {totalSupply} to enumerate all tokens.
710      */
711     function tokenByIndex(uint256 index) external view returns (uint256);
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
724  * @dev See https://eips.ethereum.org/EIPS/eip-721
725  */
726 interface IERC721Metadata is IERC721 {
727     /**
728      * @dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * @dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 }
742 
743 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
744 
745 
746 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 
752 
753 
754 
755 
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension, but not including the Enumerable extension, which is available separately as
760  * {ERC721Enumerable}.
761  */
762 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
763     using Address for address;
764     using Strings for uint256;
765 
766     // Token name
767     string private _name;
768 
769     // Token symbol
770     string private _symbol;
771 
772     // Mapping from token ID to owner address
773     mapping(uint256 => address) private _owners;
774 
775     // Mapping owner address to token count
776     mapping(address => uint256) private _balances;
777 
778     // Mapping from token ID to approved address
779     mapping(uint256 => address) private _tokenApprovals;
780 
781     // Mapping from owner to operator approvals
782     mapping(address => mapping(address => bool)) private _operatorApprovals;
783 
784     /**
785      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
786      */
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790     }
791 
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
796         return
797             interfaceId == type(IERC721).interfaceId ||
798             interfaceId == type(IERC721Metadata).interfaceId ||
799             super.supportsInterface(interfaceId);
800     }
801 
802     /**
803      * @dev See {IERC721-balanceOf}.
804      */
805     function balanceOf(address owner) public view virtual override returns (uint256) {
806         require(owner != address(0), "ERC721: balance query for the zero address");
807         return _balances[owner];
808     }
809 
810     /**
811      * @dev See {IERC721-ownerOf}.
812      */
813     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
814         address owner = _owners[tokenId];
815         require(owner != address(0), "ERC721: owner query for nonexistent token");
816         return owner;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-name}.
821      */
822     function name() public view virtual override returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-symbol}.
828      */
829     function symbol() public view virtual override returns (string memory) {
830         return _symbol;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-tokenURI}.
835      */
836     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
837         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
838 
839         string memory baseURI = _baseURI();
840         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
841     }
842 
843     /**
844      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
845      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
846      * by default, can be overriden in child contracts.
847      */
848     function _baseURI() internal view virtual returns (string memory) {
849         return "";
850     }
851 
852     /**
853      * @dev See {IERC721-approve}.
854      */
855     function approve(address to, uint256 tokenId) public virtual override {
856         address owner = ERC721.ownerOf(tokenId);
857         require(to != owner, "ERC721: approval to current owner");
858 
859         require(
860             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
861             "ERC721: approve caller is not owner nor approved for all"
862         );
863 
864         _approve(to, tokenId);
865     }
866 
867     /**
868      * @dev See {IERC721-getApproved}.
869      */
870     function getApproved(uint256 tokenId) public view virtual override returns (address) {
871         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
872 
873         return _tokenApprovals[tokenId];
874     }
875 
876     /**
877      * @dev See {IERC721-setApprovalForAll}.
878      */
879     function setApprovalForAll(address operator, bool approved) public virtual override {
880         _setApprovalForAll(_msgSender(), operator, approved);
881     }
882 
883     /**
884      * @dev See {IERC721-isApprovedForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-transferFrom}.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         //solhint-disable-next-line max-line-length
899         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
900 
901         _transfer(from, to, tokenId);
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         safeTransferFrom(from, to, tokenId, "");
913     }
914 
915     /**
916      * @dev See {IERC721-safeTransferFrom}.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) public virtual override {
924         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
925         _safeTransfer(from, to, tokenId, _data);
926     }
927 
928     /**
929      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
930      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
931      *
932      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
933      *
934      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
935      * implement alternative mechanisms to perform token transfer, such as signature-based.
936      *
937      * Requirements:
938      *
939      * - `from` cannot be the zero address.
940      * - `to` cannot be the zero address.
941      * - `tokenId` token must exist and be owned by `from`.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeTransfer(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) internal virtual {
952         _transfer(from, to, tokenId);
953         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
954     }
955 
956     /**
957      * @dev Returns whether `tokenId` exists.
958      *
959      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
960      *
961      * Tokens start existing when they are minted (`_mint`),
962      * and stop existing when they are burned (`_burn`).
963      */
964     function _exists(uint256 tokenId) internal view virtual returns (bool) {
965         return _owners[tokenId] != address(0);
966     }
967 
968     /**
969      * @dev Returns whether `spender` is allowed to manage `tokenId`.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must exist.
974      */
975     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
976         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
977         address owner = ERC721.ownerOf(tokenId);
978         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
979     }
980 
981     /**
982      * @dev Safely mints `tokenId` and transfers it to `to`.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must not exist.
987      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeMint(address to, uint256 tokenId) internal virtual {
992         _safeMint(to, tokenId, "");
993     }
994 
995     /**
996      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
997      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
998      */
999     function _safeMint(
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) internal virtual {
1004         _mint(to, tokenId);
1005         require(
1006             _checkOnERC721Received(address(0), to, tokenId, _data),
1007             "ERC721: transfer to non ERC721Receiver implementer"
1008         );
1009     }
1010 
1011     /**
1012      * @dev Mints `tokenId` and transfers it to `to`.
1013      *
1014      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must not exist.
1019      * - `to` cannot be the zero address.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _mint(address to, uint256 tokenId) internal virtual {
1024         require(to != address(0), "ERC721: mint to the zero address");
1025         require(!_exists(tokenId), "ERC721: token already minted");
1026 
1027         _beforeTokenTransfer(address(0), to, tokenId);
1028 
1029         _balances[to] += 1;
1030         _owners[tokenId] = to;
1031 
1032         emit Transfer(address(0), to, tokenId);
1033 
1034         _afterTokenTransfer(address(0), to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Destroys `tokenId`.
1039      * The approval is cleared when the token is burned.
1040      *
1041      * Requirements:
1042      *
1043      * - `tokenId` must exist.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _burn(uint256 tokenId) internal virtual {
1048         address owner = ERC721.ownerOf(tokenId);
1049 
1050         _beforeTokenTransfer(owner, address(0), tokenId);
1051 
1052         // Clear approvals
1053         _approve(address(0), tokenId);
1054 
1055         _balances[owner] -= 1;
1056         delete _owners[tokenId];
1057 
1058         emit Transfer(owner, address(0), tokenId);
1059 
1060         _afterTokenTransfer(owner, address(0), tokenId);
1061     }
1062 
1063     /**
1064      * @dev Transfers `tokenId` from `from` to `to`.
1065      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must be owned by `from`.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual {
1079         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1080         require(to != address(0), "ERC721: transfer to the zero address");
1081 
1082         _beforeTokenTransfer(from, to, tokenId);
1083 
1084         // Clear approvals from the previous owner
1085         _approve(address(0), tokenId);
1086 
1087         _balances[from] -= 1;
1088         _balances[to] += 1;
1089         _owners[tokenId] = to;
1090 
1091         emit Transfer(from, to, tokenId);
1092 
1093         _afterTokenTransfer(from, to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Approve `to` to operate on `tokenId`
1098      *
1099      * Emits a {Approval} event.
1100      */
1101     function _approve(address to, uint256 tokenId) internal virtual {
1102         _tokenApprovals[tokenId] = to;
1103         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev Approve `operator` to operate on all of `owner` tokens
1108      *
1109      * Emits a {ApprovalForAll} event.
1110      */
1111     function _setApprovalForAll(
1112         address owner,
1113         address operator,
1114         bool approved
1115     ) internal virtual {
1116         require(owner != operator, "ERC721: approve to caller");
1117         _operatorApprovals[owner][operator] = approved;
1118         emit ApprovalForAll(owner, operator, approved);
1119     }
1120 
1121     /**
1122      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1123      * The call is not executed if the target address is not a contract.
1124      *
1125      * @param from address representing the previous owner of the given token ID
1126      * @param to target address that will receive the tokens
1127      * @param tokenId uint256 ID of the token to be transferred
1128      * @param _data bytes optional data to send along with the call
1129      * @return bool whether the call correctly returned the expected magic value
1130      */
1131     function _checkOnERC721Received(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) private returns (bool) {
1137         if (to.isContract()) {
1138             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1139                 return retval == IERC721Receiver.onERC721Received.selector;
1140             } catch (bytes memory reason) {
1141                 if (reason.length == 0) {
1142                     revert("ERC721: transfer to non ERC721Receiver implementer");
1143                 } else {
1144                     assembly {
1145                         revert(add(32, reason), mload(reason))
1146                     }
1147                 }
1148             }
1149         } else {
1150             return true;
1151         }
1152     }
1153 
1154     /**
1155      * @dev Hook that is called before any token transfer. This includes minting
1156      * and burning.
1157      *
1158      * Calling conditions:
1159      *
1160      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1161      * transferred to `to`.
1162      * - When `from` is zero, `tokenId` will be minted for `to`.
1163      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1164      * - `from` and `to` are never both zero.
1165      *
1166      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1167      */
1168     function _beforeTokenTransfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) internal virtual {}
1173 
1174     /**
1175      * @dev Hook that is called after any transfer of tokens. This includes
1176      * minting and burning.
1177      *
1178      * Calling conditions:
1179      *
1180      * - when `from` and `to` are both non-zero.
1181      * - `from` and `to` are never both zero.
1182      *
1183      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1184      */
1185     function _afterTokenTransfer(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) internal virtual {}
1190 }
1191 
1192 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1193 
1194 
1195 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 
1201 /**
1202  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1203  * enumerability of all the token ids in the contract as well as all token ids owned by each
1204  * account.
1205  */
1206 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1207     // Mapping from owner to list of owned token IDs
1208     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1209 
1210     // Mapping from token ID to index of the owner tokens list
1211     mapping(uint256 => uint256) private _ownedTokensIndex;
1212 
1213     // Array with all token ids, used for enumeration
1214     uint256[] private _allTokens;
1215 
1216     // Mapping from token id to position in the allTokens array
1217     mapping(uint256 => uint256) private _allTokensIndex;
1218 
1219     /**
1220      * @dev See {IERC165-supportsInterface}.
1221      */
1222     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1223         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1224     }
1225 
1226     /**
1227      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1228      */
1229     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1230         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1231         return _ownedTokens[owner][index];
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Enumerable-totalSupply}.
1236      */
1237     function totalSupply() public view virtual override returns (uint256) {
1238         return _allTokens.length;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-tokenByIndex}.
1243      */
1244     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1245         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1246         return _allTokens[index];
1247     }
1248 
1249     /**
1250      * @dev Hook that is called before any token transfer. This includes minting
1251      * and burning.
1252      *
1253      * Calling conditions:
1254      *
1255      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1256      * transferred to `to`.
1257      * - When `from` is zero, `tokenId` will be minted for `to`.
1258      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1259      * - `from` cannot be the zero address.
1260      * - `to` cannot be the zero address.
1261      *
1262      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1263      */
1264     function _beforeTokenTransfer(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) internal virtual override {
1269         super._beforeTokenTransfer(from, to, tokenId);
1270 
1271         if (from == address(0)) {
1272             _addTokenToAllTokensEnumeration(tokenId);
1273         } else if (from != to) {
1274             _removeTokenFromOwnerEnumeration(from, tokenId);
1275         }
1276         if (to == address(0)) {
1277             _removeTokenFromAllTokensEnumeration(tokenId);
1278         } else if (to != from) {
1279             _addTokenToOwnerEnumeration(to, tokenId);
1280         }
1281     }
1282 
1283     /**
1284      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1285      * @param to address representing the new owner of the given token ID
1286      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1287      */
1288     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1289         uint256 length = ERC721.balanceOf(to);
1290         _ownedTokens[to][length] = tokenId;
1291         _ownedTokensIndex[tokenId] = length;
1292     }
1293 
1294     /**
1295      * @dev Private function to add a token to this extension's token tracking data structures.
1296      * @param tokenId uint256 ID of the token to be added to the tokens list
1297      */
1298     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1299         _allTokensIndex[tokenId] = _allTokens.length;
1300         _allTokens.push(tokenId);
1301     }
1302 
1303     /**
1304      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1305      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1306      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1307      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1308      * @param from address representing the previous owner of the given token ID
1309      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1310      */
1311     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1312         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1313         // then delete the last slot (swap and pop).
1314 
1315         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1316         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1317 
1318         // When the token to delete is the last token, the swap operation is unnecessary
1319         if (tokenIndex != lastTokenIndex) {
1320             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1321 
1322             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1323             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1324         }
1325 
1326         // This also deletes the contents at the last position of the array
1327         delete _ownedTokensIndex[tokenId];
1328         delete _ownedTokens[from][lastTokenIndex];
1329     }
1330 
1331     /**
1332      * @dev Private function to remove a token from this extension's token tracking data structures.
1333      * This has O(1) time complexity, but alters the order of the _allTokens array.
1334      * @param tokenId uint256 ID of the token to be removed from the tokens list
1335      */
1336     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1337         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1338         // then delete the last slot (swap and pop).
1339 
1340         uint256 lastTokenIndex = _allTokens.length - 1;
1341         uint256 tokenIndex = _allTokensIndex[tokenId];
1342 
1343         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1344         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1345         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1346         uint256 lastTokenId = _allTokens[lastTokenIndex];
1347 
1348         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1349         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1350 
1351         // This also deletes the contents at the last position of the array
1352         delete _allTokensIndex[tokenId];
1353         _allTokens.pop();
1354     }
1355 }
1356 
1357 // File: contracts/METASQUATCH.sol
1358 
1359 
1360 pragma solidity >=0.7.0 <0.9.0;
1361 
1362 
1363 
1364 
1365 
1366 contract METASQUATCH is ERC721, Ownable {
1367   using Strings for uint256;
1368   using Counters for Counters.Counter;
1369 
1370   Counters.Counter private supply;
1371 
1372   string public uriPrefix = "";
1373   string public uriSuffix = ".json";
1374   string public hiddenMetadataUri;
1375   
1376   uint256 public cost = 0 ether;
1377   uint256 public maxSupply = 550;
1378   uint256 public maxMintAmountPerTx = 3;
1379   uint256 public maxFreeMintPerWallet = 3;
1380 
1381   bool public paused = true;
1382   bool public revealed = true;
1383 
1384   mapping(address => uint256) public addressToFreeMinted;
1385 
1386 
1387   constructor() ERC721("METASQUATCH", "METASQUATCH") {
1388     setHiddenMetadataUri("ipfs://Fuckyournft/hidden.json");
1389   }
1390 
1391   modifier mintCompliance(uint256 _mintAmount) {
1392     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1393     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1394     _;
1395   }
1396 
1397   function totalSupply() public view returns (uint256) {
1398     return supply.current();
1399   }
1400 
1401   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1402     require(!paused, "The contract is paused!");
1403     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1404     require(addressToFreeMinted[msg.sender] + _mintAmount <= maxFreeMintPerWallet, "caller already minted for free");
1405 
1406     _mintLoop(msg.sender, _mintAmount);
1407     addressToFreeMinted[msg.sender] += _mintAmount;
1408   }
1409   
1410   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1411     _mintLoop(_receiver, _mintAmount);
1412   }
1413 
1414   function walletOfOwner(address _owner)
1415     public
1416     view
1417     returns (uint256[] memory)
1418   {
1419     uint256 ownerTokenCount = balanceOf(_owner);
1420     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1421     uint256 currentTokenId = 1;
1422     uint256 ownedTokenIndex = 0;
1423 
1424     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1425       address currentTokenOwner = ownerOf(currentTokenId);
1426 
1427       if (currentTokenOwner == _owner) {
1428         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1429 
1430         ownedTokenIndex++;
1431       }
1432 
1433       currentTokenId++;
1434     }
1435 
1436     return ownedTokenIds;
1437   }
1438 
1439   function tokenURI(uint256 _tokenId)
1440     public
1441     view
1442     virtual
1443     override
1444     returns (string memory)
1445   {
1446     require(
1447       _exists(_tokenId),
1448       "ERC721Metadata: URI query for nonexistent token"
1449     );
1450 
1451     if (revealed == false) {
1452       return hiddenMetadataUri;
1453     }
1454 
1455     string memory currentBaseURI = _baseURI();
1456     return bytes(currentBaseURI).length > 0
1457         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1458         : "";
1459   }
1460 
1461   function setRevealed(bool _state) public onlyOwner {
1462     revealed = _state;
1463   }
1464 
1465   function setCost(uint256 _cost) public onlyOwner {
1466     cost = _cost;
1467   }
1468 
1469   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1470     maxMintAmountPerTx = _maxMintAmountPerTx;
1471   }
1472 
1473   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1474     hiddenMetadataUri = _hiddenMetadataUri;
1475   }
1476 
1477   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1478     uriPrefix = _uriPrefix;
1479   }
1480 
1481   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1482     uriSuffix = _uriSuffix;
1483   }
1484 
1485   function setPaused(bool _state) public onlyOwner {
1486     paused = _state;
1487   }
1488 
1489   function withdraw() public onlyOwner {
1490     // This will transfer the remaining contract balance to the owner.
1491     // Do not remove this otherwise you will not be able to withdraw the funds.
1492     // =============================================================================
1493     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1494     require(os);
1495     // =============================================================================
1496   }
1497 
1498   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1499     for (uint256 i = 0; i < _mintAmount; i++) {
1500       supply.increment();
1501       _safeMint(_receiver, supply.current());
1502     }
1503   }
1504 
1505   function _baseURI() internal view virtual override returns (string memory) {
1506     return uriPrefix;
1507   }
1508 }