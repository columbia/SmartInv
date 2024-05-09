1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5 *
6 *          t   __ __
7 *          h  |  Y__\_/_/
8 *          e   \ /       \      ##  ##
9 *               /    .__. \    #######
10 *          b   /  _       /_    #####
11 *          e  |  _ V     |V_     ##
12 *          e  |   V      \V
13 *          i   \         |   #  #
14 *          n   <\_______/   #####
15 *          g    ._L___L_.    ###
16 *          s      o   o       #
17 *
18 *          The official Beeings ERC-721 Smart Contract
19 */
20 
21 // File: @openzeppelin/contracts/utils/Counters.sol
22 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @title Counters
27  * @author Matt Condon (@shrugs)
28  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
29  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
30  *
31  * Include with `using Counters for Counters.Counter;`
32  */
33 library Counters {
34     struct Counter {
35         // This variable should never be directly accessed by users of the library: interactions must be restricted to
36         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
37         // this feature: see https://github.com/ethereum/solidity/issues/4637
38         uint256 _value; // default: 0
39     }
40 
41     function current(Counter storage counter) internal view returns (uint256) {
42         return counter._value;
43     }
44 
45     function increment(Counter storage counter) internal {
46         unchecked {
47             counter._value += 1;
48         }
49     }
50 
51     function decrement(Counter storage counter) internal {
52         uint256 value = counter._value;
53         require(value > 0, "Counter: decrement overflow");
54         unchecked {
55             counter._value = value - 1;
56         }
57     }
58 
59     function reset(Counter storage counter) internal {
60         counter._value = 0;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Context.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/security/Pausable.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Contract module which allows children to implement an emergency stop
171  * mechanism that can be triggered by an authorized account.
172  *
173  * This module is used through inheritance. It will make available the
174  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
175  * the functions of your contract. Note that they will not be pausable by
176  * simply including this module, only once the modifiers are put in place.
177  */
178 abstract contract Pausable is Context {
179     /**
180      * @dev Emitted when the pause is triggered by `account`.
181      */
182     event Paused(address account);
183 
184     /**
185      * @dev Emitted when the pause is lifted by `account`.
186      */
187     event Unpaused(address account);
188 
189     bool private _paused;
190 
191     /**
192      * @dev Initializes the contract in unpaused state.
193      */
194     constructor() {
195         _paused = false;
196     }
197 
198     /**
199      * @dev Returns true if the contract is paused, and false otherwise.
200      */
201     function paused() public view virtual returns (bool) {
202         return _paused;
203     }
204 
205     /**
206      * @dev Modifier to make a function callable only when the contract is not paused.
207      *
208      * Requirements:
209      *
210      * - The contract must not be paused.
211      */
212     modifier whenNotPaused() {
213         require(!paused(), "Pausable: paused");
214         _;
215     }
216 
217     /**
218      * @dev Modifier to make a function callable only when the contract is paused.
219      *
220      * Requirements:
221      *
222      * - The contract must be paused.
223      */
224     modifier whenPaused() {
225         require(paused(), "Pausable: not paused");
226         _;
227     }
228 
229     /**
230      * @dev Triggers stopped state.
231      *
232      * Requirements:
233      *
234      * - The contract must not be paused.
235      */
236     function _pause() internal virtual whenNotPaused {
237         _paused = true;
238         emit Paused(_msgSender());
239     }
240 
241     /**
242      * @dev Returns to normal state.
243      *
244      * Requirements:
245      *
246      * - The contract must be paused.
247      */
248     function _unpause() internal virtual whenPaused {
249         _paused = false;
250         emit Unpaused(_msgSender());
251     }
252 }
253 
254 // File: @openzeppelin/contracts/access/Ownable.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _transferOwnership(_msgSender());
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _transferOwnership(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 // File: @openzeppelin/contracts/utils/Address.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize, which returns 0 for contracts in
362         // construction, since the code is only stored at the end of the
363         // constructor execution.
364 
365         uint256 size;
366         assembly {
367             size := extcodesize(account)
368         }
369         return size > 0;
370     }
371 
372     /**
373      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
374      * `recipient`, forwarding all available gas and reverting on errors.
375      *
376      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
377      * of certain opcodes, possibly making contracts go over the 2300 gas limit
378      * imposed by `transfer`, making them unable to receive funds via
379      * `transfer`. {sendValue} removes this limitation.
380      *
381      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
382      *
383      * IMPORTANT: because control is transferred to `recipient`, care must be
384      * taken to not create reentrancy vulnerabilities. Consider using
385      * {ReentrancyGuard} or the
386      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
387      */
388     function sendValue(address payable recipient, uint256 amount) internal {
389         require(address(this).balance >= amount, "Address: insufficient balance");
390 
391         (bool success, ) = recipient.call{value: amount}("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain `call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value
446     ) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.call{value: value}(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
476         return functionStaticCall(target, data, "Address: low-level static call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(isContract(target), "Address: delegate call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.delegatecall(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
525      * revert reason using the provided one.
526      *
527      * _Available since v4.3._
528      */
529     function verifyCallResult(
530         bool success,
531         bytes memory returndata,
532         string memory errorMessage
533     ) internal pure returns (bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @title ERC721 token receiver interface
561  * @dev Interface for any contract that wants to support safeTransfers
562  * from ERC721 asset contracts.
563  */
564 interface IERC721Receiver {
565     /**
566      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
567      * by `operator` from `from`, this function is called.
568      *
569      * It must return its Solidity selector to confirm the token transfer.
570      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
571      *
572      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
573      */
574     function onERC721Received(
575         address operator,
576         address from,
577         uint256 tokenId,
578         bytes calldata data
579     ) external returns (bytes4);
580 }
581 
582 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Interface of the ERC165 standard, as defined in the
591  * https://eips.ethereum.org/EIPS/eip-165[EIP].
592  *
593  * Implementers can declare support of contract interfaces, which can then be
594  * queried by others ({ERC165Checker}).
595  *
596  * For an implementation, see {ERC165}.
597  */
598 interface IERC165 {
599     /**
600      * @dev Returns true if this contract implements the interface defined by
601      * `interfaceId`. See the corresponding
602      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
603      * to learn more about how these ids are created.
604      *
605      * This function call must use less than 30 000 gas.
606      */
607     function supportsInterface(bytes4 interfaceId) external view returns (bool);
608 }
609 
610 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @dev Implementation of the {IERC165} interface.
620  *
621  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
622  * for the additional interface id that will be supported. For example:
623  *
624  * ```solidity
625  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
627  * }
628  * ```
629  *
630  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
631  */
632 abstract contract ERC165 is IERC165 {
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
637         return interfaceId == type(IERC165).interfaceId;
638     }
639 }
640 
641 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
642 
643 
644 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @dev Required interface of an ERC721 compliant contract.
651  */
652 interface IERC721 is IERC165 {
653     /**
654      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
655      */
656     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
657 
658     /**
659      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
660      */
661     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
662 
663     /**
664      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
665      */
666     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
667 
668     /**
669      * @dev Returns the number of tokens in ``owner``'s account.
670      */
671     function balanceOf(address owner) external view returns (uint256 balance);
672 
673     /**
674      * @dev Returns the owner of the `tokenId` token.
675      *
676      * Requirements:
677      *
678      * - `tokenId` must exist.
679      */
680     function ownerOf(uint256 tokenId) external view returns (address owner);
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
684      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Transfers `tokenId` token from `from` to `to`.
704      *
705      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must be owned by `from`.
712      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
713      *
714      * Emits a {Transfer} event.
715      */
716     function transferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) external;
721 
722     /**
723      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
724      * The approval is cleared when the token is transferred.
725      *
726      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
727      *
728      * Requirements:
729      *
730      * - The caller must own the token or be an approved operator.
731      * - `tokenId` must exist.
732      *
733      * Emits an {Approval} event.
734      */
735     function approve(address to, uint256 tokenId) external;
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) external view returns (address operator);
745 
746     /**
747      * @dev Approve or remove `operator` as an operator for the caller.
748      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
749      *
750      * Requirements:
751      *
752      * - The `operator` cannot be the caller.
753      *
754      * Emits an {ApprovalForAll} event.
755      */
756     function setApprovalForAll(address operator, bool _approved) external;
757 
758     /**
759      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
760      *
761      * See {setApprovalForAll}
762      */
763     function isApprovedForAll(address owner, address operator) external view returns (bool);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes calldata data
783     ) external;
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
796  * @dev See https://eips.ethereum.org/EIPS/eip-721
797  */
798 interface IERC721Metadata is IERC721 {
799     /**
800      * @dev Returns the token collection name.
801      */
802     function name() external view returns (string memory);
803 
804     /**
805      * @dev Returns the token collection symbol.
806      */
807     function symbol() external view returns (string memory);
808 
809     /**
810      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
811      */
812     function tokenURI(uint256 tokenId) external view returns (string memory);
813 }
814 
815 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
816 
817 
818 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
819 
820 pragma solidity ^0.8.0;
821 
822 
823 
824 
825 
826 
827 
828 
829 /**
830  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
831  * the Metadata extension, but not including the Enumerable extension, which is available separately as
832  * {ERC721Enumerable}.
833  */
834 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
835     using Address for address;
836     using Strings for uint256;
837 
838     // Token name
839     string private _name;
840 
841     // Token symbol
842     string private _symbol;
843 
844     // Mapping from token ID to owner address
845     mapping(uint256 => address) private _owners;
846 
847     // Mapping owner address to token count
848     mapping(address => uint256) private _balances;
849 
850     // Mapping from token ID to approved address
851     mapping(uint256 => address) private _tokenApprovals;
852 
853     // Mapping from owner to operator approvals
854     mapping(address => mapping(address => bool)) private _operatorApprovals;
855 
856     /**
857      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
858      */
859     constructor(string memory name_, string memory symbol_) {
860         _name = name_;
861         _symbol = symbol_;
862     }
863 
864     /**
865      * @dev See {IERC165-supportsInterface}.
866      */
867     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
868         return
869             interfaceId == type(IERC721).interfaceId ||
870             interfaceId == type(IERC721Metadata).interfaceId ||
871             super.supportsInterface(interfaceId);
872     }
873 
874     /**
875      * @dev See {IERC721-balanceOf}.
876      */
877     function balanceOf(address owner) public view virtual override returns (uint256) {
878         require(owner != address(0), "ERC721: balance query for the zero address");
879         return _balances[owner];
880     }
881 
882     /**
883      * @dev See {IERC721-ownerOf}.
884      */
885     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
886         address owner = _owners[tokenId];
887         require(owner != address(0), "ERC721: owner query for nonexistent token");
888         return owner;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-name}.
893      */
894     function name() public view virtual override returns (string memory) {
895         return _name;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-symbol}.
900      */
901     function symbol() public view virtual override returns (string memory) {
902         return _symbol;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-tokenURI}.
907      */
908     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
909         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
910 
911         string memory baseURI = _baseURI();
912         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
913     }
914 
915     /**
916      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
917      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
918      * by default, can be overriden in child contracts.
919      */
920     function _baseURI() internal view virtual returns (string memory) {
921         return "";
922     }
923 
924     /**
925      * @dev See {IERC721-approve}.
926      */
927     function approve(address to, uint256 tokenId) public virtual override {
928         address owner = ERC721.ownerOf(tokenId);
929         require(to != owner, "ERC721: approval to current owner");
930 
931         require(
932             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
933             "ERC721: approve caller is not owner nor approved for all"
934         );
935 
936         _approve(to, tokenId);
937     }
938 
939     /**
940      * @dev See {IERC721-getApproved}.
941      */
942     function getApproved(uint256 tokenId) public view virtual override returns (address) {
943         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
944 
945         return _tokenApprovals[tokenId];
946     }
947 
948     /**
949      * @dev See {IERC721-setApprovalForAll}.
950      */
951     function setApprovalForAll(address operator, bool approved) public virtual override {
952         _setApprovalForAll(_msgSender(), operator, approved);
953     }
954 
955     /**
956      * @dev See {IERC721-isApprovedForAll}.
957      */
958     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
959         return _operatorApprovals[owner][operator];
960     }
961 
962     /**
963      * @dev See {IERC721-transferFrom}.
964      */
965     function transferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         //solhint-disable-next-line max-line-length
971         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
972 
973         _transfer(from, to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public virtual override {
984         safeTransferFrom(from, to, tokenId, "");
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) public virtual override {
996         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
997         _safeTransfer(from, to, tokenId, _data);
998     }
999 
1000     /**
1001      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1002      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1003      *
1004      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1005      *
1006      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1007      * implement alternative mechanisms to perform token transfer, such as signature-based.
1008      *
1009      * Requirements:
1010      *
1011      * - `from` cannot be the zero address.
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must exist and be owned by `from`.
1014      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _safeTransfer(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) internal virtual {
1024         _transfer(from, to, tokenId);
1025         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1026     }
1027 
1028     /**
1029      * @dev Returns whether `tokenId` exists.
1030      *
1031      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1032      *
1033      * Tokens start existing when they are minted (`_mint`),
1034      * and stop existing when they are burned (`_burn`).
1035      */
1036     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1037         return _owners[tokenId] != address(0);
1038     }
1039 
1040     /**
1041      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must exist.
1046      */
1047     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1048         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1049         address owner = ERC721.ownerOf(tokenId);
1050         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1051     }
1052 
1053     /**
1054      * @dev Safely mints `tokenId` and transfers it to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _safeMint(address to, uint256 tokenId) internal virtual {
1064         _safeMint(to, tokenId, "");
1065     }
1066 
1067     /**
1068      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1069      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1070      */
1071     function _safeMint(
1072         address to,
1073         uint256 tokenId,
1074         bytes memory _data
1075     ) internal virtual {
1076         _mint(to, tokenId);
1077         require(
1078             _checkOnERC721Received(address(0), to, tokenId, _data),
1079             "ERC721: transfer to non ERC721Receiver implementer"
1080         );
1081     }
1082 
1083     /**
1084      * @dev Mints `tokenId` and transfers it to `to`.
1085      *
1086      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must not exist.
1091      * - `to` cannot be the zero address.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _mint(address to, uint256 tokenId) internal virtual {
1096         require(to != address(0), "ERC721: mint to the zero address");
1097         require(!_exists(tokenId), "ERC721: token already minted");
1098 
1099         _beforeTokenTransfer(address(0), to, tokenId);
1100 
1101         _balances[to] += 1;
1102         _owners[tokenId] = to;
1103 
1104         emit Transfer(address(0), to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Destroys `tokenId`.
1109      * The approval is cleared when the token is burned.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _burn(uint256 tokenId) internal virtual {
1118         address owner = ERC721.ownerOf(tokenId);
1119 
1120         _beforeTokenTransfer(owner, address(0), tokenId);
1121 
1122         // Clear approvals
1123         _approve(address(0), tokenId);
1124 
1125         _balances[owner] -= 1;
1126         delete _owners[tokenId];
1127 
1128         emit Transfer(owner, address(0), tokenId);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must be owned by `from`.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _transfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual {
1147         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1148         require(to != address(0), "ERC721: transfer to the zero address");
1149 
1150         _beforeTokenTransfer(from, to, tokenId);
1151 
1152         // Clear approvals from the previous owner
1153         _approve(address(0), tokenId);
1154 
1155         _balances[from] -= 1;
1156         _balances[to] += 1;
1157         _owners[tokenId] = to;
1158 
1159         emit Transfer(from, to, tokenId);
1160     }
1161 
1162     /**
1163      * @dev Approve `to` to operate on `tokenId`
1164      *
1165      * Emits a {Approval} event.
1166      */
1167     function _approve(address to, uint256 tokenId) internal virtual {
1168         _tokenApprovals[tokenId] = to;
1169         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1170     }
1171 
1172     /**
1173      * @dev Approve `operator` to operate on all of `owner` tokens
1174      *
1175      * Emits a {ApprovalForAll} event.
1176      */
1177     function _setApprovalForAll(
1178         address owner,
1179         address operator,
1180         bool approved
1181     ) internal virtual {
1182         require(owner != operator, "ERC721: approve to caller");
1183         _operatorApprovals[owner][operator] = approved;
1184         emit ApprovalForAll(owner, operator, approved);
1185     }
1186 
1187     /**
1188      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1189      * The call is not executed if the target address is not a contract.
1190      *
1191      * @param from address representing the previous owner of the given token ID
1192      * @param to target address that will receive the tokens
1193      * @param tokenId uint256 ID of the token to be transferred
1194      * @param _data bytes optional data to send along with the call
1195      * @return bool whether the call correctly returned the expected magic value
1196      */
1197     function _checkOnERC721Received(
1198         address from,
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) private returns (bool) {
1203         if (to.isContract()) {
1204             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1205                 return retval == IERC721Receiver.onERC721Received.selector;
1206             } catch (bytes memory reason) {
1207                 if (reason.length == 0) {
1208                     revert("ERC721: transfer to non ERC721Receiver implementer");
1209                 } else {
1210                     assembly {
1211                         revert(add(32, reason), mload(reason))
1212                     }
1213                 }
1214             }
1215         } else {
1216             return true;
1217         }
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before any token transfer. This includes minting
1222      * and burning.
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1230      * - `from` and `to` are never both zero.
1231      *
1232      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1233      */
1234     function _beforeTokenTransfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) internal virtual {}
1239 }
1240 
1241 // File: contracts/beeings.sol
1242 pragma solidity ^0.8.0;
1243 
1244 contract Beeings is ERC721, Ownable, Pausable {
1245 	using Counters for Counters.Counter;
1246 	using Strings for uint256;
1247 
1248 	address 								_address_for_withdrawal = 0x5144E324bE090F8b22e56476E6e5ed624037f925;
1249 	Counters.Counter private				_total;
1250 	Counters.Counter private				_reserved_total;
1251 	mapping (address => bool) private		_whitelist;
1252 	mapping (address => uint256) private	_addr_balance;
1253 	uint256 private 						_price = 0.075 ether;
1254 	uint256 private 						_mint_supply = 10000;
1255 	uint256 private 						_mint_reserved = 50;
1256 	uint256 private 						_mint_limit = 3;
1257 	uint256 private 						_mint_limit_whitelist = 3;
1258 	string private 							_base_url = 'https://2-crypto.s3.amazonaws.com/the-beeings/NFT_META/';
1259 	bool private							_is_whitelist_only = true;
1260 	bool private							_mint_limit_by_addy = true;
1261 
1262 	//construct
1263 	constructor() ERC721('Beeings','BEE') {
1264 
1265 	}
1266 
1267 	//pausing of contract
1268 	function pause() external onlyOwner {
1269 		_pause();
1270 	}
1271 	function unpause() external onlyOwner {
1272 		_unpause();
1273 	}
1274 
1275 	//whitelist
1276 	function toggle_whitelist(bool change) external onlyOwner {
1277 		_is_whitelist_only = change;
1278 	}
1279 	function add_to_whitelist(address[] memory addresses) external onlyOwner {
1280 		for(uint i=0;i<addresses.length;i++) {
1281 			address user = addresses[i];
1282 			if(_whitelist[user]) {
1283 				continue;
1284 			}
1285 			_whitelist[user] = true;
1286 		}
1287 	}
1288 	function remove_from_whitelist(address[] memory addresses) external onlyOwner {
1289 		for(uint i=0;i<addresses.length;i++) {
1290 			address user = addresses[i];
1291 			if(_whitelist[user]) {
1292 				_whitelist[user] = false;
1293 			}
1294 		}
1295 	}
1296 	function is_whitelisted(address user) public view returns (bool) {
1297 		return _whitelist[user];
1298 	}
1299 	function is_whitelist_on() external view returns (bool) {
1300 		return _is_whitelist_only;
1301 	}
1302 
1303 	//set
1304 	function set_price(uint256 new_price) external onlyOwner() {
1305 		_price = new_price;
1306 	}
1307 	function set_mint_supply(uint256 new_limit) external onlyOwner() {
1308 		_mint_supply = new_limit;
1309 	}
1310 	function set_mint_reserve(uint256 new_limit) external onlyOwner() {
1311 		_mint_reserved = new_limit;
1312 	}
1313 	function set_mint_limit(uint256 new_limit) external onlyOwner() {
1314 		_mint_limit = new_limit;
1315 	}
1316 	function set_whitelist_mint_limit(uint256 new_limit) external onlyOwner() {
1317 		_mint_limit_whitelist = new_limit;
1318 	}
1319 	function set_mint_limit_state(bool state) external onlyOwner() {
1320 		_mint_limit_by_addy = state;
1321 	}
1322 	function set_base_url(string memory new_url) external onlyOwner() {
1323 		_base_url = new_url;
1324 	}
1325 
1326 	//get
1327 	function get_price() external view returns (uint256) {
1328 		return _price;
1329 	}
1330 	function get_supply_limit() external view returns (uint256) {
1331 		return _mint_supply;
1332 	}
1333 	function get_reserve_limit() external view returns (uint256) {
1334 		return _mint_reserved;
1335 	}
1336 	function get_mint_limit() external view returns (uint256) {
1337 		return _mint_limit;
1338 	}
1339 	function get_whitelisted_mint_limit() external view returns (uint256) {
1340 		return _mint_limit_whitelist;
1341 	}
1342 	function get_addr_minted_balance(address user) public view returns (uint256) {
1343 		return _addr_balance[user];
1344 	}
1345 	function baseTokenURI() public view returns (string memory) {
1346 		return _base_url;
1347 	}
1348 	function tokenURI(uint256 token_id) public view override returns (string memory) {
1349 		require(_exists(token_id),'missing token');
1350 		return string(abi.encodePacked(_base_url,token_id.toString()));
1351 	}
1352 	function get_total_reserved() external view returns (uint256) {
1353 		return _reserved_total.current();
1354 	}
1355 	function totalSupply() public view returns (uint256) {
1356 		return _total.current();
1357 	}
1358 
1359 	//withdraw
1360 	function withdraw() external payable onlyOwner {
1361 		require(payable(_address_for_withdrawal).send(address(this).balance-1));
1362 	}
1363 
1364 	//mint
1365 	function mint(uint256 mint_num) public payable {
1366 
1367 		//entire mint supply has been minted
1368 		require(_total.current() - _reserved_total.current() + mint_num <= _mint_supply - _mint_reserved, 'exceeded remaining');
1369 
1370 		//must mint at least one
1371 		require(mint_num > 0, 'must mint 1');
1372 
1373 		//minter did not send enough ETH
1374 		require(msg.value >= _price * mint_num, 'not enough eth');
1375 
1376 		//whitelist is on
1377 		if(_is_whitelist_only) {
1378 
1379 			//must be whitelisted
1380 			require(is_whitelisted(msg.sender),'not whitelisted');
1381 
1382 			//cannot mint more than allowed
1383 			require(get_addr_minted_balance(msg.sender) + mint_num <= _mint_limit_whitelist, 'exceeded max limit');
1384 		}
1385 
1386 		//cannot mint, per address, more than allowance
1387 		else if(_mint_limit_by_addy) {
1388 			require(get_addr_minted_balance(msg.sender) + mint_num <= _mint_limit, 'exceeded max limit');
1389 		}
1390 
1391 		//cannot mint, per transaction, more than allowance
1392 		else {
1393 			require(mint_num <= _mint_limit, 'exceeded max mint');
1394 		}
1395 
1396 		//mint
1397 		for(uint256 i;i<mint_num;i++) {
1398 			_total.increment();
1399 			_addr_balance[msg.sender] += 1;
1400 			_safeMint(msg.sender,_total.current());
1401 		}
1402 	}
1403 	function mint_reserve(address address_to, uint256 mint_num) external onlyOwner() {
1404 
1405 		//cannot mint more than what has been reserved
1406 		require(_reserved_total.current() + mint_num <= _mint_reserved, 'exceeded max limit.');
1407 
1408 		//mint
1409 		for(uint256 i;i<mint_num;i++) {
1410 			_total.increment();
1411 			_reserved_total.increment();
1412 			_safeMint(address_to,_total.current());
1413 		}
1414 
1415 	}
1416 	function _beforeTokenTransfer(address from, address to, uint256 token_id) internal whenNotPaused override(ERC721) {
1417 		super._beforeTokenTransfer(from, to, token_id);
1418 	}
1419 
1420 }