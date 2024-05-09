1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d9fa59f30a27f095c48b09555106fed0200654e0/contracts/utils/Address.sol
4 
5 pragma solidity ^0.6.2;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { codehash := extcodehash(account) }
36         return (codehash != accountHash && codehash != 0x0);
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 }
63 
64 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d9fa59f30a27f095c48b09555106fed0200654e0/contracts/math/SafeMath.sol
65 
66 pragma solidity ^0.6.0;
67 
68 /**
69  * @dev Wrappers over Solidity's arithmetic operations with added overflow
70  * checks.
71  *
72  * Arithmetic operations in Solidity wrap on overflow. This can easily result
73  * in bugs, because programmers usually assume that an overflow raises an
74  * error, which is the standard behavior in high level programming languages.
75  * `SafeMath` restores this intuition by reverting the transaction when an
76  * operation overflows.
77  *
78  * Using this library instead of the unchecked operations eliminates an entire
79  * class of bugs, so it's recommended to use it always.
80  */
81 library SafeMath {
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      *
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         return div(a, b, "SafeMath: division by zero");
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b > 0, errorMessage);
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         return mod(a, b, "SafeMath: modulo by zero");
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts with custom message when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b != 0, errorMessage);
220         return a % b;
221     }
222 }
223 
224 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d9fa59f30a27f095c48b09555106fed0200654e0/contracts/token/ERC20/IERC20.sol
225 
226 pragma solidity ^0.6.0;
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Emitted when `value` tokens are moved from one account (`from`) to
289      * another (`to`).
290      *
291      * Note that `value` may be zero.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /**
296      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
297      * a call to {approve}. `value` is the new allowance.
298      */
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d9fa59f30a27f095c48b09555106fed0200654e0/contracts/GSN/Context.sol
303 
304 pragma solidity ^0.6.0;
305 
306 /*
307  * @dev Provides information about the current execution context, including the
308  * sender of the transaction and its data. While these are generally available
309  * via msg.sender and msg.data, they should not be accessed in such a direct
310  * manner, since when dealing with GSN meta-transactions the account sending and
311  * paying for execution may not be the actual sender (as far as an application
312  * is concerned).
313  *
314  * This contract is only required for intermediate, library-like contracts.
315  */
316 abstract contract Context {
317     function _msgSender() internal view virtual returns (address payable) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view virtual returns (bytes memory) {
322         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
323         return msg.data;
324     }
325 }
326 
327 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d9fa59f30a27f095c48b09555106fed0200654e0/contracts/token/ERC20/ERC20.sol
328 
329 pragma solidity ^0.6.0;
330 
331 
332 
333 
334 
335 /**
336  * @dev Implementation of the {IERC20} interface.
337  *
338  * This implementation is agnostic to the way tokens are created. This means
339  * that a supply mechanism has to be added in a derived contract using {_mint}.
340  * For a generic mechanism see {ERC20PresetMinterPauser}.
341  *
342  * TIP: For a detailed writeup see our guide
343  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
344  * to implement supply mechanisms].
345  *
346  * We have followed general OpenZeppelin guidelines: functions revert instead
347  * of returning `false` on failure. This behavior is nonetheless conventional
348  * and does not conflict with the expectations of ERC20 applications.
349  *
350  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
351  * This allows applications to reconstruct the allowance for all accounts just
352  * by listening to said events. Other implementations of the EIP may not emit
353  * these events, as it isn't required by the specification.
354  *
355  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
356  * functions have been added to mitigate the well-known issues around setting
357  * allowances. See {IERC20-approve}.
358  */
359 contract ERC20 is Context, IERC20 {
360     using SafeMath for uint256;
361     using Address for address;
362 
363     mapping (address => uint256) private _balances;
364 
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     string private _name;
370     string private _symbol;
371     uint8 private _decimals;
372 
373     /**
374      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
375      * a default value of 18.
376      *
377      * To select a different value for {decimals}, use {_setupDecimals}.
378      *
379      * All three of these values are immutable: they can only be set once during
380      * construction.
381      */
382     constructor (string memory name, string memory symbol) public {
383         _name = name;
384         _symbol = symbol;
385         _decimals = 18;
386     }
387 
388     /**
389      * @dev Returns the name of the token.
390      */
391     function name() public view returns (string memory) {
392         return _name;
393     }
394 
395     /**
396      * @dev Returns the symbol of the token, usually a shorter version of the
397      * name.
398      */
399     function symbol() public view returns (string memory) {
400         return _symbol;
401     }
402 
403     /**
404      * @dev Returns the number of decimals used to get its user representation.
405      * For example, if `decimals` equals `2`, a balance of `505` tokens should
406      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
407      *
408      * Tokens usually opt for a value of 18, imitating the relationship between
409      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
410      * called.
411      *
412      * NOTE: This information is only used for _display_ purposes: it in
413      * no way affects any of the arithmetic of the contract, including
414      * {IERC20-balanceOf} and {IERC20-transfer}.
415      */
416     function decimals() public view returns (uint8) {
417         return _decimals;
418     }
419 
420     /**
421      * @dev See {IERC20-totalSupply}.
422      */
423     function totalSupply() public view override returns (uint256) {
424         return _totalSupply;
425     }
426 
427     /**
428      * @dev See {IERC20-balanceOf}.
429      */
430     function balanceOf(address account) public view override returns (uint256) {
431         return _balances[account];
432     }
433 
434     /**
435      * @dev See {IERC20-transfer}.
436      *
437      * Requirements:
438      *
439      * - `recipient` cannot be the zero address.
440      * - the caller must have a balance of at least `amount`.
441      */
442     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
443         _transfer(_msgSender(), recipient, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-allowance}.
449      */
450     function allowance(address owner, address spender) public view virtual override returns (uint256) {
451         return _allowances[owner][spender];
452     }
453 
454     /**
455      * @dev See {IERC20-approve}.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      */
461     function approve(address spender, uint256 amount) public virtual override returns (bool) {
462         _approve(_msgSender(), spender, amount);
463         return true;
464     }
465 
466     /**
467      * @dev See {IERC20-transferFrom}.
468      *
469      * Emits an {Approval} event indicating the updated allowance. This is not
470      * required by the EIP. See the note at the beginning of {ERC20};
471      *
472      * Requirements:
473      * - `sender` and `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      * - the caller must have allowance for ``sender``'s tokens of at least
476      * `amount`.
477      */
478     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
479         _transfer(sender, recipient, amount);
480         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
481         return true;
482     }
483 
484     /**
485      * @dev Atomically increases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      */
496     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
498         return true;
499     }
500 
501     /**
502      * @dev Atomically decreases the allowance granted to `spender` by the caller.
503      *
504      * This is an alternative to {approve} that can be used as a mitigation for
505      * problems described in {IERC20-approve}.
506      *
507      * Emits an {Approval} event indicating the updated allowance.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      * - `spender` must have allowance for the caller of at least
513      * `subtractedValue`.
514      */
515     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
516         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
517         return true;
518     }
519 
520     /**
521      * @dev Moves tokens `amount` from `sender` to `recipient`.
522      *
523      * This is internal function is equivalent to {transfer}, and can be used to
524      * e.g. implement automatic token fees, slashing mechanisms, etc.
525      *
526      * Emits a {Transfer} event.
527      *
528      * Requirements:
529      *
530      * - `sender` cannot be the zero address.
531      * - `recipient` cannot be the zero address.
532      * - `sender` must have a balance of at least `amount`.
533      */
534     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
535         require(sender != address(0), "ERC20: transfer from the zero address");
536         require(recipient != address(0), "ERC20: transfer to the zero address");
537 
538         _beforeTokenTransfer(sender, recipient, amount);
539 
540         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
541         _balances[recipient] = _balances[recipient].add(amount);
542         emit Transfer(sender, recipient, amount);
543     }
544 
545     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
546      * the total supply.
547      *
548      * Emits a {Transfer} event with `from` set to the zero address.
549      *
550      * Requirements
551      *
552      * - `to` cannot be the zero address.
553      */
554     function _mint(address account, uint256 amount) internal virtual {
555         require(account != address(0), "ERC20: mint to the zero address");
556 
557         _beforeTokenTransfer(address(0), account, amount);
558 
559         _totalSupply = _totalSupply.add(amount);
560         _balances[account] = _balances[account].add(amount);
561         emit Transfer(address(0), account, amount);
562     }
563 
564     /**
565      * @dev Destroys `amount` tokens from `account`, reducing the
566      * total supply.
567      *
568      * Emits a {Transfer} event with `to` set to the zero address.
569      *
570      * Requirements
571      *
572      * - `account` cannot be the zero address.
573      * - `account` must have at least `amount` tokens.
574      */
575     function _burn(address account, uint256 amount) internal virtual {
576         require(account != address(0), "ERC20: burn from the zero address");
577 
578         _beforeTokenTransfer(account, address(0), amount);
579 
580         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
581         _totalSupply = _totalSupply.sub(amount);
582         emit Transfer(account, address(0), amount);
583     }
584 
585     /**
586      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
587      *
588      * This is internal function is equivalent to `approve`, and can be used to
589      * e.g. set automatic allowances for certain subsystems, etc.
590      *
591      * Emits an {Approval} event.
592      *
593      * Requirements:
594      *
595      * - `owner` cannot be the zero address.
596      * - `spender` cannot be the zero address.
597      */
598     function _approve(address owner, address spender, uint256 amount) internal virtual {
599         require(owner != address(0), "ERC20: approve from the zero address");
600         require(spender != address(0), "ERC20: approve to the zero address");
601 
602         _allowances[owner][spender] = amount;
603         emit Approval(owner, spender, amount);
604     }
605 
606     /**
607      * @dev Sets {decimals} to a value other than the default one of 18.
608      *
609      * WARNING: This function should only be called from the constructor. Most
610      * applications that interact with token contracts will not expect
611      * {decimals} to ever change, and may work incorrectly if it does.
612      */
613     function _setupDecimals(uint8 decimals_) internal {
614         _decimals = decimals_;
615     }
616 
617     /**
618      * @dev Hook that is called before any transfer of tokens. This includes
619      * minting and burning.
620      *
621      * Calling conditions:
622      *
623      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
624      * will be to transferred to `to`.
625      * - when `from` is zero, `amount` tokens will be minted for `to`.
626      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
627      * - `from` and `to` are never both zero.
628      *
629      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
630      */
631     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
632 }
633 
634 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d9fa59f30a27f095c48b09555106fed0200654e0/contracts/token/ERC20/ERC20Burnable.sol
635 
636 pragma solidity ^0.6.0;
637 
638 /**
639  * @dev Extension of {ERC20} that allows token holders to destroy both their own
640  * tokens and those that they have an allowance for, in a way that can be
641  * recognized off-chain (via event analysis).
642  */
643 abstract contract ERC20Burnable is Context, ERC20 {
644     /**
645      * @dev Destroys `amount` tokens from the caller.
646      *
647      * See {ERC20-_burn}.
648      */
649     function burn(uint256 amount) public virtual {
650         _burn(_msgSender(), amount);
651     }
652 
653     /**
654      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
655      * allowance.
656      *
657      * See {ERC20-_burn} and {ERC20-allowance}.
658      *
659      * Requirements:
660      *
661      * - the caller must have allowance for ``accounts``'s tokens of at least
662      * `amount`.
663      */
664     function burnFrom(address account, uint256 amount) public virtual {
665         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
666 
667         _approve(account, _msgSender(), decreasedAllowance);
668         _burn(account, amount);
669     }
670 }
671 
672 
673 // File: CATX.sol
674 
675 pragma solidity ^0.6.12;
676 
677 contract CATXToken is ERC20, ERC20Burnable {
678     constructor() ERC20("CAT.trade", "CATX") public {
679         // Limit supply to 100,000,000 at 18 decimal places = 100,000,000,000,000,000,000,000,000
680         _mint(msg.sender, 100000000000000000000000000);
681     }
682 }