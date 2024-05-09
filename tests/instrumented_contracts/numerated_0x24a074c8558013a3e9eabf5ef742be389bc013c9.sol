1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
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
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Address.sol
224 
225 
226 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
227 
228 pragma solidity ^0.8.1;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      *
251      * [IMPORTANT]
252      * ====
253      * You shouldn't rely on `isContract` to protect against flash loan attacks!
254      *
255      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
256      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
257      * constructor.
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize/address.code.length, which returns 0
262         // for contracts in construction, since the code is only stored at the end
263         // of the constructor execution.
264 
265         return account.code.length > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @title ERC721 token receiver interface
457  * @dev Interface for any contract that wants to support safeTransfers
458  * from ERC721 asset contracts.
459  */
460 interface IERC721Receiver {
461     /**
462      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
463      * by `operator` from `from`, this function is called.
464      *
465      * It must return its Solidity selector to confirm the token transfer.
466      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
467      *
468      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
469      */
470     function onERC721Received(
471         address operator,
472         address from,
473         uint256 tokenId,
474         bytes calldata data
475     ) external returns (bytes4);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev Interface of the ERC165 standard, as defined in the
487  * https://eips.ethereum.org/EIPS/eip-165[EIP].
488  *
489  * Implementers can declare support of contract interfaces, which can then be
490  * queried by others ({ERC165Checker}).
491  *
492  * For an implementation, see {ERC165}.
493  */
494 interface IERC165 {
495     /**
496      * @dev Returns true if this contract implements the interface defined by
497      * `interfaceId`. See the corresponding
498      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
499      * to learn more about how these ids are created.
500      *
501      * This function call must use less than 30 000 gas.
502      */
503     function supportsInterface(bytes4 interfaceId) external view returns (bool);
504 }
505 
506 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @dev Implementation of the {IERC165} interface.
516  *
517  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
518  * for the additional interface id that will be supported. For example:
519  *
520  * ```solidity
521  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
523  * }
524  * ```
525  *
526  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
527  */
528 abstract contract ERC165 is IERC165 {
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         return interfaceId == type(IERC165).interfaceId;
534     }
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Required interface of an ERC721 compliant contract.
547  */
548 interface IERC721 is IERC165 {
549     /**
550      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
551      */
552     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
556      */
557     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
561      */
562     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
563 
564     /**
565      * @dev Returns the number of tokens in ``owner``'s account.
566      */
567     function balanceOf(address owner) external view returns (uint256 balance);
568 
569     /**
570      * @dev Returns the owner of the `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function ownerOf(uint256 tokenId) external view returns (address owner);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
580      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must exist and be owned by `from`.
587      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Transfers `tokenId` token from `from` to `to`.
600      *
601      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must be owned by `from`.
608      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
620      * The approval is cleared when the token is transferred.
621      *
622      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
623      *
624      * Requirements:
625      *
626      * - The caller must own the token or be an approved operator.
627      * - `tokenId` must exist.
628      *
629      * Emits an {Approval} event.
630      */
631     function approve(address to, uint256 tokenId) external;
632 
633     /**
634      * @dev Returns the account approved for `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function getApproved(uint256 tokenId) external view returns (address operator);
641 
642     /**
643      * @dev Approve or remove `operator` as an operator for the caller.
644      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
645      *
646      * Requirements:
647      *
648      * - The `operator` cannot be the caller.
649      *
650      * Emits an {ApprovalForAll} event.
651      */
652     function setApprovalForAll(address operator, bool _approved) external;
653 
654     /**
655      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
656      *
657      * See {setApprovalForAll}
658      */
659     function isApprovedForAll(address owner, address operator) external view returns (bool);
660 
661     /**
662      * @dev Safely transfers `tokenId` token from `from` to `to`.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must exist and be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
671      *
672      * Emits a {Transfer} event.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId,
678         bytes calldata data
679     ) external;
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
683 
684 
685 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 interface IERC721Enumerable is IERC721 {
695     /**
696      * @dev Returns the total amount of tokens stored by the contract.
697      */
698     function totalSupply() external view returns (uint256);
699 
700     /**
701      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
702      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
703      */
704     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
705 
706     /**
707      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
708      * Use along with {totalSupply} to enumerate all tokens.
709      */
710     function tokenByIndex(uint256 index) external view returns (uint256);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 
751 
752 
753 
754 
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension, but not including the Enumerable extension, which is available separately as
759  * {ERC721Enumerable}.
760  */
761 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to owner address
772     mapping(uint256 => address) private _owners;
773 
774     // Mapping owner address to token count
775     mapping(address => uint256) private _balances;
776 
777     // Mapping from token ID to approved address
778     mapping(uint256 => address) private _tokenApprovals;
779 
780     // Mapping from owner to operator approvals
781     mapping(address => mapping(address => bool)) private _operatorApprovals;
782 
783     /**
784      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
785      */
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view virtual override returns (uint256) {
805         require(owner != address(0), "ERC721: balance query for the zero address");
806         return _balances[owner];
807     }
808 
809     /**
810      * @dev See {IERC721-ownerOf}.
811      */
812     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
813         address owner = _owners[tokenId];
814         require(owner != address(0), "ERC721: owner query for nonexistent token");
815         return owner;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public virtual override {
855         address owner = ERC721.ownerOf(tokenId);
856         require(to != owner, "ERC721: approval to current owner");
857 
858         require(
859             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
860             "ERC721: approve caller is not owner nor approved for all"
861         );
862 
863         _approve(to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId) public view virtual override returns (address) {
870         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
871 
872         return _tokenApprovals[tokenId];
873     }
874 
875     /**
876      * @dev See {IERC721-setApprovalForAll}.
877      */
878     function setApprovalForAll(address operator, bool approved) public virtual override {
879         _setApprovalForAll(_msgSender(), operator, approved);
880     }
881 
882     /**
883      * @dev See {IERC721-isApprovedForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev See {IERC721-transferFrom}.
891      */
892     function transferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         //solhint-disable-next-line max-line-length
898         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
899 
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, "");
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public virtual override {
923         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
924         _safeTransfer(from, to, tokenId, _data);
925     }
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
929      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
930      *
931      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
932      *
933      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
934      * implement alternative mechanisms to perform token transfer, such as signature-based.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeTransfer(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) internal virtual {
951         _transfer(from, to, tokenId);
952         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      * and stop existing when they are burned (`_burn`).
962      */
963     function _exists(uint256 tokenId) internal view virtual returns (bool) {
964         return _owners[tokenId] != address(0);
965     }
966 
967     /**
968      * @dev Returns whether `spender` is allowed to manage `tokenId`.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      */
974     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
975         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
976         address owner = ERC721.ownerOf(tokenId);
977         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
978     }
979 
980     /**
981      * @dev Safely mints `tokenId` and transfers it to `to`.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeMint(address to, uint256 tokenId) internal virtual {
991         _safeMint(to, tokenId, "");
992     }
993 
994     /**
995      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
996      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
997      */
998     function _safeMint(
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) internal virtual {
1003         _mint(to, tokenId);
1004         require(
1005             _checkOnERC721Received(address(0), to, tokenId, _data),
1006             "ERC721: transfer to non ERC721Receiver implementer"
1007         );
1008     }
1009 
1010     /**
1011      * @dev Mints `tokenId` and transfers it to `to`.
1012      *
1013      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must not exist.
1018      * - `to` cannot be the zero address.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _mint(address to, uint256 tokenId) internal virtual {
1023         require(to != address(0), "ERC721: mint to the zero address");
1024         require(!_exists(tokenId), "ERC721: token already minted");
1025 
1026         _beforeTokenTransfer(address(0), to, tokenId);
1027 
1028         _balances[to] += 1;
1029         _owners[tokenId] = to;
1030 
1031         emit Transfer(address(0), to, tokenId);
1032 
1033         _afterTokenTransfer(address(0), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Destroys `tokenId`.
1038      * The approval is cleared when the token is burned.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _burn(uint256 tokenId) internal virtual {
1047         address owner = ERC721.ownerOf(tokenId);
1048 
1049         _beforeTokenTransfer(owner, address(0), tokenId);
1050 
1051         // Clear approvals
1052         _approve(address(0), tokenId);
1053 
1054         _balances[owner] -= 1;
1055         delete _owners[tokenId];
1056 
1057         emit Transfer(owner, address(0), tokenId);
1058 
1059         _afterTokenTransfer(owner, address(0), tokenId);
1060     }
1061 
1062     /**
1063      * @dev Transfers `tokenId` from `from` to `to`.
1064      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must be owned by `from`.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) internal virtual {
1078         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1079         require(to != address(0), "ERC721: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(from, to, tokenId);
1082 
1083         // Clear approvals from the previous owner
1084         _approve(address(0), tokenId);
1085 
1086         _balances[from] -= 1;
1087         _balances[to] += 1;
1088         _owners[tokenId] = to;
1089 
1090         emit Transfer(from, to, tokenId);
1091 
1092         _afterTokenTransfer(from, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Approve `to` to operate on `tokenId`
1097      *
1098      * Emits a {Approval} event.
1099      */
1100     function _approve(address to, uint256 tokenId) internal virtual {
1101         _tokenApprovals[tokenId] = to;
1102         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Approve `operator` to operate on all of `owner` tokens
1107      *
1108      * Emits a {ApprovalForAll} event.
1109      */
1110     function _setApprovalForAll(
1111         address owner,
1112         address operator,
1113         bool approved
1114     ) internal virtual {
1115         require(owner != operator, "ERC721: approve to caller");
1116         _operatorApprovals[owner][operator] = approved;
1117         emit ApprovalForAll(owner, operator, approved);
1118     }
1119 
1120     /**
1121      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1122      * The call is not executed if the target address is not a contract.
1123      *
1124      * @param from address representing the previous owner of the given token ID
1125      * @param to target address that will receive the tokens
1126      * @param tokenId uint256 ID of the token to be transferred
1127      * @param _data bytes optional data to send along with the call
1128      * @return bool whether the call correctly returned the expected magic value
1129      */
1130     function _checkOnERC721Received(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) private returns (bool) {
1136         if (to.isContract()) {
1137             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1138                 return retval == IERC721Receiver.onERC721Received.selector;
1139             } catch (bytes memory reason) {
1140                 if (reason.length == 0) {
1141                     revert("ERC721: transfer to non ERC721Receiver implementer");
1142                 } else {
1143                     assembly {
1144                         revert(add(32, reason), mload(reason))
1145                     }
1146                 }
1147             }
1148         } else {
1149             return true;
1150         }
1151     }
1152 
1153     /**
1154      * @dev Hook that is called before any token transfer. This includes minting
1155      * and burning.
1156      *
1157      * Calling conditions:
1158      *
1159      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1160      * transferred to `to`.
1161      * - When `from` is zero, `tokenId` will be minted for `to`.
1162      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1163      * - `from` and `to` are never both zero.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _beforeTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual {}
1172 
1173     /**
1174      * @dev Hook that is called after any transfer of tokens. This includes
1175      * minting and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - when `from` and `to` are both non-zero.
1180      * - `from` and `to` are never both zero.
1181      *
1182      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1183      */
1184     function _afterTokenTransfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {}
1189 }
1190 
1191 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1192 
1193 
1194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 
1199 
1200 /**
1201  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1202  * enumerability of all the token ids in the contract as well as all token ids owned by each
1203  * account.
1204  */
1205 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1206     // Mapping from owner to list of owned token IDs
1207     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1208 
1209     // Mapping from token ID to index of the owner tokens list
1210     mapping(uint256 => uint256) private _ownedTokensIndex;
1211 
1212     // Array with all token ids, used for enumeration
1213     uint256[] private _allTokens;
1214 
1215     // Mapping from token id to position in the allTokens array
1216     mapping(uint256 => uint256) private _allTokensIndex;
1217 
1218     /**
1219      * @dev See {IERC165-supportsInterface}.
1220      */
1221     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1222         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1223     }
1224 
1225     /**
1226      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1227      */
1228     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1229         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1230         return _ownedTokens[owner][index];
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Enumerable-totalSupply}.
1235      */
1236     function totalSupply() public view virtual override returns (uint256) {
1237         return _allTokens.length;
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Enumerable-tokenByIndex}.
1242      */
1243     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1244         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1245         return _allTokens[index];
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before any token transfer. This includes minting
1250      * and burning.
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` will be minted for `to`.
1257      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1258      * - `from` cannot be the zero address.
1259      * - `to` cannot be the zero address.
1260      *
1261      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1262      */
1263     function _beforeTokenTransfer(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) internal virtual override {
1268         super._beforeTokenTransfer(from, to, tokenId);
1269 
1270         if (from == address(0)) {
1271             _addTokenToAllTokensEnumeration(tokenId);
1272         } else if (from != to) {
1273             _removeTokenFromOwnerEnumeration(from, tokenId);
1274         }
1275         if (to == address(0)) {
1276             _removeTokenFromAllTokensEnumeration(tokenId);
1277         } else if (to != from) {
1278             _addTokenToOwnerEnumeration(to, tokenId);
1279         }
1280     }
1281 
1282     /**
1283      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1284      * @param to address representing the new owner of the given token ID
1285      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1286      */
1287     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1288         uint256 length = ERC721.balanceOf(to);
1289         _ownedTokens[to][length] = tokenId;
1290         _ownedTokensIndex[tokenId] = length;
1291     }
1292 
1293     /**
1294      * @dev Private function to add a token to this extension's token tracking data structures.
1295      * @param tokenId uint256 ID of the token to be added to the tokens list
1296      */
1297     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1298         _allTokensIndex[tokenId] = _allTokens.length;
1299         _allTokens.push(tokenId);
1300     }
1301 
1302     /**
1303      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1304      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1305      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1306      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1307      * @param from address representing the previous owner of the given token ID
1308      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1309      */
1310     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1311         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1312         // then delete the last slot (swap and pop).
1313 
1314         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1315         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1316 
1317         // When the token to delete is the last token, the swap operation is unnecessary
1318         if (tokenIndex != lastTokenIndex) {
1319             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1320 
1321             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1322             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1323         }
1324 
1325         // This also deletes the contents at the last position of the array
1326         delete _ownedTokensIndex[tokenId];
1327         delete _ownedTokens[from][lastTokenIndex];
1328     }
1329 
1330     /**
1331      * @dev Private function to remove a token from this extension's token tracking data structures.
1332      * This has O(1) time complexity, but alters the order of the _allTokens array.
1333      * @param tokenId uint256 ID of the token to be removed from the tokens list
1334      */
1335     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1336         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1337         // then delete the last slot (swap and pop).
1338 
1339         uint256 lastTokenIndex = _allTokens.length - 1;
1340         uint256 tokenIndex = _allTokensIndex[tokenId];
1341 
1342         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1343         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1344         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1345         uint256 lastTokenId = _allTokens[lastTokenIndex];
1346 
1347         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1348         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1349 
1350         // This also deletes the contents at the last position of the array
1351         delete _allTokensIndex[tokenId];
1352         _allTokens.pop();
1353     }
1354 }
1355 
1356 // File: contracts/FOREST.sol
1357 
1358 
1359 pragma solidity >=0.7.0 <0.9.0;
1360 
1361 
1362 
1363 
1364 
1365 contract FOREST is ERC721, Ownable {
1366   using Strings for uint256;
1367   using Counters for Counters.Counter;
1368 
1369   Counters.Counter private supply;
1370 
1371   string public uriPrefix = "";
1372   string public uriSuffix = ".json";
1373   string public hiddenMetadataUri;
1374   
1375   uint256 public cost = .0069 ether;
1376   uint256 public maxSupply = 330;
1377   uint256 public maxMintAmountPerTx = 3;
1378   uint256 public maxFreeMintPerWallet = 3;
1379 
1380   bool public paused = true;
1381   bool public revealed = false;
1382 
1383   mapping(address => uint256) public addressToFreeMinted;
1384 
1385 
1386   constructor() ERC721("FOREST", "FOREST") {
1387     setHiddenMetadataUri("ipfs://QmZ8Ze7QL1jSKGPNuTyJ8uheeuM8fNwrb2AYjFfwJ5wCdY");
1388   }
1389 
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
1490     // This will pay the co-founder 50% of the initial sale.
1491     // =============================================================================
1492     (bool hs, ) = payable(0x6c62b43d4d2533f4FA332be739bCF2Efd43266e9).call{value: address(this).balance * 50 / 100}("");
1493     require(hs);
1494     // =============================================================================
1495     // This will transfer the remaining contract balance to the owner.
1496     // Do not remove this otherwise you will not be able to withdraw the funds.
1497     // =============================================================================
1498     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1499     require(os);
1500     // =============================================================================
1501   }
1502 
1503   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1504     for (uint256 i = 0; i < _mintAmount; i++) {
1505       supply.increment();
1506       _safeMint(_receiver, supply.current());
1507     }
1508   }
1509 
1510   function _baseURI() internal view virtual override returns (string memory) {
1511     return uriPrefix;
1512   }
1513 }