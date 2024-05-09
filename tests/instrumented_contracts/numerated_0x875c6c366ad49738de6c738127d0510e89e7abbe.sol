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
344   bool public enableTransfers = false;
345 
346   // functions overrides in order to maintain the token locked during the ICO
347   function transfer(address _to, uint256 _value) public returns(bool) {
348     require(enableTransfers);
349     return super.transfer(_to,_value);
350   }
351 
352   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
353       require(enableTransfers);
354       return super.transferFrom(_from,_to,_value);
355   }
356 
357   function approve(address _spender, uint256 _value) public returns (bool) {
358     require(enableTransfers);
359     return super.approve(_spender,_value);
360   }
361 
362   function burn(uint256 _value) public {
363     require(enableTransfers);
364     super.burn(_value);
365   }
366 
367   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
368     require(enableTransfers);
369     super.increaseApproval(_spender, _addedValue);
370   }
371 
372   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
373     require(enableTransfers);
374     super.decreaseApproval(_spender, _subtractedValue);
375   }
376 
377   // enable token transfers
378   function enableTokenTransfers() public onlyOwner {
379     enableTransfers = true;
380   }
381 
382   // batch transfer with different amounts for each address
383   function batchTransferDiff(address[] _to, uint256[] _amount) public {
384     require(enableTransfers);
385     require(_to.length == _amount.length);
386     uint256 totalAmount = arraySum(_amount);
387     require(totalAmount <= balances[msg.sender]);
388     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
389     for(uint i;i < _to.length;i++){
390       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
391       Transfer(msg.sender,_to[i],_amount[i]);
392     }
393   }
394 
395   // batch transfer with same amount for each address
396   function batchTransferSame(address[] _to, uint256 _amount) public {
397     require(enableTransfers);
398     uint256 totalAmount = _amount.mul(_to.length);
399     require(totalAmount <= balances[msg.sender]);
400     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
401     for(uint i;i < _to.length;i++){
402       balances[_to[i]] = balances[_to[i]].add(_amount);
403       Transfer(msg.sender,_to[i],_amount);
404     }
405   }
406 
407   // get sum of array values
408   function arraySum(uint256[] _amount) internal pure returns(uint256){
409     uint256 totalAmount;
410     for(uint i;i < _amount.length;i++){
411       totalAmount = totalAmount.add(_amount[i]);
412     }
413     return totalAmount;
414   }
415 }
416 
417 // File: contracts/ICOEngineInterface.sol
418 
419 contract ICOEngineInterface {
420 
421     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
422     function started() public view returns(bool);
423 
424     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
425     function ended() public view returns(bool);
426 
427     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
428     function startTime() public view returns(uint);
429 
430     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
431     function endTime() public view returns(uint);
432 
433     // Optional function, can be implemented in place of startTime
434     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
435     // function startBlock() public view returns(uint);
436 
437     // Optional function, can be implemented in place of endTime
438     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
439     // function endBlock() public view returns(uint);
440 
441     // returns the total number of the tokens available for the sale, must not change when the ico is started
442     function totalTokens() public view returns(uint);
443 
444     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
445     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
446     function remainingTokens() public view returns(uint);
447 
448     // return the price as number of tokens released for each ether
449     function price() public view returns(uint);
450 }
451 
452 // File: contracts/KYCBase.sol
453 
454 //import "./SafeMath.sol";
455 
456 
457 // Abstract base contract
458 contract KYCBase {
459     using SafeMath for uint256;
460 
461     mapping (address => bool) public isKycSigner;
462     mapping (uint64 => uint256) public alreadyPayed;
463 
464     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
465 
466     function KYCBase(address [] kycSigners) internal {
467         for (uint i = 0; i < kycSigners.length; i++) {
468             isKycSigner[kycSigners[i]] = true;
469         }
470     }
471 
472     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
473     function releaseTokensTo(address buyer) internal returns(bool);
474 
475     // This method can be overridden to enable some sender to buy token for a different address
476     function senderAllowedFor(address buyer)
477         internal view returns(bool)
478     {
479         return buyer == msg.sender;
480     }
481 
482     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
483         public payable returns (bool)
484     {
485         require(senderAllowedFor(buyerAddress));
486         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
487     }
488 
489     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
490         public payable returns (bool)
491     {
492         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
493     }
494 
495     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
496         private returns (bool)
497     {
498         // check the signature
499         bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
500         address signer = ecrecover(hash, v, r, s);
501         if (!isKycSigner[signer]) {
502             revert();
503         } else {
504             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
505             require(totalPayed <= maxAmount);
506             alreadyPayed[buyerId] = totalPayed;
507             KycVerified(signer, buyerAddress, buyerId, maxAmount);
508             return releaseTokensTo(buyerAddress);
509         }
510     }
511 
512     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
513     function () public {
514         revert();
515     }
516 }
517 
518 // File: contracts/RefundVault.sol
519 
520 /**
521  * @title RefundVault
522  * @dev This contract is used for storing funds while a crowdsale
523  * is in progress. Supports refunding the money if crowdsale fails,
524  * and forwarding it if crowdsale is successful.
525  */
526 contract RefundVault is Ownable {
527   using SafeMath for uint256;
528 
529   enum State { Active, Refunding, Closed }
530 
531   mapping (address => uint256) public deposited;
532   address public wallet;
533   State public state;
534 
535   event Closed();
536   event RefundsEnabled();
537   event Refunded(address indexed beneficiary, uint256 weiAmount);
538 
539   function RefundVault(address _wallet) public {
540     require(_wallet != address(0));
541     wallet = _wallet;
542     state = State.Active;
543   }
544 
545   function deposit(address investor) onlyOwner public payable {
546     require(state == State.Active);
547     deposited[investor] = deposited[investor].add(msg.value);
548   }
549 
550   function close() onlyOwner public {
551     require(state == State.Active);
552     state = State.Closed;
553     Closed();
554     wallet.transfer(this.balance);
555   }
556 
557   function enableRefunds() onlyOwner public {
558     require(state == State.Active);
559     state = State.Refunding;
560     RefundsEnabled();
561   }
562 
563   function refund(address investor) public {
564     require(state == State.Refunding);
565     uint256 depositedValue = deposited[investor];
566     deposited[investor] = 0;
567     investor.transfer(depositedValue);
568     Refunded(investor, depositedValue);
569   }
570 }
571 
572 // File: contracts/SafeERC20.sol
573 
574 /**
575  * @title SafeERC20
576  * @dev Wrappers around ERC20 operations that throw on failure.
577  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
578  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
579  */
580 library SafeERC20 {
581   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
582     assert(token.transfer(to, value));
583   }
584 
585   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
586     assert(token.transferFrom(from, to, value));
587   }
588 
589   function safeApprove(ERC20 token, address spender, uint256 value) internal {
590     assert(token.approve(spender, value));
591   }
592 }
593 
594 // File: contracts/TokenTimelock.sol
595 
596 /**
597  * @title TokenTimelock
598  * @dev TokenTimelock is a token holder contract that will allow a
599  * beneficiary to extract the tokens after a given release time
600  */
601 contract TokenTimelock {
602   using SafeERC20 for ERC20Basic;
603 
604   // ERC20 basic token contract being held
605   ERC20Basic public token;
606 
607   // beneficiary of tokens after they are released
608   address public beneficiary;
609 
610   // timestamp when token release is enabled
611   uint256 public releaseTime;
612 
613   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
614     require(_releaseTime > now);
615     token = _token;
616     beneficiary = _beneficiary;
617     releaseTime = _releaseTime;
618   }
619 
620   /**
621    * @notice Transfers tokens held by timelock to beneficiary.
622    */
623   function release() public {
624     require(now >= releaseTime);
625 
626     uint256 amount = token.balanceOf(this);
627     require(amount > 0);
628 
629     token.safeTransfer(beneficiary, amount);
630   }
631 }
632 
633 // File: contracts/HivePowerCrowdsale.sol
634 
635 // The Hive Power crowdsale contract
636 contract HivePowerCrowdsale is Ownable, ICOEngineInterface, KYCBase {
637     using SafeMath for uint;
638     enum State {Running,Success,Failure}
639 
640     State public state;
641 
642     HVT public token;
643 
644     address public wallet;
645 
646     // from ICOEngineInterface
647     uint [] public prices;
648 
649     // from ICOEngineInterface
650     uint public startTime;
651 
652     // from ICOEngineInterface
653     uint public endTime;
654 
655     // from ICOEngineInterface
656     uint [] public caps;
657 
658     // from ICOEngineInterface
659     uint public remainingTokens;
660 
661     // from ICOEngineInterface
662     uint public totalTokens;
663 
664     // amount of wei raised
665     uint public weiRaised;
666 
667     // soft goal in wei
668     uint public goal;
669 
670     // boolean to make sure preallocate is called only once
671     bool public isPreallocated;
672 
673     // preallocated company token
674     uint public companyTokens;
675 
676     // preallocated token for founders
677     uint public foundersTokens;
678 
679     // vault for refunding
680     RefundVault public vault;
681 
682     // addresses of time-locked founder vaults
683     address [4] public timeLockAddresses;
684 
685     // step in seconds for token release
686     uint public stepLockedToken;
687 
688     // allowed overshoot when crossing the bonus barrier (in wei)
689     uint public overshoot;
690 
691     /**
692      * event for token purchase logging
693      * @param purchaser who paid for the tokens
694      * @param beneficiary who got the tokens
695      * @param value weis paid for purchase
696      * @param amount amount of tokens purchased
697      */
698     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
699 
700     /**
701     * event for when weis are sent back to buyer
702     * @param purchaser who paid for the tokens and is getting back some ether
703     * @param amount of weis sent back
704     */
705     event SentBack(address indexed purchaser, uint256 amount);
706 
707     /* event for ICO successfully finalized */
708     event FinalizedOK();
709 
710     /* event for ICO not successfully finalized */
711     event FinalizedNOK();
712 
713     /**
714      * event for additional token minting
715      * @param timelock address of the time-lock contract
716      * @param amount amount of tokens minted
717      * @param releaseTime release time of tokens
718      * @param wallet address of the wallet that can get the token released
719      */
720     event TimeLocked(address indexed timelock, uint256 amount, uint256 releaseTime, address indexed wallet);
721 
722     /**
723      * event for additional token minting
724      * @param to who got the tokens
725      * @param amount amount of tokens purchased
726      */
727     event Preallocated(address indexed to, uint256 amount);
728 
729     /**
730      *  Constructor
731      */
732     function HivePowerCrowdsale(address [] kycSigner, address _token, address _wallet, uint _startTime, uint _endTime, uint [] _prices, uint [] _caps, uint _goal, uint _companyTokens, uint _foundersTokens, uint _stepLockedToken, uint _overshoot)
733         public
734         KYCBase(kycSigner)
735     {
736         require(_token != address(0));
737         require(_wallet != address(0));
738         require(_startTime > now);
739         require(_endTime > _startTime);
740         require(_prices.length == _caps.length);
741 
742         for (uint256 i=0; i < _caps.length -1; i++)
743         {
744           require(_caps[i+1].sub(_caps[i]) > _overshoot.mul(_prices[i]));
745         }
746 
747         token = HVT(_token);
748         wallet = _wallet;
749         startTime = _startTime;
750         endTime = _endTime;
751         prices = _prices;
752         caps = _caps;
753         totalTokens = _caps[_caps.length-1];
754         remainingTokens = _caps[_caps.length-1];
755         vault = new RefundVault(_wallet);
756         goal = _goal;
757         companyTokens = _companyTokens;
758         foundersTokens = _foundersTokens;
759         stepLockedToken = _stepLockedToken;
760         overshoot = _overshoot;
761         state = State.Running;
762         isPreallocated = false;
763     }
764 
765     function preallocate() onlyOwner public {
766       // can be called only once
767       require(!isPreallocated);
768 
769       // mint tokens for team founders in timelocked vaults
770       uint numTimelocks = 4;
771       uint amount = foundersTokens / numTimelocks; //amount of token per vault
772       uint256 releaseTime = endTime;
773       for(uint256 i=0; i < numTimelocks; i++)
774       {
775         // update releaseTime according to the step
776         releaseTime = releaseTime.add(stepLockedToken);
777         // create tokentimelock
778         TokenTimelock timeLock = new TokenTimelock(token, wallet, releaseTime);
779         // keep address in memory
780         timeLockAddresses[i] = address(timeLock);
781         // mint tokens in tokentimelock
782         token.mint(address(timeLock), amount);
783         // generate event
784         TimeLocked(address(timeLock), amount, releaseTime, wallet);
785       }
786 
787       //teamTimeLocks.mintTokens(teamTokens);
788       // Mint additional tokens (referral, airdrops, etc.)
789       token.mint(wallet, companyTokens);
790       Preallocated(wallet, companyTokens);
791       // cannot be called anymore
792       isPreallocated = true;
793     }
794 
795     // function that is called from KYCBase
796     function releaseTokensTo(address buyer) internal returns(bool) {
797         // needs to be started
798         require(started());
799         // and not ended
800         require(!ended());
801 
802         uint256 weiAmount = msg.value;
803         uint256 weiBack = 0;
804         uint currentPrice = price();
805         uint currentCap = getCap();
806         uint tokens = weiAmount.mul(currentPrice);
807         uint tokenRaised = totalTokens - remainingTokens;
808 
809         //check if tokens exceed the amount of tokens that can be minted
810         if (tokenRaised.add(tokens) > currentCap)
811         {
812           tokens = currentCap.sub(tokenRaised);
813           weiAmount = tokens.div(currentPrice);
814           weiBack = msg.value - weiAmount;
815         }
816         //require(tokenRaised.add(tokens) <= currentCap);
817 
818         weiRaised = weiRaised + weiAmount;
819         remainingTokens = remainingTokens.sub(tokens);
820 
821         // mint tokens and transfer funds
822         token.mint(buyer, tokens);
823         forwardFunds(weiAmount);
824 
825         if (weiBack>0)
826         {
827           msg.sender.transfer(weiBack);
828           SentBack(msg.sender, weiBack);
829         }
830 
831         TokenPurchase(msg.sender, buyer, weiAmount, tokens);
832         return true;
833     }
834 
835     function forwardFunds(uint256 weiAmount) internal {
836       vault.deposit.value(weiAmount)(msg.sender);
837     }
838 
839     /**
840      * @dev finalize an ICO in dependency on the goal reaching:
841      * 1) reached goal (successful ICO):
842      * -> release sold token for the transfers
843      * -> close the vault
844      * -> close the ICO successfully
845      * 2) not reached goal (not successful ICO):
846      * -> call finalizeNOK()
847      */
848     function finalize() onlyOwner public {
849       require(state == State.Running);
850       require(ended());
851 
852       // Check the soft goal reaching
853       if(weiRaised >= goal) {
854         // if goal reached
855 
856         // stop the minting
857         token.finishMinting();
858         // enable token transfers
859         token.enableTokenTransfers();
860         // close the vault and transfer funds to wallet
861         vault.close();
862 
863         // ICO successfully finalized
864         // set state to Success
865         state = State.Success;
866         FinalizedOK();
867       }
868       else {
869         // if goal NOT reached
870         // ICO not successfully finalized
871         finalizeNOK();
872       }
873     }
874 
875     /**
876      * @dev finalize an unsuccessful ICO:
877      * -> enable the refund
878      * -> close the ICO not successfully
879      */
880      function finalizeNOK() onlyOwner public {
881        // run checks again because this is a public function
882        require(state == State.Running);
883        require(ended());
884        // enable the refunds
885        vault.enableRefunds();
886        // ICO not successfully finalised
887        // set state to Failure
888        state = State.Failure;
889        FinalizedNOK();
890      }
891 
892      // if crowdsale is unsuccessful, investors can claim refunds here
893      function claimRefund() public {
894        require(state == State.Failure);
895        vault.refund(msg.sender);
896     }
897 
898     // get the next cap as a function of the amount of sold token
899     function getCap() public view returns(uint){
900       uint tokenRaised=totalTokens-remainingTokens;
901       for (uint i=0;i<caps.length-1;i++){
902         if (tokenRaised < caps[i])
903         {
904           // allow for a an overshoot (only when bonus is applied)
905           uint tokenPerOvershoot = overshoot * prices[i];
906           return(caps[i].add(tokenPerOvershoot));
907         }
908       }
909       // but not on the total amount of tokens
910       return(totalTokens);
911     }
912 
913     // from ICOEngineInterface
914     function started() public view returns(bool) {
915         return now >= startTime;
916     }
917 
918     // from ICOEngineInterface
919     function ended() public view returns(bool) {
920         return now >= endTime || remainingTokens == 0;
921     }
922 
923     function startTime() public view returns(uint) {
924       return(startTime);
925     }
926 
927     function endTime() public view returns(uint){
928       return(endTime);
929     }
930 
931     function totalTokens() public view returns(uint){
932       return(totalTokens);
933     }
934 
935     function remainingTokens() public view returns(uint){
936       return(remainingTokens);
937     }
938 
939     // return the price as number of tokens released for each ether
940     function price() public view returns(uint){
941       uint tokenRaised=totalTokens-remainingTokens;
942       for (uint i=0;i<caps.length-1;i++){
943         if (tokenRaised < caps[i])
944         {
945           return(prices[i]);
946         }
947       }
948       return(prices[prices.length-1]);
949     }
950 
951     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
952     function () public {
953         revert();
954     }
955 
956 }
957 
958 // File: contracts/ERC20Interface.sol
959 
960 contract ERC20Interface {
961     function totalSupply() public view returns (uint256);
962     function balanceOf(address who) public view returns (uint256);
963     function transfer(address to, uint256 value) public returns (bool);
964     event Transfer(address indexed from, address indexed to, uint256 value);
965 
966     function allowance(address owner, address spender) public view returns (uint256);
967     function transferFrom(address from, address to, uint256 value) public returns (bool);
968     function approve(address spender, uint256 value) public returns (bool);
969     event Approval(address indexed owner, address indexed spender, uint256 value);
970 }