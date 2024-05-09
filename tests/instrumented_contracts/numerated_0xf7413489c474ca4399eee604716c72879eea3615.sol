1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         uint256 c = a + b;
121         if (c < a) return (false, 0);
122         return (true, c);
123     }
124 
125     /**
126      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         if (b > a) return (false, 0);
132         return (true, a - b);
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) return (true, 0);
145         uint256 c = a * b;
146         if (c / a != b) return (false, 0);
147         return (true, c);
148     }
149 
150     /**
151      * @dev Returns the division of two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         if (b == 0) return (false, 0);
157         return (true, a / b);
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (b == 0) return (false, 0);
167         return (true, a % b);
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         require(c >= a, "SafeMath: addition overflow");
183         return c;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         require(b <= a, "SafeMath: subtraction overflow");
198         return a - b;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      *
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         if (a == 0) return 0;
213         uint256 c = a * b;
214         require(c / a == b, "SafeMath: multiplication overflow");
215         return c;
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers, reverting on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0, "SafeMath: division by zero");
232         return a / b;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * reverting when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: modulo by zero");
249         return a % b;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
254      * overflow (when the result is negative).
255      *
256      * CAUTION: This function is deprecated because it requires allocating memory for the error
257      * message unnecessarily. For custom revert reasons use {trySub}.
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         return a - b;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
272      * division by zero. The result is rounded towards zero.
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {tryDiv}.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b > 0, errorMessage);
287         return a / b;
288     }
289 
290     /**
291      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
292      * reverting with custom message when dividing by zero.
293      *
294      * CAUTION: This function is deprecated because it requires allocating memory for the error
295      * message unnecessarily. For custom revert reasons use {tryMod}.
296      *
297      * Counterpart to Solidity's `%` operator. This function uses a `revert`
298      * opcode (which leaves remaining gas untouched) while Solidity uses an
299      * invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b > 0, errorMessage);
307         return a % b;
308     }
309 }
310 
311 /**
312  * @dev Implementation of the {IERC20} interface.
313  *
314  * This implementation is agnostic to the way tokens are created. This means
315  * that a supply mechanism has to be added in a derived contract using {_mint}.
316  * For a generic mechanism see {ERC20PresetMinterPauser}.
317  *
318  * TIP: For a detailed writeup see our guide
319  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
320  * to implement supply mechanisms].
321  *
322  * We have followed general OpenZeppelin guidelines: functions revert instead
323  * of returning `false` on failure. This behavior is nonetheless conventional
324  * and does not conflict with the expectations of ERC20 applications.
325  *
326  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
327  * This allows applications to reconstruct the allowance for all accounts just
328  * by listening to said events. Other implementations of the EIP may not emit
329  * these events, as it isn't required by the specification.
330  *
331  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
332  * functions have been added to mitigate the well-known issues around setting
333  * allowances. See {IERC20-approve}.
334  */
335 contract ERC20 is Context, IERC20 {
336     using SafeMath for uint256;
337 
338     mapping (address => uint256) private _balances;
339 
340     mapping (address => mapping (address => uint256)) private _allowances;
341 
342     uint256 private _totalSupply;
343 
344     string private _name;
345     string private _symbol;
346     uint8 private _decimals;
347 
348     /**
349      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
350      * a default value of 18.
351      *
352      * To select a different value for {decimals}, use {_setupDecimals}.
353      *
354      * All three of these values are immutable: they can only be set once during
355      * construction.
356      */
357     constructor (string memory name_, string memory symbol_) public {
358         _name = name_;
359         _symbol = symbol_;
360         _decimals = 18;
361     }
362 
363     /**
364      * @dev Returns the name of the token.
365      */
366     function name() public view virtual returns (string memory) {
367         return _name;
368     }
369 
370     /**
371      * @dev Returns the symbol of the token, usually a shorter version of the
372      * name.
373      */
374     function symbol() public view virtual returns (string memory) {
375         return _symbol;
376     }
377 
378     /**
379      * @dev Returns the number of decimals used to get its user representation.
380      * For example, if `decimals` equals `2`, a balance of `505` tokens should
381      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
382      *
383      * Tokens usually opt for a value of 18, imitating the relationship between
384      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
385      * called.
386      *
387      * NOTE: This information is only used for _display_ purposes: it in
388      * no way affects any of the arithmetic of the contract, including
389      * {IERC20-balanceOf} and {IERC20-transfer}.
390      */
391     function decimals() public view virtual returns (uint8) {
392         return _decimals;
393     }
394 
395     /**
396      * @dev See {IERC20-totalSupply}.
397      */
398     function totalSupply() public view virtual override returns (uint256) {
399         return _totalSupply;
400     }
401 
402     /**
403      * @dev See {IERC20-balanceOf}.
404      */
405     function balanceOf(address account) public view virtual override returns (uint256) {
406         return _balances[account];
407     }
408 
409     /**
410      * @dev See {IERC20-transfer}.
411      *
412      * Requirements:
413      *
414      * - `recipient` cannot be the zero address.
415      * - the caller must have a balance of at least `amount`.
416      */
417     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
418         _transfer(_msgSender(), recipient, amount);
419         return true;
420     }
421 
422     /**
423      * @dev See {IERC20-allowance}.
424      */
425     function allowance(address owner, address spender) public view virtual override returns (uint256) {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {IERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount) public virtual override returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-transferFrom}.
443      *
444      * Emits an {Approval} event indicating the updated allowance. This is not
445      * required by the EIP. See the note at the beginning of {ERC20}.
446      *
447      * Requirements:
448      *
449      * - `sender` and `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      * - the caller must have allowance for ``sender``'s tokens of at least
452      * `amount`.
453      */
454     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
455         _transfer(sender, recipient, amount);
456         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
457         return true;
458     }
459 
460     /**
461      * @dev Atomically increases the allowance granted to `spender` by the caller.
462      *
463      * This is an alternative to {approve} that can be used as a mitigation for
464      * problems described in {IERC20-approve}.
465      *
466      * Emits an {Approval} event indicating the updated allowance.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
473         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
474         return true;
475     }
476 
477     /**
478      * @dev Atomically decreases the allowance granted to `spender` by the caller.
479      *
480      * This is an alternative to {approve} that can be used as a mitigation for
481      * problems described in {IERC20-approve}.
482      *
483      * Emits an {Approval} event indicating the updated allowance.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      * - `spender` must have allowance for the caller of at least
489      * `subtractedValue`.
490      */
491     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
493         return true;
494     }
495 
496     /**
497      * @dev Moves tokens `amount` from `sender` to `recipient`.
498      *
499      * This is internal function is equivalent to {transfer}, and can be used to
500      * e.g. implement automatic token fees, slashing mechanisms, etc.
501      *
502      * Emits a {Transfer} event.
503      *
504      * Requirements:
505      *
506      * - `sender` cannot be the zero address.
507      * - `recipient` cannot be the zero address.
508      * - `sender` must have a balance of at least `amount`.
509      */
510     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
511         require(sender != address(0), "ERC20: transfer from the zero address");
512         require(recipient != address(0), "ERC20: transfer to the zero address");
513 
514         _beforeTokenTransfer(sender, recipient, amount);
515 
516         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
517         _balances[recipient] = _balances[recipient].add(amount);
518         emit Transfer(sender, recipient, amount);
519     }
520 
521     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
522      * the total supply.
523      *
524      * Emits a {Transfer} event with `from` set to the zero address.
525      *
526      * Requirements:
527      *
528      * - `to` cannot be the zero address.
529      */
530     function _mint(address account, uint256 amount) internal virtual {
531         require(account != address(0), "ERC20: mint to the zero address");
532 
533         _beforeTokenTransfer(address(0), account, amount);
534 
535         _totalSupply = _totalSupply.add(amount);
536         _balances[account] = _balances[account].add(amount);
537         emit Transfer(address(0), account, amount);
538     }
539 
540     /**
541      * @dev Destroys `amount` tokens from `account`, reducing the
542      * total supply.
543      *
544      * Emits a {Transfer} event with `to` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `account` cannot be the zero address.
549      * - `account` must have at least `amount` tokens.
550      */
551     function _burn(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: burn from the zero address");
553 
554         _beforeTokenTransfer(account, address(0), amount);
555 
556         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
557         _totalSupply = _totalSupply.sub(amount);
558         emit Transfer(account, address(0), amount);
559     }
560 
561     /**
562      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
563      *
564      * This internal function is equivalent to `approve`, and can be used to
565      * e.g. set automatic allowances for certain subsystems, etc.
566      *
567      * Emits an {Approval} event.
568      *
569      * Requirements:
570      *
571      * - `owner` cannot be the zero address.
572      * - `spender` cannot be the zero address.
573      */
574     function _approve(address owner, address spender, uint256 amount) internal virtual {
575         require(owner != address(0), "ERC20: approve from the zero address");
576         require(spender != address(0), "ERC20: approve to the zero address");
577 
578         _allowances[owner][spender] = amount;
579         emit Approval(owner, spender, amount);
580     }
581 
582     /**
583      * @dev Sets {decimals} to a value other than the default one of 18.
584      *
585      * WARNING: This function should only be called from the constructor. Most
586      * applications that interact with token contracts will not expect
587      * {decimals} to ever change, and may work incorrectly if it does.
588      */
589     function _setupDecimals(uint8 decimals_) internal virtual {
590         _decimals = decimals_;
591     }
592 
593     /**
594      * @dev Hook that is called before any transfer of tokens. This includes
595      * minting and burning.
596      *
597      * Calling conditions:
598      *
599      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
600      * will be to transferred to `to`.
601      * - when `from` is zero, `amount` tokens will be minted for `to`.
602      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
603      * - `from` and `to` are never both zero.
604      *
605      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
606      */
607     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
608 }
609 
610 contract Token is ERC20 {
611 
612     uint256 constant private TOTAL_SUPPLY = 100000000 ether;
613 
614     constructor() public ERC20("APYSwap", "APYS") {
615         _mint(_msgSender(), TOTAL_SUPPLY);
616     }
617 }