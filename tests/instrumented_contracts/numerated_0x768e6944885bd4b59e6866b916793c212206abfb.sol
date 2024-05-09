1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 // File: @openzeppelin/contracts/utils/Counters.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @title Counters
14  * @author Matt Condon (@shrugs)
15  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
16  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
17  *
18  * Include with `using Counters for Counters.Counter;`
19  */
20 library Counters {
21     struct Counter {
22         // This variable should never be directly accessed by users of the library: interactions must be restricted to
23         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
24         // this feature: see https://github.com/ethereum/solidity/issues/4637
25         uint256 _value; // default: 0
26     }
27 
28     function current(Counter storage counter) internal view returns (uint256) {
29         return counter._value;
30     }
31 
32     function increment(Counter storage counter) internal {
33         unchecked {
34             counter._value += 1;
35         }
36     }
37 
38     function decrement(Counter storage counter) internal {
39         uint256 value = counter._value;
40         require(value > 0, "Counter: decrement overflow");
41         unchecked {
42             counter._value = value - 1;
43         }
44     }
45 
46     function reset(Counter storage counter) internal {
47         counter._value = 0;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/utils/Strings.sol
52 
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
66      */
67     function toString(uint256 value) internal pure returns (string memory) {
68         // Inspired by OraclizeAPI's implementation - MIT licence
69         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
70 
71         if (value == 0) {
72             return "0";
73         }
74         uint256 temp = value;
75         uint256 digits;
76         while (temp != 0) {
77             digits++;
78             temp /= 10;
79         }
80         bytes memory buffer = new bytes(digits);
81         while (value != 0) {
82             digits -= 1;
83             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
84             value /= 10;
85         }
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
91      */
92     function toHexString(uint256 value) internal pure returns (string memory) {
93         if (value == 0) {
94             return "0x00";
95         }
96         uint256 temp = value;
97         uint256 length = 0;
98         while (temp != 0) {
99             length++;
100             temp >>= 8;
101         }
102         return toHexString(value, length);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
107      */
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 // File: @openzeppelin/contracts/utils/Context.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts/access/Ownable.sol
149 
150 
151 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 /**
157  * @dev Contract module which provides a basic access control mechanism, where
158  * there is an account (an owner) that can be granted exclusive access to
159  * specific functions.
160  *
161  * By default, the owner account will be the one that deploys the contract. This
162  * can later be changed with {transferOwnership}.
163  *
164  * This module is used through inheritance. It will make available the modifier
165  * `onlyOwner`, which can be applied to your functions to restrict their use to
166  * the owner.
167  */
168 abstract contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     /**
174      * @dev Initializes the contract setting the deployer as the initial owner.
175      */
176     constructor() {
177         _transferOwnership(_msgSender());
178     }
179 
180     /**
181      * @dev Returns the address of the current owner.
182      */
183     function owner() public view virtual returns (address) {
184         return _owner;
185     }
186 
187     /**
188      * @dev Throws if called by any account other than the owner.
189      */
190     modifier onlyOwner() {
191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
192         _;
193     }
194 
195     /**
196      * @dev Leaves the contract without owner. It will not be possible to call
197      * `onlyOwner` functions anymore. Can only be called by the current owner.
198      *
199      * NOTE: Renouncing ownership will leave the contract without an owner,
200      * thereby removing any functionality that is only available to the owner.
201      */
202     function renounceOwnership() public virtual onlyOwner {
203         _transferOwnership(address(0));
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Can only be called by the current owner.
209      */
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         _transferOwnership(newOwner);
213     }
214 
215     /**
216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
217      * Internal function without access restriction.
218      */
219     function _transferOwnership(address newOwner) internal virtual {
220         address oldOwner = _owner;
221         _owner = newOwner;
222         emit OwnershipTransferred(oldOwner, newOwner);
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Address.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize, which returns 0 for contracts in
256         // construction, since the code is only stored at the end of the
257         // constructor execution.
258 
259         uint256 size;
260         assembly {
261             size := extcodesize(account)
262         }
263         return size > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain `call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.delegatecall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
419      * revert reason using the provided one.
420      *
421      * _Available since v4.3._
422      */
423     function verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) internal pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @title ERC721 token receiver interface
455  * @dev Interface for any contract that wants to support safeTransfers
456  * from ERC721 asset contracts.
457  */
458 interface IERC721Receiver {
459     /**
460      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
461      * by `operator` from `from`, this function is called.
462      *
463      * It must return its Solidity selector to confirm the token transfer.
464      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
465      *
466      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
467      */
468     function onERC721Received(
469         address operator,
470         address from,
471         uint256 tokenId,
472         bytes calldata data
473     ) external returns (bytes4);
474 }
475 
476 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Interface of the ERC165 standard, as defined in the
485  * https://eips.ethereum.org/EIPS/eip-165[EIP].
486  *
487  * Implementers can declare support of contract interfaces, which can then be
488  * queried by others ({ERC165Checker}).
489  *
490  * For an implementation, see {ERC165}.
491  */
492 interface IERC165 {
493     /**
494      * @dev Returns true if this contract implements the interface defined by
495      * `interfaceId`. See the corresponding
496      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
497      * to learn more about how these ids are created.
498      *
499      * This function call must use less than 30 000 gas.
500      */
501     function supportsInterface(bytes4 interfaceId) external view returns (bool);
502 }
503 
504 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Required interface of an ERC721 compliant contract.
545  */
546 interface IERC721 is IERC165 {
547     /**
548      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
549      */
550     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
551 
552     /**
553      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
554      */
555     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
559      */
560     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
561 
562     /**
563      * @dev Returns the number of tokens in ``owner``'s account.
564      */
565     function balanceOf(address owner) external view returns (uint256 balance);
566 
567     /**
568      * @dev Returns the owner of the `tokenId` token.
569      *
570      * Requirements:
571      *
572      * - `tokenId` must exist.
573      */
574     function ownerOf(uint256 tokenId) external view returns (address owner);
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Approve or remove `operator` as an operator for the caller.
642      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId,
676         bytes calldata data
677     ) external;
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
690  * @dev See https://eips.ethereum.org/EIPS/eip-721
691  */
692 interface IERC721Metadata is IERC721 {
693     /**
694      * @dev Returns the token collection name.
695      */
696     function name() external view returns (string memory);
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() external view returns (string memory);
702 
703     /**
704      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
705      */
706     function tokenURI(uint256 tokenId) external view returns (string memory);
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 
718 
719 
720 
721 
722 
723 /**
724  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
725  * the Metadata extension, but not including the Enumerable extension, which is available separately as
726  * {ERC721Enumerable}.
727  */
728 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
729     using Address for address;
730     using Strings for uint256;
731 
732     // Token name
733     string private _name;
734 
735     // Token symbol
736     string private _symbol;
737 
738     // Mapping from token ID to owner address
739     mapping(uint256 => address) private _owners;
740 
741     // Mapping owner address to token count
742     mapping(address => uint256) private _balances;
743 
744     // Mapping from token ID to approved address
745     mapping(uint256 => address) private _tokenApprovals;
746 
747     // Mapping from owner to operator approvals
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     /**
751      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
752      */
753     constructor(string memory name_, string memory symbol_) {
754         _name = name_;
755         _symbol = symbol_;
756     }
757 
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
762         return
763             interfaceId == type(IERC721).interfaceId ||
764             interfaceId == type(IERC721Metadata).interfaceId ||
765             super.supportsInterface(interfaceId);
766     }
767 
768     /**
769      * @dev See {IERC721-balanceOf}.
770      */
771     function balanceOf(address owner) public view virtual override returns (uint256) {
772         require(owner != address(0), "ERC721: balance query for the zero address");
773         return _balances[owner];
774     }
775 
776     /**
777      * @dev See {IERC721-ownerOf}.
778      */
779     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
780         address owner = _owners[tokenId];
781         require(owner != address(0), "ERC721: owner query for nonexistent token");
782         return owner;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-name}.
787      */
788     function name() public view virtual override returns (string memory) {
789         return _name;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-symbol}.
794      */
795     function symbol() public view virtual override returns (string memory) {
796         return _symbol;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-tokenURI}.
801      */
802     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
803         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
804 
805         string memory baseURI = _baseURI();
806         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
807     }
808 
809     /**
810      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
811      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
812      * by default, can be overriden in child contracts.
813      */
814     function _baseURI() internal view virtual returns (string memory) {
815         return "";
816     }
817 
818     /**
819      * @dev See {IERC721-approve}.
820      */
821     function approve(address to, uint256 tokenId) public virtual override {
822         address owner = ERC721.ownerOf(tokenId);
823         require(to != owner, "ERC721: approval to current owner");
824 
825         require(
826             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
827             "ERC721: approve caller is not owner nor approved for all"
828         );
829 
830         _approve(to, tokenId);
831     }
832 
833     /**
834      * @dev See {IERC721-getApproved}.
835      */
836     function getApproved(uint256 tokenId) public view virtual override returns (address) {
837         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
838 
839         return _tokenApprovals[tokenId];
840     }
841 
842     /**
843      * @dev See {IERC721-setApprovalForAll}.
844      */
845     function setApprovalForAll(address operator, bool approved) public virtual override {
846         _setApprovalForAll(_msgSender(), operator, approved);
847     }
848 
849     /**
850      * @dev See {IERC721-isApprovedForAll}.
851      */
852     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
853         return _operatorApprovals[owner][operator];
854     }
855 
856     /**
857      * @dev See {IERC721-transferFrom}.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         //solhint-disable-next-line max-line-length
865         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
866 
867         _transfer(from, to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         safeTransferFrom(from, to, tokenId, "");
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public virtual override {
890         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
891         _safeTransfer(from, to, tokenId, _data);
892     }
893 
894     /**
895      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
896      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
897      *
898      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
899      *
900      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
901      * implement alternative mechanisms to perform token transfer, such as signature-based.
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must exist and be owned by `from`.
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _safeTransfer(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) internal virtual {
918         _transfer(from, to, tokenId);
919         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      * and stop existing when they are burned (`_burn`).
929      */
930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
931         return _owners[tokenId] != address(0);
932     }
933 
934     /**
935      * @dev Returns whether `spender` is allowed to manage `tokenId`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must exist.
940      */
941     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
942         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) internal virtual {
970         _mint(to, tokenId);
971         require(
972             _checkOnERC721Received(address(0), to, tokenId, _data),
973             "ERC721: transfer to non ERC721Receiver implementer"
974         );
975     }
976 
977     /**
978      * @dev Mints `tokenId` and transfers it to `to`.
979      *
980      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - `to` cannot be the zero address.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 tokenId) internal virtual {
990         require(to != address(0), "ERC721: mint to the zero address");
991         require(!_exists(tokenId), "ERC721: token already minted");
992 
993         _beforeTokenTransfer(address(0), to, tokenId);
994 
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(address(0), to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Destroys `tokenId`.
1003      * The approval is cleared when the token is burned.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _burn(uint256 tokenId) internal virtual {
1012         address owner = ERC721.ownerOf(tokenId);
1013 
1014         _beforeTokenTransfer(owner, address(0), tokenId);
1015 
1016         // Clear approvals
1017         _approve(address(0), tokenId);
1018 
1019         _balances[owner] -= 1;
1020         delete _owners[tokenId];
1021 
1022         emit Transfer(owner, address(0), tokenId);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {
1041         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1042         require(to != address(0), "ERC721: transfer to the zero address");
1043 
1044         _beforeTokenTransfer(from, to, tokenId);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId);
1048 
1049         _balances[from] -= 1;
1050         _balances[to] += 1;
1051         _owners[tokenId] = to;
1052 
1053         emit Transfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(address to, uint256 tokenId) internal virtual {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `operator` to operate on all of `owner` tokens
1068      *
1069      * Emits a {ApprovalForAll} event.
1070      */
1071     function _setApprovalForAll(
1072         address owner,
1073         address operator,
1074         bool approved
1075     ) internal virtual {
1076         require(owner != operator, "ERC721: approve to caller");
1077         _operatorApprovals[owner][operator] = approved;
1078         emit ApprovalForAll(owner, operator, approved);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1099                 return retval == IERC721Receiver.onERC721Received.selector;
1100             } catch (bytes memory reason) {
1101                 if (reason.length == 0) {
1102                     revert("ERC721: transfer to non ERC721Receiver implementer");
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before any token transfer. This includes minting
1116      * and burning.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1124      * - `from` and `to` are never both zero.
1125      *
1126      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {}
1133 }
1134 
1135 // File: contracts/DoodFellaz.sol
1136 
1137 
1138 
1139 // Amended by HashLips
1140 /**
1141     !Disclaimer!
1142     These contracts have been used to create tutorials,
1143     and was created for the purpose to teach people
1144     how to create smart contracts on the blockchain.
1145     please review this code on your own before using any of
1146     the following code for production.
1147     The developer will not be responsible or liable for all loss or 
1148     damage whatsoever caused by you participating in any way in the 
1149     experimental code, whether putting money into the contract or 
1150     using the code for your own project.
1151 */
1152 
1153 pragma solidity >=0.7.0 <0.9.0;
1154 
1155 
1156 
1157 
1158 contract DoodFellaz is ERC721, Ownable {
1159   using Strings for uint256;
1160   using Counters for Counters.Counter;
1161 
1162   Counters.Counter private supply;
1163 
1164   string public uriPrefix = "";
1165   string public uriSuffix = ".json";
1166   string public hiddenMetadataUri;
1167   
1168   uint256 public cost = 0.02 ether;
1169   uint256 public maxSupply = 10000;
1170   uint256 public maxMintAmountPerTx = 20;
1171 
1172   bool public paused = false;
1173   bool public revealed = true;
1174 
1175   constructor() ERC721("DoodFellaz", "DF") {
1176     setHiddenMetadataUri("ipfs://QmTaLp5tHdMPzmLejBFAY2DgLVZxKSY2iPEo8jia5vvmUk/hidden.json");
1177   }
1178 
1179   modifier mintCompliance(uint256 _mintAmount) {
1180     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1181     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1182     _;
1183   }
1184 
1185   function totalSupply() public view returns (uint256) {
1186     return supply.current();
1187   }
1188 
1189   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1190     require(!paused, "The contract is paused!");
1191     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1192 
1193     _mintLoop(msg.sender, _mintAmount);
1194   }
1195   
1196   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1197     _mintLoop(_receiver, _mintAmount);
1198   }
1199 
1200   function walletOfOwner(address _owner)
1201     public
1202     view
1203     returns (uint256[] memory)
1204   {
1205     uint256 ownerTokenCount = balanceOf(_owner);
1206     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1207     uint256 currentTokenId = 1;
1208     uint256 ownedTokenIndex = 0;
1209 
1210     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1211       address currentTokenOwner = ownerOf(currentTokenId);
1212 
1213       if (currentTokenOwner == _owner) {
1214         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1215 
1216         ownedTokenIndex++;
1217       }
1218 
1219       currentTokenId++;
1220     }
1221 
1222     return ownedTokenIds;
1223   }
1224 
1225   function tokenURI(uint256 _tokenId)
1226     public
1227     view
1228     virtual
1229     override
1230     returns (string memory)
1231   {
1232     require(
1233       _exists(_tokenId),
1234       "ERC721Metadata: URI query for nonexistent token"
1235     );
1236 
1237     if (revealed == false) {
1238       return hiddenMetadataUri;
1239     }
1240 
1241     string memory currentBaseURI = _baseURI();
1242     return bytes(currentBaseURI).length > 0
1243         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1244         : "";
1245   }
1246 
1247   function setRevealed(bool _state) public onlyOwner {
1248     revealed = _state;
1249   }
1250 
1251   function setCost(uint256 _cost) public onlyOwner {
1252     cost = _cost;
1253   }
1254 
1255   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1256     maxMintAmountPerTx = _maxMintAmountPerTx;
1257   }
1258 
1259   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1260     hiddenMetadataUri = _hiddenMetadataUri;
1261   }
1262 
1263   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1264     uriPrefix = _uriPrefix;
1265   }
1266 
1267   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1268     uriSuffix = _uriSuffix;
1269   }
1270 
1271   function setPaused(bool _state) public onlyOwner {
1272     paused = _state;
1273   }
1274 
1275   function withdraw() public onlyOwner {
1276    
1277     // =============================================================================
1278 
1279     // =============================================================================
1280 
1281     // This will transfer the remaining contract balance to the owner.
1282     // Do not remove this otherwise you will not be able to withdraw the funds.
1283     // =============================================================================
1284     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1285     require(os);
1286     // =============================================================================
1287   }
1288 
1289   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1290     for (uint256 i = 0; i < _mintAmount; i++) {
1291       supply.increment();
1292       _safeMint(_receiver, supply.current());
1293     }
1294   }
1295 
1296   function _baseURI() internal view virtual override returns (string memory) {
1297     return uriPrefix;
1298   }
1299 }