1 // https://kanon.art - K21
2 //
3 //
4 //                                   $@@@@@@@@@@@$$$
5 //                               $$@@@@@@$$$$$$$$$$$$$$##
6 //                           $$$$$$$$$$$$$$$$$#########***
7 //                        $$$$$$$$$$$$$$$#######**!!!!!!
8 //                     ##$$$$$$$$$$$$#######****!!!!=========
9 //                   ##$$$$$$$$$#$#######*#***!!!=!===;;;;;
10 //                 *#################*#***!*!!======;;;:::
11 //                ################********!!!!====;;;:::~~~~~
12 //              **###########******!!!!!!==;;;;::~~~--,,,-~
13 //             ***########*#*******!*!!!!====;;;::::~~-,,......,-
14 //            ******#**********!*!!!!=!===;;::~~~-,........
15 //           ***************!*!!!!====;;:::~~-,,..........
16 //         !************!!!!!!===;;::~~--,............
17 //         !!!*****!!*!!!!!===;;:::~~--,,..........
18 //        =!!!!!!!!!=!==;;;::~~-,,...........
19 //        =!!!!!!!!!====;;;;:::~~--,........
20 //       ==!!!!!!=!==;=;;:::~~--,...:~~--,,,..
21 //       ===!!!!!=====;;;;;:::~~~--,,..#*=;;:::~--,.
22 //       ;=============;;;;;;::::~~~-,,...$$###==;;:~--.
23 //      :;;==========;;;;;;::::~~~--,,....@@$$##*!=;:~-.
24 //      :;;;;;===;;;;;;;::::~~~--,,...$$$$#*!!=;~-
25 //       :;;;;;;;;;;:::::~~~~---,,...!*##**!==;~,
26 //       :::;:;;;;:::~~~~---,,,...~;=!!!!=;;:~.
27 //       ~:::::::::::::~~~~~---,,,....-:;;=;;;~,
28 //        ~~::::::::~~~~~~~-----,,,......,~~::::~-.
29 //         -~~~~~~~~~~~~~-----------,,,.......,-~~~~~,.
30 //          ---~~~-----,,,,,........,---,.
31 //           ,,--------,,,,,,.........
32 //             .,,,,,,,,,,,,......
33 //                ...............
34 //                    .........
35 
36 
37 // SPDX-License-Identifier: MIT
38 
39 
40 // File: contracts/utils/Context.sol
41 
42 pragma solidity >=0.6.0 <0.8.0;
43 
44 /*
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with GSN meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address payable) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes memory) {
60         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
61         return msg.data;
62     }
63 }
64 
65 // File: contracts/token/ERC20/IERC20.sol
66 
67 
68 pragma solidity ^0.7.0;
69 
70 /**
71  * @dev Interface of the ERC20 standard as defined in the EIP.
72  */
73 interface IERC20 {
74     /**
75      * @dev Returns the amount of tokens in existence.
76      */
77     function totalSupply() external view returns (uint256);
78 
79     /**
80      * @dev Returns the amount of tokens owned by `account`.
81      */
82     function balanceOf(address account) external view returns (uint256);
83 
84     /**
85      * @dev Moves `amount` tokens from the caller's account to `recipient`.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transfer(address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Returns the remaining number of tokens that `spender` will be
95      * allowed to spend on behalf of `owner` through {transferFrom}. This is
96      * zero by default.
97      *
98      * This value changes when {approve} or {transferFrom} are called.
99      */
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     /**
103      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * IMPORTANT: Beware that changing an allowance with this method brings the risk
108      * that someone may use both the old and the new allowance by unfortunate
109      * transaction ordering. One possible solution to mitigate this race
110      * condition is to first reduce the spender's allowance to 0 and set the
111      * desired value afterwards:
112      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Moves `amount` tokens from `sender` to `recipient` using the
120      * allowance mechanism. `amount` is then deducted from the caller's
121      * allowance.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Emitted when `value` tokens are moved from one account (`from`) to
131      * another (`to`).
132      *
133      * Note that `value` may be zero.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     /**
138      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
139      * a call to {approve}. `value` is the new allowance.
140      */
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 // File: contracts/math/SafeMath.sol
145 
146 pragma solidity ^0.7.0;
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, with an overflow flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         uint256 c = a + b;
169         if (c < a) return (false, 0);
170         return (true, c);
171     }
172 
173     /**
174      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
175      *
176      * _Available since v3.4._
177      */
178     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         if (b > a) return (false, 0);
180         return (true, a - b);
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
185      *
186      * _Available since v3.4._
187      */
188     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) return (true, 0);
193         uint256 c = a * b;
194         if (c / a != b) return (false, 0);
195         return (true, c);
196     }
197 
198     /**
199      * @dev Returns the division of two unsigned integers, with a division by zero flag.
200      *
201      * _Available since v3.4._
202      */
203     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
204         if (b == 0) return (false, 0);
205         return (true, a / b);
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
210      *
211      * _Available since v3.4._
212      */
213     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
214         if (b == 0) return (false, 0);
215         return (true, a % b);
216     }
217 
218     /**
219      * @dev Returns the addition of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `+` operator.
223      *
224      * Requirements:
225      *
226      * - Addition cannot overflow.
227      */
228     function add(uint256 a, uint256 b) internal pure returns (uint256) {
229         uint256 c = a + b;
230         require(c >= a, "SafeMath: addition overflow");
231         return c;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting on
236      * overflow (when the result is negative).
237      *
238      * Counterpart to Solidity's `-` operator.
239      *
240      * Requirements:
241      *
242      * - Subtraction cannot overflow.
243      */
244     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b <= a, "SafeMath: subtraction overflow");
246         return a - b;
247     }
248 
249     /**
250      * @dev Returns the multiplication of two unsigned integers, reverting on
251      * overflow.
252      *
253      * Counterpart to Solidity's `*` operator.
254      *
255      * Requirements:
256      *
257      * - Multiplication cannot overflow.
258      */
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         if (a == 0) return 0;
261         uint256 c = a * b;
262         require(c / a == b, "SafeMath: multiplication overflow");
263         return c;
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         require(b > 0, "SafeMath: division by zero");
280         return a / b;
281     }
282 
283     /**
284      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
285      * reverting when dividing by zero.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         require(b > 0, "SafeMath: modulo by zero");
297         return a % b;
298     }
299 
300     /**
301      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
302      * overflow (when the result is negative).
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {trySub}.
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b <= a, errorMessage);
315         return a - b;
316     }
317 
318     /**
319      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
320      * division by zero. The result is rounded towards zero.
321      *
322      * CAUTION: This function is deprecated because it requires allocating memory for the error
323      * message unnecessarily. For custom revert reasons use {tryDiv}.
324      *
325      * Counterpart to Solidity's `/` operator. Note: this function uses a
326      * `revert` opcode (which leaves remaining gas untouched) while Solidity
327      * uses an invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b > 0, errorMessage);
335         return a / b;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * reverting with custom message when dividing by zero.
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {tryMod}.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b > 0, errorMessage);
355         return a % b;
356     }
357 }
358 
359 // File: contracts/token/ERC20/ERC20.sol
360 
361 pragma solidity ^0.7.0;
362 
363 
364 
365 
366 /**
367  * @dev Implementation of the {IERC20} interface.
368  *
369  * This implementation is agnostic to the way tokens are created. This means
370  * that a supply mechanism has to be added in a derived contract using {_mint}.
371  * For a generic mechanism see {ERC20PresetMinterPauser}.
372  *
373  * TIP: For a detailed writeup see our guide
374  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
375  * to implement supply mechanisms].
376  *
377  * We have followed general OpenZeppelin guidelines: functions revert instead
378  * of returning `false` on failure. This behavior is nonetheless conventional
379  * and does not conflict with the expectations of ERC20 applications.
380  *
381  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
382  * This allows applications to reconstruct the allowance for all accounts just
383  * by listening to said events. Other implementations of the EIP may not emit
384  * these events, as it isn't required by the specification.
385  *
386  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
387  * functions have been added to mitigate the well-known issues around setting
388  * allowances. See {IERC20-approve}.
389  */
390 contract ERC20 is Context, IERC20 {
391     using SafeMath for uint256;
392 
393     mapping (address => uint256) private _balances;
394 
395     mapping (address => mapping (address => uint256)) private _allowances;
396 
397     uint256 private _totalSupply;
398 
399     string private _name;
400     string private _symbol;
401     uint8 private _decimals;
402 
403     /**
404      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
405      * a default value of 18.
406      *
407      * To select a different value for {decimals}, use {_setupDecimals}.
408      *
409      * All three of these values are immutable: they can only be set once during
410      * construction.
411      */
412     constructor (string memory name_, string memory symbol_) {
413         _name = name_;
414         _symbol = symbol_;
415         _decimals = 18;
416     }
417 
418     /**
419      * @dev Returns the name of the token.
420      */
421     function name() public view virtual returns (string memory) {
422         return _name;
423     }
424 
425     /**
426      * @dev Returns the symbol of the token, usually a shorter version of the
427      * name.
428      */
429     function symbol() public view virtual returns (string memory) {
430         return _symbol;
431     }
432 
433     /**
434      * @dev Returns the number of decimals used to get its user representation.
435      * For example, if `decimals` equals `2`, a balance of `505` tokens should
436      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
437      *
438      * Tokens usually opt for a value of 18, imitating the relationship between
439      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
440      * called.
441      *
442      * NOTE: This information is only used for _display_ purposes: it in
443      * no way affects any of the arithmetic of the contract, including
444      * {IERC20-balanceOf} and {IERC20-transfer}.
445      */
446     function decimals() public view virtual returns (uint8) {
447         return _decimals;
448     }
449 
450     /**
451      * @dev See {IERC20-totalSupply}.
452      */
453     function totalSupply() public view virtual override returns (uint256) {
454         return _totalSupply;
455     }
456 
457     /**
458      * @dev See {IERC20-balanceOf}.
459      */
460     function balanceOf(address account) public view virtual override returns (uint256) {
461         return _balances[account];
462     }
463 
464     /**
465      * @dev See {IERC20-transfer}.
466      *
467      * Requirements:
468      *
469      * - `recipient` cannot be the zero address.
470      * - the caller must have a balance of at least `amount`.
471      */
472     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
473         _transfer(_msgSender(), recipient, amount);
474         return true;
475     }
476 
477     /**
478      * @dev See {IERC20-allowance}.
479      */
480     function allowance(address owner, address spender) public view virtual override returns (uint256) {
481         return _allowances[owner][spender];
482     }
483 
484     /**
485      * @dev See {IERC20-approve}.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      */
491     function approve(address spender, uint256 amount) public virtual override returns (bool) {
492         _approve(_msgSender(), spender, amount);
493         return true;
494     }
495 
496     /**
497      * @dev See {IERC20-transferFrom}.
498      *
499      * Emits an {Approval} event indicating the updated allowance. This is not
500      * required by the EIP. See the note at the beginning of {ERC20}.
501      *
502      * Requirements:
503      *
504      * - `sender` and `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      * - the caller must have allowance for ``sender``'s tokens of at least
507      * `amount`.
508      */
509     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
510         _transfer(sender, recipient, amount);
511         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
512         return true;
513     }
514 
515     /**
516      * @dev Atomically increases the allowance granted to `spender` by the caller.
517      *
518      * This is an alternative to {approve} that can be used as a mitigation for
519      * problems described in {IERC20-approve}.
520      *
521      * Emits an {Approval} event indicating the updated allowance.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      */
527     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
528         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
529         return true;
530     }
531 
532     /**
533      * @dev Atomically decreases the allowance granted to `spender` by the caller.
534      *
535      * This is an alternative to {approve} that can be used as a mitigation for
536      * problems described in {IERC20-approve}.
537      *
538      * Emits an {Approval} event indicating the updated allowance.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      * - `spender` must have allowance for the caller of at least
544      * `subtractedValue`.
545      */
546     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
547         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
548         return true;
549     }
550 
551     /**
552      * @dev Moves tokens `amount` from `sender` to `recipient`.
553      *
554      * This is internal function is equivalent to {transfer}, and can be used to
555      * e.g. implement automatic token fees, slashing mechanisms, etc.
556      *
557      * Emits a {Transfer} event.
558      *
559      * Requirements:
560      *
561      * - `sender` cannot be the zero address.
562      * - `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `amount`.
564      */
565     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
566         require(sender != address(0), "ERC20: transfer from the zero address");
567         require(recipient != address(0), "ERC20: transfer to the zero address");
568 
569         _beforeTokenTransfer(sender, recipient, amount);
570 
571         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
572         _balances[recipient] = _balances[recipient].add(amount);
573         emit Transfer(sender, recipient, amount);
574     }
575 
576     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
577      * the total supply.
578      *
579      * Emits a {Transfer} event with `from` set to the zero address.
580      *
581      * Requirements:
582      *
583      * - `to` cannot be the zero address.
584      */
585     function _mint(address account, uint256 amount) internal virtual {
586         require(account != address(0), "ERC20: mint to the zero address");
587 
588         _beforeTokenTransfer(address(0), account, amount);
589 
590         _totalSupply = _totalSupply.add(amount);
591         _balances[account] = _balances[account].add(amount);
592         emit Transfer(address(0), account, amount);
593     }
594 
595     /**
596      * @dev Destroys `amount` tokens from `account`, reducing the
597      * total supply.
598      *
599      * Emits a {Transfer} event with `to` set to the zero address.
600      *
601      * Requirements:
602      *
603      * - `account` cannot be the zero address.
604      * - `account` must have at least `amount` tokens.
605      */
606     function _burn(address account, uint256 amount) internal virtual {
607         require(account != address(0), "ERC20: burn from the zero address");
608 
609         _beforeTokenTransfer(account, address(0), amount);
610 
611         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
612         _totalSupply = _totalSupply.sub(amount);
613         emit Transfer(account, address(0), amount);
614     }
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
618      *
619      * This internal function is equivalent to `approve`, and can be used to
620      * e.g. set automatic allowances for certain subsystems, etc.
621      *
622      * Emits an {Approval} event.
623      *
624      * Requirements:
625      *
626      * - `owner` cannot be the zero address.
627      * - `spender` cannot be the zero address.
628      */
629     function _approve(address owner, address spender, uint256 amount) internal virtual {
630         require(owner != address(0), "ERC20: approve from the zero address");
631         require(spender != address(0), "ERC20: approve to the zero address");
632 
633         _allowances[owner][spender] = amount;
634         emit Approval(owner, spender, amount);
635     }
636 
637     /**
638      * @dev Sets {decimals} to a value other than the default one of 18.
639      *
640      * WARNING: This function should only be called from the constructor. Most
641      * applications that interact with token contracts will not expect
642      * {decimals} to ever change, and may work incorrectly if it does.
643      */
644     function _setupDecimals(uint8 decimals_) internal virtual {
645         _decimals = decimals_;
646     }
647 
648     /**
649      * @dev Hook that is called before any transfer of tokens. This includes
650      * minting and burning.
651      *
652      * Calling conditions:
653      *
654      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
655      * will be to transferred to `to`.
656      * - when `from` is zero, `amount` tokens will be minted for `to`.
657      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
658      * - `from` and `to` are never both zero.
659      *
660      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
661      */
662     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
663 }
664 
665 pragma solidity ^0.7.5;
666 
667 contract K21 is ERC20 {
668 
669     constructor () ERC20("k21.kanon.art", "K21") {
670         _mint(0x32EEA10639B92c71846edCC8D3415Cf6eff0645D, 21000000 * (10 ** uint256(decimals())));
671     }
672 }