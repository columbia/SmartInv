1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
106 
107 pragma solidity >=0.6.0 <0.8.0;
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 
266 pragma solidity >=0.6.0 <0.8.0;
267 
268 
269 
270 /**
271  * @dev Implementation of the {IERC20} interface.
272  *
273  * This implementation is agnostic to the way tokens are created. This means
274  * that a supply mechanism has to be added in a derived contract using {_mint}.
275  * For a generic mechanism see {ERC20PresetMinterPauser}.
276  *
277  * TIP: For a detailed writeup see our guide
278  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
279  * to implement supply mechanisms].
280  *
281  * We have followed general OpenZeppelin guidelines: functions revert instead
282  * of returning `false` on failure. This behavior is nonetheless conventional
283  * and does not conflict with the expectations of ERC20 applications.
284  *
285  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
286  * This allows applications to reconstruct the allowance for all accounts just
287  * by listening to said events. Other implementations of the EIP may not emit
288  * these events, as it isn't required by the specification.
289  *
290  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
291  * functions have been added to mitigate the well-known issues around setting
292  * allowances. See {IERC20-approve}.
293  */
294 contract ERC20 is Context, IERC20 {
295     using SafeMath for uint256;
296 
297     mapping (address => uint256) private _balances;
298 
299     mapping (address => mapping (address => uint256)) private _allowances;
300 
301     uint256 private _totalSupply;
302 
303     string private _name;
304     string private _symbol;
305     uint8 private _decimals;
306 
307     /**
308      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
309      * a default value of 18.
310      *
311      * To select a different value for {decimals}, use {_setupDecimals}.
312      *
313      * All three of these values are immutable: they can only be set once during
314      * construction.
315      */
316     constructor (string memory name_, string memory symbol_) public {
317         _name = name_;
318         _symbol = symbol_;
319         _decimals = 18;
320     }
321 
322     /**
323      * @dev Returns the name of the token.
324      */
325     function name() public view returns (string memory) {
326         return _name;
327     }
328 
329     /**
330      * @dev Returns the symbol of the token, usually a shorter version of the
331      * name.
332      */
333     function symbol() public view returns (string memory) {
334         return _symbol;
335     }
336 
337     /**
338      * @dev Returns the number of decimals used to get its user representation.
339      * For example, if `decimals` equals `2`, a balance of `505` tokens should
340      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
341      *
342      * Tokens usually opt for a value of 18, imitating the relationship between
343      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
344      * called.
345      *
346      * NOTE: This information is only used for _display_ purposes: it in
347      * no way affects any of the arithmetic of the contract, including
348      * {IERC20-balanceOf} and {IERC20-transfer}.
349      */
350     function decimals() public view returns (uint8) {
351         return _decimals;
352     }
353 
354     /**
355      * @dev See {IERC20-totalSupply}.
356      */
357     function totalSupply() public view override returns (uint256) {
358         return _totalSupply;
359     }
360 
361     /**
362      * @dev See {IERC20-balanceOf}.
363      */
364     function balanceOf(address account) public view override returns (uint256) {
365         return _balances[account];
366     }
367 
368     /**
369      * @dev See {IERC20-transfer}.
370      *
371      * Requirements:
372      *
373      * - `recipient` cannot be the zero address.
374      * - the caller must have a balance of at least `amount`.
375      */
376     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
377         _transfer(_msgSender(), recipient, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-allowance}.
383      */
384     function allowance(address owner, address spender) public view virtual override returns (uint256) {
385         return _allowances[owner][spender];
386     }
387 
388     /**
389      * @dev See {IERC20-approve}.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function approve(address spender, uint256 amount) public virtual override returns (bool) {
396         _approve(_msgSender(), spender, amount);
397         return true;
398     }
399 
400     /**
401      * @dev See {IERC20-transferFrom}.
402      *
403      * Emits an {Approval} event indicating the updated allowance. This is not
404      * required by the EIP. See the note at the beginning of {ERC20}.
405      *
406      * Requirements:
407      *
408      * - `sender` and `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      * - the caller must have allowance for ``sender``'s tokens of at least
411      * `amount`.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
414         _transfer(sender, recipient, amount);
415         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
452         return true;
453     }
454 
455     /**
456      * @dev Moves tokens `amount` from `sender` to `recipient`.
457      *
458      * This is internal function is equivalent to {transfer}, and can be used to
459      * e.g. implement automatic token fees, slashing mechanisms, etc.
460      *
461      * Emits a {Transfer} event.
462      *
463      * Requirements:
464      *
465      * - `sender` cannot be the zero address.
466      * - `recipient` cannot be the zero address.
467      * - `sender` must have a balance of at least `amount`.
468      */
469     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _beforeTokenTransfer(sender, recipient, amount);
474 
475         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
476         _balances[recipient] = _balances[recipient].add(amount);
477         emit Transfer(sender, recipient, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `to` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply = _totalSupply.add(amount);
495         _balances[account] = _balances[account].add(amount);
496         emit Transfer(address(0), account, amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`, reducing the
501      * total supply.
502      *
503      * Emits a {Transfer} event with `to` set to the zero address.
504      *
505      * Requirements:
506      *
507      * - `account` cannot be the zero address.
508      * - `account` must have at least `amount` tokens.
509      */
510     function _burn(address account, uint256 amount) internal virtual {
511         require(account != address(0), "ERC20: burn from the zero address");
512 
513         _beforeTokenTransfer(account, address(0), amount);
514 
515         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
516         _totalSupply = _totalSupply.sub(amount);
517         emit Transfer(account, address(0), amount);
518     }
519 
520     /**
521      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
522      *
523      * This internal function is equivalent to `approve`, and can be used to
524      * e.g. set automatic allowances for certain subsystems, etc.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `owner` cannot be the zero address.
531      * - `spender` cannot be the zero address.
532      */
533     function _approve(address owner, address spender, uint256 amount) internal virtual {
534         require(owner != address(0), "ERC20: approve from the zero address");
535         require(spender != address(0), "ERC20: approve to the zero address");
536 
537         _allowances[owner][spender] = amount;
538         emit Approval(owner, spender, amount);
539     }
540 
541     /**
542      * @dev Sets {decimals} to a value other than the default one of 18.
543      *
544      * WARNING: This function should only be called from the constructor. Most
545      * applications that interact with token contracts will not expect
546      * {decimals} to ever change, and may work incorrectly if it does.
547      */
548     function _setupDecimals(uint8 decimals_) internal {
549         _decimals = decimals_;
550     }
551 
552     /**
553      * @dev Hook that is called before any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * will be to transferred to `to`.
560      * - when `from` is zero, `amount` tokens will be minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
567 }
568 
569 
570 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
571 
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
807 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.3.0
808 
809 pragma solidity >=0.6.0 <0.8.0;
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
881 
882 // File @openzeppelin/contracts/utils/Counters.sol@v3.3.0
883 
884 pragma solidity >=0.6.0 <0.8.0;
885 
886 /**
887  * @title Counters
888  * @author Matt Condon (@shrugs)
889  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
890  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
891  *
892  * Include with `using Counters for Counters.Counter;`
893  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
894  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
895  * directly accessed.
896  */
897 library Counters {
898     using SafeMath for uint256;
899 
900     struct Counter {
901         // This variable should never be directly accessed by users of the library: interactions must be restricted to
902         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
903         // this feature: see https://github.com/ethereum/solidity/issues/4637
904         uint256 _value; // default: 0
905     }
906 
907     function current(Counter storage counter) internal view returns (uint256) {
908         return counter._value;
909     }
910 
911     function increment(Counter storage counter) internal {
912         // The {SafeMath} overflow check can be skipped here, see the comment at the top
913         counter._value += 1;
914     }
915 
916     function decrement(Counter storage counter) internal {
917         counter._value = counter._value.sub(1);
918     }
919 }
920 
921 
922 // File contracts/IERC2612Permit.sol
923 
924 pragma solidity ^0.7.0;
925 
926 /**
927  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
928  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
929  *
930  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
931  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
932  * need to send a transaction, and thus is not required to hold Ether at all.
933  */
934 interface IERC2612Permit {
935     /**
936      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
937      * given `owner`'s signed approval.
938      *
939      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
940      * ordering also apply here.
941      *
942      * Emits an {Approval} event.
943      *
944      * Requirements:
945      *
946      * - `owner` cannot be the zero address.
947      * - `spender` cannot be the zero address.
948      * - `deadline` must be a timestamp in the future.
949      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
950      * over the EIP712-formatted function arguments.
951      * - the signature must use ``owner``'s current nonce (see {nonces}).
952      *
953      * For more information on the signature format, see the
954      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
955      * section].
956      */
957     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
958 
959     /**
960      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
961      * included whenever a signature is generated for {permit}.
962      *
963      * Every successful call to {permit} increases ``owner``'s nonce by one. This
964      * prevents a signature from being used multiple times.
965      */
966     function nonces(address owner) external view returns (uint256);
967 }
968 
969 
970 // File contracts/ERC20Permit.sol
971 
972 pragma solidity ^0.7.0;
973 
974 abstract contract ERC20Permit is ERC20, IERC2612Permit {
975     using Counters for Counters.Counter;
976 
977     mapping (address => Counters.Counter) private _nonces;
978 
979     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
980     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
981 
982     bytes32 public DOMAIN_SEPARATOR;
983 
984     constructor() internal {
985         uint256 chainID;
986         assembly {
987             chainID := chainid()
988         }
989 
990         DOMAIN_SEPARATOR = keccak256(
991             abi.encode(
992                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
993                 keccak256(bytes(name())),
994                 keccak256(bytes("1")), // Version
995                 chainID,
996                 address(this)
997             )
998         );
999     }
1000 
1001     /**
1002      * @dev See {IERC2612Permit-permit}.
1003      *
1004      */
1005     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1006         require(block.timestamp <= deadline, "Permit: expired deadline");
1007 
1008         bytes32 hashStruct = keccak256(
1009             abi.encode(
1010                 PERMIT_TYPEHASH,
1011                 owner,
1012                 spender,
1013                 amount,
1014                 _nonces[owner].current(),
1015                 deadline
1016             )
1017         );
1018 
1019         bytes32 _hash = keccak256(
1020             abi.encodePacked(
1021                 uint16(0x1901),
1022                 DOMAIN_SEPARATOR,
1023                 hashStruct
1024             )
1025         );
1026 
1027         address signer = ecrecover(_hash, v, r, s);
1028         require(signer != address(0) && signer == owner, "Permit: Invalid signature");
1029 
1030         _nonces[owner].increment();
1031         _approve(owner, spender, amount);
1032     }
1033 
1034     /**
1035      * @dev See {IERC2612Permit-nonces}.
1036      */
1037     function nonces(address owner) public view override returns (uint256) {
1038         return _nonces[owner].current();
1039     }
1040 }
1041 
1042 
1043 // File contracts/DeFiWizardToken.sol
1044 
1045 pragma solidity ^0.7.0;
1046 
1047 /**
1048  * @title DeFiWizard Token
1049  * @dev DeFiWizard ERC20 Token
1050  */
1051 contract DeFiWizardToken is ERC20Permit, Ownable {
1052     uint256 _tokenSupply = 1000000 * (10**18); // 1M DWZ tokens
1053     address public governance;
1054 
1055     event RecoverToken(address indexed token, address indexed destination, uint256 indexed amount);
1056 
1057     modifier onlyGovernance() {
1058         require(msg.sender == governance, "!governance");
1059         _;
1060     }
1061 
1062     constructor() ERC20("DeFiWizard Token", "DWZ") {
1063         governance = msg.sender;
1064         _mint(governance, _tokenSupply);
1065     }
1066 
1067     /**
1068      * @notice Function to set governance contract
1069      * Owner is assumed to be governance
1070      * @param _governance Address of governance contract
1071      */
1072     function setGovernance(address _governance) public onlyGovernance {
1073         governance = _governance;
1074     }
1075 
1076     /**
1077      * @notice Function to recover funds
1078      * Owner is assumed to be governance or DeFiWizard trusted party for helping users
1079      * Funtion can be disabled by destroying ownership via `renounceOwnership` function
1080      * @param token Address of token to be rescued
1081      * @param destination User address
1082      * @param amount Amount of tokens
1083      */
1084     function recoverToken(
1085         address token,
1086         address destination,
1087         uint256 amount
1088     ) external onlyGovernance {
1089         require(token != destination, "Invalid address");
1090         require(IERC20(token).transfer(destination, amount), "Retrieve failed");
1091         emit RecoverToken(token, destination, amount);
1092     }
1093 }