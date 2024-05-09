1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/security/Pausable.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which allows children to implement an emergency stop
186  * mechanism that can be triggered by an authorized account.
187  *
188  * This module is used through inheritance. It will make available the
189  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
190  * the functions of your contract. Note that they will not be pausable by
191  * simply including this module, only once the modifiers are put in place.
192  */
193 abstract contract Pausable is Context {
194     /**
195      * @dev Emitted when the pause is triggered by `account`.
196      */
197     event Paused(address account);
198 
199     /**
200      * @dev Emitted when the pause is lifted by `account`.
201      */
202     event Unpaused(address account);
203 
204     bool private _paused;
205 
206     /**
207      * @dev Initializes the contract in unpaused state.
208      */
209     constructor() {
210         _paused = false;
211     }
212 
213     /**
214      * @dev Returns true if the contract is paused, and false otherwise.
215      */
216     function paused() public view virtual returns (bool) {
217         return _paused;
218     }
219 
220     /**
221      * @dev Modifier to make a function callable only when the contract is not paused.
222      *
223      * Requirements:
224      *
225      * - The contract must not be paused.
226      */
227     modifier whenNotPaused() {
228         require(!paused(), "Pausable: paused");
229         _;
230     }
231 
232     /**
233      * @dev Modifier to make a function callable only when the contract is paused.
234      *
235      * Requirements:
236      *
237      * - The contract must be paused.
238      */
239     modifier whenPaused() {
240         require(paused(), "Pausable: not paused");
241         _;
242     }
243 
244     /**
245      * @dev Triggers stopped state.
246      *
247      * Requirements:
248      *
249      * - The contract must not be paused.
250      */
251     function _pause() internal virtual whenNotPaused {
252         _paused = true;
253         emit Paused(_msgSender());
254     }
255 
256     /**
257      * @dev Returns to normal state.
258      *
259      * Requirements:
260      *
261      * - The contract must be paused.
262      */
263     function _unpause() internal virtual whenPaused {
264         _paused = false;
265         emit Unpaused(_msgSender());
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
273 
274 pragma solidity ^0.8.1;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      *
297      * [IMPORTANT]
298      * ====
299      * You shouldn't rely on `isContract` to protect against flash loan attacks!
300      *
301      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
302      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
303      * constructor.
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize/address.code.length, which returns 0
308         // for contracts in construction, since the code is only stored at the end
309         // of the constructor execution.
310 
311         return account.code.length > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @title ERC721 token receiver interface
503  * @dev Interface for any contract that wants to support safeTransfers
504  * from ERC721 asset contracts.
505  */
506 interface IERC721Receiver {
507     /**
508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
509      * by `operator` from `from`, this function is called.
510      *
511      * It must return its Solidity selector to confirm the token transfer.
512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
513      *
514      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
515      */
516     function onERC721Received(
517         address operator,
518         address from,
519         uint256 tokenId,
520         bytes calldata data
521     ) external returns (bytes4);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Interface of the ERC165 standard, as defined in the
533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
534  *
535  * Implementers can declare support of contract interfaces, which can then be
536  * queried by others ({ERC165Checker}).
537  *
538  * For an implementation, see {ERC165}.
539  */
540 interface IERC165 {
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * `interfaceId`. See the corresponding
544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30 000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 }
551 
552 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
584 
585 
586 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Required interface of an ERC721 compliant contract.
593  */
594 interface IERC721 is IERC165 {
595     /**
596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
597      */
598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
602      */
603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
607      */
608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
609 
610     /**
611      * @dev Returns the number of tokens in ``owner``'s account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes calldata data
642     ) external;
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Approve or remove `operator` as an operator for the caller.
701      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
702      *
703      * Requirements:
704      *
705      * - The `operator` cannot be the caller.
706      *
707      * Emits an {ApprovalForAll} event.
708      */
709     function setApprovalForAll(address operator, bool _approved) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
729 
730 
731 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
738  * @dev See https://eips.ethereum.org/EIPS/eip-721
739  */
740 interface IERC721Enumerable is IERC721 {
741     /**
742      * @dev Returns the total amount of tokens stored by the contract.
743      */
744     function totalSupply() external view returns (uint256);
745 
746     /**
747      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
748      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
749      */
750     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
751 
752     /**
753      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
754      * Use along with {totalSupply} to enumerate all tokens.
755      */
756     function tokenByIndex(uint256 index) external view returns (uint256);
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 interface IERC721Metadata is IERC721 {
772     /**
773      * @dev Returns the token collection name.
774      */
775     function name() external view returns (string memory);
776 
777     /**
778      * @dev Returns the token collection symbol.
779      */
780     function symbol() external view returns (string memory);
781 
782     /**
783      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
784      */
785     function tokenURI(uint256 tokenId) external view returns (string memory);
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
789 
790 
791 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 
798 
799 
800 
801 
802 /**
803  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
804  * the Metadata extension, but not including the Enumerable extension, which is available separately as
805  * {ERC721Enumerable}.
806  */
807 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
808     using Address for address;
809     using Strings for uint256;
810 
811     // Token name
812     string private _name;
813 
814     // Token symbol
815     string private _symbol;
816 
817     // Mapping from token ID to owner address
818     mapping(uint256 => address) private _owners;
819 
820     // Mapping owner address to token count
821     mapping(address => uint256) private _balances;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     /**
830      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
831      */
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835     }
836 
837     /**
838      * @dev See {IERC165-supportsInterface}.
839      */
840     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
841         return
842             interfaceId == type(IERC721).interfaceId ||
843             interfaceId == type(IERC721Metadata).interfaceId ||
844             super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev See {IERC721-balanceOf}.
849      */
850     function balanceOf(address owner) public view virtual override returns (uint256) {
851         require(owner != address(0), "ERC721: balance query for the zero address");
852         return _balances[owner];
853     }
854 
855     /**
856      * @dev See {IERC721-ownerOf}.
857      */
858     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
859         address owner = _owners[tokenId];
860         require(owner != address(0), "ERC721: owner query for nonexistent token");
861         return owner;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-name}.
866      */
867     function name() public view virtual override returns (string memory) {
868         return _name;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-symbol}.
873      */
874     function symbol() public view virtual override returns (string memory) {
875         return _symbol;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-tokenURI}.
880      */
881     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
882         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
883 
884         string memory baseURI = _baseURI();
885         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
886     }
887 
888     /**
889      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
890      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
891      * by default, can be overridden in child contracts.
892      */
893     function _baseURI() internal view virtual returns (string memory) {
894         return "";
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public virtual override {
901         address owner = ERC721.ownerOf(tokenId);
902         require(to != owner, "ERC721: approval to current owner");
903 
904         require(
905             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
906             "ERC721: approve caller is not owner nor approved for all"
907         );
908 
909         _approve(to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view virtual override returns (address) {
916         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public virtual override {
925         _setApprovalForAll(_msgSender(), operator, approved);
926     }
927 
928     /**
929      * @dev See {IERC721-isApprovedForAll}.
930      */
931     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
932         return _operatorApprovals[owner][operator];
933     }
934 
935     /**
936      * @dev See {IERC721-transferFrom}.
937      */
938     function transferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         //solhint-disable-next-line max-line-length
944         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
945 
946         _transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         safeTransferFrom(from, to, tokenId, "");
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) public virtual override {
969         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
970         _safeTransfer(from, to, tokenId, _data);
971     }
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
975      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
976      *
977      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
978      *
979      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
980      * implement alternative mechanisms to perform token transfer, such as signature-based.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeTransfer(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _transfer(from, to, tokenId);
998         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
999     }
1000 
1001     /**
1002      * @dev Returns whether `tokenId` exists.
1003      *
1004      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1005      *
1006      * Tokens start existing when they are minted (`_mint`),
1007      * and stop existing when they are burned (`_burn`).
1008      */
1009     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1010         return _owners[tokenId] != address(0);
1011     }
1012 
1013     /**
1014      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must exist.
1019      */
1020     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1021         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1022         address owner = ERC721.ownerOf(tokenId);
1023         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1024     }
1025 
1026     /**
1027      * @dev Safely mints `tokenId` and transfers it to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must not exist.
1032      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _safeMint(address to, uint256 tokenId) internal virtual {
1037         _safeMint(to, tokenId, "");
1038     }
1039 
1040     /**
1041      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1042      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1043      */
1044     function _safeMint(
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) internal virtual {
1049         _mint(to, tokenId);
1050         require(
1051             _checkOnERC721Received(address(0), to, tokenId, _data),
1052             "ERC721: transfer to non ERC721Receiver implementer"
1053         );
1054     }
1055 
1056     /**
1057      * @dev Mints `tokenId` and transfers it to `to`.
1058      *
1059      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must not exist.
1064      * - `to` cannot be the zero address.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 tokenId) internal virtual {
1069         require(to != address(0), "ERC721: mint to the zero address");
1070         require(!_exists(tokenId), "ERC721: token already minted");
1071 
1072         _beforeTokenTransfer(address(0), to, tokenId);
1073 
1074         _balances[to] += 1;
1075         _owners[tokenId] = to;
1076 
1077         emit Transfer(address(0), to, tokenId);
1078 
1079         _afterTokenTransfer(address(0), to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId) internal virtual {
1093         address owner = ERC721.ownerOf(tokenId);
1094 
1095         _beforeTokenTransfer(owner, address(0), tokenId);
1096 
1097         // Clear approvals
1098         _approve(address(0), tokenId);
1099 
1100         _balances[owner] -= 1;
1101         delete _owners[tokenId];
1102 
1103         emit Transfer(owner, address(0), tokenId);
1104 
1105         _afterTokenTransfer(owner, address(0), tokenId);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {
1124         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1125         require(to != address(0), "ERC721: transfer to the zero address");
1126 
1127         _beforeTokenTransfer(from, to, tokenId);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId);
1131 
1132         _balances[from] -= 1;
1133         _balances[to] += 1;
1134         _owners[tokenId] = to;
1135 
1136         emit Transfer(from, to, tokenId);
1137 
1138         _afterTokenTransfer(from, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Approve `to` to operate on `tokenId`
1143      *
1144      * Emits a {Approval} event.
1145      */
1146     function _approve(address to, uint256 tokenId) internal virtual {
1147         _tokenApprovals[tokenId] = to;
1148         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Approve `operator` to operate on all of `owner` tokens
1153      *
1154      * Emits a {ApprovalForAll} event.
1155      */
1156     function _setApprovalForAll(
1157         address owner,
1158         address operator,
1159         bool approved
1160     ) internal virtual {
1161         require(owner != operator, "ERC721: approve to caller");
1162         _operatorApprovals[owner][operator] = approved;
1163         emit ApprovalForAll(owner, operator, approved);
1164     }
1165 
1166     /**
1167      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1168      * The call is not executed if the target address is not a contract.
1169      *
1170      * @param from address representing the previous owner of the given token ID
1171      * @param to target address that will receive the tokens
1172      * @param tokenId uint256 ID of the token to be transferred
1173      * @param _data bytes optional data to send along with the call
1174      * @return bool whether the call correctly returned the expected magic value
1175      */
1176     function _checkOnERC721Received(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes memory _data
1181     ) private returns (bool) {
1182         if (to.isContract()) {
1183             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1184                 return retval == IERC721Receiver.onERC721Received.selector;
1185             } catch (bytes memory reason) {
1186                 if (reason.length == 0) {
1187                     revert("ERC721: transfer to non ERC721Receiver implementer");
1188                 } else {
1189                     assembly {
1190                         revert(add(32, reason), mload(reason))
1191                     }
1192                 }
1193             }
1194         } else {
1195             return true;
1196         }
1197     }
1198 
1199     /**
1200      * @dev Hook that is called before any token transfer. This includes minting
1201      * and burning.
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` will be minted for `to`.
1208      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1209      * - `from` and `to` are never both zero.
1210      *
1211      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1212      */
1213     function _beforeTokenTransfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) internal virtual {}
1218 
1219     /**
1220      * @dev Hook that is called after any transfer of tokens. This includes
1221      * minting and burning.
1222      *
1223      * Calling conditions:
1224      *
1225      * - when `from` and `to` are both non-zero.
1226      * - `from` and `to` are never both zero.
1227      *
1228      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1229      */
1230     function _afterTokenTransfer(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) internal virtual {}
1235 }
1236 
1237 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1238 
1239 
1240 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1241 
1242 pragma solidity ^0.8.0;
1243 
1244 
1245 
1246 /**
1247  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1248  * enumerability of all the token ids in the contract as well as all token ids owned by each
1249  * account.
1250  */
1251 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1252     // Mapping from owner to list of owned token IDs
1253     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1254 
1255     // Mapping from token ID to index of the owner tokens list
1256     mapping(uint256 => uint256) private _ownedTokensIndex;
1257 
1258     // Array with all token ids, used for enumeration
1259     uint256[] private _allTokens;
1260 
1261     // Mapping from token id to position in the allTokens array
1262     mapping(uint256 => uint256) private _allTokensIndex;
1263 
1264     /**
1265      * @dev See {IERC165-supportsInterface}.
1266      */
1267     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1268         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1273      */
1274     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1275         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1276         return _ownedTokens[owner][index];
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Enumerable-totalSupply}.
1281      */
1282     function totalSupply() public view virtual override returns (uint256) {
1283         return _allTokens.length;
1284     }
1285 
1286     /**
1287      * @dev See {IERC721Enumerable-tokenByIndex}.
1288      */
1289     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1290         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1291         return _allTokens[index];
1292     }
1293 
1294     /**
1295      * @dev Hook that is called before any token transfer. This includes minting
1296      * and burning.
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1304      * - `from` cannot be the zero address.
1305      * - `to` cannot be the zero address.
1306      *
1307      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1308      */
1309     function _beforeTokenTransfer(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) internal virtual override {
1314         super._beforeTokenTransfer(from, to, tokenId);
1315 
1316         if (from == address(0)) {
1317             _addTokenToAllTokensEnumeration(tokenId);
1318         } else if (from != to) {
1319             _removeTokenFromOwnerEnumeration(from, tokenId);
1320         }
1321         if (to == address(0)) {
1322             _removeTokenFromAllTokensEnumeration(tokenId);
1323         } else if (to != from) {
1324             _addTokenToOwnerEnumeration(to, tokenId);
1325         }
1326     }
1327 
1328     /**
1329      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1330      * @param to address representing the new owner of the given token ID
1331      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1332      */
1333     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1334         uint256 length = ERC721.balanceOf(to);
1335         _ownedTokens[to][length] = tokenId;
1336         _ownedTokensIndex[tokenId] = length;
1337     }
1338 
1339     /**
1340      * @dev Private function to add a token to this extension's token tracking data structures.
1341      * @param tokenId uint256 ID of the token to be added to the tokens list
1342      */
1343     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1344         _allTokensIndex[tokenId] = _allTokens.length;
1345         _allTokens.push(tokenId);
1346     }
1347 
1348     /**
1349      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1350      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1351      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1352      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1353      * @param from address representing the previous owner of the given token ID
1354      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1355      */
1356     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1357         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1358         // then delete the last slot (swap and pop).
1359 
1360         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1361         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1362 
1363         // When the token to delete is the last token, the swap operation is unnecessary
1364         if (tokenIndex != lastTokenIndex) {
1365             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1366 
1367             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1368             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1369         }
1370 
1371         // This also deletes the contents at the last position of the array
1372         delete _ownedTokensIndex[tokenId];
1373         delete _ownedTokens[from][lastTokenIndex];
1374     }
1375 
1376     /**
1377      * @dev Private function to remove a token from this extension's token tracking data structures.
1378      * This has O(1) time complexity, but alters the order of the _allTokens array.
1379      * @param tokenId uint256 ID of the token to be removed from the tokens list
1380      */
1381     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1382         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1383         // then delete the last slot (swap and pop).
1384 
1385         uint256 lastTokenIndex = _allTokens.length - 1;
1386         uint256 tokenIndex = _allTokensIndex[tokenId];
1387 
1388         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1389         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1390         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1391         uint256 lastTokenId = _allTokens[lastTokenIndex];
1392 
1393         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1394         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1395 
1396         // This also deletes the contents at the last position of the array
1397         delete _allTokensIndex[tokenId];
1398         _allTokens.pop();
1399     }
1400 }
1401 
1402 // File: contracts/Rugged.sol
1403 
1404 
1405 pragma solidity ^0.8.4;
1406 
1407 
1408 
1409 
1410 
1411 
1412 contract RUGGED is ERC721, Pausable, ERC721Enumerable, Ownable{
1413     constructor() ERC721("RUGGED", "RUGGED") {}
1414 
1415     function _baseURI() internal pure override returns (string memory) {
1416         return "https://nevergoingtoreveal.com";
1417     }
1418 
1419      using Strings for uint256;
1420 
1421     uint256 private _reserved = 200;
1422     uint256 private _price = 0.00 ether;
1423     bool public _paused = false;
1424 
1425     function mint(uint256 num) public payable {
1426         uint256 supply = totalSupply();
1427         require( !_paused,                              "Sale paused" );
1428         require( num < 6,                              "Max mint is 5 asshole!" );
1429         require( supply + num < 3200 - _reserved,      "Exceeds maximum supply ser" );
1430         require( msg.value >= _price * num,             "Ether sent is not correct! Count they shillings and try again" );
1431 
1432         for(uint256 i; i < num; i++){
1433             _safeMint( msg.sender, supply + i );
1434         }
1435     }
1436 
1437     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1438         uint256 tokenCount = balanceOf(_owner);
1439 
1440         uint256[] memory tokensId = new uint256[](tokenCount);
1441         for(uint256 i; i < tokenCount; i++){
1442             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1443         }
1444         return tokensId;
1445     }
1446 
1447 
1448     function getPrice() public view returns (uint256){
1449         return _price;
1450     }
1451 
1452     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1453         require( _amount <= _reserved, "Giveaway limit reached" );
1454 
1455         uint256 supply = totalSupply();
1456         for(uint256 i; i < _amount; i++){
1457             _safeMint( _to, supply + i );
1458         }
1459 
1460         _reserved -= _amount;
1461     }
1462 
1463  
1464 
1465     function withdraw() external onlyOwner {
1466         uint256 balance = address(this).balance;
1467         payable(msg.sender).transfer(balance);
1468     }
1469 
1470      function pause() public onlyOwner {
1471         _pause();
1472     }
1473 
1474     function unpause() public onlyOwner {
1475         _unpause();
1476     }
1477 
1478 
1479     // The following functions are overrides required by Solidity.
1480 
1481     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1482         internal
1483         override(ERC721, ERC721Enumerable)
1484     {
1485         super._beforeTokenTransfer(from, to, tokenId);
1486     }
1487 
1488     function supportsInterface(bytes4 interfaceId)
1489         public
1490         view
1491         override(ERC721, ERC721Enumerable)
1492         returns (bool)
1493     {
1494         return super.supportsInterface(interfaceId);
1495     }
1496  }