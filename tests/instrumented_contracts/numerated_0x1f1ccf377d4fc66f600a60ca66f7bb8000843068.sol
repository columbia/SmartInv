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
479 }
480 
481 contract NUXConstants {
482     uint constant NUX = 10**18;
483 }
484 
485 contract Readable {
486     function since(uint _timestamp) internal view returns(uint) {
487         if (not(passed(_timestamp))) {
488             return 0;
489         }
490         return block.timestamp - _timestamp;
491     }
492 
493     function passed(uint _timestamp) internal view returns(bool) {
494         return _timestamp < block.timestamp;
495     }
496 
497     function not(bool _condition) internal pure returns(bool) {
498         return !_condition;
499     }
500 }
501 
502 contract NUXPresale is Ownable, NUXConstants, Readable {
503     using SafeERC20 for IERC20;
504     uint public constant PRESALE_START = 1608649200; // Tuesday, December 22, 2020 3:00:00 PM UTC
505     uint public constant PRESALE_END = PRESALE_START + 7 days; // Tuesday, December 29, 2020 3:00:00 PM UTC
506     uint public constant PRESALE_PRICE_USD = 250000; // 0.25 USD
507     uint public etherPriceUSD;
508     uint public minimumDepositUSD;
509     uint public maximumDepositUSD;
510     IERC20 public NUXToken;
511     address payable public treasury;
512     IERC20 public usdt;
513     IERC20 public usdc;
514 
515     mapping(address => uint) public deposited;
516 
517     event Deposit(address _from, uint _usdValue);
518     event ETHPriceSet(uint _usdPerETH);
519     event TreasuryUpdated(address _treasury);
520 
521     constructor(IERC20 _nux, address payable _treasury, IERC20 _usdt, IERC20 _usdc) public {
522         NUXToken = _nux;
523         treasury = _treasury;
524         usdt = _usdt;
525         usdc = _usdc;
526         emit TreasuryUpdated(_treasury);
527     }
528 
529     function setTreasury(address payable _treasury) public onlyOwner() {
530         require(_treasury != address(0), 'Invalid address');
531         treasury = _treasury;
532         emit TreasuryUpdated(_treasury);
533     }
534 
535     function setETHPrice(uint _usdPerETH) public onlyOwner() {
536         require(etherPriceUSD == 0, 'Already set');
537         etherPriceUSD = _usdPerETH;
538         minimumDepositUSD = etherPriceUSD; // 1 ETH
539         maximumDepositUSD = 100 * etherPriceUSD; // 100 ETH
540         emit ETHPriceSet(_usdPerETH);
541     }
542 
543     function presaleStarted() public view returns(bool) {
544         return passed(PRESALE_START);
545     }
546 
547     function presaleEnded() public view returns(bool) {
548         return passed(PRESALE_END);
549     }
550 
551     function depositUSDT(uint _value) public {
552         _depositToken(usdt, _value);
553     }
554 
555     function depositUSDC(uint _value) public {
556         _depositToken(usdc, _value);
557     }
558 
559     function _depositToken(IERC20 _usdToken, uint _value) internal {
560         _usdToken.safeTransferFrom(msg.sender, treasury, _value);
561         _deposit(_value);
562     }
563 
564     function () external payable {
565         depositETH();
566     }
567 
568     function depositETH() public payable {
569         treasury.transfer(msg.value);
570         _deposit(ETHToUSD(msg.value));
571     }
572 
573     function ETHToUSD(uint _value) public view returns(uint) {
574         return (_value * etherPriceUSD) / 1 ether;
575     }
576 
577     function USDToNUX(uint _value) public pure returns(uint) {
578         return (_value * NUX) / PRESALE_PRICE_USD;
579     }
580 
581     function _deposit(uint _value) internal {
582         require(_value > 0, 'Cannot deposit 0');
583         require(presaleStarted(), 'Presale not started yet');
584         require(not(presaleEnded()), 'Presale already ended');
585         uint totalDeposit = deposited[msg.sender] + _value;
586         require(totalDeposit >= minimumDepositUSD, 'Minimum deposit not met');
587         require(totalDeposit <= maximumDepositUSD, 'Maximum deposit reached');
588         deposited[msg.sender] = totalDeposit;
589         INUXAsset(address(NUXToken)).transferLock(msg.sender, USDToNUX(_value));
590         emit Deposit(msg.sender, _value);
591     }
592 
593     function recoverTokens(IERC20 _token, address _to, uint _value) public onlyOwner() {
594         _token.safeTransfer(_to, _value);
595     }
596 
597     function finalize() public {
598         require(presaleEnded(), 'Presale not ended yet');
599         INUXAsset(address(NUXToken)).transferLock(treasury, NUXToken.balanceOf(address(this)));
600     }
601 }