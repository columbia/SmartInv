1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * Game Credits ERC20 Token Contract
6  * https://www.gamecredits.org
7  * (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
8  */
9 
10 
11 
12 
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
16  * the optional functions; to access them see {ERC20Detailed}.
17  */
18 interface iERC20 {
19 
20   /**
21     * @dev Returns the amount of tokens in existence.
22     */
23   function totalSupply() external view returns (uint);
24 
25   /**
26     * @dev Returns the amount of tokens owned by `account`.
27     */
28   function balanceOf(address account) external view returns (uint);
29 
30   /**
31     * @dev Moves `amount` tokens from the caller's account to `recipient`.
32     *
33     * Returns a boolean value indicating whether the operation succeeded.
34     *
35     * Emits a {Transfer} event.
36     */
37   function transfer(address recipient, uint amount) external returns (bool);
38 
39   /**
40     * @dev Returns the remaining number of tokens that `spender` will be
41     * allowed to spend on behalf of `owner` through {transferFrom}. This is
42     * zero by default.
43     *
44     * This value changes when {approve} or {transferFrom} are called.
45     */
46   function allowance(address owner, address spender) external view returns (uint);
47 
48   /**
49     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50     *
51     * Returns a boolean value indicating whether the operation succeeded.
52     *
53     * IMPORTANT: Beware that changing an allowance with this method brings the risk
54     * that someone may use both the old and the new allowance by unfortunate
55     * transaction ordering. One possible solution to mitigate this race
56     * condition is to first reduce the spender's allowance to 0 and set the
57     * desired value afterwards:
58     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59     *
60     * Emits an {Approval} event.
61     */
62   function approve(address spender, uint amount) external returns (bool);
63 
64   /**
65     * @dev Moves `amount` tokens from `sender` to `recipient` using the
66     * allowance mechanism. `amount` is then deducted from the caller's
67     * allowance.
68     *
69     * Returns a boolean value indicating whether the operation succeeded.
70     *
71     * Emits a {Transfer} event.
72     */
73   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
74 
75   /**
76     * @dev Emitted when `value` tokens are moved from one account (`from`) to
77     * another (`to`).
78     *
79     * Note that `value` may be zero.
80     */
81   event Transfer(address indexed from, address indexed to, uint value);
82 
83   /**
84     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85     * a call to {approve}. `value` is the new allowance.
86     */
87   event Approval(address indexed owner, address indexed spender, uint value);
88 }
89 
90 
91 
92 // @title iERC20Contract
93 // @dev The interface for cross-contract calls to the ERC20 contract
94 // @author GAME Credits Platform (https://www.gamecredits.org)
95 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
96 contract iERC20Contract {
97   function isOfficialAccount(address account) external view returns(bool);
98 }
99 
100 
101 // @title ERC20Access
102 // @dev ERC20Access contract for controlling access to ERC20 contract functions
103 // @author GAME Credits Platform (https://www.gamecredits.org)
104 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
105 contract ERC20Access is iERC20, iERC20Contract {
106 
107   event OwnershipTransferred(address previousOwner, address newOwner);
108 
109   // The Owner can perform all admin tasks, including setting the recovery account.
110   address public owner;
111 
112   // The Recovery account can change the Owner account.
113   address public recoveryAddress;
114 
115 
116   // @dev The original `owner` of the contract is the contract creator.
117   // @dev Internal constructor to ensure this contract can't be deployed alone
118   constructor()
119     internal
120   {
121     owner = msg.sender;
122   }
123 
124   // @dev Access control modifier to limit access to the Owner account
125   modifier onlyOwner() {
126     require(msg.sender == owner, "sender must be owner");
127     _;
128   }
129 
130   // @dev Access control modifier to limit access to the Recovery account
131   modifier onlyRecovery() {
132     require(msg.sender == recoveryAddress, "sender must be recovery");
133     _;
134   }
135 
136   // @dev Access control modifier to limit access to the Owner or Recovery account
137   modifier ownerOrRecovery() {
138     require(msg.sender == owner || msg.sender == recoveryAddress, "sender must be owner or recovery");
139     _;
140   }
141 
142   // Used to check if an account is treated as official by this contract
143   // @param _account - the account to check
144   // @returns true if _account equals the owner or recoveryAccount, false otherwise
145   function isOfficialAccount(address _account)
146     external
147     view
148   returns(bool)
149   {
150     return _account == owner || _account == recoveryAddress;
151   }
152 
153   // @dev Assigns a new address to act as the Owner.
154   // @notice Can only be called by the recovery account
155   // @param _newOwner The address of the new Owner
156   function setOwner(address _newOwner)
157     external
158     onlyRecovery
159   {
160     require(_newOwner != address(0), "new owner must be a non-zero address");
161     require(_newOwner != recoveryAddress, "new owner can't be the recovery address");
162 
163     owner = _newOwner;
164     emit OwnershipTransferred(owner, _newOwner);
165   }
166 
167   // @dev Assigns a new address to act as the Recovery address.
168   // @notice Can only be called by the Owner account
169   // @param _newRecovery The address of the new Recovery account
170   function setRecovery(address _newRecovery)
171     external
172     onlyOwner
173   {
174     require(_newRecovery != address(0), "new owner must be a non-zero address");
175     require(_newRecovery != owner, "new recovery can't be the owner address");
176 
177     recoveryAddress = _newRecovery;
178   }
179 
180   // @dev allows recovery of ERC20 tokens accidentally sent to this address
181   // @param tokenAddress - The address of the erc20 token
182   // @param tokens - The number of tokens to transfer
183   function transferAnyERC20Token(address tokenAddress, uint tokens)
184     public
185     ownerOrRecovery
186   returns (bool success)
187   {
188     return iERC20(tokenAddress).transfer(owner, tokens);
189   }
190 }
191 
192 
193 
194 
195 /**
196  * @dev Wrappers over Solidity's arithmetic operations with added overflow
197  * checks.
198  *
199  * Arithmetic operations in Solidity wrap on overflow. This can easily result
200  * in bugs, because programmers usually assume that an overflow raises an
201  * error, which is the standard behavior in high level programming languages.
202  * `SafeMath` restores this intuition by reverting the transaction when an
203  * operation overflows.
204  *
205  * Using this library instead of the unchecked operations eliminates an entire
206  * class of bugs, so it's recommended to use it always.
207  */
208 library SafeMath {
209   /**
210     * @dev Returns the addition of two unsigned integers, reverting on
211     * overflow.
212     *
213     * Counterpart to Solidity's `+` operator.
214     *
215     * Requirements:
216     * - Addition cannot overflow.
217     */
218   function add(uint a, uint b) internal pure returns (uint) {
219     uint c = a + b;
220     require(c >= a, "SafeMath: addition overflow");
221 
222     return c;
223   }
224 
225   /**
226     * @dev Returns the subtraction of two unsigned integers, reverting on
227     * overflow (when the result is negative).
228     *
229     * Counterpart to Solidity's `-` operator.
230     *
231     * Requirements:
232     * - Subtraction cannot overflow.
233     */
234   function sub(uint a, uint b) internal pure returns (uint) {
235     return sub(a, b, "SafeMath: subtraction overflow");
236   }
237 
238   /**
239     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240     * overflow (when the result is negative).
241     *
242     * Counterpart to Solidity's `-` operator.
243     *
244     * Requirements:
245     * - Subtraction cannot overflow.
246     *
247     * _Available since v2.4.0._
248     */
249   function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
250     require(b <= a, errorMessage);
251     uint c = a - b;
252 
253     return c;
254   }
255 
256   /**
257     * @dev Returns the multiplication of two unsigned integers, reverting on
258     * overflow.
259     *
260     * Counterpart to Solidity's `*` operator.
261     *
262     * Requirements:
263     * - Multiplication cannot overflow.
264     */
265   function mul(uint a, uint b) internal pure returns (uint) {
266     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
267     // benefit is lost if 'b' is also tested.
268     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
269     if (a == 0) {
270       return 0;
271     }
272 
273     uint c = a * b;
274     require(c / a == b, "SafeMath: multiplication overflow");
275 
276     return c;
277   }
278 
279   /**
280     * @dev Returns the integer division of two unsigned integers. Reverts on
281     * division by zero. The result is rounded towards zero.
282     *
283     * Counterpart to Solidity's `/` operator. Note: this function uses a
284     * `revert` opcode (which leaves remaining gas untouched) while Solidity
285     * uses an invalid opcode to revert (consuming all remaining gas).
286     *
287     * Requirements:
288     * - The divisor cannot be zero.
289     */
290   function div(uint a, uint b) internal pure returns (uint) {
291     return div(a, b, "SafeMath: division by zero");
292   }
293 
294   /**
295     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
296     * division by zero. The result is rounded towards zero.
297     *
298     * Counterpart to Solidity's `/` operator. Note: this function uses a
299     * `revert` opcode (which leaves remaining gas untouched) while Solidity
300     * uses an invalid opcode to revert (consuming all remaining gas).
301     *
302     * Requirements:
303     * - The divisor cannot be zero.
304     *
305     * _Available since v2.4.0._
306     */
307   function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
308     // Solidity only automatically asserts when dividing by 0
309     require(b > 0, errorMessage);
310     uint c = a / b;
311     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312 
313     return c;
314   }
315 
316   /**
317     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318     * Reverts when dividing by zero.
319     *
320     * Counterpart to Solidity's `%` operator. This function uses a `revert`
321     * opcode (which leaves remaining gas untouched) while Solidity uses an
322     * invalid opcode to revert (consuming all remaining gas).
323     *
324     * Requirements:
325     * - The divisor cannot be zero.
326     */
327   function mod(uint a, uint b) internal pure returns (uint) {
328     return mod(a, b, "SafeMath: modulo by zero");
329   }
330 
331   /**
332     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333     * Reverts with custom message when dividing by zero.
334     *
335     * Counterpart to Solidity's `%` operator. This function uses a `revert`
336     * opcode (which leaves remaining gas untouched) while Solidity uses an
337     * invalid opcode to revert (consuming all remaining gas).
338     *
339     * Requirements:
340     * - The divisor cannot be zero.
341     *
342     * _Available since v2.4.0._
343     */
344   function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
345     require(b != 0, errorMessage);
346     return a % b;
347   }
348 }
349 
350 /**
351  * @dev Implementation of the {iERC20} interface.
352  *
353  * This implementation is agnostic to the way tokens are created. This means
354  * that a supply mechanism has to be added in a derived contract using {_mint}.
355  * For a generic mechanism see {ERC20Mintable}.
356  *
357  * TIP: For a detailed writeup see our guide
358  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
359  * to implement supply mechanisms].
360  *
361  * We have followed general OpenZeppelin guidelines: functions revert instead
362  * of returning `false` on failure. This behavior is nonetheless conventional
363  * and does not conflict with the expectations of ERC20 applications.
364  *
365  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
366  * This allows applications to reconstruct the allowance for all accounts just
367  * by listening to said events. Other implementations of the EIP may not emit
368  * these events, as it isn't required by the specification.
369  *
370  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
371  * functions have been added to mitigate the well-known issues around setting
372  * allowances. See {iERC20-approve}.
373  */
374 contract ERC20Base is ERC20Access {
375   using SafeMath for uint;
376 
377   mapping (address => uint) private _balances;
378 
379   mapping (address => mapping (address => uint)) private _allowances;
380 
381   uint private _totalSupply;
382 
383   /**
384    * @dev Internal constructor to ensure this contract can't be deployed alone
385    */
386   constructor() internal{ }
387 
388   /**
389    * @dev Returns the amount of tokens in existence.
390    */
391   function totalSupply()
392     public
393     view
394   returns (uint)
395   {
396     return _totalSupply;
397   }
398 
399   /**
400    * @dev Returns the amount of tokens owned by `account`.
401    */
402   function balanceOf(address account)
403     public
404     view
405   returns (uint)
406   {
407     return _balances[account];
408   }
409 
410   /**
411    * @dev Moves `amount` tokens from the caller's account to `recipient`.
412    *
413    * Returns a boolean value indicating whether the operation succeeded.
414    *
415    * Emits a {Transfer} event.
416    *
417    * Requirements:
418    *
419    * - `recipient` cannot be the zero address.
420    * - the caller must have a balance of at least `amount`.
421    */
422   function transfer(address recipient, uint amount)
423     public
424   returns (bool)
425   {
426     _transfer(msg.sender, recipient, amount);
427     return true;
428   }
429 
430   /**
431    * @dev Returns the remaining number of tokens that `spender` will be
432    * allowed to spend on behalf of `owner` through {transferFrom}. This is
433    * zero by default.
434    *
435    * This value changes when {approve} or {transferFrom} are called.
436    */
437   function allowance(address owner, address spender)
438     public
439     view
440   returns (uint)
441   {
442     return _allowances[owner][spender];
443   }
444 
445   /**
446    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
447    *
448    * Returns a boolean value indicating whether the operation succeeded.
449    *
450    * IMPORTANT: Beware that changing an allowance with this method brings the risk
451    * that someone may use both the old and the new allowance by unfortunate
452    * transaction ordering. One possible solution to mitigate this race
453    * condition is to first reduce the spender's allowance to 0 and set the
454    * desired value afterwards:
455    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
456    *
457    * Emits an {Approval} event.
458    *
459    * Requirements:
460    *
461    * - `spender` cannot be the zero address.
462    */
463   function approve(address spender, uint amount)
464     public
465   returns (bool)
466   {
467     _approve(msg.sender, spender, amount);
468     return true;
469   }
470 
471   /**
472    * @dev Moves `amount` tokens from `sender` to `recipient` using the
473    * allowance mechanism. `amount` is then deducted from the caller's
474    * allowance.
475    *
476    * Returns a boolean value indicating whether the operation succeeded.
477    *
478    * Emits a {Transfer} event.
479    *
480    * Emits an {Approval} event indicating the updated allowance. This is not
481    * required by the EIP. See the note at the beginning of {ERC20};
482    *
483    * Requirements:
484    * - `sender` and `recipient` cannot be the zero address.
485    * - `sender` must have a balance of at least `amount`.
486    * - the caller must have allowance for `sender`'s tokens of at least
487    * `amount`.
488    */
489   function transferFrom(address sender, address recipient, uint amount)
490     public
491   returns (bool)
492   {
493     _transfer(sender, recipient, amount);
494     _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
495     return true;
496   }
497 
498   /**
499     * @dev Atomically increases the allowance granted to `spender` by the caller.
500     *
501     * This is an alternative to {approve} that can be used as a mitigation for
502     * problems described in {iERC20-approve}.
503     *
504     * Emits an {Approval} event indicating the updated allowance.
505     *
506     * Requirements:
507     *
508     * - `spender` cannot be the zero address.
509     */
510   function increaseAllowance(address spender, uint addedValue)
511     public
512   returns (bool)
513   {
514     _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
515     return true;
516   }
517 
518   /**
519     * @dev Atomically decreases the allowance granted to `spender` by the caller.
520     *
521     * This is an alternative to {approve} that can be used as a mitigation for
522     * problems described in {iERC20-approve}.
523     *
524     * Emits an {Approval} event indicating the updated allowance.
525     *
526     * Requirements:
527     *
528     * - `spender` cannot be the zero address.
529     * - `spender` must have allowance for the caller of at least
530     * `subtractedValue`.
531     */
532   function decreaseAllowance(address spender, uint subtractedValue)
533     public
534   returns (bool)
535   {
536     _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
537     return true;
538   }
539 
540   /**
541     * @dev Moves tokens `amount` from `sender` to `recipient`.
542     *
543     * This is internal function is equivalent to {transfer}, and can be used to
544     * e.g. implement automatic token fees, slashing mechanisms, etc.
545     *
546     * Emits a {Transfer} event.
547     *
548     * Requirements:
549     *
550     * - `sender` cannot be the zero address.
551     * - `recipient` cannot be the zero address.
552     * - `sender` must have a balance of at least `amount`.
553     */
554   function _transfer(address sender, address recipient, uint amount)
555     internal
556   {
557     require(sender != address(0), "ERC20: transfer from the zero address");
558     require(recipient != address(0), "ERC20: transfer to the zero address");
559 
560     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
561     _balances[recipient] = _balances[recipient].add(amount);
562     emit Transfer(sender, recipient, amount);
563   }
564 
565   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
566     * the total supply.
567     *
568     * Emits a {Transfer} event with `from` set to the zero address.
569     *
570     * Requirements
571     *
572     * - `to` cannot be the zero address.
573     */
574   function _mint(address account, uint amount)
575     internal
576   {
577     require(account != address(0), "ERC20: mint to the zero address");
578 
579     _totalSupply = _totalSupply.add(amount);
580     _balances[account] = _balances[account].add(amount);
581     emit Transfer(address(0), account, amount);
582   }
583 
584   /**
585     * @dev Destroys `amount` tokens from `account`, reducing the
586     * total supply.
587     *
588     * Emits a {Transfer} event with `to` set to the zero address.
589     *
590     * Requirements
591     *
592     * - `account` cannot be the zero address.
593     * - `account` must have at least `amount` tokens.
594     */
595   function _burn(address account, uint amount)
596     internal
597   {
598     require(account != address(0), "ERC20: burn from the zero address");
599 
600     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
601     _totalSupply = _totalSupply.sub(amount);
602     emit Transfer(account, address(0), amount);
603   }
604 
605   /**
606     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
607     *
608     * This is internal function is equivalent to `approve`, and can be used to
609     * e.g. set automatic allowances for certain subsystems, etc.
610     *
611     * Emits an {Approval} event.
612     *
613     * Requirements:
614     *
615     * - `owner` cannot be the zero address.
616     * - `spender` cannot be the zero address.
617     */
618   function _approve(address owner, address spender, uint amount)
619     internal
620   {
621     require(owner != address(0), "ERC20: approve from the zero address");
622     require(spender != address(0), "ERC20: approve to the zero address");
623 
624     _allowances[owner][spender] = amount;
625     emit Approval(owner, spender, amount);
626   }
627 }
628 
629 
630 
631 // @title iSupportContract
632 // @dev The interface for cross-contract calls to Support contracts
633 // @author GAME Credits Platform (https://www.gamecredits.org)
634 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
635 contract iSupportContract {
636 
637   function isSupportContract() external pure returns(bool);
638 
639   function getGameAccountSupport(uint _game, address _account) external view returns(uint);
640   function updateSupport(uint _game, address _account, uint _supportAmount) external;
641   function fundRewardsPool(uint _amount, uint _startWeek, uint _numberOfWeeks) external;
642 
643   function receiveGameCredits(uint _game, address _account, uint _tokenId, uint _payment, bytes32 _data) external;
644   function receiveLoyaltyPayment(uint _game, address _account, uint _tokenId, uint _payment, bytes32 _data) external;
645   function contestEntry(uint _game, address _account, uint _tokenId, uint _contestId, uint _payment, bytes32 _data) external;
646 
647   event GameCreditsPayment(uint indexed _game, address indexed account, uint indexed _tokenId, uint _payment, bytes32 _data);
648   event LoyaltyPayment(uint indexed _game, address indexed account, uint indexed _tokenId, uint _payment, bytes32 _data);
649   event EnterContest(uint indexed _game, address indexed account, uint _tokenId, uint indexed _contestId, uint _payment, bytes32 _data);
650 }
651 
652 
653 // @title Game Credits ERC20 Token Contract
654 // @dev Contract for managing the GAME ERC20 token
655 // @author GAME Credits Platform (https://www.gamecredits.org)
656 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
657 contract GameCredits is ERC20Base {
658 
659   string public url = "https://www.gamecredits.org";
660   string public name = "GAME Credits";
661   string public symbol = "GAME";
662   uint8 public decimals = 18;
663 
664   // Listing of all the support contracts registered to this contract
665   // @notice Support contracts can be added, but cannot be removed. If an erroneous one
666   //   is added, it is up to users to not call it
667   mapping (address => iSupportContract) supportContracts;
668 
669   event SupportContractAdded(address indexed supportContract);
670 
671   // @notice The constructor mints 200 million GAME tokens to the contract creator
672   //   There is no other way to create GAME tokens, capping supply at 200 million
673   constructor()
674     public
675   {
676     _mint(msg.sender, 200 * 10 ** 24);
677   }
678 
679   // @notice The fallback function reverts
680   function ()
681     external
682     payable
683   {
684     revert("this contract is not payable");
685   }
686 
687   // @dev Used to set the support contract reference for this contract
688   // @param _supportContract - the address of the support contract
689   // @notice This is a one-shot function. Once the address is set, it's locked
690   function setSupportContract(address _supportContract)
691     external
692     ownerOrRecovery
693   {
694     iSupportContract supportContract = iSupportContract(_supportContract);
695     require(supportContract.isSupportContract(), "Must implement isSupportContract");
696     supportContracts[_supportContract] = supportContract;
697     emit SupportContractAdded(_supportContract);
698   }
699 
700   // @dev Lets any user add funds to the supporting pool spread over a period of weeks
701   // @param _rewardsContract - the contract that will be funded
702   // @param _amount - the total amount of GAME tokens to add to the support pool
703   // @param _startWeek - the first week in which tokens will be added to the support pool
704   // @param _numberOfWeeks - the number of weeks over which the _amount will be spread
705   // @notice - The _amount must be exactly divisible by the _numberOfWeeks
706   function fundRewardsContract(address _rewardsContract, uint _amount, uint _startWeek, uint _numberOfWeeks)
707     external
708   {
709     iSupportContract rewardsContract = _getSupportContract(_rewardsContract);
710     _transfer(msg.sender, address(rewardsContract), _amount);
711     rewardsContract.fundRewardsPool(_amount, _startWeek, _numberOfWeeks);
712   }
713 
714   // @dev Sets the sender's support on a game to the specific value
715   // @param _rewardsContract - the contract that will set support
716   // @param _game - the game to be supported
717   // @param _increase - the amount support to be added
718   // @notice - this will throw if the user has insufficient tokens available
719   // @notice - this does not throw on an _amount of 0
720   function setSupport(address _rewardsContract, uint _game, uint _amount) public {
721     iSupportContract rewardsContract = _getSupportContract(_rewardsContract);
722     _setSupport(rewardsContract, msg.sender, _game, _amount);
723   }
724 
725   // @dev Increases the sender's support on a game
726   // @param _rewardsContract - the contract that will increase support
727   // @param _game - the game to be supported
728   // @param _increase - the amount support to be added
729   // @notice - this will throw if the user has insufficient tokens available
730   // @notice - this will throw if an increase of 0 is requested
731   function increaseSupport(address _rewardsContract, uint _game, uint _increase) public {
732     iSupportContract rewardsContract = _getSupportContract(_rewardsContract);
733     uint supportBalance = rewardsContract.getGameAccountSupport(_game, msg.sender);
734     require(_increase > 0, "can't increase by 0");
735     _setSupport(rewardsContract, msg.sender, _game, supportBalance.add(_increase));
736   }
737 
738   // @dev Reduces the sender's support on a game
739   // @param _rewardsContract - the contract that will decrease support
740   // @param _game - the game to be supported
741   // @param _decrease - the amount support to be reduced
742   // @notice - this will throw if the user has fewer tokens support
743   // @notice - this will throw if a decrease of 0 is requested
744   function decreaseSupport(address _rewardsContract, uint _game, uint _decrease) public {
745     iSupportContract rewardsContract = _getSupportContract(_rewardsContract);
746     uint supportBalance = rewardsContract.getGameAccountSupport(_game, msg.sender);
747     require(_decrease > 0, "can't decrease by 0");
748     _setSupport(rewardsContract, msg.sender, _game, supportBalance.sub(_decrease));
749   }
750 
751   // @dev Transfers tokens to a set of user accounts, and sets their support for them
752   // @param _rewardsContract - the contract that will set the support
753   // @param _recipients - the accounts to receive the tokens
754   // @param _games - the games to be supported
755   // @param _amounts - the amount of tokens to be transferred
756   // @notice - this function is designed for air dropping by/to a game
757   function airDropAndSupport(
758     address _rewardsContract,
759     address[] calldata _recipients,
760     uint[] calldata _games,
761     uint[] calldata _amounts
762   )
763     external
764   {
765     iSupportContract rewardsContract = _getSupportContract(_rewardsContract);
766     require(_recipients.length == _games.length, "must be equal number of recipients and games");
767     require(_recipients.length == _amounts.length, "must be equal number of recipients and amounts");
768     for (uint i = 0; i < _recipients.length; i++) {
769       require(_recipients[i] != msg.sender, "can't airDrop to your own account");
770       uint supportBalance = rewardsContract.getGameAccountSupport(_games[i], _recipients[i]);
771       uint supportAmount = _amounts[i].add(supportBalance);
772       _transfer(msg.sender, _recipients[i], _amounts[i]);
773       _setSupport(rewardsContract, _recipients[i], _games[i], supportAmount);
774     }
775   }
776 
777   // @dev Pays an amount of game credits to a given support contract.
778   //   The support contract will often route the payment to multiple destinations.
779   //   The exact functionality will depend on the support contract in question.
780   //   Not all support contracts will implement the receiveGameCredits function
781   // @param _supportContract - the support contract to be called
782   // @param _game - a field to enter a game Id if it is required by the support contract
783   // @param _tokenId - a field to enter a token Id if it is required by the support contract
784   // @param _payment - the amount of GAME Credits that will be paid
785   // @param _data - a field to enter additional data if it is required by the support contract
786   function payGameCredits(
787     address _supportContract,
788     uint _game,
789     uint _tokenId,
790     uint _payment,
791     bytes32 _data
792   )
793     external
794   {
795     iSupportContract supportContract = _getSupportContract(_supportContract);
796 
797     _transfer(msg.sender, _supportContract, _payment);
798     supportContract.receiveGameCredits(_game, msg.sender, _tokenId, _payment, _data);
799   }
800 
801   // @dev Requests a payment of an amount of Loyalty Points in the sidechain.
802   //   The payment is made on the sidechain by the oracle.
803   //   There is no error checking, other than ensuring the game exists.
804   //   The exact functionality will depend on the oracle, and the sidechain contract in question.
805   //   Not all support contracts will implement the payLoyaltyPoints function, and even
806   //     if they do, the oracle might not pick it up.
807   // @param _supportContract - the support contract to be called
808   // @param _game - a field to enter a game Id if it is required by the support contract
809   // @param _tokenId - a field to enter a token Id if it is required by the support contract
810   // @param _payment - the amount of Loyalty Points requested to be paid
811   // @param _data - a field to enter additional data if it is required by the support contract
812   function payLoyaltyPoints(
813     address _supportContract,
814     uint _game,
815     uint _tokenId,
816     uint _loyaltyPayment,
817     bytes32 _data
818   )
819     external
820   {
821     iSupportContract supportContract = _getSupportContract(_supportContract);
822     supportContract.receiveLoyaltyPayment(_game, msg.sender, _tokenId, _loyaltyPayment, _data);
823   }
824 
825   // @dev Pays an amount of game credits to a given support contract.
826   //   The support contract will often route the payment to multiple destinations.
827   //   The exact functionality will depend on the support contract in question.
828   //   Not all support contracts will implement the contestEntry function
829   // @param _supportContract - the support contract to be called
830   // @param _game - a field to enter a game Id if it is required by the support contract
831   // @param _tokenId - a field to enter a token Id if it is required by the support contract
832   // @param _contestId - a field to enter a contest Id if it is required by the support contract
833   // @param _payment - the amount of GAME Credits that will be paid
834   // @param _data - a field to enter additional data if it is required by the support contract
835   function enterContest(
836     address _supportContract,
837     uint _game,
838     uint _tokenId,
839     uint _contestId,
840     uint _payment,
841     bytes32 _data
842   )
843     external
844   {
845     iSupportContract supportContract = _getSupportContract(_supportContract);
846     _transfer(msg.sender, _supportContract, _payment);
847     supportContract.contestEntry(_game, msg.sender, _tokenId, _contestId, _payment, _data);
848   }
849 
850   // @dev returns the iSupportContract for the input address. Throws if it doesn't exist.
851   // @param _contractAddress - the address to test
852   // @returns iSupportContract - the support contract address, typed as iSupportContract
853   function _getSupportContract(address _contractAddress)
854     internal
855     view
856   returns (iSupportContract)
857   {
858     iSupportContract supportContract = supportContracts[_contractAddress];
859     require(address(supportContract) != address(0), "support contract must be valid");
860     return supportContract;
861   }
862 
863   // @dev Sends the new support level to the rewards contract; transfers tokens to the
864   //   contract (for increased support) or from the contract (for decreased support)
865   // @param iSupportContract - the contract that will set the support
866   // @param _supporter - the account doing the supporting
867   // @param _game - the game to be supported
868   // @param _amount - the amount of tokens to set the support to
869   function _setSupport(iSupportContract rewardsContract, address _supporter, uint _game, uint _amount)
870     internal
871   {
872     // get user's balance from rewards contract
873     uint supportBalance = rewardsContract.getGameAccountSupport(_game, _supporter);
874 
875     if (_amount == supportBalance) {
876       return;
877     } else if (_amount > supportBalance) {
878       // transfer diff to rewards contract
879       _transfer(_supporter, address(rewardsContract), _amount.sub(supportBalance));
880     } else if (_amount < supportBalance) {
881       // transfer diff to account
882       _transfer(address(rewardsContract), _supporter, supportBalance.sub(_amount));
883     }
884     rewardsContract.updateSupport(_game, _supporter, _amount);
885   }
886 }