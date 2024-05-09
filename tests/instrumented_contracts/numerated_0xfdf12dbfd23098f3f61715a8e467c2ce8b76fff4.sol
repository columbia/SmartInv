1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         _checkOwner();
61         _;
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if the sender is not the owner.
73      */
74     function _checkOwner() internal view virtual {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @title Counters
116  * @author Matt Condon (@shrugs)
117  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
118  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
119  *
120  * Include with `using Counters for Counters.Counter;`
121  */
122 library Counters {
123     struct Counter {
124         // This variable should never be directly accessed by users of the library: interactions must be restricted to
125         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
126         // this feature: see https://github.com/ethereum/solidity/issues/4637
127         uint256 _value; // default: 0
128     }
129 
130     function current(Counter storage counter) internal view returns (uint256) {
131         return counter._value;
132     }
133 
134     function increment(Counter storage counter) internal {
135         unchecked {
136             counter._value += 1;
137         }
138     }
139 
140     function decrement(Counter storage counter) internal {
141         uint256 value = counter._value;
142         require(value > 0, "Counter: decrement overflow");
143         unchecked {
144             counter._value = value - 1;
145         }
146     }
147 
148     function reset(Counter storage counter) internal {
149         counter._value = 0;
150     }
151 }
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev Interface of the ERC165 standard, as defined in the
160  * https://eips.ethereum.org/EIPS/eip-165[EIP].
161  *
162  * Implementers can declare support of contract interfaces, which can then be
163  * queried by others ({ERC165Checker}).
164  *
165  * For an implementation, see {ERC165}.
166  */
167 interface IERC165 {
168     /**
169      * @dev Returns true if this contract implements the interface defined by
170      * `interfaceId`. See the corresponding
171      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
172      * to learn more about how these ids are created.
173      *
174      * This function call must use less than 30 000 gas.
175      */
176     function supportsInterface(bytes4 interfaceId) external view returns (bool);
177 }
178 
179 
180 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Required interface of an ERC721 compliant contract.
186  */
187 interface IERC721 is IERC165 {
188     /**
189      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
192 
193     /**
194      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
195      */
196     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
197 
198     /**
199      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
200      */
201     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
202 
203     /**
204      * @dev Returns the number of tokens in ``owner``'s account.
205      */
206     function balanceOf(address owner) external view returns (uint256 balance);
207 
208     /**
209      * @dev Returns the owner of the `tokenId` token.
210      *
211      * Requirements:
212      *
213      * - `tokenId` must exist.
214      */
215     function ownerOf(uint256 tokenId) external view returns (address owner);
216 
217     /**
218      * @dev Safely transfers `tokenId` token from `from` to `to`.
219      *
220      * Requirements:
221      *
222      * - `from` cannot be the zero address.
223      * - `to` cannot be the zero address.
224      * - `tokenId` token must exist and be owned by `from`.
225      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
226      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
227      *
228      * Emits a {Transfer} event.
229      */
230     function safeTransferFrom(
231         address from,
232         address to,
233         uint256 tokenId,
234         bytes calldata data
235     ) external;
236 
237     /**
238      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
239      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
240      *
241      * Requirements:
242      *
243      * - `from` cannot be the zero address.
244      * - `to` cannot be the zero address.
245      * - `tokenId` token must exist and be owned by `from`.
246      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
247      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
248      *
249      * Emits a {Transfer} event.
250      */
251     function safeTransferFrom(
252         address from,
253         address to,
254         uint256 tokenId
255     ) external;
256 
257     /**
258      * @dev Transfers `tokenId` token from `from` to `to`.
259      *
260      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transferFrom(
272         address from,
273         address to,
274         uint256 tokenId
275     ) external;
276 
277     /**
278      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
279      * The approval is cleared when the token is transferred.
280      *
281      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
282      *
283      * Requirements:
284      *
285      * - The caller must own the token or be an approved operator.
286      * - `tokenId` must exist.
287      *
288      * Emits an {Approval} event.
289      */
290     function approve(address to, uint256 tokenId) external;
291 
292     /**
293      * @dev Approve or remove `operator` as an operator for the caller.
294      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
295      *
296      * Requirements:
297      *
298      * - The `operator` cannot be the caller.
299      *
300      * Emits an {ApprovalForAll} event.
301      */
302     function setApprovalForAll(address operator, bool _approved) external;
303 
304     /**
305      * @dev Returns the account approved for `tokenId` token.
306      *
307      * Requirements:
308      *
309      * - `tokenId` must exist.
310      */
311     function getApproved(uint256 tokenId) external view returns (address operator);
312 
313     /**
314      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
315      *
316      * See {setApprovalForAll}
317      */
318     function isApprovedForAll(address owner, address operator) external view returns (bool);
319 }
320 
321 
322 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @title ERC721 token receiver interface
328  * @dev Interface for any contract that wants to support safeTransfers
329  * from ERC721 asset contracts.
330  */
331 interface IERC721Receiver {
332     /**
333      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
334      * by `operator` from `from`, this function is called.
335      *
336      * It must return its Solidity selector to confirm the token transfer.
337      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
338      *
339      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
340      */
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
356  * @dev See https://eips.ethereum.org/EIPS/eip-721
357  */
358 interface IERC721Metadata is IERC721 {
359     /**
360      * @dev Returns the token collection name.
361      */
362     function name() external view returns (string memory);
363 
364     /**
365      * @dev Returns the token collection symbol.
366      */
367     function symbol() external view returns (string memory);
368 
369     /**
370      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
371      */
372     function tokenURI(uint256 tokenId) external view returns (string memory);
373 }
374 
375 
376 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
377 
378 pragma solidity ^0.8.1;
379 
380 /**
381  * @dev Collection of functions related to the address type
382  */
383 library Address {
384     /**
385      * @dev Returns true if `account` is a contract.
386      *
387      * [IMPORTANT]
388      * ====
389      * It is unsafe to assume that an address for which this function returns
390      * false is an externally-owned account (EOA) and not a contract.
391      *
392      * Among others, `isContract` will return false for the following
393      * types of addresses:
394      *
395      *  - an externally-owned account
396      *  - a contract in construction
397      *  - an address where a contract will be created
398      *  - an address where a contract lived, but was destroyed
399      * ====
400      *
401      * [IMPORTANT]
402      * ====
403      * You shouldn't rely on `isContract` to protect against flash loan attacks!
404      *
405      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
406      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
407      * constructor.
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // This method relies on extcodesize/address.code.length, which returns 0
412         // for contracts in construction, since the code is only stored at the end
413         // of the constructor execution.
414 
415         return account.code.length > 0;
416     }
417 
418     /**
419      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
420      * `recipient`, forwarding all available gas and reverting on errors.
421      *
422      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
423      * of certain opcodes, possibly making contracts go over the 2300 gas limit
424      * imposed by `transfer`, making them unable to receive funds via
425      * `transfer`. {sendValue} removes this limitation.
426      *
427      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
428      *
429      * IMPORTANT: because control is transferred to `recipient`, care must be
430      * taken to not create reentrancy vulnerabilities. Consider using
431      * {ReentrancyGuard} or the
432      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
433      */
434     function sendValue(address payable recipient, uint256 amount) internal {
435         require(address(this).balance >= amount, "Address: insufficient balance");
436 
437         (bool success, ) = recipient.call{value: amount}("");
438         require(success, "Address: unable to send value, recipient may have reverted");
439     }
440 
441     /**
442      * @dev Performs a Solidity function call using a low level `call`. A
443      * plain `call` is an unsafe replacement for a function call: use this
444      * function instead.
445      *
446      * If `target` reverts with a revert reason, it is bubbled up by this
447      * function (like regular Solidity function calls).
448      *
449      * Returns the raw returned data. To convert to the expected return value,
450      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
451      *
452      * Requirements:
453      *
454      * - `target` must be a contract.
455      * - calling `target` with `data` must not revert.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionCall(target, data, "Address: low-level call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
465      * `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, 0, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but also transferring `value` wei to `target`.
480      *
481      * Requirements:
482      *
483      * - the calling contract must have an ETH balance of at least `value`.
484      * - the called Solidity function must be `payable`.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(
489         address target,
490         bytes memory data,
491         uint256 value
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
498      * with `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(
503         address target,
504         bytes memory data,
505         uint256 value,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         require(address(this).balance >= value, "Address: insufficient balance for call");
509         require(isContract(target), "Address: call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.call{value: value}(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
522         return functionStaticCall(target, data, "Address: low-level static call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.staticcall(data);
539         return verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.4._
547      */
548     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
549         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal returns (bytes memory) {
563         require(isContract(target), "Address: delegate call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.delegatecall(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
571      * revert reason using the provided one.
572      *
573      * _Available since v4.3._
574      */
575     function verifyCallResult(
576         bool success,
577         bytes memory returndata,
578         string memory errorMessage
579     ) internal pure returns (bytes memory) {
580         if (success) {
581             return returndata;
582         } else {
583             // Look for revert reason and bubble it up if present
584             if (returndata.length > 0) {
585                 // The easiest way to bubble the revert reason is using memory via assembly
586                 /// @solidity memory-safe-assembly
587                 assembly {
588                     let returndata_size := mload(returndata)
589                     revert(add(32, returndata), returndata_size)
590                 }
591             } else {
592                 revert(errorMessage);
593             }
594         }
595     }
596 }
597 
598 
599 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev String operations.
605  */
606 library Strings {
607     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
608     uint8 private constant _ADDRESS_LENGTH = 20;
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
612      */
613     function toString(uint256 value) internal pure returns (string memory) {
614         // Inspired by OraclizeAPI's implementation - MIT licence
615         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
616 
617         if (value == 0) {
618             return "0";
619         }
620         uint256 temp = value;
621         uint256 digits;
622         while (temp != 0) {
623             digits++;
624             temp /= 10;
625         }
626         bytes memory buffer = new bytes(digits);
627         while (value != 0) {
628             digits -= 1;
629             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
630             value /= 10;
631         }
632         return string(buffer);
633     }
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
637      */
638     function toHexString(uint256 value) internal pure returns (string memory) {
639         if (value == 0) {
640             return "0x00";
641         }
642         uint256 temp = value;
643         uint256 length = 0;
644         while (temp != 0) {
645             length++;
646             temp >>= 8;
647         }
648         return toHexString(value, length);
649     }
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
653      */
654     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
655         bytes memory buffer = new bytes(2 * length + 2);
656         buffer[0] = "0";
657         buffer[1] = "x";
658         for (uint256 i = 2 * length + 1; i > 1; --i) {
659             buffer[i] = _HEX_SYMBOLS[value & 0xf];
660             value >>= 4;
661         }
662         require(value == 0, "Strings: hex length insufficient");
663         return string(buffer);
664     }
665 
666     /**
667      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
668      */
669     function toHexString(address addr) internal pure returns (string memory) {
670         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
671     }
672 }
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @dev Implementation of the {IERC165} interface.
681  *
682  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
683  * for the additional interface id that will be supported. For example:
684  *
685  * ```solidity
686  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
688  * }
689  * ```
690  *
691  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
692  */
693 abstract contract ERC165 is IERC165 {
694     /**
695      * @dev See {IERC165-supportsInterface}.
696      */
697     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698         return interfaceId == type(IERC165).interfaceId;
699     }
700 }
701 
702 
703 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 
709 
710 
711 
712 
713 /**
714  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
715  * the Metadata extension, but not including the Enumerable extension, which is available separately as
716  * {ERC721Enumerable}.
717  */
718 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
719     using Address for address;
720     using Strings for uint256;
721 
722     // Token name
723     string private _name;
724 
725     // Token symbol
726     string private _symbol;
727 
728     // Mapping from token ID to owner address
729     mapping(uint256 => address) private _owners;
730 
731     // Mapping owner address to token count
732     mapping(address => uint256) private _balances;
733 
734     // Mapping from token ID to approved address
735     mapping(uint256 => address) private _tokenApprovals;
736 
737     // Mapping from owner to operator approvals
738     mapping(address => mapping(address => bool)) private _operatorApprovals;
739 
740     /**
741      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
742      */
743     constructor(string memory name_, string memory symbol_) {
744         _name = name_;
745         _symbol = symbol_;
746     }
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
752         return
753             interfaceId == type(IERC721).interfaceId ||
754             interfaceId == type(IERC721Metadata).interfaceId ||
755             super.supportsInterface(interfaceId);
756     }
757 
758     /**
759      * @dev See {IERC721-balanceOf}.
760      */
761     function balanceOf(address owner) public view virtual override returns (uint256) {
762         require(owner != address(0), "ERC721: address zero is not a valid owner");
763         return _balances[owner];
764     }
765 
766     /**
767      * @dev See {IERC721-ownerOf}.
768      */
769     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
770         address owner = _owners[tokenId];
771         require(owner != address(0), "ERC721: invalid token ID");
772         return owner;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-name}.
777      */
778     function name() public view virtual override returns (string memory) {
779         return _name;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-symbol}.
784      */
785     function symbol() public view virtual override returns (string memory) {
786         return _symbol;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-tokenURI}.
791      */
792     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
793         _requireMinted(tokenId);
794 
795         string memory baseURI = _baseURI();
796         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
797     }
798 
799     /**
800      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
801      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
802      * by default, can be overridden in child contracts.
803      */
804     function _baseURI() internal view virtual returns (string memory) {
805         return "";
806     }
807 
808     /**
809      * @dev See {IERC721-approve}.
810      */
811     function approve(address to, uint256 tokenId) public virtual override {
812         address owner = ERC721.ownerOf(tokenId);
813         require(to != owner, "ERC721: approval to current owner");
814 
815         require(
816             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
817             "ERC721: approve caller is not token owner nor approved for all"
818         );
819 
820         _approve(to, tokenId);
821     }
822 
823     /**
824      * @dev See {IERC721-getApproved}.
825      */
826     function getApproved(uint256 tokenId) public view virtual override returns (address) {
827         _requireMinted(tokenId);
828 
829         return _tokenApprovals[tokenId];
830     }
831 
832     /**
833      * @dev See {IERC721-setApprovalForAll}.
834      */
835     function setApprovalForAll(address operator, bool approved) public virtual override {
836         _setApprovalForAll(_msgSender(), operator, approved);
837     }
838 
839     /**
840      * @dev See {IERC721-isApprovedForAll}.
841      */
842     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
843         return _operatorApprovals[owner][operator];
844     }
845 
846     /**
847      * @dev See {IERC721-transferFrom}.
848      */
849     function transferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         //solhint-disable-next-line max-line-length
855         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
856 
857         _transfer(from, to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public virtual override {
868         safeTransferFrom(from, to, tokenId, "");
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory data
879     ) public virtual override {
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
881         _safeTransfer(from, to, tokenId, data);
882     }
883 
884     /**
885      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
886      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
887      *
888      * `data` is additional data, it has no specified format and it is sent in call to `to`.
889      *
890      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
891      * implement alternative mechanisms to perform token transfer, such as signature-based.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _safeTransfer(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory data
907     ) internal virtual {
908         _transfer(from, to, tokenId);
909         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
910     }
911 
912     /**
913      * @dev Returns whether `tokenId` exists.
914      *
915      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
916      *
917      * Tokens start existing when they are minted (`_mint`),
918      * and stop existing when they are burned (`_burn`).
919      */
920     function _exists(uint256 tokenId) internal view virtual returns (bool) {
921         return _owners[tokenId] != address(0);
922     }
923 
924     /**
925      * @dev Returns whether `spender` is allowed to manage `tokenId`.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
932         address owner = ERC721.ownerOf(tokenId);
933         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
934     }
935 
936     /**
937      * @dev Safely mints `tokenId` and transfers it to `to`.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must not exist.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeMint(address to, uint256 tokenId) internal virtual {
947         _safeMint(to, tokenId, "");
948     }
949 
950     /**
951      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
952      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
953      */
954     function _safeMint(
955         address to,
956         uint256 tokenId,
957         bytes memory data
958     ) internal virtual {
959         _mint(to, tokenId);
960         require(
961             _checkOnERC721Received(address(0), to, tokenId, data),
962             "ERC721: transfer to non ERC721Receiver implementer"
963         );
964     }
965 
966     /**
967      * @dev Mints `tokenId` and transfers it to `to`.
968      *
969      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
970      *
971      * Requirements:
972      *
973      * - `tokenId` must not exist.
974      * - `to` cannot be the zero address.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _mint(address to, uint256 tokenId) internal virtual {
979         require(to != address(0), "ERC721: mint to the zero address");
980         require(!_exists(tokenId), "ERC721: token already minted");
981 
982         _beforeTokenTransfer(address(0), to, tokenId);
983 
984         _balances[to] += 1;
985         _owners[tokenId] = to;
986 
987         emit Transfer(address(0), to, tokenId);
988 
989         _afterTokenTransfer(address(0), to, tokenId);
990     }
991 
992     /**
993      * @dev Destroys `tokenId`.
994      * The approval is cleared when the token is burned.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _burn(uint256 tokenId) internal virtual {
1003         address owner = ERC721.ownerOf(tokenId);
1004 
1005         _beforeTokenTransfer(owner, address(0), tokenId);
1006 
1007         // Clear approvals
1008         _approve(address(0), tokenId);
1009 
1010         _balances[owner] -= 1;
1011         delete _owners[tokenId];
1012 
1013         emit Transfer(owner, address(0), tokenId);
1014 
1015         _afterTokenTransfer(owner, address(0), tokenId);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {
1034         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1035         require(to != address(0), "ERC721: transfer to the zero address");
1036 
1037         _beforeTokenTransfer(from, to, tokenId);
1038 
1039         // Clear approvals from the previous owner
1040         _approve(address(0), tokenId);
1041 
1042         _balances[from] -= 1;
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(from, to, tokenId);
1047 
1048         _afterTokenTransfer(from, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Approve `to` to operate on `tokenId`
1053      *
1054      * Emits an {Approval} event.
1055      */
1056     function _approve(address to, uint256 tokenId) internal virtual {
1057         _tokenApprovals[tokenId] = to;
1058         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Approve `operator` to operate on all of `owner` tokens
1063      *
1064      * Emits an {ApprovalForAll} event.
1065      */
1066     function _setApprovalForAll(
1067         address owner,
1068         address operator,
1069         bool approved
1070     ) internal virtual {
1071         require(owner != operator, "ERC721: approve to caller");
1072         _operatorApprovals[owner][operator] = approved;
1073         emit ApprovalForAll(owner, operator, approved);
1074     }
1075 
1076     /**
1077      * @dev Reverts if the `tokenId` has not been minted yet.
1078      */
1079     function _requireMinted(uint256 tokenId) internal view virtual {
1080         require(_exists(tokenId), "ERC721: invalid token ID");
1081     }
1082 
1083     /**
1084      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1085      * The call is not executed if the target address is not a contract.
1086      *
1087      * @param from address representing the previous owner of the given token ID
1088      * @param to target address that will receive the tokens
1089      * @param tokenId uint256 ID of the token to be transferred
1090      * @param data bytes optional data to send along with the call
1091      * @return bool whether the call correctly returned the expected magic value
1092      */
1093     function _checkOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory data
1098     ) private returns (bool) {
1099         if (to.isContract()) {
1100             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1101                 return retval == IERC721Receiver.onERC721Received.selector;
1102             } catch (bytes memory reason) {
1103                 if (reason.length == 0) {
1104                     revert("ERC721: transfer to non ERC721Receiver implementer");
1105                 } else {
1106                     /// @solidity memory-safe-assembly
1107                     assembly {
1108                         revert(add(32, reason), mload(reason))
1109                     }
1110                 }
1111             }
1112         } else {
1113             return true;
1114         }
1115     }
1116 
1117     /**
1118      * @dev Hook that is called before any token transfer. This includes minting
1119      * and burning.
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` will be minted for `to`.
1126      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1127      * - `from` and `to` are never both zero.
1128      *
1129      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1130      */
1131     function _beforeTokenTransfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) internal virtual {}
1136 
1137     /**
1138      * @dev Hook that is called after any transfer of tokens. This includes
1139      * minting and burning.
1140      *
1141      * Calling conditions:
1142      *
1143      * - when `from` and `to` are both non-zero.
1144      * - `from` and `to` are never both zero.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _afterTokenTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) internal virtual {}
1153 }
1154 
1155 
1156 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1162  * @dev See https://eips.ethereum.org/EIPS/eip-721
1163  */
1164 interface IERC721Enumerable is IERC721 {
1165     /**
1166      * @dev Returns the total amount of tokens stored by the contract.
1167      */
1168     function totalSupply() external view returns (uint256);
1169 
1170     /**
1171      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1172      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1173      */
1174     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1175 
1176     /**
1177      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1178      * Use along with {totalSupply} to enumerate all tokens.
1179      */
1180     function tokenByIndex(uint256 index) external view returns (uint256);
1181 }
1182 
1183 
1184 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 
1189 /**
1190  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1191  * enumerability of all the token ids in the contract as well as all token ids owned by each
1192  * account.
1193  */
1194 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1195     // Mapping from owner to list of owned token IDs
1196     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1197 
1198     // Mapping from token ID to index of the owner tokens list
1199     mapping(uint256 => uint256) private _ownedTokensIndex;
1200 
1201     // Array with all token ids, used for enumeration
1202     uint256[] private _allTokens;
1203 
1204     // Mapping from token id to position in the allTokens array
1205     mapping(uint256 => uint256) private _allTokensIndex;
1206 
1207     /**
1208      * @dev See {IERC165-supportsInterface}.
1209      */
1210     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1211         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1216      */
1217     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1218         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1219         return _ownedTokens[owner][index];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721Enumerable-totalSupply}.
1224      */
1225     function totalSupply() public view virtual override returns (uint256) {
1226         return _allTokens.length;
1227     }
1228 
1229     /**
1230      * @dev See {IERC721Enumerable-tokenByIndex}.
1231      */
1232     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1233         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1234         return _allTokens[index];
1235     }
1236 
1237     /**
1238      * @dev Hook that is called before any token transfer. This includes minting
1239      * and burning.
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1247      * - `from` cannot be the zero address.
1248      * - `to` cannot be the zero address.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _beforeTokenTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual override {
1257         super._beforeTokenTransfer(from, to, tokenId);
1258 
1259         if (from == address(0)) {
1260             _addTokenToAllTokensEnumeration(tokenId);
1261         } else if (from != to) {
1262             _removeTokenFromOwnerEnumeration(from, tokenId);
1263         }
1264         if (to == address(0)) {
1265             _removeTokenFromAllTokensEnumeration(tokenId);
1266         } else if (to != from) {
1267             _addTokenToOwnerEnumeration(to, tokenId);
1268         }
1269     }
1270 
1271     /**
1272      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1273      * @param to address representing the new owner of the given token ID
1274      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1275      */
1276     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1277         uint256 length = ERC721.balanceOf(to);
1278         _ownedTokens[to][length] = tokenId;
1279         _ownedTokensIndex[tokenId] = length;
1280     }
1281 
1282     /**
1283      * @dev Private function to add a token to this extension's token tracking data structures.
1284      * @param tokenId uint256 ID of the token to be added to the tokens list
1285      */
1286     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1287         _allTokensIndex[tokenId] = _allTokens.length;
1288         _allTokens.push(tokenId);
1289     }
1290 
1291     /**
1292      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1293      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1294      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1295      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1296      * @param from address representing the previous owner of the given token ID
1297      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1298      */
1299     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1300         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1301         // then delete the last slot (swap and pop).
1302 
1303         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1304         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1305 
1306         // When the token to delete is the last token, the swap operation is unnecessary
1307         if (tokenIndex != lastTokenIndex) {
1308             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1309 
1310             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1311             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1312         }
1313 
1314         // This also deletes the contents at the last position of the array
1315         delete _ownedTokensIndex[tokenId];
1316         delete _ownedTokens[from][lastTokenIndex];
1317     }
1318 
1319     /**
1320      * @dev Private function to remove a token from this extension's token tracking data structures.
1321      * This has O(1) time complexity, but alters the order of the _allTokens array.
1322      * @param tokenId uint256 ID of the token to be removed from the tokens list
1323      */
1324     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1325         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1326         // then delete the last slot (swap and pop).
1327 
1328         uint256 lastTokenIndex = _allTokens.length - 1;
1329         uint256 tokenIndex = _allTokensIndex[tokenId];
1330 
1331         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1332         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1333         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1334         uint256 lastTokenId = _allTokens[lastTokenIndex];
1335 
1336         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1337         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1338 
1339         // This also deletes the contents at the last position of the array
1340         delete _allTokensIndex[tokenId];
1341         _allTokens.pop();
1342     }
1343 }
1344 
1345 
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 
1350 
1351 
1352 contract MetaProfile is ERC721, ERC721Enumerable, Ownable {
1353     // Generate Token ID
1354     using Counters for Counters.Counter;
1355     Counters.Counter private _tokenIdCounter;
1356 
1357     // Mapping from Token ID to soul address
1358     mapping(uint256 => address) private _souls;
1359 
1360     // Mint status, if false, no more nft is allowed to mint
1361     bool public mintPermitted = true;
1362 
1363     // base uri
1364     string private _tokenBaseURI;
1365 
1366     constructor() ERC721("Resume NFT", "RNFT") {
1367         setBaseURI("https://uniuni.io/nft/profile/");
1368     }
1369 
1370     /**
1371      * @dev Everyone can mint his/her own profile nft.
1372      */
1373     function mint() external {
1374         require(mintPermitted, "Mint: the NFT contract is locked up forever");
1375         _tokenIdCounter.increment();
1376         uint256 tokenId = _tokenIdCounter.current();
1377         _safeMint(msg.sender, tokenId);
1378         _souls[tokenId] = msg.sender;
1379     }
1380     
1381     /**
1382      * @dev Everyone can burn his/her own profile NFT
1383      */
1384     function burn(uint256 tokenId) external {
1385         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1386         _burn(tokenId);
1387         // not do delete action actually so as to save gas fee
1388         // delete _souls[tokenId];
1389     }
1390 
1391     /**
1392      * @dev After the call, no NFT is allowed to mint
1393      */
1394     function lockup() external onlyOwner {
1395         mintPermitted = false;
1396     }
1397 
1398     /**
1399      * @dev Get the soul address of an NFT, require the NFT exists
1400      * @param tokenId The NFT
1401      */
1402     function soulOf(uint256 tokenId) external view returns(address) {
1403         require(_exists(tokenId), "ERC721: invalid token ID");
1404         return _souls[tokenId];
1405     }
1406 
1407     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1408         super._beforeTokenTransfer(from, to, tokenId);
1409     }
1410 
1411     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1412         return super.supportsInterface(interfaceId);
1413     }
1414 
1415     /**
1416      * @dev Set Base URI for computing {tokenURI}.
1417      */
1418     function setBaseURI(string memory uri) public onlyOwner {
1419         _tokenBaseURI = uri;
1420     }
1421 
1422     /**
1423      * @dev Base URI for computing {tokenURI}.
1424      */
1425     function _baseURI() internal view override virtual returns (string memory) {
1426         return _tokenBaseURI;
1427     }
1428 }