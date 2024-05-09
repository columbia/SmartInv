1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-26
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      *
59      * _Available since v2.4.0._
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      * - The divisor cannot be zero.
116      *
117      * _Available since v2.4.0._
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         // Solidity only automatically asserts when dividing by 0
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      *
154      * _Available since v2.4.0._
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 /**
163  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
164  * the optional functions; to access them see {ERC20Detailed}.
165  */
166 interface IERC20 {
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @dev Returns the amount of tokens owned by `account`.
174      */
175     function balanceOf(address account) external view returns (uint256);
176 
177     /**
178      * @dev Moves `amount` tokens from the caller's account to `recipient`.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transfer(address recipient, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Returns the remaining number of tokens that `spender` will be
188      * allowed to spend on behalf of `owner` through {transferFrom}. This is
189      * zero by default.
190      *
191      * This value changes when {approve} or {transferFrom} are called.
192      */
193     function allowance(address owner, address spender) external view returns (uint256);
194 
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * IMPORTANT: Beware that changing an allowance with this method brings the risk
201      * that someone may use both the old and the new allowance by unfortunate
202      * transaction ordering. One possible solution to mitigate this race
203      * condition is to first reduce the spender's allowance to 0 and set the
204      * desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address spender, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Moves `amount` tokens from `sender` to `recipient` using the
213      * allowance mechanism. `amount` is then deducted from the caller's
214      * allowance.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
221 
222     /**
223      * @dev Emitted when `value` tokens are moved from one account (`from`) to
224      * another (`to`).
225      *
226      * Note that `value` may be zero.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 value);
229 
230     /**
231      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
232      * a call to {approve}. `value` is the new allowance.
233      */
234     event Approval(address indexed owner, address indexed spender, uint256 value);
235 }
236 
237 /**
238  * @dev Optional functions from the ERC20 standard.
239  */
240 contract ERC20Detailed is IERC20 {
241     string private _name;
242     string private _symbol;
243     uint8 private _decimals;
244 
245     /**
246      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
247      * these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor (string memory name, string memory symbol, uint8 decimals) public {
251         _name = name;
252         _symbol = symbol;
253         _decimals = decimals;
254     }
255 
256     /**
257      * @dev Returns the name of the token.
258      */
259     function name() public view returns (string memory) {
260         return _name;
261     }
262 
263     /**
264      * @dev Returns the symbol of the token, usually a shorter version of the
265      * name.
266      */
267     function symbol() public view returns (string memory) {
268         return _symbol;
269     }
270 
271     /**
272      * @dev Returns the number of decimals used to get its user representation.
273      * For example, if `decimals` equals `2`, a balance of `505` tokens should
274      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
275      *
276      * Tokens usually opt for a value of 18, imitating the relationship between
277      * Ether and Wei.
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view returns (uint8) {
284         return _decimals;
285     }
286 }
287 
288 /**
289  * @dev Collection of functions related to the address type,
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * This test is non-exhaustive, and there may be false-negatives: during the
296      * execution of a contract's constructor, its address will be reported as
297      * not containing a contract.
298      *
299      * > It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies in extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         // solhint-disable-next-line no-inline-assembly
309         assembly { size := extcodesize(account) }
310         return size > 0;
311     }
312 }
313 
314 /**
315  * @title SafeERC20
316  * @dev Wrappers around ERC20 operations that throw on failure (when the token
317  * contract returns false). Tokens that return no value (and instead revert or
318  * throw on failure) are also supported, non-reverting calls are assumed to be
319  * successful.
320  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
321  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
322  */
323 
324 library SafeERC20 {
325     using SafeMath for uint256;
326     using Address for address;
327 
328     function safeTransfer(IERC20 token, address to, uint256 value) internal {
329         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
330     }
331 
332     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
334     }
335 
336     function safeApprove(IERC20 token, address spender, uint256 value) internal {
337         // safeApprove should only be called when setting an initial allowance,
338         // or when resetting it to zero. To increase and decrease it, use
339         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
340         // solhint-disable-next-line max-line-length
341         require((value == 0) || (token.allowance(address(this), spender) == 0),
342             "SafeERC20: approve from non-zero to non-zero allowance"
343         );
344         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
345     }
346 
347     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
348         uint256 newAllowance = token.allowance(address(this), spender).add(value);
349         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350     }
351 
352     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
353         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
354         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
355     }
356 
357     /**
358      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
359      * on the return value: the return value is optional (but if data is returned, it must not be false).
360      * @param token The token targeted by the call.
361      * @param data The call data (encoded using abi.encode or one of its variants).
362      */
363     function callOptionalReturn(IERC20 token, bytes memory data) private {
364         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
365         // we're implementing it ourselves.
366 
367         // A Solidity high level call has three parts:
368         //  1. The target address is checked to verify it contains contract code
369         //  2. The call itself is made, and success asserted
370         //  3. The return value is decoded, which in turn checks the size of the returned data.
371         // solhint-disable-next-line max-line-length
372         require(address(token).isContract(), "SafeERC20: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = address(token).call(data);
376         require(success, "SafeERC20: low-level call failed");
377 
378         if (returndata.length > 0) { // Return data is optional
379             // solhint-disable-next-line max-line-length
380             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
381         }
382     }
383 }
384 
385 
386 /**
387  * @dev Contract module that helps prevent reentrant calls to a function.
388  *
389  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
390  * available, which can be applied to functions to make sure there are no nested
391  * (reentrant) calls to them.
392  *
393  * Note that because there is a single `nonReentrant` guard, functions marked as
394  * `nonReentrant` may not call one another. This can be worked around by making
395  * those functions `private`, and then adding `external` `nonReentrant` entry
396  * points to them.
397  *
398  * TIP: If you would like to learn more about reentrancy and alternative ways
399  * to protect against it, check out our blog post
400  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
401  *
402  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
403  * metering changes introduced in the Istanbul hardfork.
404  */
405 contract ReentrancyGuard {
406     bool private _notEntered;
407 
408     constructor () internal {
409         // Storing an initial non-zero value makes deployment a bit more
410         // expensive, but in exchange the refund on every call to nonReentrant
411         // will be lower in amount. Since refunds are capped to a percetange of
412         // the total transaction's gas, it is best to keep them low in cases
413         // like this one, to increase the likelihood of the full refund coming
414         // into effect.
415         _notEntered = true;
416     }
417 
418     /**
419      * @dev Prevents a contract from calling itself, directly or indirectly.
420      * Calling a `nonReentrant` function from another `nonReentrant`
421      * function is not supported. It is possible to prevent this from happening
422      * by making the `nonReentrant` function external, and make it call a
423      * `private` function that does the actual work.
424      */
425     modifier nonReentrant() {
426         // On the first call to nonReentrant, _notEntered will be true
427         require(_notEntered, "ReentrancyGuard: reentrant call");
428 
429         // Any calls to nonReentrant after this point will fail
430         _notEntered = false;
431 
432         _;
433 
434         // By storing the original value once again, a refund is triggered (see
435         // https://eips.ethereum.org/EIPS/eip-2200)
436         _notEntered = true;
437     }
438 }
439 
440 
441 /**
442  * @dev Contract module which provides a basic access control mechanism, where
443  * there is an account (an owner) that can be granted exclusive access to
444  * specific functions.
445  *
446  * This module is used through inheritance. It will make available the modifier
447  * `onlyOwner`, which can be applied to your functions to restrict their use to
448  * the owner.
449  */
450 contract Ownable {
451     address private _owner;
452 
453     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
454 
455     /**
456      * @dev Initializes the contract setting the deployer as the initial owner.
457      */
458     constructor () internal {
459         address msgSender = msg.sender;
460         _owner = msgSender;
461         emit OwnershipTransferred(address(0), msgSender);
462     }
463 
464     /**
465      * @dev Returns the address of the current owner.
466      */
467     function owner() public view returns (address) {
468         return _owner;
469     }
470 
471     /**
472      * @dev Throws if called by any account other than the owner.
473      */
474     modifier onlyOwner() {
475         require(isOwner(), "Ownable: caller is not the owner");
476         _;
477     }
478 
479     /**
480      * @dev Returns true if the caller is the current owner.
481      */
482     function isOwner() public view returns (bool) {
483         return msg.sender == _owner;
484     }
485 
486     /**
487      * @dev Leaves the contract without owner. It will not be possible to call
488      * `onlyOwner` functions anymore. Can only be called by the current owner.
489      *
490      * NOTE: Renouncing ownership will leave the contract without an owner,
491      * thereby removing any functionality that is only available to the owner.
492      */
493     function renounceOwnership() public onlyOwner {
494         emit OwnershipTransferred(_owner, address(0));
495         _owner = address(0);
496     }
497 
498     /**
499      * @dev Transfers ownership of the contract to a new account (`newOwner`).
500      * Can only be called by the current owner.
501      */
502     function transferOwnership(address newOwner) public onlyOwner {
503         _transferOwnership(newOwner);
504     }
505 
506     /**
507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
508      */
509     function _transferOwnership(address newOwner) internal {
510         require(newOwner != address(0), "Ownable: new owner is the zero address");
511         emit OwnershipTransferred(_owner, newOwner);
512         _owner = newOwner;
513     }
514 }
515 
516 contract PlinkoSwap is Ownable, ReentrancyGuard {
517 	using SafeMath for uint256;
518 	using SafeERC20 for IERC20;
519 	
520 	uint256 private _decimal = 18;
521 	uint256 private _decimalConverter = 10**18;
522 	
523 	IERC20 _old_token;
524 	uint256 _old_token_decimal;
525 	IERC20 _new_token;
526 	uint256 _new_token_decimal;
527 	address payable _wallet;
528 	uint256 _rate;
529 	uint256 _rate_decimal;
530 	
531 	constructor(address old_token, uint256 old_token_decimal, address new_token , uint256 new_token_decimal, address payable wallet, uint256 rate, uint256 rate_decimal) public Ownable() {	
532 		require(rate > 0, "Swap : rate is 0");
533         require(wallet != address(0), "Swap : wallet is the zero address");
534         require(address(old_token) != address(0), "Swap: old token is the zero address");
535         require(address(new_token) != address(0), "Swap: new token is the zero address");
536 		
537 		_old_token = IERC20(old_token);
538 		_old_token_decimal = old_token_decimal;
539 		_new_token = IERC20(new_token);
540 		_new_token_decimal = new_token_decimal;
541 		_wallet = wallet;
542 		_rate = rate;
543 		_rate_decimal = rate_decimal;
544 	}
545 		
546 	function swapToken(uint256 _swap_amount) external nonReentrant {
547 		uint256 _old_token_amount = _getTokenAmount(_old_token_decimal,_swap_amount);
548 		
549 		uint256 new_token_swap_amount = _getRateAmount(_swap_amount);
550 		uint256 new_token_amount = _getTokenAmount(_new_token_decimal,new_token_swap_amount);
551 		
552 		_preValidateSwap(_swap_amount);
553 		
554 		_old_token.safeTransferFrom(msg.sender, address(this), _old_token_amount);
555 		_new_token.safeTransfer(msg.sender, new_token_amount);
556 		_old_token.safeTransfer(_wallet, _old_token_amount);
557 	}
558 	
559 	function _getTokenAmount(uint256 token_decimal, uint256 swapAmount) internal view returns (uint256) {
560 		uint256 decimalDiff;
561 		uint256 decimalDiffConverter;
562 		uint256 _swap_amount;
563 		
564 		if(_decimal == token_decimal){
565 			_swap_amount = swapAmount;
566 		} else {
567 			if(_decimal > token_decimal){
568 				decimalDiff = _decimal - token_decimal;
569 				decimalDiffConverter = 10**decimalDiff;
570 				_swap_amount = swapAmount.div(decimalDiffConverter);
571 			} else {
572 				decimalDiff = token_decimal - _decimal;
573 				decimalDiffConverter = 10**decimalDiff;
574 				_swap_amount = swapAmount.mul(decimalDiffConverter);
575 			}		
576 		}
577 		
578 		return _swap_amount;
579     }
580 	
581 	function _preValidateSwap(uint256 swapAmount) internal view {
582         require(swapAmount != 0, "Swap: Amount is 0");
583         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
584     }
585 	
586 	function _getRateAmount(uint256 swapAmount) internal view returns (uint256) {
587 		uint256 _swapAmount;
588 		
589 		if(_rate_decimal > 0){
590 			uint256 RateDecimalConverter = 10**_rate_decimal;
591 			uint256 _new_rate = _rate.mul(RateDecimalConverter);
592 			
593 			_swapAmount = swapAmount.mul(_rate);
594 			_swapAmount = swapAmount.div(_new_rate);
595 		} else {
596 			_swapAmount = swapAmount.mul(_rate);
597 		}
598 
599 	   return _swapAmount;
600     }
601 	
602 	function changeRate(uint256 new_rate, uint256 rate_decimal) external onlyOwner{
603 		_rate = new_rate;
604 		_rate_decimal = rate_decimal;
605 	}
606 	
607 	function changeOldToken(IERC20 new_token, uint256 new_token_decimal) external onlyOwner{
608 		_old_token = new_token;
609 		_old_token_decimal = new_token_decimal;
610 	}
611 	
612 	function changeNewToken(IERC20 new_token, uint256 new_token_decimal) external onlyOwner{
613 		_new_token = new_token;
614 		_new_token_decimal = new_token_decimal;
615 	}
616 	
617 	function changeWallet(address payable new_wallet) external onlyOwner{
618 		_wallet = new_wallet;
619 	}
620 	
621 	function _deliverTokens(address _token, address account, uint256 tokenAmount) external onlyOwner {
622 		IERC20(_token).safeTransfer(account, tokenAmount);
623 	}
624 		
625 	function _deliverETH(address payable wallet, uint256 ETHamount) external onlyOwner {
626 		wallet.transfer(ETHamount);
627 	}
628 	
629 	event SwapToken(address indexed user, address old_token_address, address new_token_address, uint256 amount, uint256 rate);
630 	
631 }