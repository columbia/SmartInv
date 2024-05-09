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
47 // File: @openzeppelin/contracts/utils/Context.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Provides information about the current execution context, including the
56  * sender of the transaction and its data. While these are generally available
57  * via msg.sender and msg.data, they should not be accessed in such a direct
58  * manner, since when dealing with meta-transactions the account sending and
59  * paying for execution may not be the actual sender (as far as an application
60  * is concerned).
61  *
62  * This contract is only required for intermediate, library-like contracts.
63  */
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes calldata) {
70         return msg.data;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/security/Pausable.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 
82 /**
83  * @dev Contract module which allows children to implement an emergency stop
84  * mechanism that can be triggered by an authorized account.
85  *
86  * This module is used through inheritance. It will make available the
87  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
88  * the functions of your contract. Note that they will not be pausable by
89  * simply including this module, only once the modifiers are put in place.
90  */
91 abstract contract Pausable is Context {
92     /**
93      * @dev Emitted when the pause is triggered by `account`.
94      */
95     event Paused(address account);
96 
97     /**
98      * @dev Emitted when the pause is lifted by `account`.
99      */
100     event Unpaused(address account);
101 
102     bool private _paused;
103 
104     /**
105      * @dev Initializes the contract in unpaused state.
106      */
107     constructor() {
108         _paused = false;
109     }
110 
111     /**
112      * @dev Returns true if the contract is paused, and false otherwise.
113      */
114     function paused() public view virtual returns (bool) {
115         return _paused;
116     }
117 
118     /**
119      * @dev Modifier to make a function callable only when the contract is not paused.
120      *
121      * Requirements:
122      *
123      * - The contract must not be paused.
124      */
125     modifier whenNotPaused() {
126         require(!paused(), "Pausable: paused");
127         _;
128     }
129 
130     /**
131      * @dev Modifier to make a function callable only when the contract is paused.
132      *
133      * Requirements:
134      *
135      * - The contract must be paused.
136      */
137     modifier whenPaused() {
138         require(paused(), "Pausable: not paused");
139         _;
140     }
141 
142     /**
143      * @dev Triggers stopped state.
144      *
145      * Requirements:
146      *
147      * - The contract must not be paused.
148      */
149     function _pause() internal virtual whenNotPaused {
150         _paused = true;
151         emit Paused(_msgSender());
152     }
153 
154     /**
155      * @dev Returns to normal state.
156      *
157      * Requirements:
158      *
159      * - The contract must be paused.
160      */
161     function _unpause() internal virtual whenPaused {
162         _paused = false;
163         emit Unpaused(_msgSender());
164     }
165 }
166 
167 // File: @openzeppelin/contracts/access/Ownable.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 
175 /**
176  * @dev Contract module which provides a basic access control mechanism, where
177  * there is an account (an owner) that can be granted exclusive access to
178  * specific functions.
179  *
180  * By default, the owner account will be the one that deploys the contract. This
181  * can later be changed with {transferOwnership}.
182  *
183  * This module is used through inheritance. It will make available the modifier
184  * `onlyOwner`, which can be applied to your functions to restrict their use to
185  * the owner.
186  */
187 abstract contract Ownable is Context {
188     address private _owner;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     /**
193      * @dev Initializes the contract setting the deployer as the initial owner.
194      */
195     constructor() {
196         _transferOwnership(_msgSender());
197     }
198 
199     /**
200      * @dev Returns the address of the current owner.
201      */
202     function owner() public view virtual returns (address) {
203         return _owner;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
211         _;
212     }
213 
214     /**
215      * @dev Leaves the contract without owner. It will not be possible to call
216      * `onlyOwner` functions anymore. Can only be called by the current owner.
217      *
218      * NOTE: Renouncing ownership will leave the contract without an owner,
219      * thereby removing any functionality that is only available to the owner.
220      */
221     function renounceOwnership() public virtual onlyOwner {
222         _transferOwnership(address(0));
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Internal function without access restriction.
237      */
238     function _transferOwnership(address newOwner) internal virtual {
239         address oldOwner = _owner;
240         _owner = newOwner;
241         emit OwnershipTransferred(oldOwner, newOwner);
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
249 
250 pragma solidity ^0.8.1;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      *
273      * [IMPORTANT]
274      * ====
275      * You shouldn't rely on `isContract` to protect against flash loan attacks!
276      *
277      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
278      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
279      * constructor.
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies on extcodesize/address.code.length, which returns 0
284         // for contracts in construction, since the code is only stored at the end
285         // of the constructor execution.
286 
287         return account.code.length > 0;
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         (bool success, ) = recipient.call{value: amount}("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain `call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         require(isContract(target), "Address: call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.call{value: value}(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a static call.
390      *
391      * _Available since v3.3._
392      */
393     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
394         return functionStaticCall(target, data, "Address: low-level static call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.staticcall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but performing a delegate call.
417      *
418      * _Available since v3.4._
419      */
420     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
421         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(
431         address target,
432         bytes memory data,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(isContract(target), "Address: delegate call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.delegatecall(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
443      * revert reason using the provided one.
444      *
445      * _Available since v4.3._
446      */
447     function verifyCallResult(
448         bool success,
449         bytes memory returndata,
450         string memory errorMessage
451     ) internal pure returns (bytes memory) {
452         if (success) {
453             return returndata;
454         } else {
455             // Look for revert reason and bubble it up if present
456             if (returndata.length > 0) {
457                 // The easiest way to bubble the revert reason is using memory via assembly
458 
459                 assembly {
460                     let returndata_size := mload(returndata)
461                     revert(add(32, returndata), returndata_size)
462                 }
463             } else {
464                 revert(errorMessage);
465             }
466         }
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @title ERC721 token receiver interface
479  * @dev Interface for any contract that wants to support safeTransfers
480  * from ERC721 asset contracts.
481  */
482 interface IERC721Receiver {
483     /**
484      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
485      * by `operator` from `from`, this function is called.
486      *
487      * It must return its Solidity selector to confirm the token transfer.
488      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
489      *
490      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
491      */
492     function onERC721Received(
493         address operator,
494         address from,
495         uint256 tokenId,
496         bytes calldata data
497     ) external returns (bytes4);
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Interface of the ERC165 standard, as defined in the
509  * https://eips.ethereum.org/EIPS/eip-165[EIP].
510  *
511  * Implementers can declare support of contract interfaces, which can then be
512  * queried by others ({ERC165Checker}).
513  *
514  * For an implementation, see {ERC165}.
515  */
516 interface IERC165 {
517     /**
518      * @dev Returns true if this contract implements the interface defined by
519      * `interfaceId`. See the corresponding
520      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
521      * to learn more about how these ids are created.
522      *
523      * This function call must use less than 30 000 gas.
524      */
525     function supportsInterface(bytes4 interfaceId) external view returns (bool);
526 }
527 
528 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Implementation of the {IERC165} interface.
538  *
539  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
540  * for the additional interface id that will be supported. For example:
541  *
542  * ```solidity
543  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
545  * }
546  * ```
547  *
548  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
549  */
550 abstract contract ERC165 is IERC165 {
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         return interfaceId == type(IERC165).interfaceId;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Required interface of an ERC721 compliant contract.
569  */
570 interface IERC721 is IERC165 {
571     /**
572      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
573      */
574     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
578      */
579     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
583      */
584     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
585 
586     /**
587      * @dev Returns the number of tokens in ``owner``'s account.
588      */
589     function balanceOf(address owner) external view returns (uint256 balance);
590 
591     /**
592      * @dev Returns the owner of the `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function ownerOf(uint256 tokenId) external view returns (address owner);
599 
600     /**
601      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Transfers `tokenId` token from `from` to `to`.
622      *
623      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
642      * The approval is cleared when the token is transferred.
643      *
644      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
645      *
646      * Requirements:
647      *
648      * - The caller must own the token or be an approved operator.
649      * - `tokenId` must exist.
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address to, uint256 tokenId) external;
654 
655     /**
656      * @dev Returns the account approved for `tokenId` token.
657      *
658      * Requirements:
659      *
660      * - `tokenId` must exist.
661      */
662     function getApproved(uint256 tokenId) external view returns (address operator);
663 
664     /**
665      * @dev Approve or remove `operator` as an operator for the caller.
666      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
667      *
668      * Requirements:
669      *
670      * - The `operator` cannot be the caller.
671      *
672      * Emits an {ApprovalForAll} event.
673      */
674     function setApprovalForAll(address operator, bool _approved) external;
675 
676     /**
677      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
678      *
679      * See {setApprovalForAll}
680      */
681     function isApprovedForAll(address owner, address operator) external view returns (bool);
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes calldata data
701     ) external;
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 /**
713  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
714  * @dev See https://eips.ethereum.org/EIPS/eip-721
715  */
716 interface IERC721Enumerable is IERC721 {
717     /**
718      * @dev Returns the total amount of tokens stored by the contract.
719      */
720     function totalSupply() external view returns (uint256);
721 
722     /**
723      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
724      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
725      */
726     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
727 
728     /**
729      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
730      * Use along with {totalSupply} to enumerate all tokens.
731      */
732     function tokenByIndex(uint256 index) external view returns (uint256);
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
745  * @dev See https://eips.ethereum.org/EIPS/eip-721
746  */
747 interface IERC721Metadata is IERC721 {
748     /**
749      * @dev Returns the token collection name.
750      */
751     function name() external view returns (string memory);
752 
753     /**
754      * @dev Returns the token collection symbol.
755      */
756     function symbol() external view returns (string memory);
757 
758     /**
759      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
760      */
761     function tokenURI(uint256 tokenId) external view returns (string memory);
762 }
763 
764 // File: @openzeppelin/contracts/utils/Strings.sol
765 
766 
767 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @dev String operations.
773  */
774 library Strings {
775     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
776 
777     /**
778      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
779      */
780     function toString(uint256 value) internal pure returns (string memory) {
781         // Inspired by OraclizeAPI's implementation - MIT licence
782         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
783 
784         if (value == 0) {
785             return "0";
786         }
787         uint256 temp = value;
788         uint256 digits;
789         while (temp != 0) {
790             digits++;
791             temp /= 10;
792         }
793         bytes memory buffer = new bytes(digits);
794         while (value != 0) {
795             digits -= 1;
796             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
797             value /= 10;
798         }
799         return string(buffer);
800     }
801 
802     /**
803      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
804      */
805     function toHexString(uint256 value) internal pure returns (string memory) {
806         if (value == 0) {
807             return "0x00";
808         }
809         uint256 temp = value;
810         uint256 length = 0;
811         while (temp != 0) {
812             length++;
813             temp >>= 8;
814         }
815         return toHexString(value, length);
816     }
817 
818     /**
819      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
820      */
821     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
822         bytes memory buffer = new bytes(2 * length + 2);
823         buffer[0] = "0";
824         buffer[1] = "x";
825         for (uint256 i = 2 * length + 1; i > 1; --i) {
826             buffer[i] = _HEX_SYMBOLS[value & 0xf];
827             value >>= 4;
828         }
829         require(value == 0, "Strings: hex length insufficient");
830         return string(buffer);
831     }
832 }
833 
834 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
835 
836 
837 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
937      * by default, can be overriden in child contracts.
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
1069         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
1448 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1449 
1450 
1451 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1452 
1453 pragma solidity ^0.8.0;
1454 
1455 
1456 /**
1457  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1458  *
1459  * These functions can be used to verify that a message was signed by the holder
1460  * of the private keys of a given address.
1461  */
1462 library ECDSA {
1463     enum RecoverError {
1464         NoError,
1465         InvalidSignature,
1466         InvalidSignatureLength,
1467         InvalidSignatureS,
1468         InvalidSignatureV
1469     }
1470 
1471     function _throwError(RecoverError error) private pure {
1472         if (error == RecoverError.NoError) {
1473             return; // no error: do nothing
1474         } else if (error == RecoverError.InvalidSignature) {
1475             revert("ECDSA: invalid signature");
1476         } else if (error == RecoverError.InvalidSignatureLength) {
1477             revert("ECDSA: invalid signature length");
1478         } else if (error == RecoverError.InvalidSignatureS) {
1479             revert("ECDSA: invalid signature 's' value");
1480         } else if (error == RecoverError.InvalidSignatureV) {
1481             revert("ECDSA: invalid signature 'v' value");
1482         }
1483     }
1484 
1485     /**
1486      * @dev Returns the address that signed a hashed message (`hash`) with
1487      * `signature` or error string. This address can then be used for verification purposes.
1488      *
1489      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1490      * this function rejects them by requiring the `s` value to be in the lower
1491      * half order, and the `v` value to be either 27 or 28.
1492      *
1493      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1494      * verification to be secure: it is possible to craft signatures that
1495      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1496      * this is by receiving a hash of the original message (which may otherwise
1497      * be too long), and then calling {toEthSignedMessageHash} on it.
1498      *
1499      * Documentation for signature generation:
1500      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1501      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1502      *
1503      * _Available since v4.3._
1504      */
1505     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1506         // Check the signature length
1507         // - case 65: r,s,v signature (standard)
1508         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1509         if (signature.length == 65) {
1510             bytes32 r;
1511             bytes32 s;
1512             uint8 v;
1513             // ecrecover takes the signature parameters, and the only way to get them
1514             // currently is to use assembly.
1515             assembly {
1516                 r := mload(add(signature, 0x20))
1517                 s := mload(add(signature, 0x40))
1518                 v := byte(0, mload(add(signature, 0x60)))
1519             }
1520             return tryRecover(hash, v, r, s);
1521         } else if (signature.length == 64) {
1522             bytes32 r;
1523             bytes32 vs;
1524             // ecrecover takes the signature parameters, and the only way to get them
1525             // currently is to use assembly.
1526             assembly {
1527                 r := mload(add(signature, 0x20))
1528                 vs := mload(add(signature, 0x40))
1529             }
1530             return tryRecover(hash, r, vs);
1531         } else {
1532             return (address(0), RecoverError.InvalidSignatureLength);
1533         }
1534     }
1535 
1536     /**
1537      * @dev Returns the address that signed a hashed message (`hash`) with
1538      * `signature`. This address can then be used for verification purposes.
1539      *
1540      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1541      * this function rejects them by requiring the `s` value to be in the lower
1542      * half order, and the `v` value to be either 27 or 28.
1543      *
1544      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1545      * verification to be secure: it is possible to craft signatures that
1546      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1547      * this is by receiving a hash of the original message (which may otherwise
1548      * be too long), and then calling {toEthSignedMessageHash} on it.
1549      */
1550     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1551         (address recovered, RecoverError error) = tryRecover(hash, signature);
1552         _throwError(error);
1553         return recovered;
1554     }
1555 
1556     /**
1557      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1558      *
1559      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1560      *
1561      * _Available since v4.3._
1562      */
1563     function tryRecover(
1564         bytes32 hash,
1565         bytes32 r,
1566         bytes32 vs
1567     ) internal pure returns (address, RecoverError) {
1568         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1569         uint8 v = uint8((uint256(vs) >> 255) + 27);
1570         return tryRecover(hash, v, r, s);
1571     }
1572 
1573     /**
1574      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1575      *
1576      * _Available since v4.2._
1577      */
1578     function recover(
1579         bytes32 hash,
1580         bytes32 r,
1581         bytes32 vs
1582     ) internal pure returns (address) {
1583         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1584         _throwError(error);
1585         return recovered;
1586     }
1587 
1588     /**
1589      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1590      * `r` and `s` signature fields separately.
1591      *
1592      * _Available since v4.3._
1593      */
1594     function tryRecover(
1595         bytes32 hash,
1596         uint8 v,
1597         bytes32 r,
1598         bytes32 s
1599     ) internal pure returns (address, RecoverError) {
1600         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1601         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1602         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1603         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1604         //
1605         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1606         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1607         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1608         // these malleable signatures as well.
1609         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1610             return (address(0), RecoverError.InvalidSignatureS);
1611         }
1612         if (v != 27 && v != 28) {
1613             return (address(0), RecoverError.InvalidSignatureV);
1614         }
1615 
1616         // If the signature is valid (and not malleable), return the signer address
1617         address signer = ecrecover(hash, v, r, s);
1618         if (signer == address(0)) {
1619             return (address(0), RecoverError.InvalidSignature);
1620         }
1621 
1622         return (signer, RecoverError.NoError);
1623     }
1624 
1625     /**
1626      * @dev Overload of {ECDSA-recover} that receives the `v`,
1627      * `r` and `s` signature fields separately.
1628      */
1629     function recover(
1630         bytes32 hash,
1631         uint8 v,
1632         bytes32 r,
1633         bytes32 s
1634     ) internal pure returns (address) {
1635         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1636         _throwError(error);
1637         return recovered;
1638     }
1639 
1640     /**
1641      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1642      * produces hash corresponding to the one signed with the
1643      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1644      * JSON-RPC method as part of EIP-191.
1645      *
1646      * See {recover}.
1647      */
1648     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1649         // 32 is the length in bytes of hash,
1650         // enforced by the type signature above
1651         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1652     }
1653 
1654     /**
1655      * @dev Returns an Ethereum Signed Message, created from `s`. This
1656      * produces hash corresponding to the one signed with the
1657      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1658      * JSON-RPC method as part of EIP-191.
1659      *
1660      * See {recover}.
1661      */
1662     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1663         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1664     }
1665 
1666     /**
1667      * @dev Returns an Ethereum Signed Typed Data, created from a
1668      * `domainSeparator` and a `structHash`. This produces hash corresponding
1669      * to the one signed with the
1670      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1671      * JSON-RPC method as part of EIP-712.
1672      *
1673      * See {recover}.
1674      */
1675     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1676         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1677     }
1678 }
1679 
1680 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1681 
1682 
1683 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1684 
1685 pragma solidity ^0.8.0;
1686 
1687 
1688 /**
1689  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1690  *
1691  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1692  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1693  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1694  *
1695  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1696  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1697  * ({_hashTypedDataV4}).
1698  *
1699  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1700  * the chain id to protect against replay attacks on an eventual fork of the chain.
1701  *
1702  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1703  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1704  *
1705  * _Available since v3.4._
1706  */
1707 abstract contract EIP712 {
1708     /* solhint-disable var-name-mixedcase */
1709     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1710     // invalidate the cached domain separator if the chain id changes.
1711     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1712     uint256 private immutable _CACHED_CHAIN_ID;
1713     address private immutable _CACHED_THIS;
1714 
1715     bytes32 private immutable _HASHED_NAME;
1716     bytes32 private immutable _HASHED_VERSION;
1717     bytes32 private immutable _TYPE_HASH;
1718 
1719     /* solhint-enable var-name-mixedcase */
1720 
1721     /**
1722      * @dev Initializes the domain separator and parameter caches.
1723      *
1724      * The meaning of `name` and `version` is specified in
1725      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1726      *
1727      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1728      * - `version`: the current major version of the signing domain.
1729      *
1730      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1731      * contract upgrade].
1732      */
1733     constructor(string memory name, string memory version) {
1734         bytes32 hashedName = keccak256(bytes(name));
1735         bytes32 hashedVersion = keccak256(bytes(version));
1736         bytes32 typeHash = keccak256(
1737             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1738         );
1739         _HASHED_NAME = hashedName;
1740         _HASHED_VERSION = hashedVersion;
1741         _CACHED_CHAIN_ID = block.chainid;
1742         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1743         _CACHED_THIS = address(this);
1744         _TYPE_HASH = typeHash;
1745     }
1746 
1747     /**
1748      * @dev Returns the domain separator for the current chain.
1749      */
1750     function _domainSeparatorV4() internal view returns (bytes32) {
1751         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1752             return _CACHED_DOMAIN_SEPARATOR;
1753         } else {
1754             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1755         }
1756     }
1757 
1758     function _buildDomainSeparator(
1759         bytes32 typeHash,
1760         bytes32 nameHash,
1761         bytes32 versionHash
1762     ) private view returns (bytes32) {
1763         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1764     }
1765 
1766     /**
1767      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1768      * function returns the hash of the fully encoded EIP712 message for this domain.
1769      *
1770      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1771      *
1772      * ```solidity
1773      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1774      *     keccak256("Mail(address to,string contents)"),
1775      *     mailTo,
1776      *     keccak256(bytes(mailContents))
1777      * )));
1778      * address signer = ECDSA.recover(digest, signature);
1779      * ```
1780      */
1781     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1782         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1783     }
1784 }
1785 
1786 // File: contracts/WhitelistVerification.sol
1787 
1788 
1789 pragma solidity ^0.8.0;
1790 
1791 
1792 contract WhitelistVerification is EIP712 {
1793     string private constant SIGNING_DOMAIN = "MECHA_TIGER_VERIFY";
1794     string private constant SIGNATURE_VERSION = "1";
1795 
1796     struct Whitelist {
1797         address userAddress;
1798         bytes signature;
1799     }
1800 
1801     constructor() EIP712("MECHA_TIGER_VERIFY", "1") {}
1802 
1803     function getSigner(Whitelist memory whitelist)
1804         internal
1805         view
1806         returns (address)
1807     {
1808         return _verify(whitelist);
1809     }
1810 
1811     function _hash(Whitelist memory whitelist) internal view returns (bytes32) {
1812         return
1813             _hashTypedDataV4(
1814                 keccak256(
1815                     abi.encode(
1816                         keccak256("Whitelist(address userAddress)"),
1817                         whitelist.userAddress
1818                     )
1819                 )
1820             );
1821     }
1822 
1823     function _verify(Whitelist memory whitelist)
1824         //  TODO uncommented code
1825         internal
1826         // public 
1827         view
1828         returns (address)
1829     {
1830         bytes32 digest = _hash(whitelist);
1831         return ECDSA.recover(digest, whitelist.signature);
1832     }
1833 }
1834 
1835 // File: contracts/MechaTiger.sol
1836 
1837 
1838 pragma solidity ^0.8.0;
1839 
1840 
1841 
1842 
1843 
1844 
1845 
1846 /**
1847  * @title MechaTiger
1848  * MechaTiger - a contract for my non-fungible creatures.
1849  */
1850 /* solhint-enable var-name-mixedcase */
1851 contract MechaTiger is ERC721Enumerable, Ownable, WhitelistVerification, Pausable {
1852     using Counters for Counters.Counter;
1853     using Strings for uint;
1854     using ECDSA for bytes32;
1855 
1856     // Counter for NFT count
1857     Counters.Counter private _tokenIdCounter;
1858 
1859     // NFT metadata basetoken URI
1860     string public baseTokenURI;
1861     string private baseExtension = ".json";
1862     // string public notRevealedUri;
1863     string private nonRevealBaseURI;
1864     mapping(address => uint256) public preSaleListAddress;
1865     mapping(address => uint256) public publicSaleListAddress;
1866 
1867     // Sale Price
1868     uint256 private PRESALE_PRICE_PER_TOKEN = 0.069 ether;
1869     uint256 private PUBLIC_PRICE_COST_PER_TOKEN = 0.069 ether;
1870 
1871     // Flags for whitelist,mainsale or pausing the contract
1872     bool private preSaleLive;
1873     bool private publicSaleLive;
1874     // Make it private for now!
1875     bool public revealed = false;
1876 
1877     address private _signerAddress;
1878 
1879     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1880         baseTokenURI = "";
1881     }
1882 
1883     // Set Whitelist
1884     function setPreSaleLive(bool _preSaleLive) public onlyOwner {
1885         preSaleLive = _preSaleLive;
1886     }
1887     
1888     function getPreSaleLive() public view onlyOwner returns(bool _preSaleLive) {
1889         return preSaleLive;
1890     }
1891 
1892     // Set publicsale
1893     function setPublicSaleLive(bool _publicSaleLive) public onlyOwner {
1894         publicSaleLive = _publicSaleLive;
1895     }
1896 
1897     function tokenURI(uint256 tokenId)
1898     public
1899     view
1900     virtual
1901     override
1902         returns (string memory)
1903     {
1904         require(
1905         _exists(tokenId),
1906         "ERC721Metadata: URI query for nonexistent token"
1907         );
1908         
1909         if(revealed == false) {
1910             return nonRevealBaseURI;
1911         }
1912 
1913         string memory currentBaseURI = _baseURI();
1914         return bytes(currentBaseURI).length > 0
1915             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1916             : "";
1917     }
1918 
1919 
1920     /**
1921      * @dev _baseURI
1922      * */
1923     function _baseURI() internal view virtual override returns (string memory) {
1924         return baseTokenURI;
1925     }
1926 
1927     function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
1928         baseTokenURI = _baseTokenURI;
1929     }
1930 
1931     function setNonRevealBaseURI(string memory _nonRevealBaseURI) public onlyOwner {
1932         nonRevealBaseURI = _nonRevealBaseURI;
1933     }
1934     function getNonRevealBaseURI() public view onlyOwner returns(string memory) {
1935         return nonRevealBaseURI;
1936     }
1937 
1938     function setBaseExtension(string memory _baseExtension) public onlyOwner {
1939         baseExtension = _baseExtension;
1940     }
1941 
1942     function getBaseExtension() public view onlyOwner returns(string memory) {
1943         return baseExtension;
1944     }
1945 
1946     function preSaleMint(Whitelist memory walletAddress, uint256 tokenQuantity)
1947         external
1948         payable
1949         whenNotPaused
1950     {
1951         require(preSaleLive, "SALE_CLOSED");
1952         require(getWhitelist(walletAddress), "DIRECT_MINT_DISALLOWED");
1953         // require(walletAddress.userAddress == msg.sender, "INVALID_WHITELIST_USER");
1954         // Validating funds in user's walletAdrress
1955         require(tokenQuantity * PRESALE_PRICE_PER_TOKEN <= msg.value,"INSUFFICIENT_FUNDS");
1956         // Validating token count exceeding total presale count
1957         require(totalSupply() + tokenQuantity <= 222, "WHITELIST_SALE_LIMIT_EXCEED");
1958         // Validating user's walletAddress token count exceeding
1959         require(preSaleListAddress[msg.sender] + tokenQuantity <= 1, "WHITELIST_LIMIT_EXCEEDED");
1960         // PRESALE_MINTED_TOKEN_COUNT += tokenQuantity;
1961         preSaleListAddress[msg.sender] += tokenQuantity;
1962         for (uint index = 0; index < tokenQuantity; index++) {
1963             _safeMint(walletAddress.userAddress, totalSupply() + 1);
1964         }
1965     }
1966 
1967     // Vishal .transfer is not good for the transfering all the ETH in contract to some address;
1968     function withdrawAll() external onlyOwner {
1969         uint balance = address(this).balance;
1970         require(balance > 0, "ZERO_BALANCE_CONTRACT");
1971         payable(owner()).transfer(address(this).balance);
1972     }
1973 
1974     function getWhitelist(Whitelist memory whitelist) internal view returns(bool){
1975         return getSigner(whitelist) == _signerAddress;
1976     }
1977 
1978     // Reveal transition function 
1979     function reveal() public onlyOwner {
1980         revealed = true;
1981     } 
1982 
1983     function setSignerAddress(address addr) external onlyOwner {
1984         _signerAddress = addr;
1985     }
1986 
1987     function getSignerAddress() public view onlyOwner returns(address signerAddress) {
1988         return _signerAddress;
1989     }
1990 
1991     function tokensOfOwner(address _owner) public view returns (uint256[] memory){
1992         uint256 count = balanceOf(_owner);
1993         uint256[] memory result; 
1994         for (uint256 index = 0; index < count; index++) {
1995             result[index] = tokenOfOwnerByIndex(_owner, index);
1996         }
1997         return result;
1998     }
1999 
2000     function ownerMint(uint256 tokenQuantity) external onlyOwner {
2001         require(tokenQuantity + totalSupply() <= 222, "Mint limit exceeded");
2002         for (uint256 index = 0; index < tokenQuantity; index++) {
2003             _safeMint(msg.sender, totalSupply() + 1);
2004         }
2005     }
2006 }