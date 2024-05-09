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
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
160  * the optional functions; to access them see {ERC20Detailed}.
161  */
162 interface IERC20 {
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `recipient`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address recipient, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `sender` to `recipient` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Emitted when `value` tokens are moved from one account (`from`) to
220      * another (`to`).
221      *
222      * Note that `value` may be zero.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     /**
227      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
228      * a call to {approve}. `value` is the new allowance.
229      */
230     event Approval(address indexed owner, address indexed spender, uint256 value);
231 }
232 
233 contract ERC20 is IERC20 {
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     string private _name;
243     string private _symbol;
244     uint8 private _decimals;
245 
246     constructor (string memory name, string memory symbol) public {
247         _name = name;
248         _symbol = symbol;
249         _decimals = 18;
250     }
251 
252     /**
253      * @dev Returns the name of the token.
254      */
255     function name() public view returns (string memory) {
256         return _name;
257     }
258 
259     /**
260      * @dev Returns the symbol of the token, usually a shorter version of the
261      * name.
262      */
263     function symbol() public view returns (string memory) {
264         return _symbol;
265     }
266 
267     /**
268      * @dev Returns the number of decimals used to get its user representation.
269      * For example, if `decimals` equals `2`, a balance of `505` tokens should
270      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
271      *
272      * Tokens usually opt for a value of 18, imitating the relationship between
273      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
274      * called.
275      *
276      * NOTE: This information is only used for _display_ purposes: it in
277      * no way affects any of the arithmetic of the contract, including
278      * {IERC20-balanceOf} and {IERC20-transfer}.
279      */
280 
281     function decimals() public view returns (uint8) {
282         return _decimals;
283     }
284     
285     /**
286      * @dev See {IERC20-totalSupply}.
287      */
288     function totalSupply() public view returns (uint256) {
289         return _totalSupply;
290     }
291 
292     /**
293      * @dev See {IERC20-balanceOf}.
294      */
295     function balanceOf(address account) public view returns (uint256) {
296         return _balances[account];
297     }
298 
299     /**
300      * @dev See {IERC20-transfer}.
301      *
302      * Requirements:
303      *
304      * - `recipient` cannot be the zero address.
305      * - the caller must have a balance of at least `amount`.
306      */
307     function transfer(address recipient, uint256 amount) public returns (bool) {
308         _transfer(msg.sender, recipient, amount);
309         return true;
310     }
311 
312     /**
313      * @dev See {IERC20-allowance}.
314      */
315     function allowance(address owner, address spender) public view returns (uint256) {
316         return _allowances[owner][spender];
317     }
318 
319     /**
320      * @dev See {IERC20-approve}.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function approve(address spender, uint256 amount) public returns (bool) {
327         _approve(msg.sender, spender, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-transferFrom}.
333      *
334      * Emits an {Approval} event indicating the updated allowance. This is not
335      * required by the EIP. See the note at the beginning of {ERC20};
336      *
337      * Requirements:
338      * - `sender` and `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      * - the caller must have allowance for `sender`'s tokens of at least
341      * `amount`.
342      */
343     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
344         _transfer(sender, recipient, amount);
345         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
346         return true;
347     }
348 
349     /**
350      * @dev Atomically increases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
362         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
363         return true;
364     }
365 
366     /**
367      * @dev Atomically decreases the allowance granted to `spender` by the caller.
368      *
369      * This is an alternative to {approve} that can be used as a mitigation for
370      * problems described in {IERC20-approve}.
371      *
372      * Emits an {Approval} event indicating the updated allowance.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      * - `spender` must have allowance for the caller of at least
378      * `subtractedValue`.
379      */
380     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
381         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
382         return true;
383     }
384 
385     /**
386      * @dev Moves tokens `amount` from `sender` to `recipient`.
387      *
388      * This is internal function is equivalent to {transfer}, and can be used to
389      * e.g. implement automatic token fees, slashing mechanisms, etc.
390      *
391      * Emits a {Transfer} event.
392      *
393      * Requirements:
394      *
395      * - `sender` cannot be the zero address.
396      * - `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      */
399     function _transfer(address sender, address recipient, uint256 amount) internal {
400         require(sender != address(0), "ERC20: transfer from the zero address");
401         require(recipient != address(0), "ERC20: transfer to the zero address");
402 
403         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
404         _balances[recipient] = _balances[recipient].add(amount);
405         emit Transfer(sender, recipient, amount);
406     }
407 
408     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
409      * the total supply.
410      *
411      * Emits a {Transfer} event with `from` set to the zero address.
412      *
413      * Requirements
414      *
415      * - `to` cannot be the zero address.
416      */
417     function _mint(address account, uint256 amount) internal {
418         require(account != address(0), "ERC20: mint to the zero address");
419 
420         _totalSupply = _totalSupply.add(amount);
421         _balances[account] = _balances[account].add(amount);
422         emit Transfer(address(0), account, amount);
423     }
424 
425     /**
426      * @dev Destroys `amount` tokens from `account`, reducing the
427      * total supply.
428      *
429      * Emits a {Transfer} event with `to` set to the zero address.
430      *
431      * Requirements
432      *
433      * - `account` cannot be the zero address.
434      * - `account` must have at least `amount` tokens.
435      */
436     function _burn(address account, uint256 amount) internal {
437         require(account != address(0), "ERC20: burn from the zero address");
438 
439         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
440         _totalSupply = _totalSupply.sub(amount);
441         emit Transfer(account, address(0), amount);
442     }
443 
444     /**
445      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
446      *
447      * This is internal function is equivalent to `approve`, and can be used to
448      * e.g. set automatic allowances for certain subsystems, etc.
449      *
450      * Emits an {Approval} event.
451      *
452      * Requirements:
453      *
454      * - `owner` cannot be the zero address.
455      * - `spender` cannot be the zero address.
456      */
457     function _approve(address owner, address spender, uint256 amount) internal {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
467      * from the caller's allowance.
468      *
469      * See {_burn} and {_approve}.
470      */
471     function _burnFrom(address account, uint256 amount) internal {
472         _burn(account, amount);
473         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
474     }
475 }
476 
477 contract MultiOwnable {
478   address[] private _owner;
479 
480   event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
481 
482   constructor() internal {
483     _owner.push(msg.sender);
484     emit OwnershipTransferred(address(0), _owner[0]);
485   }
486 
487   function checkOwner() private view returns (bool) {
488     for (uint8 i = 0; i < _owner.length; i++) {
489       if (_owner[i] == msg.sender) {
490         return true;
491       }
492     }
493     return false;
494   }
495 
496   function checkNewOwner(address _address) private view returns (bool) {
497     for (uint8 i = 0; i < _owner.length; i++) {
498       if (_owner[i] == _address) {
499         return false;
500       }
501     }
502     return true;
503   }
504 
505   modifier isAnOwner() {
506     require(checkOwner(), "Ownable: caller is not the owner");
507     _;
508   }
509 
510   function renounceOwnership() public isAnOwner {
511     for (uint8 i = 0; i < _owner.length; i++) {
512       if (_owner[i] == msg.sender) {
513         _owner[i] = address(0);
514         emit OwnershipTransferred(_owner[i], msg.sender);
515       }
516     }
517   }
518 
519   function getOwners() public view returns (address[] memory) {
520     return _owner;
521   }
522 
523   function addOwnerShip(address newOwner) public isAnOwner {
524     _addOwnerShip(newOwner);
525   }
526 
527   function _addOwnerShip(address newOwner) internal {
528     require(newOwner != address(0), "Ownable: new owner is the zero address");
529     require(checkNewOwner(newOwner), "Owner already exists");
530     _owner.push(newOwner);
531     emit OwnershipTransferred(_owner[_owner.length - 1], newOwner);
532   }
533 }
534 
535 contract WarLordToken is MultiOwnable, ERC20{
536     constructor (string memory name, string memory symbol) public ERC20(name, symbol) MultiOwnable(){
537     
538 	}
539 	
540 	function warlordMint(address account, uint256 amount) external isAnOwner{
541         _mint(account, amount);
542     }
543 
544     function warlordBurn(address account, uint256 amount) external isAnOwner{
545         _burn(account, amount);
546     }
547 	
548 	function addOwner(address _newOwner) external isAnOwner {
549         addOwnerShip(_newOwner);
550     }
551 
552     function getOwner() external view isAnOwner{
553         getOwners();
554     }
555 
556     function renounceOwner() external isAnOwner {
557         renounceOwnership();
558     }
559 }
560 
561 
562 /**
563  * @dev Optional functions from the ERC20 standard.
564  */
565 contract ERC20Detailed is IERC20 {
566     string private _name;
567     string private _symbol;
568     uint8 private _decimals;
569 
570     /**
571      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
572      * these values are immutable: they can only be set once during
573      * construction.
574      */
575     constructor (string memory name, string memory symbol, uint8 decimals) public {
576         _name = name;
577         _symbol = symbol;
578         _decimals = decimals;
579     }
580 
581     /**
582      * @dev Returns the name of the token.
583      */
584     function name() public view returns (string memory) {
585         return _name;
586     }
587 
588     /**
589      * @dev Returns the symbol of the token, usually a shorter version of the
590      * name.
591      */
592     function symbol() public view returns (string memory) {
593         return _symbol;
594     }
595 
596     /**
597      * @dev Returns the number of decimals used to get its user representation.
598      * For example, if `decimals` equals `2`, a balance of `505` tokens should
599      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
600      *
601      * Tokens usually opt for a value of 18, imitating the relationship between
602      * Ether and Wei.
603      *
604      * NOTE: This information is only used for _display_ purposes: it in
605      * no way affects any of the arithmetic of the contract, including
606      * {IERC20-balanceOf} and {IERC20-transfer}.
607      */
608     function decimals() public view returns (uint8) {
609         return _decimals;
610     }
611 }
612 
613 /**
614  * @dev Collection of functions related to the address type,
615  */
616 library Address {
617     /**
618      * @dev Returns true if `account` is a contract.
619      *
620      * This test is non-exhaustive, and there may be false-negatives: during the
621      * execution of a contract's constructor, its address will be reported as
622      * not containing a contract.
623      *
624      * > It is unsafe to assume that an address for which this function returns
625      * false is an externally-owned account (EOA) and not a contract.
626      */
627     function isContract(address account) internal view returns (bool) {
628         // This method relies in extcodesize, which returns 0 for contracts in
629         // construction, since the code is only stored at the end of the
630         // constructor execution.
631 
632         uint256 size;
633         // solhint-disable-next-line no-inline-assembly
634         assembly { size := extcodesize(account) }
635         return size > 0;
636     }
637 }
638 
639 /**
640  * @title SafeERC20
641  * @dev Wrappers around ERC20 operations that throw on failure (when the token
642  * contract returns false). Tokens that return no value (and instead revert or
643  * throw on failure) are also supported, non-reverting calls are assumed to be
644  * successful.
645  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
646  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
647  */
648 
649 library SafeERC20 {
650     using SafeMath for uint256;
651     using Address for address;
652 
653     function safeTransfer(IERC20 token, address to, uint256 value) internal {
654         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
655     }
656 
657     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
658         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
659     }
660 
661     function safeApprove(IERC20 token, address spender, uint256 value) internal {
662         // safeApprove should only be called when setting an initial allowance,
663         // or when resetting it to zero. To increase and decrease it, use
664         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
665         // solhint-disable-next-line max-line-length
666         require((value == 0) || (token.allowance(address(this), spender) == 0),
667             "SafeERC20: approve from non-zero to non-zero allowance"
668         );
669         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
670     }
671 
672     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
673         uint256 newAllowance = token.allowance(address(this), spender).add(value);
674         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
675     }
676 
677     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
678         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
679         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
680     }
681 
682     /**
683      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
684      * on the return value: the return value is optional (but if data is returned, it must not be false).
685      * @param token The token targeted by the call.
686      * @param data The call data (encoded using abi.encode or one of its variants).
687      */
688     function callOptionalReturn(IERC20 token, bytes memory data) private {
689         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
690         // we're implementing it ourselves.
691 
692         // A Solidity high level call has three parts:
693         //  1. The target address is checked to verify it contains contract code
694         //  2. The call itself is made, and success asserted
695         //  3. The return value is decoded, which in turn checks the size of the returned data.
696         // solhint-disable-next-line max-line-length
697         require(address(token).isContract(), "SafeERC20: call to non-contract");
698 
699         // solhint-disable-next-line avoid-low-level-calls
700         (bool success, bytes memory returndata) = address(token).call(data);
701         require(success, "SafeERC20: low-level call failed");
702 
703         if (returndata.length > 0) { // Return data is optional
704             // solhint-disable-next-line max-line-length
705             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
706         }
707     }
708 }
709 
710 
711 /**
712  * @dev Contract module that helps prevent reentrant calls to a function.
713  *
714  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
715  * available, which can be applied to functions to make sure there are no nested
716  * (reentrant) calls to them.
717  *
718  * Note that because there is a single `nonReentrant` guard, functions marked as
719  * `nonReentrant` may not call one another. This can be worked around by making
720  * those functions `private`, and then adding `external` `nonReentrant` entry
721  * points to them.
722  *
723  * TIP: If you would like to learn more about reentrancy and alternative ways
724  * to protect against it, check out our blog post
725  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
726  *
727  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
728  * metering changes introduced in the Istanbul hardfork.
729  */
730 contract ReentrancyGuard {
731     bool private _notEntered;
732 
733     constructor () internal {
734         // Storing an initial non-zero value makes deployment a bit more
735         // expensive, but in exchange the refund on every call to nonReentrant
736         // will be lower in amount. Since refunds are capped to a percetange of
737         // the total transaction's gas, it is best to keep them low in cases
738         // like this one, to increase the likelihood of the full refund coming
739         // into effect.
740         _notEntered = true;
741     }
742 
743     /**
744      * @dev Prevents a contract from calling itself, directly or indirectly.
745      * Calling a `nonReentrant` function from another `nonReentrant`
746      * function is not supported. It is possible to prevent this from happening
747      * by making the `nonReentrant` function external, and make it call a
748      * `private` function that does the actual work.
749      */
750     modifier nonReentrant() {
751         // On the first call to nonReentrant, _notEntered will be true
752         require(_notEntered, "ReentrancyGuard: reentrant call");
753 
754         // Any calls to nonReentrant after this point will fail
755         _notEntered = false;
756 
757         _;
758 
759         // By storing the original value once again, a refund is triggered (see
760         // https://eips.ethereum.org/EIPS/eip-2200)
761         _notEntered = true;
762     }
763 }
764 
765 
766 /**
767  * @dev Contract module which provides a basic access control mechanism, where
768  * there is an account (an owner) that can be granted exclusive access to
769  * specific functions.
770  *
771  * This module is used through inheritance. It will make available the modifier
772  * `onlyOwner`, which can be applied to your functions to restrict their use to
773  * the owner.
774  */
775 contract Ownable {
776     address private _owner;
777 
778     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
779 
780     /**
781      * @dev Initializes the contract setting the deployer as the initial owner.
782      */
783     constructor () internal {
784         address msgSender = msg.sender;
785         _owner = msgSender;
786         emit OwnershipTransferred(address(0), msgSender);
787     }
788 
789     /**
790      * @dev Returns the address of the current owner.
791      */
792     function owner() public view returns (address) {
793         return _owner;
794     }
795 
796     /**
797      * @dev Throws if called by any account other than the owner.
798      */
799     modifier onlyOwner() {
800         require(isOwner(), "Ownable: caller is not the owner");
801         _;
802     }
803 
804     /**
805      * @dev Returns true if the caller is the current owner.
806      */
807     function isOwner() public view returns (bool) {
808         return msg.sender == _owner;
809     }
810 
811     /**
812      * @dev Leaves the contract without owner. It will not be possible to call
813      * `onlyOwner` functions anymore. Can only be called by the current owner.
814      *
815      * NOTE: Renouncing ownership will leave the contract without an owner,
816      * thereby removing any functionality that is only available to the owner.
817      */
818     function renounceOwnership() public onlyOwner {
819         emit OwnershipTransferred(_owner, address(0));
820         _owner = address(0);
821     }
822 
823     /**
824      * @dev Transfers ownership of the contract to a new account (`newOwner`).
825      * Can only be called by the current owner.
826      */
827     function transferOwnership(address newOwner) public onlyOwner {
828         _transferOwnership(newOwner);
829     }
830 
831     /**
832      * @dev Transfers ownership of the contract to a new account (`newOwner`).
833      */
834     function _transferOwnership(address newOwner) internal {
835         require(newOwner != address(0), "Ownable: new owner is the zero address");
836         emit OwnershipTransferred(_owner, newOwner);
837         _owner = newOwner;
838     }
839 }
840 
841 contract WarlordCamp is Ownable, ReentrancyGuard {
842 	using SafeMath for uint256;
843 	using SafeERC20 for WarLordToken;
844 	using SafeERC20 for IERC20;
845 
846 	uint256 private _epochCampkStart;
847 	uint8 private _warriorTOknight;
848 	uint8 private _knightTOlegend;
849 	
850 	uint256 private _legedWarLordfirstReward;
851 	uint256 private _legedWarLordotherReward;
852 	uint256 private _decimalConverter = 10**18;
853 
854 	struct  warlordToken{
855 		WarLordToken token;
856 		uint256 totalSupply;
857 		uint256 durationReward;
858 		mapping(address => uint256)  balances;
859 		mapping(address => uint256)  periodFinish;
860 		mapping(address => uint256)  countReward;
861 	}
862 
863 	warlordToken[4] private _warlordToken;
864 
865 	constructor(address _WarLordToken,address _warriorWarLordToken, address _knightWarLordToken, address _legendWarLordToken) public Ownable() {
866 		_warlordToken[0].token = WarLordToken(_WarLordToken);
867 		_warlordToken[0].durationReward = 60 * 60 * 24; // 1 Day Duration in second
868 		
869 		_warlordToken[1].token = WarLordToken(_warriorWarLordToken);
870 		_warlordToken[1].durationReward = 60 * 60 * 24 * 2; // 2 Days Duration in second
871 		
872 		_warlordToken[2].token = WarLordToken(_knightWarLordToken);
873 		_warlordToken[2].durationReward = 60 * 60 * 24 * 3; // 3 Days Duration in second
874 		
875 		_warlordToken[3].token = WarLordToken(_legendWarLordToken);
876 		_warlordToken[3].durationReward = 60 * 60 * 24 * 7; // 1 Week Duration in second
877 		
878 		_warriorTOknight = 5;
879 		_knightTOlegend = 25;
880 		
881 		_legedWarLordfirstReward = 20;
882 		_legedWarLordotherReward = 15;
883 		
884 		_epochCampkStart = 1601906400; // October 5, 2020 2:00:00 PM GMT
885 	}
886 	
887 	function warlordType(string memory name) internal pure returns (uint8) {
888 		if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("WLT"))) {
889 			return 0;
890 		}
891 		
892 		if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("wWLT"))) {
893 			return 1;
894 		}
895 		
896 		if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("kWLT"))) {
897 			return 2;
898 		}
899 		
900 		if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("lWLT"))) {
901 			return 3;
902 		} else {
903 			return 99;
904 		}
905 	}
906 	
907 	function totalSupply(string calldata name) external view returns (uint256) {
908 		uint8 i = warlordType(name);
909 		return _warlordToken[i].totalSupply;
910 	}
911 	
912 	function balanceOf(address account, string calldata name) external view returns (uint256) {
913 		uint8 i = warlordType(name);
914 		return _warlordToken[i].balances[account];
915 	}
916 	
917 	function durationRemaining(address account, string calldata name) external view returns (uint256) {
918 		uint8 i = warlordType(name);
919 
920 		uint256 timeRemaining = 0;
921 		uint256 durationReward = 0;
922 
923 		durationReward = _warlordToken[i].durationReward;
924 
925 		if(_warlordToken[i].balances[account] > 0){
926 			if((_warlordToken[i].periodFinish[account] - now) < durationReward){
927 				timeRemaining = _warlordToken[i].periodFinish[account] - now;
928 			}
929 		}
930 
931 		return timeRemaining;
932 	}
933 	
934 	function rewardCount(address account, string calldata name) external view returns (uint256) {
935 		uint8 i = warlordType(name);
936 		return _warlordToken[i].countReward[account];
937 	}
938 	
939 	function checkKingdomReward(address account) external view returns (uint256) {
940 		uint256 countReward = _warlordToken[3].countReward[account];
941 		uint256 timeperiodFinish = _warlordToken[3].periodFinish[account];
942 		uint256 timeFirstStaking = timeperiodFinish - _warlordToken[3].durationReward;
943 		uint256 stakingPeriod = now - timeFirstStaking;
944 		uint256 countStakingReward = stakingPeriod / _warlordToken[3].durationReward;
945 		uint256 value = 0;
946 
947 		for (uint256 i = countStakingReward; i != 0; i--) {
948 			if(countReward == 0){
949 				value = value.add(_legedWarLordfirstReward);
950 			} else {
951 				value = value.add(_legedWarLordotherReward);
952 			}
953 			countReward++;
954 		}
955 
956 		return value * _warlordToken[3].balances[account];
957 	}
958 	
959 	function army(uint256 amount, string calldata name) external nonReentrant {    
960 		require(now > _epochCampkStart, "The Camp is being set up!");
961 
962 		uint8 i = warlordType(name);
963 		require(i < 99, "Not a valid warlord name");
964 
965 		require(amount >= 1, "Cannot stake less than 1");
966 
967 		if(i == 0){
968 			uint256 modulo = amount % 1;
969 			require(modulo == 0, "If send a warlord token to Recruit Camp, has to be multiple of 1");
970 		} else {
971 			if(i == 1){
972 				uint256 modulo = amount % _warriorTOknight;
973 				require(modulo == 0, "If send a warrior warlord to Training Camp, has to be multiple of 5");
974 			} else {
975 				if(i == 2){
976 					uint256 modulo = amount % _knightTOlegend;
977 					require(modulo == 0, "If send a knight warlord to Dungeon, has to be multiple of 25");
978 				} else {
979 					if(i == 3){
980 						uint256 modulo = amount % 1;
981 						require(modulo == 0, "If send a legend warlord to Kingdom, has to be multiple of 1");
982 					}
983 				}
984 			}
985 		}
986 
987 		require(_warlordToken[i].balances[msg.sender] == 0 && (_warlordToken[i].periodFinish[msg.sender] == 0 || now > _warlordToken[i].periodFinish[msg.sender]), 
988 		"You must withdraw the previous army before send more!");
989 
990 		_warlordToken[i].token.safeTransferFrom(msg.sender, address(this), amount.mul(_decimalConverter));
991 		_warlordToken[i].totalSupply = _warlordToken[i].totalSupply.add(amount);
992 		_warlordToken[i].balances[msg.sender] = _warlordToken[i].balances[msg.sender].add(amount);
993 		_warlordToken[i].periodFinish[msg.sender] = now + _warlordToken[i].durationReward;
994 
995 		emit Staked(msg.sender, amount);
996 	}
997 	
998 	function getarmy(string memory name) public nonReentrant {
999 		uint8 i = warlordType(name);
1000 		require(i < 99, "Not a valid warlord name");
1001 
1002 		require(_warlordToken[i].balances[msg.sender] > 0, "Cannot get army 0");
1003 		require(now > _warlordToken[i].periodFinish[msg.sender], "Cannot get army until the action finished!");
1004 
1005 		uint256 tempAmount;
1006 		uint256 tempcountReward;
1007 
1008 		if (i == 3) {
1009 			tempAmount = setLegendWarLordRewardAmount();
1010 			tempcountReward = getLegendWarLordRewardCount();
1011 			_warlordToken[0].token.warlordMint(msg.sender, tempAmount.mul(_decimalConverter));
1012 			_warlordToken[i].periodFinish[msg.sender] = now + _warlordToken[3].durationReward;
1013 			_warlordToken[i].countReward[msg.sender] = tempcountReward;
1014 		} else {
1015 			_warlordToken[i].token.warlordBurn(address(this), _warlordToken[i].balances[msg.sender].mul(_decimalConverter));
1016 			if(i == 2){
1017 				tempAmount = _warlordToken[i].balances[msg.sender].div(_knightTOlegend);
1018 			} else{
1019 				if(i == 1){
1020 					tempAmount = _warlordToken[i].balances[msg.sender].div(_warriorTOknight);
1021 				} else {
1022 					tempAmount = _warlordToken[i].balances[msg.sender];
1023 				}
1024 			}
1025 
1026 			_warlordToken[i + 1].token.warlordMint(msg.sender, tempAmount.mul(_decimalConverter));
1027 
1028 			zeroHoldings(i);
1029 		}
1030 		emit RewardPaid(msg.sender, tempAmount);
1031 	}
1032 	
1033 	function withdraw(string memory name) public nonReentrant {
1034 		uint8 i = warlordType(name);
1035 
1036 		require(i < 99, "Not a valid warlord name");
1037 
1038 		require(_warlordToken[i].balances[msg.sender] > 0, "Cannot withdraw 0");
1039 		_warlordToken[i].token.safeTransfer(msg.sender, _warlordToken[i].balances[msg.sender].mul(_decimalConverter));
1040 
1041 		emit Withdrawn(msg.sender,_warlordToken[i].balances[msg.sender]);
1042 
1043 		zeroHoldings(i);
1044 	}
1045 	
1046 	function zeroHoldings(uint8 i) internal{
1047 		_warlordToken[i].totalSupply = _warlordToken[i].totalSupply - _warlordToken[i].balances[msg.sender];
1048 		_warlordToken[i].balances[msg.sender] = 0;
1049 		_warlordToken[i].periodFinish[msg.sender] = 0;
1050 	}
1051 
1052 	function setLegendWarLordRewardAmount() internal view returns (uint256) {
1053 		uint256 countReward = _warlordToken[3].countReward[msg.sender];
1054 		uint256 timeperiodFinish = _warlordToken[3].periodFinish[msg.sender];
1055 		uint256 timeFirstStaking = timeperiodFinish - _warlordToken[3].durationReward;
1056 		uint256 stakingPeriod = now - timeFirstStaking;
1057 		uint256 countStakingReward = stakingPeriod / _warlordToken[3].durationReward;
1058 		uint256 value = 0;
1059 
1060 		for (uint256 i = countStakingReward; i != 0; i--) {
1061 			if(countReward == 0){
1062 				value = value.add(_legedWarLordfirstReward);
1063 			} else {
1064 				value = value.add(_legedWarLordotherReward);
1065 			}
1066 			countReward++;
1067 		}
1068 
1069 		return value * _warlordToken[3].balances[msg.sender];
1070 	}
1071 
1072 	function getLegendWarLordRewardCount() internal view returns (uint256) {
1073 		uint256 countReward = _warlordToken[3].countReward[msg.sender];
1074 		uint256 timeperiodFinish = _warlordToken[3].periodFinish[msg.sender];
1075 		uint256 timeFirstStaking = timeperiodFinish - _warlordToken[3].durationReward;
1076 		uint256 stakingPeriod = now - timeFirstStaking;
1077 		uint256 countStakingReward = stakingPeriod / _warlordToken[3].durationReward;
1078 
1079 		for (uint256 i = countStakingReward; i != 0; i--) {
1080 			countReward++;
1081 		}
1082 
1083 		return countReward;
1084 	}
1085 	
1086 	function addTokenOwner(address _token, address _newOwner) external onlyOwner {
1087 		require(now > _epochCampkStart.add(14 days), "Time before Arena Opening");
1088 
1089 		WarLordToken tempToken = WarLordToken(_token);
1090 		tempToken.addOwner(_newOwner);
1091 	}
1092 
1093 	function renounceTokenOwner(address _token) external onlyOwner {
1094 		require(now > _epochCampkStart.add(14 days), "Time before Arena Opening");
1095 
1096 		WarLordToken tempToken = WarLordToken(_token);
1097 		tempToken.renounceOwner();
1098 	}
1099 
1100 	function changeOwner(address _newOwner) external onlyOwner {
1101 		transferOwnership(_newOwner);
1102 	}
1103 	
1104 	event Staked(address indexed user, uint256 amount);
1105 	event Withdrawn(address indexed user, uint256 amount);
1106 	event RewardPaid(address indexed user, uint256 reward);
1107 }