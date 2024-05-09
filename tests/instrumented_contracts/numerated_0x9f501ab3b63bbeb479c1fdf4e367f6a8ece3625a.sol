1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   constructor() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 /**
80  * @title Pausable
81  * @dev Base contract which allows children to implement an emergency stop mechanism.
82  */
83 contract Pausable is Ownable {
84   event Pause();
85   event Unpause();
86 
87   bool public paused = false;
88 
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is not paused.
92    */
93   modifier whenNotPaused() {
94     require(!paused);
95     _;
96   }
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is paused.
100    */
101   modifier whenPaused() {
102     require(paused);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to pause, triggers stopped state
108    */
109   function pause() onlyOwner whenNotPaused public {
110     paused = true;
111     emit Pause();
112   }
113 
114   /**
115    * @dev called by the owner to unpause, returns to normal state
116    */
117   function unpause() onlyOwner whenPaused public {
118     paused = false;
119     emit Unpause();
120   }
121 }
122 
123 
124 /**
125  * @title ERC223Interface
126  * @dev Simpler version of ERC223 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/223
128  */
129 
130 contract ERC223Interface {
131     uint public totalSupply;
132     function balanceOf(address who) public constant returns (uint);
133     function transfer(address to, uint value) public;
134     function transfer(address to, uint value, bytes data) public;
135     event Transfer(address indexed from, address indexed to, uint value, bytes data);
136 }
137 
138 /**
139  * @title Contract that will work with ERC223 tokens.
140  */
141  
142 contract ERC223ReceivingContract { 
143 /**
144  * @dev Standard ERC223 function that will handle incoming token transfers.
145  *
146  * @param _from  Token sender address.
147  * @param _value Amount of tokens.
148  * @param _data  Transaction metadata.
149  */
150     function tokenFallback(address _from, uint _value, bytes _data) public;
151 }
152 
153 /**
154  * @title Reference implementation of the ERC223 standard token.
155  */
156  
157 contract ERC223Token is ERC223Interface, Pausable  {
158     using SafeMath for uint;
159 
160     mapping(address => uint) balances; // List of user balances.
161     
162     /**
163      * @dev Transfer the specified amount of tokens to the specified address.
164      *      Invokes the `tokenFallback` function if the recipient is a contract.
165      *      The token transfer fails if the recipient is a contract
166      *      but does not implement the `tokenFallback` function
167      *      or the fallback function to receive funds.
168      *
169      * @param _to    Receiver address.
170      * @param _value Amount of tokens that will be transferred.
171      * @param _data  Transaction metadata.
172      */
173      
174     function transfer(address _to, uint _value, bytes _data) public whenNotPaused {
175         // Standard function transfer similar to ERC20 transfer with no _data .
176         // Added due to backwards compatibility reasons .
177         uint codeLength;
178 
179         assembly {
180             // Retrieve the size of the code on target address, this needs assembly .
181             codeLength := extcodesize(_to)
182         }
183 
184         balances[msg.sender] = balances[msg.sender].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         if(codeLength>0) {
187             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
188             receiver.tokenFallback(msg.sender, _value, _data);
189         }
190         emit Transfer(msg.sender, _to, _value, _data);
191     }
192     
193     /**
194      * @dev Transfer the specified amount of tokens to the specified address.
195      *      This function works the same with the previous one
196      *      but doesn't contain `_data` param.
197      *      Added due to backwards compatibility reasons.
198      *
199      * @param _to    Receiver address.
200      * @param _value Amount of tokens that will be transferred.
201      */
202     function transfer(address _to, uint _value) public whenNotPaused {
203         uint codeLength;
204         bytes memory empty;
205 
206         assembly {
207             // Retrieve the size of the code on target address, this needs assembly .
208             codeLength := extcodesize(_to)
209         }
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         if(codeLength>0) {
214             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
215             receiver.tokenFallback(msg.sender, _value, empty);
216         }
217         emit Transfer(msg.sender, _to, _value, empty);
218     }
219 
220     
221     /**
222      * @dev Returns balance of the `_owner`.
223      *
224      * @param _owner   The address whose balance will be returned.
225      * @return balance Balance of the `_owner`.
226      */
227     function balanceOf(address _owner) public whenNotPaused constant returns (uint balance)  {
228         return balances[_owner];
229     }
230 }
231 
232 
233 contract LinTokenMint is ERC223Token {
234     
235     string public constant name = "LinToken";   // Set the name for display purposes
236     string public constant symbol = "LIN";  // Set the symbol for display purposes
237     uint256 public constant decimals = 18;  // 18 decimals is the strongly suggested default, avoid changing it
238     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));    // Set the initial supply
239     uint256 public totalSupply = INITIAL_SUPPLY;    // Set the total supply
240     uint256 internal Percent = INITIAL_SUPPLY.div(100); // Set the 1 percent of the total supply
241     
242     uint256 public ICOSupply = Percent.mul(50); // Set the 50 percent of the ico supply
243     uint256 internal LinNetOperationSupply = Percent.mul(30);   // Set the 30 percent of the LinNetOperation supply
244     uint256 internal LinTeamSupply = Percent.mul(10);   // Set the 10 percent of the LinTeam supply
245     uint256 internal SympoSiumSupply = Percent.mul(5);  // Set the 5 percent of the SympoSium supply
246     uint256 internal BountySupply = Percent.mul(5).div(2);  // Set the 2.5 percent of the SympoSium supply
247     uint256 internal preICOSupply = Percent.mul(5).div(2);  // Set the 2.5 percent of the preICO supply
248     
249     address internal LinNetOperation = 0x48a240d2aB56FE372e9867F19C7Ba33F60cB32fc;  // Set a LinNetOperation's address
250     address internal LinTeam = 0xF55f80d09e551c35735ed4af107f6d361a7eD623;  // Set a LinTeam's address
251     address internal SympoSium = 0x5761DB2F09A0DF0b03A885C61E618CFB4Da7492D;    // Set a SympoSium's address
252     address internal Bounty = 0x76e1173022e0fD87D15AA90270828b1a6a54Eac1;   // Set a Bounty's address
253     address internal preICO = 0x2bfdf8B830DAaf54d0b538aF1E62A192Bf291B5d;   // Set a preICO's address
254 
255     event InitSupply(uint256 owner, uint256 LinNetOperation, uint256 LinTeam, uint256 SympoSium, uint256 Bounty, uint256 preICO);
256     
257      /**
258      * @dev The log is output when the contract is distributed.
259      */
260     
261     constructor() public {
262        
263         emit InitSupply(ICOSupply, LinNetOperationSupply, LinTeamSupply, SympoSiumSupply, BountySupply, preICOSupply);
264         
265     }
266     
267 }
268 contract WhitelistedCrowdsale is Ownable {
269 
270     mapping(address => bool) public whitelist;
271 
272     event AddWhiteList(address who);
273     event DelWhiteList(address who);
274 
275     /**
276      * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
277      */
278     modifier isWhitelisted(address _beneficiary) {
279     require(whitelist[_beneficiary]);
280     _;
281     }
282 
283   /**
284    * @dev Adds single address to whitelist.
285    * @param _beneficiary Address to be added to the whitelist
286    */
287   function addToWhitelist(address _beneficiary) external onlyOwner {
288     whitelist[_beneficiary] = true;
289     emit AddWhiteList(_beneficiary);
290   }
291   
292   /**
293    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
294    * @param _beneficiaries Addresses to be added to the whitelist
295    */
296   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
297     for (uint256 i = 0; i < _beneficiaries.length; i++) {
298       whitelist[_beneficiaries[i]] = true;
299     }
300   }
301 
302   /**
303    * @dev Removes single address from whitelist. 
304    * @param _beneficiary Address to be removed to the whitelist
305    */
306   function removeFromWhitelist(address _beneficiary) external onlyOwner {
307     whitelist[_beneficiary] = false;
308     emit DelWhiteList(_beneficiary);
309   }
310 
311 }
312 
313 
314 /**
315  * @title LinCrowdSale
316  */
317  
318 contract LinCrowdSale is LinTokenMint, WhitelistedCrowdsale {
319     
320     /**
321      * @dev Calculate date in seconds.
322      */
323    
324     uint constant Month = 60*60*24*30;
325     uint constant SixMonth = 6 * Month;
326     uint constant Year = 12 * Month;
327     
328     /**
329      * @dev Set sales start time and end time.
330      */
331     
332     uint public StartTime = now;
333     uint public EndTime = StartTime + SixMonth;
334 
335     /**
336      * @dev Set private Sale EndTime and PreSale EndTime.
337      */
338 
339     uint public PrivateSaleEndTime = StartTime.add(Month*3);
340     uint public PreSaleEndTime = PrivateSaleEndTime.add(Month);
341     
342      /**
343      * @dev Flag value to check when SoftCapReached, HardCapReached, SaleClosed is achieved.
344      */
345     
346     bool public SoftCapReached = false;
347     bool public HardCapReached = false;
348     bool public SaleClosed = false;
349     
350     bool private rentrancy_lock = false; // prevent certain functions from being recursively called
351     
352     uint public constant Private_rate = 2000; // The ratio of LIN to Ether; 40% bonus
353     uint public constant Pre_rate = 1500; //  The ratio of LIN to Ether; 20%
354     uint public constant Public = 1200; //  The ratio of LIN to Ether; 0% bonus
355     
356 
357     uint public MinInvestMent = 2 * (10 ** decimals); // The minimum investment is 2 eth
358     uint public HardCap = 500000000 * (10 ** decimals);  // Set hardcap number   =  500000000
359     uint public SoftCap =  10000000 * (10 ** decimals); // Set softcap number   =   10000000
360     
361     /**
362      * @dev Check total quantity of total amount eth, sale amount lin, refund amount.
363      */
364      
365     uint public TotalAmountETH;
366     uint public SaleAmountLIN;
367     uint public RefundAmount;
368     
369     uint public InvestorNum;    // check total inverstor number
370     
371     
372     /**
373      * @dev Providing information by inserting events into all functions.
374      */
375      
376     event SuccessCoreAccount(uint256 InvestorNum);
377     event Burn(address burner, uint256 value);
378     event SuccessInvestor(address RequestAddress, uint256 amount);
379     event SuccessSoftCap(uint256 SaleAmountLin, uint256 time);
380     event SuccessHardCap(uint256 SaleAmountLin, uint256 time);
381     event SucessWithdraw(address who, uint256 AmountEth, uint256 time);
382     event SuccessEthToOwner(address owner, uint256 AmountEth, uint256 time);
383     
384     event linTokenToInvestors(address InverstorAddress, uint256 Amount, uint256 now);
385     event linTokenToCore(address CoreAddress, uint256 Amount, uint256 now);
386     event FailsafeWithdrawal(address InverstorAddress, uint256 Amount, uint256 now);
387     event FaillinTokenToInvestors(address InverstorAddress, uint256 Amount, uint256 now, uint256 ReleaseTime);
388     event FaillinTokenToCore(address CoreAddress, uint256 Amount, uint256 now, uint256 ReleaseTime);
389     event FailEthToOwner(address who, uint256 _amount, uint256 now);
390     event safeWithdrawalTry(address who);
391 
392 
393     /**
394      * @dev Check whether the specified time is satisfied.
395      */
396     modifier beforeDeadline()   { require (now < EndTime); _; }
397     modifier afterDeadline()    { require (now >= EndTime); _; }
398     modifier afterStartTime()   { require (now >= StartTime); _; }
399     modifier saleNotClosed()    { require (!SaleClosed); _; }
400     
401     
402     /**
403      * @dev Prevent reentrant attacks.
404      */
405      
406     modifier nonReentrant() {
407 
408         require(!rentrancy_lock);
409 
410         rentrancy_lock = true;
411 
412         _;
413 
414         rentrancy_lock = false;
415 
416     }
417     
418     /**
419      * @dev Set investor structure.
420      */
421      
422     struct Investor {
423     
424     	uint256 EthAmount;
425     	uint256 LinTokenAmount;
426     	uint256 LockupTime;
427     	bool    LinTokenWithdraw;
428     	
429     }
430     
431     
432     mapping (address => Investor) public Inverstors;    // Investor structure connector
433     mapping (uint256 => address) public InverstorList;  // Investor list connector
434     
435     
436     constructor() public {
437         
438         /**
439          * @dev Initial information setting of core members.
440          */
441      
442         Inverstors[LinNetOperation].EthAmount = 0;
443         Inverstors[LinNetOperation].LockupTime = Year;
444         Inverstors[LinNetOperation].LinTokenAmount = LinNetOperationSupply;
445         Inverstors[LinNetOperation].LinTokenWithdraw = false; 
446         InverstorList[InvestorNum] = LinNetOperation;
447         InvestorNum++;
448         
449         Inverstors[LinTeam].EthAmount = 0;
450         Inverstors[LinTeam].LockupTime = Year;
451         Inverstors[LinTeam].LinTokenAmount = LinTeamSupply;
452         Inverstors[LinTeam].LinTokenWithdraw = false; 
453         InverstorList[InvestorNum] = LinTeam;
454         InvestorNum++;
455         
456         Inverstors[SympoSium].EthAmount = 0;
457         Inverstors[SympoSium].LockupTime = Year;
458         Inverstors[SympoSium].LinTokenAmount = SympoSiumSupply;
459         Inverstors[SympoSium].LinTokenWithdraw = false; 
460         InverstorList[InvestorNum] = SympoSium;
461         InvestorNum++;
462         
463         Inverstors[Bounty].EthAmount = 0;
464         Inverstors[Bounty].LockupTime = Month.mul(4);
465         Inverstors[Bounty].LinTokenAmount = BountySupply;
466         Inverstors[Bounty].LinTokenWithdraw = false; 
467         InverstorList[InvestorNum] = Bounty;
468         InvestorNum++;
469         
470         Inverstors[preICO].EthAmount = 0;
471         Inverstors[preICO].LockupTime = Year;
472         Inverstors[preICO].LinTokenAmount = preICOSupply;
473         Inverstors[preICO].LinTokenWithdraw = false; 
474         InverstorList[InvestorNum] = preICO;
475         InvestorNum++;
476         
477         emit SuccessCoreAccount(InvestorNum);
478         
479     }
480     
481     
482     /**
483      * @dev It is automatically operated when depositing the eth.
484      *  Set the minimum amount to a MinInvestMent
485      */
486     
487     function() payable public isWhitelisted(msg.sender) whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
488          
489         require(msg.value >= MinInvestMent);    // Check if minimum amount satisfies
490 
491         uint amount = msg.value;    // Assign investment amount
492         
493         uint CurrentTime = now; // Assign Current time
494         
495         address RequestAddress = msg.sender;    // Investor address assignment
496         
497         uint rate;  // Token quantity variable
498         
499         uint CurrentInvestMent = Inverstors[RequestAddress].EthAmount;  // Allocated eth allocation so far
500 
501 
502         Inverstors[RequestAddress].EthAmount = CurrentInvestMent.add(amount);   // Updated eth investment
503 
504         Inverstors[RequestAddress].LockupTime = StartTime.add(SixMonth); // Set lockup time to trade tokens
505         
506         Inverstors[RequestAddress].LinTokenWithdraw = false;    // Confirm whether the token is withdrawn after unlocking
507         
508         TotalAmountETH = TotalAmountETH.add(amount); // Total investment of all investors eth Quantity
509         
510        
511         /**
512          * @dev Bonus Quantity Variable Setting Logic
513          */
514        
515         if(CurrentTime<PrivateSaleEndTime) {
516             
517             rate = Private_rate;
518             
519         } else if(CurrentTime<PreSaleEndTime) {
520             
521             rate = Pre_rate;
522             
523         } else {
524             
525             rate = Public;
526             
527         }
528 
529 
530         uint NumLinToken = amount.mul(rate);    // Lin token Quantity assignment
531         
532         ICOSupply = ICOSupply.sub(NumLinToken); // Decrease in ICOSupply quantity
533         
534         
535         if(ICOSupply > 0) {     
536         
537         //  Update investor's lean token
538         Inverstors[RequestAddress].LinTokenAmount =  Inverstors[RequestAddress].LinTokenAmount.add(NumLinToken);
539         
540         SaleAmountLIN = SaleAmountLIN.add(NumLinToken); // Total amount of lin tokens sold
541         
542         CheckHardCap(); // Execute hard cap check function
543         
544         CheckSoftCap(); // Execute soft cap check function
545         
546         InverstorList[InvestorNum] = RequestAddress;    // Assign the investor address to the current index
547         
548         InvestorNum++;  // Increase number of investors
549         
550         emit SuccessInvestor(msg.sender, msg.value);    // Investor Information event print
551         
552         } else {
553 
554             revert();   // If ICOSupply is less than 0, revert
555              
556         }
557     }
558         
559     /**
560      * @dev If it is a hard cap, set the flag to true and print the event
561      */
562          
563     function CheckHardCap() internal {
564 
565         if (!HardCapReached) {
566 
567             if (SaleAmountLIN >= HardCap) {
568 
569                 HardCapReached = true;
570 
571                 SaleClosed = true;
572                 
573                 emit SuccessSoftCap(SaleAmountLIN, now);
574 
575             }
576         }
577     }   
578     
579     /**
580      * @dev If it is a soft cap, set the flag to true and print the event
581      */
582      
583     function CheckSoftCap() internal {
584 
585         if (!SoftCapReached) {
586 
587             if (SaleAmountLIN >= SoftCap) {
588 
589                 SoftCapReached = true;
590                 
591                 emit SuccessHardCap(SaleAmountLIN, now);
592 
593             } 
594         }
595     }  
596  
597     /**
598      * @dev If the soft cap fails, return the investment and print the event
599      */
600      
601     function safeWithdrawal() external afterDeadline nonReentrant {
602 
603         if (!SoftCapReached) {
604 
605             uint amount = Inverstors[msg.sender].EthAmount;
606             
607             Inverstors[msg.sender].EthAmount = 0;
608             
609 
610             if (amount > 0) {
611 
612                 msg.sender.transfer(amount);
613 
614                 RefundAmount = RefundAmount.add(amount);
615 
616                 emit SucessWithdraw(msg.sender, amount, now);
617 
618             } else { 
619                 
620                 emit FailsafeWithdrawal(msg.sender, amount, now);
621                 
622                 revert(); 
623                 
624             }
625 
626         } else {
627             
628             emit safeWithdrawalTry(msg.sender);
629             
630         } 
631 
632     }
633     
634     /**
635      * @dev send owner's funds to the ICO owner - after ICO
636      */
637      
638     function transferEthToOwner(uint256 _amount) public onlyOwner afterDeadline nonReentrant { 
639         
640         if(SoftCapReached) {
641             
642             owner.transfer(_amount); 
643         
644             emit SuccessEthToOwner(msg.sender, _amount, now);
645         
646         } else {
647             
648             emit FailEthToOwner(msg.sender, _amount, now);
649             
650         }   
651 
652     }
653     
654     
655     /**
656      * @dev Burns a specific amount of tokens.
657      * @param _value The amount of token to be burned.
658      */
659      
660     function burn(uint256 _value) public onlyOwner afterDeadline nonReentrant {
661         
662         require(_value <= ICOSupply);
663 
664         address burner = msg.sender;
665         
666         ICOSupply = ICOSupply.sub(_value);
667         
668         totalSupply = totalSupply.sub(_value);
669         
670         emit Burn(burner, _value);
671         
672      }
673      
674     /**
675      * @dev After the lockout time, the tokens are paid to investors.
676      */
677      
678     function LinTokenToInvestors() public onlyOwner afterDeadline nonReentrant {
679         
680         require(SoftCapReached);
681 
682         for(uint256 i=5; i<InvestorNum; i++) {
683                 
684             uint256 ReleaseTime = Inverstors[InverstorList[i]].LockupTime;
685             
686             address InverstorAddress = InverstorList[i];
687             
688             uint256 Amount = Inverstors[InverstorAddress].LinTokenAmount;
689                
690                 
691             if(now>ReleaseTime && Amount>0) {
692                     
693                 balances[InverstorAddress] = Amount;
694                     
695                 Inverstors[InverstorAddress].LinTokenAmount = Inverstors[InverstorAddress].LinTokenAmount.sub(Amount);
696                     
697                 Inverstors[InverstorAddress].LinTokenWithdraw = true;
698                 
699                 emit linTokenToInvestors(InverstorAddress, Amount, now);
700                 
701             } else {
702                 
703                 emit FaillinTokenToInvestors(InverstorAddress, Amount, now, ReleaseTime);
704                 
705                 revert();
706             }
707                 
708         }
709   
710     }
711   
712     /**
713      * @dev After the lockout time, the tokens are paid to Core.
714      */
715   
716     function LinTokenToCore() public onlyOwner afterDeadline nonReentrant {
717         
718         require(SoftCapReached);
719 
720         for(uint256 i=0; i<5; i++) {
721                 
722             uint256 ReleaseTime = Inverstors[InverstorList[i]].LockupTime;
723             
724             address CoreAddress = InverstorList[i];
725             
726             uint256 Amount = Inverstors[CoreAddress].LinTokenAmount;
727             
728                 
729             if(now>ReleaseTime && Amount>0) {
730                     
731                 balances[CoreAddress] = Amount;
732                     
733                 Inverstors[CoreAddress].LinTokenAmount = Inverstors[CoreAddress].LinTokenAmount.sub(Amount);
734                 
735                 Inverstors[CoreAddress].LinTokenWithdraw = true;
736                     
737                 emit linTokenToCore(CoreAddress, Amount, now);
738                 
739             } else {
740                 
741                 emit FaillinTokenToCore(CoreAddress, Amount, now, ReleaseTime);
742                 
743                 revert();
744             }
745                 
746         }
747   
748     }
749   
750 }