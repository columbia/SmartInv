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
24 contract Ownable {
25     address public owner;
26 
27     function Ownable() public {
28         owner = msg.sender;
29     }
30 
31     function transferOwnership(address newOwner) public onlyOwner {
32         if (newOwner != address(0)) 
33             owner = newOwner;
34     }
35 
36     function kill() public {
37         if (msg.sender == owner) 
38             selfdestruct(owner);
39     }
40 
41     modifier onlyOwner() {
42         if (msg.sender == owner)
43             _;
44     }
45 }
46 
47 
48 contract Pausable is Ownable {
49     bool public stopped;
50 
51     modifier stopInEmergency {
52         if (stopped) {
53             revert();
54         }
55         _;
56     }
57 
58     modifier onlyInEmergency {
59         if (!stopped) {
60             revert();
61         }
62         _;
63     }
64 
65     // Called by the owner in emergency, triggers stopped state
66     function emergencyStop() external onlyOwner() {
67         stopped = true;
68     }
69 
70     // Called by the owner to end of emergency, returns to normal state
71     function release() external onlyOwner() onlyInEmergency {
72         stopped = false;
73     }
74 }
75 
76 contract WhiteList is Ownable {
77 
78     function isWhiteListedAndAffiliate(address _user) external view returns (bool, address);
79 }
80 
81 // Crowdsale Smart Contract
82 // This smart contract collects ETH and in return sends tokens to contributors
83 contract Crowdsale is Pausable {
84 
85     using SafeMath for uint;
86 
87     struct Backer {
88         uint weiReceived; // amount of ETH contributed
89         uint tokensToSend; // amount of tokens  sent  
90         bool claimed;
91         bool refunded; // true if user has been refunded       
92     }
93 
94     Token public token; // Token contract reference   
95     address public multisig; // Multisig contract that will receive the ETH    
96     address public team; // Address at which the team tokens will be sent   
97     uint public teamTokens; // tokens for the team.     
98     uint public ethReceivedPresale; // Number of ETH received in presale
99     uint public ethReceivedMain; // Number of ETH received in public sale
100     uint public totalTokensSent; // Number of tokens sent to ETH contributors
101     uint public totalAffiliateTokensSent;
102     uint public startBlock; // Crowdsale start block
103     uint public endBlock; // Crowdsale end block
104     uint public maxCap; // Maximum number of tokens to sell
105     uint public minCap; // Minimum number of ETH to raise
106     uint public minInvestETH; // Minimum amount to invest   
107     bool public crowdsaleClosed; // Is crowdsale still in progress
108     Step public currentStep;  // to allow for controled steps of the campaign 
109     uint public refundCount;  // number of refunds
110     uint public totalRefunded; // total amount of refunds    
111     uint public tokenPriceWei;  // price of token in wei
112     WhiteList public whiteList; // white list address
113     uint public numOfBlocksInMinute;// number of blocks in one minute * 100. eg. 
114     uint public claimCount; // number of claims
115     uint public totalClaimed; // Total number of tokens claimed
116     
117 
118     mapping(address => Backer) public backers; //backer list
119     mapping(address => uint) public affiliates; // affiliates list
120     address[] public backersIndex; // to be able to itarate through backers for verification.  
121     mapping(address => uint) public claimed;  // Tokens claimed by contibutors
122 
123     
124     // @notice to verify if action is not performed out of the campaing range
125     modifier respectTimeFrame() {
126         if ((block.number < startBlock) || (block.number > endBlock)) 
127             revert();
128         _;
129     }
130 
131     // @notice to set and determine steps of crowdsale
132     enum Step {
133         Unknown,
134         FundingPreSale,     // presale mode
135         FundingPublicSale,  // public mode
136         Refunding,  // in case campaign failed during this step contributors will be able to receive refunds
137         Claiming    // set this step to enable claiming of tokens. 
138     }
139 
140     // Events
141     event ReceivedETH(address indexed backer, address indexed affiliate, uint amount, uint tokenAmount, uint affiliateTokenAmount);
142     event RefundETH(address backer, uint amount);
143     event TokensClaimed(address backer, uint count);
144 
145 
146     // Crowdsale  {constructor}
147     // @notice fired when contract is crated. Initilizes all constnat and initial values.
148     function Crowdsale(WhiteList _whiteListAddress) public {
149         multisig = 0x49447Ea549CCfFDEF2E9a9290709d6114346df88; 
150         team = 0x49447Ea549CCfFDEF2E9a9290709d6114346df88;                                         
151         startBlock = 0; // Should wait for the call of the function start
152         endBlock = 0; // Should wait for the call of the function start                  
153         tokenPriceWei = 108110000000000;
154         maxCap = 210000000e18;         
155         minCap = 21800000e18;        
156         totalTokensSent = 0;  //TODO: add tokens sold in private sale
157         setStep(Step.FundingPreSale);
158         numOfBlocksInMinute = 416;    
159         whiteList = WhiteList(_whiteListAddress);    
160         teamTokens = 45000000e18;
161     }
162 
163     // @notice to populate website with status of the sale 
164     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint, Step, bool, bool) {            
165     
166         return (startBlock, endBlock, backersIndex.length, ethReceivedPresale.add(ethReceivedMain), maxCap, minCap, totalTokensSent, tokenPriceWei, currentStep, stopped, crowdsaleClosed);
167     }
168 
169     // @notice Specify address of token contract
170     // @param _tokenAddress {address} address of token contract
171     // @return res {bool}
172     function updateTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
173         token = _tokenAddress;
174         return true;
175     }
176 
177     // @notice set the step of the campaign 
178     // @param _step {Step}
179     function setStep(Step _step) public onlyOwner() {
180         currentStep = _step;
181         
182         if (currentStep == Step.FundingPreSale) {  // for presale 
183           
184             minInvestETH = 1 ether/5;                             
185         }else if (currentStep == Step.FundingPublicSale) { // for public sale           
186             minInvestETH = 1 ether/10;               
187         }      
188     }
189 
190     // {fallback function}
191     // @notice It will call internal function which handels allocation of Ether and calculates tokens.
192     function () external payable {           
193         contribute(msg.sender);
194     }
195 
196     // @notice It will be called by owner to start the sale    
197     function start(uint _block) external onlyOwner() {   
198 
199         require(_block < 335462);  // 4.16*60*24*56 days = 335462     
200         startBlock = block.number;
201         endBlock = startBlock.add(_block); 
202     }
203 
204     // @notice Due to changing average of block time
205     // this function will allow on adjusting duration of campaign closer to the end 
206     function adjustDuration(uint _block) external onlyOwner() {
207 
208         require(_block < 389376);  // 4.16*60*24*65 days = 389376     
209         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
210         endBlock = startBlock.add(_block); 
211     }
212 
213     // @notice It will be called by fallback function whenever ether is sent to it
214     // @param  _backer {address} address contributor
215     // @return res {bool} true if transaction was successful
216     function contribute(address _backer) internal stopInEmergency respectTimeFrame returns(bool res) {
217 
218         uint affiliateTokens;
219 
220         var(isWhiteListed, affiliate) = whiteList.isWhiteListedAndAffiliate(_backer);
221 
222         require(isWhiteListed);      // ensure that user is whitelisted
223     
224         require(currentStep == Step.FundingPreSale || currentStep == Step.FundingPublicSale); // ensure that this is correct step
225         require(msg.value >= minInvestETH);   // ensure that min contributions amount is met
226           
227         uint tokensToSend = determinePurchase();
228 
229         if (affiliate != address(0)) {
230             affiliateTokens = (tokensToSend * 5) / 100; // give 5% of tokens to affiliate
231             affiliates[affiliate] += affiliateTokens;
232             Backer storage referrer = backers[affiliate];
233             referrer.tokensToSend = referrer.tokensToSend.add(affiliateTokens);
234         }
235         
236         require(totalTokensSent.add(tokensToSend.add(affiliateTokens)) < maxCap); // Ensure that max cap hasn't been reached  
237             
238         Backer storage backer = backers[_backer];
239     
240         if (backer.tokensToSend == 0)      
241             backersIndex.push(_backer);
242            
243         backer.tokensToSend = backer.tokensToSend.add(tokensToSend); // save contributors tokens to be sent
244         backer.weiReceived = backer.weiReceived.add(msg.value);  // save how much was the contribution
245         totalTokensSent += tokensToSend + affiliateTokens;     // update the total amount of tokens sent
246         totalAffiliateTokensSent += affiliateTokens;
247     
248         if (Step.FundingPublicSale == currentStep)  // Update the total Ether recived
249             ethReceivedMain = ethReceivedMain.add(msg.value);
250         else
251             ethReceivedPresale = ethReceivedPresale.add(msg.value);     
252        
253         multisig.transfer(this.balance);   // transfer funds to multisignature wallet             
254     
255         ReceivedETH(_backer, affiliate, msg.value, tokensToSend, affiliateTokens); // Register event
256         return true;
257     }
258 
259     // @notice determine if purchase is valid and return proper number of tokens
260     // @return tokensToSend {uint} proper number of tokens based on the timline     
261     function determinePurchase() internal view  returns (uint) {
262        
263         require(msg.value >= minInvestETH);                        // ensure that min contributions amount is met  
264         uint tokenAmount = msg.value.mul(1e18) / tokenPriceWei;    // calculate amount of tokens
265 
266         uint tokensToSend;  
267 
268         if (currentStep == Step.FundingPreSale)
269             tokensToSend = calculateNoOfTokensToSend(tokenAmount); 
270         else
271             tokensToSend = tokenAmount;
272                                                                                                        
273         return tokensToSend;
274     }
275 
276     // @notice This function will return number of tokens based on time intervals in the campaign
277     // @param _tokenAmount {uint} amount of tokens to allocate for the contribution
278     function calculateNoOfTokensToSend(uint _tokenAmount) internal view  returns (uint) {
279               
280         if (block.number <= startBlock + (numOfBlocksInMinute * 60 * 24 * 14) / 100)        // less equal then/equal 14 days
281             return  _tokenAmount + (_tokenAmount * 40) / 100;  // 40% bonus
282         else if (block.number <= startBlock + (numOfBlocksInMinute * 60 * 24 * 28) / 100)   // less equal  28 days
283             return  _tokenAmount + (_tokenAmount * 30) / 100; // 30% bonus
284         else
285             return  _tokenAmount + (_tokenAmount * 20) / 100;   // remainder of the campaign 20% bonus
286           
287     }
288 
289     // @notice erase contribution from the database and do manual refund for disapproved users
290     // @param _backer {address} address of user to be erased
291     function eraseContribution(address _backer) external onlyOwner() {
292 
293         Backer storage backer = backers[_backer];        
294         backer.refunded = true;
295         totalTokensSent = totalTokensSent.sub(backer.tokensToSend);        
296     }
297 
298     // @notice allow on manual addition of contributors
299     // @param _backer {address} of contributor to be added
300     // @parm _amountTokens {uint} tokens to be added
301     function addManualContributor(address _backer, uint _amountTokens) external onlyOwner() {
302 
303         Backer storage backer = backers[_backer];        
304         backer.tokensToSend = backer.tokensToSend.add(_amountTokens);
305         if (backer.tokensToSend == 0)      
306             backersIndex.push(_backer);
307         totalTokensSent = totalTokensSent.add(_amountTokens);
308     }
309 
310 
311     // @notice contributors can claim tokens after public ICO is finished
312     // tokens are only claimable when token address is available and lock-up period reached. 
313     function claimTokens() external {
314         claimTokensForUser(msg.sender);
315     }
316 
317     // @notice this function can be called by admin to claim user's token in case of difficulties
318     // @param _backer {address} user address to claim tokens for
319     function adminClaimTokenForUser(address _backer) external onlyOwner() {
320         claimTokensForUser(_backer);
321     }
322 
323     // @notice in case refunds are needed, money can be returned to the contract
324     // and contract switched to mode refunding
325     function prepareRefund() public payable onlyOwner() {
326         
327         require(msg.value == ethReceivedMain + ethReceivedPresale); // make sure that proper amount of ether is sent
328         currentStep == Step.Refunding;
329     }
330 
331     // @notice return number of contributors
332     // @return  {uint} number of contributors   
333     function numberOfBackers() public view returns(uint) {
334         return backersIndex.length;
335     }
336  
337     // @notice called to send tokens to contributors after ICO and lockup period. 
338     // @param _backer {address} address of beneficiary
339     // @return true if successful
340     function claimTokensForUser(address _backer) internal returns(bool) {       
341 
342         require(currentStep == Step.Claiming);
343                   
344         Backer storage backer = backers[_backer];
345 
346         require(!backer.refunded);      // if refunded, don't allow for another refund           
347         require(!backer.claimed);       // if tokens claimed, don't allow refunding            
348         require(backer.tokensToSend != 0);   // only continue if there are any tokens to send           
349 
350         claimCount++;
351         claimed[_backer] = backer.tokensToSend;  // save claimed tokens
352         backer.claimed = true;
353         totalClaimed += backer.tokensToSend;
354         
355         if (!token.transfer(_backer, backer.tokensToSend)) 
356             revert(); // send claimed tokens to contributor account
357 
358         TokensClaimed(_backer, backer.tokensToSend);  
359     }
360 
361 
362     // @notice This function will finalize the sale.
363     // It will only execute if predetermined sale time passed or all tokens are sold.
364     // it will fail if minimum cap is not reached
365     function finalize() external onlyOwner() {
366 
367         require(!crowdsaleClosed);        
368         // purchasing precise number of tokens might be impractical, thus subtract 1000 tokens so finalizition is possible
369         // near the end 
370         require(block.number >= endBlock || totalTokensSent >= maxCap.sub(1000));                 
371         require(totalTokensSent >= minCap);  // ensure that minimum was reached
372 
373         crowdsaleClosed = true;  
374         
375         if (!token.transfer(team, teamTokens)) // transfer all remaing tokens to team address
376             revert();
377 
378         if (!token.burn(this, maxCap - totalTokensSent)) // burn all unsold tokens
379             revert();  
380         token.unlock();                      
381     }
382 
383     // @notice Failsafe drain
384     function drain() external onlyOwner() {
385         multisig.transfer(this.balance);               
386     }
387 
388     // @notice Failsafe token transfer
389     function tokenDrian() external onlyOwner() {
390         if (block.number > endBlock) {
391             if (!token.transfer(team, token.balanceOf(this))) 
392                 revert();
393         }
394     }
395     
396     // @notice it will allow contributors to get refund in case campaign failed
397     function refund() external stopInEmergency returns (bool) {
398 
399         require(currentStep == Step.Refunding);         
400        
401         require(this.balance > 0);  // contract will hold 0 ether at the end of campaign.                                  
402                                     // contract needs to be funded through fundContract() 
403 
404         Backer storage backer = backers[msg.sender];
405 
406         require(backer.weiReceived > 0);  // esnure that user has sent contribution
407         require(!backer.refunded);         // ensure that user hasn't been refunded yet
408         require(!backer.claimed);       // if tokens claimed, don't allow refunding   
409        
410         backer.refunded = true;  // save refund status to true
411     
412         refundCount++;
413         totalRefunded = totalRefunded.add(backer.weiReceived);
414         msg.sender.transfer(backer.weiReceived);  // send back the contribution 
415         RefundETH(msg.sender, backer.weiReceived);
416         return true;
417     }
418 }
419 
420 
421 contract ERC20 {
422     uint public totalSupply;
423    
424     function transfer(address to, uint value) public returns(bool ok);  
425 }
426 
427 
428 // The token
429 contract Token is ERC20, Ownable {
430 
431     function returnTokens(address _member, uint256 _value) public returns(bool);
432     function unlock() public;
433     function balanceOf(address _owner) public view returns(uint balance);
434     function burn( address _member, uint256 _value) public returns(bool);
435 }