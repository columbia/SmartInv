1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _setOwner(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _setOwner(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _setOwner(newOwner);
160     }
161 
162     function _setOwner(address newOwner) private {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: @openzeppelin/contracts/security/Pausable.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @dev Contract module which allows children to implement an emergency stop
178  * mechanism that can be triggered by an authorized account.
179  *
180  * This module is used through inheritance. It will make available the
181  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
182  * the functions of your contract. Note that they will not be pausable by
183  * simply including this module, only once the modifiers are put in place.
184  */
185 abstract contract Pausable is Context {
186     /**
187      * @dev Emitted when the pause is triggered by `account`.
188      */
189     event Paused(address account);
190 
191     /**
192      * @dev Emitted when the pause is lifted by `account`.
193      */
194     event Unpaused(address account);
195 
196     bool private _paused;
197 
198     /**
199      * @dev Initializes the contract in unpaused state.
200      */
201     constructor() {
202         _paused = false;
203     }
204 
205     /**
206      * @dev Returns true if the contract is paused, and false otherwise.
207      */
208     function paused() public view virtual returns (bool) {
209         return _paused;
210     }
211 
212     /**
213      * @dev Modifier to make a function callable only when the contract is not paused.
214      *
215      * Requirements:
216      *
217      * - The contract must not be paused.
218      */
219     modifier whenNotPaused() {
220         require(!paused(), "Pausable: paused");
221         _;
222     }
223 
224     /**
225      * @dev Modifier to make a function callable only when the contract is paused.
226      *
227      * Requirements:
228      *
229      * - The contract must be paused.
230      */
231     modifier whenPaused() {
232         require(paused(), "Pausable: not paused");
233         _;
234     }
235 
236     /**
237      * @dev Triggers stopped state.
238      *
239      * Requirements:
240      *
241      * - The contract must not be paused.
242      */
243     function _pause() internal virtual whenNotPaused {
244         _paused = true;
245         emit Paused(_msgSender());
246     }
247 
248     /**
249      * @dev Returns to normal state.
250      *
251      * Requirements:
252      *
253      * - The contract must be paused.
254      */
255     function _unpause() internal virtual whenPaused {
256         _paused = false;
257         emit Unpaused(_msgSender());
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies on extcodesize, which returns 0 for contracts in
290         // construction, since the code is only stored at the end of the
291         // constructor execution.
292 
293         uint256 size;
294         assembly {
295             size := extcodesize(account)
296         }
297         return size > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
481 
482 
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Interface of the ERC165 standard, as defined in the
517  * https://eips.ethereum.org/EIPS/eip-165[EIP].
518  *
519  * Implementers can declare support of contract interfaces, which can then be
520  * queried by others ({ERC165Checker}).
521  *
522  * For an implementation, see {ERC165}.
523  */
524 interface IERC165 {
525     /**
526      * @dev Returns true if this contract implements the interface defined by
527      * `interfaceId`. See the corresponding
528      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
529      * to learn more about how these ids are created.
530      *
531      * This function call must use less than 30 000 gas.
532      */
533     function supportsInterface(bytes4 interfaceId) external view returns (bool);
534 }
535 
536 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
537 
538 
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
567 
568 
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @dev Required interface of an ERC721 compliant contract.
575  */
576 interface IERC721 is IERC165 {
577     /**
578      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
579      */
580     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
584      */
585     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
586 
587     /**
588      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
589      */
590     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
591 
592     /**
593      * @dev Returns the number of tokens in ``owner``'s account.
594      */
595     function balanceOf(address owner) external view returns (uint256 balance);
596 
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) external view returns (address owner);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Transfers `tokenId` token from `from` to `to`.
628      *
629      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) external;
645 
646     /**
647      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
648      * The approval is cleared when the token is transferred.
649      *
650      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
651      *
652      * Requirements:
653      *
654      * - The caller must own the token or be an approved operator.
655      * - `tokenId` must exist.
656      *
657      * Emits an {Approval} event.
658      */
659     function approve(address to, uint256 tokenId) external;
660 
661     /**
662      * @dev Returns the account approved for `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function getApproved(uint256 tokenId) external view returns (address operator);
669 
670     /**
671      * @dev Approve or remove `operator` as an operator for the caller.
672      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
673      *
674      * Requirements:
675      *
676      * - The `operator` cannot be the caller.
677      *
678      * Emits an {ApprovalForAll} event.
679      */
680     function setApprovalForAll(address operator, bool _approved) external;
681 
682     /**
683      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
684      *
685      * See {setApprovalForAll}
686      */
687     function isApprovedForAll(address owner, address operator) external view returns (bool);
688 
689     /**
690      * @dev Safely transfers `tokenId` token from `from` to `to`.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId,
706         bytes calldata data
707     ) external;
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
711 
712 
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Metadata is IERC721 {
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
739 
740 
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
874         require(operator != _msgSender(), "ERC721: approve to caller");
875 
876         _operatorApprovals[_msgSender()][operator] = approved;
877         emit ApprovalForAll(_msgSender(), operator, approved);
878     }
879 
880     /**
881      * @dev See {IERC721-isApprovedForAll}.
882      */
883     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
884         return _operatorApprovals[owner][operator];
885     }
886 
887     /**
888      * @dev See {IERC721-transferFrom}.
889      */
890     function transferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         //solhint-disable-next-line max-line-length
896         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
897 
898         _transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         safeTransferFrom(from, to, tokenId, "");
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public virtual override {
921         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
922         _safeTransfer(from, to, tokenId, _data);
923     }
924 
925     /**
926      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
927      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
928      *
929      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
930      *
931      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
932      * implement alternative mechanisms to perform token transfer, such as signature-based.
933      *
934      * Requirements:
935      *
936      * - `from` cannot be the zero address.
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must exist and be owned by `from`.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeTransfer(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _transfer(from, to, tokenId);
950         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
951     }
952 
953     /**
954      * @dev Returns whether `tokenId` exists.
955      *
956      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
957      *
958      * Tokens start existing when they are minted (`_mint`),
959      * and stop existing when they are burned (`_burn`).
960      */
961     function _exists(uint256 tokenId) internal view virtual returns (bool) {
962         return _owners[tokenId] != address(0);
963     }
964 
965     /**
966      * @dev Returns whether `spender` is allowed to manage `tokenId`.
967      *
968      * Requirements:
969      *
970      * - `tokenId` must exist.
971      */
972     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
973         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
974         address owner = ERC721.ownerOf(tokenId);
975         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
976     }
977 
978     /**
979      * @dev Safely mints `tokenId` and transfers it to `to`.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must not exist.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeMint(address to, uint256 tokenId) internal virtual {
989         _safeMint(to, tokenId, "");
990     }
991 
992     /**
993      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
994      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
995      */
996     function _safeMint(
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) internal virtual {
1001         _mint(to, tokenId);
1002         require(
1003             _checkOnERC721Received(address(0), to, tokenId, _data),
1004             "ERC721: transfer to non ERC721Receiver implementer"
1005         );
1006     }
1007 
1008     /**
1009      * @dev Mints `tokenId` and transfers it to `to`.
1010      *
1011      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must not exist.
1016      * - `to` cannot be the zero address.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _mint(address to, uint256 tokenId) internal virtual {
1021         require(to != address(0), "ERC721: mint to the zero address");
1022         require(!_exists(tokenId), "ERC721: token already minted");
1023 
1024         _beforeTokenTransfer(address(0), to, tokenId);
1025 
1026         _balances[to] += 1;
1027         _owners[tokenId] = to;
1028 
1029         emit Transfer(address(0), to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Destroys `tokenId`.
1034      * The approval is cleared when the token is burned.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _burn(uint256 tokenId) internal virtual {
1043         address owner = ERC721.ownerOf(tokenId);
1044 
1045         _beforeTokenTransfer(owner, address(0), tokenId);
1046 
1047         // Clear approvals
1048         _approve(address(0), tokenId);
1049 
1050         _balances[owner] -= 1;
1051         delete _owners[tokenId];
1052 
1053         emit Transfer(owner, address(0), tokenId);
1054     }
1055 
1056     /**
1057      * @dev Transfers `tokenId` from `from` to `to`.
1058      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _transfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) internal virtual {
1072         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1073         require(to != address(0), "ERC721: transfer to the zero address");
1074 
1075         _beforeTokenTransfer(from, to, tokenId);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId);
1079 
1080         _balances[from] -= 1;
1081         _balances[to] += 1;
1082         _owners[tokenId] = to;
1083 
1084         emit Transfer(from, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Approve `to` to operate on `tokenId`
1089      *
1090      * Emits a {Approval} event.
1091      */
1092     function _approve(address to, uint256 tokenId) internal virtual {
1093         _tokenApprovals[tokenId] = to;
1094         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1099      * The call is not executed if the target address is not a contract.
1100      *
1101      * @param from address representing the previous owner of the given token ID
1102      * @param to target address that will receive the tokens
1103      * @param tokenId uint256 ID of the token to be transferred
1104      * @param _data bytes optional data to send along with the call
1105      * @return bool whether the call correctly returned the expected magic value
1106      */
1107     function _checkOnERC721Received(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) private returns (bool) {
1113         if (to.isContract()) {
1114             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1115                 return retval == IERC721Receiver.onERC721Received.selector;
1116             } catch (bytes memory reason) {
1117                 if (reason.length == 0) {
1118                     revert("ERC721: transfer to non ERC721Receiver implementer");
1119                 } else {
1120                     assembly {
1121                         revert(add(32, reason), mload(reason))
1122                     }
1123                 }
1124             }
1125         } else {
1126             return true;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before any token transfer. This includes minting
1132      * and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1140      * - `from` and `to` are never both zero.
1141      *
1142      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1143      */
1144     function _beforeTokenTransfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) internal virtual {}
1149 }
1150 
1151 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1152 
1153 
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 
1158 /**
1159  * @dev ERC721 token with storage based token URI management.
1160  */
1161 abstract contract ERC721URIStorage is ERC721 {
1162     using Strings for uint256;
1163 
1164     // Optional mapping for token URIs
1165     mapping(uint256 => string) private _tokenURIs;
1166 
1167     /**
1168      * @dev See {IERC721Metadata-tokenURI}.
1169      */
1170     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1171         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1172 
1173         string memory _tokenURI = _tokenURIs[tokenId];
1174         string memory base = _baseURI();
1175 
1176         // If there is no base URI, return the token URI.
1177         if (bytes(base).length == 0) {
1178             return _tokenURI;
1179         }
1180         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1181         if (bytes(_tokenURI).length > 0) {
1182             return string(abi.encodePacked(base, _tokenURI));
1183         }
1184 
1185         return super.tokenURI(tokenId);
1186     }
1187 
1188     /**
1189      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      */
1195     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1196         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1197         _tokenURIs[tokenId] = _tokenURI;
1198     }
1199 
1200     /**
1201      * @dev Destroys `tokenId`.
1202      * The approval is cleared when the token is burned.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must exist.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _burn(uint256 tokenId) internal virtual override {
1211         super._burn(tokenId);
1212 
1213         if (bytes(_tokenURIs[tokenId]).length != 0) {
1214             delete _tokenURIs[tokenId];
1215         }
1216     }
1217 }
1218 
1219 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1220 
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 
1226 
1227 /**
1228  * @dev ERC721 token with pausable token transfers, minting and burning.
1229  *
1230  * Useful for scenarios such as preventing trades until the end of an evaluation
1231  * period, or having an emergency switch for freezing all token transfers in the
1232  * event of a large bug.
1233  */
1234 abstract contract ERC721Pausable is ERC721, Pausable {
1235     /**
1236      * @dev See {ERC721-_beforeTokenTransfer}.
1237      *
1238      * Requirements:
1239      *
1240      * - the contract must not be paused.
1241      */
1242     function _beforeTokenTransfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual override {
1247         super._beforeTokenTransfer(from, to, tokenId);
1248 
1249         require(!paused(), "ERC721Pausable: token transfer while paused");
1250     }
1251 }
1252 
1253 // File: @openzeppelin/contracts/utils/Counters.sol
1254 
1255 
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 /**
1260  * @title Counters
1261  * @author Matt Condon (@shrugs)
1262  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1263  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1264  *
1265  * Include with `using Counters for Counters.Counter;`
1266  */
1267 library Counters {
1268     struct Counter {
1269         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1270         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1271         // this feature: see https://github.com/ethereum/solidity/issues/4637
1272         uint256 _value; // default: 0
1273     }
1274 
1275     function current(Counter storage counter) internal view returns (uint256) {
1276         return counter._value;
1277     }
1278 
1279     function increment(Counter storage counter) internal {
1280         unchecked {
1281             counter._value += 1;
1282         }
1283     }
1284 
1285     function decrement(Counter storage counter) internal {
1286         uint256 value = counter._value;
1287         require(value > 0, "Counter: decrement overflow");
1288         unchecked {
1289             counter._value = value - 1;
1290         }
1291     }
1292 
1293     function reset(Counter storage counter) internal {
1294         counter._value = 0;
1295     }
1296 }
1297 
1298 // File: contracts/TKN.sol
1299 
1300 
1301 pragma solidity ^0.8.0;
1302 
1303 
1304 
1305 
1306 
1307 contract tkn is ERC721, ERC721URIStorage, Pausable, Ownable {
1308     using Address for address;
1309     using Counters for Counters.Counter;
1310 
1311     Counters.Counter private _tokenIdCounter;
1312 
1313     uint256 public maxSupply = 10000;
1314     uint256 public price = 80000000000000000;
1315     bool public saleOpen = false;
1316     bool public presaleOpen = false;
1317     string public baseURI;
1318 
1319     mapping(address => uint256) public Whitelist;
1320 
1321     receive() external payable {}
1322 
1323     constructor() ERC721('Gen-I K-Noids', 'TKN') {
1324     }
1325 
1326     function mint(uint256 amount) public payable {
1327         require(!Address.isContract(msg.sender), "Contracts are not allowed to mint");
1328         require(msg.value >= price * amount, 'Not enough was paid');
1329 
1330         if (!saleOpen) {
1331             require(presaleOpen == true, 'Presale is not open');
1332             uint256 who = Whitelist[msg.sender];
1333             require(who > 0, 'This address is not whitelisted for the presale');
1334             require(amount <= who, 'This address is not allowed to mint that many during the presale');
1335             for (uint256 i = 0; i < amount; i++) 
1336                 internalMint(msg.sender);
1337                 Whitelist[msg.sender] = who - amount;
1338             return;
1339         }
1340 
1341         require(amount <= 10, 'Only 10 per transaction allowed');
1342         for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1343     }
1344 
1345     function internalMint(address to) internal {
1346         require(_tokenIdCounter.current() < maxSupply, 'Supply depleted');
1347          _tokenIdCounter.increment();
1348         _safeMint(to, _tokenIdCounter.current());
1349     }
1350 
1351     function whitelistAddress(address[] memory who, uint256 amount) public onlyOwner {
1352         for (uint256 i = 0; i < who.length; i++) Whitelist[who[i]] = amount;
1353     }
1354 
1355     function withdraw() public onlyOwner {
1356         uint256 balance = address(this).balance;
1357         payable(owner()).transfer(balance);
1358     }
1359 
1360     function pause() public onlyOwner {
1361         _pause();
1362     }
1363 
1364     function unpause() public onlyOwner {
1365         _unpause();
1366     }
1367 
1368     function toggleSale() public onlyOwner {
1369         saleOpen = !saleOpen;
1370     }
1371 
1372     function togglePresale() public onlyOwner {
1373         presaleOpen = !presaleOpen;
1374     }
1375 
1376     function setBaseURI(string memory newBaseURI) public onlyOwner {
1377         baseURI = newBaseURI;
1378     }
1379 
1380     function setPrice(uint256 newPrice) public onlyOwner {
1381         price = newPrice;
1382     }
1383 
1384     function _baseURI() internal view override returns (string memory) {
1385         return baseURI;
1386     }
1387 
1388     function safeMint(address to) public onlyOwner {
1389         internalMint(to);
1390     }
1391 
1392     // The following functions are overrides required by Solidity.
1393     function _beforeTokenTransfer(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) internal override(ERC721) whenNotPaused {
1398         super._beforeTokenTransfer(from, to, tokenId);
1399     }
1400 
1401     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1402         super._burn(tokenId);
1403     }
1404 
1405     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1406         return super.tokenURI(tokenId);
1407     }
1408 
1409     function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1410         return super.supportsInterface(interfaceId);
1411     }
1412 }