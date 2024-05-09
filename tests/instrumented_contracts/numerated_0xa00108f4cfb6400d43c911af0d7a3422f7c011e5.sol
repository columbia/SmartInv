1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/security/Pausable.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @dev Contract module which allows children to implement an emergency stop
187  * mechanism that can be triggered by an authorized account.
188  *
189  * This module is used through inheritance. It will make available the
190  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
191  * the functions of your contract. Note that they will not be pausable by
192  * simply including this module, only once the modifiers are put in place.
193  */
194 abstract contract Pausable is Context {
195     /**
196      * @dev Emitted when the pause is triggered by `account`.
197      */
198     event Paused(address account);
199 
200     /**
201      * @dev Emitted when the pause is lifted by `account`.
202      */
203     event Unpaused(address account);
204 
205     bool private _paused;
206 
207     /**
208      * @dev Initializes the contract in unpaused state.
209      */
210     constructor() {
211         _paused = false;
212     }
213 
214     /**
215      * @dev Returns true if the contract is paused, and false otherwise.
216      */
217     function paused() public view virtual returns (bool) {
218         return _paused;
219     }
220 
221     /**
222      * @dev Modifier to make a function callable only when the contract is not paused.
223      *
224      * Requirements:
225      *
226      * - The contract must not be paused.
227      */
228     modifier whenNotPaused() {
229         require(!paused(), "Pausable: paused");
230         _;
231     }
232 
233     /**
234      * @dev Modifier to make a function callable only when the contract is paused.
235      *
236      * Requirements:
237      *
238      * - The contract must be paused.
239      */
240     modifier whenPaused() {
241         require(paused(), "Pausable: not paused");
242         _;
243     }
244 
245     /**
246      * @dev Triggers stopped state.
247      *
248      * Requirements:
249      *
250      * - The contract must not be paused.
251      */
252     function _pause() internal virtual whenNotPaused {
253         _paused = true;
254         emit Paused(_msgSender());
255     }
256 
257     /**
258      * @dev Returns to normal state.
259      *
260      * Requirements:
261      *
262      * - The contract must be paused.
263      */
264     function _unpause() internal virtual whenPaused {
265         _paused = false;
266         emit Unpaused(_msgSender());
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
274 
275 pragma solidity ^0.8.1;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      *
298      * [IMPORTANT]
299      * ====
300      * You shouldn't rely on `isContract` to protect against flash loan attacks!
301      *
302      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
303      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
304      * constructor.
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // This method relies on extcodesize/address.code.length, which returns 0
309         // for contracts in construction, since the code is only stored at the end
310         // of the constructor execution.
311 
312         return account.code.length > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         (bool success, ) = recipient.call{value: amount}("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.call{value: value}(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @title ERC721 token receiver interface
504  * @dev Interface for any contract that wants to support safeTransfers
505  * from ERC721 asset contracts.
506  */
507 interface IERC721Receiver {
508     /**
509      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
510      * by `operator` from `from`, this function is called.
511      *
512      * It must return its Solidity selector to confirm the token transfer.
513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
514      *
515      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address operator,
519         address from,
520         uint256 tokenId,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @dev Interface of the ERC165 standard, as defined in the
534  * https://eips.ethereum.org/EIPS/eip-165[EIP].
535  *
536  * Implementers can declare support of contract interfaces, which can then be
537  * queried by others ({ERC165Checker}).
538  *
539  * For an implementation, see {ERC165}.
540  */
541 interface IERC165 {
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30 000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Required interface of an ERC721 compliant contract.
594  */
595 interface IERC721 is IERC165 {
596     /**
597      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
598      */
599     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
603      */
604     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
605 
606     /**
607      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
608      */
609     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
610 
611     /**
612      * @dev Returns the number of tokens in ``owner``'s account.
613      */
614     function balanceOf(address owner) external view returns (uint256 balance);
615 
616     /**
617      * @dev Returns the owner of the `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function ownerOf(uint256 tokenId) external view returns (address owner);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
627      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
636      *
637      * Emits a {Transfer} event.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Transfers `tokenId` token from `from` to `to`.
647      *
648      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must be owned by `from`.
655      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
656      *
657      * Emits a {Transfer} event.
658      */
659     function transferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) external;
664 
665     /**
666      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
667      * The approval is cleared when the token is transferred.
668      *
669      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
670      *
671      * Requirements:
672      *
673      * - The caller must own the token or be an approved operator.
674      * - `tokenId` must exist.
675      *
676      * Emits an {Approval} event.
677      */
678     function approve(address to, uint256 tokenId) external;
679 
680     /**
681      * @dev Returns the account approved for `tokenId` token.
682      *
683      * Requirements:
684      *
685      * - `tokenId` must exist.
686      */
687     function getApproved(uint256 tokenId) external view returns (address operator);
688 
689     /**
690      * @dev Approve or remove `operator` as an operator for the caller.
691      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
692      *
693      * Requirements:
694      *
695      * - The `operator` cannot be the caller.
696      *
697      * Emits an {ApprovalForAll} event.
698      */
699     function setApprovalForAll(address operator, bool _approved) external;
700 
701     /**
702      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes calldata data
726     ) external;
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
730 
731 
732 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Enumerable is IERC721 {
742     /**
743      * @dev Returns the total amount of tokens stored by the contract.
744      */
745     function totalSupply() external view returns (uint256);
746 
747     /**
748      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
749      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
750      */
751     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
752 
753     /**
754      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
755      * Use along with {totalSupply} to enumerate all tokens.
756      */
757     function tokenByIndex(uint256 index) external view returns (uint256);
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Metadata is IERC721 {
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 }
788 
789 // File: contracts/ERC721A.sol
790 
791 
792 // Creator: Chiru Labs
793 
794 pragma solidity ^0.8.4;
795 
796 
797 
798 
799 
800 
801 
802 
803 
804 error ApprovalCallerNotOwnerNorApproved();
805 error ApprovalQueryForNonexistentToken();
806 error ApproveToCaller();
807 error ApprovalToCurrentOwner();
808 error BalanceQueryForZeroAddress();
809 error MintedQueryForZeroAddress();
810 error BurnedQueryForZeroAddress();
811 error AuxQueryForZeroAddress();
812 error MintToZeroAddress();
813 error MintZeroQuantity();
814 error OwnerIndexOutOfBounds();
815 error OwnerQueryForNonexistentToken();
816 error TokenIndexOutOfBounds();
817 error TransferCallerNotOwnerNorApproved();
818 error TransferFromIncorrectOwner();
819 error TransferToNonERC721ReceiverImplementer();
820 error TransferToZeroAddress();
821 error URIQueryForNonexistentToken();
822 
823 /**
824  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
825  * the Metadata extension. Built to optimize for lower gas during batch mints.
826  *
827  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
828  *
829  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
830  *
831  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
832  */
833 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
834     using Address for address;
835     using Strings for uint256;
836 
837     // Compiler will pack this into a single 256bit word.
838     struct TokenOwnership {
839         // The address of the owner.
840         address addr;
841         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
842         uint64 startTimestamp;
843         // Whether the token has been burned.
844         bool burned;
845     }
846 
847     // Compiler will pack this into a single 256bit word.
848     struct AddressData {
849         // Realistically, 2**64-1 is more than enough.
850         uint64 balance;
851         // Keeps track of mint count with minimal overhead for tokenomics.
852         uint64 numberMinted;
853         // Keeps track of burn count with minimal overhead for tokenomics.
854         uint64 numberBurned;
855         // For miscellaneous variable(s) pertaining to the address
856         // (e.g. number of whitelist mint slots used). 
857         // If there are multiple variables, please pack them into a uint64.
858         uint64 aux;
859     }
860 
861     // The tokenId of the next token to be minted.
862     uint256 internal _currentIndex;
863 
864     // The number of tokens burned.
865     uint256 internal _burnCounter;
866 
867     // Token name
868     string private _name;
869 
870     // Token symbol
871     string private _symbol;
872 
873     // Mapping from token ID to ownership details
874     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
875     mapping(uint256 => TokenOwnership) internal _ownerships;
876 
877     // Mapping owner address to address data
878     mapping(address => AddressData) private _addressData;
879 
880     // Mapping from token ID to approved address
881     mapping(uint256 => address) private _tokenApprovals;
882 
883     // Mapping from owner to operator approvals
884     mapping(address => mapping(address => bool)) private _operatorApprovals;
885 
886     constructor(string memory name_, string memory symbol_) {
887         _name = name_;
888         _symbol = symbol_;
889     }
890 
891     /**
892      * @dev See {IERC721Enumerable-totalSupply}.
893      */
894     function totalSupply() public view returns (uint256) {
895         // Counter underflow is impossible as _burnCounter cannot be incremented
896         // more than _currentIndex times
897         unchecked {
898             return _currentIndex - _burnCounter;    
899         }
900     }
901 
902     /**
903      * @dev See {IERC165-supportsInterface}.
904      */
905     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
906         return
907             interfaceId == type(IERC721).interfaceId ||
908             interfaceId == type(IERC721Metadata).interfaceId ||
909             super.supportsInterface(interfaceId);
910     }
911 
912     /**
913      * @dev See {IERC721-balanceOf}.
914      */
915     function balanceOf(address owner) public view override returns (uint256) {
916         if (owner == address(0)) revert BalanceQueryForZeroAddress();
917         return uint256(_addressData[owner].balance);
918     }
919 
920     /**
921      * Returns the number of tokens minted by `owner`.
922      */
923     function _numberMinted(address owner) internal view returns (uint256) {
924         if (owner == address(0)) revert MintedQueryForZeroAddress();
925         return uint256(_addressData[owner].numberMinted);
926     }
927 
928     /**
929      * Returns the number of tokens burned by or on behalf of `owner`.
930      */
931     function _numberBurned(address owner) internal view returns (uint256) {
932         if (owner == address(0)) revert BurnedQueryForZeroAddress();
933         return uint256(_addressData[owner].numberBurned);
934     }
935 
936     /**
937      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
938      */
939     function _getAux(address owner) internal view returns (uint64) {
940         if (owner == address(0)) revert AuxQueryForZeroAddress();
941         return _addressData[owner].aux;
942     }
943 
944     /**
945      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
946      * If there are multiple variables, please pack them into a uint64.
947      */
948     function _setAux(address owner, uint64 aux) internal {
949         if (owner == address(0)) revert AuxQueryForZeroAddress();
950         _addressData[owner].aux = aux;
951     }
952 
953     /**
954      * Gas spent here starts off proportional to the maximum mint batch size.
955      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
956      */
957     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
958         uint256 curr = tokenId;
959 
960         unchecked {
961             if (curr < _currentIndex) {
962                 TokenOwnership memory ownership = _ownerships[curr];
963                 if (!ownership.burned) {
964                     if (ownership.addr != address(0)) {
965                         return ownership;
966                     }
967                     // Invariant: 
968                     // There will always be an ownership that has an address and is not burned 
969                     // before an ownership that does not have an address and is not burned.
970                     // Hence, curr will not underflow.
971                     while (true) {
972                         curr--;
973                         ownership = _ownerships[curr];
974                         if (ownership.addr != address(0)) {
975                             return ownership;
976                         }
977                     }
978                 }
979             }
980         }
981         revert OwnerQueryForNonexistentToken();
982     }
983 
984     /**
985      * @dev See {IERC721-ownerOf}.
986      */
987     function ownerOf(uint256 tokenId) public view override returns (address) {
988         return ownershipOf(tokenId).addr;
989     }
990 
991     /**
992      * @dev See {IERC721Metadata-name}.
993      */
994     function name() public view virtual override returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-symbol}.
1000      */
1001     function symbol() public view virtual override returns (string memory) {
1002         return _symbol;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-tokenURI}.
1007      */
1008     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1009         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1010 
1011         string memory baseURI = _baseURI();
1012         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1013     }
1014 
1015     /**
1016      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1017      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1018      * by default, can be overriden in child contracts.
1019      */
1020     function _baseURI() internal view virtual returns (string memory) {
1021         return '';
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-approve}.
1026      */
1027     function approve(address to, uint256 tokenId) public override {
1028         address owner = ERC721A.ownerOf(tokenId);
1029         if (to == owner) revert ApprovalToCurrentOwner();
1030 
1031         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1032             revert ApprovalCallerNotOwnerNorApproved();
1033         }
1034 
1035         _approve(to, tokenId, owner);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-getApproved}.
1040      */
1041     function getApproved(uint256 tokenId) public view override returns (address) {
1042         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1043 
1044         return _tokenApprovals[tokenId];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-setApprovalForAll}.
1049      */
1050     function setApprovalForAll(address operator, bool approved) public override {
1051         if (operator == _msgSender()) revert ApproveToCaller();
1052 
1053         _operatorApprovals[_msgSender()][operator] = approved;
1054         emit ApprovalForAll(_msgSender(), operator, approved);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-isApprovedForAll}.
1059      */
1060     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1061         return _operatorApprovals[owner][operator];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-transferFrom}.
1066      */
1067     function transferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         _transfer(from, to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) public virtual override {
1083         safeTransferFrom(from, to, tokenId, '');
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) public virtual override {
1095         _transfer(from, to, tokenId);
1096         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1097             revert TransferToNonERC721ReceiverImplementer();
1098         }
1099     }
1100 
1101     /**
1102      * @dev Returns whether `tokenId` exists.
1103      *
1104      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1105      *
1106      * Tokens start existing when they are minted (`_mint`),
1107      */
1108     function _exists(uint256 tokenId) internal view returns (bool) {
1109         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1110     }
1111 
1112     function _safeMint(address to, uint256 quantity) internal {
1113         _safeMint(to, quantity, '');
1114     }
1115 
1116     /**
1117      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1122      * - `quantity` must be greater than 0.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _safeMint(
1127         address to,
1128         uint256 quantity,
1129         bytes memory _data
1130     ) internal {
1131         _mint(to, quantity, _data, true);
1132     }
1133 
1134     /**
1135      * @dev Mints `quantity` tokens and transfers them to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _mint(
1145         address to,
1146         uint256 quantity,
1147         bytes memory _data,
1148         bool safe
1149     ) internal {
1150         uint256 startTokenId = _currentIndex;
1151         if (to == address(0)) revert MintToZeroAddress();
1152         if (quantity == 0) revert MintZeroQuantity();
1153 
1154         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1155 
1156         // Overflows are incredibly unrealistic.
1157         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1158         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1159         unchecked {
1160             _addressData[to].balance += uint64(quantity);
1161             _addressData[to].numberMinted += uint64(quantity);
1162 
1163             _ownerships[startTokenId].addr = to;
1164             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1165 
1166             uint256 updatedIndex = startTokenId;
1167 
1168             for (uint256 i; i < quantity; i++) {
1169                 emit Transfer(address(0), to, updatedIndex);
1170                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1171                     revert TransferToNonERC721ReceiverImplementer();
1172                 }
1173                 updatedIndex++;
1174             }
1175 
1176             _currentIndex = updatedIndex;
1177         }
1178         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1179     }
1180 
1181     /**
1182      * @dev Transfers `tokenId` from `from` to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `tokenId` token must be owned by `from`.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _transfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) private {
1196         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1197 
1198         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1199             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1200             getApproved(tokenId) == _msgSender());
1201 
1202         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1203         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1204         if (to == address(0)) revert TransferToZeroAddress();
1205 
1206         _beforeTokenTransfers(from, to, tokenId, 1);
1207 
1208         // Clear approvals from the previous owner
1209         _approve(address(0), tokenId, prevOwnership.addr);
1210 
1211         // Underflow of the sender's balance is impossible because we check for
1212         // ownership above and the recipient's balance can't realistically overflow.
1213         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1214         unchecked {
1215             _addressData[from].balance -= 1;
1216             _addressData[to].balance += 1;
1217 
1218             _ownerships[tokenId].addr = to;
1219             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1220 
1221             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1222             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1223             uint256 nextTokenId = tokenId + 1;
1224             if (_ownerships[nextTokenId].addr == address(0)) {
1225                 // This will suffice for checking _exists(nextTokenId),
1226                 // as a burned slot cannot contain the zero address.
1227                 if (nextTokenId < _currentIndex) {
1228                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1229                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1230                 }
1231             }
1232         }
1233 
1234         emit Transfer(from, to, tokenId);
1235         _afterTokenTransfers(from, to, tokenId, 1);
1236     }
1237 
1238     /**
1239      * @dev Destroys `tokenId`.
1240      * The approval is cleared when the token is burned.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _burn(uint256 tokenId) internal virtual {
1249         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1250 
1251         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1252 
1253         // Clear approvals from the previous owner
1254         _approve(address(0), tokenId, prevOwnership.addr);
1255 
1256         // Underflow of the sender's balance is impossible because we check for
1257         // ownership above and the recipient's balance can't realistically overflow.
1258         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1259         unchecked {
1260             _addressData[prevOwnership.addr].balance -= 1;
1261             _addressData[prevOwnership.addr].numberBurned += 1;
1262 
1263             // Keep track of who burned the token, and the timestamp of burning.
1264             _ownerships[tokenId].addr = prevOwnership.addr;
1265             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1266             _ownerships[tokenId].burned = true;
1267 
1268             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1269             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1270             uint256 nextTokenId = tokenId + 1;
1271             if (_ownerships[nextTokenId].addr == address(0)) {
1272                 // This will suffice for checking _exists(nextTokenId),
1273                 // as a burned slot cannot contain the zero address.
1274                 if (nextTokenId < _currentIndex) {
1275                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1276                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1277                 }
1278             }
1279         }
1280 
1281         emit Transfer(prevOwnership.addr, address(0), tokenId);
1282         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1283 
1284         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1285         unchecked { 
1286             _burnCounter++;
1287         }
1288     }
1289 
1290     /**
1291      * @dev Approve `to` to operate on `tokenId`
1292      *
1293      * Emits a {Approval} event.
1294      */
1295     function _approve(
1296         address to,
1297         uint256 tokenId,
1298         address owner
1299     ) private {
1300         _tokenApprovals[tokenId] = to;
1301         emit Approval(owner, to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1306      * The call is not executed if the target address is not a contract.
1307      *
1308      * @param from address representing the previous owner of the given token ID
1309      * @param to target address that will receive the tokens
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes optional data to send along with the call
1312      * @return bool whether the call correctly returned the expected magic value
1313      */
1314     function _checkOnERC721Received(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) private returns (bool) {
1320         if (to.isContract()) {
1321             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1322                 return retval == IERC721Receiver(to).onERC721Received.selector;
1323             } catch (bytes memory reason) {
1324                 if (reason.length == 0) {
1325                     revert TransferToNonERC721ReceiverImplementer();
1326                 } else {
1327                     assembly {
1328                         revert(add(32, reason), mload(reason))
1329                     }
1330                 }
1331             }
1332         } else {
1333             return true;
1334         }
1335     }
1336 
1337     /**
1338      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1339      * And also called before burning one token.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, `tokenId` will be burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _beforeTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 
1359     /**
1360      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1361      * minting.
1362      * And also called after one token has been burned.
1363      *
1364      * startTokenId - the first token id to be transferred
1365      * quantity - the amount to be transferred
1366      *
1367      * Calling conditions:
1368      *
1369      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1370      * transferred to `to`.
1371      * - When `from` is zero, `tokenId` has been minted for `to`.
1372      * - When `to` is zero, `tokenId` has been burned by `from`.
1373      * - `from` and `to` are never both zero.
1374      */
1375     function _afterTokenTransfers(
1376         address from,
1377         address to,
1378         uint256 startTokenId,
1379         uint256 quantity
1380     ) internal virtual {}
1381 }
1382 // File: contracts/ERC721ABurnable.sol
1383 
1384 
1385 // Creator: Chiru Labs
1386 
1387 pragma solidity ^0.8.4;
1388 
1389 
1390 
1391 /**
1392  * @title ERC721A Burnable Token
1393  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1394  */
1395 abstract contract ERC721ABurnable is Context, ERC721A {
1396 
1397     /**
1398      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1399      *
1400      * Requirements:
1401      *
1402      * - The caller must own `tokenId` or be an approved operator.
1403      */
1404     function burn(uint256 tokenId) public virtual {
1405         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1406 
1407         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1408             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1409             getApproved(tokenId) == _msgSender());
1410 
1411         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1412 
1413         _burn(tokenId);
1414     }
1415 }
1416 // File: contracts/Shines.sol
1417 
1418 
1419 pragma solidity ^0.8.4;
1420 
1421 
1422 
1423 
1424 
1425 contract Shines is ERC721A, ERC721ABurnable, Pausable, Ownable {
1426     string private _shines_base_uri = "ipfs://bafybeic6ru6yhnmeiefakg3c7pj5ylskom5bpa6qhjcb2cqcig7u2ezf64/metadata/";
1427     string private _shines_contract_uri = "ipfs://bafkreiadqeiuvo6l76qwnteeo5ee42n6qocwncds6tlmdbk6ca5ldxw6oy";
1428     uint256 public constant MAX_TOKENS = 3333;
1429     uint256 public constant FREE_MINT_TOKENS = 555;
1430     uint256 public constant MAX_PER_MINT = 20;
1431     uint256 public constant MINT_PRICE = 0.025 ether;
1432 
1433 
1434     constructor() ERC721A("Shines", "SHN") {}
1435 
1436     function pause() public onlyOwner {
1437         _pause();
1438     }
1439 
1440     function unpause() public onlyOwner {
1441         _unpause();
1442     }
1443 
1444 
1445     function safeMint(uint256 amount) public payable whenNotPaused{
1446         require(totalSupply() + amount <= MAX_TOKENS, "Can't mint that many tokens.");
1447         require(amount > 0 && amount <= MAX_PER_MINT, "Invalid amount");
1448 
1449         int256 chargable_amount;
1450         if(totalSupply() < FREE_MINT_TOKENS){
1451             chargable_amount = int256(amount) + int256(totalSupply()) - int256(FREE_MINT_TOKENS);
1452         }
1453         require(chargable_amount * int256(MINT_PRICE) <= int256(msg.value), "Insufficient ETH");
1454 
1455         _safeMint(msg.sender, amount);
1456 
1457     }
1458 
1459 
1460     function withdraw() public onlyOwner {
1461         uint256 balance = address(this).balance;
1462         payable(msg.sender).transfer(balance);
1463     }
1464 
1465 
1466     function _baseURI() internal view override returns (string memory) {
1467         return _shines_base_uri;
1468     }
1469 
1470     function setBaseURI(string memory baseURI) public onlyOwner {
1471         _shines_base_uri = baseURI;
1472     }
1473 
1474 
1475     function contractURI() public view returns (string memory) {
1476         return _shines_contract_uri;
1477     }
1478 
1479     function setContractURI(string memory URI) public onlyOwner {
1480         _shines_contract_uri = URI;
1481     }
1482 
1483 }