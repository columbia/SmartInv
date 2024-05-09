1 // Sources flattened with hardhat v2.0.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
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
20     function _msgSender() internal virtual view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal virtual view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount)
56         external
57         returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender)
67         external
68         view
69         returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
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
114     event Approval(
115         address indexed owner,
116         address indexed spender,
117         uint256 value
118     );
119 }
120 
121 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
122 
123 pragma solidity >=0.6.0 <0.8.0;
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, "SafeMath: division by zero");
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         require(b > 0, errorMessage);
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         return mod(a, b, "SafeMath: modulo by zero");
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts with custom message when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 }
292 
293 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
294 
295 pragma solidity >=0.6.0 <0.8.0;
296 
297 /**
298  * @dev Implementation of the {IERC20} interface.
299  *
300  * This implementation is agnostic to the way tokens are created. This means
301  * that a supply mechanism has to be added in a derived contract using {_mint}.
302  * For a generic mechanism see {ERC20PresetMinterPauser}.
303  *
304  * TIP: For a detailed writeup see our guide
305  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
306  * to implement supply mechanisms].
307  *
308  * We have followed general OpenZeppelin guidelines: functions revert instead
309  * of returning `false` on failure. This behavior is nonetheless conventional
310  * and does not conflict with the expectations of ERC20 applications.
311  *
312  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
313  * This allows applications to reconstruct the allowance for all accounts just
314  * by listening to said events. Other implementations of the EIP may not emit
315  * these events, as it isn't required by the specification.
316  *
317  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
318  * functions have been added to mitigate the well-known issues around setting
319  * allowances. See {IERC20-approve}.
320  */
321 contract ERC20 is Context, IERC20 {
322     using SafeMath for uint256;
323 
324     mapping(address => uint256) private _balances;
325 
326     mapping(address => mapping(address => uint256)) private _allowances;
327 
328     uint256 private _totalSupply;
329 
330     string private _name;
331     string private _symbol;
332     uint8 private _decimals;
333 
334     /**
335      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
336      * a default value of 18.
337      *
338      * To select a different value for {decimals}, use {_setupDecimals}.
339      *
340      * All three of these values are immutable: they can only be set once during
341      * construction.
342      */
343     constructor(string memory name_, string memory symbol_) public {
344         _name = name_;
345         _symbol = symbol_;
346         _decimals = 18;
347     }
348 
349     /**
350      * @dev Returns the name of the token.
351      */
352     function name() public view returns (string memory) {
353         return _name;
354     }
355 
356     /**
357      * @dev Returns the symbol of the token, usually a shorter version of the
358      * name.
359      */
360     function symbol() public view returns (string memory) {
361         return _symbol;
362     }
363 
364     /**
365      * @dev Returns the number of decimals used to get its user representation.
366      * For example, if `decimals` equals `2`, a balance of `505` tokens should
367      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
368      *
369      * Tokens usually opt for a value of 18, imitating the relationship between
370      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
371      * called.
372      *
373      * NOTE: This information is only used for _display_ purposes: it in
374      * no way affects any of the arithmetic of the contract, including
375      * {IERC20-balanceOf} and {IERC20-transfer}.
376      */
377     function decimals() public view returns (uint8) {
378         return _decimals;
379     }
380 
381     /**
382      * @dev See {IERC20-totalSupply}.
383      */
384     function totalSupply() public override view returns (uint256) {
385         return _totalSupply;
386     }
387 
388     /**
389      * @dev See {IERC20-balanceOf}.
390      */
391     function balanceOf(address account) public override view returns (uint256) {
392         return _balances[account];
393     }
394 
395     /**
396      * @dev See {IERC20-transfer}.
397      *
398      * Requirements:
399      *
400      * - `recipient` cannot be the zero address.
401      * - the caller must have a balance of at least `amount`.
402      */
403     function transfer(address recipient, uint256 amount)
404         public
405         virtual
406         override
407         returns (bool)
408     {
409         _transfer(_msgSender(), recipient, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-allowance}.
415      */
416     function allowance(address owner, address spender)
417         public
418         virtual
419         override
420         view
421         returns (uint256)
422     {
423         return _allowances[owner][spender];
424     }
425 
426     /**
427      * @dev See {IERC20-approve}.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function approve(address spender, uint256 amount)
434         public
435         virtual
436         override
437         returns (bool)
438     {
439         _approve(_msgSender(), spender, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-transferFrom}.
445      *
446      * Emits an {Approval} event indicating the updated allowance. This is not
447      * required by the EIP. See the note at the beginning of {ERC20}.
448      *
449      * Requirements:
450      *
451      * - `sender` and `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      * - the caller must have allowance for ``sender``'s tokens of at least
454      * `amount`.
455      */
456     function transferFrom(
457         address sender,
458         address recipient,
459         uint256 amount
460     ) public virtual override returns (bool) {
461         _transfer(sender, recipient, amount);
462         _approve(
463             sender,
464             _msgSender(),
465             _allowances[sender][_msgSender()].sub(
466                 amount,
467                 "ERC20: transfer amount exceeds allowance"
468             )
469         );
470         return true;
471     }
472 
473     /**
474      * @dev Atomically increases the allowance granted to `spender` by the caller.
475      *
476      * This is an alternative to {approve} that can be used as a mitigation for
477      * problems described in {IERC20-approve}.
478      *
479      * Emits an {Approval} event indicating the updated allowance.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      */
485     function increaseAllowance(address spender, uint256 addedValue)
486         public
487         virtual
488         returns (bool)
489     {
490         _approve(
491             _msgSender(),
492             spender,
493             _allowances[_msgSender()][spender].add(addedValue)
494         );
495         return true;
496     }
497 
498     /**
499      * @dev Atomically decreases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      * - `spender` must have allowance for the caller of at least
510      * `subtractedValue`.
511      */
512     function decreaseAllowance(address spender, uint256 subtractedValue)
513         public
514         virtual
515         returns (bool)
516     {
517         _approve(
518             _msgSender(),
519             spender,
520             _allowances[_msgSender()][spender].sub(
521                 subtractedValue,
522                 "ERC20: decreased allowance below zero"
523             )
524         );
525         return true;
526     }
527 
528     /**
529      * @dev Moves tokens `amount` from `sender` to `recipient`.
530      *
531      * This is internal function is equivalent to {transfer}, and can be used to
532      * e.g. implement automatic token fees, slashing mechanisms, etc.
533      *
534      * Emits a {Transfer} event.
535      *
536      * Requirements:
537      *
538      * - `sender` cannot be the zero address.
539      * - `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      */
542     function _transfer(
543         address sender,
544         address recipient,
545         uint256 amount
546     ) internal virtual {
547         require(sender != address(0), "ERC20: transfer from the zero address");
548         require(recipient != address(0), "ERC20: transfer to the zero address");
549 
550         _beforeTokenTransfer(sender, recipient, amount);
551 
552         _balances[sender] = _balances[sender].sub(
553             amount,
554             "ERC20: transfer amount exceeds balance"
555         );
556         _balances[recipient] = _balances[recipient].add(amount);
557         emit Transfer(sender, recipient, amount);
558     }
559 
560     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
561      * the total supply.
562      *
563      * Emits a {Transfer} event with `from` set to the zero address.
564      *
565      * Requirements:
566      *
567      * - `to` cannot be the zero address.
568      */
569     function _mint(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: mint to the zero address");
571 
572         _beforeTokenTransfer(address(0), account, amount);
573 
574         _totalSupply = _totalSupply.add(amount);
575         _balances[account] = _balances[account].add(amount);
576         emit Transfer(address(0), account, amount);
577     }
578 
579     /**
580      * @dev Destroys `amount` tokens from `account`, reducing the
581      * total supply.
582      *
583      * Emits a {Transfer} event with `to` set to the zero address.
584      *
585      * Requirements:
586      *
587      * - `account` cannot be the zero address.
588      * - `account` must have at least `amount` tokens.
589      */
590     function _burn(address account, uint256 amount) internal virtual {
591         require(account != address(0), "ERC20: burn from the zero address");
592 
593         _beforeTokenTransfer(account, address(0), amount);
594 
595         _balances[account] = _balances[account].sub(
596             amount,
597             "ERC20: burn amount exceeds balance"
598         );
599         _totalSupply = _totalSupply.sub(amount);
600         emit Transfer(account, address(0), amount);
601     }
602 
603     /**
604      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
605      *
606      * This internal function is equivalent to `approve`, and can be used to
607      * e.g. set automatic allowances for certain subsystems, etc.
608      *
609      * Emits an {Approval} event.
610      *
611      * Requirements:
612      *
613      * - `owner` cannot be the zero address.
614      * - `spender` cannot be the zero address.
615      */
616     function _approve(
617         address owner,
618         address spender,
619         uint256 amount
620     ) internal virtual {
621         require(owner != address(0), "ERC20: approve from the zero address");
622         require(spender != address(0), "ERC20: approve to the zero address");
623 
624         _allowances[owner][spender] = amount;
625         emit Approval(owner, spender, amount);
626     }
627 
628     /**
629      * @dev Sets {decimals} to a value other than the default one of 18.
630      *
631      * WARNING: This function should only be called from the constructor. Most
632      * applications that interact with token contracts will not expect
633      * {decimals} to ever change, and may work incorrectly if it does.
634      */
635     function _setupDecimals(uint8 decimals_) internal {
636         _decimals = decimals_;
637     }
638 
639     /**
640      * @dev Hook that is called before any transfer of tokens. This includes
641      * minting and burning.
642      *
643      * Calling conditions:
644      *
645      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
646      * will be to transferred to `to`.
647      * - when `from` is zero, `amount` tokens will be minted for `to`.
648      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
649      * - `from` and `to` are never both zero.
650      *
651      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
652      */
653     function _beforeTokenTransfer(
654         address from,
655         address to,
656         uint256 amount
657     ) internal virtual {}
658 }
659 
660 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.3.0
661 
662 pragma solidity >=0.6.0 <0.8.0;
663 
664 /**
665  * @dev Extension of {ERC20} that allows token holders to destroy both their own
666  * tokens and those that they have an allowance for, in a way that can be
667  * recognized off-chain (via event analysis).
668  */
669 abstract contract ERC20Burnable is Context, ERC20 {
670     using SafeMath for uint256;
671 
672     /**
673      * @dev Destroys `amount` tokens from the caller.
674      *
675      * See {ERC20-_burn}.
676      */
677     function burn(uint256 amount) public virtual {
678         _burn(_msgSender(), amount);
679     }
680 
681     /**
682      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
683      * allowance.
684      *
685      * See {ERC20-_burn} and {ERC20-allowance}.
686      *
687      * Requirements:
688      *
689      * - the caller must have allowance for ``accounts``'s tokens of at least
690      * `amount`.
691      */
692     function burnFrom(address account, uint256 amount) public virtual {
693         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
694             amount,
695             "ERC20: burn amount exceeds allowance"
696         );
697 
698         _approve(account, _msgSender(), decreasedAllowance);
699         _burn(account, amount);
700     }
701 }
702 
703 // File contracts/Predictr.sol
704 
705 pragma solidity ^0.6.12;
706 
707 /**
708  * @title PredictrToken
709  * @dev Utility token for Predictr platform
710  */
711 contract PredictrToken is ERC20, ERC20Burnable {
712     uint8 public constant DECIMALS = 18;
713     uint256 public constant INITIAL_SUPPLY = 190000 * (10**uint256(DECIMALS));
714 
715     /**
716      * @dev Constructor that gives _msgSender() all of existing tokens.
717      */
718     constructor() public ERC20("Predictr", "PDCT") {
719         _mint(msg.sender, INITIAL_SUPPLY);
720     }
721 }