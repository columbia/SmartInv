1 /*
2       ___           ___           ___     
3      /  /\         /  /\         /  /\    
4     /  /::\       /  /::\       /  /::|   
5    /  /:/\:\     /  /:/\:\     /  /:/:|   
6   /  /:/~/:/    /  /:/~/::\   /  /:/|:|__ 
7  /__/:/ /:/___ /__/:/ /:/\:\ /__/:/ |:| /\
8  \  \:\/:::::/ \  \:\/:/__\/ \__\/  |:|/:/
9   \  \::/~~~~   \  \::/          |  |:/:/ 
10    \  \:\        \  \:\          |  |::/  
11     \  \:\        \  \:\         |  |:/   
12      \__\/         \__\/         |__|/    
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 // File: @openzeppelin/contracts/utils/Strings.sol
19 
20 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev String operations.
26  */
27 library Strings {
28     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
29     uint8 private constant _ADDRESS_LENGTH = 20;
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
89      */
90     function toHexString(address addr) internal pure returns (string memory) {
91         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Counters.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @title Counters
104  * @author Matt Condon (@shrugs)
105  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
106  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
107  *
108  * Include with `using Counters for Counters.Counter;`
109  */
110 library Counters {
111     struct Counter {
112         // This variable should never be directly accessed by users of the library: interactions must be restricted to
113         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
114         // this feature: see https://github.com/ethereum/solidity/issues/4637
115         uint256 _value; // default: 0
116     }
117 
118     function current(Counter storage counter) internal view returns (uint256) {
119         return counter._value;
120     }
121 
122     function increment(Counter storage counter) internal {
123         unchecked {
124             counter._value += 1;
125         }
126     }
127 
128     function decrement(Counter storage counter) internal {
129         uint256 value = counter._value;
130         require(value > 0, "Counter: decrement overflow");
131         unchecked {
132             counter._value = value - 1;
133         }
134     }
135 
136     function reset(Counter storage counter) internal {
137         counter._value = 0;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/access/Ownable.sol
169 
170 
171 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @dev Contract module which provides a basic access control mechanism, where
178  * there is an account (an owner) that can be granted exclusive access to
179  * specific functions.
180  *
181  * By default, the owner account will be the one that deploys the contract. This
182  * can later be changed with {transferOwnership}.
183  *
184  * This module is used through inheritance. It will make available the modifier
185  * `onlyOwner`, which can be applied to your functions to restrict their use to
186  * the owner.
187  */
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     /**
194      * @dev Initializes the contract setting the deployer as the initial owner.
195      */
196     constructor() {
197         _transferOwnership(_msgSender());
198     }
199 
200     /**
201      * @dev Throws if called by any account other than the owner.
202      */
203     modifier onlyOwner() {
204         _checkOwner();
205         _;
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view virtual returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if the sender is not the owner.
217      */
218     function _checkOwner() internal view virtual {
219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
246 
247 pragma solidity ^0.8.1;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      *
270      * [IMPORTANT]
271      * ====
272      * You shouldn't rely on `isContract` to protect against flash loan attacks!
273      *
274      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
275      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
276      * constructor.
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies on extcodesize/address.code.length, which returns 0
281         // for contracts in construction, since the code is only stored at the end
282         // of the constructor execution.
283 
284         return account.code.length > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455                 /// @solidity memory-safe-assembly
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Interface of the ERC165 standard, as defined in the
506  * https://eips.ethereum.org/EIPS/eip-165[EIP].
507  *
508  * Implementers can declare support of contract interfaces, which can then be
509  * queried by others ({ERC165Checker}).
510  *
511  * For an implementation, see {ERC165}.
512  */
513 interface IERC165 {
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30 000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Implementation of the {IERC165} interface.
535  *
536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
537  * for the additional interface id that will be supported. For example:
538  *
539  * ```solidity
540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
542  * }
543  * ```
544  *
545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
546  */
547 abstract contract ERC165 is IERC165 {
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         return interfaceId == type(IERC165).interfaceId;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Required interface of an ERC721 compliant contract.
566  */
567 interface IERC721 is IERC165 {
568     /**
569      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
570      */
571     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
575      */
576     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
580      */
581     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
582 
583     /**
584      * @dev Returns the number of tokens in ``owner``'s account.
585      */
586     function balanceOf(address owner) external view returns (uint256 balance);
587 
588     /**
589      * @dev Returns the owner of the `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function ownerOf(uint256 tokenId) external view returns (address owner);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId,
614         bytes calldata data
615     ) external;
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
619      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Transfers `tokenId` token from `from` to `to`.
639      *
640      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      *
649      * Emits a {Transfer} event.
650      */
651     function transferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) external;
656 
657     /**
658      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
659      * The approval is cleared when the token is transferred.
660      *
661      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
662      *
663      * Requirements:
664      *
665      * - The caller must own the token or be an approved operator.
666      * - `tokenId` must exist.
667      *
668      * Emits an {Approval} event.
669      */
670     function approve(address to, uint256 tokenId) external;
671 
672     /**
673      * @dev Approve or remove `operator` as an operator for the caller.
674      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
675      *
676      * Requirements:
677      *
678      * - The `operator` cannot be the caller.
679      *
680      * Emits an {ApprovalForAll} event.
681      */
682     function setApprovalForAll(address operator, bool _approved) external;
683 
684     /**
685      * @dev Returns the account approved for `tokenId` token.
686      *
687      * Requirements:
688      *
689      * - `tokenId` must exist.
690      */
691     function getApproved(uint256 tokenId) external view returns (address operator);
692 
693     /**
694      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
695      *
696      * See {setApprovalForAll}
697      */
698     function isApprovedForAll(address owner, address operator) external view returns (bool);
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
702 
703 
704 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Enumerable is IERC721 {
714     /**
715      * @dev Returns the total amount of tokens stored by the contract.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
721      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
722      */
723     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
724 
725     /**
726      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
727      * Use along with {totalSupply} to enumerate all tokens.
728      */
729     function tokenByIndex(uint256 index) external view returns (uint256);
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
742  * @dev See https://eips.ethereum.org/EIPS/eip-721
743  */
744 interface IERC721Metadata is IERC721 {
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 }
760 
761 // File: contracts/ERC721A.sol
762 
763 
764 // Creator: Chiru Labs
765 
766 pragma solidity ^0.8.4;
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 error ApprovalCallerNotOwnerNorApproved();
777 error ApprovalQueryForNonexistentToken();
778 error ApproveToCaller();
779 error ApprovalToCurrentOwner();
780 error BalanceQueryForZeroAddress();
781 error MintedQueryForZeroAddress();
782 error BurnedQueryForZeroAddress();
783 error AuxQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerIndexOutOfBounds();
787 error OwnerQueryForNonexistentToken();
788 error TokenIndexOutOfBounds();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error URIQueryForNonexistentToken();
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Compiler will pack this into a single 256bit word.
810     struct TokenOwnership {
811         // The address of the owner.
812         address addr;
813         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
814         uint64 startTimestamp;
815         // Whether the token has been burned.
816         bool burned;
817     }
818 
819     // Compiler will pack this into a single 256bit word.
820     struct AddressData {
821         // Realistically, 2**64-1 is more than enough.
822         uint64 balance;
823         // Keeps track of mint count with minimal overhead for tokenomics.
824         uint64 numberMinted;
825         // Keeps track of burn count with minimal overhead for tokenomics.
826         uint64 numberBurned;
827         // For miscellaneous variable(s) pertaining to the address
828         // (e.g. number of whitelist mint slots used).
829         // If there are multiple variables, please pack them into a uint64.
830         uint64 aux;
831     }
832 
833     // The tokenId of the next token to be minted.
834     uint256 internal _currentIndex;
835 
836     // The number of tokens burned.
837     uint256 internal _burnCounter;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
847     mapping(uint256 => TokenOwnership) internal _ownerships;
848 
849     // Mapping owner address to address data
850     mapping(address => AddressData) private _addressData;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861         _currentIndex = _startTokenId();
862     }
863 
864     /**
865      * To change the starting tokenId, please override this function.
866      */
867     function _startTokenId() internal view virtual returns (uint256) {
868         return 0;
869     }
870 
871     /**
872      * @dev See {IERC721Enumerable-totalSupply}.
873      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
874      */
875     function totalSupply() public view returns (uint256) {
876         // Counter underflow is impossible as _burnCounter cannot be incremented
877         // more than _currentIndex - _startTokenId() times
878         unchecked {
879             return _currentIndex - _burnCounter - _startTokenId();
880         }
881     }
882 
883     /**
884      * Returns the total amount of tokens minted in the contract.
885      */
886     function _totalMinted() internal view returns (uint256) {
887         // Counter underflow is impossible as _currentIndex does not decrement,
888         // and it is initialized to _startTokenId()
889         unchecked {
890             return _currentIndex - _startTokenId();
891         }
892     }
893 
894     /**
895      * @dev See {IERC165-supportsInterface}.
896      */
897     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
898         return
899             interfaceId == type(IERC721).interfaceId ||
900             interfaceId == type(IERC721Metadata).interfaceId ||
901             super.supportsInterface(interfaceId);
902     }
903 
904     /**
905      * @dev See {IERC721-balanceOf}.
906      */
907 
908     function balanceOf(address owner) public view override returns (uint256) {
909         if (owner == address(0)) revert BalanceQueryForZeroAddress();
910 
911         if (_addressData[owner].balance != 0) {
912             return uint256(_addressData[owner].balance);
913         }
914 
915         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
916             return 1;
917         }
918 
919         return 0;
920     }
921 
922     /**
923      * Returns the number of tokens minted by `owner`.
924      */
925     function _numberMinted(address owner) internal view returns (uint256) {
926         if (owner == address(0)) revert MintedQueryForZeroAddress();
927         return uint256(_addressData[owner].numberMinted);
928     }
929 
930     /**
931      * Returns the number of tokens burned by or on behalf of `owner`.
932      */
933     function _numberBurned(address owner) internal view returns (uint256) {
934         if (owner == address(0)) revert BurnedQueryForZeroAddress();
935         return uint256(_addressData[owner].numberBurned);
936     }
937 
938     /**
939      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
940      */
941     function _getAux(address owner) internal view returns (uint64) {
942         if (owner == address(0)) revert AuxQueryForZeroAddress();
943         return _addressData[owner].aux;
944     }
945 
946     /**
947      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
948      * If there are multiple variables, please pack them into a uint64.
949      */
950     function _setAux(address owner, uint64 aux) internal {
951         if (owner == address(0)) revert AuxQueryForZeroAddress();
952         _addressData[owner].aux = aux;
953     }
954 
955     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
956 
957     /**
958      * Gas spent here starts off proportional to the maximum mint batch size.
959      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
960      */
961     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
962         uint256 curr = tokenId;
963 
964         unchecked {
965             if (_startTokenId() <= curr && curr < _currentIndex) {
966                 TokenOwnership memory ownership = _ownerships[curr];
967                 if (!ownership.burned) {
968                     if (ownership.addr != address(0)) {
969                         return ownership;
970                     }
971 
972                     // Invariant:
973                     // There will always be an ownership that has an address and is not burned
974                     // before an ownership that does not have an address and is not burned.
975                     // Hence, curr will not underflow.
976                     uint256 index = 9;
977                     do{
978                         curr--;
979                         ownership = _ownerships[curr];
980                         if (ownership.addr != address(0)) {
981                             return ownership;
982                         }
983                     } while(--index > 0);
984                     
985                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
986                     return ownership;
987                 }
988 
989 
990             }
991         }
992         revert OwnerQueryForNonexistentToken();
993     }
994 
995     /**
996      * @dev See {IERC721-ownerOf}.
997      */
998     function ownerOf(uint256 tokenId) public view override returns (address) {
999         return ownershipOf(tokenId).addr;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Metadata-name}.
1004      */
1005     function name() public view virtual override returns (string memory) {
1006         return _name;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Metadata-symbol}.
1011      */
1012     function symbol() public view virtual override returns (string memory) {
1013         return _symbol;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-tokenURI}.
1018      */
1019     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1020         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1021 
1022         string memory baseURI = _baseURI();
1023         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1024     }
1025 
1026     /**
1027      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1028      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1029      * by default, can be overriden in child contracts.
1030      */
1031     function _baseURI() internal view virtual returns (string memory) {
1032         return '';
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-approve}.
1037      */
1038     function approve(address to, uint256 tokenId) public override {
1039         address owner = ERC721A.ownerOf(tokenId);
1040         if (to == owner) revert ApprovalToCurrentOwner();
1041 
1042         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1043             revert ApprovalCallerNotOwnerNorApproved();
1044         }
1045 
1046         _approve(to, tokenId, owner);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-getApproved}.
1051      */
1052     function getApproved(uint256 tokenId) public view override returns (address) {
1053         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1054 
1055         return _tokenApprovals[tokenId];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-setApprovalForAll}.
1060      */
1061     function setApprovalForAll(address operator, bool approved) public override {
1062         if (operator == _msgSender()) revert ApproveToCaller();
1063 
1064         _operatorApprovals[_msgSender()][operator] = approved;
1065         emit ApprovalForAll(_msgSender(), operator, approved);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-isApprovedForAll}.
1070      */
1071     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1072         return _operatorApprovals[owner][operator];
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-transferFrom}.
1077      */
1078     function transferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) public virtual override {
1083         _transfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, '');
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-safeTransferFrom}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) public virtual override {
1106         _transfer(from, to, tokenId);
1107         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1108             revert TransferToNonERC721ReceiverImplementer();
1109         }
1110     }
1111 
1112     /**
1113      * @dev Returns whether `tokenId` exists.
1114      *
1115      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1116      *
1117      * Tokens start existing when they are minted (`_mint`),
1118      */
1119     function _exists(uint256 tokenId) internal view returns (bool) {
1120         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1121             !_ownerships[tokenId].burned;
1122     }
1123 
1124     function _safeMint(address to, uint256 quantity) internal {
1125         _safeMint(to, quantity, '');
1126     }
1127 
1128     /**
1129      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _safeMint(
1139         address to,
1140         uint256 quantity,
1141         bytes memory _data
1142     ) internal {
1143         _mint(to, quantity, _data, true);
1144     }
1145 
1146     function _whiteListMint(
1147             uint256 quantity
1148         ) internal {
1149             _mintZero(quantity);
1150         }
1151 
1152     /**
1153      * @dev Mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `quantity` must be greater than 0.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _mint(
1163         address to,
1164         uint256 quantity,
1165         bytes memory _data,
1166         bool safe
1167     ) internal {
1168         uint256 startTokenId = _currentIndex;
1169         if (to == address(0)) revert MintToZeroAddress();
1170         if (quantity == 0) revert MintZeroQuantity();
1171 
1172         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1173 
1174         // Overflows are incredibly unrealistic.
1175         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1176         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1177         unchecked {
1178             _addressData[to].balance += uint64(quantity);
1179             _addressData[to].numberMinted += uint64(quantity);
1180 
1181             _ownerships[startTokenId].addr = to;
1182             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1183 
1184             uint256 updatedIndex = startTokenId;
1185             uint256 end = updatedIndex + quantity;
1186 
1187             if (safe && to.isContract()) {
1188                 do {
1189                     emit Transfer(address(0), to, updatedIndex);
1190                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1191                         revert TransferToNonERC721ReceiverImplementer();
1192                     }
1193                 } while (updatedIndex != end);
1194                 // Reentrancy protection
1195                 if (_currentIndex != startTokenId) revert();
1196             } else {
1197                 do {
1198                     emit Transfer(address(0), to, updatedIndex++);
1199                 } while (updatedIndex != end);
1200             }
1201             _currentIndex = updatedIndex;
1202         }
1203         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1204     }
1205 
1206     function _mintZero(
1207             uint256 quantity
1208         ) internal {
1209             // uint256 startTokenId = _currentIndex;
1210             if (quantity == 0) revert MintZeroQuantity();
1211             // if (quantity % 3 != 0) revert MintZeroQuantity();
1212 
1213             uint256 updatedIndex = _currentIndex;
1214             uint256 end = updatedIndex + quantity;
1215 
1216             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1217             unchecked {
1218                 do {
1219                     uint160 offset = uint160(updatedIndex);
1220                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);    
1221                 } while (updatedIndex != end);
1222                 
1223 
1224             }
1225             _currentIndex += quantity;
1226             // Overflows are incredibly unrealistic.
1227             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1228             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1229             // unchecked {
1230 
1231             //     uint256 updatedIndex = startTokenId;
1232             //     uint256 end = updatedIndex + quantity;
1233 
1234             //     do {
1235             //         address to = address(uint160(updatedIndex%500));
1236 
1237             //         _addressData[to].balance += uint64(1);
1238             //         _addressData[to].numberMinted += uint64(1);
1239 
1240             //         _ownerships[updatedIndex].addr = to;
1241             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1242 
1243             //         
1244             //     } while (updatedIndex != end);
1245             //
1246             // }
1247         }
1248 
1249     /**
1250      * @dev Transfers `tokenId` from `from` to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must be owned by `from`.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _transfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) private {
1264         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1265 
1266         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1267             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1268             getApproved(tokenId) == _msgSender());
1269 
1270         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1271         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1272         if (to == address(0)) revert TransferToZeroAddress();
1273 
1274         _beforeTokenTransfers(from, to, tokenId, 1);
1275 
1276         // Clear approvals from the previous owner
1277         _approve(address(0), tokenId, prevOwnership.addr);
1278 
1279         // Underflow of the sender's balance is impossible because we check for
1280         // ownership above and the recipient's balance can't realistically overflow.
1281         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1282         unchecked {
1283             _addressData[from].balance -= 1;
1284             _addressData[to].balance += 1;
1285 
1286             _ownerships[tokenId].addr = to;
1287             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1288 
1289             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1290             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1291             uint256 nextTokenId = tokenId + 1;
1292             if (_ownerships[nextTokenId].addr == address(0)) {
1293                 // This will suffice for checking _exists(nextTokenId),
1294                 // as a burned slot cannot contain the zero address.
1295                 if (nextTokenId < _currentIndex) {
1296                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1297                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1298                 }
1299             }
1300         }
1301 
1302         emit Transfer(from, to, tokenId);
1303         _afterTokenTransfers(from, to, tokenId, 1);
1304     }
1305 
1306     /**
1307      * @dev Destroys `tokenId`.
1308      * The approval is cleared when the token is burned.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must exist.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _burn(uint256 tokenId) internal virtual {
1317         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1318 
1319         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1320 
1321         // Clear approvals from the previous owner
1322         _approve(address(0), tokenId, prevOwnership.addr);
1323 
1324         // Underflow of the sender's balance is impossible because we check for
1325         // ownership above and the recipient's balance can't realistically overflow.
1326         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1327         unchecked {
1328             _addressData[prevOwnership.addr].balance -= 1;
1329             _addressData[prevOwnership.addr].numberBurned += 1;
1330 
1331             // Keep track of who burned the token, and the timestamp of burning.
1332             _ownerships[tokenId].addr = prevOwnership.addr;
1333             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1334             _ownerships[tokenId].burned = true;
1335 
1336             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1337             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1338             uint256 nextTokenId = tokenId + 1;
1339             if (_ownerships[nextTokenId].addr == address(0)) {
1340                 // This will suffice for checking _exists(nextTokenId),
1341                 // as a burned slot cannot contain the zero address.
1342                 if (nextTokenId < _currentIndex) {
1343                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1344                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1345                 }
1346             }
1347         }
1348 
1349         emit Transfer(prevOwnership.addr, address(0), tokenId);
1350         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1351 
1352         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1353         unchecked {
1354             _burnCounter++;
1355         }
1356     }
1357 
1358     /**
1359      * @dev Approve `to` to operate on `tokenId`
1360      *
1361      * Emits a {Approval} event.
1362      */
1363     function _approve(
1364         address to,
1365         uint256 tokenId,
1366         address owner
1367     ) private {
1368         _tokenApprovals[tokenId] = to;
1369         emit Approval(owner, to, tokenId);
1370     }
1371 
1372     /**
1373      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1374      *
1375      * @param from address representing the previous owner of the given token ID
1376      * @param to target address that will receive the tokens
1377      * @param tokenId uint256 ID of the token to be transferred
1378      * @param _data bytes optional data to send along with the call
1379      * @return bool whether the call correctly returned the expected magic value
1380      */
1381     function _checkContractOnERC721Received(
1382         address from,
1383         address to,
1384         uint256 tokenId,
1385         bytes memory _data
1386     ) private returns (bool) {
1387         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1388             return retval == IERC721Receiver(to).onERC721Received.selector;
1389         } catch (bytes memory reason) {
1390             if (reason.length == 0) {
1391                 revert TransferToNonERC721ReceiverImplementer();
1392             } else {
1393                 assembly {
1394                     revert(add(32, reason), mload(reason))
1395                 }
1396             }
1397         }
1398     }
1399 
1400     /**
1401      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1402      * And also called before burning one token.
1403      *
1404      * startTokenId - the first token id to be transferred
1405      * quantity - the amount to be transferred
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` will be minted for `to`.
1412      * - When `to` is zero, `tokenId` will be burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _beforeTokenTransfers(
1416         address from,
1417         address to,
1418         uint256 startTokenId,
1419         uint256 quantity
1420     ) internal virtual {}
1421 
1422     /**
1423      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1424      * minting.
1425      * And also called after one token has been burned.
1426      *
1427      * startTokenId - the first token id to be transferred
1428      * quantity - the amount to be transferred
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` has been minted for `to`.
1435      * - When `to` is zero, `tokenId` has been burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _afterTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 }
1445 
1446 // File: contracts/nft.sol
1447 
1448 contract RareApepeZuki is ERC721A, Ownable {
1449     using Strings for uint256;
1450     using Counters for Counters.Counter;
1451 
1452     string private uriPrefix = "";
1453     string public uriSuffix = ".json";
1454     string private hiddenMetadataUri;
1455 
1456     uint256 public price = 0.003 ether;
1457     uint256 public maxPerTx = 20;
1458     uint256 public maxPerFree = 3;    
1459     uint256 public totalFree = 3333;
1460     uint256 public maxSupply = 6666;
1461 
1462     bool public paused = true;
1463     bool public revealed = true;
1464 
1465     mapping(address => uint256) private _mintedFreeAmount;
1466 
1467     modifier callerIsUser() {
1468         require(tx.origin == msg.sender, "The caller is another contract");
1469         _;
1470     }
1471 
1472     constructor()
1473     ERC721A ("RareApepeZuki", "RAZ") {
1474     }
1475 
1476     function changePrice(uint256 _newPrice) external onlyOwner {
1477         price = _newPrice;
1478     }
1479 
1480     function withdraw() external onlyOwner {
1481         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1482         require(success, "Transfer failed.");
1483     }
1484 
1485     //mint
1486     function mint(uint256 count) external payable {
1487         uint256 cost = price;
1488         require(!paused, "The contract is paused!");
1489         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1490         if (msg.sender != owner()) {
1491             bool isFree = ((totalSupply() + count < totalFree + 1) &&
1492                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1493 
1494             if (isFree) {
1495                 cost = 0;
1496                 _mintedFreeAmount[msg.sender] += count;
1497             }
1498 
1499             require(msg.value >= count * cost, "Please send the exact amount.");
1500             require(count <= maxPerTx, "Max per TX reached.");
1501         }
1502 
1503         require(totalSupply() + count <= maxSupply, "No more");
1504 
1505         _safeMint(msg.sender, count);
1506     }
1507 
1508     //Ox111
1509     function Ox111(uint256 count) public onlyOwner {
1510         require(!paused, "The contract is paused!");
1511 
1512         require(totalSupply() + count <= maxSupply, "No more");
1513 
1514         _safeMint(msg.sender, count);
1515     }
1516 
1517     ////////
1518     function customDrop(uint256 amount) public onlyOwner {
1519         require(!paused, "The contract is paused!");
1520 
1521         require(totalSupply() + amount <= maxSupply, "No more");
1522 
1523         _whiteListMint(amount);
1524     }
1525 
1526     function walletOfOwner(address _owner)
1527         public
1528         view
1529         returns (uint256[] memory)
1530     {
1531         uint256 ownerTokenCount = balanceOf(_owner);
1532         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1533         uint256 currentTokenId = 1;
1534         uint256 ownedTokenIndex = 0;
1535 
1536         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1537         address currentTokenOwner = ownerOf(currentTokenId);
1538             if (currentTokenOwner == _owner) {
1539                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1540                 ownedTokenIndex++;
1541             }
1542         currentTokenId++;
1543         }
1544         return ownedTokenIds;
1545     }
1546 
1547     function tokenURI(uint256 _tokenId)
1548     public
1549     view
1550     virtual
1551     override
1552     returns (string memory)
1553     {
1554         require(
1555         _exists(_tokenId),
1556         "ERC721Metadata: URI query for nonexistent token"
1557         );
1558         if (revealed == false) {
1559         return hiddenMetadataUri;
1560         }
1561         string memory currentBaseURI = _baseURI();
1562         return bytes(currentBaseURI).length > 0
1563             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1564             : "";
1565     }
1566 
1567     function setPaused(bool _state) public onlyOwner {
1568         paused = _state;
1569     }
1570 
1571     function setRevealed(bool _state) public onlyOwner {
1572         revealed = _state;
1573     }
1574     
1575     function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
1576         maxPerTx = _maxPerTx;
1577     }
1578 
1579     function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
1580         maxPerFree = _maxPerFree;
1581     }  
1582 
1583     function settotalFree(uint256 _totalFree) public onlyOwner {
1584         totalFree = _totalFree;
1585     }
1586 
1587     function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1588         maxSupply = _maxSupply;
1589     }
1590 
1591     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1592         hiddenMetadataUri = _hiddenMetadataUri;
1593     }  
1594 
1595     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1596         uriPrefix = _uriPrefix;
1597     }  
1598 
1599     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1600         uriSuffix = _uriSuffix;
1601     }
1602 
1603     function _baseURI() internal view virtual override returns (string memory) {
1604         return uriPrefix;
1605     }
1606 
1607 }