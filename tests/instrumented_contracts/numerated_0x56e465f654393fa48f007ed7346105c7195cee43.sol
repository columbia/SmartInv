1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
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
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
275  * the optional functions; to access them see {ERC20Detailed}.
276  */
277 interface IERC20 {
278     /**
279      * @dev Returns the amount of tokens in existence.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     /**
284      * @dev Returns the amount of tokens owned by `account`.
285      */
286     function balanceOf(address account) external view returns (uint256);
287 
288     /**
289      * @dev Moves `amount` tokens from the caller's account to `recipient`.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transfer(address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Returns the remaining number of tokens that `spender` will be
299      * allowed to spend on behalf of `owner` through {transferFrom}. This is
300      * zero by default.
301      *
302      * This value changes when {approve} or {transferFrom} are called.
303      */
304     function allowance(address owner, address spender) external view returns (uint256);
305 
306     /**
307      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * IMPORTANT: Beware that changing an allowance with this method brings the risk
312      * that someone may use both the old and the new allowance by unfortunate
313      * transaction ordering. One possible solution to mitigate this race
314      * condition is to first reduce the spender's allowance to 0 and set the
315      * desired value afterwards:
316      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address spender, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Moves `amount` tokens from `sender` to `recipient` using the
324      * allowance mechanism. `amount` is then deducted from the caller's
325      * allowance.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Emitted when `value` tokens are moved from one account (`from`) to
335      * another (`to`).
336      *
337      * Note that `value` may be zero.
338      */
339     event Transfer(address indexed from, address indexed to, uint256 value);
340 
341     /**
342      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
343      * a call to {approve}. `value` is the new allowance.
344      */
345     event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 // File: openzeppelin-solidity/contracts/utils/Address.sol
349 
350 pragma solidity ^0.5.5;
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following 
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
375         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
376         // for accounts without code, i.e. `keccak256('')`
377         bytes32 codehash;
378         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
379         // solhint-disable-next-line no-inline-assembly
380         assembly { codehash := extcodehash(account) }
381         return (codehash != accountHash && codehash != 0x0);
382     }
383 
384     /**
385      * @dev Converts an `address` into `address payable`. Note that this is
386      * simply a type cast: the actual underlying value is not changed.
387      *
388      * _Available since v2.4.0._
389      */
390     function toPayable(address account) internal pure returns (address payable) {
391         return address(uint160(account));
392     }
393 
394     /**
395      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
396      * `recipient`, forwarding all available gas and reverting on errors.
397      *
398      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
399      * of certain opcodes, possibly making contracts go over the 2300 gas limit
400      * imposed by `transfer`, making them unable to receive funds via
401      * `transfer`. {sendValue} removes this limitation.
402      *
403      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
404      *
405      * IMPORTANT: because control is transferred to `recipient`, care must be
406      * taken to not create reentrancy vulnerabilities. Consider using
407      * {ReentrancyGuard} or the
408      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
409      *
410      * _Available since v2.4.0._
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         // solhint-disable-next-line avoid-call-value
416         (bool success, ) = recipient.call.value(amount)("");
417         require(success, "Address: unable to send value, recipient may have reverted");
418     }
419 }
420 
421 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
422 
423 pragma solidity ^0.5.0;
424 
425 
426 
427 
428 /**
429  * @title SafeERC20
430  * @dev Wrappers around ERC20 operations that throw on failure (when the token
431  * contract returns false). Tokens that return no value (and instead revert or
432  * throw on failure) are also supported, non-reverting calls are assumed to be
433  * successful.
434  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
435  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
436  */
437 library SafeERC20 {
438     using SafeMath for uint256;
439     using Address for address;
440 
441     function safeTransfer(IERC20 token, address to, uint256 value) internal {
442         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
443     }
444 
445     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
446         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
447     }
448 
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves.
479 
480         // A Solidity high level call has three parts:
481         //  1. The target address is checked to verify it contains contract code
482         //  2. The call itself is made, and success asserted
483         //  3. The return value is decoded, which in turn checks the size of the returned data.
484         // solhint-disable-next-line max-line-length
485         require(address(token).isContract(), "SafeERC20: call to non-contract");
486 
487         // solhint-disable-next-line avoid-low-level-calls
488         (bool success, bytes memory returndata) = address(token).call(data);
489         require(success, "SafeERC20: low-level call failed");
490 
491         if (returndata.length > 0) { // Return data is optional
492             // solhint-disable-next-line max-line-length
493             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
494         }
495     }
496 }
497 
498 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
499 
500 pragma solidity ^0.5.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
524 
525 pragma solidity ^0.5.0;
526 
527 
528 /**
529  * @dev Implementation of the {IERC165} interface.
530  *
531  * Contracts may inherit from this and call {_registerInterface} to declare
532  * their support of an interface.
533  */
534 contract ERC165 is IERC165 {
535     /*
536      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
537      */
538     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
539 
540     /**
541      * @dev Mapping of interface ids to whether or not it's supported.
542      */
543     mapping(bytes4 => bool) private _supportedInterfaces;
544 
545     constructor () internal {
546         // Derived contracts need only register support for their own interfaces,
547         // we register support for ERC165 itself here
548         _registerInterface(_INTERFACE_ID_ERC165);
549     }
550 
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      *
554      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
555      */
556     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
557         return _supportedInterfaces[interfaceId];
558     }
559 
560     /**
561      * @dev Registers the contract as an implementer of the interface defined by
562      * `interfaceId`. Support of the actual ERC165 interface is automatic and
563      * registering its interface id is not required.
564      *
565      * See {IERC165-supportsInterface}.
566      *
567      * Requirements:
568      *
569      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
570      */
571     function _registerInterface(bytes4 interfaceId) internal {
572         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
573         _supportedInterfaces[interfaceId] = true;
574     }
575 }
576 
577 // File: contracts/Layer2I.sol
578 
579 pragma solidity ^0.5.12;
580 
581 interface Layer2I {
582   function operator() external view returns (address);
583   function isLayer2() external view returns (bool);
584   function currentFork() external view returns (uint);
585   function lastEpoch(uint forkNumber) external view returns (uint);
586   function changeOperator(address _operator) external;
587 }
588 
589 // File: contracts/stake/interfaces/DepositManagerI.sol
590 
591 pragma solidity ^0.5.12;
592 
593 
594 interface DepositManagerI {
595   function owner() external view returns (address);
596   function wton() external view returns (address);
597   function registry() external view returns (address);
598   function seigManager() external view returns (address);
599 
600   function accStaked(address layer2, address account) external view returns (uint256 wtonAmount);
601   function accStakedLayer2(address layer2) external view returns (uint256 wtonAmount);
602   function accStakedAccount(address account) external view returns (uint256 wtonAmount);
603 
604   function pendingUnstaked(address layer2, address account) external view returns (uint256 wtonAmount);
605   function pendingUnstakedLayer2(address layer2) external view returns (uint256 wtonAmount);
606   function pendingUnstakedAccount(address account) external view returns (uint256 wtonAmount);
607 
608   function accUnstaked(address layer2, address account) external view returns (uint256 wtonAmount);
609   function accUnstakedLayer2(address layer2) external view returns (uint256 wtonAmount);
610   function accUnstakedAccount(address account) external view returns (uint256 wtonAmount);
611 
612 
613   function withdrawalRequestIndex(address layer2, address account) external view returns (uint256 index);
614   function withdrawalRequest(address layer2, address account, uint256 index) external view returns (uint128 withdrawableBlockNumber, uint128 amount, bool processed );
615 
616   function WITHDRAWAL_DELAY() external view returns (uint256);
617 
618   function setSeigManager(address seigManager) external;
619   function deposit(address layer2, uint256 amount) external returns (bool);
620   function requestWithdrawal(address layer2, uint256 amount) external returns (bool);
621   function processRequest(address layer2) external returns (bool);
622   function requestWithdrawalAll(address layer2) external returns (bool);
623   function processRequests(address layer2, uint256 n) external returns (bool);
624 
625   function numRequests(address layer2, address account) external view returns (uint256);
626   function numPendingRequests(address layer2, address account) external view returns (uint256);
627 
628   function slash(address layer2, address recipient, uint256 amount) external returns (bool);
629 }
630 
631 // File: contracts/stake/interfaces/Layer2RegistryI.sol
632 
633 pragma solidity ^0.5.12;
634 
635 
636 interface Layer2RegistryI {
637   function layer2s(address layer2) external view returns (bool);
638 
639   function register(address layer2) external returns (bool);
640   function numLayer2s() external view returns (uint256);
641   function layer2ByIndex(uint256 index) external view returns (address);
642 
643   function deployCoinage(address layer2, address seigManager) external returns (bool);
644   function registerAndDeployCoinage(address layer2, address seigManager) external returns (bool);
645   function unregister(address layer2) external returns (bool);
646 }
647 
648 // File: contracts/stake/interfaces/SeigManagerI.sol
649 
650 pragma solidity ^0.5.12;
651 
652 
653 interface SeigManagerI {
654   function registry() external view returns (address);
655   function depositManager() external view returns (address);
656   function ton() external view returns (address);
657   function wton() external view returns (address);
658   function powerton() external view returns (address);
659   function tot() external view returns (address);
660   function coinages(address layer2) external view returns (address);
661   function commissionRates(address layer2) external view returns (uint256);
662 
663   function lastCommitBlock(address layer2) external view returns (uint256);
664   function seigPerBlock() external view returns (uint256);
665   function lastSeigBlock() external view returns (uint256);
666   function pausedBlock() external view returns (uint256);
667   function unpausedBlock() external view returns (uint256);
668   function DEFAULT_FACTOR() external view returns (uint256);
669 
670   function deployCoinage(address layer2) external returns (bool);
671   function setCommissionRate(address layer2, uint256 commission, bool isCommissionRateNegative) external returns (bool);
672 
673   function uncomittedStakeOf(address layer2, address account) external view returns (uint256);
674   function stakeOf(address layer2, address account) external view returns (uint256);
675   function additionalTotBurnAmount(address layer2, address account, uint256 amount) external view returns (uint256 totAmount);
676 
677   function onTransfer(address sender, address recipient, uint256 amount) external returns (bool);
678   function updateSeigniorage() external returns (bool);
679   function onDeposit(address layer2, address account, uint256 amount) external returns (bool);
680   function onWithdraw(address layer2, address account, uint256 amount) external returns (bool);
681 
682 }
683 
684 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
685 
686 pragma solidity ^0.5.0;
687 
688 
689 
690 
691 /**
692  * @dev Implementation of the {IERC20} interface.
693  *
694  * This implementation is agnostic to the way tokens are created. This means
695  * that a supply mechanism has to be added in a derived contract using {_mint}.
696  * For a generic mechanism see {ERC20Mintable}.
697  *
698  * TIP: For a detailed writeup see our guide
699  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
700  * to implement supply mechanisms].
701  *
702  * We have followed general OpenZeppelin guidelines: functions revert instead
703  * of returning `false` on failure. This behavior is nonetheless conventional
704  * and does not conflict with the expectations of ERC20 applications.
705  *
706  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
707  * This allows applications to reconstruct the allowance for all accounts just
708  * by listening to said events. Other implementations of the EIP may not emit
709  * these events, as it isn't required by the specification.
710  *
711  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
712  * functions have been added to mitigate the well-known issues around setting
713  * allowances. See {IERC20-approve}.
714  */
715 contract ERC20 is Context, IERC20 {
716     using SafeMath for uint256;
717 
718     mapping (address => uint256) private _balances;
719 
720     mapping (address => mapping (address => uint256)) private _allowances;
721 
722     uint256 private _totalSupply;
723 
724     /**
725      * @dev See {IERC20-totalSupply}.
726      */
727     function totalSupply() public view returns (uint256) {
728         return _totalSupply;
729     }
730 
731     /**
732      * @dev See {IERC20-balanceOf}.
733      */
734     function balanceOf(address account) public view returns (uint256) {
735         return _balances[account];
736     }
737 
738     /**
739      * @dev See {IERC20-transfer}.
740      *
741      * Requirements:
742      *
743      * - `recipient` cannot be the zero address.
744      * - the caller must have a balance of at least `amount`.
745      */
746     function transfer(address recipient, uint256 amount) public returns (bool) {
747         _transfer(_msgSender(), recipient, amount);
748         return true;
749     }
750 
751     /**
752      * @dev See {IERC20-allowance}.
753      */
754     function allowance(address owner, address spender) public view returns (uint256) {
755         return _allowances[owner][spender];
756     }
757 
758     /**
759      * @dev See {IERC20-approve}.
760      *
761      * Requirements:
762      *
763      * - `spender` cannot be the zero address.
764      */
765     function approve(address spender, uint256 amount) public returns (bool) {
766         _approve(_msgSender(), spender, amount);
767         return true;
768     }
769 
770     /**
771      * @dev See {IERC20-transferFrom}.
772      *
773      * Emits an {Approval} event indicating the updated allowance. This is not
774      * required by the EIP. See the note at the beginning of {ERC20};
775      *
776      * Requirements:
777      * - `sender` and `recipient` cannot be the zero address.
778      * - `sender` must have a balance of at least `amount`.
779      * - the caller must have allowance for `sender`'s tokens of at least
780      * `amount`.
781      */
782     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
783         _transfer(sender, recipient, amount);
784         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
785         return true;
786     }
787 
788     /**
789      * @dev Atomically increases the allowance granted to `spender` by the caller.
790      *
791      * This is an alternative to {approve} that can be used as a mitigation for
792      * problems described in {IERC20-approve}.
793      *
794      * Emits an {Approval} event indicating the updated allowance.
795      *
796      * Requirements:
797      *
798      * - `spender` cannot be the zero address.
799      */
800     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
801         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
802         return true;
803     }
804 
805     /**
806      * @dev Atomically decreases the allowance granted to `spender` by the caller.
807      *
808      * This is an alternative to {approve} that can be used as a mitigation for
809      * problems described in {IERC20-approve}.
810      *
811      * Emits an {Approval} event indicating the updated allowance.
812      *
813      * Requirements:
814      *
815      * - `spender` cannot be the zero address.
816      * - `spender` must have allowance for the caller of at least
817      * `subtractedValue`.
818      */
819     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
820         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
821         return true;
822     }
823 
824     /**
825      * @dev Moves tokens `amount` from `sender` to `recipient`.
826      *
827      * This is internal function is equivalent to {transfer}, and can be used to
828      * e.g. implement automatic token fees, slashing mechanisms, etc.
829      *
830      * Emits a {Transfer} event.
831      *
832      * Requirements:
833      *
834      * - `sender` cannot be the zero address.
835      * - `recipient` cannot be the zero address.
836      * - `sender` must have a balance of at least `amount`.
837      */
838     function _transfer(address sender, address recipient, uint256 amount) internal {
839         require(sender != address(0), "ERC20: transfer from the zero address");
840         require(recipient != address(0), "ERC20: transfer to the zero address");
841 
842         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
843         _balances[recipient] = _balances[recipient].add(amount);
844         emit Transfer(sender, recipient, amount);
845     }
846 
847     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
848      * the total supply.
849      *
850      * Emits a {Transfer} event with `from` set to the zero address.
851      *
852      * Requirements
853      *
854      * - `to` cannot be the zero address.
855      */
856     function _mint(address account, uint256 amount) internal {
857         require(account != address(0), "ERC20: mint to the zero address");
858 
859         _totalSupply = _totalSupply.add(amount);
860         _balances[account] = _balances[account].add(amount);
861         emit Transfer(address(0), account, amount);
862     }
863 
864     /**
865      * @dev Destroys `amount` tokens from `account`, reducing the
866      * total supply.
867      *
868      * Emits a {Transfer} event with `to` set to the zero address.
869      *
870      * Requirements
871      *
872      * - `account` cannot be the zero address.
873      * - `account` must have at least `amount` tokens.
874      */
875     function _burn(address account, uint256 amount) internal {
876         require(account != address(0), "ERC20: burn from the zero address");
877 
878         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
879         _totalSupply = _totalSupply.sub(amount);
880         emit Transfer(account, address(0), amount);
881     }
882 
883     /**
884      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
885      *
886      * This is internal function is equivalent to `approve`, and can be used to
887      * e.g. set automatic allowances for certain subsystems, etc.
888      *
889      * Emits an {Approval} event.
890      *
891      * Requirements:
892      *
893      * - `owner` cannot be the zero address.
894      * - `spender` cannot be the zero address.
895      */
896     function _approve(address owner, address spender, uint256 amount) internal {
897         require(owner != address(0), "ERC20: approve from the zero address");
898         require(spender != address(0), "ERC20: approve to the zero address");
899 
900         _allowances[owner][spender] = amount;
901         emit Approval(owner, spender, amount);
902     }
903 
904     /**
905      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
906      * from the caller's allowance.
907      *
908      * See {_burn} and {_approve}.
909      */
910     function _burnFrom(address account, uint256 amount) internal {
911         _burn(account, amount);
912         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
913     }
914 }
915 
916 // File: openzeppelin-solidity/contracts/access/Roles.sol
917 
918 pragma solidity ^0.5.0;
919 
920 /**
921  * @title Roles
922  * @dev Library for managing addresses assigned to a Role.
923  */
924 library Roles {
925     struct Role {
926         mapping (address => bool) bearer;
927     }
928 
929     /**
930      * @dev Give an account access to this role.
931      */
932     function add(Role storage role, address account) internal {
933         require(!has(role, account), "Roles: account already has role");
934         role.bearer[account] = true;
935     }
936 
937     /**
938      * @dev Remove an account's access to this role.
939      */
940     function remove(Role storage role, address account) internal {
941         require(has(role, account), "Roles: account does not have role");
942         role.bearer[account] = false;
943     }
944 
945     /**
946      * @dev Check if an account has this role.
947      * @return bool
948      */
949     function has(Role storage role, address account) internal view returns (bool) {
950         require(account != address(0), "Roles: account is the zero address");
951         return role.bearer[account];
952     }
953 }
954 
955 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
956 
957 pragma solidity ^0.5.0;
958 
959 
960 
961 contract MinterRole is Context {
962     using Roles for Roles.Role;
963 
964     event MinterAdded(address indexed account);
965     event MinterRemoved(address indexed account);
966 
967     Roles.Role private _minters;
968 
969     constructor () internal {
970         _addMinter(_msgSender());
971     }
972 
973     modifier onlyMinter() {
974         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
975         _;
976     }
977 
978     function isMinter(address account) public view returns (bool) {
979         return _minters.has(account);
980     }
981 
982     function addMinter(address account) public onlyMinter {
983         _addMinter(account);
984     }
985 
986     function renounceMinter() public {
987         _removeMinter(_msgSender());
988     }
989 
990     function _addMinter(address account) internal {
991         _minters.add(account);
992         emit MinterAdded(account);
993     }
994 
995     function _removeMinter(address account) internal {
996         _minters.remove(account);
997         emit MinterRemoved(account);
998     }
999 }
1000 
1001 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1002 
1003 pragma solidity ^0.5.0;
1004 
1005 
1006 
1007 /**
1008  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1009  * which have permission to mint (create) new tokens as they see fit.
1010  *
1011  * At construction, the deployer of the contract is the only minter.
1012  */
1013 contract ERC20Mintable is ERC20, MinterRole {
1014     /**
1015      * @dev See {ERC20-_mint}.
1016      *
1017      * Requirements:
1018      *
1019      * - the caller must have the {MinterRole}.
1020      */
1021     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1022         _mint(account, amount);
1023         return true;
1024     }
1025 }
1026 
1027 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
1028 
1029 pragma solidity ^0.5.0;
1030 
1031 
1032 
1033 /**
1034  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1035  * tokens and those that they have an allowance for, in a way that can be
1036  * recognized off-chain (via event analysis).
1037  */
1038 contract ERC20Burnable is Context, ERC20 {
1039     /**
1040      * @dev Destroys `amount` tokens from the caller.
1041      *
1042      * See {ERC20-_burn}.
1043      */
1044     function burn(uint256 amount) public {
1045         _burn(_msgSender(), amount);
1046     }
1047 
1048     /**
1049      * @dev See {ERC20-_burnFrom}.
1050      */
1051     function burnFrom(address account, uint256 amount) public {
1052         _burnFrom(account, amount);
1053     }
1054 }
1055 
1056 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1057 
1058 pragma solidity ^0.5.0;
1059 
1060 
1061 /**
1062  * @dev Optional functions from the ERC20 standard.
1063  */
1064 contract ERC20Detailed is IERC20 {
1065     string private _name;
1066     string private _symbol;
1067     uint8 private _decimals;
1068 
1069     /**
1070      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1071      * these values are immutable: they can only be set once during
1072      * construction.
1073      */
1074     constructor (string memory name, string memory symbol, uint8 decimals) public {
1075         _name = name;
1076         _symbol = symbol;
1077         _decimals = decimals;
1078     }
1079 
1080     /**
1081      * @dev Returns the name of the token.
1082      */
1083     function name() public view returns (string memory) {
1084         return _name;
1085     }
1086 
1087     /**
1088      * @dev Returns the symbol of the token, usually a shorter version of the
1089      * name.
1090      */
1091     function symbol() public view returns (string memory) {
1092         return _symbol;
1093     }
1094 
1095     /**
1096      * @dev Returns the number of decimals used to get its user representation.
1097      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1098      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1099      *
1100      * Tokens usually opt for a value of 18, imitating the relationship between
1101      * Ether and Wei.
1102      *
1103      * NOTE: This information is only used for _display_ purposes: it in
1104      * no way affects any of the arithmetic of the contract, including
1105      * {IERC20-balanceOf} and {IERC20-transfer}.
1106      */
1107     function decimals() public view returns (uint8) {
1108         return _decimals;
1109     }
1110 }
1111 
1112 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
1113 
1114 pragma solidity ^0.5.0;
1115 
1116 /**
1117  * @dev Contract module that helps prevent reentrant calls to a function.
1118  *
1119  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1120  * available, which can be applied to functions to make sure there are no nested
1121  * (reentrant) calls to them.
1122  *
1123  * Note that because there is a single `nonReentrant` guard, functions marked as
1124  * `nonReentrant` may not call one another. This can be worked around by making
1125  * those functions `private`, and then adding `external` `nonReentrant` entry
1126  * points to them.
1127  *
1128  * TIP: If you would like to learn more about reentrancy and alternative ways
1129  * to protect against it, check out our blog post
1130  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1131  *
1132  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
1133  * metering changes introduced in the Istanbul hardfork.
1134  */
1135 contract ReentrancyGuard {
1136     bool private _notEntered;
1137 
1138     constructor () internal {
1139         // Storing an initial non-zero value makes deployment a bit more
1140         // expensive, but in exchange the refund on every call to nonReentrant
1141         // will be lower in amount. Since refunds are capped to a percetange of
1142         // the total transaction's gas, it is best to keep them low in cases
1143         // like this one, to increase the likelihood of the full refund coming
1144         // into effect.
1145         _notEntered = true;
1146     }
1147 
1148     /**
1149      * @dev Prevents a contract from calling itself, directly or indirectly.
1150      * Calling a `nonReentrant` function from another `nonReentrant`
1151      * function is not supported. It is possible to prevent this from happening
1152      * by making the `nonReentrant` function external, and make it call a
1153      * `private` function that does the actual work.
1154      */
1155     modifier nonReentrant() {
1156         // On the first call to nonReentrant, _notEntered will be true
1157         require(_notEntered, "ReentrancyGuard: reentrant call");
1158 
1159         // Any calls to nonReentrant after this point will fail
1160         _notEntered = false;
1161 
1162         _;
1163 
1164         // By storing the original value once again, a refund is triggered (see
1165         // https://eips.ethereum.org/EIPS/eip-2200)
1166         _notEntered = true;
1167     }
1168 }
1169 
1170 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
1171 
1172 pragma solidity ^0.5.10;
1173 
1174 /**
1175  * @dev Library used to query support of an interface declared via {IERC165}.
1176  *
1177  * Note that these functions return the actual result of the query: they do not
1178  * `revert` if an interface is not supported. It is up to the caller to decide
1179  * what to do in these cases.
1180  */
1181 library ERC165Checker {
1182     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1183     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1184 
1185     /*
1186      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1187      */
1188     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1189 
1190     /**
1191      * @dev Returns true if `account` supports the {IERC165} interface,
1192      */
1193     function _supportsERC165(address account) internal view returns (bool) {
1194         // Any contract that implements ERC165 must explicitly indicate support of
1195         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1196         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1197             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1198     }
1199 
1200     /**
1201      * @dev Returns true if `account` supports the interface defined by
1202      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1203      *
1204      * See {IERC165-supportsInterface}.
1205      */
1206     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1207         // query support of both ERC165 as per the spec and support of _interfaceId
1208         return _supportsERC165(account) &&
1209             _supportsERC165Interface(account, interfaceId);
1210     }
1211 
1212     /**
1213      * @dev Returns true if `account` supports all the interfaces defined in
1214      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1215      *
1216      * Batch-querying can lead to gas savings by skipping repeated checks for
1217      * {IERC165} support.
1218      *
1219      * See {IERC165-supportsInterface}.
1220      */
1221     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1222         // query support of ERC165 itself
1223         if (!_supportsERC165(account)) {
1224             return false;
1225         }
1226 
1227         // query support of each interface in _interfaceIds
1228         for (uint256 i = 0; i < interfaceIds.length; i++) {
1229             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1230                 return false;
1231             }
1232         }
1233 
1234         // all interfaces supported
1235         return true;
1236     }
1237 
1238     /**
1239      * @notice Query if a contract implements an interface, does not check ERC165 support
1240      * @param account The address of the contract to query for support of an interface
1241      * @param interfaceId The interface identifier, as specified in ERC-165
1242      * @return true if the contract at account indicates support of the interface with
1243      * identifier interfaceId, false otherwise
1244      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1245      * the behavior of this method is undefined. This precondition can be checked
1246      * with the `supportsERC165` method in this library.
1247      * Interface identification is specified in ERC-165.
1248      */
1249     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1250         // success determines whether the staticcall succeeded and result determines
1251         // whether the contract at account indicates support of _interfaceId
1252         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1253 
1254         return (success && result);
1255     }
1256 
1257     /**
1258      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1259      * @param account The address of the contract to query for support of an interface
1260      * @param interfaceId The interface identifier, as specified in ERC-165
1261      * @return success true if the STATICCALL succeeded, false otherwise
1262      * @return result true if the STATICCALL succeeded and the contract at account
1263      * indicates support of the interface with identifier interfaceId, false otherwise
1264      */
1265     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1266         private
1267         view
1268         returns (bool, bool)
1269     {
1270         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1271         (bool success, bytes memory result) = account.staticcall.gas(30000)(encodedParams);
1272         if (result.length < 32) return (false, false);
1273         return (success, abi.decode(result, (bool)));
1274     }
1275 }
1276 
1277 // File: coinage-token/contracts/lib/DSMath.sol
1278 
1279 // https://github.com/dapphub/ds-math/blob/de45767/src/math.sol
1280 /// math.sol -- mixin for inline numerical wizardry
1281 
1282 // This program is free software: you can redistribute it and/or modify
1283 // it under the terms of the GNU General Public License as published by
1284 // the Free Software Foundation, either version 3 of the License, or
1285 // (at your option) any later version.
1286 
1287 // This program is distributed in the hope that it will be useful,
1288 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1289 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1290 // GNU General Public License for more details.
1291 
1292 // You should have received a copy of the GNU General Public License
1293 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1294 
1295 pragma solidity >0.4.13;
1296 
1297 contract DSMath {
1298   function add(uint x, uint y) internal pure returns (uint z) {
1299     require((z = x + y) >= x, "ds-math-add-overflow");
1300   }
1301   function sub(uint x, uint y) internal pure returns (uint z) {
1302     require((z = x - y) <= x, "ds-math-sub-underflow");
1303   }
1304   function mul(uint x, uint y) internal pure returns (uint z) {
1305     require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
1306   }
1307 
1308   function min(uint x, uint y) internal pure returns (uint z) {
1309     return x <= y ? x : y;
1310   }
1311   function max(uint x, uint y) internal pure returns (uint z) {
1312     return x >= y ? x : y;
1313   }
1314   function imin(int x, int y) internal pure returns (int z) {
1315     return x <= y ? x : y;
1316   }
1317   function imax(int x, int y) internal pure returns (int z) {
1318     return x >= y ? x : y;
1319   }
1320 
1321   uint constant WAD = 10 ** 18;
1322   uint constant RAY = 10 ** 27;
1323 
1324   function wmul(uint x, uint y) internal pure returns (uint z) {
1325     z = add(mul(x, y), WAD / 2) / WAD;
1326   }
1327   function rmul(uint x, uint y) internal pure returns (uint z) {
1328     z = add(mul(x, y), RAY / 2) / RAY;
1329   }
1330   function wdiv(uint x, uint y) internal pure returns (uint z) {
1331     z = add(mul(x, WAD), y / 2) / y;
1332   }
1333   function rdiv(uint x, uint y) internal pure returns (uint z) {
1334     z = add(mul(x, RAY), y / 2) / y;
1335   }
1336 
1337   // This famous algorithm is called "exponentiation by squaring"
1338   // and calculates x^n with x as fixed-point and n as regular unsigned.
1339   //
1340   // It's O(log n), instead of O(n) for naive repeated multiplication.
1341   //
1342   // These facts are why it works:
1343   //
1344   //  If n is even, then x^n = (x^2)^(n/2).
1345   //  If n is odd,  then x^n = x * x^(n-1),
1346   //   and applying the equation for even x gives
1347   //  x^n = x * (x^2)^((n-1) / 2).
1348   //
1349   //  Also, EVM division is flooring and
1350   //  floor[(n-1) / 2] = floor[n / 2].
1351   //
1352   function wpow(uint x, uint n) internal pure returns (uint z) {
1353     z = n % 2 != 0 ? x : WAD;
1354 
1355     for (n /= 2; n != 0; n /= 2) {
1356       x = wmul(x, x);
1357 
1358       if (n % 2 != 0) {
1359         z = wmul(z, x);
1360       }
1361     }
1362   }
1363 
1364   function rpow(uint x, uint n) internal pure returns (uint z) {
1365     z = n % 2 != 0 ? x : RAY;
1366 
1367     for (n /= 2; n != 0; n /= 2) {
1368       x = rmul(x, x);
1369 
1370       if (n % 2 != 0) {
1371         z = rmul(z, x);
1372       }
1373     }
1374   }
1375 }
1376 
1377 // File: contracts/stake/tokens/OnApprove.sol
1378 
1379 pragma solidity ^0.5.12;
1380 
1381 
1382 contract OnApprove is ERC165 {
1383   constructor() public {
1384     _registerInterface(OnApprove(this).onApprove.selector);
1385   }
1386 
1387   function onApprove(address owner, address spender, uint256 amount, bytes calldata data) external returns (bool);
1388 }
1389 
1390 // File: contracts/stake/tokens/ERC20OnApprove.sol
1391 
1392 pragma solidity ^0.5.12;
1393 
1394 
1395 
1396 
1397 
1398 contract ERC20OnApprove is ERC20 {
1399   function approveAndCall(address spender, uint256 amount, bytes memory data) public returns (bool) {
1400     require(approve(spender, amount));
1401     _callOnApprove(msg.sender, spender, amount, data);
1402     return true;
1403   }
1404 
1405   function _callOnApprove(address owner, address spender, uint256 amount, bytes memory data) internal {
1406     bytes4 onApproveSelector = OnApprove(spender).onApprove.selector;
1407 
1408     require(ERC165Checker._supportsInterface(spender, onApproveSelector),
1409       "ERC20OnApprove: spender doesn't support onApprove");
1410 
1411     (bool ok, bytes memory res) = spender.call(
1412       abi.encodeWithSelector(
1413         onApproveSelector,
1414         owner,
1415         spender,
1416         amount,
1417         data
1418       )
1419     );
1420 
1421     // check if low-level call reverted or not
1422     require(ok, string(res));
1423 
1424     assembly {
1425       ok := mload(add(res, 0x20))
1426     }
1427 
1428     // check if OnApprove.onApprove returns true or false
1429     require(ok, "ERC20OnApprove: failed to call onApprove");
1430   }
1431 
1432 }
1433 
1434 // File: contracts/stake/tokens/AuthController.sol
1435 
1436 pragma solidity ^0.5.12;
1437 
1438 
1439 
1440 interface MinterRoleRenounceTarget {
1441   function renounceMinter() external;
1442 }
1443 
1444 interface PauserRoleRenounceTarget {
1445   function renouncePauser() external;
1446 }
1447 
1448 interface OwnableTarget {
1449   function renounceOwnership() external;
1450   function transferOwnership(address newOwner) external;
1451 }
1452 
1453 contract AuthController is Ownable {
1454   function renounceMinter(address target) public onlyOwner {
1455     MinterRoleRenounceTarget(target).renounceMinter();
1456   }
1457 
1458   function renouncePauser(address target) public onlyOwner {
1459     PauserRoleRenounceTarget(target).renouncePauser();
1460   }
1461 
1462   function renounceOwnership(address target) public onlyOwner {
1463     OwnableTarget(target).renounceOwnership();
1464   }
1465 
1466   function transferOwnership(address target, address newOwner) public onlyOwner {
1467     OwnableTarget(target).transferOwnership(newOwner);
1468   }
1469 }
1470 
1471 // File: contracts/stake/tokens/SeigToken.sol
1472 
1473 pragma solidity ^0.5.12;
1474 
1475 
1476 
1477 
1478 
1479 
1480 
1481 contract SeigToken is ERC20, Ownable, ERC20OnApprove, AuthController {
1482   SeigManagerI public seigManager;
1483   bool public callbackEnabled;
1484 
1485   function enableCallback(bool _callbackEnabled) external onlyOwner {
1486     callbackEnabled = _callbackEnabled;
1487   }
1488 
1489   function setSeigManager(SeigManagerI _seigManager) external onlyOwner {
1490     seigManager = _seigManager;
1491   }
1492 
1493   //////////////////////
1494   // Override ERC20 functions
1495   //////////////////////
1496 
1497   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1498     return super.transferFrom(sender, recipient, amount);
1499   }
1500 
1501   function _transfer(address sender, address recipient, uint256 amount) internal {
1502     super._transfer(sender, recipient, amount);
1503     if (callbackEnabled && address(seigManager) != address(0)) {
1504       require(seigManager.onTransfer(sender, recipient, amount));
1505     }
1506   }
1507 
1508   function _mint(address account, uint256 amount) internal {
1509     super._mint(account, amount);
1510     if (callbackEnabled && address(seigManager) != address(0)) {
1511       require(seigManager.onTransfer(address(0), account, amount));
1512     }
1513   }
1514 
1515   function _burn(address account, uint256 amount) internal {
1516     super._burn(account, amount);
1517     if (callbackEnabled && address(seigManager) != address(0)) {
1518       require(seigManager.onTransfer(account, address(0), amount));
1519     }
1520   }
1521 }
1522 
1523 // File: contracts/stake/tokens/WTON.sol
1524 
1525 pragma solidity ^0.5.12;
1526 
1527 
1528 
1529 
1530 
1531 
1532 
1533 
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 contract WTON is DSMath, ReentrancyGuard, Ownable, ERC20Mintable, ERC20Burnable, ERC20Detailed, SeigToken, OnApprove {
1544   using SafeERC20 for ERC20Mintable;
1545 
1546   ERC20Mintable public ton;
1547 
1548   constructor (
1549     ERC20Mintable _ton
1550   )
1551     public
1552     ERC20Detailed("Wrapped TON", "WTON", 27)
1553   {
1554     require(ERC20Detailed(address(_ton)).decimals() == 18, "WTON: decimals of TON must be 18");
1555     ton = _ton;
1556   }
1557 
1558   //////////////////////
1559   // TON Approve callback
1560   //////////////////////
1561 
1562   function onApprove(
1563     address owner,
1564     address spender,
1565     uint256 tonAmount,
1566     bytes calldata data
1567   ) external returns (bool) {
1568     require(msg.sender == address(ton), "WTON: only accept TON approve callback");
1569 
1570     // swap owner's TON to WTON
1571     _swapFromTON(owner, owner, tonAmount);
1572 
1573     uint256 wtonAmount = _toRAY(tonAmount);
1574     (address depositManager, address layer2) = _decodeTONApproveData(data);
1575 
1576     // approve WTON to DepositManager
1577     _approve(owner, depositManager, wtonAmount);
1578 
1579     // call DepositManager.onApprove to deposit WTON
1580     bytes memory depositManagerOnApproveData = _encodeDepositManagerOnApproveData(layer2);
1581     _callOnApprove(owner, depositManager, wtonAmount, depositManagerOnApproveData);
1582 
1583     return true;
1584   }
1585 
1586   /**
1587    * @dev data is 64 bytes of 2 addresses in left-padded 32 bytes
1588    */
1589   function _decodeTONApproveData(
1590     bytes memory data
1591   ) internal pure returns (address depositManager, address layer2) {
1592     require(data.length == 0x40);
1593 
1594     assembly {
1595       depositManager := mload(add(data, 0x20))
1596       layer2 := mload(add(data, 0x40))
1597     }
1598   }
1599 
1600   function _encodeDepositManagerOnApproveData(
1601     address layer2
1602   ) internal pure returns (bytes memory data) {
1603     data = new bytes(0x20);
1604 
1605     assembly {
1606       mstore(add(data, 0x20), layer2)
1607     }
1608   }
1609 
1610 
1611   //////////////////////
1612   // Override ERC20 functions
1613   //////////////////////
1614 
1615   function burnFrom(address account, uint256 amount) public {
1616     if (isMinter(msg.sender)) {
1617       _burn(account, amount);
1618       return;
1619     }
1620 
1621     super.burnFrom(account, amount);
1622   }
1623 
1624   //////////////////////
1625   // Swap functions
1626   //////////////////////
1627 
1628   /**
1629    * @dev swap WTON to TON
1630    */
1631   function swapToTON(uint256 wtonAmount) public nonReentrant returns (bool) {
1632     return _swapToTON(msg.sender, msg.sender, wtonAmount);
1633   }
1634 
1635   /**
1636    * @dev swap TON to WTON
1637    */
1638   function swapFromTON(uint256 tonAmount) public nonReentrant returns (bool) {
1639     return _swapFromTON(msg.sender, msg.sender, tonAmount);
1640   }
1641 
1642   /**
1643    * @dev swap WTON to TON, and transfer TON
1644    * NOTE: TON's transfer event's `from` argument is not `msg.sender` but `WTON` address.
1645    */
1646   function swapToTONAndTransfer(address to, uint256 wtonAmount) public nonReentrant returns (bool) {
1647     return _swapToTON(to, msg.sender, wtonAmount);
1648   }
1649 
1650   /**
1651    * @dev swap TON to WTON, and transfer WTON
1652    */
1653   function swapFromTONAndTransfer(address to, uint256 tonAmount) public nonReentrant returns (bool) {
1654     return _swapFromTON(msg.sender, to, tonAmount);
1655   }
1656 
1657   function renounceTonMinter() external onlyOwner {
1658     ton.renounceMinter();
1659   }
1660 
1661   //////////////////////
1662   // Internal functions
1663   //////////////////////
1664 
1665   function _swapToTON(address tonAccount, address wtonAccount, uint256 wtonAmount) internal returns (bool) {
1666     _burn(wtonAccount, wtonAmount);
1667 
1668     // mint TON if WTON contract has not enough TON to transfer
1669     uint256 tonAmount = _toWAD(wtonAmount);
1670     uint256 tonBalance = ton.balanceOf(address(this));
1671     if (tonBalance < tonAmount) {
1672       ton.mint(address(this), tonAmount.sub(tonBalance));
1673     }
1674 
1675     ton.safeTransfer(tonAccount, tonAmount);
1676     return true;
1677   }
1678 
1679   function _swapFromTON(address tonAccount, address wtonAccount, uint256 tonAmount) internal returns (bool) {
1680     _mint(wtonAccount, _toRAY(tonAmount));
1681     ton.safeTransferFrom(tonAccount, address(this), tonAmount);
1682     return true;
1683   }
1684 
1685   /**
1686    * @dev transform WAD to RAY
1687    */
1688   function _toRAY(uint256 v) internal pure returns (uint256) {
1689     return v * 10 ** 9;
1690   }
1691 
1692   /**
1693    * @dev transform RAY to WAD
1694    */
1695   function _toWAD(uint256 v) internal pure returns (uint256) {
1696     return v / 10 ** 9;
1697   }
1698 }
1699 
1700 // File: contracts/stake/managers/DepositManager.sol
1701 
1702 pragma solidity ^0.5.12;
1703 
1704 
1705 
1706 
1707 
1708 
1709 
1710 
1711 
1712 
1713 
1714 
1715 // TODO: add events
1716 // TODO: check deposit/withdraw WTON amount (1e27)
1717 
1718 /**
1719  * @dev DepositManager manages WTON deposit and withdrawal from operator and WTON holders.
1720  */
1721 contract DepositManager is Ownable, ERC165, OnApprove {
1722   using SafeMath for uint256;
1723   using SafeERC20 for WTON;
1724 
1725   ////////////////////
1726   // Storage - contracts
1727   ////////////////////
1728 
1729   WTON internal _wton;
1730   Layer2RegistryI internal _registry;
1731   SeigManagerI internal _seigManager;
1732 
1733   ////////////////////
1734   // Storage - token amount
1735   ////////////////////
1736 
1737   // accumulated staked amount
1738   // layer2 => msg.sender => wton amount
1739   mapping (address => mapping (address => uint256)) internal _accStaked;
1740   // layer2 => wton amount
1741   mapping (address => uint256) internal _accStakedLayer2;
1742   // msg.sender => wton amount
1743   mapping (address => uint256) internal _accStakedAccount;
1744 
1745   // pending unstaked amount
1746   // layer2 => msg.sender => wton amount
1747   mapping (address => mapping (address => uint256)) internal _pendingUnstaked;
1748   // layer2 => wton amount
1749   mapping (address => uint256) internal _pendingUnstakedLayer2;
1750   // msg.sender => wton amount
1751   mapping (address => uint256) internal _pendingUnstakedAccount;
1752 
1753   // accumulated unstaked amount
1754   // layer2 => msg.sender => wton amount
1755   mapping (address => mapping (address => uint256)) internal _accUnstaked;
1756   // layer2 => wton amount
1757   mapping (address => uint256) internal _accUnstakedLayer2;
1758   // msg.sender => wton amount
1759   mapping (address => uint256) internal _accUnstakedAccount;
1760 
1761   // layer2 => msg.sender => withdrawal requests
1762   mapping (address => mapping (address => WithdrawalReqeust[])) internal _withdrawalRequests;
1763 
1764   // layer2 => msg.sender => index
1765   mapping (address => mapping (address => uint256)) internal _withdrawalRequestIndex;
1766 
1767   ////////////////////
1768   // Storage - configuration / ERC165 interfaces
1769   ////////////////////
1770 
1771   // withdrawal delay in block number
1772   // @TODO: change delay unit to CYCLE?
1773   uint256 public globalWithdrawalDelay;
1774   mapping (address => uint256) public withdrawalDelay;
1775 
1776   struct WithdrawalReqeust {
1777     uint128 withdrawableBlockNumber;
1778     uint128 amount;
1779     bool processed;
1780   }
1781 
1782   ////////////////////
1783   // Modifiers
1784   ////////////////////
1785 
1786   modifier onlyLayer2(address layer2) {
1787     require(_registry.layer2s(layer2));
1788     _;
1789   }
1790 
1791   modifier onlySeigManager() {
1792     require(msg.sender == address(_seigManager));
1793     _;
1794   }
1795 
1796   ////////////////////
1797   // Events
1798   ////////////////////
1799 
1800   event Deposited(address indexed layer2, address depositor, uint256 amount);
1801   event WithdrawalRequested(address indexed layer2, address depositor, uint256 amount);
1802   event WithdrawalProcessed(address indexed layer2, address depositor, uint256 amount);
1803 
1804   ////////////////////
1805   // Constructor
1806   ////////////////////
1807 
1808   constructor (
1809     WTON wton,
1810     Layer2RegistryI registry,
1811     uint256 globalWithdrawalDelay_
1812   ) public {
1813     _wton = wton;
1814     _registry = registry;
1815     globalWithdrawalDelay = globalWithdrawalDelay_;
1816   }
1817 
1818   ////////////////////
1819   // SeiManager function
1820   ////////////////////
1821 
1822   function setSeigManager(SeigManagerI seigManager) external onlyOwner {
1823     _seigManager = seigManager;
1824   }
1825 
1826   ////////////////////
1827   // ERC20 Approve callback
1828   ////////////////////
1829 
1830   function onApprove(
1831     address owner,
1832     address spender,
1833     uint256 amount,
1834     bytes calldata data
1835   ) external returns (bool) {
1836     require(msg.sender == address(_wton), "DepositManager: only accept WTON approve callback");
1837 
1838     address layer2 = _decodeDepositManagerOnApproveData(data);
1839     require(_deposit(layer2, owner, amount));
1840 
1841     return true;
1842   }
1843 
1844   function _decodeDepositManagerOnApproveData(
1845     bytes memory data
1846   ) internal pure returns (address layer2) {
1847     require(data.length == 0x20);
1848 
1849     assembly {
1850       layer2 := mload(add(data, 0x20))
1851     }
1852   }
1853 
1854   ////////////////////
1855   // Deposit function
1856   ////////////////////
1857 
1858   /**
1859    * @dev deposit `amount` WTON in RAY
1860    */
1861 
1862   function deposit(address layer2, uint256 amount) external returns (bool) {
1863     require(_deposit(layer2, msg.sender, amount));
1864   }
1865 
1866   function _deposit(address layer2, address account, uint256 amount) internal onlyLayer2(layer2) returns (bool) {
1867     _accStaked[layer2][account] = _accStaked[layer2][account].add(amount);
1868     _accStakedLayer2[layer2] = _accStakedLayer2[layer2].add(amount);
1869     _accStakedAccount[account] = _accStakedAccount[account].add(amount);
1870 
1871     _wton.safeTransferFrom(account, address(this), amount);
1872 
1873     emit Deposited(layer2, account, amount);
1874 
1875     require(_seigManager.onDeposit(layer2, account, amount));
1876 
1877     return true;
1878   }
1879 
1880   ////////////////////
1881   // Re-deposit function
1882   ////////////////////
1883 
1884   /**
1885    * @dev re-deposit pending requests in the pending queue
1886    */
1887 
1888   function redeposit(address layer2) external returns (bool) {
1889     uint256 i = _withdrawalRequestIndex[layer2][msg.sender];
1890     require(_redeposit(layer2, i, 1));
1891   }
1892 
1893   function redepositMulti(address layer2, uint256 n) external returns (bool) {
1894     uint256 i = _withdrawalRequestIndex[layer2][msg.sender];
1895     require(_redeposit(layer2, i, n));
1896   }
1897 
1898   function _redeposit(address layer2, uint256 i, uint256 n) internal onlyLayer2(layer2) returns (bool) {
1899     uint256 accAmount;
1900 
1901     require(_withdrawalRequests[layer2][msg.sender].length > 0, "DepositManager: no request");
1902     require(_withdrawalRequests[layer2][msg.sender].length - i >= n, "DepositManager: n exceeds num of pending requests");
1903 
1904     uint256 e = i + n;
1905     for (; i < e; i++) {
1906       WithdrawalReqeust storage r = _withdrawalRequests[layer2][msg.sender][i];
1907       uint256 amount = r.amount;
1908 
1909       require(!r.processed, "DepositManager: pending request already processed");
1910       require(amount > 0, "DepositManager: no valid pending request");
1911 
1912       accAmount = accAmount.add(amount);
1913       r.processed = true;
1914     }
1915 
1916 
1917     // deposit-related storages
1918     _accStaked[layer2][msg.sender] = _accStaked[layer2][msg.sender].add(accAmount);
1919     _accStakedLayer2[layer2] = _accStakedLayer2[layer2].add(accAmount);
1920     _accStakedAccount[msg.sender] = _accStakedAccount[msg.sender].add(accAmount);
1921 
1922     // withdrawal-related storages
1923     _pendingUnstaked[layer2][msg.sender] = _pendingUnstaked[layer2][msg.sender].sub(accAmount);
1924     _pendingUnstakedLayer2[layer2] = _pendingUnstakedLayer2[layer2].sub(accAmount);
1925     _pendingUnstakedAccount[msg.sender] = _pendingUnstakedAccount[msg.sender].sub(accAmount);
1926 
1927     _withdrawalRequestIndex[layer2][msg.sender] += n;
1928 
1929     emit Deposited(layer2, msg.sender, accAmount);
1930 
1931     require(_seigManager.onDeposit(layer2, msg.sender, accAmount));
1932 
1933     return true;
1934   }
1935 
1936   ////////////////////
1937   // Slash functions
1938   ////////////////////
1939 
1940   function slash(address layer2, address recipient, uint256 amount) external onlySeigManager returns (bool) {
1941     //return _wton.transferFrom(owner, recipient, amount);
1942   }
1943 
1944   ////////////////////
1945   // Setter
1946   ////////////////////
1947 
1948   function setGlobalWithdrawalDelay(uint256 globalWithdrawalDelay_) external onlyOwner {
1949     globalWithdrawalDelay = globalWithdrawalDelay_;
1950   }
1951 
1952   function setWithdrawalDelay(address l2chain, uint256 withdrawalDelay_) external {
1953     require(_isOperator(l2chain, msg.sender));
1954     withdrawalDelay[l2chain] = withdrawalDelay_;
1955   }
1956 
1957   ////////////////////
1958   // Withdrawal functions
1959   ////////////////////
1960 
1961   function requestWithdrawal(address layer2, uint256 amount) external returns (bool) {
1962     return _requestWithdrawal(layer2, amount);
1963   }
1964 
1965   function _requestWithdrawal(address layer2, uint256 amount) internal onlyLayer2(layer2) returns (bool) {
1966     require(amount > 0, "DepositManager: amount must not be zero");
1967 
1968     uint256 delay = globalWithdrawalDelay > withdrawalDelay[layer2] ? globalWithdrawalDelay : withdrawalDelay[layer2];
1969     _withdrawalRequests[layer2][msg.sender].push(WithdrawalReqeust({
1970       withdrawableBlockNumber: uint128(block.number + delay),
1971       amount: uint128(amount),
1972       processed: false
1973     }));
1974 
1975     _pendingUnstaked[layer2][msg.sender] = _pendingUnstaked[layer2][msg.sender].add(amount);
1976     _pendingUnstakedLayer2[layer2] = _pendingUnstakedLayer2[layer2].add(amount);
1977     _pendingUnstakedAccount[msg.sender] = _pendingUnstakedAccount[msg.sender].add(amount);
1978 
1979     emit WithdrawalRequested(layer2, msg.sender, amount);
1980 
1981     require(_seigManager.onWithdraw(layer2, msg.sender, amount));
1982 
1983     return true;
1984   }
1985 
1986   function processRequest(address layer2, bool receiveTON) external returns (bool) {
1987     return _processRequest(layer2, receiveTON);
1988   }
1989 
1990   function _processRequest(address layer2, bool receiveTON) internal returns (bool) {
1991     uint256 index = _withdrawalRequestIndex[layer2][msg.sender];
1992     require(_withdrawalRequests[layer2][msg.sender].length > index, "DepositManager: no request to process");
1993 
1994     WithdrawalReqeust storage r = _withdrawalRequests[layer2][msg.sender][index];
1995 
1996     require(r.withdrawableBlockNumber <= block.number, "DepositManager: wait for withdrawal delay");
1997     r.processed = true;
1998 
1999     _withdrawalRequestIndex[layer2][msg.sender] += 1;
2000 
2001     uint256 amount = r.amount;
2002 
2003     _pendingUnstaked[layer2][msg.sender] = _pendingUnstaked[layer2][msg.sender].sub(amount);
2004     _pendingUnstakedLayer2[layer2] = _pendingUnstakedLayer2[layer2].sub(amount);
2005     _pendingUnstakedAccount[msg.sender] = _pendingUnstakedAccount[msg.sender].sub(amount);
2006 
2007     _accUnstaked[layer2][msg.sender] = _accUnstaked[layer2][msg.sender].add(amount);
2008     _accUnstakedLayer2[layer2] = _accUnstakedLayer2[layer2].add(amount);
2009     _accUnstakedAccount[msg.sender] = _accUnstakedAccount[msg.sender].add(amount);
2010 
2011     if (receiveTON) {
2012       require(_wton.swapToTONAndTransfer(msg.sender, amount));
2013     } else {
2014       _wton.safeTransfer(msg.sender, amount);
2015     }
2016 
2017     emit WithdrawalProcessed(layer2, msg.sender, amount);
2018     return true;
2019   }
2020 
2021   function requestWithdrawalAll(address layer2) external onlyLayer2(layer2) returns (bool) {
2022     uint256 amount = _seigManager.stakeOf(layer2, msg.sender);
2023 
2024     return _requestWithdrawal(layer2, amount);
2025   }
2026 
2027   function processRequests(address layer2, uint256 n, bool receiveTON) external returns (bool) {
2028     for (uint256 i = 0; i < n; i++) {
2029       require(_processRequest(layer2, receiveTON));
2030     }
2031     return true;
2032   }
2033 
2034   function numRequests(address layer2, address account) external view returns (uint256) {
2035     return _withdrawalRequests[layer2][account].length;
2036   }
2037 
2038   function numPendingRequests(address layer2, address account) external view returns (uint256) {
2039     uint256 numRequests = _withdrawalRequests[layer2][account].length;
2040     uint256 index = _withdrawalRequestIndex[layer2][account];
2041 
2042     if (numRequests == 0) return 0;
2043 
2044     return numRequests - index;
2045   }
2046 
2047   function _isOperator(address layer2, address operator) internal view returns (bool) {
2048     return operator == Layer2I(layer2).operator();
2049   }
2050 
2051 
2052   ////////////////////
2053   // Storage getters
2054   ////////////////////
2055 
2056   // solium-disable
2057   function wton() external view returns (address) { return address(_wton); }
2058   function registry() external view returns (address) { return address(_registry); }
2059   function seigManager() external view returns (address) { return address(_seigManager); }
2060 
2061   function accStaked(address layer2, address account) external view returns (uint256 wtonAmount) { return _accStaked[layer2][account]; }
2062   function accStakedLayer2(address layer2) external view returns (uint256 wtonAmount) { return _accStakedLayer2[layer2]; }
2063   function accStakedAccount(address account) external view returns (uint256 wtonAmount) { return _accStakedAccount[account]; }
2064 
2065   function pendingUnstaked(address layer2, address account) external view returns (uint256 wtonAmount) { return _pendingUnstaked[layer2][account]; }
2066   function pendingUnstakedLayer2(address layer2) external view returns (uint256 wtonAmount) { return _pendingUnstakedLayer2[layer2]; }
2067   function pendingUnstakedAccount(address account) external view returns (uint256 wtonAmount) { return _pendingUnstakedAccount[account]; }
2068 
2069   function accUnstaked(address layer2, address account) external view returns (uint256 wtonAmount) { return _accUnstaked[layer2][account]; }
2070   function accUnstakedLayer2(address layer2) external view returns (uint256 wtonAmount) { return _accUnstakedLayer2[layer2]; }
2071   function accUnstakedAccount(address account) external view returns (uint256 wtonAmount) { return _accUnstakedAccount[account]; }
2072 
2073   function withdrawalRequestIndex(address layer2, address account) external view returns (uint256 index) { return _withdrawalRequestIndex[layer2][account]; }
2074   function withdrawalRequest(address layer2, address account, uint256 index) external view returns (uint128 withdrawableBlockNumber, uint128 amount, bool processed ) {
2075     withdrawableBlockNumber = _withdrawalRequests[layer2][account][index].withdrawableBlockNumber;
2076     amount = _withdrawalRequests[layer2][account][index].amount;
2077     processed = _withdrawalRequests[layer2][account][index].processed;
2078   }
2079 
2080   // solium-enable
2081 }