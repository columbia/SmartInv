1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-01
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-26
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-02-22
11 */
12 
13 // SPDX-License-Identifier: MIT
14 // File: @openzeppelin/contracts/utils/Counters.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @title Counters
23  * @author Matt Condon (@shrugs)
24  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
25  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
26  *
27  * Include with `using Counters for Counters.Counter;`
28  */
29 library Counters {
30     struct Counter {
31         // This variable should never be directly accessed by users of the library: interactions must be restricted to
32         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
33         // this feature: see https://github.com/ethereum/solidity/issues/4637
34         uint256 _value; // default: 0
35     }
36 
37     function current(Counter storage counter) internal view returns (uint256) {
38         return counter._value;
39     }
40 
41     function increment(Counter storage counter) internal {
42         unchecked {
43             counter._value += 1;
44         }
45     }
46 
47     function decrement(Counter storage counter) internal {
48         uint256 value = counter._value;
49         require(value > 0, "Counter: decrement overflow");
50         unchecked {
51             counter._value = value - 1;
52         }
53     }
54 
55     function reset(Counter storage counter) internal {
56         counter._value = 0;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/Strings.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Context.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes calldata) {
153         return msg.data;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/access/Ownable.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 /**
166  * @dev Contract module which provides a basic access control mechanism, where
167  * there is an account (an owner) that can be granted exclusive access to
168  * specific functions.
169  *
170  * By default, the owner account will be the one that deploys the contract. This
171  * can later be changed with {transferOwnership}.
172  *
173  * This module is used through inheritance. It will make available the modifier
174  * `onlyOwner`, which can be applied to your functions to restrict their use to
175  * the owner.
176  */
177 abstract contract Ownable is Context {
178     address private _owner;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     /**
183      * @dev Initializes the contract setting the deployer as the initial owner.
184      */
185     constructor() {
186         _transferOwnership(_msgSender());
187     }
188 
189     /**
190      * @dev Returns the address of the current owner.
191      */
192     function owner() public view virtual returns (address) {
193         return _owner;
194     }
195 
196     /**
197      * @dev Throws if called by any account other than the owner.
198      */
199     modifier onlyOwner() {
200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
201         _;
202     }
203 
204     /**
205      * @dev Leaves the contract without owner. It will not be possible to call
206      * `onlyOwner` functions anymore. Can only be called by the current owner.
207      *
208      * NOTE: Renouncing ownership will leave the contract without an owner,
209      * thereby removing any functionality that is only available to the owner.
210      */
211     function renounceOwnership() public virtual onlyOwner {
212         _transferOwnership(address(0));
213     }
214 
215     /**
216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
217      * Can only be called by the current owner.
218      */
219     function transferOwnership(address newOwner) public virtual onlyOwner {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         _transferOwnership(newOwner);
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Internal function without access restriction.
227      */
228     function _transferOwnership(address newOwner) internal virtual {
229         address oldOwner = _owner;
230         _owner = newOwner;
231         emit OwnershipTransferred(oldOwner, newOwner);
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // This method relies on extcodesize, which returns 0 for contracts in
265         // construction, since the code is only stored at the end of the
266         // constructor execution.
267 
268         uint256 size;
269         assembly {
270             size := extcodesize(account)
271         }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         (bool success, ) = recipient.call{value: amount}("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain `call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         require(isContract(target), "Address: call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.call{value: value}(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal view returns (bytes memory) {
393         require(isContract(target), "Address: static call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.staticcall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(isContract(target), "Address: delegate call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.delegatecall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
428      * revert reason using the provided one.
429      *
430      * _Available since v4.3._
431      */
432     function verifyCallResult(
433         bool success,
434         bytes memory returndata,
435         string memory errorMessage
436     ) internal pure returns (bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443 
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 /**
463  * @title ERC721 token receiver interface
464  * @dev Interface for any contract that wants to support safeTransfers
465  * from ERC721 asset contracts.
466  */
467 interface IERC721Receiver {
468     /**
469      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
470      * by `operator` from `from`, this function is called.
471      *
472      * It must return its Solidity selector to confirm the token transfer.
473      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
474      *
475      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
476      */
477     function onERC721Received(
478         address operator,
479         address from,
480         uint256 tokenId,
481         bytes calldata data
482     ) external returns (bytes4);
483 }
484 
485 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev Interface of the ERC165 standard, as defined in the
494  * https://eips.ethereum.org/EIPS/eip-165[EIP].
495  *
496  * Implementers can declare support of contract interfaces, which can then be
497  * queried by others ({ERC165Checker}).
498  *
499  * For an implementation, see {ERC165}.
500  */
501 interface IERC165 {
502     /**
503      * @dev Returns true if this contract implements the interface defined by
504      * `interfaceId`. See the corresponding
505      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
506      * to learn more about how these ids are created.
507      *
508      * This function call must use less than 30 000 gas.
509      */
510     function supportsInterface(bytes4 interfaceId) external view returns (bool);
511 }
512 
513 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @dev Implementation of the {IERC165} interface.
523  *
524  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
525  * for the additional interface id that will be supported. For example:
526  *
527  * ```solidity
528  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
530  * }
531  * ```
532  *
533  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
534  */
535 abstract contract ERC165 is IERC165 {
536     /**
537      * @dev See {IERC165-supportsInterface}.
538      */
539     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540         return interfaceId == type(IERC165).interfaceId;
541     }
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Required interface of an ERC721 compliant contract.
554  */
555 interface IERC721 is IERC165 {
556     /**
557      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
558      */
559     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
563      */
564     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
565 
566     /**
567      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
568      */
569     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
570 
571     /**
572      * @dev Returns the number of tokens in ``owner``'s account.
573      */
574     function balanceOf(address owner) external view returns (uint256 balance);
575 
576     /**
577      * @dev Returns the owner of the `tokenId` token.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function ownerOf(uint256 tokenId) external view returns (address owner);
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
587      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must exist and be owned by `from`.
594      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
595      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
596      *
597      * Emits a {Transfer} event.
598      */
599     function safeTransferFrom(
600         address from,
601         address to,
602         uint256 tokenId
603     ) external;
604 
605     /**
606      * @dev Transfers `tokenId` token from `from` to `to`.
607      *
608      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must be owned by `from`.
615      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
616      *
617      * Emits a {Transfer} event.
618      */
619     function transferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
627      * The approval is cleared when the token is transferred.
628      *
629      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
630      *
631      * Requirements:
632      *
633      * - The caller must own the token or be an approved operator.
634      * - `tokenId` must exist.
635      *
636      * Emits an {Approval} event.
637      */
638     function approve(address to, uint256 tokenId) external;
639 
640     /**
641      * @dev Returns the account approved for `tokenId` token.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must exist.
646      */
647     function getApproved(uint256 tokenId) external view returns (address operator);
648 
649     /**
650      * @dev Approve or remove `operator` as an operator for the caller.
651      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
652      *
653      * Requirements:
654      *
655      * - The `operator` cannot be the caller.
656      *
657      * Emits an {ApprovalForAll} event.
658      */
659     function setApprovalForAll(address operator, bool _approved) external;
660 
661     /**
662      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
663      *
664      * See {setApprovalForAll}
665      */
666     function isApprovedForAll(address owner, address operator) external view returns (bool);
667 
668     /**
669      * @dev Safely transfers `tokenId` token from `from` to `to`.
670      *
671      * Requirements:
672      *
673      * - `from` cannot be the zero address.
674      * - `to` cannot be the zero address.
675      * - `tokenId` token must exist and be owned by `from`.
676      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678      *
679      * Emits a {Transfer} event.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 tokenId,
685         bytes calldata data
686     ) external;
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
699  * @dev See https://eips.ethereum.org/EIPS/eip-721
700  */
701 interface IERC721Metadata is IERC721 {
702     /**
703      * @dev Returns the token collection name.
704      */
705     function name() external view returns (string memory);
706 
707     /**
708      * @dev Returns the token collection symbol.
709      */
710     function symbol() external view returns (string memory);
711 
712     /**
713      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
714      */
715     function tokenURI(uint256 tokenId) external view returns (string memory);
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
719 
720 
721 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 
727 
728 
729 
730 
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata extension, but not including the Enumerable extension, which is available separately as
735  * {ERC721Enumerable}.
736  */
737 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
738     using Address for address;
739     using Strings for uint256;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to owner address
748     mapping(uint256 => address) private _owners;
749 
750     // Mapping owner address to token count
751     mapping(address => uint256) private _balances;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     /**
760      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
761      */
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
771         return
772             interfaceId == type(IERC721).interfaceId ||
773             interfaceId == type(IERC721Metadata).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view virtual override returns (uint256) {
781         require(owner != address(0), "ERC721: balance query for the zero address");
782         return _balances[owner];
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
789         address owner = _owners[tokenId];
790         require(owner != address(0), "ERC721: owner query for nonexistent token");
791         return owner;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overriden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return "";
825     }
826 
827     /**
828      * @dev See {IERC721-approve}.
829      */
830     function approve(address to, uint256 tokenId) public virtual override {
831         address owner = ERC721.ownerOf(tokenId);
832         require(to != owner, "ERC721: approval to current owner");
833 
834         require(
835             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
836             "ERC721: approve caller is not owner nor approved for all"
837         );
838 
839         _approve(to, tokenId);
840     }
841 
842     /**
843      * @dev See {IERC721-getApproved}.
844      */
845     function getApproved(uint256 tokenId) public view virtual override returns (address) {
846         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
847 
848         return _tokenApprovals[tokenId];
849     }
850 
851     /**
852      * @dev See {IERC721-setApprovalForAll}.
853      */
854     function setApprovalForAll(address operator, bool approved) public virtual override {
855         _setApprovalForAll(_msgSender(), operator, approved);
856     }
857 
858     /**
859      * @dev See {IERC721-isApprovedForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
862         return _operatorApprovals[owner][operator];
863     }
864 
865     /**
866      * @dev See {IERC721-transferFrom}.
867      */
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public virtual override {
873         //solhint-disable-next-line max-line-length
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
875 
876         _transfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         safeTransferFrom(from, to, tokenId, "");
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) public virtual override {
899         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
900         _safeTransfer(from, to, tokenId, _data);
901     }
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
908      *
909      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
910      * implement alternative mechanisms to perform token transfer, such as signature-based.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeTransfer(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) internal virtual {
927         _transfer(from, to, tokenId);
928         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
929     }
930 
931     /**
932      * @dev Returns whether `tokenId` exists.
933      *
934      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
935      *
936      * Tokens start existing when they are minted (`_mint`),
937      * and stop existing when they are burned (`_burn`).
938      */
939     function _exists(uint256 tokenId) internal view virtual returns (bool) {
940         return _owners[tokenId] != address(0);
941     }
942 
943     /**
944      * @dev Returns whether `spender` is allowed to manage `tokenId`.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must exist.
949      */
950     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
951         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
952         address owner = ERC721.ownerOf(tokenId);
953         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
954     }
955 
956     /**
957      * @dev Safely mints `tokenId` and transfers it to `to`.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must not exist.
962      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _safeMint(address to, uint256 tokenId) internal virtual {
967         _safeMint(to, tokenId, "");
968     }
969 
970     /**
971      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
972      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
973      */
974     function _safeMint(
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) internal virtual {
979         _mint(to, tokenId);
980         require(
981             _checkOnERC721Received(address(0), to, tokenId, _data),
982             "ERC721: transfer to non ERC721Receiver implementer"
983         );
984     }
985 
986     /**
987      * @dev Mints `tokenId` and transfers it to `to`.
988      *
989      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
990      *
991      * Requirements:
992      *
993      * - `tokenId` must not exist.
994      * - `to` cannot be the zero address.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _mint(address to, uint256 tokenId) internal virtual {
999         require(to != address(0), "ERC721: mint to the zero address");
1000         require(!_exists(tokenId), "ERC721: token already minted");
1001 
1002         _beforeTokenTransfer(address(0), to, tokenId);
1003 
1004         _balances[to] += 1;
1005         _owners[tokenId] = to;
1006 
1007         emit Transfer(address(0), to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev Destroys `tokenId`.
1012      * The approval is cleared when the token is burned.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _burn(uint256 tokenId) internal virtual {
1021         address owner = ERC721.ownerOf(tokenId);
1022 
1023         _beforeTokenTransfer(owner, address(0), tokenId);
1024 
1025         // Clear approvals
1026         _approve(address(0), tokenId);
1027 
1028         _balances[owner] -= 1;
1029         delete _owners[tokenId];
1030 
1031         emit Transfer(owner, address(0), tokenId);
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
1050         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
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
1063     }
1064 
1065     /**
1066      * @dev Approve `to` to operate on `tokenId`
1067      *
1068      * Emits a {Approval} event.
1069      */
1070     function _approve(address to, uint256 tokenId) internal virtual {
1071         _tokenApprovals[tokenId] = to;
1072         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Approve `operator` to operate on all of `owner` tokens
1077      *
1078      * Emits a {ApprovalForAll} event.
1079      */
1080     function _setApprovalForAll(
1081         address owner,
1082         address operator,
1083         bool approved
1084     ) internal virtual {
1085         require(owner != operator, "ERC721: approve to caller");
1086         _operatorApprovals[owner][operator] = approved;
1087         emit ApprovalForAll(owner, operator, approved);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108                 return retval == IERC721Receiver.onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert("ERC721: transfer to non ERC721Receiver implementer");
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` and `to` are never both zero.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {}
1142 }
1143 
1144 // File: contracts/KevinPunks.sol
1145 
1146 
1147 
1148 pragma solidity >=0.7.0 <0.9.0;
1149 
1150 
1151 
1152 
1153 contract TheSaudiBirds is ERC721, Ownable {
1154   using Strings for uint256;
1155   using Counters for Counters.Counter;
1156 
1157   Counters.Counter private supply;
1158 
1159   string public uriPrefix = "";
1160   string public uriSuffix = ".json";
1161   string public hiddenMetadataUri;
1162   
1163   uint256 public cost = 0 ether;
1164   uint256 public maxSupply = 3333;
1165   uint256 public maxMintAmountPerTx = 3;
1166   uint256 public freeMintAmount = 0;
1167   mapping(address => uint256) public addressMintedBalance;
1168 
1169   bool public paused = true;
1170   bool public revealed = true;
1171 
1172   constructor() ERC721("The Saudi Birds", "Saudi Birds") {
1173     setHiddenMetadataUri("ipfs://QmXaRgiSe8v3K7zC2bxngt5dmf8MUY6GiuPYuNYGnc81cv/1.json");
1174     setUriPrefix("ipfs://QmXaRgiSe8v3K7zC2bxngt5dmf8MUY6GiuPYuNYGnc81cv/");
1175     setRevealed(true);
1176   }
1177 
1178   modifier mintCompliance(uint256 _mintAmount) {
1179         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1180         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1181     _;
1182   }
1183 
1184   function totalSupply() public view returns (uint256) {
1185     return supply.current();
1186   }
1187 
1188   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1189     require(!paused, "The contract is paused!");
1190     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1191     _mintLoop(msg.sender, _mintAmount);
1192   }
1193   
1194   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1195     _mintLoop(_receiver, _mintAmount);
1196   }
1197 
1198   function walletOfOwner(address _owner)
1199     public
1200     view
1201     returns (uint256[] memory)
1202   {
1203     uint256 ownerTokenCount = balanceOf(_owner);
1204     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1205     uint256 currentTokenId = 1;
1206     uint256 ownedTokenIndex = 0;
1207 
1208     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1209       address currentTokenOwner = ownerOf(currentTokenId);
1210 
1211       if (currentTokenOwner == _owner) {
1212         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1213 
1214         ownedTokenIndex++;
1215       }
1216 
1217       currentTokenId++;
1218     }
1219 
1220     return ownedTokenIds;
1221   }
1222 
1223   function tokenURI(uint256 _tokenId)
1224     public
1225     view
1226     virtual
1227     override
1228     returns (string memory)
1229   {
1230     require(
1231       _exists(_tokenId),
1232       "ERC721Metadata: URI query for nonexistent token"
1233     );
1234 
1235     if (revealed == false) {
1236       return hiddenMetadataUri;
1237     }
1238 
1239     string memory currentBaseURI = _baseURI();
1240     return bytes(currentBaseURI).length > 0
1241         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1242         : "";
1243   }
1244 
1245   function setRevealed(bool _state) public onlyOwner {
1246     revealed = _state;
1247   }
1248 
1249   function setCost(uint256 _cost) public onlyOwner {
1250     cost = _cost;
1251   }
1252 
1253   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1254     maxMintAmountPerTx = _maxMintAmountPerTx;
1255   }
1256 
1257   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1258     hiddenMetadataUri = _hiddenMetadataUri;
1259   }
1260 
1261   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1262     uriPrefix = _uriPrefix;
1263   }
1264 
1265   function setFreeMintAmount(uint256 _freeMintAmount) public onlyOwner {
1266       freeMintAmount = _freeMintAmount;
1267   }
1268 
1269   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1270     uriSuffix = _uriSuffix;
1271   }
1272 
1273   function setPaused(bool _state) public onlyOwner {
1274     paused = _state;
1275   }
1276 
1277   function withdraw() public onlyOwner {
1278     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1279     require(os);
1280   }
1281 
1282   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1283     for (uint256 i = 0; i < _mintAmount; i++) {
1284       supply.increment();
1285       addressMintedBalance[msg.sender]++;
1286       _safeMint(_receiver, supply.current());
1287     }
1288   }
1289 
1290   function _baseURI() internal view virtual override returns (string memory) {
1291     return uriPrefix;
1292   }
1293 }