1 pragma solidity 0.5.16;
2 
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
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
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      *
130      * _Available since v2.4.0._
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         // Solidity only automatically asserts when dividing by 0
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      *
225      * _Available since v2.4.0._
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 contract ERC20 is Context, IERC20 {
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view returns (uint256) {
253         return _balances[account];
254     }
255 
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `recipient` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address recipient, uint256 amount) public returns (bool) {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender) public view returns (uint256) {
273         return _allowances[owner][spender];
274     }
275 
276     /**
277      * @dev See {IERC20-approve}.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20};
293      *
294      * Requirements:
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for `sender`'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
339         return true;
340     }
341 
342     /**
343      * @dev Moves tokens `amount` from `sender` to `recipient`.
344      *
345      * This is internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `sender` cannot be the zero address.
353      * - `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      */
356     function _transfer(address sender, address recipient, uint256 amount) internal {
357         require(sender != address(0), "ERC20: transfer from the zero address");
358         require(recipient != address(0), "ERC20: transfer to the zero address");
359 
360         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
361         _balances[recipient] = _balances[recipient].add(amount);
362         emit Transfer(sender, recipient, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements
371      *
372      * - `to` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _totalSupply = _totalSupply.add(amount);
378         _balances[account] = _balances[account].add(amount);
379         emit Transfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
397         _totalSupply = _totalSupply.sub(amount);
398         emit Transfer(account, address(0), amount);
399     }
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
403      *
404      * This is internal function is equivalent to `approve`, and can be used to
405      * e.g. set automatic allowances for certain subsystems, etc.
406      *
407      * Emits an {Approval} event.
408      *
409      * Requirements:
410      *
411      * - `owner` cannot be the zero address.
412      * - `spender` cannot be the zero address.
413      */
414     function _approve(address owner, address spender, uint256 amount) internal {
415         require(owner != address(0), "ERC20: approve from the zero address");
416         require(spender != address(0), "ERC20: approve to the zero address");
417 
418         _allowances[owner][spender] = amount;
419         emit Approval(owner, spender, amount);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
424      * from the caller's allowance.
425      *
426      * See {_burn} and {_approve}.
427      */
428     function _burnFrom(address account, uint256 amount) internal {
429         _burn(account, amount);
430         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
431     }
432 }
433 
434 contract ERC20Detailed is IERC20 {
435     string private _name;
436     string private _symbol;
437     uint8 private _decimals;
438 
439     /**
440      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
441      * these values are immutable: they can only be set once during
442      * construction.
443      */
444     constructor (string memory name, string memory symbol, uint8 decimals) public {
445         _name = name;
446         _symbol = symbol;
447         _decimals = decimals;
448     }
449 
450     /**
451      * @dev Returns the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @dev Returns the symbol of the token, usually a shorter version of the
459      * name.
460      */
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464 
465     /**
466      * @dev Returns the number of decimals used to get its user representation.
467      * For example, if `decimals` equals `2`, a balance of `505` tokens should
468      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
469      *
470      * Tokens usually opt for a value of 18, imitating the relationship between
471      * Ether and Wei.
472      *
473      * NOTE: This information is only used for _display_ purposes: it in
474      * no way affects any of the arithmetic of the contract, including
475      * {IERC20-balanceOf} and {IERC20-transfer}.
476      */
477     function decimals() public view returns (uint8) {
478         return _decimals;
479     }
480 }
481 
482 library SafeMathUint {
483     function toInt256Safe(uint256 a) internal pure returns (int256) {
484         int256 b = int256(a);
485         require(b >= 0);
486         return b;
487     }
488 }
489 
490 library SafeMathInt {
491     function mul(int256 a, int256 b) internal pure returns (int256) {
492         // Prevent overflow when multiplying INT256_MIN with -1
493         // https://github.com/RequestNetwork/requestNetwork/issues/43
494         require(!(a == - 2 ** 255 && b == - 1) && !(b == - 2 ** 255 && a == - 1));
495 
496         int256 c = a * b;
497         require((b == 0) || (c / b == a));
498         return c;
499     }
500 
501     function div(int256 a, int256 b) internal pure returns (int256) {
502         // Prevent overflow when dividing INT256_MIN by -1
503         // https://github.com/RequestNetwork/requestNetwork/issues/43
504         require(!(a == - 2 ** 255 && b == - 1) && (b > 0));
505 
506         return a / b;
507     }
508 
509     function sub(int256 a, int256 b) internal pure returns (int256) {
510         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
511 
512         return a - b;
513     }
514 
515     function add(int256 a, int256 b) internal pure returns (int256) {
516         int256 c = a + b;
517         require((b >= 0 && c >= a) || (b < 0 && c < a));
518         return c;
519     }
520 
521     function toUint256Safe(int256 a) internal pure returns (uint256) {
522         require(a >= 0);
523         return uint256(a);
524     }
525 }
526 
527 interface IFundsDistributionToken {
528     /**
529      * @dev Returns the total amount of funds a given address is able to withdraw currently.
530      * @param owner Address of FundsDistributionToken holder
531      * @return A uint256 representing the available funds for a given account
532      */
533     function withdrawableFundsOf(address owner) external view returns (uint256);
534 
535     /**
536      * @dev Withdraws all available funds for a FundsDistributionToken holder.
537      */
538     function withdrawFunds() external;
539 
540     /**
541      * @dev This event emits when new funds are distributed
542      * @param by the address of the sender who distributed funds
543      * @param fundsDistributed the amount of funds received for distribution
544      */
545     event FundsDistributed(address indexed by, uint256 fundsDistributed);
546 
547     /**
548      * @dev This event emits when distributed funds are withdrawn by a token holder.
549      * @param by the address of the receiver of funds
550      * @param fundsWithdrawn the amount of funds that were withdrawn
551      */
552     event FundsWithdrawn(address indexed by, uint256 fundsWithdrawn);
553 }
554 
555 contract FundsDistributionToken is ERC20Detailed, ERC20, IFundsDistributionToken {
556     using SafeMath for uint256;
557     using SafeMathUint for uint256;
558     using SafeMathInt for int256;
559 
560     // optimize, see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
561     uint256 constant internal pointsMultiplier = 2 ** 128;
562     uint256 internal pointsPerShare;
563 
564     mapping(address => int256) internal pointsCorrection;
565     mapping(address => uint256) internal withdrawnFunds;
566 
567     /**
568      * prev. distributeDividends
569      * @notice Distributes funds to token holders.
570      * @dev It reverts if the total supply of tokens is 0.
571      * It emits the `FundsDistributed` event if the amount of received ether is greater than 0.
572      * About undistributed funds:
573      *   In each distribution, there is a small amount of funds which does not get distributed,
574      *     which is `(msg.value * pointsMultiplier) % totalSupply()`.
575      *   With a well-chosen `pointsMultiplier`, the amount funds that are not getting distributed
576      *     in a distribution can be less than 1 (base unit).
577      *   We can actually keep track of the undistributed ether in a distribution
578      *     and try to distribute it in the next distribution ....... todo implement
579      */
580     function _distributeFunds(uint256 value) internal {
581         require(totalSupply() > 0, "FundsDistributionToken._distributeFunds: SUPPLY_IS_ZERO");
582 
583         if (value > 0) {
584             pointsPerShare = pointsPerShare.add(
585                 value.mul(pointsMultiplier) / totalSupply()
586             );
587             emit FundsDistributed(msg.sender, value);
588         }
589     }
590 
591     /**
592      * prev. withdrawDividend
593      * @notice Prepares funds withdrawal
594      * @dev It emits a `FundsWithdrawn` event if the amount of withdrawn ether is greater than 0.
595      */
596     function _prepareWithdraw() internal returns (uint256) {
597         uint256 _withdrawableDividend = withdrawableFundsOf(msg.sender);
598 
599         withdrawnFunds[msg.sender] = withdrawnFunds[msg.sender].add(_withdrawableDividend);
600 
601         emit FundsWithdrawn(msg.sender, _withdrawableDividend);
602 
603         return _withdrawableDividend;
604     }
605 
606     /**
607      * prev. withdrawableDividendOf
608      * @notice View the amount of funds that an address can withdraw.
609      * @param _owner The address of a token holder.
610      * @return The amount funds that `_owner` can withdraw.
611      */
612     function withdrawableFundsOf(address _owner) public view returns (uint256) {
613         return accumulativeFundsOf(_owner).sub(withdrawnFunds[_owner]);
614     }
615 
616     /**
617      * prev. withdrawnDividendOf
618      * @notice View the amount of funds that an address has withdrawn.
619      * @param _owner The address of a token holder.
620      * @return The amount of funds that `_owner` has withdrawn.
621      */
622     function withdrawnFundsOf(address _owner) external view returns (uint256) {
623         return withdrawnFunds[_owner];
624     }
625 
626     /**
627      * prev. accumulativeDividendOf
628      * @notice View the amount of funds that an address has earned in total.
629      * @dev accumulativeFundsOf(_owner) = withdrawableFundsOf(_owner) + withdrawnFundsOf(_owner)
630      * = (pointsPerShare * balanceOf(_owner) + pointsCorrection[_owner]) / pointsMultiplier
631      * @param _owner The address of a token holder.
632      * @return The amount of funds that `_owner` has earned in total.
633      */
634     function accumulativeFundsOf(address _owner) public view returns (uint256) {
635         return pointsPerShare.mul(balanceOf(_owner)).toInt256Safe()
636         .add(pointsCorrection[_owner]).toUint256Safe() / pointsMultiplier;
637     }
638 
639     /**
640      * @dev Internal function that transfer tokens from one address to another.
641      * Update pointsCorrection to keep funds unchanged.
642      * @param from The address to transfer from.
643      * @param to The address to transfer to.
644      * @param value The amount to be transferred.
645      */
646     function _transfer(address from, address to, uint256 value) internal {
647         super._transfer(from, to, value);
648 
649         int256 _magCorrection = pointsPerShare.mul(value).toInt256Safe();
650         pointsCorrection[from] = pointsCorrection[from].add(_magCorrection);
651         pointsCorrection[to] = pointsCorrection[to].sub(_magCorrection);
652     }
653 
654     /**
655      * @dev Internal function that mints tokens to an account.
656      * Update pointsCorrection to keep funds unchanged.
657      * @param account The account that will receive the created tokens.
658      * @param value The amount that will be created.
659      */
660     function _mint(address account, uint256 value) internal {
661         super._mint(account, value);
662 
663         pointsCorrection[account] = pointsCorrection[account]
664         .sub((pointsPerShare.mul(value)).toInt256Safe());
665     }
666 }
667 
668 contract J2TD is FundsDistributionToken {
669     using SafeMathUint for uint256;
670     using SafeMathInt for int256;
671 
672     // balance of fundsToken that the FundsDistributionToken currently holds
673     uint256 public fundsTokenBalance;
674 
675     constructor()public ERC20Detailed("J2TX Token Dividends", "J2TD", 18){
676         _mint(msg.sender, 100000000 * 10 ** uint256(18));
677     }
678 
679     /**
680      * @notice Withdraws all available funds for a token holder
681      */
682     function withdrawFunds() external {
683         uint256 withdrawableFunds = _prepareWithdraw();
684         address payable to = msg.sender;
685         to.transfer(withdrawableFunds);
686         _updateFundsTokenBalance();
687     }
688 
689     /**
690      * @dev Updates the current funds token balance
691      * and returns the difference of new and previous funds token balances
692      * @return A int256 representing the difference of the new and previous funds token balance
693      */
694     function _updateFundsTokenBalance() internal returns (int256) {
695         uint256 prevFundsTokenBalance = fundsTokenBalance;
696         fundsTokenBalance = (address(this).balance);
697         return int256(fundsTokenBalance).sub(int256(prevFundsTokenBalance));
698     }
699 
700     /**
701      * @notice Register a payment of funds in tokens. May be called directly after a deposit is made.
702      * @dev Calls _updateFundsTokenBalance(), whereby the contract computes the delta of the previous and the new
703      * funds token balance and increments the total received funds (cumulative) by delta by calling _registerFunds()
704      */
705     function updateFundsReceived() external {
706         int256 newFunds = _updateFundsTokenBalance();
707 
708         if (newFunds > 0) {
709             _distributeFunds(newFunds.toUint256Safe());
710         }
711     }
712 
713     /**
714      * @notice  j2tx
715      */
716     function getTechInfo(address owner) external view returns (
717         uint256 balance,
718         int256 correction,
719         uint256 withdrawn,
720         uint256 withdrawable
721     ){
722         balance = balanceOf(owner);
723         correction = pointsCorrection[owner];
724         withdrawn = withdrawnFunds[owner];
725         withdrawable = withdrawableFundsOf(owner);
726     }
727 
728     /**
729      * @notice Payable function, for receive funds.
730      */
731     function() external payable {}
732 }