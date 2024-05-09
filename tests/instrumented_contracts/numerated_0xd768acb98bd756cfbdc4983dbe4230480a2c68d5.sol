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
32 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
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
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
113      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
114      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
115      * understand this adds an external call which potentially creates a reentrancy vulnerability.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 }
175 
176 // File: DogPadStake.sol
177 
178 //SPDX-License-Identifier: MIT
179 
180 
181 pragma solidity 0.8.16;
182 
183 
184 //import "@nomiclabs/buidler/console.sol";
185 
186 /*
187  * @dev Provides information about the current execution context, including the
188  * sender of the transaction and its data. While these are generally available
189  * via msg.sender and msg.data, they should not be accessed in such a direct
190  * manner, since when dealing with GSN meta-transactions the account sending and
191  * paying for execution may not be the actual sender (as far as an application
192  * is concerned).
193  *
194  * This contract is only required for intermediate, library-like contracts.
195  */
196 contract Context {
197     // Empty internal constructor, to prevent people from mistakenly deploying
198     // an instance of this contract, which should be used via inheritance.
199     constructor() {}
200 
201     function _msgSender() internal view returns (address payable) {
202         return payable(msg.sender);
203     }
204 
205     function _msgData() internal view returns (bytes memory) {
206         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
207         return msg.data;
208     }
209 }
210 
211 /**
212  * @dev Contract module which provides a basic access control mechanism, where
213  * there is an account (an owner) that can be granted exclusive access to
214  * specific functions.
215  *
216  * By default, the owner account will be the one that deploys the contract. This
217  * can later be changed with {transferOwnership}.
218  *
219  * This module is used through inheritance. It will make available the modifier
220  * `onlyOwner`, which can be applied to your functions to restrict their use to
221  * the owner.
222  */
223 contract Ownable is Context {
224     address private _owner;
225 
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228     /**
229      * @dev Initializes the contract setting the deployer as the initial owner.
230      */
231     constructor() {
232         address msgSender = _msgSender();
233         _owner = msgSender;
234         emit OwnershipTransferred(address(0), msgSender);
235     }
236 
237     /**
238      * @dev Returns the address of the current owner.
239      */
240     function owner() public view returns (address) {
241         return _owner;
242     }
243 
244     /**
245      * @dev Throws if called by any account other than the owner.
246      */
247     modifier onlyOwner() {
248         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
249         _;
250     }
251 
252     /**
253      * @dev Leaves the contract without owner. It will not be possible to call
254      * `onlyOwner` functions anymore. Can only be called by the current owner.
255      *
256      * NOTE: Renouncing ownership will leave the contract without an owner,
257      * thereby removing any functionality that is only available to the owner.
258      */
259     function renounceOwnership() public onlyOwner {
260         emit OwnershipTransferred(_owner, address(0));
261         _owner = address(0);
262     }
263 
264     /**
265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
266      * Can only be called by the current owner.
267      */
268     function transferOwnership(address newOwner) public onlyOwner {
269         _transferOwnership(newOwner);
270     }
271 
272     /**
273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
274      */
275     function _transferOwnership(address newOwner) internal {
276         require(newOwner != address(0), 'Ownable: new owner is the zero address');
277         emit OwnershipTransferred(_owner, newOwner);
278         _owner = newOwner;
279     }
280 }
281 
282 /**
283  * @dev Wrappers over Solidity's arithmetic operations with added overflow
284  * checks.
285  *
286  * Arithmetic operations in Solidity wrap on overflow. This can easily result
287  * in bugs, because programmers usually assume that an overflow raises an
288  * error, which is the standard behavior in high level programming languages.
289  * `SafeMath` restores this intuition by reverting the transaction when an
290  * operation overflows.
291  *
292  * Using this library instead of the unchecked operations eliminates an entire
293  * class of bugs, so it's recommended to use it always.
294  */
295 library SafeMath {
296     /**
297      * @dev Returns the addition of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `+` operator.
301      *
302      * Requirements:
303      *
304      * - Addition cannot overflow.
305      */
306     function add(uint256 a, uint256 b) internal pure returns (uint256) {
307         uint256 c = a + b;
308         require(c >= a, 'SafeMath: addition overflow');
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the subtraction of two unsigned integers, reverting on
315      * overflow (when the result is negative).
316      *
317      * Counterpart to Solidity's `-` operator.
318      *
319      * Requirements:
320      *
321      * - Subtraction cannot overflow.
322      */
323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
324         return sub(a, b, 'SafeMath: subtraction overflow');
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      *
335      * - Subtraction cannot overflow.
336      */
337     function sub(
338         uint256 a,
339         uint256 b,
340         string memory errorMessage
341     ) internal pure returns (uint256) {
342         require(b <= a, errorMessage);
343         uint256 c = a - b;
344 
345         return c;
346     }
347 
348     /**
349      * @dev Returns the multiplication of two unsigned integers, reverting on
350      * overflow.
351      *
352      * Counterpart to Solidity's `*` operator.
353      *
354      * Requirements:
355      *
356      * - Multiplication cannot overflow.
357      */
358     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
359         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
360         // benefit is lost if 'b' is also tested.
361         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
362         if (a == 0) {
363             return 0;
364         }
365 
366         uint256 c = a * b;
367         require(c / a == b, 'SafeMath: multiplication overflow');
368 
369         return c;
370     }
371 
372     /**
373      * @dev Returns the integer division of two unsigned integers. Reverts on
374      * division by zero. The result is rounded towards zero.
375      *
376      * Counterpart to Solidity's `/` operator. Note: this function uses a
377      * `revert` opcode (which leaves remaining gas untouched) while Solidity
378      * uses an invalid opcode to revert (consuming all remaining gas).
379      *
380      * Requirements:
381      *
382      * - The divisor cannot be zero.
383      */
384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
385         return div(a, b, 'SafeMath: division by zero');
386     }
387 
388     /**
389      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
390      * division by zero. The result is rounded towards zero.
391      *
392      * Counterpart to Solidity's `/` operator. Note: this function uses a
393      * `revert` opcode (which leaves remaining gas untouched) while Solidity
394      * uses an invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function div(
401         uint256 a,
402         uint256 b,
403         string memory errorMessage
404     ) internal pure returns (uint256) {
405         require(b > 0, errorMessage);
406         uint256 c = a / b;
407         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
408 
409         return c;
410     }
411 
412     /**
413      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
414      * Reverts when dividing by zero.
415      *
416      * Counterpart to Solidity's `%` operator. This function uses a `revert`
417      * opcode (which leaves remaining gas untouched) while Solidity uses an
418      * invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
425         return mod(a, b, 'SafeMath: modulo by zero');
426     }
427 
428     /**
429      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
430      * Reverts with custom message when dividing by zero.
431      *
432      * Counterpart to Solidity's `%` operator. This function uses a `revert`
433      * opcode (which leaves remaining gas untouched) while Solidity uses an
434      * invalid opcode to revert (consuming all remaining gas).
435      *
436      * Requirements:
437      *
438      * - The divisor cannot be zero.
439      */
440     function mod(
441         uint256 a,
442         uint256 b,
443         string memory errorMessage
444     ) internal pure returns (uint256) {
445         require(b != 0, errorMessage);
446         return a % b;
447     }
448 
449     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
450         z = x < y ? x : y;
451     }
452 
453     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
454     function sqrt(uint256 y) internal pure returns (uint256 z) {
455         if (y > 3) {
456             z = y;
457             uint256 x = y / 2 + 1;
458             while (x < z) {
459                 z = x;
460                 x = (y / x + x) / 2;
461             }
462         } else if (y != 0) {
463             z = 1;
464         }
465     }
466 }
467 
468 interface IBEP20 {
469     /**
470      * @dev Returns the amount of tokens in existence.
471      */
472     function totalSupply() external view returns (uint256);
473 
474     /**
475      * @dev Returns the token decimals.
476      */
477     function decimals() external view returns (uint8);
478 
479     /**
480      * @dev Returns the token symbol.
481      */
482     function symbol() external view returns (string memory);
483 
484     /**
485      * @dev Returns the token name.
486      */
487     function name() external view returns (string memory);
488 
489     /**
490      * @dev Returns the bep token owner.
491      */
492     function getOwner() external view returns (address);
493 
494     /**
495      * @dev Returns the amount of tokens owned by `account`.
496      */
497     function balanceOf(address account) external view returns (uint256);
498 
499     /**
500      * @dev Moves `amount` tokens from the caller's account to `recipient`.
501      *
502      * Returns a boolean value indicating whether the operation succeeded.
503      *
504      * Emits a {Transfer} event.
505      */
506     function transfer(address recipient, uint256 amount) external returns (bool);
507 
508     /**
509      * @dev Returns the remaining number of tokens that `spender` will be
510      * allowed to spend on behalf of `owner` through {transferFrom}. This is
511      * zero by default.
512      *
513      * This value changes when {approve} or {transferFrom} are called.
514      */
515     function allowance(address _owner, address spender) external view returns (uint256);
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
519      *
520      * Returns a boolean value indicating whether the operation succeeded.
521      *
522      * IMPORTANT: Beware that changing an allowance with this method brings the risk
523      * that someone may use both the old and the new allowance by unfortunate
524      * transaction ordering. One possible solution to mitigate this race
525      * condition is to first reduce the spender's allowance to 0 and set the
526      * desired value afterwards:
527      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address spender, uint256 amount) external returns (bool);
532 
533     /**
534      * @dev Moves `amount` tokens from `sender` to `recipient` using the
535      * allowance mechanism. `amount` is then deducted from the caller's
536      * allowance.
537      *
538      * Returns a boolean value indicating whether the operation succeeded.
539      *
540      * Emits a {Transfer} event.
541      */
542     function transferFrom(
543         address sender,
544         address recipient,
545         uint256 amount
546     ) external returns (bool);
547 
548     /**
549      * @dev Emitted when `value` tokens are moved from one account (`from`) to
550      * another (`to`).
551      *
552      * Note that `value` may be zero.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 value);
555 
556     /**
557      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
558      * a call to {approve}. `value` is the new allowance.
559      */
560     event Approval(address indexed owner, address indexed spender, uint256 value);
561 }
562 
563 /**
564  * @title SafeBEP20
565  * @dev Wrappers around BEP20 operations that throw on failure (when the token
566  * contract returns false). Tokens that return no value (and instead revert or
567  * throw on failure) are also supported, non-reverting calls are assumed to be
568  * successful.
569  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
570  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
571  */
572 library SafeBEP20 {
573     using SafeMath for uint256;
574     using Address for address;
575 
576     function safeTransfer(
577         IBEP20 token,
578         address to,
579         uint256 value
580     ) internal {
581         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
582     }
583 
584     function safeTransferFrom(
585         IBEP20 token,
586         address from,
587         address to,
588         uint256 value
589     ) internal {
590         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
591     }
592 
593     /**
594      * @dev Deprecated. This function has issues similar to the ones found in
595      * {IBEP20-approve}, and its usage is discouraged.
596      *
597      * Whenever possible, use {safeIncreaseAllowance} and
598      * {safeDecreaseAllowance} instead.
599      */
600     function safeApprove(
601         IBEP20 token,
602         address spender,
603         uint256 value
604     ) internal {
605         // safeApprove should only be called when setting an initial allowance,
606         // or when resetting it to zero. To increase and decrease it, use
607         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
608         // solhint-disable-next-line max-line-length
609         require(
610             (value == 0) || (token.allowance(address(this), spender) == 0),
611             'SafeBEP20: approve from non-zero to non-zero allowance'
612         );
613         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
614     }
615 
616     function safeIncreaseAllowance(
617         IBEP20 token,
618         address spender,
619         uint256 value
620     ) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).add(value);
622         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623     }
624 
625     function safeDecreaseAllowance(
626         IBEP20 token,
627         address spender,
628         uint256 value
629     ) internal {
630         uint256 newAllowance = token.allowance(address(this), spender).sub(
631             value,
632             'SafeBEP20: decreased allowance below zero'
633         );
634         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
635     }
636 
637     /**
638      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
639      * on the return value: the return value is optional (but if data is returned, it must not be false).
640      * @param token The token targeted by the call.
641      * @param data The call data (encoded using abi.encode or one of its variants).
642      */
643     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
644         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
645         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
646         // the target address contains contract code and also asserts for success in the low-level call.
647 
648         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
649         if (returndata.length > 0) {
650             // Return data is optional
651             // solhint-disable-next-line max-line-length
652             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
653         }
654     }
655 }
656 
657 /**
658  * @dev Collection of functions related to the address type
659  */
660 library Address {
661     /**
662      * @dev Returns true if `account` is a contract.
663      *
664      * [IMPORTANT]
665      * ====
666      * It is unsafe to assume that an address for which this function returns
667      * false is an externally-owned account (EOA) and not a contract.
668      *
669      * Among others, `isContract` will return false for the following
670      * types of addresses:
671      *
672      *  - an externally-owned account
673      *  - a contract in construction
674      *  - an address where a contract will be created
675      *  - an address where a contract lived, but was destroyed
676      * ====
677      */
678     function isContract(address account) internal view returns (bool) {
679         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
680         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
681         // for accounts without code, i.e. `keccak256('')`
682         bytes32 codehash;
683         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
684         // solhint-disable-next-line no-inline-assembly
685         assembly {
686             codehash := extcodehash(account)
687         }
688         return (codehash != accountHash && codehash != 0x0);
689     }
690 
691     /**
692      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
693      * `recipient`, forwarding all available gas and reverting on errors.
694      *
695      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
696      * of certain opcodes, possibly making contracts go over the 2300 gas limit
697      * imposed by `transfer`, making them unable to receive funds via
698      * `transfer`. {sendValue} removes this limitation.
699      *
700      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
701      *
702      * IMPORTANT: because control is transferred to `recipient`, care must be
703      * taken to not create reentrancy vulnerabilities. Consider using
704      * {ReentrancyGuard} or the
705      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
706      */
707     function sendValue(address payable recipient, uint256 amount) internal {
708         require(address(this).balance >= amount, 'Address: insufficient balance');
709 
710         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
711         (bool success, ) = recipient.call{value: amount}('');
712         require(success, 'Address: unable to send value, recipient may have reverted');
713     }
714 
715     /**
716      * @dev Performs a Solidity function call using a low level `call`. A
717      * plain`call` is an unsafe replacement for a function call: use this
718      * function instead.
719      *
720      * If `target` reverts with a revert reason, it is bubbled up by this
721      * function (like regular Solidity function calls).
722      *
723      * Returns the raw returned data. To convert to the expected return value,
724      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
725      *
726      * Requirements:
727      *
728      * - `target` must be a contract.
729      * - calling `target` with `data` must not revert.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
734         return functionCall(target, data, 'Address: low-level call failed');
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
739      * `errorMessage` as a fallback revert reason when `target` reverts.
740      *
741      * _Available since v3.1._
742      */
743     function functionCall(
744         address target,
745         bytes memory data,
746         string memory errorMessage
747     ) internal returns (bytes memory) {
748         return _functionCallWithValue(target, data, 0, errorMessage);
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
753      * but also transferring `value` wei to `target`.
754      *
755      * Requirements:
756      *
757      * - the calling contract must have an ETH balance of at least `value`.
758      * - the called Solidity function must be `payable`.
759      *
760      * _Available since v3.1._
761      */
762     function functionCallWithValue(
763         address target,
764         bytes memory data,
765         uint256 value
766     ) internal returns (bytes memory) {
767         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
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
782         require(address(this).balance >= value, 'Address: insufficient balance for call');
783         return _functionCallWithValue(target, data, value, errorMessage);
784     }
785 
786     function _functionCallWithValue(
787         address target,
788         bytes memory data,
789         uint256 weiValue,
790         string memory errorMessage
791     ) private returns (bytes memory) {
792         require(isContract(target), 'Address: call to non-contract');
793 
794         // solhint-disable-next-line avoid-low-level-calls
795         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
796         if (success) {
797             return returndata;
798         } else {
799             // Look for revert reason and bubble it up if present
800             if (returndata.length > 0) {
801                 // The easiest way to bubble the revert reason is using memory via assembly
802 
803                 // solhint-disable-next-line no-inline-assembly
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
815 abstract contract ReentrancyGuard {
816     // Booleans are more expensive than uint256 or any type that takes up a full
817     // word because each write operation emits an extra SLOAD to first read the
818     // slot's contents, replace the bits taken up by the boolean, and then write
819     // back. This is the compiler's defense against contract upgrades and
820     // pointer aliasing, and it cannot be disabled.
821 
822     // The values being non-zero value makes deployment a bit more expensive,
823     // but in exchange the refund on every call to nonReentrant will be lower in
824     // amount. Since refunds are capped to a percentage of the total
825     // transaction's gas, it is best to keep them low in cases like this one, to
826     // increase the likelihood of the full refund coming into effect.
827     uint256 private constant _NOT_ENTERED = 1;
828     uint256 private constant _ENTERED = 2;
829 
830     uint256 private _status;
831 
832     constructor() {
833         _status = _NOT_ENTERED;
834     }
835 
836     /**
837      * @dev Prevents a contract from calling itself, directly or indirectly.
838      * Calling a `nonReentrant` function from another `nonReentrant`
839      * function is not supported. It is possible to prevent this from happening
840      * by making the `nonReentrant` function external, and making it call a
841      * `private` function that does the actual work.
842      */
843     modifier nonReentrant() {
844         // On the first call to nonReentrant, _notEntered will be true
845         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
846 
847         // Any calls to nonReentrant after this point will fail
848         _status = _ENTERED;
849 
850         _;
851 
852         // By storing the original value once again, a refund is triggered (see
853         // https://eips.ethereum.org/EIPS/eip-2200)
854         _status = _NOT_ENTERED;
855     }
856 }
857 
858 contract DogPadStakeTwo is Ownable, ReentrancyGuard {
859     using SafeMath for uint256;
860     using SafeBEP20 for IBEP20;
861 
862     // Info of each user.
863     struct UserInfo {
864         uint256 amount;     // How many LP tokens the user has provided.
865         uint256 boostedAmount;
866         uint256 boosts;
867         uint256 rewardDebt; // Reward debt. See explanation below.
868         uint256 pendingPayout; // track any previously pending payouts from boosts
869     }
870 
871     // Info of each pool.
872     struct PoolInfo {
873         IBEP20 lpToken;           // Address of LP token contract.
874         uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
875         uint256 lastRewardTimestamp;  // Last block number that Tokens distribution occurs.
876         uint256 accTokensPerShare; // Accumulated Tokens per share, times 1e12. See below.
877     }
878 
879     IBEP20 public immutable stakingToken;
880     IBEP20 public immutable rewardToken;
881     IERC721 public immutable nftToken;
882     mapping (address => uint256) public holderUnlockTime;
883 
884     mapping (address => bool) public _isAuthorized;
885 
886     uint256 public totalStaked;
887     uint256 public totalBoostedStaked;
888     uint256 public apr;
889     uint256 public lockDuration;
890     uint256 public exitPenaltyPerc;
891 
892     uint256 public amountPerBoost;
893     uint256 public maxBoostAmount;
894     mapping ( address => uint256) public lastWalletBoostTs;
895     
896     bool public canCompoundOrStakeMore;
897 
898     // Info of each pool.
899     PoolInfo[] public poolInfo;
900     // Info of each user that stakes LP tokens.
901     mapping (address => UserInfo) public userInfo;
902     // Total allocation points. Must be the sum of all allocation points in all pools.
903     uint256 private totalAllocPoint;
904 
905     event Deposit(address indexed user, uint256 amount);
906     event Withdraw(address indexed user, uint256 amount);
907     event Compound(address indexed user);
908     event EmergencyWithdraw(address indexed user, uint256 amount);
909 
910     constructor(address _nftTokenAddress, address _stakingToken, address _tokenAddress, uint256 _apr, uint256 _lockDurationInDays, uint256 _exitPenaltyPerc, bool _canCompoundOrStakeMore) {
911         stakingToken = IBEP20(_stakingToken);
912         rewardToken = IBEP20(_tokenAddress);
913         nftToken = IERC721(_nftTokenAddress);
914         canCompoundOrStakeMore = _canCompoundOrStakeMore;
915         _isAuthorized[msg.sender] = true;
916 
917         apr = _apr;
918         lockDuration = _lockDurationInDays * 1 days;
919         exitPenaltyPerc = _exitPenaltyPerc;
920 
921         amountPerBoost = 50; // 25% boost per booster
922         maxBoostAmount = 6; // 6 boosts allowed
923 
924         // staking pool
925         poolInfo.push(PoolInfo({
926             lpToken: stakingToken,
927             allocPoint: 1000,
928             lastRewardTimestamp: 99999999999,
929             accTokensPerShare: 0
930         }));
931 
932         totalAllocPoint = 1000;
933 
934     }
935 
936     modifier onlyAuthorized() {
937         require(_isAuthorized[msg.sender], "Not Authorized");
938         _;
939     }
940 
941     function setAuthorization(address account, bool authorized) external onlyOwner {
942         _isAuthorized[account] = authorized;
943     }
944 
945     function stopReward() external onlyOwner {
946         updatePool(0);
947         apr = 0;
948     }
949 
950     function startReward() external onlyOwner {
951         require(poolInfo[0].lastRewardTimestamp == 99999999999, "Can only start rewards once");
952         poolInfo[0].lastRewardTimestamp = block.timestamp;
953     }
954 
955     // View function to see pending Reward on frontend.
956     function pendingReward(address _user) external view returns (uint256) {
957         PoolInfo storage pool = poolInfo[0];
958         UserInfo storage user = userInfo[_user];
959         if(pool.lastRewardTimestamp == 99999999999){
960             return 0;
961         }
962         uint256 accTokensPerShare = pool.accTokensPerShare;
963         uint256 lpSupply = totalBoostedStaked;
964         if (block.timestamp > pool.lastRewardTimestamp && lpSupply != 0) {
965             uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
966             accTokensPerShare = accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
967         }
968         return user.boostedAmount.mul(accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
969     }
970 
971     // Update reward variables of the given pool to be up-to-date.
972     function updatePool(uint256 _pid) internal {
973         PoolInfo storage pool = poolInfo[_pid];
974         if (block.timestamp <= pool.lastRewardTimestamp) {
975             return;
976         }
977         uint256 lpSupply = totalBoostedStaked;
978         if (lpSupply == 0) {
979             pool.lastRewardTimestamp = block.timestamp;
980             return;
981         }
982         uint256 tokenReward = calculateNewRewards().mul(pool.allocPoint).div(totalAllocPoint);
983         pool.accTokensPerShare = pool.accTokensPerShare.add(tokenReward.mul(1e12).div(lpSupply));
984         pool.lastRewardTimestamp = block.timestamp;
985     }
986 
987     // Update reward variables for all pools. Be careful of gas spending!
988     function massUpdatePools() public onlyOwner {
989         uint256 length = poolInfo.length;
990         for (uint256 pid = 0; pid < length; ++pid) {
991             updatePool(pid);
992         }
993     }
994 
995     // Stake primary tokens
996     function deposit(uint256 _amount) external nonReentrant {
997         require(nftToken.balanceOf(msg.sender) > 0, "You must to have NFT");
998         if(holderUnlockTime[msg.sender] == 0){
999             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
1000         }
1001         PoolInfo storage pool = poolInfo[0];
1002         UserInfo storage user = userInfo[msg.sender];
1003 
1004         if(!canCompoundOrStakeMore && _amount > 0){
1005             require(user.boostedAmount == 0, "Cannot stake more");
1006         }
1007 
1008         updatePool(0);
1009         if (user.boostedAmount > 0) {
1010             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1011             user.pendingPayout = 0;
1012             if(pending > 0) {
1013                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
1014                 rewardToken.safeTransfer(address(msg.sender), pending);
1015             }
1016         }
1017         uint256 amountTransferred = 0;
1018         if(_amount > 0) {
1019             totalBoostedStaked -= getWalletBoostedAmount(msg.sender);
1020             uint256 initialBalance = pool.lpToken.balanceOf(address(this));
1021             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1022             amountTransferred = pool.lpToken.balanceOf(address(this)) - initialBalance;
1023             user.amount = user.amount.add(amountTransferred);
1024             totalStaked += amountTransferred;
1025             totalBoostedStaked += getWalletBoostedAmount(msg.sender);
1026             user.boostedAmount = getWalletBoostedAmount(msg.sender);
1027         }
1028         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1029 
1030         emit Deposit(msg.sender, _amount);
1031     }
1032 
1033     function compound() external nonReentrant {
1034         require(canCompoundOrStakeMore, "Cannot compound");
1035         PoolInfo storage pool = poolInfo[0];
1036         UserInfo storage user = userInfo[msg.sender];
1037 
1038         updatePool(0);
1039         if (user.boostedAmount > 0) {
1040             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1041             user.pendingPayout = 0;
1042             if(pending > 0) {
1043                 require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
1044                 totalBoostedStaked -= getWalletBoostedAmount(msg.sender);
1045                 user.amount += pending;
1046                 totalStaked += pending;
1047                 totalBoostedStaked += getWalletBoostedAmount(msg.sender);
1048                 user.boostedAmount = getWalletBoostedAmount(msg.sender);
1049             }
1050         }
1051 
1052         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1053         emit Compound(msg.sender);
1054     }
1055 
1056     // Withdraw primary tokens from STAKING.
1057 
1058     function withdraw() external nonReentrant {
1059 
1060         require(holderUnlockTime[msg.sender] <= block.timestamp, "May not do normal withdraw early");
1061         
1062         PoolInfo storage pool = poolInfo[0];
1063         UserInfo storage user = userInfo[msg.sender];
1064 
1065         uint256 _amount = user.amount;
1066         updatePool(0);
1067         uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1068         user.pendingPayout = 0;
1069         if(pending > 0){
1070             require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
1071             rewardToken.safeTransfer(address(msg.sender), pending);
1072         }
1073 
1074         if(_amount > 0) {
1075             totalBoostedStaked -= user.boostedAmount;
1076             user.boostedAmount = 0;
1077             user.boosts = 0;
1078             user.amount = 0;
1079             totalStaked -= _amount;
1080             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1081         }
1082 
1083         user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1084         
1085         if(user.amount > 0){
1086             holderUnlockTime[msg.sender] = block.timestamp + lockDuration;
1087         } else {
1088             holderUnlockTime[msg.sender] = 0;
1089         }
1090 
1091         emit Withdraw(msg.sender, _amount);
1092     }
1093 
1094     // Withdraw without caring about rewards. EMERGENCY ONLY.
1095     function emergencyWithdraw() external nonReentrant {
1096         PoolInfo storage pool = poolInfo[0];
1097         UserInfo storage user = userInfo[msg.sender];
1098         uint256 _amount = user.amount;
1099         totalBoostedStaked -= user.boostedAmount;
1100         totalStaked -= _amount;
1101         // exit penalty for early unstakers, penalty held on contract as rewards.
1102         if(holderUnlockTime[msg.sender] >= block.timestamp){
1103             _amount -= _amount * exitPenaltyPerc / 100;
1104         }
1105         holderUnlockTime[msg.sender] = 0;
1106         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1107         user.amount = 0;
1108         user.boostedAmount = 0;
1109         user.boosts = 0;
1110         user.rewardDebt = 0;
1111         user.pendingPayout = 0;
1112         emit EmergencyWithdraw(msg.sender, _amount);
1113     }
1114 
1115     // Withdraw reward. EMERGENCY ONLY. This allows the owner to migrate rewards to a new staking pool since we are not minting new tokens.
1116     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
1117         require(_amount <= rewardToken.balanceOf(address(this)) - totalStaked, 'not enough tokens to take out');
1118         rewardToken.safeTransfer(address(msg.sender), _amount);
1119     }
1120 
1121     function calculateNewRewards() public view returns (uint256) {
1122         PoolInfo storage pool = poolInfo[0];
1123         if(pool.lastRewardTimestamp > block.timestamp){
1124             return 0;
1125         }
1126         return (((block.timestamp - pool.lastRewardTimestamp) * totalBoostedStaked) * apr / 100 / 365 days);
1127     }
1128 
1129     function rewardsRemaining() public view returns (uint256){
1130         return rewardToken.balanceOf(address(this)) - totalStaked;
1131     }
1132 
1133     function updateApr(uint256 newApr) external onlyOwner {
1134         require(newApr <= 1000, "APR must be below 1000%");
1135         updatePool(0);
1136         apr = newApr;
1137     }
1138 
1139     // only applies for new stakers
1140     function updateLockDuration(uint256 daysForLock) external onlyOwner {
1141         require(daysForLock <= 365, "Lock must be 365 days or less.");
1142         lockDuration = daysForLock * 1 days;
1143     }
1144 
1145     function updateExitPenalty(uint256 newPenaltyPerc) external onlyOwner {
1146         require(newPenaltyPerc <= 20, "May not set higher than 20%");
1147         exitPenaltyPerc = newPenaltyPerc;
1148     }
1149 
1150     function updateCanCompoundOrStakeMore(bool compoundEnabled) external onlyOwner {
1151         canCompoundOrStakeMore = compoundEnabled;
1152     }
1153 
1154     function getWalletBoostedAmount(address wallet) public view returns (uint256){
1155         UserInfo storage user = userInfo[wallet];
1156         return user.amount * (100+(user.boosts*amountPerBoost)) / 100;
1157     }
1158 
1159     function getWalletAPR(address wallet) public view returns (uint256){
1160         UserInfo storage user = userInfo[wallet];
1161         return apr * (100+(user.boosts*amountPerBoost)) / 100;
1162     }
1163 
1164     function addBoost(address wallet) external onlyAuthorized {
1165         
1166         PoolInfo storage pool = poolInfo[0];
1167         UserInfo storage user = userInfo[wallet];
1168         if(user.boosts < maxBoostAmount){
1169             updatePool(0);
1170             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1171             user.pendingPayout = pending;
1172             totalBoostedStaked -= user.boostedAmount;
1173             user.boosts += 1;
1174             user.boostedAmount = getWalletBoostedAmount(wallet);
1175             totalBoostedStaked += user.boostedAmount;
1176             user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1177             lastWalletBoostTs[wallet] = block.timestamp;
1178         }
1179     }
1180 
1181     function removeBoost(address wallet) external onlyAuthorized {
1182         
1183         PoolInfo storage pool = poolInfo[0];
1184         UserInfo storage user = userInfo[wallet];
1185         if(user.boosts > 0){
1186             updatePool(0);
1187             uint256 pending = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12).sub(user.rewardDebt) + user.pendingPayout;
1188             user.pendingPayout = pending;
1189             totalBoostedStaked -= user.boostedAmount;
1190             user.boosts -= 1;
1191             user.boostedAmount = getWalletBoostedAmount(wallet);
1192             totalBoostedStaked += user.boostedAmount;
1193             user.rewardDebt = user.boostedAmount.mul(pool.accTokensPerShare).div(1e12);
1194         }
1195         
1196     }
1197 
1198     function updateBoosters(uint256 newMaxBoostAmount, uint256 newAmountPerBoost) external onlyOwner {
1199         require(newAmountPerBoost <= 100, "amount per boost too high");
1200         maxBoostAmount = newMaxBoostAmount;
1201         amountPerBoost = newAmountPerBoost;
1202     }
1203 }