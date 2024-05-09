1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 /**
7  * @title Counters
8  * @author Matt Condon (@shrugs)
9  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
10  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
11  *
12  * Include with `using Counters for Counters.Counter;`
13  */
14 library Counters {
15     struct Counter {
16         // This variable should never be directly accessed by users of the library: interactions must be restricted to
17         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
18         // this feature: see https://github.com/ethereum/solidity/issues/4637
19         uint256 _value; // default: 0
20     }
21 
22     function current(Counter storage counter) internal view returns (uint256) {
23         return counter._value;
24     }
25 
26     function increment(Counter storage counter) internal {
27         unchecked {
28             counter._value += 1;
29         }
30     }
31 
32     function decrement(Counter storage counter) internal {
33         uint256 value = counter._value;
34         require(value > 0, "Counter: decrement overflow");
35         unchecked {
36             counter._value = value - 1;
37         }
38     }
39 
40     function reset(Counter storage counter) internal {
41         counter._value = 0;
42     }
43 }
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
47 /**
48  * @dev Provides information about the current execution context, including the
49  * sender of the transaction and its data. While these are generally available
50  * via msg.sender and msg.data, they should not be accessed in such a direct
51  * manner, since when dealing with meta-transactions the account sending and
52  * paying for execution may not be the actual sender (as far as an application
53  * is concerned).
54  *
55  * This contract is only required for intermediate, library-like contracts.
56  */
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         return msg.data;
64     }
65 }
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
69 /**
70  * @dev Contract module which provides a basic access control mechanism, where
71  * there is an account (an owner) that can be granted exclusive access to
72  * specific functions.
73  *
74  * By default, the owner account will be the one that deploys the contract. This
75  * can later be changed with {transferOwnership}.
76  *
77  * This module is used through inheritance. It will make available the modifier
78  * `onlyOwner`, which can be applied to your functions to restrict their use to
79  * the owner.
80  */
81 abstract contract Ownable is Context {
82     address private _owner;
83 
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     /**
87      * @dev Initializes the contract setting the deployer as the initial owner.
88      */
89     constructor() {
90         _transferOwnership(_msgSender());
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     /**
109      * @dev Leaves the contract without owner. It will not be possible to call
110      * `onlyOwner` functions anymore. Can only be called by the current owner.
111      *
112      * NOTE: Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public virtual onlyOwner {
116         _transferOwnership(address(0));
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Can only be called by the current owner.
122      */
123     function transferOwnership(address newOwner) public virtual onlyOwner {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
130      * Internal function without access restriction.
131      */
132     function _transferOwnership(address newOwner) internal virtual {
133         address oldOwner = _owner;
134         _owner = newOwner;
135         emit OwnershipTransferred(oldOwner, newOwner);
136     }
137 }
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
141 // CAUTION
142 // This version of SafeMath should only be used with Solidity 0.8 or later,
143 // because it relies on the compiler's built in overflow checks.
144 /**
145  * @dev Wrappers over Solidity's arithmetic operations.
146  *
147  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
148  * now has built in overflow checking.
149  */
150 library SafeMath {
151     /**
152      * @dev Returns the addition of two unsigned integers, with an overflow flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         unchecked {
158             uint256 c = a + b;
159             if (c < a) return (false, 0);
160             return (true, c);
161         }
162     }
163 
164     /**
165      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
166      *
167      * _Available since v3.4._
168      */
169     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         unchecked {
171             if (b > a) return (false, 0);
172             return (true, a - b);
173         }
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
178      *
179      * _Available since v3.4._
180      */
181     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         unchecked {
183             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184             // benefit is lost if 'b' is also tested.
185             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186             if (a == 0) return (true, 0);
187             uint256 c = a * b;
188             if (c / a != b) return (false, 0);
189             return (true, c);
190         }
191     }
192 
193     /**
194      * @dev Returns the division of two unsigned integers, with a division by zero flag.
195      *
196      * _Available since v3.4._
197      */
198     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
199         unchecked {
200             if (b == 0) return (false, 0);
201             return (true, a / b);
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
207      *
208      * _Available since v3.4._
209      */
210     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
211         unchecked {
212             if (b == 0) return (false, 0);
213             return (true, a % b);
214         }
215     }
216 
217     /**
218      * @dev Returns the addition of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `+` operator.
222      *
223      * Requirements:
224      *
225      * - Addition cannot overflow.
226      */
227     function add(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a + b;
229     }
230 
231     /**
232      * @dev Returns the subtraction of two unsigned integers, reverting on
233      * overflow (when the result is negative).
234      *
235      * Counterpart to Solidity's `-` operator.
236      *
237      * Requirements:
238      *
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242         return a - b;
243     }
244 
245     /**
246      * @dev Returns the multiplication of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `*` operator.
250      *
251      * Requirements:
252      *
253      * - Multiplication cannot overflow.
254      */
255     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a * b;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers, reverting on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator.
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function div(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a / b;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * reverting when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a % b;
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
291      * overflow (when the result is negative).
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {trySub}.
295      *
296      * Counterpart to Solidity's `-` operator.
297      *
298      * Requirements:
299      *
300      * - Subtraction cannot overflow.
301      */
302     function sub(
303         uint256 a,
304         uint256 b,
305         string memory errorMessage
306     ) internal pure returns (uint256) {
307         unchecked {
308             require(b <= a, errorMessage);
309             return a - b;
310         }
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
315      * division by zero. The result is rounded towards zero.
316      *
317      * Counterpart to Solidity's `/` operator. Note: this function uses a
318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
319      * uses an invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function div(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a / b;
333         }
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * reverting with custom message when dividing by zero.
339      *
340      * CAUTION: This function is deprecated because it requires allocating memory for the error
341      * message unnecessarily. For custom revert reasons use {tryMod}.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function mod(
352         uint256 a,
353         uint256 b,
354         string memory errorMessage
355     ) internal pure returns (uint256) {
356         unchecked {
357             require(b > 0, errorMessage);
358             return a % b;
359         }
360     }
361 }
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
365 /**
366  * @dev Interface of the ERC165 standard, as defined in the
367  * https://eips.ethereum.org/EIPS/eip-165[EIP].
368  *
369  * Implementers can declare support of contract interfaces, which can then be
370  * queried by others ({ERC165Checker}).
371  *
372  * For an implementation, see {ERC165}.
373  */
374 interface IERC165 {
375     /**
376      * @dev Returns true if this contract implements the interface defined by
377      * `interfaceId`. See the corresponding
378      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
379      * to learn more about how these ids are created.
380      *
381      * This function call must use less than 30 000 gas.
382      */
383     function supportsInterface(bytes4 interfaceId) external view returns (bool);
384 }
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
527 /**
528  * @title ERC721 token receiver interface
529  * @dev Interface for any contract that wants to support safeTransfers
530  * from ERC721 asset contracts.
531  */
532 interface IERC721Receiver {
533     /**
534      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
535      * by `operator` from `from`, this function is called.
536      *
537      * It must return its Solidity selector to confirm the token transfer.
538      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
539      *
540      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
541      */
542     function onERC721Received(
543         address operator,
544         address from,
545         uint256 tokenId,
546         bytes calldata data
547     ) external returns (bytes4);
548 }
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
552 /**
553  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
554  * @dev See https://eips.ethereum.org/EIPS/eip-721
555  */
556 interface IERC721Metadata is IERC721 {
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() external view returns (string memory);
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() external view returns (string memory);
566 
567     /**
568      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
569      */
570     function tokenURI(uint256 tokenId) external view returns (string memory);
571 }
572 
573 
574 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
575 /**
576  * @dev Collection of functions related to the address type
577  */
578 library Address {
579     /**
580      * @dev Returns true if `account` is a contract.
581      *
582      * [IMPORTANT]
583      * ====
584      * It is unsafe to assume that an address for which this function returns
585      * false is an externally-owned account (EOA) and not a contract.
586      *
587      * Among others, `isContract` will return false for the following
588      * types of addresses:
589      *
590      *  - an externally-owned account
591      *  - a contract in construction
592      *  - an address where a contract will be created
593      *  - an address where a contract lived, but was destroyed
594      * ====
595      *
596      * [IMPORTANT]
597      * ====
598      * You shouldn't rely on `isContract` to protect against flash loan attacks!
599      *
600      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
601      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
602      * constructor.
603      * ====
604      */
605     function isContract(address account) internal view returns (bool) {
606         // This method relies on extcodesize/address.code.length, which returns 0
607         // for contracts in construction, since the code is only stored at the end
608         // of the constructor execution.
609 
610         return account.code.length > 0;
611     }
612 
613     /**
614      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
615      * `recipient`, forwarding all available gas and reverting on errors.
616      *
617      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
618      * of certain opcodes, possibly making contracts go over the 2300 gas limit
619      * imposed by `transfer`, making them unable to receive funds via
620      * `transfer`. {sendValue} removes this limitation.
621      *
622      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
623      *
624      * IMPORTANT: because control is transferred to `recipient`, care must be
625      * taken to not create reentrancy vulnerabilities. Consider using
626      * {ReentrancyGuard} or the
627      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
628      */
629     function sendValue(address payable recipient, uint256 amount) internal {
630         require(address(this).balance >= amount, "Address: insufficient balance");
631 
632         (bool success, ) = recipient.call{value: amount}("");
633         require(success, "Address: unable to send value, recipient may have reverted");
634     }
635 
636     /**
637      * @dev Performs a Solidity function call using a low level `call`. A
638      * plain `call` is an unsafe replacement for a function call: use this
639      * function instead.
640      *
641      * If `target` reverts with a revert reason, it is bubbled up by this
642      * function (like regular Solidity function calls).
643      *
644      * Returns the raw returned data. To convert to the expected return value,
645      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
646      *
647      * Requirements:
648      *
649      * - `target` must be a contract.
650      * - calling `target` with `data` must not revert.
651      *
652      * _Available since v3.1._
653      */
654     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
655         return functionCall(target, data, "Address: low-level call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
660      * `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(
665         address target,
666         bytes memory data,
667         string memory errorMessage
668     ) internal returns (bytes memory) {
669         return functionCallWithValue(target, data, 0, errorMessage);
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
674      * but also transferring `value` wei to `target`.
675      *
676      * Requirements:
677      *
678      * - the calling contract must have an ETH balance of at least `value`.
679      * - the called Solidity function must be `payable`.
680      *
681      * _Available since v3.1._
682      */
683     function functionCallWithValue(
684         address target,
685         bytes memory data,
686         uint256 value
687     ) internal returns (bytes memory) {
688         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
693      * with `errorMessage` as a fallback revert reason when `target` reverts.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(
698         address target,
699         bytes memory data,
700         uint256 value,
701         string memory errorMessage
702     ) internal returns (bytes memory) {
703         require(address(this).balance >= value, "Address: insufficient balance for call");
704         require(isContract(target), "Address: call to non-contract");
705 
706         (bool success, bytes memory returndata) = target.call{value: value}(data);
707         return verifyCallResult(success, returndata, errorMessage);
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
712      * but performing a static call.
713      *
714      * _Available since v3.3._
715      */
716     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
717         return functionStaticCall(target, data, "Address: low-level static call failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
722      * but performing a static call.
723      *
724      * _Available since v3.3._
725      */
726     function functionStaticCall(
727         address target,
728         bytes memory data,
729         string memory errorMessage
730     ) internal view returns (bytes memory) {
731         require(isContract(target), "Address: static call to non-contract");
732 
733         (bool success, bytes memory returndata) = target.staticcall(data);
734         return verifyCallResult(success, returndata, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but performing a delegate call.
740      *
741      * _Available since v3.4._
742      */
743     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
744         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
749      * but performing a delegate call.
750      *
751      * _Available since v3.4._
752      */
753     function functionDelegateCall(
754         address target,
755         bytes memory data,
756         string memory errorMessage
757     ) internal returns (bytes memory) {
758         require(isContract(target), "Address: delegate call to non-contract");
759 
760         (bool success, bytes memory returndata) = target.delegatecall(data);
761         return verifyCallResult(success, returndata, errorMessage);
762     }
763 
764     /**
765      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
766      * revert reason using the provided one.
767      *
768      * _Available since v4.3._
769      */
770     function verifyCallResult(
771         bool success,
772         bytes memory returndata,
773         string memory errorMessage
774     ) internal pure returns (bytes memory) {
775         if (success) {
776             return returndata;
777         } else {
778             // Look for revert reason and bubble it up if present
779             if (returndata.length > 0) {
780                 // The easiest way to bubble the revert reason is using memory via assembly
781 
782                 assembly {
783                     let returndata_size := mload(returndata)
784                     revert(add(32, returndata), returndata_size)
785                 }
786             } else {
787                 revert(errorMessage);
788             }
789         }
790     }
791 }
792 
793 
794 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
795 /**
796  * @dev String operations.
797  */
798 library Strings {
799     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
800 
801     /**
802      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
803      */
804     function toString(uint256 value) internal pure returns (string memory) {
805         // Inspired by OraclizeAPI's implementation - MIT licence
806         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
807 
808         if (value == 0) {
809             return "0";
810         }
811         uint256 temp = value;
812         uint256 digits;
813         while (temp != 0) {
814             digits++;
815             temp /= 10;
816         }
817         bytes memory buffer = new bytes(digits);
818         while (value != 0) {
819             digits -= 1;
820             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
821             value /= 10;
822         }
823         return string(buffer);
824     }
825 
826     /**
827      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
828      */
829     function toHexString(uint256 value) internal pure returns (string memory) {
830         if (value == 0) {
831             return "0x00";
832         }
833         uint256 temp = value;
834         uint256 length = 0;
835         while (temp != 0) {
836             length++;
837             temp >>= 8;
838         }
839         return toHexString(value, length);
840     }
841 
842     /**
843      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
844      */
845     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
846         bytes memory buffer = new bytes(2 * length + 2);
847         buffer[0] = "0";
848         buffer[1] = "x";
849         for (uint256 i = 2 * length + 1; i > 1; --i) {
850             buffer[i] = _HEX_SYMBOLS[value & 0xf];
851             value >>= 4;
852         }
853         require(value == 0, "Strings: hex length insufficient");
854         return string(buffer);
855     }
856 }
857 
858 
859 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
860 /**
861  * @dev Implementation of the {IERC165} interface.
862  *
863  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
864  * for the additional interface id that will be supported. For example:
865  *
866  * ```solidity
867  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
868  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
869  * }
870  * ```
871  *
872  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
873  */
874 abstract contract ERC165 is IERC165 {
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879         return interfaceId == type(IERC165).interfaceId;
880     }
881 }
882 
883 
884 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
885 /**
886  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
887  * the Metadata extension, but not including the Enumerable extension, which is available separately as
888  * {ERC721Enumerable}.
889  */
890 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
891     using Address for address;
892     using Strings for uint256;
893 
894     // Token name
895     string private _name;
896 
897     // Token symbol
898     string private _symbol;
899 
900     // Mapping from token ID to owner address
901     mapping(uint256 => address) private _owners;
902 
903     // Mapping owner address to token count
904     mapping(address => uint256) private _balances;
905 
906     // Mapping from token ID to approved address
907     mapping(uint256 => address) private _tokenApprovals;
908 
909     // Mapping from owner to operator approvals
910     mapping(address => mapping(address => bool)) private _operatorApprovals;
911 
912     /**
913      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
914      */
915     constructor(string memory name_, string memory symbol_) {
916         _name = name_;
917         _symbol = symbol_;
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev See {IERC721-balanceOf}.
932      */
933     function balanceOf(address owner) public view virtual override returns (uint256) {
934         require(owner != address(0), "ERC721: balance query for the zero address");
935         return _balances[owner];
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
942         address owner = _owners[tokenId];
943         require(owner != address(0), "ERC721: owner query for nonexistent token");
944         return owner;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-name}.
949      */
950     function name() public view virtual override returns (string memory) {
951         return _name;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-symbol}.
956      */
957     function symbol() public view virtual override returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-tokenURI}.
963      */
964     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
965         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
966 
967         string memory baseURI = _baseURI();
968         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
969     }
970 
971     /**
972      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
973      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
974      * by default, can be overriden in child contracts.
975      */
976     function _baseURI() internal view virtual returns (string memory) {
977         return "";
978     }
979 
980     /**
981      * @dev See {IERC721-approve}.
982      */
983     function approve(address to, uint256 tokenId) public virtual override {
984         address owner = ERC721.ownerOf(tokenId);
985         require(to != owner, "ERC721: approval to current owner");
986 
987         require(
988             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
989             "ERC721: approve caller is not owner nor approved for all"
990         );
991 
992         _approve(to, tokenId);
993     }
994 
995     /**
996      * @dev See {IERC721-getApproved}.
997      */
998     function getApproved(uint256 tokenId) public view virtual override returns (address) {
999         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1000 
1001         return _tokenApprovals[tokenId];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-setApprovalForAll}.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public virtual override {
1008         _setApprovalForAll(_msgSender(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         //solhint-disable-next-line max-line-length
1027         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1028 
1029         _transfer(from, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         safeTransferFrom(from, to, tokenId, "");
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) public virtual override {
1052         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1053         _safeTransfer(from, to, tokenId, _data);
1054     }
1055 
1056     /**
1057      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1058      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1059      *
1060      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1061      *
1062      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1063      * implement alternative mechanisms to perform token transfer, such as signature-based.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must exist and be owned by `from`.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) internal virtual {
1080         _transfer(from, to, tokenId);
1081         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1082     }
1083 
1084     /**
1085      * @dev Returns whether `tokenId` exists.
1086      *
1087      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1088      *
1089      * Tokens start existing when they are minted (`_mint`),
1090      * and stop existing when they are burned (`_burn`).
1091      */
1092     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1093         return _owners[tokenId] != address(0);
1094     }
1095 
1096     /**
1097      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      */
1103     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1104         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1105         address owner = ERC721.ownerOf(tokenId);
1106         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1107     }
1108 
1109     /**
1110      * @dev Safely mints `tokenId` and transfers it to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must not exist.
1115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _safeMint(address to, uint256 tokenId) internal virtual {
1120         _safeMint(to, tokenId, "");
1121     }
1122 
1123     /**
1124      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1125      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1126      */
1127     function _safeMint(
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) internal virtual {
1132         _mint(to, tokenId);
1133         require(
1134             _checkOnERC721Received(address(0), to, tokenId, _data),
1135             "ERC721: transfer to non ERC721Receiver implementer"
1136         );
1137     }
1138 
1139     /**
1140      * @dev Mints `tokenId` and transfers it to `to`.
1141      *
1142      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must not exist.
1147      * - `to` cannot be the zero address.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _mint(address to, uint256 tokenId) internal virtual {
1152         require(to != address(0), "ERC721: mint to the zero address");
1153         require(!_exists(tokenId), "ERC721: token already minted");
1154 
1155         _beforeTokenTransfer(address(0), to, tokenId);
1156 
1157         _balances[to] += 1;
1158         _owners[tokenId] = to;
1159 
1160         emit Transfer(address(0), to, tokenId);
1161 
1162         _afterTokenTransfer(address(0), to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Destroys `tokenId`.
1167      * The approval is cleared when the token is burned.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _burn(uint256 tokenId) internal virtual {
1176         address owner = ERC721.ownerOf(tokenId);
1177 
1178         _beforeTokenTransfer(owner, address(0), tokenId);
1179 
1180         // Clear approvals
1181         _approve(address(0), tokenId);
1182 
1183         _balances[owner] -= 1;
1184         delete _owners[tokenId];
1185 
1186         emit Transfer(owner, address(0), tokenId);
1187 
1188         _afterTokenTransfer(owner, address(0), tokenId);
1189     }
1190 
1191     /**
1192      * @dev Transfers `tokenId` from `from` to `to`.
1193      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1194      *
1195      * Requirements:
1196      *
1197      * - `to` cannot be the zero address.
1198      * - `tokenId` token must be owned by `from`.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _transfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) internal virtual {
1207         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1208         require(to != address(0), "ERC721: transfer to the zero address");
1209 
1210         _beforeTokenTransfer(from, to, tokenId);
1211 
1212         // Clear approvals from the previous owner
1213         _approve(address(0), tokenId);
1214 
1215         _balances[from] -= 1;
1216         _balances[to] += 1;
1217         _owners[tokenId] = to;
1218 
1219         emit Transfer(from, to, tokenId);
1220 
1221         _afterTokenTransfer(from, to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev Approve `to` to operate on `tokenId`
1226      *
1227      * Emits a {Approval} event.
1228      */
1229     function _approve(address to, uint256 tokenId) internal virtual {
1230         _tokenApprovals[tokenId] = to;
1231         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Approve `operator` to operate on all of `owner` tokens
1236      *
1237      * Emits a {ApprovalForAll} event.
1238      */
1239     function _setApprovalForAll(
1240         address owner,
1241         address operator,
1242         bool approved
1243     ) internal virtual {
1244         require(owner != operator, "ERC721: approve to caller");
1245         _operatorApprovals[owner][operator] = approved;
1246         emit ApprovalForAll(owner, operator, approved);
1247     }
1248 
1249     /**
1250      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1251      * The call is not executed if the target address is not a contract.
1252      *
1253      * @param from address representing the previous owner of the given token ID
1254      * @param to target address that will receive the tokens
1255      * @param tokenId uint256 ID of the token to be transferred
1256      * @param _data bytes optional data to send along with the call
1257      * @return bool whether the call correctly returned the expected magic value
1258      */
1259     function _checkOnERC721Received(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) private returns (bool) {
1265         if (to.isContract()) {
1266             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1267                 return retval == IERC721Receiver.onERC721Received.selector;
1268             } catch (bytes memory reason) {
1269                 if (reason.length == 0) {
1270                     revert("ERC721: transfer to non ERC721Receiver implementer");
1271                 } else {
1272                     assembly {
1273                         revert(add(32, reason), mload(reason))
1274                     }
1275                 }
1276             }
1277         } else {
1278             return true;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before any token transfer. This includes minting
1284      * and burning.
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1292      * - `from` and `to` are never both zero.
1293      *
1294      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1295      */
1296     function _beforeTokenTransfer(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after any transfer of tokens. This includes
1304      * minting and burning.
1305      *
1306      * Calling conditions:
1307      *
1308      * - when `from` and `to` are both non-zero.
1309      * - `from` and `to` are never both zero.
1310      *
1311      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1312      */
1313     function _afterTokenTransfer(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) internal virtual {}
1318 }
1319 
1320 
1321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1322 /**
1323  * @dev ERC721 token with storage based token URI management.
1324  */
1325 abstract contract ERC721URIStorage is ERC721 {
1326     using Strings for uint256;
1327 
1328     // Optional mapping for token URIs
1329     mapping(uint256 => string) private _tokenURIs;
1330 
1331     /**
1332      * @dev See {IERC721Metadata-tokenURI}.
1333      */
1334     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1335         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1336 
1337         string memory _tokenURI = _tokenURIs[tokenId];
1338         string memory base = _baseURI();
1339 
1340         // If there is no base URI, return the token URI.
1341         if (bytes(base).length == 0) {
1342             return _tokenURI;
1343         }
1344         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1345         if (bytes(_tokenURI).length > 0) {
1346             return string(abi.encodePacked(base, _tokenURI));
1347         }
1348 
1349         return super.tokenURI(tokenId);
1350     }
1351 
1352     /**
1353      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must exist.
1358      */
1359     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1360         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1361         _tokenURIs[tokenId] = _tokenURI;
1362     }
1363 
1364     /**
1365      * @dev Destroys `tokenId`.
1366      * The approval is cleared when the token is burned.
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must exist.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function _burn(uint256 tokenId) internal virtual override {
1375         super._burn(tokenId);
1376 
1377         if (bytes(_tokenURIs[tokenId]).length != 0) {
1378             delete _tokenURIs[tokenId];
1379         }
1380     }
1381 }
1382 
1383 
1384 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1385 /**
1386  * @dev These functions deal with verification of Merkle Trees proofs.
1387  *
1388  * The proofs can be generated using the JavaScript library
1389  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1390  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1391  *
1392  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1393  */
1394 library MerkleProof {
1395     /**
1396      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1397      * defined by `root`. For this, a `proof` must be provided, containing
1398      * sibling hashes on the branch from the leaf to the root of the tree. Each
1399      * pair of leaves and each pair of pre-images are assumed to be sorted.
1400      */
1401     function verify(
1402         bytes32[] memory proof,
1403         bytes32 root,
1404         bytes32 leaf
1405     ) internal pure returns (bool) {
1406         return processProof(proof, leaf) == root;
1407     }
1408 
1409     /**
1410      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1411      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1412      * hash matches the root of the tree. When processing the proof, the pairs
1413      * of leafs & pre-images are assumed to be sorted.
1414      *
1415      * _Available since v4.4._
1416      */
1417     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1418         bytes32 computedHash = leaf;
1419         for (uint256 i = 0; i < proof.length; i++) {
1420             bytes32 proofElement = proof[i];
1421             if (computedHash <= proofElement) {
1422                 // Hash(current computed hash + current element of the proof)
1423                 computedHash = _efficientHash(computedHash, proofElement);
1424             } else {
1425                 // Hash(current element of the proof + current computed hash)
1426                 computedHash = _efficientHash(proofElement, computedHash);
1427             }
1428         }
1429         return computedHash;
1430     }
1431 
1432     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1433         assembly {
1434             mstore(0x00, a)
1435             mstore(0x20, b)
1436             value := keccak256(0x00, 0x40)
1437         }
1438     }
1439 }
1440 
1441 
1442 contract MineNations is ERC721URIStorage, Ownable {
1443     using SafeMath for uint256;
1444     using Counters for Counters.Counter;
1445     Counters.Counter private _tokenIds;
1446 
1447     string private baseURI;
1448     string public notRevealedURI;
1449     string public baseExtension = ".json";
1450     bytes32 public merkleRoot;
1451     address public community = 0x26F6fbe9b2888De3A36870Ddf241e28Fa134A3D6;
1452     bool public revealed = false;
1453     uint256 public presaleEnded;
1454     uint256 public publicPrice = 0.06 ether;
1455     uint256 public whitelistPrice = 0.05 ether;
1456 
1457     mapping (address => uint) public ownWallet;
1458 
1459     constructor(string memory _name, string memory _symbol, string memory _initBaseURI, string memory _initNotRevealedURI) ERC721(_name, _symbol) {
1460       baseURI = _initBaseURI;
1461       notRevealedURI = _initNotRevealedURI;
1462       mintItem(community, 35);
1463     }
1464 
1465     /* ****************** */
1466     /* INTERNAL FUNCTIONS */
1467     /* ****************** */
1468     function _baseURI() internal view virtual override returns (string memory) {
1469       if(revealed == false){
1470         return notRevealedURI;
1471       }
1472       return baseURI;
1473     }
1474 
1475     /* **************** */
1476     /* PUBLIC FUNCTIONS */
1477     /* **************** */
1478     function totalSupply() public view returns (uint256) {
1479         return _tokenIds.current();
1480     }
1481 
1482     function tokenURI (uint256 tokenId) public view virtual override returns(string memory){
1483       require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1484 
1485       string memory currentBaseURI = _baseURI();
1486 
1487       if(revealed == false){
1488         return bytes(currentBaseURI).length > 0
1489             ? string(
1490                 abi.encodePacked(
1491                     currentBaseURI,
1492                     Strings.toString(1),
1493                     baseExtension
1494                 )
1495             )
1496             : "";
1497       }
1498       
1499       return bytes(currentBaseURI).length > 0
1500             ? string(
1501                 abi.encodePacked(
1502                     currentBaseURI,
1503                     Strings.toString(tokenId),
1504                     baseExtension
1505                 )
1506             )
1507             : "";
1508     }
1509 
1510     function whitelistMint(address _to, uint _count, bytes32[] memory _merkleProof) public payable {
1511       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1512       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof");
1513       require(totalSupply() + _count <= 10000, "Can't mint anymore");
1514       require(presaleEnded > 0, "Can't mint the nft");
1515       if(block.timestamp < presaleEnded) {
1516         require(ownWallet[msg.sender] + _count <= 2, "Maxium is 2 during pre-sale step");
1517         require(msg.value >= _count * whitelistPrice, "Not match balance");
1518       } else {
1519         require(ownWallet[msg.sender] + _count <= 5, "Maxium is 5");
1520         require(msg.value >= _count * publicPrice, "Not match balance");
1521       }
1522 
1523       for(uint i = 0; i < _count; i++) {
1524         _tokenIds.increment();
1525         ownWallet[_to]++;
1526         _safeMint(_to, _tokenIds.current());
1527       }
1528     }
1529 
1530     function mintItem(address _to, uint _count) public payable {
1531       require(totalSupply() + _count <= 10000, "Can't mint anymore");
1532       if(msg.sender != owner() && msg.sender !=community) {
1533         require(presaleEnded > 0, "Can't mint the nft");
1534         require(block.timestamp >= presaleEnded, "Only whitelists can be mint during the pre-sale step");
1535         require(msg.value >= _count * publicPrice, "Not match balance");
1536         require(ownWallet[msg.sender] + _count <= 3, "Maxium is 3");
1537       }
1538 
1539       for(uint i = 0; i < _count; i++) {
1540         _tokenIds.increment();
1541         ownWallet[_to]++;
1542         _safeMint(_to, _tokenIds.current());
1543       }
1544     }
1545 
1546     function status() public view returns (bool) {
1547       return block.timestamp < presaleEnded;
1548     }
1549 
1550     /* *************** */
1551     /* OWNER FUNCTIONS */
1552     /* *************** */
1553     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1554         baseURI = _newBaseURI;
1555     }
1556 
1557     function setNotRevealedURI(string memory _newNotRevealedURI) public onlyOwner {
1558         notRevealedURI = _newNotRevealedURI;
1559     }
1560 
1561     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1562         baseExtension = _newBaseExtension;
1563     }
1564 
1565     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
1566         merkleRoot = _merkleRoot;
1567     }
1568 
1569     function startReveal() public onlyOwner {
1570         revealed = true;
1571     }
1572 
1573     function startPresale() public onlyOwner {
1574         presaleEnded = block.timestamp + 1 days;
1575     }
1576 
1577     function setPublicPrice(uint256 _newPublicPrice) public onlyOwner {
1578         publicPrice = _newPublicPrice;
1579     }
1580 
1581     function setWhitelistPrice(uint256 _newWhitelistPrice) public onlyOwner {
1582         whitelistPrice = _newWhitelistPrice;
1583     }
1584 
1585     function isPresale() public view returns (bool) {
1586         return block.timestamp < presaleEnded;
1587     }
1588 
1589     function isWhitelist(bytes32[] memory _merkleProof) public view returns (bool) {
1590        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1591        return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1592     }
1593 
1594     function withdraw() external onlyOwner {
1595       address _owner = owner();
1596       payable(_owner).transfer( address(this).balance );
1597     }
1598 }