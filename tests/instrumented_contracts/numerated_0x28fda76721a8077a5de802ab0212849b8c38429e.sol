1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /*
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with GSN meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address payable) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes memory) {
102         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
103         return msg.data;
104     }
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
699 // File: contracts/Token.sol
700 
701 pragma solidity ^0.6.0;
702 
703 
704 
705 
706 
707 
708 
709 
710 // ----------------------------------------------------------------------------
711 // BokkyPooBah's DateTime Library v1.01
712 //
713 // A gas-efficient Solidity date and time library
714 //
715 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
716 //
717 // Tested date range 1970/01/01 to 2345/12/31
718 //
719 // Conventions:
720 // Unit      | Range         | Notes
721 // :-------- |:-------------:|:-----
722 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
723 // year      | 1970 ... 2345 |
724 // month     | 1 ... 12      |
725 // day       | 1 ... 31      |
726 // hour      | 0 ... 23      |
727 // minute    | 0 ... 59      |
728 // second    | 0 ... 59      |
729 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
730 //
731 //
732 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
733 // ----------------------------------------------------------------------------
734 
735 library BokkyPooBahsDateTimeLibrary {
736 
737     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
738     uint constant SECONDS_PER_HOUR = 60 * 60;
739     uint constant SECONDS_PER_MINUTE = 60;
740     int constant OFFSET19700101 = 2440588;
741 
742     uint constant DOW_MON = 1;
743     uint constant DOW_TUE = 2;
744     uint constant DOW_WED = 3;
745     uint constant DOW_THU = 4;
746     uint constant DOW_FRI = 5;
747     uint constant DOW_SAT = 6;
748     uint constant DOW_SUN = 7;
749 
750     // ------------------------------------------------------------------------
751     // Calculate the number of days from 1970/01/01 to year/month/day using
752     // the date conversion algorithm from
753     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
754     // and subtracting the offset 2440588 so that 1970/01/01 is day 0
755     //
756     // days = day
757     //      - 32075
758     //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
759     //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
760     //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
761     //      - offset
762     // ------------------------------------------------------------------------
763     function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
764         require(year >= 1970);
765         int _year = int(year);
766         int _month = int(month);
767         int _day = int(day);
768 
769         int __days = _day
770           - 32075
771           + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
772           + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
773           - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
774           - OFFSET19700101;
775 
776         _days = uint(__days);
777     }
778 
779     // ------------------------------------------------------------------------
780     // Calculate year/month/day from the number of days since 1970/01/01 using
781     // the date conversion algorithm from
782     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
783     // and adding the offset 2440588 so that 1970/01/01 is day 0
784     //
785     // int L = days + 68569 + offset
786     // int N = 4 * L / 146097
787     // L = L - (146097 * N + 3) / 4
788     // year = 4000 * (L + 1) / 1461001
789     // L = L - 1461 * year / 4 + 31
790     // month = 80 * L / 2447
791     // dd = L - 2447 * month / 80
792     // L = month / 11
793     // month = month + 2 - 12 * L
794     // year = 100 * (N - 49) + year + L
795     // ------------------------------------------------------------------------
796     function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
797         int __days = int(_days);
798 
799         int L = __days + 68569 + OFFSET19700101;
800         int N = 4 * L / 146097;
801         L = L - (146097 * N + 3) / 4;
802         int _year = 4000 * (L + 1) / 1461001;
803         L = L - 1461 * _year / 4 + 31;
804         int _month = 80 * L / 2447;
805         int _day = L - 2447 * _month / 80;
806         L = _month / 11;
807         _month = _month + 2 - 12 * L;
808         _year = 100 * (N - 49) + _year + L;
809 
810         year = uint(_year);
811         month = uint(_month);
812         day = uint(_day);
813     }
814 
815     function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
816         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
817     }
818     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
819         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
820     }
821     function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
822         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
823     }
824     function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
825         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
826         uint secs = timestamp % SECONDS_PER_DAY;
827         hour = secs / SECONDS_PER_HOUR;
828         secs = secs % SECONDS_PER_HOUR;
829         minute = secs / SECONDS_PER_MINUTE;
830         second = secs % SECONDS_PER_MINUTE;
831     }
832 
833     function isValidDate(uint year, uint month, uint day) internal pure returns (bool valid) {
834         if (year >= 1970 && month > 0 && month <= 12) {
835             uint daysInMonth = _getDaysInMonth(year, month);
836             if (day > 0 && day <= daysInMonth) {
837                 valid = true;
838             }
839         }
840     }
841     function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (bool valid) {
842         if (isValidDate(year, month, day)) {
843             if (hour < 24 && minute < 60 && second < 60) {
844                 valid = true;
845             }
846         }
847     }
848     function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
849         (uint year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
850         leapYear = _isLeapYear(year);
851     }
852     function _isLeapYear(uint year) internal pure returns (bool leapYear) {
853         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
854     }
855     function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
856         weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
857     }
858     function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
859         weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
860     }
861     function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
862         (uint year, uint month,) = _daysToDate(timestamp / SECONDS_PER_DAY);
863         daysInMonth = _getDaysInMonth(year, month);
864     }
865     function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
866         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
867             daysInMonth = 31;
868         } else if (month != 2) {
869             daysInMonth = 30;
870         } else {
871             daysInMonth = _isLeapYear(year) ? 29 : 28;
872         }
873     }
874     // 1 = Monday, 7 = Sunday
875     function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
876         uint _days = timestamp / SECONDS_PER_DAY;
877         dayOfWeek = (_days + 3) % 7 + 1;
878     }
879 
880     function getYear(uint timestamp) internal pure returns (uint year) {
881         (year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
882     }
883     function getMonth(uint timestamp) internal pure returns (uint month) {
884         (,month,) = _daysToDate(timestamp / SECONDS_PER_DAY);
885     }
886     function getDay(uint timestamp) internal pure returns (uint day) {
887         (,,day) = _daysToDate(timestamp / SECONDS_PER_DAY);
888     }
889     function getHour(uint timestamp) internal pure returns (uint hour) {
890         uint secs = timestamp % SECONDS_PER_DAY;
891         hour = secs / SECONDS_PER_HOUR;
892     }
893     function getMinute(uint timestamp) internal pure returns (uint minute) {
894         uint secs = timestamp % SECONDS_PER_HOUR;
895         minute = secs / SECONDS_PER_MINUTE;
896     }
897     function getSecond(uint timestamp) internal pure returns (uint second) {
898         second = timestamp % SECONDS_PER_MINUTE;
899     }
900 
901     function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
902         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
903         year += _years;
904         uint daysInMonth = _getDaysInMonth(year, month);
905         if (day > daysInMonth) {
906             day = daysInMonth;
907         }
908         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
909         require(newTimestamp >= timestamp);
910     }
911     function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
912         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
913         month += _months;
914         year += (month - 1) / 12;
915         month = (month - 1) % 12 + 1;
916         uint daysInMonth = _getDaysInMonth(year, month);
917         if (day > daysInMonth) {
918             day = daysInMonth;
919         }
920         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
921         require(newTimestamp >= timestamp);
922     }
923     function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
924         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
925         require(newTimestamp >= timestamp);
926     }
927     function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
928         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
929         require(newTimestamp >= timestamp);
930     }
931     function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
932         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
933         require(newTimestamp >= timestamp);
934     }
935     function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
936         newTimestamp = timestamp + _seconds;
937         require(newTimestamp >= timestamp);
938     }
939 
940     function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
941         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
942         year -= _years;
943         uint daysInMonth = _getDaysInMonth(year, month);
944         if (day > daysInMonth) {
945             day = daysInMonth;
946         }
947         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
948         require(newTimestamp <= timestamp);
949     }
950     function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
951         (uint year, uint month, uint day) = _daysToDate(timestamp / SECONDS_PER_DAY);
952         uint yearMonth = year * 12 + (month - 1) - _months;
953         year = yearMonth / 12;
954         month = yearMonth % 12 + 1;
955         uint daysInMonth = _getDaysInMonth(year, month);
956         if (day > daysInMonth) {
957             day = daysInMonth;
958         }
959         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
960         require(newTimestamp <= timestamp);
961     }
962     function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
963         newTimestamp = timestamp - _days * SECONDS_PER_DAY;
964         require(newTimestamp <= timestamp);
965     }
966     function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
967         newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
968         require(newTimestamp <= timestamp);
969     }
970     function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
971         newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
972         require(newTimestamp <= timestamp);
973     }
974     function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
975         newTimestamp = timestamp - _seconds;
976         require(newTimestamp <= timestamp);
977     }
978 
979     function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
980         require(fromTimestamp <= toTimestamp);
981         (uint fromYear,,) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
982         (uint toYear,,) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
983         _years = toYear - fromYear;
984     }
985     function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
986         require(fromTimestamp <= toTimestamp);
987         (uint fromYear, uint fromMonth,) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
988         (uint toYear, uint toMonth,) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
989         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
990     }
991     function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
992         require(fromTimestamp <= toTimestamp);
993         _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
994     }
995     function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
996         require(fromTimestamp <= toTimestamp);
997         _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
998     }
999     function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
1000         require(fromTimestamp <= toTimestamp);
1001         _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
1002     }
1003     function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
1004         require(fromTimestamp <= toTimestamp);
1005         _seconds = toTimestamp - fromTimestamp;
1006     }
1007 }
1008 
1009 // ----------------------------------------------------------------------------
1010 // Testing BokkyPooBah's DateTime Library
1011 //
1012 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
1013 //
1014 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
1015 // ----------------------------------------------------------------------------
1016 
1017 contract TestDateTime {
1018     using BokkyPooBahsDateTimeLibrary for uint;
1019 
1020     uint public nextYear;
1021 
1022     function test() public {
1023         uint today = now;
1024         nextYear = today.addYears(1);
1025     }
1026 
1027     function timestampFromDate(uint year, uint month, uint day) public pure returns (uint timestamp) {
1028         return BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, day);
1029     }
1030     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) public pure returns (uint timestamp) {
1031         return BokkyPooBahsDateTimeLibrary.timestampFromDateTime(year, month, day, hour, minute, second);
1032     }
1033     function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day) {
1034         (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
1035     }
1036     function timestampToDateTime(uint timestamp) public pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
1037         (year, month, day, hour, minute, second) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(timestamp);
1038     }
1039 
1040     function isLeapYear(uint timestamp) public pure returns (bool leapYear) {
1041         leapYear = BokkyPooBahsDateTimeLibrary.isLeapYear(timestamp);
1042     }
1043     function _isLeapYear(uint year) public pure returns (bool leapYear) {
1044         leapYear = BokkyPooBahsDateTimeLibrary._isLeapYear(year);
1045     }
1046     function isWeekDay(uint timestamp) public pure returns (bool weekDay) {
1047         weekDay = BokkyPooBahsDateTimeLibrary.isWeekDay(timestamp);
1048     }
1049     function isWeekEnd(uint timestamp) public pure returns (bool weekEnd) {
1050         weekEnd = BokkyPooBahsDateTimeLibrary.isWeekEnd(timestamp);
1051     }
1052 
1053     function getDaysInMonth(uint timestamp) public pure returns (uint daysInMonth) {
1054         daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth(timestamp);
1055     }
1056     function _getDaysInMonth(uint year, uint month) public pure returns (uint daysInMonth) {
1057         daysInMonth = BokkyPooBahsDateTimeLibrary._getDaysInMonth(year, month);
1058     }
1059     function getDayOfWeek(uint timestamp) public pure returns (uint dayOfWeek) {
1060         dayOfWeek = BokkyPooBahsDateTimeLibrary.getDayOfWeek(timestamp);
1061     }
1062 
1063     function isValidDate(uint year, uint month, uint day) public pure returns (bool valid) {
1064         valid = BokkyPooBahsDateTimeLibrary.isValidDate(year, month, day);
1065     }
1066     function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) public pure returns (bool valid) {
1067         valid = BokkyPooBahsDateTimeLibrary.isValidDateTime(year, month, day, hour, minute, second);
1068     }
1069 
1070     function getYear(uint timestamp) public pure returns (uint year) {
1071         year = BokkyPooBahsDateTimeLibrary.getYear(timestamp);
1072     }
1073     function getMonth(uint timestamp) public pure returns (uint month) {
1074         month = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
1075     }
1076     function getDay(uint timestamp) public pure returns (uint day) {
1077         day = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
1078     }
1079     function getHour(uint timestamp) public pure returns (uint hour) {
1080         hour = BokkyPooBahsDateTimeLibrary.getHour(timestamp);
1081     }
1082     function getMinute(uint timestamp) public pure returns (uint minute) {
1083         minute = BokkyPooBahsDateTimeLibrary.getMinute(timestamp);
1084     }
1085     function getSecond(uint timestamp) public pure returns (uint second) {
1086         second = BokkyPooBahsDateTimeLibrary.getSecond(timestamp);
1087     }
1088 
1089     function addYears(uint timestamp, uint _years) public pure returns (uint newTimestamp) {
1090         newTimestamp = BokkyPooBahsDateTimeLibrary.addYears(timestamp, _years);
1091     }
1092     function addMonths(uint timestamp, uint _months) public pure returns (uint newTimestamp) {
1093         newTimestamp = BokkyPooBahsDateTimeLibrary.addMonths(timestamp, _months);
1094     }
1095     function addDays(uint timestamp, uint _days) public pure returns (uint newTimestamp) {
1096         newTimestamp = BokkyPooBahsDateTimeLibrary.addDays(timestamp, _days);
1097     }
1098     function addHours(uint timestamp, uint _hours) public pure returns (uint newTimestamp) {
1099         newTimestamp = BokkyPooBahsDateTimeLibrary.addHours(timestamp, _hours);
1100     }
1101     function addMinutes(uint timestamp, uint _minutes) public pure returns (uint newTimestamp) {
1102         newTimestamp = BokkyPooBahsDateTimeLibrary.addMinutes(timestamp, _minutes);
1103     }
1104     function addSeconds(uint timestamp, uint _seconds) public pure returns (uint newTimestamp) {
1105         newTimestamp = BokkyPooBahsDateTimeLibrary.addSeconds(timestamp, _seconds);
1106     }
1107 
1108     function subYears(uint timestamp, uint _years) public pure returns (uint newTimestamp) {
1109         newTimestamp = BokkyPooBahsDateTimeLibrary.subYears(timestamp, _years);
1110     }
1111     function subMonths(uint timestamp, uint _months) public pure returns (uint newTimestamp) {
1112         newTimestamp = BokkyPooBahsDateTimeLibrary.subMonths(timestamp, _months);
1113     }
1114     function subDays(uint timestamp, uint _days) public pure returns (uint newTimestamp) {
1115         newTimestamp = BokkyPooBahsDateTimeLibrary.subDays(timestamp, _days);
1116     }
1117     function subHours(uint timestamp, uint _hours) public pure returns (uint newTimestamp) {
1118         newTimestamp = BokkyPooBahsDateTimeLibrary.subHours(timestamp, _hours);
1119     }
1120     function subMinutes(uint timestamp, uint _minutes) public pure returns (uint newTimestamp) {
1121         newTimestamp = BokkyPooBahsDateTimeLibrary.subMinutes(timestamp, _minutes);
1122     }
1123     function subSeconds(uint timestamp, uint _seconds) public pure returns (uint newTimestamp) {
1124         newTimestamp = BokkyPooBahsDateTimeLibrary.subSeconds(timestamp, _seconds);
1125     }
1126 
1127     function diffYears(uint fromTimestamp, uint toTimestamp) public pure returns (uint _years) {
1128         _years = BokkyPooBahsDateTimeLibrary.diffYears(fromTimestamp, toTimestamp);
1129     }
1130     function diffMonths(uint fromTimestamp, uint toTimestamp) public pure returns (uint _months) {
1131         _months = BokkyPooBahsDateTimeLibrary.diffMonths(fromTimestamp, toTimestamp);
1132     }
1133     function diffDays(uint fromTimestamp, uint toTimestamp) public pure returns (uint _days) {
1134         _days = BokkyPooBahsDateTimeLibrary.diffDays(fromTimestamp, toTimestamp);
1135     }
1136     function diffHours(uint fromTimestamp, uint toTimestamp) public pure returns (uint _hours) {
1137         _hours = BokkyPooBahsDateTimeLibrary.diffHours(fromTimestamp, toTimestamp);
1138     }
1139     function diffMinutes(uint fromTimestamp, uint toTimestamp) public pure returns (uint _minutes) {
1140         _minutes = BokkyPooBahsDateTimeLibrary.diffMinutes(fromTimestamp, toTimestamp);
1141     }
1142     function diffSeconds(uint fromTimestamp, uint toTimestamp) public pure returns (uint _seconds) {
1143         _seconds = BokkyPooBahsDateTimeLibrary.diffSeconds(fromTimestamp, toTimestamp);
1144     }
1145 }
1146 
1147 
1148 
1149 contract Artemis is Ownable, ERC20 {
1150     
1151     using BokkyPooBahsDateTimeLibrary for uint;
1152     using SafeMath for uint256;
1153 
1154     uint256 public MAX_SUPPLY =  10000000 * 10**18;
1155     uint public last_development_withdrawal_time;
1156     //TOKENS ALLOTMENT
1157     uint256 public STAKING_RESERVE =  1670000 * 10**18;
1158     uint256 public TEAM_AND_ADVISOR_RESERVE =  240000 * 10**18;
1159     uint256 public DEVELOPMENT_RESERVE =  200000 * 10**18;
1160     uint256 public MARKETING_AND_LISTING_RESERVE =  400000 * 10**18;
1161     uint256 public MINTABLE_SUPPLY =  7000000 * 10**18;
1162     uint256 public TOTAL_MINTABLE_MINTED =  0;
1163     uint256 public PARTNERSHIP_INTERGRATION_RESERVE =  490000 * 10**18;
1164 
1165 
1166 
1167 
1168 
1169     address public _stakingWallet;
1170     address public _teamWallet;
1171     address public _developmentWallet;
1172     address public _marketingWallet;
1173     address public _partnershipIntegrationWallet;
1174 
1175 
1176 
1177     function checkTeamWalletWithdrawalEligiblity() private returns(bool){
1178         if(last_development_withdrawal_time ==0){
1179             return true;
1180         }
1181         uint _days = BokkyPooBahsDateTimeLibrary.diffDays(last_development_withdrawal_time, now);
1182 
1183         if(_days>30){
1184             return true;
1185         }else{
1186             return false;
1187         }
1188     }
1189 
1190 
1191 
1192     function claimTeamTokens()public{
1193         require(checkTeamWalletWithdrawalEligiblity(),"1 month has not passed please try after one month");
1194 
1195         require(msg.sender == _teamWallet,"You are not authorized");
1196         require(TEAM_AND_ADVISOR_RESERVE >0,"Development Reserve Empty");
1197         uint256 amount =  20000 * 10**18;
1198         _mint(_teamWallet, amount);
1199         last_development_withdrawal_time = now;
1200         TEAM_AND_ADVISOR_RESERVE = TEAM_AND_ADVISOR_RESERVE.sub(amount);
1201     }
1202 
1203 
1204     function claimDevelopmentTokens()public{
1205 
1206         
1207          require(msg.sender == _developmentWallet,"You are not authorized");
1208         _mint(_developmentWallet, DEVELOPMENT_RESERVE);
1209         DEVELOPMENT_RESERVE = 0;
1210     }
1211 
1212     function claimMarketingTokens()public{
1213         require(msg.sender == _marketingWallet,"You are not authorized");
1214         _mint(_marketingWallet, MARKETING_AND_LISTING_RESERVE);
1215         MARKETING_AND_LISTING_RESERVE = 0;
1216 
1217     }
1218     
1219     
1220      function claimPartnershipAndIntegrationTokens()public{
1221         require(msg.sender == _partnershipIntegrationWallet,"You are not authorized");
1222         _mint(_partnershipIntegrationWallet, PARTNERSHIP_INTERGRATION_RESERVE);
1223         PARTNERSHIP_INTERGRATION_RESERVE = 0;
1224 
1225     }
1226 
1227     function claimStakingTokens()public{
1228         require(msg.sender == _stakingWallet,"You are not authorized");
1229         _mint(_stakingWallet, STAKING_RESERVE);
1230         STAKING_RESERVE=0;
1231     }
1232 
1233 
1234 
1235     constructor(address stakingWallet,
1236                 address  teamWallet,
1237                 address  developmentWallet,
1238                 address marketingWallet,
1239                 address partnershipIntegrationWallet)
1240                  public ERC20("Artemis Vision", "ARV") {
1241 
1242 
1243         _stakingWallet = stakingWallet;
1244         _teamWallet = teamWallet;
1245         _developmentWallet = developmentWallet;
1246         _marketingWallet = marketingWallet;
1247 
1248         _partnershipIntegrationWallet = partnershipIntegrationWallet;
1249                   
1250                      
1251  }
1252 
1253    
1254    
1255    
1256    
1257     function mint(address account, uint256 amount) public onlyOwner {
1258         require(TOTAL_MINTABLE_MINTED.add(amount)<=MINTABLE_SUPPLY,"Max Supply Exceeds");
1259         _mint(account, amount);
1260         TOTAL_MINTABLE_MINTED = TOTAL_MINTABLE_MINTED.add(amount);
1261     }
1262 
1263 
1264 
1265    
1266     function burn(address account, uint256 amount) public onlyOwner {
1267         _burn(account, amount);
1268     }
1269 
1270     function recoverERC20( uint256 tokenAmount) public virtual onlyOwner {
1271         IERC20(address(this)).transfer(owner(), tokenAmount);
1272     }
1273 }