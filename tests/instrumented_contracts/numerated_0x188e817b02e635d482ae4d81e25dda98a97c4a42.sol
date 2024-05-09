1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
28 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address sender,
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(
280         uint256 a,
281         uint256 b,
282         string memory errorMessage
283     ) internal pure returns (uint256) {
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
303     function div(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
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
327     function mod(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         require(b > 0, errorMessage);
333         return a % b;
334     }
335 }
336 
337 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
338 
339 pragma solidity >=0.6.0 <0.8.0;
340 
341 /**
342  * @dev Implementation of the {IERC20} interface.
343  *
344  * This implementation is agnostic to the way tokens are created. This means
345  * that a supply mechanism has to be added in a derived contract using {_mint}.
346  * For a generic mechanism see {ERC20PresetMinterPauser}.
347  *
348  * TIP: For a detailed writeup see our guide
349  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
350  * to implement supply mechanisms].
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
364  */
365 contract ERC20 is Context, IERC20 {
366     using SafeMath for uint256;
367 
368     mapping(address => uint256) private _balances;
369 
370     mapping(address => mapping(address => uint256)) private _allowances;
371 
372     uint256 private _totalSupply;
373 
374     string private _name;
375     string private _symbol;
376     uint8 private _decimals;
377 
378     /**
379      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
380      * a default value of 18.
381      *
382      * To select a different value for {decimals}, use {_setupDecimals}.
383      *
384      * All three of these values are immutable: they can only be set once during
385      * construction.
386      */
387     constructor(string memory name_, string memory symbol_) public {
388         _name = name_;
389         _symbol = symbol_;
390         _decimals = 18;
391     }
392 
393     /**
394      * @dev Returns the name of the token.
395      */
396     function name() public view virtual returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @dev Returns the symbol of the token, usually a shorter version of the
402      * name.
403      */
404     function symbol() public view virtual returns (string memory) {
405         return _symbol;
406     }
407 
408     /**
409      * @dev Returns the number of decimals used to get its user representation.
410      * For example, if `decimals` equals `2`, a balance of `505` tokens should
411      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
412      *
413      * Tokens usually opt for a value of 18, imitating the relationship between
414      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
415      * called.
416      *
417      * NOTE: This information is only used for _display_ purposes: it in
418      * no way affects any of the arithmetic of the contract, including
419      * {IERC20-balanceOf} and {IERC20-transfer}.
420      */
421     function decimals() public view virtual returns (uint8) {
422         return _decimals;
423     }
424 
425     /**
426      * @dev See {IERC20-totalSupply}.
427      */
428     function totalSupply() public view virtual override returns (uint256) {
429         return _totalSupply;
430     }
431 
432     /**
433      * @dev See {IERC20-balanceOf}.
434      */
435     function balanceOf(address account) public view virtual override returns (uint256) {
436         return _balances[account];
437     }
438 
439     /**
440      * @dev See {IERC20-transfer}.
441      *
442      * Requirements:
443      *
444      * - `recipient` cannot be the zero address.
445      * - the caller must have a balance of at least `amount`.
446      */
447     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
448         _transfer(_msgSender(), recipient, amount);
449         return true;
450     }
451 
452     /**
453      * @dev See {IERC20-allowance}.
454      */
455     function allowance(address owner, address spender) public view virtual override returns (uint256) {
456         return _allowances[owner][spender];
457     }
458 
459     /**
460      * @dev See {IERC20-approve}.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function approve(address spender, uint256 amount) public virtual override returns (bool) {
467         _approve(_msgSender(), spender, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-transferFrom}.
473      *
474      * Emits an {Approval} event indicating the updated allowance. This is not
475      * required by the EIP. See the note at the beginning of {ERC20}.
476      *
477      * Requirements:
478      *
479      * - `sender` and `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      * - the caller must have allowance for ``sender``'s tokens of at least
482      * `amount`.
483      */
484     function transferFrom(
485         address sender,
486         address recipient,
487         uint256 amount
488     ) public virtual override returns (bool) {
489         _transfer(sender, recipient, amount);
490         _approve(
491             sender,
492             _msgSender(),
493             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
494         );
495         return true;
496     }
497 
498     /**
499      * @dev Atomically increases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      */
510     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
512         return true;
513     }
514 
515     /**
516      * @dev Atomically decreases the allowance granted to `spender` by the caller.
517      *
518      * This is an alternative to {approve} that can be used as a mitigation for
519      * problems described in {IERC20-approve}.
520      *
521      * Emits an {Approval} event indicating the updated allowance.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      * - `spender` must have allowance for the caller of at least
527      * `subtractedValue`.
528      */
529     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
530         _approve(
531             _msgSender(),
532             spender,
533             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
534         );
535         return true;
536     }
537 
538     /**
539      * @dev Moves tokens `amount` from `sender` to `recipient`.
540      *
541      * This is internal function is equivalent to {transfer}, and can be used to
542      * e.g. implement automatic token fees, slashing mechanisms, etc.
543      *
544      * Emits a {Transfer} event.
545      *
546      * Requirements:
547      *
548      * - `sender` cannot be the zero address.
549      * - `recipient` cannot be the zero address.
550      * - `sender` must have a balance of at least `amount`.
551      */
552     function _transfer(
553         address sender,
554         address recipient,
555         uint256 amount
556     ) internal virtual {
557         require(sender != address(0), "ERC20: transfer from the zero address");
558         require(recipient != address(0), "ERC20: transfer to the zero address");
559 
560         _beforeTokenTransfer(sender, recipient, amount);
561 
562         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
563         _balances[recipient] = _balances[recipient].add(amount);
564         emit Transfer(sender, recipient, amount);
565     }
566 
567     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
568      * the total supply.
569      *
570      * Emits a {Transfer} event with `from` set to the zero address.
571      *
572      * Requirements:
573      *
574      * - `to` cannot be the zero address.
575      */
576     function _mint(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: mint to the zero address");
578 
579         _beforeTokenTransfer(address(0), account, amount);
580 
581         _totalSupply = _totalSupply.add(amount);
582         _balances[account] = _balances[account].add(amount);
583         emit Transfer(address(0), account, amount);
584     }
585 
586     /**
587      * @dev Destroys `amount` tokens from `account`, reducing the
588      * total supply.
589      *
590      * Emits a {Transfer} event with `to` set to the zero address.
591      *
592      * Requirements:
593      *
594      * - `account` cannot be the zero address.
595      * - `account` must have at least `amount` tokens.
596      */
597     function _burn(address account, uint256 amount) internal virtual {
598         require(account != address(0), "ERC20: burn from the zero address");
599 
600         _beforeTokenTransfer(account, address(0), amount);
601 
602         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
603         _totalSupply = _totalSupply.sub(amount);
604         emit Transfer(account, address(0), amount);
605     }
606 
607     /**
608      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
609      *
610      * This internal function is equivalent to `approve`, and can be used to
611      * e.g. set automatic allowances for certain subsystems, etc.
612      *
613      * Emits an {Approval} event.
614      *
615      * Requirements:
616      *
617      * - `owner` cannot be the zero address.
618      * - `spender` cannot be the zero address.
619      */
620     function _approve(
621         address owner,
622         address spender,
623         uint256 amount
624     ) internal virtual {
625         require(owner != address(0), "ERC20: approve from the zero address");
626         require(spender != address(0), "ERC20: approve to the zero address");
627 
628         _allowances[owner][spender] = amount;
629         emit Approval(owner, spender, amount);
630     }
631 
632     /**
633      * @dev Sets {decimals} to a value other than the default one of 18.
634      *
635      * WARNING: This function should only be called from the constructor. Most
636      * applications that interact with token contracts will not expect
637      * {decimals} to ever change, and may work incorrectly if it does.
638      */
639     function _setupDecimals(uint8 decimals_) internal virtual {
640         _decimals = decimals_;
641     }
642 
643     /**
644      * @dev Hook that is called before any transfer of tokens. This includes
645      * minting and burning.
646      *
647      * Calling conditions:
648      *
649      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
650      * will be to transferred to `to`.
651      * - when `from` is zero, `amount` tokens will be minted for `to`.
652      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
653      * - `from` and `to` are never both zero.
654      *
655      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
656      */
657     function _beforeTokenTransfer(
658         address from,
659         address to,
660         uint256 amount
661     ) internal virtual {}
662 }
663 
664 // File contracts/LithiumToken.sol
665 
666 pragma solidity ^0.7.6;
667 
668 /**
669  * @title LithiumToken
670  *
671  * @dev A minimal ERC20 token contract for the Lithium token.
672  */
673 contract LithiumToken is ERC20("Lithium", "LITH") {
674     uint256 private constant TOTAL_SUPPLY = 10000000000e18;
675 
676     constructor(address genesis_holder) {
677         require(genesis_holder != address(0), "LithiumToken: zero address");
678         _mint(genesis_holder, TOTAL_SUPPLY);
679     }
680 }