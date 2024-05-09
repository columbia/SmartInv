1 // _     _ _    _____  ____   ____  _   _     
2  //| |   (_) |  / ____|/ __ \ / __ \| \ | |    
3  //| |__  _| |_| |  __| |  | | |  | |  \| |___ 
4  //| '_ \| | __| | |_ | |  | | |  | | . ` / __|
5  //| |_) | | |_| |__| | |__| | |__| | |\  \__ \
6  //|_.__/|_|\__|\_____|\____/ \____/|_| \_|___/
7 //  _                   _           _     _ _  
8 // | |                 | |         | |   (_) |   
9 // | |__  _   _   _ __ | |__   ___ | |__  _| | __
10 // | '_ \| | | | | '_ \| '_ \ / _ \| '_ \| | |/ /
11 // | |_) | |_| | | |_) | | | | (_) | |_) | |   < 
12 // |_.__/ \__, | | .__/|_| |_|\___/|_.__/|_|_|\_\
13 //         __/ | | |                             
14 //        |___/  |_|          
15 //https://bitgoons.com
16 //https://twitter.com/bitgoons
17 //https://instagram.com/bitgoons
18 
19 // SPDX-License-Identifier: MIT
20 // File: @openzeppelin/contracts/utils/Counters.sol
21 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @title Counters
27  * @author Matt Condon (@shrugs)
28  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
29  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
30  *
31  * Include with `using Counters for Counters.Counter;`
32  */
33 library Counters {
34     struct Counter {
35         // This variable should never be directly accessed by users of the library: interactions must be restricted to
36         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
37         // this feature: see https://github.com/ethereum/solidity/issues/4637
38         uint256 _value; // default: 0
39     }
40 
41     function current(Counter storage counter) internal view returns (uint256) {
42         return counter._value;
43     }
44 
45     function increment(Counter storage counter) internal {
46         unchecked {
47             counter._value += 1;
48         }
49     }
50 
51     function decrement(Counter storage counter) internal {
52         uint256 value = counter._value;
53         require(value > 0, "Counter: decrement overflow");
54         unchecked {
55             counter._value = value - 1;
56         }
57     }
58 
59     function reset(Counter storage counter) internal {
60         counter._value = 0;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Context.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/access/Ownable.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Contract module which provides a basic access control mechanism, where
171  * there is an account (an owner) that can be granted exclusive access to
172  * specific functions.
173  *
174  * By default, the owner account will be the one that deploys the contract. This
175  * can later be changed with {transferOwnership}.
176  *
177  * This module is used through inheritance. It will make available the modifier
178  * `onlyOwner`, which can be applied to your functions to restrict their use to
179  * the owner.
180  */
181 abstract contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     /**
187      * @dev Initializes the contract setting the deployer as the initial owner.
188      */
189     constructor() {
190         _transferOwnership(_msgSender());
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if called by any account other than the owner.
202      */
203     modifier onlyOwner() {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205         _;
206     }
207 
208     /**
209      * @dev Leaves the contract without owner. It will not be possible to call
210      * `onlyOwner` functions anymore. Can only be called by the current owner.
211      *
212      * NOTE: Renouncing ownership will leave the contract without an owner,
213      * thereby removing any functionality that is only available to the owner.
214      */
215     function renounceOwnership() public virtual onlyOwner {
216         _transferOwnership(address(0));
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Can only be called by the current owner.
222      */
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         _transferOwnership(newOwner);
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Internal function without access restriction.
231      */
232     function _transferOwnership(address newOwner) internal virtual {
233         address oldOwner = _owner;
234         _owner = newOwner;
235         emit OwnershipTransferred(oldOwner, newOwner);
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         assembly {
274             size := extcodesize(account)
275         }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @title ERC721 token receiver interface
468  * @dev Interface for any contract that wants to support safeTransfers
469  * from ERC721 asset contracts.
470  */
471 interface IERC721Receiver {
472     /**
473      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
474      * by `operator` from `from`, this function is called.
475      *
476      * It must return its Solidity selector to confirm the token transfer.
477      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
478      *
479      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
480      */
481     function onERC721Received(
482         address operator,
483         address from,
484         uint256 tokenId,
485         bytes calldata data
486     ) external returns (bytes4);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Interface of the ERC165 standard, as defined in the
498  * https://eips.ethereum.org/EIPS/eip-165[EIP].
499  *
500  * Implementers can declare support of contract interfaces, which can then be
501  * queried by others ({ERC165Checker}).
502  *
503  * For an implementation, see {ERC165}.
504  */
505 interface IERC165 {
506     /**
507      * @dev Returns true if this contract implements the interface defined by
508      * `interfaceId`. See the corresponding
509      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
510      * to learn more about how these ids are created.
511      *
512      * This function call must use less than 30 000 gas.
513      */
514     function supportsInterface(bytes4 interfaceId) external view returns (bool);
515 }
516 
517 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Required interface of an ERC721 compliant contract.
558  */
559 interface IERC721 is IERC165 {
560     /**
561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
562      */
563     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
567      */
568     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
572      */
573     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
574 
575     /**
576      * @dev Returns the number of tokens in ``owner``'s account.
577      */
578     function balanceOf(address owner) external view returns (uint256 balance);
579 
580     /**
581      * @dev Returns the owner of the `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function ownerOf(uint256 tokenId) external view returns (address owner);
588 
589     /**
590      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
591      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must exist and be owned by `from`.
598      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Transfers `tokenId` token from `from` to `to`.
611      *
612      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
631      * The approval is cleared when the token is transferred.
632      *
633      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
634      *
635      * Requirements:
636      *
637      * - The caller must own the token or be an approved operator.
638      * - `tokenId` must exist.
639      *
640      * Emits an {Approval} event.
641      */
642     function approve(address to, uint256 tokenId) external;
643 
644     /**
645      * @dev Returns the account approved for `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function getApproved(uint256 tokenId) external view returns (address operator);
652 
653     /**
654      * @dev Approve or remove `operator` as an operator for the caller.
655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
656      *
657      * Requirements:
658      *
659      * - The `operator` cannot be the caller.
660      *
661      * Emits an {ApprovalForAll} event.
662      */
663     function setApprovalForAll(address operator, bool _approved) external;
664 
665     /**
666      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
667      *
668      * See {setApprovalForAll}
669      */
670     function isApprovedForAll(address owner, address operator) external view returns (bool);
671 
672     /**
673      * @dev Safely transfers `tokenId` token from `from` to `to`.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes calldata data
690     ) external;
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
703  * @dev See https://eips.ethereum.org/EIPS/eip-721
704  */
705 interface IERC721Metadata is IERC721 {
706     /**
707      * @dev Returns the token collection name.
708      */
709     function name() external view returns (string memory);
710 
711     /**
712      * @dev Returns the token collection symbol.
713      */
714     function symbol() external view returns (string memory);
715 
716     /**
717      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
718      */
719     function tokenURI(uint256 tokenId) external view returns (string memory);
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension, but not including the Enumerable extension, which is available separately as
732  * {ERC721Enumerable}.
733  */
734 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to owner address
745     mapping(uint256 => address) private _owners;
746 
747     // Mapping owner address to token count
748     mapping(address => uint256) private _balances;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     /**
757      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
758      */
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
768         return
769             interfaceId == type(IERC721).interfaceId ||
770             interfaceId == type(IERC721Metadata).interfaceId ||
771             super.supportsInterface(interfaceId);
772     }
773 
774     /**
775      * @dev See {IERC721-balanceOf}.
776      */
777     function balanceOf(address owner) public view virtual override returns (uint256) {
778         require(owner != address(0), "ERC721: balance query for the zero address");
779         return _balances[owner];
780     }
781 
782     /**
783      * @dev See {IERC721-ownerOf}.
784      */
785     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
786         address owner = _owners[tokenId];
787         require(owner != address(0), "ERC721: owner query for nonexistent token");
788         return owner;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-name}.
793      */
794     function name() public view virtual override returns (string memory) {
795         return _name;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-symbol}.
800      */
801     function symbol() public view virtual override returns (string memory) {
802         return _symbol;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-tokenURI}.
807      */
808     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
809         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
810 
811         string memory baseURI = _baseURI();
812         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
813     }
814 
815     /**
816      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
817      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
818      * by default, can be overriden in child contracts.
819      */
820     function _baseURI() internal view virtual returns (string memory) {
821         return "";
822     }
823 
824     /**
825      * @dev See {IERC721-approve}.
826      */
827     function approve(address to, uint256 tokenId) public virtual override {
828         address owner = ERC721.ownerOf(tokenId);
829         require(to != owner, "ERC721: approval to current owner");
830 
831         require(
832             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
833             "ERC721: approve caller is not owner nor approved for all"
834         );
835 
836         _approve(to, tokenId);
837     }
838 
839     /**
840      * @dev See {IERC721-getApproved}.
841      */
842     function getApproved(uint256 tokenId) public view virtual override returns (address) {
843         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
844 
845         return _tokenApprovals[tokenId];
846     }
847 
848     /**
849      * @dev See {IERC721-setApprovalForAll}.
850      */
851     function setApprovalForAll(address operator, bool approved) public virtual override {
852         _setApprovalForAll(_msgSender(), operator, approved);
853     }
854 
855     /**
856      * @dev See {IERC721-isApprovedForAll}.
857      */
858     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
859         return _operatorApprovals[owner][operator];
860     }
861 
862     /**
863      * @dev See {IERC721-transferFrom}.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         //solhint-disable-next-line max-line-length
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
872 
873         _transfer(from, to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         safeTransferFrom(from, to, tokenId, "");
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) public virtual override {
896         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
897         _safeTransfer(from, to, tokenId, _data);
898     }
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
902      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
903      *
904      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
905      *
906      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
907      * implement alternative mechanisms to perform token transfer, such as signature-based.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _safeTransfer(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) internal virtual {
924         _transfer(from, to, tokenId);
925         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      * and stop existing when they are burned (`_burn`).
935      */
936     function _exists(uint256 tokenId) internal view virtual returns (bool) {
937         return _owners[tokenId] != address(0);
938     }
939 
940     /**
941      * @dev Returns whether `spender` is allowed to manage `tokenId`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      */
947     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
948         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
951     }
952 
953     /**
954      * @dev Safely mints `tokenId` and transfers it to `to`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeMint(address to, uint256 tokenId) internal virtual {
964         _safeMint(to, tokenId, "");
965     }
966 
967     /**
968      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
969      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
970      */
971     function _safeMint(
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) internal virtual {
976         _mint(to, tokenId);
977         require(
978             _checkOnERC721Received(address(0), to, tokenId, _data),
979             "ERC721: transfer to non ERC721Receiver implementer"
980         );
981     }
982 
983     /**
984      * @dev Mints `tokenId` and transfers it to `to`.
985      *
986      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
987      *
988      * Requirements:
989      *
990      * - `tokenId` must not exist.
991      * - `to` cannot be the zero address.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _mint(address to, uint256 tokenId) internal virtual {
996         require(to != address(0), "ERC721: mint to the zero address");
997         require(!_exists(tokenId), "ERC721: token already minted");
998 
999         _beforeTokenTransfer(address(0), to, tokenId);
1000 
1001         _balances[to] += 1;
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(address(0), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Destroys `tokenId`.
1009      * The approval is cleared when the token is burned.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _burn(uint256 tokenId) internal virtual {
1018         address owner = ERC721.ownerOf(tokenId);
1019 
1020         _beforeTokenTransfer(owner, address(0), tokenId);
1021 
1022         // Clear approvals
1023         _approve(address(0), tokenId);
1024 
1025         _balances[owner] -= 1;
1026         delete _owners[tokenId];
1027 
1028         emit Transfer(owner, address(0), tokenId);
1029     }
1030 
1031     /**
1032      * @dev Transfers `tokenId` from `from` to `to`.
1033      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {
1047         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Approve `to` to operate on `tokenId`
1064      *
1065      * Emits a {Approval} event.
1066      */
1067     function _approve(address to, uint256 tokenId) internal virtual {
1068         _tokenApprovals[tokenId] = to;
1069         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Approve `operator` to operate on all of `owner` tokens
1074      *
1075      * Emits a {ApprovalForAll} event.
1076      */
1077     function _setApprovalForAll(
1078         address owner,
1079         address operator,
1080         bool approved
1081     ) internal virtual {
1082         require(owner != operator, "ERC721: approve to caller");
1083         _operatorApprovals[owner][operator] = approved;
1084         emit ApprovalForAll(owner, operator, approved);
1085     }
1086 
1087     /**
1088      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1089      * The call is not executed if the target address is not a contract.
1090      *
1091      * @param from address representing the previous owner of the given token ID
1092      * @param to target address that will receive the tokens
1093      * @param tokenId uint256 ID of the token to be transferred
1094      * @param _data bytes optional data to send along with the call
1095      * @return bool whether the call correctly returned the expected magic value
1096      */
1097     function _checkOnERC721Received(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) private returns (bool) {
1103         if (to.isContract()) {
1104             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1105                 return retval == IERC721Receiver.onERC721Received.selector;
1106             } catch (bytes memory reason) {
1107                 if (reason.length == 0) {
1108                     revert("ERC721: transfer to non ERC721Receiver implementer");
1109                 } else {
1110                     assembly {
1111                         revert(add(32, reason), mload(reason))
1112                     }
1113                 }
1114             }
1115         } else {
1116             return true;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Hook that is called before any token transfer. This includes minting
1122      * and burning.
1123      *
1124      * Calling conditions:
1125      *
1126      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1127      * transferred to `to`.
1128      * - When `from` is zero, `tokenId` will be minted for `to`.
1129      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1130      * - `from` and `to` are never both zero.
1131      *
1132      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1133      */
1134     function _beforeTokenTransfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal virtual {}
1139 }
1140 
1141 
1142 pragma solidity 0.8.11; 
1143 
1144 contract OwnableDelegateProxy {}
1145 
1146 contract ProxyRegistry {
1147     mapping(address => OwnableDelegateProxy) public proxies;
1148 }
1149 
1150 contract bitGOONs is ERC721, Ownable {
1151   using Strings for uint256;
1152   using Counters for Counters.Counter;
1153 
1154   Counters.Counter private supply;
1155   
1156   string public PROVENANCE = "";
1157   string public uriPrefix = "";
1158   string public uriSuffix = ".json";
1159   string public hiddenMetadataUri = "";
1160   uint256 public cost = 0.05 ether;
1161   uint256 public maxSupply = 5000;
1162   uint256 public maxMintAmountPerTx = 5;
1163   uint256 public maxPresaleMintAmount = 10;
1164   bool public paused = true;
1165   bool public revealed = false;
1166   bool public presale = true; 
1167   mapping(address => bool) public whitelisted;
1168   address public proxyRegistryAddress;
1169   address public pwallet;
1170 
1171   constructor(string memory _name, string memory _symbol, address _initProxyAddress,string memory _hiddenMetadataUri, address _pwallet) ERC721(_name, _symbol) {
1172      hiddenMetadataUri=_hiddenMetadataUri;
1173      proxyRegistryAddress=_initProxyAddress;
1174      pwallet=_pwallet;
1175   }
1176 
1177   modifier mintCompliance(uint256 _mintAmount) {
1178     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1179     require(supply.current() + _mintAmount <= maxSupply, "MAX SUPPLY REACHED!");
1180     _;
1181   }
1182 
1183   function totalSupply() public view returns (uint256) {
1184     return supply.current();
1185   }
1186 
1187   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1188     require(!paused, "Contract is paused");
1189     require(msg.value >= cost * _mintAmount, "Insufficient Funds");
1190 
1191     if (presale) { 
1192         if ( !isInWhiteList(msg.sender))  {
1193             revert("You are not Whitelisted, Please wait for the Public Sale");
1194         }
1195         
1196         if ( balanceOf(msg.sender)+_mintAmount > maxPresaleMintAmount)
1197             revert("You have minted the max Whitelisted amount");
1198     } 
1199 
1200     _mintLoop(msg.sender, _mintAmount);
1201   }
1202   
1203   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1204     _mintLoop(_receiver, _mintAmount);
1205   }
1206 
1207   function walletOfOwner(address _owner)
1208     public
1209     view
1210     returns (uint256[] memory)
1211   {
1212     uint256 ownerTokenCount = balanceOf(_owner);
1213     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1214     uint256 currentTokenId = 1;
1215     uint256 ownedTokenIndex = 0;
1216 
1217     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1218       address currentTokenOwner = ownerOf(currentTokenId);
1219 
1220       if (currentTokenOwner == _owner) {
1221         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1222 
1223         ownedTokenIndex++;
1224       }
1225 
1226       currentTokenId++;
1227     }
1228 
1229     return ownedTokenIds;
1230   }
1231 
1232   function tokenURI(uint256 _tokenId)
1233     public
1234     view
1235     virtual
1236     override
1237     returns (string memory)
1238   {
1239     require(
1240       _exists(_tokenId),
1241       "ERC721Metadata: URI query for nonexistent token"
1242     );
1243 
1244     if (revealed == false) {
1245       return hiddenMetadataUri;
1246     }
1247 
1248     string memory currentBaseURI = _baseURI();
1249     return bytes(currentBaseURI).length > 0
1250         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1251         : "";
1252   }
1253 
1254   function setRevealed(bool _state) public onlyOwner {
1255     revealed = _state;
1256   }
1257 
1258   function setCost(uint256 _cost) public onlyOwner {
1259     cost = _cost;
1260   }
1261 
1262   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1263     maxMintAmountPerTx = _maxMintAmountPerTx;
1264   }
1265 
1266   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1267     hiddenMetadataUri = _hiddenMetadataUri;
1268   }
1269 
1270   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1271     uriPrefix = _uriPrefix;
1272   }
1273 
1274   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1275     uriSuffix = _uriSuffix;
1276   }
1277 
1278   function setPaused(bool _state) public onlyOwner {
1279     paused = _state;
1280   }
1281 
1282   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1283     for (uint256 i = 0; i < _mintAmount; i++) {
1284       supply.increment();
1285       _safeMint(_receiver, supply.current());
1286     }
1287   }
1288 
1289   function _baseURI() internal view virtual override returns (string memory) {
1290     return uriPrefix;
1291   }
1292 
1293   function setPresale(bool _state) public onlyOwner {
1294       presale = _state;
1295   }
1296 
1297   function setMaxPresaleMintAmount(uint256 _max) public onlyOwner {
1298       maxPresaleMintAmount = _max;
1299   }
1300 
1301   function addToWhiteList(address _addr) public onlyOwner {
1302       whitelisted[_addr] = true;
1303   }
1304 
1305   function addArrayToWhiteList(address[] memory _addrs) public onlyOwner {
1306       for (uint256 i=0;i< _addrs.length;i++)
1307           whitelisted[_addrs[i]] = true; 
1308   }
1309 
1310   function removeFromWhiteList(address _addr) public onlyOwner {
1311       whitelisted[_addr] = false;
1312   }
1313 
1314   function setAddress(uint addy, address _address) public onlyOwner() {
1315         require (addy<2,"Choose address 0 or 1");   
1316         if (addy==0){
1317             proxyRegistryAddress=_address;
1318         }
1319         if (addy==1){
1320             pwallet=_address;
1321         }
1322       }
1323 
1324   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1325         PROVENANCE = provenanceHash;
1326     }
1327 
1328   function isInWhiteList(address _addr) private view returns (bool) {
1329       return whitelisted[_addr]  || _addr == owner();
1330       
1331   }
1332 
1333   function withdraw() public onlyOwner {
1334     (bool ph, ) = payable(pwallet).call{value: address(this).balance * 50 / 100}("");
1335     require(ph);
1336     (bool bg, ) = payable(owner()).call{value: address(this).balance}("");
1337     require(bg);
1338   }
1339 
1340     function isApprovedForAll(address owner, address operator) override public view returns (bool)
1341     {
1342         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1343         if (address(proxyRegistry.proxies(owner)) == operator) {
1344             return true;
1345         }
1346         return super.isApprovedForAll(owner, operator);
1347     }
1348 }