1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 // CAUTION
182 // This version of SafeMath should only be used with Solidity 0.8 or later,
183 // because it relies on the compiler's built in overflow checks.
184 
185 /**
186  * @dev Wrappers over Solidity's arithmetic operations.
187  *
188  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
189  * now has built in overflow checking.
190  */
191 library SafeMath {
192     /**
193      * @dev Returns the addition of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             uint256 c = a + b;
200             if (c < a) return (false, 0);
201             return (true, c);
202         }
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
207      *
208      * _Available since v3.4._
209      */
210     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
211         unchecked {
212             if (b > a) return (false, 0);
213             return (true, a - b);
214         }
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
219      *
220      * _Available since v3.4._
221      */
222     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         unchecked {
224             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225             // benefit is lost if 'b' is also tested.
226             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227             if (a == 0) return (true, 0);
228             uint256 c = a * b;
229             if (c / a != b) return (false, 0);
230             return (true, c);
231         }
232     }
233 
234     /**
235      * @dev Returns the division of two unsigned integers, with a division by zero flag.
236      *
237      * _Available since v3.4._
238      */
239     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (b == 0) return (false, 0);
242             return (true, a / b);
243         }
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
248      *
249      * _Available since v3.4._
250      */
251     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (b == 0) return (false, 0);
254             return (true, a % b);
255         }
256     }
257 
258     /**
259      * @dev Returns the addition of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `+` operator.
263      *
264      * Requirements:
265      *
266      * - Addition cannot overflow.
267      */
268     function add(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a + b;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a - b;
284     }
285 
286     /**
287      * @dev Returns the multiplication of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `*` operator.
291      *
292      * Requirements:
293      *
294      * - Multiplication cannot overflow.
295      */
296     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a * b;
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers, reverting on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator.
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a / b;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * reverting when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a % b;
328     }
329 
330     /**
331      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
332      * overflow (when the result is negative).
333      *
334      * CAUTION: This function is deprecated because it requires allocating memory for the error
335      * message unnecessarily. For custom revert reasons use {trySub}.
336      *
337      * Counterpart to Solidity's `-` operator.
338      *
339      * Requirements:
340      *
341      * - Subtraction cannot overflow.
342      */
343     function sub(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         unchecked {
349             require(b <= a, errorMessage);
350             return a - b;
351         }
352     }
353 
354     /**
355      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
356      * division by zero. The result is rounded towards zero.
357      *
358      * Counterpart to Solidity's `/` operator. Note: this function uses a
359      * `revert` opcode (which leaves remaining gas untouched) while Solidity
360      * uses an invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function div(
367         uint256 a,
368         uint256 b,
369         string memory errorMessage
370     ) internal pure returns (uint256) {
371         unchecked {
372             require(b > 0, errorMessage);
373             return a / b;
374         }
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
379      * reverting with custom message when dividing by zero.
380      *
381      * CAUTION: This function is deprecated because it requires allocating memory for the error
382      * message unnecessarily. For custom revert reasons use {tryMod}.
383      *
384      * Counterpart to Solidity's `%` operator. This function uses a `revert`
385      * opcode (which leaves remaining gas untouched) while Solidity uses an
386      * invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      *
390      * - The divisor cannot be zero.
391      */
392     function mod(
393         uint256 a,
394         uint256 b,
395         string memory errorMessage
396     ) internal pure returns (uint256) {
397         unchecked {
398             require(b > 0, errorMessage);
399             return a % b;
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/utils/Address.sol
405 
406 
407 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
408 
409 pragma solidity ^0.8.1;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      *
432      * [IMPORTANT]
433      * ====
434      * You shouldn't rely on `isContract` to protect against flash loan attacks!
435      *
436      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
437      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
438      * constructor.
439      * ====
440      */
441     function isContract(address account) internal view returns (bool) {
442         // This method relies on extcodesize/address.code.length, which returns 0
443         // for contracts in construction, since the code is only stored at the end
444         // of the constructor execution.
445 
446         return account.code.length > 0;
447     }
448 
449     /**
450      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
451      * `recipient`, forwarding all available gas and reverting on errors.
452      *
453      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
454      * of certain opcodes, possibly making contracts go over the 2300 gas limit
455      * imposed by `transfer`, making them unable to receive funds via
456      * `transfer`. {sendValue} removes this limitation.
457      *
458      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
459      *
460      * IMPORTANT: because control is transferred to `recipient`, care must be
461      * taken to not create reentrancy vulnerabilities. Consider using
462      * {ReentrancyGuard} or the
463      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
464      */
465     function sendValue(address payable recipient, uint256 amount) internal {
466         require(address(this).balance >= amount, "Address: insufficient balance");
467 
468         (bool success, ) = recipient.call{value: amount}("");
469         require(success, "Address: unable to send value, recipient may have reverted");
470     }
471 
472     /**
473      * @dev Performs a Solidity function call using a low level `call`. A
474      * plain `call` is an unsafe replacement for a function call: use this
475      * function instead.
476      *
477      * If `target` reverts with a revert reason, it is bubbled up by this
478      * function (like regular Solidity function calls).
479      *
480      * Returns the raw returned data. To convert to the expected return value,
481      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
482      *
483      * Requirements:
484      *
485      * - `target` must be a contract.
486      * - calling `target` with `data` must not revert.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
491         return functionCall(target, data, "Address: low-level call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
496      * `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, 0, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but also transferring `value` wei to `target`.
511      *
512      * Requirements:
513      *
514      * - the calling contract must have an ETH balance of at least `value`.
515      * - the called Solidity function must be `payable`.
516      *
517      * _Available since v3.1._
518      */
519     function functionCallWithValue(
520         address target,
521         bytes memory data,
522         uint256 value
523     ) internal returns (bytes memory) {
524         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
529      * with `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(
534         address target,
535         bytes memory data,
536         uint256 value,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         require(address(this).balance >= value, "Address: insufficient balance for call");
540         require(isContract(target), "Address: call to non-contract");
541 
542         (bool success, bytes memory returndata) = target.call{value: value}(data);
543         return verifyCallResult(success, returndata, errorMessage);
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
553         return functionStaticCall(target, data, "Address: low-level static call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
558      * but performing a static call.
559      *
560      * _Available since v3.3._
561      */
562     function functionStaticCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal view returns (bytes memory) {
567         require(isContract(target), "Address: static call to non-contract");
568 
569         (bool success, bytes memory returndata) = target.staticcall(data);
570         return verifyCallResult(success, returndata, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but performing a delegate call.
576      *
577      * _Available since v3.4._
578      */
579     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
580         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
585      * but performing a delegate call.
586      *
587      * _Available since v3.4._
588      */
589     function functionDelegateCall(
590         address target,
591         bytes memory data,
592         string memory errorMessage
593     ) internal returns (bytes memory) {
594         require(isContract(target), "Address: delegate call to non-contract");
595 
596         (bool success, bytes memory returndata) = target.delegatecall(data);
597         return verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
602      * revert reason using the provided one.
603      *
604      * _Available since v4.3._
605      */
606     function verifyCallResult(
607         bool success,
608         bytes memory returndata,
609         string memory errorMessage
610     ) internal pure returns (bytes memory) {
611         if (success) {
612             return returndata;
613         } else {
614             // Look for revert reason and bubble it up if present
615             if (returndata.length > 0) {
616                 // The easiest way to bubble the revert reason is using memory via assembly
617 
618                 assembly {
619                     let returndata_size := mload(returndata)
620                     revert(add(32, returndata), returndata_size)
621                 }
622             } else {
623                 revert(errorMessage);
624             }
625         }
626     }
627 }
628 
629 // File: @openzeppelin/contracts/utils/Context.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 /**
637  * @dev Provides information about the current execution context, including the
638  * sender of the transaction and its data. While these are generally available
639  * via msg.sender and msg.data, they should not be accessed in such a direct
640  * manner, since when dealing with meta-transactions the account sending and
641  * paying for execution may not be the actual sender (as far as an application
642  * is concerned).
643  *
644  * This contract is only required for intermediate, library-like contracts.
645  */
646 abstract contract Context {
647     function _msgSender() internal view virtual returns (address) {
648         return msg.sender;
649     }
650 
651     function _msgData() internal view virtual returns (bytes calldata) {
652         return msg.data;
653     }
654 }
655 
656 // File: @openzeppelin/contracts/access/Ownable.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 
664 /**
665  * @dev Contract module which provides a basic access control mechanism, where
666  * there is an account (an owner) that can be granted exclusive access to
667  * specific functions.
668  *
669  * By default, the owner account will be the one that deploys the contract. This
670  * can later be changed with {transferOwnership}.
671  *
672  * This module is used through inheritance. It will make available the modifier
673  * `onlyOwner`, which can be applied to your functions to restrict their use to
674  * the owner.
675  */
676 abstract contract Ownable is Context {
677     address private _owner;
678 
679     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
680 
681     /**
682      * @dev Initializes the contract setting the deployer as the initial owner.
683      */
684     constructor() {
685         _transferOwnership(_msgSender());
686     }
687 
688     /**
689      * @dev Returns the address of the current owner.
690      */
691     function owner() public view virtual returns (address) {
692         return _owner;
693     }
694 
695     /**
696      * @dev Throws if called by any account other than the owner.
697      */
698     modifier onlyOwner() {
699         require(owner() == _msgSender(), "Ownable: caller is not the owner");
700         _;
701     }
702 
703     /**
704      * @dev Leaves the contract without owner. It will not be possible to call
705      * `onlyOwner` functions anymore. Can only be called by the current owner.
706      *
707      * NOTE: Renouncing ownership will leave the contract without an owner,
708      * thereby removing any functionality that is only available to the owner.
709      */
710     function renounceOwnership() public virtual onlyOwner {
711         _transferOwnership(address(0));
712     }
713 
714     /**
715      * @dev Transfers ownership of the contract to a new account (`newOwner`).
716      * Can only be called by the current owner.
717      */
718     function transferOwnership(address newOwner) public virtual onlyOwner {
719         require(newOwner != address(0), "Ownable: new owner is the zero address");
720         _transferOwnership(newOwner);
721     }
722 
723     /**
724      * @dev Transfers ownership of the contract to a new account (`newOwner`).
725      * Internal function without access restriction.
726      */
727     function _transferOwnership(address newOwner) internal virtual {
728         address oldOwner = _owner;
729         _owner = newOwner;
730         emit OwnershipTransferred(oldOwner, newOwner);
731     }
732 }
733 
734 // File: contracts/eggstaking.sol
735 
736 //SPDX-License-Identifier: MIT
737 pragma solidity 0.8.7;
738 
739 /**
740  * @title BBD Staking Platform
741  * @author Decentralized Devs - Angelo
742  */
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 
753 interface IEgg {
754 	function mintFromExtentionContract(address _to, uint256 _amount) external;
755 }
756 
757 contract DinoFamEggStakingV2 is  Ownable{
758     using SafeMath for uint256;
759     bool public paused = false;
760 	IERC721 BBD;
761     IERC721 CD;
762     IEgg egg;
763 
764     uint256 public BADBAYDINO_REWARD = 1 ether;
765     uint256 public CAVEDINO_REWARD = 2 ether;
766     uint256 public BOTHSTAKED_REWARD = 10 ether;
767     uint256 public SPECIALID_REWARD = 10 ether;
768     uint256 constant public specialTokenRange = 974;
769     
770 
771     mapping(address => uint256) public lastClaimTime;
772     mapping(uint256 => address) public bbdTokenIdOwners;
773     mapping(uint256 => address) public cdTokenIdOwners;
774     //user address => []
775     mapping(address => mapping(uint256 => uint256)) public bbdOwnerTokenIds;
776     mapping(address => mapping(uint256 => uint256)) public cdOwnerTokenIds;
777 
778     mapping(address => uint256) public numberBBDStaked;
779     mapping(address => uint256) public numberCDStaked;
780     mapping(address => uint256) public numberCDSpecialStaked;
781 
782     mapping(address => uint256) public _balances;
783     mapping(address => bool) public staff;
784     
785   
786    
787     modifier onlyAllowedContracts {
788         require(staff[msg.sender] || msg.sender == owner());
789         _;
790     }
791 
792      modifier updateReward(address account) {
793         uint256 reward = getRewards(account);
794         lastClaimTime[account] = block.timestamp;
795         _balances[account] += reward;
796         _;
797     }
798 
799 
800     constructor(address _badBabyDinosNFtAddress, address _caveDinosAddress, address _tokenAddress){
801 		
802 		BBD = IERC721(_badBabyDinosNFtAddress);
803         CD = IERC721(_caveDinosAddress);
804         egg = IEgg(_tokenAddress);
805 
806 	}
807 
808     
809 
810     function getTotalNumberStaked(address user) internal view returns (uint256){
811         uint256 a = numberBBDStaked[user];
812         uint256 b = numberCDStaked[user]; 
813         uint256 c = numberCDSpecialStaked[user];
814 
815         if(a != 0 && b !=0 && c != 0){
816         return a + b+ b;
817         }else{
818             return 0;
819         }
820         
821     }
822 
823    
824 
825     function setTokenAddress(address _val) public onlyOwner{
826         egg = IEgg(_val);
827     }
828 
829     
830 
831      function setNftAddress(bool _isBBD, address _val) public onlyOwner{
832        if(_isBBD){
833            BBD = IERC721(_val);
834        
835        }else{
836             CD = IERC721(_val);
837        }
838     }
839 
840     
841 
842     function setRewards(bool isBBD, uint256 _amount) public onlyOwner{
843         if(isBBD){
844                 BADBAYDINO_REWARD = _amount;
845         }else {
846             CAVEDINO_REWARD = _amount;
847            }
848     }
849 
850     function _mint(address user, uint256 amount) internal {
851         egg.mintFromExtentionContract(user,amount);
852     }
853 
854      function claimRewards() updateReward(msg.sender) external {
855         uint256 reward = _balances[msg.sender];
856         _balances[msg.sender] = 0;
857         _mint(msg.sender, reward);
858     } 
859 
860 
861      function stakeBBD(uint256[] calldata tokenIds) updateReward(msg.sender) external {
862         unchecked {
863             uint256 len = tokenIds.length;
864             uint256 badbabydinoCount = numberBBDStaked[msg.sender];
865             
866             for (uint256 i = 0; i < len; i++) {
867                 uint256 tokenId = tokenIds[i];
868                 bbdTokenIdOwners[tokenId] = msg.sender;
869                 bbdOwnerTokenIds[msg.sender][badbabydinoCount] = tokenId;
870                 badbabydinoCount++;
871                 BBD.transferFrom(msg.sender,address(this),tokenId);
872             }
873            numberBBDStaked[msg.sender] = badbabydinoCount;
874         }
875     }
876 
877 
878      function stakeCaveDino(uint256[] calldata tokenIds ) updateReward(msg.sender) external {
879         unchecked {
880             uint256 len = tokenIds.length;
881             uint256 caveDinoCount = numberCDStaked[msg.sender];
882             uint256 caveDinoSpecialCount = numberCDSpecialStaked[msg.sender];
883             for (uint256 i = 0; i < len; i++) {
884                 uint256 tokenId = tokenIds[i];
885                 cdTokenIdOwners[tokenId] = msg.sender;
886                 cdOwnerTokenIds[msg.sender][(caveDinoSpecialCount+caveDinoCount)] = tokenId;
887                     //check if special id or not 
888                     if(tokenId >= 0  && tokenId <= specialTokenRange){
889                          caveDinoSpecialCount++;
890                     }else{
891                           caveDinoCount++;
892                     }
893                 CD.transferFrom(msg.sender,address(this),tokenId);
894             }
895             //update counters 
896            if(caveDinoCount > 0) { numberCDStaked[msg.sender] = caveDinoCount;}
897            if(caveDinoSpecialCount > 0) {numberCDSpecialStaked[msg.sender] = caveDinoSpecialCount;}
898         }
899     }
900 
901       function unstakeBBD(uint256[] calldata tokenIds) updateReward(msg.sender) external {
902             uint256 len = tokenIds.length;
903             uint256 badbabydinoCount = numberBBDStaked[msg.sender];
904            
905 
906             for (uint256 i = 0; i < len; i++) {
907                uint256 tokenId = tokenIds[i];
908                delete bbdTokenIdOwners[tokenId];
909                     removeFromUserStakedTokens(true,msg.sender, tokenId);
910                     unchecked {
911                         badbabydinoCount--;
912                     }
913                     BBD.transferFrom(
914                                 address(this),
915                                 msg.sender,
916                                 tokenId
917                             );   
918             }
919              numberBBDStaked[msg.sender] = badbabydinoCount; 
920     }
921 
922 
923     function unstakeCaveDino(uint256[] calldata tokenIds) updateReward(msg.sender) external {
924             uint256 len = tokenIds.length;
925             uint256 caveDinoCount = numberCDStaked[msg.sender];
926             uint256 caveDinoSpecialCount = numberCDSpecialStaked[msg.sender];
927 
928             for (uint256 i = 0; i < len; i++) {
929                uint256 tokenId = tokenIds[i];
930             
931                     delete cdTokenIdOwners[tokenId];
932                     removeFromUserStakedTokens(false,msg.sender, tokenId);
933                     CD.transferFrom(
934                             address(this),
935                             msg.sender,
936                             tokenId
937                         );
938                     if( tokenId <= specialTokenRange){
939                        unchecked {
940                             caveDinoSpecialCount--;
941                        }
942                     }else{
943                         unchecked {
944                              caveDinoCount--;
945                         }
946                     }  
947             }
948             if(caveDinoCount > 0) { numberCDStaked[msg.sender] = caveDinoCount;}
949             if(caveDinoSpecialCount > 0) {numberCDSpecialStaked[msg.sender] = caveDinoSpecialCount;}
950     }
951     	
952 function removeFromUserStakedTokens(bool isBBD, address user, uint256 tokenId) internal {
953             if(isBBD){
954                 uint256 bbdCount = numberBBDStaked[user];
955                 for (uint256 j = 0; j < bbdCount; ++j) {
956                 if (bbdOwnerTokenIds[user][j] == tokenId) {
957                     uint256 lastIndex = bbdCount - 1;
958                     bbdOwnerTokenIds[user][j] = bbdOwnerTokenIds[user][
959                         lastIndex
960                     ];
961                     delete bbdOwnerTokenIds[user][lastIndex];
962                     break;
963                 }
964             }
965             }else{
966                 uint256 count = numberCDSpecialStaked[user] + numberCDStaked[user];
967                 for (uint256 j = 0; j < count; ++j) {
968                 if (cdOwnerTokenIds[user][j] == tokenId) {
969                     uint256 lastIndex = count - 1;
970                     cdOwnerTokenIds[user][j] = cdOwnerTokenIds[user][
971                         lastIndex
972                     ];
973                     delete cdOwnerTokenIds[user][lastIndex];
974                     break;
975                 }
976             }
977 
978             }
979         
980     }
981    
982 
983    
984 
985    
986 
987     function getUserstakedIdsBBD(address _user) public view returns (uint256[] memory){
988         uint256 len =numberBBDStaked[_user];
989         uint256[] memory temp = new uint[](len);
990         for (uint256 i = 0; i < len; ++i) {
991              temp[i] = bbdOwnerTokenIds[_user][i];
992         }
993         return temp;
994     }
995 
996     function getUserstakedIdsCD(address _user) public view returns (uint256[] memory){
997         uint256 len = numberCDStaked[_user] + numberCDSpecialStaked[_user];
998         uint256[] memory temp = new uint[](len);
999         for (uint256 i = 0; i < len; ++i) {
1000              temp[i] = cdOwnerTokenIds[_user][i];
1001         }
1002         return temp;
1003     }
1004 
1005 
1006    
1007     
1008   function setSpecialIdReward(uint256 _val) public onlyOwner{
1009         SPECIALID_REWARD = _val;
1010     }
1011 
1012     function setBothStakedReward(uint256 _val) public onlyOwner{
1013         BOTHSTAKED_REWARD = _val;
1014     }
1015 
1016     function getRewardValue(address user)
1017         public
1018         view
1019         returns (
1020             uint256
1021         )
1022     {
1023        
1024         uint256 babyBabyDinoCount = numberBBDStaked[user];
1025         uint256 specialIdCount = numberCDSpecialStaked[user];
1026         uint256 caveDinoCount = numberCDStaked[user] + specialIdCount;
1027         
1028          //logic
1029             if (babyBabyDinoCount >= caveDinoCount) {
1030                 uint256 bal = babyBabyDinoCount - caveDinoCount;
1031                 if ((bal) == 0) {
1032                    
1033                     return calculateCombincationRewards(0, 0, babyBabyDinoCount, specialIdCount);
1034                 } else {
1035                       return calculateCombincationRewards(bal, 0, caveDinoCount, specialIdCount);
1036                 }
1037             } else {
1038                 
1039                 uint256 bal = caveDinoCount - babyBabyDinoCount;
1040                 if ((bal) == 0) {
1041                     return calculateCombincationRewards(0, 0, caveDinoCount, specialIdCount);
1042                 } 
1043                 else if(bal == caveDinoCount){
1044                  
1045                     return calculateCombincationRewards(0, caveDinoCount, 0, specialIdCount);
1046                 }
1047                 else {
1048                       return calculateCombincationRewards(0, bal, babyBabyDinoCount, specialIdCount);
1049                 }
1050             } 
1051     }
1052 
1053      function getRewards(address account) internal view returns(uint256) {
1054             uint256 _cReward = getRewardValue(account);
1055             uint256 _lastClaimed = lastClaimTime[account];
1056             return _cReward.mul(block.timestamp.sub(_lastClaimed)).div(86400);
1057     }
1058 
1059     function viewPendingRewards(address account) public view returns(uint256){
1060             uint256 creward = getRewards(account);
1061             return creward + _balances[account];
1062     }
1063 
1064      function calculateCombincationRewards(uint256 badbabycount, uint256 cavedinocount, uint256 pairs, uint256 specials) internal view returns (uint256){
1065             unchecked{
1066                  if(specials > 0 ){
1067                    if(specials >= cavedinocount){
1068                         if(pairs == 0){
1069                               return (badbabycount * BADBAYDINO_REWARD) + (pairs * BOTHSTAKED_REWARD) + (cavedinocount * SPECIALID_REWARD);
1070                         }else{
1071                               return (badbabycount * BADBAYDINO_REWARD) + (pairs * BOTHSTAKED_REWARD) + (specials * SPECIALID_REWARD);
1072                         }
1073                    }else{
1074                          uint a = cavedinocount - specials;
1075                          return (badbabycount * BADBAYDINO_REWARD) + (a * CAVEDINO_REWARD) +  (pairs * BOTHSTAKED_REWARD) + (specials * SPECIALID_REWARD);
1076                     }
1077                     }else{
1078                             return (badbabycount * BADBAYDINO_REWARD) + (cavedinocount * CAVEDINO_REWARD) +  (pairs * BOTHSTAKED_REWARD);
1079                     }
1080             }
1081             }
1082 
1083 
1084             function overideTranser(address _user, uint256 _id, bool isBBDContract) public onlyOwner{
1085          if(isBBDContract){
1086              BBD.transferFrom(
1087             address(this),
1088             _user,
1089             _id
1090         );
1091          }else{
1092                CD.transferFrom(
1093             address(this),
1094             _user,
1095             _id
1096         );
1097          }
1098     }
1099 }