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
243     uint256 public DonscoinOwnerSupply = Percent.mul(70);
244 
245     address internal DonscoinOwner = 0x100eAc5b425C1e2527ee55ecdEF2EA2DfA4F904C ;  // Set a DonscoinOwner's address
246 
247 
248     event InitSupply(uint256 owner, uint256 DonscoinOwner);
249     
250      /**
251      * @dev The log is output when the contract is distributed.
252      */
253     
254     constructor() public {
255        
256         emit InitSupply(ICOSupply, DonscoinOwnerSupply);
257         
258     }
259     
260 }
261 contract WhitelistedCrowdsale is Ownable {
262 
263     mapping(address => bool) public whitelist;
264 
265     event AddWhiteList(address who);
266     event DelWhiteList(address who);
267 
268     /**
269      * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
270      */
271     modifier isWhitelisted(address _beneficiary) {
272     require(whitelist[_beneficiary]);
273     _;
274     }
275 
276   /**
277    * @dev Adds single address to whitelist.
278    * @param _beneficiary Address to be added to the whitelist
279    */
280   function addToWhitelist(address _beneficiary) external onlyOwner {
281     whitelist[_beneficiary] = true;
282     emit AddWhiteList(_beneficiary);
283   }
284   
285   /**
286    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
287    * @param _beneficiaries Addresses to be added to the whitelist
288    */
289   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
290     for (uint256 i = 0; i < _beneficiaries.length; i++) {
291       whitelist[_beneficiaries[i]] = true;
292     }
293   }
294 
295   /**
296    * @dev Removes single address from whitelist. 
297    * @param _beneficiary Address to be removed to the whitelist
298    */
299   function removeFromWhitelist(address _beneficiary) external onlyOwner {
300     whitelist[_beneficiary] = false;
301     emit DelWhiteList(_beneficiary);
302   }
303 
304 }
305 
306 
307 /**
308  * @title DskCrowdSale
309  */
310  
311 contract DskCrowdSale is DskTokenMint, WhitelistedCrowdsale {
312     
313     /**
314      * @dev Calculate date in seconds.
315      */
316     uint constant Day = 60*60*24;
317     uint constant Month = 60*60*24*30;
318     uint constant SixMonth = 6 * Month;
319     uint constant Year = 12 * Month;
320     
321     /**
322      * @dev Set sales start time and end time.
323      */
324     
325     uint public StartTime = 1548374400;
326     uint public EndTime = StartTime + SixMonth + 32400; // add +9:00
327 
328     /**
329      * @dev Set private Sale EndTime and PreSale EndTime.
330      */
331 
332     uint public PrivateSaleEndTime = StartTime.add(Day * 50);
333     uint public PreSaleEndTime = PrivateSaleEndTime.add(Month*2);
334     
335      /**
336      * @dev Flag value to check when SoftCapReached, HardCapReached, SaleClosed is achieved.
337      */
338     
339     bool public SoftCapReached = false;
340     bool public HardCapReached = false;
341     bool public SaleClosed = false;
342     
343     bool private rentrancy_lock = false; // prevent certain functions from being recursively called
344     
345     uint public constant Private_rate = 43875; // The ratio of DSK to Ether; 30% bonus
346     uint public constant Pre_rate = 38813; //  The ratio of DSK to Ether; 15%
347     uint public constant Public = 35438; //  The ratio of DSK to Ether; 5% bonus
348     
349 
350     uint public MinInvestMent = 2 * (10 ** decimals); // The minimum investment is 2 eth
351     uint public HardCap = 66000000000 * (10 ** uint256(decimals));  // Set hardcap number   =  44000000000
352     uint public SoftCap =  2200000000 * (10 ** uint256(decimals)); // Set softcap number   =    2200000000
353 
354     /**
355      * @dev Check total quantity of total amount eth, sale amount DSK, refund amount.
356      */
357      
358     uint public TotalAmountETH;
359     uint public SaleAmountDSK;
360     uint public RefundAmount;
361     
362     uint public InvestorNum;    // check total inverstor number
363     
364     
365     /**
366      * @dev Providing information by inserting events into all functions.
367      */
368      
369     event SuccessCoreAccount(uint256 InvestorNum);
370     event Burn(address burner, uint256 value);
371     event SuccessInvestor(address RequestAddress, uint256 amount);
372     event SuccessSoftCap(uint256 SaleAmountDsk, uint256 time);
373     event SuccessHardCap(uint256 SaleAmountDsk, uint256 time);
374     event SucessWithdraw(address who, uint256 AmountEth, uint256 time);
375     event SuccessEthToOwner(address owner, uint256 AmountEth, uint256 time);
376     
377     event dskTokenToInvestors(address InverstorAddress, uint256 Amount, uint256 now);
378     event dskTokenToCore(address CoreAddress, uint256 Amount, uint256 now);
379     event FailsafeWithdrawal(address InverstorAddress, uint256 Amount, uint256 now);
380     event FaildskTokenToInvestors(address InverstorAddress, uint256 Amount, uint256 now, uint256 ReleaseTime);
381     event FaildskTokenToCore(address CoreAddress, uint256 Amount, uint256 now, uint256 ReleaseTime);
382     event FailEthToOwner(address who, uint256 _amount, uint256 now);
383     event safeWithdrawalTry(address who);
384 
385 
386     /**
387      * @dev Check whether the specified time is satisfied.
388      */
389     modifier beforeDeadline()   { require (now < EndTime); _; }
390     modifier afterDeadline()    { require (now >= EndTime); _; }
391     modifier afterStartTime()   { require (now >= StartTime); _; }
392     modifier saleNotClosed()    { require (!SaleClosed); _; }
393     
394     
395     /**
396      * @dev Prevent reentrant attacks.
397      */
398      
399     modifier nonReentrant() {
400 
401         require(!rentrancy_lock);
402 
403         rentrancy_lock = true;
404 
405         _;
406 
407         rentrancy_lock = false;
408 
409     }
410     
411     /**
412      * @dev Set investor structure.
413      */
414      
415     struct Investor {
416     
417     	uint256 EthAmount;
418     	uint256 DskTokenAmount;
419     	uint256 LockupTime;
420     	bool    DskTokenWithdraw;
421     	
422     }
423     
424     
425     mapping (address => Investor) public Inverstors;    // Investor structure connector
426     mapping (uint256 => address) public InverstorList;  // Investor list connector
427     
428     
429     constructor() public {
430         
431         /**
432          * @dev Initial information setting of core members.
433          */
434      
435         Inverstors[DonscoinOwner].EthAmount = 0;
436         Inverstors[DonscoinOwner].LockupTime = StartTime + (Month*9);
437         Inverstors[DonscoinOwner].DskTokenAmount = DonscoinOwnerSupply;
438         Inverstors[DonscoinOwner].DskTokenWithdraw = false; 
439         InverstorList[InvestorNum] = DonscoinOwner;
440         InvestorNum++;
441        
442         
443         emit SuccessCoreAccount(InvestorNum);
444         
445     }
446     
447     
448     /**
449      * @dev It is automatically operated when depositing the eth.
450      *  Set the minimum amount to a MinInvestMent
451      */
452     
453     function() payable public isWhitelisted(msg.sender) whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
454          
455         require(msg.value >= MinInvestMent);    // Check if minimum amount satisfies
456 
457         uint amount = msg.value;    // Assign investment amount
458         
459         uint CurrentTime = now; // Assign Current time
460         
461         address RequestAddress = msg.sender;    // Investor address assignment
462         
463         uint rate;  // Token quantity variable
464         
465         uint CurrentInvestMent = Inverstors[RequestAddress].EthAmount;  // Allocated eth allocation so far
466 
467 
468         Inverstors[RequestAddress].EthAmount = CurrentInvestMent.add(amount);   // Updated eth investment
469 
470         Inverstors[RequestAddress].LockupTime = StartTime.add(Month*9); // Set lockup time to trade tokens
471         
472         Inverstors[RequestAddress].DskTokenWithdraw = false;    // Confirm whether the token is withdrawn after unlocking
473         
474         TotalAmountETH = TotalAmountETH.add(amount); // Total investment of all investors eth Quantity
475         
476        
477         /**
478          * @dev Bonus Quantity Variable Setting Logic
479          */
480        
481         if(CurrentTime<PrivateSaleEndTime) {
482             
483             rate = Private_rate;
484             
485         } else if(CurrentTime<PreSaleEndTime) {
486             
487             rate = Pre_rate;
488             
489         } else {
490             
491             rate = Public;
492             
493         }
494 
495 
496         uint NumDskToken = amount.mul(rate);    // Dsk token Quantity assignment
497         
498         ICOSupply = ICOSupply.sub(NumDskToken); // Decrease in ICOSupply quantity
499         
500         
501         if(ICOSupply > 0) {     
502         
503         //  Update investor's lean token
504         Inverstors[RequestAddress].DskTokenAmount =  Inverstors[RequestAddress].DskTokenAmount.add(NumDskToken);
505         
506         SaleAmountDSK = SaleAmountDSK.add(NumDskToken); // Total amount of dsk tokens sold
507         
508         CheckHardCap(); // Execute hard cap check function
509         
510         CheckSoftCap(); // Execute soft cap check function
511         
512         InverstorList[InvestorNum] = RequestAddress;    // Assign the investor address to the current index
513         
514         InvestorNum++;  // Increase number of investors
515         
516         emit SuccessInvestor(msg.sender, msg.value);    // Investor Information event print
517         
518         } else {
519 
520             revert();   // If ICOSupply is less than 0, revert
521              
522         }
523     }
524         
525     /**
526      * @dev If it is a hard cap, set the flag to true and print the event
527      */
528          
529     function CheckHardCap() internal {
530 
531         if (!HardCapReached) {
532 
533             if (SaleAmountDSK >= HardCap) {
534 
535                 HardCapReached = true;
536 
537                 SaleClosed = true;
538                 
539                 emit SuccessSoftCap(SaleAmountDSK, now);
540 
541             }
542         }
543     }   
544     
545     /**
546      * @dev If it is a soft cap, set the flag to true and print the event
547      */
548      
549     function CheckSoftCap() internal {
550 
551         if (!SoftCapReached) {
552 
553             if (SaleAmountDSK >= SoftCap) {
554 
555                 SoftCapReached = true;
556                 
557                 emit SuccessHardCap(SaleAmountDSK, now);
558 
559             } 
560         }
561     }  
562  
563     /**
564      * @dev If the soft cap fails, return the investment and print the event
565      */
566      
567     function safeWithdrawal() external afterDeadline nonReentrant {
568 
569         if (!SoftCapReached) {
570 
571             uint amount = Inverstors[msg.sender].EthAmount;
572             
573             Inverstors[msg.sender].EthAmount = 0;
574             
575 
576             if (amount > 0) {
577 
578                 msg.sender.transfer(amount);
579 
580                 RefundAmount = RefundAmount.add(amount);
581 
582                 emit SucessWithdraw(msg.sender, amount, now);
583 
584             } else { 
585                 
586                 emit FailsafeWithdrawal(msg.sender, amount, now);
587                 
588                  
589                 
590             }
591 
592         } else {
593             
594             emit safeWithdrawalTry(msg.sender);
595             
596         } 
597 
598     }
599     
600     /**
601      * @dev send owner's funds to the ICO owner - after ICO
602      */
603      
604     function transferEthToOwner(uint256 _amount) public onlyOwner afterDeadline nonReentrant { 
605         
606         if(SoftCapReached) {
607             
608             owner.transfer(_amount); 
609         
610             emit SuccessEthToOwner(msg.sender, _amount, now);
611         
612         } else {
613             
614             emit FailEthToOwner(msg.sender, _amount, now);
615             
616         }   
617 
618     }
619     
620     
621     /**
622      * @dev Burns a specific amount of tokens.
623      * @param _value The amount of token to be burned.
624      */
625      
626     function burn(uint256 _value) public onlyOwner afterDeadline nonReentrant {
627         
628         require(_value <= ICOSupply);
629 
630         address burner = msg.sender;
631         
632         ICOSupply = ICOSupply.sub(_value);
633         
634         totalSupply = totalSupply.sub(_value);
635         
636         emit Burn(burner, _value);
637         
638      }
639     
640     function DskToOwner() public onlyOwner afterDeadline nonReentrant {
641         
642         
643         address RequestAddress = msg.sender;
644         
645         Inverstors[RequestAddress].DskTokenAmount =  Inverstors[RequestAddress].DskTokenAmount.add(ICOSupply);
646         
647         ICOSupply = ICOSupply.sub(ICOSupply);
648     }
649     
650 
651     /**
652      * @dev After the lockout time, the tokens are paid to investors.
653      */
654      
655     function DskTokenToInvestors() public onlyOwner afterDeadline nonReentrant {
656         
657         require(SoftCapReached);
658 
659         for(uint256 i=1; i<InvestorNum; i++) {
660                 
661             uint256 ReleaseTime = Inverstors[InverstorList[i]].LockupTime;
662             
663             address InverstorAddress = InverstorList[i];
664             
665             uint256 Amount = Inverstors[InverstorAddress].DskTokenAmount;
666                
667                 
668             if(now>ReleaseTime && Amount>0) {
669                     
670                 balances[InverstorAddress] = balances[InverstorAddress] + Amount;
671                     
672                 Inverstors[InverstorAddress].DskTokenAmount = Inverstors[InverstorAddress].DskTokenAmount.sub(Amount);
673                     
674                 Inverstors[InverstorAddress].DskTokenWithdraw = true;
675                 
676                 emit dskTokenToInvestors(InverstorAddress, Amount, now);
677                 
678             } else {
679                 
680                 emit FaildskTokenToInvestors(InverstorAddress, Amount, now, ReleaseTime);
681                 
682                 
683             }
684                 
685         }
686   
687     }
688   
689     /**
690      * @dev After the lockout time, the tokens are paid to Core.
691      */
692   
693     function DskTokenToCore() public onlyOwner afterDeadline nonReentrant {
694         
695         require(SoftCapReached);
696 
697         for(uint256 i=0; i<1; i++) {
698                 
699             uint256 ReleaseTime = Inverstors[InverstorList[i]].LockupTime;
700             
701             address CoreAddress = InverstorList[i];
702             
703             uint256 Amount = Inverstors[CoreAddress].DskTokenAmount;
704             
705                 
706             if(now>ReleaseTime && Amount>0) {
707                     
708                 balances[CoreAddress] = balances[CoreAddress] + Amount;
709                     
710                 Inverstors[CoreAddress].DskTokenAmount = Inverstors[CoreAddress].DskTokenAmount.sub(Amount);
711                 
712                 Inverstors[CoreAddress].DskTokenWithdraw = true;
713                     
714                 emit dskTokenToCore(CoreAddress, Amount, now);
715                 
716             } else {
717                 
718                 emit FaildskTokenToCore(CoreAddress, Amount, now, ReleaseTime);
719                 
720                 
721             }
722                 
723         }
724   
725     }
726   
727 }