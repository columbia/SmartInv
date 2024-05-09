1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 
5 /**
6 * Equalizer Smart Contract
7 * Standard: ERC-20
8 * Name: Equalizer
9 * Ticker: EQZ
10 * Total Supply: 100,000,000 EQZ (100M)
11 */
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations with added overflow
15  * checks.
16  *
17  * Arithmetic operations in Solidity wrap on overflow. This can easily result
18  * in bugs, because programmers usually assume that an overflow raises an
19  * error, which is the standard behavior in high level programming languages.
20  * `SafeMath` restores this intuition by reverting the transaction when an
21  * operation overflows.
22  *
23  * Using this library instead of the unchecked operations eliminates an entire
24  * class of bugs, so it's recommended to use it always.
25  * Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1c3d6c97f7469721b9c683706c88558d544fc0da/contracts/math/SafeMath.sol
26  */
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         uint256 c = a + b;
35         if (c < a) return (false, 0);
36         return (true, c);
37     }
38 
39     /**
40      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         if (b > a) return (false, 0);
46         return (true, a - b);
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
58         if (a == 0) return (true, 0);
59         uint256 c = a * b;
60         if (c / a != b) return (false, 0);
61         return (true, c);
62     }
63 
64     /**
65      * @dev Returns the division of two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         if (b == 0) return (false, 0);
71         return (true, a / b);
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         if (b == 0) return (false, 0);
81         return (true, a % b);
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97         return c;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b <= a, "SafeMath: subtraction overflow");
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         if (a == 0) return 0;
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129         return c;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers, reverting on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function div(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b > 0, "SafeMath: division by zero");
146         return a / b;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b > 0, "SafeMath: modulo by zero");
163         return a % b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * CAUTION: This function is deprecated because it requires allocating memory for the error
171      * message unnecessarily. For custom revert reasons use {trySub}.
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         return a - b;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * CAUTION: This function is deprecated because it requires allocating memory for the error
189      * message unnecessarily. For custom revert reasons use {tryDiv}.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         return a / b;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         return a % b;
222     }
223 }
224 
225 /*
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with GSN meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  * Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1c3d6c97f7469721b9c683706c88558d544fc0da/contracts/utils/Context.sol
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address payable) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * We have followed general OpenZeppelin guidelines: functions revert instead
259  * of returning `false` on failure. This behavior is nonetheless conventional
260  * and does not conflict with the expectations of ERC20 applications.
261  *
262  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
263  * This allows applications to reconstruct the allowance for all accounts just
264  * by listening to said events. Other implementations of the EIP may not emit
265  * these events, as it isn't required by the specification.
266  *
267  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
268  * functions have been added to mitigate the well-known issues around setting
269  * allowances. See {IERC20-approve}.
270  * Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1c3d6c97f7469721b9c683706c88558d544fc0da/contracts/token/ERC20/IERC20.sol
271  */
272 
273 /**
274  * @dev Interface of the ERC20 standard as defined in the EIP.
275  */
276 interface IERC20 {
277     /**
278      * @dev Returns the amount of tokens in existence.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     /**
283      * @dev Returns the amount of tokens owned by `account`.
284      */
285     function balanceOf(address account) external view returns (uint256);
286 
287     /**
288      * @dev Moves `amount` tokens from the caller's account to `recipient`.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transfer(address recipient, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Returns the remaining number of tokens that `spender` will be
298      * allowed to spend on behalf of `owner` through {transferFrom}. This is
299      * zero by default.
300      *
301      * This value changes when {approve} or {transferFrom} are called.
302      */
303     function allowance(address owner, address spender) external view returns (uint256);
304 
305     /**
306      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * IMPORTANT: Beware that changing an allowance with this method brings the risk
311      * that someone may use both the old and the new allowance by unfortunate
312      * transaction ordering. One possible solution to mitigate this race
313      * condition is to first reduce the spender's allowance to 0 and set the
314      * desired value afterwards:
315      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address spender, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Moves `amount` tokens from `sender` to `recipient` using the
323      * allowance mechanism. `amount` is then deducted from the caller's
324      * allowance.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Emitted when `value` tokens are moved from one account (`from`) to
334      * another (`to`).
335      *
336      * Note that `value` may be zero.
337      */
338     event Transfer(address indexed from, address indexed to, uint256 value);
339 
340     /**
341      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
342      * a call to {approve}. `value` is the new allowance.
343      */
344     event Approval(address indexed owner, address indexed spender, uint256 value);
345 }
346 
347 /**
348  * @dev Implementation of the {IERC20} interface.
349  *
350  * Tokens are created during the smart contract deployment.
351  *
352  * We have followed general OpenZeppelin guidelines: functions revert instead
353  * of returning `false` on failure. This behavior is nonetheless conventional
354  * and does not conflict with the expectations of ERC20 applications.
355  *
356  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
357  * This allows applications to reconstruct the allowance for all accounts just
358  * by listening to said events. Other implementations of the EIP may not emit
359  * these events, as it isn't required by the specification.
360  *
361  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
362  * functions have been added to mitigate the well-known issues around setting
363  * allowances. See {IERC20-approve}.
364  * Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1c3d6c97f7469721b9c683706c88558d544fc0da/contracts/token/ERC20/ERC20.sol
365  */
366 contract ERC20 is Context, IERC20 {
367     using SafeMath for uint256;
368 
369     mapping (address => uint256) private _balances;
370 
371     mapping (address => mapping (address => uint256)) private _allowances;
372 
373     uint256 private _totalSupply;
374 
375     string private _name;
376     string private _symbol;
377     uint8 private _decimals;
378 
379     /**
380      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
381      * a default value of 18.
382      *
383      * To select a different value for {decimals}, use {_setupDecimals}.
384      *
385      * All three of these values are immutable: they can only be set once during
386      * construction.
387      */
388     constructor (string memory name_, string memory symbol_) {
389         _name = name_;
390         _symbol = symbol_;
391         _decimals = 18;
392     }
393 
394     /**
395      * @dev Returns the name of the token.
396      */
397     function name() public view virtual returns (string memory) {
398         return _name;
399     }
400 
401     /**
402      * @dev Returns the symbol of the token, usually a shorter version of the
403      * name.
404      */
405     function symbol() public view virtual returns (string memory) {
406         return _symbol;
407     }
408 
409     /**
410      * @dev Returns the number of decimals used to get its user representation.
411      * For example, if `decimals` equals `2`, a balance of `505` tokens should
412      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
413      *
414      * Tokens usually opt for a value of 18, imitating the relationship between
415      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
416      * called.
417      *
418      * NOTE: This information is only used for _display_ purposes: it in
419      * no way affects any of the arithmetic of the contract, including
420      * {IERC20-balanceOf} and {IERC20-transfer}.
421      */
422     function decimals() public view virtual returns (uint8) {
423         return _decimals;
424     }
425 
426     /**
427      * @dev See {IERC20-totalSupply}.
428      */
429     function totalSupply() public view virtual override returns (uint256) {
430         return _totalSupply;
431     }
432 
433     /**
434      * @dev See {IERC20-balanceOf}.
435      */
436     function balanceOf(address account) public view virtual override returns (uint256) {
437         return _balances[account];
438     }
439 
440     /**
441      * @dev See {IERC20-transfer}.
442      *
443      * Requirements:
444      *
445      * - `recipient` cannot be the zero address.
446      * - the caller must have a balance of at least `amount`.
447      */
448     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
449         _transfer(_msgSender(), recipient, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-allowance}.
455      */
456     function allowance(address owner, address spender) public view virtual override returns (uint256) {
457         return _allowances[owner][spender];
458     }
459 
460     /**
461      * @dev See {IERC20-approve}.
462      *
463      * Requirements:
464      *
465      * - `spender` cannot be the zero address.
466      */
467     function approve(address spender, uint256 amount) public virtual override returns (bool) {
468         _approve(_msgSender(), spender, amount);
469         return true;
470     }
471 
472     /**
473      * @dev See {IERC20-transferFrom}.
474      *
475      * Emits an {Approval} event indicating the updated allowance. This is not
476      * required by the EIP. See the note at the beginning of {ERC20}.
477      *
478      * Requirements:
479      *
480      * - `sender` and `recipient` cannot be the zero address.
481      * - `sender` must have a balance of at least `amount`.
482      * - the caller must have allowance for ``sender``'s tokens of at least
483      * `amount`.
484      */
485     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
486         _transfer(sender, recipient, amount);
487         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
488         return true;
489     }
490 
491     /**
492      * @dev Atomically increases the allowance granted to `spender` by the caller.
493      *
494      * This is an alternative to {approve} that can be used as a mitigation for
495      * problems described in {IERC20-approve}.
496      *
497      * Emits an {Approval} event indicating the updated allowance.
498      *
499      * Requirements:
500      *
501      * - `spender` cannot be the zero address.
502      */
503     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
505         return true;
506     }
507 
508     /**
509      * @dev Atomically decreases the allowance granted to `spender` by the caller.
510      *
511      * This is an alternative to {approve} that can be used as a mitigation for
512      * problems described in {IERC20-approve}.
513      *
514      * Emits an {Approval} event indicating the updated allowance.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      * - `spender` must have allowance for the caller of at least
520      * `subtractedValue`.
521      */
522     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
523         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
524         return true;
525     }
526 
527     /**
528      * @dev Moves tokens `amount` from `sender` to `recipient`.
529      *
530      * This is internal function is equivalent to {transfer}, and can be used to
531      * e.g. implement automatic token fees, slashing mechanisms, etc.
532      *
533      * Emits a {Transfer} event.
534      *
535      * Requirements:
536      *
537      * - `sender` cannot be the zero address.
538      * - `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      */
541     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
542         require(sender != address(0), "ERC20: transfer from the zero address");
543         require(recipient != address(0), "ERC20: transfer to the zero address");
544 
545         _beforeTokenTransfer(sender, recipient, amount);
546 
547         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
548         _balances[recipient] = _balances[recipient].add(amount);
549         emit Transfer(sender, recipient, amount);
550     }
551 
552     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
553      * the total supply.
554      *
555      * Emits a {Transfer} event with `from` set to the zero address.
556      *
557      * Requirements:
558      *
559      * - `to` cannot be the zero address.
560      */
561     function _mint(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: mint to the zero address");
563 
564         _beforeTokenTransfer(address(0), account, amount);
565 
566         _totalSupply = _totalSupply.add(amount);
567         _balances[account] = _balances[account].add(amount);
568         emit Transfer(address(0), account, amount);
569     }
570 
571     /**
572      * @dev Destroys `amount` tokens from `account`, reducing the
573      * total supply.
574      *
575      * Emits a {Transfer} event with `to` set to the zero address.
576      *
577      * Requirements:
578      *
579      * - `account` cannot be the zero address.
580      * - `account` must have at least `amount` tokens.
581      */
582     function _burn(address account, uint256 amount) internal virtual {
583         require(account != address(0), "ERC20: burn from the zero address");
584 
585         _beforeTokenTransfer(account, address(0), amount);
586 
587         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
588         _totalSupply = _totalSupply.sub(amount);
589         emit Transfer(account, address(0), amount);
590     }
591 
592     /**
593      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
594      *
595      * This internal function is equivalent to `approve`, and can be used to
596      * e.g. set automatic allowances for certain subsystems, etc.
597      *
598      * Emits an {Approval} event.
599      *
600      * Requirements:
601      *
602      * - `owner` cannot be the zero address.
603      * - `spender` cannot be the zero address.
604      */
605     function _approve(address owner, address spender, uint256 amount) internal virtual {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608 
609         _allowances[owner][spender] = amount;
610         emit Approval(owner, spender, amount);
611     }
612 
613     /**
614      * @dev Sets {decimals} to a value other than the default one of 18.
615      *
616      * WARNING: This function should only be called from the constructor. Most
617      * applications that interact with token contracts will not expect
618      * {decimals} to ever change, and may work incorrectly if it does.
619      */
620     function _setupDecimals(uint8 decimals_) internal virtual {
621         _decimals = decimals_;
622     }
623 
624     /**
625      * @dev Hook that is called before any transfer of tokens. This includes
626      * minting and burning.
627      *
628      * Calling conditions:
629      *
630      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
631      * will be to transferred to `to`.
632      * - when `from` is zero, `amount` tokens will be minted for `to`.
633      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
634      * - `from` and `to` are never both zero.
635      *
636      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
637      */
638     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
639 }
640 
641 /**
642  * @dev Equalizer Smart Contract
643  */
644 
645 contract Equalizer is ERC20 {
646     constructor () ERC20("Equalizer", "EQZ") {
647         _mint(_msgSender(), 100000000 * 1e18);
648     }
649 }