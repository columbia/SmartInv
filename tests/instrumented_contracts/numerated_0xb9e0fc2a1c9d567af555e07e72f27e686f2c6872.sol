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
26 
27 contract IERC20Token {
28   function totalSupply() constant returns (uint256 totalSupply);
29   function balanceOf(address _owner) constant returns (uint256 balance) {}
30   function transfer(address _to, uint256 _value) returns (bool success) {}
31   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
32   function approve(address _spender, uint256 _value) returns (bool success) {}
33   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35   event Transfer(address indexed _from, address indexed _to, uint256 _value);
36   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 contract ItokenRecipient {
39   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
40 }
41 contract IToken {
42   function totalSupply() constant returns (uint256 totalSupply);
43   function mintTokens(address _to, uint256 _amount) {}
44 }
45 contract IMintableToken {
46   function mintTokens(address _to, uint256 _amount){}
47 }
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     function Owned() {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         assert(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         require(_newOwner != owner);
63         newOwner = _newOwner;
64     }
65 
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         OwnerUpdate(owner, newOwner);
69         owner = newOwner;
70         newOwner = 0x0;
71     }
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 }
75 contract Lockable is Owned{
76 
77   uint256 public lockedUntilBlock;
78 
79   event ContractLocked(uint256 _untilBlock, string _reason);
80 
81   modifier lockAffected {
82       require(block.number > lockedUntilBlock);
83       _;
84   }
85 
86   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
87     lockedUntilBlock = _untilBlock;
88     ContractLocked(_untilBlock, _reason);
89   }
90 
91 
92   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
93     lockedUntilBlock = _untilBlock;
94     ContractLocked(_untilBlock, _reason);
95   }
96 }
97 contract ReentrnacyHandlingContract{
98 
99     bool locked;
100 
101     modifier noReentrancy() {
102         require(!locked);
103         locked = true;
104         _;
105         locked = false;
106     }
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 contract MusiconomiCrowdsale is ReentrnacyHandlingContract, Owned{
123 
124   struct ContributorData{
125     uint priorityPassAllowance;
126     uint communityAllowance;
127     bool isActive;
128     uint contributionAmount;
129     uint tokensIssued;
130   }
131 
132   mapping(address => ContributorData) public contributorList;
133   uint nextContributorIndex;
134   mapping(uint => address) contributorIndexes;
135 
136   state public crowdsaleState = state.pendingStart;
137   enum state { pendingStart, priorityPass, openedPriorityPass, crowdsale, crowdsaleEnded }
138 
139   uint public presaleStartBlock = 4217240;
140   uint public presaleUnlimitedStartBlock = 4220630;
141   uint public crowdsaleStartBlock = 4224030;
142   uint public crowdsaleEndedBlock = 4319130;
143 
144   event PresaleStarted(uint blockNumber);
145   event PresaleUnlimitedStarted(uint blockNumber);
146   event CrowdsaleStarted(uint blockNumber);
147   event CrowdsaleEnded(uint blockNumber);
148   event ErrorSendingETH(address to, uint amount);
149   event MinCapReached(uint blockNumber);
150   event MaxCapReached(uint blockNumber);
151 
152   IToken token = IToken(0x0);
153   uint ethToMusicConversion = 1416;
154 
155   uint minCap = 8824000000000000000000;
156   uint maxCap = 17648000000000000000000;
157   uint ethRaised;
158 
159   address public multisigAddress;
160 
161   uint nextContributorToClaim;
162   mapping(address => bool) hasClaimedEthWhenFail;
163 
164   uint maxTokenSupply = 100000000000000000000000000;
165   bool ownerHasClaimedTokens;
166   uint cofounditReward = 2700000000000000000000000;
167   address cofounditAddress = 0x8C0DB695de876a42cE2e133ca00fdF59A9166708;
168   bool cofounditHasClaimedTokens;
169 
170   //
171   // Unnamed function that runs when eth is sent to the contract
172   //
173   function() noReentrancy payable{
174     require(msg.value != 0);                        // Throw if value is 0
175 
176     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
177 
178     if (crowdsaleState == state.priorityPass){
179       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
180         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
181       }else{
182         refundTransaction(stateChanged);            // Set state and return funds or throw
183       }
184     }
185     else if(crowdsaleState == state.openedPriorityPass){
186       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
187         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
188       }else{
189         refundTransaction(stateChanged);            // Set state and return funds or throw
190       }
191     }
192     else if(crowdsaleState == state.crowdsale){
193       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
194     }
195     else{
196       refundTransaction(stateChanged);              // Set state and return funds or throw
197     }
198   }
199 
200   //
201   // Check crowdsale state and calibrate it
202   //
203   function checkCrowdsaleState() internal returns (bool){
204     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded){                         // Check if max cap is reached
205       crowdsaleState = state.crowdsaleEnded;
206       MaxCapReached(block.number);                                                              // Close the crowdsale
207       CrowdsaleEnded(block.number);                                                             // Raise event
208       return true;
209     }
210 
211     if (block.number > presaleStartBlock && block.number <= presaleUnlimitedStartBlock){  // Check if we are in presale phase
212       if (crowdsaleState != state.priorityPass){                                          // Check if state needs to be changed
213         crowdsaleState = state.priorityPass;                                              // Set new state
214         PresaleStarted(block.number);                                                     // Raise event
215         return true;
216       }
217     }else if(block.number > presaleUnlimitedStartBlock && block.number <= crowdsaleStartBlock){ // Check if we are in presale unlimited phase
218       if (crowdsaleState != state.openedPriorityPass){                                          // Check if state needs to be changed
219         crowdsaleState = state.openedPriorityPass;                                              // Set new state
220         PresaleUnlimitedStarted(block.number);                                                  // Raise event
221         return true;
222       }
223     }else if(block.number > crowdsaleStartBlock && block.number <= crowdsaleEndedBlock){        // Check if we are in crowdsale state
224       if (crowdsaleState != state.crowdsale){                                                   // Check if state needs to be changed
225         crowdsaleState = state.crowdsale;                                                       // Set new state
226         CrowdsaleStarted(block.number);                                                         // Raise event
227         return true;
228       }
229     }else{
230       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock){        // Check if crowdsale is over
231         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
232         CrowdsaleEnded(block.number);                                                           // Raise event
233         return true;
234       }
235     }
236     return false;
237   }
238 
239   //
240   // Decide if throw or only return ether
241   //
242   function refundTransaction(bool _stateChanged) internal{
243     if (_stateChanged){
244       msg.sender.transfer(msg.value);
245     }else{
246       revert();
247     }
248   }
249 
250   //
251   // Calculate how much user can contribute
252   //
253   function calculateMaxContribution(address _contributor) constant returns (uint maxContribution){
254     uint maxContrib;
255     if (crowdsaleState == state.priorityPass){   // Check if we are in priority pass
256       maxContrib = contributorList[_contributor].priorityPassAllowance + contributorList[_contributor].communityAllowance - contributorList[_contributor].contributionAmount;
257       if (maxContrib > (maxCap - ethRaised)){   // Check if max contribution is more that max cap
258         maxContrib = maxCap - ethRaised;        // Alter max cap
259       }
260     }
261     else{
262       maxContrib = maxCap - ethRaised;          // Alter max cap
263     }
264     return maxContrib;
265   }
266 
267   //
268   // Issue tokens and return if there is overflow
269   //
270   function processTransaction(address _contributor, uint _amount) internal{
271     uint maxContribution = calculateMaxContribution(_contributor);              // Calculate max users contribution
272     uint contributionAmount = _amount;
273     uint returnAmount = 0;
274     if (maxContribution < _amount){                                             // Check if max contribution is lower than _amount sent
275       contributionAmount = maxContribution;                                     // Set that user contibutes his maximum alowed contribution
276       returnAmount = _amount - maxContribution;                                 // Calculate howmuch he must get back
277     }
278 
279     if (ethRaised + contributionAmount > minCap && minCap < ethRaised) MinCapReached(block.number);
280 
281     if (contributorList[_contributor].isActive == false){                       // Check if contributor has already contributed
282       contributorList[_contributor].isActive = true;                            // Set his activity to true
283       contributorList[_contributor].contributionAmount = contributionAmount;    // Set his contribution
284       contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
285       nextContributorIndex++;
286     }
287     else{
288       contributorList[_contributor].contributionAmount += contributionAmount;   // Add contribution amount to existing contributor
289     }
290     ethRaised += contributionAmount;                                            // Add to eth raised
291 
292     uint tokenAmount = contributionAmount * ethToMusicConversion;               // Calculate how much tokens must contributor get
293     token.mintTokens(_contributor, tokenAmount);                                // Issue new tokens
294     contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
295 
296     if (returnAmount != 0) _contributor.transfer(returnAmount);                 // Return overflow of ether
297   }
298 
299   //
300   // Push contributor data to the contract before the crowdsale so that they are eligible for priorit pass
301   //
302   function editContributors(address[] _contributorAddresses, uint[] _contributorPPAllowances, uint[] _contributorCommunityAllowance) onlyOwner{
303     //require(crowdsaleState == state.pendingStart);                                                        // Check if crowdsale has started
304     require(_contributorAddresses.length == _contributorPPAllowances.length && _contributorAddresses.length == _contributorCommunityAllowance.length); // Check if input data is correct
305 
306     for(uint cnt = 0; cnt < _contributorAddresses.length; cnt++){
307       contributorList[_contributorAddresses[cnt]].isActive = true;                                        // Activate contributor
308       contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];  // Set PP allowance
309       contributorList[_contributorAddresses[cnt]].communityAllowance = _contributorCommunityAllowance[cnt];// Set community whitelist allowance
310       contributorIndexes[nextContributorIndex] = _contributorAddresses[cnt];                              // Set users index
311       nextContributorIndex++;
312     }
313   }
314 
315   //
316   // Method is needed for recovering tokens accedentaly sent to token address
317   //
318   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
319     IERC20Token(_tokenAddress).transfer(_to, _amount);
320   }
321 
322   //
323   // withdrawEth when minimum cap is reached
324   //
325   function withdrawEth() onlyOwner{
326     require(this.balance != 0);
327     require(ethRaised >= minCap);
328 
329     multisigAddress.transfer(this.balance);
330   }
331 
332   //
333   // Users can claim their contribution if min cap is not raised
334   //
335   function claimEthIfFailed(){
336     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);    // Check if crowdsale has failed
337     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
338     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
339 
340     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
341     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
342     if (!msg.sender.send(ethContributed)){                                // Refund eth
343       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
344     }
345   }
346 
347   //
348   // Owner can batch return contributors contributions(eth)
349   //
350   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner{
351     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);                // Check if crowdsale has failed
352     address currentParticipantAddress;
353     uint contribution;
354     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
355       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
356       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
357       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
358         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
359         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
360         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
361           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
362         }
363       }
364       nextContributorToClaim += 1;                                                    // Repeat
365     }
366   }
367 
368   //
369   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
370   //
371   function withdrawRemainingBalanceForManualRecovery() onlyOwner{
372     require(this.balance != 0);                                  // Check if there are any eth to claim
373     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
374     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
375     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
376   }
377 
378   //
379   // Owner can set multisig address for crowdsale
380   //
381   function setMultisigAddress(address _newAddress) onlyOwner{
382     multisigAddress = _newAddress;
383   }
384 
385   //
386   // Owner can set token address where mints will happen
387   //
388   function setToken(address _newAddress) onlyOwner{
389     token = IToken(_newAddress);
390   }
391 
392   //
393   // Owner can claim teams tokens when crowdsale has successfully ended
394   //
395   function claimCoreTeamsTokens(address _to) onlyOwner{
396     require(crowdsaleState == state.crowdsaleEnded);              // Check if crowdsale has ended
397     require(!ownerHasClaimedTokens);                              // Check if owner has allready claimed tokens
398 
399     uint devReward = maxTokenSupply - token.totalSupply();
400     if (!cofounditHasClaimedTokens) devReward -= cofounditReward; // If cofoundit has claimed tokens its ok if not set aside cofounditReward
401     token.mintTokens(_to, devReward);                             // Issue Teams tokens
402     ownerHasClaimedTokens = true;                                 // Block further mints from this function
403   }
404 
405   //
406   // Cofoundit can claim their tokens
407   //
408   function claimCofounditTokens(){
409     require(msg.sender == cofounditAddress);            // Check if sender is cofoundit
410     require(crowdsaleState == state.crowdsaleEnded);    // Check if crowdsale has ended
411     require(!cofounditHasClaimedTokens);                // Check if cofoundit has allready claimed tokens
412 
413     token.mintTokens(cofounditAddress, cofounditReward);// Issue cofoundit tokens
414     cofounditHasClaimedTokens = true;                   // Block further mints from this function
415   }
416 
417   function getTokenAddress() constant returns(address){
418     return address(token);
419   }
420 }