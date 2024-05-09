1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  ________  ________  ________  ___       ___  ________   ________      
9 |\   ____\|\   __  \|\   __  \|\  \     |\  \|\   ___  \|\   ____\     
10 \ \  \___|\ \  \|\  \ \  \|\ /\ \  \    \ \  \ \  \\ \  \ \  \___|_    
11  \ \  \  __\ \  \\\  \ \   __  \ \  \    \ \  \ \  \\ \  \ \_____  \   
12   \ \  \|\  \ \  \\\  \ \  \|\  \ \  \____\ \  \ \  \\ \  \|____|\  \  
13    \ \_______\ \_______\ \_______\ \_______\ \__\ \__\\ \__\____\_\  \ 
14     \|_______|\|_______|\|_______|\|_______|\|__|\|__| \|__|\_________\
15                                                            \|_________|
16                                                         U N I V E R S E
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
681 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Metadata is IERC721 {
694     /**
695      * @dev Returns the token collection name.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() external view returns (string memory);
703 
704     /**
705      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
706      */
707     function tokenURI(uint256 tokenId) external view returns (string memory);
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
711 
712 
713 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 
719 
720 
721 
722 
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension, but not including the Enumerable extension, which is available separately as
727  * {ERC721Enumerable}.
728  */
729 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to owner address
740     mapping(uint256 => address) private _owners;
741 
742     // Mapping owner address to token count
743     mapping(address => uint256) private _balances;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     /**
752      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
753      */
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view virtual override returns (uint256) {
773         require(owner != address(0), "ERC721: balance query for the zero address");
774         return _balances[owner];
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
781         address owner = _owners[tokenId];
782         require(owner != address(0), "ERC721: owner query for nonexistent token");
783         return owner;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overridden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return "";
817     }
818 
819     /**
820      * @dev See {IERC721-approve}.
821      */
822     function approve(address to, uint256 tokenId) public virtual override {
823         address owner = ERC721.ownerOf(tokenId);
824         require(to != owner, "ERC721: approval to current owner");
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             "ERC721: approve caller is not owner nor approved for all"
829         );
830 
831         _approve(to, tokenId);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view virtual override returns (address) {
838         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public virtual override {
847         _setApprovalForAll(_msgSender(), operator, approved);
848     }
849 
850     /**
851      * @dev See {IERC721-isApprovedForAll}.
852      */
853     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
854         return _operatorApprovals[owner][operator];
855     }
856 
857     /**
858      * @dev See {IERC721-transferFrom}.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         //solhint-disable-next-line max-line-length
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
867 
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         safeTransferFrom(from, to, tokenId, "");
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) public virtual override {
891         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
892         _safeTransfer(from, to, tokenId, _data);
893     }
894 
895     /**
896      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
897      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
898      *
899      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
900      *
901      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
902      * implement alternative mechanisms to perform token transfer, such as signature-based.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeTransfer(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) internal virtual {
919         _transfer(from, to, tokenId);
920         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      * and stop existing when they are burned (`_burn`).
930      */
931     function _exists(uint256 tokenId) internal view virtual returns (bool) {
932         return _owners[tokenId] != address(0);
933     }
934 
935     /**
936      * @dev Returns whether `spender` is allowed to manage `tokenId`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
943         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
944         address owner = ERC721.ownerOf(tokenId);
945         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
946     }
947 
948     /**
949      * @dev Safely mints `tokenId` and transfers it to `to`.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(address to, uint256 tokenId) internal virtual {
959         _safeMint(to, tokenId, "");
960     }
961 
962     /**
963      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
964      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
965      */
966     function _safeMint(
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) internal virtual {
971         _mint(to, tokenId);
972         require(
973             _checkOnERC721Received(address(0), to, tokenId, _data),
974             "ERC721: transfer to non ERC721Receiver implementer"
975         );
976     }
977 
978     /**
979      * @dev Mints `tokenId` and transfers it to `to`.
980      *
981      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - `to` cannot be the zero address.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _mint(address to, uint256 tokenId) internal virtual {
991         require(to != address(0), "ERC721: mint to the zero address");
992         require(!_exists(tokenId), "ERC721: token already minted");
993 
994         _beforeTokenTransfer(address(0), to, tokenId);
995 
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(address(0), to, tokenId);
1000 
1001         _afterTokenTransfer(address(0), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId) internal virtual {
1015         address owner = ERC721.ownerOf(tokenId);
1016 
1017         _beforeTokenTransfer(owner, address(0), tokenId);
1018 
1019         // Clear approvals
1020         _approve(address(0), tokenId);
1021 
1022         _balances[owner] -= 1;
1023         delete _owners[tokenId];
1024 
1025         emit Transfer(owner, address(0), tokenId);
1026 
1027         _afterTokenTransfer(owner, address(0), tokenId);
1028     }
1029 
1030     /**
1031      * @dev Transfers `tokenId` from `from` to `to`.
1032      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _transfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual {
1046         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1047         require(to != address(0), "ERC721: transfer to the zero address");
1048 
1049         _beforeTokenTransfer(from, to, tokenId);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId);
1053 
1054         _balances[from] -= 1;
1055         _balances[to] += 1;
1056         _owners[tokenId] = to;
1057 
1058         emit Transfer(from, to, tokenId);
1059 
1060         _afterTokenTransfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Approve `to` to operate on `tokenId`
1065      *
1066      * Emits a {Approval} event.
1067      */
1068     function _approve(address to, uint256 tokenId) internal virtual {
1069         _tokenApprovals[tokenId] = to;
1070         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `operator` to operate on all of `owner` tokens
1075      *
1076      * Emits a {ApprovalForAll} event.
1077      */
1078     function _setApprovalForAll(
1079         address owner,
1080         address operator,
1081         bool approved
1082     ) internal virtual {
1083         require(owner != operator, "ERC721: approve to caller");
1084         _operatorApprovals[owner][operator] = approved;
1085         emit ApprovalForAll(owner, operator, approved);
1086     }
1087 
1088     /**
1089      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1090      * The call is not executed if the target address is not a contract.
1091      *
1092      * @param from address representing the previous owner of the given token ID
1093      * @param to target address that will receive the tokens
1094      * @param tokenId uint256 ID of the token to be transferred
1095      * @param _data bytes optional data to send along with the call
1096      * @return bool whether the call correctly returned the expected magic value
1097      */
1098     function _checkOnERC721Received(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) private returns (bool) {
1104         if (to.isContract()) {
1105             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1106                 return retval == IERC721Receiver.onERC721Received.selector;
1107             } catch (bytes memory reason) {
1108                 if (reason.length == 0) {
1109                     revert("ERC721: transfer to non ERC721Receiver implementer");
1110                 } else {
1111                     assembly {
1112                         revert(add(32, reason), mload(reason))
1113                     }
1114                 }
1115             }
1116         } else {
1117             return true;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before any token transfer. This includes minting
1123      * and burning.
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1131      * - `from` and `to` are never both zero.
1132      *
1133      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1134      */
1135     function _beforeTokenTransfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Hook that is called after any transfer of tokens. This includes
1143      * minting and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - when `from` and `to` are both non-zero.
1148      * - `from` and `to` are never both zero.
1149      *
1150      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1151      */
1152     function _afterTokenTransfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) internal virtual {}
1157 }
1158 
1159 // File: contracts/GoblinsUniverse.sol
1160 
1161 /**
1162  ________  ________  ________  ___       ___  ________   ________      
1163 |\   ____\|\   __  \|\   __  \|\  \     |\  \|\   ___  \|\   ____\     
1164 \ \  \___|\ \  \|\  \ \  \|\ /\ \  \    \ \  \ \  \\ \  \ \  \___|_    
1165  \ \  \  __\ \  \\\  \ \   __  \ \  \    \ \  \ \  \\ \  \ \_____  \   
1166   \ \  \|\  \ \  \\\  \ \  \|\  \ \  \____\ \  \ \  \\ \  \|____|\  \  
1167    \ \_______\ \_______\ \_______\ \_______\ \__\ \__\\ \__\____\_\  \ 
1168     \|_______|\|_______|\|_______|\|_______|\|__|\|__| \|__|\_________\
1169                                                            \|_________|
1170                                                         U N I V E R S E
1171 */
1172 
1173 pragma solidity >=0.7.0 <0.9.0;
1174 
1175 contract GoblinsUniverse is ERC721, Ownable {
1176   using Strings for uint256;
1177   using Counters for Counters.Counter;
1178 
1179   Counters.Counter private supply;
1180 
1181   string public uriPrefix = "";
1182   string public uriSuffix = ".json";
1183   string public hiddenMetadataUri;
1184   
1185   uint256 public cost = 0 ether;
1186   uint256 public finalMaxSupply = 10000;
1187   uint256 public currentMaxSupply = 5000;
1188   uint256 public maxMintAmountPerTx = 500;
1189 
1190   bool public paused = true;
1191   bool public revealed = false;
1192 
1193   constructor() ERC721("Goblins Universe", "GOBS") {
1194     setHiddenMetadataUri("ipfs://QmfF6XcYdDFuM7fHNF39XiXgyRs9K732PgMvfyYeMu4WDL/hidden.json");
1195   }
1196 
1197   modifier mintCompliance(uint256 _mintAmount) {
1198     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1199     require(supply.current() + _mintAmount <= currentMaxSupply, "Max supply exceeded!");
1200     _;
1201   }
1202 
1203   function totalSupply() public view returns (uint256) {
1204     return supply.current();
1205   }
1206 
1207   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1208     require(!paused, "The contract is paused!");
1209     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1210 
1211     _mintLoop(msg.sender, _mintAmount);
1212   }
1213   
1214   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1215     _mintLoop(_receiver, _mintAmount);
1216   }
1217 
1218   function walletOfOwner(address _owner)
1219     public
1220     view
1221     returns (uint256[] memory)
1222   {
1223     uint256 ownerTokenCount = balanceOf(_owner);
1224     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1225     uint256 currentTokenId = 1;
1226     uint256 ownedTokenIndex = 0;
1227 
1228     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= currentMaxSupply) {
1229       address currentTokenOwner = ownerOf(currentTokenId);
1230 
1231       if (currentTokenOwner == _owner) {
1232         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1233 
1234         ownedTokenIndex++;
1235       }
1236 
1237       currentTokenId++;
1238     }
1239 
1240     return ownedTokenIds;
1241   }
1242 
1243   function tokenURI(uint256 _tokenId)
1244     public
1245     view
1246     virtual
1247     override
1248     returns (string memory)
1249   {
1250     require(
1251       _exists(_tokenId),
1252       "ERC721Metadata: URI query for nonexistent token"
1253     );
1254 
1255     if (revealed == false) {
1256       return hiddenMetadataUri;
1257     }
1258 
1259     string memory currentBaseURI = _baseURI();
1260     return bytes(currentBaseURI).length > 0
1261         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1262         : "";
1263   }
1264 
1265   function setCurrentMaxSupply(uint256 _supply) public onlyOwner {
1266     require(_supply <= finalMaxSupply && _supply >= totalSupply());
1267     currentMaxSupply = _supply;
1268   }
1269 
1270   function resetFinalMaxSupply() public onlyOwner {
1271       finalMaxSupply = currentMaxSupply;
1272   }
1273 
1274   function setRevealed(bool _state) public onlyOwner {
1275     revealed = _state;
1276   }
1277 
1278   function setCost(uint256 _cost) public onlyOwner {
1279     cost = _cost;
1280   }
1281 
1282   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1283     maxMintAmountPerTx = _maxMintAmountPerTx;
1284   }
1285 
1286   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1287     hiddenMetadataUri = _hiddenMetadataUri;
1288   }
1289 
1290   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1291     uriPrefix = _uriPrefix;
1292   }
1293 
1294   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1295     uriSuffix = _uriSuffix;
1296   }
1297 
1298   function setPaused(bool _state) public onlyOwner {
1299     paused = _state;
1300   }
1301 
1302   function withdraw() public onlyOwner {
1303     // Transfer contract balance to owner of wallet.
1304     // Do not remove this otherwise you will not be able to withdraw the funds.
1305     // =============================================================================
1306     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1307     require(os);
1308     // =============================================================================
1309   }
1310 
1311   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1312     for (uint256 i = 0; i < _mintAmount; i++) {
1313       supply.increment();
1314       _safeMint(_receiver, supply.current());
1315     }
1316   }
1317 
1318   function _baseURI() internal view virtual override returns (string memory) {
1319     return uriPrefix;
1320   }
1321 }