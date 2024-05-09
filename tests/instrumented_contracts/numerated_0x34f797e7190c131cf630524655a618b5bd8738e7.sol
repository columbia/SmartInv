1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/IERC20.sol
219 
220 pragma solidity >=0.6.0 <0.8.0;
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP.
224  */
225 interface IERC20 {
226     /**
227      * @dev Returns the amount of tokens in existence.
228      */
229     function totalSupply() external view returns (uint256);
230 
231     /**
232      * @dev Returns the amount of tokens owned by `account`.
233      */
234     function balanceOf(address account) external view returns (uint256);
235 
236     /**
237      * @dev Moves `amount` tokens from the caller's account to `recipient`.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transfer(address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Returns the remaining number of tokens that `spender` will be
247      * allowed to spend on behalf of `owner` through {transferFrom}. This is
248      * zero by default.
249      *
250      * This value changes when {approve} or {transferFrom} are called.
251      */
252     function allowance(address owner, address spender) external view returns (uint256);
253 
254     /**
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * IMPORTANT: Beware that changing an allowance with this method brings the risk
260      * that someone may use both the old and the new allowance by unfortunate
261      * transaction ordering. One possible solution to mitigate this race
262      * condition is to first reduce the spender's allowance to 0 and set the
263      * desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address spender, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Moves `amount` tokens from `sender` to `recipient` using the
272      * allowance mechanism. `amount` is then deducted from the caller's
273      * allowance.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Emitted when `value` tokens are moved from one account (`from`) to
283      * another (`to`).
284      *
285      * Note that `value` may be zero.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     /**
290      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
291      * a call to {approve}. `value` is the new allowance.
292      */
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 
297 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/utils/Context.sol
298 
299 pragma solidity >=0.6.0 <0.8.0;
300 
301 /*
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with GSN meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address payable) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes memory) {
317         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
318         return msg.data;
319     }
320 }
321 
322 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20.sol
323 
324 pragma solidity >=0.6.0 <0.8.0;
325 
326 
327 /**
328  * @dev Implementation of the {IERC20} interface.
329  *
330  * This implementation is agnostic to the way tokens are created. This means
331  * that a supply mechanism has to be added in a derived contract using {_mint}.
332  * For a generic mechanism see {ERC20PresetMinterPauser}.
333  *
334  * TIP: For a detailed writeup see our guide
335  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
336  * to implement supply mechanisms].
337  *
338  * We have followed general OpenZeppelin guidelines: functions revert instead
339  * of returning `false` on failure. This behavior is nonetheless conventional
340  * and does not conflict with the expectations of ERC20 applications.
341  *
342  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
343  * This allows applications to reconstruct the allowance for all accounts just
344  * by listening to said events. Other implementations of the EIP may not emit
345  * these events, as it isn't required by the specification.
346  *
347  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
348  * functions have been added to mitigate the well-known issues around setting
349  * allowances. See {IERC20-approve}.
350  */
351 contract ERC20 is Context, IERC20 {
352     using SafeMath for uint256;
353 
354     mapping (address => uint256) private _balances;
355 
356     mapping (address => mapping (address => uint256)) private _allowances;
357 
358     uint256 private _totalSupply;
359 
360     string private _name;
361     string private _symbol;
362     uint8 private _decimals;
363 
364     /**
365      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
366      * a default value of 18.
367      *
368      * To select a different value for {decimals}, use {_setupDecimals}.
369      *
370      * All three of these values are immutable: they can only be set once during
371      * construction.
372      */
373     constructor (string memory name_, string memory symbol_) public {
374         _name = name_;
375         _symbol = symbol_;
376         _decimals = 18;
377     }
378 
379     /**
380      * @dev Returns the name of the token.
381      */
382     function name() public view virtual returns (string memory) {
383         return _name;
384     }
385 
386     /**
387      * @dev Returns the symbol of the token, usually a shorter version of the
388      * name.
389      */
390     function symbol() public view virtual returns (string memory) {
391         return _symbol;
392     }
393 
394     /**
395      * @dev Returns the number of decimals used to get its user representation.
396      * For example, if `decimals` equals `2`, a balance of `505` tokens should
397      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
398      *
399      * Tokens usually opt for a value of 18, imitating the relationship between
400      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
401      * called.
402      *
403      * NOTE: This information is only used for _display_ purposes: it in
404      * no way affects any of the arithmetic of the contract, including
405      * {IERC20-balanceOf} and {IERC20-transfer}.
406      */
407     function decimals() public view virtual returns (uint8) {
408         return _decimals;
409     }
410 
411     /**
412      * @dev See {IERC20-totalSupply}.
413      */
414     function totalSupply() public view virtual override returns (uint256) {
415         return _totalSupply;
416     }
417 
418     /**
419      * @dev See {IERC20-balanceOf}.
420      */
421     function balanceOf(address account) public view virtual override returns (uint256) {
422         return _balances[account];
423     }
424 
425     /**
426      * @dev See {IERC20-transfer}.
427      *
428      * Requirements:
429      *
430      * - `recipient` cannot be the zero address.
431      * - the caller must have a balance of at least `amount`.
432      */
433     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
434         _transfer(_msgSender(), recipient, amount);
435         return true;
436     }
437 
438     /**
439      * @dev See {IERC20-allowance}.
440      */
441     function allowance(address owner, address spender) public view virtual override returns (uint256) {
442         return _allowances[owner][spender];
443     }
444 
445     /**
446      * @dev See {IERC20-approve}.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      */
452     function approve(address spender, uint256 amount) public virtual override returns (bool) {
453         _approve(_msgSender(), spender, amount);
454         return true;
455     }
456 
457     /**
458      * @dev See {IERC20-transferFrom}.
459      *
460      * Emits an {Approval} event indicating the updated allowance. This is not
461      * required by the EIP. See the note at the beginning of {ERC20}.
462      *
463      * Requirements:
464      *
465      * - `sender` and `recipient` cannot be the zero address.
466      * - `sender` must have a balance of at least `amount`.
467      * - the caller must have allowance for ``sender``'s tokens of at least
468      * `amount`.
469      */
470     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
471         _transfer(sender, recipient, amount);
472         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
473         return true;
474     }
475 
476     /**
477      * @dev Atomically increases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      */
488     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
489         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
490         return true;
491     }
492 
493     /**
494      * @dev Atomically decreases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      * - `spender` must have allowance for the caller of at least
505      * `subtractedValue`.
506      */
507     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
508         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
509         return true;
510     }
511 
512     /**
513      * @dev Moves tokens `amount` from `sender` to `recipient`.
514      *
515      * This is internal function is equivalent to {transfer}, and can be used to
516      * e.g. implement automatic token fees, slashing mechanisms, etc.
517      *
518      * Emits a {Transfer} event.
519      *
520      * Requirements:
521      *
522      * - `sender` cannot be the zero address.
523      * - `recipient` cannot be the zero address.
524      * - `sender` must have a balance of at least `amount`.
525      */
526     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
527         require(sender != address(0), "ERC20: transfer from the zero address");
528         require(recipient != address(0), "ERC20: transfer to the zero address");
529 
530         _beforeTokenTransfer(sender, recipient, amount);
531 
532         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
533         _balances[recipient] = _balances[recipient].add(amount);
534         emit Transfer(sender, recipient, amount);
535     }
536 
537     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
538      * the total supply.
539      *
540      * Emits a {Transfer} event with `from` set to the zero address.
541      *
542      * Requirements:
543      *
544      * - `to` cannot be the zero address.
545      */
546     function _mint(address account, uint256 amount) internal virtual {
547         require(account != address(0), "ERC20: mint to the zero address");
548 
549         _beforeTokenTransfer(address(0), account, amount);
550 
551         _totalSupply = _totalSupply.add(amount);
552         _balances[account] = _balances[account].add(amount);
553         emit Transfer(address(0), account, amount);
554     }
555 
556     /**
557      * @dev Destroys `amount` tokens from `account`, reducing the
558      * total supply.
559      *
560      * Emits a {Transfer} event with `to` set to the zero address.
561      *
562      * Requirements:
563      *
564      * - `account` cannot be the zero address.
565      * - `account` must have at least `amount` tokens.
566      */
567     function _burn(address account, uint256 amount) internal virtual {
568         require(account != address(0), "ERC20: burn from the zero address");
569 
570         _beforeTokenTransfer(account, address(0), amount);
571 
572         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
573         _totalSupply = _totalSupply.sub(amount);
574         emit Transfer(account, address(0), amount);
575     }
576 
577     /**
578      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
579      *
580      * This internal function is equivalent to `approve`, and can be used to
581      * e.g. set automatic allowances for certain subsystems, etc.
582      *
583      * Emits an {Approval} event.
584      *
585      * Requirements:
586      *
587      * - `owner` cannot be the zero address.
588      * - `spender` cannot be the zero address.
589      */
590     function _approve(address owner, address spender, uint256 amount) internal virtual {
591         require(owner != address(0), "ERC20: approve from the zero address");
592         require(spender != address(0), "ERC20: approve to the zero address");
593 
594         _allowances[owner][spender] = amount;
595         emit Approval(owner, spender, amount);
596     }
597 
598     /**
599      * @dev Sets {decimals} to a value other than the default one of 18.
600      *
601      * WARNING: This function should only be called from the constructor. Most
602      * applications that interact with token contracts will not expect
603      * {decimals} to ever change, and may work incorrectly if it does.
604      */
605     function _setupDecimals(uint8 decimals_) internal virtual {
606         _decimals = decimals_;
607     }
608 
609     /**
610      * @dev Hook that is called before any transfer of tokens. This includes
611      * minting and burning.
612      *
613      * Calling conditions:
614      *
615      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
616      * will be to transferred to `to`.
617      * - when `from` is zero, `amount` tokens will be minted for `to`.
618      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
619      * - `from` and `to` are never both zero.
620      *
621      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
622      */
623     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
624 }
625 
626 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20Burnable.sol
627 
628 pragma solidity >=0.6.0 <0.8.0;
629 
630 
631 
632 /**
633  * @dev Extension of {ERC20} that allows token holders to destroy both their own
634  * tokens and those that they have an allowance for, in a way that can be
635  * recognized off-chain (via event analysis).
636  */
637 abstract contract ERC20Burnable is Context, ERC20 {
638     using SafeMath for uint256;
639 
640     /**
641      * @dev Destroys `amount` tokens from the caller.
642      *
643      * See {ERC20-_burn}.
644      */
645     function burn(uint256 amount) public virtual {
646         _burn(_msgSender(), amount);
647     }
648 
649     /**
650      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
651      * allowance.
652      *
653      * See {ERC20-_burn} and {ERC20-allowance}.
654      *
655      * Requirements:
656      *
657      * - the caller must have allowance for ``accounts``'s tokens of at least
658      * `amount`.
659      */
660     function burnFrom(address account, uint256 amount) public virtual {
661         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
662 
663         _approve(account, _msgSender(), decreasedAllowance);
664         _burn(account, amount);
665     }
666 }
667 
668 // File: contracts/BaconToken.sol
669 
670 pragma solidity ^0.7.0;
671 
672 
673 /**
674  * @dev {ERC20} token, including:
675  *
676  *  - Preminted initial supply
677  *  - Ability for holders to burn (destroy) their tokens
678  *  - No access control mechanism (for minting/pausing) and hence no governance
679  *
680  * This contract uses {ERC20Burnable} to include burn capabilities - head to
681  * its documentation for details.
682  *
683  * _Available since v3.4._
684  */
685 contract BaconToken is ERC20Burnable {
686     /**
687      * @dev Mints `initialSupply` amount of token and transfers them to msg.sender.
688      *
689      * See {ERC20-constructor}.
690      */
691     constructor(
692         string memory name,
693         string memory symbol,
694         uint256 initialSupply
695     ) ERC20(name, symbol) {
696         _mint(msg.sender, initialSupply);
697     }
698 }