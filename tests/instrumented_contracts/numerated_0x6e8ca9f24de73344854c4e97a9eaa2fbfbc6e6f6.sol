1 // File: node_modules\@openzeppelin\contracts\utils\Counters.sol";
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title Counters
7  * @author Matt Condon (@shrugs)
8  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
9  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
10  *
11  * Include with `using Counters for Counters.Counter;`
12  */
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint256 _value; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint256) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26         unchecked {
27             counter._value += 1;
28         }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint256 value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34         unchecked {
35             counter._value = value - 1;
36         }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 0;
41     }
42 }
43 // File: node_modules\@openzeppelin\contracts\utils\math\SafeMath.sol";
44 
45 pragma solidity ^0.8.0;
46 
47 // CAUTION
48 // This version of SafeMath should only be used with Solidity 0.8 or later,
49 // because it relies on the compiler's built in overflow checks.
50 
51 /**
52  * @dev Wrappers over Solidity's arithmetic operations.
53  *
54  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
55  * now has built in overflow checking.
56  */
57 library SafeMath {
58     /**
59      * @dev Returns the addition of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             uint256 c = a + b;
66             if (c < a) return (false, 0);
67             return (true, c);
68         }
69     }
70 
71     /**
72      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
73      *
74      * _Available since v3.4._
75      */
76     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b > a) return (false, 0);
79             return (true, a - b);
80         }
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91             // benefit is lost if 'b' is also tested.
92             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
93             if (a == 0) return (true, 0);
94             uint256 c = a * b;
95             if (c / a != b) return (false, 0);
96             return (true, c);
97         }
98     }
99 
100     /**
101      * @dev Returns the division of two unsigned integers, with a division by zero flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             if (b == 0) return (false, 0);
108             return (true, a / b);
109         }
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
114      *
115      * _Available since v3.4._
116      */
117     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         unchecked {
119             if (b == 0) return (false, 0);
120             return (true, a % b);
121         }
122     }
123 
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a + b;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a - b;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      *
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a * b;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers, reverting on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator.
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a / b;
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * reverting when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         return a % b;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
198      * overflow (when the result is negative).
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {trySub}.
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(
210         uint256 a,
211         uint256 b,
212         string memory errorMessage
213     ) internal pure returns (uint256) {
214         unchecked {
215             require(b <= a, errorMessage);
216             return a - b;
217         }
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(
233         uint256 a,
234         uint256 b,
235         string memory errorMessage
236     ) internal pure returns (uint256) {
237         unchecked {
238             require(b > 0, errorMessage);
239             return a / b;
240         }
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * reverting with custom message when dividing by zero.
246      *
247      * CAUTION: This function is deprecated because it requires allocating memory for the error
248      * message unnecessarily. For custom revert reasons use {tryMod}.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(
259         uint256 a,
260         uint256 b,
261         string memory errorMessage
262     ) internal pure returns (uint256) {
263         unchecked {
264             require(b > 0, errorMessage);
265             return a % b;
266         }
267     }
268 }
269 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
270 
271 
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Provides information about the current execution context, including the
277  * sender of the transaction and its data. While these are generally available
278  * via msg.sender and msg.data, they should not be accessed in such a direct
279  * manner, since when dealing with meta-transactions the account sending and
280  * paying for execution may not be the actual sender (as far as an application
281  * is concerned).
282  *
283  * This contract is only required for intermediate, library-like contracts.
284  */
285 abstract contract Context {
286     function _msgSender() internal view virtual returns (address) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes calldata) {
291         return msg.data;
292     }
293 }
294 
295 // File: @openzeppelin\contracts\access\Ownable.sol
296 
297 
298 
299 pragma solidity ^0.8.0;
300 
301 
302 /**
303  * @dev Contract module which provides a basic access control mechanism, where
304  * there is an account (an owner) that can be granted exclusive access to
305  * specific functions.
306  *
307  * By default, the owner account will be the one that deploys the contract. This
308  * can later be changed with {transferOwnership}.
309  *
310  * This module is used through inheritance. It will make available the modifier
311  * `onlyOwner`, which can be applied to your functions to restrict their use to
312  * the owner.
313  */
314 abstract contract Ownable is Context {
315     address private _owner;
316 
317     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
318 
319     /**
320      * @dev Initializes the contract setting the deployer as the initial owner.
321      */
322     constructor() {
323         _setOwner(_msgSender());
324     }
325 
326     /**
327      * @dev Returns the address of the current owner.
328      */
329     function owner() public view virtual returns (address) {
330         return _owner;
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         require(owner() == _msgSender(), "Ownable: caller is not the owner");
338         _;
339     }
340 
341     /**
342      * @dev Leaves the contract without owner. It will not be possible to call
343      * `onlyOwner` functions anymore. Can only be called by the current owner.
344      *
345      * NOTE: Renouncing ownership will leave the contract without an owner,
346      * thereby removing any functionality that is only available to the owner.
347      */
348     function renounceOwnership() public virtual onlyOwner {
349         _setOwner(address(0));
350     }
351 
352     /**
353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
354      * Can only be called by the current owner.
355      */
356     function transferOwnership(address newOwner) public virtual onlyOwner {
357         require(newOwner != address(0), "Ownable: new owner is the zero address");
358         _setOwner(newOwner);
359     }
360 
361     function _setOwner(address newOwner) private {
362         address oldOwner = _owner;
363         _owner = newOwner;
364         emit OwnershipTransferred(oldOwner, newOwner);
365     }
366 }
367 
368 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
369 
370 
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Interface of the ERC165 standard, as defined in the
376  * https://eips.ethereum.org/EIPS/eip-165[EIP].
377  *
378  * Implementers can declare support of contract interfaces, which can then be
379  * queried by others ({ERC165Checker}).
380  *
381  * For an implementation, see {ERC165}.
382  */
383 interface IERC165 {
384     /**
385      * @dev Returns true if this contract implements the interface defined by
386      * `interfaceId`. See the corresponding
387      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
388      * to learn more about how these ids are created.
389      *
390      * This function call must use less than 30 000 gas.
391      */
392     function supportsInterface(bytes4 interfaceId) external view returns (bool);
393 }
394 
395 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Required interface of an ERC721 compliant contract.
404  */
405 interface IERC721 is IERC165 {
406     /**
407      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
413      */
414     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
418      */
419     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
420 
421     /**
422      * @dev Returns the number of tokens in ``owner``'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
437      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Transfers `tokenId` token from `from` to `to`.
457      *
458      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      *
467      * Emits a {Transfer} event.
468      */
469     function transferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
477      * The approval is cleared when the token is transferred.
478      *
479      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
480      *
481      * Requirements:
482      *
483      * - The caller must own the token or be an approved operator.
484      * - `tokenId` must exist.
485      *
486      * Emits an {Approval} event.
487      */
488     function approve(address to, uint256 tokenId) external;
489 
490     /**
491      * @dev Returns the account approved for `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function getApproved(uint256 tokenId) external view returns (address operator);
498 
499     /**
500      * @dev Approve or remove `operator` as an operator for the caller.
501      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
502      *
503      * Requirements:
504      *
505      * - The `operator` cannot be the caller.
506      *
507      * Emits an {ApprovalForAll} event.
508      */
509     function setApprovalForAll(address operator, bool _approved) external;
510 
511     /**
512      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
513      *
514      * See {setApprovalForAll}
515      */
516     function isApprovedForAll(address owner, address operator) external view returns (bool);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId,
535         bytes calldata data
536     ) external;
537 }
538 
539 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @title ERC721 token receiver interface
547  * @dev Interface for any contract that wants to support safeTransfers
548  * from ERC721 asset contracts.
549  */
550 interface IERC721Receiver {
551     /**
552      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
553      * by `operator` from `from`, this function is called.
554      *
555      * It must return its Solidity selector to confirm the token transfer.
556      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
557      *
558      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
559      */
560     function onERC721Received(
561         address operator,
562         address from,
563         uint256 tokenId,
564         bytes calldata data
565     ) external returns (bytes4);
566 }
567 
568 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
569 
570 
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
577  * @dev See https://eips.ethereum.org/EIPS/eip-721
578  */
579 interface IERC721Metadata is IERC721 {
580     /**
581      * @dev Returns the token collection name.
582      */
583     function name() external view returns (string memory);
584 
585     /**
586      * @dev Returns the token collection symbol.
587      */
588     function symbol() external view returns (string memory);
589 
590     /**
591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
592      */
593     function tokenURI(uint256 tokenId) external view returns (string memory);
594 }
595 
596 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
597 
598 
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev Collection of functions related to the address type
604  */
605 library Address {
606     /**
607      * @dev Returns true if `account` is a contract.
608      *
609      * [IMPORTANT]
610      * ====
611      * It is unsafe to assume that an address for which this function returns
612      * false is an externally-owned account (EOA) and not a contract.
613      *
614      * Among others, `isContract` will return false for the following
615      * types of addresses:
616      *
617      *  - an externally-owned account
618      *  - a contract in construction
619      *  - an address where a contract will be created
620      *  - an address where a contract lived, but was destroyed
621      * ====
622      */
623     function isContract(address account) internal view returns (bool) {
624         // This method relies on extcodesize, which returns 0 for contracts in
625         // construction, since the code is only stored at the end of the
626         // constructor execution.
627 
628         uint256 size;
629         assembly {
630             size := extcodesize(account)
631         }
632         return size > 0;
633     }
634 
635     /**
636      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
637      * `recipient`, forwarding all available gas and reverting on errors.
638      *
639      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
640      * of certain opcodes, possibly making contracts go over the 2300 gas limit
641      * imposed by `transfer`, making them unable to receive funds via
642      * `transfer`. {sendValue} removes this limitation.
643      *
644      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
645      *
646      * IMPORTANT: because control is transferred to `recipient`, care must be
647      * taken to not create reentrancy vulnerabilities. Consider using
648      * {ReentrancyGuard} or the
649      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
650      */
651     function sendValue(address payable recipient, uint256 amount) internal {
652         require(address(this).balance >= amount, "Address: insufficient balance");
653 
654         (bool success, ) = recipient.call{value: amount}("");
655         require(success, "Address: unable to send value, recipient may have reverted");
656     }
657 
658     /**
659      * @dev Performs a Solidity function call using a low level `call`. A
660      * plain `call` is an unsafe replacement for a function call: use this
661      * function instead.
662      *
663      * If `target` reverts with a revert reason, it is bubbled up by this
664      * function (like regular Solidity function calls).
665      *
666      * Returns the raw returned data. To convert to the expected return value,
667      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
668      *
669      * Requirements:
670      *
671      * - `target` must be a contract.
672      * - calling `target` with `data` must not revert.
673      *
674      * _Available since v3.1._
675      */
676     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
677         return functionCall(target, data, "Address: low-level call failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
682      * `errorMessage` as a fallback revert reason when `target` reverts.
683      *
684      * _Available since v3.1._
685      */
686     function functionCall(
687         address target,
688         bytes memory data,
689         string memory errorMessage
690     ) internal returns (bytes memory) {
691         return functionCallWithValue(target, data, 0, errorMessage);
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
696      * but also transferring `value` wei to `target`.
697      *
698      * Requirements:
699      *
700      * - the calling contract must have an ETH balance of at least `value`.
701      * - the called Solidity function must be `payable`.
702      *
703      * _Available since v3.1._
704      */
705     function functionCallWithValue(
706         address target,
707         bytes memory data,
708         uint256 value
709     ) internal returns (bytes memory) {
710         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
715      * with `errorMessage` as a fallback revert reason when `target` reverts.
716      *
717      * _Available since v3.1._
718      */
719     function functionCallWithValue(
720         address target,
721         bytes memory data,
722         uint256 value,
723         string memory errorMessage
724     ) internal returns (bytes memory) {
725         require(address(this).balance >= value, "Address: insufficient balance for call");
726         require(isContract(target), "Address: call to non-contract");
727 
728         (bool success, bytes memory returndata) = target.call{value: value}(data);
729         return verifyCallResult(success, returndata, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but performing a static call.
735      *
736      * _Available since v3.3._
737      */
738     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
739         return functionStaticCall(target, data, "Address: low-level static call failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
744      * but performing a static call.
745      *
746      * _Available since v3.3._
747      */
748     function functionStaticCall(
749         address target,
750         bytes memory data,
751         string memory errorMessage
752     ) internal view returns (bytes memory) {
753         require(isContract(target), "Address: static call to non-contract");
754 
755         (bool success, bytes memory returndata) = target.staticcall(data);
756         return verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
761      * but performing a delegate call.
762      *
763      * _Available since v3.4._
764      */
765     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
766         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
771      * but performing a delegate call.
772      *
773      * _Available since v3.4._
774      */
775     function functionDelegateCall(
776         address target,
777         bytes memory data,
778         string memory errorMessage
779     ) internal returns (bytes memory) {
780         require(isContract(target), "Address: delegate call to non-contract");
781 
782         (bool success, bytes memory returndata) = target.delegatecall(data);
783         return verifyCallResult(success, returndata, errorMessage);
784     }
785 
786     /**
787      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
788      * revert reason using the provided one.
789      *
790      * _Available since v4.3._
791      */
792     function verifyCallResult(
793         bool success,
794         bytes memory returndata,
795         string memory errorMessage
796     ) internal pure returns (bytes memory) {
797         if (success) {
798             return returndata;
799         } else {
800             // Look for revert reason and bubble it up if present
801             if (returndata.length > 0) {
802                 // The easiest way to bubble the revert reason is using memory via assembly
803 
804                 assembly {
805                     let returndata_size := mload(returndata)
806                     revert(add(32, returndata), returndata_size)
807                 }
808             } else {
809                 revert(errorMessage);
810             }
811         }
812     }
813 }
814 
815 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
816 
817 
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev String operations.
823  */
824 library Strings {
825     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
826 
827     /**
828      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
829      */
830     function toString(uint256 value) internal pure returns (string memory) {
831         // Inspired by OraclizeAPI's implementation - MIT licence
832         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
833 
834         if (value == 0) {
835             return "0";
836         }
837         uint256 temp = value;
838         uint256 digits;
839         while (temp != 0) {
840             digits++;
841             temp /= 10;
842         }
843         bytes memory buffer = new bytes(digits);
844         while (value != 0) {
845             digits -= 1;
846             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
847             value /= 10;
848         }
849         return string(buffer);
850     }
851 
852     /**
853      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
854      */
855     function toHexString(uint256 value) internal pure returns (string memory) {
856         if (value == 0) {
857             return "0x00";
858         }
859         uint256 temp = value;
860         uint256 length = 0;
861         while (temp != 0) {
862             length++;
863             temp >>= 8;
864         }
865         return toHexString(value, length);
866     }
867 
868     /**
869      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
870      */
871     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
872         bytes memory buffer = new bytes(2 * length + 2);
873         buffer[0] = "0";
874         buffer[1] = "x";
875         for (uint256 i = 2 * length + 1; i > 1; --i) {
876             buffer[i] = _HEX_SYMBOLS[value & 0xf];
877             value >>= 4;
878         }
879         require(value == 0, "Strings: hex length insufficient");
880         return string(buffer);
881     }
882 }
883 
884 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
885 
886 
887 
888 pragma solidity ^0.8.0;
889 
890 
891 /**
892  * @dev Implementation of the {IERC165} interface.
893  *
894  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
895  * for the additional interface id that will be supported. For example:
896  *
897  * ```solidity
898  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
899  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
900  * }
901  * ```
902  *
903  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
904  */
905 abstract contract ERC165 is IERC165 {
906     /**
907      * @dev See {IERC165-supportsInterface}.
908      */
909     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
910         return interfaceId == type(IERC165).interfaceId;
911     }
912 }
913 
914 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
915 
916 
917 
918 pragma solidity ^0.8.0;
919 
920 
921 
922 
923 
924 
925 
926 
927 /**
928  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
929  * the Metadata extension, but not including the Enumerable extension, which is available separately as
930  * {ERC721Enumerable}.
931  */
932 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
933     using Address for address;
934     using Strings for uint256;
935 
936     // Token name
937     string private _name;
938 
939     // Token symbol
940     string private _symbol;
941 
942     // Mapping from token ID to owner address
943     mapping(uint256 => address) private _owners;
944 
945     // Mapping owner address to token count
946     mapping(address => uint256) private _balances;
947 
948     // Mapping from token ID to approved address
949     mapping(uint256 => address) private _tokenApprovals;
950 
951     // Mapping from owner to operator approvals
952     mapping(address => mapping(address => bool)) private _operatorApprovals;
953 
954     /**
955      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
956      */
957     constructor(string memory name_, string memory symbol_) {
958         _name = name_;
959         _symbol = symbol_;
960     }
961 
962     /**
963      * @dev See {IERC165-supportsInterface}.
964      */
965     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
966         return
967             interfaceId == type(IERC721).interfaceId ||
968             interfaceId == type(IERC721Metadata).interfaceId ||
969             super.supportsInterface(interfaceId);
970     }
971 
972     /**
973      * @dev See {IERC721-balanceOf}.
974      */
975     function balanceOf(address owner) public view virtual override returns (uint256) {
976         require(owner != address(0), "ERC721: balance query for the zero address");
977         return _balances[owner];
978     }
979 
980     /**
981      * @dev See {IERC721-ownerOf}.
982      */
983     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
984         address owner = _owners[tokenId];
985         require(owner != address(0), "ERC721: owner query for nonexistent token");
986         return owner;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-name}.
991      */
992     function name() public view virtual override returns (string memory) {
993         return _name;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-symbol}.
998      */
999     function symbol() public view virtual override returns (string memory) {
1000         return _symbol;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-tokenURI}.
1005      */
1006     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1007         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1008 
1009         string memory baseURI = _baseURI();
1010         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1011     }
1012 
1013     /**
1014      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1015      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1016      * by default, can be overriden in child contracts.
1017      */
1018     function _baseURI() internal view virtual returns (string memory) {
1019         return "";
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-approve}.
1024      */
1025     function approve(address to, uint256 tokenId) public virtual override {
1026         address owner = ERC721.ownerOf(tokenId);
1027         require(to != owner, "ERC721: approval to current owner");
1028 
1029         require(
1030             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1031             "ERC721: approve caller is not owner nor approved for all"
1032         );
1033 
1034         _approve(to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-getApproved}.
1039      */
1040     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1041         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1042 
1043         return _tokenApprovals[tokenId];
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-setApprovalForAll}.
1048      */
1049     function setApprovalForAll(address operator, bool approved) public virtual override {
1050         require(operator != _msgSender(), "ERC721: approve to caller");
1051 
1052         _operatorApprovals[_msgSender()][operator] = approved;
1053         emit ApprovalForAll(_msgSender(), operator, approved);
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-isApprovedForAll}.
1058      */
1059     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1060         return _operatorApprovals[owner][operator];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-transferFrom}.
1065      */
1066     function transferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) public virtual override {
1071         //solhint-disable-next-line max-line-length
1072         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1073 
1074         _transfer(from, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-safeTransferFrom}.
1079      */
1080     function safeTransferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) public virtual override {
1085         safeTransferFrom(from, to, tokenId, "");
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) public virtual override {
1097         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1098         _safeTransfer(from, to, tokenId, _data);
1099     }
1100 
1101     /**
1102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1104      *
1105      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1106      *
1107      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1108      * implement alternative mechanisms to perform token transfer, such as signature-based.
1109      *
1110      * Requirements:
1111      *
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must exist and be owned by `from`.
1115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _safeTransfer(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) internal virtual {
1125         _transfer(from, to, tokenId);
1126         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1127     }
1128 
1129     /**
1130      * @dev Returns whether `tokenId` exists.
1131      *
1132      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1133      *
1134      * Tokens start existing when they are minted (`_mint`),
1135      * and stop existing when they are burned (`_burn`).
1136      */
1137     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1138         return _owners[tokenId] != address(0);
1139     }
1140 
1141     /**
1142      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      */
1148     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1149         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1150         address owner = ERC721.ownerOf(tokenId);
1151         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1152     }
1153 
1154     /**
1155      * @dev Safely mints `tokenId` and transfers it to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must not exist.
1160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _safeMint(address to, uint256 tokenId) internal virtual {
1165         _safeMint(to, tokenId, "");
1166     }
1167 
1168     /**
1169      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1170      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1171      */
1172     function _safeMint(
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) internal virtual {
1177         _mint(to, tokenId);
1178         require(
1179             _checkOnERC721Received(address(0), to, tokenId, _data),
1180             "ERC721: transfer to non ERC721Receiver implementer"
1181         );
1182     }
1183 
1184     /**
1185      * @dev Mints `tokenId` and transfers it to `to`.
1186      *
1187      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must not exist.
1192      * - `to` cannot be the zero address.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _mint(address to, uint256 tokenId) internal virtual {
1197         require(to != address(0), "ERC721: mint to the zero address");
1198         require(!_exists(tokenId), "ERC721: token already minted");
1199 
1200         _beforeTokenTransfer(address(0), to, tokenId);
1201 
1202         _balances[to] += 1;
1203         _owners[tokenId] = to;
1204 
1205         emit Transfer(address(0), to, tokenId);
1206     }
1207 
1208     /**
1209      * @dev Destroys `tokenId`.
1210      * The approval is cleared when the token is burned.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must exist.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _burn(uint256 tokenId) internal virtual {
1219         address owner = ERC721.ownerOf(tokenId);
1220 
1221         _beforeTokenTransfer(owner, address(0), tokenId);
1222 
1223         // Clear approvals
1224         _approve(address(0), tokenId);
1225 
1226         _balances[owner] -= 1;
1227         delete _owners[tokenId];
1228 
1229         emit Transfer(owner, address(0), tokenId);
1230     }
1231 
1232     /**
1233      * @dev Transfers `tokenId` from `from` to `to`.
1234      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1235      *
1236      * Requirements:
1237      *
1238      * - `to` cannot be the zero address.
1239      * - `tokenId` token must be owned by `from`.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _transfer(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) internal virtual {
1248         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1249         require(to != address(0), "ERC721: transfer to the zero address");
1250 
1251         _beforeTokenTransfer(from, to, tokenId);
1252 
1253         // Clear approvals from the previous owner
1254         _approve(address(0), tokenId);
1255 
1256         _balances[from] -= 1;
1257         _balances[to] += 1;
1258         _owners[tokenId] = to;
1259 
1260         emit Transfer(from, to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Approve `to` to operate on `tokenId`
1265      *
1266      * Emits a {Approval} event.
1267      */
1268     function _approve(address to, uint256 tokenId) internal virtual {
1269         _tokenApprovals[tokenId] = to;
1270         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1271     }
1272 
1273     /**
1274      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1275      * The call is not executed if the target address is not a contract.
1276      *
1277      * @param from address representing the previous owner of the given token ID
1278      * @param to target address that will receive the tokens
1279      * @param tokenId uint256 ID of the token to be transferred
1280      * @param _data bytes optional data to send along with the call
1281      * @return bool whether the call correctly returned the expected magic value
1282      */
1283     function _checkOnERC721Received(
1284         address from,
1285         address to,
1286         uint256 tokenId,
1287         bytes memory _data
1288     ) private returns (bool) {
1289         if (to.isContract()) {
1290             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1291                 return retval == IERC721Receiver.onERC721Received.selector;
1292             } catch (bytes memory reason) {
1293                 if (reason.length == 0) {
1294                     revert("ERC721: transfer to non ERC721Receiver implementer");
1295                 } else {
1296                     assembly {
1297                         revert(add(32, reason), mload(reason))
1298                     }
1299                 }
1300             }
1301         } else {
1302             return true;
1303         }
1304     }
1305 
1306     /**
1307      * @dev Hook that is called before any token transfer. This includes minting
1308      * and burning.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1316      * - `from` and `to` are never both zero.
1317      *
1318      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1319      */
1320     function _beforeTokenTransfer(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) internal virtual {}
1325 }
1326 
1327 // File: contracts\nobodyv2.sol
1328 // SPDX-License-Identifier: MIT
1329 
1330 
1331 //             ¸ ..
1332 //           « *‡ ‰  ›
1333 //             ª ¨ ™
1334 //        _--- -- -- ---_ 
1335 //       /   ¸ ¸ ¸       \       ¸    
1336 //      ¦|  [  X ]  (  •}|¦      º±_
1337 //      ¦|            ¨¨¨|¦      ”\\ 
1338 //       \   =# # # #=   /                
1339 //        ¯--- -- -- ---¯ 
1340 //
1341 //      _.    _.           ¦|                      |¦
1342 //      _|\\  _|           ¦|                      |¦   _.   _. 
1343 //      _| \\ _|   //¨¸¨\  ¦|ˆˆ¸ˆ\   //¨¸¨\   /ˆ¸ˆˆ|¦   _|   _|
1344 //      _|  \\_|   \____/   \\___/   \____/   \____//   _|____|
1345 //                                                            |
1346 //                                                        _| _|
1347 
1348 pragma solidity ^0.8.0;
1349 pragma experimental ABIEncoderV2;
1350 
1351 interface nobodyinterface
1352 {
1353     function nobody (uint256 tokenid) external view returns (string memory);
1354 }
1355 
1356 contract NobodyNxt is ERC721, Ownable {
1357   using SafeMath for uint256;
1358   using Counters for Counters.Counter;
1359 
1360 
1361   uint public maxNobody = 3210;
1362   uint public maxNobodyPerPurchase = 10;
1363   uint256 public price = 30000000000000000; // 0.03 Ether
1364 
1365   bool public isSaleActive = false;
1366   bool public isPreSaleActive = false;
1367   string public baseURI;
1368 
1369   Counters.Counter private _tokenIds;
1370 
1371   address public nobodyaddress = 0x219463D0675C3fa01C1edf537Ec5Dc693B6410AE; 
1372 
1373   nobodyinterface nobodycontract = nobodyinterface(nobodyaddress);  
1374     
1375   address public creator = 0x7ddD43C63aa73CDE4c5aa6b5De5D9681882D88f8; 
1376 
1377   mapping(address => uint256) presaleAllowance;
1378 
1379   constructor (uint _maxNobody, uint _maxNobodyPerPurchase ) ERC721("NobodyNxt", "NobodyNxt") {
1380     maxNobody = _maxNobody;
1381     maxNobodyPerPurchase = _maxNobodyPerPurchase;
1382     _mintnobody(creator, 1);
1383   }
1384 
1385   function totalSupply() public view returns (uint256) {
1386     return _tokenIds.current();
1387   }
1388   
1389   function presalemint(uint256 _count ) public payable {
1390     require(isPreSaleActive, "Sale is not active!" );
1391     require(isWhitelisted(msg.sender,_count), "Insufficient reserved tokens for your address");
1392     require(totalSupply().add(_count) <= maxNobody, "Sorry too many nobody!");
1393     require(msg.value >= price.mul(_count), "Ether value sent is not correct!");
1394 
1395     _mintnobody(msg.sender, _count);
1396     presaleAllowance[msg.sender] -= _count;
1397   }
1398 
1399   function mint(uint256 _count ) public payable {
1400     require(isSaleActive, "Sale is not active!" );
1401     require(_count > 0 && _count <= maxNobodyPerPurchase, 'Max is 10 at a time');
1402     require(totalSupply().add(_count) <= maxNobody, "Sorry too many nobody!");
1403     require(msg.value >= price.mul(_count), "Ether value sent is not correct!");
1404 
1405     _mintnobody(msg.sender, _count);
1406   }
1407 
1408   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1409     require(_exists(_tokenId), "URI query for nonexistent token");
1410     return string(abi.encodePacked(_baseURI(), "/", nobodycontract.nobody(_tokenId)));
1411   }
1412 
1413   function _mintnobody(address _to, uint256 _count ) internal {
1414     for (uint256 i = 0; i < _count; i++) {
1415         uint256 newItemId = _tokenIds.current();
1416         _tokenIds.increment();
1417         _safeMint(_to, newItemId);
1418     }
1419   }
1420   function getNobodyDNA(uint256 _tokenId) public view returns (string memory) {
1421       require(_exists(_tokenId), "nonexistent token");
1422       return nobodycontract.nobody(_tokenId);
1423   }
1424 
1425   function _baseURI() internal view virtual override returns (string memory) {
1426       return baseURI;
1427   }
1428 
1429   //whitelist
1430   function setWhitelistAllowance(address[] memory _to, uint256 _allowance) public onlyOwner {
1431       for (uint256 i = 0; i < _to.length; i++) {
1432           presaleAllowance[_to[i]] = _allowance;
1433       }
1434   }
1435 
1436   function setWhitelistAllowance(address[] memory _to, uint256[] memory _allowance) public onlyOwner {
1437       for (uint256 i = 0; i < _to.length; i++) {
1438           presaleAllowance[_to[i]] = _allowance[i];
1439       }
1440   }
1441 
1442   function getWhitelistAllowance(address _to) public view returns (uint256) {
1443       return presaleAllowance[_to];
1444   }
1445 
1446   function isWhitelisted(address _account) public view returns (bool) {
1447       return presaleAllowance[_account] > 0;
1448   }
1449 
1450   function isWhitelisted(address _account, uint256 _count) public view returns (bool) {
1451       return presaleAllowance[_account] >= _count;
1452   }
1453 
1454   //owner only
1455   function flipSaleState() public onlyOwner {
1456       isSaleActive = !isSaleActive;
1457   }
1458 
1459   function flipPreSaleState() public onlyOwner {
1460       isPreSaleActive = !isPreSaleActive;
1461   }
1462 
1463   function setPrice(uint256 _newPrice) public onlyOwner {
1464       price = _newPrice;
1465   }
1466   
1467   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1468       baseURI = _newBaseURI;
1469   }
1470 
1471   function withdraw() public onlyOwner {
1472       uint256 balance = address(this).balance;
1473       payable(msg.sender).transfer(balance);
1474   }
1475 
1476   function airdropNobody(address[] memory _to, uint256 _count ) public onlyOwner {        
1477       for (uint256 i = 0; i < _to.length; i++) {
1478       _mintnobody(_to[i], _count);
1479       }
1480   }
1481 
1482 }