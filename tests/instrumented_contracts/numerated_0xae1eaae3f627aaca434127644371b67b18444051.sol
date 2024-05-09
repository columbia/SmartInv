1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity =0.7.4;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 pragma solidity =0.7.4;
163 
164 /*
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with GSN meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 abstract contract Context {
175     function _msgSender() internal view virtual returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view virtual returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 pragma solidity =0.7.4;
186 
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP.
189  */
190 interface IERC20 {
191     /**
192      * @dev Returns the amount of tokens in existence.
193      */
194     function totalSupply() external view returns (uint256);
195 
196     /**
197      * @dev Returns the amount of tokens owned by `account`.
198      */
199     function balanceOf(address account) external view returns (uint256);
200 
201     /**
202      * @dev Moves `amount` tokens from the caller's account to `recipient`.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transfer(address recipient, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(address owner, address spender) external view returns (uint256);
218 
219     /**
220      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * IMPORTANT: Beware that changing an allowance with this method brings the risk
225      * that someone may use both the old and the new allowance by unfortunate
226      * transaction ordering. One possible solution to mitigate this race
227      * condition is to first reduce the spender's allowance to 0 and set the
228      * desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address spender, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Moves `amount` tokens from `sender` to `recipient` using the
237      * allowance mechanism. `amount` is then deducted from the caller's
238      * allowance.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Emitted when `value` tokens are moved from one account (`from`) to
248      * another (`to`).
249      *
250      * Note that `value` may be zero.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 value);
253 
254     /**
255      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
256      * a call to {approve}. `value` is the new allowance.
257      */
258     event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 pragma solidity =0.7.4;
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor () {
284         address msgSender = _msgSender();
285         _owner = msgSender;
286         emit OwnershipTransferred(address(0), msgSender);
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(_owner == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321         require(newOwner != address(0), "Ownable: new owner is the zero address");
322         emit OwnershipTransferred(_owner, newOwner);
323         _owner = newOwner;
324     }
325 }
326 
327 pragma solidity =0.7.4;
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
353 contract YOP is Context, IERC20, Ownable {
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
366     uint256 constant maxCap = 88888888  * (10 ** 8);// nice cap isnt it? :)
367     
368     uint256 public tokenSale = maxCap * 27 / 100;  // 12% for private and public ICO
369     uint256 public MarketingDevRewards = maxCap * 53 / 100;  // 52% for marketing and Dev rewards
370     uint256 public team = maxCap * 10 / 100;  // 10% for 2 years linear release V0 onwards
371     uint256 public reserve = maxCap * 10 / 100;  // 10% for balance burnt post V2 
372 
373 
374 
375     /**
376      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
377      * a default value of 8.
378      *
379      * To select a different value for {decimals}, use {_setupDecimals}.
380      *
381      * All three of these values are immutable: they can only be set once during
382      * construction.
383      */
384     constructor ()  {
385         _name = "YOP";
386         _symbol = "YOP";
387         _setupDecimals(8);
388     }
389     
390     function unlock_tokenSale(address toAddress) public onlyOwner
391     {
392         _mint(toAddress, tokenSale);
393         tokenSale = 0;
394     }
395     
396     function unlock_MarketingDevRewards(address toAddress) public onlyOwner
397     {
398         _mint(toAddress, MarketingDevRewards);
399         MarketingDevRewards = 0;
400     }
401     
402    
403     
404     function unlock_team(address toAddress) public onlyOwner
405     {
406         _mint(toAddress, team);
407         team = 0;
408     }
409     
410     
411     function unlock_reserve(address toAddress) public onlyOwner
412     {
413         _mint(toAddress, reserve);
414         reserve = 0;
415     }
416 
417     /**
418      * @dev Returns the name of the token.
419      */
420     function name() public view returns (string memory) {
421         return _name;
422     }
423 
424     /**
425      * @dev Returns the symbol of the token, usually a shorter version of the
426      * name.
427      */
428     function symbol() public view returns (string memory) {
429         return _symbol;
430     }
431 
432     /**
433      * @dev Returns the number of decimals used to get its user representation.
434      * For example, if `decimals` equals `2`, a balance of `505` tokens should
435      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
436      *
437      * Tokens usually opt for a value of 18, imitating the relationship between
438      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
439      * called.
440      *
441      * NOTE: This information is only used for _display_ purposes: it in
442      * no way affects any of the arithmetic of the contract, including
443      * {IERC20-balanceOf} and {IERC20-transfer}.
444      */
445     function decimals() public view returns (uint8) {
446         return _decimals;
447     }
448 
449     /**
450      * @dev See {IERC20-totalSupply}.
451      */
452     function totalSupply() public view override returns (uint256) {
453         return _totalSupply;
454     }
455 
456     /**
457      * @dev See {IERC20-balanceOf}.
458      */
459     function balanceOf(address account) public view override returns (uint256) {
460         return _balances[account];
461     }
462 
463     /**
464      * @dev See {IERC20-transfer}.
465      *
466      * Requirements:
467      *
468      * - `recipient` cannot be the zero address.
469      * - the caller must have a balance of at least `amount`.
470      */
471     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
472         _transfer(_msgSender(), recipient, amount);
473         return true;
474     }
475 
476     /**
477      * @dev See {IERC20-allowance}.
478      */
479     function allowance(address owner, address spender) public view virtual override returns (uint256) {
480         return _allowances[owner][spender];
481     }
482 
483     /**
484      * @dev See {IERC20-approve}.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      */
490     function approve(address spender, uint256 amount) public virtual override returns (bool) {
491         _approve(_msgSender(), spender, amount);
492         return true;
493     }
494 
495     /**
496      * @dev See {IERC20-transferFrom}.
497      *
498      * Emits an {Approval} event indicating the updated allowance. This is not
499      * required by the EIP. See the note at the beginning of {ERC20}.
500      *
501      * Requirements:
502      *
503      * - `sender` and `recipient` cannot be the zero address.
504      * - `sender` must have a balance of at least `amount`.
505      * - the caller must have allowance for ``sender``'s tokens of at least
506      * `amount`.
507      */
508     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
509         _transfer(sender, recipient, amount);
510         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
511         return true;
512     }
513 
514     /**
515      * @dev Atomically increases the allowance granted to `spender` by the caller.
516      *
517      * This is an alternative to {approve} that can be used as a mitigation for
518      * problems described in {IERC20-approve}.
519      *
520      * Emits an {Approval} event indicating the updated allowance.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
527         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
528         return true;
529     }
530 
531     /**
532      * @dev Atomically decreases the allowance granted to `spender` by the caller.
533      *
534      * This is an alternative to {approve} that can be used as a mitigation for
535      * problems described in {IERC20-approve}.
536      *
537      * Emits an {Approval} event indicating the updated allowance.
538      *
539      * Requirements:
540      *
541      * - `spender` cannot be the zero address.
542      * - `spender` must have allowance for the caller of at least
543      * `subtractedValue`.
544      */
545     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
546         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
547         return true;
548     }
549 
550     /**
551      * @dev Moves tokens `amount` from `sender` to `recipient`.
552      *
553      * This is internal function is equivalent to {transfer}, and can be used to
554      * e.g. implement automatic token fees, slashing mechanisms, etc.
555      *
556      * Emits a {Transfer} event.
557      *
558      * Requirements:
559      *
560      * - `sender` cannot be the zero address.
561      * - `recipient` cannot be the zero address.
562      * - `sender` must have a balance of at least `amount`.
563      */
564     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
565         require(sender != address(0), "ERC20: transfer from the zero address");
566         require(recipient != address(0), "ERC20: transfer to the zero address");
567 
568         _beforeTokenTransfer(sender, recipient, amount);
569 
570         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
571         _balances[recipient] = _balances[recipient].add(amount);
572         emit Transfer(sender, recipient, amount);
573     }
574 
575     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
576      * the total supply.
577      *
578      * Emits a {Transfer} event with `from` set to the zero address.
579      *
580      * Requirements:
581      *
582      * - `to` cannot be the zero address.
583      */
584     function _mint(address account, uint256 amount) internal virtual {
585         require(account != address(0), "ERC20: mint to the zero address");
586 
587         _beforeTokenTransfer(address(0), account, amount);
588 
589         _totalSupply = _totalSupply.add(amount);
590         _balances[account] = _balances[account].add(amount);
591         emit Transfer(address(0), account, amount);
592     }
593 
594     /**
595      * @dev Destroys `amount` tokens from `account`, reducing the
596      * total supply.
597      *
598      * Emits a {Transfer} event with `to` set to the zero address.
599      *
600      * Requirements:
601      *
602      * - `account` cannot be the zero address.
603      * - `account` must have at least `amount` tokens.
604      */
605     function _burn(address account, uint256 amount) internal virtual {
606         require(account != address(0), "ERC20: burn from the zero address");
607 
608         _beforeTokenTransfer(account, address(0), amount);
609 
610         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
611         _totalSupply = _totalSupply.sub(amount);
612         emit Transfer(account, address(0), amount);
613     }
614 
615     /**
616      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
617      *
618      * This internal function is equivalent to `approve`, and can be used to
619      * e.g. set automatic allowances for certain subsystems, etc.
620      *
621      * Emits an {Approval} event.
622      *
623      * Requirements:
624      *
625      * - `owner` cannot be the zero address.
626      * - `spender` cannot be the zero address.
627      */
628     function _approve(address owner, address spender, uint256 amount) internal virtual {
629         require(owner != address(0), "ERC20: approve from the zero address");
630         require(spender != address(0), "ERC20: approve to the zero address");
631 
632         _allowances[owner][spender] = amount;
633         emit Approval(owner, spender, amount);
634     }
635 
636     /**
637      * @dev Sets {decimals} to a value other than the default one of 18.
638      *
639      * WARNING: This function should only be called from the constructor. Most
640      * applications that interact with token contracts will not expect
641      * {decimals} to ever change, and may work incorrectly if it does.
642      */
643     function _setupDecimals(uint8 decimals_) internal {
644         _decimals = decimals_;
645     }
646 
647     /**
648      * @dev Hook that is called before any transfer of tokens. This includes
649      * minting and burning.
650      *
651      * Calling conditions:
652      *
653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
654      * will be to transferred to `to`.
655      * - when `from` is zero, `amount` tokens will be minted for `to`.
656      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
657      * - `from` and `to` are never both zero.
658      *
659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
660      */
661     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
662 }