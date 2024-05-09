1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
32 
33 
34 
35 pragma solidity >=0.6.0 <0.8.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
113 
114 
115 
116 pragma solidity >=0.6.0 <0.8.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         uint256 c = a + b;
139         if (c < a) return (false, 0);
140         return (true, c);
141     }
142 
143     /**
144      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
145      *
146      * _Available since v3.4._
147      */
148     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b > a) return (false, 0);
150         return (true, a - b);
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) return (true, 0);
163         uint256 c = a * b;
164         if (c / a != b) return (false, 0);
165         return (true, c);
166     }
167 
168     /**
169      * @dev Returns the division of two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b == 0) return (false, 0);
175         return (true, a / b);
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         if (b == 0) return (false, 0);
185         return (true, a % b);
186     }
187 
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      *
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a, "SafeMath: addition overflow");
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b <= a, "SafeMath: subtraction overflow");
216         return a - b;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      *
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         if (a == 0) return 0;
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233         return c;
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers, reverting on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b > 0, "SafeMath: division by zero");
250         return a / b;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * reverting when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b > 0, "SafeMath: modulo by zero");
267         return a % b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {trySub}.
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b <= a, errorMessage);
285         return a - b;
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryDiv}.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b > 0, errorMessage);
305         return a / b;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting with custom message when dividing by zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryMod}.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b > 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 
330 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.2
331 
332 
333 
334 pragma solidity >=0.6.0 <0.8.0;
335 
336 
337 
338 /**
339  * @dev Implementation of the {IERC20} interface.
340  *
341  * This implementation is agnostic to the way tokens are created. This means
342  * that a supply mechanism has to be added in a derived contract using {_mint}.
343  * For a generic mechanism see {ERC20PresetMinterPauser}.
344  *
345  * TIP: For a detailed writeup see our guide
346  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
347  * to implement supply mechanisms].
348  *
349  * We have followed general OpenZeppelin guidelines: functions revert instead
350  * of returning `false` on failure. This behavior is nonetheless conventional
351  * and does not conflict with the expectations of ERC20 applications.
352  *
353  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
354  * This allows applications to reconstruct the allowance for all accounts just
355  * by listening to said events. Other implementations of the EIP may not emit
356  * these events, as it isn't required by the specification.
357  *
358  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
359  * functions have been added to mitigate the well-known issues around setting
360  * allowances. See {IERC20-approve}.
361  */
362 contract ERC20 is Context, IERC20 {
363     using SafeMath for uint256;
364 
365     mapping (address => uint256) private _balances;
366 
367     mapping (address => mapping (address => uint256)) private _allowances;
368 
369     uint256 private _totalSupply;
370 
371     string private _name;
372     string private _symbol;
373     uint8 private _decimals;
374 
375     /**
376      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
377      * a default value of 18.
378      *
379      * To select a different value for {decimals}, use {_setupDecimals}.
380      *
381      * All three of these values are immutable: they can only be set once during
382      * construction.
383      */
384     constructor (string memory name_, string memory symbol_) public {
385         _name = name_;
386         _symbol = symbol_;
387         _decimals = 18;
388     }
389 
390     /**
391      * @dev Returns the name of the token.
392      */
393     function name() public view virtual returns (string memory) {
394         return _name;
395     }
396 
397     /**
398      * @dev Returns the symbol of the token, usually a shorter version of the
399      * name.
400      */
401     function symbol() public view virtual returns (string memory) {
402         return _symbol;
403     }
404 
405     /**
406      * @dev Returns the number of decimals used to get its user representation.
407      * For example, if `decimals` equals `2`, a balance of `505` tokens should
408      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
409      *
410      * Tokens usually opt for a value of 18, imitating the relationship between
411      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
412      * called.
413      *
414      * NOTE: This information is only used for _display_ purposes: it in
415      * no way affects any of the arithmetic of the contract, including
416      * {IERC20-balanceOf} and {IERC20-transfer}.
417      */
418     function decimals() public view virtual returns (uint8) {
419         return _decimals;
420     }
421 
422     /**
423      * @dev See {IERC20-totalSupply}.
424      */
425     function totalSupply() public view virtual override returns (uint256) {
426         return _totalSupply;
427     }
428 
429     /**
430      * @dev See {IERC20-balanceOf}.
431      */
432     function balanceOf(address account) public view virtual override returns (uint256) {
433         return _balances[account];
434     }
435 
436     /**
437      * @dev See {IERC20-transfer}.
438      *
439      * Requirements:
440      *
441      * - `recipient` cannot be the zero address.
442      * - the caller must have a balance of at least `amount`.
443      */
444     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender) public view virtual override returns (uint256) {
453         return _allowances[owner][spender];
454     }
455 
456     /**
457      * @dev See {IERC20-approve}.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function approve(address spender, uint256 amount) public virtual override returns (bool) {
464         _approve(_msgSender(), spender, amount);
465         return true;
466     }
467 
468     /**
469      * @dev See {IERC20-transferFrom}.
470      *
471      * Emits an {Approval} event indicating the updated allowance. This is not
472      * required by the EIP. See the note at the beginning of {ERC20}.
473      *
474      * Requirements:
475      *
476      * - `sender` and `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      * - the caller must have allowance for ``sender``'s tokens of at least
479      * `amount`.
480      */
481     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(sender, recipient, amount);
483         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically increases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      */
499     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
501         return true;
502     }
503 
504     /**
505      * @dev Atomically decreases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      * - `spender` must have allowance for the caller of at least
516      * `subtractedValue`.
517      */
518     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
520         return true;
521     }
522 
523     /**
524      * @dev Moves tokens `amount` from `sender` to `recipient`.
525      *
526      * This is internal function is equivalent to {transfer}, and can be used to
527      * e.g. implement automatic token fees, slashing mechanisms, etc.
528      *
529      * Emits a {Transfer} event.
530      *
531      * Requirements:
532      *
533      * - `sender` cannot be the zero address.
534      * - `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      */
537     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
538         require(sender != address(0), "ERC20: transfer from the zero address");
539         require(recipient != address(0), "ERC20: transfer to the zero address");
540 
541         _beforeTokenTransfer(sender, recipient, amount);
542 
543         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
544         _balances[recipient] = _balances[recipient].add(amount);
545         emit Transfer(sender, recipient, amount);
546     }
547 
548     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
549      * the total supply.
550      *
551      * Emits a {Transfer} event with `from` set to the zero address.
552      *
553      * Requirements:
554      *
555      * - `to` cannot be the zero address.
556      */
557     function _mint(address account, uint256 amount) internal virtual {
558         require(account != address(0), "ERC20: mint to the zero address");
559 
560         _beforeTokenTransfer(address(0), account, amount);
561 
562         _totalSupply = _totalSupply.add(amount);
563         _balances[account] = _balances[account].add(amount);
564         emit Transfer(address(0), account, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, reducing the
569      * total supply.
570      *
571      * Emits a {Transfer} event with `to` set to the zero address.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      * - `account` must have at least `amount` tokens.
577      */
578     function _burn(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: burn from the zero address");
580 
581         _beforeTokenTransfer(account, address(0), amount);
582 
583         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
584         _totalSupply = _totalSupply.sub(amount);
585         emit Transfer(account, address(0), amount);
586     }
587 
588     /**
589      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
590      *
591      * This internal function is equivalent to `approve`, and can be used to
592      * e.g. set automatic allowances for certain subsystems, etc.
593      *
594      * Emits an {Approval} event.
595      *
596      * Requirements:
597      *
598      * - `owner` cannot be the zero address.
599      * - `spender` cannot be the zero address.
600      */
601     function _approve(address owner, address spender, uint256 amount) internal virtual {
602         require(owner != address(0), "ERC20: approve from the zero address");
603         require(spender != address(0), "ERC20: approve to the zero address");
604 
605         _allowances[owner][spender] = amount;
606         emit Approval(owner, spender, amount);
607     }
608 
609     /**
610      * @dev Sets {decimals} to a value other than the default one of 18.
611      *
612      * WARNING: This function should only be called from the constructor. Most
613      * applications that interact with token contracts will not expect
614      * {decimals} to ever change, and may work incorrectly if it does.
615      */
616     function _setupDecimals(uint8 decimals_) internal virtual {
617         _decimals = decimals_;
618     }
619 
620     /**
621      * @dev Hook that is called before any transfer of tokens. This includes
622      * minting and burning.
623      *
624      * Calling conditions:
625      *
626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
627      * will be to transferred to `to`.
628      * - when `from` is zero, `amount` tokens will be minted for `to`.
629      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
630      * - `from` and `to` are never both zero.
631      *
632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
633      */
634     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
635 }
636 
637 
638 // File contracts/NAOToken.sol
639 
640 
641 pragma solidity ^0.7.6;
642 
643 /**
644  * @title NAOToken
645  *
646  * @dev A minimal ERC20 token contract for the NAO token.
647  */
648 contract NAOToken is ERC20("NFTDAO", "NAO") {
649     uint256 private constant TOTAL_SUPPLY = 100000000000000e18;
650 
651     constructor(address genesis_holder) {
652         require(genesis_holder != address(0), "NAOToken: zero address");
653         _mint(genesis_holder, TOTAL_SUPPLY);
654     }
655 }