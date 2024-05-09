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
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * NOTE: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public virtual onlyOwner {
199         _transferOwnership(address(0));
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Internal function without access restriction.
214      */
215     function _transferOwnership(address newOwner) internal virtual {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Address.sol
223 
224 
225 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
226 
227 pragma solidity ^0.8.1;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      *
250      * [IMPORTANT]
251      * ====
252      * You shouldn't rely on `isContract` to protect against flash loan attacks!
253      *
254      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
255      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
256      * constructor.
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize/address.code.length, which returns 0
261         // for contracts in construction, since the code is only stored at the end
262         // of the constructor execution.
263 
264         return account.code.length > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
448 
449 
450 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @title ERC721 token receiver interface
456  * @dev Interface for any contract that wants to support safeTransfers
457  * from ERC721 asset contracts.
458  */
459 interface IERC721Receiver {
460     /**
461      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
462      * by `operator` from `from`, this function is called.
463      *
464      * It must return its Solidity selector to confirm the token transfer.
465      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
466      *
467      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
468      */
469     function onERC721Received(
470         address operator,
471         address from,
472         uint256 tokenId,
473         bytes calldata data
474     ) external returns (bytes4);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Interface of the ERC165 standard, as defined in the
486  * https://eips.ethereum.org/EIPS/eip-165[EIP].
487  *
488  * Implementers can declare support of contract interfaces, which can then be
489  * queried by others ({ERC165Checker}).
490  *
491  * For an implementation, see {ERC165}.
492  */
493 interface IERC165 {
494     /**
495      * @dev Returns true if this contract implements the interface defined by
496      * `interfaceId`. See the corresponding
497      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
498      * to learn more about how these ids are created.
499      *
500      * This function call must use less than 30 000 gas.
501      */
502     function supportsInterface(bytes4 interfaceId) external view returns (bool);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Implementation of the {IERC165} interface.
515  *
516  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
517  * for the additional interface id that will be supported. For example:
518  *
519  * ```solidity
520  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
522  * }
523  * ```
524  *
525  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
526  */
527 abstract contract ERC165 is IERC165 {
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532         return interfaceId == type(IERC165).interfaceId;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
537 
538 
539 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Required interface of an ERC721 compliant contract.
546  */
547 interface IERC721 is IERC165 {
548     /**
549      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
550      */
551     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
552 
553     /**
554      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
555      */
556     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
560      */
561     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
562 
563     /**
564      * @dev Returns the number of tokens in ``owner``'s account.
565      */
566     function balanceOf(address owner) external view returns (uint256 balance);
567 
568     /**
569      * @dev Returns the owner of the `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function ownerOf(uint256 tokenId) external view returns (address owner);
576 
577     /**
578      * @dev Safely transfers `tokenId` token from `from` to `to`.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId,
594         bytes calldata data
595     ) external;
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
599      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` token from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Approve or remove `operator` as an operator for the caller.
654      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
655      *
656      * Requirements:
657      *
658      * - The `operator` cannot be the caller.
659      *
660      * Emits an {ApprovalForAll} event.
661      */
662     function setApprovalForAll(address operator, bool _approved) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
682 
683 
684 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Enumerable is IERC721 {
694     /**
695      * @dev Returns the total amount of tokens stored by the contract.
696      */
697     function totalSupply() external view returns (uint256);
698 
699     /**
700      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
701      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
702      */
703     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
704 
705     /**
706      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
707      * Use along with {totalSupply} to enumerate all tokens.
708      */
709     function tokenByIndex(uint256 index) external view returns (uint256);
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
722  * @dev See https://eips.ethereum.org/EIPS/eip-721
723  */
724 interface IERC721Metadata is IERC721 {
725     /**
726      * @dev Returns the token collection name.
727      */
728     function name() external view returns (string memory);
729 
730     /**
731      * @dev Returns the token collection symbol.
732      */
733     function symbol() external view returns (string memory);
734 
735     /**
736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
737      */
738     function tokenURI(uint256 tokenId) external view returns (string memory);
739 }
740 
741 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
742 
743 
744 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 
749 
750 
751 
752 
753 
754 
755 /**
756  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
757  * the Metadata extension, but not including the Enumerable extension, which is available separately as
758  * {ERC721Enumerable}.
759  */
760 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
761     using Address for address;
762     using Strings for uint256;
763 
764     // Token name
765     string private _name;
766 
767     // Token symbol
768     string private _symbol;
769 
770     // Mapping from token ID to owner address
771     mapping(uint256 => address) private _owners;
772 
773     // Mapping owner address to token count
774     mapping(address => uint256) private _balances;
775 
776     // Mapping from token ID to approved address
777     mapping(uint256 => address) private _tokenApprovals;
778 
779     // Mapping from owner to operator approvals
780     mapping(address => mapping(address => bool)) private _operatorApprovals;
781 
782     /**
783      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
784      */
785     constructor(string memory name_, string memory symbol_) {
786         _name = name_;
787         _symbol = symbol_;
788     }
789 
790     /**
791      * @dev See {IERC165-supportsInterface}.
792      */
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799 
800     /**
801      * @dev See {IERC721-balanceOf}.
802      */
803     function balanceOf(address owner) public view virtual override returns (uint256) {
804         require(owner != address(0), "ERC721: balance query for the zero address");
805         return _balances[owner];
806     }
807 
808     /**
809      * @dev See {IERC721-ownerOf}.
810      */
811     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
812         address owner = _owners[tokenId];
813         require(owner != address(0), "ERC721: owner query for nonexistent token");
814         return owner;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-name}.
819      */
820     function name() public view virtual override returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-symbol}.
826      */
827     function symbol() public view virtual override returns (string memory) {
828         return _symbol;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-tokenURI}.
833      */
834     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
835         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
836 
837         string memory baseURI = _baseURI();
838         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
839     }
840 
841     /**
842      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
843      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
844      * by default, can be overridden in child contracts.
845      */
846     function _baseURI() internal view virtual returns (string memory) {
847         return "";
848     }
849 
850     /**
851      * @dev See {IERC721-approve}.
852      */
853     function approve(address to, uint256 tokenId) public virtual override {
854         address owner = ERC721.ownerOf(tokenId);
855         require(to != owner, "ERC721: approval to current owner");
856 
857         require(
858             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
859             "ERC721: approve caller is not owner nor approved for all"
860         );
861 
862         _approve(to, tokenId);
863     }
864 
865     /**
866      * @dev See {IERC721-getApproved}.
867      */
868     function getApproved(uint256 tokenId) public view virtual override returns (address) {
869         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
870 
871         return _tokenApprovals[tokenId];
872     }
873 
874     /**
875      * @dev See {IERC721-setApprovalForAll}.
876      */
877     function setApprovalForAll(address operator, bool approved) public virtual override {
878         _setApprovalForAll(_msgSender(), operator, approved);
879     }
880 
881     /**
882      * @dev See {IERC721-isApprovedForAll}.
883      */
884     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
885         return _operatorApprovals[owner][operator];
886     }
887 
888     /**
889      * @dev See {IERC721-transferFrom}.
890      */
891     function transferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public virtual override {
896         //solhint-disable-next-line max-line-length
897         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
898 
899         _transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         safeTransferFrom(from, to, tokenId, "");
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
923         _safeTransfer(from, to, tokenId, _data);
924     }
925 
926     /**
927      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
928      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
929      *
930      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
931      *
932      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
933      * implement alternative mechanisms to perform token transfer, such as signature-based.
934      *
935      * Requirements:
936      *
937      * - `from` cannot be the zero address.
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must exist and be owned by `from`.
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeTransfer(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) internal virtual {
950         _transfer(from, to, tokenId);
951         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      * and stop existing when they are burned (`_burn`).
961      */
962     function _exists(uint256 tokenId) internal view virtual returns (bool) {
963         return _owners[tokenId] != address(0);
964     }
965 
966     /**
967      * @dev Returns whether `spender` is allowed to manage `tokenId`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must exist.
972      */
973     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
974         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
975         address owner = ERC721.ownerOf(tokenId);
976         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
977     }
978 
979     /**
980      * @dev Safely mints `tokenId` and transfers it to `to`.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _safeMint(address to, uint256 tokenId) internal virtual {
990         _safeMint(to, tokenId, "");
991     }
992 
993     /**
994      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
995      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
996      */
997     function _safeMint(
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) internal virtual {
1002         _mint(to, tokenId);
1003         require(
1004             _checkOnERC721Received(address(0), to, tokenId, _data),
1005             "ERC721: transfer to non ERC721Receiver implementer"
1006         );
1007     }
1008 
1009     /**
1010      * @dev Mints `tokenId` and transfers it to `to`.
1011      *
1012      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must not exist.
1017      * - `to` cannot be the zero address.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _mint(address to, uint256 tokenId) internal virtual {
1022         require(to != address(0), "ERC721: mint to the zero address");
1023         require(!_exists(tokenId), "ERC721: token already minted");
1024 
1025         _beforeTokenTransfer(address(0), to, tokenId);
1026 
1027         _balances[to] += 1;
1028         _owners[tokenId] = to;
1029 
1030         emit Transfer(address(0), to, tokenId);
1031 
1032         _afterTokenTransfer(address(0), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Destroys `tokenId`.
1037      * The approval is cleared when the token is burned.
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must exist.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _burn(uint256 tokenId) internal virtual {
1046         address owner = ERC721.ownerOf(tokenId);
1047 
1048         _beforeTokenTransfer(owner, address(0), tokenId);
1049 
1050         // Clear approvals
1051         _approve(address(0), tokenId);
1052 
1053         _balances[owner] -= 1;
1054         delete _owners[tokenId];
1055 
1056         emit Transfer(owner, address(0), tokenId);
1057 
1058         _afterTokenTransfer(owner, address(0), tokenId);
1059     }
1060 
1061     /**
1062      * @dev Transfers `tokenId` from `from` to `to`.
1063      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must be owned by `from`.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) internal virtual {
1077         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1078         require(to != address(0), "ERC721: transfer to the zero address");
1079 
1080         _beforeTokenTransfer(from, to, tokenId);
1081 
1082         // Clear approvals from the previous owner
1083         _approve(address(0), tokenId);
1084 
1085         _balances[from] -= 1;
1086         _balances[to] += 1;
1087         _owners[tokenId] = to;
1088 
1089         emit Transfer(from, to, tokenId);
1090 
1091         _afterTokenTransfer(from, to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev Approve `to` to operate on `tokenId`
1096      *
1097      * Emits a {Approval} event.
1098      */
1099     function _approve(address to, uint256 tokenId) internal virtual {
1100         _tokenApprovals[tokenId] = to;
1101         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `operator` to operate on all of `owner` tokens
1106      *
1107      * Emits a {ApprovalForAll} event.
1108      */
1109     function _setApprovalForAll(
1110         address owner,
1111         address operator,
1112         bool approved
1113     ) internal virtual {
1114         require(owner != operator, "ERC721: approve to caller");
1115         _operatorApprovals[owner][operator] = approved;
1116         emit ApprovalForAll(owner, operator, approved);
1117     }
1118 
1119     /**
1120      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1121      * The call is not executed if the target address is not a contract.
1122      *
1123      * @param from address representing the previous owner of the given token ID
1124      * @param to target address that will receive the tokens
1125      * @param tokenId uint256 ID of the token to be transferred
1126      * @param _data bytes optional data to send along with the call
1127      * @return bool whether the call correctly returned the expected magic value
1128      */
1129     function _checkOnERC721Received(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) private returns (bool) {
1135         if (to.isContract()) {
1136             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1137                 return retval == IERC721Receiver.onERC721Received.selector;
1138             } catch (bytes memory reason) {
1139                 if (reason.length == 0) {
1140                     revert("ERC721: transfer to non ERC721Receiver implementer");
1141                 } else {
1142                     assembly {
1143                         revert(add(32, reason), mload(reason))
1144                     }
1145                 }
1146             }
1147         } else {
1148             return true;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _beforeTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 
1172     /**
1173      * @dev Hook that is called after any transfer of tokens. This includes
1174      * minting and burning.
1175      *
1176      * Calling conditions:
1177      *
1178      * - when `from` and `to` are both non-zero.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _afterTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {}
1188 }
1189 
1190 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1191 
1192 
1193 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 
1198 
1199 /**
1200  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1201  * enumerability of all the token ids in the contract as well as all token ids owned by each
1202  * account.
1203  */
1204 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1205     // Mapping from owner to list of owned token IDs
1206     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1207 
1208     // Mapping from token ID to index of the owner tokens list
1209     mapping(uint256 => uint256) private _ownedTokensIndex;
1210 
1211     // Array with all token ids, used for enumeration
1212     uint256[] private _allTokens;
1213 
1214     // Mapping from token id to position in the allTokens array
1215     mapping(uint256 => uint256) private _allTokensIndex;
1216 
1217     /**
1218      * @dev See {IERC165-supportsInterface}.
1219      */
1220     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1221         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1226      */
1227     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1228         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1229         return _ownedTokens[owner][index];
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Enumerable-totalSupply}.
1234      */
1235     function totalSupply() public view virtual override returns (uint256) {
1236         return _allTokens.length;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Enumerable-tokenByIndex}.
1241      */
1242     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1243         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1244         return _allTokens[index];
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before any token transfer. This includes minting
1249      * and burning.
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1257      * - `from` cannot be the zero address.
1258      * - `to` cannot be the zero address.
1259      *
1260      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1261      */
1262     function _beforeTokenTransfer(
1263         address from,
1264         address to,
1265         uint256 tokenId
1266     ) internal virtual override {
1267         super._beforeTokenTransfer(from, to, tokenId);
1268 
1269         if (from == address(0)) {
1270             _addTokenToAllTokensEnumeration(tokenId);
1271         } else if (from != to) {
1272             _removeTokenFromOwnerEnumeration(from, tokenId);
1273         }
1274         if (to == address(0)) {
1275             _removeTokenFromAllTokensEnumeration(tokenId);
1276         } else if (to != from) {
1277             _addTokenToOwnerEnumeration(to, tokenId);
1278         }
1279     }
1280 
1281     /**
1282      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1283      * @param to address representing the new owner of the given token ID
1284      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1285      */
1286     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1287         uint256 length = ERC721.balanceOf(to);
1288         _ownedTokens[to][length] = tokenId;
1289         _ownedTokensIndex[tokenId] = length;
1290     }
1291 
1292     /**
1293      * @dev Private function to add a token to this extension's token tracking data structures.
1294      * @param tokenId uint256 ID of the token to be added to the tokens list
1295      */
1296     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1297         _allTokensIndex[tokenId] = _allTokens.length;
1298         _allTokens.push(tokenId);
1299     }
1300 
1301     /**
1302      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1303      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1304      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1305      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1306      * @param from address representing the previous owner of the given token ID
1307      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1308      */
1309     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1310         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1311         // then delete the last slot (swap and pop).
1312 
1313         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1314         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1315 
1316         // When the token to delete is the last token, the swap operation is unnecessary
1317         if (tokenIndex != lastTokenIndex) {
1318             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1319 
1320             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1321             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1322         }
1323 
1324         // This also deletes the contents at the last position of the array
1325         delete _ownedTokensIndex[tokenId];
1326         delete _ownedTokens[from][lastTokenIndex];
1327     }
1328 
1329     /**
1330      * @dev Private function to remove a token from this extension's token tracking data structures.
1331      * This has O(1) time complexity, but alters the order of the _allTokens array.
1332      * @param tokenId uint256 ID of the token to be removed from the tokens list
1333      */
1334     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1335         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1336         // then delete the last slot (swap and pop).
1337 
1338         uint256 lastTokenIndex = _allTokens.length - 1;
1339         uint256 tokenIndex = _allTokensIndex[tokenId];
1340 
1341         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1342         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1343         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1344         uint256 lastTokenId = _allTokens[lastTokenIndex];
1345 
1346         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1347         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1348 
1349         // This also deletes the contents at the last position of the array
1350         delete _allTokensIndex[tokenId];
1351         _allTokens.pop();
1352     }
1353 }
1354 
1355 // File: contracts/CMZ.sol
1356 
1357 
1358 
1359 //Compiled By Annoymous
1360 
1361 
1362 pragma solidity >=0.7.0 <0.9.0;
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370   contract CryptoMidgetz is ERC721, Ownable {
1371   using Strings for uint256;
1372   using Counters for Counters.Counter;
1373 
1374   Counters.Counter private supply;
1375 
1376   string public baseURI;
1377   string public baseExtension = ".json";
1378   string public notRevealedUri;
1379   uint256 public preSaleCost = 0 ether;
1380   uint256 public cost = 0 ether;
1381   uint256 public maxSupply = 5000;
1382   uint256 public preSaleMaxSupply = 4500;
1383   uint256 public maxMintAmountPresale = 3;
1384   uint256 public maxMintAmount = 3;
1385   uint256 public nftPerAddressLimitPresale = 3;
1386   uint256 public nftPerAddressLimit = 3;
1387   uint256 public preSaleDate = 1654337160;
1388   uint256 public preSaleEndDate = 1654340760;
1389   uint256 public publicSaleDate = 1654344360;
1390   bool public paused = false;
1391   bool public revealed = false;
1392   bool public onlyWhitelisted = false;
1393   mapping(address => bool) whitelistedAddresses;
1394   mapping(address => uint256) public addressMintedBalance;
1395 
1396  address p1 = 0xA1EDe06c992796c9E6B53974785D90411a4B4580; // 
1397   
1398   constructor(
1399     string memory _initBaseURI,
1400     string memory _initNotRevealedUri
1401   ) ERC721("Crypto Midgetz", "CMZ") {
1402     setBaseURI(_initBaseURI);
1403     setNotRevealedURI(_initNotRevealedUri);
1404   }
1405 
1406   //MODIFIERS
1407   modifier notPaused {
1408     require(!paused, "the contract is paused");
1409     _;
1410   }
1411 
1412   modifier saleStarted {
1413     require(block.timestamp >= preSaleDate, "Sale has not started yet");
1414     _;
1415   }
1416 
1417   modifier minimumMintAmount(uint256 _mintAmount) {
1418     require(_mintAmount > 0, "need to mint at least 1 NFT");
1419     _;
1420   }
1421 
1422   // INTERNAL
1423   function _baseURI() internal view virtual override returns (string memory) {
1424     return baseURI;
1425   }
1426 
1427   function presaleValidations(
1428     uint256 ownerTokenCount,
1429     uint256 _mintAmount,
1430     uint256 _supply
1431   ) internal {
1432     uint256 actualCost;
1433     block.timestamp < preSaleEndDate
1434       ? actualCost = preSaleCost
1435       : actualCost = cost;
1436       if (onlyWhitelisted == true) {
1437     require(isWhitelisted(msg.sender), "user is not whitelisted");
1438     require(
1439       ownerTokenCount + _mintAmount <= nftPerAddressLimitPresale,
1440       "max NFT per address exceeded for presale"
1441     );
1442     require(msg.value >= actualCost * _mintAmount, "insufficient funds");
1443     require(
1444       _mintAmount <= maxMintAmountPresale,
1445       "max mint amount per transaction exceeded"
1446     );
1447     require(
1448       supply.current() + _mintAmount <= preSaleMaxSupply,
1449       "max NFT presale limit exceeded"
1450     );}
1451     else {
1452     require(
1453       ownerTokenCount + _mintAmount <= nftPerAddressLimitPresale,
1454       "max NFT per address exceeded for presale"
1455     );
1456     require(msg.value >= actualCost * _mintAmount, "insufficient funds");
1457     require(
1458       _mintAmount <= maxMintAmountPresale,
1459       "max mint amount per transaction exceeded"
1460     );
1461     require(
1462       supply.current() + _mintAmount <= preSaleMaxSupply,
1463       "max NFT presale limit exceeded"
1464     );
1465     }
1466   }
1467 
1468   function publicsaleValidations(uint256 ownerTokenCount, uint256 _mintAmount)
1469     internal
1470   {
1471     require(
1472       ownerTokenCount + _mintAmount <= nftPerAddressLimit,
1473       "max NFT per address exceeded"
1474     );
1475     require(msg.value >= cost * _mintAmount, "insufficient funds");
1476     require(
1477       _mintAmount <= maxMintAmount,
1478       "max mint amount per transaction exceeded"
1479     );
1480   }
1481 
1482   //MINT
1483   function mint(uint256 _mintAmount)
1484     public
1485     payable
1486     notPaused
1487     saleStarted
1488     minimumMintAmount(_mintAmount)
1489   {
1490     uint256 ownerTokenCount = addressMintedBalance[msg.sender];
1491 
1492     //Do some validations depending on which step of the sale we are in
1493     block.timestamp < publicSaleDate
1494       ? presaleValidations(ownerTokenCount, _mintAmount, supply.current())
1495       : publicsaleValidations(ownerTokenCount, _mintAmount);
1496 
1497     require(supply.current() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1498 
1499      _mintLoop(msg.sender, _mintAmount);
1500   }
1501 
1502    function mintForOwner(uint256 _mintAmount) public onlyOwner {
1503     require(!paused);
1504     require(_mintAmount > 0);
1505     require(_mintAmount <= maxMintAmount);
1506     require(supply.current() + _mintAmount <= maxSupply);
1507 
1508     _mintLoop(msg.sender, _mintAmount);
1509   }
1510   
1511   	function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1512     for (uint256 i = 0; i < _mintAmount; i++) {
1513       supply.increment();
1514       _safeMint(_receiver, supply.current());
1515     }
1516   }
1517  
1518   
1519   function gift(uint256 _mintAmount, address destination) public onlyOwner {
1520     require(_mintAmount > 0, "need to mint at least 1 NFT");
1521     require(supply.current() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1522 
1523    _mintLoop(msg.sender, _mintAmount);
1524   }
1525 
1526   //PUBLIC VIEWS
1527   function isWhitelisted(address _user) public view returns (bool) {
1528     return whitelistedAddresses[_user];
1529   }
1530 
1531    function walletOfOwner(address _owner)
1532     public
1533     view
1534     returns (uint256[] memory)
1535   {
1536     uint256 ownerTokenCount = balanceOf(_owner);
1537     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1538     uint256 currentTokenId = 1;
1539     uint256 ownedTokenIndex = 0;
1540 
1541     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1542       address currentTokenOwner = ownerOf(currentTokenId);
1543 
1544       if (currentTokenOwner == _owner) {
1545         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1546 
1547         ownedTokenIndex++;
1548       }
1549 
1550       currentTokenId++;
1551     }
1552 
1553     return ownedTokenIds;
1554   }
1555 
1556   function tokenURI(uint256 tokenId)
1557     public
1558     view
1559     virtual
1560     override
1561     returns (string memory)
1562   {
1563     require(
1564       _exists(tokenId),
1565       "ERC721Metadata: URI query for nonexistent token"
1566     );
1567 
1568     if (!revealed) {
1569       return notRevealedUri;
1570     } else {
1571       string memory currentBaseURI = _baseURI();
1572       return
1573         bytes(currentBaseURI).length > 0
1574           ? string(
1575             abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
1576           )
1577           : "";
1578     }
1579   }
1580   
1581     function totalSupply() public view returns (uint256) {
1582     return supply.current();
1583   }
1584 
1585   function getCurrentCost() public view returns (uint256) {
1586     if (block.timestamp < preSaleEndDate) {
1587       return preSaleCost;
1588     } else {
1589       return cost;
1590     }
1591   }
1592 
1593   //ONLY OWNER VIEWS
1594   function getBaseURI() public view onlyOwner returns (string memory) {
1595     return baseURI;
1596   }
1597 
1598   function getContractBalance() public view onlyOwner returns (uint256) {
1599     return address(this).balance;
1600   }
1601 
1602   //ONLY OWNER SETTERS
1603   function reveal(bool _state) public onlyOwner {
1604     revealed = _state;
1605   }
1606 
1607   function pause(bool _state) public onlyOwner {
1608     paused = _state;
1609   }
1610 
1611   function setNftPerAddressLimitPreSale(uint256 _limit) public onlyOwner {
1612     nftPerAddressLimitPresale = _limit;
1613   }
1614 
1615   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1616     nftPerAddressLimit = _limit;
1617   }
1618 
1619   function setPresaleCost(uint256 _newCost) public onlyOwner {
1620     preSaleCost = _newCost;
1621   }
1622 
1623   function setCost(uint256 _newCost) public onlyOwner {
1624     cost = _newCost;
1625   }
1626 
1627   function setmaxMintAmountPreSale(uint256 _newmaxMintAmount) public onlyOwner {
1628     maxMintAmountPresale = _newmaxMintAmount;
1629   }
1630 
1631   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1632     maxMintAmount = _newmaxMintAmount;
1633   }
1634 
1635   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1636     baseURI = _newBaseURI;
1637   }
1638 
1639   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1640     baseExtension = _newBaseExtension;
1641   }
1642 
1643   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1644     notRevealedUri = _notRevealedURI;
1645   }
1646 
1647   function setPresaleMaxSupply(uint256 _newPresaleMaxSupply) public onlyOwner {
1648     preSaleMaxSupply = _newPresaleMaxSupply;
1649   }
1650 
1651   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1652     maxSupply = _maxSupply;
1653   }
1654 
1655   function setPreSaleDate(uint256 _preSaleDate) public onlyOwner {
1656     preSaleDate = _preSaleDate;
1657   }
1658 
1659   function setPreSaleEndDate(uint256 _preSaleEndDate) public onlyOwner {
1660     preSaleEndDate = _preSaleEndDate;
1661   }
1662 
1663   function setPublicSaleDate(uint256 _publicSaleDate) public onlyOwner {
1664     publicSaleDate = _publicSaleDate;
1665   }
1666 
1667     function setOnlyWhitelisted(bool _state) public onlyOwner {
1668     onlyWhitelisted = _state;
1669   }
1670 
1671   function whitelistUsers(address[] memory addresses) public onlyOwner {
1672     for (uint256 i = 0; i < addresses.length; i++) {
1673       whitelistedAddresses[addresses[i]] = true;
1674     }
1675   }
1676 
1677   function withdrawAll() public payable onlyOwner {
1678 
1679   uint256 _p1share = address(this).balance * 50 /100;
1680 
1681   uint256 _ownershare = address(this).balance * 50 /100;
1682 
1683 
1684         require(payable(p1).send(_p1share));
1685 
1686         require(payable(msg.sender).send(_ownershare));
1687   }
1688     
1689 }