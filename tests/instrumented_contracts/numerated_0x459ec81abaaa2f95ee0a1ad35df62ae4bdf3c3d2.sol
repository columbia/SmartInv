1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     emit Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * @dev Increase the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _addedValue The amount of tokens to increase the allowance by.
190    */
191   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 
221 
222 /* solium-disable security/no-low-level-calls */
223 
224 /**
225  * @title ERC827 interface, an extension of ERC20 token standard
226  *
227  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
228  * @dev methods to transfer value and data and execute calls in transfers and
229  * @dev approvals.
230  */
231 contract ERC827 is ERC20 {
232   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
233   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
234   function transferFromAndCall(
235     address _from,
236     address _to,
237     uint256 _value,
238     bytes _data
239   )
240     public
241     payable
242     returns (bool);
243 }
244 
245 
246 
247 /**
248  * @title ERC827, an extension of ERC20 token standard
249  *
250  * @dev Implementation the ERC827, following the ERC20 standard with extra
251  * @dev methods to transfer value and data and execute calls in transfers and
252  * @dev approvals.
253  *
254  * @dev Uses OpenZeppelin StandardToken.
255  */
256 contract ERC827Token is ERC827, StandardToken {
257 
258   /**
259    * @dev Addition to ERC20 token methods. It allows to
260    * @dev approve the transfer of value and execute a call with the sent data.
261    *
262    * @dev Beware that changing an allowance with this method brings the risk that
263    * @dev someone may use both the old and the new allowance by unfortunate
264    * @dev transaction ordering. One possible solution to mitigate this race condition
265    * @dev is to first reduce the spender's allowance to 0 and set the desired value
266    * @dev afterwards:
267    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    *
269    * @param _spender The address that will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    * @param _data ABI-encoded contract call to call `_to` address.
272    *
273    * @return true if the call function was executed successfully
274    */
275   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
276     require(_spender != address(this));
277 
278     super.approve(_spender, _value);
279 
280     // solium-disable-next-line security/no-call-value
281     require(_spender.call.value(msg.value)(_data));
282 
283     return true;
284   }
285 
286   /**
287    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
288    * @dev address and execute a call with the sent data on the same transaction
289    *
290    * @param _to address The address which you want to transfer to
291    * @param _value uint256 the amout of tokens to be transfered
292    * @param _data ABI-encoded contract call to call `_to` address.
293    *
294    * @return true if the call function was executed successfully
295    */
296   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
297     require(_to != address(this));
298 
299     super.transfer(_to, _value);
300 
301     // solium-disable-next-line security/no-call-value
302     require(_to.call.value(msg.value)(_data));
303     return true;
304   }
305 
306   /**
307    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
308    * @dev another and make a contract call on the same transaction
309    *
310    * @param _from The address which you want to send tokens from
311    * @param _to The address which you want to transfer to
312    * @param _value The amout of tokens to be transferred
313    * @param _data ABI-encoded contract call to call `_to` address.
314    *
315    * @return true if the call function was executed successfully
316    */
317   function transferFromAndCall(
318     address _from,
319     address _to,
320     uint256 _value,
321     bytes _data
322   )
323     public payable returns (bool)
324   {
325     require(_to != address(this));
326 
327     super.transferFrom(_from, _to, _value);
328 
329     // solium-disable-next-line security/no-call-value
330     require(_to.call.value(msg.value)(_data));
331     return true;
332   }
333 
334   /**
335    * @dev Addition to StandardToken methods. Increase the amount of tokens that
336    * @dev an owner allowed to a spender and execute a call with the sent data.
337    *
338    * @dev approve should be called when allowed[_spender] == 0. To increment
339    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
340    * @dev the first transaction is mined)
341    * @dev From MonolithDAO Token.sol
342    *
343    * @param _spender The address which will spend the funds.
344    * @param _addedValue The amount of tokens to increase the allowance by.
345    * @param _data ABI-encoded contract call to call `_spender` address.
346    */
347   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
348     require(_spender != address(this));
349 
350     super.increaseApproval(_spender, _addedValue);
351 
352     // solium-disable-next-line security/no-call-value
353     require(_spender.call.value(msg.value)(_data));
354 
355     return true;
356   }
357 
358   /**
359    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
360    * @dev an owner allowed to a spender and execute a call with the sent data.
361    *
362    * @dev approve should be called when allowed[_spender] == 0. To decrement
363    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
364    * @dev the first transaction is mined)
365    * @dev From MonolithDAO Token.sol
366    *
367    * @param _spender The address which will spend the funds.
368    * @param _subtractedValue The amount of tokens to decrease the allowance by.
369    * @param _data ABI-encoded contract call to call `_spender` address.
370    */
371   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
372     require(_spender != address(this));
373 
374     super.decreaseApproval(_spender, _subtractedValue);
375 
376     // solium-disable-next-line security/no-call-value
377     require(_spender.call.value(msg.value)(_data));
378 
379     return true;
380   }
381 
382 }
383 
384 
385 
386 /**
387  * @title Ownable
388  * @dev The Ownable contract has an owner address, and provides basic authorization control
389  * functions, this simplifies the implementation of "user permissions".
390  */
391 contract Ownable {
392   address public owner;
393 
394   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
395 
396   /**
397    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
398    * account.
399    */
400   function Ownable() public {
401     owner = msg.sender;
402   }
403 
404   /**
405    * @dev Throws if called by any account other than the owner.
406    */
407   modifier onlyOwner() {
408     require(msg.sender == owner);
409     _;
410   }
411 
412   /**
413    * @dev Allows the current owner to transfer control of the contract to a newOwner.
414    * @param newOwner The address to transfer ownership to.
415    */
416   function transferOwnership(address newOwner) public onlyOwner {
417     require(newOwner != address(0));
418     emit OwnershipTransferred(owner, newOwner);
419     owner = newOwner;
420   }
421 
422 }
423 
424 
425 
426 /**
427  * @title Pausable
428  * @dev Base contract which allows children to implement an emergency stop mechanism.
429  */
430 contract Pausable is Ownable {
431   event Pause();
432   event Unpause();
433 
434   bool public paused = false;
435 
436 
437   /**
438    * @dev Modifier to make a function callable only when the contract is not paused.
439    */
440   modifier whenNotPaused() {
441     require(!paused);
442     _;
443   }
444 
445   /**
446    * @dev Modifier to make a function callable only when the contract is paused.
447    */
448   modifier whenPaused() {
449     require(paused);
450     _;
451   }
452 
453   /**
454    * @dev called by the owner to pause, triggers stopped state
455    */
456   function pause() onlyOwner whenNotPaused public {
457     paused = true;
458     emit Pause();
459   }
460 
461   /**
462    * @dev called by the owner to unpause, returns to normal state
463    */
464   function unpause() onlyOwner whenPaused public {
465     paused = false;
466     emit Unpause();
467   }
468 }
469 
470 
471 
472 /**
473  * @title Claimable
474  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
475  * This allows the new owner to accept the transfer.
476  */
477 contract Claimable is Ownable {
478   address public pendingOwner;
479 
480   /**
481    * @dev Modifier throws if called by any account other than the pendingOwner.
482    */
483   modifier onlyPendingOwner() {
484     require(msg.sender == pendingOwner);
485     _;
486   }
487 
488   /**
489    * @dev Allows the current owner to set the pendingOwner address.
490    * @param newOwner The address to transfer ownership to.
491    */
492   function transferOwnership(address newOwner) onlyOwner public {
493     pendingOwner = newOwner;
494   }
495 
496   /**
497    * @dev Allows the pendingOwner address to finalize the transfer.
498    */
499   function claimOwnership() onlyPendingOwner public {
500     emit OwnershipTransferred(owner, pendingOwner);
501     owner = pendingOwner;
502     pendingOwner = address(0);
503   }
504 }
505 
506 
507 
508 /**
509  * @title MainframeToken
510  */
511 
512 contract MainframeToken is ERC827Token, Pausable, Claimable {
513   string public constant name = "Mainframe Token";
514   string public constant symbol = "MFT";
515   uint8  public constant decimals = 18;
516   address public distributor;
517 
518   modifier validDestination(address to) {
519     require(to != address(this));
520     _;
521   }
522 
523   modifier isTradeable() {
524     require(
525       !paused ||
526       msg.sender == owner ||
527       msg.sender == distributor
528     );
529     _;
530   }
531 
532   constructor() public {
533     totalSupply_ = 10000000000 ether; // 10 billion, 18 decimals (ether = 10^18)
534     balances[msg.sender] = totalSupply_;
535     emit Transfer(address(0x0), msg.sender, totalSupply_);
536   }
537 
538   // ERC20 Methods
539 
540   function transfer(address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
541     return super.transfer(to, value);
542   }
543 
544   function transferFrom(address from, address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
545     return super.transferFrom(from, to, value);
546   }
547 
548   function approve(address spender, uint256 value) public isTradeable returns (bool) {
549     return super.approve(spender, value);
550   }
551 
552   function increaseApproval(address spender, uint addedValue) public isTradeable returns (bool) {
553     return super.increaseApproval(spender, addedValue);
554   }
555 
556   function decreaseApproval(address spender, uint subtractedValue) public isTradeable returns (bool) {
557     return super.decreaseApproval(spender, subtractedValue);
558   }
559 
560   // ERC827 Methods
561 
562   function transferAndCall(address to, uint256 value, bytes data) public payable isTradeable returns (bool) {
563     return super.transferAndCall(to, value, data);
564   }
565 
566   function transferFromAndCall(address from, address to, uint256 value, bytes data) public payable isTradeable returns (bool) {
567     return super.transferFromAndCall(from, to, value, data);
568   }
569 
570   function approveAndCall(address spender, uint256 value, bytes data) public payable isTradeable returns (bool) {
571     return super.approveAndCall(spender, value, data);
572   }
573 
574   function increaseApprovalAndCall(address spender, uint addedValue, bytes data) public payable isTradeable returns (bool) {
575     return super.increaseApprovalAndCall(spender, addedValue, data);
576   }
577 
578   function decreaseApprovalAndCall(address spender, uint subtractedValue, bytes data) public payable isTradeable returns (bool) {
579     return super.decreaseApprovalAndCall(spender, subtractedValue, data);
580   }
581 
582   // Setters
583 
584   function setDistributor(address newDistributor) external onlyOwner {
585     distributor = newDistributor;
586   }
587 
588   // Token Drain
589 
590   function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
591     // owner can drain tokens that are sent here by mistake
592     token.transfer(owner, amount);
593   }
594 }
595 
596 
597 
598 contract StakeInterface {
599   function hasStake(address _address) external view returns (bool);
600 }
601 
602 
603 
604 contract MainframeStake is Ownable, StakeInterface {
605   using SafeMath for uint256;
606 
607   ERC20 token;
608   uint256 public arrayLimit = 200;
609   uint256 public totalDepositBalance;
610   uint256 public requiredStake;
611   mapping (address => uint256) public balances;
612 
613   struct Staker {
614     uint256 stakedAmount;
615     address stakerAddress;
616   }
617 
618   mapping (address => Staker) public whitelist; // map of whitelisted addresses for efficient hasStaked check
619 
620   constructor(address tokenAddress) public {
621     token = ERC20(tokenAddress);
622     requiredStake = 1 ether; // ether = 10^18
623   }
624 
625   /**
626   * @dev Staking MFT for a node address
627   * @param staker representing the address of the person staking (not msg.sender in case of calling from other contract)
628   * @param whitelistAddress representing the address of the node you want to stake for
629   */
630 
631   function stake(address staker, address whitelistAddress) external returns (bool success) {
632     require(whitelist[whitelistAddress].stakerAddress == 0x0);
633     require(staker == msg.sender || (msg.sender == address(token) && staker == tx.origin));
634 
635     whitelist[whitelistAddress].stakerAddress = staker;
636     whitelist[whitelistAddress].stakedAmount = requiredStake;
637 
638     deposit(staker, requiredStake);
639     emit Staked(staker);
640     return true;
641   }
642 
643   /**
644   * @dev Unstake a staked node address, will remove from whitelist and refund stake
645   * @param whitelistAddress representing the staked node address
646   */
647 
648   function unstake(address whitelistAddress) external {
649     require(whitelist[whitelistAddress].stakerAddress == msg.sender);
650 
651     uint256 stakedAmount = whitelist[whitelistAddress].stakedAmount;
652     delete whitelist[whitelistAddress];
653 
654     withdraw(msg.sender, stakedAmount);
655     emit Unstaked(msg.sender);
656   }
657 
658   /**
659   * @dev Deposit stake amount
660   * @param fromAddress representing the address to deposit from
661   * @param depositAmount representing amount being deposited
662   */
663 
664   function deposit(address fromAddress, uint256 depositAmount) private returns (bool success) {
665     token.transferFrom(fromAddress, this, depositAmount);
666     balances[fromAddress] = balances[fromAddress].add(depositAmount);
667     totalDepositBalance = totalDepositBalance.add(depositAmount);
668     emit Deposit(fromAddress, depositAmount, balances[fromAddress]);
669     return true;
670   }
671 
672   /**
673   * @dev Withdraw funds after unstaking
674   * @param toAddress representing the stakers address to withdraw to
675   * @param withdrawAmount representing stake amount being withdrawn
676   */
677 
678   function withdraw(address toAddress, uint256 withdrawAmount) private returns (bool success) {
679     require(balances[toAddress] >= withdrawAmount);
680     token.transfer(toAddress, withdrawAmount);
681     balances[toAddress] = balances[toAddress].sub(withdrawAmount);
682     totalDepositBalance = totalDepositBalance.sub(withdrawAmount);
683     emit Withdrawal(toAddress, withdrawAmount, balances[toAddress]);
684     return true;
685   }
686 
687   function balanceOf(address _address) external view returns (uint256 balance) {
688     return balances[_address];
689   }
690 
691   function totalStaked() external view returns (uint256) {
692     return totalDepositBalance;
693   }
694 
695   function hasStake(address _address) external view returns (bool) {
696     return whitelist[_address].stakedAmount > 0;
697   }
698 
699   function requiredStake() external view returns (uint256) {
700     return requiredStake;
701   }
702 
703   function setRequiredStake(uint256 value) external onlyOwner {
704     requiredStake = value;
705   }
706 
707   function setArrayLimit(uint256 newLimit) external onlyOwner {
708     arrayLimit = newLimit;
709   }
710 
711   function refundBalances(address[] addresses) external onlyOwner {
712     require(addresses.length <= arrayLimit);
713     for (uint256 i = 0; i < addresses.length; i++) {
714       address _address = addresses[i];
715       require(balances[_address] > 0);
716       token.transfer(_address, balances[_address]);
717       totalDepositBalance = totalDepositBalance.sub(balances[_address]);
718       emit RefundedBalance(_address, balances[_address]);
719       balances[_address] = 0;
720     }
721   }
722 
723   function emergencyERC20Drain(ERC20 _token) external onlyOwner {
724     // owner can drain tokens that are sent here by mistake
725     uint256 drainAmount;
726     if (address(_token) == address(token)) {
727       drainAmount = _token.balanceOf(this).sub(totalDepositBalance);
728     } else {
729       drainAmount = _token.balanceOf(this);
730     }
731     _token.transfer(owner, drainAmount);
732   }
733 
734   function destroy() external onlyOwner {
735     require(token.balanceOf(this) == 0);
736     selfdestruct(owner);
737   }
738 
739   event Staked(address indexed owner);
740   event Unstaked(address indexed owner);
741   event Deposit(address indexed _address, uint256 depositAmount, uint256 balance);
742   event Withdrawal(address indexed _address, uint256 withdrawAmount, uint256 balance);
743   event RefundedBalance(address indexed _address, uint256 refundAmount);
744 }