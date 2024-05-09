1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations.
80  */
81 library SafeMath {
82     /**
83      * @dev Returns the addition of two unsigned integers, with an overflow flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             uint256 c = a + b;
90             if (c < a) return (false, 0);
91             return (true, c);
92         }
93     }
94 
95     /**
96      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
97      *
98      * _Available since v3.4._
99      */
100     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102             if (b > a) return (false, 0);
103             return (true, a - b);
104         }
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
109      *
110      * _Available since v3.4._
111      */
112     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         unchecked {
114             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115             // benefit is lost if 'b' is also tested.
116             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117             if (a == 0) return (true, 0);
118             uint256 c = a * b;
119             if (c / a != b) return (false, 0);
120             return (true, c);
121         }
122     }
123 
124     /**
125      * @dev Returns the division of two unsigned integers, with a division by zero flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             if (b == 0) return (false, 0);
132             return (true, a / b);
133         }
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             if (b == 0) return (false, 0);
144             return (true, a % b);
145         }
146     }
147 
148     /**
149      * @dev Returns the addition of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `+` operator.
153      *
154      * Requirements:
155      *
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a + b;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a - b;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a * b;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator.
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a / b;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a % b;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
222      * overflow (when the result is negative).
223      *
224      * CAUTION: This function is deprecated because it requires allocating memory for the error
225      * message unnecessarily. For custom revert reasons use {trySub}.
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      *
231      * - Subtraction cannot overflow.
232      */
233     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         unchecked {
235             require(b <= a, errorMessage);
236             return a - b;
237         }
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         unchecked {
258             require(b > 0, errorMessage);
259             return a / b;
260         }
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * reverting with custom message when dividing by zero.
266      *
267      * CAUTION: This function is deprecated because it requires allocating memory for the error
268      * message unnecessarily. For custom revert reasons use {tryMod}.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         unchecked {
280             require(b > 0, errorMessage);
281             return a % b;
282         }
283     }
284 }
285 
286 
287 /*
288  * @dev Provides information about the current execution context, including the
289  * sender of the transaction and its data. While these are generally available
290  * via msg.sender and msg.data, they should not be accessed in such a direct
291  * manner, since when dealing with GSN meta-transactions the account sending and
292  * paying for execution may not be the actual sender (as far as an application
293  * is concerned).
294  *
295  * This contract is only required for intermediate, library-like contracts.
296  */
297 abstract contract Context {
298     function _msgSender() internal view virtual returns (address) {
299         return msg.sender;
300     }
301 
302     function _msgData() internal view virtual returns (bytes calldata) {
303         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
304         return msg.data;
305     }
306 }
307 
308 
309 /**
310  * @dev Implementation of the {IERC20} interface.
311  *
312  * This implementation is agnostic to the way tokens are created. This means
313  * that a supply mechanism has to be added in a derived contract using {_mint}.
314  * For a generic mechanism see {ERC20PresetMinterPauser}.
315  *
316  * TIP: For a detailed writeup see our guide
317  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
318  * to implement supply mechanisms].
319  *
320  * We have followed general OpenZeppelin guidelines: functions revert instead
321  * of returning `false` on failure. This behavior is nonetheless conventional
322  * and does not conflict with the expectations of ERC20 applications.
323  *
324  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
325  * This allows applications to reconstruct the allowance for all accounts just
326  * by listening to said events. Other implementations of the EIP may not emit
327  * these events, as it isn't required by the specification.
328  *
329  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
330  * functions have been added to mitigate the well-known issues around setting
331  * allowances. See {IERC20-approve}.
332  */
333 contract ERC20 is Context, IERC20 {
334     mapping (address => uint256) private _balances;
335 
336     mapping (address => mapping (address => uint256)) private _allowances;
337 
338     uint256 private _totalSupply;
339 
340     string private _name;
341     string private _symbol;
342 
343     /**
344      * @dev Sets the values for {name} and {symbol}.
345      *
346      * The defaut value of {decimals} is 18. To select a different value for
347      * {decimals} you should overload it.
348      *
349      * All three of these values are immutable: they can only be set once during
350      * construction.
351      */
352     constructor (string memory name_, string memory symbol_) {
353         _name = name_;
354         _symbol = symbol_;
355     }
356 
357     /**
358      * @dev Returns the name of the token.
359      */
360     function name() public view virtual returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @dev Returns the symbol of the token, usually a shorter version of the
366      * name.
367      */
368     function symbol() public view virtual returns (string memory) {
369         return _symbol;
370     }
371 
372     /**
373      * @dev Returns the number of decimals used to get its user representation.
374      * For example, if `decimals` equals `2`, a balance of `505` tokens should
375      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
376      *
377      * Tokens usually opt for a value of 18, imitating the relationship between
378      * Ether and Wei. This is the value {ERC20} uses, unless this function is
379      * overloaded;
380      *
381      * NOTE: This information is only used for _display_ purposes: it in
382      * no way affects any of the arithmetic of the contract, including
383      * {IERC20-balanceOf} and {IERC20-transfer}.
384      */
385     function decimals() public view virtual returns (uint8) {
386         return 18;
387     }
388 
389     /**
390      * @dev See {IERC20-totalSupply}.
391      */
392     function totalSupply() public view virtual override returns (uint256) {
393         return _totalSupply;
394     }
395 
396     /**
397      * @dev See {IERC20-balanceOf}.
398      */
399     function balanceOf(address account) public view virtual override returns (uint256) {
400         return _balances[account];
401     }
402 
403     /**
404      * @dev See {IERC20-transfer}.
405      *
406      * Requirements:
407      *
408      * - `recipient` cannot be the zero address.
409      * - the caller must have a balance of at least `amount`.
410      */
411     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
412         _transfer(_msgSender(), recipient, amount);
413         return true;
414     }
415     
416     /**
417      * @dev this function is for batched transfers with emphasis placed on gas savings
418      * 
419      * Requirements:
420      * 
421      * - `recipients` and `values` arguments must have same length. 
422      * - the caller must have a balance of at least `values`.
423      */ 
424     function transferBatched(address[] calldata _recipients, uint[] calldata _values) external returns (bool) {
425         require(_recipients.length == _values.length);
426         
427         uint256 senderBalance = _balances[msg.sender];
428         
429         for (uint256 i = 0; i < _values.length; i++) {
430             
431             uint256 value = _values[i];
432             address to = _recipients[i];
433             
434             require(senderBalance >= value);
435             
436             if(msg.sender != _recipients[i]){
437                 senderBalance = senderBalance - value;
438                 _balances[to] += value;
439             }
440 			emit Transfer(msg.sender, to, value);
441         }
442         _balances[msg.sender] = senderBalance;
443         return true;
444 }
445 
446     /**
447      * @dev See {IERC20-allowance}.
448      */
449     function allowance(address owner, address spender) public view virtual override returns (uint256) {
450         return _allowances[owner][spender];
451     }
452 
453     /**
454      * @dev See {IERC20-approve}.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      */
460     function approve(address spender, uint256 amount) public virtual override returns (bool) {
461         _approve(_msgSender(), spender, amount);
462         return true;
463     }
464 
465     /**
466      * @dev See {IERC20-transferFrom}.
467      *
468      * Emits an {Approval} event indicating the updated allowance. This is not
469      * required by the EIP. See the note at the beginning of {ERC20}.
470      *
471      * Requirements:
472      *
473      * - `sender` and `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      * - the caller must have allowance for ``sender``'s tokens of at least
476      * `amount`.
477      */
478     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
479         _transfer(sender, recipient, amount);
480 
481         uint256 currentAllowance = _allowances[sender][_msgSender()];
482         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
483         _approve(sender, _msgSender(), currentAllowance - amount);
484 
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
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
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
520         uint256 currentAllowance = _allowances[_msgSender()][spender];
521         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
522         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
523 
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
547         uint256 senderBalance = _balances[sender];
548         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
549         _balances[sender] = senderBalance - amount;
550         _balances[recipient] += amount;
551 
552         emit Transfer(sender, recipient, amount);
553     }
554 
555     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
556      * the total supply.
557      *
558      * Emits a {Transfer} event with `from` set to the zero address.
559      *
560      * Requirements:
561      *
562      * - `to` cannot be the zero address.
563      */
564     function _mint(address account, uint256 amount) internal virtual {
565         require(account != address(0), "ERC20: mint to the zero address");
566 
567         _beforeTokenTransfer(address(0), account, amount);
568 
569         _totalSupply += amount;
570         _balances[account] += amount;
571         emit Transfer(address(0), account, amount);
572     }
573 
574     /**
575      * @dev Destroys `amount` tokens from `account`, reducing the
576      * total supply.
577      *
578      * Emits a {Transfer} event with `to` set to the zero address.
579      *
580      * Requirements:
581      *
582      * - `account` cannot be the zero address.
583      * - `account` must have at least `amount` tokens.
584      */
585     function _burn(address account, uint256 amount) internal virtual {
586         require(account != address(0), "ERC20: burn from the zero address");
587 
588         _beforeTokenTransfer(account, address(0), amount);
589 
590         uint256 accountBalance = _balances[account];
591         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
592         _balances[account] = accountBalance - amount;
593         _totalSupply -= amount;
594 
595         emit Transfer(account, address(0), amount);
596     }
597 
598     /**
599      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
600      *
601      * This internal function is equivalent to `approve`, and can be used to
602      * e.g. set automatic allowances for certain subsystems, etc.
603      *
604      * Emits an {Approval} event.
605      *
606      * Requirements:
607      *
608      * - `owner` cannot be the zero address.
609      * - `spender` cannot be the zero address.
610      */
611     function _approve(address owner, address spender, uint256 amount) internal virtual {
612         require(owner != address(0), "ERC20: approve from the zero address");
613         require(spender != address(0), "ERC20: approve to the zero address");
614 
615         _allowances[owner][spender] = amount;
616         emit Approval(owner, spender, amount);
617     }
618 
619     /**
620      * @dev Hook that is called before any transfer of tokens. This includes
621      * minting and burning.
622      *
623      * Calling conditions:
624      *
625      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
626      * will be to transferred to `to`.
627      * - when `from` is zero, `amount` tokens will be minted for `to`.
628      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
629      * - `from` and `to` are never both zero.
630      *
631      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
632      */
633     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
634 }
635 
636 /**
637  * @dev Implementation of the Modefi token.
638  * This token adheres to the ERC-20 token standard based on OpenZeppelin guidelines.  
639  */
640 contract ModefiToken is ERC20 {
641 
642     /**
643      * @dev Sets the values for {name}, {symbol}, {initialAccount}, and {initialBalance}.
644      *
645      * The defaut value of {decimals} is 18. 
646      * To select a different value for {decimals} you should overload it.
647      *
648      * The value of {initialBalance} is the total supply.
649      * The value of {initialAccount} will be minted the value of {initialBalance}.
650      */    
651     constructor (
652         string memory name,
653         string memory symbol,
654         address initialAccount,
655         uint256 initialBalance
656     ) payable ERC20(name, symbol) {
657         _mint(initialAccount, initialBalance);
658     }
659 
660     /**
661      * @dev Wrapper function which externally exposes the internal _burn() function.
662      */
663     function burn(uint256 amount) external {
664         _burn(msg.sender, amount);
665     }
666     
667 }