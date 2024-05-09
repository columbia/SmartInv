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
129     uint public companyTokensInitial = 30e24;  // max tokens amount for the company 30,000,000
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
275         minInvestment = 100 ether;  // 100 eth
276         maxCapEth = 30000 ether;
277         startBlock = 0; // Starting block of the campaign
278         endBlock = 0; // Ending block of the campaign
279         currentStep = Step.FundingPresaleOne;  // initialize to first presale
280         whiteList = _whiteList; // address of white list contract
281         minCapTokens = 7.5e24;  // 15% of maxCapTokens (50 million)
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
311         minInvestment = 10 ether;  // 10 eth
312     }
313 
314     // @notice advances step of campaign to main sale
315     // @param _ratio   - it will be amount of dollars for one ether with two decimals.
316     // two decimals will be passed as next sets of digits. eg. $300.25 will be passed as 30025
317     function setMainSale(uint _ratio) public onlyOwner() {
318 
319         require(_ratio > 0);
320         currentStep = Step.FundingMainSale;
321         dollarPerEtherRatio = _ratio;
322         maxCapTokens = 50e24;
323         minInvestment = 1 ether / 10;  // 0.1 eth
324         totalTokensSold = (dollarPerEtherRatio * ethReceivedPresaleOne) / 48;  // determine amount of tokens to send from first presale
325         totalTokensSold += (dollarPerEtherRatio * ethReceivedPresaleTwo) / 55;  // determine amount of tokens to send from second presale and total it.
326     }
327 
328 
329     // @notice to populate website with status of the sale
330     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint,  bool) {
331 
332         return (startBlock, endBlock, backersIndex.length, ethReceivedPresaleOne, ethReceivedPresaleTwo, ethReceiveMainSale, maxCapTokens,   minInvestment,  stopped);
333     }
334 
335 
336     // {fallback function}
337     // @notice It will call internal function which handles allocation of Ether and calculates tokens.
338     function () public payable {
339         contribute(msg.sender);
340     }
341 
342     // @notice in case refunds are needed, money can be returned to the contract
343     // @param _returnPercentage {uint} percentage of return in respect to first presale. e.g 75% would be passed as 75
344     function fundContract(uint _returnPercentage) external payable onlyOwner() {
345 
346         require(_returnPercentage > 0);
347         require(msg.value == (ethReceivedPresaleOne.mul(_returnPercentage) / 100) + ethReceivedPresaleTwo + ethReceiveMainSale);
348         returnPercentage = _returnPercentage;
349         currentStep = Step.Refunding;
350     }
351 
352     // @notice It will be called by owner to start the sale
353     // block numbers will be calculated based on current block time average.    
354     function start() external onlyOwner() {
355         startBlock = block.number;
356         endBlock = startBlock + 563472; // 4.3*60*24*91 days
357     }
358 
359     // @notice Due to changing average of block time
360     // this function will allow on adjusting duration of campaign closer to the end
361     // allow adjusting campaign length to 101 days, equivalent of 625392 blocks at 4.3 blocks per minute
362     // @param _block  number of blocks representing duration
363     function adjustDuration(uint _block) external onlyOwner() {
364         // we'll want to set this to a buffer beyond the end of the "expected" end date so that we can extend the sale if needed/desired.
365         require(_block <= 625392);  // 4.3×60×24×101 days
366         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
367         endBlock = startBlock.add(_block);
368     }
369 
370 
371     // @notice It will be called by fallback function whenever ether is sent to it
372     // @param  _contributor {address} address of contributor
373     // @return res {bool} true if transaction was successful
374 
375     function contribute(address _contributor) internal stopInEmergency respectTimeFrame returns(bool res) {
376 
377 
378         require(whiteList.isWhiteListed(_contributor));  // ensure that user is whitelisted
379         Backer storage backer = backers[_contributor];
380         require (msg.value >= minInvestment);  // ensure that min contributions amount is met
381 
382         if (backer.weiReceivedOne == 0 && backer.weiReceivedTwo == 0 && backer.weiReceivedMain == 0)
383             backersIndex.push(_contributor);
384 
385         if (currentStep == Step.FundingPresaleOne) {          
386             backer.weiReceivedOne = backer.weiReceivedOne.add(msg.value);
387             ethReceivedPresaleOne = ethReceivedPresaleOne.add(msg.value); // Update the total Ether received in presale 1
388             require(ethReceivedPresaleOne <= maxCapEth);  // ensure that max cap hasn't been reached
389         }else if (currentStep == Step.FundingPresaleTwo) {           
390             backer.weiReceivedTwo = backer.weiReceivedTwo.add(msg.value);
391             ethReceivedPresaleTwo = ethReceivedPresaleTwo.add(msg.value);  // Update the total Ether received in presale 2
392             require(ethReceivedPresaleOne + ethReceivedPresaleTwo <= maxCapEth);  // ensure that max cap hasn't been reached
393         }else if (currentStep == Step.FundingMainSale) {
394             backer.weiReceivedMain = backer.weiReceivedMain.add(msg.value);
395             ethReceiveMainSale = ethReceiveMainSale.add(msg.value);  // Update the total Ether received in presale 2
396             uint tokensToSend = dollarPerEtherRatio.mul(msg.value) / 62;  // calculate amount of tokens to send for this user 
397             totalTokensSold += tokensToSend;
398             require(totalTokensSold <= maxCapTokens);  // ensure that max cap hasn't been reached
399         }
400         multisig.transfer(msg.value);  // send money to multisignature wallet
401 
402         ReceivedETH(_contributor, currentStep, msg.value); // Register event
403         return true;
404     }
405 
406 
407     // @notice This function will finalize the sale.
408     // It will only execute if predetermined sale time passed or all tokens were sold
409 
410     function finalizeSale() external onlyOwner() {
411         require(dateICOEnded == 0);
412         require(currentStep == Step.FundingMainSale);
413         // purchasing precise number of tokens might be impractical, thus subtract 1000 tokens so finalization is possible
414         // near the end
415         require(block.number >= endBlock || totalTokensSold >= maxCapTokens.sub(1000));
416         require(totalTokensSold >= minCapTokens);
417         
418         companyTokensInitial += maxCapTokens - totalTokensSold; // allocate unsold tokens to the company        
419         dateICOEnded = now;
420         token.unlock();
421     }
422 
423 
424     // @notice this function can be used by owner to update contribution address in case of using address from exchange or incompatible wallet
425     // @param _contributorOld - old contributor address
426     // @param _contributorNew - new contributor address
427     function updateContributorAddress(address _contributorOld, address _contributorNew) public onlyOwner() {
428 
429         Backer storage backerOld = backers[_contributorOld];
430         Backer storage backerNew = backers[_contributorNew];
431 
432         require(backerOld.weiReceivedOne > 0 || backerOld.weiReceivedTwo > 0 || backerOld.weiReceivedMain > 0); // make sure that contribution has been made to the old address
433         require(backerNew.weiReceivedOne == 0 && backerNew.weiReceivedTwo == 0 && backerNew.weiReceivedMain == 0); // make sure that existing address is not used
434         require(backerOld.claimed == false && backerOld.refunded == false);  // ensure that contributor hasn't be refunded or claimed the tokens yet
435 
436         // invalidate old address
437         backerOld.claimed = true;
438         backerOld.refunded = true;
439 
440         // initialize new address
441         backerNew.weiReceivedOne = backerOld.weiReceivedOne;
442         backerNew.weiReceivedTwo = backerOld.weiReceivedTwo;
443         backerNew.weiReceivedMain = backerOld.weiReceivedMain;
444         backersIndex.push(_contributorNew);
445     }
446 
447     // @notice called to send tokens to contributors after ICO.
448     // @param _backer {address} address of beneficiary
449     // @return true if successful
450     function claimTokensForUser(address _backer) internal returns(bool) {        
451 
452         require(dateICOEnded > 0); // allow on claiming of tokens if ICO was successful             
453 
454         Backer storage backer = backers[_backer];
455 
456         require (!backer.refunded); // if refunded, don't allow to claim tokens
457         require (!backer.claimed); // if tokens claimed, don't allow to claim again
458         require (backer.weiReceivedOne > 0 || backer.weiReceivedTwo > 0 || backer.weiReceivedMain > 0);   // only continue if there is any contribution
459 
460         claimCount++;
461         uint tokensToSend = (dollarPerEtherRatio * backer.weiReceivedOne) / 48;  // determine amount of tokens to send from first presale
462         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedTwo) / 55;  // determine amount of tokens to send from second presale
463         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedMain) / 62;  // determine amount of tokens to send from main sale
464 
465         claimed[_backer] = tokensToSend;  // save claimed tokens
466         backer.claimed = true;
467         backer.tokensSent = tokensToSend;
468         totalClaimed += tokensToSend;
469 
470         if (!token.transfer(_backer, tokensToSend))
471             revert(); // send claimed tokens to contributor account
472 
473         TokensClaimed(_backer,tokensToSend);
474         return true;
475     }
476 
477 
478     // @notice contributors can claim tokens after public ICO is finished
479     // tokens are only claimable when token address is available.
480 
481     function claimTokens() external {
482         claimTokensForUser(msg.sender);
483     }
484 
485 
486     // @notice this function can be called by admin to claim user's token in case of difficulties
487     // @param _backer {address} user address to claim tokens for
488     function adminClaimTokenForUser(address _backer) external onlyOwner() {
489         claimTokensForUser(_backer);
490     }
491 
492     // @notice allow refund when ICO failed
493     // In such a case contract will need to be funded.
494     // Until contract is funded this function will throw
495 
496     function refund() external {
497 
498         require(currentStep == Step.Refunding);                                                          
499         require(totalTokensSold < maxCapTokens/2); // ensure that refund is impossible when more than half of the tokens are sold
500 
501         Backer storage backer = backers[msg.sender];
502 
503         require (!backer.claimed); // check if tokens have been allocated already
504         require (!backer.refunded); // check if user has been already refunded
505 
506         uint totalEtherReceived = ((backer.weiReceivedOne * returnPercentage) / 100) + backer.weiReceivedTwo + backer.weiReceivedMain;  // return only e.g. 75% from presale one.
507         assert(totalEtherReceived > 0);
508 
509         backer.refunded = true; // mark contributor as refunded.
510         totalRefunded += totalEtherReceived;
511         refundCount ++;
512         refunded[msg.sender] = totalRefunded;
513 
514         msg.sender.transfer(totalEtherReceived);  // refund contribution
515         Refunded(msg.sender, totalEtherReceived); // log event
516     }
517 
518 
519 
520     // @notice refund non compliant member 
521     // @param _contributor {address} of refunded contributor
522     function refundNonCompliant(address _contributor) payable external onlyOwner() {
523     
524         Backer storage backer = backers[_contributor];
525 
526         require (!backer.claimed); // check if tokens have been allocated already
527         require (!backer.refunded); // check if user has been already refunded
528         backer.refunded = true; // mark contributor as refunded.            
529 
530         uint totalEtherReceived = backer.weiReceivedOne + backer.weiReceivedTwo + backer.weiReceivedMain;
531 
532         require(msg.value == totalEtherReceived); // ensure that exact amount is sent
533         assert(totalEtherReceived > 0);
534 
535         //adjust amounts received
536         ethReceivedPresaleOne -= backer.weiReceivedOne;
537         ethReceivedPresaleTwo -= backer.weiReceivedTwo;
538         ethReceiveMainSale -= backer.weiReceivedMain;
539         
540         totalRefunded += totalEtherReceived;
541         refundCount ++;
542         refunded[_contributor] = totalRefunded;      
543 
544         uint tokensToSend = (dollarPerEtherRatio * backer.weiReceivedOne) / 48;  // determine amount of tokens to send from first presale
545         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedTwo) / 55;  // determine amount of tokens to send from second presale
546         tokensToSend = tokensToSend + (dollarPerEtherRatio * backer.weiReceivedMain) / 62;  // determine amount of tokens to send from main sale
547 
548         if(dateICOEnded == 0) {
549             totalTokensSold -= tokensToSend;
550         } else {
551             companyTokensInitial += tokensToSend;
552         }
553 
554         _contributor.transfer(totalEtherReceived);  // refund contribution
555         Refunded(_contributor, totalEtherReceived); // log event
556     }
557 
558     // @notice Failsafe drain to individual wallet
559     function drain() external onlyOwner() {
560         multisig.transfer(this.balance);
561 
562     }
563 
564     // @notice Failsafe token transfer
565     function tokenDrain() external onlyOwner() {
566     if (block.number > endBlock) {
567         if (!token.transfer(multisig, token.balanceOf(this)))
568                 revert();
569         }
570     }
571 }
572 
573 
574 
575 
576 
577 // @notice The token contract
578 contract Token is ERC20,  Ownable {
579 
580     using SafeMath for uint;
581     // Public variables of the token
582     string public name;
583     string public symbol;
584     uint8 public decimals; // How many decimals to show.
585     string public version = "v0.1";
586     uint public totalSupply;
587     uint public initialSupply;
588     bool public locked;
589     address public crowdSaleAddress;
590     address public migrationMaster;
591     address public migrationAgent;
592     uint256 public totalMigrated;
593     address public authorized;
594 
595 
596     mapping(address => uint) public balances;
597     mapping(address => mapping(address => uint)) public allowed;
598 
599     // @notice tokens are locked during the ICO. Allow transfer of tokens after ICO.
600     modifier onlyUnlocked() {
601         if (msg.sender != crowdSaleAddress && locked)
602             revert();
603         _;
604     }
605 
606 
607     // @Notice allow minting of tokens only by authorized users
608     modifier onlyAuthorized() {
609         if (msg.sender != owner && msg.sender != authorized )
610             revert();
611         _;
612     }
613 
614 
615     // @notice The Token constructor
616     // @param _crowdSaleAddress {address} address of crowdsale contract
617     // @param _migrationMaster {address} address of authorized migration person
618     function Token(address _crowdSaleAddress) public {
619 
620         require(_crowdSaleAddress != 0);
621 
622         locked = true;  // Lock the transfer function during the crowdsale
623         initialSupply = 1e26;
624         totalSupply = initialSupply;
625         name = "Narrative"; // Set the name for display purposes
626         symbol = "NRV"; // Set the symbol for display purposes
627         decimals = 18; // Amount of decimals for display purposes
628         crowdSaleAddress = _crowdSaleAddress;
629         balances[crowdSaleAddress] = initialSupply;
630         migrationMaster = owner;
631         authorized = _crowdSaleAddress;
632     }
633 
634     // @notice unlock tokens for trading
635     function unlock() public onlyAuthorized {
636         locked = false;
637     }
638 
639     // @notice lock tokens in case of problems
640     function lock() public onlyAuthorized {
641         locked = true;
642     }
643 
644     // @notice set authorized party
645     // @param _authorized {address} of an individual to get authorization
646     function setAuthorized(address _authorized) public onlyOwner {
647 
648         authorized = _authorized;
649     }
650 
651 
652     // Token migration support: as implemented by Golem
653     event Migrate(address indexed _from, address indexed _to, uint256 _value);
654 
655     /// @notice Migrate tokens to the new token contract.
656     /// @dev Required state: Operational Migration
657     /// @param _value The amount of token to be migrated
658     function migrate(uint256 _value)  external {
659         // Abort if not in Operational Migration state.
660 
661         require (migrationAgent != 0);
662         require(_value > 0);
663         balances[msg.sender] = balances[msg.sender].sub(_value);
664         totalSupply = totalSupply.sub(_value);
665         totalMigrated = totalMigrated.add(_value);
666         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
667         Migrate(msg.sender, migrationAgent, _value);
668     }
669 
670     /// @notice Set address of migration target contract and enable migration
671     /// process.
672     /// @dev Required state: Operational Normal
673     /// @dev State transition: -> Operational Migration
674     /// @param _agent The address of the MigrationAgent contract
675     function setMigrationAgent(address _agent)  external {
676         // Abort if not in Operational Normal state.
677 
678         require(migrationAgent == 0);
679         require(msg.sender == migrationMaster);
680         migrationAgent = _agent;
681     }
682 
683     function setMigrationMaster(address _master) external {
684         require(msg.sender == migrationMaster);
685         require(_master != 0);
686         migrationMaster = _master;
687     }
688 
689     // @notice mint new tokens with max of 197.5 millions
690     // @param _target {address} of receipt
691     // @param _mintedAmount {uint} amount of tokens to be minted
692     // @return  {bool} true if successful
693     function mint(address _target, uint256 _mintedAmount) public onlyAuthorized() returns(bool) {
694         assert(totalSupply.add(_mintedAmount) <= 1975e23);  // ensure that max amount ever minted should not exceed 197.5 million tokens with 18 decimals
695         balances[_target] = balances[_target].add(_mintedAmount);
696         totalSupply = totalSupply.add(_mintedAmount);
697         Transfer(0, _target, _mintedAmount);
698         return true;
699     }
700 
701     // @notice transfer tokens to given address
702     // @param _to {address} address or recipient
703     // @param _value {uint} amount to transfer
704     // @return  {bool} true if successful
705     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
706 
707         require(_to != address(0));
708         require(balances[msg.sender] >= _value);
709         balances[msg.sender] -= _value;
710         balances[_to] += _value;
711         Transfer(msg.sender, _to, _value);
712         return true;
713     }
714 
715 
716     // @notice transfer tokens from given address to another address
717     // @param _from {address} from whom tokens are transferred
718     // @param _to {address} to whom tokens are transferred
719     // @param _value {uint} amount of tokens to transfer
720     // @return  {bool} true if successful
721     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
722 
723         require(_to != address(0));
724         require(balances[_from] >= _value); // Check if the sender has enough
725         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
726         balances[_from] -= _value; // Subtract from the sender
727         balances[_to] += _value; // Add the same to the recipient
728         allowed[_from][msg.sender] -= _value;  // adjust allowed
729         Transfer(_from, _to, _value);
730         return true;
731     }
732 
733     // @notice to query balance of account
734     // @return _owner {address} address of user to query balance
735     function balanceOf(address _owner) public view returns(uint balance) {
736         return balances[_owner];
737     }
738 
739 
740     /**
741     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
742     *
743     * Beware that changing an allowance with this method brings the risk that someone may use both the old
744     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
745     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
746     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
747     * @param _spender The address which will spend the funds.
748     * @param _value The amount of tokens to be spent.
749     */
750     function approve(address _spender, uint _value) public returns(bool) {
751         allowed[msg.sender][_spender] = _value;
752         Approval(msg.sender, _spender, _value);
753         return true;
754     }
755 
756 
757     // @notice to query of allowance of one user to the other
758     // @param _owner {address} of the owner of the account
759     // @param _spender {address} of the spender of the account
760     // @return remaining {uint} amount of remaining allowance
761     function allowance(address _owner, address _spender) public view returns(uint remaining) {
762         return allowed[_owner][_spender];
763     }
764 
765     /**
766     * approve should be called when allowed[_spender] == 0. To increment
767     * allowed value is better to use this function to avoid 2 calls (and wait until
768     * the first transaction is mined)
769     * From MonolithDAO Token.sol
770     */
771     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
772         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
773         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
774         return true;
775     }
776 
777     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
778         uint oldValue = allowed[msg.sender][_spender];
779         if (_subtractedValue > oldValue) {
780             allowed[msg.sender][_spender] = 0;
781         } else {
782             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
783         }
784         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
785         return true;
786     }
787 
788 
789 }