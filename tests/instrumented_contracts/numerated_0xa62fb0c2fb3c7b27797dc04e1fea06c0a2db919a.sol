1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/GSN/Context.sol
82 
83 
84 
85 pragma solidity >=0.6.0 <0.8.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
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
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
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
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
271 
272 
273 
274 pragma solidity >=0.6.0 <0.8.0;
275 
276 
277 
278 
279 /**
280  * @dev Implementation of the {IERC20} interface.
281  *
282  * This implementation is agnostic to the way tokens are created. This means
283  * that a supply mechanism has to be added in a derived contract using {_mint}.
284  * For a generic mechanism see {ERC20PresetMinterPauser}.
285  *
286  * TIP: For a detailed writeup see our guide
287  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
288  * to implement supply mechanisms].
289  *
290  * We have followed general OpenZeppelin guidelines: functions revert instead
291  * of returning `false` on failure. This behavior is nonetheless conventional
292  * and does not conflict with the expectations of ERC20 applications.
293  *
294  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
295  * This allows applications to reconstruct the allowance for all accounts just
296  * by listening to said events. Other implementations of the EIP may not emit
297  * these events, as it isn't required by the specification.
298  *
299  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
300  * functions have been added to mitigate the well-known issues around setting
301  * allowances. See {IERC20-approve}.
302  */
303 contract ERC20 is Context, IERC20 {
304     using SafeMath for uint256;
305 
306     mapping (address => uint256) private _balances;
307 
308     mapping (address => mapping (address => uint256)) private _allowances;
309 
310     uint256 private _totalSupply;
311 
312     string private _name;
313     string private _symbol;
314     uint8 private _decimals;
315 
316     /**
317      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
318      * a default value of 18.
319      *
320      * To select a different value for {decimals}, use {_setupDecimals}.
321      *
322      * All three of these values are immutable: they can only be set once during
323      * construction.
324      */
325     constructor (string memory name_, string memory symbol_) public {
326         _name = name_;
327         _symbol = symbol_;
328         _decimals = 18;
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
353      * called.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view virtual override returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20}.
414      *
415      * Requirements:
416      *
417      * - `sender` and `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      * - the caller must have allowance for ``sender``'s tokens of at least
420      * `amount`.
421      */
422     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
425         return true;
426     }
427 
428     /**
429      * @dev Atomically increases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
442         return true;
443     }
444 
445     /**
446      * @dev Atomically decreases the allowance granted to `spender` by the caller.
447      *
448      * This is an alternative to {approve} that can be used as a mitigation for
449      * problems described in {IERC20-approve}.
450      *
451      * Emits an {Approval} event indicating the updated allowance.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      * - `spender` must have allowance for the caller of at least
457      * `subtractedValue`.
458      */
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     /**
465      * @dev Moves tokens `amount` from `sender` to `recipient`.
466      *
467      * This is internal function is equivalent to {transfer}, and can be used to
468      * e.g. implement automatic token fees, slashing mechanisms, etc.
469      *
470      * Emits a {Transfer} event.
471      *
472      * Requirements:
473      *
474      * - `sender` cannot be the zero address.
475      * - `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      */
478     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `to` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _beforeTokenTransfer(address(0), account, amount);
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _beforeTokenTransfer(account, address(0), amount);
523 
524         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
525         _totalSupply = _totalSupply.sub(amount);
526         emit Transfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(address owner, address spender, uint256 amount) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Sets {decimals} to a value other than the default one of 18.
552      *
553      * WARNING: This function should only be called from the constructor. Most
554      * applications that interact with token contracts will not expect
555      * {decimals} to ever change, and may work incorrectly if it does.
556      */
557     function _setupDecimals(uint8 decimals_) internal {
558         _decimals = decimals_;
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be to transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
576 }
577 
578 // File: contracts/UnicGallery.sol
579 
580 pragma solidity 0.6.12;
581 
582 
583 
584 
585 // Copied from SushiBar: https://github.com/sushiswap/sushiswap/blob/master/contracts/SushiBar.sol
586 // Modified by 0xLeia
587 
588 // UnicGallery is the coolest gallery in town. You come in with some Unic, and leave with more! The longer you stay, the more Unic you get.
589 //
590 // This contract handles swapping to and from xUnic, UnicSwap's staking token.
591 contract UnicGallery is ERC20("UnicGallery", "xUNIC") {
592     using SafeMath for uint256;
593     IERC20 public unic;
594 
595     // Define the Unic token contract
596     constructor(IERC20 _unic) public {
597         unic = _unic;
598     }
599 
600     // Enter the gallery. Pay some UNICs. Earn some shares.
601     // Locks Unic and mints xUnic
602     function enter(uint256 _amount) public {
603         // Gets the amount of Unic locked in the contract
604         uint256 totalUnic = unic.balanceOf(address(this));
605         // Gets the amount of xUnic in existence
606         uint256 totalShares = totalSupply();
607         // If no xUnic exists, mint it 1:1 to the amount put in
608         if (totalShares == 0 || totalUnic == 0) {
609             _mint(msg.sender, _amount);
610         } 
611         // Calculate and mint the amount of xUnic the Unic is worth. The ratio will change overtime, as xUnic is burned/minted and Unic deposited + gained from fees / withdrawn.
612         else {
613             uint256 what = _amount.mul(totalShares).div(totalUnic);
614             _mint(msg.sender, what);
615         }
616         // Lock the Unic in the contract
617         unic.transferFrom(msg.sender, address(this), _amount);
618     }
619 
620     // Leave the gallery. Claim back your UNICs.
621     // Unclocks the staked + gained Unic and burns xUnic
622     function leave(uint256 _share) public {
623         // Gets the amount of xUnic in existence
624         uint256 totalShares = totalSupply();
625         // Calculates the amount of Unic the xUnic is worth
626         uint256 what = _share.mul(unic.balanceOf(address(this))).div(totalShares);
627         _burn(msg.sender, _share);
628         unic.transfer(msg.sender, what);
629     }
630 }