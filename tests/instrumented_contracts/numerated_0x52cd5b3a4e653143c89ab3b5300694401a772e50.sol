1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Strings.sol
47 
48 
49 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
61      */
62     function toString(uint256 value) internal pure returns (string memory) {
63         // Inspired by OraclizeAPI's implementation - MIT licence
64         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
65 
66         if (value == 0) {
67             return "0";
68         }
69         uint256 temp = value;
70         uint256 digits;
71         while (temp != 0) {
72             digits++;
73             temp /= 10;
74         }
75         bytes memory buffer = new bytes(digits);
76         while (value != 0) {
77             digits -= 1;
78             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
79             value /= 10;
80         }
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
86      */
87     function toHexString(uint256 value) internal pure returns (string memory) {
88         if (value == 0) {
89             return "0x00";
90         }
91         uint256 temp = value;
92         uint256 length = 0;
93         while (temp != 0) {
94             length++;
95             temp >>= 8;
96         }
97         return toHexString(value, length);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
102      */
103     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
104         bytes memory buffer = new bytes(2 * length + 2);
105         buffer[0] = "0";
106         buffer[1] = "x";
107         for (uint256 i = 2 * length + 1; i > 1; --i) {
108             buffer[i] = _HEX_SYMBOLS[value & 0xf];
109             value >>= 4;
110         }
111         require(value == 0, "Strings: hex length insufficient");
112         return string(buffer);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/access/Ownable.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 /**
152  * @dev Contract module which provides a basic access control mechanism, where
153  * there is an account (an owner) that can be granted exclusive access to
154  * specific functions.
155  *
156  * By default, the owner account will be the one that deploys the contract. This
157  * can later be changed with {transferOwnership}.
158  *
159  * This module is used through inheritance. It will make available the modifier
160  * `onlyOwner`, which can be applied to your functions to restrict their use to
161  * the owner.
162  */
163 abstract contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor() {
172         _transferOwnership(_msgSender());
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if called by any account other than the owner.
184      */
185     modifier onlyOwner() {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187         _;
188     }
189 
190     /**
191      * @dev Leaves the contract without owner. It will not be possible to call
192      * `onlyOwner` functions anymore. Can only be called by the current owner.
193      *
194      * NOTE: Renouncing ownership will leave the contract without an owner,
195      * thereby removing any functionality that is only available to the owner.
196      */
197     function renounceOwnership() public virtual onlyOwner {
198         _transferOwnership(address(0));
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Can only be called by the current owner.
204      */
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         _transferOwnership(newOwner);
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Internal function without access restriction.
213      */
214     function _transferOwnership(address newOwner) internal virtual {
215         address oldOwner = _owner;
216         _owner = newOwner;
217         emit OwnershipTransferred(oldOwner, newOwner);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Address.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
225 
226 pragma solidity ^0.8.1;
227 
228 /**
229  * @dev Collection of functions related to the address type
230  */
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      *
249      * [IMPORTANT]
250      * ====
251      * You shouldn't rely on `isContract` to protect against flash loan attacks!
252      *
253      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
254      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
255      * constructor.
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize/address.code.length, which returns 0
260         // for contracts in construction, since the code is only stored at the end
261         // of the constructor execution.
262 
263         return account.code.length > 0;
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
712 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
999 
1000         _afterTokenTransfer(address(0), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Destroys `tokenId`.
1005      * The approval is cleared when the token is burned.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _burn(uint256 tokenId) internal virtual {
1014         address owner = ERC721.ownerOf(tokenId);
1015 
1016         _beforeTokenTransfer(owner, address(0), tokenId);
1017 
1018         // Clear approvals
1019         _approve(address(0), tokenId);
1020 
1021         _balances[owner] -= 1;
1022         delete _owners[tokenId];
1023 
1024         emit Transfer(owner, address(0), tokenId);
1025 
1026         _afterTokenTransfer(owner, address(0), tokenId);
1027     }
1028 
1029     /**
1030      * @dev Transfers `tokenId` from `from` to `to`.
1031      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `tokenId` token must be owned by `from`.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _transfer(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) internal virtual {
1045         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1046         require(to != address(0), "ERC721: transfer to the zero address");
1047 
1048         _beforeTokenTransfer(from, to, tokenId);
1049 
1050         // Clear approvals from the previous owner
1051         _approve(address(0), tokenId);
1052 
1053         _balances[from] -= 1;
1054         _balances[to] += 1;
1055         _owners[tokenId] = to;
1056 
1057         emit Transfer(from, to, tokenId);
1058 
1059         _afterTokenTransfer(from, to, tokenId);
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
1139 
1140     /**
1141      * @dev Hook that is called after any transfer of tokens. This includes
1142      * minting and burning.
1143      *
1144      * Calling conditions:
1145      *
1146      * - when `from` and `to` are both non-zero.
1147      * - `from` and `to` are never both zero.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _afterTokenTransfer(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) internal virtual {}
1156 }
1157 
1158 // File: contracts/0xkevinpunks.sol
1159 
1160 
1161 
1162 pragma solidity >=0.7.0 <0.9.0;
1163 
1164 
1165 
1166 
1167 contract KevinPunks is ERC721, Ownable {
1168   using Strings for uint256;
1169   using Counters for Counters.Counter;
1170 
1171   Counters.Counter private supply;
1172 
1173   string public uriPrefix = "";
1174   string public uriSuffix = ".json";
1175   string public hiddenMetadataUri;
1176   
1177   uint256 public cost = 0.00 ether;
1178   uint256 public maxSupply = 5000;
1179   uint256 public maxMintAmountPerTx = 10;
1180 
1181   bool public paused = true;
1182   bool public revealed = false;
1183 
1184   constructor() ERC721("0xKevinPunks", "0xKVPKS") {
1185     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1186   }
1187 
1188   modifier mintCompliance(uint256 _mintAmount) {
1189     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1190     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1191     _;
1192   }
1193 
1194   function totalSupply() public view returns (uint256) {
1195     return supply.current();
1196   }
1197 
1198   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1199     require(!paused, "The contract is paused!");
1200     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1201 
1202     _mintLoop(msg.sender, _mintAmount);
1203   }
1204   
1205   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1206     _mintLoop(_receiver, _mintAmount);
1207   }
1208 
1209   function walletOfOwner(address _owner)
1210     public
1211     view
1212     returns (uint256[] memory)
1213   {
1214     uint256 ownerTokenCount = balanceOf(_owner);
1215     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1216     uint256 currentTokenId = 1;
1217     uint256 ownedTokenIndex = 0;
1218 
1219     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1220       address currentTokenOwner = ownerOf(currentTokenId);
1221 
1222       if (currentTokenOwner == _owner) {
1223         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1224 
1225         ownedTokenIndex++;
1226       }
1227 
1228       currentTokenId++;
1229     }
1230 
1231     return ownedTokenIds;
1232   }
1233 
1234   function tokenURI(uint256 _tokenId)
1235     public
1236     view
1237     virtual
1238     override
1239     returns (string memory)
1240   {
1241     require(
1242       _exists(_tokenId),
1243       "ERC721Metadata: URI query for nonexistent token"
1244     );
1245 
1246     if (revealed == false) {
1247       return hiddenMetadataUri;
1248     }
1249 
1250     string memory currentBaseURI = _baseURI();
1251     return bytes(currentBaseURI).length > 0
1252         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1253         : "";
1254   }
1255 
1256   function setRevealed(bool _state) public onlyOwner {
1257     revealed = _state;
1258   }
1259 
1260   function setCost(uint256 _cost) public onlyOwner {
1261     cost = _cost;
1262   }
1263 
1264   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1265     maxMintAmountPerTx = _maxMintAmountPerTx;
1266   }
1267 
1268   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1269     hiddenMetadataUri = _hiddenMetadataUri;
1270   }
1271 
1272   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1273     uriPrefix = _uriPrefix;
1274   }
1275 
1276   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1277     uriSuffix = _uriSuffix;
1278   }
1279 
1280   function setPaused(bool _state) public onlyOwner {
1281     paused = _state;
1282   }
1283 
1284   function withdraw() public onlyOwner {
1285     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1286     require(os);
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