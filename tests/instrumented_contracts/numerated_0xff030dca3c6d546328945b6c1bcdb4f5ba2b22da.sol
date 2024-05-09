1 pragma solidity ^0.4.13;
2 
3 /**
4  * Contract "Math"
5  * Purpose: Math operations with safety checks
6  */
7 library Math {
8 
9     /**
10     * Multiplication with safety check
11     */
12     function Mul(uint a, uint b) constant internal returns (uint) {
13       uint c = a * b;
14       //check result should not be other wise until a=0
15       assert(a == 0 || c / a == b);
16       return c;
17     }
18 
19     /**
20     * Division with safety check
21     */
22     function Div(uint a, uint b) constant internal returns (uint) {
23       //overflow check; b must not be 0
24       assert(b > 0);
25       uint c = a / b;
26       assert(a == b * c + a % b);
27       return c;
28     }
29 
30     /**
31     * Subtraction with safety check
32     */
33     function Sub(uint a, uint b) constant internal returns (uint) {
34       //b must be greater that a as we need to store value in unsigned integer
35       assert(b <= a);
36       return a - b;
37     }
38 
39     /**
40     * Addition with safety check
41     */
42     function Add(uint a, uint b) constant internal returns (uint) {
43       uint c = a + b;
44       //result must be greater as a or b can not be negative
45       assert(c>=a && c>=b);
46       return c;
47     }
48 }
49 
50 /**
51  * Contract "ERC20Basic"
52  * Purpose: Defining ERC20 standard with basic functionality like - CheckBalance and Transfer including Transfer event
53  */
54 contract ERC20Basic {
55   
56   //Give realtime totalSupply of EXH token
57   uint public totalSupply;
58 
59   //Get EXH token balance for provided address in lowest denomination
60   function balanceOf(address who) constant public returns (uint);
61 
62   //Transfer EXH token to provided address
63   function transfer(address _to, uint _value) public returns(bool ok);
64 
65   //Emit Transfer event outside of blockchain for every EXH token transfers
66   event Transfer(address indexed _from, address indexed _to, uint _value);
67 }
68 
69 /**
70  * Contract "ERC20"
71  * Purpose: Defining ERC20 standard with more advanced functionality like - Authorize spender to transfer EXH token
72  */
73 contract ERC20 is ERC20Basic {
74 
75   //Get EXH token amount that spender can spend from provided owner's account 
76   function allowance(address owner, address spender) public constant returns (uint);
77 
78   //Transfer initiated by spender 
79   function transferFrom(address _from, address _to, uint _value) public returns(bool ok);
80 
81   //Add spender to authrize for spending specified amount of EXH Token
82   function approve(address _spender, uint _value) public returns(bool ok);
83 
84   //Emit event for any approval provided to spender
85   event Approval(address indexed owner, address indexed spender, uint value);
86 }
87 
88 
89 /**
90  * Contract "Ownable"
91  * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account
92  */
93 contract Ownable {
94 
95   //owner variable to store contract owner account
96   address public owner;
97 
98   //Constructor for the contract to store owner's account on deployement
99   function Ownable() public {
100     owner = msg.sender;
101   }
102   
103   //modifier to check transaction initiator is only owner
104   modifier onlyOwner() {
105     if (msg.sender == owner)
106       _;
107   }
108 
109   //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
110   function transferOwnership(address newOwner) public onlyOwner {
111     if (newOwner != address(0)) 
112         owner = newOwner;
113   }
114 
115 }
116 
117 /**
118  * Contract "Pausable"
119  * Purpose: Contract to provide functionality to pause and resume Sale in case of emergency
120  */
121 contract Pausable is Ownable {
122 
123   //flag to indicate whether Sale is paused or not
124   bool public stopped;
125 
126   //Emit event when any change happens in crowdsale state
127   event StateChanged(bool changed);
128 
129   //modifier to continue with transaction only when Sale is not paused
130   modifier stopInEmergency {
131     require(!stopped);
132     _;
133   }
134 
135   //modifier to continue with transaction only when Sale is paused
136   modifier onlyInEmergency {
137     require(stopped);
138     _;
139   }
140 
141   // called by the owner on emergency, pause Sale
142   function emergencyStop() external onlyOwner  {
143     stopped = true;
144     //Emit event when crowdsale state changes
145     StateChanged(true);
146   }
147 
148   // called by the owner on end of emergency, resumes Sale
149   function release() external onlyOwner onlyInEmergency {
150     stopped = false;
151     //Emit event when crowdsale state changes
152     StateChanged(true);
153   }
154 
155 }
156 
157 /**
158  * Contract "EXH"
159  * Purpose: Create EXH token
160  */
161 contract EXH is ERC20, Ownable {
162 
163   using Math for uint;
164 
165   /* Public variables of the token */
166   //To store name for token
167   string public name;
168 
169   //To store symbol for token       
170   string public symbol;
171 
172   //To store decimal places for token
173   uint8 public decimals;    
174 
175   //To store decimal version for token
176   string public version = 'v1.0'; 
177 
178   //To store current supply of EXH Token
179   uint public totalSupply;
180 
181   //flag to indicate whether transfer of EXH Token is allowed or not
182   bool public locked;
183 
184   //map to store EXH Token balance corresponding to address
185   mapping(address => uint) balances;
186 
187   //To store spender with allowed amount of EXH Token to spend corresponding to EXH Token holder's account
188   mapping (address => mapping (address => uint)) allowed;
189 
190   //To handle ERC20 short address attack  
191   modifier onlyPayloadSize(uint size) {
192      require(msg.data.length >= size + 4);
193      _;
194   }
195   
196   // Lock transfer during Sale
197   modifier onlyUnlocked() {
198     require(!locked || msg.sender == owner);
199     _;
200   }
201 
202   //Contructor to define EXH Token token properties
203   function EXH() public {
204 
205     // lock the transfer function during Sale
206     locked = true;
207 
208     //initial token supply is 0
209     totalSupply = 0;
210 
211     //Name for token set to EXH Token
212     name = 'EXH Token';
213 
214     // Symbol for token set to 'EXH'
215     symbol = 'EXH';
216  
217     decimals = 18;
218   }
219  
220   //Implementation for transferring EXH Token to provided address 
221   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public onlyUnlocked returns (bool){
222 
223     //Check provided EXH Token should not be 0
224     if (_value > 0 && !(_to == address(0))) {
225       //deduct EXH Token amount from transaction initiator
226       balances[msg.sender] = balances[msg.sender].Sub(_value);
227       //Add EXH Token to balace of target account
228       balances[_to] = balances[_to].Add(_value);
229       //Emit event for transferring EXH Token
230       Transfer(msg.sender, _to, _value);
231       return true;
232     }
233     else{
234       return false;
235     }
236   }
237 
238   //Transfer initiated by spender 
239   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public onlyUnlocked returns (bool) {
240 
241     //Check provided EXH Token should not be 0
242     if (_value > 0 && (_to != address(0) && _from != address(0))) {
243       //Get amount of EXH Token for which spender is authorized
244       var _allowance = allowed[_from][msg.sender];
245       //Add amount of EXH Token in trarget account's balance
246       balances[_to] = balances[_to].Add( _value);
247       //Deduct EXH Token amount from _from account
248       balances[_from] = balances[_from].Sub( _value);
249       //Deduct Authorized amount for spender
250       allowed[_from][msg.sender] = _allowance.Sub( _value);
251       //Emit event for Transfer
252       Transfer(_from, _to, _value);
253       return true;
254     }else{
255       return false;
256     }
257   }
258 
259   //Get EXH Token balance for provided address
260   function balanceOf(address _owner) public constant returns (uint balance) {
261     return balances[_owner];
262   }
263   
264   //Add spender to authorize for spending specified amount of EXH Token 
265   function approve(address _spender, uint _value) public returns (bool) {
266     require(_spender != address(0));
267     allowed[msg.sender][_spender] = _value;
268     //Emit event for approval provided to spender
269     Approval(msg.sender, _spender, _value);
270     return true;
271   }
272 
273   //Get EXH Token amount that spender can spend from provided owner's account 
274   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
275     return allowed[_owner][_spender];
276   }
277   
278 }
279 
280 /**
281  * Contract "Crowdsale"
282  * Purpose: Contract for crowdsale of EXH Token
283  */
284 contract Crowdsale is EXH, Pausable {
285 
286   using Math for uint;
287   
288   /* Public variables for Sale */
289 
290   // Sale start block
291   uint public startBlock;   
292 
293   // Sale end block  
294   uint public endBlock;  
295 
296   // To store maximum number of EXH Token to sell
297   uint public maxCap;   
298 
299   // To store maximum number of EXH Token to sell in PreSale
300   uint public maxCapPreSale;   
301 
302   // To store total number of ETH received
303   uint public ETHReceived;    
304 
305   // Number of tokens that can be purchased with 1 Ether
306   uint public PRICE;   
307 
308   // To indicate Sale status; crowdsaleStatus=0 => crowdsale not started; crowdsaleStatus=1=> crowdsale started; crowdsaleStatus=2=> crowdsale finished
309   uint public crowdsaleStatus; 
310 
311   // To store crowdSale type; crowdSaleType=0 => PreSale; crowdSaleType=1 => CrowdSale
312   uint public crowdSaleType; 
313 
314   //Total Supply in PreSale
315   uint public totalSupplyPreSale; 
316 
317   //No of days for which presale will be open
318   uint public durationPreSale;
319 
320   //Value of 1 ether, ie, 1 followed by 18 zero
321   uint valueOneEther = 1e18;
322 
323   //No of days for which the complete crowdsale will run- presale  + crowdsale
324   uint public durationCrowdSale;
325 
326   //Store total number of investors
327   uint public countTotalInvestors;
328 
329   //Number of investors who have received refund
330   uint public countInvestorsRefunded;
331   
332   //Set status of refund
333   uint public refundStatus;
334 
335  //maxCAp for mint and transfer
336   uint public maxCapMintTransfer ;
337 
338   //total supply for mint and transfer
339   uint public totalSupplyMintTransfer;
340 
341   //total tokens sold in crowdsale
342   uint public totalSupplyCrowdsale;
343 
344   //Stores total investros in crowdsale
345   uint256 public countTotalInvestorsInCrowdsale;
346 
347   uint256 public countInvestorsRefundedInCrowdsale;
348 
349   //Structure for investors; holds received wei amount and EXH Token sent
350   struct Investor {
351     //wei received during PreSale
352     uint weiReceivedCrowdsaleType0;
353     //wei received during CrowdSale
354     uint weiReceivedCrowdsaleType1;
355     //Tokens sent during PreSale
356     uint exhSentCrowdsaleType0;
357     //Tokens sent during CrowdSale
358     uint exhSentCrowdsaleType1;
359     //Uniquely identify an investor(used for iterating)
360     uint investorID;
361   }
362 
363   //investors indexed by their ETH address
364   mapping(address => Investor) public investors;
365   //investors indexed by their IDs
366   mapping (uint => address) public investorList;
367 
368   
369   //Emit event on receiving ETH
370   event ReceivedETH(address addr, uint value);
371 
372   //Emit event on transferring EXH Token to user when payment is received in traditional ways or B type EXH Token converted to A type EXH Token
373   event MintAndTransferEXH(address addr, uint value, bytes32 comment);
374 
375   //constructor to initialize contract variables
376   function Crowdsale() public {
377 
378     //Will be set in function start; Makes sure Sale will be started only when start() function is called
379     startBlock = 0;   
380     //Will be set in function start; Makes sure Sale will be started only when start() function is called        
381     endBlock = 0;    
382     //Max number of EXH Token to sell in CrowdSale[Includes the tokens sold in presale](33M)
383     maxCap = 31750000e18;
384     //Max number of EXH Token to sell in Presale(0.5M)
385     maxCapPreSale = 500000e18;
386     //1250000 Tokens avalable for Mint and Transfer
387     maxCapMintTransfer = 1250000e18;
388     // EXH Token per ether
389     PRICE = 10; 
390     //Indicates Sale status; Sale is not started yet
391     crowdsaleStatus = 0;    
392     //At time of deployment crowdSale type is set to Presale
393     crowdSaleType = 0;
394     // Number of days after which sale will start since the starting of presale, a single value to replace the hardcoded
395     durationPreSale = 8 days + 1 hours;
396     // Number of days for which complete crowdsale will run, ie, presale and crowdsale period
397     durationCrowdSale = 28 days;
398     // Investor count is 0 initially
399     countTotalInvestors = 0;
400     //Initially no investor has been refunded
401     countInvestorsRefunded = 0;
402     //Refund eligible or not
403     refundStatus = 0;
404 
405     countTotalInvestorsInCrowdsale = 0;
406     countInvestorsRefundedInCrowdsale = 0;
407     
408   }
409 
410   //Modifier to make sure transaction is happening during Sale
411   modifier respectTimeFrame() {
412     assert(!((now < startBlock) || (now > endBlock )));
413     _;
414   }
415 
416   /*
417   * To start Sale from Presale
418   */
419   function start() public onlyOwner {
420     //Set block number to current block number
421     assert(startBlock == 0);
422     startBlock = now;            
423     //Set end block number
424     endBlock = now.Add(durationCrowdSale.Add(durationPreSale));
425     //Sale presale is started
426     crowdsaleStatus = 1;
427     //Emit event when crowdsale state changes
428     StateChanged(true);  
429   }
430 
431   /*
432   * To start Crowdsale
433   */
434   function startSale() public onlyOwner
435   {
436     if(now > startBlock.Add(durationPreSale) && now <= endBlock){
437         crowdsaleStatus = 1;
438         crowdSaleType = 1;
439         if(crowdSaleType != 1)
440         {
441           totalSupplyCrowdsale = totalSupplyPreSale;
442         }
443         //Emit event when crowdsale state changes
444         StateChanged(true); 
445     }
446     else
447       revert();
448   }
449 
450   /*
451   * To extend duration of Crowdsale
452   */
453   function updateDuration(uint time) public onlyOwner
454   {
455       require(time != 0);
456       assert(startBlock != 0);
457       assert(crowdSaleType == 1 && crowdsaleStatus != 2);
458       durationCrowdSale = durationCrowdSale.Add(time);
459       endBlock = endBlock.Add(time);
460       //Emit event when crowdsale state changes
461       StateChanged(true);
462   }
463 
464   /*
465   * To set price for EXH Token
466   */
467   function setPrice(uint price) public onlyOwner
468   {
469       require( price != 0);
470       PRICE = price;
471       //Emit event when crowdsale state changes
472       StateChanged(true);
473   }
474   
475   /*
476   * To enable transfers of EXH Token after completion of Sale
477   */
478   function unlock() public onlyOwner
479   {
480     locked = false;
481     //Emit event when crowdsale state changes
482     StateChanged(true);
483   }
484   
485   //fallback function i.e. payable; initiates when any address transfers Eth to Contract address
486   function () public payable {
487   //call createToken function with account who transferred Eth to contract address
488     createTokens(msg.sender);
489   }
490 
491   /*
492   * To create EXH Token and assign to transaction initiator
493   */
494   function createTokens(address beneficiary) internal stopInEmergency  respectTimeFrame {
495     //Make sure Sale is running
496     assert(crowdsaleStatus == 1); 
497     //Don't accept fund to purchase less than 1 EXH Token   
498     require(msg.value >= 1 ether/getPrice());   
499     //Make sure sent Eth is not 0           
500     require(msg.value != 0);
501     //Calculate EXH Token to send
502     uint exhToSend = msg.value.Mul(getPrice());
503 
504     //Make entry in Investor indexed with address
505     Investor storage investorStruct = investors[beneficiary];
506 
507     // For Presale
508     if(crowdSaleType == 0){
509       require(exhToSend.Add(totalSupplyPreSale) <= maxCapPreSale);
510       totalSupplyPreSale = totalSupplyPreSale.Add(exhToSend);
511       if((maxCapPreSale.Sub(totalSupplyPreSale) < valueOneEther)||(now > (startBlock.Add(7 days + 1 hours)))){
512         crowdsaleStatus = 2;
513       }        
514       investorStruct.weiReceivedCrowdsaleType0 = investorStruct.weiReceivedCrowdsaleType0.Add(msg.value);
515       investorStruct.exhSentCrowdsaleType0 = investorStruct.exhSentCrowdsaleType0.Add(exhToSend);
516     }
517 
518     // For CrowdSale
519     else if (crowdSaleType == 1){
520       if (exhToSend.Add(totalSupply) > maxCap ) {
521         revert();
522       }
523       totalSupplyCrowdsale = totalSupplyCrowdsale.Add(exhToSend);
524       if(maxCap.Sub(totalSupplyCrowdsale) < valueOneEther)
525       {
526         crowdsaleStatus = 2;
527       }
528       if(investorStruct.investorID == 0 || investorStruct.weiReceivedCrowdsaleType1 == 0){
529         countTotalInvestorsInCrowdsale++;
530       }
531       investorStruct.weiReceivedCrowdsaleType1 = investorStruct.weiReceivedCrowdsaleType1.Add(msg.value);
532       investorStruct.exhSentCrowdsaleType1 = investorStruct.exhSentCrowdsaleType1.Add(exhToSend);
533     }
534 
535     //If it is a new investor, then create a new id
536     if(investorStruct.investorID == 0){
537         countTotalInvestors++;
538         investorStruct.investorID = countTotalInvestors;
539         investorList[countTotalInvestors] = beneficiary;
540     }
541 
542     //update total supply of EXH Token
543     totalSupply = totalSupply.Add(exhToSend);
544     // Update the total wei collected during Sale
545     ETHReceived = ETHReceived.Add(msg.value);  
546     //Update EXH Token balance for transaction initiator
547     balances[beneficiary] = balances[beneficiary].Add(exhToSend);
548     //Emit event for contribution
549     ReceivedETH(beneficiary,ETHReceived); 
550     //ETHReceived during Sale will remain with contract
551     GetEXHFundAccount().transfer(msg.value);
552     //Emit event when crowdsale state changes
553     StateChanged(true);
554   }
555 
556   /*
557   * To enable vesting of B type EXH Token
558   */
559   function MintAndTransferToken(address beneficiary,uint exhToCredit,bytes32 comment) external onlyOwner {
560     //Available after the crowdsale is started
561     assert(startBlock != 0);
562     //Check whether tokens are available or not
563     assert(totalSupplyMintTransfer <= maxCapMintTransfer);
564     //Check whether the amount of token are available to transfer
565     require(totalSupplyMintTransfer.Add(exhToCredit) <= maxCapMintTransfer);
566     //Update EXH Token balance for beneficiary
567     balances[beneficiary] = balances[beneficiary].Add(exhToCredit);
568     //Update total supply for EXH Token
569     totalSupply = totalSupply.Add(exhToCredit);
570     //update total supply for EXH token in mint and transfer
571     totalSupplyMintTransfer = totalSupplyMintTransfer.Add(exhToCredit);
572     // send event for transferring EXH Token on offline payment
573     MintAndTransferEXH(beneficiary, exhToCredit,comment);
574     //Emit event when crowdsale state changes
575     StateChanged(true);  
576   }
577 
578   /*
579   * To get price for EXH Token
580   */
581   function getPrice() public constant returns (uint result) {
582       if (crowdSaleType == 0) {
583             return (PRICE.Mul(100)).Div(70);
584       }
585       if (crowdSaleType == 1) {
586           uint crowdsalePriceBracket = 1 weeks;
587           uint startCrowdsale = startBlock.Add(durationPreSale);
588             if (now > startCrowdsale && now <= startCrowdsale.Add(crowdsalePriceBracket)) {
589                 return ((PRICE.Mul(100)).Div(80));
590             }else if (now > startCrowdsale.Add(crowdsalePriceBracket) && now <= (startCrowdsale.Add(crowdsalePriceBracket.Mul(2)))) {
591                 return (PRICE.Mul(100)).Div(85);
592             }else if (now > (startCrowdsale.Add(crowdsalePriceBracket.Mul(2))) && now <= (startCrowdsale.Add(crowdsalePriceBracket.Mul(3)))) {
593                 return (PRICE.Mul(100)).Div(90);
594             }else if (now > (startCrowdsale.Add(crowdsalePriceBracket.Mul(3))) && now <= (startCrowdsale.Add(crowdsalePriceBracket.Mul(4)))) {
595                 return (PRICE.Mul(100)).Div(95);
596             }
597       }
598       return PRICE;
599   }
600 
601   function GetEXHFundAccount() internal returns (address) {
602     uint remainder = block.number%10;
603     if(remainder==0){
604       return 0xda141e704601f8C8E343C5cA246355c812238D91;
605     } else if(remainder==1){
606       return 0x2381963906C434dD4639489Bec9A2bB55D83cC14;
607     } else if(remainder==2){
608       return 0x537C7119452A7814ABD1C4ED71F6eCD25225C0F6;
609     } else if(remainder==3){
610       return 0x1F04880fFdFff05d36307f69EAAc8645B98449E2;
611     } else if(remainder==4){
612       return 0xd72B82b69FEe29d81f5e2DA66aB91014aDaE0AA0;
613     } else if(remainder==5){
614       return 0xf63bef6B67064053191dc4bC6F1D06592C07925f;
615     } else if(remainder==6){
616       return 0x7381F9C5d35E895e80aDeC1e1A3541860F876600;
617     } else if(remainder==7){
618       return 0x370301AE4659D2975be9F976011c787EC59e0645;
619     } else if(remainder==8){
620       return 0x2C041b6A7fF277966cB0b4cb966aaB8Fc1178ac5;
621     }else {
622       return 0x8A401290A39Dc8D046e42BABaf5a818e29ae4fda;
623     }
624   }
625 
626   /*
627   * Finalize the crowdsale
628   */
629   function finalize() public onlyOwner {
630     //Make sure Sale is running
631     assert(crowdsaleStatus==1 && crowdSaleType==1);
632     // cannot finalise before end or until maxcap is reached
633       assert(!((totalSupplyCrowdsale < maxCap && now < endBlock) && (maxCap.Sub(totalSupplyCrowdsale) >= valueOneEther)));  
634       //Indicates Sale is ended
635       
636       //Checks if the fundraising goal is reached in crowdsale or not
637       if (totalSupply < 5300000e18)
638         refundStatus = 2;
639       else
640         refundStatus = 1;
641       
642     //crowdsale is ended
643     crowdsaleStatus = 2;
644     //Emit event when crowdsale state changes
645     StateChanged(true);
646   }
647 
648   /*
649   * Refund the investors in case target of crowdsale not achieved
650   */
651   function refund() public onlyOwner {
652       assert(refundStatus == 2);
653       uint batchSize = countInvestorsRefunded.Add(50) < countTotalInvestors ? countInvestorsRefunded.Add(50): countTotalInvestors;
654       for(uint i=countInvestorsRefunded.Add(1); i <= batchSize; i++){
655           address investorAddress = investorList[i];
656           Investor storage investorStruct = investors[investorAddress];
657           //If purchase has been made during CrowdSale
658           if(investorStruct.exhSentCrowdsaleType1 > 0 && investorStruct.exhSentCrowdsaleType1 <= balances[investorAddress]){
659               //return everything
660               investorAddress.transfer(investorStruct.weiReceivedCrowdsaleType1);
661               //Reduce ETHReceived
662               ETHReceived = ETHReceived.Sub(investorStruct.weiReceivedCrowdsaleType1);
663               //Update totalSupply
664               totalSupply = totalSupply.Sub(investorStruct.exhSentCrowdsaleType1);
665               // reduce balances
666               balances[investorAddress] = balances[investorAddress].Sub(investorStruct.exhSentCrowdsaleType1);
667               //set everything to zero after transfer successful
668               investorStruct.weiReceivedCrowdsaleType1 = 0;
669               investorStruct.exhSentCrowdsaleType1 = 0;
670               countInvestorsRefundedInCrowdsale = countInvestorsRefundedInCrowdsale.Add(1);
671           }
672       }
673       //Update the number of investors that have recieved refund
674       countInvestorsRefunded = batchSize;
675       StateChanged(true);
676   }
677 
678   /*
679    * Failsafe drain
680    */
681   function drain() public onlyOwner {
682     GetEXHFundAccount().transfer(this.balance);
683   }
684 
685   /*
686   * Function to add Ether in the contract 
687   */
688   function fundContractForRefund() payable{
689     // StateChanged(true);
690   }
691 
692 }