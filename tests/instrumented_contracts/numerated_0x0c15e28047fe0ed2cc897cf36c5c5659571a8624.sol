1 // File: contracts/contracts/math/Math.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: contracts/contracts/token/ERC20/IERC20.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
39  * the optional functions; to access them see `ERC20Detailed`.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a `Transfer` event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through `transferFrom`. This is
67      * zero by default.
68      *
69      * This value changes when `approve` or `transferFrom` are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * > Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an `Approval` event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a `Transfer` event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to `approve`. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 // File: contracts/contracts/math/SafeMath.sol
116 
117 pragma solidity ^0.5.0;
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b <= a, "SafeMath: subtraction overflow");
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
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         // Solidity only automatically asserts when dividing by 0
201         require(b > 0, "SafeMath: division by zero");
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         require(b != 0, "SafeMath: modulo by zero");
221         return a % b;
222     }
223 }
224 
225 // File: contracts/contracts/token/ERC20/ERC20.sol
226 
227 pragma solidity ^0.5.0;
228 
229 
230 /**
231  * @dev Implementation of the `IERC20` interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using `_mint`.
235  * For a generic mechanism see `ERC20Mintable`.
236  *
237  * *For a detailed writeup see our guide [How to implement supply
238  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
239  *
240  * We have followed general OpenZeppelin guidelines: functions revert instead
241  * of returning `false` on failure. This behavior is nonetheless conventional
242  * and does not conflict with the expectations of ERC20 applications.
243  *
244  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
245  * This allows applications to reconstruct the allowance for all accounts just
246  * by listening to said events. Other implementations of the EIP may not emit
247  * these events, as it isn't required by the specification.
248  *
249  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
250  * functions have been added to mitigate the well-known issues around setting
251  * allowances. See `IERC20.approve`.
252  */
253 contract ERC20 is IERC20 {
254     using SafeMath for uint256;
255 
256     mapping (address => uint256) private _balances;
257 
258     mapping (address => mapping (address => uint256)) private _allowances;
259 
260     uint256 private _totalSupply;
261 
262     string private _name;
263     string private _symbol;
264     uint8 private _decimals;
265 
266     constructor (string memory name, string memory symbol) public {
267         _name = name;
268         _symbol = symbol;
269         _decimals = 9;
270     }
271 
272     /**
273      * @dev Returns the name of the token.
274      */
275     function name() public view returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @dev Returns the symbol of the token, usually a shorter version of the
281      * name.
282      */
283     function symbol() public view returns (string memory) {
284         return _symbol;
285     }
286 
287     /**
288      * @dev Returns the number of decimals used to get its user representation.
289      * For example, if `decimals` equals `2`, a balance of `505` tokens should
290      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
291      *
292      * Tokens usually opt for a value of 18, imitating the relationship between
293      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
294      * called.
295      *
296      * NOTE: This information is only used for _display_ purposes: it in
297      * no way affects any of the arithmetic of the contract, including
298      * {IERC20-balanceOf} and {IERC20-transfer}.
299      */
300 
301     function decimals() public view returns (uint8) {
302         return _decimals;
303     }
304     
305     /**
306      * @dev See `IERC20.totalSupply`.
307      */
308     function totalSupply() public view returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313      * @dev See `IERC20.balanceOf`.
314      */
315     function balanceOf(address account) public view returns (uint256) {
316         return _balances[account];
317     }
318 
319     /**
320      * @dev See `IERC20.transfer`.
321      *
322      * Requirements:
323      *
324      * - `recipient` cannot be the zero address.
325      * - the caller must have a balance of at least `amount`.
326      */
327     function transfer(address recipient, uint256 amount) public returns (bool) {
328         _transfer(msg.sender, recipient, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See `IERC20.allowance`.
334      */
335     function allowance(address owner, address spender) public view returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     /**
340      * @dev See `IERC20.approve`.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function approve(address spender, uint256 value) public returns (bool) {
347         _approve(msg.sender, spender, value);
348         return true;
349     }
350 
351     /**
352      * @dev See `IERC20.transferFrom`.
353      *
354      * Emits an `Approval` event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of `ERC20`;
356      *
357      * Requirements:
358      * - `sender` and `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `value`.
360      * - the caller must have allowance for `sender`'s tokens of at least
361      * `amount`.
362      */
363     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
364         _transfer(sender, recipient, amount);
365         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
366         return true;
367     }
368 
369     /**
370      * @dev Atomically increases the allowance granted to `spender` by the caller.
371      *
372      * This is an alternative to `approve` that can be used as a mitigation for
373      * problems described in `IERC20.approve`.
374      *
375      * Emits an `Approval` event indicating the updated allowance.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
382         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
383         return true;
384     }
385 
386     /**
387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to `approve` that can be used as a mitigation for
390      * problems described in `IERC20.approve`.
391      *
392      * Emits an `Approval` event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      * - `spender` must have allowance for the caller of at least
398      * `subtractedValue`.
399      */
400     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
401         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
402         return true;
403     }
404 
405     /**
406      * @dev Moves tokens `amount` from `sender` to `recipient`.
407      *
408      * This is internal function is equivalent to `transfer`, and can be used to
409      * e.g. implement automatic token fees, slashing mechanisms, etc.
410      *
411      * Emits a `Transfer` event.
412      *
413      * Requirements:
414      *
415      * - `sender` cannot be the zero address.
416      * - `recipient` cannot be the zero address.
417      * - `sender` must have a balance of at least `amount`.
418      */
419     function _transfer(address sender, address recipient, uint256 amount) internal {
420         require(sender != address(0), "ERC20: transfer from the zero address");
421         require(recipient != address(0), "ERC20: transfer to the zero address");
422 
423         _balances[sender] = _balances[sender].sub(amount);
424         _balances[recipient] = _balances[recipient].add(amount);
425         emit Transfer(sender, recipient, amount);
426     }
427 
428     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429      * the total supply.
430      *
431      * Emits a `Transfer` event with `from` set to the zero address.
432      *
433      * Requirements
434      *
435      * - `to` cannot be the zero address.
436      */
437     function _mint(address account, uint256 amount) internal {
438         require(account != address(0), "ERC20: mint to the zero address");
439 
440         _totalSupply = _totalSupply.add(amount);
441         _balances[account] = _balances[account].add(amount);
442         emit Transfer(address(0), account, amount);
443     }
444 
445      /**
446      * @dev Destoys `amount` tokens from `account`, reducing the
447      * total supply.
448      *
449      * Emits a `Transfer` event with `to` set to the zero address.
450      *
451      * Requirements
452      *
453      * - `account` cannot be the zero address.
454      * - `account` must have at least `amount` tokens.
455      */
456     function _burn(address account, uint256 value) internal {
457         require(account != address(0), "ERC20: burn from the zero address");
458 
459         _totalSupply = _totalSupply.sub(value);
460         _balances[account] = _balances[account].sub(value);
461         emit Transfer(account, address(0), value);
462     }
463 
464     /**
465      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
466      *
467      * This is internal function is equivalent to `approve`, and can be used to
468      * e.g. set automatic allowances for certain subsystems, etc.
469      *
470      * Emits an `Approval` event.
471      *
472      * Requirements:
473      *
474      * - `owner` cannot be the zero address.
475      * - `spender` cannot be the zero address.
476      */
477     function _approve(address owner, address spender, uint256 value) internal {
478         require(owner != address(0), "ERC20: approve from the zero address");
479         require(spender != address(0), "ERC20: approve to the zero address");
480 
481         _allowances[owner][spender] = value;
482         emit Approval(owner, spender, value);
483     }
484 
485 
486     /**
487      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
488      * from the caller's allowance.
489      *
490      * See `_burn` and `_approve`.
491      */
492     function _burnFrom(address account, uint256 amount) internal {
493         _burn(account, amount);
494         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
495     }
496 }
497 
498 // File: contracts/contracts/ownership/MultOwnable.sol
499 
500 pragma solidity ^0.5.0;
501 
502 
503 contract MultOwnable {
504   address[] private _owner;
505 
506   event OwnershipTransferred(
507     address indexed previousOwner,
508     address indexed newOwner
509   );
510 
511   constructor() internal {
512     _owner.push(msg.sender);
513     emit OwnershipTransferred(address(0), _owner[0]);
514   }
515 
516   function checkOwner() private view returns (bool) {
517     for (uint8 i = 0; i < _owner.length; i++) {
518       if (_owner[i] == msg.sender) {
519         return true;
520       }
521     }
522     return false;
523   }
524 
525   function checkNewOwner(address _address) private view returns (bool) {
526     for (uint8 i = 0; i < _owner.length; i++) {
527       if (_owner[i] == _address) {
528         return false;
529       }
530     }
531     return true;
532   }
533 
534   modifier isAnOwner() {
535     require(checkOwner(), "Ownable: caller is not the owner");
536     _;
537   }
538 
539   function renounceOwnership() public isAnOwner {
540     for (uint8 i = 0; i < _owner.length; i++) {
541       if (_owner[i] == msg.sender) {
542         _owner[i] = address(0);
543         emit OwnershipTransferred(_owner[i], msg.sender);
544       }
545     }
546   }
547 
548   function getOwners() public view returns (address[] memory) {
549     return _owner;
550   }
551 
552   function addOwnerShip(address newOwner) public isAnOwner {
553     _addOwnerShip(newOwner);
554   }
555 
556   function _addOwnerShip(address newOwner) internal {
557     require(newOwner != address(0), "Ownable: new owner is the zero address");
558     require(checkNewOwner(newOwner), "Owner already exists");
559     _owner.push(newOwner);
560     emit OwnershipTransferred(_owner[_owner.length - 1], newOwner);
561   }
562 }
563 
564 // File: contracts/TulipToken.sol
565 
566 pragma solidity ^0.5.16;
567 
568 
569 
570 contract TulipToken is MultOwnable, ERC20{
571     constructor (string memory name, string memory symbol) public ERC20(name, symbol) MultOwnable(){
572     }
573 
574     function contractMint(address account, uint256 amount) external isAnOwner{
575         _mint(account, amount);
576     }
577 
578     function contractBurn(address account, uint256 amount) external isAnOwner{
579         _burn(account, amount);
580     }
581 
582 
583      /* ========== RESTRICTED FUNCTIONS ========== */
584     function addOwner(address _newOwner) external isAnOwner {
585         addOwnerShip(_newOwner);
586     }
587 
588     function getOwner() external view isAnOwner{
589         getOwners();
590     }
591 
592     function renounceOwner() external isAnOwner {
593         renounceOwnership();
594     }
595 }
596 
597 // File: contracts/contracts/token/ERC20/ERC20Detailed.sol
598 
599 pragma solidity ^0.5.0;
600 
601 
602 /**
603  * @dev Optional functions from the ERC20 standard.
604  */
605 contract ERC20Detailed is IERC20 {
606     string private _name;
607     string private _symbol;
608     uint8 private _decimals;
609 
610     /**
611      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
612      * these values are immutable: they can only be set once during
613      * construction.
614      */
615     constructor (string memory name, string memory symbol, uint8 decimals) public {
616         _name = name;
617         _symbol = symbol;
618         _decimals = decimals;
619     }
620 
621     /**
622      * @dev Returns the name of the token.
623      */
624     function name() public view returns (string memory) {
625         return _name;
626     }
627 
628     /**
629      * @dev Returns the symbol of the token, usually a shorter version of the
630      * name.
631      */
632     function symbol() public view returns (string memory) {
633         return _symbol;
634     }
635 
636     /**
637      * @dev Returns the number of decimals used to get its user representation.
638      * For example, if `decimals` equals `2`, a balance of `505` tokens should
639      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
640      *
641      * Tokens usually opt for a value of 18, imitating the relationship between
642      * Ether and Wei.
643      *
644      * > Note that this information is only used for _display_ purposes: it in
645      * no way affects any of the arithmetic of the contract, including
646      * `IERC20.balanceOf` and `IERC20.transfer`.
647      */
648     function decimals() public view returns (uint8) {
649         return _decimals;
650     }
651 }
652 
653 // File: contracts/contracts/utils/Address.sol
654 
655 pragma solidity ^0.5.0;
656 
657 /**
658  * @dev Collection of functions related to the address type,
659  */
660 library Address {
661     /**
662      * @dev Returns true if `account` is a contract.
663      *
664      * This test is non-exhaustive, and there may be false-negatives: during the
665      * execution of a contract's constructor, its address will be reported as
666      * not containing a contract.
667      *
668      * > It is unsafe to assume that an address for which this function returns
669      * false is an externally-owned account (EOA) and not a contract.
670      */
671     function isContract(address account) internal view returns (bool) {
672         // This method relies in extcodesize, which returns 0 for contracts in
673         // construction, since the code is only stored at the end of the
674         // constructor execution.
675 
676         uint256 size;
677         // solhint-disable-next-line no-inline-assembly
678         assembly { size := extcodesize(account) }
679         return size > 0;
680     }
681 }
682 
683 // File: contracts/contracts/token/ERC20/SafeERC20.sol
684 
685 pragma solidity ^0.5.0;
686 
687 
688 
689 
690 /**
691  * @title SafeERC20
692  * @dev Wrappers around ERC20 operations that throw on failure (when the token
693  * contract returns false). Tokens that return no value (and instead revert or
694  * throw on failure) are also supported, non-reverting calls are assumed to be
695  * successful.
696  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
697  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
698  */
699 library SafeERC20 {
700     using SafeMath for uint256;
701     using Address for address;
702 
703     function safeTransfer(IERC20 token, address to, uint256 value) internal {
704         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
705     }
706 
707     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
708         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
709     }
710 
711     function safeApprove(IERC20 token, address spender, uint256 value) internal {
712         // safeApprove should only be called when setting an initial allowance,
713         // or when resetting it to zero. To increase and decrease it, use
714         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
715         // solhint-disable-next-line max-line-length
716         require((value == 0) || (token.allowance(address(this), spender) == 0),
717             "SafeERC20: approve from non-zero to non-zero allowance"
718         );
719         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
720     }
721 
722     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
723         uint256 newAllowance = token.allowance(address(this), spender).add(value);
724         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
725     }
726 
727     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
728         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
729         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
730     }
731 
732     /**
733      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
734      * on the return value: the return value is optional (but if data is returned, it must not be false).
735      * @param token The token targeted by the call.
736      * @param data The call data (encoded using abi.encode or one of its variants).
737      */
738     function callOptionalReturn(IERC20 token, bytes memory data) private {
739         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
740         // we're implementing it ourselves.
741 
742         // A Solidity high level call has three parts:
743         //  1. The target address is checked to verify it contains contract code
744         //  2. The call itself is made, and success asserted
745         //  3. The return value is decoded, which in turn checks the size of the returned data.
746         // solhint-disable-next-line max-line-length
747         require(address(token).isContract(), "SafeERC20: call to non-contract");
748 
749         // solhint-disable-next-line avoid-low-level-calls
750         (bool success, bytes memory returndata) = address(token).call(data);
751         require(success, "SafeERC20: low-level call failed");
752 
753         if (returndata.length > 0) { // Return data is optional
754             // solhint-disable-next-line max-line-length
755             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
756         }
757     }
758 }
759 
760 // File: contracts/contracts/ownership/Ownable.sol
761 
762 pragma solidity ^0.5.0;
763 
764 /**
765  * @dev Contract module which provides a basic access control mechanism, where
766  * there is an account (an owner) that can be granted exclusive access to
767  * specific functions.
768  *
769  * This module is used through inheritance. It will make available the modifier
770  * `onlyOwner`, which can be aplied to your functions to restrict their use to
771  * the owner.
772  */
773 contract Ownable {
774     address private _owner;
775 
776     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
777 
778     /**
779      * @dev Initializes the contract setting the deployer as the initial owner.
780      */
781     constructor () internal {
782         _owner = msg.sender;
783         emit OwnershipTransferred(address(0), _owner);
784     }
785 
786     /**
787      * @dev Returns the address of the current owner.
788      */
789     function owner() public view returns (address) {
790         return _owner;
791     }
792 
793     /**
794      * @dev Throws if called by any account other than the owner.
795      */
796     modifier onlyOwner() {
797         require(isOwner(), "Ownable: caller is not the owner");
798         _;
799     }
800 
801     /**
802      * @dev Returns true if the caller is the current owner.
803      */
804     function isOwner() public view returns (bool) {
805         return msg.sender == _owner;
806     }
807 
808     /**
809      * @dev Leaves the contract without owner. It will not be possible to call
810      * `onlyOwner` functions anymore. Can only be called by the current owner.
811      *
812      * > Note: Renouncing ownership will leave the contract without an owner,
813      * thereby removing any functionality that is only available to the owner.
814      */
815     function renounceOwnership() public onlyOwner {
816         emit OwnershipTransferred(_owner, address(0));
817         _owner = address(0);
818     }
819 
820     /**
821      * @dev Transfers ownership of the contract to a new account (`newOwner`).
822      * Can only be called by the current owner.
823      */
824     function transferOwnership(address newOwner) public onlyOwner {
825         _transferOwnership(newOwner);
826     }
827 
828     /**
829      * @dev Transfers ownership of the contract to a new account (`newOwner`).
830      */
831     function _transferOwnership(address newOwner) internal {
832         require(newOwner != address(0), "Ownable: new owner is the zero address");
833         emit OwnershipTransferred(_owner, newOwner);
834         _owner = newOwner;
835     }
836 }
837 
838 // File: contracts/contracts/utils/ReentrancyGuard.sol
839 
840 pragma solidity ^0.5.0;
841 
842 /**
843  * @dev Contract module that helps prevent reentrant calls to a function.
844  *
845  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
846  * available, which can be aplied to functions to make sure there are no nested
847  * (reentrant) calls to them.
848  *
849  * Note that because there is a single `nonReentrant` guard, functions marked as
850  * `nonReentrant` may not call one another. This can be worked around by making
851  * those functions `private`, and then adding `external` `nonReentrant` entry
852  * points to them.
853  */
854 contract ReentrancyGuard {
855     /// @dev counter to allow mutex lock with only one SSTORE operation
856     uint256 private _guardCounter;
857 
858     constructor () internal {
859         // The counter starts at one to prevent changing it from zero to a non-zero
860         // value, which is a more expensive operation.
861         _guardCounter = 1;
862     }
863 
864     /**
865      * @dev Prevents a contract from calling itself, directly or indirectly.
866      * Calling a `nonReentrant` function from another `nonReentrant`
867      * function is not supported. It is possible to prevent this from happening
868      * by making the `nonReentrant` function external, and make it call a
869      * `private` function that does the actual work.
870      */
871     modifier nonReentrant() {
872         _guardCounter += 1;
873         uint256 localCounter = _guardCounter;
874         _;
875         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
876     }
877 }
878 
879 // File: contracts/GardenContractV1.sol
880 
881 pragma solidity ^0.5.16;
882 
883 
884 
885 
886 
887 
888 
889 
890 contract GardenContractV1 is Ownable, ReentrancyGuard {
891   using SafeMath for uint256;
892   using SafeERC20 for TulipToken;
893   using SafeERC20 for IERC20;
894 
895   /* ========== STATE VARIABLES ========== */
896   
897   uint256 private _epochBlockStart;
898 
899   uint256 private _epochRedTulipStart;
900 
901   uint8 private _pinkTulipDivider;
902 
903   uint256 private _decimalConverter = 10**9;
904 
905   struct  tulipToken{
906       TulipToken token;
907       uint256 totalSupply;
908       mapping(address => uint256)  balances;
909       mapping(address => uint256)  periodFinish;
910   }
911 
912   tulipToken[3] private _tulipToken;
913 
914   struct externalToken{
915       IERC20 token;
916       uint256 rewardsDuration;
917       uint256 rewardsMultiplier;
918       string rewardsMultiplierType;
919       uint256 totalSupply;
920       address tokenAddress;
921       mapping(address => uint256)  balances;
922       mapping(address => uint256)  periodFinish;
923   }
924 
925   externalToken[] private _externalToken;
926 
927   /* ========== CONSTRUCTOR ========== */
928 
929   constructor(address _seedToken, address _basicTulipToken, address _advTulipToken) public Ownable() {
930     
931     _tulipToken[0].token = TulipToken(_seedToken);
932     _tulipToken[1].token = TulipToken(_basicTulipToken);
933     _tulipToken[2].token = TulipToken(_advTulipToken);
934     
935     _pinkTulipDivider = 100;
936     _epochBlockStart = 1600610400;
937     _epochRedTulipStart = _epochBlockStart;
938   }
939 
940   /* ========== VIEWS ========== */
941 
942       /* ========== internal ========== */
943 
944   function totalSupply(string calldata name) external view returns (uint256) {
945     uint8 i = tulipType(name);
946     return _tulipToken[i].totalSupply;
947   }
948 
949   function durationRemaining(address account, string calldata name) external view returns (uint256) {
950     uint8 i = tulipType(name);
951     return _tulipToken[i].periodFinish[account].sub(now);
952   }
953 
954   function balanceOf(address account, string calldata name) external view returns (uint256)
955   {
956     uint8 i = tulipType(name);
957     return _tulipToken[i].balances[account];
958   }
959 
960       /* ========== external ========== */
961 
962     function totalExternalSupply(address extToken) external view returns (uint256) {
963       uint8 i = externalTokenIndex(extToken);
964       return _externalToken[i].totalSupply;
965     }
966 
967     function externalDurationRemaining(address account, address extToken) external view returns (uint256) {
968       uint8 i = externalTokenIndex(extToken);
969       return _externalToken[i].periodFinish[account].sub(now);
970     }
971 
972     function externalBalanceOf(address account, address extToken) external view returns (uint256)
973     {
974       uint8 i = externalTokenIndex(extToken);
975       return  _externalToken[i].balances[account];
976     } 
977 
978   /* ========== MUTATIVE FUNCTIONS ========== */
979 
980       /* ========== internal garden ========== */
981   function plant(uint256 amount, string calldata name) external nonReentrant {    
982     require(now > _epochBlockStart, "The garden is being set up!");
983 
984     uint8 i = tulipType(name);
985 
986     require(i < 99, "Not a valid tulip name");
987     
988     require(amount >= 1, "Cannot stake less than 1");
989 
990     if(i == 1){
991       uint256 modulo = amount % 100;
992       require(modulo == 0, "If planting a pink tulip, has to be multiple of 100");
993     }
994 
995     require(_tulipToken[i].balances[msg.sender] == 0 && (_tulipToken[i].periodFinish[msg.sender] == 0 || now > _tulipToken[i].periodFinish[msg.sender]), 
996     "You must withdraw the previous crop before planting more!");
997 
998     _tulipToken[i].token.safeTransferFrom(msg.sender, address(this), amount.mul(_decimalConverter));
999 
1000     _tulipToken[i].totalSupply = _tulipToken[i].totalSupply.add(amount);
1001 
1002     _tulipToken[i].balances[msg.sender] = _tulipToken[i].balances[msg.sender].add(amount);
1003 
1004     setTimeStamp(i);
1005 
1006     emit Staked(msg.sender, amount);
1007   }
1008 
1009   
1010   function withdraw(string memory name) public nonReentrant {
1011     uint8 i = tulipType(name);
1012 
1013     require(i < 99, "Not a valid tulip name");
1014 
1015     require(_tulipToken[i].balances[msg.sender] > 0, "Cannot withdraw 0");
1016 
1017     _tulipToken[i].token.safeTransfer(msg.sender, _tulipToken[i].balances[msg.sender].mul(_decimalConverter));
1018 
1019     emit Withdrawn(msg.sender,_tulipToken[i].balances[msg.sender]);
1020 
1021     zeroHoldings(i);
1022   }
1023 
1024 
1025   function harvest(string memory name) public nonReentrant {
1026     uint8 i = tulipType(name);
1027 
1028     require(i < 99, "Not a valid tulip name");
1029     
1030     require(_tulipToken[i].balances[msg.sender] > 0, "Cannot harvest 0");
1031     
1032     require(now > _tulipToken[i].periodFinish[msg.sender], "Cannot harvest until the flowers have bloomed!");
1033 
1034     uint256 tempAmount;
1035 
1036     if (i == 2) {
1037       tempAmount = setRedTulipRewardAmount();
1038       _tulipToken[0].token.contractMint(msg.sender, tempAmount.mul(_decimalConverter));
1039       _tulipToken[i].periodFinish[msg.sender] = now.add(7 days);
1040     } 
1041     else {
1042       _tulipToken[i].token.contractBurn(address(this), _tulipToken[i].balances[msg.sender].mul(_decimalConverter));
1043       if(i == 1){
1044         tempAmount = _tulipToken[i].balances[msg.sender].div(_pinkTulipDivider);
1045       }
1046       else{
1047         tempAmount = _tulipToken[i].balances[msg.sender];
1048       }
1049       
1050       _tulipToken[i + 1].token.contractMint(msg.sender, tempAmount.mul(_decimalConverter));
1051 
1052       zeroHoldings(i);
1053     }
1054     emit RewardPaid(msg.sender, tempAmount);
1055   }
1056 
1057       /* ========== external garden ========== */
1058 
1059   function externalPlant(uint256 amount, address tokenAddress) external nonReentrant {    
1060     require(now > _epochBlockStart, "The garden is being set up!");
1061 
1062     uint8 i = externalTokenIndex(tokenAddress);
1063 
1064     require(i < 99, "Not a valid token address");
1065 
1066     require(amount > 0, "Cannot stake 0");
1067 
1068     require(_externalToken[i].balances[msg.sender] == 0 && (_externalToken[i].periodFinish[msg.sender] == 0 || now > _externalToken[i].periodFinish[msg.sender]), 
1069     "You must withdraw the previous stake before planting more!");
1070 
1071     _externalToken[i].token.safeTransferFrom(msg.sender, address(this), amount);
1072 
1073     _externalToken[i].totalSupply = _externalToken[i].totalSupply.add(amount);
1074 
1075     _externalToken[i].balances[msg.sender] = _externalToken[i].balances[msg.sender].add(amount);
1076 
1077     _externalToken[i].periodFinish[msg.sender] = now.add(_externalToken[i].rewardsDuration);
1078 
1079     emit Staked(msg.sender, amount);
1080   }
1081 
1082   
1083   function externalWithdraw(address tokenAddress) public nonReentrant {
1084     uint8 i = externalTokenIndex(tokenAddress);
1085 
1086     require(i < 99, "Not a valid token address");
1087 
1088     require(_externalToken[i].totalSupply > 0, "Cannot withdraw 0");
1089 
1090     _externalToken[i].token.safeTransfer(msg.sender, _externalToken[i].balances[msg.sender]);
1091 
1092     emit Withdrawn(msg.sender, _externalToken[i].balances[msg.sender]);
1093 
1094      _externalToken[i].totalSupply = _externalToken[i].totalSupply - _externalToken[i].balances[msg.sender];
1095      _externalToken[i].balances[msg.sender] = 0;
1096      _externalToken[i].periodFinish[msg.sender] = 0;
1097   }
1098 
1099 
1100   function externalHarvest(address tokenAddress) public nonReentrant {
1101     uint8 i = externalTokenIndex(tokenAddress);
1102 
1103     require(i < 99, "Not a valid token address");
1104 
1105     require(_externalToken[i].totalSupply > 0, "Cannot harvest 0");
1106 
1107     require(now > _externalToken[i].periodFinish[msg.sender], "Cannot harvest until the flowers have bloomed!");
1108 
1109     if(keccak256(abi.encodePacked(_externalToken[i].rewardsMultiplier)) == keccak256(abi.encodePacked("div"))){
1110       _tulipToken[0].token.contractMint(msg.sender, _externalToken[i].totalSupply.div(_externalToken[i].rewardsMultiplier));
1111     }else{
1112       _tulipToken[0].token.contractMint(msg.sender, _externalToken[i].totalSupply.mul(_externalToken[i].rewardsMultiplier));
1113     }
1114 
1115     _externalToken[i].periodFinish[msg.sender] = now.add(_externalToken[i].rewardsDuration);
1116     
1117     emit RewardPaid(msg.sender, _externalToken[i].totalSupply.mul(_externalToken[i].rewardsMultiplier));
1118   }
1119 
1120   /* ========== RESTRICTED FUNCTIONS ========== */
1121 
1122       /* ========== internal functions ========== */
1123 
1124   function addTokenOwner(address _token, address _newOwner) external onlyOwner
1125   {
1126     require(now > _epochBlockStart.add(30 days), "The admin functions are timelocked");
1127 
1128     TulipToken tempToken = TulipToken(_token);
1129     tempToken.addOwner(_newOwner);
1130   }
1131 
1132   function renounceTokenOwner(address _token) external onlyOwner
1133   {
1134     require(now > _epochBlockStart.add(30 days), "The admin functions are timelocked");
1135 
1136     TulipToken tempToken = TulipToken(_token);
1137     tempToken.renounceOwner();
1138   }
1139 
1140   function changeOwner(address _newOwner) external onlyOwner {
1141     transferOwnership(_newOwner);
1142   }
1143 
1144       /* ========== external functions ========== */
1145 
1146   function changeExternalTokenDuration(address _tokenAddress, uint256 _newDuration) external onlyOwner {
1147     uint8 i = externalTokenIndex(_tokenAddress);
1148 
1149     _externalToken[i].rewardsDuration = _newDuration;
1150   }
1151 
1152 
1153   function changeExternalTokenMultiplier(address _tokenAddress, uint256 _newMultiplier, string calldata _multType) external onlyOwner {
1154     uint8 i = externalTokenIndex(_tokenAddress);
1155 
1156     _externalToken[i].rewardsMultiplierType = _multType;
1157     _externalToken[i].rewardsMultiplier = _newMultiplier;
1158   }
1159 
1160 
1161   function addExternalToken(address _tokenAddress, uint256 _duration, uint256 _multiplier, string calldata _multiplierType ) external onlyOwner {
1162     require(keccak256(abi.encodePacked(_multiplierType)) == keccak256(abi.encodePacked("div"))|| keccak256(abi.encodePacked(_multiplierType)) == keccak256(abi.encodePacked("mul")), "Please enter a valid multiplier type");
1163    
1164     for(uint8 i = 0; i < _externalToken.length; i++){
1165       if(_externalToken[i].tokenAddress == _tokenAddress){
1166         require(_externalToken[i].tokenAddress != _tokenAddress, "This token has already been added!");
1167       }
1168     }
1169 
1170     _externalToken.push(externalToken(
1171       IERC20(_tokenAddress),
1172       _duration,
1173       _multiplier,
1174       _multiplierType,
1175       0,
1176        _tokenAddress
1177     ));
1178   }
1179 
1180 
1181   /* ========== HELPER FUNCTIONS ========== */
1182 
1183   function tulipType(string memory name) internal pure returns (uint8) {
1184     if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("sTLP"))) {
1185       return 0;
1186     }
1187     if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("pTLP"))) {
1188       return 1;
1189     }
1190     if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("rTLP"))) {
1191       return 2;
1192     } else {
1193       return 99;
1194     }
1195   }
1196 
1197 
1198   function externalTokenIndex(address tokenAddress) internal view returns(uint8){
1199     for (uint8 i = 0; i < _externalToken.length; i++){
1200       if(_externalToken[i].tokenAddress == tokenAddress){
1201         return i;
1202       }
1203     }
1204   }
1205 
1206 
1207   function setTimeStamp(uint8 i) internal{
1208     if (i == 0) {
1209       setRewardDurationSeeds();
1210     }
1211     if (i == 1) {
1212       setRewardDurationTulip();
1213     }
1214     if (i == 2) {
1215       _tulipToken[i].periodFinish[msg.sender] = now.add(7 days);
1216     }
1217   }
1218 
1219 
1220   function zeroHoldings(uint8 i) internal{
1221     _tulipToken[i].totalSupply = _tulipToken[i].totalSupply - _tulipToken[i].balances[msg.sender];
1222     _tulipToken[i].balances[msg.sender] = 0;
1223     _tulipToken[i].periodFinish[msg.sender] = 0;
1224   }
1225 
1226   /* ========== REAL FUNCTIONS ========== */
1227   
1228   function setRewardDurationSeeds() internal returns (bool) {
1229     uint256 timeSinceEpoch = ((now - _epochBlockStart) / 60 / 60 / 24 / 30) + 1;
1230 
1231     if (timeSinceEpoch >= 7) {
1232       _tulipToken[0].periodFinish[msg.sender] = now.add(7 days);
1233       return true;
1234     } else {
1235       _tulipToken[0].periodFinish[msg.sender] = now.add(
1236         timeSinceEpoch.mul(1 days)
1237       );
1238       return true;
1239     }
1240   }
1241 
1242 
1243   function setRewardDurationTulip() internal returns (bool) {
1244     uint256 timeSinceEpoch = ((now - _epochBlockStart) / 60 / 60 / 24) + 1;
1245 
1246     if (timeSinceEpoch <= 2) {
1247       _tulipToken[1].periodFinish[msg.sender] = now.add(2 days);
1248       return true;
1249     }
1250     if (timeSinceEpoch > 2 && timeSinceEpoch <= 7) {
1251       _tulipToken[1].periodFinish[msg.sender] = now.add(3 days);
1252       return true;
1253     }
1254     if (timeSinceEpoch > 7 && timeSinceEpoch <= 14) {
1255       _tulipToken[1].periodFinish[msg.sender] = now.add(7 days);
1256       return true;
1257     }
1258     if (timeSinceEpoch > 14) {
1259       uint256 tempInt = (timeSinceEpoch - 15 days) / 30;
1260 
1261       if (tempInt >= 7) {
1262         _tulipToken[1].periodFinish[msg.sender] = now.add(30 days);
1263         return true;
1264       } else {
1265         _tulipToken[1].periodFinish[msg.sender] = now.add(
1266           14 days + (tempInt.mul(2 days))
1267         );
1268         return true;
1269       }
1270     }
1271   }
1272 
1273 
1274   function setRedTulipRewardAmount() internal view returns (uint256) {
1275     uint256 timeSinceEpoch = (now - _tulipToken[2].periodFinish[msg.sender].sub(7 days)) / 60 / 60 / 24;
1276     uint256 amountWeeks = timeSinceEpoch.div(7);
1277     uint256 newtime = now;
1278     uint256 value = 0;
1279 
1280     for (uint256 i = amountWeeks; i != 0; i--) {
1281       uint256 tempTime = newtime.sub(i.mul(7 days));
1282 
1283       if (tempTime > _epochRedTulipStart && tempTime <= _epochRedTulipStart.add(7 days)) {
1284         value = value.add(50);
1285       }
1286       if (tempTime > _epochRedTulipStart.add(7 days) && tempTime <= _epochRedTulipStart.add(21 days)) {
1287         value = value.add(25);
1288       }
1289       if (tempTime > _epochRedTulipStart.add(21 days)) {
1290         value = value.add(10);
1291       }
1292     }
1293     return value * _tulipToken[2].balances[msg.sender];
1294   }
1295 
1296   /* ========== EVENTS ========== */
1297   event Staked(address indexed user, uint256 amount);
1298   event Withdrawn(address indexed user, uint256 amount);
1299   event RewardPaid(address indexed user, uint256 reward);
1300 }