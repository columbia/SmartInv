1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
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
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
271 
272 
273 
274 pragma solidity >=0.6.0 <0.8.0;
275 
276 
277 
278 
279 /**
280  * @dev Implementation of the {IERC20} interface.
281  *
282  * This implementation is agnostic to the way tokens are created. This means
283  * that a supply mechanism has to be added in a derived contract using {_mint}.
284  * For a generic mechanism see {ERC20PresetMinterPauser}.
285  *
286  * TIP: For a detailed writeup see our guide
287  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
288  * to implement supply mechanisms].
289  *
290  * We have followed general OpenZeppelin guidelines: functions revert instead
291  * of returning `false` on failure. This behavior is nonetheless conventional
292  * and does not conflict with the expectations of ERC20 applications.
293  *
294  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
295  * This allows applications to reconstruct the allowance for all accounts just
296  * by listening to said events. Other implementations of the EIP may not emit
297  * these events, as it isn't required by the specification.
298  *
299  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
300  * functions have been added to mitigate the well-known issues around setting
301  * allowances. See {IERC20-approve}.
302  */
303 contract ERC20 is Context, IERC20 {
304     using SafeMath for uint256;
305 
306     mapping (address => uint256) private _balances;
307 
308     mapping (address => mapping (address => uint256)) private _allowances;
309 
310     uint256 private _totalSupply;
311 
312     string private _name;
313     string private _symbol;
314     uint8 private _decimals;
315 
316     /**
317      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
318      * a default value of 18.
319      *
320      * To select a different value for {decimals}, use {_setupDecimals}.
321      *
322      * All three of these values are immutable: they can only be set once during
323      * construction.
324      */
325     constructor (string memory name_, string memory symbol_) public {
326         _name = name_;
327         _symbol = symbol_;
328         _decimals = 18;
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
353      * called.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view virtual override returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20}.
414      *
415      * Requirements:
416      *
417      * - `sender` and `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      * - the caller must have allowance for ``sender``'s tokens of at least
420      * `amount`.
421      */
422     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
425         return true;
426     }
427 
428     /**
429      * @dev Atomically increases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
442         return true;
443     }
444 
445     /**
446      * @dev Atomically decreases the allowance granted to `spender` by the caller.
447      *
448      * This is an alternative to {approve} that can be used as a mitigation for
449      * problems described in {IERC20-approve}.
450      *
451      * Emits an {Approval} event indicating the updated allowance.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      * - `spender` must have allowance for the caller of at least
457      * `subtractedValue`.
458      */
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     /**
465      * @dev Moves tokens `amount` from `sender` to `recipient`.
466      *
467      * This is internal function is equivalent to {transfer}, and can be used to
468      * e.g. implement automatic token fees, slashing mechanisms, etc.
469      *
470      * Emits a {Transfer} event.
471      *
472      * Requirements:
473      *
474      * - `sender` cannot be the zero address.
475      * - `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      */
478     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `to` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _beforeTokenTransfer(address(0), account, amount);
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _beforeTokenTransfer(account, address(0), amount);
523 
524         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
525         _totalSupply = _totalSupply.sub(amount);
526         emit Transfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(address owner, address spender, uint256 amount) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Sets {decimals} to a value other than the default one of 18.
552      *
553      * WARNING: This function should only be called from the constructor. Most
554      * applications that interact with token contracts will not expect
555      * {decimals} to ever change, and may work incorrectly if it does.
556      */
557     function _setupDecimals(uint8 decimals_) internal {
558         _decimals = decimals_;
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be to transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
576 }
577 
578 // File: @openzeppelin/contracts/access/Ownable.sol
579 
580 
581 
582 pragma solidity >=0.6.0 <0.8.0;
583 
584 /**
585  * @dev Contract module which provides a basic access control mechanism, where
586  * there is an account (an owner) that can be granted exclusive access to
587  * specific functions.
588  *
589  * By default, the owner account will be the one that deploys the contract. This
590  * can later be changed with {transferOwnership}.
591  *
592  * This module is used through inheritance. It will make available the modifier
593  * `onlyOwner`, which can be applied to your functions to restrict their use to
594  * the owner.
595  */
596 abstract contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600 
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor () internal {
605         address msgSender = _msgSender();
606         _owner = msgSender;
607         emit OwnershipTransferred(address(0), msgSender);
608     }
609 
610     /**
611      * @dev Returns the address of the current owner.
612      */
613     function owner() public view returns (address) {
614         return _owner;
615     }
616 
617     /**
618      * @dev Throws if called by any account other than the owner.
619      */
620     modifier onlyOwner() {
621         require(_owner == _msgSender(), "Ownable: caller is not the owner");
622         _;
623     }
624 
625     /**
626      * @dev Leaves the contract without owner. It will not be possible to call
627      * `onlyOwner` functions anymore. Can only be called by the current owner.
628      *
629      * NOTE: Renouncing ownership will leave the contract without an owner,
630      * thereby removing any functionality that is only available to the owner.
631      */
632     function renounceOwnership() public virtual onlyOwner {
633         emit OwnershipTransferred(_owner, address(0));
634         _owner = address(0);
635     }
636 
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(newOwner != address(0), "Ownable: new owner is the zero address");
643         emit OwnershipTransferred(_owner, newOwner);
644         _owner = newOwner;
645     }
646 }
647 
648 // File: @openzeppelin/contracts/utils/Address.sol
649 
650 
651 
652 pragma solidity >=0.6.2 <0.8.0;
653 
654 /**
655  * @dev Collection of functions related to the address type
656  */
657 library Address {
658     /**
659      * @dev Returns true if `account` is a contract.
660      *
661      * [IMPORTANT]
662      * ====
663      * It is unsafe to assume that an address for which this function returns
664      * false is an externally-owned account (EOA) and not a contract.
665      *
666      * Among others, `isContract` will return false for the following
667      * types of addresses:
668      *
669      *  - an externally-owned account
670      *  - a contract in construction
671      *  - an address where a contract will be created
672      *  - an address where a contract lived, but was destroyed
673      * ====
674      */
675     function isContract(address account) internal view returns (bool) {
676         // This method relies on extcodesize, which returns 0 for contracts in
677         // construction, since the code is only stored at the end of the
678         // constructor execution.
679 
680         uint256 size;
681         // solhint-disable-next-line no-inline-assembly
682         assembly { size := extcodesize(account) }
683         return size > 0;
684     }
685 
686     /**
687      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
688      * `recipient`, forwarding all available gas and reverting on errors.
689      *
690      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
691      * of certain opcodes, possibly making contracts go over the 2300 gas limit
692      * imposed by `transfer`, making them unable to receive funds via
693      * `transfer`. {sendValue} removes this limitation.
694      *
695      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
696      *
697      * IMPORTANT: because control is transferred to `recipient`, care must be
698      * taken to not create reentrancy vulnerabilities. Consider using
699      * {ReentrancyGuard} or the
700      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
701      */
702     function sendValue(address payable recipient, uint256 amount) internal {
703         require(address(this).balance >= amount, "Address: insufficient balance");
704 
705         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
706         (bool success, ) = recipient.call{ value: amount }("");
707         require(success, "Address: unable to send value, recipient may have reverted");
708     }
709 
710     /**
711      * @dev Performs a Solidity function call using a low level `call`. A
712      * plain`call` is an unsafe replacement for a function call: use this
713      * function instead.
714      *
715      * If `target` reverts with a revert reason, it is bubbled up by this
716      * function (like regular Solidity function calls).
717      *
718      * Returns the raw returned data. To convert to the expected return value,
719      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
720      *
721      * Requirements:
722      *
723      * - `target` must be a contract.
724      * - calling `target` with `data` must not revert.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
729       return functionCall(target, data, "Address: low-level call failed");
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
734      * `errorMessage` as a fallback revert reason when `target` reverts.
735      *
736      * _Available since v3.1._
737      */
738     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
739         return functionCallWithValue(target, data, 0, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but also transferring `value` wei to `target`.
745      *
746      * Requirements:
747      *
748      * - the calling contract must have an ETH balance of at least `value`.
749      * - the called Solidity function must be `payable`.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
754         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
759      * with `errorMessage` as a fallback revert reason when `target` reverts.
760      *
761      * _Available since v3.1._
762      */
763     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
764         require(address(this).balance >= value, "Address: insufficient balance for call");
765         require(isContract(target), "Address: call to non-contract");
766 
767         // solhint-disable-next-line avoid-low-level-calls
768         (bool success, bytes memory returndata) = target.call{ value: value }(data);
769         return _verifyCallResult(success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
779         return functionStaticCall(target, data, "Address: low-level static call failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
784      * but performing a static call.
785      *
786      * _Available since v3.3._
787      */
788     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
789         require(isContract(target), "Address: static call to non-contract");
790 
791         // solhint-disable-next-line avoid-low-level-calls
792         (bool success, bytes memory returndata) = target.staticcall(data);
793         return _verifyCallResult(success, returndata, errorMessage);
794     }
795 
796     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
797         if (success) {
798             return returndata;
799         } else {
800             // Look for revert reason and bubble it up if present
801             if (returndata.length > 0) {
802                 // The easiest way to bubble the revert reason is using memory via assembly
803 
804                 // solhint-disable-next-line no-inline-assembly
805                 assembly {
806                     let returndata_size := mload(returndata)
807                     revert(add(32, returndata), returndata_size)
808                 }
809             } else {
810                 revert(errorMessage);
811             }
812         }
813     }
814 }
815 
816 // File: contracts/Summa.sol
817 
818 pragma solidity ^0.6.0;
819 
820 
821 
822 
823 interface ISummaPri {
824      function inviteCompetition(address from, address to) external;
825 }
826 
827 contract Summa is ERC20, Ownable {
828 
829     using Address for address;
830 
831     address public summaPri;
832 
833     uint256 public invite_amount = 0.01 * 10 ** 18;
834 
835     address public tokenIssue;
836 
837     constructor(uint256 initialSupply) public ERC20("SUM", "SUM") payable{
838         _mint(_msgSender(), initialSupply);
839     }
840 
841     function mine(address addr, uint256 amount) public onlyOwner {
842         _mint(addr, amount);
843     }
844 
845     function issue(address addr, uint256 amount) public {
846         require(_msgSender() == tokenIssue,"caller not allowed");
847         _mint(addr, amount);
848     }
849 
850     function burn(address addr, uint256 amount) public onlyOwner {
851         _burn(addr, amount);
852     }
853 
854     function updateSummaPri(address addr) public onlyOwner {
855         summaPri = addr;
856     }
857 
858     function updateTokenIssue(address addr) public onlyOwner {
859         tokenIssue = addr;
860     }
861 
862     function updateInviteAmount(uint256 amount) public onlyOwner {
863         invite_amount = amount;
864     }
865 
866     function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
867         if(!(to.isContract()) && !(from.isContract()) && summaPri != address(0) && value >= invite_amount){
868             ISummaPri(summaPri).inviteCompetition(from,to);
869         }
870         super._beforeTokenTransfer(from, to, value);
871     }
872 
873     function withdrawETH() public onlyOwner{
874         msg.sender.transfer(address(this).balance);
875     }
876 
877     function withdrawToken(address addr) public onlyOwner{
878         ERC20(addr).transfer(_msgSender(), ERC20(addr).balanceOf(address(this)));
879     }
880 
881     receive() external payable {
882     }
883 }