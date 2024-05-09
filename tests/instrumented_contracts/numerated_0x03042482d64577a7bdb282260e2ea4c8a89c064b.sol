1 pragma solidity ^0.6.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18 
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // SPDX-License-Identifier: MIT
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () internal {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 /**
169  * @dev Wrappers over Solidity's arithmetic operations with added overflow
170  * checks.
171  *
172  * Arithmetic operations in Solidity wrap on overflow. This can easily result
173  * in bugs, because programmers usually assume that an overflow raises an
174  * error, which is the standard behavior in high level programming languages.
175  * `SafeMath` restores this intuition by reverting the transaction when an
176  * operation overflows.
177  *
178  * Using this library instead of the unchecked operations eliminates an entire
179  * class of bugs, so it's recommended to use it always.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         require(c >= a, "SafeMath: addition overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         return sub(a, b, "SafeMath: subtraction overflow");
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      * - Subtraction cannot overflow.
219      */
220     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b <= a, errorMessage);
222         uint256 c = a - b;
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `*` operator.
232      *
233      * Requirements:
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
238         // benefit is lost if 'b' is also tested.
239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         return div(a, b, "SafeMath: division by zero");
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      */
276     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         // Solidity only automatically asserts when dividing by 0
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return mod(a, b, "SafeMath: modulo by zero");
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts with custom message when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         require(b != 0, errorMessage);
313         return a % b;
314     }
315 }
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
340         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
341         // for accounts without code, i.e. `keccak256('')`
342         bytes32 codehash;
343         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
344         // solhint-disable-next-line no-inline-assembly
345         assembly { codehash := extcodehash(account) }
346         return (codehash != accountHash && codehash != 0x0);
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
369         (bool success, ) = recipient.call{ value: amount }("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 }
373 
374 /**
375  * @dev Implementation of the {IERC20} interface.
376  *
377  * This implementation is agnostic to the way tokens are created. This means
378  * that a supply mechanism has to be added in a derived contract using {_mint}.
379  * For a generic mechanism see {ERC20MinterPauser}.
380  *
381  * TIP: For a detailed writeup see our guide
382  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
383  * to implement supply mechanisms].
384  *
385  * We have followed general OpenZeppelin guidelines: functions revert instead
386  * of returning `false` on failure. This behavior is nonetheless conventional
387  * and does not conflict with the expectations of ERC20 applications.
388  *
389  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
390  * This allows applications to reconstruct the allowance for all accounts just
391  * by listening to said events. Other implementations of the EIP may not emit
392  * these events, as it isn't required by the specification.
393  *
394  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
395  * functions have been added to mitigate the well-known issues around setting
396  * allowances. See {IERC20-approve}.
397  */
398 contract ERC20 is Context, IERC20 {
399     using SafeMath for uint256;
400     using Address for address;
401 
402     mapping (address => uint256) private _balances;
403 
404     mapping (address => mapping (address => uint256)) private _allowances;
405 
406     uint256 private _totalSupply;
407 
408     string private _name;
409     string private _symbol;
410     uint8 private _decimals;
411 
412     /**
413      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
414      * a default value of 18.
415      *
416      * To select a different value for {decimals}, use {_setupDecimals}.
417      *
418      * All three of these values are immutable: they can only be set once during
419      * construction.
420      */
421     constructor (string memory name, string memory symbol) public {
422         _name = name;
423         _symbol = symbol;
424         _decimals = 18;
425     }
426 
427     /**
428      * @dev Returns the name of the token.
429      */
430     function name() public view returns (string memory) {
431         return _name;
432     }
433 
434     /**
435      * @dev Returns the symbol of the token, usually a shorter version of the
436      * name.
437      */
438     function symbol() public view returns (string memory) {
439         return _symbol;
440     }
441 
442     /**
443      * @dev Returns the number of decimals used to get its user representation.
444      * For example, if `decimals` equals `2`, a balance of `505` tokens should
445      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
446      *
447      * Tokens usually opt for a value of 18, imitating the relationship between
448      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
449      * called.
450      *
451      * NOTE: This information is only used for _display_ purposes: it in
452      * no way affects any of the arithmetic of the contract, including
453      * {IERC20-balanceOf} and {IERC20-transfer}.
454      */
455     function decimals() public view returns (uint8) {
456         return _decimals;
457     }
458 
459     /**
460      * @dev See {IERC20-totalSupply}.
461      */
462     function totalSupply() public view override returns (uint256) {
463         return _totalSupply;
464     }
465 
466     /**
467      * @dev See {IERC20-balanceOf}.
468      */
469     function balanceOf(address account) public view override returns (uint256) {
470         return _balances[account];
471     }
472 
473     /**
474      * @dev See {IERC20-transfer}.
475      *
476      * Requirements:
477      *
478      * - `recipient` cannot be the zero address.
479      * - the caller must have a balance of at least `amount`.
480      */
481     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(_msgSender(), recipient, amount);
483         return true;
484     }
485 
486     /**
487      * @dev See {IERC20-allowance}.
488      */
489     function allowance(address owner, address spender) public view virtual override returns (uint256) {
490         return _allowances[owner][spender];
491     }
492 
493     /**
494      * @dev See {IERC20-approve}.
495      *
496      * Requirements:
497      *
498      * - `spender` cannot be the zero address.
499      */
500     function approve(address spender, uint256 amount) public virtual override returns (bool) {
501         _approve(_msgSender(), spender, amount);
502         return true;
503     }
504 
505     /**
506      * @dev See {IERC20-transferFrom}.
507      *
508      * Emits an {Approval} event indicating the updated allowance. This is not
509      * required by the EIP. See the note at the beginning of {ERC20};
510      *
511      * Requirements:
512      * - `sender` and `recipient` cannot be the zero address.
513      * - `sender` must have a balance of at least `amount`.
514      * - the caller must have allowance for ``sender``'s tokens of at least
515      * `amount`.
516      */
517     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
518         _transfer(sender, recipient, amount);
519         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
520         return true;
521     }
522 
523     /**
524      * @dev Atomically increases the allowance granted to `spender` by the caller.
525      *
526      * This is an alternative to {approve} that can be used as a mitigation for
527      * problems described in {IERC20-approve}.
528      *
529      * Emits an {Approval} event indicating the updated allowance.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      */
535     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
536         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
537         return true;
538     }
539 
540     /**
541      * @dev Atomically decreases the allowance granted to `spender` by the caller.
542      *
543      * This is an alternative to {approve} that can be used as a mitigation for
544      * problems described in {IERC20-approve}.
545      *
546      * Emits an {Approval} event indicating the updated allowance.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      * - `spender` must have allowance for the caller of at least
552      * `subtractedValue`.
553      */
554     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
556         return true;
557     }
558 
559     /**
560      * @dev Moves tokens `amount` from `sender` to `recipient`.
561      *
562      * This is internal function is equivalent to {transfer}, and can be used to
563      * e.g. implement automatic token fees, slashing mechanisms, etc.
564      *
565      * Emits a {Transfer} event.
566      *
567      * Requirements:
568      *
569      * - `sender` cannot be the zero address.
570      * - `recipient` cannot be the zero address.
571      * - `sender` must have a balance of at least `amount`.
572      */
573     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
574         require(sender != address(0), "ERC20: transfer from the zero address");
575         require(recipient != address(0), "ERC20: transfer to the zero address");
576 
577         _beforeTokenTransfer(sender, recipient, amount);
578 
579         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
580         _balances[recipient] = _balances[recipient].add(amount);
581         emit Transfer(sender, recipient, amount);
582     }
583 
584     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
585      * the total supply.
586      *
587      * Emits a {Transfer} event with `from` set to the zero address.
588      *
589      * Requirements
590      *
591      * - `to` cannot be the zero address.
592      */
593     function _mint(address account, uint256 amount) internal virtual {
594         require(account != address(0), "ERC20: mint to the zero address");
595 
596         _beforeTokenTransfer(address(0), account, amount);
597 
598         _totalSupply = _totalSupply.add(amount);
599         _balances[account] = _balances[account].add(amount);
600         emit Transfer(address(0), account, amount);
601     }
602 
603     /**
604      * @dev Destroys `amount` tokens from `account`, reducing the
605      * total supply.
606      *
607      * Emits a {Transfer} event with `to` set to the zero address.
608      *
609      * Requirements
610      *
611      * - `account` cannot be the zero address.
612      * - `account` must have at least `amount` tokens.
613      */
614     function _burn(address account, uint256 amount) internal virtual {
615         require(account != address(0), "ERC20: burn from the zero address");
616 
617         _beforeTokenTransfer(account, address(0), amount);
618 
619         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
620         _totalSupply = _totalSupply.sub(amount);
621         emit Transfer(account, address(0), amount);
622     }
623 
624     /**
625      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
626      *
627      * This is internal function is equivalent to `approve`, and can be used to
628      * e.g. set automatic allowances for certain subsystems, etc.
629      *
630      * Emits an {Approval} event.
631      *
632      * Requirements:
633      *
634      * - `owner` cannot be the zero address.
635      * - `spender` cannot be the zero address.
636      */
637     function _approve(address owner, address spender, uint256 amount) internal virtual {
638         require(owner != address(0), "ERC20: approve from the zero address");
639         require(spender != address(0), "ERC20: approve to the zero address");
640 
641         _allowances[owner][spender] = amount;
642         emit Approval(owner, spender, amount);
643     }
644 
645     /**
646      * @dev Sets {decimals} to a value other than the default one of 18.
647      *
648      * WARNING: This function should only be called from the constructor. Most
649      * applications that interact with token contracts will not expect
650      * {decimals} to ever change, and may work incorrectly if it does.
651      */
652     function _setupDecimals(uint8 decimals_) internal {
653         _decimals = decimals_;
654     }
655 
656     /**
657      * @dev Hook that is called before any transfer of tokens. This includes
658      * minting and burning.
659      *
660      * Calling conditions:
661      *
662      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
663      * will be to transferred to `to`.
664      * - when `from` is zero, `amount` tokens will be minted for `to`.
665      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
666      * - `from` and `to` are never both zero.
667      *
668      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
669      */
670     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
671 }
672 
673 /**
674  * @dev Extension of {ERC20} that allows token holders to destroy both their own
675  * tokens and those that they have an allowance for, in a way that can be
676  * recognized off-chain (via event analysis).
677  */
678 abstract contract ERC20Burnable is Context, ERC20 {
679     /**
680      * @dev Destroys `amount` tokens from the caller.
681      *
682      * See {ERC20-_burn}.
683      */
684     function burn(uint256 amount) public virtual {
685         _burn(_msgSender(), amount);
686     }
687 
688     /**
689      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
690      * allowance.
691      *
692      * See {ERC20-_burn} and {ERC20-allowance}.
693      *
694      * Requirements:
695      *
696      * - the caller must have allowance for ``accounts``'s tokens of at least
697      * `amount`.
698      */
699     function burnFrom(address account, uint256 amount) public virtual {
700         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
701 
702         _approve(account, _msgSender(), decreasedAllowance);
703         _burn(account, amount);
704     }
705 }
706 
707 /**
708  * @dev Contract module which allows children to implement an emergency stop
709  * mechanism that can be triggered by an authorized account.
710  *
711  * This module is used through inheritance. It will make available the
712  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
713  * the functions of your contract. Note that they will not be pausable by
714  * simply including this module, only once the modifiers are put in place.
715  */
716 contract Pausable is Context {
717     /**
718      * @dev Emitted when the pause is triggered by `account`.
719      */
720     event Paused(address account);
721 
722     /**
723      * @dev Emitted when the pause is lifted by `account`.
724      */
725     event Unpaused(address account);
726 
727     bool private _paused;
728 
729     /**
730      * @dev Initializes the contract in unpaused state.
731      */
732     constructor () internal {
733         _paused = false;
734     }
735 
736     /**
737      * @dev Returns true if the contract is paused, and false otherwise.
738      */
739     function paused() public view returns (bool) {
740         return _paused;
741     }
742 
743     /**
744      * @dev Modifier to make a function callable only when the contract is not paused.
745      */
746     modifier whenNotPaused() {
747         require(!_paused, "Pausable: paused");
748         _;
749     }
750 
751     /**
752      * @dev Modifier to make a function callable only when the contract is paused.
753      */
754     modifier whenPaused() {
755         require(_paused, "Pausable: not paused");
756         _;
757     }
758 
759     /**
760      * @dev Triggers stopped state.
761      */
762     function _pause() internal virtual whenNotPaused {
763         _paused = true;
764         emit Paused(_msgSender());
765     }
766 
767     /**
768      * @dev Returns to normal state.
769      */
770     function _unpause() internal virtual whenPaused {
771         _paused = false;
772         emit Unpaused(_msgSender());
773     }
774 }
775 
776 /**
777  * @dev ERC20 token with pausable token transfers, minting and burning.
778  *
779  * Useful for scenarios such as preventing trades until the end of an evaluation
780  * period, or having an emergency switch for freezing all token transfers in the
781  * event of a large bug.
782  */
783 abstract contract ERC20Pausable is ERC20, Pausable {
784     /**
785      * @dev See {ERC20-_beforeTokenTransfer}.
786      *
787      * Requirements:
788      *
789      * - the contract must not be paused.
790      */
791     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
792         super._beforeTokenTransfer(from, to, amount);
793 
794         require(!paused(), "ERC20Pausable: token transfer while paused");
795     }
796 }
797 
798 contract CentaurToken is Context, Ownable, ERC20Burnable, ERC20Pausable {
799     uint256 public constant TOTAL_SUPPLY = 6000000000000000000000000000;
800 
801     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
802         _mint(_msgSender(), TOTAL_SUPPLY);
803     }
804 
805     function pause() public onlyOwner {
806         _pause();
807     }
808 
809     function unpause() public onlyOwner {
810         _unpause();
811     }
812 
813     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
814         super._beforeTokenTransfer(from, to, amount);
815     }
816 }