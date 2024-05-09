1 pragma solidity 0.4.21;
2 
3 // File: contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: contracts/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: contracts/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135   }
136 }
137 
138 // File: contracts/ERC20.sol
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 // File: contracts/Ownable.sol
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() public {
170     owner = msg.sender;
171   }
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) public onlyOwner {
186     require(newOwner != address(0));
187     OwnershipTransferred(owner, newOwner);
188     owner = newOwner;
189   }
190 
191 }
192 
193 // File: contracts/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: contracts/MintableToken.sol
291 
292 /**
293  * @title Mintable token
294  * @dev Simple ERC20 Token example, with mintable token creation
295  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
296  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
297  */
298 contract MintableToken is StandardToken, Ownable {
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301 
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     Mint(_to, _amount);
320     Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     MintFinished();
331     return true;
332   }
333 }
334 
335 // File: contracts/HVT.sol
336 
337 contract HVT is MintableToken, BurnableToken {
338   using SafeMath for uint256;
339 
340   string public name = "HiVe Token";
341   string public symbol = "HVT";
342   uint8 public decimals = 18;
343 
344   enum State {Blocked,Burnable,Transferable}
345   State public state = State.Blocked;
346 
347   // functions overrides in order to maintain the token locked during the ICO
348   function transfer(address _to, uint256 _value) public returns(bool) {
349     require(state == State.Transferable);
350     return super.transfer(_to,_value);
351   }
352 
353   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
354       require(state == State.Transferable);
355       return super.transferFrom(_from,_to,_value);
356   }
357 
358   function approve(address _spender, uint256 _value) public returns (bool) {
359     require(state == State.Transferable);
360     return super.approve(_spender,_value);
361   }
362 
363   function burn(uint256 _value) public {
364     require(state == State.Transferable || state == State.Burnable);
365     super.burn(_value);
366   }
367 
368   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
369     require(state == State.Transferable);
370     super.increaseApproval(_spender, _addedValue);
371   }
372 
373   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
374     require(state == State.Transferable);
375     super.decreaseApproval(_spender, _subtractedValue);
376   }
377 
378   // enable token transfers
379   function enableTokenTransfers() public onlyOwner {
380     state = State.Transferable;
381   }
382 
383   // enable token burn
384   function enableTokenBurn() public onlyOwner {
385     state = State.Burnable;
386   }
387 
388   // batch transfer with different amounts for each address
389   function batchTransferDiff(address[] _to, uint256[] _amount) public {
390     require(state == State.Transferable);
391     require(_to.length == _amount.length);
392     uint256 totalAmount = arraySum(_amount);
393     require(totalAmount <= balances[msg.sender]);
394     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
395     for(uint i;i < _to.length;i++){
396       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
397       Transfer(msg.sender,_to[i],_amount[i]);
398     }
399   }
400 
401   // batch transfer with same amount for each address
402   function batchTransferSame(address[] _to, uint256 _amount) public {
403     require(state == State.Transferable);
404     uint256 totalAmount = _amount.mul(_to.length);
405     require(totalAmount <= balances[msg.sender]);
406     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
407     for(uint i;i < _to.length;i++){
408       balances[_to[i]] = balances[_to[i]].add(_amount);
409       Transfer(msg.sender,_to[i],_amount);
410     }
411   }
412 
413   // get sum of array values
414   function arraySum(uint256[] _amount) internal pure returns(uint256){
415     uint256 totalAmount;
416     for(uint i;i < _amount.length;i++){
417       totalAmount = totalAmount.add(_amount[i]);
418     }
419     return totalAmount;
420   }
421 }
422 
423 // File: contracts/ICOEngineInterface.sol
424 
425 contract ICOEngineInterface {
426 
427     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
428     function started() public view returns(bool);
429 
430     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
431     function ended() public view returns(bool);
432 
433     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
434     function startTime() public view returns(uint);
435 
436     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
437     function endTime() public view returns(uint);
438 
439     // Optional function, can be implemented in place of startTime
440     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
441     // function startBlock() public view returns(uint);
442 
443     // Optional function, can be implemented in place of endTime
444     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
445     // function endBlock() public view returns(uint);
446 
447     // returns the total number of the tokens available for the sale, must not change when the ico is started
448     function totalTokens() public view returns(uint);
449 
450     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
451     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
452     function remainingTokens() public view returns(uint);
453 
454     // return the price as number of tokens released for each ether
455     function price() public view returns(uint);
456 }
457 
458 // File: contracts/KYCBase.sol
459 
460 //import "./SafeMath.sol";
461 
462 
463 // Abstract base contract
464 contract KYCBase {
465     using SafeMath for uint256;
466 
467     mapping (address => bool) public isKycSigner;
468     mapping (uint64 => uint256) public alreadyPayed;
469 
470     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
471 
472     function KYCBase(address [] kycSigners) internal {
473         for (uint i = 0; i < kycSigners.length; i++) {
474             isKycSigner[kycSigners[i]] = true;
475         }
476     }
477 
478     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
479     function releaseTokensTo(address buyer) internal returns(bool);
480 
481     // This method can be overridden to enable some sender to buy token for a different address
482     function senderAllowedFor(address buyer)
483         internal view returns(bool)
484     {
485         return buyer == msg.sender;
486     }
487 
488     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
489         public payable returns (bool)
490     {
491         require(senderAllowedFor(buyerAddress));
492         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
493     }
494 
495     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
496         public payable returns (bool)
497     {
498         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
499     }
500 
501     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
502         private returns (bool)
503     {
504         // check the signature
505         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
506         address signer = ecrecover(hash, v, r, s);
507         if (!isKycSigner[signer]) {
508             revert();
509         } else {
510             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
511             require(totalPayed <= maxAmount);
512             alreadyPayed[buyerId] = totalPayed;
513             KycVerified(signer, buyerAddress, buyerId, maxAmount);
514             return releaseTokensTo(buyerAddress);
515         }
516     }
517 
518     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
519     function () public {
520         revert();
521     }
522 }
523 
524 // File: contracts/RefundVault.sol
525 
526 /**
527  * @title RefundVault
528  * @dev This contract is used for storing funds while a crowdsale
529  * is in progress. Supports refunding the money if crowdsale fails,
530  * and forwarding it if crowdsale is successful.
531  */
532 contract RefundVault is Ownable {
533   using SafeMath for uint256;
534 
535   enum State { Active, Refunding, Closed }
536 
537   mapping (address => uint256) public deposited;
538   address public wallet;
539   State public state;
540 
541   event Closed();
542   event RefundsEnabled();
543   event Refunded(address indexed beneficiary, uint256 weiAmount);
544 
545   function RefundVault(address _wallet) public {
546     require(_wallet != address(0));
547     wallet = _wallet;
548     state = State.Active;
549   }
550 
551   function deposit(address investor) onlyOwner public payable {
552     require(state == State.Active);
553     deposited[investor] = deposited[investor].add(msg.value);
554   }
555 
556   function close() onlyOwner public {
557     require(state == State.Active);
558     state = State.Closed;
559     Closed();
560     wallet.transfer(this.balance);
561   }
562 
563   function enableRefunds() onlyOwner public {
564     require(state == State.Active);
565     state = State.Refunding;
566     RefundsEnabled();
567   }
568 
569   function refund(address investor) public {
570     require(state == State.Refunding);
571     uint256 depositedValue = deposited[investor];
572     deposited[investor] = 0;
573     investor.transfer(depositedValue);
574     Refunded(investor, depositedValue);
575   }
576 }
577 
578 // File: contracts/SafeERC20.sol
579 
580 /**
581  * @title SafeERC20
582  * @dev Wrappers around ERC20 operations that throw on failure.
583  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
584  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
585  */
586 library SafeERC20 {
587   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
588     assert(token.transfer(to, value));
589   }
590 
591   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
592     assert(token.transferFrom(from, to, value));
593   }
594 
595   function safeApprove(ERC20 token, address spender, uint256 value) internal {
596     assert(token.approve(spender, value));
597   }
598 }
599 
600 // File: contracts/TokenTimelock.sol
601 
602 /**
603  * @title TokenTimelock
604  * @dev TokenTimelock is a token holder contract that will allow a
605  * beneficiary to extract the tokens after a given release time
606  */
607 contract TokenTimelock {
608   using SafeERC20 for ERC20Basic;
609 
610   // ERC20 basic token contract being held
611   ERC20Basic public token;
612 
613   // beneficiary of tokens after they are released
614   address public beneficiary;
615 
616   // timestamp when token release is enabled
617   uint256 public releaseTime;
618 
619   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
620     require(_releaseTime > now);
621     token = _token;
622     beneficiary = _beneficiary;
623     releaseTime = _releaseTime;
624   }
625 
626   /**
627    * @notice Transfers tokens held by timelock to beneficiary.
628    */
629   function release() public {
630     require(now >= releaseTime);
631 
632     uint256 amount = token.balanceOf(this);
633     require(amount > 0);
634 
635     token.safeTransfer(beneficiary, amount);
636   }
637 }
638 
639 // File: contracts/HivePowerCrowdsale.sol
640 
641 // The Hive Power crowdsale contract
642 contract HivePowerCrowdsale is Ownable, ICOEngineInterface, KYCBase {
643     using SafeMath for uint;
644     enum State {Running,Success,Failure}
645 
646     State public state;
647 
648     HVT public token;
649 
650     address public wallet;
651 
652     // from ICOEngineInterface
653     uint [] public prices;
654 
655     // from ICOEngineInterface
656     uint public startTime;
657 
658     // from ICOEngineInterface
659     uint public endTime;
660 
661     // from ICOEngineInterface
662     uint [] public caps;
663 
664     // from ICOEngineInterface
665     uint public remainingTokens;
666 
667     // from ICOEngineInterface
668     uint public totalTokens;
669 
670     // amount of wei raised
671     uint public weiRaised;
672 
673     // soft goal in wei
674     uint public goal;
675 
676     // boolean to make sure preallocate is called only once
677     bool public isPreallocated;
678 
679     // preallocated company token
680     uint public companyTokens;
681 
682     // preallocated token for founders
683     uint public foundersTokens;
684 
685     // vault for refunding
686     RefundVault public vault;
687 
688     // addresses of time-locked founder vaults
689     address [4] public timeLockAddresses;
690 
691     // step in seconds for token release
692     uint public stepLockedToken;
693 
694     // allowed overshoot when crossing the bonus barrier (in wei)
695     uint public overshoot;
696 
697     /**
698      * event for token purchase logging
699      * @param purchaser who paid for the tokens
700      * @param beneficiary who got the tokens
701      * @param value weis paid for purchase
702      * @param amount amount of tokens purchased
703      */
704     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
705 
706     /**
707     * event for when weis are sent back to buyer
708     * @param purchaser who paid for the tokens and is getting back some ether
709     * @param amount of weis sent back
710     */
711     event SentBack(address indexed purchaser, uint256 amount);
712 
713     /* event for ICO successfully finalized */
714     event FinalizedOK();
715 
716     /* event for ICO not successfully finalized */
717     event FinalizedNOK();
718 
719     /**
720      * event for additional token minting
721      * @param timelock address of the time-lock contract
722      * @param amount amount of tokens minted
723      * @param releaseTime release time of tokens
724      * @param wallet address of the wallet that can get the token released
725      */
726     event TimeLocked(address indexed timelock, uint256 amount, uint256 releaseTime, address indexed wallet);
727 
728     /**
729      * event for additional token minting
730      * @param to who got the tokens
731      * @param amount amount of tokens purchased
732      */
733     event Preallocated(address indexed to, uint256 amount);
734 
735     /**
736      *  Constructor
737      */
738     function HivePowerCrowdsale(address [] kycSigner, address _token, address _wallet, uint _startTime, uint _endTime, uint [] _prices, uint [] _caps, uint _goal, uint _companyTokens, uint _foundersTokens, uint _stepLockedToken, uint _overshoot)
739         public
740         KYCBase(kycSigner)
741     {
742         require(_token != address(0));
743         require(_wallet != address(0));
744         require(_startTime > now);
745         require(_endTime > _startTime);
746         require(_prices.length == _caps.length);
747 
748         for (uint256 i=0; i < _caps.length -1; i++)
749         {
750           require(_caps[i+1].sub(_caps[i]) > _overshoot.mul(_prices[i]));
751         }
752 
753         token = HVT(_token);
754         wallet = _wallet;
755         startTime = _startTime;
756         endTime = _endTime;
757         prices = _prices;
758         caps = _caps;
759         totalTokens = _caps[_caps.length-1];
760         remainingTokens = _caps[_caps.length-1];
761         vault = new RefundVault(_wallet);
762         goal = _goal;
763         companyTokens = _companyTokens;
764         foundersTokens = _foundersTokens;
765         stepLockedToken = _stepLockedToken;
766         overshoot = _overshoot;
767         state = State.Running;
768         isPreallocated = false;
769     }
770 
771     function preallocate() onlyOwner public {
772       // can be called only once
773       require(!isPreallocated);
774 
775       // mint tokens for team founders in timelocked vaults
776       uint numTimelocks = 4;
777       uint amount = foundersTokens / numTimelocks; //amount of token per vault
778       uint256 releaseTime = endTime;
779       for(uint256 i=0; i < numTimelocks; i++)
780       {
781         // update releaseTime according to the step
782         releaseTime = releaseTime.add(stepLockedToken);
783         // create tokentimelock
784         TokenTimelock timeLock = new TokenTimelock(token, wallet, releaseTime);
785         // keep address in memory
786         timeLockAddresses[i] = address(timeLock);
787         // mint tokens in tokentimelock
788         token.mint(address(timeLock), amount);
789         // generate event
790         TimeLocked(address(timeLock), amount, releaseTime, wallet);
791       }
792 
793       //teamTimeLocks.mintTokens(teamTokens);
794       // Mint additional tokens (referral, airdrops, etc.)
795       token.mint(wallet, companyTokens);
796       Preallocated(wallet, companyTokens);
797       // cannot be called anymore
798       isPreallocated = true;
799     }
800 
801     // function that is called from KYCBase
802     function releaseTokensTo(address buyer) internal returns(bool) {
803         // needs to be started
804         require(started());
805         // and not ended
806         require(!ended());
807 
808         uint256 weiAmount = msg.value;
809         uint256 weiBack = 0;
810         uint currentPrice = price();
811         uint currentCap = getCap();
812         uint tokens = weiAmount.mul(currentPrice);
813         uint tokenRaised = totalTokens - remainingTokens;
814 
815         //check if tokens exceed the amount of tokens that can be minted
816         if (tokenRaised.add(tokens) > currentCap)
817         {
818           tokens = currentCap.sub(tokenRaised);
819           weiAmount = tokens.div(currentPrice);
820           weiBack = msg.value - weiAmount;
821         }
822         //require(tokenRaised.add(tokens) <= currentCap);
823 
824         weiRaised = weiRaised + weiAmount;
825         remainingTokens = remainingTokens.sub(tokens);
826 
827         // mint tokens and transfer funds
828         token.mint(buyer, tokens);
829         forwardFunds(weiAmount);
830 
831         if (weiBack>0)
832         {
833           msg.sender.transfer(weiBack);
834           SentBack(msg.sender, weiBack);
835         }
836 
837         TokenPurchase(msg.sender, buyer, weiAmount, tokens);
838         return true;
839     }
840 
841     function forwardFunds(uint256 weiAmount) internal {
842       vault.deposit.value(weiAmount)(msg.sender);
843     }
844 
845     /**
846      * @dev finalize an ICO in dependency on the goal reaching:
847      * 1) reached goal (successful ICO):
848      * -> release sold token for the transfers
849      * -> close the vault
850      * -> close the ICO successfully
851      * 2) not reached goal (not successful ICO):
852      * -> call finalizeNOK()
853      */
854     function finalize() onlyOwner public {
855       require(state == State.Running);
856       require(ended());
857 
858       // Check the soft goal reaching
859       if(weiRaised >= goal) {
860         // if goal reached
861 
862         // stop the minting
863         token.finishMinting();
864         // enable token transfers
865         token.enableTokenTransfers();
866         // close the vault and transfer funds to wallet
867         vault.close();
868 
869         // ICO successfully finalized
870         // set state to Success
871         state = State.Success;
872         FinalizedOK();
873       }
874       else {
875         // if goal NOT reached
876         // ICO not successfully finalized
877         finalizeNOK();
878       }
879     }
880 
881     /**
882      * @dev finalize an unsuccessful ICO:
883      * -> enable the refund
884      * -> close the ICO not successfully
885      */
886      function finalizeNOK() onlyOwner public {
887        // run checks again because this is a public function
888        require(state == State.Running);
889        require(ended());
890        // stop the minting
891        token.finishMinting();
892        // allow to burn tokens
893        token.enableTokenBurn();
894        // enable the refunds
895        vault.enableRefunds();
896        // ICO not successfully finalised
897        // set state to Failure
898        state = State.Failure;
899        FinalizedNOK();
900      }
901 
902      // if crowdsale is unsuccessful, investors can claim refunds here
903      function claimRefund() public {
904        require(state == State.Failure);
905        vault.refund(msg.sender);
906     }
907 
908     // get the next cap as a function of the amount of sold token
909     function getCap() public view returns(uint){
910       uint tokenRaised=totalTokens-remainingTokens;
911       for (uint i=0;i<caps.length-1;i++){
912         if (tokenRaised < caps[i])
913         {
914           // allow for a an overshoot (only when bonus is applied)
915           uint tokenPerOvershoot = overshoot * prices[i];
916           return(caps[i].add(tokenPerOvershoot));
917         }
918       }
919       // but not on the total amount of tokens
920       return(totalTokens);
921     }
922 
923     // from ICOEngineInterface
924     function started() public view returns(bool) {
925         return now >= startTime;
926     }
927 
928     // from ICOEngineInterface
929     function ended() public view returns(bool) {
930         return now >= endTime || remainingTokens == 0;
931     }
932 
933     function startTime() public view returns(uint) {
934       return(startTime);
935     }
936 
937     function endTime() public view returns(uint){
938       return(endTime);
939     }
940 
941     function totalTokens() public view returns(uint){
942       return(totalTokens);
943     }
944 
945     function remainingTokens() public view returns(uint){
946       return(remainingTokens);
947     }
948 
949     // return the price as number of tokens released for each ether
950     function price() public view returns(uint){
951       uint tokenRaised=totalTokens-remainingTokens;
952       for (uint i=0;i<caps.length-1;i++){
953         if (tokenRaised < caps[i])
954         {
955           return(prices[i]);
956         }
957       }
958       return(prices[prices.length-1]);
959     }
960 
961     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
962     function () public {
963         revert();
964     }
965 
966 }
967 
968 // File: contracts/ERC20Interface.sol
969 
970 contract ERC20Interface {
971     function totalSupply() public view returns (uint256);
972     function balanceOf(address who) public view returns (uint256);
973     function transfer(address to, uint256 value) public returns (bool);
974     event Transfer(address indexed from, address indexed to, uint256 value);
975 
976     function allowance(address owner, address spender) public view returns (uint256);
977     function transferFrom(address from, address to, uint256 value) public returns (bool);
978     function approve(address spender, uint256 value) public returns (bool);
979     event Approval(address indexed owner, address indexed spender, uint256 value);
980 }