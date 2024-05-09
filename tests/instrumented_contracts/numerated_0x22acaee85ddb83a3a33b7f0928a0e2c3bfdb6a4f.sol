1 // File: @openzeppelin\contracts\math\SafeMath.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
162 
163 pragma solidity >=0.6.0 <0.8.0;
164 
165 /*
166  * @dev Provides information about the current execution context, including the
167  * sender of the transaction and its data. While these are generally available
168  * via msg.sender and msg.data, they should not be accessed in such a direct
169  * manner, since when dealing with GSN meta-transactions the account sending and
170  * paying for execution may not be the actual sender (as far as an application
171  * is concerned).
172  *
173  * This contract is only required for intermediate, library-like contracts.
174  */
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address payable) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes memory) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
187 
188 pragma solidity >=0.6.0 <0.8.0;
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through {transferFrom}. This is
216      * zero by default.
217      *
218      * This value changes when {approve} or {transferFrom} are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to {approve}. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
265 
266 pragma solidity >=0.6.0 <0.8.0;
267 
268 
269 
270 
271 /**
272  * @dev Implementation of the {IERC20} interface.
273  *
274  * This implementation is agnostic to the way tokens are created. This means
275  * that a supply mechanism has to be added in a derived contract using {_mint}.
276  * For a generic mechanism see {ERC20PresetMinterPauser}.
277  *
278  * TIP: For a detailed writeup see our guide
279  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
280  * to implement supply mechanisms].
281  *
282  * We have followed general OpenZeppelin guidelines: functions revert instead
283  * of returning `false` on failure. This behavior is nonetheless conventional
284  * and does not conflict with the expectations of ERC20 applications.
285  *
286  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
287  * This allows applications to reconstruct the allowance for all accounts just
288  * by listening to said events. Other implementations of the EIP may not emit
289  * these events, as it isn't required by the specification.
290  *
291  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
292  * functions have been added to mitigate the well-known issues around setting
293  * allowances. See {IERC20-approve}.
294  */
295 contract ERC20 is Context, IERC20 {
296     using SafeMath for uint256;
297 
298     mapping (address => uint256) private _balances;
299 
300     mapping (address => mapping (address => uint256)) private _allowances;
301 
302     uint256 private _totalSupply;
303 
304     string private _name;
305     string private _symbol;
306     uint8 private _decimals;
307 
308     /**
309      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
310      * a default value of 18.
311      *
312      * To select a different value for {decimals}, use {_setupDecimals}.
313      *
314      * All three of these values are immutable: they can only be set once during
315      * construction.
316      */
317     constructor (string memory name_, string memory symbol_) public {
318         _name = name_;
319         _symbol = symbol_;
320         _decimals = 18;
321     }
322 
323     /**
324      * @dev Returns the name of the token.
325      */
326     function name() public view returns (string memory) {
327         return _name;
328     }
329 
330     /**
331      * @dev Returns the symbol of the token, usually a shorter version of the
332      * name.
333      */
334     function symbol() public view returns (string memory) {
335         return _symbol;
336     }
337 
338     /**
339      * @dev Returns the number of decimals used to get its user representation.
340      * For example, if `decimals` equals `2`, a balance of `505` tokens should
341      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
342      *
343      * Tokens usually opt for a value of 18, imitating the relationship between
344      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
345      * called.
346      *
347      * NOTE: This information is only used for _display_ purposes: it in
348      * no way affects any of the arithmetic of the contract, including
349      * {IERC20-balanceOf} and {IERC20-transfer}.
350      */
351     function decimals() public view returns (uint8) {
352         return _decimals;
353     }
354 
355     /**
356      * @dev See {IERC20-totalSupply}.
357      */
358     function totalSupply() public view override returns (uint256) {
359         return _totalSupply;
360     }
361 
362     /**
363      * @dev See {IERC20-balanceOf}.
364      */
365     function balanceOf(address account) public view override returns (uint256) {
366         return _balances[account];
367     }
368 
369     /**
370      * @dev See {IERC20-transfer}.
371      *
372      * Requirements:
373      *
374      * - `recipient` cannot be the zero address.
375      * - the caller must have a balance of at least `amount`.
376      */
377     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
378         _transfer(_msgSender(), recipient, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-allowance}.
384      */
385     function allowance(address owner, address spender) public view virtual override returns (uint256) {
386         return _allowances[owner][spender];
387     }
388 
389     /**
390      * @dev See {IERC20-approve}.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount) public virtual override returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20}.
406      *
407      * Requirements:
408      *
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``sender``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
415         _transfer(sender, recipient, amount);
416         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
417         return true;
418     }
419 
420     /**
421      * @dev Atomically increases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      */
432     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
453         return true;
454     }
455 
456     /**
457      * @dev Moves tokens `amount` from `sender` to `recipient`.
458      *
459      * This is internal function is equivalent to {transfer}, and can be used to
460      * e.g. implement automatic token fees, slashing mechanisms, etc.
461      *
462      * Emits a {Transfer} event.
463      *
464      * Requirements:
465      *
466      * - `sender` cannot be the zero address.
467      * - `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      */
470     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
471         require(sender != address(0), "ERC20: transfer from the zero address");
472         require(recipient != address(0), "ERC20: transfer to the zero address");
473 
474         _beforeTokenTransfer(sender, recipient, amount);
475 
476         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
477         _balances[recipient] = _balances[recipient].add(amount);
478         emit Transfer(sender, recipient, amount);
479     }
480 
481     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `to` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _beforeTokenTransfer(address(0), account, amount);
494 
495         _totalSupply = _totalSupply.add(amount);
496         _balances[account] = _balances[account].add(amount);
497         emit Transfer(address(0), account, amount);
498     }
499 
500     /**
501      * @dev Destroys `amount` tokens from `account`, reducing the
502      * total supply.
503      *
504      * Emits a {Transfer} event with `to` set to the zero address.
505      *
506      * Requirements:
507      *
508      * - `account` cannot be the zero address.
509      * - `account` must have at least `amount` tokens.
510      */
511     function _burn(address account, uint256 amount) internal virtual {
512         require(account != address(0), "ERC20: burn from the zero address");
513 
514         _beforeTokenTransfer(account, address(0), amount);
515 
516         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
517         _totalSupply = _totalSupply.sub(amount);
518         emit Transfer(account, address(0), amount);
519     }
520 
521     /**
522      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
523      *
524      * This internal function is equivalent to `approve`, and can be used to
525      * e.g. set automatic allowances for certain subsystems, etc.
526      *
527      * Emits an {Approval} event.
528      *
529      * Requirements:
530      *
531      * - `owner` cannot be the zero address.
532      * - `spender` cannot be the zero address.
533      */
534     function _approve(address owner, address spender, uint256 amount) internal virtual {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = amount;
539         emit Approval(owner, spender, amount);
540     }
541 
542     /**
543      * @dev Sets {decimals} to a value other than the default one of 18.
544      *
545      * WARNING: This function should only be called from the constructor. Most
546      * applications that interact with token contracts will not expect
547      * {decimals} to ever change, and may work incorrectly if it does.
548      */
549     function _setupDecimals(uint8 decimals_) internal {
550         _decimals = decimals_;
551     }
552 
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be to transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
568 }
569 
570 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
571 
572 pragma solidity >=0.6.0 <0.8.0;
573 
574 
575 
576 /**
577  * @dev Extension of {ERC20} that allows token holders to destroy both their own
578  * tokens and those that they have an allowance for, in a way that can be
579  * recognized off-chain (via event analysis).
580  */
581 abstract contract ERC20Burnable is Context, ERC20 {
582     using SafeMath for uint256;
583 
584     /**
585      * @dev Destroys `amount` tokens from the caller.
586      *
587      * See {ERC20-_burn}.
588      */
589     function burn(uint256 amount) public virtual {
590         _burn(_msgSender(), amount);
591     }
592 
593     /**
594      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
595      * allowance.
596      *
597      * See {ERC20-_burn} and {ERC20-allowance}.
598      *
599      * Requirements:
600      *
601      * - the caller must have allowance for ``accounts``'s tokens of at least
602      * `amount`.
603      */
604     function burnFrom(address account, uint256 amount) public virtual {
605         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
606 
607         _approve(account, _msgSender(), decreasedAllowance);
608         _burn(account, amount);
609     }
610 }
611 
612 // File: @openzeppelin\contracts\access\Ownable.sol
613 
614 pragma solidity >=0.6.0 <0.8.0;
615 
616 /**
617  * @dev Contract module which provides a basic access control mechanism, where
618  * there is an account (an owner) that can be granted exclusive access to
619  * specific functions.
620  *
621  * By default, the owner account will be the one that deploys the contract. This
622  * can later be changed with {transferOwnership}.
623  *
624  * This module is used through inheritance. It will make available the modifier
625  * `onlyOwner`, which can be applied to your functions to restrict their use to
626  * the owner.
627  */
628 abstract contract Ownable is Context {
629     address private _owner;
630 
631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
632 
633     /**
634      * @dev Initializes the contract setting the deployer as the initial owner.
635      */
636     constructor () internal {
637         address msgSender = _msgSender();
638         _owner = msgSender;
639         emit OwnershipTransferred(address(0), msgSender);
640     }
641 
642     /**
643      * @dev Returns the address of the current owner.
644      */
645     function owner() public view returns (address) {
646         return _owner;
647     }
648 
649     /**
650      * @dev Throws if called by any account other than the owner.
651      */
652     modifier onlyOwner() {
653         require(_owner == _msgSender(), "Ownable: caller is not the owner");
654         _;
655     }
656 
657     /**
658      * @dev Leaves the contract without owner. It will not be possible to call
659      * `onlyOwner` functions anymore. Can only be called by the current owner.
660      *
661      * NOTE: Renouncing ownership will leave the contract without an owner,
662      * thereby removing any functionality that is only available to the owner.
663      */
664     function renounceOwnership() public virtual onlyOwner {
665         emit OwnershipTransferred(_owner, address(0));
666         _owner = address(0);
667     }
668 
669     /**
670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
671      * Can only be called by the current owner.
672      */
673     function transferOwnership(address newOwner) public virtual onlyOwner {
674         require(newOwner != address(0), "Ownable: new owner is the zero address");
675         emit OwnershipTransferred(_owner, newOwner);
676         _owner = newOwner;
677     }
678 }
679 
680 // File: @openzeppelin\contracts\utils\Address.sol
681 
682 pragma solidity >=0.6.2 <0.8.0;
683 
684 /**
685  * @dev Collection of functions related to the address type
686  */
687 library Address {
688     /**
689      * @dev Returns true if `account` is a contract.
690      *
691      * [IMPORTANT]
692      * ====
693      * It is unsafe to assume that an address for which this function returns
694      * false is an externally-owned account (EOA) and not a contract.
695      *
696      * Among others, `isContract` will return false for the following
697      * types of addresses:
698      *
699      *  - an externally-owned account
700      *  - a contract in construction
701      *  - an address where a contract will be created
702      *  - an address where a contract lived, but was destroyed
703      * ====
704      */
705     function isContract(address account) internal view returns (bool) {
706         // This method relies on extcodesize, which returns 0 for contracts in
707         // construction, since the code is only stored at the end of the
708         // constructor execution.
709 
710         uint256 size;
711         // solhint-disable-next-line no-inline-assembly
712         assembly { size := extcodesize(account) }
713         return size > 0;
714     }
715 
716     /**
717      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
718      * `recipient`, forwarding all available gas and reverting on errors.
719      *
720      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
721      * of certain opcodes, possibly making contracts go over the 2300 gas limit
722      * imposed by `transfer`, making them unable to receive funds via
723      * `transfer`. {sendValue} removes this limitation.
724      *
725      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
726      *
727      * IMPORTANT: because control is transferred to `recipient`, care must be
728      * taken to not create reentrancy vulnerabilities. Consider using
729      * {ReentrancyGuard} or the
730      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
731      */
732     function sendValue(address payable recipient, uint256 amount) internal {
733         require(address(this).balance >= amount, "Address: insufficient balance");
734 
735         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
736         (bool success, ) = recipient.call{ value: amount }("");
737         require(success, "Address: unable to send value, recipient may have reverted");
738     }
739 
740     /**
741      * @dev Performs a Solidity function call using a low level `call`. A
742      * plain`call` is an unsafe replacement for a function call: use this
743      * function instead.
744      *
745      * If `target` reverts with a revert reason, it is bubbled up by this
746      * function (like regular Solidity function calls).
747      *
748      * Returns the raw returned data. To convert to the expected return value,
749      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
750      *
751      * Requirements:
752      *
753      * - `target` must be a contract.
754      * - calling `target` with `data` must not revert.
755      *
756      * _Available since v3.1._
757      */
758     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
759       return functionCall(target, data, "Address: low-level call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
764      * `errorMessage` as a fallback revert reason when `target` reverts.
765      *
766      * _Available since v3.1._
767      */
768     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
769         return functionCallWithValue(target, data, 0, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but also transferring `value` wei to `target`.
775      *
776      * Requirements:
777      *
778      * - the calling contract must have an ETH balance of at least `value`.
779      * - the called Solidity function must be `payable`.
780      *
781      * _Available since v3.1._
782      */
783     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
784         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
789      * with `errorMessage` as a fallback revert reason when `target` reverts.
790      *
791      * _Available since v3.1._
792      */
793     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
794         require(address(this).balance >= value, "Address: insufficient balance for call");
795         require(isContract(target), "Address: call to non-contract");
796 
797         // solhint-disable-next-line avoid-low-level-calls
798         (bool success, bytes memory returndata) = target.call{ value: value }(data);
799         return _verifyCallResult(success, returndata, errorMessage);
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
804      * but performing a static call.
805      *
806      * _Available since v3.3._
807      */
808     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
809         return functionStaticCall(target, data, "Address: low-level static call failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
814      * but performing a static call.
815      *
816      * _Available since v3.3._
817      */
818     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
819         require(isContract(target), "Address: static call to non-contract");
820 
821         // solhint-disable-next-line avoid-low-level-calls
822         (bool success, bytes memory returndata) = target.staticcall(data);
823         return _verifyCallResult(success, returndata, errorMessage);
824     }
825 
826     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
827         if (success) {
828             return returndata;
829         } else {
830             // Look for revert reason and bubble it up if present
831             if (returndata.length > 0) {
832                 // The easiest way to bubble the revert reason is using memory via assembly
833 
834                 // solhint-disable-next-line no-inline-assembly
835                 assembly {
836                     let returndata_size := mload(returndata)
837                     revert(add(32, returndata), returndata_size)
838                 }
839             } else {
840                 revert(errorMessage);
841             }
842         }
843     }
844 }
845 
846 // File: contracts\PRXY.sol
847 
848 pragma solidity 0.7.6;
849 
850 
851 
852 
853 
854 contract ProxyCoin is ERC20Burnable, Ownable {
855   using SafeMath for uint256;
856   uint256 public perBlockSupply = 2391000 * 1e18;
857   uint256 public lastMintBlock;
858   uint256 public mintDuration = 210000;
859   address public treasuryWallet;
860   uint256 public mintCycle;
861   uint256 public mintCycleCap = 20;
862 
863   bool public startBlockSet;
864  
865   event MintDurationChanged(uint256 oldValue, uint256 newValue);
866   event MintCycleCapChanged(uint256 oldValue, uint256 newValue);
867 
868   constructor (address _treasuryWallet, uint256 _lastMintBlock) ERC20("Proxy", "PRXY") {
869     _setupDecimals(18);
870     lastMintBlock = _lastMintBlock;
871     treasuryWallet = _treasuryWallet;
872     _mint(treasuryWallet, perBlockSupply);
873     mintCycle++;
874   }
875   
876   function setStartBlock(uint256 _lastMintBlock) external onlyOwner {
877     require(!startBlockSet, "start block already set");
878     lastMintBlock = _lastMintBlock;
879     startBlockSet = true;
880   }
881 
882   function startMinting() external onlyOwner {
883     require(!mintingFinished(), "Err: Minting Finished");
884     require(getMintingStatus(), "Err: Minting not allowed");
885     lastMintBlock = block.number;
886     perBlockSupply = (perBlockSupply * 9).div(10);
887     _mint(treasuryWallet, perBlockSupply);
888   }
889 
890   function mint(address addr, uint256 amount) public virtual onlyOwner {
891     _mint(addr, amount);
892   }
893 
894   function changeMintCycleCap(uint256 _mintCycleCap) external virtual onlyOwner {
895     emit MintCycleCapChanged(mintCycleCap, _mintCycleCap);
896     mintCycleCap = _mintCycleCap;
897   }
898 
899   function changeMintDuration(uint256 _mintDuration) external virtual onlyOwner {
900     emit MintDurationChanged(mintDuration, _mintDuration);
901     mintDuration = _mintDuration;
902   }
903   
904   function getBlockDifference() public view returns(uint256) {
905     return (block.number.sub(lastMintBlock));
906   }
907 
908   function getMintingStatus() public view returns(bool) {
909     return ((block.number.sub(lastMintBlock)) > mintDuration);
910   }
911 
912   function mintingFinished() public view returns(bool) {
913     return (mintCycle > mintCycleCap);
914   }
915 }