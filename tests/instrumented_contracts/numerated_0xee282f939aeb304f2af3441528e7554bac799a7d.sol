1 /**
2  * @dev Wrappers over Solidity's arithmetic operations with added overflow
3  * checks.
4  *
5  * Arithmetic operations in Solidity wrap on overflow. This can easily result
6  * in bugs, because programmers usually assume that an overflow raises an
7  * error, which is the standard behavior in high level programming languages.
8  * `SafeMath` restores this intuition by reverting the transaction when an
9  * operation overflows.
10  *
11  * Using this library instead of the unchecked operations eliminates an entire
12  * class of bugs, so it's recommended to use it always.
13  */
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, reverting on
17      * overflow.
18      *
19      * Counterpart to Solidity's `+` operator.
20      *
21      * Requirements:
22      * - Addition cannot overflow.
23      */
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30 
31     /**
32      * @dev Returns the subtraction of two unsigned integers, reverting on
33      * overflow (when the result is negative).
34      *
35      * Counterpart to Solidity's `-` operator.
36      *
37      * Requirements:
38      * - Subtraction cannot overflow.
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      *
53      * _Available since v2.4.0._
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      *
111      * _Available since v2.4.0._
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      *
148      * _Available since v2.4.0._
149      */
150     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following 
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
180         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
181         // for accounts without code, i.e. `keccak256('')`
182         bytes32 codehash;
183         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
184         // solhint-disable-next-line no-inline-assembly
185         assembly { codehash := extcodehash(account) }
186         return (codehash != accountHash && codehash != 0x0);
187     }
188 
189     /**
190      * @dev Converts an `address` into `address payable`. Note that this is
191      * simply a type cast: the actual underlying value is not changed.
192      *
193      * _Available since v2.4.0._
194      */
195     function toPayable(address account) internal pure returns (address payable) {
196         return address(uint160(account));
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      *
215      * _Available since v2.4.0._
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(address(this).balance >= amount, "Address: insufficient balance");
219 
220         // solhint-disable-next-line avoid-call-value
221         (bool success, ) = recipient.call.value(amount)("");
222         require(success, "Address: unable to send value, recipient may have reverted");
223     }
224 }
225 
226 
227 /**
228  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
229  * the optional functions; to access them see {ERC20Detailed}.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Emitted when `value` tokens are moved from one account (`from`) to
289      * another (`to`).
290      *
291      * Note that `value` may be zero.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /**
296      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
297      * a call to {approve}. `value` is the new allowance.
298      */
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 /**
303  * @title SafeERC20
304  * @dev Wrappers around ERC20 operations that throw on failure (when the token
305  * contract returns false). Tokens that return no value (and instead revert or
306  * throw on failure) are also supported, non-reverting calls are assumed to be
307  * successful.
308  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
309  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
310  */
311 library SafeERC20 {
312     using SafeMath for uint256;
313     using Address for address;
314 
315     function safeTransfer(IERC20 token, address to, uint256 value) internal {
316         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
317     }
318 
319     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
320         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
321     }
322 
323     function safeApprove(IERC20 token, address spender, uint256 value) internal {
324         // safeApprove should only be called when setting an initial allowance,
325         // or when resetting it to zero. To increase and decrease it, use
326         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
327         // solhint-disable-next-line max-line-length
328         require((value == 0) || (token.allowance(address(this), spender) == 0),
329             "SafeERC20: approve from non-zero to non-zero allowance"
330         );
331         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
332     }
333 
334     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
335         uint256 newAllowance = token.allowance(address(this), spender).add(value);
336         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
337     }
338 
339     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
340         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
341         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
342     }
343 
344     /**
345      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
346      * on the return value: the return value is optional (but if data is returned, it must not be false).
347      * @param token The token targeted by the call.
348      * @param data The call data (encoded using abi.encode or one of its variants).
349      */
350     function callOptionalReturn(IERC20 token, bytes memory data) private {
351         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
352         // we're implementing it ourselves.
353 
354         // A Solidity high level call has three parts:
355         //  1. The target address is checked to verify it contains contract code
356         //  2. The call itself is made, and success asserted
357         //  3. The return value is decoded, which in turn checks the size of the returned data.
358         // solhint-disable-next-line max-line-length
359         require(address(token).isContract(), "SafeERC20: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = address(token).call(data);
363         require(success, "SafeERC20: low-level call failed");
364 
365         if (returndata.length > 0) { // Return data is optional
366             // solhint-disable-next-line max-line-length
367             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
368         }
369     }
370 }
371 
372 
373 /*
374  * @dev Provides information about the current execution context, including the
375  * sender of the transaction and its data. While these are generally available
376  * via msg.sender and msg.data, they should not be accessed in such a direct
377  * manner, since when dealing with GSN meta-transactions the account sending and
378  * paying for execution may not be the actual sender (as far as an application
379  * is concerned).
380  *
381  * This contract is only required for intermediate, library-like contracts.
382  */
383 contract Context {
384     // Empty internal constructor, to prevent people from mistakenly deploying
385     // an instance of this contract, which should be used via inheritance.
386     constructor () internal { }
387     // solhint-disable-previous-line no-empty-blocks
388 
389     function _msgSender() internal view returns (address payable) {
390         return msg.sender;
391     }
392 
393     function _msgData() internal view returns (bytes memory) {
394         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
395         return msg.data;
396     }
397 }
398 
399 
400 /**
401  * @dev Contract module which provides a basic access control mechanism, where
402  * there is an account (an owner) that can be granted exclusive access to
403  * specific functions.
404  *
405  * This module is used through inheritance. It will make available the modifier
406  * `onlyOwner`, which can be applied to your functions to restrict their use to
407  * the owner.
408  */
409 contract Ownable is Context {
410     address private _owner;
411 
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor () internal {
418         address msgSender = _msgSender();
419         _owner = msgSender;
420         emit OwnershipTransferred(address(0), msgSender);
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         require(isOwner(), "Ownable: caller is not the owner");
435         _;
436     }
437 
438     /**
439      * @dev Returns true if the caller is the current owner.
440      */
441     function isOwner() public view returns (bool) {
442         return _msgSender() == _owner;
443     }
444 
445     /**
446      * @dev Leaves the contract without owner. It will not be possible to call
447      * `onlyOwner` functions anymore. Can only be called by the current owner.
448      *
449      * NOTE: Renouncing ownership will leave the contract without an owner,
450      * thereby removing any functionality that is only available to the owner.
451      */
452     function renounceOwnership() public onlyOwner {
453         emit OwnershipTransferred(_owner, address(0));
454         _owner = address(0);
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Can only be called by the current owner.
460      */
461     function transferOwnership(address newOwner) public onlyOwner {
462         _transferOwnership(newOwner);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      */
468     function _transferOwnership(address newOwner) internal {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         emit OwnershipTransferred(_owner, newOwner);
471         _owner = newOwner;
472     }
473 }
474 
475 interface INUXAsset {
476     function availableBalanceOf(address _holder) external view returns(uint);
477     function scheduleReleaseStart() external;
478     function transferLock(address _to, uint _value) external;
479     function publicSaleTransferLock(address _to, uint _value) external;
480     function locked(address _holder) external view returns(uint, uint);
481     function preSaleScheduleReleaseStart() external;
482     function preSaleTransferLock(address _to, uint _value) external;
483 }
484 
485 contract NUXConstants {
486     uint constant NUX = 10**18;
487 }
488 
489 contract Readable {
490     function since(uint _timestamp) internal view returns(uint) {
491         if (not(passed(_timestamp))) {
492             return 0;
493         }
494         return block.timestamp - _timestamp;
495     }
496 
497     function passed(uint _timestamp) internal view returns(bool) {
498         return _timestamp < block.timestamp;
499     }
500 
501     function not(bool _condition) internal pure returns(bool) {
502         return !_condition;
503     }
504 }
505 
506 library ExtraMath {
507     function toUInt32(uint _a) internal pure returns(uint32) {
508         require(_a <= uint32(-1), 'uint32 overflow');
509         return uint32(_a);
510     }
511 
512     function toUInt40(uint _a) internal pure returns(uint40) {
513         require(_a <= uint40(-1), 'uint40 overflow');
514         return uint40(_a);
515     }
516 
517     function toUInt64(uint _a) internal pure returns(uint64) {
518         require(_a <= uint64(-1), 'uint64 overflow');
519         return uint64(_a);
520     }
521 
522     function toUInt128(uint _a) internal pure returns(uint128) {
523         require(_a <= uint128(-1), 'uint128 overflow');
524         return uint128(_a);
525     }
526 }
527 
528 contract NUXSale is Ownable, NUXConstants, Readable {
529     using SafeERC20 for IERC20;
530     using ExtraMath for *;
531     using SafeMath for *;
532     INUXAsset public NUXAsset;
533     address payable public treasury;
534 
535 
536     struct State {
537         uint32 etherPriceUSD;
538         uint40 minimumDepositUSD;
539         uint40 maximumDepositUSD;
540         uint64 totalDepositedInUSD;
541         uint32 nextDepositId;
542         uint32 clearedDepositId;
543     }
544     State private _state;
545     mapping(uint => Deposit) public deposits;
546 
547     uint public constant SALE_START = 1612278000; // Tuesday, February 2, 2021 3:00:00 PM UTC
548     uint public constant SALE_END = SALE_START + 84 hours; // Saturday, February 6, 2021 3:00:00 PM UTC
549 
550     struct Deposit {
551         address payable user;
552         uint amount;
553         uint clearing1;
554         uint clearing2;
555         uint clearing3;
556         uint clearing4;
557     }
558 
559     event DepositEvent(address _from, uint _value);
560     event ETHReturned(address _to, uint _amount);
561     event ETHPriceSet(uint _usdPerETH);
562     event Cleared();
563     event ClearingPaused(uint _lastDepositId);
564     event TreasurySet(address _treasury);
565 
566     modifier onlyTreasury {
567         require(msg.sender == treasury, 'Only treasury');
568         _;
569     }
570 
571     constructor(INUXAsset _nux, address payable _treasury) public {
572         NUXAsset = _nux;
573         treasury = _treasury;
574     }
575 
576     function etherPriceUSD() public view returns(uint) {
577         return _state.etherPriceUSD;
578     }
579 
580     function minimumDepositUSD() public view returns(uint) {
581         return _state.minimumDepositUSD;
582     }
583 
584     function maximumDepositUSD() public view returns(uint) {
585         return _state.maximumDepositUSD;
586     }
587 
588     function totalDepositedInUSD() public view returns(uint) {
589         return _state.totalDepositedInUSD;
590     }
591 
592     function nextDepositId() public view returns(uint) {
593         return _state.nextDepositId;
594     }
595 
596     function clearedDepositId() public view returns(uint) {
597         return _state.clearedDepositId;
598     }
599 
600     function setETHPrice(uint _usdPerETH) public onlyOwner {
601         State memory state = _state;
602         require(state.etherPriceUSD == 0, 'Already set');
603         state.etherPriceUSD = _usdPerETH.toUInt32();
604         state.minimumDepositUSD = (_usdPerETH / 10).toUInt40(); // 0.1 ETH
605         state.maximumDepositUSD = (50 * _usdPerETH).toUInt40(); // 50 ETH
606         _state = state;
607         emit ETHPriceSet(_usdPerETH);
608     }
609 
610     function setTreasury(address payable _treasury) public onlyOwner {
611         require(_treasury != address(0), 'Zero address not allowed');
612         treasury = _treasury;
613         emit TreasurySet(_treasury);
614     }
615 
616     function saleStarted() public view returns(bool) {
617         return passed(SALE_START);
618     }
619 
620     function tokensSold() public view returns(uint) {
621         return totalDepositedInUSD() * NUX / getSalePrice();
622     }
623 
624     function saleEnded() public view returns(bool) {
625         return passed(SALE_END) || _isTokensSold(getSalePrice(), totalDepositedInUSD());
626     }
627 
628     function _saleEnded(uint _salePrice, uint _totalDeposited) private view returns(bool) {
629         return passed(SALE_END) || _isTokensSold(_salePrice, _totalDeposited);
630     }
631 
632     function ETHToUSD(uint _value) public view returns(uint) {
633         return _ETHToUSD(_value, etherPriceUSD());
634     }
635 
636     function _ETHToUSD(uint _value, uint _etherPrice) private pure returns(uint) {
637         return (_value * _etherPrice) / 1 ether;
638     }
639 
640     function USDtoETH(uint _value) public view returns(uint) {
641         return (_value * 1 ether) / etherPriceUSD();
642     }
643 
644     function USDToNUX(uint _value) public view returns(uint) {
645         return (_value * NUX) / getSalePrice();
646     }
647 
648     function NUXToUSD(uint _value) public view returns(uint) {
649         return (_value * getSalePrice()) / NUX;
650     }
651 
652     function ETHToNUX(uint _value) public view returns(uint) {
653         return _ETHToNUX(_value, etherPriceUSD(), getSalePrice());
654     }
655 
656     function NUXToETH(uint _value) public view returns(uint) {
657         return _NUXToETH(_value, etherPriceUSD(), getSalePrice());
658     }
659 
660     function _ETHToNUX(uint _value, uint _ethPrice, uint _salePrice) private pure returns(uint) {
661         return _value * _ethPrice / _salePrice;
662     }
663 
664     function _NUXToETH(uint _value, uint _ethPrice, uint _salePrice) private pure returns(uint) {
665         return _value * _salePrice / _ethPrice;
666     }
667 
668     function getSalePrice() public view returns(uint) {
669         return _getSalePrice(totalDepositedInUSD());
670     }
671 
672     function _getSalePrice(uint _totalDeposited) private view returns(uint) {
673         if (_isTokensSold(2500000, _totalDeposited) || not(passed(SALE_START + 12 hours))) {
674             return 2500000; // 2.5 USD
675         } else if (_isTokensSold(1830000, _totalDeposited) || not(passed(SALE_START + 24 hours))) {
676             return 1830000; // 1.83 USD
677         } else if (_isTokensSold(1350000, _totalDeposited) || not(passed(SALE_START + 36 hours))) {
678             return 1350000; // 1.35 USD
679         } else if (_isTokensSold(990000, _totalDeposited) || not(passed(SALE_START + 48 hours))) {
680             return 990000; // 0.99 USD
681         } else if (_isTokensSold(730000, _totalDeposited) || not(passed(SALE_START + 60 hours))){
682             return 730000; // 0.73 USD
683         } else if (_isTokensSold(530000, _totalDeposited) || not(passed(SALE_START + 72 hours))) {
684             return 530000; // 0.53 USD
685         } else {
686             return 350000; // 0.35 USD
687         }
688     }
689 
690     function _isTokensSold(uint _price, uint _totalDeposited) internal pure returns(bool) {
691         return ((_totalDeposited * NUX) / _price) >= (4000000 * NUX);
692     }
693 
694     function () external payable {
695         if (msg.sender == treasury) {
696             return;
697         }
698         _deposit();
699     }
700 
701     function depositETH() public payable {
702         _deposit();
703     }
704 
705     function _deposit() internal {
706         State memory state = _state;
707         treasury.transfer(msg.value);
708         uint usd = _ETHToUSD(msg.value, state.etherPriceUSD);
709         require(saleStarted(), 'Public sale not started yet');
710         require(not(_saleEnded(_getSalePrice(state.totalDepositedInUSD), state.totalDepositedInUSD)), 'Public sale already ended');
711         require(usd >= uint(state.minimumDepositUSD), 'Minimum deposit not met');
712         require(usd <= uint(state.maximumDepositUSD), 'Maximum deposit reached');
713 
714         deposits[state.nextDepositId] = Deposit(msg.sender, msg.value, 1, 1, 1, 1);
715         state.nextDepositId = (state.nextDepositId.add(1)).toUInt32();
716 
717         state.totalDepositedInUSD = (state.totalDepositedInUSD.add(usd)).toUInt64();
718         _state = state;
719         emit DepositEvent(msg.sender, msg.value);
720     }
721 
722     function clearing() public onlyOwner {
723         State memory state = _state;
724         uint salePrice = _getSalePrice(state.totalDepositedInUSD);
725         require(_saleEnded(salePrice, state.totalDepositedInUSD), 'Public sale not ended yet');
726         require(state.nextDepositId > state.clearedDepositId, 'Clearing finished');
727         INUXAsset nuxAsset = NUXAsset;
728 
729         (, uint lockedBalance) = nuxAsset.locked(address(this));
730         for (uint i = state.clearedDepositId; i < state.nextDepositId; i++) {
731             if (gasleft() < 500000) {
732                 state.clearedDepositId = i.toUInt32();
733                 _state = state;
734                 emit ClearingPaused(i);
735                 return;
736             }
737             Deposit memory deposit = deposits[i];
738             delete deposits[i];
739 
740             uint nux = _ETHToNUX(deposit.amount, state.etherPriceUSD, salePrice);
741             if (lockedBalance >= nux) {
742                 nuxAsset.publicSaleTransferLock(deposit.user, nux);
743                 lockedBalance = lockedBalance - nux;
744             } else if (lockedBalance > 0) {
745                 nuxAsset.publicSaleTransferLock(deposit.user, lockedBalance);
746                 uint tokensLeftToETH = nux - lockedBalance;
747                 uint ethAmount = _NUXToETH(tokensLeftToETH, state.etherPriceUSD, salePrice);
748                 lockedBalance = 0;
749                 deposit.user.transfer(ethAmount);
750                 emit ETHReturned(deposit.user, ethAmount);
751             } else {
752                 deposit.user.transfer(deposit.amount);
753                 emit ETHReturned(deposit.user, deposit.amount);
754             }
755         }
756         state.clearedDepositId = state.nextDepositId;
757 
758         if (lockedBalance > 0) {
759             nuxAsset.publicSaleTransferLock(address(0), lockedBalance);
760         }
761 
762         _state = state;
763         emit Cleared();
764     }
765 
766     function recoverTokens(IERC20 _token, address _to, uint _value) public onlyTreasury {
767         _token.safeTransfer(_to, _value);
768     }
769 
770     function recoverETH() public onlyTreasury {
771         treasury.transfer(address(this).balance);
772     }
773 
774 }