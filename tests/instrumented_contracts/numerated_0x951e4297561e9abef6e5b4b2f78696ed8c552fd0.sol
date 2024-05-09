1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @title Counters
8  * @author Matt Condon (@shrugs)
9  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
10  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
11  *
12  * Include with `using Counters for Counters.Counter;`
13  */
14 library Counters {
15     struct Counter {
16         // This variable should never be directly accessed by users of the library: interactions must be restricted to
17         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
18         // this feature: see https://github.com/ethereum/solidity/issues/4637
19         uint256 _value; // default: 0
20     }
21 
22     function current(Counter storage counter) internal view returns (uint256) {
23         return counter._value;
24     }
25 
26     function increment(Counter storage counter) internal {
27         unchecked {
28             counter._value += 1;
29         }
30     }
31 
32     function decrement(Counter storage counter) internal {
33         uint256 value = counter._value;
34         require(value > 0, "Counter: decrement overflow");
35         unchecked {
36             counter._value = value - 1;
37         }
38     }
39 
40     function reset(Counter storage counter) internal {
41         counter._value = 0;
42     }
43 }
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Provides information about the current execution context, including the
51  * sender of the transaction and its data. While these are generally available
52  * via msg.sender and msg.data, they should not be accessed in such a direct
53  * manner, since when dealing with meta-transactions the account sending and
54  * paying for execution may not be the actual sender (as far as an application
55  * is concerned).
56  *
57  * This contract is only required for intermediate, library-like contracts.
58  */
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes calldata) {
65         return msg.data;
66     }
67 }
68 
69 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(
89         address indexed previousOwner,
90         address indexed newOwner
91     );
92 
93     /**
94      * @dev Initializes the contract setting the deployer as the initial owner.
95      */
96     constructor() {
97         _transferOwnership(_msgSender());
98     }
99 
100     /**
101      * @dev Returns the address of the current owner.
102      */
103     function owner() public view virtual returns (address) {
104         return _owner;
105     }
106 
107     /**
108      * @dev Throws if called by any account other than the owner.
109      */
110     modifier onlyOwner() {
111         require(owner() == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     /**
116      * @dev Leaves the contract without owner. It will not be possible to call
117      * `onlyOwner` functions anymore. Can only be called by the current owner.
118      *
119      * NOTE: Renouncing ownership will leave the contract without an owner,
120      * thereby removing any functionality that is only available to the owner.
121      */
122     function renounceOwnership() public virtual onlyOwner {
123         _transferOwnership(address(0));
124     }
125 
126     /**
127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
128      * Can only be called by the current owner.
129      */
130     function transferOwnership(address newOwner) public virtual onlyOwner {
131         require(
132             newOwner != address(0),
133             "Ownable: new owner is the zero address"
134         );
135         _transferOwnership(newOwner);
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Internal function without access restriction.
141      */
142     function _transferOwnership(address newOwner) internal virtual {
143         address oldOwner = _owner;
144         _owner = newOwner;
145         emit OwnershipTransferred(oldOwner, newOwner);
146     }
147 }
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Interface of the ERC165 standard, as defined in the
155  * https://eips.ethereum.org/EIPS/eip-165[EIP].
156  *
157  * Implementers can declare support of contract interfaces, which can then be
158  * queried by others ({ERC165Checker}).
159  *
160  * For an implementation, see {ERC165}.
161  */
162 interface IERC165 {
163     /**
164      * @dev Returns true if this contract implements the interface defined by
165      * `interfaceId`. See the corresponding
166      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
167      * to learn more about how these ids are created.
168      *
169      * This function call must use less than 30 000 gas.
170      */
171     function supportsInterface(bytes4 interfaceId) external view returns (bool);
172 }
173 
174 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Required interface of an ERC721 compliant contract.
180  */
181 interface IERC721 is IERC165 {
182     /**
183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
184      */
185     event Transfer(
186         address indexed from,
187         address indexed to,
188         uint256 indexed tokenId
189     );
190 
191     /**
192      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
193      */
194     event Approval(
195         address indexed owner,
196         address indexed approved,
197         uint256 indexed tokenId
198     );
199 
200     /**
201      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
202      */
203     event ApprovalForAll(
204         address indexed owner,
205         address indexed operator,
206         bool approved
207     );
208 
209     /**
210      * @dev Returns the number of tokens in ``owner``'s account.
211      */
212     function balanceOf(address owner) external view returns (uint256 balance);
213 
214     /**
215      * @dev Returns the owner of the `tokenId` token.
216      *
217      * Requirements:
218      *
219      * - `tokenId` must exist.
220      */
221     function ownerOf(uint256 tokenId) external view returns (address owner);
222 
223     /**
224      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
225      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId
241     ) external;
242 
243     /**
244      * @dev Transfers `tokenId` token from `from` to `to`.
245      *
246      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(
258         address from,
259         address to,
260         uint256 tokenId
261     ) external;
262 
263     /**
264      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
265      * The approval is cleared when the token is transferred.
266      *
267      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
268      *
269      * Requirements:
270      *
271      * - The caller must own the token or be an approved operator.
272      * - `tokenId` must exist.
273      *
274      * Emits an {Approval} event.
275      */
276     function approve(address to, uint256 tokenId) external;
277 
278     /**
279      * @dev Returns the account approved for `tokenId` token.
280      *
281      * Requirements:
282      *
283      * - `tokenId` must exist.
284      */
285     function getApproved(uint256 tokenId)
286         external
287         view
288         returns (address operator);
289 
290     /**
291      * @dev Approve or remove `operator` as an operator for the caller.
292      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
293      *
294      * Requirements:
295      *
296      * - The `operator` cannot be the caller.
297      *
298      * Emits an {ApprovalForAll} event.
299      */
300     function setApprovalForAll(address operator, bool _approved) external;
301 
302     /**
303      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
304      *
305      * See {setApprovalForAll}
306      */
307     function isApprovedForAll(address owner, address operator)
308         external
309         view
310         returns (bool);
311 
312     /**
313      * @dev Safely transfers `tokenId` token from `from` to `to`.
314      *
315      * Requirements:
316      *
317      * - `from` cannot be the zero address.
318      * - `to` cannot be the zero address.
319      * - `tokenId` token must exist and be owned by `from`.
320      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
321      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
322      *
323      * Emits a {Transfer} event.
324      */
325     function safeTransferFrom(
326         address from,
327         address to,
328         uint256 tokenId,
329         bytes calldata data
330     ) external;
331 }
332 
333 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
339  * @dev See https://eips.ethereum.org/EIPS/eip-721
340  */
341 interface IERC721Metadata is IERC721 {
342     /**
343      * @dev Returns the token collection name.
344      */
345     function name() external view returns (string memory);
346 
347     /**
348      * @dev Returns the token collection symbol.
349      */
350     function symbol() external view returns (string memory);
351 
352     /**
353      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
354      */
355     function tokenURI(uint256 tokenId) external view returns (string memory);
356 }
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId)
381         public
382         view
383         virtual
384         override
385         returns (bool)
386     {
387         return interfaceId == type(IERC165).interfaceId;
388     }
389 }
390 
391 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev String operations.
424  */
425 library Strings {
426     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
427 
428     /**
429      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
430      */
431     function toString(uint256 value) internal pure returns (string memory) {
432         // Inspired by OraclizeAPI's implementation - MIT licence
433         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
434 
435         if (value == 0) {
436             return "0";
437         }
438         uint256 temp = value;
439         uint256 digits;
440         while (temp != 0) {
441             digits++;
442             temp /= 10;
443         }
444         bytes memory buffer = new bytes(digits);
445         while (value != 0) {
446             digits -= 1;
447             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
448             value /= 10;
449         }
450         return string(buffer);
451     }
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
455      */
456     function toHexString(uint256 value) internal pure returns (string memory) {
457         if (value == 0) {
458             return "0x00";
459         }
460         uint256 temp = value;
461         uint256 length = 0;
462         while (temp != 0) {
463             length++;
464             temp >>= 8;
465         }
466         return toHexString(value, length);
467     }
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
471      */
472     function toHexString(uint256 value, uint256 length)
473         internal
474         pure
475         returns (string memory)
476     {
477         bytes memory buffer = new bytes(2 * length + 2);
478         buffer[0] = "0";
479         buffer[1] = "x";
480         for (uint256 i = 2 * length + 1; i > 1; --i) {
481             buffer[i] = _HEX_SYMBOLS[value & 0xf];
482             value >>= 4;
483         }
484         require(value == 0, "Strings: hex length insufficient");
485         return string(buffer);
486     }
487 }
488 
489 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
490 
491 pragma solidity ^0.8.1;
492 
493 /**
494  * @dev Collection of functions related to the address type
495  */
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      *
514      * [IMPORTANT]
515      * ====
516      * You shouldn't rely on `isContract` to protect against flash loan attacks!
517      *
518      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
519      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
520      * constructor.
521      * ====
522      */
523     function isContract(address account) internal view returns (bool) {
524         // This method relies on extcodesize/address.code.length, which returns 0
525         // for contracts in construction, since the code is only stored at the end
526         // of the constructor execution.
527 
528         return account.code.length > 0;
529     }
530 
531     /**
532      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
533      * `recipient`, forwarding all available gas and reverting on errors.
534      *
535      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
536      * of certain opcodes, possibly making contracts go over the 2300 gas limit
537      * imposed by `transfer`, making them unable to receive funds via
538      * `transfer`. {sendValue} removes this limitation.
539      *
540      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
541      *
542      * IMPORTANT: because control is transferred to `recipient`, care must be
543      * taken to not create reentrancy vulnerabilities. Consider using
544      * {ReentrancyGuard} or the
545      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
546      */
547     function sendValue(address payable recipient, uint256 amount) internal {
548         require(
549             address(this).balance >= amount,
550             "Address: insufficient balance"
551         );
552 
553         (bool success, ) = recipient.call{value: amount}("");
554         require(
555             success,
556             "Address: unable to send value, recipient may have reverted"
557         );
558     }
559 
560     /**
561      * @dev Performs a Solidity function call using a low level `call`. A
562      * plain `call` is an unsafe replacement for a function call: use this
563      * function instead.
564      *
565      * If `target` reverts with a revert reason, it is bubbled up by this
566      * function (like regular Solidity function calls).
567      *
568      * Returns the raw returned data. To convert to the expected return value,
569      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
570      *
571      * Requirements:
572      *
573      * - `target` must be a contract.
574      * - calling `target` with `data` must not revert.
575      *
576      * _Available since v3.1._
577      */
578     function functionCall(address target, bytes memory data)
579         internal
580         returns (bytes memory)
581     {
582         return functionCall(target, data, "Address: low-level call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
587      * `errorMessage` as a fallback revert reason when `target` reverts.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, 0, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but also transferring `value` wei to `target`.
602      *
603      * Requirements:
604      *
605      * - the calling contract must have an ETH balance of at least `value`.
606      * - the called Solidity function must be `payable`.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(
611         address target,
612         bytes memory data,
613         uint256 value
614     ) internal returns (bytes memory) {
615         return
616             functionCallWithValue(
617                 target,
618                 data,
619                 value,
620                 "Address: low-level call with value failed"
621             );
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
626      * with `errorMessage` as a fallback revert reason when `target` reverts.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(
631         address target,
632         bytes memory data,
633         uint256 value,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         require(
637             address(this).balance >= value,
638             "Address: insufficient balance for call"
639         );
640         require(isContract(target), "Address: call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.call{value: value}(
643             data
644         );
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(address target, bytes memory data)
655         internal
656         view
657         returns (bytes memory)
658     {
659         return
660             functionStaticCall(
661                 target,
662                 data,
663                 "Address: low-level static call failed"
664             );
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
669      * but performing a static call.
670      *
671      * _Available since v3.3._
672      */
673     function functionStaticCall(
674         address target,
675         bytes memory data,
676         string memory errorMessage
677     ) internal view returns (bytes memory) {
678         require(isContract(target), "Address: static call to non-contract");
679 
680         (bool success, bytes memory returndata) = target.staticcall(data);
681         return verifyCallResult(success, returndata, errorMessage);
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
686      * but performing a delegate call.
687      *
688      * _Available since v3.4._
689      */
690     function functionDelegateCall(address target, bytes memory data)
691         internal
692         returns (bytes memory)
693     {
694         return
695             functionDelegateCall(
696                 target,
697                 data,
698                 "Address: low-level delegate call failed"
699             );
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
704      * but performing a delegate call.
705      *
706      * _Available since v3.4._
707      */
708     function functionDelegateCall(
709         address target,
710         bytes memory data,
711         string memory errorMessage
712     ) internal returns (bytes memory) {
713         require(isContract(target), "Address: delegate call to non-contract");
714 
715         (bool success, bytes memory returndata) = target.delegatecall(data);
716         return verifyCallResult(success, returndata, errorMessage);
717     }
718 
719     /**
720      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
721      * revert reason using the provided one.
722      *
723      * _Available since v4.3._
724      */
725     function verifyCallResult(
726         bool success,
727         bytes memory returndata,
728         string memory errorMessage
729     ) internal pure returns (bytes memory) {
730         if (success) {
731             return returndata;
732         } else {
733             // Look for revert reason and bubble it up if present
734             if (returndata.length > 0) {
735                 // The easiest way to bubble the revert reason is using memory via assembly
736 
737                 assembly {
738                     let returndata_size := mload(returndata)
739                     revert(add(32, returndata), returndata_size)
740                 }
741             } else {
742                 revert(errorMessage);
743             }
744         }
745     }
746 }
747 
748 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
749 
750 pragma solidity ^0.8.0;
751 
752 /**
753  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
754  * the Metadata extension, but not including the Enumerable extension, which is available separately as
755  * {ERC721Enumerable}.
756  */
757 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
758     using Address for address;
759     using Strings for uint256;
760 
761     // Token name
762     string private _name;
763 
764     // Token symbol
765     string private _symbol;
766 
767     // Mapping from token ID to owner address
768     mapping(uint256 => address) private _owners;
769 
770     // Mapping owner address to token count
771     mapping(address => uint256) private _balances;
772 
773     // Mapping from token ID to approved address
774     mapping(uint256 => address) private _tokenApprovals;
775 
776     // Mapping from owner to operator approvals
777     mapping(address => mapping(address => bool)) private _operatorApprovals;
778 
779     /**
780      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
781      */
782     constructor(string memory name_, string memory symbol_) {
783         _name = name_;
784         _symbol = symbol_;
785     }
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId)
791         public
792         view
793         virtual
794         override(ERC165, IERC165)
795         returns (bool)
796     {
797         return
798             interfaceId == type(IERC721).interfaceId ||
799             interfaceId == type(IERC721Metadata).interfaceId ||
800             super.supportsInterface(interfaceId);
801     }
802 
803     /**
804      * @dev See {IERC721-balanceOf}.
805      */
806     function balanceOf(address owner)
807         public
808         view
809         virtual
810         override
811         returns (uint256)
812     {
813         require(
814             owner != address(0),
815             "ERC721: balance query for the zero address"
816         );
817         return _balances[owner];
818     }
819 
820     /**
821      * @dev See {IERC721-ownerOf}.
822      */
823     function ownerOf(uint256 tokenId)
824         public
825         view
826         virtual
827         override
828         returns (address)
829     {
830         address owner = _owners[tokenId];
831         require(
832             owner != address(0),
833             "ERC721: owner query for nonexistent token"
834         );
835         return owner;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-name}.
840      */
841     function name() public view virtual override returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-symbol}.
847      */
848     function symbol() public view virtual override returns (string memory) {
849         return _symbol;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-tokenURI}.
854      */
855     function tokenURI(uint256 tokenId)
856         public
857         view
858         virtual
859         override
860         returns (string memory)
861     {
862         require(
863             _exists(tokenId),
864             "ERC721Metadata: URI query for nonexistent token"
865         );
866 
867         string memory baseURI = _baseURI();
868         return
869             bytes(baseURI).length > 0
870                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
871                 : "";
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return "";
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public virtual override {
887         address owner = ERC721.ownerOf(tokenId);
888         require(to != owner, "ERC721: approval to current owner");
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             "ERC721: approve caller is not owner nor approved for all"
893         );
894 
895         _approve(to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId)
902         public
903         view
904         virtual
905         override
906         returns (address)
907     {
908         require(
909             _exists(tokenId),
910             "ERC721: approved query for nonexistent token"
911         );
912 
913         return _tokenApprovals[tokenId];
914     }
915 
916     /**
917      * @dev See {IERC721-setApprovalForAll}.
918      */
919     function setApprovalForAll(address operator, bool approved)
920         public
921         virtual
922         override
923     {
924         _setApprovalForAll(_msgSender(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator)
931         public
932         view
933         virtual
934         override
935         returns (bool)
936     {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         //solhint-disable-next-line max-line-length
949         require(
950             _isApprovedOrOwner(_msgSender(), tokenId),
951             "ERC721: transfer caller is not owner nor approved"
952         );
953 
954         _transfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) public virtual override {
965         safeTransferFrom(from, to, tokenId, "");
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) public virtual override {
977         require(
978             _isApprovedOrOwner(_msgSender(), tokenId),
979             "ERC721: transfer caller is not owner nor approved"
980         );
981         _safeTransfer(from, to, tokenId, _data);
982     }
983 
984     /**
985      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
986      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
987      *
988      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
989      *
990      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
991      * implement alternative mechanisms to perform token transfer, such as signature-based.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must exist and be owned by `from`.
998      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _safeTransfer(
1003         address from,
1004         address to,
1005         uint256 tokenId,
1006         bytes memory _data
1007     ) internal virtual {
1008         _transfer(from, to, tokenId);
1009         require(
1010             _checkOnERC721Received(from, to, tokenId, _data),
1011             "ERC721: transfer to non ERC721Receiver implementer"
1012         );
1013     }
1014 
1015     /**
1016      * @dev Returns whether `tokenId` exists.
1017      *
1018      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1019      *
1020      * Tokens start existing when they are minted (`_mint`),
1021      * and stop existing when they are burned (`_burn`).
1022      */
1023     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1024         return _owners[tokenId] != address(0);
1025     }
1026 
1027     /**
1028      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      */
1034     function _isApprovedOrOwner(address spender, uint256 tokenId)
1035         internal
1036         view
1037         virtual
1038         returns (bool)
1039     {
1040         require(
1041             _exists(tokenId),
1042             "ERC721: operator query for nonexistent token"
1043         );
1044         address owner = ERC721.ownerOf(tokenId);
1045         return (spender == owner ||
1046             getApproved(tokenId) == spender ||
1047             isApprovedForAll(owner, spender));
1048     }
1049 
1050     /**
1051      * @dev Safely mints `tokenId` and transfers it to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must not exist.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _safeMint(address to, uint256 tokenId) internal virtual {
1061         _safeMint(to, tokenId, "");
1062     }
1063 
1064     /**
1065      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1066      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1067      */
1068     function _safeMint(
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) internal virtual {
1073         _mint(to, tokenId);
1074         require(
1075             _checkOnERC721Received(address(0), to, tokenId, _data),
1076             "ERC721: transfer to non ERC721Receiver implementer"
1077         );
1078     }
1079 
1080     /**
1081      * @dev Mints `tokenId` and transfers it to `to`.
1082      *
1083      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must not exist.
1088      * - `to` cannot be the zero address.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(address to, uint256 tokenId) internal virtual {
1093         require(to != address(0), "ERC721: mint to the zero address");
1094         require(!_exists(tokenId), "ERC721: token already minted");
1095 
1096         _beforeTokenTransfer(address(0), to, tokenId);
1097 
1098         _balances[to] += 1;
1099         _owners[tokenId] = to;
1100 
1101         emit Transfer(address(0), to, tokenId);
1102 
1103         _afterTokenTransfer(address(0), to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev Destroys `tokenId`.
1108      * The approval is cleared when the token is burned.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _burn(uint256 tokenId) internal virtual {
1117         address owner = ERC721.ownerOf(tokenId);
1118 
1119         _beforeTokenTransfer(owner, address(0), tokenId);
1120 
1121         // Clear approvals
1122         _approve(address(0), tokenId);
1123 
1124         _balances[owner] -= 1;
1125         delete _owners[tokenId];
1126 
1127         emit Transfer(owner, address(0), tokenId);
1128 
1129         _afterTokenTransfer(owner, address(0), tokenId);
1130     }
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) internal virtual {
1148         require(
1149             ERC721.ownerOf(tokenId) == from,
1150             "ERC721: transfer from incorrect owner"
1151         );
1152         require(to != address(0), "ERC721: transfer to the zero address");
1153 
1154         _beforeTokenTransfer(from, to, tokenId);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId);
1158 
1159         _balances[from] -= 1;
1160         _balances[to] += 1;
1161         _owners[tokenId] = to;
1162 
1163         emit Transfer(from, to, tokenId);
1164 
1165         _afterTokenTransfer(from, to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev Approve `to` to operate on `tokenId`
1170      *
1171      * Emits a {Approval} event.
1172      */
1173     function _approve(address to, uint256 tokenId) internal virtual {
1174         _tokenApprovals[tokenId] = to;
1175         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1176     }
1177 
1178     /**
1179      * @dev Approve `operator` to operate on all of `owner` tokens
1180      *
1181      * Emits a {ApprovalForAll} event.
1182      */
1183     function _setApprovalForAll(
1184         address owner,
1185         address operator,
1186         bool approved
1187     ) internal virtual {
1188         require(owner != operator, "ERC721: approve to caller");
1189         _operatorApprovals[owner][operator] = approved;
1190         emit ApprovalForAll(owner, operator, approved);
1191     }
1192 
1193     /**
1194      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1195      * The call is not executed if the target address is not a contract.
1196      *
1197      * @param from address representing the previous owner of the given token ID
1198      * @param to target address that will receive the tokens
1199      * @param tokenId uint256 ID of the token to be transferred
1200      * @param _data bytes optional data to send along with the call
1201      * @return bool whether the call correctly returned the expected magic value
1202      */
1203     function _checkOnERC721Received(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) private returns (bool) {
1209         if (to.isContract()) {
1210             try
1211                 IERC721Receiver(to).onERC721Received(
1212                     _msgSender(),
1213                     from,
1214                     tokenId,
1215                     _data
1216                 )
1217             returns (bytes4 retval) {
1218                 return retval == IERC721Receiver.onERC721Received.selector;
1219             } catch (bytes memory reason) {
1220                 if (reason.length == 0) {
1221                     revert(
1222                         "ERC721: transfer to non ERC721Receiver implementer"
1223                     );
1224                 } else {
1225                     assembly {
1226                         revert(add(32, reason), mload(reason))
1227                     }
1228                 }
1229             }
1230         } else {
1231             return true;
1232         }
1233     }
1234 
1235     /**
1236      * @dev Hook that is called before any token transfer. This includes minting
1237      * and burning.
1238      *
1239      * Calling conditions:
1240      *
1241      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1242      * transferred to `to`.
1243      * - When `from` is zero, `tokenId` will be minted for `to`.
1244      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1245      * - `from` and `to` are never both zero.
1246      *
1247      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1248      */
1249     function _beforeTokenTransfer(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) internal virtual {}
1254 
1255     /**
1256      * @dev Hook that is called after any transfer of tokens. This includes
1257      * minting and burning.
1258      *
1259      * Calling conditions:
1260      *
1261      * - when `from` and `to` are both non-zero.
1262      * - `from` and `to` are never both zero.
1263      *
1264      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1265      */
1266     function _afterTokenTransfer(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) internal virtual {}
1271 }
1272 
1273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1274 
1275 pragma solidity ^0.8.0;
1276 
1277 /**
1278  * @dev These functions deal with verification of Merkle Trees proofs.
1279  *
1280  * The proofs can be generated using the JavaScript library
1281  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1282  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1283  *
1284  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1285  */
1286 library MerkleProof {
1287     /**
1288      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1289      * defined by `root`. For this, a `proof` must be provided, containing
1290      * sibling hashes on the branch from the leaf to the root of the tree. Each
1291      * pair of leaves and each pair of pre-images are assumed to be sorted.
1292      */
1293     function verify(
1294         bytes32[] memory proof,
1295         bytes32 root,
1296         bytes32 leaf
1297     ) internal pure returns (bool) {
1298         return processProof(proof, leaf) == root;
1299     }
1300 
1301     /**
1302      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1303      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1304      * hash matches the root of the tree. When processing the proof, the pairs
1305      * of leafs & pre-images are assumed to be sorted.
1306      *
1307      * _Available since v4.4._
1308      */
1309     function processProof(bytes32[] memory proof, bytes32 leaf)
1310         internal
1311         pure
1312         returns (bytes32)
1313     {
1314         bytes32 computedHash = leaf;
1315         for (uint256 i = 0; i < proof.length; i++) {
1316             bytes32 proofElement = proof[i];
1317             if (computedHash <= proofElement) {
1318                 // Hash(current computed hash + current element of the proof)
1319                 computedHash = _efficientHash(computedHash, proofElement);
1320             } else {
1321                 // Hash(current element of the proof + current computed hash)
1322                 computedHash = _efficientHash(proofElement, computedHash);
1323             }
1324         }
1325         return computedHash;
1326     }
1327 
1328     function _efficientHash(bytes32 a, bytes32 b)
1329         private
1330         pure
1331         returns (bytes32 value)
1332     {
1333         assembly {
1334             mstore(0x00, a)
1335             mstore(0x20, b)
1336             value := keccak256(0x00, 0x40)
1337         }
1338     }
1339 }
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 contract BaeCafe is ERC721, Ownable {
1344     using Counters for Counters.Counter;
1345 
1346     uint256 public immutable MAX_HANA = 3069;
1347 
1348     uint256 public constant TOTAL_RARES = 5;
1349     uint256 public constant totalWhitelistMint = 2905;
1350     uint256 public constant totalTeamMint = 159;
1351     uint256 public constant maxBaePurchase = 4;
1352     uint256 public constant baePrice = 80080000000000000; //0.08008 ETH
1353 
1354     bytes32 public merkleRoot;
1355     string public baseURI;
1356     bool public saleIsActive = false;
1357     uint256 public countTeamMint = 0;
1358     Counters.Counter public countMintedWhitelist;
1359     Counters.Counter public countRareMint;
1360 
1361     Counters.Counter private _tokenIds;
1362     mapping(address => uint256) private MINTED_WHITELIST;
1363     address private openSeaProxyRegistryAddress;
1364 
1365     constructor(
1366         string memory name_,
1367         string memory symbol_,
1368         bytes32 merkleRoot_,
1369         string memory baseURI_,
1370         address openSeaProxyRegistryAddress_
1371     ) Ownable() ERC721(name_, symbol_) {
1372         merkleRoot = merkleRoot_;
1373         baseURI = baseURI_;
1374         openSeaProxyRegistryAddress = openSeaProxyRegistryAddress_;
1375     }
1376 
1377     /**
1378      * Function to withdraw
1379      */
1380     function withdraw() public onlyOwner {
1381         Address.sendValue(payable(msg.sender), address(this).balance);
1382     }
1383 
1384     /**
1385      * Function return total supply
1386      */
1387     function totalSupply() external view returns (uint256) {
1388         return _tokenIds.current() + countRareMint.current();
1389     }
1390 
1391     /**
1392      * Function to set MerkleRoot
1393      */
1394     function setMerkleRoot(bytes32 merkleRoot_) public onlyOwner {
1395         merkleRoot = merkleRoot_;
1396     }
1397 
1398     /*
1399      * Pause sale if active, make active if paused
1400      */
1401     function flipSaleState() public onlyOwner {
1402         saleIsActive = !saleIsActive;
1403     }
1404 
1405     /**
1406      * Function to set the base URI for all token IDs.
1407      */
1408     function setBaseURI(string memory newURI) public onlyOwner {
1409         baseURI = newURI;
1410     }
1411 
1412     /**
1413      * Set some Baes aside
1414      */
1415     function teamMint(address to, uint256 amountToMint) public onlyOwner {
1416         require(
1417             _tokenIds.current() + amountToMint <= MAX_HANA - TOTAL_RARES,
1418             "Exceed max supply of Baes"
1419         );
1420         require(
1421             countTeamMint + amountToMint <= totalTeamMint,
1422             "Exceed max TeamMint"
1423         );
1424         countTeamMint += amountToMint;
1425         for (uint256 i = 1; i <= amountToMint; i++) {
1426             _mintNFT(to);
1427         }
1428     }
1429 
1430     /**
1431      * Manually mint 1/1 rares afterward.
1432      */
1433     function rareMint(address to) public onlyOwner {
1434         require(countRareMint.current() < TOTAL_RARES, "Exceed max rareMint");
1435         countRareMint.increment();
1436         _mint(to, MAX_HANA - countRareMint.current() + 1);
1437     }
1438 
1439     /**
1440      * Get total minted of an address
1441      */
1442     function mintedOf(address minter) public view virtual returns (uint256) {
1443         return MINTED_WHITELIST[minter];
1444     }
1445 
1446     /**
1447      * Mints Baes
1448      */
1449     function mintWhitelist(
1450         uint256 availableToMint,
1451         uint256 amountToMint,
1452         bytes32[] calldata merkleProof
1453     ) public payable {
1454         require(saleIsActive, "Sale must be active to mint Bae");
1455         require(
1456             MINTED_WHITELIST[msg.sender] + amountToMint <= maxBaePurchase &&
1457                 MINTED_WHITELIST[msg.sender] + amountToMint <=
1458                 availableToMint &&
1459                 countMintedWhitelist.current() + amountToMint <=
1460                 totalWhitelistMint,
1461             "Trying to mint too many"
1462         );
1463         require(
1464             baePrice * amountToMint <= msg.value,
1465             "Ether value sent is not correct"
1466         );
1467         require(
1468             _tokenIds.current() + amountToMint <= MAX_HANA - TOTAL_RARES,
1469             "Purchase would exceed max supply of Baes"
1470         );
1471 
1472         // Verify the merkle proof.
1473         bytes32 node = keccak256(abi.encodePacked(msg.sender, availableToMint));
1474         require(
1475             MerkleProof.verify(merkleProof, merkleRoot, node),
1476             "Invalid Merkle Proof."
1477         );
1478 
1479         MINTED_WHITELIST[msg.sender] += amountToMint;
1480 
1481         for (uint256 i = 1; i <= amountToMint; i++) {
1482             countMintedWhitelist.increment();
1483             _mintNFT(msg.sender);
1484         }
1485     }
1486 
1487     function _mintNFT(address to) internal {
1488         uint256 newTokenId = _tokenIds.current() + 1;
1489         require(
1490             newTokenId <= MAX_HANA - TOTAL_RARES,
1491             "Exceed max supply of Baes"
1492         );
1493         _tokenIds.increment();
1494         _mint(to, newTokenId);
1495     }
1496 
1497     function _baseURI() internal view virtual override returns (string memory) {
1498         return baseURI;
1499     }
1500 
1501     /**
1502      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1503      */
1504     function isApprovedForAll(address owner, address operator)
1505         public
1506         view
1507         override
1508         returns (bool)
1509     {
1510         // Get a reference to OpenSea's proxy registry contract by instantiating
1511         // the contract using the already existing address.
1512         ProxyRegistry proxyRegistry = ProxyRegistry(
1513             openSeaProxyRegistryAddress
1514         );
1515         if (address(proxyRegistry.proxies(owner)) == operator) {
1516             return true;
1517         }
1518 
1519         return super.isApprovedForAll(owner, operator);
1520     }
1521 }
1522 
1523 // These contract definitions are used to create a reference to the OpenSea
1524 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1525 contract OwnableDelegateProxy {
1526 
1527 }
1528 
1529 contract ProxyRegistry {
1530     mapping(address => OwnableDelegateProxy) public proxies;
1531 }