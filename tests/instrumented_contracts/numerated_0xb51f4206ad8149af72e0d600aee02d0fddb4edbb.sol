1 // SPDX-License-Identifier: GPL-3.0
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Counters.sol
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
48 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Strings.sol
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
118 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Context.sol
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
145 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/access/Ownable.sol
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
223 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Address.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
227 
228 pragma solidity ^0.8.0;
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
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/IERC721Receiver.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @title ERC721 token receiver interface
452  * @dev Interface for any contract that wants to support safeTransfers
453  * from ERC721 asset contracts.
454  */
455 interface IERC721Receiver {
456     /**
457      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
458      * by `operator` from `from`, this function is called.
459      *
460      * It must return its Solidity selector to confirm the token transfer.
461      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
462      *
463      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
464      */
465     function onERC721Received(
466         address operator,
467         address from,
468         uint256 tokenId,
469         bytes calldata data
470     ) external returns (bytes4);
471 }
472 
473 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/introspection/IERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/introspection/ERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/IERC721.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Approve or remove `operator` as an operator for the caller.
639      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes calldata data
674     ) external;
675 }
676 
677 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/IERC721Enumerable.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Enumerable is IERC721 {
690     /**
691      * @dev Returns the total amount of tokens stored by the contract.
692      */
693     function totalSupply() external view returns (uint256);
694 
695     /**
696      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
697      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
698      */
699     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
700 
701     /**
702      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
703      * Use along with {totalSupply} to enumerate all tokens.
704      */
705     function tokenByIndex(uint256 index) external view returns (uint256);
706 }
707 
708 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/IERC721Metadata.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
718  * @dev See https://eips.ethereum.org/EIPS/eip-721
719  */
720 interface IERC721Metadata is IERC721 {
721     /**
722      * @dev Returns the token collection name.
723      */
724     function name() external view returns (string memory);
725 
726     /**
727      * @dev Returns the token collection symbol.
728      */
729     function symbol() external view returns (string memory);
730 
731     /**
732      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
733      */
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/ERC721.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 
746 
747 
748 
749 
750 
751 /**
752  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
753  * the Metadata extension, but not including the Enumerable extension, which is available separately as
754  * {ERC721Enumerable}.
755  */
756 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
757     using Address for address;
758     using Strings for uint256;
759 
760     // Token name
761     string private _name;
762 
763     // Token symbol
764     string private _symbol;
765 
766     // Mapping from token ID to owner address
767     mapping(uint256 => address) private _owners;
768 
769     // Mapping owner address to token count
770     mapping(address => uint256) private _balances;
771 
772     // Mapping from token ID to approved address
773     mapping(uint256 => address) private _tokenApprovals;
774 
775     // Mapping from owner to operator approvals
776     mapping(address => mapping(address => bool)) private _operatorApprovals;
777 
778     /**
779      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
780      */
781     constructor(string memory name_, string memory symbol_) {
782         _name = name_;
783         _symbol = symbol_;
784     }
785 
786     /**
787      * @dev See {IERC165-supportsInterface}.
788      */
789     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
790         return
791             interfaceId == type(IERC721).interfaceId ||
792             interfaceId == type(IERC721Metadata).interfaceId ||
793             super.supportsInterface(interfaceId);
794     }
795 
796     /**
797      * @dev See {IERC721-balanceOf}.
798      */
799     function balanceOf(address owner) public view virtual override returns (uint256) {
800         require(owner != address(0), "ERC721: balance query for the zero address");
801         return _balances[owner];
802     }
803 
804     /**
805      * @dev See {IERC721-ownerOf}.
806      */
807     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
808         address owner = _owners[tokenId];
809         require(owner != address(0), "ERC721: owner query for nonexistent token");
810         return owner;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-name}.
815      */
816     function name() public view virtual override returns (string memory) {
817         return _name;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-symbol}.
822      */
823     function symbol() public view virtual override returns (string memory) {
824         return _symbol;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-tokenURI}.
829      */
830     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
831         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
832 
833         string memory baseURI = _baseURI();
834         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
835     }
836 
837     /**
838      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840      * by default, can be overriden in child contracts.
841      */
842     function _baseURI() internal view virtual returns (string memory) {
843         return "";
844     }
845 
846     /**
847      * @dev See {IERC721-approve}.
848      */
849     function approve(address to, uint256 tokenId) public virtual override {
850         address owner = ERC721.ownerOf(tokenId);
851         require(to != owner, "ERC721: approval to current owner");
852 
853         require(
854             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
855             "ERC721: approve caller is not owner nor approved for all"
856         );
857 
858         _approve(to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-getApproved}.
863      */
864     function getApproved(uint256 tokenId) public view virtual override returns (address) {
865         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
866 
867         return _tokenApprovals[tokenId];
868     }
869 
870     /**
871      * @dev See {IERC721-setApprovalForAll}.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         _setApprovalForAll(_msgSender(), operator, approved);
875     }
876 
877     /**
878      * @dev See {IERC721-isApprovedForAll}.
879      */
880     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
881         return _operatorApprovals[owner][operator];
882     }
883 
884     /**
885      * @dev See {IERC721-transferFrom}.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         //solhint-disable-next-line max-line-length
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
894 
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, "");
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public virtual override {
918         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
919         _safeTransfer(from, to, tokenId, _data);
920     }
921 
922     /**
923      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
924      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
925      *
926      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
927      *
928      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
929      * implement alternative mechanisms to perform token transfer, such as signature-based.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeTransfer(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) internal virtual {
946         _transfer(from, to, tokenId);
947         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
948     }
949 
950     /**
951      * @dev Returns whether `tokenId` exists.
952      *
953      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
954      *
955      * Tokens start existing when they are minted (`_mint`),
956      * and stop existing when they are burned (`_burn`).
957      */
958     function _exists(uint256 tokenId) internal view virtual returns (bool) {
959         return _owners[tokenId] != address(0);
960     }
961 
962     /**
963      * @dev Returns whether `spender` is allowed to manage `tokenId`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must exist.
968      */
969     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
970         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
971         address owner = ERC721.ownerOf(tokenId);
972         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
973     }
974 
975     /**
976      * @dev Safely mints `tokenId` and transfers it to `to`.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must not exist.
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(address to, uint256 tokenId) internal virtual {
986         _safeMint(to, tokenId, "");
987     }
988 
989     /**
990      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
991      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
992      */
993     function _safeMint(
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) internal virtual {
998         _mint(to, tokenId);
999         require(
1000             _checkOnERC721Received(address(0), to, tokenId, _data),
1001             "ERC721: transfer to non ERC721Receiver implementer"
1002         );
1003     }
1004 
1005     /**
1006      * @dev Mints `tokenId` and transfers it to `to`.
1007      *
1008      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must not exist.
1013      * - `to` cannot be the zero address.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _mint(address to, uint256 tokenId) internal virtual {
1018         require(to != address(0), "ERC721: mint to the zero address");
1019         require(!_exists(tokenId), "ERC721: token already minted");
1020 
1021         _beforeTokenTransfer(address(0), to, tokenId);
1022 
1023         _balances[to] += 1;
1024         _owners[tokenId] = to;
1025 
1026         emit Transfer(address(0), to, tokenId);
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
1051     }
1052 
1053     /**
1054      * @dev Transfers `tokenId` from `from` to `to`.
1055      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1056      *
1057      * Requirements:
1058      *
1059      * - `to` cannot be the zero address.
1060      * - `tokenId` token must be owned by `from`.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual {
1069         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1070         require(to != address(0), "ERC721: transfer to the zero address");
1071 
1072         _beforeTokenTransfer(from, to, tokenId);
1073 
1074         // Clear approvals from the previous owner
1075         _approve(address(0), tokenId);
1076 
1077         _balances[from] -= 1;
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(from, to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev Approve `to` to operate on `tokenId`
1086      *
1087      * Emits a {Approval} event.
1088      */
1089     function _approve(address to, uint256 tokenId) internal virtual {
1090         _tokenApprovals[tokenId] = to;
1091         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev Approve `operator` to operate on all of `owner` tokens
1096      *
1097      * Emits a {ApprovalForAll} event.
1098      */
1099     function _setApprovalForAll(
1100         address owner,
1101         address operator,
1102         bool approved
1103     ) internal virtual {
1104         require(owner != operator, "ERC721: approve to caller");
1105         _operatorApprovals[owner][operator] = approved;
1106         emit ApprovalForAll(owner, operator, approved);
1107     }
1108 
1109     /**
1110      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1111      * The call is not executed if the target address is not a contract.
1112      *
1113      * @param from address representing the previous owner of the given token ID
1114      * @param to target address that will receive the tokens
1115      * @param tokenId uint256 ID of the token to be transferred
1116      * @param _data bytes optional data to send along with the call
1117      * @return bool whether the call correctly returned the expected magic value
1118      */
1119     function _checkOnERC721Received(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) private returns (bool) {
1125         if (to.isContract()) {
1126             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1127                 return retval == IERC721Receiver.onERC721Received.selector;
1128             } catch (bytes memory reason) {
1129                 if (reason.length == 0) {
1130                     revert("ERC721: transfer to non ERC721Receiver implementer");
1131                 } else {
1132                     assembly {
1133                         revert(add(32, reason), mload(reason))
1134                     }
1135                 }
1136             }
1137         } else {
1138             return true;
1139         }
1140     }
1141 
1142     /**
1143      * @dev Hook that is called before any token transfer. This includes minting
1144      * and burning.
1145      *
1146      * Calling conditions:
1147      *
1148      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1149      * transferred to `to`.
1150      * - When `from` is zero, `tokenId` will be minted for `to`.
1151      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1152      * - `from` and `to` are never both zero.
1153      *
1154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1155      */
1156     function _beforeTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {}
1161 }
1162 
1163 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1164 
1165 
1166 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 
1172 /**
1173  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1174  * enumerability of all the token ids in the contract as well as all token ids owned by each
1175  * account.
1176  */
1177 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1178     // Mapping from owner to list of owned token IDs
1179     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1180 
1181     // Mapping from token ID to index of the owner tokens list
1182     mapping(uint256 => uint256) private _ownedTokensIndex;
1183 
1184     // Array with all token ids, used for enumeration
1185     uint256[] private _allTokens;
1186 
1187     // Mapping from token id to position in the allTokens array
1188     mapping(uint256 => uint256) private _allTokensIndex;
1189 
1190     /**
1191      * @dev See {IERC165-supportsInterface}.
1192      */
1193     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1194         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1199      */
1200     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1201         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1202         return _ownedTokens[owner][index];
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-totalSupply}.
1207      */
1208     function totalSupply() public view virtual override returns (uint256) {
1209         return _allTokens.length;
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Enumerable-tokenByIndex}.
1214      */
1215     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1216         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1217         return _allTokens[index];
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before any token transfer. This includes minting
1222      * and burning.
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1230      * - `from` cannot be the zero address.
1231      * - `to` cannot be the zero address.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _beforeTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual override {
1240         super._beforeTokenTransfer(from, to, tokenId);
1241 
1242         if (from == address(0)) {
1243             _addTokenToAllTokensEnumeration(tokenId);
1244         } else if (from != to) {
1245             _removeTokenFromOwnerEnumeration(from, tokenId);
1246         }
1247         if (to == address(0)) {
1248             _removeTokenFromAllTokensEnumeration(tokenId);
1249         } else if (to != from) {
1250             _addTokenToOwnerEnumeration(to, tokenId);
1251         }
1252     }
1253 
1254     /**
1255      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1256      * @param to address representing the new owner of the given token ID
1257      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1258      */
1259     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1260         uint256 length = ERC721.balanceOf(to);
1261         _ownedTokens[to][length] = tokenId;
1262         _ownedTokensIndex[tokenId] = length;
1263     }
1264 
1265     /**
1266      * @dev Private function to add a token to this extension's token tracking data structures.
1267      * @param tokenId uint256 ID of the token to be added to the tokens list
1268      */
1269     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1270         _allTokensIndex[tokenId] = _allTokens.length;
1271         _allTokens.push(tokenId);
1272     }
1273 
1274     /**
1275      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1276      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1277      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1278      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1279      * @param from address representing the previous owner of the given token ID
1280      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1281      */
1282     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1283         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1284         // then delete the last slot (swap and pop).
1285 
1286         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1287         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1288 
1289         // When the token to delete is the last token, the swap operation is unnecessary
1290         if (tokenIndex != lastTokenIndex) {
1291             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1292 
1293             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1294             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1295         }
1296 
1297         // This also deletes the contents at the last position of the array
1298         delete _ownedTokensIndex[tokenId];
1299         delete _ownedTokens[from][lastTokenIndex];
1300     }
1301 
1302     /**
1303      * @dev Private function to remove a token from this extension's token tracking data structures.
1304      * This has O(1) time complexity, but alters the order of the _allTokens array.
1305      * @param tokenId uint256 ID of the token to be removed from the tokens list
1306      */
1307     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1308         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1309         // then delete the last slot (swap and pop).
1310 
1311         uint256 lastTokenIndex = _allTokens.length - 1;
1312         uint256 tokenIndex = _allTokensIndex[tokenId];
1313 
1314         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1315         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1316         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1317         uint256 lastTokenId = _allTokens[lastTokenIndex];
1318 
1319         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1320         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1321 
1322         // This also deletes the contents at the last position of the array
1323         delete _allTokensIndex[tokenId];
1324         _allTokens.pop();
1325     }
1326 }
1327 
1328 // File: contracts/Danny.sol
1329 
1330 
1331 
1332 pragma solidity >=0.7.0 <0.9.0;
1333 
1334 
1335 
1336 
1337 contract DannyDao is ERC721Enumerable, Ownable {
1338 
1339   using Strings for uint256;
1340   using Counters for Counters.Counter;
1341   Counters.Counter private _tokenIds;
1342 
1343   uint256 private constant maxDanny = 1001;
1344 
1345   string public baseURI;
1346   string public baseExtension = ".json";
1347   bool public paused = true;
1348 
1349   constructor (
1350       string memory _name ,
1351       string memory _symbol ,
1352       string memory _initBaseURI
1353   ) ERC721(_name, _symbol) {
1354     setBaseURI(_initBaseURI);  
1355     }
1356 
1357     function _baseURI() internal view virtual override returns (string memory) {
1358         return baseURI;
1359   }
1360 
1361     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1362     baseURI = _newBaseURI;
1363   }
1364 
1365   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1366     baseExtension = _newBaseExtension;
1367   }
1368 
1369     function MintDanny(uint256 _mintAmount) external payable {
1370         require(!paused , 'Danny isnt ready for you yet');
1371         require(_mintAmount != 0 , '0 Dannys isnt possible silly');
1372         require(_mintAmount <= 3, 'Too many Dannys');
1373         require(_tokenIds.current() + _mintAmount <= maxDanny , 'Not Enough Dannys left, go to OpenSea');
1374         for (uint256 i = 0; i < _mintAmount; i++) {
1375             _tokenIds.increment();
1376             mint(_tokenIds.current());
1377         }
1378     }
1379     
1380     function mint(uint256 tokenId ) internal {
1381         _safeMint(msg.sender , tokenId);
1382     }
1383 
1384     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1385     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1386     return string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension));
1387   }
1388 
1389   function pause(bool _state) public onlyOwner {
1390     paused = _state;
1391   }
1392 
1393   function withdraw() public onlyOwner {
1394         uint256 balance = address(this).balance;
1395         payable(msg.sender).transfer(balance);
1396     }
1397 
1398 }