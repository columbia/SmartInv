1 pragma solidity ^ 0.4.17;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) pure internal returns(uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function sub(uint a, uint b) pure internal returns(uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint a, uint b) pure internal returns(uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 
24 /**
25 * @title Ownable
26 * @dev The Ownable contract has an owner address, and provides basic authorization control
27 * functions, this simplifies the implementation of "user permissions".
28 */
29 contract Ownable {
30     address public owner;
31     
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36     * account.
37     */
38     function Ownable() public {	
39         owner = msg.sender;
40     }
41 
42     /**
43     * @dev Throws if called by any account other than the owner.
44     */
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     /**
51     * @dev Allows the current owner to transfer control of the contract to a newOwner.
52     * @param newOwner The address to transfer ownership to.
53     */
54     function transferOwnership(address newOwner) onlyOwner public {
55         require(newOwner != address(0));
56         OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 
60 }
61 
62 contract Pausable is Ownable {
63     bool public stopped;
64 
65     modifier stopInEmergency {
66         if (stopped) {
67             revert();
68         }
69         _;
70     }
71 
72     modifier onlyInEmergency {
73         if (!stopped) {
74             revert();
75         }
76         _;
77     }
78 
79     // @notice Called by the owner in emergency, triggers stopped state
80     function emergencyStop() external onlyOwner {
81         stopped = true;
82     }
83 
84     /// @notice Called by the owner to end of emergency, returns to normal state
85     function release() external onlyOwner onlyInEmergency {
86         stopped = false;
87     }
88 }
89 
90 
91 contract ERC20 {
92     uint public totalSupply;
93 
94     function balanceOf(address who) public view returns(uint);
95 
96     function allowance(address owner, address spender) public view returns(uint);
97 
98     function transfer(address to, uint value) public returns(bool ok);
99 
100     function transferFrom(address from, address to, uint value) public returns(bool ok);
101 
102     function approve(address spender, uint value) public returns(bool ok);
103 
104     event Transfer(address indexed from, address indexed to, uint value);
105     event Approval(address indexed owner, address indexed spender, uint value);
106 }
107 
108 
109 // @notice Migration Agent interface
110 
111 contract MigrationAgent {
112     function migrateFrom(address _from, uint256 _value) public;
113 }
114 
115 
116 // @notice  Whitelist interface which will hold whitelisted users
117 contract WhiteList is Ownable {
118 
119     function isWhiteListed(address _user) external view returns (bool);        
120 }
121 
122 // @notice contract to control vesting schedule for company and team tokens
123 contract Vesting is Ownable {
124 
125     using SafeMath for uint;
126 
127     uint public teamTokensInitial = 2e25;      // max tokens amount for the team 20,000,000
128     uint public teamTokensCurrent = 0;         // to keep record of distributed tokens so far to the team
129     uint public companyTokensInitial = 15e24;  // max tokens amount for the company 15,000,000
130     uint public companyTokensCurrent = 0;      // to keep record of distributed tokens so far to the company
131     Token public token;                        // token contract
132     uint public dateICOEnded;                  // date when ICO ended updated from the finalizeSale() function
133     uint public dateProductCompleted;          // date when product has been completed
134 
135 
136     event LogTeamTokensTransferred(address indexed receipient, uint amouontOfTokens);
137     event LogCompanyTokensTransferred(address indexed receipient, uint amouontOfTokens);
138 
139 
140     // @notice set the handle of the token contract
141     // @param _token  {Token} address of the token contract
142     // @return  {bool} true if successful
143     function setToken(Token _token) public onlyOwner() returns(bool) {
144         require (token == address(0));  
145         token = _token;
146         return true;
147     }
148 
149     // @notice set the product completion date for release of dev tokens
150     function setProductCompletionDate() external onlyOwner() {
151         dateProductCompleted = now;
152     }
153 
154     // @notice  to release tokens of the team according to vesting schedule
155     // @param _recipient {address} of the recipient of token transfer
156     // @param _tokensToTransfer {uint} amount of tokens to transfer
157     function transferTeamTokens(address _recipient, uint _tokensToTransfer) external onlyOwner() {
158 
159         require(_recipient != 0);       
160         require(now >= 1533081600);  // before Aug 1, 2018 00:00 GMT don't allow on distribution tokens to the team.
161 
162         require(dateProductCompleted > 0);
163         if (now < dateProductCompleted + 1 years)            // first year after product release
164             require(teamTokensCurrent.add(_tokensToTransfer) <= (teamTokensInitial * 30) / 100);
165         else if (now < dateProductCompleted + 2 years)       // second year after product release
166             require(teamTokensCurrent.add(_tokensToTransfer) <= (teamTokensInitial * 60) / 100);
167         else if (now < dateProductCompleted + 3 years)       // third year after product release
168             require(teamTokensCurrent.add(_tokensToTransfer) <= (teamTokensInitial * 80) / 100);
169         else                                                 // fourth year after product release
170             require(teamTokensCurrent.add(_tokensToTransfer) <= teamTokensInitial);
171 
172         teamTokensCurrent = teamTokensCurrent.add(_tokensToTransfer);  // update released token amount
173         
174         if (!token.transfer(_recipient, _tokensToTransfer))
175                 revert();
176 
177         LogTeamTokensTransferred(_recipient, _tokensToTransfer);
178     }
179 
180     // @notice  to release tokens of the company according to vesting schedule
181     // @param _recipient {address} of the recipient of token transfer
182     // @param _tokensToTransfer {uint} amount of tokens to transfer
183     function transferCompanyTokens(address _recipient, uint _tokensToTransfer) external onlyOwner() {
184 
185         require(_recipient != 0);
186         require(dateICOEnded > 0);       
187 
188         if (now < dateICOEnded + 1 years)   // first year
189             require(companyTokensCurrent.add(_tokensToTransfer) <= (companyTokensInitial * 50) / 100);
190         else if (now < dateICOEnded + 2 years) // second year
191             require(companyTokensCurrent.add(_tokensToTransfer) <= (companyTokensInitial * 75) / 100);
192         else                                    // third year                                                                                   
193             require(companyTokensCurrent.add(_tokensToTransfer) <= companyTokensInitial);
194 
195         companyTokensCurrent = companyTokensCurrent.add(_tokensToTransfer);  // update released token amount
196 
197         if (!token.transfer(_recipient, _tokensToTransfer))
198                 revert();
199         LogCompanyTokensTransferred(_recipient, _tokensToTransfer);
200     }
201 }
202 
203 // Presale Smart Contract
204 // This smart contract collects ETH and in return sends tokens to the backers.
205 contract CrowdSale is  Pausable, Vesting {
206 
207     using SafeMath for uint;
208 
209     struct Backer {
210         uint weiReceivedOne; // amount of ETH contributed during first presale
211         uint weiReceivedTwo;  // amount of ETH contributed during second presale
212         uint weiReceivedMain; // amount of ETH contributed during main sale
213         uint tokensSent; // amount of tokens  sent
214         bool claimed;
215         bool refunded;
216     }
217 
218     address public multisig; // Multisig contract that will receive the ETH
219     uint public ethReceivedPresaleOne; // Amount of ETH received in presale one
220     uint public ethReceivedPresaleTwo; // Amount of ETH received in presale two
221     uint public ethReceiveMainSale; // Amount of ETH received in main sale
222     uint public totalTokensSold; // Number of tokens sold to contributors in all campaigns
223     uint public startBlock; // Presale start block
224     uint public endBlock; // Presale end block
225 
226     uint public minInvestment; // Minimum amount to invest    
227     WhiteList public whiteList; // whitelist contract
228     uint public dollarPerEtherRatio; // dollar to ether ratio set at the beginning of main sale
229     uint public returnPercentage;  // percentage to be returned from first presale in case campaign is cancelled
230     Step public currentStep;  // to move through campaigns and set default values
231     uint public minCapTokens;  // minimum amount of tokens to raise for campaign to be successful
232 
233     mapping(address => Backer) public backers; //backer list
234     address[] public backersIndex;  // to be able to iterate through backer list
235     uint public maxCapEth;  // max cap eth
236     uint public maxCapTokens; // max cap tokens
237     uint public claimCount;  // number of contributors claiming tokens
238     uint public refundCount;  // number of contributors receiving refunds
239     uint public totalClaimed;  // total of tokens claimed
240     uint public totalRefunded;  // total of tokens refunded
241     mapping(address => uint) public claimed; // tokens claimed by contributors
242     mapping(address => uint) public refunded; // tokens refunded to contributors
243 
244 
245 
246     // @notice to set and determine steps of crowdsale
247     enum Step {
248         FundingPresaleOne,  // presale 1 mode
249         FundingPresaleTwo,  // presale 2 mode
250         FundingMainSale,    // main ICO
251         Refunding           // refunding
252     }
253 
254 
255     // @notice to verify if action is not performed out of the campaign range
256     modifier respectTimeFrame() {
257         if ((block.number < startBlock) || (block.number > endBlock))
258             revert();
259         _;
260     }
261 
262     // Events
263     event ReceivedETH(address indexed backer, Step indexed step, uint amount);
264     event TokensClaimed(address indexed backer, uint count);
265     event Refunded(address indexed backer, uint amount);
266 
267 
268 
269     // CrowdFunding   {constructor}
270     // @notice fired when contract is crated. Initializes all needed variables for presale 1.
271     function CrowdSale(WhiteList _whiteList, address _multisig) public {
272 
273         require(_whiteList != address(0x0));
274         multisig = _multisig;
275         minInvestment = 10 ether;
276         maxCapEth = 9000 ether;
277         startBlock = 0; // Starting block of the campaign
278         endBlock = 0; // Ending block of the campaign
279         currentStep = Step.FundingPresaleOne;  // initialize to first presale
280         whiteList = _whiteList; // address of white list contract
281         minCapTokens = 6.5e24;  // 10% of maxCapTokens
282     }
283 
284 
285     // @notice return number of  contributors for all campaigns
286     // @return {uint} number of contributors in each campaign and total number
287     function numberOfBackers() public view returns(uint, uint, uint, uint) {
288 
289         uint numOfBackersOne;
290         uint numOfBackersTwo;
291         uint numOfBackersMain;
292 
293         for (uint i = 0; i < backersIndex.length; i++) {
294             Backer storage backer = backers[backersIndex[i]];
295             if (backer.weiReceivedOne > 0)
296                 numOfBackersOne ++;
297             if (backer.weiReceivedTwo > 0)
298                 numOfBackersTwo ++;
299             if (backer.weiReceivedMain > 0)
300                 numOfBackersMain ++;
301             }
302         return ( numOfBackersOne, numOfBackersTwo, numOfBackersMain, backersIndex.length);
303     }
304 
305 
306 
307     // @notice advances the step of campaign to presale 2
308     // contract is deployed in presale 1 mode
309     function setPresaleTwo() public onlyOwner() {
310         currentStep = Step.FundingPresaleTwo;
311         maxCapEth = 60000 ether;
312         minInvestment = 5 ether;
313     }
314 
315     // @notice advances step of campaign to main sale
316     // @param _ratio   - it will be amount of dollars for one ether with two decimals.
317     // two decimals will be passed as next sets of digits. eg. $300.25 will be passed as 30025
318     function setMainSale(uint _ratio) public onlyOwner() {
319 
320         require(_ratio > 0);
321         currentStep = Step.FundingMainSale;
322         dollarPerEtherRatio = _ratio;
323         maxCapTokens = 65e24;
324         minInvestment = 1 ether / 5;  // 0.2 eth
325         totalTokensSold = (dollarPerEtherRatio * ethReceivedPresaleOne) / 48;  // determine amount of tokens to send from first presale
326         totalTokensSold += (dollarPerEtherRatio * ethReceivedPresaleTwo) / 58;  // determine amount of tokens to send from second presale and total it.
327     }
328 
329 
330     // @notice to populate website with status of the sale
331     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint,  bool) {
332 
333         return (startBlock, endBlock, backersIndex.length, ethReceivedPresaleOne, ethReceivedPresaleTwo, ethReceiveMainSale, maxCapTokens,   minInvestment,  stopped);
334     }
335 
336 
337     // {fallback function}
338     // @notice It will call internal function which handles allocation of Ether and calculates tokens.
339     function () public payable {
340         contribute(msg.sender);
341     }
342 
343     // @notice in case refunds are needed, money can be returned to the contract
344     // @param _returnPercentage {uint} percentage of return in respect to first presale. e.g 75% would be passed as 75
345     function fundContract(uint _returnPercentage) external payable onlyOwner() {
346 
347         require(_returnPercentage > 0);
348         require(msg.value == (ethReceivedPresaleOne.mul(_returnPercentage) / 100) + ethReceivedPresaleTwo + ethReceiveMainSale);
349         returnPercentage = _returnPercentage;
350         currentStep = Step.Refunding;
351     }
352 
353     // @notice It will be called by owner to start the sale
354     // block numbers will be calculated based on current block time average.    
355     function start() external onlyOwner() {
356         startBlock = block.number;
357         endBlock = startBlock + 383904; // 4.3*60*24*62 days
358     }
359 
360     // @notice Due to changing average of block time
361     // this function will allow on adjusting duration of campaign closer to the end
362     // allow adjusting campaign length to 70 days, equivalent of 433440 blocks at 4.3 blocks per minute
363     // @param _block  number of blocks representing duration
364     function adjustDuration(uint _block) external onlyOwner() {
365 
366         require(_block <= 433440);  // 4.3×60×24×70 days 
367         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
368         endBlock = startBlock.add(_block);
369     }
370 
371 
372     // @notice It will be called by fallback function whenever ether is sent to it
373     // @param  _contributor {address} address of contributor
374     // @return res {bool} true if transaction was successful
375 
376     function contribute(address _contributor) internal stopInEmergency respectTimeFrame returns(bool res) {
377 
378 
379         require(whiteList.isWhiteListed(_contributor));  // ensure that user is whitelisted
380         Backer storage backer = backers[_contributor];
381         require (msg.value >= minInvestment);  // ensure that min contributions amount is met
382 
383         if (backer.weiReceivedOne == 0 && backer.weiReceivedTwo == 0 && backer.weiReceivedMain == 0)
384             backersIndex.push(_contributor);
385 
386         if (currentStep == Step.FundingPresaleOne) {          
387             backer.weiReceivedOne = backer.weiReceivedOne.add(msg.value);
388             ethReceivedPresaleOne = ethReceivedPresaleOne.add(msg.value); // Update the total Ether received in presale 1
389             require(ethReceivedPresaleOne <= maxCapEth);  // ensure that max cap hasn't been reached
390         }else if (currentStep == Step.FundingPresaleTwo) {           
391             backer.weiReceivedTwo = backer.weiReceivedTwo.add(msg.value);
392             ethReceivedPresaleTwo = ethReceivedPresaleTwo.add(msg.value);  // Update the total Ether received in presale 2
393             require(ethReceivedPresaleOne + ethReceivedPresaleTwo <= maxCapEth);  // ensure that max cap hasn't been reached
394         }else if (currentStep == Step.FundingMainSale) {
395             backer.weiReceivedMain = backer.weiReceivedMain.add(msg.value);
396             ethReceiveMainSale = ethReceiveMainSale.add(msg.value);  // Update the total Ether received in presale 2
397             uint tokensToSend = dollarPerEtherRatio.mul(msg.value) / 62;  // calculate amount of tokens to send for this user 
398             totalTokensSold += tokensToSend;
399             require(totalTokensSold <= maxCapTokens);  // ensure that max cap hasn't been reached
400         }
401         multisig.transfer(msg.value);  // send money to multisignature wallet
402 
403         ReceivedETH(_contributor, currentStep, msg.value); // Register event
404         return true;
405     }
406 
407 
408     // @notice This function will finalize the sale.
409     // It will only execute if predetermined sale time passed or all tokens were sold
410 
411     function finalizeSale() external onlyOwner() {
412         require(dateICOEnded == 0);
413         require(currentStep == Step.FundingMainSale);
414         // purchasing precise number of tokens might be impractical, thus subtract 1000 tokens so finalization is possible
415         // near the end
416         require(block.number >= endBlock || totalTokensSold >= maxCapTokens.sub(1000));
417         require(totalTokensSold >= minCapTokens);
418         
419         companyTokensInitial += maxCapTokens - totalTokensSold; // allocate unsold tokens to the company        
420         dateICOEnded = now;
421         token.unlock();
422     }
423 
424 
425     // @notice this function can be used by owner to update contribution address in case of using address from exchange or incompatible wallet
426     // @param _contributorOld - old contributor address
427     // @param _contributorNew - new contributor address
428     function updateContributorAddress(address _contributorOld, address _contributorNew) public onlyOwner() {
429 
430         Backer storage backerOld = backers[_contributorOld];
431         Backer storage backerNew = backers[_contributorNew];
432 
433         require(backerOld.weiReceivedOne > 0 || backerOld.weiReceivedTwo > 0 || backerOld.weiReceivedMain > 0); // make sure that contribution has been made to the old address
434         require(backerNew.weiReceivedOne == 0 && backerNew.weiReceivedTwo == 0 && backerNew.weiReceivedMain == 0); // make sure that existing address is not used
435         require(backerOld.claimed == false && backerOld.refunded == false);  // ensure that contributor hasn't be refunded or claimed the tokens yet
436 
437         // invalidate old address
438         backerOld.claimed = true;
439         backerOld.refunded = true;
440 
441         // initialize new address
442         backerNew.weiReceivedOne = backerOld.weiReceivedOne;
443         backerNew.weiReceivedTwo = backerOld.weiReceivedTwo;
444         backerNew.weiReceivedMain = backerOld.weiReceivedMain;
445         backersIndex.push(_contributorNew);
446     }
447 
448     // @notice called to send tokens to contributors after ICO.
449     // @param _backer {address} address of beneficiary
450     // @return true if successful
451     function claimTokensForUser(address _backer) internal returns(bool) {        
452 
453         require(dateICOEnded > 0); // allow on claiming of tokens if ICO was successful             
454 
455         Backer storage backer = backers[_backer];
456 
457         require (!backer.refunded); // if refunded, don't allow to claim tokens
458         require (!backer.claimed); // if tokens claimed, don't allow to claim again
459         require (backer.weiReceivedOne > 0 || backer.weiReceivedTwo > 0 || backer.weiReceivedMain > 0);   // only continue if there is any contribution
460 
461         claimCount++;
462         uint tokensToSend = (dollarPerEtherRatio * backer.weiReceivedOne) / 48;  // determine amount of tokens to send from first presale
463         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedTwo) / 58;  // determine amount of tokens to send from second presale
464         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedMain) / 62;  // determine amount of tokens to send from main sale
465 
466         claimed[_backer] = tokensToSend;  // save claimed tokens
467         backer.claimed = true;
468         backer.tokensSent = tokensToSend;
469         totalClaimed += tokensToSend;
470 
471         if (!token.transfer(_backer, tokensToSend))
472             revert(); // send claimed tokens to contributor account
473 
474         TokensClaimed(_backer,tokensToSend);
475         return true;
476     }
477 
478 
479     // @notice contributors can claim tokens after public ICO is finished
480     // tokens are only claimable when token address is available.
481 
482     function claimTokens() external {
483         claimTokensForUser(msg.sender);
484     }
485 
486 
487     // @notice this function can be called by admin to claim user's token in case of difficulties
488     // @param _backer {address} user address to claim tokens for
489     function adminClaimTokenForUser(address _backer) external onlyOwner() {
490         claimTokensForUser(_backer);
491     }
492 
493     // @notice allow refund when ICO failed
494     // In such a case contract will need to be funded.
495     // Until contract is funded this function will throw
496 
497     function refund() external {
498 
499         require(currentStep == Step.Refunding);                                                          
500         require(totalTokensSold < maxCapTokens/2); // ensure that refund is impossible when more than half of the tokens are sold
501 
502         Backer storage backer = backers[msg.sender];
503 
504         require (!backer.claimed); // check if tokens have been allocated already
505         require (!backer.refunded); // check if user has been already refunded
506 
507         uint totalEtherReceived = ((backer.weiReceivedOne * returnPercentage) / 100) + backer.weiReceivedTwo + backer.weiReceivedMain;  // return only e.g. 75% from presale one.
508         assert(totalEtherReceived > 0);
509 
510         backer.refunded = true; // mark contributor as refunded.
511         totalRefunded += totalEtherReceived;
512         refundCount ++;
513         refunded[msg.sender] = totalRefunded;
514 
515         msg.sender.transfer(totalEtherReceived);  // refund contribution
516         Refunded(msg.sender, totalEtherReceived); // log event
517     }
518 
519 
520 
521     // @notice refund non compliant member 
522     // @param _contributor {address} of refunded contributor
523     function refundNonCompliant(address _contributor) payable external onlyOwner() {
524     
525         Backer storage backer = backers[_contributor];
526 
527         require (!backer.claimed); // check if tokens have been allocated already
528         require (!backer.refunded); // check if user has been already refunded
529         backer.refunded = true; // mark contributor as refunded.            
530 
531         uint totalEtherReceived = backer.weiReceivedOne + backer.weiReceivedTwo + backer.weiReceivedMain;
532 
533         require(msg.value == totalEtherReceived); // ensure that exact amount is sent
534         assert(totalEtherReceived > 0);
535 
536         //adjust amounts received
537         ethReceivedPresaleOne -= backer.weiReceivedOne;
538         ethReceivedPresaleTwo -= backer.weiReceivedTwo;
539         ethReceiveMainSale -= backer.weiReceivedMain;
540         
541         totalRefunded += totalEtherReceived;
542         refundCount ++;
543         refunded[_contributor] = totalRefunded;      
544 
545         uint tokensToSend = (dollarPerEtherRatio * backer.weiReceivedOne) / 48;  // determine amount of tokens to send from first presale
546         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedTwo) / 58;  // determine amount of tokens to send from second presale
547         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedMain) / 62;  // determine amount of tokens to send from main sale
548 
549         if(dateICOEnded == 0) {
550             totalTokensSold -= tokensToSend;
551         } else {
552             companyTokensInitial += tokensToSend;
553         }
554 
555         _contributor.transfer(totalEtherReceived);  // refund contribution
556         Refunded(_contributor, totalEtherReceived); // log event
557     }
558 
559     // @notice Failsafe drain to individual wallet
560     function drain() external onlyOwner() {
561         multisig.transfer(this.balance);
562 
563     }
564 
565     // @notice Failsafe token transfer
566     function tokenDrain() external onlyOwner() {
567     if (block.number > endBlock) {
568         if (!token.transfer(multisig, token.balanceOf(this)))
569                 revert();
570         }
571     }
572 }
573 
574 
575 
576 
577 
578 // @notice The token contract
579 contract Token is ERC20,  Ownable {
580 
581     using SafeMath for uint;
582     // Public variables of the token
583     string public name;
584     string public symbol;
585     uint8 public decimals; // How many decimals to show.
586     string public version = "v0.1";
587     uint public totalSupply;
588     uint public initialSupply;
589     bool public locked;
590     address public crowdSaleAddress;
591     address public migrationMaster;
592     address public migrationAgent;
593     uint256 public totalMigrated;
594     address public authorized;
595 
596 
597     mapping(address => uint) public balances;
598     mapping(address => mapping(address => uint)) public allowed;
599 
600     // @notice tokens are locked during the ICO. Allow transfer of tokens after ICO.
601     modifier onlyUnlocked() {
602         if (msg.sender != crowdSaleAddress && locked)
603             revert();
604         _;
605     }
606 
607 
608     // @Notice allow minting of tokens only by authorized users
609     modifier onlyAuthorized() {
610         if (msg.sender != owner && msg.sender != authorized )
611             revert();
612         _;
613     }
614 
615 
616     // @notice The Token constructor
617     // @param _crowdSaleAddress {address} address of crowdsale contract
618     // @param _migrationMaster {address} address of authorized migration person
619     function Token(address _crowdSaleAddress) public {
620 
621         require(_crowdSaleAddress != 0);
622 
623         locked = true;  // Lock the transfer function during the crowdsale
624         initialSupply = 1e26;
625         totalSupply = initialSupply;
626         name = "Narrative"; // Set the name for display purposes
627         symbol = "NRV"; // Set the symbol for display purposes
628         decimals = 18; // Amount of decimals for display purposes
629         crowdSaleAddress = _crowdSaleAddress;
630         balances[crowdSaleAddress] = initialSupply;
631         migrationMaster = owner;
632         authorized = _crowdSaleAddress;
633     }
634 
635     // @notice unlock tokens for trading
636     function unlock() public onlyAuthorized {
637         locked = false;
638     }
639 
640     // @notice lock tokens in case of problems
641     function lock() public onlyAuthorized {
642         locked = true;
643     }
644 
645     // @notice set authorized party
646     // @param _authorized {address} of an individual to get authorization
647     function setAuthorized(address _authorized) public onlyOwner {
648 
649         authorized = _authorized;
650     }
651 
652 
653     // Token migration support: as implemented by Golem
654     event Migrate(address indexed _from, address indexed _to, uint256 _value);
655 
656     /// @notice Migrate tokens to the new token contract.
657     /// @dev Required state: Operational Migration
658     /// @param _value The amount of token to be migrated
659     function migrate(uint256 _value)  external {
660         // Abort if not in Operational Migration state.
661 
662         require (migrationAgent != 0);
663         require(_value > 0);
664         balances[msg.sender] = balances[msg.sender].sub(_value);
665         totalSupply = totalSupply.sub(_value);
666         totalMigrated = totalMigrated.add(_value);
667         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
668         Migrate(msg.sender, migrationAgent, _value);
669     }
670 
671     /// @notice Set address of migration target contract and enable migration
672     /// process.
673     /// @dev Required state: Operational Normal
674     /// @dev State transition: -> Operational Migration
675     /// @param _agent The address of the MigrationAgent contract
676     function setMigrationAgent(address _agent)  external {
677         // Abort if not in Operational Normal state.
678 
679         require(migrationAgent == 0);
680         require(msg.sender == migrationMaster);
681         migrationAgent = _agent;
682     }
683 
684     function setMigrationMaster(address _master) external {
685         require(msg.sender == migrationMaster);
686         require(_master != 0);
687         migrationMaster = _master;
688     }
689 
690     // @notice mint new tokens with max of 197.5 millions
691     // @param _target {address} of receipt
692     // @param _mintedAmount {uint} amount of tokens to be minted
693     // @return  {bool} true if successful
694     function mint(address _target, uint256 _mintedAmount) public onlyAuthorized() returns(bool) {
695         assert(totalSupply.add(_mintedAmount) <= 1975e23);  // ensure that max amount ever minted should not exceed 197.5 million tokens with 18 decimals
696         balances[_target] = balances[_target].add(_mintedAmount);
697         totalSupply = totalSupply.add(_mintedAmount);
698         Transfer(0, _target, _mintedAmount);
699         return true;
700     }
701 
702     // @notice transfer tokens to given address
703     // @param _to {address} address or recipient
704     // @param _value {uint} amount to transfer
705     // @return  {bool} true if successful
706     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
707 
708         require(_to != address(0));
709         require(balances[msg.sender] >= _value);
710         balances[msg.sender] -= _value;
711         balances[_to] += _value;
712         Transfer(msg.sender, _to, _value);
713         return true;
714     }
715 
716 
717     // @notice transfer tokens from given address to another address
718     // @param _from {address} from whom tokens are transferred
719     // @param _to {address} to whom tokens are transferred
720     // @param _value {uint} amount of tokens to transfer
721     // @return  {bool} true if successful
722     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
723 
724         require(_to != address(0));
725         require(balances[_from] >= _value); // Check if the sender has enough
726         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
727         balances[_from] -= _value; // Subtract from the sender
728         balances[_to] += _value; // Add the same to the recipient
729         allowed[_from][msg.sender] -= _value;  // adjust allowed
730         Transfer(_from, _to, _value);
731         return true;
732     }
733 
734     // @notice to query balance of account
735     // @return _owner {address} address of user to query balance
736     function balanceOf(address _owner) public view returns(uint balance) {
737         return balances[_owner];
738     }
739 
740 
741     /**
742     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
743     *
744     * Beware that changing an allowance with this method brings the risk that someone may use both the old
745     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
746     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
747     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
748     * @param _spender The address which will spend the funds.
749     * @param _value The amount of tokens to be spent.
750     */
751     function approve(address _spender, uint _value) public returns(bool) {
752         allowed[msg.sender][_spender] = _value;
753         Approval(msg.sender, _spender, _value);
754         return true;
755     }
756 
757 
758     // @notice to query of allowance of one user to the other
759     // @param _owner {address} of the owner of the account
760     // @param _spender {address} of the spender of the account
761     // @return remaining {uint} amount of remaining allowance
762     function allowance(address _owner, address _spender) public view returns(uint remaining) {
763         return allowed[_owner][_spender];
764     }
765 
766     /**
767     * approve should be called when allowed[_spender] == 0. To increment
768     * allowed value is better to use this function to avoid 2 calls (and wait until
769     * the first transaction is mined)
770     * From MonolithDAO Token.sol
771     */
772     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
773         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
774         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
775         return true;
776     }
777 
778     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
779         uint oldValue = allowed[msg.sender][_spender];
780         if (_subtractedValue > oldValue) {
781             allowed[msg.sender][_spender] = 0;
782         } else {
783             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
784         }
785         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
786         return true;
787     }
788 
789 
790 }