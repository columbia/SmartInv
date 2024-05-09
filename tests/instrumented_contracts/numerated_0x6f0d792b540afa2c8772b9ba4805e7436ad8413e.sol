1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 contract IERC20Token {
27   function totalSupply() constant returns (uint256 totalSupply);
28   function balanceOf(address _owner) constant returns (uint256 balance) {}
29   function transfer(address _to, uint256 _value) returns (bool success) {}
30   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31   function approve(address _spender, uint256 _value) returns (bool success) {}
32   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34   event Transfer(address indexed _from, address indexed _to, uint256 _value);
35   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 contract ItokenRecipient {
38   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
39 }
40 contract IToken {
41   function totalSupply() constant returns (uint256 totalSupply);
42   function mintTokens(address _to, uint256 _amount) {}
43 }
44 contract IMintableToken {
45   function mintTokens(address _to, uint256 _amount){}
46 }
47 contract ReentrnacyHandlingContract{
48 
49     bool locked;
50 
51     modifier noReentrancy() {
52         require(!locked);
53         locked = true;
54         _;
55         locked = false;
56     }
57 }
58 
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     function Owned() {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         assert(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         require(_newOwner != owner);
74         newOwner = _newOwner;
75     }
76 
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         OwnerUpdate(owner, newOwner);
80         owner = newOwner;
81         newOwner = 0x0;
82     }
83 
84     event OwnerUpdate(address _prevOwner, address _newOwner);
85 }
86 contract Lockable is Owned{
87 
88   uint256 public lockedUntilBlock;
89 
90   event ContractLocked(uint256 _untilBlock, string _reason);
91 
92   modifier lockAffected {
93       require(block.number > lockedUntilBlock);
94       _;
95   }
96 
97   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
98     lockedUntilBlock = _untilBlock;
99     ContractLocked(_untilBlock, _reason);
100   }
101 
102 
103   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
104     lockedUntilBlock = _untilBlock;
105     ContractLocked(_untilBlock, _reason);
106   }
107 }
108 
109 contract Crowdsale is ReentrnacyHandlingContract, Owned{
110 
111   struct ContributorData{
112     uint priorityPassAllowance;
113     bool isActive;
114     uint contributionAmount;
115     uint tokensIssued;
116   }
117 
118   mapping(address => ContributorData) public contributorList;
119   uint nextContributorIndex;
120   mapping(uint => address) contributorIndexes;
121 
122   state public crowdsaleState = state.pendingStart;
123   enum state { pendingStart, priorityPass, openedPriorityPass, crowdsale, crowdsaleEnded }
124 
125   uint public presaleStartBlock;
126   uint public presaleUnlimitedStartBlock;
127   uint public crowdsaleStartBlock;
128   uint public crowdsaleEndedBlock;
129 
130   event PresaleStarted(uint blockNumber);
131   event PresaleUnlimitedStarted(uint blockNumber);
132   event CrowdsaleStarted(uint blockNumber);
133   event CrowdsaleEnded(uint blockNumber);
134   event ErrorSendingETH(address to, uint amount);
135   event MinCapReached(uint blockNumber);
136   event MaxCapReached(uint blockNumber);
137 
138   IToken token = IToken(0x0);
139   uint ethToTokenConversion;
140 
141   uint public minCap;
142   uint public maxP1Cap;
143   uint public maxCap;
144   uint public ethRaised;
145 
146   address public multisigAddress;
147 
148   uint nextContributorToClaim;
149   mapping(address => bool) hasClaimedEthWhenFail;
150 
151   uint maxTokenSupply;
152   bool ownerHasClaimedTokens;
153   uint cofounditReward;
154   address cofounditAddress;
155   address cofounditColdStorage;
156   bool cofounditHasClaimedTokens;
157 
158   //
159   // Unnamed function that runs when eth is sent to the contract
160   //
161   function() noReentrancy payable{
162     require(msg.value != 0);                        // Throw if value is 0
163     require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
164 
165     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
166 
167     if (crowdsaleState == state.priorityPass){
168       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
169         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
170       }else{
171         refundTransaction(stateChanged);            // Set state and return funds or throw
172       }
173     }
174     else if(crowdsaleState == state.openedPriorityPass){
175       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
176         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
177       }else{
178         refundTransaction(stateChanged);            // Set state and return funds or throw
179       }
180     }
181     else if(crowdsaleState == state.crowdsale){
182       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
183     }
184     else{
185       refundTransaction(stateChanged);              // Set state and return funds or throw
186     }
187   }
188 
189   //
190   // Check crowdsale state and calibrate it
191   //
192   function checkCrowdsaleState() internal returns (bool){
193     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded){                         // Check if max cap is reached
194       crowdsaleState = state.crowdsaleEnded;
195       MaxCapReached(block.number);                                                              // Close the crowdsale
196       CrowdsaleEnded(block.number);                                                             // Raise event
197       return true;
198     }
199 
200     if (block.number > presaleStartBlock && block.number <= presaleUnlimitedStartBlock){  // Check if we are in presale phase
201       if (crowdsaleState != state.priorityPass){                                          // Check if state needs to be changed
202         crowdsaleState = state.priorityPass;                                              // Set new state
203         PresaleStarted(block.number);                                                     // Raise event
204         return true;
205       }
206     }else if(block.number > presaleUnlimitedStartBlock && block.number <= crowdsaleStartBlock){ // Check if we are in presale unlimited phase
207       if (crowdsaleState != state.openedPriorityPass){                                          // Check if state needs to be changed
208         crowdsaleState = state.openedPriorityPass;                                              // Set new state
209         PresaleUnlimitedStarted(block.number);                                                  // Raise event
210         return true;
211       }
212     }else if(block.number > crowdsaleStartBlock && block.number <= crowdsaleEndedBlock){        // Check if we are in crowdsale state
213       if (crowdsaleState != state.crowdsale){                                                   // Check if state needs to be changed
214         crowdsaleState = state.crowdsale;                                                       // Set new state
215         CrowdsaleStarted(block.number);                                                         // Raise event
216         return true;
217       }
218     }else{
219       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock){        // Check if crowdsale is over
220         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
221         CrowdsaleEnded(block.number);                                                           // Raise event
222         return true;
223       }
224     }
225     return false;
226   }
227 
228   //
229   // Decide if throw or only return ether
230   //
231   function refundTransaction(bool _stateChanged) internal{
232     if (_stateChanged){
233       msg.sender.transfer(msg.value);
234     }else{
235       revert();
236     }
237   }
238 
239   //
240   // Calculate how much user can contribute
241   //
242   function calculateMaxContribution(address _contributor) constant returns (uint maxContribution){
243     uint maxContrib;
244     if (crowdsaleState == state.priorityPass){    // Check if we are in priority pass
245       maxContrib = contributorList[_contributor].priorityPassAllowance - contributorList[_contributor].contributionAmount;
246       if (maxContrib > (maxP1Cap - ethRaised)){   // Check if max contribution is more that max cap
247         maxContrib = maxP1Cap - ethRaised;        // Alter max cap
248       }
249     }
250     else{
251       maxContrib = maxCap - ethRaised;            // Alter max cap
252     }
253     return maxContrib;
254   }
255 
256   //
257   // Issue tokens and return if there is overflow
258   //
259   function processTransaction(address _contributor, uint _amount) internal{
260     uint maxContribution = calculateMaxContribution(_contributor);              // Calculate max users contribution
261     uint contributionAmount = _amount;
262     uint returnAmount = 0;
263     if (maxContribution < _amount){                                             // Check if max contribution is lower than _amount sent
264       contributionAmount = maxContribution;                                     // Set that user contibutes his maximum alowed contribution
265       returnAmount = _amount - maxContribution;                                 // Calculate howmuch he must get back
266     }
267 
268     if (ethRaised + contributionAmount > minCap && minCap > ethRaised) MinCapReached(block.number);
269 
270     if (contributorList[_contributor].isActive == false){                       // Check if contributor has already contributed
271       contributorList[_contributor].isActive = true;                            // Set his activity to true
272       contributorList[_contributor].contributionAmount = contributionAmount;    // Set his contribution
273       contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
274       nextContributorIndex++;
275     }
276     else{
277       contributorList[_contributor].contributionAmount += contributionAmount;   // Add contribution amount to existing contributor
278     }
279     ethRaised += contributionAmount;                                            // Add to eth raised
280 
281     uint tokenAmount = contributionAmount * ethToTokenConversion;               // Calculate how much tokens must contributor get
282     if (tokenAmount > 0){
283       token.mintTokens(_contributor, tokenAmount);                                // Issue new tokens
284       contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
285     }
286     if (returnAmount != 0) _contributor.transfer(returnAmount);                 // Return overflow of ether
287   }
288 
289   //
290   // Push contributor data to the contract before the crowdsale so that they are eligible for priorit pass
291   //
292   function editContributors(address[] _contributorAddresses, uint[] _contributorPPAllowances) onlyOwner{
293     require(_contributorAddresses.length == _contributorPPAllowances.length); // Check if input data is correct
294 
295     for(uint cnt = 0; cnt < _contributorAddresses.length; cnt++){
296       if (contributorList[_contributorAddresses[cnt]].isActive){
297         contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];
298       }
299       else{
300         contributorList[_contributorAddresses[cnt]].isActive = true;
301         contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];
302         contributorIndexes[nextContributorIndex] = _contributorAddresses[cnt];
303         nextContributorIndex++;
304       }
305     }
306   }
307 
308   //
309   // Method is needed for recovering tokens accedentaly sent to token address
310   //
311   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
312     IERC20Token(_tokenAddress).transfer(_to, _amount);
313   }
314 
315   //
316   // withdrawEth when minimum cap is reached
317   //
318   function withdrawEth() onlyOwner{
319     require(this.balance != 0);
320     require(ethRaised >= minCap);
321 
322     pendingEthWithdrawal = this.balance;
323   }
324   uint pendingEthWithdrawal;
325   function pullBalance(){
326     require(msg.sender == multisigAddress);
327     require(pendingEthWithdrawal > 0);
328 
329     multisigAddress.transfer(pendingEthWithdrawal);
330     pendingEthWithdrawal = 0;
331   }
332 
333   //
334   // Users can claim their contribution if min cap is not raised
335   //
336   function claimEthIfFailed(){
337     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);    // Check if crowdsale has failed
338     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
339     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
340 
341     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
342     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
343     if (!msg.sender.send(ethContributed)){                                // Refund eth
344       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
345     }
346   }
347 
348   //
349   // Owner can batch return contributors contributions(eth)
350   //
351   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner{
352     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);                // Check if crowdsale has failed
353     address currentParticipantAddress;
354     uint contribution;
355     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
356       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
357       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
358       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
359         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
360         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
361         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
362           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
363         }
364       }
365       nextContributorToClaim += 1;                                                    // Repeat
366     }
367   }
368 
369   //
370   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
371   //
372   function withdrawRemainingBalanceForManualRecovery() onlyOwner{
373     require(this.balance != 0);                                  // Check if there are any eth to claim
374     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
375     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
376     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
377   }
378 
379   //
380   // Owner can set multisig address for crowdsale
381   //
382   function setMultisigAddress(address _newAddress) onlyOwner{
383     multisigAddress = _newAddress;
384   }
385 
386   //
387   // Owner can set token address where mints will happen
388   //
389   function setToken(address _newAddress) onlyOwner{
390     token = IToken(_newAddress);
391   }
392 
393   //
394   // Owner can claim teams tokens when crowdsale has successfully ended
395   //
396   function claimCoreTeamsTokens(address _to) onlyOwner{
397     require(crowdsaleState == state.crowdsaleEnded);              // Check if crowdsale has ended
398     require(!ownerHasClaimedTokens);                              // Check if owner has allready claimed tokens
399 
400     uint devReward = maxTokenSupply - token.totalSupply();
401     if (!cofounditHasClaimedTokens) devReward -= cofounditReward; // If cofoundit has claimed tokens its ok if not set aside cofounditReward
402     token.mintTokens(_to, devReward);                             // Issue Teams tokens
403     ownerHasClaimedTokens = true;                                 // Block further mints from this method
404   }
405 
406   //
407   // Cofoundit can claim their tokens
408   //
409   function claimCofounditTokens(){
410     require(msg.sender == cofounditAddress);            // Check if sender is cofoundit
411     require(crowdsaleState == state.crowdsaleEnded);    // Check if crowdsale has ended
412     require(!cofounditHasClaimedTokens);                // Check if cofoundit has allready claimed tokens
413 
414     token.mintTokens(cofounditColdStorage, cofounditReward);             // Issue cofoundit tokens
415     cofounditHasClaimedTokens = true;                   // Block further mints from this method
416   }
417 
418   function getTokenAddress() constant returns(address){
419     return address(token);
420   }
421 
422   //
423   //  Before crowdsale starts owner can calibrate blocks of crowdsale stages
424   //
425   function setCrowdsaleBlocks(uint _presaleStartBlock, uint _presaleUnlimitedStartBlock, uint _crowdsaleStartBlock, uint _crowdsaleEndedBlock) onlyOwner{
426     require(crowdsaleState == state.pendingStart);                // Check if crowdsale has started
427     require(_presaleStartBlock != 0);                             // Check if any value is 0
428     require(_presaleStartBlock < _presaleUnlimitedStartBlock);    // Check if presaleUnlimitedStartBlock is set properly
429     require(_presaleUnlimitedStartBlock != 0);                    // Check if any value is 0
430     require(_presaleUnlimitedStartBlock < _crowdsaleStartBlock);  // Check if crowdsaleStartBlock is set properly
431     require(_crowdsaleStartBlock != 0);                           // Check if any value is 0
432     require(_crowdsaleStartBlock < _crowdsaleEndedBlock);         // Check if crowdsaleEndedBlock is set properly
433     require(_crowdsaleEndedBlock != 0);                           // Check if any value is 0
434     presaleStartBlock = _presaleStartBlock;
435     presaleUnlimitedStartBlock = _presaleUnlimitedStartBlock;
436     crowdsaleStartBlock = _crowdsaleStartBlock;
437     crowdsaleEndedBlock = _crowdsaleEndedBlock;
438   }
439 }
440 
441 
442 
443 contract DPPCrowdsale is Crowdsale {
444   function DPPCrowdsale(){
445     presaleStartBlock = 4291518;
446     presaleUnlimitedStartBlock = 4295146;
447     crowdsaleStartBlock = 4298775;
448     crowdsaleEndedBlock = 4313290;
449 
450     minCap = 8236 * 10**18;
451     maxP1Cap = 12000 * 10**18;
452     maxCap = 20000 * 10**18;
453 
454     ethToTokenConversion = 1250;
455 
456     maxTokenSupply = 100000000 * 10**18;
457     cofounditReward = 8000000 * 10**18;
458     cofounditAddress = 0x988c3eA5554f3D2fB5ECB4dC5c35126eEf3B8a5D;
459     cofounditColdStorage = 0x8C0DB695de876a42cE2e133ca00fdF59A9166708;
460   }
461 }