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
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/math/SafeMath.sol
98 
99 
100 pragma solidity >=0.6.0 <0.8.0;
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
259 
260 
261 pragma solidity >=0.6.0 <0.8.0;
262 
263 /**
264  * @dev Interface of the ERC20 standard as defined in the EIP.
265  */
266 interface IERC20 {
267     /**
268      * @dev Returns the amount of tokens in existence.
269      */
270     function totalSupply() external view returns (uint256);
271 
272     /**
273      * @dev Returns the amount of tokens owned by `account`.
274      */
275     function balanceOf(address account) external view returns (uint256);
276 
277     /**
278      * @dev Moves `amount` tokens from the caller's account to `recipient`.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transfer(address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Returns the remaining number of tokens that `spender` will be
288      * allowed to spend on behalf of `owner` through {transferFrom}. This is
289      * zero by default.
290      *
291      * This value changes when {approve} or {transferFrom} are called.
292      */
293     function allowance(address owner, address spender) external view returns (uint256);
294 
295     /**
296      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * IMPORTANT: Beware that changing an allowance with this method brings the risk
301      * that someone may use both the old and the new allowance by unfortunate
302      * transaction ordering. One possible solution to mitigate this race
303      * condition is to first reduce the spender's allowance to 0 and set the
304      * desired value afterwards:
305      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
306      *
307      * Emits an {Approval} event.
308      */
309     function approve(address spender, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Moves `amount` tokens from `sender` to `recipient` using the
313      * allowance mechanism. `amount` is then deducted from the caller's
314      * allowance.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Emitted when `value` tokens are moved from one account (`from`) to
324      * another (`to`).
325      *
326      * Note that `value` may be zero.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 value);
329 
330     /**
331      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
332      * a call to {approve}. `value` is the new allowance.
333      */
334     event Approval(address indexed owner, address indexed spender, uint256 value);
335 }
336 
337 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
338 
339 
340 pragma solidity >=0.6.0 <0.8.0;
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
371 
372     mapping (address => uint256) private _balances;
373 
374     mapping (address => mapping (address => uint256)) private _allowances;
375 
376     uint256 private _totalSupply;
377 
378     string private _name;
379     string private _symbol;
380     uint8 private _decimals;
381 
382     /**
383      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
384      * a default value of 18.
385      *
386      * To select a different value for {decimals}, use {_setupDecimals}.
387      *
388      * All three of these values are immutable: they can only be set once during
389      * construction.
390      */
391     constructor (string memory name_, string memory symbol_) public {
392         _name = name_;
393         _symbol = symbol_;
394         _decimals = 18;
395     }
396 
397     /**
398      * @dev Returns the name of the token.
399      */
400     function name() public view returns (string memory) {
401         return _name;
402     }
403 
404     /**
405      * @dev Returns the symbol of the token, usually a shorter version of the
406      * name.
407      */
408     function symbol() public view returns (string memory) {
409         return _symbol;
410     }
411 
412     /**
413      * @dev Returns the number of decimals used to get its user representation.
414      * For example, if `decimals` equals `2`, a balance of `505` tokens should
415      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
416      *
417      * Tokens usually opt for a value of 18, imitating the relationship between
418      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
419      * called.
420      *
421      * NOTE: This information is only used for _display_ purposes: it in
422      * no way affects any of the arithmetic of the contract, including
423      * {IERC20-balanceOf} and {IERC20-transfer}.
424      */
425     function decimals() public view returns (uint8) {
426         return _decimals;
427     }
428 
429     /**
430      * @dev See {IERC20-totalSupply}.
431      */
432     function totalSupply() public view override returns (uint256) {
433         return _totalSupply;
434     }
435 
436     /**
437      * @dev See {IERC20-balanceOf}.
438      */
439     function balanceOf(address account) public view override returns (uint256) {
440         return _balances[account];
441     }
442 
443     /**
444      * @dev See {IERC20-transfer}.
445      *
446      * Requirements:
447      *
448      * - `recipient` cannot be the zero address.
449      * - the caller must have a balance of at least `amount`.
450      */
451     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
452         _transfer(_msgSender(), recipient, amount);
453         return true;
454     }
455 
456     /**
457      * @dev See {IERC20-allowance}.
458      */
459     function allowance(address owner, address spender) public view virtual override returns (uint256) {
460         return _allowances[owner][spender];
461     }
462 
463     /**
464      * @dev See {IERC20-approve}.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      */
470     function approve(address spender, uint256 amount) public virtual override returns (bool) {
471         _approve(_msgSender(), spender, amount);
472         return true;
473     }
474 
475     /**
476      * @dev See {IERC20-transferFrom}.
477      *
478      * Emits an {Approval} event indicating the updated allowance. This is not
479      * required by the EIP. See the note at the beginning of {ERC20}.
480      *
481      * Requirements:
482      *
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
560      * Requirements:
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
580      * Requirements:
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
596      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
597      *
598      * This internal function is equivalent to `approve`, and can be used to
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
644 // File: @openzeppelin/contracts/utils/Address.sol
645 
646 
647 pragma solidity >=0.6.2 <0.8.0;
648 
649 /**
650  * @dev Collection of functions related to the address type
651  */
652 library Address {
653     /**
654      * @dev Returns true if `account` is a contract.
655      *
656      * [IMPORTANT]
657      * ====
658      * It is unsafe to assume that an address for which this function returns
659      * false is an externally-owned account (EOA) and not a contract.
660      *
661      * Among others, `isContract` will return false for the following
662      * types of addresses:
663      *
664      *  - an externally-owned account
665      *  - a contract in construction
666      *  - an address where a contract will be created
667      *  - an address where a contract lived, but was destroyed
668      * ====
669      */
670     function isContract(address account) internal view returns (bool) {
671         // This method relies on extcodesize, which returns 0 for contracts in
672         // construction, since the code is only stored at the end of the
673         // constructor execution.
674 
675         uint256 size;
676         // solhint-disable-next-line no-inline-assembly
677         assembly { size := extcodesize(account) }
678         return size > 0;
679     }
680 
681     /**
682      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
683      * `recipient`, forwarding all available gas and reverting on errors.
684      *
685      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
686      * of certain opcodes, possibly making contracts go over the 2300 gas limit
687      * imposed by `transfer`, making them unable to receive funds via
688      * `transfer`. {sendValue} removes this limitation.
689      *
690      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
691      *
692      * IMPORTANT: because control is transferred to `recipient`, care must be
693      * taken to not create reentrancy vulnerabilities. Consider using
694      * {ReentrancyGuard} or the
695      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
696      */
697     function sendValue(address payable recipient, uint256 amount) internal {
698         require(address(this).balance >= amount, "Address: insufficient balance");
699 
700         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
701         (bool success, ) = recipient.call{ value: amount }("");
702         require(success, "Address: unable to send value, recipient may have reverted");
703     }
704 
705     /**
706      * @dev Performs a Solidity function call using a low level `call`. A
707      * plain`call` is an unsafe replacement for a function call: use this
708      * function instead.
709      *
710      * If `target` reverts with a revert reason, it is bubbled up by this
711      * function (like regular Solidity function calls).
712      *
713      * Returns the raw returned data. To convert to the expected return value,
714      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
715      *
716      * Requirements:
717      *
718      * - `target` must be a contract.
719      * - calling `target` with `data` must not revert.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
724       return functionCall(target, data, "Address: low-level call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
729      * `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, 0, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but also transferring `value` wei to `target`.
740      *
741      * Requirements:
742      *
743      * - the calling contract must have an ETH balance of at least `value`.
744      * - the called Solidity function must be `payable`.
745      *
746      * _Available since v3.1._
747      */
748     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
749         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
754      * with `errorMessage` as a fallback revert reason when `target` reverts.
755      *
756      * _Available since v3.1._
757      */
758     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
759         require(address(this).balance >= value, "Address: insufficient balance for call");
760         require(isContract(target), "Address: call to non-contract");
761 
762         // solhint-disable-next-line avoid-low-level-calls
763         (bool success, bytes memory returndata) = target.call{ value: value }(data);
764         return _verifyCallResult(success, returndata, errorMessage);
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
769      * but performing a static call.
770      *
771      * _Available since v3.3._
772      */
773     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
774         return functionStaticCall(target, data, "Address: low-level static call failed");
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
779      * but performing a static call.
780      *
781      * _Available since v3.3._
782      */
783     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
784         require(isContract(target), "Address: static call to non-contract");
785 
786         // solhint-disable-next-line avoid-low-level-calls
787         (bool success, bytes memory returndata) = target.staticcall(data);
788         return _verifyCallResult(success, returndata, errorMessage);
789     }
790 
791     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
792         if (success) {
793             return returndata;
794         } else {
795             // Look for revert reason and bubble it up if present
796             if (returndata.length > 0) {
797                 // The easiest way to bubble the revert reason is using memory via assembly
798 
799                 // solhint-disable-next-line no-inline-assembly
800                 assembly {
801                     let returndata_size := mload(returndata)
802                     revert(add(32, returndata), returndata_size)
803                 }
804             } else {
805                 revert(errorMessage);
806             }
807         }
808     }
809 }
810 
811 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
812 
813 
814 pragma solidity >=0.6.0 <0.8.0;
815 
816 
817 
818 
819 /**
820  * @title SafeERC20
821  * @dev Wrappers around ERC20 operations that throw on failure (when the token
822  * contract returns false). Tokens that return no value (and instead revert or
823  * throw on failure) are also supported, non-reverting calls are assumed to be
824  * successful.
825  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
826  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
827  */
828 library SafeERC20 {
829     using SafeMath for uint256;
830     using Address for address;
831 
832     function safeTransfer(IERC20 token, address to, uint256 value) internal {
833         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
834     }
835 
836     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
837         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
838     }
839 
840     /**
841      * @dev Deprecated. This function has issues similar to the ones found in
842      * {IERC20-approve}, and its usage is discouraged.
843      *
844      * Whenever possible, use {safeIncreaseAllowance} and
845      * {safeDecreaseAllowance} instead.
846      */
847     function safeApprove(IERC20 token, address spender, uint256 value) internal {
848         // safeApprove should only be called when setting an initial allowance,
849         // or when resetting it to zero. To increase and decrease it, use
850         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
851         // solhint-disable-next-line max-line-length
852         require((value == 0) || (token.allowance(address(this), spender) == 0),
853             "SafeERC20: approve from non-zero to non-zero allowance"
854         );
855         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
856     }
857 
858     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
859         uint256 newAllowance = token.allowance(address(this), spender).add(value);
860         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
861     }
862 
863     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
864         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
865         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
866     }
867 
868     /**
869      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
870      * on the return value: the return value is optional (but if data is returned, it must not be false).
871      * @param token The token targeted by the call.
872      * @param data The call data (encoded using abi.encode or one of its variants).
873      */
874     function _callOptionalReturn(IERC20 token, bytes memory data) private {
875         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
876         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
877         // the target address contains contract code and also asserts for success in the low-level call.
878 
879         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
880         if (returndata.length > 0) { // Return data is optional
881             // solhint-disable-next-line max-line-length
882             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
883         }
884     }
885 }
886 
887 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
888 
889 
890 pragma solidity >=0.6.0 <0.8.0;
891 
892 /**
893  * @dev Contract module that helps prevent reentrant calls to a function.
894  *
895  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
896  * available, which can be applied to functions to make sure there are no nested
897  * (reentrant) calls to them.
898  *
899  * Note that because there is a single `nonReentrant` guard, functions marked as
900  * `nonReentrant` may not call one another. This can be worked around by making
901  * those functions `private`, and then adding `external` `nonReentrant` entry
902  * points to them.
903  *
904  * TIP: If you would like to learn more about reentrancy and alternative ways
905  * to protect against it, check out our blog post
906  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
907  */
908 abstract contract ReentrancyGuard {
909     // Booleans are more expensive than uint256 or any type that takes up a full
910     // word because each write operation emits an extra SLOAD to first read the
911     // slot's contents, replace the bits taken up by the boolean, and then write
912     // back. This is the compiler's defense against contract upgrades and
913     // pointer aliasing, and it cannot be disabled.
914 
915     // The values being non-zero value makes deployment a bit more expensive,
916     // but in exchange the refund on every call to nonReentrant will be lower in
917     // amount. Since refunds are capped to a percentage of the total
918     // transaction's gas, it is best to keep them low in cases like this one, to
919     // increase the likelihood of the full refund coming into effect.
920     uint256 private constant _NOT_ENTERED = 1;
921     uint256 private constant _ENTERED = 2;
922 
923     uint256 private _status;
924 
925     constructor () internal {
926         _status = _NOT_ENTERED;
927     }
928 
929     /**
930      * @dev Prevents a contract from calling itself, directly or indirectly.
931      * Calling a `nonReentrant` function from another `nonReentrant`
932      * function is not supported. It is possible to prevent this from happening
933      * by making the `nonReentrant` function external, and make it call a
934      * `private` function that does the actual work.
935      */
936     modifier nonReentrant() {
937         // On the first call to nonReentrant, _notEntered will be true
938         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
939 
940         // Any calls to nonReentrant after this point will fail
941         _status = _ENTERED;
942 
943         _;
944 
945         // By storing the original value once again, a refund is triggered (see
946         // https://eips.ethereum.org/EIPS/eip-2200)
947         _status = _NOT_ENTERED;
948     }
949 }
950 
951 // File: contracts/LiquidityFarming.sol
952 
953 
954 pragma solidity ^0.6.12;
955 
956 
957 
958 
959 
960 
961 contract LiquidityFarming is Ownable, ReentrancyGuard {
962     using SafeMath for uint256;
963     using SafeERC20 for ERC20;
964 
965     ERC20 public immutable lp;
966     ERC20 public immutable sarco;
967 
968     uint256 public totalStakers;
969     uint256 public totalRewards;
970     uint256 public totalClaimedRewards;
971     uint256 public startTime;
972     uint256 public firstStakeTime;
973     uint256 public endTime;
974 
975     uint256 public totalStakeLp;
976     uint256 private _totalWeight;
977     uint256 private _mostRecentValueCalcTime;
978 
979     mapping(address => uint256) public userClaimedRewards;
980 
981     mapping(address => uint256) public userStakeLp;
982     mapping(address => uint256) private _userWeighted;
983     mapping(address => uint256) private _userAccumulated;
984 
985     event Deposit(uint256 totalRewards, uint256 startTime, uint256 endTime);
986     event Stake(address indexed staker, uint256 lpIn);
987     event Payout(address indexed staker, uint256 reward, address to);
988     event Withdraw(address indexed staker, uint256 lpOut, address to);
989 
990     constructor(
991         address _lp,
992         address _sarco
993     ) public {
994         lp = ERC20(_lp);
995         sarco = ERC20(_sarco);
996     }
997 
998     function deposit(
999         uint256 _totalRewards,
1000         uint256 _startTime,
1001         uint256 _endTime
1002     ) public onlyOwner {
1003         require(
1004             startTime == 0,
1005             "LiquidityFarming::deposit: already received deposit"
1006         );
1007 
1008         require(
1009             _startTime >= block.timestamp,
1010             "LiquidityFarming::deposit: start time must be in future"
1011         );
1012 
1013         require(
1014             _endTime > _startTime,
1015             "LiquidityFarming::deposit: end time must after start time"
1016         );
1017 
1018         require(
1019             sarco.balanceOf(address(this)) == _totalRewards,
1020             "LiquidityFarming::deposit: contract balance does not equal expected _totalRewards"
1021         );
1022 
1023         totalRewards = _totalRewards;
1024         startTime = _startTime;
1025         endTime = _endTime;
1026 
1027         emit Deposit(_totalRewards, _startTime, _endTime);
1028     }
1029 
1030     modifier update() {
1031         if (_mostRecentValueCalcTime == 0) {
1032             _mostRecentValueCalcTime = firstStakeTime;
1033         }
1034 
1035         uint256 totalCurrentStake = totalStakeLp;
1036 
1037         if (totalCurrentStake > 0 && _mostRecentValueCalcTime < endTime) {
1038             uint256 value = 0;
1039             uint256 sinceLastCalc =
1040                 block.timestamp.sub(_mostRecentValueCalcTime);
1041             uint256 perSecondReward =
1042                 totalRewards.div(endTime.sub(firstStakeTime));
1043 
1044             if (block.timestamp < endTime) {
1045                 value = sinceLastCalc.mul(perSecondReward);
1046             } else {
1047                 uint256 sinceEndTime = block.timestamp.sub(endTime);
1048                 value = (sinceLastCalc.sub(sinceEndTime)).mul(perSecondReward);
1049             }
1050 
1051             _totalWeight = _totalWeight.add(
1052                 value.mul(10**18).div(totalCurrentStake)
1053             );
1054 
1055             _mostRecentValueCalcTime = block.timestamp;
1056         }
1057 
1058         _;
1059     }
1060 
1061     function stake(uint256 lpIn) public update nonReentrant {
1062         require(lpIn > 0, "LiquidityFarming::stake: missing LP");
1063         require(
1064             block.timestamp >= startTime,
1065             "LiquidityFarming::stake: staking isn't live yet"
1066         );
1067         require(
1068             sarco.balanceOf(address(this)) > 0,
1069             "LiquidityFarming::stake: no sarco balance"
1070         );
1071 
1072         if (firstStakeTime == 0) {
1073             firstStakeTime = block.timestamp;
1074         } else {
1075             require(
1076                 block.timestamp < endTime,
1077                 "LiquidityFarming::stake: staking is over"
1078             );
1079         }
1080 
1081         lp.safeTransferFrom(msg.sender, address(this), lpIn);
1082 
1083         if (userStakeLp[msg.sender] == 0) {
1084             totalStakers = totalStakers.add(1);
1085         }
1086 
1087         _stake(lpIn, msg.sender);
1088 
1089         emit Stake(msg.sender, lpIn);
1090     }
1091 
1092     function withdraw(address to)
1093         public
1094         update
1095         nonReentrant
1096         returns (uint256 lpOut, uint256 reward)
1097     {
1098         totalStakers = totalStakers.sub(1);
1099 
1100         (lpOut, reward) = _applyReward(msg.sender);
1101 
1102         lp.safeTransfer(to, lpOut);
1103 
1104         if (reward > 0) {
1105             sarco.safeTransfer(to, reward);
1106             userClaimedRewards[msg.sender] = userClaimedRewards[msg.sender].add(
1107                 reward
1108             );
1109             totalClaimedRewards = totalClaimedRewards.add(reward);
1110 
1111             emit Payout(msg.sender, reward, to);
1112         }
1113 
1114         emit Withdraw(msg.sender, lpOut, to);
1115     }
1116 
1117     function payout(address to)
1118         public
1119         update
1120         nonReentrant
1121         returns (uint256 reward)
1122     {
1123         require(
1124             block.timestamp < endTime,
1125             "LiquidityFarming::payout: withdraw instead"
1126         );
1127 
1128         (uint256 lpOut, uint256 _reward) = _applyReward(msg.sender);
1129 
1130         reward = _reward;
1131 
1132         if (reward > 0) {
1133             sarco.safeTransfer(to, reward);
1134             userClaimedRewards[msg.sender] = userClaimedRewards[msg.sender].add(
1135                 reward
1136             );
1137             totalClaimedRewards = totalClaimedRewards.add(reward);
1138         }
1139 
1140         _stake(lpOut, msg.sender);
1141 
1142         emit Payout(msg.sender, _reward, to);
1143     }
1144 
1145     function _stake(uint256 lpIn, address account) private {
1146         uint256 addBackLp;
1147 
1148         if (userStakeLp[account] > 0) {
1149             (uint256 lpOut, uint256 reward) = _applyReward(account);
1150             addBackLp = lpOut;
1151             userStakeLp[account] = lpOut;
1152             _userAccumulated[account] = reward;
1153         }
1154 
1155         userStakeLp[account] = userStakeLp[account].add(lpIn);
1156         _userWeighted[account] = _totalWeight;
1157 
1158         totalStakeLp = totalStakeLp.add(lpIn);
1159 
1160         if (addBackLp > 0) {
1161             totalStakeLp = totalStakeLp.add(addBackLp);
1162         }
1163     }
1164 
1165     function _applyReward(address account)
1166         private
1167         returns (uint256 lpOut, uint256 reward)
1168     {
1169         require(
1170             userStakeLp[account] > 0,
1171             "LiquidityFarming::_applyReward: no LP staked"
1172         );
1173 
1174         lpOut = userStakeLp[account];
1175 
1176         reward = lpOut
1177             .mul(_totalWeight.sub(_userWeighted[account]))
1178             .div(10**18)
1179             .add(_userAccumulated[account]);
1180 
1181         totalStakeLp = totalStakeLp.sub(lpOut);
1182 
1183         userStakeLp[account] = 0;
1184         _userAccumulated[account] = 0;
1185     }
1186 
1187     function rescueTokens(
1188         address tokenToRescue,
1189         address to,
1190         uint256 amount
1191     ) public onlyOwner nonReentrant {
1192         if (tokenToRescue == address(lp)) {
1193             require(
1194                 amount <= lp.balanceOf(address(this)).sub(totalStakeLp),
1195                 "LiquidityFarming::rescueTokens: that LP belongs to stakers"
1196             );
1197         } else if (tokenToRescue == address(sarco)) {
1198             if (totalStakers > 0) {
1199                 require(
1200                     amount <=
1201                         sarco.balanceOf(address(this)).sub(
1202                             totalRewards.sub(totalClaimedRewards)
1203                         ),
1204                     "LiquidityFarming::rescueTokens: that sarco belongs to stakers"
1205                 );
1206             }
1207         }
1208 
1209         ERC20(tokenToRescue).safeTransfer(to, amount);
1210     }
1211 }