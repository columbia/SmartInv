1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 pragma solidity ^0.7.0;
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 pragma solidity ^0.7.0;
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 pragma solidity ^0.7.0;
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         uint256 c = a + b;
128         if (c < a) return (false, 0);
129         return (true, c);
130     }
131 
132     /**
133      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         if (b > a) return (false, 0);
139         return (true, a - b);
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) return (true, 0);
152         uint256 c = a * b;
153         if (c / a != b) return (false, 0);
154         return (true, c);
155     }
156 
157     /**
158      * @dev Returns the division of two unsigned integers, with a division by zero flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         if (b == 0) return (false, 0);
164         return (true, a / b);
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         if (b == 0) return (false, 0);
174         return (true, a % b);
175     }
176 
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `+` operator.
182      *
183      * Requirements:
184      *
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190         return c;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204         require(b <= a, "SafeMath: subtraction overflow");
205         return a - b;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      *
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         if (a == 0) return 0;
220         uint256 c = a * b;
221         require(c / a == b, "SafeMath: multiplication overflow");
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers, reverting on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b > 0, "SafeMath: division by zero");
239         return a / b;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         require(b > 0, "SafeMath: modulo by zero");
256         return a % b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
261      * overflow (when the result is negative).
262      *
263      * CAUTION: This function is deprecated because it requires allocating memory for the error
264      * message unnecessarily. For custom revert reasons use {trySub}.
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      *
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b <= a, errorMessage);
274         return a - b;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {tryDiv}.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         return a / b;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * reverting with custom message when dividing by zero.
300      *
301      * CAUTION: This function is deprecated because it requires allocating memory for the error
302      * message unnecessarily. For custom revert reasons use {tryMod}.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b > 0, errorMessage);
314         return a % b;
315     }
316 }
317 
318 /**
319  * @dev Implementation of the {IERC20} interface.
320  *
321  * This implementation is agnostic to the way tokens are created. This means
322  * that a supply mechanism has to be added in a derived contract using {_mint}.
323  * For a generic mechanism see {ERC20PresetMinterPauser}.
324  *
325  * TIP: For a detailed writeup see our guide
326  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
327  * to implement supply mechanisms].
328  *
329  * We have followed general OpenZeppelin guidelines: functions revert instead
330  * of returning `false` on failure. This behavior is nonetheless conventional
331  * and does not conflict with the expectations of ERC20 applications.
332  *
333  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
334  * This allows applications to reconstruct the allowance for all accounts just
335  * by listening to said events. Other implementations of the EIP may not emit
336  * these events, as it isn't required by the specification.
337  *
338  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
339  * functions have been added to mitigate the well-known issues around setting
340  * allowances. See {IERC20-approve}.
341  */
342 contract ERC20 is Context, IERC20 {
343     using SafeMath for uint256;
344 
345     mapping (address => uint256) private _balances;
346 
347     mapping (address => mapping (address => uint256)) private _allowances;
348 
349     uint256 private _totalSupply;
350 
351     string private _name;
352     string private _symbol;
353     uint8 private _decimals;
354 
355     /**
356      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
357      * a default value of 18.
358      *
359      * To select a different value for {decimals}, use {_setupDecimals}.
360      *
361      * All three of these values are immutable: they can only be set once during
362      * construction.
363      */
364     constructor (string memory name_, string memory symbol_) {
365         _name = name_;
366         _symbol = symbol_;
367         _decimals = 18;
368     }
369 
370     /**
371      * @dev Returns the name of the token.
372      */
373     function name() public view virtual returns (string memory) {
374         return _name;
375     }
376 
377     /**
378      * @dev Returns the symbol of the token, usually a shorter version of the
379      * name.
380      */
381     function symbol() public view virtual returns (string memory) {
382         return _symbol;
383     }
384 
385     /**
386      * @dev Returns the number of decimals used to get its user representation.
387      * For example, if `decimals` equals `2`, a balance of `505` tokens should
388      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
389      *
390      * Tokens usually opt for a value of 18, imitating the relationship between
391      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
392      * called.
393      *
394      * NOTE: This information is only used for _display_ purposes: it in
395      * no way affects any of the arithmetic of the contract, including
396      * {IERC20-balanceOf} and {IERC20-transfer}.
397      */
398     function decimals() public view virtual returns (uint8) {
399         return _decimals;
400     }
401 
402     /**
403      * @dev See {IERC20-totalSupply}.
404      */
405     function totalSupply() public view virtual override returns (uint256) {
406         return _totalSupply;
407     }
408 
409     /**
410      * @dev See {IERC20-balanceOf}.
411      */
412     function balanceOf(address account) public view virtual override returns (uint256) {
413         return _balances[account];
414     }
415 
416     /**
417      * @dev See {IERC20-transfer}.
418      *
419      * Requirements:
420      *
421      * - `recipient` cannot be the zero address.
422      * - the caller must have a balance of at least `amount`.
423      */
424     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
425         _transfer(_msgSender(), recipient, amount);
426         return true;
427     }
428 
429     /**
430      * @dev See {IERC20-allowance}.
431      */
432     function allowance(address owner, address spender) public view virtual override returns (uint256) {
433         return _allowances[owner][spender];
434     }
435 
436     /**
437      * @dev See {IERC20-approve}.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function approve(address spender, uint256 amount) public virtual override returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446     }
447 
448     /**
449      * @dev See {IERC20-transferFrom}.
450      *
451      * Emits an {Approval} event indicating the updated allowance. This is not
452      * required by the EIP. See the note at the beginning of {ERC20}.
453      *
454      * Requirements:
455      *
456      * - `sender` and `recipient` cannot be the zero address.
457      * - `sender` must have a balance of at least `amount`.
458      * - the caller must have allowance for ``sender``'s tokens of at least
459      * `amount`.
460      */
461     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
462         _transfer(sender, recipient, amount);
463         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
464         return true;
465     }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
481         return true;
482     }
483 
484     /**
485      * @dev Atomically decreases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `spender` must have allowance for the caller of at least
496      * `subtractedValue`.
497      */
498     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
500         return true;
501     }
502 
503     /**
504      * @dev Moves tokens `amount` from `sender` to `recipient`.
505      *
506      * This is internal function is equivalent to {transfer}, and can be used to
507      * e.g. implement automatic token fees, slashing mechanisms, etc.
508      *
509      * Emits a {Transfer} event.
510      *
511      * Requirements:
512      *
513      * - `sender` cannot be the zero address.
514      * - `recipient` cannot be the zero address.
515      * - `sender` must have a balance of at least `amount`.
516      */
517     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
518         require(sender != address(0), "ERC20: transfer from the zero address");
519         require(recipient != address(0), "ERC20: transfer to the zero address");
520 
521         _beforeTokenTransfer(sender, recipient, amount);
522 
523         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
524         _balances[recipient] = _balances[recipient].add(amount);
525         emit Transfer(sender, recipient, amount);
526     }
527 
528     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
529      * the total supply.
530      *
531      * Emits a {Transfer} event with `from` set to the zero address.
532      *
533      * Requirements:
534      *
535      * - `to` cannot be the zero address.
536      */
537     function _mint(address account, uint256 amount) internal virtual {
538         require(account != address(0), "ERC20: mint to the zero address");
539 
540         _beforeTokenTransfer(address(0), account, amount);
541 
542         _totalSupply = _totalSupply.add(amount);
543         _balances[account] = _balances[account].add(amount);
544         emit Transfer(address(0), account, amount);
545     }
546 
547     /**
548      * @dev Destroys `amount` tokens from `account`, reducing the
549      * total supply.
550      *
551      * Emits a {Transfer} event with `to` set to the zero address.
552      *
553      * Requirements:
554      *
555      * - `account` cannot be the zero address.
556      * - `account` must have at least `amount` tokens.
557      */
558     function _burn(address account, uint256 amount) internal virtual {
559         require(account != address(0), "ERC20: burn from the zero address");
560 
561         _beforeTokenTransfer(account, address(0), amount);
562 
563         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
564         _totalSupply = _totalSupply.sub(amount);
565         emit Transfer(account, address(0), amount);
566     }
567 
568     /**
569      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
570      *
571      * This internal function is equivalent to `approve`, and can be used to
572      * e.g. set automatic allowances for certain subsystems, etc.
573      *
574      * Emits an {Approval} event.
575      *
576      * Requirements:
577      *
578      * - `owner` cannot be the zero address.
579      * - `spender` cannot be the zero address.
580      */
581     function _approve(address owner, address spender, uint256 amount) internal virtual {
582         require(owner != address(0), "ERC20: approve from the zero address");
583         require(spender != address(0), "ERC20: approve to the zero address");
584 
585         _allowances[owner][spender] = amount;
586         emit Approval(owner, spender, amount);
587     }
588 
589     /**
590      * @dev Sets {decimals} to a value other than the default one of 18.
591      *
592      * WARNING: This function should only be called from the constructor. Most
593      * applications that interact with token contracts will not expect
594      * {decimals} to ever change, and may work incorrectly if it does.
595      */
596     function _setupDecimals(uint8 decimals_) internal virtual {
597         _decimals = decimals_;
598     }
599 
600     /**
601      * @dev Hook that is called before any transfer of tokens. This includes
602      * minting and burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * will be to transferred to `to`.
608      * - when `from` is zero, `amount` tokens will be minted for `to`.
609      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
610      * - `from` and `to` are never both zero.
611      *
612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
613      */
614     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
615 }
616 
617 contract Token is ERC20 {
618 
619     constructor () ERC20("MuskGold", "MUSK") {
620         _mint(msg.sender, 690420000 * (10 ** uint256(decimals())));
621     }
622 }