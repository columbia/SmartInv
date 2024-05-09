1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 pragma solidity ^0.6.0;
30 
31 /**
32  * Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // File: @openzeppelin/contracts/math/SafeMath.sol
106 
107 pragma solidity ^0.6.0;
108 
109 /**
110  * Wrappers over Solidity's arithmetic operations with added overflow
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
124      * Returns the addition of two unsigned integers, reverting on
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
141      * Returns the subtraction of two unsigned integers, reverting on
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
155      * Returns the subtraction of two unsigned integers, reverting with custom message on
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
172      * Returns the multiplication of two unsigned integers, reverting on
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
196      * Returns the integer division of two unsigned integers. Reverts on
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
212      * Returns the integer division of two unsigned integers. Reverts with custom message on
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
232      * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
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
248      * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
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
265 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
266 
267 pragma solidity ^0.6.0;
268 
269 /**
270  * Implementation of the {IERC20} interface.
271  *
272  * This implementation is agnostic to the way tokens are created. This means
273  * that a supply mechanism has to be added in a derived contract using {_mint}.
274  * For a generic mechanism see {ERC20PresetMinterPauser}.
275  *
276  * TIP: For a detailed writeup see our guide
277  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
278  * to implement supply mechanisms].
279  *
280  * We have followed general OpenZeppelin guidelines: functions revert instead
281  * of returning `false` on failure. This behavior is nonetheless conventional
282  * and does not conflict with the expectations of ERC20 applications.
283  *
284  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
285  * This allows applications to reconstruct the allowance for all accounts just
286  * by listening to said events. Other implementations of the EIP may not emit
287  * these events, as it isn't required by the specification.
288  *
289  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
290  * functions have been added to mitigate the well-known issues around setting
291  * allowances. See {IERC20-approve}.
292  */
293 contract ERC20 is Context, IERC20 {
294     using SafeMath for uint256;
295 
296     mapping (address => uint256) private _balances;
297 
298     mapping (address => mapping (address => uint256)) private _allowances;
299 
300     uint256 private _totalSupply;
301     address public claimerAddress = address(0);
302 
303     string private _name;
304     string private _symbol;
305     uint8 private _decimals;
306     
307     event ClaimerChanged(address indexed claimer);
308 
309     /**
310      * Sets the values for {name} and {symbol}, initializes {decimals} with
311      * a default value of 18.
312      *
313      * To select a different value for {decimals}, use {_setupDecimals}.
314      *
315      * All three of these values are immutable: they can only be set once during
316      * construction.
317      */
318     constructor (string memory name, string memory symbol) public {
319         _name = name;
320         _symbol = symbol;
321         _decimals = 18;
322     }
323 
324     /**
325      * Returns the name of the token.
326      */
327     function name() public view returns (string memory) {
328         return _name;
329     }
330 
331     /**
332      * Returns the symbol of the token, usually a shorter version of the
333      * name.
334      */
335     function symbol() public view returns (string memory) {
336         return _symbol;
337     }
338 
339     /**
340      * Returns the number of decimals used to get its user representation.
341      * For example, if `decimals` equals `2`, a balance of `505` tokens should
342      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
343      *
344      * Tokens usually opt for a value of 18, imitating the relationship between
345      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
346      * called.
347      *
348      * NOTE: This information is only used for _display_ purposes: it in
349      * no way affects any of the arithmetic of the contract, including
350      * {IERC20-balanceOf} and {IERC20-transfer}.
351      */
352     function decimals() public view returns (uint8) {
353         return _decimals;
354     }
355 
356     /**
357      * See {IERC20-totalSupply}.
358      */
359     function totalSupply() public view override returns (uint256) {
360         return _totalSupply;
361     }
362 
363     /**
364      * See {IERC20-balanceOf}.
365      */
366     function balanceOf(address account) public view override returns (uint256) {
367         return _balances[account];
368     }
369 
370     /**
371      * See {IERC20-transfer}.
372      *
373      * Requirements:
374      *
375      * - `recipient` cannot be the zero address.
376      * - the caller must have a balance of at least `amount`.
377      */
378     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
379         _transfer(_msgSender(), recipient, amount);
380         return true;
381     }
382 
383     /**
384      * See {IERC20-allowance}.
385      */
386     function allowance(address owner, address spender) public view virtual override returns (uint256) {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * See {IERC20-approve}.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function approve(address spender, uint256 amount) public virtual override returns (bool) {
398         _approve(_msgSender(), spender, amount);
399         return true;
400     }
401 
402     /**
403      * See {IERC20-transferFrom}.
404      *
405      * Emits an {Approval} event indicating the updated allowance. This is not
406      * required by the EIP. See the note at the beginning of {ERC20};
407      *
408      * Requirements:
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
421      * Atomically increases the allowance granted to `spender` by the caller.
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
438      * Atomically decreases the allowance granted to `spender` by the caller.
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
457      * Moves tokens `amount` from `sender` to `recipient`.
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
474         amount = _beforeTokenTransfer(sender, recipient, amount);
475 
476         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
477         _balances[recipient] = _balances[recipient].add(amount);
478         emit Transfer(sender, recipient, amount);
479     }
480 
481     /** Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements
487      *
488      * - `to` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _totalSupply = _totalSupply.add(amount);
494         _balances[account] = _balances[account].add(amount);
495         emit Transfer(address(0), account, amount);
496     }
497     
498     function _setClaimer(address newClaimer) internal virtual {
499         require(newClaimer != address(0), "Claimer address must be set to something");
500         claimerAddress = newClaimer;
501         emit ClaimerChanged(claimerAddress);
502     }
503 
504     /**
505      * Tax `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _tax(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: tax from the zero address");
517         require(claimerAddress != address(0), "Claimer address must be set to something");
518 
519         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
520         _balances[claimerAddress] = _balances[claimerAddress].add(amount);
521         emit Transfer(account, claimerAddress, amount);
522     }
523 
524     /**
525      * Sets `amount` as the allowance of `spender` over the `owner`s tokens.
526      *
527      * This is internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * Sets {decimals} to a value other than the default one of 18.
547      *
548      * WARNING: This function should only be called from the constructor. Most
549      * applications that interact with token contracts will not expect
550      * {decimals} to ever change, and may work incorrectly if it does.
551      */
552     function _setupDecimals(uint8 decimals_) internal {
553         _decimals = decimals_;
554     }
555 
556     /**
557      * Hook that is called before any transfer of tokens.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * will be to transferred to `to`.
563      * - when `from` is zero, `amount` tokens will be minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual returns (uint256) { }
570 }
571 
572 // File: @openzeppelin/contracts/access/Ownable.sol
573 
574 pragma solidity ^0.6.0;
575 
576 /**
577  * Contract module which provides a basic access control mechanism, where
578  * there is an account (an owner) that can be granted exclusive access to
579  * specific functions.
580  *
581  * By default, the owner account will be the one that deploys the contract. This
582  * can later be changed with {transferOwnership}.
583  *
584  * This module is used through inheritance. It will make available the modifier
585  * `onlyOwner`, which can be applied to your functions to restrict their use to
586  * the owner.
587  */
588 contract Ownable is Context {
589     address private _owner;
590 
591     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
592 
593     /**
594      * Initializes the contract setting the deployer as the initial owner.
595      */
596     constructor () internal {
597         address msgSender = _msgSender();
598         _owner = msgSender;
599         emit GovernanceTransferred(address(0), msgSender);
600     }
601 
602     /**
603      * Returns the address of the current owner.
604      */
605     function governance() public view returns (address) {
606         return _owner;
607     }
608 
609     /**
610      * Throws if called by any account other than the owner.
611      */
612     modifier onlyGovernance() {
613         require(_owner == _msgSender(), "Ownable: caller is not the owner");
614         _;
615     }
616 
617     /**
618      * Transfers ownership of the contract to a new account (`newOwner`).
619      * Can only be called by the current owner.
620      */
621     function _transferGovernance(address newOwner) internal virtual onlyGovernance {
622         require(newOwner != address(0), "Ownable: new owner is the zero address");
623         emit GovernanceTransferred(_owner, newOwner);
624         _owner = newOwner;
625     }
626 }
627 
628 // File: contracts/StabinolToken.sol
629 
630 pragma solidity =0.6.6;
631 
632 // Stabilize Token with Governance.
633 contract StabinolToken is ERC20("Stabinol Token", "STOL"), Ownable {
634     using SafeMath for uint256;
635 
636     // Variables
637     uint256 constant DIVISION_FACTOR = 100000;
638     uint256 constant TAX_EFFECTIVE = 500000e18; // The threshold at which the tax kicks in
639     uint256 private effectiveMaxSupply = 1000000e18; // The default max supply of tokens
640     uint256 public taxRate = 0; // Governance can update the tax rate as it gets closer to the max supply
641     
642     mapping (address => bool) public taxExemptAccounts; // Addresses that will not have a sender tax
643     
644     constructor() public {
645         // We will mint 350,000 tokens to the deployer to use for the merkle airdrop, team and liquidity
646         _mint(_msgSender(), 350000e18);
647     }
648 
649     modifier onlyClaimer() {
650         require(claimerAddress == _msgSender(), "Ownable: caller is not the claimer");
651         _;
652     }
653 
654     function getMaxSupply() external view returns (uint256) {
655         return effectiveMaxSupply;
656     }
657     
658     /// @notice Creates `_amount` token to `_to`. Must only be called by the claimer.
659     function mint(address _to, uint256 _amount) external onlyClaimer returns (bool) {
660         _mint(_to, _amount);
661         require(totalSupply() <= effectiveMaxSupply, "Cannot mint any more tokens"); // After max supply is reached, claimer cannot claim anymore
662         return true;
663     }
664 
665     // This function will tax each non-exempt address the transfer fee
666     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override returns (uint256) {
667         super._beforeTokenTransfer(from, to, amount); // Call parent hook
668         if(taxExemptAccounts[from] == true){ return amount; } // No fee for certain accounts
669         if(taxRate > 0 && totalSupply() > TAX_EFFECTIVE){
670             // Tax is taken from sender balance. If sender balance not enough to cover transfer, tax taken from transferred amount
671             // For contracts to calculate ideal fee when sending this token, use this equation: taxRate / (1 + taxRate) = withdrawFeeRate
672             uint256 taxAmount = amount.mul(taxRate).div(DIVISION_FACTOR);
673             if(taxAmount.add(amount) > balanceOf(from)){
674                 uint256 overage = taxAmount.add(amount).sub(balanceOf(from)); // The overage for the fee
675                 amount = amount.sub(overage);
676             }
677             _tax(from,taxAmount);
678         }
679         return amount;
680     }
681     
682     // Now add some governance functions behind 24 hour timelock
683     
684     // Timelock variables
685     // Timelock doesn't activate until claimer is set to a non-zero account
686     
687     uint256 private _timelockStart; // The start of the timelock to change governance variables
688     uint256 private _timelockType; // The function that needs to be changed
689     uint256 constant TIMELOCK_DURATION = 86400; // Timelock is 24 hours
690     
691     // Reusable timelock variables
692     uint256 private _timelock_data;
693     address private _timelock_address;
694     
695     modifier timelockConditionsMet(uint256 _type) {
696         require(_timelockType == _type, "Timelock not acquired for this function");
697         _timelockType = 0; // Reset the type once the timelock is used
698         if(claimerAddress != address(0)){
699             require(now >= _timelockStart + TIMELOCK_DURATION, "Timelock time not met");
700         }
701         _;
702     }
703     
704     // Change the governance
705     // --------------------
706     function startChangeGovernance(address _address) external onlyGovernance {
707         _timelockStart = now;
708         _timelockType = 1;
709         _timelock_address = _address;       
710     }
711     
712     function finishChangeGovernance() external onlyGovernance timelockConditionsMet(1) {
713         _transferGovernance(_timelock_address);
714     }
715     // --------------------
716     
717     // Used to change tax rate
718     // --------------------
719     function startChangeTaxRate(uint256 _percent) external onlyGovernance {
720         _timelockStart = now;
721         _timelockType = 2;
722         _timelock_data = _percent;
723     }
724     
725     function finishChangeTaxRate() external onlyGovernance timelockConditionsMet(2) {
726         taxRate = _timelock_data;
727     }
728     // --------------------
729     
730     // Change the claimer address
731     // --------------------
732     function startChangeClaimer(address _address) external onlyGovernance {
733         _timelockStart = now;
734         _timelockType = 3;
735         _timelock_address = _address;       
736     }
737     
738     function finishChangeClaimer() external onlyGovernance timelockConditionsMet(3) {
739         taxExemptAccounts[_timelock_address] = true;
740         _setClaimer(_timelock_address);
741     }
742     // --------------------
743     
744     // Toggle whether an account is tax exempt or not
745     // --------------------
746     function startToggleTaxExempt(address _address) external onlyGovernance {
747         _timelockStart = now;
748         _timelockType = 4;
749         _timelock_address = _address;       
750     }
751     
752     function finishToggleTaxExempt() external onlyGovernance timelockConditionsMet(4) {
753         if(taxExemptAccounts[_timelock_address] == true){
754             taxExemptAccounts[_timelock_address] = false;
755         }else{
756             taxExemptAccounts[_timelock_address] = true;
757         }
758     }
759     // --------------------
760     
761     // Used to change the effective max supply
762     // --------------------
763     function startChangeEffectiveSupply(uint256 _supply) external onlyGovernance {
764         _timelockStart = now;
765         _timelockType = 5;
766         _timelock_data = _supply;
767     }
768     
769     function finishChangeEffectiveSupply() external onlyGovernance timelockConditionsMet(5) {
770         effectiveMaxSupply = _timelock_data;
771     }
772     // --------------------
773 }