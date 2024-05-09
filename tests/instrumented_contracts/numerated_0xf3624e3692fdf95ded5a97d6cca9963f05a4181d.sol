1 pragma solidity >=0.6.0 <0.8.0;
2 
3 /*
4 WEBSITE: https://shibaelon.org/
5 
6 TELEGRAM: t.me/shibaelon
7 
8 TWITTER: https://twitter.com/shiba_elon
9 
10 UNISWAP: https://app.uniswap.org/#/swap?inputCurrency=0xf3624e3692fdf95ded5a97d6cca9963f05a4181d&outputCurrency=ETH
11 
12 ETHERSCAN: https://etherscan.io/token/0xf3624e3692fdf95ded5a97d6cca9963f05a4181d
13 
14 DEXTOOLS: https://www.dextools.io/app/uniswap/pair-explorer/0xdbb95f254e2fc749b8785f84580d6df59a66ccce
15 */
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
39 
40 
41 pragma solidity >=0.6.0 <0.8.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 // File: @openzeppelin/contracts/math/SafeMath.sol
118 
119 
120 pragma solidity >=0.6.0 <0.8.0;
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, with an overflow flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         uint256 c = a + b;
143         if (c < a) return (false, 0);
144         return (true, c);
145     }
146 
147     /**
148      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
149      *
150      * _Available since v3.4._
151      */
152     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         if (b > a) return (false, 0);
154         return (true, a - b);
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) return (true, 0);
167         uint256 c = a * b;
168         if (c / a != b) return (false, 0);
169         return (true, c);
170     }
171 
172     /**
173      * @dev Returns the division of two unsigned integers, with a division by zero flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
178         if (b == 0) return (false, 0);
179         return (true, a / b);
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         if (b == 0) return (false, 0);
189         return (true, a % b);
190     }
191 
192     /**
193      * @dev Returns the addition of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `+` operator.
197      *
198      * Requirements:
199      *
200      * - Addition cannot overflow.
201      */
202     function add(uint256 a, uint256 b) internal pure returns (uint256) {
203         uint256 c = a + b;
204         require(c >= a, "SafeMath: addition overflow");
205         return c;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      *
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b <= a, "SafeMath: subtraction overflow");
220         return a - b;
221     }
222 
223     /**
224      * @dev Returns the multiplication of two unsigned integers, reverting on
225      * overflow.
226      *
227      * Counterpart to Solidity's `*` operator.
228      *
229      * Requirements:
230      *
231      * - Multiplication cannot overflow.
232      */
233     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234         if (a == 0) return 0;
235         uint256 c = a * b;
236         require(c / a == b, "SafeMath: multiplication overflow");
237         return c;
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers, reverting on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator. Note: this function uses a
245      * `revert` opcode (which leaves remaining gas untouched) while Solidity
246      * uses an invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function div(uint256 a, uint256 b) internal pure returns (uint256) {
253         require(b > 0, "SafeMath: division by zero");
254         return a / b;
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * reverting when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         require(b > 0, "SafeMath: modulo by zero");
271         return a % b;
272     }
273 
274     /**
275      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
276      * overflow (when the result is negative).
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {trySub}.
280      *
281      * Counterpart to Solidity's `-` operator.
282      *
283      * Requirements:
284      *
285      * - Subtraction cannot overflow.
286      */
287     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b <= a, errorMessage);
289         return a - b;
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * CAUTION: This function is deprecated because it requires allocating memory for the error
297      * message unnecessarily. For custom revert reasons use {tryDiv}.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         require(b > 0, errorMessage);
309         return a / b;
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * reverting with custom message when dividing by zero.
315      *
316      * CAUTION: This function is deprecated because it requires allocating memory for the error
317      * message unnecessarily. For custom revert reasons use {tryMod}.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b > 0, errorMessage);
329         return a % b;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
334 
335 
336 pragma solidity >=0.6.0 <0.8.0;
337 
338 
339 /**
340  * @dev Implementation of the {IERC20} interface.
341  *
342  * This implementation is agnostic to the way tokens are created. This means
343  * that a supply mechanism has to be added in a derived contract using {_mint}.
344  * For a generic mechanism see {ERC20PresetMinterPauser}.
345  *
346  * TIP: For a detailed writeup see our guide
347  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
348  * to implement supply mechanisms].
349  *
350  * We have followed general OpenZeppelin guidelines: functions revert instead
351  * of returning `false` on failure. This behavior is nonetheless conventional
352  * and does not conflict with the expectations of ERC20 applications.
353  *
354  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
355  * This allows applications to reconstruct the allowance for all accounts just
356  * by listening to said events. Other implementations of the EIP may not emit
357  * these events, as it isn't required by the specification.
358  *
359  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
360  * functions have been added to mitigate the well-known issues around setting
361  * allowances. See {IERC20-approve}.
362  */
363 contract ERC20 is Context, IERC20 {
364     using SafeMath for uint256;
365 
366     mapping (address => uint256) private _balances;
367 
368     mapping (address => mapping (address => uint256)) private _allowances;
369 
370     uint256 private _totalSupply;
371 
372     string private _name;
373     string private _symbol;
374     uint8 private _decimals;
375 
376     /**
377      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
378      * a default value of 18.
379      *
380      * To select a different value for {decimals}, use {_setupDecimals}.
381      *
382      * All three of these values are immutable: they can only be set once during
383      * construction.
384      */
385     constructor (string memory name_, string memory symbol_) public {
386         _name = name_;
387         _symbol = symbol_;
388         _decimals = 18;
389     }
390 
391     /**
392      * @dev Returns the name of the token.
393      */
394     function name() public view virtual returns (string memory) {
395         return _name;
396     }
397 
398     /**
399      * @dev Returns the symbol of the token, usually a shorter version of the
400      * name.
401      */
402     function symbol() public view virtual returns (string memory) {
403         return _symbol;
404     }
405 
406     /**
407      * @dev Returns the number of decimals used to get its user representation.
408      * For example, if `decimals` equals `2`, a balance of `505` tokens should
409      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
410      *
411      * Tokens usually opt for a value of 18, imitating the relationship between
412      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
413      * called.
414      *
415      * NOTE: This information is only used for _display_ purposes: it in
416      * no way affects any of the arithmetic of the contract, including
417      * {IERC20-balanceOf} and {IERC20-transfer}.
418      */
419     function decimals() public view virtual returns (uint8) {
420         return _decimals;
421     }
422 
423     /**
424      * @dev See {IERC20-totalSupply}.
425      */
426     function totalSupply() public view virtual override returns (uint256) {
427         return _totalSupply;
428     }
429 
430     /**
431      * @dev See {IERC20-balanceOf}.
432      */
433     function balanceOf(address account) public view virtual override returns (uint256) {
434         return _balances[account];
435     }
436 
437     /**
438      * @dev See {IERC20-transfer}.
439      *
440      * Requirements:
441      *
442      * - `recipient` cannot be the zero address.
443      * - the caller must have a balance of at least `amount`.
444      */
445     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
446         _transfer(_msgSender(), recipient, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-allowance}.
452      */
453     function allowance(address owner, address spender) public view virtual override returns (uint256) {
454         return _allowances[owner][spender];
455     }
456 
457     /**
458      * @dev See {IERC20-approve}.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function approve(address spender, uint256 amount) public virtual override returns (bool) {
465         _approve(_msgSender(), spender, amount);
466         return true;
467     }
468 
469     /**
470      * @dev See {IERC20-transferFrom}.
471      *
472      * Emits an {Approval} event indicating the updated allowance. This is not
473      * required by the EIP. See the note at the beginning of {ERC20}.
474      *
475      * Requirements:
476      *
477      * - `sender` and `recipient` cannot be the zero address.
478      * - `sender` must have a balance of at least `amount`.
479      * - the caller must have allowance for ``sender``'s tokens of at least
480      * `amount`.
481      */
482     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
483         _transfer(sender, recipient, amount);
484         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
485         return true;
486     }
487 
488     /**
489      * @dev Atomically increases the allowance granted to `spender` by the caller.
490      *
491      * This is an alternative to {approve} that can be used as a mitigation for
492      * problems described in {IERC20-approve}.
493      *
494      * Emits an {Approval} event indicating the updated allowance.
495      *
496      * Requirements:
497      *
498      * - `spender` cannot be the zero address.
499      */
500     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
502         return true;
503     }
504 
505     /**
506      * @dev Atomically decreases the allowance granted to `spender` by the caller.
507      *
508      * This is an alternative to {approve} that can be used as a mitigation for
509      * problems described in {IERC20-approve}.
510      *
511      * Emits an {Approval} event indicating the updated allowance.
512      *
513      * Requirements:
514      *
515      * - `spender` cannot be the zero address.
516      * - `spender` must have allowance for the caller of at least
517      * `subtractedValue`.
518      */
519     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
520         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
521         return true;
522     }
523 
524     /**
525      * @dev Moves tokens `amount` from `sender` to `recipient`.
526      *
527      * This is internal function is equivalent to {transfer}, and can be used to
528      * e.g. implement automatic token fees, slashing mechanisms, etc.
529      *
530      * Emits a {Transfer} event.
531      *
532      * Requirements:
533      *
534      * - `sender` cannot be the zero address.
535      * - `recipient` cannot be the zero address.
536      * - `sender` must have a balance of at least `amount`.
537      */
538     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
539         require(sender != address(0), "ERC20: transfer from the zero address");
540         require(recipient != address(0), "ERC20: transfer to the zero address");
541 
542         _beforeTokenTransfer(sender, recipient, amount);
543 
544         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
545         _balances[recipient] = _balances[recipient].add(amount);
546         emit Transfer(sender, recipient, amount);
547     }
548 
549     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
550      * the total supply.
551      *
552      * Emits a {Transfer} event with `from` set to the zero address.
553      *
554      * Requirements:
555      *
556      * - `to` cannot be the zero address.
557      */
558     function _mint(address account, uint256 amount) internal virtual {
559         require(account != address(0), "ERC20: mint to the zero address");
560 
561         _beforeTokenTransfer(address(0), account, amount);
562 
563         _totalSupply = _totalSupply.add(amount);
564         _balances[account] = _balances[account].add(amount);
565         emit Transfer(address(0), account, amount);
566     }
567 
568     /**
569      * @dev Destroys `amount` tokens from `account`, reducing the
570      * total supply.
571      *
572      * Emits a {Transfer} event with `to` set to the zero address.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      * - `account` must have at least `amount` tokens.
578      */
579     function _burn(address account, uint256 amount) internal virtual {
580         require(account != address(0), "ERC20: burn from the zero address");
581 
582         _beforeTokenTransfer(account, address(0), amount);
583 
584         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
585         _totalSupply = _totalSupply.sub(amount);
586         emit Transfer(account, address(0), amount);
587     }
588 
589     /**
590      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
591      *
592      * This internal function is equivalent to `approve`, and can be used to
593      * e.g. set automatic allowances for certain subsystems, etc.
594      *
595      * Emits an {Approval} event.
596      *
597      * Requirements:
598      *
599      * - `owner` cannot be the zero address.
600      * - `spender` cannot be the zero address.
601      */
602     function _approve(address owner, address spender, uint256 amount) internal virtual {
603         require(owner != address(0), "ERC20: approve from the zero address");
604         require(spender != address(0), "ERC20: approve to the zero address");
605 
606         _allowances[owner][spender] = amount;
607         emit Approval(owner, spender, amount);
608     }
609 
610     /**
611      * @dev Sets {decimals} to a value other than the default one of 18.
612      *
613      * WARNING: This function should only be called from the constructor. Most
614      * applications that interact with token contracts will not expect
615      * {decimals} to ever change, and may work incorrectly if it does.
616      */
617     function _setupDecimals(uint8 decimals_) internal virtual {
618         _decimals = decimals_;
619     }
620 
621     /**
622      * @dev Hook that is called before any transfer of tokens. This includes
623      * minting and burning.
624      *
625      * Calling conditions:
626      *
627      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
628      * will be to transferred to `to`.
629      * - when `from` is zero, `amount` tokens will be minted for `to`.
630      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
631      * - `from` and `to` are never both zero.
632      *
633      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
634      */
635     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
636 }
637 
638 // File: contracts/ShibaElon.sol
639 
640 // contracts/ShibaElon.sol
641 pragma solidity ^0.7.1;
642 
643 
644 contract ShibaElon is ERC20 {
645     constructor() ERC20("ShibaElon", "SELON") public {
646         _mint(msg.sender, 10e32);
647     }
648 }