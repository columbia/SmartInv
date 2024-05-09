1 // SPDX-License-Identifier: AGPL-3.0
2 
3 // File contracts/dependencies/open-zeppelin/Context.sol
4 
5 pragma solidity 0.7.5;
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
18   function _msgSender() internal view virtual returns (address payable) {
19     return msg.sender;
20   }
21 
22   function _msgData() internal view virtual returns (bytes memory) {
23     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24     return msg.data;
25   }
26 }
27 
28 
29 // File contracts/dependencies/open-zeppelin/IERC20.sol
30 
31 pragma solidity 0.7.5;
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
107 
108 // File contracts/dependencies/open-zeppelin/SafeMath.sol
109 
110 pragma solidity 0.7.5;
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
126   /**
127    * @dev Returns the addition of two unsigned integers, reverting on
128    * overflow.
129    *
130    * Counterpart to Solidity's `+` operator.
131    *
132    * Requirements:
133    * - Addition cannot overflow.
134    */
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     require(c >= a, 'SafeMath: addition overflow');
138 
139     return c;
140   }
141 
142   /**
143    * @dev Returns the subtraction of two unsigned integers, reverting on
144    * overflow (when the result is negative).
145    *
146    * Counterpart to Solidity's `-` operator.
147    *
148    * Requirements:
149    * - Subtraction cannot overflow.
150    */
151   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152     return sub(a, b, 'SafeMath: subtraction overflow');
153   }
154 
155   /**
156    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157    * overflow (when the result is negative).
158    *
159    * Counterpart to Solidity's `-` operator.
160    *
161    * Requirements:
162    * - Subtraction cannot overflow.
163    */
164   function sub(
165     uint256 a,
166     uint256 b,
167     string memory errorMessage
168   ) internal pure returns (uint256) {
169     require(b <= a, errorMessage);
170     uint256 c = a - b;
171 
172     return c;
173   }
174 
175   /**
176    * @dev Returns the multiplication of two unsigned integers, reverting on
177    * overflow.
178    *
179    * Counterpart to Solidity's `*` operator.
180    *
181    * Requirements:
182    * - Multiplication cannot overflow.
183    */
184   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186     // benefit is lost if 'b' is also tested.
187     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188     if (a == 0) {
189       return 0;
190     }
191 
192     uint256 c = a * b;
193     require(c / a == b, 'SafeMath: multiplication overflow');
194 
195     return c;
196   }
197 
198   /**
199    * @dev Returns the integer division of two unsigned integers. Reverts on
200    * division by zero. The result is rounded towards zero.
201    *
202    * Counterpart to Solidity's `/` operator. Note: this function uses a
203    * `revert` opcode (which leaves remaining gas untouched) while Solidity
204    * uses an invalid opcode to revert (consuming all remaining gas).
205    *
206    * Requirements:
207    * - The divisor cannot be zero.
208    */
209   function div(uint256 a, uint256 b) internal pure returns (uint256) {
210     return div(a, b, 'SafeMath: division by zero');
211   }
212 
213   /**
214    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215    * division by zero. The result is rounded towards zero.
216    *
217    * Counterpart to Solidity's `/` operator. Note: this function uses a
218    * `revert` opcode (which leaves remaining gas untouched) while Solidity
219    * uses an invalid opcode to revert (consuming all remaining gas).
220    *
221    * Requirements:
222    * - The divisor cannot be zero.
223    */
224   function div(
225     uint256 a,
226     uint256 b,
227     string memory errorMessage
228   ) internal pure returns (uint256) {
229     // Solidity only automatically asserts when dividing by 0
230     require(b > 0, errorMessage);
231     uint256 c = a / b;
232     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234     return c;
235   }
236 
237   /**
238    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239    * Reverts when dividing by zero.
240    *
241    * Counterpart to Solidity's `%` operator. This function uses a `revert`
242    * opcode (which leaves remaining gas untouched) while Solidity uses an
243    * invalid opcode to revert (consuming all remaining gas).
244    *
245    * Requirements:
246    * - The divisor cannot be zero.
247    */
248   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249     return mod(a, b, 'SafeMath: modulo by zero');
250   }
251 
252   /**
253    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254    * Reverts with custom message when dividing by zero.
255    *
256    * Counterpart to Solidity's `%` operator. This function uses a `revert`
257    * opcode (which leaves remaining gas untouched) while Solidity uses an
258    * invalid opcode to revert (consuming all remaining gas).
259    *
260    * Requirements:
261    * - The divisor cannot be zero.
262    */
263   function mod(
264     uint256 a,
265     uint256 b,
266     string memory errorMessage
267   ) internal pure returns (uint256) {
268     require(b != 0, errorMessage);
269     return a % b;
270   }
271 }
272 
273 
274 // File contracts/dependencies/open-zeppelin/Address.sol
275 
276 pragma solidity 0.7.5;
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282   /**
283    * @dev Returns true if `account` is a contract.
284    *
285    * [IMPORTANT]
286    * ====
287    * It is unsafe to assume that an address for which this function returns
288    * false is an externally-owned account (EOA) and not a contract.
289    *
290    * Among others, `isContract` will return false for the following
291    * types of addresses:
292    *
293    *  - an externally-owned account
294    *  - a contract in construction
295    *  - an address where a contract will be created
296    *  - an address where a contract lived, but was destroyed
297    * ====
298    */
299   function isContract(address account) internal view returns (bool) {
300     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302     // for accounts without code, i.e. `keccak256('')`
303     bytes32 codehash;
304     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305     // solhint-disable-next-line no-inline-assembly
306     assembly {
307       codehash := extcodehash(account)
308     }
309     return (codehash != accountHash && codehash != 0x0);
310   }
311 
312   /**
313    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314    * `recipient`, forwarding all available gas and reverting on errors.
315    *
316    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317    * of certain opcodes, possibly making contracts go over the 2300 gas limit
318    * imposed by `transfer`, making them unable to receive funds via
319    * `transfer`. {sendValue} removes this limitation.
320    *
321    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322    *
323    * IMPORTANT: because control is transferred to `recipient`, care must be
324    * taken to not create reentrancy vulnerabilities. Consider using
325    * {ReentrancyGuard} or the
326    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327    */
328   function sendValue(address payable recipient, uint256 amount) internal {
329     require(address(this).balance >= amount, 'Address: insufficient balance');
330 
331     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332     (bool success, ) = recipient.call{value: amount}('');
333     require(success, 'Address: unable to send value, recipient may have reverted');
334   }
335 }
336 
337 
338 // File contracts/dependencies/open-zeppelin/ERC20.sol
339 
340 pragma solidity ^0.7.5;
341 
342 
343 
344 
345 /**
346  * @dev Implementation of the {IERC20} interface.
347  *
348  * This implementation is agnostic to the way tokens are created. This means
349  * that a supply mechanism has to be added in a derived contract using {_mint}.
350  * For a generic mechanism see {ERC20PresetMinterPauser}.
351  *
352  * TIP: For a detailed writeup see our guide
353  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
354  * to implement supply mechanisms].
355  *
356  * We have followed general OpenZeppelin guidelines: functions revert instead
357  * of returning `false` on failure. This behavior is nonetheless conventional
358  * and does not conflict with the expectations of ERC20 applications.
359  *
360  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
361  * This allows applications to reconstruct the allowance for all accounts just
362  * by listening to said events. Other implementations of the EIP may not emit
363  * these events, as it isn't required by the specification.
364  *
365  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
366  * functions have been added to mitigate the well-known issues around setting
367  * allowances. See {IERC20-approve}.
368  */
369 contract ERC20 is Context, IERC20 {
370     using SafeMath for uint256;
371     using Address for address;
372 
373     mapping (address => uint256) private _balances;
374 
375     mapping (address => mapping (address => uint256)) private _allowances;
376 
377     uint256 private _totalSupply;
378 
379     string internal _name;
380     string internal _symbol;
381     uint8 private _decimals;
382 
383     /**
384      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
385      * a default value of 18.
386      *
387      * To select a different value for {decimals}, use {_setupDecimals}.
388      *
389      * All three of these values are immutable: they can only be set once during
390      * construction.
391      */
392     constructor (string memory name, string memory symbol) public {
393         _name = name;
394         _symbol = symbol;
395         _decimals = 18;
396     }
397 
398     /**
399      * @dev Returns the name of the token.
400      */
401     function name() virtual public view returns (string memory) {
402         return _name;
403     }
404 
405     /**
406      * @dev Returns the symbol of the token, usually a shorter version of the
407      * name.
408      */
409     function symbol() virtual public view returns (string memory) {
410         return _symbol;
411     }
412 
413     /**
414      * @dev Returns the number of decimals used to get its user representation.
415      * For example, if `decimals` equals `2`, a balance of `505` tokens should
416      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
417      *
418      * Tokens usually opt for a value of 18, imitating the relationship between
419      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
420      * called.
421      *
422      * NOTE: This information is only used for _display_ purposes: it in
423      * no way affects any of the arithmetic of the contract, including
424      * {IERC20-balanceOf} and {IERC20-transfer}.
425      */
426     function decimals() virtual public view returns (uint8) {
427         return _decimals;
428     }
429 
430     /**
431      * @dev See {IERC20-totalSupply}.
432      */
433     function totalSupply() public view override returns (uint256) {
434         return _totalSupply;
435     }
436 
437     /**
438      * @dev See {IERC20-balanceOf}.
439      */
440     function balanceOf(address account) public view override returns (uint256) {
441         return _balances[account];
442     }
443 
444     /**
445      * @dev See {IERC20-transfer}.
446      *
447      * Requirements:
448      *
449      * - `recipient` cannot be the zero address.
450      * - the caller must have a balance of at least `amount`.
451      */
452     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
453         _transfer(_msgSender(), recipient, amount);
454         return true;
455     }
456 
457     /**
458      * @dev See {IERC20-allowance}.
459      */
460     function allowance(address owner, address spender) public view virtual override returns (uint256) {
461         return _allowances[owner][spender];
462     }
463 
464     /**
465      * @dev See {IERC20-approve}.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      */
471     function approve(address spender, uint256 amount) public virtual override returns (bool) {
472         _approve(_msgSender(), spender, amount);
473         return true;
474     }
475 
476     /**
477      * @dev See {IERC20-transferFrom}.
478      *
479      * Emits an {Approval} event indicating the updated allowance. This is not
480      * required by the EIP. See the note at the beginning of {ERC20};
481      *
482      * Requirements:
483      * - `sender` and `recipient` cannot be the zero address.
484      * - `sender` must have a balance of at least `amount`.
485      * - the caller must have allowance for ``sender``'s tokens of at least
486      * `amount`.
487      */
488     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
489         _transfer(sender, recipient, amount);
490         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
491         return true;
492     }
493 
494     /**
495      * @dev Atomically increases the allowance granted to `spender` by the caller.
496      *
497      * This is an alternative to {approve} that can be used as a mitigation for
498      * problems described in {IERC20-approve}.
499      *
500      * Emits an {Approval} event indicating the updated allowance.
501      *
502      * Requirements:
503      *
504      * - `spender` cannot be the zero address.
505      */
506     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
508         return true;
509     }
510 
511     /**
512      * @dev Atomically decreases the allowance granted to `spender` by the caller.
513      *
514      * This is an alternative to {approve} that can be used as a mitigation for
515      * problems described in {IERC20-approve}.
516      *
517      * Emits an {Approval} event indicating the updated allowance.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      * - `spender` must have allowance for the caller of at least
523      * `subtractedValue`.
524      */
525     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
527         return true;
528     }
529 
530     /**
531      * @dev Moves tokens `amount` from `sender` to `recipient`.
532      *
533      * This is internal function is equivalent to {transfer}, and can be used to
534      * e.g. implement automatic token fees, slashing mechanisms, etc.
535      *
536      * Emits a {Transfer} event.
537      *
538      * Requirements:
539      *
540      * - `sender` cannot be the zero address.
541      * - `recipient` cannot be the zero address.
542      * - `sender` must have a balance of at least `amount`.
543      */
544     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
545         require(sender != address(0), "ERC20: transfer from the zero address");
546         require(recipient != address(0), "ERC20: transfer to the zero address");
547 
548         _beforeTokenTransfer(sender, recipient, amount);
549 
550         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
551         _balances[recipient] = _balances[recipient].add(amount);
552         emit Transfer(sender, recipient, amount);
553     }
554 
555     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
556      * the total supply.
557      *
558      * Emits a {Transfer} event with `from` set to the zero address.
559      *
560      * Requirements
561      *
562      * - `to` cannot be the zero address.
563      */
564     function _mint(address account, uint256 amount) internal virtual {
565         require(account != address(0), "ERC20: mint to the zero address");
566 
567         _beforeTokenTransfer(address(0), account, amount);
568 
569         _totalSupply = _totalSupply.add(amount);
570         _balances[account] = _balances[account].add(amount);
571         emit Transfer(address(0), account, amount);
572     }
573 
574     /**
575      * @dev Destroys `amount` tokens from `account`, reducing the
576      * total supply.
577      *
578      * Emits a {Transfer} event with `to` set to the zero address.
579      *
580      * Requirements
581      *
582      * - `account` cannot be the zero address.
583      * - `account` must have at least `amount` tokens.
584      */
585     function _burn(address account, uint256 amount) internal virtual {
586         require(account != address(0), "ERC20: burn from the zero address");
587 
588         _beforeTokenTransfer(account, address(0), amount);
589 
590         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
591         _totalSupply = _totalSupply.sub(amount);
592         emit Transfer(account, address(0), amount);
593     }
594 
595     /**
596      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
597      *
598      * This is internal function is equivalent to `approve`, and can be used to
599      * e.g. set automatic allowances for certain subsystems, etc.
600      *
601      * Emits an {Approval} event.
602      *
603      * Requirements:
604      *
605      * - `owner` cannot be the zero address.
606      * - `spender` cannot be the zero address.
607      */
608     function _approve(address owner, address spender, uint256 amount) internal virtual {
609         require(owner != address(0), "ERC20: approve from the zero address");
610         require(spender != address(0), "ERC20: approve to the zero address");
611 
612         _allowances[owner][spender] = amount;
613         emit Approval(owner, spender, amount);
614     }
615 
616     /**
617      * @dev Sets {decimals} to a value other than the default one of 18.
618      *
619      * WARNING: This function should only be called from the constructor. Most
620      * applications that interact with token contracts will not expect
621      * {decimals} to ever change, and may work incorrectly if it does.
622      */
623     function _setupDecimals(uint8 decimals_) internal {
624         _decimals = decimals_;
625     }
626 
627     /**
628      * @dev Hook that is called before any transfer of tokens. This includes
629      * minting and burning.
630      *
631      * Calling conditions:
632      *
633      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
634      * will be to transferred to `to`.
635      * - when `from` is zero, `amount` tokens will be minted for `to`.
636      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
637      * - `from` and `to` are never both zero.
638      *
639      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
640      */
641     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
642 }
643 
644 
645 // File contracts/dependencies/open-zeppelin/Ownable.sol
646 
647 pragma solidity 0.7.5;
648 
649 /**
650  * @dev Contract module which provides a basic access control mechanism, where
651  * there is an account (an owner) that can be granted exclusive access to
652  * specific functions.
653  *
654  * By default, the owner account will be the one that deploys the contract. This
655  * can later be changed with {transferOwnership}.
656  *
657  * This module is used through inheritance. It will make available the modifier
658  * `onlyOwner`, which can be applied to your functions to restrict their use to
659  * the owner.
660  */
661 contract Ownable is Context {
662   address private _owner;
663 
664   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
665 
666   /**
667    * @dev Initializes the contract setting the deployer as the initial owner.
668    */
669   constructor() {
670     address msgSender = _msgSender();
671     _owner = msgSender;
672     emit OwnershipTransferred(address(0), msgSender);
673   }
674 
675   /**
676    * @dev Returns the address of the current owner.
677    */
678   function owner() public view returns (address) {
679     return _owner;
680   }
681 
682   /**
683    * @dev Throws if called by any account other than the owner.
684    */
685   modifier onlyOwner() {
686     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
687     _;
688   }
689 
690   /**
691    * @dev Leaves the contract without owner. It will not be possible to call
692    * `onlyOwner` functions anymore. Can only be called by the current owner.
693    *
694    * NOTE: Renouncing ownership will leave the contract without an owner,
695    * thereby removing any functionality that is only available to the owner.
696    */
697   function renounceOwnership() public virtual onlyOwner {
698     emit OwnershipTransferred(_owner, address(0));
699     _owner = address(0);
700   }
701 
702   /**
703    * @dev Transfers ownership of the contract to a new account (`newOwner`).
704    * Can only be called by the current owner.
705    */
706   function transferOwnership(address newOwner) public virtual onlyOwner {
707     require(newOwner != address(0), 'Ownable: new owner is the zero address');
708     emit OwnershipTransferred(_owner, newOwner);
709     _owner = newOwner;
710   }
711 }
712 
713 
714 // File contracts/interfaces/IGovernancePowerDelegationERC20.sol
715 
716 pragma solidity 0.7.5;
717 
718 interface IGovernancePowerDelegationERC20 {
719 
720   enum DelegationType {
721     VOTING_POWER,
722     PROPOSITION_POWER
723   }
724 
725   /**
726    * @dev Emitted when a user delegates governance power to another user.
727    *
728    * @param  delegator       The delegator.
729    * @param  delegatee       The delegatee.
730    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
731    */
732   event DelegateChanged(
733     address indexed delegator,
734     address indexed delegatee,
735     DelegationType delegationType
736   );
737 
738   /**
739    * @dev Emitted when an action changes the delegated power of a user.
740    *
741    * @param  user            The user whose delegated power has changed.
742    * @param  amount          The new amount of delegated power for the user.
743    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
744    */
745   event DelegatedPowerChanged(address indexed user, uint256 amount, DelegationType delegationType);
746 
747   /**
748    * @dev Delegates a specific governance power to a delegatee.
749    *
750    * @param  delegatee       The address to delegate power to.
751    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
752    */
753   function delegateByType(address delegatee, DelegationType delegationType) external virtual;
754 
755   /**
756    * @dev Delegates all governance powers to a delegatee.
757    *
758    * @param  delegatee  The user to which the power will be delegated.
759    */
760   function delegate(address delegatee) external virtual;
761 
762   /**
763    * @dev Returns the delegatee of an user.
764    *
765    * @param  delegator       The address of the delegator.
766    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
767    */
768   function getDelegateeByType(address delegator, DelegationType delegationType)
769     external
770     view
771     virtual
772     returns (address);
773 
774   /**
775    * @dev Returns the current delegated power of a user. The current power is the power delegated
776    *  at the time of the last snapshot.
777    *
778    * @param  user            The user whose power to query.
779    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
780    */
781   function getPowerCurrent(address user, DelegationType delegationType)
782     external
783     view
784     virtual
785     returns (uint256);
786 
787   /**
788    * @dev Returns the delegated power of a user at a certain block.
789    *
790    * @param  user            The user whose power to query.
791    * @param  blockNumber     The block number at which to get the user's power.
792    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
793    */
794   function getPowerAtBlock(
795     address user,
796     uint256 blockNumber,
797     DelegationType delegationType
798   )
799     external
800     view
801     virtual
802     returns (uint256);
803 }
804 
805 
806 // File contracts/governance/token/GovernancePowerDelegationERC20Mixin.sol
807 
808 pragma solidity 0.7.5;
809 
810 
811 
812 /**
813  * @title GovernancePowerDelegationERC20Mixin
814  * @author dYdX
815  *
816  * @dev Provides support for two types of governance powers, both endowed by the governance
817  *  token, and separately delegatable. Provides functions for delegation and for querying a user's
818  *  power at a certain block number.
819  */
820 abstract contract GovernancePowerDelegationERC20Mixin is
821   ERC20,
822   IGovernancePowerDelegationERC20
823 {
824   using SafeMath for uint256;
825 
826   // ============ Constants ============
827 
828   /// @notice EIP-712 typehash for delegation by signature of a specific governance power type.
829   bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH = keccak256(
830     'DelegateByType(address delegatee,uint256 type,uint256 nonce,uint256 expiry)'
831   );
832 
833   /// @notice EIP-712 typehash for delegation by signature of all governance powers.
834   bytes32 public constant DELEGATE_TYPEHASH = keccak256(
835     'Delegate(address delegatee,uint256 nonce,uint256 expiry)'
836   );
837 
838   // ============ Structs ============
839 
840   /// @dev Snapshot of a value on a specific block, used to track voting power for proposals.
841   struct Snapshot {
842     uint128 blockNumber;
843     uint128 value;
844   }
845 
846   // ============ External Functions ============
847 
848   /**
849    * @notice Delegates a specific governance power to a delegatee.
850    *
851    * @param  delegatee       The address to delegate power to.
852    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
853    */
854   function delegateByType(
855     address delegatee,
856     DelegationType delegationType
857   )
858     external
859     override
860   {
861     _delegateByType(msg.sender, delegatee, delegationType);
862   }
863 
864   /**
865    * @notice Delegates all governance powers to a delegatee.
866    *
867    * @param  delegatee  The address to delegate power to.
868    */
869   function delegate(
870     address delegatee
871   )
872     external
873     override
874   {
875     _delegateByType(msg.sender, delegatee, DelegationType.VOTING_POWER);
876     _delegateByType(msg.sender, delegatee, DelegationType.PROPOSITION_POWER);
877   }
878 
879   /**
880    * @notice Returns the delegatee of a user.
881    *
882    * @param  delegator       The address of the delegator.
883    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
884    */
885   function getDelegateeByType(
886     address delegator,
887     DelegationType delegationType
888   )
889     external
890     override
891     view
892     returns (address)
893   {
894     (, , mapping(address => address) storage delegates) = _getDelegationDataByType(delegationType);
895 
896     return _getDelegatee(delegator, delegates);
897   }
898 
899   /**
900    * @notice Returns the current power of a user. The current power is the power delegated
901    *  at the time of the last snapshot.
902    *
903    * @param  user            The user whose power to query.
904    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
905    */
906   function getPowerCurrent(
907     address user,
908     DelegationType delegationType
909   )
910     external
911     override
912     view
913     returns (uint256)
914   {
915     (
916       mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
917       mapping(address => uint256) storage snapshotsCounts,
918       // delegates
919     ) = _getDelegationDataByType(delegationType);
920 
921     return _searchByBlockNumber(snapshots, snapshotsCounts, user, block.number);
922   }
923 
924   /**
925    * @notice Returns the power of a user at a certain block.
926    *
927    * @param  user            The user whose power to query.
928    * @param  blockNumber     The block number at which to get the user's power.
929    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
930    */
931   function getPowerAtBlock(
932     address user,
933     uint256 blockNumber,
934     DelegationType delegationType
935   )
936     external
937     override
938     view
939     returns (uint256)
940   {
941     (
942       mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
943       mapping(address => uint256) storage snapshotsCounts,
944       // delegates
945     ) = _getDelegationDataByType(delegationType);
946 
947     return _searchByBlockNumber(snapshots, snapshotsCounts, user, blockNumber);
948   }
949 
950   // ============ Internal Functions ============
951 
952   /**
953    * @dev Delegates one specific power to a delegatee.
954    *
955    * @param  delegator       The user whose power to delegate.
956    * @param  delegatee       The address to delegate power to.
957    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
958    */
959   function _delegateByType(
960     address delegator,
961     address delegatee,
962     DelegationType delegationType
963   )
964     internal
965   {
966     require(
967       delegatee != address(0),
968       'INVALID_DELEGATEE'
969     );
970 
971     (, , mapping(address => address) storage delegates) = _getDelegationDataByType(delegationType);
972 
973     uint256 delegatorBalance = balanceOf(delegator);
974 
975     address previousDelegatee = _getDelegatee(delegator, delegates);
976 
977     delegates[delegator] = delegatee;
978 
979     _moveDelegatesByType(previousDelegatee, delegatee, delegatorBalance, delegationType);
980     emit DelegateChanged(delegator, delegatee, delegationType);
981   }
982 
983   /**
984    * @dev Moves power from one user to another.
985    *
986    * @param  from            The user from which delegated power is moved.
987    * @param  to              The user that will receive the delegated power.
988    * @param  amount          The amount of power to be moved.
989    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
990    */
991   function _moveDelegatesByType(
992     address from,
993     address to,
994     uint256 amount,
995     DelegationType delegationType
996   )
997     internal
998   {
999     if (from == to) {
1000       return;
1001     }
1002 
1003     (
1004       mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
1005       mapping(address => uint256) storage snapshotsCounts,
1006       // delegates
1007     ) = _getDelegationDataByType(delegationType);
1008 
1009     if (from != address(0)) {
1010       uint256 previous = 0;
1011       uint256 fromSnapshotsCount = snapshotsCounts[from];
1012 
1013       if (fromSnapshotsCount != 0) {
1014         previous = snapshots[from][fromSnapshotsCount - 1].value;
1015       } else {
1016         previous = balanceOf(from);
1017       }
1018 
1019       uint256 newAmount = previous.sub(amount);
1020       _writeSnapshot(
1021         snapshots,
1022         snapshotsCounts,
1023         from,
1024         uint128(newAmount)
1025       );
1026 
1027       emit DelegatedPowerChanged(from, newAmount, delegationType);
1028     }
1029 
1030     if (to != address(0)) {
1031       uint256 previous = 0;
1032       uint256 toSnapshotsCount = snapshotsCounts[to];
1033       if (toSnapshotsCount != 0) {
1034         previous = snapshots[to][toSnapshotsCount - 1].value;
1035       } else {
1036         previous = balanceOf(to);
1037       }
1038 
1039       uint256 newAmount = previous.add(amount);
1040       _writeSnapshot(
1041         snapshots,
1042         snapshotsCounts,
1043         to,
1044         uint128(newAmount)
1045       );
1046 
1047       emit DelegatedPowerChanged(to, newAmount, delegationType);
1048     }
1049   }
1050 
1051   /**
1052    * @dev Searches for a balance snapshot by block number using binary search.
1053    *
1054    * @param  snapshots        The mapping of snapshots by user.
1055    * @param  snapshotsCounts  The mapping of the number of snapshots by user.
1056    * @param  user             The user for which the snapshot is being searched.
1057    * @param  blockNumber      The block number being searched.
1058    */
1059   function _searchByBlockNumber(
1060     mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
1061     mapping(address => uint256) storage snapshotsCounts,
1062     address user,
1063     uint256 blockNumber
1064   )
1065     internal
1066     view
1067     returns (uint256)
1068   {
1069     require(
1070       blockNumber <= block.number,
1071       'INVALID_BLOCK_NUMBER'
1072     );
1073 
1074     uint256 snapshotsCount = snapshotsCounts[user];
1075 
1076     if (snapshotsCount == 0) {
1077       return balanceOf(user);
1078     }
1079 
1080     // First check most recent balance
1081     if (snapshots[user][snapshotsCount - 1].blockNumber <= blockNumber) {
1082       return snapshots[user][snapshotsCount - 1].value;
1083     }
1084 
1085     // Next check implicit zero balance
1086     if (snapshots[user][0].blockNumber > blockNumber) {
1087       return 0;
1088     }
1089 
1090     uint256 lower = 0;
1091     uint256 upper = snapshotsCount - 1;
1092     while (upper > lower) {
1093       uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1094       Snapshot memory snapshot = snapshots[user][center];
1095       if (snapshot.blockNumber == blockNumber) {
1096         return snapshot.value;
1097       } else if (snapshot.blockNumber < blockNumber) {
1098         lower = center;
1099       } else {
1100         upper = center - 1;
1101       }
1102     }
1103     return snapshots[user][lower].value;
1104   }
1105 
1106   /**
1107    * @dev Returns delegation data (snapshot, snapshotsCount, delegates) by delegation type.
1108    *
1109    *  Note: This mixin contract does not itself define any storage, and we require the inheriting
1110    *  contract to implement this method to provide access to the relevant mappings in storage.
1111    *  This pattern was implemented by Aave for legacy reasons and we have decided not to change it.
1112    *
1113    * @param  delegationType  The type of power (VOTING_POWER, PROPOSITION_POWER).
1114    */
1115   function _getDelegationDataByType(
1116     DelegationType delegationType
1117   )
1118     internal
1119     virtual
1120     view
1121     returns (
1122       mapping(address => mapping(uint256 => Snapshot)) storage, // snapshots
1123       mapping(address => uint256) storage, // snapshotsCount
1124       mapping(address => address) storage // delegates
1125     );
1126 
1127   /**
1128    * @dev Writes a snapshot of a user's token/power balance.
1129    *
1130    * @param  snapshots        The mapping of snapshots by user.
1131    * @param  snapshotsCounts  The mapping of the number of snapshots by user.
1132    * @param  owner            The user whose power to snapshot.
1133    * @param  newValue         The new balance to snapshot at the current block.
1134    */
1135   function _writeSnapshot(
1136     mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
1137     mapping(address => uint256) storage snapshotsCounts,
1138     address owner,
1139     uint128 newValue
1140   )
1141     internal
1142   {
1143     uint128 currentBlock = uint128(block.number);
1144 
1145     uint256 ownerSnapshotsCount = snapshotsCounts[owner];
1146     mapping(uint256 => Snapshot) storage ownerSnapshots = snapshots[owner];
1147 
1148     if (
1149       ownerSnapshotsCount != 0 &&
1150       ownerSnapshots[ownerSnapshotsCount - 1].blockNumber == currentBlock
1151     ) {
1152       // Doing multiple operations in the same block
1153       ownerSnapshots[ownerSnapshotsCount - 1].value = newValue;
1154     } else {
1155       ownerSnapshots[ownerSnapshotsCount] = Snapshot(currentBlock, newValue);
1156       snapshotsCounts[owner] = ownerSnapshotsCount + 1;
1157     }
1158   }
1159 
1160   /**
1161    * @dev Returns the delegatee of a user. If a user never performed any delegation, their
1162    *  delegated address will be 0x0, in which case we return the user's own address.
1163    *
1164    * @param  delegator  The address of the user for which return the delegatee.
1165    * @param  delegates  The mapping of delegates for a particular type of delegation.
1166    */
1167   function _getDelegatee(
1168     address delegator,
1169     mapping(address => address) storage delegates
1170   )
1171     internal
1172     view
1173     returns (address)
1174   {
1175     address previousDelegatee = delegates[delegator];
1176 
1177     if (previousDelegatee == address(0)) {
1178       return delegator;
1179     }
1180 
1181     return previousDelegatee;
1182   }
1183 }
1184 
1185 
1186 // File contracts/governance/token/DydxToken.sol
1187 
1188 pragma solidity 0.7.5;
1189 
1190 
1191 
1192 
1193 /**
1194  * @title DydxToken
1195  * @author dYdX
1196  *
1197  * @notice The dYdX governance token.
1198  */
1199 contract DydxToken is
1200   GovernancePowerDelegationERC20Mixin,
1201   Ownable
1202 {
1203   using SafeMath for uint256;
1204 
1205   // ============ Events ============
1206 
1207   /**
1208    * @dev Emitted when an address has been added to or removed from the token transfer allowlist.
1209    *
1210    * @param  account    Address that was added to or removed from the token transfer allowlist.
1211    * @param  isAllowed  True if the address was added to the allowlist, false if removed.
1212    */
1213   event TransferAllowlistUpdated(
1214     address account,
1215     bool isAllowed
1216   );
1217 
1218   /**
1219    * @dev Emitted when the transfer restriction timestamp is reassigned.
1220    *
1221    * @param  transfersRestrictedBefore  The new timestamp on and after which non-allowlisted
1222    *                                    transfers may occur.
1223    */
1224   event TransfersRestrictedBeforeUpdated(
1225     uint256 transfersRestrictedBefore
1226   );
1227 
1228   // ============ Constants ============
1229 
1230   string internal constant NAME = 'dYdX';
1231   string internal constant SYMBOL = 'DYDX';
1232 
1233   uint256 public constant INITIAL_SUPPLY = 1_000_000_000 ether;
1234 
1235   bytes32 public immutable DOMAIN_SEPARATOR;
1236   bytes public constant EIP712_VERSION = '1';
1237   bytes32 public constant EIP712_DOMAIN = keccak256(
1238     'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
1239   );
1240   bytes32 public constant PERMIT_TYPEHASH = keccak256(
1241     'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)'
1242   );
1243 
1244   /// @notice Minimum time between mints.
1245   uint256 public constant MINT_MIN_INTERVAL = 365 days;
1246 
1247   /// @notice Cap on the percentage of the total supply that can be minted at each mint.
1248   ///  Denominated in percentage points (units out of 100).
1249   uint256 public immutable MINT_MAX_PERCENT;
1250 
1251   /// @notice The timestamp on and after which the transfer restriction must be lifted.
1252   uint256 public immutable TRANSFER_RESTRICTION_LIFTED_NO_LATER_THAN;
1253 
1254   // ============ Storage ============
1255 
1256   /// @dev Mapping from (owner) => (next valid nonce) for EIP-712 signatures.
1257   mapping(address => uint256) internal _nonces;
1258 
1259   mapping(address => mapping(uint256 => Snapshot)) public _votingSnapshots;
1260   mapping(address => uint256) public _votingSnapshotsCounts;
1261   mapping(address => address) public _votingDelegates;
1262 
1263   mapping(address => mapping(uint256 => Snapshot)) public _propositionPowerSnapshots;
1264   mapping(address => uint256) public _propositionPowerSnapshotsCounts;
1265   mapping(address => address) public _propositionPowerDelegates;
1266 
1267   /// @notice Snapshots of the token total supply, at each block where the total supply has changed.
1268   mapping(uint256 => Snapshot) public _totalSupplySnapshots;
1269 
1270   /// @notice Number of snapshots of the token total supply.
1271   uint256 public _totalSupplySnapshotsCount;
1272 
1273   /// @notice Allowlist of addresses which may send or receive tokens while transfers are
1274   ///  otherwise restricted.
1275   mapping(address => bool) public _tokenTransferAllowlist;
1276 
1277   /// @notice The timestamp on and after which minting may occur.
1278   uint256 public _mintingRestrictedBefore;
1279 
1280   /// @notice The timestamp on and after which non-allowlisted transfers may occur.
1281   uint256 public _transfersRestrictedBefore;
1282 
1283   // ============ Constructor ============
1284 
1285   /**
1286    * @notice Constructor.
1287    *
1288    * @param  distributor                           The address which will receive the initial supply of tokens.
1289    * @param  transfersRestrictedBefore             Timestamp, before which transfers are restricted unless the
1290    *                                               origin or destination address is in the allowlist.
1291    * @param  transferRestrictionLiftedNoLaterThan  Timestamp, which is the maximum timestamp that transfer
1292    *                                               restrictions can be extended to.
1293    * @param  mintingRestrictedBefore               Timestamp, before which minting is not allowed.
1294    * @param  mintMaxPercent                        Cap on the percentage of the total supply that can be minted at
1295    *                                               each mint.
1296    */
1297   constructor(
1298     address distributor,
1299     uint256 transfersRestrictedBefore,
1300     uint256 transferRestrictionLiftedNoLaterThan,
1301     uint256 mintingRestrictedBefore,
1302     uint256 mintMaxPercent
1303   )
1304     ERC20(NAME, SYMBOL)
1305   {
1306     uint256 chainId;
1307 
1308     // solium-disable-next-line
1309     assembly {
1310       chainId := chainid()
1311     }
1312 
1313     DOMAIN_SEPARATOR = keccak256(
1314       abi.encode(
1315         EIP712_DOMAIN,
1316         keccak256(bytes(NAME)),
1317         keccak256(bytes(EIP712_VERSION)),
1318         chainId,
1319         address(this)
1320       )
1321     );
1322 
1323     // Validate and set parameters.
1324     require(
1325       transfersRestrictedBefore > block.timestamp,
1326       'TRANSFERS_RESTRICTED_BEFORE_TOO_EARLY'
1327     );
1328     require(
1329       transfersRestrictedBefore <= transferRestrictionLiftedNoLaterThan,
1330       'MAX_TRANSFER_RESTRICTION_TOO_EARLY'
1331     );
1332     require(
1333       mintingRestrictedBefore > block.timestamp,
1334       'MINTING_RESTRICTED_BEFORE_TOO_EARLY'
1335     );
1336     _transfersRestrictedBefore = transfersRestrictedBefore;
1337     TRANSFER_RESTRICTION_LIFTED_NO_LATER_THAN = transferRestrictionLiftedNoLaterThan;
1338     _mintingRestrictedBefore = mintingRestrictedBefore;
1339     MINT_MAX_PERCENT = mintMaxPercent;
1340 
1341     // Mint the initial supply.
1342     _mint(distributor, INITIAL_SUPPLY);
1343 
1344     emit TransfersRestrictedBeforeUpdated(transfersRestrictedBefore);
1345   }
1346 
1347   // ============ Other Functions ============
1348 
1349   /**
1350    * @notice Adds addresses to the token transfer allowlist. Reverts if any of the addresses
1351    *  already exist in the allowlist. Only callable by owner.
1352    *
1353    * @param  addressesToAdd  Addresses to add to the token transfer allowlist.
1354    */
1355   function addToTokenTransferAllowlist(
1356     address[] calldata addressesToAdd
1357   )
1358     external
1359     onlyOwner
1360   {
1361     for (uint256 i = 0; i < addressesToAdd.length; i++) {
1362       require(
1363         !_tokenTransferAllowlist[addressesToAdd[i]],
1364         'ADDRESS_EXISTS_IN_TRANSFER_ALLOWLIST'
1365       );
1366       _tokenTransferAllowlist[addressesToAdd[i]] = true;
1367       emit TransferAllowlistUpdated(addressesToAdd[i], true);
1368     }
1369   }
1370 
1371   /**
1372    * @notice Removes addresses from the token transfer allowlist. Reverts if any of the addresses
1373    *  don't exist in the allowlist. Only callable by owner.
1374    *
1375    * @param  addressesToRemove  Addresses to remove from the token transfer allowlist.
1376    */
1377   function removeFromTokenTransferAllowlist(
1378     address[] calldata addressesToRemove
1379   )
1380     external
1381     onlyOwner
1382   {
1383     for (uint256 i = 0; i < addressesToRemove.length; i++) {
1384       require(
1385         _tokenTransferAllowlist[addressesToRemove[i]],
1386         'ADDRESS_DOES_NOT_EXIST_IN_TRANSFER_ALLOWLIST'
1387       );
1388       _tokenTransferAllowlist[addressesToRemove[i]] = false;
1389       emit TransferAllowlistUpdated(addressesToRemove[i], false);
1390     }
1391   }
1392 
1393   /**
1394    * @notice Updates the transfer restriction. Reverts if the transfer restriction has already passed,
1395    *  the new transfer restriction is earlier than the previous one, or the new transfer restriction is
1396    *  after the maximum transfer restriction.
1397    *
1398    * @param  transfersRestrictedBefore  The timestamp on and after which non-allowlisted transfers may occur.
1399    */
1400   function updateTransfersRestrictedBefore(
1401     uint256 transfersRestrictedBefore
1402   )
1403     external
1404     onlyOwner
1405   {
1406     uint256 previousTransfersRestrictedBefore = _transfersRestrictedBefore;
1407     require(
1408       block.timestamp < previousTransfersRestrictedBefore,
1409       'TRANSFER_RESTRICTION_ENDED'
1410     );
1411     require(
1412       previousTransfersRestrictedBefore <= transfersRestrictedBefore,
1413       'NEW_TRANSFER_RESTRICTION_TOO_EARLY'
1414     );
1415     require(
1416       transfersRestrictedBefore <= TRANSFER_RESTRICTION_LIFTED_NO_LATER_THAN,
1417       'AFTER_MAX_TRANSFER_RESTRICTION'
1418     );
1419 
1420     _transfersRestrictedBefore = transfersRestrictedBefore;
1421 
1422     emit TransfersRestrictedBeforeUpdated(transfersRestrictedBefore);
1423   }
1424 
1425   /**
1426    * @notice Mint new tokens. Only callable by owner after the required time period has elapsed.
1427    *
1428    * @param  recipient  The address to receive minted tokens.
1429    * @param  amount     The number of tokens to mint.
1430    */
1431   function mint(
1432     address recipient,
1433     uint256 amount
1434   )
1435     external
1436     onlyOwner
1437   {
1438     require(
1439       block.timestamp >= _mintingRestrictedBefore,
1440       'MINT_TOO_EARLY'
1441     );
1442     require(
1443       amount <= totalSupply().mul(MINT_MAX_PERCENT).div(100),
1444       'MAX_MINT_EXCEEDED'
1445     );
1446 
1447     // Update the next allowed minting time.
1448     _mintingRestrictedBefore = block.timestamp.add(MINT_MIN_INTERVAL);
1449 
1450     // Mint the amount.
1451     _mint(recipient, amount);
1452   }
1453 
1454   /**
1455    * @notice Implements the permit function as specified in EIP-2612.
1456    *
1457    * @param  owner     Address of the token owner.
1458    * @param  spender   Address of the spender.
1459    * @param  value     Amount of allowance.
1460    * @param  deadline  Expiration timestamp for the signature.
1461    * @param  v         Signature param.
1462    * @param  r         Signature param.
1463    * @param  s         Signature param.
1464    */
1465   function permit(
1466     address owner,
1467     address spender,
1468     uint256 value,
1469     uint256 deadline,
1470     uint8 v,
1471     bytes32 r,
1472     bytes32 s
1473   )
1474     external
1475   {
1476     require(
1477       owner != address(0),
1478       'INVALID_OWNER'
1479     );
1480     require(
1481       block.timestamp <= deadline,
1482       'INVALID_EXPIRATION'
1483     );
1484     uint256 currentValidNonce = _nonces[owner];
1485     bytes32 digest = keccak256(
1486       abi.encodePacked(
1487         '\x19\x01',
1488         DOMAIN_SEPARATOR,
1489         keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
1490       )
1491     );
1492 
1493     require(
1494       owner == ecrecover(digest, v, r, s),
1495       'INVALID_SIGNATURE'
1496     );
1497     _nonces[owner] = currentValidNonce.add(1);
1498     _approve(owner, spender, value);
1499   }
1500 
1501   /**
1502    * @notice Get the next valid nonce for EIP-712 signatures.
1503    *
1504    *  This nonce should be used when signing for any of the following functions:
1505    *   - permit()
1506    *   - delegateByTypeBySig()
1507    *   - delegateBySig()
1508    */
1509   function nonces(
1510     address owner
1511   )
1512     external
1513     view
1514     returns (uint256)
1515   {
1516     return _nonces[owner];
1517   }
1518 
1519   function transfer(
1520     address recipient,
1521     uint256 amount
1522   )
1523     public
1524     override
1525     returns (bool)
1526   {
1527     _requireTransferAllowed(_msgSender(), recipient);
1528     return super.transfer(recipient, amount);
1529   }
1530 
1531   function transferFrom(
1532     address sender,
1533     address recipient,
1534     uint256 amount
1535   )
1536     public
1537     override
1538     returns (bool)
1539   {
1540     _requireTransferAllowed(sender, recipient);
1541     return super.transferFrom(sender, recipient, amount);
1542   }
1543 
1544   /**
1545    * @dev Override _mint() to write a snapshot whenever the total supply changes.
1546    *
1547    *  These snapshots are intended to be used by the governance strategy.
1548    *
1549    *  Note that the ERC20 _burn() function is never used. If desired, an official burn mechanism
1550    *  could be implemented external to this contract, and accounted for in the governance strategy.
1551    */
1552   function _mint(
1553     address account,
1554     uint256 amount
1555   )
1556     internal
1557     override
1558   {
1559     super._mint(account, amount);
1560 
1561     uint256 snapshotsCount = _totalSupplySnapshotsCount;
1562     uint128 currentBlock = uint128(block.number);
1563     uint128 newValue = uint128(totalSupply());
1564 
1565     // Note: There is no special case for the total supply being updated multiple times in the same
1566     // block. That should never occur.
1567     _totalSupplySnapshots[snapshotsCount] = Snapshot(currentBlock, newValue);
1568     _totalSupplySnapshotsCount = snapshotsCount.add(1);
1569   }
1570 
1571   function _requireTransferAllowed(
1572     address sender,
1573     address recipient
1574   )
1575     view
1576     internal
1577   {
1578     // Compare against the constant `TRANSFER_RESTRICTION_LIFTED_NO_LATER_THAN` first
1579     // to avoid additional gas costs from reading from storage.
1580     if (
1581       block.timestamp < TRANSFER_RESTRICTION_LIFTED_NO_LATER_THAN &&
1582       block.timestamp < _transfersRestrictedBefore
1583     ) {
1584       // While transfers are restricted, a transfer is permitted if either the sender or the
1585       // recipient is on the allowlist.
1586       require(
1587         _tokenTransferAllowlist[sender] || _tokenTransferAllowlist[recipient],
1588         'NON_ALLOWLIST_TRANSFERS_DISABLED'
1589       );
1590     }
1591   }
1592 
1593   /**
1594    * @dev Writes a snapshot before any transfer operation, including: _transfer, _mint and _burn.
1595    *  - On _transfer, it writes snapshots for both 'from' and 'to'.
1596    *  - On _mint, only for `to`.
1597    *  - On _burn, only for `from`.
1598    *
1599    * @param  from    The sender.
1600    * @param  to      The recipient.
1601    * @param  amount  The amount being transfered.
1602    */
1603   function _beforeTokenTransfer(
1604     address from,
1605     address to,
1606     uint256 amount
1607   )
1608     internal
1609     override
1610   {
1611     address votingFromDelegatee = _getDelegatee(from, _votingDelegates);
1612     address votingToDelegatee = _getDelegatee(to, _votingDelegates);
1613 
1614     _moveDelegatesByType(
1615       votingFromDelegatee,
1616       votingToDelegatee,
1617       amount,
1618       DelegationType.VOTING_POWER
1619     );
1620 
1621     address propPowerFromDelegatee = _getDelegatee(from, _propositionPowerDelegates);
1622     address propPowerToDelegatee = _getDelegatee(to, _propositionPowerDelegates);
1623 
1624     _moveDelegatesByType(
1625       propPowerFromDelegatee,
1626       propPowerToDelegatee,
1627       amount,
1628       DelegationType.PROPOSITION_POWER
1629     );
1630   }
1631 
1632   function _getDelegationDataByType(
1633     DelegationType delegationType
1634   )
1635     internal
1636     override
1637     view
1638     returns (
1639       mapping(address => mapping(uint256 => Snapshot)) storage, // snapshots
1640       mapping(address => uint256) storage, // snapshots count
1641       mapping(address => address) storage // delegatees list
1642     )
1643   {
1644     if (delegationType == DelegationType.VOTING_POWER) {
1645       return (_votingSnapshots, _votingSnapshotsCounts, _votingDelegates);
1646     } else {
1647       return (
1648         _propositionPowerSnapshots,
1649         _propositionPowerSnapshotsCounts,
1650         _propositionPowerDelegates
1651       );
1652     }
1653   }
1654 
1655   /**
1656    * @dev Delegates specific governance power from signer to `delegatee` using an EIP-712 signature.
1657    *
1658    * @param  delegatee       The address to delegate votes to.
1659    * @param  delegationType  The type of delegation (VOTING_POWER, PROPOSITION_POWER).
1660    * @param  nonce           The signer's nonce for EIP-712 signatures on this contract.
1661    * @param  expiry          Expiration timestamp for the signature.
1662    * @param  v               Signature param.
1663    * @param  r               Signature param.
1664    * @param  s               Signature param.
1665    */
1666   function delegateByTypeBySig(
1667     address delegatee,
1668     DelegationType delegationType,
1669     uint256 nonce,
1670     uint256 expiry,
1671     uint8 v,
1672     bytes32 r,
1673     bytes32 s
1674   )
1675     public
1676   {
1677     bytes32 structHash = keccak256(
1678       abi.encode(DELEGATE_BY_TYPE_TYPEHASH, delegatee, uint256(delegationType), nonce, expiry)
1679     );
1680     bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash));
1681     address signer = ecrecover(digest, v, r, s);
1682     require(
1683       signer != address(0),
1684       'INVALID_SIGNATURE'
1685     );
1686     require(
1687       nonce == _nonces[signer]++,
1688       'INVALID_NONCE'
1689     );
1690     require(
1691       block.timestamp <= expiry,
1692       'INVALID_EXPIRATION'
1693     );
1694     _delegateByType(signer, delegatee, delegationType);
1695   }
1696 
1697   /**
1698    * @dev Delegates both governance powers from signer to `delegatee` using an EIP-712 signature.
1699    *
1700    * @param  delegatee  The address to delegate votes to.
1701    * @param  nonce      The signer's nonce for EIP-712 signatures on this contract.
1702    * @param  expiry     Expiration timestamp for the signature.
1703    * @param  v          Signature param.
1704    * @param  r          Signature param.
1705    * @param  s          Signature param.
1706    */
1707   function delegateBySig(
1708     address delegatee,
1709     uint256 nonce,
1710     uint256 expiry,
1711     uint8 v,
1712     bytes32 r,
1713     bytes32 s
1714   )
1715     public
1716   {
1717     bytes32 structHash = keccak256(abi.encode(DELEGATE_TYPEHASH, delegatee, nonce, expiry));
1718     bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash));
1719     address signer = ecrecover(digest, v, r, s);
1720     require(
1721       signer != address(0),
1722       'INVALID_SIGNATURE'
1723     );
1724     require(
1725       nonce == _nonces[signer]++,
1726       'INVALID_NONCE'
1727     );
1728     require(
1729       block.timestamp <= expiry,
1730       'INVALID_EXPIRATION'
1731     );
1732     _delegateByType(signer, delegatee, DelegationType.VOTING_POWER);
1733     _delegateByType(signer, delegatee, DelegationType.PROPOSITION_POWER);
1734   }
1735 }