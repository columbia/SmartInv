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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/math/SafeMath.sol
97 
98 pragma solidity >=0.6.0 <0.8.0;
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
257 
258 pragma solidity >=0.6.0 <0.8.0;
259 
260 /**
261  * @dev Interface of the ERC20 standard as defined in the EIP.
262  */
263 interface IERC20 {
264     /**
265      * @dev Returns the amount of tokens in existence.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     /**
270      * @dev Returns the amount of tokens owned by `account`.
271      */
272     function balanceOf(address account) external view returns (uint256);
273 
274     /**
275      * @dev Moves `amount` tokens from the caller's account to `recipient`.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transfer(address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Returns the remaining number of tokens that `spender` will be
285      * allowed to spend on behalf of `owner` through {transferFrom}. This is
286      * zero by default.
287      *
288      * This value changes when {approve} or {transferFrom} are called.
289      */
290     function allowance(address owner, address spender) external view returns (uint256);
291 
292     /**
293      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * IMPORTANT: Beware that changing an allowance with this method brings the risk
298      * that someone may use both the old and the new allowance by unfortunate
299      * transaction ordering. One possible solution to mitigate this race
300      * condition is to first reduce the spender's allowance to 0 and set the
301      * desired value afterwards:
302      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303      *
304      * Emits an {Approval} event.
305      */
306     function approve(address spender, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Moves `amount` tokens from `sender` to `recipient` using the
310      * allowance mechanism. `amount` is then deducted from the caller's
311      * allowance.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Emitted when `value` tokens are moved from one account (`from`) to
321      * another (`to`).
322      *
323      * Note that `value` may be zero.
324      */
325     event Transfer(address indexed from, address indexed to, uint256 value);
326 
327     /**
328      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
329      * a call to {approve}. `value` is the new allowance.
330      */
331     event Approval(address indexed owner, address indexed spender, uint256 value);
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
335 
336 pragma solidity >=0.6.0 <0.8.0;
337 
338 
339 
340 
341 /**
342  * @dev Implementation of the {IERC20} interface.
343  *
344  * This implementation is agnostic to the way tokens are created. This means
345  * that a supply mechanism has to be added in a derived contract using {_mint}.
346  * For a generic mechanism see {ERC20PresetMinterPauser}.
347  *
348  * TIP: For a detailed writeup see our guide
349  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
350  * to implement supply mechanisms].
351  *
352  * We have followed general OpenZeppelin guidelines: functions revert instead
353  * of returning `false` on failure. This behavior is nonetheless conventional
354  * and does not conflict with the expectations of ERC20 applications.
355  *
356  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
357  * This allows applications to reconstruct the allowance for all accounts just
358  * by listening to said events. Other implementations of the EIP may not emit
359  * these events, as it isn't required by the specification.
360  *
361  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
362  * functions have been added to mitigate the well-known issues around setting
363  * allowances. See {IERC20-approve}.
364  */
365 contract ERC20 is Context, IERC20 {
366     using SafeMath for uint256;
367 
368     mapping (address => uint256) private _balances;
369 
370     mapping (address => mapping (address => uint256)) private _allowances;
371 
372     uint256 private _totalSupply;
373 
374     string private _name;
375     string private _symbol;
376     uint8 private _decimals;
377 
378     /**
379      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
380      * a default value of 18.
381      *
382      * To select a different value for {decimals}, use {_setupDecimals}.
383      *
384      * All three of these values are immutable: they can only be set once during
385      * construction.
386      */
387     constructor (string memory name_, string memory symbol_) public {
388         _name = name_;
389         _symbol = symbol_;
390         _decimals = 18;
391     }
392 
393     /**
394      * @dev Returns the name of the token.
395      */
396     function name() public view returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @dev Returns the symbol of the token, usually a shorter version of the
402      * name.
403      */
404     function symbol() public view returns (string memory) {
405         return _symbol;
406     }
407 
408     /**
409      * @dev Returns the number of decimals used to get its user representation.
410      * For example, if `decimals` equals `2`, a balance of `505` tokens should
411      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
412      *
413      * Tokens usually opt for a value of 18, imitating the relationship between
414      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
415      * called.
416      *
417      * NOTE: This information is only used for _display_ purposes: it in
418      * no way affects any of the arithmetic of the contract, including
419      * {IERC20-balanceOf} and {IERC20-transfer}.
420      */
421     function decimals() public view returns (uint8) {
422         return _decimals;
423     }
424 
425     /**
426      * @dev See {IERC20-totalSupply}.
427      */
428     function totalSupply() public view override returns (uint256) {
429         return _totalSupply;
430     }
431 
432     /**
433      * @dev See {IERC20-balanceOf}.
434      */
435     function balanceOf(address account) public view override returns (uint256) {
436         return _balances[account];
437     }
438 
439     /**
440      * @dev See {IERC20-transfer}.
441      *
442      * Requirements:
443      *
444      * - `recipient` cannot be the zero address.
445      * - the caller must have a balance of at least `amount`.
446      */
447     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
448         _transfer(_msgSender(), recipient, amount);
449         return true;
450     }
451 
452     /**
453      * @dev See {IERC20-allowance}.
454      */
455     function allowance(address owner, address spender) public view virtual override returns (uint256) {
456         return _allowances[owner][spender];
457     }
458 
459     /**
460      * @dev See {IERC20-approve}.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function approve(address spender, uint256 amount) public virtual override returns (bool) {
467         _approve(_msgSender(), spender, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-transferFrom}.
473      *
474      * Emits an {Approval} event indicating the updated allowance. This is not
475      * required by the EIP. See the note at the beginning of {ERC20}.
476      *
477      * Requirements:
478      *
479      * - `sender` and `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      * - the caller must have allowance for ``sender``'s tokens of at least
482      * `amount`.
483      */
484     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
485         _transfer(sender, recipient, amount);
486         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
487         return true;
488     }
489 
490     /**
491      * @dev Atomically increases the allowance granted to `spender` by the caller.
492      *
493      * This is an alternative to {approve} that can be used as a mitigation for
494      * problems described in {IERC20-approve}.
495      *
496      * Emits an {Approval} event indicating the updated allowance.
497      *
498      * Requirements:
499      *
500      * - `spender` cannot be the zero address.
501      */
502     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
504         return true;
505     }
506 
507     /**
508      * @dev Atomically decreases the allowance granted to `spender` by the caller.
509      *
510      * This is an alternative to {approve} that can be used as a mitigation for
511      * problems described in {IERC20-approve}.
512      *
513      * Emits an {Approval} event indicating the updated allowance.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      * - `spender` must have allowance for the caller of at least
519      * `subtractedValue`.
520      */
521     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
522         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
523         return true;
524     }
525 
526     /**
527      * @dev Moves tokens `amount` from `sender` to `recipient`.
528      *
529      * This is internal function is equivalent to {transfer}, and can be used to
530      * e.g. implement automatic token fees, slashing mechanisms, etc.
531      *
532      * Emits a {Transfer} event.
533      *
534      * Requirements:
535      *
536      * - `sender` cannot be the zero address.
537      * - `recipient` cannot be the zero address.
538      * - `sender` must have a balance of at least `amount`.
539      */
540     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
541         require(sender != address(0), "ERC20: transfer from the zero address");
542         require(recipient != address(0), "ERC20: transfer to the zero address");
543 
544         _beforeTokenTransfer(sender, recipient, amount);
545 
546         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
547         _balances[recipient] = _balances[recipient].add(amount);
548         emit Transfer(sender, recipient, amount);
549     }
550 
551     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
552      * the total supply.
553      *
554      * Emits a {Transfer} event with `from` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `to` cannot be the zero address.
559      */
560     function _mint(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: mint to the zero address");
562 
563         _beforeTokenTransfer(address(0), account, amount);
564 
565         _totalSupply = _totalSupply.add(amount);
566         _balances[account] = _balances[account].add(amount);
567         emit Transfer(address(0), account, amount);
568     }
569 
570     /**
571      * @dev Destroys `amount` tokens from `account`, reducing the
572      * total supply.
573      *
574      * Emits a {Transfer} event with `to` set to the zero address.
575      *
576      * Requirements:
577      *
578      * - `account` cannot be the zero address.
579      * - `account` must have at least `amount` tokens.
580      */
581     function _burn(address account, uint256 amount) internal virtual {
582         require(account != address(0), "ERC20: burn from the zero address");
583 
584         _beforeTokenTransfer(account, address(0), amount);
585 
586         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
587         _totalSupply = _totalSupply.sub(amount);
588         emit Transfer(account, address(0), amount);
589     }
590 
591     /**
592      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
593      *
594      * This internal function is equivalent to `approve`, and can be used to
595      * e.g. set automatic allowances for certain subsystems, etc.
596      *
597      * Emits an {Approval} event.
598      *
599      * Requirements:
600      *
601      * - `owner` cannot be the zero address.
602      * - `spender` cannot be the zero address.
603      */
604     function _approve(address owner, address spender, uint256 amount) internal virtual {
605         require(owner != address(0), "ERC20: approve from the zero address");
606         require(spender != address(0), "ERC20: approve to the zero address");
607 
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 
612     /**
613      * @dev Sets {decimals} to a value other than the default one of 18.
614      *
615      * WARNING: This function should only be called from the constructor. Most
616      * applications that interact with token contracts will not expect
617      * {decimals} to ever change, and may work incorrectly if it does.
618      */
619     function _setupDecimals(uint8 decimals_) internal {
620         _decimals = decimals_;
621     }
622 
623     /**
624      * @dev Hook that is called before any transfer of tokens. This includes
625      * minting and burning.
626      *
627      * Calling conditions:
628      *
629      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
630      * will be to transferred to `to`.
631      * - when `from` is zero, `amount` tokens will be minted for `to`.
632      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
633      * - `from` and `to` are never both zero.
634      *
635      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
636      */
637     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
638 }
639 
640 // File: @openzeppelin/contracts/utils/Address.sol
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
806 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
807 
808 pragma solidity >=0.6.0 <0.8.0;
809 
810 
811 
812 
813 /**
814  * @title SafeERC20
815  * @dev Wrappers around ERC20 operations that throw on failure (when the token
816  * contract returns false). Tokens that return no value (and instead revert or
817  * throw on failure) are also supported, non-reverting calls are assumed to be
818  * successful.
819  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
820  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
821  */
822 library SafeERC20 {
823     using SafeMath for uint256;
824     using Address for address;
825 
826     function safeTransfer(IERC20 token, address to, uint256 value) internal {
827         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
828     }
829 
830     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
831         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
832     }
833 
834     /**
835      * @dev Deprecated. This function has issues similar to the ones found in
836      * {IERC20-approve}, and its usage is discouraged.
837      *
838      * Whenever possible, use {safeIncreaseAllowance} and
839      * {safeDecreaseAllowance} instead.
840      */
841     function safeApprove(IERC20 token, address spender, uint256 value) internal {
842         // safeApprove should only be called when setting an initial allowance,
843         // or when resetting it to zero. To increase and decrease it, use
844         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
845         // solhint-disable-next-line max-line-length
846         require((value == 0) || (token.allowance(address(this), spender) == 0),
847             "SafeERC20: approve from non-zero to non-zero allowance"
848         );
849         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
850     }
851 
852     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
853         uint256 newAllowance = token.allowance(address(this), spender).add(value);
854         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
855     }
856 
857     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
858         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
859         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
860     }
861 
862     /**
863      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
864      * on the return value: the return value is optional (but if data is returned, it must not be false).
865      * @param token The token targeted by the call.
866      * @param data The call data (encoded using abi.encode or one of its variants).
867      */
868     function _callOptionalReturn(IERC20 token, bytes memory data) private {
869         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
870         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
871         // the target address contains contract code and also asserts for success in the low-level call.
872 
873         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
874         if (returndata.length > 0) { // Return data is optional
875             // solhint-disable-next-line max-line-length
876             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
877         }
878     }
879 }
880 
881 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
882 
883 pragma solidity >=0.6.0 <0.8.0;
884 
885 /**
886  * @dev Contract module that helps prevent reentrant calls to a function.
887  *
888  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
889  * available, which can be applied to functions to make sure there are no nested
890  * (reentrant) calls to them.
891  *
892  * Note that because there is a single `nonReentrant` guard, functions marked as
893  * `nonReentrant` may not call one another. This can be worked around by making
894  * those functions `private`, and then adding `external` `nonReentrant` entry
895  * points to them.
896  *
897  * TIP: If you would like to learn more about reentrancy and alternative ways
898  * to protect against it, check out our blog post
899  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
900  */
901 abstract contract ReentrancyGuard {
902     // Booleans are more expensive than uint256 or any type that takes up a full
903     // word because each write operation emits an extra SLOAD to first read the
904     // slot's contents, replace the bits taken up by the boolean, and then write
905     // back. This is the compiler's defense against contract upgrades and
906     // pointer aliasing, and it cannot be disabled.
907 
908     // The values being non-zero value makes deployment a bit more expensive,
909     // but in exchange the refund on every call to nonReentrant will be lower in
910     // amount. Since refunds are capped to a percentage of the total
911     // transaction's gas, it is best to keep them low in cases like this one, to
912     // increase the likelihood of the full refund coming into effect.
913     uint256 private constant _NOT_ENTERED = 1;
914     uint256 private constant _ENTERED = 2;
915 
916     uint256 private _status;
917 
918     constructor () internal {
919         _status = _NOT_ENTERED;
920     }
921 
922     /**
923      * @dev Prevents a contract from calling itself, directly or indirectly.
924      * Calling a `nonReentrant` function from another `nonReentrant`
925      * function is not supported. It is possible to prevent this from happening
926      * by making the `nonReentrant` function external, and make it call a
927      * `private` function that does the actual work.
928      */
929     modifier nonReentrant() {
930         // On the first call to nonReentrant, _notEntered will be true
931         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
932 
933         // Any calls to nonReentrant after this point will fail
934         _status = _ENTERED;
935 
936         _;
937 
938         // By storing the original value once again, a refund is triggered (see
939         // https://eips.ethereum.org/EIPS/eip-2200)
940         _status = _NOT_ENTERED;
941     }
942 }
943 
944 // File: contracts/LiquidityMining2.sol
945 
946 pragma solidity ^0.6.12;
947 
948 
949 
950 
951 
952 
953 contract LiquidityMining2 is Ownable, ReentrancyGuard {
954     using SafeMath for uint256;
955     using SafeMath for uint8;
956     using SafeERC20 for ERC20;
957 
958     ERC20 public immutable usdc;
959     ERC20 public immutable usdt;
960     ERC20 public immutable dai;
961     ERC20 public immutable sarco;
962 
963     uint256 public totalStakers;
964     uint256 public totalRewards;
965     uint256 public totalClaimedRewards;
966     uint256 public startTime;
967     uint256 public firstStakeTime;
968     uint256 public endTime;
969 
970     uint256 private _totalStakeUsdc;
971     uint256 private _totalStakeUsdt;
972     uint256 private _totalStakeDai;
973     uint256 private _totalWeight;
974     uint256 private _mostRecentValueCalcTime;
975 
976     mapping(address => uint256) public userClaimedRewards;
977 
978     mapping(address => uint256) private _userStakedUsdc;
979     mapping(address => uint256) private _userStakedUsdt;
980     mapping(address => uint256) private _userStakedDai;
981     mapping(address => uint256) private _userWeighted;
982     mapping(address => uint256) private _userAccumulated;
983 
984     event Deposit(uint256 totalRewards, uint256 startTime, uint256 endTime);
985     event Stake(
986         address indexed staker,
987         uint256 usdcIn,
988         uint256 usdtIn,
989         uint256 daiIn
990     );
991     event Payout(address indexed staker, uint256 reward, address to);
992     event Withdraw(
993         address indexed staker,
994         uint256 usdcOut,
995         uint256 usdtOut,
996         uint256 daiOut,
997         address to
998     );
999 
1000     constructor(
1001         address _usdc,
1002         address _usdt,
1003         address _dai,
1004         address _sarco,
1005         address owner
1006     ) public {
1007         usdc = ERC20(_usdc);
1008         usdt = ERC20(_usdt);
1009         dai = ERC20(_dai);
1010         sarco = ERC20(_sarco);
1011 
1012         transferOwnership(owner);
1013     }
1014 
1015     function totalStakeUsdc() public view returns (uint256 totalUsdc) {
1016         totalUsdc = denormalize(usdc, _totalStakeUsdc);
1017     }
1018 
1019     function totalStakeUsdt() public view returns (uint256 totalUsdt) {
1020         totalUsdt = denormalize(usdt, _totalStakeUsdt);
1021     }
1022 
1023     function totalStakeDai() public view returns (uint256 totalDai) {
1024         totalDai = denormalize(dai, _totalStakeDai);
1025     }
1026 
1027     function userStakeUsdc(address user)
1028         public
1029         view
1030         returns (uint256 usdcStake)
1031     {
1032         usdcStake = denormalize(usdc, _userStakedUsdc[user]);
1033     }
1034 
1035     function userStakeUsdt(address user)
1036         public
1037         view
1038         returns (uint256 usdtStake)
1039     {
1040         usdtStake = denormalize(usdt, _userStakedUsdt[user]);
1041     }
1042 
1043     function userStakeDai(address user) public view returns (uint256 daiStake) {
1044         daiStake = denormalize(dai, _userStakedDai[user]);
1045     }
1046 
1047     function deposit(
1048         uint256 _totalRewards,
1049         uint256 _startTime,
1050         uint256 _endTime
1051     ) public onlyOwner {
1052         require(
1053             startTime == 0,
1054             "LiquidityMining::deposit: already received deposit"
1055         );
1056 
1057         require(
1058             _startTime >= block.timestamp,
1059             "LiquidityMining::deposit: start time must be in future"
1060         );
1061 
1062         require(
1063             _endTime > _startTime,
1064             "LiquidityMining::deposit: end time must after start time"
1065         );
1066 
1067         require(
1068             sarco.balanceOf(address(this)) == _totalRewards,
1069             "LiquidityMining::deposit: contract balance does not equal expected _totalRewards"
1070         );
1071 
1072         totalRewards = _totalRewards;
1073         startTime = _startTime;
1074         endTime = _endTime;
1075 
1076         emit Deposit(_totalRewards, _startTime, _endTime);
1077     }
1078 
1079     function totalStake() public view returns (uint256 total) {
1080         total = _totalStakeUsdc.add(_totalStakeUsdt).add(_totalStakeDai);
1081     }
1082 
1083     function totalUserStake(address user) public view returns (uint256 total) {
1084         total = _userStakedUsdc[user].add(_userStakedUsdt[user]).add(
1085             _userStakedDai[user]
1086         );
1087     }
1088 
1089     modifier update() {
1090         if (_mostRecentValueCalcTime == 0) {
1091             _mostRecentValueCalcTime = firstStakeTime;
1092         }
1093 
1094         uint256 totalCurrentStake = totalStake();
1095 
1096         if (totalCurrentStake > 0 && _mostRecentValueCalcTime < endTime) {
1097             uint256 value = 0;
1098             uint256 sinceLastCalc = block.timestamp.sub(
1099                 _mostRecentValueCalcTime
1100             );
1101             uint256 perSecondReward = totalRewards.div(
1102                 endTime.sub(firstStakeTime)
1103             );
1104 
1105             if (block.timestamp < endTime) {
1106                 value = sinceLastCalc.mul(perSecondReward);
1107             } else {
1108                 uint256 sinceEndTime = block.timestamp.sub(endTime);
1109                 value = (sinceLastCalc.sub(sinceEndTime)).mul(perSecondReward);
1110             }
1111 
1112             _totalWeight = _totalWeight.add(
1113                 value.mul(10**18).div(totalCurrentStake)
1114             );
1115 
1116             _mostRecentValueCalcTime = block.timestamp;
1117         }
1118 
1119         _;
1120     }
1121 
1122     function shift(ERC20 token) private view returns (uint8 shifted) {
1123         uint8 decimals = token.decimals();
1124         shifted = uint8(uint8(18).sub(decimals));
1125     }
1126 
1127     function normalize(ERC20 token, uint256 tokenIn)
1128         private
1129         view
1130         returns (uint256 normalized)
1131     {
1132         uint8 _shift = shift(token);
1133         normalized = tokenIn.mul(10**uint256(_shift));
1134     }
1135 
1136     function denormalize(ERC20 token, uint256 tokenIn)
1137         private
1138         view
1139         returns (uint256 denormalized)
1140     {
1141         uint8 _shift = shift(token);
1142         denormalized = tokenIn.div(10**uint256(_shift));
1143     }
1144 
1145     function stake(
1146         uint256 usdcIn,
1147         uint256 usdtIn,
1148         uint256 daiIn
1149     ) public update nonReentrant {
1150         require(
1151             usdcIn > 0 || usdtIn > 0 || daiIn > 0,
1152             "LiquidityMining::stake: missing stablecoin"
1153         );
1154         require(
1155             block.timestamp >= startTime,
1156             "LiquidityMining::stake: staking isn't live yet"
1157         );
1158         require(
1159             sarco.balanceOf(address(this)) > 0,
1160             "LiquidityMining::stake: no sarco balance"
1161         );
1162 
1163         if (firstStakeTime == 0) {
1164             firstStakeTime = block.timestamp;
1165         } else {
1166             require(
1167                 block.timestamp < endTime,
1168                 "LiquidityMining::stake: staking is over"
1169             );
1170         }
1171 
1172         if (usdcIn > 0) {
1173             usdc.safeTransferFrom(msg.sender, address(this), usdcIn);
1174         }
1175 
1176         if (usdtIn > 0) {
1177             usdt.safeTransferFrom(msg.sender, address(this), usdtIn);
1178         }
1179 
1180         if (daiIn > 0) {
1181             dai.safeTransferFrom(msg.sender, address(this), daiIn);
1182         }
1183 
1184         if (totalUserStake(msg.sender) == 0) {
1185             totalStakers = totalStakers.add(1);
1186         }
1187 
1188         _stake(
1189             normalize(usdc, usdcIn),
1190             normalize(usdt, usdtIn),
1191             normalize(dai, daiIn),
1192             msg.sender
1193         );
1194 
1195         emit Stake(msg.sender, usdcIn, usdtIn, daiIn);
1196     }
1197 
1198     function withdraw(address to)
1199         public
1200         update
1201         nonReentrant
1202         returns (
1203             uint256 usdcOut,
1204             uint256 usdtOut,
1205             uint256 daiOut,
1206             uint256 reward
1207         )
1208     {
1209         totalStakers = totalStakers.sub(1);
1210 
1211         (usdcOut, usdtOut, daiOut, reward) = _applyReward(msg.sender);
1212 
1213         usdcOut = denormalize(usdc, usdcOut);
1214         usdtOut = denormalize(usdt, usdtOut);
1215         daiOut = denormalize(dai, daiOut);
1216 
1217         if (usdcOut > 0) {
1218             usdc.safeTransfer(to, usdcOut);
1219         }
1220 
1221         if (usdtOut > 0) {
1222             usdt.safeTransfer(to, usdtOut);
1223         }
1224 
1225         if (daiOut > 0) {
1226             dai.safeTransfer(to, daiOut);
1227         }
1228 
1229         if (reward > 0) {
1230             sarco.safeTransfer(to, reward);
1231             userClaimedRewards[msg.sender] = userClaimedRewards[msg.sender].add(
1232                 reward
1233             );
1234             totalClaimedRewards = totalClaimedRewards.add(reward);
1235 
1236             emit Payout(msg.sender, reward, to);
1237         }
1238 
1239         emit Withdraw(msg.sender, usdcOut, usdtOut, daiOut, to);
1240     }
1241 
1242     function payout(address to)
1243         public
1244         update
1245         nonReentrant
1246         returns (uint256 reward)
1247     {
1248         (
1249             uint256 usdcOut,
1250             uint256 usdtOut,
1251             uint256 daiOut,
1252             uint256 _reward
1253         ) = _applyReward(msg.sender);
1254 
1255         reward = _reward;
1256 
1257         if (reward > 0) {
1258             sarco.safeTransfer(to, reward);
1259             userClaimedRewards[msg.sender] = userClaimedRewards[msg.sender].add(
1260                 reward
1261             );
1262             totalClaimedRewards = totalClaimedRewards.add(reward);
1263         }
1264 
1265         _stake(usdcOut, usdtOut, daiOut, msg.sender);
1266 
1267         emit Payout(msg.sender, _reward, to);
1268     }
1269 
1270     function _stake(
1271         uint256 usdcIn,
1272         uint256 usdtIn,
1273         uint256 daiIn,
1274         address account
1275     ) private {
1276         uint256 addBackUsdc;
1277         uint256 addBackUsdt;
1278         uint256 addBackDai;
1279 
1280         if (totalUserStake(account) > 0) {
1281             (
1282                 uint256 usdcOut,
1283                 uint256 usdtOut,
1284                 uint256 daiOut,
1285                 uint256 reward
1286             ) = _applyReward(account);
1287 
1288             addBackUsdc = usdcOut;
1289             addBackUsdt = usdtOut;
1290             addBackDai = daiOut;
1291 
1292             _userStakedUsdc[account] = usdcOut;
1293             _userStakedUsdt[account] = usdtOut;
1294             _userStakedDai[account] = daiOut;
1295 
1296             _userAccumulated[account] = reward;
1297         }
1298 
1299         _userStakedUsdc[account] = _userStakedUsdc[account].add(usdcIn);
1300         _userStakedUsdt[account] = _userStakedUsdt[account].add(usdtIn);
1301         _userStakedDai[account] = _userStakedDai[account].add(daiIn);
1302 
1303         _userWeighted[account] = _totalWeight;
1304 
1305         _totalStakeUsdc = _totalStakeUsdc.add(usdcIn);
1306         _totalStakeUsdt = _totalStakeUsdt.add(usdtIn);
1307         _totalStakeDai = _totalStakeDai.add(daiIn);
1308 
1309         if (addBackUsdc > 0) {
1310             _totalStakeUsdc = _totalStakeUsdc.add(addBackUsdc);
1311         }
1312 
1313         if (addBackUsdt > 0) {
1314             _totalStakeUsdt = _totalStakeUsdt.add(addBackUsdt);
1315         }
1316 
1317         if (addBackDai > 0) {
1318             _totalStakeDai = _totalStakeDai.add(addBackDai);
1319         }
1320     }
1321 
1322     function _applyReward(address account)
1323         private
1324         returns (
1325             uint256 usdcOut,
1326             uint256 usdtOut,
1327             uint256 daiOut,
1328             uint256 reward
1329         )
1330     {
1331         uint256 _totalUserStake = totalUserStake(account);
1332         require(
1333             _totalUserStake > 0,
1334             "LiquidityMining::_applyReward: no stablecoins staked"
1335         );
1336 
1337         usdcOut = _userStakedUsdc[account];
1338         usdtOut = _userStakedUsdt[account];
1339         daiOut = _userStakedDai[account];
1340 
1341         reward = _totalUserStake
1342             .mul(_totalWeight.sub(_userWeighted[account]))
1343             .div(10**18)
1344             .add(_userAccumulated[account]);
1345 
1346         _totalStakeUsdc = _totalStakeUsdc.sub(usdcOut);
1347         _totalStakeUsdt = _totalStakeUsdt.sub(usdtOut);
1348         _totalStakeDai = _totalStakeDai.sub(daiOut);
1349 
1350         _userStakedUsdc[account] = 0;
1351         _userStakedUsdt[account] = 0;
1352         _userStakedDai[account] = 0;
1353 
1354         _userAccumulated[account] = 0;
1355     }
1356 
1357     function rescueTokens(
1358         address tokenToRescue,
1359         address to,
1360         uint256 amount
1361     ) public onlyOwner nonReentrant {
1362         if (tokenToRescue == address(usdc)) {
1363             require(
1364                 amount <= usdc.balanceOf(address(this)).sub(_totalStakeUsdc),
1365                 "LiquidityMining::rescueTokens: that usdc belongs to stakers"
1366             );
1367         } else if (tokenToRescue == address(usdt)) {
1368             require(
1369                 amount <= usdt.balanceOf(address(this)).sub(_totalStakeUsdt),
1370                 "LiquidityMining::rescueTokens: that usdt belongs to stakers"
1371             );
1372         } else if (tokenToRescue == address(dai)) {
1373             require(
1374                 amount <= dai.balanceOf(address(this)).sub(_totalStakeDai),
1375                 "LiquidityMining::rescueTokens: that dai belongs to stakers"
1376             );
1377         } else if (tokenToRescue == address(sarco)) {
1378             if (totalStakers > 0) {
1379                 require(
1380                     amount <=
1381                         sarco.balanceOf(address(this)).sub(
1382                             totalRewards.sub(totalClaimedRewards)
1383                         ),
1384                     "LiquidityMining::rescueTokens: that sarco belongs to stakers"
1385                 );
1386             }
1387         }
1388 
1389         ERC20(tokenToRescue).safeTransfer(to, amount);
1390     }
1391 }