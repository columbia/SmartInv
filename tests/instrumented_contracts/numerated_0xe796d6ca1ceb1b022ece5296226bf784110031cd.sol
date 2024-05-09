1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
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
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         uint256 c = a + b;
127         if (c < a) return (false, 0);
128         return (true, c);
129     }
130 
131     /**
132      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         if (b > a) return (false, 0);
138         return (true, a - b);
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) return (true, 0);
151         uint256 c = a * b;
152         if (c / a != b) return (false, 0);
153         return (true, c);
154     }
155 
156     /**
157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         if (b == 0) return (false, 0);
163         return (true, a / b);
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         if (b == 0) return (false, 0);
173         return (true, a % b);
174     }
175 
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      *
184      * - Addition cannot overflow.
185      */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b <= a, "SafeMath: subtraction overflow");
204         return a - b;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      *
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         if (a == 0) return 0;
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers, reverting on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         require(b > 0, "SafeMath: division by zero");
238         return a / b;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * reverting when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         require(b > 0, "SafeMath: modulo by zero");
255         return a % b;
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260      * overflow (when the result is negative).
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {trySub}.
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         return a - b;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
278      * division by zero. The result is rounded towards zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryDiv}.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         return a / b;
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * reverting with custom message when dividing by zero.
299      *
300      * CAUTION: This function is deprecated because it requires allocating memory for the error
301      * message unnecessarily. For custom revert reasons use {tryMod}.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         require(b > 0, errorMessage);
313         return a % b;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
318 
319 /**
320  * @dev Implementation of the {IERC20} interface.
321  *
322  * This implementation is agnostic to the way tokens are created. This means
323  * that a supply mechanism has to be added in a derived contract using {_mint}.
324  * For a generic mechanism see {ERC20PresetMinterPauser}.
325  *
326  * TIP: For a detailed writeup see our guide
327  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
328  * to implement supply mechanisms].
329  *
330  * We have followed general OpenZeppelin guidelines: functions revert instead
331  * of returning `false` on failure. This behavior is nonetheless conventional
332  * and does not conflict with the expectations of ERC20 applications.
333  *
334  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
335  * This allows applications to reconstruct the allowance for all accounts just
336  * by listening to said events. Other implementations of the EIP may not emit
337  * these events, as it isn't required by the specification.
338  *
339  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
340  * functions have been added to mitigate the well-known issues around setting
341  * allowances. See {IERC20-approve}.
342  */
343 contract ERC20 is Context, IERC20 {
344     using SafeMath for uint256;
345 
346     mapping (address => uint256) private _balances;
347 
348     mapping (address => mapping (address => uint256)) private _allowances;
349 
350     uint256 private _totalSupply;
351 
352     string private _name;
353     string private _symbol;
354     uint8 private _decimals;
355 
356     /**
357      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
358      * a default value of 18.
359      *
360      * To select a different value for {decimals}, use {_setupDecimals}.
361      *
362      * All three of these values are immutable: they can only be set once during
363      * construction.
364      */
365     constructor (string memory name_, string memory symbol_) public {
366         _name = name_;
367         _symbol = symbol_;
368         _decimals = 18;
369     }
370 
371     /**
372      * @dev Returns the name of the token.
373      */
374     function name() public view virtual returns (string memory) {
375         return _name;
376     }
377 
378     /**
379      * @dev Returns the symbol of the token, usually a shorter version of the
380      * name.
381      */
382     function symbol() public view virtual returns (string memory) {
383         return _symbol;
384     }
385 
386     /**
387      * @dev Returns the number of decimals used to get its user representation.
388      * For example, if `decimals` equals `2`, a balance of `505` tokens should
389      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
390      *
391      * Tokens usually opt for a value of 18, imitating the relationship between
392      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
393      * called.
394      *
395      * NOTE: This information is only used for _display_ purposes: it in
396      * no way affects any of the arithmetic of the contract, including
397      * {IERC20-balanceOf} and {IERC20-transfer}.
398      */
399     function decimals() public view virtual returns (uint8) {
400         return _decimals;
401     }
402 
403     /**
404      * @dev See {IERC20-totalSupply}.
405      */
406     function totalSupply() public view virtual override returns (uint256) {
407         return _totalSupply;
408     }
409 
410     /**
411      * @dev See {IERC20-balanceOf}.
412      */
413     function balanceOf(address account) public view virtual override returns (uint256) {
414         return _balances[account];
415     }
416 
417     /**
418      * @dev See {IERC20-transfer}.
419      *
420      * Requirements:
421      *
422      * - `recipient` cannot be the zero address.
423      * - the caller must have a balance of at least `amount`.
424      */
425     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
426         _transfer(_msgSender(), recipient, amount);
427         return true;
428     }
429 
430     /**
431      * @dev See {IERC20-allowance}.
432      */
433     function allowance(address owner, address spender) public view virtual override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     /**
438      * @dev See {IERC20-approve}.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function approve(address spender, uint256 amount) public virtual override returns (bool) {
445         _approve(_msgSender(), spender, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-transferFrom}.
451      *
452      * Emits an {Approval} event indicating the updated allowance. This is not
453      * required by the EIP. See the note at the beginning of {ERC20}.
454      *
455      * Requirements:
456      *
457      * - `sender` and `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      * - the caller must have allowance for ``sender``'s tokens of at least
460      * `amount`.
461      */
462     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
463         _transfer(sender, recipient, amount);
464         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
465         return true;
466     }
467 
468     /**
469      * @dev Atomically increases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      */
480     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically decreases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      * - `spender` must have allowance for the caller of at least
497      * `subtractedValue`.
498      */
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503 
504     /**
505      * @dev Moves tokens `amount` from `sender` to `recipient`.
506      *
507      * This is internal function is equivalent to {transfer}, and can be used to
508      * e.g. implement automatic token fees, slashing mechanisms, etc.
509      *
510      * Emits a {Transfer} event.
511      *
512      * Requirements:
513      *
514      * - `sender` cannot be the zero address.
515      * - `recipient` cannot be the zero address.
516      * - `sender` must have a balance of at least `amount`.
517      */
518     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
519         require(sender != address(0), "ERC20: transfer from the zero address");
520         require(recipient != address(0), "ERC20: transfer to the zero address");
521 
522         _beforeTokenTransfer(sender, recipient, amount);
523 
524         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
525         _balances[recipient] = _balances[recipient].add(amount);
526         emit Transfer(sender, recipient, amount);
527     }
528 
529     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
530      * the total supply.
531      *
532      * Emits a {Transfer} event with `from` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `to` cannot be the zero address.
537      */
538     function _mint(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: mint to the zero address");
540 
541         _beforeTokenTransfer(address(0), account, amount);
542 
543         _totalSupply = _totalSupply.add(amount);
544         _balances[account] = _balances[account].add(amount);
545         emit Transfer(address(0), account, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`, reducing the
550      * total supply.
551      *
552      * Emits a {Transfer} event with `to` set to the zero address.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      * - `account` must have at least `amount` tokens.
558      */
559     function _burn(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: burn from the zero address");
561 
562         _beforeTokenTransfer(account, address(0), amount);
563 
564         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
565         _totalSupply = _totalSupply.sub(amount);
566         emit Transfer(account, address(0), amount);
567     }
568 
569     /**
570      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
571      *
572      * This internal function is equivalent to `approve`, and can be used to
573      * e.g. set automatic allowances for certain subsystems, etc.
574      *
575      * Emits an {Approval} event.
576      *
577      * Requirements:
578      *
579      * - `owner` cannot be the zero address.
580      * - `spender` cannot be the zero address.
581      */
582     function _approve(address owner, address spender, uint256 amount) internal virtual {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585 
586         _allowances[owner][spender] = amount;
587         emit Approval(owner, spender, amount);
588     }
589 
590     /**
591      * @dev Sets {decimals} to a value other than the default one of 18.
592      *
593      * WARNING: This function should only be called from the constructor. Most
594      * applications that interact with token contracts will not expect
595      * {decimals} to ever change, and may work incorrectly if it does.
596      */
597     function _setupDecimals(uint8 decimals_) internal virtual {
598         _decimals = decimals_;
599     }
600 
601     /**
602      * @dev Hook that is called before any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * will be to transferred to `to`.
609      * - when `from` is zero, `amount` tokens will be minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
616 }
617 
618 // File: contracts/tokens/BLES.sol
619 
620 // This token is owned by Timelock.
621 contract BLES is ERC20("Blind Boxes Token", "BLES") {
622 
623     constructor() public {
624         _mint(_msgSender(), 1e26);  // 100 million, 18 decimals
625     }
626 
627     function burn(uint256 _amount) external {
628         _burn(_msgSender(), _amount);
629     }
630 
631     function burnFrom(address account, uint256 amount) external {
632         uint256 currentAllowance = allowance(account, _msgSender());
633         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
634         _approve(account, _msgSender(), currentAllowance - amount);
635         _burn(account, amount);
636     }
637 }