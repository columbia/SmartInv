1 // File: @openzeppelin/contracts@4.4.0/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
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
47 // File: @openzeppelin/contracts@4.4.0/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
117 // File: @openzeppelin/contracts@4.4.0/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
144 // File: @openzeppelin/contracts@4.4.0/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
222 // File: @openzeppelin/contracts@4.4.0/security/Pausable.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
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
315 // File: @openzeppelin/contracts@4.4.0/utils/Address.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
319 
320 pragma solidity ^0.8.0;
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
342      */
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize, which returns 0 for contracts in
345         // construction, since the code is only stored at the end of the
346         // constructor execution.
347 
348         uint256 size;
349         assembly {
350             size := extcodesize(account)
351         }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         (bool success, ) = recipient.call{value: amount}("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         require(isContract(target), "Address: call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.call{value: value}(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
459         return functionStaticCall(target, data, "Address: low-level static call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.staticcall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.delegatecall(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
508      * revert reason using the provided one.
509      *
510      * _Available since v4.3._
511      */
512     function verifyCallResult(
513         bool success,
514         bytes memory returndata,
515         string memory errorMessage
516     ) internal pure returns (bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 // File: @openzeppelin/contracts@4.4.0/token/ERC721/IERC721Receiver.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @title ERC721 token receiver interface
544  * @dev Interface for any contract that wants to support safeTransfers
545  * from ERC721 asset contracts.
546  */
547 interface IERC721Receiver {
548     /**
549      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
550      * by `operator` from `from`, this function is called.
551      *
552      * It must return its Solidity selector to confirm the token transfer.
553      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
554      *
555      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
556      */
557     function onERC721Received(
558         address operator,
559         address from,
560         uint256 tokenId,
561         bytes calldata data
562     ) external returns (bytes4);
563 }
564 
565 // File: @openzeppelin/contracts@4.4.0/utils/introspection/IERC165.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Interface of the ERC165 standard, as defined in the
574  * https://eips.ethereum.org/EIPS/eip-165[EIP].
575  *
576  * Implementers can declare support of contract interfaces, which can then be
577  * queried by others ({ERC165Checker}).
578  *
579  * For an implementation, see {ERC165}.
580  */
581 interface IERC165 {
582     /**
583      * @dev Returns true if this contract implements the interface defined by
584      * `interfaceId`. See the corresponding
585      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
586      * to learn more about how these ids are created.
587      *
588      * This function call must use less than 30 000 gas.
589      */
590     function supportsInterface(bytes4 interfaceId) external view returns (bool);
591 }
592 
593 // File: @openzeppelin/contracts@4.4.0/utils/introspection/ERC165.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Implementation of the {IERC165} interface.
603  *
604  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
605  * for the additional interface id that will be supported. For example:
606  *
607  * ```solidity
608  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
609  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
610  * }
611  * ```
612  *
613  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
614  */
615 abstract contract ERC165 is IERC165 {
616     /**
617      * @dev See {IERC165-supportsInterface}.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620         return interfaceId == type(IERC165).interfaceId;
621     }
622 }
623 
624 // File: @openzeppelin/contracts@4.4.0/token/ERC721/IERC721.sol
625 
626 
627 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 
632 /**
633  * @dev Required interface of an ERC721 compliant contract.
634  */
635 interface IERC721 is IERC165 {
636     /**
637      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
638      */
639     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
640 
641     /**
642      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
643      */
644     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
645 
646     /**
647      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
648      */
649     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
650 
651     /**
652      * @dev Returns the number of tokens in ``owner``'s account.
653      */
654     function balanceOf(address owner) external view returns (uint256 balance);
655 
656     /**
657      * @dev Returns the owner of the `tokenId` token.
658      *
659      * Requirements:
660      *
661      * - `tokenId` must exist.
662      */
663     function ownerOf(uint256 tokenId) external view returns (address owner);
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
667      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) external;
684 
685     /**
686      * @dev Transfers `tokenId` token from `from` to `to`.
687      *
688      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must be owned by `from`.
695      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
696      *
697      * Emits a {Transfer} event.
698      */
699     function transferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) external;
704 
705     /**
706      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
707      * The approval is cleared when the token is transferred.
708      *
709      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
710      *
711      * Requirements:
712      *
713      * - The caller must own the token or be an approved operator.
714      * - `tokenId` must exist.
715      *
716      * Emits an {Approval} event.
717      */
718     function approve(address to, uint256 tokenId) external;
719 
720     /**
721      * @dev Returns the account approved for `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function getApproved(uint256 tokenId) external view returns (address operator);
728 
729     /**
730      * @dev Approve or remove `operator` as an operator for the caller.
731      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
732      *
733      * Requirements:
734      *
735      * - The `operator` cannot be the caller.
736      *
737      * Emits an {ApprovalForAll} event.
738      */
739     function setApprovalForAll(address operator, bool _approved) external;
740 
741     /**
742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
743      *
744      * See {setApprovalForAll}
745      */
746     function isApprovedForAll(address owner, address operator) external view returns (bool);
747 
748     /**
749      * @dev Safely transfers `tokenId` token from `from` to `to`.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
758      *
759      * Emits a {Transfer} event.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes calldata data
766     ) external;
767 }
768 
769 // File: @openzeppelin/contracts@4.4.0/token/ERC721/extensions/IERC721Enumerable.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 /**
778  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
779  * @dev See https://eips.ethereum.org/EIPS/eip-721
780  */
781 interface IERC721Enumerable is IERC721 {
782     /**
783      * @dev Returns the total amount of tokens stored by the contract.
784      */
785     function totalSupply() external view returns (uint256);
786 
787     /**
788      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
789      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
790      */
791     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
792 
793     /**
794      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
795      * Use along with {totalSupply} to enumerate all tokens.
796      */
797     function tokenByIndex(uint256 index) external view returns (uint256);
798 }
799 
800 // File: @openzeppelin/contracts@4.4.0/token/ERC721/extensions/IERC721Metadata.sol
801 
802 
803 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
804 
805 pragma solidity ^0.8.0;
806 
807 
808 /**
809  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
810  * @dev See https://eips.ethereum.org/EIPS/eip-721
811  */
812 interface IERC721Metadata is IERC721 {
813     /**
814      * @dev Returns the token collection name.
815      */
816     function name() external view returns (string memory);
817 
818     /**
819      * @dev Returns the token collection symbol.
820      */
821     function symbol() external view returns (string memory);
822 
823     /**
824      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
825      */
826     function tokenURI(uint256 tokenId) external view returns (string memory);
827 }
828 
829 // File: @openzeppelin/contracts@4.4.0/token/ERC721/ERC721.sol
830 
831 
832 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 
837 
838 
839 
840 
841 
842 
843 /**
844  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
845  * the Metadata extension, but not including the Enumerable extension, which is available separately as
846  * {ERC721Enumerable}.
847  */
848 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
849     using Address for address;
850     using Strings for uint256;
851 
852     // Token name
853     string private _name;
854 
855     // Token symbol
856     string private _symbol;
857 
858     // Mapping from token ID to owner address
859     mapping(uint256 => address) private _owners;
860 
861     // Mapping owner address to token count
862     mapping(address => uint256) private _balances;
863 
864     // Mapping from token ID to approved address
865     mapping(uint256 => address) private _tokenApprovals;
866 
867     // Mapping from owner to operator approvals
868     mapping(address => mapping(address => bool)) private _operatorApprovals;
869 
870     /**
871      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
872      */
873     constructor(string memory name_, string memory symbol_) {
874         _name = name_;
875         _symbol = symbol_;
876     }
877 
878     /**
879      * @dev See {IERC165-supportsInterface}.
880      */
881     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
882         return
883             interfaceId == type(IERC721).interfaceId ||
884             interfaceId == type(IERC721Metadata).interfaceId ||
885             super.supportsInterface(interfaceId);
886     }
887 
888     /**
889      * @dev See {IERC721-balanceOf}.
890      */
891     function balanceOf(address owner) public view virtual override returns (uint256) {
892         require(owner != address(0), "ERC721: balance query for the zero address");
893         return _balances[owner];
894     }
895 
896     /**
897      * @dev See {IERC721-ownerOf}.
898      */
899     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
900         address owner = _owners[tokenId];
901         require(owner != address(0), "ERC721: owner query for nonexistent token");
902         return owner;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-name}.
907      */
908     function name() public view virtual override returns (string memory) {
909         return _name;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-symbol}.
914      */
915     function symbol() public view virtual override returns (string memory) {
916         return _symbol;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-tokenURI}.
921      */
922     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
923         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
924 
925         string memory baseURI = _baseURI();
926         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
927     }
928 
929     /**
930      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
931      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
932      * by default, can be overriden in child contracts.
933      */
934     function _baseURI() internal view virtual returns (string memory) {
935         return "";
936     }
937 
938     /**
939      * @dev See {IERC721-approve}.
940      */
941     function approve(address to, uint256 tokenId) public virtual override {
942         address owner = ERC721.ownerOf(tokenId);
943         require(to != owner, "ERC721: approval to current owner");
944 
945         require(
946             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
947             "ERC721: approve caller is not owner nor approved for all"
948         );
949 
950         _approve(to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-getApproved}.
955      */
956     function getApproved(uint256 tokenId) public view virtual override returns (address) {
957         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
958 
959         return _tokenApprovals[tokenId];
960     }
961 
962     /**
963      * @dev See {IERC721-setApprovalForAll}.
964      */
965     function setApprovalForAll(address operator, bool approved) public virtual override {
966         _setApprovalForAll(_msgSender(), operator, approved);
967     }
968 
969     /**
970      * @dev See {IERC721-isApprovedForAll}.
971      */
972     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
973         return _operatorApprovals[owner][operator];
974     }
975 
976     /**
977      * @dev See {IERC721-transferFrom}.
978      */
979     function transferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public virtual override {
984         //solhint-disable-next-line max-line-length
985         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
986 
987         _transfer(from, to, tokenId);
988     }
989 
990     /**
991      * @dev See {IERC721-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         safeTransferFrom(from, to, tokenId, "");
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) public virtual override {
1010         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1011         _safeTransfer(from, to, tokenId, _data);
1012     }
1013 
1014     /**
1015      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1016      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1017      *
1018      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1019      *
1020      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1021      * implement alternative mechanisms to perform token transfer, such as signature-based.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must exist and be owned by `from`.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _safeTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) internal virtual {
1038         _transfer(from, to, tokenId);
1039         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1040     }
1041 
1042     /**
1043      * @dev Returns whether `tokenId` exists.
1044      *
1045      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1046      *
1047      * Tokens start existing when they are minted (`_mint`),
1048      * and stop existing when they are burned (`_burn`).
1049      */
1050     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1051         return _owners[tokenId] != address(0);
1052     }
1053 
1054     /**
1055      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1062         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1063         address owner = ERC721.ownerOf(tokenId);
1064         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1065     }
1066 
1067     /**
1068      * @dev Safely mints `tokenId` and transfers it to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - `tokenId` must not exist.
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(address to, uint256 tokenId) internal virtual {
1078         _safeMint(to, tokenId, "");
1079     }
1080 
1081     /**
1082      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1083      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1084      */
1085     function _safeMint(
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) internal virtual {
1090         _mint(to, tokenId);
1091         require(
1092             _checkOnERC721Received(address(0), to, tokenId, _data),
1093             "ERC721: transfer to non ERC721Receiver implementer"
1094         );
1095     }
1096 
1097     /**
1098      * @dev Mints `tokenId` and transfers it to `to`.
1099      *
1100      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must not exist.
1105      * - `to` cannot be the zero address.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _mint(address to, uint256 tokenId) internal virtual {
1110         require(to != address(0), "ERC721: mint to the zero address");
1111         require(!_exists(tokenId), "ERC721: token already minted");
1112 
1113         _beforeTokenTransfer(address(0), to, tokenId);
1114 
1115         _balances[to] += 1;
1116         _owners[tokenId] = to;
1117 
1118         emit Transfer(address(0), to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Destroys `tokenId`.
1123      * The approval is cleared when the token is burned.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must exist.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _burn(uint256 tokenId) internal virtual {
1132         address owner = ERC721.ownerOf(tokenId);
1133 
1134         _beforeTokenTransfer(owner, address(0), tokenId);
1135 
1136         // Clear approvals
1137         _approve(address(0), tokenId);
1138 
1139         _balances[owner] -= 1;
1140         delete _owners[tokenId];
1141 
1142         emit Transfer(owner, address(0), tokenId);
1143     }
1144 
1145     /**
1146      * @dev Transfers `tokenId` from `from` to `to`.
1147      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must be owned by `from`.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _transfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {
1161         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1162         require(to != address(0), "ERC721: transfer to the zero address");
1163 
1164         _beforeTokenTransfer(from, to, tokenId);
1165 
1166         // Clear approvals from the previous owner
1167         _approve(address(0), tokenId);
1168 
1169         _balances[from] -= 1;
1170         _balances[to] += 1;
1171         _owners[tokenId] = to;
1172 
1173         emit Transfer(from, to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Approve `to` to operate on `tokenId`
1178      *
1179      * Emits a {Approval} event.
1180      */
1181     function _approve(address to, uint256 tokenId) internal virtual {
1182         _tokenApprovals[tokenId] = to;
1183         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev Approve `operator` to operate on all of `owner` tokens
1188      *
1189      * Emits a {ApprovalForAll} event.
1190      */
1191     function _setApprovalForAll(
1192         address owner,
1193         address operator,
1194         bool approved
1195     ) internal virtual {
1196         require(owner != operator, "ERC721: approve to caller");
1197         _operatorApprovals[owner][operator] = approved;
1198         emit ApprovalForAll(owner, operator, approved);
1199     }
1200 
1201     /**
1202      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1203      * The call is not executed if the target address is not a contract.
1204      *
1205      * @param from address representing the previous owner of the given token ID
1206      * @param to target address that will receive the tokens
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param _data bytes optional data to send along with the call
1209      * @return bool whether the call correctly returned the expected magic value
1210      */
1211     function _checkOnERC721Received(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) private returns (bool) {
1217         if (to.isContract()) {
1218             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1219                 return retval == IERC721Receiver.onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert("ERC721: transfer to non ERC721Receiver implementer");
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before any token transfer. This includes minting
1236      * and burning.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 // File: @openzeppelin/contracts@4.4.0/token/ERC721/extensions/ERC721Enumerable.sol
1256 
1257 
1258 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1259 
1260 pragma solidity ^0.8.0;
1261 
1262 
1263 
1264 /**
1265  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1266  * enumerability of all the token ids in the contract as well as all token ids owned by each
1267  * account.
1268  */
1269 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1270     // Mapping from owner to list of owned token IDs
1271     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1272 
1273     // Mapping from token ID to index of the owner tokens list
1274     mapping(uint256 => uint256) private _ownedTokensIndex;
1275 
1276     // Array with all token ids, used for enumeration
1277     uint256[] private _allTokens;
1278 
1279     // Mapping from token id to position in the allTokens array
1280     mapping(uint256 => uint256) private _allTokensIndex;
1281 
1282     /**
1283      * @dev See {IERC165-supportsInterface}.
1284      */
1285     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1286         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1291      */
1292     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1293         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1294         return _ownedTokens[owner][index];
1295     }
1296 
1297     /**
1298      * @dev See {IERC721Enumerable-totalSupply}.
1299      */
1300     function totalSupply() public view virtual override returns (uint256) {
1301         return _allTokens.length;
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Enumerable-tokenByIndex}.
1306      */
1307     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1308         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1309         return _allTokens[index];
1310     }
1311 
1312     /**
1313      * @dev Hook that is called before any token transfer. This includes minting
1314      * and burning.
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1322      * - `from` cannot be the zero address.
1323      * - `to` cannot be the zero address.
1324      *
1325      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1326      */
1327     function _beforeTokenTransfer(
1328         address from,
1329         address to,
1330         uint256 tokenId
1331     ) internal virtual override {
1332         super._beforeTokenTransfer(from, to, tokenId);
1333 
1334         if (from == address(0)) {
1335             _addTokenToAllTokensEnumeration(tokenId);
1336         } else if (from != to) {
1337             _removeTokenFromOwnerEnumeration(from, tokenId);
1338         }
1339         if (to == address(0)) {
1340             _removeTokenFromAllTokensEnumeration(tokenId);
1341         } else if (to != from) {
1342             _addTokenToOwnerEnumeration(to, tokenId);
1343         }
1344     }
1345 
1346     /**
1347      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1348      * @param to address representing the new owner of the given token ID
1349      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1350      */
1351     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1352         uint256 length = ERC721.balanceOf(to);
1353         _ownedTokens[to][length] = tokenId;
1354         _ownedTokensIndex[tokenId] = length;
1355     }
1356 
1357     /**
1358      * @dev Private function to add a token to this extension's token tracking data structures.
1359      * @param tokenId uint256 ID of the token to be added to the tokens list
1360      */
1361     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1362         _allTokensIndex[tokenId] = _allTokens.length;
1363         _allTokens.push(tokenId);
1364     }
1365 
1366     /**
1367      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1368      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1369      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1370      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1371      * @param from address representing the previous owner of the given token ID
1372      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1373      */
1374     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1375         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1376         // then delete the last slot (swap and pop).
1377 
1378         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1379         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1380 
1381         // When the token to delete is the last token, the swap operation is unnecessary
1382         if (tokenIndex != lastTokenIndex) {
1383             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1384 
1385             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1386             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1387         }
1388 
1389         // This also deletes the contents at the last position of the array
1390         delete _ownedTokensIndex[tokenId];
1391         delete _ownedTokens[from][lastTokenIndex];
1392     }
1393 
1394     /**
1395      * @dev Private function to remove a token from this extension's token tracking data structures.
1396      * This has O(1) time complexity, but alters the order of the _allTokens array.
1397      * @param tokenId uint256 ID of the token to be removed from the tokens list
1398      */
1399     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1400         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1401         // then delete the last slot (swap and pop).
1402 
1403         uint256 lastTokenIndex = _allTokens.length - 1;
1404         uint256 tokenIndex = _allTokensIndex[tokenId];
1405 
1406         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1407         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1408         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1409         uint256 lastTokenId = _allTokens[lastTokenIndex];
1410 
1411         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1412         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1413 
1414         // This also deletes the contents at the last position of the array
1415         delete _allTokensIndex[tokenId];
1416         _allTokens.pop();
1417     }
1418 }
1419 
1420 // File: contracts/d_project.sol
1421 
1422 
1423 
1424 pragma solidity ^0.8.2;
1425 
1426 
1427 
1428 
1429 
1430 
1431 interface ICryptoDickbutts {
1432     function ownerOf(uint256 tokenId) external view returns (address owner);
1433     function tokenURI(uint256 tokenId) external view returns (string memory md);
1434 }
1435 
1436 //
1437 //  8===Dickenzas~~~
1438 //
1439 
1440 contract Dickenzas is ERC721, ERC721Enumerable, Pausable, Ownable {
1441     event Mint(address indexed _to, uint _tokenID, uint _hash);
1442 
1443     using Counters for Counters.Counter;
1444 
1445     Counters.Counter private counter_mints; // paid mints
1446     Counters.Counter private counter_cdbs; // free mints
1447     address addr_cdb = 0x42069ABFE407C60cf4ae4112bEDEaD391dBa1cdB; // great custom address
1448     ICryptoDickbutts cdb;
1449     uint public mintPrice = 0.069 ether; // editable with adjustPrice
1450     uint public constant MAX_CDB_MINTS = 250; // free mints for cdb holders
1451     uint public constant MAX_MINTS = 2000; // total mints possible
1452     mapping(uint => bool) cdb_mint; // track cdb ids used for free mints
1453     mapping(uint => uint) public tokenHash; // token to hash
1454     string private _baseURIextended = 'https://api.dickenzas.com/token?id=';
1455     mapping(uint=>string) private generationCode; // on chain javascript storage
1456     string public generationCodeHash = 'b88b53a1c9fa78a02d9626e42e1774f4c5dc8d3c12e94fe1a19c6c4566ad36b5'; // minified code hash
1457     string public p5jsversion = '1.4.0';
1458 
1459     function updateCodeHash(string memory _newhash) public onlyOwner{
1460         generationCodeHash = _newhash; // in case any bugs are found in p5 code.
1461     }
1462 
1463     function uploadCode(uint part, string memory code) public onlyOwner{
1464         generationCode[part] = code;
1465     }
1466 
1467     function getGenerationCode(uint part) public view returns (string memory){
1468         return generationCode[part];
1469     }
1470 
1471     function checkCDB(uint cdbID) public view returns (bool freeMint){
1472         cdb.ownerOf(cdbID); // check if token valid
1473         return !cdb_mint[cdbID];
1474     }
1475 
1476     function getCountFreeClaim() public view returns (uint m){
1477         return counter_cdbs.current();
1478     }
1479 
1480     function getCountSales() public view returns (uint m){
1481         return counter_mints.current();
1482     }
1483 
1484     function getNextTokenID() internal view returns (uint id){
1485         return counter_mints.current()+counter_cdbs.current();
1486     }
1487 
1488     function mintWithCDB(uint cdbID) public whenNotPaused{
1489         require(cdb.ownerOf(cdbID) == msg.sender,"Not owner of that CryptoDickbutt");
1490         require(checkCDB(cdbID),"Already used");
1491         require(counter_cdbs.current() < MAX_CDB_MINTS,"No free mints left");
1492         require(counter_mints.current()+counter_cdbs.current() < MAX_MINTS,"Minting complete");
1493 
1494         cdb_mint[cdbID] = true; // cdb id claimed
1495         uint nextTokenId = getNextTokenID();
1496         counter_cdbs.increment(); // track free mints
1497         uint hash = generateHash(nextTokenId);
1498         tokenHash[nextTokenId] = hash;
1499         _safeMint(msg.sender, nextTokenId);
1500         emit Mint(msg.sender, nextTokenId, hash);
1501     }
1502 
1503     function mint() public payable whenNotPaused{
1504         require((msg.value >= mintPrice) || (owner() == msg.sender),"Not enough");
1505         require(counter_mints.current()+counter_cdbs.current() < MAX_MINTS,"Minting complete");
1506         uint nextTokenId = getNextTokenID();
1507         counter_mints.increment();
1508         uint hash = generateHash(nextTokenId);
1509         tokenHash[nextTokenId] = hash;
1510         _safeMint(msg.sender, nextTokenId);
1511         emit Mint(msg.sender, nextTokenId, hash);
1512     }
1513 
1514     function reserveMints() public onlyOwner{
1515         // 10 mints for promo and giveaways
1516         require(counter_mints.current()+counter_cdbs.current() == 0 ,"Only callable before any mints occur");
1517         for (uint i = 0; i < 10; i++) {
1518             uint nextTokenId = getNextTokenID();
1519             counter_mints.increment();
1520             uint hash = generateHash(nextTokenId);
1521             tokenHash[nextTokenId] = hash;
1522             _safeMint(msg.sender, nextTokenId);
1523             emit Mint(msg.sender, nextTokenId, hash);
1524         }
1525     }
1526 
1527     function withdraw() public onlyOwner{
1528         payable(msg.sender).transfer(address(this).balance);
1529     }
1530 
1531     function adjustPrice(uint new_price) public onlyOwner{
1532         mintPrice = new_price;
1533     }
1534 
1535     function generateHash(uint inp) internal view returns (uint randomNumber){
1536         return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender, inp))) % 1e20;
1537     }
1538 
1539     constructor() ERC721("Dickenzas", "DKNZA") {
1540         cdb = ICryptoDickbutts(addr_cdb);
1541         _pause();
1542     }
1543 
1544     function setBaseURI(string memory baseURI_) external onlyOwner() {
1545         _baseURIextended = baseURI_;
1546     }
1547 
1548     function _baseURI() internal view virtual override returns (string memory) {
1549         return _baseURIextended;
1550     }
1551     
1552 
1553     function pause() public onlyOwner {
1554         _pause();
1555     }
1556 
1557     function unpause() public onlyOwner {
1558         _unpause();
1559     }
1560 
1561     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1562         internal
1563         override(ERC721, ERC721Enumerable)
1564     {
1565         super._beforeTokenTransfer(from, to, tokenId);
1566     }
1567 
1568     // The following functions are overrides required by Solidity.
1569 
1570     function supportsInterface(bytes4 interfaceId)
1571         public
1572         view
1573         override(ERC721, ERC721Enumerable)
1574         returns (bool)
1575     {
1576         return super.supportsInterface(interfaceId);
1577     }
1578 }