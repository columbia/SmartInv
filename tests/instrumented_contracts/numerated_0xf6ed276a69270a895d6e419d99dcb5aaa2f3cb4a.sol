1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Wrappers over Solidity's arithmetic operations with added overflow
29  * checks.
30  *
31  * Arithmetic operations in Solidity wrap on overflow. This can easily result
32  * in bugs, because programmers usually assume that an overflow raises an
33  * error, which is the standard behavior in high level programming languages.
34  * `SafeMath` restores this intuition by reverting the transaction when an
35  * operation overflows.
36  *
37  * Using this library instead of the unchecked operations eliminates an entire
38  * class of bugs, so it's recommended to use it always.
39  */
40 library SafeMath {
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `+` operator.
46      *
47      * Requirements:
48      *
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      *
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the multiplication of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `*` operator.
94      *
95      * Requirements:
96      *
97      * - Multiplication cannot overflow.
98      */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b > 0, errorMessage);
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts when dividing by zero.
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
162         return mod(a, b, "SafeMath: modulo by zero");
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts with custom message when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b != 0, errorMessage);
179         return a % b;
180     }
181 }
182 
183 /**
184  * @dev Contract module which provides a basic access control mechanism, where
185  * there is an account (an owner) that can be granted exclusive access to
186  * specific functions.
187  *
188  * By default, the owner account will be the one that deploys the contract. This
189  * can later be changed with {transferOwnership}.
190  *
191  * This module is used through inheritance. It will make available the modifier
192  * `onlyOwner`, which can be applied to your functions to restrict their use to
193  * the owner.
194  */
195 contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     /**
201      * @dev Initializes the contract setting the deployer as the initial owner.
202      */
203     constructor () internal {
204         address msgSender = _msgSender();
205         _owner = msgSender;
206         emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(_owner == _msgSender(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     /**
225      * @dev Leaves the contract without owner. It will not be possible to call
226      * `onlyOwner` functions anymore. Can only be called by the current owner.
227      *
228      * NOTE: Renouncing ownership will leave the contract without an owner,
229      * thereby removing any functionality that is only available to the owner.
230      */
231     function renounceOwnership() public virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Can only be called by the current owner.
239      */
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(newOwner != address(0), "Ownable: new owner is the zero address");
242         emit OwnershipTransferred(_owner, newOwner);
243         _owner = newOwner;
244     }
245 }
246 
247 
248 interface IERC20 {
249     /**
250      * @dev Returns the amount of tokens in existence.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns the amount of tokens owned by `account`.
256      */
257     function balanceOf(address account) external view returns (uint256);
258 
259     /**
260      * @dev Moves `amount` tokens from the caller's account to `recipient`.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transfer(address recipient, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Returns the remaining number of tokens that `spender` will be
270      * allowed to spend on behalf of `owner` through {transferFrom}. This is
271      * zero by default.
272      *
273      * This value changes when {approve} or {transferFrom} are called.
274      */
275     function allowance(address owner, address spender) external view returns (uint256);
276 
277     /**
278      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * IMPORTANT: Beware that changing an allowance with this method brings the risk
283      * that someone may use both the old and the new allowance by unfortunate
284      * transaction ordering. One possible solution to mitigate this race
285      * condition is to first reduce the spender's allowance to 0 and set the
286      * desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address spender, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Moves `amount` tokens from `sender` to `recipient` using the
295      * allowance mechanism. `amount` is then deducted from the caller's
296      * allowance.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 
319 
320 /**
321  * @dev Implementation of the {IERC20} interface.
322  *
323  * This implementation is agnostic to the way tokens are created. This means
324  * that a supply mechanism has to be added in a derived contract using {_mint}.
325  * For a generic mechanism see {ERC20PresetMinterPauser}.
326  *
327  * TIP: For a detailed writeup see our guide
328  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
329  * to implement supply mechanisms].
330  *
331  * We have followed general OpenZeppelin guidelines: functions revert instead
332  * of returning `false` on failure. This behavior is nonetheless conventional
333  * and does not conflict with the expectations of ERC20 applications.
334  *
335  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
336  * This allows applications to reconstruct the allowance for all accounts just
337  * by listening to said events. Other implementations of the EIP may not emit
338  * these events, as it isn't required by the specification.
339  *
340  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
341  * functions have been added to mitigate the well-known issues around setting
342  * allowances. See {IERC20-approve}.
343  */
344 contract ERC20 is Context, IERC20 {
345     using SafeMath for uint256;
346 
347     mapping (address => uint256) private _balances;
348 
349     mapping (address => mapping (address => uint256)) private _allowances;
350 
351     uint256 private _totalSupply;
352 
353     string private _name;
354     string private _symbol;
355     uint8 private _decimals;
356 
357     /**
358      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
359      * a default value of 18.
360      *
361      * To select a different value for {decimals}, use {_setupDecimals}.
362      *
363      * All three of these values are immutable: they can only be set once during
364      * construction.
365      */
366     constructor (string memory name, string memory symbol) public {
367         _name = name;
368         _symbol = symbol;
369         _decimals = 18;
370     }
371 
372     /**
373      * @dev Returns the name of the token.
374      */
375     function name() public view returns (string memory) {
376         return _name;
377     }
378 
379     /**
380      * @dev Returns the symbol of the token, usually a shorter version of the
381      * name.
382      */
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     /**
388      * @dev Returns the number of decimals used to get its user representation.
389      * For example, if `decimals` equals `2`, a balance of `505` tokens should
390      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
391      *
392      * Tokens usually opt for a value of 18, imitating the relationship between
393      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
394      * called.
395      *
396      * NOTE: This information is only used for _display_ purposes: it in
397      * no way affects any of the arithmetic of the contract, including
398      * {IERC20-balanceOf} and {IERC20-transfer}.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 
404     /**
405      * @dev See {IERC20-totalSupply}.
406      */
407     function totalSupply() public view override returns (uint256) {
408         return _totalSupply;
409     }
410 
411     /**
412      * @dev See {IERC20-balanceOf}.
413      */
414     function balanceOf(address account) public view override returns (uint256) {
415         return _balances[account];
416     }
417 
418     /**
419      * @dev See {IERC20-transfer}.
420      *
421      * Requirements:
422      *
423      * - `recipient` cannot be the zero address.
424      * - the caller must have a balance of at least `amount`.
425      */
426     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
427         _transfer(_msgSender(), recipient, amount);
428         return true;
429     }
430 
431     /**
432      * @dev See {IERC20-allowance}.
433      */
434     function allowance(address owner, address spender) public view virtual override returns (uint256) {
435         return _allowances[owner][spender];
436     }
437 
438     /**
439      * @dev See {IERC20-approve}.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function approve(address spender, uint256 amount) public virtual override returns (bool) {
446         _approve(_msgSender(), spender, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-transferFrom}.
452      *
453      * Emits an {Approval} event indicating the updated allowance. This is not
454      * required by the EIP. See the note at the beginning of {ERC20}.
455      *
456      * Requirements:
457      *
458      * - `sender` and `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      * - the caller must have allowance for ``sender``'s tokens of at least
461      * `amount`.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
466         return true;
467     }
468 
469     /**
470      * @dev Atomically increases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically decreases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      * - `spender` must have allowance for the caller of at least
498      * `subtractedValue`.
499      */
500     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
502         return true;
503     }
504 
505     /**
506      * @dev Moves tokens `amount` from `sender` to `recipient`.
507      *
508      * This is internal function is equivalent to {transfer}, and can be used to
509      * e.g. implement automatic token fees, slashing mechanisms, etc.
510      *
511      * Emits a {Transfer} event.
512      *
513      * Requirements:
514      *
515      * - `sender` cannot be the zero address.
516      * - `recipient` cannot be the zero address.
517      * - `sender` must have a balance of at least `amount`.
518      */
519     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
520         require(sender != address(0), "ERC20: transfer from the zero address");
521         require(recipient != address(0), "ERC20: transfer to the zero address");
522 
523         _beforeTokenTransfer(sender, recipient, amount);
524 
525         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
526         _balances[recipient] = _balances[recipient].add(amount);
527         emit Transfer(sender, recipient, amount);
528     }
529 
530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
531      * the total supply.
532      *
533      * Emits a {Transfer} event with `from` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `to` cannot be the zero address.
538      */
539     function _mint(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: mint to the zero address");
541 
542         _beforeTokenTransfer(address(0), account, amount);
543 
544         _totalSupply = _totalSupply.add(amount);
545         _balances[account] = _balances[account].add(amount);
546         emit Transfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
572      *
573      * This internal function is equivalent to `approve`, and can be used to
574      * e.g. set automatic allowances for certain subsystems, etc.
575      *
576      * Emits an {Approval} event.
577      *
578      * Requirements:
579      *
580      * - `owner` cannot be the zero address.
581      * - `spender` cannot be the zero address.
582      */
583     function _approve(address owner, address spender, uint256 amount) internal virtual {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     /**
592      * @dev Sets {decimals} to a value other than the default one of 18.
593      *
594      * WARNING: This function should only be called from the constructor. Most
595      * applications that interact with token contracts will not expect
596      * {decimals} to ever change, and may work incorrectly if it does.
597      */
598     function _setupDecimals(uint8 decimals_) internal {
599         _decimals = decimals_;
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be to transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
617 }
618 
619 
620 /**
621  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
622  */
623 abstract contract ERC20Capped is ERC20 {
624     uint256 private _cap;
625 
626     /**
627      * @dev Sets the value of the `cap`. This value is immutable, it can only be
628      * set once during construction.
629      */
630     constructor (uint256 cap) public {
631         require(cap > 0, "ERC20Capped: cap is 0");
632         _cap = cap;
633     }
634 
635     /**
636      * @dev Returns the cap on the token's total supply.
637      */
638     function cap() public view returns (uint256) {
639         return _cap;
640     }
641 
642     /**
643      * @dev See {ERC20-_beforeTokenTransfer}.
644      *
645      * Requirements:
646      *
647      * - minted tokens must not cause the total supply to go over the cap.
648      */
649     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
650         super._beforeTokenTransfer(from, to, amount);
651 
652         if (from == address(0)) { // When minting tokens
653             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
654         }
655     }
656 }
657 
658 
659 contract ERC20SAP is Ownable, ERC20Capped {
660     constructor (string memory name, string memory symbol, uint256 cap)
661         public ERC20(name, symbol) ERC20Capped(cap)
662     { }
663 
664     function mint(address to, uint256 amount) public onlyOwner {
665         _mint(to, amount);
666     }
667 }