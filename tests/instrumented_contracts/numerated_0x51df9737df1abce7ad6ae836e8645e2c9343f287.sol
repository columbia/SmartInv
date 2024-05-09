1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * NOTE: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public virtual onlyOwner {
199         _transferOwnership(address(0));
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Internal function without access restriction.
214      */
215     function _transferOwnership(address newOwner) internal virtual {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/security/Pausable.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 
230 /**
231  * @dev Contract module which allows children to implement an emergency stop
232  * mechanism that can be triggered by an authorized account.
233  *
234  * This module is used through inheritance. It will make available the
235  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
236  * the functions of your contract. Note that they will not be pausable by
237  * simply including this module, only once the modifiers are put in place.
238  */
239 abstract contract Pausable is Context {
240     /**
241      * @dev Emitted when the pause is triggered by `account`.
242      */
243     event Paused(address account);
244 
245     /**
246      * @dev Emitted when the pause is lifted by `account`.
247      */
248     event Unpaused(address account);
249 
250     bool private _paused;
251 
252     /**
253      * @dev Initializes the contract in unpaused state.
254      */
255     constructor() {
256         _paused = false;
257     }
258 
259     /**
260      * @dev Returns true if the contract is paused, and false otherwise.
261      */
262     function paused() public view virtual returns (bool) {
263         return _paused;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is not paused.
268      *
269      * Requirements:
270      *
271      * - The contract must not be paused.
272      */
273     modifier whenNotPaused() {
274         require(!paused(), "Pausable: paused");
275         _;
276     }
277 
278     /**
279      * @dev Modifier to make a function callable only when the contract is paused.
280      *
281      * Requirements:
282      *
283      * - The contract must be paused.
284      */
285     modifier whenPaused() {
286         require(paused(), "Pausable: not paused");
287         _;
288     }
289 
290     /**
291      * @dev Triggers stopped state.
292      *
293      * Requirements:
294      *
295      * - The contract must not be paused.
296      */
297     function _pause() internal virtual whenNotPaused {
298         _paused = true;
299         emit Paused(_msgSender());
300     }
301 
302     /**
303      * @dev Returns to normal state.
304      *
305      * Requirements:
306      *
307      * - The contract must be paused.
308      */
309     function _unpause() internal virtual whenPaused {
310         _paused = false;
311         emit Unpaused(_msgSender());
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/Address.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
319 
320 pragma solidity ^0.8.1;
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      *
343      * [IMPORTANT]
344      * ====
345      * You shouldn't rely on `isContract` to protect against flash loan attacks!
346      *
347      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
348      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
349      * constructor.
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize/address.code.length, which returns 0
354         // for contracts in construction, since the code is only stored at the end
355         // of the constructor execution.
356 
357         return account.code.length > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         (bool success, ) = recipient.call{value: amount}("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain `call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionCall(target, data, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value
434     ) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
440      * with `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(address(this).balance >= value, "Address: insufficient balance for call");
451         require(isContract(target), "Address: call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.call{value: value}(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
464         return functionStaticCall(target, data, "Address: low-level static call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.staticcall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
491         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         require(isContract(target), "Address: delegate call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.delegatecall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
513      * revert reason using the provided one.
514      *
515      * _Available since v4.3._
516      */
517     function verifyCallResult(
518         bool success,
519         bytes memory returndata,
520         string memory errorMessage
521     ) internal pure returns (bytes memory) {
522         if (success) {
523             return returndata;
524         } else {
525             // Look for revert reason and bubble it up if present
526             if (returndata.length > 0) {
527                 // The easiest way to bubble the revert reason is using memory via assembly
528 
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @title ERC721 token receiver interface
549  * @dev Interface for any contract that wants to support safeTransfers
550  * from ERC721 asset contracts.
551  */
552 interface IERC721Receiver {
553     /**
554      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
555      * by `operator` from `from`, this function is called.
556      *
557      * It must return its Solidity selector to confirm the token transfer.
558      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
559      *
560      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
561      */
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Interface of the ERC165 standard, as defined in the
579  * https://eips.ethereum.org/EIPS/eip-165[EIP].
580  *
581  * Implementers can declare support of contract interfaces, which can then be
582  * queried by others ({ERC165Checker}).
583  *
584  * For an implementation, see {ERC165}.
585  */
586 interface IERC165 {
587     /**
588      * @dev Returns true if this contract implements the interface defined by
589      * `interfaceId`. See the corresponding
590      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
591      * to learn more about how these ids are created.
592      *
593      * This function call must use less than 30 000 gas.
594      */
595     function supportsInterface(bytes4 interfaceId) external view returns (bool);
596 }
597 
598 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @dev Implementation of the {IERC165} interface.
608  *
609  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
610  * for the additional interface id that will be supported. For example:
611  *
612  * ```solidity
613  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
615  * }
616  * ```
617  *
618  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
619  */
620 abstract contract ERC165 is IERC165 {
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625         return interfaceId == type(IERC165).interfaceId;
626     }
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
630 
631 
632 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 /**
638  * @dev Required interface of an ERC721 compliant contract.
639  */
640 interface IERC721 is IERC165 {
641     /**
642      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
643      */
644     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
645 
646     /**
647      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
648      */
649     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
650 
651     /**
652      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
653      */
654     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
655 
656     /**
657      * @dev Returns the number of tokens in ``owner``'s account.
658      */
659     function balanceOf(address owner) external view returns (uint256 balance);
660 
661     /**
662      * @dev Returns the owner of the `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function ownerOf(uint256 tokenId) external view returns (address owner);
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must exist and be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
680      *
681      * Emits a {Transfer} event.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId,
687         bytes calldata data
688     ) external;
689 
690     /**
691      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
692      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
693      *
694      * Requirements:
695      *
696      * - `from` cannot be the zero address.
697      * - `to` cannot be the zero address.
698      * - `tokenId` token must exist and be owned by `from`.
699      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
700      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
701      *
702      * Emits a {Transfer} event.
703      */
704     function safeTransferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) external;
709 
710     /**
711      * @dev Transfers `tokenId` token from `from` to `to`.
712      *
713      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
714      *
715      * Requirements:
716      *
717      * - `from` cannot be the zero address.
718      * - `to` cannot be the zero address.
719      * - `tokenId` token must be owned by `from`.
720      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
721      *
722      * Emits a {Transfer} event.
723      */
724     function transferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) external;
729 
730     /**
731      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
732      * The approval is cleared when the token is transferred.
733      *
734      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
735      *
736      * Requirements:
737      *
738      * - The caller must own the token or be an approved operator.
739      * - `tokenId` must exist.
740      *
741      * Emits an {Approval} event.
742      */
743     function approve(address to, uint256 tokenId) external;
744 
745     /**
746      * @dev Approve or remove `operator` as an operator for the caller.
747      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
748      *
749      * Requirements:
750      *
751      * - The `operator` cannot be the caller.
752      *
753      * Emits an {ApprovalForAll} event.
754      */
755     function setApprovalForAll(address operator, bool _approved) external;
756 
757     /**
758      * @dev Returns the account approved for `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function getApproved(uint256 tokenId) external view returns (address operator);
765 
766     /**
767      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
768      *
769      * See {setApprovalForAll}
770      */
771     function isApprovedForAll(address owner, address operator) external view returns (bool);
772 }
773 
774 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
784  * @dev See https://eips.ethereum.org/EIPS/eip-721
785  */
786 interface IERC721Enumerable is IERC721 {
787     /**
788      * @dev Returns the total amount of tokens stored by the contract.
789      */
790     function totalSupply() external view returns (uint256);
791 
792     /**
793      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
794      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
795      */
796     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
797 
798     /**
799      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
800      * Use along with {totalSupply} to enumerate all tokens.
801      */
802     function tokenByIndex(uint256 index) external view returns (uint256);
803 }
804 
805 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
806 
807 
808 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 
813 /**
814  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
815  * @dev See https://eips.ethereum.org/EIPS/eip-721
816  */
817 interface IERC721Metadata is IERC721 {
818     /**
819      * @dev Returns the token collection name.
820      */
821     function name() external view returns (string memory);
822 
823     /**
824      * @dev Returns the token collection symbol.
825      */
826     function symbol() external view returns (string memory);
827 
828     /**
829      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
830      */
831     function tokenURI(uint256 tokenId) external view returns (string memory);
832 }
833 
834 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
835 
836 
837 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 
842 
843 
844 
845 
846 
847 
848 /**
849  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
850  * the Metadata extension, but not including the Enumerable extension, which is available separately as
851  * {ERC721Enumerable}.
852  */
853 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
854     using Address for address;
855     using Strings for uint256;
856 
857     // Token name
858     string private _name;
859 
860     // Token symbol
861     string private _symbol;
862 
863     // Mapping from token ID to owner address
864     mapping(uint256 => address) private _owners;
865 
866     // Mapping owner address to token count
867     mapping(address => uint256) private _balances;
868 
869     // Mapping from token ID to approved address
870     mapping(uint256 => address) private _tokenApprovals;
871 
872     // Mapping from owner to operator approvals
873     mapping(address => mapping(address => bool)) private _operatorApprovals;
874 
875     /**
876      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
877      */
878     constructor(string memory name_, string memory symbol_) {
879         _name = name_;
880         _symbol = symbol_;
881     }
882 
883     /**
884      * @dev See {IERC165-supportsInterface}.
885      */
886     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
887         return
888             interfaceId == type(IERC721).interfaceId ||
889             interfaceId == type(IERC721Metadata).interfaceId ||
890             super.supportsInterface(interfaceId);
891     }
892 
893     /**
894      * @dev See {IERC721-balanceOf}.
895      */
896     function balanceOf(address owner) public view virtual override returns (uint256) {
897         require(owner != address(0), "ERC721: balance query for the zero address");
898         return _balances[owner];
899     }
900 
901     /**
902      * @dev See {IERC721-ownerOf}.
903      */
904     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
905         address owner = _owners[tokenId];
906         require(owner != address(0), "ERC721: owner query for nonexistent token");
907         return owner;
908     }
909 
910     /**
911      * @dev See {IERC721Metadata-name}.
912      */
913     function name() public view virtual override returns (string memory) {
914         return _name;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-symbol}.
919      */
920     function symbol() public view virtual override returns (string memory) {
921         return _symbol;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-tokenURI}.
926      */
927     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
928         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
929 
930         string memory baseURI = _baseURI();
931         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
932     }
933 
934     /**
935      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
936      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
937      * by default, can be overridden in child contracts.
938      */
939     function _baseURI() internal view virtual returns (string memory) {
940         return "";
941     }
942 
943     /**
944      * @dev See {IERC721-approve}.
945      */
946     function approve(address to, uint256 tokenId) public virtual override {
947         address owner = ERC721.ownerOf(tokenId);
948         require(to != owner, "ERC721: approval to current owner");
949 
950         require(
951             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
952             "ERC721: approve caller is not owner nor approved for all"
953         );
954 
955         _approve(to, tokenId);
956     }
957 
958     /**
959      * @dev See {IERC721-getApproved}.
960      */
961     function getApproved(uint256 tokenId) public view virtual override returns (address) {
962         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
963 
964         return _tokenApprovals[tokenId];
965     }
966 
967     /**
968      * @dev See {IERC721-setApprovalForAll}.
969      */
970     function setApprovalForAll(address operator, bool approved) public virtual override {
971         _setApprovalForAll(_msgSender(), operator, approved);
972     }
973 
974     /**
975      * @dev See {IERC721-isApprovedForAll}.
976      */
977     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
978         return _operatorApprovals[owner][operator];
979     }
980 
981     /**
982      * @dev See {IERC721-transferFrom}.
983      */
984     function transferFrom(
985         address from,
986         address to,
987         uint256 tokenId
988     ) public virtual override {
989         //solhint-disable-next-line max-line-length
990         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
991 
992         _transfer(from, to, tokenId);
993     }
994 
995     /**
996      * @dev See {IERC721-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         safeTransferFrom(from, to, tokenId, "");
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) public virtual override {
1015         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1016         _safeTransfer(from, to, tokenId, _data);
1017     }
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1021      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1022      *
1023      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1024      *
1025      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1026      * implement alternative mechanisms to perform token transfer, such as signature-based.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must exist and be owned by `from`.
1033      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _safeTransfer(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) internal virtual {
1043         _transfer(from, to, tokenId);
1044         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      * and stop existing when they are burned (`_burn`).
1054      */
1055     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1056         return _owners[tokenId] != address(0);
1057     }
1058 
1059     /**
1060      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1067         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1068         address owner = ERC721.ownerOf(tokenId);
1069         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1070     }
1071 
1072     /**
1073      * @dev Safely mints `tokenId` and transfers it to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(address to, uint256 tokenId) internal virtual {
1083         _safeMint(to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1088      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) internal virtual {
1095         _mint(to, tokenId);
1096         require(
1097             _checkOnERC721Received(address(0), to, tokenId, _data),
1098             "ERC721: transfer to non ERC721Receiver implementer"
1099         );
1100     }
1101 
1102     /**
1103      * @dev Mints `tokenId` and transfers it to `to`.
1104      *
1105      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must not exist.
1110      * - `to` cannot be the zero address.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(address to, uint256 tokenId) internal virtual {
1115         require(to != address(0), "ERC721: mint to the zero address");
1116         require(!_exists(tokenId), "ERC721: token already minted");
1117 
1118         _beforeTokenTransfer(address(0), to, tokenId);
1119 
1120         _balances[to] += 1;
1121         _owners[tokenId] = to;
1122 
1123         emit Transfer(address(0), to, tokenId);
1124 
1125         _afterTokenTransfer(address(0), to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev Destroys `tokenId`.
1130      * The approval is cleared when the token is burned.
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must exist.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _burn(uint256 tokenId) internal virtual {
1139         address owner = ERC721.ownerOf(tokenId);
1140 
1141         _beforeTokenTransfer(owner, address(0), tokenId);
1142 
1143         // Clear approvals
1144         _approve(address(0), tokenId);
1145 
1146         _balances[owner] -= 1;
1147         delete _owners[tokenId];
1148 
1149         emit Transfer(owner, address(0), tokenId);
1150 
1151         _afterTokenTransfer(owner, address(0), tokenId);
1152     }
1153 
1154     /**
1155      * @dev Transfers `tokenId` from `from` to `to`.
1156      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {
1170         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1171         require(to != address(0), "ERC721: transfer to the zero address");
1172 
1173         _beforeTokenTransfer(from, to, tokenId);
1174 
1175         // Clear approvals from the previous owner
1176         _approve(address(0), tokenId);
1177 
1178         _balances[from] -= 1;
1179         _balances[to] += 1;
1180         _owners[tokenId] = to;
1181 
1182         emit Transfer(from, to, tokenId);
1183 
1184         _afterTokenTransfer(from, to, tokenId);
1185     }
1186 
1187     /**
1188      * @dev Approve `to` to operate on `tokenId`
1189      *
1190      * Emits a {Approval} event.
1191      */
1192     function _approve(address to, uint256 tokenId) internal virtual {
1193         _tokenApprovals[tokenId] = to;
1194         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev Approve `operator` to operate on all of `owner` tokens
1199      *
1200      * Emits a {ApprovalForAll} event.
1201      */
1202     function _setApprovalForAll(
1203         address owner,
1204         address operator,
1205         bool approved
1206     ) internal virtual {
1207         require(owner != operator, "ERC721: approve to caller");
1208         _operatorApprovals[owner][operator] = approved;
1209         emit ApprovalForAll(owner, operator, approved);
1210     }
1211 
1212     /**
1213      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1214      * The call is not executed if the target address is not a contract.
1215      *
1216      * @param from address representing the previous owner of the given token ID
1217      * @param to target address that will receive the tokens
1218      * @param tokenId uint256 ID of the token to be transferred
1219      * @param _data bytes optional data to send along with the call
1220      * @return bool whether the call correctly returned the expected magic value
1221      */
1222     function _checkOnERC721Received(
1223         address from,
1224         address to,
1225         uint256 tokenId,
1226         bytes memory _data
1227     ) private returns (bool) {
1228         if (to.isContract()) {
1229             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1230                 return retval == IERC721Receiver.onERC721Received.selector;
1231             } catch (bytes memory reason) {
1232                 if (reason.length == 0) {
1233                     revert("ERC721: transfer to non ERC721Receiver implementer");
1234                 } else {
1235                     assembly {
1236                         revert(add(32, reason), mload(reason))
1237                     }
1238                 }
1239             }
1240         } else {
1241             return true;
1242         }
1243     }
1244 
1245     /**
1246      * @dev Hook that is called before any token transfer. This includes minting
1247      * and burning.
1248      *
1249      * Calling conditions:
1250      *
1251      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1252      * transferred to `to`.
1253      * - When `from` is zero, `tokenId` will be minted for `to`.
1254      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1255      * - `from` and `to` are never both zero.
1256      *
1257      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1258      */
1259     function _beforeTokenTransfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) internal virtual {}
1264 
1265     /**
1266      * @dev Hook that is called after any transfer of tokens. This includes
1267      * minting and burning.
1268      *
1269      * Calling conditions:
1270      *
1271      * - when `from` and `to` are both non-zero.
1272      * - `from` and `to` are never both zero.
1273      *
1274      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1275      */
1276     function _afterTokenTransfer(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) internal virtual {}
1281 }
1282 
1283 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1284 
1285 
1286 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 
1291 
1292 /**
1293  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1294  * enumerability of all the token ids in the contract as well as all token ids owned by each
1295  * account.
1296  */
1297 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1298     // Mapping from owner to list of owned token IDs
1299     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1300 
1301     // Mapping from token ID to index of the owner tokens list
1302     mapping(uint256 => uint256) private _ownedTokensIndex;
1303 
1304     // Array with all token ids, used for enumeration
1305     uint256[] private _allTokens;
1306 
1307     // Mapping from token id to position in the allTokens array
1308     mapping(uint256 => uint256) private _allTokensIndex;
1309 
1310     /**
1311      * @dev See {IERC165-supportsInterface}.
1312      */
1313     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1314         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1315     }
1316 
1317     /**
1318      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1319      */
1320     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1321         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1322         return _ownedTokens[owner][index];
1323     }
1324 
1325     /**
1326      * @dev See {IERC721Enumerable-totalSupply}.
1327      */
1328     function totalSupply() public view virtual override returns (uint256) {
1329         return _allTokens.length;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Enumerable-tokenByIndex}.
1334      */
1335     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1336         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1337         return _allTokens[index];
1338     }
1339 
1340     /**
1341      * @dev Hook that is called before any token transfer. This includes minting
1342      * and burning.
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1350      * - `from` cannot be the zero address.
1351      * - `to` cannot be the zero address.
1352      *
1353      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1354      */
1355     function _beforeTokenTransfer(
1356         address from,
1357         address to,
1358         uint256 tokenId
1359     ) internal virtual override {
1360         super._beforeTokenTransfer(from, to, tokenId);
1361 
1362         if (from == address(0)) {
1363             _addTokenToAllTokensEnumeration(tokenId);
1364         } else if (from != to) {
1365             _removeTokenFromOwnerEnumeration(from, tokenId);
1366         }
1367         if (to == address(0)) {
1368             _removeTokenFromAllTokensEnumeration(tokenId);
1369         } else if (to != from) {
1370             _addTokenToOwnerEnumeration(to, tokenId);
1371         }
1372     }
1373 
1374     /**
1375      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1376      * @param to address representing the new owner of the given token ID
1377      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1378      */
1379     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1380         uint256 length = ERC721.balanceOf(to);
1381         _ownedTokens[to][length] = tokenId;
1382         _ownedTokensIndex[tokenId] = length;
1383     }
1384 
1385     /**
1386      * @dev Private function to add a token to this extension's token tracking data structures.
1387      * @param tokenId uint256 ID of the token to be added to the tokens list
1388      */
1389     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1390         _allTokensIndex[tokenId] = _allTokens.length;
1391         _allTokens.push(tokenId);
1392     }
1393 
1394     /**
1395      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1396      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1397      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1398      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1399      * @param from address representing the previous owner of the given token ID
1400      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1401      */
1402     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1403         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1404         // then delete the last slot (swap and pop).
1405 
1406         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1407         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1408 
1409         // When the token to delete is the last token, the swap operation is unnecessary
1410         if (tokenIndex != lastTokenIndex) {
1411             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1412 
1413             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1414             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1415         }
1416 
1417         // This also deletes the contents at the last position of the array
1418         delete _ownedTokensIndex[tokenId];
1419         delete _ownedTokens[from][lastTokenIndex];
1420     }
1421 
1422     /**
1423      * @dev Private function to remove a token from this extension's token tracking data structures.
1424      * This has O(1) time complexity, but alters the order of the _allTokens array.
1425      * @param tokenId uint256 ID of the token to be removed from the tokens list
1426      */
1427     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1428         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1429         // then delete the last slot (swap and pop).
1430 
1431         uint256 lastTokenIndex = _allTokens.length - 1;
1432         uint256 tokenIndex = _allTokensIndex[tokenId];
1433 
1434         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1435         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1436         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1437         uint256 lastTokenId = _allTokens[lastTokenIndex];
1438 
1439         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1440         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1441 
1442         // This also deletes the contents at the last position of the array
1443         delete _allTokensIndex[tokenId];
1444         _allTokens.pop();
1445     }
1446 }
1447 
1448 // File: archaickfelines.sol
1449 
1450 
1451 
1452 pragma solidity ^0.8.7;
1453 
1454 
1455 
1456 
1457 
1458 
1459 
1460 contract ArchaicFelines is ERC721Enumerable, Pausable, Ownable {
1461     using Counters for Counters.Counter;
1462     Counters.Counter private _tokenIds;
1463 
1464 
1465     // Maximum tokens will be 888 
1466     uint256 public _totalSupply = 888; 
1467     uint256 public _AFPrice = 25000000000000000; // 0.025 
1468     uint256 public _OGPrice = 35000000000000000; // 0.035
1469     uint256 public _publicPrice = 45000000000000000;  // 0.045
1470 
1471     // Mappings 
1472     mapping (address => bool) private _AFList; 
1473     mapping (address => uint256) public _AFMinted; 
1474     mapping (address => bool) private _OGList; 
1475     mapping (address => uint256) public _OGMinted; 
1476     mapping (address => uint256) public _publicMinted; 
1477 
1478     // Settings 
1479     bool public _AFMintActive = false; 
1480     bool public _OGMintActive = false; 
1481     bool public _publicMintActive = false; 
1482     uint256 public _AFMaxMint = 10; 
1483     uint256 public _OGMaxMint = 5; 
1484     uint256 public _publicMaxMint = 5; 
1485 
1486 
1487     // Base URI for metadata 
1488     string public _prefixURI;
1489 
1490     // Team Addresses 
1491     address public address1 = 0xd05D9B1d70756d8dc0cd7BA1b17c33B38600e8F2; 
1492     address public address2 = 0xC27d2db537514317CD033bFD185e2E206Cb158b0; 
1493     address public address3 = 0x358a8d8F663f53f2Bf7123bF63E597276cC2ddF2; 
1494     address public address4 = 0x253dB60bb8D6aF6B432865D8c755dBf7CA7BfbAf; 
1495     address public address5 = 0x9A05030125f7d94BEf05D07B752EdC3D1F29886a; 
1496     address public address6 = 0x197cD8E056B6CC93700F56FF38d5c13B613f57e8; 
1497     address public address7 = 0x67d47886f1A996176fdFF94B427a7a2e92C2Ecc9; 
1498 
1499 
1500     constructor() ERC721("Archaic Felines", "AF") {
1501     }
1502     
1503 
1504     function burnToken(uint256 tokenId) public virtual {
1505         require(_isApprovedOrOwner(msg.sender, tokenId)); 
1506         _burn(tokenId);
1507     }
1508 
1509     // URI Functions
1510     function _baseURI() internal view override returns (string memory) {
1511         return _prefixURI;
1512     }
1513 
1514     function setBaseURI(string memory _uri) public onlyOwner {
1515         _prefixURI = _uri;
1516     }
1517 
1518     function airDrop(address[] memory addrs) public onlyOwner {
1519         require(addrs.length > 0); 
1520         for (uint256 i = 0; i < addrs.length; i++) {
1521             _mintItem(addrs[i]); 
1522         }
1523     }
1524 
1525     function toggleAFActive() public onlyOwner {
1526         _AFMintActive = !_AFMintActive; 
1527     }
1528 
1529     function toggleOGActive() public onlyOwner {
1530         _OGMintActive = !_OGMintActive; 
1531     }
1532 
1533     function togglePublicActive() public onlyOwner {
1534         _publicMintActive = !_publicMintActive; 
1535     }
1536 
1537 
1538     function addToAF(address[] memory addrs) public onlyOwner {
1539         require(addrs.length > 0); 
1540         for (uint256 i = 0; i < addrs.length; i++) {
1541             _AFList[addrs[i]] = true;
1542         }
1543     }
1544 
1545     function removeFromAF(address[] memory addrs) public onlyOwner {
1546         require(addrs.length > 0); 
1547         for (uint256 i = 0; i < addrs.length; i++) {
1548             _AFList[addrs[i]] = false;
1549         }
1550     }
1551 
1552 
1553     function addToOG(address[] memory addrs) public onlyOwner {
1554         require(addrs.length > 0); 
1555         for (uint256 i = 0; i < addrs.length; i++) {
1556             _OGList[addrs[i]] = true;
1557         }
1558     }
1559 
1560     function removeFromOG(address[] memory addrs) public onlyOwner {
1561         require(addrs.length > 0); 
1562         for (uint256 i = 0; i < addrs.length; i++) {
1563             _OGList[addrs[i]] = false;
1564         }
1565     }
1566 
1567     function isAF(address addr) public view returns (bool) {
1568         require(addr != address(0)); 
1569         return _AFList[addr];
1570     }
1571 
1572     function isOG(address addr) public view returns (bool) {
1573         require(addr != address(0)); 
1574         return _OGList[addr];
1575     }
1576 
1577     function AFMint(uint256 amount) public payable {
1578         address sender = msg.sender; 
1579         require(amount > 0); 
1580         require(_AFMintActive); 
1581         require(isAF(sender));
1582         uint256 totalMinted = _tokenIds.current();
1583         require(totalMinted < _totalSupply);
1584         require(totalMinted + amount <= _totalSupply);
1585         require(_AFMinted[sender] + amount <= _AFMaxMint);
1586         require(msg.value >= amount * _AFPrice);
1587         for (uint256 i = 0; i < amount; i++) {
1588             _mintItem(sender);
1589         }
1590         _AFMinted[sender] = _AFMinted[sender] + amount; 
1591     }
1592 
1593     function OGMint(uint256 amount) public payable {
1594         address sender = msg.sender; 
1595         require(amount > 0); 
1596         require(_OGMintActive); 
1597         require(isOG(sender));
1598         uint256 totalMinted = _tokenIds.current();
1599         require(totalMinted < _totalSupply);
1600         require(totalMinted + amount <= _totalSupply);
1601         require(_OGMinted[sender] + amount <= _OGMaxMint);
1602         require(msg.value >= amount * _OGPrice);
1603         for (uint256 i = 0; i < amount; i++) {
1604             _mintItem(sender);
1605         }
1606         _OGMinted[sender] = _OGMinted[sender] + amount; 
1607     }
1608 
1609 
1610 
1611     function mint(uint256 amount) public payable {
1612         address sender = msg.sender; 
1613         require(amount > 0); 
1614         require(_publicMintActive); 
1615         uint256 totalMinted = _tokenIds.current();
1616         require(totalMinted < _totalSupply);
1617         require(totalMinted + amount <= _totalSupply); 
1618         require(_publicMinted[sender] + amount <= _publicMaxMint); 
1619         require(msg.value >= amount * _publicPrice);
1620         for (uint256 i = 0; i < amount; i++) {
1621             _mintItem(msg.sender); 
1622         }
1623         _publicMinted[sender] = _publicMinted[sender] + amount; 
1624     }
1625 
1626     //
1627     function _mintItem(address to) internal {
1628         _tokenIds.increment();
1629         uint256 id = _tokenIds.current();
1630         _safeMint(to, id);
1631     }
1632 
1633     // State management 
1634     function toggleTransferPause() public onlyOwner {
1635         paused() ? _unpause() : _pause();
1636     }
1637 
1638     function updateTotalSupply(uint256 newSupply) external onlyOwner {
1639         require(newSupply > 0); 
1640         _totalSupply = newSupply; 
1641     }
1642 
1643     function withdraw() external onlyOwner {
1644         require(address(this).balance > 0); 
1645         uint256 balance = address(this).balance; 
1646         payable(address1).transfer(balance*29/100); 
1647         payable(address2).transfer(balance*19/100); 
1648         payable(address3).transfer(balance*11/100); 
1649         payable(address4).transfer(balance*11/100); 
1650         payable(address5).transfer(balance*3/100); 
1651         payable(address6).transfer(balance*5/100); 
1652         payable(address7).transfer(balance*6/100); 
1653 
1654         // withdraw remaining to community address ~15%
1655         payable(msg.sender).transfer(address(this).balance);
1656     }
1657 }