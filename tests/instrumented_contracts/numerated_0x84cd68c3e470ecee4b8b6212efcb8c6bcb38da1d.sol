1 pragma solidity ^0.7.6;
2 
3 
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
79 /**
80  * @dev Interface for the optional metadata functions from the ERC20 standard.
81  */
82 interface IERC20Metadata is IERC20 {
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() external view returns (string memory);
87 
88     /**
89      * @dev Returns the symbol of the token.
90      */
91     function symbol() external view returns (string memory);
92 
93     /**
94      * @dev Returns the decimals places of the token.
95      */
96     function decimals() external view returns (uint8);
97 }
98 
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 /**
121  * @dev Implementation of the {IERC20} interface.
122  *
123  * This implementation is agnostic to the way tokens are created. This means
124  * that a supply mechanism has to be added in a derived contract using {_mint}.
125  * For a generic mechanism see {ERC20PresetMinterPauser}.
126  *
127  * TIP: For a detailed writeup see our guide
128  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
129  * to implement supply mechanisms].
130  *
131  * We have followed general OpenZeppelin guidelines: functions revert instead
132  * of returning `false` on failure. This behavior is nonetheless conventional
133  * and does not conflict with the expectations of ERC20 applications.
134  *
135  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
136  * This allows applications to reconstruct the allowance for all accounts just
137  * by listening to said events. Other implementations of the EIP may not emit
138  * these events, as it isn't required by the specification.
139  *
140  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
141  * functions have been added to mitigate the well-known issues around setting
142  * allowances. See {IERC20-approve}.
143  */
144 contract ERC20 is Context, IERC20, IERC20Metadata {
145     mapping (address => uint256) private _balances;
146 
147     mapping (address => mapping (address => uint256)) private _allowances;
148 
149     uint256 private _totalSupply;
150 
151     string private _name;
152     string private _symbol;
153 
154     /**
155      * @dev Sets the values for {name} and {symbol}.
156      *
157      * The defaut value of {decimals} is 18. To select a different value for
158      * {decimals} you should overload it.
159      *
160      * All two of these values are immutable: they can only be set once during
161      * construction.
162      */
163     constructor (string memory name_, string memory symbol_) {
164         _name = name_;
165         _symbol = symbol_;
166     }
167 
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() public view virtual override returns (string memory) {
172         return _name;
173     }
174 
175     /**
176      * @dev Returns the symbol of the token, usually a shorter version of the
177      * name.
178      */
179     function symbol() public view virtual override returns (string memory) {
180         return _symbol;
181     }
182 
183     /**
184      * @dev Returns the number of decimals used to get its user representation.
185      * For example, if `decimals` equals `2`, a balance of `505` tokens should
186      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
187      *
188      * Tokens usually opt for a value of 18, imitating the relationship between
189      * Ether and Wei. This is the value {ERC20} uses, unless this function is
190      * overridden;
191      *
192      * NOTE: This information is only used for _display_ purposes: it in
193      * no way affects any of the arithmetic of the contract, including
194      * {IERC20-balanceOf} and {IERC20-transfer}.
195      */
196     function decimals() public view virtual override returns (uint8) {
197         return 18;
198     }
199 
200     /**
201      * @dev See {IERC20-totalSupply}.
202      */
203     function totalSupply() public view virtual override returns (uint256) {
204         return _totalSupply;
205     }
206 
207     /**
208      * @dev See {IERC20-balanceOf}.
209      */
210     function balanceOf(address account) public view virtual override returns (uint256) {
211         return _balances[account];
212     }
213 
214     /**
215      * @dev See {IERC20-transfer}.
216      *
217      * Requirements:
218      *
219      * - `recipient` cannot be the zero address.
220      * - the caller must have a balance of at least `amount`.
221      */
222     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     /**
228      * @dev See {IERC20-allowance}.
229      */
230     function allowance(address owner, address spender) public view virtual override returns (uint256) {
231         return _allowances[owner][spender];
232     }
233 
234     /**
235      * @dev See {IERC20-approve}.
236      *
237      * Requirements:
238      *
239      * - `spender` cannot be the zero address.
240      */
241     function approve(address spender, uint256 amount) public virtual override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     /**
247      * @dev See {IERC20-transferFrom}.
248      *
249      * Emits an {Approval} event indicating the updated allowance. This is not
250      * required by the EIP. See the note at the beginning of {ERC20}.
251      *
252      * Requirements:
253      *
254      * - `sender` and `recipient` cannot be the zero address.
255      * - `sender` must have a balance of at least `amount`.
256      * - the caller must have allowance for ``sender``'s tokens of at least
257      * `amount`.
258      */
259     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
260         _transfer(sender, recipient, amount);
261 
262         uint256 currentAllowance = _allowances[sender][_msgSender()];
263         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
264         _approve(sender, _msgSender(), currentAllowance - amount);
265 
266         return true;
267     }
268 
269     /**
270      * @dev Atomically increases the allowance granted to `spender` by the caller.
271      *
272      * This is an alternative to {approve} that can be used as a mitigation for
273      * problems described in {IERC20-approve}.
274      *
275      * Emits an {Approval} event indicating the updated allowance.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
282         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
283         return true;
284     }
285 
286     /**
287      * @dev Atomically decreases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to {approve} that can be used as a mitigation for
290      * problems described in {IERC20-approve}.
291      *
292      * Emits an {Approval} event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      * - `spender` must have allowance for the caller of at least
298      * `subtractedValue`.
299      */
300     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
301         uint256 currentAllowance = _allowances[_msgSender()][spender];
302         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
303         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
304 
305         return true;
306     }
307 
308     /**
309      * @dev Moves tokens `amount` from `sender` to `recipient`.
310      *
311      * This is internal function is equivalent to {transfer}, and can be used to
312      * e.g. implement automatic token fees, slashing mechanisms, etc.
313      *
314      * Emits a {Transfer} event.
315      *
316      * Requirements:
317      *
318      * - `sender` cannot be the zero address.
319      * - `recipient` cannot be the zero address.
320      * - `sender` must have a balance of at least `amount`.
321      */
322     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
323         require(sender != address(0), "ERC20: transfer from the zero address");
324         require(recipient != address(0), "ERC20: transfer to the zero address");
325 
326         _beforeTokenTransfer(sender, recipient, amount);
327 
328         uint256 senderBalance = _balances[sender];
329         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
330         _balances[sender] = senderBalance - amount;
331         _balances[recipient] += amount;
332 
333         emit Transfer(sender, recipient, amount);
334     }
335 
336     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
337      * the total supply.
338      *
339      * Emits a {Transfer} event with `from` set to the zero address.
340      *
341      * Requirements:
342      *
343      * - `to` cannot be the zero address.
344      */
345     function _mint(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: mint to the zero address");
347 
348         _beforeTokenTransfer(address(0), account, amount);
349 
350         _totalSupply += amount;
351         _balances[account] += amount;
352         emit Transfer(address(0), account, amount);
353     }
354 
355     /**
356      * @dev Destroys `amount` tokens from `account`, reducing the
357      * total supply.
358      *
359      * Emits a {Transfer} event with `to` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `account` cannot be the zero address.
364      * - `account` must have at least `amount` tokens.
365      */
366     function _burn(address account, uint256 amount) internal virtual {
367         require(account != address(0), "ERC20: burn from the zero address");
368 
369         _beforeTokenTransfer(account, address(0), amount);
370 
371         uint256 accountBalance = _balances[account];
372         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
373         _balances[account] = accountBalance - amount;
374         _totalSupply -= amount;
375 
376         emit Transfer(account, address(0), amount);
377     }
378 
379     /**
380      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
381      *
382      * This internal function is equivalent to `approve`, and can be used to
383      * e.g. set automatic allowances for certain subsystems, etc.
384      *
385      * Emits an {Approval} event.
386      *
387      * Requirements:
388      *
389      * - `owner` cannot be the zero address.
390      * - `spender` cannot be the zero address.
391      */
392     function _approve(address owner, address spender, uint256 amount) internal virtual {
393         require(owner != address(0), "ERC20: approve from the zero address");
394         require(spender != address(0), "ERC20: approve to the zero address");
395 
396         _allowances[owner][spender] = amount;
397         emit Approval(owner, spender, amount);
398     }
399 
400     /**
401      * @dev Hook that is called before any transfer of tokens. This includes
402      * minting and burning.
403      *
404      * Calling conditions:
405      *
406      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
407      * will be to transferred to `to`.
408      * - when `from` is zero, `amount` tokens will be minted for `to`.
409      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
410      * - `from` and `to` are never both zero.
411      *
412      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
413      */
414     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
415 }
416 
417 abstract contract Ownable is Context {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () {
426         address msgSender = _msgSender();
427         _owner = msgSender;
428         emit OwnershipTransferred(address(0), msgSender);
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view virtual returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         require(owner() == _msgSender(), "Ownable: caller is not the owner");
443         _;
444     }
445 
446     /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         emit OwnershipTransferred(_owner, address(0));
455         _owner = address(0);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      * Can only be called by the current owner.
461      */
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 }
468 
469 
470 library SafeMath {
471     /**
472      * @dev Returns the addition of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `+` operator.
476      *
477      * Requirements:
478      *
479      * - Addition cannot overflow.
480      */
481     function add(uint256 a, uint256 b) internal pure returns (uint256) {
482         uint256 c = a + b;
483         require(c >= a, "SafeMath: addition overflow");
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499         return sub(a, b, "SafeMath: subtraction overflow");
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         uint256 c = a - b;
515 
516         return c;
517     }
518 
519     /**
520      * @dev Returns the multiplication of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `*` operator.
524      *
525      * Requirements:
526      *
527      * - Multiplication cannot overflow.
528      */
529     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
530         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
531         // benefit is lost if 'b' is also tested.
532         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
533         if (a == 0) {
534             return 0;
535         }
536 
537         uint256 c = a * b;
538         require(c / a == b, "SafeMath: multiplication overflow");
539 
540         return c;
541     }
542 
543     /**
544      * @dev Returns the integer division of two unsigned integers. Reverts on
545      * division by zero. The result is rounded towards zero.
546      *
547      * Counterpart to Solidity's `/` operator. Note: this function uses a
548      * `revert` opcode (which leaves remaining gas untouched) while Solidity
549      * uses an invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b > 0, errorMessage);
573         uint256 c = a / b;
574         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
575 
576         return c;
577     }
578 
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * Reverts when dividing by zero.
582      *
583      * Counterpart to Solidity's `%` operator. This function uses a `revert`
584      * opcode (which leaves remaining gas untouched) while Solidity uses an
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
592         return mod(a, b, "SafeMath: modulo by zero");
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * Reverts with custom message when dividing by zero.
598      *
599      * Counterpart to Solidity's `%` operator. This function uses a `revert`
600      * opcode (which leaves remaining gas untouched) while Solidity uses an
601      * invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b != 0, errorMessage);
609         return a % b;
610     }
611 }
612 
613 contract ChainbindersToken is ERC20("DokiDoki.Chainbinders", "BND"), Ownable {
614     using SafeMath for uint256;
615 
616     mapping(address => bool) public minters;
617 
618     bool public lock;
619 
620     event Unlock(bool lock);
621     event AddMinter(address minter);
622     event RemoveMinter(address minter);
623 
624     constructor() {
625         lock = true;
626     }
627 
628     function mint(address to, uint amount) external onlyMinter {
629         _mint(to, amount);
630     }
631 
632     function burn(uint256 amount) external {
633         _burn(_msgSender(), amount);
634     }
635 
636     function burnFrom(address account, uint256 amount) external {
637         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
638 
639         _approve(account, _msgSender(), decreasedAllowance);
640         _burn(account, amount);
641     }
642 
643     function transfer(address recipient, uint256 amount) public override returns (bool) {
644         require(msg.sender == owner() || !lock, "BND: transfer locked");
645         return super.transfer(recipient, amount);
646     }
647 
648     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
649         require(sender == owner() || !lock, "BND: transfer locked");
650         return super.transferFrom(sender, recipient, amount);
651     }
652 
653     function unlock() external onlyOwner {
654         require(lock, "Transfer has been unlocked");
655         lock = false;
656 
657         emit Unlock(lock);
658     }
659 
660     function addMinter(address account) external onlyOwner {
661         require(account != address(0), "New minter is zero address");
662         minters[account] = true;
663 
664         emit AddMinter(account);
665     }
666 
667     function removeMinter(address account) external onlyOwner {
668         minters[account] = false;
669 
670         emit RemoveMinter(account);
671     }
672 
673     modifier onlyMinter() {
674         require(minters[msg.sender], "Operation is only for minters.");
675         _;
676     }
677 }