1 // /////////////////////////////////////////////////////////////////////////////// //
2 //                                                                                 //
3 // This is the source code of the contract for PSHP, platform token of Payship.org //
4 // Deployed by Veronika Voss                                                       //
5 //                                                                                 //
6 //   //////  //////  //  //  //////                                                //
7 //   //  //  //      //  //  //  //                                                //
8 //   //////  //////  //////  //////                                                //
9 //   //          //  //  //  //                                                    //
10 //   //      //////  //  //  //                                                    //
11 //                                                                                 //
12 // /////////////////////////////////////////////////////////////////////////////// //
13 
14 // File: @openzeppelin/contracts/GSN/Context.sol
15 
16 pragma solidity ^0.6.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 contract Context {
29     // Empty internal constructor, to prevent people from mistakenly deploying
30     // an instance of this contract, which should be used via inheritance.
31     constructor () internal { }
32 
33     function _msgSender() internal view virtual returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/math/SafeMath.sol
44 
45 pragma solidity ^0.6.0;
46 
47 /**
48  * @dev Wrappers over Solidity's arithmetic operations with added overflow
49  * checks.
50  *
51  * Arithmetic operations in Solidity wrap on overflow. This can easily result
52  * in bugs, because programmers usually assume that an overflow raises an
53  * error, which is the standard behavior in high level programming languages.
54  * `SafeMath` restores this intuition by reverting the transaction when an
55  * operation overflows.
56  *
57  * Using this library instead of the unchecked operations eliminates an entire
58  * class of bugs, so it's recommended to use it always.
59  */
60 library SafeMath {
61     /**
62      * @dev Returns the addition of two unsigned integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `+` operator.
66      *
67      * Requirements:
68      * - Addition cannot overflow.
69      */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      * - Subtraction cannot overflow.
98      */
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b != 0, errorMessage);
192         return a % b;
193     }
194 }
195 
196 // File: @openzeppelin/contracts/access/Ownable.sol
197 
198 pragma solidity ^0.6.0;
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor () internal {
221         address msgSender = _msgSender();
222         _owner = msgSender;
223         emit OwnershipTransferred(address(0), msgSender);
224     }
225 
226     /**
227      * @dev Returns the address of the current owner.
228      */
229     function owner() public view returns (address) {
230         return _owner;
231     }
232 
233     /**
234      * @dev Throws if called by any account other than the owner.
235      */
236     modifier onlyOwner() {
237         require(_owner == _msgSender(), "Ownable: caller is not the owner");
238         _;
239     }
240 
241     /**
242      * @dev Leaves the contract without owner. It will not be possible to call
243      * `onlyOwner` functions anymore. Can only be called by the current owner.
244      *
245      * NOTE: Renouncing ownership will leave the contract without an owner,
246      * thereby removing any functionality that is only available to the owner.
247      */
248     function renounceOwnership() public virtual onlyOwner {
249         emit OwnershipTransferred(_owner, address(0));
250         _owner = address(0);
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 pragma solidity ^0.6.2;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
326 
327 pragma solidity ^0.6.0;
328 
329 /**
330  * @dev Interface of the ERC20 standard as defined in the EIP.
331  */
332 interface IERC20 {
333     /**
334      * @dev Returns the amount of tokens in existence.
335      */
336     function totalSupply() external view returns (uint256);
337 
338     /**
339      * @dev Returns the amount of tokens owned by `account`.
340      */
341     function balanceOf(address account) external view returns (uint256);
342 
343     /**
344      * @dev Moves `amount` tokens from the caller's account to `recipient`.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * Emits a {Transfer} event.
349      */
350     function transfer(address recipient, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Returns the remaining number of tokens that `spender` will be
354      * allowed to spend on behalf of `owner` through {transferFrom}. This is
355      * zero by default.
356      *
357      * This value changes when {approve} or {transferFrom} are called.
358      */
359     function allowance(address owner, address spender) external view returns (uint256);
360 
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * IMPORTANT: Beware that changing an allowance with this method brings the risk
367      * that someone may use both the old and the new allowance by unfortunate
368      * transaction ordering. One possible solution to mitigate this race
369      * condition is to first reduce the spender's allowance to 0 and set the
370      * desired value afterwards:
371      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
372      *
373      * Emits an {Approval} event.
374      */
375     function approve(address spender, uint256 amount) external returns (bool);
376 
377     /**
378      * @dev Moves `amount` tokens from `sender` to `recipient` using the
379      * allowance mechanism. `amount` is then deducted from the caller's
380      * allowance.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Emitted when `value` tokens are moved from one account (`from`) to
390      * another (`to`).
391      *
392      * Note that `value` may be zero.
393      */
394     event Transfer(address indexed from, address indexed to, uint256 value);
395 
396     /**
397      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
398      * a call to {approve}. `value` is the new allowance.
399      */
400     event Approval(address indexed owner, address indexed spender, uint256 value);
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
404 
405 pragma solidity ^0.6.0;
406 
407 /**
408  * @dev Implementation of the {IERC20} interface.
409  *
410  * This implementation is agnostic to the way tokens are created. This means
411  * that a supply mechanism has to be added in a derived contract using {_mint}.
412  * For a generic mechanism see {ERC20MinterPauser}.
413  *
414  * TIP: For a detailed writeup see our guide
415  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
416  * to implement supply mechanisms].
417  *
418  * We have followed general OpenZeppelin guidelines: functions revert instead
419  * of returning `false` on failure. This behavior is nonetheless conventional
420  * and does not conflict with the expectations of ERC20 applications.
421  *
422  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
423  * This allows applications to reconstruct the allowance for all accounts just
424  * by listening to said events. Other implementations of the EIP may not emit
425  * these events, as it isn't required by the specification.
426  *
427  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
428  * functions have been added to mitigate the well-known issues around setting
429  * allowances. See {IERC20-approve}.
430  */
431 contract ERC20 is Context, IERC20 {
432     using SafeMath for uint256;
433     using Address for address;
434 
435     mapping (address => uint256) private _balances;
436 
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     uint256 private _totalSupply;
440 
441     string private _name;
442     string private _symbol;
443     uint8 private _decimals;
444 
445     /**
446      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
447      * a default value of 18.
448      *
449      * To select a different value for {decimals}, use {_setupDecimals}.
450      *
451      * All three of these values are immutable: they can only be set once during
452      * construction.
453      */
454     constructor (string memory name, string memory symbol) public {
455         _name = name;
456         _symbol = symbol;
457         _decimals = 18;
458     }
459 
460     /**
461      * @dev Returns the name of the token.
462      */
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     /**
468      * @dev Returns the symbol of the token, usually a shorter version of the
469      * name.
470      */
471     function symbol() public view returns (string memory) {
472         return _symbol;
473     }
474 
475     /**
476      * @dev Returns the number of decimals used to get its user representation.
477      * For example, if `decimals` equals `2`, a balance of `505` tokens should
478      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
479      *
480      * Tokens usually opt for a value of 18, imitating the relationship between
481      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
482      * called.
483      *
484      * NOTE: This information is only used for _display_ purposes: it in
485      * no way affects any of the arithmetic of the contract, including
486      * {IERC20-balanceOf} and {IERC20-transfer}.
487      */
488     function decimals() public view returns (uint8) {
489         return _decimals;
490     }
491 
492     /**
493      * @dev See {IERC20-totalSupply}.
494      */
495     function totalSupply() public view override returns (uint256) {
496         return _totalSupply;
497     }
498 
499     /**
500      * @dev See {IERC20-balanceOf}.
501      */
502     function balanceOf(address account) public view override returns (uint256) {
503         return _balances[account];
504     }
505 
506     /**
507      * @dev See {IERC20-transfer}.
508      *
509      * Requirements:
510      *
511      * - `recipient` cannot be the zero address.
512      * - the caller must have a balance of at least `amount`.
513      */
514     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
515         _transfer(_msgSender(), recipient, amount);
516         return true;
517     }
518 
519     /**
520      * @dev See {IERC20-allowance}.
521      */
522     function allowance(address owner, address spender) public view virtual override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     /**
527      * @dev See {IERC20-approve}.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      */
533     function approve(address spender, uint256 amount) public virtual override returns (bool) {
534         _approve(_msgSender(), spender, amount);
535         return true;
536     }
537 
538     /**
539      * @dev See {IERC20-transferFrom}.
540      *
541      * Emits an {Approval} event indicating the updated allowance. This is not
542      * required by the EIP. See the note at the beginning of {ERC20};
543      *
544      * Requirements:
545      * - `sender` and `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      * - the caller must have allowance for ``sender``'s tokens of at least
548      * `amount`.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(sender, recipient, amount);
552         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
553         return true;
554     }
555 
556     /**
557      * @dev Atomically increases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically decreases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      * - `spender` must have allowance for the caller of at least
585      * `subtractedValue`.
586      */
587     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
588         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
589         return true;
590     }
591 
592     /**
593      * @dev Moves tokens `amount` from `sender` to `recipient`.
594      *
595      * This is internal function is equivalent to {transfer}, and can be used to
596      * e.g. implement automatic token fees, slashing mechanisms, etc.
597      *
598      * Emits a {Transfer} event.
599      *
600      * Requirements:
601      *
602      * - `sender` cannot be the zero address.
603      * - `recipient` cannot be the zero address.
604      * - `sender` must have a balance of at least `amount`.
605      */
606     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
607         require(sender != address(0), "ERC20: transfer from the zero address");
608         require(recipient != address(0), "ERC20: transfer to the zero address");
609 
610         _beforeTokenTransfer(sender, recipient, amount);
611 
612         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
613         _balances[recipient] = _balances[recipient].add(amount);
614         emit Transfer(sender, recipient, amount);
615     }
616 
617     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
618      * the total supply.
619      *
620      * Emits a {Transfer} event with `from` set to the zero address.
621      *
622      * Requirements
623      *
624      * - `to` cannot be the zero address.
625      */
626     function _mint(address account, uint256 amount) internal virtual {
627         require(account != address(0), "ERC20: mint to the zero address");
628 
629         _beforeTokenTransfer(address(0), account, amount);
630 
631         _totalSupply = _totalSupply.add(amount);
632         _balances[account] = _balances[account].add(amount);
633         emit Transfer(address(0), account, amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, reducing the
638      * total supply.
639      *
640      * Emits a {Transfer} event with `to` set to the zero address.
641      *
642      * Requirements
643      *
644      * - `account` cannot be the zero address.
645      * - `account` must have at least `amount` tokens.
646      */
647     function _burn(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: burn from the zero address");
649 
650         _beforeTokenTransfer(account, address(0), amount);
651 
652         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
653         _totalSupply = _totalSupply.sub(amount);
654         emit Transfer(account, address(0), amount);
655     }
656 
657     /**
658      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
659      *
660      * This is internal function is equivalent to `approve`, and can be used to
661      * e.g. set automatic allowances for certain subsystems, etc.
662      *
663      * Emits an {Approval} event.
664      *
665      * Requirements:
666      *
667      * - `owner` cannot be the zero address.
668      * - `spender` cannot be the zero address.
669      */
670     function _approve(address owner, address spender, uint256 amount) internal virtual {
671         require(owner != address(0), "ERC20: approve from the zero address");
672         require(spender != address(0), "ERC20: approve to the zero address");
673 
674         _allowances[owner][spender] = amount;
675         emit Approval(owner, spender, amount);
676     }
677 
678     /**
679      * @dev Sets {decimals} to a value other than the default one of 18.
680      *
681      * WARNING: This function should only be called from the constructor. Most
682      * applications that interact with token contracts will not expect
683      * {decimals} to ever change, and may work incorrectly if it does.
684      */
685     function _setupDecimals(uint8 decimals_) internal {
686         _decimals = decimals_;
687     }
688 
689     /**
690      * @dev Hook that is called before any transfer of tokens. This includes
691      * minting and burning.
692      *
693      * Calling conditions:
694      *
695      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
696      * will be to transferred to `to`.
697      * - when `from` is zero, `amount` tokens will be minted for `to`.
698      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
699      * - `from` and `to` are never both zero.
700      *
701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
702      */
703     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
707 
708 pragma solidity ^0.6.0;
709 
710 /**
711  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
712  */
713 abstract contract ERC20Capped is ERC20 {
714     uint256 private _cap;
715 
716     /**
717      * @dev Sets the value of the `cap`. This value is immutable, it can only be
718      * set once during construction.
719      */
720     constructor (uint256 cap) public {
721         require(cap > 0, "ERC20Capped: cap is 0");
722         _cap = cap;
723     }
724 
725     /**
726      * @dev Returns the cap on the token's total supply.
727      */
728     function cap() public view returns (uint256) {
729         return _cap;
730     }
731 
732     /**
733      * @dev See {ERC20-_beforeTokenTransfer}.
734      *
735      * Requirements:
736      *
737      * - minted tokens must not cause the total supply to go over the cap.
738      */
739     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
740         super._beforeTokenTransfer(from, to, amount);
741 
742         if (from == address(0)) { // When minting tokens
743             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
744         }
745     }
746 }
747 
748 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
749 
750 pragma solidity ^0.6.0;
751 
752 /**
753  * @dev Extension of {ERC20} that allows token holders to destroy both their own
754  * tokens and those that they have an allowance for, in a way that can be
755  * recognized off-chain (via event analysis).
756  */
757 abstract contract ERC20Burnable is Context, ERC20 {
758     /**
759      * @dev Destroys `amount` tokens from the caller.
760      *
761      * See {ERC20-_burn}.
762      */
763     function burn(uint256 amount) public virtual {
764         _burn(_msgSender(), amount);
765     }
766 
767     /**
768      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
769      * allowance.
770      *
771      * See {ERC20-_burn} and {ERC20-allowance}.
772      *
773      * Requirements:
774      *
775      * - the caller must have allowance for ``accounts``'s tokens of at least
776      * `amount`.
777      */
778     function burnFrom(address account, uint256 amount) public virtual {
779         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
780 
781         _approve(account, _msgSender(), decreasedAllowance);
782         _burn(account, amount);
783     }
784 }
785 
786 // File: @openzeppelin/contracts/introspection/IERC165.sol
787 
788 pragma solidity ^0.6.0;
789 
790 /**
791  * @dev Interface of the ERC165 standard, as defined in the
792  * https://eips.ethereum.org/EIPS/eip-165[EIP].
793  *
794  * Implementers can declare support of contract interfaces, which can then be
795  * queried by others ({ERC165Checker}).
796  *
797  * For an implementation, see {ERC165}.
798  */
799 interface IERC165 {
800     /**
801      * @dev Returns true if this contract implements the interface defined by
802      * `interfaceId`. See the corresponding
803      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
804      * to learn more about how these ids are created.
805      *
806      * This function call must use less than 30 000 gas.
807      */
808     function supportsInterface(bytes4 interfaceId) external view returns (bool);
809 }
810 
811 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
812 
813 pragma solidity ^0.6.2;
814 
815 /**
816  * @dev Library used to query support of an interface declared via {IERC165}.
817  *
818  * Note that these functions return the actual result of the query: they do not
819  * `revert` if an interface is not supported. It is up to the caller to decide
820  * what to do in these cases.
821  */
822 library ERC165Checker {
823     // As per the EIP-165 spec, no interface should ever match 0xffffffff
824     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
825 
826     /*
827      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
828      */
829     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
830 
831     /**
832      * @dev Returns true if `account` supports the {IERC165} interface,
833      */
834     function supportsERC165(address account) internal view returns (bool) {
835         // Any contract that implements ERC165 must explicitly indicate support of
836         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
837         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
838             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
839     }
840 
841     /**
842      * @dev Returns true if `account` supports the interface defined by
843      * `interfaceId`. Support for {IERC165} itself is queried automatically.
844      *
845      * See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
848         // query support of both ERC165 as per the spec and support of _interfaceId
849         return supportsERC165(account) &&
850             _supportsERC165Interface(account, interfaceId);
851     }
852 
853     /**
854      * @dev Returns true if `account` supports all the interfaces defined in
855      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
856      *
857      * Batch-querying can lead to gas savings by skipping repeated checks for
858      * {IERC165} support.
859      *
860      * See {IERC165-supportsInterface}.
861      */
862     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
863         // query support of ERC165 itself
864         if (!supportsERC165(account)) {
865             return false;
866         }
867 
868         // query support of each interface in _interfaceIds
869         for (uint256 i = 0; i < interfaceIds.length; i++) {
870             if (!_supportsERC165Interface(account, interfaceIds[i])) {
871                 return false;
872             }
873         }
874 
875         // all interfaces supported
876         return true;
877     }
878 
879     /**
880      * @notice Query if a contract implements an interface, does not check ERC165 support
881      * @param account The address of the contract to query for support of an interface
882      * @param interfaceId The interface identifier, as specified in ERC-165
883      * @return true if the contract at account indicates support of the interface with
884      * identifier interfaceId, false otherwise
885      * @dev Assumes that account contains a contract that supports ERC165, otherwise
886      * the behavior of this method is undefined. This precondition can be checked
887      * with {supportsERC165}.
888      * Interface identification is specified in ERC-165.
889      */
890     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
891         // success determines whether the staticcall succeeded and result determines
892         // whether the contract at account indicates support of _interfaceId
893         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
894 
895         return (success && result);
896     }
897 
898     /**
899      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
900      * @param account The address of the contract to query for support of an interface
901      * @param interfaceId The interface identifier, as specified in ERC-165
902      * @return success true if the STATICCALL succeeded, false otherwise
903      * @return result true if the STATICCALL succeeded and the contract at account
904      * indicates support of the interface with identifier interfaceId, false otherwise
905      */
906     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
907         private
908         view
909         returns (bool, bool)
910     {
911         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
912         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
913         if (result.length < 32) return (false, false);
914         return (success, abi.decode(result, (bool)));
915     }
916 }
917 
918 // File: @openzeppelin/contracts/introspection/ERC165.sol
919 
920 pragma solidity ^0.6.0;
921 
922 /**
923  * @dev Implementation of the {IERC165} interface.
924  *
925  * Contracts may inherit from this and call {_registerInterface} to declare
926  * their support of an interface.
927  */
928 contract ERC165 is IERC165 {
929     /*
930      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
931      */
932     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
933 
934     /**
935      * @dev Mapping of interface ids to whether or not it's supported.
936      */
937     mapping(bytes4 => bool) private _supportedInterfaces;
938 
939     constructor () internal {
940         // Derived contracts need only register support for their own interfaces,
941         // we register support for ERC165 itself here
942         _registerInterface(_INTERFACE_ID_ERC165);
943     }
944 
945     /**
946      * @dev See {IERC165-supportsInterface}.
947      *
948      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
949      */
950     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
951         return _supportedInterfaces[interfaceId];
952     }
953 
954     /**
955      * @dev Registers the contract as an implementer of the interface defined by
956      * `interfaceId`. Support of the actual ERC165 interface is automatic and
957      * registering its interface id is not required.
958      *
959      * See {IERC165-supportsInterface}.
960      *
961      * Requirements:
962      *
963      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
964      */
965     function _registerInterface(bytes4 interfaceId) internal virtual {
966         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
967         _supportedInterfaces[interfaceId] = true;
968     }
969 }
970 
971 // File: eth-token-recover/contracts/TokenRecover.sol
972 
973 pragma solidity ^0.6.0;
974 
975 /**
976  * @title TokenRecover
977  * @author Vittorio Minacori (https://github.com/vittominacori)
978  * @dev Allow to recover any ERC20 sent into the contract for error
979  */
980 contract TokenRecover is Ownable {
981 
982     /**
983      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
984      * @param tokenAddress The token contract address
985      * @param tokenAmount Number of tokens to be sent
986      */
987     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
988         IERC20(tokenAddress).transfer(owner(), tokenAmount);
989     }
990 }
991 
992 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
993 
994 pragma solidity ^0.6.0;
995 
996 /**
997  * @dev Library for managing
998  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
999  * types.
1000  *
1001  * Sets have the following properties:
1002  *
1003  * - Elements are added, removed, and checked for existence in constant time
1004  * (O(1)).
1005  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1006  *
1007  * ```
1008  * contract Example {
1009  *     // Add the library methods
1010  *     using EnumerableSet for EnumerableSet.AddressSet;
1011  *
1012  *     // Declare a set state variable
1013  *     EnumerableSet.AddressSet private mySet;
1014  * }
1015  * ```
1016  *
1017  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1018  * (`UintSet`) are supported.
1019  */
1020 library EnumerableSet {
1021     // To implement this library for multiple types with as little code
1022     // repetition as possible, we write it in terms of a generic Set type with
1023     // bytes32 values.
1024     // The Set implementation uses private functions, and user-facing
1025     // implementations (such as AddressSet) are just wrappers around the
1026     // underlying Set.
1027     // This means that we can only create new EnumerableSets for types that fit
1028     // in bytes32.
1029 
1030     struct Set {
1031         // Storage of set values
1032         bytes32[] _values;
1033 
1034         // Position of the value in the `values` array, plus 1 because index 0
1035         // means a value is not in the set.
1036         mapping (bytes32 => uint256) _indexes;
1037     }
1038 
1039     /**
1040      * @dev Add a value to a set. O(1).
1041      *
1042      * Returns true if the value was added to the set, that is if it was not
1043      * already present.
1044      */
1045     function _add(Set storage set, bytes32 value) private returns (bool) {
1046         if (!_contains(set, value)) {
1047             set._values.push(value);
1048             // The value is stored at length-1, but we add 1 to all indexes
1049             // and use 0 as a sentinel value
1050             set._indexes[value] = set._values.length;
1051             return true;
1052         } else {
1053             return false;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Removes a value from a set. O(1).
1059      *
1060      * Returns true if the value was removed from the set, that is if it was
1061      * present.
1062      */
1063     function _remove(Set storage set, bytes32 value) private returns (bool) {
1064         // We read and store the value's index to prevent multiple reads from the same storage slot
1065         uint256 valueIndex = set._indexes[value];
1066 
1067         if (valueIndex != 0) { // Equivalent to contains(set, value)
1068             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1069             // the array, and then remove the last element (sometimes called as 'swap and pop').
1070             // This modifies the order of the array, as noted in {at}.
1071 
1072             uint256 toDeleteIndex = valueIndex - 1;
1073             uint256 lastIndex = set._values.length - 1;
1074 
1075             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1076             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1077 
1078             bytes32 lastvalue = set._values[lastIndex];
1079 
1080             // Move the last value to the index where the value to delete is
1081             set._values[toDeleteIndex] = lastvalue;
1082             // Update the index for the moved value
1083             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1084 
1085             // Delete the slot where the moved value was stored
1086             set._values.pop();
1087 
1088             // Delete the index for the deleted slot
1089             delete set._indexes[value];
1090 
1091             return true;
1092         } else {
1093             return false;
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns true if the value is in the set. O(1).
1099      */
1100     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1101         return set._indexes[value] != 0;
1102     }
1103 
1104     /**
1105      * @dev Returns the number of values on the set. O(1).
1106      */
1107     function _length(Set storage set) private view returns (uint256) {
1108         return set._values.length;
1109     }
1110 
1111    /**
1112     * @dev Returns the value stored at position `index` in the set. O(1).
1113     *
1114     * Note that there are no guarantees on the ordering of values inside the
1115     * array, and it may change when more values are added or removed.
1116     *
1117     * Requirements:
1118     *
1119     * - `index` must be strictly less than {length}.
1120     */
1121     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1122         require(set._values.length > index, "EnumerableSet: index out of bounds");
1123         return set._values[index];
1124     }
1125 
1126     // AddressSet
1127 
1128     struct AddressSet {
1129         Set _inner;
1130     }
1131 
1132     /**
1133      * @dev Add a value to a set. O(1).
1134      *
1135      * Returns true if the value was added to the set, that is if it was not
1136      * already present.
1137      */
1138     function add(AddressSet storage set, address value) internal returns (bool) {
1139         return _add(set._inner, bytes32(uint256(value)));
1140     }
1141 
1142     /**
1143      * @dev Removes a value from a set. O(1).
1144      *
1145      * Returns true if the value was removed from the set, that is if it was
1146      * present.
1147      */
1148     function remove(AddressSet storage set, address value) internal returns (bool) {
1149         return _remove(set._inner, bytes32(uint256(value)));
1150     }
1151 
1152     /**
1153      * @dev Returns true if the value is in the set. O(1).
1154      */
1155     function contains(AddressSet storage set, address value) internal view returns (bool) {
1156         return _contains(set._inner, bytes32(uint256(value)));
1157     }
1158 
1159     /**
1160      * @dev Returns the number of values in the set. O(1).
1161      */
1162     function length(AddressSet storage set) internal view returns (uint256) {
1163         return _length(set._inner);
1164     }
1165 
1166    /**
1167     * @dev Returns the value stored at position `index` in the set. O(1).
1168     *
1169     * Note that there are no guarantees on the ordering of values inside the
1170     * array, and it may change when more values are added or removed.
1171     *
1172     * Requirements:
1173     *
1174     * - `index` must be strictly less than {length}.
1175     */
1176     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1177         return address(uint256(_at(set._inner, index)));
1178     }
1179 
1180 
1181     // UintSet
1182 
1183     struct UintSet {
1184         Set _inner;
1185     }
1186 
1187     /**
1188      * @dev Add a value to a set. O(1).
1189      *
1190      * Returns true if the value was added to the set, that is if it was not
1191      * already present.
1192      */
1193     function add(UintSet storage set, uint256 value) internal returns (bool) {
1194         return _add(set._inner, bytes32(value));
1195     }
1196 
1197     /**
1198      * @dev Removes a value from a set. O(1).
1199      *
1200      * Returns true if the value was removed from the set, that is if it was
1201      * present.
1202      */
1203     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1204         return _remove(set._inner, bytes32(value));
1205     }
1206 
1207     /**
1208      * @dev Returns true if the value is in the set. O(1).
1209      */
1210     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1211         return _contains(set._inner, bytes32(value));
1212     }
1213 
1214     /**
1215      * @dev Returns the number of values on the set. O(1).
1216      */
1217     function length(UintSet storage set) internal view returns (uint256) {
1218         return _length(set._inner);
1219     }
1220 
1221    /**
1222     * @dev Returns the value stored at position `index` in the set. O(1).
1223     *
1224     * Note that there are no guarantees on the ordering of values inside the
1225     * array, and it may change when more values are added or removed.
1226     *
1227     * Requirements:
1228     *
1229     * - `index` must be strictly less than {length}.
1230     */
1231     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1232         return uint256(_at(set._inner, index));
1233     }
1234 }
1235 
1236 // File: @openzeppelin/contracts/access/AccessControl.sol
1237 
1238 pragma solidity ^0.6.0;
1239 
1240 /**
1241  * @dev Contract module that allows children to implement role-based access
1242  * control mechanisms.
1243  *
1244  * Roles are referred to by their `bytes32` identifier. These should be exposed
1245  * in the external API and be unique. The best way to achieve this is by
1246  * using `public constant` hash digests:
1247  *
1248  * ```
1249  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1250  * ```
1251  *
1252  * Roles can be used to represent a set of permissions. To restrict access to a
1253  * function call, use {hasRole}:
1254  *
1255  * ```
1256  * function foo() public {
1257  *     require(hasRole(MY_ROLE, _msgSender()));
1258  *     ...
1259  * }
1260  * ```
1261  *
1262  * Roles can be granted and revoked dynamically via the {grantRole} and
1263  * {revokeRole} functions. Each role has an associated admin role, and only
1264  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1265  *
1266  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1267  * that only accounts with this role will be able to grant or revoke other
1268  * roles. More complex role relationships can be created by using
1269  * {_setRoleAdmin}.
1270  */
1271 abstract contract AccessControl is Context {
1272     using EnumerableSet for EnumerableSet.AddressSet;
1273     using Address for address;
1274 
1275     struct RoleData {
1276         EnumerableSet.AddressSet members;
1277         bytes32 adminRole;
1278     }
1279 
1280     mapping (bytes32 => RoleData) private _roles;
1281 
1282     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1283 
1284     /**
1285      * @dev Emitted when `account` is granted `role`.
1286      *
1287      * `sender` is the account that originated the contract call, an admin role
1288      * bearer except when using {_setupRole}.
1289      */
1290     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1291 
1292     /**
1293      * @dev Emitted when `account` is revoked `role`.
1294      *
1295      * `sender` is the account that originated the contract call:
1296      *   - if using `revokeRole`, it is the admin role bearer
1297      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1298      */
1299     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1300 
1301     /**
1302      * @dev Returns `true` if `account` has been granted `role`.
1303      */
1304     function hasRole(bytes32 role, address account) public view returns (bool) {
1305         return _roles[role].members.contains(account);
1306     }
1307 
1308     /**
1309      * @dev Returns the number of accounts that have `role`. Can be used
1310      * together with {getRoleMember} to enumerate all bearers of a role.
1311      */
1312     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1313         return _roles[role].members.length();
1314     }
1315 
1316     /**
1317      * @dev Returns one of the accounts that have `role`. `index` must be a
1318      * value between 0 and {getRoleMemberCount}, non-inclusive.
1319      *
1320      * Role bearers are not sorted in any particular way, and their ordering may
1321      * change at any point.
1322      *
1323      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1324      * you perform all queries on the same block. See the following
1325      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1326      * for more information.
1327      */
1328     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1329         return _roles[role].members.at(index);
1330     }
1331 
1332     /**
1333      * @dev Returns the admin role that controls `role`. See {grantRole} and
1334      * {revokeRole}.
1335      *
1336      * To change a role's admin, use {_setRoleAdmin}.
1337      */
1338     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1339         return _roles[role].adminRole;
1340     }
1341 
1342     /**
1343      * @dev Grants `role` to `account`.
1344      *
1345      * If `account` had not been already granted `role`, emits a {RoleGranted}
1346      * event.
1347      *
1348      * Requirements:
1349      *
1350      * - the caller must have ``role``'s admin role.
1351      */
1352     function grantRole(bytes32 role, address account) public virtual {
1353         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1354 
1355         _grantRole(role, account);
1356     }
1357 
1358     /**
1359      * @dev Revokes `role` from `account`.
1360      *
1361      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1362      *
1363      * Requirements:
1364      *
1365      * - the caller must have ``role``'s admin role.
1366      */
1367     function revokeRole(bytes32 role, address account) public virtual {
1368         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1369 
1370         _revokeRole(role, account);
1371     }
1372 
1373     /**
1374      * @dev Revokes `role` from the calling account.
1375      *
1376      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1377      * purpose is to provide a mechanism for accounts to lose their privileges
1378      * if they are compromised (such as when a trusted device is misplaced).
1379      *
1380      * If the calling account had been granted `role`, emits a {RoleRevoked}
1381      * event.
1382      *
1383      * Requirements:
1384      *
1385      * - the caller must be `account`.
1386      */
1387     function renounceRole(bytes32 role, address account) public virtual {
1388         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1389 
1390         _revokeRole(role, account);
1391     }
1392 
1393     /**
1394      * @dev Grants `role` to `account`.
1395      *
1396      * If `account` had not been already granted `role`, emits a {RoleGranted}
1397      * event. Note that unlike {grantRole}, this function doesn't perform any
1398      * checks on the calling account.
1399      *
1400      * [WARNING]
1401      * ====
1402      * This function should only be called from the constructor when setting
1403      * up the initial roles for the system.
1404      *
1405      * Using this function in any other way is effectively circumventing the admin
1406      * system imposed by {AccessControl}.
1407      * ====
1408      */
1409     function _setupRole(bytes32 role, address account) internal virtual {
1410         _grantRole(role, account);
1411     }
1412 
1413     /**
1414      * @dev Sets `adminRole` as ``role``'s admin role.
1415      */
1416     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1417         _roles[role].adminRole = adminRole;
1418     }
1419 
1420     function _grantRole(bytes32 role, address account) private {
1421         if (_roles[role].members.add(account)) {
1422             emit RoleGranted(role, account, _msgSender());
1423         }
1424     }
1425 
1426     function _revokeRole(bytes32 role, address account) private {
1427         if (_roles[role].members.remove(account)) {
1428             emit RoleRevoked(role, account, _msgSender());
1429         }
1430     }
1431 }
1432 
1433 // File: contracts/access/Roles.sol
1434 
1435 pragma solidity ^0.6.0;
1436 
1437 contract Roles is AccessControl {
1438 
1439     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1440     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1441 
1442     constructor () public {
1443         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1444         _setupRole(MINTER_ROLE, _msgSender());
1445         _setupRole(OPERATOR_ROLE, _msgSender());
1446     }
1447 
1448     modifier onlyMinter() {
1449         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1450         _;
1451     }
1452 
1453     modifier onlyOperator() {
1454         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1455         _;
1456     }
1457 }
1458 
1459 // File: contracts/PayshipToken.sol
1460 
1461 pragma solidity ^0.6.0;
1462 
1463 /**
1464  * @title PayshipToken
1465  * @author GitHub: @veravoss, @vittominacori
1466  * @dev Implementation of the PayshipToken
1467  */
1468 contract PayshipToken is ERC20Capped, ERC20Burnable, Roles, TokenRecover {
1469 
1470     // indicates if minting is finished
1471     bool private _mintingFinished = false;
1472 
1473     // indicates if transfer is enabled
1474     bool private _transferEnabled = false;
1475 
1476     string public constant BUILT_ON = "For https://payship.org by https://github.com/veravoss";
1477 
1478     /**
1479      * @dev Emitted during finish minting
1480      */
1481     event MintFinished();
1482 
1483     /**
1484      * @dev Emitted during transfer enabling
1485      */
1486     event TransferEnabled();
1487 
1488     /**
1489      * @dev Tokens can be minted only before minting finished.
1490      */
1491     modifier canMint() {
1492         require(!_mintingFinished, "PayshipToken: minting is finished");
1493         _;
1494     }
1495 
1496     /**
1497      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1498      */
1499     modifier canTransfer(address from) {
1500         require(
1501             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1502             "PayshipToken: transfer is not enabled or from does not have the OPERATOR role"
1503         );
1504         _;
1505     }
1506 
1507     /**
1508      * @param name Name of the token
1509      * @param symbol A symbol to be used as ticker
1510      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1511      * @param cap Maximum number of tokens mintable
1512      * @param initialSupply Initial token supply
1513      * @param transferEnabled If transfer is enabled on token creation
1514      * @param mintingFinished If minting is finished after token creation
1515      */
1516     constructor(
1517         string memory name,
1518         string memory symbol,
1519         uint8 decimals,
1520         uint256 cap,
1521         uint256 initialSupply,
1522         bool transferEnabled,
1523         bool mintingFinished
1524     )
1525         public
1526         ERC20Capped(cap)
1527         ERC20(name, symbol)
1528     {
1529         require(
1530             mintingFinished == false || cap == initialSupply,
1531             "PayshipToken: if finish minting, cap must be equal to initialSupply"
1532         );
1533 
1534         _setupDecimals(decimals);
1535 
1536         if (initialSupply > 0) {
1537             _mint(owner(), initialSupply);
1538         }
1539 
1540         if (mintingFinished) {
1541             finishMinting();
1542         }
1543 
1544         if (transferEnabled) {
1545             enableTransfer();
1546         }
1547     }
1548 
1549     /**
1550      * @return if minting is finished or not.
1551      */
1552     function mintingFinished() public view returns (bool) {
1553         return _mintingFinished;
1554     }
1555 
1556     /**
1557      * @return if transfer is enabled or not.
1558      */
1559     function transferEnabled() public view returns (bool) {
1560         return _transferEnabled;
1561     }
1562 
1563     /**
1564      * @dev Function to mint tokens.
1565      * @param to The address that will receive the minted tokens
1566      * @param value The amount of tokens to mint
1567      */
1568     function mint(address to, uint256 value) public canMint onlyMinter {
1569         _mint(to, value);
1570     }
1571 
1572     /**
1573      * @dev Transfer tokens to a specified address.
1574      * @param to The address to transfer to
1575      * @param value The amount to be transferred
1576      * @return A boolean that indicates if the operation was successful.
1577      */
1578     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1579         return super.transfer(to, value);
1580     }
1581 
1582     /**
1583      * @dev Transfer tokens from one address to another.
1584      * @param from The address which you want to send tokens from
1585      * @param to The address which you want to transfer to
1586      * @param value the amount of tokens to be transferred
1587      * @return A boolean that indicates if the operation was successful.
1588      */
1589     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1590         return super.transferFrom(from, to, value);
1591     }
1592 
1593     /**
1594      * @dev Function to stop minting new tokens.
1595      */
1596     function finishMinting() public canMint onlyOwner {
1597         _mintingFinished = true;
1598 
1599         emit MintFinished();
1600     }
1601 
1602     /**
1603      * @dev Function to enable transfers.
1604      */
1605     function enableTransfer() public onlyOwner {
1606         _transferEnabled = true;
1607 
1608         emit TransferEnabled();
1609     }
1610 
1611     /**
1612      * @dev See {ERC20-_beforeTokenTransfer}.
1613      */
1614     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1615         super._beforeTokenTransfer(from, to, amount);
1616     }
1617 }