1 pragma solidity ^0.4.13;
2 
3 contract ReentrnacyHandlingContract{
4 
5     bool locked;
6 
7     modifier noReentrancy() {
8         require(!locked);
9         locked = true;
10         _;
11         locked = false;
12     }
13 }
14 
15 contract Owned {
16     address public owner;
17     address public newOwner;
18 
19     function Owned() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         assert(msg.sender == owner);
25         _;
26     }
27 
28     function transferOwnership(address _newOwner) public onlyOwner {
29         require(_newOwner != owner);
30         newOwner = _newOwner;
31     }
32 
33     function acceptOwnership() public {
34         require(msg.sender == newOwner);
35         OwnerUpdate(owner, newOwner);
36         owner = newOwner;
37         newOwner = 0x0;
38     }
39 
40     event OwnerUpdate(address _prevOwner, address _newOwner);
41 }
42 
43 contract IToken {
44   function totalSupply() constant returns (uint256 totalSupply);
45   function mintTokens(address _to, uint256 _amount) {}
46 }
47 
48 contract IERC20Token {
49   function totalSupply() constant returns (uint256 totalSupply);
50   function balanceOf(address _owner) constant returns (uint256 balance) {}
51   function transfer(address _to, uint256 _value) returns (bool success) {}
52   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
53   function approve(address _spender, uint256 _value) returns (bool success) {}
54   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
55 
56   event Transfer(address indexed _from, address indexed _to, uint256 _value);
57   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 }
59 
60 contract MusiconomiCrowdsale is ReentrnacyHandlingContract, Owned{
61 
62   struct ContributorData{
63     uint priorityPassAllowance;
64     uint communityAllowance;
65     bool isActive;
66     uint contributionAmount;
67     uint tokensIssued;
68   }
69 
70   mapping(address => ContributorData) public contributorList;
71   uint nextContributorIndex;
72   mapping(uint => address) contributorIndexes;
73 
74   state public crowdsaleState = state.pendingStart;
75   enum state { pendingStart, priorityPass, openedPriorityPass, crowdsale, crowdsaleEnded }
76 
77   uint public presaleStartBlock = 4216670;
78   uint public presaleUnlimitedStartBlock = 4220000;
79   uint public crowdsaleStartBlock = 4223470;
80   uint public crowdsaleEndedBlock = 4318560;
81 
82   event PresaleStarted(uint blockNumber);
83   event PresaleUnlimitedStarted(uint blockNumber);
84   event CrowdsaleStarted(uint blockNumber);
85   event CrowdsaleEnded(uint blockNumber);
86   event ErrorSendingETH(address to, uint amount);
87   event MinCapReached(uint blockNumber);
88   event MaxCapReached(uint blockNumber);
89 
90   IToken token = IToken(0x0);
91   uint ethToMusicConversion = 1416;
92 
93   uint minCap = 8824000000000000000000;
94   uint maxCap = 17648000000000000000000;
95   uint ethRaised;
96 
97   address public multisigAddress;
98 
99   uint nextContributorToClaim;
100   mapping(address => bool) hasClaimedEthWhenFail;
101 
102   uint maxTokenSupply = 100000000000000000000000000;
103   bool ownerHasClaimedTokens;
104   uint cofounditReward = 2700000000000000000000000;
105   address cofounditAddress = 0x8C0DB695de876a42cE2e133ca00fdF59A9166708;
106   bool cofounditHasClaimedTokens;
107 
108   //
109   // Unnamed function that runs when eth is sent to the contract
110   //
111   function() noReentrancy payable{
112     require(msg.value != 0);                        // Throw if value is 0
113 
114     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
115 
116     if (crowdsaleState == state.priorityPass){
117       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
118         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
119       }else{
120         refundTransaction(stateChanged);            // Set state and return funds or throw
121       }
122     }
123     else if(crowdsaleState == state.openedPriorityPass){
124       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
125         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
126       }else{
127         refundTransaction(stateChanged);            // Set state and return funds or throw
128       }
129     }
130     else if(crowdsaleState == state.crowdsale){
131       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
132     }
133     else{
134       refundTransaction(stateChanged);              // Set state and return funds or throw
135     }
136   }
137 
138   //
139   // Check crowdsale state and calibrate it
140   //
141   function checkCrowdsaleState() internal returns (bool){
142     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded){                         // Check if max cap is reached
143       crowdsaleState = state.crowdsaleEnded;
144       MaxCapReached(block.number);                                                              // Close the crowdsale
145       CrowdsaleEnded(block.number);                                                             // Raise event
146       return true;
147     }
148 
149     if (block.number > presaleStartBlock && block.number <= presaleUnlimitedStartBlock){  // Check if we are in presale phase
150       if (crowdsaleState != state.priorityPass){                                          // Check if state needs to be changed
151         crowdsaleState = state.priorityPass;                                              // Set new state
152         PresaleStarted(block.number);                                                     // Raise event
153         return true;
154       }
155     }else if(block.number > presaleUnlimitedStartBlock && block.number <= crowdsaleStartBlock){ // Check if we are in presale unlimited phase
156       if (crowdsaleState != state.openedPriorityPass){                                          // Check if state needs to be changed
157         crowdsaleState = state.openedPriorityPass;                                              // Set new state
158         PresaleUnlimitedStarted(block.number);                                                  // Raise event
159         return true;
160       }
161     }else if(block.number > crowdsaleStartBlock && block.number <= crowdsaleEndedBlock){        // Check if we are in crowdsale state
162       if (crowdsaleState != state.crowdsale){                                                   // Check if state needs to be changed
163         crowdsaleState = state.crowdsale;                                                       // Set new state
164         CrowdsaleStarted(block.number);                                                         // Raise event
165         return true;
166       }
167     }else{
168       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock){        // Check if crowdsale is over
169         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
170         CrowdsaleEnded(block.number);                                                           // Raise event
171         return true;
172       }
173     }
174     return false;
175   }
176 
177   //
178   // Decide if throw or only return ether
179   //
180   function refundTransaction(bool _stateChanged) internal{
181     if (_stateChanged){
182       msg.sender.transfer(msg.value);
183     }else{
184       revert();
185     }
186   }
187 
188   //
189   // Calculate how much user can contribute
190   //
191   function calculateMaxContribution(address _contributor) constant returns (uint maxContribution){
192     uint maxContrib;
193     if (crowdsaleState == state.priorityPass){   // Check if we are in priority pass
194       maxContrib = contributorList[_contributor].priorityPassAllowance + contributorList[_contributor].communityAllowance - contributorList[_contributor].contributionAmount;
195       if (maxContrib > (maxCap - ethRaised)){   // Check if max contribution is more that max cap
196         maxContrib = maxCap - ethRaised;        // Alter max cap
197       }
198     }
199     else{
200       maxContrib = maxCap - ethRaised;          // Alter max cap
201     }
202     return maxContrib;
203   }
204 
205   //
206   // Issue tokens and return if there is overflow
207   //
208   function processTransaction(address _contributor, uint _amount) internal{
209     uint maxContribution = calculateMaxContribution(_contributor);              // Calculate max users contribution
210     uint contributionAmount = _amount;
211     uint returnAmount = 0;
212     if (maxContribution < _amount){                                             // Check if max contribution is lower than _amount sent
213       contributionAmount = maxContribution;                                     // Set that user contibutes his maximum alowed contribution
214       returnAmount = _amount - maxContribution;                                 // Calculate howmuch he must get back
215     }
216 
217     if (ethRaised + contributionAmount > minCap && minCap < ethRaised) MinCapReached(block.number);
218 
219     if (contributorList[_contributor].isActive == false){                       // Check if contributor has already contributed
220       contributorList[_contributor].isActive = true;                            // Set his activity to true
221       contributorList[_contributor].contributionAmount = contributionAmount;    // Set his contribution
222       contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
223       nextContributorIndex++;
224     }
225     else{
226       contributorList[_contributor].contributionAmount += contributionAmount;   // Add contribution amount to existing contributor
227     }
228     ethRaised += contributionAmount;                                            // Add to eth raised
229 
230     uint tokenAmount = contributionAmount * ethToMusicConversion;               // Calculate how much tokens must contributor get
231     token.mintTokens(_contributor, tokenAmount);                                // Issue new tokens
232     contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
233 
234     if (returnAmount != 0) _contributor.transfer(returnAmount);                 // Return overflow of ether
235   }
236 
237   //
238   // Push contributor data to the contract before the crowdsale so that they are eligible for priorit pass
239   //
240   function editContributors(address[] _contributorAddresses, uint[] _contributorPPAllowances, uint[] _contributorCommunityAllowance) onlyOwner{
241     require(crowdsaleState == state.pendingStart);                                                        // Check if crowdsale has started
242     require(_contributorAddresses.length == _contributorPPAllowances.length && _contributorAddresses.length == _contributorCommunityAllowance.length); // Check if input data is correct
243 
244     for(uint cnt = 0; cnt < _contributorAddresses.length; cnt++){
245       contributorList[_contributorAddresses[cnt]].isActive = true;                                        // Activate contributor
246       contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];  // Set PP allowance
247       contributorList[_contributorAddresses[cnt]].communityAllowance = _contributorCommunityAllowance[cnt];// Set community whitelist allowance
248       contributorIndexes[nextContributorIndex] = _contributorAddresses[cnt];                              // Set users index
249       nextContributorIndex++;
250     }
251   }
252 
253   //
254   // Method is needed for recovering tokens accedentaly sent to token address
255   //
256   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
257     IERC20Token(_tokenAddress).transfer(_to, _amount);
258   }
259 
260   //
261   // withdrawEth when minimum cap is reached
262   //
263   function withdrawEth() onlyOwner{
264     require(this.balance != 0);
265     require(ethRaised >= minCap);
266 
267     multisigAddress.transfer(this.balance);
268   }
269 
270   //
271   // Users can claim their contribution if min cap is not raised
272   //
273   function claimEthIfFailed(){
274     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);    // Check if crowdsale has failed
275     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
276     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
277 
278     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
279     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
280     if (!msg.sender.send(ethContributed)){                                // Refund eth
281       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
282     }
283   }
284 
285   //
286   // Owner can batch return contributors contributions(eth)
287   //
288   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner{
289     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);                // Check if crowdsale has failed
290     address currentParticipantAddress;
291     uint contribution;
292     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
293       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
294       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
295       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
296         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
297         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
298         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
299           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
300         }
301       }
302       nextContributorToClaim += 1;                                                    // Repeat
303     }
304   }
305 
306   //
307   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
308   //
309   function withdrawRemainingBalanceForManualRecovery() onlyOwner{
310     require(this.balance != 0);                                  // Check if there are any eth to claim
311     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
312     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
313     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
314   }
315 
316   //
317   // Owner can set multisig address for crowdsale
318   //
319   function setMultisigAddress(address _newAddress) onlyOwner{
320     multisigAddress = _newAddress;
321   }
322 
323   //
324   // Owner can set token address where mints will happen
325   //
326   function setToken(address _newAddress) onlyOwner{
327     token = IToken(_newAddress);
328   }
329 
330   //
331   // Owner can claim teams tokens when crowdsale has successfully ended
332   //
333   function claimCoreTeamsTokens(address _to) onlyOwner{
334     require(crowdsaleState == state.crowdsaleEnded);              // Check if crowdsale has ended
335     require(!ownerHasClaimedTokens);                              // Check if owner has allready claimed tokens
336 
337     uint devReward = maxTokenSupply - token.totalSupply();
338     if (!cofounditHasClaimedTokens) devReward -= cofounditReward; // If cofoundit has claimed tokens its ok if not set aside cofounditReward
339     token.mintTokens(_to, devReward);                             // Issue Teams tokens
340     ownerHasClaimedTokens = true;                                 // Block further mints from this function
341   }
342 
343   //
344   // Cofoundit can claim their tokens
345   //
346   function claimCofounditTokens(){
347     require(msg.sender == cofounditAddress);            // Check if sender is cofoundit
348     require(crowdsaleState == state.crowdsaleEnded);    // Check if crowdsale has ended
349     require(!cofounditHasClaimedTokens);                // Check if cofoundit has allready claimed tokens
350 
351     token.mintTokens(cofounditAddress, cofounditReward);// Issue cofoundit tokens
352     cofounditHasClaimedTokens = true;                   // Block further mints from this function
353   }
354 
355   function getTokenAddress() constant returns(address){
356     return address(token);
357   }
358 }