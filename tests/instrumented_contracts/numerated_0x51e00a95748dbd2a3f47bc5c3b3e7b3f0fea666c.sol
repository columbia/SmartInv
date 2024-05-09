1 pragma solidity >=0.6.0 <0.8.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 
25 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
26 
27 pragma solidity >=0.6.0 <0.8.0;
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
105 
106 pragma solidity >=0.6.0 <0.8.0;
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 
265 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
266 
267 pragma solidity >=0.6.0 <0.8.0;
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
570 
571 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
572 
573 pragma solidity >=0.6.0 <0.8.0;
574 
575 /**
576  * @dev Contract module which provides a basic access control mechanism, where
577  * there is an account (an owner) that can be granted exclusive access to
578  * specific functions.
579  *
580  * By default, the owner account will be the one that deploys the contract. This
581  * can later be changed with {transferOwnership}.
582  *
583  * This module is used through inheritance. It will make available the modifier
584  * `onlyOwner`, which can be applied to your functions to restrict their use to
585  * the owner.
586  */
587 abstract contract Ownable is Context {
588     address private _owner;
589 
590     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
591 
592     /**
593      * @dev Initializes the contract setting the deployer as the initial owner.
594      */
595     constructor () internal {
596         address msgSender = _msgSender();
597         _owner = msgSender;
598         emit OwnershipTransferred(address(0), msgSender);
599     }
600 
601     /**
602      * @dev Returns the address of the current owner.
603      */
604     function owner() public view returns (address) {
605         return _owner;
606     }
607 
608     /**
609      * @dev Throws if called by any account other than the owner.
610      */
611     modifier onlyOwner() {
612         require(_owner == _msgSender(), "Ownable: caller is not the owner");
613         _;
614     }
615 
616     /**
617      * @dev Leaves the contract without owner. It will not be possible to call
618      * `onlyOwner` functions anymore. Can only be called by the current owner.
619      *
620      * NOTE: Renouncing ownership will leave the contract without an owner,
621      * thereby removing any functionality that is only available to the owner.
622      */
623     function renounceOwnership() public virtual onlyOwner {
624         emit OwnershipTransferred(_owner, address(0));
625         _owner = address(0);
626     }
627 
628     /**
629      * @dev Transfers ownership of the contract to a new account (`newOwner`).
630      * Can only be called by the current owner.
631      */
632     function transferOwnership(address newOwner) public virtual onlyOwner {
633         require(newOwner != address(0), "Ownable: new owner is the zero address");
634         emit OwnershipTransferred(_owner, newOwner);
635         _owner = newOwner;
636     }
637 }
638 
639 
640 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
641 
642 pragma solidity >=0.6.2 <0.8.0;
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      */
665     function isContract(address account) internal view returns (bool) {
666         // This method relies on extcodesize, which returns 0 for contracts in
667         // construction, since the code is only stored at the end of the
668         // constructor execution.
669 
670         uint256 size;
671         // solhint-disable-next-line no-inline-assembly
672         assembly { size := extcodesize(account) }
673         return size > 0;
674     }
675 
676     /**
677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
678      * `recipient`, forwarding all available gas and reverting on errors.
679      *
680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
682      * imposed by `transfer`, making them unable to receive funds via
683      * `transfer`. {sendValue} removes this limitation.
684      *
685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
686      *
687      * IMPORTANT: because control is transferred to `recipient`, care must be
688      * taken to not create reentrancy vulnerabilities. Consider using
689      * {ReentrancyGuard} or the
690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
691      */
692     function sendValue(address payable recipient, uint256 amount) internal {
693         require(address(this).balance >= amount, "Address: insufficient balance");
694 
695         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
696         (bool success, ) = recipient.call{ value: amount }("");
697         require(success, "Address: unable to send value, recipient may have reverted");
698     }
699 
700     /**
701      * @dev Performs a Solidity function call using a low level `call`. A
702      * plain`call` is an unsafe replacement for a function call: use this
703      * function instead.
704      *
705      * If `target` reverts with a revert reason, it is bubbled up by this
706      * function (like regular Solidity function calls).
707      *
708      * Returns the raw returned data. To convert to the expected return value,
709      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
710      *
711      * Requirements:
712      *
713      * - `target` must be a contract.
714      * - calling `target` with `data` must not revert.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
719       return functionCall(target, data, "Address: low-level call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
724      * `errorMessage` as a fallback revert reason when `target` reverts.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
729         return functionCallWithValue(target, data, 0, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but also transferring `value` wei to `target`.
735      *
736      * Requirements:
737      *
738      * - the calling contract must have an ETH balance of at least `value`.
739      * - the called Solidity function must be `payable`.
740      *
741      * _Available since v3.1._
742      */
743     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
744         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
749      * with `errorMessage` as a fallback revert reason when `target` reverts.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
754         require(address(this).balance >= value, "Address: insufficient balance for call");
755         require(isContract(target), "Address: call to non-contract");
756 
757         // solhint-disable-next-line avoid-low-level-calls
758         (bool success, bytes memory returndata) = target.call{ value: value }(data);
759         return _verifyCallResult(success, returndata, errorMessage);
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
769         return functionStaticCall(target, data, "Address: low-level static call failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
779         require(isContract(target), "Address: static call to non-contract");
780 
781         // solhint-disable-next-line avoid-low-level-calls
782         (bool success, bytes memory returndata) = target.staticcall(data);
783         return _verifyCallResult(success, returndata, errorMessage);
784     }
785 
786     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
787         if (success) {
788             return returndata;
789         } else {
790             // Look for revert reason and bubble it up if present
791             if (returndata.length > 0) {
792                 // The easiest way to bubble the revert reason is using memory via assembly
793 
794                 // solhint-disable-next-line no-inline-assembly
795                 assembly {
796                     let returndata_size := mload(returndata)
797                     revert(add(32, returndata), returndata_size)
798                 }
799             } else {
800                 revert(errorMessage);
801             }
802         }
803     }
804 }
805 
806 
807 // File contracts/DVGToken.sol
808 
809 pragma solidity >= 0.7.0 < 0.8.0;
810 
811 
812 
813 
814 /// DVG token
815 contract DVGToken is ERC20("DVGToken", "DVG"), Ownable {
816     using Address for address;
817     using SafeMath for uint256;
818 
819 
820     /// A checkpoint for marking number of votes from a given block
821     struct Checkpoint {
822         uint32 fromBlock;
823         uint256 votes;
824     }
825 
826 
827     /// We need mint some DVG in advance
828     uint256 public dvgInAdvance;
829 
830     /// The address of Treasury wallet
831     address public treasuryWalletAddr;
832 
833     /// The EIP-712 typehash for the contract's domain
834     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
835 
836     /// The EIP-712 typehash for the delegation struct used by the contract
837     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
838 
839     // A record of each accounts delegate
840     mapping (address => address) internal _delegates;
841 
842     /// A record of votes checkpoints for each account, by index
843     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
844 
845     /// The number of checkpoints for each account
846     mapping (address => uint32) public numCheckpoints;
847 
848     /// A record of states for signing / validating signatures
849     mapping (address => uint) public nonces;
850 
851 
852     /// An event thats emitted when an account changes its delegate
853     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
854 
855     /// An event thats emitted when a delegate account's vote balance changes
856     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
857 
858 
859     /// @notice We need mint some DVGs in advance 
860     constructor(address _treasuryWalletAddr, uint256 _dvgInAdvance) {
861         require(!_treasuryWalletAddr.isContract(), "The Treasury wallet address should not be the smart contract address");
862 
863         treasuryWalletAddr = _treasuryWalletAddr;
864         dvgInAdvance = _dvgInAdvance;
865 
866         mint(treasuryWalletAddr, dvgInAdvance);
867     }
868 
869 
870     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner
871     function mint(address _to, uint256 _amount) public onlyOwner {
872         _mint(_to, _amount);
873         _moveDelegates(address(0), _delegates[_to], _amount);
874     }
875 
876     /**
877      * @notice Delegate votes from `msg.sender` to `delegatee`
878      * @param delegator The address to get delegatee for
879      */
880     function delegates(address delegator)
881         external
882         view
883         returns (address)
884     {
885         return _delegates[delegator];
886     }
887 
888    /**
889     * @notice Delegate votes from `msg.sender` to `delegatee`
890     * @param delegatee The address to delegate votes to
891     */
892     function delegate(address delegatee) external {
893         return _delegate(msg.sender, delegatee);
894     }
895 
896     /**
897      * @notice Delegates votes from signatory to `delegatee`
898      * @param delegatee The address to delegate votes to
899      * @param nonce The contract state required to match the signature
900      * @param expiry The time at which to expire the signature
901      * @param v The recovery byte of the signature
902      * @param r Half of the ECDSA signature pair
903      * @param s Half of the ECDSA signature pair
904      */
905     function delegateBySig(
906         address delegatee,
907         uint nonce,
908         uint expiry,
909         uint8 v,
910         bytes32 r,
911         bytes32 s
912     )
913         external
914     {
915         bytes32 domainSeparator = keccak256(
916             abi.encode(
917                 DOMAIN_TYPEHASH,
918                 keccak256(bytes(name())),
919                 getChainId(),
920                 address(this)
921             )
922         );
923 
924         bytes32 structHash = keccak256(
925             abi.encode(
926                 DELEGATION_TYPEHASH,
927                 delegatee,
928                 nonce,
929                 expiry
930             )
931         );
932 
933         bytes32 digest = keccak256(
934             abi.encodePacked(
935                 "\x19\x01",
936                 domainSeparator,
937                 structHash
938             )
939         );
940 
941         address signatory = ecrecover(digest, v, r, s);
942         require(signatory != address(0), "delegateBySig: invalid signature");
943         require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
944         require(block.timestamp <= expiry, "delegateBySig: signature expired");
945         return _delegate(signatory, delegatee);
946     }
947 
948     /**
949      * @notice Gets the current votes balance for `account`
950      * @param account The address to get votes balance
951      * @return The number of current votes for `account`
952      */
953     function getCurrentVotes(address account)
954         external
955         view
956         returns (uint256)
957     {
958         uint32 nCheckpoints = numCheckpoints[account];
959         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
960     }
961 
962     /**
963      * @notice Determine the prior number of votes for an account as of a block number
964      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
965      * @param account The address of the account to check
966      * @param blockNumber The block number to get the vote balance at
967      * @return The number of votes the account had as of the given block
968      */
969     function getPriorVotes(address account, uint blockNumber)
970         external
971         view
972         returns (uint256)
973     {
974         require(blockNumber < block.number, "getPriorVotes: not yet determined");
975 
976         uint32 nCheckpoints = numCheckpoints[account];
977         if (nCheckpoints == 0) {
978             return 0;
979         }
980 
981         // First check most recent balance
982         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
983             return checkpoints[account][nCheckpoints - 1].votes;
984         }
985 
986         // Next check implicit zero balance
987         if (checkpoints[account][0].fromBlock > blockNumber) {
988             return 0;
989         }
990 
991         uint32 lower = 0;
992         uint32 upper = nCheckpoints - 1;
993         while (upper > lower) {
994             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
995             Checkpoint memory cp = checkpoints[account][center];
996             if (cp.fromBlock == blockNumber) {
997                 return cp.votes;
998             } else if (cp.fromBlock < blockNumber) {
999                 lower = center;
1000             } else {
1001                 upper = center - 1;
1002             }
1003         }
1004         return checkpoints[account][lower].votes;
1005     }
1006 
1007     function _delegate(address delegator, address delegatee)
1008         internal
1009     {
1010         address currentDelegate = _delegates[delegator];
1011         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying DVGs (not scaled);
1012         _delegates[delegator] = delegatee;
1013 
1014         emit DelegateChanged(delegator, currentDelegate, delegatee);
1015 
1016         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1017     }
1018 
1019     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1020         if (srcRep != dstRep && amount > 0) {
1021             if (srcRep != address(0)) {
1022                 // decrease old representative
1023                 uint32 srcRepNum = numCheckpoints[srcRep];
1024                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1025                 uint256 srcRepNew = srcRepOld.sub(amount);
1026                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1027             }
1028 
1029             if (dstRep != address(0)) {
1030                 // increase new representative
1031                 uint32 dstRepNum = numCheckpoints[dstRep];
1032                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1033                 uint256 dstRepNew = dstRepOld.add(amount);
1034                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1035             }
1036         }
1037     }
1038 
1039     function _writeCheckpoint(
1040         address delegatee,
1041         uint32 nCheckpoints,
1042         uint256 oldVotes,
1043         uint256 newVotes
1044     )
1045         internal
1046     {
1047         uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");
1048 
1049         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1050             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1051         } else {
1052             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1053             numCheckpoints[delegatee] = nCheckpoints + 1;
1054         }
1055 
1056         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1057     }
1058 
1059     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1060         require(n < 2**32, errorMessage);
1061         return uint32(n);
1062     }
1063 
1064     function getChainId() internal pure returns (uint) {
1065         uint256 chainId;
1066         assembly { chainId := chainid() }
1067         return chainId;
1068     }
1069 }