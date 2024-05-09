1 pragma solidity 0.5.7;
2 
3 
4 /**
5  * @dev Contract module which provides a basic access control mechanism, where
6  * there is an account (an owner) that can be granted exclusive access to
7  * specific functions.
8  *
9  * This module is used through inheritance. It will make available the modifier
10  * `onlyOwner`, which can be aplied to your functions to restrict their use to
11  * the owner.
12  */
13 contract Ownable {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev Initializes the contract setting the deployer as the initial owner.
20      */
21     constructor () internal {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /**
27      * @dev Returns the address of the current owner.
28      */
29     function owner() public view returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(isOwner(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     /**
42      * @dev Returns true if the caller is the current owner.
43      */
44     function isOwner() public view returns (bool) {
45         return msg.sender == _owner;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * > Note: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipTransferred(_owner, address(0));
57         _owner = address(0);
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public onlyOwner {
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a, "SafeMath: subtraction overflow");
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0, "SafeMath: division by zero");
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b != 0, "SafeMath: modulo by zero");
182         return a % b;
183     }
184 }
185 
186 
187 
188 
189 
190 
191 
192 /**
193  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
194  * the optional functions; to access them see `ERC20Detailed`.
195  */
196 interface IERC20 {
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `recipient`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a `Transfer` event.
213      */
214     function transfer(address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through `transferFrom`. This is
219      * zero by default.
220      *
221      * This value changes when `approve` or `transferFrom` are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * > Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an `Approval` event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a `Transfer` event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to `approve`. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 
268 
269 /**
270  * @dev Implementation of the `IERC20` interface.
271  *
272  * This implementation is agnostic to the way tokens are created. This means
273  * that a supply mechanism has to be added in a derived contract using `_mint`.
274  * For a generic mechanism see `ERC20Mintable`.
275  *
276  * *For a detailed writeup see our guide [How to implement supply
277  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
278  *
279  * We have followed general OpenZeppelin guidelines: functions revert instead
280  * of returning `false` on failure. This behavior is nonetheless conventional
281  * and does not conflict with the expectations of ERC20 applications.
282  *
283  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See `IERC20.approve`.
291  */
292 contract ERC20 is IERC20 {
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) private _balances;
296 
297     mapping (address => mapping (address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     /**
302      * @dev See `IERC20.totalSupply`.
303      */
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309      * @dev See `IERC20.balanceOf`.
310      */
311     function balanceOf(address account) public view returns (uint256) {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See `IERC20.transfer`.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount) public returns (bool) {
324         _transfer(msg.sender, recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See `IERC20.allowance`.
330      */
331     function allowance(address owner, address spender) public view returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See `IERC20.approve`.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function approve(address spender, uint256 value) public returns (bool) {
343         _approve(msg.sender, spender, value);
344         return true;
345     }
346 
347     /**
348      * @dev See `IERC20.transferFrom`.
349      *
350      * Emits an `Approval` event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of `ERC20`;
352      *
353      * Requirements:
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `value`.
356      * - the caller must have allowance for `sender`'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
360         _transfer(sender, recipient, amount);
361         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to `approve` that can be used as a mitigation for
369      * problems described in `IERC20.approve`.
370      *
371      * Emits an `Approval` event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
378         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to `approve` that can be used as a mitigation for
386      * problems described in `IERC20.approve`.
387      *
388      * Emits an `Approval` event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
397         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
398         return true;
399     }
400 
401     /**
402      * @dev Moves tokens `amount` from `sender` to `recipient`.
403      *
404      * This is internal function is equivalent to `transfer`, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a `Transfer` event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(address sender, address recipient, uint256 amount) internal {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _balances[sender] = _balances[sender].sub(amount);
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a `Transfer` event with `from` set to the zero address.
428      *
429      * Requirements
430      *
431      * - `to` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _totalSupply = _totalSupply.add(amount);
437         _balances[account] = _balances[account].add(amount);
438         emit Transfer(address(0), account, amount);
439     }
440 
441      /**
442      * @dev Destoys `amount` tokens from `account`, reducing the
443      * total supply.
444      *
445      * Emits a `Transfer` event with `to` set to the zero address.
446      *
447      * Requirements
448      *
449      * - `account` cannot be the zero address.
450      * - `account` must have at least `amount` tokens.
451      */
452     function _burn(address account, uint256 value) internal {
453         require(account != address(0), "ERC20: burn from the zero address");
454 
455         _totalSupply = _totalSupply.sub(value);
456         _balances[account] = _balances[account].sub(value);
457         emit Transfer(account, address(0), value);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
462      *
463      * This is internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an `Approval` event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(address owner, address spender, uint256 value) internal {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = value;
478         emit Approval(owner, spender, value);
479     }
480 
481     /**
482      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
483      * from the caller's allowance.
484      *
485      * See `_burn` and `_approve`.
486      */
487     function _burnFrom(address account, uint256 amount) internal {
488         _burn(account, amount);
489         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
490     }
491 }
492 
493 
494 /**
495  * @dev Extension of `ERC20` that allows token holders to destroy both their own
496  * tokens and those that they have an allowance for, in a way that can be
497  * recognized off-chain (via event analysis).
498  */
499 contract ERC20Burnable is ERC20 {
500     /**
501      * @dev Destoys `amount` tokens from the caller.
502      *
503      * See `ERC20._burn`.
504      */
505     function burn(uint256 amount) public {
506         _burn(msg.sender, amount);
507     }
508 
509     /**
510      * @dev See `ERC20._burnFrom`.
511      */
512     function burnFrom(address account, uint256 amount) public {
513         _burnFrom(account, amount);
514     }
515 }
516 
517 
518 /*@title ProjectToken
519 * @dev This contract contains the basic ERC20 mechanism for Project tokens.
520 * Also this will handle all profit distribution for the project.
521 * Please make sure to confirm the exact address of the project token before sending any ether.
522 */
523 
524 
525 contract ProjectTokenV2 is ERC20Burnable {
526     using SafeMath for uint256;
527 
528     struct Profit {
529         //amount of unclaimed profit an address had the last time
530         //`_profitAccounting` was called.
531         uint256 unclaimedAtLastAccounting;
532         //this contract's totalIncome the last time `_profitAccounting` was called
533         uint256 incomeAtLastAccounting;
534     }
535 
536     modifier onlyFactory(){
537         require(_factory == msg.sender, "Only token factory can set value");
538         _;
539     }
540 
541     mapping (address => Profit) private _profits;
542 
543     uint256 private _ethReleased;
544 
545     string private _name;
546 
547     string private _symbol;
548 
549     uint8 private _decimals;
550 
551     address private _sales;
552 
553     address private _vault;
554 
555     address payable _owner;
556 
557     address private _factory;
558 
559     event Claim(address indexed account, uint256 payout);
560 
561     constructor(
562         string memory name,
563         string memory symbol,
564         uint8 decimals,
565         uint256 totalSupply,
566         address payable owner,
567         address factory
568     )
569         public
570     {
571 
572         _name = name;
573         _symbol = symbol;
574         _decimals = decimals;
575         _owner = owner;
576         _factory = factory;
577         _mint(msg.sender, totalSupply * (10 ** uint256(_decimals)));
578     }
579 
580     /**
581      * @dev Fallback accepts ETH.
582      */
583     function () external payable {}
584 
585     function setSalesAddress(address sales) external onlyFactory {
586         require(sales != address(0),"Sales address can not be zero");
587         _sales = sales;
588     }
589 
590     function setVaultAddress(address vault) external onlyFactory {
591         require(vault != address(0),"Vault address can not be zero");
592         _vault = vault;
593     }
594 
595 
596     /*
597      * @return the name of the token.
598      */
599     function name() public view returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @return the symbol of the token.
605      */
606     function symbol() public view returns (string memory) {
607         return _symbol;
608     }
609 
610     /**
611      * @return the number of decimals of the token.
612      */
613     function decimals() public view returns (uint8) {
614         return _decimals;
615     }
616 
617     /**
618      * @dev Total amount of ETH this contract has ever received
619      */
620     function totalIncome() public view returns (uint256) {
621         return address(this).balance.add(_ethReleased);
622     }
623 
624     function getProjectOwner() public view returns (address payable) {
625         return _owner;
626     }
627 
628     /**
629      * @dev Gets the amount profit (ETH) a specified address can claim.
630      * @param account The address to query the profit balance of.
631      * @return A uint256 representing the amount of profit owed to the
632      * passed address.
633      */
634     function profitBalanceOf(address account) public view returns (uint256) {
635         return _profits[account].unclaimedAtLastAccounting.add(
636             _earnedSinceLastAccounting(account)
637         );
638     }
639 
640     /**
641      * @dev Allows profits to be claimed.
642      * @param account The address that will receive its profit.
643      */
644     function claimProfits(address payable account) public {
645         require(account != _sales, "Sales can't claim profits");
646 
647         uint256 payout = profitBalanceOf(account);
648         require(payout > 0, "No claimable profit!!");
649         _profits[account].unclaimedAtLastAccounting = 0;
650         _profits[account].incomeAtLastAccounting = totalIncome();
651         _ethReleased = _ethReleased.add(payout);
652         emit Claim(account, payout);
653         account.transfer(payout);
654     }
655 
656     /**
657      * @dev Gets the amount of ETH the contract has received since the last
658      * profit accounting for an address.
659      * @param account The address in question.
660      */
661     function _incomeSinceLastAccounting(address account)
662         internal
663         view
664         returns (uint256)
665     {
666         return totalIncome().sub(_profits[account].incomeAtLastAccounting);
667     }
668 
669     /**
670      * @dev Gets the amount of ETH an address has earned (as profits) since
671      * the last profit accounting for the address.
672      * @param account The address in question.
673      */
674     function _earnedSinceLastAccounting(address account)
675         internal
676         view
677         returns (uint256)
678     {
679         if (totalSupply() == 0){
680             return 0;
681         }
682 
683         return _incomeSinceLastAccounting(account)
684         .mul(balanceOf(account))
685         .div((totalSupply().sub(balanceOf(_sales))).sub(balanceOf(_vault)));
686     }
687 
688     /**
689      * @dev Updates the value `_profits[account].unclaimedAtLastAccounting`
690      * for a given account.
691      * Updates `_profits[account].incomeAtLastAccounting` to reflect the
692      * most recent `totalIncome()` of the contract.
693      * @param account The address for which profit accounting will be done.
694      */
695     function _profitAccounting(address account) internal {
696         _profits[account].unclaimedAtLastAccounting = _profits[account]
697             .unclaimedAtLastAccounting.add(_earnedSinceLastAccounting(account));
698         _profits[account].incomeAtLastAccounting = totalIncome();
699     }
700 
701     /**
702      * @dev Transfer token for a specified addresses.
703      * Performs profit accounting before moving tokens.
704      * @param sender The address to transfer from.
705      * @param receiver The address to transfer to.
706      * @param value The amount to be transferred.
707      */
708     function _transfer(
709         address sender,
710         address receiver,
711         uint256 value
712     )
713         internal
714     {
715 
716         //profit accounting
717         _profitAccounting(sender);
718         _profitAccounting(receiver);
719 
720         super._transfer(sender, receiver, value);
721     }
722 
723     /**
724      * @dev Internal function that mints an amount of the token and assigns it
725      * to an account. This encapsulates the modification of balances such that
726      * the proper events are emitted.
727      * Perfroms profit accouting before minting.
728      * @param account The account that will receive the created tokens.
729      * @param value The amount that will be created.
730      */
731     function _mint(address account, uint256 value) internal {
732 
733         _profitAccounting(account);
734 
735         super._mint(account, value);
736     }
737 
738     /**
739      * @dev Internal function that burns an amount of the token of a given
740      * account.
741      * Performs profit accounting
742      * @param account The account whose tokens will be burnt.
743      * @param value The amount that will be burnt.
744      */
745     function _burn(address account, uint256 value) internal {
746 
747         _profitAccounting(account);
748 
749         super._burn(account, value);
750     }
751 }