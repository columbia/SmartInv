1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.4;
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 pragma solidity ^0.7.4;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
242 
243 pragma solidity ^0.7.4;
244 
245 /**
246  * @dev Implementation of the {IERC20} interface.
247  *
248  * This implementation is agnostic to the way tokens are created. This means
249  * that a supply mechanism has to be added in a derived contract using {_mint}.
250  * For a generic mechanism see {ERC20PresetMinterPauser}.
251  *
252  * TIP: For a detailed writeup see our guide
253  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
254  * to implement supply mechanisms].
255  *
256  * We have followed general OpenZeppelin guidelines: functions revert instead
257  * of returning `false` on failure. This behavior is nonetheless conventional
258  * and does not conflict with the expectations of ERC20 applications.
259  *
260  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
261  * This allows applications to reconstruct the allowance for all accounts just
262  * by listening to said events. Other implementations of the EIP may not emit
263  * these events, as it isn't required by the specification.
264  *
265  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
266  * functions have been added to mitigate the well-known issues around setting
267  * allowances. See {IERC20-approve}.
268  */
269 contract ERC20 is IERC20 {
270     using SafeMath for uint256;
271 
272     mapping (address => uint256) private _balances;
273 
274     mapping (address => mapping (address => uint256)) private _allowances;
275 
276     uint256 private _totalSupply;
277 
278     string private _name;
279     string private _symbol;
280     uint8 private _decimals;
281     
282     /* Added by CryptoTask */
283     address private _owner;
284     bool public _locked = false;
285     bool public _lockFixed = false;
286     address public _saleContract = address(0);
287 
288     /**
289      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
290      * a default value of 18.
291      *
292      * To select a different value for {decimals}, use {_setupDecimals}.
293      *
294      * All three of these values are immutable: they can only be set once during
295      * construction.
296      */
297     constructor (string memory name_, string memory symbol_) {
298         _name = name_;
299         _symbol = symbol_;
300         _decimals = 18;
301         _owner = msg.sender;  //added by CryptoTask
302     }
303 
304     /**
305      * @dev Returns the name of the token.
306      */
307     function name() public view returns (string memory) {
308         return _name;
309     }
310 
311     /**
312      * @dev Returns the symbol of the token, usually a shorter version of the
313      * name.
314      */
315     function symbol() public view returns (string memory) {
316         return _symbol;
317     }
318 
319     /**
320      * @dev Returns the number of decimals used to get its user representation.
321      * For example, if `decimals` equals `2`, a balance of `505` tokens should
322      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
323      *
324      * Tokens usually opt for a value of 18, imitating the relationship between
325      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
326      * called.
327      *
328      * NOTE: This information is only used for _display_ purposes: it in
329      * no way affects any of the arithmetic of the contract, including
330      * {IERC20-balanceOf} and {IERC20-transfer}.
331      */
332     function decimals() public view returns (uint8) {
333         return _decimals;
334     }
335 
336     /**
337      * @dev See {IERC20-totalSupply}.
338      */
339     function totalSupply() public view override returns (uint256) {
340         return _totalSupply;
341     }
342 
343     /**
344      * @dev See {IERC20-balanceOf}.
345      */
346     function balanceOf(address account) public view override returns (uint256) {
347         return _balances[account];
348     }
349 
350     /**
351      * @dev See {IERC20-transfer}.
352      *
353      * Requirements:
354      *
355      * - `recipient` cannot be the zero address.
356      * - the caller must have a balance of at least `amount`.
357      */
358     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
359         require(!_locked || msg.sender == _saleContract, "Transfers locked"); //added by CryptoTask
360         _transfer(msg.sender, recipient, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender) public view virtual override returns (uint256) {
368         return _allowances[owner][spender];
369     }
370 
371     /**
372      * @dev See {IERC20-approve}.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      */
378     function approve(address spender, uint256 amount) public virtual override returns (bool) {
379         _approve(msg.sender, spender, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-transferFrom}.
385      *
386      * Emits an {Approval} event indicating the updated allowance. This is not
387      * required by the EIP. See the note at the beginning of {ERC20};
388      *
389      * Requirements:
390      * - `sender` and `recipient` cannot be the zero address.
391      * - `sender` must have a balance of at least `amount`.
392      * - the caller must have allowance for ``sender``'s tokens of at least
393      * `amount`.
394      */
395     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
396         require(!_locked, "Transfers locked");  //added by CryptoTask
397         _transfer(sender, recipient, amount);
398         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
399         return true;
400     }
401 
402     /**
403      * @dev Atomically increases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      */
414     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
415         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
416         return true;
417     }
418 
419     /**
420      * @dev Atomically decreases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      * - `spender` must have allowance for the caller of at least
431      * `subtractedValue`.
432      */
433     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
434         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
435         return true;
436     }
437     
438     
439     /**
440      * @dev Set the address of the sale contract.
441      * `saleContract` can make token transfers
442      * even when the token contract state is locked.
443      * Transfer lock serves the purpose of preventing
444      * the creation of fake Uniswap pools.
445      * 
446      * Added by CryptoTask.
447      *
448      */
449     function setSaleContract(address saleContract) public {
450         require(msg.sender == _owner && _saleContract == address(0), "Caller must be owner and _saleContract yet unset");
451         _saleContract = saleContract;
452     }
453     
454     /**
455      * @dev Lock token transfers.
456      * 
457      * Added by CryptoTask.
458      *
459      */
460     function lockTransfers() public {
461         require(msg.sender == _owner && !_lockFixed, "Caller must be owner and _lockFixed false");
462         _locked = true;
463     }
464     
465     /**
466      * @dev Unlock token transfers.
467      * 
468      * Added by CryptoTask.
469      *
470      */
471     function unlockTransfers() public {
472         require(msg.sender == _owner && !_lockFixed, "Caller must be owner and _lockFixed false");
473         _locked = false;
474     }
475     
476     /**
477      * @dev Permanently unlock token transfers.
478      * After this, further locking is impossible.
479      * 
480      * Added by CryptoTask.
481      *
482      */
483     function unlockTransfersPermanent() public {
484         require(msg.sender == _owner && !_lockFixed, "Caller must be owner and _lockFixed false");
485         _locked = false;
486         _lockFixed = true;
487     }
488     
489 
490     /**
491      * @dev Moves tokens `amount` from `sender` to `recipient`.
492      *
493      * This is internal function is equivalent to {transfer}, and can be used to
494      * e.g. implement automatic token fees, slashing mechanisms, etc.
495      *
496      * Emits a {Transfer} event.
497      *
498      * Requirements:
499      *
500      * - `sender` cannot be the zero address.
501      * - `recipient` cannot be the zero address.
502      * - `sender` must have a balance of at least `amount`.
503      */
504     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
505         require(sender != address(0), "ERC20: transfer from the zero address");
506         require(recipient != address(0), "ERC20: transfer to the zero address");
507 
508         _beforeTokenTransfer(sender, recipient, amount);
509 
510         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
511         _balances[recipient] = _balances[recipient].add(amount);
512         emit Transfer(sender, recipient, amount);
513     }
514 
515     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
516      * the total supply.
517      *
518      * Emits a {Transfer} event with `from` set to the zero address.
519      *
520      * Requirements
521      *
522      * - `to` cannot be the zero address.
523      */
524     function _mint(address account, uint256 amount) internal virtual {
525         require(account != address(0), "ERC20: mint to the zero address");
526 
527         _beforeTokenTransfer(address(0), account, amount);
528 
529         _totalSupply = _totalSupply.add(amount);
530         _balances[account] = _balances[account].add(amount);
531         emit Transfer(address(0), account, amount);
532     }
533 
534     /**
535      * @dev Destroys `amount` tokens from `account`, reducing the
536      * total supply.
537      *
538      * Emits a {Transfer} event with `to` set to the zero address.
539      *
540      * Requirements
541      *
542      * - `account` cannot be the zero address.
543      * - `account` must have at least `amount` tokens.
544      */
545     function _burn(address account, uint256 amount) internal virtual {
546         require(account != address(0), "ERC20: burn from the zero address");
547 
548         _beforeTokenTransfer(account, address(0), amount);
549 
550         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
551         _totalSupply = _totalSupply.sub(amount);
552         emit Transfer(account, address(0), amount);
553     }
554 
555     /**
556      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
557      *
558      * This internal function is equivalent to `approve`, and can be used to
559      * e.g. set automatic allowances for certain subsystems, etc.
560      *
561      * Emits an {Approval} event.
562      *
563      * Requirements:
564      *
565      * - `owner` cannot be the zero address.
566      * - `spender` cannot be the zero address.
567      */
568     function _approve(address owner, address spender, uint256 amount) internal virtual {
569         require(owner != address(0), "ERC20: approve from the zero address");
570         require(spender != address(0), "ERC20: approve to the zero address");
571 
572         _allowances[owner][spender] = amount;
573         emit Approval(owner, spender, amount);
574     }
575 
576     /**
577      * @dev Sets {decimals} to a value other than the default one of 18.
578      *
579      * WARNING: This function should only be called from the constructor. Most
580      * applications that interact with token contracts will not expect
581      * {decimals} to ever change, and may work incorrectly if it does.
582      */
583     function _setupDecimals(uint8 decimals_) internal {
584         _decimals = decimals_;
585     }
586 
587     /**
588      * @dev Hook that is called before any transfer of tokens. This includes
589      * minting and burning.
590      *
591      * Calling conditions:
592      *
593      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
594      * will be to transferred to `to`.
595      * - when `from` is zero, `amount` tokens will be minted for `to`.
596      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
597      * - `from` and `to` are never both zero.
598      *
599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
600      */
601     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
602 }
603 
604 // File: contracts/CtaskToken.sol
605 
606 pragma solidity ^0.7.4;
607 
608 contract CTASK is ERC20 {
609   
610     constructor(
611         address initialAccount,
612         uint256 initialBalance
613     ) ERC20("CTASK Token", "CTASK") {
614         _mint(initialAccount, initialBalance);
615     }
616 }