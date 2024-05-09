1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 /**
9 
10 
11 :::    ::: :::    ::: :::::::::: :::::::::  :::    :::  ::::::::  :::::::::  :::::::::::     :::          
12 :+:    :+: :+:    :+: :+:        :+:    :+: :+:    :+: :+:    :+: :+:    :+:     :+:       :+: :+:        
13 +:+    +:+ +:+    +:+ +:+        +:+    +:+ +:+    +:+ +:+    +:+ +:+    +:+     +:+      +:+   +:+       
14 +#++:++#++ +#+    +:+ +#++:++#   +#++:++#+  +#++:++#++ +#+    +:+ +#++:++#:      +#+     +#++:++#++:      
15 +#+    +#+ +#+    +#+ +#+        +#+        +#+    +#+ +#+    +#+ +#+    +#+     +#+     +#+     +#+      
16 #+#    #+# #+#    #+# #+#        #+#        #+#    #+# #+#    #+# #+#    #+#     #+#     #+#     #+#      
17 ###    ###  ########  ########## ###        ###    ###  ########  ###    ### ########### ###     ###      
18 
19 
20 */    
21 
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
729 
730 
731 
732 
733 
734 
735 
736 /**
737  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
738  * the Metadata extension, but not including the Enumerable extension, which is available separately as
739  * {ERC721Enumerable}.
740  */
741 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
742     using Address for address;
743     using Strings for uint256;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
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
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overriden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return "";
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public virtual override {
835         address owner = ERC721.ownerOf(tokenId);
836         require(to != owner, "ERC721: approval to current owner");
837 
838         require(
839             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
840             "ERC721: approve caller is not owner nor approved for all"
841         );
842 
843         _approve(to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-getApproved}.
848      */
849     function getApproved(uint256 tokenId) public view virtual override returns (address) {
850         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
851 
852         return _tokenApprovals[tokenId];
853     }
854 
855     /**
856      * @dev See {IERC721-setApprovalForAll}.
857      */
858     function setApprovalForAll(address operator, bool approved) public virtual override {
859         _setApprovalForAll(_msgSender(), operator, approved);
860     }
861 
862     /**
863      * @dev See {IERC721-isApprovedForAll}.
864      */
865     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
866         return _operatorApprovals[owner][operator];
867     }
868 
869     /**
870      * @dev See {IERC721-transferFrom}.
871      */
872     function transferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public virtual override {
877         //solhint-disable-next-line max-line-length
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
879 
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, "");
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) public virtual override {
903         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
904         _safeTransfer(from, to, tokenId, _data);
905     }
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
909      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
910      *
911      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
912      *
913      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
914      * implement alternative mechanisms to perform token transfer, such as signature-based.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must exist and be owned by `from`.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeTransfer(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) internal virtual {
931         _transfer(from, to, tokenId);
932         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
933     }
934 
935     /**
936      * @dev Returns whether `tokenId` exists.
937      *
938      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
939      *
940      * Tokens start existing when they are minted (`_mint`),
941      * and stop existing when they are burned (`_burn`).
942      */
943     function _exists(uint256 tokenId) internal view virtual returns (bool) {
944         return _owners[tokenId] != address(0);
945     }
946 
947     /**
948      * @dev Returns whether `spender` is allowed to manage `tokenId`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
955         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
956         address owner = ERC721.ownerOf(tokenId);
957         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
958     }
959 
960     /**
961      * @dev Safely mints `tokenId` and transfers it to `to`.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must not exist.
966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _safeMint(address to, uint256 tokenId) internal virtual {
971         _safeMint(to, tokenId, "");
972     }
973 
974     /**
975      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
976      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
977      */
978     function _safeMint(
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) internal virtual {
983         _mint(to, tokenId);
984         require(
985             _checkOnERC721Received(address(0), to, tokenId, _data),
986             "ERC721: transfer to non ERC721Receiver implementer"
987         );
988     }
989 
990     /**
991      * @dev Mints `tokenId` and transfers it to `to`.
992      *
993      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
994      *
995      * Requirements:
996      *
997      * - `tokenId` must not exist.
998      * - `to` cannot be the zero address.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _mint(address to, uint256 tokenId) internal virtual {
1003         require(to != address(0), "ERC721: mint to the zero address");
1004         require(!_exists(tokenId), "ERC721: token already minted");
1005 
1006         _beforeTokenTransfer(address(0), to, tokenId);
1007 
1008         _balances[to] += 1;
1009         _owners[tokenId] = to;
1010 
1011         emit Transfer(address(0), to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev Destroys `tokenId`.
1016      * The approval is cleared when the token is burned.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _burn(uint256 tokenId) internal virtual {
1025         address owner = ERC721.ownerOf(tokenId);
1026 
1027         _beforeTokenTransfer(owner, address(0), tokenId);
1028 
1029         // Clear approvals
1030         _approve(address(0), tokenId);
1031 
1032         _balances[owner] -= 1;
1033         delete _owners[tokenId];
1034 
1035         emit Transfer(owner, address(0), tokenId);
1036     }
1037 
1038     /**
1039      * @dev Transfers `tokenId` from `from` to `to`.
1040      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1041      *
1042      * Requirements:
1043      *
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must be owned by `from`.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual {
1054         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1055         require(to != address(0), "ERC721: transfer to the zero address");
1056 
1057         _beforeTokenTransfer(from, to, tokenId);
1058 
1059         // Clear approvals from the previous owner
1060         _approve(address(0), tokenId);
1061 
1062         _balances[from] -= 1;
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Approve `to` to operate on `tokenId`
1071      *
1072      * Emits a {Approval} event.
1073      */
1074     function _approve(address to, uint256 tokenId) internal virtual {
1075         _tokenApprovals[tokenId] = to;
1076         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `operator` to operate on all of `owner` tokens
1081      *
1082      * Emits a {ApprovalForAll} event.
1083      */
1084     function _setApprovalForAll(
1085         address owner,
1086         address operator,
1087         bool approved
1088     ) internal virtual {
1089         require(owner != operator, "ERC721: approve to caller");
1090         _operatorApprovals[owner][operator] = approved;
1091         emit ApprovalForAll(owner, operator, approved);
1092     }
1093 
1094     /**
1095      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1096      * The call is not executed if the target address is not a contract.
1097      *
1098      * @param from address representing the previous owner of the given token ID
1099      * @param to target address that will receive the tokens
1100      * @param tokenId uint256 ID of the token to be transferred
1101      * @param _data bytes optional data to send along with the call
1102      * @return bool whether the call correctly returned the expected magic value
1103      */
1104     function _checkOnERC721Received(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) private returns (bool) {
1110         if (to.isContract()) {
1111             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1112                 return retval == IERC721Receiver.onERC721Received.selector;
1113             } catch (bytes memory reason) {
1114                 if (reason.length == 0) {
1115                     revert("ERC721: transfer to non ERC721Receiver implementer");
1116                 } else {
1117                     assembly {
1118                         revert(add(32, reason), mload(reason))
1119                     }
1120                 }
1121             }
1122         } else {
1123             return true;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any token transfer. This includes minting
1129      * and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1134      * transferred to `to`.
1135      * - When `from` is zero, `tokenId` will be minted for `to`.
1136      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1137      * - `from` and `to` are never both zero.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual {}
1146 }
1147 
1148 // File: contracts/HUEPHORIA.sol
1149 
1150 
1151 
1152 // 
1153 /**
1154     
1155 
1156 
1157 :::    ::: :::    ::: :::::::::: :::::::::  :::    :::  ::::::::  :::::::::  :::::::::::     :::          
1158 :+:    :+: :+:    :+: :+:        :+:    :+: :+:    :+: :+:    :+: :+:    :+:     :+:       :+: :+:        
1159 +:+    +:+ +:+    +:+ +:+        +:+    +:+ +:+    +:+ +:+    +:+ +:+    +:+     +:+      +:+   +:+       
1160 +#++:++#++ +#+    +:+ +#++:++#   +#++:++#+  +#++:++#++ +#+    +:+ +#++:++#:      +#+     +#++:++#++:      
1161 +#+    +#+ +#+    +#+ +#+        +#+        +#+    +#+ +#+    +#+ +#+    +#+     +#+     +#+     +#+      
1162 #+#    #+# #+#    #+# #+#        #+#        #+#    #+# #+#    #+# #+#    #+#     #+#     #+#     #+#      
1163 ###    ###  ########  ########## ###        ###    ###  ########  ###    ### ########### ###     ###      
1164 
1165 
1166     
1167 */
1168 
1169 pragma solidity >=0.7.0 <0.9.0;
1170 
1171 
1172 
1173 
1174 contract HUEPHORIA is ERC721, Ownable {
1175   using Strings for uint256;
1176   using Counters for Counters.Counter;
1177 
1178   Counters.Counter private supply;
1179 
1180   string public uriPrefix = "";
1181   string public uriSuffix = ".json";
1182   string public hiddenMetadataUri;
1183   
1184   uint256 public cost = 0.045 ether;
1185   uint256 public maxSupply = 777;
1186   uint256 public maxMintAmountPerTx = 7;
1187 
1188   bool public paused = true;
1189   bool public revealed = false;
1190 
1191   constructor() ERC721("HUEPHORIA", "HUE") {
1192     setHiddenMetadataUri("ipfs://QmaFc1kqwspa5cRWMWZzjMb4UDHUUvQ76n4mqFSrohZaP6/hidden.json");
1193   }
1194 
1195   modifier mintCompliance(uint256 _mintAmount) {
1196     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1197     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1198     _;
1199   }
1200 
1201   function totalSupply() public view returns (uint256) {
1202     return supply.current();
1203   }
1204 
1205   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1206     require(!paused, "The contract is paused!");
1207     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1208 
1209     _mintLoop(msg.sender, _mintAmount);
1210   }
1211   
1212   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1213     _mintLoop(_receiver, _mintAmount);
1214   }
1215 
1216   function walletOfOwner(address _owner)
1217     public
1218     view
1219     returns (uint256[] memory)
1220   {
1221     uint256 ownerTokenCount = balanceOf(_owner);
1222     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1223     uint256 currentTokenId = 1;
1224     uint256 ownedTokenIndex = 0;
1225 
1226     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1227       address currentTokenOwner = ownerOf(currentTokenId);
1228 
1229       if (currentTokenOwner == _owner) {
1230         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1231 
1232         ownedTokenIndex++;
1233       }
1234 
1235       currentTokenId++;
1236     }
1237 
1238     return ownedTokenIds;
1239   }
1240 
1241   function tokenURI(uint256 _tokenId)
1242     public
1243     view
1244     virtual
1245     override
1246     returns (string memory)
1247   {
1248     require(
1249       _exists(_tokenId),
1250       "ERC721Metadata: URI query for nonexistent token"
1251     );
1252 
1253     if (revealed == false) {
1254       return hiddenMetadataUri;
1255     }
1256 
1257     string memory currentBaseURI = _baseURI();
1258     return bytes(currentBaseURI).length > 0
1259         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1260         : "";
1261   }
1262 
1263   function setRevealed(bool _state) public onlyOwner {
1264     revealed = _state;
1265   }
1266 
1267   function setCost(uint256 _cost) public onlyOwner {
1268     cost = _cost;
1269   }
1270 
1271   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1272     maxMintAmountPerTx = _maxMintAmountPerTx;
1273   }
1274 
1275   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1276     hiddenMetadataUri = _hiddenMetadataUri;
1277   }
1278 
1279   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1280     uriPrefix = _uriPrefix;
1281   }
1282 
1283   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1284     uriSuffix = _uriSuffix;
1285   }
1286 
1287   function setPaused(bool _state) public onlyOwner {
1288     paused = _state;
1289   }
1290 
1291   function withdraw() public onlyOwner {
1292     
1293     // This will transfer the remaining contract balance to the owner.
1294     // Do not remove this otherwise you will not be able to withdraw the funds.
1295     // =============================================================================
1296     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1297     require(os);
1298     // =============================================================================
1299   }
1300 
1301   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1302     for (uint256 i = 0; i < _mintAmount; i++) {
1303       supply.increment();
1304       _safeMint(_receiver, supply.current());
1305     }
1306   }
1307 
1308   function _baseURI() internal view virtual override returns (string memory) {
1309     return uriPrefix;
1310   }
1311 }