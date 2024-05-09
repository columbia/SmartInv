1 /*
2 
3   Copyright 2017 Cofound.it.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity ^0.4.13;
20 
21 contract ReentrnacyHandlingContract{
22 
23     bool locked;
24 
25     modifier noReentrancy() {
26         require(!locked);
27         locked = true;
28         _;
29         locked = false;
30     }
31 }
32 
33 contract Owned {
34     address public owner;
35     address public newOwner;
36 
37     function Owned() public{
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         assert(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address _newOwner) public onlyOwner {
47         require(_newOwner != owner);
48         newOwner = _newOwner;
49     }
50 
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = 0x0;
56     }
57 
58     event OwnerUpdate(address _prevOwner, address _newOwner);
59 }
60 
61 contract IToken {
62   function totalSupply() public constant returns (uint256 totalSupply);
63   function mintTokens(address _to, uint256 _amount) public {}
64 }
65 
66 contract IERC20Token {
67   function totalSupply() public constant returns (uint256 totalSupply);
68   function balanceOf(address _owner) public constant returns (uint256 balance) {}
69   function transfer(address _to, uint256 _value) public returns (bool success) {}
70   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
71   function approve(address _spender, uint256 _value) public returns (bool success) {}
72   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
73 
74   event Transfer(address indexed _from, address indexed _to, uint256 _value);
75   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 
79 contract Crowdsale is ReentrnacyHandlingContract, Owned{
80 
81   struct ContributorData{
82     uint priorityPassAllowance;
83     bool isActive;
84     uint contributionAmount;
85     uint tokensIssued;
86   }
87 
88   mapping(address => ContributorData) public contributorList;
89   uint public nextContributorIndex;
90   mapping(uint => address) public contributorIndexes;
91 
92   state public crowdsaleState = state.pendingStart;
93   enum state { pendingStart, priorityPass, openedPriorityPass, crowdsale, crowdsaleEnded }
94 
95   uint public presaleStartTime;
96   uint public presaleUnlimitedStartTime;
97   uint public crowdsaleStartTime;
98   uint public crowdsaleEndedTime;
99 
100   event PresaleStarted(uint blockTime);
101   event PresaleUnlimitedStarted(uint blockTime);
102   event CrowdsaleStarted(uint blockTime);
103   event CrowdsaleEnded(uint blockTime);
104   event ErrorSendingETH(address to, uint amount);
105   event MinCapReached(uint blockTime);
106   event MaxCapReached(uint blockTime);
107   event ContributionMade(address indexed contributor, uint amount);
108 
109 
110   IToken token = IToken(0x0);
111   uint ethToTokenConversion;
112 
113   uint public minCap;
114   uint public maxP1Cap;
115   uint public maxCap;
116   uint public ethRaised;
117 
118   address public multisigAddress;
119 
120   uint nextContributorToClaim;
121   mapping(address => bool) hasClaimedEthWhenFail;
122 
123   uint public maxTokenSupply;
124   bool public ownerHasClaimedTokens;
125   uint public presaleBonusTokens;
126   address public presaleBonusAddress;
127   address public presaleBonusAddressColdStorage;
128   bool public presaleBonusTokensClaimed;
129 
130   //
131   // Unnamed function that runs when eth is sent to the contract
132   // @payable
133   //
134   function() public noReentrancy payable{
135     require(msg.value != 0);                        // Throw if value is 0
136     require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
137 
138     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
139 
140     if (crowdsaleState == state.priorityPass){
141       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
142         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
143       }else{
144         refundTransaction(stateChanged);            // Set state and return funds or throw
145       }
146     }
147     else if(crowdsaleState == state.openedPriorityPass){
148       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
149         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
150       }else{
151         refundTransaction(stateChanged);            // Set state and return funds or throw
152       }
153     }
154     else if(crowdsaleState == state.crowdsale){
155       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
156     }
157     else{
158       refundTransaction(stateChanged);              // Set state and return funds or throw
159     }
160   }
161 
162   //
163   // Check crowdsale state and calibrate it
164   //
165   function checkCrowdsaleState() internal returns (bool){
166     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded){                         // Check if max cap is reached
167       crowdsaleState = state.crowdsaleEnded;
168       MaxCapReached(block.timestamp);                                                              // Close the crowdsale
169       CrowdsaleEnded(block.timestamp);                                                             // Raise event
170       return true;
171     }
172 
173     if (block.timestamp > presaleStartTime && block.timestamp <= presaleUnlimitedStartTime){  // Check if we are in presale phase
174       if (crowdsaleState != state.priorityPass){                                          // Check if state needs to be changed
175         crowdsaleState = state.priorityPass;                                              // Set new state
176         PresaleStarted(block.timestamp);                                                     // Raise event
177         return true;
178       }
179     }else if(block.timestamp > presaleUnlimitedStartTime && block.timestamp <= crowdsaleStartTime){ // Check if we are in presale unlimited phase
180       if (crowdsaleState != state.openedPriorityPass){                                          // Check if state needs to be changed
181         crowdsaleState = state.openedPriorityPass;                                              // Set new state
182         PresaleUnlimitedStarted(block.timestamp);                                                  // Raise event
183         return true;
184       }
185     }else if(block.timestamp > crowdsaleStartTime && block.timestamp <= crowdsaleEndedTime){        // Check if we are in crowdsale state
186       if (crowdsaleState != state.crowdsale){                                                   // Check if state needs to be changed
187         crowdsaleState = state.crowdsale;                                                       // Set new state
188         CrowdsaleStarted(block.timestamp);                                                         // Raise event
189         return true;
190       }
191     }else{
192       if (crowdsaleState != state.crowdsaleEnded && block.timestamp > crowdsaleEndedTime){        // Check if crowdsale is over
193         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
194         CrowdsaleEnded(block.timestamp);                                                           // Raise event
195         return true;
196       }
197     }
198     return false;
199   }
200 
201   //
202   // Decide if throw or only return ether
203   //
204   function refundTransaction(bool _stateChanged) internal{
205     if (_stateChanged){
206       msg.sender.transfer(msg.value);
207     }else{
208       revert();
209     }
210   }
211 
212   //
213   // Calculate how much user can contribute
214   //
215   function calculateMaxContribution(address _contributor) constant returns (uint maxContribution){
216     uint maxContrib;
217     if (crowdsaleState == state.priorityPass){    // Check if we are in priority pass
218       maxContrib = contributorList[_contributor].priorityPassAllowance - contributorList[_contributor].contributionAmount;
219       if (maxContrib > (maxP1Cap - ethRaised)){   // Check if max contribution is more that max cap
220         maxContrib = maxP1Cap - ethRaised;        // Alter max cap
221       }
222     }
223     else{
224       maxContrib = maxCap - ethRaised;            // Alter max cap
225     }
226     return maxContrib;
227   }
228 
229   //
230   // Issue tokens and return if there is overflow
231   //
232   function processTransaction(address _contributor, uint _amount) internal{
233     uint maxContribution = calculateMaxContribution(_contributor);              // Calculate max users contribution
234     uint contributionAmount = _amount;
235     uint returnAmount = 0;
236     if (maxContribution < _amount){                                             // Check if max contribution is lower than _amount sent
237       contributionAmount = maxContribution;                                     // Set that user contributes his maximum allowed contribution
238       returnAmount = _amount - maxContribution;                                 // Calculate how much he must get back
239     }
240 
241     if (ethRaised + contributionAmount > minCap && minCap > ethRaised) MinCapReached(block.timestamp);
242 
243     if (contributorList[_contributor].isActive == false){                       // Check if contributor has already contributed
244       contributorList[_contributor].isActive = true;                            // Set his activity to true
245       contributorList[_contributor].contributionAmount = contributionAmount;    // Set his contribution
246       contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
247       nextContributorIndex++;
248     }
249     else{
250       contributorList[_contributor].contributionAmount += contributionAmount;   // Add contribution amount to existing contributor
251     }
252     ethRaised += contributionAmount;                                            // Add to eth raised
253 
254     ContributionMade(msg.sender, contributionAmount);
255 
256     uint tokenAmount = contributionAmount * ethToTokenConversion;               // Calculate how much tokens must contributor get
257     if (tokenAmount > 0){
258       token.mintTokens(_contributor, tokenAmount);                                // Issue new tokens
259       contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
260     }
261     if (returnAmount != 0) _contributor.transfer(returnAmount);                 // Return overflow of ether
262   }
263 
264   //
265   // Push contributor data to the contract before the crowdsale so that they are eligible for priority pass
266   //
267   function editContributors(address[] _contributorAddresses, uint[] _contributorPPAllowances) public onlyOwner{
268     require(_contributorAddresses.length == _contributorPPAllowances.length); // Check if input data is correct
269 
270     for(uint cnt = 0; cnt < _contributorAddresses.length; cnt++){
271       if (contributorList[_contributorAddresses[cnt]].isActive){
272         contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];
273       }
274       else{
275         contributorList[_contributorAddresses[cnt]].isActive = true;
276         contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];
277         contributorIndexes[nextContributorIndex] = _contributorAddresses[cnt];
278         nextContributorIndex++;
279       }
280     }
281   }
282 
283   //
284   // Method is needed for recovering tokens accidentally sent to token address
285   //
286   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner{
287     IERC20Token(_tokenAddress).transfer(_to, _amount);
288   }
289 
290   //
291   // withdrawEth when minimum cap is reached
292   // @owner sets contributions to withdraw
293   //
294   function withdrawEth() onlyOwner public {
295     require(this.balance != 0);
296     require(ethRaised >= minCap);
297 
298     pendingEthWithdrawal = this.balance;
299   }
300 
301 
302   uint public pendingEthWithdrawal;
303   //
304   // pulls the funds that were set to send with calling of
305   // withdrawEth when minimum cap is reached
306   // @multisig pulls the contributions to self
307   //
308   function pullBalance() public {
309     require(msg.sender == multisigAddress);
310     require(pendingEthWithdrawal > 0);
311 
312     multisigAddress.transfer(pendingEthWithdrawal);
313     pendingEthWithdrawal = 0;
314   }
315 
316   //
317   // Users can claim their contribution if min cap is not raised
318   //
319   function claimEthIfFailed() public {
320     require(block.timestamp > crowdsaleEndedTime && ethRaised < minCap);    // Check if crowdsale has failed
321     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedTime
322     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
323 
324     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
325     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
326     if (!msg.sender.send(ethContributed)){                                // Refund eth
327       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
328     }
329   }
330 
331   //
332   // Owner can batch return contributors contributions(eth)
333   //
334   function batchReturnEthIfFailed(uint _numberOfReturns) public onlyOwner{
335     require(block.timestamp > crowdsaleEndedTime && ethRaised < minCap);                // Check if crowdsale has failed
336     address currentParticipantAddress;
337     uint contribution;
338     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
339       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
340       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
341       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
342         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
343         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
344         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
345           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
346         }
347       }
348       nextContributorToClaim += 1;                                                    // Repeat
349     }
350   }
351 
352   //
353   // If there were any issue/attach with refund owner can withdraw eth at the end for manual recovery
354   //
355   function withdrawRemainingBalanceForManualRecovery() public onlyOwner{
356     require(this.balance != 0);                                  // Check if there are any eth to claim
357     require(block.timestamp > crowdsaleEndedTime);                 // Check if crowdsale is over
358     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
359     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
360   }
361 
362   //
363   // Owner can set multisig address for crowdsale
364   //
365   function setMultisigAddress(address _newAddress) public onlyOwner{
366     multisigAddress = _newAddress;
367   }
368 
369   //
370   // Owner can set token address where mints will happen
371   //
372   function setToken(address _newAddress) public onlyOwner{
373     token = IToken(_newAddress);
374   }
375 
376   //
377   // Owner can claim teams tokens when crowdsale has successfully ended
378   //
379   function claimCoreTeamsTokens(address _to) public onlyOwner{
380     require(crowdsaleState == state.crowdsaleEnded);              // Check if crowdsale has ended
381     require(!ownerHasClaimedTokens);                              // Check if owner has already claimed tokens
382 
383     uint devReward = maxTokenSupply - token.totalSupply();
384     if (!presaleBonusTokensClaimed) devReward -= presaleBonusTokens; // If presaleBonusToken has been claimed its ok if not set aside presaleBonusTokens
385     token.mintTokens(_to, devReward);                             // Issue Teams tokens
386     ownerHasClaimedTokens = true;                                 // Block further mints from this method
387   }
388 
389   //
390   // Presale bonus tokens
391   //
392   function claimPresaleTokens() public {
393     require(msg.sender == presaleBonusAddress);         // Check if sender is address to claim tokens
394     require(crowdsaleState == state.crowdsaleEnded);    // Check if crowdsale has ended
395     require(!presaleBonusTokensClaimed);                // Check if tokens were already claimed
396 
397     token.mintTokens(presaleBonusAddressColdStorage, presaleBonusTokens);             // Issue presale  tokens
398     presaleBonusTokensClaimed = true;                   // Block further mints from this method
399   }
400 
401   function getTokenAddress() public constant returns(address){
402     return address(token);
403   }
404 
405 }
406 
407 
408 contract FutouristCrowdsale is Crowdsale {
409   function FutouristCrowdsale() public {
410     /* ADAPT */
411     presaleStartTime = 1519142400; //20/2/2017/1700
412     presaleUnlimitedStartTime = 1519315200; //22/2/2017/1700
413     crowdsaleStartTime = 1519747200; //27/2/2017/1700
414     crowdsaleEndedTime = 1521561600; //20/3/2017/1700
415 
416     minCap = 1 ether;
417     maxCap = 4979 ether;
418     maxP1Cap = 4979 ether;
419 
420     ethToTokenConversion = 47000;
421 
422     maxTokenSupply = 1000000000 * 10**18;
423     presaleBonusTokens = 115996000  * 10**18;
424     presaleBonusAddress = 0xd7C4af0e30EC62a01036e45b6ed37BC6D0a3bd53;
425     presaleBonusAddressColdStorage = 0x47D634Ce50170a156ec4300d35BE3b48E17CAaf6;
426     /* /ADAPT */
427   }
428 }