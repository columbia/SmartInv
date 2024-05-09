1 // SPDX-License-Identifier: MIT
2 
3 
4 // THE OG TUBBY MFERS
5 /**
6 6900 tubby mfers auto generated out of 111 different unique traits. 
7 
8 I mixed up the mfers world & tubby world together.
9 Ended up with these cute mfers. no discord, just cool art & mfer vibes. 
10 
11 Make cheap mints a norm. 
12 
13 20% of all profit from initial mint and secondary royalties gets transferred
14 to the mfers community tresauray for the love of the culture mfers.
15 */
16 
17 
18 
19 // File: @openzeppelin/contracts/utils/Counters.sol
20 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @title Counters
26  * @author Matt Condon (@shrugs)
27  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
28  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
29  *
30  * Include with `using Counters for Counters.Counter;`
31  */
32 library Counters {
33     struct Counter {
34         // This variable should never be directly accessed by users of the library: interactions must be restricted to
35         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
36         // this feature: see https://github.com/ethereum/solidity/issues/4637
37         uint256 _value; // default: 0
38     }
39 
40     function current(Counter storage counter) internal view returns (uint256) {
41         return counter._value;
42     }
43 
44     function increment(Counter storage counter) internal {
45         unchecked {
46             counter._value += 1;
47         }
48     }
49 
50     function decrement(Counter storage counter) internal {
51         uint256 value = counter._value;
52         require(value > 0, "Counter: decrement overflow");
53         unchecked {
54             counter._value = value - 1;
55         }
56     }
57 
58     function reset(Counter storage counter) internal {
59         counter._value = 0;
60     }
61 }
62 
63 // File: @openzeppelin/contracts/utils/Strings.sol
64 
65 
66 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev String operations.
72  */
73 library Strings {
74     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
78      */
79     function toString(uint256 value) internal pure returns (string memory) {
80         // Inspired by OraclizeAPI's implementation - MIT licence
81         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
82 
83         if (value == 0) {
84             return "0";
85         }
86         uint256 temp = value;
87         uint256 digits;
88         while (temp != 0) {
89             digits++;
90             temp /= 10;
91         }
92         bytes memory buffer = new bytes(digits);
93         while (value != 0) {
94             digits -= 1;
95             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
96             value /= 10;
97         }
98         return string(buffer);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
103      */
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
119      */
120     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
121         bytes memory buffer = new bytes(2 * length + 2);
122         buffer[0] = "0";
123         buffer[1] = "x";
124         for (uint256 i = 2 * length + 1; i > 1; --i) {
125             buffer[i] = _HEX_SYMBOLS[value & 0xf];
126             value >>= 4;
127         }
128         require(value == 0, "Strings: hex length insufficient");
129         return string(buffer);
130     }
131 }
132 
133 // File: @openzeppelin/contracts/utils/Context.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 abstract contract Context {
151     function _msgSender() internal view virtual returns (address) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view virtual returns (bytes calldata) {
156         return msg.data;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/access/Ownable.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 
168 /**
169  * @dev Contract module which provides a basic access control mechanism, where
170  * there is an account (an owner) that can be granted exclusive access to
171  * specific functions.
172  *
173  * By default, the owner account will be the one that deploys the contract. This
174  * can later be changed with {transferOwnership}.
175  *
176  * This module is used through inheritance. It will make available the modifier
177  * `onlyOwner`, which can be applied to your functions to restrict their use to
178  * the owner.
179  */
180 abstract contract Ownable is Context {
181     address private _owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     /**
186      * @dev Initializes the contract setting the deployer as the initial owner.
187      */
188     constructor() {
189         _transferOwnership(_msgSender());
190     }
191 
192     /**
193      * @dev Returns the address of the current owner.
194      */
195     function owner() public view virtual returns (address) {
196         return _owner;
197     }
198 
199     /**
200      * @dev Throws if called by any account other than the owner.
201      */
202     modifier onlyOwner() {
203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
204         _;
205     }
206 
207     /**
208      * @dev Leaves the contract without owner. It will not be possible to call
209      * `onlyOwner` functions anymore. Can only be called by the current owner.
210      *
211      * NOTE: Renouncing ownership will leave the contract without an owner,
212      * thereby removing any functionality that is only available to the owner.
213      */
214     function renounceOwnership() public virtual onlyOwner {
215         _transferOwnership(address(0));
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         _transferOwnership(newOwner);
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Internal function without access restriction.
230      */
231     function _transferOwnership(address newOwner) internal virtual {
232         address oldOwner = _owner;
233         _owner = newOwner;
234         emit OwnershipTransferred(oldOwner, newOwner);
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 
241 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
242 
243 pragma solidity ^0.8.1;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      *
266      * [IMPORTANT]
267      * ====
268      * You shouldn't rely on `isContract` to protect against flash loan attacks!
269      *
270      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
271      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
272      * constructor.
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize/address.code.length, which returns 0
277         // for contracts in construction, since the code is only stored at the end
278         // of the constructor execution.
279 
280         return account.code.length > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @title ERC721 token receiver interface
472  * @dev Interface for any contract that wants to support safeTransfers
473  * from ERC721 asset contracts.
474  */
475 interface IERC721Receiver {
476     /**
477      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
478      * by `operator` from `from`, this function is called.
479      *
480      * It must return its Solidity selector to confirm the token transfer.
481      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
482      *
483      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
484      */
485     function onERC721Received(
486         address operator,
487         address from,
488         uint256 tokenId,
489         bytes calldata data
490     ) external returns (bytes4);
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Interface of the ERC165 standard, as defined in the
502  * https://eips.ethereum.org/EIPS/eip-165[EIP].
503  *
504  * Implementers can declare support of contract interfaces, which can then be
505  * queried by others ({ERC165Checker}).
506  *
507  * For an implementation, see {ERC165}.
508  */
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Implementation of the {IERC165} interface.
531  *
532  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
533  * for the additional interface id that will be supported. For example:
534  *
535  * ```solidity
536  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
538  * }
539  * ```
540  *
541  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
542  */
543 abstract contract ERC165 is IERC165 {
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         return interfaceId == type(IERC165).interfaceId;
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
671      *
672      * See {setApprovalForAll}
673      */
674     function isApprovedForAll(address owner, address operator) external view returns (bool);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes calldata data
694     ) external;
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 
735 
736 
737 
738 
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension, but not including the Enumerable extension, which is available separately as
743  * {ERC721Enumerable}.
744  */
745 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to owner address
756     mapping(uint256 => address) private _owners;
757 
758     // Mapping owner address to token count
759     mapping(address => uint256) private _balances;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     /**
768      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
769      */
770     constructor(string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
779         return
780             interfaceId == type(IERC721).interfaceId ||
781             interfaceId == type(IERC721Metadata).interfaceId ||
782             super.supportsInterface(interfaceId);
783     }
784 
785     /**
786      * @dev See {IERC721-balanceOf}.
787      */
788     function balanceOf(address owner) public view virtual override returns (uint256) {
789         require(owner != address(0), "ERC721: balance query for the zero address");
790         return _balances[owner];
791     }
792 
793     /**
794      * @dev See {IERC721-ownerOf}.
795      */
796     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
797         address owner = _owners[tokenId];
798         require(owner != address(0), "ERC721: owner query for nonexistent token");
799         return owner;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
820         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
821 
822         string memory baseURI = _baseURI();
823         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
828      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
829      * by default, can be overriden in child contracts.
830      */
831     function _baseURI() internal view virtual returns (string memory) {
832         return "";
833     }
834 
835     /**
836      * @dev See {IERC721-approve}.
837      */
838     function approve(address to, uint256 tokenId) public virtual override {
839         address owner = ERC721.ownerOf(tokenId);
840         require(to != owner, "ERC721: approval to current owner");
841 
842         require(
843             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
844             "ERC721: approve caller is not owner nor approved for all"
845         );
846 
847         _approve(to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view virtual override returns (address) {
854         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         _setApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         //solhint-disable-next-line max-line-length
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883 
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, "");
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public virtual override {
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
908         _safeTransfer(from, to, tokenId, _data);
909     }
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
913      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
914      *
915      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
916      *
917      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
918      * implement alternative mechanisms to perform token transfer, such as signature-based.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _safeTransfer(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _transfer(from, to, tokenId);
936         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      * and stop existing when they are burned (`_burn`).
946      */
947     function _exists(uint256 tokenId) internal view virtual returns (bool) {
948         return _owners[tokenId] != address(0);
949     }
950 
951     /**
952      * @dev Returns whether `spender` is allowed to manage `tokenId`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
959         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
960         address owner = ERC721.ownerOf(tokenId);
961         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
962     }
963 
964     /**
965      * @dev Safely mints `tokenId` and transfers it to `to`.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _safeMint(address to, uint256 tokenId) internal virtual {
975         _safeMint(to, tokenId, "");
976     }
977 
978     /**
979      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
980      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
981      */
982     function _safeMint(
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) internal virtual {
987         _mint(to, tokenId);
988         require(
989             _checkOnERC721Received(address(0), to, tokenId, _data),
990             "ERC721: transfer to non ERC721Receiver implementer"
991         );
992     }
993 
994     /**
995      * @dev Mints `tokenId` and transfers it to `to`.
996      *
997      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - `to` cannot be the zero address.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(address to, uint256 tokenId) internal virtual {
1007         require(to != address(0), "ERC721: mint to the zero address");
1008         require(!_exists(tokenId), "ERC721: token already minted");
1009 
1010         _beforeTokenTransfer(address(0), to, tokenId);
1011 
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(address(0), to, tokenId);
1016 
1017         _afterTokenTransfer(address(0), to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Destroys `tokenId`.
1022      * The approval is cleared when the token is burned.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must exist.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _burn(uint256 tokenId) internal virtual {
1031         address owner = ERC721.ownerOf(tokenId);
1032 
1033         _beforeTokenTransfer(owner, address(0), tokenId);
1034 
1035         // Clear approvals
1036         _approve(address(0), tokenId);
1037 
1038         _balances[owner] -= 1;
1039         delete _owners[tokenId];
1040 
1041         emit Transfer(owner, address(0), tokenId);
1042 
1043         _afterTokenTransfer(owner, address(0), tokenId);
1044     }
1045 
1046     /**
1047      * @dev Transfers `tokenId` from `from` to `to`.
1048      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must be owned by `from`.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual {
1062         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1063         require(to != address(0), "ERC721: transfer to the zero address");
1064 
1065         _beforeTokenTransfer(from, to, tokenId);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId);
1069 
1070         _balances[from] -= 1;
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(from, to, tokenId);
1075 
1076         _afterTokenTransfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits a {Approval} event.
1083      */
1084     function _approve(address to, uint256 tokenId) internal virtual {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Approve `operator` to operate on all of `owner` tokens
1091      *
1092      * Emits a {ApprovalForAll} event.
1093      */
1094     function _setApprovalForAll(
1095         address owner,
1096         address operator,
1097         bool approved
1098     ) internal virtual {
1099         require(owner != operator, "ERC721: approve to caller");
1100         _operatorApprovals[owner][operator] = approved;
1101         emit ApprovalForAll(owner, operator, approved);
1102     }
1103 
1104     /**
1105      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1106      * The call is not executed if the target address is not a contract.
1107      *
1108      * @param from address representing the previous owner of the given token ID
1109      * @param to target address that will receive the tokens
1110      * @param tokenId uint256 ID of the token to be transferred
1111      * @param _data bytes optional data to send along with the call
1112      * @return bool whether the call correctly returned the expected magic value
1113      */
1114     function _checkOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         if (to.isContract()) {
1121             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1122                 return retval == IERC721Receiver.onERC721Received.selector;
1123             } catch (bytes memory reason) {
1124                 if (reason.length == 0) {
1125                     revert("ERC721: transfer to non ERC721Receiver implementer");
1126                 } else {
1127                     assembly {
1128                         revert(add(32, reason), mload(reason))
1129                     }
1130                 }
1131             }
1132         } else {
1133             return true;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Hook that is called before any token transfer. This includes minting
1139      * and burning.
1140      *
1141      * Calling conditions:
1142      *
1143      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1144      * transferred to `to`.
1145      * - When `from` is zero, `tokenId` will be minted for `to`.
1146      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1147      * - `from` and `to` are never both zero.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _beforeTokenTransfer(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) internal virtual {}
1156 
1157     /**
1158      * @dev Hook that is called after any transfer of tokens. This includes
1159      * minting and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - when `from` and `to` are both non-zero.
1164      * - `from` and `to` are never both zero.
1165      *
1166      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1167      */
1168     function _afterTokenTransfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) internal virtual {}
1173 }
1174 
1175 // File: contracts/TubbyMFERSOG.sol
1176 
1177 
1178 
1179 pragma solidity >=0.7.0 <0.9.0;
1180 
1181 
1182 
1183 
1184 contract TubbyMFERSOG is ERC721, Ownable {
1185   using Strings for uint256;
1186   using Counters for Counters.Counter;
1187 
1188   Counters.Counter private supply;
1189 
1190   string public uriPrefix = "ipfs://QmQDAEGqfEZKBCsNnXWqGKx997yLs3CkmdW3g2SxpJUBEh/";
1191   string public uriSuffix = ".json";
1192   
1193   uint256 public cost = 0.0069 ether;
1194   uint256 public maxSupply = 6900;
1195   uint256 public maxMintAmountPerTx = 10;
1196   uint256 public maxMintAmountPerWallet = 10;
1197 
1198   bool public paused = false;
1199   
1200   mapping (address => uint256) public addressMintedBalance;
1201 
1202   constructor() ERC721("TUBBYMFERSOG", "TMFERSOG") {
1203   }
1204 
1205   modifier mintCompliance(uint256 _mintAmount) {
1206     if (msg.sender != owner()) {
1207     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1208     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1209     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1210     require (ownerMintedCount + _mintAmount <= maxMintAmountPerWallet, "max per address exceeded!");
1211     }
1212     _;
1213   }
1214 
1215   function totalSupply() public view returns (uint256) {
1216     return supply.current();
1217   }
1218 
1219   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1220     require(!paused, "The contract is paused!");
1221     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1222 
1223     _mintLoop(msg.sender, _mintAmount);
1224   }
1225   
1226   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1227     _mintLoop(_receiver, _mintAmount);
1228   }
1229 
1230   function walletOfOwner(address _owner)
1231     public
1232     view
1233     returns (uint256[] memory)
1234   {
1235     uint256 ownerTokenCount = balanceOf(_owner);
1236     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1237     uint256 currentTokenId = 1;
1238     uint256 ownedTokenIndex = 0;
1239 
1240     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1241       address currentTokenOwner = ownerOf(currentTokenId);
1242 
1243       if (currentTokenOwner == _owner) {
1244         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1245 
1246         ownedTokenIndex++;
1247       }
1248 
1249       currentTokenId++;
1250     }
1251 
1252     return ownedTokenIds;
1253   }
1254 
1255   function tokenURI(uint256 _tokenId)
1256     public
1257     view
1258     virtual
1259     override
1260     returns (string memory)
1261   {
1262     require(
1263       _exists(_tokenId),
1264       "ERC721Metadata: URI query for nonexistent token"
1265     );
1266 
1267     string memory currentBaseURI = _baseURI();
1268     return bytes(currentBaseURI).length > 0
1269         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1270         : "";
1271   }
1272 
1273   function setCost(uint256 _cost) public onlyOwner {
1274     cost = _cost;
1275   }
1276 
1277   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1278     maxMintAmountPerTx = _maxMintAmountPerTx;
1279   }
1280   
1281   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1282     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1283   }
1284 
1285   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1286     uriPrefix = _uriPrefix;
1287   }
1288 
1289   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1290     uriSuffix = _uriSuffix;
1291   }
1292 
1293   function setPaused(bool _state) public onlyOwner {
1294     paused = _state;
1295   }
1296 
1297   function withdraw() public onlyOwner {
1298     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1299     require(os);
1300   }
1301 
1302   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1303     for (uint256 i = 0; i < _mintAmount; i++) {
1304         addressMintedBalance[msg.sender]++;
1305         supply.increment();
1306          _safeMint(_receiver, supply.current());
1307     }
1308   }
1309 
1310   function _baseURI() internal view virtual override returns (string memory) {
1311     return uriPrefix;
1312   }
1313 }