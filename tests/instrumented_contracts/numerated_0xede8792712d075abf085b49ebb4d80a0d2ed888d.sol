1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
5     /**
6     * Multiplication with safety check
7     */
8     function Mul(uint256 a, uint256 b) pure internal returns (uint256) {
9       uint256 c = a * b;
10       //check result should not be other wise until a=0
11       assert(a == 0 || c / a == b);
12       return c;
13     }
14 
15     /**
16     * Division with safety check
17     */
18     function Div(uint256 a, uint256 b) pure internal returns (uint256) {
19       // assert(b > 0); // Solidity automatically throws when dividing by 0
20       uint256 c = a / b;
21       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22       return c;
23     }
24 
25     /**
26     * Subtraction with safety check
27     */
28     function Sub(uint256 a, uint256 b) pure internal returns (uint256) {
29       //b must be greater that a as we need to store value in unsigned integer
30       assert(b <= a);
31       return a - b;
32     }
33 
34     /**
35     * Addition with safety check
36     */
37     function Add(uint256 a, uint256 b) pure internal returns (uint256) {
38       uint256 c = a + b;
39       //We need to check result greater than only one number for valid Addition
40       //refer https://ethereum.stackexchange.com/a/15270/16048
41       assert(c >= a);
42       return c;
43     }
44 }
45 
46 /**
47  * Contract "ERC20Basic"
48  * Purpose: Defining ERC20 standard with basic functionality like - CheckBalance and Transfer including Transfer event
49  */
50 contract ERC20Basic {
51 
52   //Give realtime totalSupply of IAC token
53   uint256 public totalSupply;
54 
55   //Get IAC token balance for provided address
56   function balanceOf(address who) view public returns (uint256);
57 
58   //Transfer IAC token to provided address
59   function transfer(address _to, uint256 _value) public returns(bool ok);
60 
61   //Emit Transfer event outside of blockchain for every IAC token transfer
62   event Transfer(address indexed _from, address indexed _to, uint256 _value);
63 }
64 
65 /**
66  * Contract "ERC20"
67  * Purpose: Defining ERC20 standard with more advanced functionality like - Authorize spender to transfer IAC token
68  */
69 contract ERC20 is ERC20Basic {
70 
71   //Get IAC token amount that spender can spend from provided owner's account
72   function allowance(address owner, address spender) public view returns (uint256);
73 
74   //Transfer initiated by spender
75   function transferFrom(address _from, address _to, uint256 _value) public returns(bool ok);
76 
77   //Add spender to authrize for spending specified amount of IAC Token
78   function approve(address _spender, uint256 _value) public returns(bool ok);
79 
80   //Emit event for any approval provided to spender
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
85 /**
86  * Contract "Ownable"
87  * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account
88  */
89 contract Ownable {
90 
91   //owner variable to store contract owner account
92   address public owner;
93 
94   //Constructor for the contract to store owner's account on deployment
95   function Ownable() public {
96     owner = msg.sender;
97   }
98 
99   //modifier to check transaction initiator is only owner
100   modifier onlyOwner() {
101     require (msg.sender == owner);
102       _;
103   }
104 
105   //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
106   function transferOwnership(address newOwner) public onlyOwner {
107     require (newOwner != address(0));
108       owner = newOwner;
109   }
110 
111 }
112 
113 /**
114  * Contract "Pausable"
115  * Purpose: Contract to provide functionality to pause and resume Sale in case of emergency
116  */
117 contract Pausable is Ownable {
118 
119   //flag to indicate whether Sale is paused or not
120   bool public stopped;
121 
122   //Emit event when any change happens in crowdsale state
123   event StateChanged(bool changed);
124 
125   //modifier to continue with transaction only when Sale is not paused
126   modifier stopInEmergency {
127     require(!stopped);
128     _;
129   }
130 
131   //modifier to continue with transaction only when Sale is paused
132   modifier onlyInEmergency {
133     require(stopped);
134     _;
135   }
136 
137   // called by the owner on emergency, pause Sale
138   function emergencyStop() external onlyOwner  {
139     stopped = true;
140     //Emit event when crowdsale state changes
141     StateChanged(true);
142   }
143 
144   // called by the owner on end of emergency, resumes Sale
145   function release() external onlyOwner onlyInEmergency {
146     stopped = false;
147     //Emit event when crowdsale state changes
148     StateChanged(true);
149   }
150 
151 }
152 
153 /**
154  * Contract "IAC"
155  * Purpose: Create IAC token
156  */
157 contract Injii is ERC20, Ownable {
158 
159   using SafeMath for uint256;
160 
161   /* Public variables of the token */
162   //To store name for token
163   string public constant name = "Injii Access Coins";
164 
165   //To store symbol for token
166   string public constant symbol = "IAC";
167 
168   //To store decimal places for token
169   uint8 public constant decimals = 0;
170 
171   //To store decimal version for token
172   string public version = 'v1.0';
173 
174   //flag to indicate whether transfer of IAC Token is allowed or not
175   bool public locked;
176 
177   //map to store IAC Token balance corresponding to address
178   mapping(address => uint256) balances;
179 
180   //To store spender with allowed amount of IAC Token to spend corresponding to IAC Token holder's account
181   mapping (address => mapping (address => uint256)) allowed;
182 
183   //To handle ERC20 short address attack
184   modifier onlyPayloadSize(uint256 size) {
185      require(msg.data.length >= size + 4);
186      _;
187   }
188 
189   // Lock transfer during Sale
190   modifier onlyUnlocked() {
191     require(!locked);
192     _;
193   }
194 
195   //Contructor to define IAC Token properties
196   function Injii() public {
197     // lock the transfer function during Sale
198     locked = true;
199 
200     //initial token supply is 0
201     totalSupply = 0;
202   }
203 
204   //Implementation for transferring IAC Token to provided address
205   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public onlyUnlocked returns (bool){
206 
207     //Check provided IAC Token should not be 0
208     if (_to != address(0) && _value >= 1) {
209       //deduct IAC Token amount from transaction initiator
210       balances[msg.sender] = balances[msg.sender].Sub(_value);
211       //Add IAC Token to balace of target account
212       balances[_to] = balances[_to].Add(_value);
213       //Emit event for transferring IAC Token
214       Transfer(msg.sender, _to, _value);
215       return true;
216     }
217     else{
218       return false;
219     }
220   }
221 
222   //Transfer initiated by spender
223   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public onlyUnlocked returns (bool) {
224 
225     //Check provided IAC Token should not be 0
226     if (_to != address(0) && _from != address(0)) {
227       //Get amount of IAC Token for which spender is authorized
228       var _allowance = allowed[_from][msg.sender];
229       //Add amount of IAC Token in trarget account's balance
230       balances[_to] = balances[_to].Add(_value);
231       //Deduct IAC Token amount from _from account
232       balances[_from] = balances[_from].Sub(_value);
233       //Deduct Authorized amount for spender
234       allowed[_from][msg.sender] = _allowance.Sub(_value);
235       //Emit event for Transfer
236       Transfer(_from, _to, _value);
237       return true;
238     }else{
239       return false;
240     }
241   }
242 
243   //Get IAC Token balance for provided address
244   function balanceOf(address _owner) public view returns (uint256 balance) {
245     return balances[_owner];
246   }
247 
248   //Add spender to authorize for spending specified amount of IAC Token
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     require(_spender != address(0));
251     //do not allow decimals
252     uint256 iacToApprove = _value;
253     allowed[msg.sender][_spender] = iacToApprove;
254     //Emit event for approval provided to spender
255     Approval(msg.sender, _spender, iacToApprove);
256     return true;
257   }
258 
259   //Get IAC Token amount that spender can spend from provided owner's account
260   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
261     return allowed[_owner][_spender];
262   }
263 
264 }
265 
266 contract Metadata {
267     
268     address public owner;
269     
270     mapping (uint => address) registerMap;
271 
272     function Metadata() public {
273         owner = msg.sender;
274         registerMap[0] = msg.sender;
275     }
276 
277     //get contract address by its ID
278     function getAddress (uint addressId) public view returns (address){
279         return registerMap[addressId];
280     }
281 
282     //add or replace contract address by id. This is also the order of deployment
283     //0 = owner
284     //1 = Ecosystem
285     //2 = Crowdsale. This will deploy the token contract also.
286     //3 = Company Inventory
287     function addAddress (uint addressId, address addressContract) public {
288         assert(addressContract != 0x0 );
289         require (owner == msg.sender || owner == tx.origin);
290         registerMap[addressId] = addressContract;
291     }
292 }
293 
294 contract Ecosystem is Ownable{
295 
296 
297     modifier onlyOwner() {
298         require(msg.sender == owner);
299         _;
300     }
301     //variable of type metadata to store metadata contract object
302     Metadata private objMetadata;
303     Crowdsale private objCrowdsale;
304     uint256 constant private ecosystemContractID = 1;
305     uint256 constant private crowdsaleContractID = 2;
306     bool public crowdsaleAddressSet;
307     event TokensReceived(address receivedFrom, uint256 numberOfTokensReceive);
308 
309     //Constructor
310     function Ecosystem(address _metadataContractAddr) public {
311         assert(_metadataContractAddr != address(0));
312         //passing address of meta data contract to metadata type address variable
313         objMetadata = Metadata(_metadataContractAddr);
314         //register this contract in metadata
315         objMetadata.addAddress(ecosystemContractID, this);
316     }
317 
318     function SetCrowdsaleAddress () public onlyOwner {
319         require(!crowdsaleAddressSet);
320         address crowdsaleContractAddress = objMetadata.getAddress(crowdsaleContractID);
321         assert(crowdsaleContractAddress != address(0));
322         objCrowdsale = Crowdsale(crowdsaleContractAddress);
323         crowdsaleAddressSet = true;
324     }
325 
326     function rewardUser(address user, uint256 iacToSend) public onlyOwner{
327         assert(crowdsaleAddressSet);
328         objCrowdsale.transfer(user, iacToSend);
329     }
330 
331     function tokenFallback(address _from, uint _value){
332         TokensReceived(_from, _value);
333     }
334 
335 }
336 
337 contract CompanyInventory is Ownable{
338     using SafeMath for uint256;
339 
340     modifier onlyOwner() {
341         require(msg.sender == owner);
342         _;
343     }
344     //record timestamp when the lock was initiated
345     uint256 public startBlock;
346     //to record how many tokens are unlocked
347     uint256 public unlockedTokens;
348     uint256 public initialReleaseDone = 0;
349     uint256 public secondReleaseDone = 0;
350     uint256 public totalSuppliedAfterLock = 0;
351     uint256 public balance = 0;
352     uint256 public totalSupplyFromInventory;
353     //total number of tokens available in inventory
354     uint256 public totalRemainInInventory;
355     //variable of type metadata to store metadata contract object
356     Metadata private objMetadata;
357     Crowdsale private objCrowdsale;
358     uint256 constant private crowdsaleContractID = 2;
359     uint256 constant private inventoryContractID = 3;
360     //Emit event when tokens are transferred from company inventory
361     event TransferredUnlockedTokens(address addr, uint value, bytes32 comment);
362     //Emit event when any change happens in crowdsale state
363     event StateChanged(bool changed);
364     
365     //constructor
366     function CompanyInventory(address _metadataContractAddr) public {
367         assert(_metadataContractAddr != address(0));
368         //passing address of meta data contract to metadat type address variable
369         objMetadata = Metadata(_metadataContractAddr);
370         objMetadata.addAddress(inventoryContractID, this);
371         objCrowdsale = Crowdsale(objMetadata.getAddress(crowdsaleContractID));
372     }
373     
374     function initiateLocking (uint256 _alreadyTransferredTokens) public {
375         require(msg.sender == objMetadata.getAddress(crowdsaleContractID) && startBlock == 0);
376         startBlock = now;
377         unlockedTokens = 0;
378         balance = objCrowdsale.balanceOf(this);
379         totalSupplyFromInventory = _alreadyTransferredTokens;
380         totalRemainInInventory = balance.Add(_alreadyTransferredTokens).Sub(_alreadyTransferredTokens);
381         StateChanged(true);
382     }
383     
384     function releaseTokens () public onlyOwner {
385         require(startBlock > 0);
386         if(initialReleaseDone == 0){
387             require(now >= startBlock.Add(1 years));
388             unlockedTokens =  balance/2;
389             initialReleaseDone = 1;
390         }
391         else if(secondReleaseDone == 0){
392             require(now >= startBlock.Add(2 years));
393             unlockedTokens = balance;
394             secondReleaseDone = 1;
395         }
396         StateChanged(true);
397     }
398     
399     /*
400     * To enable transferring tokens from company inventory
401     */
402     function TransferFromCompanyInventory(address beneficiary,uint256 iacToCredit,bytes32 comment) onlyOwner external {
403         require(beneficiary != address(0));
404         require(totalSuppliedAfterLock.Add(iacToCredit) <= unlockedTokens);
405         objCrowdsale.transfer(beneficiary,iacToCredit);
406         //Update total supply for IAC Token
407         totalSuppliedAfterLock = totalSuppliedAfterLock.Add(iacToCredit);
408         totalSupplyFromInventory = totalSupplyFromInventory.Add(iacToCredit);
409         //total number of tokens remaining in inventory
410         totalRemainInInventory = totalRemainInInventory.Sub(iacToCredit);
411         // send event for transferring IAC Token on offline payment
412         TransferredUnlockedTokens(beneficiary, iacToCredit, comment);
413         //Emit event when crowdsale state changes
414         StateChanged(true);
415     }
416 }
417 
418 contract Crowdsale is Injii, Pausable {
419     using SafeMath for uint256;
420     //Record the timestamp when sale starts
421     uint256 public startBlock;
422     //No of days for which the complete crowdsale will run
423     uint256 public constant durationCrowdSale = 25 days;
424     //the gap period between ending of primary crowdsale and starting of secondary crowdsale
425     uint256 public constant gapInPrimaryCrowdsaleAndSecondaryCrowdsale = 2 years;
426     //Record the timestamp when sale ends
427     uint256 public endBlock;
428 
429     //maximum number of tokens available in company inventory
430     uint256 public constant maxCapCompanyInventory = 250e6;
431     //Maximum number of tokens in crowdsale = 500M tokens
432     uint256 public constant maxCap = 500e6;
433     uint256 public constant maxCapEcosystem = 250e6;
434     uint256 public constant numberOfTokensToAvail50PercentDiscount = 2e6;
435     uint256 public constant numberOfTokensToAvail25percentDiscount = 5e5;
436     uint256 public constant minimumNumberOfTokens = 2500;
437     uint256 public targetToAchieve;
438 
439     bool public inventoryLocked = false;
440     uint256 public totalSupply;
441     //Total tokens for crowdsale including mint and transfer 
442     uint256 public totalSupplyForCrowdsaleAndMint = 0;
443     //coinbase account where all ethers should go
444     address public coinbase;
445     //To store total number of ETH received
446     uint256 public ETHReceived;
447     //total number of tokens supplied from company inventory
448     uint256 public totalSupplyFromInventory;
449     //total number of tokens available in inventory
450     uint256 public totalRemainInInventory;
451     //number of tokens per ether
452     uint256 public getPrice;
453     // To indicate Sale status
454     //crowdsaleStatus=0 => crowdsale not started
455     //crowdsaleStatus=1 => crowdsale started;
456     //crowdsaleStatus=2 => crowdsale finished
457     uint256 public crowdsaleStatus;
458     //type of CrowdSale:
459     //1 = crowdsale
460     //2 = seconadry crowdsale for remaining tokens
461     uint8 public crowdSaleType;
462     //Emit event on receiving ETH
463     event ReceivedETH(address addr, uint value);
464     //Emit event on transferring IAC Token to user when payment is received in traditional ways
465     event MintAndTransferIAC(address addr, uint value, bytes32 comment);
466     //Emit event when tokens are transferred from company inventory
467     event SuccessfullyTransferedFromCompanyInventory(address addr, uint value, bytes32 comment);
468     //event to log token supplied
469     event TokenSupplied(address indexed beneficiary, uint256 indexed tokens, uint256 value);
470     //Emit event when any change happens in crowdsale state
471     event StateChanged(bool changed);
472 
473     //variable to store object of Metadata contract
474     Metadata private objMetada;
475     Ecosystem private objEcosystem;
476     CompanyInventory private objCompanyInventory;
477     address private ecosystemContractAddress;
478     //ID of Ecosystem contract
479     uint256 constant ecosystemContractID = 1;
480     //ID of this contract
481     uint256 constant private crowdsaleContractID = 2;
482     //ID of company inventory
483     uint256 constant private inventoryContractID = 3;
484 
485     /**
486      * @dev Constuctor of the contract
487      *
488      */
489     function Crowdsale() public {
490         address _metadataContractAddr = 0x8A8473E51D7f562ea773A019d7351A96c419B633;
491         startBlock = 0;
492         endBlock = 0;
493         crowdSaleType = 1;
494         totalSupply = maxCapEcosystem;
495         crowdsaleStatus=0;
496         coinbase = 0xA84196972d6b5796cE523f861CC9E367F739421F;
497         owner = msg.sender;
498         totalSupplyFromInventory=0;
499         totalRemainInInventory = maxCapCompanyInventory;
500         getPrice = 2778;
501         objMetada = Metadata(_metadataContractAddr);
502         ecosystemContractAddress = objMetada.getAddress(ecosystemContractID);
503         assert(ecosystemContractAddress != address(0));
504         objEcosystem = Ecosystem(ecosystemContractAddress);
505         objMetada.addAddress(crowdsaleContractID, this);
506         balances[ecosystemContractAddress] = maxCapEcosystem;
507         targetToAchieve = (50000*100e18)/(12*getPrice);
508     }
509 
510     //Verify if the sender is owner
511     modifier onlyOwner() {
512       require(msg.sender == owner);
513       _;
514     }
515 
516     //Modifier to make sure transaction is happening during sale when it is not stopped
517     modifier respectTimeFrame() {
518       // When contract is deployed, startblock is 0. When sale is started, startBlock should not be zero
519       assert(startBlock != 0 && !stopped && crowdsaleStatus == 1);
520       //check if requirest is made after time is up
521       if(now > endBlock){
522           //tokens cannot be bought after time is up
523           revert();
524       }
525       _;
526     }
527 
528     /**
529      * @dev To upgrade ecosystem contract
530      *
531      */
532     function SetEcosystemContract () public onlyOwner {
533         uint256 balanceOfOldEcosystem = balances[ecosystemContractAddress];
534         balances[ecosystemContractAddress] = 0;
535         //find new address of contract from metadata
536         ecosystemContractAddress = objMetada.getAddress(ecosystemContractID);
537         //update the balance of new contract
538         balances[ecosystemContractAddress] = balanceOfOldEcosystem;
539         assert(ecosystemContractAddress != address(0));
540         objEcosystem = Ecosystem(ecosystemContractAddress);
541     }
542 
543     function GetIACFundAccount() internal view returns (address) {
544         uint remainder = block.number%10;
545         if(remainder==0){
546             return 0x8786DB52D292551f4139a963F79Ce1018d909655;
547         } else if(remainder==1){
548             return 0x11818E22CDc0592F69a22b30CF0182888f315FBC;
549         } else if(remainder==2){
550             return 0x17616b652C3c2eAf2aa82a72Bd2b3cFf40A854fE;
551         } else if(remainder==3){
552             return 0xD433632CA5cAFDa27655b8E536E5c6335343d408;
553         } else if(remainder==4){
554             return 0xb0Dc59A8312D901C250f8975E4d99eAB74D79484;
555         } else if(remainder==5){
556             return 0x0e6B1F7955EF525C2707799963318c49f9Ad7374;
557         } else if(remainder==6){
558             return 0x2fE6C4D2DC0EB71d2ac885F64f029CE78b9F98d9;
559         } else if(remainder==7){
560             return 0x0a7cD1cCc55191F8046D1023340bdfdfa475F267;
561         } else if(remainder==8){
562             return 0x76C40fDFd3284da796851611e7e9e8De0CcA546C;
563         }else {
564             return 0xe4FE5295772997272914447549D570882423A227;
565         }
566   }
567     /*
568     * To start Crowdsale
569     */
570     function startSale() public onlyOwner {
571         assert(startBlock == 0);
572         //record timestamp when sale is started
573         startBlock = now;
574         //change the type of sale to crowdsale
575         crowdSaleType = 1;
576         //Change status of crowdsale to running
577         crowdsaleStatus = 1;
578         //Crowdsale should end after its proper duration when started
579         endBlock = now.Add(durationCrowdSale);
580         //Emit event when crowdsale state changes
581         StateChanged(true);
582     }
583 
584     /*
585     * To start crowdsale after 2 years(gapInPrimaryCrowdsaleAndSecondaryCrowdsale)
586     */
587     function startSecondaryCrowdsale (uint256 durationSecondaryCrowdSale) public onlyOwner {
588       //crowdsale should have been stopped
589       //startBlock should have a value. It show that sale was started at some point of time
590       //endBlock > the duration of crowdsale: this ensures endblock was updated by finalize
591       assert(crowdsaleStatus == 2 && crowdSaleType == 1);
592       if(now > endBlock.Add(gapInPrimaryCrowdsaleAndSecondaryCrowdsale)){
593           //crowdsale status set to "running"
594           crowdsaleStatus = 1;
595           //change the type of CrowdSale
596           crowdSaleType = 2;
597           //Duration is received in days
598           endBlock = now.Add(durationSecondaryCrowdSale * 86400);
599           //Emit event when crowdsale state changes
600           StateChanged(true);
601       }
602       else
603         revert();
604     }
605     
606 
607     /*
608     * To set price for IAC Token per ether
609     */
610     function setPrice(uint _tokensPerEther) public onlyOwner
611     {
612         require( _tokensPerEther != 0);
613         getPrice = _tokensPerEther;
614         targetToAchieve = (50000*100e18)/(12*_tokensPerEther);
615         //Emit event when crowdsale state changes
616         StateChanged(true);
617     }
618 
619     /*
620     * To create and assign IAC Tokens to transaction initiator
621     */
622     function createTokens(address beneficiary) internal stopInEmergency  respectTimeFrame {
623         //Make sure sent Eth is not 0
624         require(msg.value != 0);
625         //Initially count without giving discount
626         uint256 iacToSend = (msg.value.Mul(getPrice))/1e18;
627         //calculate price to avail 50% discount
628         uint256 priceToAvail50PercentDiscount = numberOfTokensToAvail50PercentDiscount.Div(2*getPrice).Mul(1e18);
629         //calculate price of tokens at 25% discount
630         uint256 priceToAvail25PercentDiscount = 3*numberOfTokensToAvail25percentDiscount.Div(4*getPrice).Mul(1e18);
631         //Check if less than minimum number of tokens are bought
632         if(iacToSend < minimumNumberOfTokens){
633             revert();
634         }
635         else if(msg.value >= priceToAvail25PercentDiscount && msg.value < priceToAvail50PercentDiscount){
636             //grant tokens according to 25% discount
637             iacToSend = (((msg.value.Mul(getPrice)).Mul(4)).Div(3))/1e18;
638         }
639         //check if user is eligible for 50% discount
640         else if(msg.value >= priceToAvail50PercentDiscount){
641             //here tokens are given at 50% discount
642             iacToSend = (msg.value.Mul(2*getPrice))/1e18;
643         }
644         //default case: no discount
645         else {
646             iacToSend = (msg.value.Mul(getPrice))/1e18;
647         }
648         //we should not be supplying more tokens than maxCap
649         assert(iacToSend.Add(totalSupplyForCrowdsaleAndMint) <= maxCap);
650         //increase totalSupply
651         totalSupply = totalSupply.Add(iacToSend);
652 
653         totalSupplyForCrowdsaleAndMint = totalSupplyForCrowdsaleAndMint.Add(iacToSend);
654 
655         if(ETHReceived < targetToAchieve){
656             //transfer ether to coinbase account
657             coinbase.transfer(msg.value);
658         }
659         else{
660             GetIACFundAccount().transfer(msg.value);
661         }
662 
663         //store ETHReceived
664         ETHReceived = ETHReceived.Add(msg.value);
665         //Emit event for contribution
666         ReceivedETH(beneficiary,ETHReceived);
667         balances[beneficiary] = balances[beneficiary].Add(iacToSend);
668 
669         TokenSupplied(beneficiary, iacToSend, msg.value);
670         //Emit event when crowdsale state changes
671         StateChanged(true);
672     }
673 
674     /*
675     * To enable owner to mint tokens
676     */
677     function MintAndTransferToken(address beneficiary,uint256 iacToCredit,bytes32 comment) external onlyOwner {
678         //Available after the crowdsale is started
679         assert(crowdsaleStatus == 1 && beneficiary != address(0));
680         //number of tokens to mint should be whole number
681         require(iacToCredit >= 1);
682         //Check whether tokens are available or not
683         assert(totalSupplyForCrowdsaleAndMint <= maxCap);
684         //Check whether the amount of token are available to transfer
685         require(totalSupplyForCrowdsaleAndMint.Add(iacToCredit) <= maxCap);
686         //Update IAC Token balance for beneficiary
687         balances[beneficiary] = balances[beneficiary].Add(iacToCredit);
688         //Update total supply for IAC Token
689         totalSupply = totalSupply.Add(iacToCredit);
690         totalSupplyForCrowdsaleAndMint = totalSupplyForCrowdsaleAndMint.Add(iacToCredit);
691         // send event for transferring IAC Token on offline payment
692         MintAndTransferIAC(beneficiary, iacToCredit, comment);
693         //Emit event when crowdsale state changes
694         StateChanged(true);
695     }
696 
697     /*
698     * To enable transferring tokens from company inventory
699     */
700     function TransferFromCompanyInventory(address beneficiary,uint256 iacToCredit,bytes32 comment) external onlyOwner {
701         //Available after the crowdsale is started
702         assert(startBlock != 0 && beneficiary != address(0));
703         //Check whether tokens are available or not
704         assert(totalSupplyFromInventory <= maxCapCompanyInventory && !inventoryLocked);
705         //number of tokens to transfer should be whole number
706         require(iacToCredit >= 1);
707         //Check whether the amount of token are available to transfer
708         require(totalSupplyFromInventory.Add(iacToCredit) <= maxCapCompanyInventory);
709         //Update IAC Token balance for beneficiary
710         balances[beneficiary] = balances[beneficiary].Add(iacToCredit);
711         //Update total supply for IAC Token
712         totalSupplyFromInventory = totalSupplyFromInventory.Add(iacToCredit);
713         //Update total supply for IAC Token
714         totalSupply = totalSupply.Add(iacToCredit);
715         //total number of tokens remaining in inventory
716         totalRemainInInventory = totalRemainInInventory.Sub(iacToCredit);
717         //send event for transferring IAC Token on offline payment
718         SuccessfullyTransferedFromCompanyInventory(beneficiary, iacToCredit, comment);
719         //Emit event when crowdsale state changes
720         StateChanged(true);
721     }
722 
723     function LockInventory () public onlyOwner {
724         require(startBlock > 0 && now >= startBlock.Add(durationCrowdSale.Add(90 days)) && !inventoryLocked);
725         address inventoryContractAddress = objMetada.getAddress(inventoryContractID);
726         require(inventoryContractAddress != address(0));
727         balances[inventoryContractAddress] = totalRemainInInventory;
728         totalSupply = totalSupply.Add(totalRemainInInventory);
729         objCompanyInventory = CompanyInventory(inventoryContractAddress);
730         objCompanyInventory.initiateLocking(totalSupplyFromInventory);
731         inventoryLocked = true;
732     }
733 
734     /*
735     * Finalize the crowdsale
736     */
737     function finalize() public onlyOwner {
738           //Make sure Sale is running
739           //finalize should be called only if crowdsale is running
740           assert(crowdsaleStatus == 1 && (crowdSaleType == 1 || crowdSaleType == 2));
741           //finalize only if less than minimum number of tokens are left or if time is up
742           assert(maxCap.Sub(totalSupplyForCrowdsaleAndMint) < minimumNumberOfTokens || now >= endBlock);
743           //crowdsale is ended
744           crowdsaleStatus = 2;
745           //update endBlock to the actual ending of crowdsale
746           endBlock = now;
747           //Emit event when crowdsale state changes
748           StateChanged(true);
749     }
750 
751     /*
752     * To enable transfers of IAC Token anytime owner wishes
753     */
754     function unlock() public onlyOwner
755     {
756         //unlock will happen after 90 days of ending of crowdsale
757         //crowdsale itself being of 25 days
758         assert(crowdsaleStatus==2 && now >= startBlock.Add(durationCrowdSale.Add(90 days)));
759         locked = false;
760         //Emit event when crowdsale state changes
761         StateChanged(true);
762     }
763 
764     /**
765      * @dev payable function to accept ether.
766      *
767      */
768     function () public payable {
769         createTokens(msg.sender);
770     }
771 
772    /*
773     * Failsafe drain
774     */
775    function drain() public  onlyOwner {
776         GetIACFundAccount().transfer(this.balance);
777   }
778 }