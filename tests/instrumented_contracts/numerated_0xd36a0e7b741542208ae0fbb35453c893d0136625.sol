1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 /*
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with GSN meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 contract Context {
169     // Empty internal constructor, to prevent people from mistakenly deploying
170     // an instance of this contract, which should be used via inheritance.
171     constructor () internal { }
172     // solhint-disable-previous-line no-empty-blocks
173 
174     function _msgSender() internal view returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see {ERC20Detailed}.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through {transferFrom}. This is
211      * zero by default.
212      *
213      * This value changes when {approve} or {transferFrom} are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * IMPORTANT: Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20Mintable}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) private _balances;
287 
288     mapping (address => mapping (address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     /**
293      * @dev See {IERC20-totalSupply}.
294      */
295     function totalSupply() public view returns (uint256) {
296         return _totalSupply;
297     }
298 
299     /**
300      * @dev See {IERC20-balanceOf}.
301      */
302     function balanceOf(address account) public view returns (uint256) {
303         return _balances[account];
304     }
305 
306     /**
307      * @dev See {IERC20-transfer}.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      * - the caller must have a balance of at least `amount`.
313      */
314     function transfer(address recipient, uint256 amount) public returns (bool) {
315         _transfer(_msgSender(), recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-allowance}.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     /**
327      * @dev See {IERC20-approve}.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 amount) public returns (bool) {
334         _approve(_msgSender(), spender, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-transferFrom}.
340      *
341      * Emits an {Approval} event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of {ERC20};
343      *
344      * Requirements:
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      * - the caller must have allowance for `sender`'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
351         _transfer(sender, recipient, amount);
352         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
389         return true;
390     }
391 
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(address sender, address recipient, uint256 amount) internal {
407         require(sender != address(0), "ERC20: transfer from the zero address");
408         require(recipient != address(0), "ERC20: transfer to the zero address");
409 
410         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `to` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _totalSupply = _totalSupply.add(amount);
428         _balances[account] = _balances[account].add(amount);
429         emit Transfer(address(0), account, amount);
430     }
431 
432     /**
433      * @dev Destroys `amount` tokens from `account`, reducing the
434      * total supply.
435      *
436      * Emits a {Transfer} event with `to` set to the zero address.
437      *
438      * Requirements
439      *
440      * - `account` cannot be the zero address.
441      * - `account` must have at least `amount` tokens.
442      */
443     function _burn(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: burn from the zero address");
445 
446         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
447         _totalSupply = _totalSupply.sub(amount);
448         emit Transfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
453      *
454      * This is internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 amount) internal {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
474      * from the caller's allowance.
475      *
476      * See {_burn} and {_approve}.
477      */
478     function _burnFrom(address account, uint256 amount) internal {
479         _burn(account, amount);
480         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
481     }
482 }
483 
484 /**
485  * @dev Optional functions from the ERC20 standard.
486  */
487 contract ERC20Detailed is IERC20 {
488     string private _name;
489     string private _symbol;
490     uint8 private _decimals;
491 
492     /**
493      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
494      * these values are immutable: they can only be set once during
495      * construction.
496      */
497     constructor (string memory name, string memory symbol, uint8 decimals) public {
498         _name = name;
499         _symbol = symbol;
500         _decimals = decimals;
501     }
502 
503     /**
504      * @dev Returns the name of the token.
505      */
506     function name() public view returns (string memory) {
507         return _name;
508     }
509 
510     /**
511      * @dev Returns the symbol of the token, usually a shorter version of the
512      * name.
513      */
514     function symbol() public view returns (string memory) {
515         return _symbol;
516     }
517 
518     /**
519      * @dev Returns the number of decimals used to get its user representation.
520      * For example, if `decimals` equals `2`, a balance of `505` tokens should
521      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
522      *
523      * Tokens usually opt for a value of 18, imitating the relationship between
524      * Ether and Wei.
525      *
526      * NOTE: This information is only used for _display_ purposes: it in
527      * no way affects any of the arithmetic of the contract, including
528      * {IERC20-balanceOf} and {IERC20-transfer}.
529      */
530     function decimals() public view returns (uint8) {
531         return _decimals;
532     }
533 }
534 
535 /**
536  * @dev Contract module which provides a basic access control mechanism, where
537  * there is an account (an owner) that can be granted exclusive access to
538  * specific functions.
539  *
540  * This module is used through inheritance. It will make available the modifier
541  * `onlyOwner`, which can be applied to your functions to restrict their use to
542  * the owner.
543  */
544 contract Ownable is Context {
545     address private _owner;
546 
547     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548 
549     /**
550      * @dev Initializes the contract setting the deployer as the initial owner.
551      */
552     constructor () internal {
553         address msgSender = _msgSender();
554         _owner = msgSender;
555         emit OwnershipTransferred(address(0), msgSender);
556     }
557 
558     /**
559      * @dev Returns the address of the current owner.
560      */
561     function owner() public view returns (address) {
562         return _owner;
563     }
564 
565     /**
566      * @dev Throws if called by any account other than the owner.
567      */
568     modifier onlyOwner() {
569         require(isOwner(), "Ownable: caller is not the owner");
570         _;
571     }
572 
573     /**
574      * @dev Returns true if the caller is the current owner.
575      */
576     function isOwner() public view returns (bool) {
577         return _msgSender() == _owner;
578     }
579 
580     /**
581      * @dev Leaves the contract without owner. It will not be possible to call
582      * `onlyOwner` functions anymore. Can only be called by the current owner.
583      *
584      * NOTE: Renouncing ownership will leave the contract without an owner,
585      * thereby removing any functionality that is only available to the owner.
586      */
587     function renounceOwnership() public onlyOwner {
588         emit OwnershipTransferred(_owner, address(0));
589         _owner = address(0);
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public onlyOwner {
597         _transferOwnership(newOwner);
598     }
599 
600     /**
601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
602      */
603     function _transferOwnership(address newOwner) internal {
604         require(newOwner != address(0), "Ownable: new owner is the zero address");
605         emit OwnershipTransferred(_owner, newOwner);
606         _owner = newOwner;
607     }
608 }
609 
610 /**
611  * @title ERC20Upgradable
612  * @dev ERC20 token whose balances can be initialized to those of a prior version of the token.
613  */
614 contract ERC20Upgradable is ERC20, Ownable {
615     using SafeMath for uint256;
616 
617     /**
618      * @dev Emitted when all balances have been initialized.
619      */
620     event BalancesInitialized();
621     
622     /**
623      * @dev Keeps track of whether all balances have been initialized.
624      */
625     bool public _balancesInitialized = false;
626 
627     /**
628      * @dev Initializes balances on token launch.
629      * @param accounts The addresses to mint to.
630      * @param amounts The amounts to be minted.
631      */
632     function initBalances(address[] calldata accounts, uint32[] calldata amounts) external onlyOwner returns (bool) {
633         require(!_balancesInitialized, "Balance initialization already complete.");
634         require(accounts.length > 0 && accounts.length == amounts.length, "Mismatch between number of accounts and amounts.");
635         for (uint256 i = 0; i < accounts.length; i++) _mint(accounts[i], uint256(amounts[i]));
636         return true;
637     }
638 
639     /**
640      * @dev Marks balance initialization as complete.
641      */
642     function completeInitialization() external onlyOwner returns (bool) {
643         require(!_balancesInitialized, "Balance initialization already complete.");
644         _balancesInitialized = true;
645         emit BalancesInitialized();
646         return true;
647     }
648 }
649 
650 /**
651  * @title ERC20SwappableInput
652  * @dev ERC20 token that can be converted to another ERC20 token.
653  */
654 contract ERC20SwappableInput is ERC20, Ownable {
655     using SafeMath for uint256;
656 
657     /**
658      * @dev Emitted when funds have been burned and queued for swapping to another token.
659      */
660     event SwapInput(address indexed outputToken, address indexed payee, uint256 inputAmount, uint256 outputAmount);
661 
662     /**
663      * @dev Swaps funds to another token.
664      * @param outputToken The output ERC20SwappableOutput token contract address.
665      * @param payee The address to which the output funds will be sent.
666      * @param inputAmount The amount of input tokens to be burned.
667      */
668     function swap(address outputToken, address payee, uint256 inputAmount) external returns (bool) {
669         require(_outputSwapTokens[outputToken] != 0, "Output token is not a registered output swap token.");
670         require(inputAmount > 0, "No funds inputted to swap.");
671         require(inputAmount <= this.balanceOf(payee), "Input amount cannot be greater than input token balance.");
672         require(_outputSwapTokens[outputToken] < 0 || inputAmount <= uint256(_outputSwapTokens[outputToken]), "Input amount is greater than the limit for this output token.");
673         ERC20SwappableOutput outputContract = ERC20SwappableOutput(outputToken);
674         uint256 outputTotalSupply = outputContract.totalSupply();
675         require(outputTotalSupply > 0, "Cannot reference zero total supply of output tokens when calculating output token amount.");
676         uint256 outputAmount = inputAmount.mul(outputTotalSupply).div(this.totalSupply());
677         _burn(msg.sender, inputAmount);
678         require(outputContract.finishSwap(msg.sender, inputAmount, outputAmount), "Failed to finish swap with output token.");
679         emit SwapInput(msg.sender, payee, inputAmount, outputAmount);
680         return true;
681     }
682 
683     mapping(address => int256) private _outputSwapTokens;
684 
685     /**
686      * @dev Registers an output swap token.
687      * @param token The address of the token.
688      */
689     function addOutputSwapToken(address token, uint256 limit) external onlyOwner returns (bool) {
690         _outputSwapTokens[token] = limit > 0 ? int256(limit) : -1;
691         return true;
692     }
693 
694     /**
695      * @dev Unregisters an output swap token.
696      * @param token The address of the token.
697      */
698     function removeOutputSwapToken(address token) external onlyOwner returns (bool) {
699         _outputSwapTokens[token] = 0;
700         return true;
701     }
702 }
703 
704 /**
705  * @title ERC20SwappableOutput
706  * @dev ERC20 token that can be converted from another ERC20 token.
707  */
708 contract ERC20SwappableOutput is ERC20, Ownable {
709     using SafeMath for uint256;
710 
711     /**
712      * @dev Emitted when funds have been successfully swapped from another token.
713      */
714     event SwapOutput(address indexed inputToken, address indexed payee, uint256 inputAmount, uint256 outputAmount);
715 
716     /**
717      * @dev Transfer previously locked funds to a payee at or after the minimum unlock time.
718      * @param payee The address whose previously locked funds will be unlocked and transferred to.
719      * @param inputAmount The amount of input tokens to be burned.
720      * @param outputAmount The amount of output tokens to be minted.
721      */
722     function finishSwap(address payee, uint256 inputAmount, uint256 outputAmount) external onlyInputSwapToken returns (bool) {
723         _mint(payee, outputAmount);
724         emit SwapOutput(msg.sender, payee, inputAmount, outputAmount);
725         return true;
726     }
727 
728     mapping(address => bool) private _inputSwapTokens;
729 
730     /**
731      * @dev Registers an input swap token.
732      * @param token The address of the token.
733      */
734     function addInputSwapToken(address token) external onlyOwner returns (bool) {
735         _inputSwapTokens[token] = true;
736         return true;
737     }
738 
739     /**
740      * @dev Unregisters an input swap token.
741      * @param token The address of the token.
742      */
743     function removeInputSwapToken(address token) external onlyOwner returns (bool) {
744         _inputSwapTokens[token] = false;
745         return true;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than a registered input swap token.
750      */
751     modifier onlyInputSwapToken() {
752         require(isInputSwapToken(), "ERC20SwappableOutput: caller is not a registered input swap token");
753         _;
754     }
755 
756     /**
757      * @dev Returns true if the caller is a registered input swap token.
758      */
759     function isInputSwapToken() public view returns (bool) {
760         return _inputSwapTokens[msg.sender];
761     }
762 }
763 
764 /**
765  * @title ITOUtilityToken
766  * @dev Version 1 of the ERC20 token contract for ITO Utility Token.
767  */
768 contract ITOUtilityToken is ERC20, ERC20Detailed, ERC20Upgradable, ERC20SwappableInput, ERC20SwappableOutput {
769     using SafeMath for uint256;
770 
771     /**
772      * @dev After the token is constructed, we will copy all token balances from version 1 of the MVG Network Token at block 9,960,000.
773      */
774     constructor () public ERC20Detailed("ITO Utility Token", "IUT", 0) { }
775 }