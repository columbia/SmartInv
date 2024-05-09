1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, with an overflow flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         uint256 c = a + b;
133         if (c < a) return (false, 0);
134         return (true, c);
135     }
136 
137     /**
138      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
139      *
140      * _Available since v3.4._
141      */
142     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         if (b > a) return (false, 0);
144         return (true, a - b);
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) return (true, 0);
157         uint256 c = a * b;
158         if (c / a != b) return (false, 0);
159         return (true, c);
160     }
161 
162     /**
163      * @dev Returns the division of two unsigned integers, with a division by zero flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         if (b == 0) return (false, 0);
169         return (true, a / b);
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
178         if (b == 0) return (false, 0);
179         return (true, a % b);
180     }
181 
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      *
190      * - Addition cannot overflow.
191      */
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         require(c >= a, "SafeMath: addition overflow");
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b <= a, "SafeMath: subtraction overflow");
210         return a - b;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         if (a == 0) return 0;
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227         return c;
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers, reverting on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         require(b > 0, "SafeMath: division by zero");
244         return a / b;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * reverting when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         require(b > 0, "SafeMath: modulo by zero");
261         return a % b;
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
266      * overflow (when the result is negative).
267      *
268      * CAUTION: This function is deprecated because it requires allocating memory for the error
269      * message unnecessarily. For custom revert reasons use {trySub}.
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      *
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b <= a, errorMessage);
279         return a - b;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
284      * division by zero. The result is rounded towards zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryDiv}.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         return a / b;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting with custom message when dividing by zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryMod}.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b > 0, errorMessage);
319         return a % b;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
324 
325 
326 pragma solidity >=0.6.0 <0.8.0;
327 
328 
329 
330 
331 /**
332  * @dev Implementation of the {IERC20} interface.
333  *
334  * This implementation is agnostic to the way tokens are created. This means
335  * that a supply mechanism has to be added in a derived contract using {_mint}.
336  * For a generic mechanism see {ERC20PresetMinterPauser}.
337  *
338  * TIP: For a detailed writeup see our guide
339  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
340  * to implement supply mechanisms].
341  *
342  * We have followed general OpenZeppelin guidelines: functions revert instead
343  * of returning `false` on failure. This behavior is nonetheless conventional
344  * and does not conflict with the expectations of ERC20 applications.
345  *
346  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
347  * This allows applications to reconstruct the allowance for all accounts just
348  * by listening to said events. Other implementations of the EIP may not emit
349  * these events, as it isn't required by the specification.
350  *
351  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
352  * functions have been added to mitigate the well-known issues around setting
353  * allowances. See {IERC20-approve}.
354  */
355 contract ERC20 is Context, IERC20 {
356     using SafeMath for uint256;
357 
358     mapping (address => uint256) private _balances;
359 
360     mapping (address => mapping (address => uint256)) private _allowances;
361 
362     uint256 private _totalSupply;
363 
364     string private _name;
365     string private _symbol;
366     uint8 private _decimals;
367 
368     /**
369      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
370      * a default value of 18.
371      *
372      * To select a different value for {decimals}, use {_setupDecimals}.
373      *
374      * All three of these values are immutable: they can only be set once during
375      * construction.
376      */
377     constructor (string memory name_, string memory symbol_) public {
378         _name = name_;
379         _symbol = symbol_;
380         _decimals = 18;
381     }
382 
383     /**
384      * @dev Returns the name of the token.
385      */
386     function name() public view virtual returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @dev Returns the symbol of the token, usually a shorter version of the
392      * name.
393      */
394     function symbol() public view virtual returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @dev Returns the number of decimals used to get its user representation.
400      * For example, if `decimals` equals `2`, a balance of `505` tokens should
401      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
402      *
403      * Tokens usually opt for a value of 18, imitating the relationship between
404      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
405      * called.
406      *
407      * NOTE: This information is only used for _display_ purposes: it in
408      * no way affects any of the arithmetic of the contract, including
409      * {IERC20-balanceOf} and {IERC20-transfer}.
410      */
411     function decimals() public view virtual returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev See {IERC20-totalSupply}.
417      */
418     function totalSupply() public view virtual override returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev See {IERC20-balanceOf}.
424      */
425     function balanceOf(address account) public view virtual override returns (uint256) {
426         return _balances[account];
427     }
428 
429     /**
430      * @dev See {IERC20-transfer}.
431      *
432      * Requirements:
433      *
434      * - `recipient` cannot be the zero address.
435      * - the caller must have a balance of at least `amount`.
436      */
437     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
438         _transfer(_msgSender(), recipient, amount);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-allowance}.
444      */
445     function allowance(address owner, address spender) public view virtual override returns (uint256) {
446         return _allowances[owner][spender];
447     }
448 
449     /**
450      * @dev See {IERC20-approve}.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      */
456     function approve(address spender, uint256 amount) public virtual override returns (bool) {
457         _approve(_msgSender(), spender, amount);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-transferFrom}.
463      *
464      * Emits an {Approval} event indicating the updated allowance. This is not
465      * required by the EIP. See the note at the beginning of {ERC20}.
466      *
467      * Requirements:
468      *
469      * - `sender` and `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      * - the caller must have allowance for ``sender``'s tokens of at least
472      * `amount`.
473      */
474     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
475         _transfer(sender, recipient, amount);
476         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
477         return true;
478     }
479 
480     /**
481      * @dev Atomically increases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     /**
517      * @dev Moves tokens `amount` from `sender` to `recipient`.
518      *
519      * This is internal function is equivalent to {transfer}, and can be used to
520      * e.g. implement automatic token fees, slashing mechanisms, etc.
521      *
522      * Emits a {Transfer} event.
523      *
524      * Requirements:
525      *
526      * - `sender` cannot be the zero address.
527      * - `recipient` cannot be the zero address.
528      * - `sender` must have a balance of at least `amount`.
529      */
530     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
531         require(sender != address(0), "ERC20: transfer from the zero address");
532         require(recipient != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(sender, recipient, amount);
535 
536         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
537         _balances[recipient] = _balances[recipient].add(amount);
538         emit Transfer(sender, recipient, amount);
539     }
540 
541     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
542      * the total supply.
543      *
544      * Emits a {Transfer} event with `from` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `to` cannot be the zero address.
549      */
550     function _mint(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply = _totalSupply.add(amount);
556         _balances[account] = _balances[account].add(amount);
557         emit Transfer(address(0), account, amount);
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from `account`, reducing the
562      * total supply.
563      *
564      * Emits a {Transfer} event with `to` set to the zero address.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      * - `account` must have at least `amount` tokens.
570      */
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
577         _totalSupply = _totalSupply.sub(amount);
578         emit Transfer(account, address(0), amount);
579     }
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
583      *
584      * This internal function is equivalent to `approve`, and can be used to
585      * e.g. set automatic allowances for certain subsystems, etc.
586      *
587      * Emits an {Approval} event.
588      *
589      * Requirements:
590      *
591      * - `owner` cannot be the zero address.
592      * - `spender` cannot be the zero address.
593      */
594     function _approve(address owner, address spender, uint256 amount) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Sets {decimals} to a value other than the default one of 18.
604      *
605      * WARNING: This function should only be called from the constructor. Most
606      * applications that interact with token contracts will not expect
607      * {decimals} to ever change, and may work incorrectly if it does.
608      */
609     function _setupDecimals(uint8 decimals_) internal virtual {
610         _decimals = decimals_;
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630 // File: @openzeppelin/contracts/access/Ownable.sol
631 
632 
633 pragma solidity >=0.6.0 <0.8.0;
634 
635 /**
636  * @dev Contract module which provides a basic access control mechanism, where
637  * there is an account (an owner) that can be granted exclusive access to
638  * specific functions.
639  *
640  * By default, the owner account will be the one that deploys the contract. This
641  * can later be changed with {transferOwnership}.
642  *
643  * This module is used through inheritance. It will make available the modifier
644  * `onlyOwner`, which can be applied to your functions to restrict their use to
645  * the owner.
646  */
647 abstract contract Ownable is Context {
648     address private _owner;
649 
650     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
651 
652     /**
653      * @dev Initializes the contract setting the deployer as the initial owner.
654      */
655     constructor () internal {
656         address msgSender = _msgSender();
657         _owner = msgSender;
658         emit OwnershipTransferred(address(0), msgSender);
659     }
660 
661     /**
662      * @dev Returns the address of the current owner.
663      */
664     function owner() public view virtual returns (address) {
665         return _owner;
666     }
667 
668     /**
669      * @dev Throws if called by any account other than the owner.
670      */
671     modifier onlyOwner() {
672         require(owner() == _msgSender(), "Ownable: caller is not the owner");
673         _;
674     }
675 
676     /**
677      * @dev Leaves the contract without owner. It will not be possible to call
678      * `onlyOwner` functions anymore. Can only be called by the current owner.
679      *
680      * NOTE: Renouncing ownership will leave the contract without an owner,
681      * thereby removing any functionality that is only available to the owner.
682      */
683     function renounceOwnership() public virtual onlyOwner {
684         emit OwnershipTransferred(_owner, address(0));
685         _owner = address(0);
686     }
687 
688     /**
689      * @dev Transfers ownership of the contract to a new account (`newOwner`).
690      * Can only be called by the current owner.
691      */
692     function transferOwnership(address newOwner) public virtual onlyOwner {
693         require(newOwner != address(0), "Ownable: new owner is the zero address");
694         emit OwnershipTransferred(_owner, newOwner);
695         _owner = newOwner;
696     }
697 }
698 
699 // File: contracts/BDPToken.sol
700 
701 
702 pragma solidity 0.6.12;
703 
704 
705 
706 
707 contract BDPToken is ERC20("BDPToken", "BDP"), Ownable {
708     using SafeMath for uint256;
709 
710     uint256 public NUMBER_BLOCKS_PER_DAY;
711     uint256 public cap = 80000000e18 + 1e18;
712     address public BDPMaster;
713     address public BDPMasterPending;
714     uint public setBDPMasterPendingAtBlock;
715 
716     uint256 public seedPoolAmount = 24000000e18;
717 
718     uint256 constant public PARTNERSHIP_TOTAL_AMOUNT = 20000000e18;
719     uint256 constant public PARTNERSHIP_FIRST_MINT = 8000000e18;
720     uint256 public partnershipAmount = PARTNERSHIP_TOTAL_AMOUNT;
721     uint256 public partnershipMintedAtBlock = 0;
722 
723     uint256 constant public TEAM_TOTAL_AMOUNT = 8000000e18;
724     uint256 public teamAmount = TEAM_TOTAL_AMOUNT;
725     uint256 public teamMintedAtBlock = 0;
726 
727     uint256 constant public FUTURE_TOTAL_AMOUNT = 28000000e18;
728     uint256 constant public FUTURE_EACH_MINT = 9333333e18;
729     uint256 public futureAmount = FUTURE_TOTAL_AMOUNT;
730     uint256 public futureCanMintAtBlock = 0;
731 
732     uint256 public startAtBlock;
733 
734     constructor (uint _startAtBlock, uint _numberBlockPerDay, address _sendTo) public {
735         startAtBlock = _startAtBlock;
736         NUMBER_BLOCKS_PER_DAY = _numberBlockPerDay > 0 ? _numberBlockPerDay : 6000;
737         _mint(_sendTo, 1e18);
738     }
739     
740     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
741         super._beforeTokenTransfer(from, to, amount);
742 
743         if (from == address(0)) {
744             require(totalSupply().add(amount) <= cap, "BDPToken: cap exceeded");
745         }
746     }
747 
748     function setPendingMaster(address _BDPMaster) public onlyOwner {
749         BDPMasterPending = _BDPMaster;
750         setBDPMasterPendingAtBlock = block.number;
751     }
752 
753     function confirmMaster() public onlyOwner {
754         require(block.number - setBDPMasterPendingAtBlock > 2 * NUMBER_BLOCKS_PER_DAY, "BDPToken: cannot confirm at this time");
755         BDPMaster = BDPMasterPending;
756     }
757 
758     function setMaster(address _BDPMaster) public onlyOwner {
759         require(BDPMaster == address(0x0), "BDPToken: Cannot set master");
760         BDPMaster = _BDPMaster;
761     }
762 
763     function mint(address _to, uint256 _amount) public {
764         require(msg.sender == BDPMaster, "BDPToken: only master farmer can mint");
765         require(seedPoolAmount > 0, "BDPToken: cannot mint for pool");
766         require(seedPoolAmount >= _amount, "BDPToken: amount greater than limitation");
767         seedPoolAmount = seedPoolAmount.sub(_amount);
768         _mint(_to, _amount);
769     }
770 
771     function mintForPartnership(address _to) public onlyOwner {
772         uint amount;
773 
774         require(block.number >= startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY, "BDPToken: Cannot mint at this time");
775         require(partnershipAmount > 0, "BDPToken: Cannot mint more token for partnership");
776 
777         // This first minting
778         if (partnershipMintedAtBlock == 0) {
779             amount = PARTNERSHIP_FIRST_MINT;
780             partnershipMintedAtBlock = startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY;
781         }
782         else {
783             amount = PARTNERSHIP_TOTAL_AMOUNT
784                 .sub(PARTNERSHIP_FIRST_MINT)
785                 .mul(block.number - partnershipMintedAtBlock)
786                 .div(270 * NUMBER_BLOCKS_PER_DAY);
787             partnershipMintedAtBlock = block.number;
788         }
789 
790         amount = amount < partnershipAmount ? amount : partnershipAmount;
791 
792         partnershipAmount = partnershipAmount.sub(amount);
793         _mint(_to, amount);
794     }
795 
796     function mintForTeam(address _to) public onlyOwner {
797         uint amount;
798 
799         require(block.number >= startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY, "BDPToken: Cannot mint at this time");
800         require(teamAmount > 0, "BDPToken: Cannot mint more token for team");
801         // This first minting
802         if (teamMintedAtBlock == 0) {
803             teamMintedAtBlock = startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY;
804         }
805         amount = TEAM_TOTAL_AMOUNT
806             .mul(block.number - teamMintedAtBlock)
807             .div(270 * NUMBER_BLOCKS_PER_DAY);
808         teamMintedAtBlock = block.number;
809 
810         amount = amount < teamAmount ? amount : teamAmount;
811 
812         teamAmount = teamAmount.sub(amount);
813         _mint(_to, amount);
814     }
815 
816     function mintForFutureFarming(address _to) public onlyOwner {
817         require(block.number >= startAtBlock + 56 * NUMBER_BLOCKS_PER_DAY, "BDPToken: Cannot mint at this time");
818         require(futureAmount > 0, "BDPToken: Cannot mint more token for future farming");
819 
820 
821         if (block.number >= startAtBlock + 56 * NUMBER_BLOCKS_PER_DAY 
822             && futureAmount >= FUTURE_TOTAL_AMOUNT) {
823             _mint(_to, FUTURE_EACH_MINT);
824             futureAmount = futureAmount.sub(FUTURE_EACH_MINT);
825         }
826 
827         if (block.number >= startAtBlock + 86 * NUMBER_BLOCKS_PER_DAY 
828             && futureAmount >= FUTURE_TOTAL_AMOUNT.sub(FUTURE_EACH_MINT)) {
829             _mint(_to, FUTURE_EACH_MINT);
830             futureAmount = futureAmount.sub(FUTURE_EACH_MINT);
831         }
832 
833         if (block.number >= startAtBlock + 116 * NUMBER_BLOCKS_PER_DAY
834             && futureAmount > 0) {
835             _mint(_to, futureAmount);
836             futureAmount = 0;
837         }
838     }
839 }