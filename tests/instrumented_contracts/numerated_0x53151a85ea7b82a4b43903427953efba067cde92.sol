1 contract SafeMath {
2     
3     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4 
5     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
6         require(x <= MAX_UINT256 - y);
7         return x + y;
8     }
9 
10     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         require(x >= y);
12         return x - y;
13     }
14 
15     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
16         if (y == 0) {
17             return 0;
18         }
19         require(x <= (MAX_UINT256 / y));
20         return x * y;
21     }
22 }
23 contract Owned {
24     address public owner;
25     address public newOwner;
26 
27     function Owned() {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner {
32         assert(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address _newOwner) public onlyOwner {
37         require(_newOwner != owner);
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         OwnerUpdate(owner, newOwner);
44         owner = newOwner;
45         newOwner = 0x0;
46     }
47 
48     event OwnerUpdate(address _prevOwner, address _newOwner);
49 }
50 contract Lockable is Owned {
51 
52     uint256 public lockedUntilBlock;
53 
54     event ContractLocked(uint256 _untilBlock, string _reason);
55 
56     modifier lockAffected {
57         require(block.number > lockedUntilBlock);
58         _;
59     }
60 
61     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
62         lockedUntilBlock = _untilBlock;
63         ContractLocked(_untilBlock, _reason);
64     }
65 
66 
67     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
68         lockedUntilBlock = _untilBlock;
69         ContractLocked(_untilBlock, _reason);
70     }
71 }
72 contract ReentrancyHandlingContract{
73 
74     bool locked;
75 
76     modifier noReentrancy() {
77         require(!locked);
78         locked = true;
79         _;
80         locked = false;
81     }
82 }
83 contract tokenRecipientInterface {
84   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
85 }
86 contract ERC20TokenInterface {
87   function totalSupply() public constant returns (uint256 _totalSupply);
88   function balanceOf(address _owner) public constant returns (uint256 balance);
89   function transfer(address _to, uint256 _value) public returns (bool success);
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91   function approve(address _spender, uint256 _value) public returns (bool success);
92   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
93 
94   event Transfer(address indexed _from, address indexed _to, uint256 _value);
95   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }
97 contract SportifyTokenInterface {
98     function mint(address _to, uint256 _amount) public;
99 }
100 
101 contract Crowdsale is ReentrancyHandlingContract, Owned {
102 
103   struct ContributorData {
104     uint contributionAmount;
105     uint tokensIssued;
106   }
107 
108   mapping(address => ContributorData) public contributorList;
109   uint nextContributorIndex;
110   mapping(uint => address) contributorIndexes;
111 
112   state public crowdsaleState = state.pendingStart;
113   enum state { pendingStart, crowdsale, crowdsaleEnded }
114 
115   uint public crowdsaleStartBlock;
116   uint public crowdsaleEndedBlock;
117 
118   event CrowdsaleStarted(uint blockNumber);
119   event CrowdsaleEnded(uint blockNumber);
120   event ErrorSendingETH(address to, uint amount);
121   event MinCapReached(uint blockNumber);
122   event MaxCapReached(uint blockNumber);
123 
124   address tokenAddress = 0x0;
125   uint decimals = 18;
126 
127   uint ethToTokenConversion;
128 
129   uint public minCap;
130   uint public maxCap;
131   uint public ethRaised;
132   uint public tokenTotalSupply = 200000000 * 10**decimals;
133 
134   address public multisigAddress;
135   uint blocksInADay;
136 
137   uint nextContributorToClaim;
138   mapping(address => bool) hasClaimedEthWhenFail;
139 
140   uint crowdsaleTokenCap =          134000000 * 10**decimals;
141   uint foundersAndTeamTokens =       36000000 * 10**decimals;
142   uint advisorAndAmbassadorTokens =  20000000 * 10**decimals;
143   uint futurePromoEventTokens =      10000000 * 10**decimals;
144   bool foundersAndTeamTokensClaimed = false;
145   bool advisorAndAmbassadorTokensClaimed = false;
146   bool futurePromoEventTokensClaimed = false;
147 
148   //
149   // Unnamed function that runs when eth is sent to the contract
150   //
151   function() noReentrancy payable public {
152     require(msg.value != 0);                        // Throw if value is 0
153     require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
154 
155     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
156 
157     if (crowdsaleState == state.crowdsale) {
158       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
159     } else {
160       refundTransaction(stateChanged);              // Set state and return funds or throw
161     }
162   }
163 
164   //
165   // Check crowdsale state and calibrate it
166   //
167   function checkCrowdsaleState() internal returns (bool) {
168     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded) {                        // Check if max cap is reached
169       crowdsaleState = state.crowdsaleEnded;
170       CrowdsaleEnded(block.number);                                                             // Raise event
171       return true;
172     }
173 
174     if (block.number > crowdsaleStartBlock && block.number <= crowdsaleEndedBlock) {            // Check if we are in crowdsale state
175       if (crowdsaleState != state.crowdsale) {                                                  // Check if state needs to be changed
176         crowdsaleState = state.crowdsale;                                                       // Set new state
177         CrowdsaleStarted(block.number);                                                         // Raise event
178         return true;
179       }
180     } else {
181       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock) {       // Check if crowdsale is over
182         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
183         CrowdsaleEnded(block.number);                                                           // Raise event
184         return true;
185       }
186     }
187     return false;
188   }
189 
190   //
191   // Decide if throw or only return ether
192   //
193   function refundTransaction(bool _stateChanged) internal {
194     if (_stateChanged) {
195       msg.sender.transfer(msg.value);
196     } else {
197       revert();
198     }
199   }
200 
201   function calculateEthToToken(uint _eth, uint _blockNumber) constant public returns(uint) {
202     if (_blockNumber < crowdsaleStartBlock + blocksInADay * 3) {
203       return _eth * 3298;
204     }
205     if (_eth >= 100*10**decimals) {
206       return _eth * 3298;
207     }
208     if (_blockNumber > crowdsaleStartBlock) {
209       return _eth * 2998;
210     }
211   }
212 
213   //
214   // Issue tokens and return if there is overflow
215   //
216   function processTransaction(address _contributor, uint _amount) internal{
217     uint contributionAmount = _amount;
218     uint returnAmount = 0;
219 
220     if (_amount > (maxCap - ethRaised)) {                                          // Check if max contribution is lower than _amount sent
221       contributionAmount = maxCap - ethRaised;                                     // Set that user contibutes his maximum alowed contribution
222       returnAmount = _amount - contributionAmount;                                 // Calculate howmuch he must get back
223     }
224 
225     if (ethRaised + contributionAmount > minCap && minCap > ethRaised) {
226       MinCapReached(block.number);
227     }
228 
229     if (ethRaised + contributionAmount == maxCap && ethRaised < maxCap) {
230       MaxCapReached(block.number);
231     }
232 
233     if (contributorList[_contributor].contributionAmount == 0) {
234         contributorIndexes[nextContributorIndex] = _contributor;
235         nextContributorIndex += 1;
236     }
237 
238     contributorList[_contributor].contributionAmount += contributionAmount;
239     ethRaised += contributionAmount;                                              // Add to eth raised
240 
241     uint tokenAmount = calculateEthToToken(contributionAmount, block.number);     // Calculate how much tokens must contributor get
242     if (tokenAmount > 0) {
243       SportifyTokenInterface(tokenAddress).mint(_contributor, tokenAmount);       // Issue new tokens
244       contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
245     }
246     if (returnAmount != 0) {
247       _contributor.transfer(returnAmount);
248     } 
249   }
250 
251   function pushAngelInvestmentData(address _address, uint _ethContributed) onlyOwner public {
252       assert(ethRaised + _ethContributed <= maxCap);
253       processTransaction(_address, _ethContributed);
254   }
255   function depositAngelInvestmentEth() payable onlyOwner public {}
256   
257 
258   //
259   // Method is needed for recovering tokens accedentaly sent to token address
260   //
261   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
262     ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
263   }
264 
265   //
266   // withdrawEth when minimum cap is reached
267   //
268   function withdrawEth() onlyOwner public {
269     require(this.balance != 0);
270     require(ethRaised >= minCap);
271 
272     multisigAddress.transfer(this.balance);
273   }
274 
275   //
276   // Users can claim their contribution if min cap is not raised
277   //
278   function claimEthIfFailed() public {
279     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);    // Check if crowdsale has failed
280     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
281     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
282 
283     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
284     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
285     if (!msg.sender.send(ethContributed)) {                                // Refund eth
286       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
287     }
288   }
289 
290   //
291   // Owner can batch return contributors contributions(eth)
292   //
293   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
294     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);                // Check if crowdsale has failed
295     address currentParticipantAddress;
296     uint contribution;
297     for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
298       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
299       if (currentParticipantAddress == 0x0) {
300         return;                                                                       // Check if all the participants were compensated
301       }
302       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
303         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
304         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
305         if (!currentParticipantAddress.send(contribution)) {                          // Refund eth
306           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
307         }
308       }
309       nextContributorToClaim += 1;                                                    // Repeat
310     }
311   }
312 
313   //
314   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
315   //
316   function withdrawRemainingBalanceForManualRecovery() onlyOwner public {
317     require(this.balance != 0);                                  // Check if there are any eth to claim
318     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
319     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
320     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
321   }
322 
323   function claimTeamTokens(address _to, uint _choice) onlyOwner public {
324     require(crowdsaleState == state.crowdsaleEnded);
325     require(ethRaised >= minCap);
326 
327     uint mintAmount;
328     if (_choice == 1) {
329       assert(!advisorAndAmbassadorTokensClaimed);
330       mintAmount = advisorAndAmbassadorTokens;
331       advisorAndAmbassadorTokensClaimed = true;
332     } else if (_choice == 2) {
333       assert(!futurePromoEventTokensClaimed);
334       mintAmount = futurePromoEventTokens;
335       futurePromoEventTokensClaimed = true;
336     } else if (_choice == 3) {
337       assert(!foundersAndTeamTokensClaimed);
338       assert(advisorAndAmbassadorTokensClaimed);
339       assert(futurePromoEventTokensClaimed);
340       assert(tokenTotalSupply > ERC20TokenInterface(tokenAddress).totalSupply());
341       mintAmount = tokenTotalSupply - ERC20TokenInterface(tokenAddress).totalSupply();
342       foundersAndTeamTokensClaimed = true;
343     } else {
344       revert();
345     }
346     SportifyTokenInterface(tokenAddress).mint(_to, mintAmount);
347   }
348 
349 
350   //
351   // Owner can set multisig address for crowdsale
352   //
353   function setMultisigAddress(address _newAddress) onlyOwner public {
354     multisigAddress = _newAddress;
355   }
356 
357   //
358   // Owner can set token address where mints will happen
359   //
360   function setToken(address _newAddress) onlyOwner public {
361     tokenAddress = _newAddress;
362   }
363 
364   function getTokenAddress() constant public returns(address) {
365     return tokenAddress;
366   }
367 
368   function investorCount() constant public returns(uint) {
369     return nextContributorIndex;
370   }
371 }
372 
373 contract SportifyCrowdsale is Crowdsale {
374   
375   function SportifyCrowdsale() { 
376 
377     crowdsaleStartBlock = 4595138;
378     crowdsaleEndedBlock = 4708120;
379 
380     minCap = 4190000000000000000000;
381     maxCap = 40629000000000000000000;
382 
383     blocksInADay = 6646;
384   }
385 }