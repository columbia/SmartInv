1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a, "SafeMath: subtraction overflow");
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, reverting on
38      * overflow.
39      *
40      * Counterpart to Solidity's `*` operator.
41      *
42      * Requirements:
43      * - Multiplication cannot overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the integer division of two unsigned integers. Reverts on
61      * division by zero. The result is rounded towards zero.
62      *
63      * Counterpart to Solidity's `/` operator. Note: this function uses a
64      * `revert` opcode (which leaves remaining gas untouched) while Solidity
65      * uses an invalid opcode to revert (consuming all remaining gas).
66      *
67      * Requirements:
68      * - The divisor cannot be zero.
69      */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0, "SafeMath: division by zero");
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
81      * Reverts when dividing by zero.
82      *
83      * Counterpart to Solidity's `%` operator. This function uses a `revert`
84      * opcode (which leaves remaining gas untouched) while Solidity uses an
85      * invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      * - The divisor cannot be zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0, "SafeMath: modulo by zero");
92         return a % b;
93     }
94 }
95 
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a `Transfer` event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through `transferFrom`. This is
119      * zero by default.
120      *
121      * This value changes when `approve` or `transferFrom` are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * > Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an `Approval` event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a `Transfer` event.
149      */
150     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to `approve`. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 /**
168  * @dev Implementation of the `IERC20` interface.
169  *
170  * This implementation is agnostic to the way tokens are created. This means
171  * that a supply mechanism has to be added in a derived contract using `_mint`.
172  * For a generic mechanism see `ERC20Mintable`.
173  *
174  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
175  * This allows applications to reconstruct the allowance for all accounts just
176  * by listening to said events. Other implementations of the EIP may not emit
177  * these events, as it isn't required by the specification.
178  *
179  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
180  * functions have been added to mitigate the well-known issues around setting
181  * allowances. See `IERC20.approve`.
182  */
183 contract ERC20Basic is IERC20 {
184     using SafeMath for uint256;
185 
186     mapping (address => uint256) private _balances;
187 
188     mapping (address => mapping (address => uint256)) private _allowances;
189 
190     uint256 private _totalSupply;
191 
192     /**
193      * @dev See `IERC20.totalSupply`.
194      */
195     function totalSupply() public view returns (uint256) {
196         return _totalSupply;
197     }
198 
199     /**
200      * @dev See `IERC20.balanceOf`.
201      */
202     function balanceOf(address account) public view returns (uint256) {
203         return _balances[account];
204     }
205 
206     /**
207      * @dev See `IERC20.transfer`.
208      *
209      * Requirements:
210      *
211      * - `recipient` cannot be the zero address.
212      * - the caller must have a balance of at least `amount`.
213      */
214     function transfer(address recipient, uint256 amount) public returns (bool) {
215         _transfer(msg.sender, recipient, amount);
216         return true;
217     }
218 
219     /**
220      * @dev See `IERC20.allowance`.
221      */
222     function allowance(address owner, address spender) public view returns (uint256) {
223         return _allowances[owner][spender];
224     }
225 
226     /**
227      * @dev See `IERC20.approve`.
228      *
229      * Requirements:
230      *
231      * - `spender` cannot be the zero address.
232      */
233     function approve(address spender, uint256 value) public returns (bool) {
234         _approve(msg.sender, spender, value);
235         return true;
236     }
237 
238     /**
239      * @dev See `IERC20.transferFrom`.
240      *
241      * Emits an `Approval` event indicating the updated allowance. This is not
242      * required by the EIP. See the note at the beginning of `ERC20`;
243      *
244      * Requirements:
245      * - `sender` and `recipient` cannot be the zero address.
246      * - `sender` must have a balance of at least `value`.
247      * - the caller must have allowance for `sender`'s tokens of at least
248      * `amount`.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
251         _transfer(sender, recipient, amount);
252         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
253         return true;
254     }
255 
256     /**
257      * @dev Atomically increases the allowance granted to `spender` by the caller.
258      *
259      * This is an alternative to `approve` that can be used as a mitigation for
260      * problems described in `IERC20.approve`.
261      *
262      * Emits an `Approval` event indicating the updated allowance.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
269         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
270         return true;
271     }
272 
273     /**
274      * @dev Atomically decreases the allowance granted to `spender` by the caller.
275      *
276      * This is an alternative to `approve` that can be used as a mitigation for
277      * problems described in `IERC20.approve`.
278      *
279      * Emits an `Approval` event indicating the updated allowance.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      * - `spender` must have allowance for the caller of at least
285      * `subtractedValue`.
286      */
287     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
288         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
289         return true;
290     }
291 
292     /**
293      * @dev Moves tokens `amount` from `sender` to `recipient`.
294      *
295      * This is internal function is equivalent to `transfer`, and can be used to
296      * e.g. implement automatic token fees, slashing mechanisms, etc.
297      *
298      * Emits a `Transfer` event.
299      *
300      * Requirements:
301      *
302      * - `sender` cannot be the zero address.
303      * - `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `amount`.
305      */
306     function _transfer(address sender, address recipient, uint256 amount) internal {
307         require(sender != address(0), "ERC20: transfer from the zero address");
308         require(recipient != address(0), "ERC20: transfer to the zero address");
309 
310         _balances[sender] = _balances[sender].sub(amount);
311         _balances[recipient] = _balances[recipient].add(amount);
312         emit Transfer(sender, recipient, amount);
313     }
314 
315     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
316      * the total supply.
317      *
318      * Emits a `Transfer` event with `from` set to the zero address.
319      *
320      * Requirements
321      *
322      * - `to` cannot be the zero address.
323      */
324     function _mint(address account, uint256 amount) internal {
325         require(account != address(0), "ERC20: mint to the zero address");
326 
327         _totalSupply = _totalSupply.add(amount);
328         _balances[account] = _balances[account].add(amount);
329         emit Transfer(address(0), account, amount);
330     }
331 
332      /**
333      * @dev Destoys `amount` tokens from `account`, reducing the
334      * total supply.
335      *
336      * Emits a `Transfer` event with `to` set to the zero address.
337      *
338      * Requirements
339      *
340      * - `account` cannot be the zero address.
341      * - `account` must have at least `amount` tokens.
342      */
343     function _burn(address account, uint256 value) internal {
344         require(account != address(0), "ERC20: burn from the zero address");
345 
346         _totalSupply = _totalSupply.sub(value);
347         _balances[account] = _balances[account].sub(value);
348         emit Transfer(account, address(0), value);
349     }
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
353      *
354      * This is internal function is equivalent to `approve`, and can be used to
355      * e.g. set automatic allowances for certain subsystems, etc.
356      *
357      * Emits an `Approval` event.
358      *
359      * Requirements:
360      *
361      * - `owner` cannot be the zero address.
362      * - `spender` cannot be the zero address.
363      */
364     function _approve(address owner, address spender, uint256 value) internal {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367 
368         _allowances[owner][spender] = value;
369         emit Approval(owner, spender, value);
370     }
371 
372     /**
373      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
374      * from the caller's allowance.
375      *
376      * See `_burn` and `_approve`.
377      */
378     function _burnFrom(address account, uint256 amount) internal {
379         _burn(account, amount);
380         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
381     }
382 }
383 
384 contract Ownable {
385     address private _owner;
386 
387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
388 
389     /**
390      * @dev Initializes the contract setting the deployer as the initial owner.
391      */
392     constructor () internal {
393         _owner = msg.sender;
394         emit OwnershipTransferred(address(0), _owner);
395     }
396 
397     /**
398      * @dev Returns the address of the current owner.
399      */
400     function owner() public view returns (address) {
401         return _owner;
402     }
403 
404     /**
405      * @dev Throws if called by any account other than the owner.
406      */
407     modifier onlyOwner() {
408         require(isOwner(), "Ownable: caller is not the owner");
409         _;
410     }
411 
412     /**
413      * @dev Returns true if the caller is the current owner.
414      */
415     function isOwner() public view returns (bool) {
416         return msg.sender == _owner;
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * > Note: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public onlyOwner {
427         emit OwnershipTransferred(_owner, address(0));
428         _owner = address(0);
429     }
430 
431     /**
432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
433      * Can only be called by the current owner.
434      */
435     function transferOwnership(address newOwner) public onlyOwner {
436         _transferOwnership(newOwner);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      */
442     function _transferOwnership(address newOwner) internal {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447 }
448 
449 library Address {
450     /**
451      * @dev Returns true if `account` is a contract.
452      *
453      * This test is non-exhaustive, and there may be false-negatives: during the
454      * execution of a contract's constructor, its address will be reported as
455      * not containing a contract.
456      *
457      * > It is unsafe to assume that an address for which this function returns
458      * false is an externally-owned account (EOA) and not a contract.
459      */
460     function isContract(address account) internal view returns (bool) {
461         // This method relies in extcodesize, which returns 0 for contracts in
462         // construction, since the code is only stored at the end of the
463         // constructor execution.
464 
465         uint256 size;
466         // solhint-disable-next-line no-inline-assembly
467         assembly { size := extcodesize(account) }
468         return size > 0;
469     }
470 
471     /**
472      * @dev Converts an `address` into `address payable`. Note that this is
473      * simply a type cast: the actual underlying value is not changed.
474      */
475     function toPayable(address account) internal pure returns (address payable) {
476         return address(uint160(account));
477     }
478 }
479 
480 /**
481  * @title SafeERC20
482  * @dev Wrappers around ERC20 operations that throw on failure (when the token
483  * contract returns false). Tokens that return no value (and instead revert or
484  * throw on failure) are also supported, non-reverting calls are assumed to be
485  * successful.
486  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
487  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
488  */
489 library SafeERC20 {
490     using SafeMath for uint256;
491     using Address for address;
492 
493     function safeTransfer(IERC20 token, address to, uint256 value) internal {
494         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
495     }
496 
497     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
498         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
499     }
500 
501     function safeApprove(IERC20 token, address spender, uint256 value) internal {
502         require((value == 0) || (token.allowance(address(this), spender) == 0),
503             "SafeERC20: approve from non-zero to non-zero allowance"
504         );
505         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
506     }
507 
508     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
509         uint256 newAllowance = token.allowance(address(this), spender).add(value);
510         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
511     }
512 
513     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
514         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
515         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
516     }
517 
518     /**
519      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
520      * on the return value: the return value is optional (but if data is returned, it must not be false).
521      * @param token The token targeted by the call.
522      * @param data The call data (encoded using abi.encode or one of its variants).
523      */
524     function callOptionalReturn(IERC20 token, bytes memory data) private {
525         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
526         // we're implementing it ourselves.
527 
528         // A Solidity high level call has three parts:
529         //  1. The target address is checked to verify it contains contract code
530         //  2. The call itself is made, and success asserted
531         //  3. The return value is decoded, which in turn checks the size of the returned data.
532         // solhint-disable-next-line max-line-length
533         require(address(token).isContract(), "SafeERC20: call to non-contract");
534 
535         // solhint-disable-next-line avoid-low-level-calls
536         (bool success, bytes memory returndata) = address(token).call(data);
537         require(success, "SafeERC20: low-level call failed");
538 
539         if (returndata.length > 0) { // Return data is optional
540             // solhint-disable-next-line max-line-length
541             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
542         }
543     }
544 }
545 
546 /**
547  * @title TokenVesting
548  * Initilize the vesting contract with token address, amount and periods
549  * add beneficiary by calling addBeneficiary funciton with specific amounts
550  * release token for available amount
551  */
552 contract TokenVesting is Ownable {
553   using SafeMath for uint256;
554   using SafeERC20 for ERC20Basic;
555 
556   event Released(address beneficiary, uint256 amount);
557 
558   ERC20Basic public token;
559   uint256 public cliff;
560   uint256 public start;
561   uint256 public duration;
562 
563   mapping (address => uint256) public shares;
564 
565   uint256 released = 0;
566 
567   address[] public beneficiaries;
568 
569   modifier onlyBeneficiaries {
570     require( isOwner() || shares[msg.sender] > 0, "You cannot release tokens!");
571     _;
572   }
573   
574   constructor(
575     ERC20Basic _token,
576     uint256 _start,
577     uint256 _cliff,
578     uint256 _duration
579   ) public
580   {
581     require(_cliff <= _duration, "Cliff has to be lower or equal to duration");
582     token = _token;
583     duration = _duration;
584     cliff = _start.add(_cliff);
585     start = _start;
586   }
587 
588   function addBeneficiary(address _beneficiary, uint256 _sharesAmount) onlyOwner public {
589     require(_beneficiary != address(0), "The beneficiary's address cannot be 0");
590     require(_sharesAmount > 0, "Shares amount has to be greater than 0");
591 
592     releaseAllTokens();
593 
594     if (shares[_beneficiary] == 0) {
595       beneficiaries.push(_beneficiary);
596     }
597 
598     shares[_beneficiary] = shares[_beneficiary].add(_sharesAmount);
599   }
600 
601   function releaseAllTokens() onlyBeneficiaries public {
602     uint256 unreleased = releasableAmount();
603 
604     if (unreleased > 0) {
605       uint beneficiariesCount = beneficiaries.length;
606 
607       released = released.add(unreleased);
608 
609       for (uint i = 0; i < beneficiariesCount; i++) {
610         release(beneficiaries[i], calculateShares(unreleased, beneficiaries[i]));
611       }
612     }
613   }
614 
615   function releasableAmount() public view returns (uint256) {
616     return vestedAmount().sub(released);
617   }
618 
619   function calculateShares(uint256 _amount, address _beneficiary) public view returns (uint256) {
620     return _amount.mul(shares[_beneficiary]).div(totalShares());
621   }
622 
623   function totalShares() public view returns (uint256) {
624     uint sum = 0;
625     uint beneficiariesCount = beneficiaries.length;
626 
627     for (uint i = 0; i < beneficiariesCount; i++) {
628       sum = sum.add(shares[beneficiaries[i]]);
629     }
630 
631     return sum;
632   }
633 
634   function vestedAmount() public view returns (uint256) {
635     uint256 currentBalance = token.balanceOf(msg.sender);
636     uint256 totalBalance = currentBalance.add(released);
637 
638     // solium-disable security/no-block-members
639     if (block.timestamp < cliff) {
640       return 0;
641     } else if (block.timestamp >= start.add(duration)) {
642       return totalBalance;
643     } else {
644       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
645     }
646     // solium-enable security/no-block-members
647   }
648 
649   function release(address _beneficiary, uint256 _amount) private {
650     token.safeTransfer(_beneficiary, _amount);
651     emit Released(_beneficiary, _amount);
652   }
653 }
654 
655 contract Token {
656     uint256 public totalSupply;
657 
658     function balanceOf(address _owner) public view returns (uint256 balance);
659 
660     function transfer(address _to, uint256 _value) public returns (bool success);
661 
662     function transferFrom(address _from, address _to, uint256 _value)public  returns  (bool success);
663 
664     function approve(address _spender, uint256 _value) public returns (bool success);
665 
666     function allowance(address _owner, address _spender) public view returns  (uint256 remaining);
667 
668     event Transfer(address indexed _from, address indexed _to, uint256 _value);
669 
670     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
671 }
672 
673 contract StandardToken is Token {
674     function transfer(address _to, uint256 _value) public returns (bool success) {
675         require(balances[msg.sender] >= _value);
676         balances[msg.sender] -= _value;
677         balances[_to] += _value; 
678         emit Transfer(msg.sender, _to, _value); 
679         return true;
680     }
681     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
682         require(balances[_from] >= _value && allowed[_from][msg.sender] >=  _value);
683         balances[_to] += _value; 
684         balances[_from] -= _value;  
685         allowed[_from][msg.sender] -= _value; 
686         emit Transfer(_from, _to, _value); 
687         return true;
688     }
689    
690     function balanceOf(address _owner) public view returns (uint256 balance) {
691         return balances[_owner];
692     }
693     
694     function approve(address _spender, uint256 _value) public returns (bool success)   
695     {
696         allowed[msg.sender][_spender] = _value;
697         emit Approval(msg.sender, _spender, _value);
698         return true;
699     }
700     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
701       return allowed[_owner][_spender];
702     }
703 
704     mapping (address => uint256) balances;
705     mapping (address => mapping (address => uint256)) allowed;
706 }
707 
708 contract SOXToken is StandardToken {
709     string public name;                   
710     uint8 public decimals;               
711     string public symbol;                 
712     string public version = 'v0.1';       
713 
714     constructor (uint256  _initialAmount, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) public {
715         balances[msg.sender] = _initialAmount; 
716         totalSupply = _initialAmount;        
717         name = _tokenName;                
718         decimals = _decimalUnits;          
719         symbol = _tokenSymbol;            
720     }
721     
722     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
723         allowed[msg.sender][_spender] = _value;
724         emit Approval(msg.sender, _spender, _value);
725         return true;
726     }
727 }