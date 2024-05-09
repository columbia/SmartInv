1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.1;
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
325 pragma solidity >=0.6.0 <0.8.0;
326 
327 
328 
329 
330 /**
331  * @dev Implementation of the {IERC20} interface.
332  *
333  * This implementation is agnostic to the way tokens are created. This means
334  * that a supply mechanism has to be added in a derived contract using {_mint}.
335  * For a generic mechanism see {ERC20PresetMinterPauser}.
336  *
337  * TIP: For a detailed writeup see our guide
338  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
339  * to implement supply mechanisms].
340  *
341  * We have followed general OpenZeppelin guidelines: functions revert instead
342  * of returning `false` on failure. This behavior is nonetheless conventional
343  * and does not conflict with the expectations of ERC20 applications.
344  *
345  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
346  * This allows applications to reconstruct the allowance for all accounts just
347  * by listening to said events. Other implementations of the EIP may not emit
348  * these events, as it isn't required by the specification.
349  *
350  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
351  * functions have been added to mitigate the well-known issues around setting
352  * allowances. See {IERC20-approve}.
353  */
354 contract ERC20 is Context, IERC20 {
355     using SafeMath for uint256;
356 
357     mapping (address => uint256) private _balances;
358 
359     mapping (address => mapping (address => uint256)) private _allowances;
360 
361     uint256 private _totalSupply;
362 
363     string private _name;
364     string private _symbol;
365     uint8 private _decimals;
366 
367     /**
368      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
369      * a default value of 18.
370      *
371      * To select a different value for {decimals}, use {_setupDecimals}.
372      *
373      * All three of these values are immutable: they can only be set once during
374      * construction.
375      */
376     constructor (string memory name_, string memory symbol_) public {
377         _name = name_;
378         _symbol = symbol_;
379         _decimals = 18;
380     }
381 
382     /**
383      * @dev Returns the name of the token.
384      */
385     function name() public view virtual returns (string memory) {
386         return _name;
387     }
388 
389     /**
390      * @dev Returns the symbol of the token, usually a shorter version of the
391      * name.
392      */
393     function symbol() public view virtual returns (string memory) {
394         return _symbol;
395     }
396 
397     /**
398      * @dev Returns the number of decimals used to get its user representation.
399      * For example, if `decimals` equals `2`, a balance of `505` tokens should
400      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
401      *
402      * Tokens usually opt for a value of 18, imitating the relationship between
403      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
404      * called.
405      *
406      * NOTE: This information is only used for _display_ purposes: it in
407      * no way affects any of the arithmetic of the contract, including
408      * {IERC20-balanceOf} and {IERC20-transfer}.
409      */
410     function decimals() public view virtual returns (uint8) {
411         return _decimals;
412     }
413 
414     /**
415      * @dev See {IERC20-totalSupply}.
416      */
417     function totalSupply() public view virtual override returns (uint256) {
418         return _totalSupply;
419     }
420 
421     /**
422      * @dev See {IERC20-balanceOf}.
423      */
424     function balanceOf(address account) public view virtual override returns (uint256) {
425         return _balances[account];
426     }
427 
428     /**
429      * @dev See {IERC20-transfer}.
430      *
431      * Requirements:
432      *
433      * - `recipient` cannot be the zero address.
434      * - the caller must have a balance of at least `amount`.
435      */
436     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
437         _transfer(_msgSender(), recipient, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-allowance}.
443      */
444     function allowance(address owner, address spender) public view virtual override returns (uint256) {
445         return _allowances[owner][spender];
446     }
447 
448     /**
449      * @dev See {IERC20-approve}.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      */
455     function approve(address spender, uint256 amount) public virtual override returns (bool) {
456         _approve(_msgSender(), spender, amount);
457         return true;
458     }
459 
460     /**
461      * @dev See {IERC20-transferFrom}.
462      *
463      * Emits an {Approval} event indicating the updated allowance. This is not
464      * required by the EIP. See the note at the beginning of {ERC20}.
465      *
466      * Requirements:
467      *
468      * - `sender` and `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      * - the caller must have allowance for ``sender``'s tokens of at least
471      * `amount`.
472      */
473     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
476         return true;
477     }
478 
479     /**
480      * @dev Atomically increases the allowance granted to `spender` by the caller.
481      *
482      * This is an alternative to {approve} that can be used as a mitigation for
483      * problems described in {IERC20-approve}.
484      *
485      * Emits an {Approval} event indicating the updated allowance.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      */
491     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
493         return true;
494     }
495 
496     /**
497      * @dev Atomically decreases the allowance granted to `spender` by the caller.
498      *
499      * This is an alternative to {approve} that can be used as a mitigation for
500      * problems described in {IERC20-approve}.
501      *
502      * Emits an {Approval} event indicating the updated allowance.
503      *
504      * Requirements:
505      *
506      * - `spender` cannot be the zero address.
507      * - `spender` must have allowance for the caller of at least
508      * `subtractedValue`.
509      */
510     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
512         return true;
513     }
514 
515     /**
516      * @dev Moves tokens `amount` from `sender` to `recipient`.
517      *
518      * This is internal function is equivalent to {transfer}, and can be used to
519      * e.g. implement automatic token fees, slashing mechanisms, etc.
520      *
521      * Emits a {Transfer} event.
522      *
523      * Requirements:
524      *
525      * - `sender` cannot be the zero address.
526      * - `recipient` cannot be the zero address.
527      * - `sender` must have a balance of at least `amount`.
528      */
529     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
530         require(sender != address(0), "ERC20: transfer from the zero address");
531         require(recipient != address(0), "ERC20: transfer to the zero address");
532 
533         _beforeTokenTransfer(sender, recipient, amount);
534 
535         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
536         _balances[recipient] = _balances[recipient].add(amount);
537         emit Transfer(sender, recipient, amount);
538     }
539 
540     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
541      * the total supply.
542      *
543      * Emits a {Transfer} event with `from` set to the zero address.
544      *
545      * Requirements:
546      *
547      * - `to` cannot be the zero address.
548      */
549     function _mint(address account, uint256 amount) internal virtual {
550         require(account != address(0), "ERC20: mint to the zero address");
551 
552         _beforeTokenTransfer(address(0), account, amount);
553 
554         _totalSupply = _totalSupply.add(amount);
555         _balances[account] = _balances[account].add(amount);
556         emit Transfer(address(0), account, amount);
557     }
558 
559     /**
560      * @dev Destroys `amount` tokens from `account`, reducing the
561      * total supply.
562      *
563      * Emits a {Transfer} event with `to` set to the zero address.
564      *
565      * Requirements:
566      *
567      * - `account` cannot be the zero address.
568      * - `account` must have at least `amount` tokens.
569      */
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572 
573         _beforeTokenTransfer(account, address(0), amount);
574 
575         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
576         _totalSupply = _totalSupply.sub(amount);
577         emit Transfer(account, address(0), amount);
578     }
579 
580     /**
581      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
582      *
583      * This internal function is equivalent to `approve`, and can be used to
584      * e.g. set automatic allowances for certain subsystems, etc.
585      *
586      * Emits an {Approval} event.
587      *
588      * Requirements:
589      *
590      * - `owner` cannot be the zero address.
591      * - `spender` cannot be the zero address.
592      */
593     function _approve(address owner, address spender,
594     uint256 amount) internal virtual {
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
630 // File: contracts/FOY.sol
631 
632 pragma solidity >=0.6.0 <0.8.0;
633 
634 contract FundOfYours is ERC20 {
635     constructor(uint256 _initialSupply, string memory _name, string memory _symbol)  public ERC20 (_name, _symbol) {
636         _mint(msg.sender, _initialSupply * (10 ** uint256(decimals())));
637 
638     }
639 }