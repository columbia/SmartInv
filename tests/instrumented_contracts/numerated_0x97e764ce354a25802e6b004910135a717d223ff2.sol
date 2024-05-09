1 //
2 // ██████╗░░█████╗░██╗░░░██╗██████╗░██╗░░██╗░█████╗░███╗░░██╗███████╗
3 // ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗██║░░██║██╔══██╗████╗░██║██╔════╝
4 // ██████╔╝███████║░╚████╔╝░██████╔╝███████║██║░░██║██╔██╗██║█████╗░░
5 // ██╔═══╝░██╔══██║░░╚██╔╝░░██╔═══╝░██╔══██║██║░░██║██║╚████║██╔══╝░░
6 // ██║░░░░░██║░░██║░░░██║░░░██║░░░░░██║░░██║╚█████╔╝██║░╚███║███████╗
7 // ╚═╝░░░░░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝
8 //
9 // Payphone by 0xDEAFBEEF
10 // Sep 2022
11 
12 // File: @openzeppelin/contracts@4.5.0/utils/Counters.sol
13 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
14 //SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @title Counters
20  * @author Matt Condon (@shrugs)
21  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
22  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
23  *
24  * Include with `using Counters for Counters.Counter;`
25  */
26 library Counters {
27     struct Counter {
28         // This variable should never be directly accessed by users of the library: interactions must be restricted to
29         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
30         // this feature: see https://github.com/ethereum/solidity/issues/4637
31         uint256 _value; // default: 0
32     }
33 
34     function current(Counter storage counter) internal view returns (uint256) {
35         return counter._value;
36     }
37 
38     function increment(Counter storage counter) internal {
39         unchecked {
40             counter._value += 1;
41         }
42     }
43 
44     function decrement(Counter storage counter) internal {
45         uint256 value = counter._value;
46         require(value > 0, "Counter: decrement overflow");
47         unchecked {
48             counter._value = value - 1;
49         }
50     }
51 
52     function reset(Counter storage counter) internal {
53         counter._value = 0;
54     }
55 }
56 
57 // File: @openzeppelin/contracts@4.5.0/utils/Strings.sol
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev String operations.
66  */
67 library Strings {
68     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
72      */
73     function toString(uint256 value) internal pure returns (string memory) {
74         // Inspired by OraclizeAPI's implementation - MIT licence
75         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
76 
77         if (value == 0) {
78             return "0";
79         }
80         uint256 temp = value;
81         uint256 digits;
82         while (temp != 0) {
83             digits++;
84             temp /= 10;
85         }
86         bytes memory buffer = new bytes(digits);
87         while (value != 0) {
88             digits -= 1;
89             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
90             value /= 10;
91         }
92         return string(buffer);
93     }
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
97      */
98     function toHexString(uint256 value) internal pure returns (string memory) {
99         if (value == 0) {
100             return "0x00";
101         }
102         uint256 temp = value;
103         uint256 length = 0;
104         while (temp != 0) {
105             length++;
106             temp >>= 8;
107         }
108         return toHexString(value, length);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
113      */
114     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
115         bytes memory buffer = new bytes(2 * length + 2);
116         buffer[0] = "0";
117         buffer[1] = "x";
118         for (uint256 i = 2 * length + 1; i > 1; --i) {
119             buffer[i] = _HEX_SYMBOLS[value & 0xf];
120             value >>= 4;
121         }
122         require(value == 0, "Strings: hex length insufficient");
123         return string(buffer);
124     }
125 }
126 
127 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * @dev Contract module which provides a basic access control mechanism, where
164  * there is an account (an owner) that can be granted exclusive access to
165  * specific functions.
166  *
167  * By default, the owner account will be the one that deploys the contract. This
168  * can later be changed with {transferOwnership}.
169  *
170  * This module is used through inheritance. It will make available the modifier
171  * `onlyOwner`, which can be applied to your functions to restrict their use to
172  * the owner.
173  */
174 abstract contract Ownable is Context {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     /**
180      * @dev Initializes the contract setting the deployer as the initial owner.
181      */
182     constructor() {
183         _transferOwnership(_msgSender());
184     }
185 
186     /**
187      * @dev Returns the address of the current owner.
188      */
189     function owner() public view virtual returns (address) {
190         return _owner;
191     }
192 
193     /**
194      * @dev Throws if called by any account other than the owner.
195      */
196     modifier onlyOwner() {
197         require(owner() == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201     /**
202      * @dev Leaves the contract without owner. It will not be possible to call
203      * `onlyOwner` functions anymore. Can only be called by the current owner.
204      *
205      * NOTE: Renouncing ownership will leave the contract without an owner,
206      * thereby removing any functionality that is only available to the owner.
207      */
208     function renounceOwnership() public virtual onlyOwner {
209         _transferOwnership(address(0));
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Can only be called by the current owner.
215      */
216     function transferOwnership(address newOwner) public virtual onlyOwner {
217         require(newOwner != address(0), "Ownable: new owner is the zero address");
218         _transferOwnership(newOwner);
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Internal function without access restriction.
224      */
225     function _transferOwnership(address newOwner) internal virtual {
226         address oldOwner = _owner;
227         _owner = newOwner;
228         emit OwnershipTransferred(oldOwner, newOwner);
229     }
230 }
231 
232 // File: @openzeppelin/contracts@4.5.0/utils/Address.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
236 
237 pragma solidity ^0.8.1;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      *
260      * [IMPORTANT]
261      * ====
262      * You shouldn't rely on `isContract` to protect against flash loan attacks!
263      *
264      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
265      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
266      * constructor.
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts@4.5.0/token/ERC721/IERC721Receiver.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @title ERC721 token receiver interface
466  * @dev Interface for any contract that wants to support safeTransfers
467  * from ERC721 asset contracts.
468  */
469 interface IERC721Receiver {
470     /**
471      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
472      * by `operator` from `from`, this function is called.
473      *
474      * It must return its Solidity selector to confirm the token transfer.
475      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
476      *
477      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
478      */
479     function onERC721Received(
480         address operator,
481         address from,
482         uint256 tokenId,
483         bytes calldata data
484     ) external returns (bytes4);
485 }
486 
487 // File: @openzeppelin/contracts@4.5.0/utils/introspection/IERC165.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @dev Interface of the ERC165 standard, as defined in the
496  * https://eips.ethereum.org/EIPS/eip-165[EIP].
497  *
498  * Implementers can declare support of contract interfaces, which can then be
499  * queried by others ({ERC165Checker}).
500  *
501  * For an implementation, see {ERC165}.
502  */
503 interface IERC165 {
504     /**
505      * @dev Returns true if this contract implements the interface defined by
506      * `interfaceId`. See the corresponding
507      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
508      * to learn more about how these ids are created.
509      *
510      * This function call must use less than 30 000 gas.
511      */
512     function supportsInterface(bytes4 interfaceId) external view returns (bool);
513 }
514 
515 // File: @openzeppelin/contracts@4.5.0/utils/introspection/ERC165.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @dev Implementation of the {IERC165} interface.
525  *
526  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
527  * for the additional interface id that will be supported. For example:
528  *
529  * ```solidity
530  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
532  * }
533  * ```
534  *
535  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
536  */
537 abstract contract ERC165 is IERC165 {
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         return interfaceId == type(IERC165).interfaceId;
543     }
544 }
545 
546 // File: @openzeppelin/contracts@4.5.0/token/ERC721/IERC721.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Required interface of an ERC721 compliant contract.
556  */
557 interface IERC721 is IERC165 {
558     /**
559      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
560      */
561     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
565      */
566     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
567 
568     /**
569      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
570      */
571     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
572 
573     /**
574      * @dev Returns the number of tokens in ``owner``'s account.
575      */
576     function balanceOf(address owner) external view returns (uint256 balance);
577 
578     /**
579      * @dev Returns the owner of the `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function ownerOf(uint256 tokenId) external view returns (address owner);
586 
587     /**
588      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
589      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function safeTransferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external;
606 
607     /**
608      * @dev Transfers `tokenId` token from `from` to `to`.
609      *
610      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      *
619      * Emits a {Transfer} event.
620      */
621     function transferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) external;
626 
627     /**
628      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
629      * The approval is cleared when the token is transferred.
630      *
631      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
632      *
633      * Requirements:
634      *
635      * - The caller must own the token or be an approved operator.
636      * - `tokenId` must exist.
637      *
638      * Emits an {Approval} event.
639      */
640     function approve(address to, uint256 tokenId) external;
641 
642     /**
643      * @dev Returns the account approved for `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function getApproved(uint256 tokenId) external view returns (address operator);
650 
651     /**
652      * @dev Approve or remove `operator` as an operator for the caller.
653      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
654      *
655      * Requirements:
656      *
657      * - The `operator` cannot be the caller.
658      *
659      * Emits an {ApprovalForAll} event.
660      */
661     function setApprovalForAll(address operator, bool _approved) external;
662 
663     /**
664      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
665      *
666      * See {setApprovalForAll}
667      */
668     function isApprovedForAll(address owner, address operator) external view returns (bool);
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must exist and be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
680      *
681      * Emits a {Transfer} event.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId,
687         bytes calldata data
688     ) external;
689 }
690 
691 // File: @openzeppelin/contracts@4.5.0/token/ERC721/extensions/IERC721Metadata.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Metadata is IERC721 {
704     /**
705      * @dev Returns the token collection name.
706      */
707     function name() external view returns (string memory);
708 
709     /**
710      * @dev Returns the token collection symbol.
711      */
712     function symbol() external view returns (string memory);
713 
714     /**
715      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
716      */
717     function tokenURI(uint256 tokenId) external view returns (string memory);
718 }
719 
720 // File: @openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 
729 
730 
731 
732 
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension, but not including the Enumerable extension, which is available separately as
737  * {ERC721Enumerable}.
738  */
739 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Token name
744     string private _name;
745 
746     // Token symbol
747     string private _symbol;
748 
749     string internal _baseURI;
750 
751     // Mapping from token ID to owner address
752     mapping(uint256 => address) private _owners;
753 
754     // Mapping owner address to token count
755     mapping(address => uint256) private _balances;
756 
757     // Mapping from token ID to approved address
758     mapping(uint256 => address) private _tokenApprovals;
759 
760     // Mapping from owner to operator approvals
761     mapping(address => mapping(address => bool)) private _operatorApprovals;
762 
763     /**
764      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
765      */
766     constructor(string memory name_, string memory symbol_) {
767         _name = name_;
768         _symbol = symbol_;
769     }
770 
771     /**
772      * @dev See {IERC165-supportsInterface}.
773      */
774     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
775         return
776             interfaceId == type(IERC721).interfaceId ||
777             interfaceId == type(IERC721Metadata).interfaceId ||
778             super.supportsInterface(interfaceId);
779     }
780 
781     /**
782      * @dev See {IERC721-balanceOf}.
783      */
784     function balanceOf(address owner) public view virtual override returns (uint256) {
785         require(owner != address(0), "ERC721: balance query for the zero address");
786         return _balances[owner];
787     }
788 
789     /**
790      * @dev See {IERC721-ownerOf}.
791      */
792     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
793         address owner = _owners[tokenId];
794         require(owner != address(0), "ERC721: owner query for nonexistent token");
795         return owner;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
816         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
817 
818         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : "";
819     }
820 
821 
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             "ERC721: approve caller is not owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public virtual override {
851         _setApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         //solhint-disable-next-line max-line-length
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
871 
872         _transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         safeTransferFrom(from, to, tokenId, "");
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) public virtual override {
895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
896         _safeTransfer(from, to, tokenId, _data);
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
902      *
903      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
904      *
905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
906      * implement alternative mechanisms to perform token transfer, such as signature-based.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeTransfer(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) internal virtual {
923         _transfer(from, to, tokenId);
924         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      * and stop existing when they are burned (`_burn`).
934      */
935     function _exists(uint256 tokenId) internal view virtual returns (bool) {
936         return _owners[tokenId] != address(0);
937     }
938 
939     /**
940      * @dev Returns whether `spender` is allowed to manage `tokenId`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
947         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
948         address owner = ERC721.ownerOf(tokenId);
949         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
950     }
951 
952     /**
953      * @dev Safely mints `tokenId` and transfers it to `to`.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must not exist.
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _safeMint(address to, uint256 tokenId) internal virtual {
963         _safeMint(to, tokenId, "");
964     }
965 
966     /**
967      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
968      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
969      */
970     function _safeMint(
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) internal virtual {
975         _mint(to, tokenId);
976         require(
977             _checkOnERC721Received(address(0), to, tokenId, _data),
978             "ERC721: transfer to non ERC721Receiver implementer"
979         );
980     }
981 
982     /**
983      * @dev Mints `tokenId` and transfers it to `to`.
984      *
985      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
986      *
987      * Requirements:
988      *
989      * - `tokenId` must not exist.
990      * - `to` cannot be the zero address.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _mint(address to, uint256 tokenId) internal virtual {
995         require(to != address(0), "ERC721: mint to the zero address");
996         require(!_exists(tokenId), "ERC721: token already minted");
997 
998         _beforeTokenTransfer(address(0), to, tokenId);
999 
1000         _balances[to] += 1;
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(address(0), to, tokenId);
1004 
1005         _afterTokenTransfer(address(0), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Destroys `tokenId`.
1010      * The approval is cleared when the token is burned.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _burn(uint256 tokenId) internal virtual {
1019         address owner = ERC721.ownerOf(tokenId);
1020 
1021         _beforeTokenTransfer(owner, address(0), tokenId);
1022 
1023         // Clear approvals
1024         _approve(address(0), tokenId);
1025 
1026         _balances[owner] -= 1;
1027         delete _owners[tokenId];
1028 
1029         emit Transfer(owner, address(0), tokenId);
1030 
1031         _afterTokenTransfer(owner, address(0), tokenId);
1032     }
1033 
1034     /**
1035      * @dev Transfers `tokenId` from `from` to `to`.
1036      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1037      *
1038      * Requirements:
1039      *
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) internal virtual {
1050         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1051         require(to != address(0), "ERC721: transfer to the zero address");
1052 
1053         _beforeTokenTransfer(from, to, tokenId);
1054 
1055         // Clear approvals from the previous owner
1056         _approve(address(0), tokenId);
1057 
1058         _balances[from] -= 1;
1059         _balances[to] += 1;
1060         _owners[tokenId] = to;
1061 
1062         emit Transfer(from, to, tokenId);
1063 
1064         _afterTokenTransfer(from, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `to` to operate on `tokenId`
1069      *
1070      * Emits a {Approval} event.
1071      */
1072     function _approve(address to, uint256 tokenId) internal virtual {
1073         _tokenApprovals[tokenId] = to;
1074         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Approve `operator` to operate on all of `owner` tokens
1079      *
1080      * Emits a {ApprovalForAll} event.
1081      */
1082     function _setApprovalForAll(
1083         address owner,
1084         address operator,
1085         bool approved
1086     ) internal virtual {
1087         require(owner != operator, "ERC721: approve to caller");
1088         _operatorApprovals[owner][operator] = approved;
1089         emit ApprovalForAll(owner, operator, approved);
1090     }
1091 
1092     /**
1093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1094      * The call is not executed if the target address is not a contract.
1095      *
1096      * @param from address representing the previous owner of the given token ID
1097      * @param to target address that will receive the tokens
1098      * @param tokenId uint256 ID of the token to be transferred
1099      * @param _data bytes optional data to send along with the call
1100      * @return bool whether the call correctly returned the expected magic value
1101      */
1102     function _checkOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         if (to.isContract()) {
1109             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1110                 return retval == IERC721Receiver.onERC721Received.selector;
1111             } catch (bytes memory reason) {
1112                 if (reason.length == 0) {
1113                     revert("ERC721: transfer to non ERC721Receiver implementer");
1114                 } else {
1115                     assembly {
1116                         revert(add(32, reason), mload(reason))
1117                     }
1118                 }
1119             }
1120         } else {
1121             return true;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before any token transfer. This includes minting
1127      * and burning.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Hook that is called after any transfer of tokens. This includes
1147      * minting and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero.
1152      * - `from` and `to` are never both zero.
1153      *
1154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1155      */
1156     function _afterTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {}
1161 }
1162 
1163 // File: payphone.sol
1164 
1165 pragma solidity ^0.8.4;
1166 
1167 contract PayPhone is ERC721, Ownable {
1168     using Counters for Counters.Counter;
1169     uint256 public last_dial_ts;
1170     uint256 public dial_index;
1171     uint256 public callsRemaining;
1172     uint256 public callRateLimit;
1173     bool public inTheOffice;
1174     uint256 public dialCost;
1175     uint256 public maxMsgLength;
1176     event DialEvent(address from, string m,uint256 dial_id);
1177     bool public isSealed;
1178 
1179     Counters.Counter private _tokenIdCounter;
1180     struct dialStruct {
1181         address from;
1182         uint256 ts;
1183         string m; //optionally store the message in contract storage
1184     }
1185     struct tokenStruct {
1186         uint256 dialId; //indentifies which dial, index into dials[] id;
1187         string m; //optionally store the message in contract storage
1188         string ipfs; //optional IPFS hash for backup of metadata
1189     }
1190 
1191     mapping (uint256 => dialStruct) public dials;
1192     mapping (uint256 => tokenStruct) public tokens;
1193 
1194     constructor() ERC721("PayPhone", "PAYPHONE") {
1195         inTheOffice = false;
1196         callsRemaining = 0;
1197         callRateLimit = 60;
1198         setBaseURI("https://payphone.deafbeef.com/");
1199         dialCost = 25000000000; //calls cost 25 Gwei
1200         maxMsgLength=10000;
1201     }
1202 
1203     function dial(string calldata m) payable public {
1204         require(msg.value>=dialCost, "Must send [dialCost] to dial");
1205 
1206         require(inTheOffice==true,"Please call back during business hours.");
1207         require(callsRemaining > 0,"Order book is full for now. Call back later.");
1208         require(block.timestamp - last_dial_ts > callRateLimit,"Busy signal. Wait [callRateLimit] seconds before calling back.");
1209         require(bytes(m).length < maxMsgLength, "Message too long");
1210 
1211         last_dial_ts = block.timestamp;
1212         dials[dial_index].from = msg.sender;
1213         dials[dial_index].ts = last_dial_ts;
1214         
1215         dial_index++;
1216         callsRemaining--;
1217         emit DialEvent(msg.sender,m,dial_index-1);    
1218     }
1219 
1220     //seconds remaining in rate limiting
1221     function timeRemaining() public view returns (uint256) { 
1222         uint256 a = block.timestamp - last_dial_ts;
1223         if (a > callRateLimit) {
1224             return 0;
1225         }  else {
1226             return callRateLimit - a;
1227         }
1228     }
1229 
1230     function setTokenIPFS(uint256 id, string memory h) public onlyOwner {
1231         require(id < _tokenIdCounter.current(), "TokenID out of range.");
1232         
1233         tokens[id].ipfs = h;
1234     }
1235 
1236     function setTokenDetails(uint256 id, uint256 dialId, string calldata m) public onlyOwner {
1237         require(id < _tokenIdCounter.current(), "TokenID out of range.");
1238         
1239         tokens[id].dialId = dialId;
1240         tokens[id].m = m;
1241     }
1242     
1243     function storeDialMessage(uint256 dialId, string calldata m) public onlyOwner {
1244         require(dialId < dial_index, "Dial Index out of range.");
1245         dials[dialId].m = m;
1246     }
1247 
1248     function setBaseURI(string memory b) public onlyOwner {
1249         _baseURI = b;
1250     }
1251     function setMaxMsgLength(uint256 a) public onlyOwner {
1252         maxMsgLength=a;
1253     }
1254     function setDialCost(uint256 a) public onlyOwner {
1255         dialCost = a;
1256     }
1257 
1258     //enable
1259     function setInTheOffice(bool a) public onlyOwner {
1260         inTheOffice = a;
1261     }
1262 
1263     //set the number of calls allowed during a shift
1264     function setCallsRemaining(uint256 a) public onlyOwner {
1265         callsRemaining = a;
1266     }
1267     function seal() public onlyOwner {
1268         isSealed=true;
1269     }
1270     
1271     function withdraw() public onlyOwner {	
1272       payable(msg.sender).transfer(address(this).balance);
1273     }
1274 
1275     //set the allowable minimum number of seconds between calls
1276     function setCallRateLimit(uint256 a) public onlyOwner {
1277         callRateLimit = a;
1278     }
1279     function safeMint(address to) public onlyOwner {
1280         require(!isSealed, "contract sealed");
1281         uint256 tokenId = _tokenIdCounter.current();
1282         _tokenIdCounter.increment();
1283         _safeMint(to, tokenId);
1284     }
1285 }