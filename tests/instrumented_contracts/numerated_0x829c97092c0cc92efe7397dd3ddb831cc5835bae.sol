1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 pragma solidity >=0.6.0 <0.8.0;
84 
85 /*
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with GSN meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address payable) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes memory) {
101         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
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
320 pragma solidity >=0.6.0 <0.8.0;
321 
322 
323 
324 
325 /**
326  * @dev Implementation of the {IERC20} interface.
327  *
328  * This implementation is agnostic to the way tokens are created. This means
329  * that a supply mechanism has to be added in a derived contract using {_mint}.
330  * For a generic mechanism see {ERC20PresetMinterPauser}.
331  *
332  * TIP: For a detailed writeup see our guide
333  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
334  * to implement supply mechanisms].
335  *
336  * We have followed general OpenZeppelin guidelines: functions revert instead
337  * of returning `false` on failure. This behavior is nonetheless conventional
338  * and does not conflict with the expectations of ERC20 applications.
339  *
340  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
341  * This allows applications to reconstruct the allowance for all accounts just
342  * by listening to said events. Other implementations of the EIP may not emit
343  * these events, as it isn't required by the specification.
344  *
345  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
346  * functions have been added to mitigate the well-known issues around setting
347  * allowances. See {IERC20-approve}.
348  */
349 contract ERC20 is Context, IERC20 {
350     using SafeMath for uint256;
351 
352     mapping (address => uint256) private _balances;
353 
354     mapping (address => mapping (address => uint256)) private _allowances;
355 
356     uint256 private _totalSupply;
357 
358     string private _name;
359     string private _symbol;
360     uint8 private _decimals;
361 
362     /**
363      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
364      * a default value of 18.
365      *
366      * To select a different value for {decimals}, use {_setupDecimals}.
367      *
368      * All three of these values are immutable: they can only be set once during
369      * construction.
370      */
371     constructor (string memory name_, string memory symbol_) public {
372         _name = name_;
373         _symbol = symbol_;
374         _decimals = 18;
375     }
376 
377     /**
378      * @dev Returns the name of the token.
379      */
380     function name() public view virtual returns (string memory) {
381         return _name;
382     }
383 
384     /**
385      * @dev Returns the symbol of the token, usually a shorter version of the
386      * name.
387      */
388     function symbol() public view virtual returns (string memory) {
389         return _symbol;
390     }
391 
392     /**
393      * @dev Returns the number of decimals used to get its user representation.
394      * For example, if `decimals` equals `2`, a balance of `505` tokens should
395      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
396      *
397      * Tokens usually opt for a value of 18, imitating the relationship between
398      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
399      * called.
400      *
401      * NOTE: This information is only used for _display_ purposes: it in
402      * no way affects any of the arithmetic of the contract, including
403      * {IERC20-balanceOf} and {IERC20-transfer}.
404      */
405     function decimals() public view virtual returns (uint8) {
406         return _decimals;
407     }
408 
409     /**
410      * @dev See {IERC20-totalSupply}.
411      */
412     function totalSupply() public view virtual override returns (uint256) {
413         return _totalSupply;
414     }
415 
416     /**
417      * @dev See {IERC20-balanceOf}.
418      */
419     function balanceOf(address account) public view virtual override returns (uint256) {
420         return _balances[account];
421     }
422 
423     /**
424      * @dev See {IERC20-transfer}.
425      *
426      * Requirements:
427      *
428      * - `recipient` cannot be the zero address.
429      * - the caller must have a balance of at least `amount`.
430      */
431     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
432         _transfer(_msgSender(), recipient, amount);
433         return true;
434     }
435 
436     /**
437      * @dev See {IERC20-allowance}.
438      */
439     function allowance(address owner, address spender) public view virtual override returns (uint256) {
440         return _allowances[owner][spender];
441     }
442 
443     /**
444      * @dev See {IERC20-approve}.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      */
450     function approve(address spender, uint256 amount) public virtual override returns (bool) {
451         _approve(_msgSender(), spender, amount);
452         return true;
453     }
454 
455     /**
456      * @dev See {IERC20-transferFrom}.
457      *
458      * Emits an {Approval} event indicating the updated allowance. This is not
459      * required by the EIP. See the note at the beginning of {ERC20}.
460      *
461      * Requirements:
462      *
463      * - `sender` and `recipient` cannot be the zero address.
464      * - `sender` must have a balance of at least `amount`.
465      * - the caller must have allowance for ``sender``'s tokens of at least
466      * `amount`.
467      */
468     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
469         _transfer(sender, recipient, amount);
470         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
471         return true;
472     }
473 
474     /**
475      * @dev Atomically increases the allowance granted to `spender` by the caller.
476      *
477      * This is an alternative to {approve} that can be used as a mitigation for
478      * problems described in {IERC20-approve}.
479      *
480      * Emits an {Approval} event indicating the updated allowance.
481      *
482      * Requirements:
483      *
484      * - `spender` cannot be the zero address.
485      */
486     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
487         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
488         return true;
489     }
490 
491     /**
492      * @dev Atomically decreases the allowance granted to `spender` by the caller.
493      *
494      * This is an alternative to {approve} that can be used as a mitigation for
495      * problems described in {IERC20-approve}.
496      *
497      * Emits an {Approval} event indicating the updated allowance.
498      *
499      * Requirements:
500      *
501      * - `spender` cannot be the zero address.
502      * - `spender` must have allowance for the caller of at least
503      * `subtractedValue`.
504      */
505     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
507         return true;
508     }
509 
510     /**
511      * @dev Moves tokens `amount` from `sender` to `recipient`.
512      *
513      * This is internal function is equivalent to {transfer}, and can be used to
514      * e.g. implement automatic token fees, slashing mechanisms, etc.
515      *
516      * Emits a {Transfer} event.
517      *
518      * Requirements:
519      *
520      * - `sender` cannot be the zero address.
521      * - `recipient` cannot be the zero address.
522      * - `sender` must have a balance of at least `amount`.
523      */
524     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
525         require(sender != address(0), "ERC20: transfer from the zero address");
526         require(recipient != address(0), "ERC20: transfer to the zero address");
527 
528         _beforeTokenTransfer(sender, recipient, amount);
529 
530         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
531         _balances[recipient] = _balances[recipient].add(amount);
532         emit Transfer(sender, recipient, amount);
533     }
534 
535     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
536      * the total supply.
537      *
538      * Emits a {Transfer} event with `from` set to the zero address.
539      *
540      * Requirements:
541      *
542      * - `to` cannot be the zero address.
543      */
544     function _mint(address account, uint256 amount) internal virtual {
545         require(account != address(0), "ERC20: mint to the zero address");
546 
547         _beforeTokenTransfer(address(0), account, amount);
548 
549         _totalSupply = _totalSupply.add(amount);
550         _balances[account] = _balances[account].add(amount);
551         emit Transfer(address(0), account, amount);
552     }
553 
554     /**
555      * @dev Destroys `amount` tokens from `account`, reducing the
556      * total supply.
557      *
558      * Emits a {Transfer} event with `to` set to the zero address.
559      *
560      * Requirements:
561      *
562      * - `account` cannot be the zero address.
563      * - `account` must have at least `amount` tokens.
564      */
565     function _burn(address account, uint256 amount) internal virtual {
566         require(account != address(0), "ERC20: burn from the zero address");
567 
568         _beforeTokenTransfer(account, address(0), amount);
569 
570         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
571         _totalSupply = _totalSupply.sub(amount);
572         emit Transfer(account, address(0), amount);
573     }
574 
575     /**
576      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
577      *
578      * This internal function is equivalent to `approve`, and can be used to
579      * e.g. set automatic allowances for certain subsystems, etc.
580      *
581      * Emits an {Approval} event.
582      *
583      * Requirements:
584      *
585      * - `owner` cannot be the zero address.
586      * - `spender` cannot be the zero address.
587      */
588     function _approve(address owner, address spender, uint256 amount) internal virtual {
589         require(owner != address(0), "ERC20: approve from the zero address");
590         require(spender != address(0), "ERC20: approve to the zero address");
591 
592         _allowances[owner][spender] = amount;
593         emit Approval(owner, spender, amount);
594     }
595 
596     /**
597      * @dev Sets {decimals} to a value other than the default one of 18.
598      *
599      * WARNING: This function should only be called from the constructor. Most
600      * applications that interact with token contracts will not expect
601      * {decimals} to ever change, and may work incorrectly if it does.
602      */
603     function _setupDecimals(uint8 decimals_) internal virtual {
604         _decimals = decimals_;
605     }
606 
607     /**
608      * @dev Hook that is called before any transfer of tokens. This includes
609      * minting and burning.
610      *
611      * Calling conditions:
612      *
613      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
614      * will be to transferred to `to`.
615      * - when `from` is zero, `amount` tokens will be minted for `to`.
616      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
617      * - `from` and `to` are never both zero.
618      *
619      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
620      */
621     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
622 }
623 
624 contract MineNetworkToken is ERC20 {
625 
626     mapping (address => uint256) private blacklist;
627     address private owner;
628 
629     constructor() ERC20("Mine Network Token", "MNET") public {
630         owner = _msgSender();
631         _mint(owner, 1_000_000_000 * (10 ** uint256(decimals())));
632     }   
633 }