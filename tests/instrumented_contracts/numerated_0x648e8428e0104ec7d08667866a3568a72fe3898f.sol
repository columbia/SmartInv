1 // File: IScrapToken.sol
2 
3 
4 /*
5   _____   _____ _____ ___   _   ___ ___ ____
6  |   \ \ / / __|_   _/ _ \ /_\ | _ \ __|_  /
7  | |) \ V /\__ \ | || (_) / _ \|  _/ _| / /
8  |___/ |_| |___/ |_| \___/_/ \_\_| |___/___|
9 
10 */
11 
12 pragma solidity ^0.8.7;
13 
14 interface IScrapToken {
15 
16     function updateReward(address _from, address _to, uint256 _tokenId) external;
17 
18     function getClaimableReward(address _account) external view returns(uint256);
19 
20     function claimReward() external;
21 }
22 // File: @openzeppelin/contracts/utils/Address.sol
23 
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Collection of functions related to the address type
31  */
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      */
50     function isContract(address account) internal view returns (bool) {
51         // This method relies on extcodesize, which returns 0 for contracts in
52         // construction, since the code is only stored at the end of the
53         // constructor execution.
54 
55         uint256 size;
56         assembly {
57             size := extcodesize(account)
58         }
59         return size > 0;
60     }
61 
62     /**
63      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
64      * `recipient`, forwarding all available gas and reverting on errors.
65      *
66      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
67      * of certain opcodes, possibly making contracts go over the 2300 gas limit
68      * imposed by `transfer`, making them unable to receive funds via
69      * `transfer`. {sendValue} removes this limitation.
70      *
71      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
72      *
73      * IMPORTANT: because control is transferred to `recipient`, care must be
74      * taken to not create reentrancy vulnerabilities. Consider using
75      * {ReentrancyGuard} or the
76      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
77      */
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level `call`. A
87      * plain `call` is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If `target` reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
95      *
96      * Requirements:
97      *
98      * - `target` must be a contract.
99      * - calling `target` with `data` must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104         return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
109      * `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(
114         address target,
115         bytes memory data,
116         string memory errorMessage
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, 0, errorMessage);
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
123      * but also transferring `value` wei to `target`.
124      *
125      * Requirements:
126      *
127      * - the calling contract must have an ETH balance of at least `value`.
128      * - the called Solidity function must be `payable`.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value
136     ) internal returns (bytes memory) {
137         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
142      * with `errorMessage` as a fallback revert reason when `target` reverts.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         require(isContract(target), "Address: call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.call{value: value}(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
166         return functionStaticCall(target, data, "Address: low-level static call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
171      * but performing a static call.
172      *
173      * _Available since v3.3._
174      */
175     function functionStaticCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal view returns (bytes memory) {
180         require(isContract(target), "Address: static call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.staticcall(data);
183         return verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
198      * but performing a delegate call.
199      *
200      * _Available since v3.4._
201      */
202     function functionDelegateCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(isContract(target), "Address: delegate call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.delegatecall(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
215      * revert reason using the provided one.
216      *
217      * _Available since v4.3._
218      */
219     function verifyCallResult(
220         bool success,
221         bytes memory returndata,
222         string memory errorMessage
223     ) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             // Look for revert reason and bubble it up if present
228             if (returndata.length > 0) {
229                 // The easiest way to bubble the revert reason is using memory via assembly
230 
231                 assembly {
232                     let returndata_size := mload(returndata)
233                     revert(add(32, returndata), returndata_size)
234                 }
235             } else {
236                 revert(errorMessage);
237             }
238         }
239     }
240 }
241 
242 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by `operator` from `from`, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
263      */
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Interface of the ERC165 standard, as defined in the
281  * https://eips.ethereum.org/EIPS/eip-165[EIP].
282  *
283  * Implementers can declare support of contract interfaces, which can then be
284  * queried by others ({ERC165Checker}).
285  *
286  * For an implementation, see {ERC165}.
287  */
288 interface IERC165 {
289     /**
290      * @dev Returns true if this contract implements the interface defined by
291      * `interfaceId`. See the corresponding
292      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
293      * to learn more about how these ids are created.
294      *
295      * This function call must use less than 30 000 gas.
296      */
297     function supportsInterface(bytes4 interfaceId) external view returns (bool);
298 }
299 
300 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 
308 /**
309  * @dev Implementation of the {IERC165} interface.
310  *
311  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
312  * for the additional interface id that will be supported. For example:
313  *
314  * ```solidity
315  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
316  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
317  * }
318  * ```
319  *
320  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
321  */
322 abstract contract ERC165 is IERC165 {
323     /**
324      * @dev See {IERC165-supportsInterface}.
325      */
326     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327         return interfaceId == type(IERC165).interfaceId;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Required interface of an ERC721 compliant contract.
341  */
342 interface IERC721 is IERC165 {
343     /**
344      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
345      */
346     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
350      */
351     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
352 
353     /**
354      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
355      */
356     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
357 
358     /**
359      * @dev Returns the number of tokens in ``owner``'s account.
360      */
361     function balanceOf(address owner) external view returns (uint256 balance);
362 
363     /**
364      * @dev Returns the owner of the `tokenId` token.
365      *
366      * Requirements:
367      *
368      * - `tokenId` must exist.
369      */
370     function ownerOf(uint256 tokenId) external view returns (address owner);
371 
372     /**
373      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
374      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must exist and be owned by `from`.
381      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
383      *
384      * Emits a {Transfer} event.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Transfers `tokenId` token from `from` to `to`.
394      *
395      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
396      *
397      * Requirements:
398      *
399      * - `from` cannot be the zero address.
400      * - `to` cannot be the zero address.
401      * - `tokenId` token must be owned by `from`.
402      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 tokenId
410     ) external;
411 
412     /**
413      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
414      * The approval is cleared when the token is transferred.
415      *
416      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
417      *
418      * Requirements:
419      *
420      * - The caller must own the token or be an approved operator.
421      * - `tokenId` must exist.
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address to, uint256 tokenId) external;
426 
427     /**
428      * @dev Returns the account approved for `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function getApproved(uint256 tokenId) external view returns (address operator);
435 
436     /**
437      * @dev Approve or remove `operator` as an operator for the caller.
438      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
439      *
440      * Requirements:
441      *
442      * - The `operator` cannot be the caller.
443      *
444      * Emits an {ApprovalForAll} event.
445      */
446     function setApprovalForAll(address operator, bool _approved) external;
447 
448     /**
449      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
450      *
451      * See {setApprovalForAll}
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
486  * @dev See https://eips.ethereum.org/EIPS/eip-721
487  */
488 interface IERC721Metadata is IERC721 {
489     /**
490      * @dev Returns the token collection name.
491      */
492     function name() external view returns (string memory);
493 
494     /**
495      * @dev Returns the token collection symbol.
496      */
497     function symbol() external view returns (string memory);
498 
499     /**
500      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
501      */
502     function tokenURI(uint256 tokenId) external view returns (string memory);
503 }
504 
505 // File: @openzeppelin/contracts/utils/Context.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Provides information about the current execution context, including the
514  * sender of the transaction and its data. While these are generally available
515  * via msg.sender and msg.data, they should not be accessed in such a direct
516  * manner, since when dealing with meta-transactions the account sending and
517  * paying for execution may not be the actual sender (as far as an application
518  * is concerned).
519  *
520  * This contract is only required for intermediate, library-like contracts.
521  */
522 abstract contract Context {
523     function _msgSender() internal view virtual returns (address) {
524         return msg.sender;
525     }
526 
527     function _msgData() internal view virtual returns (bytes calldata) {
528         return msg.data;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/access/Ownable.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Contract module which provides a basic access control mechanism, where
542  * there is an account (an owner) that can be granted exclusive access to
543  * specific functions.
544  *
545  * By default, the owner account will be the one that deploys the contract. This
546  * can later be changed with {transferOwnership}.
547  *
548  * This module is used through inheritance. It will make available the modifier
549  * `onlyOwner`, which can be applied to your functions to restrict their use to
550  * the owner.
551  */
552 abstract contract Ownable is Context {
553     address private _owner;
554 
555     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
556 
557     /**
558      * @dev Initializes the contract setting the deployer as the initial owner.
559      */
560     constructor() {
561         _transferOwnership(_msgSender());
562     }
563 
564     /**
565      * @dev Returns the address of the current owner.
566      */
567     function owner() public view virtual returns (address) {
568         return _owner;
569     }
570 
571     /**
572      * @dev Throws if called by any account other than the owner.
573      */
574     modifier onlyOwner() {
575         require(owner() == _msgSender(), "Ownable: caller is not the owner");
576         _;
577     }
578 
579     /**
580      * @dev Leaves the contract without owner. It will not be possible to call
581      * `onlyOwner` functions anymore. Can only be called by the current owner.
582      *
583      * NOTE: Renouncing ownership will leave the contract without an owner,
584      * thereby removing any functionality that is only available to the owner.
585      */
586     function renounceOwnership() public virtual onlyOwner {
587         _transferOwnership(address(0));
588     }
589 
590     /**
591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
592      * Can only be called by the current owner.
593      */
594     function transferOwnership(address newOwner) public virtual onlyOwner {
595         require(newOwner != address(0), "Ownable: new owner is the zero address");
596         _transferOwnership(newOwner);
597     }
598 
599     /**
600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
601      * Internal function without access restriction.
602      */
603     function _transferOwnership(address newOwner) internal virtual {
604         address oldOwner = _owner;
605         _owner = newOwner;
606         emit OwnershipTransferred(oldOwner, newOwner);
607     }
608 }
609 
610 // File: @openzeppelin/contracts/security/Pausable.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @dev Contract module which allows children to implement an emergency stop
620  * mechanism that can be triggered by an authorized account.
621  *
622  * This module is used through inheritance. It will make available the
623  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
624  * the functions of your contract. Note that they will not be pausable by
625  * simply including this module, only once the modifiers are put in place.
626  */
627 abstract contract Pausable is Context {
628     /**
629      * @dev Emitted when the pause is triggered by `account`.
630      */
631     event Paused(address account);
632 
633     /**
634      * @dev Emitted when the pause is lifted by `account`.
635      */
636     event Unpaused(address account);
637 
638     bool private _paused;
639 
640     /**
641      * @dev Initializes the contract in unpaused state.
642      */
643     constructor() {
644         _paused = false;
645     }
646 
647     /**
648      * @dev Returns true if the contract is paused, and false otherwise.
649      */
650     function paused() public view virtual returns (bool) {
651         return _paused;
652     }
653 
654     /**
655      * @dev Modifier to make a function callable only when the contract is not paused.
656      *
657      * Requirements:
658      *
659      * - The contract must not be paused.
660      */
661     modifier whenNotPaused() {
662         require(!paused(), "Pausable: paused");
663         _;
664     }
665 
666     /**
667      * @dev Modifier to make a function callable only when the contract is paused.
668      *
669      * Requirements:
670      *
671      * - The contract must be paused.
672      */
673     modifier whenPaused() {
674         require(paused(), "Pausable: not paused");
675         _;
676     }
677 
678     /**
679      * @dev Triggers stopped state.
680      *
681      * Requirements:
682      *
683      * - The contract must not be paused.
684      */
685     function _pause() internal virtual whenNotPaused {
686         _paused = true;
687         emit Paused(_msgSender());
688     }
689 
690     /**
691      * @dev Returns to normal state.
692      *
693      * Requirements:
694      *
695      * - The contract must be paused.
696      */
697     function _unpause() internal virtual whenPaused {
698         _paused = false;
699         emit Unpaused(_msgSender());
700     }
701 }
702 
703 // File: @openzeppelin/contracts/utils/Strings.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 /**
711  * @dev String operations.
712  */
713 library Strings {
714     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
715 
716     /**
717      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
718      */
719     function toString(uint256 value) internal pure returns (string memory) {
720         // Inspired by OraclizeAPI's implementation - MIT licence
721         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
722 
723         if (value == 0) {
724             return "0";
725         }
726         uint256 temp = value;
727         uint256 digits;
728         while (temp != 0) {
729             digits++;
730             temp /= 10;
731         }
732         bytes memory buffer = new bytes(digits);
733         while (value != 0) {
734             digits -= 1;
735             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
736             value /= 10;
737         }
738         return string(buffer);
739     }
740 
741     /**
742      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
743      */
744     function toHexString(uint256 value) internal pure returns (string memory) {
745         if (value == 0) {
746             return "0x00";
747         }
748         uint256 temp = value;
749         uint256 length = 0;
750         while (temp != 0) {
751             length++;
752             temp >>= 8;
753         }
754         return toHexString(value, length);
755     }
756 
757     /**
758      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
759      */
760     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
761         bytes memory buffer = new bytes(2 * length + 2);
762         buffer[0] = "0";
763         buffer[1] = "x";
764         for (uint256 i = 2 * length + 1; i > 1; --i) {
765             buffer[i] = _HEX_SYMBOLS[value & 0xf];
766             value >>= 4;
767         }
768         require(value == 0, "Strings: hex length insufficient");
769         return string(buffer);
770     }
771 }
772 
773 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 
781 /**
782  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
783  *
784  * These functions can be used to verify that a message was signed by the holder
785  * of the private keys of a given address.
786  */
787 library ECDSA {
788     enum RecoverError {
789         NoError,
790         InvalidSignature,
791         InvalidSignatureLength,
792         InvalidSignatureS,
793         InvalidSignatureV
794     }
795 
796     function _throwError(RecoverError error) private pure {
797         if (error == RecoverError.NoError) {
798             return; // no error: do nothing
799         } else if (error == RecoverError.InvalidSignature) {
800             revert("ECDSA: invalid signature");
801         } else if (error == RecoverError.InvalidSignatureLength) {
802             revert("ECDSA: invalid signature length");
803         } else if (error == RecoverError.InvalidSignatureS) {
804             revert("ECDSA: invalid signature 's' value");
805         } else if (error == RecoverError.InvalidSignatureV) {
806             revert("ECDSA: invalid signature 'v' value");
807         }
808     }
809 
810     /**
811      * @dev Returns the address that signed a hashed message (`hash`) with
812      * `signature` or error string. This address can then be used for verification purposes.
813      *
814      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
815      * this function rejects them by requiring the `s` value to be in the lower
816      * half order, and the `v` value to be either 27 or 28.
817      *
818      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
819      * verification to be secure: it is possible to craft signatures that
820      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
821      * this is by receiving a hash of the original message (which may otherwise
822      * be too long), and then calling {toEthSignedMessageHash} on it.
823      *
824      * Documentation for signature generation:
825      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
826      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
827      *
828      * _Available since v4.3._
829      */
830     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
831         // Check the signature length
832         // - case 65: r,s,v signature (standard)
833         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
834         if (signature.length == 65) {
835             bytes32 r;
836             bytes32 s;
837             uint8 v;
838             // ecrecover takes the signature parameters, and the only way to get them
839             // currently is to use assembly.
840             assembly {
841                 r := mload(add(signature, 0x20))
842                 s := mload(add(signature, 0x40))
843                 v := byte(0, mload(add(signature, 0x60)))
844             }
845             return tryRecover(hash, v, r, s);
846         } else if (signature.length == 64) {
847             bytes32 r;
848             bytes32 vs;
849             // ecrecover takes the signature parameters, and the only way to get them
850             // currently is to use assembly.
851             assembly {
852                 r := mload(add(signature, 0x20))
853                 vs := mload(add(signature, 0x40))
854             }
855             return tryRecover(hash, r, vs);
856         } else {
857             return (address(0), RecoverError.InvalidSignatureLength);
858         }
859     }
860 
861     /**
862      * @dev Returns the address that signed a hashed message (`hash`) with
863      * `signature`. This address can then be used for verification purposes.
864      *
865      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
866      * this function rejects them by requiring the `s` value to be in the lower
867      * half order, and the `v` value to be either 27 or 28.
868      *
869      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
870      * verification to be secure: it is possible to craft signatures that
871      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
872      * this is by receiving a hash of the original message (which may otherwise
873      * be too long), and then calling {toEthSignedMessageHash} on it.
874      */
875     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
876         (address recovered, RecoverError error) = tryRecover(hash, signature);
877         _throwError(error);
878         return recovered;
879     }
880 
881     /**
882      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
883      *
884      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
885      *
886      * _Available since v4.3._
887      */
888     function tryRecover(
889         bytes32 hash,
890         bytes32 r,
891         bytes32 vs
892     ) internal pure returns (address, RecoverError) {
893         bytes32 s;
894         uint8 v;
895         assembly {
896             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
897             v := add(shr(255, vs), 27)
898         }
899         return tryRecover(hash, v, r, s);
900     }
901 
902     /**
903      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
904      *
905      * _Available since v4.2._
906      */
907     function recover(
908         bytes32 hash,
909         bytes32 r,
910         bytes32 vs
911     ) internal pure returns (address) {
912         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
913         _throwError(error);
914         return recovered;
915     }
916 
917     /**
918      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
919      * `r` and `s` signature fields separately.
920      *
921      * _Available since v4.3._
922      */
923     function tryRecover(
924         bytes32 hash,
925         uint8 v,
926         bytes32 r,
927         bytes32 s
928     ) internal pure returns (address, RecoverError) {
929         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
930         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
931         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
932         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
933         //
934         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
935         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
936         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
937         // these malleable signatures as well.
938         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
939             return (address(0), RecoverError.InvalidSignatureS);
940         }
941         if (v != 27 && v != 28) {
942             return (address(0), RecoverError.InvalidSignatureV);
943         }
944 
945         // If the signature is valid (and not malleable), return the signer address
946         address signer = ecrecover(hash, v, r, s);
947         if (signer == address(0)) {
948             return (address(0), RecoverError.InvalidSignature);
949         }
950 
951         return (signer, RecoverError.NoError);
952     }
953 
954     /**
955      * @dev Overload of {ECDSA-recover} that receives the `v`,
956      * `r` and `s` signature fields separately.
957      */
958     function recover(
959         bytes32 hash,
960         uint8 v,
961         bytes32 r,
962         bytes32 s
963     ) internal pure returns (address) {
964         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
965         _throwError(error);
966         return recovered;
967     }
968 
969     /**
970      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
971      * produces hash corresponding to the one signed with the
972      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
973      * JSON-RPC method as part of EIP-191.
974      *
975      * See {recover}.
976      */
977     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
978         // 32 is the length in bytes of hash,
979         // enforced by the type signature above
980         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
981     }
982 
983     /**
984      * @dev Returns an Ethereum Signed Message, created from `s`. This
985      * produces hash corresponding to the one signed with the
986      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
987      * JSON-RPC method as part of EIP-191.
988      *
989      * See {recover}.
990      */
991     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
992         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
993     }
994 
995     /**
996      * @dev Returns an Ethereum Signed Typed Data, created from a
997      * `domainSeparator` and a `structHash`. This produces hash corresponding
998      * to the one signed with the
999      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1000      * JSON-RPC method as part of EIP-712.
1001      *
1002      * See {recover}.
1003      */
1004     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1005         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1006     }
1007 }
1008 
1009 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1010 
1011 
1012 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 /**
1024  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1025  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1026  * {ERC721Enumerable}.
1027  */
1028 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1029     using Address for address;
1030     using Strings for uint256;
1031 
1032     // Token name
1033     string private _name;
1034 
1035     // Token symbol
1036     string private _symbol;
1037 
1038     // Mapping from token ID to owner address
1039     mapping(uint256 => address) private _owners;
1040 
1041     // Mapping owner address to token count
1042     mapping(address => uint256) private _balances;
1043 
1044     // Mapping from token ID to approved address
1045     mapping(uint256 => address) private _tokenApprovals;
1046 
1047     // Mapping from owner to operator approvals
1048     mapping(address => mapping(address => bool)) private _operatorApprovals;
1049 
1050     /**
1051      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1052      */
1053     constructor(string memory name_, string memory symbol_) {
1054         _name = name_;
1055         _symbol = symbol_;
1056     }
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1062         return
1063             interfaceId == type(IERC721).interfaceId ||
1064             interfaceId == type(IERC721Metadata).interfaceId ||
1065             super.supportsInterface(interfaceId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-balanceOf}.
1070      */
1071     function balanceOf(address owner) public view virtual override returns (uint256) {
1072         require(owner != address(0), "ERC721: balance query for the zero address");
1073         return _balances[owner];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-ownerOf}.
1078      */
1079     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1080         address owner = _owners[tokenId];
1081         require(owner != address(0), "ERC721: owner query for nonexistent token");
1082         return owner;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-name}.
1087      */
1088     function name() public view virtual override returns (string memory) {
1089         return _name;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-symbol}.
1094      */
1095     function symbol() public view virtual override returns (string memory) {
1096         return _symbol;
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Metadata-tokenURI}.
1101      */
1102     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1103         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1104 
1105         string memory baseURI = _baseURI();
1106         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1107     }
1108 
1109     /**
1110      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1111      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1112      * by default, can be overriden in child contracts.
1113      */
1114     function _baseURI() internal view virtual returns (string memory) {
1115         return "";
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-approve}.
1120      */
1121     function approve(address to, uint256 tokenId) public virtual override {
1122         address owner = ERC721.ownerOf(tokenId);
1123         require(to != owner, "ERC721: approval to current owner");
1124 
1125         require(
1126             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1127             "ERC721: approve caller is not owner nor approved for all"
1128         );
1129 
1130         _approve(to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-getApproved}.
1135      */
1136     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1137         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1138 
1139         return _tokenApprovals[tokenId];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-setApprovalForAll}.
1144      */
1145     function setApprovalForAll(address operator, bool approved) public virtual override {
1146         _setApprovalForAll(_msgSender(), operator, approved);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-isApprovedForAll}.
1151      */
1152     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1153         return _operatorApprovals[owner][operator];
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-transferFrom}.
1158      */
1159     function transferFrom(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) public virtual override {
1164         //solhint-disable-next-line max-line-length
1165         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1166 
1167         _transfer(from, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         safeTransferFrom(from, to, tokenId, "");
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-safeTransferFrom}.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) public virtual override {
1190         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1191         _safeTransfer(from, to, tokenId, _data);
1192     }
1193 
1194     /**
1195      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1196      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1197      *
1198      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1199      *
1200      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1201      * implement alternative mechanisms to perform token transfer, such as signature-based.
1202      *
1203      * Requirements:
1204      *
1205      * - `from` cannot be the zero address.
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must exist and be owned by `from`.
1208      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _safeTransfer(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) internal virtual {
1218         _transfer(from, to, tokenId);
1219         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1220     }
1221 
1222     /**
1223      * @dev Returns whether `tokenId` exists.
1224      *
1225      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1226      *
1227      * Tokens start existing when they are minted (`_mint`),
1228      * and stop existing when they are burned (`_burn`).
1229      */
1230     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1231         return _owners[tokenId] != address(0);
1232     }
1233 
1234     /**
1235      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      */
1241     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1242         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1243         address owner = ERC721.ownerOf(tokenId);
1244         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1245     }
1246 
1247     /**
1248      * @dev Safely mints `tokenId` and transfers it to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - `tokenId` must not exist.
1253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _safeMint(address to, uint256 tokenId) internal virtual {
1258         _safeMint(to, tokenId, "");
1259     }
1260 
1261     /**
1262      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1263      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1264      */
1265     function _safeMint(
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) internal virtual {
1270         _mint(to, tokenId);
1271         require(
1272             _checkOnERC721Received(address(0), to, tokenId, _data),
1273             "ERC721: transfer to non ERC721Receiver implementer"
1274         );
1275     }
1276 
1277     /**
1278      * @dev Mints `tokenId` and transfers it to `to`.
1279      *
1280      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must not exist.
1285      * - `to` cannot be the zero address.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _mint(address to, uint256 tokenId) internal virtual {
1290         require(to != address(0), "ERC721: mint to the zero address");
1291         require(!_exists(tokenId), "ERC721: token already minted");
1292 
1293         _beforeTokenTransfer(address(0), to, tokenId);
1294 
1295         _balances[to] += 1;
1296         _owners[tokenId] = to;
1297 
1298         emit Transfer(address(0), to, tokenId);
1299     }
1300 
1301     /**
1302      * @dev Destroys `tokenId`.
1303      * The approval is cleared when the token is burned.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _burn(uint256 tokenId) internal virtual {
1312         address owner = ERC721.ownerOf(tokenId);
1313 
1314         _beforeTokenTransfer(owner, address(0), tokenId);
1315 
1316         // Clear approvals
1317         _approve(address(0), tokenId);
1318 
1319         _balances[owner] -= 1;
1320         delete _owners[tokenId];
1321 
1322         emit Transfer(owner, address(0), tokenId);
1323     }
1324 
1325     /**
1326      * @dev Transfers `tokenId` from `from` to `to`.
1327      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1328      *
1329      * Requirements:
1330      *
1331      * - `to` cannot be the zero address.
1332      * - `tokenId` token must be owned by `from`.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _transfer(
1337         address from,
1338         address to,
1339         uint256 tokenId
1340     ) internal virtual {
1341         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1342         require(to != address(0), "ERC721: transfer to the zero address");
1343 
1344         _beforeTokenTransfer(from, to, tokenId);
1345 
1346         // Clear approvals from the previous owner
1347         _approve(address(0), tokenId);
1348 
1349         _balances[from] -= 1;
1350         _balances[to] += 1;
1351         _owners[tokenId] = to;
1352 
1353         emit Transfer(from, to, tokenId);
1354     }
1355 
1356     /**
1357      * @dev Approve `to` to operate on `tokenId`
1358      *
1359      * Emits a {Approval} event.
1360      */
1361     function _approve(address to, uint256 tokenId) internal virtual {
1362         _tokenApprovals[tokenId] = to;
1363         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1364     }
1365 
1366     /**
1367      * @dev Approve `operator` to operate on all of `owner` tokens
1368      *
1369      * Emits a {ApprovalForAll} event.
1370      */
1371     function _setApprovalForAll(
1372         address owner,
1373         address operator,
1374         bool approved
1375     ) internal virtual {
1376         require(owner != operator, "ERC721: approve to caller");
1377         _operatorApprovals[owner][operator] = approved;
1378         emit ApprovalForAll(owner, operator, approved);
1379     }
1380 
1381     /**
1382      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1383      * The call is not executed if the target address is not a contract.
1384      *
1385      * @param from address representing the previous owner of the given token ID
1386      * @param to target address that will receive the tokens
1387      * @param tokenId uint256 ID of the token to be transferred
1388      * @param _data bytes optional data to send along with the call
1389      * @return bool whether the call correctly returned the expected magic value
1390      */
1391     function _checkOnERC721Received(
1392         address from,
1393         address to,
1394         uint256 tokenId,
1395         bytes memory _data
1396     ) private returns (bool) {
1397         if (to.isContract()) {
1398             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1399                 return retval == IERC721Receiver.onERC721Received.selector;
1400             } catch (bytes memory reason) {
1401                 if (reason.length == 0) {
1402                     revert("ERC721: transfer to non ERC721Receiver implementer");
1403                 } else {
1404                     assembly {
1405                         revert(add(32, reason), mload(reason))
1406                     }
1407                 }
1408             }
1409         } else {
1410             return true;
1411         }
1412     }
1413 
1414     /**
1415      * @dev Hook that is called before any token transfer. This includes minting
1416      * and burning.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1424      * - `from` and `to` are never both zero.
1425      *
1426      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1427      */
1428     function _beforeTokenTransfer(
1429         address from,
1430         address to,
1431         uint256 tokenId
1432     ) internal virtual {}
1433 }
1434 
1435 // File: DystoApez.sol
1436 
1437 
1438 /*
1439 
1440   _____   _____ _____ ___   _   ___ ___ ____
1441  |   \ \ / / __|_   _/ _ \ /_\ | _ \ __|_  /
1442  | |) \ V /\__ \ | || (_) / _ \|  _/ _| / /
1443  |___/ |_| |___/ |_| \___/_/ \_\_| |___/___|
1444 
1445 
1446 */
1447 
1448 pragma solidity ^0.8.7;
1449 
1450 
1451 
1452 
1453 
1454 
1455 
1456 contract DystoApez is ERC721, Ownable, Pausable {
1457     using Strings for uint256;
1458     uint256 public constant MAX_SUPPLY = 4444;
1459     uint256 public constant MINT_PRICE = 0.06 ether;
1460     uint256 public constant MINT_PRICE_PUBLIC = 0.07 ether;
1461     uint256 public constant MAX_MINT_PER_TX = 5;
1462     uint256 constant public LEGENDARY_SUPPLY = 10;
1463 
1464     mapping(bytes32 => bool) private _usedHashes;
1465 
1466     bool public saleStarted = false;
1467     bool public preSaleStarted = false;
1468     bool public lock = false;
1469     address private _signerAddress;
1470     uint256 public totalSupply = 0;
1471     IScrapToken public scrapToken;
1472 
1473     string public prefixURI;
1474     string public commonURI;
1475 
1476     mapping(uint256 => string) public tokenURIs;
1477 
1478     constructor() ERC721("DystoApez", "DYSTO") { }
1479 
1480     function mintLegendary() external onlyOwner {
1481         require(totalSupply == 0, "MINT_ALREADY_STARTED");
1482         for (uint256 i = 1; i <= LEGENDARY_SUPPLY; i++) {
1483             _safeMint(msg.sender, totalSupply + i);
1484         }
1485         totalSupply += LEGENDARY_SUPPLY;
1486     }
1487 
1488     function mintAdmin(uint256 _count, address _account) external onlyOwner {
1489         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1490         require(totalSupply >= LEGENDARY_SUPPLY, "LEGENDARY_NOT_MINTED");
1491         for (uint256 i = 1; i <= _count; i++) {
1492             _safeMint(_account, totalSupply + i);
1493         }
1494         totalSupply += _count;
1495     }
1496 
1497     function mintWhitelist(
1498         uint256 _count,
1499         uint256 _maxCount,
1500         bytes memory _sig)
1501         external
1502         payable
1503     {
1504         require(preSaleStarted, "MINT_NOT_STARTED");
1505         require(_count > 0 && _count <= _maxCount, "COUNT_INVALID");
1506         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1507         require(totalSupply >= LEGENDARY_SUPPLY, "LEGENDARY_NOT_MINTED");
1508         require(msg.value == (_count * MINT_PRICE), "INVALID_ETH_SENT");
1509 
1510         bytes32 hash = keccak256(abi.encode(_msgSender(), _maxCount));
1511         require(!_usedHashes[hash], "HASH_ALREADY_USED");
1512         require(_matchSigner(hash, _sig), "INVALID_SIGNER");
1513 
1514         _usedHashes[hash] = true;
1515         for (uint256 i = 1; i <= _count; i++) {
1516             _safeMint(msg.sender, totalSupply + i);
1517         }
1518         totalSupply += _count;
1519     }
1520 
1521     function _matchSigner(bytes32 _hash, bytes memory _signature) private view returns(bool) {
1522         return _signerAddress == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
1523     }
1524 
1525     function isWhiteList(
1526         address _sender,
1527         uint256 _maxCount,
1528         bytes calldata _sig
1529     ) public view returns(bool) {
1530         bytes32 _hash = keccak256(abi.encode(_sender, _maxCount));
1531         if (!_matchSigner(_hash, _sig)) {
1532             return false;
1533         }
1534         if (_usedHashes[_hash]) {
1535             return false;
1536         }
1537         return true;
1538     }
1539 
1540 
1541     // Public Mint
1542     function mint(uint256 _count) public payable {
1543         require(saleStarted, "MINT_NOT_STARTED");
1544         require(_count > 0 && _count <= MAX_MINT_PER_TX, "COUNT_INVALID");
1545         require(totalSupply >= LEGENDARY_SUPPLY, "LEGENDARY_NOT_MINTED");
1546         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1547         require(msg.value == (_count * MINT_PRICE_PUBLIC), "INVALID_ETH_SENT");
1548 
1549         for (uint256 i = 1; i <= _count; i++) {
1550             _safeMint(msg.sender, totalSupply + i);
1551         }
1552         totalSupply += _count;
1553     }
1554 
1555     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1556         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1557         if (bytes(tokenURIs[tokenId]).length != 0) {
1558             return tokenURIs[tokenId];
1559         }
1560         if (bytes(commonURI).length != 0) {
1561             return commonURI;
1562         }
1563         return string(abi.encodePacked(prefixURI, tokenId.toString()));
1564     }
1565 
1566     // ** Admin Fuctions ** //
1567     function withdraw(address payable _to) external onlyOwner {
1568         require(_to != address(0), "WITHDRAW_ADDRESS_ZERO");
1569         require(address(this).balance > 0, "EMPTY_BALANCE");
1570         _to.transfer(address(this).balance);
1571     }
1572 
1573     function setSaleStarted(bool _hasStarted) external onlyOwner {
1574         require(saleStarted != _hasStarted, "SALE_STARTED_ALREADY_SET");
1575         saleStarted = _hasStarted;
1576     }
1577 
1578     function setPreSaleStarted(bool _hasStarted) external onlyOwner {
1579         require(preSaleStarted != _hasStarted, "SALE_STARTED_ALREADY_SET");
1580         preSaleStarted = _hasStarted;
1581     }
1582 
1583     function setSignerAddress(address _signer) external onlyOwner {
1584         require(_signer != address(0), "SIGNER_ADDRESS_ZERO");
1585         _signerAddress = _signer;
1586     }
1587 
1588     function lockBaseURI() external onlyOwner {
1589         require(!lock, "ALREADY_LOCKED");
1590         lock = true;
1591     }
1592 
1593     function setPrefixURI(string calldata _uri) external onlyOwner {
1594         require(!lock, "ALREADY_LOCKED");
1595         prefixURI = _uri;
1596         commonURI = '';
1597     }
1598 
1599     function setCommonURI(string calldata _uri) external onlyOwner {
1600         require(!lock, "ALREADY_LOCKED");
1601         commonURI = _uri;
1602         prefixURI = '';
1603     }
1604 
1605     function setTokenURI(string calldata _uri, uint256 _tokenId) external onlyOwner {
1606         require(!lock, "ALREADY_LOCKED");
1607         tokenURIs[_tokenId] = _uri;
1608     }
1609 
1610     function setScrapToken(address _token) external onlyOwner {
1611         require(_token != address(scrapToken), "TOKEN_ALREADY_SET");
1612         require(_token != address(0), "TOKEN_ADDRESS_ZERO");
1613         scrapToken = IScrapToken(_token);
1614     }
1615 
1616 
1617     function pause() external onlyOwner {
1618         require(!paused(), "ALREADY_PAUSED");
1619         _pause();
1620     }
1621 
1622     function unpause() external onlyOwner {
1623         require(paused(), "ALREADY_UNPAUSED");
1624         _unpause();
1625     }
1626 
1627     function _beforeTokenTransfer(
1628         address from,
1629         address to,
1630         uint256 tokenId
1631     ) override internal virtual {
1632         require(!paused(), "TRANSFER_PAUSED");
1633         scrapToken.updateReward(from, to, tokenId);
1634         super._beforeTokenTransfer(from, to, tokenId);
1635     }
1636 }