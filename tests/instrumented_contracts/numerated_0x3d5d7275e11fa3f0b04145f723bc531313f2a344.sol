1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
85     // benefit is lost if 'b' is also tested.
86     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87     if (a == 0) {
88       return 0;
89     }
90 
91     c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return a / b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   uint256 totalSupply_;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender)
174     public view returns (uint256);
175 
176   function transferFrom(address from, address to, uint256 value)
177     public returns (bool);
178 
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(
181     address indexed owner,
182     address indexed spender,
183     uint256 value
184   );
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title DetailedERC20 token
311  * @dev The decimals are only for visualization purposes.
312  * All the operations are done using the smallest and indivisible token unit,
313  * just as on Ethereum all the operations are done in wei.
314  */
315 contract DetailedERC20 is ERC20 {
316   string public name;
317   string public symbol;
318   uint8 public decimals;
319 
320   constructor(string _name, string _symbol, uint8 _decimals) public {
321     name = _name;
322     symbol = _symbol;
323     decimals = _decimals;
324   }
325 }
326 
327 /**
328  * @title Math
329  * @dev Assorted math operations
330  */
331 library Math {
332   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
333     return a >= b ? a : b;
334   }
335 
336   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
337     return a < b ? a : b;
338   }
339 
340   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
341     return a >= b ? a : b;
342   }
343 
344   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
345     return a < b ? a : b;
346   }
347 }
348 
349 /**
350 * @title TuurntToken 
351 * @dev The TuurntToken contract contains the information about 
352 * Tuurnt token.
353 */
354 
355 
356 
357 
358 
359 contract TuurntToken is StandardToken, DetailedERC20 {
360 
361     using SafeMath for uint256;
362 
363     // distribution variables
364     uint256 public tokenAllocToTeam;
365     uint256 public tokenAllocToCrowdsale;
366     uint256 public tokenAllocToCompany;
367 
368     // addresses
369     address public crowdsaleAddress;
370     address public teamAddress;
371     address public companyAddress;
372     
373 
374     /**
375     * @dev The TuurntToken constructor set the orginal crowdsaleAddress,teamAddress and companyAddress and allocate the
376     * tokens to them.
377     * @param _crowdsaleAddress The address of crowsale contract
378     * @param _teamAddress The address of team
379     * @param _companyAddress The address of company 
380     */
381 
382     constructor(address _crowdsaleAddress, address _teamAddress, address _companyAddress, string _name, string _symbol, uint8 _decimals) public 
383         DetailedERC20(_name, _symbol, _decimals)
384     {
385         require(_crowdsaleAddress != address(0));
386         require(_teamAddress != address(0));
387         require(_companyAddress != address(0));
388         totalSupply_ = 500000000 * 10 ** 18;
389         tokenAllocToTeam = (totalSupply_.mul(33)).div(100);     // 33 % Allocation
390         tokenAllocToCompany = (totalSupply_.mul(33)).div(100);  // 33 % Allocation 
391         tokenAllocToCrowdsale = (totalSupply_.mul(34)).div(100);// 34 % Allocation
392 
393         // Address      
394         crowdsaleAddress = _crowdsaleAddress;
395         teamAddress = _teamAddress;
396         companyAddress = _companyAddress;
397         
398 
399         // Allocations
400         balances[crowdsaleAddress] = tokenAllocToCrowdsale;
401         balances[companyAddress] = tokenAllocToCompany;
402         balances[teamAddress] = tokenAllocToTeam; 
403        
404         //transfer event
405         emit Transfer(address(0), crowdsaleAddress, tokenAllocToCrowdsale);
406         emit Transfer(address(0), companyAddress, tokenAllocToCompany);
407         emit Transfer(address(0), teamAddress, tokenAllocToTeam);
408        
409         
410     }  
411 }
412 
413 contract WhitelistInterface {
414     function checkWhitelist(address _whiteListAddress) public view returns(bool);
415 }
416 
417 /**
418 * @title TuurntCrowdsale
419 * @dev The Crowdsale contract holds the token for the public sale of token and 
420 * contains the function to buy token.  
421 */
422 
423 
424 
425 
426 
427 
428 contract TuurntCrowdsale is Ownable {
429 
430     using SafeMath for uint256;
431 
432     TuurntToken public token;
433     WhitelistInterface public whitelist;
434 
435     //variable declaration
436     uint256 public MIN_INVESTMENT = 0.2 ether;
437     uint256 public ethRaised;
438     uint256 public ethRate = 524;
439     uint256 public startCrowdsalePhase1Date;
440     uint256 public endCrowdsalePhase1Date;
441     uint256 public startCrowdsalePhase2Date;
442     uint256 public endCrowdsalePhase2Date;
443     uint256 public startCrowdsalePhase3Date;
444     uint256 public endCrowdsalePhase3Date;
445     uint256 public startPresaleDate;
446     uint256 public endPresaleDate;
447     uint256 public startPrivatesaleDate;
448     uint256 public soldToken = 0;                                                           
449 
450     //addresses
451     address public beneficiaryAddress;
452     address public tokenAddress;
453 
454     bool private isPrivatesaleActive = false;
455     bool private isPresaleActive = false;
456     bool private isPhase1CrowdsaleActive = false;
457     bool private isPhase2CrowdsaleActive = false;
458     bool private isPhase3CrowdsaleActive = false;
459     bool private isGapActive = false;
460 
461     event TokenBought(address indexed _investor, uint256 _token, uint256 _timestamp);
462     event LogTokenSet(address _token, uint256 _timestamp);
463 
464     enum State { PrivateSale, PreSale, Gap, CrowdSalePhase1, CrowdSalePhase2, CrowdSalePhase3 }
465 
466     /**
467     * @dev Transfer the ether to the beneficiaryAddress.
468     * @param _fund The ether that is transferred to contract to buy tokens.  
469     */
470     function fundTransfer(uint256 _fund) internal returns(bool) {
471         beneficiaryAddress.transfer(_fund);
472         return true;
473     }
474 
475     /**
476     * @dev fallback function which accepts the ether and call the buy token function.
477     */
478     function () payable public {
479         buyTokens(msg.sender);
480     }
481 
482     /**
483     * @dev TuurntCrowdsale constructor sets the original beneficiaryAddress and 
484     * set the timeslot for the Pre-ICO and ICO.
485     * @param _beneficiaryAddress The address to transfer the ether that is raised during crowdsale. 
486     */
487     constructor(address _beneficiaryAddress, address _whitelist, uint256 _startDate) public {
488         require(_beneficiaryAddress != address(0));
489         beneficiaryAddress = _beneficiaryAddress;
490         whitelist = WhitelistInterface(_whitelist);
491         startPrivatesaleDate = _startDate;
492         isPrivatesaleActive = !isPrivatesaleActive;
493     }
494 
495     /**
496     * @dev Allow founder to end the Private sale.
497     */
498     function endPrivatesale() onlyOwner public {
499         require(isPrivatesaleActive == true);
500         isPrivatesaleActive = !isPrivatesaleActive;
501     }
502 
503     /**
504     * @dev Allow founder to set the token contract address.
505     * @param _tokenAddress The address of token contract.
506     */
507     function setTokenAddress(address _tokenAddress) onlyOwner public {
508         require(tokenAddress == address(0));
509         token = TuurntToken(_tokenAddress);
510         tokenAddress = _tokenAddress;
511         emit LogTokenSet(token, now);
512     }
513 
514      /**
515     * @dev Allow founder to start the Presale.
516     */
517     function activePresale(uint256 _presaleDate) onlyOwner public {
518         require(isPresaleActive == false);
519         require(isPrivatesaleActive == false);
520         startPresaleDate = _presaleDate;
521         endPresaleDate = startPresaleDate + 2 days;
522         isPresaleActive = !isPresaleActive;
523     }
524    
525     /**
526     * @dev Allow founder to start the Crowdsale phase1.
527     */
528     function activeCrowdsalePhase1(uint256 _phase1Date) onlyOwner public {
529         require(isPresaleActive == true);
530         require(_phase1Date > endPresaleDate);
531         require(isPhase1CrowdsaleActive == false);
532         startCrowdsalePhase1Date = _phase1Date;
533         endCrowdsalePhase1Date = _phase1Date + 1 weeks;
534         isPresaleActive = !isPresaleActive;
535         isPhase1CrowdsaleActive = !isPhase1CrowdsaleActive;
536     }
537 
538     /**
539     * @dev Allow founder to start the Crowdsale phase2. 
540     */
541 
542     function activeCrowdsalePhase2(uint256 _phase2Date) onlyOwner public {
543         require(isPhase2CrowdsaleActive == false);
544         require(_phase2Date > endCrowdsalePhase1Date);
545         require(isPhase1CrowdsaleActive == true);
546         startCrowdsalePhase2Date = _phase2Date;
547         endCrowdsalePhase2Date = _phase2Date + 2 weeks;
548         isPhase2CrowdsaleActive = !isPhase2CrowdsaleActive;
549         isPhase1CrowdsaleActive = !isPhase1CrowdsaleActive;
550     }
551 
552     /**
553     * @dev Allow founder to start the Crowdsale phase3. 
554     */
555     function activeCrowdsalePhase3(uint256 _phase3Date) onlyOwner public {
556         require(isPhase3CrowdsaleActive == false);
557         require(_phase3Date > endCrowdsalePhase2Date);
558         require(isPhase2CrowdsaleActive == true);
559         startCrowdsalePhase3Date = _phase3Date;
560         endCrowdsalePhase3Date = _phase3Date + 3 weeks;
561         isPhase3CrowdsaleActive = !isPhase3CrowdsaleActive;
562         isPhase2CrowdsaleActive = !isPhase2CrowdsaleActive;
563     }
564     /**
565     * @dev Allow founder to change the minimum investment of ether.
566     * @param _newMinInvestment The value of new minimum ether investment. 
567     */
568     function changeMinInvestment(uint256 _newMinInvestment) onlyOwner public {
569         MIN_INVESTMENT = _newMinInvestment;
570     }
571 
572      /**
573     * @dev Allow founder to change the ether rate.
574     * @param _newEthRate current rate of ether. 
575     */
576     function setEtherRate(uint256 _newEthRate) onlyOwner public {
577         require(_newEthRate != 0);
578         ethRate = _newEthRate;
579     }
580 
581     /**
582     * @dev Return the state based on the timestamp. 
583     */
584 
585     function getState() view public returns(State) {
586         
587         if(now >= startPrivatesaleDate && isPrivatesaleActive == true) {
588             return State.PrivateSale;
589         }
590         if (now >= startPresaleDate && now <= endPresaleDate) {
591             require(isPresaleActive == true);
592             return State.PreSale;
593         }
594         if (now >= startCrowdsalePhase1Date && now <= endCrowdsalePhase1Date) {
595             require(isPhase1CrowdsaleActive == true);
596             return State.CrowdSalePhase1;
597         }
598         if (now >= startCrowdsalePhase2Date && now <= endCrowdsalePhase2Date) {
599             require(isPhase2CrowdsaleActive == true);
600             return State.CrowdSalePhase2;
601         }
602         if (now >= startCrowdsalePhase3Date && now <= endCrowdsalePhase3Date) {
603             require(isPhase3CrowdsaleActive == true);
604             return State.CrowdSalePhase3;
605         }
606         return State.Gap;
607 
608     }
609  
610     /**
611     * @dev Return the rate based on the state and timestamp.
612     */
613 
614     function getRate() view public returns(uint256) {
615         if (getState() == State.PrivateSale) {
616             return 5;
617         }
618         if (getState() == State.PreSale) {
619             return 6;
620         }
621         if (getState() == State.CrowdSalePhase1) {
622             return 7;
623         }
624         if (getState() == State.CrowdSalePhase2) {
625             return 8;
626         }
627         if (getState() == State.CrowdSalePhase3) {
628             return 10;
629         }
630     }
631     
632     /**
633     * @dev Calculate the number of tokens to be transferred to the investor address 
634     * based on the invested ethers.
635     * @param _investedAmount The value of ether that is invested.  
636     */
637     function getTokenAmount(uint256 _investedAmount) view public returns(uint256) {
638         uint256 tokenRate = getRate();
639         uint256 tokenAmount = _investedAmount.mul((ethRate.mul(100)).div(tokenRate));
640         return tokenAmount;
641     }
642 
643     /**
644     * @dev Transfer the tokens to the investor address.
645     * @param _investorAddress The address of investor. 
646     */
647     function buyTokens(address _investorAddress) 
648     public 
649     payable
650     returns(bool)
651     {   
652         require(whitelist.checkWhitelist(_investorAddress));
653         if ((getState() == State.PreSale) ||
654             (getState() == State.CrowdSalePhase1) || 
655             (getState() == State.CrowdSalePhase2) || 
656             (getState() == State.CrowdSalePhase3) || 
657             (getState() == State.PrivateSale)) {
658             uint256 amount;
659             require(_investorAddress != address(0));
660             require(tokenAddress != address(0));
661             require(msg.value >= MIN_INVESTMENT);
662             amount = getTokenAmount(msg.value);
663             require(fundTransfer(msg.value));
664             require(token.transfer(_investorAddress, amount));
665             ethRaised = ethRaised.add(msg.value);
666             soldToken = soldToken.add(amount);
667             emit TokenBought(_investorAddress,amount,now);
668             return true;
669         }else {
670             revert();
671         }
672     }
673 
674     /**
675     * @dev Allow founder to end the crowsale and transfer the remaining
676     * tokens of crowdfund to the company address. 
677     */
678     function endCrowdfund(address companyAddress) onlyOwner public returns(bool) {
679         require(isPhase3CrowdsaleActive == true);
680         require(now >= endCrowdsalePhase3Date); 
681         uint256 remaining = token.balanceOf(this);
682         require(token.transfer(companyAddress, remaining));
683     }
684 
685 }