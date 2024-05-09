1 //SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 pragma experimental ABIEncoderV2;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(
95             newOwner != address(0),
96             "Ownable: new owner is the zero address"
97         );
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/math/SafeMath.sol
104 
105 pragma solidity >=0.6.0 <0.8.0;
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
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
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(
163         uint256 a,
164         uint256 b,
165         string memory errorMessage
166     ) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(
266         uint256 a,
267         uint256 b,
268         string memory errorMessage
269     ) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Counters.sol
276 
277 pragma solidity >=0.6.0 <0.8.0;
278 
279 /**
280  * @title Counters
281  * @author Matt Condon (@shrugs)
282  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
283  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
284  *
285  * Include with `using Counters for Counters.Counter;`
286  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
287  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
288  * directly accessed.
289  */
290 library Counters {
291     using SafeMath for uint256;
292 
293     struct Counter {
294         // This variable should never be directly accessed by users of the library: interactions must be restricted to
295         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
296         // this feature: see https://github.com/ethereum/solidity/issues/4637
297         uint256 _value; // default: 0
298     }
299 
300     function current(Counter storage counter) internal view returns (uint256) {
301         return counter._value;
302     }
303 
304     function increment(Counter storage counter) internal {
305         // The {SafeMath} overflow check can be skipped here, see the comment at the top
306         counter._value += 1;
307     }
308 
309     function decrement(Counter storage counter) internal {
310         counter._value = counter._value.sub(1);
311     }
312 }
313 
314 // File: @openzeppelin/contracts/introspection/IERC165.sol
315 
316 pragma solidity >=0.6.0 <0.8.0;
317 
318 /**
319  * @dev Interface of the ERC165 standard, as defined in the
320  * https://eips.ethereum.org/EIPS/eip-165[EIP].
321  *
322  * Implementers can declare support of contract interfaces, which can then be
323  * queried by others ({ERC165Checker}).
324  *
325  * For an implementation, see {ERC165}.
326  */
327 interface IERC165 {
328     /**
329      * @dev Returns true if this contract implements the interface defined by
330      * `interfaceId`. See the corresponding
331      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
332      * to learn more about how these ids are created.
333      *
334      * This function call must use less than 30 000 gas.
335      */
336     function supportsInterface(bytes4 interfaceId) external view returns (bool);
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
340 
341 pragma solidity >=0.6.2 <0.8.0;
342 
343 /**
344  * @dev Required interface of an ERC721 compliant contract.
345  */
346 interface IERC721 is IERC165 {
347     /**
348      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
349      */
350     event Transfer(
351         address indexed from,
352         address indexed to,
353         uint256 indexed tokenId
354     );
355 
356     /**
357      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
358      */
359     event Approval(
360         address indexed owner,
361         address indexed approved,
362         uint256 indexed tokenId
363     );
364 
365     /**
366      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
367      */
368     event ApprovalForAll(
369         address indexed owner,
370         address indexed operator,
371         bool approved
372     );
373 
374     /**
375      * @dev Returns the number of tokens in ``owner``'s account.
376      */
377     function balanceOf(address owner) external view returns (uint256 balance);
378 
379     /**
380      * @dev Returns the owner of the `tokenId` token.
381      *
382      * Requirements:
383      *
384      * - `tokenId` must exist.
385      */
386     function ownerOf(uint256 tokenId) external view returns (address owner);
387 
388     /**
389      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
390      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
391      *
392      * Requirements:
393      *
394      * - `from` cannot be the zero address.
395      * - `to` cannot be the zero address.
396      * - `tokenId` token must exist and be owned by `from`.
397      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
398      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
399      *
400      * Emits a {Transfer} event.
401      */
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) external;
407 
408     /**
409      * @dev Transfers `tokenId` token from `from` to `to`.
410      *
411      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
412      *
413      * Requirements:
414      *
415      * - `from` cannot be the zero address.
416      * - `to` cannot be the zero address.
417      * - `tokenId` token must be owned by `from`.
418      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
419      *
420      * Emits a {Transfer} event.
421      */
422     function transferFrom(
423         address from,
424         address to,
425         uint256 tokenId
426     ) external;
427 
428     /**
429      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
430      * The approval is cleared when the token is transferred.
431      *
432      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
433      *
434      * Requirements:
435      *
436      * - The caller must own the token or be an approved operator.
437      * - `tokenId` must exist.
438      *
439      * Emits an {Approval} event.
440      */
441     function approve(address to, uint256 tokenId) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId)
451         external
452         view
453         returns (address operator);
454 
455     /**
456      * @dev Approve or remove `operator` as an operator for the caller.
457      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
458      *
459      * Requirements:
460      *
461      * - The `operator` cannot be the caller.
462      *
463      * Emits an {ApprovalForAll} event.
464      */
465     function setApprovalForAll(address operator, bool _approved) external;
466 
467     /**
468      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
469      *
470      * See {setApprovalForAll}
471      */
472     function isApprovedForAll(address owner, address operator)
473         external
474         view
475         returns (bool);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId,
494         bytes calldata data
495     ) external;
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
499 
500 pragma solidity >=0.6.2 <0.8.0;
501 
502 /**
503  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
504  * @dev See https://eips.ethereum.org/EIPS/eip-721
505  */
506 interface IERC721Metadata is IERC721 {
507     /**
508      * @dev Returns the token collection name.
509      */
510     function name() external view returns (string memory);
511 
512     /**
513      * @dev Returns the token collection symbol.
514      */
515     function symbol() external view returns (string memory);
516 
517     /**
518      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
519      */
520     function tokenURI(uint256 tokenId) external view returns (string memory);
521 }
522 
523 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
524 
525 pragma solidity >=0.6.2 <0.8.0;
526 
527 /**
528  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
529  * @dev See https://eips.ethereum.org/EIPS/eip-721
530  */
531 interface IERC721Enumerable is IERC721 {
532     /**
533      * @dev Returns the total amount of tokens stored by the contract.
534      */
535     function totalSupply() external view returns (uint256);
536 
537     /**
538      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
539      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
540      */
541     function tokenOfOwnerByIndex(address owner, uint256 index)
542         external
543         view
544         returns (uint256 tokenId);
545 
546     /**
547      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
548      * Use along with {totalSupply} to enumerate all tokens.
549      */
550     function tokenByIndex(uint256 index) external view returns (uint256);
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
554 
555 pragma solidity >=0.6.0 <0.8.0;
556 
557 /**
558  * @title ERC721 token receiver interface
559  * @dev Interface for any contract that wants to support safeTransfers
560  * from ERC721 asset contracts.
561  */
562 interface IERC721Receiver {
563     /**
564      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
565      * by `operator` from `from`, this function is called.
566      *
567      * It must return its Solidity selector to confirm the token transfer.
568      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
569      *
570      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
571      */
572     function onERC721Received(
573         address operator,
574         address from,
575         uint256 tokenId,
576         bytes calldata data
577     ) external returns (bytes4);
578 }
579 
580 // File: @openzeppelin/contracts/introspection/ERC165.sol
581 
582 pragma solidity >=0.6.0 <0.8.0;
583 
584 /**
585  * @dev Implementation of the {IERC165} interface.
586  *
587  * Contracts may inherit from this and call {_registerInterface} to declare
588  * their support of an interface.
589  */
590 abstract contract ERC165 is IERC165 {
591     /*
592      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
593      */
594     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
595 
596     /**
597      * @dev Mapping of interface ids to whether or not it's supported.
598      */
599     mapping(bytes4 => bool) private _supportedInterfaces;
600 
601     constructor() internal {
602         // Derived contracts need only register support for their own interfaces,
603         // we register support for ERC165 itself here
604         _registerInterface(_INTERFACE_ID_ERC165);
605     }
606 
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      *
610      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
611      */
612     function supportsInterface(bytes4 interfaceId)
613         public
614         view
615         override
616         returns (bool)
617     {
618         return _supportedInterfaces[interfaceId];
619     }
620 
621     /**
622      * @dev Registers the contract as an implementer of the interface defined by
623      * `interfaceId`. Support of the actual ERC165 interface is automatic and
624      * registering its interface id is not required.
625      *
626      * See {IERC165-supportsInterface}.
627      *
628      * Requirements:
629      *
630      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
631      */
632     function _registerInterface(bytes4 interfaceId) internal virtual {
633         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
634         _supportedInterfaces[interfaceId] = true;
635     }
636 }
637 
638 // File: @openzeppelin/contracts/utils/Address.sol
639 
640 pragma solidity >=0.6.2 <0.8.0;
641 
642 /**
643  * @dev Collection of functions related to the address type
644  */
645 library Address {
646     /**
647      * @dev Returns true if `account` is a contract.
648      *
649      * [IMPORTANT]
650      * ====
651      * It is unsafe to assume that an address for which this function returns
652      * false is an externally-owned account (EOA) and not a contract.
653      *
654      * Among others, `isContract` will return false for the following
655      * types of addresses:
656      *
657      *  - an externally-owned account
658      *  - a contract in construction
659      *  - an address where a contract will be created
660      *  - an address where a contract lived, but was destroyed
661      * ====
662      */
663     function isContract(address account) internal view returns (bool) {
664         // This method relies on extcodesize, which returns 0 for contracts in
665         // construction, since the code is only stored at the end of the
666         // constructor execution.
667 
668         uint256 size;
669         // solhint-disable-next-line no-inline-assembly
670         assembly {
671             size := extcodesize(account)
672         }
673         return size > 0;
674     }
675 
676     /**
677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
678      * `recipient`, forwarding all available gas and reverting on errors.
679      *
680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
682      * imposed by `transfer`, making them unable to receive funds via
683      * `transfer`. {sendValue} removes this limitation.
684      *
685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
686      *
687      * IMPORTANT: because control is transferred to `recipient`, care must be
688      * taken to not create reentrancy vulnerabilities. Consider using
689      * {ReentrancyGuard} or the
690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
691      */
692     function sendValue(address payable recipient, uint256 amount) internal {
693         require(
694             address(this).balance >= amount,
695             "Address: insufficient balance"
696         );
697 
698         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
699         (bool success, ) = recipient.call{value: amount}("");
700         require(
701             success,
702             "Address: unable to send value, recipient may have reverted"
703         );
704     }
705 
706     /**
707      * @dev Performs a Solidity function call using a low level `call`. A
708      * plain`call` is an unsafe replacement for a function call: use this
709      * function instead.
710      *
711      * If `target` reverts with a revert reason, it is bubbled up by this
712      * function (like regular Solidity function calls).
713      *
714      * Returns the raw returned data. To convert to the expected return value,
715      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
716      *
717      * Requirements:
718      *
719      * - `target` must be a contract.
720      * - calling `target` with `data` must not revert.
721      *
722      * _Available since v3.1._
723      */
724     function functionCall(address target, bytes memory data)
725         internal
726         returns (bytes memory)
727     {
728         return functionCall(target, data, "Address: low-level call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
733      * `errorMessage` as a fallback revert reason when `target` reverts.
734      *
735      * _Available since v3.1._
736      */
737     function functionCall(
738         address target,
739         bytes memory data,
740         string memory errorMessage
741     ) internal returns (bytes memory) {
742         return functionCallWithValue(target, data, 0, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but also transferring `value` wei to `target`.
748      *
749      * Requirements:
750      *
751      * - the calling contract must have an ETH balance of at least `value`.
752      * - the called Solidity function must be `payable`.
753      *
754      * _Available since v3.1._
755      */
756     function functionCallWithValue(
757         address target,
758         bytes memory data,
759         uint256 value
760     ) internal returns (bytes memory) {
761         return
762             functionCallWithValue(
763                 target,
764                 data,
765                 value,
766                 "Address: low-level call with value failed"
767             );
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
772      * with `errorMessage` as a fallback revert reason when `target` reverts.
773      *
774      * _Available since v3.1._
775      */
776     function functionCallWithValue(
777         address target,
778         bytes memory data,
779         uint256 value,
780         string memory errorMessage
781     ) internal returns (bytes memory) {
782         require(
783             address(this).balance >= value,
784             "Address: insufficient balance for call"
785         );
786         require(isContract(target), "Address: call to non-contract");
787 
788         // solhint-disable-next-line avoid-low-level-calls
789         (bool success, bytes memory returndata) = target.call{value: value}(
790             data
791         );
792         return _verifyCallResult(success, returndata, errorMessage);
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
797      * but performing a static call.
798      *
799      * _Available since v3.3._
800      */
801     function functionStaticCall(address target, bytes memory data)
802         internal
803         view
804         returns (bytes memory)
805     {
806         return
807             functionStaticCall(
808                 target,
809                 data,
810                 "Address: low-level static call failed"
811             );
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
816      * but performing a static call.
817      *
818      * _Available since v3.3._
819      */
820     function functionStaticCall(
821         address target,
822         bytes memory data,
823         string memory errorMessage
824     ) internal view returns (bytes memory) {
825         require(isContract(target), "Address: static call to non-contract");
826 
827         // solhint-disable-next-line avoid-low-level-calls
828         (bool success, bytes memory returndata) = target.staticcall(data);
829         return _verifyCallResult(success, returndata, errorMessage);
830     }
831 
832     function _verifyCallResult(
833         bool success,
834         bytes memory returndata,
835         string memory errorMessage
836     ) private pure returns (bytes memory) {
837         if (success) {
838             return returndata;
839         } else {
840             // Look for revert reason and bubble it up if present
841             if (returndata.length > 0) {
842                 // The easiest way to bubble the revert reason is using memory via assembly
843 
844                 // solhint-disable-next-line no-inline-assembly
845                 assembly {
846                     let returndata_size := mload(returndata)
847                     revert(add(32, returndata), returndata_size)
848                 }
849             } else {
850                 revert(errorMessage);
851             }
852         }
853     }
854 }
855 
856 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
857 
858 pragma solidity >=0.6.0 <0.8.0;
859 
860 /**
861  * @dev Library for managing
862  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
863  * types.
864  *
865  * Sets have the following properties:
866  *
867  * - Elements are added, removed, and checked for existence in constant time
868  * (O(1)).
869  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
870  *
871  * ```
872  * contract Example {
873  *     // Add the library methods
874  *     using EnumerableSet for EnumerableSet.AddressSet;
875  *
876  *     // Declare a set state variable
877  *     EnumerableSet.AddressSet private mySet;
878  * }
879  * ```
880  *
881  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
882  * and `uint256` (`UintSet`) are supported.
883  */
884 library EnumerableSet {
885     // To implement this library for multiple types with as little code
886     // repetition as possible, we write it in terms of a generic Set type with
887     // bytes32 values.
888     // The Set implementation uses private functions, and user-facing
889     // implementations (such as AddressSet) are just wrappers around the
890     // underlying Set.
891     // This means that we can only create new EnumerableSets for types that fit
892     // in bytes32.
893 
894     struct Set {
895         // Storage of set values
896         bytes32[] _values;
897         // Position of the value in the `values` array, plus 1 because index 0
898         // means a value is not in the set.
899         mapping(bytes32 => uint256) _indexes;
900     }
901 
902     /**
903      * @dev Add a value to a set. O(1).
904      *
905      * Returns true if the value was added to the set, that is if it was not
906      * already present.
907      */
908     function _add(Set storage set, bytes32 value) private returns (bool) {
909         if (!_contains(set, value)) {
910             set._values.push(value);
911             // The value is stored at length-1, but we add 1 to all indexes
912             // and use 0 as a sentinel value
913             set._indexes[value] = set._values.length;
914             return true;
915         } else {
916             return false;
917         }
918     }
919 
920     /**
921      * @dev Removes a value from a set. O(1).
922      *
923      * Returns true if the value was removed from the set, that is if it was
924      * present.
925      */
926     function _remove(Set storage set, bytes32 value) private returns (bool) {
927         // We read and store the value's index to prevent multiple reads from the same storage slot
928         uint256 valueIndex = set._indexes[value];
929 
930         if (valueIndex != 0) {
931             // Equivalent to contains(set, value)
932             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
933             // the array, and then remove the last element (sometimes called as 'swap and pop').
934             // This modifies the order of the array, as noted in {at}.
935 
936             uint256 toDeleteIndex = valueIndex - 1;
937             uint256 lastIndex = set._values.length - 1;
938 
939             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
940             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
941 
942             bytes32 lastvalue = set._values[lastIndex];
943 
944             // Move the last value to the index where the value to delete is
945             set._values[toDeleteIndex] = lastvalue;
946             // Update the index for the moved value
947             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
948 
949             // Delete the slot where the moved value was stored
950             set._values.pop();
951 
952             // Delete the index for the deleted slot
953             delete set._indexes[value];
954 
955             return true;
956         } else {
957             return false;
958         }
959     }
960 
961     /**
962      * @dev Returns true if the value is in the set. O(1).
963      */
964     function _contains(Set storage set, bytes32 value)
965         private
966         view
967         returns (bool)
968     {
969         return set._indexes[value] != 0;
970     }
971 
972     /**
973      * @dev Returns the number of values on the set. O(1).
974      */
975     function _length(Set storage set) private view returns (uint256) {
976         return set._values.length;
977     }
978 
979     /**
980      * @dev Returns the value stored at position `index` in the set. O(1).
981      *
982      * Note that there are no guarantees on the ordering of values inside the
983      * array, and it may change when more values are added or removed.
984      *
985      * Requirements:
986      *
987      * - `index` must be strictly less than {length}.
988      */
989     function _at(Set storage set, uint256 index)
990         private
991         view
992         returns (bytes32)
993     {
994         require(
995             set._values.length > index,
996             "EnumerableSet: index out of bounds"
997         );
998         return set._values[index];
999     }
1000 
1001     // Bytes32Set
1002 
1003     struct Bytes32Set {
1004         Set _inner;
1005     }
1006 
1007     /**
1008      * @dev Add a value to a set. O(1).
1009      *
1010      * Returns true if the value was added to the set, that is if it was not
1011      * already present.
1012      */
1013     function add(Bytes32Set storage set, bytes32 value)
1014         internal
1015         returns (bool)
1016     {
1017         return _add(set._inner, value);
1018     }
1019 
1020     /**
1021      * @dev Removes a value from a set. O(1).
1022      *
1023      * Returns true if the value was removed from the set, that is if it was
1024      * present.
1025      */
1026     function remove(Bytes32Set storage set, bytes32 value)
1027         internal
1028         returns (bool)
1029     {
1030         return _remove(set._inner, value);
1031     }
1032 
1033     /**
1034      * @dev Returns true if the value is in the set. O(1).
1035      */
1036     function contains(Bytes32Set storage set, bytes32 value)
1037         internal
1038         view
1039         returns (bool)
1040     {
1041         return _contains(set._inner, value);
1042     }
1043 
1044     /**
1045      * @dev Returns the number of values in the set. O(1).
1046      */
1047     function length(Bytes32Set storage set) internal view returns (uint256) {
1048         return _length(set._inner);
1049     }
1050 
1051     /**
1052      * @dev Returns the value stored at position `index` in the set. O(1).
1053      *
1054      * Note that there are no guarantees on the ordering of values inside the
1055      * array, and it may change when more values are added or removed.
1056      *
1057      * Requirements:
1058      *
1059      * - `index` must be strictly less than {length}.
1060      */
1061     function at(Bytes32Set storage set, uint256 index)
1062         internal
1063         view
1064         returns (bytes32)
1065     {
1066         return _at(set._inner, index);
1067     }
1068 
1069     // AddressSet
1070 
1071     struct AddressSet {
1072         Set _inner;
1073     }
1074 
1075     /**
1076      * @dev Add a value to a set. O(1).
1077      *
1078      * Returns true if the value was added to the set, that is if it was not
1079      * already present.
1080      */
1081     function add(AddressSet storage set, address value)
1082         internal
1083         returns (bool)
1084     {
1085         return _add(set._inner, bytes32(uint256(value)));
1086     }
1087 
1088     /**
1089      * @dev Removes a value from a set. O(1).
1090      *
1091      * Returns true if the value was removed from the set, that is if it was
1092      * present.
1093      */
1094     function remove(AddressSet storage set, address value)
1095         internal
1096         returns (bool)
1097     {
1098         return _remove(set._inner, bytes32(uint256(value)));
1099     }
1100 
1101     /**
1102      * @dev Returns true if the value is in the set. O(1).
1103      */
1104     function contains(AddressSet storage set, address value)
1105         internal
1106         view
1107         returns (bool)
1108     {
1109         return _contains(set._inner, bytes32(uint256(value)));
1110     }
1111 
1112     /**
1113      * @dev Returns the number of values in the set. O(1).
1114      */
1115     function length(AddressSet storage set) internal view returns (uint256) {
1116         return _length(set._inner);
1117     }
1118 
1119     /**
1120      * @dev Returns the value stored at position `index` in the set. O(1).
1121      *
1122      * Note that there are no guarantees on the ordering of values inside the
1123      * array, and it may change when more values are added or removed.
1124      *
1125      * Requirements:
1126      *
1127      * - `index` must be strictly less than {length}.
1128      */
1129     function at(AddressSet storage set, uint256 index)
1130         internal
1131         view
1132         returns (address)
1133     {
1134         return address(uint256(_at(set._inner, index)));
1135     }
1136 
1137     // UintSet
1138 
1139     struct UintSet {
1140         Set _inner;
1141     }
1142 
1143     /**
1144      * @dev Add a value to a set. O(1).
1145      *
1146      * Returns true if the value was added to the set, that is if it was not
1147      * already present.
1148      */
1149     function add(UintSet storage set, uint256 value) internal returns (bool) {
1150         return _add(set._inner, bytes32(value));
1151     }
1152 
1153     /**
1154      * @dev Removes a value from a set. O(1).
1155      *
1156      * Returns true if the value was removed from the set, that is if it was
1157      * present.
1158      */
1159     function remove(UintSet storage set, uint256 value)
1160         internal
1161         returns (bool)
1162     {
1163         return _remove(set._inner, bytes32(value));
1164     }
1165 
1166     /**
1167      * @dev Returns true if the value is in the set. O(1).
1168      */
1169     function contains(UintSet storage set, uint256 value)
1170         internal
1171         view
1172         returns (bool)
1173     {
1174         return _contains(set._inner, bytes32(value));
1175     }
1176 
1177     /**
1178      * @dev Returns the number of values on the set. O(1).
1179      */
1180     function length(UintSet storage set) internal view returns (uint256) {
1181         return _length(set._inner);
1182     }
1183 
1184     /**
1185      * @dev Returns the value stored at position `index` in the set. O(1).
1186      *
1187      * Note that there are no guarantees on the ordering of values inside the
1188      * array, and it may change when more values are added or removed.
1189      *
1190      * Requirements:
1191      *
1192      * - `index` must be strictly less than {length}.
1193      */
1194     function at(UintSet storage set, uint256 index)
1195         internal
1196         view
1197         returns (uint256)
1198     {
1199         return uint256(_at(set._inner, index));
1200     }
1201 }
1202 
1203 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1204 
1205 pragma solidity >=0.6.0 <0.8.0;
1206 
1207 /**
1208  * @dev Library for managing an enumerable variant of Solidity's
1209  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1210  * type.
1211  *
1212  * Maps have the following properties:
1213  *
1214  * - Entries are added, removed, and checked for existence in constant time
1215  * (O(1)).
1216  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1217  *
1218  * ```
1219  * contract Example {
1220  *     // Add the library methods
1221  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1222  *
1223  *     // Declare a set state variable
1224  *     EnumerableMap.UintToAddressMap private myMap;
1225  * }
1226  * ```
1227  *
1228  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1229  * supported.
1230  */
1231 library EnumerableMap {
1232     // To implement this library for multiple types with as little code
1233     // repetition as possible, we write it in terms of a generic Map type with
1234     // bytes32 keys and values.
1235     // The Map implementation uses private functions, and user-facing
1236     // implementations (such as Uint256ToAddressMap) are just wrappers around
1237     // the underlying Map.
1238     // This means that we can only create new EnumerableMaps for types that fit
1239     // in bytes32.
1240 
1241     struct MapEntry {
1242         bytes32 _key;
1243         bytes32 _value;
1244     }
1245 
1246     struct Map {
1247         // Storage of map keys and values
1248         MapEntry[] _entries;
1249         // Position of the entry defined by a key in the `entries` array, plus 1
1250         // because index 0 means a key is not in the map.
1251         mapping(bytes32 => uint256) _indexes;
1252     }
1253 
1254     /**
1255      * @dev Adds a key-value pair to a map, or updates the value for an existing
1256      * key. O(1).
1257      *
1258      * Returns true if the key was added to the map, that is if it was not
1259      * already present.
1260      */
1261     function _set(
1262         Map storage map,
1263         bytes32 key,
1264         bytes32 value
1265     ) private returns (bool) {
1266         // We read and store the key's index to prevent multiple reads from the same storage slot
1267         uint256 keyIndex = map._indexes[key];
1268 
1269         if (keyIndex == 0) {
1270             // Equivalent to !contains(map, key)
1271             map._entries.push(MapEntry({_key: key, _value: value}));
1272             // The entry is stored at length-1, but we add 1 to all indexes
1273             // and use 0 as a sentinel value
1274             map._indexes[key] = map._entries.length;
1275             return true;
1276         } else {
1277             map._entries[keyIndex - 1]._value = value;
1278             return false;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Removes a key-value pair from a map. O(1).
1284      *
1285      * Returns true if the key was removed from the map, that is if it was present.
1286      */
1287     function _remove(Map storage map, bytes32 key) private returns (bool) {
1288         // We read and store the key's index to prevent multiple reads from the same storage slot
1289         uint256 keyIndex = map._indexes[key];
1290 
1291         if (keyIndex != 0) {
1292             // Equivalent to contains(map, key)
1293             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1294             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1295             // This modifies the order of the array, as noted in {at}.
1296 
1297             uint256 toDeleteIndex = keyIndex - 1;
1298             uint256 lastIndex = map._entries.length - 1;
1299 
1300             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1301             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1302 
1303             MapEntry storage lastEntry = map._entries[lastIndex];
1304 
1305             // Move the last entry to the index where the entry to delete is
1306             map._entries[toDeleteIndex] = lastEntry;
1307             // Update the index for the moved entry
1308             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1309 
1310             // Delete the slot where the moved entry was stored
1311             map._entries.pop();
1312 
1313             // Delete the index for the deleted slot
1314             delete map._indexes[key];
1315 
1316             return true;
1317         } else {
1318             return false;
1319         }
1320     }
1321 
1322     /**
1323      * @dev Returns true if the key is in the map. O(1).
1324      */
1325     function _contains(Map storage map, bytes32 key)
1326         private
1327         view
1328         returns (bool)
1329     {
1330         return map._indexes[key] != 0;
1331     }
1332 
1333     /**
1334      * @dev Returns the number of key-value pairs in the map. O(1).
1335      */
1336     function _length(Map storage map) private view returns (uint256) {
1337         return map._entries.length;
1338     }
1339 
1340     /**
1341      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1342      *
1343      * Note that there are no guarantees on the ordering of entries inside the
1344      * array, and it may change when more entries are added or removed.
1345      *
1346      * Requirements:
1347      *
1348      * - `index` must be strictly less than {length}.
1349      */
1350     function _at(Map storage map, uint256 index)
1351         private
1352         view
1353         returns (bytes32, bytes32)
1354     {
1355         require(
1356             map._entries.length > index,
1357             "EnumerableMap: index out of bounds"
1358         );
1359 
1360         MapEntry storage entry = map._entries[index];
1361         return (entry._key, entry._value);
1362     }
1363 
1364     /**
1365      * @dev Returns the value associated with `key`.  O(1).
1366      *
1367      * Requirements:
1368      *
1369      * - `key` must be in the map.
1370      */
1371     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1372         return _get(map, key, "EnumerableMap: nonexistent key");
1373     }
1374 
1375     /**
1376      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1377      */
1378     function _get(
1379         Map storage map,
1380         bytes32 key,
1381         string memory errorMessage
1382     ) private view returns (bytes32) {
1383         uint256 keyIndex = map._indexes[key];
1384         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1385         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1386     }
1387 
1388     // UintToAddressMap
1389 
1390     struct UintToAddressMap {
1391         Map _inner;
1392     }
1393 
1394     /**
1395      * @dev Adds a key-value pair to a map, or updates the value for an existing
1396      * key. O(1).
1397      *
1398      * Returns true if the key was added to the map, that is if it was not
1399      * already present.
1400      */
1401     function set(
1402         UintToAddressMap storage map,
1403         uint256 key,
1404         address value
1405     ) internal returns (bool) {
1406         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1407     }
1408 
1409     /**
1410      * @dev Removes a value from a set. O(1).
1411      *
1412      * Returns true if the key was removed from the map, that is if it was present.
1413      */
1414     function remove(UintToAddressMap storage map, uint256 key)
1415         internal
1416         returns (bool)
1417     {
1418         return _remove(map._inner, bytes32(key));
1419     }
1420 
1421     /**
1422      * @dev Returns true if the key is in the map. O(1).
1423      */
1424     function contains(UintToAddressMap storage map, uint256 key)
1425         internal
1426         view
1427         returns (bool)
1428     {
1429         return _contains(map._inner, bytes32(key));
1430     }
1431 
1432     /**
1433      * @dev Returns the number of elements in the map. O(1).
1434      */
1435     function length(UintToAddressMap storage map)
1436         internal
1437         view
1438         returns (uint256)
1439     {
1440         return _length(map._inner);
1441     }
1442 
1443     /**
1444      * @dev Returns the element stored at position `index` in the set. O(1).
1445      * Note that there are no guarantees on the ordering of values inside the
1446      * array, and it may change when more values are added or removed.
1447      *
1448      * Requirements:
1449      *
1450      * - `index` must be strictly less than {length}.
1451      */
1452     function at(UintToAddressMap storage map, uint256 index)
1453         internal
1454         view
1455         returns (uint256, address)
1456     {
1457         (bytes32 key, bytes32 value) = _at(map._inner, index);
1458         return (uint256(key), address(uint256(value)));
1459     }
1460 
1461     /**
1462      * @dev Returns the value associated with `key`.  O(1).
1463      *
1464      * Requirements:
1465      *
1466      * - `key` must be in the map.
1467      */
1468     function get(UintToAddressMap storage map, uint256 key)
1469         internal
1470         view
1471         returns (address)
1472     {
1473         return address(uint256(_get(map._inner, bytes32(key))));
1474     }
1475 
1476     /**
1477      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1478      */
1479     function get(
1480         UintToAddressMap storage map,
1481         uint256 key,
1482         string memory errorMessage
1483     ) internal view returns (address) {
1484         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1485     }
1486 }
1487 
1488 // File: @openzeppelin/contracts/utils/Strings.sol
1489 
1490 pragma solidity >=0.6.0 <0.8.0;
1491 
1492 /**
1493  * @dev String operations.
1494  */
1495 library Strings {
1496     /**
1497      * @dev Converts a `uint256` to its ASCII `string` representation.
1498      */
1499     function toString(uint256 value) internal pure returns (string memory) {
1500         // Inspired by OraclizeAPI's implementation - MIT licence
1501         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1502 
1503         if (value == 0) {
1504             return "0";
1505         }
1506         uint256 temp = value;
1507         uint256 digits;
1508         while (temp != 0) {
1509             digits++;
1510             temp /= 10;
1511         }
1512         bytes memory buffer = new bytes(digits);
1513         uint256 index = digits - 1;
1514         temp = value;
1515         while (temp != 0) {
1516             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1517             temp /= 10;
1518         }
1519         return string(buffer);
1520     }
1521 }
1522 
1523 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1524 
1525 pragma solidity >=0.6.0 <0.8.0;
1526 
1527 /**
1528  * @title ERC721 Non-Fungible Token Standard basic implementation
1529  * @dev see https://eips.ethereum.org/EIPS/eip-721
1530  */
1531 contract ERC721 is
1532     Context,
1533     ERC165,
1534     IERC721,
1535     IERC721Metadata,
1536     IERC721Enumerable
1537 {
1538     using SafeMath for uint256;
1539     using Address for address;
1540     using EnumerableSet for EnumerableSet.UintSet;
1541     using EnumerableMap for EnumerableMap.UintToAddressMap;
1542     using Strings for uint256;
1543 
1544     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1545     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1546     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1547 
1548     // Mapping from holder address to their (enumerable) set of owned tokens
1549     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1550 
1551     // Enumerable mapping from token ids to their owners
1552     EnumerableMap.UintToAddressMap private _tokenOwners;
1553 
1554     // Mapping from token ID to approved address
1555     mapping(uint256 => address) private _tokenApprovals;
1556 
1557     // Mapping from owner to operator approvals
1558     mapping(address => mapping(address => bool)) private _operatorApprovals;
1559 
1560     // Token name
1561     string private _name;
1562 
1563     // Token symbol
1564     string private _symbol;
1565 
1566     uint256 private _totalSupply;
1567     // Optional mapping for token URIs
1568     mapping(uint256 => string) private _tokenURIs;
1569 
1570     // Base URI
1571     string private _baseURI;
1572 
1573     /*
1574      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1575      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1576      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1577      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1578      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1579      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1580      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1581      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1582      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1583      *
1584      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1585      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1586      */
1587     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1588 
1589     /*
1590      *     bytes4(keccak256('name()')) == 0x06fdde03
1591      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1592      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1593      *
1594      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1595      */
1596     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1597 
1598     /*
1599      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1600      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1601      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1602      *
1603      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1604      */
1605     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1606 
1607     /**
1608      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1609      */
1610     constructor(
1611         string memory name_,
1612         string memory symbol_,
1613         uint256 totalSupply_
1614     ) public {
1615         _name = name_;
1616         _symbol = symbol_;
1617         _totalSupply = totalSupply_;
1618         // register the supported interfaces to conform to ERC721 via ERC165
1619         _registerInterface(_INTERFACE_ID_ERC721);
1620         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1621         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-balanceOf}.
1626      */
1627     function balanceOf(address owner) public view override returns (uint256) {
1628         require(
1629             owner != address(0),
1630             "ERC721: balance query for the zero address"
1631         );
1632 
1633         return _holderTokens[owner].length();
1634     }
1635 
1636     /**
1637      * @dev See {IERC721-ownerOf}.
1638      */
1639     function ownerOf(uint256 tokenId) public view override returns (address) {
1640         return
1641             _tokenOwners.get(
1642                 tokenId,
1643                 "ERC721: owner query for nonexistent token"
1644             );
1645     }
1646 
1647     /**
1648      * @dev See {IERC721Metadata-name}.
1649      */
1650     function name() public view override returns (string memory) {
1651         return _name;
1652     }
1653 
1654     /**
1655      * @dev See {IERC721Metadata-symbol}.
1656      */
1657     function symbol() public view override returns (string memory) {
1658         return _symbol;
1659     }
1660 
1661     /**
1662      * @dev See {IERC721Metadata-tokenURI}.
1663      */
1664     function tokenURI(uint256 tokenId)
1665         public
1666         view
1667         override
1668         returns (string memory)
1669     {
1670         require(
1671             _exists(tokenId),
1672             "ERC721Metadata: URI query for nonexistent token"
1673         );
1674 
1675         // If there is no base URI, return the token URI.
1676         string memory _tokenURI = _tokenURIs[tokenId];
1677         if (bytes(_baseURI).length == 0 && bytes(_tokenURI).length == 0) {
1678             return "ipfs://QmdSBxcU7c64uRTZS59mEzi6mtQ7eZ38WYtHpnuzz4Mie5";
1679         }
1680 
1681         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1682         if (bytes(_tokenURI).length > 0) {
1683             return _tokenURI;
1684         }
1685         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1686         return string(abi.encodePacked(_baseURI, tokenId.toString(), ".json"));
1687     }
1688 
1689     /**
1690      * @dev Returns the base URI set via {_setBaseURI}. This will be
1691      * automatically added as a prefix in {tokenURI} to each token's URI, or
1692      * to the token ID if no specific URI is set for that token ID.
1693      */
1694     function baseURI() public view returns (string memory) {
1695         return _baseURI;
1696     }
1697 
1698     /**
1699      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1700      */
1701     function tokenOfOwnerByIndex(address owner, uint256 index)
1702         public
1703         view
1704         override
1705         returns (uint256)
1706     {
1707         return _holderTokens[owner].at(index);
1708     }
1709 
1710     /**
1711      * @dev See {IERC721Enumerable-totalSupply}.
1712      */
1713     function totalSupply() public view override returns (uint256) {
1714         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1715         return _totalSupply;
1716     }
1717 
1718     /**
1719      * @dev See {IERC721Enumerable-tokenByIndex}.
1720      */
1721     function tokenByIndex(uint256 index)
1722         public
1723         view
1724         override
1725         returns (uint256)
1726     {
1727         (uint256 tokenId, ) = _tokenOwners.at(index);
1728         return tokenId;
1729     }
1730 
1731     /**
1732      * @dev See {IERC721-approve}.
1733      */
1734     function approve(address to, uint256 tokenId) public virtual override {
1735         address owner = ownerOf(tokenId);
1736         require(to != owner, "ERC721: approval to current owner");
1737 
1738         require(
1739             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1740             "ERC721: approve caller is not owner nor approved for all"
1741         );
1742 
1743         _approve(to, tokenId);
1744     }
1745 
1746     /**
1747      * @dev See {IERC721-getApproved}.
1748      */
1749     function getApproved(uint256 tokenId)
1750         public
1751         view
1752         override
1753         returns (address)
1754     {
1755         require(
1756             _exists(tokenId),
1757             "ERC721: approved query for nonexistent token"
1758         );
1759 
1760         return _tokenApprovals[tokenId];
1761     }
1762 
1763     /**
1764      * @dev See {IERC721-setApprovalForAll}.
1765      */
1766     function setApprovalForAll(address operator, bool approved)
1767         public
1768         virtual
1769         override
1770     {
1771         require(operator != _msgSender(), "ERC721: approve to caller");
1772 
1773         _operatorApprovals[_msgSender()][operator] = approved;
1774         emit ApprovalForAll(_msgSender(), operator, approved);
1775     }
1776 
1777     /**
1778      * @dev See {IERC721-isApprovedForAll}.
1779      */
1780     function isApprovedForAll(address owner, address operator)
1781         public
1782         view
1783         override
1784         returns (bool)
1785     {
1786         return _operatorApprovals[owner][operator];
1787     }
1788 
1789     /**
1790      * @dev See {IERC721-transferFrom}.
1791      */
1792     function transferFrom(
1793         address from,
1794         address to,
1795         uint256 tokenId
1796     ) public virtual override {
1797         //solhint-disable-next-line max-line-length
1798         require(
1799             _isApprovedOrOwner(_msgSender(), tokenId),
1800             "ERC721: transfer caller is not owner nor approved"
1801         );
1802 
1803         _transfer(from, to, tokenId);
1804     }
1805 
1806     /**
1807      * @dev See {IERC721-safeTransferFrom}.
1808      */
1809     function safeTransferFrom(
1810         address from,
1811         address to,
1812         uint256 tokenId
1813     ) public virtual override {
1814         safeTransferFrom(from, to, tokenId, "");
1815     }
1816 
1817     /**
1818      * @dev See {IERC721-safeTransferFrom}.
1819      */
1820     function safeTransferFrom(
1821         address from,
1822         address to,
1823         uint256 tokenId,
1824         bytes memory _data
1825     ) public virtual override {
1826         require(
1827             _isApprovedOrOwner(_msgSender(), tokenId),
1828             "ERC721: transfer caller is not owner nor approved"
1829         );
1830         _safeTransfer(from, to, tokenId, _data);
1831     }
1832 
1833     /**
1834      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1835      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1836      *
1837      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1838      *
1839      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1840      * implement alternative mechanisms to perform token transfer, such as signature-based.
1841      *
1842      * Requirements:
1843      *
1844      * - `from` cannot be the zero address.
1845      * - `to` cannot be the zero address.
1846      * - `tokenId` token must exist and be owned by `from`.
1847      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1848      *
1849      * Emits a {Transfer} event.
1850      */
1851     function _safeTransfer(
1852         address from,
1853         address to,
1854         uint256 tokenId,
1855         bytes memory _data
1856     ) internal virtual {
1857         _transfer(from, to, tokenId);
1858         require(
1859             _checkOnERC721Received(from, to, tokenId, _data),
1860             "ERC721: transfer to non ERC721Receiver implementer"
1861         );
1862     }
1863 
1864     /**
1865      * @dev Returns whether `tokenId` exists.
1866      *
1867      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1868      *
1869      * Tokens start existing when they are minted (`_mint`),
1870      * and stop existing when they are burned (`_burn`).
1871      */
1872     function _exists(uint256 tokenId) internal view returns (bool) {
1873         return _tokenOwners.contains(tokenId);
1874     }
1875 
1876     /**
1877      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1878      *
1879      * Requirements:
1880      *
1881      * - `tokenId` must exist.
1882      */
1883     function _isApprovedOrOwner(address spender, uint256 tokenId)
1884         internal
1885         view
1886         returns (bool)
1887     {
1888         require(
1889             _exists(tokenId),
1890             "ERC721: operator query for nonexistent token"
1891         );
1892         address owner = ownerOf(tokenId);
1893         return (spender == owner ||
1894             getApproved(tokenId) == spender ||
1895             isApprovedForAll(owner, spender));
1896     }
1897 
1898     /**
1899      * @dev Safely mints `tokenId` and transfers it to `to`.
1900      *
1901      * Requirements:
1902      d*
1903      * - `tokenId` must not exist.
1904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1905      *
1906      * Emits a {Transfer} event.
1907      */
1908     function _safeMint(address to, uint256 tokenId) internal virtual {
1909         _safeMint(to, tokenId, "");
1910     }
1911 
1912     /**
1913      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1914      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1915      */
1916     function _safeMint(
1917         address to,
1918         uint256 tokenId,
1919         bytes memory _data
1920     ) internal virtual {
1921         _mint(to, tokenId);
1922         require(
1923             _checkOnERC721Received(address(0), to, tokenId, _data),
1924             "ERC721: transfer to non ERC721Receiver implementer"
1925         );
1926     }
1927 
1928     /**
1929      * @dev Mints `tokenId` and transfers it to `to`.
1930      *
1931      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1932      *
1933      * Requirements:
1934      *
1935      * - `tokenId` must not exist.
1936      * - `to` cannot be the zero address.
1937      *
1938      * Emits a {Transfer} event.
1939      */
1940     function _mint(address to, uint256 tokenId) internal virtual {
1941         require(to != address(0), "ERC721: mint to the zero address");
1942         require(!_exists(tokenId), "ERC721: token already minted");
1943 
1944         _beforeTokenTransfer(address(0), to, tokenId);
1945 
1946         _holderTokens[to].add(tokenId);
1947 
1948         _tokenOwners.set(tokenId, to);
1949 
1950         emit Transfer(address(0), to, tokenId);
1951     }
1952 
1953     /**
1954      * @dev Destroys `tokenId`.
1955      * The approval is cleared when the token is burned.
1956      *
1957      * Requirements:
1958      *
1959      * - `tokenId` must exist.
1960      *
1961      * Emits a {Transfer} event.
1962      */
1963     function _burn(uint256 tokenId) internal virtual {
1964         address owner = ownerOf(tokenId);
1965 
1966         _beforeTokenTransfer(owner, address(0), tokenId);
1967 
1968         // Clear approvals
1969         _approve(address(0), tokenId);
1970 
1971         // Clear metadata (if any)
1972         if (bytes(_tokenURIs[tokenId]).length != 0) {
1973             delete _tokenURIs[tokenId];
1974         }
1975 
1976         _holderTokens[owner].remove(tokenId);
1977 
1978         _tokenOwners.remove(tokenId);
1979 
1980         emit Transfer(owner, address(0), tokenId);
1981     }
1982 
1983     /**
1984      * @dev Transfers `tokenId` from `from` to `to`.
1985      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1986      *
1987      * Requirements:
1988      *
1989      * - `to` cannot be the zero address.
1990      * - `tokenId` token must be owned by `from`.
1991      *
1992      * Emits a {Transfer} event.
1993      */
1994     function _transfer(
1995         address from,
1996         address to,
1997         uint256 tokenId
1998     ) internal virtual {
1999         require(
2000             ownerOf(tokenId) == from,
2001             "ERC721: transfer of token that is not own"
2002         );
2003         require(to != address(0), "ERC721: transfer to the zero address");
2004 
2005         _beforeTokenTransfer(from, to, tokenId);
2006 
2007         // Clear approvals from the previous owner
2008         _approve(address(0), tokenId);
2009 
2010         _holderTokens[from].remove(tokenId);
2011         _holderTokens[to].add(tokenId);
2012 
2013         _tokenOwners.set(tokenId, to);
2014 
2015         emit Transfer(from, to, tokenId);
2016     }
2017 
2018     /**
2019      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2020      *
2021      * Requirements:
2022      *
2023      * - `tokenId` must exist.
2024      */
2025     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2026         internal
2027         virtual
2028     {
2029         require(
2030             _exists(tokenId),
2031             "ERC721Metadata: URI set of nonexistent token"
2032         );
2033         _tokenURIs[tokenId] = _tokenURI;
2034     }
2035 
2036     /**
2037      * @dev Internal function to set the base URI for all token IDs. It is
2038      * automatically added as a prefix to the value returned in {tokenURI},
2039      * or to the token ID if {tokenURI} is empty.
2040      */
2041     function _setBaseURI(string memory baseURI_) internal virtual {
2042         _baseURI = baseURI_;
2043     }
2044 
2045     /**
2046      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2047      * The call is not executed if the target address is not a contract.
2048      *
2049      * @param from address representing the previous owner of the given token ID
2050      * @param to target address that will receive the tokens
2051      * @param tokenId uint256 ID of the token to be transferred
2052      * @param _data bytes optional data to send along with the call
2053      * @return bool whether the call correctly returned the expected magic value
2054      */
2055     function _checkOnERC721Received(
2056         address from,
2057         address to,
2058         uint256 tokenId,
2059         bytes memory _data
2060     ) private returns (bool) {
2061         if (!to.isContract()) {
2062             return true;
2063         }
2064         bytes memory returndata = to.functionCall(
2065             abi.encodeWithSelector(
2066                 IERC721Receiver(to).onERC721Received.selector,
2067                 _msgSender(),
2068                 from,
2069                 tokenId,
2070                 _data
2071             ),
2072             "ERC721: transfer to non ERC721Receiver implementer"
2073         );
2074         bytes4 retval = abi.decode(returndata, (bytes4));
2075         return (retval == _ERC721_RECEIVED);
2076     }
2077 
2078     function _approve(address to, uint256 tokenId) private {
2079         _tokenApprovals[tokenId] = to;
2080         emit Approval(ownerOf(tokenId), to, tokenId);
2081     }
2082 
2083     /**
2084      * @dev Hook that is called before any token transfer. This includes minting
2085      * and burning.
2086      *
2087      * Calling conditions:
2088      *
2089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2090      * transferred to `to`.
2091      * - When `from` is zero, `tokenId` will be minted for `to`.
2092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2093      * - `from` cannot be the zero address.
2094      * - `to` cannot be the zero address.
2095      *
2096      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2097      */
2098     function _beforeTokenTransfer(
2099         address from,
2100         address to,
2101         uint256 tokenId
2102     ) internal virtual {}
2103 }
2104 
2105 pragma solidity ^0.6.0;
2106 
2107 contract JCN is ERC721, Ownable {
2108     uint16 private constant mMax = 500;
2109     uint16 private constant mMintLimit = 2;
2110     uint256 private constant mPriceW = 0.1 ether;
2111     uint256 private constant mPrice = 0.18 ether;
2112     uint256 private mStartTime = 0;
2113     uint256 private mWhiteCount = 0;
2114     uint256 private mMintCount = 0;
2115     mapping(address => bool) private mWhites;
2116     mapping(address => uint8) private mHolders;
2117     struct Tiger {
2118         uint256 dna;
2119     }
2120 
2121     Tiger[] public mTigers;
2122 
2123     function _cread() internal virtual returns (uint256) {
2124         uint256 dna = _generateRandom();
2125         dna = (dna * (mMintCount + 1)) % 10000000000;
2126         mTigers.push(Tiger(dna));
2127         uint256 tokenid = mTigers.length - 1;
2128         return tokenid;
2129     }
2130 
2131     function _generateRandom() private view returns (uint256) {
2132         return
2133             uint256(
2134                 keccak256(
2135                     abi.encodePacked(
2136                         (block.timestamp)
2137                             .add(block.difficulty)
2138                             .add(
2139                                 (
2140                                     uint256(
2141                                         keccak256(
2142                                             abi.encodePacked(block.coinbase)
2143                                         )
2144                                     )
2145                                 ) / (now)
2146                             )
2147                             .add(block.gaslimit)
2148                             .add(
2149                                 (
2150                                     uint256(
2151                                         keccak256(abi.encodePacked(msg.sender))
2152                                     )
2153                                 ) / (now)
2154                             )
2155                             .add(block.number)
2156                     )
2157                 )
2158             ) % 1000000000000000000;
2159     }
2160 
2161     constructor() public ERC721("JI Capital NFTs", "JI", mMax) {
2162         //_setBaseURI("ipfs://");
2163     }
2164 
2165     modifier isMax() {
2166         require(mMintCount < mMax, "mint: End of sale");
2167         require(block.timestamp >= mStartTime, "mint: no start");
2168         require(mHolders[_msgSender()] < mMintLimit, "ERC721: MAX");
2169         _;
2170     }
2171 
2172     function mint() public payable isMax {
2173         require(mMintCount + mWhiteCount < mMax, "mint: End of public sale");
2174         require(msg.value >= mPrice, "mint: amount < price");
2175         _mint1();
2176     }
2177 
2178     function mintW() public payable isMax {
2179         require(mWhites[_msgSender()], "mint: no white");
2180         require(msg.value >= mPriceW, "mint: amount < price");
2181         mWhites[_msgSender()] = false;
2182         mWhiteCount = mWhiteCount.sub(1);
2183         _mint1();
2184     }
2185 
2186 
2187     function _mint1() private {
2188         mMintCount++;
2189         mHolders[_msgSender()]++;
2190         uint256 tokenid = _cread();
2191         _mint(_msgSender(), tokenid);
2192     }
2193 
2194     function setWhite(address[] memory _args, bool _bool) public onlyOwner {
2195         for (uint16 i = 0; i < _args.length; i++) {
2196             mWhites[_args[i]] = _bool;
2197         }
2198         _bool
2199             ? mWhiteCount = mWhiteCount.add(_args.length)
2200             : mWhiteCount = mWhiteCount.sub(_args.length);
2201     }
2202 
2203     function setTime(uint256 _day) public onlyOwner {
2204         mStartTime = _day;
2205     }
2206 
2207     function setBaseURI(string memory _baseURI) public onlyOwner {
2208         _setBaseURI(_baseURI);
2209     }
2210 
2211     function setTokenURIs(uint16[] memory _tokenid, string[] memory _url)
2212         public
2213         onlyOwner
2214     {
2215         require(_tokenid.length == _url.length, "ERC721: parameter exception");
2216         for (uint16 i = 0; i < _tokenid.length; i++) {
2217             _setTokenURI(_tokenid[i], _url[i]);
2218         }
2219     }
2220 
2221     function withdraw() public onlyOwner {
2222         address to = owner();
2223         (bool success, ) = to.call{value: address(this).balance}(new bytes(0));
2224         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
2225     }
2226 
2227     function getInfo()
2228         public
2229         view
2230         returns (
2231             uint256,
2232             uint256,
2233             uint256,
2234             uint256
2235         )
2236     {
2237         return (mMintCount, mStartTime, mWhiteCount, block.timestamp);
2238     }
2239 }