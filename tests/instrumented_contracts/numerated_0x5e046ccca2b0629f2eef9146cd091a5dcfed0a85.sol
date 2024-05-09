1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
29     require(token.transfer(to, value));
30   }
31 
32   function safeTransferFrom(
33     ERC20 token,
34     address from,
35     address to,
36     uint256 value
37   )
38     internal
39   {
40     require(token.transferFrom(from, to, value));
41   }
42 
43   function safeApprove(ERC20 token, address spender, uint256 value) internal {
44     require(token.approve(spender, value));
45   }
46 }
47 
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipRenounced(address indexed previousOwner);
60   event OwnershipTransferred(
61     address indexed previousOwner,
62     address indexed newOwner
63   );
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to relinquish control of the contract.
84    */
85   function renounceOwnership() public onlyOwner {
86     emit OwnershipRenounced(owner);
87     owner = address(0);
88   }
89 
90   /**
91    * @dev Allows the current owner to transfer control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address _newOwner) public onlyOwner {
95     _transferOwnership(_newOwner);
96   }
97 
98   /**
99    * @dev Transfers control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function _transferOwnership(address _newOwner) internal {
103     require(_newOwner != address(0));
104     emit OwnershipTransferred(owner, _newOwner);
105     owner = _newOwner;
106   }
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 /// Gives the owner the ability to transfer ownership of the contract to a new
118 /// address and it requires the owner of the new address to accept the transfer.
119 
120 
121 
122 
123 
124 
125 /**
126  * @title Claimable
127  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
128  * This allows the new owner to accept the transfer.
129  */
130 contract Claimable is Ownable {
131   address public pendingOwner;
132 
133   /**
134    * @dev Modifier throws if called by any account other than the pendingOwner.
135    */
136   modifier onlyPendingOwner() {
137     require(msg.sender == pendingOwner);
138     _;
139   }
140 
141   /**
142    * @dev Allows the current owner to set the pendingOwner address.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address newOwner) onlyOwner public {
146     pendingOwner = newOwner;
147   }
148 
149   /**
150    * @dev Allows the pendingOwner address to finalize the transfer.
151    */
152   function claimOwnership() onlyPendingOwner public {
153     emit OwnershipTransferred(owner, pendingOwner);
154     owner = pendingOwner;
155     pendingOwner = address(0);
156   }
157 }
158 
159 
160 
161 /// @title Admin functionality for TRVLToken.sol contracts.
162 contract Admin is Claimable{
163     mapping(address => bool) public admins;
164 
165     event AdminAdded(address added);
166     event AdminRemoved(address removed);
167 
168     /// @dev Verifies the msg.sender is a member of the admins mapping. Owner is by default an admin.
169     modifier onlyAdmin() {
170         require(admins[msg.sender] || msg.sender == owner, "msg.sender is not an admin!");
171         _;
172     }
173 
174     /// @notice Adds a list of addresses to the admins list.
175     /// @dev Requires that the msg.sender is the Owner. Emits an event on success.
176     /// @param _admins The list of addresses to add to the admins mapping.
177     function addAddressesToAdmins(address[] _admins) external onlyOwner {
178         require(_admins.length > 0, "Cannot add an empty list to admins!");
179         for (uint256 i = 0; i < _admins.length; ++i) {
180             address user = _admins[i];
181             require(user != address(0), "Cannot add the zero address to admins!");
182 
183             if (!admins[user]) {
184                 admins[user] = true;
185 
186                 emit AdminAdded(user);
187             }
188         }
189     }
190 
191     /// @notice Removes a list of addresses from the admins list.
192     /// @dev Requires that the msg.sender is an Owner. It is possible for the admins list to be empty, this is a fail safe
193     /// in the event the admin accounts are compromised. The owner has the ability to lockout the server access from which
194     /// TravelBlock is processing payments. Emits an event on success.
195     /// @param _admins The list of addresses to remove from the admins mapping.
196     function removeAddressesFromAdmins(address[] _admins) external onlyOwner {
197         require(_admins.length > 0, "Cannot remove an empty list to admins!");
198         for (uint256 i = 0; i < _admins.length; ++i) {
199             address user = _admins[i];
200 
201             if (admins[user]) {
202                 admins[user] = false;
203 
204                 emit AdminRemoved(user);
205             }
206         }
207     }
208 }
209 
210 
211 
212 /// @title Whitelist configurations for the TRVL Token contract.
213 contract Whitelist is Admin {
214     mapping(address => bool) public whitelist;
215 
216     event WhitelistAdded(address added);
217     event WhitelistRemoved(address removed);
218 
219     /// @dev Verifies the user is whitelisted.
220     modifier isWhitelisted(address _user) {
221         require(whitelist[_user] != false, "User is not whitelisted!");
222         _;
223     }
224 
225     /// @notice Adds a list of addresses to the whitelist.
226     /// @dev Requires that the msg.sender is the Admin. Emits an event on success.
227     /// @param _users The list of addresses to add to the whitelist.
228     function addAddressesToWhitelist(address[] _users) external onlyAdmin {
229         require(_users.length > 0, "Cannot add an empty list to whitelist!");
230         for (uint256 i = 0; i < _users.length; ++i) {
231             address user = _users[i];
232             require(user != address(0), "Cannot add the zero address to whitelist!");
233 
234             if (!whitelist[user]) {
235                 whitelist[user] = true;
236 
237                 emit WhitelistAdded(user);
238             }
239         }
240     }
241 
242     /// @notice Removes a list of addresses from the whitelist.
243     /// @dev Requires that the msg.sender is an Admin. Emits an event on success.
244     /// @param _users The list of addresses to remove from the whitelist.
245     function removeAddressesFromWhitelist(address[] _users) external onlyAdmin {
246         require(_users.length > 0, "Cannot remove an empty list to whitelist!");
247         for (uint256 i = 0; i < _users.length; ++i) {
248             address user = _users[i];
249 
250             if (whitelist[user]) {
251                 whitelist[user] = false;
252 
253                 emit WhitelistRemoved(user);
254             }
255         }
256     }
257 }
258 
259 
260 
261 
262 
263 
264 /// Standard ERC20 token with the ability to freeze and unfreeze token transfer.
265 
266 
267 
268 
269 
270 
271 
272 
273 
274 
275 
276 /**
277  * @title SafeMath
278  * @dev Math operations with safety checks that throw on error
279  */
280 library SafeMath {
281 
282   /**
283   * @dev Multiplies two numbers, throws on overflow.
284   */
285   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
286     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
287     // benefit is lost if 'b' is also tested.
288     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
289     if (a == 0) {
290       return 0;
291     }
292 
293     c = a * b;
294     assert(c / a == b);
295     return c;
296   }
297 
298   /**
299   * @dev Integer division of two numbers, truncating the quotient.
300   */
301   function div(uint256 a, uint256 b) internal pure returns (uint256) {
302     // assert(b > 0); // Solidity automatically throws when dividing by 0
303     // uint256 c = a / b;
304     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
305     return a / b;
306   }
307 
308   /**
309   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
310   */
311   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312     assert(b <= a);
313     return a - b;
314   }
315 
316   /**
317   * @dev Adds two numbers, throws on overflow.
318   */
319   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
320     c = a + b;
321     assert(c >= a);
322     return c;
323   }
324 }
325 
326 
327 
328 /**
329  * @title Basic token
330  * @dev Basic version of StandardToken, with no allowances.
331  */
332 contract BasicToken is ERC20Basic {
333   using SafeMath for uint256;
334 
335   mapping(address => uint256) balances;
336 
337   uint256 totalSupply_;
338 
339   /**
340   * @dev total number of tokens in existence
341   */
342   function totalSupply() public view returns (uint256) {
343     return totalSupply_;
344   }
345 
346   /**
347   * @dev transfer token for a specified address
348   * @param _to The address to transfer to.
349   * @param _value The amount to be transferred.
350   */
351   function transfer(address _to, uint256 _value) public returns (bool) {
352     require(_to != address(0));
353     require(_value <= balances[msg.sender]);
354 
355     balances[msg.sender] = balances[msg.sender].sub(_value);
356     balances[_to] = balances[_to].add(_value);
357     emit Transfer(msg.sender, _to, _value);
358     return true;
359   }
360 
361   /**
362   * @dev Gets the balance of the specified address.
363   * @param _owner The address to query the the balance of.
364   * @return An uint256 representing the amount owned by the passed address.
365   */
366   function balanceOf(address _owner) public view returns (uint256) {
367     return balances[_owner];
368   }
369 
370 }
371 
372 
373 
374 
375 
376 
377 /**
378  * @title ERC20 interface
379  * @dev see https://github.com/ethereum/EIPs/issues/20
380  */
381 contract ERC20 is ERC20Basic {
382   function allowance(address owner, address spender)
383     public view returns (uint256);
384 
385   function transferFrom(address from, address to, uint256 value)
386     public returns (bool);
387 
388   function approve(address spender, uint256 value) public returns (bool);
389   event Approval(
390     address indexed owner,
391     address indexed spender,
392     uint256 value
393   );
394 }
395 
396 
397 
398 /**
399  * @title Standard ERC20 token
400  *
401  * @dev Implementation of the basic standard token.
402  * @dev https://github.com/ethereum/EIPs/issues/20
403  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
404  */
405 contract StandardToken is ERC20, BasicToken {
406 
407   mapping (address => mapping (address => uint256)) internal allowed;
408 
409 
410   /**
411    * @dev Transfer tokens from one address to another
412    * @param _from address The address which you want to send tokens from
413    * @param _to address The address which you want to transfer to
414    * @param _value uint256 the amount of tokens to be transferred
415    */
416   function transferFrom(
417     address _from,
418     address _to,
419     uint256 _value
420   )
421     public
422     returns (bool)
423   {
424     require(_to != address(0));
425     require(_value <= balances[_from]);
426     require(_value <= allowed[_from][msg.sender]);
427 
428     balances[_from] = balances[_from].sub(_value);
429     balances[_to] = balances[_to].add(_value);
430     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
431     emit Transfer(_from, _to, _value);
432     return true;
433   }
434 
435   /**
436    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
437    *
438    * Beware that changing an allowance with this method brings the risk that someone may use both the old
439    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
440    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
441    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
442    * @param _spender The address which will spend the funds.
443    * @param _value The amount of tokens to be spent.
444    */
445   function approve(address _spender, uint256 _value) public returns (bool) {
446     allowed[msg.sender][_spender] = _value;
447     emit Approval(msg.sender, _spender, _value);
448     return true;
449   }
450 
451   /**
452    * @dev Function to check the amount of tokens that an owner allowed to a spender.
453    * @param _owner address The address which owns the funds.
454    * @param _spender address The address which will spend the funds.
455    * @return A uint256 specifying the amount of tokens still available for the spender.
456    */
457   function allowance(
458     address _owner,
459     address _spender
460    )
461     public
462     view
463     returns (uint256)
464   {
465     return allowed[_owner][_spender];
466   }
467 
468   /**
469    * @dev Increase the amount of tokens that an owner allowed to a spender.
470    *
471    * approve should be called when allowed[_spender] == 0. To increment
472    * allowed value is better to use this function to avoid 2 calls (and wait until
473    * the first transaction is mined)
474    * From MonolithDAO Token.sol
475    * @param _spender The address which will spend the funds.
476    * @param _addedValue The amount of tokens to increase the allowance by.
477    */
478   function increaseApproval(
479     address _spender,
480     uint _addedValue
481   )
482     public
483     returns (bool)
484   {
485     allowed[msg.sender][_spender] = (
486       allowed[msg.sender][_spender].add(_addedValue));
487     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
488     return true;
489   }
490 
491   /**
492    * @dev Decrease the amount of tokens that an owner allowed to a spender.
493    *
494    * approve should be called when allowed[_spender] == 0. To decrement
495    * allowed value is better to use this function to avoid 2 calls (and wait until
496    * the first transaction is mined)
497    * From MonolithDAO Token.sol
498    * @param _spender The address which will spend the funds.
499    * @param _subtractedValue The amount of tokens to decrease the allowance by.
500    */
501   function decreaseApproval(
502     address _spender,
503     uint _subtractedValue
504   )
505     public
506     returns (bool)
507   {
508     uint oldValue = allowed[msg.sender][_spender];
509     if (_subtractedValue > oldValue) {
510       allowed[msg.sender][_spender] = 0;
511     } else {
512       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
513     }
514     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
515     return true;
516   }
517 
518 }
519 
520 
521 
522 
523 
524 
525 
526 /**
527  * @title Pausable
528  * @dev Base contract which allows children to implement an emergency stop mechanism.
529  */
530 contract Pausable is Ownable {
531   event Pause();
532   event Unpause();
533 
534   bool public paused = false;
535 
536 
537   /**
538    * @dev Modifier to make a function callable only when the contract is not paused.
539    */
540   modifier whenNotPaused() {
541     require(!paused);
542     _;
543   }
544 
545   /**
546    * @dev Modifier to make a function callable only when the contract is paused.
547    */
548   modifier whenPaused() {
549     require(paused);
550     _;
551   }
552 
553   /**
554    * @dev called by the owner to pause, triggers stopped state
555    */
556   function pause() onlyOwner whenNotPaused public {
557     paused = true;
558     emit Pause();
559   }
560 
561   /**
562    * @dev called by the owner to unpause, returns to normal state
563    */
564   function unpause() onlyOwner whenPaused public {
565     paused = false;
566     emit Unpause();
567   }
568 }
569 
570 
571 
572 /**
573  * @title Pausable token
574  * @dev StandardToken modified with pausable transfers.
575  **/
576 contract PausableToken is StandardToken, Pausable {
577 
578   function transfer(
579     address _to,
580     uint256 _value
581   )
582     public
583     whenNotPaused
584     returns (bool)
585   {
586     return super.transfer(_to, _value);
587   }
588 
589   function transferFrom(
590     address _from,
591     address _to,
592     uint256 _value
593   )
594     public
595     whenNotPaused
596     returns (bool)
597   {
598     return super.transferFrom(_from, _to, _value);
599   }
600 
601   function approve(
602     address _spender,
603     uint256 _value
604   )
605     public
606     whenNotPaused
607     returns (bool)
608   {
609     return super.approve(_spender, _value);
610   }
611 
612   function increaseApproval(
613     address _spender,
614     uint _addedValue
615   )
616     public
617     whenNotPaused
618     returns (bool success)
619   {
620     return super.increaseApproval(_spender, _addedValue);
621   }
622 
623   function decreaseApproval(
624     address _spender,
625     uint _subtractedValue
626   )
627     public
628     whenNotPaused
629     returns (bool success)
630   {
631     return super.decreaseApproval(_spender, _subtractedValue);
632   }
633 }
634 
635 
636 /// Blocks ERC223 tokens and allows the smart contract to transfer ownership of
637 /// ERC20 tokens that are sent to the contract address.
638 
639 
640 
641 
642 
643 
644 
645 
646 
647 /**
648  * @title Contracts that should be able to recover tokens
649  * @author SylTi
650  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
651  * This will prevent any accidental loss of tokens.
652  */
653 contract CanReclaimToken is Ownable {
654   using SafeERC20 for ERC20Basic;
655 
656   /**
657    * @dev Reclaim all ERC20Basic compatible tokens
658    * @param token ERC20Basic The address of the token contract
659    */
660   function reclaimToken(ERC20Basic token) external onlyOwner {
661     uint256 balance = token.balanceOf(this);
662     token.safeTransfer(owner, balance);
663   }
664 
665 }
666 
667 
668 
669 /**
670  * @title Contracts that should not own Tokens
671  * @author Remco Bloemen <remco@2π.com>
672  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
673  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
674  * owner to reclaim the tokens.
675  */
676 contract HasNoTokens is CanReclaimToken {
677 
678  /**
679   * @dev Reject all ERC223 compatible tokens
680   * @param from_ address The address that is transferring the tokens
681   * @param value_ uint256 the amount of the specified token
682   * @param data_ Bytes The data passed from the caller.
683   */
684   function tokenFallback(address from_, uint256 value_, bytes data_) external {
685     from_;
686     value_;
687     data_;
688     revert();
689   }
690 
691 }
692 
693 
694 
695 /// @title Reward Token contract that contains all reward token configurations.
696 contract RewardToken is PausableToken, Whitelist, HasNoTokens{
697     /// @dev Any token balances added here must be removed from the balances map.
698     mapping(address => uint256) public rewardBalances;
699 
700     uint256[] public rewardPercentage;
701     uint256 public rewardPercentageDecimals;
702     uint256 public rewardPercentageDivisor;
703 
704     event RewardPercentage(uint256 index, uint256 percentage);
705 
706     /// @dev Verifies the reward index is valid.
707     modifier isValidRewardIndex(uint256 _index) {
708         require(_index < rewardPercentage.length, "The reward percentage index does not exist!");
709         _;
710     }
711 
712     /// @dev Verifies the reward percentage is valid.
713     modifier isValidRewardPercentage(uint256 _percentage) {
714         require(_percentage <= rewardPercentageDivisor, "Cannot have a reward percentage greater than 100%!");
715         _;
716     }
717 
718     constructor(uint256 _rewardPercentageDecimals) public {
719         rewardPercentageDecimals = _rewardPercentageDecimals;
720         rewardPercentageDivisor = (10 ** uint256(_rewardPercentageDecimals)).mul(100);
721     }
722 
723     /// @notice Adds a reward percentage to the list of available reward percentages, specific to 18 decimals.
724     /// @dev To achieve an affective 5% bonus, the sender needs to use 5 x 10^18.
725     /// Requires:
726     ///     - Msg.sender is an admin
727     ///     - Percentage is <= 100%
728     /// @param _percentage The new percentage specific to 18 decimals.
729     /// @return The index of the percentage added in the rewardPercentage array.
730     function addRewardPercentage(uint256 _percentage) public onlyAdmin isValidRewardPercentage(_percentage) returns (uint256 _index) {
731         _index = rewardPercentage.length;
732         rewardPercentage.push(_percentage);
733 
734         emit RewardPercentage(_index, _percentage);
735     }
736 
737     /// @notice Edits the contents of the percentage array, with the specified parameters.
738     /// @dev Allows the owner to edit percentage array contents for a given index.
739     /// Requires:
740     ///     - Msg.sender is an admin
741     ///     - The index must be within the bounds of the rewardPercentage array
742     ///     - The new percentage must be <= 100%
743     /// @param _index The index of the percentage to be edited.
744     /// @param _percentage The new percentage to be used for the given index.
745     function updateRewardPercentageByIndex(uint256 _index, uint256 _percentage)
746         public
747         onlyAdmin
748         isValidRewardIndex(_index)
749         isValidRewardPercentage(_percentage)
750     {
751         rewardPercentage[_index] = _percentage;
752 
753         emit RewardPercentage(_index, _percentage);
754     }
755 
756     /// @dev Calculates the reward based on the reward percentage index.
757     /// Requires:
758     ///     - The index must be within the bounds of the rewardPercentage array
759     /// @param _amount The amount tokens to be converted to rewards.
760     /// @param _rewardPercentageIndex The location of reward percentage to be applied.
761     /// @return The amount of tokens converted to reward tokens.
762     function getRewardToken(uint256 _amount, uint256 _rewardPercentageIndex)
763         internal
764         view
765         isValidRewardIndex(_rewardPercentageIndex)
766         returns(uint256 _rewardToken)
767     {
768         _rewardToken = _amount.mul(rewardPercentage[_rewardPercentageIndex]).div(rewardPercentageDivisor);
769     }
770 }
771 
772 
773 
774 /// @title TRVLToken smart contract
775 contract TRVLToken is RewardToken {
776     string public constant name = "TRVL Token";
777     string public constant symbol = "TRVL";
778     uint8 public constant decimals = 18;
779     uint256 public constant TOTAL_CAP = 600000000 * (10 ** uint256(decimals));
780 
781     event TransferReward(address from, address to, uint256 value);
782 
783     /// @dev Verifies the user has enough tokens to cover the payment.
784     modifier senderHasEnoughTokens(uint256 _regularTokens, uint256 _rewardTokens) {
785         require(rewardBalances[msg.sender] >= _rewardTokens, "User does not have enough reward tokens!");
786         require(balances[msg.sender] >= _regularTokens, "User does not have enough regular tokens!");
787         _;
788     }
789 
790     /// @dev Verifies the amount is > 0.
791     modifier validAmount(uint256 _amount) {
792         require(_amount > 0, "The amount specified is 0!");
793         _;
794     }
795 
796     /// @dev The TRVL Token is an ERC20 complaint token with a built in reward system that
797     /// gives users back a percentage of tokens spent on travel. These tokens are
798     /// non-transferable and can only be spent on travel through the TravelBlock website.
799     /// The percentages are defined in the rewardPercentage array and can be modified by
800     /// the TravelBlock team. The token is created with the entire balance being owned by the address that deploys.
801     constructor() RewardToken(decimals) public {
802         totalSupply_ = TOTAL_CAP;
803         balances[owner] = totalSupply_;
804         emit Transfer(0x0, owner, totalSupply_);
805     }
806 
807     /// @notice Process a payment that prioritizes the use of regular tokens.
808     /// @dev Uses up all of the available regular tokens, before using rewards tokens to cover a payment. Pushes the calculated amounts
809     /// into their respective function calls.
810     /// @param _amount The total tokens to be paid.
811     function paymentRegularTokensPriority (uint256 _amount, uint256 _rewardPercentageIndex) public {
812         uint256 regularTokensAvailable = balances[msg.sender];
813 
814         if (regularTokensAvailable >= _amount) {
815             paymentRegularTokens(_amount, _rewardPercentageIndex);
816 
817         } else {
818             if (regularTokensAvailable > 0) {
819                 uint256 amountOfRewardsTokens = _amount.sub(regularTokensAvailable);
820                 paymentMixed(regularTokensAvailable, amountOfRewardsTokens, _rewardPercentageIndex);
821             } else {
822                 paymentRewardTokens(_amount);
823             }
824         }
825     }
826 
827     /// @notice Process a payment that prioritizes the use of reward tokens.
828     /// @dev Uses up all of the available reward tokens, before using regular tokens to cover a payment. Pushes the calculated amounts
829     /// into their respective function calls.
830     /// @param _amount The total tokens to be paid.
831     function paymentRewardTokensPriority (uint256 _amount, uint256 _rewardPercentageIndex) public {
832         uint256 rewardTokensAvailable = rewardBalances[msg.sender];
833 
834         if (rewardTokensAvailable >= _amount) {
835             paymentRewardTokens(_amount);
836         } else {
837             if (rewardTokensAvailable > 0) {
838                 uint256 amountOfRegularTokens = _amount.sub(rewardTokensAvailable);
839                 paymentMixed(amountOfRegularTokens, rewardTokensAvailable, _rewardPercentageIndex);
840             } else {
841                 paymentRegularTokens(_amount, _rewardPercentageIndex);
842             }
843         }
844     }
845 
846     /// @notice Process a TRVL tokens payment with a combination of regular and rewards tokens.
847     /// @dev calls the regular/rewards payment methods respectively.
848     /// @param _regularTokenAmount The amount of regular tokens to be processed.
849     /// @param _rewardTokenAmount The amount of reward tokens to be processed.
850     function paymentMixed (uint256 _regularTokenAmount, uint256 _rewardTokenAmount, uint256 _rewardPercentageIndex) public {
851         paymentRewardTokens(_rewardTokenAmount);
852         paymentRegularTokens(_regularTokenAmount, _rewardPercentageIndex);
853     }
854 
855     /// @notice Process a payment using only regular TRVL Tokens with a specified reward percentage.
856     /// @dev Adjusts the balances accordingly and applies a reward token bonus. The accounts must be whitelisted because the travel team must own the address
857     /// to make transfers on their behalf.
858     /// Requires:
859     ///     - The contract is not paused
860     ///     - The amount being processed is greater than 0
861     ///     - The reward index being passed is valid
862     ///     - The sender has enough tokens to cover the payment
863     ///     - The sender is a whitelisted address
864     /// @param _regularTokenAmount The amount of regular tokens being used for the payment.
865     /// @param _rewardPercentageIndex The index pointing to the percentage of reward tokens to be applied.
866     function paymentRegularTokens (uint256 _regularTokenAmount, uint256 _rewardPercentageIndex)
867         public
868         validAmount(_regularTokenAmount)
869         isValidRewardIndex(_rewardPercentageIndex)
870         senderHasEnoughTokens(_regularTokenAmount, 0)
871         isWhitelisted(msg.sender)
872         whenNotPaused
873     {
874         // 1. Pay the specified amount with from the balance of the user/sender.
875         balances[msg.sender] = balances[msg.sender].sub(_regularTokenAmount);
876 
877         // 2. distribute reward tokens to the user.
878         uint256 rewardAmount = getRewardToken(_regularTokenAmount, _rewardPercentageIndex);
879         rewardBalances[msg.sender] = rewardBalances[msg.sender].add(rewardAmount);
880         emit TransferReward(owner, msg.sender, rewardAmount);
881 
882         // 3. Update the owner balance minus the reward tokens.
883         balances[owner] = balances[owner].add(_regularTokenAmount.sub(rewardAmount));
884         emit Transfer(msg.sender, owner, _regularTokenAmount.sub(rewardAmount));
885     }
886 
887     /// @notice Process a payment using only reward TRVL Tokens.
888     /// @dev Adjusts internal balances accordingly. The accounts must be whitelisted because the travel team must own the address
889     /// to make transfers on their behalf.
890     /// Requires:
891     ///     - The contract is not paused
892     ///     - The amount being processed is greater than 0
893     ///     - The sender has enough tokens to cover the payment
894     ///     - The sender is a whitelisted address
895     /// @param _rewardTokenAmount The amount of reward tokens being used for the payment.
896     function paymentRewardTokens (uint256 _rewardTokenAmount)
897         public
898         validAmount(_rewardTokenAmount)
899         senderHasEnoughTokens(0, _rewardTokenAmount)
900         isWhitelisted(msg.sender)
901         whenNotPaused
902     {
903         rewardBalances[msg.sender] = rewardBalances[msg.sender].sub(_rewardTokenAmount);
904         rewardBalances[owner] = rewardBalances[owner].add(_rewardTokenAmount);
905 
906         emit TransferReward(msg.sender, owner, _rewardTokenAmount);
907     }
908 
909     /// @notice Convert a specific amount of regular TRVL tokens from the owner, into reward tokens for a user.
910     /// @dev Converts the regular tokens into reward tokens at a 1-1 ratio.
911     /// Requires:
912     ///     - Owner has enough tokens to convert
913     ///     - The specified user is whitelisted
914     ///     - The amount being converted is greater than 0
915     /// @param _user The user receiving the converted tokens.
916     /// @param _amount The amount of tokens to be converted.
917     function convertRegularToRewardTokens(address _user, uint256 _amount)
918         external
919         onlyOwner
920         validAmount(_amount)
921         senderHasEnoughTokens(_amount, 0)
922         isWhitelisted(_user)
923     {
924         balances[msg.sender] = balances[msg.sender].sub(_amount);
925         rewardBalances[_user] = rewardBalances[_user].add(_amount);
926 
927         emit TransferReward(msg.sender, _user, _amount);
928     }
929 }