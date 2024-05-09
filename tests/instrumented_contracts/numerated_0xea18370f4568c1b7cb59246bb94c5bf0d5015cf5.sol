1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns (string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns (string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns (uint8);
107 }
108 
109 /// @title Dividend-Paying Token Optional Interface
110 /// @author Roger Wu (https://github.com/roger-wu)
111 /// @dev OPTIONAL functions for a dividend-paying token contract.
112 interface DividendPayingTokenOptionalInterface {
113   /// @notice View the amount of dividend in wei that an address can withdraw.
114   /// @param _owner The address of a token holder.
115   /// @return The amount of dividend in wei that `_owner` can withdraw.
116   function withdrawableDividendOf(address _owner) external view returns(uint256);
117 
118   /// @notice View the amount of dividend in wei that an address has withdrawn.
119   /// @param _owner The address of a token holder.
120   /// @return The amount of dividend in wei that `_owner` has withdrawn.
121   function withdrawnDividendOf(address _owner) external view returns(uint256);
122 
123   /// @notice View the amount of dividend in wei that an address has earned in total.
124   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
125   /// @param _owner The address of a token holder.
126   /// @return The amount of dividend in wei that `_owner` has earned in total.
127   function accumulativeDividendOf(address _owner) external view returns(uint256);
128 }
129 
130 /// @title Dividend-Paying Token Interface
131 /// @author Roger Wu (https://github.com/roger-wu)
132 /// @dev An interface for a dividend-paying token contract.
133 interface DividendPayingTokenInterface {
134   /// @notice View the amount of dividend in wei that an address can withdraw.
135   /// @param _owner The address of a token holder.
136   /// @return The amount of dividend in wei that `_owner` can withdraw.
137   function dividendOf(address _owner) external view returns(uint256);
138 
139   /// @notice Distributes ether to token holders as dividends.
140   /// @dev SHOULD distribute the paid ether to token holders as dividends.
141   ///  SHOULD NOT directly transfer ether to token holders in this function.
142   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
143   function distributeDividends() external payable;
144 
145   /// @notice Withdraws the ether distributed to the sender.
146   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
147   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
148   function withdrawDividend() external;
149 
150   /// @dev This event MUST emit when ether is distributed to token holders.
151   /// @param from The address which sends ether to this contract.
152   /// @param weiAmount The amount of distributed ether in wei.
153   event DividendsDistributed(
154     address indexed from,
155     uint256 weiAmount
156   );
157 
158   /// @dev This event MUST emit when an address withdraws their dividend.
159   /// @param to The address which withdraws ether from this contract.
160   /// @param weiAmount The amount of withdrawn ether in wei.
161   event DividendWithdrawn(
162     address indexed to,
163     uint256 weiAmount
164   );
165 }
166 
167 /**
168  * @title SafeMathInt
169  * @dev Math operations for int256 with overflow safety checks.
170  */
171 library SafeMathInt {
172     int256 private constant MIN_INT256 = int256(1) << 255;
173     int256 private constant MAX_INT256 = ~(int256(1) << 255);
174 
175     /**
176      * @dev Multiplies two int256 variables and fails on overflow.
177      */
178     function mul(int256 a, int256 b) internal pure returns (int256) {
179         int256 c = a * b;
180 
181         // Detect overflow when multiplying MIN_INT256 with -1
182         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
183         require((b == 0) || (c / b == a));
184         return c;
185     }
186 
187     /**
188      * @dev Division of two int256 variables and fails on overflow.
189      */
190     function div(int256 a, int256 b) internal pure returns (int256) {
191         // Prevent overflow when dividing MIN_INT256 by -1
192         require(b != -1 || a != MIN_INT256);
193 
194         // Solidity already throws when dividing by 0.
195         return a / b;
196     }
197 
198     /**
199      * @dev Subtracts two int256 variables and fails on overflow.
200      */
201     function sub(int256 a, int256 b) internal pure returns (int256) {
202         int256 c = a - b;
203         require((b >= 0 && c <= a) || (b < 0 && c > a));
204         return c;
205     }
206 
207     /**
208      * @dev Adds two int256 variables and fails on overflow.
209      */
210     function add(int256 a, int256 b) internal pure returns (int256) {
211         int256 c = a + b;
212         require((b >= 0 && c >= a) || (b < 0 && c < a));
213         return c;
214     }
215 
216     /**
217      * @dev Converts to absolute value, and fails on overflow.
218      */
219     function abs(int256 a) internal pure returns (int256) {
220         require(a != MIN_INT256);
221         return a < 0 ? -a : a;
222     }
223 
224 
225     function toUint256Safe(int256 a) internal pure returns (uint256) {
226         require(a >= 0);
227         return uint256(a);
228     }
229 }
230 
231 library SafeMathUint {
232   function toInt256Safe(uint256 a) internal pure returns (int256) {
233     int256 b = int256(a);
234     require(b >= 0);
235     return b;
236   }
237 }
238 
239 library SafeMath {
240     /**
241      * @dev Returns the addition of two unsigned integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `+` operator.
245      *
246      * Requirements:
247      *
248      * - Addition cannot overflow.
249      */
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting on
259      * overflow (when the result is negative).
260      *
261      * Counterpart to Solidity's `-` operator.
262      *
263      * Requirements:
264      *
265      * - Subtraction cannot overflow.
266      */
267     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268         return sub(a, b, "SafeMath: subtraction overflow");
269     }
270 
271     /**
272      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
273      * overflow (when the result is negative).
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      *
279      * - Subtraction cannot overflow.
280      */
281     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b <= a, errorMessage);
283         uint256 c = a - b;
284 
285         return c;
286     }
287 
288     /**
289      * @dev Returns the multiplication of two unsigned integers, reverting on
290      * overflow.
291      *
292      * Counterpart to Solidity's `*` operator.
293      *
294      * Requirements:
295      *
296      * - Multiplication cannot overflow.
297      */
298     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
299         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
300         // benefit is lost if 'b' is also tested.
301         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
302         if (a == 0) {
303             return 0;
304         }
305 
306         uint256 c = a * b;
307         require(c / a == b, "SafeMath: multiplication overflow");
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers. Reverts on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         return div(a, b, "SafeMath: division by zero");
326     }
327 
328     /**
329      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
330      * division by zero. The result is rounded towards zero.
331      *
332      * Counterpart to Solidity's `/` operator. Note: this function uses a
333      * `revert` opcode (which leaves remaining gas untouched) while Solidity
334      * uses an invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b > 0, errorMessage);
342         uint256 c = a / b;
343         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
344 
345         return c;
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
350      * Reverts when dividing by zero.
351      *
352      * Counterpart to Solidity's `%` operator. This function uses a `revert`
353      * opcode (which leaves remaining gas untouched) while Solidity uses an
354      * invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
361         return mod(a, b, "SafeMath: modulo by zero");
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * Reverts with custom message when dividing by zero.
367      *
368      * Counterpart to Solidity's `%` operator. This function uses a `revert`
369      * opcode (which leaves remaining gas untouched) while Solidity uses an
370      * invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
377         require(b != 0, errorMessage);
378         return a % b;
379     }
380 }
381 
382 /**
383  * @dev Implementation of the {IERC20} interface.
384  *
385  * This implementation is agnostic to the way tokens are created. This means
386  * that a supply mechanism has to be added in a derived contract using {_mint}.
387  * For a generic mechanism see {ERC20PresetMinterPauser}.
388  *
389  * TIP: For a detailed writeup see our guide
390  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
391  * to implement supply mechanisms].
392  *
393  * We have followed general OpenZeppelin guidelines: functions revert instead
394  * of returning `false` on failure. This behavior is nonetheless conventional
395  * and does not conflict with the expectations of ERC20 applications.
396  *
397  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
398  * This allows applications to reconstruct the allowance for all accounts just
399  * by listening to said events. Other implementations of the EIP may not emit
400  * these events, as it isn't required by the specification.
401  *
402  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
403  * functions have been added to mitigate the well-known issues around setting
404  * allowances. See {IERC20-approve}.
405  */
406  
407  contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor () public {
416         address msgSender = _msgSender();
417         _owner = msgSender;
418         emit OwnershipTransferred(address(0), _owner);
419     }
420 
421     /**
422      * @dev Returns the address of the current owner.
423      */
424     function owner() public view returns (address) {
425         return _owner;
426     }
427 
428     /**
429      * @dev Throws if called by any account other than the owner.
430      */
431     modifier onlyOwner() {
432         require(_owner == _msgSender(), "Ownable: caller is not the owner");
433         _;
434     }
435 
436     /**
437      * @dev Leaves the contract without owner. It will not be possible to call
438      * `onlyOwner` functions anymore. Can only be called by the current owner.
439      *
440      * NOTE: Renouncing ownership will leave the contract without an owner,
441      * thereby removing any functionality that is only available to the owner.
442      */
443     function renounceOwnership() public virtual onlyOwner {
444         emit OwnershipTransferred(_owner, address(0));
445         _owner = address(0);
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Can only be called by the current owner.
451      */
452     function transferOwnership(address newOwner) public virtual onlyOwner {
453         require(newOwner != address(0), "Ownable: new owner is the zero address");
454         emit OwnershipTransferred(_owner, newOwner);
455         _owner = newOwner;
456     }
457 }
458  
459 contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {
460     using SafeMath for uint256;
461 
462     mapping(address => uint256) private _balances;
463 
464     mapping(address => mapping(address => uint256)) private _allowances;
465     
466 
467     uint256 private _totalSupply;
468 
469     string private _name;
470     string private _symbol;
471 
472     
473     
474 
475     /**
476      * @dev Sets the values for {name} and {symbol}.
477      *
478      * The default value of {decimals} is 18. To select a different value for
479      * {decimals} you should overload it.
480      *
481      * All two of these values are immutable: they can only be set once during
482      * construction.
483      */
484     constructor(string memory name_, string memory symbol_) public {
485         _name = name_;
486         _symbol = symbol_;
487     }
488 
489     /**
490      * @dev Returns the name of the token.
491      */
492     function name() public view virtual override returns (string memory) {
493         return _name;
494     }
495 
496     /**
497      * @dev Returns the symbol of the token, usually a shorter version of the
498      * name.
499      */
500     function symbol() public view virtual override returns (string memory) {
501         return _symbol;
502     }
503 
504     /**
505      * @dev Returns the number of decimals used to get its user representation.
506      * For example, if `decimals` equals `2`, a balance of `505` tokens should
507      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
508      *
509      * Tokens usually opt for a value of 18, imitating the relationship between
510      * Ether and Wei. This is the value {ERC20} uses, unless this function is
511      * overridden;
512      *
513      * 
514      * 
515      * NOTE: This information is only used for _display_ purposes: it in
516      * no way affects any of the arithmetic of the contract, including
517      * {IERC20-balanceOf} and {IERC20-transfer}.
518      */
519     function decimals() public view virtual override returns (uint8) {
520         return 18;
521     }
522 
523     /**
524      * @dev See {IERC20-totalSupply}.
525      */
526     function totalSupply() public view virtual override returns (uint256) {
527         return _totalSupply;
528     }
529 
530     /**
531      * @dev See {IERC20-balanceOf}.
532      */
533     function balanceOf(address account) public view virtual override returns (uint256) {
534         return _balances[account];
535     }
536 
537     /**
538      * @dev See {IERC20-transfer}.
539      *
540      * Requirements:
541      *
542      * - `recipient` cannot be the zero address.
543      * - the caller must have a balance of at least `amount`.
544      */
545      
546      
547      
548     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
549         _transfer(_msgSender(), recipient, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-allowance}.
555      */
556     function allowance(address owner, address spender) public view virtual override returns (uint256) {
557         return _allowances[owner][spender];
558     }
559 
560     /**
561      * @dev See {IERC20-approve}.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      */
567     function approve(address spender, uint256 amount) public virtual override returns (bool) {
568         _approve(_msgSender(), spender, amount);
569         return true;
570     }
571     
572     
573 
574     /**
575      * @dev See {IERC20-transferFrom}.
576      *
577      * Emits an {Approval} event indicating the updated allowance. This is not
578      * required by the EIP. See the note at the beginning of {ERC20}.
579      *
580      * Requirements:
581      *
582      * - `sender` and `recipient` cannot be the zero address.
583      * - `sender` must have a balance of at least `amount`.
584      * - the caller must have allowance for ``sender``'s tokens of at least
585      * `amount`.
586      */
587     function transferFrom(
588         address sender,
589         address recipient,
590         uint256 amount
591     ) public virtual override returns (bool) {
592         _transfer(sender, recipient, amount);
593         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
594         return true;
595     }
596     
597     
598    
599 
600     /**
601      * @dev Atomically increases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      */
612     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
613         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
614         return true;
615     }
616 
617     /**
618      * @dev Atomically decreases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      * - `spender` must have allowance for the caller of at least
629      * `subtractedValue`.
630      */
631     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
633         return true;
634     }
635     
636 
637     /**
638      * @dev Moves tokens `amount` from `sender` to `recipient`.
639      *
640      * This is internal function is equivalent to {transfer}, and can be used to
641      * e.g. implement automatic token fees, slashing mechanisms, etc.
642      *
643      * Emits a {Transfer} event.
644      *
645      * Requirements:
646      *
647      * - `sender` cannot be the zero address.
648      * - `recipient` cannot be the zero address.
649      * - `sender` must have a balance of at least `amount`.
650      */
651     function _transfer(
652         address sender,
653         address recipient,
654         uint256 amount
655     ) internal virtual {
656         require(sender != address(0), "ERC20: transfer from the zero address");
657         require(recipient != address(0), "ERC20: transfer to the zero address");
658 
659         _beforeTokenTransfer(sender, recipient, amount);
660 
661         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
662         _balances[recipient] = _balances[recipient].add(amount);
663         
664         emit Transfer(sender, recipient, amount);
665     }
666 
667     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
668      * the total supply.
669      *
670      * Emits a {Transfer} event with `from` set to the zero address.
671      *
672      * Requirements:
673      *
674      * - `account` cannot be the zero address.
675      */
676     function _mint(address account, uint256 amount) internal virtual {
677         require(account != address(0), "ERC20: mint to the zero address");
678 
679         _beforeTokenTransfer(address(0), account, amount);
680 
681         _totalSupply = _totalSupply.add(amount);
682         _balances[account] = _balances[account].add(amount);
683         emit Transfer(address(0), account, amount);
684     }
685 
686     /**
687      * @dev Destroys `amount` tokens from `account`, reducing the
688      * total supply.
689      *
690      * Emits a {Transfer} event with `to` set to the zero address.
691      *
692      * Requirements:
693      *
694      * - `account` cannot be the zero address.
695      * - `account` must have at least `amount` tokens.
696      */
697     function _burn(address account, uint256 amount) internal virtual {
698         require(account != address(0), "ERC20: burn from the zero address");
699 
700         _beforeTokenTransfer(account, address(0), amount);
701 
702         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
703         _totalSupply = _totalSupply.sub(amount);
704         emit Transfer(account, address(0), amount);
705     }
706 
707     /**
708      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
709      *
710      * This internal function is equivalent to `approve`, and can be used to
711      * e.g. set automatic allowances for certain subsystems, etc.
712      *
713      * Emits an {Approval} event.
714      *
715      * Requirements:
716      *
717      * - `owner` cannot be the zero address.
718      * - `spender` cannot be the zero address.
719      */
720     function _approve(
721         address owner,
722         address spender,
723         uint256 amount
724     ) internal virtual {
725         require(owner != address(0), "ERC20: approve from the zero address");
726         require(spender != address(0), "ERC20: approve to the zero address");
727 
728         _allowances[owner][spender] = amount;
729         emit Approval(owner, spender, amount);
730     }
731 
732     /**
733      * @dev Hook that is called before any transfer of tokens. This includes
734      * minting and burning.
735      *
736      * Calling conditions:
737      *
738      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
739      * will be to transferred to `to`.
740      * - when `from` is zero, `amount` tokens will be minted for `to`.
741      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
742      * - `from` and `to` are never both zero.
743      *
744      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
745      */
746     function _beforeTokenTransfer(
747         address from,
748         address to,
749         uint256 amount
750     ) internal virtual {}
751 }
752 
753 interface IUniswapV2Router01 {
754     function factory() external pure returns (address);
755     function WETH() external pure returns (address);
756 
757     function addLiquidity(
758         address tokenA,
759         address tokenB,
760         uint amountADesired,
761         uint amountBDesired,
762         uint amountAMin,
763         uint amountBMin,
764         address to,
765         uint deadline
766     ) external returns (uint amountA, uint amountB, uint liquidity);
767     function addLiquidityETH(
768         address token,
769         uint amountTokenDesired,
770         uint amountTokenMin,
771         uint amountETHMin,
772         address to,
773         uint deadline
774     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
775     function removeLiquidity(
776         address tokenA,
777         address tokenB,
778         uint liquidity,
779         uint amountAMin,
780         uint amountBMin,
781         address to,
782         uint deadline
783     ) external returns (uint amountA, uint amountB);
784     function removeLiquidityETH(
785         address token,
786         uint liquidity,
787         uint amountTokenMin,
788         uint amountETHMin,
789         address to,
790         uint deadline
791     ) external returns (uint amountToken, uint amountETH);
792     function removeLiquidityWithPermit(
793         address tokenA,
794         address tokenB,
795         uint liquidity,
796         uint amountAMin,
797         uint amountBMin,
798         address to,
799         uint deadline,
800         bool approveMax, uint8 v, bytes32 r, bytes32 s
801     ) external returns (uint amountA, uint amountB);
802     function removeLiquidityETHWithPermit(
803         address token,
804         uint liquidity,
805         uint amountTokenMin,
806         uint amountETHMin,
807         address to,
808         uint deadline,
809         bool approveMax, uint8 v, bytes32 r, bytes32 s
810     ) external returns (uint amountToken, uint amountETH);
811     function swapExactTokensForTokens(
812         uint amountIn,
813         uint amountOutMin,
814         address[] calldata path,
815         address to,
816         uint deadline
817     ) external returns (uint[] memory amounts);
818     function swapTokensForExactTokens(
819         uint amountOut,
820         uint amountInMax,
821         address[] calldata path,
822         address to,
823         uint deadline
824     ) external returns (uint[] memory amounts);
825     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
826         external
827         payable
828         returns (uint[] memory amounts);
829     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
830         external
831         returns (uint[] memory amounts);
832     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
833         external
834         returns (uint[] memory amounts);
835     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
836         external
837         payable
838         returns (uint[] memory amounts);
839 
840     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
841     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
842     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
843     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
844     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
845 }
846 
847 
848 
849 // pragma solidity >=0.6.2;
850 
851 interface IUniswapV2Router02 is IUniswapV2Router01 {
852     function removeLiquidityETHSupportingFeeOnTransferTokens(
853         address token,
854         uint liquidity,
855         uint amountTokenMin,
856         uint amountETHMin,
857         address to,
858         uint deadline
859     ) external returns (uint amountETH);
860     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
861         address token,
862         uint liquidity,
863         uint amountTokenMin,
864         uint amountETHMin,
865         address to,
866         uint deadline,
867         bool approveMax, uint8 v, bytes32 r, bytes32 s
868     ) external returns (uint amountETH);
869 
870     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
871         uint amountIn,
872         uint amountOutMin,
873         address[] calldata path,
874         address to,
875         uint deadline
876     ) external;
877     function swapExactETHForTokensSupportingFeeOnTransferTokens(
878         uint amountOutMin,
879         address[] calldata path,
880         address to,
881         uint deadline
882     ) external payable;
883     function swapExactTokensForETHSupportingFeeOnTransferTokens(
884         uint amountIn,
885         uint amountOutMin,
886         address[] calldata path,
887         address to,
888         uint deadline
889     ) external;
890 }
891 
892 interface IUniswapV2Factory {
893     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
894 
895     function feeTo() external view returns (address);
896     function feeToSetter() external view returns (address);
897 
898     function getPair(address tokenA, address tokenB) external view returns (address pair);
899     function allPairs(uint) external view returns (address pair);
900     function allPairsLength() external view returns (uint);
901 
902     function createPair(address tokenA, address tokenB) external returns (address pair);
903 
904     function setFeeTo(address) external;
905     function setFeeToSetter(address) external;
906 }
907 
908 interface IUniswapV2Pair {
909     event Approval(address indexed owner, address indexed spender, uint value);
910     event Transfer(address indexed from, address indexed to, uint value);
911 
912     function name() external pure returns (string memory);
913     function symbol() external pure returns (string memory);
914     function decimals() external pure returns (uint8);
915     function totalSupply() external view returns (uint);
916     function balanceOf(address owner) external view returns (uint);
917     function allowance(address owner, address spender) external view returns (uint);
918 
919     function approve(address spender, uint value) external returns (bool);
920     function transfer(address to, uint value) external returns (bool);
921     function transferFrom(address from, address to, uint value) external returns (bool);
922 
923     function DOMAIN_SEPARATOR() external view returns (bytes32);
924     function PERMIT_TYPEHASH() external pure returns (bytes32);
925     function nonces(address owner) external view returns (uint);
926 
927     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
928 
929     event Mint(address indexed sender, uint amount0, uint amount1);
930     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
931     event Swap(
932         address indexed sender,
933         uint amount0In,
934         uint amount1In,
935         uint amount0Out,
936         uint amount1Out,
937         address indexed to
938     );
939     event Sync(uint112 reserve0, uint112 reserve1);
940 
941     function MINIMUM_LIQUIDITY() external pure returns (uint);
942     function factory() external view returns (address);
943     function token0() external view returns (address);
944     function token1() external view returns (address);
945     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
946     function price0CumulativeLast() external view returns (uint);
947     function price1CumulativeLast() external view returns (uint);
948     function kLast() external view returns (uint);
949 
950     function mint(address to) external returns (uint liquidity);
951     function burn(address to) external returns (uint amount0, uint amount1);
952     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
953     function skim(address to) external;
954     function sync() external;
955 
956     function initialize(address, address) external;
957 }
958 
959 
960 
961 library IterableMapping {
962     // Iterable mapping from address to uint;
963     struct Map {
964         address[] keys;
965         mapping(address => uint) values;
966         mapping(address => uint) indexOf;
967         mapping(address => bool) inserted;
968     }
969 
970     function get(Map storage map, address key) public view returns (uint) {
971         return map.values[key];
972     }
973 
974     function getIndexOfKey(Map storage map, address key) public view returns (int) {
975         if(!map.inserted[key]) {
976             return -1;
977         }
978         return int(map.indexOf[key]);
979     }
980 
981     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
982         return map.keys[index];
983     }
984 
985 
986 
987     function size(Map storage map) public view returns (uint) {
988         return map.keys.length;
989     }
990 
991     function set(Map storage map, address key, uint val) public {
992         if (map.inserted[key]) {
993             map.values[key] = val;
994         } else {
995             map.inserted[key] = true;
996             map.values[key] = val;
997             map.indexOf[key] = map.keys.length;
998             map.keys.push(key);
999         }
1000     }
1001 
1002     function remove(Map storage map, address key) public {
1003         if (!map.inserted[key]) {
1004             return;
1005         }
1006 
1007         delete map.inserted[key];
1008         delete map.values[key];
1009 
1010         uint index = map.indexOf[key];
1011         uint lastIndex = map.keys.length - 1;
1012         address lastKey = map.keys[lastIndex];
1013 
1014         map.indexOf[lastKey] = index;
1015         delete map.indexOf[key];
1016 
1017         map.keys[index] = lastKey;
1018         map.keys.pop();
1019     }
1020 }
1021 
1022 /// @title Dividend-Paying Token
1023 /// @author Roger Wu (https://github.com/roger-wu)
1024 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1025 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1026 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1027 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1028   using SafeMath for uint256;
1029   using SafeMathUint for uint256;
1030   using SafeMathInt for int256;
1031 
1032   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1033   // For more discussion about choosing the value of `magnitude`,
1034   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1035   uint256 constant internal magnitude = 2**128;
1036 
1037   uint256 internal magnifiedDividendPerShare;
1038 
1039   // About dividendCorrection:
1040   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1041   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1042   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1043   //   `dividendOf(_user)` should not be changed,
1044   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1045   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1046   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1047   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1048   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1049   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1050   mapping(address => int256) internal magnifiedDividendCorrections;
1051   mapping(address => uint256) internal withdrawnDividends;
1052 
1053   uint256 public totalDividendsDistributed;
1054 
1055   constructor(string memory _name, string memory _symbol) public ERC20(_name, _symbol) {
1056 
1057   }
1058 
1059   /// @dev Distributes dividends whenever ether is paid to this contract.
1060   receive() external payable {
1061     distributeDividends();
1062   }
1063 
1064   /// @notice Distributes ether to token holders as dividends.
1065   /// @dev It reverts if the total supply of tokens is 0.
1066   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1067   /// About undistributed ether:
1068   ///   In each distribution, there is a small amount of ether not distributed,
1069   ///     the magnified amount of which is
1070   ///     `(msg.value * magnitude) % totalSupply()`.
1071   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1072   ///     (de-magnified) in a distribution can be less than 1 wei.
1073   ///   We can actually keep track of the undistributed ether in a distribution
1074   ///     and try to distribute it in the next distribution,
1075   ///     but keeping track of such data on-chain costs much more than
1076   ///     the saved ether, so we don't do that.
1077   function distributeDividends() public override payable {
1078     require(totalSupply() > 0);
1079 
1080     if (msg.value > 0) {
1081       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1082         (msg.value).mul(magnitude) / totalSupply()
1083       );
1084       emit DividendsDistributed(msg.sender, msg.value);
1085 
1086       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1087     }
1088   }
1089 
1090   /// @notice Withdraws the ether distributed to the sender.
1091   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1092   function withdrawDividend() public virtual override {
1093     _withdrawDividendOfUser(msg.sender);
1094   }
1095 
1096   /// @notice Withdraws the ether distributed to the sender.
1097   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1098   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1099     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1100     if (_withdrawableDividend > 0) {
1101       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1102       emit DividendWithdrawn(user, _withdrawableDividend);
1103       (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
1104 
1105       if(!success) {
1106         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1107         return 0;
1108       }
1109 
1110       return _withdrawableDividend;
1111     }
1112 
1113     return 0;
1114   }
1115 
1116 
1117   /// @notice View the amount of dividend in wei that an address can withdraw.
1118   /// @param _owner The address of a token holder.
1119   /// @return The amount of dividend in wei that `_owner` can withdraw.
1120   function dividendOf(address _owner) public view override returns(uint256) {
1121     return withdrawableDividendOf(_owner);
1122   }
1123 
1124   /// @notice View the amount of dividend in wei that an address can withdraw.
1125   /// @param _owner The address of a token holder.
1126   /// @return The amount of dividend in wei that `_owner` can withdraw.
1127   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1128     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1129   }
1130 
1131   /// @notice View the amount of dividend in wei that an address has withdrawn.
1132   /// @param _owner The address of a token holder.
1133   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1134   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1135     return withdrawnDividends[_owner];
1136   }
1137 
1138 
1139   /// @notice View the amount of dividend in wei that an address has earned in total.
1140   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1141   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1142   /// @param _owner The address of a token holder.
1143   /// @return The amount of dividend in wei that `_owner` has earned in total.
1144   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1145     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1146       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1147   }
1148 
1149   /// @dev Internal function that transfer tokens from one address to another.
1150   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1151   /// @param from The address to transfer from.
1152   /// @param to The address to transfer to.
1153   /// @param value The amount to be transferred.
1154   function _transfer(address from, address to, uint256 value) internal virtual override {
1155     require(false);
1156 
1157     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1158     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1159     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1160   }
1161 
1162   /// @dev Internal function that mints tokens to an account.
1163   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1164   /// @param account The account that will receive the created tokens.
1165   /// @param value The amount that will be created.
1166   function _mint(address account, uint256 value) internal override {
1167     super._mint(account, value);
1168 
1169     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1170       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1171   }
1172 
1173   /// @dev Internal function that burns an amount of the token of a given account.
1174   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1175   /// @param account The account whose tokens will be burnt.
1176   /// @param value The amount that will be burnt.
1177   function _burn(address account, uint256 value) internal override {
1178     super._burn(account, value);
1179 
1180     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1181       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1182   }
1183 
1184   function _setBalance(address account, uint256 newBalance) internal {
1185     uint256 currentBalance = balanceOf(account);
1186 
1187     if(newBalance > currentBalance) {
1188       uint256 mintAmount = newBalance.sub(currentBalance);
1189       _mint(account, mintAmount);
1190     } else if(newBalance < currentBalance) {
1191       uint256 burnAmount = currentBalance.sub(newBalance);
1192       _burn(account, burnAmount);
1193     }
1194   }
1195 }
1196 
1197 
1198 
1199 
1200 contract TITN is ERC20 {
1201     using SafeMath for uint256;
1202 
1203     IUniswapV2Router02 public uniswapV2Router;
1204     address public immutable uniswapV2Pair;
1205 
1206     bool private swapping;
1207     bool public pauseSell = false;
1208     bool public pauseBuy = false;
1209 
1210 
1211     CTTDividendTracker public dividendTracker;
1212 
1213     address public liquidityWallet;
1214     address payable public marketingWallet = 0x3A8820C2a5FBF7757ca2d3c4C0D4Aecb76E2D9b4;
1215     uint256 public swapTokensAtAmount = 1000000 * (10**18); 
1216 
1217 
1218     uint256 public immutable ETHRewardsFee;
1219     uint256 public immutable liquidityFee;
1220     uint256 public immutable MarketingWalletFee;
1221     uint256 public immutable totalFees;
1222 
1223 
1224 
1225 
1226 
1227     // sells have fees of 12 and 6 (10 * 1.2 and 5 * 1.2)
1228     uint256 public sellFeeIncreaseFactor = 120; 
1229 
1230     // use by default 50,000 gas to process auto-claiming dividends
1231     uint256 public gasForProcessing = 50000;
1232 
1233 
1234     // exlcude from fees and max transaction amount
1235     mapping (address => bool) private _isExcludedFromFees;
1236     mapping (address => bool) public blackList;
1237 
1238 
1239     
1240 
1241     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1242     // could be subject to a maximum transfer amount
1243     mapping (address => bool) public automatedMarketMakerPairs;
1244 
1245     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1246 
1247     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1248 
1249     event ExcludeFromFees(address indexed account, bool isExcluded);
1250     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1251 
1252 
1253     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1254 
1255     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1256 
1257     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1258 
1259 
1260     event SwapAndLiquify(
1261         uint256 tokensSwapped,
1262         uint256 ethReceived,
1263         uint256 tokensIntoLiqudity
1264     );
1265 
1266     event SendDividends(
1267     	uint256 tokensSwapped,
1268     	uint256 amount
1269     );
1270 
1271     event ProcessedDividendTracker(
1272     	uint256 iterations,
1273     	uint256 claims,
1274         uint256 lastProcessedIndex,
1275     	bool indexed automatic,
1276     	uint256 gas,
1277     	address indexed processor
1278     );
1279 
1280     constructor() public ERC20("Crypto Titan Token", "TITN") {
1281         uint256 _ETHRewardsFee = 2;
1282         uint256 _liquidityFee = 2;
1283         uint256 _MarketingWalletFee = 6;
1284 
1285         ETHRewardsFee = _ETHRewardsFee;
1286         liquidityFee = _liquidityFee;
1287         MarketingWalletFee = _MarketingWalletFee;
1288         totalFees = _ETHRewardsFee.add(_liquidityFee).add(_MarketingWalletFee);
1289 
1290 
1291     	dividendTracker = new CTTDividendTracker();
1292 
1293     	liquidityWallet = owner();
1294 
1295     	
1296     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1297          // Create a uniswap pair for this new token
1298         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1299             .createPair(address(this), _uniswapV2Router.WETH());
1300 
1301         uniswapV2Router = _uniswapV2Router;
1302         uniswapV2Pair = _uniswapV2Pair;
1303 
1304         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1305 
1306 
1307         // exclude from receiving dividends
1308         dividendTracker.excludeFromDividends(address(dividendTracker));
1309         dividendTracker.excludeFromDividends(address(this));
1310         dividendTracker.excludeFromDividends(owner());
1311         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1312 
1313         // exclude from paying fees or having max transaction amount
1314         excludeFromFees(liquidityWallet, true);
1315         excludeFromFees(address(this), true);
1316 
1317         
1318         /*
1319             _mint is an internal function in ERC20.sol that is only called here,
1320             and CANNOT be called ever again
1321         */
1322         _mint(owner(), 1000000000000000 * (10**18));
1323     }
1324 
1325     receive() external payable {
1326 
1327   	}
1328 
1329     function updateDividendTracker(address newAddress) public onlyOwner {
1330         require(newAddress != address(dividendTracker), "The dividend tracker already has that address");
1331 
1332         CTTDividendTracker newDividendTracker = CTTDividendTracker(payable(newAddress));
1333 
1334         require(newDividendTracker.owner() == address(this), "The new dividend tracker must be owned by the CTT token contract");
1335 
1336         newDividendTracker.excludeFromDividends(address(newDividendTracker));
1337         newDividendTracker.excludeFromDividends(address(this));
1338         newDividendTracker.excludeFromDividends(owner());
1339         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
1340 
1341         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1342 
1343         dividendTracker = newDividendTracker;
1344     }
1345 
1346     function updateUniswapV2Router(address newAddress) public onlyOwner {
1347         require(newAddress != address(uniswapV2Router), "The router already has that address");
1348         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1349         uniswapV2Router = IUniswapV2Router02(newAddress);
1350     }
1351 
1352     function setSellStatus(bool enabled) external onlyOwner {
1353         pauseSell = enabled;
1354     }
1355 
1356     function setBuyStatus(bool enabled) external onlyOwner {
1357         pauseBuy = enabled;
1358     }
1359     
1360 
1361     function excludeFromFees(address account, bool excluded) public onlyOwner {
1362         require(_isExcludedFromFees[account] != excluded, "CTT: Account is already the value of 'excluded'");
1363         _isExcludedFromFees[account] = excluded;
1364 
1365         emit ExcludeFromFees(account, excluded);
1366     }
1367     
1368     function excludeFromDividends(address account) external onlyOwner {
1369         dividendTracker.excludeFromDividends(account);
1370     }
1371     
1372     function setSellFactor(uint256 newFactor) external onlyOwner {
1373         sellFeeIncreaseFactor = newFactor;
1374     }
1375     
1376     
1377     function setSwapAtAmount(uint256 newAmount) external onlyOwner {
1378         swapTokensAtAmount = newAmount * (10**18);
1379     }
1380     
1381     function changeMinimumHoldingLimit(uint256 newLimit) public onlyOwner {
1382         dividendTracker.setMinimumTokenBalanceForDividends(newLimit);
1383     }
1384     
1385 
1386     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1387         for(uint256 i = 0; i < accounts.length; i++) {
1388             _isExcludedFromFees[accounts[i]] = excluded;
1389         }
1390 
1391         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1392     }
1393     
1394     
1395     function changeMarketingWallet(address payable newAddress) external onlyOwner {
1396         marketingWallet = newAddress;
1397     }
1398     
1399 
1400     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1401         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1402 
1403         _setAutomatedMarketMakerPair(pair, value);
1404     }
1405 
1406     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1407         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
1408         automatedMarketMakerPairs[pair] = value;
1409 
1410         if(value) {
1411             dividendTracker.excludeFromDividends(pair);
1412         }
1413 
1414         emit SetAutomatedMarketMakerPair(pair, value);
1415     }
1416     
1417     function sendETHToWallets(uint256 amount) private { 
1418         swapTokensForEth(amount); 
1419         marketingWallet.transfer(address(this).balance);
1420     }
1421 
1422 
1423     function updateLiquidityWallet(address newLiquidityWallet) public onlyOwner {
1424         require(newLiquidityWallet != liquidityWallet, "CTT: The liquidity wallet is already this address");
1425         excludeFromFees(newLiquidityWallet, true);
1426         emit LiquidityWalletUpdated(newLiquidityWallet, liquidityWallet);
1427         liquidityWallet = newLiquidityWallet;
1428     }
1429 
1430     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1431         require(newValue != gasForProcessing, "CTT: Cannot update gasForProcessing to same value");
1432         emit GasForProcessingUpdated(newValue, gasForProcessing);
1433         gasForProcessing = newValue;
1434     }
1435     
1436     function blackListAddress(address account) external onlyOwner {
1437         blackList[account] = true;
1438     }
1439     
1440     function unBlockAddress(address account) external onlyOwner {
1441         blackList[account] = false;
1442     }
1443 
1444     function updateClaimWait(uint256 claimWait) external onlyOwner {
1445         dividendTracker.updateClaimWait(claimWait);
1446     }
1447 
1448     function getClaimWait() external view returns(uint256) {
1449         return dividendTracker.claimWait();
1450     }
1451     
1452     function minimumLimitForDividend() public view returns(uint256) {
1453         return dividendTracker.minimumTokenLimit();
1454     }
1455 
1456     function getTotalDividendsDistributed() external view returns (uint256) {
1457         return dividendTracker.totalDividendsDistributed();
1458     }
1459 
1460     function isExcludedFromFees(address account) public view returns(bool) {
1461         return _isExcludedFromFees[account];
1462     }
1463     
1464     function isExcludedFromDividends(address account) public view returns(bool) {
1465         return dividendTracker.excludedFromDividends(account);
1466     }
1467 
1468     function withdrawableDividendOf(address account) public view returns(uint256) {
1469     	return dividendTracker.withdrawableDividendOf(account);
1470   	}
1471 
1472 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
1473 		return dividendTracker.balanceOf(account);
1474 	}
1475 
1476     function getAccountDividendsInfo(address account)
1477         external view returns (
1478             address,
1479             int256,
1480             int256,
1481             uint256,
1482             uint256,
1483             uint256,
1484             uint256,
1485             uint256) {
1486         return dividendTracker.getAccount(account);
1487     }
1488 
1489 	function getAccountDividendsInfoAtIndex(uint256 index)
1490         external view returns (
1491             address,
1492             int256,
1493             int256,
1494             uint256,
1495             uint256,
1496             uint256,
1497             uint256,
1498             uint256) {
1499     	return dividendTracker.getAccountAtIndex(index);
1500     }
1501 
1502 	function processDividendTracker(uint256 gas) external {
1503 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1504 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1505     }
1506 
1507     function claim() external {
1508 		dividendTracker.processAccount(msg.sender, false);
1509     }
1510 
1511     function getLastProcessedIndex() external view returns(uint256) {
1512     	return dividendTracker.getLastProcessedIndex();
1513     }
1514 
1515     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1516         return dividendTracker.getNumberOfTokenHolders();
1517     }
1518     
1519 
1520     function _transfer(
1521         address from,
1522         address to,
1523         uint256 amount
1524     ) internal override {
1525         require(from != address(0), "ERC20: transfer from the zero address");
1526         require(to != address(0), "ERC20: transfer to the zero address");
1527         
1528         
1529 
1530         if(amount == 0) {
1531             super._transfer(from, to, 0);
1532             return;
1533         }
1534         
1535         if(blackList[from] == true || blackList[to] == true) {
1536             revert();
1537         }
1538 
1539         if(to == uniswapV2Pair && pauseSell == true && from != owner()) {
1540             revert();
1541         }
1542 
1543         if(from == uniswapV2Pair && pauseBuy == true && to != owner()) {
1544             revert();
1545         }
1546         
1547         
1548 		uint256 contractTokenBalance = balanceOf(address(this));
1549         
1550         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1551 
1552         if(
1553             canSwap &&
1554             !swapping &&
1555             !automatedMarketMakerPairs[from] &&
1556             from != liquidityWallet &&
1557             to != liquidityWallet
1558         ) {
1559             swapping = true;
1560             
1561             uint256 devWalletTokens = contractTokenBalance.mul(MarketingWalletFee).div(totalFees);
1562             sendETHToWallets(devWalletTokens);
1563 
1564             uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(totalFees);
1565             swapAndLiquify(swapTokens);
1566 
1567             uint256 sellTokens = balanceOf(address(this));
1568             swapAndSendDividends(sellTokens);
1569 
1570             swapping = false;
1571         }
1572 
1573 
1574         bool takeFee =  !swapping; 
1575 
1576         // if any account belongs to _isExcludedFromFee account then remove the fee
1577         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1578             takeFee = false;
1579         }
1580 
1581         if(takeFee) {
1582         	uint256 fees = amount.mul(totalFees).div(100);
1583 
1584             // if sell, multiply by 1.2
1585             if(automatedMarketMakerPairs[to]) {
1586                 fees = fees.mul(sellFeeIncreaseFactor).div(100);
1587             }
1588 
1589         	amount = amount.sub(fees);
1590 
1591             super._transfer(from, address(this), fees);
1592         }
1593 
1594         super._transfer(from, to, amount);
1595 
1596         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1597         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1598 
1599         if(!swapping) {
1600 	    	uint256 gas = gasForProcessing;
1601 
1602 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1603 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1604 	    	} 
1605 	    	catch {
1606 
1607 	    	}
1608         }
1609     }
1610 
1611     function swapAndLiquify(uint256 tokens) private {
1612         // split the contract balance into halves
1613         uint256 half = tokens.div(2);
1614         uint256 otherHalf = tokens.sub(half);
1615         // capture the contract's current ETH balance.
1616         // this is so that we can capture exactly the amount of ETH that the
1617         // swap creates, and not make the liquidity event include any ETH that
1618         // has been manually sent to the contract
1619         uint256 initialBalance = address(this).balance;
1620         
1621         // swap tokens for ETH
1622         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1623         
1624 
1625         // how much ETH did we just swap into?
1626         uint256 newBalance = address(this).balance.sub(initialBalance);
1627         
1628         // add liquidity to uniswap
1629         addLiquidity(otherHalf, newBalance);
1630 
1631         emit SwapAndLiquify(half, newBalance, otherHalf);
1632 
1633     }
1634 
1635     function swapTokensForEth(uint256 tokenAmount) private {
1636 
1637         
1638         // generate the uniswap pair path of token -> weth
1639         address[] memory path = new address[](2);
1640         path[0] = address(this);
1641         path[1] = uniswapV2Router.WETH();
1642 
1643         _approve(address(this), address(uniswapV2Router), tokenAmount);
1644 
1645         // make the swap
1646         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1647             tokenAmount,
1648             0, // accept any amount of ETH
1649             path,
1650             address(this),
1651             block.timestamp
1652         );
1653         
1654     }
1655 
1656     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1657         
1658         // approve token transfer to cover all possible scenarios
1659         _approve(address(this), address(uniswapV2Router), tokenAmount);
1660 
1661         // add the liquidity
1662         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1663             address(this),
1664             tokenAmount,
1665             0, // slippage is unavoidable
1666             0, // slippage is unavoidable
1667             liquidityWallet,
1668             block.timestamp
1669         );
1670         
1671     }
1672 
1673     function swapAndSendDividends(uint256 tokens) private {
1674         swapTokensForEth(tokens);
1675         uint256 dividends = address(this).balance;
1676         (bool success,) = address(dividendTracker).call{value: dividends}("");
1677 
1678         if(success) {
1679    	 		emit SendDividends(tokens, dividends);
1680         }
1681     }
1682 }
1683 
1684 contract CTTDividendTracker is DividendPayingToken {
1685     using SafeMath for uint256;
1686     using SafeMathInt for int256;
1687     using IterableMapping for IterableMapping.Map;
1688 
1689     IterableMapping.Map private tokenHoldersMap;
1690     uint256 public lastProcessedIndex;
1691 
1692     mapping (address => bool) public excludedFromDividends;
1693 
1694     mapping (address => uint256) public lastClaimTimes;
1695 
1696     uint256 public claimWait;
1697     uint256 private  minimumTokenBalanceForDividends;
1698 
1699     event ExcludeFromDividends(address indexed account);
1700     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1701 
1702     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1703 
1704     constructor() public DividendPayingToken("CTT_Dividend_Tracker", "CTT_Dividend_Tracker") {
1705     	claimWait = 3600;
1706         minimumTokenBalanceForDividends = 500000000000 * (10**18); 
1707     }
1708     
1709     
1710     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
1711         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10**18);
1712     }
1713 
1714     function _transfer(address, address, uint256) internal override {
1715         require(false, "CTT_Dividend_Tracker: No transfers allowed");
1716     }
1717 
1718     function withdrawDividend() public override {
1719         require(false, "CTT_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main CTT contract.");
1720     }
1721 
1722     function excludeFromDividends(address account) external onlyOwner {
1723     	require(!excludedFromDividends[account]);
1724     	excludedFromDividends[account] = true;
1725 
1726     	_setBalance(account, 0);
1727     	tokenHoldersMap.remove(account);
1728 
1729     	emit ExcludeFromDividends(account);
1730     }
1731 
1732     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1733         require(newClaimWait >= 3600 && newClaimWait <= 86400, "CTT_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1734         require(newClaimWait != claimWait, "CTT_Dividend_Tracker: Cannot update claimWait to same value");
1735         emit ClaimWaitUpdated(newClaimWait, claimWait);
1736         claimWait = newClaimWait;
1737     }
1738 
1739     function getLastProcessedIndex() external view returns(uint256) {
1740     	return lastProcessedIndex;
1741     }
1742     
1743     function minimumTokenLimit() public view returns(uint256) {
1744         return minimumTokenBalanceForDividends;
1745     }
1746 
1747     function getNumberOfTokenHolders() external view returns(uint256) {
1748         return tokenHoldersMap.keys.length;
1749     }
1750 
1751 
1752 
1753     function getAccount(address _account)
1754         public view returns (
1755             address account,
1756             int256 index,
1757             int256 iterationsUntilProcessed,
1758             uint256 withdrawableDividends,
1759             uint256 totalDividends,
1760             uint256 lastClaimTime,
1761             uint256 nextClaimTime,
1762             uint256 secondsUntilAutoClaimAvailable) {
1763         account = _account;
1764 
1765         index = tokenHoldersMap.getIndexOfKey(account);
1766 
1767         iterationsUntilProcessed = -1;
1768 
1769         if(index >= 0) {
1770             if(uint256(index) > lastProcessedIndex) {
1771                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1772             }
1773             else {
1774                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1775                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1776                                                         0;
1777 
1778 
1779                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1780             }
1781         }
1782 
1783 
1784         withdrawableDividends = withdrawableDividendOf(account);
1785         totalDividends = accumulativeDividendOf(account);
1786 
1787         lastClaimTime = lastClaimTimes[account];
1788 
1789         nextClaimTime = lastClaimTime > 0 ?
1790                                     lastClaimTime.add(claimWait) :
1791                                     0;
1792 
1793         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1794                                                     nextClaimTime.sub(block.timestamp) :
1795                                                     0;
1796     }
1797 
1798     function getAccountAtIndex(uint256 index)
1799         public view returns (
1800             address,
1801             int256,
1802             int256,
1803             uint256,
1804             uint256,
1805             uint256,
1806             uint256,
1807             uint256) {
1808     	if(index >= tokenHoldersMap.size()) {
1809             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1810         }
1811 
1812         address account = tokenHoldersMap.getKeyAtIndex(index);
1813 
1814         return getAccount(account);
1815     }
1816 
1817     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1818     	if(lastClaimTime > block.timestamp)  {
1819     		return false;
1820     	}
1821 
1822     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1823     }
1824 
1825     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1826     	if(excludedFromDividends[account]) {
1827     		return;
1828     	}
1829 
1830     	if(newBalance >= minimumTokenBalanceForDividends) {
1831             _setBalance(account, newBalance);
1832     		tokenHoldersMap.set(account, newBalance);
1833     	}
1834     	else {
1835             _setBalance(account, 0);
1836     		tokenHoldersMap.remove(account);
1837     	}
1838 
1839     	processAccount(account, true);
1840     }
1841 
1842     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1843     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1844 
1845     	if(numberOfTokenHolders == 0) {
1846     		return (0, 0, lastProcessedIndex);
1847     	}
1848 
1849     	uint256 _lastProcessedIndex = lastProcessedIndex;
1850 
1851     	uint256 gasUsed = 0;
1852 
1853     	uint256 gasLeft = gasleft();
1854 
1855     	uint256 iterations = 0;
1856     	uint256 claims = 0;
1857 
1858     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1859     		_lastProcessedIndex++;
1860 
1861     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1862     			_lastProcessedIndex = 0;
1863     		}
1864 
1865     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1866 
1867     		if(canAutoClaim(lastClaimTimes[account])) {
1868     			if(processAccount(payable(account), true)) {
1869     				claims++;
1870     			}
1871     		}
1872 
1873     		iterations++;
1874 
1875     		uint256 newGasLeft = gasleft();
1876 
1877     		if(gasLeft > newGasLeft) {
1878     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1879     		}
1880 
1881     		gasLeft = newGasLeft;
1882     	}
1883 
1884     	lastProcessedIndex = _lastProcessedIndex;
1885 
1886     	return (iterations, claims, lastProcessedIndex);
1887     }
1888 
1889     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1890         uint256 amount = _withdrawDividendOfUser(account);
1891 
1892     	if(amount > 0) {
1893     		lastClaimTimes[account] = block.timestamp;
1894             emit Claim(account, amount, automatic);
1895     		return true;
1896     	}
1897 
1898     	return false;
1899     }
1900 }