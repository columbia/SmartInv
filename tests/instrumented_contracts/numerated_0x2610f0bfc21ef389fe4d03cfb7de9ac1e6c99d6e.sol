1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-28
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 pragma solidity >=0.6.0 <0.8.0;
88 
89 /*
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with GSN meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address payable) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes memory) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 
111 pragma solidity >=0.6.0 <0.8.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         uint256 c = a + b;
134         if (c < a) return (false, 0);
135         return (true, c);
136     }
137 
138     /**
139      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
140      *
141      * _Available since v3.4._
142      */
143     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         if (b > a) return (false, 0);
145         return (true, a - b);
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) return (true, 0);
158         uint256 c = a * b;
159         if (c / a != b) return (false, 0);
160         return (true, c);
161     }
162 
163     /**
164      * @dev Returns the division of two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         if (b == 0) return (false, 0);
170         return (true, a / b);
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         if (b == 0) return (false, 0);
180         return (true, a % b);
181     }
182 
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196         return c;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         require(b <= a, "SafeMath: subtraction overflow");
211         return a - b;
212     }
213 
214     /**
215      * @dev Returns the multiplication of two unsigned integers, reverting on
216      * overflow.
217      *
218      * Counterpart to Solidity's `*` operator.
219      *
220      * Requirements:
221      *
222      * - Multiplication cannot overflow.
223      */
224     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225         if (a == 0) return 0;
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers, reverting on
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
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         require(b > 0, "SafeMath: division by zero");
245         return a / b;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * reverting when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         require(b > 0, "SafeMath: modulo by zero");
262         return a % b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {trySub}.
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b <= a, errorMessage);
280         return a - b;
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
285      * division by zero. The result is rounded towards zero.
286      *
287      * CAUTION: This function is deprecated because it requires allocating memory for the error
288      * message unnecessarily. For custom revert reasons use {tryDiv}.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         return a / b;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * reverting with custom message when dividing by zero.
306      *
307      * CAUTION: This function is deprecated because it requires allocating memory for the error
308      * message unnecessarily. For custom revert reasons use {tryMod}.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b > 0, errorMessage);
320         return a % b;
321     }
322 }
323 
324 pragma solidity >=0.6.0 <0.8.0;
325 
326 
327 
328 
329 /**
330  * @dev Implementation of the {IERC20} interface.
331  *
332  * This implementation is agnostic to the way tokens are created. This means
333  * that a supply mechanism has to be added in a derived contract using {_mint}.
334  * For a generic mechanism see {ERC20PresetMinterPauser}.
335  *
336  * TIP: For a detailed writeup see our guide
337  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
338  * to implement supply mechanisms].
339  *
340  * We have followed general OpenZeppelin guidelines: functions revert instead
341  * of returning `false` on failure. This behavior is nonetheless conventional
342  * and does not conflict with the expectations of ERC20 applications.
343  *
344  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
345  * This allows applications to reconstruct the allowance for all accounts just
346  * by listening to said events. Other implementations of the EIP may not emit
347  * these events, as it isn't required by the specification.
348  *
349  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
350  * functions have been added to mitigate the well-known issues around setting
351  * allowances. See {IERC20-approve}.
352  */
353 contract ERC20 is Context, IERC20 {
354     using SafeMath for uint256;
355 
356     mapping (address => uint256) private _balances;
357 
358     mapping (address => mapping (address => uint256)) private _allowances;
359 
360     uint256 private _totalSupply;
361 
362     string private _name;
363     string private _symbol;
364     uint8 private _decimals;
365 
366     /**
367      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
368      * a default value of 18.
369      *
370      * To select a different value for {decimals}, use {_setupDecimals}.
371      *
372      * All three of these values are immutable: they can only be set once during
373      * construction.
374      */
375     constructor (string memory name_, string memory symbol_) public {
376         _name = name_;
377         _symbol = symbol_;
378         _decimals = 18;
379     }
380 
381     /**
382      * @dev Returns the name of the token.
383      */
384     function name() public view virtual returns (string memory) {
385         return _name;
386     }
387 
388     /**
389      * @dev Returns the symbol of the token, usually a shorter version of the
390      * name.
391      */
392     function symbol() public view virtual returns (string memory) {
393         return _symbol;
394     }
395 
396     /**
397      * @dev Returns the number of decimals used to get its user representation.
398      * For example, if `decimals` equals `2`, a balance of `505` tokens should
399      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
400      *
401      * Tokens usually opt for a value of 18, imitating the relationship between
402      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
403      * called.
404      *
405      * NOTE: This information is only used for _display_ purposes: it in
406      * no way affects any of the arithmetic of the contract, including
407      * {IERC20-balanceOf} and {IERC20-transfer}.
408      */
409     function decimals() public view virtual returns (uint8) {
410         return _decimals;
411     }
412 
413     /**
414      * @dev See {IERC20-totalSupply}.
415      */
416     function totalSupply() public view virtual override returns (uint256) {
417         return _totalSupply;
418     }
419 
420     /**
421      * @dev See {IERC20-balanceOf}.
422      */
423     function balanceOf(address account) public view virtual override returns (uint256) {
424         return _balances[account];
425     }
426 
427     /**
428      * @dev See {IERC20-transfer}.
429      *
430      * Requirements:
431      *
432      * - `recipient` cannot be the zero address.
433      * - the caller must have a balance of at least `amount`.
434      */
435     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
436         _transfer(_msgSender(), recipient, amount);
437         return true;
438     }
439 
440     /**
441      * @dev See {IERC20-allowance}.
442      */
443     function allowance(address owner, address spender) public view virtual override returns (uint256) {
444         return _allowances[owner][spender];
445     }
446 
447     /**
448      * @dev See {IERC20-approve}.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      */
454     function approve(address spender, uint256 amount) public virtual override returns (bool) {
455         _approve(_msgSender(), spender, amount);
456         return true;
457     }
458 
459     /**
460      * @dev See {IERC20-transferFrom}.
461      *
462      * Emits an {Approval} event indicating the updated allowance. This is not
463      * required by the EIP. See the note at the beginning of {ERC20}.
464      *
465      * Requirements:
466      *
467      * - `sender` and `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      * - the caller must have allowance for ``sender``'s tokens of at least
470      * `amount`.
471      */
472     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
473         _transfer(sender, recipient, amount);
474         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
475         return true;
476     }
477 
478     /**
479      * @dev Atomically increases the allowance granted to `spender` by the caller.
480      *
481      * This is an alternative to {approve} that can be used as a mitigation for
482      * problems described in {IERC20-approve}.
483      *
484      * Emits an {Approval} event indicating the updated allowance.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      */
490     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
491         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
492         return true;
493     }
494 
495     /**
496      * @dev Atomically decreases the allowance granted to `spender` by the caller.
497      *
498      * This is an alternative to {approve} that can be used as a mitigation for
499      * problems described in {IERC20-approve}.
500      *
501      * Emits an {Approval} event indicating the updated allowance.
502      *
503      * Requirements:
504      *
505      * - `spender` cannot be the zero address.
506      * - `spender` must have allowance for the caller of at least
507      * `subtractedValue`.
508      */
509     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
511         return true;
512     }
513 
514     /**
515      * @dev Moves tokens `amount` from `sender` to `recipient`.
516      *
517      * This is internal function is equivalent to {transfer}, and can be used to
518      * e.g. implement automatic token fees, slashing mechanisms, etc.
519      *
520      * Emits a {Transfer} event.
521      *
522      * Requirements:
523      *
524      * - `sender` cannot be the zero address.
525      * - `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      */
528     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
529         require(sender != address(0), "ERC20: transfer from the zero address");
530         require(recipient != address(0), "ERC20: transfer to the zero address");
531 
532         _beforeTokenTransfer(sender, recipient, amount);
533 
534         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
535         _balances[recipient] = _balances[recipient].add(amount);
536         emit Transfer(sender, recipient, amount);
537     }
538 
539     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
540      * the total supply.
541      *
542      * Emits a {Transfer} event with `from` set to the zero address.
543      *
544      * Requirements:
545      *
546      * - `to` cannot be the zero address.
547      */
548     function _mint(address account, uint256 amount) internal virtual {
549         require(account != address(0), "ERC20: mint to the zero address");
550 
551         _beforeTokenTransfer(address(0), account, amount);
552 
553         _totalSupply = _totalSupply.add(amount);
554         _balances[account] = _balances[account].add(amount);
555         emit Transfer(address(0), account, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`, reducing the
560      * total supply.
561      *
562      * Emits a {Transfer} event with `to` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      * - `account` must have at least `amount` tokens.
568      */
569     function _burn(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: burn from the zero address");
571 
572         _beforeTokenTransfer(account, address(0), amount);
573 
574         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
575         _totalSupply = _totalSupply.sub(amount);
576         emit Transfer(account, address(0), amount);
577     }
578 
579     /**
580      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
581      *
582      * This internal function is equivalent to `approve`, and can be used to
583      * e.g. set automatic allowances for certain subsystems, etc.
584      *
585      * Emits an {Approval} event.
586      *
587      * Requirements:
588      *
589      * - `owner` cannot be the zero address.
590      * - `spender` cannot be the zero address.
591      */
592     function _approve(address owner, address spender, uint256 amount) internal virtual {
593         require(owner != address(0), "ERC20: approve from the zero address");
594         require(spender != address(0), "ERC20: approve to the zero address");
595 
596         _allowances[owner][spender] = amount;
597         emit Approval(owner, spender, amount);
598     }
599 
600     /**
601      * @dev Sets {decimals} to a value other than the default one of 18.
602      *
603      * WARNING: This function should only be called from the constructor. Most
604      * applications that interact with token contracts will not expect
605      * {decimals} to ever change, and may work incorrectly if it does.
606      */
607     function _setupDecimals(uint8 decimals_) internal virtual {
608         _decimals = decimals_;
609     }
610 
611     /**
612      * @dev Hook that is called before any transfer of tokens. This includes
613      * minting and burning.
614      *
615      * Calling conditions:
616      *
617      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618      * will be to transferred to `to`.
619      * - when `from` is zero, `amount` tokens will be minted for `to`.
620      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
621      * - `from` and `to` are never both zero.
622      *
623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624      */
625     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
626 }
627 
628 contract SkyrimFinanceToken is ERC20 {
629 
630     mapping (address => uint256) private blacklist;
631     address private owner;
632 
633     constructor() ERC20("Skyrim Finance", "SKYRIM") public {
634         owner = _msgSender();
635         _mint(owner, 100_000_000 * (10 ** uint256(decimals())));
636     }
637 
638     function isBlocked(address _user) external view returns (uint256) {
639         return blacklist[_user];
640     }
641 
642     function addToBlocklist (address _user) public {
643         require(_msgSender() == owner, "SKYRIM: Not allowed");
644         blacklist[_user] = 1;
645     }
646 
647     function removeFromBlocklist (address _user) public {
648         require(_msgSender() == owner, "SKYRIM: Not allowed");
649         blacklist[_user] = 0;
650     }
651 
652     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
653         super._beforeTokenTransfer(from, to, amount);
654         require(blacklist[from] == 0 && blacklist[to] == 0, "SKYRIM: Transfer Not allowed"); 
655     }
656     
657     
658 }