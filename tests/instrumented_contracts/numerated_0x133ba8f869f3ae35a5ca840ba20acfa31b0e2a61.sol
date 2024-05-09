1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @title ERC721 token receiver interface
27  * @dev Interface for any contract that wants to support safeTransfers
28  * from ERC721 asset contracts.
29  */
30 interface IERC721Receiver {
31     /**
32      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
33      * by `operator` from `from`, this function is called.
34      *
35      * It must return its Solidity selector to confirm the token transfer.
36      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
37      *dsadasdasdassa
38      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
39      */
40     function onERC721Received(
41         address operator,
42         address from,
43         uint256 tokenId,
44         bytes calldata data
45     ) external returns (bytes4);
46 }
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Interface of the ERC165 standard, as defined in the
52  * https://eips.ethereum.org/EIPS/eip-165[EIP].
53  *
54  * Implementers can declare support of contract interfaces, which can then be
55  * queried by others ({ERC165Checker}).
56  *
57  * For an implementation, see {ERC165}.
58  */
59 interface IERC165 {
60     /**
61      * @dev Returns true if this contract implements the interface defined by
62      * `interfaceId`. See the corresponding
63      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
64      * to learn more about how these ids are created.
65      *
66      * This function call must use less than 30 000 gas.
67      */
68     function supportsInterface(bytes4 interfaceId) external view returns (bool);
69 }
70 /**
71  * @dev Required interface of an ERC721 compliant contract.
72  */
73 interface IERC721 is IERC165 {
74     /**
75      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
81      */
82     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
83 
84     /**
85      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
86      */
87     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
88 
89     /**
90      * @dev Returns the number of tokens in ``owner``'s account.
91      */
92     function balanceOf(address owner) external view returns (uint256 balance);
93 
94     /**
95      * @dev Returns the owner of the `tokenId` token.
96      *
97      * Requirements:
98      *
99      * - `tokenId` must exist.
100      */
101     function ownerOf(uint256 tokenId) external view returns (address owner);
102 
103     /**
104      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
105      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must exist and be owned by `from`.
112      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
114      *
115      * Emits a {Transfer} event.
116      */
117     function safeTransferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Transfers `tokenId` token from `from` to `to`.
125      *
126      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
127      *
128      * Requirements:
129      *
130      * - `from` cannot be the zero address.
131      * - `to` cannot be the zero address.
132      * - `tokenId` token must be owned by `from`.
133      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(
138         address from,
139         address to,
140         uint256 tokenId
141     ) external;
142 
143     /**
144      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
145      * The approval is cleared when the token is transferred.
146      *
147      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
148      *
149      * Requirements:
150      *
151      * - The caller must own the token or be an approved operator.
152      * - `tokenId` must exist.
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address to, uint256 tokenId) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Approve or remove `operator` as an operator for the caller.
169      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
170      *
171      * Requirements:
172      *
173      * - The `operator` cannot be the caller.
174      *
175      * Emits an {ApprovalForAll} event.
176      */
177     function setApprovalForAll(address operator, bool _approved) external;
178 
179     /**
180      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
181      *
182      * See {setApprovalForAll}
183      */
184     function isApprovedForAll(address owner, address operator) external view returns (bool);
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId,
203         bytes calldata data
204     ) external;
205 }
206 
207 
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @dev Contract module which allows children to implement an emergency stop
214  * mechanism that can be triggered by an authorized account.
215  *
216  * This module is used through inheritance. It will make available the
217  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
218  * the functions of your contract. Note that they will not be pausable by
219  * simply including this module, only once the modifiers are put in place.
220  */
221 abstract contract Pausable is Context {
222     /**
223      * @dev Emitted when the pause is triggered by `account`.
224      */
225     event Paused(address account);
226 
227     /**
228      * @dev Emitted when the pause is lifted by `account`.
229      */
230     event Unpaused(address account);
231 
232     bool private _paused;
233 
234     /**
235      * @dev Initializes the contract in unpaused state.
236      */
237     constructor() {
238         _paused = false;
239     }
240 
241     /**
242      * @dev Returns true if the contract is paused, and false otherwise.
243      */
244     function paused() public view virtual returns (bool) {
245         return _paused;
246     }
247 
248     /**
249      * @dev Modifier to make a function callable only when the contract is not paused.
250      *
251      * Requirements:
252      *
253      * - The contract must not be paused.
254      */
255     modifier whenNotPaused() {
256         require(!paused(), "Pausable: paused");
257         _;
258     }
259 
260     /**
261      * @dev Modifier to make a function callable only when the contract is paused.
262      *
263      * Requirements:
264      *
265      * - The contract must be paused.
266      */
267     modifier whenPaused() {
268         require(paused(), "Pausable: not paused");
269         _;
270     }
271 
272     /**
273      * @dev Triggers stopped state.
274      *
275      * Requirements:
276      *
277      * - The contract must not be paused.
278      */
279     function _pause() internal virtual whenNotPaused {
280         _paused = true;
281         emit Paused(_msgSender());
282     }
283 
284     /**
285      * @dev Returns to normal state.
286      *
287      * Requirements:
288      *
289      * - The contract must be paused.
290      */
291     function _unpause() internal virtual whenPaused {
292         _paused = false;
293         emit Unpaused(_msgSender());
294     }
295 }
296 
297 // File: @openzeppelin/contracts/access/Ownable.sol
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 
304 /**
305  * @dev Contract module which provides a basic access control mechanism, where
306  * there is an account (an owner) that can be granted exclusive access to
307  * specific functions.
308  *
309  * By default, the owner account will be the one that deploys the contract. This
310  * can later be changed with {transferOwnership}.
311  *
312  * This module is used through inheritance. It will make available the modifier
313  * `onlyOwner`, which can be applied to your functions to restrict their use to
314  * the owner.
315  */
316 abstract contract Ownable is Context {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     /**
322      * @dev Initializes the contract setting the deployer as the initial owner.
323      */
324     constructor() {
325         _setOwner(_msgSender());
326     }
327 
328     /**
329      * @dev Returns the address of the current owner.
330      */
331     function owner() public view virtual returns (address) {
332         return _owner;
333     }
334 
335     /**
336      * @dev Throws if called by any account other than the owner.
337      */
338     modifier onlyOwner() {
339         require(owner() == _msgSender(), "Ownable: caller is not the owner");
340         _;
341     }
342 
343     /**
344      * @dev Leaves the contract without owner. It will not be possible to call
345      * `onlyOwner` functions anymore. Can only be called by the current owner.
346      *
347      * NOTE: Renouncing ownership will leave the contract without an owner,
348      * thereby removing any functionality that is only available to the owner.
349      */
350     function renounceOwnership() public virtual onlyOwner {
351         _setOwner(address(0));
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Can only be called by the current owner.
357      */
358     function transferOwnership(address newOwner) public virtual onlyOwner {
359         require(newOwner != address(0), "Ownable: new owner is the zero address");
360         _setOwner(newOwner);
361     }
362 
363     function _setOwner(address newOwner) private {
364         address oldOwner = _owner;
365         _owner = newOwner;
366         emit OwnershipTransferred(oldOwner, newOwner);
367     }
368 }
369 
370 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
379  * @dev See https://eips.ethereum.org/EIPS/eip-721
380  */
381 interface IERC721Enumerable is IERC721 {
382     /**
383      * @dev Returns the total amount of tokens stored by the contract.
384      */
385     function totalSupply() external view returns (uint256);
386 
387     /**
388      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
389      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
390      */
391     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
392 
393     /**
394      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
395      * Use along with {totalSupply} to enumerate all tokens.
396      */
397     function tokenByIndex(uint256 index) external view returns (uint256);
398 }
399 
400 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
401 
402 
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Implementation of the {IERC165} interface.
409  *
410  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
411  * for the additional interface id that will be supported. For example:
412  *
413  * ```solidity
414  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
416  * }
417  * ```
418  *
419  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
420  */
421 abstract contract ERC165 is IERC165 {
422     /**
423      * @dev See {IERC165-supportsInterface}.
424      */
425     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426         return interfaceId == type(IERC165).interfaceId;
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Strings.sol
431 
432 
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @dev String operations.
438  */
439 library Strings {
440     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
441 
442     /**
443      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
444      */
445     function toString(uint256 value) internal pure returns (string memory) {
446         // Inspired by OraclizeAPI's implementation - MIT licence
447         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
448 
449         if (value == 0) {
450             return "0";
451         }
452         uint256 temp = value;
453         uint256 digits;
454         while (temp != 0) {
455             digits++;
456             temp /= 10;
457         }
458         bytes memory buffer = new bytes(digits);
459         while (value != 0) {
460             digits -= 1;
461             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
462             value /= 10;
463         }
464         return string(buffer);
465     }
466 
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
469      */
470     function toHexString(uint256 value) internal pure returns (string memory) {
471         if (value == 0) {
472             return "0x00";
473         }
474         uint256 temp = value;
475         uint256 length = 0;
476         while (temp != 0) {
477             length++;
478             temp >>= 8;
479         }
480         return toHexString(value, length);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
485      */
486     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
487         bytes memory buffer = new bytes(2 * length + 2);
488         buffer[0] = "0";
489         buffer[1] = "x";
490         for (uint256 i = 2 * length + 1; i > 1; --i) {
491             buffer[i] = _HEX_SYMBOLS[value & 0xf];
492             value >>= 4;
493         }
494         require(value == 0, "Strings: hex length insufficient");
495         return string(buffer);
496     }
497 }
498 
499 // File: @openzeppelin/contracts/utils/Context.sol
500 
501 
502 // File: @openzeppelin/contracts/utils/Address.sol
503 
504 
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Collection of functions related to the address type
510  */
511 library Address {
512     /**
513      * @dev Returns true if `account` is a contract.
514      *
515      * [IMPORTANT]
516      * ====
517      * It is unsafe to assume that an address for which this function returns
518      * false is an externally-owned account (EOA) and not a contract.
519      *
520      * Among others, `isContract` will return false for the following
521      * types of addresses:
522      *
523      *  - an externally-owned account
524      *  - a contract in construction
525      *  - an address where a contract will be created
526      *  - an address where a contract lived, but was destroyed
527      * ====
528      */
529     function isContract(address account) internal view returns (bool) {
530         // This method relies on extcodesize, which returns 0 for contracts in
531         // construction, since the code is only stored at the end of the
532         // constructor execution.
533 
534         uint256 size;
535         assembly {
536             size := extcodesize(account)
537         }
538         return size > 0;
539     }
540 
541     /**
542      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
543      * `recipient`, forwarding all available gas and reverting on errors.
544      *
545      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
546      * of certain opcodes, possibly making contracts go over the 2300 gas limit
547      * imposed by `transfer`, making them unable to receive funds via
548      * `transfer`. {sendValue} removes this limitation.
549      *
550      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
551      *
552      * IMPORTANT: because control is transferred to `recipient`, care must be
553      * taken to not create reentrancy vulnerabilities. Consider using
554      * {ReentrancyGuard} or the
555      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
556      */
557     function sendValue(address payable recipient, uint256 amount) internal {
558         require(address(this).balance >= amount, "Address: insufficient balance");
559 
560         (bool success, ) = recipient.call{value: amount}("");
561         require(success, "Address: unable to send value, recipient may have reverted");
562     }
563 
564     /**
565      * @dev Performs a Solidity function call using a low level `call`. A
566      * plain `call` is an unsafe replacement for a function call: use this
567      * function instead.
568      *
569      * If `target` reverts with a revert reason, it is bubbled up by this
570      * function (like regular Solidity function calls).
571      *
572      * Returns the raw returned data. To convert to the expected return value,
573      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
574      *
575      * Requirements:
576      *
577      * - `target` must be a contract.
578      * - calling `target` with `data` must not revert.
579      *
580      * _Available since v3.1._
581      */
582     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionCall(target, data, "Address: low-level call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
588      * `errorMessage` as a fallback revert reason when `target` reverts.
589      *
590      * _Available since v3.1._
591      */
592     function functionCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, 0, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but also transferring `value` wei to `target`.
603      *
604      * Requirements:
605      *
606      * - the calling contract must have an ETH balance of at least `value`.
607      * - the called Solidity function must be `payable`.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(
612         address target,
613         bytes memory data,
614         uint256 value
615     ) internal returns (bytes memory) {
616         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
621      * with `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(
626         address target,
627         bytes memory data,
628         uint256 value,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(address(this).balance >= value, "Address: insufficient balance for call");
632         require(isContract(target), "Address: call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.call{value: value}(data);
635         return verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
645         return functionStaticCall(target, data, "Address: low-level static call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal view returns (bytes memory) {
659         require(isContract(target), "Address: static call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.staticcall(data);
662         return verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
672         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
677      * but performing a delegate call.
678      *
679      * _Available since v3.4._
680      */
681     function functionDelegateCall(
682         address target,
683         bytes memory data,
684         string memory errorMessage
685     ) internal returns (bytes memory) {
686         require(isContract(target), "Address: delegate call to non-contract");
687 
688         (bool success, bytes memory returndata) = target.delegatecall(data);
689         return verifyCallResult(success, returndata, errorMessage);
690     }
691 
692     /**
693      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
694      * revert reason using the provided one.
695      *
696      * _Available since v4.3._
697      */
698     function verifyCallResult(
699         bool success,
700         bytes memory returndata,
701         string memory errorMessage
702     ) internal pure returns (bytes memory) {
703         if (success) {
704             return returndata;
705         } else {
706             // Look for revert reason and bubble it up if present
707             if (returndata.length > 0) {
708                 // The easiest way to bubble the revert reason is using memory via assembly
709 
710                 assembly {
711                     let returndata_size := mload(returndata)
712                     revert(add(32, returndata), returndata_size)
713                 }
714             } else {
715                 revert(errorMessage);
716             }
717         }
718     }
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
722 
723 
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
730  * @dev See https://eips.ethereum.org/EIPS/eip-721
731  */
732 interface IERC721Metadata is IERC721 {
733     /**
734      * @dev Returns the token collection name.
735      */
736     function name() external view returns (string memory);
737 
738     /**
739      * @dev Returns the token collection symbol.
740      */
741     function symbol() external view returns (string memory);
742 
743     /**
744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
745      */
746     function tokenURI(uint256 tokenId) external view returns (string memory);
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
750 
751 
752 
753 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
754 
755 
756 
757 
758 
759 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
760 
761 
762 
763 
764 
765 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
766 
767 
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension, but not including the Enumerable extension, which is available separately as
774  * {ERC721Enumerable}.
775  */
776 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
777     using Address for address;
778     using Strings for uint256;
779 
780     // Token name
781     string private _name;
782 
783     // Token symbol
784     string private _symbol;
785 
786     // Mapping from token ID to owner address
787     mapping(uint256 => address) private _owners;
788 
789     // Mapping owner address to token count
790     mapping(address => uint256) private _balances;
791 
792     // Mapping from token ID to approved address
793     mapping(uint256 => address) private _tokenApprovals;
794 
795     // Mapping from owner to operator approvals
796     mapping(address => mapping(address => bool)) private _operatorApprovals;
797 
798     /**
799      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
800      */
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804     }
805 
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
810         return
811             interfaceId == type(IERC721).interfaceId ||
812             interfaceId == type(IERC721Metadata).interfaceId ||
813             super.supportsInterface(interfaceId);
814     }
815 
816     /**
817      * @dev See {IERC721-balanceOf}.
818      */
819     function balanceOf(address owner) public view virtual override returns (uint256) {
820         require(owner != address(0), "ERC721: balance query for the zero address");
821         return _balances[owner];
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
828         address owner = _owners[tokenId];
829         require(owner != address(0), "ERC721: owner query for nonexistent token");
830         return owner;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overriden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return "";
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public virtual override {
870         address owner = ERC721.ownerOf(tokenId);
871         require(to != owner, "ERC721: approval to current owner");
872 
873         require(
874             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
875             "ERC721: approve caller is not owner nor approved for all"
876         );
877 
878         _approve(to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId) public view virtual override returns (address) {
885         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
886 
887         return _tokenApprovals[tokenId];
888     }
889 
890     /**
891      * @dev See {IERC721-setApprovalForAll}.
892      */
893     function setApprovalForAll(address operator, bool approved) public virtual override {
894         require(operator != _msgSender(), "ERC721: approve to caller");
895 
896         _operatorApprovals[_msgSender()][operator] = approved;
897         emit ApprovalForAll(_msgSender(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-transferFrom}.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         //solhint-disable-next-line max-line-length
916         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
917 
918         _transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         safeTransferFrom(from, to, tokenId, "");
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public virtual override {
941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
942         _safeTransfer(from, to, tokenId, _data);
943     }
944 
945     /**
946      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
947      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
948      *
949      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
950      *
951      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
952      * implement alternative mechanisms to perform token transfer, such as signature-based.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeTransfer(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) internal virtual {
969         _transfer(from, to, tokenId);
970         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted (`_mint`),
979      * and stop existing when they are burned (`_burn`).
980      */
981     function _exists(uint256 tokenId) internal view virtual returns (bool) {
982         return _owners[tokenId] != address(0);
983     }
984 
985     /**
986      * @dev Returns whether `spender` is allowed to manage `tokenId`.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
993         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
994         address owner = ERC721.ownerOf(tokenId);
995         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
996     }
997 
998     /**
999      * @dev Safely mints `tokenId` and transfers it to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _safeMint(address to, uint256 tokenId) internal virtual {
1009         _safeMint(to, tokenId, "");
1010     }
1011 
1012     /**
1013      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1014      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1015      */
1016     function _safeMint(
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) internal virtual {
1021         _mint(to, tokenId);
1022         require(
1023             _checkOnERC721Received(address(0), to, tokenId, _data),
1024             "ERC721: transfer to non ERC721Receiver implementer"
1025         );
1026     }
1027 
1028     /**
1029      * @dev Mints `tokenId` and transfers it to `to`.
1030      *
1031      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must not exist.
1036      * - `to` cannot be the zero address.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _mint(address to, uint256 tokenId) internal virtual {
1041         require(to != address(0), "ERC721: mint to the zero address");
1042         require(!_exists(tokenId), "ERC721: token already minted");
1043 
1044         _beforeTokenTransfer(address(0), to, tokenId);
1045 
1046         _balances[to] += 1;
1047         _owners[tokenId] = to;
1048 
1049         emit Transfer(address(0), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         address owner = ERC721.ownerOf(tokenId);
1064 
1065         _beforeTokenTransfer(owner, address(0), tokenId);
1066 
1067         // Clear approvals
1068         _approve(address(0), tokenId);
1069 
1070         _balances[owner] -= 1;
1071         delete _owners[tokenId];
1072 
1073         emit Transfer(owner, address(0), tokenId);
1074     }
1075 
1076     /**
1077      * @dev Transfers `tokenId` from `from` to `to`.
1078      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must be owned by `from`.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual {
1092         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1093         require(to != address(0), "ERC721: transfer to the zero address");
1094 
1095         _beforeTokenTransfer(from, to, tokenId);
1096 
1097         // Clear approvals from the previous owner
1098         _approve(address(0), tokenId);
1099 
1100         _balances[from] -= 1;
1101         _balances[to] += 1;
1102         _owners[tokenId] = to;
1103 
1104         emit Transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Approve `to` to operate on `tokenId`
1109      *
1110      * Emits a {Approval} event.
1111      */
1112     function _approve(address to, uint256 tokenId) internal virtual {
1113         _tokenApprovals[tokenId] = to;
1114         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1119      * The call is not executed if the target address is not a contract.
1120      *
1121      * @param from address representing the previous owner of the given token ID
1122      * @param to target address that will receive the tokens
1123      * @param tokenId uint256 ID of the token to be transferred
1124      * @param _data bytes optional data to send along with the call
1125      * @return bool whether the call correctly returned the expected magic value
1126      */
1127     function _checkOnERC721Received(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) private returns (bool) {
1133         if (to.isContract()) {
1134             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1135                 return retval == IERC721Receiver.onERC721Received.selector;
1136             } catch (bytes memory reason) {
1137                 if (reason.length == 0) {
1138                     revert("ERC721: transfer to non ERC721Receiver implementer");
1139                 } else {
1140                     assembly {
1141                         revert(add(32, reason), mload(reason))
1142                     }
1143                 }
1144             }
1145         } else {
1146             return true;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Hook that is called before any token transfer. This includes minting
1152      * and burning.
1153      *
1154      * Calling conditions:
1155      *
1156      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1157      * transferred to `to`.
1158      * - When `from` is zero, `tokenId` will be minted for `to`.
1159      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1160      * - `from` and `to` are never both zero.
1161      *
1162      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1163      */
1164     function _beforeTokenTransfer(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) internal virtual {}
1169 }
1170 
1171 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1172 
1173 
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 
1179 /**
1180  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1181  * enumerability of all the token ids in the contract as well as all token ids owned by each
1182  * account.
1183  */
1184 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1185     // Mapping from owner to list of owned token IDs
1186     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1187 
1188     // Mapping from token ID to index of the owner tokens list
1189     mapping(uint256 => uint256) private _ownedTokensIndex;
1190 
1191     // Array with all token ids, used for enumeration
1192     uint256[] private _allTokens;
1193 
1194     // Mapping from token id to position in the allTokens array
1195     mapping(uint256 => uint256) private _allTokensIndex;
1196 
1197     /**
1198      * @dev See {IERC165-supportsInterface}.
1199      */
1200     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1201         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1206      */
1207     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1208         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1209         return _ownedTokens[owner][index];
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Enumerable-totalSupply}.
1214      */
1215     function totalSupply() public view virtual override returns (uint256) {
1216         return _allTokens.length;
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Enumerable-tokenByIndex}.
1221      */
1222     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1223         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1224         return _allTokens[index];
1225     }
1226 
1227     /**
1228      * @dev Hook that is called before any token transfer. This includes minting
1229      * and burning.
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1237      * - `from` cannot be the zero address.
1238      * - `to` cannot be the zero address.
1239      *
1240      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1241      */
1242     function _beforeTokenTransfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual override {
1247         super._beforeTokenTransfer(from, to, tokenId);
1248 
1249         if (from == address(0)) {
1250             _addTokenToAllTokensEnumeration(tokenId);
1251         } else if (from != to) {
1252             _removeTokenFromOwnerEnumeration(from, tokenId);
1253         }
1254         if (to == address(0)) {
1255             _removeTokenFromAllTokensEnumeration(tokenId);
1256         } else if (to != from) {
1257             _addTokenToOwnerEnumeration(to, tokenId);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1263      * @param to address representing the new owner of the given token ID
1264      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1265      */
1266     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1267         uint256 length = ERC721.balanceOf(to);
1268         _ownedTokens[to][length] = tokenId;
1269         _ownedTokensIndex[tokenId] = length;
1270     }
1271 
1272     /**
1273      * @dev Private function to add a token to this extension's token tracking data structures.
1274      * @param tokenId uint256 ID of the token to be added to the tokens list
1275      */
1276     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1277         _allTokensIndex[tokenId] = _allTokens.length;
1278         _allTokens.push(tokenId);
1279     }
1280 
1281     /**
1282      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1283      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1284      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1285      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1286      * @param from address representing the previous owner of the given token ID
1287      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1288      */
1289     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1290         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1291         // then delete the last slot (swap and pop).
1292 
1293         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1294         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1295 
1296         // When the token to delete is the last token, the swap operation is unnecessary
1297         if (tokenIndex != lastTokenIndex) {
1298             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1299 
1300             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1301             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1302         }
1303 
1304         // This also deletes the contents at the last position of the array
1305         delete _ownedTokensIndex[tokenId];
1306         delete _ownedTokens[from][lastTokenIndex];
1307     }
1308 
1309     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1310         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1311         // then delete the last slot (swap and pop).
1312 
1313         uint256 lastTokenIndex = _allTokens.length - 1;
1314         uint256 tokenIndex = _allTokensIndex[tokenId];
1315 
1316         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1317         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1318         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1319         uint256 lastTokenId = _allTokens[lastTokenIndex];
1320 
1321         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1322         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1323 
1324         // This also deletes the contents at the last position of the array
1325         delete _allTokensIndex[tokenId];
1326         _allTokens.pop();
1327     }
1328 }
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 contract MUSHROHMS is ERC721Enumerable, Ownable {
1333     using Strings for uint256;
1334     uint256 public PRICE = 0 ether;
1335     
1336     uint256 public MAX_MUSHROHMS = 1500;
1337     uint256 public MAX_PER_MINT = 1;
1338     uint256 public MAX_MUSHROHMS_MINT = 1;
1339     address public constant founderAddress = 0xFA5af8c17736B69a4CEE0E6C05DC139A92897aA9;
1340     uint256 public numshrohmsMinted;
1341     
1342     string public baseTokenURI = "ipfs://QmbJT54Bx7hxN5NJ29F8wFZ4YNq59Vf5tSSTeCQqeN9swf/";
1343     bool public presaleStarted = true;
1344     bool public pause = false;
1345     
1346     mapping(address => bool) private _presaleEligible;
1347     mapping(address => uint256) private _totalClaimed;
1348 
1349     event MushrohmMint(address minter, uint256 amountOfshrohms);
1350     
1351     constructor() ERC721("MUSHROHMS", "Shrohm") {}
1352     
1353     function togglePresaleStarted() external onlyOwner {
1354         presaleStarted = !presaleStarted;
1355     }
1356     
1357     function togglePause() external onlyOwner {
1358         pause = !pause;
1359     }
1360     
1361     function setbaseTokenURI(string memory baseURI) public onlyOwner returns (string memory) {
1362         baseTokenURI = baseURI;
1363         return baseTokenURI;
1364     }
1365     
1366     function setPrice(uint256 inPrice) public onlyOwner returns (uint256) {
1367         PRICE = inPrice;
1368         return PRICE;
1369     }
1370     
1371     function checkBal(address owner) external view returns (uint256) {
1372         uint256 currentBal = address(this).balance;
1373         return currentBal;
1374     }
1375     
1376     function addToPresale(address[] calldata addresses) external onlyOwner {
1377         for (uint256 i = 0; i < addresses.length; i++) {
1378             require(addresses[i] != address(0), "Cannot add null address");
1379 
1380             _presaleEligible[addresses[i]] = true;
1381 
1382             _totalClaimed[addresses[i]] > 0 ? _totalClaimed[addresses[i]] : 0;
1383         }
1384     }
1385 
1386     function checkPresaleEligiblity(address addr) external view returns (bool) {
1387         return _presaleEligible[addr];
1388     }
1389 
1390     function amountClaimedBy(address owner) external view returns (uint256) {
1391         require(owner != address(0), "Cannot add null address");
1392 
1393         return _totalClaimed[owner];
1394     }
1395     
1396     function mint(uint256 amountOfshrohms) external payable {
1397         require(pause == false);
1398         if (presaleStarted == true) {
1399             require(_presaleEligible[msg.sender], "You are not eligible for the presale!");
1400         }
1401         require(totalSupply() < MAX_MUSHROHMS, "All tokens have been minted.");
1402         require(amountOfshrohms <= MAX_PER_MINT, "You can only mint one Mushrohm per address.");
1403         require(totalSupply() + amountOfshrohms <= MAX_MUSHROHMS, "Minting would exceed max supply!");
1404         require(_totalClaimed[msg.sender] + amountOfshrohms <= MAX_MUSHROHMS_MINT, "Purchase exceeds max allowed per wallet.");
1405         require(amountOfshrohms > 0, "Must mint at least one Mushrohm.");
1406         require(PRICE * amountOfshrohms == msg.value, "ETH amount is incorrect.");
1407         
1408         for (uint256 i = 0; i < amountOfshrohms; i++) {
1409             uint256 tokenId = numshrohmsMinted + 1;
1410 
1411             numshrohmsMinted += 1;
1412             _totalClaimed[msg.sender] += 1;
1413             _safeMint(msg.sender, tokenId);
1414         }
1415 
1416         emit MushrohmMint(msg.sender, amountOfshrohms);
1417     }
1418     
1419     function withdrawAll() public onlyOwner {
1420         uint256 balance = address(this).balance;
1421         require(balance > 0, "Insufficent balance");
1422         _widthdraw(founderAddress, balance);
1423     }
1424     
1425     function _widthdraw(address _address, uint256 _amount) private {
1426         (bool success, ) = _address.call{ value: _amount }("");
1427         require(success, "Failed to widthdraw Ether");
1428     }
1429     
1430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1431         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1432         return bytes(baseTokenURI).length > 0 ? string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json")) : "";
1433     }
1434 }