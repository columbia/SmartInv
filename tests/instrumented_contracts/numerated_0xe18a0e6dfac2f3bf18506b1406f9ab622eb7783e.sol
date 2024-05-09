1 // File: @openzeppelin\contracts\math\SafeMath.sol
2 
3 // SPDX-License-Identifier: SimPL-2.0
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
164 
165 
166 pragma solidity >=0.6.0 <0.8.0;
167 
168 /**
169  * @dev Interface of the ERC20 standard as defined in the EIP.
170  */
171 interface IERC20 {
172     /**
173      * @dev Returns the amount of tokens in existence.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     /**
178      * @dev Returns the amount of tokens owned by `account`.
179      */
180     function balanceOf(address account) external view returns (uint256);
181 
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transfer(address recipient, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Returns the remaining number of tokens that `spender` will be
193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
194      * zero by default.
195      *
196      * This value changes when {approve} or {transferFrom} are called.
197      */
198     function allowance(address owner, address spender) external view returns (uint256);
199 
200     /**
201      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * IMPORTANT: Beware that changing an allowance with this method brings the risk
206      * that someone may use both the old and the new allowance by unfortunate
207      * transaction ordering. One possible solution to mitigate this race
208      * condition is to first reduce the spender's allowance to 0 and set the
209      * desired value afterwards:
210      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address spender, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Moves `amount` tokens from `sender` to `recipient` using the
218      * allowance mechanism. `amount` is then deducted from the caller's
219      * allowance.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Emitted when `value` tokens are moved from one account (`from`) to
229      * another (`to`).
230      *
231      * Note that `value` may be zero.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     /**
236      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
237      * a call to {approve}. `value` is the new allowance.
238      */
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
243 
244 
245 pragma solidity >=0.6.0 <0.8.0;
246 
247 /*
248  * @dev Provides information about the current execution context, including the
249  * sender of the transaction and its data. While these are generally available
250  * via msg.sender and msg.data, they should not be accessed in such a direct
251  * manner, since when dealing with GSN meta-transactions the account sending and
252  * paying for execution may not be the actual sender (as far as an application
253  * is concerned).
254  *
255  * This contract is only required for intermediate, library-like contracts.
256  */
257 abstract contract Context {
258     function _msgSender() internal view virtual returns (address payable) {
259         return msg.sender;
260     }
261 
262     function _msgData() internal view virtual returns (bytes memory) {
263         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
264         return msg.data;
265     }
266 }
267 
268 // File: @openzeppelin\contracts\access\Ownable.sol
269 
270 
271 pragma solidity >=0.6.0 <0.8.0;
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * By default, the owner account will be the one that deploys the contract. This
279  * can later be changed with {transferOwnership}.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 abstract contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor () internal {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(_owner == _msgSender(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Leaves the contract without owner. It will not be possible to call
316      * `onlyOwner` functions anymore. Can only be called by the current owner.
317      *
318      * NOTE: Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public virtual onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         emit OwnershipTransferred(_owner, newOwner);
333         _owner = newOwner;
334     }
335 }
336 
337 // File: contracts\IStakingV2.sol
338 
339 pragma solidity 0.6.12;
340 
341 /**
342  * @title Staking interface, as defined by EIP-900.
343  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
344  */
345 abstract contract IStakingV2 {
346     event Staked(address indexed user, uint256 amount, uint256 total, address referrer);
347     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
348 
349     function stake(uint256 amount, address referrer) external virtual;
350     function stakeFor(address user, uint256 amount, address referrer) external virtual;
351     function unstake(uint256 amount) external virtual;
352     function totalStakedFor(address addr) public virtual view returns (uint256);
353     function totalStaked() public virtual view returns (uint256);
354     function token() external virtual view returns (address);
355 
356     /**
357      * @return False. This application does not support staking history.
358      */
359     function supportsHistory() external pure returns (bool) {
360         return false;
361     }
362 }
363 
364 // File: contracts\TokenPool.sol
365 
366 pragma solidity 0.6.12;
367 
368 
369 
370 /**
371  * @title A simple holder of tokens.
372  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
373  * needs to hold multiple distinct pools of the same token.
374  */
375 contract TokenPool is Ownable {
376     IERC20 public token;
377 
378     constructor(IERC20 _token) public {
379         token = _token;
380     }
381 
382     function balance() public view returns (uint256) {
383         return token.balanceOf(address(this));
384     }
385 
386     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
387         return token.transfer(to, value);
388     }
389 
390     function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {
391         require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');
392 
393         return IERC20(tokenToRescue).transfer(to, amount);
394     }
395 }
396 
397 // File: contracts\IReferrerBook.sol
398 
399 pragma solidity 0.6.12;
400 
401 interface IReferrerBook {
402     function affirmReferrer(address user, address referrer) external returns (bool);
403     function getUserReferrer(address user) external view returns (address);
404     function getUserTopNode(address user) external view returns (address);
405     function getUserNormalNode(address user) external view returns (address);
406 }
407 
408 
409 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
410 
411 
412 pragma solidity >=0.6.0 <0.8.0;
413 
414 
415 
416 
417 /**
418  * @dev Implementation of the {IERC20} interface.
419  *
420  * This implementation is agnostic to the way tokens are created. This means
421  * that a supply mechanism has to be added in a derived contract using {_mint}.
422  * For a generic mechanism see {ERC20PresetMinterPauser}.
423  *
424  * TIP: For a detailed writeup see our guide
425  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
426  * to implement supply mechanisms].
427  *
428  * We have followed general OpenZeppelin guidelines: functions revert instead
429  * of returning `false` on failure. This behavior is nonetheless conventional
430  * and does not conflict with the expectations of ERC20 applications.
431  *
432  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
433  * This allows applications to reconstruct the allowance for all accounts just
434  * by listening to said events. Other implementations of the EIP may not emit
435  * these events, as it isn't required by the specification.
436  *
437  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
438  * functions have been added to mitigate the well-known issues around setting
439  * allowances. See {IERC20-approve}.
440  */
441 contract ERC20 is Context, IERC20 {
442     using SafeMath for uint256;
443 
444     mapping (address => uint256) private _balances;
445 
446     mapping (address => mapping (address => uint256)) private _allowances;
447 
448     uint256 private _totalSupply;
449 
450     string private _name;
451     string private _symbol;
452     uint8 private _decimals;
453 
454     /**
455      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
456      * a default value of 18.
457      *
458      * To select a different value for {decimals}, use {_setupDecimals}.
459      *
460      * All three of these values are immutable: they can only be set once during
461      * construction.
462      */
463     constructor (string memory name_, string memory symbol_) public {
464         _name = name_;
465         _symbol = symbol_;
466         _decimals = 18;
467     }
468 
469     /**
470      * @dev Returns the name of the token.
471      */
472     function name() public view returns (string memory) {
473         return _name;
474     }
475 
476     /**
477      * @dev Returns the symbol of the token, usually a shorter version of the
478      * name.
479      */
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     /**
485      * @dev Returns the number of decimals used to get its user representation.
486      * For example, if `decimals` equals `2`, a balance of `505` tokens should
487      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
488      *
489      * Tokens usually opt for a value of 18, imitating the relationship between
490      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
491      * called.
492      *
493      * NOTE: This information is only used for _display_ purposes: it in
494      * no way affects any of the arithmetic of the contract, including
495      * {IERC20-balanceOf} and {IERC20-transfer}.
496      */
497     function decimals() public view returns (uint8) {
498         return _decimals;
499     }
500 
501     /**
502      * @dev See {IERC20-totalSupply}.
503      */
504     function totalSupply() public view override returns (uint256) {
505         return _totalSupply;
506     }
507 
508     /**
509      * @dev See {IERC20-balanceOf}.
510      */
511     function balanceOf(address account) public view override returns (uint256) {
512         return _balances[account];
513     }
514 
515     /**
516      * @dev See {IERC20-transfer}.
517      *
518      * Requirements:
519      *
520      * - `recipient` cannot be the zero address.
521      * - the caller must have a balance of at least `amount`.
522      */
523     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
524         _transfer(_msgSender(), recipient, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-allowance}.
530      */
531     function allowance(address owner, address spender) public view virtual override returns (uint256) {
532         return _allowances[owner][spender];
533     }
534 
535     /**
536      * @dev See {IERC20-approve}.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function approve(address spender, uint256 amount) public virtual override returns (bool) {
543         _approve(_msgSender(), spender, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-transferFrom}.
549      *
550      * Emits an {Approval} event indicating the updated allowance. This is not
551      * required by the EIP. See the note at the beginning of {ERC20}.
552      *
553      * Requirements:
554      *
555      * - `sender` and `recipient` cannot be the zero address.
556      * - `sender` must have a balance of at least `amount`.
557      * - the caller must have allowance for ``sender``'s tokens of at least
558      * `amount`.
559      */
560     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
580         return true;
581     }
582 
583     /**
584      * @dev Atomically decreases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `spender` must have allowance for the caller of at least
595      * `subtractedValue`.
596      */
597     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
598         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
599         return true;
600     }
601 
602     /**
603      * @dev Moves tokens `amount` from `sender` to `recipient`.
604      *
605      * This is internal function is equivalent to {transfer}, and can be used to
606      * e.g. implement automatic token fees, slashing mechanisms, etc.
607      *
608      * Emits a {Transfer} event.
609      *
610      * Requirements:
611      *
612      * - `sender` cannot be the zero address.
613      * - `recipient` cannot be the zero address.
614      * - `sender` must have a balance of at least `amount`.
615      */
616     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
617         require(sender != address(0), "ERC20: transfer from the zero address");
618         require(recipient != address(0), "ERC20: transfer to the zero address");
619 
620         _beforeTokenTransfer(sender, recipient, amount);
621 
622         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
623         _balances[recipient] = _balances[recipient].add(amount);
624         emit Transfer(sender, recipient, amount);
625     }
626 
627     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
628      * the total supply.
629      *
630      * Emits a {Transfer} event with `from` set to the zero address.
631      *
632      * Requirements:
633      *
634      * - `to` cannot be the zero address.
635      */
636     function _mint(address account, uint256 amount) internal virtual {
637         require(account != address(0), "ERC20: mint to the zero address");
638 
639         _beforeTokenTransfer(address(0), account, amount);
640 
641         _totalSupply = _totalSupply.add(amount);
642         _balances[account] = _balances[account].add(amount);
643         emit Transfer(address(0), account, amount);
644     }
645 
646     /**
647      * @dev Destroys `amount` tokens from `account`, reducing the
648      * total supply.
649      *
650      * Emits a {Transfer} event with `to` set to the zero address.
651      *
652      * Requirements:
653      *
654      * - `account` cannot be the zero address.
655      * - `account` must have at least `amount` tokens.
656      */
657     function _burn(address account, uint256 amount) internal virtual {
658         require(account != address(0), "ERC20: burn from the zero address");
659 
660         _beforeTokenTransfer(account, address(0), amount);
661 
662         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
663         _totalSupply = _totalSupply.sub(amount);
664         emit Transfer(account, address(0), amount);
665     }
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
669      *
670      * This internal function is equivalent to `approve`, and can be used to
671      * e.g. set automatic allowances for certain subsystems, etc.
672      *
673      * Emits an {Approval} event.
674      *
675      * Requirements:
676      *
677      * - `owner` cannot be the zero address.
678      * - `spender` cannot be the zero address.
679      */
680     function _approve(address owner, address spender, uint256 amount) internal virtual {
681         require(owner != address(0), "ERC20: approve from the zero address");
682         require(spender != address(0), "ERC20: approve to the zero address");
683 
684         _allowances[owner][spender] = amount;
685         emit Approval(owner, spender, amount);
686     }
687 
688     /**
689      * @dev Sets {decimals} to a value other than the default one of 18.
690      *
691      * WARNING: This function should only be called from the constructor. Most
692      * applications that interact with token contracts will not expect
693      * {decimals} to ever change, and may work incorrectly if it does.
694      */
695     function _setupDecimals(uint8 decimals_) internal {
696         _decimals = decimals_;
697     }
698 
699     /**
700      * @dev Hook that is called before any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * will be to transferred to `to`.
707      * - when `from` is zero, `amount` tokens will be minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
714 }
715 
716 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
717 
718 
719 pragma solidity >=0.6.0 <0.8.0;
720 
721 
722 
723 /**
724  * @dev Extension of {ERC20} that allows token holders to destroy both their own
725  * tokens and those that they have an allowance for, in a way that can be
726  * recognized off-chain (via event analysis).
727  */
728 abstract contract ERC20Burnable is Context, ERC20 {
729     using SafeMath for uint256;
730 
731     /**
732      * @dev Destroys `amount` tokens from the caller.
733      *
734      * See {ERC20-_burn}.
735      */
736     function burn(uint256 amount) public virtual {
737         _burn(_msgSender(), amount);
738     }
739 
740     /**
741      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
742      * allowance.
743      *
744      * See {ERC20-_burn} and {ERC20-allowance}.
745      *
746      * Requirements:
747      *
748      * - the caller must have allowance for ``accounts``'s tokens of at least
749      * `amount`.
750      */
751     function burnFrom(address account, uint256 amount) public virtual {
752         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
753 
754         _approve(account, _msgSender(), decreasedAllowance);
755         _burn(account, amount);
756     }
757 }
758 
759 // File: contracts\DelegateERC20.sol
760 
761 pragma solidity 0.6.12;
762 
763 
764 abstract contract DelegateERC20 is ERC20Burnable {
765     // @notice A record of each accounts delegate
766     mapping(address => address) internal _delegates;
767 
768     /// @notice A checkpoint for marking number of votes from a given block
769     struct Checkpoint {
770         uint32 fromBlock;
771         uint256 votes;
772     }
773 
774     /// @notice A record of votes checkpoints for each account, by index
775     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
776 
777     /// @notice The number of checkpoints for each account
778     mapping(address => uint32) public numCheckpoints;
779 
780     /// @notice The EIP-712 typehash for the contract's domain
781     bytes32 public constant DOMAIN_TYPEHASH =
782         keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)');
783 
784     /// @notice The EIP-712 typehash for the delegation struct used by the contract
785     bytes32 public constant DELEGATION_TYPEHASH =
786         keccak256('Delegation(address delegatee,uint256 nonce,uint256 expiry)');
787 
788     /// @notice A record of states for signing / validating signatures
789     mapping(address => uint256) public nonces;
790 
791     // support delegates mint
792     function _mint(address account, uint256 amount) internal virtual override {
793         super._mint(account, amount);
794 
795         // add delegates to the minter
796         _moveDelegates(address(0), _delegates[account], amount);
797     }
798 
799     function _transfer(
800         address sender,
801         address recipient,
802         uint256 amount
803     ) internal virtual override {
804         super._transfer(sender, recipient, amount);
805         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
806     }
807 
808     // support delegates burn
809     function burn(uint256 amount) public virtual override {
810         super.burn(amount);
811 
812         // del delegates to backhole
813         _moveDelegates(_delegates[_msgSender()], address(0), amount);
814     }
815 
816     function burnFrom(address account, uint256 amount) public virtual override {
817         super.burnFrom(account, amount);
818 
819         // del delegates to the backhole
820         _moveDelegates(_delegates[account], address(0), amount);
821     }
822 
823     /**
824      * @notice Delegate votes from `msg.sender` to `delegatee`
825      * @param delegatee The address to delegate votes to
826      */
827     function delegate(address delegatee) external {
828         return _delegate(msg.sender, delegatee);
829     }
830 
831     /**
832      * @notice Delegates votes from signatory to `delegatee`
833      * @param delegatee The address to delegate votes to
834      * @param nonce The contract state required to match the signature
835      * @param expiry The time at which to expire the signature
836      * @param v The recovery byte of the signature
837      * @param r Half of the ECDSA signature pair
838      * @param s Half of the ECDSA signature pair
839      */
840     function delegateBySig(
841         address delegatee,
842         uint256 nonce,
843         uint256 expiry,
844         uint8 v,
845         bytes32 r,
846         bytes32 s
847     ) external {
848         bytes32 domainSeparator =
849             keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this)));
850 
851         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
852 
853         bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
854 
855         address signatory = ecrecover(digest, v, r, s);
856         require(signatory != address(0), 'Governance::delegateBySig: invalid signature');
857         require(nonce == nonces[signatory]++, 'Governance::delegateBySig: invalid nonce');
858         require(now <= expiry, 'Governance::delegateBySig: signature expired');
859         return _delegate(signatory, delegatee);
860     }
861 
862     /**
863      * @notice Gets the current votes balance for `account`
864      * @param account The address to get votes balance
865      * @return The number of current votes for `account`
866      */
867     function getCurrentVotes(address account) external view returns (uint256) {
868         uint32 nCheckpoints = numCheckpoints[account];
869         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
870     }
871 
872     /**
873      * @notice Determine the prior number of votes for an account as of a block number
874      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
875      * @param account The address of the account to check
876      * @param blockNumber The block number to get the vote balance at
877      * @return The number of votes the account had as of the given block
878      */
879     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
880         require(blockNumber < block.number, 'Governance::getPriorVotes: not yet determined');
881 
882         uint32 nCheckpoints = numCheckpoints[account];
883         if (nCheckpoints == 0) {
884             return 0;
885         }
886 
887         // First check most recent balance
888         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
889             return checkpoints[account][nCheckpoints - 1].votes;
890         }
891 
892         // Next check implicit zero balance
893         if (checkpoints[account][0].fromBlock > blockNumber) {
894             return 0;
895         }
896 
897         uint32 lower = 0;
898         uint32 upper = nCheckpoints - 1;
899         while (upper > lower) {
900             uint32 center = upper - (upper - lower) / 2;
901             // ceil, avoiding overflow
902             Checkpoint memory cp = checkpoints[account][center];
903             if (cp.fromBlock == blockNumber) {
904                 return cp.votes;
905             } else if (cp.fromBlock < blockNumber) {
906                 lower = center;
907             } else {
908                 upper = center - 1;
909             }
910         }
911         return checkpoints[account][lower].votes;
912     }
913 
914     function _delegate(address delegator, address delegatee) internal {
915         address currentDelegate = _delegates[delegator];
916         uint256 delegatorBalance = balanceOf(delegator);
917         // balance of underlying balances (not scaled);
918         _delegates[delegator] = delegatee;
919 
920         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
921 
922         emit DelegateChanged(delegator, currentDelegate, delegatee);
923     }
924 
925     function _moveDelegates(
926         address srcRep,
927         address dstRep,
928         uint256 amount
929     ) internal {
930         if (srcRep != dstRep && amount > 0) {
931             if (srcRep != address(0)) {
932                 // decrease old representative
933                 uint32 srcRepNum = numCheckpoints[srcRep];
934                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
935                 uint256 srcRepNew = srcRepOld.sub(amount);
936                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
937             }
938 
939             if (dstRep != address(0)) {
940                 // increase new representative
941                 uint32 dstRepNum = numCheckpoints[dstRep];
942                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
943                 uint256 dstRepNew = dstRepOld.add(amount);
944                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
945             }
946         }
947     }
948 
949     function _writeCheckpoint(
950         address delegatee,
951         uint32 nCheckpoints,
952         uint256 oldVotes,
953         uint256 newVotes
954     ) internal {
955         uint32 blockNumber = safe32(block.number, 'Governance::_writeCheckpoint: block number exceeds 32 bits');
956 
957         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
958             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
959         } else {
960             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
961             numCheckpoints[delegatee] = nCheckpoints + 1;
962         }
963 
964         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
965     }
966 
967     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
968         require(n < 2**32, errorMessage);
969         return uint32(n);
970     }
971 
972     function getChainId() internal pure returns (uint256) {
973         uint256 chainId;
974         assembly {
975             chainId := chainid()
976         }
977 
978         return chainId;
979     }
980 
981     /// @notice An event thats emitted when an account changes its delegate
982     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
983 
984     /// @notice An event thats emitted when a delegate account's vote balance changes
985     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
986 }
987 
988 // File: contracts\DSAGovToken.sol
989 
990 pragma solidity 0.6.12;
991 
992 
993 
994 contract DSAGovToken is DelegateERC20, Ownable {
995     constructor() public ERC20("DSBTC", "DSBTC") {}
996 
997     function mint(address _to, uint256 _amount) public onlyOwner {
998         _mint(_to, _amount);
999     }
1000 }
1001 
1002 // File: contracts\GovTokenPool.sol
1003 
1004 pragma solidity 0.6.12;
1005 
1006 
1007 
1008 
1009 interface IOracle {
1010     function getData() external returns (uint256, bool);
1011 }
1012 
1013 contract GovTokenPool is Ownable {
1014     using SafeMath for uint256;
1015 
1016     struct PoolInfo {
1017         uint256 allocPoint;
1018         uint256 lastRewardBlock;
1019         uint256 accTokenPerShare;
1020     }
1021 
1022     mapping(address => PoolInfo) public poolInfo;
1023     mapping(address => mapping(address => uint256)) public userDebt;
1024 
1025     DSAGovToken public token;
1026     IOracle public cpiOracle;
1027     IOracle public marketOracle;
1028     uint256 public totalAllocPoint;
1029     uint256 public startBlock;
1030 
1031     address public governance;
1032 
1033     uint256 public priceRate;
1034 
1035     uint256 constant BASE_CPI = 100 * 10**18;
1036     uint256 public constant BASE_REWARD_PER_BLOCK = 111 * 10**16;
1037 
1038     uint256 constant MAX_GAP_BLOCKS = 6500;
1039     uint256 constant BLOCKS_4YEARS = 2372500 * 4;
1040 
1041     uint256 constant ONE = 10**18;
1042     uint256 constant ZERO_PT_ONE = 10**17;
1043 
1044     uint256 constant PERFECT_RATE = 1 * ONE; //100%
1045     uint256 constant HIGH_RATE_D = 3 * ZERO_PT_ONE;
1046     uint256 constant HIGH_RATE = PERFECT_RATE + HIGH_RATE_D; //130%
1047     uint256 constant LOW_RATE_D = 9 * ZERO_PT_ONE;
1048     uint256 constant LOW_RATE = PERFECT_RATE - LOW_RATE_D; //10%
1049 
1050     constructor(
1051         DSAGovToken _token,
1052         IOracle _cpiOracle,
1053         IOracle _marketOracle,
1054         uint256 _startBlock
1055     ) public {
1056         token = _token;
1057         cpiOracle = _cpiOracle;
1058         marketOracle = _marketOracle;
1059         startBlock = _startBlock;
1060 
1061         governance = _msgSender();
1062     }
1063 
1064     modifier onlyGovernance() {
1065         require(governance == _msgSender(), "Only governance");
1066         _;
1067     }
1068 
1069     function balance() public view returns (uint256) {
1070         return token.balanceOf(address(this));
1071     }
1072 
1073     function syncRate() external {
1074         uint256 cpi;
1075         bool cpiValid;
1076         (cpi, cpiValid) = cpiOracle.getData();
1077         if (!cpiValid) {
1078             priceRate = 0;
1079             return;
1080         }
1081 
1082         uint256 rate;
1083         bool exRateValid;
1084         (rate, exRateValid) = marketOracle.getData();
1085         if (!exRateValid) {
1086             priceRate = 0;
1087             return;
1088         }
1089         uint256 targetRate = cpi.mul(10**18).div(BASE_CPI);
1090 
1091         priceRate = rate.mul(ONE).div(targetRate);
1092     }
1093 
1094     function addPool(address _addr, uint256 _allocPoint)
1095         external
1096         onlyGovernance()
1097     {
1098         uint256 lastRewardBlock =
1099             block.number > startBlock ? block.number : startBlock;
1100         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1101 
1102         require(poolInfo[_addr].lastRewardBlock == 0, "pool exists");
1103 
1104         poolInfo[_addr] = PoolInfo({
1105             allocPoint: _allocPoint,
1106             lastRewardBlock: lastRewardBlock,
1107             accTokenPerShare: 0
1108         });
1109     }
1110 
1111     function removePool(address _addr) external onlyGovernance() {
1112         delete poolInfo[_addr];
1113     }
1114 
1115     function setPool(address _addr, uint256 _allocPoint)
1116         external
1117         onlyGovernance()
1118     {
1119         require(poolInfo[_addr].lastRewardBlock != 0, "pool not exists");
1120 
1121         totalAllocPoint = totalAllocPoint.sub(poolInfo[_addr].allocPoint).add(
1122             _allocPoint
1123         );
1124         poolInfo[_addr].allocPoint = _allocPoint;
1125     }
1126 
1127     function transferGovernance(address _newAddr) external onlyGovernance() {
1128         require(_newAddr != address(0), "zero address");
1129 
1130         governance = _newAddr;
1131     }
1132 
1133     function calcRatedReward(
1134         uint256 _initReward,
1135         uint256 r
1136     ) internal pure returns (uint256) {
1137 
1138         uint256 f;
1139 
1140         if(r == PERFECT_RATE) {
1141             return _initReward;
1142         }
1143         
1144         if(r > PERFECT_RATE && r < HIGH_RATE) {
1145             f = HIGH_RATE.sub(r).mul(ONE).div(HIGH_RATE_D);
1146         } else if(r < PERFECT_RATE && r > LOW_RATE) {
1147             f = r.sub(LOW_RATE).mul(ONE).div(LOW_RATE_D);
1148         }
1149 
1150         return f.mul(f).div(ONE).mul(_initReward).div(ONE);
1151     }
1152 
1153     function _updatePool(PoolInfo storage pool, uint256 _lpSupply) private {
1154         if (block.number <= pool.lastRewardBlock) {
1155             return;
1156         }
1157 
1158         if (_lpSupply == 0) {
1159             pool.lastRewardBlock = block.number;
1160             return;
1161         }
1162 
1163         if (priceRate == 0) {
1164             pool.lastRewardBlock = block.number;
1165             return;
1166         }
1167 
1168         if (priceRate >= HIGH_RATE || priceRate <= LOW_RATE) {
1169             pool.lastRewardBlock = block.number;
1170             return;
1171         }
1172 
1173         uint256 blocks = block.number.sub(pool.lastRewardBlock);
1174 
1175         if (blocks > MAX_GAP_BLOCKS) {
1176             blocks = MAX_GAP_BLOCKS;
1177         }
1178 
1179         uint256 halveTimes = block.number.sub(startBlock).div(BLOCKS_4YEARS);
1180 
1181         uint256 perfectReward =
1182             blocks
1183                 .mul(BASE_REWARD_PER_BLOCK)
1184                 .mul(pool.allocPoint)
1185                 .div(totalAllocPoint)
1186                 .div(2**halveTimes);
1187 
1188         uint256 reward =
1189             calcRatedReward(perfectReward, priceRate);
1190 
1191         if (reward > 0) {
1192             token.mint(address(this), reward);
1193             pool.accTokenPerShare = pool.accTokenPerShare.add(
1194                 reward.mul(1e12).div(_lpSupply)
1195             );
1196         }
1197 
1198         pool.lastRewardBlock = block.number;
1199     }
1200 
1201     function updatePool(uint256 _lpSupply) external {
1202         address poolAddr = _msgSender();
1203         PoolInfo storage pool = poolInfo[poolAddr];
1204         require(pool.lastRewardBlock != 0, 'Pool not exists');
1205 
1206         _updatePool(pool, _lpSupply);
1207     }
1208 
1209     function updateAndClaim(
1210         address _userAddr,
1211         uint256 _userAmount,
1212         uint256 _lpSupply
1213     ) external {
1214         address poolAddr = _msgSender();
1215         PoolInfo storage pool = poolInfo[poolAddr];
1216         require(pool.lastRewardBlock != 0, 'Pool not exists');
1217 
1218         _updatePool(pool, _lpSupply);
1219 
1220         uint256 toClaim =
1221             _userAmount.mul(pool.accTokenPerShare).div(1e12).sub(
1222                 userDebt[poolAddr][_userAddr]
1223             );
1224 
1225         if(toClaim > 0) {
1226             require(token.transfer(_userAddr, toClaim), 'transfer dbtc error');
1227         } 
1228     }
1229 
1230     function updateDebt(address _userAddr, uint256 _userAmount) external {
1231         address poolAddr = _msgSender();
1232         PoolInfo memory pool = poolInfo[poolAddr];
1233         require(pool.lastRewardBlock != 0, 'Pool not exists');
1234         userDebt[poolAddr][_userAddr] = _userAmount.mul(pool.accTokenPerShare).div(1e12);
1235     }
1236 
1237     function pendingReward(
1238         address _poolAddr,
1239         uint256 _userAmount,
1240         address _userAddr
1241     ) external view returns (uint256) {
1242         PoolInfo memory pool = poolInfo[_poolAddr];
1243         return
1244             _userAmount.mul(pool.accTokenPerShare).div(1e12).sub(
1245                 userDebt[_poolAddr][_userAddr]
1246             );
1247     }
1248 }
1249 
1250 // File: contracts\TokenGeyserV2.sol
1251 
1252 pragma solidity 0.6.12;
1253 
1254 
1255 
1256 
1257 
1258 
1259 
1260 
1261 contract TokenGeyserV2 is IStakingV2, Ownable {
1262     using SafeMath for uint256;
1263 
1264     event Staked(
1265         address indexed user,
1266         uint256 amount,
1267         uint256 total,
1268         address referrer
1269     );
1270     event Unstaked(
1271         address indexed user,
1272         uint256 amount,
1273         uint256 total
1274     );
1275     event TokensClaimed(address indexed user, uint256 amount);
1276     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
1277     // amount: Unlocked tokens, total: Total locked tokens
1278     event TokensUnlocked(uint256 amount, uint256 total);
1279 
1280     TokenPool private _stakingPool;
1281     TokenPool private _unlockedPool;
1282     TokenPool private _lockedPool;
1283     GovTokenPool public govTokenPool;
1284 
1285     //
1286     // Time-bonus params
1287     //
1288     uint256 public constant BONUS_DECIMALS = 2;
1289     uint256 public startBonus = 0;
1290     uint256 public bonusPeriodSec = 0;
1291 
1292     //
1293     // Global accounting state
1294     //
1295     uint256 public totalLockedShares = 0;
1296     uint256 public totalStakingShares = 0;
1297     uint256 private _totalStakingShareSeconds = 0;
1298     uint256 private _lastAccountingTimestampSec = now;
1299     uint256 private _maxUnlockSchedules = 0;
1300     uint256 private _initialSharesPerToken = 0;
1301 
1302     address public referrerBook;
1303 
1304     //share percent below: user + referrer + topNode == 100% == 10000
1305     uint256 public constant USER_SHARE_PCT = 8000;
1306     uint256 public constant REF_SHARE_PCT = 1500;
1307     uint256 public constant NODE_SHARE_PCT = 500;
1308 
1309     //
1310     // User accounting state
1311     //
1312     // Represents a single stake for a user. A user may have multiple.
1313     struct Stake {
1314         uint256 stakingShares;
1315         uint256 timestampSec;
1316     }
1317 
1318     // Caches aggregated values from the User->Stake[] map to save computation.
1319     // If lastAccountingTimestampSec is 0, there's no entry for that user.
1320     struct UserTotals {
1321         uint256 stakingShares;
1322         uint256 stakingShareSeconds;
1323         uint256 lastAccountingTimestampSec;
1324     }
1325 
1326     // Aggregated staking values per user
1327     mapping(address => UserTotals) private _userTotals;
1328 
1329     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
1330     mapping(address => Stake[]) private _userStakes;
1331 
1332     //
1333     // Locked/Unlocked Accounting state
1334     //
1335     struct UnlockSchedule {
1336         uint256 initialLockedShares;
1337         uint256 unlockedShares;
1338         uint256 lastUnlockTimestampSec;
1339         uint256 endAtSec;
1340         uint256 durationSec;
1341     }
1342 
1343     UnlockSchedule[] public unlockSchedules;
1344 
1345     /**
1346      * @param stakingToken The token users deposit as stake.
1347      * @param distributionToken The token users receive as they unstake.
1348      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
1349      * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.
1350      *                    e.g. 25% means user gets 25% of max distribution tokens.
1351      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
1352      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
1353      */
1354     constructor(
1355         IERC20 stakingToken,
1356         IERC20 distributionToken,
1357         GovTokenPool _govTokenPool,
1358         uint256 maxUnlockSchedules,
1359         uint256 startBonus_,
1360         uint256 bonusPeriodSec_,
1361         uint256 initialSharesPerToken,
1362         address referrerBook_
1363     ) public {
1364         // The start bonus must be some fraction of the max. (i.e. <= 100%)
1365         require(
1366             startBonus_ <= 10**BONUS_DECIMALS,
1367             "TokenGeyser: start bonus too high"
1368         );
1369         // If no period is desired, instead set startBonus = 100%
1370         // and bonusPeriod to a small value like 1sec.
1371         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
1372         require(
1373             initialSharesPerToken > 0,
1374             "TokenGeyser: initialSharesPerToken is zero"
1375         );
1376         require(
1377             referrerBook_ != address(0),
1378             "TokenGeyser: referrer book is zero"
1379         );
1380 
1381         require(
1382             address(_govTokenPool) != address(0),
1383             "TokenGeyser: govTokenPool is zero"
1384         );
1385 
1386         _stakingPool = new TokenPool(stakingToken);
1387         _unlockedPool = new TokenPool(distributionToken);
1388         _lockedPool = new TokenPool(distributionToken);
1389         govTokenPool = _govTokenPool;
1390         startBonus = startBonus_;
1391         bonusPeriodSec = bonusPeriodSec_;
1392         _maxUnlockSchedules = maxUnlockSchedules;
1393         _initialSharesPerToken = initialSharesPerToken;
1394 
1395         referrerBook = referrerBook_;
1396     }
1397 
1398     /**
1399      * @return The token users deposit as stake.
1400      */
1401     function getStakingToken() public view returns (IERC20) {
1402         return _stakingPool.token();
1403     }
1404 
1405     /**
1406      * @return The token users receive as they unstake.
1407      */
1408     function getDistributionToken() public view returns (IERC20) {
1409         assert(_unlockedPool.token() == _lockedPool.token());
1410         return _unlockedPool.token();
1411     }
1412 
1413     /**
1414      * @dev Transfers amount of deposit tokens from the user.
1415      * @param amount Number of deposit tokens to stake.
1416      * @param referrer User's Referrer
1417      */
1418     function stake(uint256 amount, address referrer) external override {
1419         _stakeFor(msg.sender, msg.sender, amount, referrer);
1420     }
1421 
1422     /**
1423      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
1424      * @param user User address who gains credit for this stake operation.
1425      * @param amount Number of deposit tokens to stake.
1426      * @param referrer User's Referrer
1427      */
1428     function stakeFor(
1429         address user,
1430         uint256 amount,
1431         address referrer
1432     ) external override onlyOwner {
1433         _stakeFor(msg.sender, user, amount, referrer);
1434     }
1435 
1436     /**
1437      * @dev Private implementation of staking methods.
1438      * @param staker User address who deposits tokens to stake.
1439      * @param beneficiary User address who gains credit for this stake operation.
1440      * @param amount Number of deposit tokens to stake.
1441      */
1442     function _stakeFor(
1443         address staker,
1444         address beneficiary,
1445         uint256 amount,
1446         address referrer
1447     ) private {
1448         require(amount > 0, "TokenGeyser: stake amount is zero");
1449         require(
1450             beneficiary != address(0),
1451             "TokenGeyser: beneficiary is zero address"
1452         );
1453         require(
1454             totalStakingShares == 0 || totalStaked() > 0,
1455             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
1456         );
1457 
1458         uint256 mintedStakingShares = (totalStakingShares > 0)
1459             ? totalStakingShares.mul(amount).div(totalStaked())
1460             : amount.mul(_initialSharesPerToken);
1461         require(
1462             mintedStakingShares > 0,
1463             "TokenGeyser: Stake amount is too small"
1464         );
1465 
1466         updateAccounting();
1467 
1468         govTokenPool.updateAndClaim(beneficiary, totalStakedFor(beneficiary), totalStaked());
1469 
1470         // 1. User Accounting
1471         UserTotals storage totals = _userTotals[beneficiary];
1472         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
1473         totals.lastAccountingTimestampSec = now;
1474 
1475         Stake memory newStake = Stake(mintedStakingShares, now);
1476         _userStakes[beneficiary].push(newStake);
1477 
1478         // 2. Global Accounting
1479         totalStakingShares = totalStakingShares.add(mintedStakingShares);
1480         // Already set in updateAccounting()
1481         // _lastAccountingTimestampSec = now;
1482 
1483         
1484         // interactions
1485         require(
1486             _stakingPool.token().transferFrom(
1487                 staker,
1488                 address(_stakingPool),
1489                 amount
1490             ),
1491             "TokenGeyser: transfer into staking pool failed"
1492         );
1493 
1494         govTokenPool.updateDebt(beneficiary, totalStakedFor(beneficiary));
1495 
1496         if (referrer != address(0) && referrer != staker) {
1497             IReferrerBook(referrerBook).affirmReferrer(staker, referrer);
1498         }
1499 
1500         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), referrer);
1501     }
1502 
1503     /**
1504      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
1505      * alotted number of distribution tokens.
1506      * @param amount Number of deposit tokens to unstake / withdraw.
1507      */
1508     function unstake(uint256 amount) external override{
1509         _unstake(amount);
1510     }
1511 
1512     /**
1513      * @param amount Number of deposit tokens to unstake / withdraw.
1514      * @return The total number of distribution tokens that would be rewarded.
1515      */
1516     function unstakeQuery(uint256 amount) public returns (uint256) {
1517         return _unstake(amount);
1518     }
1519 
1520     /**
1521      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
1522      * alotted number of distribution tokens.
1523      * @param amount Number of deposit tokens to unstake / withdraw.
1524      * @return The total number of distribution tokens rewarded.
1525      */
1526     function _unstake(uint256 amount) private returns (uint256) {
1527         updateAccounting();
1528 
1529         // checks
1530         require(amount > 0, "TokenGeyser: unstake amount is zero");
1531         require(
1532             totalStakedFor(msg.sender) >= amount,
1533             "TokenGeyser: unstake amount is greater than total user stakes"
1534         );
1535         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(
1536             totalStaked()
1537         );
1538         require(
1539             stakingSharesToBurn > 0,
1540             "TokenGeyser: Unable to unstake amount this small"
1541         );
1542 
1543         govTokenPool.updateAndClaim(msg.sender, totalStakedFor(msg.sender), totalStaked());
1544 
1545         // 1. User Accounting
1546         UserTotals storage totals = _userTotals[msg.sender];
1547         Stake[] storage accountStakes = _userStakes[msg.sender];
1548 
1549         // Redeem from most recent stake and go backwards in time.
1550         uint256 stakingShareSecondsToBurn = 0;
1551         uint256 sharesLeftToBurn = stakingSharesToBurn;
1552         uint256 rewardAmount = 0;
1553         while (sharesLeftToBurn > 0) {
1554             Stake storage lastStake = accountStakes[accountStakes.length - 1];
1555             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
1556             uint256 newStakingShareSecondsToBurn = 0;
1557             if (lastStake.stakingShares <= sharesLeftToBurn) {
1558                 // fully redeem a past stake
1559                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
1560                     stakeTimeSec
1561                 );
1562                 rewardAmount = computeNewReward(
1563                     rewardAmount,
1564                     newStakingShareSecondsToBurn,
1565                     stakeTimeSec
1566                 );
1567                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
1568                     newStakingShareSecondsToBurn
1569                 );
1570                 sharesLeftToBurn = sharesLeftToBurn.sub(
1571                     lastStake.stakingShares
1572                 );
1573                 accountStakes.pop();
1574             } else {
1575                 // partially redeem a past stake
1576                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
1577                     stakeTimeSec
1578                 );
1579                 rewardAmount = computeNewReward(
1580                     rewardAmount,
1581                     newStakingShareSecondsToBurn,
1582                     stakeTimeSec
1583                 );
1584                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
1585                     newStakingShareSecondsToBurn
1586                 );
1587                 lastStake.stakingShares = lastStake.stakingShares.sub(
1588                     sharesLeftToBurn
1589                 );
1590                 sharesLeftToBurn = 0;
1591             }
1592         }
1593         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
1594             stakingShareSecondsToBurn
1595         );
1596         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
1597         // Already set in updateAccounting
1598         // totals.lastAccountingTimestampSec = now;
1599 
1600         // 2. Global Accounting
1601         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
1602             stakingShareSecondsToBurn
1603         );
1604         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
1605         // Already set in updateAccounting
1606         // _lastAccountingTimestampSec = now;
1607         // interactions
1608         require(
1609             _stakingPool.transfer(msg.sender, amount),
1610             "TokenGeyser: transfer out of staking pool failed"
1611         );
1612 
1613         govTokenPool.updateDebt(msg.sender, totalStakedFor(msg.sender));
1614 
1615         uint256 userRewardAmount = _rewardUserAndReferrers(
1616             msg.sender,
1617             rewardAmount
1618         );
1619 
1620         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender));
1621         emit TokensClaimed(msg.sender, rewardAmount);
1622 
1623         require(
1624             totalStakingShares == 0 || totalStaked() > 0,
1625             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
1626         );
1627         return userRewardAmount;
1628     }
1629 
1630     function _rewardUserAndReferrers(address user, uint256 rewardAmount)
1631         private
1632         returns (uint256)
1633     {
1634         //0. reward user
1635         uint256 userAmount = rewardAmount.mul(USER_SHARE_PCT).div(10000);
1636         require(
1637             _unlockedPool.transfer(user, userAmount),
1638             "TokenGeyser: transfer out of unlocked pool failed(user)"
1639         );
1640 
1641         IReferrerBook refBook = IReferrerBook(referrerBook);
1642 
1643         //1. reward referrer
1644         uint256 amount = rewardAmount.mul(REF_SHARE_PCT).div(10000);
1645         address referrer = refBook.getUserReferrer(user);
1646         if (amount > 0 && referrer != address(0)) {
1647             _unlockedPool.transfer(referrer, amount);
1648         }
1649 
1650         //2. reward top node
1651         amount = rewardAmount.mul(NODE_SHARE_PCT).div(10000);
1652         address topNode = refBook.getUserTopNode(user);
1653         if (amount > 0 && topNode != address(0)) {
1654             _unlockedPool.transfer(topNode, amount);
1655         }
1656 
1657         return userAmount;
1658     }
1659 
1660     /**
1661      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
1662      *      encourage long-term deposits instead of constant unstake/restakes.
1663      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
1664      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
1665      * @param currentRewardTokens The current number of distribution tokens already alotted for this
1666      *                            unstake op. Any bonuses are already applied.
1667      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
1668      *                            distribution tokens.
1669      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
1670      *                     the time-bonus.
1671      * @return Updated amount of distribution tokens to award, with any bonus included on the
1672      *         newly added tokens.
1673      */
1674     function computeNewReward(
1675         uint256 currentRewardTokens,
1676         uint256 stakingShareSeconds,
1677         uint256 stakeTimeSec
1678     ) private view returns (uint256) {
1679         uint256 newRewardTokens = totalUnlocked().mul(stakingShareSeconds).div(
1680             _totalStakingShareSeconds
1681         );
1682 
1683         if (stakeTimeSec >= bonusPeriodSec) {
1684             return currentRewardTokens.add(newRewardTokens);
1685         }
1686 
1687         uint256 oneHundredPct = 10**BONUS_DECIMALS;
1688         uint256 bonusedReward = startBonus
1689             .add(
1690             oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec)
1691         )
1692             .mul(newRewardTokens)
1693             .div(oneHundredPct);
1694         return currentRewardTokens.add(bonusedReward);
1695     }
1696 
1697     /**
1698      * @param addr The user to look up staking information for.
1699      * @return The number of staking tokens deposited for addr.
1700      */
1701     function totalStakedFor(address addr) public override view returns (uint256) {
1702         return
1703             totalStakingShares > 0
1704                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
1705                     totalStakingShares
1706                 )
1707                 : 0;
1708     }
1709 
1710     /**
1711      * @return The total number of deposit tokens staked globally, by all users.
1712      */
1713     function totalStaked() public override view returns (uint256) {
1714         return _stakingPool.balance();
1715     }
1716 
1717     /**
1718      * @dev Note that this application has a staking token as well as a distribution token, which
1719      * may be different. This function is required by EIP-900.
1720      * @return The deposit token used for staking.
1721      */
1722     function token() external override view returns (address) {
1723         return address(getStakingToken());
1724     }
1725 
1726     /**
1727      * @dev A globally callable function to update the accounting state of the system.
1728      *      Global state and state for the caller are updated.
1729      * @return [0] balance of the locked pool
1730      * @return [1] balance of the unlocked pool
1731      * @return [2] caller's staking share seconds
1732      * @return [3] global staking share seconds
1733      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
1734      * @return [5] block timestamp
1735      */
1736     function updateAccounting()
1737         public
1738         returns (
1739             uint256,
1740             uint256,
1741             uint256,
1742             uint256,
1743             uint256,
1744             uint256
1745         )
1746     {
1747         unlockTokens();
1748 
1749         // Global accounting
1750         uint256 newStakingShareSeconds = now
1751             .sub(_lastAccountingTimestampSec)
1752             .mul(totalStakingShares);
1753         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
1754             newStakingShareSeconds
1755         );
1756         _lastAccountingTimestampSec = now;
1757 
1758         // User Accounting
1759         UserTotals storage totals = _userTotals[msg.sender];
1760         uint256 newUserStakingShareSeconds = now
1761             .sub(totals.lastAccountingTimestampSec)
1762             .mul(totals.stakingShares);
1763         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
1764             newUserStakingShareSeconds
1765         );
1766         totals.lastAccountingTimestampSec = now;
1767 
1768         uint256 totalUserRewards = (_totalStakingShareSeconds > 0)
1769             ? totalUnlocked().mul(totals.stakingShareSeconds).div(
1770                 _totalStakingShareSeconds
1771             )
1772             : 0;
1773 
1774         return (
1775             totalLocked(),
1776             totalUnlocked(),
1777             totals.stakingShareSeconds,
1778             _totalStakingShareSeconds,
1779             totalUserRewards,
1780             now
1781         );
1782     }
1783 
1784     /**
1785      * @return Total number of locked distribution tokens.
1786      */
1787     function totalLocked() public view returns (uint256) {
1788         return _lockedPool.balance();
1789     }
1790 
1791     /**
1792      * @return Total number of unlocked distribution tokens.
1793      */
1794     function totalUnlocked() public view returns (uint256) {
1795         return _unlockedPool.balance();
1796     }
1797 
1798     /**
1799      * @return Number of unlock schedules.
1800      */
1801     function unlockScheduleCount() public view returns (uint256) {
1802         return unlockSchedules.length;
1803     }
1804 
1805     /**
1806      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
1807      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
1808      *      linearly over the duraction of durationSec timeframe.
1809      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
1810      * @param durationSec Length of time to linear unlock the tokens.
1811      */
1812     function lockTokens(uint256 amount, uint256 durationSec)
1813         external
1814         onlyOwner
1815     {
1816         require(
1817             unlockSchedules.length < _maxUnlockSchedules,
1818             "TokenGeyser: reached maximum unlock schedules"
1819         );
1820 
1821         // Update lockedTokens amount before using it in computations after.
1822         updateAccounting();
1823 
1824         uint256 lockedTokens = totalLocked();
1825         uint256 mintedLockedShares = (lockedTokens > 0)
1826             ? totalLockedShares.mul(amount).div(lockedTokens)
1827             : amount.mul(_initialSharesPerToken);
1828 
1829         UnlockSchedule memory schedule;
1830         schedule.initialLockedShares = mintedLockedShares;
1831         schedule.lastUnlockTimestampSec = now;
1832         schedule.endAtSec = now.add(durationSec);
1833         schedule.durationSec = durationSec;
1834         unlockSchedules.push(schedule);
1835 
1836         totalLockedShares = totalLockedShares.add(mintedLockedShares);
1837 
1838         require(
1839             _lockedPool.token().transferFrom(
1840                 msg.sender,
1841                 address(_lockedPool),
1842                 amount
1843             ),
1844             "TokenGeyser: transfer into locked pool failed"
1845         );
1846         emit TokensLocked(amount, durationSec, totalLocked());
1847     }
1848 
1849     /**
1850      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
1851      *      previously defined unlock schedules. Publicly callable.
1852      * @return Number of newly unlocked distribution tokens.
1853      */
1854     function unlockTokens() public returns (uint256) {
1855         uint256 unlockedTokens = 0;
1856         uint256 lockedTokens = totalLocked();
1857 
1858         if (totalLockedShares == 0) {
1859             unlockedTokens = lockedTokens;
1860         } else {
1861             uint256 unlockedShares = 0;
1862             for (uint256 s = 0; s < unlockSchedules.length; s++) {
1863                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
1864             }
1865             unlockedTokens = unlockedShares.mul(lockedTokens).div(
1866                 totalLockedShares
1867             );
1868             totalLockedShares = totalLockedShares.sub(unlockedShares);
1869         }
1870 
1871         if (unlockedTokens > 0) {
1872             require(
1873                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
1874                 "TokenGeyser: transfer out of locked pool failed"
1875             );
1876             emit TokensUnlocked(unlockedTokens, totalLocked());
1877         }
1878 
1879         return unlockedTokens;
1880     }
1881 
1882     /**
1883      * @dev Returns the number of unlockable shares from a given schedule. The returned value
1884      *      depends on the time since the last unlock. This function updates schedule accounting,
1885      *      but does not actually transfer any tokens.
1886      * @param s Index of the unlock schedule.
1887      * @return The number of unlocked shares.
1888      */
1889     function unlockScheduleShares(uint256 s) private returns (uint256) {
1890         UnlockSchedule storage schedule = unlockSchedules[s];
1891 
1892         if (schedule.unlockedShares >= schedule.initialLockedShares) {
1893             return 0;
1894         }
1895 
1896         uint256 sharesToUnlock = 0;
1897         // Special case to handle any leftover dust from integer division
1898         if (now >= schedule.endAtSec) {
1899             sharesToUnlock = (
1900                 schedule.initialLockedShares.sub(schedule.unlockedShares)
1901             );
1902             schedule.lastUnlockTimestampSec = schedule.endAtSec;
1903         } else {
1904             sharesToUnlock = now
1905                 .sub(schedule.lastUnlockTimestampSec)
1906                 .mul(schedule.initialLockedShares)
1907                 .div(schedule.durationSec);
1908             schedule.lastUnlockTimestampSec = now;
1909         }
1910 
1911         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
1912         return sharesToUnlock;
1913     }
1914 
1915     /**
1916      * @dev Lets the owner rescue funds air-dropped to the staking pool.
1917      * @param tokenToRescue Address of the token to be rescued.
1918      * @param to Address to which the rescued funds are to be sent.
1919      * @param amount Amount of tokens to be rescued.
1920      * @return Transfer success.
1921      */
1922     function rescueFundsFromStakingPool(
1923         address tokenToRescue,
1924         address to,
1925         uint256 amount
1926     ) public onlyOwner returns (bool) {
1927         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
1928     }
1929 
1930     function setReferrerBook(address referrerBook_) external onlyOwner {
1931         require(referrerBook_ != address(0), "referrerBook == 0");
1932         referrerBook = referrerBook_;
1933     }
1934 
1935     function claimGovToken() external {
1936         address beneficiary = msg.sender;
1937         govTokenPool.updateAndClaim(beneficiary,  totalStakedFor(beneficiary), totalStaked());
1938         govTokenPool.updateDebt(beneficiary,  totalStakedFor(beneficiary));
1939     }
1940 
1941     function pendingGovToken(address _user) external view returns(uint256) {
1942         return govTokenPool.pendingReward(address(this), totalStakedFor(_user), _user);
1943     }
1944 
1945     function updateGovTokenPool() external {
1946         govTokenPool.updatePool(totalStaked());
1947     }
1948 }