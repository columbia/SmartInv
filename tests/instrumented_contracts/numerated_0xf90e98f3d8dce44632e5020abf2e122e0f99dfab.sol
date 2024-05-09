1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 
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
163 // File: openzeppelin-solidity/contracts/GSN/Context.sol
164 
165 
166 
167 pragma solidity >=0.6.0 <0.8.0;
168 
169 /*
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with GSN meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
191 
192 
193 
194 pragma solidity >=0.6.0 <0.8.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
578 // File: openzeppelin-solidity/contracts/access/Ownable.sol
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
648 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
816 // File: original_contracts/IWhitelisted.sol
817 
818 pragma solidity 0.7.5;
819 
820 
821 interface IWhitelisted {
822 
823     function hasRole(
824         bytes32 role,
825         address account
826     )
827         external
828         view
829         returns (bool);
830 
831     function WHITELISTED_ROLE() external view returns(bytes32);
832 }
833 
834 // File: original_contracts/lib/IExchange.sol
835 
836 pragma solidity 0.7.5;
837 
838 
839 
840 /**
841 * @dev This interface should be implemented by all exchanges which needs to integrate with the paraswap protocol
842 */
843 interface IExchange {
844 
845     /**
846    * @dev The function which performs the swap on an exchange.
847    * Exchange needs to implement this method in order to support swapping of tokens through it
848    * @param fromToken Address of the source token
849    * @param toToken Address of the destination token
850    * @param fromAmount Amount of source tokens to be swapped
851    * @param toAmount Minimum destination token amount expected out of this swap
852    * @param exchange Internal exchange or factory contract address for the exchange. For example Registry address for the Uniswap
853    * @param payload Any exchange specific data which is required can be passed in this argument in encoded format which
854    * will be decoded by the exchange. Each exchange will publish it's own decoding/encoding mechanism
855    */
856     function swap(
857         IERC20 fromToken,
858         IERC20 toToken,
859         uint256 fromAmount,
860         uint256 toAmount,
861         address exchange,
862         bytes calldata payload) external payable returns (uint256);
863 
864   /**
865    * @dev The function which performs the swap on an exchange.
866    * Exchange needs to implement this method in order to support swapping of tokens through it
867    * @param fromToken Address of the source token
868    * @param toToken Address of the destination token
869    * @param fromAmount Max Amount of source tokens to be swapped
870    * @param toAmount Destination token amount expected out of this swap
871    * @param exchange Internal exchange or factory contract address for the exchange. For example Registry address for the Uniswap
872    * @param payload Any exchange specific data which is required can be passed in this argument in encoded format which
873    * will be decoded by the exchange. Each exchange will publish it's own decoding/encoding mechanism
874    */
875     function buy(
876         IERC20 fromToken,
877         IERC20 toToken,
878         uint256 fromAmount,
879         uint256 toAmount,
880         address exchange,
881         bytes calldata payload) external payable returns (uint256);
882 
883     /**
884    * @dev This function is used to perform onChainSwap. It build all the parameters onchain. Basically the information
885    * encoded in payload param of swap will calculated in this case
886    * Exchange needs to implement this method in order to support swapping of tokens through it
887    * @param fromToken Address of the source token
888    * @param toToken Address of the destination token
889    * @param fromAmount Amount of source tokens to be swapped
890    * @param toAmount Minimum destination token amount expected out of this swap
891    */
892     function onChainSwap(
893         IERC20 fromToken,
894         IERC20 toToken,
895         uint256 fromAmount,
896         uint256 toAmount
897     ) external payable returns (uint256);
898 }
899 
900 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
901 
902 
903 
904 pragma solidity >=0.6.0 <0.8.0;
905 
906 
907 
908 
909 /**
910  * @title SafeERC20
911  * @dev Wrappers around ERC20 operations that throw on failure (when the token
912  * contract returns false). Tokens that return no value (and instead revert or
913  * throw on failure) are also supported, non-reverting calls are assumed to be
914  * successful.
915  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
916  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
917  */
918 library SafeERC20 {
919     using SafeMath for uint256;
920     using Address for address;
921 
922     function safeTransfer(IERC20 token, address to, uint256 value) internal {
923         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
924     }
925 
926     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
927         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
928     }
929 
930     /**
931      * @dev Deprecated. This function has issues similar to the ones found in
932      * {IERC20-approve}, and its usage is discouraged.
933      *
934      * Whenever possible, use {safeIncreaseAllowance} and
935      * {safeDecreaseAllowance} instead.
936      */
937     function safeApprove(IERC20 token, address spender, uint256 value) internal {
938         // safeApprove should only be called when setting an initial allowance,
939         // or when resetting it to zero. To increase and decrease it, use
940         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
941         // solhint-disable-next-line max-line-length
942         require((value == 0) || (token.allowance(address(this), spender) == 0),
943             "SafeERC20: approve from non-zero to non-zero allowance"
944         );
945         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
946     }
947 
948     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
949         uint256 newAllowance = token.allowance(address(this), spender).add(value);
950         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
951     }
952 
953     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
954         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
955         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
956     }
957 
958     /**
959      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
960      * on the return value: the return value is optional (but if data is returned, it must not be false).
961      * @param token The token targeted by the call.
962      * @param data The call data (encoded using abi.encode or one of its variants).
963      */
964     function _callOptionalReturn(IERC20 token, bytes memory data) private {
965         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
966         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
967         // the target address contains contract code and also asserts for success in the low-level call.
968 
969         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
970         if (returndata.length > 0) { // Return data is optional
971             // solhint-disable-next-line max-line-length
972             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
973         }
974     }
975 }
976 
977 // File: original_contracts/ITokenTransferProxy.sol
978 
979 pragma solidity 0.7.5;
980 
981 
982 interface ITokenTransferProxy {
983 
984     function transferFrom(
985         address token,
986         address from,
987         address to,
988         uint256 amount
989     )
990         external;
991 
992     function freeGSTTokens(uint256 tokensToFree) external;
993 }
994 
995 // File: original_contracts/lib/Utils.sol
996 
997 pragma solidity 0.7.5;
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 library Utils {
1006     using SafeMath for uint256;
1007     using SafeERC20 for IERC20;
1008 
1009     address constant ETH_ADDRESS = address(
1010         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
1011     );
1012 
1013     uint256 constant MAX_UINT = 2 ** 256 - 1;
1014 
1015     /**
1016    * @param fromToken Address of the source token
1017    * @param toToken Address of the destination token
1018    * @param fromAmount Amount of source tokens to be swapped
1019    * @param toAmount Minimum destination token amount expected out of this swap
1020    * @param expectedAmount Expected amount of destination tokens without slippage
1021    * @param beneficiary Beneficiary address
1022    * 0 then 100% will be transferred to beneficiary. Pass 10000 for 100%
1023    * @param referrer referral id
1024    * @param path Route to be taken for this swap to take place
1025 
1026    */
1027     struct SellData {
1028         IERC20 fromToken;
1029         IERC20 toToken;
1030         uint256 fromAmount;
1031         uint256 toAmount;
1032         uint256 expectedAmount;
1033         address payable beneficiary;
1034         string referrer;
1035         Utils.Path[] path;
1036 
1037     }
1038 
1039     struct BuyData {
1040         IERC20 fromToken;
1041         IERC20 toToken;
1042         uint256 fromAmount;
1043         uint256 toAmount;
1044         address payable beneficiary;
1045         string referrer;
1046         Utils.BuyRoute[] route;
1047     }
1048 
1049     struct Route {
1050         address payable exchange;
1051         address targetExchange;
1052         uint percent;
1053         bytes payload;
1054         uint256 networkFee;//Network fee is associated with 0xv3 trades
1055     }
1056 
1057     struct Path {
1058         address to;
1059         uint256 totalNetworkFee;//Network fee is associated with 0xv3 trades
1060         Route[] routes;
1061     }
1062 
1063     struct BuyRoute {
1064         address payable exchange;
1065         address targetExchange;
1066         uint256 fromAmount;
1067         uint256 toAmount;
1068         bytes payload;
1069         uint256 networkFee;//Network fee is associated with 0xv3 trades
1070     }
1071 
1072     function ethAddress() internal pure returns (address) {return ETH_ADDRESS;}
1073 
1074     function maxUint() internal pure returns (uint256) {return MAX_UINT;}
1075 
1076     function approve(
1077         address addressToApprove,
1078         address token,
1079         uint256 amount
1080     ) internal {
1081         if (token != ETH_ADDRESS) {
1082             IERC20 _token = IERC20(token);
1083 
1084             uint allowance = _token.allowance(address(this), addressToApprove);
1085 
1086             if (allowance < amount) {
1087                 _token.safeApprove(addressToApprove, 0);
1088                 _token.safeIncreaseAllowance(addressToApprove, MAX_UINT);
1089             }
1090         }
1091     }
1092 
1093     function transferTokens(
1094         address token,
1095         address payable destination,
1096         uint256 amount
1097     )
1098     internal
1099     {
1100         if (amount > 0) {
1101             if (token == ETH_ADDRESS) {
1102                 destination.call{value: amount}("");
1103             }
1104             else {
1105                 IERC20(token).safeTransfer(destination, amount);
1106             }
1107         }
1108 
1109     }
1110 
1111     function tokenBalance(
1112         address token,
1113         address account
1114     )
1115     internal
1116     view
1117     returns (uint256)
1118     {
1119         if (token == ETH_ADDRESS) {
1120             return account.balance;
1121         } else {
1122             return IERC20(token).balanceOf(account);
1123         }
1124     }
1125 
1126     /**
1127     * @dev Helper method to refund gas using gas tokens
1128     */
1129     function refundGas(
1130         address tokenProxy,
1131         uint256 initialGas,
1132         uint256 mintPrice
1133     )
1134         internal
1135     {
1136 
1137         uint256 mintBase = 32254;
1138         uint256 mintToken = 36543;
1139         uint256 freeBase = 14154;
1140         uint256 freeToken = 6870;
1141         uint256 reimburse = 24000;
1142 
1143         uint256 tokens = initialGas.sub(
1144             gasleft()).add(freeBase).div(reimburse.mul(2).sub(freeToken)
1145         );
1146 
1147         uint256 mintCost = mintBase.add(tokens.mul(mintToken));
1148         uint256 freeCost = freeBase.add(tokens.mul(freeToken));
1149         uint256 maxreimburse = tokens.mul(reimburse);
1150 
1151         uint256 efficiency = maxreimburse.mul(tx.gasprice).mul(100).div(
1152             mintCost.mul(mintPrice).add(freeCost.mul(tx.gasprice))
1153         );
1154 
1155         if (efficiency > 100) {
1156             freeGasTokens(tokenProxy, tokens);
1157         }
1158     }
1159 
1160     /**
1161     * @dev Helper method to free gas tokens
1162     */
1163     function freeGasTokens(address tokenProxy, uint256 tokens) internal {
1164 
1165         uint256 tokensToFree = tokens;
1166         uint256 safeNumTokens = 0;
1167         uint256 gas = gasleft();
1168 
1169         if (gas >= 27710) {
1170             safeNumTokens = gas.sub(27710).div(1148 + 5722 + 150);
1171         }
1172 
1173         if (tokensToFree > safeNumTokens) {
1174             tokensToFree = safeNumTokens;
1175         }
1176 
1177         ITokenTransferProxy(tokenProxy).freeGSTTokens(tokensToFree);
1178 
1179     }
1180 }
1181 
1182 // File: original_contracts/IGST2.sol
1183 
1184 pragma solidity 0.7.5;
1185 
1186 interface IGST2 {
1187 
1188     function freeUpTo(uint256 value) external returns (uint256 freed);
1189 
1190     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
1191 
1192     function balanceOf(address who) external view returns (uint256);
1193 
1194     function mint(uint256 value) external;
1195 }
1196 
1197 // File: original_contracts/TokenTransferProxy.sol
1198 
1199 pragma solidity 0.7.5;
1200 
1201 
1202 
1203 
1204 
1205 
1206 /**
1207 * @dev Allows owner of the contract to transfer tokens on behalf of user.
1208 * User will need to approve this contract to spend tokens on his/her behalf
1209 * on Paraswap platform
1210 */
1211 contract TokenTransferProxy is Ownable {
1212     using SafeERC20 for IERC20;
1213 
1214     IGST2 private _gst2;
1215 
1216     address private _gstHolder;
1217 
1218     constructor(address gst2, address gstHolder) public {
1219         _gst2 = IGST2(gst2);
1220         _gstHolder = gstHolder;
1221     }
1222 
1223     function getGSTHolder() external view returns(address) {
1224         return _gstHolder;
1225     }
1226 
1227     function getGST() external view returns(address) {
1228         return address(_gst2);
1229     }
1230 
1231     function changeGSTTokenHolder(address gstHolder) external onlyOwner {
1232         _gstHolder = gstHolder;
1233 
1234     }
1235 
1236     /**
1237     * @dev Allows owner of the contract to transfer tokens on user's behalf
1238     * @dev Swapper contract will be the owner of this contract
1239     * @param token Address of the token
1240     * @param from Address from which tokens will be transferred
1241     * @param to Receipent address of the tokens
1242     * @param amount Amount of tokens to transfer
1243     */
1244     function transferFrom(
1245         address token,
1246         address from,
1247         address to,
1248         uint256 amount
1249     )
1250         external
1251         onlyOwner
1252     {
1253         IERC20(token).safeTransferFrom(from, to, amount);
1254     }
1255 
1256     function freeGSTTokens(uint256 tokensToFree) external onlyOwner {
1257         _gst2.freeFromUpTo(_gstHolder, tokensToFree);
1258     }
1259 
1260 }
1261 
1262 // File: original_contracts/IPartnerRegistry.sol
1263 
1264 pragma solidity 0.7.5;
1265 
1266 
1267 interface IPartnerRegistry {
1268 
1269     function getPartnerContract(string calldata referralId) external view returns(address);
1270 
1271     function addPartner(
1272         string calldata referralId,
1273         address payable feeWallet,
1274         uint256 fee,
1275         uint256 paraswapShare,
1276         uint256 partnerShare,
1277         address owner,
1278         uint256 timelock,
1279         uint256 maxFee,
1280         bool positiveSlippageToUser
1281     )
1282         external;
1283 
1284     function removePartner(string calldata referralId) external;
1285 }
1286 
1287 // File: original_contracts/IPartner.sol
1288 
1289 pragma solidity 0.7.5;
1290 
1291 
1292 interface IPartner {
1293 
1294     function getReferralId() external view returns(string memory);
1295 
1296     function getFeeWallet() external view returns(address payable);
1297 
1298     function getFee() external view returns(uint256);
1299 
1300     function getPartnerShare() external view returns(uint256);
1301 
1302     function getParaswapShare() external view returns(uint256);
1303 
1304     function changeFeeWallet(address payable feeWallet) external;
1305 
1306     function changeFee(uint256 newFee) external;
1307 
1308     function getPositiveSlippageToUser() external view returns(bool);
1309 
1310     function changePositiveSlippageToUser(bool slippageToUser) external;
1311 
1312     function getPartnerInfo() external view returns(
1313         address payable feeWallet,
1314         uint256 fee,
1315         uint256 partnerShare,
1316         uint256 paraswapShare,
1317         bool positiveSlippageToUser
1318     );
1319 }
1320 
1321 // File: original_contracts/lib/TokenFetcher.sol
1322 
1323 pragma solidity 0.7.5;
1324 
1325 
1326 
1327 
1328 contract TokenFetcher is Ownable {
1329 
1330     /**
1331     * @dev Allows owner of the contract to transfer any tokens which are assigned to the contract
1332     * This method is for safety if by any chance tokens or ETHs are assigned to the contract by mistake
1333     * @dev token Address of the token to be transferred
1334     * @dev destination Recepient of the token
1335     * @dev amount Amount of tokens to be transferred
1336     */
1337     function transferTokens(
1338         address token,
1339         address payable destination,
1340         uint256 amount
1341     )
1342         external
1343         onlyOwner
1344     {
1345         Utils.transferTokens(token, destination, amount);
1346     }
1347 }
1348 
1349 // File: original_contracts/IWETH.sol
1350 
1351 pragma solidity 0.7.5;
1352 
1353 
1354 
1355 abstract contract IWETH is IERC20 {
1356     function deposit() external virtual payable;
1357     function withdraw(uint256 amount) external virtual;
1358 }
1359 
1360 // File: original_contracts/AugustusSwapper.sol
1361 
1362 pragma solidity 0.7.5;
1363 pragma experimental ABIEncoderV2;
1364 
1365 
1366 
1367 
1368 
1369 
1370 
1371 
1372 
1373 
1374 
1375 
1376 
1377 contract AugustusSwapper is Ownable, TokenFetcher {
1378     using SafeMath for uint256;
1379     using SafeERC20 for IERC20;
1380     using Address for address;
1381 
1382     TokenTransferProxy private _tokenTransferProxy;
1383 
1384     bool private _paused;
1385 
1386     IWhitelisted private _whitelisted;
1387 
1388     IPartnerRegistry private _partnerRegistry;
1389     address payable private _feeWallet;
1390 
1391     string private _version = "2.1.0";
1392     uint256 private _gasMintPrice;
1393 
1394     event Paused();
1395     event Unpaused();
1396 
1397     event Swapped(
1398         address initiator,
1399         address indexed beneficiary,
1400         address indexed srcToken,
1401         address indexed destToken,
1402         uint256 srcAmount,
1403         uint256 receivedAmount,
1404         uint256 expectedAmount,
1405         string referrer
1406     );
1407 
1408     event Bought(
1409         address initiator,
1410         address indexed beneficiary,
1411         address indexed srcToken,
1412         address indexed destToken,
1413         uint256 srcAmount,
1414         uint256 receivedAmount,
1415         string referrer
1416     );
1417 
1418     event FeeTaken(
1419         uint256 fee,
1420         uint256 partnerShare,
1421         uint256 paraswapShare
1422     );
1423 
1424     /**
1425      * @dev Modifier to make a function callable only when the contract is not paused.
1426      */
1427     modifier whenNotPaused() {
1428         require(!_paused, "Pausable: paused");
1429         _;
1430     }
1431 
1432     /**
1433      * @dev Modifier to make a function callable only when the contract is paused.
1434      */
1435     modifier whenPaused() {
1436         require(_paused, "Pausable: not paused");
1437         _;
1438     }
1439 
1440     modifier onlySelf() {
1441       require(
1442         msg.sender == address(this),
1443         "AugustusSwapper: Invalid access"
1444       );
1445       _;
1446     }
1447 
1448 
1449   constructor(
1450         address whitelist,
1451         address gasToken,
1452         address partnerRegistry,
1453         address payable feeWallet,
1454         address gstHolder
1455     )
1456         public
1457     {
1458 
1459         _partnerRegistry = IPartnerRegistry(partnerRegistry);
1460         _tokenTransferProxy = new TokenTransferProxy(gasToken, gstHolder);
1461         _whitelisted = IWhitelisted(whitelist);
1462         _feeWallet = feeWallet;
1463         _gasMintPrice = 1;
1464     }
1465 
1466     /**
1467     * @dev Fallback method to allow exchanges to transfer back ethers for a particular swap
1468     */
1469     receive() external payable {
1470     }
1471 
1472     function getVersion() external view returns(string memory) {
1473         return _version;
1474     }
1475 
1476     function getPartnerRegistry() external view returns(address) {
1477         return address(_partnerRegistry);
1478     }
1479 
1480     function getWhitelistAddress() external view returns(address) {
1481         return address(_whitelisted);
1482     }
1483 
1484     function getFeeWallet() external view returns(address) {
1485         return _feeWallet;
1486     }
1487 
1488     function setFeeWallet(address payable feeWallet) external onlyOwner {
1489         require(feeWallet != address(0), "Invalid address");
1490         _feeWallet = feeWallet;
1491     }
1492 
1493     function getGasMintPrice() external view returns(uint) {
1494         return _gasMintPrice;
1495     }
1496 
1497     function setGasMintPrice(uint gasMintPrice) external onlyOwner {
1498         _gasMintPrice = gasMintPrice;
1499     }
1500 
1501     function setPartnerRegistry(address partnerRegistry) external onlyOwner {
1502         require(partnerRegistry != address(0), "Invalid address");
1503         _partnerRegistry = IPartnerRegistry(partnerRegistry);
1504     }
1505 
1506     function setWhitelistAddress(address whitelisted) external onlyOwner {
1507         require(whitelisted != address(0), "Invalid whitelist address");
1508         _whitelisted = IWhitelisted(whitelisted);
1509     }
1510 
1511     function getTokenTransferProxy() external view returns (address) {
1512         return address(_tokenTransferProxy);
1513     }
1514 
1515     function changeGSTHolder(address gstHolder) external onlyOwner {
1516         require(gstHolder != address(0), "Invalid address");
1517         _tokenTransferProxy.changeGSTTokenHolder(gstHolder);
1518     }
1519 
1520     /**
1521      * @dev Returns true if the contract is paused, and false otherwise.
1522      */
1523     function paused() external view returns (bool) {
1524         return _paused;
1525     }
1526 
1527     /**
1528      * @dev Called by a pauser to pause, triggers stopped state.
1529      */
1530     function pause() external onlyOwner whenNotPaused {
1531         _paused = true;
1532         emit Paused();
1533     }
1534 
1535     /**
1536      * @dev Called by a pauser to unpause, returns to normal state.
1537      */
1538     function unpause() external onlyOwner whenPaused {
1539         _paused = false;
1540         emit Unpaused();
1541     }
1542 
1543     function simplBuy(
1544         IERC20 fromToken,
1545         IERC20 toToken,
1546         uint256 fromAmount,
1547         uint256 toAmount,
1548         address[] memory callees,
1549         bytes memory exchangeData,
1550         uint256[] memory startIndexes,
1551         uint256[] memory values,
1552         address payable beneficiary,
1553         string memory referrer
1554     )
1555         external
1556         payable
1557         whenNotPaused
1558     {
1559         uint receivedAmount = performSimpleSwap(
1560             fromToken,
1561             toToken,
1562             fromAmount,
1563             toAmount,
1564             toAmount,//expected amount and to amount are same in case of buy
1565             callees,
1566             exchangeData,
1567             startIndexes,
1568             values,
1569             beneficiary,
1570             referrer
1571         );
1572 
1573         uint256 remainingAmount = Utils.tokenBalance(
1574             address(fromToken),
1575             address(this)
1576         );
1577 
1578         if (remainingAmount > 0) {
1579             Utils.transferTokens(address(fromToken), msg.sender, remainingAmount);
1580         }
1581 
1582         emit Bought(
1583             msg.sender,
1584             beneficiary == address(0)?msg.sender:beneficiary,
1585             address(fromToken),
1586             address(toToken),
1587             fromAmount,
1588             receivedAmount,
1589             referrer
1590         );
1591     }
1592 
1593     function approve(
1594       address token,
1595       address to,
1596       uint256 amount
1597     )
1598       external
1599       onlySelf
1600     {
1601       Utils.approve(to, token, amount);
1602     }
1603 
1604 
1605     function simpleSwap(
1606         IERC20 fromToken,
1607         IERC20 toToken,
1608         uint256 fromAmount,
1609         uint256 toAmount,
1610         uint256 expectedAmount,
1611         address[] memory callees,
1612         bytes memory exchangeData,
1613         uint256[] memory startIndexes,
1614         uint256[] memory values,
1615         address payable beneficiary,
1616         string memory referrer
1617     )
1618         public
1619         payable
1620         whenNotPaused
1621         returns (uint256)
1622     {
1623 
1624         uint receivedAmount = performSimpleSwap(
1625             fromToken,
1626             toToken,
1627             fromAmount,
1628             toAmount,
1629             expectedAmount,
1630             callees,
1631             exchangeData,
1632             startIndexes,
1633             values,
1634             beneficiary,
1635             referrer
1636         );
1637 
1638         emit Swapped(
1639             msg.sender,
1640             beneficiary == address(0)?msg.sender:beneficiary,
1641             address(fromToken),
1642             address(toToken),
1643             fromAmount,
1644             receivedAmount,
1645             expectedAmount,
1646             referrer
1647         );
1648 
1649         return receivedAmount;
1650     }
1651 
1652     function performSimpleSwap(
1653         IERC20 fromToken,
1654         IERC20 toToken,
1655         uint256 fromAmount,
1656         uint256 toAmount,
1657         uint256 expectedAmount,
1658         address[] memory callees,
1659         bytes memory exchangeData,
1660         uint256[] memory startIndexes,
1661         uint256[] memory values,
1662         address payable beneficiary,
1663         string memory referrer
1664     )
1665         private
1666         returns (uint256)
1667     {
1668         require(toAmount > 0, "toAmount is too low");
1669         require(callees.length > 0, "No callee provided");
1670         require(exchangeData.length > 0, "No exchangeData provided");
1671         require(
1672             callees.length + 1 == startIndexes.length,
1673             "Start indexes must be 1 greater then number of callees"
1674         );
1675 
1676         uint initialGas = gasleft();
1677 
1678         //If source token is not ETH than transfer required amount of tokens
1679         //from sender to this contract
1680         if (address(fromToken) != Utils.ethAddress()) {
1681             _tokenTransferProxy.transferFrom(
1682                 address(fromToken),
1683                 msg.sender,
1684                 address(this),
1685                 fromAmount
1686             );
1687         }
1688 
1689         for (uint256 i = 0; i < callees.length; i++) {
1690             require(
1691                 callees[i] != address(_tokenTransferProxy),
1692                 "Can not call TokenTransferProxy Contract"
1693             );
1694 
1695             bool result = externalCall(
1696                 callees[i], //destination
1697                 values[i], //value to send
1698                 startIndexes[i], // start index of call data
1699                 startIndexes[i + 1].sub(startIndexes[i]), // length of calldata
1700                 exchangeData// total calldata
1701             );
1702             require(result, "External call failed");
1703         }
1704 
1705         uint256 receivedAmount = Utils.tokenBalance(
1706             address(toToken),
1707             address(this)
1708         );
1709 
1710         require(
1711             receivedAmount >= toAmount,
1712             "Received amount of tokens are less then expected"
1713         );
1714 
1715         takeFeeAndTransferTokens(
1716             toToken,
1717             expectedAmount,
1718             receivedAmount,
1719             beneficiary,
1720             referrer
1721         );
1722 
1723         if(_gasMintPrice > 0) {
1724           Utils.refundGas(address(_tokenTransferProxy), initialGas, _gasMintPrice);
1725         }
1726 
1727         return receivedAmount;
1728     }
1729 
1730     /**
1731    * @dev This function sends the WETH returned during the exchange to the user.
1732    * @param token: The WETH Address
1733    */
1734     function withdrawAllWETH(IWETH token) external {
1735         uint256 amount = token.balanceOf(address(this));
1736         token.withdraw(amount);
1737     }
1738 
1739     /**
1740    * @dev The function which performs the multi path swap.
1741    * @param data Data required to perform swap.
1742    */
1743     function multiSwap(
1744         Utils.SellData memory data
1745     )
1746         public
1747         payable
1748         whenNotPaused
1749         returns (uint256)
1750     {
1751         //Referral can never be empty
1752         require(bytes(data.referrer).length > 0, "Invalid referrer");
1753 
1754         require(data.toAmount > 0, "To amount can not be 0");
1755 
1756         uint256 receivedAmount = performSwap(
1757             data.fromToken,
1758             data.toToken,
1759             data.fromAmount,
1760             data.toAmount,
1761             data.path
1762         );
1763 
1764         takeFeeAndTransferTokens(
1765             data.toToken,
1766             data.expectedAmount,
1767             receivedAmount,
1768             data.beneficiary,
1769             data.referrer
1770         );
1771 
1772         emit Swapped(
1773             msg.sender,
1774             data.beneficiary == address(0)?msg.sender:data.beneficiary,
1775             address(data.fromToken),
1776             address(data.toToken),
1777             data.fromAmount,
1778             receivedAmount,
1779             data.expectedAmount,
1780             data.referrer
1781         );
1782 
1783         return receivedAmount;
1784     }
1785 
1786     /**
1787    * @dev The function which performs the single path buy.
1788    * @param data Data required to perform swap.
1789    */
1790     function buy(
1791         Utils.BuyData memory data
1792     )
1793         public
1794         payable
1795         whenNotPaused
1796         returns (uint256)
1797     {
1798         //Referral id can never be empty
1799         require(bytes(data.referrer).length > 0, "Invalid referrer");
1800 
1801         require(data.toAmount > 0, "To amount can not be 0");
1802 
1803         uint256 receivedAmount = performBuy(
1804             data.fromToken,
1805             data.toToken,
1806             data.fromAmount,
1807             data.toAmount,
1808             data.route
1809         );
1810 
1811         takeFeeAndTransferTokens(
1812             data.toToken,
1813             data.toAmount,
1814             receivedAmount,
1815             data.beneficiary,
1816             data.referrer
1817         );
1818 
1819         uint256 remainingAmount = Utils.tokenBalance(
1820             address(data.fromToken),
1821             address(this)
1822         );
1823 
1824         if (remainingAmount > 0) {
1825             Utils.transferTokens(address(data.fromToken), msg.sender, remainingAmount);
1826         }
1827 
1828         emit Bought(
1829             msg.sender,
1830             data.beneficiary == address(0)?msg.sender:data.beneficiary,
1831             address(data.fromToken),
1832             address(data.toToken),
1833             data.fromAmount,
1834             receivedAmount,
1835             data.referrer
1836         );
1837 
1838         return receivedAmount;
1839     }
1840 
1841     //Helper function to transfer final amount to the beneficiaries
1842     function takeFeeAndTransferTokens(
1843         IERC20 toToken,
1844         uint256 expectedAmount,
1845         uint256 receivedAmount,
1846         address payable beneficiary,
1847         string memory referrer
1848 
1849     )
1850         private
1851     {
1852         uint256 remainingAmount = receivedAmount;
1853 
1854         //Take partner fee
1855         ( uint256 fee ) = _takeFee(
1856             toToken,
1857             receivedAmount,
1858             expectedAmount,
1859             referrer
1860         );
1861         remainingAmount = receivedAmount.sub(fee);
1862 
1863         //If there is a positive slippage after taking partner fee then 50% goes to paraswap and 50% to the user
1864         if ((remainingAmount > expectedAmount) && fee == 0) {
1865             uint256 positiveSlippageShare = remainingAmount.sub(expectedAmount).div(2);
1866             remainingAmount = remainingAmount.sub(positiveSlippageShare);
1867             Utils.transferTokens(address(toToken), _feeWallet, positiveSlippageShare);
1868         }
1869 
1870 
1871 
1872         //If beneficiary is not a 0 address then it means it is a transfer transaction
1873         if (beneficiary == address(0)){
1874             Utils.transferTokens(address(toToken), msg.sender, remainingAmount);
1875         }
1876         else {
1877             Utils.transferTokens(address(toToken), beneficiary, remainingAmount);
1878         }
1879 
1880     }
1881 
1882     /**
1883     * @dev Source take from GNOSIS MultiSigWallet
1884     * @dev https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
1885     */
1886     function externalCall(
1887         address destination,
1888         uint256 value,
1889         uint256 dataOffset,
1890         uint dataLength,
1891         bytes memory data
1892     )
1893     private
1894     returns (bool)
1895     {
1896         bool result = false;
1897 
1898         assembly {
1899             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
1900 
1901             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
1902             result := call(
1903                 sub(gas(), 34710), // 34710 is the value that solidity is currently emitting
1904                 // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
1905                 // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
1906                 destination,
1907                 value,
1908                 add(d, dataOffset),
1909                 dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
1910                 x,
1911                 0                  // Output is ignored, therefore the output size is zero
1912             )
1913         }
1914         return result;
1915     }
1916 
1917     //Helper function to perform swap
1918     function performSwap(
1919         IERC20 fromToken,
1920         IERC20 toToken,
1921         uint256 fromAmount,
1922         uint256 toAmount,
1923         Utils.Path[] memory path
1924     )
1925         private
1926         returns(uint256)
1927     {
1928         uint initialGas = gasleft();
1929 
1930         require(path.length > 0, "Path not provided for swap");
1931         require(
1932             path[path.length - 1].to == address(toToken),
1933             "Last to token does not match toToken"
1934         );
1935 
1936         //if fromToken is not ETH then transfer tokens from user to this contract
1937         if (address(fromToken) != Utils.ethAddress()) {
1938             _tokenTransferProxy.transferFrom(
1939                 address(fromToken),
1940                 msg.sender,
1941                 address(this),
1942                 fromAmount
1943             );
1944         }
1945 
1946         //Assuming path will not be too long to reach out of gas exception
1947         for (uint i = 0; i < path.length; i++) {
1948             //_fromToken will be either fromToken of toToken of the previous path
1949             IERC20 _fromToken = i > 0 ? IERC20(path[i - 1].to) : IERC20(fromToken);
1950             IERC20 _toToken = IERC20(path[i].to);
1951 
1952             uint _fromAmount = Utils.tokenBalance(address(_fromToken), address(this));
1953             if (i > 0 && address(_fromToken) == Utils.ethAddress()) {
1954                 _fromAmount = _fromAmount.sub(path[i].totalNetworkFee);
1955             }
1956 
1957             for (uint j = 0; j < path[i].routes.length; j++) {
1958                 Utils.Route memory route = path[i].routes[j];
1959 
1960                 //Check if exchange is supported
1961                 require(
1962                     _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), route.exchange),
1963                     "Exchange not whitelisted"
1964                 );
1965 
1966                 IExchange dex = IExchange(route.exchange);
1967 
1968                 //Calculating tokens to be passed to the relevant exchange
1969                 //percentage should be 200 for 2%
1970                 uint fromAmountSlice = _fromAmount.mul(route.percent).div(10000);
1971                 uint256 value = route.networkFee;
1972 
1973                 if (j == path[i].routes.length.sub(1)) {
1974                     uint256 remBal = Utils.tokenBalance(address(_fromToken), address(this));
1975 
1976                     fromAmountSlice = remBal;
1977 
1978                     if (address(_fromToken) == Utils.ethAddress()) {
1979                         //subtract network fee
1980                         fromAmountSlice = fromAmountSlice.sub(value);
1981                     }
1982                 }
1983 
1984                 //Call to the exchange
1985                 if (address(_fromToken) == Utils.ethAddress()) {
1986                     value = value.add(fromAmountSlice);
1987 
1988                     dex.swap{value: value}(_fromToken, _toToken, fromAmountSlice, 1, route.targetExchange, route.payload);
1989                 }
1990                 else {
1991                     _fromToken.safeTransfer(route.exchange, fromAmountSlice);
1992 
1993                     dex.swap{value: value}(_fromToken, _toToken, fromAmountSlice, 1, route.targetExchange, route.payload);
1994                 }
1995             }
1996         }
1997 
1998         uint256 receivedAmount = Utils.tokenBalance(
1999             address(toToken),
2000             address(this)
2001         );
2002         require(
2003             receivedAmount >= toAmount,
2004             "Received amount of tokens are less then expected"
2005         );
2006 
2007         if (_gasMintPrice > 0) {
2008             Utils.refundGas(address(_tokenTransferProxy), initialGas, _gasMintPrice);
2009         }
2010         return receivedAmount;
2011     }
2012 
2013     //Helper function to perform swap
2014     function performBuy(
2015         IERC20 fromToken,
2016         IERC20 toToken,
2017         uint256 fromAmount,
2018         uint256 toAmount,
2019         Utils.BuyRoute[] memory routes
2020     )
2021         private
2022         returns(uint256)
2023     {
2024         uint initialGas = gasleft();
2025         IERC20 _fromToken = fromToken;
2026         IERC20 _toToken = toToken;
2027 
2028         //if fromToken is not ETH then transfer tokens from user to this contract
2029         if (address(_fromToken) != Utils.ethAddress()) {
2030             _tokenTransferProxy.transferFrom(
2031                 address(_fromToken),
2032                 msg.sender,
2033                 address(this),
2034                 fromAmount
2035             );
2036         }
2037 
2038         for (uint j = 0; j < routes.length; j++) {
2039             Utils.BuyRoute memory route = routes[j];
2040 
2041             //Check if exchange is supported
2042             require(
2043                 _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), route.exchange),
2044                 "Exchange not whitelisted"
2045             );
2046             IExchange dex = IExchange(route.exchange);
2047 
2048 
2049             //Call to the exchange
2050             if (address(_fromToken) == Utils.ethAddress()) {
2051                 uint256 value = route.networkFee.add(route.fromAmount);
2052                 dex.buy{value: value}(
2053                     _fromToken,
2054                     _toToken,
2055                     route.fromAmount,
2056                     route.toAmount,
2057                     route.targetExchange,
2058                     route.payload
2059                 );
2060             }
2061             else {
2062                 _fromToken.safeTransfer(route.exchange, route.fromAmount);
2063                 dex.buy{value: route.networkFee}(
2064                     _fromToken,
2065                     _toToken,
2066                     route.fromAmount,
2067                     route.toAmount,
2068                     route.targetExchange,
2069                     route.payload
2070                 );
2071             }
2072         }
2073 
2074         uint256 receivedAmount = Utils.tokenBalance(
2075             address(_toToken),
2076             address(this)
2077         );
2078         require(
2079             receivedAmount >= toAmount,
2080             "Received amount of tokens are less then expected tokens"
2081         );
2082 
2083         if (_gasMintPrice > 0) {
2084             Utils.refundGas(address(_tokenTransferProxy), initialGas, _gasMintPrice);
2085         }
2086         return receivedAmount;
2087     }
2088 
2089     function _takeFee(
2090         IERC20 toToken,
2091         uint256 receivedAmount,
2092         uint256 expectedAmount,
2093         string memory referrer
2094     )
2095         private
2096         returns(uint256 fee)
2097     {
2098 
2099         address partnerContract = _partnerRegistry.getPartnerContract(referrer);
2100 
2101         //If there is no partner associated with the referral id then no fee will be taken
2102         if (partnerContract == address(0)) {
2103             return (0);
2104         }
2105 
2106         (
2107             address payable partnerFeeWallet,
2108             uint256 feePercent,
2109             uint256 partnerSharePercent,
2110             ,
2111             bool positiveSlippageToUser
2112         ) = IPartner(partnerContract).getPartnerInfo();
2113 
2114         uint256 partnerShare = 0;
2115         uint256 paraswapShare = 0;
2116 
2117         if (feePercent <= 50 && receivedAmount > expectedAmount) {
2118             uint256 halfPositiveSlippage = receivedAmount.sub(expectedAmount).div(2);
2119             //Calculate total fee to be taken
2120             fee = expectedAmount.mul(feePercent).div(10000);
2121             //Calculate partner's share
2122             partnerShare = fee.mul(partnerSharePercent).div(10000);
2123             //All remaining fee is paraswap's share
2124             paraswapShare = fee.sub(partnerShare);
2125             paraswapShare = paraswapShare.add(halfPositiveSlippage);
2126 
2127             fee = fee.add(halfPositiveSlippage);
2128 
2129             if (!positiveSlippageToUser) {
2130                 partnerShare = partnerShare.add(halfPositiveSlippage);
2131                 fee = fee.add(halfPositiveSlippage);
2132             }
2133         }
2134         else {
2135             //Calculate total fee to be taken
2136             fee = receivedAmount.mul(feePercent).div(10000);
2137             //Calculate partner's share
2138             partnerShare = fee.mul(partnerSharePercent).div(10000);
2139             //All remaining fee is paraswap's share
2140             paraswapShare = fee.sub(partnerShare);
2141         }
2142         Utils.transferTokens(address(toToken), partnerFeeWallet, partnerShare);
2143         Utils.transferTokens(address(toToken), _feeWallet, paraswapShare);
2144 
2145         emit FeeTaken(fee, partnerShare, paraswapShare);
2146         return (fee);
2147     }
2148 }