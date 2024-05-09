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
233 contract DskTokenMint is ERC223Token {
234     
235     string public constant name = "DONSCOIN";   // Set the name for display purposes
236     string public constant symbol = "DSK";  // Set the symbol for display purposes
237     uint256 public constant decimals = 18;  // 18 decimals is the strongly suggested default, avoid changing it
238     uint256 public constant INITIAL_SUPPLY = 220000000000 * (10 ** uint256(decimals));    // Set the initial supply
239     uint256 public totalSupply = INITIAL_SUPPLY;    // Set the total supply
240     uint256 internal Percent = INITIAL_SUPPLY.div(100); // Set the 1 percent of the total supply
241     
242     uint256 public ICOSupply = Percent.mul(30); // Set the 30 percent of the ico supply
243     uint256 public DonscoinOwnerSupply = Percent.mul(50);
244 	uint256 public DonscoinFreeSupply = Percent.mul(20);
245 	
246     address internal DonscoinOwner = 0x100eAc5b425C1e2527ee55ecdEF2EA2DfA4F904C;  // Set a DonscoinOwner's address
247 	address internal DonscoinFree =  0x1D78eBb12d5f97df80131F024a9152Ff4772CD39;  // Set a DonscoinFree's address
248 
249     event InitSupply(uint256 owner, uint256 DonscoinOwner, uint256 DonscoinFree);
250     
251      /**
252      * @dev The log is output when the contract is distributed.
253      */
254     
255     constructor() public {
256        
257         emit InitSupply(ICOSupply, DonscoinOwnerSupply, DonscoinFreeSupply);
258         
259     }
260     
261 }
262 contract WhitelistedCrowdsale is Ownable {
263 
264     mapping(address => bool) public whitelist;
265 
266     event AddWhiteList(address who);
267     event DelWhiteList(address who);
268 
269     /**
270      * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
271      */
272     modifier isWhitelisted(address _beneficiary) {
273     require(whitelist[_beneficiary]);
274     _;
275     }
276 
277   /**
278    * @dev Adds single address to whitelist.
279    * @param _beneficiary Address to be added to the whitelist
280    */
281   function addToWhitelist(address _beneficiary) external onlyOwner {
282     whitelist[_beneficiary] = true;
283     emit AddWhiteList(_beneficiary);
284   }
285   
286   /**
287    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
288    * @param _beneficiaries Addresses to be added to the whitelist
289    */
290   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
291     for (uint256 i = 0; i < _beneficiaries.length; i++) {
292       whitelist[_beneficiaries[i]] = true;
293     }
294   }
295 
296   /**
297    * @dev Removes single address from whitelist. 
298    * @param _beneficiary Address to be removed to the whitelist
299    */
300   function removeFromWhitelist(address _beneficiary) external onlyOwner {
301     whitelist[_beneficiary] = false;
302     emit DelWhiteList(_beneficiary);
303   }
304 
305 }
306 
307 
308 /**
309  * @title DskCrowdSale
310  */
311  
312 contract DskCrowdSale is DskTokenMint, WhitelistedCrowdsale {
313     
314     /**
315      * @dev Calculate date in seconds.
316      */
317     uint constant Day = 60*60*24;
318     uint constant Month = 60*60*24*30;
319     uint constant SixMonth = 6 * Month;
320     uint constant Year = 12 * Month;
321     
322     /**
323      * @dev Set sales start time and end time.
324      */
325     
326     uint public StartTime = 1548374400;
327     uint public EndTime = StartTime + SixMonth + 32400; // add +9:00
328 
329     /**
330      * @dev Set private Sale EndTime and PreSale EndTime.
331      */
332 
333     uint public PrivateSaleEndTime = StartTime.add(Day * 50);
334     uint public PreSaleEndTime = PrivateSaleEndTime.add(Month*2);
335     
336      /**
337      * @dev Flag value to check when SoftCapReached, HardCapReached, SaleClosed is achieved.
338      */
339     
340     bool public SoftCapReached = false;
341     bool public HardCapReached = false;
342     bool public SaleClosed = false;
343     
344     bool private rentrancy_lock = false; // prevent certain functions from being recursively called
345     
346     uint public constant Private_rate = 43875; // The ratio of DSK to Ether; 30% bonus
347     uint public constant Pre_rate = 38813; //  The ratio of DSK to Ether; 15%
348     uint public constant Public = 35438; //  The ratio of DSK to Ether; 5% bonus
349     
350 
351     uint public MinInvestMent = 2 * (10 ** decimals); // The minimum investment is 2 eth
352     uint public HardCap = 66000000000 * (10 ** uint256(decimals));  // Set hardcap number   =  44000000000
353     uint public SoftCap =  2200000000 * (10 ** uint256(decimals)); // Set softcap number   =    2200000000
354 
355     /**
356      * @dev Check total quantity of total amount eth, sale amount DSK, refund amount.
357      */
358      
359     uint public TotalAmountETH;
360     uint public SaleAmountDSK;
361     uint public RefundAmount;
362     
363     uint public InvestorNum;    // check total inverstor number
364     
365     
366     /**
367      * @dev Providing information by inserting events into all functions.
368      */
369      
370     event SuccessCoreAccount(uint256 InvestorNum);
371     event Burn(address burner, uint256 value);
372     event SuccessInvestor(address RequestAddress, uint256 amount);
373     event SuccessSoftCap(uint256 SaleAmountDsk, uint256 time);
374     event SuccessHardCap(uint256 SaleAmountDsk, uint256 time);
375     event SucessWithdraw(address who, uint256 AmountEth, uint256 time);
376     event SuccessEthToOwner(address owner, uint256 AmountEth, uint256 time);
377     
378     event dskTokenToInvestors(address InverstorAddress, uint256 Amount, uint256 now);
379     event dskTokenToCore(address CoreAddress, uint256 Amount, uint256 now);
380     event FailsafeWithdrawal(address InverstorAddress, uint256 Amount, uint256 now);
381     event FaildskTokenToInvestors(address InverstorAddress, uint256 Amount, uint256 now, uint256 ReleaseTime);
382     event FaildskTokenToCore(address CoreAddress, uint256 Amount, uint256 now, uint256 ReleaseTime);
383     event FailEthToOwner(address who, uint256 _amount, uint256 now);
384     event safeWithdrawalTry(address who);
385 
386 
387     /**
388      * @dev Check whether the specified time is satisfied.
389      */
390     modifier beforeDeadline()   { require (now < EndTime); _; }
391     modifier afterDeadline()    { require (now >= EndTime); _; }
392     modifier afterStartTime()   { require (now >= StartTime); _; }
393     modifier saleNotClosed()    { require (!SaleClosed); _; }
394     
395     
396     /**
397      * @dev Prevent reentrant attacks.
398      */
399      
400     modifier nonReentrant() {
401 
402         require(!rentrancy_lock);
403 
404         rentrancy_lock = true;
405 
406         _;
407 
408         rentrancy_lock = false;
409 
410     }
411     
412     /**
413      * @dev Set investor structure.
414      */
415      
416     struct Investor {
417     
418     	uint256 EthAmount;
419     	uint256 DskTokenAmount;
420     	uint256 LockupTime;
421     	bool    DskTokenWithdraw;
422     	
423     }
424     
425     
426     mapping (address => Investor) public Inverstors;    // Investor structure connector
427     mapping (uint256 => address) public InverstorList;  // Investor list connector
428     
429     
430     constructor() public {
431         
432         /**
433          * @dev Initial information setting of core members.
434          */
435      
436         Inverstors[DonscoinOwner].EthAmount = 0;
437         Inverstors[DonscoinOwner].LockupTime = EndTime;
438         Inverstors[DonscoinOwner].DskTokenAmount = DonscoinOwnerSupply;
439         Inverstors[DonscoinOwner].DskTokenWithdraw = false; 
440         InverstorList[InvestorNum] = DonscoinOwner;
441         InvestorNum++;
442        
443         Inverstors[DonscoinFree].EthAmount = 0;
444         Inverstors[DonscoinFree].LockupTime = StartTime;
445         Inverstors[DonscoinFree].DskTokenAmount = DonscoinFreeSupply;
446         Inverstors[DonscoinFree].DskTokenWithdraw = false; 
447         InverstorList[InvestorNum] = DonscoinFree;
448         InvestorNum++;
449 		
450         emit SuccessCoreAccount(InvestorNum);
451         
452     }
453     
454     
455     /**
456      * @dev It is automatically operated when depositing the eth.
457      *  Set the minimum amount to a MinInvestMent
458      */
459     
460     function() payable public isWhitelisted(msg.sender) whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
461          
462         require(msg.value >= MinInvestMent);    // Check if minimum amount satisfies
463 
464         uint amount = msg.value;    // Assign investment amount
465         
466         uint CurrentTime = now; // Assign Current time
467         
468         address RequestAddress = msg.sender;    // Investor address assignment
469         
470         uint rate;  // Token quantity variable
471         
472         uint CurrentInvestMent = Inverstors[RequestAddress].EthAmount;  // Allocated eth allocation so far
473 
474 
475         Inverstors[RequestAddress].EthAmount = CurrentInvestMent.add(amount);   // Updated eth investment
476 
477         Inverstors[RequestAddress].LockupTime = EndTime; // Set lockup time to trade tokens
478         
479         Inverstors[RequestAddress].DskTokenWithdraw = false;    // Confirm whether the token is withdrawn after unlocking
480         
481         TotalAmountETH = TotalAmountETH.add(amount); // Total investment of all investors eth Quantity
482         
483        
484         /**
485          * @dev Bonus Quantity Variable Setting Logic
486          */
487        
488         if(CurrentTime<PrivateSaleEndTime) {
489             
490             rate = Private_rate;
491             
492         } else if(CurrentTime<PreSaleEndTime) {
493             
494             rate = Pre_rate;
495             
496         } else {
497             
498             rate = Public;
499             
500         }
501 
502 
503         uint NumDskToken = amount.mul(rate);    // Dsk token Quantity assignment
504         
505         ICOSupply = ICOSupply.sub(NumDskToken); // Decrease in ICOSupply quantity
506         
507         
508         if(ICOSupply > 0) {     
509         
510         //  Update investor's lean token
511         Inverstors[RequestAddress].DskTokenAmount =  Inverstors[RequestAddress].DskTokenAmount.add(NumDskToken);
512         
513         SaleAmountDSK = SaleAmountDSK.add(NumDskToken); // Total amount of dsk tokens sold
514         
515         CheckHardCap(); // Execute hard cap check function
516         
517         CheckSoftCap(); // Execute soft cap check function
518         
519         InverstorList[InvestorNum] = RequestAddress;    // Assign the investor address to the current index
520         
521         InvestorNum++;  // Increase number of investors
522         
523         emit SuccessInvestor(msg.sender, msg.value);    // Investor Information event print
524         
525         } else {
526 
527             revert();   // If ICOSupply is less than 0, revert
528              
529         }
530     }
531         
532     /**
533      * @dev If it is a hard cap, set the flag to true and print the event
534      */
535          
536     function CheckHardCap() internal {
537 
538         if (!HardCapReached) {
539 
540             if (SaleAmountDSK >= HardCap) {
541 
542                 HardCapReached = true;
543 
544                 SaleClosed = true;
545                 
546                 emit SuccessSoftCap(SaleAmountDSK, now);
547 
548             }
549         }
550     }   
551     
552     /**
553      * @dev If it is a soft cap, set the flag to true and print the event
554      */
555      
556     function CheckSoftCap() internal {
557 
558         if (!SoftCapReached) {
559 
560             if (SaleAmountDSK >= SoftCap) {
561 
562                 SoftCapReached = true;
563                 
564                 emit SuccessHardCap(SaleAmountDSK, now);
565 
566             } 
567         }
568     }  
569  
570     /**
571      * @dev If the soft cap fails, return the investment and print the event
572      */
573      
574     function safeWithdrawal() external afterDeadline nonReentrant {
575 
576         if (!SoftCapReached) {
577 
578             uint amount = Inverstors[msg.sender].EthAmount;
579             
580             Inverstors[msg.sender].EthAmount = 0;
581             
582 
583             if (amount > 0) {
584 
585                 msg.sender.transfer(amount);
586 
587                 RefundAmount = RefundAmount.add(amount);
588 
589                 emit SucessWithdraw(msg.sender, amount, now);
590 
591             } else { 
592                 
593                 emit FailsafeWithdrawal(msg.sender, amount, now);
594                 
595                  
596                 
597             }
598 
599         } else {
600             
601             emit safeWithdrawalTry(msg.sender);
602             
603         } 
604 
605     }
606     
607     /**
608      * @dev send owner's funds to the ICO owner - after ICO
609      */
610      
611     function transferEthToOwner(uint256 _amount) public onlyOwner afterDeadline nonReentrant { 
612         
613         if(SoftCapReached) {
614             
615             owner.transfer(_amount); 
616         
617             emit SuccessEthToOwner(msg.sender, _amount, now);
618         
619         } else {
620             
621             emit FailEthToOwner(msg.sender, _amount, now);
622             
623         }   
624 
625     }
626     
627     
628     /**
629      * @dev Burns a specific amount of tokens.
630      * @param _value The amount of token to be burned.
631      */
632      
633     function burn(uint256 _value) public onlyOwner afterDeadline nonReentrant {
634         
635         require(_value <= ICOSupply);
636 
637         address burner = msg.sender;
638         
639         ICOSupply = ICOSupply.sub(_value);
640         
641         totalSupply = totalSupply.sub(_value);
642         
643         emit Burn(burner, _value);
644         
645      }
646     
647     function DskToOwner() public onlyOwner afterDeadline nonReentrant {
648         
649         
650         address RequestAddress = msg.sender;
651         
652         Inverstors[RequestAddress].DskTokenAmount =  Inverstors[RequestAddress].DskTokenAmount.add(ICOSupply);
653         
654         ICOSupply = ICOSupply.sub(ICOSupply);
655     }
656     
657 
658     /**
659      * @dev After the lockout time, the tokens are paid to investors.
660      */
661      
662     function DskTokenToInvestors() public onlyOwner afterDeadline nonReentrant {
663         
664         require(SoftCapReached);
665 
666         for(uint256 i=2; i<InvestorNum; i++) {
667                 
668             uint256 ReleaseTime = Inverstors[InverstorList[i]].LockupTime;
669             
670             address InverstorAddress = InverstorList[i];
671             
672             uint256 Amount = Inverstors[InverstorAddress].DskTokenAmount;
673                
674                 
675             if(now>ReleaseTime && Amount>0) {
676                     
677                 balances[InverstorAddress] = balances[InverstorAddress] + Amount;
678                     
679                 Inverstors[InverstorAddress].DskTokenAmount = Inverstors[InverstorAddress].DskTokenAmount.sub(Amount);
680                     
681                 Inverstors[InverstorAddress].DskTokenWithdraw = true;
682                 
683                 emit dskTokenToInvestors(InverstorAddress, Amount, now);
684                 
685             } else {
686                 
687                 emit FaildskTokenToInvestors(InverstorAddress, Amount, now, ReleaseTime);
688                 
689                 
690             }
691                 
692         }
693   
694     }
695   
696     /**
697      * @dev After the lockout time, the tokens are paid to Core.
698      */
699   
700     function DskTokenToCore() public onlyOwner nonReentrant {
701         
702 
703 
704         for(uint256 i=0; i<2; i++) {
705                 
706             uint256 ReleaseTime = Inverstors[InverstorList[i]].LockupTime;
707             
708             address CoreAddress = InverstorList[i];
709             
710             uint256 Amount = Inverstors[CoreAddress].DskTokenAmount;
711             
712                 
713             if(now>ReleaseTime && Amount>0) {
714                     
715                 balances[CoreAddress] = balances[CoreAddress] + Amount;
716                     
717                 Inverstors[CoreAddress].DskTokenAmount = Inverstors[CoreAddress].DskTokenAmount.sub(Amount);
718                 
719                 Inverstors[CoreAddress].DskTokenWithdraw = true;
720                     
721                 emit dskTokenToCore(CoreAddress, Amount, now);
722                 
723             } else {
724                 
725                 emit FaildskTokenToCore(CoreAddress, Amount, now, ReleaseTime);
726                 
727                 
728             }
729                 
730         }
731   
732     }
733   
734 }