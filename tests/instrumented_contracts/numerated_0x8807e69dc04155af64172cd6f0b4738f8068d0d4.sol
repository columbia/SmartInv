1 /*
2  _____ ______   _______  _________  ________     
3 |\   _ \  _   \|\  ___ \|\___   ___\\   __  \    
4 \ \  \\\__\ \  \ \   __/\|___ \  \_\ \  \|\  \   
5  \ \  \\|__| \  \ \  \_|/__  \ \  \ \ \   __  \  
6   \ \  \    \ \  \ \  \_|\ \  \ \  \ \ \  \ \  \ 
7    \ \__\    \ \__\ \_______\  \ \__\ \ \__\ \__\
8     \|__|     \|__|\|_______|   \|__|  \|__|\|__|
9 */
10 // File: @openzeppelin/contracts/GSN/Context.sol
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity >=0.6.0 <0.8.0;
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
38 
39 
40 pragma solidity >=0.6.0 <0.8.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: @openzeppelin/contracts/math/SafeMath.sol
117 
118 
119 pragma solidity >=0.6.0 <0.8.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
235     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
278 
279 
280 pragma solidity >=0.6.0 <0.8.0;
281 
282 
283 
284 
285 /**
286  * @dev Implementation of the {IERC20} interface.
287  *
288  * This implementation is agnostic to the way tokens are created. This means
289  * that a supply mechanism has to be added in a derived contract using {_mint}.
290  * For a generic mechanism see {ERC20PresetMinterPauser}.
291  *
292  * TIP: For a detailed writeup see our guide
293  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
294  * to implement supply mechanisms].
295  *
296  * We have followed general OpenZeppelin guidelines: functions revert instead
297  * of returning `false` on failure. This behavior is nonetheless conventional
298  * and does not conflict with the expectations of ERC20 applications.
299  *
300  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
301  * This allows applications to reconstruct the allowance for all accounts just
302  * by listening to said events. Other implementations of the EIP may not emit
303  * these events, as it isn't required by the specification.
304  *
305  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
306  * functions have been added to mitigate the well-known issues around setting
307  * allowances. See {IERC20-approve}.
308  */
309 contract ERC20 is Context, IERC20 {
310     using SafeMath for uint256;
311 
312     mapping (address => uint256) private _balances;
313 
314     mapping (address => mapping (address => uint256)) private _allowances;
315 
316     uint256 private _totalSupply;
317 
318     string private _name;
319     string private _symbol;
320     uint8 private _decimals;
321 
322     /**
323      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
324      * a default value of 18.
325      *
326      * To select a different value for {decimals}, use {_setupDecimals}.
327      *
328      * All three of these values are immutable: they can only be set once during
329      * construction.
330      */
331     constructor (string memory name_, string memory symbol_) public {
332         _name = name_;
333         _symbol = symbol_;
334         _decimals = 18;
335     }
336 
337     /**
338      * @dev Returns the name of the token.
339      */
340     function name() public view returns (string memory) {
341         return _name;
342     }
343 
344     /**
345      * @dev Returns the symbol of the token, usually a shorter version of the
346      * name.
347      */
348     function symbol() public view returns (string memory) {
349         return _symbol;
350     }
351 
352     /**
353      * @dev Returns the number of decimals used to get its user representation.
354      * For example, if `decimals` equals `2`, a balance of `505` tokens should
355      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
356      *
357      * Tokens usually opt for a value of 18, imitating the relationship between
358      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
359      * called.
360      *
361      * NOTE: This information is only used for _display_ purposes: it in
362      * no way affects any of the arithmetic of the contract, including
363      * {IERC20-balanceOf} and {IERC20-transfer}.
364      */
365     function decimals() public view returns (uint8) {
366         return _decimals;
367     }
368 
369     /**
370      * @dev See {IERC20-totalSupply}.
371      */
372     function totalSupply() public view override returns (uint256) {
373         return _totalSupply;
374     }
375 
376     /**
377      * @dev See {IERC20-balanceOf}.
378      */
379     function balanceOf(address account) public view override returns (uint256) {
380         return _balances[account];
381     }
382 
383     /**
384      * @dev See {IERC20-transfer}.
385      *
386      * Requirements:
387      *
388      * - `recipient` cannot be the zero address.
389      * - the caller must have a balance of at least `amount`.
390      */
391     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
392         _transfer(_msgSender(), recipient, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-allowance}.
398      */
399     function allowance(address owner, address spender) public view virtual override returns (uint256) {
400         return _allowances[owner][spender];
401     }
402 
403     /**
404      * @dev See {IERC20-approve}.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function approve(address spender, uint256 amount) public virtual override returns (bool) {
411         _approve(_msgSender(), spender, amount);
412         return true;
413     }
414 
415     /**
416      * @dev See {IERC20-transferFrom}.
417      *
418      * Emits an {Approval} event indicating the updated allowance. This is not
419      * required by the EIP. See the note at the beginning of {ERC20}.
420      *
421      * Requirements:
422      *
423      * - `sender` and `recipient` cannot be the zero address.
424      * - `sender` must have a balance of at least `amount`.
425      * - the caller must have allowance for ``sender``'s tokens of at least
426      * `amount`.
427      */
428     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
429         _transfer(sender, recipient, amount);
430         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
431         return true;
432     }
433 
434     /**
435      * @dev Atomically increases the allowance granted to `spender` by the caller.
436      *
437      * This is an alternative to {approve} that can be used as a mitigation for
438      * problems described in {IERC20-approve}.
439      *
440      * Emits an {Approval} event indicating the updated allowance.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
447         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
448         return true;
449     }
450 
451     /**
452      * @dev Atomically decreases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      * - `spender` must have allowance for the caller of at least
463      * `subtractedValue`.
464      */
465     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
466         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
467         return true;
468     }
469 
470     /**
471      * @dev Moves tokens `amount` from `sender` to `recipient`.
472      *
473      * This is internal function is equivalent to {transfer}, and can be used to
474      * e.g. implement automatic token fees, slashing mechanisms, etc.
475      *
476      * Emits a {Transfer} event.
477      *
478      * Requirements:
479      *
480      * - `sender` cannot be the zero address.
481      * - `recipient` cannot be the zero address.
482      * - `sender` must have a balance of at least `amount`.
483      */
484     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
485         require(sender != address(0), "ERC20: transfer from the zero address");
486         require(recipient != address(0), "ERC20: transfer to the zero address");
487 
488         _beforeTokenTransfer(sender, recipient, amount);
489 
490         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
491         _balances[recipient] = _balances[recipient].add(amount);
492         emit Transfer(sender, recipient, amount);
493     }
494 
495     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
496      * the total supply.
497      *
498      * Emits a {Transfer} event with `from` set to the zero address.
499      *
500      * Requirements:
501      *
502      * - `to` cannot be the zero address.
503      */
504     function _mint(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: mint to the zero address");
506 
507         _beforeTokenTransfer(address(0), account, amount);
508 
509         _totalSupply = _totalSupply.add(amount);
510         _balances[account] = _balances[account].add(amount);
511         emit Transfer(address(0), account, amount);
512     }
513 
514     /**
515      * @dev Destroys `amount` tokens from `account`, reducing the
516      * total supply.
517      *
518      * Emits a {Transfer} event with `to` set to the zero address.
519      *
520      * Requirements:
521      *
522      * - `account` cannot be the zero address.
523      * - `account` must have at least `amount` tokens.
524      */
525     function _burn(address account, uint256 amount) internal virtual {
526         require(account != address(0), "ERC20: burn from the zero address");
527 
528         _beforeTokenTransfer(account, address(0), amount);
529 
530         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
531         _totalSupply = _totalSupply.sub(amount);
532         emit Transfer(account, address(0), amount);
533     }
534 
535     /**
536      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
537      *
538      * This internal function is equivalent to `approve`, and can be used to
539      * e.g. set automatic allowances for certain subsystems, etc.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `owner` cannot be the zero address.
546      * - `spender` cannot be the zero address.
547      */
548     function _approve(address owner, address spender, uint256 amount) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Sets {decimals} to a value other than the default one of 18.
558      *
559      * WARNING: This function should only be called from the constructor. Most
560      * applications that interact with token contracts will not expect
561      * {decimals} to ever change, and may work incorrectly if it does.
562      */
563     function _setupDecimals(uint8 decimals_) internal {
564         _decimals = decimals_;
565     }
566 
567     /**
568      * @dev Hook that is called before any transfer of tokens. This includes
569      * minting and burning.
570      *
571      * Calling conditions:
572      *
573      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
574      * will be to transferred to `to`.
575      * - when `from` is zero, `amount` tokens will be minted for `to`.
576      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
577      * - `from` and `to` are never both zero.
578      *
579      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
580      */
581     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
585 
586 
587 pragma solidity >=0.6.0 <0.8.0;
588 
589 
590 
591 /**
592  * @dev Extension of {ERC20} that allows token holders to destroy both their own
593  * tokens and those that they have an allowance for, in a way that can be
594  * recognized off-chain (via event analysis).
595  */
596 abstract contract ERC20Burnable is Context, ERC20 {
597     using SafeMath for uint256;
598 
599     /**
600      * @dev Destroys `amount` tokens from the caller.
601      *
602      * See {ERC20-_burn}.
603      */
604     function burn(uint256 amount) public virtual {
605         _burn(_msgSender(), amount);
606     }
607 
608     /**
609      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
610      * allowance.
611      *
612      * See {ERC20-_burn} and {ERC20-allowance}.
613      *
614      * Requirements:
615      *
616      * - the caller must have allowance for ``accounts``'s tokens of at least
617      * `amount`.
618      */
619     function burnFrom(address account, uint256 amount) public virtual {
620         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
621 
622         _approve(account, _msgSender(), decreasedAllowance);
623         _burn(account, amount);
624     }
625 }
626 
627 // File: @openzeppelin/contracts/access/Ownable.sol
628 
629 
630 pragma solidity >=0.6.0 <0.8.0;
631 
632 /**
633  * @dev Contract module which provides a basic access control mechanism, where
634  * there is an account (an owner) that can be granted exclusive access to
635  * specific functions.
636  *
637  * By default, the owner account will be the one that deploys the contract. This
638  * can later be changed with {transferOwnership}.
639  *
640  * This module is used through inheritance. It will make available the modifier
641  * `onlyOwner`, which can be applied to your functions to restrict their use to
642  * the owner.
643  */
644 abstract contract Ownable is Context {
645     address private _owner;
646 
647     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
648 
649     /**
650      * @dev Initializes the contract setting the deployer as the initial owner.
651      */
652     constructor () internal {
653         address msgSender = _msgSender();
654         _owner = msgSender;
655         emit OwnershipTransferred(address(0), msgSender);
656     }
657 
658     /**
659      * @dev Returns the address of the current owner.
660      */
661     function owner() public view returns (address) {
662         return _owner;
663     }
664 
665     /**
666      * @dev Throws if called by any account other than the owner.
667      */
668     modifier onlyOwner() {
669         require(_owner == _msgSender(), "Ownable: caller is not the owner");
670         _;
671     }
672 
673     /**
674      * @dev Leaves the contract without owner. It will not be possible to call
675      * `onlyOwner` functions anymore. Can only be called by the current owner.
676      *
677      * NOTE: Renouncing ownership will leave the contract without an owner,
678      * thereby removing any functionality that is only available to the owner.
679      */
680     function renounceOwnership() public virtual onlyOwner {
681         emit OwnershipTransferred(_owner, address(0));
682         _owner = address(0);
683     }
684 
685     /**
686      * @dev Transfers ownership of the contract to a new account (`newOwner`).
687      * Can only be called by the current owner.
688      */
689     function transferOwnership(address newOwner) public virtual onlyOwner {
690         require(newOwner != address(0), "Ownable: new owner is the zero address");
691         emit OwnershipTransferred(_owner, newOwner);
692         _owner = newOwner;
693     }
694 }
695 
696 // File: @openzeppelin/contracts/utils/Counters.sol
697 
698 
699 pragma solidity >=0.6.0 <0.8.0;
700 
701 
702 /**
703  * @title Counters
704  * @author Matt Condon (@shrugs)
705  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
706  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
707  *
708  * Include with `using Counters for Counters.Counter;`
709  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
710  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
711  * directly accessed.
712  */
713 library Counters {
714     using SafeMath for uint256;
715 
716     struct Counter {
717         // This variable should never be directly accessed by users of the library: interactions must be restricted to
718         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
719         // this feature: see https://github.com/ethereum/solidity/issues/4637
720         uint256 _value; // default: 0
721     }
722 
723     function current(Counter storage counter) internal view returns (uint256) {
724         return counter._value;
725     }
726 
727     function increment(Counter storage counter) internal {
728         // The {SafeMath} overflow check can be skipped here, see the comment at the top
729         counter._value += 1;
730     }
731 
732     function decrement(Counter storage counter) internal {
733         counter._value = counter._value.sub(1);
734     }
735 }
736 
737 // File: contracts/IERC20Permit.sol
738 
739 
740 pragma solidity ^0.6.0;
741 
742 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/IERC20Permit.sol
743 
744 /**
745  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
746  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
747  *
748  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
749  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
750  * need to send a transaction, and thus is not required to hold Ether at all.
751  */
752 interface IERC20Permit {
753     /**
754      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
755      * given `owner`'s signed approval.
756      *
757      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
758      * ordering also apply here.
759      *
760      * Emits an {Approval} event.
761      *
762      * Requirements:
763      *
764      * - `spender` cannot be the zero address.
765      * - `deadline` must be a timestamp in the future.
766      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
767      * over the EIP712-formatted function arguments.
768      * - the signature must use ``owner``'s current nonce (see {nonces}).
769      *
770      * For more information on the signature format, see the
771      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
772      * section].
773      */
774     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
775 
776     /**
777      * @dev Returns the current nonce for `owner`. This value must be
778      * included whenever a signature is generated for {permit}.
779      *
780      * Every successful call to {permit} increases ``owner``'s nonce by one. This
781      * prevents a signature from being used multiple times.
782      */
783     function nonces(address owner) external view returns (uint256);
784 
785     /**
786      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
787      */
788     // solhint-disable-next-line func-name-mixedcase
789     function DOMAIN_SEPARATOR() external view returns (bytes32);
790 }
791 
792 // File: contracts/ECDSA.sol
793 
794 
795 pragma solidity ^0.6.0;
796 
797 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/cryptography/ECDSA.sol
798 
799 /**
800  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
801  *
802  * These functions can be used to verify that a message was signed by the holder
803  * of the private keys of a given address.
804  */
805 library ECDSA {
806     /**
807      * @dev Returns the address that signed a hashed message (`hash`) with
808      * `signature`. This address can then be used for verification purposes.
809      *
810      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
811      * this function rejects them by requiring the `s` value to be in the lower
812      * half order, and the `v` value to be either 27 or 28.
813      *
814      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
815      * verification to be secure: it is possible to craft signatures that
816      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
817      * this is by receiving a hash of the original message (which may otherwise
818      * be too long), and then calling {toEthSignedMessageHash} on it.
819      */
820     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
821         // Check the signature length
822         if (signature.length != 65) {
823             revert("ECDSA: invalid signature length");
824         }
825 
826         // Divide the signature in r, s and v variables
827         bytes32 r;
828         bytes32 s;
829         uint8 v;
830 
831         // ecrecover takes the signature parameters, and the only way to get them
832         // currently is to use assembly.
833         // solhint-disable-next-line no-inline-assembly
834         assembly {
835             r := mload(add(signature, 0x20))
836             s := mload(add(signature, 0x40))
837             v := byte(0, mload(add(signature, 0x60)))
838         }
839 
840         return recover(hash, v, r, s);
841     }
842 
843     /**
844      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
845      * `r` and `s` signature fields separately.
846      */
847     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
848         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
849         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
850         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
851         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
852         //
853         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
854         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
855         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
856         // these malleable signatures as well.
857         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature s value");
858         require(v == 27 || v == 28, "ECDSA: invalid signature v value");
859 
860         // If the signature is valid (and not malleable), return the signer address
861         address signer = ecrecover(hash, v, r, s);
862         require(signer != address(0), "ECDSA: invalid signature");
863 
864         return signer;
865     }
866 
867     /**
868      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
869      * replicates the behavior of the
870      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
871      * JSON-RPC method.
872      *
873      * See {recover}.
874      */
875     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
876         // 32 is the length in bytes of hash,
877         // enforced by the type signature above
878         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
879     }
880 }
881 
882 // File: contracts/EIP712.sol
883 
884 
885 pragma solidity ^0.6.0;
886 
887 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/EIP712.sol
888 
889 /**
890  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
891  *
892  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
893  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
894  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
895  *
896  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
897  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
898  * ({_hashTypedDataV4}).
899  *
900  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
901  * the chain id to protect against replay attacks on an eventual fork of the chain.
902  *
903  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
904  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
905  */
906 abstract contract EIP712 {
907     /* solhint-disable var-name-mixedcase */
908     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
909     // invalidate the cached domain separator if the chain id changes.
910     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
911     uint256 private immutable _CACHED_CHAIN_ID;
912 
913     bytes32 private immutable _HASHED_NAME;
914     bytes32 private immutable _HASHED_VERSION;
915     bytes32 private immutable _TYPE_HASH;
916     /* solhint-enable var-name-mixedcase */
917 
918     /**
919      * @dev Initializes the domain separator and parameter caches.
920      *
921      * The meaning of `name` and `version` is specified in
922      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
923      *
924      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
925      * - `version`: the current major version of the signing domain.
926      *
927      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
928      * contract upgrade].
929      */
930     constructor(string memory name, string memory version) internal {
931         bytes32 hashedName = keccak256(bytes(name));
932         bytes32 hashedVersion = keccak256(bytes(version));
933         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
934         _HASHED_NAME = hashedName;
935         _HASHED_VERSION = hashedVersion;
936         _CACHED_CHAIN_ID = _getChainId();
937         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
938         _TYPE_HASH = typeHash;
939     }
940 
941     /**
942      * @dev Returns the domain separator for the current chain.
943      */
944     function _domainSeparatorV4() internal view returns (bytes32) {
945         if (_getChainId() == _CACHED_CHAIN_ID) {
946             return _CACHED_DOMAIN_SEPARATOR;
947         } else {
948             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
949         }
950     }
951 
952     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
953         return keccak256(
954             abi.encode(
955                 typeHash,
956                 name,
957                 version,
958                 _getChainId(),
959                 address(this)
960             )
961         );
962     }
963 
964     /**
965      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
966      * function returns the hash of the fully encoded EIP712 message for this domain.
967      *
968      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
969      *
970      * ```solidity
971      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
972      *     keccak256("Mail(address to,string contents)"),
973      *     mailTo,
974      *     keccak256(bytes(mailContents))
975      * )));
976      * address signer = ECDSA.recover(digest, signature);
977      * ```
978      */
979     function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
980         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
981     }
982 
983     function _getChainId() private pure returns (uint256 chainId) {
984         // solhint-disable-next-line no-inline-assembly
985         assembly {
986             chainId := chainid()
987         }
988     }
989 }
990 
991 // File: contracts/ERC20Permit.sol
992 
993 
994 pragma solidity ^0.6.0;
995 
996 
997 
998 
999 
1000 
1001 // An adapted copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/ERC20Permit.sol
1002 
1003 /**
1004  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1005  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1006  *
1007  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1008  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1009  * need to send a transaction, and thus is not required to hold Ether at all.
1010  */
1011 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1012     using Counters for Counters.Counter;
1013 
1014     mapping (address => Counters.Counter) private _nonces;
1015 
1016     // solhint-disable-next-line var-name-mixedcase
1017     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1018 
1019     /**
1020      * @dev See {IERC20Permit-permit}.
1021      */
1022     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1023         // solhint-disable-next-line not-rely-on-time
1024         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1025 
1026         bytes32 structHash = keccak256(
1027             abi.encode(
1028                 _PERMIT_TYPEHASH,
1029                 owner,
1030                 spender,
1031                 value,
1032                 _nonces[owner].current(),
1033                 deadline
1034             )
1035         );
1036 
1037         bytes32 hash = _hashTypedDataV4(structHash);
1038 
1039         address signer = ECDSA.recover(hash, v, r, s);
1040         require(signer == owner, "ERC20Permit: invalid signature");
1041 
1042         _nonces[owner].increment();
1043         _approve(owner, spender, value);
1044     }
1045 
1046     /**
1047      * @dev See {IERC20Permit-nonces}.
1048      */
1049     function nonces(address owner) public view override returns (uint256) {
1050         return _nonces[owner].current();
1051     }
1052 
1053     /**
1054      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1055      */
1056     // solhint-disable-next-line func-name-mixedcase
1057     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1058         return _domainSeparatorV4();
1059     }
1060 }
1061 
1062 // File: contracts/Meta.sol
1063 
1064 
1065 pragma solidity ^0.6.0;
1066 
1067 
1068 
1069 contract Meta is ERC20Permit, ERC20Burnable, Ownable {
1070     constructor() public ERC20("Meta Network", "Meta") EIP712("Meta Network", "1") {
1071         _mint(_msgSender(), 210000 ether);
1072     }
1073 
1074     function mint(address to, uint256 amount) external onlyOwner {
1075         _mint(to, amount);
1076     }
1077 }