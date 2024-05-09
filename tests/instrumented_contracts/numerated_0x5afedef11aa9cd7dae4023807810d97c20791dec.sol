1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File contracts/interfaces/ITokenHelper.sol
4 pragma solidity ^0.6.0;
5 
6 interface ITokenHelper {
7     function transferHelper(address from, address to, uint256 amount) external;
8 }
9 
10 
11 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
12 pragma solidity >=0.6.0 <0.8.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 
36 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
37 pragma solidity >=0.6.0 <0.8.0;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
115 pragma solidity >=0.6.0 <0.8.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         uint256 c = a + b;
138         if (c < a) return (false, 0);
139         return (true, c);
140     }
141 
142     /**
143      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         if (b > a) return (false, 0);
149         return (true, a - b);
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) return (true, 0);
162         uint256 c = a * b;
163         if (c / a != b) return (false, 0);
164         return (true, c);
165     }
166 
167     /**
168      * @dev Returns the division of two unsigned integers, with a division by zero flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         if (b == 0) return (false, 0);
174         return (true, a / b);
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         if (b == 0) return (false, 0);
184         return (true, a % b);
185     }
186 
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b <= a, "SafeMath: subtraction overflow");
215         return a - b;
216     }
217 
218     /**
219      * @dev Returns the multiplication of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `*` operator.
223      *
224      * Requirements:
225      *
226      * - Multiplication cannot overflow.
227      */
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         if (a == 0) return 0;
230         uint256 c = a * b;
231         require(c / a == b, "SafeMath: multiplication overflow");
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: division by zero");
249         return a / b;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * reverting when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         require(b > 0, "SafeMath: modulo by zero");
266         return a % b;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
271      * overflow (when the result is negative).
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {trySub}.
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b <= a, errorMessage);
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * CAUTION: This function is deprecated because it requires allocating memory for the error
292      * message unnecessarily. For custom revert reasons use {tryDiv}.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         require(b > 0, errorMessage);
304         return a / b;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * reverting with custom message when dividing by zero.
310      *
311      * CAUTION: This function is deprecated because it requires allocating memory for the error
312      * message unnecessarily. For custom revert reasons use {tryMod}.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         require(b > 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 
329 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
330 pragma solidity >=0.6.0 <0.8.0;
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20PresetMinterPauser}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     string private _name;
366     string private _symbol;
367     uint8 private _decimals;
368 
369     /**
370      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
371      * a default value of 18.
372      *
373      * To select a different value for {decimals}, use {_setupDecimals}.
374      *
375      * All three of these values are immutable: they can only be set once during
376      * construction.
377      */
378     constructor (string memory name_, string memory symbol_) public {
379         _name = name_;
380         _symbol = symbol_;
381         _decimals = 18;
382     }
383 
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() public view virtual returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev Returns the symbol of the token, usually a shorter version of the
393      * name.
394      */
395     function symbol() public view virtual returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400      * @dev Returns the number of decimals used to get its user representation.
401      * For example, if `decimals` equals `2`, a balance of `505` tokens should
402      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
403      *
404      * Tokens usually opt for a value of 18, imitating the relationship between
405      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
406      * called.
407      *
408      * NOTE: This information is only used for _display_ purposes: it in
409      * no way affects any of the arithmetic of the contract, including
410      * {IERC20-balanceOf} and {IERC20-transfer}.
411      */
412     function decimals() public view virtual returns (uint8) {
413         return _decimals;
414     }
415 
416     /**
417      * @dev See {IERC20-totalSupply}.
418      */
419     function totalSupply() public view virtual override returns (uint256) {
420         return _totalSupply;
421     }
422 
423     /**
424      * @dev See {IERC20-balanceOf}.
425      */
426     function balanceOf(address account) public view virtual override returns (uint256) {
427         return _balances[account];
428     }
429 
430     /**
431      * @dev See {IERC20-transfer}.
432      *
433      * Requirements:
434      *
435      * - `recipient` cannot be the zero address.
436      * - the caller must have a balance of at least `amount`.
437      */
438     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
439         _transfer(_msgSender(), recipient, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-allowance}.
445      */
446     function allowance(address owner, address spender) public view virtual override returns (uint256) {
447         return _allowances[owner][spender];
448     }
449 
450     /**
451      * @dev See {IERC20-approve}.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      */
457     function approve(address spender, uint256 amount) public virtual override returns (bool) {
458         _approve(_msgSender(), spender, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-transferFrom}.
464      *
465      * Emits an {Approval} event indicating the updated allowance. This is not
466      * required by the EIP. See the note at the beginning of {ERC20}.
467      *
468      * Requirements:
469      *
470      * - `sender` and `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      * - the caller must have allowance for ``sender``'s tokens of at least
473      * `amount`.
474      */
475     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
476         _transfer(sender, recipient, amount);
477         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
478         return true;
479     }
480 
481     /**
482      * @dev Atomically increases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      */
493     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
495         return true;
496     }
497 
498     /**
499      * @dev Atomically decreases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      * - `spender` must have allowance for the caller of at least
510      * `subtractedValue`.
511      */
512     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
514         return true;
515     }
516 
517     /**
518      * @dev Moves tokens `amount` from `sender` to `recipient`.
519      *
520      * This is internal function is equivalent to {transfer}, and can be used to
521      * e.g. implement automatic token fees, slashing mechanisms, etc.
522      *
523      * Emits a {Transfer} event.
524      *
525      * Requirements:
526      *
527      * - `sender` cannot be the zero address.
528      * - `recipient` cannot be the zero address.
529      * - `sender` must have a balance of at least `amount`.
530      */
531     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
532         require(sender != address(0), "ERC20: transfer from the zero address");
533         require(recipient != address(0), "ERC20: transfer to the zero address");
534 
535         _beforeTokenTransfer(sender, recipient, amount);
536 
537         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
538         _balances[recipient] = _balances[recipient].add(amount);
539         emit Transfer(sender, recipient, amount);
540     }
541 
542     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
543      * the total supply.
544      *
545      * Emits a {Transfer} event with `from` set to the zero address.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      */
551     function _mint(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: mint to the zero address");
553 
554         _beforeTokenTransfer(address(0), account, amount);
555 
556         _totalSupply = _totalSupply.add(amount);
557         _balances[account] = _balances[account].add(amount);
558         emit Transfer(address(0), account, amount);
559     }
560 
561     /**
562      * @dev Destroys `amount` tokens from `account`, reducing the
563      * total supply.
564      *
565      * Emits a {Transfer} event with `to` set to the zero address.
566      *
567      * Requirements:
568      *
569      * - `account` cannot be the zero address.
570      * - `account` must have at least `amount` tokens.
571      */
572     function _burn(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: burn from the zero address");
574 
575         _beforeTokenTransfer(account, address(0), amount);
576 
577         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
578         _totalSupply = _totalSupply.sub(amount);
579         emit Transfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
584      *
585      * This internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(address owner, address spender, uint256 amount) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Sets {decimals} to a value other than the default one of 18.
605      *
606      * WARNING: This function should only be called from the constructor. Most
607      * applications that interact with token contracts will not expect
608      * {decimals} to ever change, and may work incorrectly if it does.
609      */
610     function _setupDecimals(uint8 decimals_) internal virtual {
611         _decimals = decimals_;
612     }
613 
614     /**
615      * @dev Hook that is called before any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * will be to transferred to `to`.
622      * - when `from` is zero, `amount` tokens will be minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
629 }
630 
631 
632 // File contracts/vARMOR.sol
633 
634 // SPDX-License-Identifier: (c) Armor.Fi DAO, 2021
635 
636 pragma solidity 0.6.12;
637 
638 contract vARMOR is ERC20("Voting Armor Token", "vARMOR") {
639     using SafeMath for uint256;
640     IERC20 public immutable armor;
641     address public governance;
642     uint48 public withdrawDelay;
643     uint256 public pending;
644     address[] public tokenHelpers;
645     mapping (address => WithdrawRequest) public withdrawRequests;
646 
647     struct WithdrawRequest {
648         uint208 amount;
649         uint48 time;
650     }
651 
652     constructor(address _armor, address _gov) public {
653         armor = IERC20(_armor);
654         governance = _gov;
655     }
656 
657     function addTokenHelper(address _helper) external {
658         require(msg.sender == governance, "!gov");
659         tokenHelpers.push(_helper);
660     }
661 
662     function removeTokenHelper(uint256 _idx) external {
663         require(msg.sender == governance, "!gov");
664         tokenHelpers[_idx] = tokenHelpers[tokenHelpers.length - 1];
665         tokenHelpers.pop();
666     }
667 
668     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
669         _moveDelegates(_delegates[from], _delegates[to], amount);
670 
671         for(uint256 i = 0; i<tokenHelpers.length; i++){
672             ITokenHelper(tokenHelpers[i]).transferHelper(from, to, amount);
673         }
674     }
675 
676     function transferGov(address _newGov) external {
677         require(msg.sender == governance, "!gov");
678         governance = _newGov;
679     }
680     
681     function changeDelay(uint48 _newDelay) external {
682         require(msg.sender == governance, "!gov");
683         withdrawDelay = _newDelay;
684     }
685     
686     /// deposit and withdraw functions
687     function deposit(uint256 _amount) external {
688         uint256 varmor = armorToVArmor(_amount);
689         _mint(msg.sender, varmor);
690         _moveDelegates(address(0), _delegates[msg.sender], varmor);
691         // checkpoint for totalSupply
692         _writeCheckpointTotal(totalSupply());
693         armor.transferFrom(msg.sender, address(this), _amount);
694     }
695 
696     /// withdraw share
697     function requestWithdrawal(uint256 _amount) external {
698         _burn(msg.sender, _amount);
699         _moveDelegates(_delegates[msg.sender], address(0), _amount);
700         // checkpoint for totalSupply
701         _writeCheckpointTotal(totalSupply());
702         pending = pending.add(_amount);
703         withdrawRequests[msg.sender] = WithdrawRequest(withdrawRequests[msg.sender].amount + uint208(_amount), uint48(block.timestamp));
704     }
705     
706     /// withdraw share
707     function finalizeWithdrawal() external {
708         WithdrawRequest memory request = withdrawRequests[msg.sender];
709         require(request.time > 0 && block.timestamp >= request.time + withdrawDelay, "Withdrawal may not be completed yet.");
710         delete withdrawRequests[msg.sender];
711         uint256 armorAmount = vArmorToArmor(request.amount);
712         pending = pending.sub(uint256(request.amount));
713         armor.transfer(msg.sender, armorAmount);
714     }
715 
716     function armorToVArmor(uint256 _armor) public view returns(uint256) {
717         uint256 _pending = pending;
718         if(totalSupply().add(_pending) == 0){
719             return _armor;
720         }
721         return _armor.mul( totalSupply().add(_pending) ).div( armor.balanceOf( address(this) ) );
722     }
723 
724     function vArmorToArmor(uint256 _varmor) public view returns(uint256) {
725         if(armor.balanceOf( address(this) ) == 0){
726             return 0;
727         }
728         return _varmor.mul( armor.balanceOf( address(this) ) ).div( totalSupply().add(pending) );
729     }
730 
731     /// @notice A record of each accounts delegate
732     mapping (address => address) internal _delegates;
733 
734     /// @notice A checkpoint for marking number of votes from a given block
735     struct Checkpoint {
736         uint32 fromBlock;
737         uint256 votes;
738     }
739 
740     /// @notice A record of votes checkpoints for each account, by index
741     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
742 
743     /// @notice The number of checkpoints for each account
744     mapping (address => uint32) public numCheckpoints;
745 
746 
747     // totalSupply checkpoint
748     mapping (uint32 => Checkpoint) public checkpointsTotal;
749 
750     uint32 public numCheckpointsTotal;
751 
752     /// @notice The EIP-712 typehash for the contract's domain
753     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
754 
755     /// @notice The EIP-712 typehash for the delegation struct used by the contract
756     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
757 
758     /// @notice A record of states for signing / validating signatures
759     mapping (address => uint) public nonces;
760 
761     /// @notice An event thats emitted when an account changes its delegate
762     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
763 
764     /// @notice An event thats emitted when a delegate account's vote balance changes
765     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
766 
767     /**
768      * @notice Delegate votes from `msg.sender` to `delegatee`
769      * @param delegator The address to get delegatee for
770      */
771     function delegates(address delegator)
772         external
773         view
774         returns (address)
775     {
776         return _delegates[delegator];
777     }
778 
779    /**
780     * @notice Delegate votes from `msg.sender` to `delegatee`
781     * @param delegatee The address to delegate votes to
782     */
783     function delegate(address delegatee) external {
784         return _delegate(msg.sender, delegatee);
785     }
786 
787     /**
788      * @notice Delegates votes from signatory to `delegatee`
789      * @param delegatee The address to delegate votes to
790      * @param nonce The contract state required to match the signature
791      * @param expiry The time at which to expire the signature
792      * @param v The recovery byte of the signature
793      * @param r Half of the ECDSA signature pair
794      * @param s Half of the ECDSA signature pair
795      */
796     function delegateBySig(
797         address delegatee,
798         uint nonce,
799         uint expiry,
800         uint8 v,
801         bytes32 r,
802         bytes32 s
803     )
804         external
805     {
806         bytes32 domainSeparator = keccak256(
807             abi.encode(
808                 DOMAIN_TYPEHASH,
809                 keccak256(bytes(name())),
810                 getChainId(),
811                 address(this)
812             )
813         );
814 
815         bytes32 structHash = keccak256(
816             abi.encode(
817                 DELEGATION_TYPEHASH,
818                 delegatee,
819                 nonce,
820                 expiry
821             )
822         );
823 
824         bytes32 digest = keccak256(
825             abi.encodePacked(
826                 "\x19\x01",
827                 domainSeparator,
828                 structHash
829             )
830         );
831 
832         address signatory = ecrecover(digest, v, r, s);
833         require(signatory != address(0), "vARMOR::delegateBySig: invalid signature");
834         require(nonce == nonces[signatory]++, "vARMOR::delegateBySig: invalid nonce");
835         require(now <= expiry, "vARMOR::delegateBySig: signature expired");
836         return _delegate(signatory, delegatee);
837     }
838 
839     /**
840      * @notice Gets the current votes balance for `account`
841      * @param account The address to get votes balance
842      * @return The number of current votes for `account`
843      */
844     function getCurrentVotes(address account)
845         external
846         view
847         returns (uint256)
848     {
849         uint32 nCheckpoints = numCheckpoints[account];
850         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
851     }
852 
853     /**
854      * @notice Determine the prior number of votes for an account as of a block number
855      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
856      * @param account The address of the account to check
857      * @param blockNumber The block number to get the vote balance at
858      * @return The number of votes the account had as of the given block
859      */
860     function getPriorVotes(address account, uint blockNumber)
861         external
862         view
863         returns (uint256)
864     {
865         require(blockNumber < block.number, "vARMOR::getPriorVotes: not yet determined");
866 
867         uint32 nCheckpoints = numCheckpoints[account];
868         if (nCheckpoints == 0) {
869             return 0;
870         }
871 
872         // First check most recent balance
873         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
874             return checkpoints[account][nCheckpoints - 1].votes;
875         }
876 
877         // Next check implicit zero balance
878         if (checkpoints[account][0].fromBlock > blockNumber) {
879             return 0;
880         }
881 
882         uint32 lower = 0;
883         uint32 upper = nCheckpoints - 1;
884         while (upper > lower) {
885             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
886             Checkpoint memory cp = checkpoints[account][center];
887             if (cp.fromBlock == blockNumber) {
888                 return cp.votes;
889             } else if (cp.fromBlock < blockNumber) {
890                 lower = center;
891             } else {
892                 upper = center - 1;
893             }
894         }
895         return checkpoints[account][lower].votes;
896     }
897     
898     function getPriorTotalVotes(uint blockNumber)
899         external
900         view
901         returns (uint256)
902     {
903         require(blockNumber < block.number, "vARMOR::getPriorTotalVotes: not yet determined");
904 
905         uint32 nCheckpoints = numCheckpointsTotal;
906         
907         // First check most recent balance
908         if (checkpointsTotal[nCheckpoints - 1].fromBlock <= blockNumber) {
909             return checkpointsTotal[nCheckpoints - 1].votes;
910         }
911 
912         // Next check implicit zero balance
913         if (checkpointsTotal[0].fromBlock > blockNumber) {
914             return 0;
915         }
916 
917         uint32 lower = 0;
918         uint32 upper = nCheckpoints - 1;
919         while (upper > lower) {
920             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
921             Checkpoint memory cp = checkpointsTotal[center];
922             if (cp.fromBlock == blockNumber) {
923                 return cp.votes;
924             } else if (cp.fromBlock < blockNumber) {
925                 lower = center;
926             } else {
927                 upper = center - 1;
928             }
929         }
930         return checkpointsTotal[lower].votes;
931     }
932 
933     function _delegate(address delegator, address delegatee)
934         internal
935     {
936         address currentDelegate = _delegates[delegator];
937         uint256 delegatorBalance = balanceOf(delegator);
938         _delegates[delegator] = delegatee;
939 
940         emit DelegateChanged(delegator, currentDelegate, delegatee);
941 
942         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
943     }
944 
945     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
946         if (srcRep != dstRep && amount > 0) {
947             if (srcRep != address(0)) {
948                 // decrease old representative
949                 uint32 srcRepNum = numCheckpoints[srcRep];
950                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
951                 uint256 srcRepNew = srcRepOld.sub(amount);
952                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
953             } 
954             if (dstRep != address(0)) {
955                 // increase new representative
956                 uint32 dstRepNum = numCheckpoints[dstRep];
957                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
958                 uint256 dstRepNew = dstRepOld.add(amount);
959                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
960             }
961         }
962     }
963 
964     function _writeCheckpointTotal(
965         uint256 newTotal 
966     )
967         internal
968     {
969         uint32 nCheckpoints = numCheckpointsTotal;
970         uint32 blockNumber = safe32(block.number, "vARMOR::_writeCheckpoint: block number exceeds 32 bits");
971 
972         if (nCheckpoints > 0 && checkpointsTotal[nCheckpoints - 1].fromBlock == blockNumber) {
973             checkpointsTotal[nCheckpoints - 1].votes = newTotal;
974         } else {
975             checkpointsTotal[nCheckpoints] = Checkpoint(blockNumber, newTotal);
976             numCheckpointsTotal = nCheckpoints + 1;
977         }
978     }
979 
980     function _writeCheckpoint(
981         address delegatee,
982         uint32 nCheckpoints,
983         uint256 oldVotes,
984         uint256 newVotes
985     )
986         internal
987     {
988         uint32 blockNumber = safe32(block.number, "vARMOR::_writeCheckpoint: block number exceeds 32 bits");
989 
990         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
991             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
992         } else {
993             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
994             numCheckpoints[delegatee] = nCheckpoints + 1;
995         }
996 
997         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
998     }
999 
1000     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1001         require(n < 2**32, errorMessage);
1002         return uint32(n);
1003     }
1004 
1005     function getChainId() internal pure returns (uint) {
1006         uint256 chainId;
1007         assembly { chainId := chainid() }
1008         return chainId;
1009     }
1010 }