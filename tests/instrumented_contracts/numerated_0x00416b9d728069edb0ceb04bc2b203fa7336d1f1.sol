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
21 contract ReentrancyHandlingContract {
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
32 contract Owned {
33     address public owner;
34     address public newOwner;
35 
36     function Owned() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         assert(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         require(_newOwner != owner);
47         newOwner = _newOwner;
48     }
49 
50     function acceptOwnership() public {
51         require(msg.sender == newOwner);
52         OwnerUpdate(owner, newOwner);
53         owner = newOwner;
54         newOwner = 0x0;
55     }
56 
57     event OwnerUpdate(address _prevOwner, address _newOwner);
58 }
59 contract PriorityPassInterface {
60     function getAccountLimit(address _accountAddress) public constant returns (uint);
61     function getAccountActivity(address _accountAddress) public constant returns (bool);
62 }
63 contract ERC20TokenInterface {
64   function totalSupply() public constant returns (uint256 _totalSupply);
65   function balanceOf(address _owner) public constant returns (uint256 balance);
66   function transfer(address _to, uint256 _value) public returns (bool success);
67   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
68   function approve(address _spender, uint256 _value) public returns (bool success);
69   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
70 
71   event Transfer(address indexed _from, address indexed _to, uint256 _value);
72   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 contract SeedCrowdsaleContract is ReentrancyHandlingContract, Owned {
76 
77   struct ContributorData {
78     uint contributionAmount;
79   }
80 
81   mapping(address => ContributorData) public contributorList;
82   uint public nextContributorIndex;
83   mapping(uint => address) public contributorIndexes;
84 
85   state public crowdsaleState = state.pendingStart;
86   enum state { pendingStart, priorityPass, openedPriorityPass, crowdsaleEnded }
87 
88   uint public presaleStartTime;
89   uint public presaleUnlimitedStartTime;
90   uint public crowdsaleEndedTime;
91 
92   event PresaleStarted(uint blocktime);
93   event PresaleUnlimitedStarted(uint blocktime);
94   event CrowdsaleEnded(uint blocktime);
95   event ErrorSendingETH(address to, uint amount);
96   event MinCapReached(uint blocktime);
97   event MaxCapReached(uint blocktime);
98   event ContributionMade(address indexed contributor, uint amount);
99 
100   PriorityPassInterface priorityPassContract = PriorityPassInterface(0x0);
101 
102   uint public minCap;
103   uint public maxP1Cap;
104   uint public maxCap;
105   uint public ethRaised;
106 
107   address public multisigAddress;
108 
109   uint nextContributorToClaim;
110   mapping(address => bool) hasClaimedEthWhenFail;
111 
112   //
113   // Unnamed function that runs when eth is sent to the contract
114   // @payable
115   //
116   function() noReentrancy payable public {
117     require(msg.value != 0);                                                    // Throw if value is 0
118     require(crowdsaleState != state.crowdsaleEnded);                            // Check if crowdsale has ended
119 
120     bool stateChanged = checkCrowdsaleState();                                  // Check blocks time and calibrate crowdsale state
121 
122     if (crowdsaleState == state.priorityPass) {
123       if (priorityPassContract.getAccountActivity(msg.sender)) {                // Check if contributor is in priorityPass
124         processTransaction(msg.sender, msg.value);                              // Process transaction and issue tokens
125       } else {
126         refundTransaction(stateChanged);                                        // Set state and return funds or throw
127       }
128     } else if (crowdsaleState == state.openedPriorityPass) {
129       if (priorityPassContract.getAccountActivity(msg.sender)) {                // Check if contributor is in priorityPass
130         processTransaction(msg.sender, msg.value);                              // Process transaction and issue tokens
131       } else {
132         refundTransaction(stateChanged);                                        // Set state and return funds or throw
133       }
134     } else {
135       refundTransaction(stateChanged);                                          // Set state and return funds or throw
136     }
137   }
138 
139   //
140   // @internal checks crowdsale state and emits events it
141   // @returns boolean
142   //
143   function checkCrowdsaleState() internal returns (bool) {
144     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded) {        // Check if max cap is reached
145       crowdsaleState = state.crowdsaleEnded;
146       MaxCapReached(block.timestamp);                                           // Close the crowdsale
147       CrowdsaleEnded(block.timestamp);                                          // Raise event
148       return true;
149     }
150 
151     if (block.timestamp > presaleStartTime && block.timestamp <= presaleUnlimitedStartTime) { // Check if we are in presale phase
152       if (crowdsaleState != state.priorityPass) {                               // Check if state needs to be changed
153         crowdsaleState = state.priorityPass;                                    // Set new state
154         PresaleStarted(block.timestamp);                                        // Raise event
155         return true;
156       }
157     } else if (block.timestamp > presaleUnlimitedStartTime && block.timestamp <= crowdsaleEndedTime) {  // Check if we are in presale unlimited phase
158       if (crowdsaleState != state.openedPriorityPass) {                         // Check if state needs to be changed
159         crowdsaleState = state.openedPriorityPass;                              // Set new state
160         PresaleUnlimitedStarted(block.timestamp);                               // Raise event
161         return true;
162       }
163     } else {
164       if (crowdsaleState != state.crowdsaleEnded && block.timestamp > crowdsaleEndedTime) {// Check if crowdsale is over
165         crowdsaleState = state.crowdsaleEnded;                                  // Set new state
166         CrowdsaleEnded(block.timestamp);                                        // Raise event
167         return true;
168       }
169     }
170     return false;
171   }
172 
173   //
174   // @internal determines if return eth or throw according to changing state
175   // @param _stateChanged boolean message about state change
176   //
177   function refundTransaction(bool _stateChanged) internal {
178     if (_stateChanged) {
179       msg.sender.transfer(msg.value);
180     } else {
181       revert();
182     }
183   }
184 
185   //
186   // Getter to calculate how much user can contribute
187   // @param _contributor address of the contributor
188   //
189   function calculateMaxContribution(address _contributor) constant public returns (uint maxContribution) {
190     uint maxContrib;
191 
192     if (crowdsaleState == state.priorityPass) {                                 // Check if we are in priority pass
193       maxContrib = priorityPassContract.getAccountLimit(_contributor) - contributorList[_contributor].contributionAmount;
194 
195 	    if (maxContrib > (maxP1Cap - ethRaised)) {                                // Check if max contribution is more that max cap
196         maxContrib = maxP1Cap - ethRaised;                                      // Alter max cap
197       }
198 
199     } else {
200       maxContrib = maxCap - ethRaised;                                          // Alter max cap
201     }
202     return maxContrib;
203   }
204 
205   //
206   // Return if there is overflow of contributed eth
207   // @internal processes transactions
208   // @param _contributor address of an contributor
209   // @param _amount contributed amount
210   //
211   function processTransaction(address _contributor, uint _amount) internal {
212     uint maxContribution = calculateMaxContribution(_contributor);              // Calculate max users contribution
213     uint contributionAmount = _amount;
214     uint returnAmount = 0;
215 
216 	  if (maxContribution < _amount) {                                            // Check if max contribution is lower than _amount sent
217       contributionAmount = maxContribution;                                     // Set that user contributes his maximum alowed contribution
218       returnAmount = _amount - maxContribution;                                 // Calculate how much he must get back
219     }
220 
221     if (ethRaised + contributionAmount >= minCap && minCap > ethRaised) {
222       MinCapReached(block.timestamp);
223     } 
224 
225     if (contributorList[_contributor].contributionAmount == 0) {                // Check if contributor has already contributed
226       contributorList[_contributor].contributionAmount = contributionAmount;    // Set their contribution
227       contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
228       nextContributorIndex++;
229     } else {
230       contributorList[_contributor].contributionAmount += contributionAmount;   // Add contribution amount to existing contributor
231     }
232     ethRaised += contributionAmount;                                            // Add to eth raised
233 
234     ContributionMade(msg.sender, contributionAmount);                           // Raise event about contribution
235 
236 	  if (returnAmount != 0) {
237       _contributor.transfer(returnAmount);                                      // Return overflow of ether
238     } 
239   }
240 
241   //
242   // Recovers ERC20 tokens other than eth that are send to this address
243   // @owner refunds the erc20 tokens
244   // @param _tokenAddress address of the erc20 token
245   // @param _to address to where tokens should be send to
246   // @param _amount amount of tokens to refund
247   //
248   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
249     ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
250   }
251 
252   //
253   // withdrawEth when minimum cap is reached
254   // @owner sets contributions to withdraw
255   //
256   function withdrawEth() onlyOwner public {
257     require(this.balance != 0);
258     require(ethRaised >= minCap);
259 
260     pendingEthWithdrawal = this.balance;
261   }
262 
263 
264   uint public pendingEthWithdrawal;
265   //
266   // pulls the funds that were set to send with calling of
267   // withdrawEth when minimum cap is reached
268   // @multisig pulls the contributions to self
269   //
270   function pullBalance() public {
271     require(msg.sender == multisigAddress);
272     require(pendingEthWithdrawal > 0);
273 
274     multisigAddress.transfer(pendingEthWithdrawal);
275     pendingEthWithdrawal = 0;
276   }
277 
278   //
279   // Owner can batch return contributors contributions(eth)
280   // @owner returns contributions
281   // @param _numberOfReturns number of returns to do in one transaction
282   //
283   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
284     require(block.timestamp > crowdsaleEndedTime && ethRaised < minCap);        // Check if crowdsale has failed
285 
286     address currentParticipantAddress;
287     uint contribution;
288 
289     for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
290       currentParticipantAddress = contributorIndexes[nextContributorToClaim];   // Get next unclaimed participant
291 
292       if (currentParticipantAddress == 0x0) {
293          return;                                                                // Check if all the participants were compensated
294       }
295 
296       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                  // Check if participant has already claimed
297         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
298         hasClaimedEthWhenFail[currentParticipantAddress] = true;                // Set that he has claimed
299 
300         if (!currentParticipantAddress.send(contribution)) {                    // Refund eth
301           ErrorSendingETH(currentParticipantAddress, contribution);             // If there is an issue raise event for manual recovery
302         }
303       }
304       nextContributorToClaim += 1;                                              // Repeat
305     }
306   }
307 
308   //
309   // If there were any issue with refund owner can withdraw eth at the end for manual recovery
310   // @owner withdraws remaining funds
311   //
312   function withdrawRemainingBalanceForManualRecovery() onlyOwner public {
313     require(this.balance != 0);                                                 // Check if there are any eth to claim
314     require(block.timestamp > crowdsaleEndedTime);                              // Check if crowdsale is over
315     require(contributorIndexes[nextContributorToClaim] == 0x0);                 // Check if all the users were refunded
316     multisigAddress.transfer(this.balance);                                     // Withdraw to multisig for manual processing
317   }
318 
319   //
320   // Owner can set multisig address for crowdsale
321   // @owner sets an address where funds will go
322   // @param _newAddress
323   //
324   function setMultisigAddress(address _newAddress) onlyOwner public {
325     multisigAddress = _newAddress;
326   }
327 
328   //
329   // Setter for the whitelist contract
330   // @owner sets address of whitelist contract
331   // @param address
332   //
333   function setPriorityPassContract(address _newAddress) onlyOwner public {
334     priorityPassContract = PriorityPassInterface(_newAddress);
335   }
336 
337   //
338   // Getter for the whitelist contract
339   // @returns white list contract address
340   //
341   function priorityPassContractAddress() constant public returns (address) {
342     return address(priorityPassContract);
343   }
344 
345   //
346   // Before crowdsale starts owner can calibrate time of crowdsale stages
347   // @owner sends new times for the sale
348   // @param _presaleStartTime timestamp for sale limited start
349   // @param _presaleUnlimitedStartTime timestamp for sale unlimited
350   // @param _crowdsaleEndedTime timestamp for ending sale
351   //
352   function setCrowdsaleTimes(uint _presaleStartTime, uint _presaleUnlimitedStartTime, uint _crowdsaleEndedTime) onlyOwner public {
353     require(crowdsaleState == state.pendingStart);                              // Check if crowdsale has started
354     require(_presaleStartTime != 0);                                            // Check if any value is 0
355     require(_presaleStartTime < _presaleUnlimitedStartTime);                    // Check if presaleUnlimitedStartTime is set properly
356     require(_presaleUnlimitedStartTime != 0);                                   // Check if any value is 0
357     require(_presaleUnlimitedStartTime < _crowdsaleEndedTime);                  // Check if crowdsaleEndedTime is set properly
358     require(_crowdsaleEndedTime != 0);                                          // Check if any value is 0
359     presaleStartTime = _presaleStartTime;
360     presaleUnlimitedStartTime = _presaleUnlimitedStartTime;
361     crowdsaleEndedTime = _crowdsaleEndedTime;
362   }
363 
364 }
365 
366 contract AversafeSeedCrowdsale is SeedCrowdsaleContract {
367   
368   function AversafeSeedCrowdsale() {
369 
370     presaleStartTime = 1512032400;
371     presaleUnlimitedStartTime = 1512063000;
372     crowdsaleEndedTime = 1512140400;
373 
374     minCap = 451 ether;
375     maxP1Cap = 802 ether;
376     maxCap = 891 ether;
377   }
378 }