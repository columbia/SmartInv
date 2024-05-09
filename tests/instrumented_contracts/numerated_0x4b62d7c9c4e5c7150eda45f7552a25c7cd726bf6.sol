1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
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
79 pragma solidity ^0.6.0;
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
103 pragma solidity ^0.6.0;
104 
105 
106 /**
107  * @dev Implementation of the {IERC20} interface.
108  *
109  * This implementation is agnostic to the way tokens are created. This means
110  * that a supply mechanism has to be added in a derived contract using {_mint}.
111  * For a generic mechanism see {ERC20PresetMinterPauser}.
112  *
113  * TIP: For a detailed writeup see our guide
114  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
115  * to implement supply mechanisms].
116  *
117  * We have followed general OpenZeppelin guidelines: functions revert instead
118  * of returning `false` on failure. This behavior is nonetheless conventional
119  * and does not conflict with the expectations of ERC20 applications.
120  *
121  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
122  * This allows applications to reconstruct the allowance for all accounts just
123  * by listening to said events. Other implementations of the EIP may not emit
124  * these events, as it isn't required by the specification.
125  *
126  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
127  * functions have been added to mitigate the well-known issues around setting
128  * allowances. See {IERC20-approve}.
129  */
130 contract ERC20 is Context, IERC20 {
131     using SafeMath for uint256;
132     using Address for address;
133 
134     mapping (address => uint256) private _balances;
135 
136     mapping (address => mapping (address => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142     uint8 private _decimals;
143 
144     /**
145      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
146      * a default value of 18.
147      *
148      * To select a different value for {decimals}, use {_setupDecimals}.
149      *
150      * All three of these values are immutable: they can only be set once during
151      * construction.
152      */
153     constructor (string memory name, string memory symbol) public {
154         _name = name;
155         _symbol = symbol;
156         _decimals = 18;
157     }
158 
159     /**
160      * @dev Returns the name of the token.
161      */
162     function name() public view returns (string memory) {
163         return _name;
164     }
165 
166     /**
167      * @dev Returns the symbol of the token, usually a shorter version of the
168      * name.
169      */
170     function symbol() public view returns (string memory) {
171         return _symbol;
172     }
173 
174     /**
175      * @dev Returns the number of decimals used to get its user representation.
176      * For example, if `decimals` equals `2`, a balance of `505` tokens should
177      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
178      *
179      * Tokens usually opt for a value of 18, imitating the relationship between
180      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
181      * called.
182      *
183      * NOTE: This information is only used for _display_ purposes: it in
184      * no way affects any of the arithmetic of the contract, including
185      * {IERC20-balanceOf} and {IERC20-transfer}.
186      */
187     function decimals() public view returns (uint8) {
188         return _decimals;
189     }
190 
191     /**
192      * @dev See {IERC20-totalSupply}.
193      */
194     function totalSupply() public view override returns (uint256) {
195         return _totalSupply;
196     }
197 
198     /**
199      * @dev See {IERC20-balanceOf}.
200      */
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     /**
206      * @dev See {IERC20-transfer}.
207      *
208      * Requirements:
209      *
210      * - `recipient` cannot be the zero address.
211      * - the caller must have a balance of at least `amount`.
212      */
213     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
214         _transfer(_msgSender(), recipient, amount);
215         return true;
216     }
217 
218     /**
219      * @dev See {IERC20-allowance}.
220      */
221     function allowance(address owner, address spender) public view virtual override returns (uint256) {
222         return _allowances[owner][spender];
223     }
224 
225     /**
226      * @dev See {IERC20-approve}.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      */
232     function approve(address spender, uint256 amount) public virtual override returns (bool) {
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236 
237     /**
238      * @dev See {IERC20-transferFrom}.
239      *
240      * Emits an {Approval} event indicating the updated allowance. This is not
241      * required by the EIP. See the note at the beginning of {ERC20};
242      *
243      * Requirements:
244      * - `sender` and `recipient` cannot be the zero address.
245      * - `sender` must have a balance of at least `amount`.
246      * - the caller must have allowance for ``sender``'s tokens of at least
247      * `amount`.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(sender, recipient, amount);
251         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
252         return true;
253     }
254 
255     /**
256      * @dev Atomically increases the allowance granted to `spender` by the caller.
257      *
258      * This is an alternative to {approve} that can be used as a mitigation for
259      * problems described in {IERC20-approve}.
260      *
261      * Emits an {Approval} event indicating the updated allowance.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
268         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
269         return true;
270     }
271 
272     /**
273      * @dev Atomically decreases the allowance granted to `spender` by the caller.
274      *
275      * This is an alternative to {approve} that can be used as a mitigation for
276      * problems described in {IERC20-approve}.
277      *
278      * Emits an {Approval} event indicating the updated allowance.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      * - `spender` must have allowance for the caller of at least
284      * `subtractedValue`.
285      */
286     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
287         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
288         return true;
289     }
290 
291     /**
292      * @dev Moves tokens `amount` from `sender` to `recipient`.
293      *
294      * This is internal function is equivalent to {transfer}, and can be used to
295      * e.g. implement automatic token fees, slashing mechanisms, etc.
296      *
297      * Emits a {Transfer} event.
298      *
299      * Requirements:
300      *
301      * - `sender` cannot be the zero address.
302      * - `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      */
305     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
306         require(sender != address(0), "ERC20: transfer from the zero address");
307         require(recipient != address(0), "ERC20: transfer to the zero address");
308 
309         _beforeTokenTransfer(sender, recipient, amount);
310 
311         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
312         _balances[recipient] = _balances[recipient].add(amount);
313         emit Transfer(sender, recipient, amount);
314     }
315 
316     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
317      * the total supply.
318      *
319      * Emits a {Transfer} event with `from` set to the zero address.
320      *
321      * Requirements
322      *
323      * - `to` cannot be the zero address.
324      */
325     function _mint(address account, uint256 amount) internal virtual {
326         require(account != address(0), "ERC20: mint to the zero address");
327 
328         _beforeTokenTransfer(address(0), account, amount);
329 
330         _totalSupply = _totalSupply.add(amount);
331         _balances[account] = _balances[account].add(amount);
332         emit Transfer(address(0), account, amount);
333     }
334 
335     /**
336      * @dev Destroys `amount` tokens from `account`, reducing the
337      * total supply.
338      *
339      * Emits a {Transfer} event with `to` set to the zero address.
340      *
341      * Requirements
342      *
343      * - `account` cannot be the zero address.
344      * - `account` must have at least `amount` tokens.
345      */
346     function _burn(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349         _beforeTokenTransfer(account, address(0), amount);
350 
351         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
352         _totalSupply = _totalSupply.sub(amount);
353         emit Transfer(account, address(0), amount);
354     }
355 
356     /**
357      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
358      *
359      * This is internal function is equivalent to `approve`, and can be used to
360      * e.g. set automatic allowances for certain subsystems, etc.
361      *
362      * Emits an {Approval} event.
363      *
364      * Requirements:
365      *
366      * - `owner` cannot be the zero address.
367      * - `spender` cannot be the zero address.
368      */
369     function _approve(address owner, address spender, uint256 amount) internal virtual {
370         require(owner != address(0), "ERC20: approve from the zero address");
371         require(spender != address(0), "ERC20: approve to the zero address");
372 
373         _allowances[owner][spender] = amount;
374         emit Approval(owner, spender, amount);
375     }
376 
377     /**
378      * @dev Sets {decimals} to a value other than the default one of 18.
379      *
380      * WARNING: This function should only be called from the constructor. Most
381      * applications that interact with token contracts will not expect
382      * {decimals} to ever change, and may work incorrectly if it does.
383      */
384     function _setupDecimals(uint8 decimals_) internal {
385         _decimals = decimals_;
386     }
387 
388     /**
389      * @dev Hook that is called before any transfer of tokens. This includes
390      * minting and burning.
391      *
392      * Calling conditions:
393      *
394      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
395      * will be to transferred to `to`.
396      * - when `from` is zero, `amount` tokens will be minted for `to`.
397      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
398      * - `from` and `to` are never both zero.
399      *
400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
401      */
402     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
403 }
404 
405 pragma solidity ^0.6.0;
406 
407 /**
408  * @dev Contract module that helps prevent reentrant calls to a function.
409  *
410  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
411  * available, which can be applied to functions to make sure there are no nested
412  * (reentrant) calls to them.
413  *
414  * Note that because there is a single `nonReentrant` guard, functions marked as
415  * `nonReentrant` may not call one another. This can be worked around by making
416  * those functions `private`, and then adding `external` `nonReentrant` entry
417  * points to them.
418  *
419  * TIP: If you would like to learn more about reentrancy and alternative ways
420  * to protect against it, check out our blog post
421  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
422  */
423 contract ReentrancyGuard {
424     // Booleans are more expensive than uint256 or any type that takes up a full
425     // word because each write operation emits an extra SLOAD to first read the
426     // slot's contents, replace the bits taken up by the boolean, and then write
427     // back. This is the compiler's defense against contract upgrades and
428     // pointer aliasing, and it cannot be disabled.
429 
430     // The values being non-zero value makes deployment a bit more expensive,
431     // but in exchange the refund on every call to nonReentrant will be lower in
432     // amount. Since refunds are capped to a percentage of the total
433     // transaction's gas, it is best to keep them low in cases like this one, to
434     // increase the likelihood of the full refund coming into effect.
435     uint256 private constant _NOT_ENTERED = 1;
436     uint256 private constant _ENTERED = 2;
437 
438     uint256 private _status;
439 
440     constructor () internal {
441         _status = _NOT_ENTERED;
442     }
443 
444     /**
445      * @dev Prevents a contract from calling itself, directly or indirectly.
446      * Calling a `nonReentrant` function from another `nonReentrant`
447      * function is not supported. It is possible to prevent this from happening
448      * by making the `nonReentrant` function external, and make it call a
449      * `private` function that does the actual work.
450      */
451     modifier nonReentrant() {
452         // On the first call to nonReentrant, _notEntered will be true
453         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
454 
455         // Any calls to nonReentrant after this point will fail
456         _status = _ENTERED;
457 
458         _;
459 
460         // By storing the original value once again, a refund is triggered (see
461         // https://eips.ethereum.org/EIPS/eip-2200)
462         _status = _NOT_ENTERED;
463     }
464 }
465 
466 
467 pragma solidity ^0.6.0;
468 
469 
470 /**
471  * @dev Contract module which provides a basic access control mechanism, where
472  * there is an account (an owner) that can be granted exclusive access to
473  * specific functions.
474  *
475  * By default, the owner account will be the one that deploys the contract. This
476  * can later be changed with {transferOwnership}.
477  *
478  * This module is used through inheritance. It will make available the modifier
479  * `onlyOwner`, which can be applied to your functions to restrict their use to
480  * the owner.
481  */
482 contract Ownable is Context {
483     address private _owner;
484 
485     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
486 
487     /**
488      * @dev Initializes the contract setting the deployer as the initial owner.
489      */
490     constructor () internal {
491         address msgSender = _msgSender();
492         _owner = msgSender;
493         emit OwnershipTransferred(address(0), msgSender);
494     }
495 
496     /**
497      * @dev Returns the address of the current owner.
498      */
499     function owner() public view returns (address) {
500         return _owner;
501     }
502 
503     /**
504      * @dev Throws if called by any account other than the owner.
505      */
506     modifier onlyOwner() {
507         require(_owner == _msgSender(), "Ownable: caller is not the owner");
508         _;
509     }
510 
511     /**
512      * @dev Leaves the contract without owner. It will not be possible to call
513      * `onlyOwner` functions anymore. Can only be called by the current owner.
514      *
515      * NOTE: Renouncing ownership will leave the contract without an owner,
516      * thereby removing any functionality that is only available to the owner.
517      */
518     function renounceOwnership() public virtual onlyOwner {
519         emit OwnershipTransferred(_owner, address(0));
520         _owner = address(0);
521     }
522 
523     /**
524      * @dev Transfers ownership of the contract to a new account (`newOwner`).
525      * Can only be called by the current owner.
526      */
527     function transferOwnership(address newOwner) public virtual onlyOwner {
528         require(newOwner != address(0), "Ownable: new owner is the zero address");
529         emit OwnershipTransferred(_owner, newOwner);
530         _owner = newOwner;
531     }
532 }
533 
534 pragma solidity ^0.6.0;
535 
536 
537 /**
538  * @dev Extension of {ERC20} that allows token holders to destroy both their own
539  * tokens and those that they have an allowance for, in a way that can be
540  * recognized off-chain (via event analysis).
541  */
542 abstract contract ERC20Burnable is Context, ERC20 {
543     /**
544      * @dev Destroys `amount` tokens from the caller.
545      *
546      * See {ERC20-_burn}.
547      */
548     function burn(uint256 amount) public virtual {
549         _burn(_msgSender(), amount);
550     }
551 
552     /**
553      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
554      * allowance.
555      *
556      * See {ERC20-_burn} and {ERC20-allowance}.
557      *
558      * Requirements:
559      *
560      * - the caller must have allowance for ``accounts``'s tokens of at least
561      * `amount`.
562      */
563     function burnFrom(address account, uint256 amount) public virtual {
564         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
565 
566         _approve(account, _msgSender(), decreasedAllowance);
567         _burn(account, amount);
568     }
569 }
570 
571 
572 pragma solidity ^0.6.0;
573 
574 /**
575  * @dev Wrappers over Solidity's arithmetic operations with added overflow
576  * checks.
577  *
578  * Arithmetic operations in Solidity wrap on overflow. This can easily result
579  * in bugs, because programmers usually assume that an overflow raises an
580  * error, which is the standard behavior in high level programming languages.
581  * `SafeMath` restores this intuition by reverting the transaction when an
582  * operation overflows.
583  *
584  * Using this library instead of the unchecked operations eliminates an entire
585  * class of bugs, so it's recommended to use it always.
586  */
587 library SafeMath {
588     /**
589      * @dev Returns the addition of two unsigned integers, reverting on
590      * overflow.
591      *
592      * Counterpart to Solidity's `+` operator.
593      *
594      * Requirements:
595      *
596      * - Addition cannot overflow.
597      */
598     function add(uint256 a, uint256 b) internal pure returns (uint256) {
599         uint256 c = a + b;
600         require(c >= a, "SafeMath: addition overflow");
601 
602         return c;
603     }
604 
605     /**
606      * @dev Returns the subtraction of two unsigned integers, reverting on
607      * overflow (when the result is negative).
608      *
609      * Counterpart to Solidity's `-` operator.
610      *
611      * Requirements:
612      *
613      * - Subtraction cannot overflow.
614      */
615     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
616         return sub(a, b, "SafeMath: subtraction overflow");
617     }
618 
619     /**
620      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
621      * overflow (when the result is negative).
622      *
623      * Counterpart to Solidity's `-` operator.
624      *
625      * Requirements:
626      *
627      * - Subtraction cannot overflow.
628      */
629     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
630         require(b <= a, errorMessage);
631         uint256 c = a - b;
632 
633         return c;
634     }
635 
636     /**
637      * @dev Returns the multiplication of two unsigned integers, reverting on
638      * overflow.
639      *
640      * Counterpart to Solidity's `*` operator.
641      *
642      * Requirements:
643      *
644      * - Multiplication cannot overflow.
645      */
646     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
647         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
648         // benefit is lost if 'b' is also tested.
649         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
650         if (a == 0) {
651             return 0;
652         }
653 
654         uint256 c = a * b;
655         require(c / a == b, "SafeMath: multiplication overflow");
656 
657         return c;
658     }
659 
660     /**
661      * @dev Returns the integer division of two unsigned integers. Reverts on
662      * division by zero. The result is rounded towards zero.
663      *
664      * Counterpart to Solidity's `/` operator. Note: this function uses a
665      * `revert` opcode (which leaves remaining gas untouched) while Solidity
666      * uses an invalid opcode to revert (consuming all remaining gas).
667      *
668      * Requirements:
669      *
670      * - The divisor cannot be zero.
671      */
672     function div(uint256 a, uint256 b) internal pure returns (uint256) {
673         return div(a, b, "SafeMath: division by zero");
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator. Note: this function uses a
681      * `revert` opcode (which leaves remaining gas untouched) while Solidity
682      * uses an invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
689         require(b > 0, errorMessage);
690         uint256 c = a / b;
691         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
692 
693         return c;
694     }
695 
696     /**
697      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
698      * Reverts when dividing by zero.
699      *
700      * Counterpart to Solidity's `%` operator. This function uses a `revert`
701      * opcode (which leaves remaining gas untouched) while Solidity uses an
702      * invalid opcode to revert (consuming all remaining gas).
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
709         return mod(a, b, "SafeMath: modulo by zero");
710     }
711 
712     /**
713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
714      * Reverts with custom message when dividing by zero.
715      *
716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
717      * opcode (which leaves remaining gas untouched) while Solidity uses an
718      * invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
725         require(b != 0, errorMessage);
726         return a % b;
727     }
728 }
729 
730 
731 pragma solidity ^0.6.2;
732 
733 /**
734  * @dev Collection of functions related to the address type
735  */
736 library Address {
737     /**
738      * @dev Returns true if `account` is a contract.
739      *
740      * [IMPORTANT]
741      * ====
742      * It is unsafe to assume that an address for which this function returns
743      * false is an externally-owned account (EOA) and not a contract.
744      *
745      * Among others, `isContract` will return false for the following
746      * types of addresses:
747      *
748      *  - an externally-owned account
749      *  - a contract in construction
750      *  - an address where a contract will be created
751      *  - an address where a contract lived, but was destroyed
752      * ====
753      */
754     function isContract(address account) internal view returns (bool) {
755         // This method relies in extcodesize, which returns 0 for contracts in
756         // construction, since the code is only stored at the end of the
757         // constructor execution.
758 
759         uint256 size;
760         // solhint-disable-next-line no-inline-assembly
761         assembly { size := extcodesize(account) }
762         return size > 0;
763     }
764 
765     /**
766      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
767      * `recipient`, forwarding all available gas and reverting on errors.
768      *
769      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
770      * of certain opcodes, possibly making contracts go over the 2300 gas limit
771      * imposed by `transfer`, making them unable to receive funds via
772      * `transfer`. {sendValue} removes this limitation.
773      *
774      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
775      *
776      * IMPORTANT: because control is transferred to `recipient`, care must be
777      * taken to not create reentrancy vulnerabilities. Consider using
778      * {ReentrancyGuard} or the
779      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
780      */
781     function sendValue(address payable recipient, uint256 amount) internal {
782         require(address(this).balance >= amount, "Address: insufficient balance");
783 
784         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
785         (bool success, ) = recipient.call{ value: amount }("");
786         require(success, "Address: unable to send value, recipient may have reverted");
787     }
788 
789     /**
790      * @dev Performs a Solidity function call using a low level `call`. A
791      * plain`call` is an unsafe replacement for a function call: use this
792      * function instead.
793      *
794      * If `target` reverts with a revert reason, it is bubbled up by this
795      * function (like regular Solidity function calls).
796      *
797      * Returns the raw returned data. To convert to the expected return value,
798      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
799      *
800      * Requirements:
801      *
802      * - `target` must be a contract.
803      * - calling `target` with `data` must not revert.
804      *
805      * _Available since v3.1._
806      */
807     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
808       return functionCall(target, data, "Address: low-level call failed");
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
813      * `errorMessage` as a fallback revert reason when `target` reverts.
814      *
815      * _Available since v3.1._
816      */
817     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
818         return _functionCallWithValue(target, data, 0, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but also transferring `value` wei to `target`.
824      *
825      * Requirements:
826      *
827      * - the calling contract must have an ETH balance of at least `value`.
828      * - the called Solidity function must be `payable`.
829      *
830      * _Available since v3.1._
831      */
832     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
833         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
838      * with `errorMessage` as a fallback revert reason when `target` reverts.
839      *
840      * _Available since v3.1._
841      */
842     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
843         require(address(this).balance >= value, "Address: insufficient balance for call");
844         return _functionCallWithValue(target, data, value, errorMessage);
845     }
846 
847     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
848         require(isContract(target), "Address: call to non-contract");
849 
850         // solhint-disable-next-line avoid-low-level-calls
851         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
852         if (success) {
853             return returndata;
854         } else {
855             // Look for revert reason and bubble it up if present
856             if (returndata.length > 0) {
857                 // The easiest way to bubble the revert reason is using memory via assembly
858 
859                 // solhint-disable-next-line no-inline-assembly
860                 assembly {
861                     let returndata_size := mload(returndata)
862                     revert(add(32, returndata), returndata_size)
863                 }
864             } else {
865                 revert(errorMessage);
866             }
867         }
868     }
869 }
870 
871 
872 pragma solidity ^0.6.0;
873 
874 
875 /**
876  * @title SafeERC20
877  * @dev Wrappers around ERC20 operations that throw on failure (when the token
878  * contract returns false). Tokens that return no value (and instead revert or
879  * throw on failure) are also supported, non-reverting calls are assumed to be
880  * successful.
881  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
882  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
883  */
884 library SafeERC20 {
885     using SafeMath for uint256;
886     using Address for address;
887 
888     function safeTransfer(IERC20 token, address to, uint256 value) internal {
889         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
890     }
891 
892     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
893         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
894     }
895 
896     /**
897      * @dev Deprecated. This function has issues similar to the ones found in
898      * {IERC20-approve}, and its usage is discouraged.
899      *
900      * Whenever possible, use {safeIncreaseAllowance} and
901      * {safeDecreaseAllowance} instead.
902      */
903     function safeApprove(IERC20 token, address spender, uint256 value) internal {
904         // safeApprove should only be called when setting an initial allowance,
905         // or when resetting it to zero. To increase and decrease it, use
906         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
907         // solhint-disable-next-line max-line-length
908         require((value == 0) || (token.allowance(address(this), spender) == 0),
909             "SafeERC20: approve from non-zero to non-zero allowance"
910         );
911         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
912     }
913 
914     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
915         uint256 newAllowance = token.allowance(address(this), spender).add(value);
916         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
917     }
918 
919     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
920         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
921         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
922     }
923 
924     /**
925      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
926      * on the return value: the return value is optional (but if data is returned, it must not be false).
927      * @param token The token targeted by the call.
928      * @param data The call data (encoded using abi.encode or one of its variants).
929      */
930     function _callOptionalReturn(IERC20 token, bytes memory data) private {
931         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
932         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
933         // the target address contains contract code and also asserts for success in the low-level call.
934 
935         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
936         if (returndata.length > 0) { // Return data is optional
937             // solhint-disable-next-line max-line-length
938             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
939         }
940     }
941 }
942 
943 
944 contract COREuFFYI is ERC20, ReentrancyGuard {
945   using SafeERC20 for IERC20;
946   using Address for address;
947   using SafeMath for uint256;
948 
949   IERC20 public uFFYI = IERC20(0x021576770CB3729716CCfb687afdB4c6bF720CB6);
950   IERC20 public FFYI  = IERC20(0xca76BAa777d749De63Ca044853D22D56bC70bb47);
951   
952   uint256 private rewardSpeed = 200000000000000000000000000000000000; // (rewards per block) 4 * 60 * 24 = 5760 blocks/day 60000 / 0.1777 / 5760 = 58 days
953                                         // 300 000 blocks
954   
955   mapping(address => uint256) private startStaking;
956   mapping(address => uint256) private rewards;
957   mapping(uint256 => uint256) private totalBlocks;
958   uint256[] private blocks;
959   uint256 private stopBlock = 0;
960 
961   
962   constructor () public ERC20("wrapped uFFYI", "wuFFYI") {
963     uint256 blockNumber = getBlockNumber();
964     blocks.push(blockNumber);
965     totalBlocks[blockNumber] = totalSupply();
966   }
967 
968   function stake(uint256 amount) public {
969       
970       if (startStaking[_msgSender()] > 0) {  // have exist stake amount
971           rewards[_msgSender()] = earned(_msgSender());
972       }
973       _mint(_msgSender(), amount);
974       uint256 blockNumber = getBlockNumber();
975       startStaking[_msgSender()] = blockNumber;
976       if (stopBlock == 0) {
977         stopBlock = blockNumber + 300000;
978       }
979 
980       if (stopBlock > blockNumber) {
981         totalBlocks[blockNumber] = totalSupply();
982         if (blocks.length>0) {
983           if (blocks[blocks.length - 1] < blockNumber) {
984             blocks.push(blockNumber);
985           }
986         } else {
987           blocks.push(blockNumber);
988         }
989       }
990       uFFYI.safeTransferFrom(_msgSender(), address(this), amount);
991   }
992 
993   function withdraw(uint256 amount) public {
994       rewards[_msgSender()] = earned(_msgSender());
995 
996       uint256 blockNumber = getBlockNumber();
997       if (balanceOf(_msgSender()) == amount) {
998         startStaking[_msgSender()] = 0;
999       } else {
1000         startStaking[_msgSender()] = blockNumber;
1001       }
1002       
1003       if (stopBlock > blockNumber) {
1004         if (blocks.length>0) {
1005           if (blocks[blocks.length - 1] < blockNumber) {
1006             blocks.push(blockNumber);
1007           }
1008         } else {
1009           blocks.push(blockNumber);
1010         }
1011         totalBlocks[blockNumber] = totalSupply();
1012       }
1013       _burn(_msgSender(), amount);
1014       uFFYI.safeTransfer(_msgSender(), amount);
1015   }
1016   
1017   function earned(address account) public view returns (uint256) {
1018       uint256 lastblock = getBlockNumber();
1019       if (stopBlock > 0) {
1020         if (stopBlock < lastblock) {
1021           lastblock = stopBlock;
1022         }
1023       }
1024       uint256 deltaRewards = 0;
1025       
1026       if (startStaking[account] > 0) {
1027         
1028         for (uint256 i=blocks.length-1; i>0; i--) {
1029           uint256 firstblock = blocks[i];
1030           if (blocks[i]<startStaking[account]) {
1031             firstblock = startStaking[account];
1032           }
1033           deltaRewards = deltaRewards.add(balanceOf(account).mul(_rewardPerToken(totalBlocks[blocks[i]])).mul(lastblock.sub(firstblock)).div(1e18));
1034           if (blocks[i]<startStaking[account]) {
1035             break;
1036           }
1037           lastblock = blocks[i];
1038         }
1039       }
1040       
1041       return
1042           deltaRewards
1043               .add(rewards[account]);
1044   }
1045   
1046   function rewardPerToken() public view returns (uint256) {
1047     if (totalSupply() == 0) {
1048         return 0;
1049     }
1050     return
1051         rewardSpeed.div(totalSupply());
1052   }
1053   
1054   function _rewardPerToken(uint256 total) private view returns (uint256) {
1055     if (total == 0) {
1056         return 0;
1057     }
1058     return
1059         rewardSpeed.div(total);
1060   }
1061 
1062   function exit() public {
1063       withdraw(balanceOf(_msgSender()));
1064       if (rewards[_msgSender()] > 0) {
1065           _sendRewards(_msgSender(), rewards[_msgSender()]);
1066           rewards[_msgSender()] = 0;
1067       }
1068   }
1069 
1070   function getReward() public {
1071       uint256 reward = earned(_msgSender());
1072       if (reward > 0) {
1073           rewards[_msgSender()] = 0;
1074           startStaking[_msgSender()] = getBlockNumber();
1075           _sendRewards(_msgSender(), reward);
1076       }
1077   }
1078   
1079   function _sendRewards(address account, uint256 reward) private {
1080       if (FFYI.balanceOf(address(this)) > reward) {
1081           FFYI.safeTransfer(account, reward);
1082       } else {
1083           require(FFYI.balanceOf(address(this)) != 0, "COREuFFYI: Rewards exhausted");
1084           FFYI.safeTransfer(account, FFYI.balanceOf(address(this)));
1085       }
1086   }
1087   
1088   function getBlockNumber() public view returns (uint256) {
1089       return block.number;
1090   }
1091 }