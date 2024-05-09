1 pragma solidity 0.4.20;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
49 // ----------------------------------------------------------------------------
50 contract ERC20Interface {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     function allowance(address owner, address spender) public view returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57 
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Burn(address indexed burner, uint256 value);
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // VIOLET ERC20 Standard Token
66 // ----------------------------------------------------------------------------
67 contract VLTToken is ERC20Interface {
68     using SafeMath for uint256;
69 
70     address public owner = msg.sender;
71 
72     bytes32 public symbol;
73     bytes32 public name;
74     uint8 public decimals;
75     uint256 public _totalSupply;
76 
77     mapping(address => uint256) internal balances;
78     mapping(address => mapping (address => uint256)) internal allowed;
79 
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     // ------------------------------------------------------------------------
86     // Constructor
87     // ------------------------------------------------------------------------
88     function VLTToken() public {
89         symbol = "VAI";
90         name = "VIOLET";
91         decimals = 18;
92         _totalSupply = 250000000 * 10**uint256(decimals);
93         balances[owner] = _totalSupply;
94         Transfer(address(0), owner, _totalSupply);
95     }
96 
97 
98     /**
99     * @dev total number of tokens in existence
100     */
101     function totalSupply() public view returns (uint256) {
102         return _totalSupply;
103     }
104 
105     /**
106     * @dev Gets the balance of the specified address.
107     * @param _owner The address to query the the balance of.
108     * @return An uint256 representing the amount owned by the passed address.
109     */
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114     /**
115     * @dev transfer token for a specified address
116     * @param _to The address to transfer to.
117     * @param _value The amount to be transferred.
118     */
119     function transfer(address _to, uint256 _value) public returns (bool) {
120         // allow sending 0 tokens
121         if (_value == 0) {
122             Transfer(msg.sender, _to, _value);    // Follow the spec to louch the event when transfer 0
123             return;
124         }
125         
126         require(_to != address(0));
127         require(_value <= balances[msg.sender]);
128 
129         // SafeMath.sub will throw if there is not enough balance.
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138     *
139     * Beware that changing an allowance with this method brings the risk that someone may use both the old
140     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143     * @param _spender The address which will spend the funds.
144     * @param _value The amount of tokens to be spent.
145     */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153     * @dev Transfer tokens from one address to another
154     * @param _from address The address which you want to send tokens from
155     * @param _to address The address which you want to transfer to
156     * @param _value uint256 the amount of tokens to be transferred
157     */
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159         // allow sending 0 tokens
160         if (_value == 0) {
161             Transfer(_from, _to, _value);    // Follow the spec to louch the event when transfer 0
162             return;
163         }
164 
165         require(_to != address(0));
166         require(_value <= balances[_from]);
167         require(_value <= allowed[_from][msg.sender]);
168 
169         balances[_from] = balances[_from].sub(_value);
170         balances[_to] = balances[_to].add(_value);
171         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172         Transfer(_from, _to, _value);
173         return true;
174     }
175 
176 
177     /**
178     * @dev Function to check the amount of tokens that an owner allowed to a spender.
179     * @param _owner address The address which owns the funds.
180     * @param _spender address The address which will spend the funds.
181     * @return A uint256 specifying the amount of tokens still available for the spender.
182     */
183     function allowance(address _owner, address _spender) public view returns (uint256) {
184         return allowed[_owner][_spender];
185     }
186 
187 
188     /**
189     * @dev Increase the amount of tokens that an owner allowed to a spender.
190     *
191     * approve should be called when allowed[_spender] == 0. To increment
192     * allowed value is better to use this function to avoid 2 calls (and wait until
193     * the first transaction is mined)
194     * From MonolithDAO Token.sol
195     * @param _spender The address which will spend the funds.
196     * @param _addedValue The amount of tokens to increase the allowance by.
197     */
198     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 
204     /**
205     * @dev Decrease the amount of tokens that an owner allowed to a spender.
206     *
207     * approve should be called when allowed[_spender] == 0. To decrement
208     * allowed value is better to use this function to avoid 2 calls (and wait until
209     * the first transaction is mined)
210     * From MonolithDAO Token.sol
211     * @param _spender The address which will spend the funds.
212     * @param _subtractedValue The amount of tokens to decrease the allowance by.
213     */
214     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215         uint oldValue = allowed[msg.sender][_spender];
216         if (_subtractedValue > oldValue) {
217         allowed[msg.sender][_spender] = 0;
218         } else {
219         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220         }
221         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225     /**
226     * @dev Burns a specific amount of tokens.
227     * @param _value The amount of token to be burned.
228     */
229     function burn(uint256 _value) public {
230         require(_value <= balances[msg.sender]);
231         // no need to require value <= totalSupply, since that would imply the
232         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
233 
234         address burner = msg.sender;
235         balances[burner] = balances[burner].sub(_value);
236         _totalSupply = _totalSupply.sub(_value);
237         Burn(burner, _value);
238         Transfer(burner, address(0), _value);
239     }
240 
241     /**
242      * Destroy tokens from other account
243      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
244      * @param _from the address of the sender
245      * @param _value the amount of money to burn
246      */
247     function burnFrom(address _from, uint256 _value) public returns (bool) {
248         require(_value <= balances[_from]);               // Check if the targeted balance is enough
249         require(_value <= allowed[_from][msg.sender]);    // Check allowed allowance
250         balances[_from] = balances[_from].sub(_value);  // Subtract from the targeted balance
251         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
252         _totalSupply = _totalSupply.sub(_value);                              // Update totalSupply
253         Burn(_from, _value);
254         Transfer(_from, address(0), _value);
255         return true;
256     } 
257 
258     // ------------------------------------------------------------------------
259     // Owner can transfer out any accidentally sent ERC20 tokens
260     // ------------------------------------------------------------------------
261     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
262         return ERC20Interface(tokenAddress).transfer(owner, tokens);
263     }
264 }
265 
266 contract ERC20Basic {
267   uint256 public totalSupply;
268   function balanceOf(address who) public view returns (uint256);
269   function transfer(address to, uint256 value) public returns (bool);
270   event Transfer(address indexed from, address indexed to, uint256 value);
271 }
272 
273 contract ERC20 is ERC20Basic {
274   function allowance(address owner, address spender) public view returns (uint256);
275   function transferFrom(address from, address to, uint256 value) public returns (bool);
276   function approve(address spender, uint256 value) public returns (bool);
277   event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 contract Ownable {
281   address public owner;
282 
283 
284   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286 
287   /**
288    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289    * account.
290    */
291   function Ownable() public {
292     owner = msg.sender;
293   }
294 
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(msg.sender == owner);
301     _;
302   }
303 
304 
305   /**
306    * @dev Allows the current owner to transfer control of the contract to a newOwner.
307    * @param newOwner The address to transfer ownership to.
308    */
309   function transferOwnership(address newOwner) public onlyOwner {
310     require(newOwner != address(0));
311     OwnershipTransferred(owner, newOwner);
312     owner = newOwner;
313   }
314 
315 }
316 
317 
318 
319 /**
320  * @title ViolaCrowdsale
321  * @dev ViolaCrowdsale reserves token from supply when eth is received
322  * funds will be forwarded after the end of crowdsale. Tokens will be claimable
323  * within 7 days after crowdsale ends.
324  */
325  
326 contract ViolaCrowdsale is Ownable {
327   using SafeMath for uint256;
328 
329   enum State { Deployed, PendingStart, Active, Paused, Ended, Completed }
330 
331   //Status of contract
332   State public status = State.Deployed;
333 
334   // The token being sold
335   VLTToken public violaToken;
336 
337   //For keeping track of whitelist address. cap >0 = whitelisted
338   mapping(address=>uint) public maxBuyCap;
339 
340   //For checking if address passed KYC
341   mapping(address => bool)public addressKYC;
342 
343   //Total wei sum an address has invested
344   mapping(address=>uint) public investedSum;
345 
346   //Total violaToken an address is allocated
347   mapping(address=>uint) public tokensAllocated;
348 
349     //Total violaToken an address purchased externally is allocated
350   mapping(address=>uint) public externalTokensAllocated;
351 
352   //Total bonus violaToken an address is entitled after vesting
353   mapping(address=>uint) public bonusTokensAllocated;
354 
355   //Total bonus violaToken an address purchased externally is entitled after vesting
356   mapping(address=>uint) public externalBonusTokensAllocated;
357 
358   //Store addresses that has registered for crowdsale before (pushed via setWhitelist)
359   //Does not mean whitelisted as it can be revoked. Just to track address for loop
360   address[] public registeredAddress;
361 
362   //Total amount not approved for withdrawal
363   uint256 public totalApprovedAmount = 0;
364 
365   //Start and end timestamps where investments are allowed (both inclusive)
366   uint256 public startTime;
367   uint256 public endTime;
368   uint256 public bonusVestingPeriod = 60 days;
369 
370 
371   /**
372    * Note all values are calculated in wei(uint256) including token amount
373    * 1 ether = 1000000000000000000 wei
374    * 1 viola = 1000000000000000000 vi lawei
375    */
376 
377 
378   //Address where funds are collected
379   address public wallet;
380 
381   //Min amount investor can purchase
382   uint256 public minWeiToPurchase;
383 
384   // how many token units *in wei* a buyer gets *per wei*
385   uint256 public rate;
386 
387   //Extra bonus token to give *in percentage*
388   uint public bonusTokenRateLevelOne = 20;
389   uint public bonusTokenRateLevelTwo = 15;
390   uint public bonusTokenRateLevelThree = 10;
391   uint public bonusTokenRateLevelFour = 0;
392 
393   //Total amount of tokens allocated for crowdsale
394   uint256 public totalTokensAllocated;
395 
396   //Total amount of tokens reserved from external sources
397   //Sub set of totalTokensAllocated ( totalTokensAllocated - totalReservedTokenAllocated = total tokens allocated for purchases using ether )
398   uint256 public totalReservedTokenAllocated;
399 
400   //Numbers of token left above 0 to still be considered sold
401   uint256 public leftoverTokensBuffer;
402 
403   /**
404    * event for front end logging
405    */
406 
407   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount, uint256 bonusAmount);
408   event ExternalTokenPurchase(address indexed purchaser, uint256 amount, uint256 bonusAmount);
409   event ExternalPurchaseRefunded(address indexed purchaser, uint256 amount, uint256 bonusAmount);
410   event TokenDistributed(address indexed tokenReceiver, uint256 tokenAmount);
411   event BonusTokenDistributed(address indexed tokenReceiver, uint256 tokenAmount);
412   event TopupTokenAllocated(address indexed tokenReceiver, uint256 amount, uint256 bonusAmount);
413   event CrowdsalePending();
414   event CrowdsaleStarted();
415   event CrowdsaleEnded();
416   event BonusRateChanged();
417   event Refunded(address indexed beneficiary, uint256 weiAmount);
418 
419   //Set inital arguments of the crowdsale
420   function initialiseCrowdsale (uint256 _startTime, uint256 _rate, address _tokenAddress, address _wallet) onlyOwner external {
421     require(status == State.Deployed);
422     require(_startTime >= now);
423     require(_rate > 0);
424     require(address(_tokenAddress) != address(0));
425     require(_wallet != address(0));
426 
427     startTime = _startTime;
428     endTime = _startTime + 30 days;
429     rate = _rate;
430     wallet = _wallet;
431     violaToken = VLTToken(_tokenAddress);
432 
433     status = State.PendingStart;
434 
435     CrowdsalePending();
436 
437   }
438 
439   /**
440    * Crowdsale state functions
441    * To track state of current crowdsale
442    */
443 
444 
445   // To be called by Ethereum alarm clock or anyone
446   //Can only be called successfully when time is valid
447   function startCrowdsale() external {
448     require(withinPeriod());
449     require(violaToken != address(0));
450     require(getTokensLeft() > 0);
451     require(status == State.PendingStart);
452 
453     status = State.Active;
454 
455     CrowdsaleStarted();
456   }
457 
458   //To be called by owner or contract
459   //Ends the crowdsale when tokens are sold out
460   function endCrowdsale() public {
461     if (!tokensHasSoldOut()) {
462       require(msg.sender == owner);
463     }
464     require(status == State.Active);
465 
466     bonusVestingPeriod = now + 60 days;
467 
468     status = State.Ended;
469 
470     CrowdsaleEnded();
471   }
472   //Emergency pause
473   function pauseCrowdsale() onlyOwner external {
474     require(status == State.Active);
475 
476     status = State.Paused;
477   }
478   //Resume paused crowdsale
479   function unpauseCrowdsale() onlyOwner external {
480     require(status == State.Paused);
481 
482     status = State.Active;
483   }
484 
485   function completeCrowdsale() onlyOwner external {
486     require(hasEnded());
487     require(violaToken.allowance(owner, this) == 0);
488     status = State.Completed;
489 
490     _forwardFunds();
491 
492     assert(this.balance == 0);
493   }
494 
495   function burnExtraTokens() onlyOwner external {
496     require(hasEnded());
497     uint256 extraTokensToBurn = violaToken.allowance(owner, this);
498     violaToken.burnFrom(owner, extraTokensToBurn);
499     assert(violaToken.allowance(owner, this) == 0);
500   }
501 
502   // send ether to the fund collection wallet
503   function _forwardFunds() internal {
504     wallet.transfer(this.balance);
505   }
506 
507   function partialForwardFunds(uint _amountToTransfer) onlyOwner external {
508     require(status == State.Ended);
509     require(_amountToTransfer < totalApprovedAmount);
510     totalApprovedAmount = totalApprovedAmount.sub(_amountToTransfer);
511     
512     wallet.transfer(_amountToTransfer);
513   }
514 
515   /**
516    * Setter functions for crowdsale parameters
517    * Only owner can set values
518    */
519 
520 
521   function setLeftoverTokensBuffer(uint256 _tokenBuffer) onlyOwner external {
522     require(_tokenBuffer > 0);
523     require(getTokensLeft() >= _tokenBuffer);
524     leftoverTokensBuffer = _tokenBuffer;
525   }
526 
527   //Set the ether to token rate
528   function setRate(uint _rate) onlyOwner external {
529     require(_rate > 0);
530     rate = _rate;
531   }
532 
533   function setBonusTokenRateLevelOne(uint _rate) onlyOwner external {
534     //require(_rate > 0);
535     bonusTokenRateLevelOne = _rate;
536     BonusRateChanged();
537   }
538 
539   function setBonusTokenRateLevelTwo(uint _rate) onlyOwner external {
540     //require(_rate > 0);
541     bonusTokenRateLevelTwo = _rate;
542     BonusRateChanged();
543   }
544 
545   function setBonusTokenRateLevelThree(uint _rate) onlyOwner external {
546     //require(_rate > 0);
547     bonusTokenRateLevelThree = _rate;
548     BonusRateChanged();
549   }
550   function setBonusTokenRateLevelFour(uint _rate) onlyOwner external {
551     //require(_rate > 0);
552     bonusTokenRateLevelFour = _rate;
553     BonusRateChanged();
554   }
555 
556   function setMinWeiToPurchase(uint _minWeiToPurchase) onlyOwner external {
557     minWeiToPurchase = _minWeiToPurchase;
558   }
559 
560 
561   /**
562    * Whitelisting and KYC functions
563    * Whitelisted address can buy tokens, KYC successful purchaser can claim token. Refund if fail KYC
564    */
565 
566 
567   //Set the amount of wei an address can purchase up to
568   //@dev Value of 0 = not whitelisted
569   //@dev cap is in *18 decimals* ( 1 token = 1*10^18)
570   
571   function setWhitelistAddress( address _investor, uint _cap ) onlyOwner external {
572         require(_cap > 0);
573         require(_investor != address(0));
574         maxBuyCap[_investor] = _cap;
575         registeredAddress.push(_investor);
576         //add event
577     }
578 
579   //Remove the address from whitelist
580   function removeWhitelistAddress(address _investor) onlyOwner external {
581     require(_investor != address(0));
582     
583     maxBuyCap[_investor] = 0;
584     uint256 weiAmount = investedSum[_investor];
585 
586     if (weiAmount > 0) {
587       _refund(_investor);
588     }
589   }
590 
591   //Flag address as KYC approved. Address is now approved to claim tokens
592   function approveKYC(address _kycAddress) onlyOwner external {
593     require(_kycAddress != address(0));
594     addressKYC[_kycAddress] = true;
595 
596     uint256 weiAmount = investedSum[_kycAddress];
597     totalApprovedAmount = totalApprovedAmount.add(weiAmount);
598   }
599 
600   //Set KYC status as failed. Refund any eth back to address
601   function revokeKYC(address _kycAddress) onlyOwner external {
602     require(_kycAddress != address(0));
603     addressKYC[_kycAddress] = false;
604 
605     uint256 weiAmount = investedSum[_kycAddress];
606     totalApprovedAmount = totalApprovedAmount.sub(weiAmount);
607 
608     if (weiAmount > 0) {
609       _refund(_kycAddress);
610     }
611   }
612 
613   /**
614    * Getter functions for crowdsale parameters
615    * Does not use gas
616    */
617 
618   //Checks if token has been sold out
619     function tokensHasSoldOut() view internal returns (bool) {
620       if (getTokensLeft() <= leftoverTokensBuffer) {
621         return true;
622       } else {
623         return false;
624       }
625     }
626 
627       // @return true if the transaction can buy tokens
628   function withinPeriod() public view returns (bool) {
629     return now >= startTime && now <= endTime;
630   }
631 
632   // @return true if crowdsale event has ended
633   function hasEnded() public view returns (bool) {
634     if (status == State.Ended) {
635       return true;
636     }
637     return now > endTime;
638   }
639 
640   function getTokensLeft() public view returns (uint) {
641     return violaToken.allowance(owner, this).sub(totalTokensAllocated);
642   }
643 
644   function transferTokens (address receiver, uint tokenAmount) internal {
645      require(violaToken.transferFrom(owner, receiver, tokenAmount));
646   }
647 
648   function getTimeBasedBonusRate() public view returns(uint) {
649     bool bonusDuration1 = now >= startTime && now <= (startTime + 1 days);  //First 24hr
650     bool bonusDuration2 = now > (startTime + 1 days) && now <= (startTime + 3 days);//Next 48 hr
651     bool bonusDuration3 = now > (startTime + 3 days) && now <= (startTime + 10 days);//4th to 10th day
652     bool bonusDuration4 = now > (startTime + 10 days) && now <= endTime;//11th day onwards
653     if (bonusDuration1) {
654       return bonusTokenRateLevelOne;
655     } else if (bonusDuration2) {
656       return bonusTokenRateLevelTwo;
657     } else if (bonusDuration3) {
658       return bonusTokenRateLevelThree;
659     } else if (bonusDuration4) {
660       return bonusTokenRateLevelFour;
661     } else {
662       return 0;
663     }
664   }
665 
666   function getTotalTokensByAddress(address _investor) public view returns(uint) {
667     return getTotalNormalTokensByAddress(_investor).add(getTotalBonusTokensByAddress(_investor));
668   }
669 
670   function getTotalNormalTokensByAddress(address _investor) public view returns(uint) {
671     return tokensAllocated[_investor].add(externalTokensAllocated[_investor]);
672   }
673 
674   function getTotalBonusTokensByAddress(address _investor) public view returns(uint) {
675     return bonusTokensAllocated[_investor].add(externalBonusTokensAllocated[_investor]);
676   }
677 
678   function _clearTotalNormalTokensByAddress(address _investor) internal {
679     tokensAllocated[_investor] = 0;
680     externalTokensAllocated[_investor] = 0;
681   }
682 
683   function _clearTotalBonusTokensByAddress(address _investor) internal {
684     bonusTokensAllocated[_investor] = 0;
685     externalBonusTokensAllocated[_investor] = 0;
686   }
687 
688 
689   /**
690    * Functions to handle buy tokens
691    * Fallback function as entry point for eth
692    */
693 
694 
695   // Called when ether is sent to contract
696   function () external payable {
697     buyTokens(msg.sender);
698   }
699 
700   //Used to buy tokens
701   function buyTokens(address investor) internal {
702     require(status == State.Active);
703     require(msg.value >= minWeiToPurchase);
704 
705     uint weiAmount = msg.value;
706 
707     checkCapAndRecord(investor,weiAmount);
708 
709     allocateToken(investor,weiAmount);
710     
711   }
712 
713   //Internal call to check max user cap
714   function checkCapAndRecord(address investor, uint weiAmount) internal {
715       uint remaindingCap = maxBuyCap[investor];
716       require(remaindingCap >= weiAmount);
717       maxBuyCap[investor] = remaindingCap.sub(weiAmount);
718       investedSum[investor] = investedSum[investor].add(weiAmount);
719   }
720 
721   //Internal call to allocated tokens purchased
722     function allocateToken(address investor, uint weiAmount) internal {
723         // calculate token amount to be created
724         uint tokens = weiAmount.mul(rate);
725         uint bonusTokens = tokens.mul(getTimeBasedBonusRate()).div(100);
726         
727         uint tokensToAllocate = tokens.add(bonusTokens);
728         
729         require(getTokensLeft() >= tokensToAllocate);
730         totalTokensAllocated = totalTokensAllocated.add(tokensToAllocate);
731 
732         tokensAllocated[investor] = tokensAllocated[investor].add(tokens);
733         bonusTokensAllocated[investor] = bonusTokensAllocated[investor].add(bonusTokens);
734 
735         if (tokensHasSoldOut()) {
736           endCrowdsale();
737         }
738         TokenPurchase(investor, weiAmount, tokens, bonusTokens);
739   }
740 
741 
742 
743   /**
744    * Functions for refunds & claim tokens
745    * 
746    */
747 
748 
749 
750   //Refund users in case of unsuccessful crowdsale
751   function _refund(address _investor) internal {
752     uint256 investedAmt = investedSum[_investor];
753     require(investedAmt > 0);
754 
755   
756       uint totalInvestorTokens = tokensAllocated[_investor].add(bonusTokensAllocated[_investor]);
757 
758     if (status == State.Active) {
759       //Refunded tokens go back to sale pool
760       totalTokensAllocated = totalTokensAllocated.sub(totalInvestorTokens);
761     }
762 
763     _clearAddressFromCrowdsale(_investor);
764 
765     _investor.transfer(investedAmt);
766 
767     Refunded(_investor, investedAmt);
768   }
769 
770     //Partial refund users
771   function refundPartial(address _investor, uint _refundAmt, uint _tokenAmt, uint _bonusTokenAmt) onlyOwner external {
772 
773     uint investedAmt = investedSum[_investor];
774     require(investedAmt > _refundAmt);
775     require(tokensAllocated[_investor] > _tokenAmt);
776     require(bonusTokensAllocated[_investor] > _bonusTokenAmt);
777 
778     investedSum[_investor] = investedSum[_investor].sub(_refundAmt);
779     tokensAllocated[_investor] = tokensAllocated[_investor].sub(_tokenAmt);
780     bonusTokensAllocated[_investor] = bonusTokensAllocated[_investor].sub(_bonusTokenAmt);
781 
782 
783     uint totalRefundTokens = _tokenAmt.add(_bonusTokenAmt);
784 
785     if (status == State.Active) {
786       //Refunded tokens go back to sale pool
787       totalTokensAllocated = totalTokensAllocated.sub(totalRefundTokens);
788     }
789 
790     _investor.transfer(_refundAmt);
791 
792     Refunded(_investor, _refundAmt);
793   }
794 
795   //Used by investor to claim token
796     function claimTokens() external {
797       require(hasEnded());
798       require(addressKYC[msg.sender]);
799       address tokenReceiver = msg.sender;
800       uint tokensToClaim = getTotalNormalTokensByAddress(tokenReceiver);
801 
802       require(tokensToClaim > 0);
803       _clearTotalNormalTokensByAddress(tokenReceiver);
804 
805       violaToken.transferFrom(owner, tokenReceiver, tokensToClaim);
806 
807       TokenDistributed(tokenReceiver, tokensToClaim);
808 
809     }
810 
811     //Used by investor to claim bonus token
812     function claimBonusTokens() external {
813       require(hasEnded());
814       require(now >= bonusVestingPeriod);
815       require(addressKYC[msg.sender]);
816 
817       address tokenReceiver = msg.sender;
818       uint tokensToClaim = getTotalBonusTokensByAddress(tokenReceiver);
819 
820       require(tokensToClaim > 0);
821       _clearTotalBonusTokensByAddress(tokenReceiver);
822 
823       violaToken.transferFrom(owner, tokenReceiver, tokensToClaim);
824 
825       BonusTokenDistributed(tokenReceiver, tokensToClaim);
826     }
827 
828     //Used by owner to distribute bonus token
829     function distributeBonusTokens(address _tokenReceiver) onlyOwner external {
830       require(hasEnded());
831       require(now >= bonusVestingPeriod);
832 
833       address tokenReceiver = _tokenReceiver;
834       uint tokensToClaim = getTotalBonusTokensByAddress(tokenReceiver);
835 
836       require(tokensToClaim > 0);
837       _clearTotalBonusTokensByAddress(tokenReceiver);
838 
839       transferTokens(tokenReceiver, tokensToClaim);
840 
841       BonusTokenDistributed(tokenReceiver,tokensToClaim);
842 
843     }
844 
845     //Used by owner to distribute token
846     function distributeICOTokens(address _tokenReceiver) onlyOwner external {
847       require(hasEnded());
848 
849       address tokenReceiver = _tokenReceiver;
850       uint tokensToClaim = getTotalNormalTokensByAddress(tokenReceiver);
851 
852       require(tokensToClaim > 0);
853       _clearTotalNormalTokensByAddress(tokenReceiver);
854 
855       transferTokens(tokenReceiver, tokensToClaim);
856 
857       TokenDistributed(tokenReceiver,tokensToClaim);
858 
859     }
860 
861     //For owner to reserve token for presale
862     // function reserveTokens(uint _amount) onlyOwner external {
863 
864     //   require(getTokensLeft() >= _amount);
865     //   totalTokensAllocated = totalTokensAllocated.add(_amount);
866     //   totalReservedTokenAllocated = totalReservedTokenAllocated.add(_amount);
867 
868     // }
869 
870     // //To distribute tokens not allocated by crowdsale contract
871     // function distributePresaleTokens(address _tokenReceiver, uint _amount) onlyOwner external {
872     //   require(hasEnded());
873     //   require(_tokenReceiver != address(0));
874     //   require(_amount > 0);
875 
876     //   violaToken.transferFrom(owner, _tokenReceiver, _amount);
877 
878     //   TokenDistributed(_tokenReceiver,_amount);
879 
880     // }
881 
882     //For external purchases & pre-sale via btc/fiat
883     function externalPurchaseTokens(address _investor, uint _amount, uint _bonusAmount) onlyOwner external {
884       require(_amount > 0);
885       uint256 totalTokensToAllocate = _amount.add(_bonusAmount);
886 
887       require(getTokensLeft() >= totalTokensToAllocate);
888       totalTokensAllocated = totalTokensAllocated.add(totalTokensToAllocate);
889       totalReservedTokenAllocated = totalReservedTokenAllocated.add(totalTokensToAllocate);
890 
891       externalTokensAllocated[_investor] = externalTokensAllocated[_investor].add(_amount);
892       externalBonusTokensAllocated[_investor] = externalBonusTokensAllocated[_investor].add(_bonusAmount);
893       
894       ExternalTokenPurchase(_investor,  _amount, _bonusAmount);
895 
896     }
897 
898     function refundAllExternalPurchase(address _investor) onlyOwner external {
899       require(_investor != address(0));
900       require(externalTokensAllocated[_investor] > 0);
901 
902       uint externalTokens = externalTokensAllocated[_investor];
903       uint externalBonusTokens = externalBonusTokensAllocated[_investor];
904 
905       externalTokensAllocated[_investor] = 0;
906       externalBonusTokensAllocated[_investor] = 0;
907 
908       uint totalInvestorTokens = externalTokens.add(externalBonusTokens);
909 
910       totalReservedTokenAllocated = totalReservedTokenAllocated.sub(totalInvestorTokens);
911       totalTokensAllocated = totalTokensAllocated.sub(totalInvestorTokens);
912 
913       ExternalPurchaseRefunded(_investor,externalTokens,externalBonusTokens);
914     }
915 
916     function refundExternalPurchase(address _investor, uint _amountToRefund, uint _bonusAmountToRefund) onlyOwner external {
917       require(_investor != address(0));
918       require(externalTokensAllocated[_investor] >= _amountToRefund);
919       require(externalBonusTokensAllocated[_investor] >= _bonusAmountToRefund);
920 
921       uint totalTokensToRefund = _amountToRefund.add(_bonusAmountToRefund);
922       externalTokensAllocated[_investor] = externalTokensAllocated[_investor].sub(_amountToRefund);
923       externalBonusTokensAllocated[_investor] = externalBonusTokensAllocated[_investor].sub(_bonusAmountToRefund);
924 
925       totalReservedTokenAllocated = totalReservedTokenAllocated.sub(totalTokensToRefund);
926       totalTokensAllocated = totalTokensAllocated.sub(totalTokensToRefund);
927 
928       ExternalPurchaseRefunded(_investor,_amountToRefund,_bonusAmountToRefund);
929     }
930 
931     function _clearAddressFromCrowdsale(address _investor) internal {
932       tokensAllocated[_investor] = 0;
933       bonusTokensAllocated[_investor] = 0;
934       investedSum[_investor] = 0;
935       maxBuyCap[_investor] = 0;
936     }
937 
938     function allocateTopupToken(address _investor, uint _amount, uint _bonusAmount) onlyOwner external {
939       require(hasEnded());
940       require(_amount > 0);
941       uint256 tokensToAllocate = _amount.add(_bonusAmount);
942 
943       require(getTokensLeft() >= tokensToAllocate);
944       totalTokensAllocated = totalTokensAllocated.add(_amount);
945 
946       tokensAllocated[_investor] = tokensAllocated[_investor].add(_amount);
947       bonusTokensAllocated[_investor] = bonusTokensAllocated[_investor].add(_bonusAmount);
948 
949       TopupTokenAllocated(_investor,  _amount, _bonusAmount);
950     }
951 
952   //For cases where token are mistakenly sent / airdrops
953   function emergencyERC20Drain( ERC20 token, uint amount ) external onlyOwner {
954     require(status == State.Completed);
955     token.transfer(owner,amount);
956   }
957 
958 }