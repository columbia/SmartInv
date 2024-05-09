1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.2;
3 
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
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 // File: @openzeppelin/contracts/math/SafeMath.sol
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         uint256 c = a + b;
124         if (c < a) return (false, 0);
125         return (true, c);
126     }
127 
128     /**
129      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         if (b > a) return (false, 0);
135         return (true, a - b);
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
147         if (a == 0) return (true, 0);
148         uint256 c = a * b;
149         if (c / a != b) return (false, 0);
150         return (true, c);
151     }
152 
153     /**
154      * @dev Returns the division of two unsigned integers, with a division by zero flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         if (b == 0) return (false, 0);
160         return (true, a / b);
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         if (b == 0) return (false, 0);
170         return (true, a % b);
171     }
172 
173     /**
174      * @dev Returns the addition of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `+` operator.
178      *
179      * Requirements:
180      *
181      * - Addition cannot overflow.
182      */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         uint256 c = a + b;
185         require(c >= a, "SafeMath: addition overflow");
186         return c;
187     }
188 
189     /**
190      * @dev Returns the subtraction of two unsigned integers, reverting on
191      * overflow (when the result is negative).
192      *
193      * Counterpart to Solidity's `-` operator.
194      *
195      * Requirements:
196      *
197      * - Subtraction cannot overflow.
198      */
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         require(b <= a, "SafeMath: subtraction overflow");
201         return a - b;
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `*` operator.
209      *
210      * Requirements:
211      *
212      * - Multiplication cannot overflow.
213      */
214     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
215         if (a == 0) return 0;
216         uint256 c = a * b;
217         require(c / a == b, "SafeMath: multiplication overflow");
218         return c;
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers, reverting on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         require(b > 0, "SafeMath: division by zero");
235         return a / b;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * reverting when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         require(b > 0, "SafeMath: modulo by zero");
252         return a % b;
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
257      * overflow (when the result is negative).
258      *
259      * CAUTION: This function is deprecated because it requires allocating memory for the error
260      * message unnecessarily. For custom revert reasons use {trySub}.
261      *
262      * Counterpart to Solidity's `-` operator.
263      *
264      * Requirements:
265      *
266      * - Subtraction cannot overflow.
267      */
268     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b <= a, errorMessage);
270         return a - b;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
275      * division by zero. The result is rounded towards zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryDiv}.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b > 0, errorMessage);
290         return a / b;
291     }
292 
293     /**
294      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
295      * reverting with custom message when dividing by zero.
296      *
297      * CAUTION: This function is deprecated because it requires allocating memory for the error
298      * message unnecessarily. For custom revert reasons use {tryMod}.
299      *
300      * Counterpart to Solidity's `%` operator. This function uses a `revert`
301      * opcode (which leaves remaining gas untouched) while Solidity uses an
302      * invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         require(b > 0, errorMessage);
310         return a % b;
311     }
312 }
313 
314 
315 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
316 
317 /**
318  * @dev Implementation of the {IERC20} interface.
319  *
320  * This implementation is agnostic to the way tokens are created. This means
321  * that a supply mechanism has to be added in a derived contract using {_mint}.
322  * For a generic mechanism see {ERC20PresetMinterPauser}.
323  *
324  * TIP: For a detailed writeup see our guide
325  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
326  * to implement supply mechanisms].
327  *
328  * We have followed general OpenZeppelin guidelines: functions revert instead
329  * of returning `false` on failure. This behavior is nonetheless conventional
330  * and does not conflict with the expectations of ERC20 applications.
331  *
332  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
333  * This allows applications to reconstruct the allowance for all accounts just
334  * by listening to said events. Other implementations of the EIP may not emit
335  * these events, as it isn't required by the specification.
336  *
337  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
338  * functions have been added to mitigate the well-known issues around setting
339  * allowances. See {IERC20-approve}.
340  */
341 contract ERC20 is Context, IERC20 {
342     using SafeMath for uint256;
343 
344     mapping (address => uint256) private _balances;
345 
346     mapping (address => mapping (address => uint256)) private _allowances;
347 
348     uint256 private _totalSupply;
349 
350     string private _name;
351     string private _symbol;
352     uint8 private _decimals;
353 
354     /**
355      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
356      * a default value of 18.
357      *
358      * To select a different value for {decimals}, use {_setupDecimals}.
359      *
360      * All three of these values are immutable: they can only be set once during
361      * construction.
362      */
363     constructor (string memory name_, string memory symbol_) public {
364         _name = name_;
365         _symbol = symbol_;
366         _decimals = 18;
367     }
368 
369     /**
370      * @dev Returns the name of the token.
371      */
372     function name() public view virtual returns (string memory) {
373         return _name;
374     }
375 
376     /**
377      * @dev Returns the symbol of the token, usually a shorter version of the
378      * name.
379      */
380     function symbol() public view virtual returns (string memory) {
381         return _symbol;
382     }
383 
384     /**
385      * @dev Returns the number of decimals used to get its user representation.
386      * For example, if `decimals` equals `2`, a balance of `505` tokens should
387      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
388      *
389      * Tokens usually opt for a value of 18, imitating the relationship between
390      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
391      * called.
392      *
393      * NOTE: This information is only used for _display_ purposes: it in
394      * no way affects any of the arithmetic of the contract, including
395      * {IERC20-balanceOf} and {IERC20-transfer}.
396      */
397     function decimals() public view virtual returns (uint8) {
398         return _decimals;
399     }
400 
401     /**
402      * @dev See {IERC20-totalSupply}.
403      */
404     function totalSupply() public view virtual override returns (uint256) {
405         return _totalSupply;
406     }
407 
408     /**
409      * @dev See {IERC20-balanceOf}.
410      */
411     function balanceOf(address account) public view virtual override returns (uint256) {
412         return _balances[account];
413     }
414 
415     /**
416      * @dev See {IERC20-transfer}.
417      *
418      * Requirements:
419      *
420      * - `recipient` cannot be the zero address.
421      * - the caller must have a balance of at least `amount`.
422      */
423     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
424         _transfer(_msgSender(), recipient, amount);
425         return true;
426     }
427 
428     /**
429      * @dev See {IERC20-allowance}.
430      */
431     function allowance(address owner, address spender) public view virtual override returns (uint256) {
432         return _allowances[owner][spender];
433     }
434 
435     /**
436      * @dev See {IERC20-approve}.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function approve(address spender, uint256 amount) public virtual override returns (bool) {
443         _approve(_msgSender(), spender, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-transferFrom}.
449      *
450      * Emits an {Approval} event indicating the updated allowance. This is not
451      * required by the EIP. See the note at the beginning of {ERC20}.
452      *
453      * Requirements:
454      *
455      * - `sender` and `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      * - the caller must have allowance for ``sender``'s tokens of at least
458      * `amount`.
459      */
460     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
461         _transfer(sender, recipient, amount);
462         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
463         return true;
464     }
465 
466     /**
467      * @dev Atomically increases the allowance granted to `spender` by the caller.
468      *
469      * This is an alternative to {approve} that can be used as a mitigation for
470      * problems described in {IERC20-approve}.
471      *
472      * Emits an {Approval} event indicating the updated allowance.
473      *
474      * Requirements:
475      *
476      * - `spender` cannot be the zero address.
477      */
478     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
479         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
480         return true;
481     }
482 
483     /**
484      * @dev Atomically decreases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      * - `spender` must have allowance for the caller of at least
495      * `subtractedValue`.
496      */
497     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
499         return true;
500     }
501 
502     /**
503      * @dev Moves tokens `amount` from `sender` to `recipient`.
504      *
505      * This is internal function is equivalent to {transfer}, and can be used to
506      * e.g. implement automatic token fees, slashing mechanisms, etc.
507      *
508      * Emits a {Transfer} event.
509      *
510      * Requirements:
511      *
512      * - `sender` cannot be the zero address.
513      * - `recipient` cannot be the zero address.
514      * - `sender` must have a balance of at least `amount`.
515      */
516     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
517         require(sender != address(0), "ERC20: transfer from the zero address");
518         require(recipient != address(0), "ERC20: transfer to the zero address");
519 
520         _beforeTokenTransfer(sender, recipient, amount);
521 
522         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
523         _balances[recipient] = _balances[recipient].add(amount);
524         emit Transfer(sender, recipient, amount);
525     }
526 
527     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
528      * the total supply.
529      *
530      * Emits a {Transfer} event with `from` set to the zero address.
531      *
532      * Requirements:
533      *
534      * - `to` cannot be the zero address.
535      */
536     function _mint(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: mint to the zero address");
538 
539         _beforeTokenTransfer(address(0), account, amount);
540 
541         _totalSupply = _totalSupply.add(amount);
542         _balances[account] = _balances[account].add(amount);
543         emit Transfer(address(0), account, amount);
544     }
545 
546     /**
547      * @dev Destroys `amount` tokens from `account`, reducing the
548      * total supply.
549      *
550      * Emits a {Transfer} event with `to` set to the zero address.
551      *
552      * Requirements:
553      *
554      * - `account` cannot be the zero address.
555      * - `account` must have at least `amount` tokens.
556      */
557     function _burn(address account, uint256 amount) internal virtual {
558         require(account != address(0), "ERC20: burn from the zero address");
559 
560         _beforeTokenTransfer(account, address(0), amount);
561 
562         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
563         _totalSupply = _totalSupply.sub(amount);
564         emit Transfer(account, address(0), amount);
565     }
566 
567     /**
568      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
569      *
570      * This internal function is equivalent to `approve`, and can be used to
571      * e.g. set automatic allowances for certain subsystems, etc.
572      *
573      * Emits an {Approval} event.
574      *
575      * Requirements:
576      *
577      * - `owner` cannot be the zero address.
578      * - `spender` cannot be the zero address.
579      */
580     function _approve(address owner, address spender, uint256 amount) internal virtual {
581         require(owner != address(0), "ERC20: approve from the zero address");
582         require(spender != address(0), "ERC20: approve to the zero address");
583 
584         _allowances[owner][spender] = amount;
585         emit Approval(owner, spender, amount);
586     }
587 
588     /**
589      * @dev Sets {decimals} to a value other than the default one of 18.
590      *
591      * WARNING: This function should only be called from the constructor. Most
592      * applications that interact with token contracts will not expect
593      * {decimals} to ever change, and may work incorrectly if it does.
594      */
595     function _setupDecimals(uint8 decimals_) internal virtual {
596         _decimals = decimals_;
597     }
598 
599     /**
600      * @dev Hook that is called before any transfer of tokens. This includes
601      * minting and burning.
602      *
603      * Calling conditions:
604      *
605      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
606      * will be to transferred to `to`.
607      * - when `from` is zero, `amount` tokens will be minted for `to`.
608      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
609      * - `from` and `to` are never both zero.
610      *
611      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
612      */
613     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
614 }
615 
616 
617 // File: contracts/HID.sol
618 
619 /// @title HID token contract with ERC20 specification
620 /// @dev You can use this contract for managing states of HID tokens
621 contract HID is ERC20 {
622 
623     /// @notice initiates HID token contract passed initial supply
624     /// @param initialSupply total numebr of HID token
625     constructor(uint256 initialSupply) public ERC20("Hypersign Identity Token", "HID") {
626         _mint(msg.sender, initialSupply);
627     }
628 }