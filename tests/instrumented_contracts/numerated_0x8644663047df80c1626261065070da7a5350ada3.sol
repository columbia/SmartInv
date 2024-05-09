1 pragma solidity ^ 0.4.17;
2 
3 
4 library SafeMath {
5 
6     function mul(uint a, uint b) internal pure returns(uint) {
7         uint c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function sub(uint a, uint b) internal pure  returns(uint) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function add(uint a, uint b) internal  pure returns(uint) {
18         uint c = a + b;
19         assert(c >= a && c >= b);
20         return c;
21     }
22 }
23 
24 
25 contract ERC20 {
26     uint public totalSupply;
27 
28     function balanceOf(address who) public view returns(uint);
29 
30     function allowance(address owner, address spender) public view returns(uint);
31 
32     function transfer(address to, uint value) public returns(bool ok);
33 
34     function transferFrom(address from, address to, uint value) public returns(bool ok);
35 
36     function approve(address spender, uint value) public returns(bool ok);
37 
38     event Transfer(address indexed from, address indexed to, uint value);
39     event Approval(address indexed owner, address indexed spender, uint value);
40 }
41 
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49 
50     address public owner;
51     
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56     * account.
57     */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63     * @dev Throws if called by any account other than the owner.
64     */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71     * @dev Allows the current owner to transfer control of the contract to a newOwner.
72     * @param newOwner The address to transfer ownership to.
73     */
74     function transferOwnership(address newOwner) onlyOwner public {
75         require(newOwner != address(0));
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 
80 }
81 
82 
83 /**
84  * @title Pausable
85  * @dev Base contract which allows children to implement an emergency stop mechanism.
86  */
87 contract Pausable is Ownable {
88     event Pause();
89     event Unpause();
90 
91     bool public paused = false;
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is not paused.
95    */
96     modifier whenNotPaused() {
97         require(!paused);
98         _;
99     }
100 
101   /**
102    * @dev Modifier to make a function callable only when the contract is paused.
103    */
104     modifier whenPaused() {
105         require(paused);
106         _;
107     }
108 
109   /**
110    * @dev called by the owner to pause, triggers stopped state
111    */
112     function pause() public onlyOwner whenNotPaused {
113         paused = true;
114         Pause();
115     }
116 
117   /**
118    * @dev called by the owner to unpause, returns to normal state
119    */
120     function unpause() public onlyOwner whenPaused {
121         paused = false;
122         Unpause();
123     }
124 }
125 
126 
127 // Whitelist smart contract
128 // This smart contract keeps list of addresses to whitelist
129 contract WhiteList is Ownable {
130     
131     mapping(address => bool) public whiteList;
132     uint public totalWhiteListed; //white listed users number
133 
134     event LogWhiteListed(address indexed user, uint whiteListedNum);
135     event LogWhiteListedMultiple(uint whiteListedNum);
136     event LogRemoveWhiteListed(address indexed user);
137 
138     // @notice it will return status of white listing
139     // @return true if user is white listed and false if is not
140     function isWhiteListed(address _user) external view returns (bool) {
141 
142         return whiteList[_user]; 
143     }
144 
145     // @notice it will remove whitelisted user
146     // @param _contributor {address} of user to unwhitelist
147     function removeFromWhiteList(address _user) external onlyOwner() returns (bool) {
148        
149         require(whiteList[_user] == true);
150         whiteList[_user] = false;
151         totalWhiteListed--;
152         LogRemoveWhiteListed(_user);
153         return true;
154     }
155 
156     // @notice it will white list one member
157     // @param _user {address} of user to whitelist
158     // @return true if successful
159     function addToWhiteList(address _user) external onlyOwner()  returns (bool) {
160 
161         if (whiteList[_user] != true) {
162             whiteList[_user] = true;
163             totalWhiteListed++;
164             LogWhiteListed(_user, totalWhiteListed);            
165         }
166         return true;
167     }
168 
169     // @notice it will white list multiple members
170     // @param _user {address[]} of users to whitelist
171     // @return true if successful
172     function addToWhiteListMultiple(address[] _users) external onlyOwner()  returns (bool) {
173 
174         for (uint i = 0; i < _users.length; ++i) {
175 
176             if (whiteList[_users[i]] != true) {
177                 whiteList[_users[i]] = true;
178                 totalWhiteListed++;                          
179             }           
180         }
181         LogWhiteListedMultiple(totalWhiteListed); 
182         return true;
183     }
184 }
185 
186 
187 // @note this contract can be inherited by Crowdsale and TeamAllocation contracts and
188 // control release of tokens through even time release based on the inputted duration time interval
189 contract TokenVesting is Ownable {
190     using SafeMath for uint;
191 
192     struct TokenHolder {
193         uint weiReceived; // amount of ETH contributed
194         uint tokensToSend; // amount of tokens  sent  
195         bool refunded; // true if user has been refunded       
196         uint releasedAmount; // amount released through vesting schedule
197         bool revoked; // true if right to continue vesting is revoked
198     }
199 
200     event Released(uint256 amount, uint256 tokenDecimals);
201     event ContractUpdated(bool done);
202 
203     uint256 public cliff;  // time in  when vesting should begin
204     uint256 public startCountDown;  // time when countdown starts
205     uint256 public duration; // duration of period in which vesting takes place   
206     Token public token;  // token contract containing tokens
207     mapping(address => TokenHolder) public tokenHolders; //tokenHolder list
208     WhiteList public whiteList; // whitelist contract
209     uint256 public presaleBonus;
210     
211     // @note constructor 
212     /**
213     function TokenVesting(uint256 _start, uint256 _cliff, uint256 _duration) public {   
214          require(_cliff <= _duration);   
215         duration = _duration;
216         cliff = _start.add(_cliff);
217         startCountDown = _start;         
218         ContractUpdated(true);                    
219     }
220     */
221     // @notice Specify address of token contract
222     // @param _tokenAddress {address} address of token contract
223     // @return res {bool}
224     function initilizeVestingAndTokenAndWhiteList(Token _tokenAddress, 
225                                         uint256 _start, 
226                                         uint256 _cliff, 
227                                         uint256 _duration,
228                                         uint256 _presaleBonus, 
229                                         WhiteList _whiteList) external onlyOwner() returns(bool res) {
230         require(_cliff <= _duration);   
231         require(_tokenAddress != address(0));
232         duration = _duration;
233         cliff = _start.add(_cliff);
234         startCountDown = _start;  
235         token = _tokenAddress; 
236         whiteList = _whiteList;
237         presaleBonus = _presaleBonus;
238         ContractUpdated(true);
239         return true;    
240     }
241 
242     // @notice Specify address of token contract
243     // @param _tokenAddress {address} address of token contract
244     // @return res {bool}
245     function initilizeVestingAndToken(Token _tokenAddress, 
246                                         uint256 _start, 
247                                         uint256 _cliff, 
248                                         uint256 _duration,
249                                         uint256 _presaleBonus
250                                         ) external onlyOwner() returns(bool res) {
251         require(_cliff <= _duration);   
252         require(_tokenAddress != address(0));
253         duration = _duration;
254         cliff = _start.add(_cliff);
255         startCountDown = _start;  
256         token = _tokenAddress;        
257         presaleBonus = _presaleBonus;
258         ContractUpdated(true);
259         return true;    
260     }
261 
262     function returnVestingSchedule() external view returns (uint, uint, uint) {
263 
264         return (duration, cliff, startCountDown);
265     }
266 
267     // @note owner can revoke access to continue vesting of tokens
268     // @param _user {address} of user to revoke their right to vesting
269     function revoke(address _user) public onlyOwner() {
270 
271         TokenHolder storage tokenHolder = tokenHolders[_user];
272         tokenHolder.revoked = true; 
273     }
274 
275     function vestedAmountAvailable() public view returns (uint amount, uint decimals) {
276 
277         TokenHolder storage tokenHolder = tokenHolders[msg.sender];
278         uint tokensToRelease = vestedAmount(tokenHolder.tokensToSend);
279 
280      //   if (tokenHolder.releasedAmount + tokensToRelease > tokenHolder.tokensToSend)
281       //      return (tokenHolder.tokensToSend - tokenHolder.releasedAmount, token.decimals());
282      //   else 
283         return (tokensToRelease - tokenHolder.releasedAmount, token.decimals());
284     }
285     
286     // @notice Transfers vested available tokens to beneficiary   
287     function release() public {
288 
289         TokenHolder storage tokenHolder = tokenHolders[msg.sender];        
290         // check if right to vesting is not revoked
291         require(!tokenHolder.revoked);                                   
292         uint tokensToRelease = vestedAmount(tokenHolder.tokensToSend);      
293         uint currentTokenToRelease = tokensToRelease - tokenHolder.releasedAmount;
294         tokenHolder.releasedAmount += currentTokenToRelease;            
295         token.transfer(msg.sender, currentTokenToRelease);
296 
297         Released(currentTokenToRelease, token.decimals());
298     }
299   
300     // @notice this function will determine vested amount
301     // @param _totalBalance {uint} total balance of tokens assigned to this user
302     // @return {uint} amount of tokens available to transfer
303     function vestedAmount(uint _totalBalance) public view returns (uint) {
304 
305         if (now < cliff) {
306             return 0;
307         } else if (now >= startCountDown.add(duration)) {
308             return _totalBalance;
309         } else {
310             return _totalBalance.mul(now.sub(startCountDown)) / duration;
311         }
312     }
313 }
314 
315 
316 // Crowdsale Smart Contract
317 // This smart contract collects ETH and in return sends  tokens to the Backers
318 contract Crowdsale is Pausable, TokenVesting {
319 
320     using SafeMath for uint;
321 
322     address public multisigETH; // Multisig contract that will receive the ETH
323     address public commissionAddress;  // address to deposit commissions
324     uint public tokensForTeam; // tokens for the team
325     uint public ethReceivedPresale; // Number of ETH received in presale
326     uint public ethReceivedMain; // Number of ETH received in main sale
327     uint public totalTokensSent; // Number of tokens sent to ETH contributors
328     uint public tokensSentMain;
329     uint public tokensSentPresale;       
330     uint public tokensSentDev;         
331     uint public startBlock; // Crowdsale start block
332     uint public endBlock; // Crowdsale end block
333     uint public maxCap; // Maximum number of token to sell
334     uint public minCap; // Minimum number of ETH to raise
335     uint public minContributionMainSale; // Minimum amount to contribute in main sale
336     uint public minContributionPresale; // Minimum amount to contribut in presale
337     uint public maxContribution;
338     bool public crowdsaleClosed; // Is crowdsale still on going
339     uint public tokenPriceWei;
340     uint public refundCount;
341     uint public totalRefunded;
342     uint public campaignDurationDays; // campaign duration in days 
343     uint public firstPeriod; 
344     uint public secondPeriod; 
345     uint public thirdPeriod; 
346     uint public firstBonus; 
347     uint public secondBonus;
348     uint public thirdBonus;
349     uint public multiplier;
350     uint public status;    
351     Step public currentStep;  // To allow for controlled steps of the campaign 
352    
353     // Looping through Backer
354     //mapping(address => Backer) public backers; //backer list
355     address[] public holdersIndex;   // to be able to itarate through backers when distributing the tokens
356     address[] public devIndex;   // to be able to itarate through backers when distributing the tokens
357 
358     // @notice to set and determine steps of crowdsale
359     enum Step {      
360         FundingPreSale,     // presale mode
361         FundingMainSale,  // public mode
362         Refunding  // in case campaign failed during this step contributors will be able to receive refunds
363     }
364 
365     // @notice to verify if action is not performed out of the campaing range
366     modifier respectTimeFrame() {
367         if ((block.number < startBlock) || (block.number > endBlock)) 
368             revert();
369         _;
370     }
371 
372     modifier minCapNotReached() {
373         if (totalTokensSent >= minCap) 
374             revert();
375         _;
376     }
377 
378     // Events
379     event LogReceivedETH(address indexed backer, uint amount, uint tokenAmount);
380     event LogStarted(uint startBlockLog, uint endBlockLog);
381     event LogFinalized(bool success);  
382     event LogRefundETH(address indexed backer, uint amount);
383     event LogStepAdvanced();
384     event LogDevTokensAllocated(address indexed dev, uint amount);
385     event LogNonVestedTokensSent(address indexed user, uint amount);
386 
387     // Crowdsale  {constructor}
388     // @notice fired when contract is crated. Initilizes all constnat variables.
389     function Crowdsale(uint _decimalPoints,
390                         address _multisigETH,
391                         uint _toekensForTeam, 
392                         uint _minContributionPresale,
393                         uint _minContributionMainSale,
394                         uint _maxContribution,                        
395                         uint _maxCap, 
396                         uint _minCap, 
397                         uint _tokenPriceWei, 
398                         uint _campaignDurationDays,
399                         uint _firstPeriod, 
400                         uint _secondPeriod, 
401                         uint _thirdPeriod, 
402                         uint _firstBonus, 
403                         uint _secondBonus,
404                         uint _thirdBonus) public {
405         multiplier = 10**_decimalPoints;
406         multisigETH = _multisigETH; 
407         tokensForTeam = _toekensForTeam * multiplier; 
408         minContributionPresale = _minContributionPresale; 
409         minContributionMainSale = _minContributionMainSale;
410         maxContribution = _maxContribution;       
411         maxCap = _maxCap * multiplier;       
412         minCap = _minCap * multiplier;
413         tokenPriceWei = _tokenPriceWei;
414         campaignDurationDays = _campaignDurationDays;
415         firstPeriod = _firstPeriod; 
416         secondPeriod = _secondPeriod; 
417         thirdPeriod = _thirdPeriod;
418         firstBonus = _firstBonus;
419         secondBonus = _secondBonus;
420         thirdBonus = _thirdBonus;       
421         //TODO replace this address below with correct address.
422         commissionAddress = 0x326B5E9b8B2ebf415F9e91b42c7911279d296ea1;
423         //commissionAddress = 0x853A3F142430658A32f75A0dc891b98BF4bDF5c1;
424         currentStep = Step.FundingPreSale; 
425     }
426 
427     // @notice to populate website with status of the sale 
428     function returnWebsiteData() external view returns(uint, 
429         uint, uint, uint, uint, uint, uint, uint, uint, uint, bool, bool, uint, Step) {
430     
431         return (startBlock, endBlock, numberOfBackers(), ethReceivedPresale + ethReceivedMain, maxCap, minCap, 
432                 totalTokensSent, tokenPriceWei, minContributionPresale, minContributionMainSale, 
433                 paused, crowdsaleClosed, token.decimals(), currentStep);
434     }
435     
436     // @notice this function will determine status of crowdsale
437     function determineStatus() external view returns (uint) {
438        
439         if (crowdsaleClosed)            // ICO finihsed
440             return 1;   
441 
442         if (block.number < endBlock && totalTokensSent < maxCap - 100)   // ICO in progress
443             return 2;            
444     
445         if (totalTokensSent < minCap && block.number > endBlock)      // ICO failed    
446             return 3;            
447     
448         if (endBlock == 0)           // ICO hasn't been started yet 
449             return 4;            
450     
451         return 0;         
452     } 
453 
454     // {fallback function}
455     // @notice It will call internal function which handels allocation of Ether and calculates tokens.
456     function () public payable {    
457              
458         contribute(msg.sender);
459     }
460 
461     // @notice to allow for contribution from interface
462     function contributePublic() external payable {
463         contribute(msg.sender);
464     }
465 
466     // @notice set the step of the campaign from presale to public sale
467     // contract is deployed in presale mode
468     // WARNING: there is no way to go back
469     function advanceStep() external onlyOwner() {
470         currentStep = Step.FundingMainSale;
471         LogStepAdvanced();
472     }
473 
474     // @notice It will be called by owner to start the sale    
475     function start() external onlyOwner() {
476         startBlock = block.number;
477         endBlock = startBlock + (4*60*24*campaignDurationDays); // assumption is that one block takes 15 sec. 
478         crowdsaleClosed = false;
479         LogStarted(startBlock, endBlock);
480     }
481 
482     // @notice This function will finalize the sale.
483     // It will only execute if predetermined sale time passed or all tokens are sold.
484     function finalize() external onlyOwner() {
485 
486         require(!crowdsaleClosed);                       
487         require(block.number >= endBlock || totalTokensSent > maxCap - 1000);
488                     // - 1000 is used to allow closing of the campaing when contribution is near 
489                     // finished as exact amount of maxCap might be not feasible e.g. you can't easily buy few tokens. 
490                     // when min contribution is 0.1 Eth.  
491 
492         require(totalTokensSent >= minCap);
493         crowdsaleClosed = true;
494         
495         // transfer commission portion to the platform
496         commissionAddress.transfer(determineCommissions());         
497         
498         // transfer remaning funds to the campaign wallet
499         multisigETH.transfer(this.balance);
500         
501         /*if (!token.transfer(owner, token.balanceOf(this))) 
502             revert(); // transfer tokens to admin account  
503             
504         if (!token.burn(this, token.balanceOf(this))) 
505             revert();  // burn all the tokens remaining in the contract   */
506         token.unlock();    // release lock from transfering tokens. 
507 
508         LogFinalized(true);        
509     }
510 
511     // @notice it will allow contributors to get refund in case campaign failed
512     // @return {bool} true if successful
513     function refund() external whenNotPaused returns (bool) {      
514         
515         uint totalEtherReceived = ethReceivedPresale + ethReceivedMain;
516 
517         require(totalEtherReceived < minCap);  // ensure that campaign failed
518         require(this.balance > 0);  // contract will hold 0 ether at the end of campaign.
519                                     // contract needs to be funded through fundContract() 
520         TokenHolder storage backer = tokenHolders[msg.sender];
521 
522         require(backer.weiReceived > 0);  // ensure that user has sent contribution
523         require(!backer.refunded);        // ensure that user hasn't been refunded yet
524 
525         backer.refunded = true;  // save refund status to true
526         refundCount++;
527         totalRefunded += backer.weiReceived;
528 
529         if (!token.burn(msg.sender, backer.tokensToSend)) // burn tokens
530             revert();        
531         msg.sender.transfer(backer.weiReceived);  // send back the contribution 
532         LogRefundETH(msg.sender, backer.weiReceived);
533         return true;
534     }
535 
536     // @notice allocate tokens to dev/team/advisors
537     // @param _dev {address} 
538     // @param _amount {uint} amount of tokens
539     function devAllocation(address _dev, uint _amount) external onlyOwner() returns (bool) {
540 
541         require(_dev != address(0));
542         require(crowdsaleClosed); 
543         require(totalTokensSent.add(_amount) <= token.totalSupply());
544         devIndex.push(_dev);
545         TokenHolder storage tokenHolder = tokenHolders[_dev];
546         tokenHolder.tokensToSend = _amount;
547         tokensSentDev += _amount;
548         totalTokensSent += _amount;        
549         LogDevTokensAllocated(_dev, _amount); // Register event
550         return true;
551 
552     }
553 
554     // @notice Failsafe drain
555     function drain(uint _amount) external onlyOwner() {
556         owner.transfer(_amount);           
557     }
558 
559     // @notice transfer tokens which are not subject to vesting
560     // @param _recipient {addres}
561     // @param _amont {uint} amount to transfer
562     function transferTokens(address _recipient, uint _amount) external onlyOwner() returns (bool) {
563 
564         require(_recipient != address(0));
565         if (!token.transfer(_recipient, _amount))
566             revert();
567         LogNonVestedTokensSent(_recipient, _amount);
568     }
569 
570     // @notice determine amount of commissions for the platform    
571     function determineCommissions() public view returns (uint) {
572      
573         if (this.balance <= 500 ether) {
574             return (this.balance * 10)/100;
575         }else if (this.balance <= 1000 ether) {
576             return (this.balance * 8)/100;
577         }else if (this.balance < 10000 ether) {
578             return (this.balance * 6)/100;
579         }else {
580             return (this.balance * 6)/100;
581         }
582     }
583 
584     // @notice return number of contributors
585     // @return  {uint} number of contributors
586     function numberOfBackers() public view returns (uint) {
587         return holdersIndex.length;
588     }
589 
590     // @notice It will be called by fallback function whenever ether is sent to it
591     // @param  _backer {address} address of beneficiary
592     // @return res {bool} true if transaction was successful
593     function contribute(address _backer) internal whenNotPaused respectTimeFrame returns(bool res) {
594 
595         //require(msg.value <= maxContribution);
596 
597         if (whiteList != address(0))  // if whitelist initialized verify member whitelist status
598             require(whiteList.isWhiteListed(_backer));  // ensure that user is whitelisted
599           
600         uint tokensToSend = calculateNoOfTokensToSend(); // calculate number of tokens
601 
602         // Ensure that max cap hasn't been reached
603         require(totalTokensSent + tokensToSend <= maxCap);
604         
605         TokenHolder storage backer = tokenHolders[_backer];
606 
607         if (backer.weiReceived == 0)
608             holdersIndex.push(_backer);
609 
610         if (Step.FundingMainSale == currentStep) { // Update the total Ether received and tokens sent during public sale
611             require(msg.value >= minContributionMainSale); // stop when required minimum is not met    
612             ethReceivedMain = ethReceivedMain.add(msg.value);
613             tokensSentMain += tokensToSend;
614         }else {  
615             require(msg.value >= minContributionPresale); // stop when required minimum is not met
616             ethReceivedPresale = ethReceivedPresale.add(msg.value); 
617             tokensSentPresale += tokensToSend;
618         }  
619        
620         backer.tokensToSend += tokensToSend;
621         backer.weiReceived = backer.weiReceived.add(msg.value);       
622         totalTokensSent += tokensToSend;      
623         
624         // tokens are not transferrd to contributors during this phase
625         // tokens will be transferred based on the vesting schedule, when contributor
626         // calls release() function of this contract
627         LogReceivedETH(_backer, msg.value, tokensToSend); // Register event
628         return true;
629     }
630 
631     // @notice This function will return number of tokens based on time intervals in the campaign
632     function calculateNoOfTokensToSend() internal view returns (uint) {
633 
634         uint tokenAmount = msg.value.mul(multiplier) / tokenPriceWei;
635 
636         if (Step.FundingMainSale == currentStep) {
637         
638             if (block.number <= startBlock + firstPeriod) {  
639                 return  tokenAmount + tokenAmount.mul(firstBonus) / 100;
640             }else if (block.number <= startBlock + secondPeriod) {
641                 return  tokenAmount + tokenAmount.mul(secondBonus) / 100; 
642             }else if (block.number <= startBlock + thirdPeriod) { 
643                 return  tokenAmount + tokenAmount.mul(thirdBonus) / 100;        
644             }else {              
645                 return  tokenAmount; 
646             }
647         }else 
648             return  tokenAmount + tokenAmount.mul(presaleBonus) / 100;
649     }  
650 }
651 
652 
653 // The  token
654 contract Token is ERC20, Ownable {
655 
656     using SafeMath for uint;
657     // Public variables of the token
658     string public name;
659     string public symbol;
660     uint public decimals; // How many decimals to show.
661     string public version = "v0.1";
662     uint public totalSupply;
663     bool public locked;
664     address public crowdSaleAddress;
665 
666     mapping(address => uint) public balances;
667     mapping(address => mapping(address => uint)) public allowed;
668     
669     // Lock transfer during the ICO
670     modifier onlyUnlocked() {
671         if (msg.sender != crowdSaleAddress && locked && msg.sender != owner) 
672             revert();
673         _;
674     }
675 
676     modifier onlyAuthorized() {
677         if (msg.sender != crowdSaleAddress && msg.sender != owner) 
678             revert();
679         _;
680     }
681 
682     // The Token constructor     
683     function Token(uint _initialSupply,
684             string _tokenName,
685             uint _decimalUnits,
686             string _tokenSymbol,
687             string _version,
688             address _crowdSaleAddress) public {      
689         locked = true;  // Lock the transfer of tokens during the crowdsale
690         totalSupply = _initialSupply * (10**_decimalUnits);     
691                                         
692         name = _tokenName; // Set the name for display purposes
693         symbol = _tokenSymbol; // Set the symbol for display purposes
694         decimals = _decimalUnits; // Amount of decimals for display purposes
695         version = _version;
696         crowdSaleAddress = _crowdSaleAddress;              
697         balances[crowdSaleAddress] = totalSupply;   
698     }
699 
700     function unlock() public onlyAuthorized {
701         locked = false;
702     }
703 
704     function lock() public onlyAuthorized {
705         locked = true;
706     }
707 
708     function burn(address _member, uint256 _value) public onlyAuthorized returns(bool) {
709         require(balances[_member] >= _value);
710         balances[_member] -= _value;
711         totalSupply -= _value;
712         Transfer(_member, 0x0, _value);
713         return true;
714     }
715 
716    
717     // @notice transfer tokens to given address
718     // @param _to {address} address or recipient
719     // @param _value {uint} amount to transfer
720     // @return  {bool} true if successful
721     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
722 
723         require(_to != address(0));
724         require(balances[msg.sender] >= _value);
725         balances[msg.sender] -= _value;
726         balances[_to] += _value;
727         Transfer(msg.sender, _to, _value);
728         return true;
729     }
730 
731     // @notice transfer tokens from given address to another address
732     // @param _from {address} from whom tokens are transferred
733     // @param _to {address} to whom tokens are transferred
734     // @param _value {uint} amount of tokens to transfer
735     // @return  {bool} true if successful
736     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
737 
738         require(_to != address(0));
739         require(balances[_from] >= _value); // Check if the sender has enough
740         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
741         balances[_from] -= _value; // Subtract from the sender
742         balances[_to] += _value; // Add the same to the recipient
743         allowed[_from][msg.sender] -= _value;  // adjust allowed
744         Transfer(_from, _to, _value);
745         return true;
746     }
747 
748       // @notice to query balance of account
749     // @return _owner {address} address of user to query balance
750     function balanceOf(address _owner) public view returns(uint balance) {
751         return balances[_owner];
752     }
753 
754     /**
755     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
756     *
757     * Beware that changing an allowance with this method brings the risk that someone may use both the old
758     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
759     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
760     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
761     * @param _spender The address which will spend the funds.
762     * @param _value The amount of tokens to be spent.
763     */
764     function approve(address _spender, uint _value) public returns(bool) {
765         allowed[msg.sender][_spender] = _value;
766         Approval(msg.sender, _spender, _value);
767         return true;
768     }
769 
770     // @notice to query of allowance of one user to the other
771     // @param _owner {address} of the owner of the account
772     // @param _spender {address} of the spender of the account
773     // @return remaining {uint} amount of remaining allowance
774     function allowance(address _owner, address _spender) public view returns(uint remaining) {
775         return allowed[_owner][_spender];
776     }
777 
778     /**
779     * approve should be called when allowed[_spender] == 0. To increment
780     * allowed value is better to use this function to avoid 2 calls (and wait until
781     * the first transaction is mined)
782     * From MonolithDAO Token.sol
783     */
784     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
785         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
786         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
787         return true;
788     }
789 
790     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
791         uint oldValue = allowed[msg.sender][_spender];
792         if (_subtractedValue > oldValue) {
793             allowed[msg.sender][_spender] = 0;
794         } else {
795             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
796         }
797         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
798         return true;
799     }
800 
801 }