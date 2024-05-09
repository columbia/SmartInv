1 pragma solidity >=0.6.0 <0.8.0;
2 
3 // SPDX-License-Identifier: Unlicensed
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
26 
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
105 
106 
107 pragma solidity >=0.6.0 <0.8.0;
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         uint256 c = a + b;
130         if (c < a) return (false, 0);
131         return (true, c);
132     }
133 
134     /**
135      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         if (b > a) return (false, 0);
141         return (true, a - b);
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
146      *
147      * _Available since v3.4._
148      */
149     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) return (true, 0);
154         uint256 c = a * b;
155         if (c / a != b) return (false, 0);
156         return (true, c);
157     }
158 
159     /**
160      * @dev Returns the division of two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         if (b == 0) return (false, 0);
166         return (true, a / b);
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         if (b == 0) return (false, 0);
176         return (true, a % b);
177     }
178 
179     /**
180      * @dev Returns the addition of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `+` operator.
184      *
185      * Requirements:
186      *
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192         return c;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         require(b <= a, "SafeMath: subtraction overflow");
207         return a - b;
208     }
209 
210     /**
211      * @dev Returns the multiplication of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `*` operator.
215      *
216      * Requirements:
217      *
218      * - Multiplication cannot overflow.
219      */
220     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221         if (a == 0) return 0;
222         uint256 c = a * b;
223         require(c / a == b, "SafeMath: multiplication overflow");
224         return c;
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers, reverting on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b) internal pure returns (uint256) {
240         require(b > 0, "SafeMath: division by zero");
241         return a / b;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * reverting when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         require(b > 0, "SafeMath: modulo by zero");
258         return a % b;
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * CAUTION: This function is deprecated because it requires allocating memory for the error
266      * message unnecessarily. For custom revert reasons use {trySub}.
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      *
272      * - Subtraction cannot overflow.
273      */
274     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b <= a, errorMessage);
276         return a - b;
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * CAUTION: This function is deprecated because it requires allocating memory for the error
284      * message unnecessarily. For custom revert reasons use {tryDiv}.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b > 0, errorMessage);
296         return a / b;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * reverting with custom message when dividing by zero.
302      *
303      * CAUTION: This function is deprecated because it requires allocating memory for the error
304      * message unnecessarily. For custom revert reasons use {tryMod}.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         require(b > 0, errorMessage);
316         return a % b;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
321 
322 
323 pragma solidity >=0.6.0 <0.8.0;
324 
325 
326 
327 
328 /**
329  * @dev Implementation of the {IERC20} interface.
330  *
331  * This implementation is agnostic to the way tokens are created. This means
332  * that a supply mechanism has to be added in a derived contract using {_mint}.
333  * For a generic mechanism see {ERC20PresetMinterPauser}.
334  *
335  * TIP: For a detailed writeup see our guide
336  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
337  * to implement supply mechanisms].
338  *
339  * We have followed general OpenZeppelin guidelines: functions revert instead
340  * of returning `false` on failure. This behavior is nonetheless conventional
341  * and does not conflict with the expectations of ERC20 applications.
342  *
343  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
344  * This allows applications to reconstruct the allowance for all accounts just
345  * by listening to said events. Other implementations of the EIP may not emit
346  * these events, as it isn't required by the specification.
347  *
348  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
349  * functions have been added to mitigate the well-known issues around setting
350  * allowances. See {IERC20-approve}.
351  */
352 contract ERC20 is Context, IERC20 {
353     using SafeMath for uint256;
354 
355     mapping (address => uint256) private _balances;
356 
357     mapping (address => mapping (address => uint256)) private _allowances;
358 
359     uint256 private _totalSupply;
360 
361     string private _name;
362     string private _symbol;
363     uint8 private _decimals;
364 
365     /**
366      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
367      * a default value of 18.
368      *
369      * To select a different value for {decimals}, use {_setupDecimals}.
370      *
371      * All three of these values are immutable: they can only be set once during
372      * construction.
373      */
374     constructor (string memory name_, string memory symbol_) public {
375         _name = name_;
376         _symbol = symbol_;
377         _decimals = 18;
378     }
379 
380     /**
381      * @dev Returns the name of the token.
382      */
383     function name() public view virtual returns (string memory) {
384         return _name;
385     }
386 
387     /**
388      * @dev Returns the symbol of the token, usually a shorter version of the
389      * name.
390      */
391     function symbol() public view virtual returns (string memory) {
392         return _symbol;
393     }
394 
395     /**
396      * @dev Returns the number of decimals used to get its user representation.
397      * For example, if `decimals` equals `2`, a balance of `505` tokens should
398      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
399      *
400      * Tokens usually opt for a value of 18, imitating the relationship between
401      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
402      * called.
403      *
404      * NOTE: This information is only used for _display_ purposes: it in
405      * no way affects any of the arithmetic of the contract, including
406      * {IERC20-balanceOf} and {IERC20-transfer}.
407      */
408     function decimals() public view virtual returns (uint8) {
409         return _decimals;
410     }
411 
412     /**
413      * @dev See {IERC20-totalSupply}.
414      */
415     function totalSupply() public view virtual override returns (uint256) {
416         return _totalSupply;
417     }
418 
419     /**
420      * @dev See {IERC20-balanceOf}.
421      */
422     function balanceOf(address account) public view virtual override returns (uint256) {
423         return _balances[account];
424     }
425 
426     /**
427      * @dev See {IERC20-transfer}.
428      *
429      * Requirements:
430      *
431      * - `recipient` cannot be the zero address.
432      * - the caller must have a balance of at least `amount`.
433      */
434     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437     }
438 
439     /**
440      * @dev See {IERC20-allowance}.
441      */
442     function allowance(address owner, address spender) public view virtual override returns (uint256) {
443         return _allowances[owner][spender];
444     }
445 
446     /**
447      * @dev See {IERC20-approve}.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      */
453     function approve(address spender, uint256 amount) public virtual override returns (bool) {
454         _approve(_msgSender(), spender, amount);
455         return true;
456     }
457 
458     /**
459      * @dev See {IERC20-transferFrom}.
460      *
461      * Emits an {Approval} event indicating the updated allowance. This is not
462      * required by the EIP. See the note at the beginning of {ERC20}.
463      *
464      * Requirements:
465      *
466      * - `sender` and `recipient` cannot be the zero address.
467      * - `sender` must have a balance of at least `amount`.
468      * - the caller must have allowance for ``sender``'s tokens of at least
469      * `amount`.
470      */
471     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
472         _transfer(sender, recipient, amount);
473         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
474         return true;
475     }
476 
477     /**
478      * @dev Atomically increases the allowance granted to `spender` by the caller.
479      *
480      * This is an alternative to {approve} that can be used as a mitigation for
481      * problems described in {IERC20-approve}.
482      *
483      * Emits an {Approval} event indicating the updated allowance.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      */
489     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
491         return true;
492     }
493 
494     /**
495      * @dev Atomically decreases the allowance granted to `spender` by the caller.
496      *
497      * This is an alternative to {approve} that can be used as a mitigation for
498      * problems described in {IERC20-approve}.
499      *
500      * Emits an {Approval} event indicating the updated allowance.
501      *
502      * Requirements:
503      *
504      * - `spender` cannot be the zero address.
505      * - `spender` must have allowance for the caller of at least
506      * `subtractedValue`.
507      */
508     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
509         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
510         return true;
511     }
512 
513     /**
514      * @dev Moves tokens `amount` from `sender` to `recipient`.
515      *
516      * This is internal function is equivalent to {transfer}, and can be used to
517      * e.g. implement automatic token fees, slashing mechanisms, etc.
518      *
519      * Emits a {Transfer} event.
520      *
521      * Requirements:
522      *
523      * - `sender` cannot be the zero address.
524      * - `recipient` cannot be the zero address.
525      * - `sender` must have a balance of at least `amount`.
526      */
527     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
528         require(sender != address(0), "ERC20: transfer from the zero address");
529         require(recipient != address(0), "ERC20: transfer to the zero address");
530 
531         _beforeTokenTransfer(sender, recipient, amount);
532 
533         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
534         _balances[recipient] = _balances[recipient].add(amount);
535         emit Transfer(sender, recipient, amount);
536     }
537 
538     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
539      * the total supply.
540      *
541      * Emits a {Transfer} event with `from` set to the zero address.
542      *
543      * Requirements:
544      *
545      * - `to` cannot be the zero address.
546      */
547     function _mint(address account, uint256 amount) internal virtual {
548         require(account != address(0), "ERC20: mint to the zero address");
549 
550         _beforeTokenTransfer(address(0), account, amount);
551 
552         _totalSupply = _totalSupply.add(amount);
553         _balances[account] = _balances[account].add(amount);
554         emit Transfer(address(0), account, amount);
555     }
556 
557     /**
558      * @dev Destroys `amount` tokens from `account`, reducing the
559      * total supply.
560      *
561      * Emits a {Transfer} event with `to` set to the zero address.
562      *
563      * Requirements:
564      *
565      * - `account` cannot be the zero address.
566      * - `account` must have at least `amount` tokens.
567      */
568     function _burn(address account, uint256 amount) internal virtual {
569         require(account != address(0), "ERC20: burn from the zero address");
570 
571         _beforeTokenTransfer(account, address(0), amount);
572 
573         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
574         _totalSupply = _totalSupply.sub(amount);
575         emit Transfer(account, address(0), amount);
576     }
577 
578     /**
579      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
580      *
581      * This internal function is equivalent to `approve`, and can be used to
582      * e.g. set automatic allowances for certain subsystems, etc.
583      *
584      * Emits an {Approval} event.
585      *
586      * Requirements:
587      *
588      * - `owner` cannot be the zero address.
589      * - `spender` cannot be the zero address.
590      */
591     function _approve(address owner, address spender, uint256 amount) internal virtual {
592         require(owner != address(0), "ERC20: approve from the zero address");
593         require(spender != address(0), "ERC20: approve to the zero address");
594 
595         _allowances[owner][spender] = amount;
596         emit Approval(owner, spender, amount);
597     }
598 
599     /**
600      * @dev Sets {decimals} to a value other than the default one of 18.
601      *
602      * WARNING: This function should only be called from the constructor. Most
603      * applications that interact with token contracts will not expect
604      * {decimals} to ever change, and may work incorrectly if it does.
605      */
606     function _setupDecimals(uint8 decimals_) internal virtual {
607         _decimals = decimals_;
608     }
609 
610     /**
611      * @dev Hook that is called before any transfer of tokens. This includes
612      * minting and burning.
613      *
614      * Calling conditions:
615      *
616      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
617      * will be to transferred to `to`.
618      * - when `from` is zero, `amount` tokens will be minted for `to`.
619      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
620      * - `from` and `to` are never both zero.
621      *
622      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
623      */
624     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
625 }
626 
627 pragma solidity ^0.7.1;
628 
629 
630 contract MILF is ERC20 {
631     constructor() ERC20("Milf Token", "MILF") public {
632         _mint(msg.sender, 10e28);
633     }
634 }