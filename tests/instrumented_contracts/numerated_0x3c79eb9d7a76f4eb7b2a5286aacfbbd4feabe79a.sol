1 /*
2 Website: https://dogtick.vip
3 Channel: https://t.me/DogTickVip
4 Portal: https://t.me/DogTick
5 Twitter: https://twitter.com/DogTickVip
6 Medium: https://medium.com/@dogtickvip
7 Email: admin@dogtick.vip
8 */
9 
10 // File: @openzeppelin/contracts/utils/Context.sol
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity >=0.6.0 <0.8.0;
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
38 
39 
40 pragma solidity >=0.6.0 <0.8.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: @openzeppelin/contracts/math/SafeMath.sol
117 
118 
119 pragma solidity >=0.6.0 <0.8.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         uint256 c = a + b;
142         if (c < a) return (false, 0);
143         return (true, c);
144     }
145 
146     /**
147      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         if (b > a) return (false, 0);
153         return (true, a - b);
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) return (true, 0);
166         uint256 c = a * b;
167         if (c / a != b) return (false, 0);
168         return (true, c);
169     }
170 
171     /**
172      * @dev Returns the division of two unsigned integers, with a division by zero flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         if (b == 0) return (false, 0);
178         return (true, a / b);
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         if (b == 0) return (false, 0);
188         return (true, a % b);
189     }
190 
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204         return c;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b <= a, "SafeMath: subtraction overflow");
219         return a - b;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      *
230      * - Multiplication cannot overflow.
231      */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         if (a == 0) return 0;
234         uint256 c = a * b;
235         require(c / a == b, "SafeMath: multiplication overflow");
236         return c;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers, reverting on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: division by zero");
253         return a / b;
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * reverting when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         require(b > 0, "SafeMath: modulo by zero");
270         return a % b;
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
275      * overflow (when the result is negative).
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {trySub}.
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b <= a, errorMessage);
288         return a - b;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {tryDiv}.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         require(b > 0, errorMessage);
308         return a / b;
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * reverting with custom message when dividing by zero.
314      *
315      * CAUTION: This function is deprecated because it requires allocating memory for the error
316      * message unnecessarily. For custom revert reasons use {tryMod}.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b > 0, errorMessage);
328         return a % b;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
333 
334 
335 pragma solidity >=0.6.0 <0.8.0;
336 
337 
338 
339 
340 /**
341  * @dev Implementation of the {IERC20} interface.
342  *
343  * This implementation is agnostic to the way tokens are created. This means
344  * that a supply mechanism has to be added in a derived contract using {_mint}.
345  * For a generic mechanism see {ERC20PresetMinterPauser}.
346  *
347  * TIP: For a detailed writeup see our guide
348  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
349  * to implement supply mechanisms].
350  *
351  * We have followed general OpenZeppelin guidelines: functions revert instead
352  * of returning `false` on failure. This behavior is nonetheless conventional
353  * and does not conflict with the expectations of ERC20 applications.
354  *
355  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
356  * This allows applications to reconstruct the allowance for all accounts just
357  * by listening to said events. Other implementations of the EIP may not emit
358  * these events, as it isn't required by the specification.
359  *
360  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
361  * functions have been added to mitigate the well-known issues around setting
362  * allowances. See {IERC20-approve}.
363  */
364 contract ERC20 is Context, IERC20 {
365     using SafeMath for uint256;
366 
367     mapping (address => uint256) private _balances;
368 
369     mapping (address => mapping (address => uint256)) private _allowances;
370 
371     uint256 private _totalSupply;
372 
373     string private _name;
374     string private _symbol;
375     uint8 private _decimals;
376 
377     /**
378      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
379      * a default value of 18.
380      *
381      * To select a different value for {decimals}, use {_setupDecimals}.
382      *
383      * All three of these values are immutable: they can only be set once during
384      * construction.
385      */
386     constructor (string memory name_, string memory symbol_) {
387         _name = name_;
388         _symbol = symbol_;
389         _decimals = 18;
390     }
391 
392     /**
393      * @dev Returns the name of the token.
394      */
395     function name() public view virtual returns (string memory) {
396         return _name;
397     }
398 
399     /**
400      * @dev Returns the symbol of the token, usually a shorter version of the
401      * name.
402      */
403     function symbol() public view virtual returns (string memory) {
404         return _symbol;
405     }
406 
407     /**
408      * @dev Returns the number of decimals used to get its user representation.
409      * For example, if `decimals` equals `2`, a balance of `505` tokens should
410      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
411      *
412      * Tokens usually opt for a value of 18, imitating the relationship between
413      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
414      * called.
415      *
416      * NOTE: This information is only used for _display_ purposes: it in
417      * no way affects any of the arithmetic of the contract, including
418      * {IERC20-balanceOf} and {IERC20-transfer}.
419      */
420     function decimals() public view virtual returns (uint8) {
421         return _decimals;
422     }
423 
424     /**
425      * @dev See {IERC20-totalSupply}.
426      */
427     function totalSupply() public view virtual override returns (uint256) {
428         return _totalSupply;
429     }
430 
431     /**
432      * @dev See {IERC20-balanceOf}.
433      */
434     function balanceOf(address account) public view virtual override returns (uint256) {
435         return _balances[account];
436     }
437 
438     /**
439      * @dev See {IERC20-transfer}.
440      *
441      * Requirements:
442      *
443      * - `recipient` cannot be the zero address.
444      * - the caller must have a balance of at least `amount`.
445      */
446     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
447         _transfer(_msgSender(), recipient, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-allowance}.
453      */
454     function allowance(address owner, address spender) public view virtual override returns (uint256) {
455         return _allowances[owner][spender];
456     }
457 
458     /**
459      * @dev See {IERC20-approve}.
460      *
461      * Requirements:
462      *
463      * - `spender` cannot be the zero address.
464      */
465     function approve(address spender, uint256 amount) public virtual override returns (bool) {
466         _approve(_msgSender(), spender, amount);
467         return true;
468     }
469 
470     /**
471      * @dev See {IERC20-transferFrom}.
472      *
473      * Emits an {Approval} event indicating the updated allowance. This is not
474      * required by the EIP. See the note at the beginning of {ERC20}.
475      *
476      * Requirements:
477      *
478      * - `sender` and `recipient` cannot be the zero address.
479      * - `sender` must have a balance of at least `amount`.
480      * - the caller must have allowance for ``sender``'s tokens of at least
481      * `amount`.
482      */
483     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
484         _transfer(sender, recipient, amount);
485         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
486         return true;
487     }
488 
489     /**
490      * @dev Atomically increases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to {approve} that can be used as a mitigation for
493      * problems described in {IERC20-approve}.
494      *
495      * Emits an {Approval} event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      */
501     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
503         return true;
504     }
505 
506     /**
507      * @dev Atomically decreases the allowance granted to `spender` by the caller.
508      *
509      * This is an alternative to {approve} that can be used as a mitigation for
510      * problems described in {IERC20-approve}.
511      *
512      * Emits an {Approval} event indicating the updated allowance.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      * - `spender` must have allowance for the caller of at least
518      * `subtractedValue`.
519      */
520     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
522         return true;
523     }
524 
525     /**
526      * @dev Moves tokens `amount` from `sender` to `recipient`.
527      *
528      * This is internal function is equivalent to {transfer}, and can be used to
529      * e.g. implement automatic token fees, slashing mechanisms, etc.
530      *
531      * Emits a {Transfer} event.
532      *
533      * Requirements:
534      *
535      * - `sender` cannot be the zero address.
536      * - `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      */
539     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
540         require(sender != address(0), "ERC20: transfer from the zero address");
541         require(recipient != address(0), "ERC20: transfer to the zero address");
542 
543         _beforeTokenTransfer(sender, recipient, amount);
544 
545         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
546         _balances[recipient] = _balances[recipient].add(amount);
547         emit Transfer(sender, recipient, amount);
548     }
549 
550     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
551      * the total supply.
552      *
553      * Emits a {Transfer} event with `from` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `to` cannot be the zero address.
558      */
559     function _mint(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _beforeTokenTransfer(address(0), account, amount);
563 
564         _totalSupply = _totalSupply.add(amount);
565         _balances[account] = _balances[account].add(amount);
566         emit Transfer(address(0), account, amount);
567     }
568 
569     /**
570      * @dev Destroys `amount` tokens from `account`, reducing the
571      * total supply.
572      *
573      * Emits a {Transfer} event with `to` set to the zero address.
574      *
575      * Requirements:
576      *
577      * - `account` cannot be the zero address.
578      * - `account` must have at least `amount` tokens.
579      */
580     function _burn(address account, uint256 amount) internal virtual {
581         require(account != address(0), "ERC20: burn from the zero address");
582 
583         _beforeTokenTransfer(account, address(0), amount);
584 
585         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
586         _totalSupply = _totalSupply.sub(amount);
587         emit Transfer(account, address(0), amount);
588     }
589 
590     /**
591      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
592      *
593      * This internal function is equivalent to `approve`, and can be used to
594      * e.g. set automatic allowances for certain subsystems, etc.
595      *
596      * Emits an {Approval} event.
597      *
598      * Requirements:
599      *
600      * - `owner` cannot be the zero address.
601      * - `spender` cannot be the zero address.
602      */
603     function _approve(address owner, address spender, uint256 amount) internal virtual {
604         require(owner != address(0), "ERC20: approve from the zero address");
605         require(spender != address(0), "ERC20: approve to the zero address");
606 
607         _allowances[owner][spender] = amount;
608         emit Approval(owner, spender, amount);
609     }
610 
611     /**
612      * @dev Sets {decimals} to a value other than the default one of 18.
613      *
614      * WARNING: This function should only be called from the constructor. Most
615      * applications that interact with token contracts will not expect
616      * {decimals} to ever change, and may work incorrectly if it does.
617      */
618     function _setupDecimals(uint8 decimals_) internal virtual {
619         _decimals = decimals_;
620     }
621 
622     /**
623      * @dev Hook that is called before any transfer of tokens. This includes
624      * minting and burning.
625      *
626      * Calling conditions:
627      *
628      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
629      * will be to transferred to `to`.
630      * - when `from` is zero, `amount` tokens will be minted for `to`.
631      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
632      * - `from` and `to` are never both zero.
633      *
634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
635      */
636     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
637 }
638 
639 // File: contracts/DogTick.sol
640 
641 pragma solidity ^0.7.1;
642 
643 
644 contract DogTick is ERC20 {
645     constructor() ERC20("DogTick", "DOGTIC") {
646         _mint(msg.sender, 69e27);
647     }
648 }