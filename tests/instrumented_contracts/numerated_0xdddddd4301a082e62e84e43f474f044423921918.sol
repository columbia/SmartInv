1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
269 
270 
271 pragma solidity >=0.6.0 <0.8.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20PresetMinterPauser}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     string private _name;
310     string private _symbol;
311     uint8 private _decimals;
312 
313     /**
314      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
315      * a default value of 18.
316      *
317      * To select a different value for {decimals}, use {_setupDecimals}.
318      *
319      * All three of these values are immutable: they can only be set once during
320      * construction.
321      */
322     constructor (string memory name_, string memory symbol_) public {
323         _name = name_;
324         _symbol = symbol_;
325         _decimals = 18;
326     }
327 
328     /**
329      * @dev Returns the name of the token.
330      */
331     function name() public view returns (string memory) {
332         return _name;
333     }
334 
335     /**
336      * @dev Returns the symbol of the token, usually a shorter version of the
337      * name.
338      */
339     function symbol() public view returns (string memory) {
340         return _symbol;
341     }
342 
343     /**
344      * @dev Returns the number of decimals used to get its user representation.
345      * For example, if `decimals` equals `2`, a balance of `505` tokens should
346      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
347      *
348      * Tokens usually opt for a value of 18, imitating the relationship between
349      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
350      * called.
351      *
352      * NOTE: This information is only used for _display_ purposes: it in
353      * no way affects any of the arithmetic of the contract, including
354      * {IERC20-balanceOf} and {IERC20-transfer}.
355      */
356     function decimals() public view returns (uint8) {
357         return _decimals;
358     }
359 
360     /**
361      * @dev See {IERC20-totalSupply}.
362      */
363     function totalSupply() public view override returns (uint256) {
364         return _totalSupply;
365     }
366 
367     /**
368      * @dev See {IERC20-balanceOf}.
369      */
370     function balanceOf(address account) public view override returns (uint256) {
371         return _balances[account];
372     }
373 
374     /**
375      * @dev See {IERC20-transfer}.
376      *
377      * Requirements:
378      *
379      * - `recipient` cannot be the zero address.
380      * - the caller must have a balance of at least `amount`.
381      */
382     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
383         _transfer(_msgSender(), recipient, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-allowance}.
389      */
390     function allowance(address owner, address spender) public view virtual override returns (uint256) {
391         return _allowances[owner][spender];
392     }
393 
394     /**
395      * @dev See {IERC20-approve}.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function approve(address spender, uint256 amount) public virtual override returns (bool) {
402         _approve(_msgSender(), spender, amount);
403         return true;
404     }
405 
406     /**
407      * @dev See {IERC20-transferFrom}.
408      *
409      * Emits an {Approval} event indicating the updated allowance. This is not
410      * required by the EIP. See the note at the beginning of {ERC20}.
411      *
412      * Requirements:
413      *
414      * - `sender` and `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      * - the caller must have allowance for ``sender``'s tokens of at least
417      * `amount`.
418      */
419     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
420         _transfer(sender, recipient, amount);
421         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
439         return true;
440     }
441 
442     /**
443      * @dev Atomically decreases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      * - `spender` must have allowance for the caller of at least
454      * `subtractedValue`.
455      */
456     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
457         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
458         return true;
459     }
460 
461     /**
462      * @dev Moves tokens `amount` from `sender` to `recipient`.
463      *
464      * This is internal function is equivalent to {transfer}, and can be used to
465      * e.g. implement automatic token fees, slashing mechanisms, etc.
466      *
467      * Emits a {Transfer} event.
468      *
469      * Requirements:
470      *
471      * - `sender` cannot be the zero address.
472      * - `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      */
475     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
476         require(sender != address(0), "ERC20: transfer from the zero address");
477         require(recipient != address(0), "ERC20: transfer to the zero address");
478 
479         _beforeTokenTransfer(sender, recipient, amount);
480 
481         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
482         _balances[recipient] = _balances[recipient].add(amount);
483         emit Transfer(sender, recipient, amount);
484     }
485 
486     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
487      * the total supply.
488      *
489      * Emits a {Transfer} event with `from` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `to` cannot be the zero address.
494      */
495     function _mint(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: mint to the zero address");
497 
498         _beforeTokenTransfer(address(0), account, amount);
499 
500         _totalSupply = _totalSupply.add(amount);
501         _balances[account] = _balances[account].add(amount);
502         emit Transfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
522         _totalSupply = _totalSupply.sub(amount);
523         emit Transfer(account, address(0), amount);
524     }
525 
526     /**
527      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
528      *
529      * This internal function is equivalent to `approve`, and can be used to
530      * e.g. set automatic allowances for certain subsystems, etc.
531      *
532      * Emits an {Approval} event.
533      *
534      * Requirements:
535      *
536      * - `owner` cannot be the zero address.
537      * - `spender` cannot be the zero address.
538      */
539     function _approve(address owner, address spender, uint256 amount) internal virtual {
540         require(owner != address(0), "ERC20: approve from the zero address");
541         require(spender != address(0), "ERC20: approve to the zero address");
542 
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547     /**
548      * @dev Sets {decimals} to a value other than the default one of 18.
549      *
550      * WARNING: This function should only be called from the constructor. Most
551      * applications that interact with token contracts will not expect
552      * {decimals} to ever change, and may work incorrectly if it does.
553      */
554     function _setupDecimals(uint8 decimals_) internal {
555         _decimals = decimals_;
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be to transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
576 
577 
578 pragma solidity >=0.6.0 <0.8.0;
579 
580 
581 
582 /**
583  * @dev Extension of {ERC20} that allows token holders to destroy both their own
584  * tokens and those that they have an allowance for, in a way that can be
585  * recognized off-chain (via event analysis).
586  */
587 abstract contract ERC20Burnable is Context, ERC20 {
588     using SafeMath for uint256;
589 
590     /**
591      * @dev Destroys `amount` tokens from the caller.
592      *
593      * See {ERC20-_burn}.
594      */
595     function burn(uint256 amount) public virtual {
596         _burn(_msgSender(), amount);
597     }
598 
599     /**
600      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
601      * allowance.
602      *
603      * See {ERC20-_burn} and {ERC20-allowance}.
604      *
605      * Requirements:
606      *
607      * - the caller must have allowance for ``accounts``'s tokens of at least
608      * `amount`.
609      */
610     function burnFrom(address account, uint256 amount) public virtual {
611         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
612 
613         _approve(account, _msgSender(), decreasedAllowance);
614         _burn(account, amount);
615     }
616 }
617 
618 // File: @openzeppelin/contracts/access/Ownable.sol
619 
620 
621 pragma solidity >=0.6.0 <0.8.0;
622 
623 /**
624  * @dev Contract module which provides a basic access control mechanism, where
625  * there is an account (an owner) that can be granted exclusive access to
626  * specific functions.
627  *
628  * By default, the owner account will be the one that deploys the contract. This
629  * can later be changed with {transferOwnership}.
630  *
631  * This module is used through inheritance. It will make available the modifier
632  * `onlyOwner`, which can be applied to your functions to restrict their use to
633  * the owner.
634  */
635 abstract contract Ownable is Context {
636     address private _owner;
637 
638     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
639 
640     /**
641      * @dev Initializes the contract setting the deployer as the initial owner.
642      */
643     constructor () internal {
644         address msgSender = _msgSender();
645         _owner = msgSender;
646         emit OwnershipTransferred(address(0), msgSender);
647     }
648 
649     /**
650      * @dev Returns the address of the current owner.
651      */
652     function owner() public view returns (address) {
653         return _owner;
654     }
655 
656     /**
657      * @dev Throws if called by any account other than the owner.
658      */
659     modifier onlyOwner() {
660         require(_owner == _msgSender(), "Ownable: caller is not the owner");
661         _;
662     }
663 
664     /**
665      * @dev Leaves the contract without owner. It will not be possible to call
666      * `onlyOwner` functions anymore. Can only be called by the current owner.
667      *
668      * NOTE: Renouncing ownership will leave the contract without an owner,
669      * thereby removing any functionality that is only available to the owner.
670      */
671     function renounceOwnership() public virtual onlyOwner {
672         emit OwnershipTransferred(_owner, address(0));
673         _owner = address(0);
674     }
675 
676     /**
677      * @dev Transfers ownership of the contract to a new account (`newOwner`).
678      * Can only be called by the current owner.
679      */
680     function transferOwnership(address newOwner) public virtual onlyOwner {
681         require(newOwner != address(0), "Ownable: new owner is the zero address");
682         emit OwnershipTransferred(_owner, newOwner);
683         _owner = newOwner;
684     }
685 }
686 
687 // File: @openzeppelin/contracts/utils/Counters.sol
688 
689 
690 pragma solidity >=0.6.0 <0.8.0;
691 
692 
693 /**
694  * @title Counters
695  * @author Matt Condon (@shrugs)
696  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
697  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
698  *
699  * Include with `using Counters for Counters.Counter;`
700  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
701  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
702  * directly accessed.
703  */
704 library Counters {
705     using SafeMath for uint256;
706 
707     struct Counter {
708         // This variable should never be directly accessed by users of the library: interactions must be restricted to
709         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
710         // this feature: see https://github.com/ethereum/solidity/issues/4637
711         uint256 _value; // default: 0
712     }
713 
714     function current(Counter storage counter) internal view returns (uint256) {
715         return counter._value;
716     }
717 
718     function increment(Counter storage counter) internal {
719         // The {SafeMath} overflow check can be skipped here, see the comment at the top
720         counter._value += 1;
721     }
722 
723     function decrement(Counter storage counter) internal {
724         counter._value = counter._value.sub(1);
725     }
726 }
727 
728 // File: contracts/IERC20Permit.sol
729 
730 
731 pragma solidity ^0.6.0;
732 
733 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/IERC20Permit.sol
734 
735 /**
736  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
737  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
738  *
739  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
740  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
741  * need to send a transaction, and thus is not required to hold Ether at all.
742  */
743 interface IERC20Permit {
744     /**
745      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
746      * given `owner`'s signed approval.
747      *
748      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
749      * ordering also apply here.
750      *
751      * Emits an {Approval} event.
752      *
753      * Requirements:
754      *
755      * - `spender` cannot be the zero address.
756      * - `deadline` must be a timestamp in the future.
757      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
758      * over the EIP712-formatted function arguments.
759      * - the signature must use ``owner``'s current nonce (see {nonces}).
760      *
761      * For more information on the signature format, see the
762      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
763      * section].
764      */
765     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
766 
767     /**
768      * @dev Returns the current nonce for `owner`. This value must be
769      * included whenever a signature is generated for {permit}.
770      *
771      * Every successful call to {permit} increases ``owner``'s nonce by one. This
772      * prevents a signature from being used multiple times.
773      */
774     function nonces(address owner) external view returns (uint256);
775 
776     /**
777      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
778      */
779     // solhint-disable-next-line func-name-mixedcase
780     function DOMAIN_SEPARATOR() external view returns (bytes32);
781 }
782 
783 // File: contracts/ECDSA.sol
784 
785 
786 pragma solidity ^0.6.0;
787 
788 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/cryptography/ECDSA.sol
789 
790 /**
791  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
792  *
793  * These functions can be used to verify that a message was signed by the holder
794  * of the private keys of a given address.
795  */
796 library ECDSA {
797     /**
798      * @dev Returns the address that signed a hashed message (`hash`) with
799      * `signature`. This address can then be used for verification purposes.
800      *
801      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
802      * this function rejects them by requiring the `s` value to be in the lower
803      * half order, and the `v` value to be either 27 or 28.
804      *
805      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
806      * verification to be secure: it is possible to craft signatures that
807      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
808      * this is by receiving a hash of the original message (which may otherwise
809      * be too long), and then calling {toEthSignedMessageHash} on it.
810      */
811     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
812         // Check the signature length
813         if (signature.length != 65) {
814             revert("ECDSA: invalid signature length");
815         }
816 
817         // Divide the signature in r, s and v variables
818         bytes32 r;
819         bytes32 s;
820         uint8 v;
821 
822         // ecrecover takes the signature parameters, and the only way to get them
823         // currently is to use assembly.
824         // solhint-disable-next-line no-inline-assembly
825         assembly {
826             r := mload(add(signature, 0x20))
827             s := mload(add(signature, 0x40))
828             v := byte(0, mload(add(signature, 0x60)))
829         }
830 
831         return recover(hash, v, r, s);
832     }
833 
834     /**
835      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
836      * `r` and `s` signature fields separately.
837      */
838     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
839         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
840         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
841         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
842         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
843         //
844         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
845         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
846         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
847         // these malleable signatures as well.
848         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature s value");
849         require(v == 27 || v == 28, "ECDSA: invalid signature v value");
850 
851         // If the signature is valid (and not malleable), return the signer address
852         address signer = ecrecover(hash, v, r, s);
853         require(signer != address(0), "ECDSA: invalid signature");
854 
855         return signer;
856     }
857 
858     /**
859      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
860      * replicates the behavior of the
861      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
862      * JSON-RPC method.
863      *
864      * See {recover}.
865      */
866     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
867         // 32 is the length in bytes of hash,
868         // enforced by the type signature above
869         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
870     }
871 }
872 
873 // File: contracts/EIP712.sol
874 
875 
876 pragma solidity ^0.6.0;
877 
878 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/EIP712.sol
879 
880 /**
881  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
882  *
883  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
884  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
885  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
886  *
887  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
888  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
889  * ({_hashTypedDataV4}).
890  *
891  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
892  * the chain id to protect against replay attacks on an eventual fork of the chain.
893  *
894  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
895  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
896  */
897 abstract contract EIP712 {
898     /* solhint-disable var-name-mixedcase */
899     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
900     // invalidate the cached domain separator if the chain id changes.
901     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
902     uint256 private immutable _CACHED_CHAIN_ID;
903 
904     bytes32 private immutable _HASHED_NAME;
905     bytes32 private immutable _HASHED_VERSION;
906     bytes32 private immutable _TYPE_HASH;
907     /* solhint-enable var-name-mixedcase */
908 
909     /**
910      * @dev Initializes the domain separator and parameter caches.
911      *
912      * The meaning of `name` and `version` is specified in
913      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
914      *
915      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
916      * - `version`: the current major version of the signing domain.
917      *
918      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
919      * contract upgrade].
920      */
921     constructor(string memory name, string memory version) internal {
922         bytes32 hashedName = keccak256(bytes(name));
923         bytes32 hashedVersion = keccak256(bytes(version));
924         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
925         _HASHED_NAME = hashedName;
926         _HASHED_VERSION = hashedVersion;
927         _CACHED_CHAIN_ID = _getChainId();
928         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
929         _TYPE_HASH = typeHash;
930     }
931 
932     /**
933      * @dev Returns the domain separator for the current chain.
934      */
935     function _domainSeparatorV4() internal view returns (bytes32) {
936         if (_getChainId() == _CACHED_CHAIN_ID) {
937             return _CACHED_DOMAIN_SEPARATOR;
938         } else {
939             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
940         }
941     }
942 
943     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
944         return keccak256(
945             abi.encode(
946                 typeHash,
947                 name,
948                 version,
949                 _getChainId(),
950                 address(this)
951             )
952         );
953     }
954 
955     /**
956      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
957      * function returns the hash of the fully encoded EIP712 message for this domain.
958      *
959      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
960      *
961      * ```solidity
962      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
963      *     keccak256("Mail(address to,string contents)"),
964      *     mailTo,
965      *     keccak256(bytes(mailContents))
966      * )));
967      * address signer = ECDSA.recover(digest, signature);
968      * ```
969      */
970     function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
971         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
972     }
973 
974     function _getChainId() private pure returns (uint256 chainId) {
975         // solhint-disable-next-line no-inline-assembly
976         assembly {
977             chainId := chainid()
978         }
979     }
980 }
981 
982 // File: contracts/ERC20Permit.sol
983 
984 
985 pragma solidity ^0.6.0;
986 
987 
988 
989 
990 
991 
992 // An adapted copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/ERC20Permit.sol
993 
994 /**
995  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
996  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
997  *
998  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
999  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1000  * need to send a transaction, and thus is not required to hold Ether at all.
1001  */
1002 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1003     using Counters for Counters.Counter;
1004 
1005     mapping (address => Counters.Counter) private _nonces;
1006 
1007     // solhint-disable-next-line var-name-mixedcase
1008     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1009 
1010     /**
1011      * @dev See {IERC20Permit-permit}.
1012      */
1013     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1014         // solhint-disable-next-line not-rely-on-time
1015         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1016 
1017         bytes32 structHash = keccak256(
1018             abi.encode(
1019                 _PERMIT_TYPEHASH,
1020                 owner,
1021                 spender,
1022                 value,
1023                 _nonces[owner].current(),
1024                 deadline
1025             )
1026         );
1027 
1028         bytes32 hash = _hashTypedDataV4(structHash);
1029 
1030         address signer = ECDSA.recover(hash, v, r, s);
1031         require(signer == owner, "ERC20Permit: invalid signature");
1032 
1033         _nonces[owner].increment();
1034         _approve(owner, spender, value);
1035     }
1036 
1037     /**
1038      * @dev See {IERC20Permit-nonces}.
1039      */
1040     function nonces(address owner) public view override returns (uint256) {
1041         return _nonces[owner].current();
1042     }
1043 
1044     /**
1045      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1046      */
1047     // solhint-disable-next-line func-name-mixedcase
1048     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1049         return _domainSeparatorV4();
1050     }
1051 }
1052 
1053 // File: contracts/DeversiFi.sol
1054 
1055 
1056 pragma solidity ^0.6.0;
1057 
1058 
1059 contract DeversiFi is ERC20Permit, ERC20Burnable, Ownable {
1060     constructor(address _owner) public ERC20("DeversiFi Token", "DVF") EIP712("DeversiFi Token", "1") {
1061         _mint(_owner, 1e8 ether);
1062         transferOwnership(_owner);
1063     }
1064 
1065     function mint(address to, uint256 amount) external onlyOwner {
1066         _mint(to, amount);
1067     }
1068 }