1 pragma solidity >=0.4.21 <0.6.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 
184 /**
185  * @dev Implementation of the `IERC20` interface.
186  *
187  * This implementation is agnostic to the way tokens are created. This means
188  * that a supply mechanism has to be added in a derived contract using `_mint`.
189  * For a generic mechanism see `ERC20Mintable`.
190  *
191  * *For a detailed writeup see our guide [How to implement supply
192  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
193  *
194  * We have followed general OpenZeppelin guidelines: functions revert instead
195  * of returning `false` on failure. This behavior is nonetheless conventional
196  * and does not conflict with the expectations of ERC20 applications.
197  *
198  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
199  * This allows applications to reconstruct the allowance for all accounts just
200  * by listening to said events. Other implementations of the EIP may not emit
201  * these events, as it isn't required by the specification.
202  *
203  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
204  * functions have been added to mitigate the well-known issues around setting
205  * allowances. See `IERC20.approve`.
206  */
207 contract ERC20 is IERC20 {
208     using SafeMath for uint256;
209 
210     mapping (address => uint256) private _balances;
211 
212     mapping (address => mapping (address => uint256)) private _allowances;
213 
214     uint256 private _totalSupply;
215 
216     /**
217      * @dev See `IERC20.totalSupply`.
218      */
219     function totalSupply() public view returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See `IERC20.balanceOf`.
225      */
226     function balanceOf(address account) public view returns (uint256) {
227         return _balances[account];
228     }
229 
230     /**
231      * @dev See `IERC20.transfer`.
232      *
233      * Requirements:
234      *
235      * - `recipient` cannot be the zero address.
236      * - the caller must have a balance of at least `amount`.
237      */
238     function transfer(address recipient, uint256 amount) public returns (bool) {
239         _transfer(msg.sender, recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See `IERC20.allowance`.
245      */
246     function allowance(address owner, address spender) public view returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See `IERC20.approve`.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 value) public returns (bool) {
258         _approve(msg.sender, spender, value);
259         return true;
260     }
261 
262     /**
263      * @dev See `IERC20.transferFrom`.
264      *
265      * Emits an `Approval` event indicating the updated allowance. This is not
266      * required by the EIP. See the note at the beginning of `ERC20`;
267      *
268      * Requirements:
269      * - `sender` and `recipient` cannot be the zero address.
270      * - `sender` must have a balance of at least `value`.
271      * - the caller must have allowance for `sender`'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to `approve` that can be used as a mitigation for
284      * problems described in `IERC20.approve`.
285      *
286      * Emits an `Approval` event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
293         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to `approve` that can be used as a mitigation for
301      * problems described in `IERC20.approve`.
302      *
303      * Emits an `Approval` event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
312         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
313         return true;
314     }
315 
316     /**
317      * @dev Moves tokens `amount` from `sender` to `recipient`.
318      *
319      * This is internal function is equivalent to `transfer`, and can be used to
320      * e.g. implement automatic token fees, slashing mechanisms, etc.
321      *
322      * Emits a `Transfer` event.
323      *
324      * Requirements:
325      *
326      * - `sender` cannot be the zero address.
327      * - `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      */
330     function _transfer(address sender, address recipient, uint256 amount) internal {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333 
334         _balances[sender] = _balances[sender].sub(amount);
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337     }
338 
339     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
340      * the total supply.
341      *
342      * Emits a `Transfer` event with `from` set to the zero address.
343      *
344      * Requirements
345      *
346      * - `to` cannot be the zero address.
347      */
348     function _mint(address account, uint256 amount) internal {
349         require(account != address(0), "ERC20: mint to the zero address");
350 
351         _totalSupply = _totalSupply.add(amount);
352         _balances[account] = _balances[account].add(amount);
353         emit Transfer(address(0), account, amount);
354     }
355 
356      /**
357      * @dev Destoys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a `Transfer` event with `to` set to the zero address.
361      *
362      * Requirements
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 value) internal {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _totalSupply = _totalSupply.sub(value);
371         _balances[account] = _balances[account].sub(value);
372         emit Transfer(account, address(0), value);
373     }
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
377      *
378      * This is internal function is equivalent to `approve`, and can be used to
379      * e.g. set automatic allowances for certain subsystems, etc.
380      *
381      * Emits an `Approval` event.
382      *
383      * Requirements:
384      *
385      * - `owner` cannot be the zero address.
386      * - `spender` cannot be the zero address.
387      */
388     function _approve(address owner, address spender, uint256 value) internal {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = value;
393         emit Approval(owner, spender, value);
394     }
395 
396     /**
397      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
398      * from the caller's allowance.
399      *
400      * See `_burn` and `_approve`.
401      */
402     function _burnFrom(address account, uint256 amount) internal {
403         _burn(account, amount);
404         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
405     }
406 }
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * This module is used through inheritance. It will make available the modifier
414  * `onlyOwner`, which can be aplied to your functions to restrict their use to
415  * the owner.
416  */
417 contract Ownable {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () internal {
426         _owner = msg.sender;
427         emit OwnershipTransferred(address(0), _owner);
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(isOwner(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445     /**
446      * @dev Returns true if the caller is the current owner.
447      */
448     function isOwner() public view returns (bool) {
449         return msg.sender == _owner;
450     }
451 
452     /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * > Note: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public onlyOwner {
460         emit OwnershipTransferred(_owner, address(0));
461         _owner = address(0);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public onlyOwner {
469         _transferOwnership(newOwner);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      */
475     function _transferOwnership(address newOwner) internal {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 }
481 
482 // Compound finance ERC20 market interface
483 interface CERC20 {
484   function mint(uint mintAmount) external returns (uint);
485   function redeemUnderlying(uint redeemAmount) external returns (uint);
486   function borrow(uint borrowAmount) external returns (uint);
487   function repayBorrow(uint repayAmount) external returns (uint);
488   function borrowBalanceCurrent(address account) external returns (uint);
489   function exchangeRateCurrent() external returns (uint);
490   function transfer(address recipient, uint256 amount) external returns (bool);
491 
492   function balanceOf(address account) external view returns (uint);
493   function decimals() external view returns (uint);
494   function underlying() external view returns (address);
495   function exchangeRateStored() external view returns (uint);
496 }
497 
498 // Compound finance comptroller
499 interface Comptroller {
500   function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
501   function markets(address cToken) external view returns (bool isListed, uint256 collateralFactorMantissa);
502 }
503 
504 contract PooledCDAI is ERC20, Ownable {
505   uint256 internal constant PRECISION = 10 ** 18;
506 
507   address public constant COMPTROLLER_ADDRESS = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
508   address public constant CDAI_ADDRESS = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
509   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
510 
511   string private _name;
512   string private _symbol;
513 
514   address public beneficiary; // the account that will receive the interests from Compound
515 
516   event Mint(address indexed sender, address indexed to, uint256 amount);
517   event Burn(address indexed sender, address indexed to, uint256 amount);
518   event WithdrawInterest(address indexed sender, address beneficiary, uint256 amount, bool indexed inDAI);
519   event SetBeneficiary(address oldBeneficiary, address newBeneficiary);
520 
521   /**
522     * @dev Sets the values for `name` and `symbol`. Both of
523     * these values are immutable: they can only be set once during
524     * construction.
525     */
526   function init(string memory name, string memory symbol, address _beneficiary) public {
527     require(beneficiary == address(0), "Already initialized");
528 
529     _name = name;
530     _symbol = symbol;
531 
532     // Set beneficiary
533     require(_beneficiary != address(0), "Beneficiary can't be zero");
534     beneficiary = _beneficiary;
535     emit SetBeneficiary(address(0), _beneficiary);
536     
537     _transferOwnership(msg.sender);
538 
539     // Enter cDAI market
540     Comptroller troll = Comptroller(COMPTROLLER_ADDRESS);
541     address[] memory cTokens = new address[](1);
542     cTokens[0] = CDAI_ADDRESS;
543     uint[] memory errors = troll.enterMarkets(cTokens);
544     require(errors[0] == 0, "Failed to enter cDAI market");
545   }
546 
547   /**
548     * @dev Returns the name of the token.
549     */
550   function name() public view returns (string memory) {
551     return _name;
552   }
553 
554   /**
555     * @dev Returns the symbol of the token, usually a shorter version of the
556     * name.
557     */
558   function symbol() public view returns (string memory) {
559     return _symbol;
560   }
561 
562   /**
563     * @dev Returns the number of decimals used to get its user representation.
564     * For example, if `decimals` equals `2`, a balance of `505` tokens should
565     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
566     *
567     * Tokens usually opt for a value of 18, imitating the relationship between
568     * Ether and Wei.
569     *
570     * NOTE: This information is only used for _display_ purposes: it in
571     * no way affects any of the arithmetic of the contract, including
572     * {IERC20-balanceOf} and {IERC20-transfer}.
573     */
574   function decimals() public pure returns (uint8) {
575     return 18;
576   }
577 
578   function mint(address to, uint256 amount) public returns (bool) {
579     // transfer `amount` DAI from msg.sender
580     ERC20 dai = ERC20(DAI_ADDRESS);
581     require(dai.transferFrom(msg.sender, address(this), amount), "Failed to transfer DAI from msg.sender");
582 
583     // use `amount` DAI to mint cDAI
584     CERC20 cDAI = CERC20(CDAI_ADDRESS);
585     require(dai.approve(CDAI_ADDRESS, 0), "Failed to clear DAI allowance");
586     require(dai.approve(CDAI_ADDRESS, amount), "Failed to set DAI allowance");
587     require(cDAI.mint(amount) == 0, "Failed to mint cDAI");
588 
589     // mint `amount` pcDAI for `to`
590     _mint(to, amount);
591 
592     // emit event
593     emit Mint(msg.sender, to, amount);
594 
595     return true;
596   }
597 
598   function burn(address to, uint256 amount) public returns (bool) {
599     // burn `amount` pcDAI for msg.sender
600     _burn(msg.sender, amount);
601 
602     // burn cDAI for `amount` DAI
603     CERC20 cDAI = CERC20(CDAI_ADDRESS);
604     require(cDAI.redeemUnderlying(amount) == 0, "Failed to redeem");
605 
606     // transfer DAI to `to`
607     ERC20 dai = ERC20(DAI_ADDRESS);
608     require(dai.transfer(to, amount), "Failed to transfer DAI to target");
609 
610     // emit event
611     emit Burn(msg.sender, to, amount);
612 
613     return true;
614   }
615 
616   function accruedInterestCurrent() public returns (uint256) {
617     CERC20 cDAI = CERC20(CDAI_ADDRESS);
618     return cDAI.exchangeRateCurrent().mul(cDAI.balanceOf(address(this))).div(PRECISION).sub(totalSupply());
619   }
620 
621   function accruedInterestStored() public view returns (uint256) {
622     CERC20 cDAI = CERC20(CDAI_ADDRESS);
623     return cDAI.exchangeRateStored().mul(cDAI.balanceOf(address(this))).div(PRECISION).sub(totalSupply());
624   }
625 
626   function withdrawInterestInDAI() public returns (bool) {
627     // calculate amount of interest in DAI
628     uint256 interestAmount = accruedInterestCurrent();
629 
630     // burn cDAI
631     CERC20 cDAI = CERC20(CDAI_ADDRESS);
632     require(cDAI.redeemUnderlying(interestAmount) == 0, "Failed to redeem");
633 
634     // transfer DAI to beneficiary
635     ERC20 dai = ERC20(DAI_ADDRESS);
636     require(dai.transfer(beneficiary, interestAmount), "Failed to transfer DAI to beneficiary");
637 
638     emit WithdrawInterest(msg.sender, beneficiary, interestAmount, true);
639 
640     return true;
641   }
642 
643   function withdrawInterestInCDAI() public returns (bool) {
644     // calculate amount of cDAI to transfer
645     CERC20 cDAI = CERC20(CDAI_ADDRESS);
646     uint256 interestAmountInCDAI = accruedInterestCurrent().mul(PRECISION).div(cDAI.exchangeRateCurrent());
647 
648     // transfer cDAI to beneficiary
649     require(cDAI.transfer(beneficiary, interestAmountInCDAI), "Failed to transfer cDAI to beneficiary");
650 
651     // emit event
652     emit WithdrawInterest(msg.sender, beneficiary, interestAmountInCDAI, false);
653 
654     return true;
655   }
656 
657   function setBeneficiary(address newBeneficiary) public onlyOwner returns (bool) {
658     require(newBeneficiary != address(0), "Beneficiary can't be zero");
659     emit SetBeneficiary(beneficiary, newBeneficiary);
660 
661     beneficiary = newBeneficiary;
662 
663     return true;
664   }
665 
666   function() external payable {
667     revert("Contract doesn't support receiving Ether");
668   }
669 }
670 
671 /*
672 The MIT License (MIT)
673 
674 Copyright (c) 2018 Murray Software, LLC.
675 
676 Permission is hereby granted, free of charge, to any person obtaining
677 a copy of this software and associated documentation files (the
678 "Software"), to deal in the Software without restriction, including
679 without limitation the rights to use, copy, modify, merge, publish,
680 distribute, sublicense, and/or sell copies of the Software, and to
681 permit persons to whom the Software is furnished to do so, subject to
682 the following conditions:
683 
684 The above copyright notice and this permission notice shall be included
685 in all copies or substantial portions of the Software.
686 
687 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
688 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
689 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
690 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
691 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
692 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
693 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
694 */
695 //solhint-disable max-line-length
696 //solhint-disable no-inline-assembly
697 
698 contract CloneFactory {
699 
700   function createClone(address target) internal returns (address result) {
701     bytes20 targetBytes = bytes20(target);
702     assembly {
703       let clone := mload(0x40)
704       mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
705       mstore(add(clone, 0x14), targetBytes)
706       mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
707       result := create(0, clone, 0x37)
708     }
709   }
710 
711   function isClone(address target, address query) internal view returns (bool result) {
712     bytes20 targetBytes = bytes20(target);
713     assembly {
714       let clone := mload(0x40)
715       mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
716       mstore(add(clone, 0xa), targetBytes)
717       mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
718 
719       let other := add(clone, 0x40)
720       extcodecopy(query, other, 0, 0x2d)
721       result := and(
722         eq(mload(clone), mload(other)),
723         eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
724       )
725     }
726   }
727 }
728 
729 contract PooledCDAIFactory is CloneFactory {
730 
731   address public libraryAddress;
732 
733   event CreatePool(address sender, address pool, bool indexed renounceOwnership);
734 
735   constructor(address _libraryAddress) public {
736     libraryAddress = _libraryAddress;
737   }
738 
739   function createPCDAI(string memory name, string memory symbol, address beneficiary, bool renounceOwnership) public returns (PooledCDAI) {
740     PooledCDAI pcDAI = _createPCDAI(name, symbol, beneficiary, renounceOwnership);
741     emit CreatePool(msg.sender, address(pcDAI), renounceOwnership);
742     return pcDAI;
743   }
744 
745   function _createPCDAI(string memory name, string memory symbol, address beneficiary, bool renounceOwnership) internal returns (PooledCDAI) {
746     address payable clone = _toPayableAddr(createClone(libraryAddress));
747     PooledCDAI pcDAI = PooledCDAI(clone);
748     pcDAI.init(name, symbol, beneficiary);
749     if (renounceOwnership) {
750       pcDAI.renounceOwnership();
751     } else {
752       pcDAI.transferOwnership(msg.sender);
753     }
754     return pcDAI;
755   }
756 
757   function _toPayableAddr(address _addr) internal pure returns (address payable) {
758     return address(uint160(_addr));
759   }
760 }
761 
762 contract MetadataPooledCDAIFactory is PooledCDAIFactory {
763   event CreatePoolWithMetadata(address sender, address pool, bool indexed renounceOwnership, bytes metadata);
764 
765   constructor(address _libraryAddress) public PooledCDAIFactory(_libraryAddress) {}
766 
767   function createPCDAIWithMetadata(
768     string memory name,
769     string memory symbol,
770     address beneficiary,
771     bool renounceOwnership,
772     bytes memory metadata
773   ) public returns (PooledCDAI) {
774     PooledCDAI pcDAI = _createPCDAI(name, symbol, beneficiary, renounceOwnership);
775     emit CreatePoolWithMetadata(msg.sender, address(pcDAI), renounceOwnership, metadata);
776   }
777 }
778 
779 interface KyberNetworkProxy {
780   function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view
781       returns (uint expectedRate, uint slippageRate);
782 
783   function tradeWithHint(
784     ERC20 src, uint srcAmount, ERC20 dest, address payable destAddress, uint maxDestAmount,
785     uint minConversionRate, address walletId, bytes calldata hint) external payable returns(uint);
786 }
787 
788 /**
789  * @title SafeERC20
790  * @dev Wrappers around ERC20 operations that throw on failure (when the token
791  * contract returns false). Tokens that return no value (and instead revert or
792  * throw on failure) are also supported, non-reverting calls are assumed to be
793  * successful.
794  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
795  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
796  */
797 library SafeERC20 {
798     using SafeMath for uint256;
799     using Address for address;
800 
801     function safeTransfer(IERC20 token, address to, uint256 value) internal {
802         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
803     }
804 
805     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
806         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
807     }
808 
809     function safeApprove(IERC20 token, address spender, uint256 value) internal {
810         // safeApprove should only be called when setting an initial allowance,
811         // or when resetting it to zero. To increase and decrease it, use
812         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
813         // solhint-disable-next-line max-line-length
814         require((value == 0) || (token.allowance(address(this), spender) == 0),
815             "SafeERC20: approve from non-zero to non-zero allowance"
816         );
817         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
818     }
819 
820     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
821         uint256 newAllowance = token.allowance(address(this), spender).add(value);
822         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
823     }
824 
825     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
826         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
827         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
828     }
829 
830     /**
831      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
832      * on the return value: the return value is optional (but if data is returned, it must not be false).
833      * @param token The token targeted by the call.
834      * @param data The call data (encoded using abi.encode or one of its variants).
835      */
836     function callOptionalReturn(IERC20 token, bytes memory data) private {
837         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
838         // we're implementing it ourselves.
839 
840         // A Solidity high level call has three parts:
841         //  1. The target address is checked to verify it contains contract code
842         //  2. The call itself is made, and success asserted
843         //  3. The return value is decoded, which in turn checks the size of the returned data.
844         // solhint-disable-next-line max-line-length
845         require(address(token).isContract(), "SafeERC20: call to non-contract");
846 
847         // solhint-disable-next-line avoid-low-level-calls
848         (bool success, bytes memory returndata) = address(token).call(data);
849         require(success, "SafeERC20: low-level call failed");
850 
851         if (returndata.length > 0) { // Return data is optional
852             // solhint-disable-next-line max-line-length
853             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
854         }
855     }
856 }
857 
858 /**
859  * @dev Collection of functions related to the address type,
860  */
861 library Address {
862     /**
863      * @dev Returns true if `account` is a contract.
864      *
865      * This test is non-exhaustive, and there may be false-negatives: during the
866      * execution of a contract's constructor, its address will be reported as
867      * not containing a contract.
868      *
869      * > It is unsafe to assume that an address for which this function returns
870      * false is an externally-owned account (EOA) and not a contract.
871      */
872     function isContract(address account) internal view returns (bool) {
873         // This method relies in extcodesize, which returns 0 for contracts in
874         // construction, since the code is only stored at the end of the
875         // constructor execution.
876 
877         uint256 size;
878         // solhint-disable-next-line no-inline-assembly
879         assembly { size := extcodesize(account) }
880         return size > 0;
881     }
882 }
883 
884 /**
885   @dev An extension to PooledCDAI that enables minting & burning pcDAI using ETH & ERC20 tokens
886     supported by Kyber Network, rather than just DAI. There's no need to deploy one for each pool,
887     since it uses pcDAI as a black box.
888  */
889 contract PooledCDAIKyberExtension {
890   using SafeERC20 for ERC20;
891   using SafeERC20 for PooledCDAI;
892   using SafeMath for uint256;
893 
894   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
895   address public constant KYBER_ADDRESS = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
896   ERC20 internal constant ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
897   bytes internal constant PERM_HINT = "PERM"; // Only use permissioned reserves from Kyber
898   uint internal constant MAX_QTY   = (10**28); // 10B tokens
899 
900   function mintWithETH(PooledCDAI pcDAI, address to) public payable returns (bool) {
901     // convert `msg.value` ETH to DAI
902     ERC20 dai = ERC20(DAI_ADDRESS);
903     (uint256 actualDAIAmount, uint256 actualETHAmount) = _kyberTrade(ETH_TOKEN_ADDRESS, msg.value, dai);
904 
905     // mint `actualDAIAmount` pcDAI
906     _mint(pcDAI, to, actualDAIAmount);
907 
908     // return any leftover ETH
909     if (actualETHAmount < msg.value) {
910       msg.sender.transfer(msg.value.sub(actualETHAmount));
911     }
912 
913     return true;
914   }
915 
916   function mintWithToken(PooledCDAI pcDAI, address tokenAddress, address to, uint256 amount) public returns (bool) {
917     require(tokenAddress != address(ETH_TOKEN_ADDRESS), "Use mintWithETH() instead");
918     require(tokenAddress != DAI_ADDRESS, "Use mint() instead");
919 
920     // transfer `amount` token from msg.sender
921     ERC20 token = ERC20(tokenAddress);
922     token.safeTransferFrom(msg.sender, address(this), amount);
923 
924     // convert `amount` token to DAI
925     ERC20 dai = ERC20(DAI_ADDRESS);
926     (uint256 actualDAIAmount, uint256 actualTokenAmount) = _kyberTrade(token, amount, dai);
927 
928     // mint `actualDAIAmount` pcDAI
929     _mint(pcDAI, to, actualDAIAmount);
930 
931     // return any leftover tokens
932     if (actualTokenAmount < amount) {
933       token.safeTransfer(msg.sender, amount.sub(actualTokenAmount));
934     }
935 
936     return true;
937   }
938 
939   function burnToETH(PooledCDAI pcDAI, address payable to, uint256 amount) public returns (bool) {
940     // burn `amount` pcDAI for msg.sender to get DAI
941     _burn(pcDAI, amount);
942 
943     // convert `amount` DAI to ETH
944     ERC20 dai = ERC20(DAI_ADDRESS);
945     (uint256 actualETHAmount, uint256 actualDAIAmount) = _kyberTrade(dai, amount, ETH_TOKEN_ADDRESS);
946 
947     // transfer `actualETHAmount` ETH to `to`
948     to.transfer(actualETHAmount);
949 
950     // transfer any leftover DAI
951     if (actualDAIAmount < amount) {
952       dai.safeTransfer(msg.sender, amount.sub(actualDAIAmount));
953     }
954 
955     return true;
956   }
957 
958   function burnToToken(PooledCDAI pcDAI, address tokenAddress, address to, uint256 amount) public returns (bool) {
959     require(tokenAddress != address(ETH_TOKEN_ADDRESS), "Use burnToETH() instead");
960     require(tokenAddress != DAI_ADDRESS, "Use burn() instead");
961 
962     // burn `amount` pcDAI for msg.sender to get DAI
963     _burn(pcDAI, amount);
964 
965     // convert `amount` DAI to token
966     ERC20 dai = ERC20(DAI_ADDRESS);
967     ERC20 token = ERC20(tokenAddress);
968     (uint256 actualTokenAmount, uint256 actualDAIAmount) = _kyberTrade(dai, amount, token);
969 
970     // transfer `actualTokenAmount` token to `to`
971     token.safeTransfer(to, actualTokenAmount);
972 
973     // transfer any leftover DAI
974     if (actualDAIAmount < amount) {
975       dai.safeTransfer(msg.sender, amount.sub(actualDAIAmount));
976     }
977 
978     return true;
979   }
980 
981   function _mint(PooledCDAI pcDAI, address to, uint256 actualDAIAmount) internal {
982     ERC20 dai = ERC20(DAI_ADDRESS);
983     dai.safeApprove(address(pcDAI), 0);
984     dai.safeApprove(address(pcDAI), actualDAIAmount);
985     require(pcDAI.mint(to, actualDAIAmount), "Failed to mint pcDAI");
986   }
987 
988   function _burn(PooledCDAI pcDAI, uint256 amount) internal {
989     // transfer `amount` pcDAI from msg.sender
990     pcDAI.safeTransferFrom(msg.sender, address(this), amount);
991 
992     // burn `amount` pcDAI for DAI
993     require(pcDAI.burn(address(this), amount), "Failed to burn pcDAI");
994   }
995 
996   /**
997    * @notice Get the token balance of an account
998    * @param _token the token to be queried
999    * @param _addr the account whose balance will be returned
1000    * @return token balance of the account
1001    */
1002   function _getBalance(ERC20 _token, address _addr) internal view returns(uint256) {
1003     if (address(_token) == address(ETH_TOKEN_ADDRESS)) {
1004       return uint256(_addr.balance);
1005     }
1006     return uint256(_token.balanceOf(_addr));
1007   }
1008 
1009   function _toPayableAddr(address _addr) internal pure returns (address payable) {
1010     return address(uint160(_addr));
1011   }
1012 
1013   /**
1014    * @notice Wrapper function for doing token conversion on Kyber Network
1015    * @param _srcToken the token to convert from
1016    * @param _srcAmount the amount of tokens to be converted
1017    * @param _destToken the destination token
1018    * @return _destPriceInSrc the price of the dest token, in terms of source tokens
1019    *         _srcPriceInDest the price of the source token, in terms of dest tokens
1020    *         _actualDestAmount actual amount of dest token traded
1021    *         _actualSrcAmount actual amount of src token traded
1022    */
1023   function _kyberTrade(ERC20 _srcToken, uint256 _srcAmount, ERC20 _destToken)
1024     internal
1025     returns(
1026       uint256 _actualDestAmount,
1027       uint256 _actualSrcAmount
1028     )
1029   {
1030     // Get current rate & ensure token is listed on Kyber
1031     KyberNetworkProxy kyber = KyberNetworkProxy(KYBER_ADDRESS);
1032     (, uint256 rate) = kyber.getExpectedRate(_srcToken, _destToken, _srcAmount);
1033     require(rate > 0, "Price for token is 0 on Kyber");
1034 
1035     uint256 beforeSrcBalance = _getBalance(_srcToken, address(this));
1036     uint256 msgValue;
1037     if (_srcToken != ETH_TOKEN_ADDRESS) {
1038       msgValue = 0;
1039       _srcToken.safeApprove(KYBER_ADDRESS, 0);
1040       _srcToken.safeApprove(KYBER_ADDRESS, _srcAmount);
1041     } else {
1042       msgValue = _srcAmount;
1043     }
1044     _actualDestAmount = kyber.tradeWithHint.value(msgValue)(
1045       _srcToken,
1046       _srcAmount,
1047       _destToken,
1048       _toPayableAddr(address(this)),
1049       MAX_QTY,
1050       rate,
1051       0x8B2315243349f461045854beec3c5aFA84f600B6,
1052       PERM_HINT
1053     );
1054     require(_actualDestAmount > 0, "Received 0 dest token");
1055     if (_srcToken != ETH_TOKEN_ADDRESS) {
1056       _srcToken.safeApprove(KYBER_ADDRESS, 0);
1057     }
1058 
1059     _actualSrcAmount = beforeSrcBalance.sub(_getBalance(_srcToken, address(this)));
1060   }
1061 }