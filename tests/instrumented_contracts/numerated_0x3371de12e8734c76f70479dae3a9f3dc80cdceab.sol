1 // SPDX-License-Identifier: GPL-3.0-only
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
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
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/math/SafeMath.sol
99 
100 
101 pragma solidity >=0.6.0 <0.8.0;
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
260 
261 
262 pragma solidity >=0.6.0 <0.8.0;
263 
264 /**
265  * @dev Contract module that helps prevent reentrant calls to a function.
266  *
267  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
268  * available, which can be applied to functions to make sure there are no nested
269  * (reentrant) calls to them.
270  *
271  * Note that because there is a single `nonReentrant` guard, functions marked as
272  * `nonReentrant` may not call one another. This can be worked around by making
273  * those functions `private`, and then adding `external` `nonReentrant` entry
274  * points to them.
275  *
276  * TIP: If you would like to learn more about reentrancy and alternative ways
277  * to protect against it, check out our blog post
278  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
279  */
280 abstract contract ReentrancyGuard {
281     // Booleans are more expensive than uint256 or any type that takes up a full
282     // word because each write operation emits an extra SLOAD to first read the
283     // slot's contents, replace the bits taken up by the boolean, and then write
284     // back. This is the compiler's defense against contract upgrades and
285     // pointer aliasing, and it cannot be disabled.
286 
287     // The values being non-zero value makes deployment a bit more expensive,
288     // but in exchange the refund on every call to nonReentrant will be lower in
289     // amount. Since refunds are capped to a percentage of the total
290     // transaction's gas, it is best to keep them low in cases like this one, to
291     // increase the likelihood of the full refund coming into effect.
292     uint256 private constant _NOT_ENTERED = 1;
293     uint256 private constant _ENTERED = 2;
294 
295     uint256 private _status;
296 
297     constructor () internal {
298         _status = _NOT_ENTERED;
299     }
300 
301     /**
302      * @dev Prevents a contract from calling itself, directly or indirectly.
303      * Calling a `nonReentrant` function from another `nonReentrant`
304      * function is not supported. It is possible to prevent this from happening
305      * by making the `nonReentrant` function external, and make it call a
306      * `private` function that does the actual work.
307      */
308     modifier nonReentrant() {
309         // On the first call to nonReentrant, _notEntered will be true
310         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
311 
312         // Any calls to nonReentrant after this point will fail
313         _status = _ENTERED;
314 
315         _;
316 
317         // By storing the original value once again, a refund is triggered (see
318         // https://eips.ethereum.org/EIPS/eip-2200)
319         _status = _NOT_ENTERED;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
324 
325 
326 pragma solidity >=0.6.0 <0.8.0;
327 
328 /**
329  * @dev Interface of the ERC20 standard as defined in the EIP.
330  */
331 interface IERC20 {
332     /**
333      * @dev Returns the amount of tokens in existence.
334      */
335     function totalSupply() external view returns (uint256);
336 
337     /**
338      * @dev Returns the amount of tokens owned by `account`.
339      */
340     function balanceOf(address account) external view returns (uint256);
341 
342     /**
343      * @dev Moves `amount` tokens from the caller's account to `recipient`.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transfer(address recipient, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Returns the remaining number of tokens that `spender` will be
353      * allowed to spend on behalf of `owner` through {transferFrom}. This is
354      * zero by default.
355      *
356      * This value changes when {approve} or {transferFrom} are called.
357      */
358     function allowance(address owner, address spender) external view returns (uint256);
359 
360     /**
361      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * IMPORTANT: Beware that changing an allowance with this method brings the risk
366      * that someone may use both the old and the new allowance by unfortunate
367      * transaction ordering. One possible solution to mitigate this race
368      * condition is to first reduce the spender's allowance to 0 and set the
369      * desired value afterwards:
370      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
371      *
372      * Emits an {Approval} event.
373      */
374     function approve(address spender, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Moves `amount` tokens from `sender` to `recipient` using the
378      * allowance mechanism. `amount` is then deducted from the caller's
379      * allowance.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Emitted when `value` tokens are moved from one account (`from`) to
389      * another (`to`).
390      *
391      * Note that `value` may be zero.
392      */
393     event Transfer(address indexed from, address indexed to, uint256 value);
394 
395     /**
396      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
397      * a call to {approve}. `value` is the new allowance.
398      */
399     event Approval(address indexed owner, address indexed spender, uint256 value);
400 }
401 
402 // File: contracts/ElasticERC20.sol
403 
404 pragma solidity ^0.6.0;
405 
406 
407 
408 
409 /**
410  * @dev This contract is based on the OpenZeppelin ERC20 implementation,
411  * basically adding the elastic extensions.
412  */
413 contract ElasticERC20 is Context, IERC20
414 {
415 	using SafeMath for uint256;
416 
417 	uint8 constant UNSCALED_DECIMALS = 24;
418 	uint256 constant UNSCALED_FACTOR = 10 ** uint256(UNSCALED_DECIMALS);
419 
420 	mapping (address => mapping (address => uint256)) private allowances_;
421 
422 	mapping (address => uint256) private unscaledBalances_;
423 	uint256 private unscaledTotalSupply_;
424 
425 	string private name_;
426 	string private symbol_;
427 	uint8 private decimals_;
428 
429 	uint256 private scalingFactor_;
430 
431 	constructor (string memory _name, string memory _symbol) public
432 	{
433 		name_ = _name;
434 		symbol_ = _symbol;
435 		_setupDecimals(18);
436 	}
437 
438 	function name() public view returns (string memory _name)
439 	{
440 		return name_;
441 	}
442 
443 	function symbol() public view returns (string memory _symbol)
444 	{
445 		return symbol_;
446 	}
447 
448 	function decimals() public view returns (uint8 _decimals)
449 	{
450 		return decimals_;
451 	}
452 
453 	function totalSupply() public view override returns (uint256 _supply)
454 	{
455 		return _scale(unscaledTotalSupply_, scalingFactor_);
456 	}
457 
458 	function balanceOf(address _account) public view override returns (uint256 _balance)
459 	{
460 		return _scale(unscaledBalances_[_account], scalingFactor_);
461 	}
462 
463 	function allowance(address _owner, address _spender) public view virtual override returns (uint256 _allowance)
464 	{
465 		return allowances_[_owner][_spender];
466 	}
467 
468 	function approve(address _spender, uint256 _amount) public virtual override returns (bool _success)
469 	{
470 		_approve(_msgSender(), _spender, _amount);
471 		return true;
472 	}
473 
474 	function increaseAllowance(address _spender, uint256 _addedValue) public virtual returns (bool _success)
475 	{
476 		_approve(_msgSender(), _spender, allowances_[_msgSender()][_spender].add(_addedValue));
477 		return true;
478 	}
479 
480 	function decreaseAllowance(address _spender, uint256 _subtractedValue) public virtual returns (bool _success)
481 	{
482 		_approve(_msgSender(), _spender, allowances_[_msgSender()][_spender].sub(_subtractedValue, "ERC20: decreased allowance below zero"));
483 		return true;
484 	}
485 
486 	function transfer(address _recipient, uint256 _amount) public virtual override returns (bool _success)
487 	{
488 		_transfer(_msgSender(), _recipient, _amount);
489 		return true;
490 	}
491 
492 	function transferFrom(address _sender, address _recipient, uint256 _amount) public virtual override returns (bool _success)
493 	{
494 		_transfer(_sender, _recipient, _amount);
495 		_approve(_sender, _msgSender(), allowances_[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
496 		return true;
497 	}
498 
499 	function _approve(address _owner, address _spender, uint256 _amount) internal virtual
500 	{
501 		require(_owner != address(0), "ERC20: approve from the zero address");
502 		require(_spender != address(0), "ERC20: approve to the zero address");
503 		allowances_[_owner][_spender] = _amount;
504 		emit Approval(_owner, _spender, _amount);
505 	}
506 
507 	function _transfer(address _sender, address _recipient, uint256 _amount) internal virtual
508 	{
509 		uint256 _unscaledAmount = _unscale(_amount, scalingFactor_);
510 		require(_sender != address(0), "ERC20: transfer from the zero address");
511 		require(_recipient != address(0), "ERC20: transfer to the zero address");
512 		_beforeTokenTransfer(_sender, _recipient, _amount);
513 		unscaledBalances_[_sender] = unscaledBalances_[_sender].sub(_unscaledAmount, "ERC20: transfer amount exceeds balance");
514 		unscaledBalances_[_recipient] = unscaledBalances_[_recipient].add(_unscaledAmount);
515 		emit Transfer(_sender, _recipient, _amount);
516 	}
517 
518 	function _mint(address _account, uint256 _amount) internal virtual
519 	{
520 		uint256 _unscaledAmount = _unscale(_amount, scalingFactor_);
521 		require(_account != address(0), "ERC20: mint to the zero address");
522 		_beforeTokenTransfer(address(0), _account, _amount);
523 		unscaledTotalSupply_ = unscaledTotalSupply_.add(_unscaledAmount);
524 		uint256 _maxScalingFactor = _calcMaxScalingFactor(unscaledTotalSupply_);
525 		require(scalingFactor_ <= _maxScalingFactor, "unsupported scaling factor");
526 		unscaledBalances_[_account] = unscaledBalances_[_account].add(_unscaledAmount);
527 		emit Transfer(address(0), _account, _amount);
528 	}
529 
530 	function _burn(address _account, uint256 _amount) internal virtual
531 	{
532 		uint256 _unscaledAmount = _unscale(_amount, scalingFactor_);
533 		require(_account != address(0), "ERC20: burn from the zero address");
534 		_beforeTokenTransfer(_account, address(0), _amount);
535 		unscaledBalances_[_account] = unscaledBalances_[_account].sub(_unscaledAmount, "ERC20: burn amount exceeds balance");
536 		unscaledTotalSupply_ = unscaledTotalSupply_.sub(_unscaledAmount);
537 		emit Transfer(_account, address(0), _amount);
538 	}
539 
540 	function _setupDecimals(uint8 _decimals) internal
541 	{
542 		decimals_ = _decimals;
543 		scalingFactor_ = 10 ** uint256(_decimals);
544 	}
545 
546 	function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual { }
547 
548 	function unscaledTotalSupply() public view returns (uint256 _supply)
549 	{
550 		return unscaledTotalSupply_;
551 	}
552 
553 	function unscaledBalanceOf(address _account) public view returns (uint256 _balance)
554 	{
555 		return unscaledBalances_[_account];
556 	}
557 
558 	function scalingFactor() public view returns (uint256 _scalingFactor)
559 	{
560 		return scalingFactor_;
561 	}
562 
563 	function maxScalingFactor() public view returns (uint256 _maxScalingFactor)
564 	{
565 		return _calcMaxScalingFactor(unscaledTotalSupply_);
566 	}
567 
568 	function _calcMaxScalingFactor(uint256 _unscaledTotalSupply) internal pure returns (uint256 _maxScalingFactor)
569 	{
570 		return uint256(-1).div(_unscaledTotalSupply);
571 	}
572 
573 	function _scale(uint256 _unscaledAmount, uint256 _scalingFactor) internal pure returns (uint256 _amount)
574 	{
575 		return _unscaledAmount.mul(_scalingFactor).div(UNSCALED_FACTOR);
576 	}
577 
578 	function _unscale(uint256 _amount, uint256 _scalingFactor) internal pure returns (uint256 _unscaledAmount)
579 	{
580 		return _amount.mul(UNSCALED_FACTOR).div(_scalingFactor);
581 	}
582 
583 	function _setScalingFactor(uint256 _scalingFactor) internal
584 	{
585 		uint256 _maxScalingFactor = _calcMaxScalingFactor(unscaledTotalSupply_);
586 		require(0 < _scalingFactor && _scalingFactor <= _maxScalingFactor, "unsupported scaling factor");
587 		scalingFactor_ = _scalingFactor;
588 	}
589 }
590 
591 // File: contracts/Executor.sol
592 
593 pragma solidity ^0.6.0;
594 
595 /**
596  * @dev This library provides support for the dynamic execution of external
597  * contract calls.
598  */
599 library Executor
600 {
601 	struct Target {
602 		address to;
603 		bytes data;
604 	}
605 
606 	function addTarget(Target[] storage _targets, address _to, bytes memory _data) internal
607 	{
608 		_targets.push(Target({ to: _to, data: _data }));
609 	}
610 
611 	function removeTarget(Target[] storage _targets, uint256 _index) internal
612 	{
613 		require(_index < _targets.length, "invalid index");
614 		_targets[_index] = _targets[_targets.length - 1];
615 		_targets.pop();
616 	}
617 
618 	function executeAll(Target[] storage _targets) internal
619 	{
620 		for (uint256 _i = 0; _i < _targets.length; _i++) {
621 			Target storage _target = _targets[_i];
622 			bool _success = _externalCall(_target.to, _target.data);
623 			require(_success, "call failed");
624 		}
625 	}
626 
627 	function _externalCall(address _to, bytes memory _data) private returns (bool _success)
628 	{
629 		assembly {
630 			_success := call(gas(), _to, 0, add(_data, 0x20), mload(_data), 0, 0)
631 		}
632 	}
633 }
634 
635 // File: contracts/GElastic.sol
636 
637 pragma solidity ^0.6.0;
638 
639 /**
640  * @dev This interface exposes the base functionality of GElasticToken.
641  */
642 interface GElastic
643 {
644 	// view functions
645 	function referenceToken() external view returns (address _referenceToken);
646 	function treasury() external view returns (address _treasury);
647 	function rebaseMinimumDeviation() external view returns (uint256 _rebaseMinimumDeviation);
648 	function rebaseDampeningFactor() external view returns (uint256 _rebaseDampeningFactor);
649 	function rebaseTreasuryMintPercent() external view returns (uint256 _rebaseTreasuryMintPercent);
650 	function rebaseTimingParameters() external view returns (uint256 _rebaseMinimumInterval, uint256 _rebaseWindowOffset, uint256 _rebaseWindowLength);
651 	function rebaseActive() external view returns (bool _rebaseActive);
652 	function rebaseAvailable() external view returns (bool _available);
653 	function lastRebaseTime() external view returns (uint256 _lastRebaseTime);
654 	function epoch() external view returns (uint256 _epoch);
655 	function lastExchangeRate() external view returns (uint256 _exchangeRate);
656 	function currentExchangeRate() external view returns (uint256 _exchangeRate);
657 	function pair() external view returns (address _pair);
658 
659 	// open functions
660 	function rebase() external;
661 
662 	// priviledged functions
663 	function activateOracle(address _pair) external;
664 	function activateRebase() external;
665 	function setTreasury(address _newTreasury) external;
666 	function setRebaseMinimumDeviation(uint256 _newRebaseMinimumDeviation) external;
667 	function setRebaseDampeningFactor(uint256 _newRebaseDampeningFactor) external;
668 	function setRebaseTreasuryMintPercent(uint256 _newRebaseTreasuryMintPercent) external;
669 	function setRebaseTimingParameters(uint256 _newRebaseMinimumInterval, uint256 _newRebaseWindowOffset, uint256 _newRebaseWindowLength) external;
670 	function addPostRebaseTarget(address _to, bytes memory _data) external;
671 	function removePostRebaseTarget(uint256 _index) external;
672 
673 	// emitted events
674 	event Rebase(uint256 indexed _epoch, uint256 _oldScalingFactor, uint256 _newScalingFactor);
675 	event ChangeTreasury(address _oldTreasury, address _newTreasury);
676 	event ChangeRebaseMinimumDeviation(uint256 _oldRebaseMinimumDeviation, uint256 _newRebaseMinimumDeviation);
677 	event ChangeRebaseDampeningFactor(uint256 _oldRebaseDampeningFactor, uint256 _newRebaseDampeningFactor);
678 	event ChangeRebaseTreasuryMintPercent(uint256 _oldRebaseTreasuryMintPercent, uint256 _newRebaseTreasuryMintPercent);
679 	event ChangeRebaseTimingParameters(uint256 _oldRebaseMinimumInterval, uint256 _oldRebaseWindowOffset, uint256 _oldRebaseWindowLength, uint256 _newRebaseMinimumInterval, uint256 _newRebaseWindowOffset, uint256 _newRebaseWindowLength);
680 	event AddPostRebaseTarget(address indexed _to, bytes _data);
681 	event RemovePostRebaseTarget(address indexed _to, bytes _data);
682 }
683 
684 // File: contracts/GElasticTokenManager.sol
685 
686 pragma solidity ^0.6.0;
687 
688 
689 /**
690  * @dev This library helps managing rebase parameters and calculations.
691  */
692 library GElasticTokenManager
693 {
694 	using SafeMath for uint256;
695 	using GElasticTokenManager for GElasticTokenManager.Self;
696 
697 	uint256 constant MAXIMUM_REBASE_TREASURY_MINT_PERCENT = 25e16; // 25%
698 
699 	uint256 constant DEFAULT_REBASE_MINIMUM_INTERVAL = 24 hours;
700 	uint256 constant DEFAULT_REBASE_WINDOW_OFFSET = 17 hours; // 5PM UTC
701 	uint256 constant DEFAULT_REBASE_WINDOW_LENGTH = 1 hours;
702 	uint256 constant DEFAULT_REBASE_MINIMUM_DEVIATION = 5e16; // 5%
703 	uint256 constant DEFAULT_REBASE_DAMPENING_FACTOR = 10; // 10x to reach 100%
704 	uint256 constant DEFAULT_REBASE_TREASURY_MINT_PERCENT = 10e16; // 10%
705 
706 	struct Self {
707 		address treasury;
708 
709 		uint256 rebaseMinimumDeviation;
710 		uint256 rebaseDampeningFactor;
711 		uint256 rebaseTreasuryMintPercent;
712 
713 		uint256 rebaseMinimumInterval;
714 		uint256 rebaseWindowOffset;
715 		uint256 rebaseWindowLength;
716 
717 		bool rebaseActive;
718 		uint256 lastRebaseTime;
719 		uint256 epoch;
720 	}
721 
722 	function init(Self storage _self, address _treasury) public
723 	{
724 		_self.treasury = _treasury;
725 
726 		_self.rebaseMinimumDeviation = DEFAULT_REBASE_MINIMUM_DEVIATION;
727 		_self.rebaseDampeningFactor = DEFAULT_REBASE_DAMPENING_FACTOR;
728 		_self.rebaseTreasuryMintPercent = DEFAULT_REBASE_TREASURY_MINT_PERCENT;
729 
730 		_self.rebaseMinimumInterval = DEFAULT_REBASE_MINIMUM_INTERVAL;
731 		_self.rebaseWindowOffset = DEFAULT_REBASE_WINDOW_OFFSET;
732 		_self.rebaseWindowLength = DEFAULT_REBASE_WINDOW_LENGTH;
733 
734 		_self.rebaseActive = false;
735 		_self.lastRebaseTime = 0;
736 		_self.epoch = 0;
737 	}
738 
739 	function activateRebase(Self storage _self) public
740 	{
741 		require(!_self.rebaseActive, "already active");
742 		_self.rebaseActive = true;
743 		_self.lastRebaseTime = now.sub(now.mod(_self.rebaseMinimumInterval)).add(_self.rebaseWindowOffset);
744 	}
745 
746 	function setTreasury(Self storage _self, address _treasury) public
747 	{
748 		require(_treasury != address(0), "invalid treasury");
749 		_self.treasury = _treasury;
750 	}
751 
752 	function setRebaseMinimumDeviation(Self storage _self, uint256 _rebaseMinimumDeviation) public
753 	{
754 		require(_rebaseMinimumDeviation > 0, "invalid minimum deviation");
755 		_self.rebaseMinimumDeviation = _rebaseMinimumDeviation;
756 	}
757 
758 	function setRebaseDampeningFactor(Self storage _self, uint256 _rebaseDampeningFactor) public
759 	{
760 		require(_rebaseDampeningFactor > 0, "invalid dampening factor");
761 		_self.rebaseDampeningFactor = _rebaseDampeningFactor;
762 	}
763 
764 	function setRebaseTreasuryMintPercent(Self storage _self, uint256 _rebaseTreasuryMintPercent) public
765 	{
766 		require(_rebaseTreasuryMintPercent <= MAXIMUM_REBASE_TREASURY_MINT_PERCENT, "invalid percent");
767 		_self.rebaseTreasuryMintPercent = _rebaseTreasuryMintPercent;
768 	}
769 
770 	function setRebaseTimingParameters(Self storage _self, uint256 _rebaseMinimumInterval, uint256 _rebaseWindowOffset, uint256 _rebaseWindowLength) public
771 	{
772 		require(_rebaseMinimumInterval > 0, "invalid interval");
773 		require(_rebaseWindowOffset.add(_rebaseWindowLength) <= _rebaseMinimumInterval, "invalid window");
774 		_self.rebaseMinimumInterval = _rebaseMinimumInterval;
775 		_self.rebaseWindowOffset = _rebaseWindowOffset;
776 		_self.rebaseWindowLength = _rebaseWindowLength;
777 	}
778 
779 	function rebaseAvailable(Self storage _self) public view returns (bool _available)
780 	{
781 		return _self._rebaseAvailable();
782 	}
783 
784 	function rebase(Self storage _self, uint256 _exchangeRate, uint256 _totalSupply) public returns (uint256 _delta, bool _positive, uint256 _mintAmount)
785 	{
786 		require(_self._rebaseAvailable(), "not available");
787 
788 		_self.lastRebaseTime = now.sub(now.mod(_self.rebaseMinimumInterval)).add(_self.rebaseWindowOffset);
789 		_self.epoch = _self.epoch.add(1);
790 
791 		_positive = _exchangeRate > 1e18;
792 
793 		uint256 _deviation = _positive ? _exchangeRate.sub(1e18) : uint256(1e18).sub(_exchangeRate);
794 		if (_deviation < _self.rebaseMinimumDeviation) {
795 			_deviation = 0;
796 			_positive = false;
797 		}
798 
799 		_delta = _deviation.div(_self.rebaseDampeningFactor);
800 
801 		_mintAmount = 0;
802 		if (_positive) {
803 			uint256 _mintPercent = _delta.mul(_self.rebaseTreasuryMintPercent).div(1e18);
804 			_delta = _delta.sub(_mintPercent);
805 			_mintAmount = _totalSupply.mul(_mintPercent).div(1e18);
806 		}
807 
808 		return (_delta, _positive, _mintAmount);
809 	}
810 
811 	function _rebaseAvailable(Self storage _self) internal view returns (bool _available)
812 	{
813 		if (!_self.rebaseActive) return false;
814 		if (now < _self.lastRebaseTime.add(_self.rebaseMinimumInterval)) return false;
815 		uint256 _offset = now.mod(_self.rebaseMinimumInterval);
816 		return _self.rebaseWindowOffset <= _offset && _offset < _self.rebaseWindowOffset.add(_self.rebaseWindowLength);
817 	}
818 }
819 
820 // File: @uniswap/lib/contracts/libraries/FullMath.sol
821 
822 pragma solidity >=0.4.0;
823 
824 // taken from https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
825 // license is CC-BY-4.0
826 library FullMath {
827     function fullMul(uint256 x, uint256 y) internal pure returns (uint256 l, uint256 h) {
828         uint256 mm = mulmod(x, y, uint256(-1));
829         l = x * y;
830         h = mm - l;
831         if (mm < l) h -= 1;
832     }
833 
834     function fullDiv(
835         uint256 l,
836         uint256 h,
837         uint256 d
838     ) private pure returns (uint256) {
839         uint256 pow2 = d & -d;
840         d /= pow2;
841         l /= pow2;
842         l += h * ((-pow2) / pow2 + 1);
843         uint256 r = 1;
844         r *= 2 - d * r;
845         r *= 2 - d * r;
846         r *= 2 - d * r;
847         r *= 2 - d * r;
848         r *= 2 - d * r;
849         r *= 2 - d * r;
850         r *= 2 - d * r;
851         r *= 2 - d * r;
852         return l * r;
853     }
854 
855     function mulDiv(
856         uint256 x,
857         uint256 y,
858         uint256 d
859     ) internal pure returns (uint256) {
860         (uint256 l, uint256 h) = fullMul(x, y);
861 
862         uint256 mm = mulmod(x, y, d);
863         if (mm > l) h -= 1;
864         l -= mm;
865 
866         if (h == 0) return l / d;
867 
868         require(h < d, 'FullMath: FULLDIV_OVERFLOW');
869         return fullDiv(l, h, d);
870     }
871 }
872 
873 // File: @uniswap/lib/contracts/libraries/Babylonian.sol
874 
875 
876 pragma solidity >=0.4.0;
877 
878 // computes square roots using the babylonian method
879 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
880 library Babylonian {
881     // credit for this implementation goes to
882     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
883     function sqrt(uint256 x) internal pure returns (uint256) {
884         if (x == 0) return 0;
885         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
886         // however that code costs significantly more gas
887         uint256 xx = x;
888         uint256 r = 1;
889         if (xx >= 0x100000000000000000000000000000000) {
890             xx >>= 128;
891             r <<= 64;
892         }
893         if (xx >= 0x10000000000000000) {
894             xx >>= 64;
895             r <<= 32;
896         }
897         if (xx >= 0x100000000) {
898             xx >>= 32;
899             r <<= 16;
900         }
901         if (xx >= 0x10000) {
902             xx >>= 16;
903             r <<= 8;
904         }
905         if (xx >= 0x100) {
906             xx >>= 8;
907             r <<= 4;
908         }
909         if (xx >= 0x10) {
910             xx >>= 4;
911             r <<= 2;
912         }
913         if (xx >= 0x8) {
914             r <<= 1;
915         }
916         r = (r + x / r) >> 1;
917         r = (r + x / r) >> 1;
918         r = (r + x / r) >> 1;
919         r = (r + x / r) >> 1;
920         r = (r + x / r) >> 1;
921         r = (r + x / r) >> 1;
922         r = (r + x / r) >> 1; // Seven iterations should be enough
923         uint256 r1 = x / r;
924         return (r < r1 ? r : r1);
925     }
926 }
927 
928 // File: @uniswap/lib/contracts/libraries/BitMath.sol
929 
930 pragma solidity >=0.5.0;
931 
932 library BitMath {
933     // returns the 0 indexed position of the most significant bit of the input x
934     // s.t. x >= 2**msb and x < 2**(msb+1)
935     function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
936         require(x > 0, 'BitMath::mostSignificantBit: zero');
937 
938         if (x >= 0x100000000000000000000000000000000) {
939             x >>= 128;
940             r += 128;
941         }
942         if (x >= 0x10000000000000000) {
943             x >>= 64;
944             r += 64;
945         }
946         if (x >= 0x100000000) {
947             x >>= 32;
948             r += 32;
949         }
950         if (x >= 0x10000) {
951             x >>= 16;
952             r += 16;
953         }
954         if (x >= 0x100) {
955             x >>= 8;
956             r += 8;
957         }
958         if (x >= 0x10) {
959             x >>= 4;
960             r += 4;
961         }
962         if (x >= 0x4) {
963             x >>= 2;
964             r += 2;
965         }
966         if (x >= 0x2) r += 1;
967     }
968 
969     // returns the 0 indexed position of the least significant bit of the input x
970     // s.t. (x & 2**lsb) != 0 and (x & (2**(lsb) - 1)) == 0)
971     // i.e. the bit at the index is set and the mask of all lower bits is 0
972     function leastSignificantBit(uint256 x) internal pure returns (uint8 r) {
973         require(x > 0, 'BitMath::leastSignificantBit: zero');
974 
975         r = 255;
976         if (x & uint128(-1) > 0) {
977             r -= 128;
978         } else {
979             x >>= 128;
980         }
981         if (x & uint64(-1) > 0) {
982             r -= 64;
983         } else {
984             x >>= 64;
985         }
986         if (x & uint32(-1) > 0) {
987             r -= 32;
988         } else {
989             x >>= 32;
990         }
991         if (x & uint16(-1) > 0) {
992             r -= 16;
993         } else {
994             x >>= 16;
995         }
996         if (x & uint8(-1) > 0) {
997             r -= 8;
998         } else {
999             x >>= 8;
1000         }
1001         if (x & 0xf > 0) {
1002             r -= 4;
1003         } else {
1004             x >>= 4;
1005         }
1006         if (x & 0x3 > 0) {
1007             r -= 2;
1008         } else {
1009             x >>= 2;
1010         }
1011         if (x & 0x1 > 0) r -= 1;
1012     }
1013 }
1014 
1015 // File: @uniswap/lib/contracts/libraries/FixedPoint.sol
1016 
1017 pragma solidity >=0.4.0;
1018 
1019 
1020 
1021 
1022 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
1023 library FixedPoint {
1024     // range: [0, 2**112 - 1]
1025     // resolution: 1 / 2**112
1026     struct uq112x112 {
1027         uint224 _x;
1028     }
1029 
1030     // range: [0, 2**144 - 1]
1031     // resolution: 1 / 2**112
1032     struct uq144x112 {
1033         uint256 _x;
1034     }
1035 
1036     uint8 public constant RESOLUTION = 112;
1037     uint256 public constant Q112 = 0x10000000000000000000000000000; // 2**112
1038     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000; // 2**224
1039     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
1040 
1041     // encode a uint112 as a UQ112x112
1042     function encode(uint112 x) internal pure returns (uq112x112 memory) {
1043         return uq112x112(uint224(x) << RESOLUTION);
1044     }
1045 
1046     // encodes a uint144 as a UQ144x112
1047     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
1048         return uq144x112(uint256(x) << RESOLUTION);
1049     }
1050 
1051     // decode a UQ112x112 into a uint112 by truncating after the radix point
1052     function decode(uq112x112 memory self) internal pure returns (uint112) {
1053         return uint112(self._x >> RESOLUTION);
1054     }
1055 
1056     // decode a UQ144x112 into a uint144 by truncating after the radix point
1057     function decode144(uq144x112 memory self) internal pure returns (uint144) {
1058         return uint144(self._x >> RESOLUTION);
1059     }
1060 
1061     // multiply a UQ112x112 by a uint, returning a UQ144x112
1062     // reverts on overflow
1063     function mul(uq112x112 memory self, uint256 y) internal pure returns (uq144x112 memory) {
1064         uint256 z = 0;
1065         require(y == 0 || (z = self._x * y) / y == self._x, 'FixedPoint::mul: overflow');
1066         return uq144x112(z);
1067     }
1068 
1069     // multiply a UQ112x112 by an int and decode, returning an int
1070     // reverts on overflow
1071     function muli(uq112x112 memory self, int256 y) internal pure returns (int256) {
1072         uint256 z = FullMath.mulDiv(self._x, uint256(y < 0 ? -y : y), Q112);
1073         require(z < 2**255, 'FixedPoint::muli: overflow');
1074         return y < 0 ? -int256(z) : int256(z);
1075     }
1076 
1077     // multiply a UQ112x112 by a UQ112x112, returning a UQ112x112
1078     // lossy
1079     function muluq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
1080         if (self._x == 0 || other._x == 0) {
1081             return uq112x112(0);
1082         }
1083         uint112 upper_self = uint112(self._x >> RESOLUTION); // * 2^0
1084         uint112 lower_self = uint112(self._x & LOWER_MASK); // * 2^-112
1085         uint112 upper_other = uint112(other._x >> RESOLUTION); // * 2^0
1086         uint112 lower_other = uint112(other._x & LOWER_MASK); // * 2^-112
1087 
1088         // partial products
1089         uint224 upper = uint224(upper_self) * upper_other; // * 2^0
1090         uint224 lower = uint224(lower_self) * lower_other; // * 2^-224
1091         uint224 uppers_lowero = uint224(upper_self) * lower_other; // * 2^-112
1092         uint224 uppero_lowers = uint224(upper_other) * lower_self; // * 2^-112
1093 
1094         // so the bit shift does not overflow
1095         require(upper <= uint112(-1), 'FixedPoint::muluq: upper overflow');
1096 
1097         // this cannot exceed 256 bits, all values are 224 bits
1098         uint256 sum = uint256(upper << RESOLUTION) + uppers_lowero + uppero_lowers + (lower >> RESOLUTION);
1099 
1100         // so the cast does not overflow
1101         require(sum <= uint224(-1), 'FixedPoint::muluq: sum overflow');
1102 
1103         return uq112x112(uint224(sum));
1104     }
1105 
1106     // divide a UQ112x112 by a UQ112x112, returning a UQ112x112
1107     function divuq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
1108         require(other._x > 0, 'FixedPoint::divuq: division by zero');
1109         if (self._x == other._x) {
1110             return uq112x112(uint224(Q112));
1111         }
1112         if (self._x <= uint144(-1)) {
1113             uint256 value = (uint256(self._x) << RESOLUTION) / other._x;
1114             require(value <= uint224(-1), 'FixedPoint::divuq: overflow');
1115             return uq112x112(uint224(value));
1116         }
1117 
1118         uint256 result = FullMath.mulDiv(Q112, self._x, other._x);
1119         require(result <= uint224(-1), 'FixedPoint::divuq: overflow');
1120         return uq112x112(uint224(result));
1121     }
1122 
1123     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
1124     // can be lossy
1125     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
1126         require(denominator > 0, 'FixedPoint::fraction: division by zero');
1127         if (numerator == 0) return FixedPoint.uq112x112(0);
1128 
1129         if (numerator <= uint144(-1)) {
1130             uint256 result = (numerator << RESOLUTION) / denominator;
1131             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
1132             return uq112x112(uint224(result));
1133         } else {
1134             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
1135             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
1136             return uq112x112(uint224(result));
1137         }
1138     }
1139 
1140     // take the reciprocal of a UQ112x112
1141     // reverts on overflow
1142     // lossy
1143     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1144         require(self._x != 0, 'FixedPoint::reciprocal: reciprocal of zero');
1145         require(self._x != 1, 'FixedPoint::reciprocal: overflow');
1146         return uq112x112(uint224(Q224 / self._x));
1147     }
1148 
1149     // square root of a UQ112x112
1150     // lossy between 0/1 and 40 bits
1151     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1152         if (self._x <= uint144(-1)) {
1153             return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
1154         }
1155 
1156         uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
1157         safeShiftBits -= safeShiftBits % 2;
1158         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
1159     }
1160 }
1161 
1162 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1163 
1164 pragma solidity >=0.5.0;
1165 
1166 interface IUniswapV2Pair {
1167     event Approval(address indexed owner, address indexed spender, uint value);
1168     event Transfer(address indexed from, address indexed to, uint value);
1169 
1170     function name() external pure returns (string memory);
1171     function symbol() external pure returns (string memory);
1172     function decimals() external pure returns (uint8);
1173     function totalSupply() external view returns (uint);
1174     function balanceOf(address owner) external view returns (uint);
1175     function allowance(address owner, address spender) external view returns (uint);
1176 
1177     function approve(address spender, uint value) external returns (bool);
1178     function transfer(address to, uint value) external returns (bool);
1179     function transferFrom(address from, address to, uint value) external returns (bool);
1180 
1181     function DOMAIN_SEPARATOR() external view returns (bytes32);
1182     function PERMIT_TYPEHASH() external pure returns (bytes32);
1183     function nonces(address owner) external view returns (uint);
1184 
1185     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1186 
1187     event Mint(address indexed sender, uint amount0, uint amount1);
1188     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1189     event Swap(
1190         address indexed sender,
1191         uint amount0In,
1192         uint amount1In,
1193         uint amount0Out,
1194         uint amount1Out,
1195         address indexed to
1196     );
1197     event Sync(uint112 reserve0, uint112 reserve1);
1198 
1199     function MINIMUM_LIQUIDITY() external pure returns (uint);
1200     function factory() external view returns (address);
1201     function token0() external view returns (address);
1202     function token1() external view returns (address);
1203     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1204     function price0CumulativeLast() external view returns (uint);
1205     function price1CumulativeLast() external view returns (uint);
1206     function kLast() external view returns (uint);
1207 
1208     function mint(address to) external returns (uint liquidity);
1209     function burn(address to) external returns (uint amount0, uint amount1);
1210     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1211     function skim(address to) external;
1212     function sync() external;
1213 
1214     function initialize(address, address) external;
1215 }
1216 
1217 // File: @uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol
1218 
1219 pragma solidity >=0.5.0;
1220 
1221 
1222 
1223 // library with helper methods for oracles that are concerned with computing average prices
1224 library UniswapV2OracleLibrary {
1225     using FixedPoint for *;
1226 
1227     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
1228     function currentBlockTimestamp() internal view returns (uint32) {
1229         return uint32(block.timestamp % 2 ** 32);
1230     }
1231 
1232     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
1233     function currentCumulativePrices(
1234         address pair
1235     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
1236         blockTimestamp = currentBlockTimestamp();
1237         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1238         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1239 
1240         // if time has elapsed since the last update on the pair, mock the accumulated price values
1241         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
1242         if (blockTimestampLast != blockTimestamp) {
1243             // subtraction overflow is desired
1244             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1245             // addition overflow is desired
1246             // counterfactual
1247             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
1248             // counterfactual
1249             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
1250         }
1251     }
1252 }
1253 
1254 // File: contracts/interop/UniswapV2.sol
1255 
1256 pragma solidity ^0.6.0;
1257 
1258 
1259 /**
1260  * @dev Minimal set of declarations for Uniswap V2 interoperability.
1261  */
1262 interface Factory
1263 {
1264 	function getPair(address _tokenA, address _tokenB) external view returns (address _pair);
1265 	function createPair(address _tokenA, address _tokenB) external returns (address _pair);
1266 }
1267 
1268 interface PoolToken is IERC20
1269 {
1270 }
1271 
1272 interface Pair is PoolToken
1273 {
1274 	function token0() external view returns (address _token0);
1275 	function token1() external view returns (address _token1);
1276 	function price0CumulativeLast() external view returns (uint256 _price0CumulativeLast);
1277 	function price1CumulativeLast() external view returns (uint256 _price1CumulativeLast);
1278 	function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
1279 	function mint(address _to) external returns (uint256 _liquidity);
1280 	function sync() external;
1281 }
1282 
1283 interface Router01
1284 {
1285 	function WETH() external pure returns (address _token);
1286 	function addLiquidity(address _tokenA, address _tokenB, uint256 _amountADesired, uint256 _amountBDesired, uint256 _amountAMin, uint256 _amountBMin, address _to, uint256 _deadline) external returns (uint256 _amountA, uint256 _amountB, uint256 _liquidity);
1287 	function removeLiquidity(address _tokenA, address _tokenB, uint256 _liquidity, uint256 _amountAMin, uint256 _amountBMin, address _to, uint256 _deadline) external returns (uint256 _amountA, uint256 _amountB);
1288 	function swapExactTokensForTokens(uint256 _amountIn, uint256 _amountOutMin, address[] calldata _path, address _to, uint256 _deadline) external returns (uint256[] memory _amounts);
1289 	function swapETHForExactTokens(uint256 _amountOut, address[] calldata _path, address _to, uint256 _deadline) external payable returns (uint256[] memory _amounts);
1290 	function getAmountOut(uint256 _amountIn, uint256 _reserveIn, uint256 _reserveOut) external pure returns (uint256 _amountOut);
1291 }
1292 
1293 interface Router02 is Router01
1294 {
1295 }
1296 
1297 // File: contracts/GPriceOracle.sol
1298 
1299 pragma solidity ^0.6.0;
1300 
1301 
1302 
1303 
1304 /**
1305  * @dev This library implements a TWAP oracle on Uniswap V2. Based on
1306  * https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleOracleSimple.sol
1307  */
1308 library GPriceOracle
1309 {
1310 	using FixedPoint for FixedPoint.uq112x112;
1311 	using FixedPoint for FixedPoint.uq144x112;
1312 	using GPriceOracle for GPriceOracle.Self;
1313 
1314 	uint256 constant DEFAULT_MINIMUM_INTERVAL = 23 hours;
1315 
1316 	struct Self {
1317 		address pair;
1318 		bool use0;
1319 
1320 		uint256 minimumInterval;
1321 
1322 		uint256 priceCumulativeLast;
1323 		uint32 blockTimestampLast;
1324 		FixedPoint.uq112x112 priceAverage;
1325 	}
1326 
1327 	function init(Self storage _self) public
1328 	{
1329 		_self.pair = address(0);
1330 
1331 		_self.minimumInterval = DEFAULT_MINIMUM_INTERVAL;
1332 	}
1333 
1334 	function active(Self storage _self) public view returns (bool _isActive)
1335 	{
1336 		return _self._active();
1337 	}
1338 
1339 	function activate(Self storage _self, address _pair, bool _use0) public
1340 	{
1341 		require(!_self._active(), "already active");
1342 		require(_pair != address(0), "invalid pair");
1343 
1344 		_self.pair = _pair;
1345 		_self.use0 = _use0;
1346 
1347 		_self.priceCumulativeLast = _use0 ? Pair(_pair).price0CumulativeLast() : Pair(_pair).price1CumulativeLast();
1348 
1349 		uint112 reserve0;
1350 		uint112 reserve1;
1351 		(reserve0, reserve1, _self.blockTimestampLast) = Pair(_pair).getReserves();
1352 		require(reserve0 > 0 && reserve1 > 0, "no reserves"); // ensure that there's liquidity in the pair
1353 	}
1354 
1355 	function changeMinimumInterval(Self storage _self, uint256 _minimumInterval) public
1356 	{
1357 		require(_minimumInterval > 0, "invalid interval");
1358 		_self.minimumInterval = _minimumInterval;
1359 	}
1360 
1361 	function consultLastPrice(Self storage _self, uint256 _amountIn) public view returns (uint256 _amountOut)
1362 	{
1363 		require(_self._active(), "not active");
1364 
1365 		return _self.priceAverage.mul(_amountIn).decode144();
1366 	}
1367 
1368 	function consultCurrentPrice(Self storage _self, uint256 _amountIn) public view returns (uint256 _amountOut)
1369 	{
1370 		require(_self._active(), "not active");
1371 
1372 		(,, FixedPoint.uq112x112 memory _priceAverage) = _self._estimatePrice(false);
1373 		return _priceAverage.mul(_amountIn).decode144();
1374 	}
1375 
1376 	function updatePrice(Self storage _self) public
1377 	{
1378 		require(_self._active(), "not active");
1379 
1380 		(_self.priceCumulativeLast, _self.blockTimestampLast, _self.priceAverage) = _self._estimatePrice(true);
1381 	}
1382 
1383 	function _active(Self storage _self) internal view returns (bool _isActive)
1384 	{
1385 		return _self.pair != address(0);
1386 	}
1387 
1388 	function _estimatePrice(Self storage _self, bool _enforceTimeElapsed) internal view returns (uint256 _priceCumulative, uint32 _blockTimestamp, FixedPoint.uq112x112 memory _priceAverage)
1389 	{
1390 		uint256 _price0Cumulative;
1391 		uint256 _price1Cumulative;
1392 		(_price0Cumulative, _price1Cumulative, _blockTimestamp) = UniswapV2OracleLibrary.currentCumulativePrices(_self.pair);
1393 		_priceCumulative = _self.use0 ? _price0Cumulative : _price1Cumulative;
1394 
1395 		uint32 _timeElapsed = _blockTimestamp - _self.blockTimestampLast; // overflow is desired
1396 
1397 		// ensure that at least one full interval has passed since the last update
1398 		if (_enforceTimeElapsed) {
1399 			require(_timeElapsed >= _self.minimumInterval, "minimum interval not elapsed");
1400 		}
1401 
1402 		// overflow is desired, casting never truncates
1403 		// cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
1404 		_priceAverage = FixedPoint.uq112x112(uint224((_priceCumulative - _self.priceCumulativeLast) / _timeElapsed));
1405 	}
1406 }
1407 
1408 // File: contracts/modules/Math.sol
1409 
1410 pragma solidity ^0.6.0;
1411 
1412 /**
1413  * @dev This library implements auxiliary math definitions.
1414  */
1415 library Math
1416 {
1417 	function _min(uint256 _amount1, uint256 _amount2) internal pure returns (uint256 _minAmount)
1418 	{
1419 		return _amount1 < _amount2 ? _amount1 : _amount2;
1420 	}
1421 
1422 	function _max(uint256 _amount1, uint256 _amount2) internal pure returns (uint256 _maxAmount)
1423 	{
1424 		return _amount1 > _amount2 ? _amount1 : _amount2;
1425 	}
1426 }
1427 
1428 // File: contracts/GElasticToken.sol
1429 
1430 pragma solidity ^0.6.0;
1431 
1432 
1433 
1434 
1435 
1436 
1437 
1438 
1439 
1440 
1441 
1442 /**
1443  * @notice This contract implements an ERC20 compatible elastic token that
1444  * rebases according to the TWAP of another token. Inspired by AMPL and YAM.
1445  */
1446 contract GElasticToken is ElasticERC20, Ownable, ReentrancyGuard, GElastic
1447 {
1448 	using SafeMath for uint256;
1449 	using GElasticTokenManager for GElasticTokenManager.Self;
1450 	using GPriceOracle for GPriceOracle.Self;
1451 	using Executor for Executor.Target[];
1452 
1453 	address public immutable override referenceToken;
1454 
1455 	GElasticTokenManager.Self etm;
1456 	GPriceOracle.Self oracle;
1457 
1458 	Executor.Target[] public targets;
1459 
1460 	modifier onlyEOA()
1461 	{
1462 		require(tx.origin == _msgSender(), "not an externally owned account");
1463 		_;
1464 	}
1465 
1466 	constructor (string memory _name, string memory _symbol, uint8 _decimals, address _referenceToken, uint256 _initialSupply)
1467 		ElasticERC20(_name, _symbol) public
1468 	{
1469 		address _treasury = msg.sender;
1470 		_setupDecimals(_decimals);
1471 		assert(_referenceToken != address(0));
1472 		referenceToken = _referenceToken;
1473 		etm.init(_treasury);
1474 		oracle.init();
1475 		_mint(_treasury, _initialSupply);
1476 	}
1477 
1478 	function treasury() external view override returns (address _treasury)
1479 	{
1480 		return etm.treasury;
1481 	}
1482 
1483 	function rebaseMinimumDeviation() external view override returns (uint256 _rebaseMinimumDeviation)
1484 	{
1485 		return etm.rebaseMinimumDeviation;
1486 	}
1487 
1488 	function rebaseDampeningFactor() external view override returns (uint256 _rebaseDampeningFactor)
1489 	{
1490 		return etm.rebaseDampeningFactor;
1491 	}
1492 
1493 	function rebaseTreasuryMintPercent() external view override returns (uint256 _rebaseTreasuryMintPercent)
1494 	{
1495 		return etm.rebaseTreasuryMintPercent;
1496 	}
1497 
1498 	function rebaseTimingParameters() external view override returns (uint256 _rebaseMinimumInterval, uint256 _rebaseWindowOffset, uint256 _rebaseWindowLength)
1499 	{
1500 		return (etm.rebaseMinimumInterval, etm.rebaseWindowOffset, etm.rebaseWindowLength);
1501 	}
1502 
1503 	function rebaseAvailable() external view override returns (bool _rebaseAvailable)
1504 	{
1505 		return etm.rebaseAvailable();
1506 	}
1507 
1508 	function rebaseActive() external view override returns (bool _rebaseActive)
1509 	{
1510 		return etm.rebaseActive;
1511 	}
1512 
1513 	function lastRebaseTime() external view override returns (uint256 _lastRebaseTime)
1514 	{
1515 		return etm.lastRebaseTime;
1516 	}
1517 
1518 	function epoch() external view override returns (uint256 _epoch)
1519 	{
1520 		return etm.epoch;
1521 	}
1522 
1523 	function lastExchangeRate() external view override returns (uint256 _exchangeRate)
1524 	{
1525 		return oracle.consultLastPrice(10 ** uint256(decimals()));
1526 	}
1527 
1528 	function currentExchangeRate() external view override returns (uint256 _exchangeRate)
1529 	{
1530 		return oracle.consultCurrentPrice(10 ** uint256(decimals()));
1531 	}
1532 
1533 	function pair() external view override returns (address _pair)
1534 	{
1535 		return oracle.pair;
1536 	}
1537 
1538 	function rebase() external override onlyEOA nonReentrant
1539 	{
1540 		oracle.updatePrice();
1541 
1542 		uint256 _exchangeRate = oracle.consultLastPrice(10 ** uint256(decimals()));
1543 
1544 		uint256 _totalSupply = totalSupply();
1545 
1546 		(uint256 _delta, bool _positive, uint256 _mintAmount) = etm.rebase(_exchangeRate, _totalSupply);
1547 
1548 		_rebase(etm.epoch, _delta, _positive);
1549 
1550 		if (_mintAmount > 0) {
1551 			_mint(etm.treasury, _mintAmount);
1552 		}
1553 
1554 		// updates cached reserve balances wherever necessary
1555 		Pair(oracle.pair).sync();
1556 		targets.executeAll();
1557 	}
1558 
1559 	function activateOracle(address _pair) external override onlyOwner nonReentrant
1560 	{
1561 		address _token0 = Pair(_pair).token0();
1562 		address _token1 = Pair(_pair).token1();
1563 		require(_token0 == address(this) && _token1 == referenceToken || _token1 == address(this) && _token0 == referenceToken, "invalid pair");
1564 		oracle.activate(_pair, _token0 == address(this));
1565 	}
1566 
1567 	function activateRebase() external override onlyOwner nonReentrant
1568 	{
1569 		require(oracle.active(), "not available");
1570 		etm.activateRebase();
1571 	}
1572 
1573 	function setTreasury(address _newTreasury) external override onlyOwner nonReentrant
1574 	{
1575 		address _oldTreasury = etm.treasury;
1576 		etm.setTreasury(_newTreasury);
1577 		emit ChangeTreasury(_oldTreasury, _newTreasury);
1578 	}
1579 
1580 	function setRebaseMinimumDeviation(uint256 _newRebaseMinimumDeviation) external override onlyOwner nonReentrant
1581 	{
1582 		uint256 _oldRebaseMinimumDeviation = etm.rebaseMinimumDeviation;
1583 		etm.setRebaseMinimumDeviation(_newRebaseMinimumDeviation);
1584 		emit ChangeRebaseMinimumDeviation(_oldRebaseMinimumDeviation, _newRebaseMinimumDeviation);
1585 	}
1586 
1587 	function setRebaseDampeningFactor(uint256 _newRebaseDampeningFactor) external override onlyOwner nonReentrant
1588 	{
1589 		uint256 _oldRebaseDampeningFactor = etm.rebaseDampeningFactor;
1590 		etm.setRebaseDampeningFactor(_newRebaseDampeningFactor);
1591 		emit ChangeRebaseDampeningFactor(_oldRebaseDampeningFactor, _newRebaseDampeningFactor);
1592 	}
1593 
1594 	function setRebaseTreasuryMintPercent(uint256 _newRebaseTreasuryMintPercent) external override onlyOwner nonReentrant
1595 	{
1596 		uint256 _oldRebaseTreasuryMintPercent = etm.rebaseTreasuryMintPercent;
1597 		etm.setRebaseTreasuryMintPercent(_newRebaseTreasuryMintPercent);
1598 		emit ChangeRebaseTreasuryMintPercent(_oldRebaseTreasuryMintPercent, _newRebaseTreasuryMintPercent);
1599 	}
1600 
1601 	function setRebaseTimingParameters(uint256 _newRebaseMinimumInterval, uint256 _newRebaseWindowOffset, uint256 _newRebaseWindowLength) external override onlyOwner nonReentrant
1602 	{
1603 		uint256 _oldRebaseMinimumInterval = etm.rebaseMinimumInterval;
1604 		uint256 _oldRebaseWindowOffset = etm.rebaseWindowOffset;
1605 		uint256 _oldRebaseWindowLength = etm.rebaseWindowLength;
1606 		etm.setRebaseTimingParameters(_newRebaseMinimumInterval, _newRebaseWindowOffset, _newRebaseWindowLength);
1607 		oracle.changeMinimumInterval(_newRebaseMinimumInterval.sub(_newRebaseWindowLength));
1608 		emit ChangeRebaseTimingParameters(_oldRebaseMinimumInterval, _oldRebaseWindowOffset, _oldRebaseWindowLength, _newRebaseMinimumInterval, _newRebaseWindowOffset, _newRebaseWindowLength);
1609 	}
1610 
1611 	function addPostRebaseTarget(address _to, bytes memory _data) external override onlyOwner nonReentrant
1612 	{
1613 		_addPostRebaseTarget(_to, _data);
1614 	}
1615 
1616 	function removePostRebaseTarget(uint256 _index) external override onlyOwner nonReentrant
1617 	{
1618 		_removePostRebaseTarget(_index);
1619 	}
1620 
1621 	function addBalancerPostRebaseTarget(address _pool) external onlyOwner nonReentrant
1622 	{
1623 		_addPostRebaseTarget(_pool, abi.encodeWithSignature("gulp(address)", address(this)));
1624 	}
1625 
1626 	function addUniswapV2PostRebaseTarget(address _pair) external onlyOwner nonReentrant
1627 	{
1628 		_addPostRebaseTarget(_pair, abi.encodeWithSignature("sync()"));
1629 	}
1630 
1631 	function _addPostRebaseTarget(address _to, bytes memory _data) internal
1632 	{
1633 		targets.addTarget(_to, _data);
1634 		emit AddPostRebaseTarget(_to, _data);
1635 	}
1636 
1637 	function _removePostRebaseTarget(uint256 _index) internal
1638 	{
1639 		Executor.Target storage _target = targets[_index];
1640 		address _to = _target.to;
1641 		bytes memory _data = _target.data;
1642 		targets.removeTarget(_index);
1643 		emit RemovePostRebaseTarget(_to, _data);
1644 	}
1645 
1646 	function _rebase(uint256 _epoch, uint256 _delta, bool _positive) internal virtual
1647 	{
1648 		uint256 _oldScalingFactor = scalingFactor();
1649 		uint256 _newScalingFactor;
1650 		if (_delta == 0) {
1651 			_newScalingFactor = _oldScalingFactor;
1652 		} else {
1653 			if (_positive) {
1654 				_newScalingFactor = _oldScalingFactor.mul(uint256(1e18).add(_delta)).div(1e18);
1655 			} else {
1656 				_newScalingFactor = _oldScalingFactor.mul(uint256(1e18).sub(_delta)).div(1e18);
1657 			}
1658 		}
1659 		if (_newScalingFactor > _oldScalingFactor) {
1660 			_newScalingFactor = Math._min(_newScalingFactor, maxScalingFactor());
1661 		}
1662 		_setScalingFactor(_newScalingFactor);
1663 		emit Rebase(_epoch, _oldScalingFactor, _newScalingFactor);
1664 	}
1665 }
1666 
1667 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1668 
1669 
1670 pragma solidity >=0.6.0 <0.8.0;
1671 
1672 
1673 
1674 
1675 /**
1676  * @dev Implementation of the {IERC20} interface.
1677  *
1678  * This implementation is agnostic to the way tokens are created. This means
1679  * that a supply mechanism has to be added in a derived contract using {_mint}.
1680  * For a generic mechanism see {ERC20PresetMinterPauser}.
1681  *
1682  * TIP: For a detailed writeup see our guide
1683  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1684  * to implement supply mechanisms].
1685  *
1686  * We have followed general OpenZeppelin guidelines: functions revert instead
1687  * of returning `false` on failure. This behavior is nonetheless conventional
1688  * and does not conflict with the expectations of ERC20 applications.
1689  *
1690  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1691  * This allows applications to reconstruct the allowance for all accounts just
1692  * by listening to said events. Other implementations of the EIP may not emit
1693  * these events, as it isn't required by the specification.
1694  *
1695  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1696  * functions have been added to mitigate the well-known issues around setting
1697  * allowances. See {IERC20-approve}.
1698  */
1699 contract ERC20 is Context, IERC20 {
1700     using SafeMath for uint256;
1701 
1702     mapping (address => uint256) private _balances;
1703 
1704     mapping (address => mapping (address => uint256)) private _allowances;
1705 
1706     uint256 private _totalSupply;
1707 
1708     string private _name;
1709     string private _symbol;
1710     uint8 private _decimals;
1711 
1712     /**
1713      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1714      * a default value of 18.
1715      *
1716      * To select a different value for {decimals}, use {_setupDecimals}.
1717      *
1718      * All three of these values are immutable: they can only be set once during
1719      * construction.
1720      */
1721     constructor (string memory name_, string memory symbol_) public {
1722         _name = name_;
1723         _symbol = symbol_;
1724         _decimals = 18;
1725     }
1726 
1727     /**
1728      * @dev Returns the name of the token.
1729      */
1730     function name() public view returns (string memory) {
1731         return _name;
1732     }
1733 
1734     /**
1735      * @dev Returns the symbol of the token, usually a shorter version of the
1736      * name.
1737      */
1738     function symbol() public view returns (string memory) {
1739         return _symbol;
1740     }
1741 
1742     /**
1743      * @dev Returns the number of decimals used to get its user representation.
1744      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1745      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1746      *
1747      * Tokens usually opt for a value of 18, imitating the relationship between
1748      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1749      * called.
1750      *
1751      * NOTE: This information is only used for _display_ purposes: it in
1752      * no way affects any of the arithmetic of the contract, including
1753      * {IERC20-balanceOf} and {IERC20-transfer}.
1754      */
1755     function decimals() public view returns (uint8) {
1756         return _decimals;
1757     }
1758 
1759     /**
1760      * @dev See {IERC20-totalSupply}.
1761      */
1762     function totalSupply() public view override returns (uint256) {
1763         return _totalSupply;
1764     }
1765 
1766     /**
1767      * @dev See {IERC20-balanceOf}.
1768      */
1769     function balanceOf(address account) public view override returns (uint256) {
1770         return _balances[account];
1771     }
1772 
1773     /**
1774      * @dev See {IERC20-transfer}.
1775      *
1776      * Requirements:
1777      *
1778      * - `recipient` cannot be the zero address.
1779      * - the caller must have a balance of at least `amount`.
1780      */
1781     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1782         _transfer(_msgSender(), recipient, amount);
1783         return true;
1784     }
1785 
1786     /**
1787      * @dev See {IERC20-allowance}.
1788      */
1789     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1790         return _allowances[owner][spender];
1791     }
1792 
1793     /**
1794      * @dev See {IERC20-approve}.
1795      *
1796      * Requirements:
1797      *
1798      * - `spender` cannot be the zero address.
1799      */
1800     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1801         _approve(_msgSender(), spender, amount);
1802         return true;
1803     }
1804 
1805     /**
1806      * @dev See {IERC20-transferFrom}.
1807      *
1808      * Emits an {Approval} event indicating the updated allowance. This is not
1809      * required by the EIP. See the note at the beginning of {ERC20}.
1810      *
1811      * Requirements:
1812      *
1813      * - `sender` and `recipient` cannot be the zero address.
1814      * - `sender` must have a balance of at least `amount`.
1815      * - the caller must have allowance for ``sender``'s tokens of at least
1816      * `amount`.
1817      */
1818     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1819         _transfer(sender, recipient, amount);
1820         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1821         return true;
1822     }
1823 
1824     /**
1825      * @dev Atomically increases the allowance granted to `spender` by the caller.
1826      *
1827      * This is an alternative to {approve} that can be used as a mitigation for
1828      * problems described in {IERC20-approve}.
1829      *
1830      * Emits an {Approval} event indicating the updated allowance.
1831      *
1832      * Requirements:
1833      *
1834      * - `spender` cannot be the zero address.
1835      */
1836     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1837         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1838         return true;
1839     }
1840 
1841     /**
1842      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1843      *
1844      * This is an alternative to {approve} that can be used as a mitigation for
1845      * problems described in {IERC20-approve}.
1846      *
1847      * Emits an {Approval} event indicating the updated allowance.
1848      *
1849      * Requirements:
1850      *
1851      * - `spender` cannot be the zero address.
1852      * - `spender` must have allowance for the caller of at least
1853      * `subtractedValue`.
1854      */
1855     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1856         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1857         return true;
1858     }
1859 
1860     /**
1861      * @dev Moves tokens `amount` from `sender` to `recipient`.
1862      *
1863      * This is internal function is equivalent to {transfer}, and can be used to
1864      * e.g. implement automatic token fees, slashing mechanisms, etc.
1865      *
1866      * Emits a {Transfer} event.
1867      *
1868      * Requirements:
1869      *
1870      * - `sender` cannot be the zero address.
1871      * - `recipient` cannot be the zero address.
1872      * - `sender` must have a balance of at least `amount`.
1873      */
1874     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1875         require(sender != address(0), "ERC20: transfer from the zero address");
1876         require(recipient != address(0), "ERC20: transfer to the zero address");
1877 
1878         _beforeTokenTransfer(sender, recipient, amount);
1879 
1880         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1881         _balances[recipient] = _balances[recipient].add(amount);
1882         emit Transfer(sender, recipient, amount);
1883     }
1884 
1885     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1886      * the total supply.
1887      *
1888      * Emits a {Transfer} event with `from` set to the zero address.
1889      *
1890      * Requirements:
1891      *
1892      * - `to` cannot be the zero address.
1893      */
1894     function _mint(address account, uint256 amount) internal virtual {
1895         require(account != address(0), "ERC20: mint to the zero address");
1896 
1897         _beforeTokenTransfer(address(0), account, amount);
1898 
1899         _totalSupply = _totalSupply.add(amount);
1900         _balances[account] = _balances[account].add(amount);
1901         emit Transfer(address(0), account, amount);
1902     }
1903 
1904     /**
1905      * @dev Destroys `amount` tokens from `account`, reducing the
1906      * total supply.
1907      *
1908      * Emits a {Transfer} event with `to` set to the zero address.
1909      *
1910      * Requirements:
1911      *
1912      * - `account` cannot be the zero address.
1913      * - `account` must have at least `amount` tokens.
1914      */
1915     function _burn(address account, uint256 amount) internal virtual {
1916         require(account != address(0), "ERC20: burn from the zero address");
1917 
1918         _beforeTokenTransfer(account, address(0), amount);
1919 
1920         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1921         _totalSupply = _totalSupply.sub(amount);
1922         emit Transfer(account, address(0), amount);
1923     }
1924 
1925     /**
1926      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1927      *
1928      * This internal function is equivalent to `approve`, and can be used to
1929      * e.g. set automatic allowances for certain subsystems, etc.
1930      *
1931      * Emits an {Approval} event.
1932      *
1933      * Requirements:
1934      *
1935      * - `owner` cannot be the zero address.
1936      * - `spender` cannot be the zero address.
1937      */
1938     function _approve(address owner, address spender, uint256 amount) internal virtual {
1939         require(owner != address(0), "ERC20: approve from the zero address");
1940         require(spender != address(0), "ERC20: approve to the zero address");
1941 
1942         _allowances[owner][spender] = amount;
1943         emit Approval(owner, spender, amount);
1944     }
1945 
1946     /**
1947      * @dev Sets {decimals} to a value other than the default one of 18.
1948      *
1949      * WARNING: This function should only be called from the constructor. Most
1950      * applications that interact with token contracts will not expect
1951      * {decimals} to ever change, and may work incorrectly if it does.
1952      */
1953     function _setupDecimals(uint8 decimals_) internal {
1954         _decimals = decimals_;
1955     }
1956 
1957     /**
1958      * @dev Hook that is called before any transfer of tokens. This includes
1959      * minting and burning.
1960      *
1961      * Calling conditions:
1962      *
1963      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1964      * will be to transferred to `to`.
1965      * - when `from` is zero, `amount` tokens will be minted for `to`.
1966      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1967      * - `from` and `to` are never both zero.
1968      *
1969      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1970      */
1971     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1972 }
1973 
1974 // File: contracts/GLPMining.sol
1975 
1976 pragma solidity ^0.6.0;
1977 
1978 /**
1979  * @dev This interface exposes the base functionality of GLPMiningToken.
1980  */
1981 interface GLPMining
1982 {
1983 	// view functions
1984 	function reserveToken() external view returns (address _reserveToken);
1985 	function rewardsToken() external view returns (address _rewardsToken);
1986 	function treasury() external view returns (address _treasury);
1987 	function performanceFee() external view returns (uint256 _performanceFee);
1988 	function rewardRatePerWeek() external view returns (uint256 _rewardRatePerWeek);
1989 	function calcSharesFromCost(uint256 _cost) external view returns (uint256 _shares);
1990 	function calcCostFromShares(uint256 _shares) external view returns (uint256 _cost);
1991 	function calcSharesFromTokenAmount(address _token, uint256 _amount) external view returns (uint256 _shares);
1992 	function calcTokenAmountFromShares(address _token, uint256 _shares) external view returns (uint256 _amount);
1993 	function totalReserve() external view returns (uint256 _totalReserve);
1994 	function rewardInfo() external view returns (uint256 _lockedReward, uint256 _unlockedReward, uint256 _rewardPerBlock);
1995 	function pendingFees() external view returns (uint256 _feeShares);
1996 
1997 	// open functions
1998 	function deposit(uint256 _cost) external;
1999 	function withdraw(uint256 _shares) external;
2000 	function depositToken(address _token, uint256 _amount, uint256 _minShares) external;
2001 	function withdrawToken(address _token, uint256 _shares, uint256 _minAmount) external;
2002 	function gulpRewards(uint256 _minCost) external;
2003 	function gulpFees() external;
2004 
2005 	// priviledged functions
2006 	function setTreasury(address _treasury) external;
2007 	function setPerformanceFee(uint256 _performanceFee) external;
2008 	function setRewardRatePerWeek(uint256 _rewardRatePerWeek) external;
2009 
2010 	// emitted events
2011 	event ChangeTreasury(address _oldTreasury, address _newTreasury);
2012 	event ChangePerformanceFee(uint256 _oldPerformanceFee, uint256 _newPerformanceFee);
2013 	event ChangeRewardRatePerWeek(uint256 _oldRewardRatePerWeek, uint256 _newRewardRatePerWeek);
2014 }
2015 
2016 // File: @openzeppelin/contracts/utils/Address.sol
2017 
2018 
2019 pragma solidity >=0.6.2 <0.8.0;
2020 
2021 /**
2022  * @dev Collection of functions related to the address type
2023  */
2024 library Address {
2025     /**
2026      * @dev Returns true if `account` is a contract.
2027      *
2028      * [IMPORTANT]
2029      * ====
2030      * It is unsafe to assume that an address for which this function returns
2031      * false is an externally-owned account (EOA) and not a contract.
2032      *
2033      * Among others, `isContract` will return false for the following
2034      * types of addresses:
2035      *
2036      *  - an externally-owned account
2037      *  - a contract in construction
2038      *  - an address where a contract will be created
2039      *  - an address where a contract lived, but was destroyed
2040      * ====
2041      */
2042     function isContract(address account) internal view returns (bool) {
2043         // This method relies on extcodesize, which returns 0 for contracts in
2044         // construction, since the code is only stored at the end of the
2045         // constructor execution.
2046 
2047         uint256 size;
2048         // solhint-disable-next-line no-inline-assembly
2049         assembly { size := extcodesize(account) }
2050         return size > 0;
2051     }
2052 
2053     /**
2054      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2055      * `recipient`, forwarding all available gas and reverting on errors.
2056      *
2057      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2058      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2059      * imposed by `transfer`, making them unable to receive funds via
2060      * `transfer`. {sendValue} removes this limitation.
2061      *
2062      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2063      *
2064      * IMPORTANT: because control is transferred to `recipient`, care must be
2065      * taken to not create reentrancy vulnerabilities. Consider using
2066      * {ReentrancyGuard} or the
2067      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2068      */
2069     function sendValue(address payable recipient, uint256 amount) internal {
2070         require(address(this).balance >= amount, "Address: insufficient balance");
2071 
2072         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
2073         (bool success, ) = recipient.call{ value: amount }("");
2074         require(success, "Address: unable to send value, recipient may have reverted");
2075     }
2076 
2077     /**
2078      * @dev Performs a Solidity function call using a low level `call`. A
2079      * plain`call` is an unsafe replacement for a function call: use this
2080      * function instead.
2081      *
2082      * If `target` reverts with a revert reason, it is bubbled up by this
2083      * function (like regular Solidity function calls).
2084      *
2085      * Returns the raw returned data. To convert to the expected return value,
2086      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2087      *
2088      * Requirements:
2089      *
2090      * - `target` must be a contract.
2091      * - calling `target` with `data` must not revert.
2092      *
2093      * _Available since v3.1._
2094      */
2095     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2096       return functionCall(target, data, "Address: low-level call failed");
2097     }
2098 
2099     /**
2100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2101      * `errorMessage` as a fallback revert reason when `target` reverts.
2102      *
2103      * _Available since v3.1._
2104      */
2105     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
2106         return functionCallWithValue(target, data, 0, errorMessage);
2107     }
2108 
2109     /**
2110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2111      * but also transferring `value` wei to `target`.
2112      *
2113      * Requirements:
2114      *
2115      * - the calling contract must have an ETH balance of at least `value`.
2116      * - the called Solidity function must be `payable`.
2117      *
2118      * _Available since v3.1._
2119      */
2120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
2121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2122     }
2123 
2124     /**
2125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2126      * with `errorMessage` as a fallback revert reason when `target` reverts.
2127      *
2128      * _Available since v3.1._
2129      */
2130     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
2131         require(address(this).balance >= value, "Address: insufficient balance for call");
2132         require(isContract(target), "Address: call to non-contract");
2133 
2134         // solhint-disable-next-line avoid-low-level-calls
2135         (bool success, bytes memory returndata) = target.call{ value: value }(data);
2136         return _verifyCallResult(success, returndata, errorMessage);
2137     }
2138 
2139     /**
2140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2141      * but performing a static call.
2142      *
2143      * _Available since v3.3._
2144      */
2145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2146         return functionStaticCall(target, data, "Address: low-level static call failed");
2147     }
2148 
2149     /**
2150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2151      * but performing a static call.
2152      *
2153      * _Available since v3.3._
2154      */
2155     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
2156         require(isContract(target), "Address: static call to non-contract");
2157 
2158         // solhint-disable-next-line avoid-low-level-calls
2159         (bool success, bytes memory returndata) = target.staticcall(data);
2160         return _verifyCallResult(success, returndata, errorMessage);
2161     }
2162 
2163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
2164         if (success) {
2165             return returndata;
2166         } else {
2167             // Look for revert reason and bubble it up if present
2168             if (returndata.length > 0) {
2169                 // The easiest way to bubble the revert reason is using memory via assembly
2170 
2171                 // solhint-disable-next-line no-inline-assembly
2172                 assembly {
2173                     let returndata_size := mload(returndata)
2174                     revert(add(32, returndata), returndata_size)
2175                 }
2176             } else {
2177                 revert(errorMessage);
2178             }
2179         }
2180     }
2181 }
2182 
2183 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
2184 
2185 
2186 pragma solidity >=0.6.0 <0.8.0;
2187 
2188 
2189 
2190 
2191 /**
2192  * @title SafeERC20
2193  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2194  * contract returns false). Tokens that return no value (and instead revert or
2195  * throw on failure) are also supported, non-reverting calls are assumed to be
2196  * successful.
2197  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2198  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2199  */
2200 library SafeERC20 {
2201     using SafeMath for uint256;
2202     using Address for address;
2203 
2204     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2205         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2206     }
2207 
2208     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2209         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2210     }
2211 
2212     /**
2213      * @dev Deprecated. This function has issues similar to the ones found in
2214      * {IERC20-approve}, and its usage is discouraged.
2215      *
2216      * Whenever possible, use {safeIncreaseAllowance} and
2217      * {safeDecreaseAllowance} instead.
2218      */
2219     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2220         // safeApprove should only be called when setting an initial allowance,
2221         // or when resetting it to zero. To increase and decrease it, use
2222         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2223         // solhint-disable-next-line max-line-length
2224         require((value == 0) || (token.allowance(address(this), spender) == 0),
2225             "SafeERC20: approve from non-zero to non-zero allowance"
2226         );
2227         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2228     }
2229 
2230     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2231         uint256 newAllowance = token.allowance(address(this), spender).add(value);
2232         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2233     }
2234 
2235     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2236         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2237         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2238     }
2239 
2240     /**
2241      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2242      * on the return value: the return value is optional (but if data is returned, it must not be false).
2243      * @param token The token targeted by the call.
2244      * @param data The call data (encoded using abi.encode or one of its variants).
2245      */
2246     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2247         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2248         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2249         // the target address contains contract code and also asserts for success in the low-level call.
2250 
2251         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2252         if (returndata.length > 0) { // Return data is optional
2253             // solhint-disable-next-line max-line-length
2254             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2255         }
2256     }
2257 }
2258 
2259 // File: contracts/modules/Transfers.sol
2260 
2261 pragma solidity ^0.6.0;
2262 
2263 
2264 
2265 /**
2266  * @dev This library abstracts ERC-20 operations in the context of the current
2267  * contract.
2268  */
2269 library Transfers
2270 {
2271 	using SafeERC20 for IERC20;
2272 
2273 	/**
2274 	 * @dev Retrieves a given ERC-20 token balance for the current contract.
2275 	 * @param _token An ERC-20 compatible token address.
2276 	 * @return _balance The current contract balance of the given ERC-20 token.
2277 	 */
2278 	function _getBalance(address _token) internal view returns (uint256 _balance)
2279 	{
2280 		return IERC20(_token).balanceOf(address(this));
2281 	}
2282 
2283 	/**
2284 	 * @dev Allows a spender to access a given ERC-20 balance for the current contract.
2285 	 * @param _token An ERC-20 compatible token address.
2286 	 * @param _to The spender address.
2287 	 * @param _amount The exact spending allowance amount.
2288 	 */
2289 	function _approveFunds(address _token, address _to, uint256 _amount) internal
2290 	{
2291 		uint256 _allowance = IERC20(_token).allowance(address(this), _to);
2292 		if (_allowance > _amount) {
2293 			IERC20(_token).safeDecreaseAllowance(_to, _allowance - _amount);
2294 		}
2295 		else
2296 		if (_allowance < _amount) {
2297 			IERC20(_token).safeIncreaseAllowance(_to, _amount - _allowance);
2298 		}
2299 	}
2300 
2301 	/**
2302 	 * @dev Transfer a given ERC-20 token amount into the current contract.
2303 	 * @param _token An ERC-20 compatible token address.
2304 	 * @param _from The source address.
2305 	 * @param _amount The amount to be transferred.
2306 	 */
2307 	function _pullFunds(address _token, address _from, uint256 _amount) internal
2308 	{
2309 		if (_amount == 0) return;
2310 		IERC20(_token).safeTransferFrom(_from, address(this), _amount);
2311 	}
2312 
2313 	/**
2314 	 * @dev Transfer a given ERC-20 token amount from the current contract.
2315 	 * @param _token An ERC-20 compatible token address.
2316 	 * @param _to The target address.
2317 	 * @param _amount The amount to be transferred.
2318 	 */
2319 	function _pushFunds(address _token, address _to, uint256 _amount) internal
2320 	{
2321 		if (_amount == 0) return;
2322 		IERC20(_token).safeTransfer(_to, _amount);
2323 	}
2324 }
2325 
2326 // File: contracts/network/$.sol
2327 
2328 pragma solidity ^0.6.0;
2329 
2330 /**
2331  * @dev This library is provided for convenience. It is the single source for
2332  *      the current network and all related hardcoded contract addresses.
2333  */
2334 library $
2335 {
2336 	address constant AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
2337 
2338 	address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
2339 
2340 	address constant UniswapV2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
2341 
2342 	address constant UniswapV2_ROUTER02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
2343 }
2344 
2345 // File: contracts/modules/UniswapV2LiquidityPoolAbstraction.sol
2346 
2347 pragma solidity ^0.6.0;
2348 
2349 
2350 
2351 
2352 
2353 
2354 
2355 /**
2356  * @dev This library provides functionality to facilitate adding/removing
2357  * single-asset liquidity to/from a Uniswap V2 pool.
2358  */
2359 library UniswapV2LiquidityPoolAbstraction
2360 {
2361 	using SafeMath for uint256;
2362 
2363 	function _estimateJoinPool(address _pair, address _token, uint256 _amount) internal view returns (uint256 _shares)
2364 	{
2365 		if (_amount == 0) return 0;
2366 		address _router = $.UniswapV2_ROUTER02;
2367 		address _token0 = Pair(_pair).token0();
2368 		(uint256 _reserve0, uint256 _reserve1,) = Pair(_pair).getReserves();
2369 		uint256 _balance = _token == _token0 ? _reserve0 : _reserve1;
2370 		uint256 _otherBalance = _token == _token0 ? _reserve1 : _reserve0;
2371 		uint256 _totalSupply = Pair(_pair).totalSupply();
2372 		uint256 _swapAmount = _calcSwapOutputFromInput(_balance, _amount);
2373 		if (_swapAmount == 0) _swapAmount = _amount / 2;
2374 		uint256 _leftAmount = _amount.sub(_swapAmount);
2375 		uint256 _otherAmount = Router02(_router).getAmountOut(_swapAmount, _balance, _otherBalance);
2376 		_shares = Math._min(_totalSupply.mul(_leftAmount) / _balance.add(_swapAmount), _totalSupply.mul(_otherAmount) / _otherBalance.sub(_otherAmount));
2377 		return _shares;
2378 	}
2379 
2380 	function _estimateExitPool(address _pair, address _token, uint256 _shares) internal view returns (uint256 _amount)
2381 	{
2382 		if (_shares == 0) return 0;
2383 		address _router = $.UniswapV2_ROUTER02;
2384 		address _token0 = Pair(_pair).token0();
2385 		(uint256 _reserve0, uint256 _reserve1,) = Pair(_pair).getReserves();
2386 		uint256 _balance = _token == _token0 ? _reserve0 : _reserve1;
2387 		uint256 _otherBalance = _token == _token0 ? _reserve1 : _reserve0;
2388 		uint256 _totalSupply = Pair(_pair).totalSupply();
2389 		uint256 _baseAmount = _balance.mul(_shares) / _totalSupply;
2390 		uint256 _swapAmount = _otherBalance.mul(_shares) / _totalSupply;
2391 		uint256 _additionalAmount = Router02(_router).getAmountOut(_swapAmount, _otherBalance.sub(_swapAmount), _balance.sub(_baseAmount));
2392 		_amount = _baseAmount.add(_additionalAmount);
2393 		return _amount;
2394 	}
2395 
2396 	function _joinPool(address _pair, address _token, uint256 _amount, uint256 _minShares) internal returns (uint256 _shares)
2397 	{
2398 		if (_amount == 0) return 0;
2399 		address _router = $.UniswapV2_ROUTER02;
2400 		address _token0 = Pair(_pair).token0();
2401 		address _token1 = Pair(_pair).token1();
2402 		address _otherToken = _token == _token0 ? _token1 : _token0;
2403 		(uint256 _reserve0, uint256 _reserve1,) = Pair(_pair).getReserves();
2404 		uint256 _swapAmount = _calcSwapOutputFromInput(_token == _token0 ? _reserve0 : _reserve1, _amount);
2405 		if (_swapAmount == 0) _swapAmount = _amount / 2;
2406 		uint256 _leftAmount = _amount.sub(_swapAmount);
2407 		Transfers._approveFunds(_token, _router, _amount);
2408 		address[] memory _path = new address[](2);
2409 		_path[0] = _token;
2410 		_path[1] = _otherToken;
2411 		uint256 _otherAmount = Router02(_router).swapExactTokensForTokens(_swapAmount, 1, _path, address(this), uint256(-1))[1];
2412 		Transfers._approveFunds(_otherToken, _router, _otherAmount);
2413 		(,,_shares) = Router02(_router).addLiquidity(_token, _otherToken, _leftAmount, _otherAmount, 1, 1, address(this), uint256(-1));
2414 		require(_shares >= _minShares, "high slippage");
2415 		return _shares;
2416 	}
2417 
2418 	function _exitPool(address _pair, address _token, uint256 _shares, uint256 _minAmount) internal returns (uint256 _amount)
2419 	{
2420 		if (_shares == 0) return 0;
2421 		address _router = $.UniswapV2_ROUTER02;
2422 		address _token0 = Pair(_pair).token0();
2423 		address _token1 = Pair(_pair).token1();
2424 		address _otherToken = _token == _token0 ? _token1 : _token0;
2425 		Transfers._approveFunds(_pair, _router, _shares);
2426 		(uint256 _baseAmount, uint256 _swapAmount) = Router02(_router).removeLiquidity(_token, _otherToken, _shares, 1, 1, address(this), uint256(-1));
2427 		Transfers._approveFunds(_otherToken, _router, _swapAmount);
2428 		address[] memory _path = new address[](2);
2429 		_path[0] = _otherToken;
2430 		_path[1] = _token;
2431 		uint256 _additionalAmount = Router02(_router).swapExactTokensForTokens(_swapAmount, 1, _path, address(this), uint256(-1))[1];
2432 		_amount = _baseAmount.add(_additionalAmount);
2433 	        require(_amount >= _minAmount, "high slippage");
2434 		return _amount;
2435 	}
2436 
2437 	function _calcSwapOutputFromInput(uint256 _reserveAmount, uint256 _inputAmount) private pure returns (uint256)
2438 	{
2439 		return Babylonian.sqrt(_reserveAmount.mul(_inputAmount.mul(3988000).add(_reserveAmount.mul(3988009)))).sub(_reserveAmount.mul(1997)) / 1994;
2440 	}
2441 }
2442 
2443 // File: contracts/GLPMiningToken.sol
2444 
2445 pragma solidity ^0.6.0;
2446 
2447 
2448 
2449 
2450 
2451 
2452 
2453 /**
2454  * @notice This contract implements liquidity mining for staking Uniswap V2
2455  * shares.
2456  */
2457 contract GLPMiningToken is ERC20, Ownable, ReentrancyGuard, GLPMining
2458 {
2459 	uint256 constant MAXIMUM_PERFORMANCE_FEE = 50e16; // 50%
2460 
2461 	uint256 constant BLOCKS_PER_WEEK = 7 days / uint256(13 seconds);
2462 	uint256 constant DEFAULT_PERFORMANCE_FEE = 10e16; // 10%
2463 	uint256 constant DEFAULT_REWARD_RATE_PER_WEEK = 10e16; // 10%
2464 
2465 	address public immutable override reserveToken;
2466 	address public immutable override rewardsToken;
2467 
2468 	address public override treasury;
2469 
2470 	uint256 public override performanceFee = DEFAULT_PERFORMANCE_FEE;
2471 	uint256 public override rewardRatePerWeek = DEFAULT_REWARD_RATE_PER_WEEK;
2472 
2473 	uint256 lastContractBlock = block.number;
2474 	uint256 lastRewardPerBlock = 0;
2475 	uint256 lastUnlockedReward = 0;
2476 	uint256 lastLockedReward = 0;
2477 
2478 	uint256 lastTotalSupply = 1;
2479 	uint256 lastTotalReserve = 1;
2480 
2481 	constructor (string memory _name, string memory _symbol, uint8 _decimals, address _reserveToken, address _rewardsToken)
2482 		ERC20(_name, _symbol) public
2483 	{
2484 		address _treasury = msg.sender;
2485 		_setupDecimals(_decimals);
2486 		assert(_reserveToken != address(0));
2487 		assert(_rewardsToken != address(0));
2488 		assert(_reserveToken != _rewardsToken);
2489 		reserveToken = _reserveToken;
2490 		rewardsToken = _rewardsToken;
2491 		treasury = _treasury;
2492 		// just after creation it must transfer 1 wei from reserveToken
2493 		// into this contract
2494 		// this must be performed manually because we cannot approve
2495 		// the spending by this contract before it exists
2496 		// Transfers._pullFunds(_reserveToken, _from, 1);
2497 		_mint(address(this), 1);
2498 	}
2499 
2500 	function calcSharesFromCost(uint256 _cost) public view override returns (uint256 _shares)
2501 	{
2502 		return _cost.mul(totalSupply()).div(totalReserve());
2503 	}
2504 
2505 	function calcCostFromShares(uint256 _shares) public view override returns (uint256 _cost)
2506 	{
2507 		return _shares.mul(totalReserve()).div(totalSupply());
2508 	}
2509 
2510 	function calcSharesFromTokenAmount(address _token, uint256 _amount) external view override returns (uint256 _shares)
2511 	{
2512 		uint256 _cost = UniswapV2LiquidityPoolAbstraction._estimateJoinPool(reserveToken, _token, _amount);
2513 		return calcSharesFromCost(_cost);
2514 	}
2515 
2516 	function calcTokenAmountFromShares(address _token, uint256 _shares) external view override returns (uint256 _amount)
2517 	{
2518 		uint256 _cost = calcCostFromShares(_shares);
2519 		return UniswapV2LiquidityPoolAbstraction._estimateExitPool(reserveToken, _token, _cost);
2520 	}
2521 
2522 	function totalReserve() public view override returns (uint256 _totalReserve)
2523 	{
2524 		return Transfers._getBalance(reserveToken);
2525 	}
2526 
2527 	function rewardInfo() external view override returns (uint256 _lockedReward, uint256 _unlockedReward, uint256 _rewardPerBlock)
2528 	{
2529 		(, _rewardPerBlock, _unlockedReward, _lockedReward) = _calcCurrentRewards();
2530 		return (_lockedReward, _unlockedReward, _rewardPerBlock);
2531 	}
2532 
2533 	function pendingFees() external view override returns (uint256 _feeShares)
2534 	{
2535 		return _calcFees();
2536 	}
2537 
2538 	function deposit(uint256 _cost) external override nonReentrant
2539 	{
2540 		address _from = msg.sender;
2541 		uint256 _shares = calcSharesFromCost(_cost);
2542 		Transfers._pullFunds(reserveToken, _from, _cost);
2543 		_mint(_from, _shares);
2544 	}
2545 
2546 	function withdraw(uint256 _shares) external override nonReentrant
2547 	{
2548 		address _from = msg.sender;
2549 		uint256 _cost = calcCostFromShares(_shares);
2550 		Transfers._pushFunds(reserveToken, _from, _cost);
2551 		_burn(_from, _shares);
2552 	}
2553 
2554 	function depositToken(address _token, uint256 _amount, uint256 _minShares) external override nonReentrant
2555 	{
2556 		address _from = msg.sender;
2557 		uint256 _minCost = calcCostFromShares(_minShares);
2558 		Transfers._pullFunds(_token, _from, _amount);
2559 		uint256 _cost = UniswapV2LiquidityPoolAbstraction._joinPool(reserveToken, _token, _amount, _minCost);
2560 		uint256 _shares = _cost.mul(totalSupply()).div(totalReserve().sub(_cost));
2561 		_mint(_from, _shares);
2562 	}
2563 
2564 	function withdrawToken(address _token, uint256 _shares, uint256 _minAmount) external override nonReentrant
2565 	{
2566 		address _from = msg.sender;
2567 		uint256 _cost = calcCostFromShares(_shares);
2568 		uint256 _amount = UniswapV2LiquidityPoolAbstraction._exitPool(reserveToken, _token, _cost, _minAmount);
2569 		Transfers._pushFunds(_token, _from, _amount);
2570 		_burn(_from, _shares);
2571 	}
2572 
2573 	function gulpRewards(uint256 _minCost) external override nonReentrant
2574 	{
2575 		_updateRewards();
2576 		UniswapV2LiquidityPoolAbstraction._joinPool(reserveToken, rewardsToken, lastUnlockedReward, _minCost);
2577 		lastUnlockedReward = 0;
2578 	}
2579 
2580 	function gulpFees() external override nonReentrant
2581 	{
2582 		uint256 _feeShares = _calcFees();
2583 		if (_feeShares > 0) {
2584 			lastTotalSupply = totalSupply();
2585 			lastTotalReserve = totalReserve();
2586 			_mint(treasury, _feeShares);
2587 		}
2588 	}
2589 
2590 	function setTreasury(address _newTreasury) external override onlyOwner nonReentrant
2591 	{
2592 		require(_newTreasury != address(0), "invalid address");
2593 		address _oldTreasury = treasury;
2594 		treasury = _newTreasury;
2595 		emit ChangeTreasury(_oldTreasury, _newTreasury);
2596 	}
2597 
2598 	function setPerformanceFee(uint256 _newPerformanceFee) external override onlyOwner nonReentrant
2599 	{
2600 		require(_newPerformanceFee <= MAXIMUM_PERFORMANCE_FEE, "invalid rate");
2601 		uint256 _oldPerformanceFee = performanceFee;
2602 		performanceFee = _newPerformanceFee;
2603 		emit ChangePerformanceFee(_oldPerformanceFee, _newPerformanceFee);
2604 	}
2605 
2606 	function setRewardRatePerWeek(uint256 _newRewardRatePerWeek) external override onlyOwner nonReentrant
2607 	{
2608 		require(_newRewardRatePerWeek <= 1e18, "invalid rate");
2609 		uint256 _oldRewardRatePerWeek = rewardRatePerWeek;
2610 		rewardRatePerWeek = _newRewardRatePerWeek;
2611 		emit ChangeRewardRatePerWeek(_oldRewardRatePerWeek, _newRewardRatePerWeek);
2612 	}
2613 
2614 	function _updateRewards() internal
2615 	{
2616 		(lastContractBlock, lastRewardPerBlock, lastUnlockedReward, lastLockedReward) = _calcCurrentRewards();
2617 		uint256 _balanceReward = Transfers._getBalance(rewardsToken);
2618 		uint256 _totalReward = lastLockedReward.add(lastUnlockedReward);
2619 		if (_balanceReward > _totalReward) {
2620 			uint256 _newLockedReward = _balanceReward.sub(_totalReward);
2621 			uint256 _newRewardPerBlock = _calcRewardPerBlock(_newLockedReward);
2622 			lastRewardPerBlock = lastRewardPerBlock.add(_newRewardPerBlock);
2623 			lastLockedReward = lastLockedReward.add(_newLockedReward);
2624 		}
2625 		else
2626 		if (_balanceReward < _totalReward) {
2627 			uint256 _removedLockedReward = _totalReward.sub(_balanceReward);
2628 			if (_removedLockedReward >= lastLockedReward) {
2629 				_removedLockedReward = lastLockedReward;
2630 			}
2631 			uint256 _removedRewardPerBlock = _calcRewardPerBlock(_removedLockedReward);
2632 			if (_removedLockedReward >= lastLockedReward) {
2633 				_removedRewardPerBlock = lastRewardPerBlock;
2634 			}
2635 			lastRewardPerBlock = lastRewardPerBlock.sub(_removedRewardPerBlock);
2636 			lastLockedReward = lastLockedReward.sub(_removedLockedReward);
2637 			lastUnlockedReward = _balanceReward.sub(lastLockedReward);
2638 		}
2639 	}
2640 
2641 	function _calcFees() internal view returns (uint256 _feeShares)
2642 	{
2643 		uint256 _oldTotalSupply = lastTotalSupply;
2644 		uint256 _oldTotalReserve = lastTotalReserve;
2645 
2646 		uint256 _newTotalSupply = totalSupply();
2647 		uint256 _newTotalReserve = totalReserve();
2648 
2649 		// calculates the profit using the following formula
2650 		// ((P1 - P0) * S1 * f) / P1
2651 		// where P1 = R1 / S1 and P0 = R0 / S0
2652 		uint256 _positive = _oldTotalSupply.mul(_newTotalReserve);
2653 		uint256 _negative = _newTotalSupply.mul(_oldTotalReserve);
2654 		if (_positive > _negative) {
2655 			uint256 _profitCost = _positive.sub(_negative).div(_oldTotalSupply);
2656 			uint256 _feeCost = _profitCost.mul(performanceFee).div(1e18);
2657 			return calcSharesFromCost(_feeCost);
2658 		}
2659 
2660 		return 0;
2661 	}
2662 
2663 	function _calcCurrentRewards() internal view returns (uint256 _currentContractBlock, uint256 _currentRewardPerBlock, uint256 _currentUnlockedReward, uint256 _currentLockedReward)
2664 	{
2665 		uint256 _contractBlock = lastContractBlock;
2666 		uint256 _rewardPerBlock = lastRewardPerBlock;
2667 		uint256 _unlockedReward = lastUnlockedReward;
2668 		uint256 _lockedReward = lastLockedReward;
2669 		if (_contractBlock < block.number) {
2670 			uint256 _week = _contractBlock.div(BLOCKS_PER_WEEK);
2671 			uint256 _offset = _contractBlock.mod(BLOCKS_PER_WEEK);
2672 
2673 			_contractBlock = block.number;
2674 			uint256 _currentWeek = _contractBlock.div(BLOCKS_PER_WEEK);
2675 			uint256 _currentOffset = _contractBlock.mod(BLOCKS_PER_WEEK);
2676 
2677 			while (_week < _currentWeek) {
2678 				uint256 _blocks = BLOCKS_PER_WEEK.sub(_offset);
2679 				uint256 _reward = _blocks.mul(_rewardPerBlock);
2680 				_unlockedReward = _unlockedReward.add(_reward);
2681 				_lockedReward = _lockedReward.sub(_reward);
2682 				_rewardPerBlock = _calcRewardPerBlock(_lockedReward);
2683 				_week++;
2684 				_offset = 0;
2685 			}
2686 
2687 			uint256 _blocks = _currentOffset.sub(_offset);
2688 			uint256 _reward = _blocks.mul(_rewardPerBlock);
2689 			_unlockedReward = _unlockedReward.add(_reward);
2690 			_lockedReward = _lockedReward.sub(_reward);
2691 		}
2692 		return (_contractBlock, _rewardPerBlock, _unlockedReward, _lockedReward);
2693 	}
2694 
2695 	function _calcRewardPerBlock(uint256 _lockedReward) internal view returns (uint256 _rewardPerBlock)
2696 	{
2697 		return _lockedReward.mul(rewardRatePerWeek).div(1e18).div(BLOCKS_PER_WEEK);
2698 	}
2699 }
2700 
2701 // File: contracts/interop/WrappedEther.sol
2702 
2703 pragma solidity ^0.6.0;
2704 
2705 
2706 /**
2707  * @dev Minimal set of declarations for WETH interoperability.
2708  */
2709 interface WETH is IERC20
2710 {
2711 	function deposit() external payable;
2712 	function withdraw(uint256 _amount) external;
2713 }
2714 
2715 // File: contracts/modules/Wrapping.sol
2716 
2717 pragma solidity ^0.6.0;
2718 
2719 
2720 
2721 /**
2722  * @dev This library abstracts Wrapped Ether operations.
2723  */
2724 library Wrapping
2725 {
2726 	/**
2727 	 * @dev Sends some ETH to the Wrapped Ether contract in exchange for WETH.
2728 	 * @param _amount The amount of ETH to be wrapped.
2729 	 */
2730 	function _wrap(uint256 _amount) internal
2731 	{
2732 		WETH($.WETH).deposit{value: _amount}();
2733 	}
2734 
2735 	/**
2736 	 * @dev Receives some ETH from the Wrapped Ether contract in exchange for WETH.
2737 	 *      Note that the contract using this library function must declare a
2738 	 *      payable receive/fallback function.
2739 	 * @param _amount The amount of ETH to be unwrapped.
2740 	 */
2741 	function _unwrap(uint256 _amount) internal
2742 	{
2743 		WETH($.WETH).withdraw(_amount);
2744 	}
2745 }
2746 
2747 // File: contracts/GEtherBridge.sol
2748 
2749 pragma solidity ^0.6.0;
2750 
2751 
2752 
2753 
2754 contract GEtherBridge
2755 {
2756 	function deposit(address _stakeToken, uint256 _minShares) external payable
2757 	{
2758 		address _from = msg.sender;
2759 		uint256 _amount = msg.value;
2760 		address _token = $.WETH;
2761 		Wrapping._wrap(_amount);
2762 		Transfers._approveFunds(_token, _stakeToken, _amount);
2763 		GLPMining(_stakeToken).depositToken(_token, _amount, _minShares);
2764 		uint256 _shares = Transfers._getBalance(_stakeToken);
2765 		Transfers._pushFunds(_stakeToken, _from, _shares);
2766 	}
2767 
2768 	function withdraw(address _stakeToken, uint256 _shares, uint256 _minAmount) external
2769 	{
2770 		address payable _from = msg.sender;
2771 		address _token = $.WETH;
2772 		Transfers._pullFunds(_stakeToken, _from, _shares);
2773 		GLPMining(_stakeToken).withdrawToken(_token, _shares, _minAmount);
2774 		uint256 _amount = Transfers._getBalance(_token);
2775 		Wrapping._unwrap(_amount);
2776 		_from.transfer(_amount);
2777 	}
2778 
2779 	receive() external payable {} // not to be used directly
2780 }
2781 
2782 // File: contracts/GTokens.sol
2783 
2784 pragma solidity ^0.6.0;
2785 
2786 
2787 
2788 
2789 
2790 
2791 /**
2792  * @notice Definition of rAAVE. It is an elastic supply token that uses AAVE
2793  * as reference token.
2794  */
2795 contract rAAVE is GElasticToken
2796 {
2797 	constructor (uint256 _initialSupply)
2798 		GElasticToken("rebase AAVE", "rAAVE", 18, $.AAVE, _initialSupply) public
2799 	{
2800 	}
2801 }
2802 
2803 /**
2804  * @notice Definition of stkAAVE/rAAVE. It provides mining or reward rAAVE when
2805  * providing liquidity to the AAVE/rAAVE pool.
2806  */
2807 contract stkAAVE_rAAVE is GLPMiningToken
2808 {
2809 	constructor (address _AAVE_rAAVE, address _rAAVE)
2810 		GLPMiningToken("staked AAVE/rAAVE", "stkAAVE/rAAVE", 18, _AAVE_rAAVE, _rAAVE) public
2811 	{
2812 	}
2813 }
2814 
2815 /**
2816  * @notice Definition of stkGRO/rAAVE. It provides mining or reward rAAVE when
2817  * providing liquidity to the GRO/rAAVE pool.
2818  */
2819 contract stkGRO_rAAVE is GLPMiningToken
2820 {
2821 	constructor (address _GRO_rAAVE, address _rAAVE)
2822 		GLPMiningToken("staked GRO/rAAVE", "stkGRO/rAAVE", 18, _GRO_rAAVE, _rAAVE) public
2823 	{
2824 	}
2825 }
2826 
2827 /**
2828  * @notice Definition of stkETH/rAAVE. It provides mining or reward rAAVE when
2829  * providing liquidity to the WETH/rAAVE pool.
2830  */
2831 contract stkETH_rAAVE is GLPMiningToken
2832 {
2833 	constructor (address _ETH_rAAVE, address _rAAVE)
2834 		GLPMiningToken("staked ETH/rAAVE", "stkETH/rAAVE", 18, _ETH_rAAVE, _rAAVE) public
2835 	{
2836 	}
2837 }
2838 
2839 // File: contracts/GTokenRegistry.sol
2840 
2841 pragma solidity ^0.6.0;
2842 
2843 
2844 /**
2845  * @notice This contract allows external agents to detect when new GTokens
2846  *         are deployed to the network.
2847  */
2848 contract GTokenRegistry is Ownable
2849 {
2850 	/**
2851 	 * @notice Registers a new gToken.
2852 	 * @param _growthToken The address of the token being registered.
2853 	 * @param _oldGrowthToken The address of the token implementation
2854 	 *                        being replaced, for upgrades, or 0x0 0therwise.
2855 	 */
2856 	function registerNewToken(address _growthToken, address _oldGrowthToken) public onlyOwner
2857 	{
2858 		emit NewToken(_growthToken, _oldGrowthToken);
2859 	}
2860 
2861 	event NewToken(address indexed _growthToken, address indexed _oldGrowthToken);
2862 }