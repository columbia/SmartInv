1 // SPDX-License-Identifier: MIT
2 
3 /// 
4 ///     _ ,  ___     _ _    _ ,          ___        
5 ///   ,- -  -   -_, - - /  - -    -_-/  -   ---___- 
6 ///  _||_  (  ~/||    ('||  ||   (_ /      (' ||    
7 /// ' ||   (  / ||   (( ||--||  (_ --_    ((  ||    
8 ///   ||    \/==||   (( ||--||    --_ )  ((   ||    
9 ///   |,    /_ _||   (( /   ||   _/  ))   (( //     
10 /// _-/    (  - \\,    -___-\\, (_-_-       -____-  
11 ///                                                 
12 ///   A SINFUL JOURNEY.                                                
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @title Counters
21  * @author Matt Condon (@shrugs)
22  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
23  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
24  *
25  * Include with `using Counters for Counters.Counter;`
26  */
27 library Counters {
28     struct Counter {
29         // This variable should never be directly accessed by users of the library: interactions must be restricted to
30         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
31         // this feature: see https://github.com/ethereum/solidity/issues/4637
32         uint256 _value; // default: 0
33     }
34 
35     function current(Counter storage counter) internal view returns (uint256) {
36         return counter._value;
37     }
38 
39     function increment(Counter storage counter) internal {
40         unchecked {
41             counter._value += 1;
42         }
43     }
44 
45     function decrement(Counter storage counter) internal {
46         uint256 value = counter._value;
47         require(value > 0, "Counter: decrement overflow");
48         unchecked {
49             counter._value = value - 1;
50         }
51     }
52 
53     function reset(Counter storage counter) internal {
54         counter._value = 0;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/utils/Strings.sol
59 
60 
61 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev String operations.
67  */
68 library Strings {
69     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
70     uint8 private constant _ADDRESS_LENGTH = 20;
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
74      */
75     function toString(uint256 value) internal pure returns (string memory) {
76         // Inspired by OraclizeAPI's implementation - MIT licence
77         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
78 
79         if (value == 0) {
80             return "0";
81         }
82         uint256 temp = value;
83         uint256 digits;
84         while (temp != 0) {
85             digits++;
86             temp /= 10;
87         }
88         bytes memory buffer = new bytes(digits);
89         while (value != 0) {
90             digits -= 1;
91             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
92             value /= 10;
93         }
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
99      */
100     function toHexString(uint256 value) internal pure returns (string memory) {
101         if (value == 0) {
102             return "0x00";
103         }
104         uint256 temp = value;
105         uint256 length = 0;
106         while (temp != 0) {
107             length++;
108             temp >>= 8;
109         }
110         return toHexString(value, length);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
115      */
116     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
117         bytes memory buffer = new bytes(2 * length + 2);
118         buffer[0] = "0";
119         buffer[1] = "x";
120         for (uint256 i = 2 * length + 1; i > 1; --i) {
121             buffer[i] = _HEX_SYMBOLS[value & 0xf];
122             value >>= 4;
123         }
124         require(value == 0, "Strings: hex length insufficient");
125         return string(buffer);
126     }
127 
128     /**
129      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
130      */
131     function toHexString(address addr) internal pure returns (string memory) {
132         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Provides information about the current execution context, including the
145  * sender of the transaction and its data. While these are generally available
146  * via msg.sender and msg.data, they should not be accessed in such a direct
147  * manner, since when dealing with meta-transactions the account sending and
148  * paying for execution may not be the actual sender (as far as an application
149  * is concerned).
150  *
151  * This contract is only required for intermediate, library-like contracts.
152  */
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes calldata) {
159         return msg.data;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/access/Ownable.sol
164 
165 
166 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 
171 /**
172  * @dev Contract module which provides a basic access control mechanism, where
173  * there is an account (an owner) that can be granted exclusive access to
174  * specific functions.
175  *
176  * By default, the owner account will be the one that deploys the contract. This
177  * can later be changed with {transferOwnership}.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         _transferOwnership(_msgSender());
193     }
194 
195     /**
196      * @dev Throws if called by any account other than the owner.
197      */
198     modifier onlyOwner() {
199         _checkOwner();
200         _;
201     }
202 
203     /**
204      * @dev Returns the address of the current owner.
205      */
206     function owner() public view virtual returns (address) {
207         return _owner;
208     }
209 
210     /**
211      * @dev Throws if the sender is not the owner.
212      */
213     function _checkOwner() internal view virtual {
214         require(owner() == _msgSender(), "Ownable: caller is not the owner");
215     }
216 
217     /**
218      * @dev Leaves the contract without owner. It will not be possible to call
219      * `onlyOwner` functions anymore. Can only be called by the current owner.
220      *
221      * NOTE: Renouncing ownership will leave the contract without an owner,
222      * thereby removing any functionality that is only available to the owner.
223      */
224     function renounceOwnership() public virtual onlyOwner {
225         _transferOwnership(address(0));
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Can only be called by the current owner.
231      */
232     function transferOwnership(address newOwner) public virtual onlyOwner {
233         require(newOwner != address(0), "Ownable: new owner is the zero address");
234         _transferOwnership(newOwner);
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Internal function without access restriction.
240      */
241     function _transferOwnership(address newOwner) internal virtual {
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      *
276      * [IMPORTANT]
277      * ====
278      * You shouldn't rely on `isContract` to protect against flash loan attacks!
279      *
280      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
281      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
282      * constructor.
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize/address.code.length, which returns 0
287         // for contracts in construction, since the code is only stored at the end
288         // of the constructor execution.
289 
290         return account.code.length > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain `call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.call{value: value}(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(isContract(target), "Address: delegate call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
446      * revert reason using the provided one.
447      *
448      * _Available since v4.3._
449      */
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461                 /// @solidity memory-safe-assembly
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by `operator` from `from`, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
494      */
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Interface of the ERC165 standard, as defined in the
512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
513  *
514  * Implementers can declare support of contract interfaces, which can then be
515  * queried by others ({ERC165Checker}).
516  *
517  * For an implementation, see {ERC165}.
518  */
519 interface IERC165 {
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * `interfaceId`. See the corresponding
523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30 000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Implementation of the {IERC165} interface.
541  *
542  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
543  * for the additional interface id that will be supported. For example:
544  *
545  * ```solidity
546  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
548  * }
549  * ```
550  *
551  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
552  */
553 abstract contract ERC165 is IERC165 {
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         return interfaceId == type(IERC165).interfaceId;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Required interface of an ERC721 compliant contract.
572  */
573 interface IERC721 is IERC165 {
574     /**
575      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
576      */
577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
581      */
582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
583 
584     /**
585      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
586      */
587     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
588 
589     /**
590      * @dev Returns the number of tokens in ``owner``'s account.
591      */
592     function balanceOf(address owner) external view returns (uint256 balance);
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) external view returns (address owner);
602 
603     /**
604      * @dev Safely transfers `tokenId` token from `from` to `to`.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must exist and be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
613      *
614      * Emits a {Transfer} event.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId,
620         bytes calldata data
621     ) external;
622 
623     /**
624      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
625      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Transfers `tokenId` token from `from` to `to`.
645      *
646      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must be owned by `from`.
653      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
654      *
655      * Emits a {Transfer} event.
656      */
657     function transferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external;
662 
663     /**
664      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
665      * The approval is cleared when the token is transferred.
666      *
667      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
668      *
669      * Requirements:
670      *
671      * - The caller must own the token or be an approved operator.
672      * - `tokenId` must exist.
673      *
674      * Emits an {Approval} event.
675      */
676     function approve(address to, uint256 tokenId) external;
677 
678     /**
679      * @dev Approve or remove `operator` as an operator for the caller.
680      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
681      *
682      * Requirements:
683      *
684      * - The `operator` cannot be the caller.
685      *
686      * Emits an {ApprovalForAll} event.
687      */
688     function setApprovalForAll(address operator, bool _approved) external;
689 
690     /**
691      * @dev Returns the account approved for `tokenId` token.
692      *
693      * Requirements:
694      *
695      * - `tokenId` must exist.
696      */
697     function getApproved(uint256 tokenId) external view returns (address operator);
698 
699     /**
700      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
701      *
702      * See {setApprovalForAll}
703      */
704     function isApprovedForAll(address owner, address operator) external view returns (bool);
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 interface IERC721Metadata is IERC721 {
720     /**
721      * @dev Returns the token collection name.
722      */
723     function name() external view returns (string memory);
724 
725     /**
726      * @dev Returns the token collection symbol.
727      */
728     function symbol() external view returns (string memory);
729 
730     /**
731      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
732      */
733     function tokenURI(uint256 tokenId) external view returns (string memory);
734 }
735 
736 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
737 
738 
739 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 
745 
746 
747 
748 
749 
750 /**
751  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
752  * the Metadata extension, but not including the Enumerable extension, which is available separately as
753  * {ERC721Enumerable}.
754  */
755 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
756     using Address for address;
757     using Strings for uint256;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Mapping from token ID to owner address
766     mapping(uint256 => address) private _owners;
767 
768     // Mapping owner address to token count
769     mapping(address => uint256) private _balances;
770 
771     // Mapping from token ID to approved address
772     mapping(uint256 => address) private _tokenApprovals;
773 
774     // Mapping from owner to operator approvals
775     mapping(address => mapping(address => bool)) private _operatorApprovals;
776 
777     /**
778      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
779      */
780     constructor(string memory name_, string memory symbol_) {
781         _name = name_;
782         _symbol = symbol_;
783     }
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
789         return
790             interfaceId == type(IERC721).interfaceId ||
791             interfaceId == type(IERC721Metadata).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721-balanceOf}.
797      */
798     function balanceOf(address owner) public view virtual override returns (uint256) {
799         require(owner != address(0), "ERC721: address zero is not a valid owner");
800         return _balances[owner];
801     }
802 
803     /**
804      * @dev See {IERC721-ownerOf}.
805      */
806     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
807         address owner = _owners[tokenId];
808         require(owner != address(0), "ERC721: invalid token ID");
809         return owner;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-name}.
814      */
815     function name() public view virtual override returns (string memory) {
816         return _name;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-symbol}.
821      */
822     function symbol() public view virtual override returns (string memory) {
823         return _symbol;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-tokenURI}.
828      */
829     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
830         _requireMinted(tokenId);
831 
832         string memory baseURI = _baseURI();
833         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
834     }
835 
836     /**
837      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
838      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
839      * by default, can be overridden in child contracts.
840      */
841     function _baseURI() internal view virtual returns (string memory) {
842         return "";
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public virtual override {
849         address owner = ERC721.ownerOf(tokenId);
850         require(to != owner, "ERC721: approval to current owner");
851 
852         require(
853             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
854             "ERC721: approve caller is not token owner nor approved for all"
855         );
856 
857         _approve(to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-getApproved}.
862      */
863     function getApproved(uint256 tokenId) public view virtual override returns (address) {
864         _requireMinted(tokenId);
865 
866         return _tokenApprovals[tokenId];
867     }
868 
869     /**
870      * @dev See {IERC721-setApprovalForAll}.
871      */
872     function setApprovalForAll(address operator, bool approved) public virtual override {
873         _setApprovalForAll(_msgSender(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-transferFrom}.
885      */
886     function transferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         //solhint-disable-next-line max-line-length
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
893 
894         _transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, "");
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory data
916     ) public virtual override {
917         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
918         _safeTransfer(from, to, tokenId, data);
919     }
920 
921     /**
922      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
923      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
924      *
925      * `data` is additional data, it has no specified format and it is sent in call to `to`.
926      *
927      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
928      * implement alternative mechanisms to perform token transfer, such as signature-based.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must exist and be owned by `from`.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeTransfer(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory data
944     ) internal virtual {
945         _transfer(from, to, tokenId);
946         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      * and stop existing when they are burned (`_burn`).
956      */
957     function _exists(uint256 tokenId) internal view virtual returns (bool) {
958         return _owners[tokenId] != address(0);
959     }
960 
961     /**
962      * @dev Returns whether `spender` is allowed to manage `tokenId`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
969         address owner = ERC721.ownerOf(tokenId);
970         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
971     }
972 
973     /**
974      * @dev Safely mints `tokenId` and transfers it to `to`.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeMint(address to, uint256 tokenId) internal virtual {
984         _safeMint(to, tokenId, "");
985     }
986 
987     /**
988      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
989      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
990      */
991     function _safeMint(
992         address to,
993         uint256 tokenId,
994         bytes memory data
995     ) internal virtual {
996         _mint(to, tokenId);
997         require(
998             _checkOnERC721Received(address(0), to, tokenId, data),
999             "ERC721: transfer to non ERC721Receiver implementer"
1000         );
1001     }
1002 
1003     /**
1004      * @dev Mints `tokenId` and transfers it to `to`.
1005      *
1006      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must not exist.
1011      * - `to` cannot be the zero address.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _mint(address to, uint256 tokenId) internal virtual {
1016         require(to != address(0), "ERC721: mint to the zero address");
1017         require(!_exists(tokenId), "ERC721: token already minted");
1018 
1019         _beforeTokenTransfer(address(0), to, tokenId);
1020 
1021         _balances[to] += 1;
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(address(0), to, tokenId);
1025 
1026         _afterTokenTransfer(address(0), to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Destroys `tokenId`.
1031      * The approval is cleared when the token is burned.
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must exist.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _burn(uint256 tokenId) internal virtual {
1040         address owner = ERC721.ownerOf(tokenId);
1041 
1042         _beforeTokenTransfer(owner, address(0), tokenId);
1043 
1044         // Clear approvals
1045         _approve(address(0), tokenId);
1046 
1047         _balances[owner] -= 1;
1048         delete _owners[tokenId];
1049 
1050         emit Transfer(owner, address(0), tokenId);
1051 
1052         _afterTokenTransfer(owner, address(0), tokenId);
1053     }
1054 
1055     /**
1056      * @dev Transfers `tokenId` from `from` to `to`.
1057      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `tokenId` token must be owned by `from`.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _transfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) internal virtual {
1071         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1072         require(to != address(0), "ERC721: transfer to the zero address");
1073 
1074         _beforeTokenTransfer(from, to, tokenId);
1075 
1076         // Clear approvals from the previous owner
1077         _approve(address(0), tokenId);
1078 
1079         _balances[from] -= 1;
1080         _balances[to] += 1;
1081         _owners[tokenId] = to;
1082 
1083         emit Transfer(from, to, tokenId);
1084 
1085         _afterTokenTransfer(from, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev Approve `to` to operate on `tokenId`
1090      *
1091      * Emits an {Approval} event.
1092      */
1093     function _approve(address to, uint256 tokenId) internal virtual {
1094         _tokenApprovals[tokenId] = to;
1095         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1096     }
1097 
1098     /**
1099      * @dev Approve `operator` to operate on all of `owner` tokens
1100      *
1101      * Emits an {ApprovalForAll} event.
1102      */
1103     function _setApprovalForAll(
1104         address owner,
1105         address operator,
1106         bool approved
1107     ) internal virtual {
1108         require(owner != operator, "ERC721: approve to caller");
1109         _operatorApprovals[owner][operator] = approved;
1110         emit ApprovalForAll(owner, operator, approved);
1111     }
1112 
1113     /**
1114      * @dev Reverts if the `tokenId` has not been minted yet.
1115      */
1116     function _requireMinted(uint256 tokenId) internal view virtual {
1117         require(_exists(tokenId), "ERC721: invalid token ID");
1118     }
1119 
1120     /**
1121      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1122      * The call is not executed if the target address is not a contract.
1123      *
1124      * @param from address representing the previous owner of the given token ID
1125      * @param to target address that will receive the tokens
1126      * @param tokenId uint256 ID of the token to be transferred
1127      * @param data bytes optional data to send along with the call
1128      * @return bool whether the call correctly returned the expected magic value
1129      */
1130     function _checkOnERC721Received(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory data
1135     ) private returns (bool) {
1136         if (to.isContract()) {
1137             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1138                 return retval == IERC721Receiver.onERC721Received.selector;
1139             } catch (bytes memory reason) {
1140                 if (reason.length == 0) {
1141                     revert("ERC721: transfer to non ERC721Receiver implementer");
1142                 } else {
1143                     /// @solidity memory-safe-assembly
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
1192 // File: contracts/faust-fiends.sol
1193 
1194 
1195 
1196 /// 
1197 ///     _ ,  ___     _ _    _ ,          ___        
1198 ///   ,- -  -   -_, - - /  - -    -_-/  -   ---___- 
1199 ///  _||_  (  ~/||    ('||  ||   (_ /      (' ||    
1200 /// ' ||   (  / ||   (( ||--||  (_ --_    ((  ||    
1201 ///   ||    \/==||   (( ||--||    --_ )  ((   ||    
1202 ///   |,    /_ _||   (( /   ||   _/  ))   (( //     
1203 /// _-/    (  - \\,    -___-\\, (_-_-       -____-  
1204 ///                                                 
1205 ///   A SINFUL JOURNEY.                                                
1206 
1207 
1208 pragma solidity >=0.7.0 <0.9.0;
1209 
1210 
1211 
1212 
1213 contract FaustFiends is ERC721, Ownable {
1214   using Strings for uint256;
1215   using Counters for Counters.Counter;
1216 
1217   Counters.Counter private supply;
1218 
1219   string public uriPrefix = "";
1220   string public uriSuffix = ".json";
1221   string public hiddenMetadataUri;
1222   
1223   uint256 public cost;
1224   uint256 public maxSupply = 5000;
1225   uint256 public maxMintAmountPerTx = 2;
1226   uint256 public maxMintAmountPerWhitelistTx = 3;
1227 
1228   bool public whitelistMintEnabled = false;
1229   bool public publicMintEnabled = false;
1230   bool public revealed = false;
1231 
1232   mapping(address => bool) whitelist;
1233 
1234   mapping(address => bool) whitelistMinted;
1235   mapping(address => bool) publicMinted;
1236 
1237   constructor() ERC721("FAUST Fiend", "FIEND") {
1238     setHiddenMetadataUri("ipfs://QmQvta82BtPyNKE1TFMS4yjS3pdNfxFr7TwaMTqEFtArag/unrevealed.json");
1239     setCost(0);
1240     mintExistingHolders();
1241   }
1242 
1243   modifier onlyWhitelisted() {
1244     require(isWhitelisted(msg.sender), "You are not whitelisted");
1245     _;
1246   }
1247 
1248   modifier hasNotWhitelistMinted() {
1249     require(!whitelistMinted[msg.sender], "You have already minted during whitelist mint.");
1250     _;
1251   }
1252 
1253   modifier hasNotPublicMinted() {
1254     require(!publicMinted[msg.sender], "You have already minted during public mint.");
1255     _;
1256   }
1257 
1258   modifier whitelistMintCompliance(uint256 _mintAmount) {
1259     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerWhitelistTx, "Invalid whitelist mint amount!");
1260     require(supply.current() + _mintAmount <= maxSupply, "Max whitelist supply exceeded!");
1261     _;
1262   }
1263 
1264   modifier publicMintCompliance(uint256 _mintAmount) {
1265     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1266     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1267     _;
1268   }
1269 
1270   function isWhitelisted(address _address) public view returns (bool) {
1271       return whitelist[_address];
1272   }
1273 
1274   function hasWhitelistMinted(address _address) public view returns (bool) {
1275       return whitelistMinted[_address];
1276   }
1277 
1278   function hasPublicMinted(address _address) public view returns (bool) {
1279       return publicMinted[_address];
1280   }
1281 
1282     function whitelistAdd(address _address) public onlyOwner {
1283         whitelist[_address] = true;
1284     }
1285 
1286     function whitelistAddMultiple(address[] memory users) public onlyOwner {
1287         for (uint i = 0; i < users.length; i++) {
1288             whitelist[users[i]] = true;
1289         }
1290     }
1291 
1292     function whitelistRemove(address _address) public onlyOwner {
1293         whitelist[_address] = false;
1294     }
1295 
1296   function totalSupply() public view returns (uint256) {
1297     return supply.current();
1298   }
1299 
1300   function mint(uint256 _mintAmount) public payable publicMintCompliance(_mintAmount) hasNotPublicMinted {
1301     require(publicMintEnabled, "Public minting not enabled!");
1302     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1303 
1304     _mintLoop(msg.sender, _mintAmount);
1305     publicMinted[msg.sender] = true;
1306   }
1307 
1308   function whitelistMint(uint256 _mintAmount) public payable whitelistMintCompliance(_mintAmount) onlyWhitelisted hasNotWhitelistMinted{
1309     require(whitelistMintEnabled, "Whitelist minting not enabled!");
1310     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1311 
1312     _mintLoop(msg.sender, _mintAmount);
1313     whitelistMinted[msg.sender] = true;
1314   }
1315   
1316   function mintForAddress(uint256 _mintAmount, address _receiver) public publicMintCompliance(_mintAmount) onlyOwner {
1317     _mintLoop(_receiver, _mintAmount);
1318   }
1319 
1320   function walletOfOwner(address _owner)
1321     public
1322     view
1323     returns (uint256[] memory)
1324   {
1325     uint256 ownerTokenCount = balanceOf(_owner);
1326     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1327     uint256 currentTokenId = 1;
1328     uint256 ownedTokenIndex = 0;
1329 
1330     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1331       address currentTokenOwner = ownerOf(currentTokenId);
1332 
1333       if (currentTokenOwner == _owner) {
1334         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1335 
1336         ownedTokenIndex++;
1337       }
1338 
1339       currentTokenId++;
1340     }
1341 
1342     return ownedTokenIds;
1343   }
1344 
1345   function tokenURI(uint256 _tokenId)
1346     public
1347     view
1348     virtual
1349     override
1350     returns (string memory)
1351   {
1352     require(
1353       _exists(_tokenId),
1354       "ERC721Metadata: URI query for nonexistent token"
1355     );
1356 
1357     if (revealed == false) {
1358       return hiddenMetadataUri;
1359     }
1360 
1361     string memory currentBaseURI = _baseURI();
1362     return bytes(currentBaseURI).length > 0
1363         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1364         : "";
1365   }
1366 
1367   function setRevealed(bool _state) public onlyOwner {
1368     revealed = _state;
1369   }
1370 
1371   function setCost(uint256 _cost) public onlyOwner {
1372     cost = _cost;
1373   }
1374   
1375   // POWER UP OUR FIENDS COMING FROM THE FANTOM NETWORK
1376   function mintExistingHolders() internal {
1377       require(supply.current() == 0, "Tokens have already been minted!");
1378       address[81] memory existingHolders = [
1379           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1380           0xCAc7a3aA77b2Cb5a07c9f33c9B7118101770e410,
1381           0x6524E9B964978b86Ad6AA5B11374864926f0cfa5,
1382           0xE9d53d1e63925517b9dE2e0d724B91D88ABf6917,
1383           0xf4b01D989f81382b0690ccf5165A29B406679B00,
1384 
1385           0x4eBa0f6c0436013ae4759d3cC20D5b9970AE7735,
1386           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1387           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1388           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1389           0x5F13B17024C14D6D10D5F4c6A04c0877e0C3E50B,
1390 
1391           0x5F13B17024C14D6D10D5F4c6A04c0877e0C3E50B,
1392           0x08BCb4de5407B97cC1eb05f8331e88D35F74Ab83,
1393           0x08BCb4de5407B97cC1eb05f8331e88D35F74Ab83,
1394           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1395           0x33Cf3A4Fe0AeDfE3A85C2845395A438baba7702e,
1396 
1397           0xB5cC3308C8E0F12fCCCa72e0fA3C8C20518c11e7,
1398           0x4201fD30BC90689Dcb0E36177Cc2485B3177bbaE,
1399           0x22559E54E1702C27A99E03b8437482fCf1686113,
1400           0x22559E54E1702C27A99E03b8437482fCf1686113,
1401           0x7a0EF482134aa53468850A7b117EcA38A6a3003D,
1402 
1403           0x04B7dBD17a817d22eBD9B35A9a210D8e6E59a7CE,
1404           0xf2d696E7b3e040B160D658dE02C00A4Ef5Be1bC0,
1405           0xA7E1af033A471d37b7f5A495bF342418822cD979,
1406           0xA6f051653fB75dC3756f10209E2D0941fcB586e9,
1407           0x6524E9B964978b86Ad6AA5B11374864926f0cfa5,
1408           
1409           0x9eC99B98Fb35aB8bdaB4C37880759816180874De,
1410           0x4209F11186318DBca71996Fd5842bcA214b3269F,
1411           0x4553448E66559c825eca1E9B6b1A6D8556e8F584,
1412           0xA9Ea60Bb786e9F12b29bB44ba73a38418e0A365b,
1413           0x64C12292045246c4B01e44Ff79763749eC397d70,
1414 
1415           0xe15bE2C6771713077500d29634EB19D20BBb8BB1,
1416           0x51Ca42fb14C727e2E026Df8dab8Be684bfB3ED9A,
1417           0xB73C27e8f39CFd94bb1fF6F30Ccf41351E989df9,
1418           0x21E61C2905C0B1d3760984Bb5dC19915557e3Ed4,
1419           0x9448D4fDfAB5Ae18302c49ab8599EC744A0e743C,
1420           
1421           0xFFB671f107328B9dc46BA9aa5c9396D63CB95488,
1422           0x21E61C2905C0B1d3760984Bb5dC19915557e3Ed4,
1423           0x21E61C2905C0B1d3760984Bb5dC19915557e3Ed4,
1424           0x9448D4fDfAB5Ae18302c49ab8599EC744A0e743C,
1425           0x5F13B17024C14D6D10D5F4c6A04c0877e0C3E50B,
1426 
1427           0x0026dd985dA16f70E9D9cF739b08C6cdF6A7f407,
1428           0xf4E6232d2f86Bd3399D956b3892d6B1893e1e06E,
1429           0x59E5fe3a536d2fa69614E0A0692F5C6e3D6dCbfc,
1430           0x59E5fe3a536d2fa69614E0A0692F5C6e3D6dCbfc,
1431           0x21E61C2905C0B1d3760984Bb5dC19915557e3Ed4,
1432 
1433           0x21E61C2905C0B1d3760984Bb5dC19915557e3Ed4,
1434           0x4553448E66559c825eca1E9B6b1A6D8556e8F584,
1435           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1436           0x51Ca42fb14C727e2E026Df8dab8Be684bfB3ED9A,
1437           0x6d79af750b839414F63966288e40c8E7fBA3F0CF,
1438           
1439           0xE80cc1600Bfc4994f42cdbcBFc783A560e40e81a,
1440           0xe69DAb397b59f52dC8B65C01533a17538a07E2dD,
1441           0xe69DAb397b59f52dC8B65C01533a17538a07E2dD,
1442           0x5bB4c1c7B1149e236cA28A41Ac24528b0B35f9c5,
1443           0x02bfd87Fb5b3a7a2e643C0aF9a72e88E0F868077,
1444 
1445           0x7d6423C5077B2540Fafd6258CE93314048DBE41c,
1446           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1447           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1448           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1449           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1450           
1451           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1452           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1453           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1454           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1455           0xc030ad321418b559227Bc444d81DFeCF6fdaDC14,
1456           
1457           0xa802c75E4B00a239F18d238e7054aE058506d221,
1458           0x038B2e8c7DbcD053f749edB6c2cDF25CA3C6bEde,
1459           0x59E5fe3a536d2fa69614E0A0692F5C6e3D6dCbfc,
1460           0x3214e141bdAe08Be1f382A885cf3d2a448A5E780,
1461           0xfa16125e504c10DF4d0bd6942d5c3932F76E9918,
1462           
1463           0xCc879Ab4DE63FC7Be6aAca522285D6F5d816278e,
1464           0x8FDe1AC3a0459b4f7b3659c7a1df355F49601176,
1465           0xA9Ea60Bb786e9F12b29bB44ba73a38418e0A365b,
1466           0xafe47D6f287cE1397f6D1af56868ce8981D555e8,
1467           0xFb2EB8734F57bDEa9cbF2956972f25c0a704862e,
1468           
1469           0xF9542D1D4b7356A774eEb7FDdF7efD92B78bDE51,
1470           0x0F6b73e16C8cF8BAC1EA69b50e142c2edB8f1c96,
1471           0x857D5884FC42CEa646bD62Cc84F806aEB9a2AE6F,
1472           0x8Cc1226540EB7Da70BD230BB4bfaEeBd3Ff053cb,
1473           0xb96A1688DDCE8da1F2e2aDD33962768224E39E4C,
1474           
1475           0xb96A1688DDCE8da1F2e2aDD33962768224E39E4C
1476       ];
1477 
1478       for (uint256 i = 0; i < existingHolders.length; i++) {
1479         supply.increment();
1480         _safeMint(existingHolders[i], supply.current());
1481       }
1482   }
1483 
1484   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1485     maxMintAmountPerTx = _maxMintAmountPerTx;
1486   }
1487 
1488   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1489     hiddenMetadataUri = _hiddenMetadataUri;
1490   }
1491 
1492   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1493     uriPrefix = _uriPrefix;
1494   }
1495 
1496   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1497     uriSuffix = _uriSuffix;
1498   }
1499 
1500   function setPublicMintEnabled(bool _state) public onlyOwner {
1501     publicMintEnabled = _state;
1502   }
1503 
1504   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1505     whitelistMintEnabled = _state;
1506   }
1507 
1508   function withdraw() public onlyOwner {
1509     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1510     require(os);
1511   }
1512 
1513   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1514     for (uint256 i = 0; i < _mintAmount; i++) {
1515       supply.increment();
1516       _safeMint(_receiver, supply.current());
1517     }
1518   }
1519 
1520   function _baseURI() internal view virtual override returns (string memory) {
1521     return uriPrefix;
1522   }
1523 }