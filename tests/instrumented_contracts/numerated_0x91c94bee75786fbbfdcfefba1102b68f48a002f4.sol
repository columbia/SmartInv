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
27 contract Owned {
28     address public owner;
29     address public newOwner;
30 
31     function Owned() {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         assert(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address _newOwner) public onlyOwner {
41         require(_newOwner != owner);
42         newOwner = _newOwner;
43     }
44 
45     function acceptOwnership() public {
46         require(msg.sender == newOwner);
47         OwnerUpdate(owner, newOwner);
48         owner = newOwner;
49         newOwner = 0x0;
50     }
51 
52     event OwnerUpdate(address _prevOwner, address _newOwner);
53 }
54 
55 contract Lockable is Owned{
56 
57   uint256 public lockedUntilBlock;
58 
59   event ContractLocked(uint256 _untilBlock, string _reason);
60 
61   modifier lockAffected {
62       require(block.number > lockedUntilBlock);
63       _;
64   }
65 
66   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
67     lockedUntilBlock = _untilBlock;
68     ContractLocked(_untilBlock, _reason);
69   }
70 
71 
72   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
73     lockedUntilBlock = _untilBlock;
74     ContractLocked(_untilBlock, _reason);
75   }
76 }
77 
78 contract ReentrancyHandlingContract{
79 
80     bool locked;
81 
82     modifier noReentrancy() {
83         require(!locked);
84         locked = true;
85         _;
86         locked = false;
87     }
88 }
89 contract IMintableToken {
90   function mintTokens(address _to, uint256 _amount){}
91 }
92 contract IERC20Token {
93   function totalSupply() constant returns (uint256 totalSupply);
94   function balanceOf(address _owner) constant returns (uint256 balance) {}
95   function transfer(address _to, uint256 _value) returns (bool success) {}
96   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
97   function approve(address _spender, uint256 _value) returns (bool success) {}
98   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
99 
100   event Transfer(address indexed _from, address indexed _to, uint256 _value);
101   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102 }
103 contract ItokenRecipient {
104   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
105 }
106 contract IToken {
107   function totalSupply() constant returns (uint256 totalSupply);
108   function mintTokens(address _to, uint256 _amount) {}
109 }
110 
111 
112 
113 
114 
115 
116 contract Crowdsale is ReentrancyHandlingContract, Owned{
117 
118   struct ContributorData{
119     uint contributionAmount;
120     uint tokensIssued;
121   }
122 
123   mapping(address => ContributorData) public contributorList;
124   uint nextContributorIndex;
125   mapping(uint => address) contributorIndexes;
126 
127   state public crowdsaleState = state.pendingStart;
128   enum state { pendingStart, crowdsale, crowdsaleEnded }
129 
130   uint public crowdsaleStartBlock;
131   uint public crowdsaleEndedBlock;
132 
133   event CrowdsaleStarted(uint blockNumber);
134   event CrowdsaleEnded(uint blockNumber);
135   event ErrorSendingETH(address to, uint amount);
136   event MinCapReached(uint blockNumber);
137   event MaxCapReached(uint blockNumber);
138 
139   address tokenAddress = 0x0;
140   uint decimals = 18;
141 
142   uint ethToTokenConversion;
143 
144   uint public minCap;
145   uint public maxCap;
146   uint public ethRaised;
147   uint public tokenTotalSupply = 200000000 * 10**decimals;
148 
149   address public multisigAddress;
150   uint blocksInADay;
151 
152   uint nextContributorToClaim;
153   mapping(address => bool) hasClaimedEthWhenFail;
154 
155   uint crowdsaleTokenCap =          120000000 * 10**decimals;
156   uint foundersAndTeamTokens =       32000000 * 10**decimals;
157   uint advisorAndAmbassadorTokens =  16000000 * 10**decimals;
158   uint investorTokens =               8000000 * 10**decimals;
159   uint viberateContributorTokens =   10000000 * 10**decimals;
160   uint futurePartnerTokens =         14000000 * 10**decimals;
161   bool foundersAndTeamTokensClaimed = false;
162   bool advisorAndAmbassadorTokensClaimed = false;
163   bool investorTokensClaimed = false;
164   bool viberateContributorTokensClaimed = false;
165   bool futurePartnerTokensClaimed = false;
166 
167   //
168   // Unnamed function that runs when eth is sent to the contract
169   //
170   function() noReentrancy payable{
171     require(msg.value != 0);                        // Throw if value is 0
172     require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
173 
174     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
175 
176     if(crowdsaleState == state.crowdsale){
177       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
178     }
179     else{
180       refundTransaction(stateChanged);              // Set state and return funds or throw
181     }
182   }
183 
184   //
185   // Check crowdsale state and calibrate it
186   //
187   function checkCrowdsaleState() internal returns (bool){
188     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded){                         // Check if max cap is reached
189       crowdsaleState = state.crowdsaleEnded;
190       CrowdsaleEnded(block.number);                                                             // Raise event
191       return true;
192     }
193 
194     if(block.number > crowdsaleStartBlock && block.number <= crowdsaleEndedBlock){        // Check if we are in crowdsale state
195       if (crowdsaleState != state.crowdsale){                                                   // Check if state needs to be changed
196         crowdsaleState = state.crowdsale;                                                       // Set new state
197         CrowdsaleStarted(block.number);                                                         // Raise event
198         return true;
199       }
200     }else{
201       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock){        // Check if crowdsale is over
202         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
203         CrowdsaleEnded(block.number);                                                           // Raise event
204         return true;
205       }
206     }
207     return false;
208   }
209 
210   //
211   // Decide if throw or only return ether
212   //
213   function refundTransaction(bool _stateChanged) internal{
214     if (_stateChanged){
215       msg.sender.transfer(msg.value);
216     }else{
217       revert();
218     }
219   }
220 
221   //
222   //
223   //
224   function calculateEthToVibe(uint _eth, uint _blockNumber) constant returns(uint) {
225     if (_blockNumber < crowdsaleStartBlock) return _eth * 3158;
226     if (_blockNumber >= crowdsaleStartBlock && _blockNumber < crowdsaleStartBlock + blocksInADay * 2) return _eth * 3158;
227     if (_blockNumber >= crowdsaleStartBlock + blocksInADay * 2 && _blockNumber < crowdsaleStartBlock + blocksInADay * 7) return _eth * 3074;
228     if (_blockNumber >= crowdsaleStartBlock + blocksInADay * 7 && _blockNumber < crowdsaleStartBlock + blocksInADay * 14) return _eth * 2989;
229     if (_blockNumber >= crowdsaleStartBlock + blocksInADay * 14 && _blockNumber < crowdsaleStartBlock + blocksInADay * 21) return _eth * 2905;
230     if (_blockNumber >= crowdsaleStartBlock + blocksInADay * 21 ) return _eth * 2820;
231   }
232 
233   //
234   // Issue tokens and return if there is overflow
235   //
236   function processTransaction(address _contributor, uint _amount) internal{
237     uint contributionAmount = _amount;
238     uint returnAmount = 0;
239 
240     if (_amount > (maxCap - ethRaised)){                                           // Check if max contribution is lower than _amount sent
241       contributionAmount = maxCap - ethRaised;                                     // Set that user contibutes his maximum alowed contribution
242       returnAmount = _amount - contributionAmount;                                 // Calculate howmuch he must get back
243     }
244 
245     if (ethRaised + contributionAmount > minCap && minCap > ethRaised){
246       MinCapReached(block.number);
247     }
248 
249     if (ethRaised + contributionAmount == maxCap && ethRaised < maxCap){
250       MaxCapReached(block.number);
251     }
252 
253     if (contributorList[_contributor].contributionAmount == 0){
254         contributorIndexes[nextContributorIndex] = _contributor;
255         nextContributorIndex += 1;
256     }
257 
258     contributorList[_contributor].contributionAmount += contributionAmount;
259     contributorList[_contributor].tokensIssued += contributionAmount;
260     ethRaised += contributionAmount;                                              // Add to eth raised
261 
262     uint tokenAmount = calculateEthToVibe(contributionAmount, block.number);      // Calculate how much tokens must contributor get
263     if (tokenAmount > 0){
264       IToken(tokenAddress).mintTokens(_contributor, tokenAmount);                 // Issue new tokens
265       contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
266     }
267     if (returnAmount != 0) _contributor.transfer(returnAmount);
268   }
269 
270   function pushAngelInvestmentData(address _address, uint _ethContributed) onlyOwner{
271       assert(ethRaised + _ethContributed <= maxCap);
272       processTransaction(_address, _ethContributed);
273   }
274   function depositAngelInvestmentEth() payable onlyOwner {}
275   
276 
277   //
278   // Method is needed for recovering tokens accedentaly sent to token address
279   //
280   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
281     IERC20Token(_tokenAddress).transfer(_to, _amount);
282   }
283 
284   //
285   // withdrawEth when minimum cap is reached
286   //
287   function withdrawEth() onlyOwner{
288     require(this.balance != 0);
289     require(ethRaised >= minCap);
290 
291     multisigAddress.transfer(this.balance);
292   }
293 
294   //
295   // Users can claim their contribution if min cap is not raised
296   //
297   function claimEthIfFailed(){
298     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);    // Check if crowdsale has failed
299     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
300     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
301 
302     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
303     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
304     if (!msg.sender.send(ethContributed)){                                // Refund eth
305       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
306     }
307   }
308 
309   //
310   // Owner can batch return contributors contributions(eth)
311   //
312   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner{
313     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);                // Check if crowdsale has failed
314     address currentParticipantAddress;
315     uint contribution;
316     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
317       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
318       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
319       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
320         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
321         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
322         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
323           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
324         }
325       }
326       nextContributorToClaim += 1;                                                    // Repeat
327     }
328   }
329 
330   //
331   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
332   //
333   function withdrawRemainingBalanceForManualRecovery() onlyOwner{
334     require(this.balance != 0);                                  // Check if there are any eth to claim
335     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
336     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
337     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
338   }
339 
340   function claimTeamTokens(address _to, uint _choice) onlyOwner{
341     require(crowdsaleState == state.crowdsaleEnded);
342     require(ethRaised >= minCap);
343 
344     uint mintAmount;
345     if(_choice == 1){
346       assert(!advisorAndAmbassadorTokensClaimed);
347       mintAmount = advisorAndAmbassadorTokens;
348       advisorAndAmbassadorTokensClaimed = true;
349     }else if(_choice == 2){
350       assert(!investorTokensClaimed);
351       mintAmount = investorTokens;
352       investorTokensClaimed = true;
353     }else if(_choice == 3){
354       assert(!viberateContributorTokensClaimed);
355       mintAmount = viberateContributorTokens;
356       viberateContributorTokensClaimed = true;
357     }else if(_choice == 4){
358       assert(!futurePartnerTokensClaimed);
359       mintAmount = futurePartnerTokens;
360       futurePartnerTokensClaimed = true;
361     }else if(_choice == 5){
362       assert(!foundersAndTeamTokensClaimed);
363       assert(advisorAndAmbassadorTokensClaimed);
364       assert(investorTokensClaimed);
365       assert(viberateContributorTokensClaimed);
366       assert(futurePartnerTokensClaimed);
367       assert(tokenTotalSupply > IERC20Token(tokenAddress).totalSupply());
368       mintAmount = tokenTotalSupply - IERC20Token(tokenAddress).totalSupply();
369       foundersAndTeamTokensClaimed = true;
370     }
371     else{
372       revert();
373     }
374     IToken(tokenAddress).mintTokens(_to, mintAmount);
375   }
376 
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
389     tokenAddress = _newAddress;
390   }
391 
392   function getTokenAddress() constant returns(address){
393     return tokenAddress;
394   }
395 
396   function investorCount() constant returns(uint){
397     return nextContributorIndex;
398   }
399 }
400 
401 
402 
403 
404 
405 
406 
407 
408 
409 contract ViberateCrowdsale is Crowdsale {
410   function ViberateCrowdsale(){
411 
412     crowdsaleStartBlock = 4240935;
413     crowdsaleEndedBlock = 4348935;
414 
415     minCap = 3546099290780000000000;
416     maxCap = 37993920972640000000000;
417 
418     blocksInADay = 3600;
419 
420   }
421 }