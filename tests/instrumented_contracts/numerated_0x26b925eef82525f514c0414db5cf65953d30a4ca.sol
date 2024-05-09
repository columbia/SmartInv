1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 pragma solidity ^0.8.0;
27 /**
28  * @dev Contract module which allows children to implement an emergency stop
29  * mechanism that can be triggered by an authorized account.
30  *
31  * This module is used through inheritance. It will make available the
32  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
33  * the functions of your contract. Note that they will not be pausable by
34  * simply including this module, only once the modifiers are put in place.
35  */
36 abstract contract Pausable is Context {
37     /**
38      * @dev Emitted when the pause is triggered by `account`.
39      */
40     event Paused(address account);
41 
42     /**
43      * @dev Emitted when the pause is lifted by `account`.
44      */
45     event Unpaused(address account);
46 
47     bool private _paused;
48 
49     /**
50      * @dev Initializes the contract in unpaused state.
51      */
52     constructor() {
53         _paused = false;
54     }
55 
56     /**
57      * @dev Returns true if the contract is paused, and false otherwise.
58      */
59     function paused() public view virtual returns (bool) {
60         return _paused;
61     }
62 
63     /**
64      * @dev Modifier to make a function callable only when the contract is not paused.
65      *
66      * Requirements:
67      *
68      * - The contract must not be paused.
69      */
70     modifier whenNotPaused() {
71         require(!paused(), "Pausable: paused");
72         _;
73     }
74 
75     /**
76      * @dev Modifier to make a function callable only when the contract is paused.
77      *
78      * Requirements:
79      *
80      * - The contract must be paused.
81      */
82     modifier whenPaused() {
83         require(paused(), "Pausable: not paused");
84         _;
85     }
86 
87     /**
88      * @dev Triggers stopped state.
89      *
90      * Requirements:
91      *
92      * - The contract must not be paused.
93      */
94     function _pause() internal virtual whenNotPaused {
95         _paused = true;
96         emit Paused(_msgSender());
97     }
98 
99     /**
100      * @dev Returns to normal state.
101      *
102      * Requirements:
103      *
104      * - The contract must be paused.
105      */
106     function _unpause() internal virtual whenPaused {
107         _paused = false;
108         emit Unpaused(_msgSender());
109     }
110 }
111 
112 // File: @openzeppelin/contracts/access/Ownable.sol
113 pragma solidity ^0.8.0;
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _setOwner(_msgSender());
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         _setOwner(address(0));
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         _setOwner(newOwner);
171     }
172 
173     function _setOwner(address newOwner) private {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 
181 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Interface of the ERC165 standard, as defined in the
186  * https://eips.ethereum.org/EIPS/eip-165[EIP].
187  *
188  * Implementers can declare support of contract interfaces, which can then be
189  * queried by others ({ERC165Checker}).
190  *
191  * For an implementation, see {ERC165}.
192  */
193 interface IERC165 {
194     /**
195      * @dev Returns true if this contract implements the interface defined by
196      * `interfaceId`. See the corresponding
197      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
198      * to learn more about how these ids are created.
199      *
200      * This function call must use less than 30 000 gas.
201      */
202     function supportsInterface(bytes4 interfaceId) external view returns (bool);
203 }
204 
205 
206 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
207 pragma solidity ^0.8.0;
208 
209 
210 /**
211  * @dev Implementation of the {IERC165} interface.
212  *
213  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
214  * for the additional interface id that will be supported. For example:
215  *
216  * ```solidity
217  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
218  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
219  * }
220  * ```
221  *
222  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
223  */
224 abstract contract ERC165 is IERC165 {
225     /**
226      * @dev See {IERC165-supportsInterface}.
227      */
228     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
229         return interfaceId == type(IERC165).interfaceId;
230     }
231 }
232 
233 
234 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
235 pragma solidity ^0.8.0;
236 /**
237  * @dev Required interface of an ERC721 compliant contract.
238  */
239 interface IERC721 is IERC165 {
240     /**
241      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
242      */
243     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
244 
245     /**
246      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
247      */
248     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
249 
250     /**
251      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
252      */
253     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
254 
255     /**
256      * @dev Returns the number of tokens in ``owner``'s account.
257      */
258     function balanceOf(address owner) external view returns (uint256 balance);
259 
260     /**
261      * @dev Returns the owner of the `tokenId` token.
262      *
263      * Requirements:
264      *
265      * - `tokenId` must exist.
266      */
267     function ownerOf(uint256 tokenId) external view returns (address owner);
268 
269     /**
270      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
271      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must exist and be owned by `from`.
278      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
279      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
280      *
281      * Emits a {Transfer} event.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external;
288 
289     /**
290      * @dev Transfers `tokenId` token from `from` to `to`.
291      *
292      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     /**
310      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
311      * The approval is cleared when the token is transferred.
312      *
313      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
314      *
315      * Requirements:
316      *
317      * - The caller must own the token or be an approved operator.
318      * - `tokenId` must exist.
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address to, uint256 tokenId) external;
323 
324     /**
325      * @dev Returns the account approved for `tokenId` token.
326      *
327      * Requirements:
328      *
329      * - `tokenId` must exist.
330      */
331     function getApproved(uint256 tokenId) external view returns (address operator);
332 
333     /**
334      * @dev Approve or remove `operator` as an operator for the caller.
335      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
336      *
337      * Requirements:
338      *
339      * - The `operator` cannot be the caller.
340      *
341      * Emits an {ApprovalForAll} event.
342      */
343     function setApprovalForAll(address operator, bool _approved) external;
344 
345     /**
346      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
347      *
348      * See {setApprovalForAll}
349      */
350     function isApprovedForAll(address owner, address operator) external view returns (bool);
351 
352     /**
353      * @dev Safely transfers `tokenId` token from `from` to `to`.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must exist and be owned by `from`.
360      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
362      *
363      * Emits a {Transfer} event.
364      */
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId,
369         bytes calldata data
370     ) external;
371 }
372 
373 
374 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
375 pragma solidity ^0.8.0;
376 /**
377  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
378  * @dev See https://eips.ethereum.org/EIPS/eip-721
379  */
380 interface IERC721Enumerable is IERC721 {
381     /**
382      * @dev Returns the total amount of tokens stored by the contract.
383      */
384     function totalSupply() external view returns (uint256);
385 
386     /**
387      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
388      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
389      */
390     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
391 
392     /**
393      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
394      * Use along with {totalSupply} to enumerate all tokens.
395      */
396     function tokenByIndex(uint256 index) external view returns (uint256);
397 }
398 
399 
400 // File: @openzeppelin/contracts/utils/Strings.sol
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev String operations.
405  */
406 library Strings {
407     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
411      */
412     function toString(uint256 value) internal pure returns (string memory) {
413         // Inspired by OraclizeAPI's implementation - MIT licence
414         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
415 
416         if (value == 0) {
417             return "0";
418         }
419         uint256 temp = value;
420         uint256 digits;
421         while (temp != 0) {
422             digits++;
423             temp /= 10;
424         }
425         bytes memory buffer = new bytes(digits);
426         while (value != 0) {
427             digits -= 1;
428             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
429             value /= 10;
430         }
431         return string(buffer);
432     }
433 
434     /**
435      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
436      */
437     function toHexString(uint256 value) internal pure returns (string memory) {
438         if (value == 0) {
439             return "0x00";
440         }
441         uint256 temp = value;
442         uint256 length = 0;
443         while (temp != 0) {
444             length++;
445             temp >>= 8;
446         }
447         return toHexString(value, length);
448     }
449 
450     /**
451      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
452      */
453     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
454         bytes memory buffer = new bytes(2 * length + 2);
455         buffer[0] = "0";
456         buffer[1] = "x";
457         for (uint256 i = 2 * length + 1; i > 1; --i) {
458             buffer[i] = _HEX_SYMBOLS[value & 0xf];
459             value >>= 4;
460         }
461         require(value == 0, "Strings: hex length insufficient");
462         return string(buffer);
463     }
464 }
465 
466 // File: @openzeppelin/contracts/utils/Address.sol
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Collection of functions related to the address type
471  */
472 library Address {
473     /**
474      * @dev Returns true if `account` is a contract.
475      *
476      * [IMPORTANT]
477      * ====
478      * It is unsafe to assume that an address for which this function returns
479      * false is an externally-owned account (EOA) and not a contract.
480      *
481      * Among others, `isContract` will return false for the following
482      * types of addresses:
483      *
484      *  - an externally-owned account
485      *  - a contract in construction
486      *  - an address where a contract will be created
487      *  - an address where a contract lived, but was destroyed
488      * ====
489      */
490     function isContract(address account) internal view returns (bool) {
491         // This method relies on extcodesize, which returns 0 for contracts in
492         // construction, since the code is only stored at the end of the
493         // constructor execution.
494 
495         uint256 size;
496         assembly {
497             size := extcodesize(account)
498         }
499         return size > 0;
500     }
501 
502     /**
503      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
504      * `recipient`, forwarding all available gas and reverting on errors.
505      *
506      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
507      * of certain opcodes, possibly making contracts go over the 2300 gas limit
508      * imposed by `transfer`, making them unable to receive funds via
509      * `transfer`. {sendValue} removes this limitation.
510      *
511      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
512      *
513      * IMPORTANT: because control is transferred to `recipient`, care must be
514      * taken to not create reentrancy vulnerabilities. Consider using
515      * {ReentrancyGuard} or the
516      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(address(this).balance >= amount, "Address: insufficient balance");
520 
521         (bool success, ) = recipient.call{value: amount}("");
522         require(success, "Address: unable to send value, recipient may have reverted");
523     }
524 
525     /**
526      * @dev Performs a Solidity function call using a low level `call`. A
527      * plain `call` is an unsafe replacement for a function call: use this
528      * function instead.
529      *
530      * If `target` reverts with a revert reason, it is bubbled up by this
531      * function (like regular Solidity function calls).
532      *
533      * Returns the raw returned data. To convert to the expected return value,
534      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
535      *
536      * Requirements:
537      *
538      * - `target` must be a contract.
539      * - calling `target` with `data` must not revert.
540      *
541      * _Available since v3.1._
542      */
543     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
544         return functionCall(target, data, "Address: low-level call failed");
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
549      * `errorMessage` as a fallback revert reason when `target` reverts.
550      *
551      * _Available since v3.1._
552      */
553     function functionCall(
554         address target,
555         bytes memory data,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(
573         address target,
574         bytes memory data,
575         uint256 value
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
582      * with `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(address(this).balance >= value, "Address: insufficient balance for call");
593         require(isContract(target), "Address: call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.call{value: value}(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
606         return functionStaticCall(target, data, "Address: low-level static call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a static call.
612      *
613      * _Available since v3.3._
614      */
615     function functionStaticCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal view returns (bytes memory) {
620         require(isContract(target), "Address: static call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.staticcall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628      * but performing a delegate call.
629      *
630      * _Available since v3.4._
631      */
632     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
633         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
638      * but performing a delegate call.
639      *
640      * _Available since v3.4._
641      */
642     function functionDelegateCall(
643         address target,
644         bytes memory data,
645         string memory errorMessage
646     ) internal returns (bytes memory) {
647         require(isContract(target), "Address: delegate call to non-contract");
648 
649         (bool success, bytes memory returndata) = target.delegatecall(data);
650         return verifyCallResult(success, returndata, errorMessage);
651     }
652 
653     /**
654      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
655      * revert reason using the provided one.
656      *
657      * _Available since v4.3._
658      */
659     function verifyCallResult(
660         bool success,
661         bytes memory returndata,
662         string memory errorMessage
663     ) internal pure returns (bytes memory) {
664         if (success) {
665             return returndata;
666         } else {
667             // Look for revert reason and bubble it up if present
668             if (returndata.length > 0) {
669                 // The easiest way to bubble the revert reason is using memory via assembly
670 
671                 assembly {
672                     let returndata_size := mload(returndata)
673                     revert(add(32, returndata), returndata_size)
674                 }
675             } else {
676                 revert(errorMessage);
677             }
678         }
679     }
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
683 pragma solidity ^0.8.0;
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Metadata is IERC721 {
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
701      */
702     function tokenURI(uint256 tokenId) external view returns (string memory);
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @title ERC721 token receiver interface
710  * @dev Interface for any contract that wants to support safeTransfers
711  * from ERC721 asset contracts.
712  */
713 interface IERC721Receiver {
714     /**
715      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
716      * by `operator` from `from`, this function is called.
717      *
718      * It must return its Solidity selector to confirm the token transfer.
719      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
720      *
721      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
722      */
723     function onERC721Received(
724         address operator,
725         address from,
726         uint256 tokenId,
727         bytes calldata data
728     ) external returns (bytes4);
729 }
730 
731 
732 
733 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
734 pragma solidity ^0.8.0;
735 /**
736  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
737  * the Metadata extension, but not including the Enumerable extension, which is available separately as
738  * {ERC721Enumerable}.
739  */
740 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
741     using Address for address;
742     using Strings for uint256;
743 
744     // Token name
745     string private _name;
746 
747     // Token symbol
748     string private _symbol;
749 
750     // Mapping from token ID to owner address
751     mapping(uint256 => address) private _owners;
752 
753     // Mapping owner address to token count
754     mapping(address => uint256) private _balances;
755 
756     // Mapping from token ID to approved address
757     mapping(uint256 => address) private _tokenApprovals;
758 
759     // Mapping from owner to operator approvals
760     mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762     /**
763      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
764      */
765     constructor(string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768     }
769 
770     /**
771      * @dev See {IERC165-supportsInterface}.
772      */
773     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
774         return
775             interfaceId == type(IERC721).interfaceId ||
776             interfaceId == type(IERC721Metadata).interfaceId ||
777             super.supportsInterface(interfaceId);
778     }
779 
780     /**
781      * @dev See {IERC721-balanceOf}.
782      */
783     function balanceOf(address owner) public view virtual override returns (uint256) {
784         require(owner != address(0), "ERC721: balance query for the zero address");
785         return _balances[owner];
786     }
787 
788     /**
789      * @dev See {IERC721-ownerOf}.
790      */
791     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
792         address owner = _owners[tokenId];
793         require(owner != address(0), "ERC721: owner query for nonexistent token");
794         return owner;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-name}.
799      */
800     function name() public view virtual override returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-symbol}.
806      */
807     function symbol() public view virtual override returns (string memory) {
808         return _symbol;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-tokenURI}.
813      */
814     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
815         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
816 
817         string memory baseURI = _baseURI();
818         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
819     }
820 
821     /**
822      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
823      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
824      * by default, can be overriden in child contracts.
825      */
826     function _baseURI() internal view virtual returns (string memory) {
827         return "";
828     }
829 
830     /**
831      * @dev See {IERC721-approve}.
832      */
833     function approve(address to, uint256 tokenId) public virtual override {
834         address owner = ERC721.ownerOf(tokenId);
835         require(to != owner, "ERC721: approval to current owner");
836 
837         require(
838             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
839             "ERC721: approve caller is not owner nor approved for all"
840         );
841 
842         _approve(to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-getApproved}.
847      */
848     function getApproved(uint256 tokenId) public view virtual override returns (address) {
849         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
850 
851         return _tokenApprovals[tokenId];
852     }
853 
854     /**
855      * @dev See {IERC721-setApprovalForAll}.
856      */
857     function setApprovalForAll(address operator, bool approved) public virtual override {
858         require(operator != _msgSender(), "ERC721: approve to caller");
859 
860         _operatorApprovals[_msgSender()][operator] = approved;
861         emit ApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881 
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, "");
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
906         _safeTransfer(from, to, tokenId, _data);
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
911      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
912      *
913      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
914      *
915      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
916      * implement alternative mechanisms to perform token transfer, such as signature-based.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeTransfer(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _transfer(from, to, tokenId);
934         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      * and stop existing when they are burned (`_burn`).
944      */
945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
946         return _owners[tokenId] != address(0);
947     }
948 
949     /**
950      * @dev Returns whether `spender` is allowed to manage `tokenId`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
957         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
958         address owner = ERC721.ownerOf(tokenId);
959         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
960     }
961 
962     /**
963      * @dev Safely mints `tokenId` and transfers it to `to`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(address to, uint256 tokenId) internal virtual {
973         _safeMint(to, tokenId, "");
974     }
975 
976     /**
977      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
978      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
979      */
980     function _safeMint(
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) internal virtual {
985         _mint(to, tokenId);
986         require(
987             _checkOnERC721Received(address(0), to, tokenId, _data),
988             "ERC721: transfer to non ERC721Receiver implementer"
989         );
990     }
991 
992     /**
993      * @dev Mints `tokenId` and transfers it to `to`.
994      *
995      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
996      *
997      * Requirements:
998      *
999      * - `tokenId` must not exist.
1000      * - `to` cannot be the zero address.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(address to, uint256 tokenId) internal virtual {
1005         require(to != address(0), "ERC721: mint to the zero address");
1006         require(!_exists(tokenId), "ERC721: token already minted");
1007 
1008         _beforeTokenTransfer(address(0), to, tokenId);
1009 
1010         _balances[to] += 1;
1011         _owners[tokenId] = to;
1012 
1013         emit Transfer(address(0), to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Destroys `tokenId`.
1018      * The approval is cleared when the token is burned.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _burn(uint256 tokenId) internal virtual {
1027         address owner = ERC721.ownerOf(tokenId);
1028 
1029         _beforeTokenTransfer(owner, address(0), tokenId);
1030 
1031         // Clear approvals
1032         _approve(address(0), tokenId);
1033 
1034         _balances[owner] -= 1;
1035         delete _owners[tokenId];
1036 
1037         emit Transfer(owner, address(0), tokenId);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {
1056         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1057         require(to != address(0), "ERC721: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(from, to, tokenId);
1060 
1061         // Clear approvals from the previous owner
1062         _approve(address(0), tokenId);
1063 
1064         _balances[from] -= 1;
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Approve `to` to operate on `tokenId`
1073      *
1074      * Emits a {Approval} event.
1075      */
1076     function _approve(address to, uint256 tokenId) internal virtual {
1077         _tokenApprovals[tokenId] = to;
1078         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
1135 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1136 pragma solidity ^0.8.0;
1137 /**
1138  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1139  * enumerability of all the token ids in the contract as well as all token ids owned by each
1140  * account.
1141  */
1142 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1143     // Mapping from owner to list of owned token IDs
1144     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1145 
1146     // Mapping from token ID to index of the owner tokens list
1147     mapping(uint256 => uint256) private _ownedTokensIndex;
1148 
1149     // Array with all token ids, used for enumeration
1150     uint256[] private _allTokens;
1151 
1152     // Mapping from token id to position in the allTokens array
1153     mapping(uint256 => uint256) private _allTokensIndex;
1154 
1155     /**
1156      * @dev See {IERC165-supportsInterface}.
1157      */
1158     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1159         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1164      */
1165     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1166         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1167         return _ownedTokens[owner][index];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Enumerable-totalSupply}.
1172      */
1173     function totalSupply() public view virtual override returns (uint256) {
1174         return _allTokens.length;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Enumerable-tokenByIndex}.
1179      */
1180     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1181         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1182         return _allTokens[index];
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before any token transfer. This includes minting
1187      * and burning.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1195      * - `from` cannot be the zero address.
1196      * - `to` cannot be the zero address.
1197      *
1198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1199      */
1200     function _beforeTokenTransfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) internal virtual override {
1205         super._beforeTokenTransfer(from, to, tokenId);
1206 
1207         if (from == address(0)) {
1208             _addTokenToAllTokensEnumeration(tokenId);
1209         } else if (from != to) {
1210             _removeTokenFromOwnerEnumeration(from, tokenId);
1211         }
1212         if (to == address(0)) {
1213             _removeTokenFromAllTokensEnumeration(tokenId);
1214         } else if (to != from) {
1215             _addTokenToOwnerEnumeration(to, tokenId);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1221      * @param to address representing the new owner of the given token ID
1222      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1223      */
1224     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1225         uint256 length = ERC721.balanceOf(to);
1226         _ownedTokens[to][length] = tokenId;
1227         _ownedTokensIndex[tokenId] = length;
1228     }
1229 
1230     /**
1231      * @dev Private function to add a token to this extension's token tracking data structures.
1232      * @param tokenId uint256 ID of the token to be added to the tokens list
1233      */
1234     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1235         _allTokensIndex[tokenId] = _allTokens.length;
1236         _allTokens.push(tokenId);
1237     }
1238 
1239     /**
1240      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1241      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1242      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1243      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1244      * @param from address representing the previous owner of the given token ID
1245      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1246      */
1247     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1248         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1249         // then delete the last slot (swap and pop).
1250 
1251         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1252         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1253 
1254         // When the token to delete is the last token, the swap operation is unnecessary
1255         if (tokenIndex != lastTokenIndex) {
1256             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1257 
1258             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1259             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1260         }
1261 
1262         // This also deletes the contents at the last position of the array
1263         delete _ownedTokensIndex[tokenId];
1264         delete _ownedTokens[from][lastTokenIndex];
1265     }
1266 
1267     /**
1268      * @dev Private function to remove a token from this extension's token tracking data structures.
1269      * This has O(1) time complexity, but alters the order of the _allTokens array.
1270      * @param tokenId uint256 ID of the token to be removed from the tokens list
1271      */
1272     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1273         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1274         // then delete the last slot (swap and pop).
1275 
1276         uint256 lastTokenIndex = _allTokens.length - 1;
1277         uint256 tokenIndex = _allTokensIndex[tokenId];
1278 
1279         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1280         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1281         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1282         uint256 lastTokenId = _allTokens[lastTokenIndex];
1283 
1284         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1285         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1286 
1287         // This also deletes the contents at the last position of the array
1288         delete _allTokensIndex[tokenId];
1289         _allTokens.pop();
1290     }
1291 }
1292 
1293 // File: Genesis_blocks.sol
1294 pragma solidity ^0.8.0;
1295 contract GenesisBlocks is ERC721Enumerable, Ownable {
1296     using Strings for uint256;
1297 
1298     uint256 public constant MAX_SUPPLY = 2500;
1299     uint256 public constant PRICE = 0.05 ether;
1300     uint256 public constant MAX_MINT = 10;
1301     uint256 public constant PRESALE_MAX_MINT = 5;
1302     uint256 public constant MAX_WALLET = 50;
1303     uint256 public constant RESERVED_NFTS = 30;
1304     address public constant genesisAddress = 0xa65159C939FbED795164bb40F7507d9E5D54Ff22;
1305 
1306     uint256 public reservedClaimed;
1307 
1308     uint256 public numTokensMinted;
1309 
1310     string public baseTokenURI;
1311 
1312     bool public publicSaleStarted;
1313     bool public presaleStarted;
1314 
1315     mapping(address => bool) private _presaleEligible;
1316     mapping(address => uint256) private _totalClaimed;
1317 
1318     event BaseURIChanged(string baseURI);
1319     event PresaleMint(address minter, uint256 amountOfTokens);
1320     event PublicSaleMint(address minter, uint256 amountOfTokens);
1321 
1322     modifier whenPresaleStarted() {
1323         require(presaleStarted, "Presale has not started");
1324         _;
1325     }
1326 
1327     modifier whenPublicSaleStarted() {
1328         require(publicSaleStarted, "Public sale has not started");
1329         _;
1330     }
1331 
1332     constructor(string memory baseURI) ERC721("Genesis Blocks", "GEN") {
1333         baseTokenURI = baseURI;
1334     }
1335 
1336     function claimReserved(address recipient, uint256 amount) external onlyOwner {
1337         require(reservedClaimed != RESERVED_NFTS, "Already have claimed all reserved tokens");
1338         require(reservedClaimed + amount <= RESERVED_NFTS, "Minting would exceed max reserved tokens");
1339         require(recipient != address(0), "Cannot add null address");
1340         require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1341         require(totalSupply() + amount <= MAX_SUPPLY, "Minting would exceed max supply");
1342 
1343         uint256 _nextTokenId = numTokensMinted + 1;
1344 
1345         for (uint256 i = 0; i < amount; i++) {
1346             _safeMint(recipient, _nextTokenId + i);
1347         }
1348         numTokensMinted += amount;
1349         reservedClaimed += amount;
1350     }
1351     
1352     function claimMultipleReserved(address[] calldata addresses) external onlyOwner{
1353         require(reservedClaimed != RESERVED_NFTS, "Already have claimed all reserved tokens");
1354         for (uint256 i = 0; i < addresses.length; i++) {
1355             uint256 _nextTokenId = numTokensMinted + 1;
1356             require(reservedClaimed + 1 <= RESERVED_NFTS, "Minting would exceed max reserved tokens");
1357             require(addresses[i] != address(0), "Cannot add null address");
1358             require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1359             require(totalSupply() + 1 <= MAX_SUPPLY, "Minting would exceed max supply");
1360             _safeMint(addresses[i], _nextTokenId);
1361             numTokensMinted += 1;
1362             reservedClaimed += 1;
1363         }
1364     }
1365     
1366   
1367     function addToPresale(address[] calldata addresses) external onlyOwner {
1368         for (uint256 i = 0; i < addresses.length; i++) {
1369             require(addresses[i] != address(0), "Cannot add null address");
1370 
1371             _presaleEligible[addresses[i]] = true;
1372 
1373             _totalClaimed[addresses[i]] > 0 ? _totalClaimed[addresses[i]] : 0;
1374         }
1375     }
1376 
1377     function checkPresaleEligiblity(address addr) external view returns (bool) {
1378         return _presaleEligible[addr];
1379     }
1380 
1381     function amountClaimedBy(address owner) external view returns (uint256) {
1382         require(owner != address(0), "Cannot add null address");
1383 
1384         return _totalClaimed[owner];
1385     }
1386 
1387     function mintPresale(uint256 amountOfTokens) external payable whenPresaleStarted {
1388         require(_presaleEligible[msg.sender], "You are not eligible for the presale");
1389         require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1390         require(amountOfTokens <= PRESALE_MAX_MINT, "Cannot purchase this many tokens during presale");
1391         require(totalSupply() + amountOfTokens <= MAX_SUPPLY, "Minting would exceed max supply");
1392         require(_totalClaimed[msg.sender] + amountOfTokens <= PRESALE_MAX_MINT, "Purchase exceeds max allowed");
1393         require(amountOfTokens > 0, "Must mint at least one token");
1394         require(PRICE * amountOfTokens == msg.value, "ETH amount is incorrect");
1395 
1396         for (uint256 i = 0; i < amountOfTokens; i++) {
1397             uint256 tokenId = numTokensMinted + 1;
1398 
1399             numTokensMinted += 1;
1400             _totalClaimed[msg.sender] += 1;
1401             _safeMint(msg.sender, tokenId);
1402         }
1403 
1404         emit PresaleMint(msg.sender, amountOfTokens);
1405     }
1406 
1407     function mint(uint256 amountOfTokens) external payable whenPublicSaleStarted {
1408         require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1409         require(amountOfTokens <= MAX_MINT, "Cannot purchase this many tokens in a transaction");
1410         require(totalSupply() + amountOfTokens <= MAX_SUPPLY, "Minting would exceed max supply");
1411         require(_totalClaimed[msg.sender] + amountOfTokens <= MAX_WALLET, "Purchase exceeds max allowed per address");
1412         require(amountOfTokens > 0, "Must mint at least one token");
1413         require(PRICE * amountOfTokens == msg.value, "ETH amount is incorrect");
1414         require( msg.sender == tx.origin, "No contracts!" );
1415         
1416         for (uint256 i = 0; i < amountOfTokens; i++) {
1417             uint256 tokenId = numTokensMinted + 1;
1418 
1419             numTokensMinted += 1;
1420             _totalClaimed[msg.sender] += 1;
1421             _safeMint(msg.sender, tokenId);
1422         }
1423 
1424         emit PublicSaleMint(msg.sender, amountOfTokens);
1425     }
1426 
1427     function togglePresaleStarted() external onlyOwner {
1428         presaleStarted = !presaleStarted;
1429     }
1430 
1431     function togglePublicSaleStarted() external onlyOwner {
1432         publicSaleStarted = !publicSaleStarted;
1433     }
1434 
1435     function _baseURI() internal view virtual override returns (string memory) {
1436         return baseTokenURI;
1437     }
1438 
1439     function setBaseURI(string memory baseURI) public onlyOwner {
1440         baseTokenURI = baseURI;
1441         emit BaseURIChanged(baseURI);
1442     }
1443 
1444     function withdrawAll() public onlyOwner {
1445         uint256 balance = address(this).balance;
1446         require(balance > 0, "Insufficent balance");
1447         _widthdraw(genesisAddress, address(this).balance);
1448     }
1449 
1450     function _widthdraw(address _address, uint256 _amount) private {
1451         (bool success, ) = _address.call{ value: _amount }("");
1452         require(success, "Failed to widthdraw Ether");
1453     }
1454 }