1 pragma solidity 0.4.21;
2 
3 // File: contracts/BytesDeserializer.sol
4 
5 /*
6  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
7  *
8  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
9  */
10 
11 /*
12  * Deserialize bytes payloads.
13  *
14  * Values are in big-endian byte order.
15  *
16  */
17 library BytesDeserializer {
18 
19   /*
20    * Extract 256-bit worth of data from the bytes stream.
21    */
22   function slice32(bytes b, uint offset) public pure returns (bytes32) {
23     bytes32 out;
24 
25     for (uint i = 0; i < 32; i++) {
26       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
27     }
28     return out;
29   }
30 
31   /*
32    * Extract Ethereum address worth of data from the bytes stream.
33    */
34   function sliceAddress(bytes b, uint offset) public pure returns (address) {
35     bytes32 out;
36 
37     for (uint i = 0; i < 20; i++) {
38       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
39     }
40     return address(uint(out));
41   }
42 
43   /*
44    * Extract 128-bit worth of data from the bytes stream.
45    */
46   function slice16(bytes b, uint offset) public pure returns (bytes16) {
47     bytes16 out;
48 
49     for (uint i = 0; i < 16; i++) {
50       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
51     }
52     return out;
53   }
54 
55   /*
56    * Extract 32-bit worth of data from the bytes stream.
57    */
58   function slice4(bytes b, uint offset) public pure returns (bytes4) {
59     bytes4 out;
60 
61     for (uint i = 0; i < 4; i++) {
62       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
63     }
64     return out;
65   }
66 
67   /*
68    * Extract 16-bit worth of data from the bytes stream.
69    */
70   function slice2(bytes b, uint offset) public pure returns (bytes2) {
71     bytes2 out;
72 
73     for (uint i = 0; i < 2; i++) {
74       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
75     }
76     return out;
77   }
78 
79 }
80 
81 // File: contracts/KYCPayloadDeserializer.sol
82 
83 /**
84  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
85  *
86  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
87  */
88 
89 
90 /**
91  * A mix-in contract to decode AML payloads.
92  *
93  * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we put this as a mix-in.
94  */
95 contract KYCPayloadDeserializer {
96 
97   using BytesDeserializer for bytes;
98 
99   /**
100    * This function takes the dataframe and unpacks it
101    * We have the users ETH address for verification that they are using their own signature
102    * CustomerID so we can track customer purchases
103    * Min/Max ETH to invest for AML/CTF purposes - this can be supplied by the user OR by the back-end.
104    */
105   function getKYCPayload(bytes dataframe) public pure returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth) {
106     address _whitelistedAddress = dataframe.sliceAddress(0);
107     uint128 _customerId = uint128(dataframe.slice16(20));
108     uint32 _minETH = uint32(dataframe.slice4(36));
109     uint32 _maxETH = uint32(dataframe.slice4(40));
110     return (_whitelistedAddress, _customerId, _minETH, _maxETH);
111   }
112 
113 }
114 
115 // File: contracts/Ownable.sol
116 
117 /**
118  * @title Ownable
119  * @dev The Ownable contract has an owner address, and provides basic authorization control
120  * functions, this simplifies the implementation of "user permissions".
121  */
122 contract Ownable {
123   address public owner;
124 
125   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127   /**
128    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
129    * account.
130    */
131   function Ownable() public {
132     owner = msg.sender;
133   }
134 
135   /**
136    * @dev Throws if called by any account other than the owner.
137    */
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) public onlyOwner {
149     require(newOwner != address(0));
150     OwnershipTransferred(owner, newOwner);
151     owner = newOwner;
152   }
153 
154 }
155 
156 // File: contracts/ERC20Basic.sol
157 
158 /**
159  * @title ERC20Basic
160  * @dev Simpler version of ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/179
162  */
163 contract ERC20Basic {
164   uint256 public totalSupply;
165   function balanceOf(address who) public view returns (uint256);
166   function transfer(address to, uint256 value) public returns (bool);
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 // File: contracts/SafeMath.sol
171 
172 /**
173  * @title SafeMath
174  * @dev Math operations with safety checks that throw on error
175  */
176 library SafeMath {
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         if (a == 0) {
179             return 0;
180         }
181         uint256 c = a * b;
182         assert(c / a == b);
183         return c;
184     }
185 
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         // assert(b > 0); // Solidity automatically throws when dividing by 0
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190         return c;
191     }
192 
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         assert(b <= a);
195         return a - b;
196     }
197 
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         assert(c >= a);
201         return c;
202     }
203 }
204 
205 // File: contracts/BasicToken.sol
206 
207 /**
208  * @title Basic token
209  * @dev Basic version of StandardToken, with no allowances.
210  */
211 contract BasicToken is ERC20Basic {
212   using SafeMath for uint256;
213 
214   mapping(address => uint256) balances;
215 
216   /**
217   * @dev transfer token for a specified address
218   * @param _to The address to transfer to.
219   * @param _value The amount to be transferred.
220   */
221   function transfer(address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[msg.sender]);
224 
225     // SafeMath.sub will throw if there is not enough balance.
226     balances[msg.sender] = balances[msg.sender].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     Transfer(msg.sender, _to, _value);
229     return true;
230   }
231 
232   /**
233   * @dev Gets the balance of the specified address.
234   * @param _owner The address to query the the balance of.
235   * @return An uint256 representing the amount owned by the passed address.
236   */
237   function balanceOf(address _owner) public view returns (uint256 balance) {
238     return balances[_owner];
239   }
240 
241 }
242 
243 // File: contracts/ERC20.sol
244 
245 /**
246  * @title ERC20 interface
247  * @dev see https://github.com/ethereum/EIPs/issues/20
248  */
249 contract ERC20 is ERC20Basic {
250   function allowance(address owner, address spender) public view returns (uint256);
251   function transferFrom(address from, address to, uint256 value) public returns (bool);
252   function approve(address spender, uint256 value) public returns (bool);
253   event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 // File: contracts/StandardToken.sol
257 
258 /**
259  * @title Standard ERC20 token
260  *
261  * @dev Implementation of the basic standard token.
262  * @dev https://github.com/ethereum/EIPs/issues/20
263  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
264  */
265 contract StandardToken is ERC20, BasicToken {
266 
267   mapping (address => mapping (address => uint256)) internal allowed;
268 
269 
270   /**
271    * @dev Transfer tokens from one address to another
272    * @param _from address The address which you want to send tokens from
273    * @param _to address The address which you want to transfer to
274    * @param _value uint256 the amount of tokens to be transferred
275    */
276   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
277     require(_to != address(0));
278     require(_value <= balances[_from]);
279     require(_value <= allowed[_from][msg.sender]);
280 
281     balances[_from] = balances[_from].sub(_value);
282     balances[_to] = balances[_to].add(_value);
283     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
284     Transfer(_from, _to, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
290    *
291    * Beware that changing an allowance with this method brings the risk that someone may use both the old
292    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
293    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
294    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295    * @param _spender The address which will spend the funds.
296    * @param _value The amount of tokens to be spent.
297    */
298   function approve(address _spender, uint256 _value) public returns (bool) {
299     allowed[msg.sender][_spender] = _value;
300     Approval(msg.sender, _spender, _value);
301     return true;
302   }
303 
304   /**
305    * @dev Function to check the amount of tokens that an owner allowed to a spender.
306    * @param _owner address The address which owns the funds.
307    * @param _spender address The address which will spend the funds.
308    * @return A uint256 specifying the amount of tokens still available for the spender.
309    */
310   function allowance(address _owner, address _spender) public view returns (uint256) {
311     return allowed[_owner][_spender];
312   }
313 
314   /**
315    * approve should be called when allowed[_spender] == 0. To increment
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    */
320   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
321     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
322     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
327     uint oldValue = allowed[msg.sender][_spender];
328     if (_subtractedValue > oldValue) {
329       allowed[msg.sender][_spender] = 0;
330     } else {
331       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
332     }
333     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337 }
338 
339 // File: contracts/ReleasableToken.sol
340 
341 /**
342  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
343  *
344  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
345  *
346  * Some of this code has been updated by Pickeringware ltd to faciliatte the new solidity compilation requirements
347  */
348 
349 pragma solidity 0.4.21;
350 
351 
352 
353 
354 /**
355  * Define interface for releasing the token transfer after a successful crowdsale.
356  */
357 contract ReleasableToken is StandardToken, Ownable {
358 
359   /* The finalizer contract that allows unlift the transfer limits on this token */
360   address public releaseAgent;
361 
362   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
363   bool public released = false;
364 
365   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
366   mapping (address => bool) public transferAgents;
367 
368   /**
369    * Limit token transfer until the crowdsale is over.
370    *
371    */
372   modifier canTransfer(address _sender) {
373     if(!released) {
374         if(!transferAgents[_sender]) {
375             revert();
376         }
377     }
378     _;
379   }
380 
381   /**
382    * Set the contract that can call release and make the token transferable.
383    *
384    * Design choice. Allow reset the release agent to fix fat finger mistakes.
385    */
386   function setReleaseAgent() onlyOwner inReleaseState(false) public {
387 
388     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
389     releaseAgent = owner;
390   }
391 
392   /**
393    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
394    */
395   function setTransferAgent(address addr, bool state) onlyReleaseAgent inReleaseState(false) public {
396     transferAgents[addr] = state;
397   }
398 
399   /**
400    * One way function to release the tokens to the wild.
401    *
402    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
403    */
404   function releaseTokenTransfer() public onlyReleaseAgent {
405     released = true;
406   }
407 
408   /** The function can be called only before or after the tokens have been releasesd */
409   modifier inReleaseState(bool releaseState) {
410     if(releaseState != released) {
411         revert();
412     }
413     _;
414   }
415 
416   /** The function can be called only by a whitelisted release agent. */
417   modifier onlyReleaseAgent() {
418     if(msg.sender != releaseAgent) {
419         revert();
420     }
421     _;
422   }
423 
424   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
425     // Call StandardToken.transfer()
426    return super.transfer(_to, _value);
427   }
428 
429   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
430     // Call StandardToken.transferForm()
431     return super.transferFrom(_from, _to, _value);
432   }
433 
434 }
435 
436 // File: contracts/MintableToken.sol
437 
438 /**
439  * @title Mintable token
440  * @dev Simple ERC20 Token example, with mintable token creation
441  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
442  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
443  * 
444  * Some of this code has been changed by Pickeringware ltd to facilitate solidities new compilation requirements
445  */
446 
447 contract MintableToken is ReleasableToken {
448   event Mint(address indexed to, uint256 amount);
449   event MintFinished();
450 
451   bool public mintingFinished = false;
452 
453   modifier canMint() {
454     require(!mintingFinished);
455     _;
456   }
457 
458   /**
459    * @dev Function to mint tokens
460    * @param _to The address that will receive the minted tokens.
461    * @param _amount The amount of tokens to mint.
462    * @return A boolean that indicates if the operation was successful.
463    */
464   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
465     totalSupply = totalSupply.add(_amount);
466     balances[_to] = balances[_to].add(_amount);
467     Mint(_to, _amount);
468     Transfer(address(0), _to, _amount);
469     return true;
470   }
471 
472   /**
473    * @dev Function to stop minting new tokens.
474    * @return True if the operation was successful.
475    */
476   function finishMinting() onlyOwner canMint public returns (bool) {
477     mintingFinished = true;
478     MintFinished();
479     return true;
480   }
481 }
482 
483 // File: contracts/AMLToken.sol
484 
485 /**
486  * This contract has been written by Pickeringware ltd in some areas to facilitate custom crwodsale features
487  */
488 
489 pragma solidity 0.4.21;
490 
491 
492 
493 /**
494  * The AML Token
495  *
496  * This subset of MintableCrowdsaleToken gives the Owner a possibility to
497  * reclaim tokens from a participant before the token is released
498  * after a participant has failed a prolonged AML process.
499  *
500  * It is assumed that the anti-money laundering process depends on blockchain data.
501  * The data is not available before the transaction and not for the smart contract.
502  * Thus, we need to implement logic to handle AML failure cases post payment.
503  * We give a time window before the token release for the token sale owners to
504  * complete the AML and claw back all token transactions that were
505  * caused by rejected purchases.
506  */
507 contract AMLToken is MintableToken {
508 
509   // An event when the owner has reclaimed non-released tokens
510   event ReclaimedAllAndBurned(address claimedBy, address fromWhom, uint amount);
511 
512     // An event when the owner has reclaimed non-released tokens
513   event ReclaimAndBurned(address claimedBy, address fromWhom, uint amount);
514 
515   /// @dev Here the owner can reclaim the tokens from a participant if
516   ///      the token is not released yet. Refund will be handled in sale contract.
517   /// We also burn the tokens in the interest of economic value to the token holder
518   /// @param fromWhom address of the participant whose tokens we want to claim
519   function reclaimAllAndBurn(address fromWhom) public onlyReleaseAgent inReleaseState(false) {
520     uint amount = balanceOf(fromWhom);    
521     balances[fromWhom] = 0;
522     totalSupply = totalSupply.sub(amount);
523     
524     ReclaimedAllAndBurned(msg.sender, fromWhom, amount);
525   }
526 
527   /// @dev Here the owner can reclaim the tokens from a participant if
528   ///      the token is not released yet. Refund will be handled in sale contract.
529   /// We also burn the tokens in the interest of economic value to the token holder
530   /// @param fromWhom address of the participant whose tokens we want to claim
531   function reclaimAndBurn(address fromWhom, uint256 amount) public onlyReleaseAgent inReleaseState(false) {       
532     balances[fromWhom] = balances[fromWhom].sub(amount);
533     totalSupply = totalSupply.sub(amount);
534     
535     ReclaimAndBurned(msg.sender, fromWhom, amount);
536   }
537 }
538 
539 // File: contracts/PickToken.sol
540 
541 /*
542  * This token is part of Pickeringware ltds smart contracts
543  * It is used to specify certain details about the token upon release
544  */
545 
546 
547 contract PickToken is AMLToken {
548   string public name = "AX1 Mining token";
549   string public symbol = "AX1";
550   uint8 public decimals = 5;
551 }
552 
553 // File: contracts/Stoppable.sol
554 
555 contract Stoppable is Ownable {
556   bool public halted;
557 
558   event SaleStopped(address owner, uint256 datetime);
559 
560   modifier stopInEmergency {
561     require(!halted);
562     _;
563   }
564 
565   function hasHalted() internal view returns (bool isHalted) {
566   	return halted;
567   }
568 
569    // called by the owner on emergency, triggers stopped state
570   function stopICO() external onlyOwner {
571     halted = true;
572     SaleStopped(msg.sender, now);
573   }
574 }
575 
576 // File: contracts/Crowdsale.sol
577 
578 /**
579  * @title Crowdsale
580  * @dev Crowdsale is a base contract for managing a token crowdsale.
581  * Crowdsales have a start and end timestamps, where investors can make
582  * token purchases and the crowdsale will assign them tokens based
583  * on a token per ETH rate. Funds collected are forwarded to a wallet
584  * as they arrive.
585  *
586  * This base contract has been changed in certain areas by Pickeringware ltd to facilitate extra functionality
587  */
588 contract Crowdsale is Stoppable {
589   using SafeMath for uint256;
590 
591   // The token being sold
592   PickToken public token;
593 
594   // start and end timestamps where investments are allowed (both inclusive)
595   uint256 public startTime;
596   uint256 public endTime;
597 
598   // address where funds are collected
599   address public wallet;
600   address public contractAddr;
601   
602   // how many token units a buyer gets per wei
603   uint256 public rate;
604 
605   // amount of raised money in wei
606   uint256 public weiRaised;
607   uint256 public presaleWeiRaised;
608 
609   // amount of tokens sent
610   uint256 public tokensSent;
611 
612   // These store balances of participants by ID, address and in wei, pre-sale wei and tokens
613   mapping(uint128 => uint256) public balancePerID;
614   mapping(address => uint256) public balanceOf;
615   mapping(address => uint256) public presaleBalanceOf;
616   mapping(address => uint256) public tokenBalanceOf;
617 
618   /**
619    * event for token purchase logging
620    * @param purchaser who paid for the tokens
621    * @param beneficiary who got the tokens
622    * @param value weis paid for purchase
623    * @param amount amount of tokens purchased
624    */
625   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 datetime);
626 
627   /*
628    * Contructor
629    * This initialises the basic crowdsale data
630    * It transfers ownership of this token to the chosen beneficiary 
631   */
632   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, PickToken _token) public {
633     require(_startTime >= now);
634     require(_endTime >= _startTime);
635     require(_rate > 0);
636     require(_wallet != address(0));
637 
638     token = _token;
639     startTime = _startTime;
640     endTime = _endTime;
641     rate = _rate;
642     wallet = _wallet;
643     transferOwnership(_wallet);
644   }
645 
646   /*
647    * This method has been changed by Pickeringware ltd
648    * We have split this method down into overidable functions which may affect how users purchase tokens
649    * We also take in a customerID (UUiD v4) which we store in our back-end in order to track users participation
650   */ 
651   function buyTokens(uint128 buyer) internal stopInEmergency {
652     require(buyer != 0);
653 
654     uint256 weiAmount = msg.value;
655 
656     // calculate token amount to be created
657     uint256 tokens = tokensToRecieve(weiAmount);
658 
659     // MUST DO REQUIRE AFTER tokens are calculated to check for cap restrictions in stages
660     require(validPurchase(tokens));
661 
662     // We move the participants sliders before we mint the tokens to prevent re-entrancy
663     finalizeSale(weiAmount, tokens, buyer);
664     produceTokens(msg.sender, weiAmount, tokens);
665   }
666 
667   // This function was created to be overridden by a parent contract
668   function produceTokens(address buyer, uint256 weiAmount, uint256 tokens) internal {
669     token.mint(buyer, tokens);
670     TokenPurchase(msg.sender, buyer, weiAmount, tokens, now);
671   }
672 
673   // This was created to be overriden by stages implementation
674   // It will adjust the stage sliders accordingly if needed
675   function finalizeSale(uint256 _weiAmount, uint256 _tokens, uint128 _buyer) internal {
676     // Collect ETH and send them a token in return
677     balanceOf[msg.sender] = balanceOf[msg.sender].add(_weiAmount);
678     tokenBalanceOf[msg.sender] = tokenBalanceOf[msg.sender].add(_tokens);
679     balancePerID[_buyer] = balancePerID[_buyer].add(_weiAmount);
680 
681     // update state
682     weiRaised = weiRaised.add(_weiAmount);
683     tokensSent = tokensSent.add(_tokens);
684   }
685   
686   // This was created to be overridden by the stages implementation
687   // Again, this is dependent on the price of tokens which may or may not be collected in stages
688   function tokensToRecieve(uint256 _wei) internal view returns (uint256 tokens) {
689     return _wei.div(rate);
690   }
691 
692   // send ether to the fund collection wallet
693   // override to create custom fund forwarding mechanisms
694   function successfulWithdraw() external onlyOwner stopInEmergency {
695     require(hasEnded());
696 
697     owner.transfer(weiRaised);
698   }
699 
700   // @return true if the transaction can buy tokens
701   // Receives tokens to send as variable for custom stage implementation
702   // Has an unused variable _tokens which is necessary for capped sale implementation
703   function validPurchase(uint256 _tokens) internal view returns (bool) {
704     bool withinPeriod = now >= startTime && now <= endTime;
705     bool nonZeroPurchase = msg.value != 0;
706     return withinPeriod && nonZeroPurchase;
707   }
708 
709   // @return true if crowdsale event has ended
710   function hasEnded() public view returns (bool) {
711     return now > endTime;
712   }
713 }
714 
715 // File: contracts/CappedCrowdsale.sol
716 
717 /**
718  * @title CappedCrowdsale
719  * @dev Extension of Crowdsale with a max amount of funds raised
720  */
721 contract CappedCrowdsale is Crowdsale {
722   using SafeMath for uint256;
723 
724   uint256 public softCap;
725   uint256 public hardCap;
726   uint256 public withdrawn;
727   bool public canWithdraw;
728   address public beneficiary;
729 
730   event BeneficiaryWithdrawal(address admin, uint256 amount, uint256 datetime);
731 
732   // Changed implentation to include soft/hard caps
733   function CappedCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _beneficiary, uint256 _softCap, uint256 _hardCap, PickToken _token) 
734     Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
735       public {
736 
737     require(_hardCap > 0 && _softCap > 0 && _softCap < _hardCap);
738 
739     softCap = _softCap;
740     hardCap = _hardCap;
741     withdrawn = 0;
742     canWithdraw = false;
743     beneficiary = _beneficiary;
744   }
745 
746   // overriding Crowdsale#validPurchase to add extra cap logic
747   // @return true if investors can buy at the moment
748   function validPurchase(uint256 _tokens) internal view returns (bool) {
749     bool withinCap = tokensSent.add(_tokens) <= hardCap;
750     return super.validPurchase(_tokens) && withinCap;
751   }
752   
753   // overriding Crowdsale#hasEnded to add cap logic
754   // @return true if crowdsale event has ended
755   function hasEnded() public view returns (bool) {
756     bool capReached = tokensSent >= hardCap;
757     return super.hasEnded() || capReached;
758   }
759 
760   // overriding Crowdsale#successfulWithdraw to add cap logic
761   // only allow beneficiary to withdraw if softcap has been reached
762   // Uses withdrawn incase a parent contract requires withdrawing softcap early
763   function successfulWithdraw() external onlyOwner stopInEmergency {
764     require(hasEnded());
765     // This is used for extra functionality if necessary, i.e. KYC checks
766     require(canWithdraw);
767     require(tokensSent > softCap);
768 
769     uint256 withdrawalAmount = weiRaised.sub(withdrawn);
770 
771     withdrawn = withdrawn.add(withdrawalAmount);
772 
773     beneficiary.transfer(withdrawalAmount);
774 
775     BeneficiaryWithdrawal(msg.sender, withdrawalAmount, now);
776   }
777 
778 }
779 
780 // File: contracts/SaleStagesLib.sol
781 
782 /*
783  * SaleStagesLib is a part of Pickeringware ltd's smart contracts
784  * Its intended use is to abstract the implementation of stages away from a contract to ease deployment and codel length
785  * It uses a stage struct to store specific details about each stage
786  * It has several functions which are used to get/change this data
787 */
788 
789 library SaleStagesLib {
790 	using SafeMath for uint256;
791 
792 	// Stores Stage implementation
793 	struct Stage{
794         uint256 deadline;
795         uint256 tokenPrice;
796         uint256 tokensSold;
797         uint256 minimumBuy;
798         uint256 cap;
799 	}
800 
801 	// The struct that is stored by the contract
802 	// Contains counter to iterate through map of stages
803 	struct StageStorage {
804  		mapping(uint8 => Stage) stages;
805  		uint8 stageCount;
806 	}
807 
808 	// Initiliase the stagecount to 0
809 	function init(StageStorage storage self) public {
810 		self.stageCount = 0;
811 	}
812 
813 	// Create stage adds new stage to stages map and increments stage count
814 	function createStage(
815 		StageStorage storage self, 
816 		uint8 _stage, 
817 		uint256 _deadline, 
818 		uint256 _price,
819 		uint256 _minimum,
820 		uint256 _cap
821 	) internal {
822         // Ensures stages cannot overlap each other
823         uint8 prevStage = _stage - 1;
824         require(self.stages[prevStage].deadline < _deadline);
825 		
826         self.stages[_stage].deadline = _deadline;
827 		self.stages[_stage].tokenPrice = _price;
828 		self.stages[_stage].tokensSold = 0;
829 		self.stages[_stage].minimumBuy = _minimum;
830 		self.stages[_stage].cap = _cap;
831 		self.stageCount = self.stageCount + 1;
832 	}
833 
834    /*
835     * Crowdfund state machine management.
836     *
837     * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
838     * Each one of these conditions checks if the time has passed into another stage and therefore, act as appropriate
839     */
840     function getStage(StageStorage storage self) public view returns (uint8 stage) {
841         uint8 thisStage = self.stageCount + 1;
842 
843         for (uint8 i = 0; i < thisStage; i++) {
844             if(now <= self.stages[i].deadline){
845                 return i;
846             }
847         }
848 
849         return thisStage;
850     }
851 
852     // Both of the below are checked on the overridden validPurchase() function
853     // Check to see if the tokens they're about to purchase is above the minimum for this stage
854     function checkMinimum(StageStorage storage self, uint8 _stage, uint256 _tokens) internal view returns (bool isValid) {
855     	if(_tokens < self.stages[_stage].minimumBuy){
856     		return false;
857     	} else {
858     		return true;
859     	}
860     }
861 
862     // Both of the below are checked on the overridden validPurchase() function
863     // Check to see if the tokens they're about to purchase is above the minimum for this stage
864     function changeDeadline(StageStorage storage self, uint8 _stage, uint256 _deadline) internal {
865         require(self.stages[_stage].deadline > now);
866         self.stages[_stage].deadline = _deadline;
867     }
868 
869     // Checks to see if the tokens they're about to purchase is below the cap for this stage
870     function checkCap(StageStorage storage self, uint8 _stage, uint256 _tokens) internal view returns (bool isValid) {
871     	uint256 totalTokens = self.stages[_stage].tokensSold.add(_tokens);
872 
873     	if(totalTokens > self.stages[_stage].cap){
874     		return false;
875     	} else {
876     		return true;
877     	}
878     }
879 
880     // Refund a particular participant, by moving the sliders of stages he participated in
881     function refundParticipant(StageStorage storage self, uint256 stage1, uint256 stage2, uint256 stage3, uint256 stage4) internal {
882         self.stages[1].tokensSold = self.stages[1].tokensSold.sub(stage1);
883         self.stages[2].tokensSold = self.stages[2].tokensSold.sub(stage2);
884         self.stages[3].tokensSold = self.stages[3].tokensSold.sub(stage3);
885         self.stages[4].tokensSold = self.stages[4].tokensSold.sub(stage4);
886     }
887     
888 	// Both of the below are checked on the overridden validPurchase() function
889     // Check to see if the tokens they're about to purchase is above the minimum for this stage
890     function changePrice(StageStorage storage self, uint8 _stage, uint256 _tokenPrice) internal {
891         require(self.stages[_stage].deadline > now);
892 
893         self.stages[_stage].tokenPrice = _tokenPrice;
894     }
895 }
896 
897 // File: contracts/PickCrowdsale.sol
898 
899 /*
900  * PickCrowdsale and PickToken are a part of Pickeringware ltd's smart contracts
901  * This uses the SaleStageLib which is also a part of Pickeringware ltd's smart contracts
902  * We create the stages initially in the constructor such that stages cannot be added after the sale has started
903  * We then pre-allocate necessary accounts prior to the sale starting
904  * This contract implements the stages lib functionality with overriding functions for stages implementation
905 */
906 contract PickCrowdsale is CappedCrowdsale {
907 
908   using SaleStagesLib for SaleStagesLib.StageStorage;
909   using SafeMath for uint256;
910 
911   SaleStagesLib.StageStorage public stages;
912 
913   bool preallocated = false;
914   bool stagesSet = false;
915   address private founders;
916   address private bounty;
917   address private buyer;
918   uint256 public burntBounty;
919   uint256 public burntFounder;
920 
921   event ParticipantWithdrawal(address participant, uint256 amount, uint256 datetime);
922   event StagePriceChanged(address admin, uint8 stage, uint256 price);
923   event ExtendedStart(uint256 oldStart, uint256 newStart);
924 
925   modifier onlyOnce(bool _check) {
926     if(_check) {
927       revert();
928     }
929     _;
930   }
931 
932   function PickCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _beneficiary, address _buyer, address _founders, address _bounty, uint256 _softCap, uint256 _hardCap, PickToken _token)
933   	CappedCrowdsale(_startTime, _endTime, _rate, _wallet, _beneficiary, _softCap, _hardCap, _token)
934      public { 
935     stages.init();
936     stages.createStage(0, _startTime, 0, 0, 0);
937     founders = _founders;
938     bounty = _bounty;
939     buyer = _buyer;
940   }
941 
942   function setPreallocations() external onlyOwner onlyOnce(preallocated) {
943     preallocate(buyer, 1250000, 10000000000);
944     preallocate(founders, 1777777, 0);
945     preallocate(bounty, 444445, 0);
946     preallocated = true;
947   }
948 
949   function setStages() external onlyOwner onlyOnce(stagesSet) {
950     stages.createStage(1, startTime.add(1 days), 100000000, 10000000, 175000000000);  //Deadline 1 day (86400)  after start - price: 0.001  - min: 90 - cap: 1,250,000
951     stages.createStage(2, startTime.add(2 days), 110000000, 5000000, 300000000000); //Deadline 2 days (172800) after start - price: 0.0011 - min: 60 - cap: 3,000,000 
952     stages.createStage(3, startTime.add(3 days), 120000000, 2500000, 575000000000);  //Deadline 4 days (345600) after start - price: 0.0012 - cap: 5,750,000 
953     stages.createStage(4, endTime, 150000000, 1000000, 2000000000000);               //Deadline 1 week after start - price: 0.0015 - cap: 20,000,000 
954     stagesSet = true;
955   }
956 
957   // Creates new stage for the crowdsale
958   // Can ONLY be called by the owner of the contract as should never change after creating them on initialisation
959   function createStage(uint8 _stage, uint256 _deadline, uint256 _price, uint256 _minimum, uint256 _cap ) internal onlyOwner {
960     stages.createStage(_stage, _deadline, _price, _minimum, _cap);
961   }
962 
963   // Creates new stage for the crowdsale
964   // Can ONLY be called by the owner of the contract as should never change after creating them on initialisation
965   function changePrice(uint8 _stage, uint256 _price) public onlyOwner {
966     stages.changePrice(_stage, _price);
967     StagePriceChanged(msg.sender, _stage, _price);
968   }
969 
970   // Get stage is required to rethen the stage we are currently in
971   // This is necessary to check the stage details listed in the below functions
972   function getStage() public view returns (uint8 stage) {
973     return stages.getStage();
974   }
975 
976   function getStageDeadline(uint8 _stage) public view returns (uint256 deadline) { 
977     return stages.stages[_stage].deadline;
978   }
979 
980   function getStageTokensSold(uint8 _stage) public view returns (uint256 sold) { 
981     return stages.stages[_stage].tokensSold;
982   }
983 
984   function getStageCap(uint8 _stage) public view returns (uint256 cap) { 
985     return stages.stages[_stage].cap;
986   }
987 
988   function getStageMinimum(uint8 _stage) public view returns (uint256 min) { 
989     return stages.stages[_stage].minimumBuy;
990   }
991 
992   function getStagePrice(uint8 _stage) public view returns (uint256 price) { 
993     return stages.stages[_stage].tokenPrice;
994   }
995 
996   // This is used for extending the sales start time (and the deadlines of each stage) accordingly
997   function extendStart(uint256 _newStart) external onlyOwner {
998     require(_newStart > startTime);
999     require(_newStart > now); 
1000     require(now < startTime);
1001 
1002     uint256 difference = _newStart - startTime;
1003     uint256 oldStart = startTime;
1004     startTime = _newStart;
1005     endTime = endTime + difference;
1006 
1007     // Loop through every stage in the sale
1008     for (uint8 i = 0; i < 4; i++) {
1009       // Extend that stages deadline accordingly
1010       uint256 temp = stages.stages[i].deadline;
1011       temp = temp + difference;
1012 
1013       stages.changeDeadline(i, temp);
1014     }
1015 
1016     ExtendedStart(oldStart, _newStart);
1017   }
1018 
1019   // @Override crowdsale contract to check the current stage price
1020   // @return tokens investors are due to recieve
1021   function tokensToRecieve(uint256 _wei) internal view returns (uint256 tokens) {
1022     uint8 stage = getStage();
1023     uint256 price = getStagePrice(stage);
1024 
1025     return _wei.div(price);
1026   }
1027 
1028   // overriding Crowdsale validPurchase to add extra stage logic
1029   // @return true if investors can buy at the moment
1030   function validPurchase(uint256 _tokens) internal view returns (bool) {
1031     bool isValid = false;
1032     uint8 stage = getStage();
1033 
1034     if(stages.checkMinimum(stage, _tokens) && stages.checkCap(stage, _tokens)){
1035       isValid = true;
1036     }
1037 
1038     return super.validPurchase(_tokens) && isValid;
1039   }
1040 
1041   // Override crowdsale finalizeSale function to log balance change plus tokens sold in that stage
1042   function finalizeSale(uint256 _weiAmount, uint256 _tokens, uint128 _buyer) internal {
1043     // Collect ETH and send them a token in return
1044     balanceOf[msg.sender] = balanceOf[msg.sender].add(_weiAmount);
1045     tokenBalanceOf[msg.sender] = tokenBalanceOf[msg.sender].add(_tokens);
1046     balancePerID[_buyer] = balancePerID[_buyer].add(_weiAmount);
1047 
1048     // update state
1049     weiRaised = weiRaised.add(_weiAmount);
1050     tokensSent = tokensSent.add(_tokens);
1051 
1052     uint8 stage = getStage();
1053     stages.stages[stage].tokensSold = stages.stages[stage].tokensSold.add(_tokens);
1054   }
1055 
1056   /**
1057    * Preallocate tokens for the early investors.
1058    */
1059   function preallocate(address receiver, uint tokens, uint weiPrice) internal {
1060     uint decimals = token.decimals();
1061     uint tokenAmount = tokens * 10 ** decimals;
1062     uint weiAmount = weiPrice * tokens; 
1063 
1064     presaleWeiRaised = presaleWeiRaised.add(weiAmount);
1065     tokensSent = tokensSent.add(tokenAmount);
1066     tokenBalanceOf[receiver] = tokenBalanceOf[receiver].add(tokenAmount);
1067 
1068     presaleBalanceOf[receiver] = presaleBalanceOf[receiver].add(weiAmount);
1069 
1070     produceTokens(receiver, weiAmount, tokenAmount);
1071   }
1072 
1073   // If the sale is unsuccessful (has halted or reached deadline and didnt reach softcap)
1074   // Allows participants to withdraw their balance
1075   function unsuccessfulWithdrawal() external {
1076       require(balanceOf[msg.sender] > 0);
1077       require(hasEnded() && tokensSent < softCap || hasHalted());
1078       uint256 withdrawalAmount;
1079 
1080       withdrawalAmount = balanceOf[msg.sender];
1081       balanceOf[msg.sender] = 0; 
1082 
1083       msg.sender.transfer(withdrawalAmount);
1084       assert(balanceOf[msg.sender] == 0);
1085 
1086       ParticipantWithdrawal(msg.sender, withdrawalAmount, now);
1087   }
1088 
1089   // Burn the percentage of tokens not sold from the founders and bounty wallets
1090   // Must do it this way as solidity doesnt deal with decimals
1091   function burnFoundersTokens(uint256 _bounty, uint256 _founders) internal {
1092       require(_founders < 177777700000);
1093       require(_bounty < 44444500000);
1094 
1095       // Calculate the number of tokens to burn from founders and bounty wallet
1096       burntFounder = _founders;
1097       burntBounty = _bounty;
1098 
1099       token.reclaimAndBurn(founders, burntFounder);
1100       token.reclaimAndBurn(bounty, burntBounty);
1101   }
1102 }
1103 
1104 // File: contracts/KYCCrowdsale.sol
1105 
1106 /**
1107  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1108  *
1109  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1110  *
1111  * Some implementation has been changed by Pickeringware ltd to achieve custom features
1112  */
1113 
1114 
1115 
1116 /*
1117  * A crowdsale that allows only signed payload with server-side specified buy in limits.
1118  *
1119  * The token distribution happens as in the allocated crowdsale contract
1120  */
1121 contract KYCCrowdsale is KYCPayloadDeserializer, PickCrowdsale {
1122 
1123   /* Server holds the private key to this address to decide if the AML payload is valid or not. */
1124   address public signerAddress;
1125   mapping(address => uint256) public refundable;
1126   mapping(address => bool) public refunded;
1127   mapping(address => bool) public blacklist;
1128 
1129   /* A new server-side signer key was set to be effective */
1130   event SignerChanged(address signer);
1131   event TokensReclaimed(address user, uint256 amount, uint256 datetime);
1132   event AddedToBlacklist(address user, uint256 datetime);
1133   event RemovedFromBlacklist(address user, uint256 datetime);
1134   event RefundCollected(address user, uint256 datetime);
1135   event TokensReleased(address agent, uint256 datetime, uint256 bounty, uint256 founders);
1136 
1137   /*
1138    * Constructor.
1139    */
1140   function KYCCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _beneficiary, address _buyer, address _founders, address _bounty, uint256 _softCap, uint256 _hardCap, PickToken _token) public
1141   PickCrowdsale(_startTime, _endTime, _rate, _wallet, _beneficiary, _buyer, _founders, _bounty, _softCap, _hardCap, _token)
1142   {}
1143 
1144   // This sets the token agent to the contract, allowing the contract to reclaim and burn tokens if necessary
1145   function setTokenAgent() external onlyOwner {
1146     // contractAddr = token.owner();
1147     // Give the sale contract rights to reclaim tokens
1148     token.setReleaseAgent();
1149   }
1150 
1151  /* 
1152   * This function was written by Pickeringware ltd to facilitate a refund action upon failure of KYC analysis
1153   * 
1154   * It simply allows the participant to withdraw his ether from the sale
1155   * Moves the crowdsale sliders accordingly
1156   * Reclaims the users tokens and burns them
1157   * Blacklists the user to prevent them from buying any more tokens
1158   *
1159   * Stage 1, 2, 3, & 4 are all collected from the database prior to calling this function
1160   * It allows us to calculate how many tokens need to be taken from each individual stage
1161   */
1162   function refundParticipant(address participant, uint256 _stage1, uint256 _stage2, uint256 _stage3, uint256 _stage4) external onlyOwner {
1163     require(balanceOf[participant] > 0);
1164 
1165     uint256 balance = balanceOf[participant];
1166     uint256 tokens = tokenBalanceOf[participant];
1167 
1168     balanceOf[participant] = 0;
1169     tokenBalanceOf[participant] = 0;
1170 
1171     // Refund the participant
1172     refundable[participant] = balance;
1173 
1174     // Move the crowdsale sliders
1175     weiRaised = weiRaised.sub(balance);
1176     tokensSent = tokensSent.sub(tokens);
1177 
1178     // Reclaim the participants tokens and burn them
1179     token.reclaimAllAndBurn(participant);
1180 
1181     // Blacklist participant so they cannot make further purchases
1182     blacklist[participant] = true;
1183     AddedToBlacklist(participant, now);
1184 
1185     stages.refundParticipant(_stage1, _stage2, _stage3, _stage4);
1186 
1187     TokensReclaimed(participant, tokens, now);
1188   }
1189 
1190   // Allows only the beneficiary to release tokens to people
1191   // This is needed as the token is owned by the contract, in order to mint tokens
1192   // therefore, the owner essentially gives permission for the contract to release tokens
1193   function releaseTokens(uint256 _bounty, uint256 _founders) onlyOwner external {
1194       // Unless the hardcap was reached, theremust be tokens to burn
1195       require(_bounty > 0 || tokensSent == hardCap);
1196       require(_founders > 0 || tokensSent == hardCap);
1197 
1198       burnFoundersTokens(_bounty, _founders);
1199 
1200       token.releaseTokenTransfer();
1201 
1202       canWithdraw = true;
1203 
1204       TokensReleased(msg.sender, now, _bounty, _founders);
1205   }
1206   
1207   // overriding Crowdsale#validPurchase to add extra KYC blacklist logic
1208   // @return true if investors can buy at the moment
1209   function validPurchase(uint256 _tokens) internal view returns (bool) {
1210     bool onBlackList;
1211 
1212     if(blacklist[msg.sender] == true){
1213       onBlackList = true;
1214     } else {
1215       onBlackList = false;
1216     }
1217     return super.validPurchase(_tokens) && !onBlackList;
1218   }
1219 
1220   // This is necessary for the blacklisted user to pull his ether from the contract upon being refunded
1221   function collectRefund() external {
1222     require(refundable[msg.sender] > 0);
1223     require(refunded[msg.sender] == false);
1224 
1225     uint256 theirwei = refundable[msg.sender];
1226     refundable[msg.sender] = 0;
1227     refunded[msg.sender] == true;
1228 
1229     msg.sender.transfer(theirwei);
1230 
1231     RefundCollected(msg.sender, now);
1232   }
1233 
1234   /*
1235    * A token purchase with anti-money laundering and KYC checks
1236    * This function takes in a dataframe and EC signature to verify if the purchaser has been verified
1237    * on the server side of our application and has therefore, participated in KYC. 
1238    * Upon registering to the site, users are supplied with a signature allowing them to purchase tokens, 
1239    * which can be revoked at any time, this containst their ETH address, a unique ID and the min and max 
1240    * ETH that user has stated they will purchase. (Any more than the max may be subject to AML checks).
1241    */
1242   function buyWithKYCData(bytes dataframe, uint8 v, bytes32 r, bytes32 s) public payable {
1243 
1244       bytes32 hash = sha256(dataframe);
1245 
1246       address whitelistedAddress;
1247       uint128 customerId;
1248       uint32 minETH;
1249       uint32 maxETH;
1250       
1251       (whitelistedAddress, customerId, minETH, maxETH) = getKYCPayload(dataframe);
1252 
1253       // Check that the KYC data is signed by our server
1254       require(ecrecover(hash, v, r, s) == signerAddress);
1255 
1256       // Check that the user is using his own signature
1257       require(whitelistedAddress == msg.sender);
1258 
1259       // Check they are buying within their limits - THIS IS ONLY NEEDED IF SPECIFIED BY REGULATORS
1260       uint256 weiAmount = msg.value;
1261       uint256 max = maxETH;
1262       uint256 min = minETH;
1263 
1264       require(weiAmount < (max * 1 ether));
1265       require(weiAmount > (min * 1 ether));
1266 
1267       buyTokens(customerId);
1268   }  
1269 
1270   /// @dev This function can set the server side address
1271   /// @param _signerAddress The address derived from server's private key
1272   function setSignerAddress(address _signerAddress) external onlyOwner {
1273     // EC rcover returns 0 in case of error therefore, this CANNOT be 0.
1274     require(_signerAddress != 0);
1275     signerAddress = _signerAddress;
1276     SignerChanged(signerAddress);
1277   }
1278 
1279   function removeFromBlacklist(address _blacklisted) external onlyOwner {
1280     require(blacklist[_blacklisted] == true);
1281     blacklist[_blacklisted] = false;
1282     RemovedFromBlacklist(_blacklisted, now);
1283   }
1284 
1285 }