1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity >=0.6.0 <0.8.0;
80 
81 /*
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with GSN meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address payable) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes memory) {
97         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
98         return msg.data;
99     }
100 }
101 
102 
103 pragma solidity >=0.6.0 <0.8.0;
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         uint256 c = a + b;
126         if (c < a) return (false, 0);
127         return (true, c);
128     }
129 
130     /**
131      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         if (b > a) return (false, 0);
137         return (true, a - b);
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) return (true, 0);
150         uint256 c = a * b;
151         if (c / a != b) return (false, 0);
152         return (true, c);
153     }
154 
155     /**
156      * @dev Returns the division of two unsigned integers, with a division by zero flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         if (b == 0) return (false, 0);
162         return (true, a / b);
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         if (b == 0) return (false, 0);
172         return (true, a % b);
173     }
174 
175     /**
176      * @dev Returns the addition of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `+` operator.
180      *
181      * Requirements:
182      *
183      * - Addition cannot overflow.
184      */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         require(c >= a, "SafeMath: addition overflow");
188         return c;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         require(b <= a, "SafeMath: subtraction overflow");
203         return a - b;
204     }
205 
206     /**
207      * @dev Returns the multiplication of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `*` operator.
211      *
212      * Requirements:
213      *
214      * - Multiplication cannot overflow.
215      */
216     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217         if (a == 0) return 0;
218         uint256 c = a * b;
219         require(c / a == b, "SafeMath: multiplication overflow");
220         return c;
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers, reverting on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b > 0, "SafeMath: division by zero");
237         return a / b;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * reverting when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         require(b > 0, "SafeMath: modulo by zero");
254         return a % b;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
259      * overflow (when the result is negative).
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {trySub}.
263      *
264      * Counterpart to Solidity's `-` operator.
265      *
266      * Requirements:
267      *
268      * - Subtraction cannot overflow.
269      */
270     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         require(b <= a, errorMessage);
272         return a - b;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
277      * division by zero. The result is rounded towards zero.
278      *
279      * CAUTION: This function is deprecated because it requires allocating memory for the error
280      * message unnecessarily. For custom revert reasons use {tryDiv}.
281      *
282      * Counterpart to Solidity's `/` operator. Note: this function uses a
283      * `revert` opcode (which leaves remaining gas untouched) while Solidity
284      * uses an invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         require(b > 0, errorMessage);
292         return a / b;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * reverting with custom message when dividing by zero.
298      *
299      * CAUTION: This function is deprecated because it requires allocating memory for the error
300      * message unnecessarily. For custom revert reasons use {tryMod}.
301      *
302      * Counterpart to Solidity's `%` operator. This function uses a `revert`
303      * opcode (which leaves remaining gas untouched) while Solidity uses an
304      * invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         require(b > 0, errorMessage);
312         return a % b;
313     }
314 }
315 
316 pragma solidity >=0.6.0 <0.8.0;
317 
318 
319 
320 
321 /**
322  * @dev Implementation of the {IERC20} interface.
323  *
324  * This implementation is agnostic to the way tokens are created. This means
325  * that a supply mechanism has to be added in a derived contract using {_mint}.
326  * For a generic mechanism see {ERC20PresetMinterPauser}.
327  *
328  * TIP: For a detailed writeup see our guide
329  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
330  * to implement supply mechanisms].
331  *
332  * We have followed general OpenZeppelin guidelines: functions revert instead
333  * of returning `false` on failure. This behavior is nonetheless conventional
334  * and does not conflict with the expectations of ERC20 applications.
335  *
336  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
337  * This allows applications to reconstruct the allowance for all accounts just
338  * by listening to said events. Other implementations of the EIP may not emit
339  * these events, as it isn't required by the specification.
340  *
341  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
342  * functions have been added to mitigate the well-known issues around setting
343  * allowances. See {IERC20-approve}.
344  */
345 contract ERC20 is Context, IERC20 {
346     using SafeMath for uint256;
347 
348     mapping (address => uint256) private _balances;
349 
350     mapping (address => mapping (address => uint256)) private _allowances;
351 
352     uint256 private _totalSupply;
353 
354     string private _name;
355     string private _symbol;
356     uint8 private _decimals;
357 
358     /**
359      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
360      * a default value of 18.
361      *
362      * To select a different value for {decimals}, use {_setupDecimals}.
363      *
364      * All three of these values are immutable: they can only be set once during
365      * construction.
366      */
367     constructor (string memory name_, string memory symbol_) public {
368         _name = name_;
369         _symbol = symbol_;
370         _decimals = 18;
371     }
372 
373     /**
374      * @dev Returns the name of the token.
375      */
376     function name() public view virtual returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @dev Returns the symbol of the token, usually a shorter version of the
382      * name.
383      */
384     function symbol() public view virtual returns (string memory) {
385         return _symbol;
386     }
387 
388     /**
389      * @dev Returns the number of decimals used to get its user representation.
390      * For example, if `decimals` equals `2`, a balance of `505` tokens should
391      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
392      *
393      * Tokens usually opt for a value of 18, imitating the relationship between
394      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
395      * called.
396      *
397      * NOTE: This information is only used for _display_ purposes: it in
398      * no way affects any of the arithmetic of the contract, including
399      * {IERC20-balanceOf} and {IERC20-transfer}.
400      */
401     function decimals() public view virtual returns (uint8) {
402         return _decimals;
403     }
404 
405     /**
406      * @dev See {IERC20-totalSupply}.
407      */
408     function totalSupply() public view virtual override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     /**
413      * @dev See {IERC20-balanceOf}.
414      */
415     function balanceOf(address account) public view virtual override returns (uint256) {
416         return _balances[account];
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-allowance}.
434      */
435     function allowance(address owner, address spender) public view virtual override returns (uint256) {
436         return _allowances[owner][spender];
437     }
438 
439     /**
440      * @dev See {IERC20-approve}.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         _approve(_msgSender(), spender, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-transferFrom}.
453      *
454      * Emits an {Approval} event indicating the updated allowance. This is not
455      * required by the EIP. See the note at the beginning of {ERC20}.
456      *
457      * Requirements:
458      *
459      * - `sender` and `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      * - the caller must have allowance for ``sender``'s tokens of at least
462      * `amount`.
463      */
464     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
465         _transfer(sender, recipient, amount);
466         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503         return true;
504     }
505 
506     /**
507      * @dev Moves tokens `amount` from `sender` to `recipient`.
508      *
509      * This is internal function is equivalent to {transfer}, and can be used to
510      * e.g. implement automatic token fees, slashing mechanisms, etc.
511      *
512      * Emits a {Transfer} event.
513      *
514      * Requirements:
515      *
516      * - `sender` cannot be the zero address.
517      * - `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      */
520     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
521         require(sender != address(0), "ERC20: transfer from the zero address");
522         require(recipient != address(0), "ERC20: transfer to the zero address");
523 
524         _beforeTokenTransfer(sender, recipient, amount);
525 
526         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
527         _balances[recipient] = _balances[recipient].add(amount);
528         emit Transfer(sender, recipient, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `to` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply = _totalSupply.add(amount);
546         _balances[account] = _balances[account].add(amount);
547         emit Transfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
567         _totalSupply = _totalSupply.sub(amount);
568         emit Transfer(account, address(0), amount);
569     }
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
573      *
574      * This internal function is equivalent to `approve`, and can be used to
575      * e.g. set automatic allowances for certain subsystems, etc.
576      *
577      * Emits an {Approval} event.
578      *
579      * Requirements:
580      *
581      * - `owner` cannot be the zero address.
582      * - `spender` cannot be the zero address.
583      */
584     function _approve(address owner, address spender, uint256 amount) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Sets {decimals} to a value other than the default one of 18.
594      *
595      * WARNING: This function should only be called from the constructor. Most
596      * applications that interact with token contracts will not expect
597      * {decimals} to ever change, and may work incorrectly if it does.
598      */
599     function _setupDecimals(uint8 decimals_) internal virtual {
600         _decimals = decimals_;
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be to transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
618 }
619 
620 contract KylinToken is ERC20 {
621 
622     mapping (address => uint256) private blacklist;
623     address private owner;
624 
625     constructor() ERC20("Kylin Network", "KYL") public {
626         owner = _msgSender();
627         _mint(owner, 1_000_000_000 * (10 ** uint256(decimals())));
628     }
629 
630     function isBlocked(address _user) external view returns (uint256) {
631         return blacklist[_user];
632     }
633 
634     function addToBlocklist (address _user) public {
635         require(_msgSender() == owner, "KYL: Not allowed");
636         blacklist[_user] = 1;
637     }
638 
639     function removeFromBlocklist (address _user) public {
640         require(_msgSender() == owner, "KYL: Not allowed");
641         blacklist[_user] = 0;
642     }
643 
644     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
645         require(blacklist[from] == 0 && blacklist[to] == 0, "KYL: Transfer Not allowed"); 
646     }
647 }